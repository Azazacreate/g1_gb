/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  PARSER
 FileName: PARSER.PRO
 Purpose: Parser Generator
 Written by: Eugene Akimov
 Comments:
******************************************************************************/

include "parser.inc"
include "parser.con"
include "hlptopic.con"

PREDICATES
	close_file(WINDOW)
	close_menu(WINDOW)
	select(WINDOW,integer)
	set_enabled_menu(WINDOW)
	check_edit(string,string,string,integer)
	close_update_file(WINDOW)
	close_update_file1(WINDOW)
	
CLAUSES
  close_file(_Win):-
	editwin(Window,FileName,Text),
	NewText=edit_GetText(Window),
	check_edit(FileName,NewText,Text,Ans),
	select(_Win,Ans),
	win_Destroy(Window),
	retract(editwin(Window,FileName,Text)),
	fail.
  close_file(_Win).	
		
  set_enabled_menu(W) :-
	menu_Enable(W,id_file_save,b_true),
	menu_Enable(W,id_file_save_as,b_true),
	menu_Enable(W,id_edit_cut,b_true),
	menu_Enable(W,id_edit_copy,b_true),
	menu_Enable(W,id_edit_paste,b_true),
	menu_Enable(W,id_edit_delete,b_true),
	menu_Enable(W,id_edit_undo,b_true),
	menu_Enable(W,id_edit_redo,b_true).

  check_edit(_,Text,Text,1):-!.
  check_edit(FileName,New_Text,Text,_ANSWER):-New_Text<>Text,
	Title="Ask",
	String="Do you want to save changes to \n\n",
	concat(String,FileName,FinalTxt),
	_ANSWER = dlg_Ask(Title,FinalTxt/*Prompt*/,["Yes","No"]/*ButtonTitlesList*/).

  select(_Win,1):-!.
  select(_Win,_):-new_file,!,
	win_SendEvent(_Win,e_Menu(id_file_save_as,c_ShiftCtlAlt)),
	retractall(new_file).
  select(_Win,_):-
	win_SendEvent(_Win,e_Menu(id_file_save,c_ShiftCtlAlt)).

  close_update_file(_Win):-
	win_focus(Window),
	editwin(Window,FileName,Text),
	NewText=edit_GetText(_Win),
	check_edit(FileName,NewText,Text,Ans),
	select(_Win,Ans),
	retract(editwin(Window,FileName,Text)),
	close_menu(_Win),
	win_Destroy(Window),
	fail.
  close_update_file(_Win).

  close_update_file1(_Win):-
	editwin(Window,FileName,Text),
	NewText=edit_GetText(Window),
	check_edit(FileName,NewText,Text,Ans),
	select(_Win,Ans),
	retract(editwin(Window,FileName,Text)),
	win_Destroy(Window),
	fail.
  close_update_file1(_Win):-editwin(_,_,_),!.
  close_update_file1(_Win):-
	win_Destroy(_Win).

  close_menu(_Win):-editwin(_,_,_),!.
  close_menu(_Win):-
	W=win_GetParent(_Win),
	menu_Enable(W,id_file_save,b_false),
	menu_Enable(W,id_file_save_as,b_false),
	menu_Enable(W,id_edit_cut,b_false),
	menu_Enable(W,id_edit_copy,b_false),
	menu_Enable(W,id_edit_paste,b_false),
	menu_Enable(W,id_edit_delete,b_false),
	menu_Enable(W,id_edit_undo,b_false),
	menu_Enable(W,id_edit_redo,b_false),
	menu_Enable(W,id_generate,b_false),
	menu_Enable(W,id_Display_domain,b_false),
	menu_Enable(W,id_Display_predicates,b_false),
	menu_Update(W).

/* Check Selection */
predicates
  check_EditSelection(WINDOW EditWin,boolean Cut,boolean Copy,boolean Delete) - procedure (i,o,o,o)

clauses
  check_EditSelection(_Win,b_false,b_false,b_false):-
	edit_GetSelection(_Win,StartPos,EndPos),
	StartPos=EndPos,
	StartPos=0,!.
  check_EditSelection(_Win,b_true,b_true,b_true).

/* Check Possible Paste */
predicates
  check_EditPaste(boolean Paste) - procedure (o)

clauses
  check_EditPaste(b_true):-
	Str=cb_GetString(),
	Str<>"",!.
  check_EditPaste(b_false).

include "writedom.pro"
include "writepre.pro"

%BEGIN_WIN Task Window
/***************************************************************************
	Event handling for Task Window
***************************************************************************/

PREDICATES

  task_win_eh : EHANDLER

CONSTANTS

