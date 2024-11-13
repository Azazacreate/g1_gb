/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S 

 FileName:	TABLEED2.PRO
 Purpose:	Module for Table Editor object
 Written by:	Andrey Skobelev
 Version:	1.0
 Build:		009.981112
 Tested with:   Visual Prolog v.5.1 build 555a
 Comments:	
******************************************************************************/
predicates
% reverse
  procedure  tableedit_reverse(MENU_ITEM_LIST,MENU_ITEM_LIST,MENU_ITEM_LIST)
  procedure  tableedit_reverse(TABLEEDIT_DATA,TABLEEDIT_DATA,TABLEEDIT_DATA)
  procedure  tableedit_reverse(TABLEEDIT_COLUMNDATA,TABLEEDIT_COLUMNDATA,TABLEEDIT_COLUMNDATA)
  procedure  tableedit_reverse(GRIDLIST2D,GRIDLIST2D,GRIDLIST2D)
  procedure  tableedit_reverse(GRIDLIST,GRIDLIST,GRIDLIST)
  procedure  tableedit_DelMenuItems(MENU_ITEM_LIST,MENU_ITEM_LIST,MENU_ITEM_LIST)

CLAUSES
  tableedit_DelMenuItems([],LOut1,LOut2):-
	LOut1 = [separator | Rest],
	tableedit_reverse(Rest,[],LOut2),
	!.
  tableedit_DelMenuItems([],LOut1,LOut2):-
	tableedit_reverse(LOut1,[],LOut2),
	!.
  tableedit_DelMenuItems([L1 | L2],LOut,L):-
	L1 = txt(_,_,_,b_true,_,_),!,
	tableedit_DelMenuItems(L2,[L1 | LOut],L).
  tableedit_DelMenuItems([L1 | L2],LOut,L):-
	L1 = separator,
	LOut = [X|_],
	not(X = separator),!,
	tableedit_DelMenuItems(L2,[L1 | LOut],L).
  tableedit_DelMenuItems([_L1 | L2],LOut,L):-!,
	tableedit_DelMenuItems(L2,LOut,L).
  tableedit_DelMenuItems(_,_,_):-errorexit().

  tableedit_CreateMenu(Win,X,Y):-
  	grid_get_pos(Win,X,Y,Row,Column),
	not(tableedit_SendCallback(Win,menu_beg(Row,Column))),
	tableedit_CurWait(Win,b_true),
	tableedit_GetPossibilityCopy(Win,PossCopy,_),
	tableedit_GetPossibilityCut(Win,PossCut,_),
	tableedit_GetPossibilityPaste(Win,PossPast,_),
	tableedit_GetPossibilitySort(Win,PossS,_),
	tableedit_GetPossibilityFilter(Win,b_true,PossFEx,_),
	tableedit_GetPossibilityFilter(Win,b_false,PossFBy,_),
	tableedit_GetPossibilityInsRow(Win,_,PossIns),
	tableedit_GetPossibilityDelRow(Win,PossDel,_),
	tableedit_GetPossibilityShowRow(Win,ShowAll),
	tableedit_GetPossibilityUndo(Win,PossUndo),
	tableedit_GetPossibilityRedo(Win,PossRedo),
	tableedit_GetPossibilityFindNext(Win,PossFindNext),
	tableedit_GetPossibilityFind(Win,PossFind),
	MList = [txt(tableedit_MenuId18,tableedit_con_undotext,3,PossUndo,mis_None,[]),
		 txt(tableedit_MenuId19,tableedit_con_redotext,3,PossRedo,mis_None,[]),
		 separator,
		 txt(tableedit_MenuId6,tableedit_con_copytext,3,PossCopy,mis_None,[]),
		 txt(tableedit_MenuId7,tableedit_con_pastetext,22,PossPast,mis_None,[]),
		 txt(tableedit_MenuId8,tableedit_con_cuttext,24,PossCut,mis_None,[]),
		 separator,
		 txt(tableedit_MenuId9,tableedit_con_sortAtext,19,PossS,mis_None,[]),
		 txt(tableedit_MenuId11,tableedit_con_sortDtext,19,PossS,mis_None,[]),
		 separator,
		 txt(tableedit_MenuId1,tableedit_con_filterStext,19,PossFBy,mis_None,[]),
		 txt(tableedit_MenuId3,tableedit_con_filterEtext,19,PossFEx,mis_None,[]),
		 txt(tableedit_MenuId5,tableedit_con_showRowstext,19,ShowAll,mis_None,[]),
		 separator,
		 txt(tableedit_MenuId14,tableedit_con_insRowtext,k_ins,PossIns,mis_None,[]),
		 txt(tableedit_MenuId16,tableedit_con_delRowtext,k_del,PossDel,mis_None,[]),
		 separator,
		 txt(tableedit_MenuId22,tableedit_con_find,19,PossFind,mis_None,[]),
		 txt(tableedit_MenuId23,tableedit_con_findnext,19,PossFindNext,mis_None,[])
		],
	tableedit_DelMenuItems(MList,[],OutMList),
	tableedit_AppendToMenu(Win,OutMList,OutMenuList),
	not(OutMenuList=[]),
	tableedit_CurWait(Win,b_false),
	menu_PopUp(Win,dyn_menu(OutMenuList),pnt(X,Y),align_Left),
	!.
  tableedit_CreateMenu(Win,_,_):-
	tableedit_CurWait(Win,b_false),!.

predicates
%Create filter list from area list
  procedure  tableedit_CreateAreaFilter1(WINDOW,BOOLEAN Exclude,GRID_AREALIST,INTEGER Column,INTEGER MaxColumn,
			      TABLEEDIT_FILTERS,TABLEEDIT_FILTERS)
  procedure  tableedit_CreateAreaFilter2(WINDOW,BOOLEAN Exclude,GRID_AREALIST,INTEGER Column,
			      TABLEEDIT_ORFILTERLIST,TABLEEDIT_ORFILTERLIST)
  procedure  tableedit_CreateAreaFilter3(WINDOW,BOOLEAN Exclude,GRID_AREA,INTEGER Column,
			      TABLEEDIT_ORFILTERLIST,TABLEEDIT_ORFILTERLIST)
  procedure  tableedit_CreateAreaFilter4(WINDOW,BOOLEAN Exclude,GRID_AREA,INTEGER Column,
			      TABLEEDIT_ORFILTERLIST,TABLEEDIT_ORFILTERLIST)

clauses

  tableedit_CreateAreaFilter(Win,Exclude,Gal,Filters):-
	MaxCol = tableedit_MaxCol(Win),
	tableedit_CreateAreaFilter1(Win,Exclude,Gal,1,MaxCol,[],Filters),!.

  tableedit_CreateAreaFilter1(_Win,_Exclude,_Gal,Col,MaxCol,F,F):- Col > MaxCol,!.
  tableedit_CreateAreaFilter1(Win,Exclude,Gal,Col,MaxCol,IFL,OF):-!,
	tableedit_CreateAreaFilter2(Win,Exclude,Gal,Col,[],FL),
	IFL1 = [columnfilter(Col,FL) | IFL],
	NextCol = Col + 1,
	tableedit_CreateAreaFilter1(Win,Exclude,Gal,NextCol,MaxCol,IFL1,OF).

  tableedit_CreateAreaFilter2(_Win,_Exclude,[],_,F,F):-!.
  tableedit_CreateAreaFilter2(Win,Exclude,[L1|L2],Col,InFl,OF):-!,
	tableedit_CreateAreaFilter3(Win,Exclude,L1,Col,InFl,OutFL),
	tableedit_CreateAreaFilter2(Win,Exclude,L2,Col,OutFL,OF).
  tableedit_CreateAreaFilter2(_,_,_,_,_,[]):-!.

  tableedit_CreateAreaFilter3(Win,Exclude,Ga,Col,InFl,OutFL):-
	Ga = ga(_FromRow,_ToRow,FromCol,ToCol), Col >= FromCol, Col <= ToCol,
	tableedit_CreateAreaFilter4(Win,Exclude,Ga,Col,InFl,OutFL),!.
  tableedit_CreateAreaFilter3(_Win,_Exclude,_Ga,_Col,InFl,InFl):-!.
	
  tableedit_CreateAreaFilter4(_Win,_Exclude,ga(Row,ToRow,_FromCol,_ToCol),_Col,Fl,Fl):- Row > ToRow,!.
  tableedit_CreateAreaFilter4(Win,Exclude,ga(Row,ToRow,_FromCol,_ToCol),Col,InFl,OutFL):-
	CellData = tableedit_GetCellData(Win,Row,Col),
	tableedit_CellDataToFilterData(CellData,Exclude,FdataList), FdataList = [Fdata],!,
	InFl1 = [Fdata | InFl],
	Row1 = Row + 1,
	tableedit_CreateAreaFilter4(Win,Exclude,ga(Row1,ToRow,_FromCol,_ToCol),Col,InFl1,OutFL).
  tableedit_CreateAreaFilter4(_,_,_,_,_,[]):-errorExit().

