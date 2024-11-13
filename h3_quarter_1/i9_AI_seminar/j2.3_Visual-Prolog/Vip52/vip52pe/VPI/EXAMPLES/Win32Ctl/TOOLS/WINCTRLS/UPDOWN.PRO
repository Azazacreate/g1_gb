/******************************************************************************

		 Copyright (c) 1984 - 2000 Prolog Development Center A/S

 FileName:	UPDOWN.PRO
 Purpose:	Up-Down custom control object
 Written by:	Sergey Alexeev
 Version:	1.0
 Build:		002.000316
 Tested with:   Visual Prolog v.5.0 build 533
 Comments:
******************************************************************************/
ifdef use_winctrl_UpDown

ifndef winctrls_pre_included
 #Error: this file requires include: winctrls.pre
enddef 

ifndef error_con_included
 #Error: this file requires include: error.con
enddef 

DOMAINS
UD_NMHDR = struct nmhdr(WCC_POINT WUDWin,UNSIGNED IdFrom,UNSIGNED CodeOperation)
UD_ACCEL = struct accel(UNSIGNED Sec,UNSIGNED Inc,UNSIGNED Sec,UNSIGNED Inc,UNSIGNED Sec,UNSIGNED Inc)

CONSTANTS
ud_buddy_id	= 16166

udn_deltapos	= 0xfffffd2e

udm_setrange	= 0x0465
udm_getrange	= 0x0466
udm_setpos	= 0x0467
udm_getpos	= 0x0468
udm_setbuddy	= 0x0469
udm_getbuddy	= 0x046a
udm_setaccel	= 0x046b
udm_getaccel	= 0x046c
udm_setbase	= 0x046d
udm_getbase	= 0x046e

DATABASE - ud_db
  ud_info(WINDOW UDWin,WINDOW WUDWin,UD_CALLBACK,WINDOW BuddyWin)
  ud_buddy_win(WINDOW UDWin,WINDOW UserWin)

PREDICATES
  procedure ud_get_accel1(INTEGER,INTEGER Time1,INTEGER Delta1,INTEGER Time2,INTEGER Delta2,INTEGER Time3,INTEGER Delta3,UD_ACCELERATORLIST)
CLAUSES
  ud_get_accel1(3,Time1,Delta1,Time2,Delta2,Time3,Delta3,[ud_ac(Time1,Delta1),ud_ac(Time2,Delta2),ud_ac(Time3,Delta3)]):-!.
  ud_get_accel1(2,Time1,Delta1,Time2,Delta2,_,_,[ud_ac(Time1,Delta1),ud_ac(Time2,Delta2)]):-!.
  ud_get_accel1(1,Time1,Delta1,_,_,_,_,[ud_ac(Time1,Delta1)]):-!.
  ud_get_accel1(_,_,_,_,_,_,_,[]).

PREDICATES
  procedure ud_set_accel1(INTEGER,INTEGER Time1,INTEGER Delta1,INTEGER Time2,INTEGER Delta2,INTEGER Time3,INTEGER Delta3,UD_ACCELERATORLIST)
CLAUSES
  ud_set_accel1(3,Time1,Delta1,Time2,Delta2,Time3,Delta3,[ud_ac(Time1,Delta1),ud_ac(Time2,Delta2),ud_ac(Time3,Delta3)|_]):-!.
  ud_set_accel1(2,Time1,Delta1,Time2,Delta2,0,0,[ud_ac(Time1,Delta1),ud_ac(Time2,Delta2)]):-!.
  ud_set_accel1(1,Time1,Delta1,0,0,0,0,[ud_ac(Time1,Delta1)]):-!.
  ud_set_accel1(_,0,0,0,0,0,0,_):-!.

PREDICATES
  procedure WINDOW ud_create_buddy(WINDOW UDWin,WINDOW WUDWin)
CLAUSES
  ud_create_buddy(UDWin,WUDWin,BuddyWin):-
	Rect = win_GetClientRect(UDWin),
	BuddyWin = win_CreateDynControl([ctl(wdef(wc_Edit,Rect,"UpDownBuddyWindow",u_Pixels),
		ud_buddy_id,[wsf_Invisible])],UDWin),
	BuddyWinP = cast(long,BuddyWin),
	win_SendEvent(WUDWin,e_native(udm_setbuddy,BuddyWinP,0)),!.

PREDICATES
  procedure ud_change_value(WINDOW UDWin)
