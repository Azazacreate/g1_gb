/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  PIE
 FileName: PIE.PRO
 Purpose: Core module. Handle User Goal
 Written by: PDC
 Comments:
******************************************************************************/

%Place your project INC file here
IFDEF os_nt
code = 25000
ELSEDEF
code = 16000
ENDDEF

CONSTANTS
implement_trace = 1

include "pie.inc"


/***********************************PIE********************************/

PREDICATES % Need to be compiles first due to memory limitations
  nondeterm handle_retract(TERM)
  nondeterm call(STRING,TERML)

/* ---------- The clause and operator database ------------------- */


DATABASE - operators
	variable(STRING,TERM)
	op(PRIOR,XFY,OP)
	determ traceflag
	determ pause_execution
	determ stop_execution
	determ topmost(UNSIGNED)
	
ifndef use_extdbase
	clause(STERM,STERM)
enddef

DOMAINS
  variable_ = variable_(STRING,TERM)
  op_ = op_(PRIOR,XFY,OP)
  clause_ = clause_(STERM,STERM)
  var_list = variable_*
  op_list = op_*
  clau_list = clause_*

CLAUSES
  op(1200,xfx,":-").	op(1100,xfy,";").	op(1000,xfy,",").
  op(900,fy,"not").

  op(700,xfx,"=").	op(700,xfx,"\\=").
  op(700,xfx,"is").	op(700,xfx,"<").	op(700,xfx,"=<").
  op(700,xfx,">").	op(700,xfx,">=").	op(700,xfx,"==").
  op(700,xfx,"\\==").	op(700,xfx,"=..").
  op(700,xfx,"<>").	op(700,xfx,"><").
  op(500,yfx,"+").	op(500,yfx,"-").
  op(400,yfx,"*").	op(400,yfx,"/"). op(400,yfx,"div").
  op(300,xfx,"mod").
  op(200,fx,"+").	op(200,fx,"-").


/*****************************************************************************
	Include files	
*****************************************************************************/
include "iodecl.con"

include "pie_sca.pro"	% The scanner
include "pie_out.pro"	% The term
include "pie_par.pro"	% The operator precedence parser
include "pie_inf.pro"	% The inference engine
include "include\\cgi\\cgitools.pro"

DATABASE - counter
  determ counter(INTEGER)

/******************************************************
	Main Application Goal
******************************************************/
PREDICATES
  procedure runme(parmlist)
  nondeterm pie_member(parm,parmlist)
  procedure str_to_url     (string,string)
  procedure url_to_str     (string,string)
  procedure save_Clauses   (string)
  procedure save_Vars      (string)
  procedure save_Ops       (string)
  procedure save_Trace     (string)
  procedure restore_Clauses(string)
  procedure restore_Vars   (string)
  procedure restore_Ops    (string)
  procedure restore_Trace  (string)
GOAL
        write("Content-type: text/html\n\n"),
        %
        %  Start Document
        %
        write("<html>"),nl,
        write("<head>"),nl,
        write("<title>PIE-Dialog</title>"),nl,
        write("<base target=\"dialog\">"),nl,
        write("</head>"),
        write("<body bgcolor=\"#FFFFFF\">"),nl,
	ParmList = cgi_GetParmList(),
	%
	% run PIE
	%
	write("<PRE>"),
	runme(ParmList),
	write("\n</PRE>"),
	%
	% save current PIE state
	%
	save_Clauses(ClauStr),
	save_Vars(VarStr),
	save_Ops(OpStr),
	save_Trace(TraceFlag),
	str_to_url(URL_Clau,ClauStr),
	str_to_url(URL_Var,VarStr),
	str_to_url(URL_Op,OpStr),
	write("<form name=\"dlgform\">"),nl,
	write("<input type=\"hidden\" name=\"clauses\" value=\""),
	write(URL_Clau),
	write("\">"),nl,
	write("<input type=\"hidden\" name=\"vars\" value=\""),
	write(URL_Var),
	write("\">"),nl,
	write("<input type=\"hidden\" name=\"ops\" value=\""),
	write(URL_Op),
	write("\">"),nl,
	write("<input type=\"hidden\" name=\"trace\" value=\"",TraceFlag,"\">"),nl,
	write("</form>"),nl,
	%
	%  Finish Document
	%
	write("</body>"),nl,
	write("</html>"),nl.