% e_CloseRequest() handling
  tableedit_HandleEvent1(Win,e_CloseRequest()):-!,
	tableedit_SendCallback(Win,closerequest()),
	!.
% e_Destroy() handling
  tableedit_HandleEvent1(Win,e_Destroy()):-
	retractAll(tableedit_db_Te_Info(Win,_)),
	retractAll(tableedit_db_Col_Info(Win,_,_)),
	retractAll(tableedit_db_Data_Info(Win,_)),
  	retractAll(tableedit_db_DataBufRange(Win,_,_)),
	retractAll(tableedit_db_ShadowData_Info(Win,_)),
	tableedit_CliarUndoRedoData(Win),
  	retractAll(tableedit_db_PasteError(Win)),
	retractAll(tableedit_db_InitMode(Win)),
	retractAll(tableedit_db_UndoAction(Win)),
	!.
% e_MouseDown handling (create menu)
  tableedit_HandleEvent1(Win,e_MouseUp(pnt(X,Y),c_Nothing,mouse_button_right)):-
	tableedit_CreateMenu(Win,X,Y),
	!.
% win_PostEvent to "Undo"
  tableedit_HandleEvent1(Win,e_Menu(tableedit_MenuId18,_)):-
	win_PostEvent(Win,e_Menu(tableedit_MenuId20,c_Nothing)),
	!.
% "Undo"
  tableedit_HandleEvent1(Win,e_Menu(tableedit_MenuId20,_)):-
	tableedit_db_Te_Info(Win,bufferingmode(nobuffering)),
	not(tableedit_SendCallback(Win,undo())),
	tableedit_CurWait(Win,b_true),
	tableedit_Undo(Win),
	tableedit_CurWait(Win,b_false),
	!.
  tableedit_HandleEvent1(Win,e_Menu(tableedit_MenuId20,_)):-
	tableedit_db_Te_Info(Win,bufferingmode(buffering(_AnsFunc,_RowBuffSize,_MaxRows))),
	not(tableedit_SendCallback(Win,undo())),
	!.
  tableedit_HandleEvent1(Win,e_Menu(tableedit_MenuId20,_)):-
	tableedit_CurWait(Win,b_false),
	!.

% win_PostEvent to "Redo"
  tableedit_HandleEvent1(Win,e_Menu(tableedit_MenuId19,_)):-
	win_PostEvent(Win,e_Menu(tableedit_MenuId21,c_Nothing)),
	!.
% "Redo"
  tableedit_HandleEvent1(Win,e_Menu(tableedit_MenuId21,_)):-
	tableedit_db_Te_Info(Win,bufferingmode(nobuffering)),
	not(tableedit_SendCallback(Win,redo())),
	tableedit_CurWait(Win,b_true),
	tableedit_Redo(Win),
	tableedit_CurWait(Win,b_false),
	!.
  tableedit_HandleEvent1(Win,e_Menu(tableedit_MenuId21,_)):-
	tableedit_db_Te_Info(Win,bufferingmode(buffering(_AnsFunc,_RowBuffSize,_MaxRows))),
	not(tableedit_SendCallback(Win,redo())),
	!.
  tableedit_HandleEvent1(Win,e_Menu(tableedit_MenuId21,_)):-
	tableedit_CurWait(Win,b_false),
	!.

% win_PostEvent to "Filter by selection"
  tableedit_HandleEvent1(Win,e_Menu(tableedit_MenuId1,_)):-
	win_PostEvent(Win,e_Menu(tableedit_MenuId2,c_Nothing)),
	!.
% "Filter by selection"
  tableedit_HandleEvent1(Win,e_Menu(tableedit_MenuId2,_)):- 
	tableedit_db_Te_Info(Win,bufferingmode(nobuffering)),
	tableedit_CurWait(Win,b_true),
	tableedit_GetPossibilityFilter(Win,b_false,P,Fdata), P = b_true,
	not(tableedit_SendCallback(Win,filter(Fdata))),
	win_SendEvent(Win,e_Menu(tableedit_MenuId17,c_Nothing)),
	tableedit_ReSetFilters(Win,Fdata),
	tableedit_db_Te_Info(Win,sortedby(Col)),
	tableedit_Sort(Win,Col),
	tableedit_CliarUndoRedoData(Win),
	tableedit_CurWait(Win,b_false),
	!.
  tableedit_HandleEvent1(Win,e_Menu(tableedit_MenuId2,_)):- 
	tableedit_db_Te_Info(Win,bufferingmode(buffering(_AnsFunc,_RowBuffSize,_MaxRows))),
	tableedit_CurWait(Win,b_true),
	tableedit_GetPossibilityFilter(Win,b_false,P,Fdata), P = b_true,
	not(tableedit_SendCallback(Win,filter(Fdata))),
	win_SendEvent(Win,e_Menu(tableedit_MenuId17,c_Nothing)),
	tableedit_CliarUndoRedoData(Win),
	tableedit_CurWait(Win,b_false),
	!.
  tableedit_HandleEvent1(Win,e_Menu(tableedit_MenuId2,_)):-
	tableedit_CurWait(Win,b_false),
	!.

% win_PostEvent to "Filter excluding selection"
  tableedit_HandleEvent1(Win,e_Menu(tableedit_MenuId3,_)):-
	win_PostEvent(Win,e_Menu(tableedit_MenuId4,c_Nothing)),
	!.
% "Filter excluding selection"
  tableedit_HandleEvent1(Win,e_Menu(tableedit_MenuId4,_)):- 
	tableedit_db_Te_Info(Win,bufferingmode(nobuffering)),
	tableedit_CurWait(Win,b_true),
	tableedit_GetPossibilityFilter(Win,b_true,P,Fdata), P = b_true,
	not(tableedit_SendCallback(Win,filter(Fdata))),
	win_SendEvent(Win,e_Menu(tableedit_MenuId17,c_Nothing)),
	tableedit_ReSetFilters(Win,Fdata),
	tableedit_db_Te_Info(Win,sortedby(Col)),
	tableedit_Sort(Win,Col),
	tableedit_CliarUndoRedoData(Win),
	tableedit_CurWait(Win,b_false),
	!.
  tableedit_HandleEvent1(Win,e_Menu(tableedit_MenuId4,_)):- 
	tableedit_db_Te_Info(Win,bufferingmode(buffering(_AnsFunc,_RowBuffSize,_MaxRows))),
	tableedit_CurWait(Win,b_true),
	tableedit_GetPossibilityFilter(Win,b_true,P,Fdata), P = b_true,
	not(tableedit_SendCallback(Win,filter(Fdata))),
	win_SendEvent(Win,e_Menu(tableedit_MenuId17,c_Nothing)),
	tableedit_CurWait(Win,b_false),
	!.
  tableedit_HandleEvent1(Win,e_Menu(tableedit_MenuId4,_)):-
	tableedit_CurWait(Win,b_false),
	!.

% "Show All rows"
  tableedit_HandleEvent1(Win,e_Menu(tableedit_MenuId5,_)):- 
	tableedit_db_Te_Info(Win,bufferingmode(nobuffering)),
	tableedit_CurWait(Win,b_true),
	not(tableedit_SendCallback(Win,filter([]))),
	tableedit_ReSetFilters(Win,[]),
	tableedit_db_Te_Info(Win,sortedby(Col)),
	tableedit_Sort(Win,Col),
	tableedit_CliarUndoRedoData(Win),
	tableedit_CurWait(Win,b_false),
	!.
  tableedit_HandleEvent1(Win,e_Menu(tableedit_MenuId5,_)):- 
	tableedit_db_Te_Info(Win,bufferingmode(buffering(_AnsFunc,_RowBuffSize,_MaxRows))),
	tableedit_CurWait(Win,b_true),
	not(tableedit_SendCallback(Win,filter([]))),
	tableedit_CurWait(Win,b_false),
	!.
  tableedit_HandleEvent1(Win,e_Menu(tableedit_MenuId5,_)):-
	tableedit_CurWait(Win,b_false),
	!.

