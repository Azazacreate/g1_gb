/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: CH11E10.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: 
******************************************************************************/

domains
  file = dd

predicates
  error(integer) - procedure (i)
  process(string) - nondeterm (o)

clauses
  process("a").
  process("b"):-
	writedevice(dd).	% This will exit with an error

  error(E):-
	write("\nerror ", E),nl.

goal
  trap(process(A),E,error(E)).
