/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: CH04E14.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: 
******************************************************************************/

predicates
  action(integer) - procedure (i)

clauses
  action(1):-!,
	nl,
	write("You typed 1.").
  action(2):-!,
	nl,
	write("You typed two.").
  action(3):-!,
	nl,
	write("Three was what you typed.").
  action(_):-nl,
	write("I don't know that number!").

goal
  write("Type a number from 1 to 3: "),
  readint(Num),
  action(Num),nl.
