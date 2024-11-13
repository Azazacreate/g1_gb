/******************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S 

 FileName:	PROPERTY.PRO
 Purpose:	PROPERTY EDITOR template file
 Written by:	Andrew Skobelev
 Version:	1.0
 Build:		008.981112
 Tested with:   Visual Prolog v.5.1 build 555a
 Comments:
******************************************************************************/
ifdef use_property
 #Error: Property tool was alredy included by Visual Prolog Application Expert
enddef 

ifdef platform_16bit
  code = 5000
enddef

% Replace PROJECT with actual name of project:
include "PROJECT.inc"

include "property.pre"

% Replace PROPERTY_DIR with actual path to PROPERTY tool:
include "PROPERTY_DIR\\prop_ut1.PRO"
include "PROPERTY_DIR\\prop_ut2.PRO"
include "PROPERTY_DIR\\propmain.PRO"

