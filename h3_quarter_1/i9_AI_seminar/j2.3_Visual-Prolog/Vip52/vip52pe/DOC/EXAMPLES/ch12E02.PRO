/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: CH12E02.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: 
******************************************************************************/

domains
  integerlist = integer*

predicates
  writelist(integerlist) - procedure (i)
  write5(integerlist,integer) - procedure (i,i)

clauses
  writelist(NL):-
	nl,
	write5(NL,0),nl.
  write5(TL,5):-!,
	nl,
	write5(TL, 0).
  write5([H|T],N):-!,
	write(H," "),
	N1=N+1,
	write5(T,N1).
  write5([],_).

goal
  writelist([2,4,6,8,10,12,14,16,18,20,22]).