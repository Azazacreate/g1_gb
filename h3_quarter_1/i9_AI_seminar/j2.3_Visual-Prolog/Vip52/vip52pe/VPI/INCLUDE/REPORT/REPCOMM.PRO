/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S 

 FileName:	ENGINE0.PRO
 Purpose:	
 Written by:	Alexander Grachev
 Version:	1.3
 Build:		019.990201
 Tested with:	Visual Prolog v.5.1 build 563
 Comments:
*****************************************************************************/
constants
  main 		=	1
  accessory 	=	2
  end_of_sheet 	=	3
  proceed 	=	4
  c_header 	=	5
  c_footer 	=	6
  noclip_re	=	9
  clip_re  	=	10
  depend_re	=	11
  wrap_re  	=	12
  re_root_page	= 	13
  re_side_page	= 	14

domains
  ERR_IDENT	  = no_errors();
 		    error_at(INTEGER,STRING)
  CURSORTOK       = t(TOK,CURSOR)
  TOKL            = CURSORTOK*
  REP_BORDER_TYPE = re_border(INTEGER);
  		    re_roundrect(INTEGER,INTEGER);
  		    re_ellipse();
  		    re_brockenrect(INTEGER,INTEGER,INTEGER,INTEGER,INTEGER,INTEGER)
  		    
  REP_TEXTOBJECT  = reptxt(STRING);
  		    repround(STRING,INTEGER,INTEGER);
  		    repellipse(STRING);
  		    repbrockenrect(STRING,INTEGER,INTEGER,INTEGER,INTEGER,INTEGER,INTEGER)
  		    
  KEEP_DBA_DOM    = out_text(RCT,STRING,ILIST);
  		    outline(PNT,PNT);
  		    outrect(RCT);
  		    outroundrect(RCT,INTEGER,INTEGER);
  		    outellipse(RCT);
  		    outbrockenrect(RCT,INTEGER,INTEGER,INTEGER,INTEGER,INTEGER,INTEGER);
  		    outpict(STRING,PNT);
  		    outpage(INTEGER);
  		    endpage(INTEGER);
  		    outfooter();
  		    outprop(FONT,LONG,LONG,INTEGER,INTEGER,INTEGER,FONTSTYLE,INTEGER) 
  OUT_PARAM	  = param(RCT,REP_BORDER_TYPE,STRING,ILIST,LONG,LONG,INTEGER,INTEGER,INTEGER,FONTSTYLE,INTEGER)
%			in_rct bord    -----text-----		|indentation| ------- font ------
  OUTPARAMLIST	  = OUT_PARAM*  		    
  
  THICKBORD	  = doublebord;
  		    singlebord;
  		    nobord
  HEADER_WITHP	  = headerproperty(HEADER,LEVEL_PROPERTIES,REAL,THICKBORD)
  HEADER_WITHP_LIST	= HEADER_WITHP*
  
  LEVEL_PROPERTIES  = level_properties(FONT,INTEGER,FONTSTYLE,INTEGER,REAL,ILIST,INTEGER,INTEGER,
	INTEGER,ALIGNMENT_VAL,LONG,LONG,INTEGER,INTEGER,INTEGER,UNSIGNED);
		      no_level_properties

database - paper
determ  re_send_invalidate(WINDOW)
determ	drv_metrics(LONG,LONG,LONG,LONG,LONG,LONG,LONG,LONG)
determ	margins(REAL,REAL,REAL,REAL)
determ	generation_in_progress(LONG)
determ	progress_cbf(PROGRESS_PRED,ILIST)
determ	convert_rtf(STRING)

ifdef time_consuption_check
	time_fact(INTEGER,INTEGER,INTEGER,INTEGER)
	time_spentCB(INTEGER,INTEGER,INTEGER)
enddef
database - prop
%             level  font  family   style   size      x0   tabs	defaulttabs  y0
 active_prop(INTEGER,FONT,INTEGER,FONTSTYLE,INTEGER,REAL,ILIST,INTEGER,INTEGER,

% border   align  	fore_color  back_color  l - t indent    clip	complex
  INTEGER, ALIGNMENT_VAL,  LONG,      LONG,   INTEGER,INTEGER, INTEGER,UNSIGNED)
