/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: CH07E04.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: 
******************************************************************************/

domains
  list = integer*

predicates
  add1(list,list) - procedure (i,o)

clauses
  add1([], []). /* boundary condition */
  add1([Head|Tail],[Head1|Tail1]):- /* separate the head */
				       /* from the rest of the list */
	Head1= Head+1,		       /* add 1 to the first element */
	add1(Tail,Tail1). /* call element with the rest of the list */

goal
  add1([1,2,3,4],NewList).
