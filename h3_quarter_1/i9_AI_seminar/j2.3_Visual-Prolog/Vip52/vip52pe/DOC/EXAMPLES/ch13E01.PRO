/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: CH13E01.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: 
******************************************************************************/

domains
  charlist = char*

predicates
  string_chlist(string,charlist) - determ (i,o)

clauses
  string_chlist("", []):-!.
  string_chlist(S, [H|T]):-
	frontchar(S,H,S1),
	string_chlist(S1,T).

goal
  string_chlist("ABC",Z).
