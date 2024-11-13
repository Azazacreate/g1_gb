/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  Gridtest
 FileName: GRIDTEST.INC
 Purpose:  Project's global declarations
 Written by: Sergey A. Alexeev
 Comments:
*****************************************************************************/

constants
%BEGIN_CONST Project configuration constants, Code automatically updated!
  use_mdi = 1
  use_3dctrl = 1
  use_tbar = 1
  use_dlgpack = 1
  use_editor = 1
  use_message = 1
  use_grid = 1
  use_date = 1
%END_CONST

include "vpi.con"
include "vpi.dom"
include "vpi.pre"
ifdef use_tabdlg
  ifndef use_dlgpack
    constants
       use_dlgpack =1
  enddef
enddef
ifdef use_dlgpack
  include "dialog\\dialog.dom"
  include "dialog\\dialog.pre"
enddef
ifdef use_message
  ifndef use_editor
    constants
       use_editor =1
  enddef
enddef
ifdef use_editor
  include "edit.dom"
  include "edit.pre"
enddef
ifdef use_message
  include "messages\\messages.pre"
enddef
ifdef use_tbar
  include "toolbar\\toolbar.dom"
  include "toolbar\\toolbar.pre"
enddef
ifdef use_tree
  include "tree\\vpitree.dom"
  include "tree\\vpitree.pre"
enddef
ifdef use_tabdlg
  include "tabdlg\\tabdlg.dom"
  include "tabdlg\\tabdlg.pre"
enddef
ifdef use_dlgdir
  ifndef use_ownerdraw
    constants
       use_ownerdraw =1
  enddef
  include "dlgdir\\dlgdir.pre"
enddef
ifdef use_ownerdraw
  include "owndraw\\owndraw.dom"
  include "owndraw\\owndraw.pre"
enddef
ifdef use_grid
  include "grid\\grid.dom"
  include "grid\\grid.pre"
enddef
ifdef use_date
  include "date\\date.dom"
  constants
    language_english = 1
%    language_danish  = 1
%    language_russian = 1
  include "date\\date.pre"
enddef
ifdef use_treebrowser
global domains
  BROWSELIST_USERITEMKEY = INTEGER % User specified

  include "treebrws\\treebrws.dom"
  include "treebrws\\treebrws.pre"
enddef
ifdef use_listproperty
  include "property\\property.dom"
  include "property\\property.pre"
enddef
ifdef use_palette
  include "palette\\palette.dom"
  include "palette\\palette.pre"
enddef
ifdef use_progress
  include "progress\\progress.pre"
enddef
ifdef use_doc
  include "docstr.dom"
  include "html.pre"
  include "ipf.pre"
  include "rtf.pre"
  include "errhndl.pre"
enddef
ifdef use_sql
  include "sqlbind.dom"
  include "sqlbind.pre"
enddef
ifdef use_odbc
  include "odbc.dom"
  include "odbc.pre"
enddef
ifdef use_socket
  ifndef use_runtime
    constants
      use_runtime = 1
  enddef
enddef
ifdef use_runtime
  include "pdcrunt.dom"
  include "pdcrunt.pre"
enddef
ifdef use_socket
  include "include\\pdcsock.dom"
  include "include\\pdcsock.con"
  include "include\\pdcsock.pre"
enddef



/*****************************************************************************
			User's Declarations.
*****************************************************************************/
global domains
  DB_SELECTOR = browselist_db	% For treebrowser tool
  FILE = fileselector1; fileselector2 % To be edited

include "gridtest.pre"
include "datecust\\date_cc.pre"
