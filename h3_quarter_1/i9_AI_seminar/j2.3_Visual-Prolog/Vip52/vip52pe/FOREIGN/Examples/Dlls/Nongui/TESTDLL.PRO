/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S
		
			VISUAL Prolog

 Project:  TESTDLL
 FileName: TESTDLL.PRO
 Purpose: Demonstrates DLL text
 Written by: Visual Prolog
 Comments:
******************************************************************************/
ifndef ws_win
 #Error: This examples works under Windows-32 platform only
enddef 
ifndef platform_32bit
 #Error: This examples works under Windows-32 platform only
enddef 

include "testdll.inc"

GLOBAL PREDICATES
  procedure dll_mark_gstack(STACKMARK)     - (o) language stdcall
  procedure dll_release_gstack(STACKMARK) - (i) language stdcall
  procedure setInteger(integer In ) - (i) language stdcall
  procedure getInteger(integer Out) - (o) language stdcall
  procedure setReal(real In ) - (i) language stdcall
  procedure getReal(real Out ) - (o) language stdcall
  procedure setString(string In) - (i) language stdcall
  procedure getString(string Out) - (o) language stdcall

DATABASE - dll_database
  single i(integer)
  single r(real)
  single s(string)

CLAUSES
  i(0).
  r(0.0).
  s("Empty").

  dll_mark_gstack(STACKMARK):- STACKMARK=mem_MarkGStack().
  dll_release_gstack(STACKMARK):-mem_ReleaseGStack(STACKMARK).

  setInteger(In ):-
  	assert(i(In)).
  getInteger(Out):-
  	i(Out).
  
  setReal(In ):-
  	assert(r(In)).
  getReal(Out ):-
  	r(Out).

  setString(In):-
  	assert(s(In)).

/*
  Important note:
  getString should be surrounded in calling program in following way:
  dll_mark_gstack(Stack)
  getString(String)
  [saving String in variable of calling program]
  dll_release_gstack(Stack)
*/
  getString(OutStr):-		% OutStr is output parameter allocated on Prolog GStack
  	s(PrologStr),		
	ASCIIZ_2_VB_String(PrologStr, OutStr). %Convert to BSTR string type. Needed for Visual Basic.
/*
  Important note:
  In complex commersial applications we recommend using of more safe technique for retreiving 
  of strings and other data allocated on Prolog GStack) from Prolog DLLs. 
  This technique is described in FOREIGN\examples\MSVB\readme.HTM file.
*/


GOAL 
  true.
