/*****************************************************************************

		 Copyright (c) 1984 - 2000 Prolog Development Center A/S

			VISUAL Prolog

 Project:  EDITOR
 FileName: EDITOR.PRO
 Purpose: Editor
 Written by: Ilyin Yuri
 Modifyed by: Eugene Akimov
 Comments:
******************************************************************************/

include "editor.inc"

DATABASE - edit_window
	edit_window(WINDOW,STRING FileName,STRING Data)
	count(INTEGER)
	edwin(string,boolean)

PREDICATES
	error_handler(STRING,INTEGER)
	close_window(Window,string,string,string)
	get_file_data(STRING,STRING,BOOLEAN)
	open_file(STRING,BOOLEAN)
	set_enabled_menu(WINDOW)
	get_title(STRING,STRING)
	next_filename(STRING)
	next_filename(STRING,STRING)
	save_as(WINDOW,STRING)
	final_prompt(WINDOW)
	clean_up_data(WINDOW)
	close_menu

CLAUSES
  error_handler(S,E) :-
	format(STR,"% - Error code = %",S,E),
	dlg_Error(STR).

  get_file_data(FileName,Text,_) :-
	FileName<>"",
	existfile(FileName),!,
	format(ERROR_MSG, "Unable to load file %", FileName),
	trap(file_str(FileName,Text),E,error_handler(ERROR_MSG,E)).
  get_file_data(_,"",b_true) :- !,
	Resp = dlg_Ask("","File does not exist. Create",["Yes", "No", ""]),
	Resp = resp_default.
  get_file_data(_,"",_).

  open_file(FileName,_) :-
	edit_window(EW,FileName,_),!,
	win_SetFocus(EW).
  open_file(FileName,Prompt) :-
	retractall(edwin(_,_)),
	assert(edwin(FileName,Prompt)),
	Task_Win=vpi_GetTaskWin(),
	win_editor_Create(Task_Win).

  set_enabled_menu(W) :-
	menu_Enable(W,id_file_save,b_true),
	menu_Enable(W,id_file_save_as,b_true),
	menu_Enable(W,id_edit_cut,b_true),
	menu_Enable(W,id_edit_copy,b_true),
	menu_Enable(W,id_edit_paste,b_true),
	menu_Enable(W,id_edit_delete,b_true),
	menu_Enable(W,id_edit_undo,b_true),
	menu_Enable(W,id_edit_redo,b_true).

  get_title(FileName,Title) :-
	filenamepath(FileName,_,Title),!.
  get_title(FileName,FileName).

  next_filename(FileName) :-
	retract(count(N)),
	N < 10000,!,
	disk(Path),
	format(FileName0,"%s\\FILE%u.LST",Path,N),
	N1 = N + 1,
	assert(count(N1)),
	next_filename(FileName0,FileName).
  next_filename(FileName) :-
	assert(count(0)),
	next_filename(FileName).

  next_filename(FileName0,FileName1) :-
	existfile(FileName0),!,
	next_filename(FileName1).
  next_filename(FileName,FileName).

  save_as(_,NewName) :-
	edit_window(_,NewName,_),!,
	dlg_Note("Can't write (process active)").
  save_as(_,NewName) :-
	existfile(NewName),
	format(Prompt,"Rewrite %s?",NewName),
	Resp = dlg_Ask("",Prompt,["Yes", "No", ""]),
	Resp <> resp_default,!.
  save_as(EW,NewName) :-
	Text = edit_GetText(EW),
	trap(file_str(NewName,Text),C,error_handler("Failed writing",C)),
	get_title(NewName,Title),
	win_SetText(EW,Title),
	retractall(edit_window(EW,_,_)),
	assert(edit_window(EW,NewName,Text)).

  final_prompt(EW) :-
	retract(edit_window(EW,FileName,OldData)),
	NewData = edit_GetText(EW),
	OldData <> NewData,
	get_title(FileName,Title),
	format(Prompt,"Save %s?",Title),
	Resp = dlg_Ask("",Prompt,["Yes", "No", ""]),
	Resp = resp_default,!,
	trap(file_str(FileName,NewData),C,error_handler("Failed writing",C)),fail.
  final_prompt(_).

  clean_up_data(EW) :-
	edit_window(EW,_,_),!,
	final_prompt(EW).
  clean_up_data(_) :-
	edit_window(EW,_,_),
	final_prompt(EW),fail.
  clean_up_data(W) :-
	retractall(_,edit_window),
	win_Destroy(W).

 close_window(_Win,_,NewData,OldData):-NewData=OldData,!,
 	close_menu,
 	win_Destroy(_Win).
 close_window(_Window,FileName,NewData,_):-
 	get_title(FileName,Title),
 	format(Prompt,"Save %s?",Title),
 	Resp=dlg_Ask("",Prompt,["Yes","No",""]),
	Resp = resp_default,!,
	trap(file_str(FileName,NewData),C,error_handler("Failed writing",C)),
	close_menu,
	win_Destroy(_Window).
