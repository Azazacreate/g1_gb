/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  WINCTRLS
 FileName: WINCTRLS.PRO
 Purpose: No description
 Written by: Visual Prolog
 Comments:
******************************************************************************/

include "winctrls.inc"
include "winctrls.con"
include "hlptopic.con"
include "tools\\winctrls\\winctrls.pre"
include "mycode.pro"

%BEGIN_WIN Task Window
/***************************************************************************
	Event handling for Task Window
***************************************************************************/
PREDICATES
  task_win_eh : EHANDLER
CONSTANTS

%BEGIN Task Window, CreateParms, 14:38:12-24.11.1999, Code automatically updated!
  task_win_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Close,wsf_Maximize,wsf_Minimize,wsf_ClipSiblings]
  task_win_Menu  = res_menu(idr_task_menu)
  task_win_Title = "WinCtrls"
  task_win_Help  = idh_contents
%END Task Window, CreateParms

CLAUSES
%BEGIN Task Window, e_Create
  task_win_eh(_Win,e_Create(_),0):-!,
%BEGIN Task Window, InitControls, 14:38:12-24.11.1999, Code automatically updated!
%END Task Window, InitControls
%BEGIN Task Window, ToolbarCreate, 14:38:12-24.11.1999, Code automatically updated!
	tb_project_toolbar_Create(_Win),
	tb_help_line_Create(_Win),
%END Task Window, ToolbarCreate
IFDEF use_message
	msg_Create(100),
ENDDEF
	class_Create("treeview",treeview_eh),
	class_Create("listview",listview_eh),
	class_Create("tabctrl",tabctrl_eh),
	class_Create("updown",updown_eh),
	class_Create("treebut",treebut_eh),
	!.
%END Task Window, e_Create

%MARK Task Window, new events

%BEGIN Task Window, id_file_New_tab_control
  task_win_eh(Win,e_Menu(id_file_New_tab_control,_ShiftCtlAlt),0):-!,
	dlg_tab_control_Create(Win),
	!.
%END Task Window, id_file_New_tab_control


%BEGIN Task Window, id_file_New_list_view
  task_win_eh(Win,e_Menu(id_file_New_list_view,_ShiftCtlAlt),0):-!,
	win_list_view_Create(Win),
	!.
%END Task Window, id_file_New_list_view

%BEGIN Task Window, e_Destroy
  task_win_eh(_Win,e_Destroy,0):-!,
	class_Destroy("treeview"),
	class_Destroy("listview"),
	class_Destroy("tabctrl"),
	class_Destroy("updown"),
	class_Destroy("treebut"),
	!.
%END Task Window, e_Destroy

%BEGIN Task Window, id_file_New_tree_view
  task_win_eh(Win,e_Menu(id_file_New_tree_view,_ShiftCtlAlt),0):-!,
	win_tree_view_Create(Win),
	!.
%END Task Window, id_file_New_tree_view

%BEGIN Task Window, id_help_contents
  task_win_eh(_Win,e_Menu(id_help_contents,_ShiftCtlAlt),0):-!,
  	vpi_ShowHelp("winctrls.hlp"),
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
  	vpi_ShowHelpContext("winctrls.hlp",HelpTopic).

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
  vpi_Init(task_win_Flags,task_win_eh,task_win_Menu,"winctrls",task_win_Title).

%BEGIN_TLB Project toolbar, 12:09:56-10.12.1999, Code automatically updated!
/**************************************************************************
	Creation of toolbar: Project toolbar
**************************************************************************/

clauses

  tb_project_toolbar_Create(_Parent):-
ifdef use_tbar
	toolbar_create(tb_top,0xC0C0C0,_Parent,
		[tb_ctrl(id_file_new,pushb,idb_new_up,idb_new_dn,idb_new_up,"New;New file",1,1),
		 tb_ctrl(id_file_open,pushb,idb_open_up,idb_open_dn,idb_open_up,"Open;Open file",1,1),
		 tb_ctrl(id_file_save,pushb,idb_save_up,idb_save_dn,idb_save_up,"Save;File save",1,1),
		 separator,
		 tb_ctrl(id_edit_undo,pushb,idb_undo_up,idb_undo_dn,idb_undo_up,"Undo;Undo",1,1),
		 tb_ctrl(id_edit_redo,pushb,idb_redo_up,idb_redo_dn,idb_redo_up,"Redo;Redo",1,1),
		 separator,
		 tb_ctrl(id_edit_cut,pushb,idb_cut_up,idb_cut_dn,idb_cut_up,"Cut;Cut to clipboard",1,1),
		 tb_ctrl(id_edit_copy,pushb,idb_copy_up,idb_copy_dn,idb_copy_up,"Copy;Copy to clipboard",1,1),
		 tb_ctrl(id_edit_paste,pushb,idb_paste_up,idb_paste_dn,idb_paste_up,"Paste;Paste from clipboard",1,1),
		 separator,
		 separator,
		 tb_ctrl(id_help_contents,pushb,idb_help_up,idb_help_down,idb_help_up,"Help;Help",0,1)]),
enddef
	true.
%END_TLB Project toolbar


%BEGIN_TLB Help line, 14:38:30-24.11.1999, Code automatically updated!
/**************************************************************************
	Creation of toolbar: Help line
**************************************************************************/

clauses

  tb_help_line_Create(_Parent):-
ifdef use_tbar
	toolbar_create(tb_bottom,0xC0C0C0,_Parent,
		[tb_text(idt_help_line,tb_context,452,0,4,10,0x0,"")]),
enddef
	true.
%END_TLB Help line


%BEGIN_DLG About dialog
/**************************************************************************
	Creation and event handling for dialog: About dialog
**************************************************************************/

CONSTANTS

%BEGIN About dialog, CreateParms, 13:42:42-8.10.1997, Code automatically updated!
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

%BEGIN_WIN Tree View
/**************************************************************************
        Creation and event handling for window: Tree View
**************************************************************************/

CONSTANTS
%BEGIN Tree View, CreateParms, 14:38:10-24.11.1999, Code automatically updated!
  win_tree_view_WinType = w_TopLevel
  win_tree_view_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Close,wsf_ClipSiblings]
  win_tree_view_RCT = rct(100,80,440,460)
  win_tree_view_Menu = res_menu(idr_tree_view)
  win_tree_view_Title = "Tree View"
  win_tree_view_Help = idh_contents
%END Tree View, CreateParms

PREDICATES
  determ check_already_exist1(WINDOW TVWin,UNSIGNED ItemId)
CLAUSES
  check_already_exist1(LVWin,ItemId):-
	trap(tv_get_item(LVWin,ItemId,_,_,_),_,fail),
	!,fail.
  check_already_exist1(_,_).

PREDICATES

  win_tree_view_eh : EHANDLER
CLAUSES

  win_tree_view_Create(_Parent):-
	win_Create(win_tree_view_WinType,win_tree_view_RCT,win_tree_view_Title,
		   win_tree_view_Menu,_Parent,win_tree_view_Flags,win_tree_view_eh,0).
predicates
  select_item(WINDOW TVWin,UNSIGNED ItemId)
clauses
  select_item(TVWin,ItemId):-
	ItemId <> wcc_null,
	not(check_already_exist1(TVWin,ItemId)),
	tv_select(TVWin,ItemId,b_true),!.
  select_item(_,ItemId):-
	ItemId <> wcc_null,
	dlg_error("ItemId isn't exist and can't be selected"),!.
  select_item(_,_).


%BEGIN Tree View, e_Create
  win_tree_view_eh(Win,e_Create(_),0):-!,
%BEGIN Tree View, InitControls, 14:38:10-24.11.1999, Code automatically updated!
%END Tree View, InitControls
	CtrlWin=win_CreateDynControl([customctl(wdef(wc_Custom,rct(10,13,332,364),"TreeView",u_Pixels),"treeview",idc_treeview,[wsf_Group,wsf_TabStop])],Win),
%BEGIN Tree View, ToolbarCreate, 14:38:10-24.11.1999, Code automatically updated!
%END Tree View, ToolbarCreate
	assert(parent_child(Win,CtrlWin)),
	!.
%END Tree View, e_Create
%MARK Tree View, new events

%BEGIN Tree View, id_Actions_edit_item_end
  win_tree_view_eh(Win,e_Menu(id_Actions_edit_item_end,_ShiftCtlAlt),0):-!,
	parent_child(Win,TVWin),
	tv_edit_end(TVWin),
	!.
%END Tree View, id_Actions_edit_item_end

