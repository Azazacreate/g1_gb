/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: CH06E12.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: 
******************************************************************************/

domains
  treetype = tree(string, treetype, treetype) ; empty
  file     = infile ; outfile

predicates
  main - determ ()
  read_input(treetype) - procedure (o)
  read_input_aux(treetype,treetype) - procedure (i,o)
  insert(string,treetype,treetype) - procedure (i,i,o)
  write_output(treetype) - procedure (i)

clauses
  main :-
	write("PDC Prolog Treesort"),nl,
	write("File to read:  "),
	readln(In),nl,
	openread(infile, In),               /* open the specified file for reading */
	write("File to write: "),
	readln(Out),nl,
	openwrite(outfile, Out),
	readdevice(infile),    /* redirect all read operations to the opened file */
	read_input(Tree),
	writedevice(outfile),  /* redirect all write operations to the opened file */
	write_output(Tree),
	closefile(infile),                    /* close the file opened for reading */
	closefile(outfile).


/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * read_input(Tree)                                            *
 *   reads lines from the current input device until EOF, then *
 *   instantiates Tree to the binary search tree built         *
 *   therefrom                                                 *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

  read_input(Tree):-
	read_input_aux(empty,Tree).

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * read_input_aux(Tree, NewTree)                                *
 *  reads a line, inserts it into Tree giving NewTree,         *
 *  and calls itself recursively unless at EOF.                *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

  read_input_aux(Tree, NewTree):-
	readln(S),
	!,
	insert(S, Tree, Tree1),
	read_input_aux(Tree1, NewTree).

  read_input_aux(Tree, Tree). /* The first clause fails at EOF. */

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *  insert(Element, Tree, NewTree)                             *
 *     inserts Element into Tree giving NewTree.               *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

  insert(NewItem, empty, tree(NewItem,empty,empty)):-!.

  insert(NewItem,tree(Element,Left,Right),tree(Element,NewLeft, Right)):-
	NewItem < Element,
	!,
	insert(NewItem, Left, NewLeft).

  insert(NewItem,tree(Element,Left,Right),tree(Element,Left,NewRight)):-
	insert(NewItem, Right, NewRight).

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * write_output(Tree)                                          *
 *    writes out the elements of Tree in alphabetical order.   *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

  write_output(empty). /* Do nothing */

  write_output(tree(Item,Left,Right)):-
	write_output(Left),
	write(Item), nl,
	write_output(Right).

goal
  main,
  nl.
