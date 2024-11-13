/******************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:	Label Expert
 FileName:	LAYOUTED.PRO
 Purpose:	Layout Editor
 Written by:	Sergey Alexeev
 Build:		008.981112
 Comments:
******************************************************************************/
domains
  LE_ACTION = create(WINDOW,INTEGER,RCT,LE_FIELD_ORIENTATION,LE_FIELD_TYPE);
	      delete(WINDOW,INTEGER,RCT,LE_FIELD_ORIENTATION,LE_FIELD_TYPE);
	      move(WINDOW,ILIST,LAYOUT_RCTLIST,WINDOW,ILIST,LAYOUT_RCTLIST);
	      copy(WINDOW,ILIST,LAYOUT_RCTLIST,WINDOW,ILIST,LAYOUT_RCTLIST);
	      size(WINDOW,ILIST,RCT,RCT);
	      select(WINDOW,ILIST);
	      unselect(WINDOW,ILIST);
	      init(WINDOW,INTEGER,LE_FIELD_ORIENTATION,LE_FIELD_TYPE,LE_FIELD_ORIENTATION,LE_FIELD_TYPE);
	      direction(WINDOW,ILIST,ILIST)

  LE_ACTIONLIST = LE_ACTION*
  PROPERTY_LIST2D = PROPERTY_LIST*
constants
  le_max_stack = 100

  le_edit_cut		= 1
  le_edit_copy		= 2
  le_edit_paste		= 3
  le_edit_delete	= 4
  le_edit_front		= 5
  le_edit_back		= 6
  le_edit_type		= 7
  le_screen_update	= 8
  le_cancel		= 9
  le_propertyes		= 10
  le_alignment		= 11
  le_palette_id		= 12
% Property Id Constants
  le_Grid_HorStep	= 1
  le_Grid_VerStep	= 2
  le_Grid_Visible	= 3
  le_Grid_Color		= 4
  le_Grid_Snap		= 5
  le_Rect_Left		= 6
  le_Rect_Top		= 7
  le_Rect_Width		= 8
  le_Rect_Heght		= 9
  le_Orientation_id	= 10
  le_Pen_Width		= 11
  le_Pen_Style		= 12
  le_Pen_Color		= 13
  le_Brush_Style	= 14
  le_Brush_Color	= 15
%  le_Line_Width	= 16	Changed on Pen Width
%  le_Line_Style	= 17	Changed on Pen Style
%  le_Line_Color	= 18	Changed on Pen Color
  le_Bitmap_FileName	= 19
  le_Bitmap_Stretch	= 20
  le_Font_Name		= 21
  le_Text_Counter_Color	= 22
  le_Text_Wrap		= 23
  le_Barcode		= 24
  le_Counter_Start	= 25
  le_Counter_End	= 26
  le_Counter_Step	= 27
  le_Counter_Digit_Number	= 28
  le_Text_String	= 29
  le_ASCII_FileName	= 30
  le_ASCII_From		= 31
  le_ASCII_To		= 32
  le_ODBC_BaseName	= 33
  le_ODBC_TableName	= 34
  le_ODBC_Column	= 35
  le_ODBC_UserName	= 36
  le_ODBC_Password	= 37
  le_DBASE_FileName	= 38
  le_DBASE_Column	= 39
  le_TEXT_STYLE		= 40
  le_DATE_Format_string	= 41
  le_DATE_Shift		= 42
  le_PAGE_NAME		= 43
  le_Text_alignment	= 44
  le_PAGE_SIZE		= 45
  le_PAGE_NUMB		= 46
  le_PAGE_ORIENT	= 47
  le_PAGE_FONT		= 48

  le_to_view		= 1

  le_lt	= 1
  le_rt	= 2
  le_lb	= 3
  le_rb	= 4
  le_l	= 5
  le_t	= 6
  le_r	= 7
  le_b	= 8

database - le_info_db
  le_info(WINDOW ParentWin,WINDOW LEWin,STRING PageName,REAL LabelWidth, REAL LabelHeight,
	UNSIGNED NoHor,UNSIGNED NoVert,BOOLEAN Page_Roll,BOOLEAN Landscape,INTEGER PixInMM,
	INTEGER ScaleThick,COLOR BgColor,LE_CALLBACK)
  le_scale(WINDOW LEWin,WINDOW HS_Win,WINDOW VS_Win)
  le_layout(WINDOW LEWin,WINDOW LO1_Win,WINDOW LO_Win,INTEGER L,INTEGER T)
  le_layout_style(PEN,BRUSH,COLOR TextColor,BOOLEAN PictStretch,BOOLEAN WrapText)
  le_label_style(WINDOW LEWin,FONT,STRING FontName)
  le_vscroll_info(WINDOW LEWin,BOOLEAN Vert,WINDOW Vert,INTEGER CurVPos,INTEGER MaxVPos)
  le_hscroll_info(WINDOW LEWin,BOOLEAN Hor,WINDOW Hor,INTEGER CurHPos,INTEGER MaxHPos)
  le_focus_win(WINDOW LEWin)
  le_grid_set(WINDOW LEWin,INTEGER GridHorStep,INTEGER GridVerStep,LAYOUT_GRID Visible,COLOR,BOOLEAN SnapToGrid)
  le_layout_size(WINDOW LEWin,ALIGN_PUSH)
  le_base_answer(STRING)
  le_font(FONT)
  le_odbc
  le_callback(LE_CALLBACK)

  le_field_info(WINDOW LEWin,INTEGER LayoutId,LE_FIELD_ORIENTATION,LE_FIELD_TYPE)

  le_not_stack()
  le_stack(UNSIGNED Count)
  le_undo_stack(LE_ACTIONLIST)
  le_redo_stack(LE_ACTIONLIST)
  le_edit_info(WINDOW LEWin,INTEGER Id,WINDOW EditWin)

  determ le_move_right(INTEGER X, INTEGER Y)
  le_property_timer(WINDOW LEWin,LONG PropTimerId)

  le_property(WINDOW Win)
  le_palette(WINDOW Win)
  le_align(WINDOW Win)

  le_property_stored(WINDOW PRWin)
  le_palette_stored(WINDOW PLWin)
  le_align_stored(WINDOW ALWin)
  le_property_stored1
  le_palette_stored1
  le_align_stored1

  determ dyntext_fact(SLIST)
  determ prop_cursor(CURSOR,INTEGER Corner,BOOLEAN ButtonPressed)
  determ le_prop_title_width(INTEGER LeftTitle,INTEGER Width,INTEGER Height)

