/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S 

 FileName:	ENGINE.PRO
 Purpose:	Report Generator
 Written by:	Alexander Grachev
 Version:	1.3
 Build:		019.990201
 Tested with:	Visual Prolog v.5.1 build 563
 Comments:
******************************************************************************/
predicates
procedure	set_base_point(BOOLEAN,BLOCK_RECT,REAL)
procedure	insert_pb_sign
procedure	re_gettxtobject(REP_TEXTOBJECT,INTEGER,STRING,REP_BORDER_TYPE)

clauses
  set_base_point(1,RECT,_):-
  	rect_measured(RECT,L,_,_,_),
  	get_X(X_POS),
  	X = 2 * X_POS - L,
	set_X(X),
  	!.
  set_base_point(_,_,X_PREV):-
  	set_X(X_PREV).

  re_gettxtobject(reptxt(STR),BORDER,STR,re_border(BORDER)):- !.
  re_gettxtobject(repround(STR,Xr,Yr),_,STR,re_roundrect(Xr,Yr)):- !.
  re_gettxtobject(repellipse(STR),_,STR,re_ellipse):- !.
  re_gettxtobject(repbrockenrect(STR,L,T,R,B,DX,DY),_,STR,re_brockenrect(L,T,R,B,DX,DY)):- !.
  re_gettxtobject(_,_,"",re_border(0)):- errorexit().
  	

  end_of_pane.

ifdef report_reserve_space
predicates
procedure	re_conditional_concat(STRING,STRING)

clauses
  re_conditional_concat("\p","\p"):- !.
  re_conditional_concat(STR,Str_reserved):-
	concat(STR," ",Str_reserved),
	!.

enddef

predicates
procedure	retrieve_pattern(STRING,INTEGER)
procedure	alignment_trans(ALIGNMENT_VAL,ILIST)
procedure	textout1(INTEGER,INTEGER,INTEGER,RCT,STRING,STRING,ILIST)
procedure	insert_Bord(RCT,REP_BORDER_TYPE,LONG,INTEGER)
procedure	insert_dbBord(RCT,REP_BORDER_TYPE,LONG,INTEGER,STRING)
procedure	insert_Indentation(INTEGER,INTEGER,RCT,RCT)
procedure	re_set_writeproperty(STRING)
procedure	re_check_existing_props(STRING,FONT,LONG,LONG,REP_BORDER_TYPE,INTEGER,INTEGER,FONTSTYLE,INTEGER)
clauses
  textparam(reptxt("\b"),_,_,pnt(0,0)):-!.

  textparam(OBJECT,RCT_SET,CLIP,pnt(R_TAIL,BOT)):-
	active_prop(3,FONT,FF,FSTYLE,FSIZE,_,_,_,_,BORDER,ALIGNMENT,FORE,BACK,LEFTM,TOPM,_,COMPL),
	re_gettxtobject(OBJECT,BORDER,STR,BORDER_TYPE),
	m_calcultext(STR,RCT_SET,CLIP,_,RCT),
	alignment_trans(ALIGNMENT,ALIGNMENT_FL),
	RCT=rct(_,_,R_TAIL,BOT),
	R_Tailfloat = val(REAL,R_TAIL),
	y_memory(BOT), x_memory(R_TailFloat),
	active_block(LEVEL),
	store_block_width(LEVEL,R_TAIL,main),
ifdef report_reserve_space
	re_conditional_concat(STR,Str_reserved),
elsedef
	Str_reserved = STR,
enddef
	re_store_recured_obj(param(RCT,BORDER_TYPE,Str_reserved,ALIGNMENT_FL,
FORE,BACK,LEFTM,TOPM,FF,FSTYLE,FSIZE),FONT,COMPL),
	assert(block(LEVEL,param(RCT,BORDER_TYPE,Str_reserved,ALIGNMENT_FL,
FORE,BACK,LEFTM,TOPM,FF,FSTYLE,FSIZE),FONT)),
	!.
  textparam(_,_,_,pnt(0,0)).
  	
  retrieve_pattern("\p",pat_Hollow):-!.
  retrieve_pattern("\\l",pat_Cross):-!.
  retrieve_pattern(_,pat_Solid):-!.
  
    alignment_trans(center,[dtext_center]):-!.
    alignment_trans(left,[dtext_left]):-!.
    alignment_trans(right,[dtext_right]):-!.
    alignment_trans(_,[]):-errorexit().

  textout1(pat_Solid,LIND,TIND,NEWRCT,St,Chain,Alignment):-
	insert_Indentation(LIND,TIND,NEWRCT,RCT_IND),
	chain_insertz(engine,Chain,KEEP_DBA_DOM,out_text(RCT_IND,ST,ALIGNMENT),_),
	!.
  textout1(_,_,_,_,_,_,_).
	
    textout(_,_):-
    	draw_forbidden,!.
    textout(param(RCT,BORDER,ST,ALIGNMENT,FORE,BACK,LIND,TIND,FF,FSTYLE,FSIZE),FONT):-
	RCT = rct(Left,Top,Right,Bottom),
  	find_Out_HorRes(Avail),
	Left >= Avail,
	Page = Left div Avail,
	format(Chain,"page%d",Page),
	NewLeft = Left - Page * Avail,
	NewRight = Right - Page * Avail,
	NEWRCT = rct(NewLeft,Top,NewRight,Bottom),
	retrieve_pattern(ST,PAT),
	re_check_existing_props(Chain,FONT,FORE,BACK,BORDER,PAT,FF,FSTYLE,FSIZE),
	insert_dbBord(NEWRCT,BORDER,BACK,PAT,Chain),
	textout1(PAT,LIND,TIND,NEWRCT,St,Chain,Alignment),
	!.    	

    textout(param(RCT,BORDER,ST,ALIGNMENT,FORE,BACK,LIND,TIND,FF,FSTYLE,FSIZE),FONT):-
	retrieve_pattern(ST,PAT),
	re_check_existing_props("",FONT,FORE,BACK,BORDER,PAT,FF,FSTYLE,FSIZE),
	insert_Bord(RCT,BORDER,BACK,PAT),
	PAT = pat_Solid,
	insert_Indentation(LIND,TIND,RCT,RCT_IND),
	assertz(keeping(out_text(RCT_IND,ST,ALIGNMENT))),
	!.    	
    textout(_,_):-!.

   insert_Bord(_,re_border(0),color_White,pat_Solid):-!.		% Rectangle Only
   insert_Bord(rct(L,T,R,B),_,_,pat_Cross):-		% Line ONLY
   	assert(keeping(outline(pnt(L,T),pnt(R,B)))),
   	!.	
   insert_Bord(RCT,re_brockenrect(L,T,R,B,DX,DY),_,_):-	
	assertz(keeping(outbrockenrect(RCT,L,T,R,B,DX,DY))),
	!.
   insert_Bord(rct(L,T,R,B),_,_,_):-			% Border Around the Text
	NR = R + 1, NB = B + 1,
	RRR = rct(L,T,NR,NB),
	assertz(keeping(outrect(RRR))),
	!.
   insert_Bord(_,_,_,_):-!.		% Rectangle Only

   insert_dbBord(_,re_border(0),color_White,pat_Solid,_):-!.		% Rectangle Only
   insert_dbBord(rct(L,T,R,B),_,_,pat_Cross,Chain):-		% Line ONLY
	chain_insertz(engine,Chain,KEEP_DBA_DOM,outline(pnt(L,T),pnt(R,B)),_),
   	!.	
   insert_dbBord(RCT,re_brockenrect(L,T,R,B,DX,DY),_,_,Chain):-	
	chain_insertz(engine,Chain,KEEP_DBA_DOM,outbrockenrect(RCT,L,T,R,B,DX,DY),_),
	!.
   insert_dbBord(rct(L,T,R,B),_,_,_,Chain):-			% Border Around the Text
	NR = R + 1, NB = B + 1,
	RRR = rct(L,T,NR,NB),
	chain_insertz(engine,Chain,KEEP_DBA_DOM,outrect(RRR),_),
	!.
   insert_dbBord(_,_,_,_,_):-!.		% Rectangle Only

  insert_Indentation(LIND,TIND,RCT,RCT_IND):-
  	RCT = rct(L,T,R,B),
  	NL = L + LIND, NT = T + TIND,
  	NR = R - LIND,
  	RCT_IND = rct(NL,NT,NR,B),
  	!.
  	
