/******************************************************************************

               Copyright (c) 1984 - 2000 Prolog Development Center A/S

 FileName:	GRIDMAR.PRO
 Purpose:	GRID custom control object drawing subroutines
 Version:	2.0
 Written by:	Sergey Alexeev
 Build:		025.991028
 Tested with:   Visual Prolog v.5.2
 Comments:
******************************************************************************/
predicates
procedure grid_adjust_datalist(WINDOW GridWin,
	INTEGER FromRow,INTEGER ToRow,INTEGER FromColumn,INTEGER ToColumn,
	INTEGER FromRowX,INTEGER ToRowX,INTEGER FromColumnX,INTEGER ToColumnX,
	GRIDLIST2D,GRIDLIST2D)
clauses
  grid_adjust_datalist(GridWin,FromRow,ToRow,FromColumn,ToColumn,FirstRows,LastRows,FirstCols,LastCols,List2D,List2D1):-
	grid_column_info(GridWin,_,_,FirstColumn,_,NoScrollColumns),
	NSC = NoScrollColumns + 1,
	NSC = FirstColumn,
	RCT = grid_my_win_GetClientRect(GridWin),
	RCT = rct(_,_,R,B),
	grid_row_info(GridWin,_,_,_,_,_,FirstRow,_),
	grid_convert(GridWin,grid_y(B),grid_row(LastRow),_),
	grid_convert(GridWin,grid_x(R),grid_column(LastColumn),_),
	FirstRows = grid_max(FromRow,FirstRow),
	FirstCols = grid_max(FromColumn,1),
	LastRows = grid_min(ToRow,LastRow),
	LastCols = grid_min(ToColumn,LastColumn),
	grid_remove_data(FromRow,FromColumn,FirstRows,LastRows,FirstCols,LastCols,List2D,List2D1),!.
  grid_adjust_datalist(GridWin,FromRow,ToRow,FromColumn,ToColumn,FirstRows,LastRows,FirstCols,LastCols,List2D,List2D1):-
	grid_column_info(GridWin,_,_,_,_,NoScrollColumns),
	FromColumn <= NoScrollColumns, ToColumn <= NoScrollColumns,
	RCT = grid_my_win_GetClientRect(GridWin),
	RCT = rct(_,_,_,B),
	grid_row_info(GridWin,_,_,_,_,_,FirstRow,_),
	grid_convert(GridWin,grid_y(B),grid_row(LastRow),_),
	FirstRows = grid_max(FromRow,FirstRow),
	FirstCols = grid_max(FromColumn,1),
	LastRows = grid_min(ToRow,LastRow),
	LastCols = grid_min(ToColumn,NoScrollColumns),
	grid_remove_data(FromRow,FromColumn,FirstRows,LastRows,FirstCols,LastCols,List2D,List2D1),!.
  grid_adjust_datalist(GridWin,FromRow,ToRow,FromColumn,ToColumn,FirstRows,LastRows,FirstCols,LastCols,List2D,List2D1):-
	grid_column_info(GridWin,_,_,FirstColumn,_,NoScrollColumns),
	FromColumn <= NoScrollColumns, ToColumn >= NoScrollColumns,
	RCT = grid_my_win_GetClientRect(GridWin),
	RCT = rct(_,_,R,B),
	grid_row_info(GridWin,_,_,_,_,_,FirstRow,_),
	grid_convert(GridWin,grid_y(B),grid_row(LastRow),_),
	grid_convert(GridWin,grid_x(R),grid_column(LastColumn),_),
	FirstRows = grid_max(FromRow,FirstRow),
	FirstCols = grid_max(FromColumn,FirstColumn),
	LastRows = grid_min(ToRow,LastRow),
	LastCols = grid_min(ToColumn,LastColumn),
	grid_remove_data(FromRow,FromColumn,FirstRows,LastRows,FirstCols,LastCols,List2D,List2D1),
	FirstColsX = grid_max(FromColumn,1),
	grid_remove_data(FromRow,FromColumn,FirstRows,LastRows,FirstColsX,LastCols,List2D,List2D1X),
	grid_draw(GridWin,FirstRows,LastRows,FirstColsX,NoScrollColumns,data_answer(grid_area_answer(List2D1X))),!.
  grid_adjust_datalist(GridWin,FromRow,ToRow,FromColumn,ToColumn,FirstRows,LastRows,FirstCols,LastCols,List2D,List2D1):-
	RCT = grid_my_win_GetClientRect(GridWin),
	RCT = rct(_,_,R,B),
	grid_row_info(GridWin,_,_,_,_,_,FirstRow,_),
	grid_convert(GridWin,grid_y(B),grid_row(LastRow),_),
	grid_column_info(GridWin,_,_,FirstColumn,_,_),
	grid_convert(GridWin,grid_x(R),grid_column(LastColumn),_),
	FirstRows = grid_max(FromRow,FirstRow),
	FirstCols = grid_max(FromColumn,FirstColumn),
	LastRows = grid_min(ToRow,LastRow),
	LastCols = grid_min(ToColumn,LastColumn),
	grid_remove_data(FromRow,FromColumn,FirstRows,LastRows,FirstCols,LastCols,List2D,List2D1),!.
  grid_adjust_datalist(_,_,_,_,_,_,_,_,_,_,[]):-
	errorexit().

ifndef  ws_win
predicates
procedure grid_update_controls(WINDOW GridWin)
clauses
  grid_update_controls(GridWin):-
	grid_vscroll_info(GridWin,b_true,Vert,_,_),
	win_Invalidate(Vert),
	fail.
  grid_update_controls(GridWin):-
	grid_hscroll_info(GridWin,b_true,Horz,_,_),
	win_Invalidate(Horz),!.
  grid_update_controls(_).
enddef

  grid_draw(GridWin,FromRow,ToRow,FromColumn,ToColumn,data_answer(grid_area_answer(List2D))):-
	grid_adjust_datalist(GridWin,FromRow,ToRow,FromColumn,ToColumn,
		FromRow1,ToRow1,FromColumn1,ToColumn1,List2D,List2D1),
	Rect = grid_my_win_GetClientRect(GridWin),
	Rect = rct(L0,T0,R,B),
	grid_row_info(GridWin,_,LeftTitleWidth,TopTitleHeight,_,_,_,_),
	L = L0 + LeftTitleWidth, T = T0 + TopTitleHeight,
	win_SetClip(GridWin,rct(L,T,R,B)),
	grid_redraw_row(List2D1,GridWin,FromRow1,ToRow1,FromColumn1,ToColumn1),
	retractall(grid_invalidate_action),
	win_SetClip(GridWin,Rect),
ifndef  ws_win
	grid_update_controls(GridWin),
enddef
	!.
  grid_draw(GridWin,FromRow,ToRow,FromColumn,ToColumn,_):-
	Rect = grid_my_win_GetClientRect(GridWin),
	Rect = rct(L0,T0,R,B),
	grid_row_info(GridWin,_,LeftTitleWidth,TopTitleHeight,_,_,_,_),
	L = L0 + LeftTitleWidth, T = T0 + TopTitleHeight,
	win_SetClip(GridWin,rct(L,T,R,B)),
	grid_redraw_row_empty(GridWin,FromRow,ToRow,FromColumn,ToColumn),
	retractall(grid_invalidate_action),
	win_SetClip(GridWin,Rect),!.
  grid_draw(GridWin,_,_,_,_,_):-
	Rect = grid_my_win_GetClientRect(GridWin),
	win_SetClip(GridWin,Rect),!.

  grid_redraw_row([],_,_,_,_,_):-!.
  grid_redraw_row(_,_,From_Row,To_Row,_,_):-
	From_Row > To_Row,!.
  grid_redraw_row([List|Rest],GridWin,From_Row,To_Row,From_Column,To_Column):-
	grid_redraw_column(List,GridWin,From_Row,From_Column,To_Column),
	FR = From_Row + 1,
	grid_redraw_row(Rest,GridWin,FR,To_Row,From_Column,To_Column).

  grid_redraw_column([],_,_,_,_):-!.
  grid_redraw_column(_,_,_,From_Column,To_Column):-
	From_Column > To_Column,!.
  grid_redraw_column([Answer|Rest],GridWin,Row,From_Column,To_Column):-
	grid_cell_draw_ext(GridWin,Answer,Row,From_Column),
	FC = From_Column + 1,!,
	grid_redraw_column(Rest,GridWin,Row,FC,To_Column).

  grid_redraw_row_empty(_,From_Row,To_Row,_,_):-
	From_Row > To_Row,!.
  grid_redraw_row_empty(GridWin,From_Row,To_Row,From_Column,To_Column):-
	grid_redraw_column_empty(GridWin,From_Row,From_Column,To_Column),
	FR = From_Row + 1,
	grid_redraw_row_empty(GridWin,FR,To_Row,From_Column,To_Column).

  grid_redraw_column_empty(_,_,From_Column,To_Column):-
	From_Column > To_Column,!.
  grid_redraw_column_empty(GridWin,Row,From_Column,To_Column):-
	grid_get_text_answer(GridWin,empty_answer,String,ForeColor,BackColor),
	grid_cell_draw(GridWin,Row,From_Column,ForeColor,BackColor,String),!,
	FC = From_Column + 1,
	grid_redraw_column_empty(GridWin,Row,FC,To_Column).

  grid_get_text_answer(_,Answer,String,ForeColor,BackColor):-
	Answer = textatr(String,ForeColor,BackColor),!.
  grid_get_text_answer(GridWin,Answer,"",BgColor,FrColor):-
	Answer = empty_answer,
	grid_view_info(GridWin,_,_,_,_,_,BgColor,FrColor,_,_,_),!.
  grid_get_text_answer_pict(GridWin,Answer,Picture,Stretch,BgColor):-
	Answer = picture(Picture,Stretch),
	grid_view_info(GridWin,_,_,_,_,_,BgColor,_,_,_,_),!.

  grid_cell_draw_ext(GridWin,GridText,Row,Column):-
	grid_get_text_answer(GridWin,GridText,String,ForeColor,BackColor),
	grid_cell_draw(GridWin,Row,Column,ForeColor,BackColor,String),!.
  grid_cell_draw_ext(GridWin,GridText,Row,Column):-
	grid_get_text_answer_pict(GridWin,GridText,Picture,Stretch,BackColor),
	grid_cell_draw_pict(GridWin,Row,Column,BackColor,Stretch,Picture),!.

predicates
  procedure grid_insert_new_string(WINDOW EditWin,STRING String)
clauses
  grid_insert_new_string(EditWin,String):-
	retract(grid_edit(GridWin,CtlId,EditWin,Row,Column,_,List)),
	assert(grid_edit(GridWin,CtlId,EditWin,Row,Column,String,List)),!.
  grid_insert_new_string(_,_).

