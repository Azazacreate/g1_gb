/*****************************************************************************

		 Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  LISTBOX
 FileName: LISTBOX.PRO
 Purpose: ListBox handling
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments:
******************************************************************************/

include "listbox.inc"
include "listbox.con"
include "hlptopic.con"

PREDICATES
	select(WINDOW,integer,integer)
	select1(WINDOW,WINDOW,integer,integer)
	select2(WINDOW,integer)
	
CLAUSES
  select(_Win,Index,Index):-!,
  	lbox_Delete(_Win,Index),
  	W=win_GetParent(_Win),
  	EW=win_GetCtlHandle(W,idc_selected),
  	win_SetText(EW,""),
	W1=win_GetCtlHandle(W,idc_list_test_get_selected),
	W2=win_GetCtlHandle(W,idc_list_delete_selected),
	win_SetState(W1,[wsf_Disabled]),
	win_SetState(W2,[wsf_Disabled]),
	Items=lbox_CountAll(_Win),
	select2(W,Items).
  select(_Win,Index,_):-
  	lbox_Delete(_Win,Index),  		
  	W=win_GetParent(_Win),
	Items=lbox_CountAll(_Win),
	select2(W,Items).

  select1(_Win,LboxWin,Index,AllItems):-
	Index<AllItems,!,
	lbox_SetSel(LboxWin,Index,b_True),
	W1=win_GetCtlHandle(_Win,idc_list_test_get_selected),
	W2=win_GetCtlHandle(_Win,idc_list_delete_selected),
	win_SetState(W1,[wsf_Enabled]),
	win_SetState(W2,[wsf_Enabled]).
  select1(_,_,_,_):-
  	Title="",
  	dlg_Note(Title,"Invalid index of the selection.").

  select2(_Win,0):-!,
  	W=win_GetCtlHandle(_Win,idc_list_test_delete_last),
	W1=win_GetCtlHandle(_Win,idc_list_test_delete_all),
  	win_SetState(W,[wsf_Disabled]),
	win_SetState(W1,[wsf_Disabled]),
	W3=win_GetCtlHandle(_Win,idc_list_test_get_selected),
	W4=win_GetCtlHandle(_Win,idc_list_delete_selected),
	win_SetState(W3,[wsf_Disabled]),
	win_SetState(W4,[wsf_Disabled]),
	EDC=win_GetCtlHandle(_Win,idc_selected),
	win_SetText(EDC,"").

  select2(_,_).  	

%BEGIN_WIN Task Window
/***************************************************************************
	Event handling for Task Window
***************************************************************************/

PREDICATES

  task_win_eh : EHANDLER

CONSTANTS

%BEGIN Task Window, CreateParms, 20:09:02-23.11.1999, Code automatically updated!
  task_win_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Close,wsf_Maximize,wsf_Minimize,wsf_ClipSiblings]
  task_win_Menu  = res_menu(idr_task_menu)
  task_win_Title = "Listbox"
  task_win_Help  = idh_contents
%END Task Window, CreateParms

CLAUSES

%BEGIN Task Window, e_Create
  task_win_eh(_Win,e_Create(_),0):-!,
%BEGIN Task Window, InitControls, 20:09:02-23.11.1999, Code automatically updated!
%END Task Window, InitControls
%BEGIN Task Window, ToolbarCreate, 20:09:02-23.11.1999, Code automatically updated!
%END Task Window, ToolbarCreate
IFDEF use_message
	msg_Create(100),
ENDDEF
IFDEF os_os2
	menu_Enable(_Win,id_Listbox_multiple_collumn,b_false),
ENDDEF	
	!.
%END Task Window, e_Create

%MARK Task Window, new events

%BEGIN Task Window, id_ListBox_multiple_collumn
  task_win_eh(_Win,e_Menu(id_ListBox_multiple_collumn,_ShiftCtlAlt),0):-!,
	win_multicol_Create(_Win),
	!.
%END Task Window, id_ListBox_multiple_collumn

%BEGIN Task Window, id_ListBox_multiple_selection
  task_win_eh(_Win,e_Menu(id_ListBox_multiple_selection,_ShiftCtlAlt),0):-!,
	dlg_multi_selection_Create(_Win),
	!.
%END Task Window, id_ListBox_multiple_selection

%BEGIN Task Window, id_ListBox_single_selection
  task_win_eh(_Win,e_Menu(id_ListBox_single_selection,_ShiftCtlAlt),0):-!,
	dlg_list_test_Create(_Win),
	!.
