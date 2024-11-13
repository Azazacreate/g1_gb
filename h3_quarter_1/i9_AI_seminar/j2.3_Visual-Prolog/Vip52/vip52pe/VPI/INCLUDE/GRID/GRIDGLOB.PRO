/******************************************************************************

               Copyright (c) 1984 - 2000 Prolog Development Center A/S

 FileName:	GRIDGLOB.PRO
 Purpose:	GRID custom control clauses for global predicates
 Written by:	Sergey Alexeev
 Version:	2.0
 Build:		025.991028
 Tested with:   Visual Prolog v.5.1 build 563
 Comments:
******************************************************************************/

/*************************************************************************
			     ROW MARKER
 *************************************************************************/
predicates
procedure grid_delete(GRID_AREA,GRID_AREALIST,GRID_AREALIST)
procedure grid_delete(GRID_LINE,GRID_LINELIST,GRID_LINELIST)
clauses
  grid_delete(_,[],[]):-!.
  grid_delete(A,[A|R],O):-!,
	grid_delete(A,R,O).
  grid_delete(A,[B|R],[B|O]):-!,
	grid_delete(A,R,O).
  grid_delete(_,_,[]):-
	errorexit().

predicates
procedure  grid_add_row_marker(WINDOW GridWin,INTEGER Row,GRID_LINELIST RowList)
clauses
  grid_add_row_marker(GridWin,Row,RowList1):-
	grid_row(GridWin,RowList),
	grid_member(gl(Row,Row),RowList),
	grid_delete(gl(Row,Row),RowList,RowList1),
	grid_column_info(GridWin,MaxColumn,_,_,_,_),
	grid_view_info(GridWin,CellStyle,_,_,_,_,_,_,_,_,b_false),
	grid_draw_border_area(GridWin,Row,Row,1,MaxColumn,CellStyle,grid_normal),!.
  grid_add_row_marker(GridWin,Row,RowList1):-
	grid_row(GridWin,RowList),
	grid_member(gl(Row,Row),RowList),
	grid_delete(gl(Row,Row),RowList,RowList1),!.
  grid_add_row_marker(GridWin,Row,RowList3):-
	grid_row(GridWin,RowList),
	grid_reverse_list(RowList,[],RowList1),
	RowList2 = [gl(Row,Row)|RowList1],
	grid_reverse_list(RowList2,[],RowList3),!.
  grid_add_row_marker(_,Row,[gl(Row,Row)]):-!.

predicates
procedure  grid_remove_row_marker1(WINDOW GridWin,INTEGER MaxColumn,GRID_LINELIST RowList)
clauses
  grid_remove_row_marker1(_,_,[]):-!.
  grid_remove_row_marker1(GridWin,MaxColumn,[gl(FromRow,ToRow)|Rest]):-
	grid_draw_left_title_border(GridWin,FromRow,ToRow),
	grid_draw_border(GridWin,FromRow,ToRow,1,MaxColumn),!,
	grid_remove_row_marker1(GridWin,MaxColumn,Rest).
  grid_remove_row_marker1(_,_,_):-errorexit().

  grid_create_row_marker(GridWin):-
	grid_row(GridWin,RowList),
	grid_check_callback(GridWin,user_action(grid_marker(grid_row_marker(RowList),b_true))),
	grid_reset_activerow(GridWin),!.
  grid_create_row_marker(GridWin):-
	retract(grid_row(GridWin,RowList)),
	RowList = [gl(FromRow,ToRow)],
	grid_column_info(GridWin,MaxColumn,_,_,_,_),
	grid_correct(GridWin,grid_row(FromRow),grid_row(FromRow1)),
	grid_correct(GridWin,grid_row(ToRow),grid_row(ToRow1)),
	grid_correct(GridWin,grid_column(1),grid_column(FromColumn)),
	grid_correct(GridWin,grid_column(MaxColumn),grid_column(ToColumn)),
	grid_draw_left_title_border(GridWin,FromRow1,ToRow1),
	grid_draw_markers(GridWin,FromRow1,ToRow1,FromColumn,ToColumn),!.
  grid_create_row_marker(GridWin):-
	retract(grid_row(GridWin,RowList)),
	grid_reverse_list(RowList,[],RowList1),
	RowList1 = [gl(FromRow,ToRow)|Rest],
	grid_reverse_list(Rest,[],Rest1),
	assert(grid_row(GridWin,Rest1)),
	grid_column_info(GridWin,MaxColumn,_,_,_,_),
	grid_correct(GridWin,grid_row(FromRow),grid_row(FromRow1)),
	grid_correct(GridWin,grid_row(ToRow),grid_row(ToRow1)),
	grid_correct(GridWin,grid_column(1),grid_column(FromColumn)),
	grid_correct(GridWin,grid_column(MaxColumn),grid_column(ToColumn)),
	grid_draw_left_title_border(GridWin,FromRow1,ToRow1),
	grid_draw_markers(GridWin,FromRow1,ToRow1,FromColumn,ToColumn),!.
  grid_create_row_marker(_).

  grid_remove_row_marker(GridWin):-
	grid_row(GridWin,RowList),
	grid_check_callback(GridWin,user_action(grid_marker(grid_row_marker(RowList),b_false))),
	retract(grid_row(GridWin,_)),
	grid_column_info(GridWin,MaxColumn,_,_,_,_),
	grid_remove_row_marker1(GridWin,MaxColumn,RowList),!.

  grid_begin_row_marker(GridWin,Row):-
	grid_column_info(GridWin,MaxColumn,_,FirstColumn,_,_),
	grid_check_scroll(GridWin,Row,FirstColumn),
	grid_add_row_marker(GridWin,Row,RowList),
	retractall(grid_row(GridWin,_)),
	assert(grid_row(GridWin,RowList)),
	grid_correct(GridWin,grid_row(Row),grid_row(Row1)),
	grid_correct(GridWin,grid_column(1),grid_column(FromColumn)),
	grid_correct(GridWin,grid_column(MaxColumn),grid_column(ToColumn)),
	grid_draw_left_title_border(GridWin,Row1,Row1),
	grid_draw_markers(GridWin,Row1,Row1,FromColumn,ToColumn),!.

  grid_extend_row_marker(GridWin,Row0):-
	grid_row_info(GridWin,MaxRow,_,_,_,_,_,_),
	Row01 = grid_max(Row0,1),
	Row = grid_min(Row01,MaxRow),
	grid_row(GridWin,RowList),
	grid_reverse_list(RowList,[],RowList1),
	RowList1 = [gl(FromRow,ToRow0)|Rest],
	Row > ToRow0,
	grid_column_info(GridWin,MaxColumn,_,FirstColumn,_,_),
	grid_check_scroll(GridWin,Row,FirstColumn),
	retract(grid_row(GridWin,_)),
	RowList2 = [gl(FromRow,Row)|Rest],
	grid_reverse_list(RowList2,[],RowList3),
	assert(grid_row(GridWin,RowList3)),
	ToRow = ToRow0 + 1,
	grid_correct(GridWin,grid_row(ToRow),grid_row(ToRow1)),
	grid_correct(GridWin,grid_row(Row),grid_row(Row1)),
	grid_correct(GridWin,grid_column(1),grid_column(FromColumn)),
	grid_correct(GridWin,grid_column(MaxColumn),grid_column(ToColumn)),
	grid_draw_left_title_border(GridWin,ToRow1,Row1),
	grid_draw_markers(GridWin,ToRow1,Row1,FromColumn,ToColumn),!.
  grid_extend_row_marker(GridWin,Row0):-
	grid_row_info(GridWin,MaxRow,_,_,_,_,_,_),
	Row01 = grid_max(Row0,1),
	Row = grid_min(Row01,MaxRow),
	grid_row(GridWin,RowList),
	grid_reverse_list(RowList,[],RowList1),
	RowList1 = [gl(FromRow,ToRow)|Rest],
	FromRow <= Row, Row < ToRow,
	grid_column_info(GridWin,MaxColumn,_,FirstColumn,_,_),
	grid_check_scroll(GridWin,Row,FirstColumn),
	retract(grid_row(GridWin,_)),
	RowList2 = [gl(FromRow,Row)|Rest],
	grid_reverse_list(RowList2,[],RowList3),
	assert(grid_row(GridWin,RowList3)),
	Row2 = Row + 1,
	grid_correct(GridWin,grid_row(Row2),grid_row(Row1)),
	grid_correct(GridWin,grid_row(ToRow),grid_row(ToRow1)),
	grid_correct(GridWin,grid_column(1),grid_column(FromColumn)),
	grid_correct(GridWin,grid_column(MaxColumn),grid_column(ToColumn)),
	grid_draw_left_title_border(GridWin,Row1,ToRow1),
	grid_draw_border(GridWin,Row1,ToRow1,FromColumn,ToColumn),!.
  grid_extend_row_marker(_,_).

