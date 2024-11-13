/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S 

 FileName:	EDITPS.PRO
 Purpose:	Window Editor for Print Script
 Written by:	Alexander Grachev
 Version:	1.3
 Build:		019.990201
 Tested with:	Visual Prolog v.5.1 build 563
 Comments:
*****************************************************************************/
constants
ifndef id_edit_undo
  id_edit_undo = 1060
enddef
ifndef id_edit_redo
  id_edit_redo = 1061
enddef
ifndef id_edit_cut
  id_edit_cut = 1063
enddef
ifndef id_edit_copy
  id_edit_copy = 1064
enddef
ifndef id_edit_paste
  id_edit_paste = 1065
enddef
ifndef id_edit_delete
  id_edit_delete = 1066
enddef
ifndef id_edit_del
  id_edit_del = 1067
enddef


  win_edit_FLAGS = [wsf_SizeBorder,wsf_TitleBar,wsf_Close,wsf_Maximize,wsf_Minimize,wsf_HScroll,wsf_VScroll,wsf_ClipSiblings,wsf_ClipChildren]

database	- editwindow
determ		editwin(WINDOW)
predicates
procedure	change_win(WINDOW)
		win_edit_eh	: EHANDLER
clauses
  report_EditScript(_FN,_RCT,_):-
        editwin(EDWin),
        trap(win_Destroy(EDWin),_V,fail),
        fail.

  report_EditScript(FILENAME,RCT,WINDOW):-
	file_str(FILENAME,Text),
	NULLWIN = cast(window,0),
	T_W = win_GetAttrVal(NULLWIN,attr_task_window),
	WIN_HAND = cast(window,T_W),
        FONT = font_Create(ff_Fixed, [], 10),
	ReadOnly = b_false, Indent = b_true, _Wrap = b_true,InitPos = 1,
	WINDOW = edit_Create(w_TopLevel,RCT,FILENAME,
		no_menu,WIN_HAND,win_edit_FLAGS,FONT,ReadOnly,
		 Indent,Text,InitPos,win_edit_eh),
        change_win(WINDOW),
	!.

  win_edit_eh(_Win,e_Menu(id_edit_undo,_ShiftCtlAlt),0):-
	trap(edit_Undo(_Win),_,fail),
	!.
  win_edit_eh(_Win,e_Menu(id_edit_redo,_ShiftCtlAlt),0):-
	trap(edit_Redo(_Win),_,fail),
	!.
  win_edit_eh(_Win,e_Menu(id_edit_cut,_ShiftCtlAlt),0):-
	trap(edit_Cut(_Win),_,fail),
	!.
  win_edit_eh(_Win,e_Menu(id_edit_copy,_ShiftCtlAlt),0):-
	trap(edit_Copy(_Win),_,fail),
	!.
  win_edit_eh(_Win,e_Menu(id_edit_paste,_ShiftCtlAlt),0):-
	trap(edit_Paste(_Win),_,fail),
	!.
  win_edit_eh(_Win,e_Menu(id_edit_delete,_ShiftCtlAlt),0):-
	trap(edit_Delete(_Win),_,fail),
	!.
  win_edit_eh(_Win,e_Menu(id_edit_del,_ShiftCtlAlt),0):-
	trap(edit_Del(_Win),_,fail),
	!.

  change_win(_):-
  	retract(editwin(_)),
  	fail.
  change_win(WIN):-
  	assert(editwin(WIN)), !.
  	
