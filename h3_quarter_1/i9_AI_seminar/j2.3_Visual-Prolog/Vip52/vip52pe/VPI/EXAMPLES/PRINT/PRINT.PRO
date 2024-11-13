/*****************************************************************************

		 Copyright (c) 1984 - 2000 Prolog Development Center A/S

			VISUAL Prolog

 Project:  PRINT
 FileName: PRINT.PRO
 Purpose: Print Example
 Written by: Leo Jensen
 Comments:

******************************************************************************/

include "print.inc"
include "print.con"
include "hlptopic.con"

%BEGIN_WIN Task Window
/***************************************************************************
		Event handling for task window
***************************************************************************/

PREDICATES

  task_win_eh : EHANDLER

CONSTANTS

%BEGIN Task Window, CreateParms, 12:39:14-24.11.1999, Code automatically updated!
  task_win_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Close,wsf_Maximize,wsf_Minimize,wsf_ClipSiblings,wsf_Maximized]
  task_win_Menu  = res_menu(idr_task_menu)
  task_win_Title = "Print"
  task_win_Help  = idh_contents
%END Task Window, CreateParms

CLAUSES

%BEGIN Task Window, e_Create
  task_win_eh(_Win,e_Create(_),0):-!,
%BEGIN Task Window, InitControls, 12:39:14-24.11.1999, Code automatically updated!
%END Task Window, InitControls
%BEGIN Task Window, ToolbarCreate, 12:39:14-24.11.1999, Code automatically updated!
%END Task Window, ToolbarCreate
IFDEF use_message
	msg_Create(100),
ENDDEF
	win_mywin_Create(_Win),
	!.
%END Task Window, e_Create

%BEGIN Task Window, id_help_contents
IFDEF use_on_line_help
  task_win_eh(_Win,e_Menu(id_help_contents,_ShiftCtlAlt),0):-!,
	vpi_ShowHelp("print.hlp"),
	!.
ENDDEF
%END Task Window, id_help_contents

%MARK Task Window, new events

%BEGIN Task Window, e_Update
  task_win_eh(_Win,e_Update(_UpdateRct),0):-!,
	win_Clear(_Win,color_LtGray),
	!.
%END Task Window, e_Update

%BEGIN Task Window, id_file_new
  task_win_eh(_Win,e_Menu(id_file_new,_ShiftCtlAlt),0):-!,
	menu_Enable(_Win,id_file_new,b_false),
	menu_Enable(_Win,id_file_print,b_true),
	menu_Update(_Win),
	win_mywin_Create(_Win),
	!.
%END Task Window, id_file_new

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
  vpi_Init(task_win_Flags,task_win_eh,task_win_Menu,"print",task_win_Title).

%END_WIN Task Window

%BEGIN_DLG About dialog
/**************************************************************************
	Creation and event handling for dialog: "About dialog"
	Code style: Single dialog
**************************************************************************/

CONSTANTS

%BEGIN About dialog, CreateParms, 23:22:36-10.1.2000, Code automatically updated!
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

  dlg_about_dialog_eh(_,_,0):-!,fail.
%END_DLG About dialog



/******************************************************
	Draw the picture
******************************************************/
PREDICATES
  draw(WINDOW)
CLAUSES
  draw(_Win):-

	FONT = font_Create(ff_helvetica,[],12),
	win_SetFont(_Win,FONT),
	win_SetBrush(_Win,brush(pat_Hollow,color_Black)),
	draw_Rect(_Win,rct(30,30,500,300)),
	draw_Text(_Win, 50,50, "Hello there" ),
	draw_Ellipse(_Win,rct(300,200,450,275)),
	win_SetBrush(_Win,brush(pat_FDiag,color_Black)),
	draw_Rect(_Win,rct(80,200,230,275)),
	win_SetBrush(_Win,brush(pat_Cross,color_Black)),
	PNTLIST =       [pnt(250,50), pnt(400,70),
			 pnt(320,80), pnt(380,150), pnt(150,100)],
	draw_Polygon(_Win,PNTLIST),!.

%BEGIN_WIN mywin
/**************************************************************************
	Creation and event handling for window: mywin
	Code style: Single window
**************************************************************************/