PREDICATES
  procedure handle_usergoal(STERM)
  procedure scan_parse(STRING,STERM)
  procedure init_counter
  procedure count
  procedure wsol(INTEGER)
  procedure wenv(ENV)
  procedure errorhnd(INTEGER)

CLAUSES
  pie_member(X,[X|_]).
  pie_member(X,[_|Y]):-pie_member(X,Y).
  
  runme(ParmList) :-
  	pie_member(parm("Run",_),ParmList),
  	pie_member(parm("Goal",URL_Goal),ParmList),
  	pie_member(parm("clauses",URL_Clauses),ParmList),
  	pie_member(parm("vars",URL_Vars),ParmList),
  	pie_member(parm("ops",URL_Ops),ParmList),
  	pie_member(parm("trace",TraceFlag),ParmList),
	URL_Goal><"",
	url_to_str(URL_Goal,TheGoal),
	url_to_str(URL_Clauses,TheClauses),
	url_to_str(URL_Vars,TheVars),
	url_to_str(URL_Ops,TheOps),
	restore_Clauses(TheClauses),
	restore_Vars(TheVars),
	restore_Ops(TheOps),
	restore_Trace(TraceFlag),
	init_counter,
  	scan_parse(TheGoal,TERM),
  	trap(handle_usergoal(TERM),E,errorhnd(E)),
  	retractall(topmost(_)),
	fail.
  runme(ParmList) :-
  	pie_member(parm("Reconsult",_),ParmList),
  	pie_member(parm("Text",URL_Text),ParmList),
	URL_Text><"",
	url_to_str(URL_Text,TheText),
	recons_text(TheText),
	write("Reconsulted"),nl,
	fail.
  runme(ParmList) :-
  	pie_member(parm("Reset",_),ParmList),
	retractall(clause(_,_)),
	write("The PIE database is clear"),nl,
	fail.
  runme(_).

  handle_usergoal(cmp(":-",[HEAD,BODY])):-!,
	convhead(HEAD,HEAD1),
	ascla('z',HEAD1,BODY),
	write("Asserted ",HEAD1).
  handle_usergoal(TERM):-
  	free(ENV),
	getbacktrack(BTOP),
	retractall(topmost(_)),
	assert(topmost(BTOP)),
	unify_body(TERM,ENV,BTOP),
	wenv(ENV),nl,
	count,
	free(ENV), % Give only one solution when there are no variables
	cutbacktrack(BTOP),
	fail.
  handle_usergoal(_):-
	closefile(seeing),closefile(telling),
	counter(X),wsol(X),
	ifdef use_extdbase
	  db_statistics(clause_db,NoOfRecords,MemSize,DbaSize,FreeSize),
	  writef("\nNoOfRecords=%, MemSize=%, DbaSize=%, Freesize=%",NoOfRecords,MemSize,DbaSize,FreeSize),
	  storage(SS,HH,TT),
	  writef("\nStack=%, Heap=%, Trail=%",SS,HH,TT),
	enddef
	!.

  scan_parse(STR,TERM):-
	tokl(0,STR,TOKL),
	s_term(TOKL,_,TERM),!.
  scan_parse(_,_):-write(">> Syntax error"),nl,fail.

  errorhnd(0):-!.
  errorhnd(-1):-!,exit.
  errorhnd(ErrorNo):-
  	syspath(ExeStartupPath,_),
  	format(ErrFile,"%s\\prolog.err",ExeStartupPath),
	errormsg(ErrFile,ErrorNo,ErrorMsg,Extra),
	write(ErrorMsg,"\n",Extra).

  init_counter:-
	retractall(_,counter),assert(counter(0)).

  count:-retract(counter(N)),N1=N+1,assert(counter(N1)).

  wsol(0):-!,write("No solutions"),nl.
  wsol(1):-!,write("1 Solution"),nl.
  wsol(N):-write(N," Solutions"),nl.

  wenv(L):-free(L),!,write("\nTrue").
  wenv([e(VAR,TERM)|T]):-free(T),!,write(VAR,"= "),wterm("write",TERM).
  wenv([e(VAR,TERM)|T]):-write(VAR,"= "),wterm("write",TERM),write(", "),wenv(T).

  trace(off) :- retractall(traceflag).
  trace(on) :- retractall(traceflag),assert(traceflag).
  
  pause(off) :- retractall(pause_execution).
  pause(on) :- retractall(pause_execution),assert(pause_execution).
  
  resume_execution :- retractall(stop_execution).
  break_execution:- retractall(stop_execution),assert(stop_execution).
  
  is_system_trace :- traceflag.
  is_system_paused :- pause_execution.
  
  get_clause_list(RUN_PREDICATES) :-
  	findall(X,clause(cmp(X,_),_), SLIST1 ),
	remove_duplicates(SLIST1,RUN_PREDICATES).

  reset_engine :-
  	retractall(clause(_,_)).

