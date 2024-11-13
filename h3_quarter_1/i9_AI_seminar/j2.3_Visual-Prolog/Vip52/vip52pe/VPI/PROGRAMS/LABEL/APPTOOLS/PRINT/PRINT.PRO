/******************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:	Label Expert
 FileName:	PRINT.PRO
 Purpose:	Print and Print preview
 Written by:	Sergey Alexeev
 Build:		008.981112
 Comments:
******************************************************************************/
constants
  pv_to_source = 1
database - pv_info_db
  pv_info(WINDOW ParentWin,WINDOW PVWin,INTEGER PixInMM,INTEGER ScaleThick,COLOR BgColor,PV_CALLBACK)
  pv_scale(WINDOW PVWin,WINDOW HS_Win,WINDOW VS_Win)
  pv_layout(WINDOW PVWin,WINDOW LO1_Win,WINDOW LO_Win,INTEGER L1,INTEGER T1)
  pv_vscroll_info(WINDOW PVWin,BOOLEAN Vert,WINDOW Vert,INTEGER CurVPos,INTEGER MaxVPos)
  pv_hscroll_info(WINDOW PVWin,BOOLEAN Hor,WINDOW Hor,INTEGER CurHPos,INTEGER MaxHPos)
  pv_param(WINDOW PVWin,INTEGER FormPage,COLOR ColorPage,REAL LeftMarg,REAL TopMarg,REAL HorSpace,
	REAL VertSpace,REAL LabelWidth,REAL LabelHeight,UNSIGNED NoHor,UNSIGNED NoVert,
	BOOLEAN Page_Roll,BOOLEAN Landscape,LE_FIELD_INFORMATIONLIST)
  pv_labels(WINDOW PVWin,WINDOW LOWin,WINDOW LO_Win,INTEGER HoHor,INTEGER NoVert),
  pv_update_area(RCT)
  determ pv_font(FONT)

predicates
  pv_min(REAL,REAL,REAL)
  pv_min1(INTEGER,INTEGER,INTEGER)
  pv_min1(UNSIGNED,UNSIGNED,UNSIGNED)
  pv_max(REAL,REAL,REAL)
  pv_max1(INTEGER,INTEGER,INTEGER)
clauses
  pv_min(X1,X2,X1):-
	X1 < X2,!.
  pv_min(_,X2,X2).
  pv_min1(X1,X2,X1):-
	X1 < X2,!.
  pv_min1(_,X2,X2).
  pv_max(X1,X2,X2):-
	X1 < X2,!.
  pv_max(X1,_,X1).
  pv_max1(X1,X2,X2):-
	X1 < X2,!.
  pv_max1(X1,_,X1).

predicates
  pv_win_eh : EHANDLER
  pv1_win_eh : EHANDLER
  pv2_win_eh : EHANDLER
  pv_calc_scale_rect(RCT PVWinInMM,INTEGER PixInMM,INTEGER ScaleThick,
	RCT PVWinInPix,RCT HorScale,RCT VerScale)
  pv_calc_layout_rect(REAL LeftMarg,REAL TopMarg,REAL HorSpace,REAL VertSpace,REAL LabelWidth,
	REAL LabelHeight,INTEGER NoHor,INTEGER NoVert,BOOLEAN Page_Roll,REAL PixInMM,
	INTEGER ScaleThick,RCT LayoutRect,RCT,INTEGER NoHor1,INTEGER NoVert1)
  pv_create_scroll(WINDOW PVWin)
  pv_draw_labels(BOOLEAN PrintBorder,UNSIGNED BegCount,UNSIGNED MaxCount,BOOLEAN,WINDOW LOWin,REAL PixInMMX,REAL PixInMMY,
	INTEGER FormPage,BRUSH Page,REAL LeftMarg,REAL TopMarg,REAL HorSpace,REAL VertSpace,
	REAL LabelWidth,REAL LabelHeight,INTEGER NoHor,INTEGER NoVert,BOOLEAN Landscape,LE_FIELD_INFORMATIONLIST)
  pv_draw_labels0(WINDOW PrintWin,BOOLEAN PrintBorder,UNSIGNED MaxCount,UNSIGNED MaxCount,BOOLEAN,WINDOW LOWin,
	REAL PixInMMX,REAL PixInMMY,INTEGER FormPage,BRUSH Page,REAL LeftMarg,REAL TopMarg,
	REAL HorSpace,REAL VertSpace,REAL LabelWidth,REAL LabelHeight,INTEGER NoHor,
	INTEGER NoVert,BOOLEAN Landscape,LE_FIELD_INFORMATIONLIST)
  pv_dialog_Ask(UNSIGNED LabNumber)
