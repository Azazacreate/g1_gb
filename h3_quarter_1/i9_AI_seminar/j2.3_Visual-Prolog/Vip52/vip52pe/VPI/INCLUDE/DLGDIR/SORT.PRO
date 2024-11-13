/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S 

 Project:  
 FileName: SORT.PRO
 Purpose: 
 Written by: PDC
 Comments:
******************************************************************************/

predicates
  procedure br_sort(SLIST,SLIST)	%- (i,o)                                                                                                                                                                                                   

/**************************************************************
	Sort stringlist in alphabet order
***************************************************************/
domains
   BR_TREE = reference t(VAL,BR_TREE,BR_TREE)
   VAL  = STRING

predicates
  procedure insert(STRING,BR_TREE) - (i,i),(i,o)
  procedure instree(SLIST,BR_TREE)
  nondeterm treemembers(STRING,BR_TREE)

clauses
   insert(Val,t(Val,_,_)):-!.
   insert(Val,t(Val1,Tree,_)):-
	upper_lower(Val,ValLow),
	upper_lower(Val1,Val1Low),
	ValLow<Val1Low,!,
	insert(Val,Tree).
   insert(Val,t(_,_,Tree)):-insert(Val,Tree).

   instree([],_):-!.
   instree([H|T],Tree):-
      insert(H,Tree),!,
      instree(T,Tree).
   instree(_,_):-errorexit(). % Should never be called !

   treemembers(_,T):-free(T),!,fail.
   treemembers(X,t(_,L,_)):-treemembers(X,L).
   treemembers(X,t(Refstr,_,_)):-X=Refstr.
   treemembers(X,t(_,_,R)):-treemembers(X,R).

   br_sort(L, L1) :-
      instree(L,Tree),
      findall(X,treemembers(X,Tree),L1).
