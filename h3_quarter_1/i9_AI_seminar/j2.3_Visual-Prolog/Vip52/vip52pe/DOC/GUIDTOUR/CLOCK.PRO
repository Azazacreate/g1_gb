/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  MYPROJ
 FileName: CLOCK.PRO
 Purpose: A little Demo
 Written by: Leo Jensen
 Comments:
******************************************************************************/

include "myproj.inc"
include "myproj.con"
include "hlptopic.con"

/******************************************************
	Timer Handling
******************************************************/
facts - clock
  timer(Window,LONG Id)

predicates
  startTimer(Window)
  stopTimer(Window)

clauses
  startTimer(Win):-
	TimerId = timer_Set(Win,1000),
	assert(timer(Win,TimerId)).

  stopTimer(Win):-
	retract(timer(Win,TimerId)),!,
	timer_Kill(TimerId).

/******************************************************
	Convert Time
******************************************************/
predicates
  clock_ConvertTime(integer InputTime,string OutTime) - procedure (i,o)

clauses
  clock_ConvertTime(InputTime,OutTime):-
	InputTime<10,
	!,
	format(OutTime,"0%",InputTime).
  clock_ConvertTime(InputTime,OutTime):-
	str_int(OutTime,InputTime).

%BEGIN_WIN Clock
/**************************************************************************
        Creation and event handling for window: Clock
**************************************************************************/

constants
%BEGIN Clock, CreateParms, 10:07:44-24.11.1999, Code automatically updated!
  win_clock_WinType = w_TopLevel
  win_clock_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Close,wsf_Maximize,wsf_Minimize,wsf_ClipSiblings,wsf_ClipChildren]
  win_clock_RCT = rct(109,60,423,226)
  win_clock_Menu = no_menu
  win_clock_Title = "Clock"
  win_clock_Help = idh_contents
%END Clock, CreateParms

predicates

  win_clock_eh : EHANDLER

clauses

  win_clock_Create(Parent):-
	win_Create(win_clock_WinType,win_clock_RCT,win_clock_Title,
		   win_clock_Menu,Parent,win_clock_Flags,win_clock_eh,0).

%BEGIN Clock, e_Create
  win_clock_eh(_Win,e_Create(_),0):-!,
%BEGIN Clock, InitControls, 10:07:44-24.11.1999, Code automatically updated!
	win_CreateControl(wc_PushButton,rct(6,9,106,33),"Start",_Win,[wsf_Group,wsf_TabStop],idc_startstop),
	win_CreateControl(wc_CheckBox,rct(6,44,106,68),"Show Date",_Win,[wsf_Group,wsf_TabStop,wsf_Auto],idc_show_date),
%END Clock, InitControls
%BEGIN Clock, ToolbarCreate, 10:07:44-24.11.1999, Code automatically updated!
%END Clock, ToolbarCreate
	!.
%END Clock, e_Create
%MARK Clock, new events

%BEGIN Clock, e_Update
  win_clock_eh(_Win,e_Update(_),0):-
	_CtrlWin =win_GetCtlHandle(_Win, idc_show_date),
	_IsChecked = win_IsChecked(_CtrlWin),
	_IsChecked = checkbox_on,!,
	win_Clear(_Win,color_LtGray),
	RCT=win_GetClientRect(_Win),
	time(Hours,Minutes,Seconds,_),
	date(Year,Month,Day),
	clock_ConvertTime(Hours,OutHours),
	clock_ConvertTime(Minutes,OutMinutes),
	clock_ConvertTime(Seconds,OutSeconds),
	format(Str,"%/%/% - %:%:%",Year,Month,Day,OutHours,OutMinutes,OutSeconds),
	draw_TextInRect(_Win, RCT, Str, -1,[dtext_center,dtext_vcenter,dtext_singleline]),
	!.
  win_clock_eh(_Win,e_Update(_),0):-!,
	win_Clear(_Win,color_LtGray),
	RCT=win_GetClientRect(_Win),
	time(Hours,Minutes,Seconds,_),
	clock_ConvertTime(Hours,OutHours),
	clock_ConvertTime(Minutes,OutMinutes),
	clock_ConvertTime(Seconds,OutSeconds),
	format(Str,"%:%:%",OutHours,OutMinutes,OutSeconds),
	draw_TextInRect(_Win, RCT, Str, -1,[dtext_center,dtext_vcenter,dtext_singleline]),
	!.
%END Clock, e_Update

%BEGIN Clock, e_Timer
  win_clock_eh(_Win,e_Timer(_TimerId),0):-!,
	win_Invalidate(_Win),
 	!.
%END Clock, e_Timer

%BEGIN Clock, idc_startstop _CtlInfo
  win_clock_eh(_Win,e_Control(idc_startstop,_CtrlType,_CtrlWin,_CtlInfo),0):-
	Title=win_GetText(_CtrlWin),
	Title = "Start",
	startTimer(_Win),
	win_SetText(_CtrlWin,"Stop"),
	!.
  win_clock_eh(_Win,e_Control(idc_startstop,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	stopTimer(_Win),
	win_SetText(_CtrlWin,"Start"),
	!.
%END Clock, idc_startstop _CtlInfo

%BEGIN Clock, idc_show_date _CtlInfo
  win_clock_eh(_Win,e_Control(idc_show_date,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	win_Invalidate(_Win),
	!.
%END Clock, idc_show_date _CtlInfo

%BEGIN Clock, e_Size
  win_clock_eh(_Win,e_Size(_Width,_Height),0):-!,
	win_Invalidate(_Win),
ifdef use_tbar
	toolbar_Resize(_Win),
enddef
	!.
%END Clock, e_Size

%BEGIN Clock, e_Menu, Parent window 
  win_clock_eh(Win,e_Menu(ID,CAS),0):-!,
	PARENT = win_GetParent(Win),
	win_SendEvent(PARENT,e_Menu(ID,CAS)),
	!.
%END Clock, e_Menu, Parent window

%END_WIN Clock
