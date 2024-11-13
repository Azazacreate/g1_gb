/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S 

 FileName:	TABMAIN.PRO
 Purpose:	Module for Table Editor object
 Written by:	Andrey Skobelev
 Version:	1.0
 Build:		009.981112
 Tested with:   Visual Prolog v.5.1 build 555a
 Comments:	
******************************************************************************/
clauses
  tableedit_Init(Win,TabProp,ColumnList,InputData):-
	retractAll(tableedit_db_Te_Info(Win,_)),
	retractAll(tableedit_db_Col_Info(Win,_,_)),
	retractAll(tableedit_db_Data_Info(Win,_)),
	retractAll(tableedit_db_ShadowData_Info(Win,_)),
	retractAll(tableedit_db_DataBufRange(Win,_,_)),
	tableedit_CliarUndoRedoData(Win),
	assert(tableedit_db_InitMode(Win)),
	% assert default Property
	tableedit_InitDefaultEditor(Win),
	% reassert Property from list 
	tableedit_ReAssertPropertyList(Win,TabProp),
	% assert visible Data from list 
	tableedit_AssertStartData(Win,InputData),
	% assert shadow Data from list 
	assert(tableedit_db_ShadowData_Info(Win,[])),
	% assert default column property and reassert from list for columns
	tableedit_InitColumns(Win,0,ColumnList),
	trap(tableedit_Grid_Init(Win,InputData),_,fail),!.
  tableedit_Init(_,_,_,_):-
	errorExit().

  tableedit_GetProperties(Win,TabProperties):-
	tableedit_db_Te_Info(Win,_),
	findall(Prop,tableedit_db_Te_Info(Win,Prop),TabProperties),!.
  tableedit_GetProperties(_,[]):-
	errorExit().

  tableedit_SetProperties(Win,TabProp):-
	grid_Marker(Win,grid_no_marker),
	retractAll(tableedit_db_InitMode(Win)),
	assert(tableedit_db_InitMode(Win)),
	tableedit_ReAssertPropertyList(Win,TabProp),
	tableedit_db_Te_Info(Win,bufferingmode(nobuffering)),
	trap(Data = tableedit_GetAllData(Win),_,fail),
	retractAll(tableedit_db_Data_Info(Win,_)),
	retractAll(tableedit_db_ShadowData_Info(Win,_)),
	assert(tableedit_db_Data_Info(Win,Data)),
	assert(tableedit_db_ShadowData_Info(Win,[])),
	trap(tableedit_Grid_Init(Win,Data),_,fail),
	tableedit_CliarUndoRedoData(Win),
	!.
  tableedit_SetProperties(Win,_TabProp):-
	tableedit_db_Te_Info(Win,bufferingmode(buffering(_AnsFunc,_RowBuffSize,_MaxRows))),
	trap(tableedit_Grid_Init(Win,[]),_,fail),
	tableedit_CliarUndoRedoData(Win),
	!.
  tableedit_SetProperties(_,_):-
	errorExit().

  tableedit_GetColumnProperties(Win,Column,ColProperties):-
	trap(grid_ColumnStyle(Win,CS),_,fail), 
	CS = grid_columnstyle(_NS,CLIst),
	tableedit_ResetColWidth(Win,CLIst,1),
	tableedit_db_Col_Info(Win,Column,_),
	findall(Prop,tableedit_db_Col_Info(Win,Column,Prop),ColProperties),!.
  tableedit_GetColumnProperties(_,_,[]):-
	errorExit().

  tableedit_SetColumnProperties(Win,Column,ColProperties):-
	tableedit_db_Te_Info(Win,bufferingmode(nobuffering)),
	grid_Marker(Win,grid_no_marker),
	tableedit_InitColumn(Win,Column,ColProperties),
	tableedit_CreateGridColumnList(Win,GridColumnStyle),
	assert(tableedit_db_InitMode(Win)),
	tableedit_db_Col_Info(Win,Column,filterlist(FilterList)),
	tableedit_SetColumnFilter(Win,Column,FilterList),
	tableedit_db_Te_Info(Win,sortedby(Col)),
	tableedit_Sort(Win,Col),
	retractAll(tableedit_db_InitMode(Win)),
	tableedit_db_Data_Info(Win,Data),
	tableedit_CalcMaxRows(Win,Data,MaxRows),
	trap(grid_Rows(Win,MaxRows),_,fail),
	trap(grid_ColumnStyle(Win,GridColumnStyle),_,fail),
	tableedit_CliarUndoRedoData(Win),
	!.
  tableedit_SetColumnProperties(Win,Column,ColProperties):-
	tableedit_db_Te_Info(Win,bufferingmode(buffering(_AnsFunc,_RowBuffSize,MaxRows))),
	grid_Marker(Win,grid_no_marker),
	tableedit_InitColumn(Win,Column,ColProperties),
	tableedit_CreateGridColumnList(Win,GridColumnStyle),
	trap(grid_Rows(Win,MaxRows),_,fail),
	trap(grid_ColumnStyle(Win,GridColumnStyle),_,fail),
	tableedit_CliarUndoRedoData(Win),
	!.
  tableedit_SetColumnProperties(_,_,_):-
	errorExit().

  tableedit_GetMarker(Win,GridMarker):-trap(grid_Marker(Win,GridMarker),_,fail),!.
  tableedit_GetMarker(_,grid_no_marker):-
	errorExit().

  tableedit_SetMarker(Win,GridMarker):-trap(grid_Marker(Win,GridMarker),_,fail),!.
  tableedit_SetMarker(_,_):-
	errorExit().

