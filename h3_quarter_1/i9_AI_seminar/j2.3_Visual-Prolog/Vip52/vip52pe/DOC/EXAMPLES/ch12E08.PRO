/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: CH12E08.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: 
******************************************************************************/

domains
  list = integer*

predicates
  readlist(list) - procedure (o)
  run - procedure ()

clauses
  readlist([H|T]):-
	write("> "),
	readint(H),!,
	readlist(T).
  readlist([]).

  run:-
	write("*************** Integer List *****************"),nl,
	write(" Type in a column of integers, like this:"),nl,
	write("  integer (press ENTER)\n  integer (press ENTER)\n"),
	write("  etc.\n\n Type X (and press ENTER) to end the list.\n\n"),
	readlist(TheList),nl,
	write("The list is: ",TheList).

goal
	run,nl.