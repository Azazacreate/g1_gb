/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S 

 FileName:	PARSER.PRO
 Purpose:	Parsing Predicates
 Written by:	Alexander Grachev
 Version:	1.3
 Build:		019.990201
 Tested with:	Visual Prolog v.5.1 build 563
 Comments:
*****************************************************************************/
database - re_plan_optionalparam
  re_plantime(INTEGER,UNSIGNED)
  re_planday(ILIST)
  re_plandate(LLIST)
  re_plandiv(INTEGER)
  re_plandurat(EXP)
  re_planhandle(EXP)

predicates
procedure	s_fstyle(TOKL,TOKL,FONTSTYLE)
procedure	s_fstyle1(TOKL,TOKL,FONTSTYLE)
determ		s_falign(TOKL,TOKL,ALIGNMENT_VAL)
determ		s_orientation(TOKL,TOKL,BOOLEAN)

clauses
  s_fstyle([t(normal,_)|LL0],LL0,[]):-!.
  s_fstyle([t(bold,_)|LL1],LL0,[fs_bold|REST]):-
  	s_fstyle1(LL1,LL0,REST), !.
  s_fstyle([t(italic,_)|LL1],LL0,[fs_italic|REST]):-
  	s_fstyle1(LL1,LL0,REST), !.
  s_fstyle([t(underline,_)|LL1],LL0,[fs_underline|REST]):-
  	s_fstyle1(LL1,LL0,REST), !.
  s_fstyle(_,[],[]):-errorexit().

  s_fstyle1([t(comma,_)|LL1],LL0,REST):-!,
  	s_fstyle(LL1,LL0,REST).
  s_fstyle1(LL,LL,[]).
    
  s_falign([t(center,_)|LL0],LL0,center):-!.
  s_falign([t(left,_)|LL0],LL0,left):-!.
  s_falign([t(right,_)|LL0],LL0,right).

  s_orientation([t(portrait,_)|LL0],LL0,b_false):-!.
  s_orientation([t(landscape,_)|LL0],LL0,b_true):-!.
  s_orientation(LL,LL,b_false):-
  	syntax_error(re_p03,LL).

predicates
determ	s_exp(TOKL,TOKL,EXP)
determ	s_exp1(TOKL,TOKL,EXP)
determ	s_exp2(TOKL,TOKL,EXP)
determ	s_exp3(TOKL,TOKL,EXP)
determ	s_exp4(TOKL,TOKL,EXP,EXP)
determ	s_exp5(TOKL,TOKL,EXP,EXP)
determ	s_variable(TOKL,TOKL,VARIABLE)

clauses
  s_exp(LL1,LL0,EXP):-
	s_exp1(LL1,LL0,EXP).

  s_exp1(LL1,LL0,EXP_):-
	s_exp2(LL1,LL2,EXP),
	s_exp4(LL2,LL0,EXP,EXP_).

  s_exp2(LL1,LL0,EXP_):-
	s_exp3(LL1,LL2,EXP),
	s_exp5(LL2,LL0,EXP,EXP_).

  s_exp3([t(lbracket,_)|LL1],LL0,EXP):-!,
	s_exp(LL1,LL2,EXP),
	expect(t(rbracket,_),LL2,LL0).
  s_exp3(LL1,LL0,ident(VARIABLE)):-
	s_variable(LL1,LL0,VARIABLE),!.
  s_exp3([t(str(STRING),_)|LL],LL,cin_s(STRING)):-!.
  s_exp3([t(int(INTEGER),_)|LL],LL,cin_i(INTEGER)):-!.
  s_exp3([t(long(LONG),_)|LL],LL,cin_l(LONG)):-!.
  s_exp3([t(real(REAL),_)|LL],LL,cin_r(REAL)):-!.
  s_exp3([t(minus,_),t(int(INT),_)|LL],LL,cin_i(INTEGER)):-!,
  	INTEGER = 0 - INT.

  s_exp4([t(plus,_)|LL1],LL0,EXP,EXP_):-!,
	s_exp2(LL1,LL2,EXP1),
	s_exp4(LL2,LL0,plus(EXP,EXP1),EXP_).
  s_exp4([t(minus,_)|LL1],LL0,EXP,EXP_):-!,
	s_exp2(LL1,LL2,EXP1),
	s_exp4(LL2,LL0,minus(EXP,EXP1),EXP_).
  s_exp4(LL,LL,EXP,EXP).

  s_exp5([t(mult,_)|LL1],LL0,EXP,EXP_):-!,
	s_exp3(LL1,LL2,EXP1),
	s_exp5(LL2,LL0,mult(EXP,EXP1),EXP_).
  s_exp5([t(div,_)|LL1],LL0,EXP,EXP_):-!,
	s_exp3(LL1,LL2,EXP1),
	s_exp5(LL2,LL0,div(EXP,EXP1),EXP_).
  s_exp5(LL,LL,EXP,EXP).

  s_variable([t(id(STRING),_)|LL],LL,ident(STRING)):-!.

predicates
determ		s_optional_plan_properties(TOKL,TOKL,EXP,EXP,VGRIDLIST,ILIST,LLIST,INTEGER)
determ		s_plan_period(TOKL,TOKL,EXP,EXP)
determ		s_optional_plan_param(TOKL,TOKL)
determ		s_longlist(TOKL,TOKL,LLIST)
determ		s_longlist1(TOKL,TOKL,LLIST)
determ		s_long(TOKL,TOKL,LONG)
determ		s_integer(TOKL,TOKL,INTEGER)
determ		s_widthlist(TOKL,TOKL,WIDTHLIST)
determ		s_widthlist1(TOKL,TOKL,WIDTHLIST)
determ		s_widthprop(TOKL,TOKL,WIDTHPROP)
procedure	s_optional_plan_prop1(TOKL,TOKL)
procedure	s_optional_time(VGRIDLIST)
procedure	s_optional_day(ILIST)
procedure	s_optional_date(LLIST)
procedure	s_optional_div(INTEGER)
procedure	s_optional_plandurat(EXP)
procedure	s_optional_planhandle(EXP)
procedure	s_integerlist(TOKL,TOKL,ILIST)
procedure	s_integerlist1(TOKL,TOKL,ILIST)

