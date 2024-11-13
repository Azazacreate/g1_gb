/******************************************************************************

		 Copyright (c) 1984 - 2000 Prolog Development Center A/S

 FileName:	TREEBUT.PRO
 Purpose:	Tree Button custom control object
 Written by:	Sergey Alexeev
 Version:	1.0
 Build:		002.000316
 Tested with:   Visual Prolog v.5.0 build 533
 Comments:
******************************************************************************/
ifdef use_winctrl_treebut

ifndef winctrls_pre_included
 #Error: this file requires include: winctrls.pre
enddef 

DATABASE - tb_db
  tb_class
  tb_info(WINDOW TBWin,TV_TREELIST,INTEGER ItemId,RCT LargeSizeRect,RCT SmallSizeRect,BOOLEAN Expand)

PREDICATES
  procedure tb_class_create()
CLAUSES
  tb_class_create():-
	tb_class,!.
  tb_class_create():-
	class_Create("TopTreeViewClassName",toppart_eh),
	class_Create("BotTreeViewClassName",botpart_eh),
	assert(tb_class),!.

PREDICATES
  procedure tb_set_top_part(WINDOW TopWin,WINDOW BotWin,UNSIGNED ItemId)
  tb_top_cb : TV_CALLBACK
  tb_bot_cb : TV_CALLBACK
CLAUSES
  tb_set_top_part(TopWin,BotWin,ItemId):-
	tv_get_item(BotWin,ItemId,Text,Flags,BitmapId),
	tv_Init(TopWin,[tvs_disabledragdrop],0,0,[tree(ItemId,Flags,BitmapId,Text,[])],tb_top_cb),!.

PREDICATES
  determ tb_check_place(INTEGER)
CLAUSES
  tb_check_place(tvht_onitemicon):-!.
  tb_check_place(tvht_onitemlabel):-!.

PREDICATES
  procedure tb_draw_push_button(WINDOW,RCT)
CLAUSES
  tb_draw_push_button(CtlWin,RCT):-
	RCT = rct(L,T,R0,B0),
	R = R0 - 1, B = B0 - 1,
	draw_Rect(CtlWin,RCT),
	L1 = L + 1, T1 = T + 1, R1 = R - 1, B1 = B - 1,
	win_SetPen(CtlWin,pen(1,ps_solid,color_Gray)),
	draw_PolyLine(CtlWin,[pnt(R1,T1),pnt(R1,B1),pnt(L,B1)]),
	win_SetPen(CtlWin,pen(1,ps_solid,color_LtGray)),
	draw_PolyLine(CtlWin,[pnt(L,B1),pnt(L,T),pnt(R,T)]),
	win_SetPen(CtlWin,pen(1,ps_solid,color_White)),
	B2 = B1 - 1,
	draw_PolyLine(CtlWin,[pnt(L1,B2),pnt(L1,T1),pnt(R1,T1)]),!.

PREDICATES
  procedure tb_draw_fore_button(WINDOW,RCT,INTEGER)
CLAUSES
  tb_draw_fore_button(CtlWin,rct(L,T,R,B),Disp):-
	Delta1 = (B - T) div 5, Delta2 = (R - L) div 5,
	wcc_min(Delta1,Delta2,Delta),
	X2 = (R + L) div 2 + Disp, X1 = X2 - Delta, X3 = X2 + Delta,
	Y1 = (B + T) div 2 - (Delta div 2) + Disp, Y2 = Y1 + Delta,
	draw_Polygon(CtlWin,[pnt(X1,Y1),pnt(X3,Y1),pnt(X2,Y2)]),!.
  tb_draw_fore_button(_,_,_):-!.

PREDICATES
  procedure tb_ownerdraw_DrawButton(OD_ITEMACTION,OD_ITEMSTATE,WINDOW CtlWin)
