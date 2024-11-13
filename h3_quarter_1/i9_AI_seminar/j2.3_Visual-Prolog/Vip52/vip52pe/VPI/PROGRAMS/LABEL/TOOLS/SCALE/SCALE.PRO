/******************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 FileName:	SCALE.PRO
 Purpose:	Scale object
 Written by:	Sergey Alexeev
 Build:		008.981112
 Comments:
******************************************************************************/
constants
  scale_hor  = 1
  scale_ver  = 2

database - scale_db
  scale_info(WINDOW ScaleWin,INTEGER HorVer,
	INTEGER WorkSpaceBeg,INTEGER WorkSpaceEnd,INTEGER LineStep)
  scale_callback(WINDOW ScaleWin,EHANDLER ParentWinHandler)
  scale_point(WINDOW ScaleWin,INTEGER Value)
  scale_rect(WINDOW ScaleWin,INTEGER Value1,INTEGER Value2)

predicates
  scale_min(INTEGER,INTEGER,INTEGER)
  scale_max(INTEGER,INTEGER,INTEGER)
clauses
  scale_min(A,B,A):-
	A < B,!.
  scale_min(_,B,B).
  scale_max(A,B,A):-
	A > B,!.
  scale_max(_,B,B).
predicates
  scale_SavePoint(WINDOW)
  scale_SaveRect(WINDOW)
  scale_RemovePoint(WINDOW)
  scale_RemoveRect(WINDOW)
  scale_redraw(WINDOW)
  scale_draw_raised(WINDOW)
  scale_draw_workspace(WINDOW)
  scale_draw(WINDOW)