%BEGIN Tree View, id_Actions_edit_item_begin
  win_tree_view_eh(Win,e_Menu(id_Actions_edit_item_begin,_ShiftCtlAlt),0):-!,
	parent_child(Win,TVWin),
	tv_get_sel(TVWin,ItemId),
	ItemId <> wcc_null,
	tv_edit_begin(TVWin,ItemId),
	!.
%END Tree View, id_Actions_edit_item_begin

%BEGIN Tree View, id_Actions_delete_item
  win_tree_view_eh(Win,e_Menu(id_Actions_delete_item,_ShiftCtlAlt),0):-!,
	parent_child(Win,TVWin),
	tv_get_sel(TVWin,ItemId),
	ItemId <> wcc_null,
	tv_delete_item(TVWin,ItemId),
	!.
%END Tree View, id_Actions_delete_item

%BEGIN Tree View, id_Actions_insert_item_right
  win_tree_view_eh(Win,e_Menu(id_Actions_insert_item_right,_ShiftCtlAlt),0):-
	parent_child(Win,TVWin),
	tv_get_sel(TVWin,ParentId),
	ParentId <> wcc_null,
	dlg_insert_item_Create(Win,ItemId,Text,StateList,BitmapId),
	check_already_exist1(TVWin,ItemId),!,
	BitmapId <> wcc_null,
	tv_insert_item(TVWin,ItemId,ParentId,wcc_null,Text,StateList,BitmapId),
	!.
  win_tree_view_eh(_Win,e_Menu(id_Actions_insert_item_right,_ShiftCtlAlt),0):-
	dlg_error("ItemId is already exist and can't be duplicated"),!.
%END Tree View, id_Actions_insert_item_right

%BEGIN Tree View, id_Actions_insert_item
  win_tree_view_eh(Win,e_Menu(id_Actions_insert_item,_ShiftCtlAlt),0):-
	parent_child(Win,TVWin),
	tv_get_sel(TVWin,PreviosId),
	PreviosId <> wcc_null,
	tv_get_parent(TVWin,PreviosId,ParentId),
	dlg_insert_item_Create(Win,ItemId,Text,StateList,BitmapId),
	check_already_exist1(TVWin,ItemId),!,
	BitmapId <> wcc_null,
	tv_insert_item(TVWin,ItemId,ParentId,PreviosId,Text,StateList,BitmapId),
	!.
  win_tree_view_eh(_Win,e_Menu(id_Actions_insert_item,_ShiftCtlAlt),0):-
	dlg_error("ItemId is already exist and can't be duplicated"),
	!.
%END Tree View, id_Actions_insert_item

%BEGIN Tree View, id_Actions_set_item_status
  win_tree_view_eh(Win,e_Menu(id_Actions_set_item_status,_ShiftCtlAlt),0):-!,
	parent_child(Win,TVWin),
	tv_get_sel(TVWin,ItemId),
	ItemId <> wcc_null,
	dlg_set_item_status_Create(Win,Text,StateList,BitmapId),
	BitmapId <> wcc_null,
	tv_set_item(TVWin,ItemId,Text,StateList,BitmapId),
	!.
%END Tree View, id_Actions_set_item_status

%BEGIN Tree View, id_Actions_visible
  win_tree_view_eh(Win,e_Menu(id_Actions_visible,_ShiftCtlAlt),0):-!,
	parent_child(Win,TVWin),
	win_SetState(TVWin,[wsf_Visible]),
	!.
%END Tree View, id_Actions_visible

%BEGIN Tree View, id_Actions_invisible
  win_tree_view_eh(Win,e_Menu(id_Actions_invisible,_ShiftCtlAlt),0):-!,
	parent_child(Win,TVWin),
	win_SetState(TVWin,[wsf_Invisible]),
	!.
%END Tree View, id_Actions_invisible

%BEGIN Tree View, id_Actions_enable
  win_tree_view_eh(Win,e_Menu(id_Actions_enable,_ShiftCtlAlt),0):-!,
	parent_child(Win,TVWin),
	win_SetState(TVWin,[wsf_Enabled]),
	!.
%END Tree View, id_Actions_enable

%BEGIN Tree View, id_Actions_disable
  win_tree_view_eh(Win,e_Menu(id_Actions_disable,_ShiftCtlAlt),0):-!,
	parent_child(Win,TVWin),
	win_SetState(TVWin,[wsf_Disabled]),
	!.
%END Tree View, id_Actions_disable

%BEGIN Tree View, id_Actions_set_font
  win_tree_view_eh(Win,e_Menu(id_Actions_set_font,_ShiftCtlAlt),0):-!,
	parent_child(Win,TVWin),
	OldFont = win_GetFont(TVWin),
	NewFont = dlg_ChooseFont(OldFont,_,_),
	win_SetFont(TVWin,NewFont),
	!.
%END Tree View, id_Actions_set_font

%BEGIN Tree View, e_Update
  win_tree_view_eh(Win,e_Update(_UpdateRct),0):-!,
	win_Clear(Win,color_LtGray),
	!.
%END Tree View, e_Update

%BEGIN Tree View, e_EraseBackGround
  win_tree_view_eh(_Win,e_EraseBackGround,0):-!,
	!.
%END Tree View, e_EraseBackGround

%BEGIN Tree View, id_Actions_select
  win_tree_view_eh(Win,e_Menu(id_Actions_select,_ShiftCtlAlt),0):-
	parent_child(Win,TVWin),
	ItemId = dlg_get_item_id_Create(Win),
	select_item(TVWin,ItemId),!.
%END Tree View, id_Actions_select

%BEGIN Tree View, id_Actions_expand
  win_tree_view_eh(Win,e_Menu(id_Actions_expand,_ShiftCtlAlt),0):-
	parent_child(Win,TVWin),
	tv_get_sel(TVWin,ItemId),
	ItemId <> wcc_null,
	tv_expand(TVWin,ItemId),
	!.
%END Tree View, id_Actions_expand

%BEGIN Tree View, id_Actions_get_item_status
  win_tree_view_eh(Win,e_Menu(id_Actions_get_item_status,_ShiftCtlAlt),0):-!,
	parent_child(Win,TVWin),
	tv_get_sel(TVWin,ItemId),
	ItemId <> wcc_null,
	tv_get_item(TVWin,ItemId,Text,StateList,BitmapId),
	write("Answer: ItemId=",ItemId,", Text=",Text,", State=["),
	write_state_list(1,StateList),
	write("], BitmapResid=",BitmapId,"\n"),
	!.
%END Tree View, id_Actions_get_item_status

%BEGIN Tree View, e_Destroy
  win_tree_view_eh(Win,e_Destroy,0):-!,
	retract(parent_child(Win,_)),
	!.
%END Tree View, e_Destroy

%BEGIN Tree View, id_Actions_get_item_selected
  win_tree_view_eh(Win,e_Menu(id_Actions_get_item_selected,_ShiftCtlAlt),0):-!,
	parent_child(Win,TVWin),
	tv_get_sel(TVWin,ItemId),
	write("Answer: ItemSelected=",ItemId,"\n"),
	!.
%END Tree View, id_Actions_get_item_selected


%BEGIN Tree View, e_Size
  win_tree_view_eh(Win,e_Size(Width0,Height0),0):-!,
IFDEF use_tbar
	toolbar_Resize(Win),
ENDDEF
	parent_child(Win,TVWin),
	Width = Width0 - 10,
	Height = Height0 - 10,
	win_Move(TVWin,rct(5,5,Width,Height)),
	!.
%END Tree View, e_Size

%BEGIN Tree View, e_Menu, Parent window 
  win_tree_view_eh(Win,e_Menu(ID,CAS),0):-!,
	PARENT = win_GetParent(Win),
	win_SendEvent(PARENT,e_Menu(ID,CAS)),
	!.
%END Tree View, e_Menu, Parent window

%END_WIN Tree View



%BEGIN_DLG Get Item Id
/**************************************************************************
	Creation and event handling for dialog: Get Item Id
**************************************************************************/

CONSTANTS

%BEGIN Get Item Id, CreateParms, 14:37:46-24.11.1999, Code automatically updated!
  dlg_get_item_id_ResID = idd_get_item_id
  dlg_get_item_id_DlgType = wd_Modal
  dlg_get_item_id_Help = idh_contents
%END Get Item Id, CreateParms

PREDICATES

  dlg_get_item_id_eh : EHANDLER
  INTEGER dlg_get_item_id_handle_answer(INTEGER EndButton,DIALOG_VAL_LIST)
  determ INTEGER dlg_get_item_id_update(DIALOG_VAL_LIST)

CLAUSES

  dlg_get_item_id_Create(Parent,ItemId):-

