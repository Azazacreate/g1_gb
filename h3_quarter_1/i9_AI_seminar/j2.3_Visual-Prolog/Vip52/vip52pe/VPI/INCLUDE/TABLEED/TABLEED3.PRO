/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S 

 FileName:	TABLEED3.PRO
 Purpose:	Module for Table Editor object
 Written by:	Andrey Skobelev
 Version:	1.0
 Build:		009.981112
 Tested with:   Visual Prolog v.5.1 build 555a
 Comments:	
******************************************************************************/

predicates
  determ  tableedit_GetGridDataFromToRow(WINDOW,INTEGER Column,INTEGER FrRow,INTEGER ToRow,
	INTEGER FrCol,INTEGER ToCol,
  	TABLEEDIT_DATA,GRIDLIST2D,GRIDLIST2D)

  determ  tableedit_GetGridDataFromToCol(WINDOW,INTEGER Column,
	INTEGER FrCol,INTEGER ToCol,
  	TABLEEDIT_COLUMNDATA,GRIDLIST,GRIDLIST)

  determ  tableedit_ConvDataToAnswer(WINDOW,TABLEEDIT_CELLDATA,INTEGER Column,GRIDTEXT)

clauses

% Get answer list for grid
  tableedit_GetGridDataFromTo(Win,FrRow,ToRow,FRColumn,ToColumn,AnswerData):-
	tableedit_db_Data_Info(Win,Data),
	tableedit_GetGridDataFromToRow(Win,1,FrRow,ToRow,FRColumn,ToColumn,Data,[],AnswerData),!.

  tableedit_GetGridDataFromToRow(_Win,_Col,_FrRow,_ToRow,_FRColumn,_ToColumn,[],AData,ANewData):- tableedit_reverse(AData,[],ANewData),!.
  tableedit_GetGridDataFromToRow(_Win,_,_,0,_,_,_,AData,ANewData):-tableedit_reverse(AData,[],ANewData),!.
  tableedit_GetGridDataFromToRow(Win,Column,FrRow,ToRow,FRColumn,ToColumn,[Data|Rest],AD,NewData):-
	FrRow <= 1, ToRow > 0,
	FR = FrRow - 1, TR = ToRow - 1,!,
	tableedit_GetGridDataFromToCol(Win,Column,FRColumn,ToColumn,Data,[],Answer),
	tableedit_GetGridDataFromToRow(Win,Column,FR,TR,FRColumn,ToColumn,Rest,[Answer|AD],NewData).
  tableedit_GetGridDataFromToRow(Win,Col,FrRow,ToRow,FRColumn,ToColumn,[_Data|Rest],AD,NewData):-
	FR = FrRow - 1, TR = ToRow - 1,!, 
	tableedit_GetGridDataFromToRow(Win,Col,FR,TR,FRColumn,ToColumn,Rest,AD,NewData).

  tableedit_GetGridDataFromToCol(_Win,_Col,_FrCol,_ToCol,[],AData,ANewData):- tableedit_reverse(AData,[],ANewData),!.
  tableedit_GetGridDataFromToCol(Win,Column,FrCol,ToCol,[Data|Rest],AD,NewData):-
	FrCol <= 1, ToCol > 0,
	FC = FrCol - 1, TC = ToCol - 1,!,
	tableedit_ConvDataToAnswer(Win,Data,Column,Answer),
	C = Column + 1,
	tableedit_GetGridDataFromToCol(Win,C,FC,TC,Rest,[Answer|AD],NewData).
  tableedit_GetGridDataFromToCol(Win,Col,FrRow,ToRow,[_Data|Rest],AD,NewData):-
	FR = FrRow - 1, TR = ToRow - 1,!, C = Col + 1,
	tableedit_GetGridDataFromToCol(Win,C,FR,TR,Rest,AD,NewData).
	
  tableedit_ConvDataToAnswer(_Win,p(fromres(Id),Stretch,_String),_Column,picture(Pic,Stretch)):-
	trap(Pic = pict_GetFromRes(Id),_,fail),
	!.
  tableedit_ConvDataToAnswer(_Win,p(fromfile(FilePath),Stretch,_String),_Column,picture(Pic,Stretch)):-
	trap(Pic = pict_Load(FilePath),_,fail),
	!.
  tableedit_ConvDataToAnswer(Win,CellData,Column,textatr(String,Fg_Col,Bg_Col)):-
	not(CellData = p(_,_,_)),
	tableedit_CellDataToGridData(Win,CellData,Column,String,Fg_Col,Bg_Col),!.
  tableedit_ConvDataToAnswer(_Win,_,_,empty_answer).

  tableedit_CellDataToGridData(_Win,p(_Pic,_Stretch,String),_Column,String,0,0):-!.
  tableedit_CellDataToGridData(Win,i(Int),Column,String,Fg_Col,Bg_Col):-
	trap(str_int(String,Int),_,fail),
	tableedit_db_Col_Info(Win,Column,backcolor(Bg_Col)),
	tableedit_db_Col_Info(Win,Column,forecolor(Fg_Col)),!.
  tableedit_CellDataToGridData(Win,ic(Int,Bg_Col),Column,String,Fg_Col,Bg_Col):-
	trap(str_int(String,Int),_,fail),
	tableedit_db_Col_Info(Win,Column,forecolor(Fg_Col)),!.
  tableedit_CellDataToGridData(Win,l(Long),Column,String,Fg_Col,Bg_Col):-
	trap(term_str(long,Long,String),_,fail),
	tableedit_db_Col_Info(Win,Column,backcolor(Bg_Col)),
	tableedit_db_Col_Info(Win,Column,forecolor(Fg_Col)),!.
  tableedit_CellDataToGridData(Win,lc(Long,Bg_Col),Column,String,Fg_Col,Bg_Col):-
	trap(term_str(long,Long,String),_,fail),
	tableedit_db_Col_Info(Win,Column,forecolor(Fg_Col)),!.
  tableedit_CellDataToGridData(Win,r(Real),Column,String,Fg_Col,Bg_Col):-
	trap(str_real(String,Real),_,fail),
	tableedit_db_Col_Info(Win,Column,backcolor(Bg_Col)),
	tableedit_db_Col_Info(Win,Column,forecolor(Fg_Col)),!.
  tableedit_CellDataToGridData(Win,rc(Real,Bg_Col),Column,String,Fg_Col,Bg_Col):-
	trap(str_real(String,Real),_,fail),
	tableedit_db_Col_Info(Win,Column,forecolor(Fg_Col)),!.
  tableedit_CellDataToGridData(Win,s(String),Column,String,Fg_Col,Bg_Col):-
	tableedit_db_Col_Info(Win,Column,backcolor(Bg_Col)),
	tableedit_db_Col_Info(Win,Column,forecolor(Fg_Col)),!.
  tableedit_CellDataToGridData(Win,sc(String,Bg_Col),Column,String,Fg_Col,Bg_Col):-
	tableedit_db_Col_Info(Win,Column,forecolor(Fg_Col)),!.
  tableedit_CellDataToGridData(Win,void,Column,"",Fg_Col,Bg_Col):-
	tableedit_db_Te_Info(Win,emptycolor(Bg_Col)),
	tableedit_db_Col_Info(Win,Column,forecolor(Fg_Col)),!.
  tableedit_CellDataToGridData(Win,voidc(Bg_Col),Column,"",Fg_Col,Bg_Col):-
	tableedit_db_Col_Info(Win,Column,forecolor(Fg_Col)),!.

  tableedit_member_index(S,[S|_],1):-!.
  tableedit_member_index(S,[_|L],M):-
        bound(M),!,
        N = M - 1,
        tableedit_member_index(S,L,N),!.
  tableedit_member_index(S,[_|L],M):-
        tableedit_member_index(S,L,N),!,
        M = N + 1.

predicates
  procedure  tableedit_GetDataFromToRow(WINDOW,INTEGER Column,INTEGER FrRow,INTEGER ToRow,INTEGER FrCol,INTEGER ToCol,
  		TABLEEDIT_DATA,TABLEEDIT_DATA,TABLEEDIT_DATA)
  procedure  tableedit_GetDataFromToCol(WINDOW,INTEGER Column,INTEGER FrCol,INTEGER ToCol,
  		TABLEEDIT_COLUMNDATA,TABLEEDIT_COLUMNDATA,TABLEEDIT_COLUMNDATA)
  procedure  tableedit_SetDataFromToRow(WINDOW,BOOLEAN SendCallback,INTEGER Row,INTEGER FrRow,
			     INTEGER ToRow,INTEGER FrCol,INTEGER ToCol,
			     TABLEEDIT_DATA,TABLEEDIT_DATA,TABLEEDIT_DATA,
			     TABLEEDIT_DATA)
  procedure  tableedit_SetDataFromToCol(WINDOW,BOOLEAN SendCallback,INTEGER Row,
			     INTEGER Column,INTEGER FrCol,INTEGER ToCol,
			     TABLEEDIT_COLUMNDATA,TABLEEDIT_COLUMNDATA,
			     TABLEEDIT_COLUMNDATA,TABLEEDIT_COLUMNDATA)
  procedure  tableedit_SortData(WINDOW,INTEGER Col,TABLEEDIT_DATA,TABLEEDIT_DATA)
  procedure  tableedit_ResetColWidth(WINDOW,GRID_COLUMN_LIST,INTEGER Column)

clauses
% reset "column width" properties from grid
  tableedit_ResetColWidth(_Win,[],_Column):-!.
  tableedit_ResetColWidth(Win,[L1|L2],Column):-
	L1 = grid_col(_Ti,CW,_Ha,_Va,_DX,_DY,_ML),
	retract(tableedit_db_Col_Info(Win,Column,width(_))),!,
	assert(tableedit_db_Col_Info(Win,Column,width(CW))),
	Col1 = Column + 1,
	tableedit_ResetColWidth(Win,L2,Col1).
  tableedit_ResetColWidth(_,_,_):-errorexit().
	
% sort data list
  tableedit_SortData(Win,Col,Data,OutData):-
	tableedit_db_Col_Info(Win,Col,sortmode(ascending(Ilist))),
	tableedit_db_Te_Info(Win,compare(CompareFunc)),
	tableedit_CutHeadersFooters(Win,Data,Data1,HeadData,FootData),
	tableedit_sort_data(Win,CompareFunc,b_true,[Col|Ilist],Data1,NewData),
	tableedit_InsHeadersFooters(Win,NewData,OutData,HeadData,FootData),
	tableedit_CliarUndoRedoData(Win),
	!.
  tableedit_SortData(Win,Col,Data,OutData):-
	tableedit_db_Col_Info(Win,Col,sortmode(descending(Ilist))),
	tableedit_db_Te_Info(Win,compare(CompareFunc)),
	tableedit_CutHeadersFooters(Win,Data,Data1,HeadData,FootData),
	tableedit_sort_data(Win,CompareFunc,b_false,[Col|Ilist],Data1,NewData),
	tableedit_InsHeadersFooters(Win,NewData,OutData,HeadData,FootData),
	tableedit_CliarUndoRedoData(Win),
	!.
  tableedit_SortData(_Win,_,Data,Data):-!.

