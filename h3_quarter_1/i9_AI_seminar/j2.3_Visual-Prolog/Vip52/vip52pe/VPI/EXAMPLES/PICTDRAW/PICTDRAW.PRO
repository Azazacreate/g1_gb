/*****************************************************************************

		 Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  PICTDRAW
 FileName: PICTDRAW.PRO
 Purpose: Bitmap handling
 Written by: Alexander Gostintsev
 Comments:
******************************************************************************/

include "pictdraw.inc"
include "pictdraw.con"
include "hlptopic.con"

CONSTANTS
  const1 = [0,40,80,120,160,200,240,280,320,360,400]
  const2 = [20,60,100,140,180,220,260,300,340,380]

DATABASE - pictdraw
  background(PICTURE back)
  mask(PICTURE mask)
  timer(unsigned timerID)
  pos(INTEGER x,INTEGER y)
  checked(SYMBOL)

PREDICATES

  do_Create(WINDOW)
  do_Destroy
  do_Timer(WINDOW)
  clear_window(WINDOW,INTEGER,INTEGER)
  get_position(INTEGER,INTEGER)
  member(ILIST,INTEGER)

CLAUSES

  do_Create(WIN):-
	assert(checked(snake)),
	win_Move(WIN,rct(100,30,477,454)),
	win_SetPen(WIN,pen(1,ps_Solid,color_White)),
	BACKGROUND=pict_GetFromRes(idb_backgr),
	asserta(background(BACKGROUND)),
	MASK=pict_GetFromRes(idb_mask),
	asserta(mask(MASK)).

  do_Destroy:-
	retract(background(P1)),pict_Destroy(P1),
	retract(mask(P2)),pict_Destroy(P2),fail.
  do_Destroy:-
	timer(ID),
	timer_Kill(ID),!.
  do_Destroy:-!.

  do_Timer(W):-
	get_position(L,T),
	clear_window(W,L,T),
	R=L+25,
	B=T+25,
	background(BG),
	mask(MASK),!,
	pict_Draw(W,BG,rct(L,T,R,B),rct(L,T,R,B),rop_SrcInvert),
	pict_Draw(W,MASK,pnt(L,T),rop_SrcAnd),
	pict_Draw(W,BG,rct(L,T,R,B),rct(L,T,R,B),rop_SrcInvert).

  clear_window(W,0,0):-!,
	RECT=win_GetClientRect(W),
	draw_Rect(W,RECT).
  clear_window(_,_,_).

  get_position(X,Y):-
	checked(drop),!,
	random(370,X),
	random(430,Y).

  get_position(X,Y):-           % to the right
	pos(X1,Y),member(const1,Y),X1<350,!,X=X1+4,
	retractall(pos(_,_)),assert(pos(X,Y)).
  get_position(X,Y):-           % next row from the right side
	pos(X,Y1),member(const1,Y1),Y1<400,!,Y=Y1+20,
	retractall(pos(_,_)),assert(pos(X,Y)).
  get_position(0,0):-           % to the beginning
	pos(_X,Y1),member(const1,Y1),Y1=400,!,
	retractall(pos(_,_)),assert(pos(0,0)).
  get_position(X,Y):-           % to the left
	pos(X1,Y),member(const2,Y),X1>0,!,X=X1-4,
	retractall(pos(_,_)),assert(pos(X,Y)).
  get_position(X,Y):-           % next row from the left side
	pos(X,Y1),member(const2,Y1),Y1<380,!,Y=Y1+20,
	retractall(pos(_,_)),assert(pos(X,Y)).
  get_position(0,0):-           % to the beginning
	pos(_X,Y1),member(const2,Y1),Y1=360,!,
	retractall(pos(_,_)),assert(pos(0,0)).

  get_position(0,0):-           % initially
	assert(pos(0,0)).

  member([H|_],H):-!.
  member([_|T],X):-member(T,X).

%BEGIN_WIN Task Window
/***************************************************************************
	Event handling for Task Window
***************************************************************************/

PREDICATES

  task_win_eh : EHANDLER

CONSTANTS

%BEGIN Task Window, CreateParms, 20:06:50-28.5.1997, Code automatically updated!
  task_win_Flags = [wsf_TitleBar,wsf_Close,wsf_ClipSiblings,wsf_ClipChildren]
  task_win_Menu  = res_menu(idr_task_menu)
  task_win_Title = "Pictdraw"
  task_win_Help  = idh_contents
%END Task Window, CreateParms

CLAUSES

%BEGIN Task Window, e_Create
  task_win_eh(_Win,e_Create(_),0):-!,
%BEGIN Task Window, InitControls, 20:06:50-28.5.1997, Code automatically updated!
%END Task Window, InitControls
%BEGIN Task Window, ToolbarCreate, 20:06:50-28.5.1997, Code automatically updated!
%END Task Window, ToolbarCreate
IFDEF use_message
	msg_Create(100),
