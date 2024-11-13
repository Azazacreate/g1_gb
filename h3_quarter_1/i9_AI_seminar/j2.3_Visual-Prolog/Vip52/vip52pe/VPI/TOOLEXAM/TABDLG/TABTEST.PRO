/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  TABTEST
 FileName: TABTEST.PRO
 Purpose: Handling of Property sheet dialogs
 Written by: Visual Prolog
 Comments:
******************************************************************************/

include "tabtest.inc"
include "tabtest.con"
include "hlptopic.con"

PREDICATES
  getFontforDialog(WINDOW,FONT)
  error
  
CLAUSES
  error.
  
  getFontforDialog(_Win,Font):-
	trap(Font=win_GetFont(_Win),_,error),!.
  getFontforDialog(_,Font):-
	Font=font_Create(ff_System,[],10).
	
%BEGIN_WIN Task Window
/***************************************************************************
	Event handling for Task Window
***************************************************************************/

PREDICATES

  task_win_eh : EHANDLER

CONSTANTS

%BEGIN Task Window, CreateParms, 16:05:04-24.11.1999, Code automatically updated!
  task_win_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Close,wsf_Maximize,wsf_Minimize,wsf_ClipSiblings]
  task_win_Menu  = res_menu(idr_task_menu)
  task_win_Title = "Tabtest"
  task_win_Help  = idh_contents
%END Task Window, CreateParms

CLAUSES

%BEGIN Task Window, e_Create
  task_win_eh(_Win,e_Create(_),0):-!,
%BEGIN Task Window, InitControls, 16:05:04-24.11.1999, Code automatically updated!
%END Task Window, InitControls
%BEGIN Task Window, ToolbarCreate, 16:05:04-24.11.1999, Code automatically updated!
	tb_project_toolbar_Create(_Win),
	tb_help_line_Create(_Win),
%END Task Window, ToolbarCreate
IFDEF use_message
	msg_Create(100),
ENDDEF
  	tabdlg_Register,
	!.
%END Task Window, e_Create

%MARK Task Window, new events

%BEGIN Task Window, id_file_new
  task_win_eh(_Win,e_Menu(id_file_new,_ShiftCtlAlt),0):-!,
	dlg_tab_dialog_Create(_Win),
	!.
%END Task Window, id_file_new

%BEGIN Task Window, id_help_contents
  task_win_eh(_Win,e_Menu(id_help_contents,_ShiftCtlAlt),0):-!,
  	vpi_ShowHelp("tabtest.hlp"),
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
  	vpi_ShowHelpContext("tabtest.hlp",HelpTopic).

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
  vpi_Init(task_win_Flags,task_win_eh,task_win_Menu,"tabtest",task_win_Title).

%BEGIN_TLB Project toolbar, 16:05:22-24.11.1999, Code automatically updated!
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















%BEGIN_TLB Help line, 16:05:28-24.11.1999, Code automatically updated!
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

%BEGIN About dialog, CreateParms, 16:01:24-24.11.1999, Code automatically updated!
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

%BEGIN_DLG A Dialog
/**************************************************************************
	Creation and event handling for dialog: A Dialog
**************************************************************************/

CONSTANTS

%BEGIN A Dialog, CreateParms, 16:01:08-24.11.1999, Code automatically updated!
  dlg_a_dialog_ResID = idd_a_dialog
  dlg_a_dialog_DlgType = wd_Modal
  dlg_a_dialog_Help = idh_contents
%END A Dialog, CreateParms

PREDICATES

  dlg_a_dialog_eh : EHANDLER
  dlg_a_dialog_handle_answer(INTEGER EndButton,DIALOG_VAL_LIST)
  dlg_a_dialog_update(DIALOG_VAL_LIST)

CLAUSES

  dlg_a_dialog_Create(Parent):-

