/******************************************************************************

               Copyright (c) 1984 - 2000 Prolog Development Center A/S

 FileName:	GRIDMAIN.PRO
 Purpose:	GRID custom control object
 Written by:	Sergey Alexeev
 Version:	2.0
 Build:		025.991028
 Tested with:   Visual Prolog v.5.1 build 563
 Comments:
******************************************************************************/
constants
  grid_edit_id = 7777
  grid_lbb_id  = 7778
  grid_lbe_id  = 7779
  grid_custom_id  = 7780
  grid_righttop_id = 7781
  grid_leftbottom_id = 7782
  grid_rightbottom_id = 7783

  grid_normal  = 0
  grid_pressed = 1

ifdef os_nt
  grid_row_height = 4
elsedef
  grid_row_height = 12
enddef

  grid_l	= 313
  grid_r	= 314
  grid_t	= 301
  grid_b	= 302

  grid_single_marker	= 0
  grid_areas_marker	= 1
  grid_rows_marker	= 2
  grid_columns_marker	= 3

  grid_move_one_down	= 1
  grid_move_one_up	= 2
  grid_move_page_down	= 3
  grid_move_page_up	= 4
  grid_move_down	= 5
  grid_move_up		= 6
  grid_size_one_down	= 7
  grid_size_one_up	= 8
  grid_size_page_down	= 9
  grid_size_page_up	= 10
  grid_size_down	= 11
  grid_size_up		= 12
  grid_move_one_right	= 13
  grid_move_one_left	= 14
  grid_move_right	= 15
  grid_move_left	= 16
  grid_size_one_right	= 17
  grid_size_one_left	= 18
  grid_size_right	= 19
  grid_size_left	= 20

domains
GRID_CONVERT	=	grid_tb(LONG Top,LONG Bottom);
			grid_lr(INTEGER Left,INTEGER Right,GRID_HORALIGNMENT,GRID_VERALIGNMENT,INTEGER DX,INTEGER DY,INTEGER MaxText,STRING Title);
			grid_row(INTEGER Row);
			grid_y(INTEGER Y);
			grid_x(INTEGER X);
			grid_column(INTEGER Column);
			grid_lt;
			grid_tt;
			grid_empty

database - grid_db
  grid_info(WINDOW GridWin,RCT,GRID_CALLBACK,WINDOW ParentWin)
  grid_view_info(WINDOW GridWin,GRID_CELLS_STYLE,GRID_ROW_SELECTOR,BOOLEAN ActiveRowPointer,INTEGER ActiveRow,
	COLOR DefaultColor,COLOR BgColor,COLOR FrColor,COLOR BgTitleColor,COLOR FgTitleColor,BOOLEAN InvisibleMarkers)
  grid_row_info(WINDOW GridWin,INTEGER MaxRow,INTEGER LeftTitleWidth,INTEGER TopTitleHeight,INTEGER RowHeight,INTEGER MaxLine,INTEGER FirstRow,INTEGER LastRow)
  grid_column_info(WINDOW GridWin,INTEGER MaxColumn,GRID_COLUMN_LIST,INTEGER FirstColumn,INTEGER LastColumn,INTEGER NoScrollColumns)
  grid_column_stat(WINDOW GridWin,STRING Title,INTEGER Num,INTEGER L,INTEGER R,GRID_HORALIGNMENT,GRID_VERALIGNMENT,INTEGER DX,INTEGER DY,INTEGER MaxTextLength)
  grid_vscroll_info(WINDOW GridWin,BOOLEAN Vert,WINDOW Vert,INTEGER CurVPos,INTEGER MaxVPos)
  grid_hscroll_info(WINDOW GridWin,BOOLEAN Hor,WINDOW Hor,INTEGER CurHPos,INTEGER MaxHPos)
  grid_resize(WINDOW GridWin,BOOLEAN Cursor,BOOLEAN Resize,INTEGER Column,INTEGER X)

  grid_edit(WINDOW GridWin,INTEGER CtlId,WINDOW CtrlWin,INTEGER Row,INTEGER Column,STRING String,SLIST InitStr)
  grid_custom_func(WINDOW GridWin,String CustomName,CTL_FLAGS,GRID_PUT_CUSTOM_DATA,GRID_GET_CUSTOM_DATA)
  grid_all(WINDOW GridWin)
  grid_row(WINDOW GridWin,GRID_LINELIST)
  grid_column(WINDOW GridWin,GRID_LINELIST)
  grid_area(WINDOW GridWin,GRID_AREALIST)

  grid_mouse_pressed(WINDOW GridWin)
  grid_visit_order(WINDOW GridWin,GRID_KEY Key,INTEGER ShiftCtlAlt,GRID_KEY_ACTION Action)

  grid_custom_handler(WINDOW GridWin,WINDOW FocWin,EHANDLER)
  grid_move_edit_max_post(WINDOW ControlWin)

  determ grid_hscroll_destroy
  determ grid_hscroll_create
  determ grid_vscroll_destroy
  determ grid_vscroll_create

  determ grid_nofon_reaction
  determ grid_invalidate_action
  determ grid_no_marker_callback
  determ grid_edit_kill
  determ grid_nocalc_clear_area
  determ grid_ignore_size

/**global PREDICATE*******************************************************
			     GRID_INIT
 *************************************************************************/
predicates
procedure  grid_win_Destroy(WINDOW)
procedure  INTEGER grid_val(LONG)
procedure  grid_get_param(WINDOW GridWin,GRID_STYLE,GRID_ROWSTYLE,GRID_COLUMNSTYLE)
determ   grid_create_scroll_bar(WINDOW GridWin)
determ   grid_set_last_RowColumn(WINDOW GridWin)

determ  grid_convert(WINDOW GridWin,GRID_CONVERT,GRID_CONVERT,BOOLEAN Inside)
determ  grid_correct(WINDOW GridWin,GRID_CONVERT,GRID_CONVERT)
determ  grid_calc(WINDOW GridWin,GRID_CONVERT,GRID_CONVERT)
determ  grid_inside(WINDOW GridWin,GRID_CONVERT,BOOLEAN Inside)

determ  INTEGER grid_get_x_max(WINDOW GridWin)
determ  INTEGER grid_get_y_max(WINDOW GridWin)

determ  grid_redraw_row(GRIDLIST2D,WINDOW GridWin,INTEGER From_Row,INTEGER To_Row,INTEGER From_Column,INTEGER To_Column)
determ  grid_redraw_column(GRIDLIST,WINDOW GridWin,INTEGER Row,INTEGER From_Column,INTEGER To_Column)

determ  grid_redraw_row_empty(WINDOW GridWin,INTEGER From_Row,INTEGER To_Row,INTEGER From_Column,INTEGER To_Column)
determ  grid_redraw_column_empty(WINDOW GridWin,INTEGER Row,INTEGER From_Column,INTEGER To_Column)

determ  grid_get_text_answer(WINDOW GridWin,GRIDTEXT,STRING,COLOR ForeColor,COLOR BackColor)
determ  grid_get_text_answer_pict(WINDOW GridWin,GRIDTEXT,PICTURE,BOOLEAN Stretch,COLOR BackColor)
procedure  grid_cell_draw(WINDOW GridWin,INTEGER Row,INTEGER Column,COLOR ForeColor,COLOR BackColor,STRING)
procedure  grid_cell_draw_pict(WINDOW GridWin,INTEGER Row,INTEGER Column,COLOR BackColor,BOOLEAN Stretch,PICTURE)
determ  grid_cell_draw_ext(WINDOW GridWin,GRIDTEXT,INTEGER Row,INTEGER Column)
procedure  grid_draw_pushbotton(WINDOW GridWin,GRID_CONVERT,GRID_CONVERT,COLOR Rct_Color,COLOR Txt_color,
  	INTEGER DX,INTEGER DY,GRID_HORALIGNMENT,GRID_VERALIGNMENT,STRING)
procedure  grid_draw_pushbotton_pict(WINDOW GridWin,GRID_CONVERT,GRID_CONVERT,COLOR Rct_Color,
  	INTEGER DX,INTEGER DY,GRID_HORALIGNMENT,GRID_VERALIGNMENT,BOOLEAN Stretch,PICTURE)
determ  grid_check_callback(WINDOW GridWin,GRIDMESS)
procedure  grid_check_callback_nofail(WINDOW GridWin,GRIDMESS)

procedure  grid_ownerdraw_CreateControl(WINTYPE,UNSIGNED,RCT,STRING,WINDOW)
determ  grid_ownerdraw_DrawButton(OD_ITEMACTION,OD_ITEMSTATE,WINDOW GridWin,WINDOW CtlWin,INTEGER CtlId)

determ  grid_remove_markers(WINDOW GridWin,INTEGER MultiMarker)
procedure  grid_remove_scroll_bar(WINDOW GridWin)

procedure grid_resize_grid(WINDOW GridWin)
procedure grid_Invalidate_my(WINDOW GridWin,GRID_DATA_AREA)
clauses
  grid_Init(GridWin,CellsStyle,CellsRowStyle,CellsColumnStyle,
		CallBackFunc):-
	grid_remove_markers(GridWin,grid_single_marker),

	grid_remove_scroll_bar(GridWin),
	retractall(grid_info(GridWin,_,_,_)),
	retractall(grid_view_info(GridWin,_,_,_,_,_,_,_,_,_,_)),
	retractall(grid_row_info(GridWin,_,_,_,_,_,_,_)),
	retractall(grid_column_info(GridWin,_,_,_,_,_)),
	retractall(grid_column_stat(GridWin,_,_,_,_,_,_,_,_,_)),
	retractall(grid_vscroll_info(GridWin,_,_,_,_)),
	retractall(grid_hscroll_info(GridWin,_,_,_,_)),
	retractall(grid_resize(GridWin,_,_,_,_)),
	retractall(grid_edit(GridWin,_,_,_,_,_,_)),
	retractall(grid_custom_func(GridWin,_,_,_,_)),
	retractall(grid_all(GridWin)),
	retractall(grid_row(GridWin,_)),
	retractall(grid_column(GridWin,_)),
	retractall(grid_area(GridWin,_)),

	retractall(grid_mouse_pressed(GridWin)),
	retractall(grid_visit_order(GridWin,_,_,_)),
	retractall(grid_custom_handler(GridWin,_,_)),

	retractall(grid_hscroll_destroy),
	retractall(grid_hscroll_create),
	retractall(grid_vscroll_destroy),
	retractall(grid_vscroll_create),
	retractall(grid_invalidate_action),
	retractall(grid_no_marker_callback),

	RCT = win_GetOuterRect(GridWin),
	ParentWin = win_GetParent(GridWin),
	grid_get_param(GridWin,CellsStyle,CellsRowStyle,CellsColumnStyle),

	assert(grid_info(GridWin,RCT,CallBackFunc,ParentWin)),
	assert(grid_resize(GridWin,b_true,b_false,1,0)),
	assert(grid_visit_order(GridWin,grid_key_enter,c_Nothing,grid_down)),
	assert(grid_visit_order(GridWin,grid_key_enter,c_Shift,grid_up)),
	assert(grid_visit_order(GridWin,grid_key_tab,c_Nothing,grid_right)),
	assert(grid_visit_order(GridWin,grid_key_tab,c_Shift,grid_left)),
	assert(grid_visit_order(GridWin,grid_max_length,c_Nothing,grid_right)),
	grid_resize_grid(GridWin),
	grid_create_scroll_bar(GridWin),
	grid_set_last_RowColumn(GridWin),
	retractall(grid_nocalc_clear_area),
	assert(grid_nocalc_clear_area),
	win_Invalidate(GridWin),!.
  grid_Init(_,_,_,_,_):-
	errorexit(error_vpi_package_bad_data).

 grid_resize_grid(GridWin):-
	grid_info(GridWin,Rect,_,_),
	Rect = rct(L,T,R,B),
	grid_row_info(GridWin,_,_,TopTitleHeight,RowHeight,_,_,_),
	B1 = T + ((((B - T) - TopTitleHeight) div RowHeight) * RowHeight + TopTitleHeight),
	win_Move(GridWin,rct(L,T,R,B1)),!.
 grid_resize_grid(_).

