/*****************************************************************************

		 Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  SPEEDTST
 FileName: SPEEDTST.PRO
 Purpose: Demonstrates update time 
 Written by: PDC
 Modifyed by: Eugene Akimov
 Comments:
******************************************************************************/

include "speedtst.inc"
include "speedtst.con"
include "hlptopic.con"

DATABASE - db
  win_num(WINDOW,string)

PREDICATES
  nondeterm windows_update(INTEGER No,STRING Text)
  create_windows(WINDOW)
  show_window(WINDOW,integer,integer,integer)
  resize_window(WINDOW)

CLAUSES
  windows_update(1,"dots").
  windows_update(2,"picts").
  windows_update(3,"boxes").
  windows_update(4,"strings").
  windows_update(5,"lines").
  windows_update(6,"setpen_lines").
  
  create_windows(Parent):-
  	windows_update(_,Text),
	win_mywin_Create(Parent,Text),
	fail.
  create_windows(_).
  
  show_window(_Win,L1,L2,N):-N>3,!,
	No=N-3,
	L0=L1*(No-1),
	T0=20,
	R0=(L1*No)-5,
	B0=(L2+5),
	win_Move(_Win,rct(L0,T0,R0,B0)).
  show_window(_Win,L1,L2,No):-
	L0=L1*(No-1),
	T0=L2+30,
	R0=(L1*No)-5,
	B0=(L2*2)+15,
	win_Move(_Win,rct(L0,T0,R0,B0)).
	
  resize_window(_Win):-
	RCT=win_GetClientRect(_Win),
	RCT=rct(_,_,R,B),
	L1=R div 3,
	L2=(B-20) div 2,
	win_num(Window,Title),
	windows_update(No,Title),
	show_window(Window,L1,L2,No),
	fail.
  resize_window(_).	

/******************************************************
	Return a time mark in Hund ths of Sec's
******************************************************/
PREDICATES
  get_time(LONG TimeMark)
CLAUSES
  get_time(TimeMark):-
	time(Hours,Minutes,Seconds,Hundredths),
	TimeMark = Hundredths+100*(Seconds+60*val(long,Minutes+60*Hours)).

/******************************************************
	The 'for' predicate
******************************************************/

PREDICATES
  nondeterm for(INTEGER RetVal,INTEGER Start, INTEGER End, INTEGER Step)
CLAUSES
  for(X,X,_,_).  		% First return the starting value
  for(X,Start,End,Step):-	% Handle counting up
	Step>0,!, Start < End,
	Next = Start + Step,
	for(X,Next,End,Step).
  for(X,Start,End,Step):-	% Handle counting down
	Start < End,
	Next = Start + Step,
	for(X,Next,End,Step).


/******************************************************
	Draw lines in the window, from the center
	to all points at the edge
******************************************************/

PREDICATES
  draw_lines(WINDOW,RCT)
CLAUSES
  draw_lines(Win,rct(_, _, W, H)):-
	win_SetPen(Win,pen(1,ps_solid,color_Green)),
	for(Y,0,H,1),
	  draw_Line(Win,pnt(0,Y),pnt(W,Y)),
	fail.
  draw_lines(_,_).


/******************************************************
	Draw colored lines.
	Set the pen at each draw operation!
******************************************************/

PREDICATES
  draw_colored_lines(WINDOW,RCT)
CLAUSES
  draw_colored_lines(Win,rct(_, _, W, H)):-
	win_SetPen(Win,pen(1,ps_solid,color_Green)),
	for(Y,0,H,1),
	  win_SetPen(Win,pen(1,ps_solid,color_Red)),
	  draw_Line(Win,pnt(0,Y),pnt(W,Y)),
	fail.
  draw_colored_lines(_,_).


/******************************************************
	Fill the window with text
******************************************************/
PREDICATES
  draw_strings(WINDOW,RCT)
CLAUSES
  draw_strings(Win,rct(_,_,W,H)):-
	Font=font_Create(ff_Times, [], 10),
	win_SetFont(Win,Font),
	win_GetTextExtent(Win, "Hello", -1, INCx, INCy),
	for(Y,0,H,INCy),
	  for(X,0,W,INCx),
	    draw_Text(Win, X, Y, "Hello"),
	fail.
  draw_strings(_,_).

