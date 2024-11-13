/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: CH04E03.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: 
******************************************************************************/

domains
  child = symbol
  age   = integer

predicates
  player(child,age) - nondeterm (o,i), nondeterm (i,i)

clauses
  player(peter,9).
  player(paul,10).
  player(chris,9).
  player(susan,9).

goal
  player(Person1,9),
  player(Person2,9),
  Person1 <> Person2.
