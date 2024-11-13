/******************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S 

 FileName:	PALETTE.PRO
 Purpose:	PALETTE template file
 Written by:	Andrew Skobelev
 Version:	1.0
 Build:		008.981112
 Tested with:   Visual Prolog v.5.1 build 555a
 Comments:
******************************************************************************/
ifdef use_palette
 #Error: Palette tool was alredy included by Visual Prolog Application Expert
enddef 

ifdef platform_16bit
  code = 5000
enddef

% Replace PROJECT with actual name of project:
include "PROJECT.inc"

include "palette.pre"

% Replace PALETTE_DIR with actual path to PALETTE tool:
include "PALETTE_DIR\\palette.pro"

