/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: CH11E09.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: 
******************************************************************************/

predicates
  comp_unify_bin - procedure ()
  comp_unify(binary,binary) - procedure (i,o), procedure (i,i)
  access(binary) - procedure (i)

clauses
  comp_unify_bin:-
	Bin = makebinary(5),
	comp_unify(Bin,_),
	comp_unify($[1,2],$[100]),
	comp_unify($[0],Bin),
	comp_unify($[1,2,3],$[1,2,4]).

  comp_unify(B,B):-!,
	write(B," = ",B,'\n').
  comp_unify(B1,B2):-
	B1 > B2,!,
	write(B1," > ",B2,'\n').
  comp_unify(B1,B2):-
	write(B1," < ",B2,'\n').

  access(Bin):-
	setwordentry(Bin,3,255),
	fail.  % Changes are not undone when backtracking!
  access(Bin):-
	Size = getbinarysize(Bin),
	X = getwordentry(Bin,3),
	write("\nSize=",Size," X=",X," Bin=",Bin,'\n').
goal
% Illustrate comparison and unification of binary terms
  comp_unify_bin,

% Allocate a binary chunk of 4 words
  WordSize = sizeof(word),
  Bin = makebinary(4,WordSize),
  access(Bin),

% Illustrate range checking; element numbers are 0-relative
  write("Run-time error due to wrong index:\n"),
  Index = 4,
  trap(setwordentry(Bin,Index,0),E,
  write("Error ",E," setting word index ",Index," of ",Bin,'\n')).
