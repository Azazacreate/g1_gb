/*****************************************************************************

		 Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  EVENTS
 FileName: EVENTS.PRO
 Purpose: VPI Events
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments:
******************************************************************************/

include "events.inc"
include "events.con"
include "hlptopic.con"

GLOBAL PREDICATES
  pdctree_handler : EHANDLER          % "PDCTREE" class handler
  pdcedit_handler : EHANDLER	      % "PDCEDIT" class handler

CLAUSES
/******************************* PDCTREE handler *******************************/
  pdctree_handler(_Win,Event,0):-
	write("Custom Control PDCTREE ( ",_Win," ) ",':',Event),nl,
	fail.
  
  pdctree_handler ( _Win, e_Create(_), 0 ) :- !,
	Tree = tree ( "0:Null", unmarked,
			[
			tree ( "1:One", unmarked, 
			        [], 0
			     ),
			tree ( "2:Two", unmarked,
			 	[tree("3:Three",unmarked,
			 		[],0
			 	     )
			 	],0
			      ),
			tree ("4:Four",unmarked,
			   	[],0
			       )
		        ],0
		     ),
	TreeFont = font_Create ( ff_Times, [], 10 ),
	TreeWinInfo = tree_WinInfo ( TreeFont, tree_DirRight, [] ),
	tree_CreateSubClass( _Win, Tree, TreeWinInfo, [] ),
	!.
  pdctree_handler ( W, e_MouseDbl ( _, _, _ ), 0 ) :-!,
		tree_OpenCloseNode ( W ),
	!.		

/******************************* PDCEDIT handler *******************************/
  pdcedit_handler(_Win,Event,0):-
	write("Custom Control PDCEDIT ( ",_Win," ) ",':',Event),nl,
	fail.

  pdcedit_handler (_Win,e_create(_),0 ) :-!,
	Text="Hello, Custom Control (Editor)",
	Font = font_Create ( ff_Times, [], 15 ),
	edit_CreateSubClass ( _Win, "*.pro", Font, b_false, b_true, b_false,Text, 1, pdcedit_handler ),!,
	fail.

  pdcedit_handler ( W, e_MouseDown ( _, _, _ ), 0 ) :- !, 
	win_SetFocus ( W ), fail.

%BEGIN_WIN Task Window
/***************************************************************************
	Event handling for Task Window
***************************************************************************/

PREDICATES

  task_win_eh : EHANDLER

CONSTANTS

%BEGIN Task Window, CreateParms, 11:18:42-10.12.1999, Code automatically updated!
  task_win_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Close,wsf_Maximize,wsf_Minimize,wsf_ClipChildren]
  task_win_Menu  = res_menu(idr_task_menu)
  task_win_Title = "Events"
  task_win_Help  = idh_contents
%END Task Window, CreateParms

CLAUSES

%BEGIN Task Window, e_Create
  task_win_eh(_Win,e_Create(_),0):-!,
%BEGIN Task Window, InitControls, 11:18:42-10.12.1999, Code automatically updated!
	win_CreateControl(wc_PushButton,rct(30,40,130,64),"Push Button",_Win,[wsf_Group,wsf_TabStop],idc_task_push_button),
	win_CreateControl(wc_CheckBox,rct(30,80,130,98),"Check Box",_Win,[wsf_Auto,wsf_Group,wsf_TabStop],idc_task_check_box),
	win_CreateControl(wc_RadioButton,rct(30,120,130,138),"Radio Button",_Win,[wsf_Auto,wsf_TabStop],idc_task_radio_button),
	win_CreateControl(wc_HScroll,rct(30,160,156,180),"",_Win,[],idc_task_hscroll),
	win_CreateControl(wc_VScroll,rct(159,40,176,160),"",_Win,[],idc_task_vscroll),
	win_CreateControl(wc_LBox,rct(210,40,450,152),"",_Win,[wsf_Group,wsf_TabStop,wsf_VScroll,wsf_Sort,wsf_NoIntegralHeight],idc_task_list_box),
	win_CreateControl(wc_Text,rct(240,190,340,208),"Static text",_Win,[wsf_AlignLeft],idc_task_static_text),
	win_CreateControl(wc_Edit,rct(480,40,580,64),"Edit",_Win,[wsf_Group,wsf_TabStop,wsf_AutoHScroll,wsf_AlignLeft],idc_task_edit),
	win_CreateControl(wc_LBoxButton,rct(480,84,580,144),"",_Win,[wsf_Group,wsf_TabStop,wsf_VScroll,wsf_Sort],idc_task_list_button),
	win_CreateControl(wc_LBoxEdit,rct(480,128,580,188),"",_Win,[wsf_Group,wsf_TabStop,wsf_VScroll,wsf_Sort],idc_task_list_edit),
