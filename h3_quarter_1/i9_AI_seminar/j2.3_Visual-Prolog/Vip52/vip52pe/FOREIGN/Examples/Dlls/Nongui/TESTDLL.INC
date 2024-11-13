/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  TESTDLL
 FileName: TESTDLL.INC
 Purpose:  Project's global declarations
 Written by: Visual Prolog
 Comments:
*****************************************************************************/

CONSTANTS
%BEGIN_CONST Project configuration constants
  use_mdi = 1
  use_3dctrl = 1
  use_tbar = 1
  use_dlgpack = 1
  use_editor = 1
  use_message = 1
  use_runtime = 1
%END_CONST

/*****************************************************************************
			User's Declarations
*****************************************************************************/
include "types.dom"

IFDEF use_runtime
  include "pdcrunt.dom"
  include "pdcrunt.pre"
ENDDEF
