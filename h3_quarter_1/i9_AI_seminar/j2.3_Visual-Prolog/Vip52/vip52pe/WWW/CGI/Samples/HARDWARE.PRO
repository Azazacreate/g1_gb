/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  HARDWARE
 FileName: HARDWARE.PRO
 Purpose: No description
 Written by: Visual Prolog
 Comments:
******************************************************************************/
include "cgiexam.inc"

DOMAINS
  d = integer
  
DATABASE - inp
  inp (D,D)

PREDICATES
  not_(D,D)
  and_(D,D,D)
  or_(D,D,D)
  xor_(D,D,D)

CLAUSES
  not_(1,0).      not_(0,1).
  and_(0,0,0).    and_(0,1,0).
  and_(1,0,0).    and_(1,1,1).
  or_(0,0,0).     or_(0,1,1).
  or_(1,0,1).     or_(1,1,1).

  % See the documentarion for the XOR circuit
  xor_(Input1,Input2,Output):-
	not_(Input1,N1),
	not_(Input2,N2),
	and_(Input1,N2,N3),
	and_(Input2,N1,N4),
	or_(N3,N4,Output).
	
PREDICATES
  nondeterm member(parm,parmlist)
  runme(parmlist)
  legal(D)
CLAUSES
  member (X,[X|_]).
  member (X,[_|Y]):-member(X,Y).
  
  legal (1). legal (0).
	
  runme(Parmlist) :-
  	member (parm("i1",S1),ParmList),
  	member (parm("i2",S2),ParmList),
  	trap (str_int(S1,I1),_,fail),
  	trap (str_int(S2,I2),_,fail),
  	legal(I1),
  	legal(I2),!,
  	xor_(I1,I2,Out),
  	write ("<p>Input 1 = ",I1),
  	write ("<br>Input 2 = ",I2),
  	write ("<p>Output = ",Out).
  runme (_) :-
  	write ("<p>Illegal input values. Only 0 and 1 are allowed.\n").

GOAL
        write("Content-type: text/html\n\n"),
        write("<html>\n"),
        write("<body>\n"),
	ParmList = cgi_GetParmList(),
	runme(ParmList),
	write("</body>\n"),
	write("</html>\n").
