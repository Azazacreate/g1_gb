/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: CH04E05.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: 
******************************************************************************/

predicates
  type(symbol,symbol) - nondeterm (o,i)
  is_a(symbol,symbol) - nondeterm (o,i)
  lives(symbol,symbol) - nondeterm (i,i)
  can_swim(symbol) - nondeterm (o)

clauses
  type(ungulate,animal).
  type(fish,animal).

  is_a(zebra,ungulate).
  is_a(herring,fish).
  is_a(shark,fish).

  lives(zebra,on_land).
  lives(frog,on_land).
  lives(frog,in_water).
  lives(shark,in_water).

  can_swim(Y):-
	type(X,animal),
	is_a(Y,X),
	lives(Y,in_water).

goal
  can_swim(What),
  write("A ",What," can swim\n").