% complex Properties: xx NewPage recurrent   expandable outer keep direction	***

determ	mywin(WINDOW)
determ	tree(REPORT,PROCESS_PRED)
determ  re_current_font(FONT)
determ	draw_forbidden
determ  pb_sign
determ  pb_sign_superfluous
determ	generation_canceled
determ	left_corner(INTEGER)
determ	last_pos(INTEGER)
determ  re_maxwrap(INTEGER)
determ	last_X(REAL)
determ  not_reached_yet
determ	footers(INTEGER,INTEGER)
determ	outer_right_bottom(INTEGER,INTEGER)
determ  composite_page(INTEGER,INTEGER)
determ  recalculation_delta(INTEGER)
	while_data(INTEGER,COND,STMTS,BLOCKLIST,LEVEL_PROPERTIES,HEADER_WITHP_LIST,PROCESS_PRED)

	right_corner(INTEGER)
	convert_hor(REAL)
	convert_ver(REAL)
	page(INTEGER,INTEGER)
	err(err_ident)
	variable(STRING,STRING)
	outer_left_top(INTEGER,INTEGER)
	page_right_expansion(INTEGER,INTEGER)
	obj_right_expansion(REF,INTEGER)	
	
database - keep
determ  regen_is_needed
determ	re_stream
        writeprop(STRING,FONT,LONG,LONG,INTEGER,INTEGER,INTEGER,FONTSTYLE,INTEGER)
	keeping(KEEP_DBA_DOM)

database - preview_update
determ	setpage
determ  chkprop(FONT,LONG,LONG,INTEGER,INTEGER)
	updating(KEEP_DBA_DOM)

database - temporary
determ  blocks_mosttop(INTEGER)
determ  blocks_mostbottom(INTEGER)
	active_block(INTEGER)
%		Block	Keep	Outer	Direction Type	RightPos Parent
	a_block(INTEGER,INTEGER,INTEGER,INTEGER,INTEGER,INTEGER,INTEGER)
	block(INTEGER,OUT_PARAM,FONT)
determ	the_most_top(INTEGER)
determ	the_most_left(INTEGER)
determ	the_most_bottom(INTEGER)
determ	the_most_right(INTEGER)
determ  the_last_succeded(INTEGER)
determ  listx_outers(ILIST,ILIST)

predicates
procedure	x_memory(REAL)
procedure	x_reset(INTEGER)
procedure	set_X(REAL)
procedure	y_memory(INTEGER)
procedure	y_reset
procedure	y_reset(INTEGER)
procedure	y_set(INTEGER,REAL,INTEGER)
procedure	y_store(INTEGER)
procedure	set_Y(INTEGER)

clauses
  x_memory(X):-
  	last_X(Z),
  	Z > X, !.
  x_memory(_):-
  	retract(last_x(_)),
  	fail.
  x_memory(RIGHT):-
  	assert(last_x(RIGHT)),
  	!.	

  x_reset(0):-
  	retractall(last_X(_)),!.
  x_reset(_).

  set_X(X):-
      retract(active_prop(3,FONT,FF,STYLE,SIZE,_X,TABS,DT,Y,BORDER,ALIGNMENT,
              NEW_FOREGR_COLOR, BACKGR_COLOR,LIND,TIND,CLIP,COMPL)),
      assert(active_prop(3,FONT,FF,STYLE,SIZE,X,TABS,DT,Y,BORDER,ALIGNMENT,
              NEW_FOREGR_COLOR, BACKGR_COLOR,LIND,TIND,CLIP,COMPL)),
      !.
  set_X(_).
  y_memory(Y):-
  	last_pos(Z),
  	Z > Y,!.
  y_memory(_):-
  	retract(last_pos(_)),
  	fail.
  y_memory(BOT):-
  	assert(last_pos(BOT)),
  	!.	

  y_reset:-
  	retract(re_maxwrap(_)),
  	fail.
  y_reset:-
  	retract(last_pos(_)),
  	fail.
  y_reset:-
  	retract(last_x(_)),
  	fail.
  y_reset:-
  	y_memory(0),
	assert(last_x(0.0)),
  	!.  
  y_reset(0):-y_reset, !.
  y_reset(_).
  
  y_set(0,X,_):-
  	last_pos(Y),
  	set_Y(Y),
  	set_X(X),
	x_memory(X),
  	!.
  y_set(1,_,Y0):-
  	last_X(X),
  	set_X(X),
  	set_Y(Y0),
  	y_memory(Y0),
  	!.
  y_set(_,_,_).
  
  y_store(Y):-
  	Y >= 31000, !.
  y_store(Y):-
  	set_Y(Y).
  set_Y(Y):-
      retract(active_prop(3,FONT,FF,STYLE,SIZE,X,TABS,DT,_Y,BORDER,ALIGNMENT,
              NEW_FOREGR_COLOR, BACKGR_COLOR,LIND,TIND,CLIP,COMPL)),
      assert(active_prop(3,FONT,FF,STYLE,SIZE,X,TABS,DT,Y,BORDER,ALIGNMENT,
              NEW_FOREGR_COLOR, BACKGR_COLOR,LIND,TIND,CLIP,COMPL)),
      !.
  set_Y(_).
  	