clauses
  s_optional_plan_properties(LL1,LL0,DURATION,HANDLE,TIME,DAY,DATE,DIV):-
	retractall(_,re_plan_optionalparam),
	s_optional_plan_prop1(LL1,LL0),
  	s_optional_time(TIME),
  	s_optional_day(DAY),
  	s_optional_date(DATE),
  	s_optional_div(DIV),
	s_optional_plandurat(DURATION),
	s_optional_planhandle(HANDLE),
  	!.
  	
  s_optional_plan_properties(LL,_,_,_,_,_,_,_):-
  	syntax_error(re_p04,LL),
  	fail.

  s_plan_period([t(start_period,_)|LL1],LL0,START,END):-
	expect(t(equal,_),LL1,LL2),
  	s_exp(LL2,LL3,START),
	expect(t(end_period,_),LL3,LL4),
	expect(t(equal,_),LL4,LL5),
	s_exp(LL5,LL0,END), !.
  s_plan_period(LL,_,_,_):-
  	syntax_error(re_p05,LL),
  	fail.
  
  s_optional_plan_prop1(LL1,LL0):-
  	s_optional_plan_param(LL1,LL2),!,
  	s_optional_plan_prop1(LL2,LL0).
  s_optional_plan_prop1(L,L):- !.
  s_optional_plan_param([t(time_off,_)|LL1],LL0):-
	expect(t(equal,_),LL1,LL2),
	s_integer(LL2,LL3,S),
	expect(t(comma,_),LL3,LL4),
	s_integer(LL4,LL0,E),
	assert(re_plantime(S,E)),
	!.
	
  s_optional_plan_param([t(day_off,_)|LL1],LL0):-
	expect(t(equal,_),LL1,LL2),
	s_integerlist(LL2,LL0,ILIST),
	assert(re_planday(ILIST)),
	!.  	
	
  s_optional_plan_param([t(holidays,_)|LL1],LL0):-
	expect(t(equal,_),LL1,LL2),
  	s_longlist(LL2,LL0,DATE),
  	assert(re_plandate(DATE)),
  	!.
  s_optional_plan_param([t(divider,_)|LL1],LL0):-
	expect(t(equal,_),LL1,LL2),
	s_integer(LL2,LL0,DIV),
	assert(re_plandiv(DIV)),
	!.  	
  s_optional_plan_param([t(duration_period,_)|LL1],LL0):-
	expect(t(equal,_),LL1,LL2),
	s_exp(LL2,LL0,DIV),
	assert(re_plandurat(DIV)),
	!.  	

  s_optional_plan_param([t(planhandle,_)|LL1],LL0):-
	expect(t(equal,_),LL1,LL2),
	s_exp(LL2,LL0,Handle),
	assert(re_planhandle(Handle)),
	!.  	

  s_optional_time([vgrid(S,E)|LIST]):-
  	retract(re_plantime(S,E)),!,
  	s_optional_time(LIST).
  s_optional_time([]):-!.
  
  s_optional_day(ILIST):-
  	retract(re_planday(ILIST)), !.
  s_optional_day([]):-!.

  s_optional_date(LLIST):-
  	retract(re_plandate(LLIST)), !.
  s_optional_date([]):-!.

  s_optional_div(DIV):-
  	retract(re_plandiv(DIV)), !.
  s_optional_div(10):-!.

  s_optional_plandurat(DIV):-
  	retract(re_plandurat(DIV)), !.
  s_optional_plandurat(cin_l(0)):-!.

  s_optional_planhandle(Handle):-
  	retract(re_planhandle(Handle)), !.
  s_optional_planhandle(cin_i(0)):-!.

  s_integerlist(LL1,LL0,[INTEGER|INTEGERLIST]):-
	s_integer(LL1,LL2,INTEGER),!,
	s_integerlist1(LL2,LL0,INTEGERLIST).
  s_integerlist(LL,LL,[]).

  s_integerlist1([t(comma,_)|LL1],LL2,INTEGERLIST):-!,
	s_integerlist(LL1,LL2,INTEGERLIST).
  s_integerlist1(LL,LL,[]).

  s_longlist(LL1,LL0,[L|LLIST]):-
	s_long(LL1,LL2,L),!,
	s_longlist1(LL2,LL0,LLIST).

  s_longlist1([t(comma,_)|LL1],LL2,LLIST):-!,
	s_longlist(LL1,LL2,LLIST).
  s_longlist1(LL,LL,[]).

  s_integer([t(int(INTEGER),_)|LL],LL,INTEGER):-!.
  s_integer(LL,_,_):-syntax_error(re_p06,LL),fail.

  s_long([t(long(L),_)|LL],LL,L):-!.
  s_long([t(int(I),_)|LL],LL,L):-
  	str_int(S,I),
  	term_str(long,L,S),
  	!.

  s_widthlist(LL1,LL0,[WP|WL]):-
  	s_widthprop(LL1,LL2,WP),!,
  	s_widthlist1(LL2,LL0,WL).
  s_widthlist1([t(comma,_)|LL1],LL2,LIST):-!,
	s_widthlist(LL1,LL2,LIST).
  s_widthlist1(LL,LL,[]).

  s_widthprop(LL1,LL0,widthprop(WIDTH,alignment(ALIGN))):-
	expect(t(int(WIDTH),_),LL1,LL2),
	s_falign(LL2,LL0,ALIGN), !.

  s_widthprop(LL1,LL0,widthprop(WIDTH,alignment(left))):-
	expect(t(int(WIDTH),_),LL1,LL0).