clauses
  print_create(Font,PrintBorder,FormPage,LeftMarg,TopMarg,HorSpace,VertSpace,
	LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,Landscape,InformationList):-
	retractall(pv_font(_)),
	assert(pv_font(Font)),
	pv_dialog_Ask(MaxCount),
	pv_calc_layout_rect(LeftMarg,TopMarg,HorSpace,VertSpace,LabelWidth,LabelHeight,
	NoHor,NoVert,Page_Roll,10,0,_,_,NoHor1,NoVert1),
	PHres = vpi_GetAttrVal(attr_printer_hres),
	PVres = vpi_GetAttrVal(attr_printer_vres),
	PixInMMX = PHres / 25.4,
	PixInMMY = PVres / 25.4,
	print_SetOrientation(Landscape),
	trap(PrintWin = print_StartJob(label_msg145),_,fail),
	win_SetMapMode(PrintWin,mm_Arbitrary),
	pv_draw_labels0(PrintWin,PrintBorder,MaxCount,MaxCount,b_true,PrintWin,PixInMMX,PixInMMY,FormPage,brush(pat_Hollow,color_White),LeftMarg,TopMarg,
	HorSpace,VertSpace,LabelWidth,LabelHeight,NoHor1,NoVert1,Landscape,InformationList),
	print_EndJob(PrintWin),!.
  print_create(_,_,_,_,_,_,_,_,_,_,_,_,_,_):-
	Msg="Cannot initialize a print job",
	dlg_Note(Msg).

  pv_draw_labels0(_,_,0,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_):-!.
  pv_draw_labels0(PrintWin,PrintBorder,Count,MaxCount,Print,LOWin,PixInMMX,PixInMMY,FormPage,Page,LeftMarg,TopMarg,
	HorSpace,VertSpace,LabelWidth,LabelHeight,NoHor,NoVert,Landscape,InformationList):-
	PageCount = NoHor * NoVert,
	pv_min1(Count,PageCount,MaxCount1),
	win_SetMapMode(PrintWin,mm_Arbitrary),
	print_StartPage(PrintWin),
	vpi_ProcessEvents(b_true),
	BegCount = MaxCount - Count + 1,
	pv_draw_labels(PrintBorder,BegCount,MaxCount1,Print,LOWin,PixInMMX,PixInMMY,FormPage,Page,LeftMarg,TopMarg,
	HorSpace,VertSpace,LabelWidth,LabelHeight,NoHor,NoVert,Landscape,InformationList),
	vpi_ProcessEvents(b_true),
	print_EndPage(PrintWin),
	vpi_ProcessEvents(b_true),
	MC = Count - MaxCount1,!,
	pv_draw_labels0(PrintWin,PrintBorder,MC,MaxCount,Print,LOWin,PixInMMX,PixInMMY,FormPage,Page,LeftMarg,TopMarg,
	HorSpace,VertSpace,LabelWidth,LabelHeight,NoHor,NoVert,Landscape,InformationList).

predicates
  pv_maximized(WINDOW,BOOLEAN)
  pv_tb_callback : TOOLBAR_ACTION_FUNC