predicates
procedure  grid_cell_draw1(WINDOW GridWin,INTEGER Row,INTEGER Column,COLOR ForeColor,COLOR BackColor,STRING)
procedure  grid_cell_draw1_pict(WINDOW GridWin,INTEGER Row,INTEGER Column,COLOR BackColor,BOOLEAN Stretch,PICTURE)
clauses
  grid_cell_draw(GridWin,Row,Column,Txt_color,Back_color,String):-
	grid_cell_draw1(GridWin,Row,Column,Txt_color,Back_color,String).

  grid_cell_draw_pict(GridWin,Row,Column,Back_color,Stretch,Picture):-
	grid_cell_draw1_pict(GridWin,Row,Column,Back_color,Stretch,Picture).

  grid_cell_draw1(GridWin,Row,Column,_,_,String):-
	grid_invalidate_action,
	retract(grid_edit(GridWin,CtlId,EditWin,Row,Column,_,List)),
	assert(grid_edit(GridWin,CtlId,EditWin,Row,Column,String,List)),
	win_SetText(EditWin,String),!.
  grid_cell_draw1(GridWin,Row,Column,_,_,_):-
	not(grid_invalidate_action),
	grid_edit(GridWin,_,_,Row,Column,_,_),!.
  grid_cell_draw1(GridWin,Row,Column,Txt_color,Back_color,String):-
	grid_convert(GridWin,grid_column(Column),grid_lr(_,_,Hor_marg,Vert_marg,DX,DY,_,_),_),
	grid_draw_pushbotton(GridWin,grid_row(Row),grid_column(Column),
	Back_color,Txt_color,DX,DY,Hor_marg,Vert_marg,String),!.
  grid_cell_draw1(_,_,_,_,_,_):-!.
  grid_cell_draw1_pict(GridWin,Row,Column,Back_color,Stretch,Picture):-
	grid_convert(GridWin,grid_column(Column),grid_lr(_,_,Hor_marg,Vert_marg,DX,DY,_,_),_),
	grid_draw_pushbotton_pict(GridWin,grid_row(Row),grid_column(Column),
	Back_color,DX,DY,Hor_marg,Vert_marg,Stretch,Picture),!.
  grid_cell_draw1_pict(_,_,_,_,_,_):-!.

predicates
procedure  grid_draw_botton(WINDOW GridWin,RCT,PATSTYLE,COLOR RctColor)
procedure  grid_draw_text(WINDOW GridWin,RCT,COLOR Txt_Color,
  	INTEGER DX,INTEGER DY,GRID_HORALIGNMENT,GRID_VERALIGNMENT,STRING)
procedure  grid_draw_picture(WINDOW GridWin,RCT,
	INTEGER DX,INTEGER DY,GRID_HORALIGNMENT,GRID_VERALIGNMENT,BOOLEAN Stretch,PICTURE)
procedure  grid_get_rct1(GRID_CELLS_STYLE,RCT InRct,RCT OutRct)
clauses
  grid_draw_pushbotton(GridWin,grid_tt,Column,Rct_Color,Txt_color,DX,DY,
				Horiz,Vert,String):-
	grid_convert(GridWin,grid_tt,grid_tb(Tx,Bx),_),
	Txx = grid_min1(Tx,10000),
	T = grid_max1(Txx,-10000),
	Bxx = grid_min1(Bx,10000),
	B = grid_max1(Bxx,-10000),
	grid_convert(GridWin,Column,grid_lr(L,R,_,_,_,_,_,_),_),
	grid_view_info(GridWin,CellStyle,_,_,_,_,_,_,_,_,_),
	TI = grid_val(T),
	BI = grid_val(B),
	grid_get_rct1(CellStyle,rct(L,TI,R,BI),RctDraw),
	grid_draw_botton(GridWin,RctDraw,pat_Solid,Rct_Color),
	grid_draw_text(GridWin,RctDraw,Txt_Color,DX,DY,Horiz,Vert,String),!.
  grid_draw_pushbotton(GridWin,Row,grid_lt,Rct_Color,Txt_color,DX,DY,
				Horiz,Vert,String):-
	grid_convert(GridWin,Row,grid_tb(Tx,Bx),_),
	Txx = grid_min1(Tx,10000),
	T = grid_max1(Txx,-10000),
	Bxx = grid_min1(Bx,10000),
	B = grid_max1(Bxx,-10000),
	grid_convert(GridWin,grid_lt,grid_lr(L,R,_,_,_,_,_,_),_),
	grid_view_info(GridWin,CellStyle,_,_,_,_,_,_,_,_,_),
	TI = grid_val(T),
	BI = grid_val(B),
	grid_get_rct1(CellStyle,rct(L,TI,R,BI),RctDraw),
	grid_draw_botton(GridWin,RctDraw,pat_Solid,Rct_Color),
	grid_get_lefttextwidth(GridWin,R,R1),
	grid_get_rct1(CellStyle,rct(L,TI,R1,BI),RctDraw1),
	grid_draw_text(GridWin,RctDraw1,Txt_Color,DX,DY,Horiz,Vert,String),!.
  grid_draw_pushbotton(GridWin,Row,Column,Rct_Color,Txt_color,DX,DY,
				Horiz,Vert,String):-
	grid_convert(GridWin,Row,grid_tb(Tx,Bx),_),
	Txx = grid_min1(Tx,10000),
	T = grid_max1(Txx,-10000),
	Bxx = grid_min1(Bx,10000),
	B = grid_max1(Bxx,-10000),
	grid_convert(GridWin,Column,grid_lr(L,R,_,_,_,_,_,_),_),
	grid_view_info(GridWin,CellStyle,_,_,_,_,_,_,_,_,_),
	TI = grid_val(T),
	BI = grid_val(B),
	grid_get_rct1(CellStyle,rct(L,TI,R,BI),RctDraw),
	grid_draw_botton(GridWin,RctDraw,pat_Solid,Rct_Color),
	grid_draw_text(GridWin,RctDraw,Txt_Color,DX,DY,Horiz,Vert,String),!.
  grid_draw_pushbotton(_,_,_,_,_,_,_,_,_,_).

  grid_draw_pushbotton_pict(GridWin,Row,Column,Rct_Color,DX,DY,
				Hor_marg,Vert_marg,Stretch,Picture):-
	grid_convert(GridWin,Row,grid_tb(Tx,Bx),_),
	Txx = grid_min1(Tx,10000),
	T = grid_max1(Txx,-10000),
	Bxx = grid_min1(Bx,10000),
	B = grid_max1(Bxx,-10000),
	grid_convert(GridWin,Column,grid_lr(L,R,_,_,_,_,_,_),_),
	grid_view_info(GridWin,CellStyle,_,_,_,_,_,_,_,_,_),
	TI = grid_val(T),
	BI = grid_val(B),
	grid_get_rct1(CellStyle,rct(L,TI,R,BI),RctDraw),
	grid_draw_botton(GridWin,RctDraw,pat_Solid,Rct_Color),
	grid_draw_picture(GridWin,RctDraw,DX,DY,Hor_marg,Vert_marg,Stretch,Picture),!.
  grid_draw_pushbotton_pict(_,_,_,_,_,_,_,_,_,_).

  grid_draw_botton(GridWin,_,_,Color):-
	grid_view_info(GridWin,_,_,_,_,Color,_,_,_,_,_),!.
  grid_draw_botton(GridWin,rct(L,T,R,B),Pattern,Color):-
	win_SetPen(GridWin,pen(1,ps_Hollow,Color)),
	win_SetBrush(GridWin,brush(Pattern,Color)),
	draw_Rect(GridWin,rct(L,T,R,B)),!.

predicates
procedure  grid_get_flags(GRID_HORALIGNMENT,GRID_VERALIGNMENT,ILIST Flags)
determ  grid_get_rct(RCT InRct,GRID_HORALIGNMENT,GRID_VERALIGNMENT,INTEGER DX,INTEGER DY,RCT OutRct)
procedure  grid_check_hor_alignment(WINDOW GridWin,STRING,RCT,GRID_HORALIGNMENT,GRID_HORALIGNMENT)
clauses
  grid_draw_text(GridWin,Rct_text,Txt_Color,DX,DY,Horiz_margin,Vert_margin,String):-
	win_SetForeColor(GridWin,Txt_Color),
	grid_check_hor_alignment(GridWin,String,Rct_text,Horiz_margin,Horiz_margin1),
	grid_get_flags(Horiz_margin1,Vert_margin,Flags),
	grid_get_rct(Rct_text,Horiz_margin,Vert_margin,DX,DY,Rct_text1),
	draw_TextInRect(GridWin,Rct_text1,String,-1,Flags),!.
  grid_draw_text(_,_,_,_,_,_,_,_).

  grid_check_hor_alignment(GridWin,String,rct(L,_,R,_),_,grid_left_align):-
	not(searchchar(String,'\n',_)),
	win_GetTextExtent(GridWin,String,-1,TextWidth,_),
	Width = R - L + 1,
	TextWidth > Width,!.
  grid_check_hor_alignment(_,_,_,Horiz_margin,Horiz_margin).

  grid_get_flags(grid_left_align,grid_top_align,[dtext_left,dtext_top,dtext_noprefix]):-!.
  grid_get_flags(grid_left_align,grid_bottom_align,[dtext_left,dtext_bottom,dtext_noprefix]):-!.
  grid_get_flags(grid_left_align,grid_center,[dtext_left,dtext_vcenter,dtext_noprefix]):-!.
  grid_get_flags(grid_right_align,grid_top_align,[dtext_right,dtext_top,dtext_noprefix]):-!.
  grid_get_flags(grid_right_align,grid_bottom_align,[dtext_right,dtext_bottom,dtext_noprefix]):-!.
  grid_get_flags(grid_right_align,grid_center,[dtext_right,dtext_vcenter,dtext_noprefix]):-!.
  grid_get_flags(grid_center,grid_top_align,[dtext_center,dtext_top,dtext_noprefix]):-!.
  grid_get_flags(grid_center,grid_bottom_align,[dtext_center,dtext_bottom,dtext_noprefix]):-!.
  grid_get_flags(grid_center,grid_center,[dtext_center,dtext_vcenter,dtext_noprefix]):-!.
  grid_get_flags(_,_,[]):-errorexit().