%MARK A Dialog, new variables

	dialog_CreateModal(Parent,dlg_a_dialog_ResID,"",
  		[
%BEGIN A Dialog, ControlList, 16:01:08-24.11.1999, Code automatically updated!
		df(idc_edit,editstr("Edit",[]),nopr),
		df(idc_a_dialog_5,editstr("Edit",[]),nopr),
		df(idc_a_dialog_1,listbutton([],0),nopr),
		df(idc_a_dialog_6,editstr("Edit",[]),nopr),
		df(idc_a_dialog_2,listbutton([],0),nopr),
		df(idc_check_box,checkbox(b_false),nopr),
		df(idc_a_dialog_9,checkbox(b_false),nopr),
		df(idc_a_dialog_10,checkbox(b_false),nopr)
%END A Dialog, ControlList
		],
		dlg_a_dialog_eh,0,VALLIST,ANSWER),
	dlg_a_dialog_handle_answer(ANSWER,VALLIST).

  dlg_a_dialog_handle_answer(idc_ok,VALLIST):-!,
	dlg_a_dialog_update(VALLIST).
  dlg_a_dialog_handle_answer(idc_cancel,_):-!.  % Handle Esc and Cancel here
  dlg_a_dialog_handle_answer(_,_):-
	errorexit().

  dlg_a_dialog_update(_VALLIST):-
%BEGIN A Dialog, Update controls, 16:01:08-24.11.1999, Code automatically updated!
	_IDC_EDIT_VALUE = dialog_VLGetstr(idc_edit,_VALLIST),
	_IDC_A_DIALOG_5_VALUE = dialog_VLGetstr(idc_a_dialog_5,_VALLIST),
	_IDC_A_DIALOG_6_VALUE = dialog_VLGetstr(idc_a_dialog_6,_VALLIST),
	_IDC_CHECK_BOX_CHECKED = dialog_VLGetCheck(idc_check_box,_VALLIST),
	_IDC_A_DIALOG_9_CHECKED = dialog_VLGetCheck(idc_a_dialog_9,_VALLIST),
	_IDC_A_DIALOG_10_CHECKED = dialog_VLGetCheck(idc_a_dialog_10,_VALLIST),
	dialog_VLGetListButton(idc_a_dialog_1,_VALLIST,_IDC_A_DIALOG_1_ITEMLIST,_IDC_A_DIALOG_1_SELECT),
	dialog_VLGetListButton(idc_a_dialog_2,_VALLIST,_IDC_A_DIALOG_2_ITEMLIST,_IDC_A_DIALOG_2_SELECT),
%END A Dialog, Update controls
	true.

%MARK A Dialog, new events

  dlg_a_dialog_eh(_,_,_):-!,fail.

%END_DLG A Dialog

%BEGIN_DLG Use Code Expert
/**************************************************************************
	Creation and event handling for dialog: Use Code Expert
**************************************************************************/

CONSTANTS

%BEGIN Use Code Expert, CreateParms, 16:00:46-24.11.1999, Code automatically updated!
  dlg_use_code_expert_ResID = idd_codeexp
  dlg_use_code_expert_DlgType = wd_Modal
  dlg_use_code_expert_Help = idh_contents
%END Use Code Expert, CreateParms

PREDICATES

  dlg_use_code_expert_eh : EHANDLER
  dlg_use_code_expert_handle_answer(INTEGER EndButton,DIALOG_VAL_LIST)
  dlg_use_code_expert_update(DIALOG_VAL_LIST)

CLAUSES

  dlg_use_code_expert_Create(Parent):-

%MARK Use Code Expert, new variables

	dialog_CreateModal(Parent,dlg_use_code_expert_ResID,"",
		[
%BEGIN Use Code Expert, ControlList, 16:00:46-24.11.1999, Code automatically updated!
		df(dlg_tab1_edit1,editint(void,[range(3,5)]),nopr),
		df(dlg_tab1_check_box_1,checkbox(b_false),nopr),
		df(dlg_tab1_check_box_2,checkbox(b_false),nopr),
		df(dlg_tab1_bla_1,listbox(["first","second","no 3","four","bla. bla.","last"],[2]),nopr),
		df(dlg_codeexp_enabledisable_controls,checkbox(b_false),nopr),
		df(dlg_codeexp_showhide_controls,checkbox(b_false),nopr)
%END Use Code Expert, ControlList
		],
		dlg_use_code_expert_eh,0,VALLIST,ANSWER),
	dlg_use_code_expert_handle_answer(ANSWER,VALLIST).

  dlg_use_code_expert_handle_answer(idc_ok,VALLIST):-!,
	dlg_use_code_expert_update(VALLIST).
  dlg_use_code_expert_handle_answer(idc_cancel,_):-!.  % Handle Esc and Cancel here
  dlg_use_code_expert_handle_answer(_,_):-
	errorexit().

  dlg_use_code_expert_update(_VALLIST):-
