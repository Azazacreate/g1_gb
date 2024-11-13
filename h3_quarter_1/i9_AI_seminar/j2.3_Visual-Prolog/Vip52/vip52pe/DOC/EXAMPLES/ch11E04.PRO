/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: CH11E04.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: 
******************************************************************************/
% run under PDC debugger

diagnostics  %should be placed before the start of the program text 

domains
  tree = reference t(val,tree,tree)
  val  = string

predicates
  insert(val,tree) - procedure (i,i), procedure (i,o)

clauses
  insert(ID,t(ID,_,_)):-!.
  insert(ID,t(ID1,Tree,_)):-
	ID<ID1,
	!,insert(ID,Tree).
  insert(ID,t(_,_,Tree)):-
	insert(ID,Tree).

goal
  insert("tom",Tree),
  insert("dick",Tree),
  insert("harry",Tree),
  write("Tree=",Tree).
