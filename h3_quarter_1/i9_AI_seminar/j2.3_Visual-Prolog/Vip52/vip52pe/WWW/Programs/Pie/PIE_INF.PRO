/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  PIE
 FileName: PIE.INF
 Purpose: The inference engine
 Written by: PDC.
 Comments:
******************************************************************************/

/*****************************************************************************
		General Help predicates
*****************************************************************************/

PREDICATES
  listlen(TERML,LONG,LONG) % Gives the length of a list
  listlen(STERML,LONG,LONG)
  member(E,ENV)			 % The god old member
  member(STRING,SLIST)
  nondeterm repeat		 % The even older repeat
  nondeterm for(LONG,LONG,LONG)
  getfilename(TERM,STRING)	 % construct the filename with extension
  remove_duplicates(SLIST,SLIST)
  
CLAUSES

  remove_duplicates([],[]):-!.
  remove_duplicates([X|T],[X|RESULT]):-
  	not (member(X,T)),!,
  	remove_duplicates(T,RESULT).
  remove_duplicates([_|T],RESULT):-
  	remove_duplicates(T,RESULT).

  listlen([],N,N):-!.
  listlen([_|T],SUB,N):-SUB1=SUB+1,listlen(T,SUB1,N).

  member(X,[X|_]):-!.
  member(X,[_|L]):-member(X,L).

  repeat.
  repeat:-repeat.

  for(I,I,_).
  for(I,Start,Stop):-
	Start < Stop,Next=Start+1,
	for(I,Next,Stop).

  getfilename(atom(S),FILENAME):-!,
	concat(S,".pro",FILENAME).
  getfilename(str(FILENAME),FILENAME).

/*****************************************************************************
	Expression evaluation
*****************************************************************************/

PREDICATES
  eval(TERM,REFINT)

CLAUSES
  eval(T,_):- free(T), !, fail.  % or 'exit(1040)' free var not allowed
  eval(int(I),I):- !.
  eval(cmp("+",[T1,T2]),R):- !, eval(T1,R1), eval(T2,R2), R=R1+R2.
  eval(cmp("-",[T1,T2]),R):- !, eval(T1,R1), eval(T2,R2), R=R1-R2.
  eval(cmp("*",[T1,T2]),R):- !, eval(T1,R1), eval(T2,R2), R=R1*R2.
  eval(cmp("/",[T1,T2]),R):- !, eval(T1,R1), eval(T2,R2), R=R1/R2.
  eval(cmp("-",[T1]),R):-    !, eval(T1,R1), R=-R1.
  eval(cmp("mod",[T1,T2]),R):- !, eval(T1,R1), eval(T2,R2), R=R1 mod R2.
  eval(cmp("div",[T1,T2]),R):- !, eval(T1,R1), eval(T2,R2), R=R1 div R2.
  eval(cmp("abs",[T]),R):- !, eval(T,R1),R=abs(R1).


/*****************************************************************************
	File system
*****************************************************************************/

DATABASE - seetell
  determ seeing_name(STRING)
  determ telling_name(STRING)

PREDICATES
  tell(STRING)
  telling(STRING)
  told
  see(STRING)
  seeing(STRING)
  seen
  handle_eof

CLAUSES
  tell(FILENAME):-
	closefile(telling),
	openwrite(telling,FILENAME),
	writedevice(telling),
	retractall(telling_name(_)),
	assert(telling_name(FILENAME)).

  telling(FILENAME):-
	telling_name(FILENAME).

  told:-
	retract(telling_name(_)),!,
	closefile(telling).
  told.

  see(FILENAME):-
	closefile(seeing),
	openread(seeing,FILENAME),
	readdevice(seeing),
	retractall(seeing_name(_)),
	assert(seeing_name(FILENAME)).

  seeing(FILENAME):-
	seeing_name(FILENAME).

  seen:-
	retract(seeing_name(_)),!,
	closefile(seeing).
  seen.

  handle_eof:-
  	seeing_name(_),!,
  	eof(seeing).

/*****************************************************************************
		Handle clause listing
*****************************************************************************/


ifdef use_extdbase
PREDICATES
  nondeterm clause(STERM,STERM)

CLAUSES
  clause(H,B):-
	db_chains(clause_db,CHAIN),
	chain_terms(clause_db,CHAIN,clause,clause(H,B),_).
enddef


PREDICATES
  nondeterm named_clause(STRING,STERML,STERM)
 determ 	get_variable(STRING,TERM) - (i,o)

