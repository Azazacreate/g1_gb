/******************************************************************************

               Copyright (c) 1984 - 2000 Prolog Development Center A/S

 FileName:	GRIDDRAW.PRO
 Purpose:	GRID custom control object drawing subroutines
 Version:	2.0
 Written by:	Sergey Alexeev
 Build:		025.991028
 Tested with:   Visual Prolog v.5.1 build 563
 Comments:
******************************************************************************/
predicates
  procedure grid_correct_scroll_start(WINDOW GridWin,INTEGER Value,INTEGER ValueX)
clauses
  grid_correct_scroll_start(GridWin,A,A):-
	grid_view_info(GridWin,grid_raised,_,_,_,_,_,_,_,_,_),!.
  grid_correct_scroll_start(_,A,B):-
	B = A - 1 .

  grid_vmove_cells_area(GridWin,Diff):-
	grid_vscroll_info(GridWin,b_true,VW,CurPos,MaxPos),
	Pos = CurPos + Diff,
	Pos1 = grid_max(Pos,1),
	NewPos = grid_min(Pos1,MaxPos),
	retractall(grid_vscroll_info(GridWin,_,_,_,_)),
	assert(grid_vscroll_info(GridWin,b_true,VW,NewPos,MaxPos)),
	win_SetScrollPos(VW,sb_Ctl,NewPos),
	retract(grid_row_info(GridWin,MaxRow,LeftTitleWidth,TopTitleHeight,RowHeight,MaxLine,_,LastRow)),
	assert(grid_row_info(GridWin,MaxRow,LeftTitleWidth,TopTitleHeight,RowHeight,MaxLine,NewPos,LastRow)),
	grid_set_last_RowColumn(GridWin),
	Shift = (val(long,CurPos) - NewPos) * RowHeight,
	Shift1 = grid_min1(Shift,10000),
	Shift2 = grid_max1(Shift1,-10000),
	Shift2I = grid_val(Shift2),
	Shift3 = val(integer,Shift2I),
	RCT = grid_my_win_GetClientRect(GridWin),
	RCT = rct(L,T1,R,B),
	TX = T1 + TopTitleHeight,
	grid_correct_scroll_start(GridWin,TX,T),
	win_Scroll(GridWin,rct(L,T,R,B),0,Shift3),
	grid_SetFocus(GridWin),
	grid_refresh_edit_marker(GridWin),!.
  grid_vmove_cells_area(_,_).

  grid_vscroll_handler(GridWin,sc_LineUp,_):-
	grid_vmove_cells_area(GridWin,-1),!.
  grid_vscroll_handler(GridWin,sc_LineDown,_):-
	grid_vmove_cells_area(GridWin,1),!.
  grid_vscroll_handler(GridWin,sc_PageUp,_):-
	grid_get_area_range(GridWin,Row,_),
	Row1 = 1 - Row,
	grid_vmove_cells_area(GridWin,Row1),!.
  grid_vscroll_handler(GridWin,sc_PageDown,_):-
	grid_get_area_range(GridWin,Row1,_),
	Row = Row1 - 1,
	grid_vmove_cells_area(GridWin,Row),!.
  grid_vscroll_handler(GridWin,sc_Thumb,Pos):-
	grid_vscroll_info(GridWin,_,_,CurVPos,_),
	Row = Pos - CurVPos,
	grid_vmove_cells_area(GridWin,Row),!.
  grid_vscroll_handler(GridWin,sc_Top,_):-
	grid_vscroll_info(GridWin,_,_,CurVPos,_),
	Row = 1 - CurVPos,
	grid_vmove_cells_area(GridWin,Row),!.
  grid_vscroll_handler(GridWin,sc_Bottom,_):-
	grid_vscroll_info(GridWin,_,_,CurVPos,_),
	grid_row_info(GridWin,MaxRow,_,_,_,_,_,_),
	Row = MaxRow - CurVPos,
	grid_vmove_cells_area(GridWin,Row),!.
  grid_vscroll_handler(GridWin,_,_):-
	grid_SetFocus(GridWin),!.

predicates
determ  grid_calc_shift(WINDOW GridWin,INTEGER DiffInColumn,INTEGER Shift)
determ  grid_change_diff(WINDOW GridWin,INTEGER Diff0,INTEGER Diff)
determ  grid_change_diff1(WINDOW GridWin,INTEGER MaxColumn,INTEGER Column,INTEGER Diff,INTEGER Diff)
determ  grid_change_diff2(WINDOW GridWin,INTEGER MinColumn,INTEGER Column,INTEGER Diff,INTEGER Diff)
clauses
  grid_change_diff(GridWin,1,Diff):-
	grid_column_info(GridWin,MaxColumn,_,FirstColumn,_,_),
	FirstColumn < MaxColumn,
	Column = FirstColumn + 1,
	grid_change_diff1(GridWin,MaxColumn,Column,1,Diff),!.
  grid_change_diff(GridWin,-1,Diff):-
	grid_column_info(GridWin,_,_,FirstColumn,_,NoScrollColumn),
	NSC = NoScrollColumn + 1,
	FirstColumn > NSC,
	Column = FirstColumn - 1,
	grid_change_diff2(GridWin,NSC,Column,-1,Diff),!.
  grid_change_diff(_,Diff,Diff).

  grid_change_diff1(_,Column,Column,Diff,Diff):-!.
  grid_change_diff1(GridWin,_,Column,Diff,Diff):-
	grid_convert(GridWin,grid_column(Column),grid_lr(L,R,_,_,_,_,_,_),_),
	Width = R - L,
	Width > 5,!.
  grid_change_diff1(GridWin,MaxColumn,Column0,Diff0,Diff):-
	Column1 = Column0 + 1,
	Diff1 = Diff0 + 1,
	grid_change_diff1(GridWin,MaxColumn,Column1,Diff1,Diff).

  grid_change_diff2(_,Column,Column,Diff,Diff):-!.
  grid_change_diff2(GridWin,_,Column,Diff,Diff):-
	grid_convert(GridWin,grid_column(Column),grid_lr(L,R,_,_,_,_,_,_),_),
	Width = R - L,
	Width > 5,!.
  grid_change_diff2(GridWin,MinColumn,Column0,Diff0,Diff):-
	Column1 = Column0 - 1,
	Diff1 = Diff0 - 1,
	grid_change_diff2(GridWin,MinColumn,Column1,Diff1,Diff).

  grid_hmove_cells_area(GridWin,Diff0):-
	grid_hscroll_info(GridWin,b_true,HW,CurPos,MaxPos),
	grid_change_diff(GridWin,Diff0,Diff),
	Pos = CurPos + Diff,
	Pos1 = grid_max(Pos,1),
	NewPos = grid_min(Pos1,MaxPos),
	retractall(grid_hscroll_info(GridWin,_,_,_,_)),
	assert(grid_hscroll_info(GridWin,b_true,HW,NewPos,MaxPos)),
	win_SetScrollPos(HW,sb_Ctl,NewPos),
	Diff1 = NewPos - CurPos,
	grid_calc_shift(GridWin,Diff1,Shift),
	retract(grid_column_info(GridWin,MaxColumn,GridColumnList,_,LastColumn,NoScrollColumns)),
	FirstColumn = NoScrollColumns + NewPos,
	assert(grid_column_info(GridWin,MaxColumn,GridColumnList,FirstColumn,LastColumn,NoScrollColumns)),
	grid_set_last_RowColumn(GridWin),
	RCT = grid_my_win_GetClientRect(GridWin),
	RCT = rct(L1,T,R,B),
	grid_convert(GridWin,grid_column(FirstColumn),grid_lr(L2,_,_,_,_,_,_,_),_),
	LX = L1 + L2,
	grid_correct_scroll_start(GridWin,LX,L),
	grid_invisible_markers(GridWin,b_true),
	win_Scroll(GridWin,rct(L,T,R,B),Shift,0),
	grid_invisible_markers(GridWin,b_false),
	grid_SetFocus(GridWin),
	grid_refresh_edit_marker(GridWin),!.
  grid_hmove_cells_area(_,_).

  grid_calc_shift(GridWin,DiffInColumn,Shift):-
	grid_column_info(GridWin,_,_,FirstColumn,_,_),
	grid_convert(GridWin,grid_column(FirstColumn),grid_lr(L,_,_,_,_,_,_,_),_),
	FirstColumn1 = FirstColumn + DiffInColumn,
	grid_convert(GridWin,grid_column(FirstColumn1),grid_lr(R,_,_,_,_,_,_,_),_),
	Shift = L - R,!.

  grid_hscroll_handler(GridWin,sc_LineUp,_):-
	grid_hmove_cells_area(GridWin,-1),!.
  grid_hscroll_handler(GridWin,sc_LineDown,_):-
	grid_hmove_cells_area(GridWin,1),!.
  grid_hscroll_handler(GridWin,sc_PageUp,_):-
	grid_get_area_range(GridWin,_,Column1),
	Column1 = 1,
	grid_hmove_cells_area(GridWin,-1),!.
  grid_hscroll_handler(GridWin,sc_PageDown,_):-
	grid_get_area_range(GridWin,_,Column1),
	Column1 = 1,
	grid_hmove_cells_area(GridWin,1),!.
  grid_hscroll_handler(GridWin,sc_PageUp,_):-
	grid_get_area_range(GridWin,_,Column1),
	Column = 1 - Column1,
	grid_hmove_cells_area(GridWin,Column),!.
  grid_hscroll_handler(GridWin,sc_PageDown,_):-
	grid_get_area_range(GridWin,_,Column1),
	Column = Column1 - 1,
	grid_hmove_cells_area(GridWin,Column),!.
  grid_hscroll_handler(GridWin,sc_Thumb,Pos):-
	grid_hscroll_info(GridWin,_,_,CurVPos,_),
	Column = Pos - CurVPos,
	grid_hmove_cells_area(GridWin,Column),!.
  grid_hscroll_handler(GridWin,sc_Top,_):-
	grid_hscroll_info(GridWin,_,_,CurVPos,_),
	Column = 1 - CurVPos,
	grid_hmove_cells_area(GridWin,Column),!.
  grid_hscroll_handler(GridWin,sc_Bottom,_):-
	grid_hscroll_info(GridWin,_,_,CurVPos,_),
	grid_column_info(GridWin,MaxColumn,_,_,_,_),
	Column = MaxColumn - CurVPos,
	grid_hmove_cells_area(GridWin,Column),!.
  grid_hscroll_handler(GridWin,_,_):-
	grid_SetFocus(GridWin),!.

predicates
determ  grid_reverse_list(GRID_AREALIST,GRID_AREALIST,GRID_AREALIST)
determ  grid_reverse_list(GRID_LINELIST,GRID_LINELIST,GRID_LINELIST)
clauses
  grid_reverse_list([],O,O):-!.
  grid_reverse_list([H|R],C,O):-!,
	grid_reverse_list(R,[H|C],O).