clauses
  pv_maximized(PVWIn,b_true):-
	win_PostEvent(PVWin,e_Menu(0,0)),!.
  pv_maximized(_,_).

  pv_create(ParentWin,Maximized,Title,PixInMM,Rect,ScaleThick,BgColor,FormPage,ColorPage,LeftMarg,
	TopMarg,HorSpace,VertSpace,LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,Landscape,
	InformationList,CallBackFunc,PVWin):-
	pv_calc_scale_rect(Rect,PixInMM,ScaleThick,Rect1,HRect,VRect),
	PVWin = win_Create(w_TopLevel,Rect1,Title,no_menu,ParentWin,
		[wsf_TitleBar,wsf_ClipChildren,wsf_ClipSiblings],
		pv_win_eh,0),
	win_SetMapMode(PVWin,mm_Arbitrary),
	HS_Win = scale_CreateHor(PVWin,HRect,PixInMM),
	VS_Win = scale_CreateVer(PVWin,VRect,PixInMM),
	assert(pv_scale(PVWin,HS_Win,VS_Win)),
	pv_calc_layout_rect(LeftMarg,TopMarg,HorSpace,VertSpace,LabelWidth,LabelHeight,
	NoHor,NoVert,Page_Roll,PixInMM,ScaleThick,rct(LayL,LayT,LayR,LayB),rct(L,T,R,B),
	NoHor1,NoVert1),
	assert(pv_info(ParentWin,PVWin,PixInMM,ScaleThick,BgColor,CallBackFunc)),
	assert(pv_param(PVWin,FormPage,ColorPage,LeftMarg,TopMarg,HorSpace,VertSpace,
	LabelWidth,LabelHeight,NoHor1,NoVert1,Page_Roll,Landscape,InformationList)),
	scale_WorkSpace(HS_Win,L,R),
	scale_WorkSpace(VS_Win,T,B),
	Rect1 = rct(LM,TM,RM,BM),
	LOR = RM - LM, LOB = BM - TM,
	LO1_Win = win_Create(w_Child,rct(ScaleThick,ScaleThick,LOR,LOB),"",no_menu,PVWin,
		[wsf_ClipChildren,wsf_ClipSiblings],
		pv1_win_eh,0),
	LO_Win = win_Create(w_Child,rct(LayL,LayT,LayR,LayB),"",no_menu,LO1_Win,
		[wsf_ClipChildren,wsf_ClipSiblings],
		pv2_win_eh,0),
	L1 = L - ScaleThick, T1 = T - ScaleThick,
	toolbar_create(tb_inside(pnt(0,0)),0xC0C0C0,PVWin,[tb_ctrl(pv_to_source,pushb,idb_source_up,
		idb_source_dn,idb_source_dn,"",b_true,b_true)],pv_tb_callback),
	assert(pv_layout(PVWin,LO1_Win,LO_Win,L1,T1)),
	pv_create_scroll(PVWin),
	win_SetFocus(PVWin),
	pv_maximized(PVWin,Maximized),!.

  pv_tb_callback(PVWin,pv_to_source,ctrl_value(b_true,b_true)):-
	pv_info(_,PVWin,_,_,_,CallBackFunc),
	CallBackFunc(PVWin,go_to_source),!.

  pv_init(PVWin,PixInMM):-
	retract(pv_info(ParentWin,PVWin,_,ScaleThick,BgColor,CallBackFunc)),
	assert(pv_info(ParentWin,PVWin,PixInMM,ScaleThick,BgColor,CallBackFunc)),
	Rect = win_GetOuterRect(PVWin),
	Rect = rct(L01,T01,R01,B01),
	L0 = L01 div PixInMM, T0 = T01 div PixInMM,
	R0 = R01 div PixInMM, B0 = B01 div PixInMM,
	pv_calc_scale_rect(rct(L0,T0,R0,B0),PixInMM,ScaleThick,Rect1,HRect,VRect),
	retract(pv_scale(PVWin,HS_Win0,VS_Win0)),
	win_Destroy(HS_Win0),
	win_Destroy(VS_Win0),
	HS_Win = scale_CreateHor(PVWin,HRect,PixInMM),
	VS_Win = scale_CreateVer(PVWin,VRect,PixInMM),
	assert(pv_scale(PVWin,HS_Win,VS_Win)),
	pv_param(PVWin,_,_,LeftMarg,TopMarg,HorSpace,VertSpace,
	LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,_,_),
	pv_calc_layout_rect(LeftMarg,TopMarg,HorSpace,VertSpace,LabelWidth,LabelHeight,
	NoHor,NoVert,Page_Roll,PixInMM,ScaleThick,rct(LayL,LayT,LayR,LayB),rct(L,T,R,B),_,_),
	scale_WorkSpace(HS_Win,L,R),
	scale_WorkSpace(VS_Win,T,B),
	Rect1 = rct(LM,TM,RM,BM),
	LOR = RM - LM, LOB = BM - TM,
	L1 = L - ScaleThick, T1 = T - ScaleThick,
	retract(pv_layout(PVWin,LO1_Win,LO_Win,_,_)),
	assert(pv_layout(PVWin,LO1_Win,LO_Win,L1,T1)),
	win_Move(LO1_Win,rct(ScaleThick,ScaleThick,LOR,LOB)),
	win_Move(LO_Win,rct(LayL,LayT,LayR,LayB)),
	RectValid = win_GetClientRect(LO_Win),
	win_ValidateRect(LO_Win,RectValid),
	win_Invalidate(LO_Win),
	pv_create_scroll(PVWin),!.

  pv_calc_layout_rect(LeftMarg,TopMarg,HorSpace,VertSpace,LabelWidth,LabelHeight,
	NoHor,NoVert,b_false,PixInMM,ScaleThick,rct(L1,T1,R1,B1),rct(L2,T2,R2,B2),NoHor,3):-
	NoVert = 0,
	NH1 = NoHor - 1,
	pv_max1(NH1,0,NH),
	Width = LeftMarg * 2 + LabelWidth * NoHor + HorSpace * NH,
	Height = TopMarg * 2 + LabelHeight * 3 + VertSpace * 2,
	L1 = 10 * PixInMM + 3,
	T1 = 10 * PixInMM + 3,
	R1 = L1 + Width * PixInMM,
	B1 = T1 + Height * PixInMM,
	L2 = L1 + ScaleThick, T2 = T1 + ScaleThick,
	R2 = R1 + ScaleThick, B2 = B1 + ScaleThick,!.
  pv_calc_layout_rect(LeftMarg,TopMarg,HorSpace,VertSpace,LabelWidth,LabelHeight,
	NoHor,NoVert,b_false,PixInMM,ScaleThick,rct(L1,T1,R1,B1),rct(L2,T2,R2,B2),3,NoVert):-
	NoHor = 0,
	NV1 = NoVert - 1,
	pv_max1(NV1,0,NV),
	Width = LeftMarg * 2 + LabelWidth * 3 + HorSpace * 2,
	Height = TopMarg * 2 + LabelHeight * NoVert + VertSpace * NV,
	L1 = 10 * PixInMM + 3,
	T1 = 10 * PixInMM + 3,
	R1 = L1 + Width * PixInMM,
	B1 = T1 + Height * PixInMM,
	L2 = L1 + ScaleThick, T2 = T1 + ScaleThick,
	R2 = R1 + ScaleThick, B2 = B1 + ScaleThick,!.
  pv_calc_layout_rect(LeftMarg,TopMarg,HorSpace,VertSpace,LabelWidth,LabelHeight,
	NoHor,NoVert,_,PixInMM,ScaleThick,rct(L1,T1,R1,B1),rct(L2,T2,R2,B2),NoHor,NoVert):-
	NH1 = NoHor - 1,
	pv_max1(NH1,0,NH),
	NV1 = NoVert - 1,
	pv_max1(NV1,0,NV),
	Width = LeftMarg * 2 + LabelWidth * NoHor + HorSpace * NH,
	Height = TopMarg * 2 + LabelHeight * NoVert + VertSpace * NV,
	L1 = 10 * PixInMM + 3,
	T1 = 10 * PixInMM + 3,
	R1 = L1 + Width * PixInMM,
	B1 = T1 + Height * PixInMM,
	L2 = L1 + ScaleThick, T2 = T1 + ScaleThick,
	R2 = R1 + ScaleThick, B2 = B1 + ScaleThick,!.

  pv_calc_scale_rect(rct(L,T,R,B),PixInMM,ScaleThick,rct(L1,T1,R1,B1),rct(HL,HT,HR,HB),rct(VL,VT,VR,VB)):-
	L1 = L * PixInMM, T1 = T * PixInMM, R1 = L + (R - L) * PixInMM, B1 = T + (B - T) * PixInMM,
	HL = ScaleThick, HT = 0, HR = R1, HB = ScaleThick,
	VL = 0, VT = ScaleThick, VR = ScaleThick, VB = B1,!.

predicates
  pv_remove_scroll(WINDOW PVWin)
clauses
  pv_remove_scroll(PVWin):-
	retract(pv_vscroll_info(PVWin,b_true,Win,_,_)),
	win_Destroy(Win),fail.
  pv_remove_scroll(PVWin):-
	retract(pv_hscroll_info(PVWin,b_true,Win,_,_)),
	win_Destroy(Win),!.
  pv_remove_scroll(_).

predicates
  pv_resize_scroll(WINDOW PVWin)
clauses
  pv_resize_scroll(PVWin):-
	pv_vscroll_info(PVWin,b_true,VW,_,_),
	pv_hscroll_info(PVWin,b_true,HW,_,_),
	Rect1 = win_GetOuterRect(VW),
	Rect2 = win_GetOuterRect(HW),
	Rect1 = rct(L1,T1,R1,_),
	Rect2 = rct(L2,T2,_,B2),
	win_Move(VW,rct(L1,T1,R1,T2)),
	win_Move(HW,rct(L2,T2,L1,B2)),!.
  pv_resize_scroll(_).

predicates
  pv_create_vscroll(WINDOW PVWin,RCT,RCT,RCT)
  pv_create_hscroll(WINDOW PVWin,RCT,RCT,RCT)
  pv_set_vscroll_range(WINDOW PVWin,INTEGER T1,INTEGER B1,INTEGER T2,INTEGER B2)
  pv_set_hscroll_range(WINDOW PVWin,INTEGER L1,INTEGER R1,INTEGER L2,INTEGER R2)
