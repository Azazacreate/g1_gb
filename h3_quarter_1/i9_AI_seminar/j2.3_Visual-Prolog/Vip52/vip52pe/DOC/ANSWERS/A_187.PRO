/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: A_187.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: 
******************************************************************************/

domains
  integerlist = integer*	

predicates
  even_member(integer,integerlist) - nondeterm (o,i)
  get_integer_list(integerlist) - procedure (o)
  write_even_members(integerlist) - procedure (i)

clauses
  even_member(Head,[Head|_]):-
	0 = Head mod 2.
  even_member(Element,[_|Tail]):-
	even_member(Element,Tail).
  	
  get_integer_list([H|T]):-
	write("Enter an integer: ") ,
	readint(H),
	!,
	nl,
	get_integer_list(T).
  get_integer_list([]).

  write_even_members(L):-
	even_member(E,L),
	write(E),
	nl,
	fail.
  write_even_members(_).  	

goal
  write("Please enter the integers which ",
      "you wish to include in the list.\n",
            "  (Enter a non-integer to end list.)\n\n"),
  get_integer_list(List),
  nl,
  write("Here are the even numbers in the list:\n\n"),
  write_even_members(List),
  nl,
  write("Press any key..."),
  readchar(_).