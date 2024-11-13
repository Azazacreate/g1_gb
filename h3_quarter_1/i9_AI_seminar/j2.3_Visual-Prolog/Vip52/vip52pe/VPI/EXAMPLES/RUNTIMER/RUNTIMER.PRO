/*****************************************************************************

		 Copyright (c) 1984 - 2000 Prolog Development Center A/S 

			VISUAL Prolog

 Project:  RUNTIMER
 FileName: RUNTIMER.PRO
 Purpose: Timer handling
 Written by: Illin Yuri
 Modifyed by: Eugene Akimov
 Comments:
******************************************************************************/
include "runtimer.inc"
include "runtimer.con"
include "hlptopic.con"

DATABASE - db
	timer(WINDOW,unsigned,COLOR)
	runtimer(integer,unsigned,COLOR)
	
DATABASE - db1
	count(integer)
	run
	
PREDICATES
	nondeterm timer_int(integer,unsigned,COLOR)
	check_runtimer(integer,unsigned,COLOR)
	check_timer(WINDOW)
	set_options
	
CLAUSES
  timer_int(1,100,color_Red).
  timer_int(2,250,color_Blue).
  timer_int(3,500,color_Cyan).	
  timer_int(4,600,color_Green).
  timer_int(5,750,color_Gray).
  timer_int(6,900,color_Magenta).
  timer_int(7,1000,color_LtGray).
  timer_int(8,1200,color_Yellow).
  timer_int(9,1350,color_DkGray).
  timer_int(10,1500,color_Black).
  timer_int(11,1600,0x8080FF).
  timer_int(12,1800,0x80).
  timer_int(13,2000,0x80FF).
  timer_int(14,2250,0x808000).
  timer_int(15,2500,0xA00000).

  check_timer(_Win):-
  	count(X),X>=15,!,
	Title="Error",
	dlg_Note(Title,"Too many timers (>15)").
  check_timer(_Win):-
  	count(X),!,
  	Y=X+1,
  	retractall(count(X)),
  	assert(count(Y)),
	win_timer_Create(_Win).

 
  set_options:-
  	timer_int(X,Interval,Color),!,
  	check_runtimer(X,Interval,Color).
  	
  check_runtimer(X,Interval,Color):-run,!,
  	assert(runtimer(X,Interval,Color)),
  	retractall(run).
  check_runtimer(X,_,Color):-timer(_,_,Color),
	Y=X+1,
	timer_int(Y,Interval,Color1),!,
  	check_runtimer(Y,Interval,Color1).
  check_runtimer(X,Interval,Color):-
  	retractall(runtimer(_,_,_)),
  	assert(runtimer(X,Interval,Color)).
  	
%BEGIN_WIN Task Window
/***************************************************************************
		Event handling for task window
***************************************************************************/

PREDICATES

  task_win_eh : EHANDLER

CONSTANTS

%BEGIN Task Window, CreateParms, 14:02:54-24.11.1999, Code automatically updated!
  task_win_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Close,wsf_Maximize,wsf_Minimize,wsf_ClipSiblings]
  task_win_Menu  = res_menu(idr_task_menu)
  task_win_Title = "Runtimer"
  task_win_Help  = idh_contents
%END Task Window, CreateParms

CLAUSES

%BEGIN Task Window, e_Create
  task_win_eh(_Win,e_Create(_),0):-!,
%BEGIN Task Window, ToolbarCreate, 14:02:54-24.11.1999, Code automatically updated!
%END Task Window, ToolbarCreate
IFDEF use_message
	msg_Create(100),
ENDDEF
	assert(count(0)),
	assert(run),
	!.
%END Task Window, e_Create

%MARK Task Window, new events

%BEGIN Task Window, id_help_about
  task_win_eh(_Win,e_Menu(id_help_about,_ShiftCtlAlt),0):-!,
	dlg_about_dialog_Create(_Win),
	!.
%END Task Window, id_help_about
%BEGIN Task Window, id_file_exit
  task_win_eh(_Win,e_Menu(id_file_exit,_ShiftCtlAlt),0):-!,
	win_Destroy(_Win),
	!.
%END Task Window, id_file_exit
%BEGIN Task Window, id_Timer_create
  task_win_eh(_Win,e_Menu(id_Timer_create,_ShiftCtlAlt),0):-!,
	check_timer(_Win),
	!.
%END Task Window, id_Timer_create
%BEGIN Task Window, id_Timer_destroy
  task_win_eh(_Win,e_Menu(id_Timer_destroy,_ShiftCtlAlt),0):-
	W=win_GetFocus(),
	retract(timer(W,TimerID,_Color)),!,
	timer_Kill(TimerId),
	win_Destroy(W),
	count(X),
	Y=X-1,
	retractall(count(X)),
	assert(count(Y)),
	!.
%END Task Window, id_Timer_destroy

%BEGIN Task Window, id_help_contents
IFDEF use_on_line_help
  task_win_eh(_Win,e_Menu(id_help_contents,_ShiftCtlAlt),0):-!,
	vpi_ShowHelp("runtimer.hlp"),
	!.