predicates
procedure	s_stmts(TOKL,TOKL,STMTS)
procedure	s_stmts1(TOKL,TOKL,STMTS)
procedure	s_blocklist(TOKL,TOKL,BLOCKLIST)
procedure	s_blocklist1(TOKL,TOKL,BLOCKLIST)
procedure	s_atomblocklist(TOKL,TOKL,ATOMBLOCKLIST)
procedure	s_atomblocklist1(TOKL,TOKL,ATOMBLOCKLIST)
procedure	s_properties(TOKL,TOKL,PROPERTIES)
procedure	s_fontlist(TOKL,TOKL,FONTLIST)
procedure	s_alignment(TOKL,TOKL,ALIGNMENT)
procedure	s_pageproperties(TOKL,TOKL,PAGEPROPERTIES)
procedure	s_ganttproperties(TOKL,TOKL,GANTTPROPERTIES)
procedure	s_schemeproperties(TOKL,TOKL,SCHEMEPROPERTIES)
procedure	s_vgridlist1(TOKL,TOKL,VGRIDLIST)
procedure	s_exps(TOKL,TOKL,EXPS)
procedure	s_exps1(TOKL,TOKL,EXPS)
procedure	s_stringlist1(TOKL,TOKL,SLIST)
procedure	s_var_out(TOKL,TOKL,VAR_OUT)
procedure	s_var_out1(TOKL,TOKL,VAR_OUT)
procedure	s_header(TOKL,TOKL,HEADER)
procedure	s_footer(TOKL,TOKL,FOOTER)
procedure	s_block(TOKL,TOKL,BLOCK)
procedure	s_atomblock(TOKL,TOKL,ATOMBLOCK)
procedure	s_rect(TOKL,TOKL,BLOCK_RECT)
procedure	s_titlelist(TOKL,TOKL,TITLELIST)
procedure	s_titlelist1(TOKL,TOKL,TITLELIST)
procedure	s_varlist_out(TOKL,TOKL,VARLIST_OUT)
determ		s_stringlist(TOKL,TOKL,SLIST)
determ  	s_calproperties(TOKL,TOKL,CALPROPERTIES)
determ  	s_calproperties1(TOKL,TOKL,CALPROPERTIES)
determ  	s_vgridlist(TOKL,TOKL,VGRIDLIST)
determ  	s_font(TOKL,TOKL,PFONT)
determ  	s_report(TOKL,TOKL,REPORT)
determ  	s_name(TOKL,TOKL,NAME)
determ  	s_script(TOKL,TOKL,SCRIPT)
determ  	s_stmt(TOKL,TOKL,STMT)
determ  	s_property(TOKL,TOKL,PROPERTY)
determ  	s_pageproperty(TOKL,TOKL,PAGEPROPERTY)
determ  	s_units(TOKL,TOKL,UNITS)
determ  	s_planproperties(TOKL,TOKL,PLANPROPERTIES)
determ  	s_ganttproperty(TOKL,TOKL,GANTTPROPERTY)
determ  	s_schemeproperty(TOKL,TOKL,SCHEMEPROPERTY)
determ  	s_titlestr(TOKL,TOKL,TITLESTR)
determ  	s_mode(TOKL,TOKL,MODE)
determ  	s_vgrid(TOKL,TOKL,VGRID)
determ  	s_calendar(TOKL,TOKL,CALENDAR)
determ  	s_step(TOKL,TOKL,STEP)
determ  	s_cond(TOKL,TOKL,COND)
determ  	s_cond1(TOKL,TOKL,COND)
determ  	s_cond4(TOKL,TOKL,EXP,COND)
determ  	s_cond2(TOKL,TOKL,COND)
determ  	s_cond5(TOKL,TOKL,COND,COND)
determ  	s_cond3(TOKL,TOKL,COND)
determ  	s_predcall(TOKL,TOKL,PREDCALL)
determ  	s_real(TOKL,TOKL,REAL)
determ  	s_real_withsign(TOKL,TOKL,REAL)

clauses
  s_report([t(report,_)|LL1],LL0,report(NAME,PAGEPROPERTIES,PROPERTIES,SCRIPT,HEADER,BLOCKLIST,FOOTER)):-!,
	s_name(LL1,LL2,NAME),
	s_pageproperties(LL2,LL3,PAGEPROPERTIES),
	s_properties(LL3,LL4,PROPERTIES),
	s_script(LL4,LL5,SCRIPT),
	s_header(LL5,LL6,HEADER),
	s_blocklist(LL6,LL7,BLOCKLIST),
	s_footer(LL7,LL8,FOOTER),
	expect(t(end_report,_),LL8,LL0).
  s_report(LL,_,_):-syntax_error(re_p07,LL),fail.

  s_name([t(id(STRING),_)|LL],LL,name(STRING)):-!.
  s_name(LL,_,_):-syntax_error(re_p08,LL),fail.

  s_header([t(header,_)|LL1],LL0,header(PROPERTIES,SCRIPT,ATOMBLOCKLIST)):-
	s_properties(LL1,LL2,PROPERTIES),
	s_script(LL2,LL3,SCRIPT),
	s_atomblocklist(LL3,LL4,ATOMBLOCKLIST),
	expect(t(end_header,_),LL4,LL0),
	!.
  s_header(LL,LL,noheader):-!.

  s_footer([t(footer,_)|LL1],LL0,footer(PROPERTIES,SCRIPT,ATOMBLOCKLIST)):-
	s_properties(LL1,LL2,PROPERTIES),
	s_script(LL2,LL3,SCRIPT),
	s_atomblocklist(LL3,LL4,ATOMBLOCKLIST),
	expect(t(end_footer,_),LL4,LL0),
	!.
  s_footer(LL,LL,nofooter):-!.

  s_script([t(script,_)|LL1],LL0,script(STMTS)):-!,
	s_stmts(LL1,LL2,STMTS),
	expect(t(end_script,_),LL2,LL0).
  s_script(L,L,script([])).
