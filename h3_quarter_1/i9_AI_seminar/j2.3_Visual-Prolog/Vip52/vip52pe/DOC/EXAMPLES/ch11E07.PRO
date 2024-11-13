/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: CH11E07.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: 
******************************************************************************/

domains
  ilist = integer*
  list_process = determ integer (integer) - (i)
  list_p_list = list_process*
  elem_process = determ (integer,integer,integer) - (i,i,o)
  elem_p_list = elem_process*

predicates
  list_same: list_process
  list_square: list_process
  list_cube: list_process

  elem_add: elem_process
  elem_max: elem_process
  elem_min: elem_process

  il_process(ilist,list_process,ilist) - procedure (i,i,o)
  il_post_process(ilist,elem_process,integer) - determ (i,i,o)

  apply_elemprocess(ilist,elem_p_list) - nondeterm (i,i)
  apply_listprocess(ilist,list_p_list,elem_p_list) - nondeterm (i,i,i)

  String lpname(list_process) - nondeterm (i)
  String epname(elem_process) - nondeterm (i)
  run - nondeterm ()

clauses
  lpname(list_same,"list_same").	% Map predicate pointer to its name
  lpname(list_square,"list_square").
  lpname(list_cube,"list_cube").

  epname(elem_add,"elem_add").
  epname(elem_min,"elem_min").
  epname(elem_max,"elem_max").

  elem_add(E1,E2,E3):- E3 = E1+E2.
  elem_max(E1,E2,E1):- E1 >= E2, !.
  elem_max(_,E2,E2).
  elem_min(E1,E2,E1):- E1 <= E2, !.
  elem_min(_,E2,E2).

  list_same(E,E).
  list_square(E,ES):- ES = E*E.
  list_cube(E,EC):- EC = E*E*E.

  il_process([],_,[]).
  il_process([Head|Tail],E_Process,[P_Head|P_Tail]):-
	P_Head = E_Process(Head),
	il_process(Tail,E_Process,P_Tail).

  il_post_process([E],_,E):-!.
  il_post_process([H|T],L_Process,Result):-
	il_post_process(T,L_Process,R1),
	L_Process(H,R1,Result).

  apply_elemprocess(_,[]).
  apply_elemprocess(P_List,[E_Process|E_Tail]):-
	il_post_process(P_List,E_Process,PostProcess),
	NE_Process = epname(E_Process),
	write(NE_Process,": Result = ",PostProcess,'\n'),
	apply_elemprocess(P_List,E_Tail).

  apply_listprocess(_,[],_).
  apply_listprocess(I_List,[L_Process|L_Tail],E_List):-
	il_process(I_List,L_Process,P_List),
	NL_Process = lpname(L_Process),
	write('\n',NL_Process,":\nProcessed list = ",P_List,
					"\nPost-processing with:\n"),
	apply_elemprocess(P_List,E_List),
	apply_listprocess(I_List,L_Tail,E_List).

  run:-
	List = [-12,6,24,14,-3],
	write("Processing ",List," using:\n"),nl,
	apply_listprocess(List,[list_same,list_square,list_cube],
					[elem_add,elem_max,elem_min]).

goal
  run.