%MARK Get Item Id, new variables

	dialog_CreateModal(Parent,dlg_get_item_id_ResID,"",
  		[
%BEGIN Get Item Id, ControlList, 14:37:46-24.11.1999, Code automatically updated!
		df(idc_get_item_id_1,editint(void,[]),nopr)
%END Get Item Id, ControlList
		],
		dlg_get_item_id_eh,0,VALLIST,ANSWER),
		ANSWER=idc_ok,!,
	ItemId = dlg_get_item_id_handle_answer(ANSWER,VALLIST).
  dlg_get_item_id_Create(_,wcc_null).

  dlg_get_item_id_handle_answer(idc_ok,VALLIST,ItemId):-
	ItemId = dlg_get_item_id_update(VALLIST),!.
  dlg_get_item_id_handle_answer(idc_cancel,_,wcc_null):-!.  % Handle Esc and Cancel here
  dlg_get_item_id_handle_answer(_,_,wcc_null):-
	dlg_error("Bad Item Id").

  dlg_get_item_id_update(_VALLIST,ItemId):-
%BEGIN Get Item Id, Update controls, 14:37:46-24.11.1999, Code automatically updated!
	_IDC_GET_ITEM_ID_1_VALUE = dialog_VLGetint(idc_get_item_id_1,_VALLIST),
%END Get Item Id, Update controls
	_IDC_GET_ITEM_ID_1_VALUE = i(ItemId),
	true.

%MARK Get Item Id, new events

  dlg_get_item_id_eh(_,_,_):-!,fail.

%END_DLG Get Item Id

%BEGIN_DLG Set item status
/**************************************************************************
	Creation and event handling for dialog: Set item status
**************************************************************************/

CONSTANTS

%BEGIN Set item status, CreateParms, 16:02:50-13.3.2000, Code automatically updated!
  dlg_set_item_status_ResID = idd_set_item_status
  dlg_set_item_status_DlgType = wd_Modal
  dlg_set_item_status_Help = idh_contents
%END Set item status, CreateParms

PREDICATES

  dlg_set_item_status_eh : EHANDLER
  dlg_set_item_status_handle_answer(INTEGER EndButton,DIALOG_VAL_LIST,STRING Text,ILIST StateList,INTEGER BitmapId)
  dlg_set_item_status_update(DIALOG_VAL_LIST,STRING Text,ILIST StateList,INTEGER BitmapId)

CLAUSES

  dlg_set_item_status_Create(Parent,Text,StateList,BitmapId):-

	bitmap_list(BitmapList),
	dialog_CreateModal(Parent,dlg_set_item_status_ResID,"",
  		[
		df(idc_set_item_status_1,editstr("",[]),nopr),
		df(idc_tvis_selected,checkbox(b_false),nopr),
		df(idc_tvis_cut,checkbox(b_false),nopr),
		df(idc_tvis_drophilited,checkbox(b_false),nopr),
		df(idc_tvis_bold,checkbox(b_false),nopr),
		df(idc_tvis_expanded,checkbox(b_false),nopr),
		df(idc_set_item_status_2,listbutton(BitmapList,0),nopr)
		],
		dlg_set_item_status_eh,0,VALLIST,ANSWER),
	dlg_set_item_status_handle_answer(ANSWER,VALLIST,Text,StateList,BitmapId),!.

  dlg_set_item_status_handle_answer(idc_ok,VALLIST,Text,StateList,BitmapId):-!,
	dlg_set_item_status_update(VALLIST,Text,StateList,BitmapId).
  dlg_set_item_status_handle_answer(idc_cancel,_,"",[],wcc_null):-!.  % Handle Esc and Cancel here
  dlg_set_item_status_handle_answer(_,_,"",[],wcc_null):-
	errorexit().

  dlg_set_item_status_update(_VALLIST,Text,StateList,BitmapId):-
	Text = dialog_VLGetstr(idc_set_item_status_1,_VALLIST),
	Select = dialog_VLGetCheck(idc_tvis_selected,_VALLIST),
	Cut = dialog_VLGetCheck(idc_tvis_cut,_VALLIST),
	Drop = dialog_VLGetCheck(idc_tvis_drophilited,_VALLIST),
	Bold = dialog_VLGetCheck(idc_tvis_bold,_VALLIST),
	Expand = dialog_VLGetCheck(idc_tvis_expanded,_VALLIST),
	get_flags_list([Select,Cut,Drop,Bold,Expand],
		[tvis_selected,tvis_cut,tvis_drophilited,tvis_bold,tvis_expanded],[],StateList),
	dialog_VLGetListButton(idc_set_item_status_2,_VALLIST,BitmapText,_),
	get_bitmap_id(BitmapText,BitmapId),!.
  dlg_set_item_status_update(_,"",[],wcc_null).

%MARK Set item status, new events

  dlg_set_item_status_eh(_,_,_):-!,fail.

%END_DLG Set item status

%BEGIN_DLG Insert item
/**************************************************************************
	Creation and event handling for dialog: Insert item
**************************************************************************/

CONSTANTS

%BEGIN Insert item, CreateParms, 14:37:36-24.11.1999, Code automatically updated!
  dlg_insert_item_ResID = idd_insert_item
  dlg_insert_item_DlgType = wd_Modal
  dlg_insert_item_Help = idh_contents
%END Insert item, CreateParms

PREDICATES

  dlg_insert_item_eh : EHANDLER
  dlg_insert_item_handle_answer(INTEGER EndButton,DIALOG_VAL_LIST,INTEGER ItemId,STRING Text,ILIST StateList,INTEGER BitmapId)
  dlg_insert_item_update(DIALOG_VAL_LIST,INTEGER ItemId,STRING Text,ILIST StateList,INTEGER BitmapId)

CLAUSES

  dlg_insert_item_Create(Parent,ItemId,Text,StateList,BitmapId):-

	bitmap_list(BitmapList),
	dialog_CreateModal(Parent,dlg_insert_item_ResID,"",
  		[
		df(idc_get_item_id_1,editint(void,[]),nopr),
		df(idc_set_item_status_1,editstr("",[]),nopr),
		df(idc_tvis_selected,checkbox(b_false),nopr),
		df(idc_tvis_cut,checkbox(b_false),nopr),
		df(idc_tvis_drophilited,checkbox(b_false),nopr),
		df(idc_tvis_bold,checkbox(b_false),nopr),
		df(idc_tvis_expanded,checkbox(b_false),nopr),
		df(idc_set_item_status_2,listbutton(BitmapList,0),nopr)
		],
		dlg_insert_item_eh,0,VALLIST,ANSWER),
	dlg_insert_item_handle_answer(ANSWER,VALLIST,ItemId,Text,StateList,BitmapId),!.

  dlg_insert_item_handle_answer(idc_ok,VALLIST,ItemId,Text,StateList,BitmapId):-!,
	dlg_insert_item_update(VALLIST,ItemId,Text,StateList,BitmapId).
  dlg_insert_item_handle_answer(idc_cancel,_,wcc_null,"",[],wcc_null):-!.  % Handle Esc and Cancel here
  dlg_insert_item_handle_answer(_,_,wcc_null,"",[],wcc_null):-
	errorexit().

  dlg_insert_item_update(_VALLIST,ItemId,Text,StateList,BitmapId):-
	ItemIdI = dialog_VLGetint(idc_get_item_id_1,_VALLIST),
	ItemIdI = i(ItemId),
	Text = dialog_VLGetstr(idc_set_item_status_1,_VALLIST),
	Select = dialog_VLGetCheck(idc_tvis_selected,_VALLIST),
	Cut = dialog_VLGetCheck(idc_tvis_cut,_VALLIST),
	Drop = dialog_VLGetCheck(idc_tvis_drophilited,_VALLIST),
	Bold = dialog_VLGetCheck(idc_tvis_bold,_VALLIST),
	Expand = dialog_VLGetCheck(idc_tvis_expanded,_VALLIST),
	get_flags_list([Select,Cut,Drop,Bold,Expand],
		[tvis_selected,tvis_cut,tvis_drophilited,tvis_bold,tvis_expanded],[],StateList),
	dialog_VLGetListButton(idc_set_item_status_2,_VALLIST,BitmapText,_),
	get_bitmap_id(BitmapText,BitmapId),!.
  dlg_insert_item_update(_,wcc_null,"",[],wcc_null).

%MARK Insert item, new events

  dlg_insert_item_eh(_,_,_):-!,fail.

%END_DLG Insert item





%BEGIN_WIN List View
/**************************************************************************
        Creation and event handling for window: List View
**************************************************************************/