/* EA 2.07.96 */
 close_window(_Window,_,_,_):-
	close_menu,
	win_Destroy(_Window).
/* */	
  close_menu:-edit_window(_,_,_),!.
  close_menu:-
	Task_Win=vpi_GetTaskWin(),
	menu_Enable(Task_Win,id_file_save,b_false),
	menu_Enable(Task_Win,id_file_save_as,b_false),
	menu_Enable(Task_Win,id_edit_cut,b_false),
	menu_Enable(Task_Win,id_edit_copy,b_false),
	menu_Enable(Task_Win,id_edit_paste,b_false),
	menu_Enable(Task_Win,id_edit_delete,b_false),
	menu_Enable(Task_Win,id_edit_undo,b_false),
	menu_Enable(Task_Win,id_edit_redo,b_false).

%BEGIN_WIN Task Window
/***************************************************************************
		Event handling for task window
***************************************************************************/

PREDICATES

  task_win_eh : EHANDLER

CONSTANTS

%BEGIN Task Window, CreateParms, 18:49:16-23.11.1999, Code automatically updated!
  task_win_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Close,wsf_Maximize,wsf_Minimize,wsf_ClipSiblings,wsf_ClipChildren]
  task_win_Menu  = res_menu(idr_task_menu)
  task_win_Title = "Editor"
  task_win_Help  = idh_contents
%END Task Window, CreateParms

CLAUSES

%BEGIN Task Window, e_Create
  task_win_eh(_Win,e_Create(_),0):-!,
%BEGIN Task Window, InitControls, 18:49:16-23.11.1999, Code automatically updated!
%END Task Window, InitControls
%BEGIN Task Window, ToolbarCreate, 18:49:16-23.11.1999, Code automatically updated!
%END Task Window, ToolbarCreate
IFDEF use_message
	msg_Create(100),
ENDDEF
	!.
%END Task Window, e_Create

%MARK Task Window, new events

%BEGIN Task Window, id_help_contents
IFDEF use_on_line_help
  task_win_eh(_Win,e_Menu(id_help_contents,_ShiftCtlAlt),0):-!,
	vpi_ShowHelp("editor.hlp"),
	!.
ENDDEF
%END Task Window, id_help_contents

%BEGIN Task Window, id_help_about
  task_win_eh(_Win,e_Menu(id_help_about,_ShiftCtlAlt),0):-!,
	dlg_about_dialog_Create(_Win),
	!.
%END Task Window, id_help_about

%BEGIN Task Window, id_file_exit
  task_win_eh(_Win,e_Menu(id_file_exit,_ShiftCtlAlt),0):-!,
	Task_Win=vpi_GetTaskWin(),
	win_SendEvent(TASK_WIN,e_CloseRequest),
	!.
%END Task Window, id_file_exit

%BEGIN Task Window, e_CloseRequest
  task_win_eh(_Win,e_CloseRequest,0):-!,
	clean_up_data(_Win),!,fail.
%END Task Window, e_CloseRequest
%BEGIN Task Window, id_file_open
  task_win_eh(_Win,e_Menu(id_file_open,_ShiftCtlAlt),0):-
	FileName = dlg_GetFileName("*.*",["*.*","*.*"],"Open file",[dlgfn_MultiSel],"", _OutListFiles ),
	FileName<>"",!,
	open_file(FileName,b_true),
	!.
  task_win_eh(_Win,e_Menu(id_file_open,_ShiftCtlAlt),0):-
%	next_filename(FileName),
%	open_file(FileName,b_true),
	!.
%END Task Window, id_file_open
%BEGIN Task Window, id_file_new
  task_win_eh(_Win,e_Menu(id_file_new,_ShiftCtlAlt),0):-!,
	next_filename(FileName),
	open_file(FileName,b_false),
	!.