CLAUSES
  get_variable(NAME,VALUE):-
  	  variable(NAME,VALUE),!.

  named_clause(PID,TERML,B):-
        ifdef use_extdbase
	  chain_terms(clause_db,PID,clause,clause(cmp(PID,TERML),B),_).
        elsedef
	  clause(cmp(PID,TERML),B).
        enddef


PREDICATES
  list
  list(STRING)
  list(STRING,LONG)
  wclause(STERM,STERM)
  wor(STERM,LONG)
  wand(STERM,LONG)
  handle_list(TERML)
  indent(LONG)

CLAUSES
  wclause(HEAD,atom(true)):-!,
	write("  "),
	wterm("list",HEAD),
	write(".\n").
  wclause(HEAD,BODY):-
	write("  "),
	wterm("list",HEAD),
	write(":-\n"),
	wor(BODY,1),
	write(".\n").

  wor(cmp(";",[G,GG]),INDENT):-!,
	Indent1=INDENT+1,
	wor(G,INDENT1),
	nl,
	indent(INDENT),write(";\n"),
	wor(GG,INDENT1).
  wor(G,INDENT):-wand(G,INDENT).


  wand(cmp(",",[G,GG]),Indent) :-!,
	indent(Indent),
	wterm("list",G),nl,
	wand(GG,Indent).
  wand(G,Indent) :-
	indent(Indent),
	wterm("list",G).

  indent(0):-!.
  indent(N):-N1=N-1,write('\t'),indent(N1).


  % list all clauses in the database
  list:-
        ifdef use_extdbase
  	  db_chains(clause_db,CHAIN),
	  chain_first(clause_db,CHAIN,FIRST),
	  ref_term(clause_db,clause,FIRST,clause(cmp(_,ARGL),_)),
	  listlen(ARGL,0,N),
	  write("\n  % ",CHAIN,'/',N),nl,
	  chain_terms(clause_db,CHAIN,clause,clause(H,B),_),
        elsedef
          clause(H,B),
        enddef
	  wclause(H,B),fail.
  list.

  % list  pred for all arities
  list(ID):-
	named_clause(ID,TERML,BODY),
	wclause(cmp(ID,TERML),BODY),
	fail.
  list(_).

  % list  pred/arity
  list(ID,N):-
	named_clause(ID,TERML,BODY),
	listlen(TERML,0,N),
	wclause(cmp(ID,TERML),BODY),
	fail.
  list(_,_).

  handle_list([]):-!,list.
  handle_list([atom(Pid)]):-!,list(PID).
  handle_list([cmp("/",[atom(PID),int(N)])]):-list(PID,N).

/*****************************************************************************
		Handle assert
*****************************************************************************/

PREDICATES
  convhead(STERM,STERM)
  ascla(CHAR,STERM,STERM)
  assertclause(CHAR,STERM)

CLAUSES
  convhead(atom(ID),cmp(ID,[])):-!.
  convhead(HEAD,HEAD).

  ascla('a',cmp(PID,TERML),B):-!,
        ifdef use_extdbase
	  chain_inserta(clause_db,PID,clause,clause(cmp(PID,TERML),B),_).
        elsedef
	  asserta(clause(cmp(PID,TERML),B)).
	enddef
  ascla(_,cmp(PID,TERML),B):-
        ifdef use_extdbase
	  chain_insertz(clause_db,PID,clause,clause(cmp(PID,TERML),B),_).
        elsedef
	  assertz(clause(cmp(PID,TERML),B)).
	enddef

  assertclause(C,cmp(":-",[HEAD,BODY])):-!,
	convhead(HEAD,HEAD1),
	ascla(C,HEAD1,BODY).
  assertclause(C,HEAD):-
	convhead(HEAD,HEAD1),
	ascla(C,HEAD1,atom(true)).

/*****************************************************************************
		Handle Consult
*****************************************************************************/

PREDICATES
  cons(STRING)
  sav(STRING)
  parse_clauses(TOKL)

CLAUSES
  parse_clauses([]):-!.
  parse_clauses(TOKL):-
	s_term(TOKL,TOKL1,TERM),!,
	assertclause('0',TERM),
	parse_clauses(TOKL1).
  parse_clauses(_).

  cons(FIL):-
	file_str(FIL,TXT),
	tokl(0,TXT,TOKL),!,
	parse_clauses(TOKL).
  cons(_).

  sav(FIL):-
	openwrite(temp,FIL),
	writedevice(temp),
	list,
	closefile(temp).

/*****************************************************************************
		Handle ReConsult
*****************************************************************************/

PREDICATES
  recons(STRING)
  %recons_text(STRING) - declared as global
  recons_parse(TOKL)
  recons_newclause(STERM)
  recons_newclause_change(STERM,STERM)
  recons_delete_old(STRING)

