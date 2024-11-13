/******************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S 

 FileName:	DATE_CC.PRO
 PURPOSE:	Date custom control
 Written by:	Alexander Butovsky
 Version:	1.0
 Build:		012.000316
 Tested with:   Visual Prolog v.5.1 build 565
 Comments:

******************************************************************************/
ifdef platform_16bit
  code = 5000
enddef

% Replace PROJECT with actual name of project:
include "PROJECT.inc"

% Replace DATE_cc_DIR with actual path to DATE tool:
include "date.pre"	% EXTERNAL
include "date_cc.pre"	% PUBLIC

% Replace DATECUST_DIR with actual path to DATECUST tool:
include "DATECUST_DIR\\date_cmi.pro"
