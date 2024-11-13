/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: CH04E07.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: 
******************************************************************************/

predicates
  buy_car(symbol,symbol) - determ (i,o)
  car(symbol,symbol,integer) - nondeterm (i,o,o)
  colors(symbol,symbol) - nondeterm (i,i)

clauses
  buy_car(Model,Color):-
	car(Model,Color,Price),
	colors(Color,sexy),!,
	Price > 25000.

  car(maserati,green,25000).
  car(corvette,black,24000).
  car(corvette,red,26000).
  car(porsche,red,24000).

  colors(red,sexy).
  colors(black,mean).
  colors(green,preppy).

goal
  buy_car(corvette,Y).
