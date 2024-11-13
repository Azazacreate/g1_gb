/******************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S 

 FileName:	TABLEED.PRO
 Purpose:	TABLE EDITOR custom control template file
 Written by:	Andrew Skobelev
 Version:	1.0
 Build:		009.981112
 Tested with:   Visual Prolog v.5.1 build 555a
 Comments:	
******************************************************************************/
ifdef use_tableed
 #Error: Table editor tool was already included by Visual Prolog Application Expert
enddef 
ifdef platform_16bit
  code = 5000
enddef

% Replace PROJECT with actual name of project:
include "PROJECT.inc"

include "grid.pre"
include "tableed.pre"

% Replace TABLEED_DIR with actual path to TABLEED tool:
include "TABLEED_DIR\\tableed.con"
include "TABLEED_DIR\\tableed1.pro"
include "TABLEED_DIR\\tableed2.pro"
include "TABLEED_DIR\\tableed3.pro"
include "TABLEED_DIR\\tableed4.pro"
include "TABLEED_DIR\\tabmain.pro"