predicates
procedure	get_X(REAL)
procedure	get_Y(INTEGER)
procedure	get_border(INTEGER)
procedure	set_border(INTEGER)
procedure	rp_get_page(INTEGER)
procedure	find_out_VertRes(INTEGER,REAL,REAL)
procedure	find_Out_HorRes(INTEGER)

clauses
    get_X(X):-
      active_prop(3,_FONT,_FF,_STYLE,_SIZE,X,_TABS,_DT,_Y,_BORDER,_ALIGNMENT,
              _NEW_FOREGR_COLOR, _BACKGR_COLOR,_,_,_,_),
      !.
    get_X(0.0).
    get_Y(Y):-
      active_prop(3,_FONT,_FF,_STYLE,_SIZE,_X,_TABS,_DT,Y,_BORDER,_ALIGNMENT,
              _FOREGR_COLOR, _BACKGR_COLOR,_,_,_,_),
      !.
    get_Y(0).
    get_border(BORDER):-
      active_prop(3,_FONT,_FF,_STYLE,_SIZE,_X,_TABS,_DT,_Y,BORDER,_ALIGNMENT,
              _FOREGR_COLOR, _BACKGR_COLOR,_,_,_,_),
      !.
    get_border(0).
    set_border(INT):-
      retract(active_prop(3,FONT,FF,STYLE,SIZE,X,TABS,DT,Y,_BORDER,ALIGNMENT,
              FOREGR_COLOR, BACKGR_COLOR,LIND,TIND,CLIP,COMPL)),
      assert(active_prop(3,FONT,FF,STYLE,SIZE,X,TABS,DT,Y,INT,ALIGNMENT,
              FOREGR_COLOR, BACKGR_COLOR,LIND,TIND,CLIP,COMPL)),
      !.
    set_border(_).

    rp_get_page(PAGE):-
  	page(PAGE,_), !.
  
    rp_get_page(0):- errorexit().
  	
  find_out_VertRes(VRES,TOP,BOTTOM):-
	drv_metrics(_,_,_,Screen_VRES,Printer_HEIGHT,_,_,Printer_VRES),
	DELTA = trunc((TOP + BOTTOM) * Printer_VRES / 2.54),
	VRES = trunc((Printer_HEIGHT - DELTA) * Screen_VRES / Printer_VRES),
	!.
  find_out_VertRes(VRES,TOP,BOTTOM):-
  	NW = cast(WINDOW,0),
	Printer_VRES = win_GetAttrVal(NW, attr_printer_vres),
	Printer_HEIGHT = win_GetAttrVal(NW, attr_printer_height),
	Screen_VRES = win_GetAttrVal(NW, attr_screen_vres),
	DELTA = trunc((TOP + BOTTOM) * Printer_VRES / 2.54),
	VRES = trunc((Printer_HEIGHT - DELTA) * Screen_VRES / Printer_VRES),
	!.
  find_out_HorRes(HRES):-
	margins(LEFT,_,RIGHT,_),
	drv_metrics(_,_,Screen_HRES,_,_,Printer_WIDTH,Printer_HRES,_),
	DELTA = trunc((LEFT + RIGHT) * Printer_HRES / 2.54),
	HRES = trunc((Printer_WIDTH - DELTA) * Screen_HRES / Printer_HRES),
	!.
  find_out_HorRes(VRES):-
	margins(LEFT,_,RIGHT,_),
  	NW = cast(WINDOW,0),
	Printer_HRES = win_GetAttrVal(NW, attr_printer_hres),
	Printer_WIDTH = win_GetAttrVal(NW, attr_printer_width),
	Screen_HRES = win_GetAttrVal(NW, attr_screen_hres),
	DELTA = trunc((LEFT + RIGHT) * Printer_HRES / 2.54),
	VRES = trunc((Printer_WIDTH - DELTA) * Screen_HRES / Printer_HRES),
	!.
  find_out_HorRes(0).