predicates
determ  grid_create_row_markers(WINDOW GridWin,GRID_LINELIST RowList)
clauses
  grid_create_row_markers(_,[]):-!.
  grid_create_row_markers(GridWin,[gl(FromRow,ToRow)|Rest]):-
	grid_begin_row_marker(GridWin,FromRow),
	grid_extend_row_marker(GridWin,ToRow),
	grid_create_row_marker(GridWin),!,
	grid_create_row_markers(GridWin,Rest).

/*************************************************************************
			     COLUMN MARKER
 *************************************************************************/
predicates
procedure  grid_add_column_marker(WINDOW GridWin,INTEGER Column,GRID_LINELIST ColumnList)
clauses
  grid_add_column_marker(GridWin,Column,ColumnList1):-
	grid_column(GridWin,ColumnList),
	grid_member(gl(Column,Column),ColumnList),
	grid_delete(gl(Column,Column),ColumnList,ColumnList1),
	grid_row_info(GridWin,MaxRow,_,_,_,_,_,_),
	grid_view_info(GridWin,CellStyle,_,_,_,_,_,_,_,_,b_false),
	grid_draw_border_area(GridWin,1,MaxRow,Column,Column,CellStyle,grid_normal),!.
  grid_add_column_marker(GridWin,Column,ColumnList1):-
	grid_column(GridWin,ColumnList),
	grid_member(gl(Column,Column),ColumnList),
	grid_delete(gl(Column,Column),ColumnList,ColumnList1),!.
  grid_add_column_marker(GridWin,Column,ColumnList3):-
	grid_column(GridWin,ColumnList),
	grid_reverse_list(ColumnList,[],ColumnList1),
	ColumnList2 = [gl(Column,Column)|ColumnList1],
	grid_reverse_list(ColumnList2,[],ColumnList3),!.
  grid_add_column_marker(_,Column,[gl(Column,Column)]):-!.

predicates
procedure  grid_remove_column_marker1(WINDOW GridWin,INTEGER FromRow,INTEGER ToRow,GRID_LINELIST ColumnList)
clauses
  grid_remove_column_marker1(_,_,_,[]):-!.
  grid_remove_column_marker1(GridWin,FromRow,ToRow,[gl(FromColumn,ToColumn)|Rest]):-
	grid_draw_top_title_border(GridWin,FromColumn,ToColumn),
	grid_draw_border(GridWin,FromRow,ToRow,FromColumn,ToColumn),!,
	grid_remove_column_marker1(GridWin,FromRow,ToRow,Rest).
  grid_remove_column_marker1(_,_,_,_):-errorexit().

  grid_create_column_marker(GridWin):-
	grid_column(GridWin,ColumnList),
	grid_check_callback(GridWin,user_action(grid_marker(grid_col_marker(ColumnList),b_true))),!.
  grid_create_column_marker(GridWin):-
	retract(grid_column(GridWin,ColumnList)),
	ColumnList = [gl(FromColumn,ToColumn)],
	grid_row_info(GridWin,MaxRow,_,_,_,_,_,_),
	grid_correct(GridWin,grid_column(FromColumn),grid_column(FromColumn1)),
	grid_correct(GridWin,grid_column(ToColumn),grid_column(ToColumn1)),
	grid_correct(GridWin,grid_row(1),grid_row(FromRow)),
	grid_correct(GridWin,grid_row(MaxRow),grid_row(ToRow)),
	grid_draw_top_title_border(GridWin,FromColumn1,ToColumn1),
	grid_draw_markers(GridWin,FromRow,ToRow,FromColumn1,ToColumn1),!.
  grid_create_column_marker(GridWin):-
	retract(grid_column(GridWin,ColumnList)),
	grid_reverse_list(ColumnList,[],ColumnList1),
	ColumnList1 = [gl(FromColumn,ToColumn)|Rest],
	grid_reverse_list(Rest,[],Rest1),
	assert(grid_column(GridWin,Rest1)),
	grid_row_info(GridWin,MaxRow,_,_,_,_,_,_),
	grid_correct(GridWin,grid_column(FromColumn),grid_column(FromColumn1)),
	grid_correct(GridWin,grid_column(ToColumn),grid_column(ToColumn1)),
	grid_correct(GridWin,grid_row(1),grid_row(FromRow)),
	grid_correct(GridWin,grid_row(MaxRow),grid_row(ToRow)),
	grid_draw_top_title_border(GridWin,FromColumn1,ToColumn1),
	grid_draw_markers(GridWin,FromRow,ToRow,FromColumn1,ToColumn1),!.
  grid_create_column_marker(_).

  grid_remove_column_marker(GridWin):-
	grid_column(GridWin,ColumnList),
	grid_check_callback(GridWin,user_action(grid_marker(grid_col_marker(ColumnList),b_false))),
	retract(grid_column(GridWin,_)),
	grid_row_info(GridWin,MaxRow,_,_,_,_,_,_),
	grid_correct(GridWin,grid_row(1),grid_row(FromRow)),
	grid_correct(GridWin,grid_row(MaxRow),grid_row(ToRow)),
	grid_remove_column_marker1(GridWin,FromRow,ToRow,ColumnList),!.

  grid_begin_column_marker(GridWin,Column):-
	grid_row_info(GridWin,MaxRow,_,_,_,_,FirstRow,_),
	grid_check_scroll(GridWin,FirstRow,Column),
	grid_add_column_marker(GridWin,Column,ColumnList),
	retractall(grid_column(GridWin,_)),
	assert(grid_column(GridWin,ColumnList)),
	grid_correct(GridWin,grid_column(Column),grid_column(Column1)),
	grid_correct(GridWin,grid_row(1),grid_row(FromRow)),
	grid_correct(GridWin,grid_row(MaxRow),grid_row(ToRow)),
	grid_draw_top_title_border(GridWin,Column1,Column1),
	grid_draw_markers(GridWin,FromRow,ToRow,Column1,Column1),!.

  grid_extend_column_marker(GridWin,Column0):-
	grid_column_info(GridWin,MaxColumn,_,_,_,_),
	Column01 = grid_max(Column0,1),
	Column = grid_min(Column01,MaxColumn),
	grid_column(GridWin,ColumnList),
	grid_reverse_list(ColumnList,[],ColumnList1),
	ColumnList1 = [gl(FromColumn,ToColumn0)|Rest],
	Column > ToColumn0,
	grid_row_info(GridWin,MaxRow,_,_,_,_,FirstRow,_),
	grid_check_scroll(GridWin,FirstRow,Column),
	retract(grid_column(GridWin,_)),
	ColumnList2 = [gl(FromColumn,Column)|Rest],
	grid_reverse_list(ColumnList2,[],ColumnList3),
	assert(grid_column(GridWin,ColumnList3)),
	ToColumn = ToColumn0 + 1,
	grid_correct(GridWin,grid_column(ToColumn),grid_column(ToColumn1)),
	grid_correct(GridWin,grid_column(Column),grid_column(Column1)),
	grid_correct(GridWin,grid_row(1),grid_row(FromRow)),
	grid_correct(GridWin,grid_row(MaxRow),grid_row(ToRow)),
	grid_draw_top_title_border(GridWin,ToColumn1,Column1),
	grid_draw_markers(GridWin,FromRow,ToRow,ToColumn1,Column1),!.
  grid_extend_column_marker(GridWin,Column0):-
	grid_column_info(GridWin,MaxColumn,_,_,_,_),
	Column01 = grid_max(Column0,1),
	Column = grid_min(Column01,MaxColumn),
	grid_column(GridWin,ColumnList),
	grid_reverse_list(ColumnList,[],ColumnList1),
	ColumnList1 = [gl(FromColumn,ToColumn)|Rest],
	FromColumn <= Column, Column < ToColumn,
	grid_row_info(GridWin,MaxRow,_,_,_,_,FirstRow,_),
	grid_check_scroll(GridWin,FirstRow,Column),
	retract(grid_column(GridWin,_)),
	ColumnList2 = [gl(FromColumn,Column)|Rest],
	grid_reverse_list(ColumnList2,[],ColumnList3),
	assert(grid_column(GridWin,ColumnList3)),
	Column2 = Column + 1,
	grid_correct(GridWin,grid_column(Column2),grid_column(Column1)),
	grid_correct(GridWin,grid_column(ToColumn),grid_column(ToColumn1)),
	grid_correct(GridWin,grid_row(1),grid_row(FromRow)),
	grid_correct(GridWin,grid_row(MaxRow),grid_row(ToRow)),
	grid_draw_top_title_border(GridWin,Column1,ToColumn1),
	grid_draw_border(GridWin,FromRow,ToRow,Column1,ToColumn1),!.
  grid_extend_column_marker(_,_).