% Control 'c' - win_PostEvent to "Copy"
  tableedit_HandleEvent1(Win,e_Char(3,c_Control)):- 
	win_PostEvent(Win,e_Menu(tableedit_MenuId6,c_Nothing)),
	!.
% "Copy"
  tableedit_HandleEvent1(Win,e_Menu(tableedit_MenuId6,_)):-
	tableedit_GetPossibilityCopy(Win,P,AML), P = b_true,
	tableedit_CurWait(Win,b_true),
	AML = [ga(FromRow,ToRow,FromCol,ToCol)],
	not(tableedit_SendCallback(Win,copy(FromRow,ToRow,FromCol,ToCol))),
	RowStringData = tableedit_GetClipBoardData(Win,FromRow,ToRow,FromCol,ToCol),
	cb_PutString(RowStringData),
	tableedit_CurWait(Win,b_false),
	!.
  tableedit_HandleEvent1(Win,e_Menu(tableedit_MenuId6,_)):-
	tableedit_CurWait(Win,b_false),
	!.

% Control 'v' - win_PostEvent to "Paste"
  tableedit_HandleEvent1(Win,e_Char(22,c_Control)):- 
	win_PostEvent(Win,e_Menu(tableedit_MenuId7,c_Nothing)),
	!.
% "Paste"
  tableedit_HandleEvent1(Win,e_Menu(tableedit_MenuId7,_)):-
	tableedit_GetPossibilityPaste(Win,P,AML), P = b_true,
	AML = [ga(FromRow,ToRow,FromCol,ToCol)],
	tableedit_CurWait(Win,b_true),
	not(tableedit_SendCallback(Win,paste(FromRow,ToRow,FromCol,ToCol))),
	SourceStr = cb_GetString(),
	tableedit_ChkClipBoardStr(Win,AML,SourceStr,b_true),
	tableedit_SetRowDataSendCallback(Win,AML,SourceStr),
	tableedit_CurWait(Win,b_false),
	!.
  tableedit_HandleEvent1(Win,e_Menu(tableedit_MenuId7,_)):-
	tableedit_CurWait(Win,b_false),
	!.

  tableedit_HandleEvent1(Win,e_Char(24,c_Control)):- 
	win_PostEvent(Win,e_Menu(tableedit_MenuId8,c_Nothing)),
	!.
% "Cut"
  tableedit_HandleEvent1(Win,e_Menu(tableedit_MenuId8,_)):-
	tableedit_db_Te_Info(Win,bufferingmode(nobuffering)),
	tableedit_GetPossibilityCut(Win,P,AML), P = b_true,
	tableedit_CurWait(Win,b_true),
	AML = [ga(FromRow,ToRow,FromCol,ToCol)],
	not(tableedit_SendCallback(Win,cut(FromRow,ToRow,FromCol,ToCol))),
	RowStringData = tableedit_GetClipBoardData(Win,FromRow,ToRow,FromCol,ToCol),
	cb_PutString(RowStringData),
	Nrows = ToRow - FromRow + 1,
	tableedit_CreateVoidRows(Win,Nrows,[],VoidData),
	tableedit_SetDataSendCallback(Win,FromRow,ToRow,FromCol,ToCol,VoidData),
	tableedit_CurWait(Win,b_false),
	!.
  tableedit_HandleEvent1(Win,e_Menu(tableedit_MenuId8,_)):-
	tableedit_db_Te_Info(Win,bufferingmode(buffering(_AnsFunc,_RowBuffSize,_MaxRows))),
	tableedit_GetPossibilityCut(Win,P,AML), P = b_true,
	tableedit_CurWait(Win,b_true),
	AML = [ga(FromRow,ToRow,FromCol,ToCol)],
	not(tableedit_SendCallback(Win,cut(FromRow,ToRow,FromCol,ToCol))),
	RowStringData = tableedit_GetClipBoardData(Win,FromRow,ToRow,FromCol,ToCol),
	cb_PutString(RowStringData),
	Nrows = ToRow - FromRow + 1,
	tableedit_CreateVoidRows(Win,Nrows,[],VoidData),
	tableedit_SetData(Win,FromRow,ToRow,FromCol,ToCol,VoidData),
	tableedit_CurWait(Win,b_false),
	!.
  tableedit_HandleEvent1(Win,e_Menu(tableedit_MenuId8,_)):-
	tableedit_CurWait(Win,b_false),
	!.

% win_PostEvent to "Sort ascending"
  tableedit_HandleEvent1(Win,e_Menu(tableedit_MenuId9,_)):-
	win_PostEvent(Win,e_Menu(tableedit_MenuId10,c_Nothing)),
	!.
% "Sort ascending"
  tableedit_HandleEvent1(Win,e_Menu(tableedit_MenuId10,_)):- 
	tableedit_db_Te_Info(Win,bufferingmode(nobuffering)),
	tableedit_GetPossibilitySort(Win,P,FromCol), P = b_true,
	tableedit_CurWait(Win,b_true),
	tableedit_GetSortList(Win,FromCol,SortList),
	not(tableedit_SendCallback(Win,sort(FromCol,ascending(SortList)))),
	retract(tableedit_db_Col_Info(Win,FromCol,sortmode(_))),
	assert(tableedit_db_Col_Info(Win,FromCol,sortmode(ascending([FromCol|SortList])))),
	retract(tableedit_db_Te_Info(Win,sortedby(_))),
	assert(tableedit_db_Te_Info(Win,sortedby(FromCol))),
	win_SendEvent(Win,e_Menu(tableedit_MenuId17,c_Nothing)),
	tableedit_Sort(Win,FromCol),
	retract(tableedit_db_Col_Info(Win,FromCol,sortmode(_))),
	assert(tableedit_db_Col_Info(Win,FromCol,sortmode(ascending(SortList)))),!,
	tableedit_CliarUndoRedoData(Win),
	tableedit_CurWait(Win,b_false),
	fail.
  tableedit_HandleEvent1(Win,e_Menu(tableedit_MenuId10,_)):- 
	tableedit_db_Te_Info(Win,bufferingmode(buffering(_AnsFunc,_RowBuffSize,_MaxRows))),
	tableedit_GetPossibilitySort(Win,P,FromCol), P = b_true,
	tableedit_CurWait(Win,b_true),
	tableedit_GetSortList(Win,FromCol,SortList),
	not(tableedit_SendCallback(Win,sort(FromCol,ascending(SortList)))),
	win_SendEvent(Win,e_Menu(tableedit_MenuId17,c_Nothing)),
	retract(tableedit_db_Te_Info(Win,sortedby(_))),
	assert(tableedit_db_Te_Info(Win,sortedby(FromCol))),
	retract(tableedit_db_Col_Info(Win,FromCol,sortmode(_))),
	assert(tableedit_db_Col_Info(Win,FromCol,sortmode(ascending(SortList)))),!,
	tableedit_CliarUndoRedoData(Win),
	tableedit_CurWait(Win,b_false),
	fail.
  tableedit_HandleEvent1(Win,e_Menu(tableedit_MenuId10,_)):-
	tableedit_CurWait(Win,b_false),
	!.

% win_PostEvent to "Sort descending"
  tableedit_HandleEvent1(Win,e_Menu(tableedit_MenuId11,_)):-
	win_PostEvent(Win,e_Menu(tableedit_MenuId12,c_Nothing)),
	!.