predicates
  le_win_eh : EHANDLER
  le_win_eh1 : EHANDLER
  layout_cb : LAYOUT_CALLBACK
  le_calc_scale_rect(RCT LEWinInMM,INTEGER PixInMM,INTEGER ScaleThick,
	RCT LEWinInPix,RCT HorScale,RCT VerScale)
  le_calc_layout_rect(LAYOUT_PAGE InPage,INTEGER PixInMM,INTEGER ScaleThick,
	LAYOUT_PAGE OutPage,RCT PageRect,COLOR BgColor)
  le_create_scroll(WINDOW LEWin)
  le_prop_status()
  le_prop_status(WINDOW LEWin)
clauses
/**global PREDICATE*******************************************************
			     LE_CREATE
*************************************************************************/
predicates
  le_grid(WINDOW LEWin)
  le_assert_default()
  le_maximized(WINDOW,BOOLEAN)
  le_tb_callback : TOOLBAR_ACTION_FUNC
clauses
  le_create(ParentWin,Maximized,PageName,LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,Landscape,Font,Title,
	PixInMM,Rect,ScaleThick,Page,CallBackFunc,LEWin):-
	retractall(le_font(_)),
	assert(le_font(Font)),
	le_calc_scale_rect(Rect,PixInMM,ScaleThick,Rect1,HRect,VRect),
	LEWin = win_Create(w_TopLevel,Rect1,Title,no_menu,ParentWin,[wsf_SizeBorder,wsf_TitleBar,wsf_Close,
		wsf_ClipChildren,wsf_ClipSiblings,wsf_Maximize,wsf_Minimize],le_win_eh,0),
	retractall(le_focus_win(_)),
	assert(le_focus_win(LEWin)),
	timer_Set(LEWin,60000),
	HS_Win = scale_CreateHor(LEWin,HRect,PixInMM),
	VS_Win = scale_CreateVer(LEWin,VRect,PixInMM),
	assert(le_scale(LEWin,HS_Win,VS_Win)),
	le_calc_layout_rect(Page,PixInMM,ScaleThick,Page1,rct(L,T,R,B),BgColor),
	assert(le_info(ParentWin,LEWin,PageName,LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,Landscape,PixInMM,ScaleThick,BgColor,CallBackFunc)),
	scale_WorkSpace(HS_Win,L,R),
	scale_WorkSpace(VS_Win,T,B),
	Rect1 = rct(LM,TM,RM,BM),
	LOR = RM - LM, LOB = BM - TM,
	LO1_Win = win_Create(w_Child,rct(ScaleThick,ScaleThick,LOR,LOB),"",no_menu,LEWin,
		[wsf_ClipChildren,wsf_ClipSiblings],
		le_win_eh1,0),
	LO_Win = layout_CreatePage(LO1_Win,Page1,layout_cb,label_msg227,label_msg228,label_msg181),
	toolbar_create(tb_inside(pnt(0,0)),0xC0C0C0,LEWin,[tb_ctrl(le_to_view,pushb,idb_view_up,
		idb_view_dn,idb_view_dn,"",b_true,b_true)],le_tb_callback),
	L1 = L - ScaleThick, T1 = T - ScaleThick,
	assert(le_layout(LEWin,LO1_Win,LO_Win,L1,T1)),
	assert(le_grid_set(LEWin,5,5,invisible,color_Black,b_false)),
	le_create_scroll(LEWin),
	le_grid(LEWin),
	win_SetFocus(LEWin),
	le_maximized(LEWin,Maximized),!.

predicates
  le_check_callback(WINDOW Win,LE_MESSAGE)
clauses
  le_tb_callback(LEWin,le_to_view,ctrl_value(b_true,b_true)):-
	le_check_callback(LEWin,user_action(go_to_preview)),!.

  le_maximized(LEWIn,b_true):-
	win_PostEvent(LEWin,e_Menu(0,0)),!.
  le_maximized(_,_).

  le_assert_default():-
	le_layout_style(_,_,_,_,_),!.
  le_assert_default():-
	assert(le_layout_style(pen(1,ps_Solid,color_Black),
		brush(pat_Solid,color_White),color_Black,b_true,b_true)),!.
/**global PREDICATE*******************************************************
			     LE_INIT
*************************************************************************/
  le_init(LEWin,PageName,LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,Landscape,PixInMM,ScaleThick,Page,Stretch):-
	retract(le_info(ParentWin,LEWin,_,_,_,_,_,_,_,_,_,BgColor,CallBackFunc)),
	assert(le_info(ParentWin,LEWin,PageName,LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,Landscape,
	PixInMM,ScaleThick,BgColor,CallBackFunc)),
	Rect = win_GetOuterRect(LEWin),
	Rect = rct(L01,T01,R01,B01),
	L0 = L01 div PixInMM, T0 = T01 div PixInMM,
	R0 = R01 div PixInMM, B0 = B01 div PixInMM,
	le_calc_scale_rect(rct(L0,T0,R0,B0),PixInMM,ScaleThick,Rect1,HRect,VRect),
	retract(le_scale(LEWin,HS_Win0,VS_Win0)),
	win_Destroy(HS_Win0),
	win_Destroy(VS_Win0),
	HS_Win = scale_CreateHor(LEWin,HRect,PixInMM),
	VS_Win = scale_CreateVer(LEWin,VRect,PixInMM),
	assert(le_scale(LEWin,HS_Win,VS_Win)),
	le_calc_layout_rect(Page,PixInMM,ScaleThick,Page1,rct(L,T,R,B),_),
	scale_WorkSpace(HS_Win,L,R),
	scale_WorkSpace(VS_Win,T,B),
	Rect1 = rct(LM,TM,RM,BM),
	LOR = RM - LM, LOB = BM - TM,
	L1 = L - ScaleThick, T1 = T - ScaleThick,
	retract(le_layout(LEWin,LO1_Win,LO_Win,_,_)),
	assert(le_layout(LEWin,LO1_Win,LO_Win,L1,T1)),
	win_Move(LO1_Win,rct(ScaleThick,ScaleThick,LOR,LOB)),
	layout_InitPage(LO_Win,Page1,Stretch),
	le_create_scroll(LEWin),
	le_grid(LEWin),!.

/**global PREDICATE*******************************************************
			     LE_INVALIDATE
*************************************************************************/
  le_Invalidate(LEWin):-
	le_scale(LEWin,HS_Win,VS_Win),
	le_layout(LEWin,LO1_Win,LO_Win,_,_),
	win_Invalidate(HS_Win),
	win_Invalidate(VS_Win),
	win_Invalidate(LO1_Win),
	win_Invalidate(LO_Win),!.

