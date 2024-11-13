/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: CH06E03.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: 
	Recursive program to compute factorials.
	Ordinary recursion, not tail recursion.
******************************************************************************/

predicates
  factorial(unsigned,real) - procedure (i,o)

clauses
  factorial(1,1.0):-!.

  factorial(X,FactX):-
	Y=X-1,
	factorial(Y,FactY),
	FactX = X*FactY.

goal
  X=3,
  factorial(X,Y).
