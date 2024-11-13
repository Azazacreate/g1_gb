/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S 

 FileName:	RTFCONV.PRO
 Purpose:	Report Conversion to RTFormat
 Written by:	Alexander Grachev
 Version:	1.3
 Build:		019.990201
 Tested with:	Visual Prolog v.5.1 build 563
 Comments:
******************************************************************************/
constants

re_rtfHeader1 = "{\\rtf1\\ansi \\deff4\\deflang1033{\\fonttbl{\\f1\\fscript\\fcharset0\\fprq2 System;}{\\f2\\fmodern\\fcharset0\\fprq2 Courier New;}{\\f3\\froman\\fcharset0\\fprq2 Times New Roman;}{\\f4\\fswiss\\fcharset0\\fprq2 Arial;}}"
re_rtfHeader2 = "{\\colortbl;\\red0\\green0\\blue0;\\red0\\green0\\blue255;\\red0\\green255\\blue255;\\red0\\green255\\blue0;\\red255\\green0\\blue255;\\red255\\green0\\blue0;"
re_rtfHeader3 = "\\red255\\green255\\blue0;\\red255\\green255\\blue255;\\red0\\green0\\blue128;\\red0\\green128\\blue128;\\red0\\green128\\blue0;\\red128\\green0\\blue128;\\red128\\green0\\blue0;\\red128\\green128\\blue0;\\red128\\green128\\blue128;\\red192\\green192\\blue192;}"
re_rtfHeader4 = "{\\stylesheet{\\widctlpar \\f4\\fs20 \\snext0 Normal;}{\\*\\cs10 \\additive Default Paragraph Font;}}"

re_tablerow   = "\\trbrdrt\\brdrs\\brdrw15\\brdrcf1 \\trbrdrl\\brdrs\\brdrw15\\brdrcf1 \\trbrdrb\\brdrs\\brdrw15\\brdrcf1 \\trbrdrr\\brdrs\\brdrw15\\brdrcf1 \\trbrdrh\\brdrs\\brdrw15\\brdrcf1 \\trbrdrv\\brdrs\\brdrw15\\brdrcf1"
re_tablecell  = "\\clbrdrt\\brdrs\\brdrw15\\brdrcf1 \\clbrdrl\\brdrs\\brdrw15\\brdrcf1 \\clbrdrb\\brdrs\\brdrw15\\brdrcf1 \\clbrdrr\\brdrs\\brdrw15\\brdrcf1 "
domains
  TEXTELEMENT = tabtxt(STRING,STRING)
  TEXTELEMENTLIST = TEXTELEMENT*

  RE_TXTDOM	= txtdom(INTEGER,INTEGER,INTEGER,INTEGER,STRING,RCT,INTEGER,FONTSTYLE,INTEGER)
  RE_TXTDOMLIST = RE_TXTDOM*
database - rtf_converter
determ  rt_paragraph_table
determ  set_footer
determ  rt_parlist(INTEGER,INTEGER,STRING,TEXTELEMENTLIST)
determ  rt_fontheight(INTEGER)
determ  rt_row_height(INTEGER)
determ  rt_table_offset(INTEGER)

determ  boldflag
determ  italicflag
  re_cell(RCT)
  
database - txtobjects
determ  txtprop(INTEGER,FONTSTYLE,INTEGER)
determ  current_props(INTEGER,FONTSTYLE,INTEGER)
  txtcont(RE_TXTDOM)
  txtrect(RCT)
predicates
determ   paragraph_edge2(INTEGER,RCT)
procedure  calculate_tabpos(INTEGER,STRING,STRING,STRING)
procedure  calculate_paroffset(INTEGER,INTEGER,INTEGER,STRING)
procedure  calculate_insertpar(INTEGER,INTEGER,STRING)
procedure  start_newParag(INTEGER,RCT,STRING)
procedure  table_properties(STRING)
procedure  paragraph_edge
procedure  ret_paragraph_type(INTEGER)
procedure  rt_change_row_height(INTEGER)
procedure  rt_getparagraph_height(STRING)
procedure  rt_gettable_offset(STRING)

