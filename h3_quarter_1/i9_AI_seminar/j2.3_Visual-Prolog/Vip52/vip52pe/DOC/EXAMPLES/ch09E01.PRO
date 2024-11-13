/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: CH09E01.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: 
******************************************************************************/

predicates
  person(integer,symbol) - nondeterm (i,o)
  rand_int_1_5(integer) - procedure (o)
  rand_person(integer) - nondeterm (i)

clauses
  person(1,fred).
  person(2,tom).
  person(3,mary).
  person(4,dick).
  person(5,george).

  rand_int_1_5(X):-
	random(Y),
	X=Y*4+1.

  rand_person(0):-!.

  rand_person(Count):-
	rand_int_1_5(N),
	person(N,Name),
	write(Name),nl,
	NewCount=Count-1,
	rand_person(NewCount).
goal
  time(_,_,_,RandomSeed),
  randominit(RandomSeed),
  rand_person(3).

