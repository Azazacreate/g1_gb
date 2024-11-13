/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  CTLCOLOR
 FileName: CTLCOLOR.PRO
 Purpose: Set color to controls in Win32
 Written by: Visual Prolog
 Comments: This example works right only under WinNT.
******************************************************************************/

include "ctlcolor.inc"
include "ctlcolor.con"
include "hlptopic.con"

GLOBAL PREDICATES
SetTextColor(UNSIGNED, LONG) - (i,i) language stdcall
SetBkColor(UNSIGNED, LONG) - (i,i) language stdcall
UNSIGNED CreateSolidBrush(LONG) - (i) language stdcall
DeleteObject(UNSIGNED) - (i) language stdcall

CONSTANTS
wm_ctlcoloredit                 = 0x0133
wm_ctlcolorlistbox              = 0x0134
wm_ctlcolorbtn                  = 0x0135

DATABASE - hbrush
determ hbrush(UNSIGNED)

%BEGIN_WIN Task Window
/***************************************************************************
	Event handling for Task Window
***************************************************************************/

PREDICATES

  task_win_eh : EHANDLER

CONSTANTS

%BEGIN Task Window, CreateParms, 18:01:54-23.11.1999, Code automatically updated!
  task_win_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Close,wsf_Maximize,wsf_Minimize,wsf_ClipSiblings]
  task_win_Menu  = res_menu(idr_task_menu)
  task_win_Title = "Set colors to control"
  task_win_Help  = idh_contents
%END Task Window, CreateParms

CLAUSES

%BEGIN Task Window, e_Create
  task_win_eh(_Win,e_Create(_),0):-!,
%BEGIN Task Window, InitControls, 18:01:54-23.11.1999, Code automatically updated!
%END Task Window, InitControls
%BEGIN Task Window, ToolbarCreate, 18:01:54-23.11.1999, Code automatically updated!
%END Task Window, ToolbarCreate
IFDEF use_message
	msg_Create(100),
ENDDEF
        HBRUSH = CreateSolidBrush(color_Green),
        assert(hbrush(HBRUSH)),
	!.
%END Task Window, e_Create

%MARK Task Window, new events

%BEGIN Task Window, e_Destroy
  task_win_eh(_Win,e_Destroy,0):-!,
        retract(hbrush(HBRUSH)),
        DeleteObject(HBRUSH),
	!.
%END Task Window, e_Destroy

%BEGIN Task Window, id_file_new
  task_win_eh(_Win,e_Menu(id_file_new,_ShiftCtlAlt),0):-!,
	dlg_dialog_with_color_contol_Create(_Win),
	!.
%END Task Window, id_file_new

%BEGIN Task Window, id_help_contents
  task_win_eh(_Win,e_Menu(id_help_contents,_ShiftCtlAlt),0):-!,
  	vpi_ShowHelp("ctlcolor.hlp"),
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
  	vpi_ShowHelpContext("ctlcolor.hlp",HelpTopic).

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
  vpi_Init(task_win_Flags,task_win_eh,task_win_Menu,"ctlcolor",task_win_Title).

%BEGIN_DLG About dialog
/**************************************************************************
	Creation and event handling for dialog: About dialog
**************************************************************************/

CONSTANTS

%BEGIN About dialog, CreateParms, 15:02:08-25.11.1999, Code automatically updated!
  dlg_about_dialog_ResID = idd_dlg_about
  dlg_about_dialog_DlgType = wd_Modal
  dlg_about_dialog_Help = idh_contents
%END About dialog, CreateParms

PREDICATES

  dlg_about_dialog_eh : EHANDLER

CLAUSES

  dlg_about_dialog_Create(Parent):-
	win_CreateResDialog(Parent,dlg_about_dialog_DlgType,dlg_about_dialog_ResID,dlg_about_dialog_eh,0).

%BEGIN About dialog, idc_ok _CtlInfo
  dlg_about_dialog_eh(_Win,e_Control(idc_ok,_CtrlType,_CtrlWin,_CtrlInfo),0):-!,
	win_Destroy(_Win),
	!.
%END About dialog, idc_ok _CtlInfo
%MARK About dialog, new events

  dlg_about_dialog_eh(_,_,_):-!,fail.

%END_DLG About dialog


%BEGIN_DLG Dialog with color contol
/**************************************************************************
	Creation and event handling for dialog: Dialog with color contol
**************************************************************************/

CONSTANTS

%BEGIN Dialog with color contol, CreateParms, 18:01:46-23.11.1999, Code automatically updated!
  dlg_dialog_with_color_contol_ResID = idd_dialog_with_color_contol
  dlg_dialog_with_color_contol_DlgType = wd_Modal
  dlg_dialog_with_color_contol_Help = idh_contents
%END Dialog with color contol, CreateParms

PREDICATES

  dlg_dialog_with_color_contol_eh : EHANDLER

CLAUSES

  dlg_dialog_with_color_contol_Create(Parent):-
	win_CreateResDialog(Parent,dlg_dialog_with_color_contol_DlgType,dlg_dialog_with_color_contol_ResID,dlg_dialog_with_color_contol_eh,0).

%BEGIN Dialog with color contol, idc_ok _CtlInfo
  dlg_dialog_with_color_contol_eh(_Win,e_Control(idc_ok,_CtrlType,_CtrlWin,_CtrlInfo),0):-!,
	win_Destroy(_Win),
	!.
%END Dialog with color contol, idc_ok _CtlInfo
%MARK Dialog with color contol, new events

%BEGIN Dialog with color contol, e_Native
  dlg_dialog_with_color_contol_eh(_Win,e_Native(wm_ctlcoloredit,HDC,_LParam),HBRUSH):-!,
        SetTextColor(HDC, color_Red),
        SetBkColor(HDC, color_Black),
        hbrush(HBRUSH),
	!.
%END Dialog with color contol, e_Native

%BEGIN Dialog with color contol, e_Create
  dlg_dialog_with_color_contol_eh(_Win,e_Create(_CreationData),0):-!,
	win_EnableHook(_Win, b_true),
	!.
%END Dialog with color contol, e_Create

  dlg_dialog_with_color_contol_eh(_,_,_):-!,fail.

%END_DLG Dialog with color contol