predicates
procedure  rais_boldflag
procedure  rais_italicflag
procedure  fall_boldflag(STRING)
procedure  fall_italicflag(STRING)
procedure  convert_fontstyle(FONTSTYLE,INTEGER,INTEGER,STRING)
procedure  store_parlist(TEXTELEMENTLIST,STRING)
procedure  store_fontsize(INTEGER)
procedure  get_fontsize(INTEGER)
procedure  change_props(INTEGER,FONTSTYLE,INTEGER,STRING)

clauses
  paragraph_edge2(T,RCT):-
  	RCT = rct(_,T,_,B),
	rt_paragraph_table,
  	retract(re_Cell(RCT)),
  	ROW_HEIGHT = B - T,
  	rt_change_row_height(ROW_HEIGHT),
	!.
  paragraph_edge2(T,RCT):-
  	RCT = rct(_,T,_,B),
	assert(rt_paragraph_table),
  	retract(re_Cell(RCT)),
  	ROW_HEIGHT = B - T,
  	rt_change_row_height(ROW_HEIGHT),
	!.
  	
%===	Calculate Cells X position		===
  calculate_tabpos(_,SCELL,STRING,STR):-
	drv_metrics(_,_,Screen_HRES,_,_,_,_,_),
	re_cell(RCT),
	RCT = rct(_,_,R,_),
	CELLPOS = trunc((2.54 * R / Screen_HRES) * 567),
	format(SCELL,"%s\\cellx%",re_tablecell,CELLPOS),
	concat(STRING,"\\cell ",STR),
  	!.


%===	Calculate Horizontal Distance		===
  calculate_tabpos(0,"",STR,STR):-!.

  calculate_tabpos(L,TAB,STRING,STR):-
	drv_metrics(_,_,Screen_HRES,_,_,_,_,_),
	TBPOS = trunc((2.54 * L / Screen_HRES) * 567),
	format(TAB,"\\tx%",TBPOS),
	concat(" \\tab ",STRING,STR), !.

  calculate_tabpos(_,"",_,""):-errorexit().
%===	Calculate Vertical Distance		===
%===	Vertical Alignment in Table Row		===
  calculate_paroffset(VERX,T,OLD,Y1):-
	re_cell(_),
  	D1 = VERX - OLD,
	D1 > 0,
	drv_metrics(_,_,_,Screen_VRES,_,_,_,_),
	DELTA = trunc((2.54 * D1 / Screen_VRES) * 28.35),
	get_fontsize(PFSIZE),
	REST = val(INTEGER,(DELTA - PFSIZE)),
	calculate_insertpar(REST,PFSIZE,OFFSET),
  	D = T - VERX,
	HEIGHT = trunc((2.54 * D / Screen_VRES) * 28.35),
	VIND = HEIGHT - PFSIZE,
	TWIPS = trunc(10 * VIND),
	format(Y1,"%s\\sb%\\sa%",OFFSET,TWIPS,TWIPS),
	!.

  calculate_paroffset(_,T,OLD,Y1):-
	re_cell(_),
  	D = T - OLD,
  	D > 0,
	drv_metrics(_,_,_,Screen_VRES,_,_,_,_),
	DELTA = trunc((2.54 * D / Screen_VRES) * 28.35),
	get_fontsize(PFSIZE),
	REST = DELTA - PFSIZE,
	TWIPS = trunc(10 * REST),
	format(Y1,"\\sb%\\sa%",TWIPS,TWIPS),
	!.

  calculate_paroffset(_,T,OLD,Y1):-
  	D = T - OLD,
  	D > 0,
	drv_metrics(_,_,_,Screen_VRES,_,_,_,_),
	DELTA = trunc((2.54 * D / Screen_VRES) * 28.35),
	get_fontsize(PFSIZE),
	REST = DELTA - PFSIZE,
	REST > PFSIZE,
	TWIPS = trunc(20 * REST),
	format(Y1,"\\sb%",TWIPS),
	!.

  calculate_paroffset(_,_,_,"").
  calculate_insertpar(REST,PFSIZE,STR):-
	REST > PFSIZE,
	OFFSET = trunc(20 * REST),
	format(STR,"\\pard \\sb%\\par ",OFFSET),
	!.
	
  calculate_insertpar(_,_,"").

