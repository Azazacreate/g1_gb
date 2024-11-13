/******************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:	Label Expert
 FileName:	LETOOLS.PRO
 Purpose:	Layout Editor
 Written by:	Sergey Alexeev
 Build:		008.981112
 Comments:
******************************************************************************/

ifdef platform_16bit
  code = 5000
enddef

include "label.inc"

include "apptools\\layouted\\layouted.pre"
include "tools\\scale\\scale.pre"
include "tools\\layout\\layout.pre"
include "tools\\barcode\\barcode.pre"
include "apptools\\align\\align.pre"
include "apptools\\editmode\\editmode.pre"
include "apptools\\drawtool\\draw.pre"
include "palette\\palette.pre"

include "apptools\\layouted\\layouted.pro"
include "tools\\scale\\scale.pro"
include "tools\\layout\\layout.pro"
include "tools\\barcode\\barcode.pro"
include "apptools\\align\\align.pro"
include "apptools\\editmode\\editmode.pro"
include "apptools\\drawtool\\draw.pro"
include "palette\\palette.pro"
