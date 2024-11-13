/******************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 FileName:	SPLIT.PRO
 Purpose:	Split window toool - top level
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
include "split.pre"

% Replace SPLIT_DIR with actual path to SPLIT tool:
include "SPLIT_DIR\\split.pro"
