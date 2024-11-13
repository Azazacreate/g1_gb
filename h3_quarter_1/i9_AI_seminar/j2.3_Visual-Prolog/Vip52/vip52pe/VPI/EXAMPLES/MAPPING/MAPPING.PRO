/*****************************************************************************

		 Copyright (c) 1984 - 2000 Prolog Development Center A/S

			VISUAL Prolog

 Project:  MAPPING
 FileName: MAPPING.PRO
 Purpose: VPI Mapping example
 Written by: PDC
 Comments:

******************************************************************************/

include "mapping.inc"
include "mapping.con"
include "hlptopic.con"

/******************************************************
	Fact declarations
******************************************************/

% Facts to be consulted in from file
% The logical scale is -10000 to 10000 in both axes
DATABASE - map
  poly(STRING,PNTLIST)

% Dynamic settings
DATABASE - interaction
  drag(RCT)
  scale(INTEGER,INTEGER,INTEGER,INTEGER)
  anisotropic() % A flag for anisotropic mapping


/******************************************************
	Setup current mapping
******************************************************/

PREDICATES
  get_scale(integer,integer,integer,integer)
CLAUSES
  get_scale(XMIN,XMAX,YMIN,YMAX) :-
	scale(XMIN,XMAX,YMIN,YMAX), !.
  get_scale(-10000,10000,-10000,10000).     % Default scale!.


PREDICATES
  setup_mapping(WINDOW)
CLAUSES
  setup_mapping(_Win):-
	anisotropic(),!,
	Rect = win_GetClientRect(_Win),
	Rect = rct(_,_,R,B),
	win_SetMapMode(_Win,mm_Arbitrary),
	get_scale(XMIN,XMAX,YMIN,YMAX),
	LXEXT = XMAX-XMIN,
	LYEXT = YMAX-YMIN,
	LXORG = XMIN+(LXEXT div 2),
	LYORG = YMIN+(LYEXT div 2),
	DXEXT = R,
	DYEXT = -B,
	DXORG = R div 2,
	DYORG = B div 2,
	win_SetMapScale(_Win,pnt(LXORG,LYORG),pnt(LXEXT,LYEXT),pnt(DXORG,DYORG),pnt(DXEXT,DYEXT)).


  setup_mapping(_Win):-
	Rect = win_GetClientRect(_Win),
	Rect = rct(_,_,R,B),
	win_SetMapMode(_Win,mm_Arbitrary),
	get_scale(XMIN,_XMAX,YMIN,YMAX),
%       Use isotropic mapping
	LYEXT = YMAX-YMIN,
	LXEXT = LYEXT,
	DYEXT = -B,
	DXEXT = -DYEXT,
	LXORG = XMIN+(LXEXT div 2),
	LYORG = YMIN+(LYEXT div 2),
	DXORG = R div 2,
	DYORG = B div 2,
	win_SetMapScale(_Win,pnt(LXORG,LYORG),pnt(LXEXT,LYEXT),pnt(DXORG,DYORG),pnt(DXEXT,DYEXT)).

/******************************************************
	Draw the map of Denmark
******************************************************/

PREDICATES
  drawmap(WINDOW)
  drawinfo(WINDOW)
  RCT get_logical_client ( WINDOW )
  validate_pntlist ( RCT, PNTLIST, PNTLIST, PNTLIST )
  validate_coord ( INTEGER, INTEGER, INTEGER, INTEGER )

CLAUSES
  drawinfo(_Win):-
	win_SetPen(_Win,pen(1,ps_Solid,color_Black)),
	win_SetBrush(_Win,brush(pat_Solid,color_Red)),
	HereX = 6117,
	HereY = -3080,
	HereLineX = 3983,
	HereLineY = 1126,
	HereTextX = HereLineX,
	HereTextY = HereLineY+1300,
	draw_Ellipse(_Win,rct(5867,-3230,6267,-2930)),
	RCT = get_logical_client ( _Win ),
	validate_pntlist ( RCT, [ pnt(HereX,HereY),pnt(HereTextX,HereLineY) ], [], List ),
	draw_Polyline (_Win, List ),
	win_SetForeColor(_Win,color_Red),
	win_SetBackMode(_Win,bk_Transparent),
	draw_Text(_Win,HereTextX,HereTextY,"PDC Denmark",11).

  drawmap(_Win):-
	RCT = get_logical_client ( _Win ),
	win_SetBrush ( _Win, brush ( pat_Solid, color_Cyan ) ),
	draw_Rect ( _Win, RCT ),
	win_SetPen(_Win,pen(1,ps_Solid,color_Black)),
	win_SetBrush(_Win,brush(pat_Solid,color_Green)),
	poly(_,PointList),
	validate_pntlist ( RCT, PointList, [], PointList_ ),
	draw_Polygon(_Win,PointList_),
	fail.
  drawmap(_Win).

  get_logical_client ( _Win, rct ( L2, T2, R2, B2 ) ) :-
	RCT = win_GetClientRect ( _Win ),
	RCT = rct ( L0, T0, R0, B0 ),
	LIST = win_DPtoLP ( _Win, [ pnt ( L0, T0 ), pnt ( R0, B0 ) ] ),
	LIST = [ pnt ( L1, B1 ), pnt ( R1, T1 ) ],
	L2 = L1 - 1,
	T2 = T1 - 1,
	R2 = R1 + 1,
	B2 = B1 + 1.

  validate_pntlist ( _, [], L, L ) :- !.
  validate_pntlist ( rct ( L, T, R, B ), [ pnt ( X, Y ) | L0 ], L1, L2 ) :-
	validate_coord ( L, R, X, X_ ),
	validate_coord ( T, B, Y, Y_ ),
	validate_pntlist ( rct ( L, T, R, B ), L0, [ pnt ( X_, Y_ ) | L1 ], L2 ).

  validate_coord ( A, _, X, A ) :-
	X <= A, !.
  validate_coord ( _, B, X, B ) :-
	X >= B, !.
  validate_coord ( _, _, X, X ).

