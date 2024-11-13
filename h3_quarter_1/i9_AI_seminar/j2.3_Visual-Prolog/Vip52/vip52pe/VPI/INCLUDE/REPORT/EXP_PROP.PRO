/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S 

 FileName:	EXP_PROP.PRO
 Purpose:	Expressions and Properties processing
 Written by:	Alexander Grachev
 Version:	1.3
 Build:		019.990201
 Tested with:	Visual Prolog v.5.1 build 563
 Comments:
*****************************************************************************/
predicates
procedure	conv_inparam(EXPS,SLIST)
procedure	conv_outparam(VAR_OUT,SLIST)
procedure	INTEGER add_depend_ontype(STRING,STRING,INTEGER,INTEGER,STRING)
procedure	INTEGER retrieve_var_type(STRING)
procedure	expr_str(EXP,STRING)
procedure	m_exps(EXPS,SLIST)
procedure	INTEGER m_exp(EXP,STRING)
procedure	warning_message(STRING)
determ		m_cond(COND,PROCESS_PRED)
determ		m_predcall(PREDCALL,PROCESS_PRED)

clauses
/*                                                                            *
*                     EXPRESSIONS EVALUATING
*                                                                             */
  conv_inparam([FIRST|REST],[S|RS]):-
  	expr_str(FIRST,S),
  	conv_inparam(REST,RS),
  	!.
  conv_inparam([],[]):-!.

  conv_inparam(_,[]):-errorexit().
  conv_outparam([],[]):- !.
  conv_outparam([F|_],_):-
  	F = ident(STR),
  	retract(variable(STR,_)),
  	fail.
  conv_outparam([FFORM|RFORM],[OUT|R]):-
  	FFORM = ident(STR),
  	assert(variable(STR,OUT)),!,
  	conv_outparam(RFORM,R).
  conv_outparam(_,_):-
	warning_message(re_r01),
	!.

  add_depend_ontype(S1,S2,1,_,S,1):-
  	concat(S1,S2,S),!.
  add_depend_ontype(S1,S2,_,1,S,1):-
  	concat(S1,S2,S),!.
  add_depend_ontype(S1,S2,_,_,S,0):-
	trap(str_long(S1,I1),_,fail),
	trap(str_long(S2,I2),_,fail),
  	I = I1 + I2,
	trap(str_long(S,I),_,fail),
  	!.
  add_depend_ontype(S1,S2,_,_,S,0):-
  	str_real(S1,R1),
  	str_real(S2,R2),
  	R = R1 + R2,
  	str_real(S,R),
  	!.
  add_depend_ontype(_,_,_,_,"0",0).

  retrieve_var_type(S,0):-
	trap(str_long(S,_),_,fail),
  	!.
  retrieve_var_type(S,0):-
	str_real(S,_), !.
  retrieve_var_type(_,1):-!.
  
  expr_str(ident(ident(STR)),VAL):-
 	variable(STR,VAL), !.
  expr_str(ident(ident(_)),"0"):-
	draw_forbidden, !.
  expr_str(ident(ident(VAR)),"0"):-
	format(M,re_r02,VAR),
	warning_message(M),!.