% set new data
  tableedit_SetAllDataNoSort(Win,NewData):-
	not(tableedit_db_InitMode(Win)),
	retract(tableedit_db_Data_Info(Win,_Data)),
	assert(tableedit_db_Data_Info(Win,NewData)),
	tableedit_CalcMaxRows(Win,NewData,MaxRows),
	trap(grid_Rows(Win,MaxRows),_,fail),
	trap(grid_Invalidate(Win,grid_all),_,fail),!.
  tableedit_SetAllDataNoSort(Win,NewData):-
	tableedit_db_InitMode(Win),
	retract(tableedit_db_Data_Info(Win,_Data)),
	assert(tableedit_db_Data_Info(Win,NewData)),!.
  tableedit_SetAllDataNoSort(_,_):-!.

  tableedit_GetDataFromToRow(_Win,_Col,_FrRow,_ToRow,_FRColumn,_ToColumn,[],AData,ANewData):- tableedit_reverse(AData,[],ANewData),!.
  tableedit_GetDataFromToRow(_Win,_,_,0,_,_,_,AData,ANewData):-tableedit_reverse(AData,[],ANewData),!.
  tableedit_GetDataFromToRow(Win,Column,FrRow,ToRow,FRColumn,ToColumn,[Data|Rest],AD,NewData):-
	FrRow <= 1, ToRow > 0,
	FR = FrRow - 1, TR = ToRow - 1,!,
	tableedit_GetDataFromToCol(Win,Column,FRColumn,ToColumn,Data,[],Answer),
	tableedit_GetDataFromToRow(Win,Column,FR,TR,FRColumn,ToColumn,Rest,[Answer|AD],NewData).
  tableedit_GetDataFromToRow(Win,Col,FrRow,ToRow,FRColumn,ToColumn,[_Data|Rest],AD,NewData):-
	FR = FrRow - 1, TR = ToRow - 1,!, 
	tableedit_GetDataFromToRow(Win,Col,FR,TR,FRColumn,ToColumn,Rest,AD,NewData).
  tableedit_GetDataFromToRow(_,_,_,_,_,_,_,_,[]):-errorexit().

  tableedit_GetDataFromToCol(_Win,_Col,_FrCol,_ToCol,[],AData,ANewData):- tableedit_reverse(AData,[],ANewData),!.
  tableedit_GetDataFromToCol(Win,Col,FrCol,ToCol,[Data|Rest],AD,NewData):-
	FrCol <= 1, ToCol > 0,
	FC = FrCol - 1, TC = ToCol - 1,!,
	tableedit_GetDataFromToCol(Win,Col,FC,TC,Rest,[Data|AD],NewData).
  tableedit_GetDataFromToCol(Win,Col,FrRow,ToRow,[_Data|Rest],AD,NewData):-
	FR = FrRow - 1, TR = ToRow - 1,!,
	tableedit_GetDataFromToCol(Win,Col,FR,TR,Rest,AD,NewData).
  tableedit_GetDataFromToCol(_,_,_,_,_,_,[]):-errorexit().

% set new data and send "modified" callbacks on modified cells
  tableedit_SetDataSendCallback(Win,FrRow,ToRow,FRColumn,ToColumn,InData):-
	retract(tableedit_db_Data_Info(Win,Data)),
	tableedit_SetDataFromToRow(Win,b_true,1,FrRow,ToRow,FRColumn,ToColumn,InData,Data,[],NewData),
	assert(tableedit_db_Data_Info(Win,NewData)),
	grid_Invalidate(Win,grid_area(FrRow,ToRow,FRColumn,ToColumn)),
	!.
  tableedit_SetDataSendCallback(_,_,_,_,_,_).

  tableedit_SetDataFromToRow(_Win,_Send,_Row,_FrRow,_ToRow,_FRColumn,_ToColumn,_InData,[],AData,ANewData):- tableedit_reverse(AData,[],ANewData),!.
  tableedit_SetDataFromToRow(Win,Send,Row,FrRow,ToRow,FRColumn,ToColumn,[InData|InRest],[Data|Rest],AD,NewData):-
	FrRow <= 1, ToRow > 0,
	FR = FrRow - 1, TR = ToRow - 1,!,
	tableedit_SetDataFromToCol(Win,Send,Row,1,FRColumn,ToColumn,InData,Data,[],NewOutData),
	Row1 = Row + 1,
	tableedit_SetDataFromToRow(Win,Send,Row1,FR,TR,FRColumn,ToColumn,InRest,Rest,[NewOutData|AD],NewData).
  tableedit_SetDataFromToRow(Win,Send,Row,FrRow,ToRow,FRColumn,ToColumn,InD,[Data|Rest],AD,NewData):-
	FR = FrRow - 1, TR = ToRow - 1,Row1 = Row + 1,!, 
	tableedit_SetDataFromToRow(Win,Send,Row1,FR,TR,FRColumn,ToColumn,InD,Rest,[Data|AD],NewData).
  tableedit_SetDataFromToRow(_,_,_,_,_,_,_,_,_,_,[]):- errorexit().

  tableedit_SetDataFromToCol(_Win,_Send,_Row,_Col,_FrCol,_ToCol,_InData,[],AData,ANewData):- tableedit_reverse(AData,[],ANewData),!.
  tableedit_SetDataFromToCol(Win,Send,Row,Col,FrCol,ToCol,[InData|InRest],[Data|Rest],AD,NewData):-
	FrCol <= 1, ToCol > 0,
	tableedit_SendDataModifiedCallback(Win,Send,Row,Col,Data,InData),
	FC = FrCol - 1, TC = ToCol - 1, Col1 = Col + 1,!,
	tableedit_SetDataFromToCol(Win,Send,Row,Col1,FC,TC,InRest,Rest,[InData|AD],NewData).
  tableedit_SetDataFromToCol(Win,Send,Row,Col,FrCol,ToCol,[_InData|InRest],[Data|Rest],AD,NewData):-
	FrCol <= 1, ToCol > 0,
	FC = FrCol - 1, TC = ToCol - 1, Col1 = Col + 1,!,
	tableedit_SetDataFromToCol(Win,Send,Row,Col1,FC,TC,InRest,Rest,[Data|AD],NewData).
  tableedit_SetDataFromToCol(Win,Send,Row,Col,FrRow,ToRow,InD,[Data|Rest],AD,NewData):-
	FR = FrRow - 1, TR = ToRow - 1, Col1 = Col + 1,!,
	tableedit_SetDataFromToCol(Win,Send,Row,Col1,FR,TR,InD,Rest,[Data|AD],NewData).
  tableedit_SetDataFromToCol(_,_,_,_,_,_,_,_,_,[]):- errorexit().


predicates
% create N rows containing void data
  procedure  tableedit_CreateVoidRow(WINDOW,INTEGER,TABLEEDIT_COLUMNDATA,TABLEEDIT_COLUMNDATA)
  determ  tableedit_ChkNotLineListForDel(GRID_LINELIST,INTEGER Row)
  determ  tableedit_ChkLineForDel(GRID_LINE,INTEGER Row)
  procedure  tableedit_DelRows(WINDOW,BOOLEAN SendCallback,GRID_LINELIST)
  procedure  tableedit_CutReverseLineListRows(WINDOW,BOOLEAN SendCallback,INTEGER Row,GRID_LINELIST,
			    TABLEEDIT_DATA,TABLEEDIT_DATA,TABLEEDIT_DATA,
			    TABLEEDIT_DATA,TABLEEDIT_DATA) 
  determ tableedit_SendDelCallback(WINDOW,INTEGER Row,TABLEEDIT_COLUMNDATA Data,BOOLEAN SendCallback)

clauses
% fail if the line list contains Row 
  tableedit_ChkNotLineListForDel([],_Row):-!.
  tableedit_ChkNotLineListForDel([L1|L2],Row):-!,
	tableedit_ChkLineForDel(L1,Row),
	tableedit_ChkNotLineListForDel(L2,Row).

  tableedit_ChkLineForDel(Line,Row):- 
	Line = gl(FromRow,ToRow), Row >= FromRow, Row <= ToRow,!,fail.
  tableedit_ChkLineForDel(_,_):-!.

  tableedit_DeleteRowsSendCallback(Win,LList):-
	tableedit_DelRows(Win,b_true,LList),
	tableedit_db_Data_Info(Win,NewData),
	tableedit_CalcMaxRows(Win,NewData,MaxRows),
	grid_Rows(Win,MaxRows),!.
  tableedit_DeleteRowsSendCallback(_,_).
predicates
  tableedit_DelBuffRows(WINDOW,BOOLEAN,INTEGER MaxRows,GRID_LINELIST)
clauses

  tableedit_DelRows(Win,Send,LList):-
	tableedit_db_Te_Info(Win,bufferingmode(nobuffering)),
	tableedit_db_Data_Info(Win,Data),
	tableedit_reverse(Data,[],ReverseData),
	tableedit_CalcMaxRows(Win,Data,MaxRows),
	tableedit_CutReverseLineListRows(Win,Send,MaxRows,LList,ReverseData,[],NewData,[],_CND),
	retract(tableedit_db_Data_Info(Win,_)),
	assert(tableedit_db_Data_Info(Win,NewData)),!.
  tableedit_DelRows(Win,Send,LList):-
	tableedit_db_Te_Info(Win,bufferingmode(buffering(_AnsFunc,_RowBuffSize,MaxRows))),
 	tableedit_DelBuffRows(Win,Send,MaxRows,LList),
	tableedit_BuffInvalidate(Win),
	!.
  tableedit_DelRows(_,_,_).

  tableedit_DelBuffRows(_Win,_Send,0,_LList):-!.
  tableedit_DelBuffRows(Win,Send,Row,LList):-
	not(tableedit_ChkNotLineListForDel(LList,Row)),
	FromRow = Row, ToRow = Row, FromColumn = 1, ToColumn = tableedit_MaxCol(Win),
	Data1 = tableedit_GetData(Win,FromRow,ToRow,FromColumn,ToColumn),
	Data1 = [Data],
	tableedit_SendDelCallback(Win,Row,Data,Send),
	R = Row - 1,!,
	tableedit_DelBuffRows(Win,Send,R,LList).
  tableedit_DelBuffRows(Win,Send,Row,LList):-!,
	R = Row - 1,!,
	tableedit_DelBuffRows(Win,Send,R,LList).


  tableedit_CutReverseLineListRows(_Win,_Send,_Row,_LList,[],AData,AData,CutData,CutData):- !.
  tableedit_CutReverseLineListRows(Win,Send,Row,LList,[Data|Rest],AD,NewData,CD,CND):- 
	not(tableedit_ChkNotLineListForDel(LList,Row)),
	tableedit_SendDelCallback(Win,Row,Data,Send),
	R = Row - 1,!,
	tableedit_CutReverseLineListRows(Win,Send,R,LList,Rest,AD,NewData,[Data|CD],CND).
  tableedit_CutReverseLineListRows(Win,Send,Row,LList,[Data|Rest],AD,NewData,CD,CND):- 
	R = Row - 1,!, 
	tableedit_CutReverseLineListRows(Win,Send,R,LList,Rest,[Data|AD],NewData,CD,CND).
  tableedit_CutReverseLineListRows(_,_,_,_,_,_,[],_,[]):- errorexit().

  tableedit_SendDelCallback(Win,Row,Data,b_true):-
	not(tableedit_SendCallback(Win,delete_row(Row,Data))),!.
  tableedit_SendDelCallback(Win,Row,Data,b_false):-
	tableedit_UpdateUndoRedoModified(Win,delete_row(Row,Data)),!.

  tableedit_CutListRows(_Win,_FrRow,_ToRow,[],AData,ANewData,CutData,CutNewData):- 
	tableedit_reverse(AData,[],ANewData),
	tableedit_reverse(CutData,[],CutNewData),!.
  tableedit_CutListRows(Win,FrRow,ToRow,[Data|Rest],AD,NewData,CD,CND):- 
	FrRow <= 1, ToRow > 0,
	FR = FrRow - 1, TR = ToRow - 1,!,
	tableedit_CutListRows(Win,FR,TR,Rest,AD,NewData,[Data|CD],CND).
  tableedit_CutListRows(Win,FrRow,ToRow,[Data|Rest],AD,NewData,CD,CND):- 
	FR = FrRow - 1, TR = ToRow - 1,!, 
	tableedit_CutListRows(Win,FR,TR,Rest,[Data|AD],NewData,CD,CND).

  tableedit_InsRows(Win,Row,InsData):-
	InsData = [InsD],
	tableedit_db_Te_Info(Win,bufferingmode(nobuffering)),
	not(tableedit_SendCallback(Win,insert_row(Row,InsD))),
	retract(tableedit_db_Data_Info(Win,Data)),
	tableedit_InsListRows(Win,Row,InsData,Data,[],NewData),
	assert(tableedit_db_Data_Info(Win,NewData)),
	tableedit_CalcMaxRows(Win,NewData,MaxRows),
	grid_Rows(Win,MaxRows),
	!.
  tableedit_InsRows(Win,Row,InsData):-
	InsData = [InsD],
	tableedit_db_Te_Info(Win,bufferingmode(buffering(_AnsFunc,_RowBuffSize,_MaxRows))),
	not(tableedit_SendCallback(Win,insert_row(Row,InsD))),
	tableedit_BuffInvalidate(Win),
	!.

  tableedit_InsDefRowZ(Win):-
	tableedit_db_Data_Info(Win,Data),
	tableedit_db_Te_Info(Win,footers(F)),
	tableedit_CalcMaxRows(Win,Data,MaxRows),
	Row = MaxRows - F + 1,
	tableedit_InsDefRow(Win,Row),
	tableedit_db_Data_Info(Win,NewData),
	tableedit_CalcMaxRows(Win,NewData,NewMax),
	not(NewMax = MaxRows),
	grid_Rows(Win,NewMax),
	!.
  tableedit_InsDefRowZ(_Win):-!.

  tableedit_InsDefRow(Win,Row):-
	tableedit_db_Te_Info(Win,bufferingmode(nobuffering)),
	tableedit_CreateDefRow(Win,1,[],DefData),
	not(tableedit_SendCallback(Win,insert_row(Row,DefData))),
	retract(tableedit_db_Data_Info(Win,Data)), DD = [DefData],
	tableedit_InsListRows(Win,Row,DD,Data,[],NewData),
	assert(tableedit_db_Data_Info(Win,NewData)),!.
  tableedit_InsDefRow(Win,Row):-
	tableedit_db_Te_Info(Win,bufferingmode(buffering(_AnsFunc,_RowBuffSize,_MaxRows))),
	tableedit_CreateDefRow(Win,1,[],DefData),
	not(tableedit_SendCallback(Win,insert_row(Row,DefData))),
	!.
  tableedit_InsDefRow(_Win,_Row):-!.

  tableedit_CreateVoidRows(_Win,Col,AData,AData):- Col <= 0,!. 
  tableedit_CreateVoidRows(Win,Col,AData,ANewData):- 
	C = Col - 1,
	tableedit_CreateVoidRow(Win,1,[],RowData),!,
	tableedit_CreateVoidRows(Win,C,[RowData|AData],ANewData). 


  tableedit_CreateVoidRow(Win,Col,AData,AData):- 
	not(tableedit_db_Col_Info(Win,Col,_)),!.
  tableedit_CreateVoidRow(Win,Col,Data,ND):-!,
	NextCol = Col + 1,
	tableedit_CreateVoidRow(Win,NextCol,[void|Data],ND).

