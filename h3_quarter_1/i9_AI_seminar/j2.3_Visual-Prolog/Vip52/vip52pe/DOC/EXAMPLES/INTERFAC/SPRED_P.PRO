/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: SPRED.PRO
 Purpose: 
 Written by: PDC
 Comments: 
******************************************************************************/
project "spred"

global predicates
myfail language c as "_fail"
mymakewindow(integer,integer,integer,string,integer,integer,integer,integer)
  - (i,i,i,i,i,i,i,i) language c as "_makewindow"
myshiftwindow(integer) - (i) language c as "_shiftwindow"
myremovewindow language c as "_removewindow"
write_integer(integer) - (i) language c as "_write_integer"
write_real(real) - (i) language c as "_write_real"
write_string(string) - (i) language c as "_write_string"
myreadchar(char) - (o) language c as "_readchar"
myreadline(string) - (o) language c as "_readline"

extprog language c

clauses
myfail:- fail.

mymakewindow(Wno, Wattr, Fattr, Text, Srow, Scol, Rows, Cols):-
	makewindow(Wno, Wattr, Fattr, Text, Srow, Scol, Rows, Cols).

myshiftwindow(WNO):- shiftwindow(WNO).

myremovewindow:- removewindow.

write_integer(I):- write(I).

write_real(R):- write(R).

write_string(S):- write(S).

myreadchar(CH):- readchar(CH).

myreadline(S):- readln(S).

goal
	extprog.