% "Sort descending"
  tableedit_HandleEvent1(Win,e_Menu(tableedit_MenuId12,_)):- 
	tableedit_db_Te_Info(Win,bufferingmode(nobuffering)),
	tableedit_GetPossibilitySort(Win,P,FromCol), P = b_true,
	tableedit_CurWait(Win,b_true),
	tableedit_GetSortList(Win,FromCol,SortList),
	not(tableedit_SendCallback(Win,sort(FromCol,descending(SortList)))),
	retract(tableedit_db_Col_Info(Win,FromCol,sortmode(_))),
	assert(tableedit_db_Col_Info(Win,FromCol,sortmode(descending([FromCol|SortList])))),
	retract(tableedit_db_Te_Info(Win,sortedby(_))),
	assert(tableedit_db_Te_Info(Win,sortedby(FromCol))),
	win_SendEvent(Win,e_Menu(tableedit_MenuId17,c_Nothing)),
	tableedit_Sort(Win,FromCol),
	retract(tableedit_db_Col_Info(Win,FromCol,sortmode(_))),
	assert(tableedit_db_Col_Info(Win,FromCol,sortmode(descending(SortList)))),!,
	tableedit_CliarUndoRedoData(Win),
	tableedit_CurWait(Win,b_false),
	fail.
  tableedit_HandleEvent1(Win,e_Menu(tableedit_MenuId12,_)):- 
	tableedit_db_Te_Info(Win,bufferingmode(buffering(_AnsFunc,_RowBuffSize,_MaxRows))),
	tableedit_GetPossibilitySort(Win,P,FromCol), P = b_true,
	tableedit_CurWait(Win,b_true),
	tableedit_GetSortList(Win,FromCol,SortList),
	not(tableedit_SendCallback(Win,sort(FromCol,descending(SortList)))),
	win_SendEvent(Win,e_Menu(tableedit_MenuId17,c_Nothing)),
	retract(tableedit_db_Te_Info(Win,sortedby(_))),
	assert(tableedit_db_Te_Info(Win,sortedby(FromCol))),
	retract(tableedit_db_Col_Info(Win,FromCol,sortmode(_))),
	assert(tableedit_db_Col_Info(Win,FromCol,sortmode(descending(SortList)))),!,
	tableedit_CliarUndoRedoData(Win),
	tableedit_CurWait(Win,b_false),
	fail.
  tableedit_HandleEvent1(Win,e_Menu(tableedit_MenuId12,_)):-
	tableedit_CurWait(Win,b_false),
	!.
% 'Ins' - win_PostEvent to "Insert Row"
  tableedit_HandleEvent1(Win,e_Char(k_ins,c_Nothing)):-
	win_PostEvent(Win,e_Menu(tableedit_MenuId13,c_Nothing)),
	!.
% win_PostEvent to "Insert Row"
  tableedit_HandleEvent1(Win,e_Menu(tableedit_MenuId14,_)):-
	win_PostEvent(Win,e_Menu(tableedit_MenuId13,c_Nothing)),
	!.
% "Insert Row"
  tableedit_HandleEvent1(Win,e_Menu(tableedit_MenuId13,_)):-
	tableedit_GetPossibilityInsRow(Win,Row,P), P = b_true,
	tableedit_CurWait(Win,b_true),
	tableedit_InsDefRowZ(Win),
	tableedit_BuffInvalidate(Win,Row),
	tableedit_CurWait(Win,b_false),
	!.
  tableedit_HandleEvent1(Win,e_Menu(tableedit_MenuId13,_)):-
	tableedit_CurWait(Win,b_false),
	!.
% 'Del' - win_PostEvent to "Delete Rows"
  tableedit_HandleEvent1(Win,e_Char(k_del,c_Nothing)):-
	win_PostEvent(Win,e_Menu(tableedit_MenuId15,c_Nothing)),
	!,fail.

% shift F3 - Find Next
  tableedit_HandleEvent1(Win,e_Char(k_f3,c_Shift)):-
	tableedit_GetPossibilityFindNext(Win,P), P = b_true,
	tableedit_find_Next(Win),
	!,fail.

% win_PostEvent to "Delete Rows"
  tableedit_HandleEvent1(Win,e_Menu(tableedit_MenuId16,_)):-
	win_PostEvent(Win,e_Menu(tableedit_MenuId15,c_Nothing)),
	!.
% "Delete Rows"
  tableedit_HandleEvent1(Win,e_Menu(tableedit_MenuId15,_)):-
	tableedit_GetPossibilityDelRow(Win,P,LList), P = b_true,
	tableedit_CurWait(Win,b_true),
	win_SendEvent(Win,e_Menu(tableedit_MenuId17,c_Nothing)),
	tableedit_DeleteRowsSendCallback(Win,LList),
	tableedit_CurWait(Win,b_false),
	!.
  tableedit_HandleEvent1(Win,e_Menu(tableedit_MenuId15,_)):-
	tableedit_CurWait(Win,b_false),
	!.
% Set Marker - "grid_no_marker"
  tableedit_HandleEvent1(Win,e_Menu(tableedit_MenuId17,_)):-
	grid_Marker(Win,grid_no_marker),
	!.
% Dialog "Find" create
  tableedit_HandleEvent1(Win,e_Menu(tableedit_MenuId22,_)):-
	tableedit_dlg_find_Create(Win),
	!.
% Dialog "Find" create
  tableedit_HandleEvent1(Win,e_Menu(tableedit_MenuId23,_)):-
	tableedit_GetPossibilityFindNext(Win,P), P = b_true,
	tableedit_find_Next(Win),
	!.

% Send Callback - "menu(..)" for custom items
  tableedit_HandleEvent1(Win,e_Menu(Tag,_)):-
	grid_Marker(Win,M),
	not(tableedit_SendCallback(Win,menu(Tag,M))),
	!.
  tableedit_HandleEvent1(Win,e_User(6623,1)):-
	tableedit_HandleBuffAnswer(Win),
	!.
  tableedit_HandleEvent1(_,_):-!.


predicates
  determ  tableedit_member_index(TABLEEDIT_COLUMNDATA,TABLEEDIT_DATA,INTEGER)
  determ  tableedit_member_index(TABLEEDIT_CELLDATA,TABLEEDIT_COLUMNDATA,INTEGER)
% Get string,forecolor,backcolor from cell
  determ  tableedit_GetGridData(WINDOW,INTEGER Row,INTEGER Column,STRING,
			COLOR Fg_Col,COLOR Bg_Col)
% cell data to string,forecolor,backcolor transformation
  determ  tableedit_CellDataToGridData(WINDOW,TABLEEDIT_CELLDATA,INTEGER Column,
  			STRING,COLOR Fg_Col,COLOR Bg_Col)
% string data to cell data transformation and set it to database
  procedure  tableedit_ReplaceData(WINDOW,INTEGER Row,INTEGER Column,STRING String)
% get cell data from database
  determ  tableedit_GetTbaleedData(WINDOW,INTEGER Row,INTEGER Column,TABLEEDIT_CELLDATA)
% get GRIDLIST2D format data from database
  determ  tableedit_GetGridDataFromTo(WINDOW,INTEGER FrRow,INTEGER ToRow,INTEGER FrColumn,INTEGER ToColumn,
  	GRIDLIST2D)
% check string to validation rule
  determ  tableedit_ChkValidation(WINDOW,INTEGER Col,STRING)
  tableedit_CorrectString(WINDOW,STRING,INTEGER Col,STRING)
% send callback if cell data modified 
  determ  tableedit_SendModifiedCallback(WINDOW,INTEGER Row,INTEGER Column,STRING NewData)
  determ  tableedit_SendDataModifiedCallback(WINDOW,BOOLEAN Possibility,INTEGER Row,INTEGER Column,
				     TABLEEDIT_CELLDATA Old,TABLEEDIT_CELLDATA New)
% string data from cell to TABLEEDIT_CELLDATA transformation
  procedure  tableedit_GridDataToCellData(WINDOW,INTEGER Column,STRING,TABLEEDIT_CELLDATA Old,
  			       TABLEEDIT_CELLDATA New)

  determ  tableedit_CompareVoid(TABLEEDIT_CELLDATA,TABLEEDIT_CELLDATA)

