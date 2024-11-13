/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: CH12E04.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: 
******************************************************************************/

domains
  sentence   = sentence(nounphrase, verbphrase)
  nounphrase = nounp(article, noun); name(name)
  verbphrase = verb(verb); verbphrase(verb, nounphrase)
  article, noun, name, verb = symbol

predicates
  write_sentence(sentence) - procedure (i)
  write_nounphrase(nounphrase) - procedure (i)
  write_verbphrase(verbphrase) - procedure (i)

clauses
  write_sentence(sentence(S,V)):-
	write_nounphrase(S),
	write_verbphrase(V).
  write_nounphrase(nounp(A,N)):-
	write(A,' ',N,' ').
  write_nounphrase(name(N)):-write(N,' ').
  write_verbphrase(verb(V)):-write(V,' ').
  write_verbphrase(verbphrase(V,N)):-
	write(V,' '),
	write_nounphrase(N).

goal
  write_sentence(sentence(name(bill),verb(jumps))),nl.