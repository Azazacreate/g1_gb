/******************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S 
			
			Visual Prolog 

 FileName: Messages.PRO
 PURPOSE: Output messages using write predicate to the special window
 Written by: Leo Jensen
 Modified by: A.G.
 Comments:
 
******************************************************************************/
ifndef message_pre_included
 #Error: this file requires include: message.pre
enddef 

constants
  msg_resize_win = 9400

database - mess_db
  determ max_no_lines(INTEGER)
  determ mess_win(WINDOW)
  nocopy determ msg_buffer(STRING)
  determ msg_timer(LONG)
  determ msg_newrct(RCT)
  determ msg_debug

/*****************************************************************************
* Add string to the message window
******************************************************************************/

predicates

  procedure add_str(STRING addedStr)
  nondeterm msg_member(WSFLAG,WSFLAGS)
  nondeterm msg_member(INTEGER,ILIST)
  procedure add_str1(WINDOW,STRING addedStr)
  procedure add_str2(WINDOW,STRING addedStr)
  procedure add_str3(WINDOW,STRING addedStr)
  determ contains_nl(String)
  procedure check_StartTimer(Window)

clauses

  contains_nl(Str):-
	frontchar(Str,'\n',_RestString),!.
  contains_nl(Str):-
	frontchar(Str,_,RestString),
	contains_nl(RestString).

  check_StartTimer(_Win):-
	msg_timer(_),!.
  check_StartTimer(Win):-
	TimerId = timer_Set(Win, 200),
	assert(msg_timer(TimerId)).

  % Purpose: Return if messagewindow not Open
  add_str(Str):-
  	mess_win(Win),!,
	add_str1(Win,Str).
  add_str(_).

  % Purpose: Send output to editor only if newline in string
  add_str1(Win,Str):-
	contains_nl(Str),!,
	add_str2(Win,Str).
  add_str1(Win,Str):-
	retract(msg_buffer(OldStr)),!,
	concat(OldStr,Str,NewStr),
	assert(msg_buffer(NewStr)),
	check_StartTimer(Win).
  add_str1(Win,Str):-
	assert(msg_buffer(Str)),
	check_StartTimer(Win).

  % Purpose: Send output to Editor
  add_str2(_Win,_Str):-  % If timer exists stop it !
	msg_timer(TimerId),
	timer_Kill(TimerId),
	retractall(msg_timer(_)),
	fail.
  add_str2(Win,Str):-  % If something in the buffer; empty this
	msg_buffer(OldStr),!,
	concat(OldStr,Str,NewStr),
	retractall(msg_buffer(_)),
	add_str3(Win,NewStr).
  add_str2(Win,Str):-
	add_str3(Win,Str).

  add_str3(Win,Str):-
  	max_no_lines(Max_no_lines),
 	edit_AppendStr(WIN,Str,Max_no_lines),
 	msg_debug,!,
	vpi_ProcessEvents().
  add_str3(_,_).

  msg_member(S,[S|_]).
  msg_member(S,[_|L]):-msg_member(S,L).
  
/******************************************************************************
*	The event handler for the message window
******************************************************************************/
predicates
  mess_win_handler   : EHANDLER
  procedure mess_possible_copy(WINDOW,BOOLEAN)

clauses
  mess_possible_copy(WIN,b_false):-
  	edit_GetSelection(WIN,POS1,POS2),
  	POS1=POS2,
  	POS1=0,!.
  mess_possible_copy(_WIN,b_true):-!.


  mess_win_handler(WIN,e_MouseUp(PNT,_,1),b_true):-!,
%  	ParentWin=win_GetParent(WIN),
%  	win_SetFocus(ParentWin),
  	mess_possible_copy(WIN,COPY_ENABLED),
  	MENU=dyn_menu([txt(1000,"&Copy",0,COPY_ENABLED,b_false,[]),
  	               txt(1001,"&Search...",0,b_true,b_false,[]),
  	               txt(1002,"Search &again",0,b_true,b_false,[]),
                       txt(1003,"&Font",0,b_true,b_false,[]),
                       txt(1004,"C&lear",0,b_true,b_false,[])
  	             ]),
	menu_PopUp(Win,MENU,PNT,align_Left).