% Set all data for nobuffering mode
% Request data from database for buffering mode (ignore NewData)
  tableedit_SetAllData(Win,NewData):-
	tableedit_db_Te_Info(Win,bufferingmode(nobuffering)),
	tableedit_db_Data_Info(Win,_),
	retractAll(tableedit_db_ShadowData_Info(Win,_)),
	assert(tableedit_db_ShadowData_Info(Win,[])),
	retract(tableedit_db_Data_Info(Win,_)),
	tableedit_db_Te_Info(Win,sortedby(Col)),
	tableedit_SortData(Win,Col,NewData,NewData1),
	assert(tableedit_db_Data_Info(Win,NewData1)),
	tableedit_CalcMaxRows(Win,NewData1,MaxRows),
	trap(grid_Rows(Win,MaxRows),_,fail),
	trap(grid_Invalidate(Win,grid_all),_,fail),
	tableedit_CliarUndoRedoData(Win),
	!.
  tableedit_SetAllData(Win,_NewData):-
	tableedit_db_Te_Info(Win,bufferingmode(buffering(_AnsFunc,_RowBuffSize,MaxRows))),
	tableedit_db_Data_Info(Win,_),
	retractAll(tableedit_db_ShadowData_Info(Win,_)),
	assert(tableedit_db_ShadowData_Info(Win,[])),
	retractAll(tableedit_db_DataBufRange(Win,_,_)),
	assert(tableedit_db_DataBufRange(Win,0,0)),
	trap(grid_Rows(Win,MaxRows),_,fail),
	trap(grid_Invalidate(Win,grid_all),_,fail),
	tableedit_CliarUndoRedoData(Win),
	!.
  tableedit_SetAllData(_,_):-
	errorExit().

  tableedit_GetAllVisibleData(Win,Data):-
	tableedit_db_Te_Info(Win,bufferingmode(nobuffering)),
	tableedit_db_Data_Info(Win,Data),!.
  tableedit_GetAllVisibleData(Win,Data):-
	tableedit_db_Te_Info(Win,bufferingmode(buffering(AnsFunc,_RowBuffSize,MaxRows))),
	AnsFunc(Win,1,MaxRows,Data),
	!.
  tableedit_GetAllVisibleData(_,[]):-
	errorExit().

  tableedit_GetAllData(Win,OutData1):-
	tableedit_db_Te_Info(Win,bufferingmode(nobuffering)),
	tableedit_db_ShadowData_Info(Win,ShadowData),
	tableedit_db_Data_Info(Win,VisibleData),
	tableedit_db_Te_Info(Win,footers(F)),
	tableedit_CalcMaxRows(Win,VisibleData,MaxRows), FootPos = MaxRows - F + 1,
	tableedit_InsListRows(Win,FootPos,ShadowData,VisibleData,[],OutData1),
	!.
  tableedit_GetAllData(Win,Data):-
	tableedit_db_Te_Info(Win,bufferingmode(buffering(AnsFunc,_RowBuffSize,MaxRows))),
	AnsFunc(Win,1,MaxRows,Data),
	!.
  tableedit_GetAllData(_,[]):-
	errorExit().

  tableedit_GetData(Win,FrRow,ToRow,FRColumn,ToColumn,OutData):-
	tableedit_db_Te_Info(Win,bufferingmode(nobuffering)),
	tableedit_db_Data_Info(Win,Data),
	tableedit_GetDataFromToRow(Win,1,FrRow,ToRow,FRColumn,ToColumn,Data,[],OutData),!.
  tableedit_GetData(Win,FrRow,ToRow,FRColumn,ToColumn,OutData):-
	tableedit_db_Te_Info(Win,bufferingmode(buffering(_AnsFunc,_RowBuffSize,_MaxRows))),
	tableedit_db_DataBufRange(Win,FromRowB,ToRowB),
	FrRow >= FromRowB, ToRow <= ToRowB,
	tableedit_db_Data_Info(Win,Data),
	FrRow1 = FrRow - FromRowB + 1,
	ToRow1 = ToRow - FromRowB + 1,
	tableedit_GetDataFromToRow(Win,1,FrRow1,ToRow1,FRColumn,ToColumn,Data,[],OutData),!.
  tableedit_GetData(Win,FrRow,ToRow,FRColumn,ToColumn,OutData):-
	tableedit_db_Te_Info(Win,bufferingmode(buffering(AnsFunc,_RowBuffSize,_MaxRows))),
	AnsFunc(Win,FrRow,ToRow,Data), FrRow1 = 1, ToRow1 = ToRow - FrRow + 1,
	tableedit_GetDataFromToRow(Win,1,FrRow1,ToRow1,FRColumn,ToColumn,Data,[],OutData),!.
  tableedit_GetData(_,_,_,_,_,[]):-
	errorExit().

