/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: A_143.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: Uses backtracking to print all solutions to a query.
******************************************************************************/

predicates
  country(symbol,real) - nondeterm (o,o)
  %      (name,population)
  print_countries - procedure ()

clauses
  country(england,3e7).
  country(france,2.3e7).
  country(germany,1.6e7).
  country(denmark,2.4e6).
  country(canada,7.3e6).
  country(chile,2.5e6).

  print_countries :-
	country(X,P),     /* bind country name to X and population to P */
	P > 1e7,          /* is population greater than 10 million? */
	write(X),         /* write the value of X */
	nl,               /* start a new line */
	fail.             /* force backtracking to find all solutions */
  print_countries.       /* make sure print_countries succeeds */

goal
  print_countries.
  