/****************************************************************************
	Normaliza rect ensures that R>L and B>T
****************************************************************************/

PREDICATES
  min(integer,integer,integer)
  max(integer,integer,integer)
CLAUSES
  min(A,B,A) :- A<=B, !.
  min(_,B,B).

  max(A,B,A) :- A>=B, !.
  max(_,B,B).


PREDICATES
  normalize_rect(RCT,RCT)
CLAUSES
  normalize_rect(rct(L,T,R,B),rct(LNorm,TNorm,RNorm,BNorm)) :-
	min(L,R,LNorm),
	max(L,R,RNorm),
	min(T,B,TNorm),
	max(T,B,BNorm).


PREDICATES      % Check that the selection is at least 10 pixels in each direction
  valid_rect(RCT)
CLAUSES
  valid_rect(rct(L,T,R,B)):-
	R>L+10, B>T+10.


/******************************************************
Convert a rectangle from pixel cordinates to logical
******************************************************/

PREDICATES
  logical_rect(WINDOW,RCT,RCT)
CLAUSES
  logical_rect(_Win,rct(L,T,R,B),rct(X1,Y1,X2,Y2)) :-
	PNTLIST = win_DPtoLP(_Win,[pnt(L,T),pnt(R,B)]),
	PNTLIST = [pnt(X1,Y1),pnt(X2,Y2)].


/******************************************************
	Draw the dragging rectangle
******************************************************/

PREDICATES
  draw_dragrect(WINDOW,RCT)
CLAUSES
  draw_dragrect(_Win,RCT) :-
	win_SetPen(_Win,pen(1,ps_Solid,color_Black)),
	win_SetBrush(_Win,brush(pat_Hollow,color_Black)),
	OldDrawMode  = win_GetDrawMode(_Win),
	win_SetDrawMode(_Win,dm_Not),
	logical_rect(_Win,RCT,LRCT),
	draw_Rect(_Win,LRCT),
	win_SetDrawMode(_Win,OldDrawMode).

%BEGIN_WIN Task Window
/***************************************************************************
		Event handling for task window
***************************************************************************/

PREDICATES

  task_win_eh : EHANDLER

CONSTANTS

%BEGIN Task Window, CreateParms, 20:20:42-23.11.1999, Code automatically updated!
  task_win_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Close,wsf_Maximize,wsf_Minimize,wsf_ClipSiblings]
  task_win_Menu  = res_menu(idr_task_menu)
  task_win_Title = "Mapping"
  task_win_Help  = idh_contents
%END Task Window, CreateParms

CLAUSES

%BEGIN Task Window, e_Create
  task_win_eh(_Win,e_Create(_),0):-!,
%BEGIN Task Window, ToolbarCreate, 20:20:42-23.11.1999, Code automatically updated!
%END Task Window, ToolbarCreate
IFDEF use_message
	msg_Create(100),
ENDDEF
	consult("denmark.dba",map),
	menu_Enable(_Win,id_Mapping_zoom_out,b_false),
	!.
%END Task Window, e_Create

%MARK Task Window, new events

%BEGIN Task Window, id_help_contents
IFDEF use_on_line_help
  task_win_eh(_Win,e_Menu(id_help_contents,_ShiftCtlAlt),0):-!,
	vpi_ShowHelp("mapping.hlp"),
	!.
ENDDEF
%END Task Window, id_help_contents

%BEGIN Task Window, id_help_about
  task_win_eh(_Win,e_Menu(id_help_about,_ShiftCtlAlt),0):-!,
	dlg_about_dialog_Create(_Win),
	!.
%END Task Window, id_help_about

%BEGIN Task Window, id_file_exit
  task_win_eh(Win,e_Menu(id_file_exit,_ShiftCtlAlt),0):-!,
	win_Destroy(Win),
	!.
%END Task Window, id_file_exit

%BEGIN Task Window, e_Update
  task_win_eh(_Win,e_Update(_UpdateRct),0):-!,
	setup_mapping(_Win),
	drawmap(_Win),
	drawinfo(_Win),
	!.