CONSTANTS
%BEGIN List View, CreateParms, 14:38:04-24.11.1999, Code automatically updated!
  win_list_view_WinType = w_TopLevel
  win_list_view_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Close,wsf_ClipSiblings]
  win_list_view_RCT = rct(100,80,440,460)
  win_list_view_Menu = res_menu(idr_list_view)
  win_list_view_Title = "List View"
  win_list_view_Help = idh_contents
%END List View, CreateParms

PREDICATES
  determ check_already_exist(WINDOW LVWin,UNSIGNED ItemId)
CLAUSES
  check_already_exist(LVWin,ItemId):-
	trap(lv_get_item(LVWin,ItemId,_),_,fail),
	dlg_error("ItemId is already exist and can't be duplicated"),
	!,fail.
  check_already_exist(_,_).

PREDICATES

  win_list_view_eh : EHANDLER

CLAUSES

  win_list_view_Create(_Parent):-
	win_Create(win_list_view_WinType,win_list_view_RCT,win_list_view_Title,
		   win_list_view_Menu,_Parent,win_list_view_Flags,win_list_view_eh,0).

%BEGIN List View, e_Create
  win_list_view_eh(Win,e_Create(_),0):-!,
%BEGIN List View, InitControls, 14:38:04-24.11.1999, Code automatically updated!
%END List View, InitControls
	CtrlWin=win_CreateDynControl([customctl(wdef(wc_Custom,rct(10,13,332,364),"ListView",u_Pixels),"listview",idc_listview,[wsf_Group,wsf_TabStop])],Win),
%BEGIN List View, ToolbarCreate, 14:38:04-24.11.1999, Code automatically updated!
%END List View, ToolbarCreate
	assert(parent_child(Win,CtrlWin)),
	!.
%END List View, e_Create
%MARK List View, new events

%BEGIN List View, id_Actions_set_color
  win_list_view_eh(Win,e_Menu(id_Actions_set_color,_ShiftCtlAlt),0):-!,
	parent_child(Win,LVWin),
	lv_set_color(LVWin,color_Black,color_Magenta),
	!.
%END List View, id_Actions_set_color

%BEGIN List View, id_Actions_get_color
  win_list_view_eh(Win,e_Menu(id_Actions_get_color,_ShiftCtlAlt),0):-!,
	parent_child(Win,LVWin),
	lv_get_color(LVWin,TextColor,TextBgColor),
	write("Answer: TextColor=",TextColor,", TextBgColor=",TextBgColor,"\n"),
	!.
%END List View, id_Actions_get_color

%BEGIN List View, id_Actions_set_column_status
  win_list_view_eh(Win,e_Menu(id_Actions_set_column_status,_ShiftCtlAlt),0):-!,
	parent_child(Win,LVWin),
	dlg_set_column_Create(Win,ColumnNum,Text,Width,Align),
	lv_set_column(LVWin,ColumnNum,column(Text,Width,Align)),
	!.
%END List View, id_Actions_set_column_status

%BEGIN List View, id_Actions_get_column_status
  win_list_view_eh(Win,e_Menu(id_Actions_get_column_status,_ShiftCtlAlt),0):-
	parent_child(Win,LVWin),
	dlg_get_column_number_Create(Win,ColumnNum),
	trap(lv_get_column(LVWin,ColumnNum,Column),_,fail),
	Column = column(Text,Width,Alignment),
	write("Answer: Text=",Text,", Width=",Width,", Alignment=",Alignment,"\n"),
	!.
  win_list_view_eh(_Win,e_Menu(id_Actions_get_column_status,_ShiftCtlAlt),0):-
	dlg_error("Wrong column number."),
	!.
%END List View, id_Actions_get_column_status

%BEGIN List View, id_Actions_delete_column
  win_list_view_eh(Win,e_Menu(id_Actions_delete_column,_ShiftCtlAlt),0):-!,
	parent_child(Win,LVWin),
	dlg_get_column_number_Create(Win,ColumnNum),
	lv_delete_column(LVWin,ColumnNum),
	!.
%END List View, id_Actions_delete_column

%BEGIN List View, id_Actions_insert_column
  win_list_view_eh(Win,e_Menu(id_Actions_insert_column,_ShiftCtlAlt),0):-!,
	parent_child(Win,LVWin),
	dlg_insert_column_Create(Win,ColumnNum,Text,Width,Align),
	lv_insert_column(LVWin,ColumnNum,column(Text,Width,Align)),
	!.
%END List View, id_Actions_insert_column

%BEGIN List View, id_Actions_set_item_status
  win_list_view_eh(Win,e_Menu(id_Actions_set_item_status,_ShiftCtlAlt),0):-!,
	parent_child(Win,LVWin),
	lv_get_focus(LVWin,ItemId),
	ItemId <> wcc_null,
	lv_get_item(LVWin,ItemId,Item),
	Item = item(_,OldText,OldLargeBitmapId,OldSmallBitmapId,OldFlags,OldSubItemText),
	dlg_set_item_Create(Win,OldText,OldFlags,OldLargeBitmapId,OldSmallBitmapId,OldSubItemText,
		Text,StateList,LargeBitmapId,SmallBitmapId,SubText),
	lv_set_item(LVWin,item(ItemId,Text,LargeBitmapId,SmallBitmapId,StateList,SubText)),
	!.
%END List View, id_Actions_set_item_status

%BEGIN List View, id_Actions_insert_item
  win_list_view_eh(Win,e_Menu(id_Actions_insert_item,_ShiftCtlAlt),0):-!,
	parent_child(Win,LVWin),
	dlg_insert_item1_Create(Win,ItemId,Text,StateList,LargeBitmapId,SmallBitmapId,SubText),
	check_already_exist(LVWin,ItemId),
	lv_insert_item(LVWin,item(ItemId,Text,LargeBitmapId,SmallBitmapId,StateList,SubText)),
	!.
%END List View, id_Actions_insert_item

%BEGIN List View, id_Actions_delete_item
  win_list_view_eh(Win,e_Menu(id_Actions_delete_item,_ShiftCtlAlt),0):-!,
	parent_child(Win,LVWin),
	lv_get_focus(LVWin,ItemId),
	ItemId <> wcc_null,
	lv_delete_item(LVWin,ItemId),
	!.
%END List View, id_Actions_delete_item

%BEGIN List View, id_Actions_sort
  win_list_view_eh(Win,e_Menu(id_Actions_sort,_ShiftCtlAlt),0):-!,
	dlg_sort_item_Create(Win,Order,ColumnNumber,HeaderRows,FooterRows),
	parent_child(Win,LVWin),
	lv_sort_items(LVWin,Order,ColumnNumber,HeaderRows,FooterRows),
	!.
%END List View, id_Actions_sort

%BEGIN List View, id_Actions_Style_sortdescending
  win_list_view_eh(Win,e_Menu(id_Actions_Style_sortdescending,_ShiftCtlAlt),0):-!,
	set_style(Win,id_Actions_Style_sortdescending),
	!.
%END List View, id_Actions_Style_sortdescending

%BEGIN List View, id_Actions_Style_sortascending
  win_list_view_eh(Win,e_Menu(id_Actions_Style_sortascending,_ShiftCtlAlt),0):-!,
	set_style(Win,id_Actions_Style_sortascending),
	!.
%END List View, id_Actions_Style_sortascending

%BEGIN List View, id_Actions_Style_singlesel
  win_list_view_eh(Win,e_Menu(id_Actions_Style_singlesel,_ShiftCtlAlt),0):-!,
	set_style(Win,id_Actions_Style_singlesel),
	!.
%END List View, id_Actions_Style_singlesel

%BEGIN List View, id_Actions_Style_showselalways
  win_list_view_eh(Win,e_Menu(id_Actions_Style_showselalways,_ShiftCtlAlt),0):-!,
	set_style(Win,id_Actions_Style_showselalways),
	!.
%END List View, id_Actions_Style_showselalways


%BEGIN List View, id_Actions_Style_noscroll
  win_list_view_eh(Win,e_Menu(id_Actions_Style_noscroll,_ShiftCtlAlt),0):-!,
	set_style(Win,id_Actions_Style_noscroll),
	!.
%END List View, id_Actions_Style_noscroll

%BEGIN List View, id_Actions_Style_nolabelwrap
  win_list_view_eh(Win,e_Menu(id_Actions_Style_nolabelwrap,_ShiftCtlAlt),0):-!,
	set_style(Win,id_Actions_Style_nolabelwrap),
	!.
%END List View, id_Actions_Style_nolabelwrap

%BEGIN List View, id_Actions_Style_editlabels
  win_list_view_eh(Win,e_Menu(id_Actions_Style_editlabels,_ShiftCtlAlt),0):-!,
	set_style(Win,id_Actions_Style_editlabels),
	!.