%  grid_get_flags(grid_left_align,grid_top_align,[dtext_left,dtext_top,dtext_singleline,dtext_noprefix]).
%  grid_get_flags(grid_left_align,grid_bottom_align,[dtext_left,dtext_bottom,dtext_singleline,dtext_noprefix]).
%  grid_get_flags(grid_left_align,grid_center,[dtext_left,dtext_vcenter,dtext_singleline,dtext_noprefix]).
%  grid_get_flags(grid_right_align,grid_top_align,[dtext_right,dtext_top,dtext_singleline,dtext_noprefix]).
%  grid_get_flags(grid_right_align,grid_bottom_align,[dtext_right,dtext_bottom,dtext_singleline,dtext_noprefix]).
%  grid_get_flags(grid_right_align,grid_center,[dtext_right,dtext_vcenter,dtext_singleline,dtext_noprefix]).
%  grid_get_flags(grid_center,grid_top_align,[dtext_center,dtext_top,dtext_singleline,dtext_noprefix]).
%  grid_get_flags(grid_center,grid_bottom_align,[dtext_center,dtext_bottom,dtext_singleline,dtext_noprefix]).
%  grid_get_flags(grid_center,grid_center,[dtext_center,dtext_vcenter,dtext_singleline,dtext_noprefix]).

  grid_get_rct(rct(X1,_,X2,_),_,_,_,_,_):-
	X1 > X2 - 3,
	!,fail.
  grid_get_rct(rct(L,T,R,B),grid_left_align,grid_top_align,DX,DY,rct(L1,T1,R,B)):-
	L1 = L + DX,
	T1 = T + DY,!.
  grid_get_rct(rct(L,T,R,B),grid_left_align,grid_bottom_align,DX,DY,rct(L1,T,R,B1)):-
	L1 = L + DX,
	B1 = B - DY,!.
  grid_get_rct(rct(L,T,R,B),grid_left_align,grid_center,DX,_,rct(L1,T,R,B)):-
	L1 = L + DX,!.
  grid_get_rct(rct(L,T,R,B),grid_right_align,grid_top_align,DX,DY,rct(L,T1,R1,B)):-
	R1 = R - DX,
	T1 = T + DY,!.
  grid_get_rct(rct(L,T,R,B),grid_right_align,grid_bottom_align,DX,DY,rct(L,T,R1,B1)):-
	R1 = R - DX,
	B1 = B - DY,!.
  grid_get_rct(rct(L,T,R,B),grid_right_align,grid_center,DX,_,rct(L,T,R1,B)):-
	R1 = R - DX,!.
  grid_get_rct(rct(L,T,R,B),grid_center,grid_top_align,_,DY,rct(L,T1,R,B)):-
	T1 = T + DY,!.
  grid_get_rct(rct(L,T,R,B),grid_center,grid_bottom_align,_,DY,rct(L,T,R,B1)):-
	B1 = B - DY,!.
  grid_get_rct(rct(L,T,R,B),grid_center,grid_center,_,_,rct(L,T,R,B)):-!.
  grid_get_rct(_,_,_,_,_,rct(0,0,0,0)):-errorexit().

  grid_get_rct1(grid_raised,rct(L,T,R,B),rct(L1,T1,R,B)):-
	L1 = L + 1,
	T1 = T + 1,!.
  grid_get_rct1(_,InRct,InRct).

predicates
procedure  grid_get_pnt(RCT TargetRct,INTEGER WidthPict,INTEGER HeightPict,INTEGER DX,INTEGER DY,
	GRID_HORALIGNMENT,GRID_VERALIGNMENT,PNT UpperLeftCorner)
clauses
  grid_draw_picture(GridWin,Rct_pict,DX,DY,Hor_marg,Vert_marg,b_false,Picture):-
	pict_GetSize(Picture,Width,Height,_),
	grid_get_pnt(Rct_pict,Width,Height,DX,DY,Hor_marg,Vert_marg,UpperLeftCorner),
	ClipRct = grid_my_win_GetClientRect(GridWin),
	ClipRct1 = rect_Intersect(ClipRct,Rct_pict),
	win_SetClip(GridWin,ClipRct1),
	pict_Draw(GridWin,Picture,UpperLeftCorner,rop_SrcCopy),
	win_SetClip(GridWin,ClipRct),
	pict_Destroy(Picture),!.
  grid_draw_picture(GridWin,Rct_pict,_DX,_DY,_Hor_marg,_Vert_marg,b_true,Picture):-
	pict_GetSize(Picture,Width,Height,_),
	pict_Draw(GridWin,Picture,Rct_pict,rct(0,0,Width,Height),rop_SrcCopy),
	pict_Destroy(Picture),!.
  grid_draw_picture(_,_,_,_,_,_,_,_).

predicates
procedure  grid_get_pnt_x(RCT TargetRct,INTEGER WidthPict,INTEGER DX,GRID_HORALIGNMENT,INTEGER X)
procedure  grid_get_pnt_y(RCT TargetRct,INTEGER HeightPict,INTEGER DY,GRID_VERALIGNMENT,INTEGER Y)
clauses
  grid_get_pnt(TargetRct,WidthPict,HeightPict,DX,DY,HorAlign,VerAlign,UpperLeftCorner):-
	grid_get_pnt_x(TargetRct,WidthPict,DX,HorAlign,X),
	grid_get_pnt_y(TargetRct,HeightPict,DY,VerAlign,Y),
	UpperLeftCorner = pnt(X,Y),!.

  grid_get_pnt_x(rct(L,_,_,_),_,DX,grid_left_align,X):-
	X = L + DX,!.
  grid_get_pnt_x(rct(_,_,R,_),WidthPict,DX,grid_right_align,X):-
	X = R - (WidthPict + DX),!.
  grid_get_pnt_x(rct(L,_,R,_),WidthPict,_,grid_center,X):-
	X = (R + L) div 2 - WidthPict div 2,!.
  grid_get_pnt_x(_,_,_,_,0):-errorexit().

  grid_get_pnt_y(rct(_,T,_,_),_,DY,grid_top_align,Y):-
	Y = T + DY,!.
  grid_get_pnt_y(rct(_,_,_,B),HeightPict,DY,grid_bottom_align,Y):-
	Y = B - (HeightPict + DY),!.
  grid_get_pnt_y(rct(_,T,_,B),HeightPict,_,grid_center,Y):-
	Y = (B + T) div 2 - HeightPict div 2,!.
  grid_get_pnt_y(_,_,_,_,0):-errorexit().

/*************************************************************************
			     OWNERDRAW 
 *************************************************************************/
predicates
procedure  grid_draw_up_push_button(WINDOW CtlWin,RCT)
procedure  grid_draw_down_push_button(WINDOW CtlWin,RCT)
procedure  grid_draw_fore_button(WINDOW GridWin,WINDOW CtlWin,INTEGER CtlId,RCT,INTEGER Displacement)
clauses
  grid_ownerdraw_CreateControl(wc_PushButton,CtlId,OwnRCT,Title,ParentWin):-
	win_CreateDynControl([ctl(wdef(wc_PushButton,OwnRCT,Title,u_Pixels),
        	CtlId,[ctl_OwnerDraw,ctl_AlignCenter])],ParentWin),!.
  grid_ownerdraw_CreateControl(_,_,_,_,_):-!.

  grid_ownerdraw_DrawButton(ACTIONLIST,STATELIST,GridWin,CtlWin,CtlId):- 
	ACTIONLIST = [odact_Select],
	STATELIST = [odstate_Focus,odstate_Selected],
	RCT = win_GetClientRect(CtlWin),
	win_SetPen(CtlWin,pen(1,ps_solid,color_Gray)),
	win_SetBrush(CtlWin,brush(pat_Solid,color_LtGray)),
	grid_draw_down_push_button(CtlWin,RCT),
	win_SetPen(CtlWin,pen(1,ps_Solid,color_black)),
	win_SetBrush(CtlWin,brush(pat_Solid,color_black)),
	grid_draw_fore_button(GridWin,CtlWin,CtlId,RCT,2),!.
  grid_ownerdraw_DrawButton(ACTIONLIST,STATELIST,GridWin,CtlWin,CtlId):-
	ACTIONLIST = [odact_Select],
	STATELIST = [odstate_Focus],
	RCT = win_GetClientRect(CtlWin),
	win_SetPen(CtlWin,pen(1,ps_solid,color_Black)),
	win_SetBrush(CtlWin,brush(pat_Solid,color_LtGray)),
 	grid_draw_up_push_button(CtlWin,RCT),
	win_SetPen(CtlWin,pen(1,ps_Solid,color_black)),
	win_SetBrush(CtlWin,brush(pat_Solid,color_black)),
	grid_draw_fore_button(GridWin,CtlWin,CtlId,RCT,0),!.
  grid_ownerdraw_DrawButton(ACTIONLIST,[],GridWin,CtlWin,CtlId):-
	ACTIONLIST = [odact_DrawEntire],
	RCT = win_GetClientRect(CtlWin),
	win_SetPen(CtlWin,pen(1,ps_solid,color_Black)),
	win_SetBrush(CtlWin,brush(pat_Solid,color_LtGray)),
 	grid_draw_up_push_button(CtlWin,RCT),
	win_SetPen(CtlWin,pen(1,ps_Solid,color_black)),
	win_SetBrush(CtlWin,brush(pat_Solid,color_black)),
	grid_draw_fore_button(GridWin,CtlWin,CtlId,RCT,0),!.

  grid_draw_up_push_button(CtlWin,RCT):-
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

  grid_draw_down_push_button(CtlWin,RCT):-
	draw_Rect(CtlWin,RCT),!.

%********* DRAWING ARROW SYMBOLS ON TOP OF THE OWNERDRAW BUTTONS **********
predicates
procedure  grid_calc_rect(RCT,INTEGER X1,INTEGER X2,INTEGER X3,INTEGER Y1,INTEGER Y2,INTEGER Y3)
procedure  grid_calc_rect_disp(RCT,INTEGER Displacement,INTEGER X1,INTEGER X2,INTEGER X3,
			INTEGER Y1,INTEGER Y2,INTEGER Y3)
