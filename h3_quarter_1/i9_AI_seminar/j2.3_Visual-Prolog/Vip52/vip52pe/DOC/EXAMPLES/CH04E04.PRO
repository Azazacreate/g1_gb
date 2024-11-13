/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: CH04E04.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: 
******************************************************************************/

domains
  name,thing = symbol

predicates
  likes(name,thing) - determ (o,i)
  reads(name) - procedure (o)
  is_inquisitive(name) - determ (i)

clauses
  likes(john,wine):-!.
  likes(lance,skiing):-!.
  likes(lance,books):-!.
  likes(lance,films):-!.
  likes(Z,books):-
	reads(Z),
	is_inquisitive(Z).

  reads(john).

  is_inquisitive(john).

goal
  likes(X,wine).
