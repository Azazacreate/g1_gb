/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  PARSER
 FileName: PARSE.PRO
 Purpose: Syntactical Analysis
 Written by: Eugene Akimov
 Comments:
******************************************************************************/

PREDICATES
  determ	convert_token_to_string(TOK, STRING)
  determ	expect(CURSORTOK, TOKL, TOKL)
  determ	insure_all_tokens_were_processed(TOKL)
  nondeterm	member(PRODNAME, PRODNAMES)
  determ	syntax_error(STRING, TOKL)

include "PARSER.PAR"
include "ASSERT.PRO"
include "CHECK.PRO"	

CLAUSES
/************************************************************************
 *									*
 *	convert_token_to_string/2					*
 *									*
 ************************************************************************/

  convert_token_to_string(TOKEN, STRING) :-
  	string_token(STRING, TOKEN),
  	!.

  convert_token_to_string(upper(""), "production name") :- !.

  convert_token_to_string(id(""), "identifier") :- !.
  	
  convert_token_to_string(arrow, "->") :- !.
  	
  convert_token_to_string(priorsepp, "--") :- !.
  	

/************************************************************************
 *									*
 *	expect/3							*
 *									*
 ************************************************************************/

  expect(TOK, [TOK|L], L) :- !.
  
  expect(t(TOK,_), [t(_,CURSOR)|_], _) :-
	is_a_better_error(CURSOR),
	convert_token_to_string(TOK, STR),
	concat(STR, " expected", MSG),
	change_error(MSG, CURSOR),
	fail.


/************************************************************************
 *									*
 *	insure_all_tokens_were_processed/1				*
 *									*
 ************************************************************************/

  insure_all_tokens_were_processed([]) :- !.

  insure_all_tokens_were_processed([t(_,CURSOR)|_]) :-
	is_a_better_error(CURSOR),
	change_error("Syntax error", CURSOR).


/************************************************************************
 *									*
 *	member/2							*
 *									*
 ************************************************************************/

  member(X, [X|_]).
  
  member(X, [_|L]) :-
  	member(X, L).
  

/************************************************************************
 *									*
 *	parse/1								*
 *									*
 ************************************************************************/

 parse(TOKENS) :-
	s_parser(TOKENS, UNPROCESSED_TOKENS, PARSER),
	insure_all_tokens_were_processed(UNPROCESSED_TOKENS),
	assertparser(PARSER),
	check_parser.


/************************************************************************
 *									*
 *	syntax_error/2							*
 *									*
 ************************************************************************/

  syntax_error(PROD, [t(_,CURSOR)|_]) :-
	is_a_better_error(CURSOR),
	concat("Syntax error in ", PROD, MSG),
	change_error(MSG, CURSOR),
	fail.
 