clauses
  grid_draw_fore_button(_,CtlWin,grid_righttop_id,RCT,Disp):-
	grid_calc_rect_disp(RCT,Disp,X1,X2,X3,Y1,Y2,Y3),
	draw_Polygon(CtlWin,[pnt(X1,Y2),pnt(X3,Y2),pnt(X2,Y1)]),
	draw_Polygon(CtlWin,[pnt(X1,Y3),pnt(X3,Y3),pnt(X2,Y2)]),!.
  grid_draw_fore_button(_,CtlWin,grid_leftbottom_id,RCT,Disp):-
	grid_calc_rect_disp(RCT,Disp,X1,X2,X3,Y1,Y2,Y3),
	draw_Polygon(CtlWin,[pnt(X2,Y1),pnt(X2,Y3),pnt(X1,Y2)]),
	draw_Polygon(CtlWin,[pnt(X3,Y1),pnt(X3,Y3),pnt(X2,Y2)]),!.
  grid_draw_fore_button(GridWin,CtlWin,grid_rightbottom_id,rct(L,T,R,B),Disp):-
	grid_vscroll_info(GridWin,b_true,_,_,_),
	grid_hscroll_info(GridWin,b_true,_,_,_),
	Delta = (R - L) div 6,
	X2 = (L + R) div 2 + Disp, Y2 = (B + T) div 2 + Disp,
	X1 = X2 - Delta, X3 = X2 + Delta, X4 = X1 - Delta,
	Y1 = Y2 - Delta, Y3 = Y2 + Delta, Y4 = Y1 - Delta,
	draw_Polygon(CtlWin,[pnt(X1,Y3),pnt(X3,Y1),pnt(X3,Y3)]),
	draw_Polygon(CtlWin,[pnt(X2,Y4),pnt(X4,Y2),pnt(X2,Y2)]),!.
  grid_draw_fore_button(GridWin,CtlWin,grid_rightbottom_id,RCT,Disp):-
	grid_vscroll_info(GridWin,b_true,_,_,_),
	grid_calc_rect_disp(RCT,Disp,X1,X2,X3,Y1,Y2,Y3),
	draw_Polygon(CtlWin,[pnt(X1,Y1),pnt(X3,Y1),pnt(X2,Y2)]),
	draw_Polygon(CtlWin,[pnt(X1,Y2),pnt(X3,Y2),pnt(X2,Y3)]),!.
  grid_draw_fore_button(_,CtlWin,grid_rightbottom_id,RCT,Disp):-
	grid_calc_rect_disp(RCT,Disp,X1,X2,X3,Y1,Y2,Y3),
	draw_Polygon(CtlWin,[pnt(X1,Y1),pnt(X1,Y3),pnt(X2,Y2)]),
	draw_Polygon(CtlWin,[pnt(X2,Y1),pnt(X2,Y3),pnt(X3,Y2)]),!.
  grid_draw_fore_button(_,_,_,_,_):-!.

  grid_calc_rect(rct(L,T,R,B),X1,X2,X3,Y1,Y2,Y3):-
	X2 = (R + L) div 2, Y2 = (B + T) div 2,
	Delta1 = (B - T) div 5, Delta2 = (R - L) div 5,
	Delta = grid_min(Delta1,Delta2),
	X1 = X2 - Delta, X3 = X2 + Delta,
	Y1 = Y2 - Delta, Y3 = Y2 + Delta,!.

  grid_calc_rect_disp(RCT,Disp,X10,X20,X30,Y10,Y20,Y30):-
	grid_calc_rect(RCT,X1,X2,X3,Y1,Y2,Y3),
	X10 = X1 + Disp, X20 = X2 + Disp, X30 = X3 + Disp,
	Y10 = Y1 + Disp, Y20 = Y2 + Disp, Y30 = Y3 + Disp,!.

/*************************************************************************
			     MARKERS
 *************************************************************************/
  grid_remove_markers(GridWin,_):-
	grid_Marker(GridWin,Marker),
	Marker = grid_no_marker,!.

  grid_remove_markers(GridWin,Marker):-
	Marker = grid_rows_marker,
	grid_row(GridWin,_),!.
  grid_remove_markers(GridWin,Marker):-
	Marker = grid_columns_marker,
	grid_column(GridWin,_),!.
  grid_remove_markers(GridWin,Marker):-
	Marker = grid_areas_marker,
	grid_area(GridWin,_),!.
  grid_remove_markers(GridWin,_):-
	grid_remove_cell_marker(GridWin),!.
  grid_remove_markers(GridWin,_):-
	grid_remove_all_marker(GridWin),!.
  grid_remove_markers(GridWin,_):-
	grid_remove_row_marker(GridWin),!.
  grid_remove_markers(GridWin,_):-
	grid_remove_column_marker(GridWin),!.
  grid_remove_markers(GridWin,_):-
	grid_remove_area_marker(GridWin),!.

/*************************************************************************
			     CELL MARKER
 *************************************************************************/
predicates
determ  grid_check_answer(GRIDANSWER,WINDOW GridWin,INTEGER Row,INTEGER Column)
procedure  grid_create_sub_handler(WINDOW ControlWin)
  grid_SubHandler  : EHANDLER
clauses
  grid_create_cell_marker(GridWin,Row,Column):-
	grid_info(GridWin,_,Callbackfunc,_),
	Callbackfunc(GridWin,user_action(grid_marker(grid_edit_cell(Row,Column),b_true)),Answer),
	grid_check_answer(Answer,GridWin,Row,Column),!.
  grid_create_cell_marker(GridWin,Row,Column):-
	grid_create_edit_marker(GridWin,Row,Column),!.

  grid_check_answer(event_answer(stop),_,_,_):-!.
  grid_check_answer(event_answer(continue),GridWin,Row,Column):-
	grid_create_edit_marker(GridWin,Row,Column),!.
  grid_check_answer(event_answer(editCtrl(InitString)),GridWin,Row,Column):-
	grid_create_edit_marker_init(GridWin,Row,Column,InitString),!.
  grid_check_answer(event_answer(lBoxButton(List,InitString)),GridWin,Row,Column):-
	grid_create_lbb_marker(GridWin,Row,Column,List,InitString),!.
  grid_check_answer(event_answer(lBoxEdit(List,InitString)),GridWin,Row,Column):-
	grid_create_lbe_marker(GridWin,Row,Column,List,InitString),!.
  grid_check_answer(event_answer(custom_ctrl(Name,Ctl_Flags,PutFunc,GetFunc,InitString)),GridWin,Row,Column):-
	grid_create_custom_marker(GridWin,Row,Column,Name,Ctl_Flags,PutFunc,GetFunc,InitString),!.

  grid_create_cell_marker1(GridWin):-
	grid_edit(GridWin,grid_edit_id,_,_,_,_,_),
	grid_create_edit_marker1(GridWin),!.
  grid_create_cell_marker1(GridWin):-
	grid_edit(GridWin,grid_lbb_id,_,_,_,_,_),
	grid_create_lbb_marker1(GridWin),!.
  grid_create_cell_marker1(GridWin):-
	grid_edit(GridWin,grid_lbe_id,_,_,_,_,_),
	grid_create_lbe_marker1(GridWin),!.
  grid_create_cell_marker1(GridWin):-
	grid_edit(GridWin,grid_custom_id,_,_,_,_,_),
	grid_create_custom_marker1(GridWin),!.
  grid_create_cell_marker1(_).

  grid_remove_cell_marker(GridWin):-
	grid_edit(GridWin,_,EditWin,Row,Column,String,_),
	NullWin = cast(WINDOW,0),
	NullWin = EditWin,
	grid_check_callback(GridWin,user_action(modified(Row,Column,String))),
	grid_check_callback(GridWin,user_action(grid_marker(grid_edit_cell(Row,Column),b_false))),
	retract(grid_edit(GridWin,_,_,_,_,_,_)),
	trap(win_SetFocus(GridWin),_,fail),!.
  grid_remove_cell_marker(GridWin):-
	grid_edit(GridWin,grid_custom_id,EditWin,Row,Column,_,_),
	grid_custom_func(GridWin,_,_,_,GetFunc),
	GetFunc(EditWin,String),
	grid_check_callback(GridWin,user_action(modified(Row,Column,String))),
	grid_check_callback(GridWin,user_action(grid_marker(grid_edit_cell(Row,Column),b_false))),
	retract(grid_edit(GridWin,_,_,_,_,_,_)),
	retract(grid_custom_func(GridWin,_,_,_,_)),
	grid_win_Destroy(EditWin),
	grid_Invalidate_my(GridWin,grid_area(Row,Row,Column,Column)),
	trap(win_SetFocus(GridWin),_,fail),!.
  grid_remove_cell_marker(GridWin):-
	grid_edit(GridWin,_,EditWin,Row,Column,String,_),
	grid_check_callback(GridWin,user_action(modified(Row,Column,String))),
	grid_check_callback(GridWin,user_action(grid_marker(grid_edit_cell(Row,Column),b_false))),
	retract(grid_edit(GridWin,_,_,_,_,_,_)),
	grid_win_Destroy(EditWin),
	grid_Invalidate_my(GridWin,grid_area(Row,Row,Column,Column)),
	trap(win_SetFocus(GridWin),_,fail),!.

  grid_remove_cell_marker1(GridWin):-
	grid_edit(GridWin,_,EditWin,_,_,_,_),
	NullWin = cast(WINDOW,0),
	NullWin = EditWin,!.
  grid_remove_cell_marker1(GridWin):-
	retract(grid_edit(GridWin,grid_custom_id,EditWin,Row,Column,_,List)),
	grid_custom_func(GridWin,_,_,_,GetFunc),
	GetFunc(EditWin,String),
	NullWin = cast(WINDOW,0),
	assert(grid_edit(GridWin,grid_custom_id,NullWin,Row,Column,String,List)),
	grid_win_Destroy(EditWin),!.
  grid_remove_cell_marker1(GridWin):-
	retract(grid_edit(GridWin,MarkerId,EditWin,Row,Column,String,List)),
	NullWin = cast(WINDOW,0),
	assert(grid_edit(GridWin,MarkerId,NullWin,Row,Column,String,List)),
	grid_win_Destroy(EditWin),!.
  grid_remove_cell_marker1(_).

  grid_refresh_edit_marker(GridWin):-
	grid_remove_cell_marker1(GridWin),
	grid_create_cell_marker1(GridWin),!.

  grid_create_sub_handler(ControlWin):-
	win_SetSubClassHandler(ControlWin,grid_SubHandler,b_false),!.
%	win_EnableHook(ControlWin,b_true),!.

predicates
procedure grid_correct_rowmarker(WINDOW GridWin,INTEGER MaxRow,GRID_LINELIST RowList,GRID_LINELIST Curr,GRID_LINELIST NewRowList)
clauses
  grid_correct_rowmarker(_,_,[],Curr,NewRowList):-
	grid_reverse_list(Curr,[],NewRowList),!.
  grid_correct_rowmarker(GridWin,MaxRow,[gl(FromRow,_)|RowList],Curr,NewRowList):-
	FromRow > MaxRow,!,
	grid_correct_rowmarker(GridWin,MaxRow,RowList,Curr,NewRowList).
  grid_correct_rowmarker(GridWin,MaxRow,[gl(FromRow,ToRow)|RowList],Curr,NewRowList):-
	NewToRow = grid_min(MaxRow,ToRow),!,
	grid_correct_rowmarker(GridWin,MaxRow,RowList,[gl(FromRow,NewToRow)|Curr],NewRowList).
  grid_correct_rowmarker(_,_,_,_,[]):-
	errorexit().

