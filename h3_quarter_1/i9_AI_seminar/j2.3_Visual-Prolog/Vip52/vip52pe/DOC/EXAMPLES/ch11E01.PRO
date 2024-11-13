/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: CH11E01.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: 
******************************************************************************/

diagnostics	% should be placed before the start of the program text 

domains
  cinfo 	= area(string,ulong); 
		  population(string,ulong);
		  capital(string,string)

predicates
 country(cinfo) - nondeterm (i), nondeterm (o), nondeterm (area(o,o)), nondeterm (population(i,o))

clauses
  country(area("Denmark",16633)).
  country(population("Denmark",5097000)).
  country(capital("Denmark","Copenhagen")).
  country(area("Singapore",224)).
  country(population("Singapore",2584000)).
  country(capital("Singapore","Singapore")).

goal
  country(C),					
  country(area(Name,Area)),			
  country(population("Denmark",Pop)),		
  country(capital("Singapore","Singapore")).	