CLAUSES
  ud_change_value(UDWin):-
	ud_buddy_win(UDWin,UserWin),
	ud_info(UDWin,_,_,BuddyWin),
	Text = win_GetText(UserWin),
	win_SetText(BuddyWin,Text),!.
  ud_change_value(_).

PREDICATES
  procedure ud_value_change(WINDOW UDWin)
CLAUSES
  ud_value_change(UDWin):-
	ud_info(UDWin,_,_,BuddyWin),
	ud_buddy_win(UDWin,UserWin),
	Text = win_GetText(BuddyWin),
	win_SetText(UserWin,Text),!.
  ud_value_change(_).

PREDICATES
  determ ud_check_code(ULONG CodeOperation,WINDOW UDWin,UNSIGNED WParam,LONG LParam,UD_MESSAGE,STRING Message)
CLAUSES
  ud_check_code(udn_deltapos,_,_,_,changing,"DeltaPos"):-!.

/**GLOBAL PREDICATE*******************************************************
			     UD_GET_POS
 *************************************************************************/
  ud_get_pos(UDWin,Pos):-
	ud_info(UDWin,WUDWin,_,_),
	Pos1 = win_SendEvent(WUDWin,e_native(udm_getpos,0,0)),
	Pos = val(short,Pos1),!.
  ud_get_pos(_,0):-
	errorexit(error_vpi_package_bad_window),!.

/**GLOBAL PREDICATE*******************************************************
			     UD_SET_POS
 *************************************************************************/
  ud_set_pos(UDWin,Pos):-
	ud_info(UDWin,WUDWin,_,_),
	Pos = win_SendEvent(WUDWin,e_native(udm_setpos,0,Pos)),!.
  ud_set_pos(_,_):-
	errorexit(error_vpi_package_bad_window),!.

/**GLOBAL PREDICATE*******************************************************
			     UD_GET_RANGE
 *************************************************************************/
  ud_get_range(UDWin,Max,Min):-
	ud_info(UDWin,WUDWin,_,_),
	Range = win_SendEvent(WUDWin,e_native(udm_getrange,0,0)),
	Min = val(short,Range),
	bitright(Range,16,Max1),
	Max = val(short,Max1),!.
  ud_get_range(_,0,0):-
	errorexit(error_vpi_package_bad_window),!.

/**GLOBAL PREDICATE*******************************************************
			     UD_SET_RANGE
 *************************************************************************/
  ud_set_range(UDWin,Max,Min):-
	ud_info(UDWin,WUDWin,_,_),
	Range1 = val(long,Max),
	bitleft(Range1,16,Range2),
	Range = Range2 + Min, 
	win_SendEvent(WUDWin,e_native(udm_setrange,0,Range)),!.
  ud_set_range(_,_,_):-
	errorexit(error_vpi_package_bad_window),!.

/**GLOBAL PREDICATE*******************************************************
			     UD_GET_ACCEL
 *************************************************************************/
  ud_get_accel(UDWin,Acc):-
	ud_info(UDWin,WUDWin,_,_),
	Point = accel(0,0,0,0,0,0),
	PointP = cast(long,Point),
	Num = win_SendEvent(WUDWin,e_native(udm_getaccel,3,PointP)),
	Point1 = cast(ud_accel,PointP),
	Point1 = accel(Time1,Delta1,Time2,Delta2,Time3,Delta3),
	ud_get_accel1(Num,Time1,Delta1,Time2,Delta2,Time3,Delta3,Acc),!.
  ud_get_accel(_,[]):-
	errorexit(error_vpi_package_bad_window),!.

/**GLOBAL PREDICATE*******************************************************
			     UD_SET_ACCEL
 *************************************************************************/
  ud_set_accel(UDWin,Acc):-
	ud_info(UDWin,WUDWin,_,_),
	wcc_length_list(Acc,Num1),
	wcc_min(Num1,3,Num),
	ud_set_accel1(Num,Time1,Delta1,Time2,Delta2,Time3,Delta3,Acc),
	Point = accel(Time1,Delta1,Time2,Delta2,Time3,Delta3),
	PointP = cast(long,Point),
	win_SendEvent(WUDWin,e_native(udm_setaccel,Num,PointP)),!.
  ud_set_accel(_,_):-
	errorexit(error_vpi_package_bad_window),!.

/**GLOBAL PREDICATE*******************************************************
			     UD_GET_BUDDY
 *************************************************************************/
PREDICATES
  ud_buddy_eh : EHANDLER
