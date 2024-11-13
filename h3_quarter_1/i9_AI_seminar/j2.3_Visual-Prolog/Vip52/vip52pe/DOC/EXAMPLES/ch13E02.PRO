/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: CH13E02.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: 
******************************************************************************/

domains
  namelist = name*
  name  = symbol

predicates
  string_namelist(string,namelist) - procedure (i,o)

clauses
  string_namelist(S,[H|T]):-
	fronttoken(S,H,S1),!,
	string_namelist(S1,T).
  string_namelist(_,[]).

goal
  string_namelist("bill fred tom dick harry",X).