DATABASE - reconsulted
  removed(STRING)

CLAUSES
  recons_delete_old(PID):-
	ifdef use_extdbase
	  chain_delete(clause_db,PID),!.
	elsedef
	  retractall(clause(cmp(PID,_),_)),!.
	enddef
  recons_delete_old(_).

  recons_newclause_change(cmp(PID,TERML),BODY):-
	not(removed(PID)),
	recons_delete_old(PID),
	assert(removed(PID)),
	fail;
	ascla('0',cmp(PID,TERML),BODY).

  recons_newclause(cmp(":-",[HEAD,BODY])):-!,
	convhead(HEAD,HEAD1),
	recons_newclause_change(HEAD1,BODY).
  recons_newclause(HEAD):-
	convhead(HEAD,HEAD1),
	recons_newclause_change(HEAD1,atom(true)).

  recons_parse(TOKL):-
	s_term(TOKL,TOKL1,TERM),!,
	recons_newclause(TERM),
	recons_parse(TOKL1).
  recons_parse(_).

  recons(FIL):-
	retractall(_,reconsulted),
	file_str(FIL,TXT),
	recons_text(TXT).

  recons_text(TXT):-
	retractall(_,reconsulted),
	tokl(0,TXT,TOKL),!,
	recons_parse(TOKL).
  recons_text(_).

/*****************************************************************************
		Handle editor
*****************************************************************************/
/*
PREDICATES
  ed
  ed(STRING)
  ed(STRING,INTEGER)
  handle_edit(TERML)

CLAUSES
  ed:-
	ifdef wdwmode
	  filenameunique("",TempName),
	  openwrite(temp,TempName),
	  writedevice(temp),
	  list,
	  writedevice(screen),
	  closefile(temp),
	  file_str(TempName,TXT),
	  deletefile(TempName),
	  makewindow(1,2,23,"CLAUSES",5,5,15,70),
	  edit(TXT,TXT1),
	  removewindow,
	  shiftwindow(OLD),shiftwindow(1),shiftwindow(OLD),
	  TXT1><TXT,
	  recons_text(TXT1).
	elsedef
	  filenameunique("",TempName),
	  openwrite(temp,TempName),
	  writedevice(OldOut),
	  writedevice(temp),
	  list,
	  writedevice(OldOut),
	  closefile(temp),
	  vitmp(TempName),
	  file_str(TempName,TXT),
	  deletefile(TempName),
	  recons_text(TXT).
	enddef

  ed(FILENAME):-
	ifdef wdwmode
	  file_str(FILENAME,TXT),
	  makewindow(1,2,23,"CLAUSES",5,5,15,70),
	  edit(TXT,TXT1),
	  removewindow,
	  shiftwindow(OLD),shiftwindow(1),shiftwindow(OLD),
	  file_str(FILENAME,TXT1),
	  recons_text(TXT1).
	elsedef
	  vi(FILENAME),
	  existfile(FILENAME),
	  recons(FILENAME).
	enddef

  ed(ID,N):-
	ifdef wdwmode
	  filenameunique("",TempName),
	  openwrite(temp,TempName),
	  writedevice(temp),
	  list(ID,N),
	  writedevice(screen),
	  closefile(temp),
	  file_str(TempName,TXT),
	  deletefile(TempName),
	  makewindow(1,2,23,"CLAUSES",5,5,15,70),
	  edit(TXT,TXT1),
	  removewindow,
	  shiftwindow(OLD),shiftwindow(1),shiftwindow(OLD),
	  TXT1><TXT,
	  recons_text(TXT1).
	elsedef
	  filenameunique("",TempName),
	  openwrite(temp,TempName),
	  writedevice(OldOut),
	  writedevice(temp),
	  list(ID,N),
	  writedevice(OldOut),
	  closefile(temp),
	  vitmp(TempName),
	  file_str(TempName,TXT),
	  deletefile(TempName),
	  recons_text(TXT).
	enddef

  handle_edit([]):-!,
	ed.
  handle_edit([cmp("/",[atom(PID),int(N)])]):-
	bound(PID),bound(N),!,
	ed(PID,N).
  handle_edit([TERM]):-!,
	bound(TERM),getfilename(TERM,FILENAME),ed(FILENAME).
*/
/*****************************************************************************
	Misc help predicates for implementing standard predicates
*****************************************************************************/

