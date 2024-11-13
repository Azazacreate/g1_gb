/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  PIE (WWW)
 FileName: PIE.INC
 Purpose:  Project's global declarations
 Written by: Oleg Erjomin
 Comments:
*****************************************************************************/

CONSTANTS
include "error.con"
include "types.dom"		
include "pdcrunt.dom"		
include "include\\cgi\\cgitools.dom"

include "pdcrunt.pre"
include "include\\cgi\\cgitools.pre"
/*****************************************************************************
			User's Declarations
*****************************************************************************/
GLOBAL DATABASE - standard_clauses
	std_clause (STRING,STRING)

include "pie.dom"
include "pie.pre"
