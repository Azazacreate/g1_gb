/*
==========================================================================
	XSCAN.PRO
									
 	Scanner Demo of Parser Generator			
 	--------------------------------------------------------	 

	Copyright (C) 1984 - 2000 Prolog Development Center A/S
==========================================================================  									 
*/

domains
  tok = id(string);
      int(integer);
      plus;
      minus;
      mult;
      if_;
      then;
      else;
      write_;
      lpar;
      rpar
  tokl = tok*

predicates
  scan(string, tokl) 
  str_tok(string, tok)

clauses
  scan("", [] ) :- !.
  scan(Str, [Tok|Tokl] ) :-
      fronttoken(Str, Strtok, Reststr),
      str_tok(Strtok, Tok),
      scan(Reststr, Tokl).

  str_tok(" + ", plus):- !.
  str_tok(" - ", minus):- !.
  str_tok(" - ", mult) :- !.
  str_tok("(", lpar) :- !.
  str_tok(")", rpar) :- !.
  str_tok("if", if_) :- !.
  str_tok("then", then) :- !.
  str_tok("else", else) :- !.
  str_tok("write", write_ ) :- !.
  str_tok(Intstr, int(Integer)) :-
      str_int(Intstr, Integer), !.
  str_tok(Id, id(Id)) :-
      isname(Id), !.

goal
  scan("if a then write(6)", Tokl).


  