PREDICATES
  eeq(TERM,TERM)		% True equality
  eeqterml(TERML,TERML)
  list_terml(TERM,TERML)	% Conversion between list and TERML
  retractclause(STERM,STERM)	% Used to give a deterministic retract
  nondeterm handle_op(REFINT,REFSYMB,REFSYMB).
  functor(TERM,REFSYMB,REFINT)
  arg(INTEGER,TERML,TERM)
  writeterml(MODE,TERML)

CLAUSES
  eeq(T1,T2):-free(T1),free(T2),T1=int(0),T2=int(1),!,fail.
  eeq(T1,T2):-free(T1),free(T2),!.
  eeq(T1,T2):-free(T1),!,fail; free(T2),!,fail.
  eeq(cmp(ID,TERML1),cmp(ID,TERML2)):-!,eeqterml(TERML1,TERML2).
  eeq(list(H1,T1),list(H2,T2)):-!,eeq(H1,H2),eeq(T1,T2).
  eeq(X,X).

  eeqterml([],[]):-!.
  eeqterml([H1|T1],[H2|T2]):-
	eeq(H1,H2),eeqterml(T1,T2).

  list_terml(nill,[]):-!.
  list_terml(list(H,T),[H|TT]):-list_terml(T,TT).

  retractclause(cmp(PID,TEML),BODY):-
	ifdef use_extdbase
	  chain_terms(clause_db,PID,clause,TERM,REF),
	  TERM=clause(cmp(PID,TEML),BODY),!,
	  term_delete(clause_db,PID,REF).
	elsedef
	  retract(clause(cmp(PID,TEML),BODY)),!.
	enddef

  handle_op(PRIOR,XFY,OP):-
	bound(PRIOR),bound(XFY),bound(OP),!,
	PRIOR1=PRIOR,XFY1=XFY,OP1=OP,
	retractall(op(_,_,OP1)),
	assert(op(PRIOR1,XFY1,OP1)).
  handle_op(PRIOR,XFY,OP):-
	op(P1,A1,O1),
	P1=PRIOR,A1=XFY,O1=OP.

  functor(cmp(ID,TERML),ID,N):-
	bound(N),!,bound(ID),listlen(TERML,0,N).
  functor(cmp(ID,TERML),ID,N):-!,
	bound(ID),free(N),
	listlen(TERML,0,N1),N=N1.
  functor(atom(S),S,0):-!.

  arg(1,[X|_],X):-!.
  arg(N,[_|T],X):-
	N1=N-1,
	arg(N1,T,X).

  writeterml(_,[]):-!.
  writeterml(DISPLAY,[H|T]):-wterm(DISPLAY,H),writeterml(DISPLAY,T).

/*****************************************************************************
	Variable name generator for assert of rules
*****************************************************************************/

DATABASE - varno
  determ current_var(INTEGER)

PREDICATES
  reset_vargenerator
  createVar(TERM,ENV,STRING)
  lookup_termid(TERM,ENV,STRING)
  get_next_unused(ENV,LONG,LONG,STRING)
  vid_exist(STRING,ENV)

CLAUSES
  reset_vargenerator:-
	retractall(current_var(_)),
	assert(current_var(0)).

  createVar(TERM,ENV,ID):-
	lookup_termid(TERM,ENV,ID),!.
  createVar(TERM,ENV,NEWID):-
	retract(current_var(NO)),
	NO1=NO+1,
	get_next_unused(ENV,NO1,NO2,NEWID),
	member(e(NEWID,TERM),ENV),
	assert(current_var(NO2)).

  lookup_termid(_,ENV,_):-free(ENV),!,fail.
  lookup_termid(TERM,[e(ID,TERM1)|_],ID):-
	eeq(TERM,TERM1),!.
  lookup_termid(TERM,[_|ENV],ID):-
	lookup_termid(TERM,ENV,ID).

  get_next_unused(ENV,NO,NO,NEWID):-
	str_int(ID,NO),concat("_",ID,NEWID),
	not(vid_exist(NEWID,ENV)),!.
  get_next_unused(ENV,NO1,NO3,ID):-
	NO2=NO1+1,
	get_next_unused(ENV,NO2,NO3,ID).

  vid_exist(_,ENV):-free(ENV),!,fail.
  vid_exist(VID,[e(VID,_)|_]):-!.
  vid_exist(VID,[_|L]):-vid_exist(VID,L).

/*****************************************************************************
	Implementation of trace
*****************************************************************************/
ifdef implement_trace
PREDICATES
  showtrace(STRING,STRING,TERML)
  nondeterm trace_call(STRING,TERML)
  nondeterm report_redo(STRING,TERML)
