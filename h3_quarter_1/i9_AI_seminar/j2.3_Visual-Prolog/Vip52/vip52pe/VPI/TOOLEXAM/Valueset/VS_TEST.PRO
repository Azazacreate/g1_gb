/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  VS_TEST
 FileName: VS_TEST.PRO
 Purpose: Value set example
 Written by: Yuri Illin
 Comments:
******************************************************************************/

include "vs_test.inc"
include "vs_test.con"
include "hlptopic.con"

%BEGIN_WIN Task Window
/***************************************************************************
	Event handling for Task Window
***************************************************************************/

PREDICATES

  task_win_eh : EHANDLER

CONSTANTS

%BEGIN Task Window, CreateParms, 16:37:42-24.11.1999, Code automatically updated!
  task_win_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Close,wsf_Maximize,wsf_Minimize,wsf_ClipSiblings]
  task_win_Menu  = res_menu(idr_task_menu)
  task_win_Title = "ValueSet test"
  task_win_Help  = idh_contents
%END Task Window, CreateParms

CLAUSES

%BEGIN Task Window, e_Create
  task_win_eh(_Win,e_Create(_),0):-!,
%BEGIN Task Window, InitControls, 16:37:42-24.11.1999, Code automatically updated!
%END Task Window, InitControls
IFDEF use_message
	msg_Create(100),
ENDDEF
	win_valueset_Create(_Win),
	write("Press F7 to open dialog"),nl,
	!.
%END Task Window, e_Create

%MARK Task Window, new events

%BEGIN Task Window, id_file_new
  task_win_eh(_Win,e_Menu(id_file_new,_ShiftCtlAlt),0):-!,
	dlg_see_events_from_value_set_Create(_Win),
	!.
%END Task Window, id_file_new

%BEGIN Task Window, id_help_contents
  task_win_eh(_Win,e_Menu(id_help_contents,_ShiftCtlAlt),0):-!,
  	vpi_ShowHelp("vs_test.hlp"),
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
  	vpi_ShowHelpContext("vs_test.hlp",HelpTopic),!.

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
ENDDEF  
  vpi_Init(task_win_Flags,task_win_eh,task_win_Menu,"vs_test",task_win_Title).

%BEGIN_DLG About dialog
/**************************************************************************
	Creation and event handling for dialog: About dialog
**************************************************************************/

CONSTANTS

%BEGIN About dialog, CreateParms, 13:56:54-9.12.1999, Code automatically updated!
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

%BEGIN_WIN valueset
/**************************************************************************
	Creation and event handling for class: "valueset"
**************************************************************************/

CONSTANTS

%BEGIN valueset, CreateParms, 16:37:36-24.11.1999, Code automatically updated!
  win_valueset_ClassName = "valueset"
  win_valueset_Help = idh_contents
%END valueset, CreateParms

PREDICATES

  win_valueset_eh : EHANDLER

CLAUSES

  win_valueset_Create(_Parent):-
	class_Create(win_valueset_ClassName,win_valueset_eh),!.

%BEGIN valueset, e_Create
  win_valueset_eh(Win,e_Create(_),0):-!,
%BEGIN valueset, InitControls, 16:37:36-24.11.1999, Code automatically updated!
%END valueset, InitControls
    	valueset_CreateSubClass( WIN, 1, 3, [
    	  c(10,text("First item of value set")),
    	  c(11,icon(vpi_application_icon)),
    	  c(12,text("Last"))
    	  ] ),
	!.
%END valueset, e_Create
%MARK valueset, new events

%BEGIN valueset, e_Menu, Parent window 
  win_valueset_eh(Win,e_Menu(ID,CAS),0):-!,
	PARENT = win_GetParent(Win),
	win_SendEvent(PARENT,e_Menu(ID,CAS)),
	!.
%END valueset, e_Menu, Parent window

%END_WIN valueset


%BEGIN_DLG See events from value set
/**************************************************************************
	Creation and event handling for dialog: See events from value set
**************************************************************************/

CONSTANTS

%BEGIN See events from value set, CreateParms, 16:37:26-24.11.1999, Code automatically updated!
  dlg_see_events_from_value_set_ResID = idd_see_events_from_value_set
  dlg_see_events_from_value_set_DlgType = wd_Modeless
  dlg_see_events_from_value_set_Help = idh_contents
%END See events from value set, CreateParms

PREDICATES

  dlg_see_events_from_value_set_eh : EHANDLER
  procedure dlg_see_events_from_value_set_update(DIALOG_VAL_LIST)

CLAUSES

  dlg_see_events_from_value_set_Create(Parent):-

%MARK See events from value set, new variables

	dialog_CreateModeless(Parent,dlg_see_events_from_value_set_ResID,"",
  		[
%BEGIN See events from value set, ControlList, 16:37:26-24.11.1999, Code automatically updated!
%END See events from value set, ControlList
		],
		dlg_see_events_from_value_set_eh,0),!.

  dlg_see_events_from_value_set_Create(_):-
	dlg_Note("Error: Fail in dlg_see_events_from_value_set_Create").

  dlg_see_events_from_value_set_update(_VALLIST):-
%BEGIN See events from value set, Update controls, 16:37:26-24.11.1999, Code automatically updated!
%END See events from value set, Update controls
	!.
  dlg_see_events_from_value_set_update(_):-
	dlg_Note("Error: Fail in dlg_see_events_from_value_set_update").

%BEGIN See events from value set, idc_ok _CtlInfo
  dlg_see_events_from_value_set_eh(_Win,e_Control(idc_ok,_CtrlType,_CtrlWin,_CtrlInfo),0):-!,
	VALLIST = dialog_GetValues(_Win),
	dlg_see_events_from_value_set_update(VALLIST),
	!,fail.
%END See events from value set, idc_ok _CtlInfo
%MARK See events from value set, new events
  dlg_see_events_from_value_set_eh(_Win,e_Control(Id,CtrlType,CtrlWin,CtlInfo),0):-!,
  	Id <> idc_cancel,
  	E = e_Control(Id,CtrlType,CtrlWin,CtlInfo),
  	write(E),nl,
	!.

  dlg_see_events_from_value_set_eh(_,_,_):-!,fail.

%END_DLG See events from value set