%END Task Window, id_file_new
%BEGIN Task Window, id_file_save
  task_win_eh(_Win,e_Menu(id_file_save,_ShiftCtlAlt),0):-!,
	EW = win_GetFocus(),
	edit_window(EW,FileName,OldText),
	Text = edit_GetText(EW),
	OldText <> Text,
	trap(file_str(FileName,Text),C,error_handler("Failed writing",C)),
	retractall(edit_window(EW,_,_)),
	assert(edit_window(EW,FileName,Text)),
	!.
%END Task Window, id_file_save
%BEGIN Task Window, id_file_save_as
  task_win_eh(_Win,e_Menu(id_file_save_as,_ShiftCtlAlt),0):-
	NewName = dlg_GetFileName("*.lst", ["All files","*.*"],"Save file",[dlgfn_Save],"", _OutListFiles ),
	EW = win_GetFocus(),
	edit_window(EW,OldName,_),
	OldName <> NewName,!,
	save_as(EW,NewName)
	;
	EW = win_GetFocus(),
	edit_window(EW,Name,OldText),
	Text = edit_GetText(EW),
	OldText <> Text,!,
	trap(file_str(Name,Text),C,error_handler("Failed writing",C)),
	retractall(edit_window(EW,_,_)),
	assert(edit_window(EW,Name,Text)).

%END Task Window, id_file_save_as
%BEGIN Task Window, id_edit_undo
  task_win_eh(_Win,e_Menu(id_edit_undo,_ShiftCtlAlt),0):-
	_Window=win_GetFocus(),
	edit_window(_Window,_,_),
	edit_PossibleUndoRedo(_Window,Undo, _Redo),
	Undo=b_true,!,
	edit_Undo(_Window),
	!.
  task_win_eh(_Win,e_Menu(id_edit_undo,_ShiftCtlAlt),0):-!,
  	!.
%END Task Window, id_edit_undo
%BEGIN Task Window, id_edit_redo
  task_win_eh(_Win,e_Menu(id_edit_redo,_ShiftCtlAlt),0):-
	_Window=win_GetFocus(),
	edit_window(_Window,_,_),
	edit_PossibleUndoRedo(_Window, _Undo,Redo),
	Redo=b_true,!,
	edit_Redo(_Window),
	!.
  task_win_eh(_Win,e_Menu(id_edit_redo,_ShiftCtlAlt),0):-!,
  	!.
%END Task Window, id_edit_redo
%BEGIN Task Window, id_edit_cut
  task_win_eh(_Win,e_Menu(id_edit_cut,_ShiftCtlAlt),0):-
	_Window=win_GetFocus(),
	edit_window(_Window,_,_),!,
	edit_Cut(_Window),
	!.
%END Task Window, id_edit_cut
%BEGIN Task Window, id_edit_copy
  task_win_eh(_Win,e_Menu(id_edit_copy,_ShiftCtlAlt),0):-
	_Window=win_GetFocus(),
	edit_window(_Window,_,_),!,
	edit_Copy(_Window),
	!.
%END Task Window, id_edit_copy
%BEGIN Task Window, id_edit_paste
  task_win_eh(_Win,e_Menu(id_edit_paste,_ShiftCtlAlt),0):-
	_Window=win_GetFocus(),
	edit_window(_Window,_,_),!,
	edit_Paste(_Window),
	!.
%END Task Window, id_edit_paste
%BEGIN Task Window, id_edit_delete
  task_win_eh(_Win,e_Menu(id_edit_delete,_ShiftCtlAlt),0):-
	_Window=win_GetFocus(),
	edit_window(_Window,_,_),!,
	edit_Delete(_Window),
	!.
%END Task Window, id_edit_delete
%BEGIN Task Window, e_Size
  task_win_eh(_Win,e_Size(_Width,_Height),0):-!,
IFDEF use_tbar
	toolbar_Resize(_Win),
ENDDEF
IFDEF use_message
	msg_Resize(_Win),
ENDDEF
	!,fail.
%END Task Window, e_Size

/***************************************************************************
			Main Goal Project
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
  vpi_Init(task_win_Flags,task_win_eh,task_win_Menu,"editor",task_win_Title).

%END_WIN Task Window

%BEGIN_TLB Help line, 13:25:05-28.2.1995
/**************************************************************************
		Creation to toolbar: Help line
**************************************************************************/

