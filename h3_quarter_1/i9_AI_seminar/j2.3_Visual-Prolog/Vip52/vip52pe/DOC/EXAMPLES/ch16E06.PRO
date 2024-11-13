/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: CH16E06.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: 
******************************************************************************/

domains
  letter = char
  word_ = letter*

predicates
  divide(word_,word_,word_,word_) - nondeterm (i,i,o,o)
  vocal(letter) - determ (i)
  consonant(letter) - determ (i)
  string_word(string,word_) - nondeterm (i,o), nondeterm (o,i)
  append(word_,word_,word_)
  repeat - nondeterm ()
  quit(string) - procedure (i)

clauses
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

  repeat.
  repeat:-repeat.

  quit(""):-exit.
  quit(_).

goal
  repeat,
  write("Write a multi-syllable word: "),
  readln(S),nl,
  quit(S),
  string_word(S,Word),
  divide([],Word,Part1,Part2),
  string_word(Syllable1,Part1),
  string_word(Syllable2,Part2),
  write("Division: ",Syllable1,"-",Syllable2),nl,
  fail.