%********************************************************************************
%		Keeping & Extracting write properties
%********************************************************************************
  re_set_writeproperty(Chain):-
	Chain = "",
  	writeprop(Chain,FONT,L9,L0,BORDER,PAT,FF,FSTYLE,FSIZE),
	assertz(keeping(outprop(FONT,L9,L0,BORDER,PAT,FF,FSTYLE,FSIZE))),
	!.			
  re_set_writeproperty(Chain):-
  	writeprop(Chain,FONT,L9,L0,BORDER,PAT,FF,FSTYLE,FSIZE),
	chain_insertz(engine,Chain,KEEP_DBA_DOM,outprop(FONT,L9,L0,BORDER,PAT,FF,FSTYLE,FSIZE),_),
	!.			
  re_set_writeproperty(_). 	

  re_check_existing_props(Chain,FONT,FOREGR_COLOR,BACKGR_COLOR,re_border(BORDER),PAT,FF,FSTYLE,FSIZE):-
	writeprop(Chain,FONT,FOREGR_COLOR,BACKGR_COLOR,BORDER,PAT,FF,FSTYLE,FSIZE),
	!.	

  re_check_existing_props(Chain,FONT,FOREGR_COLOR,BACKGR_COLOR,BORDER_TYPE,PAT,FF,FSTYLE,FSIZE):-
	not(BORDER_TYPE = re_border(_)),
	writeprop(Chain,FONT,FOREGR_COLOR,BACKGR_COLOR,_,PAT,FF,FSTYLE,FSIZE),
	!.	

  re_check_existing_props(_,_,_,_,_,_,_,_,_):-
	retract(writeprop(_,_,_,_,_,_,_,_,_)),
	fail.

  re_check_existing_props(Chain,FONT,FOREGR_COLOR,BACKGR_COLOR,re_border(BORDER),PAT,FF,FSTYLE,FSIZE):-
	asserta(writeprop(Chain,FONT,FOREGR_COLOR,BACKGR_COLOR,BORDER,PAT,FF,FSTYLE,FSIZE)),
	re_set_writeproperty(Chain),
	!.             
  re_check_existing_props(Chain,FONT,FOREGR_COLOR,BACKGR_COLOR,_,PAT,FF,FSTYLE,FSIZE):-
	asserta(writeprop(Chain,FONT,FOREGR_COLOR,BACKGR_COLOR,1,PAT,FF,FSTYLE,FSIZE)),
	re_set_writeproperty(Chain),
	!.             

predicates
procedure	m_pageprop(PAGEPROPERTIES,REAL,REAL)
procedure	pageprop(PAGEPROPERTY)
procedure	m_margins(REAL,REAL,REAL,REAL)
procedure	footer_setting(INTEGER)
procedure	clear_superfluous_page
procedure	clear_extra_outpage(INTEGER,LONG)
procedure	get_while_order(INTEGER)
procedure	BOOLEAN retrieve_direction(PROPERTIES)
  
clauses

  m_pageprop([],T,B):-
  	margins(_L,T,_R,B), !.
  m_pageprop([],1.0,1.0):-!.
  	
  m_pageprop([FIRST|REST],T,B):-
	pageprop(FIRST), !,
  	m_pageprop(REST,T,B).

  m_pageprop(_,1.0,1.0):-errorexit().
  pageprop(margins(L,T,R,B)):-
  	m_margins(L,T,R,B),!.

  pageprop(units(pixel)):-!.
  pageprop(units(cm)):-
	drv_metrics(_,_,ScreenH,ScreenV,_,_,_,_),
	K_H = ScreenH /2.54,
	K_V = ScreenV /2.54,
	assert(convert_hor(K_H)),
	assert(convert_ver(K_V)),
	!.
  pageprop(units(logical(HOR,VERT))):-
   	margins(LEFT,Top,RIGHT,Bottom),
	drv_metrics(_,_,ScreenH,ScreenV,PrH,PrW,Pr_hres,Pr_vres),
	K_H = ScreenH * (PrW - (Left + Right) * Pr_hres / 2.54) / (Pr_hres * HOR),
	K_V = ScreenV * (PrH - (Top + Bottom) * Pr_vres / 2.54) / (Pr_vres * VERT),
	assert(convert_hor(K_H)),
	assert(convert_ver(K_V)),
	!.
  	  	
  pageprop(_).
  m_margins(_,_,_,_):-
   	retract(margins(_,_,_,_)),
	fail.
  m_margins(LEFT,TOP,RIGHT,BOTTOM):-
   	assert(margins(LEFT,TOP,RIGHT,BOTTOM)),
   	!.

  footer_setting(main):-
  	pb_sign_superfluous,
  	clear_superfluous_page,
	not(draw_forbidden),
	assert(draw_forbidden),
	!.  	
  footer_setting(_):-
  	change_second_level,
	footers(F,VRES),
	Y = VRES - F,
	set_Y(Y),
	x_reset(0),
	active_prop(2,_,_,_,_,X,_,_,_,_,_,_,_,_,_,_,_),
	set_X(X), !.
  footer_setting(_).

  clear_superfluous_page:-
	retract(page(N,R)),
	P = N - 1,
	assert(page(P,R)),
	!. 
  clear_superfluous_page.
  
  clear_extra_outpage(PAGE,Pos):-
	PAGE >= 1000,
	NewPos = Pos - 15,
	filepos(re_temp_file,NewPos,0),
  	!.
  clear_extra_outpage(PAGE,Pos):-
	PAGE >= 100,
	NewPos = Pos - 14,
	filepos(re_temp_file,NewPos,0),
  	!.
  clear_extra_outpage(PAGE,Pos):-
	PAGE >= 10,
	NewPos = Pos - 13,
	filepos(re_temp_file,NewPos,0),
  	!.
  clear_extra_outpage(_,Pos):-
	NewPos = Pos - 12,
	filepos(re_temp_file,NewPos,0),
  	!.
  clear_extra_outpage(_,_).
  
  get_while_order(ORDER):-
	while_data(INT,_,_,_,_,_,_),
	ORDER = INT + 1,
	!.
  get_while_order(1).
  
  retrieve_direction([],b_false):-!.
  retrieve_direction([horizontal_block|_],b_true):-!.
  retrieve_direction([_|ROP],RES):- !,
  	RES = retrieve_direction(ROP).
  retrieve_direction(_,b_false):-errorexit().
predicates
procedure	move_termsfrom_chain(REF)
clauses
  move_termsfrom_chain(REF):-
  	ref_term(engine,KEEP_DBA_DOM,REF,Term),
  	assertz(keeping(Term),keep),
  	chain_next(engine,REF,NEXT), !,
  	move_termsfrom_chain(NEXT).

  move_termsfrom_chain(_).
predicates
determ		proc_endofsheet1(process_pred,HEADER_WITHP_LIST)
determ		check_eof_or_flag(INTEGER)
procedure	m_headerlist(HEADER_WITHP_LIST,process_pred)
procedure	m_header(HEADER,process_pred,INTEGER)
procedure	m_footer(FOOTER,process_pred)
procedure	estimate_footer(FOOTER,process_pred)
procedure	proc2(process_pred,HEADER_WITHP_LIST,INTEGER)
procedure	decrement_page(process_pred,HEADER_WITHP_LIST,INTEGER) 
procedure	decrement_dbpage(INTEGER,STRING,PROCESS_PRED,HEADER_WITHP_LIST)
procedure	re_store_pagemark(INTEGER,INTEGER)
procedure	re_change_composite_page(INTEGER)
procedure	clear_keep_buffer
procedure	flush_keep_buffer
procedure	re_update_buffer(INTEGER)
procedure	re_read_temp_buffer(INTEGER,INTEGER)
procedure	read_page_num(KEEP_DBA_DOM,INTEGER,INTEGER)
procedure	re_store_update_info(KEEP_DBA_DOM,INTEGER)
procedure	re_temp_file_open_proc
procedure	bord_setting(THICKBORD)
procedure	insert_pb_sign0
procedure	insert_pb_sign1
procedure	change_recalculation_delta(INTEGER)

clauses
  proc_endofsheet(_,_,accessory):-!.
  proc_endofsheet(_,_,c_header):-!.
  proc_endofsheet(_,_,c_footer):-!.
  proc_endofsheet(CCB,HEADER,_FLAG):-
	get_Y(Y),
	proc_endofsheet1(CCB,HEADER),
	proc2(CCB,HEADER,Y),!.
  proc_endofsheet(_,_,_).

  
%-------- have printed --->  quit
  proc_endofsheet1(CCB,HEADER):-
	last_pos(Y),
	footers(HP,VRES),
	AVAIL = VRES - HP,
	Y > AVAIL,
	end_of_pane,
	put_older,
	tree(report(_,_,_,_,HEAD,_,FOOTER),_),!,
	check_split(AVAIL,HEAD,HEADER,CCB),
	re_change_composite_page(re_root_page),
	footer_setting(end_of_sheet),
        m_footer(FOOTER,CCB).
