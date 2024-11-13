/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: CH04E15.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: 
******************************************************************************/

predicates
  classify(integer,symbol) - nondeterm (i,i)

clauses
  classify(0,zero).
  classify(X,negative):-
	X < 0.
  classify(X,positive):-
	X > 0.

goal
  classify(45,positive).