predicates
determ  grid_create_column_markers(WINDOW GridWin,GRID_LINELIST ColumnList)
clauses
  grid_create_column_markers(_,[]):-!.
  grid_create_column_markers(GridWin,[gl(FromColumn,ToColumn)|Rest]):-
	grid_begin_column_marker(GridWin,FromColumn),
	grid_extend_column_marker(GridWin,ToColumn),
	grid_create_column_marker(GridWin),!,
	grid_create_column_markers(GridWin,Rest).

/*************************************************************************
			     AREA MARKER
 *************************************************************************/
predicates
procedure  grid_add_area_marker(WINDOW GridWin,INTEGER Row,INTEGER Column,GRID_AREALIST)
clauses
  grid_add_area_marker(GridWin,Row,Column,GridAreaList1):-
	grid_area(GridWin,GridAreaList),
	grid_member(ga(Row,Row,Column,Column),GridAreaList),
	grid_delete(ga(Row,Row,Column,Column),GridAreaList,GridAreaList1),
	grid_view_info(GridWin,CellStyle,_,_,_,_,_,_,_,_,b_false),
	grid_draw_border_area(GridWin,Row,Row,Column,Column,CellStyle,grid_normal),!.
  grid_add_area_marker(GridWin,Row,Column,GridAreaList1):-
	grid_area(GridWin,GridAreaList),
	grid_member(ga(Row,Row,Column,Column),GridAreaList),
	grid_delete(ga(Row,Row,Column,Column),GridAreaList,GridAreaList1),!.
  grid_add_area_marker(GridWin,Row,Column,GridAreaList3):-
	grid_area(GridWin,GridAreaList),
	grid_reverse_list(GridAreaList,[],GridAreaList1),
	GridAreaList2 = [ga(Row,Row,Column,Column)|GridAreaList1],
	grid_reverse_list(GridAreaList2,[],GridAreaList3),!.
  grid_add_area_marker(_,Row,Column,[ga(Row,Row,Column,Column)]):-!.

predicates
procedure  grid_remove_area_marker1(WINDOW GridWin,GRID_AREALIST)
clauses
  grid_remove_area_marker1(_,[]):-!.
  grid_remove_area_marker1(GridWin,[ga(FromRow,ToRow,FromColumn,ToColumn)|Rest]):-
	grid_draw_border(GridWin,FromRow,ToRow,FromColumn,ToColumn),!,
	grid_remove_area_marker1(GridWin,Rest).
  grid_remove_area_marker1(_,_):-errorexit().

  grid_create_area_marker(GridWin):-
	grid_area(GridWin,AreaList),
	grid_check_callback(GridWin,user_action(grid_marker(grid_area_marker(AreaList),b_true))),
	grid_reset_activerow(GridWin),!.
  grid_create_area_marker(GridWin):-
	retract(grid_area(GridWin,AreaList)),
	AreaList = [ga(FromRow,ToRow,FromColumn,ToColumn)],
	grid_correct(GridWin,grid_row(FromRow),grid_row(FromRow1)),
	grid_correct(GridWin,grid_row(ToRow),grid_row(ToRow1)),
	grid_correct(GridWin,grid_column(FromColumn),grid_column(FromColumn1)),
	grid_correct(GridWin,grid_column(ToColumn),grid_column(ToColumn1)),
	grid_draw_markers(GridWin,FromRow1,ToRow1,FromColumn1,ToColumn1),!.
  grid_create_area_marker(GridWin):-
	retract(grid_area(GridWin,AreaList)),
	grid_reverse_list(AreaList,[],AreaList1),
	AreaList1 = [ga(FromRow,ToRow,FromColumn,ToColumn)|Rest],
	grid_reverse_list(Rest,[],Rest1),
	assert(grid_area(GridWin,Rest1)),
	grid_correct(GridWin,grid_row(FromRow),grid_row(FromRow1)),
	grid_correct(GridWin,grid_row(ToRow),grid_row(ToRow1)),
	grid_correct(GridWin,grid_column(FromColumn),grid_column(FromColumn1)),
	grid_correct(GridWin,grid_column(ToColumn),grid_column(ToColumn1)),
	grid_draw_markers(GridWin,FromRow1,ToRow1,FromColumn1,ToColumn1),!.
  grid_create_area_marker(_).

  grid_remove_area_marker(GridWin):-
	grid_area(GridWin,AreaList),
	grid_check_callback(GridWin,user_action(grid_marker(grid_area_marker(AreaList),b_false))),
	retract(grid_area(GridWin,_)),
	grid_remove_area_marker1(GridWin,AreaList),!.

  grid_begin_area_marker(GridWin,Row,Column):-
	grid_check_scroll(GridWin,Row,Column),
	grid_add_area_marker(GridWin,Row,Column,AreaList),
	retractall(grid_area(GridWin,_)),
	assert(grid_area(GridWin,AreaList)),
	grid_correct(GridWin,grid_row(Row),grid_row(Row1)),
	grid_correct(GridWin,grid_column(Column),grid_column(Column1)),
	grid_draw_markers(GridWin,Row1,Row1,Column1,Column1),!.