ENDDEF
%END Task Window, id_help_contents
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
  vpi_Init(task_win_Flags,task_win_eh,task_win_Menu,"runtimer",task_win_Title).

%END_WIN Task Window

%BEGIN_DLG About dialog
/**************************************************************************
	Creation and event handling for dialog: "About dialog"
	Code style: Single dialog
**************************************************************************/

CONSTANTS

%BEGIN About dialog, CreateParms, 14:02:50-24.11.1999, Code automatically updated!
  dlg_about_dialog_ResID = idd_dlg_about
  dlg_about_dialog_DlgType = wd_Modal
  dlg_about_dialog_Help = idh_contents
%END About dialog, CreateParms

PREDICATES

  dlg_about_dialog_eh : EHANDLER

CLAUSES

  dlg_about_dialog_Create(_Win):-
	win_CreateResDialog(_Win,dlg_about_dialog_DlgType,dlg_about_dialog_ResID,dlg_about_dialog_eh,0),!.

%BEGIN About dialog, idc_ok _CtlInfo
  dlg_about_dialog_eh(_Win,e_Control(idc_ok,_CtrlType,_CtrlWin,_CtrlInfo),0):-!,
	win_Destroy(_Win),
	!.
%END About dialog, idc_ok _CtlInfo
%MARK About dialog, new events

  dlg_about_dialog_eh(_,_,0) :- !,fail.
%END_DLG About dialog

%BEGIN_WIN Timer
/**************************************************************************
        Creation and event handling for window: Timer
**************************************************************************/

CONSTANTS
%BEGIN Timer, CreateParms, 14:02:50-24.11.1999, Code automatically updated!
  win_timer_WinType = w_TopLevel
  win_timer_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Close,wsf_ClipSiblings]
  win_timer_RCT = rct(100,80,440,240)
  win_timer_Menu = no_menu
  win_timer_Title = "Timer"
  win_timer_Help = idh_contents
%END Timer, CreateParms

PREDICATES

  win_timer_eh : EHANDLER

CLAUSES

  win_timer_Create(Parent):-
	win_Create(win_timer_WinType,win_timer_RCT,win_timer_Title,
		   win_timer_Menu,Parent,win_timer_Flags,win_timer_eh,0).

%BEGIN Timer, e_Create
  win_timer_eh(_Win,e_Create(_),0):-!,
%BEGIN Timer, InitControls, 14:02:50-24.11.1999, Code automatically updated!
%END Timer, InitControls
%BEGIN Timer, ToolbarCreate, 14:02:50-24.11.1999, Code automatically updated!
%END Timer, ToolbarCreate
	set_options,
	runtimer(X,Interval,Color),
	TimerID = timer_Set(_Win,Interval),
	assert(timer(_Win,TimerID,Color)),		   
	str_int(Str,X),
	Text="Timer ",
	concat(Text,Str,Text1),
	Text2="  (Interval=",
	term_str( unsigned, Interval, Str1 ),
	concat(Text1,Text2,Text3),
	concat(Text3,Str1,Text4),
	concat(Text4,")",Final),
	win_SetText(_Win,Final),
	!.
%END Timer, e_Create
%MARK Timer, new events

%BEGIN Timer, e_Timer
  win_timer_eh(_Win,e_Timer(_TimerId),0):-!,
	timer(_Win,_,Color),!,
	RCT  = win_GetClientRect(_Win),
	RCT  = rct(_,_,Width,Height),
	MidleX = Width div 2,
	MidleY = Height div 2,
	random(Width,X),
	random(Height,Y),
	win_SetPen(_Win,pen(1,ps_Solid,COLOR)),
	draw_Line(_Win,pnt(MidleX,MidleY),pnt(X,Y)),
	!.
%END Timer, e_Timer

%BEGIN Timer, e_Update
  win_timer_eh(_Win,e_Update(_UpdateRct),0):-!,
	DRAWTOOLS = win_GetDrawTools(_Win),
	win_SetPen(_Win,pen(1,ps_Solid,color_White)),
	win_SetBrush(_Win,brush(pat_Solid,color_White)),
	draw_Rect(_Win,_UpdateRct),
	win_SetDrawTools(_Win,DRAWTOOLS),
	!.
%END Timer, e_Update

%BEGIN Timer, e_CloseRequest
  win_timer_eh(_Win,e_CloseRequest,0):-!,
	W=win_GetFocus(),
	retract(timer(W,TimerID,_Color)),!,
	timer_Kill(TimerId),
	win_Destroy(W),
	count(X),
	Y=X-1,
	retractall(count(X)),
	assert(count(Y)),
	!.
%END Timer, e_CloseRequest

%BEGIN Timer, e_Size
  win_timer_eh(_Win,e_Size(_Width,_Height),0):-!,
IFDEF use_tbar
	toolbar_Resize(_Win),
ENDDEF
	!.
%END Timer, e_Size

%BEGIN Timer, e_Menu, Parent window 
  win_timer_eh(Win,e_Menu(ID,CAS),0):-!,
	PARENT = win_GetParent(Win),
	win_SendEvent(PARENT,e_Menu(ID,CAS)),
	!.
%END Timer, e_Menu, Parent window

%END_WIN Timer




















