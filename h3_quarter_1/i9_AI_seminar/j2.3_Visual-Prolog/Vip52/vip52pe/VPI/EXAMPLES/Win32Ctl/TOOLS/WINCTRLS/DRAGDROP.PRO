/******************************************************************************

		 Copyright (c) 1984 - 2000 Prolog Development Center A/S

 FileName:	DRAGDROP.PRO
 Purpose:	Drag and Drop operations
 Written by:	Sergey Alexeev
 Version:	1.0
 Build:		002.000316
 Tested with:   Visual Prolog v.5.0 build 533
 Comments:
******************************************************************************/
ifndef winctrls_pre_included
 #Error: this file requires include: winctrls.pre
enddef 

ifdef use_drag_and_drop

GLOBAL PREDICATES
  procedure WINDOW _wcc_WindowFromPoint(INTEGER X,INTEGER Y) - (i,i) language C
  procedure LONG _wcc_WinSendMessage(WINDOW,INTEGER MEssage,LONG WParam,LONG LParam) - (i,i,i,i) language C
  procedure INTEGER _wcc_GlobalAddAtom(STRING) - (i) language C
  procedure _wcc_GlobalDeleteAtom(INTEGER Atom) - (i) language C
  procedure STRING _wcc_GlobalGetAtomName(INTEGER Atom) - (i) language C

DOMAINS
  DD_MESS = dd_mess(DD_EVENT,WINDOW ToWin,WINDOW FromWin,PNT,INTEGER MouseButton,STRING Data)

DATABASE - dd_db
  dd_drag_win(WINDOW)
  dd_info(WINDOW,EHANDLER)
  dd_cb(WINDOW,DD_CALLBACK)
  dd_str(STRING)

CONSTANTS
wm_user		= 0x0400

dd_drag_drop		= 16011966
dd_drag_drop_str	= 25011965
dd_drag_drop_beg	= 8031989

PREDICATES
  procedure dd_adjust_point(WINDOW SourceWin,PNT PointIn,PNT PointOut)
CLAUSES
  dd_adjust_point(SourceWin,PointIn,PointOut):-
	Screen = vpi_GetAttrVal(attr_screen_window),
	ScrWin = cast(window,Screen),
	PntList = win_MapPoints(SourceWin,ScrWin,[PointIn]),
	PntList = [PointOut1],
	PointOut1 = pnt(X1,Y1),
	bitand(X1,0x7fff,X),
	bitand(Y1,0x7fff,Y),
	PointOut = pnt(X,Y),!.
  dd_adjust_point(_,Point,Point).

PREDICATES
  procedure dd_convert_point(WINDOW SourceWin,PNT PointIn,PNT PointOut)
CLAUSES
  dd_convert_point(SourceWin,PointIn,PointOut):-
	Screen = vpi_GetAttrVal(attr_screen_window),
	ScrWin = cast(window,Screen),
	PntList = win_MapPoints(ScrWin,SourceWin,[PointIn]),
	PntList = [PointOut],!.
  dd_convert_point(_,Point,Point).

PREDICATES
  procedure dd_GetTaskWin(WINDOW Win,WINDOW Win,WINDOW TaskWin)
CLAUSES
  dd_GetTaskWin(Win,_,TaskWin):-
	trap(TaskWin = win_GetParent(Win),_,fail),
	dd_info(TaskWin,_),!.
  dd_GetTaskWin(Win,_,TaskWin):-
	trap(ParentWin = win_GetParent(Win),_,fail),!,
	dd_GetTaskWin(ParentWin,Win,TaskWin).
  dd_GetTaskWin(_,TaskWin,TaskWin).

PREDICATES
  procedure dd_PutString(WINDOW TaskWin,STRING String)
CLAUSES
  dd_PutString(TaskWin,Str):-
	str_len(Str,StrLength),
	StrLength < 255,
	Atom = _wcc_GlobalAddAtom(Str),
	_wcc_WinSendMessage(TaskWin,wm_user,dd_drag_drop_str,Atom),
	_wcc_GlobalDeleteAtom(Atom),!.
  dd_PutString(TaskWin,Str):-
	frontstr(255,Str,StartString,RestString),
	Atom = _wcc_GlobalAddAtom(StartString),
	_wcc_WinSendMessage(TaskWin,wm_user,dd_drag_drop_str,Atom),
	_wcc_GlobalDeleteAtom(Atom),!,
	dd_PutString(TaskWin,RestString).
  dd_PutString(_,_):-
	errorexit().

PREDICATES
  dd_handler : EHANDLER
