/*****************************************************************************

		 Copyright (c) 1984 - 2000 Prolog Development Center A/S

			VISUAL Prolog

 Project:  SHOWFONT
 FileName: SHOWFONT.PRO
 Purpose: Font handling
 Written by: Ilyin Yuri
 Modifyed by: Eugene Akimov
 Comments:
******************************************************************************/

include "showfont.inc"
include "showfont.con"
include "hlptopic.con"

DOMAINS
  OBJ_ID = INTEGER

DATABASE - text_objects
  text_objects(OBJ_ID,STRING,Pnt)
  sel_obj(OBJ_ID)

CLAUSES
  text_objects(1,"This is the first sentence.", pnt( 60,10)).
  text_objects(2,"This is the second sentence.", pnt(140, 80)).
  text_objects(3,"This is the third sentence.",pnt(225, 130)).
  text_objects(4,"This is the fourth sentence.", pnt(300, 180)).

/***************************************************************************
  Object state handling
***************************************************************************/
CONSTANTS
  no_obj = -1                                   /* means no selection */

DATABASE - states
  obj_bounds(OBJ_ID,RCT)
  obj_font(OBJ_ID,FONT)

/***************************************************************************
	Select a Font for an object
***************************************************************************/

PREDICATES
  choose_font(INTEGER, FONT)
  get_font(INTEGER,FONT)

CLAUSES
  choose_font(1,Font) :- !,
	Font = font_Create(ff_Fixed,[],26).
  choose_font(2,Font) :- !,
	Font = font_Create(ff_Times,[fs_Italic],22).
  choose_font(3,Font) :- !,
	Font = font_Create(ff_Helvetica,[fs_UnderLine],16).
  choose_font(4,Font) :- !,
	Font = font_Create(ff_System,[fs_Bold],10).

  get_font(Obj,Font):-!,
	obj_font(Obj,Font),!.

/***************************************************************************
	Find a text object, given a mouse position.
***************************************************************************/
PREDICATES
  find_obj(Pnt,OBJ_ID)

CLAUSES
  find_obj(Pos,Obj) :-
	obj_bounds(Obj,Bounds),
	rect_PntInside(Bounds,Pos),!.
  find_obj(_,no_obj).

/**************************************************************************
	set tools
**************************************************************************/
PREDICATES
  set_tools_for_inv(WINDOW)
  set_solid_pen_brush(WINDOW,COLOR)
CLAUSES
  set_tools_for_inv(_Win):-
	win_SetDrawMode(_Win,dm_NotMergePen),
	set_solid_pen_brush(_Win,color_black).

  set_solid_pen_brush(_Win,COLOR):-
	win_setpen(_Win, pen( 1, ps_Solid, COLOR )),
	win_setbrush(_Win,brush(pat_solid,COLOR)).

/***************************************************************************
	find boundaries for choosed font
	find_bounds(i,i,i,i,i,o,o,o)
***************************************************************************/
PREDICATES
  find_bounds(WINDOW,FONT,STRING,OBJ_ID,PNT,INTEGER,INTEGER,RCT)
CLAUSES
  find_bounds(_Win,Font,Text,Obj,Pos,Pos_H,Pos_V,Bounds):-
	win_setfont(_Win,Font),
	win_getfontmetrics(_Win,Leading, ASCENT, DESCENT),
	win_GetTextExtent(_Win,Text,-1,Width,_),
	Pos = pnt(Pos_V,Pos_H),
	TOP = Pos_V - ASCENT - Leading,
	LEFT = Pos_H,
	BOTTOM = Pos_V + DESCENT,
	RIGHT = Pos_H + WIDTH,
	Bounds = rct(LEFT,TOP,RIGHT,BOTTOM),
	retractall(obj_bounds(Obj,_)),
	assert(obj_bounds(Obj,Bounds)).
	
/***************************************************************************
	Change Font
***************************************************************************/
PREDICATES
  change_font_Selected_text(WINDOW,INTEGER)
  set_font_Selected_text(FONT,FONT,INTEGER)
CLAUSES
  set_font_Selected_text(OldFont,Fnt,1):-
	Fnt = dlg_ChooseFont(OldFont),
	!. % choose new font
  set_font_Selected_text(F1,F2,2):-
	font_GetAttrs(F1,StyleFlags,OldSize),
	str_int(SOldSize,OldSize),
	SSize = dlg_GetStr("","InPut new height of text",SOldSize), % choose new size
	str_int(SSize,Size),
	F2 = font_SetAttrs(F1,StyleFlags,Size),!.
  set_font_Selected_text(F1,F1,_).

  change_font_Selected_text(_Win,NN):-
	sel_obj(Obj),
	text_objects(Obj,Text,Pos),
	obj_bounds(Obj,Bounds),
	obj_font(Obj,OldFont),!,
	set_font_Selected_text(OldFont,Fnt,NN),
	retractall(obj_font(Obj,_)),
	asserta(obj_font(Obj,Fnt)),
	Tools = win_GetDrawTools(_Win),
	Tools = draw_tools(_,_,_,_,_,Colorbg,_),
	win_SetDrawMode(_Win,dm_CopyPen),
	set_solid_pen_brush(_Win,Colorbg),
	draw_Rect(_Win,Bounds),             % clear old text
	find_bounds(_Win,Fnt,Text,Obj,Pos,Pos_H,Pos_V,Bounds1),
	draw_Rect(_Win,Bounds1),             % clear rectangle for text in new font
	set_solid_pen_brush(_Win,color_Black),
	draw_Text(_Win,Pos_H, Pos_V, Text, -1),
	win_SetDrawMode(_Win,dm_Not),
	draw_rect(_Win,Bounds1),             % invert to show selection
	win_SetDrawTools(_Win,Tools),
	Rect=win_GetClientRect(_Win),
	win_SendEvent(_Win,e_Update(Rect)).
  change_font_Selected_text(_,_):-
	dlg_Note("","Select first text with clicking mouse").

