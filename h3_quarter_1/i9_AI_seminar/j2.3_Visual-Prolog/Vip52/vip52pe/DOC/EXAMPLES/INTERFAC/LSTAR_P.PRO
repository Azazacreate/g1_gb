/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: LSTAR_P.PRO
 Purpose: 
 Written by: PDC
 Comments: 
******************************************************************************/
project "lstar"

global domains
  ilist = integer*

global predicates
  inclist(ilist,ilist) - (i,o) language c

goal
	inclist([1,2,3,4,5,6,7],L), write(L).
