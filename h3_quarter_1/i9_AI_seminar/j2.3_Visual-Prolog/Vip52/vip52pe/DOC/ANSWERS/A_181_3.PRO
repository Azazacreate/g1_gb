/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: A_181_3.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments:
******************************************************************************/

domains
  integerlist = integer*

predicates
  get_integer_list(integerlist) - procedure (o)
  get_list_sum(integerlist,integer,integer) - procedure (i,i,o)
  sum_list(integerlist,integer) - procedure (i,o)
	
clauses
  sum_list(List,Sum):-
	get_list_sum(List,0,Sum).

  get_list_sum([],X,X):-!.
  get_list_sum([Num|T],Temp,Sum):-
	Temp_sum = Temp + Num ,
  	get_list_sum(T,Temp_sum,Sum).
  	
  get_integer_list([H|T]):-
  	write("Enter an integer: "),
  	readint(H),
  	!,
  	nl,
  	get_integer_list(T).
  get_integer_list([]).
  
goal
  write("************* Sum of an Integerlist ***************"),
  nl,
  write("Please enter the integers which you wish to sum.\n" ,
       	"  (Enter a non-integer to stop.)\n\n") ,
  get_integer_list(List),
  sum_list(List,Sum),
  nl,
  write("The sum of the list is: ",Sum,"\n").