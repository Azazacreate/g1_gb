/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: CH07E09.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: 
******************************************************************************/

domains
  llist = l(list); i(integer); c(char); s(string)
  list = llist*

predicates
  append(list,list,list) - procedure (i,i,o)

clauses
  append([],L,L).
  append([X|L1],L2,[X|L3]):-
	append(L1,L2,L3).

goal
  append([s("likes"), l([s("bill"), s("mary")])],[s("bill"), s("sue")],Ans),
  append([l([s("This"),s("is"),s("a"),s("list")]),s("bee")], [c('c')],Ans2).

