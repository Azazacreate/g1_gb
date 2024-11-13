/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: CH06E10.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: 
******************************************************************************/

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * Simple tree-building procedures                                         *
 * create_tree(A, B) puts A in the data field of a one-cell tree giving B  *
 * insert_left(A, B, C) inserts A as left subtree of B giving C            *
 * insert_right(A, B, C) inserts A as right subtree of B giving C          *
 *									   *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

domains
  treetype = tree(string,treetype,treetype) ; empty()

predicates
  create_tree(string,treetype) - procedure (i,o)
  insert_left(treetype,treetype,treetype) - determ (i,i,o)
  insert_right(treetype,treetype,treetype) - determ (i,i,o)
  run - determ ()

clauses
  create_tree(A,tree(A,empty,empty)).
  insert_left(X,tree(A,_,B),tree(A,X,B)).
  insert_right(X,tree(A,B,_),tree(A,B,X)).
	
  run:-	
   /* First create some one-cell trees... */

	create_tree("Charles",Ch),
	create_tree("Hazel",H),
	create_tree("Michael",Mi),
	create_tree("Jim",J),
	create_tree("Eleanor",E),
	create_tree("Melody",Me),
	create_tree("Cathy",Ca),

   /* ...then link them up... */

	insert_left(Ch, Mi, Mi2),
	insert_right(H, Mi2, Mi3),
	insert_left(J, Me, Me2),
	insert_right(E, Me2, Me3),
	insert_left(Mi3, Ca, Ca2),
	insert_right(Me3, Ca2, Ca3),

   /* ...and print the result. */

	write(Ca3,'\n').

goal
  run.
