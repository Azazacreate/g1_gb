/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 FileName:	PALTEST.PRO
 Purpose:	Palette example application
 Written by:	Andrey Skobelev
 Comments:	
******************************************************************************/

include "paltest.inc"
include "paltest.con"
include "hlptopic.con"

database - paltest_db
  db_test(WINDOW)

predicates

  palette_Callback : PALETTE_CALLBACK % Palette callback function

  colorList_member(INTEGER,INTEGER,COLORLIST,COLORLIST)
  colorNameToNumber(STRING,LONG)
  penNameToPENWIDTH_PENSTYLE(STRING,PENWIDTH,PENSTYLE)
  brushNameToPATSTYLE(STRING,PATSTYLE)

clauses
  colorList_member(X,NEntr,[_|Rest],Rest1):-
	M = X + 1, not(X = NEntr),
	colorList_member(M,NEntr,Rest,Rest1),!.
  colorList_member(_,_,RestOut,RestOut):-!.

  colorNameToNumber("White",0xFFFFFF):-!.
  colorNameToNumber("Black",0x000000):-!.
  colorNameToNumber("Gray",0x808080):-!.
  colorNameToNumber("LtGray",0xC0C0C0):-!.
  colorNameToNumber("Red",0x0000FF):-!.
  colorNameToNumber("DkRed",0x000080):-!.
  colorNameToNumber("Green",0x00FF00):-!.
  colorNameToNumber("DkGreen",0x008000):-!.
  colorNameToNumber("Blue",0xFF0000):-!.
  colorNameToNumber("DkBlue",0x800000):-!.
  colorNameToNumber("Cyan",0xFFFF00):-!.
  colorNameToNumber(_,0):-!.
  
  penNameToPENWIDTH_PENSTYLE("Solid 1",1,ps_Solid):-!.
  penNameToPENWIDTH_PENSTYLE("Solid 3",3,ps_Solid):-!.
  penNameToPENWIDTH_PENSTYLE("Dash 1",1,ps_Dash):-!.
  penNameToPENWIDTH_PENSTYLE("Dot 1",1,ps_Dot):-!.
  penNameToPENWIDTH_PENSTYLE("DashDot 1",1,ps_DashDot):-!.
  penNameToPENWIDTH_PENSTYLE("DashDotDot 1",1,ps_DashDotDot):-!.
  penNameToPENWIDTH_PENSTYLE("Hollow 1",1,ps_Hollow):-!.
  penNameToPENWIDTH_PENSTYLE(_,1,ps_Solid):-!.

  brushNameToPATSTYLE("Hollow",pat_Hollow):-!.
  brushNameToPATSTYLE("Solid",pat_Solid):-!.
  brushNameToPATSTYLE("Horz",pat_Horz):-!.
  brushNameToPATSTYLE("Vert",pat_Vert):-!.
  brushNameToPATSTYLE("FDiag",pat_FDiag):-!.
  brushNameToPATSTYLE("BDiag",pat_BDiag):-!.
  brushNameToPATSTYLE("Cross",pat_Cross):-!.
  brushNameToPATSTYLE("DiagCross",pat_DiagCross):-!.
  brushNameToPATSTYLE(_,pat_Solid):-!.

/*******************************************************************
	Palette callback function 
*******************************************************************/
% If callback function fails, then preview is drawn automatically.
% Events :change_PATSTYLE,change_PEN,change_PenColor,change_BrushColor
  palette_Callback(_PalWin,Event):- nl,write("CALLBACK: ",Event),fail.
			
% If callback function fails, then palette dialog is destroyed 
  palette_Callback(PalWin,is_ToBeDestroyed):- 
	retract(db_test(PalWin)),!,fail.


%BEGIN_WIN Task Window
/***************************************************************************
	Event handling for Task Window
***************************************************************************/
predicates
  
  task_win_eh : EHANDLER

constants

%BEGIN Task Window, CreateParms, 14:04:16-24.11.1999, Code automatically updated!
  task_win_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Close,wsf_Maximize,wsf_Minimize,wsf_ClipSiblings]
  task_win_Menu  = res_menu(idr_task_menu)
  task_win_Title = "Paltest"
  task_win_Help  = idh_contents
%END Task Window, CreateParms

clauses

%BEGIN Task Window, e_Create
  task_win_eh(_Win,e_Create(_),0):-!,
%BEGIN Task Window, InitControls, 14:04:16-24.11.1999, Code automatically updated!
%END Task Window, InitControls
%BEGIN Task Window, ToolbarCreate, 14:04:16-24.11.1999, Code automatically updated!
	tb_project_toolbar_Create(_Win),
	tb_help_line_Create(_Win),