predicates
  procedure  tableedit_CreateDefRows(WINDOW,INTEGER Nrows,TABLEEDIT_COLUMNDATA DefData,
  	TABLEEDIT_DATA Data,TABLEEDIT_DATA NewData)
  procedure  tableedit_SaveInsDataForUndo(WINDOW,INTEGER Row,TABLEEDIT_DATA)
clauses

  tableedit_CreateDefRows(_Win,Nrows,_DefData,Data,Data):- Nrows <= 0,!.
  tableedit_CreateDefRows(Win,Nrows,DefData,AData,ANewData):-!,
	R = Nrows - 1,
  	tableedit_CreateDefRows(Win,R,DefData,[DefData|AData],ANewData).

  tableedit_SaveInsDataForUndo(_,_,[]):-!.
  tableedit_SaveInsDataForUndo(Win,Row,[L1|L2]):-!,
	tableedit_UpdateUndoRedoModified(Win,insert_row(Row,L1)),
	R = Row + 1,
	tableedit_SaveInsDataForUndo(Win,R,L2).
  tableedit_SaveInsDataForUndo(_,_,_):-errorexit().

  tableedit_CreateDefRow(Win,Col,AData,ANewData):- 
	not(tableedit_db_Col_Info(Win,Col,_)),
	tableedit_reverse(AData,[],ANewData),!.
  tableedit_CreateDefRow(Win,Col,Data,ND):-
	tableedit_db_Col_Info(Win,Col,defaultvalue(DefVal)),!,
	NextCol = Col + 1,
	tableedit_CreateDefRow(Win,NextCol,[DefVal|Data],ND).

  tableedit_InsListRows(_Win,_FrRow,[],[],AData,ANewData):- tableedit_reverse(AData,[],ANewData),!.
  tableedit_InsListRows(Win,FrRow,[Data1|Rest1],Data2,AD,NewData):- 
	FrRow <= 1,
	FR = FrRow - 1,!,
	tableedit_InsListRows(Win,FR,Rest1,Data2,[Data1|AD],NewData).
  tableedit_InsListRows(Win,FrRow,Data1,[Data2|Rest2],AD,NewData):- 
	FR = FrRow - 1,!, 
	tableedit_InsListRows(Win,FR,Data1,Rest2,[Data2|AD],NewData).

predicates
  procedure tableedit_ConvertDataToString(TABLEEDIT_CELLDATA,STRING String)
clauses
  tableedit_ConvertDataToString(p(_Pic,_Stretch,String),String):-!.
  tableedit_ConvertDataToString(i(Int),String):-
	trap(str_int(String,Int),_,fail),!.
  tableedit_ConvertDataToString(ic(Int,_Bg_Col),String):-
	trap(str_int(String,Int),_,fail),!.
  tableedit_ConvertDataToString(l(Long),String):-
	trap(term_str(long,Long,String),_,fail),!.
  tableedit_ConvertDataToString(lc(Long,_Bg_Col),String):-
	trap(term_str(long,Long,String),_,fail),!.
  tableedit_ConvertDataToString(r(Real),String):-
	trap(str_real(String,Real),_,fail),!.
  tableedit_ConvertDataToString(rc(Real,_Bg_Col),String):-
	trap(str_real(String,Real),_,fail),!.
  tableedit_ConvertDataToString(s(String),OString):-
	tableedit_ReplaceString(String,"\t"," ",OString1),
	tableedit_ReplaceString(OString1,"\r"," ",OString2),
	tableedit_ReplaceString(OString2,"\n"," ",OString),
	!.
  tableedit_ConvertDataToString(sc(String,_Bg_Col),OString):-
	tableedit_ReplaceString(String,"\t"," ",OString1),
	tableedit_ReplaceString(OString1,"\r"," ",OString2),
	tableedit_ReplaceString(OString2,"\n"," ",OString),
	!.
  tableedit_ConvertDataToString(void,""):-!.
  tableedit_ConvertDataToString(voidc(_Bg_Col),""):-!.
  tableedit_ConvertDataToString(_,""):-
	errorexit().


% Create clipboard format string from table editor data
predicates
procedure  tableedit_CreateStringRowsData(TABLEEDIT_DATA,STRING OutString)
procedure  tableedit_CreateStringRowsData1(TABLEEDIT_DATA)
procedure  tableedit_CreateStringColumnData(TABLEEDIT_COLUMNDATA,STRING OutString)
procedure  tableedit_retract(STRING)
clauses


  tableedit_CreateStringRowsData(Data,OutString):-
	retractall(tableedit_str_buffer(_)),
	assert(tableedit_str_buffer("")),
	tableedit_CreateStringRowsData1(Data),
	retract(tableedit_str_buffer(OutString)),!.
  tableedit_CreateStringRowsData(_,""):-
	errorexit().

  tableedit_retract(String):-
	retract(tableedit_str_buffer(String)),!.
  tableedit_retract(""):-
	errorexit().

  tableedit_CreateStringRowsData1([Data|[]]):-
	tableedit_CreateStringColumnData(Data,OutStrX),
	tableedit_retract(TmpString),
	concat(TmpString,OutStrX,OutStr),
	assert(tableedit_str_buffer(OutStr)),!.
  tableedit_CreateStringRowsData1([Data|_]):-
	tableedit_CreateStringColumnData(Data,OutStrX),
	concat(OutStrX,"\r\n",OutStrY),
	tableedit_retract(TmpString),
	concat(TmpString,OutStrY,OutStr),
	assert(tableedit_str_buffer(OutStr)),
	fail.
  tableedit_CreateStringRowsData1([_|Rest]):-!,
	tableedit_CreateStringRowsData1(Rest).
  tableedit_CreateStringRowsData1(_):-
	errorexit().

  tableedit_CreateStringColumnData([],""):-!.
  tableedit_CreateStringColumnData([CellData|[]],OutStr):-
	tableedit_ConvertDataToString(CellData,OutStr),!.
  tableedit_CreateStringColumnData([CellData|Rest],OutStr):-
	tableedit_ConvertDataToString(CellData,Cell),
	tableedit_CreateStringColumnData(Rest,RestStr),!,
	concat(Cell,"\t",CellX),
	concat(CellX,RestStr,OutStr).
  tableedit_CreateStringColumnData(_,""):-
	errorexit().

predicates
  determ  tableedit_frontstr(UNSIGNED,STRING,STRING,STRING)
  determ  tableedit_searchstring(STRING,STRING,UNSIGNED)

  determ  tableedit_SetStrDataFromToRow(WINDOW,BOOLEAN SendCallback,INTEGER FrRow,
		INTEGER Row,INTEGER FrPastLimit,INTEGER ToPasteLimit,INTEGER FrCol,INTEGER ToCol,
		STRING SourceStr,TABLEEDIT_DATA,TABLEEDIT_DATA,TABLEEDIT_DATA,INTEGER,INTEGER NunmberToSetFromClipboard)

  determ  tableedit_SplitString(WINDOW,BOOLEAN SendCallback,INTEGER Row,INTEGER Col,
		INTEGER FrCol,INTEGER ToCol,STRING SourceStr,
		TABLEEDIT_COLUMNDATA,TABLEEDIT_COLUMNDATA,TABLEEDIT_COLUMNDATA)

  procedure  tableedit_CutTabString(STRING,STRING,STRING)
  procedure  tableedit_CliarString(STRING,STRING)

  
