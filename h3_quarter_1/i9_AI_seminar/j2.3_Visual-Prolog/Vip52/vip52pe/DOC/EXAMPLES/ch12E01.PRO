/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: CH12E01.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: 
******************************************************************************/

domains
  integerlist = integer*
  namelist    = symbol*

predicates
  writelist(integerlist) - procedure (i)
  writelist(namelist) - procedure (i)

clauses
  writelist([]).
  writelist([H|T]):-
	write(H, " "),
	writelist(T).

goal
  writelist([1,2,3,4]),nl.