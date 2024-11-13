/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: CH06E07.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: 
******************************************************************************/

predicates
  factorial(unsigned,real) - determ (i,o)
  factorial_aux(unsigned,real,unsigned,real) - determ (i,o,i,i)

/* Numbers likely to become large are declared as reals. */

clauses
  factorial(N,FactN):-
	factorial_aux(N,FactN,1,1.0).

  factorial_aux(N,FactN,I,P):-
	I <= N,!,
	NewP = P * I,
	NewI = I + 1,
	factorial_aux(N,FactN,NewI,NewP).

  factorial_aux(N,FactN,I,P) :-
	I > N,
	FactN = P.

goal
  factorial(3,X).
