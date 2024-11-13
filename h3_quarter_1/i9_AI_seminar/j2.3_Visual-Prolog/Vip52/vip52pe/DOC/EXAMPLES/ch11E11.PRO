/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: CH11E11.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: 
******************************************************************************/

domains
  dom = align byte cmp(string,short)

predicates
  run - procedure ()

clauses
  run:-
	T = cmp("Bilse",31),
	term_bin(dom,T,B),
	write("Binary form of ",T,":\n",B),
	term_bin(dom,T1,B),
	write("\nConverted back: ",T1,'\n'),beep.

goal
  run.