clauses

  tableedit_SendDataModifiedCallback(Win,b_true,Row,Column,CellData,NewValue):-
	not(tableedit_CompareVoid(NewValue,CellData)),
	not(tableedit_SendCallback(Win,modified(Row,Column,CellData,NewValue))),
	!.
  tableedit_SendDataModifiedCallback(Win,b_false,Row,Column,CellData,NewValue):-
	not(tableedit_CompareVoid(NewValue,CellData)),
	not(NewValue = p(_,_,_)), not(CellData = p(_,_,_)),
	tableedit_UpdateUndoRedoModified(Win,modified(Row,Column,CellData,NewValue)),
	!.
  tableedit_SendDataModifiedCallback(_Win,b_false,_Row,_Column,_CellData,_NewValue):-
	!.

  tableedit_SendModifiedCallback(Win,Row,Column,ModStr):-
	trap(CellData = tableedit_GetCellData(Win,Row,Column),_,fail),
	tableedit_GridDataToCellData(Win,Column,ModStr,CellData,NewValue),!,
	not(tableedit_CompareVoid(NewValue,CellData)),
	not(tableedit_SendCallback(Win,modified(Row,Column,CellData,NewValue))),
	!.


  tableedit_CompareVoid(NewValue,CellData):-
	NewValue = s(""), CellData = void,!.
  tableedit_CompareVoid(NewValue,CellData):-
	NewValue = sc("",_), CellData = void,!.
  tableedit_CompareVoid(NewValue,CellData):-
	CellData = s(""), NewValue = void,!.
  tableedit_CompareVoid(NewValue,CellData):-
	CellData = sc("",_), NewValue = void,!.
  tableedit_CompareVoid(NewValue,CellData):-
	NewValue = s(""), CellData = voidc(_),!.
  tableedit_CompareVoid(NewValue,CellData):-
	NewValue = sc("",_), CellData = voidc(_),!.
  tableedit_CompareVoid(NewValue,CellData):-
	CellData = s(""), NewValue = voidc(_),!.
  tableedit_CompareVoid(NewValue,CellData):-
	CellData = sc("",_), NewValue = voidc(_),!.
  tableedit_CompareVoid(NewValue,CellData):-
	CellData = NewValue,!.
  
  tableedit_SendCallbackForAction(Win,GrinAct):-
	GrinAct = grid_row_marker_beg(Row),
	A = row_marker_beg(Row),
	tableedit_SendCallback(Win,action(A)),
	!.
  tableedit_SendCallbackForAction(Win,GrinAct):-
	GrinAct = grid_col_marker_beg(Column),
	A = col_marker_beg(Column),
	tableedit_SendCallback(Win,action(A)),
	!.
  tableedit_SendCallbackForAction(Win,GrinAct):-
	GrinAct = grid_area_marker_beg(Row,Column),
	A = area_marker_beg(Row,Column),
	tableedit_SendCallback(Win,action(A)),
	!.
  tableedit_SendCallbackForAction(Win,GrinAct):-
	GrinAct = grid_all_marker_beg,
	A = all_marker_beg(),
	tableedit_SendCallback(Win,action(A)),
	!.
  tableedit_SendCallbackForAction(Win,GrinAct):-
	GrinAct = grid_edit_cell_beg(Row,Column),
	A = edit_cell_beg(Row,Column),
	tableedit_SendCallback(Win,action(A)),
	!.
  tableedit_SendCallbackForAction(Win,GrinAct):-
	GrinAct = grid_resize_column_beg(Column),
	A = resize_column_beg(Column),
	tableedit_SendCallback(Win,action(A)),
	!.
  tableedit_SendCallbackForAction(Win,GrinAct):-
	GrinAct = grid_resize_column(Column,Width),
	A = resize_column(Column,Width),
	tableedit_SendCallback(Win,action(A)),
	!.
  tableedit_SendCallbackForAction(Win,GrinAct):-
	GrinAct = grid_hscroll_create,
	A = hscroll_create(),
	tableedit_SendCallback(Win,action(A)),
	!.
  tableedit_SendCallbackForAction(Win,GrinAct):-
	GrinAct = grid_vscroll_create,
	A = vscroll_create(),
	tableedit_SendCallback(Win,action(A)),
	!.
  tableedit_SendCallbackForAction(Win,GrinAct):-
	GrinAct = grid_hscroll_destroy,
	A = hscroll_destroy(),
	tableedit_SendCallback(Win,action(A)),
	!.
  tableedit_SendCallbackForAction(Win,GrinAct):-
	GrinAct = grid_vscroll_destroy,
	A = vscroll_destroy(),
	tableedit_SendCallback(Win,action(A)),
	!.
predicates
procedure  tableedit_ConvertSingleMarker(WINDOW,GRID_MARKER)
clauses
  tableedit_ConvertSingleMarker(Win,_Mark):-
	grid_Marker(Win,grid_no_marker),fail.
  tableedit_ConvertSingleMarker(Win,Mark):-
	grid_Marker(Win,CurMar),
	CurMar = grid_no_marker,
	not(tableedit_GridCallback(Win,user_action(grid_marker(Mark,b_true)),_)),
	grid_Marker(Win,Mark),
	!.
  tableedit_ConvertSingleMarker(_Win,_Mark):-!.

% ========== Grid Callback ===========

% Control 'Y' - Redo
  tableedit_GridCallback(Win,
	event(e_Char(25,c_Control)),
	event_answer(stop)):-
		tableedit_GetPossibilityRedo(Win,P), P = b_true,
		grid_Marker(Win,Marker),
		not(Marker = grid_edit_cell(_,_)),
		win_PostEvent(Win,e_Menu(tableedit_MenuId21,c_Nothing)),!.
% Control 'Z' - Undo
  tableedit_GridCallback(Win,
	event(e_Char(26,c_Control)),
	event_answer(stop)):-
		tableedit_GetPossibilityUndo(Win,P), P = b_true, 
		grid_Marker(Win,Marker),
		not(Marker = grid_edit_cell(_,_)),
		win_PostEvent(Win,e_Menu(tableedit_MenuId20,c_Nothing)),!.

% stop on grid_all_marker_beg action
  tableedit_GridCallback(Win,
	user_action(grid_all_marker_beg),
	event_answer(stop)):-
		tableedit_db_Te_Info(Win,allmarker(b_false)),!.

% none for rowmarker
  tableedit_GridCallback(Win,
	user_action(grid_row_marker_beg(_Row)),
	event_answer(stop)):-
		tableedit_db_Te_Info(Win,rowmarker(none)),!.

% send row_marker_beg callback 
  tableedit_GridCallback(Win,
	user_action(A),
	event_answer(stop)):-
		A = grid_row_marker_beg(_Row),
		tableedit_SendCallbackForAction(Win,A),
		!.

% singular for rowmarker
  tableedit_GridCallback(Win,
	user_action(grid_row_marker_beg(Row)),
	event_answer(stop)):-
		tableedit_db_Te_Info(Win,rowmarker(singular)),
		Mark = grid_row_marker([gl(Row,Row)]),
		tableedit_ConvertSingleMarker(Win,Mark),
		!.
% singular for rowmarker
  tableedit_GridCallback(Win,
	user_action(grid_marker(GM,b_true)),
	event_answer(continue)):-
		tableedit_db_Te_Info(Win,rowmarker(singular)),
		GM = grid_row_marker([gl(Row,Row1)]),
		GM1 = grid_row_marker([gl(Row,Row)]),
		not(GM1 = GM),		
		Mark = grid_row_marker([gl(Row1,Row1)]),
		tableedit_ConvertSingleMarker(Win,Mark),
		!.
% singlearea for rowmarker
  tableedit_GridCallback(Win,
	user_action(grid_row_marker_beg(_Row)),
	event_answer(continue)):-
		tableedit_db_Te_Info(Win,rowmarker(singlearea)),
		grid_Marker(Win,Mark), Mark = grid_row_marker([gl(_,_)]),
		grid_Marker(Win,grid_no_marker),!.

% none for colmarker
  tableedit_GridCallback(Win,
	user_action(grid_col_marker_beg(_Row)),
	event_answer(stop)):-
		tableedit_db_Te_Info(Win,colmarker(none)),!.

% send col_marker_beg callback 
  tableedit_GridCallback(Win,
	user_action(A),
	event_answer(stop)):-
		A = grid_col_marker_beg(_Col),
		tableedit_SendCallbackForAction(Win,A),
		!.

% singular for colmarker
  tableedit_GridCallback(Win,
	user_action(grid_col_marker_beg(Row)),
	event_answer(stop)):-
		tableedit_db_Te_Info(Win,colmarker(singular)),
		Mark = grid_col_marker([gl(Row,Row)]),
		tableedit_ConvertSingleMarker(Win,Mark),
		!.
% singular for colmarker
  tableedit_GridCallback(Win,
	user_action(grid_marker(GM,b_true)),
	event_answer(continue)):-
		tableedit_db_Te_Info(Win,colmarker(singular)),
		GM = grid_col_marker([gl(Col,Col1)]),
		GM1 = grid_col_marker([gl(Col,Col)]),
		not(GM1 = GM),		
		Mark = grid_col_marker([gl(Col1,Col1)]),
		tableedit_ConvertSingleMarker(Win,Mark),
		!.

% singlearea for colmarker
  tableedit_GridCallback(Win,
	user_action(grid_col_marker_beg(_Row)),
	event_answer(continue)):-
		tableedit_db_Te_Info(Win,colmarker(singlearea)),
		grid_Marker(Win,Mark), Mark = grid_col_marker([gl(_,_)]),
		grid_Marker(Win,grid_no_marker),!.

% none for areamarker
  tableedit_GridCallback(Win,
	user_action(grid_area_marker_beg(_Row,_Col)),
	event_answer(stop)):-
		tableedit_db_Te_Info(Win,areamarker(none)),!.

