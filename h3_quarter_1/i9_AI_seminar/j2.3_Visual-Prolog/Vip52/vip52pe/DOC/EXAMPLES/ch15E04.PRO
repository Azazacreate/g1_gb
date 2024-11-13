/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: CH15E04.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: 
******************************************************************************/

predicates
  ttimeout(real) - procedure (i)

clauses
  ttimeout(TM):-
	timeout(TM),!.
  ttimeout(TM):-
	write("No timeout, sleep 0.5 secs"),nl,
	sleep(50),
	ttimeout(TM).

goal
  marktime(400,TM),	% 4 secs
  ttimeout(TM),
  write("\nBINGO!\n").
