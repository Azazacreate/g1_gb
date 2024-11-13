/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: CH06E01.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: 
******************************************************************************/

predicates
  country(symbol) - nondeterm (o)
  print_countries - procedure ()

clauses
  country("England").
  country("France").
  country("Germany").
  country("Denmark").

  print_countries:-
	country(X),
	write(X),         /* write the value of X */
	nl,              /* start a new line */
	fail.
  print_countries.

goal
  print_countries.