%END Task Window, id_ListBox_single_selection

%BEGIN Task Window, e_Update
  task_win_eh(_Win,e_Update(_UpdateRct),0):-!,
  	win_Clear(_Win,color_White),
	!.
%END Task Window, e_Update

%BEGIN Task Window, id_help_contents
  task_win_eh(_Win,e_Menu(id_help_contents,_ShiftCtlAlt),0):-!,
  	vpi_ShowHelp("listbox.hlp"),
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
  	vpi_ShowHelpContext("listbox.hlp",HelpTopic),!.

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
  vpi_Init(task_win_Flags,task_win_eh,task_win_Menu,"listbox",task_win_Title).

%BEGIN_DLG About dialog
/**************************************************************************
	Creation and event handling for dialog: About dialog
**************************************************************************/

CONSTANTS

%BEGIN About dialog, CreateParms, 23:22:44-10.1.2000, Code automatically updated!
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

%BEGIN_WIN multicol
/**************************************************************************
        Creation and event handling for window: multicol
**************************************************************************/

CONSTANTS
%BEGIN multicol, CreateParms, 20:09:00-23.11.1999, Code automatically updated!
  win_multicol_WinType = w_TopLevel
  win_multicol_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Close,wsf_Maximize,wsf_Minimize,wsf_ClipSiblings,wsf_ClipChildren]
  win_multicol_RCT = rct(5,27,470,276)
  win_multicol_Menu = no_menu
  win_multicol_Title = "Multicol"
  win_multicol_Help = idh_contents
%END multicol, CreateParms

PREDICATES

  win_multicol_eh : EHANDLER

CLAUSES

  win_multicol_Create(Parent):-
	win_Create(win_multicol_WinType,win_multicol_RCT,win_multicol_Title,
		   win_multicol_Menu,Parent,win_multicol_Flags,win_multicol_eh,0).

%BEGIN multicol, e_Create
  win_multicol_eh(_Win,e_Create(_),0):-!,
%BEGIN multicol, InitControls, 20:09:00-23.11.1999, Code automatically updated!
	win_CreateControl(wc_LBox,rct(10,17,461,144),"",_Win,[wsf_MultiColumn,wsf_UseTabStops,wsf_HScroll,wsf_VScroll,wsf_TabStop,wsf_MultiSelect,wsf_ExtendedSel,wsf_WantKeyboardInput],idc_list),
%END multicol, InitControls
%BEGIN multicol, ToolbarCreate, 20:09:00-23.11.1999, Code automatically updated!
%END multicol, ToolbarCreate
ifndef os_os2
	win_CreateControl(wc_LBox,rct(10,17,461,144),"",_Win,[wsf_ClipSiblings,wsf_MultiColumn,wsf_UseTabStops,wsf_HScroll,wsf_VScroll,wsf_TabStop,wsf_MultiSelect,wsf_ExtendedSel,wsf_WantKeyboardInput],idc_list),
	LBW =win_GetCtlHandle(_Win, idc_list),
	RCT=win_GetClientRect(LBW),
	RCT=rct(L,_,R,_),
	WIDTH=(R-L) div 2,
	lbox_SetColumnWidth(LBW,WIDTH),
	Tabstop1=WIDTH div 8,
	Tabstop2=Tabstop1*2,
	Tabstop3=Tabstop1*3,
	Tabstop4=Tabstop1*4,
	Tabstop5=Tabstop1*5,
	Tabstop6=Tabstop1*6,
	Tabstop7=Tabstop1*7,
	Tabstop8=Tabstop1*8,
	lbox_SetTabStops(LBW,   [
					Tabstop1,Tabstop2,Tabstop3,Tabstop4,
					Tabstop5,Tabstop6,Tabstop7,Tabstop8
					]),
	lbox_Add(LBW,-1,"A\tB\tC\tD"),
	lbox_Add(LBW,-1,"E\tF\tG\tH"),
	lbox_Add(LBW,-1,"I\tJ\tK\tL"),
	lbox_Add(LBW,-1,"M\tN\tO\tP"),
	lbox_Add(LBW,-1,"Q\tR\tS\tT"),
	lbox_Add(LBW,-1,"U\tV\tW\tX"),
	lbox_Add(LBW,-1,"Y\tZ\ta\tb"),
	lbox_Add(LBW,-1,"c\td\te\tf"),
	lbox_Add(LBW,-1,"j\th\ti\tj"),
	lbox_Add(LBW,-1,"k\tl\tm\tn"),
	lbox_Add(LBW,-1,"o\tp\tq\tr"),
	lbox_Add(LBW,-1,"s\tt\tu\tv"),
	lbox_Add(LBW,-1,"w\tx\ty\tz"),
	lbox_Add(LBW,-1,"1\t2\t3\t4"),
	lbox_Add(LBW,-1,"5\t6\t7\t8"),
	lbox_Add(LBW,-1,"9\t10\t11\t12"),
	lbox_Add(LBW,-1,"13\t14\t15\t16"),
	lbox_Add(LBW,-1,"17\t18\t19\t20"),
	lbox_Add(LBW,-1,"21\t22\t23\t24"),
	lbox_Add(LBW,-1,"25\t26\t27\t28"),
	lbox_Add(LBW,-1,"29\t30\t31\t32"),
	lbox_Add(LBW,-1,"one\ttwo\tthree\tfour"),