predicates
procedure grid_correct_areamarker(WINDOW GridWin,INTEGER MaxRow,GRID_AREALIST AreaList,GRID_AREALIST Curr,GRID_AREALIST NewAreaList)
clauses
  grid_correct_areamarker(_,_,[],Curr,NewAreaList):-
	grid_reverse_list(Curr,[],NewAreaList),!.
  grid_correct_areamarker(GridWin,MaxRow,[ga(FromRow,_,_,_)|AreaList],Curr,NewAreaList):-
	FromRow > MaxRow,!,
	grid_correct_areamarker(GridWin,MaxRow,AreaList,Curr,NewAreaList).
  grid_correct_areamarker(GridWin,MaxRow,[ga(FromRow,ToRow,FromColumn,ToColumn)|AreaList],Curr,NewAreaList):-
	NewToRow = grid_min(MaxRow,ToRow),!,
	grid_correct_areamarker(GridWin,MaxRow,AreaList,[ga(FromRow,NewToRow,FromColumn,ToColumn)|Curr],NewAreaList).
  grid_correct_areamarker(_,_,_,_,[]):-
	errorexit().

  grid_refresh_markers(GridWin):-
	grid_row(GridWin,RowList),
	grid_row_info(GridWin,MaxRow,_,_,_,_,_,_),
	grid_correct_rowmarker(GridWin,MaxRow,RowList,[],NewRowList),
	grid_Marker(GridWin,grid_row_marker(NewRowList)),!.
  grid_refresh_markers(GridWin):-
	grid_area(GridWin,AreaList),
	grid_row_info(GridWin,MaxRow,_,_,_,_,_,_),
	grid_correct_areamarker(GridWin,MaxRow,AreaList,[],NewAreaList),
	grid_Marker(GridWin,grid_area_marker(NewAreaList)),!.
  grid_refresh_markers(_).


%constants
%  wm_GetDlgCode	= 0x0087

predicates
procedure  grid_move_edit_arrow(WINDOW ControlWin,INTEGER Key)
procedure  grid_move_edit_keys(WINDOW ControlWin,INTEGER Key,INTEGER SCA)
determ  grid_get_editWin(WINDOW FocWin,WINDOW GridWin,WINDOW EditWin)
clauses
  grid_get_editWin(FocWin,GridWin,EditWin):-
	grid_custom_handler(GridWin,FocWin,_),
	grid_edit(GridWin,_,EditWin,_,_,_,_),!.
  grid_get_editWin(EditWin,GridWin,EditWin):-
	grid_edit(GridWin,_,EditWin,_,_,_,_),!.
  grid_get_editWin(FocWin,GridWin,EditWin):-
	EditWin = win_GetParent(FocWin),
	grid_edit(GridWin,_,EditWin,_,_,_,_),!.

%  grid_SubHandler(FocWin,e_Native(wm_GetDlgCode,Char,_),0):-
%	grid_visit_order(GridWin,Char,_,_),
%	grid_get_editWin(FocWin,GridWin,_),
%	win_PostEvent(FocWin,e_Menu(Char,0)),!.

  grid_SubHandler(FocWin,e_Menu(grid_l,_),0):-
	grid_get_editWin(FocWin,_,EditWin),
	grid_move_edit_arrow(EditWin,grid_l),!.
  grid_SubHandler(FocWin,e_Menu(grid_r,_),0):-
	grid_get_editWin(FocWin,_,EditWin),
	grid_move_edit_arrow(EditWin,grid_r),!.
  grid_SubHandler(FocWin,e_Menu(grid_t,_),0):-
	grid_get_editWin(FocWin,_,EditWin),
	grid_move_edit_arrow(EditWin,grid_t),!.
  grid_SubHandler(FocWin,e_Menu(grid_b,_),0):-
	grid_get_editWin(FocWin,_,EditWin),
	grid_move_edit_arrow(EditWin,grid_b),!.
  grid_SubHandler(FocWin,e_Menu(Key,SCA),0):-
	grid_get_editWin(FocWin,_,EditWin),
	grid_move_edit_keys(EditWin,Key,SCA),!.

  grid_SubHandler(FocWin,e_Char(Char,SCA),0):-
	grid_get_editWin(FocWin,GridWin,_),
	not(grid_check_callback(GridWin,event(e_Char(Char,SCA)))),!.

  grid_SubHandler(FocWin,e_Char(27,0),0):-
	grid_get_editWin(FocWin,GridWin,_),
	assert(grid_edit_kill),
	win_PostEvent(GridWin,e_Menu(0,0)),!.

  grid_SubHandler(_,e_Char(grid_l,c_Control),0):-!.
  grid_SubHandler(_,e_KeyUp(grid_l,c_Control),0):-!.
  grid_SubHandler(FocWin,e_KeyDown(grid_l,c_Control),0):-
	win_PostEvent(FocWin,e_Menu(grid_l,0)),!.

  grid_SubHandler(_,e_Char(grid_r,c_Control),0):-!.
  grid_SubHandler(_,e_KeyUp(grid_r,c_Control),0):-!.
  grid_SubHandler(FocWin,e_KeyDown(grid_r,c_Control),0):-
	win_PostEvent(FocWin,e_Menu(grid_r,0)),!.

  grid_SubHandler(_,e_Char(grid_t,c_Control),0):-!.
  grid_SubHandler(_,e_KeyUp(grid_t,c_Control),0):-!.
  grid_SubHandler(FocWin,e_KeyDown(grid_t,c_Control),0):-
	win_PostEvent(FocWin,e_Menu(grid_t,0)),!.

  grid_SubHandler(_,e_Char(grid_b,c_Control),0):-!.
  grid_SubHandler(_,e_KeyUp(grid_b,c_Control),0):-!.
  grid_SubHandler(FocWin,e_KeyDown(grid_b,c_Control),0):-
	win_PostEvent(FocWin,e_Menu(grid_b,0)),!.

  grid_SubHandler(FocWin,e_KeyDown(Key,SCA),0):-
	grid_get_editWin(FocWin,GridWin,_),
	grid_visit_order(GridWin,Key,SCA,_),
	win_PostEvent(FocWin,e_Menu(Key,SCA)),!.
  grid_SubHandler(FocWin,e_KeyUp(Key,SCA),0):-
	grid_get_editWin(FocWin,GridWin,_),
	grid_visit_order(GridWin,Key,SCA,_),!.
  grid_SubHandler(FocWin,e_Char(Key,SCA),0):-
	grid_get_editWin(FocWin,GridWin,_),
	grid_visit_order(GridWin,Key,SCA,_),!.

  grid_SubHandler(FocWin,Event,_):-
	grid_custom_handler(_,FocWin,CustHandler),
	CustHandler(FocWin,Event),!,fail.

predicates
determ  grid_check_return_back(INTEGER Row1,INTEGER Column1,INTEGER Row2,INTEGER Column2)
clauses
  grid_check_return_back(Row1,Column1,Row2,Column2):-
	Row1 = Row2, Column1 = Column2,!,fail.
  grid_check_return_back(_,_,_,_).

predicates
determ  grid_new_edit_pos(WINDOW GridWin,GRID_KEY Key,INTEGER ShiftCtlAlt,INTEGER Row1,INTEGER Column1,INTEGER Row,INTEGER Column)
procedure  grid_new_edit_pos(INTEGER Key,INTEGER Row1,INTEGER Column1,INTEGER Row,INTEGER Column)
procedure  grid_change_edit_pos(WINDOW GridWin,INTEGER Row,INTEGER Column,INTEGER EdRow,INTEGER EdColumn)
determ  grid_move_edit_arrow1(WINDOW GridWin,INTEGER Key,INTEGER FirstRow,INTEGER FirstColumn,INTEGER Row,
	INTEGER Column,INTEGER EdRow,INTEGER EdColumn)
clauses
  grid_move_edit_arrow1(GridWin,Key,_,_,Row,Column,EdRow,EdColumn):-
	grid_new_edit_pos(Key,Row,Column,Row1,Column1),
	grid_change_edit_pos(GridWin,Row1,Column1,EdRow,EdColumn),
	grid_check_callback(GridWin,user_action(grid_edit_cell_beg(EdRow,EdColumn))),!.
  grid_move_edit_arrow1(GridWin,Key,FirstRow,FirstColumn,Row,Column,EdRow,EdColumn):-
	grid_new_edit_pos(Key,Row,Column,Row1,Column1),
	grid_change_edit_pos(GridWin,Row1,Column1,Row2,Column2),
	grid_check_return_back(Row2,Column2,FirstRow,FirstColumn),!,
	grid_move_edit_arrow1(GridWin,Key,FirstRow,FirstColumn,Row2,Column2,EdRow,EdColumn).

  grid_move_edit_arrow(EditWin,Key):-
	grid_edit(GridWin,_,EditWin,Row,Column,_,_),
	grid_move_edit_arrow1(GridWin,Key,Row,Column,Row,Column,EdRow,EdColumn),
	grid_remove_cell_marker(GridWin),
	grid_check_scroll(GridWin,EdRow,EdColumn),
	grid_create_cell_marker(GridWin,EdRow,EdColumn),!.
  grid_move_edit_arrow(_,_).

predicates
determ  grid_move_edit_key(WINDOW GridWin,GRID_KEY GridKey,INTEGER SCA,INTEGER FirstRow,INTEGER FirstColumn,
	INTEGER Row,INTEGER Column,INTEGER EdRow,INTEGER EdColumn)