predicates
nondeterm	re1_repeat
procedure	emax(INTEGER,INTEGER,INTEGER)
procedure	rect_measured(BLOCK_RECT,REAL,INTEGER,INTEGER,INTEGER)
clauses
  re1_repeat.
  re1_repeat:- re1_repeat.
  
  emax(I1,I2,I1):- I1>I2,!.
  emax(_,I2,I2).

  rect_measured(rect(L,T,R,B),LL,TT,RR,BB):-
  	convert_hor(K_H),
  	convert_ver(K_V),
  	get_X(X0), get_Y(Y0),
  	LL = L * K_H + X0,
  	TT = trunc(T * K_V + Y0),
  	RR = trunc(R * K_H + X0),
  	BB = trunc(B * K_V + Y0),
  	!.
  rect_measured(rect(L,T,R,B),LL,TT,RR,BB):-
  	get_X(X0), get_Y(Y0),
	LL = L + X0, TT = trunc(T + Y0),
	RR = trunc(R + X0), BB = trunc(B + Y0), !.
  rect_measured(norect,X0,Y0,XFloat,Y0):-
  	get_X(X0), get_Y(Y0),
  	XFloat = val(REAL,X0),
  	!.
  rect_measured(_,0.0,0,0,0):-errorexit().

predicates
procedure	change_page_right_expansion(INTEGER,INTEGER)
procedure	cut_right_tail(RCT,INTEGER,INTEGER)
procedure	cut_extra_tail(RCT,INTEGER,INTEGER,INTEGER)
procedure	cut_extra_tail1(RCT,INTEGER,INTEGER,INTEGER)
procedure	cut_extra_tail2(RCT,INTEGER,INTEGER,INTEGER,INTEGER)
determ		calculate_page_right_expansion(INTEGER,INTEGER,INTEGER)
procedure	INTEGER calculate_page_ext(INTEGER)
procedure	calcul_clipping(INTEGER,INTEGER,INTEGER,INTEGER)
procedure	re_store_recured_obj(OUT_PARAM,FONT,INTEGER)
procedure	re_insert_recured_obj(INTEGER)
procedure	re_insert_recured_terms(INTEGER,REF)
procedure	re_insert_recured_terms1(INTEGER,REF)
procedure	re_lookup_recuredscope(RCT,INTEGER,INTEGER)
procedure	re_lookup_recuredscope1(RCT,REF,INTEGER,INTEGER)
procedure	re_lookupscope(RCT,RCT,INTEGER,INTEGER)
procedure	re_lookup_nextref(RCT,REF,INTEGER,INTEGER)
procedure	re_check_current_font(WINDOW,FONT)
clauses
  change_page_right_expansion(Page,Exp):-
	re_insert_recured_obj(Page),
	page_right_expansion(Page,Val),
	Val >= Exp, !.
  
  change_page_right_expansion(Page,_):-
	retract(page_right_expansion(Page,_)),
	fail.
	
  change_page_right_expansion(Page,Exp):-
	assert(page_right_expansion(Page,Exp)),
	!.

  cut_right_tail(RCT,NewL,NewR):-
	RCT = rct(L,_,_,_),
	Page = calculate_page_ext(L),
	cut_extra_tail(RCT,Page,NewL,NewR),
	!.

  cut_extra_tail(RCT,Page,LastL,LastR):-
	calculate_page_right_expansion(Page,0,Ext), !,
	RCT = rct(L,T,R,B),
	NewL = L + Ext,
	NewR = R + Ext,
	RBT = rct(NewL,T,NewR,B),
	cut_extra_tail2(RBT,Page,LastL,LastR,Ext).

  cut_extra_tail(RCT,Page,NewL,NewR):-
	cut_extra_tail1(RCT,Page,NewL,NewR).

  cut_extra_tail1(rct(L,_,R,_),Page,L,R):-
  	find_Out_HorRes(Avail),
	R <= Avail * (Page + 1),
