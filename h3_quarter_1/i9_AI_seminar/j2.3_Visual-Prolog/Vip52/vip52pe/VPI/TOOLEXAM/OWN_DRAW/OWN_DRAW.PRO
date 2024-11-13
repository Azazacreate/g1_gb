/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S
 
 Project:  OWN_DRAW
 FileName: OWN_DRAW.PRO
 Purpose: View owner draw
 Written by: Ilyin Yuri
 Comments:

******************************************************************************/

include "own_draw.inc"
include "own_draw.con"

/***************************************************************************
	Auxilliary predicates for window counting
***************************************************************************/
CONSTANTS
  ctl_GroupBox  = 501
  ctl_Button    = 502
  ctl_LBox      = 503
  ctl_CheckBox  = 504
  ctl_CheckBox1 = 509
  ctl_RadioB1   = 505
  ctl_RadioB2   = 506
  ctl_RadioB3   = 507
  ctl_RadioB4   = 510
  ctl_RadioB5   = 511
  
DATABASE - owndraw_win
  wincolor(WINDOW,COLOR)
determ  dialog_in_use
	use_window(WINDOW)

PREDICATES
  member(ILIST,INTEGER)
CLAUSES
  member([X|_],X):-!.
  member([_|T],X):-member(T,X).

PREDICATES
  drawMenu : OWNERDRAW_MENU_FUNC
  drawTaskMenu : OWNERDRAW_MENU_FUNC
CLAUSES
  drawTaskMenu(W,id_open_window,Rect,_):-
	Rect = rct(L,T,_,_),
	X = 2+L, Y = T,
	PICTURE = pict_GetFromRes(idb_menu1),
	pict_Draw(W,PICTURE,pnt(X,Y),rop_SrcCopy),
	pict_Destroy(PICTURE),!.
  drawTaskMenu(W,id_open_dialog,Rect,_):-
	Rect = rct(L,T,_,_),
	X = 2+L, Y = T,
	PICTURE = pict_GetFromRes(idb_menu2),
	pict_Draw(W,PICTURE,pnt(X,Y),rop_SrcCopy),
	pict_Destroy(PICTURE),
	!.
  drawTaskMenu(W,id_file_exit,Rect,_):-
	Rect = rct(L,T,_,_),
	X = 2+L, Y = T,
	PICTURE = pict_GetFromRes(idb_menu3),
	pict_Draw(W,PICTURE,pnt(X,Y),rop_SrcCopy),
	pict_Destroy(PICTURE),!.

  drawMenu(W,_,_,_):-
	FONT=font_Create(ff_times,[fs_Bold],10),
	win_SetFont(W,FONT),
	fail.
  drawMenu(W,_,_,b_true):-
	win_SetForeColor(W,color_Black),
	win_SetBackColor(W,color_LtGray),
	fail.
  drawMenu(W,id_window_new,Rect,_):-
	Rect = rct(L,T,_,_),
	X = 50+L, Y = 25+T,
	draw_Icon(W,10,8,9012),
	draw_Text(W,X,Y,"Open Window",-1),!.
  drawMenu(W,id_window_red,Rect,_):-
	Rect = rct(L,T,_,_), X = 40+L, Y = 25+T,
	draw_Text(W,X,Y,"Red Window",-1),!.
  drawMenu(W,id_window_green,Rect,_):-
	Rect = rct(L,T,_,_), X = 40+L, Y = 15+T,
	draw_Text(W,X,Y,"Green Window",-1),!.
  drawMenu(W,id_window_blue,Rect,_):-
	Rect = rct(L,T,_,_), X = 40+L, Y = 25+T,
	draw_Text(W,X,Y,"Blue Window",-1),!.
  drawMenu(W,id_window_close,Rect,_):-
	Rect = rct(L,T,_,_), X = 40+L, Y = 25+T,
	draw_Text(W,X,Y,"Close Window",-1),!.

PREDICATES
  draw_button : OWNERDRAW_BUT_FUNC