clauses
  scale_redraw(Win):-
	scale_SavePoint(Win),
	scale_SaveRect(Win),
	win_clear(Win,color_LtGray),
	scale_draw_raised(Win),
	scale_draw_workspace(Win),
	scale_draw(Win),
	scale_RemoveRect(Win),
	scale_RemovePoint(Win),!.

  scale_SavePoint(Win):-
	scale_point(Win,Value),
	assert(scale_point(Win,Value)),
	assert(scale_point(Win,Value)),
	scale_RemovePoint(Win),!.
  scale_SavePoint(_).

  scale_SaveRect(Win):-
	scale_rect(Win,Value1,Value2),
	assert(scale_rect(Win,Value1,Value2)),
	assert(scale_rect(Win,Value1,Value2)),
	scale_RemoveRect(Win),!.
  scale_SaveRect(_).

  scale_draw_raised(Win):-
	Rect = win_getClientRect(Win),
	Rect = rct(L,T,R1,B1),
	R = R1 - 1, B = B1 - 1,
	win_SetPen(Win,pen(1,ps_Solid,color_LtGray)),
	draw_Line(Win,pnt(L,B),pnt(L,T)),
	draw_Line(Win,pnt(L,T),pnt(R,T)),
	win_SetPen(Win,pen(1,ps_Solid,color_Black)),
	draw_Line(Win,pnt(L,B),pnt(R,B)),
	draw_Line(Win,pnt(R,B),pnt(R,T)),
	LI = L + 1, TI = T + 1, RI = R - 1, BI = B - 1,
	win_SetPen(Win,pen(1,ps_Solid,color_White)),
	draw_Line(Win,pnt(LI,BI),pnt(LI,TI)),
	draw_Line(Win,pnt(LI,TI),pnt(RI,TI)),
	win_SetPen(Win,pen(1,ps_Solid,color_Gray)),
	draw_Line(Win,pnt(LI,BI),pnt(RI,BI)),
	draw_Line(Win,pnt(RI,BI),pnt(RI,TI)),
	win_SetPen(Win,pen(1,ps_Solid,color_Black)),
	LB = LI + 3, TB = TI + 3, RB = RI - 3, BB = BI - 3,
	draw_Line(Win,pnt(LB,TB),pnt(RB,TB)),
	draw_Line(Win,pnt(RB,TB),pnt(RB,BB)),
	draw_Line(Win,pnt(RB,BB),pnt(LB,BB)),
	draw_Line(Win,pnt(LB,BB),pnt(LB,TB)),
	LB1 = LB + 1, TB1 = TB + 1,
	win_SetClip(Win,rct(LB1,TB1,RB,BB)),!.

  scale_draw_workspace(Win):-
	scale_info(Win,scale_hor,L2,R2,_),
	L2 <> R2,
	Rect = win_getClientRect(Win),
	Rect = rct(L1,T1,R1,B1),
	T = T1 + 4, B = B1 - 4, L3 = L1 + 4, R3 = R1 - 4,
	scale_max(L3,L2,L), scale_min(R3,R2,R),
	win_SetPen(Win,pen(1,ps_Solid,color_LtGray)),
	draw_Line(Win,pnt(R,T),pnt(R,B)),
	win_SetPen(Win,pen(1,ps_Solid,color_Black)),
	draw_Line(Win,pnt(L,T),pnt(L,B)),
	LI = L - 1, TI = T + 1, RI = R + 1, BI = B - 1,
	win_SetPen(Win,pen(1,ps_Solid,color_White)),
	draw_Line(Win,pnt(RI,TI),pnt(RI,BI)),
	win_SetPen(Win,pen(1,ps_Solid,color_Gray)),
	draw_Line(Win,pnt(LI,TI),pnt(LI,BI)),
	LR = L + 1, TR = TI + 1, RR = R, BR = BI - 1,
	win_Clear(Win,rct(LR,TR,RR,BR),color_White),!.
  scale_draw_workspace(Win):-
	scale_info(Win,scale_ver,T2,B2,_),
	T2 <> B2,
	Rect = win_getClientRect(Win),
	Rect = rct(L1,T1,R1,B1),
	L = L1 + 4, R = R1 - 4, T3 = T1 + 4, B3 = B1 - 4,
	scale_max(T3,T2,T), scale_min(B3,B2,B),
	win_SetPen(Win,pen(1,ps_Solid,color_LtGray)),
	draw_Line(Win,pnt(L,B),pnt(R,B)),
	win_SetPen(Win,pen(1,ps_Solid,color_Black)),
	draw_Line(Win,pnt(L,T),pnt(R,T)),
	LI = L + 1, TI = T - 1, RI = R - 1, BI = B + 1,
	win_SetPen(Win,pen(1,ps_Solid,color_White)),
	draw_Line(Win,pnt(LI,BI),pnt(RI,BI)),
	win_SetPen(Win,pen(1,ps_Solid,color_Gray)),
	draw_Line(Win,pnt(LI,TI),pnt(RI,TI)),
	LR = LI + 1, TR = T + 1, RR = RI - 1, BR = B,
	win_Clear(Win,rct(LR,TR,RR,BR),color_White),!.
  scale_draw_workspace(_).

predicates
  scale_hdraw1(WINDOW,INTEGER T,INTEGER B,INTEGER Step,INTEGER Count,INTEGER Begin,INTEGER End)
  scale_hdraw2(WINDOW,INTEGER T,INTEGER B,INTEGER Step,INTEGER Count,INTEGER Begin,INTEGER End)
  scale_vdraw1(WINDOW,INTEGER L,INTEGER R,INTEGER Step,INTEGER Count,INTEGER Begin,INTEGER End)
  scale_vdraw2(WINDOW,INTEGER L,INTEGER R,INTEGER Step,INTEGER Count,INTEGER Begin,INTEGER End)
clauses
  scale_draw(Win):-
	scale_info(Win,scale_hor,Lw,_,Step),
	Rect = win_getClientRect(Win),
	Rect = rct(L,T,R,B),
	win_SetPen(Win,pen(1,ps_Solid,color_Black)),
	scale_hdraw1(Win,T,B,Step,0,Lw,L),
	scale_hdraw2(Win,T,B,Step,0,Lw,R),!.
  scale_draw(Win):-
	scale_info(Win,scale_ver,Tw,_,Step),
	Rect = win_getClientRect(Win),
	Rect = rct(L,T,R,B),
	win_SetPen(Win,pen(1,ps_Solid,color_Black)),
	scale_vdraw1(Win,L,R,Step,0,Tw,T),
	scale_vdraw2(Win,L,R,Step,0,Tw,B),!.
  scale_draw(_).

