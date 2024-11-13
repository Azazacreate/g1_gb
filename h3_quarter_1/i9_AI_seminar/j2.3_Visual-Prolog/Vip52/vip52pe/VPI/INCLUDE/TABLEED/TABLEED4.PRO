/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S 

 FileName:	TABLEED4.PRO
 Purpose:	Module for Table Editor object
 Written by:	Andrey Skobelev
 Version:	1.0
 Build:		009.981112
 Tested with:   Visual Prolog v.5.1 build 555a
 Comments:	
******************************************************************************/

clauses

  tableedit_AssertStartData(Win,InputData):-
	tableedit_db_Te_Info(Win,bufferingmode(nobuffering)),
	assert(tableedit_db_Data_Info(Win,InputData)),
	!.
  tableedit_AssertStartData(Win,_):-
	tableedit_db_Te_Info(Win,bufferingmode(buffering(_AnsFunc,_RowBuffSize,_MaxRows))),
	assert(tableedit_db_Data_Info(Win,[])),
	assert(tableedit_db_DataBufRange(Win,0,0)),
	!.
  tableedit_AssertStartData(_Win,_):-errorexit().

% Request data for buffer, if Row not in RowRange
  tableedit_RequestBuff(Win,_Row):-
	tableedit_db_Te_Info(Win,bufferingmode(nobuffering)),
	!.
  tableedit_RequestBuff(Win,Row):-
	tableedit_db_Te_Info(Win,bufferingmode(buffering(_AnsFunc,_RowBuffSize,_MaxRows))),
	tableedit_db_DataBufRange(Win,FromRow,ToRow),
	Row >= FromRow, Row<=ToRow,
	!.
  tableedit_RequestBuff(Win,FromRow):-
	tableedit_db_Te_Info(Win,bufferingmode(buffering(AnsFunc,RowBuffSize,MaxRows))),
	Row = ((FromRow - 1) div RowBuffSize + 1) * RowBuffSize - RowBuffSize + 1,
	ToRow = Row + RowBuffSize - 1, ToRow <= MaxRows,
	AnsFunc(Win,Row,ToRow,Data),
	retractAll(tableedit_db_DataBufRange(Win,_,_)),
	assert(tableedit_db_DataBufRange(Win,Row,ToRow)),
	retractAll(tableedit_db_Data_Info(Win,_)),
	assert(tableedit_db_Data_Info(Win,Data)),
	!.
  tableedit_RequestBuff(Win,FromRow):-
	tableedit_db_Te_Info(Win,bufferingmode(buffering(AnsFunc,RowBuffSize,MaxRows))),
	Row = ((FromRow - 1) div RowBuffSize + 1) * RowBuffSize - RowBuffSize + 1,
	ToRow = Row + RowBuffSize - 1, ToRow > MaxRows,
	AnsFunc(Win,Row,MaxRows,Data),
	retractAll(tableedit_db_DataBufRange(Win,_,_)),
	assert(tableedit_db_DataBufRange(Win,Row,MaxRows)),
	retractAll(tableedit_db_Data_Info(Win,_)),
	assert(tableedit_db_Data_Info(Win,Data)),
	!.
  tableedit_RequestBuff(_Win,_Row):-!.