% send area_marker_beg callback 
  tableedit_GridCallback(Win,
	user_action(A),
	event_answer(stop)):-
		A = grid_area_marker_beg(_Row,_Col),
		tableedit_SendCallbackForAction(Win,A),
		!.

% singular for areamarker
  tableedit_GridCallback(Win,
	user_action(grid_area_marker_beg(Row,Col)),
	event_answer(stop)):-
		tableedit_db_Te_Info(Win,areamarker(singular)),
		Mark = grid_area_marker([ga(Row,Row,Col,Col)]),
		tableedit_ConvertSingleMarker(Win,Mark),
		!.
% singular for areamarker
  tableedit_GridCallback(Win,
	user_action(grid_marker(GM,b_true)),
	event_answer(continue)):-
		tableedit_db_Te_Info(Win,areamarker(singular)),
		GM = grid_area_marker([ga(Row,Row1,Col,Col1)]),
		GM1 = grid_area_marker([ga(Row,Row,Col,Col)]),
		not(GM1 = GM),		
		Mark = grid_area_marker([ga(Row1,Row1,Col1,Col1)]),
		tableedit_ConvertSingleMarker(Win,Mark),
		!.


% singlearea for areamarker
  tableedit_GridCallback(Win,
	user_action(grid_area_marker_beg(_Row,_Col)),
	event_answer(continue)):-
		tableedit_db_Te_Info(Win,areamarker(singlearea)),
		grid_Marker(Win,Mark), Mark = grid_area_marker([ga(_,_,_,_)]),
		grid_Marker(Win,grid_no_marker),
		!.

% stop on grid_edit_cell_beg action
  tableedit_GridCallback(Win,
	user_action(grid_edit_cell_beg(_Row,Column)),
	event_answer(stop)):-
		tableedit_db_Col_Info(Win,Column,readonly(b_true)),!.

% stop on resize column action
  tableedit_GridCallback(Win,user_action(ACTION),event_answer(stop)):-
	Action = grid_resize_column_beg(Column),
	tableedit_db_Col_Info(Win,Column,resizable(b_false)),!.

% send action callback
  tableedit_GridCallback(Win,user_action(A),event_answer(stop)):-
	A = grid_all_marker_beg, tableedit_SendCallbackForAction(Win,A),!.
  tableedit_GridCallback(Win,user_action(A),event_answer(stop)):-
	A = grid_edit_cell_beg(_Row,_Column), tableedit_SendCallbackForAction(Win,A),!.
  tableedit_GridCallback(Win,user_action(A),event_answer(stop)):-
	A = grid_resize_column_beg(_Column), tableedit_SendCallbackForAction(Win,A),!.
  tableedit_GridCallback(Win,user_action(A),event_answer(stop)):-
	A = grid_resize_column(_Column,_Width), tableedit_SendCallbackForAction(Win,A),!.
  tableedit_GridCallback(Win,user_action(A),event_answer(stop)):-
	A = grid_hscroll_create, tableedit_SendCallbackForAction(Win,A),!.
  tableedit_GridCallback(Win,user_action(A),event_answer(stop)):-
	A = grid_hscroll_destroy, tableedit_SendCallbackForAction(Win,A),!.
  tableedit_GridCallback(Win,user_action(A),event_answer(stop)):-
	A = grid_vscroll_create, tableedit_SendCallbackForAction(Win,A),!.
  tableedit_GridCallback(Win,user_action(A),event_answer(stop)):-
	A = grid_vscroll_destroy, tableedit_SendCallbackForAction(Win,A),!.

% send marker callback
  tableedit_GridCallback(Win,user_action(ACTION),event_answer(stop)):-
	Action = grid_marker(Mark,M),
	tableedit_SendCallback(Win,marker(Mark,M)),
	!.

% edit control answer
  tableedit_GridCallback(Win,
	user_action(grid_marker(grid_edit_cell(Row,Column),b_true)),
	event_answer(editCtrl(InitString))):-
		tableedit_db_Col_Info(Win,Column,control(edit)),
		tableedit_GetGridData(Win,Row,Column,InitString,_Fg_Col,_Bg_Col),
		!.

% listbutton control answer
  tableedit_GridCallback(Win,
	user_action(grid_marker(grid_edit_cell(Row,Column),b_true)),
	event_answer(lBoxButton(SLIST,InitString))):-
		tableedit_db_Col_Info(Win,Column,control(listbutton(SLIST))),
		tableedit_GetGridData(Win,Row,Column,InitString,_Fg_Col,_Bg_Col),!.

% listedit control answer
  tableedit_GridCallback(Win,
	user_action(grid_marker(grid_edit_cell(Row,Column),b_true)),
	event_answer(lBoxEdit(SLIST,InitString))):-
		tableedit_db_Col_Info(Win,Column,control(listedit(SLIST))),
		tableedit_GetGridData(Win,Row,Column,InitString,_Fg_Col,_Bg_Col),!.

% custom control answer
  tableedit_GridCallback(Win,
	user_action(grid_marker(grid_edit_cell(Row,Column),b_true)),
	event_answer(custom_ctrl(ClassName,Flags,PutData,GetData,InitString))):-
		tableedit_db_Col_Info(Win,Column,control(CustCtrl)),
		CustCtrl = custom(ClassName,Flags,PutData,GetData),
		tableedit_GetGridData(Win,Row,Column,InitString,_Fg_Col,_Bg_Col),!.

% V Scroll Create
  tableedit_GridCallback(Win,user_action(grid_vscroll_create),event_answer(continue)):-
	assert(tableedit_db_VScroll(Win)),
	!.
% V Scroll Destroy
  tableedit_GridCallback(Win,user_action(grid_vscroll_destroy),event_answer(continue)):-
	retractAll(tableedit_db_VScroll(Win)),
	!.

  tableedit_GridCallback(Win,
	user_action(modified(_Row,Column,String)),
	event_answer(stop)):- % column type - all ; Vtext not ""
		not(tableedit_db_Col_Info(Win,Column,column_type(te_picture))),
		tableedit_db_Col_Info(Win,Column,validationtext(VText)),
		not(VText = ""),
		not(tableedit_ChkValidation(Win,Column,String)),
		!.
  tableedit_GridCallback(Win,
	user_action(modified(Row,Column,String)),
	event_answer(continue)):- % column type - string ; Vtext = ""
		tableedit_db_Col_Info(Win,Column,column_type(te_string)),
		tableedit_db_Col_Info(Win,Column,validationtext(VText)),
		VText = "",
		tableedit_CorrectString(Win,String,Column,String1),
		tableedit_ReplaceData(Win,Row,Column,String1),
		!.
  tableedit_GridCallback(Win,
	user_action(modified(_Row,Column,String)),
	event_answer(continue)):- % column type - all ; Vtext = ""
		not(tableedit_db_Col_Info(Win,Column,column_type(te_picture))),
		tableedit_db_Col_Info(Win,Column,validationtext(VText)),
		VText = "",
		not(tableedit_ChkValidation(Win,Column,String)),
		!.
  tableedit_GridCallback(Win,
	user_action(modified(Row,Column,String)),
	event_answer(continue)):-% column type - string ; Vtext - all
		tableedit_db_Col_Info(Win,Column,column_type(te_string)),
		tableedit_CorrectString(Win,String,Column,String1),
		tableedit_ReplaceData(Win,Row,Column,String1),
		!.
  tableedit_GridCallback(Win,
	user_action(modified(Row,Column,String)),
	event_answer(continue)):-
		tableedit_ReplaceData(Win,Row,Column,String),
		!.


% grid_area data request
  tableedit_GridCallback(Win,data_request(grid_area(From_Row,To_Row,From_Column,To_Column)),
	data_answer(grid_area_answer(CellList))):-
		tableedit_db_Te_Info(Win,bufferingmode(nobuffering)),
		tableedit_GetGridDataFromTo(Win,From_Row,To_Row,From_Column,To_Column,CellList),
		!.
  tableedit_GridCallback(Win,data_request(grid_area(FromRow,ToRow,FromColumn,ToColumn)),
	data_answer(empty_answer)):-
		tableedit_db_Te_Info(Win,bufferingmode(buffering(_AnsFunc,_RowBuffSize,_MaxRows))),
		assertz(tableedit_db_AnswerRange(Win,FromRow,ToRow,FromColumn,ToColumn)),
		tableedit_SeparateAnswer(Win),
		win_PostEvent(Win,e_User(6623,1)),
		!.


  tableedit_reverse([],IdList,IdList):-!.
  tableedit_reverse([Id|Rest],IL,IdList):-!,
	tableedit_reverse(Rest,[Id|IL],IdList).
  tableedit_reverse(_,_,[]):-errorExit().

