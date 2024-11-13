/*****************************************************************************

		 Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  MDIWIN
 FileName: MDIWIN.PRO
 Purpose: MDI windows handling
 Written by: Yuri Illin
 Comments: Lines containing "%draw_background" comments are responsible for imitation 
of customized background drawing in the MDI task window.
******************************************************************************/

include "mdiwin.inc"
include "mdiwin.con"
%include "hlptopic.con"

%BEGIN_WIN Task Window
/***************************************************************************
	Event handling for Task Window
***************************************************************************/

PREDICATES

  task_win_eh : EHANDLER
  background_w_handler: EHANDLER  %draw_background

CONSTANTS

%BEGIN Task Window, CreateParms, 21:02:50-23.11.1999, Code automatically updated!
  task_win_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Close,wsf_Maximize,wsf_Minimize,wsf_ClipSiblings]
  task_win_Menu  = res_menu(idr_task_menu)
  task_win_Title = "Mdiwin"
  task_win_Help  = idh_contents
%END Task Window, CreateParms

CLAUSES

  background_w_handler(_Win,e_EraseBackground(),1):-	%%draw_background
  	!.
  background_w_handler(_Win,e_Update(_ClentRect),0):-	%draw_background
	win_SetForeColor(_Win,color_Yellow),
	Font=font_Create(ff_Helvetica,[fs_Bold,fs_Italic],14),
	win_SetFont(_Win,Font),
	draw_text(_Win,50,50,"This is imitation of drawing in the MDI task window client area").

%BEGIN Task Window, e_Create
  task_win_eh(_Win,e_Create(_),0):-!,
%BEGIN Task Window, InitControls, 21:02:50-23.11.1999, Code automatically updated!
%END Task Window, InitControls
%BEGIN Task Window, ToolbarCreate, 21:02:50-23.11.1999, Code automatically updated!
%END Task Window, ToolbarCreate
IFDEF use_message
	msg_Create(100),
ENDDEF
	NatMDI_TaskWin_h = vpi_GetAttrVal (attr_win_mdi_client_hwnd),	%draw_background
	WinHnd = cast(WINDOW,NatMDI_TaskWin_h),				%draw_background
	MDI_Win_ClientRCT = win_GetClientRect(_Win),			%draw_background
	_Background_Win = win_Create(w_child,MDI_Win_ClientRCT,"",	%draw_background
          no_menu,WinHnd,[wsf_ClipSiblings,wsf_Disabled,wsf_Transparent],background_w_handler,0),	%draw_background
	win_win_Create(_Win),
	win_win_Create(_Win),
	!.
%END Task Window, e_Create

%MARK Task Window, new events

%BEGIN Task Window, id_vertical_tile
  task_win_eh(_Win,e_Menu(id_vertical_tile,_ShiftCtlAlt),0):-!,
	vpi_MoveMDIWindowsTile( [mdiwin_vertical] ),
	!.
%END Task Window, id_vertical_tile

%BEGIN Task Window, id_horizontal_tile
  task_win_eh(_Win,e_Menu(id_horizontal_tile,_ShiftCtlAlt),0):-!,
	vpi_MoveMDIWindowsTile( [mdiwin_horizontal] ),
	!.
%END Task Window, id_horizontal_tile

%BEGIN Task Window, id_cascade
  task_win_eh(_Win,e_Menu(id_cascade,_ShiftCtlAlt),0):-!,
	vpi_MoveMDIWindowsCascade( [] ),
	!.
%END Task Window, id_cascade

%BEGIN Task Window, id_arrange_icons
  task_win_eh(_Win,e_Menu(id_arrange_icons,_ShiftCtlAlt),0):-!,
	vpi_ArrangeMDIIcons(),
	!.
%END Task Window, id_arrange_icons

%BEGIN Task Window, id_file_new
  task_win_eh(_Win,e_Menu(id_file_new,_ShiftCtlAlt),0):-!,
	win_win_Create(_Win),
	!.
%END Task Window, id_file_new

%BEGIN Task Window, id_help_contents
  task_win_eh(_Win,e_Menu(id_help_contents,_ShiftCtlAlt),0):-!,
  	vpi_ShowHelp("mdiwin.hlp"),
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
  	vpi_ShowHelpContext("mdiwin.hlp",HelpTopic),!.

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
ENDDEF  vpi_Init(task_win_Flags,task_win_eh,task_win_Menu,"mdiwin",task_win_Title).

%BEGIN_DLG About dialog
/**************************************************************************
	Creation and event handling for dialog: About dialog
**************************************************************************/

CONSTANTS

%BEGIN About dialog, CreateParms, 23:22:38-10.1.2000, Code automatically updated!
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

%BEGIN_WIN Win
/**************************************************************************
        Creation and event handling for window: Win
**************************************************************************/
DATABASE - winenum
determ  winnumber( INTEGER )
  
CONSTANTS
%BEGIN Win, CreateParms, 21:02:48-23.11.1999, Code automatically updated!
  win_win_WinType = w_TopLevel
  win_win_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Maximize,wsf_Minimize,wsf_Close,wsf_ClipSiblings]
  win_win_RCT = rct(0,0,200,100)
  win_win_Menu = no_menu
  win_win_Title = "Window - "
  win_win_Help = idh_contents
%END Win, CreateParms

PREDICATES

  win_win_eh : EHANDLER
  get_next_window_number( STRING )
  RCT random_shift_window( WINDOW, RCT )

CLAUSES

  win_win_Create(Parent):-
	WinRCT = random_shift_window( Parent, win_win_RCT ),
	get_next_window_number( Num ),
	concat(win_win_Title,Num,Title),
	win_Create(win_win_WinType,WinRCT,Title,
		   win_win_Menu,Parent,win_win_Flags,win_win_eh,0).

%BEGIN Win, e_Create
  win_win_eh(_Win,e_Create(_),0):-!,
%BEGIN Win, InitControls, 21:02:48-23.11.1999, Code automatically updated!
%END Win, InitControls
%BEGIN Win, ToolbarCreate, 21:02:48-23.11.1999, Code automatically updated!
%END Win, ToolbarCreate
	!.
%END Win, e_Create
%MARK Win, new events

%BEGIN Win, e_Size
  win_win_eh(_Win,e_Size(_Width,_Height),0):-!,
IFDEF use_tbar
	toolbar_Resize(_Win),
ENDDEF
	!.
%END Win, e_Size

%BEGIN Win, e_Menu, Parent window 
  win_win_eh(Win,e_Menu(ID,CAS),0):-!,
	PARENT = win_GetParent(Win),
	win_SendEvent(PARENT,e_Menu(ID,CAS)),
	!.
%END Win, e_Menu, Parent window

  get_next_window_number( Num ):-
        retract(winnumber( Iprev )),!,
        I = Iprev + 1,
        assert(winnumber( I )),
        str_int( Num, I ).
  get_next_window_number( Num ):-
        I = 1,
        assert(winnumber( I )),
        str_int( Num, I ).

  random_shift_window( Parent, StartWinRCT, WinRCT ):-
	ParentRCT = win_GetClientRect( Parent ),
	ParentRCT = rct( _, _, ParentWidth, ParentHeight ),
	StartWinRCT = rct( _, _, WinWidth, WinHeight ),
	MaxShiftedX = ParentWidth - WinWidth,
	MaxShiftedY = ParentHeight - WinHeight,
	random( MaxShiftedX, Dh ),
	random( MaxShiftedY, Dv ),
	WinRCT = rect_Offset( StartWinRCT, Dh, Dv ).

%END_WIN Win



































