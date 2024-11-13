/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S 

 FileName:	TABLEED1.PRO
 Purpose:	Module for Table Editor object
 Written by:	Andrey Skobelev
 Version:	1.0
 Build:		009.981112
 Tested with:   Visual Prolog v.5.1 build 555a
 Comments:	
******************************************************************************/
constants
  tableedit_MenuId1 = 2001
  tableedit_MenuId2 = 2002
  tableedit_MenuId3 = 2003
  tableedit_MenuId4 = 2004
  tableedit_MenuId5 = 2005
  tableedit_MenuId6 = 2006
  tableedit_MenuId7 = 2007
  tableedit_MenuId8 = 2008
  tableedit_MenuId9 = 2009
  tableedit_MenuId10 = 2010
  tableedit_MenuId11 = 2011
  tableedit_MenuId12 = 2012
  tableedit_MenuId13 = 2013
  tableedit_MenuId14 = 2014
  tableedit_MenuId15 = 2015
  tableedit_MenuId16 = 2016
  tableedit_MenuId17 = 2017
  tableedit_MenuId18 = 2018
  tableedit_MenuId19 = 2019
  tableedit_MenuId20 = 2020
  tableedit_MenuId21 = 2021
  tableedit_MenuId22 = 2022
  tableedit_MenuId23 = 2023

  dlg_find_DlgType = wd_Modal
  dlg_find_Title = tableedit_con_find
  dlg_find_RCT = rct(50,40,250,150)
  dlg_find_Flags = [wsf_DlgBorder,wsf_Close,wsf_TitleBar]
  dlg_find_Help = contents
  con_rb_entire		= 1001
  con_rb_from		= 1002
  con_rb_backward	= 1003
  con_rb_forward	= 1004
  con_fromstart		= 1005
  con_entirestring	= 1006
  con_anypart		= 1007
  con_findcolumn	= 1008
  con_Casesensitive	= 1009
  con_findstr		= 1010
  con_static_text	= 1011
  con_static_text1	= 1012
  con_groupbox		= 1013
  con_groupbox1		= 1014
  con_groupbox2		= 1015

domains
% Domains for undo, redo 
  TABLEEDIT_UNDOREDODATA = modified(INTEGER Row,INTEGER Column,
			   TABLEEDIT_CELLDATA OldValue,TABLEEDIT_CELLDATA NewValue);
			   marker(GRID_MARKER);
			   row(INTEGER Row,TABLEEDIT_COLUMNDATA Old,TABLEEDIT_COLUMNDATA New);
			   resize_column(INTEGER Column,INTEGER Width)
  TABLEEDIT_UNDOREDOLIST = TABLEEDIT_UNDOREDODATA*

database - tableedit_db
% Visible data
  tableedit_db_Data_Info(WINDOW,TABLEEDIT_DATA)
% Buffer Row range
  tableedit_db_DataBufRange(WINDOW,INTEGER FromRow,INTEGER ToRow)
% GridAnswer 
  tableedit_db_AnswerRange(WINDOW,INTEGER FromRow,INTEGER ToRow,INTEGER FromLolumn,INTEGER ToColumn)
% Filtered data (invisible)
  tableedit_db_ShadowData_Info(WINDOW,TABLEEDIT_DATA)
% Table properties
  tableedit_db_Te_Info(WINDOW,TABLEEDIT_PROPERTY)
% Column properties
  tableedit_db_Col_Info(WINDOW,INTEGER Ncolumn,TABLEEDIT_COLUMNPROPERTY)
% Data for undo
  tableedit_db_UndoData(WINDOW,TABLEEDIT_UNDOREDOLIST)
% Data for redo
  tableedit_db_RedoData(WINDOW,TABLEEDIT_UNDOREDOLIST)
% Current UndoRedo action
  tableedit_db_CurrentUndoRedo(WINDOW,TABLEEDIT_UNDOREDOLIST)
% Paste cannot be carried out (Not conformity of a clipboard data format to table format)
  tableedit_db_PasteError(WINDOW)
% Initialization is current action
  tableedit_db_InitMode(WINDOW)
% Undo,redo is current action
  tableedit_db_UndoAction(WINDOW)
% Find param
  tableedit_db_FindParam(WINDOW,STRING,TABLEEDIT_DIRECTION,INTEGER Column,TABLEEDIT_MATCH,BOOLEAN CaseSensitive)
% Find Dialog param
  tableedit_db_FindDlgParam(WINDOW,INTEGER ColumnId,INTEGER ColumnItemId)
% exist V Scroll
  tableedit_db_VScroll(WINDOW)

  determ tableedit_str_buffer(STRING)
  determ tableedit_db_Stopmodified(WINDOW)

predicates
% Grid callback
  tableedit_GridCallback : GRID_CALLBACK		% Grid Callback
% Internal table editor callback
  tableedit_CallbackInternal : TABLEEDIT_CALLBACK	% table editor internal dummy callback
% Table editor callback
  tableedit_SendCallback : TABLEEDIT_CALLBACK      
% Internal table editor compare function
  tableedit_CompareInternal : TABLEEDIT_COMPARE		% table editor internal dummy comparation

% Set data to table editor (without sorting)
  procedure  tableedit_SetAllDataNoSort(WINDOW,TABLEEDIT_DATA)
% grid initialization
  determ  tableedit_Grid_Init(WINDOW,TABLEEDIT_DATA)
% number columns calculation 
  procedure  tableedit_CalcMaxCol(WINDOW,INTEGER MaxColumn)
% number rows calculation
  procedure  tableedit_CalcMaxRows(WINDOW,TABLEEDIT_DATA,INTEGER MaxRows)
  procedure  tableedit_CalcMaxCol1(WINDOW,INTEGER,INTEGER MaxColumn)

  determ  tableedit_listlength(TABLEEDIT_DATA,INTEGER)
%  determ  tableedit_listlength(TABLEEDIT_COLUMNDATA,INTEGER)

% GRID_CELLS_STYLE to TABLEEDIT_PROPERTY format data transformation
  determ  tableedit_ConvGridCellsStyle(GRID_CELLS_STYLE,TABLEEDIT_PROPERTY)

% Table editor initialization with table parameters by default
  procedure  tableedit_InitDefaultEditor(WINDOW)
% assert table property
  procedure  tableedit_AssertPropertyList(WINDOW,TABLEEDIT_PROPERTIES)
  procedure  tableedit_ReAssertPropertyList(WINDOW,TABLEEDIT_PROPERTIES)
  procedure  tableedit_ReAssert(WINDOW,TABLEEDIT_PROPERTY)

% assert column property
  determ  tableedit_InitColumns(WINDOW,INTEGER Column,TABLEEDIT_COLUMNLIST)
  procedure  tableedit_InitColumn(WINDOW,INTEGER Column,TABLEEDIT_COLUMNPROPERTIES)
  procedure  tableedit_ReAssertColumn(WINDOW,INTEGER Column,TABLEEDIT_COLUMNPROPERTY)

  determ  tableedit_CreateGridColumnList(WINDOW,GRID_COLUMNSTYLE)
  determ  tableedit_BuildGridColumns(WINDOW,INTEGER Ncolumn,GRID_COLUMN_LIST,GRID_COLUMN_LIST)
  determ  tableedit_BuildGridColumn(WINDOW,INTEGER Ncolumn,GRID_COLUMN)
  determ  tableedit_Append(GRID_COLUMN_LIST,GRID_COLUMN_LIST,GRID_COLUMN_LIST)
  determ  tableedit_Append(MENU_ITEM_LIST,MENU_ITEM_LIST,MENU_ITEM_LIST)

% Get GRID_STYLE format data from table editor properties
  determ  tableedit_GetGridStyle(WINDOW,GRID_STYLE)

% Table editor data sorting
  determ  tableedit_sort_data(WINDOW,TABLEEDIT_COMPARE ComareFunc,BOOLEAN Ascendig,ILIST ColumnNumber,TABLEEDIT_DATA,TABLEEDIT_DATA)

% Insert default row
  procedure  tableedit_InsDefRow(WINDOW,INTEGER Row)
% Create default row
  determ  tableedit_CreateDefRow(WINDOW,INTEGER,TABLEEDIT_COLUMNDATA,TABLEEDIT_COLUMNDATA)