%  s_script(LL,_,_):-syntax_error(script,LL),fail.

  s_stmt(LL1,LL0,assign(VARIABLE,EXP)):-
	s_variable(LL1,LL2,VARIABLE),
	expect(t(assign,_),LL2,LL3),
	s_exp(LL3,LL0,EXP),!.
  s_stmt(LL1,LL0,predcall(PREDCALL)):-
	s_predcall(LL1,LL0,PREDCALL),!.

  s_stmt([t(while,_)|LL1],LL0,while_st(COND,STMTS)):-
  	s_cond(LL1,LL2,COND),
  	expect(t(do,_),LL2,LL3),
  	s_stmts(LL3,LL4,STMTS),
  	expect(t(end_while,_),LL4,LL0), !.

  s_stmt([t(if_,_)|LL1],LL0,if_else_st(COND,STMTS1,STMTS2)):-
  	s_cond(LL1,LL2,COND),
  	expect(t(then,_),LL2,LL3),
  	s_stmts(LL3,LL4,STMTS1),
  	expect(t(else,_),LL4,LL5),
  	s_stmts(LL5,LL6,STMTS2),
  	expect(t(end_if,_),LL6,LL0), !.
  
  s_stmt([t(if_,_)|LL1],LL0,if_st(COND,STMTS)):-
  	s_cond(LL1,LL2,COND),
  	expect(t(then,_),LL2,LL3),
  	s_stmts(LL3,LL4,STMTS),
  	expect(t(end_if,_),LL4,LL0), !.

  s_block([t(while,_)|LL1],LL0,while(COND,RECT,PROPERTIES,HEADER,SCRIPT,BLOCKLIST)):-
	s_cond(LL1,LL2,COND),
	expect(t(do,_),LL2,LL3),
	s_rect(LL3,LL4,RECT),
	s_properties(LL4,LL5,PROPERTIES),
	s_header(LL5,LL6,HEADER),
	expect(t(begin,_),LL6,LL7),
	s_script(LL7,LL8,SCRIPT),
	s_blocklist(LL8,LL9,BLOCKLIST),
	expect(t(end,_),LL9,LL0),!.
  s_block([t(if_,_)|LL1],LL0,ifthen(COND,RECT,PROPERTIES,HEADER,SCRIPT,BLOCKLIST)):-
	s_cond(LL1,LL2,COND),
	expect(t(then,_),LL2,LL3),
	s_rect(LL3,LL4,RECT),
	s_properties(LL4,LL5,PROPERTIES),
	s_header(LL5,LL6,HEADER),
	expect(t(begin,_),LL6,LL7),
	s_script(LL7,LL8,SCRIPT),
	s_blocklist(LL8,LL9,BLOCKLIST),
	expect(t(end,_),LL9,LL0),!.
  s_block([t(block,_)|LL1],LL0,block(RECT,PROPERTIES,HEADER,SCRIPT,BLOCKLIST)):-
	s_rect(LL1,LL2,RECT),
	s_properties(LL2,LL3,PROPERTIES),
	s_header(LL3,LL4,HEADER),
	expect(t(begin,_),LL4,LL5),
	s_script(LL5,LL6,SCRIPT),
	s_blocklist(LL6,LL7,BLOCKLIST),
	expect(t(end,_),LL7,LL0),!.
  s_block([t(plan,_)|LL1],LL0,plan(RECT,PLANPROPERTIES,HEADER,SCRIPT,BLOCKLIST)):-
	s_rect(LL1,LL2,RECT),
	s_planproperties(LL2,LL3,PLANPROPERTIES),
	s_header(LL3,LL4,HEADER),
	expect(t(begin,_),LL4,LL5),
	s_script(LL5,LL6,SCRIPT),
	s_blocklist(LL6,LL7,BLOCKLIST),
	expect(t(end,_),LL7,LL0),!.
  s_block([t(gantt,_)|LL1],LL0,gantt(GANTTPROPERTIES)):-
	s_ganttproperties(LL1,LL0,GANTTPROPERTIES),!.
  s_block([t(scheme,_)|LL1],LL0,scheme(SCHEMEPROPERTIES)):-
	s_schemeproperties(LL1,LL0,SCHEMEPROPERTIES),!.
  s_block([t(histogramm,_)|LL],LL,histogramm):-!.
  s_block([t(pagebreak,_)|LL],LL,pagebreak):-!.
  s_block(LL1,LL0,atomblock(ATOMBLOCK)):-
	s_atomblock(LL1,LL0,ATOMBLOCK),!.

  s_atomblock([t(text,_)|LL1],LL0,text(EXPS,RECT,PROPERTIES)):-
	s_exps(LL1,LL2,EXPS),
	s_rect(LL2,LL3,RECT),
	s_properties(LL3,LL0,PROPERTIES),!.
  s_atomblock([t(bitmap,_)|LL1],LL0,bmp_file(STRING,RECT,PROPERTIES)):-
	expect(t(id(STRING),_),LL1,LL2),
	s_rect(LL2,LL3,RECT),
	s_properties(LL3,LL0,PROPERTIES),!.
  s_atomblock([t(block,_)|LL1],LL0,atomblock(RECT,PROPERTIES,ATOMBLOCKLIST)):-
	s_rect(LL1,LL2,RECT),
	s_properties(LL2,LL3,PROPERTIES),
	expect(t(begin,_),LL3,LL4),
	s_atomblocklist(LL4,LL5,ATOMBLOCKLIST),
	expect(t(end,_),LL5,LL0),!.
  s_atomblock([t(line,_)|LL1],LL0,line(RECT,PROPERTIES)):-
	s_rect(LL1,LL2,RECT),
	s_properties(LL2,LL0,PROPERTIES),!.
  s_atomblock([t(calendar,_)|LL1],LL0,calendar(CALPROPERTIES)):-
	s_calproperties(LL1,LL0,CALPROPERTIES),!.
  s_atomblock(LL,LL,noatomblock):-!.

  s_rect([t(at,_)|LL1],LL0,rect(REAL,REAL1,REAL2,REAL3)):-
	expect(t(lbracket,_),LL1,LL2),
	s_real_withsign(LL2,LL3,REAL),
	expect(t(comma,_),LL3,LL4),
	s_real_withsign(LL4,LL5,REAL1),
	expect(t(comma,_),LL5,LL6),
	s_real(LL6,LL7,REAL2),
	expect(t(comma,_),LL7,LL8),
	s_real(LL8,LL9,REAL3),
	expect(t(rbracket,_),LL9,LL0),!.
  s_rect(LL,LL,norect):-!.

  s_property(LL1,LL0,fonttype(FONT)):-
  	s_font(LL1,LL0,FONT), !.
  s_property([t(tabs,_)|LL1],LL0,tabs(INTEGERLIST)):-!,
	expect(t(equal,_),LL1,LL2),
	s_integerlist(LL2,LL0,INTEGERLIST).
  s_property([t(defaulttabs,_)|LL1],LL0,defaulttabs(EXP)):-!,
	expect(t(equal,_),LL1,LL2),
  	s_exp(LL2,LL0,EXP).
  s_property([t(border,_)|LL1],LL0,border(INTEGER)):-!,
	expect(t(equal,_),LL1,LL2),
	expect(t(int(INTEGER),_),LL2,LL0).
  s_property([t(alignment,_)|LL1],LL0,alignment(ALIGN)):-
	expect(t(equal,_),LL1,LL2),
	s_falign(LL2,LL0,ALIGN), !.
  s_property([t(alignment,_)|LL1],_,_):-
	expect(t(equal,_),LL1,LL),
	syntax_error(re_p02,LL), fail.


  s_property([t(forecolor,_)|LL1],LL0,forecolor(LONG)):-!,
	expect(t(equal,_),LL1,LL2),
	expect(t(long(LONG),_),LL2,LL0).
  s_property([t(backcolor,_)|LL1],LL0,backcolor(LONG)):-!,
	expect(t(equal,_),LL1,LL2),
	expect(t(long(LONG),_),LL2,LL0).
  s_property([t(var_backcolor,_)|LL1],LL0,var_backcolor(EXP)):-!,
  	s_exp(LL1,LL0,EXP).
  s_property([t(var_forecolor,_)|LL1],LL0,var_forecolor(EXP)):-!,
  	s_exp(LL1,LL0,EXP).
  s_property([t(var_border,_)|LL1],LL0,var_border(EXP)):-!,
  	s_exp(LL1,LL0,EXP).
  s_property([t(var_font,_)|LL1],LL0,var_font(EXP)):-!,
  	s_exp(LL1,LL0,EXP).
  s_property([t(topindent,_)|LL1],LL0,topindent(REAL)):-!,
	expect(t(equal,_),LL1,LL2),
	s_real(LL2,LL0,REAL).
  s_property([t(leftindent,_)|LL1],LL0,leftindent(REAL)):-!,
	expect(t(equal,_),LL1,LL2),
	s_real(LL2,LL0,REAL).
  	
  s_property([t(keep_together,_)|LL],LL,keep_together):-!.
  s_property([t(new_page,_)|LL],LL,new_page):-!.
  s_property([t(outer_rect,_)|LL],LL,outer_rect):-!.
  s_property([t(expandable,_)|LL],LL,expandable):-!.
  s_property([t(enlarge,_)|LL],LL,enlarge):-!.
  s_property([t(clip,_)|LL],LL,clip):-!.
  s_property([t(wrap,_)|LL],LL,wrap):-!.
  s_property([t(recurrent,_)|LL],LL,recurrent):-!.
  
  s_property([t(vertical,_)|LL],LL,vertical_block):-!.
  s_property([t(horizontal,_)|LL],LL,horizontal_block):-!.

  s_font([t(fontname,_)|LL1],LL0,fontname(STRING)):-!,
	expect(t(equal,_),LL1,LL2),
	expect(t(id(STRING),_),LL2,LL0).
  s_font([t(fontstyle,_)|LL1],LL0,fontstyle(STYLE)):-!,
	expect(t(equal,_),LL1,LL2),
	s_fstyle(LL2,LL0,STYLE).
  s_font([t(fontsize,_)|LL1],LL0,fontsize(INTEGER)):-!,
	expect(t(equal,_),LL1,LL2),
	expect(t(int(INTEGER),_),LL2,LL0).

  s_fontlist(LL1,LL0,[FONT|FLIST]):-
	s_font(LL1,LL2,FONT),!,
	s_fontlist(LL2,LL0,FLIST).
  s_fontlist(LL,LL,[]).

  s_alignment([t(alignment,_)|LL1],LL0,alignment(ALIGN)):-
	expect(t(equal,_),LL1,LL2),
	s_falign(LL2,LL0,ALIGN), !.
	
  s_alignment([t(alignment,_)|LL1],_,_):-
	expect(t(equal,_),LL1,LL),
	syntax_error(re_p02,LL), fail.
  s_alignment(LL,LL,nill).


  s_pageproperty([t(margins,_)|LL1],LL0,margins(REAL,REAL1,REAL2,REAL3)):-!,
	expect(t(lbracket,_),LL1,LL2),
	s_real(LL2,LL3,REAL),
	expect(t(comma,_),LL3,LL4),
	s_real(LL4,LL5,REAL1),
	expect(t(comma,_),LL5,LL6),
	s_real(LL6,LL7,REAL2),
	expect(t(comma,_),LL7,LL8),
	s_real(LL8,LL9,REAL3),
	expect(t(rbracket,_),LL9,LL10),
	expect(t(semicolon,_),LL10,LL0).
  s_pageproperty([t(units,_)|LL1],LL0,units(UNITS)):-!,
	s_units(LL1,LL2,UNITS),
	expect(t(semicolon,_),LL2,LL0).

  s_pageproperty([t(orientation,_)|LL1],LL0,orientation(ORIENTATION)):-!,
  	expect(t(equal,_),LL1,LL2),
  	s_orientation(LL2,LL3,ORIENTATION),
	expect(t(semicolon,_),LL3,LL0).

  	
  
  s_units([t(pixel,_)|LL],LL,pixel):-!.
  s_units([t(cm,_)|LL],LL,cm):-!.
  s_units([t(logical,_)|LL1],LL0,logical(INTEGER,INTEGER1)):-!,
	expect(t(lbracket,_),LL1,LL2),
	s_integer(LL2,LL3,INTEGER),
	s_integer(LL3,LL4,INTEGER1),
	expect(t(rbracket,_),LL4,LL0).
  s_units(LL,_,_):-syntax_error(re_p09,LL),fail.

  s_planproperties([t(leftmargin,_)|LL1],LL0,
  planproperties(LEFT,RIGHT,START,END,DURATION,Handle,TIME,DAY,DATE,DIV)):-
	expect(t(equal,_),LL1,LL2),
	s_integer(LL2,LL3,LEFT),
	expect(t(rightmargin,_),LL3,LL4),
	expect(t(equal,_),LL4,LL5),
	s_integer(LL5,LL6,RIGHT),
	s_plan_period(LL6,LL7,START,END),
	s_optional_plan_properties(LL7,LL0,DURATION,Handle,TIME,DAY,DATE,DIV), !.
	
  s_planproperties(LL,_,_):-syntax_error(re_p10,LL),fail.
  
  s_ganttproperty([t(panehandle,_)|LL1],LL0,paneorder(ORDER)):-!,
  	expect(t(equal,_),LL1,LL2),
  	s_integer(LL2,LL0,ORDER).
  s_ganttproperty([t(mode,_)|LL1],LL0,mode(MODE)):-!,
	expect(t(equal,_),LL1,LL2),
	s_mode(LL2,LL0,MODE).
  s_ganttproperty([t(horgrid,_)|LL1],LL0,horgrid(LONG)):-!,
	expect(t(equal,_),LL1,LL2),
	expect(t(long(LONG),_),LL2,LL0).
  s_ganttproperty([t(vertgrid,_)|LL1],LL0,vertgrid(VGRIDLIST)):-!,
	expect(t(equal,_),LL1,LL2),
	s_vgridlist(LL2,LL0,VGRIDLIST).
  s_ganttproperty([t(rightcolumns,_)|LL1],LL0,rightcolumns(WL)):-!,
	expect(t(equal,_),LL1,LL2),
	s_widthlist(LL2,LL0,WL).
  s_ganttproperty([t(title,_)|LL1],LL0,title(TITLE,FONT)):-
  	s_fontlist(LL1,LL2,FONT),
  	s_titlelist(LL2,LL3,TITLE),
  	expect(t(end_title,_),LL3,LL0),
  	!.
  s_ganttproperty(LL1,LL0,fonttype(FONT)):-
	s_font(LL1,LL0,FONT), !.
  

  s_schemeproperty([t(panehandle,_)|LL1],LL0,paneorder(ORDER)):-!,
  	expect(t(equal,_),LL1,LL2),
  	s_integer(LL2,LL0,ORDER).

  s_schemeproperty([t(period,_)|LL1],LL0,period(INTEGER)):-!,
  	expect(t(equal,_),LL1,LL2),
  	expect(t(int(INTEGER),_),LL2,LL0).
  s_schemeproperty([t(subrows,_)|LL1],LL0,subrows(INTEGER)):-!,
  	expect(t(equal,_),LL1,LL2),
  	expect(t(int(INTEGER),_),LL2,LL0).
  s_schemeproperty([t(subcolumns,_)|LL1],LL0,subcolumns(WL)):-!,
  	expect(t(equal,_),LL1,LL2),
  	s_widthlist(LL2,LL0,WL).
  s_schemeproperty([t(rightcolumns,_)|LL1],LL0,rightcolumns(WL)):-!,
	expect(t(equal,_),LL1,LL2),
	s_widthlist(LL2,LL0,WL).
  s_schemeproperty([t(title,_)|LL1],LL0,title(TITLE,FONT)):-
  	s_fontlist(LL1,LL2,FONT),
  	s_titlelist(LL2,LL3,TITLE),
  	expect(t(end_title,_),LL3,LL0),
  	!.
  s_schemeproperty(LL1,LL0,fonttype(FONT)):-
	s_font(LL1,LL0,FONT), !.

  s_titlestr([t(lefttitle,_)|LL1],LL0,lefttitle(STRING,FONT,ALIGNMENT)):-!,
	expect(t(equal,_),LL1,LL2),
	expect(t(str(STRING),_),LL2,LL3),
	s_fontlist(LL3,LL4,FONT),
	s_alignment(LL4,LL0,ALIGNMENT).
  s_titlestr([t(columntitle,_)|LL1],LL0,columntitle(STRINGLIST,FONT,ALIGNMENT)):-!,
	expect(t(equal,_),LL1,LL2),
	s_stringlist(LL2,LL3,STRINGLIST),
	s_fontlist(LL3,LL4,FONT),
	s_alignment(LL4,LL0,ALIGNMENT).
  s_titlestr([t(subcolumntitle,_)|LL1],LL0,subcolumntitle(STRINGLIST,FONT,ALIGNMENT)):-!,
	expect(t(equal,_),LL1,LL2),
	s_stringlist(LL2,LL3,STRINGLIST),
	s_fontlist(LL3,LL4,FONT),
	s_alignment(LL4,LL0,ALIGNMENT).
  s_titlestr([t(righttitle,_)|LL1],LL0,righttitle(STRING,FONT,ALIGNMENT)):-!,
	expect(t(equal,_),LL1,LL2),
	expect(t(str(STRING),_),LL2,LL3),
	s_fontlist(LL3,LL4,FONT),
	s_alignment(LL4,LL0,ALIGNMENT).
  s_titlestr([t(rightsubcolumntitle,_)|LL1],LL0,rightsubcolumntitle(STRINGLIST,FONT,ALIGNMENT)):-!,
	expect(t(equal,_),LL1,LL2),
	s_stringlist(LL2,LL3,STRINGLIST),
	s_fontlist(LL3,LL4,FONT),
	s_alignment(LL4,LL0,ALIGNMENT).
