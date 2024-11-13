/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: A_168_3.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments:
	Please note, we have added a KEY associated with each text string
	to make this example a bit more realistic.
******************************************************************************/

domains
  textlink = link(KEY,Text,TextLink) ; nil
  text = string
  KEY = string

predicates
  w_str(string) - determ (i)
  do(textlink) - nondeterm (i)
  options(textlink) - determ (i)
  insert(KEY,string,textlink,textlink) - procedure (i,i,i,o)
  showtext(textlink) - procedure (i)
  showkey(KEY,textlink) - nondeterm (i,i)
  do_choice(char,textlink,textlink) - nondeterm (i,i,o)
  repeat - nondeterm ()

clauses
  do(Link):-
	write("******************** HYPER TEXT ************************"),nl,nl,nl,
	repeat,
	write("          ********** Main Menu **********"),nl,
	write("          *  1. (A)dd a new text        *"),nl,
	write("          *  2. (S)how all text         *"),nl,
	write("          *  3. (K)ey text              *"),nl,
	write("          *  4. e(X)it program          *"),nl,
	write("          *******************************"),nl,nl,nl,
	write(" Select your option by selecting first letter"),nl,
	write("********************************************************"),nl,
	readchar(Choice),
	do_choice(Choice,Link,NewLink),
	do(NewLink).

  do_choice('a',nil,link(KEY,Text,nil)):-
	write("Please enter a key for text :"),
	nl,
    % Your options
	readln(KEY),
	KEY<>"",
	nl,
	nl,
	write("Please enter a line of text :"),
	nl,
	readln(Text),
	nl.

  do_choice('a',Link,NewLink):-
	write("Please enter a key for text :"),
	nl,
	write("\nOptions are:\n"),
	options(Link),
	readln(KEY),
	KEY<>"",
	nl,
	nl,
	write("Please enter a line of text :"),
	nl,
	readln(Text),
	nl,
	insert(KEY,Text,Link,NewLink).

  do_choice('s',Link,Link):-
	showtext(Link),
	readchar(_),
	nl.

  do_choice('k',Link,Link):-
	write("enter key:"),
	nl,
	readln(Key),
	showkey(Key,Link),
	readchar(_),
	nl.

  do_choice('x',_,_):-
	exit.

  insert(KEY,Text,nil,link(KEY,Text,nil)):-!.

  insert(KEY,Text,link(Old_id,OldText,Next),link(Old_id,Oldtext,NewNext)):-
	insert(KEY,Text,Next,NewNext).

  showtext(nil).
  showtext(link(KEY,Text,Next)):-
	write(KEY,"\n",Text),
	nl,
	nl,
	showtext(Next).

  showkey(KEY,link(KEY,Text,_)):-!,
	write(KEY,"\n",Text).
  showkey(KEY,link(_,_,Next)):-
	showkey(KEY,Next).
  showkey(KEY,_):-
	nl,
	write("ERROR !",KEY," is an invalid key."),
	readchar(_),
	nl.

  repeat.
  repeat:-repeat.

  w_str(""):-!.
  w_str(Str):-
	fronttoken(Str,Sym,Rest),
	write(Sym),
	nl,
	w_str(Rest).

  options(link(_,Str,nil)):-!,
	w_str(Str).
  options(link(_,Str,Link)):-!,
	w_str(Str),
	Options(Link).

goal
  do(nil).