%END Task Window, InitControls
%BEGIN Task Window, ToolbarCreate, 11:18:42-10.12.1999, Code automatically updated!
%END Task Window, ToolbarCreate
IFDEF use_message
	msg_Create(100),
ENDDEF
	CONTROLLIST=[
	icon(wdef(wc_Icon,rct(380,180,412,212),"",u_Pixels),101,9012,[wsf_NoClipSiblings])
		],
	win_CreateDynControl(CONTROLLIST,_Win),		
	
	LBW0 = win_getCtlHandle(_Win,idc_task_list_edit),
	lbox_Add(LBW0,-1,["Edit 0","Edit 1","Edit 2","Edit 3"]),
	lbox_SetSel(LBW0,0,b_true),
	LBW1 = win_getCtlHandle(_Win,idc_task_list_box),
	lbox_Add(LBW1,-1,["Item 0","Item 1","Item 2","Item 3",
			"Item 4","Item 5","Item 6","Item 7"]),
	lbox_SetSel(LBW1,0,b_true),
	LBW2 = win_getCtlHandle(_Win,idc_task_list_button),
	lbox_Add(LBW2,-1,["0","1","2","3"]),
	lbox_SetSel(LBW2,0,b_true),
	class_Create("PDCTREE",pdctree_handler),
	class_Create("PDCEDIT",pdcedit_handler),
	!.
%END Task Window, e_Create
  task_win_eh(_Win,Event,0):-
	write("Task Window ( ",_Win," ) ",':',Event),nl,
	fail.

%MARK Task Window, new events

%BEGIN Task Window, e_Update
  task_win_eh(_Win,e_Update(_UpdateRct),0):-!,
	DRAWTOOLS = win_GetDrawTools ( _Win ),
	win_SetPen ( _Win, pen ( 1, ps_Solid, color_LtGray ) ),
	win_SetBrush ( _Win ,brush ( pat_Solid, color_LtGray ) ),
	RCT = win_GetClientRect ( _Win ),
	draw_Rect ( _Win, RCT ),
	win_SetDrawTools ( _Win, DRAWTOOLS ),
	!.
%END Task Window, e_Update

%BEGIN Task Window, id_Open_Window_window_custom_control
  task_win_eh(_Win,e_Menu(id_Open_Window_window_custom_control,_ShiftCtlAlt),0):-!,
	win_window_Create(_Win),
	!.
%END Task Window, id_Open_Window_window_custom_control

%BEGIN Task Window, id_Open_Window_test_window
  task_win_eh(_Win,e_Menu(id_Open_Window_test_window,_ShiftCtlAlt),0):-!,
	win_test_window_Create(_Win),
	!.
%END Task Window, id_Open_Window_test_window

%BEGIN Task Window, id_Open_Dialog_test_dialog
  task_win_eh(_Win,e_Menu(id_Open_Dialog_test_dialog,_ShiftCtlAlt),0):-!,
	dlg_test_dialog_Create(_Win),
	!.
%END Task Window, id_Open_Dialog_test_dialog

%BEGIN Task Window, id_Open_Dialog_dialog_custom_control
  task_win_eh(_Win,e_Menu(id_Open_Dialog_dialog_custom_control,_ShiftCtlAlt),0):-!,
	dlg_dialog_Create(_Win),
	!.
%END Task Window, id_Open_Dialog_dialog_custom_control

%BEGIN Task Window, id_help_contents
  task_win_eh(_Win,e_Menu(id_help_contents,_ShiftCtlAlt),0):-!,
  	vpi_ShowHelp("events.hlp"),
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
  	vpi_ShowHelpContext("events.hlp",HelpTopic),!.

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
  vpi_Init(task_win_Flags,task_win_eh,task_win_Menu,"events",task_win_Title).