/**global PREDICATE*******************************************************
			     LE_FIELDS
*************************************************************************/
predicates
  le_multi_init(WINDOW LEWin,WINDOW LOWin,INTEGER PixInMM,LE_FIELD_INFORMATIONLIST)
  le_multi_get(WINDOW LEWin,WINDOW LOWin,INTEGER PixInMM,ILIST IdList,LE_FIELD_INFORMATIONLIST,LE_FIELD_INFORMATIONLIST)
  le_convert_type(LE_FIELD_TYPE,LAYOUT_FIELD_TYPE)
  le_reverse(PROPERTY_LIST,PROPERTY_LIST,PROPERTY_LIST)
  le_reverse(ILIST,ILIST,ILIST)
  le_reverse(LAYOUT_RCTLIST,LAYOUT_RCTLIST,LAYOUT_RCTLIST)
clauses
  le_fields(LEWin,Information,LabelFont,LabelFontName):-
	bound(Information), bound(LabelFont), bound(LabelFontName),
	le_layout(LEWin,_,LOWin,_,_),
	le_info(_,LEWin,_,_,_,_,_,_,_,PixInMM,_,_,_),
	le_multi_init(LEWin,LOWin,PixInMM,Information),
	retractall(le_label_style(LEWin,_,_)),
	assert(le_label_style(LEWin,LabelFont,LabelFontName)),!.
  le_fields(LEWin,Information,LabelFont,LabelFontName):-
	free(Information), free(LabelFont), free(LabelFontName),
	le_layout(LEWin,_,LOWin,_,_),
	layout_fields(LOWin,IdList),
	le_reverse(IdList,[],IdList1),
	le_info(_,LEWin,_,_,_,_,_,_,_,PixInMM,_,_,_),
	le_multi_get(LEWin,LOWin,PixInMM,IdList1,[],Information1),
	Information = Information1,
	le_label_style(LEWin,LabelFont,LabelFontName),!.

  le_multi_init(_,_,_,[]):-!.
  le_multi_init(LEWin,LOWin,PixInMM,[info(le_rct(L,T,R,B),Orientation,Type)|Rest]):-
	L1 = L * PixInMM, T1 = T * PixInMM, R1 = R * PixInMM, B1 = B * PixInMM,
	le_convert_type(Type,Type1),
	layout_Create(LOWin,rct(L1,T1,R1,B1),Type1,Id),
	assert(le_field_info(LEWin,Id,Orientation,Type)),!,
	le_multi_init(LEWin,LOWin,PixInMM,Rest).

  le_multi_get(_,_,_,[],Information,Information):-!.
  le_multi_get(LEWin,LOWin,PixInMM,[Id|Rest],Info,Information):-
	layout_rectangle(LOWin,[Id],Rect),
	Rect = rct(L,T,R,B),
	L1 = L / PixInMM, T1 = T / PixInMM, R1 = R / PixInMM, B1 = B / PixInMM,
	le_field_info(LEWin,Id,Orientation,Type),!,
	le_multi_get(LEWin,LOWin,PixInMM,Rest,[info(le_rct(L1,T1,R1,B1),Orientation,Type)|Info],Information).

  le_calc_scale_rect(rct(L,T,R,B),PixInMM,ScaleThick,rct(L1,T1,R1,B1),rct(HL,HT,HR,HB),rct(VL,VT,VR,VB)):-
	L1 = L * PixInMM, T1 = T * PixInMM, R1 = L + (R - L) * PixInMM, B1 = T + (B - T) * PixInMM,
	HL = ScaleThick, HT = 0, HR = R1, HB = ScaleThick,
	VL = 0, VT = ScaleThick, VR = ScaleThick, VB = B1,!.

predicates
  le_calc_rects(RCT,INTEGER PixInMM,INTEGER ScaleThick,RCT,RCT)
clauses
  le_calc_rects(rct(L,T,R,B),PixInMM,ScaleThick,rct(L1,T1,R1,B1),rct(L2,T2,R2,B2)):-
	L1 = L * PixInMM + 3,
	T1 = T * PixInMM + 3,
	R1 = L1 + (R - L) * PixInMM,
	B1 = T1 + (B - T) * PixInMM,
	L2 = L1 + ScaleThick, T2 = T1 + ScaleThick,
	R2 = R1 + ScaleThick, B2 = B1 + ScaleThick,!.

  le_calc_layout_rect(roundrect(Rect,Brush,CornerRad,BgColor,Shadow),
	PixInMM,ScaleThick,roundrect(Rect1,Brush,CornerRad1,BgColor,Shadow),
	Rect2,BgColor):-
	le_calc_rects(Rect,PixInMM,ScaleThick,Rect1,Rect2),
	CornerRad1 = CornerRad * PixInMM,!.
  le_calc_layout_rect(rectangle(Rect,Brush,BgColor,Shadow),
	PixInMM,ScaleThick,rectangle(Rect1,Brush,BgColor,Shadow),
	Rect2,color_LtGray):-
	le_calc_rects(Rect,PixInMM,ScaleThick,Rect1,Rect2),!.
  le_calc_layout_rect(ellipse(Rect,Brush,BgColor,Shadow),
	PixInMM,ScaleThick,ellipse(Rect1,Brush,BgColor,Shadow),
	Rect2,BgColor):-
	le_calc_rects(Rect,PixInMM,ScaleThick,Rect1,Rect2),!.

predicates
  le_property_set()
  le_align_set()
  le_palette_set()
clauses
  le_property_set():-
	le_property_stored(_),
	le_property_on(),!.
  le_property_set():-
	le_property(_),
	le_property_off(),!.
  le_property_set():-
	le_property_create(),!.

  le_align_set():-
	le_align_stored(_),
	le_align_on(),!.
  le_align_set():-
	le_align(_),
	le_align_off(),!.
  le_align_set():-
	le_align_create(),!.

  le_palette_set():-
	le_palette_stored(_),
	le_palette_on(),!.
  le_palette_set():-
	le_palette(_),
	le_palette_off(),!.
  le_palette_set():-
	le_palette_create(),!.

predicates
  le_vscroll_handler(WINDOW GridWin,SCROLLCODE Control,INTEGER Pos)
  le_hscroll_handler(WINDOW GridWin,SCROLLCODE Control,INTEGER Pos)
  le_check_callback1(WINDOW Win,LE_MESSAGE)

  le_cut(WINDOW LEWin,ILIST IdList)
  le_copy(WINDOW LEWin,ILIST IdList)
  le_paste(WINDOW LEWin)
  le_undo()
  le_redo()
  le_date_redraw(WINDOW LEWin)
  le_popup_menu(WINDOW LEWin,PNT)
  le_edit(WINDOW Win,INTEGER Id)
  le_edit(WINDOW Win,INTEGER Id,CHAR)
  le_retract_default()