CLAUSES
  draw_button(W,X,Y,_):-
	win_SetForeColor(W,color_Blue),
	win_SetBackColor(W,color_LtGray),
	FONT=font_Create(ff_times,[fs_Bold],10),
	win_SetFont(W,FONT),
	X1 = 10+X, Y1 = 30+Y, X2 = 20+X, Y2 = 50+Y, Y3 = 52+Y, X4 = 30+X, Y4 = Y+54,
	draw_text(W,X1,Y1,"Ownerdraw",-1),
	draw_text(W,X2,Y2,"Button",-1),
	win_SetPen(W,pen(2,ps_solid,color_Red)),
	draw_Line(W,pnt(10,Y3),pnt(90,Y3)),
	draw_Icon(W,X4,Y4,9012).

PREDICATES
  draw_Lbox : OWNERDRAW_LBOX_FUNC
CLAUSES
  draw_Lbox(W,RECT,SHIFT,STRITEM,_):-
	RECT=rct(_,TOP,_,_),
	TOP2=TOP+14+SHIFT,
	win_SetForeColor(W,color_Black),
	win_SetBackColor(W,color_LtGray),
	FONT=font_Create(ff_Helvetica,[],8),
	win_SetFont(W,FONT),
	draw_Text(W,20,TOP2,STRITEM,-1).

PREDICATES
  draw_checkbox :       OWNERDRAW_CHECK_FUNC

CLAUSES
  draw_checkbox(W,_,CRCT,b_true):-
	win_SetPen(W,pen(2,ps_Solid,color_Gray)),
	CRCT = rct(L,T,R,B),
	draw_Line(W,pnt(L,T),pnt(R,B)),
	draw_Line(W,pnt(L,B),pnt(R,T)),
	win_SetForeColor(W,color_Black),
	win_SetBackColor(W,color_LtGray),
	FONT=font_Create(ff_Helvetica,[fs_Bold],8),
	win_SetFont(W,FONT),
	draw_Text(W,24,14,"Checked",-1),!.

  draw_checkbox(W,_,_,b_false):-
	win_SetForeColor(W,color_Black),
	win_SetBackColor(W,color_LtGray),
	FONT=font_Create(ff_Helvetica,[fs_Bold],8),
	win_SetFont(W,FONT),
	draw_Text(W,24,14,"UnChecked",-1).

PREDICATES
  draw_radiobox :       OWNERDRAW_RADIO_FUNC
  radio_box_text ( INTEGER, STRING )

CLAUSES
  draw_radiobox(_,W,_,_,b_false):-
	win_SetForeColor(W,color_Black),
	win_SetBackColor(W,color_LtGray),
	FONT=font_Create(ff_Helvetica,[fs_Bold],8),
	win_SetFont(W,FONT),
	draw_Text(W,24,14,"UnChoosed",-1),!.

  draw_radiobox(CtrlID,W,_,CRCT,b_true):-
	win_SetForeColor(W,color_Black),
	win_SetBackColor(W,color_LtGray),
	FONT=font_Create(ff_Helvetica,[fs_Bold],8),
	win_SetFont(W,FONT),
	win_SetPen(W,pen(1,ps_Solid,color_Black)),
	win_SetBrush(W,brush(pat_Solid,color_Black)),
	RECT = rect_Inflate(CRCT,-2,-2),
	draw_Ellipse(W,RECT),
	radio_box_text ( CtrlId, Text ),
	draw_Text(W,24,14,Text,-1),!.

  radio_box_text ( ctl_RadioB1, "Choose 1" ) :- !.
  radio_box_text ( ctl_RadioB2, "Choose 2" ) :- !.
  radio_box_text ( ctl_RadioB3, "Choose 3" ) :- !.
  radio_box_text ( ctl_RadioB4, "Choose 4" ) :- !.
  radio_box_text ( ctl_RadioB5, "Choose 5" ) :- !.

PREDICATES
  draw_Frame(WINDOW)