% ---ignore for NObuffering mode
  tableedit_Buff_InvalidateArea(Win,FrRow,ToRow,FRColumn,ToColumn):-
	tableedit_db_Te_Info(Win,bufferingmode(buffering(_AnsFunc,_RowBuffSize,_MaxRows))),
	retractAll(tableedit_db_DataBufRange(Win,_,_)),
	assert(tableedit_db_DataBufRange(Win,0,0)),
	trap(grid_Invalidate(Win,grid_area(FrRow,ToRow,FRColumn,ToColumn)),_,fail),
	!.	
  tableedit_Buff_InvalidateArea(_,_,_,_,_):-!.


  tableedit_SetData(Win,FrRow,ToRow,FRColumn,ToColumn,InData):-
	tableedit_db_Te_Info(Win,bufferingmode(nobuffering)),
	retract(tableedit_db_Data_Info(Win,Data)),
	tableedit_SetDataFromToRow(Win,b_false,1,FrRow,ToRow,FRColumn,ToColumn,InData,Data,[],NewData),
	assert(tableedit_db_Data_Info(Win,NewData)),
	trap(grid_Invalidate(Win,grid_area(FrRow,ToRow,FRColumn,ToColumn)),_,fail),
	!.
  tableedit_SetData(Win,FrRow,ToRow,FRColumn,ToColumn,InData):-
	tableedit_db_Te_Info(Win,bufferingmode(buffering(_AnsFunc,_RowBuffSize,_MaxRows))),
	ToCol = tableedit_MaxCol(Win),
	Data = tableedit_GetData(Win,FrRow,ToRow,1,ToCol),
	ToRow1 = ToRow - FrRow + 1,
	tableedit_SetDataFromToRow(Win,b_true,FrRow,1,ToRow1,FRColumn,ToColumn,InData,Data,[],_NewData),
	retractAll(tableedit_db_DataBufRange(Win,_,_)),
	assert(tableedit_db_DataBufRange(Win,0,0)),
	trap(grid_Invalidate(Win,grid_area(FrRow,ToRow,FRColumn,ToColumn)),_,fail),
	!.
  tableedit_SetData(_,_,_,_,_,_):-
	errorExit().

  tableedit_SetCellData(Win,Row,Column,CellData):-
	trap(tableedit_SetData(Win,Row,Row,Column,Column,[[CellData]]),_,fail),!.
  tableedit_SetCellData(_,_,_,_):-
	errorExit().

  tableedit_GetCellData(Win,Row,Column,CellData):-
	trap(Data = tableedit_GetData(Win,Row,Row,Column,Column),_,fail),
	Data = [[CellData]],!.	
  tableedit_GetCellData(_,_,_,void):-
	errorExit().

  tableedit_SetActiveRow(Win,ActiveRow):-
	MaxRows = tableedit_MaxVisibleRows(Win),
	ActiveRow <= MaxRows,
	trap(grid_ActiveRow(Win,ActiveRow),_,fail),!.
  tableedit_SetActiveRow(_,_):-
	errorExit().

  tableedit_GetActiveRow(Win,ActiveRow):-
	trap(grid_ActiveRow(Win,ActiveRow),_,fail),!.
  tableedit_GetActiveRow(_,0):-
	errorExit().

  tableedit_MaxCol(Win,Col):- 
	tableedit_CalcMaxCol(Win,Col),
	not(Col = 0),!.
  tableedit_MaxCol(_,0):- 
	errorExit().

  tableedit_MaxVisibleRows(Win,MaxRows):-
	trap(grid_Rows(Win,MaxRows),_,fail),!.
  tableedit_MaxVisibleRows(_,0):-
	errorExit().

  tableedit_MaxRows(Win,Rows):-
	tableedit_db_Te_Info(Win,bufferingmode(nobuffering)),
	trap(grid_Rows(Win,MaxRows),_,fail),
	tableedit_db_ShadowData_Info(Win,ShadowData),
	tableedit_CalcMaxRows(Win,ShadowData,ShadowRows),
	Rows = MaxRows + ShadowRows,!.
  tableedit_MaxRows(Win,Rows):-
	tableedit_db_Te_Info(Win,bufferingmode(buffering(_AnsFunc,_RowBuffSize,_MaxRows))),
	Rows = tableedit_MaxVisibleRows(Win),!.
  tableedit_MaxRows(_,0):-
	errorExit().