predicates
determ  grid_get_resize_area1(WINDOW GridWin,INTEGER X,INTEGER Column,INTEGER Column)
clauses
  grid_get_resize_area1(_,_,0,0):-!,fail.
  grid_get_resize_area1(GridWin,X,Column,Column):-
	grid_convert(GridWin,grid_column(Column),grid_lr(_,R,_,_,_,_,_,_),_),
	R1 = R - 2, R2 = R + 2,
	R1 <= X, X <= R2,!.
  grid_get_resize_area1(GridWin,X,Column1,Column):-
	Column2 = Column1 - 1,
	grid_get_resize_area1(GridWin,X,Column2,Column),!.

  grid_get_resize_area(GridWin,X,Y,Column):-
	grid_row_info(GridWin,_,_,TopTitleWidth,_,_,_,_),
	Y < TopTitleWidth,
	grid_column_info(GridWin,MaxColumn,_,_,_,_),
	grid_get_resize_area1(GridWin,X,MaxColumn,Column),!.
  grid_get_central_area(GridWin,X,Y,Row,Column):-
	grid_convert(GridWin,grid_x(X),grid_column(Column),Inside),
	Inside = b_true,
	grid_convert(GridWin,grid_y(Y),grid_row(Row),Insaid1),
	Insaid1 = b_true,!.
  grid_get_lt_area(GridWin,X,Y):-
	grid_row_info(GridWin,_,LeftTitleWidth,TopTitleWidth,_,_,_,_),
	X < LeftTitleWidth, Y < TopTitleWidth,!.
  grid_get_left_area(GridWin,X,Y,Row):-
	grid_row_info(GridWin,_,LeftTitleWidth,_,_,_,_,_),
	X < LeftTitleWidth,!,
	grid_convert(GridWin,grid_y(Y),grid_row(Row),Inside),
	Inside = b_true,!.
  grid_get_top_area(GridWin,X,Y,Column):-
	grid_row_info(GridWin,_,_,TopTitleWidth,_,_,_,_),
	Y < TopTitleWidth,!,
	grid_convert(GridWin,grid_x(X),grid_column(Column),Inside),
	Inside = b_true,!.

  grid_clear_subwin(GridWin,rct(L,T,R1,B1),BgColor,DefColor):-
	retract(grid_nocalc_clear_area),
	R = R1 + 1, B = B1 + 1,
	win_SetBrush(GridWin,brush(pat_Solid,BgColor)),
	win_SetPen(GridWin,pen(1,ps_Hollow,BgColor)),
	draw_Rect(GridWin,rct(L,T,R,B)),
	grid_row_info(GridWin,MaxRow,_,_,_,_,_,_),
	grid_column_info(GridWin,MaxColumn,_,_,_,_),
	grid_convert(GridWin,grid_row(MaxRow),grid_tb(_,B01),_),
	grid_convert(GridWin,grid_column(MaxColumn),grid_lr(_,R01,_,_,_,_,_,_),_),
	R0 = grid_min(R,R01), B0 = grid_min1(B,B01),
	win_SetBrush(GridWin,brush(pat_Solid,DefColor)),
	win_SetPen(GridWin,pen(1,ps_Hollow,DefColor)),
	R00 = R0 + 1, B00 = B0 + 1,
	B00I = grid_val(B00),
	draw_Rect(GridWin,rct(L,T,R00,B00I)),!.
  grid_clear_subwin(GridWin,rct(L,T,R1,B1),BgColor,DefColor):-
	R = R1 + 1, B = B1 + 1,
	grid_row_info(GridWin,MaxRow,_,_,_,_,_,_),
	grid_column_info(GridWin,MaxColumn,_,_,_,_),
	grid_convert(GridWin,grid_row(MaxRow),grid_tb(_,B01),_),
	grid_convert(GridWin,grid_column(MaxColumn),grid_lr(_,R01,_,_,_,_,_,_),_),
	R0 = grid_min1(R,R01), B0 = grid_min1(B,B01),
	win_SetBrush(GridWin,brush(pat_Solid,DefColor)),
	win_SetPen(GridWin,pen(1,ps_Hollow,DefColor)),
	R00 = R0 + 1, B00 = B0 + 1,
	R00I = grid_val(R00),
	B00I = grid_val(B00),
	B0I = grid_val(B0),
	R0I = grid_val(R0),
	draw_Rect(GridWin,rct(L,T,R00I,B00I)),
	win_SetBrush(GridWin,brush(pat_Solid,BgColor)),
	win_SetPen(GridWin,pen(1,ps_Hollow,BgColor)),
	draw_Rect(GridWin,rct(L,B0I,R00I,B)),
	draw_Rect(GridWin,rct(R0I,T,R,B)),!.
  grid_clear_subwin(_,_,_,_).


predicates
procedure  grid_redraw_title(WINDOW GridWin,RCT)
procedure  grid_draw_border(WINDOW GridWin,INTEGER FromRow,INTEGER ToRow,INTEGER FromColumn,INTEGER ToColumn)
clauses
  grid_handle_update(GridWin,rct(L,T,R,B)):-
	grid_convert(GridWin,grid_y(T),grid_row(FromRow),b_true),
	grid_convert(GridWin,grid_y(B),grid_row(ToRow),b_true),
	grid_convert(GridWin,grid_x(L),grid_column(FromColumn),b_true),
	grid_convert(GridWin,grid_x(R),grid_column(ToColumn),b_true),
	grid_draw_border(GridWin,FromRow,ToRow,FromColumn,ToColumn),
	FromRow <> 0, ToRow <> 0,
	grid_column_info(GridWin,_,_,FirstColumn,_,NoScrollColumns),
	NSC = NoScrollColumns + 1,
	NSC <> FirstColumn,
	grid_convert(GridWin,grid_column(NoScrollColumns),grid_lr(_,Right,_,_,_,_,_,_),_),
	L <= Right, Right <= R,
	FromColumn1 = NoScrollColumns, ToColumn1 = FirstColumn,
	grid_info(GridWin,_,Callbackfunc,_),
	Callbackfunc(GridWin,data_request(grid_area(FromRow,ToRow,FromColumn,FromColumn1)),Answer1),
	Callbackfunc(GridWin,data_request(grid_area(FromRow,ToRow,ToColumn1,ToColumn)),Answer2),
	grid_redraw_title(GridWin,rct(L,T,R,B)),
	grid_draw(GridWin,FromRow,ToRow,FromColumn,FromColumn1,Answer1),
	grid_draw(GridWin,FromRow,ToRow,ToColumn1,ToColumn,Answer2),!.
  grid_handle_update(GridWin,rct(L,T,R,B)):-
	grid_convert(GridWin,grid_y(T),grid_row(FromRow),b_true),
	grid_convert(GridWin,grid_y(B),grid_row(ToRow),b_true),
	grid_convert(GridWin,grid_x(L),grid_column(FromColumn),b_true),
	grid_convert(GridWin,grid_x(R),grid_column(ToColumn),b_true),
	FromRow <> 0, ToRow <> 0,
	grid_info(GridWin,_,Callbackfunc,_),
	Callbackfunc(GridWin,data_request(grid_area(FromRow,ToRow,FromColumn,ToColumn)),Answer),
	grid_redraw_title(GridWin,rct(L,T,R,B)),
	grid_draw(GridWin,FromRow,ToRow,FromColumn,ToColumn,Answer),!.
  grid_handle_update(GridWin,rct(L,T,R,B)):-
	grid_convert(GridWin,grid_y(T),grid_row(FromRow),b_true),
	grid_convert(GridWin,grid_y(B),grid_row(ToRow),b_true),
	grid_convert(GridWin,grid_x(L),grid_column(FromColumn),b_true),
	grid_convert(GridWin,grid_x(R),grid_column(ToColumn),b_true),
	FromRow <> 0, ToRow <> 0,
	grid_column_info(GridWin,_,_,FirstColumn,_,NoScrollColumns),
	NSC = NoScrollColumns + 1,
	NSC <> FirstColumn,
	grid_convert(GridWin,grid_column(NoScrollColumns),grid_lr(_,Right,_,_,_,_,_,_),_),
	L <= Right, Right <= R,
	FromColumn1 = NoScrollColumns, ToColumn1 = FirstColumn,
	grid_redraw_title(GridWin,rct(L,T,R,B)),
	grid_draw(GridWin,FromRow,ToRow,FromColumn,FromColumn1,data_answer(empty_answer)),
	grid_draw(GridWin,FromRow,ToRow,ToColumn1,ToColumn,data_answer(empty_answer)),!.
  grid_handle_update(GridWin,rct(L,T,R,B)):-
	grid_convert(GridWin,grid_y(T),grid_row(FromRow),b_true),
	grid_convert(GridWin,grid_y(B),grid_row(ToRow),b_true),
	grid_convert(GridWin,grid_x(L),grid_column(FromColumn),b_true),
	grid_convert(GridWin,grid_x(R),grid_column(ToColumn),b_true),
	FromRow <> 0, ToRow <> 0,
	grid_redraw_title(GridWin,rct(L,T,R,B)),
	grid_draw(GridWin,FromRow,ToRow,FromColumn,ToColumn,data_answer(empty_answer)),!.
  grid_handle_update(GridWin,rct(L,T,R,B)):-
	grid_redraw_title(GridWin,rct(L,T,R,B)),!.

/*************************************************************************
			     CALCULATION
 *************************************************************************/
% 1. Row	->	TB
  grid_convert(GridWin,grid_row(Row),Answer,Inside):-
  	bound(Inside),!,
	grid_correct(GridWin,grid_row(Row),grid_row(Row1)),
	grid_calc(GridWin,grid_row(Row1),Answer),!.
  grid_convert(GridWin,grid_row(Row),Answer,Inside):-
  	grid_calc(GridWin,grid_row(Row),Answer),
	grid_inside(GridWin,Answer,Inside),!.
% 2. Y		->	Row
  grid_convert(GridWin,grid_y(Y),Answer,Inside):-
  	bound(Inside),!,
	grid_calc(GridWin,grid_y(Y),Answer1),
	grid_correct(GridWin,Answer1,Answer),!.
  grid_convert(GridWin,grid_y(Y),Answer,Inside):-
  	grid_calc(GridWin,grid_y(Y),Answer),
	grid_inside(GridWin,grid_tb(Y,Y),Inside),!.
% 3. TopTitleRow	->	TB
  grid_convert(GridWin,grid_tt,Answer,Inside):-
  	bound(Inside),!,
  	grid_calc(GridWin,grid_tt,Answer),!.
  grid_convert(GridWin,grid_tt,Answer,b_true):-
  	grid_calc(GridWin,grid_tt,Answer),!.
% 4. Column	->	LR
  grid_convert(GridWin,grid_column(Column),Answer,Inside):-
  	bound(Inside),!,
	grid_correct(GridWin,grid_column(Column),grid_column(Column1)),
  	grid_calc(GridWin,grid_column(Column1),Answer),!.
  grid_convert(GridWin,grid_column(Column),Answer,Inside):-
  	grid_calc(GridWin,grid_column(Column),Answer),
	grid_inside(GridWin,Answer,Inside),!.
% 5. LeftTitleColumn->	LR
  grid_convert(GridWin,grid_lt,Answer,Inside):-
  	bound(Inside),!,
  	grid_calc(GridWin,grid_lt,Answer),!.
  grid_convert(GridWin,grid_lt,Answer,b_true):-
  	grid_calc(GridWin,grid_lt,Answer),!.
% 6. X		->	Column
  grid_convert(GridWin,grid_x(X),Answer,Inside):-
  	bound(Inside),!,
  	grid_calc(GridWin,grid_x(X),Answer1),
	grid_correct(GridWin,Answer1,Answer),!.
  grid_convert(GridWin,grid_x(X),Answer,Inside):-
  	grid_calc(GridWin,grid_x(X),Answer),
	grid_inside(GridWin,grid_lr(X,X,grid_center,grid_top_align,0,0,0,""),Inside),!.

  grid_convert(_,_,_,_):-!,fail.

