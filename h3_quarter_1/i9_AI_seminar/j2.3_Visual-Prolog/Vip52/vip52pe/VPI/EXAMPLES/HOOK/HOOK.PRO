/*****************************************************************************

		 Copyright (c) 1984 - 2000 Prolog Development Center A/S

			VISUAL Prolog

 Project:  HOOK
 FileName: HOOK.PRO
 Purpose: Example of using hook function
 Written by: Alexander Gostintsev
 Comments:
******************************************************************************/

include "hook.inc"
include "hook.con"
include "hlptopic.con"

PREDICATES

  get_Win_msg(INTEGER,STRING)

CLAUSES

  get_win_msg(0x0200,"WM_MOUSEMOVE"):-!.
  get_win_msg(0x0201,"WM_LBUTTONDOWN"):-!.
  get_win_msg(0x0202,"WM_LBUTTONUP"):-!.
  get_win_msg(0x0203,"WM_LBUTTONDBLCLK"):-!.
  get_win_msg(0x0204,"WM_RBUTTONDOWN"):-!.
  get_win_msg(0x0205,"WM_RBUTTONUP"):-!.
  get_win_msg(0x0206,"WM_RBUTTONDBLCLK"):-!.
  get_win_msg(0x00a0,"WM_NCMOUSEMOVE"):-!.
  get_win_msg(0x00a1,"WM_NCLBUTTONDOWN"):-!.
  get_win_msg(0x00a2,"WM_NCLBUTTONUP"):-!.
  get_win_msg(0x00a3,"WM_NCLBUTTONDBLCLK"):-!.
  get_win_msg(0x00a4,"WM_NCRBUTTONDOWN"):-!.
  get_win_msg(0x00a5,"WM_NCRBUTTONUP"):-!.
  get_win_msg(0x00a6,"WM_NCRBUTTONDBLCLK"):-!.
  get_win_msg(0x0006,"WM_ACTIVATE"):-!.
  get_win_msg(0x001c,"WM_ACTIVATEAPP"):-!.
  get_win_msg(0x0086,"WM_NCACTIVATE"):-!.
  get_win_msg(0x0007,"WM_SETFOCUS"):-!.
  get_win_msg(0x0008,"WM_KILLFOCUS"):-!.
  get_win_msg(0x0100,"WM_KEYDOWN"):-!.
  get_win_msg(0x0101,"WM_KEYUP"):-!.
  get_win_msg(0x0102,"WM_CHAR"):-!.
  get_win_msg(0x0104,"WM_SYSKEYDOWN"):-!.
  get_win_msg(0x0105,"WM_SYSKEYUP"):-!.
  get_win_msg(0x0106,"WM_SYSCHAR"):-!.
  get_win_msg(0x0020,"WM_SETCURSOR"):-!.
  get_win_msg(0x0084,"WM_NCHITTEST"):-!.
  get_win_msg(0x000f,"WM_PAINT"):-!.
  get_win_msg(0x0085,"WM_NCPAINT"):-!.
  get_win_msg(0x0046,"WM_WINDOWPOSCHANGING"):-!.
  get_win_msg(0x0047,"WM_WINDOWPOSCHANGED"):-!.
  get_win_msg(0x0083,"WM_NCCALCSIZE"):-!.
  get_win_msg(0x000d,"WM_CONTINUE"):-!.
  get_win_msg(0x0014,"WM_ERASEBKGND"):-!.
  get_win_msg(0x0021,"WM_MOUSEACTIVATE"):-!.
  get_win_msg(0x0112,"WM_SYSCOMMAND"):-!.
  get_win_msg(0x0210,"WM_PARENTNOTIFY"):-!.
  get_win_msg(0x0116,"WM_INITMENU"):-!.
  get_win_msg(0x0117,"WM_INITMENUPOPUP"):-!.
  get_win_msg(0x011f,"WM_MENUSELECT"):-!.
  get_win_msg(0x0121,"WM_ENTERIDLE"):-!.
  get_win_msg(0x0024,"WM_GETMINMAXINFO"):-!.
  get_win_msg(0x0111,"WM_COMMAND"):-!.
  get_win_msg(0x0211,"WM_ENTERMENULOOP"):-!.
  get_win_msg(0x0212,"WM_EXITMENULOOP"):-!.

  get_win_msg(Mes,Smes):-!,
	str_int(Smes,Mes).

%BEGIN_WIN Task Window
/***************************************************************************
		Event handling for task window
***************************************************************************/

PREDICATES

  task_win_eh : EHANDLER

CONSTANTS