% Create void rows
  determ  tableedit_CreateVoidRows(WINDOW,INTEGER,TABLEEDIT_DATA,TABLEEDIT_DATA)

  determ  tableedit_InsDefRowZ(WINDOW)

% Cut rows from list
  determ  tableedit_CutListRows(WINDOW,INTEGER FromRow,INTEGER ToRow,
  	TABLEEDIT_DATA Input,TABLEEDIT_DATA Empty,TABLEEDIT_DATA Out,
  	TABLEEDIT_DATA Empty,TABLEEDIT_DATA CutData)

% Insert rows to list
  determ  tableedit_InsListRows(WINDOW,INTEGER FrRow,TABLEEDIT_DATA,TABLEEDIT_DATA,
  	TABLEEDIT_DATA,TABLEEDIT_DATA) 

% Cut header and footer rows from list
  procedure  tableedit_CutHeadersFooters(WINDOW,TABLEEDIT_DATA Data,TABLEEDIT_DATA OutData,
  	TABLEEDIT_DATA HeadData,TABLEEDIT_DATA FootData)

% Insert header and footer rows to list
  procedure  tableedit_InsHeadersFooters(WINDOW,TABLEEDIT_DATA Data,TABLEEDIT_DATA OutData,
	TABLEEDIT_DATA HeadData,TABLEEDIT_DATA FootData)

% Cliar undo and redo data
  procedure  tableedit_CliarUndoRedoData(WINDOW)

% Check up a clipboard string on compatibility with a type of table editor data
  determ  tableedit_ChkClipBoardStr(WINDOW,GRID_AREALIST,STRING SourceStr,BOOLEAN)

% To carry out a filtration according to current filters
  determ  tableedit_ProcessFilter(WINDOW)
  procedure  tableedit_CurWait(WINDOW,BOOLEAN WaitCursor)


clauses

  tableedit_CurWait(Win,b_true):- 
	cursor_Set(Win,cursor_Wait),
	!.
  tableedit_CurWait(Win,_):-
	cursor_Set(Win,cursor_Arrow),
	!.

% Internal table editor callback
  tableedit_CallbackInternal(_Win,_Event):- fail.

% data to data,footer data,header data convertion
  tableedit_CutHeadersFooters(Win,Data,Data,[],[]):-
	tableedit_db_Te_Info(Win,headers(0)),
	tableedit_db_Te_Info(Win,footers(0)),
	!.
  tableedit_CutHeadersFooters(Win,Data,OutData,HeadData,FootData):-
	tableedit_db_Te_Info(Win,headers(H)),
	tableedit_db_Te_Info(Win,footers(F)),
	tableedit_CutListRows(Win,1,H,Data,[],OutData1,[],HeadData),
	tableedit_CalcMaxRows(Win,OutData1,MaxRows), FootPos = MaxRows - F + 1,
	tableedit_CutListRows(Win,FootPos,MaxRows,OutData1,[],OutData,[],FootData),
	!.
  tableedit_CutHeadersFooters(_,Data,Data,[],[]).

% data,footer data,header data to data convertion
  tableedit_InsHeadersFooters(Win,Data,Data,_HeadData,_FootData):-
	tableedit_db_Te_Info(Win,headers(0)),
	tableedit_db_Te_Info(Win,footers(0)),
	!.
  tableedit_InsHeadersFooters(Win,Data,OutData,HeadData,FootData):-
	tableedit_InsListRows(Win,0,HeadData,Data,[],OutData1),
	tableedit_CalcMaxRows(Win,OutData1,MaxRows), FootPos = MaxRows + 1,
	tableedit_InsListRows(Win,FootPos,FootData,OutData1,[],OutData),
	!.
  tableedit_InsHeadersFooters(_Win,Data,Data,_HeadData,_FootData):-!.

predicates
procedure tableedit_AssertStartData(WINDOW,TABLEEDIT_DATA)
procedure tableedit_RequestBuff(WINDOW,INTEGER FromRow)
procedure tableedit_RequestBuff(WINDOW,INTEGER FromRow,INTEGER ToRow)
procedure tableedit_GetBuffCellData(WINDOW,INTEGER Row,INTEGER Column,TABLEEDIT_CELLDATA)
procedure tableedit_SeparateAnswer(WINDOW)
procedure tableedit_HandleBuffAnswer(WINDOW)
procedure tableedit_HandleBuffAnswer1(WINDOW,INTEGER FromRow,INTEGER ToRow,INTEGER FromColumn,INTEGER ToColumn)
procedure  tableedit_BuffInvalidate(WINDOW)
procedure  tableedit_BuffInvalidate(WINDOW,INTEGER Row)

clauses

  tableedit_Grid_Init(Win,InputData):-
	tableedit_db_Te_Info(Win,bufferingmode(nobuffering)),
	tableedit_GetGridStyle(Win,GridStyle),
	tableedit_CalcMaxRows(Win,InputData,MaxRows),
	tableedit_db_Te_Info(Win,rowselector(RowSelector,RowWidth,M)),
	GridRowStyle = grid_rowstyle(RowWidth,MaxRows,1,RowSelector,M),	
	tableedit_CreateGridColumnList(Win,GridColumnStyle),
	tableedit_ProcessFilter(Win),
	tableedit_db_Te_Info(Win,sortedby(Col)),
	tableedit_Sort(Win,Col),
	grid_Init(Win,GridStyle,GridRowStyle,
	GridColumnStyle,
	tableedit_GridCallback),
	retractAll(tableedit_db_InitMode(Win)),
	!.
  tableedit_Grid_Init(Win,_InputData):-
	tableedit_db_Te_Info(Win,bufferingmode(buffering(_AnsFunc,_RowBuffSize,MaxRows))),
	tableedit_GetGridStyle(Win,GridStyle),
	tableedit_db_Te_Info(Win,rowselector(RowSelector,RowWidth,M)),
	GridRowStyle = grid_rowstyle(RowWidth,MaxRows,1,RowSelector,M),	
	tableedit_CreateGridColumnList(Win,GridColumnStyle),
	grid_Init(Win,GridStyle,GridRowStyle,
	GridColumnStyle,
	tableedit_GridCallback),
	retractAll(tableedit_db_InitMode(Win)),
	!.

% table properties to grid style convertion
  tableedit_GetGridStyle(Win,GridStyle):-
	tableedit_db_Te_Info(Win,raised(R)),
	tableedit_ConvGridCellsStyle(Cells_Style,raised(R)),
	tableedit_db_Te_Info(Win,backcolor(BackColor)),
	tableedit_db_Te_Info(Win,emptycolor(EmptyCellColor)),
	tableedit_db_Te_Info(Win,titlebackcolor(BackTitleColor)),
	tableedit_db_Te_Info(Win,titleforecolor(ForeTitleColor)),
	tableedit_db_Te_Info(Win,defcellcolor(DefaultCellColor)),
	GridStyle = grid_Style(Cells_Style,DefaultCellColor,BackColor,EmptyCellColor,
		BackTitleColor,ForeTitleColor),
	!.

% table properties to Grid Column Style convertion
  tableedit_CreateGridColumnList(Win,GridColumnStyle):-
	tableedit_BuildGridColumns(Win,1,[],ColList),
	tableedit_db_Te_Info(Win,nonscrollcol(NonScroll)),
	GridColumnStyle = grid_columnstyle(NonScroll,ColList),
	!.
% Create grid column list from table properties
  tableedit_BuildGridColumns(Win,Ncolumn,InColumns,Columns):-
	tableedit_BuildGridColumn(Win,Ncolumn,GridCol),
	tableedit_Append(InColumns,[GridCol],OutColumns),
	NextCol = Ncolumn + 1,
	tableedit_BuildGridColumns(Win,NextCol,OutColumns,Columns),!.
  tableedit_BuildGridColumns(_,_,GridColumns,GridColumns):-!.