CLAUSES
 /*
  trace_call(_,_):-retract(stop_execution),!,
  	retract(topmost(BTOP)),
  	cutbacktrack(BTOP),
  	fail.
  */
  trace_call(_,_):-date(Year,Month,_),Year=1996,Month>10,!,fail.
  trace_call(PID,TERML):-not(traceflag),!,
  	upper_lower(PID,LOWER_CALLNAME),
  	call(LOWER_CALLNAME,TERML).
  trace_call(PID,TERML):-
  	upper_lower(PID,LOWER_CALLNAME),
  	%call(LOWER_CALLNAME,TERML),
	showtrace("CALL:   ",PID,TERML),
	call(LOWER_CALLNAME,TERML),
	report_redo(LOWER_CALLNAME,TERML),
	showtrace("RETURN: ",PID,TERML).
  trace_call(PID,TERML):-
	showtrace("FAIL:   ",PID,TERML),
	fail.

  report_redo(_,_).
  report_redo(PID,TERML):-
	showtrace("REDO:   ",PID,TERML),
	fail.

  showtrace(STR,PID,TERML):-
	  write("Trace: >> ",STR),
	  wterm("write",cmp(PID,TERML)),nl,
	  !.
elsedef  % call the predicate "call" directly

CONSTANTS
  trace_call = call
enddef

/*****************************************************************************
	The inference engine
*****************************************************************************/

PREDICATES
  % nondeterm call(STRING,TERML) declared as first predicate due to memory problems
  unify_term(TERM,STERM,ENV)
  unify_terml(TERML,STERML,ENV)
  nondeterm unify_body(STERM,ENV,LONG)
  handle_assert(CHAR,STERM,ENV)
%  nondeterm handle_retract(TERM)
  term_to_slist(TERM,SLIST)
  %term_to_slist(STERM,SLIST)
  stringlist_to_term(SLIST,TERM)
  slist_to_string(SLIST,STRING)
  %slist_to_parm_str(SLIST,STRING)
  string_slist(STRING,SLIST)
  /* TREE SUPPORT */
  sort(SLIST,SLIST)
  sort(SLIST,SLIST,SLIST)
  split(SLIST,STRING,SLIST,SLIST)
  
  %tok_value(CURSORTOK,STRING VALUE)
CLAUSES

%tok_value(t(atom(VALUE),_),VALUE):-!.
%tok_value(t(int(VALUE),_),VAL):-str_long(VAL,VALUE),!.
%tok_value(INVALID,_):-write(">> Invalid token ",INVALID),nl,fail.

    sort(LIST,RESULT):-
          sort(LIST,[],RESULT).    
    sort([HEAD|TAIL],SORTEDBIGGER,RESULT):-
          split(TAIL,HEAD,LESSLIST,BIGGERLIST),
          sort(BIGGERLIST,SORTEDBIGGER,NEWSORTEDBIGGER),
          sort(LESSLIST,[HEAD|NEWSORTEDBIGGER],RESULT).
    sort([],SORTED,SORTED).

    split([],_,[],[]).
    split([Y|L],X,[Y|L1],L2):-Y<X,!,split(L,X,L1,L2).
    split([Y|L],X,L1,[Y|L2]):-split(L,X,L1,L2).

  stringlist_to_term([],nill).
  stringlist_to_term([H|TAIL],list(str(H),SubList)):-
	stringlist_to_term(TAIL,SubList).

  term_to_slist(nill,[]):-!.
  term_to_slist(list(str(S),TAIL),[S|RESULT]):-
  	term_to_slist(TAIL,RESULT).

  slist_to_string([],""):-!.
  slist_to_string([H|T],RESULT):-
  	slist_to_string(T,TEMP),
  	concat(H,TEMP,RESULT).
