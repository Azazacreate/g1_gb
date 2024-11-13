/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  MYPROJ
 FileName: CROSS.PRO
 Purpose: A little Demo
 Written by: Leo Jensen
 Comments:
******************************************************************************/

include "myproj.inc"
include "myproj.con"
include "hlptopic.con"

%BEGIN_WIN Cross
/**************************************************************************
        Creation and event handling for window: Cross
	Code style: Single window
**************************************************************************/

constants
%BEGIN Cross, CreateParms, 10:07:44-24.11.1999, Code automatically updated!
  win_cross_WinType = w_TopLevel
  win_cross_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Close,wsf_Maximize,wsf_Minimize,wsf_ClipSiblings,wsf_ClipChildren]
  win_cross_RCT = rct(100,80,440,240)
  win_cross_Menu = no_menu
  win_cross_Title = "Cross"
  win_cross_Help = idh_contents
%END Cross, CreateParms

predicates

  win_cross_eh : EHANDLER

clauses

  win_cross_Create(Parent):-
	win_Create(win_cross_WinType,win_cross_RCT,win_cross_Title,
		   win_cross_Menu,Parent,win_cross_Flags,win_cross_eh,0).

  win_cross_eh(Win,Event,0):-
	write(Win,':',Event),nl,
	fail.

%BEGIN Cross, e_Create
  win_cross_eh(_Win,e_Create(_),0):-!,
%BEGIN Cross, InitControls, 10:07:44-24.11.1999, Code automatically updated!
%END Cross, InitControls
%BEGIN Cross, ToolbarCreate, 10:07:44-24.11.1999, Code automatically updated!
%END Cross, ToolbarCreate
 	!.
%END Cross, e_Create
%MARK Cross, new events

%BEGIN Cross, e_Update
  win_cross_eh(_Win,e_Update(_),0):-!,
	win_Clear ( _Win, color_White ),
	RCT=win_GetClientRect(_Win),
	RCT = rct(_,_,R,B),
	draw_Line(_Win,pnt(0,0),pnt(R,B)),
	draw_Line(_Win,pnt(0,B),pnt(R,0)),
	draw_Text(_Win, 55, 20, "This is a text in the Cross Window"),
	draw_Ellipse(_Win,rct(30,50,60,100)),
	draw_PolyGon(_Win,[pnt(130,130),pnt(180,130),pnt(145,100),pnt(150,150),pnt(170,110)]),
	draw_Rect(_Win,rct(250,50,300,100)),
	!.
%END Cross, e_Update

%BEGIN Cross, e_Size
  win_cross_eh(_Win,e_Size(_Width,_Height),0):-!,
	win_Invalidate(_Win),
ifdef use_tbar
	toolbar_Resize(_Win),
enddef
	!.
%END Cross, e_Size

%BEGIN Cross, e_Menu, Parent window 
  win_cross_eh(Win,e_Menu(ID,CAS),0):-!,
	PARENT = win_GetParent(Win),
	win_SendEvent(PARENT,e_Menu(ID,CAS)),
	!.
%END Cross, e_Menu, Parent window

%END_WIN Cross