%===	Paragraph Beggining			===
  start_newParag(Y0,RCT,STRING):-
	RCT = rct(L,T,_,B),
	table_properties(PARAGTAB),
	calculate_tabpos(L,TAB,STRING,STR),
	calculate_paroffset(T,B,Y0,YBot),
	concat(PARAGTAB,TAB,RESTAB),
	assert(rt_parlist(T,B,YBot,[tabtxt(RESTAB,STR)])),
	!.
	
  table_properties(TBLROW):-
	re_cell(RCT),
	RCT = rct(L,_,_,_),
	drv_metrics(_,_,Screen_HRES,_,_,_,_,_),
	TLPOS = trunc((2.54 * L / Screen_HRES) * 567),
	format(TBLROW,"\\trleft% %s",TLPOS,re_tablerow),
	!.
  table_properties(""):- !.
  	
%===	Paragraph end				===
  paragraph_edge:-
	retract(rt_paragraph_table),
	write(" }\\pard \\row"), nl, !.
  paragraph_edge:-
	write("\\par \\pard"), nl.

  ret_paragraph_type(T):-
	re_cell(RCT),
	paragraph_edge2(T,RCT),
	fail.
  
  ret_paragraph_type(_):-!.

  rt_change_row_height(ROW):-
  	rt_row_height(HEIGHT),
  	ROW <= HEIGHT, !.

  rt_change_row_height(_):-
  	retract(rt_row_height(_)),
  	fail.
  rt_change_row_height(ROW):-
  	assert(rt_row_height(ROW)), !.

  rt_getparagraph_height(HEIGHT):-
  	retract(rt_row_height(H)),
	drv_metrics(_,_,_,Screen_VRES,_,_,_,_),
	TBH = trunc((2.54 * H / Screen_VRES) * 567),
	format(HEIGHT,"\\trrh-%",TBH),
	!.
  	
  rt_getparagraph_height("").

  rt_gettable_offset(OFFSET):-
	retract(rt_table_offset(TIND)),
	drv_metrics(_,_,_,Screen_VRES,_,_,_,_),
	TWP = trunc((2.54 * TIND / Screen_VRES) * 567),
	format(OFFSET," \\sb%\\par ",TWP),
	!.
  
  rt_gettable_offset("").

clauses
  rais_boldflag:-
  	boldflag, !.
  rais_boldflag:-
  	assert(boldflag), !.
  rais_italicflag:-
  	italicflag, !.
  rais_italicflag:-
  	assert(italicflag), !.
  fall_boldflag("\\b0"):-
  	retract(boldflag), !.
  fall_boldflag("").
  	
  fall_italicflag("\\i0"):-
  	retract(italicflag), !.
  fall_italicflag("").
  	
  convert_fontstyle([],0,0,STR):-
  	fall_boldflag(BOLD),
  	fall_italicflag(IT),
  	concat(BOLD,IT,STR), !.
  convert_fontstyle([],0,1,BOLD):-
  	fall_boldflag(BOLD),
	!.	
  convert_fontstyle([],1,0,IT):-
  	fall_italicflag(IT),
	!.
  	
  convert_fontstyle([],1,1,""):- !.

  convert_fontstyle([1|REST],_,IT,TEXT):-
  	rais_boldflag,
  	convert_fontstyle(REST,1,IT,PREV),
  	concat(PREV,"\\b",TEXT), !.
  convert_fontstyle([2|REST],BOLD,_,TEXT):-
	rais_italicflag,
  	convert_fontstyle(REST,BOLD,1,PREV),
  	concat(PREV,"\\i",TEXT), !.
  convert_fontstyle([_|REST],BOLD,IT,TEXT):-
  	convert_fontstyle(REST,BOLD,IT,TEXT), !.

  convert_fontstyle(_,_,_,""):-errorexit().
  
  store_parlist([],TABS):-
	current_props(FF,FONTSTYLE,FSIZE),
	rt_paragraph_table,
	rt_getparagraph_height(HEIGHT),
	rt_gettable_offset(OFFSET),
	change_props(FF,FONTSTYLE,FSIZE,FSS),
	format(TABLE_HEADER,"%s\\trowd \\trgaph108%s",OFFSET,HEIGHT),
	format(TABLE_IN,"\\intbl {%",FSS),
	write(TABLE_HEADER),
  	write(TABS),
  	write(TABLE_IN),
  	!.
  store_parlist([],TABS):-
  	write(TABS),
  	!.
  store_parlist([tabtxt(TAB,STR)|REST],TABS1):-
	concat(TAB,TABS1,ALL),
  	store_parlist(REST,ALL),
  	write(STR),
  	!.
  	
  store_parlist(_,_):- errorexit().
  
  store_fontsize(_):-
  	retract(rt_fontheight(_)),
	fail.
  store_fontsize(FSIZE):-
  	assert(rt_fontheight(FSIZE)),
  	!.
  get_fontsize(FSIZE):-
  	rt_fontheight(FSIZE), !.

  get_fontsize(0):-!.