clauses
  pv_create_scroll(PVWin):-
	pv_layout(PVWin,LO1_Win,LO_Win,DX,DY),
	pv_remove_scroll(PVWin),
	Rect1 = win_GetClientRect(PVWin),
	Rect1 = rct(L01,T01,R0,B0),
	pv_info(_,PVWin,_,ScaleThick,_,_),
	L0 = L01 + ScaleThick, T0 = T01 + ScaleThick,
	Rect2 = win_GetOuterRect(LO_Win),
	Rect2 = rct(L1,T1,R,B),
	L = L1 - DX, T = T1 - DY,
	NullWin = cast(WINDOW,0),
	retractall(pv_vscroll_info(PVWin,_,_,_,_)),
	retractall(pv_hscroll_info(PVWin,_,_,_,_)),
	assert(pv_vscroll_info(PVWin,b_false,NullWin,0,0)),
	assert(pv_hscroll_info(PVWin,b_false,NullWin,0,0)),
	pv_create_vscroll(PVWin,rct(L0,T0,R0,B0),rct(L,T,R,B),Rect11),
	pv_create_hscroll(PVWin,Rect11,rct(L,T,R,B),Rect12),
	pv_create_vscroll(PVWin,Rect12,rct(L,T,R,B),Rect13),
	pv_resize_scroll(PVWin),
	pv_set_vscroll_range(PVWin,T0,B0,T,B),
	pv_set_hscroll_range(PVWin,L0,R0,L,R),
	win_Move(LO1_Win,Rect13),!.

  pv_create_vscroll(PVWin,rct(L1,T1,R1,B1),rct(_,T2,_,B2),rct(L1,T1,Lv,B1)):-
	pv_vscroll_info(PVWin,b_false,_,CVP,MVP),
	DM = B1 - T1, DD = B2 - T2,
	DD > DM,
	DS = vpi_GetAttrVal(attr_ctl_vert_sbar_width),
	Lv = R1 - DS,
	VW = win_CreateControl(wc_VScroll,rct(Lv,T1,R1,B1),"",PVWin,[],777),
	retractall(pv_vscroll_info(PVWin,_,_,_,_)),
	assert(pv_vscroll_info(PVWin,b_true,VW,CVP,MVP)),!.
  pv_create_vscroll(PVWin,Rect,_,Rect):-
	pv_vscroll_info(PVWin,b_false,_,_,_),
	pv_layout(PVWin,_,LO_Win,_,DY),
	RCT = win_GetOuterRect(LO_Win),
	RCT = rct(L,T,R,B),
	T1 = DY, B1 = T1 + (B - T),
	win_Move(LO_Win,rct(L,T1,R,B1)),
	pv_scale(PVWin,_,VS_Win),
	pv_info(_,PVWin,_,ScaleThick,_,_),
	scale_WorkSpace(VS_Win,T0,B0),
	T01 = DY + ScaleThick, B01 = T01 + (B0 - T0),
	scale_WorkSpace(VS_Win,T01,B01),!.
  pv_create_vscroll(_,Rect,_,Rect).
  pv_create_hscroll(PVWin,rct(L1,T1,R1,B1),rct(L2,_,R2,_),rct(L1,T1,R1,Tv)):-
	pv_hscroll_info(PVWin,b_false,_,CVP,MVP),
	DM = R1 - L1, DD = R2 - L2,
	DD > DM,
	DS = vpi_GetAttrVal(attr_ctl_horz_sbar_height),
	Tv = B1 - DS,
	HW = win_CreateControl(wc_HScroll,rct(L1,Tv,R1,B1),"",PVWin,[],778),
	retractall(pv_hscroll_info(PVWin,_,_,_,_)),
	assert(pv_hscroll_info(PVWin,b_true,HW,CVP,MVP)),!.
  pv_create_hscroll(PVWin,Rect,_,Rect):-
	pv_hscroll_info(PVWin,b_false,_,_,_),
	pv_layout(PVWin,_,LO_Win,DX,_),
	RCT = win_GetOuterRect(LO_Win),
	RCT = rct(L,T,R,B),
	L1 = DX, R1 = L1 + (R - L),
	win_Move(LO_Win,rct(L1,T,R1,B)),
	pv_scale(PVWin,HS_Win,_),
	pv_info(_,PVWin,_,ScaleThick,_,_),
	scale_WorkSpace(HS_Win,L0,R0),
	L01 = DX + ScaleThick, R01 = L01 + (R0 - L0),
	scale_WorkSpace(HS_Win,L01,R01),!.
  pv_create_hscroll(_,Rect,_,Rect).

  pv_set_vscroll_range(PVWin,T1,B1,T2,B2):-
	pv_vscroll_info(PVWin,b_true,VW,_,_),
	pv_info(_,PVWin,PixInMM,_,_,_),
	OneScroll = 10 * PixInMM,
	DM = B1 - T1, DD = B2 - T2,
	Range = (DD - DM) div OneScroll + 3,
	win_SetScrollRange(VW,sb_Ctl,1,Range),
	First = 0 - T2 div OneScroll + 1,
	win_SetScrollPos(VW,sb_Ctl,First),
	retractall(pv_vscroll_info(PVWin,_,_,_,_)),
	assert(pv_vscroll_info(PVWin,b_true,VW,First,Range)),!.
  pv_set_vscroll_range(_,_,_,_,_).
  pv_set_hscroll_range(PVWin,L1,R1,L2,R2):-
	pv_hscroll_info(PVWin,b_true,HW,_,_),
	pv_info(_,PVWin,PixInMM,_,_,_),
	OneScroll = 10 * PixInMM,
	DM = R1 - L1, DD = R2 - L2,
	Range = (DD - DM) div OneScroll + 3,
	win_SetScrollRange(HW,sb_Ctl,1,Range),
	First = 0 - L2 div OneScroll + 1,
	win_SetScrollPos(HW,sb_Ctl,First),
	retractall(pv_hscroll_info(PVWin,_,_,_,_)),
	assert(pv_hscroll_info(PVWin,b_true,HW,First,Range)),!.
  pv_set_hscroll_range(_,_,_,_,_).

