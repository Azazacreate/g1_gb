/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: CH04E10.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: 
******************************************************************************/

domains
  name = symbol
  gpa  = real

predicates
  honor_student(name) - nondeterm (o)
  student(name,gpa) - nondeterm (o,o)
  probation(name) - nondeterm (i)

clauses
  honor_student(Name):-
	student(Name,GPA),
	GPA>=3.5,
	not(probation(Name)).

  student("Betty Blue",3.5).
  student("David Smith",2.0).
  student("John Johnson",3.7).

  probation("Betty Blue").
  probation("David Smith").

goal
  honor_student(X).
	