%END List View, id_Actions_Style_editlabels

%BEGIN List View, id_Actions_Style_autoarrange
  win_list_view_eh(Win,e_Menu(id_Actions_Style_autoarrange,_ShiftCtlAlt),0):-!,
	set_style(Win,id_Actions_Style_autoarrange),
	!.
%END List View, id_Actions_Style_autoarrange

%BEGIN List View, id_Actions_Style_aligntop
  win_list_view_eh(Win,e_Menu(id_Actions_Style_aligntop,_ShiftCtlAlt),0):-!,
	set_style(Win,id_Actions_Style_aligntop),
	!.
%END List View, id_Actions_Style_aligntop

%BEGIN List View, id_Actions_Style_alignleft
  win_list_view_eh(Win,e_Menu(id_Actions_Style_alignleft,_ShiftCtlAlt),0):-!,
	set_style(Win,id_Actions_Style_alignleft),
	!.
%END List View, id_Actions_Style_alignleft

%BEGIN List View, id_Actions_select
  win_list_view_eh(Win,e_Menu(id_Actions_select,_ShiftCtlAlt),0):-
	parent_child(Win,LVWin),
	ItemId = dlg_get_item_id_Create(Win),
	trap(lv_get_sel(LVWin,ItemIdList),_,fail),
	trap(lv_select(LVWin,ItemIdList,b_false),_,fail),
	trap(lv_select(LVWin,[ItemId],b_true),_,fail),
	!.
  win_list_view_eh(_Win,e_Menu(id_Actions_select,_ShiftCtlAlt),0):-!,
	dlg_error("Bad Item Id"),
	!.
%END List View, id_Actions_select

%BEGIN List View, id_Actions_get_item_selected
  win_list_view_eh(Win,e_Menu(id_Actions_get_item_selected,_ShiftCtlAlt),0):-!,
	parent_child(Win,LVWin),
	lv_get_sel(LVWin,ItemIdList),
	write("Answer: ItemSelected=",ItemIdList,"\n"),
	!.
%END List View, id_Actions_get_item_selected

%BEGIN List View, id_Actions_get_item_status
  win_list_view_eh(Win,e_Menu(id_Actions_get_item_status,_ShiftCtlAlt),0):-!,
	parent_child(Win,LVWin),
	lv_get_focus(LVWin,ItemId),
	ItemId <> wcc_null,
	lv_get_item(LVWin,ItemId,Item),
	Item = item(ItemId,Text,LargeBitmap,SmallBitmap,StateList,SubItemText),
	write("Answer: ItemId=",ItemId,", Text=",Text,", State=["),
	write_state_list(2,StateList),
	write("], LargeBitmapResid=",LargeBitmap,", SmallBitmapResid=",SmallBitmap,", SubItemText=",SubItemText,"\n"),
	!.
%END List View, id_Actions_get_item_status

%BEGIN List View, id_Actions_View_details
  win_list_view_eh(Win,e_Menu(id_Actions_View_details,_ShiftCtlAlt),0):-!,
	parent_child(Win,LVWin),
	lv_set_type(LVWIN,lvs_report),
	!.
%END List View, id_Actions_View_details

%BEGIN List View, id_Actions_View_list
  win_list_view_eh(Win,e_Menu(id_Actions_View_list,_ShiftCtlAlt),0):-!,
	parent_child(Win,LVWin),
	lv_set_type(LVWIN,lvs_list),
	!.
%END List View, id_Actions_View_list

%BEGIN List View, id_Actions_View_small_icons
  win_list_view_eh(Win,e_Menu(id_Actions_View_small_icons,_ShiftCtlAlt),0):-!,
	parent_child(Win,LVWin),
	lv_set_type(LVWIN,lvs_smallicon),
	!.
%END List View, id_Actions_View_small_icons

%BEGIN List View, id_Actions_View_large_icons
  win_list_view_eh(Win,e_Menu(id_Actions_View_large_icons,_ShiftCtlAlt),0):-!,
	parent_child(Win,LVWin),
	lv_set_type(LVWIN,lvs_icon),
	!.
%END List View, id_Actions_View_large_icons

%BEGIN List View, id_Actions_set_font
  win_list_view_eh(Win,e_Menu(id_Actions_set_font,_ShiftCtlAlt),0):-!,
	parent_child(Win,LVWin),
	OldFont = win_GetFont(LVWin),
	NewFont = dlg_ChooseFont(OldFont,_,_),
	win_SetFont(LVWin,NewFont),
	!.
%END List View, id_Actions_set_font

%BEGIN List View, id_Actions_visible
  win_list_view_eh(Win,e_Menu(id_Actions_visible,_ShiftCtlAlt),0):-!,
	parent_child(Win,LVWin),
	win_SetState(LVWin,[wsf_Visible]),
	!.
%END List View, id_Actions_visible

%BEGIN List View, id_Actions_invisible
  win_list_view_eh(Win,e_Menu(id_Actions_invisible,_ShiftCtlAlt),0):-!,
	parent_child(Win,LVWin),
	win_SetState(LVWin,[wsf_Invisible]),
	!.
%END List View, id_Actions_invisible

%BEGIN List View, id_Actions_disable
  win_list_view_eh(Win,e_Menu(id_Actions_disable,_ShiftCtlAlt),0):-!,
	parent_child(Win,LVWin),
	win_SetState(LVWin,[wsf_Disabled]),
	!.
%END List View, id_Actions_disable

%BEGIN List View, id_Actions_enable
  win_list_view_eh(Win,e_Menu(id_Actions_enable,_ShiftCtlAlt),0):-!,
	parent_child(Win,LVWin),
	win_SetState(LVWin,[wsf_Enabled]),
	!.
%END List View, id_Actions_enable

%BEGIN List View, e_InitMenu
  win_list_view_eh(Win,e_InitMenu(),0):-!,
	check_style(Win),
	!.
%END List View, e_InitMenu

%BEGIN List View, e_Update
  win_list_view_eh(Win,e_Update(_UpdateRct),0):-!,
	win_Clear(Win,color_LtGray),
	!.
%END List View, e_Update

%BEGIN List View, e_EraseBackGround
  win_list_view_eh(_Win,e_EraseBackGround,0):-!,
	!.
%END List View, e_EraseBackGround

%BEGIN List View, e_Destroy
  win_list_view_eh(Win,e_Destroy,0):-!,
	retract(parent_child(Win,_)),
	!.
%END List View, e_Destroy

%BEGIN List View, e_Size
  win_list_view_eh(Win,e_Size(Width0,Height0),0):-!,
IFDEF use_tbar
	toolbar_Resize(Win),
ENDDEF
	parent_child(Win,LVWin),
	Width = Width0 - 10,
	Height = Height0 - 10,
	win_Move(LVWin,rct(5,5,Width,Height)),
	!.
%END List View, e_Size

%BEGIN List View, e_Menu, Parent window 
  win_list_view_eh(Win,e_Menu(ID,CAS),0):-!,
	PARENT = win_GetParent(Win),
	win_SendEvent(PARENT,e_Menu(ID,CAS)),
	!.
%END List View, e_Menu, Parent window

%END_WIN List View




%BEGIN_DLG Sort item
/**************************************************************************
	Creation and event handling for dialog: Sort item
**************************************************************************/

CONSTANTS

%BEGIN Sort item, CreateParms, 14:36:56-24.11.1999, Code automatically updated!
  dlg_sort_item_ResID = idd_sort_item
  dlg_sort_item_DlgType = wd_Modal
  dlg_sort_item_Help = idh_contents
%END Sort item, CreateParms

PREDICATES

  dlg_sort_item_eh : EHANDLER
  determ dlg_sort_item_handle_answer(INTEGER EndButton,DIALOG_VAL_LIST,LV_ORDER,UNSIGNED ColumnNumber,UNSIGNED HeaderRows,UNSIGNED FooterRows)
  determ dlg_sort_item_update(DIALOG_VAL_LIST,LV_ORDER,UNSIGNED ColumnNumber,UNSIGNED HeaderRows,UNSIGNED FooterRows)

CLAUSES

  dlg_sort_item_Create(Parent,Order,ColumnNumber,HeaderRows,FooterRows):-

