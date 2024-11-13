/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  PARSER
 FileName: WRITEDOM.PRO
 Purpose: Generate domain definitions
 Written by: Eugene Akimov
 Comments:
******************************************************************************/
include "helper.pro"

PREDICATES
  wterml(TERML)  
  wterm(TERM)
  wdoml(PRODNAMES)
  wtok(TOKK)

CLAUSES
  write_domain_definitions_aux:-
	write("/***********************************************************\n"),
	write("\t\tDOMAIN DEFINITIONS"),nl,
	write("***********************************************************/\n"),
	write("\nDOMAINS\n"),
	prodname(PRODNAME),
	findall(TERMS,terms(PRODNAME,TERMS),TERML),
	unikterml(TERML,TERML1),not(TERML1=[]),
	writef("  %-15 = ",PRODNAME),
	wterml(TERML1),
	nl,nl,
	fail.
  write_domain_definitions_aux:-
	write("\n  TOK\t\t  = "),
	decltok(_,TOK),
	wtok(TOK),write(";\n\t\t    "),
	fail.
  write_domain_definitions_aux:-write("nill\n\n").

  terms(PRODNAME,TERM):-
	p(PRODNAME,groups(PRODUCTIONGROUPS)),
	member(PRODUCTIONGROUP,PRODUCTIONGROUPS),
	member(prod(_,_,_,TERM),PRODUCTIONGROUP),
	not(TERM=dom(PRODNAME,_)).
  terms(PRODNAME,list(DOM)):-
	p(PRODNAME,list(DOM,_,_,_)).

  wterml([TERM]):-!,wterm(TERM).
  wterml([H|T]):-wterm(H),write(";\n\t\t    "),wterml(T).

  wterm(term(FUNC,_,DOML)):-
	write(FUNC,'('),
	wdoml(DOML),
	write(')').
  wterm(dom(DOM,_)):-wdoml([DOM]).
  wterm(list(DOM)):-wdoml([DOM]),write('*').
  wterm(name(FUNCTOR,_)):-write(FUNCTOR,"()").

  wdoml([DOM]):-!,write(DOM).
  wdoml([H|T]):-write(H,','),wdoml(T).
  wdoml([]).

  wtok(name(NAME,_)):-write(NAME,"()").
  wtok(cmp(FUNC,_,DOML)):-
	write(FUNC,"("),wdoml(DOML),write(')').


