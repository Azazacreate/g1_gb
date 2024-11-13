/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: CH02E04.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: 
******************************************************************************/

predicates
  male(symbol) - nondeterm (o)
  female(symbol) - nondeterm (o)
  parent(symbol,symbol) - nondeterm (o,o)

clauses
  male(bill).
  male(joe).

  female(sue).
  female(tammy).

  parent(bill,joe).
  parent(sue,joe).
  parent(joe,tammy).

goal
  parent(Parent,_).
