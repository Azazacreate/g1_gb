/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: CH06E05.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: 
	In 32bit memory architectures, such as '386 UNIX, the examples here
	will run for a considerable length of time, occupying large amounts
	of memory and possibly reducing system performance significantly.
******************************************************************************/

predicates
  badcount1(long) - procedure (i)
  badcount2(long) - nondeterm (i)
  badcount3(long) - nondeterm (i)
  check(long) - nondeterm (i)

clauses
/* badcount1:
   The recursive call is not the last step. */

  badcount1(X):-
	write('\r',X),
	NewX = X+1,
	badcount1(NewX),
	nl.

/* badcount2:
   There is a clause that has not been tried
   at the time the recursive call is made. */

  badcount2(X):-
	write('\r',X),
	NewX = X+1,
	badcount2(NewX).

	badcount2(X):-
	X < 0,
	write("X is negative.").

/* badcount3:
   There is an untried alternative in a
   predicate called before the recursive call. */

  badcount3(X):-
	write('\r',X),
	NewX = X+1,
	check(NewX),
	badcount3(NewX).

  check(Z):-
	Z >= 0.
  check(Z):-
	Z < 0.

goal
  badcount1(123).
	