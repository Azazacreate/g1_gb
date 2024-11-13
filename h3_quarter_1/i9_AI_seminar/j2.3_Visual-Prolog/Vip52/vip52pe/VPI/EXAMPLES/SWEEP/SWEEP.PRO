/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

			VISUAL Prolog

 Project:  SWEEP
 FileName: SWEEP.PRO
 Purpose: View mouse moving
 Written by: Ilyin Yuri
 Comments:
******************************************************************************/

include "sweep.inc"
include "sweep.con"
include "hlptopic.con"

/****************************************************************************
	Handling pointlist's
****************************************************************************/
ifdef os_os2
DATABASE - db
	mousedown_flag
enddef
	
DATABASE - apl
	nocopy point(PNT)

PREDICATES
	connect(WINDOW,pntlist)
	drawlines(WINDOW,PNT,pntlist)

CLAUSES
 connect(_,[]):-!.
 connect(_Win,[From|Rest]):-
	drawlines(_Win,From,Rest),
	connect(_Win,Rest).

 drawlines(_,_,[]):-!.
 drawlines(_Win,pnt(X,Y),[pnt(Tox,Toy)|Rest]):-
	draw_Line(_Win,pnt(X,Y),pnt(Tox,Toy)),
	drawlines(_Win,pnt(X,Y),Rest).

%BEGIN_WIN Task Window
/***************************************************************************
		Event handling for task window
***************************************************************************/

PREDICATES

  task_win_eh : EHANDLER

CONSTANTS

%BEGIN Task Window, CreateParms, 14:31:26-24.11.1999, Code automatically updated!
  task_win_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Close,wsf_Maximize,wsf_Minimize,wsf_ClipSiblings]
  task_win_Menu  = res_menu(idr_task_menu)
  task_win_Title = "Sweep"
  task_win_Help  = idh_contents
%END Task Window, CreateParms

CLAUSES

%BEGIN Task Window, e_Create
  task_win_eh(_Win,e_Create(_),0):-!,
%BEGIN Task Window, ToolbarCreate, 14:31:26-24.11.1999, Code automatically updated!
%END Task Window, ToolbarCreate
IFDEF use_message
	msg_Create(100),
ENDDEF
	!.
%END Task Window, e_Create

%MARK Task Window, new events

%BEGIN Task Window, e_MouseDown
  task_win_eh(_Win,e_MouseDown(_PNT,_,_Button),0):-!,
	retractall(point(_)),
ifdef os_os2
	assert(mousedown_flag),
enddef
	!.
%END Task Window, e_MouseDown
%BEGIN Task Window, e_MouseMove
ifdef os_os2
  task_win_eh(_Win,e_MouseMove(PNT,_,_Button),0):-
	mousedown_flag,!,
	assert(point(PNT)),
	!.
  task_win_eh(_Win,e_MouseMove(_PNT,_,_Button),0):-!,fail.
elsedef
  task_win_eh(_Win,e_MouseMove(PNT,_,_Button),0):-!,
	assert(point(PNT)),
	!.
enddef
%END Task Window, e_MouseMove
%BEGIN Task Window, e_MouseUp
  task_win_eh(_Win,e_MouseUp(_PNT,_,_Button),0):-!,
ifdef os_os2
	retractall(_,db),
	findall(X,point(X),List),
	connect(_Win,List),
	retractall(point(_)),
elsedef
	findall(X,point(X),List),
	connect(_Win,List),
enddef
	!.
%END Task Window, e_MouseUp
%BEGIN Task Window, id_file_exit
  task_win_eh(_Win,e_Menu(id_file_exit,_),0):-
	win_Destroy(_Win),
	!.
%END Task Window, id_file_exit
%BEGIN Task Window, e_Update
  task_win_eh(_Win,e_Update(UpdateRect),0):-!,
	DrawTools = win_GetDrawTools ( _Win ),
	win_SetPen ( _Win, pen ( 1, ps_Solid, color_Yellow ) ),
	win_SetBrush ( _Win, brush ( pat_Solid, color_Yellow ) ),
	draw_Rect ( _Win, UpdateRect ),
	win_SetDrawTools ( _Win, DrawTools ),
	MenuHeight = vpi_GetAttrVal(attr_menu_height),
	win_GetTextExtent(_Win,"I",-1,_,H),
	H1 = MenuHeight + 5,
	S1 = "1) Press down left button",
	H2 = H1 + H,
	S2 = "2) Move mouse in circle",
	H3 = H2 + H,
	S3 = "3) Release button",
	draw_text(_Win,5,H1,S1),
	draw_text(_Win,5,H2,S2),
	draw_text(_Win,5,H3,S3),
	!.
%END Task Window, e_Update
%BEGIN Task Window, id_help_about
  task_win_eh(_Win,e_Menu(id_help_about,_ShiftCtlAlt),0):-!,
	dlg_about_dialog_Create(_Win),
	!.
%END Task Window, id_help_about
%BEGIN Task Window, id_help_contents
IFDEF use_on_line_help
  task_win_eh(_Win,e_Menu(id_help_contents,_ShiftCtlAlt),0):-!,
	vpi_ShowHelp("sweep.hlp"),
	!.
ENDDEF
%END Task Window, id_help_contents
%BEGIN Task Window, id_clean_up
  task_win_eh(_Win,e_Menu(id_clean_up,_ShiftCtlAlt),0):-!,
	win_Invalidate(_Win),
	!.
%END Task Window, id_clean_up
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

  task_win_eh(_,_,0):-fail.

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
  vpi_Init(task_win_Flags,task_win_eh,task_win_Menu,"sweep",task_win_Title).

%END_WIN Task Window

%BEGIN_DLG About dialog
/**************************************************************************
	Creation and event handling for dialog: "About dialog"
	Code style: Single dialog
**************************************************************************/

CONSTANTS

%BEGIN About dialog, CreateParms, 14:31:22-24.11.1999, Code automatically updated!
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






