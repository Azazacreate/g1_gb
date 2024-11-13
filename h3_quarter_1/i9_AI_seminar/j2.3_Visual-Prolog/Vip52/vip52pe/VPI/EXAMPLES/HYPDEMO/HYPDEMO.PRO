/*****************************************************************************

		 Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  HYPDEMO
 FileName: HYPDEMO.PRO
 Purpose: Simple HyperEditor example
 Written by: Eugene Akimov
 Comments:
******************************************************************************/

include "hypdemo.inc"
include "hypdemo.con"
include "hlptopic.con"

DATABASE - db
	win(WINDOW)
	
PREDICATES
	hidden_text(STRING,STRING)

CLAUSES
  hidden_text("","No hidden text") :- !.
  hidden_text(Text,Text) :- !.

%BEGIN_WIN Task Window
/***************************************************************************
	Event handling for Task Window
***************************************************************************/

PREDICATES

  task_win_eh : EHANDLER

CONSTANTS

%BEGIN Task Window, CreateParms, 19:50:40-23.11.1999, Code automatically updated!
  task_win_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Close,wsf_Maximize,wsf_Minimize,wsf_ClipSiblings]
  task_win_Menu  = res_menu(idr_task_menu)
  task_win_Title = "Hypdemo"
  task_win_Help  = idh_contents
%END Task Window, CreateParms

CLAUSES

%BEGIN Task Window, e_Create
  task_win_eh(_Win,e_Create(_),0):-!,
%BEGIN Task Window, InitControls, 19:50:40-23.11.1999, Code automatically updated!
%END Task Window, InitControls
%BEGIN Task Window, ToolbarCreate, 19:50:40-23.11.1999, Code automatically updated!
%END Task Window, ToolbarCreate
IFDEF use_message
	msg_Create(100),
ENDDEF
	win_hypereditor_Create(_Win),
	!.
%END Task Window, e_Create

%MARK Task Window, new events

%BEGIN Task Window, id_delete
  task_win_eh(_Win,e_Menu(id_delete,_ShiftCtlAlt),0):-!,
	win(W),
	edit_DeleteHyperField(W),
	!.
%END Task Window, id_delete

%BEGIN Task Window, id_create
  task_win_eh(_Win,e_Menu(id_create,_ShiftCtlAlt),0):-
	win(W),
	edit_GetSelection(W,SPos,EPos),
	SPos<>EPos,!,
	Msg="Type in hyperfield <HiddenText>",
	InitStr="",
	Title="Setting",
	NewSTRING=dlg_GetStr(Title,Msg,InitStr),
	edit_CreateHyperField(W,NewSTRING),
	!.
  task_win_eh(_Win,e_Menu(id_create,_ShiftCtlAlt),0):-!,
	dlg_Note("Not selected text"),
	!.
%END Task Window, id_create

%BEGIN Task Window, id_help_contents
  task_win_eh(_Win,e_Menu(id_help_contents,_ShiftCtlAlt),0):-!,
  	vpi_ShowHelp("hypdemo.hlp"),
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
  	vpi_ShowHelpContext("hypdemo.hlp",HelpTopic),!.

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
  vpi_Init(task_win_Flags,task_win_eh,task_win_Menu,"hypdemo",task_win_Title).

%BEGIN_DLG About dialog
/**************************************************************************
	Creation and event handling for dialog: About dialog
**************************************************************************/

CONSTANTS

%BEGIN About dialog, CreateParms, 19:50:30-23.11.1999, Code automatically updated!
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

%BEGIN_WIN HyperEditor
/**************************************************************************
	Creation and event handling for window: "HyperEditor"
**************************************************************************/

CONSTANTS

%BEGIN HyperEditor, CreateParms, 19:50:36-23.11.1999, Code automatically updated!
  win_hypereditor_WinType = w_TopLevel
  win_hypereditor_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Maximize,wsf_Minimize,wsf_ClipSiblings,wsf_VScroll,wsf_HScroll,wsf_Close]
  win_hypereditor_RCT = rct(30,45,480,295)
  win_hypereditor_Menu = no_menu
  win_hypereditor_Title = "HyperEditor"
  win_hypereditor_Help = idh_contents