%	fail.
  expr_str(cin_s(STR),STR):-!.
  expr_str(cin_i(INT),STR):-
  	str_int(STR,INT),
  	!.
  expr_str(cin_l(L),STR):-
  	term_str(long,L,STR),
  	!.
  expr_str(cin_r(R),STR):-
  	str_real(STR,R),
  	!.

  expr_str(_,""):-errorexit().
  m_exps([],[]):- !.
  m_exps([EXP|RE],[STR|RS]):-
  	m_exp(EXP,STR), !,
  	m_exps(RE,RS).
  m_exps(_,[]):- errorexit().

  m_exp(cin_s(STR),STR,1):-!.
  m_exp(cin_i(INT),S,0):-
  	str_int(S,INT),!.
  m_exp(cin_l(LONG),S,0):-
  	term_str(long,LONG,S),!.
  m_exp(cin_r(R),S,0):-
  	str_real(S,R),!.
  m_exp(ident(STR),S,TYPE):-
  	VAL = ident(STR),
  	expr_str(VAL,S),
	TYPE = retrieve_var_type(S),
  	!.
  m_exp(plus(E1,E2),S,T):-
  	T1 = m_exp(E1,S1),
  	T2 = m_exp(E2,S2),
	T = add_depend_ontype(S1,S2,T1,T2,S),
	!.

  m_exp(minus(E1,E2),S,0):-
  	m_exp(E1,S1),
  	m_exp(E2,S2),
	trap(str_long(S1,I1),_,fail),
	trap(str_long(S2,I2),_,fail),
        I = I1 - I2,
	trap(str_long(S,I),_,fail),
  	!.
  m_exp(minus(E1,E2),S,0):-
  	m_exp(E1,S1),
  	m_exp(E2,S2),
  	str_real(S1,R1),
  	str_real(S2,R2),
        R = R1 - R2,
  	str_real(S,R),
  	!.
  m_exp(mult(E1,E2),S,0):-
  	m_exp(E1,S1),
  	m_exp(E2,S2),
	trap(str_long(S1,I1),_,fail),
	trap(str_long(S2,I2),_,fail),
	I = I1 * I2,
	trap(str_long(S,I),_,fail),
	!.  	
  m_exp(mult(E1,E2),S,0):-
  	m_exp(E1,S1),
  	m_exp(E2,S2),
  	str_real(S1,R1),
  	str_real(S2,R2),
	R = R1 * R2,
	str_real(S,R),
	!.  	
  m_exp(mult(E1,E2),"0",0):-
	term_str(exp,E1,SE1),
	term_str(exp,E2,SE2),
	concat(re_r03,SE1,EE),
	concat(EE,"/",EEE),
	concat(EEE,SE2,EO), !,
	warning_message(EO).
  m_exp(div(E1,E2),S,0):-
  	m_exp(E1,S1),
  	m_exp(E2,S2),
	trap(str_long(S1,I1),_,fail),
	trap(str_long(S2,I2),_,fail),
  	I = val(INTEGER,I1/I2),
	trap(str_long(S,I),_,fail),
  	!.
  m_exp(div(E1,E2),S,0):-
  	m_exp(E1,S1),
  	m_exp(E2,S2),
  	str_real(S1,R1),
  	str_real(S2,R2),
  	R = trunc(R1/R2),
  	str_real(S,R),
  	!.
  m_exp(div(E1,E2),"0",0):-
	term_str(exp,E1,SE1),
	term_str(exp,E2,SE2),
	concat(re_r04,SE1,EE),
	concat(EE,"/",EEE),
	concat(EEE,SE2,SO), !,
	warning_message(SO).
  m_exp(_,"0",0).
  
  m_cond(eq(E1,E2),_):-
  	m_exp(E1,S1),
  	m_exp(E2,S2),
	trap(str_long(S1,I1),_,fail),
	trap(str_long(S2,I2),_,fail),
  	I1 = I2,
  	!.
  m_cond(eq(E1,E2),_):-
  	m_exp(E1,S1),
  	m_exp(E2,S2),
  	str_real(S1,R1),
  	str_real(S2,R2),
  	R1 = R2,
  	!.
  m_cond(eq(E1,E2),_):-
  	m_exp(E1,S1),
  	m_exp(E2,S2),
	S1 = S2,
	!.
  m_cond(more(E1,E2),_):-
  	m_exp(E1,S1),
  	m_exp(E2,S2),
	trap(str_long(S1,I1),_,fail),
	trap(str_long(S2,I2),_,fail),
  	I1 > I2,
  	!.
  m_cond(more(E1,E2),_):-
  	m_exp(E1,S1),
  	m_exp(E2,S2),
  	str_real(S1,R1),
  	str_real(S2,R2),
	R1 > R2,
  	!.
  m_cond(more_eq(E1,E2),_):-
  	m_exp(E1,S1),
  	m_exp(E2,S2),
	trap(str_long(S1,I1),_,fail),
	trap(str_long(S2,I2),_,fail),
  	I1 >= I2,
  	!.
  m_cond(more_eq(E1,E2),_):-
  	m_exp(E1,S1),
  	m_exp(E2,S2),
  	str_real(S1,R1),
  	str_real(S2,R2),
  	R1 >= R2,
  	!.
  	
  m_cond(less(E1,E2),_):-
  	m_exp(E1,S1),
  	m_exp(E2,S2),
	trap(str_long(S1,I1),_,fail),
	trap(str_long(S2,I2),_,fail),
  	I1 < I2,
  	!.
  m_cond(less(E1,E2),_):-
  	m_exp(E1,S1),
  	m_exp(E2,S2),
  	str_real(S1,R1),
  	str_real(S2,R2),
  	R1 < R2,
  	!.
  m_cond(less_eq(E1,E2),_):-
  	m_exp(E1,S1),
  	m_exp(E2,S2),
	trap(str_long(S1,I1),_,fail),
	trap(str_long(S2,I2),_,fail),
  	I1 <= I2,
  	!.
  m_cond(less_eq(E1,E2),_):-
  	m_exp(E1,S1),
  	m_exp(E2,S2),
  	str_real(S1,R1),
  	str_real(S2,R2),
	R1 <= R2,
  	!.
  m_cond(not_eq(E1,E2),_):-
  	m_exp(E1,S1),
  	m_exp(E2,S2),
  	S1 >< S2,
  	!.
  m_cond(or_(C1,_),CB):-
  	m_cond(C1,CB), !.
  m_cond(or_(_,C2),CB):-
  	m_cond(C2,CB), !.
  m_cond(xor_(C1,C2),CB):-
  	m_cond(C1,CB),
  	not(m_cond(C2,CB)), !.
  m_cond(xor_(C1,C2),CB):-
  	m_cond(C2,CB),
  	not(m_cond(C1,CB)), !.
  m_cond(and_(C1,C2),CB):-
  	m_cond(C1,CB),
  	m_cond(C2,CB), !.
  m_cond(not_(C),CB):-
  	not(m_cond(C,CB)), !.  
  m_cond(predcall(PREDNAME),CCB):-!,
  	m_predcall(PREDNAME,CCB).

  m_predcall(predcall(PREDNAME,EXPS,outparam(VARLIST)),CCB):-
  	conv_inparam(EXPS,IN),