predicates
  pv_vscroll_handler(WINDOW PVWin,SCROLLCODE Control,INTEGER Pos)
  pv_hscroll_handler(WINDOW PVWin,SCROLLCODE Control,INTEGER Pos)
  pv_vmove(WINDOW PVWin,INTEGER Dif)
  pv_hmove(WINDOW PVWin,INTEGER Dif)
clauses
  pv_vscroll_handler(_,sc_None,_):-!.
  pv_vscroll_handler(PVWin,sc_LineUp,_):-
	pv_vmove(PVWin,-1),!.
  pv_vscroll_handler(PVWin,sc_LineDown,_):-
	pv_vmove(PVWin,1),!.
  pv_vscroll_handler(PVWin,sc_PageUp,_):-
	pv_layout(PVWin,LO1_Win,_,_,_),
	Rect = win_GetClientRect(LO1_Win),
	Rect = rct(_,T,_,B),
	pv_info(_,PVWin,PixInMM,_,_,_),
	OneScroll = 10 * PixInMM,
	Dif = 0 - (B - T) div OneScroll,
	pv_vmove(PVWin,Dif),!.
  pv_vscroll_handler(PVWin,sc_PageDown,_):-
	pv_layout(PVWin,LO1_Win,_,_,_),
	Rect = win_GetClientRect(LO1_Win),
	Rect = rct(_,T,_,B),
	pv_info(_,PVWin,PixInMM,_,_,_),
	OneScroll = 10 * PixInMM,
	Dif = (B - T) div OneScroll,
	pv_vmove(PVWin,Dif),!.
  pv_vscroll_handler(PVWin,sc_Thumb,Pos):-
	pv_vscroll_info(PVWin,_,_,CurVPos,_),
	Dif = Pos - CurVPos,
	pv_vmove(PVWin,Dif),!.
  pv_vscroll_handler(PVWin,_,_):-
	trap(win_SetFocus(PVWin),_,true),!.

  pv_hscroll_handler(_,sc_None,_):-!.
  pv_hscroll_handler(PVWin,sc_LineUp,_):-
	pv_hmove(PVWin,-1),!.
  pv_hscroll_handler(PVWin,sc_LineDown,_):-
	pv_hmove(PVWin,1),!.
  pv_hscroll_handler(PVWin,sc_PageUp,_):-
	pv_layout(PVWin,LO1_Win,_,_,_),
	Rect = win_GetClientRect(LO1_Win),
	Rect = rct(L,_,R,_),
	pv_info(_,PVWin,PixInMM,_,_,_),
	OneScroll = 10 * PixInMM,
	Dif = 0 - (R - L) div OneScroll,
	pv_hmove(PVWin,Dif),!.
  pv_hscroll_handler(PVWin,sc_PageDown,_):-
	pv_layout(PVWin,LO1_Win,_,_,_),
	Rect = win_GetClientRect(LO1_Win),
	Rect = rct(L,_,R,_),
	pv_info(_,PVWin,PixInMM,_,_,_),
	OneScroll = 10 * PixInMM,
	Dif = (R - L) div OneScroll,
	pv_hmove(PVWin,Dif),!.
  pv_hscroll_handler(PVWin,sc_Thumb,Pos):-
	pv_hscroll_info(PVWin,_,_,CurVPos,_),
	Dif = Pos - CurVPos,
	pv_hmove(PVWin,Dif),!.
  pv_hscroll_handler(PVWin,_,_):-
	trap(win_SetFocus(PVWin),_,true),!.

  pv_vmove(PVWin,Deff):-
	pv_vscroll_info(PVWin,b_true,VW,CurPos,MaxPos),
	Pos = CurPos + Deff,
	pv_max(Pos,1,Pos1),
	pv_min(Pos1,MaxPos,NewPos),
	retractall(pv_vscroll_info(PVWin,_,_,_,_)),
	assert(pv_vscroll_info(PVWin,b_true,VW,NewPos,MaxPos)),
	win_SetScrollPos(VW,sb_Ctl,NewPos),
	pv_layout(PVWin,_,LO_Win,_,_),
	Rect = win_GetOuterRect(LO_Win),
	Rect = rct(L,T1,R,B1),
	pv_info(_,PVWin,PixInMM,_,_,_),
	OneScroll = 10 * PixInMM,
	Dif = (CurPos - NewPos) * OneScroll,
	T = T1 + Dif, B = B1 + Dif,
	win_Move(LO_Win,rct(L,T,R,B)),
	pv_scale(PVWin,_,VS_Win),
	scale_WorkSpace(VS_Win,T0,B0),
	T01 = T0 + Dif, B01 = B0 + Dif,
	scale_WorkSpace(VS_Win,T01,B01),!.
  pv_vmove(_,_).
  pv_hmove(PVWin,Deff):-
	pv_hscroll_info(PVWin,b_true,VW,CurPos,MaxPos),
	Pos = CurPos + Deff,
	pv_max(Pos,1,Pos1),
	pv_min(Pos1,MaxPos,NewPos),
	retractall(pv_hscroll_info(PVWin,_,_,_,_)),
	assert(pv_hscroll_info(PVWin,b_true,VW,NewPos,MaxPos)),
	win_SetScrollPos(VW,sb_Ctl,NewPos),
	pv_layout(PVWin,_,LO_Win,_,_),
	Rect = win_GetOuterRect(LO_Win),
	Rect = rct(L1,T,R1,B),
	pv_info(_,PVWin,PixInMM,_,_,_),
	OneScroll = 10 * PixInMM,
	Dif = (CurPos - NewPos) * OneScroll,
	L = L1 + Dif, R = R1 + Dif,
	win_Move(LO_Win,rct(L,T,R,B)),
	pv_scale(PVWin,HS_Win,_),
	scale_WorkSpace(HS_Win,L0,R0),
	L01 = L0 + Dif, R01 = R0 + Dif,
	scale_WorkSpace(HS_Win,L01,R01),!.
  pv_hmove(_,_).

