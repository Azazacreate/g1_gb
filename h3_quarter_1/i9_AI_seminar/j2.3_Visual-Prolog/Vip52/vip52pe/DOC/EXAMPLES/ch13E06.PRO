/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: CH13E06.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: 
******************************************************************************/

domains
  sentence    = s(noun_phrase,verb_phrase)

  noun_phrase = noun(noun) ; noun_phrase(detrm,noun)
  noun        = string

  verb_phrase = verb(verb) ; verb_phrase(verb,noun_phrase)
  verb        = string

  detrm       = string

predicates
  s_sentence(string,sentence) - nondeterm (i,o)
  s_noun_phrase(string,string,noun_phrase) - nondeterm (i,o,o), nondeterm (i,i,o)
  s_verb_phrase(string,verb_phrase) - nondeterm (i,o)
  d(string) - determ (i)
  n(string) - nondeterm (i)
  v(string) - determ (i)

clauses
  s_sentence(Str,s(N_Phrase,V_Phrase)):-
	s_noun_phrase(Str, Rest, N_Phrase),
	s_verb_phrase(Rest, V_Phrase).

  s_noun_phrase(Str,Rest,noun_phrase(Detr,Noun)):-
	fronttoken(Str,Detr,Rest1),
	d(Detr),
	fronttoken(Rest1,Noun,Rest),
	n(Noun).

  s_noun_phrase(Str,Rest,noun(Noun)):-
	fronttoken(STR,Noun,Rest),
	n(Noun).

  s_verb_phrase(Str, verb_phrase(Verb,N_Phrase)):-
	fronttoken(Str,Verb,Rest1),
	v(Verb),
	s_noun_phrase(Rest1,"",N_Phrase).

  s_verb_phrase(Str,verb(Verb)):-
	fronttoken(STR,Verb,""),
	v(Verb).

/* determiner */

  d("the").
  d("a").

/* nouns */

  n("bill").
  n("dog").
  n("cat").

/* verbs */

  v("is").

goal
  s_sentence("bill is a cat",Result).