%	************************
%	CallBack Function Timing
%	************************
ifdef time_consumption_check
	time(_,M1,S1,MS1),
	assertz(time_fact(3,M1,S1,MS1)),
  	CCB(PREDNAME,IN,OUT),!,
	time(_,M2,S2,MS2),
	assertz(time_fact(4,M2,S2,MS2)),
elsedef
  	CCB(PREDNAME,IN,OUT),!,
enddef
  	conv_outparam(VARLIST,OUT).

  m_predcall(predcall(PREDNAME,EXPS,outparam(VARLIST)),_):-
  	conv_inparam(EXPS,IN),
  	built_in(PREDNAME,IN,OUT),
  	conv_outparam(VARLIST,OUT),
  	!.

  m_predcall(predcall(PREDNAME,EXPS,noout),CCB):-
  	conv_inparam(EXPS,IN),
ifdef time_consumption_check
	time(_,M1,S1,MS1),
	assertz(time_fact(3,M1,S1,MS1)),
  	CCB(PREDNAME,IN,OUT),!,
	time(_,M2,S2,MS2),
	assertz(time_fact(4,M2,S2,MS2)),
elsedef
  	CCB(PREDNAME,IN,OUT),!,
enddef
  	OUT = [].

  m_predcall(predcall(PREDNAME,EXPS,noout),_):-
  	conv_inparam(EXPS,IN),
  	built_in(PREDNAME,IN,OUT),
  	OUT = [], !.


ifdef warning_level
  warning_message(STR):-
  	write(STR).
elsedef
  warning_message(_).
enddef
domains
	FONTDOM = str(STRING);
		  font(FONT)
predicates
procedure	table_font(STRING,FONTFAMILY)
procedure	change_fam(FONTDOM, FONTSTYLE, INTEGER, FONT)
procedure	table_style(STRING,FONTSTYLE)
procedure	calculate_leftindentation(REAL,INTEGER)
procedure	calculate_topindentation(REAL,INTEGER)

clauses
  table_font("fixed",ff_Fixed):-!.
  table_font("times",ff_Times):-!.
  table_font("helvetica",ff_Helvetica):-!.
  table_font("system",ff_System):-!.
  table_font(_,ff_System).
  change_fam(str(FFAMILY), STYLE, SIZE, NEWFONT):-
        upper_lower(FFAMILY,INDX),
        table_font(INDX,FF),
        NEWFONT = font_Create(FF, STYLE, SIZE),
        !.
  change_fam(str(_), STYLE, SIZE, FONT):-
        FONT = font_Create(ff_System, STYLE, SIZE),
        !.
  change_fam(font(FONT), STYLE, SIZE, NEWFONT):-
        NEWFONT = font_SetAttrs(FONT,STYLE,SIZE),
       	!.
  change_fam(_,_,_,NEWFONT):-
  	NEWFONT = cast(FONT,0),
  	errorexit().

  table_style("bold",[fs_bold]):-!.
  table_style("italic",[fs_italic]):-!.
  table_style("bold_italic",[fs_bold,fs_italic]):-!.
  table_style(_,[]).
  
  calculate_leftindentation(LIND,LEFTM):-
  	convert_hor(K_H),
  	LEFTM = trunc(LIND * K_H),
  	!.
  calculate_leftindentation(LIND,LEFTM):-
	LEFTM = trunc(LIND).

  calculate_topindentation(TIND,TOPM):-
  	convert_ver(K_V),
  	TOPM = trunc(TIND * K_V),
  	!.
  calculate_topindentation(TIND,TOPM):-
	TOPM = trunc(TIND).

