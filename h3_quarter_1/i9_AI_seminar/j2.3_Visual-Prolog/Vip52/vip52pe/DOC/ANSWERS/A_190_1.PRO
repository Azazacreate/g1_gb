/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: A_190_1.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: 
******************************************************************************/

domains
  integerlist = integer*

predicates
  get_integer_list(integerlist) - procedure (o)
  odd_list(integerlist,integerlist) - procedure (i,o)
  run - determ ()

clauses
  odd_list([],[]):-!.      % If the input list is empty,
                              % the output must be empty.

  odd_list([H|T1],[H|T2]):-
	1 = H mod 2,!,      % Is the head odd?
  	odd_list(T1,T2).     % If so, add it to the head
  	                      % of the output list.

  odd_list([_|T1],T2):-     % If the head is not odd,
  	odd_list(T1,T2).     % try the rest of the list!
  	
  get_integer_list([Int|T]):-
  	write("Enter an integer: "),
  	readint(Int),
  	!,
  	nl,
  	get_integer_list(T).
  get_integer_list([]).

  run:-
	write("*************** Odd List *******************"),
	nl,
	write("Enter the integers to make a list.\n",
              " (Enter a non-integer to end list.)\n\n"),
	get_integer_list(List),
	odd_list(List,Odds),
	nl,
	write("The whole list is: ",List),
	nl,
	write("The odd list is  : ",Odds),
	nl,
	nl,
	write("Press any key..."),
	readchar(_).

goal
  run.