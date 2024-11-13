/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: CH13E05.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: 
******************************************************************************/

domains
  tok  = numb(integer); name(string); char(char)
  toklist = tok*

predicates
  scanner(string,toklist) - nondeterm (i,o)
  maketok(string,tok) - nondeterm (i,o)
  run - nondeterm ()

clauses
  scanner("",[]).
  scanner(Str,[Tok|Rest]):-
	fronttoken(Str, Sym, Str1), maketok(Sym, Tok), scanner(Str1, Rest).

  maketok(S,name(S)):-isname(S).
  maketok(S,numb(N)):-str_int(S,N).
  maketok(S,char(C)):-str_char(S, C).

  run:-
	write("Enter some text:"),nl,
	readln(Text),nl,
	scanner(Text,T_List),
	write(T_List).
goal
  run,
  nl.