predicates
procedure	m_properties(INTEGER,PROPERTIES)
procedure	m_property(INTEGER,PROPERTY)
clauses
/*************************************************************************************
---------------------- PROPERTIES  SET UP --------------------------------------------
*************************************************************************************/
  m_properties(_LEVEL,[]):-!.
  m_properties(LEVEL,[PROP|PROPERTIES]) :-
      m_property(LEVEL,PROP), !,
      m_properties(LEVEL,PROPERTIES).
  m_properties(_,_):-errorexit().

  m_property(LEVEL,fonttype(fontname(FFAMILY))) :-
      retract(active_prop(LEVEL,_FONT,_,STYLE,SIZE,X,TABS,DT,Y,BORDER,ALIGNMENT,
              FOREGR_COLOR, BACKGR_COLOR,LIND,TIND,CLIP,COMPL)), !,
      change_fam(str(FFAMILY), STYLE, SIZE, NEWFONT),
      upper_lower(FFAMILY,INDX),
      table_font(INDX,FF),
      assert(active_prop(LEVEL,NEWFONT,FF,STYLE,SIZE,X,TABS,DT,Y,BORDER,ALIGNMENT,
              FOREGR_COLOR, BACKGR_COLOR,LIND,TIND,CLIP,COMPL)),
               !.

  m_property(LEVEL,fonttype(fontstyle(NEW))) :-
      retract(active_prop(LEVEL,FONT,FF,_STYLE,SIZE,X,TABS,DT,Y,BORDER,ALIGNMENT,
              FOREGR_COLOR, BACKGR_COLOR,LIND,TIND,CLIP,COMPL)), !,
      change_fam(font(FONT), NEW, SIZE, NEWFONT),
      assert(active_prop(LEVEL,NEWFONT,FF,NEW,SIZE,X,TABS,DT,Y,BORDER,ALIGNMENT,
              FOREGR_COLOR, BACKGR_COLOR,LIND,TIND,CLIP,COMPL)),
               !.

  m_property(LEVEL,fonttype(fontsize(NEW_SIZE))) :-
      retract(active_prop(LEVEL,FONT,FF,STYLE,_SIZE,X,TABS,DT,Y,BORDER,ALIGNMENT,
              FOREGR_COLOR, BACKGR_COLOR,LIND,TIND,CLIP,COMPL)), !,
      change_fam(font(FONT), STYLE, NEW_SIZE, NEWFONT),
      assert(active_prop(LEVEL,NEWFONT,FF,STYLE,NEW_SIZE,X,TABS,DT,Y,BORDER,ALIGNMENT,
              FOREGR_COLOR, BACKGR_COLOR,LIND,TIND,CLIP,COMPL)),
               !.

  m_property(LEVEL,fonttype(fontstruct(FONT))) :-
      retract(active_prop(LEVEL,_,FF,STYLE,SIZE,X,TABS,DT,Y,BORDER,ALIGNMENT,
              FOREGR_COLOR, BACKGR_COLOR,LIND,TIND,CLIP,COMPL)), !,
      assert(active_prop(LEVEL,FONT,FF,STYLE,SIZE,X,TABS,DT,Y,BORDER,ALIGNMENT,
              FOREGR_COLOR, BACKGR_COLOR,LIND,TIND,CLIP,COMPL)),
               !.

  m_property(LEVEL,border(NEW_BORDER)) :-
      retract(active_prop(LEVEL,FONT,FF,STYLE,SIZE,X,TABS,DT,Y,_BORDER,ALIGNMENT,
              FOREGR_COLOR, BACKGR_COLOR,LIND,TIND,CLIP,COMPL)), !,
      assert(active_prop(LEVEL,FONT,FF,STYLE,SIZE,X,TABS,DT,Y,NEW_BORDER,ALIGNMENT,
              FOREGR_COLOR, BACKGR_COLOR,LIND,TIND,CLIP,COMPL)),
               !.
  m_property(LEVEL,tabs(TABS)) :-
      retract(active_prop(LEVEL,FONT,FF,STYLE,SIZE,X,_,DT,Y,BORDER,ALIGNMENT,
              FOREGR_COLOR, BACKGR_COLOR,LIND,TIND,CLIP,COMPL)),
      assert(active_prop(LEVEL,FONT,FF,STYLE,SIZE,X,TABS,DT,Y,BORDER,ALIGNMENT,
              FOREGR_COLOR,BACKGR_COLOR,LIND,TIND,CLIP,COMPL)),
               !.
  m_property(LEVEL,defaulttabs(EXP)) :-
	m_exp(EXP,DEFAULT),
	str_int(DEFAULT,TAB),
      retract(active_prop(LEVEL,FONT,FF,STYLE,SIZE,X,T,_,Y,BORDER,ALIGNMENT,
              FOREGR_COLOR, BACKGR_COLOR,LIND,TIND,CLIP,COMPL)),
      assert(active_prop(LEVEL,FONT,FF,STYLE,SIZE,X,T,TAB,Y,BORDER,ALIGNMENT,
              FOREGR_COLOR,BACKGR_COLOR,LIND,TIND,CLIP,COMPL)),
               !.
  m_property(LEVEL,alignment(NEW_ALIGNMENT)) :-
      retract(active_prop(LEVEL,FONT,FF,STYLE,SIZE,X,TABS,DT,Y,BORDER,_ALIGNMENT,
              FOREGR_COLOR, BACKGR_COLOR,LIND,TIND,CLIP,COMPL)), !,
      assert(active_prop(LEVEL,FONT,FF,STYLE,SIZE,X,TABS,DT,Y,BORDER,NEW_ALIGNMENT,
              FOREGR_COLOR, BACKGR_COLOR,LIND,TIND,CLIP,COMPL)),
               !.
  m_property(LEVEL,forecolor(NEW_FOREGR_COLOR)) :-
      retract(active_prop(LEVEL,FONT,FF,STYLE,SIZE,X,TABS,DT,Y,BORDER,ALIGNMENT,
              _FOREGR_COLOR, BACKGR_COLOR,LIND,TIND,CLIP,COMPL)), !,
      assert(active_prop(LEVEL,FONT,FF,STYLE,SIZE,X,TABS,DT,Y,BORDER,ALIGNMENT,
              NEW_FOREGR_COLOR, BACKGR_COLOR,LIND,TIND,CLIP,COMPL)),
               !.
  m_property(LEVEL,backcolor(NEW_BACKGR_COLOR)) :-
      retract(active_prop(LEVEL,FONT,FF,STYLE,SIZE,X,TABS,DT,Y,BORDER,ALIGNMENT,
              FOREGR_COLOR, _BACKGR_COLOR,LIND,TIND,CLIP,COMPL)), !,
      assert(active_prop(LEVEL,FONT,FF,STYLE,SIZE,X,TABS,DT,Y,BORDER,ALIGNMENT,
              FOREGR_COLOR, NEW_BACKGR_COLOR,LIND,TIND,CLIP,COMPL)),
               !.

  m_property(LEVEL,var_forecolor(EXP)):-
	m_exp(EXP,SR),
	trap(term_str(long,FC,SR),_,fail),
	retract(active_prop(LEVEL,FONT,FF,STYLE,SIZE,X,TABS,DT,Y,BORDER,ALIGNMENT,
              _FOREGR_COLOR, BACKGR_COLOR,LIND,TIND,CLIP,COMPL)),
	assert(active_prop(LEVEL,FONT,FF,STYLE,SIZE,X,TABS,DT,Y,BORDER,ALIGNMENT,
              FC, BACKGR_COLOR,LIND,TIND,CLIP,COMPL)), !.
  m_property(_,var_forecolor(EXP)):-
	term_str(exp,EXP,S),
	format(A2,re_r05,S),
	warning_message(A2), !.
  m_property(LEVEL,var_backcolor(EXP)):-
	m_exp(EXP,SR),
	trap(term_str(long,BC,SR),_,fail),
	retract(active_prop(LEVEL,FONT,FF,STYLE,SIZE,X,TABS,DT,Y,BORDER,ALIGNMENT,
              FOREGR_COLOR, _COLOR,LIND,TIND,CLIP,COMPL)),
	assert(active_prop(LEVEL,FONT,FF,STYLE,SIZE,X,TABS,DT,Y,BORDER,ALIGNMENT,
              FOREGR_COLOR, BC,LIND,TIND,CLIP,COMPL)), !.
  m_property(_,var_backcolor(EXP)):-
	term_str(exp,EXP,S),
	format(A2,re_r06,S),
	warning_message(A2), !.
  m_property(LEVEL,var_border(EXP)):-
	m_exp(EXP,SR),
	trap(str_int(SR,BT),_,fail),
	retract(active_prop(LEVEL,FONT,FF,STYLE,SIZE,X,TABS,DT,Y,_BORDER,ALIGNMENT,
              FOREGR_COLOR, BACK_COLOR,LIND,TIND,CLIP,COMPL)),
	assert(active_prop(LEVEL,FONT,FF,STYLE,SIZE,X,TABS,DT,Y,BT,ALIGNMENT,
              FOREGR_COLOR, BACK_COLOR,LIND,TIND,CLIP,COMPL)), !.
  m_property(_,var_border(EXP)):-
	term_str(exp,EXP,S),
	format(A2,re_r07,S),
	warning_message(A2), !.

  m_property(LEVEL,var_font(EXP)):- % Whole the Font
	m_exp(EXP,SR),
	trap(term_str(font,FONT,SR),_,fail),
	retract(active_prop(LEVEL,_NT,FF,STYLE,SIZE,X,TABS,DT,Y,BORDER,ALIGNMENT,
              FOREGR_COLOR, BACK_COLOR,LIND,TIND,CLIP,COMPL)),
	assert(active_prop(LEVEL,FONT,FF,STYLE,SIZE,X,TABS,DT,Y,BORDER,ALIGNMENT,
              FOREGR_COLOR, BACK_COLOR,LIND,TIND,CLIP,COMPL)), !.
