/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  GRIDTEST
 FileName: VPITOOLS.PRO
 Purpose: Include VPI predicates and tools
 Written by: Visual Prolog Application expert
 Comments:
******************************************************************************/

ifdef platform_16bit
  code = 5000
elsedef
% code = 48000 %set your code size > 32000 if have "Code array too small" problem
enddef

include "gridtest.inc"
include "error.con"

/******************************************************************************
			Include tools
******************************************************************************/

ifdef use_message
  include "iodecl.pre"
enddef
ifdef use_dlgpack
  include "dialog\\dialog.pro"
enddef
ifdef use_tbar
  include "toolbar\\toolbar.pro"
enddef
ifdef use_tree
  include "tree\\vpitree.pro"
enddef
ifdef use_message
  include "messages\\messages.pro"
enddef
ifdef use_socket
  include "include\\pdcsock.pro"
enddef
ifdef use_tabdlg
  ifndef use_dlgpack
    include "dialog\\dialog.pro"
  enddef
  include "tabdlg\\tabdlg.pro"
enddef
ifdef use_ownerdraw
  include "owndraw\\owndraw.pro"
enddef
ifdef use_dlgdir
  ifndef use_ownerdraw
    include "owndraw\\owndraw.pro"
  enddef
  include "iodecl.con"
  include "dlgdir\\sort.pro"
  include "dlgdir\\dlgdir.pro"
enddef
ifdef use_grid
  include "grid\\grid.pro"
enddef
ifdef use_date
  include "date\\date.pro"
enddef
ifdef use_treebrowser
  include "treebrws\\treebrws.pro"
enddef
ifdef use_listproperty
  include "property\\property.pro"
enddef
ifdef use_palette
  include "palette\\palette.pro"
enddef
ifdef use_doc
  include "html.pro"
  include "ipf.pro"
  include "rtf.pro"
  include "errhndl.pro"
enddef

include "datecust\\date_cc.pro"
