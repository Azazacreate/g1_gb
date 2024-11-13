/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  SEN_AN
 FileName: SEN_AN.PRO
 Purpose: No description
 Written by: Visual Prolog
 Comments:
******************************************************************************/

facts - senan_db
  det(string)
  noun(string)
  rel(string)
  verb(string)

domains
  DETERM	= none;
  		  determ(string)
  NOUNP		= nounp(DETERM,string,RELCL)
  RELCL		= none;
  		  relcl(string,VERBP)
  SENTENCE	= sent(NOUNP,VERBP)
  VERBP		=verb(string);
		  verbp(string,NOUNP)
  TOKL		= string*

predicates
% Recognition of words in different forms
  is_det(string)
  is_noun(string)
  is_rel(string)
  is_verb(string)

% Parser
  nondeterm s_determ(TOKL,TOKL,DETERM)
  nondeterm s_nounp(TOKL,TOKL,NOUNP)
  nondeterm s_relcl(TOKL,TOKL,RELCL)
  nondeterm s_sentence(TOKL,TOKL,SENTENCE)
  nondeterm s_verbp(TOKL,TOKL,VERBP)

% scanner
  check(string)
  tokl(string,TOKL)

clauses
  s_sentence(TOKL,TOKL2,sent(NOUNP,VERBP)):-
	s_nounp(TOKL,TOKL1,NOUNP),
	s_verbp(TOKL1,TOKL2,VERBP),
	TOKL2=[],
	!.
  s_sentence(_,_,_):-
	write(">> Sentence not recognized\n"),
	fail.

  s_nounp(TOKL,TOKL2,nounp(DETERM,NOUN,RELCL)):-
	s_determ(TOKL,[NOUN|TOKL1],DETERM),
	is_noun(NOUN),
	s_relcl(TOKL1,TOKL2,RELCL).

  s_determ([DETERM|TOKL],TOKL,determ(DETERM)):-
	is_det(DETERM).
  s_determ(TOKL,TOKL,none).

  s_relcl([REL|TOKL],TOKL1,relcl(REL,VERBP)):-
	is_rel(REL),
	s_verbp(TOKL,TOKL1,VERBP).
  s_relcl(TOKL,TOKL,none).

  s_verbp([VERB|TOKL],TOKL1,verbp(VERB,NOUNP)):-
	is_verb(VERB),
	s_nounp(TOKL,TOKL1,NOUNP).
  s_verbp([VERB|TOKL],TOKL,verb(VERB)):-
	is_verb(VERB).

  is_noun(X):-
	noun(X),
	!.
  is_noun(X):-
	noun(Y),
	concat(Y,"s",X),
	!.

  is_det(X):-
	det(X),
	!.

  is_rel(X):-
	rel(X),
	!.

  is_verb(X):-
	verb(X),
	!.
  is_verb(X):-
	verb(Y),
	concat(Y,"s",X),
	!.
  is_verb(X):-
	verb(Y),
	concat(Y,"ed",X),
	!.
  is_verb(X):-
	verb(Y),
	concat(Y,"es",X),
	!.
  is_verb(X):-
	verb(Y),
	concat(Y,"ing",X),
	!.

  tokl(STR,[TOK|TOKL]):-
	fronttoken(STR,TOK,STR1),
	check(TOK),
	!,
	tokl(STR1,TOKL).
  tokl(_,[]).

  check(WORD):-
	is_noun(WORD),
	!.
  check(WORD):-
	is_det(WORD),
	!.
  check(WORD):-
	is_rel(WORD),
	!.
  check(WORD):-
	is_verb(WORD),
	!.
  check(WORD):-
	write(">> Unknown word: ",WORD),
	nl.

goal
  consult("sen_an.dba",senan_db),
  write("Try: every man that lives loves a woman\n"),
  write("Write a sentence: "),
  readln(STR),
  tokl(STR,TOKL),
  s_sentence(TOKL,RESTTOKL,SENT),
  RESTTOKL=[],
  write(SENT).