predicates
determ  grid_extend_area_marker_row(WINDOW GridWin,INTEGER Row)
determ  grid_extend_area_marker_column(WINDOW GridWin,INTEGER Column)
clauses
  grid_extend_area_marker(GridWin,Row0,Column0):-
	grid_row_info(GridWin,MaxRow,_,_,_,_,_,_),
	Row01 = grid_max(Row0,1),
	Row = grid_min(Row01,MaxRow),
	grid_column_info(GridWin,MaxColumn,_,_,_,_),
	Column01 = grid_max(Column0,1),
	Column = grid_min(Column01,MaxColumn),
	grid_check_scroll(GridWin,Row,Column),
	grid_extend_area_marker_row(GridWin,Row),
	grid_extend_area_marker_column(GridWin,Column),!.

  grid_extend_area_marker_row(GridWin,Row):-
	grid_area(GridWin,AreaList),
	grid_reverse_list(AreaList,[],AreaList1),
	AreaList1 = [ga(FromRow,ToRow0,FromColumn,ToColumn)|Rest],
	Row > ToRow0,
	grid_check_scroll(GridWin,Row,ToColumn),
	retract(grid_area(GridWin,_)),
	AreaList2 = [ga(FromRow,Row,FromColumn,ToColumn)|Rest],
	grid_reverse_list(AreaList2,[],AreaList3),
	assert(grid_area(GridWin,AreaList3)),
	ToRow = ToRow0 + 1,
	grid_correct(GridWin,grid_row(ToRow),grid_row(ToRow1)),
	grid_correct(GridWin,grid_row(Row),grid_row(Row1)),
	grid_correct(GridWin,grid_column(FromColumn),grid_column(FromColumn1)),
	grid_correct(GridWin,grid_column(ToColumn),grid_column(ToColumn1)),
	grid_draw_markers(GridWin,ToRow1,Row1,FromColumn1,ToColumn1),!.
  grid_extend_area_marker_row(GridWin,Row):-
	grid_area(GridWin,AreaList),
	grid_reverse_list(AreaList,[],AreaList1),
	AreaList1 = [ga(FromRow,ToRow,FromColumn,ToColumn)|Rest],
	FromRow <= Row, Row < ToRow,
	grid_check_scroll(GridWin,Row,ToColumn),
	retract(grid_area(GridWin,_)),
	AreaList2 = [ga(FromRow,Row,FromColumn,ToColumn)|Rest],
	grid_reverse_list(AreaList2,[],AreaList3),
	assert(grid_area(GridWin,AreaList3)),
	Row2 = Row + 1,
	grid_correct(GridWin,grid_row(Row2),grid_row(Row1)),
	grid_correct(GridWin,grid_row(ToRow),grid_row(ToRow1)),
	grid_correct(GridWin,grid_column(FromColumn),grid_column(FromColumn1)),
	grid_correct(GridWin,grid_column(ToColumn),grid_column(ToColumn1)),
	grid_draw_border(GridWin,Row1,ToRow1,FromColumn1,ToColumn1),!.
  grid_extend_area_marker_row(_,_).

  grid_extend_area_marker_column(GridWin,Column):-
	grid_area(GridWin,AreaList),
	grid_reverse_list(AreaList,[],AreaList1),
	AreaList1 = [ga(FromRow,ToRow,FromColumn,ToColumn0)|Rest],
	Column > ToColumn0,
	grid_check_scroll(GridWin,ToRow,Column),
	retract(grid_area(GridWin,_)),
	AreaList2 = [ga(FromRow,ToRow,FromColumn,Column)|Rest],
	grid_reverse_list(AreaList2,[],AreaList3),
	assert(grid_area(GridWin,AreaList3)),
	ToColumn = ToColumn0 + 1,
	grid_correct(GridWin,grid_column(ToColumn),grid_column(ToColumn1)),
	grid_correct(GridWin,grid_column(Column),grid_column(Column1)),
	grid_correct(GridWin,grid_row(FromRow),grid_row(FromRow1)),
	grid_correct(GridWin,grid_row(ToRow),grid_row(ToRow1)),
	grid_draw_markers(GridWin,FromRow1,ToRow1,ToColumn1,Column1),!.
  grid_extend_area_marker_column(GridWin,Column):-
	grid_area(GridWin,AreaList),
	grid_reverse_list(AreaList,[],AreaList1),
	AreaList1 = [ga(FromRow,ToRow,FromColumn,ToColumn)|Rest],
	FromColumn <= Column, Column < ToColumn,
	grid_check_scroll(GridWin,ToRow,Column),
	retract(grid_area(GridWin,_)),
	AreaList2 = [ga(FromRow,ToRow,FromColumn,Column)|Rest],
	grid_reverse_list(AreaList2,[],AreaList3),
	assert(grid_area(GridWin,AreaList3)),
	Column2 = Column + 1,
	grid_correct(GridWin,grid_column(Column2),grid_column(Column1)),
	grid_correct(GridWin,grid_column(ToColumn),grid_column(ToColumn1)),
	grid_correct(GridWin,grid_row(FromRow),grid_row(FromRow1)),
	grid_correct(GridWin,grid_row(ToRow),grid_row(ToRow1)),
	grid_draw_border(GridWin,FromRow1,ToRow1,Column1,ToColumn1),!.
  grid_extend_area_marker_column(_,_).

