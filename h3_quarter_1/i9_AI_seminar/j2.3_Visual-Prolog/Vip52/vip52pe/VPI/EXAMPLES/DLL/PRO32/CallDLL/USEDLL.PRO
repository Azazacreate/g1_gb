/*****************************************************************************

		 Copyright (c) 1984 - 2000 Prolog Development Center A/S

 			VISUAL Prolog
 
 Project:  USEDLL
 FileName: USEDLL.PRO
 Purpose: Demonstrates DLL using
 Written by: Visual Prolog
 Comments:
******************************************************************************/

include "usedll.inc"
include "usedll.con"
include "hlptopic.con"

%BEGIN_WIN Task Window
/***************************************************************************
	Event handling for Task Window
***************************************************************************/

PREDICATES

  task_win_eh : EHANDLER

CONSTANTS

%BEGIN Task Window, CreateParms, 18:37:50-24.11.1999, Code automatically updated!
  task_win_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Close,wsf_Maximize,wsf_Minimize,wsf_ClipSiblings]
  task_win_Menu  = res_menu(idr_task_menu)
  task_win_Title = "Use DLL"
  task_win_Help  = idh_contents
%END Task Window, CreateParms

CLAUSES

%BEGIN Task Window, e_Create
  task_win_eh(_Win,e_Create(_),0):-!,
%BEGIN Task Window, InitControls, 18:37:50-24.11.1999, Code automatically updated!
%END Task Window, InitControls
%BEGIN Task Window, ToolbarCreate, 18:37:50-24.11.1999, Code automatically updated!
	tb_project_toolbar_Create(_Win),
	tb_help_line_Create(_Win),
%END Task Window, ToolbarCreate
IFDEF use_message
	msg_Create(100),
ENDDEF
	!.
%END Task Window, e_Create

%MARK Task Window, new events

%BEGIN Task Window, id_file_open
  task_win_eh(_Win,e_Menu(id_file_open,_ShiftCtlAlt),0):-!,
	dlg_usedll_Create(_Win),
	!.
%END Task Window, id_file_open

%BEGIN Task Window, id_help_contents
  task_win_eh(_Win,e_Menu(id_help_contents,_ShiftCtlAlt),0):-!,
  	vpi_ShowHelp("usedll.hlp"),
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
  	vpi_ShowHelpContext("usedll.hlp",HelpTopic),!.

/***************************************************************************
	Main Goal
***************************************************************************/

GOAL

IFDEF use_mdi
  vpi_SetAttrVal(attr_win_mdi,b_true),
ENDDEF
IFDEF use_3dctrl
  vpi_SetAttrVal(attr_win_Tbar,28),
  vpi_SetAttrVal(attr_win_Sbar,24),
  vpi_SetAttrVal(attr_win_3dcontrols,b_true),
ENDDEF
  vpi_Init(task_win_Flags,task_win_eh,task_win_Menu,"usedll",task_win_Title).

%BEGIN_TLB Project toolbar, 18:38:00-24.11.1999, Code automatically updated!
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



%BEGIN_TLB Help line, 18:38:02-24.11.1999, Code automatically updated!
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

%BEGIN About dialog, CreateParms, 23:22:54-10.1.2000, Code automatically updated!
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

%BEGIN_DLG UseDLL
/**************************************************************************
	Creation and event handling for dialog: UseDLL
**************************************************************************/

CONSTANTS

%BEGIN UseDLL, CreateParms, 17:44:20-4.11.1998, Code automatically updated!
  dlg_usedll_ResID = idd_usedll
  dlg_usedll_DlgType = wd_Modal
  dlg_usedll_Help = idh_contents
%END UseDLL, CreateParms

PREDICATES

  dlg_usedll_eh : EHANDLER
  dlg_usedll_handle_answer(INTEGER EndButton,DIALOG_VAL_LIST)
  dlg_usedll_update(DIALOG_VAL_LIST)

CLAUSES

  dlg_usedll_Create(Parent):-

%MARK UseDLL, new variables

	dialog_CreateModal(Parent,dlg_usedll_ResID,"",
  		[
%BEGIN UseDLL, ControlList, 17:44:20-4.11.1998, Code automatically updated!
		df(idc_i,editint(void,[]),str_prompt("Value")),
		df(idc_r,editreal(void,[]),str_prompt("Value")),
		df(idc_s,editstr("",[]),str_prompt("Value")),
		df(idc_i_ret,editint(void,[]),str_prompt("Value")),
		df(idc_r_ret,editreal(void,[]),str_prompt("Value")),
		df(idc_s_ret,editstr("",[]),str_prompt("Value"))
%END UseDLL, ControlList
		],
		dlg_usedll_eh,0,VALLIST,ANSWER),
	dlg_usedll_handle_answer(ANSWER,VALLIST).

  dlg_usedll_handle_answer(idc_ok,VALLIST):-!,
	dlg_usedll_update(VALLIST).
  dlg_usedll_handle_answer(idc_cancel,_):-!.  % Handle Esc and Cancel here
  dlg_usedll_handle_answer(_,_):-
	errorexit().

  dlg_usedll_update(_VALLIST):-
	true.

%MARK UseDLL, new events

%BEGIN UseDLL, idc_get_s _CtlInfo
  dlg_usedll_eh(Win,e_Control(idc_get_s,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
  	dll_mark_gstack(STACKMARK),
  	getString(Out),
	dialog_SetStr(Win,idc_s_ret,Out),
  	dll_release_gstack(STACKMARK),
	!.
%END UseDLL, idc_get_s _CtlInfo

%BEGIN UseDLL, idc_set_s _CtlInfo
  dlg_usedll_eh(_Win,e_Control(idc_set_s,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	In = dialog_GetStr(_Win,idc_s),
  	setString(In),
	!.
%END UseDLL, idc_set_s _CtlInfo

%BEGIN UseDLL, idc_get_r _CtlInfo
  dlg_usedll_eh(Win,e_Control(idc_get_r,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
  	getReal(Out ),
	dialog_SetReal(Win, idc_r_ret, r(Out)),
	!.
%END UseDLL, idc_get_r _CtlInfo

%BEGIN UseDLL, idc_set_r _CtlInfo
  dlg_usedll_eh( Win, e_Control(idc_set_r,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	dialog_CheckEditProperties(Win, idc_r),
	Dialog_Real = dialog_GetReal(Win, idc_r),
	Dialog_Real = r( In ),
	setReal( In ),
	!.
%END UseDLL, idc_set_r _CtlInfo

%BEGIN UseDLL, idc_get_i _CtlInfo
  dlg_usedll_eh(Win,e_Control(idc_get_i,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	getInteger(Out),
	dialog_SetInt(Win, idc_i_ret, i(Out)),
	!.
%END UseDLL, idc_get_i _CtlInfo

%BEGIN UseDLL, idc_set_i _CtlInfo
  dlg_usedll_eh(_Win,e_Control(idc_set_i,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	dialog_CheckEditProperties(_Win, idc_i),
	Dialog_Int = dialog_GetInt(_Win,idc_i),
	Dialog_Int = i(In),
	setInteger( In ),
	!.
%END UseDLL, idc_set_i _CtlInfo

  dlg_usedll_eh(_,_,_):-!,fail.

%END_DLG UseDLL