%BEGIN_WIN Task Window
/***************************************************************************
		Event handling for task window
***************************************************************************/

PREDICATES

  task_win_eh : EHANDLER

CONSTANTS

%BEGIN Task Window, CreateParms, 18:58:52-23.11.1999, Code automatically updated!
  task_win_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Close,wsf_Maximize,wsf_Minimize,wsf_ClipSiblings]
  task_win_Menu  = res_menu(idr_task_menu)
  task_win_Title = "Showfont"
  task_win_Help  = idh_contents
%END Task Window, CreateParms

CLAUSES

%BEGIN Task Window, e_Create
  task_win_eh(_Win,e_Create(_),0):-
%BEGIN Task Window, InitControls, 18:58:52-23.11.1999, Code automatically updated!
%END Task Window, InitControls
%BEGIN Task Window, ToolbarCreate, 18:58:52-23.11.1999, Code automatically updated!
%END Task Window, ToolbarCreate
IFDEF use_message
	msg_Create(100),
ENDDEF
	text_objects(Obj,Text,Pos),
	choose_font(Obj,Font),
	asserta(obj_font(Obj,Font)),
	find_bounds(_Win,Font,Text,Obj,Pos,_,_,_),
	fail.
%END Task Window, e_Create

%MARK Task Window, new events

%BEGIN Task Window, id_file_exit
  task_win_eh(Win,e_Menu(id_file_exit,_),0):-!,
	win_Destroy(Win).
%END Task Window, id_file_exit
%BEGIN Task Window, id_help_about
  task_win_eh(_Win,e_Menu(id_help_about,_),0):-!,
	dlg_about_dialog_Create(_Win).
%END Task Window, id_help_about
%BEGIN Task Window, id_Font_font
%+++++ change font for selected text +++++
  task_win_eh(_Win,e_Menu(id_Font_font,_),0):-!,
	change_font_Selected_text(_Win,1).
%END Task Window, id_Font_font
%BEGIN Task Window, id_Font_size
%+++++ change size for selected text +++++
  task_win_eh(_Win,e_Menu(id_Font_size,_),0):-!,
	change_font_Selected_text(_Win,2).
%END Task Window, id_Font_size
%BEGIN Task Window, e_Update
  task_win_eh(_Win,e_Update(UpdateRct),0):-
	DrawTools = win_GetDrawTools ( _Win ),
	win_SetPen ( _Win, pen ( 1, ps_Solid, color_White ) ),
	win_SetBrush ( _Win ,brush ( pat_Solid, color_White ) ),
	draw_Rect ( _Win,UpdateRct),
	win_SetDrawTools ( _Win, DrawTools ),
	text_objects(Obj,Text,Pos),
	get_font(Obj,Font),
	find_bounds(_Win,Font,Text,Obj,Pos,Pos_H,Pos_V,Bounds),
	draw_text(_Win,Pos_H, Pos_V, Text, -1),
	sel_obj(Obj),% if object selected it will be inversed
	Tools = win_GetDrawTools(_Win),
	set_tools_for_inv(_Win),
	draw_Rect(_Win,Bounds),
	win_SetDrawTools(_Win,Tools),
	fail.
%END Task Window, e_Update
%BEGIN Task Window, e_MouseDbl
  task_win_eh(_Win,e_MouseDbl(Pnt,_,_Button),0):-
	find_obj(Pnt,Obj),
	not(Obj = no_obj),!,
	get_font(Obj,Font),
	win_setfont(_Win,Font),
	Name_Font=font_GetAttrs(Font,_,Size),
	format(Note,"Font size: % points \nFont name: %",  Size,Name_Font),
	dlg_Note("",Note).
%END Task Window, e_MouseDbl
%BEGIN Task Window, e_MouseDown
  task_win_eh(_Win,e_MouseDown(Pnt,_,_Button),0):-
	find_obj(Pnt,Obj),
	obj_bounds(Obj,Bounds),
	sel_obj(Obj1),
	obj_bounds(Obj1,Bounds1),!,
	Tools = win_GetDrawTools(_Win),
	retractall(sel_obj(_)),
	assert(sel_obj(Obj)),
	set_tools_for_inv(_Win),
	draw_Rect(_Win,Bounds1),
	draw_Rect(_Win,Bounds),
	win_SetDrawTools(_Win,Tools).

  task_win_eh(_Win,e_MouseDown(Pnt,_,_Button),0):-
	find_obj(Pnt,Obj),
	obj_bounds(Obj,Bounds),
	not(sel_obj(_)),!,
	Tools = win_GetDrawTools(_Win),
	set_tools_for_inv(_Win),
	assert(sel_obj(Obj)),
	draw_Rect(_Win,Bounds),
	win_SetDrawTools(_Win,Tools).
%END Task Window, e_MouseDown
%BEGIN Task Window, id_help_contents
IFDEF use_on_line_help
  task_win_eh(_Win,e_Menu(id_help_contents,_ShiftCtlAlt),0):-!,
	vpi_ShowHelp("showfont.hlp"),
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
  vpi_Init(task_win_Flags,task_win_eh,task_win_Menu,"showfont",task_win_Title).

%END_WIN Task Window

%BEGIN_DLG About dialog
/**************************************************************************
	Creation and event handling for dialog: "About dialog"
	Code style: Single dialog
**************************************************************************/

CONSTANTS

%BEGIN About dialog, CreateParms, 18:58:48-23.11.1999, Code automatically updated!
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