/*
  slist_to_parm_str([H],RESULT):-!,format(RESULT,"\"%\"",H).
  slist_to_parm_str([H|T],RESULT):-
  	slist_to_parm_str(T,TEMP),
  	format(RESULT,"\"%\",%",H,TEMP).
*/
  string_slist(STRING,[H|TAIL]):-
  	fronttoken(STRING,H,REST),!,
  	string_slist(REST,TAIL).
  string_slist(STRING,[STRING]).

  handle_assert(Poscode,TERM,ENV):-
	unify_term(CALL,TERM,ENV),
	reset_vargenerator,
	unify_term(CALL,STERM,ENV),
	assertclause(Poscode,STERM),
	fail.	% Remove generated identifiers from environment
  handle_assert(_,_,_).

  handle_retract(cmp(":-",[cmp(ID,TERML),BODY])):-
	bound(ID),!,
	named_clause(ID,STERML,SBODY),
	free(ENV),
	unify_terml(TERML,STERML,ENV),
	unify_term(BODY,SBODY,ENV),
	retractclause(cmp(ID,STERML),SBODY),true.

  handle_retract(cmp(":-",[HEAD,BODY])):-free(HEAD),!,
	clause(SHEAD,SBODY),
	free(ENV),
	unify_term(HEAD,SHEAD,ENV),
	unify_term(BODY,SBODY,ENV),
	retractclause(SHEAD,SBODY),true.

  handle_retract(cmp(ID,TERML)):-
	named_clause(ID,TERML1,atom(true)),
	free(ENV),
	unify_terml(TERML,TERML1,ENV),
	retractclause(cmp(ID,TERML1),atom(true)),true.


  unify_terml([],[],_):-!.
  unify_terml([TERM1|TL1],[TERM2|TL2],ENV):-
	unify_term(TERM1,TERM2,ENV),unify_terml(TL1,TL2,ENV).

  unify_term(TERM,var(ID),ENV):-free(ID),free(TERM),!,createVar(TERM,ENV,ID).
  unify_term(_,STerm,_):-bound(STerm),Sterm=var("_"),!.
  unify_term(Term,var(ID),ENV):-bound(ID),!,member(e(ID,Term1),ENV),Term1=Term.
  unify_term(int(I),int(I),_):-!.
  unify_term(atom(A),atom(A),_):-!.
  unify_term(str(S),str(S),_):-!.
  unify_term(char(C),char(C),_):-!.
  unify_term(list(H1,T1),list(H2,T2),ENV):-!,
	unify_term(H1,H2,ENV),unify_term(T1,T2,ENV).
  unify_term(nill,nill,_):-!.
  unify_term(cmp(ID,L1),cmp(ID,L2),ENV):-!,unify_terml(L1,L2,ENV).

  unify_body(atom(true),_,_):-!.
  unify_body(cmp(",",[TERM1,TERM2]),ENV,BTOP):-!,
	unify_body(TERM1,ENV,BTOP),unify_body(TERM2,ENV,BTOP).
  unify_body(atom("!"),_,BTOP):-!,cutbacktrack(BTOP).
  unify_body(cmp(";",[TERM,_]),ENV,BTOP):-unify_body(TERM,ENV,BTOP).
  unify_body(cmp(";",[_,TERM]),ENV,BTOP):-!,unify_body(TERM,ENV,BTOP).
  unify_body(cmp("not",[TERM]),ENV,_):-
	getbacktrack(BTOP),unify_body(TERM,ENV,BTOP),!,fail.
  unify_body(cmp("not",_),_,_):-!.
  unify_body(cmp("call",[TERM]),ENV,_):-!,
	getbacktrack(BTOP),unify_body(TERM,ENV,BTOP).
  unify_body(cmp("assert",[TERM]),ENV,_):- !,handle_assert('0',TERM,ENV).
  unify_body(cmp("asserta",[TERM]),ENV,_):-!,handle_assert('a',TERM,ENV).
  unify_body(cmp("assertz",[TERM]),ENV,_):-!,handle_assert('z',TERM,ENV).
  unify_body(cmp(PID,TERML),ENV,_):-
	unify_terml(CALL,TERML,ENV),trace_call(PID,CALL).
  unify_body(var(ID),ENV,_):-!,
	member(e(ID,TERM),ENV),bound(TERM),
	TERM=cmp(PID,TERML), trace_call(PID,TERML).
  unify_body(atom(PID),_,_):-
	trace_call(PID,[]).

  call("fail",[]):-!,fail.

  call("repeat",[]):-!,repeat.

  call("for",[int(INDEX),int(FROM),int(TO)]):-!,
  	for(I,FROM,TO),
  	INDEX = I.

  call("halt",[]):-!,exit(-1).

  call("write",TERML):-!, writeterml("write",TERML).

  call("nl",[]):-!, nl.

  call("display",TERML):-!,writeterml("display",TERML).
  
  call("read",[TERM]):-!,
	readln(L),
 	tokl(0,L,TOKL),
	s_term(TOKL,_,STERM),
	free(E),
	unify_term(TERM,STERM,E).

  call("readln",[str(L1)]):-!,
	readln(L),L1=L.

  call("readchar",[char(CH)]):-!,readchar(CH1),CH=CH1.
  
  call("eof",[]) :-!, handle_eof.

  %call("help",[]):-!,view("resolut.hlp").

  call("retract",[TERM]):-!,handle_retract(TERM).

  call("tell",[str(FILENAME)]):-!,bound(FILENAME),tell(FILENAME).
  call("telling",[str(FILENAME)]):-!,telling(FILENAME1),FILENAME=FILENAME1.
  call("told",[]):-!,told.

  call("see",[str(FILENAME)]):-!,bound(FILENAME),see(FILENAME).
  call("seeing",[str(FILENAME)]):-!,seeing(FILENAME1),FILENAME=FILENAME1.
  call("seen",[]):-!,seen.

  call("=..",[cmp(ID,TERML),list(atom(ID),LIST)]):-!,
	list_terml(LIST,TERML).

  call("arg",[int(N),cmp(FID,TERML),X]):-!,
	bound(N),bound(FID),N>0,
	arg(N,TERML,X).

  call("functor",[TERM,atom(FID),int(ARITY)]):-!,
	functor(TERM,FID,ARITY).

  call("clause",[HEAD,BODY]):-!,
	clause(SHEAD,SBODY),
	free(ENV),
	unify_term(HEAD,SHEAD,ENV),
	unify_term(BODY,SBODY,ENV).

  call("concat",[str(A),str(B),str(C)]):-!,concat(A,B,C).

  call("str_int",[str(STR),int(I)]):-!,str_long(STR,I).

  call("str_atom",[str(STR),atom(SYMB)]):-!,STR=SYMB.

  call("is",[int(Res),T2]):-!, eval(T2,Res).

  call("==",[T1,T2]):-!, eeq(T1,T2).
  call("\\==",[T1,T2]):-!, not(eeq(T1,T2)).

  call("=",[X,X]):-!.
  call("\\=",[X,Y]):-!,not(X=Y).
  call("<",[T1,T2]):-!,eval(T1,X),eval(T2,Y),X<Y.
  call(">",[T1,T2]):-!,eval(T1,X),eval(T2,Y),X>Y.
  call("=<",[T1,T2]):-!,eval(T1,X),eval(T2,Y),X<=Y.
  call(">=",[T1,T2]):-!,eval(T1,X),eval(T2,Y),X>=Y.
  call("><",[T1,T2]):-!,eval(T1,X),eval(T2,Y),X><Y.
  call("<>",[T1,T2]):-!,eval(T1,X),eval(T2,Y),X><Y.

  call("integer",[TERM]):-!,bound(TERM),TERM=int(_).

  call("var",[TERM]):-!,free(TERM).
  call("nonvar",[TERM]):-!,bound(TERM).

  call("list",TERML):-handle_list(TERML).

  %call("edit",TERML):-handle_edit(TERML).

