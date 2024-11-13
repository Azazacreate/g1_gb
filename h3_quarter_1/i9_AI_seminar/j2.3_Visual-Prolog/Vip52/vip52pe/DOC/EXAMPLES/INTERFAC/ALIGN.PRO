/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: ALIGN.PRO
 Purpose: 
 Written by: PDC
 Comments: 
******************************************************************************/

domains
  dom = struct f(char,integer)
  dom1 = align word f(integer,integer,long); g(string)
  refint = reference integer

predicates
  refint(refint)

clauses
  refint(_).

goal	% Find the size of a functorless domain
	A = sizeof(dom),
	write("\nSize=",A),

	% when there are alternatives, the largest is returned
	B = sizeof(dom1),
	write("\nSize=",B),

	% Find size of a single alternative
	C = sizeof(dom1,g),
	write("\nSize=",C),

	% Find size of a term pointed to by a variable
	X = f(1,1,1),	% This is from dom1
	D = sizeof(X),
	write("\nSize=",D),

	% Find size of a string pointed to by a variable
	Y = "hello there",
	E = sizeof(Y),
	write("\nSize=",E),

	% Find size of a reference variable
	refint(Z),
	F = sizeof(Z),
	write("\nSize=",F),nl.