%MARK Sort item, new variables

	dialog_CreateModal(Parent,dlg_sort_item_ResID,"",
  		[
%BEGIN Sort item, ControlList, 14:36:56-24.11.1999, Code automatically updated!
		df(idc_sort_item_1,editint(void,[]),nopr),
		df(idc_sort_item_2,editint(void,[]),nopr),
		df(idc_sort_item_3,editint(void,[]),nopr),
		df(idc_ascending,radiobuttongroup([idc_ascending,idc_descending,idc_sort_item_10]),nopr)
%END Sort item, ControlList
		],
		dlg_sort_item_eh,0,VALLIST,ANSWER),
	dlg_sort_item_handle_answer(ANSWER,VALLIST,Order,ColumnNumber,HeaderRows,FooterRows).

  dlg_sort_item_handle_answer(idc_ok,VALLIST,Order,ColumnNumber,HeaderRows,FooterRows):-!,
	dlg_sort_item_update(VALLIST,Order,ColumnNumber,HeaderRows,FooterRows).
  dlg_sort_item_handle_answer(idc_cancel,_,_,_,_,_):-!,fail.  % Handle Esc and Cancel here
  dlg_sort_item_handle_answer(_,_,ascending,0,0,0):-
	errorexit().

  dlg_sort_item_update(_VALLIST,Order,ColumnNumber,HeaderRows,FooterRows):-
%BEGIN Sort item, Update controls, 14:36:56-24.11.1999, Code automatically updated!
	_IDC_SORT_ITEM_1_VALUE = dialog_VLGetint(idc_sort_item_1,_VALLIST),
	_IDC_SORT_ITEM_2_VALUE = dialog_VLGetint(idc_sort_item_2,_VALLIST),
	_IDC_SORT_ITEM_3_VALUE = dialog_VLGetint(idc_sort_item_3,_VALLIST),
	_IDC_ASCENDING = dialog_VLGetRadiobutton(idc_ascending,_VALLIST),
%END Sort item, Update controls
	_IDC_SORT_ITEM_1_VALUE = i(ColumnNumber),
	_IDC_SORT_ITEM_2_VALUE = i(HeaderRows),
	_IDC_SORT_ITEM_3_VALUE = i(FooterRows),
	get_order(_IDC_ASCENDING,Order),
	true.

%MARK Sort item, new events

  dlg_sort_item_eh(_,_,_):-!,fail.

%END_DLG Sort item






%BEGIN_DLG Set item
/**************************************************************************
	Creation and event handling for dialog: Set item
**************************************************************************/

CONSTANTS

%BEGIN Set item, CreateParms, 13:55:30-31.10.1997, Code automatically updated!
  dlg_set_item_ResID = idd_set_item
  dlg_set_item_DlgType = wd_Modal
  dlg_set_item_Help = contents
%END Set item, CreateParms

PREDICATES

  dlg_set_item_eh : EHANDLER
  determ dlg_set_item_handle_answer(INTEGER EndButton,DIALOG_VAL_LIST,STRING Text,ILIST StateList,
	RESID LargeBitmapId,RESID SmallBitmapId,SLIST SubText)
  determ dlg_set_item_update(DIALOG_VAL_LIST,STRING Text,ILIST StateList,
	RESID LargeBitmapId,RESID SmallBitmapId,SLIST SubText)

CLAUSES

  dlg_set_item_Create(Parent,OldText,OldFlags,OldLargeBitmapId,OldSmallBitmapId,OldSubItemText,
	Text,StateList,LargeBitmapId,SmallBitmapId,SubText):-

	get_check_list(OldFlags,[lvis_focused,lvis_drophilited,lvis_cut,lvis_selected],[],CheckList),
	CheckList = [TVIS_SELECTED_CHECKED,TVIS_CUT_CHECKED,TVIS_DROPHILITED_CHECKED,TVIS_FOCUSED_CHECKED],
	OldSubItemText = [SecondName,ThirdName|_],
	get_bitmap_id(OldLargeBitmapName,OldLargeBitmapId),
	get_bitmap_id(OldSmallBitmapName,OldSmallBitmapId),
	bitmap_list(BitmapList),
	member_index(OldLargeBitmapName,BitmapList,OldLargeBitmapIndex),
	member_index(OldSmallBitmapName,BitmapList,OldSmallBitmapIndex),
	dialog_CreateModal(Parent,dlg_set_item_ResID,"",
  		[
		df(idc_set_item_status_1,editstr(OldText,[]),nopr),
		df(idc_tvis_selected,checkbox(TVIS_SELECTED_CHECKED),nopr),
		df(idc_tvis_cut,checkbox(TVIS_CUT_CHECKED),nopr),
		df(idc_tvis_drophilited,checkbox(TVIS_DROPHILITED_CHECKED),nopr),
		df(idc_tvis_bold,checkbox(TVIS_FOCUSED_CHECKED),nopr),
		df(idc_set_item_3,editstr(SecondName,[]),nopr),
		df(idc_set_item_15,editstr(ThirdName,[]),nopr),
		df(idc_set_item_status_2,listbutton(BitmapList,OldLargeBitmapIndex),nopr),
		df(idc_set_item_11,listbutton(BitmapList,OldSmallBitmapIndex),nopr)
		],
		dlg_set_item_eh,0,VALLIST,ANSWER),
	dlg_set_item_handle_answer(ANSWER,VALLIST,Text,StateList,LargeBitmapId,SmallBitmapId,SubText),!.

  dlg_set_item_handle_answer(idc_ok,VALLIST,Text,StateList,LargeBitmapId,SmallBitmapId,SubText):-!,
	dlg_set_item_update(VALLIST,Text,StateList,LargeBitmapId,SmallBitmapId,SubText).
  dlg_set_item_handle_answer(idc_cancel,_,_,_,_,_,_):-!,fail.  % Handle Esc and Cancel here
  dlg_set_item_handle_answer(_,_,"",[],0,0,[]):-
	errorexit().

  dlg_set_item_update(_VALLIST,Text,StateList,LargeBitmapId,SmallBitmapId,SubText):-
%BEGIN Set item, Update controls, 13:55:30-31.10.1997, Code automatically updated!
	_IDC_SET_ITEM_STATUS_1_VALUE = dialog_VLGetstr(idc_set_item_status_1,_VALLIST),
	_IDC_TVIS_SELECTED_CHECKED = dialog_VLGetCheck(idc_tvis_selected,_VALLIST),
	_IDC_TVIS_CUT_CHECKED = dialog_VLGetCheck(idc_tvis_cut,_VALLIST),
	_IDC_TVIS_DROPHILITED_CHECKED = dialog_VLGetCheck(idc_tvis_drophilited,_VALLIST),
	_IDC_TVIS_BOLD_CHECKED = dialog_VLGetCheck(idc_tvis_bold,_VALLIST),
	dialog_VLGetListButton(idc_set_item_status_2,_VALLIST,_IDC_SET_ITEM_STATUS_2_ITEMLIST,_IDC_SET_ITEM_STATUS_2_SELECT),
	_IDC_SET_ITEM_3_VALUE = dialog_VLGetstr(idc_set_item_3,_VALLIST),
	_IDC_SET_ITEM_15_VALUE = dialog_VLGetstr(idc_set_item_15,_VALLIST),
	dialog_VLGetListButton(idc_set_item_11,_VALLIST,_IDC_SET_ITEM_11_ITEMLIST,_IDC_SET_ITEM_11_SELECT),
%END Set item, Update controls
	Text = _IDC_SET_ITEM_STATUS_1_VALUE,
	Text1 = _IDC_SET_ITEM_3_VALUE,
	Text2 = _IDC_SET_ITEM_15_VALUE,
	SubText = [Text1,Text2],
	get_flags_list([_IDC_TVIS_SELECTED_CHECKED,_IDC_TVIS_CUT_CHECKED,_IDC_TVIS_DROPHILITED_CHECKED,_IDC_TVIS_BOLD_CHECKED],
		[lvis_selected,lvis_cut,lvis_drophilited,lvis_focused],[],StateList),
	get_bitmap_id(_IDC_SET_ITEM_STATUS_2_ITEMLIST,LargeBitmapId),
	get_bitmap_id(_IDC_SET_ITEM_11_ITEMLIST,SmallBitmapId),
	true.

%MARK Set item, new events

  dlg_set_item_eh(_,_,_):-!,fail.

%END_DLG Set item

%BEGIN_DLG Insert item1
/**************************************************************************
	Creation and event handling for dialog: Insert item1
**************************************************************************/

CONSTANTS

%BEGIN Insert item1, CreateParms, 14:36:38-24.11.1999, Code automatically updated!
  dlg_insert_item1_ResID = idd_insert_item1
  dlg_insert_item1_DlgType = wd_Modal
  dlg_insert_item1_Help = idh_contents
%END Insert item1, CreateParms

