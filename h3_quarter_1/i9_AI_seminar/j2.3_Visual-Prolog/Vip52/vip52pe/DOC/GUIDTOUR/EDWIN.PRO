/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  MYPROJ
 FileName: EDWIN.PRO
 Purpose: A little Demo
 Written by: Leo Jensen
 Comments:
******************************************************************************/

include "myproj.inc"
include "myproj.con"
include "hlptopic.con"

/* Set Enable/Disable Edit menu items */
predicates
  editor_SetEnableDisableEditMenu(WINDOW EditorWin) - procedure (i)
  editor_PossiblePaste(boolean Paste) - procedure (o)
  editor_PossibleCutCopyDelete(WINDOW EditorWin,boolean Cut,boolean Copy,boolean Delete) - procedure (i,o,o,o)

clauses
  editor_SetEnableDisableEditMenu(EditorWin):-
	edit_PossibleUndoRedo(EditorWin,Undo,Redo),
	editor_PossiblePaste(Paste),
	editor_PossibleCutCopyDelete(EditorWin,Cut,Copy,Delete),
	menu_Enable(EditorWin,id_edit_undo,Undo),
	menu_Enable(EditorWin,id_edit_redo,Redo),
	menu_Enable(EditorWin,id_edit_paste,Paste),
	menu_Enable(EditorWin,id_edit_cut,Cut),
	menu_Enable(EditorWin,id_edit_copy,Copy),
	menu_Enable(EditorWin,id_edit_delete,Delete).

  editor_PossiblePaste(b_true):-
	Str=cb_GetString(),
	Str<>"",
	!.
  editor_PossiblePaste(b_false).

  editor_PossibleCutCopyDelete(EditorWin,b_false,b_false,b_false):-
	edit_GetSelection(EditorWin,PosBegin,PosEnd),
	PosBegin=PosEnd,
	!.
  editor_PossibleCutCopyDelete(_,b_true,b_true,b_true).

/* Check focus of the window */
predicates
  check_WindowFocus(WINDOW EditorWin) - procedure (i)

clauses
  check_WindowFocus(EditorWin):-
	win_focus(EditorWin),
	!.
  check_WindowFocus(EditorWin):-
	win_focus(_),
	!,
	retractall(_,focus),
	assert(win_focus(EditorWin)).
  check_WindowFocus(EditorWin):-
	assert(win_focus(EditorWin)).

%BEGIN_WIN Editor

facts - editor
  commentflag(WINDOW)

/**************************************************************************
        Creation and event handling for window: "Editor"
	Code style: Editor
**************************************************************************/

constants

%BEGIN Editor, CreateParms, 15:21:16-23.2.2000, Code automatically updated!
  win_editor_WinType = w_TopLevel
  win_editor_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Close,wsf_Maximize,wsf_Minimize,wsf_ClipSiblings,wsf_ClipChildren,wsf_VScroll,wsf_HScroll]
  win_editor_RCT = rct(100,80,440,240)
  win_editor_Menu = res_menu(idr_task_menu)
  win_editor_Title = "Editor"
  win_editor_Help = idh_contents
%END Editor, CreateParms

predicates
  win_editor_eh : EHANDLER

clauses
  win_editor_Create(Parent):-
ifdef use_editor
	FileName = "..\\MYPROJ.CON",
	file_str(FileName ,Text),
	Font = font_Create(ff_Fixed,[],10),
	ReadOnly = b_false, Indent = b_true, InitPos = 1,
	edit_Create(win_editor_WinType,win_editor_RCT,FileName,
		 win_editor_Menu,Parent,win_editor_Flags,Font,ReadOnly,
		 Indent,Text,InitPos,win_editor_eh),
enddef
	true.

%BEGIN Editor, e_Create
  win_editor_eh(_Win,e_Create(_CreationData),0):-!,
	menu_Enable(_Win,id_file_save,b_true).
%END Editor, e_Create

%BEGIN Editor, e_Menu, Editor default popup menu 
  win_editor_eh(_Win,e_Menu(ID,_CAS),0):-
	ID >= edit_MenuUndo, ID <= edit_MenuFont, 
	!,fail.
%END Editor, e_Menu, Editor default popup menu
%MARK Editor, new events

%BEGIN Editor, e_GetFocus
  win_editor_eh(_Win,e_GetFocus,0):-!,
	check_WindowFocus(_Win),
	!.
%END Editor, e_GetFocus

%BEGIN Editor, e_InitMenu
  win_editor_eh(_Win,e_InitMenu,0):-!,
	editor_SetEnableDisableEditMenu(_Win),
	!.
%END Editor, e_InitMenu

%BEGIN Editor, e_Destroy
  win_editor_eh(_Win,e_Destroy,0):-
	retract(win_focus(_Win)),
	!,
	menu_Enable(_Win,id_file_save,b_false),
	!.
%END Editor, e_Destroy

%BEGIN Editor, e_MouseDbl
  win_editor_eh(_Win,e_MouseDbl(_PNT,_ShiftCtlAlt,_Button),0):-!,
	WordSelected = edit_SelectWord(_Win),
	WordSelected = b_true,
	edit_GetSelection(_Win,Pos1,Pos2),
	Text = edit_GetText(_Win),
	NoOfBytes = Pos2-Pos1,
	substring(Text,Pos1,NoOfBytes,SubString),
	format(Msg,"Got the token: >%<",SubString),
	dlg_Note(Msg),
	!.
%END Editor, e_MouseDbl

%BEGIN Editor, e_Char
  win_editor_eh(_Win,e_Char('/',_),0):-!,
	not(commentflag(_Win)),
	assert(commentflag(_Win)),
	fail.
  win_editor_eh(_Win,e_Char('*',_),0):-!,
	retract(commentflag(_Win)),
	Pos = edit_GetPos(_Win),
	edit_PasteStr( _Win, Pos, "*  */" ),
	Pos1 = Pos+1, Pos2 = Pos1 + 4,
	edit_SetSelection(_Win, Pos1, Pos2),!.
  win_editor_eh(_Win,e_Char(_,_),0):-!,
	retract(commentflag(_Win)),
	fail.
%END Editor, e_Char

%BEGIN Editor, id_file_save
  win_editor_eh(_Win,e_Menu(id_file_save,_ShiftCtlAlt),0):-!,
	Msg="Save As File",
	Flags=[dlgfn_Save],
	SaveFileName = dlg_GetFileName("*.txt", ["*.txt","*.txt","*.*","*.*"],Msg, Flags,"", _OutListFiles ),
	Text = edit_GetText(_Win),
	file_str(SaveFileName, Text),
	format(InfoStr,"File % saved\n",SaveFileName),
	msg_AppendStr(InfoStr),
	upper_lower(OutSaveFileName,SaveFileName),
	win_SetText(_Win,OutSaveFileName),
	!.
%END Editor, id_file_save

%BEGIN Editor, e_Size
  win_editor_eh(_Win,e_Size(_Width,_Height),0):-!,
ifdef use_tbar
	toolbar_Resize(_Win),
enddef
	!.
%END Editor, e_Size

%BEGIN Editor, e_Menu, Parent window 
  win_editor_eh(Win,e_Menu(ID,CAS),0):-!,
	PARENT = win_GetParent(Win),
	win_SendEvent(PARENT,e_Menu(ID,CAS)),
	!.
%END Editor, e_Menu, Parent window

%END_WIN Editor

