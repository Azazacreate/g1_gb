/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: CH12E10.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: 
******************************************************************************/

domains
  file = input

predicates
  inspect_positions(file) - determ (i)

clauses
  inspect_positions(UserInput):-
	readdevice(UserInput),
	nl,write("Position No? "),
	readln(X),
	term_str(ulong,Posn,X),
	readdevice(input),
	filepos(input,Posn,0),
	readchar(Y),nl,
	write("Char is: ",Y),
	inspect_positions(UserInput).

goal
  write("Which file do you want to work with ?"),nl,
  readln(FileName),
  openread(input, FileName),
  readdevice(UserInput),
  inspect_positions(UserInput).