ifdef platform_16bit
  grid_val(L,I):-
	I = val(integer,L),!.
elsedef
  grid_val(L,L):-!.
enddef

  grid_win_Destroy(Win):-
	trap(win_Destroy(Win),_,fail),!.
  grid_win_Destroy(_).

predicates
procedure  grid_send_hscroll_callback(WINDOW GridWin)
clauses
  grid_send_hscroll_callback(_):-
	grid_hscroll_destroy,
	grid_hscroll_create,!.
  grid_send_hscroll_callback(GridWin):-
	grid_hscroll_destroy,
	retractall(grid_hscroll_destroy),
	retractall(grid_hscroll_create),
	grid_check_callback_nofail(GridWin,user_action(grid_hscroll_destroy)),!.
  grid_send_hscroll_callback(GridWin):-
	grid_hscroll_create,
	retractall(grid_hscroll_destroy),
	retractall(grid_hscroll_create),
	grid_check_callback_nofail(GridWin,user_action(grid_hscroll_create)),!.
  grid_send_hscroll_callback(_).

predicates
procedure  grid_send_vscroll_callback(WINDOW GridWin)
clauses
  grid_send_vscroll_callback(_):-
	grid_vscroll_destroy,
	grid_vscroll_create,!.
  grid_send_vscroll_callback(GridWin):-
	grid_vscroll_destroy,
	retractall(grid_vscroll_destroy),
	retractall(grid_vscroll_create),
	grid_check_callback_nofail(GridWin,user_action(grid_vscroll_destroy)),!.
  grid_send_vscroll_callback(GridWin):-
	grid_vscroll_create,
	retractall(grid_vscroll_destroy),
	retractall(grid_vscroll_create),
	grid_check_callback_nofail(GridWin,user_action(grid_vscroll_create)),!.
  grid_send_vscroll_callback(_).

predicates
procedure  grid_send_scroll_callback(WINDOW GridWin)
clauses
  grid_send_scroll_callback(GridWin):-
	grid_send_hscroll_callback(GridWin),
	grid_send_vscroll_callback(GridWin),
	retractall(grid_hscroll_destroy),
	retractall(grid_hscroll_create),
	retractall(grid_vscroll_destroy),
	retractall(grid_vscroll_create),!.

predicates
procedure  RCT grid_my_win_GetClientRect(WINDOW GridWin)
procedure  grid_set_vscroll(WINDOW GridWin,INTEGER FirstRow,INTEGER DYtab,INTEGER DYsc,RCT,INTEGER DXsc,INTEGER DXsc1)
procedure  grid_set_hscroll(WINDOW GridWin,INTEGER FirstColumn,INTEGER DXtab,INTEGER DXsc,RCT,INTEGER DYsc,INTEGER DYsc1)
procedure  grid_set_vscroll_range(WINDOW GridWin)
procedure  grid_set_hscroll_range(WINDOW GridWin)
procedure  INTEGER grid_min(INTEGER X1,INTEGER X2)
procedure  LONG grid_min1(LONG X1,LONG X2)
procedure  INTEGER grid_max(INTEGER X1,INTEGER X2)
procedure  LONG grid_max1(LONG X1,LONG X2)
procedure  grid_create_rb_control(WINDOW GridWin,INTEGER R,INTEGER B)
procedure  grid_win_destroy1(WINDOW GridWin,INTEGER Id)

clauses
  grid_win_destroy1(GridWin,Id):-
	trap(CtlWin = win_GetCtlHandle(GridWin,Id),_,fail),
	grid_win_Destroy(CtlWin),!.
  grid_win_destroy1(_,_).

  grid_remove_scroll_bar(GridWin):-
	retract(grid_vscroll_info(GridWin,b_true,Win,_,_)),
	grid_win_Destroy(Win),
	retractall(grid_vscroll_destroy),
	assert(grid_vscroll_destroy),
	grid_win_destroy1(GridWin,grid_righttop_id),
	grid_win_destroy1(GridWin,grid_rightbottom_id),
	fail.
  grid_remove_scroll_bar(GridWin):-
	retract(grid_hscroll_info(GridWin,b_true,Win,_,_)),
	grid_win_Destroy(Win),
	retractall(grid_hscroll_destroy),
	assert(grid_hscroll_destroy),
	grid_win_destroy1(GridWin,grid_leftbottom_id),
	grid_win_destroy1(GridWin,grid_rightbottom_id),!.
  grid_remove_scroll_bar(_).

  grid_create_scroll_bar(GridWin):-
	grid_remove_scroll_bar(GridWin),
	NullWin = cast(WINDOW,0),
	retractall(grid_vscroll_info(GridWin,_,_,_,_)),
	retractall(grid_hscroll_info(GridWin,_,_,_,_)),
	assert(grid_vscroll_info(GridWin,b_false,NullWin,0,0)),
	assert(grid_hscroll_info(GridWin,b_false,NullWin,0,0)),
	grid_row_info(GridWin,MaxRow,Xscmin,Yscmin,RowHeight,_,FirstRow,_),
	RCT = win_GetClientRect(GridWin),
	RCT = rct(_,_,Xscmax,Yscmax),
	DYsc = Yscmax - Yscmin,
	DXsc = Xscmax - Xscmin,
	DYtab0 = val(LONG,MaxRow) * val(LONG,RowHeight),
	DYsc0  = val(LONG,DYsc) + 1,
	DYtab00 = grid_min1(DYsc0,DYtab0),
	DYtab = grid_val(DYtab00),
	grid_column_info(GridWin,MaxColumn,_,FirstColumn,_,_),
	grid_column_stat(GridWin,_,1,Xmintab,_,_,_,_,_,_),
	grid_column_stat(GridWin,_,MaxColumn,_,Xmaxtab,_,_,_,_,_),
	DXtab = Xmaxtab - Xmintab,
	Width = win_GetAttrVal(GridWin,attr_ctl_vert_sbar_width),
	Height = win_GetAttrVal(GridWin,attr_ctl_horz_sbar_height),
	Lv = Xscmax - Width, Tv = Yscmin, Rv = Xscmax, Bv = Yscmax - Height,
	Lh = Xscmin, Th = Yscmax - Height, Rh = Xscmax - Width, Bh = Yscmax,
	BvI = grid_val(Bv),
	LvI = grid_val(Lv),
	RhI = grid_val(Rh),
	ThI = grid_val(Th),
	grid_set_vscroll(GridWin,FirstRow,DYtab,DYsc,rct(LvI,Tv,Rv,BvI),DXsc,DXsc1),
	grid_set_hscroll(GridWin,FirstColumn,DXtab,DXsc1,rct(Lh,ThI,RhI,Bh),DYsc,DYsc1),
	grid_set_vscroll(GridWin,FirstRow,DYtab,DYsc1,rct(LvI,Tv,Rv,BvI),DXsc,_),
	grid_create_rb_control(GridWin,Xscmax,Yscmax),
	grid_set_last_RowColumn(GridWin),
	grid_set_vscroll_range(GridWin),
	grid_set_hscroll_range(GridWin),
	ClipRct = grid_my_win_GetClientRect(GridWin),
	win_SetClip(GridWin,ClipRct),
	grid_send_scroll_callback(GridWin),!.

  grid_set_vscroll(GridWin,_,DYtab,DYsc,rct(Lv,Tv,Rv,Bv),DXsc,DXsc1):-
	grid_vscroll_info(GridWin,b_false,_,CVP,MVP),
	DYtab > DYsc,
	grid_info(GridWin,_,_,_),!,
	VW = win_CreateControl(wc_VScroll,rct(Lv,Tv,Rv,Bv),"",GridWin,[],0),
	retractall(grid_vscroll_create),
	assert(grid_vscroll_create),
	retractall(grid_vscroll_info(GridWin,_,_,_,_)),
	assert(grid_vscroll_info(GridWin,b_true,VW,CVP,MVP)),
	Lrt = Lv, Trt = 0,Rrt = Rv, Brt = Tv,
	grid_ownerdraw_CreateControl(wc_PushButton,grid_righttop_id,rct(Lrt,Trt,Rrt,Brt),"",GridWin),
	DXsc1 = DXsc - (Rv - Lv),!.
  grid_set_vscroll(GridWin,FirstRow,_,_,_,DXsc,DXsc):-
	grid_vscroll_info(GridWin,b_false,_,_,_),
	FirstRow <> 1,
	retract(grid_row_info(GridWin,MaxRow,LeftTitleWidth,TopTitleHeight,RowHeight,MaxLine,_,LastRow)),!,
	assert(grid_row_info(GridWin,MaxRow,LeftTitleWidth,TopTitleHeight,RowHeight,MaxLine,1,LastRow)),
	win_Invalidate(GridWin),!.
  grid_set_vscroll(_,_,_,_,_,DXsc,DXsc).

  grid_set_hscroll(GridWin,_,DXtab,DXsc,rct(Lh,Th,Rh,Bh),DYsc,DYsc1):-
	grid_hscroll_info(GridWin,b_false,_,CVP,MVP),
	DXtab > DXsc,
	grid_info(GridWin,_,_,_),!,
	HW = win_CreateControl(wc_HScroll,rct(Lh,Th,Rh,Bh),"",GridWin,[],0),
	retractall(grid_hscroll_create),
	assert(grid_hscroll_create),
	retractall(grid_hscroll_info(GridWin,_,_,_,_)),
	assert(grid_hscroll_info(GridWin,b_true,HW,CVP,MVP)),
	Llb = 0, Tlb = Th, Rlb = Lh, Blb = Bh,
	grid_ownerdraw_CreateControl(wc_PushButton,grid_leftbottom_id,rct(Llb,Tlb,Rlb,Blb),"",GridWin),
	DYsc1 = DYsc - (Bh - Th),!.
  grid_set_hscroll(GridWin,FirstColumn,_,_,_,DYsc,DYsc):-
	grid_hscroll_info(GridWin,b_false,_,_,_),
	grid_column_info(GridWin,_,_,_,_,NoScrollColumns),
	NSC = NoScrollColumns + 1,
	FirstColumn <> NSC,
	retract(grid_column_info(GridWin,MaxColumn,GRID_COLUMNLIST,_,LastColumn,NoScrollColumns)),!,
	assert(grid_column_info(GridWin,MaxColumn,GRID_COLUMNLIST,NSC,LastColumn,NoScrollColumns)),
	win_Invalidate(GridWin),!.
  grid_set_hscroll(_,_,_,_,_,DYsc,DYsc).

  grid_create_rb_control(GridWin,R,B):-
	grid_vscroll_info(GridWin,b_true,_,_,_),
	Width = win_GetAttrVal(GridWin,attr_ctl_vert_sbar_width),
	Height = win_GetAttrVal(GridWin,attr_ctl_horz_sbar_height),
	L = R - Width, T = B - Height,
	TI = grid_val(T),
	LI = grid_val(L),
	grid_ownerdraw_CreateControl(wc_PushButton,grid_rightbottom_id,rct(LI,TI,R,B),"",GridWin),!.
  grid_create_rb_control(GridWin,R,B):-
	grid_hscroll_info(GridWin,b_true,_,_,_),
	Width = win_GetAttrVal(GridWin,attr_ctl_vert_sbar_width),
	Height = win_GetAttrVal(GridWin,attr_ctl_horz_sbar_height),
	L = R - Width, T = B - Height,
	TI = grid_val(T),
	LI = grid_val(L),
	grid_ownerdraw_CreateControl(wc_PushButton,grid_rightbottom_id,rct(LI,TI,R,B),"",GridWin),!.
  grid_create_rb_control(_,_,_).

