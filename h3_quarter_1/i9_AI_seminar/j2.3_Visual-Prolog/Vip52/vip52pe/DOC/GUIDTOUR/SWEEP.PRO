/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  MYPROJ
 FileName: SWEEP.PRO
 Purpose: A little Demo
 Written by: Leo Jensen
 Comments:
******************************************************************************/

include "myproj.inc"
include "myproj.con"
include "hlptopic.con"

/******************************************************
	Drawing the sweep lines
******************************************************/

predicates
 connect(WINDOW,pntlist)
 drawlines(WINDOW,PNT,pntlist)

clauses
 connect(_,[]):-!.
 connect(Win,[FROM|REST]):-
   drawlines(Win,FROM,REST),
   connect(Win,REST).

 drawlines(_,_,[]):-!.
 drawlines(Win,pnt(X,Y),[pnt(TOX,TOY)|REST]):-
   draw_Line(Win,pnt(X,Y),pnt(TOX,TOY)),
   drawlines(Win,pnt(X,Y),REST).

/******************************************************
	Facts for doing the sweep
******************************************************/

facts - apl
  nocopy point(WINDOW,PNT)
  mouse_isdown(WINDOW)

/******************************************************
	Draw the sweep window
******************************************************/
predicates
  sweep_Draw(WINDOW Win,WINDOW AssertWin)

clauses
  sweep_Draw(_Win,AssertWin):-
	win_Clear(_Win, color_White),
	findall(X,point(AssertWin,X),List),
	connect(_Win,List).

%BEGIN_TLB Sweep toolbar, 10:09:30-24.11.1999, Code automatically updated!
/**************************************************************************
	Creation of toolbar: Sweep toolbar
**************************************************************************/

clauses

  tb_sweep_toolbar_Create(_Parent):-
ifdef use_tbar
	toolbar_create(tb_right,0xFF00,_Parent,
		[tb_ctrl(id_clear,pushb,idb_mybmp_norm,idb_mybmp_down,idb_mybmp_down,"",1,1)]),
enddef
	true.
%END_TLB Sweep toolbar

%BEGIN_WIN Sweep
/**************************************************************************
        Creation and event handling for window: Sweep
**************************************************************************/

constants
%BEGIN Sweep, CreateParms, 10:07:44-24.11.1999, Code automatically updated!
  win_sweep_WinType = w_TopLevel
  win_sweep_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Close,wsf_Maximize,wsf_Minimize,wsf_ClipSiblings,wsf_ClipChildren]
  win_sweep_RCT = rct(100,80,440,240)
  win_sweep_Menu = res_menu(idr_sweep_men)
  win_sweep_Title = "Sweep"
  win_sweep_Help = idh_contents
%END Sweep, CreateParms

predicates

  win_sweep_eh : EHANDLER

clauses

  win_sweep_Create(Parent):-
	win_Create(win_sweep_WinType,win_sweep_RCT,win_sweep_Title,
		   win_sweep_Menu,Parent,win_sweep_Flags,win_sweep_eh,0).

%BEGIN Sweep, e_Create
  win_sweep_eh(_Win,e_Create(_),0):-!,
	cursor_Set(_Win, idc_sweep),
%BEGIN Sweep, InitControls, 10:07:44-24.11.1999, Code automatically updated!
%END Sweep, InitControls
%BEGIN Sweep, ToolbarCreate, 10:07:44-24.11.1999, Code automatically updated!
	tb_sweep_toolbar_Create(_Win),
%END Sweep, ToolbarCreate
	!.
%END Sweep, e_Create
%MARK Sweep, new events

%BEGIN Sweep, e_MouseDown
  win_sweep_eh(_Win,e_MouseDown(PNT,_ShiftCtlAlt,mouse_button_right),0):-!,
	menu_PopUp(_Win,res_menu(idr_sweep_popup),PNT, align_Right).

  win_sweep_eh(_Win,e_MouseDown(_PNT,_ShiftCtlAlt,mouse_button_left),0):-!,
	retractall(mouse_isdown(_Win)),
	retractall(point(_Win,_)),
	assert(mouse_isdown(_Win)),
	win_Invalidate(_Win),
	!.
%END Sweep, e_MouseDown

