/*****************************************************************************

	(c) Copyright 1984 - 2000 Prolog Development Center A/S

 Project:  SETUP
 FileName: BMPCTRL.PRO
 Purpose: Setup Program
 Written by: Leo Jensen
 Modified by: Zaichenko Michael
 Comments:
 
******************************************************************************/
ifndef bmpctrl_pre_included
 #Error: this file requires include: bmpctrl.pre
enddef 

constants
 bmp_pal = b_false
 
  %%debug_bmpctrl_sizes = 1 %show size of client rect on upper left corner
 
clauses

%BEGIN_WIN bmpctrl

domains
  CTRLBMP = file(STRING FileName); resid(RESID)

database - bmpctrl
  %bmp_str_id(STRING,RESID)
  ctrl_bmp(WINDOW,CTRLBMP,BOOLEAN Stretch,BOOLEAN Flip)



ifdef debug_bmpctrl_sizes
predicates
  procedure  draw_ClinetRect(Window,integer)
clauses
  draw_ClinetRect(Win,Type):-
	RCT = win_GetClientRect(Win),
	RCT = rct(_,_,X,Y),
	format (Sis,"%d X=%u Y=%u",Type,X,Y),
	win_SetBackMode(Win, bk_Opaque),
	win_GetTextExtent(Win,Sis,-1,Tx,Ty),
	draw_TextInRect(Win,rct(0,0,Tx,Ty),Sis,-1,[dtext_singleline]).
enddef

/**************************************************************************
        Event handling for custom control : bmpctrl
**************************************************************************/
%database - timers
% timerCome(WINDOW)

predicates
 win_bmpctrl_eh : EHANDLER
 determ clip_window(Window,integer X,integer Y)- (i,i,i)
 procedure INTEGER bmpctrl_min(INTEGER,INTEGER)-(i,i)
 procedure bmpctrl_pict_GetSize(Picture, Integer X, Integer Y)-(i,o,o)

clauses
 bmpctrl_min(A,B,A):-A<=B,!.
 bmpctrl_min(_,B,B).

 bmpctrl_pict_GetSize(Picture,DX,DY):-
	 pict_GetSize(Picture,X,Y,_),
	 DX = X-1,
	 DY = Y-1.


 clip_window(Win,PX,PY):-
	WinRCT = win_GetClientRect(Win),
	WinRCT = rct(X1,Y1,X2,Y2),
	X3 = X2 - 1,
	Y3 = Y2 - 1,
	Dpx = Px-1,
	Dpy = Py-1,
	CX= bmpctrl_min(X3,DPX),
	CY= bmpctrl_min(Y3,DPY),
	NWinRCT = rct(X1,Y1,CX,CY),
	%NWinRCT = rct(X1,Y1,X3,Y3),
	win_SetClip(Win,NWinRCT).

%BEGIN bmpctrl, e_Create
%  win_bmpctrl_eh(_Win,e_Create(_),0):-!,
%  	_Id = timer_Set(_Win,200).
%END bmpctrl, e_Create
%MARK bmpctrl, new events

/*  win_bmpctrl_eh(_Win,e_Timer(Id),0):-
	trap(timer_Kill(Id),_,fail),
	fail.*/
  %win_bmpctrl_eh(_Win,e_Timer(_),0):-!,
	%assert(timerCome(_Win)),
	%win_bmpctrl_eh(_Win,e_Update(rct(0,0,0,0))).

%BEGIN bmpctrl, e_Destroy
  win_bmpctrl_eh(_Win,e_Destroy,0):-!,
	retractall(ctrl_bmp(_Win,_,_,_)).
	%retractall(timerCome(_Win)).
%END bmpctrl, e_Destroy

%BEGIN bmpctrl, e_Update
%  win_bmpctrl_eh(_Win,e_Update(_UpdateRct),0):-
%	not(timerCome(_Win)),!.
	
  win_bmpctrl_eh(_Win,e_Update(_UpdateRct),0):-
	ctrl_bmp(_Win,file(File),b_True,_),!,
	Picture = pict_Load(File),
	bmpctrl_pict_GetSize(Picture, X, Y),
	WinRCT = win_GetClientRect(_Win),
	trap(pict_DrawEx(_Win,Picture, WinRCT, rct(0,0,X,Y),rop_SrcCopy, bmp_pal),_,fail),
	pict_Destroy(Picture),