% ---ignore for NObuffering mode
  tableedit_Buff_SetMaxRows(Win,MaxRows):-
	retract(tableedit_db_Te_Info(Win,bufferingmode(buffering(AnsFunc,RowBuffSize,_MaxRowsOld)))),
	assert(tableedit_db_Te_Info(Win,bufferingmode(buffering(AnsFunc,RowBuffSize,MaxRows)))),
	trap(grid_Rows(Win,MaxRows),_,fail),!.
  tableedit_Buff_SetMaxRows(_Win,_MaxRows):-!.

  tableedit_GetRowData(Win,FrRow,ToRow,String):-
	tableedit_CalcMaxCol(Win,MaxCol),
	Data = tableedit_GetData(Win,FrRow,ToRow,1,MaxCol),
	not(Data = []),
	tableedit_CreateStringRowsData(Data,String),
	!.
  tableedit_GetRowData(_,_,_,""):-
	errorExit().

  tableedit_GetClipBoardData(Win,FrRow,ToRow,FromCol,ToCol,String):-
	Data = tableedit_GetData(Win,FrRow,ToRow,FromCol,ToCol),
	not(Data = []),
	tableedit_CreateStringRowsData(Data,String),
	!.
  tableedit_GetClipBoardData(_,_,_,_,_,""):-
	errorExit().

