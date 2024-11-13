/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: CH15E03.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: For DOS platform only
******************************************************************************/

predicates
  extend(string,string) 

clauses
  extend(S,S):-
	concat(_,".pro",S),
	!.
  extend(S,S1):-
	concat(S,".pro",S1).

goal
  comline(X),   /* must be compiled to .exe to function correctly */
  extend(X,X1),
  file_str(X1,S),
  makewindow(1,23,8,"EDITOR",0,0,25,80),
  edit(S,S1,"","","",0,"",RET),
  removewindow,
  RET><1,!,
  file_str(X1,S1).
