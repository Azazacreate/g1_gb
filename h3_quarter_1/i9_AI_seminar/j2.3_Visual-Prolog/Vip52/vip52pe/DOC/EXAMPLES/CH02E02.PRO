/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: CH02E02.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: 
******************************************************************************/

predicates
  can_buy(symbol,symbol) - nondeterm (o,o)
  person(symbol) - nondeterm (o)
  car(symbol) - nondeterm (o)
  likes(symbol,symbol) - nondeterm (i,i)
  for_sale(symbol) - nondeterm (i)

clauses
  can_buy(X,Y):-
	person(X),
	car(Y),
	likes(X,Y),
   	for_sale(Y).

  person(kelly).
  person(judy).
  person(ellen).
  person(mark).

  car(lemon).
  car(hot_rod).

  likes(kelly, hot_rod).
  likes(judy, pizza).
  likes(ellen, tennis).
  likes(mark, tennis).

  for_sale(pizza).
  for_sale(lemon).
  for_sale(hot_rod).

goal
  can_buy(Who,What).
