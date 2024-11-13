/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: A_168_4.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments:
	Please note, we have added a KEY associated with each text string
	to make this example a bit more realistic.
******************************************************************************/

DOMAINS
  text = string
  KEY = string

DATABASE - textlink
  link(key,text)

PREDICATES
  w_str(string)
  options
  showtext
  showkey(KEY)
  do_choice(char)
  nondeterm repeat

CLAUSES
  do_choice('a'):-
	not(link(_,_)),!,
	write("Please enter a key for text :"),nl,
	% Your options
	readln(KEY),KEY<>"",nl,nl,
	write("Please enter a line of text :"),nl,
	readln(Text),nl,
	asserta(link(Key,Text)).

  do_choice('a'):-
	write("Please enter a key for text :"),
	write("\nOptions are:\n"),
	options,
	readln(KEY),KEY<>"",
	write("\n\nPlease enter a line of text :"),nl,
	readln(Text),nl,
	assertz(link(KEY,Text)).

  do_choice('s'):-
	showtext,
	readchar(_),nl.

  do_choice('k'):-
	write("enter key:"),nl,
	readln(Key),
	showkey(Key),
	readchar(_),nl.

  do_choice('x'):-
	exit.

  showtext:-
	link(Key,Text),
	write(KEY,"\n",Text),nl,nl,
	fail.
  showtext.

  showkey(KEY):-
	link(Key,Text),!,
	write("\n",Text).
	showkey(Key):-nl,
	write("ERROR !",KEY," is an invalid key."),
	readchar(_),nl.

  Options:-
	link(_,Str),
	w_str(Str),fail.
  Options.

  w_str(""):-!.
  w_str(Str):-
	fronttoken(Str,Sym,Rest),
	write(Sym),nl,
	w_str(Rest).

  repeat.
  repeat:-repeat.

GOAL
  repeat,
  write("******************** HYPER TEXT ************************"),nl,nl,nl,
  write("          ********** Main Menu **********"),nl,
  write("          *  1. (A)dd a new text        *"),nl,
  write("          *  2. (S)how all text         *"),nl,
  write("          *  3. (K)ey text              *"),nl,
  write("          *  4. e(X)it program          *"),nl,
  write("          *******************************"),nl,nl,nl,
  write(" Select your option by selecting first letter"),nl,
  write("********************************************************"),nl,
  readchar(Choice),
  do_choice(Choice).