% Ignore for buffering mode
  tableedit_SetRowData(Win,FrRow,SourceStr):-
	tableedit_db_Te_Info(Win,bufferingmode(nobuffering)),
	retractAll(tableedit_db_PasteError(Win)),
	tableedit_db_Data_Info(Win,Data),
	tableedit_CalcMaxRows(Win,Data,MaxRows),
	trap(ToCol = tableedit_MaxCol(Win),_,fail),
	tableedit_SetStrDataFromToRow(Win,b_false,FrRow,1,1,MaxRows,1,ToCol,SourceStr,Data,[],NewData,0,_NSet),
	not(tableedit_db_PasteError(Win)),
	retract(tableedit_db_Data_Info(Win,Data)),
	assert(tableedit_db_Data_Info(Win,NewData)),
	trap(grid_Invalidate(Win,grid_all),_,fail),!.
  tableedit_SetRowData(Win,_FrRow,_SourceStr):-
	tableedit_db_Te_Info(Win,bufferingmode(buffering(_AnsFunc,_RowBuffSize,_MaxRows))),
	!.
  tableedit_SetRowData(_,_,_):-
	errorExit().

  tableedit_SetRowData(Win,FrRow,ToRow,SourceStr):-
	tableedit_db_Te_Info(Win,bufferingmode(nobuffering)),
	retractAll(tableedit_db_PasteError(Win)),
	tableedit_db_Data_Info(Win,Data),
	trap(ToCol = tableedit_MaxCol(Win),_,fail),
	tableedit_SetStrDataFromToRow(Win,b_false,FrRow,1,1,ToRow,1,ToCol,SourceStr,Data,[],NewData,0,_NSet),
	not(tableedit_db_PasteError(Win)),
	retract(tableedit_db_Data_Info(Win,Data)),
	assert(tableedit_db_Data_Info(Win,NewData)),
	trap(grid_Invalidate(Win,grid_all),_,fail),!.
  tableedit_SetRowData(Win,FrRow,ToRow,SourceStr):-
	tableedit_db_Te_Info(Win,bufferingmode(buffering(_AnsFunc,_RowBuffSize,_MaxRows))),
	retractAll(tableedit_db_PasteError(Win)),
	ToCol = tableedit_MaxCol(Win),
	Data = tableedit_GetData(Win,FrRow,ToRow,1,ToCol),
	tableedit_SetStrDataFromToRow(Win,b_true,1,FrRow,FrRow,ToRow,1,ToCol,SourceStr,Data,[],NewData,0,_NSet),
	not(tableedit_db_PasteError(Win)),
	not(Data = NewData),
	retractAll(tableedit_db_DataBufRange(Win,_,_)),
	assert(tableedit_db_DataBufRange(Win,0,0)),
	trap(grid_Invalidate(Win,grid_area(FrRow,ToRow,1,ToCol)),_,fail),
	!.
  tableedit_SetRowData(Win,_FrRow,_ToRow,_SourceStr):-
	tableedit_db_Te_Info(Win,bufferingmode(buffering(_AnsFunc,_RowBuffSize,_MaxRows))),
	not(tableedit_db_PasteError(Win)),
	!.
  tableedit_SetRowData(_,_,_,_):-
	errorExit().

  tableedit_SetClipBoardData(Win,FrRow,ToRow,FromCol,ToCol,SourceStr):-
	tableedit_db_Te_Info(Win,bufferingmode(nobuffering)),
	retractAll(tableedit_db_PasteError(Win)),
	tableedit_db_Data_Info(Win,Data),
	trap(ToCol = tableedit_MaxCol(Win),_,fail),
	tableedit_SetStrDataFromToRow(Win,b_false,FrRow,1,1,ToRow,FromCol,ToCol,SourceStr,Data,[],NewData,0,_NSet),
	not(tableedit_db_PasteError(Win)),
	retract(tableedit_db_Data_Info(Win,Data)),
	assert(tableedit_db_Data_Info(Win,NewData)),
	trap(grid_Invalidate(Win,grid_all),_,fail),!.
  tableedit_SetClipBoardData(Win,FrRow,ToRow,FromCol,ToCol,SourceStr):-
	tableedit_db_Te_Info(Win,bufferingmode(buffering(_AnsFunc,_RowBuffSize,_MaxRows))),
	retractAll(tableedit_db_PasteError(Win)),
	Col = tableedit_MaxCol(Win),
	Data = tableedit_GetData(Win,FrRow,ToRow,1,Col),
	tableedit_SetStrDataFromToRow(Win,b_true,1,FrRow,FrRow,ToRow,FromCol,ToCol,SourceStr,Data,[],NewData,0,_NSet),
	not(tableedit_db_PasteError(Win)),
	not(Data = NewData),
	retractAll(tableedit_db_DataBufRange(Win,_,_)),
	assert(tableedit_db_DataBufRange(Win,0,0)),
	trap(grid_Invalidate(Win,grid_area(FrRow,ToRow,FromCol,ToCol)),_,fail),
	!.
  tableedit_SetClipBoardData(Win,_FrRow,_ToRow,_FromCol,_ToCol,_SourceStr):-
	tableedit_db_Te_Info(Win,bufferingmode(buffering(_AnsFunc,_RowBuffSize,_MaxRows))),
	not(tableedit_db_PasteError(Win)),
	!.
  tableedit_SetClipBoardData(_,_,_,_,_,_):-
	errorExit().