clauses

  tableedit_ChkClipBoardStr(Win,AML,SourceStr,b_true):-
	tableedit_db_Te_Info(Win,bufferingmode(nobuffering)),
	AML = [ga(FrRow,ToRow,FrCol,ToCol)],
	retractAll(tableedit_db_PasteError(Win)),
	tableedit_db_Data_Info(Win,Data),
	assert(tableedit_db_UndoAction(Win)),
	tableedit_SetStrDataFromToRow(Win,b_false,FrRow,1,1,ToRow,FrCol,ToCol,SourceStr,Data,[],_NewData,0,_NSet),
	retractAll(tableedit_db_UndoAction(Win)),
	not(tableedit_db_PasteError(Win)),
	!.
  tableedit_ChkClipBoardStr(Win,AML,SourceStr,b_true):-
	tableedit_db_Te_Info(Win,bufferingmode(buffering(_AnsFunc,_RowBuffSize,_MaxRows))),
	AML = [ga(FrRow,ToRow,FrCol,ToCol)],
	retractAll(tableedit_db_PasteError(Win)),
	assert(tableedit_db_UndoAction(Win)),
	Col = tableedit_MaxCol(Win),
	Data = tableedit_GetData(Win,FrRow,ToRow,1,Col),
	tableedit_SetStrDataFromToRow(Win,b_false,1,FrRow,FrRow,ToRow,FrCol,ToCol,SourceStr,Data,[],_NewData,0,_NSet),
	retractAll(tableedit_db_UndoAction(Win)),
	not(tableedit_db_PasteError(Win)),
	!.
  tableedit_ChkClipBoardStr(_Win,_AML,_SourceStr,b_false):-!.

  tableedit_SetRowDataSendCallback(Win,AML,SourceStr):-
	tableedit_db_Te_Info(Win,bufferingmode(nobuffering)),
	AML = [ga(FrRow,ToRow,FrCol,ToCol)],
	retractAll(tableedit_db_PasteError(Win)),
	tableedit_db_Data_Info(Win,Data),
	tableedit_SetStrDataFromToRow(Win,b_true,FrRow,1,1,ToRow,FrCol,ToCol,SourceStr,Data,[],NewData,0,_NSet),
	not(tableedit_db_PasteError(Win)),
	retract(tableedit_db_Data_Info(Win,_)),
	assert(tableedit_db_Data_Info(Win,NewData)),
	grid_Invalidate(Win,grid_all),!.
  tableedit_SetRowDataSendCallback(Win,AML,SourceStr):-
	tableedit_db_Te_Info(Win,bufferingmode(buffering(_AnsFunc,_RowBuffSize,_MaxRows))),
	AML = [ga(FrRow,ToRow,FrCol,ToCol)],
	retractAll(tableedit_db_PasteError(Win)),
	Col = tableedit_MaxCol(Win),
	Data = tableedit_GetData(Win,FrRow,ToRow,1,Col),
	tableedit_SetStrDataFromToRow(Win,b_true,1,FrRow,FrRow,ToRow,FrCol,ToCol,SourceStr,Data,[],_NewData,0,_NSet),
	not(tableedit_db_PasteError(Win)),
	retractAll(tableedit_db_DataBufRange(Win,_,_)),
	assert(tableedit_db_DataBufRange(Win,0,0)),
	grid_Invalidate(Win,grid_area(FrRow,ToRow,FrCol,ToCol)),!.
  tableedit_SetRowDataSendCallback(_,_,_):-!.

  tableedit_frontstr(LenStart,SourceStr,StartStr,EndString):-
	frontstr(LenStart,SourceStr,StartStr,EndString),!.
  tableedit_frontstr(_,SourceStr,SourceStr,""):- str_len(SourceStr,L),L > 0,!.
  tableedit_frontstr(_,"","",""):-!.

  tableedit_searchstring(SourceStr,SearchStr,Pos):-searchstring(SourceStr,SearchStr,Pos),!.
  tableedit_searchstring(SourceStr,_SearchStr,Pos):-str_len(SourceStr,Len), Pos = Len + 1,!.


  tableedit_SetStrDataFromToRow(_Win,_Send,_FrRow,_Row,_FP,_TP,_FrCol,_ToCol,_Str,[],AData,ANewData,NSet,NSet):- tableedit_reverse(AData,[],ANewData),!.
  tableedit_SetStrDataFromToRow(Win,Send,FrRow,Row,FP,TP,FrCol,ToCol,SourceStr,[Data|Rest],AD,NewData,NSet1,NS):-
	FrRow <= 1, 
	FR = FrRow - 1, Row1 = Row + 1, Row >= FP, Row <= TP,!,
	tableedit_searchstring(SourceStr,"\n",Pos),
	tableedit_frontstr(Pos,SourceStr,StartStr,EndString),
	tableedit_SplitString(Win,Send,Row,1,FrCol,ToCol,StartStr,Data,[],NewOutData), NSet2 = NSet1 + 1,
	tableedit_SetStrDataFromToRow(Win,Send,FR,Row1,FP,TP,FrCol,ToCol,EndString,Rest,[NewOutData|AD],NewData,NSet2,NS).
  tableedit_SetStrDataFromToRow(Win,Send,FrRow,Row,FP,TP,FrCol,ToCol,InD,[Data|Rest],AD,NewData,NS1,NS2):-
	FR = FrRow - 1, Row1 = Row + 1,!, 
	tableedit_SetStrDataFromToRow(Win,Send,FR,Row1,FP,TP,FrCol,ToCol,InD,Rest,[Data|AD],NewData,NS1,NS2).

  tableedit_SplitString(_Win,_Send,_Row,_Col,_FrCol,_ToCol,_,[],AData,ANewData):- tableedit_reverse(AData,[],ANewData),!.
  tableedit_SplitString(Win,Send,Row,Col,FrCol,ToCol,SourceStr,[Data|Rest],AD,NewData):-
	tableedit_CutTabString(SourceStr,StartStr,EndStr),
	tableedit_CliarString(StartStr,DataStr),
	Col >= FrCol, Col <= ToCol,
	tableedit_GridDataToCellData(Win,Col,DataStr,Data,NewOutData),
	tableedit_SendDataModifiedCallback(Win,Send,Row,Col,Data,NewOutData),!,
	C = Col + 1,
	tableedit_SplitString(Win,Send,Row,C,FrCol,ToCol,EndStr,Rest,[NewOutData|AD],NewData).
  tableedit_SplitString(Win,Send,Row,Col,FrCol,ToCol,SourceStr,[Data|Rest],AD,NewData):-
	tableedit_CutTabString(SourceStr,StartStr,EndStr),
	tableedit_CliarString(StartStr,DataStr),
	Col >= FrCol, Col <= ToCol,
	!,
	tableedit_GridDataToCellData(Win,Col,DataStr,Data,_NewOutData),
	C = Col + 1,
	tableedit_SplitString(Win,Send,Row,C,FrCol,ToCol,EndStr,Rest,[Data|AD],NewData).
  tableedit_SplitString(Win,Send,Row,Col,FrCol,ToCol,SourceStr,[Data|Rest],AD,NewData):-!,
	EndStr = SourceStr,
	C = Col + 1,
	tableedit_SplitString(Win,Send,Row,C,FrCol,ToCol,EndStr,Rest,[Data|AD],NewData).

  tableedit_CutTabString(SourceStr,StartStr,EndString):-
	tableedit_searchstring(SourceStr,"\t",Pos),
	tableedit_frontstr(Pos,SourceStr,StartStr,EndString),
	!.
  tableedit_CutTabString(SourceStr,SourceStr,"").

predicates
  procedure tableedit_CliarString1(STRING StartStr,STRING DataStr)

clauses
  tableedit_CliarString(StartStr,DataStr):-
	tableedit_CliarString1(StartStr,S1),
	tableedit_CliarString1(S1,S2),
	tableedit_CliarString1(S2,DataStr),!.

  tableedit_CliarString1(StartStr,DataStr):-
	concat(DataStr,"\r",StartStr),!.
  tableedit_CliarString1(StartStr,DataStr):-
	concat(DataStr,"\t",StartStr),!.
  tableedit_CliarString1(StartStr,DataStr):-
	concat(DataStr,"\n",StartStr),!.
  tableedit_CliarString1(StartStr,StartStr):-!.

predicates
% cut the data according to the list of filters
  procedure  tableedit_CutFilterRows(WINDOW,TABLEEDIT_ORFILTERLIST,TABLEEDIT_ORFILTERLIST,INTEGER Columnm,
		TABLEEDIT_DATA,TABLEEDIT_DATA,TABLEEDIT_DATA,TABLEEDIT_DATA,TABLEEDIT_DATA)
  determ tableedit_CutColumnsFilterRows(WINDOW,TABLEEDIT_DATA,TABLEEDIT_DATA,INTEGER Column,INTEGER MaxColumn,
		TABLEEDIT_DATA,TABLEEDIT_DATA)
  procedure  tableedit_CliarFilters(WINDOW)
  determ tableedit_SetFilters(WINDOW,TABLEEDIT_FILTERS)
  procedure  tableedit_SeparateFilters(WINDOW,TABLEEDIT_ORFILTERLIST,TABLEEDIT_ORFILTERLIST,
		TABLEEDIT_ORFILTERLIST,TABLEEDIT_ORFILTERLIST,TABLEEDIT_ORFILTERLIST)

clauses
% assert empty filter for columns
  tableedit_CliarFilters(Win):-
	tableedit_db_Col_Info(Win,Column,title(_)),
	assert(tableedit_db_Col_Info(Win,Column,filterlist([]))),
	fail.
  tableedit_CliarFilters(_Win):-!.

% Set filters from filter list
  tableedit_SetFilters(Win,[]):- 
	tableedit_ProcessFilter(Win),
	!.
  tableedit_SetFilters(Win,[L1|L2]):-
	L1 = columnfilter(Column,FilterList),
	retract(tableedit_db_Col_Info(Win,Column,filterlist(_))),
	assert(tableedit_db_Col_Info(Win,Column,filterlist(FilterList))),!,
	tableedit_SetFilters(Win,L2).

% filter handling
  tableedit_ProcessFilter(Win):-
	tableedit_db_ShadowData_Info(Win,ShadowData),
	tableedit_db_Data_Info(Win,Data),
	tableedit_CutHeadersFooters(Win,Data,Data1,HeadData,FootData),
	tableedit_InsListRows(Win,0,ShadowData,Data1,[],OutData1),
	trap(MaxColumn = tableedit_MaxCol(Win),_,fail),
	tableedit_CutColumnsFilterRows(Win,OutData1,[],1,MaxColumn,ShadowData1,VisibleData1),
	tableedit_InsHeadersFooters(Win,VisibleData1,NewOutData,HeadData,FootData),
	tableedit_SetAllDataNoSort(Win,NewOutData),
	retractAll(tableedit_db_ShadowData_Info(Win,_)),
	assert(tableedit_db_ShadowData_Info(Win,ShadowData1)),
	!.
  
  tableedit_CutColumnsFilterRows(_Win,VisibleData,ShadowData,Column,MaxColumn,ShadowData,VisibleData):- Column > MaxColumn,!.
  tableedit_CutColumnsFilterRows(Win,Data,ShadowData,Column,MaxColumn,SH,VD):-
	tableedit_db_Col_Info(Win,Column,filterlist(FilterList)),!,
	NextCol = Column + 1,
	tableedit_SeparateFilters(Win,FilterList,[],[],FL,NF),
	tableedit_CutFilterRows(Win,FL,NF,Column,Data,[],ShadowData1,[],VisibleData),
	tableedit_InsListRows(Win,0,ShadowData,ShadowData1,[],ShadowData2),
	tableedit_CutColumnsFilterRows(Win,VisibleData,ShadowData2,NextCol,MaxColumn,SH,VD).

predicates
% check data for filters
  determ tableedit_ChkCellDataForFilter(WINDOW,TABLEEDIT_CELLDATA,TABLEEDIT_ORFILTER)
  determ tableedit_ChkCellDataForFilterList(WINDOW,TABLEEDIT_CELLDATA,TABLEEDIT_ORFILTERLIST,TABLEEDIT_ORFILTERLIST)
  determ tableedit_ChkCellDataForNotFilter(WINDOW,TABLEEDIT_CELLDATA,TABLEEDIT_ORFILTER)
  determ tableedit_ChkCellDataForNotFilterList(WINDOW,TABLEEDIT_CELLDATA,TABLEEDIT_ORFILTERLIST)
  determ tableedit_ChkNotFilters(WINDOW,TABLEEDIT_ORFILTER)
