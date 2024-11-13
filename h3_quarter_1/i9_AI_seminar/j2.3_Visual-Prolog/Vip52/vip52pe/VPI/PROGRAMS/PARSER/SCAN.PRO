/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  PARSER
 FileName: SCAN.PRO
 Purpose: Lexical Analysis
 Written by: Eugene Akimov
 Comments:
******************************************************************************/

PREDICATES
  determ	get_token(integer, STRING, TOK, STRING, STRING, CURSOR)
  determ	is_a_space(CHAR)
  determ	scan_aux(integer, TEXT, TOKL)
  determ	scan_error(STRING, integer)
  determ	skip_spaces(STRING, STRING, INTEGER)
  determ	string_token(STRING, TOK)


CLAUSES
/************************************************************************
 *									*
 *	get_token/6							*
 *									*
 ************************************************************************/

  get_token(_, STRING, TOKEN, REST, REST, 0) :-
  	string_token(STRING, TOKEN),
  	!.
  	
  get_token(_, "-", arrow, REST_IN, REST_OUT, 1) :- 
  	frontchar(REST_IN, '>', REST_OUT),
  	!.

  get_token(_, "-", priorsepp, REST_IN, REST_OUT, 1) :-
  	frontchar(REST_IN, '-', REST_OUT),
  	!.

  get_token(_, STRING, upper(STRING), REST, REST, 0) :-
  	frontchar(STRING, FRONTCHAR, _),
  	FRONTCHAR >= 'A',
  	FRONTCHAR <= 'Z',
  	!.

  get_token(_, STRING, id(STRING), REST, REST, 0) :-
  	isname(STRING),
  	!.

  get_token(CURSOR, _, _, _, _, _) :-
  	scan_error("Illegal token", CURSOR),
  	fail.

/************************************************************************
 *									*
 *	is_a_space/1							*
 *									*
 ************************************************************************/

  is_a_space(' ').
  is_a_space('\t').
  is_a_space('\n').

/************************************************************************
 *									*
 *	scan/1								*
 *									*
 ************************************************************************/

  scan(TOKENS) :-
	grammar(SOURCE),
	scan_aux(0, SOURCE, TOKENS).

/************************************************************************
 *									*
 *	scan_aux/3							*
 *									*
 ************************************************************************/

  scan_aux(STARTING_POSITION, STRING, [t(TOKEN, LOCATION_OF_TOKEN)|TAIL]) :-
	skip_spaces(STRING, NEW_STRING, NUMBER_OF_SPACES),
	LOCATION_OF_TOKEN = STARTING_POSITION + NUMBER_OF_SPACES,
	fronttoken(NEW_STRING, FRONT_TOKEN, REST),
	!,
	get_token(LOCATION_OF_TOKEN, 
		  FRONT_TOKEN, 
		  TOKEN, 
		  REST, 
		  NEW_REST, 
		  NUMBER_OF_EXTRA_CHARACTERS_USED),
	str_len(FRONT_TOKEN, LENGTH_OF_FRONT_TOKEN),
	NEW_STARTING_POSITION =   LOCATION_OF_TOKEN 
				+ LENGTH_OF_FRONT_TOKEN 
				+ NUMBER_OF_EXTRA_CHARACTERS_USED,
	scan_aux(NEW_STARTING_POSITION, NEW_REST, TAIL).

  scan_aux(_, _, []).


/************************************************************************
 *									*
 *	scan_error/2							*
 *									*
 ************************************************************************/

  scan_error(MSG, CURSOR) :-
  	is_a_better_error(CURSOR),
	change_error(MSG, CURSOR),
	fail.


/************************************************************************
 *									*
 *	skip_spaces/3							*
 *									*
 ************************************************************************/

  skip_spaces(STRING, STRING2, NUMBER_OF_SPACES):-
	frontchar(STRING, CH, STRING1),
	is_a_space(CH),
	!,		
	skip_spaces(STRING1, STRING2, N1),
	NUMBER_OF_SPACES = N1 + 1.
	
  skip_spaces(STRING, STRING, 0).


/************************************************************************
 *									*
 *	string_token/2							*
 *									*
 ************************************************************************/

  string_token(",",		comma		) :- !.
	
  string_token(":",		colon		) :- !.

  string_token("(",		lpar		) :- !.

  string_token(")",		rpar		) :- !.

  string_token("*",		star		) :- !.

  string_token("+",		plus		) :- !.

  string_token("=",		equal		) :- !.

  string_token("separator",	separator_	) :- !.

  string_token("productions",	productions_	) :- !.

  string_token("rightassoc",	rightassoc_	) :- !.

  string_token("userdefined",	userdefined_	) :- !.

  string_token("domains",        domains_     ):-!.
 