ifdef debug_bmpctrl_sizes
	draw_ClinetRect(_Win,1),
enddef
	!.
  win_bmpctrl_eh(_Win,e_Update(_UpdateRct),0):-
	ctrl_bmp(_Win,file(File),b_False,_),!,
	Picture = pict_Load(File),
	trap(pict_DrawEx(_Win,Picture,pnt(0,0),rop_SrcCopy, bmp_pal),_,fail),
	pict_Destroy(Picture),
ifdef debug_bmpctrl_sizes
	draw_ClinetRect(_Win,2),
enddef
	!.
	
/*ifdef idb_prolog
  win_bmpctrl_eh(_Win,e_Update(_UpdateRct),0):-
	ctrl_bmp(_Win,resid(idb_prolog),b_True,_),
	Picture = pict_GetFromRes(idb_prolog),
	WinRCT = win_GetClientRect(_Win),
	pict_DrawEx(_Win,Picture, WinRCT, rct(20,19,262,286),rop_SrcCopy, bmp_pal),
	pict_Destroy(Picture),
	!.
enddef*/
  win_bmpctrl_eh(_Win,e_Update(_UpdateRct),0):-
  	%standart with cliping
	ctrl_bmp(_Win,resid(Resid),b_True,b_false),
	Picture = pict_GetFromRes(ResId),
	bmpctrl_pict_GetSize(Picture, X, Y),
	%clip_window(_Win,X,Y),
	%Dx= X-1,
	%Dy= Y-1,
	trap(pict_DrawEx(_Win,Picture,rct(0,0,X,Y), rct(0,0,X,Y),rop_SrcCopy, bmp_pal),_,fail),
	pict_Destroy(Picture),
ifdef debug_bmpctrl_sizes
	draw_ClinetRect(_Win,3),
enddef
	!.
  win_bmpctrl_eh(_Win,e_Update(_UpdateRct),0):-
  	%Reversed with cliping
	ctrl_bmp(_Win,resid(Resid),b_True,b_True),
	Picture = pict_GetFromRes(ResId),
	bmpctrl_pict_GetSize(Picture, X, Y),
	%clip_window(_Win,X,Y),
	trap(pict_DrawEx(_Win,Picture, rct(0,0,X,Y), rct(0,Y,X,0),rop_SrcCopy, bmp_pal),_,fail),
	pict_Destroy(Picture),
ifdef debug_bmpctrl_sizes
	draw_ClinetRect(_Win,4),
enddef
	!.
  win_bmpctrl_eh(_Win,e_Update(_UpdateRct),0):-
	ctrl_bmp(_Win,resid(Resid),_b_False,_),
	Picture = pict_GetFromRes(ResId),
	bmpctrl_pict_GetSize(Picture, X, Y),
	clip_window(_Win,X,Y),
	trap(pict_DrawEx(_Win,Picture,pnt(0,0),rop_SrcCopy, bmp_pal),_,fail),
	pict_Destroy(Picture),
ifdef debug_bmpctrl_sizes
	draw_ClinetRect(_Win,5),
enddef
	!.
  win_bmpctrl_eh(_Win,e_Update(_UpdateRct),0):-
	!.
%END bmpctrl, e_Update


 % win_bmpctrl_eh(_Win,e_EraseBackGround,0):-
 % 	ctrl_bmp(_Win,_,B1,B2),!,
 % 	B1=B2,B1=b_true.
  win_bmpctrl_eh(_Win,e_EraseBackGround,0):-!.
  
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
/*  bmpctrl_register([Sh|St],[Rh|Rt]) :-
	assert(bmp_str_id(Sh,Rh)),
	bmpctrl_register(St,Rt),!.
*/
  bmpctrl_register() :-
	trap(class_Create("BMPCTRL",win_bmpctrl_eh),_,fail),
	!.
  bmpctrl_register().
  
  bmpctrl_unregister() :-
	class_Destroy("BMPCTRL").

/**************************************************************************
	Setting the bitmap for the bitmap control
**************************************************************************/


  bmpctrl_SetBMPResId(Win,Resid,Stretch,Flip) :-
	retractall(ctrl_bmp(Win,_,_,_)),
	assert(ctrl_bmp(Win,resid(Resid),Stretch,Flip))
	
ifdef	os_os2
	,win_invalidate(Win)
enddef
	.

%END_WIN bmpctrl
