/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  MYPROJ
 FileName: PICTURE.PRO
 Purpose: A little Demo
 Written by: Leo Jensen
 Comments:
******************************************************************************/

include "myproj.inc"
include "myproj.con"
include "hlptopic.con"

%BEGIN_WIN Picture
/**************************************************************************
        Creation and event handling for window: Picture
	Code style: Single window
**************************************************************************/

constants
%BEGIN Picture, CreateParms, 10:07:44-24.11.1999, Code automatically updated!
  win_picture_WinType = w_TopLevel
  win_picture_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Close,wsf_Maximize,wsf_Minimize,wsf_ClipSiblings,wsf_ClipChildren]
  win_picture_RCT = rct(100,80,440,240)
  win_picture_Menu = no_menu
  win_picture_Title = "Picture"
  win_picture_Help = idh_contents
%END Picture, CreateParms

predicates

  win_picture_eh : EHANDLER

clauses

  win_picture_Create(Parent):-
	win_Create(win_picture_WinType,win_picture_RCT,win_picture_Title,
		   win_picture_Menu,Parent,win_picture_Flags,win_picture_eh,0).

%BEGIN Picture, e_Create
  win_picture_eh(_Win,e_Create(_),0):-!,
%BEGIN Picture, InitControls, 10:07:44-24.11.1999, Code automatically updated!
%END Picture, InitControls
%BEGIN Picture, ToolbarCreate, 10:07:44-24.11.1999, Code automatically updated!
%END Picture, ToolbarCreate
	!.
%END Picture, e_Create
%MARK Picture, new events

%BEGIN Picture, e_Update
  win_picture_eh(_Win,e_Update(_Rct),0):-!,
	RCT=win_GetClientRect(_Win),
ifdef os_os2
	Picture = pict_Load("..\\RES\\OS2\\CARSOS2.BMP"),
elsedef	
	Picture = pict_Load("..\\RES\\WIN\\CARS.BMP"),
enddef	
	pict_GetSize(Picture, X, Y, _Size),
	pict_Draw(_Win,Picture, RCT, rct(0,0,X,Y),rop_SrcCopy),
	pict_Destroy(Picture),
	!.
%END Picture, e_Update

%BEGIN Picture, e_Size
  win_picture_eh(_Win,e_Size(_Width,_Height),0):-!,
	win_invalidate(_Win),
ifdef use_tbar
	toolbar_Resize(_Win),
enddef
	!.
%END Picture, e_Size

%BEGIN Picture, e_Menu, Parent window 
  win_picture_eh(Win,e_Menu(ID,CAS),0):-!,
	PARENT = win_GetParent(Win),
	win_SendEvent(PARENT,e_Menu(ID,CAS)),
	!.
%END Picture, e_Menu, Parent window

%END_WIN Picture