ifdef visual_project
  mess_win_handler(_W,e_Getfocus,0):-!,
	TASKWIN=vpi_GetTaskWin(),
	toolbar_MesRedirect(TASKWIN,TASKWIN),
	fail.

  mess_win_handler(W,e_CloseRequest,0):-
	A = dlg_Ask("Question","To reopen Message Window use Options/Global/Environment and check on Show Message Window. Close?",["&Yes", "&No", ""]),
	A = resp_default,!,
	retract(message_win_attr(OLD,LINES,RCT,L,T,R,B)),
	NEW = OLD - 1,
  	assert(message_win_attr(NEW,LINES,RCT,L,T,R,B)),!,
  	win_Destroy(W).
  mess_win_handler(_W,e_CloseRequest,0):-!.

  mess_win_handler(_W,e_State(font(FONT)),0):-
	retractall(msg_deffont(_)),
	assert(msg_deffont(FONT)),!,
	fail.
enddef

  mess_win_handler(_, e_Destroy, 0) :-!,
	retractall(_,mess_db).

  mess_win_handler(Win,e_Size(_,_),0):-!,
	msg_newrct(_),
	win_PostEvent(Win,e_Menu(msg_resize_win,0)),!.

  mess_win_handler(Win,e_Menu(msg_resize_win,_),1):-!,
	vpi_ProcessEvents(b_true),
	MsgFlags = win_GetState(Win),
	not(msg_member(wsf_Minimized,MsgFlags)),
	not(msg_member(wsf_Maximized,MsgFlags)),!,
	retract(msg_newrct(NewRCT)),
	win_Move(Win,NewRCT),!.
  mess_win_handler(_Win,e_Menu(1000,_),1):-!,
	edit_Copy(_Win).
  mess_win_handler(_Win,e_Menu(1001,_),1):-!,
	edit_SearchDlg(_Win).
  mess_win_handler(_Win,e_Menu(1002,_),1):-!,
	edit_SearchAgain(_Win).
  mess_win_handler(WIN,e_Menu(1003,_),1):-!,
	edit_SetFontDlg(WIN).
  mess_win_handler(_WIN,e_Menu(1004,_),1):-!,
	msg_Clear.
  mess_win_handler(_WIN,e_Menu(Event,CAS),1):-!,
	not(msg_member(Event,[9064,9077,9079])),	% BB! 7.01.97
	  PW=win_GetParent(_Win),!,
	  win_SendEvent(PW,e_Menu(Event,CAS)).
  mess_win_handler(_WIN,e_Timer(TimerId),1):-
	retract(msg_buffer(Str)),!,
	add_str3(_Win,Str),
	retract(msg_timer(TimerId)),!,
	timer_Kill(TimerId).

/******************************************************************************
*	The actual global routines
******************************************************************************/
predicates
  procedure get_initial_mes_win_size(INTEGER,INTEGER,INTEGER,BOOLEAN)
  procedure out_str(STRING)
  procedure INTEGER get_TBar_if_MDI(WINDOW,INTEGER)

clauses
  msg_create(Max_no_lines,Win):-
	Win=msg_create(Max_no_lines,"Messages").

  msg_create(_,_,WIN) :-
	mess_win(WIN),!.
  msg_create(Max_no_lines,Title,WIN) :-
	retractall(_,mess_db),
	assert(max_no_lines(Max_no_lines)),
	Task_win = cast(window, vpi_GetAttrVal(attr_task_window)),
	RECT=win_GetClientRect(Task_win),
	RECT=rct(_,_,R,B),
	Tbar = val(integer,vpi_GetAttrVal(attr_win_tbar)),
	Sbar = val(integer,vpi_GetAttrVal(attr_win_sbar)),
	B1 = B - 10 - Tbar - Sbar,
	L1 = 10, 
  	get_initial_mes_win_size(R,W,H,Readonly),
	T1 = B1 - H,
	R1 = L1 + W,
	NewRCT = rct(L1,T1,R1,B1),
	Flags = [wsf_SizeBorder,wsf_Close,wsf_Minimize,wsf_Maximize,
                 wsf_ClipChildren,wsf_ClipSiblings,wsf_Titlebar,
                 wsf_HScroll,wsf_VScroll],
	FONT=font_Create(ff_System,[],10),
	WIN=edit_CreateWrap(w_TopLevel,NewRct,Title,no_menu,
		Task_Win,Flags,FONT,Readonly,
		b_true,
		b_false,/*b_true,*/
		"",1,mess_win_handler),
	assert(mess_win(Win)),
	edit_StatusLineShow(WIN,0),!.
	
ifdef visual_project
  get_initial_mes_win_size(_,W,H,b_true):-
  	initial_mes_win_size(W,H),!.