% ***** Correction position inside area *****
% 1. Row -> Row
  grid_correct(GridWin,grid_row(_),Answer):-
	grid_row_info(GridWin,0,_,_,_,_,_,_),
	Answer = grid_row(0),!.
  grid_correct(GridWin,grid_row(Row),Answer):-
	grid_row_info(GridWin,_,_,_,_,_,FirstRow,_),
	Row < FirstRow,
	Answer = grid_row(FirstRow),!.
  grid_correct(GridWin,grid_row(Row),Answer):-
	grid_row_info(GridWin,_,_,_,_,_,_,LastRow),
	Row > LastRow,
	Answer = grid_row(LastRow),!.
  grid_correct(_,grid_row(Row),Answer):-
	Answer = grid_row(Row),!.
% 1. Column -> Column
  grid_correct(GridWin,grid_column(Column),Answer):-
	grid_column_info(GridWin,_,_,_,_,NoScrollColumn),
	1 <= Column, Column <= NoScrollColumn,
	Answer = grid_column(Column),!.
  grid_correct(GridWin,grid_column(0),Answer):-
	grid_column_info(GridWin,_,_,_,_,NoScrollColumn),
	NoScrollColumn > 0,
	Answer = grid_column(1),!.
  grid_correct(GridWin,grid_column(Column),Answer):-
	grid_column_info(GridWin,_,_,FirstColumn,_,_),
	Column < FirstColumn,
	Answer = grid_column(FirstColumn),!.
  grid_correct(GridWin,grid_column(Column),Answer):-
	grid_column_info(GridWin,_,_,_,LastColumn,_),
	Column > LastColumn,
	Answer = grid_column(LastColumn),!.
  grid_correct(_,grid_column(Column),Answer):-
	Answer = grid_column(Column),!.

  grid_correct(_,_,_):-!,fail.

% ***** Check position in area *****
% TB
  grid_inside(GridWin,grid_tb(_,Bottom1),b_false):-
	Bottom = Bottom1 - 1,
	grid_row_info(GridWin,_,_,TopTitleHeight,_,_,_,_),
  	Bottom < TopTitleHeight,!.
  grid_inside(GridWin,grid_tb(Top,_),b_false):-
	Y = grid_get_y_max(GridWin),
  	Top > Y,!.
% LR
  grid_inside(GridWin,grid_lr(_,Right1,_,_,_,_,_,_),b_false):-
	Right = Right1 - 1,
	grid_row_info(GridWin,_,LeftTitleWidth,_,_,_,_,_),
  	Right < LeftTitleWidth,!.
  grid_inside(GridWin,grid_lr(Left,_,_,_,_,_,_,_),b_false):-
	X = grid_get_x_max(GridWin),
  	Left > X,!.
% If inside area - b_true
  grid_inside(_,_,b_true).

% ***** Calculate position *****
predicates
determ grid_get_column_par(WINDOW GridWin,INTEGER Column,GRID_HORALIGNMENT,GRID_VERALIGNMENT,INTEGER DX,INTEGER DY,INTEGER MaxText,STRING Title)
clauses
  grid_get_column_par(GridWin,Column,HM,VM,DX,DY,MaxText,Title):-
	grid_column_stat(GridWin,Title,Column,_,_,HM,VM,DX,DY,MaxText),!.
  grid_get_column_par(_,_,grid_center,grid_top_align,0,0,0,"").

predicates
determ  grid_calc1(WINDOW GridWin,INTEGER AbsX,INTEGER Column)
clauses
% 1. Row	->	TB
  grid_calc(GridWin,grid_row(Row),Answer):-
	grid_row_info(GridWin,_,_,TopTitleHeight,Height,_,FirstRow,_),
	Top = (val(long,Row) - FirstRow) * Height + TopTitleHeight,
	Bottom = Top + Height,
	Answer = grid_tb(Top,Bottom),!.
% 2. TopTitleRow->	TB
  grid_calc(GridWin,grid_tt,Answer):-
	grid_row_info(GridWin,_,_,Bottom,_,_,_,_),
	Answer = grid_tb(0,Bottom),!.
% 3. Y		->	Row
  grid_calc(GridWin,grid_y(Y),Answer):-
	grid_row_info(GridWin,_,_,TopTitleHeight,Height,_,FirstRow,_),
	Y < TopTitleHeight,
	Row = FirstRow - (TopTitleHeight - Y) div Height,
	Answer = grid_row(Row),!.
  grid_calc(GridWin,grid_y(Y),Answer):-
	grid_row_info(GridWin,_,_,TopTitleHeight,Height,_,FirstRow,_),
	Row = (Y - TopTitleHeight) div Height + FirstRow,
	Answer = grid_row(Row),!.
% 4. Column	->	LR
  grid_calc(GridWin,grid_column(Column),Answer):-
	grid_column_info(GridWin,_,_,_,_,NoScrollColumun),
	Column <= NoScrollColumun,
	grid_column_stat(GridWin,_,Column,L,R,_,_,_,_,_),
	grid_row_info(GridWin,_,LeftWidth,_,_,_,_,_),
	Left = L + LeftWidth, Right = R + LeftWidth,
	grid_get_column_par(GridWin,Column,HM,VM,DXT,DYT,MaxText,Title),
	Answer = grid_lr(Left,Right,HM,VM,DXT,DYT,MaxText,Title),!.
  grid_calc(GridWin,grid_column(Column),Answer):-
	grid_column_info(GridWin,_,_,FirstColumn,_,NoScrollColumun),
	NoScrollColumun > 0,
	grid_column_stat(GridWin,_,Column,L,R,_,_,_,_,_),
	grid_column_stat(GridWin,_,FirstColumn,DX,_,_,_,_,_,_),
	grid_column_stat(GridWin,_,NoScrollColumun,_,DX1,_,_,_,_,_),
	grid_row_info(GridWin,_,LeftWidth,_,_,_,_,_),
	Left = L + LeftWidth - DX + DX1, Right = R + LeftWidth - DX + DX1,
	grid_get_column_par(GridWin,Column,HM,VM,DXT,DYT,MaxText,Title),
	Answer = grid_lr(Left,Right,HM,VM,DXT,DYT,MaxText,Title),!.
  grid_calc(GridWin,grid_column(Column),Answer):-
	grid_column_stat(GridWin,_,Column,L,R,_,_,_,_,_),
	grid_column_info(GridWin,_,_,FirstColumn,_,_),
	grid_column_stat(GridWin,_,FirstColumn,DX,_,_,_,_,_,_),
	grid_row_info(GridWin,_,LeftWidth,_,_,_,_,_),
	Left = L + LeftWidth - DX, Right = R + LeftWidth - DX,
	grid_get_column_par(GridWin,Column,HM,VM,DXT,DYT,MaxText,Title),
	Answer = grid_lr(Left,Right,HM,VM,DXT,DYT,MaxText,Title),!.
  grid_calc(GridWin,grid_column(_),Answer):-
	grid_row_info(GridWin,_,LeftWidth,_,_,_,_,_),
	Answer = grid_lr(LeftWidth,LeftWidth,grid_center,grid_top_align,0,0,0,""),!.
% 5. LeftTitleColumn->	LR
  grid_calc(GridWin,grid_lt,Answer):-
	grid_row_info(GridWin,_,Right,_,_,_,_,_),
	Answer = grid_lr(0,Right,grid_center,grid_top_align,0,0,0,""),!.
% 6. X		->	Column
  grid_calc(GridWin,grid_x(X),Answer):-
	grid_row_info(GridWin,_,LeftTitleWidth,_,_,_,_,_),
	X < LeftTitleWidth,
	Answer = grid_column(0),!.
  grid_calc(GridWin,grid_x(X),Answer):-
	grid_row_info(GridWin,_,LeftTitleWidth,_,_,_,_,_),
	X = LeftTitleWidth,
	Answer = grid_column(1),!.
  grid_calc(GridWin,grid_x(X),Answer):-
	grid_row_info(GridWin,_,LeftTitleWidth,_,_,_,_,_),
	AbsX = X - LeftTitleWidth,
	grid_column_info(GridWin,_,_,_,_,NoScrollColumn),
	NSC = NoScrollColumn + 1,
	grid_column_stat(GridWin,_,NSC,DX,_,_,_,_,_,_),
	AbsX <= DX,
	grid_calc1(GridWin,AbsX,Column),
	Answer = grid_column(Column),!.
  grid_calc(GridWin,grid_x(X),Answer):-
	grid_column_info(GridWin,_,_,FirstColumn,_,NoScrollColumn),
	grid_row_info(GridWin,_,LeftTitleWidth,_,_,_,_,_),
	grid_column_stat(GridWin,_,FirstColumn,DX,_,_,_,_,_,_),
	NSC = NoScrollColumn + 1,
	grid_column_stat(GridWin,_,NSC,DX1,_,_,_,_,_,_),
	AbsX = X - LeftTitleWidth + DX - DX1,
	grid_calc1(GridWin,AbsX,Column),
	Answer = grid_column(Column),!.
  grid_calc(GridWin,_,Answer):-
	grid_column_info(GridWin,MaxColumn,_,_,_,_),
	Column = MaxColumn + 1,
	Answer = grid_column(Column),!.

  grid_calc(_,_,_):-!,fail.

  grid_calc1(GridWin,Absx,Column):-
	grid_column_stat(GridWin,_,Column,L,R,_,_,_,_,_),
	L <= AbsX, AbsX <= R,!.

  grid_get_x_max(GridWin,X):-
	RCT = grid_my_win_GetClientRect(GridWin),
	RCT = rct(_,_,X1,_),
	grid_convert(GridWin,grid_x(X1),grid_column(Column),b_true),
	grid_convert(GridWin,grid_column(Column),grid_lr(_,X2,_,_,_,_,_,_),b_true),
	X = grid_min(X1,X2),!.

  grid_get_y_max(GridWin,Y):-
	RCT = grid_my_win_GetClientRect(GridWin),
	RCT = rct(_,_,_,Y1),
	grid_convert(GridWin,grid_y(Y1),grid_row(Row),b_true),
	grid_convert(GridWin,grid_row(Row),grid_tb(_,Y2),b_true),
	Y2I = grid_val(Y2),
	Y = grid_min(Y1,Y2I),!.

predicates
determ  grid_check_line_marker(INTEGER RC,GRID_LINELIST RCList)
clauses
  grid_check_line_marker(_,[]):-!,fail.
  grid_check_line_marker(RC,[gl(FromRC,ToRC)|_]):-
	FromRC <= RC, RC <= ToRC,!.
  grid_check_line_marker(Row,[_|Rest]):-!,
	grid_check_line_marker(Row,Rest).

predicates
procedure  grid_redraw_left_title(WINDOW GridWin,INTEGER Left,INTEGER Top,INTEGER Bottom)
procedure  grid_redraw_top_title(WINDOW GridWin,INTEGER Top,INTEGER Left,INTEGER Right)
procedure  grid_redraw_lt_title(WINDOW GridWin,INTEGER Left,INTEGER Top)
determ  grid_draw_left_title(WINDOW GridWin,INTEGER FromRow,INTEGER ToRow)
procedure  grid_draw_top_title(WINDOW GridWin,INTEGER FromColumn,INTEGER ToColumn)