%BEGIN_DLG About dialog
/**************************************************************************
	Creation and event handling for dialog: About dialog
**************************************************************************/

CONSTANTS

%BEGIN About dialog, CreateParms, 15:03:10-25.11.1999, Code automatically updated!
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

%BEGIN_WIN Test window
/**************************************************************************
        Creation and event handling for window: Test window
**************************************************************************/

CONSTANTS
%BEGIN Test window, CreateParms, 18:55:42-23.11.1999, Code automatically updated!
  win_test_window_WinType = w_TopLevel
  win_test_window_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Close,wsf_ClipSiblings]
  win_test_window_RCT = rct(100,80,440,240)
  win_test_window_Menu = no_menu
  win_test_window_Title = "Test window"
  win_test_window_Help = idh_contents
%END Test window, CreateParms

PREDICATES

  win_test_window_eh : EHANDLER

CLAUSES

  win_test_window_Create(Parent):-
	win_Create(win_test_window_WinType,win_test_window_RCT,win_test_window_Title,
		   win_test_window_Menu,Parent,win_test_window_Flags,win_test_window_eh,0).

  win_test_window_eh(_Win,Event,0):-
	write("Test window ( ",_Win," ) ",':',Event),nl,
	fail.
%BEGIN Test window, e_Create
  win_test_window_eh(_Win,e_Create(_),0):-!,
%BEGIN Test window, InitControls, 18:55:42-23.11.1999, Code automatically updated!
%END Test window, InitControls
%BEGIN Test window, ToolbarCreate, 18:55:42-23.11.1999, Code automatically updated!
%END Test window, ToolbarCreate
	!.
%END Test window, e_Create
%MARK Test window, new events

%BEGIN Test window, e_Update
  win_test_window_eh(_Win,e_Update(_UpdateRct),0):-!,
	win_Clear(_Win,color_White),
	!.
%END Test window, e_Update

%BEGIN Test window, e_Size
  win_test_window_eh(_Win,e_Size(_Width,_Height),0):-!,
IFDEF use_tbar
	toolbar_Resize(_Win),
ENDDEF
	!.
%END Test window, e_Size

%BEGIN Test window, e_Menu, Parent window 
  win_test_window_eh(Win,e_Menu(ID,CAS),0):-!,
	PARENT = win_GetParent(Win),
	win_SendEvent(PARENT,e_Menu(ID,CAS)),
	!.
%END Test window, e_Menu, Parent window

%END_WIN Test window


%BEGIN_DLG Test dialog
/**************************************************************************
	Creation and event handling for dialog: Test dialog
**************************************************************************/

CONSTANTS

%BEGIN Test dialog, CreateParms, 18:55:30-23.11.1999, Code automatically updated!
  dlg_test_dialog_ResID = idd_test_dialog
  dlg_test_dialog_DlgType = wd_Modal
  dlg_test_dialog_Help = idh_contents
%END Test dialog, CreateParms

PREDICATES

  dlg_test_dialog_eh : EHANDLER

CLAUSES

  dlg_test_dialog_Create(Parent):-
	win_CreateResDialog(Parent,dlg_test_dialog_DlgType,dlg_test_dialog_ResID,dlg_test_dialog_eh,0),!.

  dlg_test_dialog_eh(_Win,Event,0):-
	write("Test dialog ( ",_Win," ) ",':',Event),nl,
	fail.

%BEGIN Test dialog, idc_ok _CtlInfo
  dlg_test_dialog_eh(_Win,e_Control(idc_ok,_CtrlType,_CtrlWin,_CtrlInfo),0):-!,
	win_Destroy(_Win),
	!.
%END Test dialog, idc_ok _CtlInfo
%MARK Test dialog, new events

%BEGIN Test dialog, e_Create
  dlg_test_dialog_eh(_Win,e_Create(_CreationData),0):-!,
	LBW0 = win_GetCtlHandle(_Win,idc_list_edit),
	lbox_Add(LBW0,-1,["Edit 0","Edit 1","Edit 2","Edit 3"]),
	lbox_SetSel(LBW0,0,b_true),
	LBW1 = win_GetCtlHandle(_Win,idc_list_box),
	lbox_Add(LBW1,-1,["Item 0","Item 1","Item 2","Item 3",
			"Item 4","Item 5","Item 6","Item 7"]),
	lbox_SetSel(LBW1,0,b_true),
	LBW2 = win_GetCtlHandle(_Win,idc_list_button),
	lbox_Add(LBW2,-1,["0","1","2","3"]),
	lbox_SetSel(LBW2,0,b_true),
	!.
