/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: CSUM_P.PRO
 Purpose: 
 Written by: PDC
 Comments: 
******************************************************************************/
project "csum"

global predicates
  integer sum_verify(char,char,string,ulong) - (i,i,i,o) language asm

predicates
  uc_check(string)

clauses
  uc_check(S):-
	0 = sum_verify('A','Z',S,Sum), !,
	write('"',S,"\" OK, sum = ",Sum,'\n').
  uc_check(S):- write('"',S,"\" fails\n").

goal
	uc_check("UNIX"),
	uc_check("Windows").
