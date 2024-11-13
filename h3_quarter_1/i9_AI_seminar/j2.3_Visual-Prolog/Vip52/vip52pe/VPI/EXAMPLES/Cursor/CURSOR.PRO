/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  CURSOR
 FileName: CURSOR.PRO
 Purpose: Cursor handling
 Written by: PDC
 Comments:
******************************************************************************/

include "cursor.inc"
include "cursor.con"
include "hlptopic.con"

/******************************************************
	Handling of child windows
******************************************************/

DATABASE - cursor_window
  cursor_window(WINDOW,INTEGER,INTEGER)
ifdef os_os2
  cursor_text(WINDOW,string)
enddef

PREDICATES
  nondeterm cursor_type(INTEGER No,STRING Text,CURSOR)
  create_windows(WINDOW)
  resize_windows(WINDOW)
  my_counter (REAL)		%AnB 4.07.97

CLAUSES

  my_counter (5000000):-!.	%AnB 4.07.97
  my_counter (I):-
  	NewI=I+1,
  	my_counter(NewI).


  cursor_type(1,"Arrow",cursor_Arrow).
  cursor_type(2,"Cross",cursor_Cross).
  cursor_type(3,"I beam",cursor_Ibeam).
  cursor_type(4,"Icon",cursor_Icon).
  cursor_type(5,"Size",cursor_Size).
  cursor_type(6,"Size NESW",cursor_SizeNESW).
  cursor_type(7,"Size NS",cursor_SizeNS).
  cursor_type(8,"Size NWSE",cursor_SizeNWSE).
  cursor_type(9,"Size WE",cursor_SizeWE).
  cursor_type(10,"Up Arrow",cursor_UpArrow).
  cursor_type(11,"Wait",cursor_Wait).

  create_windows(Parent) :-
	cursor_type(No,Text,Type),
	  I = No mod 4,
	  J = No div 4,
	  WC = win_child_Create(Parent,Text),
	  cursor_set(WC,Type),
	  assert(cursor_window(WC,I,J)),
ifdef os_os2
	  assert(cursor_text(WC,Text)),
enddef
	fail.
  create_windows(_).

  resize_windows(W) :-
	Rect = win_GetClientRect(W),
	Rect = rct(L,T,R,B),
	Wid = ( R - L ) / 4,
	Hei = ( B - T ) / 3,
	cursor_window(WC,I,J),
	  L0 = L + Wid * I + 2,
	  T0 = T + Hei * J + 2,
	  R0 = L + Wid * ( I + 1 ) - 2,
	  B0 = T + Hei * ( J + 1 ) - 2,
	  win_Move(WC,rct(L0,T0,R0,B0)),
	fail.
  resize_windows(_).

%BEGIN_WIN Task Window
/***************************************************************************
	Event handling for Task Window
***************************************************************************/

PREDICATES

  task_win_eh : EHANDLER

CONSTANTS

%BEGIN Task Window, CreateParms, 18:12:04-23.11.1999, Code automatically updated!
  task_win_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Close,wsf_Maximize,wsf_Minimize,wsf_ClipSiblings]
  task_win_Menu  = res_menu(idr_task_menu)
  task_win_Title = "Cursor"
  task_win_Help  = idh_contents
%END Task Window, CreateParms

CLAUSES

%BEGIN Task Window, e_Create
  task_win_eh(_Win,e_Create(_),0):-!,
%BEGIN Task Window, InitControls, 18:12:04-23.11.1999, Code automatically updated!
%END Task Window, InitControls
%BEGIN Task Window, ToolbarCreate, 18:12:04-23.11.1999, Code automatically updated!
%END Task Window, ToolbarCreate
IFDEF use_message
	msg_Create(100),
ENDDEF
	create_windows(_Win),
	resize_windows(_Win),
	!.
%END Task Window, e_Create

%MARK Task Window, new events

%BEGIN Task Window, id_set_wait
  task_win_eh(_Win,e_Menu(id_set_wait,_ShiftCtlAlt),0):-!,
	cursor_SetWait(),
	my_counter (1),		%AnB 4.07.97
%	sleep ( 200 ),		%AnB 4.07.97
	!.
%END Task Window, id_set_wait

