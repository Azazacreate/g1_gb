/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S 

 Project:  SETUP
 FileName: BMPCTRL.PRO
 Purpose: Setup Program
 Written by: Leo Jensen
 Comments:
******************************************************************************/
ifndef bmpctrl_pre_included
 #Error: this file requires include: bmpctrl.pre
enddef 

%BEGIN_WIN bmpctrl

domains
  CTRLBMP = file(STRING FileName); resid(RESID)

database - bmpctrl
  ctrl_bmp(WINDOW,CTRLBMP,BOOLEAN Stretch)


/**************************************************************************
        File name should be received from parent window
**************************************************************************/
predicates
  procedure bmpctrl_GetData(WINDOW) - (i)

clauses
  bmpctrl_GetData(Win):-
  	ParentWin = win_GetParent ( Win ),
  	ControlId = win_GetCtlId( Win ),
  	CtlData = win_SendEvent ( ParentWin, e_User ( bmpctrl_getfilename, ControlId ) ),
  	CtlData >< 0, !,
  	FileName = cast ( string, CtlData ),
	bmpctrl_SetBMPFile(Win,FileName,b_True).
  bmpctrl_GetData(_).
	

/**************************************************************************
        Creation and event handling for window: bmpctrl
**************************************************************************/

predicates
  win_bmpctrl_eh : EHANDLER

clauses
%BEGIN bmpctrl, e_Create
  win_bmpctrl_eh(_Win,e_Create(_),0):-!,
	bmpctrl_GetData(_Win),
%BEGIN bmpctrl, InitControls, 10:44:59-18.9.1995, Code automatically updated!
%END bmpctrl, InitControls
%BEGIN bmpctrl, ToolbarCreate, 10:44:59-18.9.1995, Code automatically updated!
%END bmpctrl, ToolbarCreate
	!.
%END bmpctrl, e_Create
%MARK bmpctrl, new events

%BEGIN bmpctrl, e_Destroy
  win_bmpctrl_eh(_Win,e_Destroy,0):-!,
	retractall(ctrl_bmp(_Win,_,_)),
	!.
%END bmpctrl, e_Destroy

%BEGIN bmpctrl, e_Update
  win_bmpctrl_eh(_Win,e_Update(_UpdateRct),0):-
	ctrl_bmp(_Win,file(File),b_True),!,
	Picture = pict_Load(File),
	pict_GetSize(Picture, X, Y, _Size),
	WinRCT = win_GetClientRect(_Win),
	pict_Draw(_Win,Picture, WinRCT, rct(0,0,X,Y),rop_SrcCopy),
	pict_Destroy(Picture),
	!.
  win_bmpctrl_eh(_Win,e_Update(_UpdateRct),0):-
	ctrl_bmp(_Win,file(File),b_False),!,
	Picture = pict_Load(File),
	pict_Draw(_Win,Picture,pnt(0,0),rop_SrcCopy),
	pict_Destroy(Picture),
	!.
  win_bmpctrl_eh(_Win,e_Update(_UpdateRct),0):-
	ctrl_bmp(_Win,resid(Resid),b_True),
	Picture = pict_GetFromRes(ResId),
	pict_GetSize(Picture, X, Y, _Size),
	WinRCT = win_GetClientRect(_Win),
	pict_Draw(_Win,Picture, WinRCT, rct(0,0,X,Y),rop_SrcCopy),
	pict_Destroy(Picture),
	!.
  win_bmpctrl_eh(_Win,e_Update(_UpdateRct),0):-
	ctrl_bmp(_Win,resid(Resid),b_False),
	Picture = pict_GetFromRes(ResId),
	pict_Draw(_Win,Picture,pnt(0,0),rop_SrcCopy),
	pict_Destroy(Picture),
	!.
  win_bmpctrl_eh(_Win,e_Update(_UpdateRct),0):-
	win_Clear(_Win, color_Black),
	!.
%END bmpctrl, e_Update

%BEGIN bmpctrl, e_Size
  win_bmpctrl_eh(_Win,e_Size(_Width,_Height),0):-!,
ifdef use_tbar
	toolbar_Resize(_Win),
enddef
	!.
%END bmpctrl, e_Size

%BEGIN bmpctrl, e_Menu, Parent window 
  win_bmpctrl_eh(Win,e_Menu(ID,CAS),0):-!,
	PARENT = win_GetParent(Win),
	win_SendEvent(PARENT,e_Menu(ID,CAS)),
	!.
%END bmpctrl, e_Menu, Parent window



/**************************************************************************
	Registering the bitmap control class
**************************************************************************/

clauses
  bmpctrl_register :-
	class_Create("BMPCTRL",win_bmpctrl_eh).


/**************************************************************************
	Setting the bitmap for the bitmap control
**************************************************************************/


clauses
  bmpctrl_SetBMPFile(Win,File,Stretch) :-
	retractall(ctrl_bmp(Win,_,_)),
	assert(ctrl_bmp(Win,file(File),Stretch)).

  bmpctrl_SetBMPResId(Win,Resid,Stretch) :-
	retractall(ctrl_bmp(Win,_,_)),
	assert(ctrl_bmp(Win,resid(Resid),Stretch)).


%END_WIN bmpctrl