PREDICATES

  dlg_insert_item1_eh : EHANDLER
  determ dlg_insert_item1_handle_answer(INTEGER EndButton,DIALOG_VAL_LIST,INTEGER ItemId,STRING Text,
	ILIST StateList,RESID LargeBitmapId,RESID SmallBitmapId,SLIST SubText)
  determ dlg_insert_item1_update(DIALOG_VAL_LIST,INTEGER ItemId,STRING Text,
	ILIST StateList,RESID LargeBitmapId,RESID SmallBitmapId,SLIST SubText)

CLAUSES

  dlg_insert_item1_Create(Parent,ItemId,Text,StateList,LargeBitmapId,SmallBitmapId,SubText):-
	bitmap_list(BitmapList),
	dialog_CreateModal(Parent,dlg_insert_item1_ResID,"",
  		[
		df(idc_insert_item1_1,editint(void,[]),nopr),
		df(idc_set_item_status_1,editstr("",[]),nopr),
		df(idc_tvis_selected,checkbox(b_false),nopr),
		df(idc_tvis_cut,checkbox(b_false),nopr),
		df(idc_tvis_drophilited,checkbox(b_false),nopr),
		df(idc_tvis_bold,checkbox(b_false),nopr),
		df(idc_set_item_3,editstr("",[]),nopr),
		df(idc_set_item_15,editstr("",[]),nopr),
		df(idc_set_item_status_2,listbutton(BitmapList,0),nopr),
		df(idc_set_item_11,listbutton(BitmapList,0),nopr)
		],
		dlg_insert_item1_eh,0,VALLIST,ANSWER),
	dlg_insert_item1_handle_answer(ANSWER,VALLIST,ItemId,Text,StateList,LargeBitmapId,SmallBitmapId,SubText),!.

  dlg_insert_item1_handle_answer(idc_ok,VALLIST,ItemId,Text,StateList,LargeBitmapId,SmallBitmapId,SubText):-!,
	dlg_insert_item1_update(VALLIST,ItemId,Text,StateList,LargeBitmapId,SmallBitmapId,SubText).
  dlg_insert_item1_handle_answer(idc_cancel,_,_,_,_,_,_,_):-!,fail.  % Handle Esc and Cancel here
  dlg_insert_item1_handle_answer(_,_,0,"",[],0,0,[]):-
	errorexit().

  dlg_insert_item1_update(_VALLIST,ItemId,Text,StateList,LargeBitmapId,SmallBitmapId,SubText):-
%BEGIN Insert item1, Update controls, 14:36:38-24.11.1999, Code automatically updated!
	_IDC_SET_ITEM_STATUS_1_VALUE = dialog_VLGetstr(idc_set_item_status_1,_VALLIST),
	_IDC_TVIS_SELECTED_CHECKED = dialog_VLGetCheck(idc_tvis_selected,_VALLIST),
	_IDC_TVIS_CUT_CHECKED = dialog_VLGetCheck(idc_tvis_cut,_VALLIST),
	_IDC_TVIS_DROPHILITED_CHECKED = dialog_VLGetCheck(idc_tvis_drophilited,_VALLIST),
	_IDC_TVIS_BOLD_CHECKED = dialog_VLGetCheck(idc_tvis_bold,_VALLIST),
	dialog_VLGetListButton(idc_set_item_status_2,_VALLIST,_IDC_SET_ITEM_STATUS_2_ITEMLIST,_IDC_SET_ITEM_STATUS_2_SELECT),
	_IDC_SET_ITEM_3_VALUE = dialog_VLGetstr(idc_set_item_3,_VALLIST),
	_IDC_SET_ITEM_15_VALUE = dialog_VLGetstr(idc_set_item_15,_VALLIST),
	dialog_VLGetListButton(idc_set_item_11,_VALLIST,_IDC_SET_ITEM_11_ITEMLIST,_IDC_SET_ITEM_11_SELECT),
	_IDC_INSERT_ITEM1_1_VALUE = dialog_VLGetint(idc_insert_item1_1,_VALLIST),
%END Insert item1, Update controls
	_IDC_INSERT_ITEM1_1_VALUE = i(ItemId),
	Text = _IDC_SET_ITEM_STATUS_1_VALUE,
	Text1 = _IDC_SET_ITEM_3_VALUE,
	Text2 = _IDC_SET_ITEM_15_VALUE,
	SubText = [Text1,Text2],
	get_flags_list([_IDC_TVIS_SELECTED_CHECKED,_IDC_TVIS_CUT_CHECKED,_IDC_TVIS_DROPHILITED_CHECKED,_IDC_TVIS_BOLD_CHECKED],
		[lvis_selected,lvis_cut,lvis_drophilited,lvis_focused],[],StateList),
	get_bitmap_id(_IDC_SET_ITEM_STATUS_2_ITEMLIST,LargeBitmapId),
	get_bitmap_id(_IDC_SET_ITEM_11_ITEMLIST,SmallBitmapId),
	true.

%MARK Insert item1, new events

  dlg_insert_item1_eh(_,_,_):-!,fail.

%END_DLG Insert item1

%BEGIN_DLG Get column number
/**************************************************************************
	Creation and event handling for dialog: Get column number
**************************************************************************/

CONSTANTS

%BEGIN Get column number, CreateParms, 14:36:28-24.11.1999, Code automatically updated!
  dlg_get_column_number_ResID = idd_get_column_number
  dlg_get_column_number_DlgType = wd_Modal
  dlg_get_column_number_Help = idh_contents
%END Get column number, CreateParms

PREDICATES

  dlg_get_column_number_eh : EHANDLER
  determ dlg_get_column_number_handle_answer(INTEGER EndButton,DIALOG_VAL_LIST,INTEGER Number)
  determ dlg_get_column_number_update(DIALOG_VAL_LIST,INTEGER Number)

CLAUSES

  dlg_get_column_number_Create(Parent,Number):-

%MARK Get column number, new variables

	dialog_CreateModal(Parent,dlg_get_column_number_ResID,"",
  		[
%BEGIN Get column number, ControlList, 14:36:28-24.11.1999, Code automatically updated!
		df(idc_get_item_id_1,editint(void,[]),nopr)
%END Get column number, ControlList
		],
		dlg_get_column_number_eh,0,VALLIST,ANSWER),
	dlg_get_column_number_handle_answer(ANSWER,VALLIST,Number).

  dlg_get_column_number_handle_answer(idc_ok,VALLIST,Number):-!,
	dlg_get_column_number_update(VALLIST,Number).
  dlg_get_column_number_handle_answer(idc_cancel,_,_):-!,fail.  % Handle Esc and Cancel here
  dlg_get_column_number_handle_answer(_,_,0):-
	errorexit().

  dlg_get_column_number_update(_VALLIST,Number):-
%BEGIN Get column number, Update controls, 14:36:28-24.11.1999, Code automatically updated!
	_IDC_GET_ITEM_ID_1_VALUE = dialog_VLGetint(idc_get_item_id_1,_VALLIST),
%END Get column number, Update controls
	_IDC_GET_ITEM_ID_1_VALUE = i(Number),
	true.

%MARK Get column number, new events

  dlg_get_column_number_eh(_,_,_):-!,fail.

%END_DLG Get column number


%BEGIN_DLG Set column
/**************************************************************************
	Creation and event handling for dialog: Set column
**************************************************************************/

CONSTANTS

%BEGIN Set column, CreateParms, 14:36:08-24.11.1999, Code automatically updated!
  dlg_set_column_ResID = idd_set_column
  dlg_set_column_DlgType = wd_Modal
  dlg_set_column_Help = idh_contents
%END Set column, CreateParms

PREDICATES

  dlg_set_column_eh : EHANDLER
  determ dlg_set_column_handle_answer(INTEGER EndButton,DIALOG_VAL_LIST,INTEGER ColumnNum,STRING Text,INTEGER Width,LV_ALIGNMENT Align)
  determ dlg_set_column_update(DIALOG_VAL_LIST,INTEGER ColumnNum,STRING Text,INTEGER Width,LV_ALIGNMENT Align)

CLAUSES

  dlg_set_column_Create(Parent,ColumnNum,Text,Width,Align):-

