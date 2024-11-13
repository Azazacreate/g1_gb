/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: CH04E06.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: 
******************************************************************************/

domains
  name = symbol

predicates
  father(name,name) - nondeterm (o,o)
  everybody - procedure ()

clauses
  father(leonard,katherine).
  father(carl,jason).
  father(carl,marilyn).
  everybody:-
	father(X,Y),
	write(X," is ",Y,"'s father\n"),
	fail.
  everybody.

goal
  everybody.