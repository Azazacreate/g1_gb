/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: CH06E02.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: 
	Uses repeat to keep accepting characters and printing them
	until the user presses Enter.
******************************************************************************/

predicates
  repeat - nondeterm ()
  typewriter - nondeterm ()

clauses
  repeat.
  repeat:-repeat.

  typewriter:-
	repeat,
	readchar(C),       /* Read a char, bind C to it */
	write(C),
	C = '\r'.          /* Is it a carriage return? fail if isn't */

goal
  typewriter,nl.
  