% table properties to grid column format converion
  tableedit_BuildGridColumn(Win,Ncolumn,GridCol):-
	tableedit_db_Col_Info(Win,Ncolumn,title(Title)),
	tableedit_db_Col_Info(Win,Ncolumn,width(Width)),
	tableedit_db_Col_Info(Win,Ncolumn,alignment(HorAlignment)),
	tableedit_db_Col_Info(Win,Ncolumn,maxlength(Length)),
	GridCol = grid_col(Title,Width,HorAlignment,grid_top_align,4,0,Length),
	!.

  tableedit_Append([],L,L).	
  tableedit_Append([N|L1],L2,[N|L3]):-
	tableedit_Append(L1,L2,L3).	

% number of columns calculation
  tableedit_CalcMaxCol(Win,Col):- tableedit_CalcMaxCol1(Win,1,Col),!.

  tableedit_CalcMaxCol1(Win,Col,ColRes):- 
	not(tableedit_db_Col_Info(Win,Col,_)),ColRes = Col - 1,!.
  tableedit_CalcMaxCol1(Win,Col,NC):-!,
	NextCol = Col + 1,
	tableedit_CalcMaxCol1(Win,NextCol,NC).

% number of rows calculation
  tableedit_CalcMaxRows(Win,Data,MaxRows):-
	tableedit_db_Te_Info(Win,bufferingmode(nobuffering)),
	tableedit_listlength(Data,MaxRows),!.
  tableedit_CalcMaxRows(Win,_Data,MaxRows):-
	tableedit_db_Te_Info(Win,bufferingmode(buffering(_AnsFunc,_RowBuffSize,MaxRows))),!.
  tableedit_CalcMaxRows(_Win,_,0):-!.

  tableedit_listlength([],0):-!.
  tableedit_listlength([_|T],N1):-
	tableedit_listlength(T,N),
	N1=N+1.


% Table editor initialization with table parameters by default
  tableedit_InitDefaultEditor(Win):-
	tableedit_AssertPropertyList(Win,
			[raised(b_true),
			defcellcolor(color_LtGray),
			backcolor(color_Gray),
			emptycolor(color_LtGray),
			titlebackcolor(color_LtGray),
			titleforecolor(color_Black),
			rowselector(grid_number,50,b_false),
			nonscrollcol(0),
			sortedby(1),
			allmarker(b_false),
			areamarker(singular),
			colmarker(none),
			rowmarker(singular),
			insert_rows(b_true),
			delete_rows(b_true),
			undo_redo(b_true),
			paste(b_true),
			cut(b_true),
			menu([]),
		     	headers(0),
		     	footers(0),
			filter(b_true),
			readonly(b_false),
			callback(tableedit_CallbackInternal),
			compare(tableedit_CompareInternal),
			find(b_true),
			bufferingmode(nobuffering)
			]),
	!.

  tableedit_AssertPropertyList(_Win,[]):-!.
  tableedit_AssertPropertyList(Win,[L1|L2]):-!,
	assert(tableedit_db_Te_Info(Win,L1)),
	tableedit_AssertPropertyList(Win,L2).
  tableedit_AssertPropertyList(_Win,_):-!.

  tableedit_ReAssertPropertyList(_Win,[]):-!.
  tableedit_ReAssertPropertyList(Win,[L1|L2]):-!,
	tableedit_ReAssert(Win,L1),
	tableedit_ReAssertPropertyList(Win,L2).
  tableedit_ReAssertPropertyList(_Win,_):-!.