predicates
procedure grid_get_right_nonscroll1(WINDOW GridWin,INTEGER Width,INTEGER MaxColumn,INTEGER NonScrollColumn)
clauses
  grid_get_right_nonscroll1(_,_,0,NonScrollColumn):-
	NonScrollColumn = 0,!.
  grid_get_right_nonscroll1(GridWin,Width,Column,NonScrollColumn):-
	grid_column_stat(GridWin,_,Column,L,R,_,_,_,_,_),
	Length = R - L,
	Length > Width,
	NonScrollColumn = Column + 1,!.
  grid_get_right_nonscroll1(GridWin,Width,Column,NonScrollColumn):-
	grid_column_stat(GridWin,_,Column,L,R,_,_,_,_,_),
	Length = R - L,
	Width1 = Width - Length,
	Column1 = Column - 1,!,
	grid_get_right_nonscroll1(GridWin,Width1,Column1,NonScrollColumn).
  grid_get_right_nonscroll1(_,_,_,0):-errorexit().

predicates
procedure grid_get_noscroll_width(WINDOW GridWin,INTEGER NoScrollLeftColumn,INTEGER NoScrollWidth)
clauses
  grid_get_noscroll_width(GridWin,NoScrollLeftColumn,NoScrollWidth):-
	grid_column_stat(GridWin,_,NoScrollLeftColumn,_,NoScrollWidth,_,_,_,_,_),!.
  grid_get_noscroll_width(_,_,0).

predicates
determ grid_adjust_NoScrollRightColumn(INTEGER Width,INTEGER LastLength,
	INTEGER MaxColumn,INTEGER NoScrollLeftColumn,INTEGER NoScrollRightColumn,
	INTEGER NewNoScrollRightColumn)
clauses
  grid_adjust_NoScrollRightColumn(Width,_,_,_,_,_):-
	Width < 0,!,
	fail.
  grid_adjust_NoScrollRightColumn(_,_,MaxColumn,NoScrollLeftColumn,_,_):-
	MaxColumn <= NoScrollLeftColumn + 1,!,
	fail.
  grid_adjust_NoScrollRightColumn(Width,LastLength,MaxColumn,_,NoScrollRightColumn,NewNoScrollRightColumn):-
	Width1 = Width - LastLength,
	Width1 < 0,
	NewNoScrollRightColumn = MaxColumn - NoScrollRightColumn + 1,!.
  grid_adjust_NoScrollRightColumn(_,_,MaxColumn,_,NoScrollRightColumn,NewNoScrollRightColumn):-
	NewNoScrollRightColumn = MaxColumn - NoScrollRightColumn,!.

predicates
determ grid_get_right_nonscroll(WINDOW GridWin,INTEGER MaxColumn,INTEGER NoScrollLeftColumn,INTEGER NoScrollRightColumn)
clauses
  grid_get_right_nonscroll(GridWin,MaxColumn,NoScrollLeftColumn,NoScrollRightColumn):-
	Rect = grid_my_win_GetClientRect(GridWin),
	Rect = rct(L,_,R,_),
	grid_get_noscroll_width(GridWin,NoScrollLeftColumn,NoScrollWidth),
	grid_row_info(GridWin,_,LeftTitleWidth,_,_,_,_,_),
	Width = R - L - NoScrollWidth - LeftTitleWidth,
	grid_get_right_nonscroll1(GridWin,Width,MaxColumn,NoScrollRightColumn1),
	grid_column_stat(GridWin,_,MaxColumn,ML,MR,_,_,_,_,_),
	LastLength = MR - ML,!,
	grid_adjust_NoScrollRightColumn(Width,LastLength,MaxColumn,NoScrollLeftColumn,NoScrollRightColumn1,NoScrollRightColumn).
  grid_get_right_nonscroll(_,_,_,0).

predicates
procedure grid_change_first_column(WINDOW GridWin,INTEGER FirstColumn,INTEGER NewFirstColumn)
clauses
  grid_change_first_column(_,FirstColumn,FirstColumn):-!.
  grid_change_first_column(GridWin,_,NewFirstColumn):-
	retract(grid_column_info(GridWin,MaxColumn,GRID_COLUMNLIST,_,LastColumn,NoScrollColumns)),
	assert(grid_column_info(GridWin,MaxColumn,GRID_COLUMNLIST,NewFirstColumn,LastColumn,NoScrollColumns)),
	win_Invalidate(GridWin),!.
  grid_change_first_column(_,_,_).

predicates
determ  grid_get_area_range(WINDOW GridWin,INTEGER Row,INTEGER Column)
clauses
  grid_set_vscroll_range(GridWin):-
	grid_vscroll_info(GridWin,b_true,VW,_,_),
	grid_get_area_range(GridWin,Row,_),
	grid_row_info(GridWin,MaxRow,_,_,_,_,FirstRow,_),
	Range = MaxRow - Row + 2,
	win_SetScrollRange(VW,sb_Ctl,1,Range),
	win_SetScrollPos(VW,sb_Ctl,FirstRow),
	retractall(grid_vscroll_info(GridWin,_,_,_,_)),
	assert(grid_vscroll_info(GridWin,b_true,VW,FirstRow,Range)),!.
  grid_set_vscroll_range(_).
  grid_set_hscroll_range(GridWin):-
	grid_hscroll_info(GridWin,b_true,HW,_,_),
	grid_column_info(GridWin,MaxColumn,_,FirstColumn,_,NoScrollColumn),
	grid_get_right_nonscroll(GridWin,MaxColumn,NoScrollColumn,NoScrollRightColumn),
	Range = MaxColumn - NoScrollColumn - NoScrollRightColumn,
	FirstColumn1 = MaxColumn - NoScrollRightColumn,
	NewFirstColumn1 = grid_min(FirstColumn,FirstColumn1),
	NewFirstColumn = grid_max(NewFirstColumn1,NoScrollColumn),
	win_SetScrollRange(HW,sb_Ctl,1,Range),
	Pos = NewFirstColumn - NoScrollColumn,
	win_SetScrollPos(HW,sb_Ctl,Pos),
	retractall(grid_hscroll_info(GridWin,_,_,_,_)),
	assert(grid_hscroll_info(GridWin,b_true,HW,Pos,Range)),
	grid_change_first_column(GridWin,FirstColumn,NewFirstColumn),!.
  grid_set_hscroll_range(GridWin):-
	grid_hscroll_info(GridWin,b_true,HW,_,_),
	grid_column_info(GridWin,MaxColumn,_,_,_,NoScrollColumn),
	win_SetScrollRange(HW,sb_Ctl,1,1),
	win_SetScrollPos(HW,sb_Ctl,1),
	win_SetState(HW,[wsf_Disabled]),
	NewFirstColumn = NoScrollColumn + 1,
	retractall(grid_hscroll_info(GridWin,_,_,_,_)),
	assert(grid_hscroll_info(GridWin,b_true,HW,1,1)),
	retract(grid_column_info(GridWin,MaxColumn,GRID_COLUMNLIST,_,LastColumn,NoScrollColumns)),
	assert(grid_column_info(GridWin,MaxColumn,GRID_COLUMNLIST,NewFirstColumn,LastColumn,NoScrollColumns)),
	win_Invalidate(GridWin),!.
  grid_set_hscroll_range(_).

predicates
procedure  grid_get_row_range(WINDOW GridWin,INTEGER Row)
clauses
  grid_get_row_range(GridWin,Row):-
	RCT = grid_my_win_GetClientRect(GridWin),
	RCT = rct(_,_,_,B),
	grid_convert(GridWin,grid_y(B),grid_row(Row1),_),
	grid_row_info(GridWin,_,_,_,_,_,FirstRow,_),
	Row = Row1 - FirstRow + 1,!.
  grid_get_row_range(_,0).