%END Task Window, ToolbarCreate
ifdef use_message
	msg_Create(100),
enddef
	!.
%END Task Window, e_Create

%MARK Task Window, new events

%BEGIN Task Window, id_help_contents
  task_win_eh(_Win,e_Menu(id_help_contents,_ShiftCtlAlt),0):-!,
  	vpi_ShowHelp("paltest.hlp"),
	!.
%END Task Window, id_help_contents

%BEGIN Task Window, id_help_about
  task_win_eh(Win,e_Menu(id_help_about,_ShiftCtlAlt),0):-!,
	dlg_about_dialog_Create(Win),
	!.
%END Task Window, id_help_about

%BEGIN Task Window, id_preview_pattern
  task_win_eh(_Win,e_Menu(id_preview_pattern,_ShiftCtlAlt),0):-
	db_test(PalWin),
	palette_Setup(PalWin,preview(on(pnt(5,5)))),
	palette_Setup(PalWin,pen(off)),
	palette_Setup(PalWin,color(off)),
	palette_Setup(PalWin,pattern(on(pnt(55,5)))),
	win_Move(PalWin,rct(100,100,245,150)),
	fail.
%END Task Window, id_preview_pattern

%BEGIN Task Window, id_color_pen
  task_win_eh(_Win,e_Menu(id_color_pen,_ShiftCtlAlt),0):-
	db_test(PalWin),
	palette_Setup(PalWin,preview(off)),
	palette_Setup(PalWin,pen(on(pnt(5,50)))),
	palette_Setup(PalWin,color(on(pnt(5,5)))),
	palette_Setup(PalWin,pattern(off)),
	win_Move(PalWin,rct(100,100,320,200)),
	fail.
%END Task Window, id_color_pen

/* Get Preview for Pen and Brush */
%BEGIN Task Window, id_GetPreview
  task_win_eh(_Win,e_Menu(id_GetPreview,_ShiftCtlAlt),0):-
	db_test(PalWin),
	palette_GetPreview(PalWin,PEN,BRUSH),
	nl,write("PREVIEW: ",PEN," ",BRUSH),
	fail.

  task_win_eh(_Win,e_Menu(id_GetPreview,_ShiftCtlAlt),0):-!,
	not(db_test(_)),
	dlg_Note("Warning","Palette not created !\n Please, press F7 or F8 button"),
	!.
%END Task Window, id_GetPreview

/* Create dialog "Preview dialog" for choice of */
/* palette_SetPreview predicate arguments (Pen and Brush) */
%BEGIN Task Window, id_SetPreview
  task_win_eh(_Win,e_Menu(id_SetPreview,_ShiftCtlAlt),0):-
	dlg_palette_setpreview_Create(_Win),
	!.
%END Task Window, id_SetPreview

/* Create Pallete dialog : palette_Create/6 */
%BEGIN Task Window, id_file_open
  task_win_eh(TaskWin,e_Menu(id_file_open,_ShiftCtlAlt),0):-!,
	PalWin = palette_Create(TaskWin,pnt(10,50),palette_Callback,"Palette dialog",b_true,b_true),
	assert(db_test(PalWin)),
	!.
%END Task Window, id_file_open

/* Create dialog "Choice dialog" for choice of palette_Create/8 predicate arguments */
/* (ColorButtons and ColorList) */
%BEGIN Task Window, id_file_new
  task_win_eh(_Win,e_Menu(id_file_new,_ShiftCtlAlt),0):-!,
	dlg_choice_color_Create(_Win),
	!.
%END Task Window, id_file_new

%BEGIN Task Window, id_file_exit
  task_win_eh(Win,e_Menu(id_file_exit,_ShiftCtlAlt),0):-!,
  	win_Destroy(Win),
	!.
%END Task Window, id_file_exit

%BEGIN Task Window, e_Size
  task_win_eh(_Win,e_Size(_Width,_Height),0):-!,
ifdef use_tbar
	toolbar_Resize(_Win),
enddef
ifdef use_message
	msg_Resize(_Win),
enddef
	!.
%END Task Window, e_Size

%END_WIN Task Window

/***************************************************************************
	Invoking on-line Help
***************************************************************************/
  project_ShowHelpContext(HelpTopic):-
  	vpi_ShowHelpContext("paltest.hlp",HelpTopic),!.

/***************************************************************************
	Main Goal
***************************************************************************/

GOAL

ifdef use_mdi
  vpi_SetAttrVal(attr_win_mdi,b_true),
enddef
ifdef use_3dctrl
  vpi_SetAttrVal(attr_win_3dcontrols,b_true),
