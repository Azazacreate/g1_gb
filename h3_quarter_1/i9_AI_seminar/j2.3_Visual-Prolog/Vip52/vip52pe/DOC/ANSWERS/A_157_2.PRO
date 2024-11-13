/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: A_157_2.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments:
******************************************************************************/

predicates
  typewriter(char) - determ (i)

clauses
  typewriter('\13'):-!.
  typewriter(Char):-
	write(Char),
  	readchar(C),
  	typewriter(C).

goal
  readchar(Char),
  typewriter(Char).