clauses
  grid_move_edit_key(GridWin,GridKey,SCA,_,_,Row,Column,EdRow,EdColumn):-
	grid_new_edit_pos(GridWin,GridKey,SCA,Row,Column,Row1,Column1),
	grid_change_edit_pos(GridWin,Row1,Column1,EdRow,EdColumn),
	grid_check_callback(GridWin,user_action(grid_edit_cell_beg(EdRow,EdColumn))),!.
  grid_move_edit_key(GridWin,GridKey,SCA,FirstRow,FirstColumn,Row,Column,EdRow,EdColumn):-
	grid_new_edit_pos(GridWin,GridKey,SCA,Row,Column,Row1,Column1),
	grid_change_edit_pos(GridWin,Row1,Column1,Row2,Column2),
	grid_check_return_back(Row2,Column2,FirstRow,FirstColumn),!,
	grid_move_edit_key(GridWin,GridKey,SCA,FirstRow,FirstColumn,Row2,Column2,EdRow,EdColumn).

  grid_move_edit_keys(EditWin,Key,SCA):-
	grid_edit(GridWin,_,EditWin,Row,Column,_,_),
	grid_move_edit_key(GridWin,Key,SCA,Row,Column,Row,Column,EdRow,EdColumn),
	grid_remove_cell_marker(GridWin),
	grid_check_scroll(GridWin,EdRow,EdColumn),
	grid_create_cell_marker(GridWin,EdRow,EdColumn),!.
  grid_move_edit_keys(_,_,_).
  grid_move_edit_max(EditWin):-
	String = win_GetText(EditWin),
	grid_insert_new_string(EditWin,String),
	fail.
  grid_move_edit_max(EditWin):-
	grid_edit(GridWin,_,EditWin,Row,Column,_,_),
	String = win_GetText(EditWin),
	grid_convert(GridWin,grid_column(Column),grid_lr(_,_,_,_,_,_,MaxText,_),_),
	str_len(String,Text),
	Text >= MaxText,
	grid_move_edit_key(GridWin,grid_max_length,0,Row,Column,Row,Column,EdRow,EdColumn),
	grid_remove_cell_marker(GridWin),
	grid_check_scroll(GridWin,EdRow,EdColumn),
	grid_create_cell_marker(GridWin,EdRow,EdColumn),!.
  grid_move_edit_max(_).

  grid_new_edit_pos(grid_r,Row,Column1,Row,Column):-
	Column = Column1 + 1,!.
  grid_new_edit_pos(grid_l,Row,Column1,Row,Column):-
	Column = Column1 - 1,!.
  grid_new_edit_pos(grid_b,Row1,Column,Row,Column):-
	Row = Row1 + 1,!.
  grid_new_edit_pos(grid_t,Row1,Column,Row,Column):-
	Row = Row1 - 1,!.
  grid_new_edit_pos(_,Row,Column,Row,Column).

  grid_new_edit_pos(GridWin,Key,ShiftCtlAlt,Row,Column1,Row,Column):-
	grid_visit_order(GridWin,Key,ShiftCtlAlt,grid_right),!,
	Column = Column1 + 1.
  grid_new_edit_pos(GridWin,Key,ShiftCtlAlt,Row,Column1,Row,Column):-
	grid_visit_order(GridWin,Key,ShiftCtlAlt,grid_left),!,
	Column = Column1 - 1.
  grid_new_edit_pos(GridWin,Key,ShiftCtlAlt,Row1,Column,Row,Column):-
	grid_visit_order(GridWin,Key,ShiftCtlAlt,grid_down),!,
	Row = Row1 + 1.
  grid_new_edit_pos(GridWin,Key,ShiftCtlAlt,Row1,Column,Row,Column):-
	grid_visit_order(GridWin,Key,ShiftCtlAlt,grid_up),!,
	Row = Row1 - 1.
  grid_new_edit_pos(_,_,_,Row,Column,Row,Column).

  grid_change_edit_pos(GridWin,Row,Column,1,1):-
	grid_row_info(GridWin,MaxRow,_,_,_,_,_,_),
	grid_column_info(GridWin,MaxColumn,_,_,_,_),
	Row = MaxRow, Column > MaxColumn,!.
  grid_change_edit_pos(GridWin,Row,Column,1,1):-
	grid_row_info(GridWin,MaxRow,_,_,_,_,_,_),
	grid_column_info(GridWin,MaxColumn,_,_,_,_),
	Row > MaxRow, Column = MaxColumn,!.
  grid_change_edit_pos(GridWin,Row,Column,1,EdColumn):-
	grid_row_info(GridWin,MaxRow,_,_,_,_,_,_),
	Row > MaxRow,
	EdColumn = Column + 1,!.
  grid_change_edit_pos(GridWin,Row,Column,EdRow,1):-
	grid_column_info(GridWin,MaxColumn,_,_,_,_),
	Column > MaxColumn,
	EdRow = Row + 1,!.
  grid_change_edit_pos(GridWin,1,0,MaxRow,MaxColumn):-
	grid_row_info(GridWin,MaxRow,_,_,_,_,_,_),
	grid_column_info(GridWin,MaxColumn,_,_,_,_),!.
  grid_change_edit_pos(GridWin,0,1,MaxRow,MaxColumn):-
	grid_row_info(GridWin,MaxRow,_,_,_,_,_,_),
	grid_column_info(GridWin,MaxColumn,_,_,_,_),!.
  grid_change_edit_pos(GridWin,Row,Column,MaxRow,EdColumn):-
	Row < 1,
	grid_row_info(GridWin,MaxRow,_,_,_,_,_,_),
	EdColumn = Column - 1,!.
  grid_change_edit_pos(GridWin,Row,Column,EdRow,MaxColumn):-
	Column < 1,
	grid_column_info(GridWin,MaxColumn,_,_,_,_),
	EdRow = Row - 1,!.
  grid_change_edit_pos(_,Row,Column,Row,Column).

/*************************************************************************
			     LBB MARKER
 *************************************************************************/
predicates
procedure  grid_get_lbb_flags(WINDOW GridWin,INTEGER Column,CTL_FLAGS WinFlags)
determ     grid_member_index(STRING,SLIST,UNSIGNED)
determ     grid_member(STRING,SLIST)
determ     grid_member(GRID_AREA,GRID_AREALIST)
determ     grid_member(GRID_LINE,GRID_LINELIST)
procedure  grid_get_index(STRING,SLIST,UNSIGNED)
clauses
  grid_get_lbb_flags(GridWin,Column,[ctl_VScroll,ctl_AutoHScroll,ctl_AutoVScroll,ctl_AlignLeft]):-
	grid_column_stat(GridWin,_,Column,_,_,grid_left_align,_,_,_,_),!.
  grid_get_lbb_flags(GridWin,Column,[ctl_VScroll,ctl_AutoHScroll,ctl_AutoVScroll,ctl_AlignRight]):-
	grid_column_stat(GridWin,_,Column,_,_,grid_right_align,_,_,_,_),!.
  grid_get_lbb_flags(GridWin,Column,[ctl_VScroll,ctl_AutoHScroll,ctl_AutoVScroll,ctl_AlignCenter]):-
	grid_column_stat(GridWin,_,Column,_,_,grid_center,_,_,_,_),!.
  grid_get_lbb_flags(_,_,[ctl_VScroll,ctl_AutoHScroll,ctl_AutoVScroll,ctl_AlignCenter]):-!.

  grid_get_index(S,L,P):-
	grid_member(S,L),
	grid_member_index(S,L,P),!.
  grid_get_index(_,_,0).

  grid_member_index(S,[S|_],0):-!.
  grid_member_index(S,[_|L],M):-
        bound(M),!,
        N = M - 1,
        grid_member_index(S,L,N),!.
  grid_member_index(S,[_|L],M):-
        grid_member_index(S,L,N),!,
        M = N + 1.

  grid_member(S,[S|_]):-!.
  grid_member(S,[_|L]):-!,
	grid_member(S,L).

  grid_create_lbb_marker(GridWin,Row,Column,List,InitString):-
	grid_check_scroll(GridWin,Row,Column),
	grid_convert(GridWin,grid_row(Row),grid_tb(Tx,BRx),Insaid),
	Txx = grid_min1(Tx,10000),
	T = grid_max1(Txx,-10000),
	BRxx = grid_min1(BRx,10000),
	BR = grid_max1(BRxx,-10000),
	Insaid = b_true,
	grid_convert(GridWin,grid_column(Column),grid_lr(L,RR,_,_,_,_,_,_),Insaid1),
	Insaid1 = b_true,
	Y = grid_get_y_max(GridWin),
	BRI = grid_val(BR),
	B = grid_min(Y,BRI),
	X = grid_get_x_max(GridWin),
	R = grid_min(X,RR),
	R_Min = vpi_GetAttrVal(attr_ctl_vert_sbar_width),
	R > R_Min,
	grid_get_lbb_flags(GridWin,Column,Flags),
	L1 = L, T1 = T, R1 = R, B1 = B + 100,
	T1I = grid_val(T1),
	EditWin = win_CreateControl(wc_LBoxButton,rct(L1,T1I,R1,B1),InitString,GridWin,Flags,grid_lbb_id),
ifdef ws_win
	ValRect = win_GetOuterRect(EditWin),
	win_ValidateRect(GridWin,ValRect),
elsedef
	B2 = B - 2,
	win_ValidateRect(GridWin,rct(L1,T1,R1,B2)),
enddef
	Font = win_GetFont(GridWin),
	win_SetFont(EditWin,Font),
	lbox_Add(EditWin,List),
	grid_get_index(InitString,List,Pos),
	lbox_SetSel(EditWin,Pos,b_true),
	grid_SetFocus(EditWin),
	grid_create_sub_handler(EditWin),
	assert(grid_edit(GridWin,grid_lbb_id,EditWin,Row,Column,InitString,List)),
	grid_reset_activerow(GridWin),!.
  grid_create_lbb_marker(_,_,_,_,_).

  grid_create_lbb_marker1(GridWin):-
	grid_edit(GridWin,_,_,Row,Column,String,List),
	grid_convert(GridWin,grid_row(Row),grid_tb(Tx,BRx),Insaid),
	Txx = grid_min1(Tx,10000),
	T = grid_max1(Txx,-10000),
	BRxx = grid_min1(BRx,10000),
	BR = grid_max1(BRxx,-10000),
	Insaid = b_true,
	grid_convert(GridWin,grid_column(Column),grid_lr(L,RR,_,_,_,_,_,_),Insaid1),
	Insaid1 = b_true,
	Y = grid_get_y_max(GridWin),
	BRI = grid_val(BR),
	B = grid_min(Y,BRI),
	X = grid_get_x_max(GridWin),
	R = grid_min(X,RR),
	R_Min = vpi_GetAttrVal(attr_ctl_vert_sbar_width),
	R > R_Min,
	grid_get_lbb_flags(GridWin,Column,Flags),
	L1 = L, T1 = T, R1 = R, B1 = B + 100,
	T1I = grid_val(T1),
	EditWin = win_CreateControl(wc_LBoxButton,rct(L1,T1I,R1,B1),String,GridWin,Flags,grid_lbb_id),
ifdef ws_win
	ValRect = win_GetOuterRect(EditWin),
	win_ValidateRect(GridWin,ValRect),
elsedef
	B2 = B - 2,
	win_ValidateRect(GridWin,rct(L1,T1,R1,B2)),
enddef
	Font = win_GetFont(GridWin),
	win_SetFont(EditWin,Font),
	retract(grid_edit(GridWin,_,_,Row,Column,String,_)),
	lbox_Add(EditWin,List),
	grid_get_index(String,List,Pos),
	lbox_SetSel(EditWin,Pos,b_true),
	grid_SetFocus(EditWin),
	grid_create_sub_handler(EditWin),
	assert(grid_edit(GridWin,grid_lbb_id,EditWin,Row,Column,String,List)),!.
  grid_create_lbb_marker1(_).