% Request data for buffer, if FromRow - ToRow not in RowRange
  tableedit_RequestBuff(Win,_FromRow,_ToRow):-
	tableedit_db_Te_Info(Win,bufferingmode(nobuffering)),
	!.
  tableedit_RequestBuff(Win,FromRow1,ToRow1):-
	tableedit_db_Te_Info(Win,bufferingmode(buffering(_AnsFunc,_RowBuffSize,_MaxRows))),
	tableedit_db_DataBufRange(Win,FromRow,ToRow),
	FromRow1 >= FromRow, ToRow1 <= ToRow,
	!.
  tableedit_RequestBuff(Win,FromRow,_ToRow1):-
	tableedit_db_Te_Info(Win,bufferingmode(buffering(AnsFunc,RowBuffSize,MaxRows))),
	FromRow1 = ((FromRow - 1) div RowBuffSize + 1) * RowBuffSize - RowBuffSize + 1,
	ToRow = FromRow1 + RowBuffSize - 1, ToRow <= MaxRows,
	AnsFunc(Win,FromRow1,ToRow,Data),
	retractAll(tableedit_db_DataBufRange(Win,_,_)),
	assert(tableedit_db_DataBufRange(Win,FromRow1,ToRow)),
	retractAll(tableedit_db_Data_Info(Win,_)),
	assert(tableedit_db_Data_Info(Win,Data)),
	!.
  tableedit_RequestBuff(Win,FromRow,_ToRow1):-
	tableedit_db_Te_Info(Win,bufferingmode(buffering(AnsFunc,RowBuffSize,MaxRows))),
	FromRow1 = ((FromRow - 1) div RowBuffSize + 1) * RowBuffSize - RowBuffSize + 1,
	ToRow = FromRow1 + RowBuffSize - 1, ToRow > MaxRows,
	AnsFunc(Win,FromRow1,MaxRows,Data),
	retractAll(tableedit_db_DataBufRange(Win,_,_)),
	assert(tableedit_db_DataBufRange(Win,FromRow1,MaxRows)),
	retractAll(tableedit_db_Data_Info(Win,_)),
	assert(tableedit_db_Data_Info(Win,Data)),
	!.
  tableedit_RequestBuff(_Win,_FromRow1,_ToRow1):-!.

  tableedit_GetBuffCellData(Win,Row,Column,CellData):-
	tableedit_RequestBuff(Win,Row),
	tableedit_db_DataBufRange(Win,FromRow,_ToRow),
	tableedit_db_Data_Info(Win,Data),
	XRow = Row - FromRow + 1,
	tableedit_member_index(ColumnData,Data,XRow),
	tableedit_member_index(CellData,ColumnData,Column),
	!.
  tableedit_GetBuffCellData(_,_,_,void):- errorexit().

predicates
procedure  tableedit_OptimAnswer(WINDOW)
clauses

  tableedit_OptimAnswer(Win):-
	tableedit_db_DataBufRange(Win,FromRow,_ToRow1),
	retract(tableedit_db_AnswerRange(Win,FromRow,ToRow,FromColumn,ToColumn)),
	asserta(tableedit_db_AnswerRange(Win,FromRow,ToRow,FromColumn,ToColumn)),
	!.
  tableedit_OptimAnswer(_Win):-!.

  tableedit_SeparateAnswer(Win):-
	tableedit_db_Te_Info(Win,bufferingmode(buffering(_AnsFunc,RowBuffSize,_MaxRows))),
	tableedit_db_AnswerRange(Win,FromRow,ToRow,FromColumn,ToColumn),
	FromRow1 = ((FromRow - 1) div RowBuffSize + 1) * RowBuffSize - RowBuffSize + 1,
	RowBuffSize < ToRow - FromRow1 + 1,
	retract(tableedit_db_AnswerRange(Win,FromRow,ToRow,FromColumn,ToColumn)),
	ToRow1 = FromRow1 + RowBuffSize - 1,
	FromRow2 = ToRow1 + 1,
	assertz(tableedit_db_AnswerRange(Win,FromRow1,ToRow1,FromColumn,ToColumn)),
	assertz(tableedit_db_AnswerRange(Win,FromRow2,ToRow,FromColumn,ToColumn)),!,
	tableedit_SeparateAnswer(Win).
  tableedit_SeparateAnswer(Win):- tableedit_OptimAnswer(Win),!.

  tableedit_HandleBuffAnswer(Win):-
	tableedit_db_Te_Info(Win,bufferingmode(buffering(_AnsFunc,_RowBuffSize,_MaxRows))),
	tableedit_db_AnswerRange(Win,FromRow,ToRow,FromColumn,ToColumn),
	tableedit_RequestBuff(Win,FromRow,ToRow),
	tableedit_HandleBuffAnswer1(Win,FromRow,ToRow,FromColumn,ToColumn),
	!.
  tableedit_HandleBuffAnswer(_Win):-!.