% LJP insert
  m_property(LEVEL,var_font(EXP)):- % Fontsize
	m_exp(EXP,SR),
	str_int(SR,NewFontsize),
	retract(active_prop(LEVEL,FONT,FF,STYLE,_SIZE,X,TABS,DT,Y,BORDER,ALIGNMENT,
              FOREGR_COLOR, BACKGR_COLOR,LIND,TIND,CLIP,COMPL)),
	change_fam(font(FONT), STYLE, NewFontsize, NEWFONT),
	assert(active_prop(LEVEL,NEWFONT,FF,STYLE,NewFontsize,X,TABS,DT,Y,BORDER,ALIGNMENT,
              FOREGR_COLOR, BACKGR_COLOR,LIND,TIND,CLIP,COMPL)),
	!.
  m_property(LEVEL,var_font(EXP)):- % Fontstyle
	m_exp(EXP,NewFontStyleStr),
	table_style(NewFontStyleStr,NewFontStyle),
	retract(active_prop(LEVEL,FONT,FF,_STYLE,SIZE,X,TABS,DT,Y,BORDER,ALIGNMENT,
              FOREGR_COLOR, BACKGR_COLOR,LIND,TIND,CLIP,COMPL)),
	change_fam(font(FONT), NewFontStyle, SIZE, NEWFONT),
	assert(active_prop(LEVEL,NEWFONT,FF,NewFontStyle,SIZE,X,TABS,DT,Y,BORDER,ALIGNMENT,
              FOREGR_COLOR, BACKGR_COLOR,LIND,TIND,CLIP,COMPL)),
	!.
  m_property(LEVEL,var_font(EXP)):- % Fontfamily
	m_exp(EXP,NewFontFamily),
	retract(active_prop(LEVEL,_FONT,_,STYLE,SIZE,X,TABS,DT,Y,BORDER,ALIGNMENT,
              FOREGR_COLOR, BACKGR_COLOR,LIND,TIND,CLIP,COMPL)),
	change_fam(str(NewFontFamily), STYLE, SIZE, NEWFONT),
	table_font(NewFontFamily,NewF),
	assert(active_prop(LEVEL,NEWFONT,NewF,STYLE,SIZE,X,TABS,DT,Y,BORDER,ALIGNMENT,
              FOREGR_COLOR, BACKGR_COLOR,LIND,TIND,CLIP,COMPL)),
	!.
