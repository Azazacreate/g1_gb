/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: CH06E11.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: 
******************************************************************************/

domains
  chartree = tree(char, chartree, chartree); end

predicates
  do(chartree) - nondeterm (i)
  action(char,chartree,chartree) - determ (i,i,o)
  create_tree(chartree,chartree) - procedure (i,o)
  insert(char,chartree,chartree) - procedure (i,i,o)
  write_tree(chartree) - procedure (i)
  repeat - nondeterm ()

clauses
  do(Tree):-
	repeat,nl,
	write("*******************************************************"),nl,
	write("Enter 1 to update tree\n"),
	write("Enter 2 to show tree\n"),
	write("Enter 7 to exit\n"),
	write("*******************************************************"),nl,
	write("Enter number - "),
	readchar(X),nl,
	action(X, Tree, NewTree),
	do(NewTree).

  action('1',Tree,NewTree):-
	write("Enter characters or # to end: "),
	create_Tree(Tree, NewTree).
  action('2',Tree,Tree):-
	write_Tree(Tree),
	write("\nPress a key to continue"),
	readchar(_),nl.
  action('7', _, end):-
	exit.

  create_Tree(Tree, NewTree):-
	readchar(C),
	C<>'#',!,
	write(C, " "),
	insert(C, Tree, TempTree),
	create_Tree(TempTree, NewTree).
	create_Tree(Tree, Tree).

  insert(New,end,tree(New,end,end)):-!.
  insert(New,tree(Element,Left,Right),tree(Element,NewLeft,Right)):-
	New<Element,!,
	insert(New,Left,NewLeft).
  insert(New,tree(Element,Left,Right),tree(Element,Left,NewRight)):-
	insert(New,Right,NewRight).

  write_Tree(end).
  write_Tree(tree(Item,Left,Right)):-
	write_Tree(Left),
	write(Item, " "),
	write_Tree(Right).

  repeat.
  repeat:-repeat.

goal
  write("*************** Character tree sort *******************"),nl,
  do(end).