% ignore for buffering mode
  tableedit_SetColumnFilter(Win,Column,FilterList):-
	tableedit_db_Te_Info(Win,bufferingmode(nobuffering)),
	retract(tableedit_db_Col_Info(Win,Column,filterlist(_))),
	assert(tableedit_db_Col_Info(Win,Column,filterlist(FilterList))),
	tableedit_ProcessFilter(Win),
	!.
  tableedit_SetColumnFilter(Win,_Column,_FilterList):-
	tableedit_db_Te_Info(Win,bufferingmode(buffering(_AnsFunc,_RowBuffSize,_MaxRows))),
	!.
  tableedit_SetColumnFilter(_,_,_):-
	errorExit().

% ignore for buffering mode
  tableedit_ReSetFilters(Win,Filters):-
	tableedit_db_Te_Info(Win,bufferingmode(nobuffering)),
	retractAll(tableedit_db_Col_Info(Win,_,filterlist(_))),
	tableedit_CliarFilters(Win),
	tableedit_SetFilters(Win,Filters),
	!.
  tableedit_ReSetFilters(Win,_Filters):-
	tableedit_db_Te_Info(Win,bufferingmode(buffering(_AnsFunc,_RowBuffSize,_MaxRows))),
	!.
  tableedit_ReSetFilters(_,_):-
	errorExit().

% ignore for buffering mode
  tableedit_Sort(Win,Col):-
	tableedit_db_Te_Info(Win,bufferingmode(nobuffering)),
	tableedit_db_Col_Info(Win,Col,sortmode(ascending(Ilist))),
	tableedit_db_Te_Info(Win,compare(CompareFunc)),
	trap(Data = tableedit_GetAllVisibleData(Win),_,fail),
	tableedit_CutHeadersFooters(Win,Data,Data1,HeadData,FootData),
	tableedit_sort_data(Win,CompareFunc,b_true,[Col|Ilist],Data1,NewData),
	tableedit_InsHeadersFooters(Win,NewData,OutData,HeadData,FootData),
	trap(tableedit_SetAllDataNoSort(Win,OutData),_,fail),
	tableedit_CliarUndoRedoData(Win),
	!.
  tableedit_Sort(Win,Col):-
	tableedit_db_Te_Info(Win,bufferingmode(nobuffering)),
	tableedit_db_Col_Info(Win,Col,sortmode(descending(Ilist))),
	tableedit_db_Te_Info(Win,compare(CompareFunc)),
	trap(Data = tableedit_GetAllVisibleData(Win),_,fail),
	tableedit_CutHeadersFooters(Win,Data,Data1,HeadData,FootData),
	tableedit_sort_data(Win,CompareFunc,b_false,[Col|Ilist],Data1,NewData),
	tableedit_InsHeadersFooters(Win,NewData,OutData,HeadData,FootData),
	trap(tableedit_SetAllDataNoSort(Win,OutData),_,fail),
	tableedit_CliarUndoRedoData(Win),
	!.
  tableedit_Sort(Win,Col):-
	tableedit_db_Te_Info(Win,bufferingmode(nobuffering)),
	tableedit_db_Col_Info(Win,Col,sortmode(_)),!.
  tableedit_Sort(Win,_Col):-
	tableedit_db_Te_Info(Win,bufferingmode(buffering(_AnsFunc,_RowBuffSize,_MaxRows))),
	!.
  tableedit_Sort(_Win,_):-!.

