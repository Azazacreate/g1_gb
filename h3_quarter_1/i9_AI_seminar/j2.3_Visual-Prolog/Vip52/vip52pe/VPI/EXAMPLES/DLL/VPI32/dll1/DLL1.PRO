/*****************************************************************************

		 Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  DLL1
 FileName: DLL1.PRO
 Purpose: No description
 Written by: Visual Prolog
 Comments:
******************************************************************************/

include "dll1.inc"
include "dll1.con"
include "hlptopic.con"

DATABASE - dll1
 registered

CLAUSES /*Exported*/

 /* Memory Management Clauses */
 %Note: The constant "use_runtime" MUST be defined in the DLL1.INC file
 %      because the next two predicates are exported 
 %      They are not needed if the DLL is statically linked
 dll_mark_gstack(STACKMARK):- STACKMARK=mem_MarkGStack().
 dll_release_gstack(STACKMARK):-mem_ReleaseGStack(STACKMARK).

PREDICATES
procedure WINDOW  custom_Create(WINDOW,RCT,INTEGER)

CLAUSES
 dll1_custom_Create(Parent,RCT, Id, WIN):-
%"Win" is output parameter, but memory for it do not allocated on GStack
 	STACKMARK = mem_MarkGStack(),
 	Win = custom_Create(Parent,RCT, Id),
	mem_ReleaseGStack(STACKMARK).

DATABASE - denmark
	poly(string,PNTLIST)
	
DATABASE - interaction
	scale(INTEGER,INTEGER,INTEGER,INTEGER)

PREDICATES
	get_scale(integer,integer,integer,integer)
CLAUSES
  get_scale(XMIN,XMAX,YMIN,YMAX) :-
	scale(XMIN,XMAX,YMIN,YMAX),
	!.
  get_scale(-10000,10000,-10000,10000).     % Default scale!.


PREDICATES
  setup_mapping(WINDOW)
CLAUSES
  setup_mapping(Win):-
    Rect = win_GetClientRect(Win),
    Rect = rct(_,_,R,B),
    win_SetMapMode(Win,mm_Arbitrary),
    get_scale(XMIN,XMAX,YMIN,YMAX),
    LXEXT = XMAX-XMIN,                  LYEXT = YMAX-YMIN,
    LXORG = XMIN+(LXEXT div 2), LYORG = YMIN+(LYEXT div 2),
    DXEXT = R,                          DYEXT = -B,
    DXORG = R div 2,                    DYORG = B div 2,
    win_SetMapScale(Win,pnt(LXORG,LYORG),pnt(LXEXT,LYEXT),pnt(DXORG,DYORG),pnt(DXEXT,DYEXT)).

PREDICATES
  drawinfo(WINDOW)
  RCT get_logical_client(WINDOW)
  validate_pntlist(RCT,PNTLIST,PNTLIST,PNTLIST)
  validate_coord(integer,integer,integer,integer)
  drawmap(WINDOW) - (i)

CLAUSES
  drawinfo(Win):-
    win_SetPen(Win,pen(1,ps_Solid,color_Black)),
    win_SetBrush(Win,brush(pat_Solid,color_Red)),
    HereX = 6117,
    HereY = -3080,
    HereLineX = 3983,
    HereLineY = 1126,
    HereTextX = HereLineX-3000,
    HereTextY = HereLineY+1000,
    draw_Ellipse(Win,rct(5867,-3230,6267,-2930)),
    RCT = get_logical_client ( Win ),
    validate_pntlist ( RCT, [ pnt(HereX,HereY),pnt(HereLineX,HereLineY) ], [], List ),
    draw_Polyline (Win, List ),
    win_SetForeColor(Win,color_Red),
    win_SetBackMode(Win,bk_Transparent),
    draw_Text(Win,HereTextX,HereTextY,"PDC Denmark",11).
    
  drawmap(Win):-
	RCT=get_logical_client(Win),
	win_SetBrush(Win,brush(pat_Solid,color_Cyan)),
	draw_Rect(Win,RCT),
	win_SetPen(Win,pen(1,ps_Solid,color_Black)),
	win_SetBrush(Win,brush(pat_solid,color_Green)),
	poly(_,PointList),
	validate_pntlist(RCT,PointList,[],PointList_),
	draw_Polygon(Win,PointList_),
	fail.
  drawmap(_Win).
    
  get_logical_client(Win,rct(L2,T2,R2,B2)):-
  	RCT=win_GetClientRect(Win),
  	RCT=rct(L0,T0,R0,B0),
  	LIST=win_DPtoLP(Win,[pnt(L0,T0),pnt(R0,B0)]),
  	LIST=[pnt(L1,B1),pnt(R1,T1)],
  	L2=L1-1,
  	T2=T1-1,
  	R2=R1+1,
  	B2=B1+1.
  	
  validate_pntlist(_,[],L,L):-!.
  validate_pntlist(rct(L,T,R,B),[pnt(X,Y)|L0],L1,L2):-
  	validate_coord(L,R,X,X_),
  	validate_coord(T,B,Y,Y_),
  	validate_pntlist(rct(L,T,R,B),L0,[pnt(X_,Y_)|L1],L2).
  	
  validate_coord(A,_,X,A):-
  	X<=A,!.
  validate_coord(_,B,X,B):-
  	X>=B,!.
  validate_coord(_,_,X,X).  	  	  	

%BEGIN_WIN custom
/**************************************************************************
	Creation and event handling for class: "custom"
**************************************************************************/

CONSTANTS

%BEGIN custom, CreateParms, 18:40:22-24.11.1999, Code automatically updated!
  win_custom_ClassName = "customDenmark"
  win_custom_Help = idh_contents
%END custom, CreateParms

PREDICATES

  win_custom_eh : EHANDLER

CLAUSES
  custom_Create(_Parent,_RCT,_Id,~0):-
  	not(registered),
  	trap(class_Create(win_custom_ClassName,win_custom_eh),_,fail),
  	assert(registered),
  	fail.
  custom_Create(_Parent,RCT,Id,Win):-
%"Win" is output parameter, but memory for it do not allocated on GStack
	trap(Win = win_CreateDynControl([
		customctl(wdef(wc_Custom,RCT,"DLL1",u_Pixels),win_custom_ClassName,Id,[wsf_Group,wsf_TabStop])
		], _Parent),_,fail),
	!.
  custom_Create(_Parent,_RCT,_Id,~0):-
	dlg_Error( "DLL1 error", "Cannot create control in DLL1" ).
	
%BEGIN custom, e_Create
  win_custom_eh(_Win,e_Create(_),0):-!,
%BEGIN custom, InitControls, 18:40:22-24.11.1999, Code automatically updated!
%END custom, InitControls
	consult("denmark.dba",denmark),
	setup_mapping(_Win),
	!.
%END custom, e_Create
%MARK custom, new events

%BEGIN custom, e_Update
  win_custom_eh(_Win,e_Update(_UpdateRct),0):-!,
	drawmap(_Win),
	drawinfo(_Win),
	!.
%END custom, e_Update

%END_WIN custom

 dll1_custom_Destroy(WIN):-
	win_Destroy(WIN),
	fail.
 dll1_custom_Destroy(_WIN):-
  	retract(registered),
	class_Destroy(win_custom_ClassName),
	fail.
 dll1_custom_Destroy(_WIN).

GOAL true.

