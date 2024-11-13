/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: CH09E02.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: 
******************************************************************************/

predicates
  test(real,real) - procedure (i,i)

clauses
  test(X,X):-!,
	write("ok\n").
  test(X,Y):-
	Diff = X-Y,
	write(X,"<>",Y,"\nX-Y = ",Diff,'\n').
  
goal
  X=47.0,
  Y=4.7*10,
  test(X,Y).