% end LJP insert
  m_property(_,var_font(EXP)):-
  	term_str(exp,EXP,S),
	format(A2,re_r08,S),
	warning_message(A2), !.
  
  m_property(LEVEL,new_page):-
      retract(active_prop(LEVEL,FONT,FF,STYLE,SIZE,X,TABS,DT,Y,BORDER,ALIGNMENT,
              FOREGR_COLOR, BACKGR_COLOR,LIND,TIND,CLIP,COMPL)),
      bitand(COMPL,$FFDF,INTRM),
      bitor(INTRM,$20,COMPL2),
      assert(active_prop(LEVEL,FONT,FF,STYLE,SIZE,X,TABS,DT,Y,BORDER,ALIGNMENT,
              FOREGR_COLOR, BACKGR_COLOR,LIND,TIND,CLIP,COMPL2)),
               !.
  m_property(LEVEL,recurrent):-
      retract(active_prop(LEVEL,FONT,FF,STYLE,SIZE,X,TABS,DT,Y,BORDER,ALIGNMENT,
              FOREGR_COLOR, BACKGR_COLOR,LIND,TIND,CLIP,COMPL)),
      bitand(COMPL,$FFEF,INTRM),
      bitor(INTRM,32,COMPL2),
      assert(active_prop(LEVEL,FONT,FF,STYLE,SIZE,X,TABS,DT,Y,BORDER,ALIGNMENT,
              FOREGR_COLOR, BACKGR_COLOR,LIND,TIND,CLIP,COMPL2)),
               !.
  m_property(LEVEL,enlarge):-
      retract(active_prop(LEVEL,FONT,FF,STYLE,SIZE,X,TABS,DT,Y,BORDER,ALIGNMENT,
              FOREGR_COLOR, BACKGR_COLOR,LIND,TIND,CLIP,COMPL)),
      bitand(COMPL,$FFEF,INTRM),
      bitor(INTRM,16,COMPL2),
      assert(active_prop(LEVEL,FONT,FF,STYLE,SIZE,X,TABS,DT,Y,BORDER,ALIGNMENT,
              FOREGR_COLOR, BACKGR_COLOR,LIND,TIND,CLIP,COMPL2)),
               !.
  m_property(LEVEL,expandable):-
      retract(active_prop(LEVEL,FONT,FF,STYLE,SIZE,X,TABS,DT,Y,BORDER,ALIGNMENT,
              FOREGR_COLOR, BACKGR_COLOR,LIND,TIND,CLIP,COMPL)),
      bitand(COMPL,$FFF7,INTRM),
      bitor(INTRM,8,COMPL2),
      assert(active_prop(LEVEL,FONT,FF,STYLE,SIZE,X,TABS,DT,Y,BORDER,ALIGNMENT,
              FOREGR_COLOR, BACKGR_COLOR,LIND,TIND,CLIP,COMPL2)),
               !.
  m_property(LEVEL,outer_rect):-
      retract(active_prop(LEVEL,FONT,FF,STYLE,SIZE,X,TABS,DT,Y,BORDER,ALIGNMENT,
              FOREGR_COLOR, BACKGR_COLOR,LIND,TIND,CLIP,COMPL)),
      bitand(COMPL,$FFFB,INTRM),
      bitor(INTRM,4,COMPL2),
      assert(active_prop(LEVEL,FONT,FF,STYLE,SIZE,X,TABS,DT,Y,BORDER,ALIGNMENT,
              FOREGR_COLOR, BACKGR_COLOR,LIND,TIND,CLIP,COMPL2)),
               !.
  m_property(LEVEL,keep_together):-
      retract(active_prop(LEVEL,FONT,FF,STYLE,SIZE,X,TABS,DT,Y,BORDER,ALIGNMENT,
              FOREGR_COLOR, BACKGR_COLOR,LIND,TIND,CLIP,COMPL)),
      bitand(COMPL,$FFFD,COMPL2),
      assert(active_prop(LEVEL,FONT,FF,STYLE,SIZE,X,TABS,DT,Y,BORDER,ALIGNMENT,
              FOREGR_COLOR, BACKGR_COLOR,LIND,TIND,CLIP,COMPL2)),
               !.
  m_property(LEVEL,vertical_block):-
      retract(active_prop(LEVEL,FONT,FF,STYLE,SIZE,X,TABS,DT,Y,BORDER,ALIGNMENT,
              FOREGR_COLOR, BACKGR_COLOR,LIND,TIND,CLIP,COMPL)),
      bitand(COMPL,$FFFE,COMPL2),
      assert(active_prop(LEVEL,FONT,FF,STYLE,SIZE,X,TABS,DT,Y,BORDER,ALIGNMENT,
              FOREGR_COLOR, BACKGR_COLOR,LIND,TIND,CLIP,COMPL2)),
               !.
  m_property(LEVEL,horizontal_block):-
      retract(active_prop(LEVEL,FONT,FF,STYLE,SIZE,X,TABS,DT,Y,BORDER,ALIGNMENT,
              FOREGR_COLOR, BACKGR_COLOR,LIND,TIND,CLIP,COMPL)),
      bitand(COMPL,$FFFE,INTRM),
      bitor(INTRM,$0001,COMPL2),
      assert(active_prop(LEVEL,FONT,FF,STYLE,SIZE,X,TABS,DT,Y,BORDER,ALIGNMENT,
              FOREGR_COLOR, BACKGR_COLOR,LIND,TIND,CLIP,COMPL2)),
               !.
  m_property(LEVEL,clip):-
      retract(active_prop(LEVEL,FONT,FF,STYLE,SIZE,X,TABS,DT,Y,BORDER,ALIGNMENT,
              FOREGR_COLOR, BACKGR_COLOR,LIND,TIND,_CLIP,COMPL)),
      assert(active_prop(LEVEL,FONT,FF,STYLE,SIZE,X,TABS,DT,Y,BORDER,ALIGNMENT,
              FOREGR_COLOR, BACKGR_COLOR,LIND,TIND,clip_re,COMPL)),
               !.
  m_property(LEVEL,wrap):-
      retract(active_prop(LEVEL,FONT,FF,STYLE,SIZE,X,TABS,DT,Y,BORDER,ALIGNMENT,
              FOREGR_COLOR, BACKGR_COLOR,LIND,TIND,_CLIP,COMPL)),
      assert(active_prop(LEVEL,FONT,FF,STYLE,SIZE,X,TABS,DT,Y,BORDER,ALIGNMENT,
              FOREGR_COLOR, BACKGR_COLOR,LIND,TIND,wrap_re,COMPL)),
               !.
  
  m_property(LEVEL,topindent(TOP)):-
	calculate_topindentation(TOP,TOPM),
      retract(active_prop(LEVEL,FONT,FF,STYLE,SIZE,X,TABS,DT,Y,BORDER,ALIGNMENT,
              FOREGR_COLOR, BACKGR_COLOR,LIND,_,CLIP,COMPL)),
      assert(active_prop(LEVEL,FONT,FF,STYLE,SIZE,X,TABS,DT,Y,BORDER,ALIGNMENT,
              FOREGR_COLOR, BACKGR_COLOR,LIND,TOPM,CLIP,COMPL)),
               !.
  m_property(LEVEL,leftindent(LEFT)):-
	calculate_leftindentation(LEFT,LEFTM),
      retract(active_prop(LEVEL,FONT,FF,STYLE,SIZE,X,TABS,DT,Y,BORDER,ALIGNMENT,
              FOREGR_COLOR, BACKGR_COLOR,_,TIND,CLIP,COMPL)),
      assert(active_prop(LEVEL,FONT,FF,STYLE,SIZE,X,TABS,DT,Y,BORDER,ALIGNMENT,
              FOREGR_COLOR, BACKGR_COLOR,LEFTM,TIND,CLIP,COMPL)),
               !.

  m_property(_,PROP):-
  	term_str(PROPERTY,PROP,S),
	format(A2,re_r09,S),
	warning_message(A2).