predicates
  procedure  tableedit_Replace(WINDOW,INTEGER Column,INTEGER Row,STRING String,TABLEEDIT_DATA,TABLEEDIT_DATA,TABLEEDIT_DATA)
  procedure  tableedit_Replace1(WINDOW,INTEGER Column,INTEGER Column,STRING String,TABLEEDIT_COLUMNDATA,TABLEEDIT_COLUMNDATA,TABLEEDIT_COLUMNDATA)
clauses

% Replace data
  tableedit_ReplaceData(Win,Row,Column,String):-
	tableedit_db_Te_Info(Win,bufferingmode(nobuffering)),
	not(tableedit_db_Col_Info(Win,Column,column_type(te_picture))),
	tableedit_SendModifiedCallback(Win,Row,Column,String),
	retract(tableedit_db_Data_Info(Win,Data)),
	tableedit_Replace(Win,Column,Row,String,Data,[],NewData),
	assert(tableedit_db_Data_Info(Win,NewData)),!.
  tableedit_ReplaceData(Win,Row,Column,String):-
	tableedit_db_Te_Info(Win,bufferingmode(nobuffering)),
	tableedit_db_Col_Info(Win,Column,column_type(te_picture)),
	tableedit_SendModifiedCallback(Win,Row,Column,String),
	!.
  tableedit_ReplaceData(Win,Row,Column,String):-
	tableedit_db_Te_Info(Win,bufferingmode(buffering(_,_,_))),
	tableedit_SendModifiedCallback(Win,Row,Column,String),
	retractAll(tableedit_db_DataBufRange(Win,_,_)),
	assert(tableedit_db_DataBufRange(Win,0,0)),
	!.
  tableedit_ReplaceData(_Win,_Row,_Column,_String):-!.

  tableedit_Replace(_Win,_,_,_,[],NewData1,NewData):-
	tableedit_reverse(NewData1,[],NewData),!.
  tableedit_Replace(Win,Col,1,String,[Data|Rest],ND,NewData):-!,
	tableedit_Replace1(Win,Col,Col,String,Data,[],ND1),
	tableedit_Replace(Win,Col,0,String,Rest,[ND1|ND],NewData).
  tableedit_Replace(Win,Col,Row,String,[Data|Rest],ND,NewData):-
	R = Row - 1,!,
	tableedit_Replace(Win,Col,R,String,Rest,[Data|ND],NewData).
  tableedit_Replace(_,_,_,_,_,_,[]):-errorExit().

  tableedit_Replace1(_Win,_,_,_,[],NewData1,NewData):-
	tableedit_reverse(NewData1,[],NewData),!.
  tableedit_Replace1(Win,Col,1,String,[Data|Rest],ND,NewData):-
	tableedit_GridDataToCellData(Win,Col,String,Data,ND1),!,
	tableedit_Replace1(Win,Col,0,String,Rest,[ND1|ND],NewData).
  tableedit_Replace1(Win,Col,ColC,String,[Data|Rest],ND,NewData):-
	C = ColC - 1,!,
	tableedit_Replace1(Win,Col,C,String,Rest,[Data|ND],NewData).
  tableedit_Replace1(_,_,_,_,_,_,[]):-errorExit().

  tableedit_GridDataToCellData(_Win,_Col,"",sc(_,C),voidc(C)):-!.
  tableedit_GridDataToCellData(_Win,_Col,"",s(_),void):-!.
  tableedit_GridDataToCellData(Win,Col,"",void,void):-
	tableedit_db_Col_Info(Win,Col,column_type(te_string)),!.
  tableedit_GridDataToCellData(Win,Col,"",voidc(C),voidc(C)):-
	tableedit_db_Col_Info(Win,Col,column_type(te_string)),!.
  tableedit_GridDataToCellData(_Win,_Col,String,s(_),s(String)):-!.
  tableedit_GridDataToCellData(_Win,_Col,String,sc(_,C),sc(String,C)):-!.
  tableedit_GridDataToCellData(Win,Col,String,void,s(String)):-
	tableedit_db_Col_Info(Win,Col,column_type(te_string)),!.
  tableedit_GridDataToCellData(Win,Col,String,voidc(C),sc(String,C)):-
	tableedit_db_Col_Info(Win,Col,column_type(te_string)),!.

  tableedit_GridDataToCellData(_Win,_Col,String,ic(_,C),ic(Dig,C)):-
	trap(term_str(integer,Dig,String),_,fail),!.
  tableedit_GridDataToCellData(Win,Col,String,voidc(C),ic(Dig,C)):-
	tableedit_db_Col_Info(Win,Col,column_type(te_integer)),
	trap(term_str(integer,Dig,String),_,fail),!.
  tableedit_GridDataToCellData(Win,Col,String,_,i(Dig)):-
	tableedit_db_Col_Info(Win,Col,column_type(te_integer)),
	trap(term_str(integer,Dig,String),_,fail),!.

  tableedit_GridDataToCellData(_Win,_Col,String,lc(_,C),lc(Dig,C)):-
	trap(term_str(long,Dig,String),_,fail),!.
  tableedit_GridDataToCellData(Win,Col,String,voidc(C),lc(Dig,C)):-
	tableedit_db_Col_Info(Win,Col,column_type(te_long)),
	trap(term_str(long,Dig,String),_,fail),!.
  tableedit_GridDataToCellData(Win,Col,String,_,l(Dig)):-
	tableedit_db_Col_Info(Win,Col,column_type(te_long)),
	trap(term_str(long,Dig,String),_,fail),!.

  tableedit_GridDataToCellData(_Win,_Col,String,rc(_,C),rc(Dig,C)):-
	trap(term_str(real,Dig,String),_,fail),!.
  tableedit_GridDataToCellData(Win,Col,String,voidc(C),rc(Dig,C)):-
	tableedit_db_Col_Info(Win,Col,column_type(te_real)),
	trap(term_str(real,Dig,String),_,fail),!.
  tableedit_GridDataToCellData(Win,Col,String,_,r(Dig)):-
	tableedit_db_Col_Info(Win,Col,column_type(te_real)),
	trap(term_str(real,Dig,String),_,fail),!.

  tableedit_GridDataToCellData(_Win,_Col,String,p(Pic,S,_Str),p(Pic,S,String)):-
	not(String = ""),
	!.
  tableedit_GridDataToCellData(Win,Col,String,void,p(none,b_false,String)):-
	tableedit_db_Col_Info(Win,Col,column_type(te_picture)),
	not(String = ""),
	!.
  tableedit_GridDataToCellData(Win,Col,"",_,void):-
	tableedit_db_Col_Info(Win,Col,column_type(te_picture)),
	!.

  tableedit_GridDataToCellData(_Win,_Col,"",i(_),void):-!.
  tableedit_GridDataToCellData(_Win,_Col,"",ic(_,C),voidc(C)):-!.
  tableedit_GridDataToCellData(_Win,_Col,"",l(_),void):-!.
  tableedit_GridDataToCellData(_Win,_Col,"",lc(_,C),voidc(C)):-!.
  tableedit_GridDataToCellData(_Win,_Col,"",r(_),void):-!.
  tableedit_GridDataToCellData(_Win,_Col,"",rc(_,C),voidc(C)):-!.
  tableedit_GridDataToCellData(_Win,_Col,"",void,void):-!.
  tableedit_GridDataToCellData(_Win,_Col,"",voidc(C),voidc(C)):-!.
  tableedit_GridDataToCellData(Win,_Col,_,X,X):-
	retractAll(tableedit_db_PasteError(Win)),
	assert(tableedit_db_PasteError(Win)),
	!.

predicates
% VALIDATION RULE handling
% Create prompt string
  procedure  tableedit_InsertSubString(STRING PromptStr,STRING SubStr,STRING InsertStr,STRING OutStr)
  determ  tableedit_ChkListValidatin(WINDOW,TABLEEDIT_CELLDATA,TABLEEDIT_RULELIST)
  determ  tableedit_ChkValidation1(WINDOW,TABLEEDIT_CELLDATA,TABLEEDIT_RULE)
  determ  tableedit_CorrectStringToValidatinList(WINDOW,STRING,TABLEEDIT_RULELIST,STRING)
  determ  tableedit_ChkValidationString1(WINDOW,STRING,TABLEEDIT_RULE,STRING)
  procedure  tableedit_frontstr3(INTEGER Max,STRING StrIn,STRING StrOut)
