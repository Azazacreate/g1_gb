/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: CH03E05.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: 
******************************************************************************/

predicates
  isletter(char) - nondeterm (i)

clauses
/* When applied to characters, '<=' means */
/* "alphabetically precedes or is the same as" */
  isletter(Ch):-
	'a' <= Ch,
	Ch <= 'z'.
  isletter(Ch):-
	'A' <= Ch,
	Ch <= 'Z'.

goal
  isletter('x').