%BEGIN Task Window, CreateParms, 19:01:14-23.11.1999, Code automatically updated!
  task_win_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Close,wsf_Maximize,wsf_Minimize,wsf_ClipSiblings]
  task_win_Menu  = res_menu(idr_task_menu)
  task_win_Title = "Hook"
  task_win_Help  = idh_contents
%END Task Window, CreateParms

CLAUSES

%BEGIN Task Window, e_Create
  task_win_eh(_Win,e_Create(_),0):-!,
%BEGIN Task Window, ToolbarCreate, 19:01:14-23.11.1999, Code automatically updated!
%END Task Window, ToolbarCreate
IFDEF use_message
	msg_Create(1000),
ENDDEF
	!.
%END Task Window, e_Create

%MARK Task Window, new events

%BEGIN Task Window, e_Native
  task_win_eh(_Win,e_Native(Mes,_WPARAM,_LPARAM),0):-
	Mes>=0x300,Mes<=0x30E,!,fail. % clipboard messages must be excluded for write
  task_win_eh(Win,e_Native(Mes,WParam,LParam),0):-
	get_win_msg(Mes,Smes),
	write("Window: ",Win,"  Message: ",Smes,"  wParam: ",WParam,"  lParam: ",LParam),nl,
	!,fail.
%END Task Window, e_Native

%BEGIN Task Window, e_Update
  task_win_eh(_Win,e_Update(_UpdateRct),0):-!,
  	win_Clear(_Win,color_White),
	!.
%END Task Window, e_Update

%BEGIN Task Window, id_help_about
  task_win_eh(_Win,e_Menu(id_help_about,_ShiftCtlAlt),0):-!,
	dlg_about_dialog_Create(_Win),
	!.
%END Task Window, id_help_about
%BEGIN Task Window, id_hook_enable_hook
  task_win_eh(_Win,e_Menu(id_hook_enable_hook,_ShiftCtlAlt),0):-!,
	menu_Check(_Win,id_hook_disable_hook,b_false),
	menu_Check(_Win,id_hook_enable_hook,b_true),
	win_EnableHook(_Win,b_true),
	!.
%END Task Window, id_hook_enable_hook
%BEGIN Task Window, id_hook_disable_hook
  task_win_eh(_Win,e_Menu(id_hook_disable_hook,_ShiftCtlAlt),0):-!,
	menu_Check(_Win,id_hook_disable_hook,b_true),
	menu_Check(_Win,id_hook_enable_hook,b_false),
	win_EnableHook(_Win,b_false),
	!.
%END Task Window, id_hook_disable_hook
%BEGIN Task Window, id_file_exit
  task_win_eh(_Win,e_Menu(id_file_exit,_ShiftCtlAlt),0):-!,
	win_EnableHook(_Win,b_false),
	win_Destroy(_Win),
	!.
%END Task Window, id_file_exit
%BEGIN Task Window, id_help_contents
IFDEF use_on_line_help
  task_win_eh(_Win,e_Menu(id_help_contents,_ShiftCtlAlt),0):-!,
	vpi_ShowHelp("hook.hlp"),
	!.
ENDDEF
%END Task Window, id_help_contents
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

/***************************************************************************
			Main Goal Project
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
  vpi_Init(task_win_Flags,task_win_eh,task_win_Menu,"hook",task_win_Title).

%END_WIN Task Window

%BEGIN_DLG About dialog
/**************************************************************************
	Creation and event handling for dialog: "About dialog"
	Code style: Single dialog
**************************************************************************/

CONSTANTS

%BEGIN About dialog, CreateParms, 19:01:10-23.11.1999, Code automatically updated!
  dlg_about_dialog_ResID = idd_dlg_about
  dlg_about_dialog_DlgType = wd_Modal
  dlg_about_dialog_Help = idh_contents
%END About dialog, CreateParms

PREDICATES

  dlg_about_dialog_eh : EHANDLER

CLAUSES

  dlg_about_dialog_Create(_Win):-
	win_CreateResDialog(_Win,dlg_about_dialog_DlgType,dlg_about_dialog_ResID,dlg_about_dialog_eh,0),!.

%BEGIN About dialog, idc_ok _CtlInfo
  dlg_about_dialog_eh(_Win,e_Control(idc_ok,_CtrlType,_CtrlWin,_CtrlInfo),0):-!,
	win_Destroy(_Win),
	!.
%END About dialog, idc_ok _CtlInfo
%MARK About dialog, new events

  dlg_about_dialog_eh(_,_,0) :- !,fail.
%END_DLG About dialog