enddef
  vpi_Init(task_win_Flags,task_win_eh,task_win_Menu,"paltest",task_win_Title).

%BEGIN_TLB Project toolbar, 14:04:42-24.11.1999, Code automatically updated!
/**************************************************************************
	Creation of toolbar: Project toolbar
**************************************************************************/

clauses

  tb_project_toolbar_Create(_Parent):-
ifdef use_tbar
	toolbar_create(tb_top,0xC0C0C0,_Parent,
		[tb_ctrl(id_file_new,pushb,idb_new_up,idb_new_dn,idb_new_up,"New;New file",1,1),
		 tb_ctrl(id_file_open,pushb,idb_open_up,idb_open_dn,idb_open_up,"Open;Open file",1,1),
		 tb_ctrl(id_file_save,pushb,idb_save_up,idb_save_dn,idb_save_up,"Save;File save",1,1),
		 separator,
		 tb_ctrl(id_edit_undo,pushb,idb_undo_up,idb_undo_dn,idb_undo_up,"Undo;Undo",1,1),
		 tb_ctrl(id_edit_redo,pushb,idb_redo_up,idb_redo_dn,idb_redo_up,"Redo;Redo",1,1),
		 separator,
		 tb_ctrl(id_edit_cut,pushb,idb_cut_up,idb_cut_dn,idb_cut_up,"Cut;Cut to clipboard",1,1),
		 tb_ctrl(id_edit_copy,pushb,idb_copy_up,idb_copy_dn,idb_copy_up,"Copy;Copy to clipboard",1,1),
		 tb_ctrl(id_edit_paste,pushb,idb_paste_up,idb_paste_dn,idb_paste_up,"Paste;Paste from clipboard",1,1),
		 separator,
		 separator,
		 tb_ctrl(id_help_contents,pushb,idb_help_up,idb_help_down,idb_help_up,"Help;Help",0,1)]),
enddef
	true.
%END_TLB Project toolbar


%BEGIN_TLB Help line, 14:04:50-24.11.1999, Code automatically updated!
/**************************************************************************
	Creation of toolbar: Help line
**************************************************************************/

clauses

  tb_help_line_Create(_Parent):-
ifdef use_tbar
	toolbar_create(tb_bottom,0xC0C0C0,_Parent,
		[tb_text(idt_help_line,tb_context,452,0,4,10,0x0,"")]),
enddef
	true.
%END_TLB Help line


%BEGIN_DLG About dialog
/**************************************************************************
	Creation and event handling for dialog: About dialog
**************************************************************************/
constants
%BEGIN About dialog, CreateParms, 14:04:10-24.11.1999, Code automatically updated!
  dlg_about_dialog_ResID = idd_dlg_about
  dlg_about_dialog_DlgType = wd_Modal
  dlg_about_dialog_Help = idh_contents
%END About dialog, CreateParms

predicates

  dlg_about_dialog_eh : EHANDLER

clauses

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

%BEGIN_DLG Choice color
/**************************************************************************
	Creation and event handling for dialog: Choice color
**************************************************************************/

constants

%BEGIN Choice color, CreateParms, 14:04:00-24.11.1999, Code automatically updated!
  dlg_choice_color_ResID = idd_color
  dlg_choice_color_DlgType = wd_Modal
  dlg_choice_color_Help = idh_contents
%END Choice color, CreateParms

predicates

  dlg_choice_color_eh : EHANDLER
  dlg_choice_color_handle_answer(INTEGER EndButton,DIALOG_VAL_LIST)
  dlg_choice_color_update(DIALOG_VAL_LIST)

clauses

  dlg_choice_color_Create(Parent):-

%MARK Choice color, new variables

	dialog_CreateModal(Parent,dlg_choice_color_ResID,"",
  		[
%BEGIN Choice color, ControlList, 14:04:00-24.11.1999, Code automatically updated!
		df(idc_color,listbutton([],0),nopr),
		df(idc_button,listbutton([],0),nopr)
%END Choice color, ControlList
		],
		dlg_choice_color_eh,0,VALLIST,ANSWER),
	dlg_choice_color_handle_answer(ANSWER,VALLIST).

  dlg_choice_color_handle_answer(idc_ok,VALLIST):-!,
	dlg_choice_color_update(VALLIST).
  dlg_choice_color_handle_answer(idc_cancel,_):-!.  % Handle Esc and Cancel here
  dlg_choice_color_handle_answer(_,_):-
	errorexit().

  dlg_choice_color_update(_VALLIST):-