predicates
procedure  grid_get_column_range(WINDOW GridWin,INTEGER Column)
clauses
  grid_get_column_range(GridWin,Column):-
	RCT = grid_my_win_GetClientRect(GridWin),
	RCT = rct(_,_,R,_),
	grid_convert(GridWin,grid_x(R),grid_column(Column1),_),
	grid_column_info(GridWin,_,_,FirstColumn,_,_),
	Column = Column1 - FirstColumn + 1,!.
  grid_get_column_range(_,0).

  grid_get_area_range(GridWin,Row,Column):-
	grid_get_row_range(GridWin,Row),
	grid_get_column_range(GridWin,Column),!.

  grid_my_win_GetClientRect(GridWin,rct(L,T,R1,B1)):-
	grid_vscroll_info(GridWin,b_true,_,_,_),
	grid_hscroll_info(GridWin,b_true,_,_,_),
	RCT = win_GetClientRect(GridWin),
	RCT = rct(L,T,R,B),
	Y = win_GetAttrVal(GridWin,attr_ctl_horz_sbar_height),
	X = win_GetAttrVal(GridWin,attr_ctl_vert_sbar_width),
	R1 = R - X,
	B1 = B - Y,!.
  grid_my_win_GetClientRect(GridWin,rct(L,T,R1,B)):-
	grid_vscroll_info(GridWin,b_true,_,_,_),
	RCT = win_GetClientRect(GridWin),
	RCT = rct(L,T,R,B),
	X = win_GetAttrVal(GridWin,attr_ctl_vert_sbar_width),
	R1 = R - X,!.
  grid_my_win_GetClientRect(GridWin,rct(L,T,R,B1)):-
	grid_hscroll_info(GridWin,b_true,_,_,_),
	RCT = win_GetClientRect(GridWin),
	RCT = rct(L,T,R,B),
	Y = win_GetAttrVal(GridWin,attr_ctl_horz_sbar_height),
	B1 = B - Y,!.
  grid_my_win_GetClientRect(GridWin,RCT):-
	RCT = win_GetClientRect(GridWin).

predicates
  procedure grid_get_ActiveRow_init(INTEGER MaxRow,INTEGER ActiveRow)
clauses
  grid_get_ActiveRow_init(0,0):-!.
  grid_get_ActiveRow_init(_,1).

predicates
procedure  grid_listlength(GRID_COLUMN_LIST,INTEGER)
procedure  grid_build_column_list(WINDOW GridWin,INTEGER X,INTEGER N,GRID_COLUMN_LIST)
determ  grid_build_column_list1(WINDOW GridWin,INTEGER Column,GRID_COLUMN_LIST,GRID_COLUMN_LIST)
procedure  grid_set_first_column(INTEGER NoScrollColumns,INTEGER FirstColumn,INTEGER NoScrollColumnsNew)

clauses
  grid_get_param(GridWin,grid_style(CellStyle,DefaultColor,BgColor,FrColor,BgTitleColor,FgTitleColor),
		grid_rowstyle(LeftTitleWidth,MaxRow,MaxLine,NumberStyle,ActiveRowPointer),
		grid_columnstyle(NoScrollColumns,ColomnStyleList)):-
	win_GetFontMetrics(GridWin,_,Ascent,Descent),
	TopTitleHeight = Ascent + Descent + grid_row_height,
	RowHeight = (Ascent + Descent) * MaxLine + grid_row_height,
	grid_build_column_list(GridWin,0,1,ColomnStyleList),
	grid_listlength(ColomnStyleList,MaxColumn),
	MaxNoScrollColumns = MaxColumn - 1,
	NewNoScrollColumns = grid_min(NoScrollColumns,MaxNoScrollColumns),
	grid_set_first_column(NewNoScrollColumns,FirstColumn,NoScrollColumnsNew),
	grid_get_ActiveRow_init(MaxRow,ActiveRow),
	assert(grid_view_info(GridWin,CellStyle,NumberStyle,ActiveRowPointer,ActiveRow,DefaultColor,BgColor,FrColor,BgTitleColor,FgTitleColor,b_false)),
	assert(grid_row_info(GridWin,MaxRow,LeftTitleWidth,TopTitleHeight,RowHeight,MaxLine,ActiveRow,MaxRow)),
	assert(grid_column_info(GridWin,MaxColumn,ColomnStyleList,FirstColumn,MaxColumn,NoScrollColumnsNew)),!.

  grid_set_first_column(NoScrollColumns,1,0):-
	NoScrollColumns < 1,!.
  grid_set_first_column(NoScrollColumns,FirstColumn,NoScrollColumns):-
	FirstColumn = NoScrollColumns + 1,!.

  grid_set_last_RowColumn(GridWin):-
	grid_get_area_range(GridWin,ScRow,ScColumn),
	retract(grid_row_info(GridWin,MaxRow,LeftTitleWidth,TopTitleHeight,RowHeight,MaxLine,FirstRow,_)),
	retract(grid_column_info(GridWin,MaxColumn,List,FirstColumn,_,NoScrollColumns)),
	LastRow1 = FirstRow + ScRow - 1,
	LastColumn1 = FirstColumn + ScColumn - 1,
	LastRow = grid_min(MaxRow,LastRow1),
	LastColumn = grid_min(MaxColumn,LastColumn1),
	assert(grid_row_info(GridWin,MaxRow,LeftTitleWidth,TopTitleHeight,RowHeight,MaxLine,FirstRow,LastRow)),
	assert(grid_column_info(GridWin,MaxColumn,List,FirstColumn,LastColumn,NoScrollColumns)),!.

  grid_min(X1,X2,X1):-
	X1 < X2,!.
  grid_min(_,X2,X2).

  grid_min1(X1,X2,X1):-
	X1 < X2,!.
  grid_min1(_,X2,X2).

  grid_max(X1,X2,X1):-
	X1 > X2,!.
  grid_max(_,X2,X2).

  grid_max1(X1,X2,X1):-
	X1 > X2,!.
  grid_max1(_,X2,X2).

  grid_listlength([],0):-!.
  grid_listlength([_|T],N1):-
	grid_listlength(T,N),
	N1=N+1,!.
  grid_listlength(_,0):-errorexit().

  grid_build_column_list(_,_,_,[]):-!.
  grid_build_column_list(GridWin,X,N,[grid_col(Title,Length,HorMargin,VertMargin,DX,DY,MaxText)|Rest]):-
	X1 = X + Length,
	assert(grid_column_stat(GridWin,Title,N,X,X1,HorMargin,VertMargin,DX,DY,MaxText)),
	N1 = N + 1,!,
	grid_build_column_list(GridWin,X1,N1,Rest).
  grid_build_column_list(_,_,_,_):-errorexit().

/*************************************************************************
			     EVENT HANDLER
 *************************************************************************/
predicates
procedure  grid_handle_update(WINDOW GridWin,RCT)
procedure  grid_clear_subwin(WINDOW GridWin,RCT,COLOR,COLOR)
determ  grid_get_resize_area(WINDOW GridWin,INTEGER X,INTEGER Y,INTEGER Column)
determ  grid_get_central_area(WINDOW GridWin,INTEGER X,INTEGER Y,INTEGER Row,INTEGER Column)
determ  grid_get_lt_area(WINDOW GridWin,INTEGER X,INTEGER Y)
determ  grid_get_left_area(WINDOW GridWin,INTEGER X,INTEGER Y,INTEGER Row)
determ  grid_get_top_area(WINDOW GridWin,INTEGER X,INTEGER Y,INTEGER Column)
procedure  grid_vscroll_handler(WINDOW GridWin,SCROLLCODE Control,INTEGER Pos)
procedure  grid_hscroll_handler(WINDOW GridWin,SCROLLCODE Control,INTEGER Pos)
procedure  grid_draw_resize_line(WINDOW GridWin,INTEGER X)
determ  grid_replace_column_size(WINDOW GridWin,INTEGER Column,INTEGER X)

determ  grid_refresh_edit_marker(WINDOW GridWin)
procedure grid_refresh_markers(WINDOW GridWin)

determ  grid_create_cell_marker(WINDOW GridWin,INTEGER Row,INTEGER Column)
determ  grid_create_cell_marker1(WINDOW GridWin)
determ  grid_remove_cell_marker(WINDOW GridWin)
determ  grid_remove_cell_marker1(WINDOW GridWin)

procedure  grid_create_lbb_marker(WINDOW GridWin,INTEGER Row,INTEGER Column,SLIST InitStr,STRING InitString)
procedure  grid_create_lbb_marker1(WINDOW GridWin)

procedure  grid_create_lbe_marker(WINDOW GridWin,INTEGER Row,INTEGER Column,SLIST InitStr,STRING InitString)
procedure  grid_create_lbe_marker1(WINDOW GridWin)

procedure  grid_create_custom_marker(WINDOW GridWin,INTEGER Row,INTEGER Column,STRING ClassName,
  	CTL_FLAGS Ctl_Flags,GRID_PUT_CUSTOM_DATA,GRID_GET_CUSTOM_DATA,STRING InitString)
determ  grid_create_custom_marker1(WINDOW GridWin)

procedure  grid_create_edit_marker(WINDOW GridWin,INTEGER Row,INTEGER Column)
procedure  grid_create_edit_marker_init(WINDOW GridWin,INTEGER Row,INTEGER Column,STRING InitString)
procedure  grid_create_edit_marker1(WINDOW GridWin)

determ  grid_create_all_marker(WINDOW GridWin)
determ  grid_remove_all_marker(WINDOW GridWin)

procedure  grid_create_row_marker(WINDOW GridWin)
determ  grid_remove_row_marker(WINDOW GridWin)
determ  grid_begin_row_marker(WINDOW GridWin,INTEGER Row)
procedure  grid_extend_row_marker(WINDOW GridWin,INTEGER Row)

procedure  grid_create_column_marker(WINDOW GridWin)
determ  grid_remove_column_marker(WINDOW GridWin)
determ  grid_begin_column_marker(WINDOW GridWin,INTEGER Column)
procedure  grid_extend_column_marker(WINDOW GridWin,INTEGER Column)

procedure  grid_create_area_marker(WINDOW GridWin)
determ  grid_remove_area_marker(WINDOW GridWin)
determ  grid_begin_area_marker(WINDOW GridWin,INTEGER Row,INTEGER Column)
determ  grid_extend_area_marker(WINDOW GridWin,INTEGER Row,INTEGER Column)

procedure  grid_check_scroll(WINDOW GridWin,INTEGER EdRow,INTEGER EdColumn)

