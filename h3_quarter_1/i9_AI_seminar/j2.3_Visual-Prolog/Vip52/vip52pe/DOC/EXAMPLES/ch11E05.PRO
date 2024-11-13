/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: CH11E05.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: 
******************************************************************************/
% in VDE Messages window check, which domains are treated as reference  

diagnostics  %should be placed before the start of the program text 

domains
  tree = reference t(val,tree,tree)
  val  = integer
  list = integer*

predicates
  insert(integer,tree) - procedure (i,o), procedure (i,i)
  instree(list,tree) - procedure (i,i), procedure (i,o)
  treemembers(integer,tree) - nondeterm (o,i)
  sort(list,list) - procedure (i,o)

clauses
  insert(Val,t(Val,_,_)):-!.
  insert(Val,t(Val1,Tree,_)):-
	Val<Val1,!,
	insert(Val,Tree).
  insert(Val,t(_,_,Tree)):-
	insert(Val,Tree).

  instree([],_).
  instree([H|T],Tree):-
	insert(H,Tree),
	instree(T,Tree).

  treemembers(_,T):-
	free(T),!,fail.
  treemembers(X,t(_,L,_)):-
	treemembers(X,L).
  treemembers(X,t(Refstr,_,_)):-
	X = Refstr.
  treemembers(X,t(_,_,R)):-
	treemembers(X,R).

  sort(L,L1):-
	instree(L,Tree),
	findall(X,treemembers(X,Tree),L1).

goal
  sort([3,6,1,4,5],L).