procedure  grid_draw_left_title_border(WINDOW GridWin,INTEGER FromRow,INTEGER ToRow)
procedure  grid_draw_top_title_border(WINDOW GridWin,INTEGER FromColumn,INTEGER ToColumn)
procedure  grid_draw_lt_title_border(WINDOW GridWin)
clauses
  grid_redraw_title(GridWin,rct(L,T,R,B)):-
	grid_redraw_left_title(GridWin,L,T,B),
	grid_redraw_top_title(GridWin,T,L,R),
	grid_redraw_lt_title(GridWin,L,T),!.
  grid_redraw_title(_,_):-!.

  grid_redraw_left_title(GridWin,L,T,B):-
	grid_row_info(GridWin,_,LeftTitleWidth,_,_,_,_,_),
	L <= LeftTitleWidth,
	grid_convert(GridWin,grid_y(T),grid_row(FromRow),b_true),
	grid_convert(GridWin,grid_y(B),grid_row(ToRow),b_true),
	grid_draw_left_title(GridWin,FromRow,ToRow),
	grid_draw_left_title_border(GridWin,FromRow,ToRow),!.
  grid_redraw_left_title(_,_,_,_).
  grid_redraw_top_title(GridWin,T,L,R):-
	grid_row_info(GridWin,_,_,TopTitleWidth,_,_,_,_),
	T <= TopTitleWidth,
	grid_convert(GridWin,grid_x(L),grid_column(FromColumn),b_true),
	grid_convert(GridWin,grid_x(R),grid_column(ToColumn),b_true),!,
	grid_draw_top_title(GridWin,FromColumn,ToColumn),
	grid_draw_top_title_border(GridWin,FromColumn,ToColumn),!.
  grid_redraw_top_title(_,_,_,_).
  grid_redraw_lt_title(GridWin,L,T):-
	grid_get_lt_area(GridWin,L,T),
	grid_view_info(GridWin,_,_,_,_,_,_,_,Back_Color,Txt_color,_),
	grid_draw_pushbotton(GridWin,grid_tt,grid_lt,
	Back_color,Txt_color,0,0,grid_center,grid_center,""),
	grid_draw_lt_title_border(GridWin),!.
  grid_redraw_lt_title(_,_,_).

predicates
determ  grid_check_view(WINDOW GridWin,INTEGER Column)
clauses
  grid_check_view(GridWin,Column):-
	grid_column_info(GridWin,_,_,_,_,NoScrollColumns),
	Column <= NoScrollColumns,!.
  grid_check_view(GridWin,Column):-
	grid_column_info(GridWin,_,_,_,_,NoScrollColumns),
	grid_convert(GridWin,grid_column(Column),grid_lr(L,_,_,_,_,_,_,_),_),
	grid_convert(GridWin,grid_column(NoScrollColumns),grid_lr(_,R,_,_,_,_,_,_),_),
	L >= R,!.

predicates
determ  grid_get_lefttextwidth(WINDOW GridWin,INTEGER R,INTEGER R1)
clauses
  grid_get_lefttextwidth(GridWin,R,R):-
	grid_view_info(GridWin,_,_,b_false,_,_,_,_,_,_,_),!.
  grid_get_lefttextwidth(GridWin,R,R1):-
	grid_row_info(GridWin,_,_,TopTitleHeight,_,_,_,_),
	TreAngleWidth = ((TopTitleHeight div 2) - grid_row_height) div 2,
	R1 = R - TreAngleWidth - grid_row_height,!.

predicates
procedure  grid_draw_ActiveRowPointer(WINDOW GridWin)
clauses
  grid_draw_ActiveRowPointer(GridWin):-
	grid_row_info(GridWin,_,0,_,_,_,_,_),!.
  grid_draw_ActiveRowPointer(GridWin):-
	grid_row_info(GridWin,0,_,_,_,_,_,_),!.
  grid_draw_ActiveRowPointer(GridWin):-
	grid_view_info(GridWin,_,_,b_false,_,_,_,_,_,_,_),!.
  grid_draw_ActiveRowPointer(GridWin):-
	grid_view_info(GridWin,_,_,_,0,_,_,_,_,_,_),!.
  grid_draw_ActiveRowPointer(GridWin):-
	win_GetFontMetrics(GridWin,_,Ascent,Descent),
	ThreeAngleWidth = (Ascent + Descent) div 2,
	grid_view_info(GridWin,_,_,_,ActiveRow,_,_,_,_,_,_),
	grid_convert(GridWin,grid_row(ActiveRow),grid_tb(Tx,_),_),
	Txx = grid_min1(Tx,10000),
	T = Grid_max1(Txx,-10000),
	grid_convert(GridWin,grid_lt,grid_lr(_,R,_,_,_,_,_,_),_),
	DX = grid_row_height div 2,
	X1 = R - DX, X2 = X1 - ThreeAngleWidth,
	Y1 = T + DX, Y2 = Y1 + ThreeAngleWidth, Y3 = Y2 + ThreeAngleWidth,
	win_SetBrush(GridWin,brush(pat_Solid,color_Black)),
	win_SetPen(GridWin,pen(1,ps_Solid,color_Black)),
	Y1I = grid_val(Y1),
	Y2I = grid_val(Y2),
	Y3I = grid_val(Y3),
	draw_Polygon(GridWin,[pnt(X2,Y1I),pnt(X2,Y3I),pnt(X1,Y2I),pnt(X2,Y1I)]),!.
  grid_draw_ActiveRowPointer(_):-!.

predicates
determ  grid_get_row_title(WINDOW GridWin,INTEGER Row,STRING)
determ  grid_draw_left_title1(WINDOW GridWin,INTEGER Row)
clauses
  grid_draw_left_title(GridWin,FromRow,ToRow):-
	FromRow > ToRow,
	grid_draw_ActiveRowPointer(GridWin),!.
  grid_draw_left_title(GridWin,FromRow,ToRow):-
	grid_draw_left_title1(GridWin,FromRow),
	FR = FromRow + 1,!,
	grid_draw_left_title(GridWin,FR,ToRow).

  grid_draw_left_title1(_,0):-!.
  grid_draw_left_title1(GridWin,Row):-
	grid_view_info(GridWin,_,_,_,_,_,_,_,Back_Color,Txt_color,_),
	grid_get_row_title(GridWin,Row,String),
	grid_draw_pushbotton(GridWin,grid_row(Row),grid_lt,
	Back_color,Txt_color,0,0,grid_center,grid_center,String),!.

  grid_get_row_title(GridWin,Row,String):-
	grid_view_info(GridWin,_,grid_number,_,_,_,_,_,_,_,_),
	str_int(String,Row),!.
  grid_get_row_title(_,_,"").

predicates
procedure  grid_redraw_activerow(WINDOW GridWin,BOOLEAN ActiveRowPointer,INTEGER OldRow)
clauses
  grid_redraw_activerow(GridWin,b_true,OldRow):-
	grid_convert(GridWin,grid_row(OldRow),grid_tb(Tx,Bx),_),
	Txx = grid_min1(Tx,10000),
	T = grid_max1(Txx,-10000),
	Bxx = grid_min1(Bx,10000),
	B = grid_max1(Bxx,-10000),
	grid_convert(GridWin,grid_lt,grid_lr(L,R,_,_,_,_,_,_),_),
	TI = grid_val(T),
	BI = grid_val(B),
	win_Invalidate(GridWin,rct(L,TI,R,BI)),
	grid_draw_ActiveRowPointer(GridWin),!.
  grid_redraw_activerow(_,_,_).

predicates
determ  grid_reset_activerow(WINDOW GridWin,INTEGER Row)
determ  grid_reset_activerow(WINDOW GridWin)
clauses
  grid_reset_activerow(GridWin,Row):-
	retract(grid_view_info(GridWin,GridCellsStyle,GridRowSelector,ActiveRowPointer,OldRow,DefaultColor,BgColor,FrColor,BgTitleColor,FgTitleColor,InvisibleMarkers)),
	assert(grid_view_info(GridWin,GridCellsStyle,GridRowSelector,ActiveRowPointer,Row,DefaultColor,BgColor,FrColor,BgTitleColor,FgTitleColor,InvisibleMarkers)),
	grid_redraw_activerow(GridWin,ActiveRowPointer,OldRow),!.

  grid_reset_activerow(GridWin):-
	grid_edit(GridWin,_,_,Row,_,_,_),
	retract(grid_view_info(GridWin,GridCellsStyle,GridRowSelector,ActiveRowPointer,OldRow,DefaultColor,BgColor,FrColor,BgTitleColor,FgTitleColor,InvisibleMarkers)),
	assert(grid_view_info(GridWin,GridCellsStyle,GridRowSelector,ActiveRowPointer,Row,DefaultColor,BgColor,FrColor,BgTitleColor,FgTitleColor,InvisibleMarkers)),
	grid_redraw_activerow(GridWin,ActiveRowPointer,OldRow),!.
  grid_reset_activerow(GridWin):-
	grid_row(GridWin,RowList),
	grid_reverse_list(RowList,[],RowList1),
	RowList1 = [gl(Row,_)|_],
	retract(grid_view_info(GridWin,GridCellsStyle,GridRowSelector,ActiveRowPointer,OldRow,DefaultColor,BgColor,FrColor,BgTitleColor,FgTitleColor,InvisibleMarkers)),
	assert(grid_view_info(GridWin,GridCellsStyle,GridRowSelector,ActiveRowPointer,Row,DefaultColor,BgColor,FrColor,BgTitleColor,FgTitleColor,InvisibleMarkers)),
	grid_redraw_activerow(GridWin,ActiveRowPointer,OldRow),!.
  grid_reset_activerow(GridWin):-
	grid_area(GridWin,GridCellList),
	grid_reverse_list(GridCellList,[],GridCellList1),
	GridCellList1 = [ga(Row,_,_,_)|_],
	retract(grid_view_info(GridWin,GridCellsStyle,GridRowSelector,ActiveRowPointer,OldRow,DefaultColor,BgColor,FrColor,BgTitleColor,FgTitleColor,InvisibleMarkers)),
	assert(grid_view_info(GridWin,GridCellsStyle,GridRowSelector,ActiveRowPointer,Row,DefaultColor,BgColor,FrColor,BgTitleColor,FgTitleColor,InvisibleMarkers)),
	grid_redraw_activerow(GridWin,ActiveRowPointer,OldRow),!.
  grid_reset_activerow(_).

