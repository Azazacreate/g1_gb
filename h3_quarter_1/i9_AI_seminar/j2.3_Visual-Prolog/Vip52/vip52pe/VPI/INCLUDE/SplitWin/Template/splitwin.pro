/******************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 FileName:	SPLITWIN.PRO
 Purpose:	Split window toool - bottom level
 Written by:	Andrew Skobelev
 Version:	1.0
 Build:		007.990304
 Tested with:   Visual Prolog v.5.1 build 563
 Comments:	
******************************************************************************/
ifdef platform_16bit
  code = 5000
enddef

% Replace PROJECT with actual name of project:
include "PROJECT.inc"

include "splitwin.pre"

% Replace SPLITWIN_DIR with actual path to SPLITWIN tool:
include "SPLITWIN_DIR\\splitwin.pro"
