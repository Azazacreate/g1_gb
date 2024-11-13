/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: CH06E06.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: 
	Shows how badcount2 and badcount3 can be fixed by adding cuts to
	rule out the untried clauses. These versions are tail recursive.
******************************************************************************/

predicates
  cutcount2(long) - procedure (i)
  cutcount3(long) - nondeterm (i)
  check(long) - nondeterm (i)

clauses
/* cutcount2:
   There is a clause that has not been tried
   at the time the recursive call is made. */

  cutcount2(X):-
	X>=0,!,
	write('\r',X),
	NewX = X + 1,
	cutcount2(NewX).

  cutcount2(_):-
	write("X is negative.").

/* cutcount3:
   There is an untried alternative in a
   clause called before the recursive call. */

  cutcount3(X):-
	write('\r',X),
	NewX = X+1,
	check(NewX),
	!,
	cutcount3(NewX).

  check(Z):-Z >= 0.
  check(Z):-Z < 0.

goal
  cutcount3(123).
  