predicates
procedure  tableedit_RepHandleNextAnswer(WINDOW)
clauses

  tableedit_HandleBuffAnswer1(Win,FromRow,ToRow,FromColumn,ToColumn):-
	retract(tableedit_db_AnswerRange(Win,FromRow,ToRow,FromColumn,ToColumn)),
	tableedit_db_DataBufRange(Win,From_Row,_To_Row),
	FromRow1 = FromRow - From_Row + 1,
	ToRow1 = ToRow - From_Row + 1,
	tableedit_GetGridDataFromTo(Win,FromRow1,ToRow1,FromColumn,ToColumn,AnswerList),
	AnswerData = data_answer(grid_area_answer(AnswerList)),
	grid_draw(Win,FromRow,ToRow,FromColumn,ToColumn,AnswerData),
	tableedit_RepHandleNextAnswer(Win),
	!.
  tableedit_HandleBuffAnswer1(_Win,_FromRow,_ToRow,_,_):-!.

  tableedit_RepHandleNextAnswer(Win):-
	tableedit_db_AnswerRange(Win,_FromRow,_ToRow,_,_),
	win_PostEvent(Win,e_User(6623,1)),
	!.
  tableedit_RepHandleNextAnswer(_):-!.

  tableedit_BuffInvalidate(Win):-
	tableedit_db_Te_Info(Win,bufferingmode(buffering(_AnsFunc,_RowBuffSize,_MaxRows))),
	retractAll(tableedit_db_DataBufRange(Win,_,_)),
	assert(tableedit_db_DataBufRange(Win,0,0)),
	trap(grid_Invalidate(Win,grid_all),_,fail),
	!.
  tableedit_BuffInvalidate(_):-!.

  tableedit_BuffInvalidate(Win,Row):-
	tableedit_db_Te_Info(Win,bufferingmode(buffering(_AnsFunc,_RowBuffSize,_MaxRows))),
	tableedit_db_DataBufRange(Win,FromRow,ToRow),
	Row >= FromRow,	Row <= ToRow,
	tableedit_BuffInvalidate(Win),
	!.
  tableedit_BuffInvalidate(_,_):-!.

predicates
procedure  tableedit_SetRelativeWidth(WINDOW Win,BOOLEAN NotResizableResize,INTEGER Col,INTEGER MaxCol,INTEGER ResizableW,INTEGER Factor,INTEGER AreaWidth,INTEGER,INTEGER)
procedure  tableedit_GetScrollWidth(WINDOW Win,INTEGER ScrollWidth)
procedure  tableedit_CalcColSize(WINDOW Win,BOOLEAN Resizable,INTEGER Col,INTEGER Maxcol,INTEGER,INTEGER TotalWidth)
procedure  tableedit_GetSelectorWidth(WINDOW Win,INTEGER SelectorWidth)
procedure  tableedit_CorrectWidth(INTEGER Old,INTEGER New)
procedure  tableedit_CalcNewWidth(INTEGER,INTEGER,INTEGER,INTEGER)
determ  tableedit_CheckResizable(TABLEEDIT_COLUMNPROPERTIES,BOOLEAN NotResizableResize)

