/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: CH11E14.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: For UNIX platform only
******************************************************************************/

include "/usr/local/PDCProlog/include/error.con"

global predicates
  alarm(integer) - (i) language C	% See alarm(S)

predicates
  brkclear
  nondeterm repeat
  ehand(integer)
  getchar(char)
  run

clauses
  brkclear:-breakpressed,!.	% Clear break-flag, if set
  brkclear.

  repeat.
  repeat:-repeat.

  ehand(2214):-!,
	write("Do something!\n").
  ehand(E):-
	write("\nUnknown exit ",E,'\n'),
	exit(2).

  getchar(C):-
	write("Enter char: "),
	alarm(3),	% Alarm to go off in 3 seconds
	readchar(C),	% This will exit with err_sigalrm when receiving SIGALRM
	alarm(0),	% Cancel pending alarm signal
	break(off),
	brkclear,	% Clear break-flag, in case alarm went off
	break(on).	% just before cancellation above.

  run:-
	Old=signal(err_sigalrm,sig_catch),	% Declared in error.con
	repeat,
	  trap(getchar(C),Err,ehand(Err)),
	!,
	signal(err_sigalrm,Old),
	write("\nYou entered '",C,"'\n").

goal
  run.