enddef
	!.
%END multicol, e_Create
%MARK multicol, new events

%BEGIN multicol, e_Update
  win_multicol_eh(_Win,e_Update(_UpdateRct),0):-!,
  	win_Clear(_Win,color_White),
	!.
%END multicol, e_Update

%BEGIN multicol, e_Size
  win_multicol_eh(_Win,e_Size(_Width,_Height),0):-!,
IFDEF use_tbar
	toolbar_Resize(_Win),
ENDDEF
	LBOXWIN = win_GetCtlHandle(_Win,idc_list),
	win_Move(LBOXWIN,rct(0,0,_Width,_Height)),
	!.
%END multicol, e_Size

%BEGIN multicol, e_Menu, Parent window 
  win_multicol_eh(Win,e_Menu(ID,CAS),0):-!,
	PARENT = win_GetParent(Win),
	win_SendEvent(PARENT,e_Menu(ID,CAS)),
	!.
%END multicol, e_Menu, Parent window

%END_WIN multicol


%BEGIN_DLG List Test
/**************************************************************************
	Creation and event handling for dialog: List Test
**************************************************************************/

CONSTANTS

%BEGIN List Test, CreateParms, 20:08:44-23.11.1999, Code automatically updated!
  dlg_list_test_ResID = idd_list_test
  dlg_list_test_DlgType = wd_Modal
  dlg_list_test_Help = idh_contents
%END List Test, CreateParms

PREDICATES

  dlg_list_test_eh : EHANDLER

CLAUSES

  dlg_list_test_Create(Parent):-
	win_CreateResDialog(Parent,dlg_list_test_DlgType,dlg_list_test_ResID,dlg_list_test_eh,0),!.

%MARK List Test, new events