CLAUSES
  dd_handler(_,e_native(wm_user,dd_drag_drop_beg,Point),dd_drag_drop):-
	Win = cast(window,Point),
	dd_cb(Win,_),
	retractall(dd_str(_)),
	assert(dd_str("")),!.
  dd_handler(_,e_native(wm_user,dd_drag_drop_str,Atom),dd_drag_drop):-
	retract(dd_str(Str)),
	AddStr = _wcc_GlobalGetAtomName(Atom),
	concat(Str,AddStr,Str1),
	assert(dd_str(Str1)),!.
  dd_handler(_,e_native(wm_user,dd_drag_drop,WinPoint),dd_drag_drop):-
	Win = cast(window,WinPoint),
	dd_cb(Win,CallBack),
	retract(dd_str(String)),
	trap(term_str(dd_mess,Data,String),_,fail),
	Data = dd_mess(Event,ToWin,FromWin,Point,MouseButton,SendData),
	not(CallBack(Event,ToWin,FromWin,Point,MouseButton,SendData)),!.
  dd_handler(TaskWin,Event,Answer):-
	dd_info(TaskWin,Ehandler),
	Answer = Ehandler(TaskWin,Event),!.

/**GLOBAL PREDICATE*******************************************************
			     DD_CLIENT
 *************************************************************************/
  dd_client(Win,_):-
	dd_GetTaskWin(Win,Win,TaskWin),
	not(dd_info(TaskWin,_)),
	Ehandler = win_GetHandler(TaskWin),
	assert(dd_info(TaskWin,Ehandler)),
	win_SetHandler(TaskWin,dd_handler),
	win_EnableHook(TaskWin,b_true),
	fail.
  dd_client(Win,CallBack):-
	retractall(dd_cb(Win,_)),
	assert(dd_cb(Win,CallBack)),!.

/**GLOBAL PREDICATE*******************************************************
			     DD_DRAG
 *************************************************************************/
PREDICATES
  procedure dd_send_dragonborder(WINDOW TaskWin,WINDOW ToWin,WINDOW FromWin,STRING Data)
CLAUSES
  dd_send_dragonborder(TaskWin,ToWin,FromWin,Data):-
	dd_drag_win(Win),
	Win <> ToWin,
	SendData = dd_mess(dragend,Win,FromWin,pnt(0,0),0,Data),
	term_str(dd_mess,SendData,String),
	WinP = cast(long,Win),
	Answer = _wcc_WinSendMessage(TaskWin,wm_user,dd_drag_drop_beg,WinP),
	Answer = dd_drag_drop,
	dd_PutString(TaskWin,String),
	Answer = _wcc_WinSendMessage(TaskWin,wm_user,dd_drag_drop,WinP),
	Answer = dd_drag_drop,
	fail,!.
  dd_send_dragonborder(TaskWin,ToWin,FromWin,Data):-
	not(dd_drag_win(ToWin)),
	SendData = dd_mess(dragbeg,ToWin,FromWin,pnt(0,0),0,Data),
	term_str(dd_mess,SendData,String),
	ToWinP = cast(long,ToWin),
	Answer = _wcc_WinSendMessage(TaskWin,wm_user,dd_drag_drop_beg,ToWinP),
	Answer = dd_drag_drop,
	dd_PutString(TaskWin,String),
	Answer = _wcc_WinSendMessage(TaskWin,wm_user,dd_drag_drop,ToWinP),
	Answer = dd_drag_drop,!.
  dd_send_dragonborder(_,_,_,_).

  dd_drag(SourceWin,Point,MouseButton,Data):-
	dd_adjust_point(SourceWin,Point,Point1),
	Point1 = pnt(X,Y),
	TargetWin = _wcc_WindowFromPoint(X,Y),
	dd_convert_point(TargetWin,Point1,Point2),
	SendData = dd_mess(drag,TargetWin,SourceWin,Point2,MouseButton,Data),
	term_str(dd_mess,SendData,String),
	dd_GetTaskWin(TargetWin,TargetWin,TaskWin),
	dd_send_dragonborder(TaskWin,TargetWin,SourceWin,Data),
	retractall(dd_drag_win(_)),
	assert(dd_drag_win(TargetWin)),
	Win = cast(long,TargetWin),
	Answer = _wcc_WinSendMessage(TaskWin,wm_user,dd_drag_drop_beg,Win),
	Answer = dd_drag_drop,
	dd_PutString(TaskWin,String),
	Answer = _wcc_WinSendMessage(TaskWin,wm_user,dd_drag_drop,Win),
	Answer = dd_drag_drop,!.

/**GLOBAL PREDICATE*******************************************************
			     DD_DROP
 *************************************************************************/
  dd_drop(SourceWin,Point,MouseButton,Data):-
	retractall(dd_drag_win(_)),
	dd_adjust_point(SourceWin,Point,Point1),
	Point1 = pnt(X,Y),
	TargetWin = _wcc_WindowFromPoint(X,Y),
	dd_convert_point(TargetWin,Point1,Point2),
	SendData = dd_mess(drop,TargetWin,SourceWin,Point2,MouseButton,Data),
	term_str(dd_mess,SendData,String),
	dd_GetTaskWin(TargetWin,TargetWin,TaskWin),
	Win = cast(long,TargetWin),
	Answer = _wcc_WinSendMessage(TaskWin,wm_user,dd_drag_drop_beg,Win),
	Answer = dd_drag_drop,
	dd_PutString(TaskWin,String),
	Answer = _wcc_WinSendMessage(TaskWin,wm_user,dd_drag_drop,Win),
	Answer = dd_drag_drop,!.

enddef /*** use_drag_and_drop ***/
