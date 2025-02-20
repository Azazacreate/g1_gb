/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: CH06E08.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: 
******************************************************************************/

predicates
  factorial(unsigned,real) - procedure (i,o)
  factorial(unsigned,real,unsigned,real) - procedure (i,o,i,i)

/* Numbers likely to become large are declared as reals. */

clauses
  factorial(N,FactN):-
	factorial(N,FactN,1,1.0).

  factorial(N,FactN,N,FactN):-!.
  factorial(N,FactN,I,P):-
	NewI = I+1,
	NewP = P*NewI,
	factorial(N, FactN, NewI, NewP).

goal
  factorial(3,X).