ENDDEF
	do_Create(_Win),
	menu_Check(_Win,id_Options_snake,b_true),
	assert(checked(snake)),
	!.
%END Task Window, e_Create

%MARK Task Window, new events


%BEGIN Task Window, e_Update
  task_win_eh(_Win,e_Update(_RECT),0):-!,
	draw_Rect(_Win,_RECT),
	!.
%END Task Window, e_Update

%BEGIN Task Window, e_Timer
  task_win_eh(_Win,e_Timer(_TimerId),0):-!,
	do_Timer(_Win).
%END Task Window, e_Timer

%BEGIN Task Window, id_Options_drop
  task_win_eh(_Win,e_Menu(id_Options_drop,_ShiftCtlAlt),0):-!,
	retract(checked(snake)),!,
	assert(checked(drop)),
	menu_Check(_Win,id_Options_snake,b_false),
	menu_Check(_Win,id_Options_drop,b_true),
	clear_window(_Win,0,0),
	retractall(pos(_,_)).
%END Task Window, id_Options_drop

%BEGIN Task Window, id_Options_snake
  task_win_eh(_Win,e_Menu(id_Options_snake,_ShiftCtlAlt),0):-!,
	retract(checked(drop)),!,
	assert(checked(snake)),
	menu_Check(_Win,id_Options_snake,b_true),
	menu_Check(_Win,id_Options_drop,b_false),
	clear_window(_Win,0,0),
	retractall(pos(_,_)).
%END Task Window, id_Options_snake

%BEGIN Task Window, id_run_stop
  task_win_eh(_Win,e_Menu(id_run_stop,_ShiftCtlAlt),0):-!,
	timer(ID),!,
	retractall(timer(_)),
	timer_Kill(ID),
	retractall(pos(_,_)),
	RECT=win_GetClientRect(_Win),
	draw_Rect(_Win,RECT),
	menu_Check(_Win,id_run_start,b_false),
	menu_Check(_Win,id_run_stop,b_true).
%END Task Window, id_run_stop

%BEGIN Task Window, id_run_start
  task_win_eh(_Win,e_Menu(id_run_start,_ShiftCtlAlt),0):-!,
	not(timer(_)),
	TID=timer_Set(_Win,2),
	assert(timer(TID)),
	menu_Check(_Win,id_run_start,b_true),
	menu_Check(_Win,id_run_stop,b_false),
	!.
%END Task Window, id_run_start

%BEGIN Task Window, id_help_contents
  task_win_eh(_Win,e_Menu(id_help_contents,_ShiftCtlAlt),0):-!,
  	vpi_ShowHelp("pictdraw.hlp"),
	!.
%END Task Window, id_help_contents

%BEGIN Task Window, id_help_about
  task_win_eh(Win,e_Menu(id_help_about,_ShiftCtlAlt),0):-!,
	dlg_about_dialog_Create(Win),
	!.
%END Task Window, id_help_about

%BEGIN Task Window, id_file_exit
  task_win_eh(Win,e_Menu(id_file_exit,_ShiftCtlAlt),0):-!,
  	win_Destroy(Win),
	!.
%END Task Window, id_file_exit

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
	Invoking on-line Help
***************************************************************************/

  project_ShowHelpContext(HelpTopic):-
  	vpi_ShowHelpContext("pictdraw.hlp",HelpTopic),!.

/***************************************************************************
	Main Goal
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
  vpi_Init(task_win_Flags,task_win_eh,task_win_Menu,"pictdraw",task_win_Title).

%END_WIN Task Window















































%BEGIN_DLG About dialog
/**************************************************************************
	Creation and event handling for dialog: About dialog
**************************************************************************/

CONSTANTS

%BEGIN About dialog, CreateParms, 12:12:45-2.11.1998, Code automatically updated!
  dlg_about_dialog_ResID = idd_dlg_about
  dlg_about_dialog_DlgType = wd_Modal
  dlg_about_dialog_Help = idh_contents
%END About dialog, CreateParms

PREDICATES

  dlg_about_dialog_eh : EHANDLER

CLAUSES

  dlg_about_dialog_Create(Parent):-
	win_CreateResDialog(Parent,dlg_about_dialog_DlgType,dlg_about_dialog_ResID,dlg_about_dialog_eh,0).

%BEGIN About dialog, idc_ok _CtlInfo
  dlg_about_dialog_eh(_Win,e_Control(idc_ok,_CtrlType,_CtrlWin,_CtrlInfo),0):-!,
	win_Destroy(_Win),
	!.
%END About dialog, idc_ok _CtlInfo
%MARK About dialog, new events

  dlg_about_dialog_eh(_,_,_):-!,fail.

%END_DLG About dialog