CLAUSES

  tb_ownerdraw_DrawButton(ACTIONLIST,STATELIST,CtlWin):- 
	ACTIONLIST = [odact_Select],
	STATELIST = [odstate_Focus,odstate_Selected],
	RCT = win_GetClientRect(CtlWin),
	win_SetPen(CtlWin,pen(1,ps_solid,color_Gray)),
	win_SetBrush(CtlWin,brush(pat_Solid,color_LtGray)),
	draw_Rect(CtlWin,RCT),
	win_SetPen(CtlWin,pen(1,ps_Solid,color_black)),
	win_SetBrush(CtlWin,brush(pat_Solid,color_black)),
	tb_draw_fore_button(CtlWin,RCT,1),!.
  tb_ownerdraw_DrawButton(ACTIONLIST,STATELIST,CtlWin):-
	ACTIONLIST = [odact_Select],
	STATELIST = [odstate_Focus],
	RCT = win_GetClientRect(CtlWin),
	win_SetPen(CtlWin,pen(1,ps_solid,color_Black)),
	win_SetBrush(CtlWin,brush(pat_Solid,color_LtGray)),
 	tb_draw_push_button(CtlWin,RCT),
	win_SetPen(CtlWin,pen(1,ps_Solid,color_black)),
	win_SetBrush(CtlWin,brush(pat_Solid,color_black)),
	tb_draw_fore_button(CtlWin,RCT,0),!.
  tb_ownerdraw_DrawButton(ACTIONLIST,[],CtlWin):-
	ACTIONLIST = [odact_DrawEntire],
	RCT = win_GetClientRect(CtlWin),
	win_SetPen(CtlWin,pen(1,ps_solid,color_Black)),
	win_SetBrush(CtlWin,brush(pat_Solid,color_LtGray)),
 	tb_draw_push_button(CtlWin,RCT),
	win_SetPen(CtlWin,pen(1,ps_Solid,color_black)),
	win_SetBrush(CtlWin,brush(pat_Solid,color_black)),
	tb_draw_fore_button(CtlWin,RCT,0),!.
  tb_ownerdraw_DrawButton(_,_,_).

/**GLOBAL PREDICATE*******************************************************
			     TB_ADD
 *************************************************************************/
  tb_add(TBWin,ItemId,ParentId,PreviosId,Text,StateList,BitmapId):-
	BotWin = win_GetCtlHandle(TBWin,2),
	tv_insert_item(BotWin,ItemId,ParentId,PreviosId,Text,StateList,BitmapId),!.

/**GLOBAL PREDICATE*******************************************************
			     TB_CLEAR
 *************************************************************************/
  tb_clear(TBWin):-
	TopWin = win_GetCtlHandle(TBWin,1),
	BotWin = win_GetCtlHandle(TBWin,2),
	tv_Init(TopWin,[tvs_disabledragdrop],0,0,[],tb_top_cb),
	tv_Init(BotWin,[tvs_disabledragdrop,tvs_hasbuttons,tvs_linesatroot,tvs_haslines],0,0,[],tb_bot_cb),!.

/**GLOBAL PREDICATE*******************************************************
			     TB_COUNT
 *************************************************************************/
  tb_count(TBWin,Count):-
	BotWin = win_GetCtlHandle(TBWin,2),
	tv_get_count(BotWin,Count),!.

/**GLOBAL PREDICATE*******************************************************
			     TB_DELETE
 *************************************************************************/
  tb_delete(TBWin,ItemId):-
	BotWin = win_GetCtlHandle(TBWin,2),
	tv_delete_item(BotWin,ItemId),!.

/**GLOBAL PREDICATE*******************************************************
			     TB_GETALL
 *************************************************************************/
  tb_getAll(TBWin,TreeList):-
	BotWin = win_GetCtlHandle(TBWin,2),
	tv_get_all(BotWin,TreeList),!.

/**GLOBAL PREDICATE*******************************************************
			     TB_GETITEM
 *************************************************************************/
  tb_GetItem(TBWin,ItemId,Text,StateList,BitmapId):-
	BotWin = win_GetCtlHandle(TBWin,2),
	tv_get_item(BotWin,ItemId,Text,StateList,BitmapId),!.

/**GLOBAL PREDICATE*******************************************************
			     TB_GETSEL
 *************************************************************************/
  tb_GetSel(TBWin,ItemId):-
	BotWin = win_GetCtlHandle(TBWin,2),
	tv_get_sel(BotWin,ItemId),!.

/**GLOBAL PREDICATE*******************************************************
			     TB_SELECT
 *************************************************************************/
  tb_select(TBWin,ItemId,Select):-
	BotWin = win_GetCtlHandle(TBWin,2),
	tv_select(BotWin,ItemId,Select),!.

/**GLOBAL PREDICATE*******************************************************
			     TB_INIT
 *************************************************************************/
PREDICATES
  toppart_eh : EHANDLER
  botpart_eh : EHANDLER