CONSTANTS
%BEGIN mywin, CreateParms, 12:39:10-24.11.1999, Code automatically updated!
  win_mywin_WinType = w_TopLevel
  win_mywin_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Close,wsf_Maximize,wsf_Minimize,wsf_ClipSiblings,wsf_ClipChildren]
  win_mywin_RCT = rct(35,50,605,411)
  win_mywin_Menu = res_menu(idr_task_menu)
  win_mywin_Title = "Mywin"
  win_mywin_Help = idh_contents
%END mywin, CreateParms

PREDICATES

  win_mywin_eh : EHANDLER

CLAUSES

  win_mywin_Create(Parent):-
	win_Create(win_mywin_WinType,win_mywin_RCT,win_mywin_Title,
		   win_mywin_Menu,Parent,win_mywin_Flags,win_mywin_eh,0).

%BEGIN mywin, e_Create
  win_mywin_eh(_Win,e_Create(_),0):-!,
%BEGIN mywin, InitControls, 12:39:10-24.11.1999, Code automatically updated!
%END mywin, InitControls
%BEGIN mywin, ToolbarCreate, 12:39:10-24.11.1999, Code automatically updated!
%END mywin, ToolbarCreate
	!.
%END mywin, e_Create
%MARK mywin, new events

%BEGIN mywin, e_CloseRequest
  win_mywin_eh(_Win,e_CloseRequest,0):-!,
	W=win_GetParent(_Win),
	menu_Enable(W,id_file_new,b_true),
	menu_Enable(W,id_file_print,b_false),
	menu_Update(W),
	win_Destroy(_Win),
	!.
%END mywin, e_CloseRequest

%BEGIN mywin, e_Update
  win_mywin_eh(_Win,e_Update(_Rct),0):-!,
  	win_Clear(_Win,color_White),
	FONT = font_Create(ff_helvetica,[],12),
	win_SetFont(_Win,FONT),
	draw(_Win),
	!.
%END mywin, e_Update
%BEGIN mywin, id_file_print
  win_mywin_eh(_Win,e_Menu(id_file_print,_ShiftCtlAlt),0):-
	FONT = font_Create(ff_helvetica,[],12),
	trap(PRINTWIN=print_StartJob("Test printing..."),_,fail),
	!,
	VResPrinter = vpi_GetAttrVal(attr_printer_vres),
	HResPrinter = vpi_GetAttrVal(attr_printer_hres),
	VResScreen = vpi_GetAttrVal(attr_screen_vres),
	HResScreen = vpi_GetAttrVal(attr_screen_hres),
	print_StartPage(PRINTWIN),
	win_SetMapMode(PRINTWIN,mm_arbitrary),
	win_SetMapScale(PRINTWIN,pnt(0,0),pnt(VResScreen,HResScreen),pnt(0,0),pnt(VResPrinter,HResPrinter)),
	win_SetFont(PRINTWIN,FONT),
	draw(PRINTWIN),
	print_EndPage(PRINTWIN),
	print_EndJob(PRINTWIN),
	!.
  win_mywin_eh(_Win,e_Menu(id_file_print,_ShiftCtlAlt),0):-!,
	Msg="Cannot initialize a print job",
	dlg_Note(Msg),
	!.
%END mywin, id_file_print
%BEGIN mywin, id_file_exit
  win_mywin_eh(_Win,e_Menu(id_file_exit,_ShiftCtlAlt),0):-!,
	PWin = win_GetParent(_Win),
	win_Destroy(PWin),
	!.
%END mywin, id_file_exit
%BEGIN mywin, e_Size
  win_mywin_eh(_Win,e_Size(_Width,_Height),0):-!,
IFDEF use_tbar
	toolbar_Resize(_Win),
ENDDEF
	!.
%END mywin, e_Size

%BEGIN mywin, e_Menu, Parent window 
  win_mywin_eh(Win,e_Menu(ID,CAS),0):-!,
	PARENT = win_GetParent(Win),
	win_SendEvent(PARENT,e_Menu(ID,CAS)),
	!.
%END mywin, e_Menu, Parent window
%END_WIN mywin





