ifdef implement_trace
  call("trace",_):-traceflag,!.
  call("trace",_):-!,assert(traceflag).
  call("notrace",_):-!,retractall(traceflag).
enddef

  call("time",[int(H),int(M),int(S),int(HH)]):-
	free(H),free(M),free(S),free(HH),!,
	time(H,M,S,HH).
  call("date",[int(Y),int(M),int(D)]):-
	free(Y),free(M),free(D),!,
	date(Y,M,D).
  call("char_int",[char(CH),int(INT)]):-!,
  	char_int(CH,INT).

  call("consult",[TERM]):-!,
	bound(TERM),getfilename(TERM,FILENAME),cons(FILENAME).

  call("reconsult",[TERM]):-!,
	bound(TERM),getfilename(TERM,FILENAME),recons(FILENAME).

  call("save",[TERM]):-!,
	bound(TERM),getfilename(TERM,FILENAME),sav(FILENAME).

  call("op",[int(PRIOR),atom(ASSOC),atom(OP)]):-!,
	handle_op(PRIOR,ASSOC,OP).


/*****************************STUFF WRITTEN BY SERG PENKOV ************/
  call("fronttoken",[str(IN),str(FRONT),str(REST)]):-!,
  	fronttoken(IN,FRONT,REST).

/* PLACE STRING IN QUOTES - 
	parser doesn't allow to enter strings with '"' inside
*/
  call("enquote_str",[str(STR),str(RESULT)]):-
  	format(MSG,"\"%s\"",STR),
  	RESULT = MSG,
  	!.
