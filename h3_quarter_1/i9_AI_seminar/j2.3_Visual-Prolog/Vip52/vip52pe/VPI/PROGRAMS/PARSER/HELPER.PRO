/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  PARSER
 FileName: HELPER.PRO
 Purpose: Help Predicates
 Written by: Eugene Akimov
 Comments:
******************************************************************************/

PREDICATES
  unikterml(TERML,TERML)
  append(PRODNAMES,PRODNAMES,PRODNAMES)
  reverse(PRIORGROUP,PRIORGROUP,PRIORGROUP)
  nondeterm member(TERM,TERML)
  nondeterm member(TOKK,TOKKL)
  nondeterm member(PRODNAME,PRODNAMES)
  nondeterm member(PRODUCTION,PRODUCTIONS)
  nondeterm member(PRIORGROUP,PRODGROUPS)
  nondeterm member(SINGPROD,PRIORGROUP)
  nondeterm member(GRAMTOK,GRAMTOKL)
  determ	min(INTEGER, INTEGER, INTEGER)
  strlist_str(SLIST,STRING)
  wr(DBASEDOM)

CLAUSES
  wr(X):-write(X).

  member(X,[X|_]).
  member(X,[_|L]):-member(X,L).

  append([],L,L).
  append([X|L1],L2,[X|L3]):-append(L1,L2,L3).  

  min(A, B, A) :-
  	A < B,
  	!.
  min(_, B, B).

  unikterml([],[]).
  unikterml([dom(DOM,_)|T],T1):-member(dom(DOM,_),T),!,unikterml(T,T1).
  unikterml([name(ID,_)|T],T1):-member(name(ID,_),T),!,unikterml(T,T1).
  unikterml([term(ID,_,DOML)|T],T1):-member(term(ID,_,DOML),T),!,unikterml(T,T1).
  unikterml([H|T],[H|T1]):-unikterml(T,T1).

  strlist_str([],"").
  strlist_str([H|T],STR):-
	strlist_str(T,STR1),
	concat(H,STR1,STR).

  reverse([],L,L).
  reverse([H|T],L1,L2):-reverse(T,[H|L1],L2).
 