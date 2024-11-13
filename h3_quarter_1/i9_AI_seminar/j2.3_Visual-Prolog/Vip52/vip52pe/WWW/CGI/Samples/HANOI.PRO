/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  HANOI
 FileName: HANOI.PRO
 Purpose: No description
 Written by: Visual Prolog
 Comments:
******************************************************************************/
include "cgiexam.inc"

DOMAINS
  loc =right;middle;left

PREDICATES
  hanoi(integer)
  move(integer,loc,loc,loc)
  inform(loc,loc)
  
CLAUSES
  hanoi(N):-
  	N<=0,!,
  	write("<p>You must enter positive number.\n").
  hanoi(N):-
	move(N,left,middle,right).
	move(1,A,_,C):-
	inform(A,C),!.

  move(N,A,B,C):-
	N1=N-1,
	move(N1,A,C,B),
	inform(A,C),
	move(N1,B,A,C).

  inform(Loc1, Loc2):-
	write("\n<br>Move a disk from ", Loc1, " to ", Loc2).

PREDICATES
  nondeterm member(parm,parmlist)
  runme(parmlist)
CLAUSES
  member (X,[X|_]).
  member (X,[_|Y]):-member(X,Y).
	
  runme(Parmlist) :-
  	member (parm("nd",N),ParmList),
  	str_int (N,I),
  	hanoi(I),!.
  runme (_) :-
  	write ("<p>Error while executing Hanoi.exe\n").

GOAL
        write("Content-type: text/html\n\n"),
        write("<html>\n"),
        write("<body>\n"),
	ParmList = cgi_GetParmList(),   
	runme(ParmList),
	write("</body>\n"),
	write("</html>\n").
