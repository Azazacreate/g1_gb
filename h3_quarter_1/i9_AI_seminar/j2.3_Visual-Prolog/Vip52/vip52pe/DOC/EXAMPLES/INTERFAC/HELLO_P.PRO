/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  
 FileName: HELLO_P.PRO
 Purpose: 
 Written by: PDC
 Comments: 
******************************************************************************/
project "hello"

global predicates
  char prowin_msg(string) - (i) language c
  hello_c - language c

clauses
  prowin_msg(S,C) :-
	write(S," (press any key)"), readchar(C).

goal
ifdef os_unix
	wdinit,
enddef
	prowin_msg("Hello from PDC Prolog"),
	hello_c.