determ  grid_Rectangle(WINDOW GridWin,RCT)

determ  grid_move_marker(INTEGER Action,INTEGER MaxRowColumn,INTEGER RowColumnRange,GRID_MARKER InMarker,GRID_MARKER OutMarker)
determ grid_send_marker_beg(WINDOW GridWin,GRID_MARKER OutMarker)

clauses
  grid_Rectangle(GridWin,RCT):-
	bound(RCT),
	retract(grid_info(GridWin,_,CallBackFunc,ParentWin)),
	assert(grid_info(GridWin,RCT,CallBackFunc,ParentWin)),
	retractall(grid_ignore_size),
	assert(grid_ignore_size),
	grid_resize_grid(GridWin),
	retractall(grid_ignore_size),
	grid_set_last_RowColumn(GridWin),
	grid_create_scroll_bar(GridWin),
	retractall(grid_nocalc_clear_area),
	assert(grid_nocalc_clear_area),
	win_Invalidate(GridWin),
	grid_refresh_edit_marker(GridWin),!.
  grid_Rectangle(GridWin,RCT):-
	free(RCT),
	grid_info(GridWin,RCT,_,_),!.

predicates
determ  grid_check_marker_callback(GRIDMESS)
clauses
  grid_check_marker_callback(_):-
	not(grid_no_marker_callback),!.
  grid_check_marker_callback(user_action(grid_marker(_,b_true))):-!,fail.
  grid_check_marker_callback(user_action(grid_row_marker_beg(_))):-!,fail.
  grid_check_marker_callback(user_action(grid_col_marker_beg(_))):-!,fail.
  grid_check_marker_callback(user_action(grid_area_marker_beg(_,_))):-!,fail.
  grid_check_marker_callback(user_action(grid_all_marker_beg)):-!,fail.
  grid_check_marker_callback(user_action(grid_edit_cell_beg(_,_))):-!,fail.
  grid_check_marker_callback(_).

  grid_check_callback(GridWin,Mess):-
	grid_check_marker_callback(Mess),
	grid_info(GridWin,_,Callbackfunc,_),
	Callbackfunc(GridWin,Mess,Answer),
	Answer = event_answer(stop),!,fail.
  grid_check_callback(_,_).

  grid_check_callback_nofail(GridWin,Mess):-
	grid_info(GridWin,_,Callbackfunc,_),
	Callbackfunc(GridWin,Mess,_),!.
  grid_check_callback_nofail(_,_).

predicates
procedure  grid_change_current_edit_value(WINDOW GridWin,STRING)
clauses
  grid_change_current_edit_value(GridWin,String):-
	retract(grid_edit(GridWin,grid_edit_id,CtrlWin,Row,Column,_,InitStr)),
	assert(grid_edit(GridWin,grid_edit_id,CtrlWin,Row,Column,String,InitStr)),!.
  grid_change_current_edit_value(GridWin,String):-
	retract(grid_edit(GridWin,grid_lbe_id,CtrlWin,Row,Column,_,InitStr)),
	assert(grid_edit(GridWin,grid_lbe_id,CtrlWin,Row,Column,String,InitStr)),!.
  grid_change_current_edit_value(GridWin,String):-
	retract(grid_edit(GridWin,grid_custom_id,CtrlWin,Row,Column,_,InitStr)),
	assert(grid_edit(GridWin,grid_custom_id,CtrlWin,Row,Column,String,InitStr)),!.
  grid_change_current_edit_value(_,_).

predicates
procedure  grid_SetFocus(WINDOW GridWin)
clauses
  grid_SetFocus(GridWin):-
	trap(win_SetFocus(GridWin),_,fail),!.
  grid_SetFocus(_).

predicates
procedure  grid_draw_markers(WINDOW GridWin,INTEGER FromRow,INTEGER ToRow,INTEGER FromColumn,INTEGER ToColumn)
procedure  grid_draw_first_border(WINDOW GridWin)
clauses
  grid_draw_first_border(GridWin):-
	grid_row_info(GridWin,_,_,_,_,_,FirstRow,LastRow),
	grid_column_info(GridWin,_,_,FirstColumn,LastColumn,0),!,
	grid_draw_markers(GridWin,FirstRow,LastRow,FirstColumn,LastColumn).
  grid_draw_first_border(GridWin):-
	grid_row_info(GridWin,_,_,_,_,_,FirstRow,LastRow),
	grid_column_info(GridWin,_,_,_,LastColumn,_),!,
	grid_draw_markers(GridWin,FirstRow,LastRow,1,LastColumn).
  grid_draw_first_border(_).

predicates
procedure  grid_move_edit_max(WINDOW ControlWin)
clauses
  grid_HandleEvent(GridWin,EVENT):-
	not(grid_check_callback(GridWin,event(EVENT))),!.

  grid_HandleEvent(_,e_CloseRequest):-!.

  grid_HandleEvent(GridWin,e_MouseDown(_,_,_)):-
	grid_SetFocus(GridWin),
	fail.

  grid_HandleEvent(_,e_EraseBackground()):-!.
/*************************************************************************
			     FOCUS
 *************************************************************************/
ifdef ws_win
  grid_HandleEvent(GridWin,e_GetFocus):-
	grid_edit(GridWin,_,CtrlWin,_,_,_,_),!,
	grid_SetFocus(CtrlWin),
	fail.
enddef

/*************************************************************************
			     DESTROY
 *************************************************************************/
  grid_HandleEvent(GridWin,e_Destroy):-
	grid_info(GridWin,_,_,_),
	grid_remove_markers(GridWin,grid_single_marker),
	retract(grid_info(GridWin,_,_,_)),
	retractall(grid_view_info(GridWin,_,_,_,_,_,_,_,_,_,_)),
	retractall(grid_row_info(GridWin,_,_,_,_,_,_,_)),
	retractall(grid_column_info(GridWin,_,_,_,_,_)),
	retractall(grid_column_stat(GridWin,_,_,_,_,_,_,_,_,_)),
	retractall(grid_vscroll_info(GridWin,_,_,_,_)),
	retractall(grid_hscroll_info(GridWin,_,_,_,_)),
	retractall(grid_resize(GridWin,_,_,_,_)),
	retractall(grid_visit_order(GridWin,_,_,_)),!.
/*************************************************************************
			     UPDATE
 *************************************************************************/
  grid_HandleEvent(GridWin,e_User(0,0)):-
	grid_draw_first_border(GridWin),!.
  grid_HandleEvent(GridWin,e_Update(RCT)):-
	grid_view_info(GridWin,_,_,_,_,DefColor,BgColor,_,_,_,_),
	RCT = rct(L,T,R,B),
	L1 = L - 1, T1 = T - 1, R1 = R + 1, B1 = B + 1,
	RCT1 = rct(L1,T1,R1,B1),
	grid_clear_subwin(GridWin,RCT1,BgColor,DefColor),
	grid_handle_update(GridWin,RCT1),
	win_PostEvent(GridWin,e_User(0,0)),!.
/*************************************************************************
			     MOVE
 *************************************************************************/
  grid_HandleEvent(GridWin,e_Move(L,T)):-
	RCT = win_GetClientRect(GridWin),
	RCT = rct(_,_,WW,HW),
	R = L + WW, B = T + HW,
	grid_rectangle(GridWin,rct(L,T,R,B)),!.
/*************************************************************************
			     SIZE
 *************************************************************************/
  grid_HandleEvent(GridWin,e_Size(Width,Height)):-
	not(grid_ignore_size),
	RCT = win_GetOuterRect(GridWin),
	RCT = rct(L,T,_,_),
	R = L + Width, B = T + Height,
	grid_rectangle(GridWin,rct(L,T,R,B)),!.
/*************************************************************************
			     FONT
 *************************************************************************/
  grid_HandleEvent(GridWin,e_State(font(_Font))):-
	retract(grid_row_info(GridWin,MaxRow,LeftTitleWidth,_,_,MaxLine,FirstRow,LastRow)),
	win_GetFontMetrics(GridWin,_,Ascent,Descent),
	TopTitleHeight = Ascent + Descent + grid_row_height,
	RowHeight = (Ascent + Descent) * MaxLine + grid_row_height,
	assert(grid_row_info(GridWin,MaxRow,LeftTitleWidth,TopTitleHeight,RowHeight,MaxLine,FirstRow,LastRow)),
	grid_resize_grid(GridWin),
	grid_set_last_RowColumn(GridWin),
	grid_create_scroll_bar(GridWin),
	grid_Invalidate_my(GridWin,grid_all),
	grid_refresh_edit_marker(GridWin),!.

/*************************************************************************
			     DISABLED
 *************************************************************************/
  grid_HandleEvent(GridWin,e_State(disabled())):-
	grid_edit(GridWin,_,CtrlWin,_,_,_,_),
	win_SetState(CtrlWin,[wsf_Disabled]),!.

/*************************************************************************
			     ENABLED
 *************************************************************************/
  grid_HandleEvent(GridWin,e_State(enabled())):-
	grid_edit(GridWin,_,CtrlWin,_,_,_,_),
	win_SetState(CtrlWin,[wsf_Enabled]),!.