%------ scroll one more page and make current the last
%------ /to provide End Button Pressing does not exceed the page boundary/
  decrement_page(CCB,HEAD,Y):-
	db_flush(engine),
	chain_first(engine,"page1",_), !,
	decrement_dbpage(main,"page1",CCB,HEAD),
	retractall(page_right_expansion(_,_)),
	decrement_page(CCB,HEAD,Y).
	
  decrement_page(CCB,HEAD,Y):-
  	retract(page(CURRENT,_)),
	NEXT = CURRENT + 1,
	assert(page(NEXT,CURRENT)),
  	set_up,
	tree(report(_,_,PROP,_,HEADER,_,_),_),
	y_reset,
	m_properties(1,PROP),
	change_second_level,
        retractall(left_corner(_)),
        m_header(HEADER,CCB,c_footer),
        m_headerlist(HEAD,CCB),
        count_over_again(DELTA),
        change_recalculation_delta(DELTA),
	NewY = Y  - Delta,
	y_store(NewY),
	proc_endofsheet(CCB,HEAD,main),
        !.
  decrement_page(_,_,_).
  proc2(CCb,HEADER,Y):-
  	page(PAGE,_),
	PP = PAGE + 1,
  	assertz(keeping(outpage(PP))), 
	openappend(re_temp_file,re_temp_file_name),
	writedevice(re_temp_file),
	flush_keep_buffer,
	closefile(re_temp_file),
	re_temp_file_open_proc,
	vpi_ProcessEvents(b_true),
  	decrement_page(CCB,HEADER,Y),!.
  proc2(_,_,_).
  	
  decrement_dbpage(_,_,_,_):-
	retractall(obj_right_expansion(_,_)),
	chain_delete(engine,"recured"),
	fail.

  decrement_dbpage(Flag,Chain,CCB,HEAD):-
	chain_first(engine,Chain,REF),
  	retract(page(CURRENT,_)),
	NEXT = CURRENT + 1,
	assert(page(NEXT,CURRENT)),
	concat("page",Num,Chain),
	str_int(Num,Level),
  	set_up,
	tree(report(_,_,PROP,_,HEADER,_,FOOTER),_),
	y_reset,
	m_properties(1,PROP),
	change_second_level,
        retractall(left_corner(_)),
        m_header(HEADER,CCB,c_footer),
	move_termsfrom_chain(REF),
	re_change_composite_page(re_side_page),
	footer_setting(end_of_sheet),
        m_footer(FOOTER,CCB),
	OutPage = Next + 1,
	re_store_pagemark(Flag,OutPage),
	openappend(re_temp_file,re_temp_file_name),
	writedevice(re_temp_file),
	flush_keep_buffer,
	closefile(re_temp_file),
	re_temp_file_open_proc,
	vpi_ProcessEvents(b_true),
	Next_Level = Level + 1,
	format(NextChain,"page%d",Next_Level),
	chain_delete(engine,Chain), !,
	decrement_dbpage(FLAG,NextChain,CCB,HEAD).
	
  decrement_dbpage(_,_,_,_).
%---	28th of November 
  re_store_pagemark(_main,OutPage):-
  	assertz(keeping(outpage(OutPage))), !.
  re_store_pagemark(_,_).

  re_change_composite_page(re_root_page):-
  	retract(composite_page(R,_)),
  	N = R + 1,
  	assert(composite_page(N,1)),
  	!.
  	
  re_change_composite_page(re_side_page):-
  	retract(composite_page(R,S)),
  	N = S + 1,
  	assert(composite_page(R,N)),
  	!.

  re_change_composite_page(_):-
  	assert(composite_page(1,1)),
  	!.

  clear_keep_buffer:-
	retractall(_,keep),
  	!.
  	
  flush_keep_buffer:-
	retract(keeping(DBA),keep),
	term_str(KEEP_DBA_DOM,DBA,STR),
	write(STR), nl,
	fail.

  flush_keep_buffer.

  re_update_buffer(PAGE):-
	re1_repeat,
	re_read_temp_buffer(PAGE,FLAG),
	check_eof_or_flag(FLAG),
  	retractall(re_stream),
	!.

  re_update_buffer(_).

  re_read_temp_buffer(PAGE,FLAG):-
  	readln(STR),
	term_str(KEEP_DBA_DOM,DBA,STR),
	read_page_num(DBA,PAGE,FLAG),
	re_store_update_info(DBA,FLAG),
	!.

  re_read_temp_buffer(_,main).

  read_page_num(outpage(P),P,proceed):- 
  	assert(re_stream),!.
  read_page_num(outpage(_),_,main):-
  	retract(re_stream), !.
  read_page_num(_,_,proceed):- re_stream, !.
  read_page_num(_,_,accessory):-!.
  
  re_store_update_info(_,accessory):-!.
  re_store_update_info(DBA,_):-
	assertz(updating(DBA),preview_update), !.
  
  check_eof_or_flag(main):-!.
  check_eof_or_flag(_):-
  	eof(re_temp_file), !.
  	
  re_temp_file_open_proc:-
  	retract(re_send_invalidate(WIN)),
  	win_Invalidate(WIN), !.

  re_temp_file_open_proc.
  
  bord_setting(doublebord):-
  	not(left_corner(_)),
  	get_Y(Y0),
  	Y0 < 31000,
  	assert(left_corner(Y0)),
  	!.
  bord_setting(_):-!.
  insert_pb_sign:-
	  insert_pb_sign0,
	  insert_pb_sign1.

  insert_pb_sign0:-
  	pb_sign,!.
  insert_pb_sign0:-
  	assert(pb_sign), !.
  	
  insert_pb_sign1:-
  	pb_sign_superfluous,!.
  insert_pb_sign1:-
  	assert(pb_sign_superfluous), !.

  change_recalculation_delta(_):-
  	retract(recalculation_delta(_)),
  	fail.
  change_recalculation_delta(DELTA):-
  	assert(recalculation_delta(DELTA)),
  	!.
  	
predicates
procedure	m_pict(STRING,BLOCK_RECT)
procedure	m_pict1(STRING,PNT)
procedure	m_line(BLOCK_RECT)
clauses  	
  m_pict(STR,RECT):-
	rect_measured(RECT,L,UP,_,_),
	concat(STR,".bmp",FILE),
	trap(PICT = pict_Load(FILE),_V,fail),
	P_ZERO = cast(PICTURE,0),
	PICT >< P_ZERO,
	pict_GetSize(PICT,_,H,_),
	pict_Destroy(PICT),
	BOTTOM = UP + H,
	y_memory(BOTTOM),
	LEFT = val(INTEGER,L),
	PNT = pnt(LEFT,UP),
	m_pict1(FILE,PNT),
	!.
  m_pict(STR,RECT):-
	rect_measured(RECT,_,_,_,DOWN),
	y_memory(DOWN),
  	writef(re_s01,STR),
  	!.

  m_pict1(_,_):-
  	draw_forbidden, !.
  m_pict1(FILE,PNT):-
	assertz(keeping(outpict(FILE,PNT))),
	!.
  m_line(RECT):-
	rect_measured(RECT,L,TOP,RIGHT,BOTTOM),
	emax(TOP,BOTTOM,MAX),
	y_memory(MAX),
	LEFT = val(INTEGER,L),
	m_line1(pnt(LEFT,TOP),pnt(RIGHT,BOTTOM)),
	!.	
  m_line1(_,_):-
  	draw_forbidden, !.
  m_line1(pnt(L,T),pnt(R,B)):-
	cut_right_tail(rct(L,T,R,B),LOUT,RR),
	RRR = rct(LOUT,T,RR,B),
	FONT=font_Create(ff_System, [],6),	% Null Font
	active_block(LEVEL),
	store_block_width(LEVEL,RR,main),
	assert(block(LEVEL,param(RRR,re_border(0),"\\l",[],0,0,0,0,0,[],0),FONT)),
	!.
  m_line1(_,_).

ifdef   report_shift_tabpos

predicates
procedure	re_shift_tabpos(INTEGER,ILIST,ILIST,ILIST)
procedure	re_shift_tabpos1(INTEGER,ILIST,ILIST)

clauses
  re_shift_tabpos(_,[],T,T):-!.

  re_shift_tabpos(L,[X|TABS],T,SHIFTED):-
  	convert_hor(K_H),
  	Z = trunc(X*K_H),
  	L > Z, !,
  	re_shift_tabpos(L,TABS,T,SHIFTED).

  re_shift_tabpos(L,[X|TABS],T,SHIFTED):-
	not(convert_hor(_)),
  	L > X, !,
  	re_shift_tabpos(L,TABS,T,SHIFTED).

  re_shift_tabpos(L,LIST,_,SHIFTED):-
  	re_shift_tabpos1(L,List,Shifted).
  
  re_shift_tabpos1(_,[],[]):-!.

  re_shift_tabpos1(L,[X|Rest],[V|List]):-
  	convert_hor(K_H),
  	V = trunc(X * K_H) - L, !,
  	re_shift_tabpos1(L,Rest,List).
  	  
  re_shift_tabpos1(L,[X|Rest],[V|List]):-
  	V = X - L, !,
  	re_shift_tabpos1(L,Rest,List).
  	  
  re_shift_tabpos1(_,_,[]):-errorexit().
elsedef
predicates
procedure	re_recalculate_tabpos(ILIST,ILIST)

clauses
  re_recalculate_tabpos([],[]):-!.

  re_recalculate_tabpos([X|TABS],[Z|CALCULATED]):-
  	convert_hor(K_H),
  	Z = trunc(X*K_H), !,
  	re_recalculate_tabpos(TABS,CALCULATED).

  re_recalculate_tabpos(TABS,TABS):- !.

enddef