clauses
/*************************************************************************
			     LE EVENT HANDLER
*************************************************************************/
  le_win_eh1(Win,Event,0):-
	not(le_check_callback(Win,event(Event))),!.

  le_win_eh1(_,e_EraseBackground(),0):-!.

  le_win_eh1(Win,e_GetFocus,0):-
	le_layout(LEWin,Win,_,_,_),
	win_SendEvent(LEWin,e_GetFocus),!.

  le_win_eh1(LO1_Win,e_Update(Rect),0):-
	le_layout(LEWin,LO1_Win,_,_,_),
	le_info(_,LEWin,_,_,_,_,_,_,_,_,_,BgColor,_),
	win_Clear(LO1_Win,Rect,BgColor),!.

  le_win_eh(Win,Event,0):-
	not(le_check_callback(Win,event(Event))),!.

  le_win_eh(LEWin,e_GetFocus,0):-
	retractall(le_focus_win(_)),
	assert(le_focus_win(LEWin)),
	retract(le_property_timer(LEWin,PropTimerIdOld)),
	timer_Kill(PropTimerIdOld),
	PropTimerId = timer_Set(LEWin,500),
	assert(le_property_timer(LEWin,PropTimerId)),!.
  le_win_eh(LEWin,e_GetFocus,0):-
	PropTimerId = timer_Set(LEWin,500),
	assert(le_property_timer(LEWin,PropTimerId)),!.

  le_win_eh(LEWin,e_Timer(PropTimerId),0):-
	retract(le_property_timer(LEWin,PropTimerId)),
	timer_Kill(PropTimerId),
	le_prop_status(),!.
  le_win_eh(LEWin,e_Timer(_),0):-
	le_date_redraw(LEWin),!.

  le_win_eh(LEWin,e_Destroy,0):-
	retract(le_info(_,LEWin,_,_,_,_,_,_,_,_,_,_,_)),
	retract(le_scale(LEWin,_,_)),
	retract(le_layout(LEWin,_,_,_,_)),
	retractall(le_vscroll_info(LEWin,_,_,_,_)),
	retractall(le_hscroll_info(LEWin,_,_,_,_)),
	retractall(le_field_info(LEWin,_,_,_)),!.

  le_win_eh(_,e_EraseBackground(),0):-!.

  le_win_eh(LEWin,e_Update(Rect),0):-
	le_info(_,LEWin,_,_,_,_,_,_,_,_,_,BgColor,_),
	win_Clear(LEWin,Rect,BgColor),!.

  le_win_eh(LEWin,e_Size(Width,Height),0):-
	le_info(_,LEWin,_,_,_,_,_,_,_,PixInMM,ScaleThick,_,_),
	le_calc_scale_rect(rct(0,0,Width,Height),PixInMM,ScaleThick,_,HRect,VRect),
	le_scale(LEWin,HS_Win,VS_Win),
	scale_Resize(HS_Win,HRect),
	scale_Resize(VS_Win,VRect),
	le_layout(LEWin,LO1_Win,_,_,_),
	win_Move(LO1_Win,rct(ScaleThick,ScaleThick,Width,Height)),
	le_create_scroll(LEWin),!.

  le_win_eh(LEWin,e_Control(_,wc_VScroll,_,scroll(Control,Pos)),0):-
	le_vscroll_handler(LEWin,Control,Pos),!.
  le_win_eh(LEWin,e_Control(_,wc_HScroll,_,scroll(Control,Pos)),0):-
	le_hscroll_handler(LEWin,Control,Pos),!.

  le_win_eh(LEWin,e_Menu(0,_ShiftCtlAlt),0):-
	win_SetState(LEWin,[wsf_Maximized]),!.
  le_win_eh(LEWin,e_Menu(le_edit_cut,_ShiftCtlAlt),0):-
	le_win_eh(LEWin,e_Char(24,c_Control)),!.
  le_win_eh(LEWin,e_Menu(le_edit_copy,_ShiftCtlAlt),0):-
	le_win_eh(LEWin,e_Char(3,c_Control)),!.
  le_win_eh(LEWin,e_Menu(le_edit_paste,_ShiftCtlAlt),0):-
	le_win_eh(LEWin,e_Char(22,c_Control)),!.
  le_win_eh(LEWin,e_Menu(le_edit_delete,_ShiftCtlAlt),0):-
	le_win_eh(LEWin,e_Char(k_del,c_Nothing)),!.
  le_win_eh(LEWin,e_Menu(le_edit_front,_ShiftCtlAlt),0):-
	le_BringToFront(LEWin),!.
  le_win_eh(LEWin,e_Menu(le_edit_back,_ShiftCtlAlt),0):-
	le_SendToBack(LEWin),!.
  le_win_eh(LEWin,e_Menu(le_edit_type,_ShiftCtlAlt),0):-
	le_check_callback1(LEWin,user_action(page_change)),!.
  le_win_eh(_,e_Menu(le_propertyes,_ShiftCtlAlt),0):-
	le_property_set(),!.
  le_win_eh(_,e_Menu(le_alignment,_ShiftCtlAlt),0):-
	le_align_set(),!.
  le_win_eh(_,e_Menu(le_palette_id,_ShiftCtlAlt),0):-
	le_palette_set(),!.
  le_win_eh(LEWin,e_Menu(le_screen_update,_ShiftCtlAlt),0):-
	le_layout(LEWin,_,LOWin,_,_),
	win_Invalidate(LOWin),!.

  le_win_eh(LEWin,e_Char(24,c_Control),0):-
	le_layout(LEWin,_,LOWin,_,_),
	layout_select(LOWin,IdList),
	le_cut(LEWin,IdList),!.
  le_win_eh(LEWin,e_Char(3,c_Control),0):-
	le_layout(LEWin,_,LOWin,_,_),
	layout_select(LOWin,IdList),
	le_copy(LEWin,IdList),!.
  le_win_eh(LEWin,e_Char(22,c_Control),0):-
	le_paste(LEWin),!.
  le_win_eh(LEWin,e_Char(k_del,c_Nothing),0):-
	le_layout(LEWin,_,LOWin,_,_),
	layout_select(LOWin,IdList),
	layout_delete(LOWin,IdList),!.

  le_win_eh(_,e_Char(26,c_Control),0):-
	le_undo(),!.

  le_win_eh(_,e_Char(26,c_ShiftCtl),0):-
	le_redo(),!.

  le_win_eh(LEWin,e_Char(k_right,c_Nothing),0):-
	le_layout(LEWin,_,LOWin,_,_),
	layout_select(LOWin,IdList),
	layout_grid(LOWin,GridHorStep,_,_,_),
	layout_move(LOWin,IdList,GridHorStep,0),!.
  le_win_eh(LEWin,e_Char(k_left,c_Nothing),0):-
	le_layout(LEWin,_,LOWin,_,_),
	layout_select(LOWin,IdList),
	layout_grid(LOWin,GridHorStep,_,_,_),
	Step = -GridHorStep,
	layout_move(LOWin,IdList,Step,0),!.
  le_win_eh(LEWin,e_Char(k_down,c_Nothing),0):-
	le_layout(LEWin,_,LOWin,_,_),
	layout_select(LOWin,IdList),
	layout_grid(LOWin,_,GridVerStep,_,_),
	layout_move(LOWin,IdList,0,GridVerStep),!.
  le_win_eh(LEWin,e_Char(k_up,c_Nothing),0):-
	le_layout(LEWin,_,LOWin,_,_),
	layout_select(LOWin,IdList),
	layout_grid(LOWin,_,GridVerStep,_,_),
	Step = -GridVerStep,
	layout_move(LOWin,IdList,0,Step),!.
  le_win_eh(LEWin,e_Char(314,c_Control),0):-
	le_layout(LEWin,_,LOWin,_,_),
	layout_select(LOWin,IdList),
	layout_move(LOWin,IdList,1,0),!.
  le_win_eh(LEWin,e_Char(313,c_Control),0):-
	le_layout(LEWin,_,LOWin,_,_),
	layout_select(LOWin,IdList),
	layout_move(LOWin,IdList,-1,0),!.
  le_win_eh(LEWin,e_Char(k_down,c_Control),0):-
	le_layout(LEWin,_,LOWin,_,_),
	layout_select(LOWin,IdList),
	layout_move(LOWin,IdList,0,1),!.
  le_win_eh(LEWin,e_Char(k_up,c_Control),0):-
	le_layout(LEWin,_,LOWin,_,_),
	layout_select(LOWin,IdList),
	layout_move(LOWin,IdList,0,-1),!.
  le_win_eh(LEWin,e_Char(Char,_),0):-
	le_layout(LEWin,_,LOWin,_,_),
	layout_select(LOWin,IdList),
	IdList = [Id|[]],
	le_edit(LEWin,Id,Char),!.

  le_grid(LEWin):-
	le_layout(LEWin,_,LOWin,_,_),
	le_info(_,LEWin,_,_,_,_,_,_,_,PixInMM,_,_,_),
	le_grid_set(LEWin,GridHorStep,GridVerStep,Visible,_,SnapToGrid),
	GridHorStep2 = GridHorStep * PixInMM, GridHorStep1 = val(integer,GridHorStep2),
	GridVerStep2 = GridVerStep * PixInMM, GridVerStep1 = val(integer,GridVerStep2),
	layout_grid(LOWin,GridHorStep1,GridVerStep1,Visible,SnapToGrid),!.

  le_retract_default():-
	le_layout(_,_,_,_,_),!.
  le_retract_default():-
	retract(le_layout_style(_,_,_,_,_)),!.