%BEGIN Task Window, CreateParms, 19:04:12-25.11.1999, Code automatically updated!
  task_win_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Close,wsf_Maximize,wsf_Minimize,wsf_ClipSiblings]
  task_win_Menu  = res_menu(idr_task_menu)
  task_win_Title = "Parser Generator"
  task_win_Help  = idh_contents
%END Task Window, CreateParms

CLAUSES

%BEGIN Task Window, e_Create
  task_win_eh(_Win,e_Create(_),0):-!,
%BEGIN Task Window, InitControls, 19:04:12-25.11.1999, Code automatically updated!
%END Task Window, InitControls
%BEGIN Task Window, ToolbarCreate, 19:04:12-25.11.1999, Code automatically updated!
	tb_status_line_Create(_Win),
	tb_project_toolbar_Create(_Win),
%END Task Window, ToolbarCreate
IFDEF use_message
	msg_Create(100),
ENDDEF
	menu_Enable(_Win,id_Display_domain,b_false),
	menu_Enable(_Win,id_Display_predicates,b_false),
	menu_Enable(_Win,id_generate,b_false),
	!.
%END Task Window, e_Create

%MARK Task Window, new events

%BEGIN Task Window, e_CloseRequest
  task_win_eh(_Win,e_CloseRequest,0):-!,
	close_update_file1(_Win),
	!.
%END Task Window, e_CloseRequest
                                               
%BEGIN Task Window, id_generate
  task_win_eh(_Win,e_Menu(id_generate,_ShiftCtlAlt),0):-
	win_focus(Window),!,
	Text=edit_GetText(Window),
	change_grammar(Text),
	generate_parser(_Win,Window),
	!.
  task_win_eh(_Win,e_Menu(id_generate,_ShiftCtlAlt),0):-!,
  	dlg_Note("Warning","Grammar file not open"),
  	!.
%END Task Window, id_generate

%BEGIN Task Window, id_Display_domain
  task_win_eh(_Win,e_Menu(id_Display_domain,_ShiftCtlAlt),0):-!,
	display_domain_definftions(_Win),
	!.
%END Task Window, id_Display_domain

%BEGIN Task Window, id_Display_predicates
  task_win_eh(_Win,e_Menu(id_Display_predicates,_ShiftCtlAlt),0):-!,
	display_parsing_predicates(_Win),
	!.
%END Task Window, id_Display_predicates

%BEGIN Task Window, id_file_save
  task_win_eh(_Win,e_Menu(id_file_save,_ShiftCtlAlt),0):-!,
	TB_VALUE1=text_value("Save file"),
	toolbar_SetValue(_Win,idt_status_line_2,TB_VALUE1),
	editwin(Window,_FILENAME,_),
	_Text=edit_GetText(Window),
	file_str(_FILENAME,_Text),
	TB_VALUE2=text_value(""),
	toolbar_SetValue(_Win,idt_status_line_2,TB_VALUE2),
	!.
%END Task Window, id_file_save

%BEGIN Task Window, id_file_new
  task_win_eh(_Win,e_Menu(id_file_new,_ShiftCtlAlt),0):-!,
	close_file(_Win),
	TB_VALUE1=text_value("Create new file"),
	toolbar_SetValue(_Win,idt_status_line_2,TB_VALUE1),
	new_grammar(_Win),
	menu_Enable(_Win,id_file_save,b_true),
	menu_Enable(_Win,id_file_save_as,b_true),
	menu_Enable(_Win,id_Display_domain,b_true),
	menu_Enable(_Win,id_Display_predicates,b_true),
	menu_Enable(_Win,id_generate,b_true),
	menu_Update(_Win),
	asserta(new_file),
	TB_VALUE2=text_value(""),
	toolbar_SetValue(_Win,idt_status_line_2,TB_VALUE2),
	!.
%END Task Window, id_file_new

%BEGIN Task Window, id_file_save_as
  task_win_eh(_Win,e_Menu(id_file_save_as,_ShiftCtlAlt),0):-!,
  	Title="Save Grammar",
  	_FILENAME = dlg_GetSaveFileName("*.grm"/*Mask*/,["*.*","*.*"],Title),
	_FILENAME<>"",
	TB_VALUE1=text_value("Save grammar file"),
	toolbar_SetValue(_Win,idt_status_line_2,TB_VALUE1),
	editwin(Window,_,_),
	_Text=edit_GetText(Window),
	file_str(_FILENAME,_Text),
	win_SetText(Window,_FILENAME),
	TB_VALUE2=text_value(""),
	toolbar_SetValue(_Win,idt_status_line_2,TB_VALUE2),
	!.
%END Task Window, id_file_save_as

%BEGIN Task Window, id_edit_undo		
  task_win_eh(_Win,e_Menu(id_edit_undo,_ShiftCtlAlt),0):-
	win_focus(Window),
	edit_PossibleUndoRedo(Window,Undo,_),
	Undo=b_true,!,
	edit_Undo(Window),
	!.