/*************************************************************************
			     RESIZE COLUMN
 *************************************************************************/
  grid_HandleEvent(GridWin,e_MouseDown(pnt(X,Y),c_Nothing,mouse_button_left)):-
	grid_resize(GridWin,b_false,b_false,_,_),
	grid_get_resize_area(GridWin,X,Y,Column),
	win_CaptureMouse(GridWin),
	grid_draw_resize_line(GridWin,X),
	retract(grid_resize(GridWin,_,_,_,_)),
	assert(grid_resize(GridWin,b_false,b_true,Column,X)),!.
  grid_HandleEvent(GridWin,e_MouseUp(pnt(_,_),_,mouse_button_left)):-
	grid_resize(GridWin,b_false,b_true,Column,X),
	grid_draw_resize_line(GridWin,X),
	grid_convert(GridWin,grid_column(Column),grid_lr(_,X1,_,_,_,_,_,_),_),
	DX = X - X1,
	grid_replace_column_size(GridWin,Column,DX),
	grid_refresh_edit_marker(GridWin),
	retract(grid_resize(GridWin,_,_,_,_)),
	assert(grid_resize(GridWin,b_false,b_false,1,0)),
	win_ReleaseMouse(),
	grid_check_callback(GridWin,user_action(grid_resize_column(Column,DX))),!.
  grid_HandleEvent(GridWin,e_MouseMove(pnt(X,_),_,_)):-
	grid_resize(GridWin,b_false,b_true,Column,X1),
	grid_convert(GridWin,grid_column(Column),grid_lr(X21,_,_,_,_,_,_,_),_),
	X2 = X21 + 0,
	RCT = grid_my_win_GetClientRect(GridWin),
	RCT = rct(_,_,X31,_),
	X3 = X31 - 2,
	X4 = grid_max(X,X2),
	X5 = grid_min(X4,X3),
	X1 <> X5,
	grid_draw_resize_line(GridWin,X1),
	grid_draw_resize_line(GridWin,X5),
	retract(grid_resize(GridWin,_,_,_,_)),
	assert(grid_resize(GridWin,b_false,b_true,Column,X5)),!.
  grid_HandleEvent(GridWin,e_MouseMove(pnt(X,Y),_,_)):-
	grid_resize(GridWin,b_true,b_false,_,_),
	grid_get_resize_area(GridWin,X,Y,Column),
	grid_check_callback(GridWin,user_action(grid_resize_column_beg(Column))),
	retract(grid_resize(GridWin,_,_,_,_)),
	assert(grid_resize(GridWin,b_false,b_false,1,0)),
	cursor_Set(GridWin,cursor_SizeWE),!.
  grid_HandleEvent(GridWin,e_MouseMove(pnt(X,Y),_,_)):-
	grid_resize(GridWin,b_false,b_false,_,_),
	not(grid_get_resize_area(GridWin,X,Y,_)),
	retract(grid_resize(GridWin,_,_,_,_)),
	assert(grid_resize(GridWin,b_true,b_false,1,0)),
	cursor_Set(GridWin,cursor_Arrow),!.
/*************************************************************************
			     EDIT MARKER
 *************************************************************************/
  grid_HandleEvent(GridWin,e_MouseDbl(pnt(X,Y),c_Nothing,mouse_button_left)):-
	grid_get_central_area(GridWin,X,Y,Row,Column),
	grid_check_callback(GridWin,user_action(grid_edit_cell_beg(Row,Column))),
	grid_remove_markers(GridWin,grid_single_marker),
	grid_create_cell_marker(GridWin,Row,Column),!.
  grid_HandleEvent(_GridWin,e_Control(grid_lbb_id,_,CtrlWin,selchanged)):-
	Pos =  lbox_GetSelIndex(CtrlWin),
	String = lbox_GetItem(CtrlWin,Pos),
	retract(grid_edit(GridWin,CtlId,CtrlWin,Row,Column,_,InitStr)),
	assert(grid_edit(GridWin,CtlId,CtrlWin,Row,Column,String,InitStr)),
	grid_check_callback_nofail(GridWin,user_action(modified(Row,Column,String))),!.
  grid_HandleEvent(_GridWin,e_Control(grid_lbe_id,_,CtrlWin,selchanged)):-
	Pos =  lbox_GetSelIndex(CtrlWin),
	String = lbox_GetItem(CtrlWin,Pos),
	retract(grid_edit(GridWin,CtlId,CtrlWin,Row,Column,_,InitStr)),
	assert(grid_edit(GridWin,CtlId,CtrlWin,Row,Column,String,InitStr)),
	grid_check_callback_nofail(GridWin,user_action(modified(Row,Column,String))),!.
  % We need to use PostEvents here to avoid GPF (due to VPI error).
  grid_HandleEvent(GridWin,e_Control(grid_lbe_id,_,ControlWin,modified())):-
	retractall(grid_move_edit_max_post(_)),
	assert(grid_move_edit_max_post(ControlWin)),
	win_PostEvent(GridWin,e_User(777,777)),!.
  grid_HandleEvent(GridWin,e_Control(grid_edit_id,_,ControlWin,modified())):-
	retractall(grid_move_edit_max_post(_)),
	assert(grid_move_edit_max_post(ControlWin)),
	win_PostEvent(GridWin,e_User(777,777)),!.
  grid_HandleEvent(_,e_User(777,777)):-
	retract(grid_move_edit_max_post(ControlWin)),
	grid_move_edit_max(ControlWin),!.
/*************************************************************************
			     ALL MARKER
 *************************************************************************/
  grid_HandleEvent(GridWin,e_MouseDown(pnt(X,Y),c_Nothing,mouse_button_left)):-
	grid_get_lt_area(GridWin,X,Y),
	grid_all(GridWin),
	grid_remove_markers(GridWin,grid_single_marker),!.
  grid_HandleEvent(GridWin,e_MouseDown(pnt(X,Y),c_Nothing,mouse_button_left)):-
	grid_get_lt_area(GridWin,X,Y),
	grid_check_callback(GridWin,user_action(grid_all_marker_beg)),
	grid_remove_markers(GridWin,grid_single_marker),
	grid_check_callback(GridWin,user_action(grid_marker(grid_all_marker,b_true))),
	grid_create_all_marker(GridWin),!.
/*************************************************************************
			     ROW MARKER
 *************************************************************************/
  grid_HandleEvent(GridWin,e_MouseDown(pnt(X,Y),c_Shift,mouse_button_left)):-
	grid_get_left_area(GridWin,X,Y,ToRow),
	grid_row(GridWin,RowList),
	RowList = [gl(Row1,Row2)],
	Row1 = Row2,
	Row1 <= ToRow,
	grid_check_callback(GridWin,user_action(grid_row_marker_beg(Row1))),
	grid_remove_markers(GridWin,grid_single_marker),
	grid_begin_row_marker(GridWin,Row1),
	grid_extend_row_marker(GridWin,ToRow),
	grid_create_row_marker(GridWin),!.
  grid_HandleEvent(GridWin,e_MouseDown(pnt(X,Y),c_Control,mouse_button_left)):-
	grid_get_left_area(GridWin,X,Y,Row),
	grid_check_callback(GridWin,user_action(grid_row_marker_beg(Row))),
	grid_remove_markers(GridWin,grid_rows_marker),
	grid_begin_row_marker(GridWin,Row),
	retractall(grid_mouse_pressed(GridWin)),
	assert(grid_mouse_pressed(GridWin)),
	win_CaptureMouse(GridWin),!.
  grid_HandleEvent(GridWin,e_MouseDown(pnt(X,Y),c_Nothing,mouse_button_left)):-
	grid_get_left_area(GridWin,X,Y,Row),
	grid_check_callback(GridWin,user_action(grid_row_marker_beg(Row))),
	grid_remove_markers(GridWin,grid_single_marker),
	grid_begin_row_marker(GridWin,Row),
	retractall(grid_mouse_pressed(GridWin)),
	assert(grid_mouse_pressed(GridWin)),
	win_CaptureMouse(GridWin),!.
  grid_HandleEvent(GridWin,e_MouseUp(pnt(_,_),_,mouse_button_left)):-
	grid_row(GridWin,_),
	retract(grid_mouse_pressed(GridWin)),
	win_ReleaseMouse(),
	grid_create_row_marker(GridWin),!.
  grid_HandleEvent(GridWin,e_MouseMove(pnt(_,Y),_,_)):-
	grid_mouse_pressed(GridWin),
	grid_row(GridWin,_),
	grid_convert(GridWin,grid_y(Y),grid_row(Row),_),
	grid_extend_row_marker(GridWin,Row),!.
/*************************************************************************
			     COLUMN MARKER
 *************************************************************************/
  grid_HandleEvent(GridWin,e_MouseDown(pnt(X,Y),c_Shift,mouse_button_left)):-
	grid_get_top_area(GridWin,X,Y,ToColumn),
	grid_column(GridWin,ColumnList),
	ColumnList = [gl(Column1,Column2)],
	Column1 = Column2,
	Column1 <= ToColumn,
	grid_check_callback(GridWin,user_action(grid_col_marker_beg(Column1))),
	grid_remove_markers(GridWin,grid_single_marker),
	grid_begin_column_marker(GridWin,Column1),
	grid_extend_column_marker(GridWin,ToColumn),
	grid_create_column_marker(GridWin),!.
  grid_HandleEvent(GridWin,e_MouseDown(pnt(X,Y),c_Control,mouse_button_left)):-
	grid_get_top_area(GridWin,X,Y,Column),
	grid_check_callback(GridWin,user_action(grid_col_marker_beg(Column))),
	grid_remove_markers(GridWin,grid_columns_marker),
	grid_begin_column_marker(GridWin,Column),
	retractall(grid_mouse_pressed(GridWin)),
	assert(grid_mouse_pressed(GridWin)),
	win_CaptureMouse(GridWin),!.
  grid_HandleEvent(GridWin,e_MouseDown(pnt(X,Y),c_Nothing,mouse_button_left)):-
	grid_get_top_area(GridWin,X,Y,Column),
	grid_check_callback(GridWin,user_action(grid_col_marker_beg(Column))),
	grid_remove_markers(GridWin,grid_single_marker),
	grid_begin_column_marker(GridWin,Column),
	retractall(grid_mouse_pressed(GridWin)),
	assert(grid_mouse_pressed(GridWin)),
	win_CaptureMouse(GridWin),!.
  grid_HandleEvent(GridWin,e_MouseUp(pnt(_,_),_,mouse_button_left)):-
	grid_column(GridWin,_),
	retract(grid_mouse_pressed(GridWin)),
	win_ReleaseMouse(),
	grid_create_column_marker(GridWin),!.
  grid_HandleEvent(GridWin,e_MouseMove(pnt(X,_),_,_)):-
	grid_mouse_pressed(GridWin),
	grid_column(GridWin,_),
	grid_convert(GridWin,grid_x(X),grid_column(Column),_),
	grid_extend_column_marker(GridWin,Column),!.