%BEGIN Use Code Expert, Update controls, 16:00:46-24.11.1999, Code automatically updated!
	_DLG_TAB1_CHECK_BOX_1_CHECKED = dialog_VLGetCheck(dlg_tab1_check_box_1,_VALLIST),
	_DLG_TAB1_CHECK_BOX_2_CHECKED = dialog_VLGetCheck(dlg_tab1_check_box_2,_VALLIST),
	_DLG_TAB1_EDIT1_VALUE = dialog_VLGetint(dlg_tab1_edit1,_VALLIST),
	dialog_VLGetListBox(dlg_tab1_bla_1,_VALLIST,_DLG_TAB1_BLA_1_ITEMLIST,_DLG_TAB1_BLA_1_SELECT),
	_DLG_CODEEXP_ENABLEDISABLE_CONTROLS_CHECKED = dialog_VLGetCheck(dlg_codeexp_enabledisable_controls,_VALLIST),
	_DLG_CODEEXP_SHOWHIDE_CONTROLS_CHECKED = dialog_VLGetCheck(dlg_codeexp_showhide_controls,_VALLIST),
%END Use Code Expert, Update controls
	true.

%MARK Use Code Expert, new events

  dlg_use_code_expert_eh(_,_,_):-!,fail.

%END_DLG Use Code Expert


%BEGIN_DLG Tab Dialog
/**************************************************************************
	Creation and event handling for dialog: Tab Dialog
**************************************************************************/

CONSTANTS

%BEGIN Tab Dialog, CreateParms, 16:00:16-24.11.1999, Code automatically updated!
  dlg_tab_dialog_ResID = dlg_tabtest
  dlg_tab_dialog_DlgType = wd_Modal
  dlg_tab_dialog_Help = idh_contents
%END Tab Dialog, CreateParms

PREDICATES

  dlg_tab_dialog_eh : EHANDLER
  dlg_tab_dialog_handle_answer(INTEGER EndButton,DIALOG_VAL_LIST)
  dlg_tab_dialog_update(DIALOG_VAL_LIST)

CLAUSES

  dlg_tab_dialog_Create(Parent):-

%MARK Tab Dialog, new variables

	dialog_CreateModal(Parent,dlg_tab_dialog_ResID,"",
  		[
%BEGIN Tab Dialog, ControlList, 16:00:16-24.11.1999, Code automatically updated!
%END Tab Dialog, ControlList
		],
		dlg_tab_dialog_eh,0,VALLIST,ANSWER),
	dlg_tab_dialog_handle_answer(ANSWER,VALLIST).

  dlg_tab_dialog_handle_answer(idc_ok,VALLIST):-!,
	dlg_tab_dialog_update(VALLIST).
  dlg_tab_dialog_handle_answer(idc_cancel,_):-!.  % Handle Esc and Cancel here
  dlg_tab_dialog_handle_answer(_,_):-
	errorexit().

  dlg_tab_dialog_update(_VALLIST):-
%BEGIN Tab Dialog, Update controls, 16:00:16-24.11.1999, Code automatically updated!
%END Tab Dialog, Update controls
	true.

%MARK Tab Dialog, new events