/*************************************************************************
			     LBE MARKER
 *************************************************************************/
predicates
procedure  grid_get_lbe_flags(WINDOW GridWin,INTEGER Column,CTL_FLAGS WinFlags)
clauses
  grid_get_lbe_flags(GridWin,Column,[wsf_WantKeyboardInput,ctl_VScroll,ctl_AutoHScroll,ctl_AutoVScroll,ctl_AlignLeft]):-
	grid_column_stat(GridWin,_,Column,_,_,grid_left_align,_,_,_,_),!.
  grid_get_lbe_flags(GridWin,Column,[wsf_WantKeyboardInput,ctl_VScroll,ctl_AutoHScroll,ctl_AutoVScroll,ctl_AlignRight]):-
	grid_column_stat(GridWin,_,Column,_,_,grid_right_align,_,_,_,_),!.
  grid_get_lbe_flags(GridWin,Column,[wsf_WantKeyboardInput,ctl_VScroll,ctl_AutoHScroll,ctl_AutoVScroll,ctl_AlignCenter]):-
	grid_column_stat(GridWin,_,Column,_,_,grid_center,_,_,_,_),!.
  grid_get_lbe_flags(_,_,[wsf_WantKeyboardInput,ctl_VScroll,ctl_AutoHScroll,ctl_AutoVScroll,ctl_AlignCenter]):-!.

  grid_create_lbe_marker(GridWin,Row,Column,List,InitString):-
	grid_check_scroll(GridWin,Row,Column),
	grid_convert(GridWin,grid_row(Row),grid_tb(Tx,BRx),Insaid),
	Txx = grid_min1(Tx,10000),
	T = grid_max1(Txx,-10000),
	BRxx = grid_min1(BRx,10000),
	BR = grid_max1(BRxx,-10000),
	Insaid = b_true,
	grid_convert(GridWin,grid_column(Column),grid_lr(L,RR,_,_,_,_,_,_),Insaid1),
	Insaid1 = b_true,
	Y = grid_get_y_max(GridWin),
	BRI = grid_val(BR),
	B = grid_min(Y,BRI),
	X = grid_get_x_max(GridWin),
	R = grid_min(X,RR),
	R_Min = vpi_GetAttrVal(attr_ctl_vert_sbar_width),
	R > R_Min,
	grid_get_lbe_flags(GridWin,Column,Flags),
	L1 = L, T1 = T, R1 = R, B1 = B + 100,
	T1I = grid_val(T1),
	EditWin = win_CreateControl(wc_LBoxEdit,rct(L1,T1I,R1,B1),InitString,GridWin,Flags,grid_lbe_id),
ifdef ws_win
	ValRect = win_GetOuterRect(EditWin),
	win_ValidateRect(GridWin,ValRect),
elsedef
	B2 = B - 2,
	win_ValidateRect(GridWin,rct(L1,T1,R1,B2)),
enddef
	Font = win_GetFont(GridWin),
	win_SetFont(EditWin,Font),
	lbox_Add(EditWin,List),
	win_SetText(EditWin,InitString),
	str_len(InitString,Length),
	win_SelectText(EditWin,0,Length),
	grid_SetFocus(EditWin),
	grid_create_sub_handler(EditWin),
	assert(grid_edit(GridWin,grid_lbe_id,EditWin,Row,Column,InitString,List)),
	grid_reset_activerow(GridWin),!.
  grid_create_lbe_marker(_,_,_,_,_).

  grid_create_lbe_marker1(GridWin):-
	grid_edit(GridWin,_,_,Row,Column,String,List),
	grid_convert(GridWin,grid_row(Row),grid_tb(Tx,BRx),Insaid),
	Txx = grid_min1(Tx,10000),
	T = grid_max1(Txx,-10000),
	BRxx = grid_min1(BRx,10000),
	BR = grid_max1(BRxx,-10000),
	Insaid = b_true,
	grid_convert(GridWin,grid_column(Column),grid_lr(L,RR,_,_,_,_,_,_),Insaid1),
	Insaid1 = b_true,
	Y = grid_get_y_max(GridWin),
	BRI = grid_val(BR),
	B = grid_min(Y,BRI),
	X = grid_get_x_max(GridWin),
	R = grid_min(X,RR),
	R_Min = vpi_GetAttrVal(attr_ctl_vert_sbar_width),
	R > R_Min,
	grid_get_lbe_flags(GridWin,Column,Flags),
	L1 = L, T1 = T, R1 = R, B1 = B + 100,
	T1I = grid_val(T1),
	EditWin = win_CreateControl(wc_LBoxEdit,rct(L1,T1I,R1,B1),String,GridWin,Flags,grid_lbe_id),
ifdef ws_win
	ValRect = win_GetOuterRect(EditWin),
	win_ValidateRect(GridWin,ValRect),
elsedef
	B2 = B - 2,
	win_ValidateRect(GridWin,rct(L1,T1,R1,B2)),
enddef
	Font = win_GetFont(GridWin),
	win_SetFont(EditWin,Font),
	retract(grid_edit(GridWin,_,_,Row,Column,String,_)),
	lbox_Add(EditWin,List),
	grid_get_index(String,List,Pos),
	lbox_SetSel(EditWin,Pos,b_true),
	grid_SetFocus(EditWin),
	grid_create_sub_handler(EditWin),
	assert(grid_edit(GridWin,grid_lbe_id,EditWin,Row,Column,String,List)),!.
  grid_create_lbe_marker1(_).

/*************************************************************************
			     CUSTOM CONTROLS
 *************************************************************************/
  grid_create_custom_marker(GridWin,Row,Column,Name,Ctl_Flags,PutFunc,GetFunc,InitString):-
	grid_check_scroll(GridWin,Row,Column),
	grid_convert(GridWin,grid_row(Row),grid_tb(Tx,BRx),Insaid),
	Txx = grid_min1(Tx,10000),
	TI = grid_max1(Txx,-10000),
	T = grid_val(TI),
	BRxx = grid_min1(BRx,10000),
	BR = grid_max1(BRxx,-10000),
	Insaid = b_true,
	grid_convert(GridWin,grid_column(Column),grid_lr(L,RR,_,_,_,_,_,_),Insaid1),
	Insaid1 = b_true,
	Y = grid_get_y_max(GridWin),
	BRI = grid_val(BR),
	B = grid_min(Y,BRI),
	X = grid_get_x_max(GridWin),
	R = grid_min(X,RR),
	L1 = L + 1, T1 = T + 1, R1 = R - 1, B1 = B - 1,
ifdef ws_win
	EditWin = win_CreateDynControl([customctl(wdef(wc_Custom,rct(L1,T1,R1,B1),"",u_Pixels),Name,grid_custom_id,Ctl_Flags)],GridWin),
	ValRect = win_GetOuterRect(EditWin),
	win_ValidateRect(GridWin,ValRect),
elsedef
	EditWin = win_CreateDynControl([customctl(wdef(wc_Custom,rct(L,T,R,B),"",u_Pixels),Name,grid_custom_id,Ctl_Flags)],GridWin),
	win_ValidateRect(GridWin,rct(L1,T1,R1,B1)),
enddef
	Font = win_GetFont(GridWin),
	win_SetFont(EditWin,Font),
	retractall(grid_custom_func(GridWin,_,_,_,_)),
	assert(grid_custom_func(GridWin,Name,Ctl_Flags,PutFunc,GetFunc)),
	grid_SetFocus(EditWin),
ifdef ws_win
	FocWin = win_GetFocus(),
	CustHand = win_GetHandler(FocWin),
	grid_create_sub_handler(FocWin),
	assert(grid_custom_handler(GridWin,FocWin,CustHand)),
	assert(grid_edit(GridWin,grid_custom_id,EditWin,Row,Column,InitString,[])),
elsedef
	CustHand = win_GetHandler(EditWin),
	grid_create_sub_handler(EditWin),
	assert(grid_custom_handler(GridWin,EditWin,CustHand)),
	assert(grid_edit(GridWin,grid_custom_id,EditWin,Row,Column,InitString,[])),
enddef
	PutFunc(EditWin,InitString),
	grid_reset_activerow(GridWin),!.
  grid_create_custom_marker(_,_,_,_,_,_,_,_).

  grid_create_custom_marker1(GridWin):-
	grid_edit(GridWin,_,_,Row,Column,String,_),
	grid_convert(GridWin,grid_row(Row),grid_tb(Tx,BRx),Insaid),
	Txx = grid_min1(Tx,10000),
	T = grid_max1(Txx,-10000),
	BRxx = grid_min1(BRx,10000),
	BR = grid_max1(BRxx,-10000),
	Insaid = b_true,
	grid_convert(GridWin,grid_column(Column),grid_lr(L,RR,_,_,_,_,_,_),Insaid1),
	Insaid1 = b_true,!,
	Y = grid_get_y_max(GridWin),
	BRI = grid_val(BR),
	B = grid_min(Y,BRI),
	X = grid_get_x_max(GridWin),
	R = grid_min(X,RR),
	L1 = L + 1, T1 = T + 1, R1 = R - 1, B1 = B - 1,
	grid_custom_func(GridWin,Name,Ctl_Flags,PutFunc,_),
	T1I = grid_val(T1),
	EditWin = win_CreateDynControl([customctl(wdef(wc_Custom,rct(L1,T1I,R1,B1),"",u_Pixels),Name,grid_custom_id,Ctl_Flags)],GridWin),
ifdef ws_win
	ValRect = win_GetOuterRect(EditWin),
	win_ValidateRect(GridWin,ValRect),
elsedef
	win_ValidateRect(GridWin,rct(L1,T1,R1,B1)),
enddef
	Font = win_GetFont(GridWin),
	win_SetFont(EditWin,Font),
	PutFunc(EditWin,String),
	retract(grid_edit(GridWin,_,_,Row,Column,String,_)),
	grid_SetFocus(EditWin),
ifdef ws_win
	FocWin = win_GetFocus(),
	CustHand = win_GetHandler(FocWin),
	grid_create_sub_handler(FocWin),
	assert(grid_custom_handler(GridWin,FocWin,CustHand)),
	assert(grid_edit(GridWin,grid_custom_id,EditWin,Row,Column,String,[])),!.
elsedef
	CustHand = win_GetHandler(EditWin),
	grid_create_sub_handler(EditWin),
	assert(grid_custom_handler(GridWin,EditWin,CustHand)),
	assert(grid_edit(GridWin,grid_custom_id,EditWin,Row,Column,String,[])),!.
enddef
  grid_create_custom_marker1(_).

