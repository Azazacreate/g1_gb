/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: CH07E05.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: 
******************************************************************************/

domains
  list = integer*

predicates
  discard_negatives(list,list) - procedure (i,o)

clauses
  discard_negatives([],[]).

  discard_negatives([H|T],ProcessedTail):-
	H < 0,				/* If H is negative, just skip it */
	!,
	discard_negatives(T, ProcessedTail).

  discard_negatives([H|T],[H|ProcessedTail]):-
	discard_negatives(T, ProcessedTail).

goal
  discard_negatives([2,-45,3,468],X).
