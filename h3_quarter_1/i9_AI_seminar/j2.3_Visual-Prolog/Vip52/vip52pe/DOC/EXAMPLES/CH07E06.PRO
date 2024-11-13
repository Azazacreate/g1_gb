/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: CH07E06.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: 
******************************************************************************/

domains
  namelist = name*
  name = symbol

predicates
  member(name,namelist) - nondeterm (i,i)

clauses
  member(Name,[Name|_]).
  member(Name,[_|Tail]):-
	member(Name,Tail).

goal
  member(susan,[ian,susan,john]).