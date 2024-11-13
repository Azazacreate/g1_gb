/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  DLL2
 FileName: DLL2.PRO
 Purpose: No description
 Written by: Visual Prolog
 Comments:
******************************************************************************/

include "dll2.inc"
include "dll2.con"
include "hlptopic.con"

CLAUSES /*Exported*/

 /* Memory Management Clauses */
 %Note: The constant "use_runtime" MUST be defined in the DLL1.INC file
 %      because the next two predicates are exported 
 %      They are not needed if the DLL is statically linked
 dll_mark_gstack(STACKMARK):- STACKMARK=mem_MarkGStack().
 dll_release_gstack(STACKMARK):-mem_ReleaseGStack(STACKMARK).

 callCallback(Mycallback):-
	STACKMARK=mem_MarkGStack(),
 	Str = "String from DLL2", %<--- memory allocation on GStack
	Mycallback(Str),
 	mem_ReleaseGStack(STACKMARK).

 getstring(OutStr):-
%parameter is output  
%	STACKMARK=mem_MarkGStack()
% 	mem_ReleaseGStack(STACKMARK)
%	should be called in calling process
 	Str = "String from DLL2", %<--- memory allocation on GStack
	ASCIIZ_2_VB_String(Str,OutStr). %Convert to BSTR type. Needed for Visual basic
	
GOAL
	true.