predicates
determ		re_extract_completed_line(STRING,STRING,INTEGER,STRING)
determ		re_check_extracted_char(STRING,STRING,STRING,INTEGER,INTEGER,INTEGER,STRING,STRING)
procedure	re_extract_with_lines(STRING,INTEGER,SLIST,INTEGER,INTEGER)
procedure	shift_pos_afterWrap(INTEGER,INTEGER)
determ		re_store_maxwrappos(INTEGER,INTEGER)
procedure	re_choose_maxwrap(INTEGER)
procedure	print_wrapborder(INTEGER,RCT,INTEGER)
procedure	adjust_bottom_byline(INTEGER,INTEGER,INTEGER,INTEGER,INTEGER)
procedure	print_atposition(STRING,RCT,INTEGER)
procedure	print_atrect1(STRING,ILIST,RCT)
procedure	print_atrect10(STRING,INTEGER,INTEGER,INTEGER)
procedure	print_atrect2(SLIST,RCT,INTEGER,INTEGER)
procedure	print_atrect21(SLIST,RCT,INTEGER,INTEGER)
procedure	num_incl(STRING,INTEGER,SLIST)
procedure	num_incl1(INTEGER,STRING,INTEGER,SLIST)

clauses
%===	Kits for W R A P text property processing		===

  re_extract_with_lines(STR,Width,[LISTELEMENT|LIST],Total,Height):-
  	re_extract_completed_line(STR,REST,Width,LISTELEMENT), !,
  	re_extract_with_lines(REST,Width,LIST,Lines,Height),
  	Total = Lines + 1.

  re_extract_with_lines("",_,[""],1,Height):- 
  	m_calcultext("S",rct(0,0,0,0),noclip_re,Height,_),
	!.
  re_extract_with_lines(STR,_,[STR],1,Height):- 
  	m_calcultext(STR,rct(0,0,0,0),noclip_re,Height,_),
	!.

  re_extract_completed_line(STR,REST,Width,LISTELEMENT):-
  	frontstr(1,STR,EX,TAIL),
  	re_check_extracted_char(Ex,"",Tail,Width,0,1,Rest,ListelEment).
  
  re_check_extracted_char(" ",WORD,STR,Width,_BlPos,LastPos,Rest,Element):-
  	m_calcultext(WORD,rct(0,0,0,0),noclip_re,_,rct(_,_,W,_)),
	W < Width, !,
  	frontstr(1,STR,EX,TAIL),
  	concat(WORD," ",WORD1),
  	NextPos = LastPos + 1,
	re_check_extracted_char(EX,WORD1,TAIL,Width,LastPos,NextPos,Rest,Element),
	!.
  
  re_check_extracted_char("\n",WORD,STR,_Width,_BlankPos,_LastPos,STR,Word):- !.

  re_check_extracted_char(Char,WORD,STR,Width,BlankPos,LastPos,Rest,Element):-
  	m_calcultext(WORD,rct(0,0,0,0),noclip_re,_,rct(_,_,W,_)),
	W < Width, !,
  	frontstr(1,STR,EX,TAIL),
  	concat(WORD,Char,WORD1),
  	NextPos = LastPos + 1,
	re_check_extracted_char(EX,WORD1,TAIL,Width,BlankPos,NextPos,Rest,Element),
	!.
  
  re_check_extracted_char(Char,WORD,STR,_Width,BlankPos,_LastPos,Rest,Element):-
  	not(BlankPos = 0),
  	frontstr(BlankPos,Word,Element,R1),
  	concat(R1,Char,R2),
  	concat(R2,Str,Rest),
  	!.
  
  re_check_extracted_char(Char,WORD,STR,_,_,LastPos,Rest,Element):-
	CurPos = LastPos - 2,
	CurPos > 1,
	frontstr(CurPos,Word,Element,R1),
	concat(R1,Char,R2),
	concat(R2,Str,Rest),
	!.
	
  shift_pos_afterWrap(B_Delta,Y0):-
	active_prop(3,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,COMPL),
	bitand(COMPL,8,VAL),
	re_store_maxwrappos(VAL,B_Delta),
	VAL = 0,
  	B_Delta > 0,
  	B = Y0 + B_Delta,
  	set_Y(B), !.
  shift_pos_afterWrap(_,_).

  re_store_maxwrappos(8,B_Delta):-
  	B_Delta > 0,
	re_choose_maxwrap(B_Delta),
	!.
  
  re_choose_maxwrap(B_Delta):-
  	re_maxwrap(B),
  	B >= B_Delta, !.
  re_choose_maxwrap(_):-
  	retract(re_maxwrap(_)),
  	fail.
  re_choose_maxwrap(B):-
  	assert(re_maxwrap(B)), !.

  print_wrapborder(0,_,_):-!.
  print_wrapborder(BORDER,RCTCALC,CLIP):-
  	set_border(BORDER),
	print_atposition("\p",RCTCALC,CLIP).

%===	Print a single Line of Text (poss. with tabs)	===
  print_line(STR,RCT,_):-
  	searchchar(STR,'\t',_Pos),
  	get_tabs(TABS),
  	not(TABS = []),
ifdef   report_shift_tabpos
  	RCT = rct(L,_,_,_),
	get_X(X0), L_rel = val(INTEGER,L - trunc(X0)),
	re_shift_tabpos(L_rel,TABS,TABS,SHIFTED),
  	print_atrect1(STR,SHIFTED,RCT), !.
elsedef
	re_recalculate_tabpos(TABS,RECALCULATED),
  	print_atrect1(STR,RECALCULATED,RCT), !.
enddef

  print_line(STR,RCT,_):-
  	searchchar(STR,'\t',_Pos),
  	print_atrect1(STR,[0],RCT), !.
  print_line(STR,RCT,CLIP):-
  	textparam(reptxt(STR),RCT,CLIP).

  adjust_bottom_byline(1,_,_,Bottom,Bottom):-!.

  adjust_bottom_byline(Lines,Height,T,_,Bottom):-
	Bottom = T + trunc(1.1 * Lines * Height).
%===	Text with W R A P Property		===  	
  print_atposition(STR,RCT,CLIP):-
	not(STR = "\p"),
	active_prop(3,_,_,_,_,_,_,_,_,_,_,_,_,_,_,wrap_re,_),!,
	get_Y(Y0),
	RCT = rct(L,T,R,B),
	Width = R - L,
	re_extract_with_lines(STR,Width,LIST,Lines,Height),
	adjust_bottom_byline(Lines,Height,T,B,Bottom),
	RCTCALC = rct(L,T,R,Bottom),
	get_border(BORDER),
	set_border(0),
  	print_atrect2(LIST,RCTCALC,Lines,CLIP),
	print_wrapborder(BORDER,RCTCALC,noclip_re),
  	B_DELTA = BOTTOM - B,
  	shift_pos_afterWrap(B_Delta,Y0).

%===	Text broken with Line Break		===
  print_atposition(STR,RCT,CLIP):-
  	num_incl(STR,NUM,LIST),
 	NUM > 0,!,
	Lines = NUM + 1,
	get_border(BORDER),
	set_border(0),
  	print_atrect2(LIST,RCT,Lines,CLIP),
	set_border(BORDER),
	print_atposition("\p",RCT,CLIP).
  	
%===	Line of Text				===
  print_atposition(STR,RCT,CLIP):-
  	print_line(STR,RCT,CLIP).
  
%===	Tabs from property	===
  print_atrect1(STR,[XP|X_REST],RCT):-
	searchchar(STR,'\t',Pos),
	N = Pos - 1,
	frontstr(N,STR,SPrn,Rest),
	RCT = rct(L,T,_,B),
	X_REST = [XS|_],
	L2 = L + XP,
	R2 = L + XS,
	RRR = rct(L2,T,R2,B),
	textparam(reptxt(SPrn),RRR,depend_re),
	frontchar(Rest,'\t',REST_STR),!,
	print_atrect1(REST_STR,X_REST,RCT).

%===	Auto Tabs by Defaulttabs property (if exists !) 	===
  print_atrect1(STR,[XP|_],RCT):-
	active_prop(3,_,_,_,_,_,_,Defaulttabs,_,_,_,_,_,_,_,_,_),
	not(Defaulttabs = 0),
	searchchar(STR,'\t',Pos),
	N = Pos - 1,
	frontstr(N,STR,SPrn,Rest),
	RCT = rct(L,T,_,B),
	Xs = XP + Defaulttabs,
	L2 = L + XP,
	R2 = L + Xs,
	RRR = rct(L2,T,R2,B),
	textparam(reptxt(SPrn),RRR,depend_re),
	frontchar(Rest,'\t',REST_STR),!,
	print_atrect1(REST_STR,[Xs],RCT).

