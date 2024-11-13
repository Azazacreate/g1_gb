/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: CH06E09.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: 
	Traversing a tree by depth-first search
	and printing each element as it is encountered
******************************************************************************/

domains
  treetype = tree(string, treetype, treetype) ; empty()

predicates
  traverse(treetype) - procedure (i)

clauses
  traverse(empty).

  traverse(tree(Name,Left,Right)):-
	write(Name,'\n'),
	traverse(Left),
	traverse(Right).

goal
  traverse(tree("Cathy",
	   tree("Michael",
	   tree("Charles", empty, empty),
	   tree("Hazel", empty, empty)),
	   tree("Melody",
	   tree("Jim", empty, empty),
	   tree("Eleanor", empty, empty)))).