% Table editor initialization with column parameters by default
  tableedit_InitColumns(_Win,_,[]):-!.
  tableedit_InitColumns(Win,NCol,[L1|L2]):-
	NextCol = NCol + 1,
	L1 = column(ColumnProp),
	tableedit_db_Te_Info(Win,readonly(R)),
	tableedit_InitColumn(Win,NextCol,[readonly(R)]),
	tableedit_db_Te_Info(Win,filter(F)),
	tableedit_InitColumn(Win,NextCol,[filter(F)]),
	tableedit_InitColumn(Win,NextCol,
			[title(""),
			width(100),
			backcolor(color_LtGray),
			forecolor(color_Black),
			alignment(grid_right_align),
			maxlength(0x7FFF),
			resizable(b_true),
			sortmode(ascending([])),
			filterlist([]),
			defaultvalue(void),
			validationrule([]),
			validationtext(""),
			column_type(te_string),
			control(edit),
			mandatory(b_false)
			]),
	tableedit_InitColumn(Win,NextCol,ColumnProp),!,
	tableedit_InitColumns(Win,NextCol,L2).

  tableedit_InitColumn(_Win,_,[]):-!.
  tableedit_InitColumn(Win,NextCol,[L1|L2]):-!,
	tableedit_ReAssertColumn(Win,NextCol,L1),
	tableedit_InitColumn(Win,NextCol,L2).
  tableedit_InitColumn(_Win,_,_):-!.
	
  tableedit_ReAssertColumn(Win,NextCol,filterlist(FL)):-
	retractAll(tableedit_db_Col_Info(Win,NextCol,filterlist(_))),
	assert(tableedit_db_Col_Info(Win,NextCol,filterlist(FL))),!.
  tableedit_ReAssertColumn(Win,NextCol,filter(F)):-
	retractAll(tableedit_db_Col_Info(Win,NextCol,filter(_))),
	assert(tableedit_db_Col_Info(Win,NextCol,filter(F))),!.
  tableedit_ReAssertColumn(Win,NextCol,mandatory(M)):-
	retractAll(tableedit_db_Col_Info(Win,NextCol,mandatory(_))),
	assert(tableedit_db_Col_Info(Win,NextCol,mandatory(M))),!.
  tableedit_ReAssertColumn(Win,NextCol,control(C)):-
	retractAll(tableedit_db_Col_Info(Win,NextCol,control(_))),
	assert(tableedit_db_Col_Info(Win,NextCol,control(C))),!.
  tableedit_ReAssertColumn(Win,NextCol,column_type(T)):-
	retractAll(tableedit_db_Col_Info(Win,NextCol,column_type(_))),
	assert(tableedit_db_Col_Info(Win,NextCol,column_type(T))),!.
  tableedit_ReAssertColumn(Win,NextCol,title(T)):-
	retractAll(tableedit_db_Col_Info(Win,NextCol,title(_))),
	assert(tableedit_db_Col_Info(Win,NextCol,title(T))),!.
  tableedit_ReAssertColumn(Win,NextCol,width(W)):-
	retractAll(tableedit_db_Col_Info(Win,NextCol,width(_))),
	assert(tableedit_db_Col_Info(Win,NextCol,width(W))),!.
  tableedit_ReAssertColumn(Win,NextCol,backcolor(C)):-
	retractAll(tableedit_db_Col_Info(Win,NextCol,backcolor(_))),
	assert(tableedit_db_Col_Info(Win,NextCol,backcolor(C))),!.
  tableedit_ReAssertColumn(Win,NextCol,forecolor(C)):-
	retractAll(tableedit_db_Col_Info(Win,NextCol,forecolor(_))),
	assert(tableedit_db_Col_Info(Win,NextCol,forecolor(C))),!.
  tableedit_ReAssertColumn(Win,NextCol,alignment(A)):-
	retractAll(tableedit_db_Col_Info(Win,NextCol,alignment(_))),
	assert(tableedit_db_Col_Info(Win,NextCol,alignment(A))),!.
  tableedit_ReAssertColumn(Win,NextCol,readonly(R)):-
	retractAll(tableedit_db_Col_Info(Win,NextCol,readonly(_))),
	assert(tableedit_db_Col_Info(Win,NextCol,readonly(R))),!.
  tableedit_ReAssertColumn(Win,NextCol,resizable(R)):-
	retractAll(tableedit_db_Col_Info(Win,NextCol,resizable(_))),
	assert(tableedit_db_Col_Info(Win,NextCol,resizable(R))),!.
  tableedit_ReAssertColumn(Win,NextCol,sortmode(S)):-
	retractAll(tableedit_db_Col_Info(Win,NextCol,sortmode(_))),
	assert(tableedit_db_Col_Info(Win,NextCol,sortmode(S))),!.
  tableedit_ReAssertColumn(Win,NextCol,defaultvalue(D)):-
	retractAll(tableedit_db_Col_Info(Win,NextCol,defaultvalue(_))),
	assert(tableedit_db_Col_Info(Win,NextCol,defaultvalue(D))),!.
  tableedit_ReAssertColumn(Win,NextCol,validationrule(V)):-
	retractAll(tableedit_db_Col_Info(Win,NextCol,validationrule(_))),
	assert(tableedit_db_Col_Info(Win,NextCol,validationrule(V))),!.
  tableedit_ReAssertColumn(Win,NextCol,validationtext(T)):-
	retractAll(tableedit_db_Col_Info(Win,NextCol,validationtext(_))),
	assert(tableedit_db_Col_Info(Win,NextCol,validationtext(T))),!.
  tableedit_ReAssertColumn(Win,NextCol,maxlength(Value)):-
	retractAll(tableedit_db_Col_Info(Win,NextCol,maxlength(_))),
	assert(tableedit_db_Col_Info(Win,NextCol,maxlength(Value))),!.
  tableedit_ReAssertColumn(_Win,_,_).

  tableedit_ReAssert(Win,defcellcolor(C)):-
	retractAll(tableedit_db_Te_Info(Win,defcellcolor(_))),
	assert(tableedit_db_Te_Info(Win,defcellcolor(C))),!.
  tableedit_ReAssert(Win,areamarker(M)):-
	retractAll(tableedit_db_Te_Info(Win,areamarker(_))),
	assert(tableedit_db_Te_Info(Win,areamarker(M))),!.
  tableedit_ReAssert(Win,cut(C)):-
	retractAll(tableedit_db_Te_Info(Win,cut(_))),
	assert(tableedit_db_Te_Info(Win,cut(C))),!.
  tableedit_ReAssert(Win,paste(P)):-
	retractAll(tableedit_db_Te_Info(Win,paste(_))),
	assert(tableedit_db_Te_Info(Win,paste(P))),!.
  tableedit_ReAssert(Win,undo_redo(UR)):-
	retractAll(tableedit_db_Te_Info(Win,undo_redo(_))),
	assert(tableedit_db_Te_Info(Win,undo_redo(UR))),!.
  tableedit_ReAssert(Win,filter(F)):-
	retractAll(tableedit_db_Te_Info(Win,filter(_))),
	assert(tableedit_db_Te_Info(Win,filter(F))),!.
  tableedit_ReAssert(Win,raised(R)):-
	retractAll(tableedit_db_Te_Info(Win,raised(_))),
	assert(tableedit_db_Te_Info(Win,raised(R))),!.
  tableedit_ReAssert(Win,headers(H)):-
	retractAll(tableedit_db_Te_Info(Win,headers(_))),
	assert(tableedit_db_Te_Info(Win,headers(H))),!.
  tableedit_ReAssert(Win,footers(F)):-
	retractAll(tableedit_db_Te_Info(Win,footers(_))),
	assert(tableedit_db_Te_Info(Win,footers(F))),!.
  tableedit_ReAssert(Win,backcolor(Col)):-
	retractAll(tableedit_db_Te_Info(Win,backcolor(_))),
	assert(tableedit_db_Te_Info(Win,backcolor(Col))),!.
  tableedit_ReAssert(Win,emptycolor(Col)):-
	retractAll(tableedit_db_Te_Info(Win,emptycolor(_))),
	assert(tableedit_db_Te_Info(Win,emptycolor(Col))),!.
  tableedit_ReAssert(Win,titlebackcolor(Col)):-
	retractAll(tableedit_db_Te_Info(Win,titlebackcolor(_))),
	assert(tableedit_db_Te_Info(Win,titlebackcolor(Col))),!.
  tableedit_ReAssert(Win,titleforecolor(Col)):-
	retractAll(tableedit_db_Te_Info(Win,titleforecolor(_))),
	assert(tableedit_db_Te_Info(Win,titleforecolor(Col))),!.
  tableedit_ReAssert(Win,rowselector(Row_Sel,W,M)):-
	retractAll(tableedit_db_Te_Info(Win,rowselector(_,_,_))),
	assert(tableedit_db_Te_Info(Win,rowselector(Row_Sel,W,M))),!.
  tableedit_ReAssert(Win,nonscrollcol(NColumn)):-
	retractAll(tableedit_db_Te_Info(Win,nonscrollcol(_))),
	assert(tableedit_db_Te_Info(Win,nonscrollcol(NColumn))),!.
  tableedit_ReAssert(Win,sortedby(Col)):-
	retractAll(tableedit_db_Te_Info(Win,sortedby(_))),
	assert(tableedit_db_Te_Info(Win,sortedby(Col))),!.
  tableedit_ReAssert(Win,allmarker(Mark)):-
	retractAll(tableedit_db_Te_Info(Win,allmarker(_))),
	assert(tableedit_db_Te_Info(Win,allmarker(Mark))),!.
  tableedit_ReAssert(Win,colmarker(Mark)):-
	retractAll(tableedit_db_Te_Info(Win,colmarker(_))),
	assert(tableedit_db_Te_Info(Win,colmarker(Mark))),!.
  tableedit_ReAssert(Win,rowmarker(Mark)):-
	retractAll(tableedit_db_Te_Info(Win,rowmarker(_))),
	assert(tableedit_db_Te_Info(Win,rowmarker(Mark))),!.
  tableedit_ReAssert(Win,insert_rows(Row)):-
	retractAll(tableedit_db_Te_Info(Win,insert_rows(_))),
	assert(tableedit_db_Te_Info(Win,insert_rows(Row))),!.
  tableedit_ReAssert(Win,delete_rows(Row)):-
	retractAll(tableedit_db_Te_Info(Win,delete_rows(_))),
	assert(tableedit_db_Te_Info(Win,delete_rows(Row))),!.
  tableedit_ReAssert(Win,menu(M)):-
	retractAll(tableedit_db_Te_Info(Win,menu(_))),
	assert(tableedit_db_Te_Info(Win,menu(M))),!.
  tableedit_ReAssert(Win,readonly(R)):-
	retractAll(tableedit_db_Te_Info(Win,readonly(_))),
	assert(tableedit_db_Te_Info(Win,readonly(R))),!.
  tableedit_ReAssert(Win,callback(CB)):-
	retractAll(tableedit_db_Te_Info(Win,callback(_))),
	assert(tableedit_db_Te_Info(Win,callback(CB))),!.
  tableedit_ReAssert(Win,compare(CO)):-
	retractAll(tableedit_db_Te_Info(Win,compare(_))),
	assert(tableedit_db_Te_Info(Win,compare(CO))),!.
  tableedit_ReAssert(Win,find(F)):-
	retractAll(tableedit_db_Te_Info(Win,find(_))),
	assert(tableedit_db_Te_Info(Win,find(F))),!.
  tableedit_ReAssert(Win,bufferingmode(Buf)):-
	retractAll(tableedit_db_Te_Info(Win,bufferingmode(_))),
	assert(tableedit_db_Te_Info(Win,bufferingmode(Buf))),!.
  tableedit_ReAssert(_Win,_).

  tableedit_ConvGridCellsStyle(grid_raised,raised(b_true)):-!.
  tableedit_ConvGridCellsStyle(grid_plain,raised(b_false)):-!.

predicates
% Get possibility for Undo action
  procedure  tableedit_GetPossibilityUndo(WINDOW,BOOLEAN PossUndo) - (i,o)
% Get possibility for Redo action
  procedure tableedit_GetPossibilityRedo(WINDOW,BOOLEAN PossRedo) - (i,o)
% Assert action to UndoRedo actions list
  procedure tableedit_UpdateUndoRedoModified(WINDOW,TABLEEDIT_EVENT)
% Undo actin
  procedure tableedit_Undo(WINDOW)
% Redo actin
  procedure tableedit_Redo(WINDOW)
% Set data to table editor with the notice on modifying
  procedure tableedit_SetDataSendCallback(WINDOW,INTEGER FrRow,INTEGER ToRow,
				INTEGER FRColumn,INTEGER ToColumn,TABLEEDIT_DATA InData)
% Set clipboard format data to table editor with the notice on modifying
  procedure tableedit_SetRowDataSendCallback(WINDOW,GRID_AREALIST,STRING SourceStr)

  procedure tableedit_ResetCurrentUndoRedoData(WINDOW,TABLEEDIT_UNDOREDOLIST)

  determ  tableedit_InsRows(WINDOW,INTEGER Row,TABLEEDIT_DATA InsData)

