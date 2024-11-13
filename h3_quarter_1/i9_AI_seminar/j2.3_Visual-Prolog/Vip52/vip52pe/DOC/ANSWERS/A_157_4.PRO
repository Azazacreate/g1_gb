/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: A_157_4.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments:
******************************************************************************/

predicates
  mult_x_itself(real) - procedure (i)

clauses
  mult_x_itself(X):-
	X <= 1,
  	!,
  	write("no\n").

  mult_x_itself(81.0):-
	write("yes\n"),
	!.

  mult_x_itself(Num):-
  	Num > 81 ,
  	!,
  	write("no\n").

  mult_x_itself(Num):-
  	Num1 = Num * Num,
  	mult_x_itself(Num1).

goal
  write("\nEnter a number: "),
  readreal(Number),
  nl,
  mult_x_itself(Number),
  nl.