/******************************************************
	Save/Restore the Interpretter Database
******************************************************/
PREDICATES
  nondeterm retrieve_clause(clause_)
  nondeterm retrieve_var   (variable_)
  nondeterm retrieve_op    (op_)
  procedure restore_ClauList(clau_list)
  procedure restore_VarList (var_list)
  procedure restore_OpList  (op_list)
  procedure assert_operand  (PRIOR,XFY,OP)
CLAUSES
  save_Clauses(ClauStr) :-
  	findall(C,retrieve_clause(C),CL),
  	term_str(clau_list,CL,ClauStr).
  save_Vars(VarStr) :-
  	findall(V,retrieve_var(V),VL),
  	term_str(var_list,VL,VarStr).
  save_Ops(OpStr) :-
  	findall(O,retrieve_op(O),OL),
  	term_str(op_list,OL,OpStr).
  save_Trace("1") :-
  	traceflag,!.
  save_Trace("0").
  	
  restore_Clauses(ClauStr) :-
  	term_str(clau_list,CL,ClauStr),
  	retractall(clause(_,_)),
  	restore_ClauList(CL).
  	
  restore_Vars(VarStr) :-
  	term_str(var_list,VL,VarStr),
  	retractall(variable(_,_)),
  	restore_VarList(VL).
  
  restore_Ops(OpStr) :-
  	term_str(op_list,OL,OpStr),
  	restore_OpList(OL).
  	
  retrieve_clause(C) :-
  	clause(Head,Body),
  	C = clause_(Head,Body).
  	
  retrieve_var(V) :-
  	variable(ID,VAL),
  	V = variable_(ID,VAL).
  	
  retrieve_op(O) :-
  	op(PRIOR,XFY,OP),
  	O = op_(PRIOR,XFY,OP).
  	
  restore_ClauList([]).
  restore_ClauList([H|T]) :-
  	H = clause_(Head,Body),
  	assert(clause(Head,Body)),
  	restore_ClauList(T).
  	
  restore_VarList([]).
  restore_VarList([H|T]) :-
  	H = variable_(ID,VAL),
  	assert(variable(ID,VAL)),
  	restore_VarList(T).
  
  restore_OpList([]).
  restore_OpList([H|T]) :-
  	H = op_(PRIOR,XFY,OP),
  	assert_operand(PRIOR,XFY,OP),
  	restore_OpList(T).
  	
  assert_operand(PRIOR,XFY,OP) :-
  	op(PRIOR,XFY,OP),!.
  assert_operand(PRIOR,XFY,OP) :-
  	assert(op(PRIOR,XFY,OP)).
  	
  restore_Trace("1") :- !,
  	retractall(traceflag),
  	assert(traceflag).
  restore_Trace(_) :-
  	retractall(traceflag).
  	
/******************************************************
        URLE to/from STRING convertion
******************************************************/
PREDICATES
  decode_char(char,integer)
  isalnum(char)
  
  procedure decode_url_str(long,long,long)
  procedure encode_url_str(long,long,long)
  
  procedure decode_url_char(char,char,long,integer)
  procedure encode_url_char(char,long,integer)
  
  procedure count_spec(long,long,integer,integer)
  
CLAUSES

  str_to_url(URL,Str) :-
  	PSTR=cast(long,Str),
  	str_len(Str,Len),
  	PEND=PSTR+Len,
  	count_spec(PSTR,PEND,0,Count),
  	NewLen=Len+Count+Count,
  	str_len(URL,NewLen),
  	PURL=cast(long,URL),
  	encode_url_str(PSTR,PURL,PEND).
  	  	
  url_to_str(URL,OutStr) :-
  	str_len(URL,Len),
  	str_len(Str,Len),
  	PURL=cast(long,URL),
  	PSTR=cast(long,Str),
  	PEND=PURL+Len,
  	decode_url_str(PURL,PSTR,PEND),
  	concat(Str,"",OutStr).
  	