%END Test dialog, e_Create

%BEGIN Test dialog, idc_cancel _CtlInfo
  dlg_test_dialog_eh(_Win,e_Control(idc_cancel,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	win_Destroy(_Win),
	!.
%END Test dialog, idc_cancel _CtlInfo

  dlg_test_dialog_eh(_,_,_):-!,fail.

%END_DLG Test dialog


%BEGIN_WIN Window
/**************************************************************************
        Creation and event handling for window: Window
**************************************************************************/

CONSTANTS
%BEGIN Window, CreateParms, 18:55:34-23.11.1999, Code automatically updated!
  win_window_WinType = w_TopLevel
  win_window_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Maximize,wsf_Minimize,wsf_Close,wsf_ClipSiblings]
  win_window_RCT = rct(100,80,423,258)
  win_window_Menu = no_menu
  win_window_Title = "Window"
  win_window_Help = idh_contents
%END Window, CreateParms

PREDICATES

  win_window_eh : EHANDLER

CLAUSES

  win_window_Create(Parent):-
	win_Create(win_window_WinType,win_window_RCT,win_window_Title,
		   win_window_Menu,Parent,win_window_Flags,win_window_eh,0).

  win_window_eh(_Win,Event,0):-
	write("Window ( ",_Win," ) ",':',Event),nl,
	fail.
%BEGIN Window, e_Create
  win_window_eh(_Win,e_Create(_),0):-!,
%BEGIN Window, InitControls, 18:55:34-23.11.1999, Code automatically updated!
	win_CreateDynControl([customctl(wdef(wc_Custom,rct(15,20,308,127),"Custom",u_Pixels),"PDCTREE",idc_custom_tree,[wsf_Group,wsf_TabStop])],_Win),
	win_CreateControl(wc_PushButton,rct(108,145,204,169),"Close",_Win,[wsf_Group,wsf_TabStop],idc_close),
	win_CreateControl(wc_GroupBox,rct(4,2,319,135),"Custom Control",_Win,[],idc_custom_control),
%END Window, InitControls
%BEGIN Window, ToolbarCreate, 18:55:34-23.11.1999, Code automatically updated!
%END Window, ToolbarCreate
	!.
%END Window, e_Create
%MARK Window, new events

%BEGIN Window, idc_close _CtlInfo
  win_window_eh(_Win,e_Control(idc_close,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	win_Destroy(_Win),
	!.
%END Window, idc_close _CtlInfo

%BEGIN Window, e_Update
  win_window_eh(_Win,e_Update(_UpdateRct),0):-!,
	win_Clear(_Win,color_LtGray),
	!.
%END Window, e_Update

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


%BEGIN_DLG Dialog
/**************************************************************************
	Creation and event handling for dialog: Dialog
**************************************************************************/

CONSTANTS

%BEGIN Dialog, CreateParms, 18:55:22-23.11.1999, Code automatically updated!
  dlg_dialog_ResID = idd_dialog
  dlg_dialog_DlgType = wd_Modal
  dlg_dialog_Help = idh_contents
%END Dialog, CreateParms

PREDICATES

  dlg_dialog_eh : EHANDLER

CLAUSES

  dlg_dialog_Create(Parent):-
	win_CreateResDialog(Parent,dlg_dialog_DlgType,dlg_dialog_ResID,dlg_dialog_eh,0),!.

  dlg_dialog_eh(_Win,Event,0):-
	write("Dialog ( ",_Win," ) ",':',Event),nl,
	fail.
%BEGIN Dialog, idc_ok _CtlInfo
  dlg_dialog_eh(_Win,e_Control(idc_ok,_CtrlType,_CtrlWin,_CtrlInfo),0):-!,
	win_Destroy(_Win),
	!.
%END Dialog, idc_ok _CtlInfo
%MARK Dialog, new events

  dlg_dialog_eh(_,_,_):-!,fail.

%END_DLG Dialog