predicates
procedure  grid_draw_top_title1(WINDOW GridWin,INTEGER Column)
clauses
  grid_draw_top_title(_,FromColumn,ToColumn):-
	FromColumn > ToColumn,!.
  grid_draw_top_title(GridWin,FromColumn,ToColumn):-
	grid_column_info(GridWin,_,_,FirstColumn,_,NoScrollColumns),
	NoScrollColumns < FromColumn, FromColumn < FirstColumn,
	FC = FromColumn + 1,!,
	grid_draw_top_title(GridWin,FC,ToColumn).
  grid_draw_top_title(GridWin,FromColumn,ToColumn):-
	grid_draw_top_title1(GridWin,FromColumn),
	FC = FromColumn + 1,!,
	grid_draw_top_title(GridWin,FC,ToColumn).

  grid_draw_top_title1(GridWin,Column):-
	grid_all(GridWin),
	grid_view_info(GridWin,_,_,_,_,_,_,_,Back_Color,Txt_color,_),
	grid_convert(GridWin,grid_column(Column),grid_lr(_,_,_,_,_,_,_,String),_),
	grid_draw_pushbotton(GridWin,grid_tt,grid_column(Column),
	Back_color,Txt_color,0,0,grid_center,grid_center,String),!.
  grid_draw_top_title1(GridWin,Column):-
	grid_column(GridWin,ColumnList),
	grid_check_line_marker(Column,ColumnList),
	grid_view_info(GridWin,_,_,_,_,_,_,_,Back_Color,Txt_color,_),
	grid_convert(GridWin,grid_column(Column),grid_lr(_,_,_,_,_,_,_,String),_),
	grid_draw_pushbotton(GridWin,grid_tt,grid_column(Column),
	Back_color,Txt_color,0,0,grid_center,grid_center,String),!.
  grid_draw_top_title1(GridWin,Column):-
	grid_view_info(GridWin,_,_,_,_,_,_,_,Back_Color,Txt_color,_),
	grid_convert(GridWin,grid_column(Column),grid_lr(_,_,_,_,_,_,_,String),_),
	grid_draw_pushbotton(GridWin,grid_tt,grid_column(Column),
	Back_color,Txt_color,0,0,grid_center,grid_center,String),!.
  grid_draw_top_title1(_,_):-!.

  grid_redraw(GridWin):-
	RCT = grid_my_win_GetClientRect(GridWin),
	win_Invalidate(GridWin,RCT),!.

predicates
procedure  grid_draw_horz_line(WINDOW GridWin,INTEGER L,INTEGER R,INTEGER T,INTEGER B,INTEGER Step,INTEGER Shift)
clauses
  grid_draw_horz_line(_,_,_,T,B,_,_):-
	T > B,!.
  grid_draw_horz_line(GridWin,L,R,T,B,Step,Shift):-
	TX = T + Shift,
	draw_Line(GridWin,pnt(L,TX),pnt(R,TX)),
	T1 = T + Step,!,
	grid_draw_horz_line(GridWin,L,R,T1,B,Step,Shift).

predicates
determ  grid_draw_vert_line(WINDOW GridWin,INTEGER FromColumn,INTEGER ToColumn,INTEGER T,INTEGER B,INTEGER Shift)
clauses
  grid_draw_vert_line(GridWin,_,ToColumn,T,B,Shift):-
	grid_column_info(GridWin,_,_,FirstColumn,_,NoScrollColumns),
	ToColumn < FirstColumn, ToColumn > NoScrollColumns,
	grid_convert(GridWin,grid_column(FirstColumn),grid_lr(X1,_,_,_,_,_,_,_),b_true),
	X = X1 + Shift,
	draw_Line(GridWin,pnt(X,T),pnt(X,B)),!.
  grid_draw_vert_line(GridWin,FromColumn,ToColumn,T,B,Shift):-
	FromColumn > ToColumn,
	grid_convert(GridWin,grid_column(ToColumn),grid_lr(_,X1,_,_,_,_,_,_),b_true),
	X = X1 + Shift,
	draw_Line(GridWin,pnt(X,T),pnt(X,B)),!.
  grid_draw_vert_line(GridWin,FromColumn,ToColumn,T,B,Shift):-
	grid_convert(GridWin,grid_column(FromColumn),grid_lr(X1,_,_,_,_,_,_,_),b_true),
	X = X1 + Shift,
	draw_Line(GridWin,pnt(X,T),pnt(X,B)),
	FC = FromColumn + 1,!,
	grid_draw_vert_line(GridWin,FC,ToColumn,T,B,Shift).

predicates
procedure grid_correcrt_title_Width(WINDOW GridWin,INTEGER A,INTEGER B)
clauses
  grid_correcrt_title_Width(GridWin,A,A):-
	grid_view_info(GridWin,grid_raised,_,_,_,_,_,_,_,_,_),!.
  grid_correcrt_title_Width(_,A,B):-
	B = A - 1.

  grid_draw_lt_title_border(GridWin):-
	grid_view_info(GridWin,grid_raised,_,_,_,_,_,_,_,_,b_false),
	grid_all(GridWin),
	grid_row_info(GridWin,_,Width,Height,_,_,_,_),
	Width1X = Width - 1, Height1X = Height - 1,
	grid_correcrt_title_Width(GridWin,Width1X,Width1),
	grid_correcrt_title_Width(GridWin,Height1X,Height1),
	win_SetPen(GridWin,pen(1,ps_Solid,color_Black)),
	draw_Line(GridWin,pnt(0,0),pnt(0,Height1)),
	draw_Line(GridWin,pnt(0,0),pnt(Width1,0)),
	win_SetPen(GridWin,pen(1,ps_Solid,color_White)),
	draw_Line(GridWin,pnt(Width1,Height1),pnt(0,Height1)),
	draw_Line(GridWin,pnt(Width1,Height1),pnt(Width1,0)),!.
  grid_draw_lt_title_border(GridWin):-
	grid_view_info(GridWin,grid_raised,_,_,_,_,_,_,_,_,_),
	grid_row_info(GridWin,_,Width,Height,_,_,_,_),
	Width1X = Width - 1, Height1X = Height - 1,
	grid_correcrt_title_Width(GridWin,Width1X,Width1),
	grid_correcrt_title_Width(GridWin,Height1X,Height1),
	win_SetPen(GridWin,pen(1,ps_Solid,color_White)),
	draw_Line(GridWin,pnt(0,0),pnt(0,Height1)),
	draw_Line(GridWin,pnt(0,0),pnt(Width1,0)),
	win_SetPen(GridWin,pen(1,ps_Solid,color_Black)),
	draw_Line(GridWin,pnt(Width1,Height1),pnt(0,Height1)),
	draw_Line(GridWin,pnt(Width1,Height1),pnt(Width1,0)),!.
  grid_draw_lt_title_border(GridWin):-
	grid_view_info(GridWin,grid_raisedplain,_,_,_,_,_,_,_,_,b_false),
	grid_all(GridWin),
	grid_row_info(GridWin,_,Width,Height,_,_,_,_),
	Width1X = Width - 1, Height1X = Height - 1,
	grid_correcrt_title_Width(GridWin,Width1X,Width1),
	grid_correcrt_title_Width(GridWin,Height1X,Height1),
	win_SetPen(GridWin,pen(1,ps_Solid,color_Black)),
	draw_Line(GridWin,pnt(0,0),pnt(0,Height1)),
	draw_Line(GridWin,pnt(0,0),pnt(Width1,0)),
	win_SetPen(GridWin,pen(1,ps_Solid,color_White)),
	draw_Line(GridWin,pnt(Width1,Height1),pnt(0,Height1)),
	draw_Line(GridWin,pnt(Width1,Height1),pnt(Width1,0)),!.
  grid_draw_lt_title_border(GridWin):-
	grid_view_info(GridWin,grid_raisedplain,_,_,_,_,_,_,_,_,_),
	grid_row_info(GridWin,_,Width,Height,_,_,_,_),
	Width1X = Width - 1, Height1X = Height - 1,
	grid_correcrt_title_Width(GridWin,Width1X,Width1),
	grid_correcrt_title_Width(GridWin,Height1X,Height1),
	win_SetPen(GridWin,pen(1,ps_Solid,color_White)),
	draw_Line(GridWin,pnt(0,0),pnt(0,Height1)),
	draw_Line(GridWin,pnt(0,0),pnt(Width1,0)),
	win_SetPen(GridWin,pen(1,ps_Solid,color_Black)),
	draw_Line(GridWin,pnt(Width1,Height1),pnt(0,Height1)),
	draw_Line(GridWin,pnt(Width1,Height1),pnt(Width1,0)),!.
  grid_draw_lt_title_border(GridWin):-
	grid_view_info(GridWin,_,_,_,_,_,_,_,_,_,b_false),
	grid_all(GridWin),
	grid_row_info(GridWin,_,WidthX,HeightX,_,_,_,_),
	grid_correcrt_title_Width(GridWin,WidthX,Width),
	grid_correcrt_title_Width(GridWin,HeightX,Height),
	win_SetPen(GridWin,pen(1,ps_Solid,color_White)),
	draw_Line(GridWin,pnt(0,0),pnt(0,Height)),
	draw_Line(GridWin,pnt(0,0),pnt(Width,0)),
	draw_Line(GridWin,pnt(Width,Height),pnt(0,Height)),
	draw_Line(GridWin,pnt(Width,Height),pnt(Width,0)),!.
  grid_draw_lt_title_border(GridWin):-
	grid_row_info(GridWin,_,WidthX,HeightX,_,_,_,_),
	grid_correcrt_title_Width(GridWin,WidthX,Width),
	grid_correcrt_title_Width(GridWin,HeightX,Height),
	win_SetPen(GridWin,pen(1,ps_Solid,color_Black)),
	draw_Line(GridWin,pnt(0,0),pnt(0,Height)),
	draw_Line(GridWin,pnt(0,0),pnt(Width,0)),
	draw_Line(GridWin,pnt(Width,Height),pnt(0,Height)),
	draw_Line(GridWin,pnt(Width,Height),pnt(Width,0)),!.
  grid_draw_lt_title_border(_):-!.

predicates
procedure  grid_draw_border_left(WINDOW GridWin,INTEGER Width,INTEGER FromRow,INTEGER ToRow,
	GRID_CELLS_STYLE CellStyle,INTEGER Pressed)
