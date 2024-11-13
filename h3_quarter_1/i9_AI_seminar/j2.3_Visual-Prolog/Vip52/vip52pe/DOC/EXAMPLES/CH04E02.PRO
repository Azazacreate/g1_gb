/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: CH04E02.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: 
******************************************************************************/

predicates
  likes(symbol,symbol) - nondeterm (i,o)
  tastes(symbol,symbol) - nondeterm (i,i)
  food(symbol) - nondeterm (o)

clauses
  likes(bill,X):-
	food(X),
	tastes(X,good).

  tastes(pizza,good).
  tastes(brussels_sprouts,bad).

  food(brussels_sprouts).
  food(pizza).

goal
  likes(bill,What).
	