%  decode_url_str(PEND,PSTR,PEND):-!,
%  	Cur=cast(string,PSTR),
%  	membyte(Cur,'\0').
  decode_url_str(PURL,PSTR,_):-
  	CurURL=cast(string,PURL),
  	CurStr=cast(string,PSTR),
  	membyte(CurURL,CH),CH='\0',!,
  	membyte(CurStr,CH).
  decode_url_str(PURL,PSTR,PEND) :-
  	CurURL=cast(string,PURL),
  	membyte(CurURL,URL_CH),
  	decode_url_char(URL_CH,STR_CH,PURL,Shift),
  	CurStr=cast(string,PSTR),
  	membyte(CurStr,STR_CH),
  	NextPURL=PURL+Shift,
  	NextPSTR=PSTR+1,!,
  	decode_url_str(NextPURL,NextPSTR,PEND).
/*  	
  encode_url_str(PEND,PURL,PEND):-!,
  	Cur=cast(string,PURL),
  	membyte(Cur,'\0').
*/
  encode_url_str(PSTR,PURL,_PEND):-
  	CurURL=cast(string,PURL),
  	CurStr=cast(string,PSTR),
  	membyte(CurStr,CH),CH='\0',!,
  	membyte(CurURL,CH).
  encode_url_str(PSTR,PURL,PEND) :-
  	CurStr=cast(string,PSTR),
  	membyte(CurStr,STR_CH),
  	encode_url_char(STR_CH,PURL,Shift),
  	NextPSTR=PSTR+1,!,
  	NextPURL=PURL+Shift,
  	encode_url_str(NextPSTR,NextPURL,PEND).
  	
  decode_url_char('+',' ',_PURL,1):-!.
  decode_url_char('%',NextCH,PURL,3):-
  	PURL1=PURL+1,
  	PURL2=PURL+2,
  	CurURL1=cast(string,PURL1),
  	CurURL2=cast(string,PURL2),
  	membyte(CurURL1,CH1),
  	membyte(CurURL2,CH2),
  	decode_char(CH1,HighQu),
        decode_char(CH2,LowQu),
        AsciiCode = HighQu*16 + LowQu,
        char_int(NextCH,AsciiCode),!.
  decode_url_char(CH,CH,_PURL,1):-!.
  
  encode_url_char(' ',PURL,1) :-!,
  	CurURL=cast(string,PURL),
  	membyte(CurURL,'+').
  encode_url_char(CH,PURL,3) :-
  	not(isalnum(CH)),!,
  	format(Hex,"%x",CH),
  	PHex=cast(long,Hex),
  	PHex1=PHex+1,
  	Hex1=cast(string,PHex1),
  	membyte(Hex,CH0),
  	membyte(Hex1,CH1),
  	PURL1=PURL+1,
  	PURL2=PURL+2,
  	CurURL=cast(string,PURL),
  	CurURL1=cast(string,PURL1),
  	CurURL2=cast(string,PURL2),
  	membyte(CurURL,'%'),
  	membyte(CurURL1,CH0),
  	membyte(CurURL2,CH1).
  encode_url_char(CH,PURL,1) :-!,
  	CurURL=cast(string,PURL),
  	membyte(CurURL,CH).
  
  % Primitive char_to_hex convertion
  decode_char(C,HV) :-
        '0' <= C , C <= '9' ,!,
                HV = C - '0' .
  decode_char(C,HV) :-
        'A' <= C , C <= 'F' ,!,
                HV = C - 'A' + 10.
  decode_char(C,HV) :-
        'a' <= C , C <= 'f' ,!,
                HV = C - 'a' + 10.

  isalnum(C) :- '0' <= C , C <= '9' ,!.
  isalnum(C) :- 'A' <= C , C <= 'Z' ,!.
  isalnum(C) :- 'a' <= C , C <= 'z'.

  count_spec(PSTR,PSTR,Count,Count):-!.
  count_spec(PSTR,PEND,B,Count):-
  	CurStr=cast(string,PSTR),
  	membyte(CurStr,CH),
  	not(isalnum(CH)),
  	B1=B+1,
  	PNext=PSTR+1,!,
  	count_spec(PNext,PEND,B1,Count).
  count_spec(PSTR,PEND,B,Count):-
  	PNext=PSTR+1,!,
  	count_spec(PNext,PEND,B,Count).
  	
    	