%BEGIN Choice color, Update controls, 14:04:00-24.11.1999, Code automatically updated!
	dialog_VLGetListButton(idc_color,_VALLIST,_IDC_COLOR_ITEMLIST,_IDC_COLOR_SELECT),
	dialog_VLGetListButton(idc_button,_VALLIST,_IDC_BUTTON_ITEMLIST,_IDC_BUTTON_SELECT),
%END Choice color, Update controls
	true.

%MARK Choice color, new events

%BEGIN Choice color, idc_cancel _CtlInfo
  dlg_choice_color_eh(_Win,e_Control(idc_cancel,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	win_Destroy(_Win),
	!.
%END Choice color, idc_cancel _CtlInfo

%BEGIN Choice color, idc_ok _CtlInfo
  dlg_choice_color_eh(_Win,e_Control(idc_ok,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	CtrlWin1 = win_GetCtlHandle(_Win,idc_color),
	ListLen = lbox_GetSelIndex(CtrlWin1),
	CtrlWin2 = win_GetCtlHandle(_Win,idc_button),
	NumberOfButtons = lbox_GetSelIndex(CtrlWin2),
	ColorList = 
	[8388672,8421440,4210816,0xFFFFFF,0x000000,0x808080,0xC0C0C0,
	0x0000FF,0x000080,0x00FF00,0x008000,0xFF0000,0x800000,0xFFFF00,
	0x808000,0xFF00FF,0x800080,0x00FFFF,0x008080],
	colorList_member(ListLen,19,ColorList,OutColorList),
	TaskWin = win_GetParent(_Win), % OutColorList contains ListLen of elements 
  %*********** Create Pallete dialog : palette_Create/8 ************************
	PalWin = palette_Create(TaskWin,pnt(10,150),palette_Callback,"Palette dialog",
	  b_true,b_true,NumberOfButtons,OutColorList),
  %*****************************************************************************
	assert(db_test(PalWin)),
	win_Destroy(_Win),	
	!.
%END Choice color, idc_ok _CtlInfo

%BEGIN Choice color, e_Create
  dlg_choice_color_eh(_Win,e_Create(_CreationData),0):-!,
	CtrlWin1 = win_GetCtlHandle(_Win,idc_color),
	CtrlWin2 = win_GetCtlHandle(_Win,idc_button),
	InitLB = ["0","1","2","3","4","5",
	"6","7","8","9","10","11","12","13","14","15","16","17","18","19"],
	lbox_Add(CtrlWin1,InitLB),
	lbox_SetSel(CtrlWin1,19,b_true),
	lbox_Add(CtrlWin2,InitLB),
	lbox_SetSel(CtrlWin2,8,b_true),
	!.
%END Choice color, e_Create

  dlg_choice_color_eh(_,_,_):-!,fail.

%END_DLG Choice color


%BEGIN_DLG palette_SetPreview
/**************************************************************************
	Creation and event handling for dialog: palette_SetPreview
**************************************************************************/

constants

%BEGIN palette_SetPreview, CreateParms, 14:03:42-24.11.1999, Code automatically updated!
  dlg_palette_setpreview_ResID = idd_setpreview
  dlg_palette_setpreview_DlgType = wd_Modal
  dlg_palette_setpreview_Help = idh_contents
%END palette_SetPreview, CreateParms

predicates

  dlg_palette_setpreview_eh : EHANDLER
  dlg_palette_setpreview_handle_answer(INTEGER EndButton,DIALOG_VAL_LIST)
  dlg_palette_setpreview_update(DIALOG_VAL_LIST)

clauses

  dlg_palette_setpreview_Create(Parent):-

%MARK palette_SetPreview, new variables

	dialog_CreateModal(Parent,dlg_palette_setpreview_ResID,"",
  		[
%BEGIN palette_SetPreview, ControlList, 14:03:42-24.11.1999, Code automatically updated!
		df(idc_brush,listbutton([],0),nopr),
		df(idc_brushcolor,listbutton([],0),nopr),
		df(idc_pen,listbutton([],0),nopr),
		df(idc_pencolor,listbutton([],0),nopr)
%END palette_SetPreview, ControlList
		],
		dlg_palette_setpreview_eh,0,VALLIST,ANSWER),
	dlg_palette_setpreview_handle_answer(ANSWER,VALLIST).

  dlg_palette_setpreview_handle_answer(idc_ok,VALLIST):-!,
	dlg_palette_setpreview_update(VALLIST).
  dlg_palette_setpreview_handle_answer(idc_cancel,_):-!.  % Handle Esc and Cancel here
  dlg_palette_setpreview_handle_answer(_,_):-
	errorexit().

  dlg_palette_setpreview_update(_VALLIST):-
%BEGIN palette_SetPreview, Update controls, 14:03:42-24.11.1999, Code automatically updated!
	dialog_VLGetListButton(idc_brush,_VALLIST,_IDC_BRUSH_ITEMLIST,_IDC_BRUSH_SELECT),
	dialog_VLGetListButton(idc_brushcolor,_VALLIST,_IDC_BRUSHCOLOR_ITEMLIST,_IDC_BRUSHCOLOR_SELECT),
	dialog_VLGetListButton(idc_pen,_VALLIST,_IDC_PEN_ITEMLIST,_IDC_PEN_SELECT),
	dialog_VLGetListButton(idc_pencolor,_VALLIST,_IDC_PENCOLOR_ITEMLIST,_IDC_PENCOLOR_SELECT),
%END palette_SetPreview, Update controls
	true.

%MARK palette_SetPreview, new events

%BEGIN palette_SetPreview, idc_cancel _CtlInfo
  dlg_palette_setpreview_eh(_Win,e_Control(idc_cancel,_CtrlType,_CtrlWin,activated()),0):-!,
	win_Destroy(_Win),
	!.
%END palette_SetPreview, idc_cancel _CtlInfo

%BEGIN palette_SetPreview, idc_ok _CtlInfo
  dlg_palette_setpreview_eh(_Win,e_Control(idc_ok,_CtrlType,_CtrlWin,activated()),0):-
	CtrlWin1 = win_GetCtlHandle(_Win,idc_brush),
	CtrlWin2 = win_GetCtlHandle(_Win,idc_brushColor),
	CtrlWin3 = win_GetCtlHandle(_Win,idc_pen),
	CtrlWin4 = win_GetCtlHandle(_Win,idc_pencolor),
	Index1 = lbox_GetSelIndex(CtrlWin1),
	Item1 = lbox_GetItem(CtrlWin1,Index1),
	Index2 = lbox_GetSelIndex(CtrlWin2),
	Item2 = lbox_GetItem(CtrlWin2,Index2),
	Index3 = lbox_GetSelIndex(CtrlWin3),
	Item3 = lbox_GetItem(CtrlWin3,Index3),
	Index4 = lbox_GetSelIndex(CtrlWin4),
	Item4 = lbox_GetItem(CtrlWin4,Index4),
	brushNameToPATSTYLE(Item1,FillStyle),
	colorNameToNumber(Item2,FillColor),
	penNameToPENWIDTH_PENSTYLE(Item3,PenWidth,PenStyle),
	colorNameToNumber(Item4,PenColor),
	win_Destroy(_Win),
	db_test(PalWin),
  %********** Set Preview for Pen and Brush ***********************************
	palette_SetPreview(PalWin,pen(PenWidth,PenStyle,PenColor),
	  brush(FillStyle,FillColor)),
  %*****************************************************************************
	fail.	

  dlg_palette_setpreview_eh(_Win,e_Control(idc_ok,_CtrlType,_CtrlWin,activated()),0):-!,
	not(db_test(_)),
	win_Destroy(_Win),
	dlg_Note("Warning","Palette not created !\n Please, press F7 or F8 button"),
	!.
%END palette_SetPreview, idc_ok _CtlInfo

%BEGIN palette_SetPreview, e_Create
  dlg_palette_setpreview_eh(_Win,e_Create(_CreationData),0):-!,
	CtrlWin1 = win_GetCtlHandle(_Win,idc_brush),
	CtrlWin2 = win_GetCtlHandle(_Win,idc_brushColor),
	CtrlWin3 = win_GetCtlHandle(_Win,idc_pen),
	CtrlWin4 = win_GetCtlHandle(_Win,idc_pencolor),
	InitColor = ["White","Black","Gray","LtGray","Red","DkRed",
	  "Green","DkGreen","Blue","DkBlue","Cyan"],
	InitPen = ["Solid 1","Solid 3","Dash 1","Dot 1","DashDot 1","DashDotDot 1",
	  "Hollow 1"],
	InitFill = ["Hollow","Solid","Horz","Vert","FDiag","BDiag",
	  "Cross","DiagCross"],
	lbox_Add(CtrlWin1,InitFill),
	lbox_Add(CtrlWin2,InitColor),
	lbox_Add(CtrlWin3,InitPen),
	lbox_Add(CtrlWin4,InitColor),
	lbox_SetSel(CtrlWin1,1,b_true),
	lbox_SetSel(CtrlWin2,4,b_true),
	lbox_SetSel(CtrlWin3,0,b_true),
	lbox_SetSel(CtrlWin4,6,b_true),
	!.
%END palette_SetPreview, e_Create

  dlg_palette_setpreview_eh(_,_,_):-!,fail.

%END_DLG palette_SetPreview








