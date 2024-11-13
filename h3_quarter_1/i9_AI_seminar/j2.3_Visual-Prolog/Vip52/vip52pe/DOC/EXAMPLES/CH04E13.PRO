/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: CH04E13.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: 
******************************************************************************/

predicates
  action(integer) - nondeterm (i)

clauses
  action(1):-
	nl,
	write("You typed 1."),nl.
  action(2):-
	nl,
	write("You typed two."),nl.
  action(3):-
	nl,
	write("Three was what you typed."),nl.
  action(N):-
	nl,
	N<>1, N<>2, N<>3,
	write("I don't know that number!").

goal
  write("Type a number from 1 to 3: "),
  readint(Num),
  action(Num).