%	write(" new Left=",L," R<=Avail:",R),
	!.
	  	
  cut_extra_tail1(RCT,Page,NewL,NewR):-
	RCT = rct(L,_,R,_),
	re_lookup_recuredscope(RCT,Page,NewL),
	Delta = NewL - L,
	NewR = R + Delta,
	NewPage = Page + 1,
%write(" old Left=",L," new=",NewL," newR=",NewR," NewPage=",NewPage),
	change_page_right_expansion(NewPage,Delta).
  	
  cut_extra_tail2(rct(L,T,R,B),Page,LastL,LastR,OldExt):-
	XPage = calculate_page_ext(L),
	Page <> XPage,
%write(" XPage=",XPage),
	calculate_page_right_expansion(XPage,0,Ext), !,
	DExt = Ext - OldExt,
%write(" DExt=",DExt),
	L2 = L + DExt,
	R2 = R + DExt,
	cut_extra_tail1(rct(L2,T,R2,B),XPage,LastL,LastR).

  cut_extra_tail2(RCT,Page,L2,R2,_):-
	cut_extra_tail1(RCT,Page,L2,R2).

  calculate_page_right_expansion(Page,In,Out):-
  	page_right_expansion(Page,Exp),
  	Next = In + Exp,
	NextPage = Page - 1, !,
	calculate_page_right_expansion(NextPage,Next,Out).
	
  calculate_page_right_expansion(Page,Ext,Ext):-
  	Page < 1, !.

  calculate_page_ext(L,Page1):-
  	find_Out_HorRes(Avail),
	Mod = L mod Avail,
	Mod = 0,
	Page = L div Avail,
	Page > 0,
	Page1 = Page - 1,
	!.

  calculate_page_ext(L,Page):-
  	find_Out_HorRes(Avail),
	Page = L div Avail.

  calcul_clipping(WS,WD,WCLIPPING,noclip_re):-
  	emax(WS,WD,WCLIPPING), !.
  calcul_clipping(WS,WD,WCLIPED,depend_re):-
	active_prop(3,_,_,_,_,_,_,_,_,_,_,_,_,_,_,CLIP,_),
  	calcul_clipping(WS,WD,WCLIPED,CLIP), !.
  calcul_clipping(WS,_,WS,_):-!.

  re_store_recured_obj(param(RCT,BORDER,Str,ALIGNMENT,
FORE,BACK,LEFTM,TOPM,FF,FSTYLE,FSIZE),_,COMPL):-
  	bitand(COMPL,32,Val),
  	Val = 32, !,
	chain_insertz(engine,"recured",OUT_PARAM,param(RCT,BORDER,Str,ALIGNMENT,
FORE,BACK,LEFTM,TOPM,FF,FSTYLE,FSIZE),_).

  re_store_recured_obj(_,_,_).
  
  re_insert_recured_obj(Page):-
  	chain_first(engine,"recured",REF),
  	find_Out_HorRes(Avail),
  	Offset = Avail * Page, !,
	re_insert_recured_terms(Offset,REF).
  	
  re_insert_recured_obj(_).

  re_insert_recured_terms(Offset,REF):-
	obj_right_expansion(REF,Offset), !,
	re_insert_recured_terms1(Offset,REF).

  re_insert_recured_terms(Offset,REF):-
  	ref_term(engine,OUT_PARAM,REF,param(RCT,BORDER,Str,ALIGNMENT,
FORE,BACK,LEFTM,TOPM,FF,FSTYLE,FSIZE)),
	RCT = rct(L,T,R,B),
	NewL = L + Offset,
	NewR = R + Offset,
	RBT = rct(NewL,T,NewR,B),
	FONT = font_Create(FF,FSTYLE,FSIZE),
	active_block(LEVEL),
	assert(block(LEVEL,param(RBT,BORDER,Str,ALIGNMENT,
FORE,BACK,LEFTM,TOPM,FF,FSTYLE,FSIZE),FONT)),
	assert(obj_right_expansion(REF,Offset)), !,
	re_insert_recured_terms1(Offset,REF).
  re_insert_recured_terms(_,_).

  re_insert_recured_terms1(Offset,REF):-
	chain_Next(engine,REF,NEXT), !,
	re_insert_recured_terms(Offset,NEXT).
	
  re_insert_recured_terms1(_,_).

  re_lookup_recuredscope(RCT,Page,ResL):-
  	chain_first(engine,"recured",REF),
	re_lookup_recuredscope1(RCT,REF,0,NewL),
	NewL <> 0,
  	find_Out_HorRes(Avail), !,
	ResL = NewL + Avail * (Page + 1).

  re_lookup_recuredscope(_,Page,NewL):-
  	find_Out_HorRes(Avail),
	NewL = Avail * (Page + 1),
	!.

  re_lookup_recuredscope1(RCT,REF,OldL,ResL):-
  	ref_term(engine,OUT_PARAM,REF,TERM),
  	TERM = param(RBT,_,_,_,_,_,_,_,_,_,_),
  	re_lookupscope(RCT,RBT,OldL,NewL), !,
	re_lookup_nextref(RCT,REF,NewL,ResL).
	

  re_lookup_recuredscope1(RCT,REF,OldL,NewL):-
  	chain_next(engine,REF,NEXT), !,
	re_lookup_recuredscope1(RCT,NEXT,OldL,NewL).
  	
  re_lookup_recuredscope1(_,_,L,L).
	
  re_lookup_nextref(RCT,REF,OldL,NewL):-
  	chain_next(engine,REF,NEXT), !,
	re_lookup_recuredscope1(RCT,NEXT,OldL,NewL).
  
  re_lookup_nextref(_,_,L,L).

  re_lookupscope(rct(_,T,_,B),rct(_,Ts,Rs,_),OldL,Rs):-
  	T <= Ts,
  	B >= Ts,
  	Rs > OldL,
  	!.
  	
  re_lookupscope(rct(_,T,_,B),rct(_,_,Rs,Bs),OldL,Rs):-
  	B >= Bs,
  	T < Bs,
  	Rs > OldL,
  	!.

  re_lookupscope(rct(_,T,_,B),rct(_,Ts,Rs,Bs),OldL,Rs):-
	T < Ts,
	B > Bs,
	Rs > OldL,
	!.
  re_lookupscope(_,_,L,L).
  
  re_check_current_font(_,FONT):-
  	re_current_font(FONT), !.
  re_check_current_font(_,_):-
  	retract(re_current_font(_)),
  	fail.
  re_check_current_font(Win,FONT):-
  	assert(re_current_font(FONT)),
  	win_SetFont(Win,FONT), !.