predicates
determ  grid_create_area_markers(WINDOW GridWin,GRID_AREALIST AreaList)
clauses
  grid_create_area_markers(_,[]):-!.
  grid_create_area_markers(GridWin,[ga(FromRow,ToRow,FromColumn,ToColumn)|Rest]):-
	grid_begin_area_marker(GridWin,FromRow,FromColumn),
	grid_extend_area_marker(GridWin,ToRow,ToColumn),
	grid_create_area_marker(GridWin),!,
	grid_create_area_markers(GridWin,Rest).

  grid_move_marker(grid_move_one_down,MaxRow,_,grid_row_marker([gl(FromRow,ToRow)]),grid_row_marker([gl(FromRow1,ToRow1)])):-
	ToRow01 = ToRow + 1,
	ToRow1 = grid_min(ToRow01,MaxRow),
	FromRow1 = ToRow1 - (ToRow - FromRow),!.
  grid_move_marker(grid_move_one_down,MaxRow,_,grid_area_marker([ga(FromRow,ToRow,FromColumn,ToColumn)]),grid_area_marker([ga(FromRow1,ToRow1,FromColumn,ToColumn)])):-
	ToRow01 = ToRow + 1,
	ToRow1 = grid_min(ToRow01,MaxRow),
	FromRow1 = ToRow1 - (ToRow - FromRow),!.

  grid_move_marker(grid_move_one_up,_,_,grid_row_marker([gl(FromRow,ToRow)]),grid_row_marker([gl(FromRow1,ToRow1)])):-
	FromRow01 = FromRow - 1,
	FromRow1 = grid_max(FromRow01,1),
	ToRow1 = FromRow1 + (ToRow - FromRow),!.
  grid_move_marker(grid_move_one_up,_,_,grid_area_marker([ga(FromRow,ToRow,FromColumn,ToColumn)]),grid_area_marker([ga(FromRow1,ToRow1,FromColumn,ToColumn)])):-
	FromRow01 = FromRow - 1,
	FromRow1 = grid_max(FromRow01,1),
	ToRow1 = FromRow1 + (ToRow - FromRow),!.

  grid_move_marker(grid_move_page_down,MaxRow,RowRange,grid_row_marker([gl(FromRow,ToRow)]),grid_row_marker([gl(FromRow1,ToRow1)])):-
	ToRow01 = ToRow + RowRange,
	ToRow1 = grid_min(ToRow01,MaxRow),
	FromRow1 = ToRow1 - (ToRow - FromRow),!.
  grid_move_marker(grid_move_page_down,MaxRow,RowRange,grid_area_marker([ga(FromRow,ToRow,FromColumn,ToColumn)]),grid_area_marker([ga(FromRow1,ToRow1,FromColumn,ToColumn)])):-
	ToRow01 = ToRow + RowRange,
	ToRow1 = grid_min(ToRow01,MaxRow),
	FromRow1 = ToRow1 - (ToRow - FromRow),!.

  grid_move_marker(grid_move_page_up,_,RowRange,grid_row_marker([gl(FromRow,ToRow)]),grid_row_marker([gl(FromRow1,ToRow1)])):-
	FromRow01 = FromRow - RowRange,
	FromRow1 = grid_max(FromRow01,1),
	ToRow1 = FromRow1 + (ToRow - FromRow),!.
  grid_move_marker(grid_move_page_up,_,RowRange,grid_area_marker([ga(FromRow,ToRow,FromColumn,ToColumn)]),grid_area_marker([ga(FromRow1,ToRow1,FromColumn,ToColumn)])):-
	FromRow01 = FromRow - RowRange,
	FromRow1 = grid_max(FromRow01,1),
	ToRow1 = FromRow1 + (ToRow - FromRow),!.

  grid_move_marker(grid_move_down,MaxRow,_,grid_row_marker([gl(FromRow,ToRow)]),grid_row_marker([gl(FromRow1,ToRow1)])):-
	ToRow1 = MaxRow,
	FromRow1 = ToRow1 - (ToRow - FromRow),!.
  grid_move_marker(grid_move_down,MaxRow,_,grid_area_marker([ga(FromRow,ToRow,FromColumn,ToColumn)]),grid_area_marker([ga(FromRow1,ToRow1,FromColumn,ToColumn)])):-
	ToRow1 = MaxRow,
	FromRow1 = ToRow1 - (ToRow - FromRow),!.

  grid_move_marker(grid_move_up,_,_,grid_row_marker([gl(FromRow,ToRow)]),grid_row_marker([gl(FromRow1,ToRow1)])):-
	FromRow1 = 1,
	ToRow1 = FromRow1 + (ToRow - FromRow),!.
  grid_move_marker(grid_move_up,_,_,grid_area_marker([ga(FromRow,ToRow,FromColumn,ToColumn)]),grid_area_marker([ga(FromRow1,ToRow1,FromColumn,ToColumn)])):-
	FromRow1 = 1,
	ToRow1 = FromRow1 + (ToRow - FromRow),!.

  grid_move_marker(grid_size_one_down,MaxRow,_,grid_row_marker([gl(FromRow,ToRow)]),grid_row_marker([gl(FromRow1,ToRow1)])):-
	ToRow01 = ToRow + 1,
	ToRow1 = grid_min(ToRow01,MaxRow),
	FromRow1 = FromRow,!.
  grid_move_marker(grid_size_one_down,MaxRow,_,grid_area_marker([ga(FromRow,ToRow,FromColumn,ToColumn)]),grid_area_marker([ga(FromRow1,ToRow1,FromColumn,ToColumn)])):-
	ToRow01 = ToRow + 1,
	ToRow1 = grid_min(ToRow01,MaxRow),
	FromRow1 = FromRow,!.

  grid_move_marker(grid_size_one_up,_,_,grid_row_marker([gl(FromRow,ToRow)]),grid_row_marker([gl(FromRow1,ToRow1)])):-
	ToRow01 = ToRow - 1,
	ToRow1 = grid_max(FromRow,ToRow01),
	FromRow1 = FromRow,!.
  grid_move_marker(grid_size_one_up,_,_,grid_area_marker([ga(FromRow,ToRow,FromColumn,ToColumn)]),grid_area_marker([ga(FromRow1,ToRow1,FromColumn,ToColumn)])):-
	ToRow01 = ToRow - 1,
	ToRow1 = grid_max(FromRow,ToRow01),
	FromRow1 = FromRow,!.

  grid_move_marker(grid_size_page_down,MaxRow,RowRange,grid_row_marker([gl(FromRow,ToRow)]),grid_row_marker([gl(FromRow1,ToRow1)])):-
	ToRow01 = ToRow + RowRange,
	ToRow1 = grid_min(ToRow01,MaxRow),
	FromRow1 = FromRow,!.
  grid_move_marker(grid_size_page_down,MaxRow,RowRange,grid_area_marker([ga(FromRow,ToRow,FromColumn,ToColumn)]),grid_area_marker([ga(FromRow1,ToRow1,FromColumn,ToColumn)])):-
	ToRow01 = ToRow + RowRange,
	ToRow1 = grid_min(ToRow01,MaxRow),
	FromRow1 = FromRow,!.

  grid_move_marker(grid_size_page_up,_,RowRange,grid_row_marker([gl(FromRow,ToRow)]),grid_row_marker([gl(FromRow1,ToRow1)])):-
	ToRow01 = ToRow - RowRange,
	ToRow1 = grid_max(FromRow,ToRow01),
	FromRow1 = FromRow,!.
  grid_move_marker(grid_size_page_up,_,RowRange,grid_area_marker([ga(FromRow,ToRow,FromColumn,ToColumn)]),grid_area_marker([ga(FromRow1,ToRow1,FromColumn,ToColumn)])):-
	ToRow01 = ToRow - RowRange,
	ToRow1 = grid_max(FromRow,ToRow01),
	FromRow1 = FromRow,!.

  grid_move_marker(grid_size_down,MaxRow,_,grid_row_marker([gl(FromRow,_)]),grid_row_marker([gl(FromRow1,ToRow1)])):-
	ToRow1 = MaxRow,
	FromRow1 = FromRow,!.
  grid_move_marker(grid_size_down,MaxRow,_,grid_area_marker([ga(FromRow,_,FromColumn,ToColumn)]),grid_area_marker([ga(FromRow1,ToRow1,FromColumn,ToColumn)])):-
	ToRow1 = MaxRow,
	FromRow1 = FromRow,!.

  grid_move_marker(grid_size_up,_,_,grid_row_marker([gl(FromRow,_)]),grid_row_marker([gl(FromRow1,ToRow1)])):-
	ToRow1 = FromRow,
	FromRow1 = FromRow,!.
  grid_move_marker(grid_size_up,_,_,grid_area_marker([ga(FromRow,_,FromColumn,ToColumn)]),grid_area_marker([ga(FromRow1,ToRow1,FromColumn,ToColumn)])):-
	ToRow1 = FromRow,
	FromRow1 = FromRow,!.

  grid_move_marker(grid_move_one_right,MaxColumn,_,grid_col_marker([gl(FromColumn,ToColumn)]),grid_col_marker([gl(FromColumn1,ToColumn1)])):-
	ToColumn01 = ToColumn + 1,
	ToColumn1 = grid_min(ToColumn01,MaxColumn),
	FromColumn1 = ToColumn1 - (ToColumn - FromColumn),!.
  grid_move_marker(grid_move_one_right,MaxColumn,_,grid_area_marker([ga(FromRow,ToRow,FromColumn,ToColumn)]),grid_area_marker([ga(FromRow,ToRow,FromColumn1,ToColumn1)])):-
	ToColumn01 = ToColumn + 1,
	ToColumn1 = grid_min(ToColumn01,MaxColumn),
	FromColumn1 = ToColumn1 - (ToColumn - FromColumn),!.

  grid_move_marker(grid_move_one_left,_,_,grid_col_marker([gl(FromColumn,ToColumn)]),grid_col_marker([gl(FromColumn1,ToColumn1)])):-
	FromColumn01 = FromColumn - 1,
	FromColumn1 = grid_max(FromColumn01,1),
	ToColumn1 = FromColumn1 + (ToColumn - FromColumn),!.
  grid_move_marker(grid_move_one_left,_,_,grid_area_marker([ga(FromRow,ToRow,FromColumn,ToColumn)]),grid_area_marker([ga(FromRow,ToRow,FromColumn1,ToColumn1)])):-
	FromColumn01 = FromColumn - 1,
	FromColumn1 = grid_max(FromColumn01,1),
	ToColumn1 = FromColumn1 + (ToColumn - FromColumn),!.

  grid_move_marker(grid_move_right,MaxColumn,_,grid_col_marker([gl(FromColumn,ToColumn)]),grid_col_marker([gl(FromColumn1,ToColumn1)])):-
	ToColumn1 = MaxColumn,
	FromColumn1 = ToColumn1 - (ToColumn - FromColumn),!.
  grid_move_marker(grid_move_right,MaxColumn,_,grid_area_marker([ga(FromRow,ToRow,FromColumn,ToColumn)]),grid_area_marker([ga(FromRow,ToRow,FromColumn1,ToColumn1)])):-
	ToColumn1 = MaxColumn,
	FromColumn1 = ToColumn1 - (ToColumn - FromColumn),!.

  grid_move_marker(grid_move_left,_,_,grid_col_marker([gl(FromColumn,ToColumn)]),grid_col_marker([gl(FromColumn1,ToColumn1)])):-
	FromColumn1 = 1,
	ToColumn1 = 1 + (ToColumn - FromColumn),!.
  grid_move_marker(grid_move_left,_,_,grid_area_marker([ga(FromRow,ToRow,FromColumn,ToColumn)]),grid_area_marker([ga(FromRow,ToRow,FromColumn1,ToColumn1)])):-
	FromColumn1 = 1,
	ToColumn1 = 1 + (ToColumn - FromColumn),!.

  grid_move_marker(grid_size_one_right,MaxColumn,_,grid_col_marker([gl(FromColumn,ToColumn)]),grid_col_marker([gl(FromColumn1,ToColumn1)])):-
	ToColumn01 = ToColumn + 1,
	ToColumn1 = grid_min(ToColumn01,MaxColumn),
	FromColumn1 = FromColumn,!.
  grid_move_marker(grid_size_one_right,MaxColumn,_,grid_area_marker([ga(FromRow,ToRow,FromColumn,ToColumn)]),grid_area_marker([ga(FromRow,ToRow,FromColumn1,ToColumn1)])):-
	ToColumn01 = ToColumn + 1,
	ToColumn1 = grid_min(ToColumn01,MaxColumn),
	FromColumn1 = FromColumn,!.

  grid_move_marker(grid_size_one_left,_,_,grid_col_marker([gl(FromColumn,ToColumn)]),grid_col_marker([gl(FromColumn1,ToColumn1)])):-
	ToColumn01 = ToColumn - 1,
	ToColumn1 = grid_max(FromColumn,ToColumn01),
	FromColumn1 = FromColumn,!.
  grid_move_marker(grid_size_one_left,_,_,grid_area_marker([ga(FromRow,ToRow,FromColumn,ToColumn)]),grid_area_marker([ga(FromRow,ToRow,FromColumn1,ToColumn1)])):-
	ToColumn01 = ToColumn - 1,
	ToColumn1 = grid_max(FromColumn,ToColumn01),
	FromColumn1 = FromColumn,!.

  grid_move_marker(grid_size_right,MaxColumn,_,grid_col_marker([gl(FromColumn,_)]),grid_col_marker([gl(FromColumn1,ToColumn1)])):-
	ToColumn1 = MaxColumn,
	FromColumn1 = FromColumn,!.
  grid_move_marker(grid_size_right,MaxColumn,_,grid_area_marker([ga(FromRow,ToRow,FromColumn,_)]),grid_area_marker([ga(FromRow,ToRow,FromColumn1,ToColumn1)])):-
	ToColumn1 = MaxColumn,
	FromColumn1 = FromColumn,!.

  grid_move_marker(grid_size_left,_,_,grid_col_marker([gl(FromColumn,_)]),grid_col_marker([gl(FromColumn1,ToColumn1)])):-
	ToColumn1 = FromColumn,
	FromColumn1 = FromColumn,!.
  grid_move_marker(grid_size_left,_,_,grid_area_marker([ga(FromRow,ToRow,FromColumn,_)]),grid_area_marker([ga(FromRow,ToRow,FromColumn1,ToColumn1)])):-
	ToColumn1 = FromColumn,
	FromColumn1 = FromColumn,!.

  grid_send_marker_beg(GridWin,grid_area_marker([ga(Row,_,Column,_)])):-!,
	grid_check_callback(GridWin,user_action(grid_area_marker_beg(Row,Column))).
  grid_send_marker_beg(GridWin,grid_col_marker([gl(Column,_)])):-!,
	grid_check_callback(GridWin,user_action(grid_col_marker_beg(Column))).
  grid_send_marker_beg(GridWin,grid_row_marker([gl(Row,_)])):-!,
	grid_check_callback(GridWin,user_action(grid_row_marker_beg(Row))).