predicates
procedure  sort_txt_list(RE_TXTDOMLIST,RE_TXTDOMLIST)
procedure  rt_insert(RE_TXTDOM,RE_TXTDOMLIST,RE_TXTDOMLIST)

procedure  process_collected_terms
procedure  send_to_process(RE_TXTDOMLIST)
procedure  retrieve_border(RCT,RCT)
procedure  insert_term_toframe(KEEP_DBA_DOM)
procedure  store_term(RE_TXTDOM)

clauses

  sort_txt_list([],[]):- !.
  sort_txt_list([X|Tail],Sorted_list):-
	sort_txt_list(Tail,Sorted_tail), !,
	rt_insert(X,Sorted_Tail,Sorted_list).
	
  sort_txt_list(_,[]):- errorexit().
  
  rt_insert(X,[Y|Sorted_list],[Y|Sorted_list1]):-
	X = txtdom(_,TX,_,_,_,_,_,_,_),
	Y = txtdom(_,TY,_,_,_,_,_,_,_),
  	TX > TY, !,
  	rt_insert(X,Sorted_list,Sorted_list1).
  rt_insert(X,[Y|Sorted_list],[Y|Sorted_list1]):-
	X = txtdom(LX,TX,_,_,_,_,_,_,_),
	Y = txtdom(LY,TY,_,_,_,_,_,_,_),
  	TX = TY,
  	LX > LY, !,
  	rt_insert(X,Sorted_list,Sorted_list1).
  rt_insert(X,Sorted_list,[X|Sorted_list]).
  

  process_collected_terms:-
  	findall(TXT,txtcont(TXT),TXTLIST),
  	not(TXTLIST = []),
  	sort_txt_list(TXTLIST,SORTED_LIST),
  	retractall(_,txtobjects),
  	send_to_process(SORTED_LIST),
	!.
	
  process_collected_terms.
  
  send_to_process([]):-
  	retract(rt_parlist(Told,_,Y1,LIST)),
	retractall(rt_row_height(_)),
	ret_paragraph_type(Told),
	store_parlist(LIST,Y1),
	paragraph_edge, !.
  send_to_process([SORTED|LIST]):-
	store_term(SORTED), !,
	send_to_process(LIST).

  send_to_process(_).
  
  retrieve_border(RCT_Text,RCT):-
	retract(txtrect(RCT)),
	RCT_Text = rct(LT,TT,RT,BT),
	RCT = rct(L,T,R,B),
	LT >= L, TT >= T,
	RT <= R, BT <= B,
	retractall(txtrect(_)),
	!.
  retrieve_border(_,rct(0,0,0,0)).

  insert_term_toframe(outpage(_)):-
	retractall(set_footer),
	process_collected_terms,
	!.
    	
  insert_term_toframe(_):-
  	set_footer, !.

  insert_term_toframe(outprop(_,_,_,_,_,FF,FONTSTYLE,FSIZE)):-
	retractall(txtprop(_,_,_)),
	assert(txtprop(FF,FONTSTYLE,FSIZE)),
	!.
	
  insert_term_toframe(out_text(RCT,STRING,_)):-
  	RCT = rct(L,T,R,B),
    	txtprop(FF,FONTSTYLE,FSIZE),
    	retrieve_border(RCT,BORD),
    	assert(txtcont(txtdom(L,T,R,B,STRING,BORD,FF,FONTSTYLE,FSIZE))),
    	!.

  insert_term_toframe(outrect(RCT)):-
  	assert(txtrect(RCT)),
  	!.
  	
  insert_term_toframe(outfooter()):-
	assert(set_footer), !.
  insert_term_toframe(_).