% ignore for buffering mode
% delete rows contains in line list
  tableedit_DeleteRows(Win,LList):-
	tableedit_db_Te_Info(Win,bufferingmode(nobuffering)),
	tableedit_DelRows(Win,b_false,LList),
	tableedit_db_Data_Info(Win,NewData),
	tableedit_CalcMaxRows(Win,NewData,MaxRows),
	grid_Rows(Win,MaxRows),!.
  tableedit_DeleteRows(Win,_):-
	tableedit_db_Te_Info(Win,bufferingmode(buffering(_AnsFunc,_RowBuffSize,_MaxRows))),
	!.
  tableedit_DeleteRows(_,_):-
	errorExit().

% ignore for buffering mode
  tableedit_InsertRows(Win,Row,InsData):-
	tableedit_db_Te_Info(Win,bufferingmode(nobuffering)),
	retract(tableedit_db_Data_Info(Win,Data)),
	tableedit_SaveInsDataForUndo(Win,Row,InsData),
	tableedit_InsListRows(Win,Row,InsData,Data,[],NewData),
	assert(tableedit_db_Data_Info(Win,NewData)),
	tableedit_CalcMaxRows(Win,NewData,MaxRows),
	grid_Rows(Win,MaxRows),!.
  tableedit_InsertRows(Win,_Row,_InsData):-
	tableedit_db_Te_Info(Win,bufferingmode(buffering(_AnsFunc,_RowBuffSize,_MaxRows))),
	!.
  tableedit_InsertRows(_,_,_):-
	errorExit().

% ignore for buffering mode
  tableedit_InsertRowsToEnd(Win,InsData,FromRow):-
	tableedit_db_Te_Info(Win,bufferingmode(nobuffering)),
	retract(tableedit_db_Data_Info(Win,Data)),
	tableedit_db_Te_Info(Win,footers(F)),
	tableedit_CalcMaxRows(Win,Data,MaxRowsOld),
	Row = MaxRowsOld - F + 1, FromRow = Row,
	tableedit_SaveInsDataForUndo(Win,Row,InsData),
	tableedit_InsListRows(Win,Row,InsData,Data,[],NewData),
	assert(tableedit_db_Data_Info(Win,NewData)),
	tableedit_CalcMaxRows(Win,NewData,MaxRows),
	grid_Rows(Win,MaxRows),!.
  tableedit_InsertRowsToEnd(Win,_InsData,0):-
	tableedit_db_Te_Info(Win,bufferingmode(buffering(_AnsFunc,_RowBuffSize,_MaxRows))),
	!.
  tableedit_InsertRowsToEnd(_,_,0):-
	errorExit().

% ignore for buffering mode
  tableedit_InsertDefRowsToEnd(Win,Nrows,FromRow):-
	tableedit_db_Te_Info(Win,bufferingmode(nobuffering)),
	retract(tableedit_db_Data_Info(Win,Data)),
	tableedit_db_Te_Info(Win,footers(F)),
	tableedit_CalcMaxRows(Win,Data,MaxRowsOld),
	Row = MaxRowsOld - F + 1,  FromRow = Row,
	tableedit_CreateDefRow(Win,1,[],DefData),
	tableedit_CreateDefRows(Win,Nrows,DefData,[],InsData),
	tableedit_SaveInsDataForUndo(Win,Row,InsData),
	tableedit_InsListRows(Win,Row,InsData,Data,[],NewData),
	assert(tableedit_db_Data_Info(Win,NewData)),
	tableedit_CalcMaxRows(Win,NewData,MaxRows),
	grid_Rows(Win,MaxRows),
	!.
  tableedit_InsertDefRowsToEnd(Win,_Nrows,0):-
	tableedit_db_Te_Info(Win,bufferingmode(buffering(_AnsFunc,_RowBuffSize,_MaxRows))),
	!.
  tableedit_InsertDefRowsToEnd(_,_,0):-
	errorExit().

  tableedit_SetVisitOrder(Win,Key,ShiftCtlAlt,Key_Action):-
	grid_VisitOrder(Win,Key,ShiftCtlAlt,Key_Action),!.
  tableedit_SetVisitOrder(_,_,_,_):-
	errorExit().

  tableedit_GetVisitOrder(Win,Key,ShiftCtlAlt,Key_Action):-
	grid_VisitOrder(Win,Key,ShiftCtlAlt,Key_Action),!.