/*************************************************************************
			     PV EVENT HANDLER
*************************************************************************/
  pv2_win_eh(_,e_EraseBackground(),0):-!.

  pv2_win_eh(LOWin,e_Update(Rect),0):-
	Rect1 = win_GetClientRect(LOWin),
	win_SetClip(LOWin,Rect1),
	win_Clear(LOWin,Rect,color_Yellow),
	pv_layout(PVWin,_,LOWin,_,_),
	pv_param(PVWin,FormPage,ColorPage,LeftMarg,TopMarg,
	HorSpace,VertSpace,LabelWidth,LabelHeight,NoHor,NoVert,_,Landscape,InformationList),
	pv_info(_,PVWin,PixInMM,_,_,_),
	pv_draw_labels(b_true,1,10000,b_false,LOWin,PixInMM,PixInMM,FormPage,brush(pat_Solid,ColorPage),LeftMarg,TopMarg,
	HorSpace,VertSpace,LabelWidth,LabelHeight,NoHor,NoVert,Landscape,InformationList),!.

  pv1_win_eh(_,e_EraseBackground(),0):-!.

  pv1_win_eh(LO1_Win,e_Update(Rect),0):-
	pv_layout(PVWin,LO1_Win,_,_,_),
	pv_info(_,PVWin,_,_,BgColor,_),
	win_Clear(LO1_Win,Rect,BgColor),!.

  pv_win_eh(PVWin,EVENT,0):-
	pv_info(_,PVWin,_,_,_,CallBackFunc),
	CallBackFunc(PVWin,event(EVENT)),!.

  pv_win_eh(PVWin,e_Destroy,0):-
	retract(pv_info(_,PVWin,_,_,_,_)),
	retract(pv_scale(PVWin,_,_)),
	retract(pv_layout(PVWin,_,_,_,_)),
	retractall(pv_vscroll_info(PVWin,_,_,_,_)),
	retractall(pv_hscroll_info(PVWin,_,_,_,_)),
	retractall(pv_labels(PVWin,_,_,_,_)),!.

  pv_win_eh(_,e_EraseBackground(),0):-!.

  pv_win_eh(PVWin,e_Update(Rect),0):-
	pv_info(_,PVWin,_,_,BgColor,_),
	win_Clear(PVWin,Rect,BgColor),!.

  pv_win_eh(PVWin,e_Size(Width,Height),0):-
	pv_info(_,PVWin,PixInMM,ScaleThick,_,_),
	pv_calc_scale_rect(rct(0,0,Width,Height),PixInMM,ScaleThick,_,HRect,VRect),
	pv_scale(PVWin,HS_Win,VS_Win),
	scale_Resize(HS_Win,HRect),
	scale_Resize(VS_Win,VRect),
	pv_layout(PVWin,LO1_Win,_,_,_),
	win_Move(LO1_Win,rct(ScaleThick,ScaleThick,Width,Height)),
	pv_create_scroll(PVWin),!.

  pv_win_eh(PVWin,e_Menu(0,_ShiftCtlAlt),0):-
	win_SetState(PVWin,[wsf_Maximized]),!.

  pv_win_eh(PVWin,e_Control(_,wc_VScroll,_,scroll(Control,Pos)),0):-
	pv_vscroll_handler(PVWin,Control,Pos),!.
  pv_win_eh(PVWin,e_Control(_,wc_HScroll,_,scroll(Control,Pos)),0):-
	pv_hscroll_handler(PVWin,Control,Pos),!.

predicates
  pv_win_SetClip(BOOLEAN,WINDOW LOWin,RCT,RCT)
clauses
  pv_win_SetClip(b_false,LOWin,Rect,_):-
	win_SetClip(LOWin,Rect),!.
  pv_win_SetClip(_,LOWin,_,Rect):-
	win_SetClip(LOWin,Rect),!.

predicates
  pv_GetDrawRect(BOOLEAN,RCT,RCT,RCT)
clauses
  pv_GetDrawRect(b_false,Rect,_,Rect):-!.
  pv_GetDrawRect(_,_,Rect,Rect).

predicates
  pv_draw_labels1(BOOLEAN PrintBorder,UNSIGNED MaxCount,BOOLEAN Clip,ULONG Count,WINDOW LOWin,INTEGER L,INTEGER T,REAL PixInMMX,
	REAL PixInMMY,INTEGER FormPage,BRUSH Page,REAL HorSpace,REAL VertSpace,REAL LabelWidth,
	REAL LabelHeight,INTEGER NoHor,INTEGER NoVert,BOOLEAN Landscape,LE_FIELD_INFORMATIONLIST)
clauses
  pv_draw_labels(PrintBorder,BegCount,MaxCount,Clip,LOWin,PixInMMX,PixInMMY,FormPage,Brush,LeftMarg,TopMarg,HorSpace,VertSpace,
	LabelWidth,LabelHeight,NoHor,NoVert,Landscape,InformationList):-
	MC = BegCount + MaxCount - 1,
	L = LeftMarg * PixInMMX, T = TopMarg * PixInMMY,
	PixInMMX2 = PixInMMX * 10,
	PixInMMY2 = PixInMMY * 10,
	PixInMMX1 = val(integer,PixInMMX2),
	PixInMMY1 = val(integer,PixInMMY2),
	win_SetMapScale(LOWin,pnt(0,0),pnt(40,40),pnt(0,0),pnt(PixInMMX1,PixInMMY1)),
	pv_draw_labels1(PrintBorder,MC,Clip,BegCount,LOWin,L,T,PixInMMX,PixInMMY,FormPage,Brush,HorSpace,VertSpace,
	LabelWidth,LabelHeight,NoHor,NoVert,Landscape,InformationList),
	win_SetMapScale(LOWin,pnt(0,0),pnt(40,40),pnt(0,0),pnt(40,40)),
	pv_win_SetClip(Clip,LOWin,rct(0,0,30000,30000),rct(0,0,30000,30000)),!.
  pv_draw_labels(_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_).