/*************************************************************************
			     AREA MARKER
 *************************************************************************/
  grid_HandleEvent(GridWin,e_MouseDown(pnt(X,Y),c_Shift,mouse_button_left)):-
	grid_get_central_area(GridWin,X,Y,ToRow,ToColumn),
	grid_area(GridWin,GridCellList),
	GridCellList = [ga(Row1,Row2,Column1,Column2)],
	Row1 = Row2, Column1 = Column2,
	Row1 <= ToRow, Column1 <= ToColumn,
	grid_check_callback(GridWin,user_action(grid_area_marker_beg(Row1,Column1))),
	grid_remove_markers(GridWin,grid_single_marker),
	grid_begin_area_marker(GridWin,Row1,Column1),
	grid_extend_area_marker(GridWin,ToRow,ToColumn),
	grid_create_area_marker(GridWin),!.
  grid_HandleEvent(GridWin,e_MouseDown(pnt(X,Y),c_Control,mouse_button_left)):-
	grid_get_central_area(GridWin,X,Y,Row,Column),
	grid_check_callback(GridWin,user_action(grid_area_marker_beg(Row,Column))),
	grid_remove_markers(GridWin,grid_areas_marker),
	grid_begin_area_marker(GridWin,Row,Column),
	retractall(grid_mouse_pressed(GridWin)),
	assert(grid_mouse_pressed(GridWin)),
	win_CaptureMouse(GridWin),!.
  grid_HandleEvent(GridWin,e_MouseDown(pnt(X,Y),c_Nothing,mouse_button_left)):-
	grid_get_central_area(GridWin,X,Y,Row,Column),
	grid_check_callback(GridWin,user_action(grid_area_marker_beg(Row,Column))),
	grid_remove_markers(GridWin,grid_single_marker),
	grid_begin_area_marker(GridWin,Row,Column),
	retractall(grid_mouse_pressed(GridWin)),
	assert(grid_mouse_pressed(GridWin)),
	win_CaptureMouse(GridWin),!.
  grid_HandleEvent(GridWin,e_MouseUp(pnt(_,_),_,mouse_button_left)):-
	grid_area(GridWin,_),
	retract(grid_mouse_pressed(GridWin)),
	win_ReleaseMouse(),
	grid_create_area_marker(GridWin),!.
  grid_HandleEvent(GridWin,e_MouseMove(pnt(X,Y),_,_)):-
	grid_mouse_pressed(GridWin),
	grid_area(GridWin,_),
	grid_convert(GridWin,grid_y(Y),grid_row(Row),_),
	grid_convert(GridWin,grid_x(X),grid_column(Column),_),
	grid_extend_area_marker(GridWin,Row,Column),!.

/*************************************************************************
			     MOVE MARKERS
 *************************************************************************/
  grid_HandleEvent(GridWin,e_char(k_down,c_Nothing)):-
	grid_Marker(GridWin,OldMarker),
	grid_row_info(GridWin,MaxRow,_,_,_,_,_,_),
	grid_get_area_range(GridWin,RowRange,_),
	grid_move_marker(grid_move_one_down,MaxRow,RowRange,OldMarker,NewMarker),!,
	grid_send_marker_beg(GridWin,NewMarker),
	assert(grid_no_marker_callback),
	grid_Marker(GridWin,NewMarker),!.
  grid_HandleEvent(GridWin,e_char(k_up,c_Nothing)):-
	grid_Marker(GridWin,OldMarker),
	grid_row_info(GridWin,MaxRow,_,_,_,_,_,_),
	grid_get_area_range(GridWin,RowRange,_),
	grid_move_marker(grid_move_one_up,MaxRow,RowRange,OldMarker,NewMarker),!,
	grid_send_marker_beg(GridWin,NewMarker),
	assert(grid_no_marker_callback),
	grid_Marker(GridWin,NewMarker),!.
  grid_HandleEvent(GridWin,e_Char(k_next,c_Nothing)):-
	grid_Marker(GridWin,OldMarker),
	grid_row_info(GridWin,MaxRow,_,_,_,_,_,_),
	grid_get_area_range(GridWin,RowRange,_),
	grid_move_marker(grid_move_page_down,MaxRow,RowRange,OldMarker,NewMarker),!,
	grid_send_marker_beg(GridWin,NewMarker),
	assert(grid_no_marker_callback),
	grid_Marker(GridWin,NewMarker),!.
  grid_HandleEvent(GridWin,e_Char(k_prev,c_Nothing)):-
	grid_Marker(GridWin,OldMarker),
	grid_row_info(GridWin,MaxRow,_,_,_,_,_,_),
	grid_get_area_range(GridWin,RowRange,_),
	grid_move_marker(grid_move_page_up,MaxRow,RowRange,OldMarker,NewMarker),!,
	grid_send_marker_beg(GridWin,NewMarker),
	assert(grid_no_marker_callback),
	grid_Marker(GridWin,NewMarker),!.
  grid_HandleEvent(GridWin,e_Char(k_next,c_Control)):-
	grid_Marker(GridWin,OldMarker),
	grid_row_info(GridWin,MaxRow,_,_,_,_,_,_),
	grid_get_area_range(GridWin,RowRange,_),
	grid_move_marker(grid_move_down,MaxRow,RowRange,OldMarker,NewMarker),!,
	grid_send_marker_beg(GridWin,NewMarker),
	assert(grid_no_marker_callback),
	grid_Marker(GridWin,NewMarker),!.
  grid_HandleEvent(GridWin,e_Char(k_prev,c_Control)):-
	grid_Marker(GridWin,OldMarker),
	grid_row_info(GridWin,MaxRow,_,_,_,_,_,_),
	grid_get_area_range(GridWin,RowRange,_),
	grid_move_marker(grid_move_up,MaxRow,RowRange,OldMarker,NewMarker),!,
	grid_send_marker_beg(GridWin,NewMarker),
	assert(grid_no_marker_callback),
	grid_Marker(GridWin,NewMarker),!.
  grid_HandleEvent(GridWin,e_char(k_down,c_Shift)):-
	grid_Marker(GridWin,OldMarker),
	grid_row_info(GridWin,MaxRow,_,_,_,_,_,_),
	grid_get_area_range(GridWin,RowRange,_),
	grid_move_marker(grid_size_one_down,MaxRow,RowRange,OldMarker,NewMarker),
	assert(grid_no_marker_callback),
	grid_Marker(GridWin,NewMarker),!.
  grid_HandleEvent(GridWin,e_char(k_up,c_Shift)):-
	grid_Marker(GridWin,OldMarker),
	grid_row_info(GridWin,MaxRow,_,_,_,_,_,_),
	grid_get_area_range(GridWin,RowRange,_),
	grid_move_marker(grid_size_one_up,MaxRow,RowRange,OldMarker,NewMarker),
	assert(grid_no_marker_callback),
	grid_Marker(GridWin,NewMarker),!.
  grid_HandleEvent(GridWin,e_Char(k_next,c_Shift)):-
	grid_Marker(GridWin,OldMarker),
	grid_row_info(GridWin,MaxRow,_,_,_,_,_,_),
	grid_get_area_range(GridWin,RowRange,_),
	grid_move_marker(grid_size_page_down,MaxRow,RowRange,OldMarker,NewMarker),
	assert(grid_no_marker_callback),
	grid_Marker(GridWin,NewMarker),!.
  grid_HandleEvent(GridWin,e_Char(k_prev,c_Shift)):-
	grid_Marker(GridWin,OldMarker),
	grid_row_info(GridWin,MaxRow,_,_,_,_,_,_),
	grid_get_area_range(GridWin,RowRange,_),
	grid_move_marker(grid_size_page_up,MaxRow,RowRange,OldMarker,NewMarker),
	assert(grid_no_marker_callback),
	grid_Marker(GridWin,NewMarker),!.
  grid_HandleEvent(GridWin,e_Char(k_next,c_ShiftCtl)):-
	grid_Marker(GridWin,OldMarker),
	grid_row_info(GridWin,MaxRow,_,_,_,_,_,_),
	grid_get_area_range(GridWin,RowRange,_),
	grid_move_marker(grid_size_down,MaxRow,RowRange,OldMarker,NewMarker),
	assert(grid_no_marker_callback),
	grid_Marker(GridWin,NewMarker),!.
  grid_HandleEvent(GridWin,e_Char(k_prev,c_ShiftCtl)):-
	grid_Marker(GridWin,OldMarker),
	grid_row_info(GridWin,MaxRow,_,_,_,_,_,_),
	grid_get_area_range(GridWin,RowRange,_),
	grid_move_marker(grid_size_up,MaxRow,RowRange,OldMarker,NewMarker),
	assert(grid_no_marker_callback),
	grid_Marker(GridWin,NewMarker),!.

  grid_HandleEvent(GridWin,e_char(k_right,c_Nothing)):-
	grid_Marker(GridWin,OldMarker),
	grid_column_info(GridWin,MaxColumn,_,_,_,_),
	grid_move_marker(grid_move_one_right,MaxColumn,0,OldMarker,NewMarker),!,
	grid_send_marker_beg(GridWin,NewMarker),
	assert(grid_no_marker_callback),
	grid_Marker(GridWin,NewMarker),!.
  grid_HandleEvent(GridWin,e_char(k_left,c_Nothing)):-
	grid_Marker(GridWin,OldMarker),
	grid_column_info(GridWin,MaxColumn,_,_,_,_),
	grid_move_marker(grid_move_one_left,MaxColumn,0,OldMarker,NewMarker),!,
	grid_send_marker_beg(GridWin,NewMarker),
	assert(grid_no_marker_callback),
	grid_Marker(GridWin,NewMarker),!.
  grid_HandleEvent(GridWin,e_Char(k_lend,c_Nothing)):-
	grid_Marker(GridWin,OldMarker),
	grid_column_info(GridWin,MaxColumn,_,_,_,_),
	grid_move_marker(grid_move_right,MaxColumn,0,OldMarker,NewMarker),!,
	grid_send_marker_beg(GridWin,NewMarker),
	assert(grid_no_marker_callback),
	grid_Marker(GridWin,NewMarker),!.
  grid_HandleEvent(GridWin,e_Char(k_lhome,c_Nothing)):-
	grid_Marker(GridWin,OldMarker),
	grid_column_info(GridWin,MaxColumn,_,_,_,_),
	grid_move_marker(grid_move_left,MaxColumn,0,OldMarker,NewMarker),!,
	grid_send_marker_beg(GridWin,NewMarker),
	assert(grid_no_marker_callback),
	grid_Marker(GridWin,NewMarker),!.
  grid_HandleEvent(GridWin,e_char(k_right,c_Shift)):-
	grid_Marker(GridWin,OldMarker),
	grid_column_info(GridWin,MaxColumn,_,_,_,_),
	grid_move_marker(grid_size_one_right,MaxColumn,0,OldMarker,NewMarker),
	assert(grid_no_marker_callback),
	grid_Marker(GridWin,NewMarker),!.
  grid_HandleEvent(GridWin,e_char(k_left,c_Shift)):-
	grid_Marker(GridWin,OldMarker),
	grid_column_info(GridWin,MaxColumn,_,_,_,_),
	grid_move_marker(grid_size_one_left,MaxColumn,0,OldMarker,NewMarker),
	assert(grid_no_marker_callback),
	grid_Marker(GridWin,NewMarker),!.
  grid_HandleEvent(GridWin,e_Char(k_lend,c_Shift)):-
	grid_Marker(GridWin,OldMarker),
	grid_column_info(GridWin,MaxColumn,_,_,_,_),
	grid_move_marker(grid_size_right,MaxColumn,0,OldMarker,NewMarker),
	assert(grid_no_marker_callback),
	grid_Marker(GridWin,NewMarker),!.
  grid_HandleEvent(GridWin,e_Char(k_lhome,c_Shift)):-
	grid_Marker(GridWin,OldMarker),
	grid_column_info(GridWin,MaxColumn,_,_,_,_),
	grid_move_marker(grid_size_left,MaxColumn,0,OldMarker,NewMarker),
	assert(grid_no_marker_callback),
	grid_Marker(GridWin,NewMarker),!.