CLAUSES
  draw_Frame(W):-
	win_SetPen(W,pen(1,ps_Solid,color_Gray)),
	draw_PolyLine(W,[pnt(10,230),pnt(10,10),pnt(410,10)]),
	win_SetPen(W,pen(1,ps_Solid,color_White)),
	draw_PolyLine(W,[pnt(10,230),pnt(410,230),pnt(410,10)]).

%BEGIN_WIN Task Window
/***************************************************************************
		Event handling for task window
***************************************************************************/

PREDICATES

  task_win_eh : EHANDLER

CONSTANTS

%BEGIN Task Window, CreateParms, 13:39:00-24.11.1999, Code automatically updated!
  task_win_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Close,wsf_Maximize,wsf_Minimize,wsf_ClipSiblings,wsf_ClipChildren]
  task_win_Menu  = res_menu(idr_task_menu)
  task_win_Title = "Own_Draw"
  task_win_Help  = idh_contents
%END Task Window, CreateParms

CLAUSES

%BEGIN Task Window, e_Create
  task_win_eh(_Win,e_Create(_),0):-!,
%BEGIN Task Window, ToolbarCreate, 13:39:00-24.11.1999, Code automatically updated!
%END Task Window, ToolbarCreate
IFDEF use_message
	msg_Create(100),
ENDDEF
	!.
%END Task Window, e_Create

%MARK Task Window, new events

%BEGIN Task Window, e_OwnerMeasureItem
  task_win_eh(_,e_OwnerMeasureItem(od_Menu,_,ID,_),SIZE):-
	ownerdraw_MeasureControl(ID,SIZE),!.
%END Task Window, e_OwnerMeasureItem
%BEGIN Task Window, e_OwnerDraw
  task_win_eh(W,e_OwnerDraw(od_Menu,_,MENU_TAG,ACTIONLIST,STATELIST,_,_,_),0):-
	ownerdraw_DrawMenu(ACTIONLIST,STATELIST,W,MENU_TAG,drawTaskMenu),!.
%END Task Window, e_OwnerDraw
%BEGIN Task Window, id_Open_window
  task_win_eh(TASK,e_Menu(id_open_window,_),0) :-!,
	win_window_Create(TASK),
	!.
%END Task Window, id_Open_window
%BEGIN Task Window, id_Open_dialog
  task_win_eh(TASK,e_Menu(id_Open_dialog,_ShiftCtlAlt),0):-!,
	assert(dialog_in_use),
	dlg_dialog_Create(TASK),
	!.
%END Task Window, id_Open_dialog
%BEGIN Task Window, e_Update
  task_win_eh(W,e_Update(_),0):-!,
	win_SetPen ( W, pen ( 1, ps_Solid, color_LtGray ) ),
	win_SetBrush ( W ,brush ( pat_Solid, color_LtGray ) ),
	RCT = win_GetClientRect ( W ),
	draw_Rect ( W, RCT ),
	Str0 = "	1) Use RIGHT MOUSE BUTTON to see popup menu\n",
	Str1 = "	or choose main menu item.\n",
	Str2 = "	2) RIGHT MOUSE BUTTON is also active\n",
	Str3 = "	in opened windows.\n",
	format ( Str, "\n\n\n%s%s\n%s%s", Str0, Str1, Str2, Str3 ),
	draw_TextInRect( W, RCT, Str, -1, [ dtext_expandtabs ] ).
%END Task Window, e_Update
%BEGIN Task Window, e_MouseDown
  task_win_eh(_,e_MouseDown(_,_,1),0) :-
  	use_window(_),!.
  task_win_eh(W,e_MouseDown(PNT,_,1),0) :-
	ownerdraw_CreateMenu([ownerdraw_item_def(id_open_window,100,48,[]),
			      ownerdraw_item_def(id_open_dialog,100,48,[]),
			      ownerdraw_item_def(id_file_exit,100,48,[])
			     ],MENU),
	menu_PopUp(W,MENU,PNT,align_left),
	!.
