/*****************************************************************************

		 Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  EASYWIN
 FileName: EASYWIN.PRO
 Purpose: Easywin example
 Written by: Alexander Gostintsev
 Comments:
******************************************************************************/

GLOBAL DOMAINS
  file=in

PREDICATES
  tst
  nondeterm repeat

CLAUSES

  repeat.
  repeat:-repeat.

  tst:-
  	write("Input str: "),
  	readln(SSS),nl,
	write("You typed: ",SSS),nl,
  	openread(in,"EASYWIN.TXT"),
  	readdevice(in),
  	readln(STR),
  	write("String from file: ", STR),nl,
  	write("Chars from file:"),nl,
  	repeat,
  	  readchar(C),
  	  write(C),
  	C='!',
  	closefile(in),
  	nl,
  	write("Input any string: "),
  	readln(X),nl,
  	write("You typed: ",X),nl,
	repeat,
	  nl,
	  write("Input an integer value: "),
	readint(INT),nl,
	write("This is: ",INT),nl,
	repeat,
	  nl,
	  write("Input a real value: "),
	readreal(REAL),nl,
	write("This is: ",REAL),nl,
	LIST=[1,2,3,4,5],/*LIST=5,*/
	write("List example: "),write(LIST),nl,
	write("Waiting for a character..."),
	readchar(CHAR),nl,
	write("Your char: ",CHAR),nl,
	repeat,
	  write("End of session: <Enter>"),
	  readln(COMPLETE),nl,
	COMPLETE="",
	write("End"),!.

GOAL
  tst.