/*************************************************************************
			     SCROLL
 *************************************************************************/
  grid_HandleEvent(GridWin,e_Control(grid_leftbottom_id,_,_,_)):-
	grid_hscroll_handler(GridWin,sc_Top,0),!.
  grid_HandleEvent(GridWin,e_Control(grid_righttop_id,_,_,_)):-
	grid_vscroll_handler(GridWin,sc_Top,0),!.
  grid_HandleEvent(GridWin,e_Control(grid_rightbottom_id,_,_,_)):-
	grid_vscroll_handler(GridWin,sc_Bottom,0),
	grid_hscroll_handler(GridWin,sc_Bottom,0),!.
  grid_HandleEvent(GridWin,e_Control(_,wc_VScroll,_,scroll(Control,Pos))):-
	grid_vscroll_handler(GridWin,Control,Pos),!.
  grid_HandleEvent(GridWin,e_Control(_,wc_HScroll,_,scroll(Control,Pos))):-
	grid_hscroll_handler(GridWin,Control,Pos),!.
  grid_HandleEvent(GridWin,e_Char(k_next,c_Nothing)):-
	grid_vscroll_handler(GridWin,sc_PageDown,0),!.
  grid_HandleEvent(GridWin,e_Char(k_prev,c_Nothing)):-
	grid_vscroll_handler(GridWin,sc_PageUp,0),!.
  grid_HandleEvent(GridWin,e_Char(k_next,c_Control)):-
	grid_vscroll_handler(GridWin,sc_Bottom,0),!.
  grid_HandleEvent(GridWin,e_Char(k_prev,c_Control)):-
	grid_vscroll_handler(GridWin,sc_Top,0),!.
  grid_HandleEvent(GridWin,e_Char(k_lhome,c_Nothing)):-
	grid_hscroll_handler(GridWin,sc_Top,0),!.
  grid_HandleEvent(GridWin,e_Char(k_lend,c_Nothing)):-
	grid_hscroll_handler(GridWin,sc_Bottom,0),!.
  grid_HandleEvent(GridWin,e_char(k_up,c_Nothing)):-
	grid_vscroll_handler(GridWin,sc_LineUp,0),!.
  grid_HandleEvent(GridWin,e_char(k_down,c_Nothing)):-
	grid_vscroll_handler(GridWin,sc_LineDown,0),!.
  grid_HandleEvent(GridWin,e_char(k_left,c_Nothing)):-
	grid_hscroll_handler(GridWin,sc_LineUp,0),!.
  grid_HandleEvent(GridWin,e_char(k_right,c_Nothing)):-
	grid_hscroll_handler(GridWin,sc_LineDown,0),!.
/*************************************************************************
			     OWNERDRAW
 *************************************************************************/
  grid_HandleEvent(GridWin,e_OwnerDraw(od_Button,Control_Id,_,ACTIONLIST,STATELIST,CtlWin,_,_)):-
	grid_ownerdraw_DrawButton(ACTIONLIST,STATELIST,GridWin,CtlWin,Control_Id),!.

/*************************************************************************
			     FROM CELL MARKER TO EDIT CELL
 *************************************************************************/
  grid_HandleEvent(GridWin,e_Char(127,_CSA)):-		% "Delete" key
	grid_area(GridWin,[ga(Row1,Row2,Column1,Column2)]),
	Row1 = Row2, Column1 = Column2,
	grid_check_callback(GridWin,user_action(grid_edit_cell_beg(Row1,Column1))),
	assert(grid_no_marker_callback),
	grid_Marker(GridWin,grid_edit_cell(Row1,Column1)),
	grid_edit(GridWin,_,CtrlWin,Row1,Column1,_,_),
	grid_change_current_edit_value(GridWin,""),
	trap(win_SetText(CtrlWin,""),_,fail),
	trap(win_SelectText(CtrlWin,0,0),_,fail),
	!.
  grid_HandleEvent(GridWin,e_Char(Char,_CSA)):-
	32 <= Char, Char <= 255,
	grid_area(GridWin,[ga(Row1,Row2,Column1,Column2)]),
	Row1 = Row2, Column1 = Column2,
	grid_check_callback(GridWin,user_action(grid_edit_cell_beg(Row1,Column1))),
	assert(grid_no_marker_callback),
	grid_Marker(GridWin,grid_edit_cell(Row1,Column1)),
	grid_edit(GridWin,_,CtrlWin,Row1,Column1,_,_),
	trap(char_int(CharC,Char),_,fail),
	trap(str_char(String,CharC),_,fail),
	grid_change_current_edit_value(GridWin,String),
	trap(win_SetText(CtrlWin,String),_,fail),
	trap(win_SelectText(CtrlWin,1,1),_,fail),
	!.

  grid_HandleEvent(GridWin,e_Menu(0,_)):-
	retract(grid_edit_kill),
	grid_edit(GridWin,_,_,Row,Column,_,_),
	assert(grid_no_marker_callback),
	grid_Marker(GridWin,grid_area_marker([ga(Row,Row,Column,Column)])),!.

/*************************************************************************
			     END EVENT HANDLER
 *************************************************************************/
predicates
procedure  grid_hmove_cells_area(WINDOW GridWin,INTEGER DiffInColumn)
procedure  grid_vmove_cells_area(WINDOW GridWin,INTEGER DiffInRow)
clauses
  grid_check_scroll(GridWin,Row,_):-
	grid_row_info(GridWin,_,_,TopTitleHeight,RowHeight,_,FirstRow,_),
	RCT = grid_my_win_GetClientRect(GridWin),
	RCT = rct(_,T,_,B),
	MinHeight = TopTitleHeight + RowHeight,
	RealHeight = B - T,
	RealHeight <= MinHeight,
	Diff = Row - FirstRow,
	grid_vmove_cells_area(GridWin,Diff),!.
  grid_check_scroll(GridWin,Row,_):-
	grid_row_info(GridWin,_,_,_,_,_,FirstRow,_),
	Row < FirstRow,
	Diff = Row - FirstRow,
	grid_vmove_cells_area(GridWin,Diff),
	fail.
  grid_check_scroll(GridWin,Row,_):-
	grid_row_info(GridWin,_,_,_,_,_,_,LastRow),
	Row >= LastRow,
	Diff = Row - LastRow + 1,
	grid_vmove_cells_area(GridWin,Diff),
	fail.
  grid_check_scroll(GridWin,_,Column):-
	grid_column_info(GridWin,_,_,FirstColumn,_,NoScrollColumn),
	NoScrollColumn < Column, Column < FirstColumn,
	Diff = Column - FirstColumn,
	grid_hmove_cells_area(GridWin,Diff),
	fail.
  grid_check_scroll(GridWin,_,Column):-
	grid_column_info(GridWin,MaxColumn,_,FirstColumn,LastColumn,_),
	Column = LastColumn,
	MaxColumn > 1,
	Column <> FirstColumn,
	Diff = Column - LastColumn + 1,
	grid_hmove_cells_area(GridWin,Diff),
	fail.
  grid_check_scroll(GridWin,_,Column):-
	grid_column_info(GridWin,_,_,_,LastColumn,_),
	Column > LastColumn,
	Diff = Column - LastColumn + 1,
	grid_hmove_cells_area(GridWin,Diff),
	fail.
  grid_check_scroll(_,_,_).

predicates
procedure  grid_replace_column(WINDOW GridWin,INTEGER Num,INTEGER Column,INTEGER DeltaX)
procedure  grid_redraw(WINDOW GridWin)
clauses
  grid_replace_column_size(GridWin,Column,DX):-
	grid_replace_column(GridWin,1,Column,DX),
	grid_create_scroll_bar(GridWin),
	grid_set_last_RowColumn(GridWin),
	Rect = grid_my_win_GetClientRect(GridWin),
	Rect = rct(_,T,R,B),
	grid_convert(GridWin,grid_column(Column),grid_lr(L,_,_,_,_,_,_,_),_),
	win_Invalidate(GridWin,rct(L,T,R,B)),!.

  grid_replace_column(GridWin,Num,Column,DeltaX):-
	Num < Column,
	Num1 = Num + 1,
	grid_replace_column(GridWin,Num1,Column,DeltaX),!.
  grid_replace_column(GridWin,Num,Column,DeltaX):-
	Num = Column,
	retract(grid_column_stat(GridWin,Title,Num,L,R,GridHorAlignment,GridVerAlignment,DX,DY,TextLength)),
	R1 = R + DeltaX,
	assert(grid_column_stat(GridWin,Title,Num,L,R1,GridHorAlignment,GridVerAlignment,DX,DY,TextLength)),
	Num1 = Num + 1,
	grid_replace_column(GridWin,Num1,Column,DeltaX),!.
  grid_replace_column(GridWin,Num,Column,DeltaX):-
	Num > Column,
	retract(grid_column_stat(GridWin,Title,Num,L,R,GridHorAlignment,GridVerAlignment,DX,DY,TextLength)),
	L1 = L + DeltaX, R1 = R + DeltaX,
	assert(grid_column_stat(GridWin,Title,Num,L1,R1,GridHorAlignment,GridVerAlignment,DX,DY,TextLength)),
	Num1 = Num + 1,
	grid_replace_column(GridWin,Num1,Column,DeltaX),!.
  grid_replace_column(_,_,_,_).

  grid_draw_resize_line(GridWin,X):-
	RCT = grid_my_win_GetClientRect(GridWin),
	RCT = rct(_,T,_,B),
	win_SetPen(GridWin,pen(3,ps_Solid,color_White)),
	win_SetDrawMode(GridWin,dm_XorPen),
	draw_Line(GridWin,pnt(X,T),pnt(X,B)),
	win_SetDrawMode(GridWin,dm_CopyPen),!.