CLAUSES

  tb_help_line_Create(_Parent):-
IFDEF use_tbar
	toolbar_create(tb_bottom,0x808080,_Parent,
		[tb_text(idt_help_line,tb_context,452,0,4,10,0,"")]),
ENDDEF
	!.
%END_TLB Help line


%BEGIN_WIN Editor
/**************************************************************************
	Creation and event handling for window: "Editor"
**************************************************************************/

CONSTANTS

%BEGIN Editor, CreateParms, 18:49:50-23.11.1999, Code automatically updated!
  win_editor_WinType = w_TopLevel
  win_editor_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Maximize,wsf_Minimize,wsf_Close,wsf_ClipSiblings,wsf_ClipChildren,wsf_VScroll,wsf_HScroll]
  win_editor_RCT = rct(100,80,440,240)
  win_editor_Menu = no_menu
  win_editor_Title = "Editor"
  win_editor_Help = idh_contents
%END Editor, CreateParms

PREDICATES

  win_editor_eh : EHANDLER

CLAUSES

  win_editor_Create(Parent):-
IFDEF use_editor
	edwin(FileName,Prompt),
	CRCT = win_GetClientRect(Parent),
	CRCT = rct(L,T,R,B),
	L1 = L + 50,
	T1 = T + 50,
	R1 = R - 50,
	B1 = B - 50,
	get_file_data(FileName,Text,Prompt),
	get_title(FileName,Title),
	Font = font_Create(ff_Fixed,[],10),
	ReadOnly = b_false, Indent = b_true, InitPos = 1,
	EW=edit_Create(win_editor_WinType,rct(L1,T1,R1,B1),Title,
		 win_editor_Menu,Parent,win_editor_Flags,Font,ReadOnly,
		 Indent,Text,InitPos,win_editor_eh),
ENDDEF
	set_enabled_menu(Parent),
	assert(edit_window(EW,FileName,Text)),
	!.

%BEGIN Editor, e_Create
  win_editor_eh(_Win,e_Create(_),0):-!,
%BEGIN Editor, InitControls, 18:49:50-23.11.1999, Code automatically updated!
%END Editor, InitControls
%BEGIN Editor, ToolbarCreate, 18:49:50-23.11.1999, Code automatically updated!
%END Editor, ToolbarCreate
	!.
%END Editor, e_Create

%BEGIN Editor, e_Menu, Editor default popup menu 
  win_editor_eh(_Win,e_Menu(ID,_CAS),0):-
	ID >= edit_MenuUndo, ID <= edit_MenuFont, 
	!,fail.
%END Editor, e_Menu, Editor default popup menu

%BEGIN Editor, e_User
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
%END Editor, e_User
%MARK Editor, new events

%BEGIN Editor, e_CloseRequest
  win_editor_eh(_Win,e_CloseRequest,0):-!,
	 _Window =win_GetFocus(),
	 retract(edit_window(_Window,FileName,OldData)),
	 NewData=edit_GetText(_Window),
	 close_window(_Window,FileName,NewData,OldData),
	!.
%END Editor, e_CloseRequest

%BEGIN Editor, e_Size
  win_editor_eh(_Win,e_Size(_Width,_Height),0):-!,
IFDEF use_tbar
	toolbar_Resize(_Win),
ENDDEF
	!.
%END Editor, e_Size

%BEGIN Editor, e_Menu, Parent window 
  win_editor_eh(Win,e_Menu(ID,CAS),0):-!,
	PARENT = win_GetParent(Win),
	win_SendEvent(PARENT,e_Menu(ID,CAS)),
	!.
%END Editor, e_Menu, Parent window

%END_WIN Editor










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
	win_CreateResDialog(Parent,dlg_about_dialog_DlgType,dlg_about_dialog_ResID,dlg_about_dialog_eh,0).

%BEGIN About dialog, idc_ok _CtlInfo
  dlg_about_dialog_eh(_Win,e_Control(idc_ok,_CtrlType,_CtrlWin,_CtrlInfo),0):-!,
	win_Destroy(_Win),
	!.
%END About dialog, idc_ok _CtlInfo
%MARK About dialog, new events

  dlg_about_dialog_eh(_,_,_):-!,fail.

%END_DLG About dialog