predicates
  scale_draw_hline(WINDOW,INTEGER T,INTEGER B,INTEGER Count,INTEGER X)
clauses
  scale_hdraw1(_,_,_,_,_,Beg,End):-
	Beg <= End,!.
  scale_hdraw1(Win,T,B,Step,Count,Beg,End):-
	Count = 0,
	C = Count + 1,
	Be = Beg - Step,!,
	scale_hdraw1(Win,T,B,Step,C,Be,End).
  scale_hdraw1(Win,T,B,Step,Count,Beg,End):-
	scale_draw_hline(Win,T,B,Count,Beg),
	C = Count + 1,
	Be = Beg - Step,!,
	scale_hdraw1(Win,T,B,Step,C,Be,End).

  scale_hdraw2(_,_,_,_,_,Beg,End):-
	Beg >= End,!.
  scale_hdraw2(Win,T,B,Step,Count,Beg,End):-
	Count = 0,
	C = Count + 1,
	Be = Beg + Step,!,
	scale_hdraw2(Win,T,B,Step,C,Be,End).
  scale_hdraw2(Win,T,B,Step,Count,Beg,End):-
	scale_draw_hline(Win,T,B,Count,Beg),
	C = Count + 1,
	Be = Beg + Step,!,
	scale_hdraw2(Win,T,B,Step,C,Be,End).

ifdef idb_numbers
predicates
  scale_draw_hdigit(WINDOW Win,PICTURE,INTEGER X,INTEGER Y,INTEGER Dig)
clauses
enddef
  scale_draw_hline(Win,T,B,Count,X):-
	C = Count mod 10,
	C = 0,
	DLR = (B - T) * 0.3,
	DL = val(integer,DLR),
	B1 = B - 7,
	T1 = B1 - DL,
	draw_Line(Win,pnt(X,T1),pnt(X,B1)),
ifdef idb_numbers
	XX = X - 10, YY  = T + 8,
	Dig = Count div 10,
	Picture = pict_GetFromRes(idb_numbers),
	scale_draw_hdigit(Win,Picture,XX,YY,Dig),
	pict_Destroy(Picture),
enddef
	!.
  scale_draw_hline(Win,T,B,Count,X):-
	C = Count mod 5,
	C = 0,
	DLR = (B - T) * 0.2,
	DL = val(integer,DLR),
	B1 = B - 7,
	T1 = B1 - DL,
	draw_Line(Win,pnt(X,T1),pnt(X,B1)),!.
  scale_draw_hline(Win,T,B,_,X):-
	DLR = (B - T) * 0.1,
	DL = val(integer,DLR),
	B1 = B - 7,
	T1 = B1 - DL,
	draw_Line(Win,pnt(X,T1),pnt(X,B1)),!.

ifdef idb_numbers
predicates
  scale_draw_hdigit1(WINDOW Win,Picture,INTEGER X,INTEGER Y,STRING SDig)
clauses
  scale_draw_hdigit(Win,Picture,X,Y,Dig):-
	format(SDig,"%",Dig),
	scale_draw_hdigit1(Win,Picture,X,Y,SDig),!.

  scale_draw_hdigit1(_,_,_,_,""):-!.
  scale_draw_hdigit1(Win,Picture,X,Y,SDig):-
	frontstr(1,SDig,CDig,Rest),
	str_int(CDig,Dig),
	X1 = X + 10, Y1 = Y + 10,
	L = Dig * 10,R = L + 10,
	pict_Draw(Win,Picture,rct(X,Y,X1,Y1),rct(L,0,R,10),rop_SrcAnd),!,
	scale_draw_hdigit1(Win,Picture,X1,Y,Rest).
enddef

predicates
  scale_draw_vline(WINDOW,INTEGER T,INTEGER B,INTEGER Count,INTEGER X)