predicates
  pv_draw_labels2v(BOOLEAN PrintBorder,UNSIGNED MaxCount,BOOLEAN Clip,ULONG Count,ULONG Count,WINDOW LOWin,
	INTEGER L,INTEGER T,INTEGER B,REAL PixInMMX,REAL PixInMMY,INTEGER FormPage,BRUSH Page,REAL HorSpace,
	REAL LabelWidth,INTEGER NoHor,INTEGER NoVert,LE_FIELD_INFORMATIONLIST)
  pv_draw_labels2h(BOOLEAN PrintBorder,UNSIGNED MaxCount,BOOLEAN Clip,ULONG Count,ULONG Count,WINDOW LOWin,
	INTEGER L,INTEGER T,INTEGER R,REAL PixInMMX,REAL PixInMMY,INTEGER FormPage,BRUSH Page,REAL VertSpace,
	REAL LabelHeight,INTEGER NoHor,INTEGER NoVert,LE_FIELD_INFORMATIONLIST)
clauses
  pv_draw_labels1(_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,0,b_false,_):-!.
  pv_draw_labels1(_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,0,_,b_true,_):-!.
  pv_draw_labels1(PrintBorder,MaxCount,Clip,Count,LOWin,L,T,PixInMMX,PixInMMY,FormPage,Brush,HorSpace,VertSpace,
	LabelWidth,LabelHeight,NoHor,NoVert,b_false,InformationList):-
	B = T + LabelHeight * PixInMMY,
	pv_draw_labels2v(PrintBorder,MaxCount,Clip,Count,C,LOWin,L,T,B,PixInMMX,PixInMMY,FormPage,Brush,HorSpace,
	LabelWidth,NoHor,NoVert,InformationList),
	T1 = T + (LabelHeight + VertSpace) * PixInMMY,
	NV = NoVert - 1,!,
	pv_draw_labels1(PrintBorder,MaxCount,Clip,C,LOWin,L,T1,PixInMMX,PixInMMY,FormPage,Brush,HorSpace,VertSpace,
	LabelWidth,LabelHeight,NoHor,NV,b_false,InformationList).
  pv_draw_labels1(PrintBorder,MaxCount,Clip,Count,LOWin,L,T,PixInMMX,PixInMMY,FormPage,Brush,HorSpace,VertSpace,
	LabelWidth,LabelHeight,NoHor,NoVert,b_true,InformationList):-
	R = L + LabelWidth * PixInMMX,
	pv_draw_labels2h(PrintBorder,MaxCount,Clip,Count,C,LOWin,L,T,R,PixInMMX,PixInMMY,FormPage,Brush,VertSpace,
	LabelHeight,NoHor,NoVert,InformationList),
	L1 = L + (LabelWidth + HorSpace) * PixInMMX,
	NH = NoHor - 1,!,
	pv_draw_labels1(PrintBorder,MaxCount,Clip,C,LOWin,L1,T,PixInMMX,PixInMMY,FormPage,Brush,HorSpace,VertSpace,
	LabelWidth,LabelHeight,NH,NoVert,b_true,InformationList).

predicates
  pv_draw_fields(BOOLEAN Clip,REAL PixInMMX,REAL PixInMMY,ULONG Count,WINDOW LOWin,INTEGER L,
	INTEGER T,LE_FIELD_INFORMATIONLIST)
  pv_draw_page(BOOLEAN PrintBorder,WINDOW LOWin,INTEGER FormPage,RCT,BRUSH,REAL PixInMM)
clauses
  pv_draw_labels2v(_,MaxCount,_,Count,Count,_,_,_,_,_,_,_,_,_,_,_,_,_):-
	Count > MaxCount,!.
  pv_draw_labels2v(_,_,_,Count,Count,_,_,_,_,_,_,_,_,_,_,0,_,_):-!.
  pv_draw_labels2v(PrintBorder,MaxCount,Clip,C,Count,LOWin,L,T,B,PixInMMX,PixInMMY,FormPage,Brush,
	HorSpace,LabelWidth,NoHor,NoVert,InformationList):-
	R = L + LabelWidth * PixInMMX,
	Ls = L * 4 / PixInMMX, Ts = T * 4 / PixInMMY,
	Rs = Ls + (R - L) * 4 / PixInMMX, Bs = Ts + (B - T) * 4 / PixInMMY,
	pv_win_SetClip(Clip,LOWin,rct(L,T,R,B),rct(Ls,Ts,Rs,Bs)),
	pv_GetDrawRect(Clip,rct(L,T,R,B),rct(Ls,Ts,Rs,Bs),DrawRect),
	pv_draw_page(PrintBorder,LOWin,FormPage,DrawRect,Brush,PixInMMX),
	pv_draw_fields(Clip,PixInMMX,PixInMMY,C,LOWin,L,T,InformationList),
	L1 = L + (LabelWidth + HorSpace) * PixInMMX,
	NH = NoHor - 1,
	C1 = C + 1,!,
	pv_draw_labels2v(PrintBorder,MaxCount,Clip,C1,Count,LOWin,L1,T,B,PixInMMX,PixInMMY,FormPage,
	Brush,HorSpace,LabelWidth,NH,NoVert,InformationList).

  pv_draw_labels2h(_,MaxCount,_,Count,Count,_,_,_,_,_,_,_,_,_,_,_,_,_):-
	Count > MaxCount,!.
  pv_draw_labels2h(_,_,_,Count,Count,_,_,_,_,_,_,_,_,_,_,_,0,_):-!.
  pv_draw_labels2h(PrintBorder,MaxCount,Clip,C,Count,LOWin,L,T,R,PixInMMX,PixInMMY,FormPage,Brush,
	VertSpace,LabelHeight,NoHor,NoVert,InformationList):-
	B = T + LabelHeight * PixInMMY,
	Ls = L * 4 / PixInMMX, Ts = T * 4 / PixInMMY,
	Rs = Ls + (R - L) * 4 / PixInMMX, Bs = Ts + (B - T) * 4 / PixInMMY,
	pv_win_SetClip(Clip,LOWin,rct(L,T,R,B),rct(Ls,Ts,Rs,Bs)),
	pv_GetDrawRect(Clip,rct(L,T,R,B),rct(Ls,Ts,Rs,Bs),DrawRect),
	pv_draw_page(PrintBorder,LOWin,FormPage,DrawRect,Brush,PixInMMX),
	pv_draw_fields(Clip,PixInMMX,PixInMMY,C,LOWin,L,T,InformationList),
	T1 = T + (LabelHeight + VertSpace) * PixInMMY,
	NV = NoVert - 1,
	C1 = C + 1,!,
	pv_draw_labels2h(PrintBorder,MaxCount,Clip,C1,Count,LOWin,L,T1,R,PixInMMX,PixInMMY,FormPage,
	Brush,VertSpace,LabelHeight,NoHor,NV,InformationList).

  pv_draw_fields(_,_,_,_,_,_,_,[]):-!.