/**global PREDICATE*******************************************************
			     GRID_INVALIDATE
 *************************************************************************/
  grid_Invalidate(GridWin,grid_all):-
	retractall(grid_invalidate_action),
	assert(grid_invalidate_action),
	grid_redraw(GridWin),!.
  grid_Invalidate(GridWin,grid_area(FromRow,ToRow,FromColumn,ToColumn)):-
	grid_convert(GridWin,grid_row(FromRow),grid_tb(T1x,_),_),
	grid_convert(GridWin,grid_row(ToRow),grid_tb(_,B1x),_),
	T1xx = grid_min1(T1x,10000),
	T1 = grid_max1(T1xx,-10000),
	B1xx = grid_min1(B1x,10000),
	B1 = grid_max1(B1xx,-10000),
	grid_convert(GridWin,grid_column(FromColumn),grid_lr(L1,_,_,_,_,_,_,_),_),
	grid_convert(GridWin,grid_column(ToColumn),grid_lr(_,R1,_,_,_,_,_,_),_),
	L = L1 + 1, T = T1 + 1, R = R1 - 1, B = B1 - 1,
	retractall(grid_invalidate_action),
	assert(grid_invalidate_action),
	TI = grid_val(T),
	BI = grid_val(B),
	win_Invalidate(GridWin,rct(L,TI,R,BI)),!.
  grid_Invalidate(_,_):-!.


  grid_Invalidate_my(GridWin,grid_all):-
	retractall(grid_invalidate_action),
	grid_redraw(GridWin),!.
  grid_Invalidate_my(GridWin,grid_area(FromRow,ToRow,FromColumn,ToColumn)):-
	grid_convert(GridWin,grid_row(FromRow),grid_tb(T1x,_),_),
	grid_convert(GridWin,grid_row(ToRow),grid_tb(_,B1x),_),
	T1xx = grid_min1(T1x,10000),
	T1 = grid_max1(T1xx,-10000),
	B1xx = grid_min1(B1x,10000),
	B1 = grid_max1(B1xx,-10000),
	grid_convert(GridWin,grid_column(FromColumn),grid_lr(L1,_,_,_,_,_,_,_),_),
	grid_convert(GridWin,grid_column(ToColumn),grid_lr(_,R1,_,_,_,_,_,_),_),
	L = L1 + 1, T = T1 + 1, R = R1 - 1, B = B1 - 1,
	retractall(grid_invalidate_action),
	TI = grid_val(T),
	BI = grid_val(B),
	win_Invalidate(GridWin,rct(L,TI,R,BI)),!.
  grid_Invalidate_my(_,_):-!.

/**global PREDICATE*******************************************************
			     GRID_MARKER
 *************************************************************************/
