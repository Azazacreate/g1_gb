/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: CH11E15.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: For UNIX platform only
******************************************************************************/

include "/usr/local/PDCProlog/include/error.con"

global predicates
  alarm(integer) - (i) language C	% See alarm(S)

facts
  rcount(unsigned)
  dba(real,real,real)

predicates
  nondeterm repeat
  process_dba
  bcheck
  bcheck1(integer)
  run

clauses
  repeat.
  repeat:- repeat.

  rcount(0).

  dba(1,1,1).

  process_dba:-
	retract(dba(F1,F2,F3)), !, F = F1 * F2 * F3, assert(dba(F,F,F)),
	retract(rcount(N)), !, NN = N+1, assert(rcount(NN)),
	NN = 25000.	% fail back to repeat in goal

  bcheck:-
	Break = breakpressed(),!,
	bcheck1(Break).
  bcheck.

  bcheck1(err_sigalrm):-!,
	rcount(N),!,
	time(H,M,S,_),
	writef("\r%:%:% % records   ",H,M,S,N),
	alarm(1). % Next alarm in 1 second
  bcheck1(0):-!,
	 write("\nInterrupt\n"),
	 exit(1).
  bcheck1(Exit):-
	 write("\nUnknown exit ",Exit,"; runtime error?\n"),
	 exit(2).

  run:-
	break(off),
	Old = signal(err_sigalrm,sig_catch),	% Declared in error.pre
	alarm(1),		% First alarm in 1 second
	repeat,
	  bcheck, process_dba,
	!,
	alarm(0),		% Cancel pending alarm
	signal(err_sigalrm,Old),
	dba(F1,F2,F3), !,
	write('\n',F1,' ',F2,' ',F3,'\n').

goal
  run.