clauses
  scale_vdraw1(_,_,_,_,_,Beg,End):-
	Beg <= End,!.
  scale_vdraw1(Win,L,R,Step,Count,Beg,End):-
	Count = 0,
	C = Count + 1,
	Be = Beg - Step,!,
	scale_vdraw1(Win,L,R,Step,C,Be,End).
  scale_vdraw1(Win,L,R,Step,Count,Beg,End):-
	scale_draw_vline(Win,L,R,Count,Beg),
	C = Count + 1,
	Be = Beg - Step,!,
	scale_vdraw1(Win,L,R,Step,C,Be,End).

  scale_vdraw2(_,_,_,_,_,Beg,End):-
	Beg >= End,!.
  scale_vdraw2(Win,L,R,Step,Count,Beg,End):-
	Count = 0,
	C = Count + 1,
	Be = Beg + Step,!,
	scale_vdraw2(Win,L,R,Step,C,Be,End).
  scale_vdraw2(Win,L,R,Step,Count,Beg,End):-
	scale_draw_vline(Win,L,R,Count,Beg),
	C = Count + 1,
	Be = Beg + Step,!,
	scale_vdraw2(Win,L,R,Step,C,Be,End).

ifdef idb_numbers
predicates
  scale_draw_vdigit(WINDOW Win,PICTURE,INTEGER X,INTEGER Y,INTEGER Dig)
clauses
enddef
  scale_draw_vline(Win,L,R,Count,Y):-
	C = Count mod 10,
	C = 0,
	DLR = (R - L) * 0.3,
	DL = val(integer,DLR),
	R1 = R - 7,
	L1 = R1 - DL,
	draw_Line(Win,pnt(L1,Y),pnt(R1,Y)),
ifdef idb_numbers
	XX = L + 8, YY  = Y + 10,
	Dig = Count div 10,
	Picture = pict_GetFromRes(idb_numbers),
	scale_draw_vdigit(Win,Picture,XX,YY,Dig),
	pict_Destroy(Picture),
enddef
	!.
  scale_draw_vline(Win,L,R,Count,Y):-
	C = Count mod 5,
	C = 0,
	DLR = (R - L) * 0.2,
	DL = val(integer,DLR),
	R1 = R - 7,
	L1 = R1 - DL,
	draw_Line(Win,pnt(L1,Y),pnt(R1,Y)),!.
  scale_draw_vline(Win,L,R,_,Y):-
	DLR = (R - L) * 0.1,
	DL = val(integer,DLR),
	R1 = R - 7,
	L1 = R1 - DL,
	draw_Line(Win,pnt(L1,Y),pnt(R1,Y)),!.

ifdef idb_numbers
predicates
  scale_draw_vdigit1(WINDOW Win,PICTURE,INTEGER X,INTEGER Y,STRING SDig)
clauses
  scale_draw_vdigit(Win,Picture,X,Y,Dig):-
	format(SDig,"%",Dig),
	scale_draw_vdigit1(Win,Picture,X,Y,SDig),!.

  scale_draw_vdigit1(_,_,_,_,""):-!.
  scale_draw_vdigit1(Win,Picture,X,Y,SDig):-
	frontstr(1,SDig,CDig,Rest),
	str_int(CDig,Dig),
	X1 = X + 10, Y1 = Y - 10,
	L = Dig * 10,R = L + 10,
	pict_Draw(Win,Picture,rct(X,Y1,X1,Y),rct(L,10,R,20),rop_SrcAnd),!,
	scale_draw_vdigit1(Win,Picture,X,Y1,Rest).
enddef

predicates
  scale_DrawPoint(WINDOW,INTEGER Value)