% fail for buffering mode, fail for nobuffering mode,if string not find.
  tableedit_Find(Win,Str,Direction,Column,Match,CaseSens,RowPosition):-
	tableedit_db_Te_Info(Win,bufferingmode(nobuffering)),
	tableedit_FindString(Win,Str,Direction,Column,Match,CaseSens,RowPosition),
	!.

  tableedit_OptimizeColumnsWidth(Win,NotResizableResize):-
	NotResizableResize = b_false,
	Flags = win_GetState(Win),
	win_SetState(Win,[wsf_Invisible]),
	NCol = tableedit_MaxCol(Win),
	tableedit_CalcColSize(Win,b_true,1,Ncol,0,ResizableW),
	tableedit_CalcColSize(Win,b_false,1,Ncol,0,NotResizableW),
	tableedit_GetScrollWidth(Win,ScrollWidth),
	tableedit_GetSelectorWidth(Win,SelectorWidth),
	SW = ScrollWidth + SelectorWidth,
	RCT = win_GetClientRect(Win), RCT = rct(_,_,WW,_),
	WW1 = WW - NotResizableW - SW,
	WW2 = WW - SW,
	tableedit_SetRelativeWidth(Win,NotResizableResize,1,NCol,ResizableW,WW1,WW2,0,_),
	win_SetState(Win,Flags),
	!.
  tableedit_OptimizeColumnsWidth(Win,NotResizableResize):-
	NotResizableResize = b_true,
	Flags = win_GetState(Win),
	win_SetState(Win,[wsf_Invisible]),
	NCol = tableedit_MaxCol(Win),
	tableedit_CalcColSize(Win,b_true,1,Ncol,0,RW),
	tableedit_CalcColSize(Win,b_false,1,Ncol,0,NRW),
	ResizableW = RW + NRW,
	NotResizableW = 0,
	tableedit_GetScrollWidth(Win,ScrollWidth),
	tableedit_GetSelectorWidth(Win,SelectorWidth),
	SW = ScrollWidth + SelectorWidth,
	RCT = win_GetClientRect(Win), RCT = rct(_,_,WW,_),
	WW1 = WW - NotResizableW - SW,
	WW2 = WW - SW,
	tableedit_SetRelativeWidth(Win,NotResizableResize,1,NCol,ResizableW,WW1,WW2,0,_),
	win_SetState(Win,Flags),
	!.
  tableedit_OptimizeColumnsWidth(_Win,_):-errorexit().

  tableedit_GetInvisibleMarkers(Win,InvisibleVisible):-
	trap(grid_invisible_markers(Win,InvisibleVisible),_,fail),
	!.
  tableedit_GetInvisibleMarkers(_Win,b_false):-errorexit().

  tableedit_SetInvisibleMarkers(Win,InvisibleVisible):-
	trap(grid_invisible_markers(Win,InvisibleVisible),_,fail),
	!.
  tableedit_SetInvisibleMarkers(_Win,_):-errorexit().

%procedure grid_invisible_markers(WINDOW GridWin,BOOLEAN InvisibleVisible) - (i,i), (i,o)


  tableedit_HandleEvent(GridWin,Event):-
	tableedit_HandleEvent1(GridWin,Event),
	grid_HandleEvent(GridWin,EVENT).