predicates
determ  rtcheck_term(KEEP_DBA_DOM)
determ  read_entire_text
procedure  re_convert_size(STRING)
procedure  re_convert_marg(STRING)
procedure  discover_footers
procedure  entire_text
procedure  read_temp_data
procedure  convert_props(INTEGER,FONTSTYLE,INTEGER,STRING)
procedure  store_text_rct(RCT)
procedure  convert_term(KEEP_DBA_DOM,INTEGER)
  
clauses
  re_convert_size(SIZE):-
	drv_metrics(_,_,_,_,PAPER_HEIGHT,PAPER_WIDTH,Printer_HRES,Printer_VRES),
	HEIGHT = trunc((2.54 * PAPER_HEIGHT / Printer_VRES) * 567),
	WIDTH =  trunc((2.54 * PAPER_WIDTH / Printer_HRES) * 567),
	format(SIZE,"\\paperw%\\paperh%",WIDTH,HEIGHT),
	!.

  re_convert_size(""):-errorexit().
  
  re_convert_marg(MARG):-
  	margins(L,T,R,B),
  	LI = trunc(L * 567),
  	TI = trunc(T * 567),
  	RI = trunc(R * 567),
  	BI = trunc(B * 567),
  	format(MARG,"\\margl%\\margt%\\margr%\\margb% \\pard\\plain ",LI,TI,RI,BI),
  	!.
  	
  re_convert_marg(""):-errorexit().
  
  rtcheck_term(outfooter()):-
  	assert(set_footer), !,
	write("\\ftnbj\\aenddoc\\fet0\\sectd \\footery1440 {\\footer \\pard\\plain "),
  	fail.
  	
  rtcheck_term(outpage(N)):-
	not(N = 1),
  	retract(rt_parlist(_,_,Y1,LIST)),
	store_parlist(LIST,Y1),
  	write("\\par }"),
	retractall(set_footer),
	!.
	
  rtcheck_term(outpage(N)):-
	not(N = 1),
	retractall(set_footer),
	!.
  rtcheck_term(TERM):-
	set_footer,
	convert_term(TERM,c_footer), !,
	fail.
  
  discover_footers:-
  	openread(re_temp_file,re_temp_file_name),
  	readdevice(re_temp_file),
  	re1_repeat,
  	readln(TERMSTRING),
  	term_str(KEEP_DBA_DOM,TERM,TERMSTRING),
	rtcheck_term(TERM),
	!.
  discover_footers.

  entire_text:-
	filepos(re_temp_file,0,0),
  	read_entire_text,
  	write("}"),
  	closefile(re_temp_file), !.
  
  entire_text:-errorexit().
  
  read_entire_text:-
  	re1_repeat,
  	read_temp_data,
  	eof(re_temp_file),
  	!.

  read_temp_data:-
  	readln(TERMSTRING),
  	term_str(KEEP_DBA_DOM,TERM,TERMSTRING),
  	insert_term_toframe(TERM),
  	!.

  read_temp_data.

  convert_props(FF,FONTSTYLE,FSIZE,""):-
	current_props(FF,FONTSTYLE,FSIZE), !.
  convert_props(FF,FONTSTYLE,FSIZE,FSS):-
  	retractall(current_props(_,_,_)),
	change_props(FF,FONTSTYLE,FSIZE,FSS),
	assert(current_props(FF,FONTSTYLE,FSIZE)),
	!.
  	
  change_props(FF,FONTSTYLE,FSIZE,FSS):-
	format(FFS,"\\f%",FF),
	convert_fontstyle(FONTSTYLE,0,0,FS),
	FMS = 2 * FSIZE,
%removed blanc 10.12.97
	format(FSS,"%s%s\\fs% ",FFS,FS,FMS),
	store_fontsize(FSIZE),
	!.

  store_text_rct(rct(0,0,0,0)):-!.
  store_text_rct(RCT):-
  	asserta(re_cell(RCT)), !.

