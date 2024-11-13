/*****************************************************************************

		 Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  HELP
 FileName: HELP.PRO
 Purpose: Demo On-line Help
 Written by: Eugene Akimov
 Comments:
******************************************************************************/

include "help.inc"
include "help.con"
include "hlptopic.con"

%BEGIN_WIN Task Window
/***************************************************************************
	Event handling for Task Window
***************************************************************************/

PREDICATES

  task_win_eh : EHANDLER

CONSTANTS

%BEGIN Task Window, CreateParms, 19:44:50-24.11.1999, Code automatically updated!
  task_win_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Close,wsf_Maximize,wsf_Minimize,wsf_ClipSiblings]
  task_win_Menu  = res_menu(idr_task_menu)
  task_win_Title = "Help"
  task_win_Help  = idh_contents
%END Task Window, CreateParms

CLAUSES

%BEGIN Task Window, e_Create
  task_win_eh(_Win,e_Create(_),0):-!,
%BEGIN Task Window, InitControls, 19:44:50-24.11.1999, Code automatically updated!
%END Task Window, InitControls
%BEGIN Task Window, ToolbarCreate, 19:44:50-24.11.1999, Code automatically updated!
%END Task Window, ToolbarCreate
IFDEF use_message
	msg_Create(100),
ENDDEF
	!.
%END Task Window, e_Create

%MARK Task Window, new events

%BEGIN Task Window, id_open_window
  task_win_eh(_Win,e_Menu(id_open_window,_ShiftCtlAlt),0):-!,
	win_window_Create(_Win),
	!.
%END Task Window, id_open_window

%BEGIN Task Window, id_open_dialog
  task_win_eh(_Win,e_Menu(id_open_dialog,_ShiftCtlAlt),0):-!,
	dlg_dialog_Create(_Win),
	!.
%END Task Window, id_open_dialog

%BEGIN Task Window, id_help_contents
  task_win_eh(_Win,e_Menu(id_help_contents,_ShiftCtlAlt),0):-!,
ifdef platform_16bit
  	vpi_ShowHelp("help_w16.hlp"),
elsedef
  ifndef os_os2
  	vpi_ShowHelp("help.hlp"),
  elsedef  	
  	vpi_ShowHelp("help_os2.hlp"),
  enddef
enddef
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
ifdef platform_16bit
  	vpi_ShowHelpContext("help_w16.hlp",HelpTopic),
elsedef
  ifndef os_os2
  	vpi_ShowHelpContext("help.hlp",HelpTopic),
  elsedef  	
  	vpi_ShowHelpContext("help_os2.hlp",HelpTopic),
  enddef
enddef
  	!.

/***************************************************************************
	Main Goal
***************************************************************************/

GOAL

IFDEF use_mdi
  vpi_SetAttrVal(attr_win_mdi,b_true),
ENDDEF
IFDEF ws_win
  IFDEF use_3dctrl
    vpi_SetAttrVal(attr_win_3dcontrols,b_true),
  ENDDEF
ENDDEF  vpi_Init(task_win_Flags,task_win_eh,task_win_Menu,"help",task_win_Title).

%BEGIN_DLG About dialog
/**************************************************************************
	Creation and event handling for dialog: About dialog
**************************************************************************/

CONSTANTS

%BEGIN About dialog, CreateParms, 19:44:48-24.11.1999, Code automatically updated!
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

%BEGIN_DLG Dialog
/**************************************************************************
	Creation and event handling for dialog: Dialog
**************************************************************************/

CONSTANTS

%BEGIN Dialog, CreateParms, 19:44:44-24.11.1999, Code automatically updated!
  dlg_dialog_ResID = idd_dialog
  dlg_dialog_DlgType = wd_Modeless
  dlg_dialog_Help = idh_dialog
%END Dialog, CreateParms

PREDICATES

  dlg_dialog_eh : EHANDLER
  dlg_dialog_update(DIALOG_VAL_LIST)

CLAUSES

  dlg_dialog_Create(Parent):-

%MARK Dialog, new variables

	dialog_CreateModeless(Parent,dlg_dialog_ResID,"",
  		[
%BEGIN Dialog, ControlList, 19:44:44-24.11.1999, Code automatically updated!
%END Dialog, ControlList
		],
		dlg_dialog_eh,0).

  dlg_dialog_update(_VALLIST):-
%BEGIN Dialog, Update controls, 19:44:44-24.11.1999, Code automatically updated!
%END Dialog, Update controls
	true.

%MARK Dialog, new events

%BEGIN Dialog, idc_help _CtlInfo
  dlg_dialog_eh(_Win,e_Control(idc_help,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	project_ShowHelpContext(dlg_dialog_Help),
	!.
%END Dialog, idc_help _CtlInfo

  dlg_dialog_eh(_,_,_):-!,fail.

%END_DLG Dialog


%BEGIN_WIN Window
/**************************************************************************
        Creation and event handling for window: Window
**************************************************************************/

CONSTANTS
%BEGIN Window, CreateParms, 19:44:48-24.11.1999, Code automatically updated!
  win_window_WinType = w_TopLevel
  win_window_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Maximize,wsf_Minimize,wsf_Close,wsf_ClipSiblings]
  win_window_RCT = rct(200,80,361,178)
  win_window_Menu = no_menu
  win_window_Title = "Window"
  win_window_Help = idh_window
%END Window, CreateParms

PREDICATES

  win_window_eh : EHANDLER

CLAUSES

  win_window_Create(Parent):-
	win_Create(win_window_WinType,win_window_RCT,win_window_Title,
		   win_window_Menu,Parent,win_window_Flags,win_window_eh,0).

%BEGIN Window, e_Create
  win_window_eh(_Win,e_Create(_),0):-!,
%BEGIN Window, InitControls, 19:44:48-24.11.1999, Code automatically updated!
	win_CreateControl(wc_PushButton,rct(40,68,120,92),"Close",_Win,[wsf_Group,wsf_TabStop],idc_close),
	win_CreateControl(wc_PushButton,rct(38,23,118,47),"Help",_Win,[wsf_Group,wsf_TabStop],idc_help),
	win_CreateControl(wc_GroupBox,rct(4,0,157,56),"Call Help for Window",_Win,[],idc_call_help_for_window),
%END Window, InitControls
%BEGIN Window, ToolbarCreate, 19:44:48-24.11.1999, Code automatically updated!
%END Window, ToolbarCreate
	!.
%END Window, e_Create
%MARK Window, new events

%BEGIN Window, e_Update
  win_window_eh(_Win,e_Update(_UpdateRct),0):-!,
	win_Clear(_Win,color_LtGray),
	!.
%END Window, e_Update

%BEGIN Window, idc_close _CtlInfo
  win_window_eh(_Win,e_Control(idc_close,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	win_Destroy(_Win),
	!.
%END Window, idc_close _CtlInfo

%BEGIN Window, idc_help _CtlInfo
  win_window_eh(_Win,e_Control(idc_help,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	project_ShowHelpContext(win_window_Help),
	!.
%END Window, idc_help _CtlInfo

%BEGIN Window, e_Size
  win_window_eh(_Win,e_Size(_Width,_Height),0):-!,
IFDEF use_tbar
	toolbar_Resize(_Win),
ENDDEF
	!.
%END Window, e_Size

%BEGIN Window, e_Menu, Parent window 
  win_window_eh(Win,e_Menu(ID,CAS),0):-!,
	PARENT = win_GetParent(Win),
	win_SendEvent(PARENT,e_Menu(ID,CAS)),
	!.
%END Window, e_Menu, Parent window

%END_WIN Window

























