/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  COLORS
 FileName: COLORS.PRO
 Purpose: Demonstrates color handling 
 Written by: PDC
 Comments:
******************************************************************************/

include "colors.inc"
include "colors.con"
include "hlptopic.con"

CONSTANTS
/* Try this to display 16000 Color rectangles
  noof_Xcolors = 512
  noof_Ycolors = 64
  noof_reds = 64
  noof_greens = 32
  noof_blues = 16
*/

%/* Try this to display 256 Color rectangles
  noof_Xcolors = 64
  noof_Ycolors = 4
  noof_reds = 4
  noof_greens = 8
  noof_blues = 8
%*/

/* Try this to display 64 Color rectangles
  noof_Xcolors = 16
  noof_Ycolors = 4
  noof_reds = 4
  noof_greens = 4
  noof_blues = 4
*/

PREDICATES
  nondeterm for(unsigned,unsigned,unsigned)

CLAUSES
  for(CUR,CUR,_).
  for(CUR,MIN,MAX) :-
    MIN1 = val(unsigned,MIN + 1),MIN1 < MAX, for(CUR,MIN1,MAX).

PREDICATES
  decompose(Color,unsigned R,unsigned G,unsigned B)
CLAUSES
  decompose(Color,R,G,B):-
	R = Color mod 256,
	G = (Color div 256) mod 256,
	B = Color div 256 div 256.

PREDICATES
  COLOR create_Color(unsigned I)
CLAUSES
  create_Color(0,0):-!.
  create_Color(I,Color):-
	vpi_ProcessEvents(b_false),
	R = (256 div noof_reds) * (I mod noof_reds) ,
	G = (256 div noof_greens) * ((I div noof_reds) mod noof_greens),
	B = (256 div noof_blues) * (I div (noof_reds*noof_greens)),
	Color = vpi_ComposeRGB(R,G,B).

PREDICATES
  draw_rct(Window,unsigned No,unsigned XW,unsigned YW)
CLAUSES
  draw_rct(_Win,I,XW,YW):-
	X = XW * (I div noof_Ycolors), X1 = X + XW,
	Y = YW * (I mod noof_Ycolors), Y1 = Y + YW,
	win_NeedsUpdate(_Win,rct(X,Y,X1,Y1)),!,
	Color = create_Color(I),
	DRAWTOOLS = win_GetDrawTools ( _Win ),
	win_SetPen ( _Win, pen ( 1, ps_Solid, Color ) ),
	win_SetBrush ( _Win ,brush ( pat_Solid, Color ) ),
	draw_Rect ( _Win, rct ( X, Y, X1, Y1 ) ),
	win_SetDrawTools ( _Win, DRAWTOOLS ).
  draw_rct(_Win,_I,_XW,_YW).

PREDICATES
  get_steps(WINDOW,unsigned XW,unsigned YW)
CLAUSES
  get_steps(_Win,XW,YW):-
	ClientRect = win_GetClientRect(_Win),
	ClientRect = rct(_,_,Width,Heigth),
	XW = Width div noof_Xcolors,
	YW = Heigth div noof_Ycolors.

%BEGIN_WIN Task Window
/***************************************************************************
	Event handling for Task Window
***************************************************************************/

PREDICATES

  task_win_eh : EHANDLER

CONSTANTS

%BEGIN Task Window, CreateParms, 17:43:58-23.11.1999, Code automatically updated!
  task_win_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Close,wsf_Maximize,wsf_Minimize,wsf_ClipSiblings]
  task_win_Menu  = res_menu(idr_task_menu)
  task_win_Title = "Colors"
  task_win_Help  = idh_contents
%END Task Window, CreateParms

CLAUSES

%BEGIN Task Window, e_Create
  task_win_eh(_Win,e_Create(_),0):-!,
%BEGIN Task Window, InitControls, 17:43:58-23.11.1999, Code automatically updated!
%END Task Window, InitControls
%BEGIN Task Window, ToolbarCreate, 17:43:58-23.11.1999, Code automatically updated!
%END Task Window, ToolbarCreate
IFDEF use_message
	msg_Create(100),
ENDDEF
	!.
%END Task Window, e_Create

%MARK Task Window, new events

%BEGIN Task Window, e_MouseUp
  task_win_eh(_Win,e_MouseUp(pnt(X,Y),_ShiftCtlAlt,_Button),0):-!,
	get_steps(_Win,XW,YW),
	XI = X div XW,
	YI = Y div YW,
	I = val(unsigned,XI * noof_Ycolors + YI),

	ColorSet = create_Color(I),
	decompose(ColorSet,R,G,B),

	Color = win_GetPixel(_Win,pnt(X,Y)),
	decompose(Color,R1,G1,B1),

	format(S,"I=%\nRGB was set to: (%,%,%)\nGetPixel Found: (%,%,%):",I,R,G,B,R1,G1,B1),
	dlg_Note(S),
	!.
%END Task Window, e_MouseUp

%BEGIN Task Window, e_Update
  task_win_eh(_Win,e_Update(_UpdateRct),0):-!,
	DRAWTOOLS = win_GetDrawTools ( _Win ),
	win_SetPen ( _Win, pen ( 1, ps_Solid, color_White ) ),
	win_SetBrush ( _Win ,brush ( pat_Solid, color_White ) ),
	RCT = win_GetClientRect ( _Win ),
	draw_Rect ( _Win, RCT ),
	win_SetDrawTools ( _Win, DRAWTOOLS ),
	get_steps(_Win,XW,YW),
	MaxColor = val(unsigned,noof_Xcolors) * val(unsigned,noof_Ycolors),
	for(I,0,MaxColor),
	  draw_rct(_Win,I,XW,YW),
	  I >= MaxColor,
	!.
%END Task Window, e_Update

%BEGIN Task Window, id_help_contents
  task_win_eh(_Win,e_Menu(id_help_contents,_ShiftCtlAlt),0):-!,
  	vpi_ShowHelp("colors.hlp"),
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
	% Force a complete redraw on a resize
	win_Invalidate(_Win,rct(0,0,_Width,_Height)),
	!.
%END Task Window, e_Size

%END_WIN Task Window

/***************************************************************************
	Invoking on-line Help
***************************************************************************/

  project_ShowHelpContext(HelpTopic):-
  	vpi_ShowHelpContext("colors.hlp",HelpTopic),!.

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
  vpi_Init(task_win_Flags,task_win_eh,task_win_Menu,"colors",task_win_Title).

%BEGIN_DLG About dialog
/**************************************************************************
	Creation and event handling for dialog: About dialog
**************************************************************************/

CONSTANTS

%BEGIN About dialog, CreateParms, 17:43:52-23.11.1999, Code automatically updated!
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








