/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: A_146_1.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments:
	Uses repeat to keep accepting characters, printing
	them all in uppercase until the user presses Enter.
******************************************************************************/

predicates
  repeat - nondeterm ()
  typewriter - nondeterm ()

clauses
  repeat.
  repeat:-repeat.

  typewriter:-
	repeat,
	readchar(C),        /* Read a char and bind it C */
	upper_lower(C1,C) , /* Convert C to upper case   */
	write(C1),
	char_int(C,13).     /* Is C = ASCII 13?
                                        This call will fail until a <CR> is
                                        hit.  When the user presses <CR>,
                                        the loop will finally succeed,
                                        ending the repeat/fail process.
                                     */
goal
  typewriter,
  nl.
