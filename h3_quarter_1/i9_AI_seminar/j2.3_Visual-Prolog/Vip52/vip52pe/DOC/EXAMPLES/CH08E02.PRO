/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: CH08E02.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: 
******************************************************************************/

domains
  screenname, fname, type = symbol
  row,col,len = integer

facts
  screen(symbol,dbasedom)	 /* Saving different screens */

facts - screen
  field(fname,type,row,col,len)  /* Definitions of I/O field on screen */
  txtfield(row,col,len,string)  /* Showing textfields */
  windowsize(row,col)

predicates
  shiftscreen(symbol) - procedure (i)

clauses
  shiftscreen(_):-
	retract(field(_,_,_,_,_)),
	fail.

  shiftscreen(_):-
	retract(txtfield(_,_,_,_)),
	fail.

  shiftscreen(_):-
	retract(windowsize(_,_)),
	fail.

  shiftscreen(Name):-
	screen(Name,Term),
	assert(Term),
	fail.

  shiftscreen(_).

goal
  shiftscreen(person).