predicates
  le_paste_status()
clauses
  le_paste_status():-
	cb_StringAvailable(),
	StringData = cb_GetString(),
	searchstring(StringData,"Layout:",_),!.

predicates
  le_property_status(INTEGER)
clauses
  le_property_status(mis_None):-
	le_property_stored(_),!.
  le_property_status(mis_Checked):-
	le_property(_),!.
  le_property_status(mis_None).

predicates
  le_align_status(INTEGER)
clauses
  le_align_status(mis_None):-
	le_align_stored(_),!.
  le_align_status(mis_Checked):-
	le_align(_),!.
  le_align_status(mis_None).

predicates
  le_palette_status(INTEGER)
clauses
  le_palette_status(mis_None):-
	le_palette_stored(_),!.
  le_palette_status(mis_Checked):-
	le_palette(_),!.
  le_palette_status(mis_None).

predicates
  le_controls_status(INTEGER,INTEGER,INTEGER)
clauses
  le_controls_status(S1,S2,S3):-
	le_property_status(S1),
	le_align_status(S2),
	le_palette_status(S3),!.

  le_popup_menu(LEWin,Pnt):-
	le_layout(LEWin,_,LOWin,_,_),
	layout_select(LOWin,IdList),
	IdList = [_|_],
	le_paste_status(),
	le_controls_status(S1,S2,S3),
	Menu = dyn_menu([
	txt(le_edit_cut,label_msg201,0,1,0,[]),
	txt(le_edit_copy,label_msg202,0,1,0,[]),
	txt(le_edit_paste,label_msg203,0,1,0,[]),
	txt(le_edit_delete,label_msg204,0,1,0,[]),
	separator,
	txt(le_edit_front,label_msg205,0,1,0,[]),
	txt(le_edit_back,label_msg206,0,1,0,[]),
	separator,
	txt(le_edit_type,label_msg207,0,1,0,[]),
	separator,
	txt(le_propertyes,label_msg119,0,1,S1,[]),
	txt(le_alignment,label_msg225,0,1,S2,[]),
	txt(le_palette_id,label_msg234,0,1,S3,[]),
	separator,
	txt(le_screen_update,label_msg214,0,1,0,[]),
	separator,
	txt(le_cancel,label_msg181,0,1,0,[])
	]),
	menu_PopUp(LEWin,Menu,Pnt,align_left),!.
  le_popup_menu(LEWin,Pnt):-
	le_layout(LEWin,_,LOWin,_,_),
	layout_select(LOWin,IdList),
	IdList = [_|_],
	le_controls_status(S1,S2,S3),
	Menu = dyn_menu([
	txt(le_edit_cut,label_msg201,0,1,0,[]),
	txt(le_edit_copy,label_msg202,0,1,0,[]),
	txt(le_edit_delete,label_msg204,0,1,0,[]),
	separator,
	txt(le_edit_front,label_msg205,0,1,0,[]),
	txt(le_edit_back,label_msg206,0,1,0,[]),
	separator,
	txt(le_edit_type,label_msg207,0,1,0,[]),
	separator,
	txt(le_propertyes,label_msg119,0,1,S1,[]),
	txt(le_alignment,label_msg225,0,1,S2,[]),
	txt(le_palette_id,label_msg234,0,1,S3,[]),
	separator,
	txt(le_screen_update,label_msg214,0,1,0,[]),
	separator,
	txt(le_cancel,label_msg181,0,1,0,[])
	]),
	menu_PopUp(LEWin,Menu,Pnt,align_left),!.
  le_popup_menu(LEWin,Pnt):-
	le_paste_status(),
	le_controls_status(S1,S2,S3),
	Menu = dyn_menu([
	txt(le_edit_paste,label_msg203,0,1,0,[]),
	separator,
	txt(le_edit_type,label_msg207,0,1,0,[]),
	separator,
	txt(le_propertyes,label_msg119,0,1,S1,[]),
	txt(le_alignment,label_msg225,0,1,S2,[]),
	txt(le_palette_id,label_msg234,0,1,S3,[]),
	separator,
	txt(le_screen_update,label_msg214,0,1,0,[]),
	separator,
	txt(le_cancel,label_msg181,0,1,0,[])
	]),
	menu_PopUp(LEWin,Menu,Pnt,align_left),!.
  le_popup_menu(LEWin,Pnt):-
	le_controls_status(S1,S2,S3),
	Menu = dyn_menu([
	txt(le_edit_type,label_msg207,0,1,0,[]),
	separator,
	txt(le_propertyes,label_msg119,0,1,S1,[]),
	txt(le_alignment,label_msg225,0,1,S2,[]),
	txt(le_palette_id,label_msg234,0,1,S3,[]),
	separator,
	txt(le_screen_update,label_msg214,0,1,0,[]),
	separator,
	txt(le_cancel,label_msg181,0,1,0,[])
	]),
	menu_PopUp(LEWin,Menu,Pnt,align_left),!.