/******************************************************
	Fill the window with boxes
******************************************************/
PREDICATES
  draw_boxes(WINDOW,RCT)
CLAUSES
  draw_boxes(Win,rct(_,_,W,H)):-
	INC = 10,
	for(Y,0,H,INC),
	  for(X,0,W,INC),
	    L = X, R = L + INC, T = Y, B = Y + INC,
	    draw_Rect(Win,rct(L,T,R,B)),
	fail.
  draw_boxes(_,_).


/******************************************************
	Fill the window with boxes
******************************************************/
PREDICATES
  draw_dots(WINDOW,RCT)
CLAUSES
  draw_dots(Win,rct(_,_,W,H)):-
	for(Y,0,H,2),
	  for(X,0,W,2),
	    draw_Pixel(Win,pnt(X,Y),color_Blue),
	fail.
  draw_dots(_,_).


/******************************************************
	Fill the window with bitmaps
******************************************************/
PREDICATES
  draw_picts(WINDOW,RCT)
  draw_picts(WINDOW,RCT,PICTURE)
CLAUSES
  draw_picts(Win,Rct):-
IFDEF ws_win
	Picture = pict_Load("..\\RES\\WIN\\SPEED.BMP"),
ELSEDEF
	Picture = pict_Load("..\\RES\\OS2\\SPEED.BMP"),
ENDDEF
	draw_picts(Win,Rct,Picture),
	pict_Destroy(Picture).

  draw_picts(Win,rct(_,_,W,H),PICTURE):-
	pict_GetSize(Picture, XSize, YSize, _Size),
	for(Y,0,H,YSize),
	  for(X,0,W,XSize),
	    pict_Draw(Win,Picture,pnt(X,Y),rop_SrcCopy),
	fail.
  draw_picts(_,_,_).


/******************************************************
	Select the updating routine
******************************************************/
PREDICATES
  draw_win(WINDOW,RCT,STRING Title)
CLAUSES
  draw_win(Win,RCT,"boxes"):-draw_boxes(Win,RCT).
  draw_win(Win,RCT,"lines"):-draw_lines(Win,RCT).
  draw_win(Win,RCT,"setpen_lines"):-draw_colored_lines(Win,RCT).
  draw_win(Win,RCT,"strings"):-draw_strings(Win,RCT).
  draw_win(Win,RCT,"dots"):-draw_dots(Win,RCT).
  draw_win(Win,RCT,"picts"):-draw_picts(Win,RCT).

%BEGIN_WIN Task Window
/***************************************************************************
	Event handling for Task Window
***************************************************************************/

PREDICATES

  task_win_eh : EHANDLER

CONSTANTS

%BEGIN Task Window, CreateParms, 14:12:18-24.11.1999, Code automatically updated!
  task_win_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Close,wsf_Maximize,wsf_Minimize,wsf_ClipSiblings]
  task_win_Menu  = res_menu(idr_task_menu)
  task_win_Title = "Speedtst"
  task_win_Help  = idh_contents
%END Task Window, CreateParms

CLAUSES

%BEGIN Task Window, e_Create
  task_win_eh(_Win,e_Create(_),0):-!,
%BEGIN Task Window, InitControls, 14:12:18-24.11.1999, Code automatically updated!
%END Task Window, InitControls
%BEGIN Task Window, ToolbarCreate, 14:12:18-24.11.1999, Code automatically updated!
%END Task Window, ToolbarCreate
IFDEF use_message
	msg_Create(100),
ENDDEF
	create_windows(_Win),
	!.
%END Task Window, e_Create

%MARK Task Window, new events

%BEGIN Task Window, id_help_contents
  task_win_eh(_Win,e_Menu(id_help_contents,_ShiftCtlAlt),0):-!,
  	vpi_ShowHelp("speedtst.hlp"),
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
	resize_window(_Win),
	!.
%END Task Window, e_Size

