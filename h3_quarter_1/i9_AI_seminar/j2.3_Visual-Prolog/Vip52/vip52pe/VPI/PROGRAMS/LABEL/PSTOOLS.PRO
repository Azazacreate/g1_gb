/******************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:	Label Expert
 FileName:	PSTOOLS.PRO
 Purpose:	Page setup
 Written by:	Sergey Alexeev
 Build:		008.981112
 Comments:
******************************************************************************/

ifdef platform_16bit
  code = 5000
enddef

include "label.inc"

include "apptools\\pageset\\pageset.pre"
include "apptools\\lbpgview\\lbpgview.pre"

include "apptools\\pageset\\pageset.pro"
include "apptools\\lbpgview\\lbpgview.pro"
