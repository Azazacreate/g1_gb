/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: CH11E06.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: 
******************************************************************************/

domains
  ilist = integer*
  list_process = determ integer (integer) - (i)
  ilist_p = determ (ilist,list_process,ilist) - (i,i,o)

predicates
  list_square: list_process
  list_cube: list_process
  il_process: ilist_p

clauses
  list_square(E,ES):-
	ES = E*E.
  list_cube(E,EC):-
	EC = E*E*E.

  il_process([],_,[]).
  il_process([Head|Tail],L_Process,[P_Head|P_Tail]):-
	P_Head = L_Process(Head),
	il_process(Tail,L_Process,P_Tail).

goal
  List = [-12,6,24,14,-3],
  il_process(List,list_square,P_List1),!,
  il_process(List,list_cube,P_List2).