%END Task Window, id_edit_undo

%BEGIN Task Window, id_edit_redo
  task_win_eh(_Win,e_Menu(id_edit_redo,_ShiftCtlAlt),0):-
	win_focus(Window),
	edit_PossibleUndoRedo(Window,_,Redo),
	Redo=b_true,!,
	edit_Redo(Window),
	!.
%END Task Window, id_edit_redo

%BEGIN Task Window, id_edit_paste
  task_win_eh(_Win,e_Menu(id_edit_paste,_ShiftCtlAlt),0):-
	win_focus(Window),!,
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
	edit_Cut(Window),
	!.
%END Task Window, id_edit_cut

%BEGIN Task Window, id_edit_copy
  task_win_eh(_Win,e_Menu(id_edit_copy,_ShiftCtlAlt),0):-
	win_focus(Window),!,
	edit_Copy(Window),
	!.
%END Task Window, id_edit_copy

%BEGIN Task Window, id_file_open
  task_win_eh(_Win,e_Menu(id_file_open,_ShiftCtlAlt),0):-!,
  	Title="Load Grammar",
	_FILENAME=dlg_GetFileName("*.grm",["*.grm","*.grm","*.*","*.*"],Title,[],"",_),
	_FILENAME<>"",!,
	close_file(_Win),	
	TB_VALUE1=text_value("Load grammar file"),
	toolbar_SetValue(_Win,idt_status_line_2,TB_VALUE1),
	load_grammar(_Win,_FILENAME),
	menu_Enable(_Win,id_file_save,b_true),
	menu_Enable(_Win,id_file_save_as,b_true),
	menu_Enable(_Win,id_Display_domain,b_true),
	menu_Enable(_Win,id_Display_predicates,b_true),
	menu_Enable(_Win,id_generate,b_true),
	menu_Update(_Win),
	TB_VALUE2=text_value(""),
	toolbar_SetValue(_Win,idt_status_line_2,TB_VALUE2),
	!.
%END Task Window, id_file_open

%BEGIN Task Window, id_help_contents
  task_win_eh(_Win,e_Menu(id_help_contents,_ShiftCtlAlt),0):-!,
  	vpi_ShowHelp("parser.hlp"),
	!.
%END Task Window, id_help_contents

%BEGIN Task Window, id_help_about
  task_win_eh(Win,e_Menu(id_help_about,_ShiftCtlAlt),0):-!,
	dlg_about_dialog_Create(Win),
	!.
%END Task Window, id_help_about

%BEGIN Task Window, id_file_exit
  task_win_eh(_Win,e_Menu(id_file_exit,_ShiftCtlAlt),0):-!,
	close_update_file1(_Win),
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
  	vpi_ShowHelpContext("parser.hlp",HelpTopic),!.

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
IFDEF use_tbar
  vpi_SetAttrVal(attr_win_tbar,use_tbar),
ENDDEF
IFDEF use_sbar
  vpi_SetAttrVal(attr_win_sbar,use_sbar),
ENDDEF
  vpi_Init(task_win_Flags,task_win_eh,task_win_Menu,"parser",task_win_Title).


%BEGIN_TLB Project toolbar, 19:04:36-25.11.1999, Code automatically updated!
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
		 tb_ctrl(id_generate,pushb,idb_flower_up,idb_flower_down,idb_flower_up,"Generate",1,1),
		 separator,
		 tb_ctrl(id_help_contents,pushb,idb_help_up,idb_help_down,idb_help_up,"Help;Help",0,1)]),
enddef
	true.
%END_TLB Project toolbar





















%BEGIN_DLG About dialog
/**************************************************************************
	Creation and event handling for dialog: About dialog
**************************************************************************/

CONSTANTS

%BEGIN About dialog, CreateParms, 10:16:24-11.1.2000, Code automatically updated!
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


%BEGIN_TLB status line, 19:04:28-25.11.1999, Code automatically updated!
/**************************************************************************
	Creation of toolbar: status line
**************************************************************************/

clauses

  tb_status_line_Create(_Parent):-
ifdef use_tbar
	toolbar_create(tb_bottom,0xC0C0C0,_Parent,
		[tb_text(idt_status_line_1,tb_context,264,0,1,10,0x0,""),
		 tb_text(idt_status_line_2,tb_static,200,0,1,10,0x0,"")]),
enddef
	true.
%END_TLB status line


%BEGIN_WIN EDITOR
/**************************************************************************
	Creation and event handling for window: "EDITOR"
**************************************************************************/

CONSTANTS

