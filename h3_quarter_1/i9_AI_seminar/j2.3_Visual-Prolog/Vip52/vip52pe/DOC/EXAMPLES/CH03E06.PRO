/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: CH03E06.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: 
******************************************************************************/

domains
  person = symbol

predicates
  father(person) - nondeterm (o)		/* This person is a father */
  father(person,person) - nondeterm (o,o)	/* One person is the father of the other person */

clauses
  father(Man):-
	father(Man,_).
  father(adam,seth).
  father(abraham,isaac).

goal
  father(X).
