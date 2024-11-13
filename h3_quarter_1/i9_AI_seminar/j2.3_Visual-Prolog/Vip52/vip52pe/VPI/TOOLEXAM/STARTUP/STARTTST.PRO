/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  STARTUP
 FileName: STARTTST.PRO
 Purpose: Start up example
 Written by: Eugene Akimov
 Comments:
******************************************************************************/

include "startup.inc"
include "startup.con"
include "hlptopic.con"
	
%BEGIN_WIN Task Window
/***************************************************************************
	Event handling for Task Window
***************************************************************************/

PREDICATES

  task_win_eh : EHANDLER

CONSTANTS

%BEGIN Task Window, CreateParms, 15:49:36-24.11.1999, Code automatically updated!
  task_win_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Close,wsf_Maximize,wsf_Minimize,wsf_ClipSiblings]
  task_win_Menu  = res_menu(idr_task_menu)
  task_win_Title = "Starttst"
  task_win_Help  = idh_contents
%END Task Window, CreateParms

ifdef os_os2
  bmpFileName = "..\\..\\..\\..\\bin\\os2\\Prolog.BMP"
elsedef
  bmpFileName = "..\\..\\..\\..\\bin\\win\\Prolog.BMP"
enddef

CLAUSES

%BEGIN Task Window, e_Create
  task_win_eh(_Win,e_Create(_),0):-!,
%BEGIN Task Window, InitControls, 15:49:36-24.11.1999, Code automatically updated!
%END Task Window, InitControls
%BEGIN Task Window, ToolbarCreate, 15:49:36-24.11.1999, Code automatically updated!
	tb_startup_Create(_Win),
	tb_help_line_Create(_Win),
%END Task Window, ToolbarCreate
IFDEF use_message
	msg_Create(100),
ENDDEF
	!.
%END Task Window, e_Create

%MARK Task Window, new events

%BEGIN Task Window, id_file_close
  task_win_eh(_Win,e_Menu(id_file_close,_ShiftCtlAlt),0):-!,
	syspath(SYSPATH,_),
	filenamepath(BmpName,SYSPATH,bmpFileName),
	startup_Close(BmpName),
	menu_Enable(_Win,id_file_close,b_false),
	menu_Enable(_Win,id_file_open,b_true),
	!.
%END Task Window, id_file_close

%BEGIN Task Window, id_file_open
  task_win_eh(_Win,e_Menu(id_file_open,_ShiftCtlAlt),0):-!,
	syspath(SYSPATH,_),
	filenamepath(BmpFile,SYSPATH,bmpFileName),
	_StartupWin = startup_Create(_Win,BmpFile),
	menu_Enable(_Win,id_file_close,b_true),
	menu_Enable(_Win,id_file_open,b_false),
	!.
%END Task Window, id_file_open

%BEGIN Task Window, id_help_contents
  task_win_eh(_Win,e_Menu(id_help_contents,_ShiftCtlAlt),0):-!,
  	vpi_ShowHelp("startup.hlp"),
	!.
%END Task Window, id_help_contents

%BEGIN Task Window, id_help_about
  task_win_eh(Win,e_Menu(id_help_about,_ShiftCtlAlt),0):-!,
	dlg_about_dialog_Create(Win),
	!.
%END Task Window, id_help_about

%BEGIN Task Window, id_file_exit
  task_win_eh(Win,e_Menu(id_file_exit,_ShiftCtlAlt),0):-!,
  	win_Destroy(Win),
	!.
%END Task Window, id_file_exit

%BEGIN Task Window, e_Size
  task_win_eh(_Win,e_Size(_Width,_Height),0):-!,
IFDEF use_tbar
	toolbar_Resize(_Win),
ENDDEF
IFDEF use_message
	msg_Resize(_Win),
ENDDEF
	!.
%END Task Window, e_Size

%END_WIN Task Window

/***************************************************************************
	Invoking on-line Help
***************************************************************************/

  project_ShowHelpContext(HelpTopic):-
  	vpi_ShowHelpContext("startup.hlp",HelpTopic),!.

/***************************************************************************
	Main Goal
***************************************************************************/

GOAL

IFDEF use_mdi
  vpi_SetAttrVal(attr_win_mdi,b_true),
ENDDEF
IFDEF use_3dctrl
  vpi_SetAttrVal(attr_win_3dcontrols,b_true),
ENDDEF
IFDEF use_tbar
  vpi_SetAttrVal(attr_win_tbar,use_tbar),
ENDDEF
IFDEF use_sbar
  vpi_SetAttrVal(attr_win_sbar,use_sbar),
ENDDEF
  vpi_Init(task_win_Flags,task_win_eh,task_win_Menu,"startup",task_win_Title).

%BEGIN_TLB Help line, 15:49:50-24.11.1999, Code automatically updated!
/**************************************************************************
	Creation of toolbar: Help line
**************************************************************************/

clauses

  tb_help_line_Create(_Parent):-
ifdef use_tbar
	toolbar_create(tb_bottom,0xC0C0C0,_Parent,
		[tb_text(idt_help_line,tb_context,452,0,4,10,0x0,"")]),
enddef
	true.
%END_TLB Help line


%BEGIN_DLG About dialog
/**************************************************************************
	Creation and event handling for dialog: About dialog
**************************************************************************/

CONSTANTS

%BEGIN About dialog, CreateParms, 15:49:28-24.11.1999, Code automatically updated!
  dlg_about_dialog_ResID = idd_dlg_about
  dlg_about_dialog_DlgType = wd_Modal
  dlg_about_dialog_Help = idh_contents
%END About dialog, CreateParms

PREDICATES

  dlg_about_dialog_eh : EHANDLER

CLAUSES

  dlg_about_dialog_Create(Parent):-
	win_CreateResDialog(Parent,dlg_about_dialog_DlgType,dlg_about_dialog_ResID,dlg_about_dialog_eh,0),!.

%BEGIN About dialog, idc_ok _CtlInfo
  dlg_about_dialog_eh(_Win,e_Control(idc_ok,_CtrlType,_CtrlWin,_CtrlInfo),0):-!,
	win_Destroy(_Win),
	!.
%END About dialog, idc_ok _CtlInfo
%MARK About dialog, new events

  dlg_about_dialog_eh(_,_,_):-!,fail.

%END_DLG About dialog

%BEGIN_TLB startup, 15:49:42-24.11.1999, Code automatically updated!
/**************************************************************************
	Creation of toolbar: startup
**************************************************************************/

clauses

  tb_startup_Create(_Parent):-
ifdef use_tbar
	toolbar_create(tb_top,0xC0C0C0,_Parent,
		[tb_ctrl(id_file_Open,pushb,idb_open_up,idb_open_dn,idb_open_up,"Open Picture",1,1),
		 tb_ctrl(id_file_close,pushb,idb_cut_up,idb_cut_dn,idb_cut_up,"Close Picture",1,1)]),
enddef
	true.
%END_TLB startup















































