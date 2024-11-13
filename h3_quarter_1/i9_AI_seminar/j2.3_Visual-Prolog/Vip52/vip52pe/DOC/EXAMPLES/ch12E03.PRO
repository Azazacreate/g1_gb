/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: CH12E03.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: 
******************************************************************************/

domains
  expr = number(integer); x; log(expr);
  plus(expr, expr); mult(expr, expr)

predicates
  writeExp(expr) - procedure (i)

clauses
  writeExp(x):-write('x').
  writeExp(number(No)):-write(No).
  writeExp(log(Expr)):-
	write("log("), writeExp(Expr), write(')').
  writeExp(plus(U1, U2)):-
	writeExp(U1),
	write('+'),
	writeExp(U2).
  writeExp(mult(U1,U2)):-
	writeExp(U1),
	write('*'),
	writeExp(U2).

goal
  writeExp(plus(mult(x,number(99)),mult(number(3),x))),nl.