clauses
  tableedit_ResetCurrentUndoRedoData(Win,URData):-
	retractAll(tableedit_db_CurrentUndoRedo(Win,_)),
	assert(tableedit_db_CurrentUndoRedo(Win,URData)),
	!. 

  tableedit_SendCallback(Win,Event):-
	tableedit_db_Te_Info(Win,callback(CBack)),
	not(CBack(Win,Event)),!,
	tableedit_UpdateUndoRedoModified(Win,Event),fail.
  tableedit_SendCallback(_Win,_Event):-!.

  tableedit_CliarUndoRedoData(Win):-
	retractAll(tableedit_db_CurrentUndoRedo(Win,_)),
	retractAll(tableedit_db_UndoData(Win,_)),
	retractAll(tableedit_db_RedoData(Win,_)),!.

predicates
procedure  tableedit_assertUndoRedo(WINDOW,TABLEEDIT_UNDOREDOLIST)
clauses

  tableedit_assertUndoRedo(Win,UR):-
	trap(asserta(tableedit_db_UndoData(Win,UR)),_,fail),!.
  tableedit_assertUndoRedo(Win,_UR):-
	tableedit_CliarUndoRedoData(Win),!.
  tableedit_assertUndoRedo(_Win,_UR):-!.
predicates
procedure tableedit_convertEditMarker(GRID_MARKER In,GRID_MARKER Out)
clauses

  tableedit_convertEditMarker(InMark,OutMark):-
	InMark = grid_edit_cell(Row,Col),
	OutMark = grid_area_marker([ga(Row,Row,Col,Col)]),
	!.
  tableedit_convertEditMarker(Mark,Mark).

  tableedit_UpdateUndoRedoModified(Win,Event):-
	tableedit_db_Te_Info(Win,bufferingmode(nobuffering())),
	tableedit_db_Te_Info(Win,undo_redo(b_true)),
	not(tableedit_db_UndoAction(Win)),
	Event = marker(Marker,b_false),
	not(Marker = grid_edit_cell(_,_)),
	retractAll(tableedit_db_RedoData(Win,_)),
	UR = [marker(Marker)],
	tableedit_assertUndoRedo(Win,UR),!.
  tableedit_UpdateUndoRedoModified(Win,Event):-
	tableedit_db_Te_Info(Win,bufferingmode(nobuffering())),
	tableedit_db_Te_Info(Win,undo_redo(b_true)),
	not(tableedit_db_UndoAction(Win)),
	Event = modified(Row,Column,CellData,NewValue),
	grid_Marker(Win,Marker),
	tableedit_convertEditMarker(Marker,OutMarker),
	retractAll(tableedit_db_RedoData(Win,_)),
	UR = [marker(OutMarker),modified(Row,Column,CellData,NewValue)],
	tableedit_assertUndoRedo(Win,UR),!.
  tableedit_UpdateUndoRedoModified(Win,Event):-
	tableedit_db_Te_Info(Win,bufferingmode(nobuffering())),
	tableedit_db_Te_Info(Win,undo_redo(b_true)),
	not(tableedit_db_UndoAction(Win)),
	Event = insert_row(Row,NewValue),
	grid_Marker(Win,Marker),
	retractAll(tableedit_db_RedoData(Win,_)),
	UR = [marker(Marker),row(Row,[],NewValue)],
	tableedit_assertUndoRedo(Win,UR),!.
  tableedit_UpdateUndoRedoModified(Win,Event):-
	tableedit_db_Te_Info(Win,bufferingmode(nobuffering())),
	tableedit_db_Te_Info(Win,undo_redo(b_true)),
	not(tableedit_db_UndoAction(Win)),
	Event = delete_row(Row,OldData),
	grid_Marker(Win,Marker),
	retractAll(tableedit_db_RedoData(Win,_)),
	UR = [marker(Marker),row(Row,OldData,[])],
	tableedit_assertUndoRedo(Win,UR),!.
  tableedit_UpdateUndoRedoModified(Win,Event):-
	tableedit_db_Te_Info(Win,bufferingmode(nobuffering())),
	tableedit_db_Te_Info(Win,undo_redo(b_true)),
	not(tableedit_db_UndoAction(Win)),
	Event = action(ACT), ACT = resize_column(Column,Width),
	grid_Marker(Win,Marker),
	retractAll(tableedit_db_RedoData(Win,_)),
	UR = [marker(Marker),resize_column(Column,Width)],
	tableedit_assertUndoRedo(Win,UR),!.
  tableedit_UpdateUndoRedoModified(_,_).

predicates
% remove action from undo list
  procedure tableedit_DelUndoData(WINDOW,TABLEEDIT_UNDOREDOLIST  Removedaction)
% remove action from redo list
  procedure tableedit_DelRedoData(WINDOW,TABLEEDIT_UNDOREDOLIST Removedaction)
% add action to undo list
  procedure tableedit_AddUndoData(WINDOW,TABLEEDIT_UNDOREDOLIST Action)
% add action to redo list
  procedure tableedit_AddRedoData(WINDOW,TABLEEDIT_UNDOREDOLIST Action)
% get undo action
  procedure tableedit_GetUndoData(WINDOW,TABLEEDIT_UNDOREDOLIST Action)
% get redo action
  procedure tableedit_GetRedoData(WINDOW,TABLEEDIT_UNDOREDOLIST Action)
% get marker from UndRedo action
  procedure tableedit_GetUndoRedoMarker(TABLEEDIT_UNDOREDOLIST,TABLEEDIT_UNDOREDOLIST)
% Carry out undo action
  procedure tableedit_SetUndoData(WINDOW,TABLEEDIT_UNDOREDOLIST)
% Carry out redo action
  procedure tableedit_SetRedoData(WINDOW,TABLEEDIT_UNDOREDOLIST)
% Set marker from UndoRedo action
  procedure tableedit_SetNewUndoRedoMarker(WINDOW,GRID_MARKER)
% send ACTION callback
  determ  tableedit_SendCallbackForAction(WINDOW,GRID_USER_ACTION)

  determ tableedit_member(TABLEEDIT_UNDOREDODATA,TABLEEDIT_UNDOREDOLIST)
  determ tableedit_member(TABLEEDIT_COLUMNPROPERTY,TABLEEDIT_COLUMNPROPERTIES)
  determ tableedit_member(TABLEEDIT_PROPERTY,TABLEEDIT_PROPERTIES)

  procedure tableedit_DeleteRowsSendCallback(WINDOW,GRID_LINELIST)

