/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: CH11E03.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: 
******************************************************************************/
% run Test Goal

diagnostics	%should be placed before the start of the program text 

domains
  refinteger = integer
  reflist = reference refinteger*

predicates
  member(refinteger,reflist) - nondeterm (i,o), nondeterm (o,i)
  append(reflist, reflist, reflist)

clauses
  member(X,[X|_]).
  member(X,[_|L]):-
	member(X,L).

  append([],L,L).
  append([X|L1],L2,[X|L3]):-
	append(L1, L2, L3).

goal 
  member(X,[1,2,3]).
%  member(1,L).		              % Give all lists where 1 is a member 
%  member(X,L), X=1.		      % Same as before 
%  member(1,L), member(2,L).	      % Lists starting with 1 and containing 2 
%  member(X,L),X=Y,member(Y,L),X=3.   % Lists starting with X and containing Y
%  member(1,L), append(L,[2,3],L1).   % Lists starting with X and closing with [2,3] 
%  append(L,L,L1), member(1,L).       % L1 - lists containing 1 as less twice 
