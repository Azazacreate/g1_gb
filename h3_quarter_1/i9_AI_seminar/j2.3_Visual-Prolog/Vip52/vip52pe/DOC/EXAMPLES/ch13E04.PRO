/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: CH13E04.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: 
******************************************************************************/

domains
  intlist = integer*

goal
  write("Input list : "),
  readln(L),nl,
  str_len(L,Len),
  write("The stringlength of ",L),
  write(" is ",Len,'\n').