%END Task Window, e_Update
%BEGIN Task Window, e_Char
  task_win_eh(_Win,e_Char(_Char,_ShiftCtlAlt),0):-!,
	win_SendEvent(_Win,e_Menu(id_Mapping_zoom_out,0)),
	!.
%END Task Window, e_Char
%BEGIN Task Window, e_MouseDown
  task_win_eh(_Win,e_MouseDown(pnt(X,Y),_,0),0):-!,
	win_CaptureMouse (_Win),
	retractall(drag(_)),
	draw_dragrect(_Win,rct(X,Y,X,Y)),
	assert(drag(rct(X,Y,X,Y))),
	!.
%END Task Window, e_MouseDown
%BEGIN Task Window, e_MouseMove
  task_win_eh(_Win,e_MouseMove(pnt(X,Y),_,_),0):-
	RCT = win_GetClientRect (_Win),
	rect_PntInside ( RCT, pnt ( X, Y ) ), !,
	drag(rct(StartX,StartY,OldX,OldY)),!,
	draw_dragrect(_Win,rct(StartX,StartY,OldX,OldY)),
	retractall(drag(_)),
	draw_dragrect(_Win,rct(StartX,StartY,X,Y)),
	assert(drag(rct(StartX,StartY,X,Y))),
	!.
  task_win_eh(_Win,e_MouseMove(PNT,_,_),0):- !,
	win_SendEvent ( _Win, e_MouseUp ( PNT, 0, 0 ) ).
%END Task Window, e_MouseMove
%BEGIN Task Window, e_MouseUp
  task_win_eh(_Win,e_MouseUp(_,_,0),0):-!,
	win_ReleaseMouse (),
	drag(Rect), !,
	retractall(drag(_)),
	draw_dragrect(_Win,Rect),
	normalize_rect(Rect,NRect),
	valid_rect(NRect),
	logical_rect(_Win,NRect,LRect),
	LRect = rct(L,T,R,B),
	asserta(scale(L,R,B,T)),     % assert at the top (LIFO style stack)
	setup_mapping(_Win),
	ClientRect = win_GetClientRect(_Win),
	win_Invalidate(_Win,ClientRect).

  task_win_eh(_Win,e_MouseUp(PNT,_,1),0):-!,
	setup_mapping(_Win),
	PNTLIST = win_DPtoLP(_Win,[PNT]),
	PNTLIST = [pnt(X1,Y1)],
	format(STR,"X= %, Y= %",X1,Y1),
	dlg_Note(STR).
%END Task Window, e_MouseUp
%BEGIN Task Window, id_Mapping_zoom_out
  task_win_eh(_Win,e_Menu(id_Mapping_zoom_out,_ShiftCtlAlt),0):-!,
	ClientRect = win_GetClientRect(_Win),
	win_Invalidate(_Win,ClientRect),
	retract(scale(_,_,_,_)),
	!.
%END Task Window, id_Mapping_zoom_out
%BEGIN Task Window, id_Mapping_isotropic_mapping
  task_win_eh(_Win,e_Menu(id_Mapping_isotropic_mapping,_ShiftCtlAlt),0):-!,
	retract(anisotropic),
	menu_Check(_Win,id_Mapping_isotropic_mapping,b_True),
	menu_Check(_Win,id_Mapping_anisotropic_mapping,b_False),
	ClientRect = win_GetClientRect(_Win),
	win_Invalidate(_Win,ClientRect),
	!.
%END Task Window, id_Mapping_isotropic_mapping
%BEGIN Task Window, id_Mapping_anisotropic_mapping
  task_win_eh(_Win,e_Menu(id_Mapping_anisotropic_mapping,_ShiftCtlAlt),0):-!,
	not(anisotropic),
	assert(anisotropic),
	menu_Check(_Win,id_Mapping_isotropic_mapping,b_False),
	menu_Check(_Win,id_Mapping_anisotropic_mapping,b_True),
	ClientRect = win_GetClientRect(_Win),
	win_Invalidate(_Win,ClientRect),
	!.
%END Task Window, id_Mapping_anisotropic_mapping
%BEGIN Task Window, e_InitMenu
  task_win_eh(_Win,e_InitMenu,b_false):-
	scale(_,_,_,_),!,
	menu_Enable(_Win,id_Mapping_zoom_out,b_True).
  task_win_eh(_Win,e_InitMenu,b_false):-!,
	menu_Enable(_Win,id_Mapping_zoom_out,b_False).
%END Task Window, e_InitMenu
%BEGIN Task Window, e_Size
  task_win_eh(_Win,e_Size(_Width,_Height),0):-!,
	Rect = win_GetClientRect(_Win),
	win_Invalidate(_Win,Rect),
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
  vpi_Init(task_win_Flags,task_win_eh,task_win_Menu,"mapping",task_win_Title).

%END_WIN Task Window

%BEGIN_DLG About dialog
/**************************************************************************
	Creation and event handling for dialog: "About dialog"
	Code style: Single dialog
**************************************************************************/

CONSTANTS

%BEGIN About dialog, CreateParms, 20:20:38-23.11.1999, Code automatically updated!
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