clauses

  tableedit_ChkValidation(Win,Col,""):-
	not(tableedit_db_Col_Info(Win,Col,column_type(te_string))),
	tableedit_db_Col_Info(Win,Col,mandatory(b_false)),
	!.
  tableedit_ChkValidation(Win,Col,String):-
	tableedit_db_Col_Info(Win,Col,column_type(te_string)),
	tableedit_db_Col_Info(Win,Col,validationrule(RuleList)),
	tableedit_db_Col_Info(Win,Col,mandatory(b_true)),
	not(String = ""),
	tableedit_ChkListValidatin(Win,s(String),RuleList),!.
  tableedit_ChkValidation(Win,Col,String):-
	tableedit_db_Col_Info(Win,Col,column_type(te_string)),
	tableedit_db_Col_Info(Win,Col,validationrule(RuleList)),
	tableedit_db_Col_Info(Win,Col,mandatory(b_false)),
	tableedit_ChkListValidatin(Win,s(String),RuleList),!.
  tableedit_ChkValidation(Win,Col,String):-
	tableedit_db_Col_Info(Win,Col,column_type(te_integer)),
	trap(term_str(integer,Dig,String),_,fail),
	tableedit_db_Col_Info(Win,Col,validationrule(RuleList)),
	tableedit_ChkListValidatin(Win,i(Dig),RuleList),!.
  tableedit_ChkValidation(Win,Col,String):-
	tableedit_db_Col_Info(Win,Col,column_type(te_long)),
	trap(term_str(long,Dig,String),_,fail),
	tableedit_db_Col_Info(Win,Col,validationrule(RuleList)),
	tableedit_ChkListValidatin(Win,l(Dig),RuleList),!.
  tableedit_ChkValidation(Win,Col,String):-
	tableedit_db_Col_Info(Win,Col,column_type(te_real)),
	trap(term_str(real,Dig,String),_,fail),
	tableedit_db_Col_Info(Win,Col,validationrule(RuleList)),
	tableedit_ChkListValidatin(Win,r(Dig),RuleList),!.
  tableedit_ChkValidation(Win,Col,String):-
	tableedit_db_Col_Info(Win,Col,validationtext(VText)),!,
	not(VText = ""),
	tableedit_InsertSubString(VText,"%",String,VText1), % create error messege
	dlg_Note(tableedit_con_noteTitle,VText1),fail.

  tableedit_InsertSubString(PromptStr,SubStr,InsertStr,OutStr):-
	searchstring(PromptStr,SubStr,Pos), FrontChars = Pos - 1,
	frontstr(FrontChars,PromptStr,StartStr,EndString),
	concat(SubStr,X,EndString),
	concat(StartStr,InsertStr,Str1),
	concat(Str1,X,OutStr),!.
  tableedit_InsertSubString(PromptStr,_SubStr,_InsertStr,PromptStr):-!.

  tableedit_ChkListValidatin(_Win,_Dig,[]):-!.
  tableedit_ChkListValidatin(Win,Dig,[L1|L2]):-!,
	tableedit_ChkValidation1(Win,Dig,L1),
	tableedit_ChkListValidatin(Win,Dig,L2).

  tableedit_ChkValidation1(_Win,i(Dig),i_min(Lim)):- Dig >= Lim,!.
  tableedit_ChkValidation1(_Win,i(Dig),i_max(Lim)):- Dig <= Lim,!.
  tableedit_ChkValidation1(_Win,l(Dig),l_min(Lim)):- Dig >= Lim,!.
  tableedit_ChkValidation1(_Win,l(Dig),l_max(Lim)):- Dig <= Lim,!.
  tableedit_ChkValidation1(_Win,r(Dig),r_min(Lim)):- Dig >= Lim,!.
  tableedit_ChkValidation1(_Win,r(Dig),r_max(Lim)):- Dig <= Lim,!.
  tableedit_ChkValidation1(_Win,s(Str),s_length(VLen)):- str_len(Str,Len), Len = VLen,!.
  tableedit_ChkValidation1(_Win,s(Str),s_min(Lim)):- str_len(Str,Len), Len >= Lim,!.
  tableedit_ChkValidation1(_Win,s(Str),s_max(Lim)):- str_len(Str,Len), Len <= Lim,!.
  tableedit_ChkValidation1(_Win,s(_),s_upper):-!.
  tableedit_ChkValidation1(_Win,s(_),s_lower):-!.

  tableedit_CorrectString(Win,Str,Col,StrOut):-
	tableedit_db_Col_Info(Win,Col,column_type(te_string)),
	tableedit_db_Col_Info(Win,Col,validationrule(RuleList)),
	tableedit_CorrectStringToValidatinList(Win,Str,RuleList,StrOut),
	!.
  tableedit_CorrectString(_Win,Str,_Col,Str):-!.

  tableedit_CorrectStringToValidatinList(_Win,StrOut,[],StrOut):-!.
  tableedit_CorrectStringToValidatinList(Win,Str,[L1|L2],OS):-!,
	tableedit_ChkValidationString1(Win,Str,L1,Str1),
	tableedit_CorrectStringToValidatinList(Win,Str1,L2,OS).

  tableedit_ChkValidationString1(_Win,Str,s_length(VLen),Str1):- 
	format(Fstring,"%s%ds","\%-",VLen),format(StrOut,Fstring,Str),
	tableedit_frontstr3(VLen,StrOut,Str1),!.
  tableedit_ChkValidationString1(_Win,Str,s_min(VLen),Str1):- 
	format(Fstring,"%s%ds","\%-",VLen),format(Str1,Fstring,Str),!.
  tableedit_ChkValidationString1(_Win,Str,s_max(VLen),Str1):- 
	tableedit_frontstr3(VLen,Str,Str1),!.
  tableedit_ChkValidationString1(_Win,Str,s_upper,Str1):- 
	upper_lower(Str1,Str),!.
  tableedit_ChkValidationString1(_Win,Str,s_lower,Str1):- 
	upper_lower(Str,Str1),!.

  tableedit_frontstr3(Max,StrIn,StrOut):-
	str_len(StrIn,Len), Len>Max,
	frontstr(Max,StrIn,StrOut,_),
	!.
  tableedit_frontstr3(_,StrIn,StrIn).

  tableedit_GetGridData(Win,Row,Column,String,Fg_Col,Bg_Col):-
	tableedit_GetTbaleedData(Win,Row,Column,CellData),
	tableedit_CellDataToGridData(Win,CellData,Column,String,Fg_Col,Bg_Col),
	!.

  tableedit_GetTbaleedData(Win,Row,Column,CellData):-
	tableedit_db_Te_Info(Win,bufferingmode(nobuffering)),
	tableedit_db_Data_Info(Win,Data),
	tableedit_member_index(ColumnData,Data,Row),
	tableedit_member_index(CellData,ColumnData,Column),
	!.
  tableedit_GetTbaleedData(Win,Row,Column,CellData):-
	tableedit_db_Te_Info(Win,bufferingmode(buffering(_AnsFunc,_RowBuffSize,_MaxRows))),
	tableedit_GetBuffCellData(Win,Row,Column,CellData),
	!.

predicates
procedure  tableedit_ReplaceString(STRING Src,STRING Search,STRING Rep,STRING Out)
procedure  tableedit_ReplaceString1(STRING Src,STRING Search,STRING Rep,STRING,STRING Out)
clauses

  tableedit_ReplaceString(Str1,SearchStr,Repstr,OS):-
	trap(tableedit_ReplaceString1(Str1,SearchStr,Repstr,"",OS),_,fail),!.
  tableedit_ReplaceString(_,_,_,""):-errorexit().

  tableedit_ReplaceString1(Str1,SearchStr,Repstr,OurStr1,OS):-
	searchstring(Str1,SearchStr,Pos),
	Pos1 = Pos - 1,
	frontstr(Pos1,Str1,STR11,STR12),
	str_len(SearchStr,Len),
	frontstr(Len,STR12,_,STR22),
	concat(OurStr1,STR11,OurStr2),
	concat(OurStr2,Repstr,OutStr3),!,
	tableedit_ReplaceString1(STR22,SearchStr,Repstr,OutStr3,OS).
  tableedit_ReplaceString1(Str1,_SearchStr,_Repstr,OurStr1,OS):-
	concat(OurStr1,Str1,OS),
	!.
  tableedit_ReplaceString1(_,_,_,_,""):-errorexit().