predicates
procedure	set_up
procedure	change_active_prop
procedure	change_second_level   
procedure	get_tabs(ILIST)
procedure	backup_all_properties(INTEGER,LEVEL_PROPERTIES)
procedure	setup_all_properties(INTEGER,LEVEL_PROPERTIES)
procedure	re_set_complexprops(LEVEL_PROPERTIES)
procedure	re_clear_noninherited(LEVEL_PROPERTIES)
procedure	re_extract_props_forbeginning(PROPERTIES)
procedure	re_extract_props(INTEGER,PROPERTIES)
clauses
   set_up:-
	        retract(active_prop(_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_)),
		fail.
   set_up:-	page(CURRENT,REQUIRED),
		CURRENT = REQUIRED,
		retract(draw_forbidden),
            	fail.
   set_up:-
            FONT = font_Create(ff_times,[],12),
            assert(active_prop(1,FONT,ff_times,[],8, 0.0,[],0,0,0,center,0,color_White,0,0,noclip_re,2)),
            assert(active_prop(2,FONT,ff_times,[],8, 0.0,[],0,0,0,center,0,color_White,0,0,noclip_re,2)),
            assert(active_prop(3,FONT,ff_times,[],8, 0.0,[],0,0,0,center,0,color_White,0,0,noclip_re,2)),
            !.

  change_active_prop:-
      active_prop(2,FONT,FF,STYLE,SIZE,_X,TABS,DT,_Y,BORDER,ALIGNMENT,
              FOREGR_COLOR, BACKGR_COLOR,LIND,TIND,CLIP,COMPL),
      retract(active_prop(3,_,_,_,_,X,_,_,Y,_,_,_,_,_,_,_,_)),
      assert(active_prop(3,FONT,FF,STYLE,SIZE,X,TABS,DT,Y,BORDER,ALIGNMENT,
              FOREGR_COLOR, BACKGR_COLOR,LIND,TIND,CLIP,COMPL)),
      	!.
  change_active_prop.

  change_second_level:-
      active_prop(1,FONT,FF,STYLE,SIZE,X,TABS,DT,_Y,BORDER,ALIGNMENT,
              FOREGR_COLOR, BACKGR_COLOR,LIND,TIND,CLIP,COMPL),
      active_prop(3,_,_,_,_,_,_,_,Y,_,_,_,_,_,_,_,_),
      retract(active_prop(2,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_)),
      assert(active_prop(2,FONT,FF,STYLE,SIZE,X,TABS,DT,Y,BORDER,ALIGNMENT,
              FOREGR_COLOR, BACKGR_COLOR,LIND,TIND,CLIP,COMPL)),
      !.
  change_second_level.

    get_tabs(TABS):-
      active_prop(3,_FONT,_,_STYLE,_SIZE,_X,TABS,_,_Y,_BORDER,_ALIGNMENT,
              _FOREGR_COLOR, _BACKGR_COLOR,_,_,_CLIP,_),
      !.
    get_tabs([]).
