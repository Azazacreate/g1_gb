/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  license
 FileName: LICENSE.INC
 Purpose:  Project's global declarations
 Written by: Visual Prolog
 Comments:
*****************************************************************************/

include "include\\types.dom"
include "include\\pdcrunt.dom"
include "www\\include\\cgi\\cgitools.dom"

/*****************************************************************************
			User's Declarations
*****************************************************************************/
GLOBAL DOMAINS
  userId = integer
  softwareId = integer

  fieldSpec = text(integer Size); textarea(integer Rows,integer Cols)
  field = field(string Show,string FieldName,string Title,fieldSpec)
  fieldList = field*

