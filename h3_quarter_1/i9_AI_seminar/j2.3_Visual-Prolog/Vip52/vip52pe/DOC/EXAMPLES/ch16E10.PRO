/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: CH16E10.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: 
******************************************************************************/

predicates
  wait(char) - nondeterm (i)
  equal(char,char) - determ (i,i)
  test(string) - nondeterm (i)
  time_it(string,unsigned) - nondeterm (i,o)
  run - nondeterm ()

clauses
ifdef os_unix
  time_it(Line,Time):-
	marktime(0,T1),
	test(Line),
	marktime(0,T2),
	difftime(T2,T1,Time).
elsedef
  time_it(Line,Time):-
	time(H1,M1,S1,C1),
	test(Line),time(H2,M2,S2,C2),
	Time = C2-C1+100*(S2-S1+60*(M2-M1+60*(H2-H1))).
enddef

  wait(X):-
%	inkey(Y),
	readchar(Y),
	equal(X,Y).
  wait(X):-
	write(X).
	wait(_).

  test(W):-
	frontchar(W,Ch,R),
	wait(Ch),
	write(Ch),
	test(R).
  test("").

  equal(X,X):-!.
  equal(_,_):-fail.

  run:-
	Line = "Peter Piper picked a peck of pickled peppers",
	write("Please type :\n\t", Line,"\n\t"),
	time_it(Line,Hundredths),
	write("\nYou took ",Hundredths," hundredths"),nl.
	
goal
  run.	