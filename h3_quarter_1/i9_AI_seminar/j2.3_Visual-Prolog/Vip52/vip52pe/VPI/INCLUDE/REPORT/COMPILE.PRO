/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S 

 FileName:	COMPILE.PRO
 Purpose:	Report Form Compile
 Written by:	Alexander Grachev
 Version:	1.3
 Build:		019.990201
 Tested with:	Visual Prolog v.5.1 build 563
 Comments:
******************************************************************************/

predicates
determ		checkempty(TOKL)
procedure	set_no_errors
clauses
   checkempty([]) :- 
   	retractall(_,keep),
   	fail.
   checkempty([]) :- !. 
   checkempty([t(T,C)|_]):-
        term_str(tok,T,STR),
	concat(re_sc02,STR,M),
	assert(err(error_at(C,M))),!,
	fail.
   set_no_errors:-
        retract(err(_)),
        fail.
   set_no_errors:-
	assert(err(no_errors)),
	!.
/***************************************************************************
*
*       The Main Compiling Predicate.
*
***************************************************************************/
predicates
procedure	compilePrint(STRING InputStr, REPORT Tree,ERR_IDENT IDError)

clauses
  compilePrint(InputStr,Report,Errors):-
	set_no_errors,
	tokl(1,InputStr,L),
ifdef toklist
	openwrite(sFN,"tokl.sav"),
	writedevice(sFN),
	write(L),
	closefile(sFN),
enddef	
	s_report(L,L1,Report),
ifdef reporttree
	openwrite(sFN,"tree.sav"),
	writedevice(sFN),
	write(Report),
	closefile(sFN),
enddef	
	checkempty(L1),
	err(Errors),
	!.
  compilePrint(_IS,REPORT,Errors):-
	retract(err(no_errors)),
        err(Errors),
	REPORT = report(name(""),[],[],script([]),noheader,
		 [],nofooter),
        !.
  compilePrint(_,REPORT,no_errors):-
	REPORT = report(name(""),[],[],script([]),noheader,
		 [],nofooter).