clauses
  grid_draw_border_left(GridWin,_,FromRow,_,_,_):-
	grid_row_info(GridWin,_,_,_,_,_,_,LastRow),
	FromRow > LastRow,!.
  grid_draw_border_left(GridWin,_,_,ToRow,_,_):-
	grid_row_info(GridWin,_,_,_,_,_,FirstRow,_),
	ToRow < FirstRow,!.
	
  grid_draw_border_left(GridWin,Width,FromRow,ToRow,grid_raised,grid_normal):-
	grid_convert(GridWin,grid_row(FromRow),grid_tb(Tx,_),b_true),
	grid_convert(GridWin,grid_row(ToRow),grid_tb(_,Bx),b_true),
	Txx = grid_min1(Tx,10000),
	T = grid_max1(Txx,-10000),
	Bxx = grid_min1(Bx,10000),
	B = grid_max1(Bxx,-10000),
	grid_row_info(GridWin,_,_,_,Step,_,_,_),
	win_SetPen(GridWin,pen(1,ps_Solid,color_Black)),
	T1 = T - 1,
	T1I = grid_val(T1),
	BI = grid_val(B),
	TI = grid_val(T),
	Width1 = Width - 1,
	grid_draw_horz_line(GridWin,0,Width,T1I,BI,Step,0),
	draw_Line(GridWin,pnt(Width1,T1I),pnt(Width1,BI)),
	win_SetPen(GridWin,pen(1,ps_Solid,color_White)),
	grid_draw_horz_line(GridWin,0,Width,TI,BI,Step,0),
	draw_Line(GridWin,pnt(0,T1I),pnt(0,BI)),!.
  grid_draw_border_left(GridWin,Width,FromRow,ToRow,grid_raised,grid_pressed):-
	grid_convert(GridWin,grid_row(FromRow),grid_tb(Tx,_),b_true),
	grid_convert(GridWin,grid_row(ToRow),grid_tb(_,Bx),b_true),
	Txx = grid_min1(Tx,10000),
	T = grid_max1(Txx,-10000),
	Bxx = grid_min1(Bx,10000),
	B = grid_max1(Bxx,-10000),
	grid_row_info(GridWin,_,_,_,Step,_,_,_),
	FromRow1 = FromRow + 1,
	grid_convert(GridWin,grid_row(FromRow1),grid_tb(T1x,_),b_true),
	T1xx = grid_min1(T1x,10000),
	T1 = grid_max1(T1xx,-10000),
	T0 = T1 - 1,
	Width1 = Width - 1,
	TI = grid_val(T),
	T0I = grid_val(T0),
	BI = grid_val(B),
	win_SetPen(GridWin,pen(1,ps_Solid,color_White)),
	grid_draw_horz_line(GridWin,0,Width,T0I,BI,Step,0),
	draw_Line(GridWin,pnt(Width1,TI),pnt(Width1,BI)),
	win_SetPen(GridWin,pen(1,ps_Solid,color_Black)),
	ToRow1 = ToRow - 1,
	grid_convert(GridWin,grid_row(ToRow1),grid_tb(_,B1x),_),
	B1xx = grid_min1(B1x,10000),
	B1 = grid_max1(B1xx,-10000),
	B1I = grid_val(B1),
	grid_draw_horz_line(GridWin,0,Width,TI,B1I,Step,0),
	draw_Line(GridWin,pnt(0,TI),pnt(0,BI)),!.
  grid_draw_border_left(GridWin,Width,FromRow,ToRow,grid_raisedplain,grid_normal):-
	grid_convert(GridWin,grid_row(FromRow),grid_tb(Tx,_),b_true),
	grid_convert(GridWin,grid_row(ToRow),grid_tb(_,Bx),b_true),
	Txx = grid_min1(Tx,10000),
	T = grid_max1(Txx,-10000),
	Bxx = grid_min1(Bx,10000),
	B = grid_max1(Bxx,-10000),
	grid_row_info(GridWin,_,_,_,Step,_,_,_),
	win_SetPen(GridWin,pen(1,ps_Solid,color_Black)),
	T1 = T - 1,
	T1I = grid_val(T1),
	BI = grid_val(B),
	TI = grid_val(T),
	Width1 = Width - 1,
	grid_draw_horz_line(GridWin,0,Width,T1I,BI,Step,0),
	draw_Line(GridWin,pnt(Width1,T1I),pnt(Width1,BI)),
	win_SetPen(GridWin,pen(1,ps_Solid,color_White)),
	grid_draw_horz_line(GridWin,0,Width,TI,BI,Step,0),
	draw_Line(GridWin,pnt(0,T1I),pnt(0,BI)),!.
  grid_draw_border_left(GridWin,Width,FromRow,ToRow,grid_raisedplain,grid_pressed):-
	grid_convert(GridWin,grid_row(FromRow),grid_tb(Tx,_),b_true),
	grid_convert(GridWin,grid_row(ToRow),grid_tb(_,Bx),b_true),
	Txx = grid_min1(Tx,10000),
	T = grid_max1(Txx,-10000),
	Bxx = grid_min1(Bx,10000),
	B = grid_max1(Bxx,-10000),
	grid_row_info(GridWin,_,_,_,Step,_,_,_),
	FromRow1 = FromRow + 1,
	grid_convert(GridWin,grid_row(FromRow1),grid_tb(T1x,_),b_true),
	T1xx = grid_min1(T1x,10000),
	T1 = grid_max1(T1xx,-10000),
	T0 = T1 - 1,
	Width1 = Width - 1,
	TI = grid_val(T),
	T0I = grid_val(T0),
	BI = grid_val(B),
	win_SetPen(GridWin,pen(1,ps_Solid,color_White)),
	grid_draw_horz_line(GridWin,0,Width,T0I,BI,Step,0),
	draw_Line(GridWin,pnt(Width1,TI),pnt(Width1,BI)),
	win_SetPen(GridWin,pen(1,ps_Solid,color_Black)),
	ToRow1 = ToRow - 1,
	grid_convert(GridWin,grid_row(ToRow1),grid_tb(_,B1x),_),
	B1xx = grid_min1(B1x,10000),
	B1 = grid_max1(B1xx,-10000),
	B1I = grid_val(B1),
	grid_draw_horz_line(GridWin,0,Width,TI,B1I,Step,0),
	draw_Line(GridWin,pnt(0,TI),pnt(0,BI)),!.
  grid_draw_border_left(GridWin,Width,FromRow,ToRow,grid_plain,grid_normal):-
	grid_convert(GridWin,grid_row(FromRow),grid_tb(Tx,_),b_true),
	grid_convert(GridWin,grid_row(ToRow),grid_tb(_,Bx),b_true),
	Txx = grid_min1(Tx,10000),
	T = grid_max1(Txx,-10000),
	Bxx = grid_min1(Bx,10000),
	B = grid_max1(Bxx,-10000),
	grid_row_info(GridWin,_,_,_,Step,_,_,_),
	win_SetPen(GridWin,pen(1,ps_Solid,color_Black)),
	T1 = T - 1,
	T1I = grid_val(T1),
	BI = grid_val(B),
	grid_draw_horz_line(GridWin,0,Width,T1I,BI,Step,0),
	draw_Line(GridWin,pnt(0,T1I),pnt(0,BI)),
	draw_Line(GridWin,pnt(Width,T1I),pnt(Width,BI)),!.
  grid_draw_border_left(GridWin,Width,FromRow,ToRow,grid_plain,grid_pressed):-
	grid_convert(GridWin,grid_row(FromRow),grid_tb(Tx,_),b_true),
	grid_convert(GridWin,grid_row(ToRow),grid_tb(_,Bx),b_true),
	Txx = grid_min1(Tx,10000),
	T = grid_max1(Txx,-10000),
	Bxx = grid_min1(Bx,10000),
	B = grid_max1(Bxx,-10000),
	grid_row_info(GridWin,_,_,_,Step,_,_,_),
	win_SetPen(GridWin,pen(1,ps_Solid,color_White)),
	T1 = T - 1,
	T1I = grid_val(T1),
	BI = grid_val(B),
	grid_draw_horz_line(GridWin,0,Width,T1I,BI,Step,0),
	draw_Line(GridWin,pnt(0,T1I),pnt(0,BI)),
	draw_Line(GridWin,pnt(Width,T1I),pnt(Width,BI)),!.
  grid_draw_border_left(_,_,_,_,_,_).

predicates
determ  grid_draw_left_row_markers(WINDOW GridWin,GRID_CELLS_STYLE CellStyle,GRID_LINELIST RowList)
clauses
  grid_draw_left_row_markers(GridWin,_,_):-
	grid_view_info(GridWin,_,_,_,_,_,_,_,_,_,b_true),!.
  grid_draw_left_row_markers(_,_,[]):-!.
  grid_draw_left_row_markers(GridWin,CellStyle,[gl(FromRow,ToRow)|Rest]):-
	grid_row_info(GridWin,_,LeftTitleWidthX,_,_,_,_,_),
	grid_correcrt_title_Width(GridWin,LeftTitleWidthX,LeftTitleWidth),
	grid_draw_border_left(GridWin,LeftTitleWidth,FromRow,ToRow,CellStyle,grid_pressed),!,
	grid_draw_left_row_markers(GridWin,CellStyle,Rest).

predicates
procedure  grid_draw_left_markers(WINDOW GridWin)
clauses
  grid_draw_left_markers(GridWin):-
	grid_row(GridWin,RowList),
	grid_view_info(GridWin,CellStyle,_,_,_,_,_,_,_,_,_),
	grid_draw_left_row_markers(GridWin,CellStyle,RowList),!.
  grid_draw_left_markers(_).

  grid_draw_left_title_border(GridWin,FromRow0,ToRow0):-
	grid_row_info(GridWin,MaxRow,LeftTitleWidthX,_,_,_,_,_),
	grid_correcrt_title_Width(GridWin,LeftTitleWidthX,LeftTitleWidth),
	FromRow01 = grid_max(FromRow0,1),
	FromRow = grid_min(FromRow01,MaxRow),
	ToRow01 = grid_max(ToRow0,1),
	ToRow = grid_min(ToRow01,MaxRow),
	grid_view_info(GridWin,CellStyle,_,_,_,_,_,_,_,_,_),
	grid_draw_border_left(GridWin,LeftTitleWidth,FromRow,ToRow,CellStyle,grid_normal),
	grid_draw_left_markers(GridWin),!.
  grid_draw_left_title_border(_,_,_):-!.

predicates
procedure  grid_draw_border_top(WINDOW GridWin,INTEGER Height,INTEGER FromColumn,INTEGER ToColumn,
	GRID_CELLS_STYLE CellStyle,INTEGER Pressed)
clauses
  grid_draw_border_top(GridWin,_,FromColumn,_,_,_):-
	grid_column_info(GridWin,_,_,_,LastColumn,_),
	FromColumn > LastColumn,!.
  grid_draw_border_top(GridWin,_,_,ToColumn,_,_):-
	grid_column_info(GridWin,_,_,FirstColumn,_,0),
	ToColumn < FirstColumn,!.

  grid_draw_border_top(GridWin,Height,FromColumn,ToColumn,grid_raised,grid_normal):-
	grid_convert(GridWin,grid_column(FromColumn),grid_lr(L,_,_,_,_,_,_,_),b_true),
	grid_convert(GridWin,grid_column(ToColumn),grid_lr(_,R,_,_,_,_,_,_),b_true),
	win_SetPen(GridWin,pen(1,ps_Solid,color_Black)),
	Height1 = Height - 1,
	grid_draw_horz_line(GridWin,L,R,Height1,Height1,Height,0),
	grid_draw_vert_line(GridWin,FromColumn,ToColumn,0,Height,-1),
	win_SetPen(GridWin,pen(1,ps_Solid,color_White)),
	grid_draw_horz_line(GridWin,L,R,0,1,Height,0),
	grid_draw_vert_line(GridWin,FromColumn,ToColumn,0,Height,0),!.
  grid_draw_border_top(GridWin,Height,FromColumn,ToColumn,grid_raised,grid_pressed):-
	grid_convert(GridWin,grid_column(FromColumn),grid_lr(L,_,_,_,_,_,_,_),b_true),
	grid_convert(GridWin,grid_column(ToColumn),grid_lr(_,R,_,_,_,_,_,_),b_true),
	FromColumn1 = FromColumn + 1,
	win_SetPen(GridWin,pen(1,ps_Solid,color_White)),
	Height1 = Height - 1,
	grid_draw_horz_line(GridWin,L,R,Height1,Height1,Height,0),
	grid_draw_vert_line(GridWin,FromColumn1,ToColumn,0,Height,-1),
	win_SetPen(GridWin,pen(1,ps_Solid,color_Black)),
	ToColumn1 = ToColumn - 1,
	grid_draw_horz_line(GridWin,L,R,0,1,Height,0),
	grid_draw_vert_line(GridWin,FromColumn,ToColumn1,0,Height,0),!.
  grid_draw_border_top(GridWin,Height,FromColumn,ToColumn,grid_raisedplain,grid_normal):-
	grid_convert(GridWin,grid_column(FromColumn),grid_lr(L,_,_,_,_,_,_,_),b_true),
	grid_convert(GridWin,grid_column(ToColumn),grid_lr(_,R,_,_,_,_,_,_),b_true),
	win_SetPen(GridWin,pen(1,ps_Solid,color_Black)),
	Height1 = Height - 1,
	grid_draw_horz_line(GridWin,L,R,Height1,Height1,Height,0),
	grid_draw_vert_line(GridWin,FromColumn,ToColumn,0,Height,-1),
	win_SetPen(GridWin,pen(1,ps_Solid,color_White)),
	grid_draw_horz_line(GridWin,L,R,0,1,Height,0),
	grid_draw_vert_line(GridWin,FromColumn,ToColumn,0,Height,0),!.
  grid_draw_border_top(GridWin,Height,FromColumn,ToColumn,grid_raisedplain,grid_pressed):-
	grid_convert(GridWin,grid_column(FromColumn),grid_lr(L,_,_,_,_,_,_,_),b_true),
	grid_convert(GridWin,grid_column(ToColumn),grid_lr(_,R,_,_,_,_,_,_),b_true),
	FromColumn1 = FromColumn + 1,
	win_SetPen(GridWin,pen(1,ps_Solid,color_White)),
	Height1 = Height - 1,
	grid_draw_horz_line(GridWin,L,R,Height1,Height1,Height,0),
	grid_draw_vert_line(GridWin,FromColumn1,ToColumn,0,Height,-1),
	win_SetPen(GridWin,pen(1,ps_Solid,color_Black)),
	ToColumn1 = ToColumn - 1,
	grid_draw_horz_line(GridWin,L,R,0,1,Height,0),
	grid_draw_vert_line(GridWin,FromColumn,ToColumn1,0,Height,0),!.
  grid_draw_border_top(GridWin,Height,FromColumn,ToColumn,grid_plain,grid_normal):-
	grid_convert(GridWin,grid_column(FromColumn),grid_lr(L,_,_,_,_,_,_,_),b_true),
	grid_convert(GridWin,grid_column(ToColumn),grid_lr(_,R,_,_,_,_,_,_),b_true),
	win_SetPen(GridWin,pen(1,ps_Solid,color_Black)),
	grid_draw_horz_line(GridWin,L,R,0,Height,Height,0),
	grid_draw_vert_line(GridWin,FromColumn,ToColumn,0,Height,-1),!.
  grid_draw_border_top(GridWin,Height,FromColumn,ToColumn,grid_plain,grid_pressed):-
	grid_convert(GridWin,grid_column(FromColumn),grid_lr(L,_,_,_,_,_,_,_),b_true),
	grid_convert(GridWin,grid_column(ToColumn),grid_lr(_,R,_,_,_,_,_,_),b_true),
	win_SetPen(GridWin,pen(1,ps_Solid,color_White)),
	grid_draw_horz_line(GridWin,L,R,0,Height,Height,0),
	grid_draw_vert_line(GridWin,FromColumn,ToColumn,0,Height,-1),!.
  grid_draw_border_top(_,_,_,_,_,_).