/* Enter clause in dialogue */
/*
  call("dlg_term",[TERM]):-!,
	Msg="Enter term:",
	InitStr="",
	Title="Prolog Inference Engine",
	_NewSTRING=dlg_GetStr(Title,Msg,InitStr),
  	tokl(0,_NewSTRING,TOKL),
	s_term(TOKL,_,STERM),
	free(E),
	unify_term(TERM,STERM,E).
  call("dlg_str",[str(Prompt),str(Init),str(L1)]):-!,
	Title="Enter string",
	InitStr=Init,
	_NewSTRING=dlg_GetStr(Title,Prompt,InitStr),
	L1=_NewSTRING.
  call("dlg_openfilename",[str(Title),str(Type),str(Extension),str(L1)]):-!,
	_FILENAME=dlg_GetOpenFileName("*.*",[Type,Extension],Title),
	L1 = _FILENAME.
  call("dlg_savefilename",[str(Title),str(Type),str(Extension),str(L1)]):-!,
	_FILENAME=dlg_GetSaveFileName("*.*",[Type,Extension],Title),
	L1 = _FILENAME.
  call("dlg_ask",[str(Prompt),BUTTON_LIST,int(RESULT)]):-
  	term_to_slist(BUTTON_LIST,SLIST),
	_ANSWER = dlg_Ask("Prolog Inference Engine",Prompt,SLIST),
	RESULT = _ANSWER,
	!.
*/
  call("filenamepath",[str(FILENAME),str(PATH),str(FILE)]):-
  	free(FILENAME),bound(PATH),bound(FILE),!,
  	filenamepath(TEMP,PATH,FILE),
  	FILENAME = TEMP.
  call("filenamepath",[str(FILENAME),str(PATH),str(FILE)]):-
  	free(PATH),free(FILE),bound(FILENAME),!,
  	filenamepath(FILENAME,PATH1,FILE1),
  	str_len(PATH1,PLEN),LEN = PLEN-1,frontstr(LEN,PATH1,PATH2,_),
  	PATH = PATH2, FILE = FILE1.
  call("filenameext",[str(FILENAME),str(NAME),str(EXT)]):-
  	free(FILENAME),bound(NAME),bound(EXT),!,
  	filenameext(TEMP,NAME,EXT),
  	FILENAME = TEMP.
  call("filenameext",[str(FILENAME),str(NAME),str(EXT)]):-
  	free(NAME),free(EXT),bound(FILENAME),!,
  	filenameext(FILENAME,NAME1,EXT1),
  	NAME = NAME1,frontchar(EXT1,_,EXT2),EXT = EXT2.
  call("str_toklist",[str(STRING),TOKLIST]):-
  	free(TOKLIST),bound(STRING),!,
	string_slist(STRING,TOKL),
	stringlist_to_term(TOKL,TOKLIST).
  call("str_toklist",[str(STRING),TERM]):-
  	free(STRING),bound(TERM),!,
	term_to_slist(TERM,SLIST),
	slist_to_string(SLIST,TEMP),
	STRING = TEMP,
	!.
  call("files",[str(Wild),FILELIST]):-!,
  	findall(X,dirfiles(Wild,fa_normal,X,_,_,_,_,_,_,_,_),SLIST),
  	stringlist_to_term(SLIST,Temp),
	FileList = Temp.
  call("directories",[str(Root),DirList]):-!,
  	format(Wild,"%*.*",Root),
  	findall(X,dirfiles(Wild,fa_subdir,X,_,_,_,_,_,_,_,_),SLIST),
  	sort(SLIST,SORTED),
  	stringlist_to_term(SORTED,Temp),
	DirList = Temp.
  call("filedetails",[str(File),int(Attr),int(H),int(M),int(S),int(Y),int(MM),int(D),int(SSize)]):-!,
	dirfiles(File,fa_normal,FName,RetAttr,Hour,Min,Sec,Year,Month,Day,Size),
	Fname = File,
	Attr = RetAttr, H = Hour, M = Min, S = Sec, Y = Year, MM = Month, D = Day, SSize = Size,
	!.

  /* STD syntax error handling here */
  call(CLAUSE,TERML):-
  	std_clause(CLAUSE,SYNTAX),!,
  	write("Syntax error in standard predicate ",CLAUSE),nl,
  	wterm("display<br>",cmp(CLAUSE,TERML)),nl,
  	write("Predicate syntax is\t",SYNTAX),nl,
  	write("Check number of parameters, their types and assignment."),nl,
  	fail.

  call(ID,TERML):-
	getbacktrack(BTOP),
	named_clause(ID,TERML1,BODY),
	free(ENV),
	unify_terml(TERML,TERML1,ENV),
	unify_body(BODY,ENV,BTOP).
  /*UNKNOWN CLAUSE CHECK */
  call(CLAUSE,TERML):-
  	not(clause(cmp(CLAUSE,_),_)),!,
  	write("Unknown clause found "),
  	wterm("write",cmp(CLAUSE,TERML)),
  	nl,
  	retract(topmost(TOP)),
  	cutbacktrack(TOP),
  	%assert(stop_execution),
  	write("Execution terminated"),nl,
  	fail.

