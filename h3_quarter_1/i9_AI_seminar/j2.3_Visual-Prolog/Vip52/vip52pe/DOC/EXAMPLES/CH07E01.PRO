/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: CH07E01.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: 
******************************************************************************/

domains
  list = integer* /* or whatever type you wish to use */

predicates
  write_a_list(list) - procedure (i)

clauses
  write_a_list([]). /* If the list is empty, do nothing more. */

  write_a_list([H|T]):- /* Match the head to H and the tail to T, then... */
	write(H),nl,
	write_a_list(T).

goal
  write_a_list([1,2,3]).