predicates
determ  grid_draw_top_column_markers(WINDOW GridWin,GRID_CELLS_STYLE CellStyle,GRID_LINELIST ColumnList)
clauses
  grid_draw_top_column_markers(GridWin,_,_):-
	grid_view_info(GridWin,_,_,_,_,_,_,_,_,_,b_true),!.
  grid_draw_top_column_markers(_,_,[]):-!.
  grid_draw_top_column_markers(GridWin,CellStyle,[gl(FromColumn,ToColumn)|Rest]):-
	grid_row_info(GridWin,_,_,TopTitleHeight,_,_,_,_),
	grid_draw_border_top(GridWin,TopTitleHeight,FromColumn,ToColumn,CellStyle,grid_pressed),!,
	grid_draw_top_column_markers(GridWin,CellStyle,Rest).

predicates
procedure  grid_draw_top_markers(WINDOW GridWin)
clauses
  grid_draw_top_markers(GridWin):-
	grid_column(GridWin,ColumnList),
	grid_view_info(GridWin,CellStyle,_,_,_,_,_,_,_,_,_),
	grid_draw_top_column_markers(GridWin,CellStyle,ColumnList),!.
  grid_draw_top_markers(_).

  grid_draw_top_title_border(GridWin,FromColumn0,ToColumn0):-
	grid_column_info(GridWin,MaxColumn,_,_,_,_),
	FromColumn01 = grid_max(FromColumn0,1),
	FromColumn = grid_min(FromColumn01,MaxColumn),
	ToColumn01 = grid_max(ToColumn0,1),
	ToColumn = grid_min(ToColumn01,MaxColumn),
	grid_view_info(GridWin,CellStyle,_,_,_,_,_,_,_,_,_),
	grid_row_info(GridWin,_,_,TopTitleHeightX,_,_,_,_),
	grid_correcrt_title_Width(GridWin,TopTitleHeightX,TopTitleHeight),
	grid_draw_border_top(GridWin,TopTitleHeight,FromColumn,ToColumn,CellStyle,grid_normal),
	grid_draw_top_markers(GridWin),!.
  grid_draw_top_title_border(_,_,_):-!.

predicates
procedure grid_get_marker_color(WINDOW GridWin,COLOR MarkerColor1,COLOR MarkerColor2)
clauses
  grid_get_marker_color(GridWin,color_Black,color_LtGray):-
	grid_view_info(GridWin,_,_,_,_,color_White,_,_,_,_,_),!.
  grid_get_marker_color(_,color_White,color_Black).

predicates
procedure grid_adjust_row_column(WINDOW GridWin,INTEGER FromRowX,INTEGER ToRowX,INTEGER FromColumnX,INTEGER ToColumnX,
	INTEGER FromRow,INTEGER ToRow,INTEGER FromColumn,INTEGER ToColumn)
clauses
  grid_adjust_row_column(GridWin,FromRowX,ToRowX,FromColumnX,ToColumnX,FromRow,ToRow,FromColumn,ToColumn):-
	grid_row_info(GridWin,_,_,_,_,_,FirstRow,LastRow),
	grid_column_info(GridWin,_,_,FirstColumn,LastColumn,0),
	FromRow = grid_max(FromRowX,FirstRow),
	ToRow = grid_min(ToRowX,LastRow),
	FromColumn = grid_max(FromColumnX,FirstColumn),
	ToColumn = grid_min(ToColumnX,LastColumn),!.
  grid_adjust_row_column(GridWin,FromRowX,ToRowX,FromColumnX,ToColumnX,FromRow,ToRow,FromColumn,ToColumn):-
	grid_row_info(GridWin,_,_,_,_,_,FirstRow,LastRow),
	grid_column_info(GridWin,_,_,FirstColumn,_,NonScrollColumn),
	NonScrollColumn < ToColumnX, ToColumnX < FirstColumn,
	FromRow = grid_max(FromRowX,FirstRow),
	ToRow = grid_min(ToRowX,LastRow),
	FromColumn = grid_max(FromColumnX,1),
	ToColumn = NonScrollColumn,!.
  grid_adjust_row_column(GridWin,FromRowX,ToRowX,FromColumnX,ToColumnX,FromRow,ToRow,FromColumn,ToColumn):-
	grid_row_info(GridWin,_,_,_,_,_,FirstRow,LastRow),
	grid_column_info(GridWin,_,_,_,LastColumn,_),
	FromRow = grid_max(FromRowX,FirstRow),
	ToRow = grid_min(ToRowX,LastRow),
	FromColumn = grid_max(FromColumnX,1),
	ToColumn = grid_min(ToColumnX,LastColumn),!.
  grid_adjust_row_column(_,_,_,_,_,0,0,0,0).

predicates
procedure  grid_draw_border_area(WINDOW GridWin,INTEGER FromRow,INTEGER ToRow,INTEGER FromColumn,INTEGER ToColumn,
	GRID_CELLS_STYLE CellStyle,INTEGER Pressed)
clauses
  grid_draw_border_area(GridWin,FromRow,_,_,_,_,_):-
	grid_row_info(GridWin,_,_,_,_,_,_,LastRow),
	FromRow > LastRow,!.
  grid_draw_border_area(GridWin,_,ToRow,_,_,_,_):-
	grid_row_info(GridWin,_,_,_,_,_,FirstRow,_),
	ToRow < FirstRow,!.
  grid_draw_border_area(GridWin,_,_,FromColumn,_,_,_):-
	grid_column_info(GridWin,_,_,_,LastColumn,_),
	FromColumn > LastColumn,!.
  grid_draw_border_area(GridWin,_,_,_,ToColumn,_,_):-
	grid_column_info(GridWin,_,_,FirstColumn,_,0),
	ToColumn < FirstColumn,!.
  grid_draw_border_area(GridWin,_,_,FromColumn,ToColumn,_,_):-
	grid_column_info(GridWin,_,_,FirstColumn,_,NoScrollColumn),
	FromColumn > NoScrollColumn,
	ToColumn < FirstColumn,!.

  grid_draw_border_area(GridWin,FromRowX,ToRowX,FromColumnX,ToColumnX,grid_raised,grid_normal):-
	grid_adjust_row_column(GridWin,FromRowX,ToRowX,FromColumnX,ToColumnX,FromRow,ToRow,FromColumn,ToColumn),
	grid_convert(GridWin,grid_row(FromRow),grid_tb(Tx,_),b_true),
	grid_convert(GridWin,grid_row(ToRow),grid_tb(_,Bx),b_true),
	Txx = grid_min1(Tx,10000),
	T = grid_max1(Txx,-10000),
	Bxx = grid_min1(Bx,10000),
	B = grid_max1(Bxx,-10000),
	grid_convert(GridWin,grid_column(FromColumn),grid_lr(L,_,_,_,_,_,_,_),b_true),
	grid_convert(GridWin,grid_column(ToColumn),grid_lr(_,R,_,_,_,_,_,_),b_true),
	grid_row_info(GridWin,_,_,_,Step,_,_,_),
	grid_get_marker_color(GridWin,_,MarkerColor),
	win_SetPen(GridWin,pen(1,ps_Solid,MarkerColor)),
	T1 = T - 1,
	TI = grid_val(T),
	T1I = grid_val(T1),
	BI = grid_val(B),
	grid_draw_horz_line(GridWin,L,R,T1I,BI,Step,0),
	grid_draw_vert_line(GridWin,FromColumn,ToColumn,TI,BI,-1),
	win_SetPen(GridWin,pen(1,ps_Solid,color_White)),
	grid_draw_horz_line(GridWin,L,R,TI,BI,Step,0),
	grid_draw_vert_line(GridWin,FromColumn,ToColumn,TI,BI,0),!.
  grid_draw_border_area(GridWin,FromRowX,ToRowX,FromColumnX,ToColumnX,grid_raised,grid_pressed):-
	grid_adjust_row_column(GridWin,FromRowX,ToRowX,FromColumnX,ToColumnX,FromRow,ToRow,FromColumn,ToColumn),
	grid_convert(GridWin,grid_row(FromRow),grid_tb(Tx,_),b_true),
	grid_convert(GridWin,grid_row(ToRow),grid_tb(_,Bx),b_true),
	Txx = grid_min1(Tx,10000),
	T = grid_max1(Txx,-10000),
	Bxx = grid_min1(Bx,10000),
	B = grid_max1(Bxx,-10000),
	grid_convert(GridWin,grid_column(FromColumn),grid_lr(L,_,_,_,_,_,_,_),b_true),
	grid_convert(GridWin,grid_column(ToColumn),grid_lr(_,R,_,_,_,_,_,_),b_true),
	grid_row_info(GridWin,_,_,_,Step,_,_,_),
	FromRow1 = FromRow + 1,
	grid_convert(GridWin,grid_row(FromRow1),grid_tb(T1x,_),_),
	T1xx = grid_min1(T1x,10000),
	T1 = grid_max1(T1xx,-10000),
	T0 = T1 - 1,
	FromColumn1 = FromColumn + 1,
	ToColumn1 = ToColumn - 1,
	TI = grid_val(T),
	T0I = grid_val(T0),
	BI = grid_val(B),
	grid_get_marker_color(GridWin,MarkerColor1,MarkerColor2),
	win_SetPen(GridWin,pen(1,ps_Solid,MarkerColor1)),
	grid_draw_horz_line(GridWin,L,R,T0I,BI,Step,0),
	grid_draw_vert_line(GridWin,FromColumn1,ToColumn,TI,BI,-1),
	win_SetPen(GridWin,pen(1,ps_Solid,MarkerColor2)),
	ToRow1 = ToRow - 1,
	grid_convert(GridWin,grid_row(ToRow1),grid_tb(_,B1x),_),
	B1xx = grid_min1(B1x,10000),
	B1 = grid_max1(B1xx,-10000),
	B1I = grid_val(B1),
	grid_draw_horz_line(GridWin,L,R,TI,B1I,Step,0),
	grid_draw_vert_line(GridWin,FromColumn,ToColumn1,TI,BI,0),!.
  grid_draw_border_area(GridWin,FromRowX,ToRowX,FromColumnX,ToColumnX,_,grid_normal):-
	grid_adjust_row_column(GridWin,FromRowX,ToRowX,FromColumnX,ToColumnX,FromRow,ToRow,FromColumn,ToColumn),
	grid_convert(GridWin,grid_row(FromRow),grid_tb(Tx,_),b_true),
	grid_convert(GridWin,grid_row(ToRow),grid_tb(_,Bx),b_true),
	Txx = grid_min1(Tx,10000),
	T = grid_max1(Txx,-10000),
	Bxx = grid_min1(Bx,10000),
	B = grid_max1(Bxx,-10000),
	grid_convert(GridWin,grid_column(FromColumn),grid_lr(L,_,_,_,_,_,_,_),b_true),
	grid_convert(GridWin,grid_column(ToColumn),grid_lr(_,R,_,_,_,_,_,_),b_true),
	grid_row_info(GridWin,_,_,_,Step,_,_,_),
	grid_get_marker_color(GridWin,_,MarkerColor),
	win_SetPen(GridWin,pen(1,ps_Solid,MarkerColor)),
	T1 = T - 1,
	TI = grid_val(T),
	T1I = grid_val(T1),
	BI = grid_val(B),
	grid_draw_horz_line(GridWin,L,R,T1I,BI,Step,0),
	grid_draw_vert_line(GridWin,FromColumn,ToColumn,TI,BI,-1),!.
  grid_draw_border_area(GridWin,FromRowX,ToRowX,FromColumnX,ToColumnX,_,grid_pressed):-
	grid_adjust_row_column(GridWin,FromRowX,ToRowX,FromColumnX,ToColumnX,FromRow,ToRow,FromColumn,ToColumn),
	grid_convert(GridWin,grid_row(FromRow),grid_tb(Tx,_),b_true),
	grid_convert(GridWin,grid_row(ToRow),grid_tb(_,Bx),b_true),
	Txx = grid_min1(Tx,10000),
	T = grid_max1(Txx,-10000),
	Bxx = grid_min1(Bx,10000),
	B = grid_max1(Bxx,-10000),
	grid_convert(GridWin,grid_column(FromColumn),grid_lr(L,_,_,_,_,_,_,_),b_true),
	grid_convert(GridWin,grid_column(ToColumn),grid_lr(_,R,_,_,_,_,_,_),b_true),
	grid_row_info(GridWin,_,_,_,Step,_,_,_),
	grid_get_marker_color(GridWin,MarkerColor,_),
	win_SetPen(GridWin,pen(1,ps_Solid,MarkerColor)),
	T1 = T - 1,
	TI = grid_val(T),
	T1I = grid_val(T1),
	BI = grid_val(B),
	grid_draw_horz_line(GridWin,L,R,T1I,BI,Step,0),
	grid_draw_vert_line(GridWin,FromColumn,ToColumn,TI,BI,-1),!.
  grid_draw_border_area(_,_,_,_,_,_,_).

