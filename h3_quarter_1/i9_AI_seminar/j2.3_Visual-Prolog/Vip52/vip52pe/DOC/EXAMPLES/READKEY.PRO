/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: READKEY.PRO
 Purpose: 
 Written by: PDC
 Comments: 
******************************************************************************/

ifdef os_unix
  include "/usr/local/PDCProlog/programs/readkey.pre"
elsedef
  ifdef os_os2
    include "C:\\VIP52\\Doc\\Examples\\readkey.pre"
  elsedef
    include "C:\\Program Files\\VIP52\\Doc\\Examples\\readkey.pre"
  enddef
enddef

/****************************************************************/
/* Note for UNIX users: wdinit must be called, in order to	*/
/* initialize the program for terminal i/o, before special	*/
/* keys such as the function and cursor-movement keys can	*/
/* be recognized.						*/
/****************************************************************/

domains
   key = cr; esc; break; tab; btab; del; bdel; ins; end; home;
   fkey(integer); up_arrow; down_arrow; left_arrow; right_arrow;
   char(char); other

predicates
   readkey(key) - determ (o)
   key_code(key,char,integer) - determ (o,i,i)
   key_code2(key,integer)

clauses
   readkey(Key):-
	readchar(T),
	char_int(T,Val),
	key_code(Key,T,Val).

ifndef os_unix
   key_code(break,_,key_break_):-!.
   key_code(bdel,_,key_backspace_):-!.
enddef
   key_code(tab,_,9):-!.
   key_code(cr,_,13):-!.
   key_code(esc,_,27):-!.
   key_code(Key,_,0):-!,
	readchar(T),
	char_int(T,Val),
	key_code2(Key,Val).
   key_code(char(T),T,_).

ifdef os_unix
   key_code2(bdel,key_backspace_):-!.
   key_code2(break,key_break_):-!.
enddef
   key_code2(btab,key_btab_):-!.
   key_code2(home,key_home_):-!.
   key_code2(up_arrow,key_up_):-!.
   key_code2(left_arrow,key_left_):-!.
   key_code2(right_arrow,key_right_):-!.
   key_code2(end,key_end_):-!.
   key_code2(down_arrow,key_down_):-!.
   key_code2(ins,key_ic_):-!.
ifdef os_unix
   key_code2(del,key_dc_):-!.  % UNIX: unless stty'ed otherwise, del is break
   key_code2(fkey(N),V):-
	V>=key_f0_,
	V<=key_f63_,!,
	N=V-key_f0_.
elsedef
   key_code2(fkey(N),V):-
	V>58,
	V<70,!,
	N=V-58.
enddef
   key_code2(other,_).