%===	Auto Tabs by 8 char		===
  print_atrect1(STR,[XP|_],RCT):-
	searchchar(STR,'\t',Pos),
	N = Pos - 1,
	frontstr(N,STR,SPrn,Rest),
	RCT = rct(L,T,_R,B),
	concat(SPrn,"xxxxxxxx",JustString),
	m_calcultext(JustString,rct(0,0,0,0),noclip_re,_,rct(_,_,W,_)),
	L2 = L + XP,
	X_P = L2 + W,
	RCT_DRAW = rct(L2,T,X_P,B),
	textparam(reptxt(SPrn),RCT_DRAW,depend_re),
	frontchar(Rest,'\t',REST_STR),!,
	print_atrect10(REST_STR,X_P,T,B).

  print_atrect1(_,_,_).

  print_atrect10(STR,L,Y1,Y2):-
	searchchar(STR,'\t',Pos),
	N = Pos - 1,
	frontstr(N,STR,SPrn,Rest),
	concat(SPrn,"xxxxxxxx",JustString),
	m_calcultext(JustString,rct(0,0,0,0),noclip_re,_,rct(_,_,W,_)),
	X_P = L + W,
	RCT = rct(L,Y1,X_P,Y2),
	textparam(reptxt(SPrn),RCT,depend_re),
	frontchar(Rest,'\t',REST_STR),!,
	print_atrect10(REST_STR,X_P,Y1,Y2).

  print_atrect10(_,_,_,_).

  print_atrect2(LIST,RCT,NUM,CLIP):-
	RCT = rct(X1,Y1,X2,Y2),
  	DELTA = val(INTEGER,(Y2 - Y1)/NUM),
  	NY = Y1 + DELTA,
  	RRR = rct(X1,Y1,X2,NY),
	print_atrect21(LIST,RRR,DELTA,CLIP).
	  
  print_atrect21([],_,_,_):-!.
  print_atrect21([STR|LIST],RCT,DELTA,CLIP):-
  	searchchar(STR,'\n',Pos),
  	Pos = 1,!,
  	print_line(" ",RCT,CLIP),
  	RCT = rct(L,_T,R,B),
  	NB = B + DELTA,
  	RRR = rct(L,B,R,NB),
  	print_atrect21(LIST,RRR,DELTA,CLIP).
  	
  print_atrect21([STR|LIST],RCT,DELTA,CLIP):-
  	searchchar(STR,'\n',Pos),
  	N = Pos - 1,
  	frontstr(N,STR,Legal,_),!,
  	print_line(Legal,RCT,CLIP),
  	RCT = rct(L,_T,R,B),
  	NB = B + DELTA,
  	RRR = rct(L,B,R,NB),
  	print_atrect21(LIST,RRR,DELTA,CLIP).
  	
  print_atrect21([STR|LIST],RCT,DELTA,CLIP):-
  	print_line(STR,RCT,CLIP),
  	RCT = rct(L,_T,R,B),
  	NB = B + DELTA, 
  	RRR = rct(L,B,R,NB), !,
  	print_atrect21(LIST,RRR,DELTA,CLIP).
  print_atrect21(_,_,_,_):-errorexit().
  
  num_incl(STR,NE,LIST):-
	searchchar(STR,'\n',Pos),
	num_incl1(Pos,STR,NUM,LIST),
	NE = NUM + 1,
	!.
  num_incl(STR,0,[STR]):-!.
  num_incl1(N,STR,NUM,[TARG|LIST]):-
	frontstr(N,STR,TARG,REST),
	num_incl(REST,NUM,LIST),
	!.
  num_incl1(_,_,0,[]):-!.

predicates
determ		m_block(BLOCK,process_pred,HEADER_WITHP_LIST)
determ		extract_sign
procedure	not_reached
procedure	check_draw_forbidden(INTEGER)
procedure	clear_draw_forbidden(INTEGER)
procedure	estimate_headerlist(HEADER_WITHP_LIST,PROCESS_PRED)
procedure	estimate_header(HEADER,PROCESS_PRED,INTEGER)
procedure	m_atomlist(ATOMBLOCKLIST,PROCESS_PRED,HEADER_WITHP_LIST)
procedure	put_footer_mark
procedure	insert_outer_mark(LEVEL_PROPERTIES,THICKBORD)
procedure	re_force_new_page(INTEGER)
procedure	re_check_pb_occured(INTEGER,INTEGER,INTEGER,PROCESS_PRED,HEADER_WITHP_LIST)
procedure	get_recalculation_delta(INTEGER)

clauses
  not_reached:-
  	assert(not_reached_yet),!.
  extract_sign:-
  	retract(not_reached_yet), !.
  	
  check_draw_forbidden(1):-
  	draw_forbidden, !.
  check_draw_forbidden(0):-
  	assert(draw_forbidden), !.
  clear_draw_forbidden(1):-!.
  clear_draw_forbidden(_):-
  	retractall(draw_forbidden).
  	
  get_headers_height(CCB,HEADER,HEADERLIST,POS):-
  	check_draw_forbidden(FLAG),
	get_Y(Y0),
	set_Y(0),
  	y_reset,
  	estimate_header(HEADER,CCB,c_footer),
  	estimate_headerlist(HEADERLIST,CCB),
  	last_pos(POS),
  	y_reset,
  	set_Y(Y0),
	clear_draw_forbidden(FLAG),
  	!.
  get_headers_height(_,_,_,0).

  estimate_header(header(PROP,_,ATOMLIST),CCB,FLAG):-
  	m_properties(2,PROP),
	on_beginning(PROP,accessory),
  	m_atomlist(ATOMLIST,CCB,[]),
	on_exit(CCB,[],FLAG),
  	!.
  estimate_header(noheader,_,_):-!.
  estimate_header(_,_,_):-errorexit().
  estimate_headerlist([],_):-!.
  estimate_headerlist([headerproperty(HEAD,PROP,_POS,BORD)|LIST],CCB):-!,
	setup_all_properties(2,PROP),
  	bord_setting(BORD),
  	estimate_header(HEAD,CCB,c_footer),
  	estimate_headerlist(LIST,CCB).
  estimate_headerlist(_,_):-errorexit().

  put_footer_mark:-
    	draw_forbidden,!.
  put_footer_mark:-
	assertz(keeping(outfooter())),
	!.  
  insert_outer_mark(level_properties(_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,COMPL),singlebord):-
	bitand(COMPL,4,VAL),
	VAL = 4,
  	get_X(X0),get_Y(Y0),
  	X = val(INTEGER,X0),
  	asserta(outer_left_top(X,Y0)), !.

  insert_outer_mark(_,nobord).
	
  re_force_new_page(ORDER):-
	while_data(ORDER,_,_,_,PROP,HLIST,CCB),
	PROP = level_properties(_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,COMPL),
	bitand(COMPL,$20,VAL),
	VAL = $20,
	m_block(pagebreak,CCB,HLIST),
	!.
  re_force_new_page(_).


  re_check_pb_occured(_,_,_,_,_):-
  	retract(pb_sign), !.
/*  re_check_pb_occured(_,_,_,CCB,HLIST):-
	active_prop(3,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,COMPL),
	bitand(COMPL,$20,VAL),
	VAL = $20,
	m_block(pagebreak,CCB,HLIST),
	!.
*/	
  re_check_pb_occured(_,Yz,_,_,_):-
	active_prop(3,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,COMPL),
	bitand(COMPL,8,VAL),
	VAL = 8,
	retract(re_maxwrap(B_Delta)),
  	New = Yz + B_Delta,
  	set_Y(New), !.
  re_check_pb_occured(main,YR,PAGE0,_,_):-
	rp_get_page(PAGE1),
	PAGE0 = PAGE1,
  	set_Y(YR), !.

  re_check_pb_occured(main,YR,PAGE0,_,_):-
	rp_get_page(PAGE1),
	not(PAGE0 = PAGE1),
	get_recalculation_delta(DELTA),
	NewY = YR - DELTA, !,
	set_Y(NewY).

  re_check_pb_occured(_,_,_,_,_).
  	
  get_recalculation_delta(DELTA):-
  	recalculation_delta(DELTA), !.
  get_recalculation_delta(0):- !.
  	
predicates
determ		m_state_while(COND,STMTS,process_pred)
determ		m_while(INTEGER,REAL,INTEGER,INTEGER)
determ		m_while1(INTEGER,INTEGER,LEVEL_PROPERTIES,REAL,INTEGER,REAL,INTEGER)
determ		m_atom(ATOMBLOCK,process_pred,HEADER_WITHP_LIST)
procedure	m_report(REPORT,process_pred)
procedure	m_name(NAME,process_pred)
procedure	m_script(STMTS,process_pred)
procedure	m_statement(STMT,process_pred)
procedure	m_rect(BLOCK_RECT)
procedure	INTEGER m_blocklist(BLOCKLIST,HEADER_WITHP_LIST,LEVEL_PROPERTIES,PROCESS_PRED)
procedure	report_retcode(PROCESS_PRED,HEADER_WITHP_LIST)

clauses
  m_report(report(NAME,_,PROPERTIES,script(STMTS),HEADER,BLOCK,FOOTER),CCB):-
        m_name(NAME,CCB),
        m_script(STMTS,CCB),
	m_properties(1,PROPERTIES),
	x_reset(0),
  	change_second_level,
        m_header(HEADER,CCB,accessory),
        on_beginning([],main),
  	change_second_level,
        backup_all_properties(2,PROP),
        RET = m_blocklist(BLOCK,[],PROP,CCB),
	re_change_composite_page(re_root_page),
        footer_setting(RET),
        m_footer(FOOTER,CCB),
        report_retcode(CCB,[]),
	re_temp_file_open_proc,
	vpi_ProcessEvents(b_true),
        !.
  m_report(_,_):-!.

  report_retcode(CCB,HEAD):-
	db_flush(engine),
