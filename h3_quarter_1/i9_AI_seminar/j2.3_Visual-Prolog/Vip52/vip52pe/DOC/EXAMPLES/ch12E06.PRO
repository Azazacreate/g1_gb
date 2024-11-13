/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: CH12E06.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: 
******************************************************************************/

facts
  person(string,integer,real)

predicates
  run - procedure ()

clauses
  person("Pete Ashton",20,11111.111).
  person("Marc Spiers",32,33333.333).
  person("Kim Clark",28,66666.666).

  run:-
    % Name   is left-justified, at least 15 characters wide
    % Age    is right-justified, 2 characters wide
    % Income is right-justified, 9 characters wide, with 2
    %        decimal places, printed in fixed-decimal notation

	person(N, A, I),
	writef("Name= %-15, Age= %2, Income= $%9.2f \n",N,A,I),
	fail
	;
	true.

goal
  run.