predicates
procedure	m_calcultext(STRING,RCT,INTEGER,INTEGER,RCT)
procedure	repeng_errhandler(UNSIGNED Code)
determ		clear_all_content(BOOLEAN)

clauses
  m_calcultext("\\l",RCT,_,0,RCT):-!.
  m_calcultext(STR,RCT_SET,CLIP,HeightWithIndent,RCT):-
	active_prop(3,FONT,_,_,_,_,_,_,_,_,_,_,_,LeftM,TopM,_,_),
	mywin(WIN),
	RCT_SET = rct(LS,TS,RS,BS),
	WS = RS - LS, HS = BS - TS,
	re_check_current_font(WIN,FONT),
	trap(win_GetTextExtent(WIN, STR,-1, WD, HT),_,fail),
	WidthWithIndent = val(INTEGER,(WD + 2.3*LeftM)),
	HeightWithIndent = HT + TopM,
	calcul_clipping(WS,WidthWithIndent,WCLIPPING,CLIP),
	R = LS + WCLIPPING,
	emax(HeightWithIndent,HS,H), B = TS + H,
	cut_right_tail(rct(LS,TS,R,BS),LOUT,RR),
	RCT = rct(LOUT,TS,RR,B), !.
  m_calcultext(_,RCT,_,0,RCT).

  repeng_errhandler(Code):-
	retractall(generation_in_progress(_)),
	run_Error(Code).

  clear_all_content(b_false):-!.
  clear_all_content(b_true):-
  	generation_canceled, !,
  	fail.
  clear_all_content(b_true):-
  	assert(generation_canceled), !,
  	fail.

  	