%+++++++ N E W	16 of Sept' 97
	chain_first(engine,"page1",_),
	page(CURRENT,_),
	NEXT = CURRENT + 1,
  	assertz(keeping(outpage(NEXT))), 
	decrement_dbpage(end_of_sheet,"page1",CCB,HEAD),
	retract(page(First,_)), !,
	assert(page(First,First)),
  	assertz(keeping(outpage(0))),
	openappend(re_temp_file,re_temp_file_name),
	writedevice(re_temp_file),
	flush_keep_buffer,
	closefile(re_temp_file),
	!.
  
  report_retcode(_,_):-
	retract(pb_sign_superfluous),
	clear_keep_buffer,
	retract(page(First,_)),
	assert(page(First,First)),
  	assertz(keeping(outpage(0))),
	openappend(re_temp_file,re_temp_file_name),
	writedevice(re_temp_file),
	filepos(re_temp_file,FilePos,0),
	N = First + 1,
  	clear_extra_outpage(N,FilePos),
	flush_keep_buffer,
	closefile(re_temp_file),
  	!.

  report_retcode(_,_):-
	retract(page(First,_)),
	assert(page(First,First)),
  	assertz(keeping(outpage(0))),
	openappend(re_temp_file,re_temp_file_name),
	writedevice(re_temp_file),
	flush_keep_buffer,
	closefile(re_temp_file),
  	!.
  report_retcode(_,_):-write("\nSomething wrong with report Ret Code").
  
  m_name(NAME,_):- 
  	NAME = name(_),
  	!.
  m_name(_,_):-warning_message("NAME"),errorexit().

  m_header(header(PROP,script(STMTS),ATOMLIST),CCB,FLAG):-
  	m_script(STMTS,CCB),
	not(ATOMLIST = [noatomblock]),
	backup_all_properties(2,BACK_PROP),
  	m_properties(2,PROP),
	on_beginning(PROP,accessory),
	get_direction(DIR),
	get_X(X0),
	get_Y(Y0),
  	m_atomlist(ATOMLIST,CCB,[]),
	y_set(DIR,X0,Y0),
	on_exit(CCB,[],FLAG),
	x_reset(DIR),
	setup_all_properties(2,BACK_PROP),
  	!.
  m_header(_,_,_).

  m_headerlist([],_):-fail.
  m_headerlist([],_):-!.
  m_headerlist([headerproperty(HEAD,PROP,X_POS,BORD)|LIST],CCB):-!,
	setup_all_properties(2,PROP),
  	bord_setting(BORD),
  	set_X(X_POS),
  	m_header(HEAD,CCB,c_footer),
  	m_headerlist(LIST,CCB).		% after all the headers have been printed.
  m_headerlist(_,_):-errorexit().

  m_footer(footer(PROP,script(STMTS),ATOMLIST),CCB):-
	backup_all_properties(2,BACK_PROP),
  	change_second_level,
  	m_properties(2,PROP),
  	m_script(STMTS,CCB),
	on_beginning(PROP,accessory),
  	m_atomlist(ATOMLIST,CCB,[]),
	y_set(0,0.0,0),
	put_footer_mark,
	on_exit(CCB,[],c_footer),
	setup_all_properties(2,BACK_PROP),
  	!.
  m_footer(nofooter,_):-
  	y_memory(0), !.
  
  m_footer(_,_):-errorexit().
  estimate_footer(footer(PROP,_,ATOMLIST),CB):-
%	backup_all_properties(2,BACK_PROP),
  	change_second_level,
  	m_properties(2,PROP),
	on_beginning(PROP,accessory),
  	m_atomlist(ATOMLIST,CB,[]),
	y_set(0,0.0,0),
	on_exit(CB,[],c_footer),
%	m_properties(2,BACK_PROP),
  	!.
  estimate_footer(nofooter,_):-
  	y_memory(0), !.
    	
  estimate_footer(_,_):-errorexit().
  m_blocklist([],HEADER_PROP,_,CB,main):-
  	on_exit(CB,HEADER_PROP,main),
  	!.
  m_blocklist([F|REST],HEADER_PROP,PROP,CCB,RET):-
	setup_all_properties(2,PROP),
  	m_block(F,CCB,HEADER_PROP),!,
  	RET = m_blocklist(REST,HEADER_PROP,PROP,CCB).
  	
  m_blocklist(_,_,_,_,end_of_sheet).
  
  m_block(while(COND,RECT,PROP,HEADER,script(STMTS),BLOCK),CCB,HLIST):-
	get_X(X_PREV),
	m_cond(COND,CCB),
	m_properties(2,PROP),
	BOOL = retrieve_direction(PROP),
	y_reset(BOOL),
	m_rect(RECT),
	get_X(X_POS),
	backup_all_properties(2,BACK_PROP),
	insert_outer_mark(BACK_PROP,BORD),
 	m_header(HEADER,CCB,c_header),
	get_Y(Y_POS),
 	appendh(HLIST,[headerproperty(HEADER,BACK_PROP,X_POS,BORD)],TOTLIST),
	get_while_order(ORDER),
	asserta(while_data(ORDER,COND,STMTS,BLOCK,BACK_PROP,TOTLIST,CCB)),!,
	m_while(ORDER,X_POS,Y_POS,Y_Level),
	re_check_pb_occured(accessory,Y_Level,0,CCB,HLIST),
	set_base_point(BOOL,RECT,X_PREV).

  m_block(while(_,_,_,_,_,_),_,_).

  m_block(ifthen(COND,RECT,PROP,HEADER,script(STMTS),BLOCK),CCB,HLIST):-
	m_cond(COND,CCB),
	m_properties(2,PROP),
	y_reset,
	get_X(XR),get_Y(YR),rp_get_page(PAGE0),
	m_rect(RECT),
	get_X(X_POS),
 	m_header(HEADER,CCB,c_header),
	m_script(STMTS,CCB),
	on_beginning(PROP,main),
	backup_all_properties(2,BACK_PROP),
	insert_outer_mark(BACK_PROP,BORD),
 	appendh(HLIST,[headerproperty(HEADER,BACK_PROP,X_POS,BORD)],TOTLIST),
	re_clear_noninherited(CLEARED_PROP),!,
	RET = m_blocklist(BLOCK,TOTLIST,CLEARED_PROP,CCB),
	not(RET = end_of_sheet),
	re_check_pb_occured(main,YR,PAGE0,CCB,HLIST),
	set_X(XR),
	progress_cbf(PCB,_),
	PCB(progressing,250,CONT),
	clear_all_content(CONT).

  m_block(ifthen(_,_,_,_,_,_),_,_):-
	progress_cbf(PCB,_),
	PCB(progressing,250,CONT),
	clear_all_content(CONT),
	!.  
  m_block(block(RECT,PROP,HEADER,script(STMTS),BLOCK),CB,HLIST):-
	m_properties(2,PROP),
	y_reset,
	get_X(XR),get_Y(YR),rp_get_page(PAGE0),
	m_rect(RECT),
	get_X(X_POS),
 	m_header(HEADER,CB,c_header),
	m_script(STMTS,CB),
	on_beginning(PROP,main),
	backup_all_properties(2,BACK_PROP),
	insert_outer_mark(BACK_PROP,BORD),
 	appendh(HLIST,[headerproperty(HEADER,BACK_PROP,X_POS,BORD)],TOTLIST),!,
	re_clear_noninherited(CLEARED_PROP),!,
	RET = m_blocklist(BLOCK,TOTLIST,CLEARED_PROP,CB),
	not(RET = end_of_sheet),
	re_check_pb_occured(main,YR,PAGE0,CB,HLIST),
	set_X(XR),
	progress_cbf(PCB,_),
	PCB(progressing,250,CONT),
	clear_all_content(CONT).

  m_block(pagebreak,CB,HEAD):-
  	y_memory(31000),
	y_set(0,0.0,0),
	insert_pb_sign,
	retrieve_block_prop(PROP),
  	on_exit(CB,HEAD,main),
	on_beginning(PROP,main),
	!.

  m_block(atomblock(ATOMBLOCK),CCB,HEAD):-
	not(ATOMBLOCK = noatomblock),
	retractall(pb_sign_superfluous),
  	m_atom(ATOMBLOCK,CCB,HEAD),
  	!.

  m_block(atomblock(ATOMBLOCK),CCB,HEAD):-
  	m_atom(ATOMBLOCK,CCB,HEAD),
  	!.
  
  m_while(ORDER,X0,Y0,YLevel):-
	while_data(ORDER,COND,STMTS,BLOCK,PROP,HEADER,CCB),
	m_script(STMTS,CCB),
	setup_all_properties(2,PROP),
	re_extract_props_forbeginning(PROPS),
	on_beginning(PROPS,main),
	re_clear_noninherited(CLEARED_PROP),
	get_direction(DIRECTION),
	RET = m_blocklist(BLOCK,HEADER,CLEARED_PROP,CCB),
	progress_cbf(PCB,_),
	PCB(progressing,250,CONT),
	clear_all_content(CONT),
	not(RET = end_of_sheet),
	not_reached,
	m_cond(COND,CCB),
	m_while1(ORDER,DIRECTION,PROP,X0,Y0,X1,Y1),
	extract_sign,!,
	m_while(ORDER,X1,Y1,YLevel).

  m_while(ORDER,_,_,_):-
	retract(while_data(ORDER,_,_,_,PROP,_,_)),
	re_set_complexprops(PROP),
	fail.
  m_while(_,_,_,Y1):-
	retract(not_reached_yet),
	get_Y(Y1),
	!.
	
  m_while1(ORDER,DIRECTION,PROP,X0,Y0,X1,Y1):-
	y_set(DIRECTION,X0,Y0),
	get_X(X1),
	get_Y(Y1),
	insert_outer_mark(PROP,_),
	re_force_new_page(ORDER),
	!.

  m_rect(rect(LEFT,TOP,RIGHT,BOT)):-
  	rect_measured(rect(LEFT,TOP,RIGHT,BOT),NX,NY,_,_),
  	set_X(NX), set_Y(NY), y_memory(NY),
  	!.
  	
  m_rect(norect):-!.
  m_rect(_):-errorexit().
