/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: A_239.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: 
******************************************************************************/

constants
  conversion_factor = 180/3.14159265

predicates
  get_vals(real) - procedure (i)
  list_vals(real,real,real,real) - procedure (i,i,i,i)
  run - procedure ()

clauses
  run:-
	write("  Angle\t\tSine\t\t Cosine\t\t  Tangent\n"),
	write("  =====\t\t====\t\t ===== \t\t  =======\n"),
	nl,
	get_vals(0.0).

  get_vals(Deg):-
	Deg < 361,
	!,
	Rad = Deg / ( conversion_factor ),
	Sine = sin(Rad),
	Cosine = cos(Rad),
	Tangent = tan(Rad),
	list_vals(Deg,Sine,Cosine,Tangent),
	NewAngle = Deg + 15,
	get_vals(NewAngle).
	get_vals(_).

  list_vals(A,B,C,D):-
	writef("%4%18.6%18.6%18.6\n",A,B,C,D).

goal
  run.
