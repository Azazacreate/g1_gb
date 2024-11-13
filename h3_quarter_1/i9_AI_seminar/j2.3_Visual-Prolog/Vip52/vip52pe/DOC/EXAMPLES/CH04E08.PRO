/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: CH04E08.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: 
******************************************************************************/

predicates
  friend(symbol,symbol) - nondeterm (i,o)
  girl(symbol) - nondeterm (i)
  likes(symbol,symbol) - nondeterm (i,i)

clauses
  friend(bill,jane):-
	girl(jane),
	likes(bill,jane),!.
  friend(bill,jim):-
	likes(jim,baseball),!.
  friend(bill,sue):-
	girl(sue).

  girl(mary).
  girl(jane).
  girl(sue).

  likes(jim,baseball).
  likes(bill,sue).

goal
  friend(bill,Who).
