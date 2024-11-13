/******************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 FileName:	GRID.PRO
 Purpose:	GRID custom control template file
 Written by:	Sergey Alexeev
 Version:	2.0
 Build:		009.970220
 Tested with:	Visual Prolog v. 4.1 build 509
 Comments:
******************************************************************************/
ifdef use_grid
 #Error: Simultaneous inclusion tool by templates and by Application Expert is impossible
enddef 

ifdef platform_16bit
  code = 5000
enddef

% Replace PROJECT with actual name of project:
include "trans.inc"

include "grid.pre"

% Replace GRID_DIR with actual path to GRID tool:
include "grid\\gridmain.pro"
include "grid\\griddraw.pro"
include "grid\\gridmar.pro"
include "grid\\gridglob.pro"