%### 		SCRIPT				###  
  m_script([],_):-fail.
  m_script([],_):-!.
  m_script([S|STMTS],CCB):-
  	m_statement(S,CCB), !,
  	m_script(STMTS,CCB).
  m_script(_,_):-errorexit().

  m_statement(assign(VAR,EXP),_):-
 	m_exp(EXP,STR),
 	conv_outparam([VAR],[STR]),!.

  m_statement(predcall(PREDNAME),CCB):-
  	m_predcall(PREDNAME,CCB),!.

  m_statement(while_st(COND,STMTS),CB):-
  	m_state_while(COND,STMTS,CB), !.
  
  m_statement(if_else_st(COND,STMTS,_),CB):-
  	m_cond(COND,CB),
  	m_script(STMTS,CB), !.
  m_statement(if_else_st(COND,_,STMTS),CB):-
  	not(m_cond(COND,CB)),
  	m_script(STMTS,CB), !.

  m_statement(if_st(COND,STMTS),CB):-
  	m_cond(COND,CB),
  	m_script(STMTS,CB), !.
  m_statement(if_st(_,_),_):- !.
  m_statement(_,_).
  
  m_state_while(COND,STMTS,CB):-
  	m_cond(COND,CB),!,
  	m_script(STMTS,CB),
  	m_state_while(COND,STMTS,CB).
  m_state_while(_,_,_).
    
  m_atomlist([A|REST],CB,HEAD):-
	change_active_prop,
  	m_atom(A,CB,HEAD),!,
  	m_atomlist(REST,CB,HEAD).
  m_atomlist(_,_,_):-fail.
  m_atomlist(_,_,_):-!.

  m_atom(text(EXPS,RECT,PROP),_CB,_HEAD):-
  	change_active_prop,
  	m_properties(3,PROP),
  	m_exps(EXPS,ELEM),
	ELEM = [S|_],
	rect_measured(RECT,L,T,R,B),
	LEFT = val(INTEGER,L),
	RCT = rct(LEFT,T,R,B),
  	print_atposition(S,RCT,depend_re),
  	!.
  m_atom(bmp_file(STRING,RECT,_),_,_HEAD):-
	m_pict(STRING,RECT).
  m_atom(line(RCT,_PR),_,_HEAD):-
	m_line(RCT).  	

  m_atom(atomblock(RECT,PROPERTIES,ATOMBLOCKLIST),CB,HEAD):-
	m_rect(RECT),  	
	m_properties(2,PROPERTIES),
	m_atomlist(ATOMBLOCKLIST,CB,HEAD),
	!.

  m_atom(noatomblock,_,_).

predicates
procedure	build_polygon(INTEGER,INTEGER,INTEGER,INTEGER,INTEGER,INTEGER,PNTLIST)
procedure	build_polyleft(INTEGER,RCT,INTEGER,INTEGER,PNTLIST)
procedure	build_polyright(INTEGER,RCT,INTEGER,INTEGER,PNTLIST)
procedure	build_reverselist(PNTLIST,PNTLIST,PNTLIST)
determ		get_page(KEEP_DBA_DOM,INTEGER,INTEGER,INTEGER)
determ		get_dbainfo(WINDOW,KEEP_DBA_DOM,INTEGER)
procedure	check_border(WINDOW)
procedure	get_dbainfo1(WINDOW,FONT,LONG,LONG,INTEGER,INTEGER)
procedure	change_current_settings(FONT,LONG,LONG,INTEGER,INTEGER)
procedure	ret_code(INTEGER,INTEGER)

clauses
  build_polygon(0,X,T,B,Dx,Dy,[pnt(X1,T1)|Out]):-
	T1 = T + Dy,
	T1 < B, !,
	X1 = X + Dx,
	build_polygon(1,X,T1,B,Dx,Dy,Out).
  build_polygon(1,X,T,B,Dx,Dy,[pnt(X,T1)|Out]):-
	T1 = T + Dy,
	T1 < B, !,
	build_polygon(0,X,T1,B,Dx,Dy,Out).
  build_polygon(_,X,_T,B,_,_,[pnt(X,B)]):- !.

  build_polyleft(1,rct(L,T,_R,B),Dx,Dy,[pnt(L,T)|List1]):-
	build_polygon(0,L,T,B,Dx,Dy,List1),
	!.
  build_polyleft(0,rct(L,T,_R,B),_Dx,_Dy,[pnt(L,T),pnt(L,B)]):- !.
  build_polyleft(_,_,_,_,[]):- errorexit().
  	
  build_polyright(1,rct(_L,T,R,B),_Dx,_Dy,[pnt(R,T)|List1]):-
	build_polygon(0,R,T,B,_Dx,_Dy,List1),
	!.
  build_polyright(0,rct(_L,T,R,B),_Dx,_Dy,[pnt(R,T),pnt(R,B)]):- !.
  build_polyright(_,_,_,_,[]):- errorexit().

  build_reverselist([],List,List):-!.
  build_reverselist([E|Rest],Inv,List):- !,
	build_reverselist(Rest,[E|Inv],List).
  build_reverselist(_,_,[]):-errorexit().
  
  get_page(outpage(0),_,main,end_of_sheet):- 
	setpage, !.
  get_page(outpage(_),_,main,main):- 
	setpage, !.
  get_page(_,_,proceed,main):-
	setpage, !.
  get_page(outpage(PAGE),PAGE,_,_):- 
  	asserta(setpage), !,
  	fail.

  get_dbainfo(WIN,out_text(RCT,STRING,ILIST),proceed):-
	TXTFLAGS = [dtext_Vcenter,dtext_NoPrefix,dtext_SingleLine,dtext_Expandtabs|ILIST],
	draw_TextInRect(WIN,RCT,STRING,-1,TXTFLAGS),
	fail.

  get_dbainfo(WIN,outline(PNT1,PNT2),proceed):-
  	draw_Line(WIN,PNT1,PNT2),
  	fail.
  	
  get_dbainfo(WIN,outrect(RCT),proceed):-  	
	re_GetPrintingStatus(Status),
	Status = 0,
  	chkprop(_,FC,_,B,_),
	check_border(WIN),
	draw_Rect(WIN,RCT),
	win_SetPen(WIN,pen(B,ps_Solid,FC)),
	fail.

  get_dbainfo(WIN,outrect(RCT),proceed):-  	
	re_GetPrintingStatus(Status),
	Status = 1,
  	chkprop(_,FC,_,Back,_),
	check_border(WIN),
	RCT = rct(L,T,R,B), RR = R - 1,
	RBT = rct(L,T,RR,B),
	draw_Rect(WIN,RBT),
	win_SetPen(WIN,pen(Back,ps_Solid,FC)),
	fail.

  get_dbainfo(WIN,outbrockenrect(RCT,L,_T,R,_B,Dx,Dy),proceed):-  	
	build_polyleft(L,RCT,Dx,Dy,List1),
	build_polyright(R,RCT,Dx,Dy,List2),
	build_reverselist(List2,[],Inv2),
	appendH(List1,Inv2,OutList),	
	draw_polygon(WIN,OutList),
	fail.
	
  get_dbainfo(WIN,outpict(FILE,PNT),proceed):-
	PICT = pict_Load(FILE),
	P_ZERO = cast(PICTURE,0),
	PICT >< P_ZERO,
	pict_Draw(WIN,PICT,PNT,rop_SrcCopy),
	pict_Destroy(PICT),
	fail.

  get_dbainfo(WIN,outprop(FONT,FOREGR_COLOR, BACKGR_COLOR,BORDER,PAT,_,_,_),proceed):-  
	get_dbainfo1(WIN,FONT,FOREGR_COLOR, BACKGR_COLOR,BORDER,PAT),
	fail.
	
  get_dbainfo(_,_,main):-
  !.

  get_dbainfo1(_,FONT,FOREGR_COLOR, BACKGR_COLOR,BORDER,PAT):-  
	chkprop(F,FC,BC,B,PAT),
	FONT = F, FOREGR_COLOR = FC,
	BACKGR_COLOR = BC,
	BORDER = B,
	!.
  get_dbainfo1(WIN,FONT,FOREGR_COLOR, BACKGR_COLOR,BORDER,PAT):-
       	win_SetFont(WIN,FONT),
	win_SetForeColor(WIN,FOREGR_COLOR),
	win_SetPen(WIN,pen(BORDER,ps_Solid,FOREGR_COLOR)), 
	win_SetBackColor(WIN,BACKGR_COLOR),
	win_SetBrush(WIN,brush(PAT,BACKGR_COLOR)),
	change_current_settings(FONT,FOREGR_COLOR, BACKGR_COLOR,BORDER,PAT),
	!.  		

  change_current_settings(_,_,_,_,_):-
  	retract(chkprop(_,_,_,_,_)),
  	fail.
  change_current_settings(FONT,FC,BC,B,PAT):-
  	assert(chkprop(FONT,FC,BC,B,PAT)),
  	!.  	

  check_border(WIN):-
  	chkprop(_FONT,FC,BC,B,_PAT),
  	B = 0,
  	not(FC = BC),
	win_SetPen(WIN,pen(1,ps_Solid,BC)),
  	!.
  check_border(WIN):-
  	chkprop(_FONT,FC,BC,B,_PAT),
  	B = 1,
  	FC = color_White,
  	BC = color_Black,
	win_SetPen(WIN,pen(1,ps_Solid,BC)),
  	!.
  check_border(_).
  	
  ret_code(end_of_sheet,Y):-
  	footers(_,YY),
  	Y = 0 - YY,
  	!.
  ret_code(_,Y):-
	footers(_,Y),
  	!.
  ret_code(_,0).
