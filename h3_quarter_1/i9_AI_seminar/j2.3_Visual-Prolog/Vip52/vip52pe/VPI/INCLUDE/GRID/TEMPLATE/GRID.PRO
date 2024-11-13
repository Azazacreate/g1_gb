/******************************************************************************

               Copyright (c) 1984 - 2000 Prolog Development Center A/S

 FileName:	GRID.PRO
 Purpose:	GRID custom control template file
 Written by:	Sergey Alexeev
 Version:	2.0
 Build:		025.991028
 Tested with:   Visual Prolog v.5.1 build 563
 Comments:
******************************************************************************/
ifdef use_grid
 #Error: Grid tool was already included by Visual Prolog Application Expert
enddef 

ifdef platform_16bit
  code = 5000
enddef

% Replace PROJECT with actual name of project:
include "PROJECT.inc"

include "grid.pre"

% Replace GRID_DIR with actual path to GRID tool:
include "GRID_DIR\\gridmain.pro"
include "GRID_DIR\\griddraw.pro"
include "GRID_DIR\\gridmar.pro"
include "GRID_DIR\\gridglob.pro"