predicates
procedure  grid_check_marker_callback_needed()
clauses
  grid_check_marker_callback_needed():-
	grid_no_marker_callback,
	retract(grid_no_marker_callback),!.
  grid_check_marker_callback_needed():-
	assert(grid_no_marker_callback),!.

  grid_Marker(GridWin,Marker):-
	bound(Marker),
	grid_check_marker_callback_needed(),
	not(grid_remove_markers(GridWin,grid_single_marker)),
	retractall(grid_no_marker_callback),!.
  grid_Marker(GridWin,Marker):-
	bound(Marker),
	Marker = grid_row_marker(RowList),
	grid_row_info(GridWin,MaxRow,_,_,_,_,_,_),
	grid_correct_rowmarker(GridWin,MaxRow,RowList,[],NewRowList),
	grid_create_row_markers(GridWin,NewRowList),
	retractall(grid_no_marker_callback),!.
  grid_Marker(GridWin,Marker):-
	bound(Marker),
	Marker = grid_col_marker(ColumnList),
	grid_create_column_markers(GridWin,ColumnList),
	retractall(grid_no_marker_callback),!.
  grid_Marker(GridWin,Marker):-
	bound(Marker),
	Marker = grid_area_marker(AreaList),
	grid_row_info(GridWin,MaxRow,_,_,_,_,_,_),
	grid_correct_areamarker(GridWin,MaxRow,AreaList,[],NewAreaList),
	grid_create_area_markers(GridWin,NewAreaList),
	retractall(grid_no_marker_callback),!.
  grid_Marker(GridWin,Marker):-
	bound(Marker),
	Marker = grid_all_marker,
	grid_create_all_marker(GridWin),
	retractall(grid_no_marker_callback),!.
  grid_Marker(GridWin,Marker):-
	bound(Marker),
	Marker = grid_edit_cell(Row,Column),
	grid_create_cell_marker(GridWin,Row,Column),
	retractall(grid_no_marker_callback),!.
  grid_Marker(_,Marker):-
	bound(Marker),
	Marker = grid_no_marker,
	retractall(grid_no_marker_callback),!.
  grid_Marker(GridWin,Marker):-
	free(Marker),
	grid_row(GridWin,RowList),
	Marker = grid_row_marker(RowList),!.
  grid_Marker(GridWin,Marker):-
	free(Marker),
	grid_column(GridWin,ColumnList),
	Marker = grid_col_marker(ColumnList),!.
  grid_Marker(GridWin,Marker):-
	free(Marker),
	grid_area(GridWin,AreaList),
	Marker = grid_area_marker(AreaList),!.
  grid_Marker(GridWin,Marker):-
	free(Marker),
	grid_all(GridWin),
	Marker = grid_all_marker,!.
  grid_Marker(GridWin,Marker):-
	free(Marker),
	grid_edit(GridWin,_,_,Row,Column,_,_),
	Marker = grid_edit_cell(Row,Column),!.
  grid_Marker(_,Marker):-
	free(Marker),
	Marker = grid_no_marker,!.
  grid_Marker(_,Marker):-
	free(Marker),
	Marker = grid_no_marker,!,
	errorexit(error_vpi_package_bad_data).
  grid_Marker(_,Marker):-
	bound(Marker),!,
	errorexit(error_vpi_package_bad_data).

/**global PREDICATE*******************************************************
			     GRID_ROWS
 *************************************************************************/
  grid_Rows(GridWin,MaxRow):-
	bound(MaxRow),
	grid_RowStyle(GridWin,RowStyle),
	RowStyle = grid_rowstyle(RowSelectorAreaWidth,_,MaxTextLinesInRow,RowSelector,ActiveRowPointer),
	grid_RowStyle(GridWin,grid_rowstyle(RowSelectorAreaWidth,MaxRow,MaxTextLinesInRow,RowSelector,ActiveRowPointer)),!.
  grid_Rows(GridWin,MaxRow):-
	free(MaxRow),
	grid_RowStyle(GridWin,RowStyle),
	RowStyle = grid_rowstyle(_,MaxRow,_,_,_),!.
  grid_Rows(_,MaxRow):-
	free(MaxRow),
	MaxRow = 0,!,
	errorexit(error_vpi_package_bad_data).
  grid_Rows(_,MaxRow):-
	bound(MaxRow),!,
	errorexit(error_vpi_package_bad_data).

/**global PREDICATE*******************************************************
			     GRID_COLUMNSTYLE
 *************************************************************************/
  grid_ColumnStyle(GridWin,ColumnStyle):-
	bound(ColumnStyle),
	ColumnStyle = grid_columnstyle(NoScrollColumns,List),
	retractall(grid_column_stat(GridWin,_,_,_,_,_,_,_,_,_)),
	grid_build_column_list(GridWin,0,1,List),
	grid_listlength(List,MaxColumn),
	MaxNoScrollColumns = MaxColumn - 1,
	NewNoScrollColumns = grid_min(NoScrollColumns,MaxNoScrollColumns),
	retract(grid_column_info(GridWin,_,_,FirstColumn,LastColumn,_)),
	FirstColumn1 = NewNoScrollColumns + 1,
	NewFirstColumn = grid_max(FirstColumn,FirstColumn1),
	assert(grid_column_info(GridWin,MaxColumn,List,NewFirstColumn,LastColumn,NewNoScrollColumns)),
	grid_set_last_RowColumn(GridWin),
	grid_create_scroll_bar(GridWin),
	retractall(grid_nocalc_clear_area),
	assert(grid_nocalc_clear_area),
	grid_Invalidate_my(GridWin,grid_all),
	grid_refresh_edit_marker(GridWin),
	win_Invalidate(GridWin),
	grid_set_last_RowColumn(GridWin),!.
  grid_ColumnStyle(GridWin,ColumnStyle):-
	free(ColumnStyle),
	grid_column_info(GridWin,MaxColumn,_,_,_,NoScrollColumns),
	grid_build_column_list1(GridWin,MaxColumn,[],List),
	ColumnStyle = grid_columnstyle(NoScrollColumns,List),!.
  grid_ColumnStyle(_,ColumnStyle):-
	free(ColumnStyle),
	ColumnStyle = cast(GRID_COLUMNSTYLE,0),!,
	errorexit(error_vpi_package_bad_data).
  grid_ColumnStyle(_,ColumnStyle):-
	bound(ColumnStyle),!,
	errorexit(error_vpi_package_bad_data).


  grid_build_column_list1(_,0,List,List):-!.
  grid_build_column_list1(GridWin,Column,Empty,List):-
	grid_column_stat(GridWin,Title,Column,L,R,HorMargin,VertMargin,DX,DY,MaxText),!,
	Length = R - L,
	Column1 = Column - 1,
	grid_build_column_list1(GridWin,Column1,[grid_col(Title,Length,HorMargin,VertMargin,DX,DY,MaxText)|Empty],List).