CLAUSES
  tb_Init(TBWin,TreeList,ItemId):-
	tb_class_create(),
	TBRect = win_GetClientRect(TBWin),
	TBRect = rct(LargeL,LargeT,LargeR,LargeB),
	ButtonHeight = vpi_GetAttrVal(attr_ctl_button_height),
	ButtonWidth = vpi_GetAttrVal(attr_ctl_vert_sbar_width),
	SmallL = LargeL, SmallT = LargeT, SmallR = LargeR,
	SmallB = LargeT + ButtonHeight + 4,
	TopL = LargeL + 2,
	TopT = LargeT + 2,
	TopR = LargeR - 3 - ButtonWidth,
	TopB = SmallB - 2,
	ButL = TopR,
	ButT = TopT,
	ButR = LargeR - 2,
	ButB = TopB,
	BotL = LargeL + 1,
	BotT = SmallB + 1,
	BotR = LargeR - 1,
	BotB = LargeB - 1,
	ParentWin = win_GetParent(TBWin),
	LargeList = win_MapPoints(TBWin,ParentWin,[pnt(LargeL,LargeT),pnt(LargeR,LargeB)]),
	LargeList = [pnt(LL,TL),pnt(RL,BL)],
	LargeRct = rct(LL,TL,RL,BL),
	SmallList = win_MapPoints(TBWin,ParentWin,[pnt(SmallL,SmallT),pnt(SmallR,SmallB)]),
	SmallList = [pnt(LS,TS),pnt(RS,BS)],
	SmallRct = rct(LS,TS,RS,BS),
	assert(tb_info(TBWin,TreeList,ItemId,LargeRct,SmallRct,b_false)),
	win_CreateDynControl([customctl(wdef(wc_Custom,rct(TopL,TopT,TopR,TopB),"TopPart",u_Pixels),"TopTreeViewClassName",1,[])],TBWin),
	win_CreateDynControl([customctl(wdef(wc_Custom,rct(BotL,BotT,BotR,BotB),"BotPart",u_Pixels),"BotTreeViewClassName",2,[])],TBWin),
	win_CreateDynControl([ctl(wdef(wc_PushButton,rct(ButL,ButT,ButR,ButB),"BuPart",u_Pixels),3,[ctl_OwnerDraw,ctl_AlignCenter])],TBWin),
	win_Move(TBWin,SmallRct),!.
  tb_Init(_,_,_).

PREDICATES
  procedure tb_send_event(WINDOW TBWin,CONTROL_INFO)
CLAUSES
  tb_send_event(TBWin,Info):-
	ParentWin = win_GetParent(TBWin),
	TBId = win_GetCtlId(TBWin),
	win_SendEvent(ParentWin,e_Control(TBId,wc_Custom,TBWin,Info)),!.