clauses
  tableedit_member(S,[S|_]):-!.
  tableedit_member(S,[_|L]):-
	tableedit_member(S,L).

  tableedit_DelUndoData(Win,UndoData):-retract(tableedit_db_UndoData(Win,UndoData)),!.
  tableedit_DelUndoData(_Win,_UndoData):-!.
  
  tableedit_DelRedoData(Win,RedoData):-retract(tableedit_db_RedoData(Win,RedoData)),!.
  tableedit_DelRedoData(_Win,_RedoData):-!.
  
  tableedit_AddUndoData(Win,UndoData):-asserta(tableedit_db_UndoData(Win,UndoData)),!.

  tableedit_AddRedoData(Win,RedoData):-asserta(tableedit_db_RedoData(Win,RedoData)),!.

  tableedit_GetUndoData(Win,UndoData):-tableedit_db_UndoData(Win,UndoData),!.
  tableedit_GetUndoData(_Win,[]):-!.

  tableedit_GetRedoData(Win,RedoData):-tableedit_db_RedoData(Win,RedoData),!.
  tableedit_GetRedoData(_Win,[]):-!.
  
  tableedit_GetUndoRedoMarker(URData,M):-
	tableedit_member(marker(Marker),URData), M = [marker(Marker)],!.
  tableedit_GetUndoRedoMarker(_URData,[]):-!. 

  tableedit_SetNewUndoRedoMarker(Win,NewMarker):-
	grid_Marker(Win,Marker), 
	not(Marker = NewMarker),
	tableedit_db_Te_Info(Win,callback(CBack)),
	not(CBack(Win,marker(NewMarker,b_true))),
	grid_Marker(Win,NewMarker),
	!.
  tableedit_SetNewUndoRedoMarker(_Win,_NewMarker):-!.

  tableedit_SetUndoData(Win,UndoData):-
	tableedit_member(modified(Row,Column,OldValue,_NewValue),UndoData),
	tableedit_SetDataSendCallback(Win,Row,Row,Column,Column,[[OldValue]]),fail.
  tableedit_SetUndoData(Win,UndoData):-
	tableedit_member(marker(Marker),UndoData),
	tableedit_SetNewUndoRedoMarker(Win,Marker),fail.
  tableedit_SetUndoData(Win,UndoData):-
	tableedit_member(row(Row,[],_NewData),UndoData),
	tableedit_DeleteRowsSendCallback(Win,[gl(Row,Row)]),fail.
  tableedit_SetUndoData(Win,UndoData):-
	tableedit_member(row(Row,OD,[]),UndoData),
	OldData = [OD],
	tableedit_InsRows(Win,Row,OldData),fail.
  tableedit_SetUndoData(Win,UndoData):-
	tableedit_member(resize_column(Column,Width),UndoData),
	Wrevers =-Width,
	A = grid_resize_column(Column,Wrevers),
	not(tableedit_SendCallbackForAction(Win,A)),
	ColProp = tableedit_GetColumnProperties(Win,Column),
	tableedit_member(width(W),ColProp),
	OldWidth = W - Width,
	retractAll(tableedit_db_Col_Info(Win,Column,width(_))),
	assert(tableedit_db_Col_Info(Win,Column,width(OldWidth))),
	tableedit_CreateGridColumnList(Win,NewGridColumnStyle),
	grid_ColumnStyle(Win,NewGridColumnStyle),
	fail.
  tableedit_SetUndoData(_Win,_UndoData):-!.

  tableedit_SetRedoData(Win,RedoData):-
	tableedit_member(modified(Row,Column,_OldValue,NewValue),RedoData),
	tableedit_SetDataSendCallback(Win,Row,Row,Column,Column,[[NewValue]]),fail.
  tableedit_SetRedoData(Win,RedoData):-
	tableedit_member(marker(Marker),RedoData),
	tableedit_SetNewUndoRedoMarker(Win,Marker),fail.
  tableedit_SetRedoData(Win,RedoData):-
	tableedit_member(row(Row,[],NewData),RedoData),
	ND = [NewData],
	tableedit_InsRows(Win,Row,ND),fail.
  tableedit_SetRedoData(Win,RedoData):-
	tableedit_member(row(Row,_OldData,[]),RedoData),
	tableedit_DeleteRowsSendCallback(Win,[gl(Row,Row)]),fail.
  tableedit_SetRedoData(Win,RedoData):-
	tableedit_member(resize_column(Column,Width),RedoData),
	A = grid_resize_column(Column,Width),
	not(tableedit_SendCallbackForAction(Win,A)),
	ColProp = tableedit_GetColumnProperties(Win,Column),
	tableedit_member(width(W),ColProp),
	NewWidth = W + Width,
	retractAll(tableedit_db_Col_Info(Win,Column,width(_))),
	assert(tableedit_db_Col_Info(Win,Column,width(NewWidth))),
	tableedit_CreateGridColumnList(Win,NewGridColumnStyle),
	grid_ColumnStyle(Win,NewGridColumnStyle),
	fail.
  tableedit_SetRedoData(_Win,_RedoData):-!.


predicates
% Check : if UndoRedo action not yet was carried out
determ  tableedit_ChkCurrentUndoRedo(WINDOW,TABLEEDIT_UNDOREDOLIST)
clauses

  tableedit_ChkCurrentUndoRedo(Win,URData):-
	not(tableedit_db_CurrentUndoRedo(Win,URData)),
	!.
  tableedit_ChkCurrentUndoRedo(Win,URData):-
	tableedit_db_CurrentUndoRedo(Win,URData),
	tableedit_member(modified(_,_,_,_),URData),
	!.

  tableedit_Undo(Win):-
	assert(tableedit_db_UndoAction(Win)),
	tableedit_db_UndoData(Win,UndoData),
	  tableedit_GetUndoRedoMarker(UndoData,UndoMarker),
	  tableedit_DelUndoData(Win,UndoData),
	  tableedit_AddRedoData(Win,UndoData),
	  tableedit_SetUndoData(Win,UndoData),
	tableedit_ChkCurrentUndoRedo(Win,UndoData),
	tableedit_ResetCurrentUndoRedoData(Win,UndoData),
	tableedit_GetUndoData(Win,NewUndoData),
	tableedit_GetUndoRedoMarker(NewUndoData,NewUndoMarker),
	not(UndoMarker = NewUndoMarker),
	retractAll(tableedit_db_UndoAction(Win)),
	!.
  tableedit_Undo(Win):-
	retractAll(tableedit_db_UndoAction(Win)),
	!.

  tableedit_Redo(Win):-
	assert(tableedit_db_UndoAction(Win)),
	tableedit_db_RedoData(Win,RedoData),
	  tableedit_GetUndoRedoMarker(RedoData,RedoMarker),
	  tableedit_DelRedoData(Win,RedoData),
	  tableedit_AddUndoData(Win,RedoData),
	  tableedit_SetRedoData(Win,RedoData),
	tableedit_ChkCurrentUndoRedo(Win,RedoData),
	tableedit_ResetCurrentUndoRedoData(Win,RedoData),
	tableedit_GetRedoData(Win,NewRedoData),
	tableedit_GetUndoRedoMarker(NewRedoData,NewRedoMarker),
	not(RedoMarker = NewRedoMarker),
	retractAll(tableedit_db_UndoAction(Win)),
	!.
  tableedit_Redo(Win):-
	retractAll(tableedit_db_UndoAction(Win)),
	!.

  tableedit_GetPossibilityUndo(Win,b_true):-
	tableedit_db_Te_Info(Win,bufferingmode(nobuffering())),
	tableedit_db_Te_Info(Win,undo_redo(b_true)),
	tableedit_db_UndoData(Win,UndoData),
	not(UndoData = []),
	!.
  tableedit_GetPossibilityUndo(Win,b_true):-
	tableedit_db_Te_Info(Win,bufferingmode(buffering(_AnsFunc,_RowBuffSize,_MaxRows))),
	tableedit_db_Te_Info(Win,undo_redo(b_true)),
	!.
  tableedit_GetPossibilityUndo(_Win,b_false):-!.

  tableedit_GetPossibilityRedo(Win,b_true):-
	tableedit_db_Te_Info(Win,bufferingmode(nobuffering())),
	tableedit_db_Te_Info(Win,undo_redo(b_true)),
	tableedit_db_RedoData(Win,RedoData),
	not(RedoData = []),
	!.
  tableedit_GetPossibilityRedo(Win,b_true):-
	tableedit_db_Te_Info(Win,bufferingmode(buffering(_AnsFunc,_RowBuffSize,_MaxRows))),
	tableedit_db_Te_Info(Win,undo_redo(b_true)),
	!.
  tableedit_GetPossibilityRedo(_Win,b_false):-!.

domains
  BOOLEANlIST=BOOLEAN*

predicates
  determ  tableedit_HandleEvent1(WINDOW,EVENT)
% Create menu
  procedure  tableedit_CreateMenu(WINDOW,INTEGER,INTEGER)
% Get possibility for "insert row" action
  procedure  tableedit_GetPossibilityInsRow(WINDOW,INTEGER Row,BOOLEAN) 
% Get possibility for "delete row" action
  procedure  tableedit_GetPossibilityDelRow(WINDOW,BOOLEAN,GRID_LINELIST)
% Get possibility for "cut" action
  procedure  tableedit_GetPossibilityCut(WINDOW,BOOLEAN,GRID_AREALIST)
% Get possibility for "paste" action
  procedure  tableedit_GetPossibilityPaste(WINDOW,BOOLEAN,GRID_AREALIST) - (i,o,o)
% Get possibility for "copy" action
  procedure  tableedit_GetPossibilityCopy(WINDOW,BOOLEAN,GRID_AREALIST) - (i,o,o)
