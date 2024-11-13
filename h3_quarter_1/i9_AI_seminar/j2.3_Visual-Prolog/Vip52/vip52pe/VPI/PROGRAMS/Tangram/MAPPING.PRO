/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  TANGRAM
 FileName: MAPPING.PRO
 Purpose: Tangram puzzle game
 Written by: Hans Dybkjær
 Comments:
******************************************************************************/

include "tangram.inc"

database - map
	scale(WINDOW,REAL,REAL,REAL,REAL)	% Xmin,Xmax, Ymin,Ymax
	toolbarheight(WINDOW,REAL)
	mappings(	WINDOW,
			REAL,	% LxExt
			REAL,	% LyExt
			REAL,	% DxExt
			REAL,	% DyExt
			REAL,	% LxOri
			REAL,	% LyOri
			REAL,	% DxOri
			REAL)	% DyOri
			
clauses
scaleSet(Win,Xmin,Xmax,Ymin,Ymax) :-
	retractall(scale(Win,_,_,_,_)),
	assert(scale(Win,Xmin,Xmax,Ymin,Ymax)),
	retractall(toolbarheight(Win,_)),
	assert(toolbarheight(Win,40)),
	mapSet(Win).

scaleGet(Win,Xmin,Xmax,Ymin,Ymax) :-!,
	scale(Win,Xmin,Xmax,Ymin,Ymax),!.
	
mapSet(Win):-
	scale(Win,XMIN,XMAX,YMIN,YMAX),!,
	toolbarheight(Win,TH),
	Rect = win_GetClientRect(Win),
	Rect = rct(Rx0,Ry0,Rx1,Ry1),
	win_SetMapMode(Win,mm_Arbitrary),
	%       Use isotropic mapping (adjust LXext to fill out)
	DYExt = Ry0-Ry1+TH,   	DXExt = Rx1-Rx0, % Note: turn Y to point up.
	LYExt = YMAX-YMIN, 	LXExt = -LYExt*DXExt/DYExt,
	DYOri = Ry1,		DXOri = Rx0,
	LYOri = YMIN, 		LXOri = LXExt*XMIN/(XMAX-XMIN), 
	%
	%write(LXExt,"/",LYExt,"/",DXExt,"/",DYExt,"/"),nl,
	%write(LXOri,"/",LYOri,"/",DXOri,"/",DYOri),
	retractall(mappings(_,_,_,_,_,_,_,_,_)),
	assert(mappings(Win,LXExt,LYExt,DXExt,DYExt,LXOri,LYOri,DXOri,DYOri)),
	!.

mapSet(Win) :- % only here if scale was undefined
	scaleSet(Win,-2,4,-5,2). % set default, implicit call of mapSet.

mapDP2LP(Win,pnt(DX,DY),pt(LX,LY)) :-
	mappings(Win,LXExt,LYExt,DXExt,DYExt,LXOri,LYOri,DXOri,DYOri),!,
	LX=LXOri + (DX-DXOri)*LXExt/DXExt,
	LY=LYOri + (DY-DYOri)*LYExt/DYExt.
mapLP2DP(Win,pt(LX,LY),pnt(DX,DY)) :-
	mappings(Win,LXExt,LYExt,DXExt,DYExt,LXOri,LYOri,DXOri,DYOri),!,
	DX=DXOri + (LX-LXOri)*DXext/LXExt,
	DY=DYOri + (LY-LYOri)*DYext/LYExt.
	
mapLL2DL(Win,[PT|LL],[PNT|DL]) :-
	mapLP2DP(Win,PT,PNT),
	mapLL2DL(Win,LL,DL).
mapLL2DL(_,[],[]).


