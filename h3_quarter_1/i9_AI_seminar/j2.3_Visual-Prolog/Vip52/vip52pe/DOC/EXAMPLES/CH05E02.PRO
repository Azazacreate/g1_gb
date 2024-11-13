/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: CH05E02.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: For DOS platform only
******************************************************************************/

domains
  row,column,step = unsigned
  movement = up(step);down(step);left(step);right(step)

predicates
  move_cursor(movement)

clauses
  move_cursor(up(Step)):-
	cursor(R,C),
	R1=R-Step,
	cursor(R1,C).
  move_cursor(down(Step)):-
	cursor(R,C),
	R1=R+Step,
	cursor(R1,C).
  move_cursor(left(Step)):-
	cursor(R,C),
	C1=C-Step,
	cursor(R,C1).
  move_cursor(right(Step)):-
	cursor(R,C),
	C1=C+Step,
	cursor(R,C1).

goal
  makewindow(1,7,7,"",0,0,20,20),
  cursor(R,C),
  cursor(R,C),  % turn on cursor
  sleep(100),
  move_cursor(down(8)),
  sleep(100),
  move_cursor(right(12)),
  sleep(100),
  move_cursor(up(2)),
  sleep(100),
  move_cursor(left(5)),
  sleep(100).