enddef
  get_initial_mes_win_size(R,W,100,b_false):-
  	W = R - 20,!.

  msg_close:-
  	mess_win(W),!,
  	win_Destroy(W).
  msg_close.

  msg_Clear:-
  	mess_win(EDWIN),!,
  	edit_PasteStr(EDWIN,""),
	edit_GotoPos(EDWIN,1).
  msg_Clear.
  
  msg_SetLines(LINES):-
	retractall(max_no_lines(_)),
	assert(max_no_lines(LINES)),
	fail.
  msg_SetLines(LINES):-
	mess_win(EDWIN),
	CUR=edit_GetNumberOfLines(EDWIN),
	CUR>=LINES,!,
	msg_Clear().
  msg_SetLines(_).

  msg_AppendStr(S):-
  	out_str(S),!.

  msg_GetWin(W):-mess_win(W),!.

  msg_SetFocus():-
	mess_win(W),
	MsgFlags = win_GetState(W),
	not(msg_member(wsf_Minimized,MsgFlags)),
	trap(win_SetFocus(W),_,fail),	% BB! 1.12.97
	vpi_ProcessEvents(),!.
  msg_SetFocus().

  msg_Resize(TaskWin):-
	TWFlags = win_GetState(TaskWin),
	msg_member(wsf_Minimized,TWFlags),!.
  msg_Resize(TaskWin):-
%	vpi_ProcessEvents(b_true),    Must not be called in e_Size !
					% Will give problems during startup
	MessWin = msg_GetWin(),
	MsgFlags = win_GetState(MessWin),
	not(msg_member(wsf_Minimized,MsgFlags)),
	not(msg_member(wsf_Maximized,MsgFlags)),!,
	RCT = win_GetClientRect(TaskWin),
	RCT = rct(_L,_T,Width,Height),	
  	Null = cast(window,0),
	TBar = get_TBar_if_MDI(Null,Lbar),	
	Sbar = val(integer,win_GetAttrVal(Null, attr_win_sbar)),
	Rbar = val(integer,win_GetAttrVal(Null, attr_win_rbar)),
	T1 = Height - 110 - Tbar - Sbar,
	R1 = Width - 10 - Lbar - Rbar,
	B1 = Height - 10 - Tbar - Sbar,
	NewRCT = rcT(10,T1,R1,B1),
	win_Move(MessWin,NewRCT),!.
  msg_Resize(TaskWin):-
	RCT = win_GetClientRect(TaskWin),
	RCT = rct(_L,_T,Width,Height),	
  	Null = cast(window,0),
	TBar = get_TBar_if_MDI(Null,Lbar),	
	Sbar = val(integer,vpi_GetAttrVal(attr_win_sbar)),
	Rbar = val(integer,vpi_GetAttrVal(attr_win_rbar)),
	T1 = Height - 110 - Tbar - Sbar,
	R1 = Width - 10 - Lbar - Rbar,
	B1 = Height - 10 - Tbar - Sbar,
	NewRCT = rct(10,T1,R1,B1),
	retractall(msg_newrct(_)),
	assert(msg_newrct(NewRCT)),!.

  msg_FastUpdate( FastUpdate ):-
  	free( FastUpdate ),
  	msg_debug,
  	FastUpdate = b_false,!.
  msg_FastUpdate( FastUpdate ):-
  	free( FastUpdate ),
  	FastUpdate = b_true,!.
  msg_FastUpdate( FastUpdate ):-
  	bound( FastUpdate ),
  	FastUpdate = b_false,
  	not(msg_debug),!,
  	assert(msg_debug).
  msg_FastUpdate( FastUpdate ):-
  	bound( FastUpdate ),
  	FastUpdate = b_true,
  	retract(msg_debug),!.
  msg_FastUpdate( FastUpdate ):-
  	bound( FastUpdate ).
  
  get_TBar_if_MDI(Null,Lbar,TBar):-
	MDI = win_GetAttrVal(Null, attr_win_mdi),
	MDI = b_true,!,
	Lbar = val(integer,win_GetAttrVal(Null, attr_win_lbar)),
	Tbar = val(integer,win_GetAttrVal(Null, attr_win_tbar)).
  get_TBar_if_MDI(_,0,0).


/***************************************************************************
	Default Output
***************************************************************************/
clauses

  out_str(Str):-mess_win(_),add_str(Str),fail.
  out_str(_Str).

  IO_WrStrCon(Str):-
	out_str(Str).
  IO_WrChCon(Ch):-
	str_char(Str,Ch),
	out_str(Str),
	fail.
  IO_WrChCon(_Ch).
