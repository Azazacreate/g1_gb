/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: CH07E07.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: 
******************************************************************************/

domains
  integerlist = integer*

predicates
  append(integerlist,integerlist,integerlist) - procedure (i,i,o)
   
clauses
  append([],List,List).
  append([H|L1],List2,[H|L3]):-
	append(L1,List2,L3).

goal
  append([1,2,3],[5,6],L).
