/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: A_179_2.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments:
******************************************************************************/

domains
  integerlist = integer*

predicates
  sum_of(integerlist,integer) - procedure (i,o)
  get_integer_list(integerlist) - procedure (o)

clauses
  sum_of([],0):-!.
  sum_of([Num|T],Sum):-
	sum_of(T, Sum_of_tail) ,
	Sum = Num + Sum_of_tail.
  	
  get_integer_list([H|T]):-
	write("Enter an integer: ") ,
  	readint(H),
  	!,
  	nl,
  	get_integer_list(T).
  get_integer_list([]).

goal
  write("**************** Sum of an Integerlist ******************"),
  nl,
  write("Please enter the integers which you wish to sum.\n"),
  write("  (Enter a non-integer to stop.)\n") ,
  get_integer_list(List),
  sum_of(List,Sum),
  nl,
  write("The sum of the list is: ",Sum,"\n").