%END Task Window, e_MouseDown
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
%BEGIN Task Window, id_help_contents
IFDEF use_on_line_help
  task_win_eh(_Win,e_Menu(id_help_contents,_ShiftCtlAlt),0):-!,
	vpi_ShowHelp("own_draw.hlp"),
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
  vpi_Init(task_win_Flags,task_win_eh,task_win_Menu,"own_draw",task_win_Title).

%END_WIN Task Window


%BEGIN_WIN Window
/**************************************************************************
        Creation and event handling for window: Window
**************************************************************************/

CONSTANTS
%BEGIN Window, CreateParms, 17:07:47-19.2.1996, Code automatically updated!
  win_window_WinType = w_TopLevel
  win_window_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Maximize,wsf_Minimize,wsf_Close,wsf_ClipSiblings,wsf_ClipChildren]
  win_window_RCT = rct(10,30,450,300)
  win_window_Menu = res_menu(idr_win_menu)
  win_window_Title = "Window"
  win_window_Help = idh_contents
%END Window, CreateParms

PREDICATES

  WIN_WINDOW_EH : EHANDLER

CLAUSES

  win_window_Create(Parent):-
	win_Create(win_window_WinType,win_window_RCT,win_window_Title,
		   win_window_Menu,Parent,win_window_Flags,win_window_eh,0).

%BEGIN Window, e_Create
  win_window_eh(_Win,e_Create(_),0):-!,
%BEGIN Window, InitControls, 17:07:47-19.2.1996, Code automatically updated!
%END Window, InitControls
%BEGIN Window, ToolbarCreate, 17:07:47-19.2.1996, Code automatically updated!
%END Window, ToolbarCreate
	ownerdraw_CreateControl(wc_PushButton, ctl_Button,rct(40,40,140,140),
		"Push Button",_Win),
	ownerdraw_CreateControl(wc_CheckBox,ctl_CheckBox,rct(40,150,140,170),
		"Check Box",_Win),
	ownerdraw_CreateControl(wc_CheckBox,ctl_CheckBox1,rct(40,180,140,200),
		"Check Box",_Win),
	LIST=["DOS","Pharlap","Windows 3.1","Windows NT","OS/2",
		"OS/2 PM","Unix"],
	ownerdraw_CreateListBox(ctl_LBox,rct(150,40,280,140),"",_Win,LIST,0,4),
	ownerdraw_CreateControl(wc_RadioButton,ctl_RadioB1,rct(290,40,390,60),
		"Radio Box 1",_Win),
	ownerdraw_CreateControl(wc_RadioButton,ctl_RadioB2,rct(290,70,390,90),
		"Radio Box 2",_Win),
	ownerdraw_CreateControl(wc_RadioButton,ctl_RadioB3,rct(290,100,390,120),
		"Radio Box 3",_Win),
	ownerdraw_CreateControl(wc_RadioButton,ctl_RadioB4,rct(290,150,390,170),
		"Radio Box 4",_Win),
	ownerdraw_CreateControl(wc_RadioButton,ctl_RadioB5,rct(290,180,390,200),
		"Radio Box 5",_Win),
	ownerdraw_CreateGroupBox(rct(285,140,395,205),_Win),
	assert(use_window(_Win)),
	!.
%END Window, e_Create
%MARK Window, new events

%BEGIN Window, e_CloseRequest
  win_window_eh(_Win,e_CloseRequest,0):-!,
	retractall(use_window(_Win)),
	win_Destroy(_Win),
	!.
%END Window, e_CloseRequest

%BEGIN Window, id_Window_red
  win_window_eh(_Win,e_Menu(id_Window_red,_ShiftCtlAlt),0):-!,
	retractall(wincolor(_Win,_)),assert(wincolor(_Win,color_Red)),
	win_Invalidate ( _Win ),
	!.
%END Window, id_Window_red

%BEGIN Window, id_Window_new
  win_window_eh(_Win,e_Menu(id_Window_new,_ShiftCtlAlt),0):-!,
	Parent=win_GetParent(_Win),
	win_window_Create(Parent),
	!.
%END Window, id_Window_new

