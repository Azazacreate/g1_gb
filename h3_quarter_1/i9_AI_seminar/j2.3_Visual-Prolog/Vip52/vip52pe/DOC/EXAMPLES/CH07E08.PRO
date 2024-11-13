/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: CH07E08.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: 
******************************************************************************/

domains
  name,address = string
  age = integer
  list = age*

predicates
  person(name,address,age) - nondeterm (o,o,o)
  sumlist(list,age,integer) - procedure (i,o,o)
  run - procedure ()
   
clauses
  sumlist([],0,0).
  sumlist([H|T],Sum,N):-
	sumlist(T,S1,N1),
	Sum=H+S1, N=1+N1.

  person("Sherlock Holmes", "22B Baker Street", 42).
  person("Pete Spiers", "Apt. 22, 21st Street", 36).
  person("Mary Darrow", "Suite 2, Omega Home", 51).

  run:-
	findall(Age,person(_, _, Age),L),
	sumlist(L,Sum,N),
	Ave = Sum/N,
	write("Average=", Ave),nl.

goal
  run.
