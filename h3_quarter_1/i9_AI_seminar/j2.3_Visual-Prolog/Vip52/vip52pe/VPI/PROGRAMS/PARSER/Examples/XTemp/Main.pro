/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  XTEMP
 FileName: XTEMP.PRO
 Purpose: Demo using parser source file
 Written by: Eugene Akimov
 Comments:
******************************************************************************/

include "xtemp.inc"
include "xtemp.con"
include "hlptopic.con"

facts - win
  result_win(WINDOW ResultWin)
  press_close_request

/* Check Selected Text */
predicates
  check_SelectedText(WINDOW ResultWin,boolean ClipboardEmpty) - procedure (i,o)

clauses
  check_SelectedText(ResultWin,b_false):-
	edit_GetSelection(ResultWin,StartPos,EndPos),
	StartPos=EndPos,
	EndPos=0,
	!.
  check_SelectedText(_,b_true).

%BEGIN_WIN Task Window
/***************************************************************************
		Event handling for Task Window
***************************************************************************/

predicates

  task_win_eh : EHANDLER

constants

%BEGIN Task Window, CreateParms, 22:31:06-1.12.1999, Code automatically updated!
  task_win_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Close,wsf_Maximize,wsf_Minimize,wsf_ClipSiblings]
  task_win_Menu  = res_menu(idr_task_menu)
  task_win_Title = "XTemp"
  task_win_Help  = idh_contents
%END Task Window, CreateParms

clauses

%BEGIN Task Window, e_Create
  task_win_eh(_Win,e_Create(_),0):-!,
%BEGIN Task Window, InitControls, 22:31:06-1.12.1999, Code automatically updated!
%END Task Window, InitControls
%BEGIN Task Window, ToolbarCreate, 22:31:06-1.12.1999, Code automatically updated!
	tb_project_toolbar_Create(_Win),
	tb_help_line_Create(_Win),
%END Task Window, ToolbarCreate
ifdef use_message
	msg_Create(100),
enddef
	msg_AppendStr("Press F7\n"),
	!.
%END Task Window, e_Create

%MARK Task Window, new events

%BEGIN Task Window, id_file_new
  task_win_eh(_Win,e_Menu(id_file_new,_ShiftCtlAlt),0):-
	result_win(ResultWin),
	!,
	win_SetFocus(ResultWin).
  task_win_eh(_Win,e_Menu(id_file_new,_ShiftCtlAlt),0):-!,
	win_result_Create(_Win,ResultWin),
	assert(result_win(ResultWin)),
	!.
%END Task Window, id_file_new

%BEGIN Task Window, id_help_contents
  task_win_eh(_Win,e_Menu(id_help_contents,_ShiftCtlAlt),0):-!,
  	vpi_ShowHelp("xtemp.hlp"),
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
ifdef use_tbar
	toolbar_Resize(_Win),
enddef
ifdef use_message
	msg_Resize(_Win),
enddef
	!.
%END Task Window, e_Size

%END_WIN Task Window

/***************************************************************************
		Invoking on-line Help
***************************************************************************/

  project_ShowHelpContext(HelpTopic):-
  	vpi_ShowHelpContext("xtemp.hlp",HelpTopic).

/***************************************************************************
			Main Goal
***************************************************************************/

goal

ifdef use_mdi
  vpi_SetAttrVal(attr_win_mdi,b_true),
enddef
ifdef ws_win
  ifdef use_3dctrl
    vpi_SetAttrVal(attr_win_3dcontrols,b_true),
  enddef
enddef  
  vpi_Init(task_win_Flags,task_win_eh,task_win_Menu,"xtemp",task_win_Title).

%BEGIN_TLB Project toolbar, 23:50:24-1.12.1999, Code automatically updated!
/**************************************************************************
	Creation of toolbar: Project toolbar
**************************************************************************/

clauses

  tb_project_toolbar_Create(_Parent):-