/*************************************************************************
			     EDIT MARKER
 *************************************************************************/
predicates
procedure  grid_get_edit_flags(WINDOW GridWin,INTEGER Column,CTL_FLAGS WinFlags)
procedure  grid_str_len(STRING,UNSIGNED Length)
clauses
  grid_get_edit_flags(GridWin,Column,[ctl_MultiLine,ctl_AutoHScroll,ctl_AutoVScroll,ctl_WantReturn,ctl_AlignLeft]):-
	grid_column_stat(GridWin,_,Column,_,_,grid_left_align,_,_,_,_),!.
  grid_get_edit_flags(GridWin,Column,[ctl_MultiLine,ctl_AutoHScroll,ctl_AutoVScroll,ctl_WantReturn,ctl_AlignRight]):-
	grid_column_stat(GridWin,_,Column,_,_,grid_right_align,_,_,_,_),!.
  grid_get_edit_flags(GridWin,Column,[ctl_MultiLine,ctl_AutoHScroll,ctl_AutoVScroll,ctl_WantReturn,ctl_AlignCenter]):-
	grid_column_stat(GridWin,_,Column,_,_,grid_center,_,_,_,_),!.
  grid_get_edit_flags(_,_,[ctl_MultiLine,ctl_AutoHScroll,ctl_AutoVScroll,ctl_WantReturn,ctl_AlignCenter]):-!.

  grid_create_edit_marker(GridWin,Row,Column):-
	grid_info(GridWin,_,Callbackfunc,_),
	grid_check_scroll(GridWin,Row,Column),
	grid_convert(GridWin,grid_row(Row),grid_tb(Tx,BRx),Insaid),
	Txx = grid_min1(Tx,10000),
	T = grid_max1(Txx,-10000),
	BRxx = grid_min1(BRx,10000),
	BR = grid_max1(BRxx,-10000),
	Insaid = b_true,
	grid_convert(GridWin,grid_column(Column),grid_lr(L,RR,_,_,_,_,_,_),Insaid1),
	Insaid1 = b_true,
	Y = grid_get_y_max(GridWin),
	BRI = grid_val(BR),
	B = grid_min(Y,BRI),
	X = grid_get_x_max(GridWin),
	R = grid_min(X,RR),
	Callbackfunc(GridWin,data_request(grid_area(Row,Row,Column,Column)),Answer),
	Answer = data_answer(grid_area_answer([[textatr(String,_,_)]])),
	grid_get_edit_flags(GridWin,Column,Flags),
	L1 = L, T1 = T, R1 = R, B1 = B - 1,
	T1I = grid_val(T1),
	EditWin = win_CreateControl(wc_edit,rct(L1,T1I,R1,B1),String,GridWin,Flags,grid_edit_id),
	T1I = grid_val(T1),
	win_ValidateRect(GridWin,rct(L1,T1I,R1,B1)),
	Font = win_GetFont(GridWin),
	win_SetFont(EditWin,Font),
	grid_str_len(String,Length),
	win_SelectText(EditWin,0,Length),
	grid_SetFocus(EditWin),
	grid_create_sub_handler(EditWin),
	assert(grid_edit(GridWin,grid_edit_id,EditWin,Row,Column,String,[])),
	grid_reset_activerow(GridWin),!.
  grid_create_edit_marker(GridWin,Row,Column):-
	grid_convert(GridWin,grid_row(Row),grid_tb(Tx,BRx),Insaid),
	Txx = grid_min1(Tx,10000),
	T = grid_max1(Txx,-10000),
	BRxx = grid_min1(BRx,10000),
	BR = grid_max1(BRxx,-10000),
	Insaid = b_true,
	grid_convert(GridWin,grid_column(Column),grid_lr(L,RR,_,_,_,_,_,_),Insaid1),
	Insaid1 = b_true,
	Y = grid_get_y_max(GridWin),
	BRI = grid_val(BR),
	B = grid_min(Y,BRI),
	X = grid_get_x_max(GridWin),
	R = grid_min(X,RR),
	grid_get_edit_flags(GridWin,Column,Flags),
	L1 = L, T1 = T, R1 = R, B1 = B - 1,
	T1I = grid_val(T1),
	EditWin = win_CreateControl(wc_edit,rct(L1,T1I,R1,B1),"",GridWin,Flags,grid_edit_id),
	T1I = grid_val(T1),
	win_ValidateRect(GridWin,rct(L1,T1I,R1,B1)),
	Font = win_GetFont(GridWin),
	win_SetFont(EditWin,Font),
	grid_SetFocus(EditWin),
	grid_create_sub_handler(EditWin),
	assert(grid_edit(GridWin,grid_edit_id,EditWin,Row,Column,"",[])),
	grid_reset_activerow(GridWin),!.
  grid_create_edit_marker(_,_,_).

  grid_create_edit_marker_init(GridWin,Row,Column,InitString):-
	grid_check_scroll(GridWin,Row,Column),
	grid_convert(GridWin,grid_row(Row),grid_tb(Tx,BRx),Insaid),
	Txx = grid_min1(Tx,10000),
	T = grid_max1(Txx,-10000),
	BRxx = grid_min1(BRx,10000),
	BR = grid_max1(BRxx,-10000),
	Insaid = b_true,
	grid_convert(GridWin,grid_column(Column),grid_lr(L,RR,_,_,_,_,_,_),Insaid1),
	Insaid1 = b_true,
	Y = grid_get_y_max(GridWin),
	BRI = grid_val(BR),
	B = grid_min(Y,BRI),
	X = grid_get_x_max(GridWin),
	R = grid_min(X,RR),
	grid_get_edit_flags(GridWin,Column,Flags),
	L1 = L, T1 = T, R1 = R, B1 = B - 1,
	T1I = grid_val(T1),
	EditWin = win_CreateControl(wc_edit,rct(L1,T1I,R1,B1),InitString,GridWin,Flags,grid_edit_id),
	win_ValidateRect(GridWin,rct(L1,T1I,R1,B1)),
	Font = win_GetFont(GridWin),
	win_SetFont(EditWin,Font),
	grid_str_len(InitString,Length),
	win_SelectText(EditWin,0,Length),
	grid_SetFocus(EditWin),
	grid_create_sub_handler(EditWin),
	assert(grid_edit(GridWin,grid_edit_id,EditWin,Row,Column,InitString,[])),
	grid_reset_activerow(GridWin),!.
  grid_create_edit_marker_init(_,_,_,_).

  grid_create_edit_marker1(GridWin):-
	grid_edit(GridWin,_,_,Row,Column,String,_),
	grid_convert(GridWin,grid_row(Row),grid_tb(Tx,BRx),Insaid),
	Txx = grid_min1(Tx,10000),
	T = grid_max1(Txx,-10000),
	BRxx = grid_min1(BRx,10000),
	BR = grid_max1(BRxx,-10000),
	Insaid = b_true,
	grid_convert(GridWin,grid_column(Column),grid_lr(L,RR,_,_,_,_,_,_),Insaid1),
	Insaid1 = b_true,
	grid_check_view(GridWin,Column),
	Y = grid_get_y_max(GridWin),
	BRI = grid_val(BR),
	B = grid_min(Y,BRI),
	X = grid_get_x_max(GridWin),
	R = grid_min(X,RR),
	grid_get_edit_flags(GridWin,Column,Flags),
	L1 = L, T1 = T, R1 = R, B1 = B - 1,
	T1I = grid_val(T1),
	EditWin = win_CreateControl(wc_edit,rct(L1,T1I,R1,B1),String,GridWin,Flags,grid_edit_id),
	T1I = grid_val(T1),
	win_ValidateRect(GridWin,rct(L1,T1I,R1,B1)),
	Font = win_GetFont(GridWin),
	win_SetFont(EditWin,Font),
	grid_str_len(String,Length),
	win_SelectText(EditWin,Length,Length),
	retract(grid_edit(GridWin,_,_,Row,Column,String,List)),
	grid_SetFocus(EditWin),
	grid_create_sub_handler(EditWin),
	assert(grid_edit(GridWin,grid_edit_id,EditWin,Row,Column,String,List)),!.
  grid_create_edit_marker1(_).

predicates
procedure  grid_str_len1(STRING,UNSIGNED,UNSIGNED Length)
clauses
  grid_str_len(String,Length):-
	grid_str_len1(String,0,Length),!.

  grid_str_len1(String,L,Length):-
	frontchar(String,FrontChar,RestString),
	FrontChar = '\n',
	L1 = L + 2,!,
	grid_str_len1(RestString,L1,Length).
  grid_str_len1(String,L,Length):-
	frontchar(String,_,RestString),
	L1 = L + 1,!,
	grid_str_len1(RestString,L1,Length).
  grid_str_len1(_,Length,Length).

/*************************************************************************
			     ALL MARKER
 *************************************************************************/
  grid_create_all_marker(GridWin):-
	assert(grid_all(GridWin)),
	grid_row_info(GridWin,MaxRow,_,_,_,_,_,_),
	grid_column_info(GridWin,MaxColumn,_,_,_,_),
	grid_correct(GridWin,grid_row(1),grid_row(FromRow)),
	grid_correct(GridWin,grid_row(MaxRow),grid_row(ToRow)),
	grid_correct(GridWin,grid_column(1),grid_column(FromColumn)),
	grid_correct(GridWin,grid_column(MaxColumn),grid_column(ToColumn)),
	grid_draw_lt_title_border(GridWin),
	grid_draw_top_title_border(GridWin,FromColumn,ToColumn),
	grid_draw_left_title_border(GridWin,FromRow,ToRow),
	grid_draw_border(GridWin,FromRow,ToRow,FromColumn,ToColumn),!.
  grid_create_all_marker(_).

  grid_remove_all_marker(GridWin):-
	grid_all(GridWin),
	grid_check_callback(GridWin,user_action(grid_marker(grid_all_marker,b_false))),
	retract(grid_all(GridWin)),
	grid_row_info(GridWin,MaxRow,_,_,_,_,_,_),
	grid_column_info(GridWin,MaxColumn,_,_,_,_),
	grid_correct(GridWin,grid_row(1),grid_row(FromRow)),
	grid_correct(GridWin,grid_row(MaxRow),grid_row(ToRow)),
	grid_correct(GridWin,grid_column(1),grid_column(FromColumn)),
	grid_correct(GridWin,grid_column(MaxColumn),grid_column(ToColumn)),
	grid_draw_lt_title_border(GridWin),
	grid_draw_top_title_border(GridWin,FromColumn,ToColumn),
	grid_draw_left_title_border(GridWin,FromRow,ToRow),
	grid_draw_border(GridWin,FromRow,ToRow,FromColumn,ToColumn),!.
