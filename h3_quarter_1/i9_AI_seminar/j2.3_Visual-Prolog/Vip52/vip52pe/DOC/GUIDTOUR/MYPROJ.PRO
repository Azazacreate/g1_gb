/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  MYPROJ
 FileName: MYPROJ.PRO
 Purpose: A little Demo
 Written by: Leo Jensen
 Comments:
******************************************************************************/

include "myproj.inc"
include "myproj.con"
include "hlptopic.con"

%BEGIN_WIN Task Window
/***************************************************************************
		Event handling for Task Window
***************************************************************************/

predicates

  task_win_eh : EHANDLER

constants

%BEGIN Task Window, CreateParms, 10:07:54-24.11.1999, Code automatically updated!
  task_win_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Close,wsf_Maximize,wsf_Minimize,wsf_ClipSiblings,wsf_ClipChildren]
  task_win_Menu  = res_menu(idr_task_menu)
  task_win_Title = "Myproj"
  task_win_Help  = idh_contents
%END Task Window, CreateParms

clauses

%BEGIN Task Window, e_Create
  task_win_eh(_Win,e_Create(_),0):-!,
%	dde_Init([ddef_clientonly]),
%BEGIN Task Window, InitControls, 10:07:54-24.11.1999, Code automatically updated!
%END Task Window, InitControls
%BEGIN Task Window, ToolbarCreate, 10:07:54-24.11.1999, Code automatically updated!
	tb_project_toolbar_Create(_Win),
	tb_help_line_Create(_Win),
%END Task Window, ToolbarCreate
ifdef use_message
	msg_Create(100),
enddef
	
ifdef os_os2
	menu_Enable(_Win,id_Test_dde_test,b_false),
	menu_Enable(_Win,id_Test_directory_list,b_false),
enddef		
	!.
%END Task Window, e_Create

%MARK Task Window, new events

%BEGIN Task Window, id_edit_undo
  task_win_eh(_Win,e_Menu(id_edit_undo,_ShiftCtlAlt),0):-
	win_focus(Window),
	edit_PossibleUndoRedo(Window,Undo,_),
	Undo=b_true,!,
ifdef os_os2
	win_SetFocus(Window),
enddef
	edit_Undo(Window),
	!.
%END Task Window, id_edit_undo

%BEGIN Task Window, id_edit_redo
  task_win_eh(_Win,e_Menu(id_edit_redo,_ShiftCtlAlt),0):-
	win_focus(Window),
	edit_PossibleUndoRedo(Window,_,Redo),
	Redo=b_true,!,
ifdef os_os2
	win_SetFocus(Window),
enddef
	edit_Redo(Window),
	!.
%END Task Window, id_edit_redo

%BEGIN Task Window, id_edit_paste
  task_win_eh(_Win,e_Menu(id_edit_paste,_ShiftCtlAlt),0):-
	win_focus(Window),!,
ifdef os_os2
	win_SetFocus(Window),
enddef
	edit_Paste(Window),
	!.
%END Task Window, id_edit_paste

%BEGIN Task Window, id_edit_delete
  task_win_eh(_Win,e_Menu(id_edit_delete,_ShiftCtlAlt),0):-
	win_focus(Window),!,
	edit_Delete(Window),
	!.
%END Task Window, id_edit_delete

%BEGIN Task Window, id_edit_cut
  task_win_eh(_Win,e_Menu(id_edit_cut,_ShiftCtlAlt),0):-
	win_focus(Window),!,
ifdef os_os2
	win_SetFocus(Window),
enddef
	edit_Cut(Window),
	!.
%END Task Window, id_edit_cut

%BEGIN Task Window, id_edit_copy
  task_win_eh(_Win,e_Menu(id_edit_copy,_ShiftCtlAlt),0):-
	win_focus(Window),!,
ifdef os_os2
	win_SetFocus(Window),
enddef
	edit_Copy(Window),
	!.
%END Task Window, id_edit_copy

%BEGIN Task Window, id_help_contents
  task_win_eh(_Win,e_Menu(id_help_contents,_ShiftCtlAlt),0):-!,
  	vpi_ShowHelp("myproj.hlp"),
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

%BEGIN Task Window, id_hello
  task_win_eh(_Win,e_Menu(id_hello,_ShiftCtlAlt),0):-!,
	Title="Title",
	dlg_Note(Title,"Hello World"),
	!.
%END Task Window, id_hello

%BEGIN Task Window, id_Test_crosswin
  task_win_eh(_Win,e_Menu(id_Test_crosswin,_ShiftCtlAlt),0):-!,
	win_cross_Create(_Win),
	!.
%END Task Window, id_Test_crosswin

%BEGIN Task Window, id_Test_sweep_window
  task_win_eh(_Win,e_Menu(id_Test_sweep_window,_ShiftCtlAlt),0):-!,
	win_sweep_Create(_Win),
	!.
%END Task Window, id_Test_sweep_window

%BEGIN Task Window, id_Test_clock_window
  task_win_eh(_Win,e_Menu(id_Test_clock_window,_ShiftCtlAlt),0):-!,
	win_clock_Create(_Win),
	!.
%END Task Window, id_Test_clock_window

%BEGIN Task Window, id_Test_picture_window
  task_win_eh(_Win,e_Menu(id_Test_picture_window,_ShiftCtlAlt),0):-!,
	win_picture_Create(_Win),
	!.
%END Task Window, id_Test_picture_window

%BEGIN Task Window, id_Test_tree_window
  task_win_eh(_Win,e_Menu(id_Test_tree_window,_ShiftCtlAlt),0):-!,
	win_tree_window_Create(_Win),
	!.
%END Task Window, id_Test_tree_window