%END_WIN Task Window

/***************************************************************************
	Invoking on-line Help
***************************************************************************/

  project_ShowHelpContext(HelpTopic):-
  	vpi_ShowHelpContext("speedtst.hlp",HelpTopic),!.

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
  vpi_Init(task_win_Flags,task_win_eh,task_win_Menu,"speedtst",task_win_Title).

%BEGIN_DLG About dialog
/**************************************************************************
	Creation and event handling for dialog: About dialog
**************************************************************************/

CONSTANTS

%BEGIN About dialog, CreateParms, 14:12:14-24.11.1999, Code automatically updated!
  dlg_about_dialog_ResID = idd_dlg_about
  dlg_about_dialog_DlgType = wd_Modal
  dlg_about_dialog_Help = idh_contents
%END About dialog, CreateParms

PREDICATES

  dlg_about_dialog_eh : EHANDLER

CLAUSES

  dlg_about_dialog_Create(Parent):-
	win_CreateResDialog(Parent,dlg_about_dialog_DlgType,dlg_about_dialog_ResID,dlg_about_dialog_eh,0),!.

%BEGIN About dialog, idc_ok _CtlInfo
  dlg_about_dialog_eh(_Win,e_Control(idc_ok,_CtrlType,_CtrlWin,_CtrlInfo),0):-!,
	win_Destroy(_Win),
	!.
%END About dialog, idc_ok _CtlInfo
%MARK About dialog, new events

  dlg_about_dialog_eh(_,_,_):-!,fail.

%END_DLG About dialog

%BEGIN_WIN mywin
/**************************************************************************
        Creation and event handling for window: mywin
**************************************************************************/

CONSTANTS
%BEGIN mywin, CreateParms, 14:12:14-24.11.1999, Code automatically updated!
  win_mywin_WinType = w_TopLevel
  win_mywin_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Close,wsf_Maximize,wsf_ClipSiblings,wsf_ClipChildren]
  win_mywin_RCT = rct(65,67,405,227)
  win_mywin_Menu = no_menu
  win_mywin_Title = "Mywin"
  win_mywin_Help = idh_contents
%END mywin, CreateParms

PREDICATES

  win_mywin_eh : EHANDLER

CLAUSES

  win_mywin_Create(Parent,Title):-
	Win=win_Create(win_mywin_WinType,win_mywin_RCT,Title,
		   win_mywin_Menu,Parent,win_mywin_Flags,win_mywin_eh,0),
	assert(win_num(Win,Title)).

%BEGIN mywin, e_Create
  win_mywin_eh(_Win,e_Create(_),0):-!,
%BEGIN mywin, InitControls, 14:12:14-24.11.1999, Code automatically updated!
%END mywin, InitControls
%BEGIN mywin, ToolbarCreate, 14:12:14-24.11.1999, Code automatically updated!
%END mywin, ToolbarCreate
	!.
%END mywin, e_Create
%MARK mywin, new events

%BEGIN mywin, e_Update
  win_mywin_eh(_Win,e_Update(_UpdateRct),0):-!,
	RCT = win_GetClientRect(_Win),
	Title = win_GetText(_Win),
	fronttoken(Title,Kind,_),
	get_time(Mark1),
	draw_win(_Win,RCT,Kind),
	get_time(Mark2),
	Time = Mark2-Mark1,
	format(NewTitle,"%: Update time=%",Kind,Time),
	win_SetText(_Win,NewTitle),
	!.
%END mywin, e_Update

%BEGIN mywin, e_Size
  win_mywin_eh(_Win,e_Size(_Width,_Height),0):-!,
IFDEF use_tbar
	toolbar_Resize(_Win),
ENDDEF
	win_Invalidate(_Win),
	!.
%END mywin, e_Size

%BEGIN mywin, e_Menu, Parent window 
  win_mywin_eh(Win,e_Menu(ID,CAS),0):-!,
	PARENT = win_GetParent(Win),
	win_SendEvent(PARENT,e_Menu(ID,CAS)),
	!.
%END mywin, e_Menu, Parent window

%END_WIN mywin





