ifdef use_tbar
	toolbar_create(tb_top,0xC0C0C0,_Parent,
		[tb_ctrl(id_file_new,pushb,idb_new_up,idb_new_dn,idb_new_up,"Open;Open Result window",1,1),
		 tb_ctrl(id_file_run,pushb,idb_open_up,idb_open_dn,idb_open_up,"Run;Run",1,1),
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


%BEGIN_TLB Help line, 22:31:34-1.12.1999, Code automatically updated!
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

constants

%BEGIN About dialog, CreateParms, 10:16:24-11.1.2000, Code automatically updated!
  dlg_about_dialog_ResID = idd_dlg_about
  dlg_about_dialog_DlgType = wd_Modal
  dlg_about_dialog_Help = idh_contents
%END About dialog, CreateParms

predicates

  dlg_about_dialog_eh : EHANDLER

clauses

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

%BEGIN_WIN Result
/**************************************************************************
	Creation and event handling for window: "Result"
**************************************************************************/

constants

%BEGIN Result, CreateParms, 23:48:36-1.12.1999, Code automatically updated!
  win_result_WinType = w_TopLevel
  win_result_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Maximize,wsf_Minimize,wsf_Close,wsf_ClipSiblings,wsf_HScroll]
  win_result_RCT = rct(100,80,525,400)
  win_result_Menu = res_menu(idr_task_menu)
  win_result_Title = "Result"
  win_result_Help = idh_contents
%END Result, CreateParms

predicates

  win_result_eh : EHANDLER

clauses

  win_result_Create(_Parent,ResultWin):-
ifdef use_editor
	Text = "",
	Font = font_Create(ff_Fixed,[],10),
	ReadOnly = b_true, Indent = b_true, InitPos = 1,
	ResultWin=edit_Create(win_result_WinType,win_result_RCT,win_result_Title,
		 win_result_Menu,_Parent,win_result_Flags,Font,ReadOnly,
		 Indent,Text,InitPos,win_result_eh),
enddef
	true.

%BEGIN Result, e_Create
  win_result_eh(_Win,e_Create(_),0):-!,
%BEGIN Result, InitControls, 23:48:36-1.12.1999, Code automatically updated!
%END Result, InitControls
%BEGIN Result, ToolbarCreate, 23:48:36-1.12.1999, Code automatically updated!
%END Result, ToolbarCreate
	menu_Enable(_Win,id_file_run,b_true),
	menu_Enable(_Win,id_file_new,b_false),
	!.
%END Result, e_Create

%BEGIN Result, e_Menu, Editor default popup menu 
  win_result_eh(_Win,e_Menu(ID,_CAS),0):-
	ID >= edit_MenuUndo, ID <= edit_MenuFont, 
	!,fail.
%END Result, e_Menu, Editor default popup menu
%MARK Result, new events

%BEGIN Result, e_CloseRequest
  win_result_eh(_Win,e_CloseRequest,0):-
	run_execute,
	!,
	assert(press_close_request),
	assert(stop_execute),
	win_Destroy(_Win).
  win_result_eh(_Win,e_CloseRequest,0):-!,
	win_Destroy(_Win),
	!.
%END Result, e_CloseRequest

%BEGIN Result, id_file_stop
  win_result_eh(_Win,e_Menu(id_file_stop,_ShiftCtlAlt),0):-!,
	assert(stop_execute),
	!.
%END Result, id_file_stop

%BEGIN Result, e_Destroy
  win_result_eh(_Win,e_Destroy,0):-
	retract(result_win(_Win)),
	!.
%END Result, e_Destroy

%BEGIN Result, id_file_run
  win_result_eh(_Win,e_Menu(id_file_run,_ShiftCtlAlt),0):-
	run_execute,
	Msg="Run process still active\n For stop process press F10",
	dlg_Note(Msg),
	!.
  win_result_eh(_Win,e_Menu(id_file_run,_ShiftCtlAlt),0):-
	menu_Enable(_Win,id_file_run,b_false),
	menu_Enable(_Win,id_file_stop,b_true),
	assert(run_execute),
	main(_Win),
	not(press_close_request),
	!,
	menu_Enable(_Win,id_file_run,b_true),
	menu_Enable(_Win,id_file_stop,b_false),
	retractall(_,xtemp),
	!.
  win_result_eh(_Win,e_Menu(id_file_run,_ShiftCtlAlt),0):-
	retract(press_close_request),
	retractall(_,xtemp),
	!.
%END Result, id_file_run

%BEGIN Result, id_edit_redo
  win_result_eh(_Win,e_Menu(id_edit_redo,_ShiftCtlAlt),0):-
	edit_PossibleUndoRedo(_Win,_,Redo),
	Redo=b_true,!,
	edit_Redo(_Win),
	!.
%END Result, id_edit_redo

%BEGIN Result, id_edit_undo
  win_result_eh(_Win,e_Menu(id_edit_undo,_ShiftCtlAlt),0):-
	edit_PossibleUndoRedo(_Win,Undo,_),
	Undo=b_true,!,
	edit_Undo(_Win),
	!.
%END Result, id_edit_undo

%BEGIN Result, id_edit_copy
  win_result_eh(_Win,e_Menu(id_edit_copy,_ShiftCtlAlt),0):-!,
	edit_Copy(_Win),
	!.
%END Result, id_edit_copy

%BEGIN Result, e_InitMenu
  win_result_eh(_Win,e_InitMenu,0):-!,
	edit_PossibleUndoRedo(_Win,Undo,Redo),
	check_SelectedText(_Win,Copy),
	menu_Enable(_Win,id_edit_undo,Undo),
	menu_Enable(_Win,id_edit_redo,Redo),
	menu_Enable(_Win,id_edit_copy,Copy),
	!.
%END Result, e_InitMenu

%BEGIN Result, e_Size
  win_result_eh(_Win,e_Size(_Width,_Height),0):-!,
ifdef use_tbar
	toolbar_Resize(_Win),
enddef
	!.
%END Result, e_Size

%BEGIN Result, e_Menu, Parent window 
  win_result_eh(Win,e_Menu(ID,CAS),0):-!,
	PARENT = win_GetParent(Win),
	win_SendEvent(PARENT,e_Menu(ID,CAS)),
	!.
%END Result, e_Menu, Parent window

%END_WIN Result
