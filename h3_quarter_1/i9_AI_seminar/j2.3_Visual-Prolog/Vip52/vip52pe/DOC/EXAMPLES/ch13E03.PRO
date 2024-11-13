/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: CH13E03.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: 
******************************************************************************/

predicates
  nd_searchchar(string,char,integer) - nondeterm (i,i,o)
  nd_searchchar1(string,char,integer,integer) - nondeterm (i,i,o,i)
  nd_sc(string,char,integer,integer,integer) - nondeterm (i,i,o,i,i)

clauses
  nd_searchchar(Str,Ch,Pos):-
	nd_searchchar1(Str,Ch,Pos,0).

  nd_searchchar1(Str,Ch,Pos,Old):-
	searchchar(Str,Ch,Pos1),
	nd_sc(Str,Ch,Pos,Pos1,Old).

  nd_sc(_,_,Pos,Pos1,Old):- Pos = Pos1+Old.
  nd_sc(Str,Ch,Pos,Pos1,Old):-
	frontstr(Pos1,Str,_,Rest),
	Old1 = Old + Pos1,
	nd_searchchar1(Rest,Ch,Pos,Old1).

goal
  nd_searchchar("abbalblablabbala",'a',P),
  write(P,'\n'),
  fail.