/**global PREDICATE*******************************************************
			     LE_LAYOUT_SETMODE
*************************************************************************/
  le_SetMode(LEWin,_):-
	not(le_layout(LEWin,_,_,_,_)),!,
	fail.
  le_SetMode(LEWin,edit_mode):-
	le_layout(LEWin,_,LOWin,_,_),
	retractall(le_field_info(LEWin,0,_,_)),
	layout_SetMode(LOWin,edit_mode),!.
  le_SetMode(LEWin,create_mode(text)):-
	le_layout(LEWin,_,LOWin,_,_),
	le_layout_style(Pen,Brush,TextColor,_,Wrap),
	le_label_style(LEWin,Font,FontName),
	retractall(le_field_info(LEWin,0,_,_)),
	assert(le_field_info(LEWin,0,angle_0,text(text(""),Font,FontName,TextColor,left,Pen,Brush,Wrap,none))),
	layout_SetMode(LOWin,create_mode(rectangle)),!.
  le_SetMode(LEWin,create_mode(counter)):-
	le_layout(LEWin,_,LOWin,_,_),
	le_layout_style(Pen,Brush,TextColor,_,_),
	le_label_style(LEWin,Font,FontName),
	retractall(le_field_info(LEWin,0,_,_)),
	assert(le_field_info(LEWin,0,angle_0,counter(0,0,0,1,Font,FontName,TextColor,left,Pen,Brush,none))),
	layout_SetMode(LOWin,create_mode(rectangle)),!.
  le_SetMode(LEWin,create_mode(bitmap)):-
	le_layout(LEWin,_,LOWin,_,_),
	le_layout_style(Pen,_,_,Stretch,_),
	retractall(le_field_info(LEWin,0,_,_)),
	assert(le_field_info(LEWin,0,angle_0,bitmap(Pen,"",Stretch))),
	layout_SetMode(LOWin,create_mode(rectangle)),!.
  le_SetMode(LEWin,create_mode(rectangle)):-
	le_layout(LEWin,_,LOWin,_,_),
	le_layout_style(Pen,Brush,_,_,_),
	retractall(le_field_info(LEWin,0,_,_)),
	assert(le_field_info(LEWin,0,angle_0,rectangle(Pen,Brush))),
	layout_SetMode(LOWin,create_mode(rectangle)),!.
  le_SetMode(LEWin,create_mode(ellipse)):-
	le_layout(LEWin,_,LOWin,_,_),
	le_layout_style(Pen,Brush,_,_,_),
	retractall(le_field_info(LEWin,0,_,_)),
	assert(le_field_info(LEWin,0,angle_0,ellipse(Pen,Brush))),
	layout_SetMode(LOWin,create_mode(ellipse)),!.
  le_SetMode(LEWin,create_mode(line)):-
	le_layout(LEWin,_,LOWin,_,_),
	le_layout_style(Pen,_,_,_,_),
	retractall(le_field_info(LEWin,0,_,_)),
	assert(le_field_info(LEWin,0,angle_0,line(Pen))),
	layout_SetMode(LOWin,create_mode(line)),!.

/**global PREDICATE*******************************************************
			     LE_BRINGTOFRONT
*************************************************************************/
  le_BringToFront(LEWin):-
	le_layout(LEWin,_,LOWin,_,_),
	layout_select(LOWin,IdList),
	layout_BringToFront(LOWin,IdList),!.

/**global PREDICATE*******************************************************
			     LE_SENDTOBACK
*************************************************************************/
  le_SendToBack(LEWin):-
	le_layout(LEWin,_,LOWin,_,_),
	layout_select(LOWin,IdList),
	layout_SendToBack(LOWin,IdList),!.

predicates
  le_remove_scroll(WINDOW LEWin)
clauses
  le_remove_scroll(LEWin):-
	retract(le_vscroll_info(LEWin,b_true,Win,_,_)),
	win_Destroy(Win),fail.
  le_remove_scroll(LEWin):-
	retract(le_hscroll_info(LEWin,b_true,Win,_,_)),
	win_Destroy(Win),!.
  le_remove_scroll(_).

predicates
  le_resize_scroll(WINDOW LEWin)
clauses
  le_resize_scroll(LEWin):-
	le_vscroll_info(LEWin,b_true,VW,_,_),
	le_hscroll_info(LEWin,b_true,HW,_,_),
	Rect1 = win_GetOuterRect(VW),
	Rect2 = win_GetOuterRect(HW),
	Rect1 = rct(L1,T1,R1,_),
	Rect2 = rct(L2,T2,_,B2),
	win_Move(VW,rct(L1,T1,R1,T2)),
	win_Move(HW,rct(L2,T2,L1,B2)),!.
  le_resize_scroll(_).

predicates
  le_create_vscroll(WINDOW LEWin,RCT,RCT,RCT)
  le_create_hscroll(WINDOW LEWin,RCT,RCT,RCT)
  le_set_vscroll_range(WINDOW LEWin,INTEGER T1,INTEGER B1,INTEGER T2,INTEGER B2)
  le_set_hscroll_range(WINDOW LEWin,INTEGER L1,INTEGER R1,INTEGER L2,INTEGER R2)