clauses

  tableedit_CorrectWidth(Old,Old):- Old >= 1,!.
  tableedit_CorrectWidth(_Old,1):-!.

  tableedit_CalcNewWidth(W,WW1,ResizableW,NewW2):-
	not(ResizableW = 0),
	Factor = WW1/ResizableW,
	NewW2 = val(INTEGER,W * Factor),
	!.
  tableedit_CalcNewWidth(_W,_WW1,_ResizableW,0):-!.

  tableedit_CheckResizable(Cprop,NotResizableResize):-
	NotResizableResize = b_false,
	tableedit_member(resizable(b_true),Cprop),
	!.
  tableedit_CheckResizable(_Cprop,NotResizableResize):-
	NotResizableResize = b_true,
	!.

  tableedit_SetRelativeWidth(Win,NotResizableResize,Col,NCol,_ResizableW,_WW1,WW2,NewW,NewW):-
	Col = NCol,
	Cprop = tableedit_GetColumnProperties(Win,Col),
	tableedit_CheckResizable(Cprop,NotResizableResize),
	NewW2 = WW2 - NewW,
	tableedit_CorrectWidth(NewW2,Width),
	tableedit_SetColumnProperties(Win,Col,[width(Width)]),
	!.
  tableedit_SetRelativeWidth(Win,_,Col,NCol,_ResizableW,_WW1,_WW2,NewW,NewW):-
	Col = NCol,
	Cprop = tableedit_GetColumnProperties(Win,Col),
	tableedit_member(resizable(b_false),Cprop),
	!.
  tableedit_SetRelativeWidth(Win,NotResizableResize,Col1,NCol,ResizableW,WW1,WW2,NewW1,NewW):-
	Cprop = tableedit_GetColumnProperties(Win,Col1),
	tableedit_CheckResizable(Cprop,NotResizableResize),
	tableedit_member(width(W),Cprop),
	tableedit_CalcNewWidth(W,WW1,ResizableW,NewW2),
	tableedit_CorrectWidth(NewW2,Width),
	tableedit_SetColumnProperties(Win,Col1,[width(Width)]),
	NewW3 = NewW1 + Width, Col2 = Col1 + 1,!,
	tableedit_SetRelativeWidth(Win,NotResizableResize,Col2,NCol,ResizableW,WW1,WW2,NewW3,NewW).
  tableedit_SetRelativeWidth(Win,NotResizableResize,Col1,NCol,ResizableW,WW1,WW2,NewW1,NewW):-
	Cprop = tableedit_GetColumnProperties(Win,Col1),
	tableedit_member(resizable(b_false),Cprop),
	tableedit_member(width(W),Cprop),
	NewW3 = NewW1 + W, Col2 = Col1 + 1,!,
	tableedit_SetRelativeWidth(Win,NotResizableResize,Col2,NCol,ResizableW,WW1,WW2,NewW3,NewW).
  tableedit_SetRelativeWidth(_,_,_,_,_,_,_,_,0):-errorexit().

  tableedit_GetScrollWidth(Win,ScrollW):-
	tableedit_db_VScroll(Win),
	ScrollW = vpi_GetAttrVal(attr_ctl_vert_sbar_width),
	!.
  tableedit_GetScrollWidth(_Win,0):-!.

  tableedit_GetSelectorWidth(Win,SelW):-
	Prop = tableedit_GetProperties(Win),
	tableedit_member(rowselector(_,SelW,_),Prop),
	!.
  tableedit_GetSelectorWidth(_Win,0):-!.
	
  tableedit_CalcColSize(_Win,_Resizable,Col,Ncol,TotalW,TotalW):- Col>Ncol,!.
  tableedit_CalcColSize(Win,Resizable,Col1,Ncol,TotalW1,TotalW):-
	Cprop = tableedit_GetColumnProperties(Win,Col1),
	tableedit_member(width(W),Cprop),
	tableedit_member(resizable(Resizable),Cprop),
	TotalW2 = TotalW1 + W, Col2 = Col1 + 1,!,
	tableedit_CalcColSize(Win,Resizable,Col2,Ncol,TotalW2,TotalW).
  tableedit_CalcColSize(Win,Resizable,Col1,Ncol,TotalW1,TotalW):-
	Col2 = Col1 + 1,!,
	tableedit_CalcColSize(Win,Resizable,Col2,Ncol,TotalW1,TotalW).
	
	