%=================================================================================
%	Write Texts, Properties Objects to RTF
%=================================================================================
%---	The same Paragraph				---
  store_term(txtdom(L,T,_R,_B,STRING,BORD,FF,FONTSTYLE,FSIZE)):-
  	rt_parlist(T,Y0,Y1,LIST),
	retract(rt_parlist(_,_,_,LIST)),
	convert_props(FF,FONTSTYLE,FSIZE,STRPROP),
	store_text_rct(BORD),
	calculate_tabpos(L,TAB,STRING,STR),
	concat(STRPROP,STR,RES_STR),
	assert(rt_parlist(T,Y0,Y1,[tabtxt(TAB,RES_STR)|LIST])),
	!.
%---	The Old Paragraph is over, The New is started	---
  store_term(txtdom(L,T,R,B,STRING,BORD,FF,FONTSTYLE,FSIZE)):-
  	retract(rt_parlist(Told,Y0,Y1,LIST)),
	retractall(rt_row_height(_)),
	ret_paragraph_type(Told),
	store_parlist(LIST,Y1),
	paragraph_edge,
	convert_props(FF,FONTSTYLE,FSIZE,STRPROP),
	concat(STRPROP,STRING,RES_STR),
	store_text_rct(BORD),
	start_newParag(Y0,rct(L,T,R,B),RES_STR),
	!.

%---	The New Paragraph				---
  store_term(txtdom(L,T,R,B,STRING,BORD,FF,FONTSTYLE,FSIZE)):-
	convert_props(FF,FONTSTYLE,FSIZE,STRPROP),
	concat(STRPROP,STRING,RES_STR),
	store_text_rct(BORD),
	start_newParag(0,rct(L,T,R,B),RES_STR),
	!.

%=================================================================================
%			F O O T E R 
%	Write Texts, Properties Objects to RTF
%=================================================================================
%---	The same Paragraph				---
  convert_term(out_text(RCT,STRING,_),_):-
  	RCT = rct(L,T,_,_),
  	rt_parlist(T,Y0,Y1,LIST),
	retract(rt_parlist(_,_,_,LIST)),
	calculate_tabpos(L,TAB,STRING,STR),
	assert(rt_parlist(T,Y0,Y1,[tabtxt(TAB,STR)|LIST])),
	!.
%---	The Old Paragraph is over, The New is started	---
  convert_term(out_text(RCT,STRING,_),_):-
  	retract(rt_parlist(T,Y0,Y1,LIST)),
	retractall(rt_row_height(_)),
	ret_paragraph_type(T),
	store_parlist(LIST,Y1),
	paragraph_edge,
	start_newParag(Y0,RCT,STRING),
	!.

%---	The New Paragraph				---
  convert_term(out_text(RCT,STRING,_),c_footer):-
	RCT = rct(_,_,_,B),
	start_newParag(B,RCT,STRING),
	!.

  convert_term(outrect(RCT),_):-
  	asserta(re_cell(RCT)), !.
  
  convert_term(outprop(_,_,_,_,_,FF,FONTSTYLE,FSIZE),_):-
  	retract(rt_parlist(T,Y0,Y1,LIST)),
	format(FFS,"\\f%",FF),
	convert_fontstyle(FONTSTYLE,0,0,FS),
	FMS = 2 * FSIZE,
	format(FSS,"%s%s\\fs% ",FFS,FS,FMS),
	assert(rt_parlist(T,Y0,Y1,[tabtxt("",FSS)|LIST])),
	store_fontsize(FSIZE),
	!.
  	
  	
  convert_term(outprop(_,_,_,_,_,FF,FONTSTYLE,FSIZE),_):-
	format(FFS,"\\f%",FF),
	convert_fontstyle(FONTSTYLE,0,0,FS),
	FMS = 2 * FSIZE,
	format(FSS,"%s%s\\fs% ",FFS,FS,FMS),
	store_fontsize(FSIZE),
	write(FSS), !.
		
  convert_term(_,_).


predicates
procedure  re_RTFConvert(STRING)


clauses
  re_RTFConvert(STR):-
	re_convert_size(SIZE),
  	re_convert_marg(MARG),
  	openwrite(re_rtffile,STR),
  	writedevice(re_rtffile),
  	write(re_rtfHeader1,re_rtfHeader2,re_rtfHeader3,re_rtfHeader4),
	write(SIZE),
	write(MARG),
	discover_footers,
	entire_text,
  	closefile(re_rtffile), !.
  	