predicates
procedure  grid_draw_row_markers(WINDOW GridWin,INTEGER FromColumn,INTEGER ToColumn,GRID_CELLS_STYLE CellStyle,GRID_LINELIST RowList)
clauses
  grid_draw_row_markers(GridWin,_,_,_,_):-
	grid_view_info(GridWin,_,_,_,_,_,_,_,_,_,b_true),!.
  grid_draw_row_markers(_,_,_,_,[]):-!.
  grid_draw_row_markers(GridWin,FromColumn,ToColumn,CellStyle,[gl(FromRow,ToRow)|Rest]):-
	grid_draw_border_area(GridWin,FromRow,ToRow,FromColumn,ToColumn,CellStyle,grid_pressed),!,
	grid_draw_row_markers(GridWin,FromColumn,ToColumn,CellStyle,Rest).
  grid_draw_row_markers(_,_,_,_,_):-errorexit().

predicates
procedure  grid_draw_column_markers(WINDOW GridWin,INTEGER FromRow,INTEGER ToRow,GRID_CELLS_STYLE CellStyle,GRID_LINELIST ColumnList)
clauses
  grid_draw_column_markers(_,_,_,_,[]):-!.
  grid_draw_column_markers(GridWin,FromRow,ToRow,CellStyle,[gl(FromColumn,ToColumn)|Rest]):-
	grid_draw_border_area(GridWin,FromRow,ToRow,FromColumn,ToColumn,CellStyle,grid_pressed),!,
	grid_draw_column_markers(GridWin,FromRow,ToRow,CellStyle,Rest).
  grid_draw_column_markers(_,_,_,_,_):-errorexit.

predicates
procedure  grid_draw_area_markers(WINDOW GridWin,GRID_CELLS_STYLE CellStyle,GRID_AREALIST ColumnList)
clauses
  grid_draw_area_markers(_,_,[]):-!.
  grid_draw_area_markers(GridWin,CellStyle,[ga(FromRow,ToRow,FromColumn,ToColumn)|Rest]):-
	grid_draw_border_area(GridWin,FromRow,ToRow,FromColumn,ToColumn,CellStyle,grid_pressed),!,
	grid_draw_area_markers(GridWin,CellStyle,Rest).
  grid_draw_area_markers(_,_,_):-errorexit().

  grid_draw_markers(GridWin,_,_,FromColumn,ToColumn):-
	grid_row(GridWin,RowList),
	grid_view_info(GridWin,CellStyle,_,_,_,_,_,_,_,_,b_false),
	grid_draw_row_markers(GridWin,FromColumn,ToColumn,CellStyle,RowList),!.
  grid_draw_markers(GridWin,FromRow,ToRow,_,_):-
	grid_column(GridWin,ColumnList),
	grid_view_info(GridWin,CellStyle,_,_,_,_,_,_,_,_,b_false),
	grid_draw_column_markers(GridWin,FromRow,ToRow,CellStyle,ColumnList),!.
  grid_draw_markers(GridWin,_,_,_,_):-
	grid_area(GridWin,AreaList),
	grid_view_info(GridWin,CellStyle,_,_,_,_,_,_,_,_,b_false),
	grid_draw_area_markers(GridWin,CellStyle,AreaList),!.
  grid_draw_markers(_,_,_,_,_).

  grid_draw_border(GridWin,FromRow0,ToRow0,FromColumn0,ToColumn0):-
	grid_all(GridWin),
	grid_row_info(GridWin,MaxRow,_,_,_,_,_,_),
	grid_column_info(GridWin,MaxColumn,_,_,_,_),
	FromRow01 = grid_max(FromRow0,1),
	FromRow = grid_min(FromRow01,MaxRow),
	FromColumn01 = grid_max(FromColumn0,1),
	FromColumn = grid_min(FromColumn01,MaxColumn),
	ToRow01 = grid_max(ToRow0,1),
	ToRow = grid_min(ToRow01,MaxRow),
	ToColumn01 = grid_max(ToColumn0,1),
	ToColumn = grid_min(ToColumn01,MaxColumn),
	grid_view_info(GridWin,CellStyle,_,_,_,_,_,_,_,_,b_false),
	grid_draw_border_area(GridWin,FromRow,ToRow,FromColumn,ToColumn,CellStyle,grid_pressed),!.
  grid_draw_border(GridWin,FromRow0,ToRow0,FromColumn0,ToColumn0):-
	grid_row_info(GridWin,MaxRow,_,_,_,_,_,_),
	grid_column_info(GridWin,MaxColumn,_,_,_,_),
	FromRow01 = grid_max(FromRow0,1),
	FromRow = grid_min(FromRow01,MaxRow),
	FromColumn01 = grid_max(FromColumn0,1),
	FromColumn = grid_min(FromColumn01,MaxColumn),
	ToRow01 = grid_max(ToRow0,1),
	ToRow = grid_min(ToRow01,MaxRow),
	ToColumn01 = grid_max(ToColumn0,1),
	ToColumn = grid_min(ToColumn01,MaxColumn),
	grid_view_info(GridWin,CellStyle,_,_,_,_,_,_,_,_,_),
	grid_draw_border_area(GridWin,FromRow,ToRow,FromColumn,ToColumn,CellStyle,grid_normal),
	grid_draw_markers(GridWin,FromRow,ToRow,FromColumn,ToColumn),!.
  grid_draw_border(_,_,_,_,_):-!.

predicates
procedure grid_remove_cols(INTEGER Column,INTEGER FromColumn,INTEGER ToColumn,GRIDLIST,GRIDLIST)
clauses
  grid_remove_cols(_,_,_,[],[]):-!.
  grid_remove_cols(Column,_,ToColumn,_,[]):-
	Column > ToColumn,!.
  grid_remove_cols(Column,FromColumn,ToColumn,[_|Rest],OutList):-
	Column < FromColumn,
	NewColumn = Column + 1,!,
	grid_remove_cols(NewColumn,FromColumn,ToColumn,Rest,OutList).
  grid_remove_cols(Column,FromColumn,ToColumn,[Data|Rest],[Data|OutList]):-
	NewColumn = Column + 1,!,
	grid_remove_cols(NewColumn,FromColumn,ToColumn,Rest,OutList).
  grid_remove_cols(_,_,_,_,[]):-
	errorexit().

predicates
procedure grid_remove_data(INTEGER Row,INTEGER Column,INTEGER FromRow,INTEGER ToRow,INTEGER FromColumn,INTEGER ToColumn,GRIDLIST2D,GRIDLIST2D)
clauses
  grid_remove_data(_,_,_,_,_,_,[],[]):-!.
  grid_remove_data(Row,_,_,ToRow,_,_,_,[]):-
	Row > ToRow,!.
  grid_remove_data(Row,Column,FromRow,ToRow,FromColumn,ToColumn,[_|Rest],OutList):-
	Row < FromRow,
	NewRow = Row + 1,!,
	grid_remove_data(NewRow,Column,FromRow,ToRow,FromColumn,ToColumn,Rest,OutList).
  grid_remove_data(Row,Column,FromRow,ToRow,FromColumn,ToColumn,[RowData|Rest],[NewRowData|OutList]):-
	grid_remove_cols(Column,FromColumn,ToColumn,RowData,NewRowData),
	NewRow = Row + 1,!,
	grid_remove_data(NewRow,Column,FromRow,ToRow,FromColumn,ToColumn,Rest,OutList).
  grid_remove_data(_,_,_,_,_,_,_,[]):-
	errorexit().