%BEGIN Window, id_Window_green
  win_window_eh(_Win,e_Menu(id_Window_green,_ShiftCtlAlt),0):-!,
	retractall(wincolor(_Win,_)),assert(wincolor(_Win,color_Green)),
	win_Invalidate ( _Win ),
	!.
%END Window, id_Window_green

%BEGIN Window, id_Window_close
  win_window_eh(_Win,e_Menu(id_Window_close,_ShiftCtlAlt),0):-!,
  	win_Destroy(_Win),
  	retract(use_window(_Win)),
  	!.
%END Window, id_Window_close

%BEGIN Window, id_Window_blue
  win_window_eh(_Win,e_Menu(id_Window_blue,_ShiftCtlAlt),0):-!,
	retractall(wincolor(_Win,_)),assert(wincolor(_Win,color_Blue)),
	win_Invalidate ( _Win ),
	!.
%END Window, id_Window_blue

  win_window_eh(_,e_Control(ctl_Button,_,_,_),0):-dialog_in_use,!,
	!.
  win_window_eh(_,e_Control(ctl_Button,_,_,_),0):-!,
	dlg_Note("","Click the right mouse button\n inside Test Window").

  win_window_eh(_,e_Control(ctl_LBox,_,LBOXWIN,activated()),0):-!,
	INDEX=lbox_GetSelIndex(LBOXWIN),
	STR=lbox_GetItem(LBOXWIN,INDEX),
	dlg_Note("",STR).

%BEGIN Window, e_Destroy
  win_window_eh(_,e_Destroy,0):-
  	retract( dialog_in_use ),
  	fail.
  win_window_eh(_Win,e_Destroy,0):-!,
	ownerdraw_Destroy(_Win).
%END Window, e_Destroy

%BEGIN Window, e_Update
  win_window_eh(W,e_Update(_),0):-
  	Type = win_GetType ( W ),
  	member ( [ wd_Modal, wd_Modeless ], Type ), !.
  win_window_eh(W,e_Update(_),0):-
	wincolor(W,COLOR),!,
	win_SetPen ( W, pen ( 1, ps_Solid, COLOR ) ),
	win_SetBrush ( W, brush ( pat_Solid, COLOR ) ),
	RCT = win_GetClientRect ( W ),
	draw_Rect ( W, RCT ),
	draw_Frame(W).

  win_window_eh(W,e_Update(_),0):- !,
	win_SetPen ( W, pen ( 1, ps_Solid, color_LtGray ) ),
	win_SetBrush ( W, brush ( pat_Solid, color_LtGray ) ),
	RCT = win_GetClientRect ( W ),
	draw_Rect ( W, RCT ),
	draw_Frame(W).

%END Window, e_Update

%BEGIN Window, e_OwnerMeasureItem
  win_window_eh(_,e_OwnerMeasureItem(od_Button,ID,_,_),SIZE):-
	ownerdraw_MeasureControl(ID,SIZE),!.
  win_window_eh(_,e_OwnerMeasureItem(od_LBox,ID,_,_),SIZE):-
	ownerdraw_MeasureControl(ID,SIZE),!.
  win_window_eh(_,e_OwnerMeasureItem(od_Menu,_,ID,_),SIZE):-
	ownerdraw_MeasureControl(ID,SIZE),!.

%END Window, e_OwnerMeasureItem

%BEGIN Window, e_MouseDown
  win_window_eh(_Win,e_MouseDown(PNT,_,mouse_button_right),0):-
  	not ( dialog_in_use ),!,
	ownerdraw_CreateMenu([ownerdraw_item_def(id_window_new,160,48,[]),
			      ownerdraw_item_def(id_window_red,160,48,[]),
			      ownerdraw_item_def(id_window_green,160,28,[]),
			      ownerdraw_item_def(id_window_blue,160,48,[]),
			      ownerdraw_item_def(id_window_close,160,48,[])
			     ],MENU),
	menu_PopUp(_Win,MENU,PNT,align_left),
	!.
%END Window, e_MouseDown

