/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  MYPROJ
 FileName: TREE.PRO
 Purpose: A little Demo
 Written by: Leo Jensen
 Comments:
******************************************************************************/

include "myproj.inc"
include "myproj.con"
include "hlptopic.con"

%BEGIN_WIN Tree window
/**************************************************************************
	Creation and event handling for window: "Tree window"
**************************************************************************/

constants

%BEGIN Tree window, CreateParms, 10:07:44-24.11.1999, Code automatically updated!
  win_tree_window_WinType = w_TopLevel
  win_tree_window_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Close,wsf_Maximize,wsf_Minimize,wsf_ClipSiblings,wsf_ClipChildren]
  win_tree_window_RCT = rct(100,80,440,240)
  win_tree_window_Menu = no_menu
  win_tree_window_Title = "Tree window"
  win_tree_window_Help = idh_contents
%END Tree window, CreateParms

predicates

  win_tree_window_eh : EHANDLER

clauses

  win_tree_window_Create(Parent):-
ifdef use_tree
	Tree = tree("0",unmarked,
		    [tree("3",unmarked,[],0),
		     tree("2",unmarked,
			  [tree("4",unmarked,[],0)],0),
		     tree("1",unmarked,[],0)
		    ],0),
	TreeDir = tree_dirright,
	Font = font_Create(ff_Fixed,[],10),
	TreeWinInfo = tree_WinInfo(Font,TreeDir,[]),
	tree_Create(win_tree_window_WinType,win_tree_window_RCT,win_tree_window_Title,
		win_tree_window_Menu,Parent,win_tree_window_Flags,win_tree_window_eh,0,Tree,TreeWinInfo,[]),
enddef
	true.

%BEGIN Tree window, e_Create
  win_tree_window_eh(_Win,e_Create(_CreationData),0):-!,
	!.
%END Tree window, e_Create
%MARK Tree window, new events

%BEGIN Tree window, e_MouseUp
  win_tree_window_eh(_Win,e_MouseUp(_PNT,_ShiftCtlAlt,_Button),0):-!,
	Selector=tree_GetSelectedNode(_Win),
	dlg_Note(Selector),
	!.
%END Tree window, e_MouseUp

%BEGIN Tree window, e_Size
  win_tree_window_eh(_Win,e_Size(_Width,_Height),0):-!,
ifdef use_tbar
	toolbar_Resize(_Win),
enddef
	!.
%END Tree window, e_Size

%BEGIN Tree window, e_Menu, Parent window 
  win_tree_window_eh(Win,e_Menu(ID,CAS),0):-!,
	PARENT = win_GetParent(Win),
	win_SendEvent(PARENT,e_Menu(ID,CAS)),
	!.
%END Tree window, e_Menu, Parent window

%END_WIN Tree window