%  pv_draw_fields(Print,PixInMMX,PixInMMY,Count,LOWin,X,Y,[info(le_rct(L,T,R,B),Orientation,line(Pen))|Rest]):-
%	L1 = L * PixInMMX, T1 = T * PixInMMY, R1 = R * PixInMMX, B1 = B * PixInMMY,
%	L2 = L1 + X, T2 = T1 + Y, R2 = R1 + X, B2 = B1 + Y,
%	L3 = L2 * 4 / PixInMMX, T3 = T2 * 4 / PixInMMY,
%	R3 = L3 + (R2 - L2) * 4 / PixInMMX, B3 = T3 + (B2 - T2) * 4 / PixInMMY,
%	pv_win_SetClip(Print,LOWin,rct(0,0,30000,30000),rct(0,0,30000,30000)),
%	dr_draw_field(b_false,Print,LOWin,Count,rct(L3,T3,R3,B3),Orientation,line(Pen)),!,
%	pv_draw_fields(Print,PixInMMX,PixInMMY,Count,LOWin,X,Y,Rest).
  pv_draw_fields(Print,PixInMMX,PixInMMY,Count,LOWin,X,Y,[info(le_rct(L,T,R,B),Orientation,Type)|Rest]):-
	L1 = L * PixInMMX, T1 = T * PixInMMY, R1 = R * PixInMMX, B1 = B * PixInMMY,
	L2 = L1 + X, T2 = T1 + Y, R2 = R1 + X, B2 = B1 + Y,
	L3 = L2 * 4 / PixInMMX, T3 = T2 * 4 / PixInMMY,
	R3 = L3 + (R2 - L2) * 4 / PixInMMX, B3 = T3 + (B2 - T2) * 4 / PixInMMY,
	pv_win_SetClip(Print,LOWin,rct(L2,T2,R2,B2),rct(L3,T3,R3,B3)),
	pv_GetDrawRect(Print,rct(L2,T2,R2,B2),rct(L3,T3,R3,B3),DrawRect),
	dr_draw_field(b_false,Print,PixInMMX,LOWin,Count,DrawRect,Orientation,Type),
	pv_draw_fields(Print,PixInMMX,PixInMMY,Count,LOWin,X,Y,Rest).

  pv_draw_page(b_true,LOWin,1,Rect,Brush,_):-
	win_SetPen(LOWin,pen(1,ps_Solid,color_Black)),
	win_SetBrush(LOWin,Brush),
	draw_Rect(LOWin,Rect),!.
  pv_draw_page(b_true,LOWin,2,Rect,Brush,PixInMM):-
	CornerRad = 5 * PixInMM,
	win_SetPen(LOWin,pen(1,ps_Solid,color_Black)),
	win_SetBrush(LOWin,Brush),
	draw_RoundRect(LOWin,Rect,CornerRad,CornerRad),!.
  pv_draw_page(b_true,LOWin,3,Rect,Brush,_):-
	win_SetPen(LOWin,pen(1,ps_Solid,color_Black)),
	win_SetBrush(LOWin,Brush),
	draw_Ellipse(LOWin,Rect),!.
  pv_draw_page(b_false,LOWin,1,Rect,Brush,_):-
	win_SetPen(LOWin,pen(1,ps_Hollow,color_Black)),
	win_SetBrush(LOWin,Brush),
	draw_Rect(LOWin,Rect),!.
  pv_draw_page(b_false,LOWin,2,Rect,Brush,PixInMM):-
	CornerRad = 5 * PixInMM,
	win_SetPen(LOWin,pen(1,ps_Hollow,color_Black)),
	win_SetBrush(LOWin,Brush),
	draw_RoundRect(LOWin,Rect,CornerRad,CornerRad),!.
  pv_draw_page(b_false,LOWin,3,Rect,Brush,_):-
	win_SetPen(LOWin,pen(1,ps_Hollow,color_Black)),
	win_SetBrush(LOWin,Brush),
	draw_Ellipse(LOWin,Rect),!.

predicates
  pv_dialog_ask_eh : EHANDLER
clauses
  pv_dialog_Ask(LabNumber):-
	TaskWin1 = vpi_GetAttrVal(attr_task_window),
	TaskWin = cast(window,TaskWin1),
	dialog_Create(TaskWin,[resdlg(idd_pv_ask,wd_Modal)],
  		[
		df(idct_ask_1,statictext(label_msg146),nopr),
		df(idc_pv_ask_1,editint(i(1),[range(1,10000),default(1)]),nopr),
		df(idc_ok,pushbutton(label_msg180),nopr),
		df(idc_cancel,pushbutton(label_msg181),nopr)
  		],
		pv_dialog_ask_eh,0,Vallist,Answer),
	Answer = idc_ok,
	LabNumber1 = dialog_VLGetInt(idc_pv_ask_1,Vallist),
	LabNumber1 = i(LabNumber),!.

  pv_dialog_ask_eh(Win,e_Create(_),0):-
	pv_font(Font),
	Ctl1 = win_GetCtlHandle(Win,idct_ask_1),
	win_SetFont(Ctl1,Font),
	Ctl2 = win_GetCtlHandle(Win,idc_pv_ask_1),
	win_SetFont(Ctl2,Font),
	Ctl3 = win_GetCtlHandle(Win,idc_ok),
	win_SetFont(Ctl3,Font),
	Ctl4 = win_GetCtlHandle(Win,idc_cancel),
	win_SetFont(Ctl4,Font),!.