CLAUSES

  ud_get_buddy(UDWin,Win):-
	ud_buddy_win(UDWin,Win),!.
  ud_get_buddy(UDWin,Win):-
	ud_info(UDWin,_,_,_),
	Win = cast(window,0),!.
  ud_get_buddy(_,Win):-
	Win = cast(window,0),
	errorexit(error_vpi_package_bad_window),!.

/**GLOBAL PREDICATE*******************************************************
			     UD_SET_BUDDY
 *************************************************************************/
  ud_set_buddy(UDWin,Win):-
	retractall(ud_buddy_win(UDWin,_)),
	assert(ud_buddy_win(UDWin,Win)),
	win_SetSubclassHandler(Win,ud_buddy_eh,b_false),
	ud_change_value(UDWin),!.
  ud_set_buddy(_,_):-
	errorexit(error_vpi_package_bad_window),!.

/**GLOBAL PREDICATE*******************************************************
			     UD_INIT
 *************************************************************************/
  ud_Init(UDWin,_,_):-
	ud_info(UDWin,WUDWin,_,BuddyWin),
	win_Destroy(WUDWin),
	win_Destroy(BuddyWin),
	ud_HandleEvent(UDWin,e_Destroy),
	fail.
  ud_Init(UDWin,Flags,CallBack):-
	Hinst = vpi_GetAttrVal(attr_win_instance),
	wcc_summ_list(Flags,0,SummFlags),
	WUDWin = _wcc_create(Hinst,UDWin,"msctls_updown32","Up-Down Control",SummFlags),
	BuddyWin = ud_create_buddy(UDWin,WUDWin),
	assert(ud_info(UDWin,WUDWin,CallBack,BuddyWin)),
	ud_set_range(UDWin,0,100),
	win_EnableHook(UDWin,b_true),!.
  ud_Init(_,_,_).

/*************************************************************************
			     EVENT HANDLER
 *************************************************************************/
  ud_HandleEvent(UDWin,e_Control(_,_,_,ControlInfo),-1):-
	ControlInfo = scroll(sc_Thumb,Pos),
	ud_value_change(UDWin),
	ud_info(UDWin,_,CallBack,_),
	CallBack(UDWin,changed(Pos)),!.
  ud_HandleEvent(UDWin,e_native(wm_notify,WParam,LParam),-1):-
	Event = cast(ud_nmhdr,LParam),
	Event = nmhdr(_,_,CodeOperation),
	ud_check_code(CodeOperation,UDWin,WParam,LParam,UD_Message,_Message),
%	write("_Message=",_Message,"\n"),
	ud_info(UDWin,_,CallBack,_),
	CallBack(UDWin,UD_Message),!.

  ud_HandleEvent(UDWin,e_Size(Width,Height),0):-
	ud_info(UDWin,WUDWin,_,_),
	win_Move(WUDWin,rct(0,0,Width,Height)),!.
  ud_HandleEvent(UDWin,e_State(font(Font)),0):-
	ud_info(UDWin,WUDWin,_,_),
	win_SetFont(WUDWin,Font),!.
  ud_HandleEvent(UDWin,e_State(disabled()),0):-
	ud_info(UDWin,WUDWin,_,_),
	win_SetState(WUDWin,[wsf_Disabled]),!.
  ud_HandleEvent(UDWin,e_State(enabled()),0):-
	ud_info(UDWin,WUDWin,_,_),
	win_SetState(WUDWin,[wsf_Enabled]),!.
  ud_HandleEvent(UDWin,e_State(invisible()),0):-
	ud_info(UDWin,WUDWin,_,_),
	win_SetState(WUDWin,[wsf_Invisible]),!.
  ud_HandleEvent(UDWin,e_State(visible()),0):-
	ud_info(UDWin,WUDWin,_,_),
	win_SetState(WUDWin,[wsf_Visible]),!.
  ud_HandleEvent(UDWin,e_Destroy,0):-
	retractall(ud_info(UDWin,_,_,_)),
	retractall(ud_buddy_win(UDWin,_)),
	fail.

  ud_buddy_eh(UserWin,e_Destroy,0):-
	retractall(ud_buddy_win(_,UserWin)),
	!,fail.
  ud_buddy_eh(UserWin,e_KeyUp(_,_),0):-
	ud_buddy_win(UDWin,UserWin),
	ud_change_value(UDWin),
	!,fail.
enddef /*** use_winctrl_UpDown ***/