%BEGIN Tab Dialog, e_Create
  dlg_tab_dialog_eh(_Win,e_Create(_CreationData),0):-!,
	getFontforDialog(_Win,Font),

	DynCtlList2=
		[
		df(dlg_tab1_edit1,editint(void,[range(3,5)]),nopr),
		df(dlg_tab1_check_box_1,checkbox(b_false),nopr),
		df(dlg_tab1_check_box_2,checkbox(b_false),nopr),
		df(dlg_tab1_bla_1,listbox(["first","second","no 3","four","bla. bla.","last"],[2]),nopr),
		df(dlg_codeexp_enabledisable_controls,checkbox(b_true),nopr),
		df(dlg_codeexp_showhide_controls,checkbox(b_true),nopr)
		],
		
  	DynCtlList3 = 
  	[	ctl(wdef(wc_Edit,rct(10,10,80,22),"Yet another edit text",u_DlgBase),100,[ctl_tabstop]),
		ctl(wdef(wc_PushButton,rct(20,50,160,100),"Large Button",u_DlgBase),101,[])
	],
	DynFieldList3 = [df(100,editstr("Ole",[length(5)]),str_prompt("Ole field"))], 	

  	DynCtlList4 = 
  	[	ctl(wdef(wc_Text,rct(10,10,100,22),"Yet another static text",u_DlgBase),102,[]),
		ctl(wdef(wc_PushButton,rct(20,50,100,74),"Button",u_DlgBase),103,[])
	],
	
  	SheetList =
  	[	
  		tabdlg(1,bmp(idb_b1),res(idd_codeexp), DynCtlList2),
 		tabdlg(2,bmp(idb_b4),res(idd_a_dialog), []),
  		tabdlg(3,bmp(idb_b5),dyn(DynCtlList3), DynFieldList3),
  		tabdlg(4,bmp(idb_b6),dyn(DynCtlList4), [])
  	],

 	tabdlg_Create(_Win,dlg_tabtest_tab,Font,right,58,56,SheetList,2),
	!.
%END Tab Dialog, e_Create

  dlg_tab_dialog_eh(_Win,e_Control(dlg_codeexp_enabledisable_controls,_CtrlType,CtrlWin,_CtlInfo),0):-
	State=win_IsChecked(CtrlWin),
	State=checkbox_off,!,
	StateList=[
			enable(dlg_tab1_edit1,b_false),
			enable(dlg_tab1_check_box_1,b_false),
			enable(dlg_tab1_check_box_2,b_false),
			enable(dlg_tab1_bla_1,b_false),
			enable(idc_hello,b_false),
			enable(idc_ole,b_false)
		],
	tabdlg_SetState(_Win,StateList),
	!.
  dlg_tab_dialog_eh(_Win,e_Control(dlg_codeexp_enabledisable_controls,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	StateList=[
			enable(dlg_tab1_edit1,b_true),
			enable(dlg_tab1_check_box_1,b_true),
			enable(dlg_tab1_check_box_2,b_true),
			enable(dlg_tab1_bla_1,b_true),
			enable(idc_hello,b_true),
			enable(idc_ole,b_true)
		],
	tabdlg_SetState(_Win,StateList),
	!.

  dlg_tab_dialog_eh(_Win,e_Control(dlg_codeexp_showhide_controls,_CtrlType,CtrlWin,_CtlInfo),0):-
	State=win_IsChecked(CtrlWin),
	State=checkbox_off,!,
	StateList=[
			show(dlg_tab1_edit1,b_false),
			show(dlg_tab1_check_box_1,b_false),
			show(dlg_tab1_check_box_2,b_false),
			show(dlg_tab1_bla_1,b_false),
			show(idc_hello,b_false),
			show(idc_ole,b_false),
			show(dlg_tab1_groupbox,b_false)
		],
	tabdlg_SetState(_Win,StateList),
	!.
  dlg_tab_dialog_eh(_Win,e_Control(dlg_codeexp_showhide_controls,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	StateList=[
			show(dlg_tab1_edit1,b_true),
			show(dlg_tab1_check_box_1,b_true),
			show(dlg_tab1_check_box_2,b_true),
			show(dlg_tab1_bla_1,b_true),
			show(idc_hello,b_true),
			show(idc_ole,b_true),
			show(dlg_tab1_groupbox,b_true)
		],
	tabdlg_SetState(_Win,StateList),
	!.

  dlg_tab_dialog_eh(_,_,_):-!,fail.

%END_DLG Tab Dialog