%BEGIN Task Window, id_Test_editor_window
  task_win_eh(_Win,e_Menu(id_Test_editor_window,_ShiftCtlAlt),0):-!,
	win_editor_Create(_Win),
	!.
%END Task Window, id_Test_editor_window

%BEGIN Task Window, id_Test_directory_list
  task_win_eh(_Win,e_Menu(id_Test_directory_list,_ShiftCtlAlt),0):-!,
	win_directory_Create(_Win),
	!.
%END Task Window, id_Test_directory_list

%BEGIN Task Window, id_Test_dialog
  task_win_eh(_Win,e_Menu(id_Test_dialog,_ShiftCtlAlt),0):-!,
	dlg_person_Create(_Win),
	!.
%END Task Window, id_Test_dialog

%BEGIN Task Window, id_Test_dde_test
ifdef os_os2 
  task_win_eh(_Win,e_Menu(id_Test_dde_test,_ShiftCtlAlt),0):-!,
	!.
/*
	trap(Conv = dde_Connect("WinWord","System"),_,write("WinWord not running\n")),
	filenamepath(FullName,"","..\\MYPROJ.PRO"),
	format(Command,"[FileOpen .Name=\"%\"]",FullName),
	write("DDE Command=",Command),nl,
	dde_Execute(Conv,Command,0),
	dde_DisConnect(Conv),
*/
elsedef
  task_win_eh(_Win,e_Menu(id_Test_dde_test,_ShiftCtlAlt),0):-!,
	trap(Conv = dde_Connect("WinWord","System"),_,write("WinWord not running\n")),
	filenamepath(FullName,"","..\\MYPROJ.PRO"),
	format(Command,"[FileOpen .Name=\"%\"]",FullName),
	write("DDE Command=",Command),nl,
	dde_Execute(Conv,Command,0),
	dde_DisConnect(Conv),
	!.
enddef	
%END Task Window, id_Test_dde_test

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

/***************************************************************************
			Main Goal Project
***************************************************************************/

goal

ifdef use_mdi
  vpi_SetAttrVal(attr_win_mdi,b_true),
enddef
ifdef use_3dctrl
  vpi_SetAttrVal(attr_win_3dcontrols,b_true),
enddef
ifdef use_tbar
  vpi_SetAttrVal(attr_win_tbar,use_tbar),
enddef
ifdef use_sbar
  vpi_SetAttrVal(attr_win_sbar,use_sbar),
enddef
  vpi_Init(task_win_Flags,task_win_eh,task_win_Menu,"myproj",task_win_Title).

%END_WIN Task Window

%BEGIN_TLB Project toolbar, 10:09:46-24.11.1999, Code automatically updated!
/**************************************************************************
	Creation of toolbar: Project toolbar
**************************************************************************/

clauses

  tb_project_toolbar_Create(_Parent):-
ifdef use_tbar
	toolbar_create(tb_top,0xC0C0C0,_Parent,
		[tb_ctrl(id_file_new,pushb,idb_new_up,idb_new_dn,idb_new_up,"New file",1,1),
		 tb_ctrl(id_file_open,pushb,idb_open_up,idb_open_dn,idb_open_up,"Open file",1,1),
		 tb_ctrl(id_file_save,pushb,idb_save_up,idb_save_dn,idb_save_up,"File save",1,1),
		 separator,
		 tb_ctrl(id_edit_undo,pushb,idb_undo_up,idb_undo_dn,idb_undo_up,"Undo",1,1),
		 tb_ctrl(id_edit_redo,pushb,idb_redo_up,idb_redo_dn,idb_redo_up,"Redo",1,1),
		 separator,
		 tb_ctrl(id_edit_cut,pushb,idb_cut_up,idb_cut_dn,idb_cut_up,"Cut to clipboard",1,1),
		 tb_ctrl(id_edit_copy,pushb,idb_copy_up,idb_copy_dn,idb_copy_up,"Copy to clipboard",1,1),
		 tb_ctrl(id_edit_paste,pushb,idb_paste_up,idb_paste_dn,idb_paste_up,"Paste from clipboard",1,1),
		 separator,
		 separator,
		 tb_ctrl(id_help_contents,pushb,idb_help_up,idb_help_down,idb_help_up,"Help",1,1)]),
enddef
	true.
%END_TLB Project toolbar

%BEGIN_DLG About dialog
/**************************************************************************
	Creation and event handling for dialog: About dialog
**************************************************************************/

constants

%BEGIN About dialog, CreateParms, 19:47:56-10.1.2000, Code automatically updated!
  dlg_about_dialog_ResID = idd_dlg_about
  dlg_about_dialog_DlgType = wd_Modal
  dlg_about_dialog_Help = idh_contents
%END About dialog, CreateParms

predicates

  dlg_about_dialog_eh : EHANDLER

clauses

  dlg_about_dialog_Create(Parent):-
	win_CreateResDialog(Parent,dlg_about_dialog_DlgType,dlg_about_dialog_ResID,dlg_about_dialog_eh,0),!.

%BEGIN About dialog, idc_ok _CtlInfo
  dlg_about_dialog_eh(_Win,e_Control(idc_ok,_CtrlType,_CtrlWin,_CtrlInfo),0):-!,
	win_Destroy(_Win),
	!.
%END About dialog, idc_ok _CtlInfo
%MARK About dialog, new events

%BEGIN About dialog, idc_help _CtlInfo
  dlg_about_dialog_eh(_,e_Control(idc_help,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	osversion(VerString),
	dlg_Note("",VerString),
	!.
%END About dialog, idc_help _CtlInfo

  dlg_about_dialog_eh(_,_,0):-!,fail.

%END_DLG About dialog

%BEGIN_TLB Help line, 10:09:52-24.11.1999, Code automatically updated!
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
