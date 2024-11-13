/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S 

 Project:  SUBCLASS
 FileName: SUBCLASS.PRO
 Purpose: SubClass Example
 Written by: Eugene Akimov
 Comments:
******************************************************************************/

include "subclass.inc"
include "subclass.con"
include "hlptopic.con"

PREDICATES
  subclass_eh : EHANDLER

CLAUSES
  subclass_eh(_EdWin,Event,0):-
	write("Edit Control Window ( ",_EdWin," ) ",':',Event),nl,
	fail.
  subclass_eh(_EdWin,e_Char(49,_),0):-!,
 	Parent=win_GetParent(_EdWin),
 	W=win_GetCtlHandle(Parent,idc_subclass_1),
 	Text=win_GetText(W),
 	upper_lower(Upper,Text),
 	win_SetText(W,Upper),
  	!.

  subclass_eh(_EdWin,e_Char(50,_),0):-!,
 	Parent=win_GetParent(_EdWin),
 	W=win_GetCtlHandle(Parent,idc_subclass_1),
 	Text=win_GetText(W),
 	upper_lower(Text,Lower),
 	win_SetText(W,Lower),
  	!.

%BEGIN_WIN Task Window
/***************************************************************************
	Event handling for Task Window
***************************************************************************/

PREDICATES

  task_win_eh : EHANDLER

CONSTANTS

%BEGIN Task Window, CreateParms, 14:28:56-24.11.1999, Code automatically updated!
  task_win_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Close,wsf_Maximize,wsf_Minimize,wsf_ClipSiblings]
  task_win_Menu  = res_menu(idr_task_menu)
  task_win_Title = "Subclass"
  task_win_Help  = idh_contents
%END Task Window, CreateParms

CLAUSES

%BEGIN Task Window, e_Create
  task_win_eh(_Win,e_Create(_),0):-!,
%BEGIN Task Window, InitControls, 14:28:56-24.11.1999, Code automatically updated!
%END Task Window, InitControls
%BEGIN Task Window, ToolbarCreate, 14:28:56-24.11.1999, Code automatically updated!
%END Task Window, ToolbarCreate
IFDEF use_message
	msg_Create(100),
ENDDEF
	!.
%END Task Window, e_Create

%MARK Task Window, new events

%BEGIN Task Window, id_subclass
  task_win_eh(_Win,e_Menu(id_subclass,_ShiftCtlAlt),0):-!,
	dlg_subclass_Create(_Win),
	!.
%END Task Window, id_subclass

%BEGIN Task Window, id_help_contents
  task_win_eh(_Win,e_Menu(id_help_contents,_ShiftCtlAlt),0):-!,
  	vpi_ShowHelp("subclass.hlp"),
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
  	vpi_ShowHelpContext("subclass.hlp",HelpTopic),!.

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
ENDDEF  vpi_Init(task_win_Flags,task_win_eh,task_win_Menu,"subclass",task_win_Title).

%BEGIN_DLG About dialog
/**************************************************************************
	Creation and event handling for dialog: About dialog
**************************************************************************/

CONSTANTS

%BEGIN About dialog, CreateParms, 14:28:52-24.11.1999, Code automatically updated!
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

%BEGIN_DLG Subclass
/**************************************************************************
	Creation and event handling for dialog: Subclass
**************************************************************************/

CONSTANTS

%BEGIN Subclass, CreateParms, 14:28:48-24.11.1999, Code automatically updated!
  dlg_subclass_ResID = idd_subclass
  dlg_subclass_DlgType = wd_Modal
  dlg_subclass_Help = idh_contents
%END Subclass, CreateParms

PREDICATES

  dlg_subclass_eh : EHANDLER
  dlg_subclass_update(DIALOG_VAL_LIST)

CLAUSES

  dlg_subclass_Create(Parent):-

%MARK Subclass, new variables

	dialog_CreateModal(Parent,dlg_subclass_ResID,"",
  		[
%BEGIN Subclass, ControlList, 14:28:48-24.11.1999, Code automatically updated!
		df(idc_subclass_1,editstr("pdc",[]),nopr)
%END Subclass, ControlList
		],
		dlg_subclass_eh,0,VALLIST,ANSWER),!,
	ANSWER = idc_ok,
	dlg_subclass_update(VALLIST),!.

  dlg_subclass_Create(_):-
	dlg_Note("Error: Fail in dlg_subclass_Create").

  dlg_subclass_update(_VALLIST):-
%BEGIN Subclass, Update controls, 14:28:48-24.11.1999, Code automatically updated!
	_IDC_SUBCLASS_1_VALUE = dialog_VLGetstr(idc_subclass_1,_VALLIST),
%END Subclass, Update controls
	!.
  dlg_subclass_update(_):-
	dlg_Note("Error: Fail in dlg_subclass_update").

%MARK Subclass, new events

%BEGIN Subclass, idc_lower _CtlInfo
  dlg_subclass_eh(_Win,e_Control(idc_lower,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	Window=win_GetCtlHandle(_Win,idc_subclass_1),
	win_SendEvent(Window,e_Char(50,c_Nothing)),
	!.
%END Subclass, idc_lower _CtlInfo

%BEGIN Subclass, idc_upper _CtlInfo
  dlg_subclass_eh(_Win,e_Control(idc_upper,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	Window=win_GetCtlHandle(_Win,idc_subclass_1),
	win_SendEvent(Window,e_Char(49,c_Nothing)),
	!.
%END Subclass, idc_upper _CtlInfo

%BEGIN Subclass, e_Create
  dlg_subclass_eh(_Win,e_Create(_CreationData),0):-!,
	Window=win_GetCtlHandle(_Win,idc_lower),
	win_Check(Window,checkbox_on),
	W=win_GetCtlHandle(_Win,idc_subclass_1),
	win_SetSubclassHandler(W,subclass_eh,b_false),
	!.
%END Subclass, e_Create

  dlg_subclass_eh(_,_,_):-!,fail.

%END_DLG Subclass
















