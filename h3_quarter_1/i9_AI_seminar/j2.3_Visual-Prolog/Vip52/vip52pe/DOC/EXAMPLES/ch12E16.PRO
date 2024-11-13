/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: CH12E16.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: 
******************************************************************************/
ifdef os_unix
  include "/usr/local/PDCProlog/include/iodecl.con"
elsedef
  ifdef os_os2
    include "C:\\VIP52\\Include\\Iodecl.con"
  elsedef
    include "C:\\Program Files\\VIP52\\Include\\Iodecl.con"
  enddef
enddef

predicates
  existdir(string) - determ (i)
  exd1(string) - determ (i)
  exd2(string,string) - determ (i,i)

clauses
  existdir(Wild):-
	diropen(Wild,fa_subdir,Block),
	exd1(Block),
 	dirclose(Block).

  exd1(Block):-
	dirmatch(Block,Name,_,_,_,_,_,_,_,_),
	exd2(Block,Name).

  exd2(_,Name):-
	not(frontchar(Name,'.',_)),!.
  exd2(Block,_):-
	exd1(Block).

goal
  X="*.pro",
  existdir(X).	