clauses

  scale_RemovePoint(Win):-
	retract(scale_point(Win,Value)),
	scale_DrawPoint(Win,Value),!.
  scale_RemovePoint(_).

  scale_DrawPoint(Win,X):-
	scale_info(Win,scale_hor,_,_,_),
	ParentWin = win_GetParent(Win),
	Pnts = win_MapPoints(ParentWin,Win,[pnt(X,0)]),
	Pnts = [pnt(XS,_)],
	Rect = win_GetClientRect(Win),
	Rect = rct(_,T,_,B),
	win_SetPen(Win,pen(1,ps_Solid,color_White)),
	win_SetDrawMode(Win,dm_XorPen),
	draw_Line(Win,pnt(XS,T),pnt(XS,B)),
	win_SetDrawMode(Win,dm_CopyPen),!.
  scale_DrawPoint(Win,Y):-
	scale_info(Win,scale_ver,_,_,_),
	ParentWin = win_GetParent(Win),
	Pnts = win_MapPoints(ParentWin,Win,[pnt(0,Y)]),
	Pnts = [pnt(_,YS)],
	Rect = win_GetClientRect(Win),
	Rect = rct(L,_,R,_),
	win_SetPen(Win,pen(1,ps_Solid,color_White)),
	win_SetDrawMode(Win,dm_XorPen),
	draw_Line(Win,pnt(L,YS),pnt(R,YS)),
	win_SetDrawMode(Win,dm_CopyPen),!.
  scale_DrawPoint(_,_).

predicates
  scale_DrawRect(WINDOW,INTEGER Value1,INTEGER Value2)
clauses

  scale_RemoveRect(Win):-
	retract(scale_rect(Win,Value1,Value2)),
	scale_DrawRect(Win,Value1,Value2),!.
  scale_RemoveRect(_).

  scale_DrawRect(Win,X1,X2):-
	scale_info(Win,scale_hor,_,_,_),
	ParentWin = win_GetParent(Win),
	Pnts = win_MapPoints(ParentWin,Win,[pnt(X1,0),pnt(X2,0)]),
	Pnts = [pnt(XS1,_),pnt(XS2,_)],
	Rect = win_GetClientRect(Win),
	Rect = rct(_,T,_,B),
	win_SetPen(Win,pen(1,ps_Solid,color_White)),
	win_SetBrush(Win,brush(pat_Solid,color_White)),
	win_SetDrawMode(Win,dm_XorPen),
	draw_Rect(Win,rct(XS1,T,XS2,B)),
	win_SetDrawMode(Win,dm_CopyPen),!.
  scale_DrawRect(Win,Y1,Y2):-
	scale_info(Win,scale_ver,_,_,_),
	ParentWin = win_GetParent(Win),
	Pnts = win_MapPoints(ParentWin,Win,[pnt(0,Y1),pnt(0,Y2)]),
	Pnts = [pnt(_,YS1),pnt(_,YS2)],
	Rect = win_GetClientRect(Win),
	Rect = rct(L,_,R,_),
	win_SetPen(Win,pen(1,ps_Solid,color_White)),
	win_SetBrush(Win,brush(pat_Solid,color_White)),
	win_SetDrawMode(Win,dm_XorPen),
	draw_Rect(Win,rct(L,YS1,R,YS2)),
	win_SetDrawMode(Win,dm_CopyPen),!.
  scale_DrawRect(_,_,_).

/**************************************************************************
	Creation and event handling for window: vscale
**************************************************************************/
predicates
  win_scale_eh : EHANDLER
clauses
  win_scale_eh(Win,e_Destroy,0):-
	retractall(scale_info(Win,_,_,_,_)),
	retractall(scale_callback(Win,_)),
	retractall(scale_point(Win,_)),
	retractall(scale_rect(Win,_,_)),!.

  win_scale_eh(_Win,e_EraseBackGround,0):-!.

  win_scale_eh(Win,e_Update(_),0):-
	Rect = win_getClientRect(Win),
	win_SetClip(Win,Rect),
	scale_redraw(Win),!.

  win_scale_eh(Win,Event,RetVal):-
	scale_callback(Win,ParentWinHandler),
	RetVal = ParentWinHandler(Win,EVENT),!.

  win_scale_eh(Win,e_Menu(ID,CAS),0):-
	ParentWin = win_GetParent(Win),
	win_SendEvent(ParentWin,e_Menu(ID,CAS)),!.