% Get possibility for "filter" action
  procedure  tableedit_GetPossibilityFilter(WINDOW,BOOLEAN Exclude,BOOLEAN,TABLEEDIT_FILTERS) - (i,i,o,o)
% Get possibility for "sort" action
  procedure  tableedit_GetPossibilitySort(WINDOW,BOOLEAN,INTEGER Column) - (i,o,o)
% Get possibility for "show all rows" action
  procedure  tableedit_GetPossibilityShowRow(WINDOW,BOOLEAN)
% Cell data to filter data transformation
  procedure  tableedit_CellDataToFilterData(TABLEEDIT_CELLDATA,BOOLEAN Excluding,TABLEEDIT_ORFILTERLIST)
% Get SortList from "sortmode" property
  procedure  tableedit_GetSortList(WINDOW,INTEGER Col,ILIST)
% Append custom item list to default item list
  procedure  tableedit_AppendToMenu(WINDOW,MENU_ITEM_LIST,MENU_ITEM_LIST)
% Create filter list from area list
  procedure  tableedit_CreateAreaFilter(WINDOW,BOOLEAN Exclude,GRID_AREALIST,TABLEEDIT_FILTERS)
% Create "Find" dialog
  procedure  tableedit_dlg_find_Create(WINDOW)
% Find next
  procedure  tableedit_find_next(WINDOW)

clauses
  tableedit_GetSortList(Win,Col,SortList):-
	tableedit_db_Col_Info(Win,Col,sortmode(ascending(SortList))),!.
  tableedit_GetSortList(Win,Col,SortList):-
	tableedit_db_Col_Info(Win,Col,sortmode(descending(SortList))),!.
  tableedit_GetSortList(_Win,_Col,[]):-!.


  tableedit_CellDataToFilterData(i(Val),b_false,[if_range(Val,Val)]):-!.
  tableedit_CellDataToFilterData(ic(Val,_),b_false,[if_range(Val,Val)]):-!.
  tableedit_CellDataToFilterData(l(Val),b_false,[lf_range(Val,Val)]):-!.
  tableedit_CellDataToFilterData(lc(Val,_),b_false,[lf_range(Val,Val)]):-!.
  tableedit_CellDataToFilterData(r(Val),b_false,[rf_range(Val,Val)]):-!.
  tableedit_CellDataToFilterData(rc(Val,_),b_false,[rf_range(Val,Val)]):-!.
  tableedit_CellDataToFilterData(s(Val),b_false,[s_f(Val)]):-!.
  tableedit_CellDataToFilterData(sc(Val,_),b_false,[s_f(Val)]):-!.
  tableedit_CellDataToFilterData(p(_,_,Val),b_false,[s_f(Val)]):-!.
  tableedit_CellDataToFilterData(void,b_false,[fvoid]):-!.
  tableedit_CellDataToFilterData(voidc(_),b_false,[fvoid]):-!.

  tableedit_CellDataToFilterData(i(Val),b_true,[if_not(Val)]):-!.
  tableedit_CellDataToFilterData(ic(Val,_),b_true,[if_not(Val)]):-!.
  tableedit_CellDataToFilterData(l(Val),b_true,[lf_not(Val)]):-!.
  tableedit_CellDataToFilterData(lc(Val,_),b_true,[lf_not(Val)]):-!.
  tableedit_CellDataToFilterData(r(Val),b_true,[rf_not(Val)]):-!.
  tableedit_CellDataToFilterData(rc(Val,_),b_true,[rf_not(Val)]):-!.
  tableedit_CellDataToFilterData(s(Val),b_true,[s_f_not(Val)]):-!.
  tableedit_CellDataToFilterData(p(_,_,Val),b_true,[s_f_not(Val)]):-!.
  tableedit_CellDataToFilterData(sc(Val,_),b_true,[s_f_not(Val)]):-!.
  tableedit_CellDataToFilterData(void,b_true,[fvoid_not]):-!.
  tableedit_CellDataToFilterData(voidc(_),b_true,[fvoid_not]):-!.
  tableedit_CellDataToFilterData(_,_,[]):-!.

  tableedit_GetPossibilityInsRow(Win,Row,b_true):-
	tableedit_db_Te_Info(Win,insert_rows(b_true)),
	tableedit_db_Te_Info(Win,footers(F)),
	MaxRows = tableedit_MaxVisibleRows(Win),
	Row = MaxRows - F + 1,
	tableedit_CreateDefRow(Win,1,[],DefData),
	not(tableedit_SendCallback(Win,insert_row_beg(Row,DefData))),
	!.
  tableedit_GetPossibilityInsRow(_Win,0,b_false):-!.

predicates
% Create line list from area list
  procedure  tableedit_ConvAreaToLine(GRID_AREALIST,GRID_LINELIST,GRID_LINELIST)

