/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: CH06E04.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: Tail recursive program that never runs out of memory
******************************************************************************/

predicates
  count(ulong) - procedure (i)

clauses
  count(N):-
	write('\r',N),
	NewN = N+1,
	count(NewN).

goal
  nl,
  count(0).
