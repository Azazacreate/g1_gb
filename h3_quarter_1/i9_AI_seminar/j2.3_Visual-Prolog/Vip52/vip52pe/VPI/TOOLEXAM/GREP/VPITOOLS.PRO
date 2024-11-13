/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  GREP
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

include "greptool.inc"
include "error.con"

/******************************************************************************
			Include tools
******************************************************************************/

IFDEF use_message
  include "iodecl.pre"
ENDDEF
IFDEF use_sql
  include "sqlbind.pre"
ENDDEF
IFDEF use_odbc
  include "odbc.pre"
ENDDEF
IFDEF use_socket
  include "pdcrunt.pre"
  include "pdcsock.con"
  include "pdcsock.pre"
ENDDEF
IFDEF use_tree
  include "tree\\vpitree.pre"
ENDDEF
IFDEF use_tabdlg
  include "tabdlg\\tabdlg.pre"
ENDDEF
IFDEF use_grid
  include "grid\\grid.pre"
ENDDEF
IFDEF use_date
  CONSTANTS
    language_english = 1
%    language_danish  = 1
%    language_russian = 1
  include "date\\date.pre"
ENDDEF
IFDEF use_treebrowser
  include "treebrws\\treebrws.pre"
ENDDEF
IFDEF use_listproperty
  include "property\\property.pre"
ENDDEF
IFDEF use_palette
  include "palette\\palette.pre"
ENDDEF
IFDEF use_doc
  include "html.pre"
  include "ipf.pre"
  include "rtf.pre"
  include "errhndl.pre"
ENDDEF
IFDEF use_progress
  include "progress\\progress.pre"
ENDDEF

IFDEF use_dlgpack
  include "dialog\\dialog.pro"
ENDDEF
IFDEF use_tbar
  include "toolbar\\toolbar.pro"
ENDDEF
IFDEF use_tree
  include "tree\\vpitree.pro"
ENDDEF
IFDEF use_message
  include "messages\\messages.pro"
ENDDEF
IFDEF use_socket
  include "pdcsock.pro"
ENDDEF
IFDEF use_tabdlg
  include "tabdlg\\tabdlg.pro"
ENDDEF
IFDEF use_ownerdraw
  include "owndraw\\owndraw.pro"
ENDDEF
IFDEF use_dlgdir
  include "iodecl.con"
  include "dlgdir\\sort.pro"
  include "dlgdir\\dlgdir.pro"
ENDDEF
IFDEF use_grid
  include "grid\\grid.pro"
ENDDEF
IFDEF use_date
  include "date\\date.pro"
ENDDEF
IFDEF use_treebrowser
  include "treebrws\\treebrws.pro"
ENDDEF
IFDEF use_listproperty
  include "property\\property.pro"
ENDDEF
IFDEF use_palette
  include "palette\\palette.pro"
ENDDEF
IFDEF use_progress
  include "progress\\progress.pro"
ENDDEF
IFDEF use_doc
  include "html.pro"
  include "ipf.pro"
  include "rtf.pro"
  include "errhndl.pro"
ENDDEF
  include "grep\\grep.pro"