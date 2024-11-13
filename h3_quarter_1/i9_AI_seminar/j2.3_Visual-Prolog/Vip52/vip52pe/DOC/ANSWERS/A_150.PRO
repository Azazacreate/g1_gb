/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: A_150.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments:
	Note that if your ulimit is greater than the available core, quite
	heavy swapping will result from trying this program.
******************************************************************************/

predicates
  count(integer) - procedure (i)
  check_count(integer) - procedure (i)

clauses
  check_count(N):-
	N mod 1000=0,
	!,
	write(N,'\n').
  check_count(_).

  count(Number):-
	check_count(Number),
  	New_number = Number + 1,
	count(New_number),
  	write("This added call makes this clause non-tail recursive.").

goal
  count(0).
