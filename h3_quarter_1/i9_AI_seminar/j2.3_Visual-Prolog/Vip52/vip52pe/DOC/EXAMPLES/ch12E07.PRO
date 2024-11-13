/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: CH12E07.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: 
******************************************************************************/

domains
  person = p(name, age, telno, job)
  age = integer
  telno, name, job = string

predicates
  run - procedure ()

clauses
  run:-
      write("Which name ? "), readln(Name),
      write("Job ? "), readln(Job),
      write("Age ? "), readint(Age),
      write("Telephone no ? "), readln(Telno),
      P=p(Name,Age,Telno,Job),
      write(P),nl,
      write("Is this compound object OK (y/n)"),
      readchar(Ch),nl,Ch='y', !.

  run :-
	 nl,nl,
	 write("Alright, try again"),
	 nl,nl,run.

goal
  run.
