/******************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:	Label Expert
 FileName:	PRTOOLS.PRO
 Purpose:	Label Print and Print Preview
 Written by:	Sergey Alexeev
 Build:		008.981112
 Comments:
******************************************************************************/

ifdef platform_16bit
  code = 5000
enddef

include "label.inc"

include "apptools\\print\\print.pre"
include "tools\\scale\\scale.pre"
include "tools\\layout\\layout.pre"
include "tools\\barcode\\barcode.pre"
include "apptools\\drawtool\\draw.pre"

include "apptools\\print\\print.pro"