%  s_titlestr(LL,_,_):-syntax_error(titlestr,LL),fail.

  s_mode([t(expanded,_)|LL],LL,expanded):-!.
  s_mode([t(collapsed,_)|LL],LL,collapsed):-!.
  s_mode(LL,_,_):-syntax_error(re_p11,LL),fail.

  s_vgrid(LL1,LL0,vgrid(INTEGER,LONG)):-
	s_integer(LL1,LL2,INTEGER),
	expect(t(comma,_),LL2,LL3),
	expect(t(long(LONG),_),LL3,LL0).

  s_calendar([t(str(STRING),_)|LL1],LL0,calendar(STRING,STEP)):-
	LL1 = [t(comma,_)|LL2],
	s_step(LL2,LL0,STEP),!.

  s_calendar([t(absolute,_)|LL],LL,calendar_style(absolute)):-!.
  
  s_calendar([t(relative,_)|LL],LL,calendar_style(relative)):-!.
  
  s_step([t(days,_)|LL1],LL0,days(INTEGER)):-!,
	expect(t(equal,_),LL1,LL2),
	s_integer(LL2,LL0,INTEGER).
  s_step([t(hour,_)|LL1],LL0,hour(INTEGER)):-!,
	expect(t(equal,_),LL1,LL2),
	s_integer(LL2,LL0,INTEGER).
  s_step([t(mins,_)|LL1],LL0,mins(INTEGER)):-!,
	expect(t(equal,_),LL1,LL2),
	s_integer(LL2,LL0,INTEGER).
  s_step(LL,_,_):-syntax_error(re_p12,LL),fail.

  s_cond(LL1,LL0,COND):-
	s_cond2(LL1,LL0,COND),!.

  s_cond1(LL1,LL0,COND_):-
	s_exp(LL1,LL2,EXP),
	s_cond4(LL2,LL0,EXP,COND_),!.

  s_cond2([t(not_,_)|LL1],LL0,not_(COND)):-!,
	s_cond2(LL1,LL0,COND).
  s_cond2(LL1,LL0,COND_):-
	s_cond1(LL1,LL2,COND),
	s_cond5(LL2,LL0,COND,COND_),!.
  s_cond2(LL1,LL0,COND_):-
	s_cond3(LL1,LL2,COND),
	s_cond5(LL2,LL0,COND,COND_),!.

  s_cond3([t(lbracket,_)|LL1],LL0,COND):- !,
  	s_cond(LL1,LL2,COND),
  	expect(t(rbracket,_),LL2,LL0).
  s_cond3(LL1,LL0,predcall(PREDCALL)):-
	s_predcall(LL1,LL0,PREDCALL),!.

  s_predcall([t(call(STRING),_)|LL1],LL0,predcall(STRING,EXPS,VARLIST_OUT)):-!,
	expect(t(lbracket,_),LL1,LL2),
	s_exps(LL2,LL3,EXPS),
	s_varlist_out(LL3,LL4,VARLIST_OUT),
	expect(t(rbracket,_),LL4,LL0).

  s_varlist_out([t(semicolon,_)|LL1],LL0,outparam(VAR_OUT)):-
	s_var_out(LL1,LL0,VAR_OUT),!.
  s_varlist_out(LL,LL,noout):-!.

  s_real([t(real(REAL),_)|LL],LL,REAL):-!.
  s_real([t(int(INT),_)|LL],LL,REAL):-
  	str_int(S,INT),
  	str_real(S,REAL),
  	!.
  s_real(LL,_,_):-syntax_error(re_p13,LL),fail.

  s_real_withsign([t(minus,_)|LL1],LL0,REAL):-
  	s_real(LL1,LL0,VAL),
  	REAL = 0 - VAL, !.
  s_real_withsign(L1,L2,TOK):-
  	s_real(L1,L2,TOK), !.
  s_real_withsign(LL,_,_):-syntax_error(re_p14,LL), fail.
  s_cond4([t(equal,_)|LL1],LL0,EXP,eq(EXP,EXP1)):-!,
	s_exp(LL1,LL0,EXP1).
  s_cond4([t(not_eq,_)|LL1],LL0,EXP,not_eq(EXP,EXP1)):-!,
	s_exp(LL1,LL0,EXP1).
  s_cond4([t(less,_)|LL1],LL0,EXP,less(EXP,EXP1)):-!,
	s_exp(LL1,LL0,EXP1).
  s_cond4([t(less_eq,_)|LL1],LL0,EXP,less_eq(EXP,EXP1)):-!,
	s_exp(LL1,LL0,EXP1).
  s_cond4([t(more,_)|LL1],LL0,EXP,more(EXP,EXP1)):-!,
	s_exp(LL1,LL0,EXP1).
  s_cond4([t(more_eq,_)|LL1],LL0,EXP,more_eq(EXP,EXP1)):-!,
	s_exp(LL1,LL0,EXP1).

  s_cond5([t(or_,_)|LL1],LL0,COND,COND_):-!,
	s_cond2(LL1,LL2,COND1),
	s_cond5(LL2,LL0,or_(COND,COND1),COND_).
  s_cond5([t(xor_,_)|LL1],LL0,COND,COND_):-!,
	s_cond2(LL1,LL2,COND1),
	s_cond5(LL2,LL0,xor_(COND,COND1),COND_).
  s_cond5([t(and_,_)|LL1],LL0,COND,COND_):-!,
	s_cond2(LL1,LL2,COND1),
	s_cond5(LL2,LL0,and_(COND,COND1),COND_).
  s_cond5(LL,LL,COND,COND).

  s_stmts(LL1,LL0,[STMT|STMTS]):-
	s_stmt(LL1,LL2,STMT),!,
	s_stmts1(LL2,LL0,STMTS).
  s_stmts(LL,LL,[]).

  s_stmts1([t(semicolon,_)|LL1],LL2,STMTS):-!,
	s_stmts(LL1,LL2,STMTS).
  s_stmts1(LL,LL,[]).

  s_blocklist(LL1,LL0,[BLOCK|BLOCKLIST]):-
	s_block(LL1,LL2,BLOCK),!,
	s_blocklist1(LL2,LL0,BLOCKLIST).
  s_blocklist(LL,LL,[]).

  s_blocklist1([t(semicolon,_)|LL1],LL2,BLOCKLIST):-!,
	s_blocklist(LL1,LL2,BLOCKLIST).
  s_blocklist1(LL,LL,[]).

  s_atomblocklist(LL1,LL0,[ATOMBLOCK|ATOMBLOCKLIST]):-
	s_atomblock(LL1,LL2,ATOMBLOCK),!,
	s_atomblocklist1(LL2,LL0,ATOMBLOCKLIST).
  s_atomblocklist(LL,LL,[]).

  s_atomblocklist1([t(semicolon,_)|LL1],LL2,ATOMBLOCKLIST):-!,
	s_atomblocklist(LL1,LL2,ATOMBLOCKLIST).
  s_atomblocklist1(LL,LL,[]).

  s_properties(LL1,LL0,[PROPERTY|PROPERTIES]):-
	s_property(LL1,LL2,PROPERTY),!,
	s_properties(LL2,LL0,PROPERTIES).
  s_properties(LL,LL,[]).

  s_pageproperties(LL1,LL0,[PAGEPROPERTY|PAGEPROPERTIES]):-
	s_pageproperty(LL1,LL2,PAGEPROPERTY),!,
	s_pageproperties(LL2,LL0,PAGEPROPERTIES).
  s_pageproperties(LL,LL,[]).

  s_ganttproperties(LL1,LL0,[GANTTPROPERTY|GANTTPROPERTIES]):-
	s_ganttproperty(LL1,LL2,GANTTPROPERTY),!,
	s_ganttproperties(LL2,LL0,GANTTPROPERTIES).
  s_ganttproperties(LL,LL,[]).

  s_schemeproperties(LL1,LL0,[SCHEMEPROPERTY|SCHEMEPROPERTIES]):-
	s_schemeproperty(LL1,LL2,SCHEMEPROPERTY),!,
	s_schemeproperties(LL2,LL0,SCHEMEPROPERTIES).
  s_schemeproperties(LL,LL,[]).

  s_titlelist(LL1,LL0,[TITLESTR|TITLELIST]):-
	s_titlestr(LL1,LL2,TITLESTR),!,
	s_titlelist1(LL2,LL0,TITLELIST).
  s_titlelist(LL,LL,[]).

  s_titlelist1([t(comma,_)|LL1],LL2,TITLELIST):-!,
	s_titlelist(LL1,LL2,TITLELIST).
  s_titlelist1(LL,LL,[]).

  s_vgridlist(LL1,LL0,[VGRID|VGRIDLIST]):-
	s_vgrid(LL1,LL2,VGRID),!,
	s_vgridlist1(LL2,LL0,VGRIDLIST).

  s_vgridlist1([t(comma,_)|LL1],LL2,VGRIDLIST):-
	s_vgridlist(LL1,LL2,VGRIDLIST), !.
  s_vgridlist1(LL,LL,[]).

  s_calproperties(LL1,LL0,[CALENDAR|CALPROPERTIES]):-
	s_calendar(LL1,LL2,CALENDAR),!,
	s_calproperties1(LL2,LL0,CALPROPERTIES).

  s_calproperties1([t(comma,_)|LL1],LL2,CALPROPERTIES):-!,
	s_calproperties(LL1,LL2,CALPROPERTIES).
  s_calproperties1(LL,LL,[]).

  s_exps(LL1,LL0,[EXP|EXPS]):-
	s_exp(LL1,LL2,EXP),
	s_exps1(LL2,LL0,EXPS),
	!.
  s_exps(L, L, []).

  s_exps1([t(comma,_)|LL1],LL2,EXPS):-!,
	s_exps(LL1,LL2,EXPS).
  s_exps1(LL,LL,[]).

  s_stringlist(LL1,LL0,[STRING|STRINGLIST]):-
	LL1 = [t(str(STRING),_)|LL2],!,
	s_stringlist1(LL2,LL0,STRINGLIST).

  s_stringlist1([t(comma,_)|LL1],LL2,STRINGLIST):-
	s_stringlist(LL1,LL2,STRINGLIST),!.
  s_stringlist1(LL,LL,[]).

  s_var_out(LL1,LL0,[VARIABLE|VAR_OUT]):-
	s_variable(LL1,LL2,VARIABLE),
	s_var_out1(LL2,LL0,VAR_OUT),
	!.
  s_var_out(L, L, []).

  s_var_out1([t(comma,_)|LL1],LL2,VAR_OUT):-!,
	s_var_out(LL1,LL2,VAR_OUT).
  s_var_out1(LL,LL,[]).

