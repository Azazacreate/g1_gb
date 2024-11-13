/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  FAMILY
 FileName: FAMILY.PRO
 Purpose: No description
 Written by: Visual Prolog
 Comments:
******************************************************************************/


database - tmp
  son(STRING,STRING)
  sister(STRING,STRING)
  brother(STRING,STRING)
  married(STRING,STRING)

clauses
  son("John","Dan").
  sister("Mary","Suzan").
  brother("Harold","Larry").
  married("John","Mary").
  married("Larry","Sue").

predicates
  father(STRING father,STRING child)
  grandfather(STRING grandfather,STRING grandchild)
  sister_in_law(STRING,STRING)

clauses
  father(A,B):-
	son(B,A).

  grandfather(A,B):-
	father(A,C),
	father(C,B).

  sister_in_law(A,B):-
	married(A,C),
	sister(C,B).
  sister_in_law(A,B):-
	brother(A,C),
	married(C,B).

goal
  sister_in_law("John",Z),
  format(Msg,"sister_in_law(\"John\",%)",Z),
  write(Msg).
%goal
% sister_in_law("Harold",Z).