clauses
  le_create_scroll(LEWin):-
	le_layout(LEWin,LO1_Win,LO_Win,DX,DY),
	le_remove_scroll(LEWin),
	Rect1 = win_GetClientRect(LEWin),
	Rect1 = rct(L01,T01,R0,B0),
	le_info(_,LEWin,_,_,_,_,_,_,_,_,ScaleThick,_,_),
	L0 = L01 + ScaleThick, T0 = T01 + ScaleThick,
	Rect2 = win_GetOuterRect(LO_Win),
	Rect2 = rct(L1,T1,R,B),
	L = L1 - DX, T = T1 - DY,
	NullWin = cast(WINDOW,0),
	retractall(le_vscroll_info(LEWin,_,_,_,_)),
	retractall(le_hscroll_info(LEWin,_,_,_,_)),
	assert(le_vscroll_info(LEWin,b_false,NullWin,0,0)),
	assert(le_hscroll_info(LEWin,b_false,NullWin,0,0)),
	le_create_vscroll(LEWin,rct(L0,T0,R0,B0),rct(L,T,R,B),Rect11),
	le_create_hscroll(LEWin,Rect11,rct(L,T,R,B),Rect12),
	le_create_vscroll(LEWin,Rect12,rct(L,T,R,B),Rect13),
	le_resize_scroll(LEWin),
	le_set_vscroll_range(LEWin,T0,B0,T,B),
	le_set_hscroll_range(LEWin,L0,R0,L,R),
	win_Move(LO1_Win,Rect13),!.

  le_create_vscroll(LEWin,rct(L1,T1,R1,B1),rct(_,T2,_,B2),rct(L1,T1,Lv,B1)):-
	le_vscroll_info(LEWin,b_false,_,CVP,MVP),
	DM = B1 - T1, DD = B2 - T2,
	DD > DM,
	DS = vpi_GetAttrVal(attr_ctl_vert_sbar_width),
	Lv = R1 - DS,
	VW = win_CreateControl(wc_VScroll,rct(Lv,T1,R1,B1),"",LEWin,[],777),
	retractall(le_vscroll_info(LEWin,_,_,_,_)),
	assert(le_vscroll_info(LEWin,b_true,VW,CVP,MVP)),!.
  le_create_vscroll(LEWin,Rect,_,Rect):-
	le_vscroll_info(LEWin,b_false,_,_,_),
	le_layout(LEWin,_,LO_Win,_,DY),
	RCT = win_GetOuterRect(LO_Win),
	RCT = rct(L,T,R,B),
	T1 = DY, B1 = T1 + (B - T),
	win_Move(LO_Win,rct(L,T1,R,B1)),
	le_scale(LEWin,_,VS_Win),
	le_info(_,LEWin,_,_,_,_,_,_,_,_,ScaleThick,_,_),
	scale_WorkSpace(VS_Win,T0,B0),
	T01 = DY + ScaleThick, B01 = T01 + (B0 - T0),
	scale_WorkSpace(VS_Win,T01,B01),!.
  le_create_vscroll(_,Rect,_,Rect).
  le_create_hscroll(LEWin,rct(L1,T1,R1,B1),rct(L2,_,R2,_),rct(L1,T1,R1,Tv)):-
	le_hscroll_info(LEWin,b_false,_,CVP,MVP),
	DM = R1 - L1, DD = R2 - L2,
	DD > DM,
	DS = vpi_GetAttrVal(attr_ctl_horz_sbar_height),
	Tv = B1 - DS,
	HW = win_CreateControl(wc_HScroll,rct(L1,Tv,R1,B1),"",LEWin,[],778),
	retractall(le_hscroll_info(LEWin,_,_,_,_)),
	assert(le_hscroll_info(LEWin,b_true,HW,CVP,MVP)),!.
  le_create_hscroll(LEWin,Rect,_,Rect):-
	le_hscroll_info(LEWin,b_false,_,_,_),
	le_layout(LEWin,_,LO_Win,DX,_),
	RCT = win_GetOuterRect(LO_Win),
	RCT = rct(L,T,R,B),
	L1 = DX, R1 = L1 + (R - L),
	win_Move(LO_Win,rct(L1,T,R1,B)),
	le_scale(LEWin,HS_Win,_),
	le_info(_,LEWin,_,_,_,_,_,_,_,_,ScaleThick,_,_),
	scale_WorkSpace(HS_Win,L0,R0),
	L01 = DX + ScaleThick, R01 = L01 + (R0 - L0),
	scale_WorkSpace(HS_Win,L01,R01),!.
  le_create_hscroll(_,Rect,_,Rect).

  le_set_vscroll_range(LEWin,T1,B1,T2,B2):-
	le_vscroll_info(LEWin,b_true,VW,_,_),
	le_info(_,LEWin,_,_,_,_,_,_,_,PixInMM,_,_,_),
	OneScroll = 10 * PixInMM,
	DM = B1 - T1, DD = B2 - T2,
	Range = (DD - DM) div OneScroll + 3,
	win_SetScrollRange(VW,sb_Ctl,1,Range),
	First = 0 - T2 div OneScroll + 1,
	win_SetScrollPos(VW,sb_Ctl,First),
	retractall(le_vscroll_info(LEWin,_,_,_,_)),
	assert(le_vscroll_info(LEWin,b_true,VW,First,Range)),!.
  le_set_vscroll_range(_,_,_,_,_).
  le_set_hscroll_range(LEWin,L1,R1,L2,R2):-
	le_hscroll_info(LEWin,b_true,HW,_,_),
	le_info(_,LEWin,_,_,_,_,_,_,_,PixInMM,_,_,_),
	OneScroll = 10 * PixInMM,
	DM = R1 - L1, DD = R2 - L2,
	Range = (DD - DM) div OneScroll + 3,
	win_SetScrollRange(HW,sb_Ctl,1,Range),
	First = 0 - L2 div OneScroll + 1,
	win_SetScrollPos(HW,sb_Ctl,First),
	retractall(le_hscroll_info(LEWin,_,_,_,_)),
	assert(le_hscroll_info(LEWin,b_true,HW,First,Range)),!.
  le_set_hscroll_range(_,_,_,_,_).

predicates
  le_vmove(WINDOW LEWin,INTEGER Dif)
  le_hmove(WINDOW LEWin,INTEGER Dif)
