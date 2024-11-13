/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  MESSPACK
 FileName: MESSPACK.PRO
 Purpose: Demonstrate Messages Package
 Written by: Eugene Akimov
 Comments:
******************************************************************************/

include "messpack.inc"
include "messpack.con"
include "hlptopic.con"

%BEGIN_WIN Task Window
/***************************************************************************
	Event handling for Task Window
***************************************************************************/

PREDICATES

  task_win_eh : EHANDLER

CONSTANTS

%BEGIN Task Window, CreateParms, 13:35:44-24.11.1999, Code automatically updated!
  task_win_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Close,wsf_Maximize,wsf_Minimize,wsf_ClipSiblings]
  task_win_Menu  = res_menu(idr_task_menu)
  task_win_Title = "Messpack"
  task_win_Help  = idh_contents
%END Task Window, CreateParms

CLAUSES

%BEGIN Task Window, e_Create
  task_win_eh(_Win,e_Create(_),0):-!,
%BEGIN Task Window, InitControls, 13:35:44-24.11.1999, Code automatically updated!
%END Task Window, InitControls
%BEGIN Task Window, ToolbarCreate, 13:35:44-24.11.1999, Code automatically updated!
%END Task Window, ToolbarCreate
IFDEF use_message
	msg_Create(100),
ELSEDEF
	menu_Enable(_Win,"Messages",b_false),
ENDDEF
	!.
%END Task Window, e_Create

%MARK Task Window, new events

%BEGIN Task Window, id_messages
  task_win_eh(_Win,e_Menu(id_messages,_ShiftCtlAlt),0):-!,
ifdef use_message
	msg_Create(100,"Messages"),
enddef
	dlg_messages_Create(_Win),
	!.
%END Task Window, id_messages

%BEGIN Task Window, id_help_contents
  task_win_eh(_Win,e_Menu(id_help_contents,_ShiftCtlAlt),0):-!,
  	vpi_ShowHelp("messpack.hlp"),
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
  	vpi_ShowHelpContext("messpack.hlp",HelpTopic),!.

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
ENDDEF  vpi_Init(task_win_Flags,task_win_eh,task_win_Menu,"messpack",task_win_Title).

%BEGIN_DLG About dialog
/**************************************************************************
	Creation and event handling for dialog: About dialog
**************************************************************************/

CONSTANTS

%BEGIN About dialog, CreateParms, 13:35:36-24.11.1999, Code automatically updated!
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

%BEGIN_DLG Messages
/**************************************************************************
	Creation and event handling for dialog: Messages
**************************************************************************/

CONSTANTS

%BEGIN Messages, CreateParms, 13:35:28-24.11.1999, Code automatically updated!
  dlg_messages_ResID = idd_messages
  dlg_messages_DlgType = wd_Modal
  dlg_messages_Help = idh_contents
%END Messages, CreateParms

PREDICATES

  dlg_messages_eh : EHANDLER
  dlg_messages_update(DIALOG_VAL_LIST)

CLAUSES

  dlg_messages_Create(Parent):-

%MARK Messages, new variables

	dialog_CreateModal(Parent,dlg_messages_ResID,"",
  		[
%BEGIN Messages, ControlList, 13:35:28-24.11.1999, Code automatically updated!
		df(idc_messages_1,editstr("string",[]),nopr)
%END Messages, ControlList
		],
		dlg_messages_eh,0,VALLIST,ANSWER),!,
	ANSWER = idc_ok,
	dlg_messages_update(VALLIST),!.

  dlg_messages_Create(_):-
	dlg_Note("Error: Fail in dlg_messages_Create").

  dlg_messages_update(_VALLIST):-
%BEGIN Messages, Update controls, 13:35:28-24.11.1999, Code automatically updated!
	_IDC_MESSAGES_1_VALUE = dialog_VLGetstr(idc_messages_1,_VALLIST),
%END Messages, Update controls
	!.
  dlg_messages_update(_):-
	dlg_Note("Error: Fail in dlg_messages_update").

%MARK Messages, new events

%BEGIN Messages, e_Create
  dlg_messages_eh(_Win,e_Create(_CreationData),0):-!,
	Win_Create=win_GetCtlHandle(_Win,idc_create_messages),
	win_SetState(Win_Create,[wsf_Disabled]),
	!.
%END Messages, e_Create

%BEGIN Messages, idc_append _CtlInfo
  dlg_messages_eh(_Win,e_Control(idc_append,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
ifdef use_message
	W=win_GetCtlHandle(_Win,idc_messages_1),
	Text=win_GetText(W),
	msg_AppendStr(Text),nl,
enddef
	!.
%END Messages, idc_append _CtlInfo

%BEGIN Messages, idc_clear _CtlInfo
  dlg_messages_eh(_Win,e_Control(idc_clear,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
ifdef use_message
	msg_Clear(),
enddef
	!.
%END Messages, idc_clear _CtlInfo

%BEGIN Messages, idc_close _CtlInfo
  dlg_messages_eh(_Win,e_Control(idc_close,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
ifdef use_Message
	msg_Close(),
	Win_Create=win_GetCtlHandle(_Win,idc_create_messages),
	Win_Close=win_GetCtlHandle(_Win,idc_close),
	Win_Clear=win_GetCtlHandle(_Win,idc_clear),
	Win_Append=win_GetCtlHandle(_Win,idc_append),
	win_SetState(Win_Create,[wsf_Enabled]),
	win_SetState(Win_Close,[wsf_Disabled]),
	win_SetState(Win_Clear,[wsf_Disabled]),
	win_SetState(Win_Append,[wsf_Disabled]),
enddef
	!.
%END Messages, idc_close _CtlInfo

%BEGIN Messages, idc_create_messages _CtlInfo
  dlg_messages_eh(_Win,e_Control(idc_create_messages,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
ifdef use_message
	msg_Create(100,"Created Messages"),
	Win_Create=win_GetCtlHandle(_Win,idc_create_messages),
	Win_Close=win_GetCtlHandle(_Win,idc_close),
	Win_Clear=win_GetCtlHandle(_Win,idc_clear),
	Win_Append=win_GetCtlHandle(_Win,idc_append),
	win_SetState(Win_Create,[wsf_Disabled]),
	win_SetState(Win_Close,[wsf_Enabled]),
	win_SetState(Win_Clear,[wsf_Enabled]),
	win_SetState(Win_Append,[wsf_Enabled]),
enddef
	!.
%END Messages, idc_create_messages _CtlInfo

  dlg_messages_eh(_,_,_):-!,fail.

%END_DLG Messages













