/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: A_184_2.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: This is an example of multiple predicate declarations.
******************************************************************************/

domains
  name        = symbol

  namelist    = name*
  integerlist = integer*	
  reallist    = real*
  stringlist  = string*
  charlist    = char*

predicates
  member(name,namelist) - nondeterm (o,i)
  member(real,reallist) - nondeterm (o,i)
  member(integer,integerlist) - nondeterm (o,i)
  member(string,stringlist) - nondeterm (o,i)
  member(char,charlist) - nondeterm (o,i)

clauses
  member(Head,[Head|_]).
  member(Element,[_|Tail]):-
	member(Element,Tail).

goal
  member(X,[a,b,c]).
