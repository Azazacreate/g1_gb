/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: CH11E02.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: 
******************************************************************************/
diagnostics	%should be placed before the start of the program text 

predicates
  plus(integer,integer,integer) - nondeterm (i,i,o)
  num(integer) - nondeterm (o)

clauses
  plus(X,Y,Z):-
	bound(X),
	bound(Y),
	Z=X+Y. /* (i,i,o) */
  plus(X,Y,Z):-
	bound(Y),
	bound(Z),
	X=Z-Y. /* (o,i,i) */
  plus(X,Y,Z):-
	bound(X),
	bound(Z),
	Y=Z-X. /* (i,o,i) */
  plus(X,Y,Z):-
	free(X),
	free(Y),
	bound(Z),
	num(X),
	Y=Z-X. /* (o,o,i) */
  plus(X,Y,Z):-
	free(X),
	free(Z),
	bound(Y),
	num(X),
	Z=X+Y. /* (o,i,o) */
  plus(X,Y,Z):-
	free(Y),
	free(Z),
	bound(X),
	num(Y),
	Z=X+Y. /* (i,o,o) */
  plus(X,Y,Z):-
	free(X),
	free(Y),
	free(Z),
	num(X),
	num(Y),
	Z=X+Y. /* (o,o,o) */

   /* Generator of numbers starting from 0 */
  num(0).
  num(X):-
	num(A),
	X = A+1.

goal
  plus(3,5,Z).
