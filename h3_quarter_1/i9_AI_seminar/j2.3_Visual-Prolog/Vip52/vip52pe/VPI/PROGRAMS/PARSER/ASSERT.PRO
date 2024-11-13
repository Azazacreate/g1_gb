/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  PARSER
 FileName: ASSERT.PRO
 Purpose: Transforming the tree to clauses
 Written by: Eugene Akimov
 Comments:
******************************************************************************/

PREDICATES
  determ assertparser(PARSER)
  assertproductions(PRODUCTIONS)
  assertsection(SECTION)

CLAUSES
  assertparser([]).
  assertparser([H|T]) :-assertsection(H),assertparser(T).
  
  assertsection(productions_(PRODUCTIONS)) :- !,assertproductions(PRODUCTIONS).
  assertsection(userprods_(PRODUCTIONS)) :-
	member(PROD,PRODUCTIONS),
	assert(userprod(PROD)),
	fail.
  assertsection(userdoms_(PRODUCTIONS)) :-
	member(PROD,PRODUCTIONS),
	assert(userdom(PROD)),
	fail.
  assertsection(_).

  assertproductions([]).
  assertproductions([p(PRODNAME,_,PRODBODY)|T]) :-
	not(prodname(PRODNAME)),!,
	assert(prodname(PRODNAME)),
	assert(p(PRODNAME,PRODBODY)),
	assertproductions(T).
  assertproductions([p(_,CURSOR,_)|_]) :-
	retractall(error(_, _)),
	assert(error("Production already defined",CURSOR)),
	change_error("Production already defined",CURSOR),
	fail.