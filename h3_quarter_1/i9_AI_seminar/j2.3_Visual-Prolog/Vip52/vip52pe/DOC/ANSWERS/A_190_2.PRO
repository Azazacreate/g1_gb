/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: A_190_2.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: 
******************************************************************************/

domains
  reallist = real*

predicates
  real_average(reallist,real) - procedure (i,o)
  list_length(reallist,real,real) - procedure (i,i,o)
  list_sum(reallist,real,real) - procedure (i,i,o)
  get_list(reallist) - procedure (o)
  run - procedure ()

clauses
  real_average(List,Average):-
	list_length(List,0.0,Length),
  	list_sum(List,0.0,Sum),
  	Average = Sum / Length.
  	
  list_length([],L,L):-!.
  list_length([_|T],Temp_length,Length):-
  	New_temp = Temp_length + 1,
  	list_length(T,New_temp,Length).
  	
  list_sum([],S,S):-!.
  list_sum([Num|T],Temp_sum,Sum):-
    	New_temp = Num + Temp_sum,
    	list_sum(T,New_temp,Sum).
    	
  get_list([H|T]):-
    	write("Enter a real number: "),
    	readreal(H),
    	!,
    	nl,
    	get_list(T).
  get_list([]).    	

  run:-
  	write("************** Real List Sum ********************"),
  	nl,
	write("Please enter a list of real numbers",
            " (enter a non-integer to stop):\n\n"),
	get_list(List),
	nl,
	nl,
	real_average(List, Average),
	write("The list is:\n", List),
	nl,
	nl,
	writef("The average is: %.\n", Average),
	nl.

goal
  run.