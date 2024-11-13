/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: CH16E08.PRO
 Purpose: 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments: 
******************************************************************************/
ifdef os_unix
  include "/usr/local/PDCProlog/programs/readkey.pro"
elsedef
  ifdef os_os2
    include "C:\\VIP52\\Doc\\Examples\\readkey.pro"
  elsedef
    include "C:\\Program Files\\VIP52\\Doc\\Examples\\readkey.pro"
  enddef
enddef

/****************************************************************/
/* Note for UNIX users: wdinit must be called, in order to	*/
/* initialize the program for terminal i/o, before special	*/
/* keys such as the function and cursor-movement keys can	*/
/* be recognized.						*/
/****************************************************************/

predicates
  run - determ ()

clauses
  run:-
ifdef os_unix
	wdinit,	% Must initialize for terminal interface
enddef
	write("Keyboard test. Press a key!"),
	readkey(Key),nl,
	write("The ",Key,"-key was pressed"),nl.

goal
  run.