predicates
procedure	set_zero(WINDOW)
procedure	calcul_footers(REPORT,PROCESS_PRED)

clauses

   set_zero(WINDOW):-
        assert(mywin(WINDOW)),
	FONT = font_Create(ff_times,[],8),
	assert(active_prop(1,FONT,ff_times, [],8, 0.0,[],0,0,0,center,0,color_White,0,0,noclip_re,2)),
	assert(active_prop(2,FONT,ff_times, [],8, 0.0,[],0,0,0,center,0,color_White,0,0,noclip_re,2)),
	assert(active_prop(3,FONT,ff_times, [],8, 0.0,[],0,0,0,center,0,color_White,0,0,noclip_re,2)),
	assert(draw_forbidden),
	assert(page(1,1)),
	!.

   calcul_footers(report(_,PAGEPROP,_,_,_,_,FOOTER),CCB):-
	m_pageprop(PAGEPROP,T,B),
	find_out_VertRes(VRES,T,B),
        y_reset,
        estimate_footer(FOOTER,CCB),
	last_pos(POS),
	assert(footers(POS,VRES)),
	y_reset,
	!.
   calcul_footers(_,_).
/***********************************************************
		global predicates
***********************************************************/
constants
  dummy_Flags = [wsf_Invisible,wsf_Disabled,wsf_ClipSiblings,wsf_ClipChildren]

predicates
		dummy_handler 	: EHANDLER
determ  	executePrint(REPORT,PROCESS_PRED)
procedure	INTEGER displayPrint(WINDOW,INTEGER)
procedure	INTEGER display_ifclear(WINDOW,INTEGER)
procedure	re_delete_temp_file
procedure	expands_dbdelete
determ		re_temp_open_er(WINDOW,INTEGER)

clauses
  displayPrint(_,_,-1):-
	generation_canceled, !.
  
  displayPrint(WINDOW,PAGE,Y):-
	updating(DBA),
	get_page(DBA,PAGE,FLAG,LAST),
	get_dbainfo(WINDOW,DBA,FLAG),
	ret_code(LAST,Y),
	retractall(setpage),
	!.

  displayPrint(WIN,PAGE,Y):-
  	retractall(_,preview_update),
  	trap(openread(re_temp_file,re_temp_file_name),CODE,re_temp_open_er(WIN,CODE)),
  	readdevice(re_temp_file),
	re_update_buffer(PAGE),
  	closefile(re_temp_file),
	retractall(re_stream),
	Y = display_ifclear(WIN,PAGE),
	!.

  displayPrint(_,_,1).
  
  display_ifclear(WIN,PAGE,Y):-
	updating(_),
	Y = displayPrint(WIN,PAGE),
  	!.
  display_ifclear(_,_,H):-
	footers(_,H),
	!.
  display_ifclear(_,_,0).
 	
  executePrint(_,_):-
  	retractall(_,preview_update),
	re_delete_temp_file,
	expands_dbdelete,
  	fail.
  
  executePrint(REPORT,CONTROL_CALLBACK):-
db_Create(engine,"engine.dba",in_memory),
	retractall(regen_is_needed),
	progress_cbf(PCB,_),
ifdef time_consumption_check
	time(_,Mins,Secs,Milisecs),
	assert(time_fact(1,Mins,Secs,Milisecs)),
	write("\nStarting ",Mins,":",Secs,".",MiliSecs),
enddef
	PCB(starting,0,CONT),
	clear_all_content(CONT),
	trap(assert(generation_in_progress(1)),_,repeng_errhandler(reperr_47)),
	retractall(_,keep),
	retractall(_,prop),
	retractall(_,temporary),
	assert(tree(REPORT,CONTROL_CALLBACK)),
  	NULLWIN=cast(window,0),
	TMP=win_GetAttrVal(NULLWIN,attr_task_window),
	TASK_WIN=cast(window,TMP),
	win_Create(w_TopLevel,rct(0,0,100,100),"",
		   no_Menu,TASK_WIN,dummy_Flags,dummy_handler,0),
	!. 

%===	Need to be changed			====
  re_delete_temp_file:-
  	existfile(re_temp_file_name),
  	trap(deletefile(re_temp_file_name),_,fail),
	!.  
  re_delete_temp_file.

  expands_dbdelete:-
	trap(db_Close(engine),_,fail),
	trap(db_delete("engine.dba",in_memory),_,fail),
	!.

  expands_dbdelete.
  re_temp_open_er(_WIN,1101):- !.

  re_temp_open_er(_WIN,7002):-
  	re_send_invalidate(_),
  	!.
  re_temp_open_er(WIN,7002):-
  	assert(re_send_invalidate(WIN)),
  	!.
ifdef os_os2
  re_temp_open_er(_WIN,7110):-
  	re_send_invalidate(_),
  	!.
  re_temp_open_er(WIN,7110):-
  	assert(re_send_invalidate(WIN)),
  	!.
enddef
  re_temp_open_er(WIN,_):-
	trap(win_PostEvent(WIN,e_CloseRequest),_,fail),
	fail.
  re_temp_open_er(_,Error):-
	repeng_errhandler(Error).

  dummy_handler(WIN,e_Create(_),0):-
	win_PostEvent(WIN,e_User(3333,3333)),!,fail.
  dummy_handler(WIN,e_User(3333,_),0):-
	timer_Set(WIN,100),
	tree(REPORT,CONTROL_CALLBACK),
  	set_zero(WIN),
	calcul_footers(REPORT,CONTROL_CALLBACK),
	set_up,
	assertz(keeping(outpage(1))),
	m_report(REPORT,CONTROL_CALLBACK),
	progress_cbf(PCB,_),
	PCB(finish,100,_),
ifdef time_consumption_check
	time(_,M1,S1,MS1),
	assertz(time_fact(2,M1,S1,MS1)),
	write("\nFinishing ",M1,":",S1,".",MS1),
enddef
	retractall(generation_in_progress(_)),!.

  dummy_handler(_WIN,e_Timer(ID),0):-
	not(generation_in_progress(_)),!,
	timer_Kill(ID),
	win_PostEvent(_WIN,e_CloseRequest()).

/***********************************************************
                ERRORS PROCESSING predicates
***********************************************************/
ifndef no_scanner
predicates
determ  syntax_error(STRING,TOKL)
determ  expect(CURSORTOK,TOKL,TOKL)
clauses
    syntax_error("call",[t(id(STR),CURSOR)|_]):-
    	concat(re_s03,STR,M),
    	assertz(err(error_at(CURSOR,M))),!,
    	fail.
    syntax_error(PROD,[t(TOKK,CURSOR)|_]):-
	term_str(tok,TOKK,S_TOK),
	format(M,re_s04,PROD,S_TOK),
        assertz(err(error_at(CURSOR,M))),
        fail.

  expect(TOK,[TOK|L],L) :- !.
  expect(t(long(L),C),[t(int(INT),C)|LIST],LIST):-
  	str_int(STR,INT),
  	term_str(long,L,STR),
  	!.
  expect(t(call(_),C),[t(equal,C)|L],L):-!.
  expect(t(call(_),_),_,_):-!,fail.
  expect(t(else,_),_,_):-!,fail.
  	
  expect(t(TOK,_),[t(TR,CC)|_],_):-
 	bound(TOK),
        term_str(tok,TOK,STR),
        term_str(tok,TR,S_T),
	format(MM,re_s05,STR,S_T),
        assertz(err(error_at(CC,MM))),!,
        fail.
  	
  expect(T,[t(TOK,CC)|_],_):-
	not(bound(T)),!,
	term_str(tok,TOK,STR),
	concat(re_s06,STR,MSG),
	assertz(err(error_at(CC,MSG))),
	fail.
  expect(_,[],_):-
        assertz(err(error_at(0,re_s07))),!,
        fail.

enddef