clauses  

  tableedit_ConvAreaToLine([],LList,LList):-!.
  tableedit_ConvAreaToLine([L1|L2],LList,OutLList):-!,
	L1 = ga(FromRow,ToRow,_,_), L = gl(FromRow,ToRow),
	tableedit_ConvAreaToLine(L2,[L | LList],OutLList).
  tableedit_ConvAreaToLine(_,_,[]):-!.

  tableedit_GetPossibilityDelRow(Win,b_true,RML):-
	tableedit_db_Te_Info(Win,delete_rows(b_true)),
	grid_Marker(Win,M), M = grid_area_marker(AML),
	tableedit_ConvAreaToLine(AML,[],RML),
	not(tableedit_SendCallback(Win,delete_row_beg(RML))),
	!.
  tableedit_GetPossibilityDelRow(Win,b_true,RML):-
	tableedit_db_Te_Info(Win,delete_rows(b_true)),
	grid_Marker(Win,M), M = grid_row_marker(RML),
	not(tableedit_SendCallback(Win,delete_row_beg(RML))),
	!.
  tableedit_GetPossibilityDelRow(Win,b_true,RML):-
	tableedit_db_Te_Info(Win,delete_rows(b_true)),
	grid_Marker(Win,M), M = grid_edit_Cell(Row,_Col), RML = [gl(Row,Row)],
	not(tableedit_SendCallback(Win,delete_row_beg(RML))),
	!.
  tableedit_GetPossibilityDelRow(_Win,b_false,[]):-!.

  tableedit_GetPossibilityShowRow(Win,b_false):-
	tableedit_db_Te_Info(Win,bufferingmode(nobuffering)),
	tableedit_db_ShadowData_Info(Win,[]),
	!.
  tableedit_GetPossibilityShowRow(Win,b_true):-
	tableedit_db_Te_Info(Win,bufferingmode(nobuffering)),
	not(tableedit_SendCallback(Win,filter_beg([]))),
	!.
  tableedit_GetPossibilityShowRow(Win,b_true):-
	tableedit_db_Te_Info(Win,bufferingmode(buffering(_AnsFunc,_RowBuffSize,_MaxRows))),
	not(tableedit_SendCallback(Win,filter_beg([]))),
	!.
  tableedit_GetPossibilityShowRow(_Win,b_false):-!.

  tableedit_GetPossibilityCut(Win,b_true,AML):-
	not(tableedit_db_Col_Info(Win,_,readonly(b_true))),
	tableedit_db_Te_Info(Win,cut(b_true)),
	grid_Marker(Win,M), M = grid_row_marker(LML),
	LML = [gl(FromRow,ToRow)],
	ToCol = tableedit_MaxCol(Win),
	AML = [ga(FromRow,ToRow,1,ToCol)],
	not(tableedit_SendCallback(Win,cut_beg(FromRow,ToRow,1,ToCol))),
	!.
  tableedit_GetPossibilityCut(Win,b_true,AML):-
	not(tableedit_db_Col_Info(Win,_,readonly(b_true))),
	tableedit_db_Te_Info(Win,cut(b_true)),
	grid_Marker(Win,M), M = grid_area_marker(AML),
	AML = [ga(FromRow,ToRow,FromCol,ToCol)],
	not(tableedit_SendCallback(Win,cut_beg(FromRow,ToRow,FromCol,ToCol))),
	!.
  tableedit_GetPossibilityCut(Win,b_true,AML):-
	not(tableedit_db_Col_Info(Win,_,readonly(b_true))),
	tableedit_db_Te_Info(Win,cut(b_true)),
	grid_Marker(Win,M), M = grid_all_marker,
	ToRow = tableedit_MaxVisibleRows(Win), ToRow >= 1,
	ToCol = tableedit_MaxCol(Win),
	AML = [ga(1,ToRow,1,ToCol)],
	not(tableedit_SendCallback(Win,cut_beg(1,ToRow,1,ToCol))),
	!.
  tableedit_GetPossibilityCut(_Win,b_false,[]):-!.

  tableedit_GetPossibilityPaste(Win,b_true,AML):-
	not(tableedit_db_Col_Info(Win,_,readonly(b_true))),
	tableedit_db_Te_Info(Win,paste(b_true)),
	grid_Marker(Win,M), M = grid_row_marker([gl(FromRow,ToRow)]),
	ToCol = tableedit_MaxCol(Win),
	AML = [ga(FromRow,ToRow,1,ToCol)],
	SourceStr = cb_GetString(),
	tableedit_ChkClipBoardStr(Win,AML,SourceStr,b_true),
	not(tableedit_SendCallback(Win,paste_beg(FromRow,ToRow,1,ToCol))),
	!.
  tableedit_GetPossibilityPaste(Win,b_true,AML):-
	not(tableedit_db_Col_Info(Win,_,readonly(b_true))),
	tableedit_db_Te_Info(Win,paste(b_true)),
	grid_Marker(Win,M), M = grid_area_marker(AML),
	AML = [ga(FromRow,ToRow,FromCol,ToCol)],
	SourceStr = cb_GetString(),
	tableedit_ChkClipBoardStr(Win,AML,SourceStr,b_true),
	not(tableedit_SendCallback(Win,paste_beg(FromRow,ToRow,FromCol,ToCol))),
	!.
  tableedit_GetPossibilityPaste(Win,b_true,AML):-
	not(tableedit_db_Col_Info(Win,_,readonly(b_true))),
	tableedit_db_Te_Info(Win,paste(b_true)),
	grid_Marker(Win,M), M = grid_all_marker,
	ToRow = tableedit_MaxVisibleRows(Win), ToRow >= 1,
	ToCol = tableedit_MaxCol(Win),
	AML = [ga(1,ToRow,1,ToCol)],
	SourceStr = cb_GetString(),
	tableedit_ChkClipBoardStr(Win,AML,SourceStr,b_true),
	not(tableedit_SendCallback(Win,paste_beg(1,ToRow,1,ToCol))),
	!.
  tableedit_GetPossibilityPaste(_Win,b_false,[]):-!.

  tableedit_GetPossibilityCopy(Win,b_true,AML):-
	grid_Marker(Win,M), M = grid_row_marker(LML),
	LML = [gl(FromRow,ToRow)],
	ToCol = tableedit_MaxCol(Win),
	AML = [ga(FromRow,ToRow,1,ToCol)],
	not(tableedit_SendCallback(Win,copy_beg(FromRow,ToRow,1,ToCol))),
	!.
  tableedit_GetPossibilityCopy(Win,b_true,AML):-
	grid_Marker(Win,M), M = grid_area_marker(AML),
	AML = [ga(FromRow,ToRow,FromCol,ToCol)],
	not(tableedit_SendCallback(Win,copy_beg(FromRow,ToRow,FromCol,ToCol))),
	!.
  tableedit_GetPossibilityCopy(Win,b_true,AML):-
	grid_Marker(Win,M), M = grid_all_marker,
	ToRow = tableedit_MaxVisibleRows(Win), ToRow >= 1,
	ToCol = tableedit_MaxCol(Win),
	AML = [ga(1,ToRow,1,ToCol)],
	not(tableedit_SendCallback(Win,copy_beg(1,ToRow,1,ToCol))),
	!.
  tableedit_GetPossibilityCopy(_Win,b_false,[]):-!.

  tableedit_GetPossibilitySort(Win,b_true,Col):-
	grid_Marker(Win,M), M = grid_area_marker([ga(_,_,Col,ToCol)]), Col = ToCol,
	tableedit_db_Col_Info(Win,Col,sortmode(SortMode)),
	not(SortMode = none),
	not(tableedit_SendCallback(Win,sort_beg(Col))),
	!.
  tableedit_GetPossibilitySort(Win,b_true,Col):-
	grid_Marker(Win,M), M = grid_col_marker([gl(Col,ToCol)]), Col = ToCol,
	tableedit_db_Col_Info(Win,Col,sortmode(SortMode)),
	not(SortMode = none),
	not(tableedit_SendCallback(Win,sort_beg(Col))),
	!.
  tableedit_GetPossibilitySort(Win,b_true,Col):-
	grid_Marker(Win,M), M = grid_edit_Cell(_,Col),
	tableedit_db_Col_Info(Win,Col,sortmode(SortMode)),
	not(SortMode = none),
	not(tableedit_SendCallback(Win,sort_beg(Col))),
	!.
  tableedit_GetPossibilitySort(_Win,b_false,0):-!.

predicates
% Check : if exist column with "filter(b_false)" property in area list, then - fail
  determ  tableedit_ChkAreaListForFilter(WINDOW,GRID_AREALIST)
  determ  tableedit_ChkAreaListForFilter1(WINDOW,INTEGER FromColumn,INTEGER ToColumn)
clauses

  tableedit_ChkAreaListForFilter(_Win,[]):-!.
  tableedit_ChkAreaListForFilter(Win,[L1|L2]):-!,
	L1 = ga(_FRow,_ToRow,FCol,ToCol),
	not(tableedit_ChkAreaListForFilter1(Win,FCol,ToCol)),
	tableedit_ChkAreaListForFilter(Win,L2).

  tableedit_ChkAreaListForFilter1(Win,FCol,ToCol):-
	tableedit_db_Col_Info(Win,Col,filter(b_false)),
	Col >= FCol, Col <= ToCol,!.
    
  tableedit_GetPossibilityFilter(Win,Exclude,b_true,FL):-
	grid_Marker(Win,M), M = grid_area_marker(AREALIST),
	tableedit_ChkAreaListForFilter(Win,AREALIST),
	tableedit_CreateAreaFilter(Win,Exclude,AREALIST,FL),
	not(tableedit_SendCallback(Win,filter_beg(FL))),
	!.
  tableedit_GetPossibilityFilter(Win,Exclude,b_true,FL):-
	grid_Marker(Win,M), M = grid_edit_Cell(Row,Col),
	tableedit_ChkAreaListForFilter(Win,[ga(Row,Row,Col,Col)]),
	tableedit_CreateAreaFilter(Win,Exclude,[ga(Row,Row,Col,Col)],FL),
	not(tableedit_SendCallback(Win,filter_beg(FL))),
	!.
  tableedit_GetPossibilityFilter(_Win,_,b_false,[]):-!.

  tableedit_AppendToMenu(Win,MenuList,MenuList):-
	tableedit_db_Te_Info(Win,menu([])),!.
  tableedit_AppendToMenu(Win,InMenuList,OutMenuList):-
	tableedit_db_Te_Info(Win,menu(MenuList)),
	tableedit_Append(InMenuList,[separator | MenuList],OutMenuList),!.
  tableedit_AppendToMenu(_,MenuList,MenuList).

predicates
  tableedit_GetPossibilityFind(WINDOW TabWin,BOOLEAN PossFindNext)
  tableedit_GetPossibilityFindNext(WINDOW TabWin,BOOLEAN PossFindNext)
clauses
  tableedit_GetPossibilityFindNext(TabWin,b_true):-
	tableedit_db_Te_Info(TabWin,find(b_true)),
	tableedit_db_FindParam(TabWin,_Str,_Direction,Column,_Match,_CaseSens),
	tableedit_db_FindDlgParam(TabWin,Column,_),
	!.
  tableedit_GetPossibilityFindNext(_TabWin,b_false):-!.

  tableedit_GetPossibilityFind(Win,b_true):-
	tableedit_db_Te_Info(Win,find(b_true)),
	!.
  tableedit_GetPossibilityFind(_Win,b_false):-!.

