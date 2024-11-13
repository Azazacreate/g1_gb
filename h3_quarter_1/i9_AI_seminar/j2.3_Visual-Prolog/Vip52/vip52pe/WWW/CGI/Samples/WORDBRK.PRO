/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  WORDBRK
 FileName: WORDBRK.PRO
 Purpose: No description
 Written by: Visual Prolog
 Comments:
******************************************************************************/
include "cgiexam.inc"

DOMAINS
	letter = char
	word_ = letter*

PREDICATES
	nondeterm divide(word_,word_,word_,word_)
	vocal(letter)
	consonant(letter)
	nondeterm string_word(string,word_)
	append(word_,word_,word_)
CLAUSES
  divide(Start,[T1,T2,T3|Rest],D1,[T2,T3|Rest]):-
	vocal(T1),
	consonant(T2),
	vocal(T3),
        append(Start,[T1],D1).
  divide(Start,[T1,T2,T3,T4|Rest],D1,[T3,T4|Rest]):-
	vocal(T1),
	consonant(T2),
	consonant(T3),
	vocal(T4),
        append(Start,[T1,T2],D1).
  divide(Start,[T1|Rest],D1,D2):-
	append(Start,[T1],S),
	divide(S,Rest,D1,D2).

  vocal('a').
  vocal('e').
  vocal('i').
  vocal('o').
  vocal('u').
  vocal('y').

  consonant(B):-
	not(vocal(B)),
	B <= 'z',
	'a' <= B.

  string_word("",[]):-!.
  string_word(Str,[H|T]):-
	bound(Str),
	frontchar(Str,H,S),
	string_word(S,T).
  string_word(Str,[H|T]):-
	free(Str),
	bound(H),
	string_word(S,T),
	frontchar(Str,H,S).

  append([],L,L):-!.
  append([X|L1],L2,[X|L3]):-
	append(L1,L2,L3).


PREDICATES
  nondeterm member(parm,parmlist)
  runme(parmlist)
CLAUSES
  member (X,[X|_]).
  member (X,[_|Y]):-member(X,Y).
	
  runme(Parmlist) :-
  	member (parm("txt",S),ParmList),
	string_word(S,Word),
	divide([],Word,Part1,Part2),
	  string_word(Syllable1,Part1),
	  string_word(Syllable2,Part2),
	  write("<p>Division: ",Syllable1,"-",Syllable2),nl,
	fail.
  runme (_).

GOAL
        write("Content-type: text/html\n\n"),
        write("<html>\n"),
        write("<body>\n"),
	ParmList = cgi_GetParmList(), 
	runme(ParmList),
	write("</body>\n"),
	write("</html>\n").