clauses
  le_vscroll_handler(_,sc_None,_):-!.
  le_vscroll_handler(LEWin,sc_LineUp,_):-
	le_vmove(LEWin,-1),!.
  le_vscroll_handler(LEWin,sc_LineDown,_):-
	le_vmove(LEWin,1),!.
  le_vscroll_handler(LEWin,sc_PageUp,_):-
	le_layout(LEWin,LO1_Win,_,_,_),
	Rect = win_GetClientRect(LO1_Win),
	Rect = rct(_,T,_,B),
	le_info(_,LEWin,_,_,_,_,_,_,_,PixInMM,_,_,_),
	OneScroll = 10 * PixInMM,
	Dif = 0 - (B - T) div OneScroll,
	le_vmove(LEWin,Dif),!.
  le_vscroll_handler(LEWin,sc_PageDown,_):-
	le_layout(LEWin,LO1_Win,_,_,_),
	Rect = win_GetClientRect(LO1_Win),
	Rect = rct(_,T,_,B),
	le_info(_,LEWin,_,_,_,_,_,_,_,PixInMM,_,_,_),
	OneScroll = 10 * PixInMM,
	Dif = (B - T) div OneScroll,
	le_vmove(LEWin,Dif),!.
  le_vscroll_handler(LEWin,sc_Thumb,Pos):-
	le_vscroll_info(LEWin,_,_,CurVPos,_),
	Dif = Pos - CurVPos,
	le_vmove(LEWin,Dif),!.
  le_vscroll_handler(LEWin,_,_):-
	trap(win_SetFocus(LEWin),_,true),!.

  le_hscroll_handler(_,sc_None,_):-!.
  le_hscroll_handler(LEWin,sc_LineUp,_):-
	le_hmove(LEWin,-1),!.
  le_hscroll_handler(LEWin,sc_LineDown,_):-
	le_hmove(LEWin,1),!.
  le_hscroll_handler(LEWin,sc_PageUp,_):-
	le_layout(LEWin,LO1_Win,_,_,_),
	Rect = win_GetClientRect(LO1_Win),
	Rect = rct(L,_,R,_),
	le_info(_,LEWin,_,_,_,_,_,_,_,PixInMM,_,_,_),
	OneScroll = 10 * PixInMM,
	Dif = 0 - (R - L) div OneScroll,
	le_hmove(LEWin,Dif),!.
  le_hscroll_handler(LEWin,sc_PageDown,_):-
	le_layout(LEWin,LO1_Win,_,_,_),
	Rect = win_GetClientRect(LO1_Win),
	Rect = rct(L,_,R,_),
	le_info(_,LEWin,_,_,_,_,_,_,_,PixInMM,_,_,_),
	OneScroll = 10 * PixInMM,
	Dif = (R - L) div OneScroll,
	le_hmove(LEWin,Dif),!.
  le_hscroll_handler(LEWin,sc_Thumb,Pos):-
	le_hscroll_info(LEWin,_,_,CurVPos,_),
	Dif = Pos - CurVPos,
	le_hmove(LEWin,Dif),!.
  le_hscroll_handler(LEWin,_,_):-
	trap(win_SetFocus(LEWin),_,true),!.

predicates
  le_max(INTEGER,INTEGER,INTEGER)
  le_min(INTEGER,INTEGER,INTEGER)
  le_max(REAL,REAL,REAL)
  le_min(REAL,REAL,REAL)
clauses
  le_vmove(LEWin,Deff):-
	le_vscroll_info(LEWin,b_true,VW,CurPos,MaxPos),
	Pos = CurPos + Deff,
	le_max(Pos,1,Pos1),
	le_min(Pos1,MaxPos,NewPos),
	retractall(le_vscroll_info(LEWin,_,_,_,_)),
	assert(le_vscroll_info(LEWin,b_true,VW,NewPos,MaxPos)),
	win_SetScrollPos(VW,sb_Ctl,NewPos),
	le_layout(LEWin,_,LO_Win,_,_),
	Rect = win_GetOuterRect(LO_Win),
	Rect = rct(L,T1,R,B1),
	le_info(_,LEWin,_,_,_,_,_,_,_,PixInMM,_,_,_),
	OneScroll = 10 * PixInMM,
	Dif = (CurPos - NewPos) * OneScroll,
	T = T1 + Dif, B = B1 + Dif,
	win_Move(LO_Win,rct(L,T,R,B)),
	le_scale(LEWin,_,VS_Win),
	scale_WorkSpace(VS_Win,T0,B0),
	T01 = T0 + Dif, B01 = B0 + Dif,
	scale_WorkSpace(VS_Win,T01,B01),!.
  le_vmove(_,_).
  le_hmove(LEWin,Deff):-
	le_hscroll_info(LEWin,b_true,VW,CurPos,MaxPos),
	Pos = CurPos + Deff,
	le_max(Pos,1,Pos1),
	le_min(Pos1,MaxPos,NewPos),
	retractall(le_hscroll_info(LEWin,_,_,_,_)),
	assert(le_hscroll_info(LEWin,b_true,VW,NewPos,MaxPos)),
	win_SetScrollPos(VW,sb_Ctl,NewPos),
	le_layout(LEWin,_,LO_Win,_,_),
	Rect = win_GetOuterRect(LO_Win),
	Rect = rct(L1,T,R1,B),
	le_info(_,LEWin,_,_,_,_,_,_,_,PixInMM,_,_,_),
	OneScroll = 10 * PixInMM,
	Dif = (CurPos - NewPos) * OneScroll,
	L = L1 + Dif, R = R1 + Dif,
	win_Move(LO_Win,rct(L,T,R,B)),
	le_scale(LEWin,HS_Win,_),
	scale_WorkSpace(HS_Win,L0,R0),
	L01 = L0 + Dif, R01 = R0 + Dif,
	scale_WorkSpace(HS_Win,L01,R01),!.
  le_hmove(_,_).

predicates
  le_auto_scroll(WINDOW LEWin,RCT)
  le_auto_scroll1(WINDOW LEWin,RCT,RCT)
clauses
  le_auto_scroll(LEWin,rct(L,T,R,B)):-
	le_layout(LEWin,LO1_Win,_,_,_),
	Rect = win_GetOuterRect(LO1_Win),
	Rect = rct(L1,T1,R1,B1),
	le_auto_scroll1(LEWin,rct(L1,T1,R1,B1),rct(L,T,R,B)),!.
  le_auto_scroll(_,_).

  le_auto_scroll1(LEWin,rct(L,_,_,_),rct(L1,_,_,_)):-
	L1 < L,
	le_hscroll_handler(LEWin,sc_LineUp,0),!.
  le_auto_scroll1(LEWin,rct(_,_,R,_),rct(_,_,R1,_)):-
	R1 > R,
	le_hscroll_handler(LEWin,sc_LineDown,0),!.
  le_auto_scroll1(LEWin,rct(_,T,_,_),rct(_,T1,_,_)):-
	T1 < T,
	le_vscroll_handler(LEWin,sc_LineUp,0),!.
  le_auto_scroll1(LEWin,rct(_,_,_,B),rct(_,_,_,B1)):-
	B1 > B,
	le_vscroll_handler(LEWin,sc_LineDown,0),!.

  le_check_callback(LEWin,user_action(create_field)):-
	le_info(_,LEWin,_,_,_,_,_,_,_,_,_,_,Callbackfunc),
	Callbackfunc(LEWin,user_action(create_field),Answer),!,
	Answer = continue.
  le_check_callback(LEWin,Mess):-
	le_info(_,LEWin,_,_,_,_,_,_,_,_,_,_,Callbackfunc),
	Callbackfunc(LEWin,Mess,Answer),!,
	Answer = continue.
  le_check_callback(LO1_Win,Mess):-
	le_layout(LEWin,LO1_Win,_,_,_),
	le_info(_,LEWin,_,_,_,_,_,_,_,_,_,_,Callbackfunc),
	Callbackfunc(LEWin,Mess,Answer),!,
	Answer = continue.
  le_check_callback(_,_).

  le_check_callback1(Win,Mess):-
	le_callback(Callbackfunc),
	Callbackfunc(Win,Mess,_),!.
  le_check_callback1(_,_).