clauses

  tableedit_CutFilterRows(_Win,_FilterList,_NotFilterList,_Column,[],AData,ANewData,CutData,CutNewData):- 
	tableedit_reverse(AData,[],ANewData),
	tableedit_reverse(CutData,[],CutNewData),!.
  tableedit_CutFilterRows(Win,FilterList,NotFilterList,Column,[Data|Rest],AD,NewData,CD,CND):-
	tableedit_member_index(CellData,Data,Column),
	tableedit_ChkCellDataForFilterList(Win,CellData,FilterList,FilterList),
	not(tableedit_ChkCellDataForNotFilterList(Win,CellData,NotFilterList)),!,
	tableedit_CutFilterRows(Win,FilterList,NotFilterList,Column,Rest,AD,NewData,[Data|CD],CND).
  tableedit_CutFilterRows(Win,FilterList,NotFilterList,Column,[Data|Rest],AD,NewData,CD,CND):- !, 
	tableedit_CutFilterRows(Win,FilterList,NotFilterList,Column,Rest,[Data|AD],NewData,CD,CND).
  tableedit_CutFilterRows(_,_,_,_,_,_,[],_,[]):-errorexit().

  tableedit_ChkCellDataForFilterList(_Win,_Val,[],[]):-!.
  tableedit_ChkCellDataForFilterList(Win,Val,[L1|_L2],_):-
	tableedit_ChkCellDataForFilter(Win,Val,L1),!.
  tableedit_ChkCellDataForFilterList(Win,Val,[_L1|L2],Fl):-!,
	tableedit_ChkCellDataForFilterList(Win,Val,L2,Fl).

  tableedit_ChkCellDataForNotFilterList(_Win,_Val,[]):-!,fail.
  tableedit_ChkCellDataForNotFilterList(Win,Val,[L1|_L2]):-
	tableedit_ChkCellDataForNotFilter(Win,Val,L1),!.
  tableedit_ChkCellDataForNotFilterList(Win,Val,[_L1|L2]):-!,
	tableedit_ChkCellDataForNotFilterList(Win,Val,L2).

  tableedit_SeparateFilters(_Win,[],F,NF,F,NF):-!.
  tableedit_SeparateFilters(Win,[L1|L2],F,NF,FX,NFX):-
	not(tableedit_ChkNotFilters(Win,L1)),
	F1 = [L1|F],!,
	tableedit_SeparateFilters(Win,L2,F1,NF,FX,NFX).
  tableedit_SeparateFilters(Win,[L1|L2],F,NF,FX,NFX):-
	F1 = [L1|NF],!,
	tableedit_SeparateFilters(Win,L2,F,F1,FX,NFX).
  tableedit_SeparateFilters(_,_,_,_,[],[]):-errorexit().


  tableedit_ChkNotFilters(_Win,if_not(_)):-!.
  tableedit_ChkNotFilters(_Win,rf_not(_)):-!.
  tableedit_ChkNotFilters(_Win,lf_not(_)):-!.
  tableedit_ChkNotFilters(_Win,s_f_not(_)):-!.
  tableedit_ChkNotFilters(_Win,fvoid_not):-!.

  tableedit_ChkCellDataForFilter(_Win,i(Val),if_min(Min)):- Val >= Min,!.
  tableedit_ChkCellDataForFilter(_Win,i(Val),if_max(Max)):- Val <= Max,!.
  tableedit_ChkCellDataForFilter(_Win,i(Val),if_range(Min,Max)):- Val >= Min, Val <= Max,!.
  tableedit_ChkCellDataForFilter(_Win,ic(Val,_),if_min(Min)):- Val >= Min,!.
  tableedit_ChkCellDataForFilter(_Win,ic(Val,_),if_max(Max)):- Val <= Max,!.
  tableedit_ChkCellDataForFilter(_Win,ic(Val,_),if_range(Min,Max)):- Val >= Min, Val <= Max,!.

  tableedit_ChkCellDataForFilter(_Win,l(Val),lf_min(Min)):- Val >= Min,!.
  tableedit_ChkCellDataForFilter(_Win,l(Val),lf_max(Max)):- Val <= Max,!.
  tableedit_ChkCellDataForFilter(_Win,l(Val),lf_range(Min,Max)):- Val >= Min, Val <= Max,!.
  tableedit_ChkCellDataForFilter(_Win,lc(Val,_),lf_min(Min)):- Val >= Min,!.
  tableedit_ChkCellDataForFilter(_Win,lc(Val,_),lf_max(Max)):- Val <= Max,!.
  tableedit_ChkCellDataForFilter(_Win,lc(Val,_),lf_range(Min,Max)):- Val >= Min, Val <= Max,!.

  tableedit_ChkCellDataForFilter(_Win,r(Val),rf_min(Min)):- Val >= Min,!.
  tableedit_ChkCellDataForFilter(_Win,r(Val),rf_max(Max)):- Val <= Max,!.
  tableedit_ChkCellDataForFilter(_Win,r(Val),rf_range(Min,Max)):- Val >= Min, Val <= Max,!.
  tableedit_ChkCellDataForFilter(_Win,rc(Val,_),rf_min(Min)):- Val >= Min,!.
  tableedit_ChkCellDataForFilter(_Win,rc(Val,_),rf_max(Max)):- Val <= Max,!.
  tableedit_ChkCellDataForFilter(_Win,rc(Val,_),rf_range(Min,Max)):- Val >= Min, Val <= Max,!.
  tableedit_ChkCellDataForFilter(_Win,s(Val),s_f(Str)):- Val = Str,!.
  tableedit_ChkCellDataForFilter(_Win,p(_,_,Val),s_f(Str)):- Val = Str,!.
  tableedit_ChkCellDataForFilter(_Win,sc(Val,_),s_f(Str)):- Val = Str,!.
  tableedit_ChkCellDataForFilter(_Win,void,s_f("")):-!.
  tableedit_ChkCellDataForFilter(_Win,voidc(_),s_f("")):-!.

  tableedit_ChkCellDataForFilter(_Win,s(""),fvoid):-!.
  tableedit_ChkCellDataForFilter(_Win,p(_,_,""),fvoid):-!.
  tableedit_ChkCellDataForFilter(_Win,sc("",_),fvoid):-!.
  tableedit_ChkCellDataForFilter(_Win,void,fvoid):-!.
  tableedit_ChkCellDataForFilter(_Win,voidc(_),fvoid):-!.

  tableedit_ChkCellDataForNotFilter(_Win,i(Val),if_not(EVal)):- Val = EVal,!.
  tableedit_ChkCellDataForNotFilter(_Win,ic(Val,_),if_not(EVal)):- Val = EVal,!.

  tableedit_ChkCellDataForNotFilter(_Win,l(Val),lf_not(EVal)):- Val = EVal,!.
  tableedit_ChkCellDataForNotFilter(_Win,lc(Val,_),lf_not(EVal)):- Val = EVal,!.

  tableedit_ChkCellDataForNotFilter(_Win,r(Val),rf_not(EVal)):- Val = EVal,!.
  tableedit_ChkCellDataForNotFilter(_Win,rc(Val,_),rf_not(EVal)):- Val = EVal,!.

  tableedit_ChkCellDataForNotFilter(_Win,s(Val),s_f_not(EVal)):- Val = EVal,!.
  tableedit_ChkCellDataForNotFilter(_Win,p(_,_,Val),s_f_not(EVal)):- Val = EVal,!.
  tableedit_ChkCellDataForNotFilter(_Win,sc(Val,_),s_f_not(EVal)):- Val = EVal,!.
  tableedit_ChkCellDataForNotFilter(_Win,void,s_f_not(EVal)):- EVal = "",!.
  tableedit_ChkCellDataForNotFilter(_Win,voidc(_),s_f_not(EVal)):- EVal = "",!.

  tableedit_ChkCellDataForNotFilter(_Win,Val,fvoid_not):- Val = void,!.
  tableedit_ChkCellDataForNotFilter(_Win,Val,fvoid_not):- Val = voidc(_),!.
  tableedit_ChkCellDataForNotFilter(_Win,Val,fvoid_not):- Val = s(""),!.
  tableedit_ChkCellDataForNotFilter(_Win,Val,fvoid_not):- Val = p(_,_,""),!.
  tableedit_ChkCellDataForNotFilter(_Win,Val,fvoid_not):- Val = sc("",_),!.

% ============  Sort operations =============

predicates
determ  tableedit_convert_p(TABLEEDIT_CELLDATA,STRING)
clauses
  tableedit_convert_p(p(_,_,Val),Val):-!.
predicates
determ  tableedit_convert_s(TABLEEDIT_CELLDATA,STRING)
clauses
  tableedit_convert_s(s(Val),Val):-!.
  tableedit_convert_s(sc(Val,_),Val):-!.
predicates
determ  tableedit_convert_i(TABLEEDIT_CELLDATA,INTEGER)
clauses
  tableedit_convert_i(i(Val),Val):-!.
  tableedit_convert_i(ic(Val,_),Val):-!.
predicates
determ  tableedit_convert_l(TABLEEDIT_CELLDATA,LONG)
clauses
  tableedit_convert_l(l(Val),Val):-!.
  tableedit_convert_l(lc(Val,_),Val):-!.
predicates
determ  tableedit_convert_r(TABLEEDIT_CELLDATA,REAL)
clauses
  tableedit_convert_r(r(Val),Val):-!.
  tableedit_convert_r(rc(Val,_),Val):-!.

  tableedit_CompareInternal(_,_,_,_,_):-fail.

predicates
  determ tableed_convert_answer(BOOLEAN Ascending,TABLEEDIT_COMPARESTATUS,TABLEEDIT_COMPARESTATUS)
clauses
  tableed_convert_answer(_,equal,equal):-!.
  tableed_convert_answer(b_true,Answer,Answer):-!.
  tableed_convert_answer(b_false,less,more):-!.
  tableed_convert_answer(b_false,more,less):-!.

predicates
  procedure tableed_compare1(TABLEEDIT_COMPARE,WINDOW,INTEGER Column,BOOLEAN Ascending,TABLEEDIT_CELLDATA,TABLEEDIT_CELLDATA,TABLEEDIT_COMPARESTATUS Answer)