%BEGIN EDITOR, CreateParms, 09:24:44-10.12.1999, Code automatically updated!
  win_editor_WinType = w_TopLevel
  win_editor_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Maximize,wsf_Minimize,wsf_Close,wsf_ClipSiblings,wsf_HScroll,wsf_VScroll]
  win_editor_RCT = rct(10,30,463,232)
  win_editor_Menu = res_menu(idr_task_menu)
  win_editor_Title = "Editor"
  win_editor_Help = idh_contents
%END EDITOR, CreateParms

PREDICATES

  win_editor_eh : EHANDLER

CLAUSES

  win_editor_Create(Parent):-
IFDEF use_editor
	options(FileName,Text,Title),!,
	upper_lower(OutTitle,Title),
	RCT=win_GetClientRect(Parent),
	RCT=rct(_,_,Right,Bottom),
	New_Right=Right-10,
	New_Bottom=Bottom-65,
	RCT1=rct(10,30,New_Right,New_Bottom),
	Font = font_Create(ff_Fixed,[],10),
	ReadOnly = b_false, Indent = b_true, InitPos = 1,
	Window=edit_Create(win_editor_WinType,RCT1,OutTitle,
		 win_editor_Menu,Parent,win_editor_Flags,Font,ReadOnly,
		 Indent,Text,InitPos,win_editor_eh),
ENDDEF
	asserta(editwin(Window,FileName,Text)),
	change_grammar(Text),
	set_enabled_menu(Parent),
	!.

%BEGIN EDITOR, e_Create
  win_editor_eh(_Win,e_Create(_),0):-!,
%BEGIN EDITOR, InitControls, 09:24:44-10.12.1999, Code automatically updated!
%END EDITOR, InitControls
%BEGIN EDITOR, ToolbarCreate, 09:24:44-10.12.1999, Code automatically updated!
%END EDITOR, ToolbarCreate
	!.
%END EDITOR, e_Create

%BEGIN EDITOR, e_Menu, Editor default popup menu 
  win_editor_eh(_Win,e_Menu(ID,_CAS),0):-
	ID >= edit_MenuUndo, ID <= edit_MenuFont, 
	!,fail.
%END EDITOR, e_Menu, Editor default popup menu

%BEGIN EDITOR, e_User
% Help button in dialog "Find Text"
  win_editor_eh(_Win,e_User(idc_help,edit_HelpFind),0):-!,
	!.
% Help button in dialog "Replace Text"
  win_editor_eh(_Win,e_User(idc_help,edit_HelpReplace),0):-!,
	!.
% Help button in dialog "Go To Line"
  win_editor_eh(_Win,e_User(idc_help,edit_HelpLine),0):-!,
	!.
% Help button in dialog "Go To Position"
  win_editor_eh(_Win,e_User(idc_help,edit_HelpPos),0):-!,
	!.
% Help button in dialog "Editor Options"
  win_editor_eh(_Win,e_User(idc_help,edit_HelpOptions),0):-!,
	!.
%END EDITOR, e_User
%MARK EDITOR, new events

%BEGIN EDITOR, e_InitMenu
  win_editor_eh(_Win,e_InitMenu,0):-!,
	edit_PossibleUndoRedo(_Win,Undo,Redo),
	check_EditSelection(_Win,Cut,Copy,Delete),
	check_EditPaste(Paste),
	menu_Enable(_Win,id_edit_undo,Undo),
	menu_Enable(_Win,id_edit_redo,Redo),
	menu_Enable(_Win,id_edit_cut,Cut),
	menu_Enable(_Win,id_edit_copy,Copy),
	menu_Enable(_Win,id_edit_delete,Delete),
	menu_Enable(_Win,id_edit_Paste,Paste),

	!.
%END EDITOR, e_InitMenu

%BEGIN EDITOR, e_Destroy
  win_editor_eh(_Win,e_Destroy,0):-
	retract(win_focus(_Win)),
	!.
%END EDITOR, e_Destroy

%BEGIN EDITOR, e_GetFocus
  win_editor_eh(_Win,e_GetFocus,0):-!,
	retractall(_,db2),
	assert(win_focus(_Win)),
	!.
%END EDITOR, e_GetFocus

%BEGIN EDITOR, e_CloseRequest
  win_editor_eh(_Win,e_CloseRequest,0):-
	close_update_file(_Win),
	!.
%END EDITOR, e_CloseRequest

%BEGIN EDITOR, e_Size
  win_editor_eh(_Win,e_Size(_Width,_Height),0):-!,
IFDEF use_tbar
	toolbar_Resize(_Win),
ENDDEF
	!.
%END EDITOR, e_Size

%BEGIN EDITOR, e_Menu, Parent window 
  win_editor_eh(Win,e_Menu(ID,CAS),0):-!,
	PARENT = win_GetParent(Win),
	win_SendEvent(PARENT,e_Menu(ID,CAS)),
	!.
%END EDITOR, e_Menu, Parent window

%END_WIN EDITOR




























