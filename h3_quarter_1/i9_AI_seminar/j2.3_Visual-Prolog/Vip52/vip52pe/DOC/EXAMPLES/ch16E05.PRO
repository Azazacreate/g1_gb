/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: CH16E05.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: 
******************************************************************************/

domains
  loc =right;middle;left

predicates
  hanoi(integer) - procedure (i)
  move(integer,loc,loc,loc) - procedure (i,i,i,i)
  inform(loc,loc) - procedure (i,i)

clauses
  hanoi(N):-
	move(N,left,middle,right).

  move(1,A,_,C):-
	inform(A,C),
	!.

  move(N,A,B,C):-
	N1=N-1,
	move(N1,A,C,B),
	inform(A,C),
	move(N1,B,A,C).

  inform(Loc1,Loc2):-
	write("Move a disk from ",Loc1," to ",Loc2),nl.

goal
  hanoi(3).