clauses
  tableed_compare1(CallBack,Win,Column,Ascending,First,Second,Answer):-
	CallBack(Win,Column,First,Second,Answer1),
	tableed_convert_answer(Ascending,Answer1,Answer),!.
  tableed_compare1(_,_,_,_,CD1,CD2,equal):-
	tableedit_convert_s(CD1,CD11),
	tableedit_convert_s(CD2,CD21),
	CD11 = CD21,!.
  tableed_compare1(_,_,_,_,CD1,CD2,equal):-
	tableedit_convert_p(CD1,CD11),
	tableedit_convert_p(CD2,CD21),
	CD11 = CD21,!.
  tableed_compare1(_,_,_,_,CD1,CD2,equal):-
	tableedit_convert_i(CD1,CD11),
	tableedit_convert_i(CD2,CD21),
	CD11 = CD21,!.
  tableed_compare1(_,_,_,_,CD1,CD2,equal):-
	tableedit_convert_l(CD1,CD11),
	tableedit_convert_l(CD2,CD21),
	CD11 = CD21,!.
  tableed_compare1(_,_,_,_,CD1,CD2,equal):-
	tableedit_convert_r(CD1,CD11),
	tableedit_convert_r(CD2,CD21),
	CD11 = CD21,!.
  tableed_compare1(_,_,_,b_true,CD1,CD2,less):-
	tableedit_convert_s(CD1,CD11),
	tableedit_convert_s(CD2,CD21),
	CD11 < CD21,!.
  tableed_compare1(_,_,_,b_true,CD1,CD2,less):-
	tableedit_convert_p(CD1,CD11),
	tableedit_convert_p(CD2,CD21),
	CD11 < CD21,!.
  tableed_compare1(_,_,_,b_true,CD1,CD2,less):-
	tableedit_convert_i(CD1,CD11),
	tableedit_convert_i(CD2,CD21),
	CD11 < CD21,!.
  tableed_compare1(_,_,_,b_true,CD1,CD2,less):-
	tableedit_convert_l(CD1,CD11),
	tableedit_convert_l(CD2,CD21),
	CD11 < CD21,!.
  tableed_compare1(_,_,_,b_true,CD1,CD2,less):-
	tableedit_convert_r(CD1,CD11),
	tableedit_convert_r(CD2,CD21),
	CD11 < CD21,!.
  tableed_compare1(_,_,_,b_false,CD1,CD2,less):-
	tableedit_convert_s(CD1,CD11),
	tableedit_convert_s(CD2,CD21),
	CD11 > CD21,!.
  tableed_compare1(_,_,_,b_false,CD1,CD2,less):-
	tableedit_convert_p(CD1,CD11),
	tableedit_convert_p(CD2,CD21),
	CD11 > CD21,!.
  tableed_compare1(_,_,_,b_false,CD1,CD2,less):-
	tableedit_convert_i(CD1,CD11),
	tableedit_convert_i(CD2,CD21),
	CD11 > CD21,!.
  tableed_compare1(_,_,_,b_false,CD1,CD2,less):-
	tableedit_convert_l(CD1,CD11),
	tableedit_convert_l(CD2,CD21),
	CD11 > CD21,!.
  tableed_compare1(_,_,_,b_false,CD1,CD2,less):-
	tableedit_convert_r(CD1,CD11),
	tableedit_convert_r(CD2,CD21),
	CD11 > CD21,!.
  tableed_compare1(_,_,_,_,_,_,more).

predicates
  determ tableed_compare_list(TABLEEDIT_COMPARE,WINDOW,INTEGER Column,BOOLEAN Ascendig,ILIST ColumnNumber,TABLEEDIT_COLUMNDATA,TABLEEDIT_COLUMNDATA,TABLEEDIT_COLUMNDATA,TABLEEDIT_COLUMNDATA)
  determ tableed_compare(TABLEEDIT_COMPARE,WINDOW,TABLEEDIT_COMPARESTATUS Answer,BOOLEAN A,ILIST CR,TABLEEDIT_COLUMNDATA CDF1,TABLEEDIT_COLUMNDATA CDF2)
clauses
  tableed_compare_list(_,_,_,_,[],_,_,_,_):-!.
  tableed_compare_list(CallBack,Win,Column,A,[1|CR],CDF1,CDF2,[CD1|_],[CD2|_]):-
	tableed_compare1(CallBack,Win,Column,A,CD1,CD2,Answer),!,
	tableed_compare(CallBack,Win,Answer,A,CR,CDF1,CDF2),!.
  tableed_compare_list(CallBack,Win,Column,A,[CN|CR],CDF1,CDF2,[_|CR1],[_|CR2]):-
	CN1 = CN - 1,!,
	tableed_compare_list(CallBack,Win,Column,A,[CN1|CR],CDF1,CDF2,CR1,CR2).

  tableed_compare(CallBack,Win,equal,A,[Column|Rest],CDF1,CDF2):-
	tableed_compare_list(CallBack,Win,Column,A,[Column|Rest],CDF1,CDF2,CDF1,CDF2),!.
  tableed_compare(_,_,less,_,_,_,_).

predicates
  determ tableed_sort_list2d2(TABLEEDIT_COMPARE,WINDOW,BOOLEAN Ascending,ILIST ColumnNumber,TABLEEDIT_COLUMNDATA A,TABLEEDIT_DATA Input,BOOLEAN Rev,TABLEEDIT_DATA,TABLEEDIT_DATA Output)
clauses
  tableed_sort_list2d2(_,_,_,_,_,Output,b_true,[],Output):-!.
  tableed_sort_list2d2(CallBack,Win,Ascending,ColumnNumber,B,Curr,b_true,[A|Rest],Output):-!,
	tableed_sort_list2d2(CallBack,Win,Ascending,ColumnNumber,B,[A|Curr],b_true,Rest,Output).
  tableed_sort_list2d2(CallBack,Win,Ascending,ColumnNumber,A,[],b_false,Curr,Output):-!,
	tableed_sort_list2d2(CallBack,Win,Ascending,ColumnNumber,A,[A],b_true,Curr,Output).
  tableed_sort_list2d2(CallBack,Win,Ascending,[Column|ColumnRest],A,[B|Rest],b_false,Curr,Output):-
	tableed_compare_list(CallBack,Win,Column,Ascending,[Column|ColumnRest],A,B,A,B),!,
	tableed_sort_list2d2(CallBack,Win,Ascending,[Column|ColumnRest],A,[A,B|Rest],b_true,Curr,Output).
  tableed_sort_list2d2(CallBack,Win,Ascending,ColumnNumber,A,[B|Rest],Rev,Curr,Output):-!,
	tableed_sort_list2d2(CallBack,Win,Ascending,ColumnNumber,A,Rest,Rev,[B|Curr],Output).

predicates
  determ tableed_sort_list2d1(TABLEEDIT_COMPARE,WINDOW,BOOLEAN Ascending,ILIST ColumnNumber,TABLEEDIT_DATA Input,TABLEEDIT_DATA,TABLEEDIT_DATA Output)
clauses
  tableed_sort_list2d1(_,_,_,_,[],Output,Output):-!.
  tableed_sort_list2d1(CallBack,Win,Ascending,ColumnNumber,[A|Rest],Curr,Output):-
	tableed_sort_list2d2(CallBack,Win,Ascending,ColumnNumber,A,Curr,b_false,[],Curr1),
	tableed_sort_list2d1(CallBack,Win,Ascending,ColumnNumber,Rest,Curr1,Output).

  tableedit_sort_data(_,_,_,_,[],[]):-!.
  tableedit_sort_data(_,_,_,_,[A|[]],[A]):-!.
  tableedit_sort_data(Win,CompareFunc,Ascending,ColumnNumber,Input,Output):-
	tableed_sort_list2d1(CompareFunc,Win,Ascending,ColumnNumber,Input,[],Output),!.

% ============ Find operations ===========
predicates
determ tableedit_FindString(WINDOW,STRING,TABLEEDIT_DIRECTION,INTEGER Column,TABLEEDIT_MATCH,BOOLEAN CaseSensitive,INTEGER RowPos)
determ tableedit_FindRow(TABLEEDIT_MATCH,BOOLEAN CaseSensitive,STRING FindStr,TABLEEDIT_DATA DataString,INTEGER,INTEGER RowPosition)
determ tableedit_GetStringData(WINDOW,STRING,TABLEEDIT_DIRECTION,INTEGER Column,TABLEEDIT_MATCH,BOOLEAN,INTEGER Position)
clauses

  tableedit_FindString(Win,Str,Direction,Column,_Match,_CaseSens,RowPosition):-
	not(Column = 0),
	MaxCol = tableedit_MaxCol(Win),
	Column <= MaxCol,
	tableedit_GetStringData(Win,Str,Direction,Column,_Match,_CaseSens,RowPosition),
	!.

  tableedit_GetStringData(Win,Str,alldown,Column,Match,CaseSens,RowPosition):-
	ToRow = tableedit_MaxVisibleRows(Win),
	not(ToRow = 0),
	TEData = tableedit_GetData(Win,1,ToRow,Column,Column),
	tableedit_FindRow(Match,CaseSens,Str,TEData,1,RowPosition),
	!.
  tableedit_GetStringData(Win,Str,down,Column,Match,CaseSens,RowPosition):-
	ToRow = tableedit_MaxVisibleRows(Win),
	not(ToRow = 0),
	ActRow = tableedit_GetActiveRow(Win),
	ActRow <= ToRow, ActRow > 0,
	TEData = tableedit_GetData(Win,ActRow,ToRow,Column,Column),
	tableedit_FindRow(Match,CaseSens,Str,TEData,1,RowPosition1),
	RowPosition = RowPosition1 + ActRow - 1,
	!.
  tableedit_GetStringData(Win,Str,up,Column,Match,CaseSens,RowPosition):-
	ToRow = tableedit_MaxVisibleRows(Win),
	not(ToRow = 0),
	ActRow = tableedit_GetActiveRow(Win),
	ActRow <= ToRow, ActRow > 0,
	TEDataX = tableedit_GetData(Win,1,ActRow,Column,Column),
	tableedit_reverse(TEDataX,[],TEData),
	tableedit_FindRow(Match,CaseSens,Str,TEData,1,RowPosition1),
	RowPosition = ActRow - RowPosition1 + 1,
	!.
  tableedit_GetStringData(Win,Str,allup,Column,Match,CaseSens,RowPosition):-
	ToRow = tableedit_MaxVisibleRows(Win),
	not(ToRow = 0),
	TEDataX = tableedit_GetData(Win,1,ToRow,Column,Column),
	tableedit_reverse(TEDataX,[],TEData),
	tableedit_FindRow(Match,CaseSens,Str,TEData,1,RowPosition1),
	RowPosition = ToRow - RowPosition1 + 1,
	!.

  tableedit_FindRow(_,_,_,[],_,_):-!,fail.
  tableedit_FindRow(from_start,b_true,Str,[[Data]|_],Pos,Pos):-
	tableedit_ConvertDataToString(Data,String),
	searchstring(String,Str,FoundPos),
	FoundPos = 1,!.
  tableedit_FindRow(from_start,b_false,Str,[[Data]|_],Pos,Pos):-
	tableedit_ConvertDataToString(Data,String),
	upper_lower(Str,StrX),
	upper_lower(String,StringX),
	searchstring(StringX,StrX,FoundPos),
	FoundPos = 1,!.
  tableedit_FindRow(any_part,b_true,Str,[[Data]|_],Pos,Pos):-
	tableedit_ConvertDataToString(Data,String),
	searchstring(String,Str,_),!.
  tableedit_FindRow(any_part,b_false,Str,[[Data]|_],Pos,Pos):-
	tableedit_ConvertDataToString(Data,String),
	upper_lower(Str,StrX),
	upper_lower(String,StringX),
	searchstring(StringX,StrX,_),!.
  tableedit_FindRow(entire,b_true,Str,[[Data]|_],Pos,Pos):-
	tableedit_ConvertDataToString(Data,String),
	String = Str,!.
  tableedit_FindRow(entire,b_false,Str,[[Data]|_],Pos,Pos):-
	tableedit_ConvertDataToString(Data,String),
	upper_lower(Str,StrX),
	upper_lower(String,StringX),
	StringX = StrX,!.
  tableedit_FindRow(Where,CaseSent,Str,[_|Rest],P,Pos):-
	NewP = P + 1,!,
	tableedit_FindRow(Where,CaseSent,Str,Rest,NewP,Pos).

%BEGIN_DLG Find
/**************************************************************************
	Creation and event handling for dialog: Find
**************************************************************************/
predicates

  dlg_find_eh : EHANDLER