/******************************************************************
	TOP LEVEL predicates
*******************************************************************/
  scale_CreateHor(Win,RCT,PixInMM,EH,HWin):-
	HWin = scale_CreateHor(Win,RCT,PixInMM),
	assert(scale_callback(HWin,EH)),!.

  scale_CreateVer(Win,RCT,PixInMM,EH,VWin):-
	VWin = scale_CreateVer(Win,RCT,PixInMM),
	assert(scale_callback(VWin,EH)),!.

  scale_CreateHor(WIN,RCT,PixInMM,HWin):-
	HWin = win_Create(w_Child,RCT,"",no_menu,Win,
			[wsf_ClipSiblings],win_scale_eh,0),
	assert(scale_info(HWin,scale_hor,0,0,PixInMM)),!.

  scale_CreateVer(Win,RCT,PixInMM,VWin):-
	VWin = win_Create(w_Child,RCT,"",no_menu,Win,
			[wsf_ClipSiblings],win_scale_eh,0),
	assert(scale_info(VWin,scale_ver,0,0,PixInMM)),!.

  scale_WorkSpace(Win,L,R):-
	bound(L), bound(R),
	ParentWin = win_GetParent(Win),
	Pnts = win_MapPoints(ParentWin,Win,[pnt(L,0),pnt(R,0)]),
	Pnts = [pnt(L1,_),pnt(R1,_)],
	scale_info(Win,scale_hor,L1,R1,_),!.
  scale_WorkSpace(Win,L,R):-
	bound(L), bound(R),
	ParentWin = win_GetParent(Win),
	Pnts = win_MapPoints(ParentWin,Win,[pnt(L,0),pnt(R,0)]),
	Pnts = [pnt(L1,_),pnt(R1,_)],
	retract(scale_info(Win,scale_hor,_,_,LineStep)),
	assert(scale_info(Win,scale_hor,L1,R1,LineStep)),
	scale_redraw(Win),!.
  scale_WorkSpace(Win,L,R):-
	free(L), free(R),
	scale_info(Win,scale_hor,L1,R1,_),
	ParentWin = win_GetParent(Win),
	Pnts = win_MapPoints(Win,ParentWin,[pnt(L1,0),pnt(R1,0)]),
	Pnts = [pnt(L,_),pnt(R,_)],!.
  scale_WorkSpace(Win,T,B):-
	bound(T), bound(B),
	ParentWin = win_GetParent(Win),
	Pnts = win_MapPoints(ParentWin,Win,[pnt(0,T),pnt(0,B)]),
	Pnts = [pnt(_,T1),pnt(_,B1)],
	scale_info(Win,scale_ver,T1,B1,_),!.
  scale_WorkSpace(Win,T,B):-
	bound(T), bound(B),
	ParentWin = win_GetParent(Win),
	Pnts = win_MapPoints(ParentWin,Win,[pnt(0,T),pnt(0,B)]),
	Pnts = [pnt(_,T1),pnt(_,B1)],
	retract(scale_info(Win,scale_ver,_,_,LineStep)),
	assert(scale_info(Win,scale_ver,T1,B1,LineStep)),
	scale_redraw(Win),!.
  scale_WorkSpace(Win,T,B):-
	free(T), free(B),
	scale_info(Win,scale_ver,T1,B1,_),
	ParentWin = win_GetParent(Win),
	Pnts = win_MapPoints(Win,ParentWin,[pnt(0,T1),pnt(0,B1)]),
	Pnts = [pnt(_,T),pnt(_,B)],!.
  
  scale_Resize(Win,Rct):-
	scale_RemovePoint(Win),
	win_move(Win,Rct),!.

  scale_MovePnt(Win,Value):-
	scale_point(Win,Value),!.
  scale_MovePnt(Win,Value):-
	scale_RemovePoint(Win),
	scale_DrawPoint(Win,Value),
	assert(scale_point(Win,Value)),!.

  scale_RemovePnt(Win):-
	scale_RemovePoint(Win),!.

  scale_MoveRct(Win,Value1,Value2):-
	scale_rect(Win,Value1,Value2),!.
  scale_MoveRct(Win,Value1,Value2):-
	scale_RemoveRect(Win),
	scale_DrawRect(Win,Value1,Value2),
	assert(scale_rect(Win,Value1,Value2)),!.

  scale_RemoveRct(Win):-
	scale_RemoveRect(Win),!.