/*************************************************************************
			     EVENT HANDLER
 *************************************************************************/
  tb_HandleEvent(TBWin,e_Destroy):-
	retract(tb_info(TBWin,_,_,_,_,_)),!.
  tb_HandleEvent(_,e_EraseBackground()):-!.
  tb_HandleEvent(TBWin,e_Control(3,_,_,_)):-
	retract(tb_info(TBWin,TreeList,ItemId,LargeRect,SmallRect,b_false)),
	assert(tb_info(TBWin,TreeList,ItemId,LargeRect,SmallRect,b_true)),
	win_Move(TBWin,LargeRect),
	BotWin = win_GetCtlHandle(TBWin,2),
	win_SetFocus(BotWin),
	tb_send_event(TBWin,dropdown()),!.
  tb_HandleEvent(TBWin,e_Control(3,_,_,_)):-
	retract(tb_info(TBWin,TreeList,ItemId,LargeRect,SmallRect,b_true)),
	assert(tb_info(TBWin,TreeList,ItemId,LargeRect,SmallRect,b_false)),
	win_Move(TBWin,SmallRect),
	TopWin = win_GetCtlHandle(TBWin,1),
	win_SetFocus(TopWin),
	tb_send_event(TBWin,closeup()),!.
  tb_HandleEvent(_,e_OwnerDraw(od_Button,3,_,ACTIONLIST,STATELIST,CtlWin,_,_)):-
	tb_ownerdraw_DrawButton(ACTIONLIST,STATELIST,CtlWin),!.

  tb_HandleEvent(TBWin,e_Update(_)):-
	Rect = win_GetClientRect(TBWin),
	Rect = rct(L,T,R0,B0),
	TopPartHeight = vpi_GetAttrVal(attr_ctl_button_height),
	R = R0 - 1,
	B = T + TopPartHeight + 3,
	L1 = L + 1, T1 = T + 1, R1 = R - 1, B1 = B - 1,
	win_SetPen(TBWin,pen(1,ps_Solid,color_Gray)),
	draw_Line(TBWin,pnt(L,B),pnt(L,T)),
	draw_Line(TBWin,pnt(L,T),pnt(R,T)),
	win_SetPen(TBWin,pen(1,ps_Solid,color_White)),
	draw_Line(TBWin,pnt(L,B),pnt(R0,B)),
	draw_Line(TBWin,pnt(R,T),pnt(R,B)),
	win_SetPen(TBWin,pen(1,ps_Solid,color_Black)),
	draw_Line(TBWin,pnt(L1,B1),pnt(L1,T1)),
	draw_Line(TBWin,pnt(L1,T1),pnt(R1,T1)),
	win_SetPen(TBWin,pen(1,ps_Solid,color_LtGray)),
	draw_Line(TBWin,pnt(L1,B1),pnt(R,B1)),
	draw_Line(TBWin,pnt(R1,T1),pnt(R1,B1)),
	tb_info(TBWin,_,_,_,_,b_true),
	T4 = B + 1,
	win_SetPen(TBWin,pen(1,ps_Solid,color_Black)),
	win_SetBrush(TBWin,brush(pat_Hollow,color_Black)),
	draw_Rect(TBWin,rct(L,T4,R0,B0)),!.

  toppart_eh(TopWin,e_Create(_),0):-
	TBWin = win_GetParent(TopWin),
	tb_info(TBWin,TreeList,ItemId,_,_,_),
	TreeList = [tree(ItemId,Flags,BitmapId,Text,_)|_],
	tv_Init(TopWin,[tvs_disabledragdrop],0,0,[tree(ItemId,Flags,BitmapId,Text,[])],tb_top_cb),!.
  toppart_eh(TopWin,Event,Answer):-
	Answer = tv_HandleEvent(TopWin,Event).

  tb_top_cb(TopWin,click(_)):-
	TBWin = win_GetParent(TopWin),
	retract(tb_info(TBWin,TreeList,ItemId,LargeRect,SmallRect,b_false)),
	assert(tb_info(TBWin,TreeList,ItemId,LargeRect,SmallRect,b_true)),
	win_Move(TBWin,LargeRect),
	BotWin = win_GetCtlHandle(TBWin,2),
	win_SetFocus(BotWin),
	tb_send_event(TBWin,dropdown()),!.
  tb_top_cb(TopWin,click(_)):-
	TBWin = win_GetParent(TopWin),
	retract(tb_info(TBWin,TreeList,ItemId,LargeRect,SmallRect,b_true)),
	assert(tb_info(TBWin,TreeList,ItemId,LargeRect,SmallRect,b_false)),
	win_Move(TBWin,SmallRect),
	tb_send_event(TBWin,closeup()),!.

  botpart_eh(BotWin,e_Create(_),0):-
	TBWin = win_GetParent(BotWin),
	tb_info(TBWin,TreeList,ItemId,_,_,_),
	tv_Init(BotWin,[tvs_disabledragdrop,tvs_hasbuttons,tvs_linesatroot,tvs_haslines],0,0,TreeList,tb_bot_cb),
	tv_ensure_visible(BotWin,ItemId),
	tv_select(BotWin,ItemId,b_true),!.
  botpart_eh(BotWin,Event,Answer):-
	Answer = tv_HandleEvent(BotWin,Event).

  tb_bot_cb(BotWin,click(pnt(X,Y))):-
	tv_get_pos(BotWin,X,Y,ItemId,Place),
	tb_check_place(Place),
	tv_select(BotWin,ItemId,b_true),
	TBWin = win_GetParent(BotWin),
	TBRect = win_GetClientRect(TBWin),
	TBRect = rct(L,T,R,B),
	ParentWin = win_GetParent(TBWin),
	LargeList = win_MapPoints(TBWin,ParentWin,[pnt(L,T),pnt(R,B)]),
	LargeList = [pnt(LL,TL),pnt(RL,BL)],
	LargeRect = rct(LL,TL,RL,BL),
	retract(tb_info(TBWin,TreeList,_,LargeRect,SmallRect,_)),
	assert(tb_info(TBWin,TreeList,ItemId,LargeRect,SmallRect,b_false)),
	win_Move(TBWin,SmallRect),
	TopWin = win_GetCtlHandle(TBWin,1),
	tb_set_top_part(TopWin,BotWin,ItemId),
	win_SetFocus(TopWin),
	tb_send_event(TBWin,selchanged()),
	tb_send_event(TBWin,closeup()),
	!,fail.

enddef /*** use_winctrl_treebut ***/