/**global PREDICATE*******************************************************
			     GRID_ROWSTYLE
 *************************************************************************/
  grid_RowStyle(GridWin,RowStyle):-
	bound(RowStyle),
	RowStyle = grid_rowstyle(LeftTitleWidth,MaxRow,MaxLine,GridRowSelector,ActiveRowPointer),
	retract(grid_row_info(GridWin,_,_,_,_,_,FirstRow,LastRow)),
	win_GetFontMetrics(GridWin,_,Ascent,Descent),
	TopTitleHeight = Ascent + Descent + grid_row_height,
	RowHeight = (Ascent + Descent) * MaxLine + grid_row_height,
	assert(grid_row_info(GridWin,MaxRow,LeftTitleWidth,TopTitleHeight,RowHeight,MaxLine,FirstRow,LastRow)),
	grid_resize_grid(GridWin),
	retract(grid_view_info(GridWin,GridCellsStyle,_,_,ActiveRow,DefaultColor,BgColor,FrColor,BgTitleColor,FgTitleColor,InvisibleMarkers)),
	ActiveRow1 = grid_max(ActiveRow,1),
	NewActiveRow = grid_min(ActiveRow1,MaxRow),
	assert(grid_view_info(GridWin,GridCellsStyle,GridRowSelector,ActiveRowPointer,NewActiveRow,DefaultColor,BgColor,FrColor,BgTitleColor,FgTitleColor,InvisibleMarkers)),
	grid_set_last_RowColumn(GridWin),
	grid_create_scroll_bar(GridWin),
	retractall(grid_nocalc_clear_area),
	assert(grid_nocalc_clear_area),
	grid_Invalidate_my(GridWin,grid_all),
	grid_refresh_edit_marker(GridWin),
	grid_refresh_markers(GridWin),
	grid_reset_activerow(GridWin),
	win_Invalidate(GridWin),!.
  grid_RowStyle(GridWin,RowStyle):-
	free(RowStyle),
	grid_row_info(GridWin,MaxRow,LeftTitleWidth,_,_,MaxLine,_,_),
	grid_view_info(GridWin,_,GridRowSelector,ActiveRowPointer,_,_,_,_,_,_,_),
	RowStyle = grid_rowstyle(LeftTitleWidth,MaxRow,MaxLine,GridRowSelector,ActiveRowPointer),!.
  grid_RowStyle(_,RowStyle):-
	free(RowStyle),
	RowStyle = cast(GRID_ROWSTYLE,0),!,
	errorexit(error_vpi_package_bad_data).
  grid_RowStyle(_,RowStyle):-
	bound(RowStyle),!,
	errorexit(error_vpi_package_bad_data).
/**global PREDICATE*******************************************************
			     GRID_STYLE
 *************************************************************************/
  grid_Style(GridWin,Style):-
	bound(Style),
	Style = grid_style(GridCellsStyle,DefaultColor,BackGroundColor,EmptyCellColor,BgTitleColor,FrTitleColor),
	retract(grid_row_info(GridWin,MaxRow,LeftTitleWidth,_,_,MaxLine,FirstRow,LastRow)),
	win_GetFontMetrics(GridWin,_,Ascent,Descent),
	TopTitleHeight = Ascent + Descent + grid_row_height,
	RowHeight = (Ascent + Descent) * MaxLine + grid_row_height,
	assert(grid_row_info(GridWin,MaxRow,LeftTitleWidth,TopTitleHeight,RowHeight,MaxLine,FirstRow,LastRow)),
	grid_resize_grid(GridWin),
	retract(grid_view_info(GridWin,_,GridRowSelector,ActiveRowPointer,ActiveRow,_,_,_,_,_,InvisibleMarkers)),
	assert(grid_view_info(GridWin,GridCellsStyle,GridRowSelector,ActiveRowPointer,ActiveRow,DefaultColor,BackGroundColor,EmptyCellColor,BgTitleColor,FrTitleColor,InvisibleMarkers)),
	grid_set_last_RowColumn(GridWin),
	grid_create_scroll_bar(GridWin),
	retractall(grid_nocalc_clear_area),
	assert(grid_nocalc_clear_area),
	grid_refresh_markers(GridWin),
	grid_reset_activerow(GridWin),
	grid_Invalidate_my(GridWin,grid_all),
	grid_refresh_edit_marker(GridWin),!.
  grid_Style(GridWin,Style):-
	free(Style),
	grid_view_info(GridWin,GridCellsStyle,_,_,_,DefaultColor,BackGroundColor,EmptyCellColor,BgTitleColor,FrTitleColor,_),
	Style = grid_style(GridCellsStyle,DefaultColor,BackGroundColor,EmptyCellColor,BgTitleColor,FrTitleColor),!.
  grid_Style(_,Style):-
	free(Style),
	Style = cast(GRID_STYLE,0),!,
	errorexit(error_vpi_package_bad_data).
  grid_Style(_,Style):-
	bound(Style),!,
	errorexit(error_vpi_package_bad_data).
/**global PREDICATE*******************************************************
			     GRID_CALLBACKFUNC
 *************************************************************************/
  grid_CallBackFunc(GridWin,CallBackFunc):-
	bound(CallBackFunc),
	retract(grid_info(GridWin,RCT,_,ParentWin)),
	assert(grid_info(GridWin,RCT,CallBackFunc,ParentWin)),!.
  grid_CallBackFunc(GridWin,CallBackFunc):-
	free(CallBackFunc),
	grid_info(GridWin,_,CallBackFunc,_),!.

/**global PREDICATE*******************************************************
			     GRID_GET_POS
 *************************************************************************/
  grid_get_pos(GridWin,X,Y,Row,Column):-
	grid_get_central_area(GridWin,X,Y,Row,Column),!.
  grid_get_pos(GridWin,X,Y,0,0):-
	grid_get_lt_area(GridWin,X,Y),!.
  grid_get_pos(GridWin,X,Y,Row,0):-
	grid_get_left_area(GridWin,X,Y,Row),!.
  grid_get_pos(GridWin,X,Y,0,Column):-
	grid_get_top_area(GridWin,X,Y,Column),!.

/**global PREDICATE*******************************************************
			     GRID_VISITORDER
 *************************************************************************/
  grid_VisitOrder(GridWin,Key,Action):-
	grid_VisitOrder(GridWin,Key,c_Nothing,Action),!.

  grid_VisitOrder(GridWin,Key,ShiftCtlAlt,Action):-
	bound(Action),
	retractall(grid_visit_order(GridWin,Key,ShiftCtlAlt,_)),
	assert(grid_visit_order(GridWin,Key,ShiftCtlAlt,Action)),!.
  grid_VisitOrder(GridWin,Key,ShiftCtlAlt,Action):-
	free(Action),
	grid_visit_order(GridWin,Key,ShiftCtlAlt,Action),!.
  grid_VisitOrder(_,_,_,Action):-
	free(Action),
	Action = grid_none,!.

/**global PREDICATE*******************************************************
			     GRID_INVISIBLE_MARKERS
 *************************************************************************/
  grid_invisible_markers(GridWin,InvisibleMarkers):-
	bound(InvisibleMarkers),
	retract(grid_view_info(GridWin,CellsStyle,RowSelector,ActiveRowPointer,ActiveRow,
		DefaultColor,BgColor,FrColor,BgTitleColor,FgTitleColor,_)),
	assert(grid_view_info(GridWin,CellsStyle,RowSelector,ActiveRowPointer,ActiveRow,
		DefaultColor,BgColor,FrColor,BgTitleColor,FgTitleColor,InvisibleMarkers)),
	win_Invalidate(GridWin),!.
  grid_invisible_markers(GridWin,InvisibleMarkers):-
	free(InvisibleMarkers),
	grid_view_info(GridWin,_,_,_,_,_,_,_,_,_,InvisibleMarkers),!.
  grid_invisible_markers(_,InvisibleMarkers):-
	free(InvisibleMarkers),
	InvisibleMarkers = b_false,!,
	errorexit(error_vpi_package_bad_data).
  grid_invisible_markers(_,InvisibleMarkers):-
	bound(InvisibleMarkers),!,
	errorexit(error_vpi_package_bad_data).

/**global PREDICATE*******************************************************
			     GRID_ACTIVEROW
 *************************************************************************/
  grid_ActiveRow(GridWin,ActiveRow):-
	bound(ActiveRow),
	grid_reset_activerow(GridWin,ActiveRow),!.
  grid_ActiveRow(GridWin,ActiveRow):-
	free(ActiveRow),
	grid_view_info(GridWin,_,_,_,ActiveRow,_,_,_,_,_,_),!.
  grid_ActiveRow(_,ActiveRow):-
	free(ActiveRow),
	ActiveRow = 0,!,
	errorexit(error_vpi_package_bad_data).
  grid_ActiveRow(_,ActiveRow):-
	bound(ActiveRow),!,
	errorexit(error_vpi_package_bad_data).