%BEGIN Sweep, e_MouseUp
  win_sweep_eh(_Win,e_MouseUp(_PNT,_ShiftCtlAlt,mouse_button_left),0):-!,
	retractall(mouse_isdown(_Win)),
	win_Invalidate(_Win),
	!.
%END Sweep, e_MouseUp

%BEGIN Sweep, e_MouseMove
  win_sweep_eh(_Win,e_MouseMove(_PNT,_ShiftCtlAlt,_Button),0):-!,
	mouse_isdown(_Win),
	assert(point(_Win,_PNT)),
	draw_Pixel(_Win,_PNT,color_Black),
	!.
%END Sweep, e_MouseMove

%BEGIN Sweep, e_Update
  win_sweep_eh(_Win,e_Update(_),0):-!,
	sweep_Draw(_Win,_Win),
	!.
%END Sweep, e_Update

  win_sweep_eh(_Win,e_Menu(id_close,_ShiftCtlAlt),0):-!,
	win_Destroy(_Win).

  win_sweep_eh(_Win,e_Menu(id_maximize,_ShiftCtlAlt),0):-!,
	win_SetState(_Win, [wsf_Maximized]).

  win_sweep_eh(_Win,e_Menu(id_restore,_ShiftCtlAlt),0):-!,
	win_SetState(_Win, [wsf_Restored]).

  win_sweep_eh(_Win,e_Menu(id_color,_ShiftCtlAlt),0):-!,
	Pen=win_GetPen(_Win),
	Pen = pen(Penwidth,PenStyle,Color),
	NewColor = dlg_ChooseColor(Color),
	win_SetPen(_Win,pen(Penwidth,PenStyle,NewColor)),
	win_Invalidate(_Win).

  win_sweep_eh(_Win,e_Menu(id_edit_copy,_),0):-!,
	RCT=win_GetClientRect(_Win),
	PW = pict_Open(RCT),
	sweep_Draw(PW,_Win),
	Picture = pict_Close( PW ),
	cb_PutPicture(Picture),
	pict_Destroy(Picture).

  win_sweep_eh(_Win,e_Menu(id_edit_paste,_),0):-
	trap(Picture=cb_GetPicture(),_,fail),!,
	pict_Draw(_Win,Picture,pnt(0,0),rop_SrcCopy),
	pict_Destroy(Picture).
  win_sweep_eh(_Win,e_Menu(id_edit_paste,_),0):-!,
	Msg="No picture in clipboard",
	dlg_Note(Msg).

  win_sweep_eh(_Win,e_Menu(id_print,_),0):-!,
	ScreenRCT=win_GetClientRect(_Win),
	ScreenRCT=rct(_,_,WinSize,_),
        PRINTWIN=print_StartJob("Printing Sweep drawing"),
        print_StartPage(PRINTWIN),
  	PrnSize = vpi_GetAttrVal(attr_printer_width),
	win_SetMapMode(PRINTWIN,mm_arbitrary),
	win_SetMapScale(PRINTWIN,pnt(0,0),pnt(WinSize,WinSize),pnt(0,0),pnt(PrnSize,PrnSize)),
	findall(X,point(_Win,X),List),
	connect(PRINTWIN,List),
        print_EndPage(PRINTWIN),
	print_EndJob(PRINTWIN).

%BEGIN Sweep, id_clear
  win_sweep_eh(_Win,e_Menu(id_clear,_ShiftCtlAlt),0):-!,
	retractall(mouse_isdown(_Win)),
	retractall(point(_Win,_)),
	win_Clear(_Win, color_White),
	!.
%END Sweep, id_clear

%BEGIN Sweep, e_Destroy
  win_sweep_eh(_Win,e_Destroy,0):-!,
	retractall(mouse_isdown(_Win)),
	retractall(point(_Win,_)),
	!.
%END Sweep, e_Destroy

%BEGIN Sweep, e_Size
  win_sweep_eh(_Win,e_Size(_Width,_Height),0):-!,
ifdef use_tbar
	toolbar_Resize(_Win),
enddef
	!.
%END Sweep, e_Size

%BEGIN Sweep, e_Menu, Parent window 
  win_sweep_eh(Win,e_Menu(ID,CAS),0):-!,
	PARENT = win_GetParent(Win),
	win_SendEvent(PARENT,e_Menu(ID,CAS)),
	!.
%END Sweep, e_Menu, Parent window

%END_WIN Sweep