procedure  tableedit_SetFindParam(WINDOW DlgWin,WINDOW TabWin)
determ  tableedit_ReSetFindParam(WINDOW DlgWin,WINDOW TabWin)
procedure  tableedit_SetStartFindParam(WINDOW TabWin)  
procedure  tableedit_GetFindString(WINDOW TabWin,STRING)
procedure  tableedit_GetFindColumn(WINDOW TabWin,INTEGER Column)
clauses

  tableedit_GetFindString(TabWin,Str):-
	M = tableedit_GetMarker(TabWin),
	M = grid_area_marker([ga(R1,R2,C1,C2)]),
	R1 = R2, C1 = C2,
	Str = tableedit_GetClipBoardData(TabWin,R1,R2,C1,C2),
	!.
  tableedit_GetFindString(TabWin,Str):-
	tableedit_db_FindParam(TabWin,Str,_,_,_,_),
	!.
  tableedit_GetFindString(_TabWin,""):-!.

  tableedit_GetFindColumn(TabWin,C1):-
	M = tableedit_GetMarker(TabWin),
	M = grid_area_marker([ga(R1,R2,C1,C2)]),
	R1 = R2, C1 = C2,
	!.
  tableedit_GetFindColumn(TabWin,C1):-
	M = tableedit_GetMarker(TabWin),
	M = grid_col_marker([gl(C1,C2)]),
	C1 = C2,
	!.
  tableedit_GetFindColumn(TabWin,C1):-
	tableedit_db_FindParam(TabWin,_,_,C1,_,_),
	!.
  tableedit_GetFindColumn(_TabWin,1):-!.

  tableedit_SetStartFindParam(TabWin):-  
	not(tableedit_db_FindParam(TabWin,_,_,_,_,_)),
	tableedit_GetFindString(TabWin,Str),
	tableedit_GetFindColumn(TabWin,Column),
	retractAll(tableedit_db_FindParam(TabWin,_,_,_,_,_)),
	assert(tableedit_db_FindParam(TabWin,Str,alldown,Column,entire,b_false)),
	!.
  tableedit_SetStartFindParam(TabWin):-  
	tableedit_db_FindParam(TabWin,_,D,_,M,CS),
	tableedit_GetFindString(TabWin,Str),
	tableedit_GetFindColumn(TabWin,Column),
	retractAll(tableedit_db_FindParam(TabWin,_,_,_,_,_)),
	assert(tableedit_db_FindParam(TabWin,Str,D,Column,M,CS)),
	!.
  tableedit_SetStartFindParam(_TabWin):-errorexit().

predicates
procedure  tableedit_SetTitles(WINDOW TabWin,WINDOW CtrlWin,INTEGER,INTEGER,INTEGER MaxColumn)
clauses
  tableedit_SetTitles(_TabWin,_CtrlWin,_DlgItem,Col,MaxCol):-Col>MaxCol,!.
  tableedit_SetTitles(TabWin,CtrlWin,DlgItem1,Col1,MaxCol):-
	CProp = tableedit_GetColumnProperties(TabWin,Col1),
	tableedit_member(width(W),CProp), not(W = 0),
	tableedit_member(title(TitleStr),CProp),!,
	lbox_Add(CtrlWin,TitleStr),
	assert(tableedit_db_FindDlgParam(TabWin,Col1,DlgItem1)),
	Col2 = Col1 + 1,
	DlgItem2 = DlgItem1 + 1,
	tableedit_SetTitles(TabWin,CtrlWin,DlgItem2,Col2,MaxCol).
  tableedit_SetTitles(TabWin,CtrlWin,DlgItem,Col1,MaxCol):-
	Col2 = Col1 + 1,!,
	tableedit_SetTitles(TabWin,CtrlWin,DlgItem,Col2,MaxCol).
  tableedit_SetTitles(_,_,_,_,_):-errorexit().
predicates
determ  tableedit_GetDirection(TABLEEDIT_DIRECTION,WINLIST,WINLIST,WINLIST)
determ  tableedit_GetMatchWin(TABLEEDIT_MATCH,WINLIST,WINDOW)
clauses

  tableedit_GetDirection(allup,[W1,_W2],[W3,_W4],[W1,W3]):-!.
  tableedit_GetDirection(alldown,[W1,_W2],[_W3,W4],[W1,W4]):-!.
  tableedit_GetDirection(up,[_W1,W2],[W3,_W4],[W2,W3]):-!.
  tableedit_GetDirection(down,[_W1,W2],[_W3,W4],[W2,W4]):-!.

  tableedit_GetMatchWin(from_start,[W1,_W2,_W3],W1):-!.
  tableedit_GetMatchWin(entire,[_W1,W2,_W3],W2):-!.
  tableedit_GetMatchWin(any_part,[_W1,_W2,W3],W3):-!.

predicates
procedure tableedit_ReSetFindStr(WINDOW DlgWin,WINDOW TabWin)
determ tableedit_ReSetFindColumn(WINDOW DlgWin,WINDOW TabWin)
procedure tableedit_ReSetFindCase(WINDOW DlgWin,WINDOW TabWin)
procedure tableedit_ReSetFindDirection(WINDOW DlgWin,WINDOW TabWin)
procedure tableedit_ReSetFindMatch(WINDOW DlgWin,WINDOW TabWin)
clauses

  tableedit_ReSetFindStr(DlgWin,TabWin):-
	CtrlWin = win_GetCtlHandle(DlgWin,con_findstr),
	Str = win_GetText(CtrlWin),
	retract(tableedit_db_FindParam(TabWin,_,Direct,Column,Match,CaseSens)),
	assert(tableedit_db_FindParam(TabWin,Str,Direct,Column,Match,CaseSens)),
	!.
  tableedit_ReSetFindStr(_,_):-errorexit().

  tableedit_ReSetFindColumn(DlgWin,TabWin):-
	CtrlWin = win_GetCtlHandle(DlgWin,con_findcolumn),
	lbox_GetSel(CtrlWin,_,SelList), SelList = [Sel],
	tableedit_db_FindDlgParam(TabWin,Column,Sel),
	retract(tableedit_db_FindParam(TabWin,Str,Direct,_,Match,CaseSens)),
	assert(tableedit_db_FindParam(TabWin,Str,Direct,Column,Match,CaseSens)),
	!.

  tableedit_ReSetFindCase(DlgWin,TabWin):-
	CtrlWin = win_GetCtlHandle(DlgWin,con_Casesensitive),
	CheckState = win_IsChecked(CtrlWin),
	CaseSens = val(BOOLEAN,CheckState),
	retract(tableedit_db_FindParam(TabWin,Str,Direct,Column,Match,_)),
	assert(tableedit_db_FindParam(TabWin,Str,Direct,Column,Match,CaseSens)),
	!.
  tableedit_ReSetFindCase(_,_):-errorexit().

predicates
determ tableedit_GetCheckWins2(WINLIST,WINDOW)
determ tableedit_GetCheckWins3(WINLIST,WINDOW)
clauses

  tableedit_ReSetFindDirection(DlgWin,TabWin):-
	CtrlWin1 = win_GetCtlHandle(DlgWin,con_rb_entire),
	CtrlWin2 = win_GetCtlHandle(DlgWin,con_rb_from),
	CtrlWin3 = win_GetCtlHandle(DlgWin,con_rb_backward),
	CtrlWin4 = win_GetCtlHandle(DlgWin,con_rb_forward),
	WinL1 = [CtrlWin1,CtrlWin2],
	WinL2 = [CtrlWin3,CtrlWin4],
	tableedit_GetCheckWins2(WinL1,CWin1),
	tableedit_GetCheckWins2(WinL2,CWin2),
	tableedit_GetDirection(Direction,WinL1,WinL2,[CWin1,CWin2]),
	retract(tableedit_db_FindParam(TabWin,Str,_,Column,Match,CaseSens)),
	assert(tableedit_db_FindParam(TabWin,Str,Direction,Column,Match,CaseSens)),
	!.
  tableedit_ReSetFindDirection(_,_):-errorexit().

  tableedit_GetCheckWins2([W1,_W2],W1):- CheckState = win_IsChecked(W1), CheckState = checkbox_on,!.
  tableedit_GetCheckWins2([_W1,W2],W2):- CheckState = win_IsChecked(W2), CheckState = checkbox_on,!.

  tableedit_GetCheckWins3([W1,_W2,_W3],W1):- CheckState = win_IsChecked(W1), CheckState = checkbox_on,!.
  tableedit_GetCheckWins3([_W1,W2,_W3],W2):- CheckState = win_IsChecked(W2), CheckState = checkbox_on,!.
  tableedit_GetCheckWins3([_W1,_W2,W3],W3):- CheckState = win_IsChecked(W3), CheckState = checkbox_on,!.

  tableedit_ReSetFindMatch(DlgWin,TabWin):-
	CtrlWin1 = win_GetCtlHandle(DlgWin,con_fromstart),
	CtrlWin2 = win_GetCtlHandle(DlgWin,con_entirestring),
	CtrlWin3 = win_GetCtlHandle(DlgWin,con_anypart),
	WinL = [CtrlWin1,CtrlWin2,CtrlWin3],
	tableedit_GetCheckWins3(WinL,CWin),
	tableedit_GetMatchWin(Match,WinL,CWin),
	retract(tableedit_db_FindParam(TabWin,Str,Direction,Column,_,CaseSens)),
	assert(tableedit_db_FindParam(TabWin,Str,Direction,Column,Match,CaseSens)),
	!.
  tableedit_ReSetFindMatch(_,_):-errorexit().
	
  tableedit_ReSetFindParam(DlgWin,TabWin):-
	tableedit_ReSetFindStr(DlgWin,TabWin),
	tableedit_ReSetFindColumn(DlgWin,TabWin),
	tableedit_ReSetFindCase(DlgWin,TabWin),
	tableedit_ReSetFindDirection(DlgWin,TabWin),
	tableedit_ReSetFindMatch(DlgWin,TabWin),
	!.
  tableedit_ReSetFindParam(_,_):-
	dlg_Note(tableedit_con_find,tableedit_con_ColumnNote),
	!,fail.

  tableedit_SetFindParam(DlgWin,TabWin):-
	tableedit_db_FindParam(TabWin,Str,_,_,_,_),
	CtrlWin = win_GetCtlHandle(DlgWin,con_findstr),
	win_SetText(CtrlWin,Str),
	fail.
  tableedit_SetFindParam(DlgWin,TabWin):-
	tableedit_db_FindParam(TabWin,_,_,Column,_,_),
	CtrlWin = win_GetCtlHandle(DlgWin,con_findcolumn),
	MaxCol = tableedit_MaxCol(TabWin),
	retractAll(tableedit_db_FindDlgParam(TabWin,_,_)),
	tableedit_SetTitles(TabWin,CtrlWin,0,1,MaxCol),
	tableedit_db_FindDlgParam(TabWin,Column,Sel),
	lbox_SetSel(CtrlWin,Sel,b_true),
	fail.
  tableedit_SetFindParam(DlgWin,TabWin):-
	tableedit_db_FindParam(TabWin,_,_,_,_,CaseSensitive),
	CtrlWin = win_GetCtlHandle(DlgWin,con_Casesensitive),
	Check = val(INTEGER,CaseSensitive),
	win_Check(CtrlWin,Check),
	fail.
  tableedit_SetFindParam(DlgWin,TabWin):-
	tableedit_db_FindParam(TabWin,_,Direction,_,_,_),
	CtrlWin1 = win_GetCtlHandle(DlgWin,con_rb_entire),
	CtrlWin2 = win_GetCtlHandle(DlgWin,con_rb_from),
	CtrlWin3 = win_GetCtlHandle(DlgWin,con_rb_backward),
	CtrlWin4 = win_GetCtlHandle(DlgWin,con_rb_forward),
	WinL1 = [CtrlWin1,CtrlWin2],
	WinL2 = [CtrlWin3,CtrlWin4],
	tableedit_GetDirection(Direction,WinL1,WinL2,[CWin1,CWin2]),
	win_CheckRadioButton(CWin1,WinL1),
	win_CheckRadioButton(CWin2,WinL2),
	fail.
  tableedit_SetFindParam(DlgWin,TabWin):-
	tableedit_db_FindParam(TabWin,_,_,_,Match,_),
	CtrlWin1 = win_GetCtlHandle(DlgWin,con_fromstart),
	CtrlWin2 = win_GetCtlHandle(DlgWin,con_entirestring),
	CtrlWin3 = win_GetCtlHandle(DlgWin,con_anypart),
	WinL = [CtrlWin1,CtrlWin2,CtrlWin3],
	tableedit_GetMatchWin(Match,WinL,CtrlWin),
	win_CheckRadioButton(CtrlWin,WinL),
	fail.
  tableedit_SetFindParam(_,_):-!.