%MARK Set column, new variables

	dialog_CreateModal(Parent,dlg_set_column_ResID,"",
  		[
%BEGIN Set column, ControlList, 14:36:08-24.11.1999, Code automatically updated!
		df(idc_set_column_11,editint(void,[]),nopr),
		df(idc_set_item_status_1,editstr("",[]),nopr),
		df(idc_set_item_3,editint(void,[]),nopr),
		df(idc_left,radiobuttongroup([idc_left,idc_right,idc_center]),nopr)
%END Set column, ControlList
		],
		dlg_set_column_eh,0,VALLIST,ANSWER),
	dlg_set_column_handle_answer(ANSWER,VALLIST,ColumnNum,Text,Width,Align).

  dlg_set_column_handle_answer(idc_ok,VALLIST,ColumnNum,Text,Width,Align):-!,
	dlg_set_column_update(VALLIST,ColumnNum,Text,Width,Align).
  dlg_set_column_handle_answer(idc_cancel,_,_,_,_,_):-!,fail.  % Handle Esc and Cancel here
  dlg_set_column_handle_answer(_,_,1,"",0,left):-
	errorexit().

  dlg_set_column_update(_VALLIST,ColumnNum,Text,Width,Align):-
%BEGIN Set column, Update controls, 14:36:08-24.11.1999, Code automatically updated!
	_IDC_SET_ITEM_STATUS_1_VALUE = dialog_VLGetstr(idc_set_item_status_1,_VALLIST),
	_IDC_SET_ITEM_3_VALUE = dialog_VLGetint(idc_set_item_3,_VALLIST),
	_IDC_SET_COLUMN_11_VALUE = dialog_VLGetint(idc_set_column_11,_VALLIST),
	_IDC_LEFT = dialog_VLGetRadiobutton(idc_left,_VALLIST),
%END Set column, Update controls
	_IDC_SET_COLUMN_11_VALUE = i(ColumnNum),
	Text = _IDC_SET_ITEM_STATUS_1_VALUE,
	_IDC_SET_ITEM_3_VALUE = i(Width),
	get_align(_IDC_LEFT,Align),
	true.

%MARK Set column, new events

  dlg_set_column_eh(_,_,_):-!,fail.

%END_DLG Set column




%BEGIN_DLG Insert column
/**************************************************************************
	Creation and event handling for dialog: Insert column
**************************************************************************/

CONSTANTS

%BEGIN Insert column, CreateParms, 14:36:02-24.11.1999, Code automatically updated!
  dlg_insert_column_ResID = idd_insert_column
  dlg_insert_column_DlgType = wd_Modal
  dlg_insert_column_Help = idh_contents
%END Insert column, CreateParms

PREDICATES

  dlg_insert_column_eh : EHANDLER
  determ dlg_insert_column_handle_answer(INTEGER EndButton,DIALOG_VAL_LIST,INTEGER ColumnNum,STRING Text,INTEGER Width,LV_ALIGNMENT Align)
  determ dlg_insert_column_update(DIALOG_VAL_LIST,INTEGER ColumnNum,STRING Text,INTEGER Width,LV_ALIGNMENT Align)

CLAUSES

  dlg_insert_column_Create(Parent,ColumnNum,Text,Width,Align):-

%MARK Insert column, new variables

	dialog_CreateModal(Parent,dlg_insert_column_ResID,"",
  		[
%BEGIN Insert column, ControlList, 14:36:02-24.11.1999, Code automatically updated!
		df(idc_set_column_11,editint(void,[]),nopr),
		df(idc_set_item_status_1,editstr("",[]),nopr),
		df(idc_set_item_3,editint(void,[]),nopr),
		df(idc_left,radiobuttongroup([idc_left,idc_right,idc_center]),nopr)
%END Insert column, ControlList
		],
		dlg_insert_column_eh,0,VALLIST,ANSWER),
	dlg_insert_column_handle_answer(ANSWER,VALLIST,ColumnNum,Text,Width,Align).

  dlg_insert_column_handle_answer(idc_ok,VALLIST,ColumnNum,Text,Width,Align):-!,
	dlg_insert_column_update(VALLIST,ColumnNum,Text,Width,Align).
  dlg_insert_column_handle_answer(idc_cancel,_,_,_,_,_):-!,fail.  % Handle Esc and Cancel here
  dlg_insert_column_handle_answer(_,_,1,"",0,left):-
	errorexit().

  dlg_insert_column_update(_VALLIST,ColumnNum,Text,Width,Align):-
%BEGIN Insert column, Update controls, 14:36:02-24.11.1999, Code automatically updated!
	_IDC_SET_ITEM_STATUS_1_VALUE = dialog_VLGetstr(idc_set_item_status_1,_VALLIST),
	_IDC_SET_ITEM_3_VALUE = dialog_VLGetint(idc_set_item_3,_VALLIST),
	_IDC_SET_COLUMN_11_VALUE = dialog_VLGetint(idc_set_column_11,_VALLIST),
	_IDC_LEFT = dialog_VLGetRadiobutton(idc_left,_VALLIST),
%END Insert column, Update controls
	_IDC_SET_COLUMN_11_VALUE = i(ColumnNum),
	Text = _IDC_SET_ITEM_STATUS_1_VALUE,
	_IDC_SET_ITEM_3_VALUE = i(Width),
	get_align(_IDC_LEFT,Align),
	true.

%MARK Insert column, new events

  dlg_insert_column_eh(_,_,_):-!,fail.

%END_DLG Insert column










%BEGIN_DLG Tab Control
/**************************************************************************
	Creation and event handling for dialog: Tab Control
**************************************************************************/

CONSTANTS

%BEGIN Tab Control, CreateParms, 14:35:54-24.11.1999, Code automatically updated!
  dlg_tab_control_ResID = idd_tab_control
  dlg_tab_control_DlgType = wd_Modal
  dlg_tab_control_Help = idh_contents
%END Tab Control, CreateParms

PREDICATES

  dlg_tab_control_eh : EHANDLER
  dlg_tab_control_handle_answer(INTEGER EndButton,DIALOG_VAL_LIST)
  dlg_tab_control_update(DIALOG_VAL_LIST)

CLAUSES

  dlg_tab_control_Create(Parent):-

%MARK Tab Control, new variables

	dialog_CreateModal(Parent,dlg_tab_control_ResID,"",
  		[
%BEGIN Tab Control, ControlList, 14:35:54-24.11.1999, Code automatically updated!
		df(idc_edit,editint(i(0),[]),nopr),
		df(idc_check_box_1,checkbox(b_false),nopr),
		df(idc_check_box_2,checkbox(b_false),nopr),
		df(idc_check_box_3,checkbox(b_false),nopr),
		df(idc_check_box_4,checkbox(b_false),nopr),
		df(idc_edit1,editint(i(0),[]),nopr),
		df(idc_radio_button_1,radiobuttongroup([idc_radio_button_1,idc_radio_button_2,idc_radio_button_3,idc_radio_button_4]),nopr)
%END Tab Control, ControlList
		],
		dlg_tab_control_eh,0,VALLIST,ANSWER),
	dlg_tab_control_handle_answer(ANSWER,VALLIST).

  dlg_tab_control_handle_answer(idc_ok,VALLIST):-!,
	dlg_tab_control_update(VALLIST).
  dlg_tab_control_handle_answer(idc_cancel,_):-!.  % Handle Esc and Cancel here
  dlg_tab_control_handle_answer(_,_):-
	errorexit().

  dlg_tab_control_update(_VALLIST):-
%BEGIN Tab Control, Update controls, 14:35:54-24.11.1999, Code automatically updated!
	_IDC_EDIT_VALUE = dialog_VLGetint(idc_edit,_VALLIST),
	_IDC_CHECK_BOX_1_CHECKED = dialog_VLGetCheck(idc_check_box_1,_VALLIST),
	_IDC_CHECK_BOX_2_CHECKED = dialog_VLGetCheck(idc_check_box_2,_VALLIST),
	_IDC_CHECK_BOX_3_CHECKED = dialog_VLGetCheck(idc_check_box_3,_VALLIST),
	_IDC_CHECK_BOX_4_CHECKED = dialog_VLGetCheck(idc_check_box_4,_VALLIST),
	_IDC_EDIT1_VALUE = dialog_VLGetint(idc_edit1,_VALLIST),
	_IDC_RADIO_BUTTON_1 = dialog_VLGetRadiobutton(idc_radio_button_1,_VALLIST),
%END Tab Control, Update controls
write("Edit=",_IDC_EDIT_VALUE,", CB1=",_IDC_CHECK_BOX_1_CHECKED,", CB2=",_IDC_CHECK_BOX_2_CHECKED,
", CB3=",_IDC_CHECK_BOX_3_CHECKED,", CB4=",_IDC_CHECK_BOX_4_CHECKED,", RB=",_IDC_RADIO_BUTTON_1,"\n"),
	true.

%MARK Tab Control, new events

  dlg_tab_control_eh(_,e_Control(idc_treebut,_,_,Message),_):-
	write("Tree Button CallBack=",Message,"\n"),
	fail.
  dlg_tab_control_eh(_,_,_):-!,fail.

%END_DLG Tab Control








































































