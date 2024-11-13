/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: CH12E09.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: 
******************************************************************************/

domains
  file = myfile

predicates
  readloop - procedure ()
  run - procedure ()

clauses
  readloop:-
	readchar(X),
	X<>'#',!,
	write(X),
	readloop.
  readloop.

  run:-
	write("This program reads your input and writes it to"),nl,
	write("tryfile.one\n"),
	write("For stop press #"),nl,
	openwrite(myfile,"tryfile.one"),
	writedevice(myfile),
	readloop,
	closefile(myfile),
	writedevice(screen),
	write("Your input has been transferred to the file tryfile.one"),nl.

goal
  run.