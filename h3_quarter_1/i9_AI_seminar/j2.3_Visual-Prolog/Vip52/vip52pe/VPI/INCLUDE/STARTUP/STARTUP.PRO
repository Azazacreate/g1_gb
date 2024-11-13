/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S 

 Project:  STARTUP
 FileName: STARTUP.PRO
 Purpose: Start up example
 Written by: Eugene Akimov
 Comments:
******************************************************************************/
ifndef startup_pre_included
 #Error: this file requires include: startup.pre
enddef 

/**************************************************************************
	Creation and event handling for window: startup
	Code style: Single window
**************************************************************************/

database - nw

  startUp_Created(STRING BmpFileName,WINDOW , PICTURE )
	
constants

  dlg_startup_dlg_DlgType = wd_Modeless
  dlg_startup_dlg_Title = ""
  dlg_startup_dlg_RCT = rct(50,40,213,147)
  dlg_startup_dlg_Flags = [wsf_Invisible]

predicates

  dlg_startup_dlg_eh: EHANDLER
  pictureDrawHandler: EHANDLER

clauses

  dlg_startup_dlg_eh(_Win,e_create(_),0):-
	Nullwin=cast(window,0),
	retract(startUp_created(BmpFile,Nullwin,PICT)),!,
	asserta(startUp_created(BmpFile,_Win,PICT)),fail.

  pictureDrawHandler(_Win,e_update(_),0):-
	Parent=win_GetParent(_Win),
	startUp_created(_BmpFile,Parent,PICT),
	pict_GetSize(PICT, Xsrc, Ysrc, _Size),X=Xsrc-1,Y=Ysrc-1,
	CustomWinRCT=win_GetClientRect(_Win),
	pict_Draw(_Win,PICT,CustomWinRCT,rct(0,0,X,Y),rop_SrcCopy),!.

  startup_Create(_,BmpFile,DlgWindow):-
	startUp_created(BmpFile,DlgWindow,_Pict),
	!,
	win_BringToTop(DlgWindow).
  startup_Create(_Parent,_BmpFile,_StartupWin):-
	not(startUp_created(_,_,_)),
	class_Create("PictureDraw",pictureDrawHandler),fail.  
  startup_Create(_Parent,BmpFile,StartupWin):-
	existfile(BmpFile),
	ScrWin = cast(window,vpi_GetAttrVal(attr_screen_window)),
	ScrWinRct=win_GetClientRect(ScrWin),
	ScrWinRct=rct(_,_,ScrWinWidth,ScrWinHeight),
	vpi_GetBaseUnits(Width,Height),
	Pict =pict_Load(BmpFile),
	pict_GetSize(Pict, X, Y, _Size),
	DlgWidth =(X * 4) div Width,
	DlgHeight=(Y * 8) div Height,
	DlgLeft=(((ScrWinWidth-X)*4) div Width  ) div 2,
	DlgTop=(((ScrWinHeight-Y)*8) div Height ) div 2,
	DlgRight=DlgLeft+DlgWidth,
	DlgBottom=DlgTop+DlgHeight,
	DlgRct = rct(DlgLeft,DlgTop,DlgRight,DlgBottom),
	Nullwin=cast(window,0),
	asserta(startUp_created(BmpFile,Nullwin,Pict)),
	StartupWin = win_CreateDynDialog(ScrWin,
		[
		 dlg(wdef(dlg_startup_dlg_DlgType,
		 DlgRct,
		 dlg_startup_dlg_Title,u_DlgPlatform),dlg_startup_dlg_Flags),
		 customctl(wdef(wc_Custom,rct(0,0,DlgWidth,DlgHeight),"",u_DlgPlatform),"PictureDraw",1,[])
	],dlg_startup_dlg_eh,0),
	vpi_ProcessEvents(b_true),
	win_SetState(StartupWin,[wsf_Visible]),
	!.

  startup_Create(_,BmpFile,Nullwin):-
	Nullwin=cast(window,0),
	format(Msg,"Can not create Startup Image from file %s!!!",BmpFile),
	dlg_Error(Msg).

  startup_Close(BmpFile):-
	retract(startUp_Created(BmpFile,Win,PICT)),
	pict_Destroy(PICT),
	win_Destroy(Win),
	not(startUp_Created(_,_,_)),
	class_Destroy("PictureDraw"),!. 
  startup_Close(_BmpFile).
  
