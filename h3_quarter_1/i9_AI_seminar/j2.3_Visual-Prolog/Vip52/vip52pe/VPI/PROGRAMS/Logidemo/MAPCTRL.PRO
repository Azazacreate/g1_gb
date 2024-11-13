/******************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 FileName:	MAPCTRL.PRO
 Purpose:	Map custom control template file
 Written by:	Alexander Butovsky
 Version:	1.0
 Build:		008.981112
 Tested with:   Visual Prolog v.5.1 build 555a 
 Comments:
******************************************************************************/

ifdef platform_16bit
  code = 5000
enddef

% Replace PROJECT with actual name of the project:
include "trans.inc"

include "mapctrl.pre"

% Replace MAPCTRL_DIR with actual path to MAPCTRL tool:
include "mapctrl\\mapctrl.con"
include "mapctrl\\mapctrl.pro"
include "mapctrl\\mapedit.pro"