%--- Prevent OUTER_RECT is inherited toward the internal block ---
backup_all_properties(LEVEL,DOM):-
	active_prop(LEVEL,FONT,FF,STYLE,SIZE,X,TABS,DT,Y,BORDER,ALIGNMENT,
              FOREGR_COLOR, BACKGR_COLOR,LIND,TIND,CLIP,COMPL),
DOM = level_properties(FONT,FF,STYLE,SIZE,X,TABS,DT,Y,BORDER,ALIGNMENT,
              FOREGR_COLOR, BACKGR_COLOR,LIND,TIND,CLIP,COMPL),!.
backup_all_properties(_,no_level_properties).

setup_all_properties(LEVEL,DOM):-
DOM = level_properties(FONT,FF,STYLE,SIZE,X,TABS,DT,Y,BORDER,ALIGNMENT,
              FOREGR_COLOR, BACKGR_COLOR,LIND,TIND,CLIP,COMPL),
	retract(active_prop(LEVEL,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,OLDCompl)),
	bitand(OldCompl,$FFFB,INTER),
	bitor(COMPL,INTER,NEWCompl),
	assert(active_prop(LEVEL,FONT,FF,STYLE,SIZE,X,TABS,DT,Y,BORDER,ALIGNMENT,
              FOREGR_COLOR, BACKGR_COLOR,LIND,TIND,CLIP,NewCompl)),!.

setup_all_properties(_,_).

  re_set_complexprops(DOM):-
	DOM = level_properties(_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,COMPL_DOM),
	bitand(COMPL_DOM,8,VAL),
	VAL = 8,
	retract(active_prop(3,FONT,FF,STYLE,SIZE,X,TABS,DT,Y,BORDER,ALIGNMENT,
              FORE,BACK,LIND,TIND,CLIP,COMPL)),
	bitand(COMPL,$FFF7,INTRM),
	bitor(INTRM,8,COMPL2),
	assert(active_prop(3,FONT,FF,STYLE,SIZE,X,TABS,DT,Y,BORDER,ALIGNMENT,
              FORE,BACK,LIND,TIND,CLIP,COMPL2)),
	!.
  
  re_set_complexprops(_).

   re_clear_noninherited(DOM):-
	retract(active_prop(2,FONT,FF,STYLE,SIZE,X,TABS,DT,Y,BORDER,ALIGNMENT,
              FORE,BACK,LIND,TIND,CLIP,COMPL)),
        bitand(COMPL,$FFFB,COMPL2),
        bitand(COMPL,$FFF3,COMPL_O),
	DOM = level_properties(FONT,FF,STYLE,SIZE,X,TABS,DT,Y,BORDER,ALIGNMENT,
              FORE,BACK,LIND,TIND,CLIP,COMPL_O),
	assert(active_prop(2,FONT,FF,STYLE,SIZE,X,TABS,DT,Y,BORDER,ALIGNMENT,
              FORE,BACK,LIND,TIND,CLIP,COMPL2)),
	!.
  
   re_clear_noninherited(no_level_properties).
  re_extract_props_forbeginning(PROPS):-
	active_prop(2,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,COMPL),
	bitand(COMPL,7,VAL),
	re_extract_props(VAL,PROPS), !.
  re_extract_props_forbeginning([]).
	
  re_extract_props(0,[keep_together]):-!.
  re_extract_props(1,[keep_together,horizontal_block]):-!.
  re_extract_props(2,[]):-!.
  re_extract_props(3,[horizontal_block]):-!.
  re_extract_props(4,[keep_together,outer_rect]):-!.
  re_extract_props(5,[keep_together,outer_rect,horizontal_block]):-!.
  re_extract_props(6,[outer_rect]):-!.
  re_extract_props(7,[outer_rect,horizontal_block]):-!.
  re_extract_props(_,[]).