%END HyperEditor, CreateParms

PREDICATES

  win_hypereditor_eh : EHANDLER

CLAUSES

  win_hypereditor_Create(Parent):-
IFDEF use_editor
	S0 = "To create hyper text field:\n",
	S1 = "	1) select text to be converted to a field;\n",
	S2 = "	2) choose HyperText\\CreateField menu item.\n\n",
	format(S3,
	  "Double click on the highlited %c<HyperField>%c<Hidden Text>%c to display the associated hidden text.",
	   hyper_begin,hyper_middle,hyper_end),
	S4 = "\n\nNotice that <HyperField> declaration in the previous line is done directly in the source text.\n",
	S5 = "For example, such explicit <HyperField> declaration can be like the following:\n",
	S6 = "format(Hyperfield,\"%c<HyperField>%c<Hidden Text>%c\",hyper_begin,hyper_middle,hyper_end)\n",
	S7 = "Constants hyper_begin, hyper_middle, hyper_end are declared in vpi\\include\\EDITOR.DOM\n\n",
	S8 = "To delete hyper text field:\n",
	S9 = "	1) set caret on the field you need to delete;\n",
	S10 = "	2) choose HyperText\\DeleteField menu item.\n",
	format(Text,"%s%s%s%s%s%s%s%s%s%s%s",S0,S1,S2,S3,S4,S5,S6,S7,S8,S9,S10),

	Font = font_Create(ff_Fixed,[],10),
	ReadOnly = b_false, Indent = b_true, Wrap = b_true, InitPos = 1,
	Window=edit_CreateHyper(win_hypereditor_WinType,win_hypereditor_RCT,win_hypereditor_Title,
		 win_hypereditor_Menu,Parent,win_hypereditor_Flags,Font,ReadOnly,
		 Indent,Wrap,Text,InitPos,win_hypereditor_eh),
ENDDEF
	assert(win(Window)),
	!.

%BEGIN HyperEditor, e_Create
  win_hypereditor_eh(_Win,e_Create(_),0):-!,
%BEGIN HyperEditor, InitControls, 19:50:36-23.11.1999, Code automatically updated!
%END HyperEditor, InitControls
%BEGIN HyperEditor, ToolbarCreate, 19:50:36-23.11.1999, Code automatically updated!
%END HyperEditor, ToolbarCreate
	!.
%END HyperEditor, e_Create

%BEGIN HyperEditor, e_Menu, Editor default popup menu 
  win_hypereditor_eh(_Win,e_Menu(ID,_CAS),0):-
	ID >= edit_MenuUndo, ID <= edit_MenuFont, 
	!,fail.
%END HyperEditor, e_Menu, Editor default popup menu
%MARK HyperEditor, new events

%BEGIN HyperEditor, e_CloseRequest
  win_hypereditor_eh(_Win,e_CloseRequest,0):-!,
	TaskWin=vpi_GetTaskWin(),
	menu_Enable(TaskWin,"HyperText",b_false),
	win_Destroy(_Win),
	!.
%END HyperEditor, e_CloseRequest

%BEGIN HyperEditor, e_User
  win_hypereditor_eh(_Win,e_User(e_FollowLink,LONG),0):-!,
	EVENT = cast(HYPER_EVENT,LONG),
	EVENT = followLink(Field),
	hidden_text(Field,Text),
	dlg_Note(Text).

  win_hypereditor_eh(_,e_User(e_RemoveLink,_),0) :- !,
	!.
%END HyperEditor, e_User

%BEGIN HyperEditor, e_Size
  win_hypereditor_eh(_Win,e_Size(_Width,_Height),0):-!,
IFDEF use_tbar
	toolbar_Resize(_Win),
ENDDEF
	!.
%END HyperEditor, e_Size

%BEGIN HyperEditor, e_Menu, Parent window 
  win_hypereditor_eh(Win,e_Menu(ID,CAS),0):-!,
	PARENT = win_GetParent(Win),
	win_SendEvent(PARENT,e_Menu(ID,CAS)),
	!.
%END HyperEditor, e_Menu, Parent window

%END_WIN HyperEditor