predicates
procedure  tableedit_HandleFind(WINDOW TabWin)
procedure  tableedit_CheckPermisionMarker(WINDOW TabWin,INTEGER Row,INTEGER Column)
clauses
  tableedit_HandleFind(TabWin):-
	tableedit_db_FindParam(TabWin,Str,Direction,Column,Match,CaseSens),
	tableedit_SendCallback(TabWin,find(Str,Direction,Column,Match,CaseSens,b_false)),
	!.
  tableedit_HandleFind(TabWin):-
	tableedit_db_Te_Info(TabWin,bufferingmode(nobuffering)),
	tableedit_db_FindParam(TabWin,Str,Direction,Column,Match,CaseSens),
	Row = tableedit_Find(TabWin,Str,Direction,Column,Match,CaseSens),
	tableedit_SetActiveRow(TabWin,Row),
	tableedit_CheckPermisionMarker(TabWin,Row,Column),
	!.
  tableedit_HandleFind(TabWin):-
	tableedit_db_Te_Info(TabWin,bufferingmode(nobuffering)),
	tableedit_db_FindParam(TabWin,_Str,_Direction,_Column,_Match,_CaseSens),
	dlg_Note(tableedit_con_find,tableedit_con_Notfind),
	!.
  tableedit_HandleFind(_):-!.

  tableedit_CheckPermisionMarker(TabWin,Row,Column):-
	not(tableedit_db_Te_Info(TabWin,areamarker(none))),
	not(tableedit_SendCallback(TabWin,action(area_marker_beg(Row,Column)))),
	not(tableedit_SendCallback(TabWin,marker(grid_area_marker([ga(Row,Row,Column,Column)]),1))),
	tableedit_SetMarker(TabWin,grid_area_marker([ga(Row,Row,Column,Column)])),
	!.
  tableedit_CheckPermisionMarker(TabWin,_Row,_Column):-
	tableedit_SetMarker(TabWin,grid_no_marker),
	!. 

predicates
procedure  tableedit_GetNewNextDirecton(TABLEEDIT_DIRECTION,TABLEEDIT_DIRECTION,INTEGER Row,INTEGER NewRow)
clauses

  tableedit_GetNewNextDirecton(alldown,down,Row,NewRow):-NewRow = Row + 1,!.
  tableedit_GetNewNextDirecton(allup,up,Row,NewRow):-NewRow = Row - 1,!.
  tableedit_GetNewNextDirecton(down,down,Row,NewRow):-NewRow = Row + 1,!.
  tableedit_GetNewNextDirecton(up,up,Row,NewRow):-NewRow = Row - 1,!.
  tableedit_GetNewNextDirecton(D,D,Row,Row):-errorexit().
	
  tableedit_find_Next(TabWin):-
	tableedit_db_FindParam(TabWin,Str,Direction,Column,Match,CaseSens),
	tableedit_db_FindDlgParam(TabWin,Column,_),
	tableedit_GetNewNextDirecton(Direction,NewDirection,1,_),
	tableedit_SendCallback(TabWin,find(Str,NewDirection,Column,Match,CaseSens,b_true)),
	!.
  tableedit_find_Next(TabWin):-
	tableedit_db_Te_Info(TabWin,bufferingmode(nobuffering)),
	tableedit_db_FindParam(TabWin,Str,Direction,Column,Match,CaseSens),
	tableedit_db_FindDlgParam(TabWin,Column,_),
	trap(win_SetFocus(TabWin),_,fail),
	Row = tableedit_GetActiveRow(TabWin),
	tableedit_GetNewNextDirecton(Direction,NewDirection,Row,NextRow),
	MaxVisibleRow = tableedit_MaxVisibleRows(TabWin),
	NextRow <= MaxVisibleRow, NextRow > 0,
	tableedit_SetActiveRow(TabWin,NextRow),
	FindRow = tableedit_Find(TabWin,Str,NewDirection,Column,Match,CaseSens),
	tableedit_SetActiveRow(TabWin,FindRow),
	tableedit_CheckPermisionMarker(TabWin,FindRow,Column),
	!.
  tableedit_find_Next(TabWin):-
	tableedit_db_Te_Info(TabWin,bufferingmode(nobuffering)),
	tableedit_db_FindParam(TabWin,_Str,_Direction,Column,_Match,_CaseSens),
	tableedit_db_FindDlgParam(TabWin,Column,_),
	trap(win_SetFocus(TabWin),_,fail),
	dlg_Note(tableedit_con_find,tableedit_con_Notfind),
	!.
  tableedit_find_Next(TabWin):-
	tableedit_db_Te_Info(TabWin,bufferingmode(nobuffering)),
	tableedit_db_FindParam(TabWin,_Str,_Direction,Column,_Match,_CaseSens),
	not(tableedit_db_FindDlgParam(TabWin,Column,_)),
	trap(win_SetFocus(TabWin),_,fail),
	dlg_Note(tableedit_con_find,tableedit_con_ColumnNote),
	!.
  tableedit_find_Next(_):-!.
		
  tableedit_dlg_find_Create(TabWin):-
	tableedit_SetStartFindParam(TabWin),
	win_CreateDynDialog(TabWin,
		[
		 dlg(wdef(dlg_find_DlgType,dlg_find_RCT,dlg_find_Title,u_DlgBase),dlg_find_Flags),
		 ctl(wdef(wc_Edit,rct(60,5,190,17),"",u_DlgBase),con_findstr,[wsf_Group,wsf_TabStop,wsf_AutoHScroll,wsf_AlignLeft]),
		 ctl(wdef(wc_RadioButton,rct(9,29,64,39),tableedit_con_Scope,u_DlgBase),con_rb_entire,[wsf_TabStop,wsf_Auto,wsf_Group]),
		 ctl(wdef(wc_RadioButton,rct(9,40,64,50),tableedit_con_FromPoiter,u_DlgBase),con_rb_from,[wsf_TabStop,wsf_Auto]),
		 ctl(wdef(wc_RadioButton,rct(68,29,123,39),tableedit_con_Forward,u_DlgBase),con_rb_forward,[wsf_Auto,wsf_TabStop,wsf_Group]),
		 ctl(wdef(wc_RadioButton,rct(68,40,123,50),tableedit_con_Backward,u_DlgBase),con_rb_backward,[wsf_Auto,wsf_TabStop]),
		 ctl(wdef(wc_RadioButton,rct(129,30,189,40),tableedit_con_Entirestring,u_DlgBase),con_entirestring,[wsf_Auto,wsf_TabStop,wsf_Group]),
		 ctl(wdef(wc_RadioButton,rct(129,41,189,51),tableedit_con_Fromstart,u_DlgBase),con_fromstart,[wsf_TabStop,wsf_Auto]),
		 ctl(wdef(wc_RadioButton,rct(129,52,189,62),tableedit_con_Anypart,u_DlgBase),con_anypart,[wsf_TabStop,wsf_Auto]),
		 ctl(wdef(wc_LBoxButton,rct(6,72,121,140),"",u_DlgBase),con_findcolumn,[wsf_Group,wsf_TabStop,wsf_VScroll]),
		 ctl(wdef(wc_CheckBox,rct(126,72,200,82),tableedit_con_Casesensitive,u_DlgBase),con_Casesensitive,[wsf_Group,wsf_TabStop,wsf_Auto]),
		 ctl(wdef(wc_PushButton,rct(60,91,100,103),tableedit_con_find,u_DlgBase),idc_ok,[wsf_Default,wsf_Group,wsf_TabStop]),
		 ctl(wdef(wc_PushButton,rct(108,91,148,103),tableedit_con_Cancel,u_DlgBase),idc_cancel,[wsf_Group,wsf_TabStop]),
		 ctl(wdef(wc_Text,rct(6,58,54,68),tableedit_con_Columns,u_DlgBase),con_static_text,[wsf_AlignLeft]),
		 ctl(wdef(wc_Text,rct(6,6,56,16),tableedit_con_What,u_DlgBase),con_static_text1,[wsf_AlignLeft]),
		 ctl(wdef(wc_GroupBox,rct(6,19,65,55),tableedit_con_Origin,u_DlgBase),con_groupbox,[]),
		 ctl(wdef(wc_GroupBox,rct(67,19,125,55),tableedit_con_Diretion,u_DlgBase),con_groupbox1,[]),
		 ctl(wdef(wc_GroupBox,rct(127,19,190,66),tableedit_con_Match,u_DlgBase),con_groupbox2,[])
		],dlg_find_eh,0),
	!.
domains
  TABLEEDIT_CTLIDLIST = CTLID*
predicates
  procedure tableedit_set_FontList(WINLIST,FONT)
  procedure WINLIST tableedit_get_CtlHandleList(WINDOW ParentWin,TABLEEDIT_CTLIDLIST)
clauses
  tableedit_get_CtlHandleList(_,[],[]):-!.
  tableedit_get_CtlHandleList(ParentWin,[CtrlId|T1],[CtrlWin|T2]):-
	CtrlWin = win_GetCtlHandle(ParentWin,CtrlId),!,
	T2 = tableedit_get_CtlHandleList(ParentWin,T1).
  tableedit_get_CtlHandleList(_,_,[]):-errorexit.

  tableedit_set_FontList([],_):-!.
  tableedit_set_FontList([CtrlWin|T],Font):-
	win_SetFont(CtrlWin,Font),
	win_SetState(CtrlWin,[wsf_Visible]),!,
	tableedit_set_FontList(T,Font).
  tableedit_set_FontList(_,_):-errorexit.

  dlg_find_eh(DlgWin,e_Create(_),0):-!,
	TabWin=win_GetParent(DlgWin),
	tableedit_SetFindParam(DlgWin,TabWin),
	CtrlWin = win_GetCtlHandle(DlgWin,con_findstr),
	win_SetFocus(CtrlWin),
	win_SelectText (CtrlWin,0,500),
	trap(Font = win_GetFont(TabWin),_,fail),
	FontSize = 9,
	trap(Font1 = font_SetAttrs(Font,[fs_Bold],FontSize),_,fail),
	CtlHandleList1 = tableedit_get_CtlHandleList(DlgWin,[con_findstr,con_rb_entire,con_rb_from,con_rb_forward,con_rb_backward,con_entirestring,con_fromstart,con_anypart,con_findcolumn,con_Casesensitive,idc_ok,idc_cancel,con_static_text,con_static_text1,con_groupbox,con_groupbox1,con_groupbox2]),
	tableedit_set_FontList(CtlHandleList1,Font1),
	!,fail.
  dlg_find_eh(DlgWin,e_Control(idc_ok,_CtrlType,_CtrlWin,_CtrlInfo),0):-!,
	TabWin=win_GetParent(DlgWin),
	tableedit_ReSetFindParam(DlgWin,TabWin),
	tableedit_HandleFind(TabWin),
	win_Destroy(DlgWin),
	trap(win_SetFocus(TabWin),_,fail),
	!.
  dlg_find_eh(DlgWin,e_Control(idc_cancel,_CtrlType,_CtrlWin,_CtrlInfo),0):-!,
	win_Destroy(DlgWin),
	!.
  dlg_find_eh(_,_,_):-!,fail.

  
  