%BEGIN Task Window, id_hide
  task_win_eh(_Win,e_Menu(id_hide,_ShiftCtlAlt),0):-!,
	cursor_Hide(),
	my_counter(1),		%AnB 4.07.97
%	sleep (200),		%AnB 4.07.97
	!.
%END Task Window, id_hide

%BEGIN Task Window, e_Destroy
  task_win_eh(_Win,e_Destroy,0):-!,
	retractall(_,cursor_window),
	!.
%END Task Window, e_Destroy

%BEGIN Task Window, e_Update
  task_win_eh(_Win,e_Update(_UpdateRct),0):-!,
  	win_Clear(_Win,color_White),
	!.
%END Task Window, e_Update

%BEGIN Task Window, id_help_contents
  task_win_eh(_Win,e_Menu(id_help_contents,_ShiftCtlAlt),0):-!,
  	vpi_ShowHelp("cursor.hlp"),
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
	resize_windows(_Win),
	!.
%END Task Window, e_Size

%END_WIN Task Window

/***************************************************************************
	Invoking on-line Help
***************************************************************************/

  project_ShowHelpContext(HelpTopic):-
  	vpi_ShowHelpContext("cursor.hlp",HelpTopic),!.

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
  vpi_Init(task_win_Flags,task_win_eh,task_win_Menu,"cursor",task_win_Title).

%BEGIN_DLG About dialog
/**************************************************************************
	Creation and event handling for dialog: About dialog
**************************************************************************/

CONSTANTS

%BEGIN About dialog, CreateParms, 23:22:58-10.1.2000, Code automatically updated!
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

%BEGIN_WIN Child
/**************************************************************************
        Creation and event handling for window: Child
**************************************************************************/

CONSTANTS
%BEGIN Child, CreateParms, 18:12:00-23.11.1999, Code automatically updated!
  win_child_WinType = w_Child
  win_child_Flags = [wsf_Border]
  win_child_RCT = rct(100,80,440,240)
  win_child_Menu = no_menu
  win_child_Title = "Child"
  win_child_Help = 
%END Child, CreateParms

PREDICATES

  win_child_eh : EHANDLER

CLAUSES

  win_child_Create(Parent,Title,Win):-
	Win=win_Create(win_child_WinType,win_child_RCT,Title,
		   win_child_Menu,Parent,win_child_Flags,win_child_eh,0).

%BEGIN Child, e_Create
  win_child_eh(_Win,e_Create(_),0):-!,
%BEGIN Child, InitControls, 18:12:00-23.11.1999, Code automatically updated!
%END Child, InitControls
%BEGIN Child, ToolbarCreate, 18:12:00-23.11.1999, Code automatically updated!
%END Child, ToolbarCreate
	!.
%END Child, e_Create
%MARK Child, new events

%BEGIN Child, e_Update
  win_child_eh(_Win,e_Update(_UpdateRct),0):-!,
	DRAWTOOLS = win_GetDrawTools ( _Win ),
	win_SetPen ( _Win, pen ( 1, ps_Solid, color_Green ) ),
	win_SetBrush ( _Win ,brush ( pat_Solid, color_Green ) ),
	RCT = win_GetClientRect ( _Win ),
	draw_Rect ( _Win, RCT ),
	win_SetDrawTools ( _Win, DRAWTOOLS ),
ifdef os_os2
	cursor_text(_Win,Text),
elsedef
	Text=win_GetText(_Win),
enddef	
	ClientRect = win_GetClientRect(_Win),
	draw_TextInRect(_Win,ClientRect, Text, -1,[dtext_center]),
	!.
%END Child, e_Update

%BEGIN Child, e_Size
  win_child_eh(_Win,e_Size(_Width,_Height),0):-!,
IFDEF use_tbar
	toolbar_Resize(_Win),
ENDDEF
	win_Invalidate(_Win),
	!.
%END Child, e_Size

%BEGIN Child, e_Menu, Parent window 
  win_child_eh(Win,e_Menu(ID,CAS),0):-!,
	PARENT = win_GetParent(Win),
	win_SendEvent(PARENT,e_Menu(ID,CAS)),
	!.
%END Child, e_Menu, Parent window

%END_WIN Child











