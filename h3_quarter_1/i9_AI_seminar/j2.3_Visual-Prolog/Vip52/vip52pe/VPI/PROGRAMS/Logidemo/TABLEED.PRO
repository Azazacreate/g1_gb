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
ifdef platform_16bit
  code = 5000
enddef

% Replace PROJECT with actual name of project:
include "trans.inc"

include "grid.pre"
include "tableed.pre"

% Replace TABLEED_DIR with actual path to TABLEED tool:
include "tableed\\tableed.con"
include "tableed\\tableed1.pro"
include "tableed\\tableed2.pro"
include "tableed\\tableed3.pro"
include "tableed\\tableed4.pro"
include "tableed\\tabmain.pro"