%BEGIN List Test, idc_select _CtlInfo
  dlg_list_test_eh(_Win,e_Control(idc_select,_CtrlType,_CtrlWin,_CtlInfo),0):-
	LboxWin = win_GetCtlHandle(_Win,idc_list_test_list_box),
	EDC = win_GetCtlHandle(_Win,idc_selected),
	String = win_GetText(EDC),
	String<>"",!,
	str_int(String,Index),
	AllItems=lbox_CountAll(LboxWin),
	select1(_Win,LboxWin,Index,AllItems),
	!.
  dlg_list_test_eh(_Win,e_Control(idc_select,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	Title="Error",
	dlg_Note(Title,"String is empty."),
	!.
%END List Test, idc_select _CtlInfo

%BEGIN List Test, idc_get_all _CtlInfo
  dlg_list_test_eh(_Win,e_Control(idc_get_all,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	LBOXWIN = win_GetCtlHandle(_Win,idc_list_test_list_box),
	SLIST = lbox_GetAll(LBOXWIN),
	term_str(slist,SLIST,String),
	dlg_Note(String),
	!.
%END List Test, idc_get_all _CtlInfo

%BEGIN List Test, idc_add_before_selection _CtlInfo
  dlg_list_test_eh(_Win,e_Control(idc_add_before_selection,_CtrlType,_CtrlWin,_CtlInfo),0):-
	LBOXWIN = win_GetCtlHandle(_Win,idc_list_test_list_box),
	Index = lbox_GetSelIndex(LBOXWIN),!,
	E_WINDOW = win_GetCtlHandle(_Win,idc_list_test_edit_control),
	EDIT_STRING = win_GetText(E_WINDOW),
	lbox_Add(LBOXWIN,Index,EDIT_STRING),
	W=win_GetCtlHandle(_Win,idc_selected),
	Str=win_GetText(W),
	str_int(Str,N),
	N1=N+1,
	str_int(Str1,N1),
	win_SetText(W,Str1),
	W1=win_GetCtlHandle(_Win,idc_list_test_delete_last),
	win_SetState(W1,[wsf_Enabled]),
	W2=win_GetCtlHandle(_Win,idc_list_test_delete_all),
	win_SetState(W2,[wsf_Enabled]),
	!.
  dlg_list_test_eh(_Win,e_Control(idc_add_before_selection,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	Title="",
	dlg_Note(Title,"Item not selected."),
	!.
%END List Test, idc_add_before_selection _CtlInfo

%BEGIN List Test, idc_list_delete_selected _CtlInfo
  dlg_list_test_eh(_Win,e_Control(idc_list_delete_selected,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	LBOXWIN = win_GetCtlHandle(_Win,idc_list_test_list_box),
	Index = lbox_GetSelIndex(LBOXWIN),
	lbox_Delete(LBOXWIN,Index),
	lbox_SetSel(LBOXWIN,0,b_true),
	W=win_GetCtlHandle(_Win,idc_selected),
	win_SetText(W,"0"),
	Items=lbox_CountAll(LBOXWIN),
	select2(_Win,Items),
	!.
%END List Test, idc_list_delete_selected _CtlInfo

%BEGIN List Test, idc_list_test_get_selected _CtlInfo
  dlg_list_test_eh(_Win,e_Control(idc_list_test_get_selected,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	LBOXWIN = win_GetCtlHandle(_Win,idc_list_test_list_box),
	Index = lbox_GetSelIndex(LBOXWIN),
	Item  = lbox_GetItem(LBOXWIN,Index),
	format(Msg,"You Chose: %",Item),
	dlg_note(Msg),
	!.
%END List Test, idc_list_test_get_selected _CtlInfo

%BEGIN List Test, idc_list_test_delete_last _CtlInfo
  dlg_list_test_eh(_Win,e_Control(idc_list_test_delete_last,_WINTYPE,_WINDOW,_CtlInfo),0):-
	LBOXWIN = win_GetCtlHandle(_Win,idc_list_test_list_box),
	LastItem = lbox_CountAll(LBOXWIN),
	SelIndex=lbox_GetSelIndex(LBOXWIN),!,
	Index = LastItem - 1,
	select(LBOXWIN,Index,SelIndex),
	!.
  dlg_list_test_eh(_Win,e_Control(idc_list_test_delete_last,_WINTYPE,_WINDOW,_CtlInfo),0):-!,
	LBOXWIN = win_GetCtlHandle(_Win,idc_list_test_list_box),
	LastItem = lbox_CountAll(LBOXWIN),
	Index = LastItem - 1,
	lbox_Delete(LBOXWIN,Index),
	Items=lbox_CountAll(LboxWin),
	select2(_Win,Items),
	!.
%END List Test, idc_list_test_delete_last _CtlInfo

%BEGIN List Test, idc_list_test_delete_all _CtlInfo
  dlg_list_test_eh(_Win,e_Control(idc_list_test_delete_all,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	LBOXWIN = win_GetCtlHandle(_Win,idc_list_test_list_box),
	lbox_Clear(LBOXWIN),
	W=win_GetCtlHandle(_Win,idc_selected),
	W1=win_GetCtlHandle(_Win,idc_list_test_get_selected),
	W2=win_GetCtlHandle(_Win,idc_list_delete_selected),
	W3=win_GetCtlHandle(_Win,idc_list_test_delete_last),
	W4=win_GetCtlHandle(_Win,idc_list_test_delete_all),
	win_SetText(W,""),	
	win_SetState(W1,[wsf_Disabled]),
	win_SetState(W2,[wsf_Disabled]),
	win_SetState(W3,[wsf_Disabled]),
	win_SetState(W4,[wsf_Disabled]),
	!.
%END List Test, idc_list_test_delete_all _CtlInfo

%BEGIN List Test, idc_list_test_add_button _CtlInfo
  dlg_list_test_eh(_Win,e_Control(idc_list_test_add_button,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	LBOXWIN = win_GetCtlHandle(_Win,idc_list_test_list_box),
	E_WINDOW = win_GetCtlHandle(_Win,idc_list_test_edit_control),
	EDIT_STRING= win_GetText(E_WINDOW),
	Nr = 1 + lbox_CountAll(LBOXWIN),
	format(EDIT_STRING1,"% - %",EDIT_STRING,NR),
	lbox_Add(LBOXWIN,-1,EDIT_STRING1),
	W1=win_GetCtlHandle(_Win,idc_list_test_delete_last),
	win_SetState(W1,[wsf_Enabled]),
	W2=win_GetCtlHandle(_Win,idc_list_test_delete_all),
	win_SetState(W2,[wsf_Enabled]),
	!.
%END List Test, idc_list_test_add_button _CtlInfo

%BEGIN List Test, idc_close _CtlInfo
  dlg_list_test_eh(_Win,e_Control(idc_close,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	win_Destroy(_Win),
	!.
%END List Test, idc_close _CtlInfo

%BEGIN List Test, idc_list_test_list_box selchanged
  dlg_list_test_eh(_Win,e_Control(idc_list_test_list_box,_CtrlType,_CtrlWin,selchanged),0):-!,
	LBOXWIN = win_GetCtlHandle(_Win,idc_list_test_list_box),
	Index = lbox_GetSelIndex(LBOXWIN),
	EDC = win_GetCtlHandle(_Win,idc_selected),
	str_int(String,Index),
	win_SetText(EDC,String),
	W1=win_GetCtlHandle(_Win,idc_list_test_get_selected),
	W2=win_GetCtlHandle(_Win,idc_list_delete_selected),
	win_SetState(W1,[wsf_Enabled]),
	win_SetState(W2,[wsf_Enabled]),
	!.
%END List Test, idc_list_test_list_box selchanged

%BEGIN List Test, idc_list_test_list_box activated
  dlg_list_test_eh(_Win,e_Control(idc_list_test_list_box,_CtrlType,_CtrlWin,activated),0):-!,
	dlg_note("Double Clicked in Listbox"),
	!.
%END List Test, idc_list_test_list_box activated

%BEGIN List Test, e_Create
  dlg_list_test_eh(_Win,e_Create(_CreationData),0):-!,
	LBOXWIN = win_GetCtlHandle(_Win,idc_list_test_list_box),
	W1=win_GetCtlHandle(_Win,idc_list_test_get_selected),
	W2=win_GetCtlHandle(_Win,idc_list_delete_selected),
	lbox_Add(LBOXWIN,-1,[first,second,third]),
	win_SetState(W1,[wsf_Disabled]),
	win_SetState(W2,[wsf_Disabled]),
	!.
%END List Test, e_Create

  dlg_list_test_eh(_,_,_):-!,fail.

%END_DLG List Test


%BEGIN_DLG Multi Selection
/**************************************************************************
	Creation and event handling for dialog: Multi Selection
**************************************************************************/

CONSTANTS

%BEGIN Multi Selection, CreateParms, 20:08:54-23.11.1999, Code automatically updated!
  dlg_multi_selection_ResID = idd_multi_selection
  dlg_multi_selection_DlgType = wd_Modal
  dlg_multi_selection_Help = idh_contents
%END Multi Selection, CreateParms

PREDICATES

  dlg_multi_selection_eh : EHANDLER

CLAUSES

  dlg_multi_selection_Create(Parent):-
	win_CreateResDialog(Parent,dlg_multi_selection_DlgType,dlg_multi_selection_ResID,dlg_multi_selection_eh,0),!.

%BEGIN Multi Selection, idc_ok _CtlInfo
  dlg_multi_selection_eh(_Win,e_Control(idc_ok,_CtrlType,_CtrlWin,_CtrlInfo),0):-!,
	win_Destroy(_Win),
	!.
%END Multi Selection, idc_ok _CtlInfo
%MARK Multi Selection, new events

%BEGIN Multi Selection, idc_get_selected _CtlInfo
  dlg_multi_selection_eh(_Win,e_Control(idc_get_selected,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	LBOXWIN = win_GetCtlHandle(_Win,idc_list),
	lbox_GetSel(LBOXWIN,SLIST,_ILIST),
	term_str(slist,SLIST,String),
	dlg_Note(String),
	!.
%END Multi Selection, idc_get_selected _CtlInfo

%BEGIN Multi Selection, e_Create
  dlg_multi_selection_eh(_Win,e_Create(_CreationData),0):-!,
	LBOXWIN = win_GetCtlHandle(_Win,idc_list),
	lbox_Add(LBOXWIN,[first,second,third,four,five,six]),
	!.
%END Multi Selection, e_Create

  dlg_multi_selection_eh(_,_,_):-!,fail.

%END_DLG Multi Selection
