%BEGIN Window, e_OwnerDraw
  win_window_eh(_Win,e_OwnerDraw(od_Button,ID,_,ACTIONLIST,STATELIST,CW,RECT,_),0):-
	member([ctl_CheckBox,ctl_CheckBox1],ID),!,
	ownerdraw_DrawCheck(ACTIONLIST,STATELIST,RECT,rct(4,4,15,15),_Win,
		CW,draw_checkbox).

  /* owner draw RadioBox */
  win_window_eh(_Win,e_OwnerDraw(od_Button,ID,_,ACTIONLIST,STATELIST,CW,RECT,_),0):-
	member([ctl_RadioB1,ctl_RadioB2,ctl_RadioB3,ctl_RadioB4,ctl_RadioB5],ID),!,
	ownerdraw_DrawRadio(ACTIONLIST,STATELIST,RECT,rct(4,4,15,15),_Win,CW,
		ID,draw_radiobox).

  /* owner draw ListBox */
  win_window_eh(_Win,e_OwnerDraw(od_LBox,ctl_LBox,ITEM,ACTIONLIST,STATELIST,CW,RECT,_),0):-
	ownerdraw_DrawListBox(ACTIONLIST,STATELIST,RECT,_Win,
		CW,ITEM,draw_Lbox,b_true),!.

  /* owner draw Push Button */
  win_window_eh(_Win,e_OwnerDraw(od_Button,ctl_Button,_,ACTIONLIST,STATELIST,CtrlW,RECT,_),0):-
	ownerdraw_DrawButton(ACTIONLIST,STATELIST,RECT,CtrlW,draw_button),!.

  win_window_eh(_Win,e_OwnerDraw(od_Menu,_,MENU_TAG,ACTIONLIST,STATELIST,_,_,_),0):-
	ownerdraw_DrawMenu(ACTIONLIST,STATELIST,_Win,MENU_TAG,drawMenu),!.

%END Window, e_OwnerDraw

%BEGIN Window, e_Size
  win_window_eh(_Win,e_Size(_Width,_Height),0):-!,
IFDEF use_tbar
	toolbar_Resize(_Win),
ENDDEF
	RCT = win_GetClientRect(_Win),
	win_Invalidate(_Win,RCT),
	!.
%END Window, e_Size

%BEGIN Window, e_Menu, Parent window 
  win_window_eh(Win,e_Menu(ID,CAS),0):-!,
	PARENT = win_GetParent(Win),
	win_SendEvent(PARENT,e_Menu(ID,CAS)),
	!.
%END Window, e_Menu, Parent window

%END_WIN Window

%BEGIN_DLG Dialog
/**************************************************************************
	Creation and event handling for dialog: Dialog
**************************************************************************/

CONSTANTS

%BEGIN Dialog, CreateParms, 13:38:44-24.11.1999, Code automatically updated!
  dlg_dialog_DlgType = wd_Modal
  dlg_dialog_Title = "Dialog"
  dlg_dialog_RCT = rct(5,15,225,150)
  dlg_dialog_Flags = [wsf_Close,wsf_TitleBar,wsf_ClipChildren,wsf_ClipSiblings]
  dlg_dialog_Help = idh_contents
%END Dialog, CreateParms

PREDICATES

  dlg_dialog_eh : EHANDLER

CLAUSES

  dlg_dialog_Create(Parent):-
	win_CreateDynDialog(Parent,
		[
%BEGIN Dialog, WinDefList, 13:38:44-24.11.1999, Code automatically updated!
		 dlg(wdef(dlg_dialog_DlgType,dlg_dialog_RCT,dlg_dialog_Title,u_DlgBase),dlg_dialog_Flags)
%END Dialog, WinDefList
		],win_window_eh,0),!.

%MARK Dialog, new events

  dlg_dialog_eh(_,_,_):-!,fail.

%END_DLG Dialog


























































%BEGIN_DLG About dialog
/**************************************************************************
	Creation and event handling for dialog: About dialog
**************************************************************************/

CONSTANTS

%BEGIN About dialog, CreateParms, 13:38:54-24.11.1999, Code automatically updated!
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


