/******************************************************************************
        global UNIVERSAL predicates
******************************************************************************/
predicates
procedure	monthtostr(INTEGER,STRING)
procedure	provtime(INTEGER,STRING,STRING)
procedure	dump

clauses
  monthtostr(1,re_m01):- !.
  monthtostr(2,re_m02):- !.
  monthtostr(3,re_m03):- !.
  monthtostr(4,re_m04):- !.
  monthtostr(5,re_m05):- !.
  monthtostr(6,re_m06):- !.
  monthtostr(7,re_m07):- !.
  monthtostr(8,re_m08):- !.
  monthtostr(9,re_m09):- !.
  monthtostr(10,re_m10):- !.
  monthtostr(11,re_m11):- !.
  monthtostr(_,re_m12).

  provtime(M,SM,SMM):-
  	M < 10,
  	concat("0",SM,SMM),
  	!.
  provtime(_,SM,SM).

  dump:-
	active_block(A),
	write("\nActive=",A),
	fail.
  dump:-
	a_block(I1,I2,I3,I4,I5,I6,I7),
	write("\nBlocks=",I1,I2,I3,I4,I5,I6,I7),
	fail. 
  dump:-
	block(Bl,OUT_PARAM,_),
	OUT_PARAM= param(RCT,BORD,STRING,_,_,_,_,_,_,_,_),
	write("\nText=",STRING,BORD,RCT," Block=",Bl),
	fail.
  dump.
	
predicates
  built_in : PROCESS_PRED

clauses
  built_in(ID,_,[SOut]) :-
        upper_lower(ID,"time"),
        time(Hours,Minutes,_Seconds,_Hundredths),
     	str_int(SH,Hours), str_int(SM,Minutes),
     	provtime(Minutes,SM,SSM),
     	concat(SH,":",S2),
     	concat(S2,SSM,SOut),
     	!.
  built_in(ID,_,[SOut]) :-
        upper_lower(ID,"date"),
     	    date(Year,Month,Day),
     	    str_int(SD,Day),
     	    monthtostr(Month,SM),
     	    concat(SD,SM,S1),
     	    str_int(SY,Year),
     	    concat(S1,SY,SOut),
     	    !.
  built_in(ID,_,[SP]) :-
        upper_lower(ID,"page"),
                page(PAGE,_),
  	   	str_int(SP,PAGE),
  	   	!.

  built_in(ID,_,[SR,SS]) :-
        upper_lower(ID,"composite_page"),
                composite_page(ROOT,SIDE),
  	   	str_int(SR,ROOT),
  	   	str_int(SS,SIDE),
  	   	!.

  built_in(ID,LIST,[]):-
  	upper_lower(ID,"message"),
  	nl,write(LIST),
  	!.
  built_in(ID,_,[]):-
  	upper_lower(ID,"print_y"),
  	get_Y(Y),
  	write(Y),
  	!.  	
  built_in(ID,_,[]):-
  	upper_lower(ID,"snap_data"),
  	dump, !.

/******************************************************************************************
|*		Realized in other files, used everywhere
*******************************************************************************************/
predicates
procedure	proc_endofsheet(process_pred,HEADER_WITHP_LIST,INTEGER)
procedure	textout(OUT_PARAM,FONT)
procedure	PNT textparam(REP_TEXTOBJECT,RCT,INTEGER)
procedure	print_line(STRING,RCT,INTEGER)
procedure	get_headers_height(PROCESS_PRED,HEADER,HEADER_WITHP_LIST,INTEGER)
procedure	m_line1(PNT,PNT)
procedure	end_of_pane
procedure	re_GetGenerationStatus(BOOLEAN)
procedure	re_GetPrintingStatus(BOOLEAN)
