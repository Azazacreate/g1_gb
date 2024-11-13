/******************************************************************************

		Copyright (c) 1984 - 1998 Prolog Development Center A/S

 Project:	SQLDEMO
 FileName:	DBFUNC.PRO
 Purpose:	High level interface with Windows ODBC
 Written by:	Sergey Alexeev
 Build:		005.970916
 Comments:
******************************************************************************/
constants
  buff_len_in_bytes = 50000

domains
  ODBC_BUFF_DATA = s(STRING);
		   null
  ODBC_BUFF_DATA_LIST = ODBC_BUFF_DATA*
  BLIST = BOOLEAN*

database - odbc_db
  odbc_open_base(INTEGER Id,STRING BaseName,HENV,HDBC,HSTMT,STRING TableName,
	STRING SelectStr,LONG MaxRow,UNSIGNED MaxColumn,SLIST NameList,
	ILIST TypeList,BLIST FullSizeList,ILIST SearchableList,ILIST PrimaryList,
	BLIST UpdatableList)
  odbc_cursor(INTEGER Id,LONG RowCursor)
  odbc_buffer_attr(INTEGER Id,LONG BuffSize,LONG FirstRow,LONG LastRow)
  odbc_buffer(INTEGER Id,LONG Row,ODBC_BUFF_DATA_LIST)

/***********************************************************************
			odbc_GetBaseNameList
***********************************************************************/
predicates
  odbc_GetBaseNameList(SLIST NameList)
  odbc_GetBaseNameList1(HENV,SLIST Null,SLIST NameList)
clauses
  odbc_GetBaseNameList(NameList):-
	trap(odbcAllocEnv(Henv),_,fail),
	trap(odbcDataSources(Henv,odbc_fetch_first,Name,_),_,fail),
	odbc_GetBaseNameList1(Henv,[Name],NameList),
	trap(odbcFreeEnv(Henv),_,fail),!.

  odbc_GetBaseNameList1(Henv,NL,NameList):-
	trap(odbcDataSources(Henv,odbc_fetch_next,Name,_),_,fail),!,
	odbc_GetBaseNameList1(Henv,[Name|NL],NameList).
  odbc_GetBaseNameList1(_,NameList,NameList).

/***********************************************************************
			odbc_GetTableNameList
***********************************************************************/
predicates
  INTEGER odbc_GetTableNameList(STRING BaseName,STRING UserName,STRING Password,SLIST TableNameList)
  connect_base(STRING BaseName,STRING UserName,STRING Password,HENV,HDBC)
  odbc_GetTableNameList1(HENV,HDBC,HSTMT,SLIST Null,SLIST TableNameList)
  get_new_id(INTEGER First,INTEGER Id)
clauses
  odbc_GetTableNameList(BaseName,UserName,Password,TableNameList,Id):-
	connect_base(BaseName,UserName,Password,Henv,Hdbc),
	trap(odbcAllocStmt(Henv,Hdbc,Hstmt),_,fail),
	trap(odbcGetInfo(Henv,Hdbc,odbc_database_name,Data),_,fail),
	Data = s(TableQualifier),
	trap(odbcTables(Henv,Hdbc,Hstmt,TableQualifier,"NULL_STRING","%","TABLE"),_,fail),
	odbc_GetTableNameList1(Henv,Hdbc,Hstmt,[],TableNameList),
	trap(odbcFreeStmt(Henv,Hdbc,Hstmt,odbc_close),_,fail),
	get_new_id(1,Id),
	assert(odbc_open_base(Id,BaseName,Henv,Hdbc,Hstmt,"","",0,0,[],[],[],[],[],[])),!.

  connect_base(BaseName,_,_,Henv,Hdbc):-
	odbc_open_base(_,BaseName,Henv,Hdbc,_,_,_,_,_,_,_,_,_,_,_),!.
  connect_base(BaseName,UserName,Password,Henv,Hdbc):-
	trap(odbcAllocEnv(Henv),_,fail),
	trap(odbcAllocConnect(Henv,Hdbc),_,fail),
	trap(odbcConnect(Henv,Hdbc,BaseName,UserName,Password),_,fail),!.

  odbc_GetTableNameList1(Henv,Hdbc,Hstmt,Null,TableNameList):-
	trap(odbcFetch(Henv,Hdbc,Hstmt),_,fail),
	trap(odbcGetData(Henv,Hdbc,Hstmt,3,odbc_string,256,Data,_),_,fail),
	Data = s(TableName),!,
	odbc_GetTableNameList1(Henv,Hdbc,Hstmt,[TableName|Null],TableNameList).
  odbc_GetTableNameList1(_,_,_,TableNameList,TableNameList).

  get_new_id(Id,Id):-
	not(odbc_open_base(Id,_,_,_,_,_,_,_,_,_,_,_,_,_,_)),!.
  get_new_id(First,Id):-
	F = First + 1,!,
	get_new_id(F,Id).

/***********************************************************************
			odbc_open_table
***********************************************************************/
predicates
  odbc_bracket(STRING,STRING)
clauses
  odbc_bracket(Str,Str1):-
	searchchar(Str,' ',_),
	format(Str1,"[%s]",Str),!.
  odbc_bracket(Str,Str).
predicates
  odbc_bracket1(STRING,STRING)
clauses
  odbc_bracket1(Str,Str1):-
	format(Str1,"[%s]",Str),!.
predicates
  odbc_open_table(INTEGER Id,STRING TableName,LONG MaxRow,UNSIGNED MaxColumn,SLIST NameList,ILIST TypeList)
  odbc_get_primary_column(HENV,HDBC,HSTMT,STRING TableName,SLIST PrimaryList)
  odbc_get_max_column(HENV,HDBC,HSTMT,UNSIGNED MaxColumn,SLIST NameList,
  	ILIST TypeList,BLIST FullSizeList,ILIST SearchableList,BLIST UpdatableList,
  	UNSIGNED RowLen)
  odbc_get_primary_int(SLIST PrimaryListS,SLIST NameList,ILIST Null,ILIST PrimaryList)
  odbc_reverse_list(ODBC_BUFF_DATA_LIST InList,ODBC_BUFF_DATA_LIST Null,ODBC_BUFF_DATA_LIST OutList)
  odbc_get_max_row(INTEGER Id,HENV,HDBC,HSTMT,LONG Null,LONG MaxRow,LONG Null1,UNSIGNED BuffSize,
	UNSIGNED MaxColumn,ILIST ListType)
  odbc_min(LONG A1,LONG A2,LONG A)
clauses
  odbc_open_table(Id,TableName,MaxRow,MaxColumn,NameList,TypeList):-
	odbc_open_base(Id,BaseName,Henv,Hdbc,Hstmt,_,_,_,_,_,_,_,_,_,_),
	odbc_get_primary_column(Henv,Hdbc,Hstmt,TableName,PrimaryListS),
	odbc_bracket(TableName,TableNameBracket),
	format(SelectStr,"SELECT * FROM %s",TableNameBracket),
	write(SelectStr), nl,
	trap(odbcExecDirect(Henv,Hdbc,Hstmt,SelectStr),_,fail),
	odbc_get_max_column(Henv,Hdbc,Hstmt,MaxColumn,NameList,TypeList,
	FullSizeList,SearchableList,UpdatableList,RowLen),
	odbc_get_primary_int(PrimaryListS,NameList,[],PrimaryList),
	BuffSize = buff_len_in_bytes div val(long,RowLen),
	retractall(odbc_buffer(Id,_,_)),
	write("--> Data loading From row 1 to row "),
ifdef platform_16bit
	BuffSizeConverted=val(unsigned,BuffSize),
	odbc_get_max_row(Id,Henv,Hdbc,Hstmt,0,MaxRow,1,BuffSizeConverted,MaxColumn,TypeList),
elsedef
	odbc_get_max_row(Id,Henv,Hdbc,Hstmt,0,MaxRow,1,BuffSize,MaxColumn,TypeList),
enddef
	retract(odbc_open_base(Id,_,_,_,_,_,_,_,_,_,_,_,_,_,_)),
	assert(odbc_open_base(Id,BaseName,Henv,Hdbc,Hstmt,TableName,SelectStr,MaxRow,MaxColumn,
		NameList,TypeList,FullSizeList,SearchableList,PrimaryList,UpdatableList)),
	retractall(odbc_cursor(Id,_)),
	assert(odbc_cursor(Id,MaxRow)),
	retractall(odbc_buffer_attr(Id,_,_,_)),
	odbc_min(BuffSize,MaxRow,LastRow),
	assert(odbc_buffer_attr(Id,BuffSize,1,LastRow)),
	writef("% ...Done\n",LastRow),!.

predicates
  odbc_get_primary_column1(Henv,Hdbc,Hstmt,SLIST Null,SLIST PrimaryList)
clauses
  odbc_get_primary_column(Henv,Hdbc,Hstmt,TableName,PrimaryList):-
	trap(odbcGetInfo(Henv,Hdbc,odbc_database_name,Data),_,fail),
	Data = s(TableQualifier),
	trap(odbcStatistics(Henv,Hdbc,Hstmt,TableQualifier,"NULL_STRING",
	TableName,odbc_index_all,odbc_quick),_,fail),
	odbc_get_primary_column1(Henv,Hdbc,Hstmt,[],PrimaryList),
	trap(odbcFreeStmt(Henv,Hdbc,Hstmt,odbc_close),_,fail),!.
  odbc_get_primary_column(_,_,_,_,[]).

predicates
  odbc_get_primary_column2(ODBC_DATA,SLIST In,SLIST Out)
clauses
  odbc_get_primary_column1(Henv,Hdbc,Hstmt,Null,PrimaryList):-
	trap(odbcFetch(Henv,Hdbc,Hstmt),_,fail),
	trap(odbcGetData(Henv,Hdbc,Hstmt,9,odbc_string,256,Data,_),_,fail),
	odbc_get_primary_column2(Data,Null,NullOut),!,
	odbc_get_primary_column1(Henv,Hdbc,Hstmt,NullOut,PrimaryList).
  odbc_get_primary_column1(_,_,_,PrimaryList,PrimaryList).

predicates
  check_unique(STRING Primary,SLIST Null)
clauses
  odbc_get_primary_column2(s(Primary),Null,[Primary|Null]):-
	check_unique(Primary,Null),!.
  odbc_get_primary_column2(_,Null,Null):-!.

  check_unique(_,[]):-!.
  check_unique(Primary,[Primary|_]):-!,fail.
  check_unique(Primary,[_|NullRest]):-
	check_unique(Primary,NullRest).

predicates
  odbc_get_primary_int1(STRING PrimaryS,SLIST NameList,INTEGER Null,INTEGER Primary)
clauses
  odbc_get_primary_int([],_,PrimaryList,PrimaryList):-!.
  odbc_get_primary_int([PrimaryS|PrimaryRestS],NameList,Null,PrimaryList):-
	odbc_get_primary_int1(PrimaryS,NameList,1,Primary),!,
	odbc_get_primary_int(PrimaryRestS,NameList,[Primary|Null],PrimaryList).

  odbc_get_primary_int1(PrimaryS,[PrimaryS|_],Primary,Primary):-!.
  odbc_get_primary_int1(PrimaryS,[_|NameRest],Null,Primary):-
	N = Null + 1,!,
	odbc_get_primary_int1(PrimaryS,NameRest,N,Primary).

predicates
  odbc_get_column_attr(HENV,HDBC,HSTMT,UNSIGNED MaxColumn,SLIST Null,SLIST NameList,
	ILIST Null,ILIST TypeList,BLIST Null,BLIST FullSizeList,
	ILIST Null,ILIST SearchableList,BLIST UpdatableList,BLIST UpdatableList,
	UNSIGNED Null,UNSIGNED RowLen)
clauses
  odbc_get_max_column(Henv,Hdbc,Hstmt,MaxColumn,NameList,TypeList,FullSizeList,
	SearchableList,UpdatableList,RowLen):-
	trap(odbcNumResultCols(Henv,Hdbc,Hstmt,MaxColumn),_,fail),
	odbc_get_column_attr(Henv,Hdbc,Hstmt,MaxColumn,[],NameList,[],TypeList,
	[],FullSizeList,[],SearchableList,[],UpdatableList,0,RowLen),!.

predicates
  ajust_len(UNSIGNED Len1,UNSIGNED Len,BOOLEAN FullSize)
  get_updatable(ODBC_COLUMN_DATA,BOOLEAN)
clauses
  odbc_get_column_attr(_,_,_,0,NameList,NameList,TypeList,TypeList,
	FullSizeList,FullSizeList,SearchableList,SearchableList,UpdatableList,
	UpdatableList,RowLen,RowLen):-!.
  odbc_get_column_attr(Henv,Hdbc,Hstmt,Column,Names,NameList,Types,TypeList,
	FullSizes,FullSizeList,Searchables,SearchableList,Updatables,UpdatableList,
	Lens,RowLen):-
	trap(odbcDescribeCol(Henv,Hdbc,Hstmt,Column,Name,Type,_,_,_),_,fail),
	trap(odbcColAttributes(Henv,Hdbc,Hstmt,Column,odbc_column_length,Data1),_,fail),
	Data1 = le(Len1),
	trap(odbcColAttributes(Henv,Hdbc,Hstmt,Column,odbc_column_searchable,Data2),_,fail),
	Data2 = se(Searchable),
	trap(odbcColAttributes(Henv,Hdbc,Hstmt,Column,odbc_column_updatable,Data3),_,fail),
	get_updatable(Data3,Updatable),
ifdef platform_16bit
	Len1Converted=val(unsigned,Len1),
	ajust_len(Len1Converted,Len,FullSize),
elsedef
	ajust_len(Len1,Len,FullSize),
enddef
	L = Lens + Len,
	C = Column - 1,
	odbc_get_column_attr(Henv,Hdbc,Hstmt,C,[Name|Names],NameList,[Type|Types],TypeList,
	[FullSize|FullSizes],FullSizeList,[Searchable|Searchables],SearchableList,
	[Updatable|Updatables],UpdatableList,L,RowLen).

  get_updatable(up(odbc_attr_write),b_true):-!.
  get_updatable(_,b_false):-!.

  ajust_len(0,100,b_false):-!.
  ajust_len(Len,100,b_false):-
	Len > 100,!.
  ajust_len(Len,Len,b_true):-!.

  odbc_reverse_list([],List,List):-!.
  odbc_reverse_list([A|Rest],MIL,List):-
	odbc_reverse_list(Rest,[A|MIL],List).

predicates
  odbc_load_row(INTEGER Id,HENV,HDBC,HSTMT,LONG Row,UNSIGNED MaxColumn,UNSIGNED Column,ILIST ListType,ODBC_BUFF_DATA_LIST)
clauses
  odbc_get_max_row(Id,Henv,Hdbc,Hstmt,Null,MaxRow,Null1,BuffSize,MaxColumn,ListType):-
	Null1 <= BuffSize,
	trap(odbcFetch(Henv,Hdbc,Hstmt),_,fail),
	odbc_load_row(Id,Henv,Hdbc,Hstmt,Null1,MaxColumn,1,ListType,[]),!,
	N = Null + 1,
	N1 = Null1 + 1,
	odbc_get_max_row(Id,Henv,Hdbc,Hstmt,N,MaxRow,N1,BuffSize,MaxColumn,ListType).
  odbc_get_max_row(Id,Henv,Hdbc,Hstmt,Null,MaxRow,Null1,BuffSize,MaxColumn,ListType):-
	trap(odbcFetch(Henv,Hdbc,Hstmt),_,fail),!,
	N = Null + 1,
	odbc_get_max_row(Id,Henv,Hdbc,Hstmt,N,MaxRow,Null1,BuffSize,MaxColumn,ListType).
  odbc_get_max_row(_,_,_,_,MaxRow,MaxRow,_,_,_,_).

predicates
clauses
predicates
  odbc_get_data(ODBC_DATA,ODBC_BUFF_DATA)
clauses
  odbc_load_row(Id,_,_,_,Row,MaxColumn,Column,_,DataList1):-
	Column > MaxColumn,
	odbc_reverse_list(DataList1,[],DataList),
	assert(odbc_buffer(Id,Row,DataList)),!.
  odbc_load_row(Id,Henv,Hdbc,Hstmt,Row,MaxColumn,Column,[DataType|Rest],DataList):-
	trap(odbcGetData(Henv,Hdbc,Hstmt,Column,DataType,100,Data,_),_,fail),
	odbc_get_data(Data,Answer),
	C = Column + 1,!,
	odbc_load_row(Id,Henv,Hdbc,Hstmt,Row,MaxColumn,C,Rest,[Answer|DataList]).
  odbc_load_row(Id,Henv,Hdbc,Hstmt,Row,MaxColumn,Column,[_|Rest],DataList):-
	C = Column + 1,!,
	odbc_load_row(Id,Henv,Hdbc,Hstmt,Row,MaxColumn,C,Rest,[s("<Error loading>")|DataList]).

  odbc_get_data(s(DataS),s(DataS)):-!.
  odbc_get_data(bit(Data),s(DataS)):-
	str_int(DataS,Data),!.
  odbc_get_data(byte(Data),s(DataS)):-
	str_int(DataS,Data),!.
  odbc_get_data(i(Data),s(DataS)):-
	str_int(DataS,Data),!.
  odbc_get_data(l(Data),s(DataS)):-
	trap(term_str(long,Data,DataS),_,fail),!.
  odbc_get_data(f(Data),s(DataS)):-
	str_real(DataS,Data),!.
  odbc_get_data(r(Data),s(DataS)):-
	str_real(DataS,Data),!.
  odbc_get_data(d(DataS),s(DataS)):-!.
  odbc_get_data(t(DataS),s(DataS)):-!.
  odbc_get_data(ts(DataS),s(DataS)):-!.
  odbc_get_data(b(_),s("<Binary data>")):-!.
  odbc_get_data(n(DataS),s(DataS)):-!.
  odbc_get_data(null,null):-!.

/***********************************************************************
			odbc_close_table
***********************************************************************/
predicates
  odbc_close_table(INTEGER Id)
  odbc_close_table1(STRING BaseName,HENV,HDBC)
clauses
  odbc_close_table(Id):-
	retract(odbc_open_base(Id,BaseName,Henv,Hdbc,Hstmt,_,_,_,_,_,_,_,_,_,_)),
	retractall(odbc_cursor(Id,_)),
	retractall(odbc_buffer_attr(Id,_,_,_)),
	retractall(odbc_buffer(Id,_,_)),
	trap(odbcFreeStmt(Henv,Hdbc,Hstmt,odbc_drop),_,fail),
	odbc_close_table1(BaseName,Henv,Hdbc),!.
  odbc_close_table(_).

  odbc_close_table1(BaseName,Henv,Hdbc):-
	not(odbc_open_base(_,BaseName,_,_,_,_,_,_,_,_,_,_,_,_,_)),
	trap(odbcDisconnect(Henv,Hdbc),_,fail),
	trap(odbcFreeConnect(Henv,Hdbc),_,fail),
	trap(odbcFreeEnv(Henv),_,fail),!.
  odbc_close_table1(_,_,_).

/***********************************************************************
			odbc_GetData
***********************************************************************/
predicates
  odbc_GetData(INTEGER Id,LONG Row,UNSIGNED Column,STRING Answer)
  odbc_member_index(UNSIGNED,ODBC_BUFF_DATA_LIST,ODBC_BUFF_DATA)
  odbc_member_index(UNSIGNED,SLIST,STRING)
  odbc_member_index(UNSIGNED,ILIST,INTEGER)
  odbc_member_index(UNSIGNED,BLIST,BOOLEAN)
  odbc_answer_data(ODBC_BUFF_DATA,STRING)
  odbc_reload_buffer(INTEGER Id,LONG Row)
clauses
  odbc_GetData(Id,Row,Column,Answer):-
	odbc_buffer(Id,Row,DataList),
	odbc_member_index(Column,DataList,Data),
	odbc_answer_data(Data,Answer),!.
  odbc_GetData(Id,Row,Column,Answer):-
	odbc_reload_buffer(Id,Row),
	odbc_GetData(Id,Row,Column,Answer).

  odbc_member_index(1,[S|_],S):-!.
  odbc_member_index(M,[_|L],S):-
        N = M - 1,
        odbc_member_index(N,L,S),!.

  odbc_answer_data(s(Answer),Answer):-!.
  odbc_answer_data(null,"<Null>"):-!.

predicates
  odbc_get_buffer_attr(INTEGER Id,LONG Row,LONG MaxRow,LONG FirstRow,LONG LastRow)
  odbc_goto_row(INTEGER Id,HENV,HDBC,HSTMT,LONG TargetRow)
  odbc_get_buffer(INTEGER Id,HENV,HDBC,HSTMT,LONG FirstRow,LONG LastRow,UNSIGNED MaxColumn,
	ILIST ListType)
clauses
  odbc_reload_buffer(Id,Row):-
	odbc_open_base(Id,_,Henv,Hdbc,Hstmt,_,_,MaxRow,MaxColumn,_,TypeList,_,_,_,_),
	odbc_get_buffer_attr(Id,Row,MaxRow,FirstRow,LastRow),
	writef("--> Data loading From row % to row %",FirstRow,LastRow),
	odbc_goto_row(Id,Henv,Hdbc,Hstmt,FirstRow),
	odbc_get_buffer(Id,Henv,Hdbc,Hstmt,FirstRow,LastRow,MaxColumn,TypeList),
	retract(odbc_cursor(Id,_)),
	assert(odbc_cursor(Id,LastRow)),
	write(" ...Done\n"),!.

predicates
  odbc_max(LONG A1,LONG A2,LONG A)
  odbc_check_buffer(INTEGER Id,LONG NewFirstRow,LONG NewLastRow,LONG CurrFirstRow,LONG CurrLastRow,LONG NewFirstRow,LONG LastRow)
clauses
  odbc_get_buffer_attr(Id,Row,MaxRow,FirstRow,LastRow):-
	odbc_buffer_attr(Id,BuffSize,CurrFirstRow,CurrLastRow),
	FirstRow1R = Row - BuffSize * 0.5,
	FirstRow1 = val(integer,FirstRow1R),
	odbc_max(FirstRow1,1,FirstRow2),
	LastRow1 = FirstRow2 + BuffSize - 1,
	odbc_min(LastRow1,MaxRow,NewLastRow),
	FirstRow3 = NewLastRow - BuffSize + 1,
	odbc_max(FirstRow3,1,NewFirstRow),
	odbc_check_buffer(Id,NewFirstRow,NewLastRow,CurrFirstRow,CurrLastRow,FirstRow,LastRow),!.

predicates
  retract_buffer(INTEGER Id,LONG RetFirstRow,LONG RetLastRow)
clauses
  odbc_check_buffer(Id,NewFirstRow,NewLastRow,_,CurrLastRow,NewFirstRow,NewLastRow):-
	NewFirstRow > CurrLastRow,
	retractall(odbc_buffer(Id,_,_)),
	retract(odbc_buffer_attr(Id,BuffSize,_,_)),
	assert(odbc_buffer_attr(Id,BuffSize,NewFirstRow,NewLastRow)),!.
  odbc_check_buffer(Id,NewFirstRow,NewLastRow,CurrFirstRow,_,NewFirstRow,NewLastRow):-
	NewLastRow < CurrFirstRow,
	retractall(odbc_buffer(Id,_,_)),
	retract(odbc_buffer_attr(Id,BuffSize,_,_)),
	assert(odbc_buffer_attr(Id,BuffSize,NewFirstRow,NewLastRow)),!.
  odbc_check_buffer(Id,NewFirstRow,NewLastRow,CurrFirstRow,CurrLastRow,FirstRow,NewLastRow):-
	NewFirstRow > CurrFirstRow,
	FirstRow = CurrLastRow + 1,
	RetFirstRow = CurrFirstRow,
	RetLastRow = NewFirstRow - 1,
	retract_buffer(Id,RetFirstRow,RetLastRow),
	retract(odbc_buffer_attr(Id,BuffSize,_,_)),
	assert(odbc_buffer_attr(Id,BuffSize,NewFirstRow,NewLastRow)),!.
  odbc_check_buffer(Id,NewFirstRow,NewLastRow,CurrFirstRow,CurrLastRow,NewFirstRow,LastRow):-
	NewLastRow < CurrLastRow,
	LastRow = CurrFirstRow - 1,
	RetFirstRow = NewLastRow + 1,
	RetLastRow = CurrLastRow,
	retract_buffer(Id,RetFirstRow,RetLastRow),
	retract(odbc_buffer_attr(Id,BuffSize,_,_)),
	assert(odbc_buffer_attr(Id,BuffSize,NewFirstRow,NewLastRow)),!.

  retract_buffer(Id,RetFirstRow,RetLastRow):-
	odbc_buffer(Id,Row,_),
	RetFirstRow <= Row, Row <= RetLastRow,
	retractall(odbc_buffer(Id,Row,_)),
	fail.
  retract_buffer(_,_,_).

  odbc_max(A1,A2,A1):-
	A1 >= A2,!.
  odbc_max(_,A2,A2).
  odbc_min(A1,A2,A1):-
	A1 <= A2,!.
  odbc_min(_,A2,A2).

predicates
  odbc_fetch_row(HENV,HDBC,HSTMT,LONG Diff)
clauses
  odbc_goto_row(Id,Henv,Hdbc,Hstmt,Target):-
	odbc_cursor(Id,CurrRow),
	Target > CurrRow,!,
	Diff = Target - CurrRow,
	odbc_fetch_row(Henv,Hdbc,Hstmt,Diff),!.
  odbc_goto_row(Id,Henv,Hdbc,Hstmt,Target):-
	odbc_open_base(Id,_,_,_,_,_,SelectStr,_,_,_,_,_,_,_,_),
	trap(odbcFreeStmt(Henv,Hdbc,Hstmt,odbc_close),_,fail),
	trap(odbcExecDirect(Henv,Hdbc,Hstmt,SelectStr),_,fail),
	odbc_fetch_row(Henv,Hdbc,Hstmt,Target),!.

  odbc_fetch_row(_,_,_,1):-!.
  odbc_fetch_row(Henv,Hdbc,Hstmt,Diff):-
	trap(odbcFetch(Henv,Hdbc,Hstmt),_,fail),!,
	D = Diff - 1,
	odbc_fetch_row(Henv,Hdbc,Hstmt,D).

  odbc_get_buffer(Id,Henv,Hdbc,Hstmt,FirstRow,LastRow,MaxColumn,ListType):-
	FirstRow <= LastRow,
	trap(odbcFetch(Henv,Hdbc,Hstmt),_,fail),!,
	odbc_load_row(Id,Henv,Hdbc,Hstmt,FirstRow,MaxColumn,1,ListType,[]),
	FR = FirstRow + 1,
	odbc_get_buffer(Id,Henv,Hdbc,Hstmt,FR,LastRow,MaxColumn,ListType).
  odbc_get_buffer(_,_,_,_,_,_,_,_).
/***********************************************************************
			odbc_PutData
***********************************************************************/
predicates
  LONG odbc_PutData(INTEGER Id,LONG Row,UNSIGNED Column,STRING Data)
  odbc_get_row_changed(HENV,HDBC,HSTMT,LONG RowChanged)
  odbc_get_set(UNSIGNED Column,STRING Data,SLIST NameList,ILIST TypeList,STRING Set)
  odbc_get_where(INTEGER Id,LONG Row,SLIST NameList,ILIST TypeList,BLIST FullSizeList,
	ILIST SearchableList,ILIST PrimaryList,STRING Where)
clauses
  odbc_PutData(Id,Row,Column,Data,RowChanged):-
	odbc_open_base(Id,_,Henv,Hdbc,Hstmt,TableName,SelectStr,_,_,NameList,TypeList,
	FullSizeList,SearchableList,PrimaryList,_),
	odbc_get_set(Column,Data,NameList,TypeList,Set),
	odbc_get_where(Id,Row,NameList,TypeList,FullSizeList,SearchableList,PrimaryList,Where),
	odbc_bracket(TableName,TableNameBracket),
	format(SqlStr,"UPDATE %s SET %s WHERE %s",TableNameBracket,Set,Where),
write(SqlStr), nl,
	trap(odbcFreeStmt(Henv,Hdbc,Hstmt,odbc_close),_,fail),
	trap(odbcExecDirect(Henv,Hdbc,Hstmt,SqlStr),_,fail),
	odbc_get_row_changed(Henv,Hdbc,Hstmt,RowChanged),
	trap(odbcFreeStmt(Henv,Hdbc,Hstmt,odbc_close),_,fail),
	trap(odbcExecDirect(Henv,Hdbc,Hstmt,SelectStr),_,fail),
	retract(odbc_cursor(Id,_)),
	assert(odbc_cursor(Id,0)),
	retract(odbc_buffer_attr(Id,BuffSize,_,_)),
	assert(odbc_buffer_attr(Id,BuffSize,0,0)),
	retractall(odbc_buffer(Id,_,_)),!.

  odbc_get_row_changed(Henv,Hdbc,Hstmt,RowChanged):-
	trap(odbcRowCount(Henv,Hdbc,Hstmt,RowChanged),_,fail),!.
  odbc_get_row_changed(_,_,_,0).

predicates
  odbc_sql_param(STRING Data1,INTEGER Type,STRING Data)
clauses
  odbc_get_set(Column,Data1,NameList,TypeList,Set):-
	odbc_member_index(Column,NameList,Name),
	odbc_member_index(Column,TypeList,Type),
	odbc_sql_param(Data1,Type,Data),
	odbc_bracket1(Name,NameBracket),
	format(Set,"%s = %s",NameBracket,Data),!.

  odbc_sql_param(Data,odbc_bit,Data):-!.
  odbc_sql_param(Data,odbc_byte,Data):-!.
  odbc_sql_param(Data,odbc_integer,Data):-!.
  odbc_sql_param(Data,odbc_long,Data):-!.
  odbc_sql_param(Data,odbc_float,Data):-!.
  odbc_sql_param(Data,odbc_real,Data):-!.
  odbc_sql_param(Data,odbc_numeric,Data):-!.
  odbc_sql_param(Data1,odbc_date,Data):-
	format(Data,"#%s#",Data1),!.
  odbc_sql_param(Data1,odbc_time,Data):-
	format(Data,"#%s#",Data1),!.
  odbc_sql_param(Data1,odbc_timestamp,Data):-
	format(Data,"#%s#",Data1),!.
  odbc_sql_param(Data1,_,Data):-
	format(Data,"'%s'",Data1),!.

predicates
  odbc_get_where1(INTEGER Id,LONG Row,SLIST NameList,ILIST TypeList,BLIST FullSizeList,
	ILIST SearchableList,STRING Where)
  odbc_check_where(ILIST PrimaryList,BLIST FullSizeList,ILIST SearchableList)
  odbc_get_where4(INTEGER Id,LONG Row,SLIST NameList,ILIST TypeList,ILIST PrimaryList,
	STRING Where)
clauses
  odbc_get_where(Id,Row,NameList,TypeList,FullSizeList,SearchableList,[],Where):-
	odbc_get_where1(Id,Row,NameList,TypeList,FullSizeList,SearchableList,Where),!.
  odbc_get_where(Id,Row,NameList,TypeList,FullSizeList,SearchableList,PrimaryList,Where):-
	odbc_check_where(PrimaryList,FullSizeList,SearchableList),
	odbc_get_where4(Id,Row,NameList,TypeList,PrimaryList,Where),!.
  odbc_get_where(Id,Row,NameList,TypeList,FullSizeList,SearchableList,_,Where):-
	odbc_get_where1(Id,Row,NameList,TypeList,FullSizeList,SearchableList,Where),!.

predicates
  odbc_check_searchable(INTEGER Searchable)
clauses
  odbc_check_where([],_,_):-!.
  odbc_check_where([Primary|PrimaryRest],FullSizeList,SearchableList):-!,
	odbc_member_index(Primary,FullSizeList,FullSize),
	FullSize = b_true,
	odbc_member_index(Primary,SearchableList,Searchable),
	odbc_check_searchable(Searchable),
	odbc_check_where(PrimaryRest,FullSizeList,SearchableList).

  odbc_check_searchable(odbc_all_except_like):-!.
  odbc_check_searchable(odbc_searchable):-!.

predicates
  odbc_get_where2(ODBC_BUFF_DATA_LIST,SLIST NameList,ILIST TypeList,
	BLIST FullSizeList,ILIST SearchableList,BOOLEAN FirstParam,STRING Null,STRING Where)
clauses
  odbc_get_where1(Id,Row,NameList,TypeList,FullSizeList,SearchableList,Where):-
	odbc_buffer(Id,Row,DataList),
	odbc_get_where2(DataList,NameList,TypeList,FullSizeList,SearchableList,
	b_true,"",Where),!.
  odbc_get_where1(Id,Row,NameList,TypeList,FullSizeList,SearchableList,Where):-
	odbc_reload_buffer(Id,Row),
	odbc_get_where1(Id,Row,NameList,TypeList,FullSizeList,SearchableList,Where).

predicates
  odbc_sql_param1(ODBC_BUFF_DATA,INTEGER Type,STRING Data)
  odbc_get_where3(ODBC_BUFF_DATA,STRING Name,INTEGER Type,BOOLEAN FullSize,
	INTEGER Searchable,BOOLEAN FirstIn,BOOLEAN FirstOut,STRING WhereIn,
	STRING WhereOut)
clauses
  odbc_get_where2([],[],[],[],[],_,Where,Where):-!.
  odbc_get_where2([Data|DataRest],[Name|NameRest],[Type|TypeRest],
  [FullSize|FullSizeRest],[Searchable|SearchableRest],FirstIn,WhereIn,Where):-!,
	odbc_get_where3(Data,Name,Type,FullSize,Searchable,FirstIn,FirstOut,WhereIn,WhereOut),
	odbc_get_where2(DataRest,NameRest,TypeRest,FullSizeRest,SearchableRest,
	FirstOut,WhereOut,Where).

  odbc_get_where3(_,_,_,_,odbc_unsearchable,First,First,Where,Where):-!.
  odbc_get_where3(_,_,_,_,odbc_like_only,First,First,Where,Where):-!.
  odbc_get_where3(_,_,_,b_false,_,First,First,Where,Where):-!.
  odbc_get_where3(Data1,Name,Type,_,_,b_true,b_false,WhereIn,WhereOut):-
	odbc_sql_param1(Data1,Type,Data),
	odbc_bracket1(Name,NameBracket),
	format(WhereOut,"%s (%s %s)",WhereIn,NameBracket,Data),!.
  odbc_get_where3(Data1,Name,Type,_,_,b_false,b_false,WhereIn,WhereOut):-
	odbc_sql_param1(Data1,Type,Data),
	odbc_bracket1(Name,NameBracket),
	format(WhereOut,"%s AND (%s %s)",WhereIn,NameBracket,Data),!.

  odbc_sql_param1(null,_,"IS NULL"):-!.
  odbc_sql_param1(s(Data2),Type,Data):-
	odbc_sql_param(Data2,Type,Data1),
	format(Data,"= %s",Data1),!.

predicates
  odbc_get_where5(ODBC_BUFF_DATA_LIST,SLIST NameList,ILIST TypeList,
	ILIST PrimaryList,BOOLEAN FirstParam,STRING Null,STRING Where)
clauses
  odbc_get_where4(Id,Row,NameList,TypeList,PrimaryList,Where):-
	odbc_buffer(Id,Row,DataList),
	odbc_get_where5(DataList,NameList,TypeList,PrimaryList,b_true,"",Where),!.
  odbc_get_where4(Id,Row,NameList,TypeList,PrimaryList,Where):-
	odbc_reload_buffer(Id,Row),
	odbc_get_where4(Id,Row,NameList,TypeList,PrimaryList,Where).

  odbc_get_where5(_,_,_,[],_,Where,Where):-!.
  odbc_get_where5(DataList,NameList,TypeList,[Primary|PrimaryRest],FirstIn,WhereIn,Where):-!,
	odbc_member_index(Primary,DataList,Data),
	odbc_member_index(Primary,NameList,Name),
	odbc_member_index(Primary,TypeList,Type),
	odbc_get_where3(Data,Name,Type,b_true,odbc_searchable,FirstIn,FirstOut,WhereIn,WhereOut),
	odbc_get_where5(DataList,NameList,TypeList,PrimaryRest,FirstOut,WhereOut,Where).

/***********************************************************************
			odbc_InsRow
***********************************************************************/
predicates
  LONG odbc_InsRow(INTEGER Id)
  odbc_InsRow1(HENV,HDBC,HSTMT,STRING TableName,SLIST NameList,ILIST TypeList,
	BLIST UpdatableList)
clauses
  odbc_InsRow(Id,RowInserted):-
	odbc_open_base(Id,BaseName,Henv,Hdbc,Hstmt,TableName,SelectStr,MaxRow,MaxColumn,
	NameList,TypeList,FullSizeList,SearchableList,PrimaryList,UpdatableList),
	odbc_InsRow1(Henv,Hdbc,Hstmt,TableName,NameList,TypeList,UpdatableList),
	odbc_get_row_changed(Henv,Hdbc,Hstmt,RowInserted),
	trap(odbcFreeStmt(Henv,Hdbc,Hstmt,odbc_close),_,fail),
	trap(odbcExecDirect(Henv,Hdbc,Hstmt,SelectStr),_,fail),
	NewMaxRow = MaxRow + RowInserted,
	retract(odbc_cursor(Id,_)),
	assert(odbc_cursor(Id,0)),
	retract(odbc_buffer_attr(Id,BuffSize,_,_)),
	assert(odbc_buffer_attr(Id,BuffSize,0,0)),
	retractall(odbc_buffer(Id,_,_)),
	retract(odbc_open_base(Id,_,_,_,_,_,_,_,_,_,_,_,_,_,_)),
	assert(odbc_open_base(Id,BaseName,Henv,Hdbc,Hstmt,TableName,SelectStr,NewMaxRow,MaxColumn,
	NameList,TypeList,FullSizeList,SearchableList,PrimaryList,UpdatableList)),!.

predicates
  odbc_InsRow2(HENV,HDBC,HSTMT,STRING TableName,STRING Name,INTEGER Type,BOOLEAN Updatable)
clauses
  odbc_InsRow1(_,_,_,_,[],[],[]):-!,fail.
  odbc_InsRow1(Henv,Hdbc,Hstmt,TableName,[Name|NameRest],[Type|TypeRest],
	[Updatable|UpdatableRest]):-
	odbc_InsRow2(Henv,Hdbc,Hstmt,TableName,Name,Type,Updatable),!,
	odbc_InsRow1(Henv,Hdbc,Hstmt,TableName,NameRest,TypeRest,UpdatableRest).
  odbc_InsRow1(_,_,_,_,_,_,_).

predicates
  odbc_InsRow3(INTEGER Type,STRING Empty)
clauses
  odbc_InsRow2(_,_,_,_,_,_,b_false):-!.
  odbc_InsRow2(Henv,Hdbc,Hstmt,TableName,Name,_,_):-
	odbc_bracket(TableName,TableNameBracket),
	odbc_bracket1(Name,NameBracket),
	format(SqlStr,"INSERT INTO %s (%s) VALUES (NULL)",TableNameBracket,NameBracket),
	trap(odbcFreeStmt(Henv,Hdbc,Hstmt,odbc_close),_,fail),
	trap(odbcExecDirect(Henv,Hdbc,Hstmt,SqlStr),_,fail),!,
write(SqlStr), nl,
	fail.
  odbc_InsRow2(Henv,Hdbc,Hstmt,TableName,Name,Type,_):-
	odbc_InsRow3(Type,Empty),
	odbc_bracket(TableName,TableNameBracket),
	odbc_bracket1(Name,NameBracket),
	format(SqlStr,"INSERT INTO %s (%s) VALUES (%s)",TableNameBracket,NameBracket,Empty),
	trap(odbcFreeStmt(Henv,Hdbc,Hstmt,odbc_close),_,fail),
	trap(odbcExecDirect(Henv,Hdbc,Hstmt,SqlStr),_,fail),!,
write(SqlStr), nl,
	fail.
  odbc_InsRow2(_,_,_,_,_,_,_).

  odbc_InsRow3(odbc_string,"'Empty value'"):-!.
  odbc_InsRow3(odbc_bit,"0"):-!.
  odbc_InsRow3(odbc_byte,"0"):-!.
  odbc_InsRow3(odbc_integer,"0"):-!.
  odbc_InsRow3(odbc_long,"0"):-!.
  odbc_InsRow3(odbc_float,"0.0"):-!.
  odbc_InsRow3(odbc_real,"0.0"):-!.
  odbc_InsRow3(odbc_date,EmptyOut):-
	date(Year,Month,Day),
	format(EmptyOut,"#%-2d-%-2d-%-4d#",Month,Day,Year),!.
  odbc_InsRow3(odbc_time,EmptyOut):-
	time(Hours,Minutes,Seconds,_),
	format(EmptyOut,"#%-2d:%-2d:%-2d#",Hours,Minutes,Seconds),!.
  odbc_InsRow3(odbc_timestamp,EmptyOut):-
	date(Year,Month,Day),
	time(Hours,Minutes,Seconds,_),
	format(EmptyOut,"#%-2d-%-2d-%-4d %-2d:%-2d:%-2d#",Month,Day,Year,Hours,Minutes,Seconds),!.
  odbc_InsRow3(odbc_numeric,"0"):-!.
  odbc_InsRow3(odbc_binary,"'Empty value'"):-!.

/***********************************************************************
			odbc_DelRow
***********************************************************************/
predicates
  LONG odbc_DelRow(INTEGER Id,LONG Row)
clauses
  odbc_DelRow(Id,Row,RowDeleted):-
	odbc_open_base(Id,BaseName,Henv,Hdbc,Hstmt,TableName,SelectStr,MaxRow,MaxColumn,
	NameList,TypeList,FullSizeList,SearchableList,PrimaryList,UpdatableList),
	odbc_get_where(Id,Row,NameList,TypeList,FullSizeList,SearchableList,PrimaryList,Where),
	odbc_bracket(TableName,TableNameBracket),
	format(SqlStr,"DELETE FROM %s WHERE %s",TableNameBracket,Where),
	write(SqlStr), nl,
	trap(odbcFreeStmt(Henv,Hdbc,Hstmt,odbc_close),_,fail),
	trap(odbcExecDirect(Henv,Hdbc,Hstmt,SqlStr),_,fail),
	odbc_get_row_changed(Henv,Hdbc,Hstmt,RowDeleted),
	trap(odbcFreeStmt(Henv,Hdbc,Hstmt,odbc_close),_,fail),
	trap(odbcExecDirect(Henv,Hdbc,Hstmt,SelectStr),_,fail),
	retract(odbc_cursor(Id,_)),
	assert(odbc_cursor(Id,0)),
	retract(odbc_buffer_attr(Id,BuffSize,_,_)),
	assert(odbc_buffer_attr(Id,BuffSize,0,0)),
	retractall(odbc_buffer(Id,_,_)),
	NewMaxRow = MaxRow - RowDeleted,
	retract(odbc_open_base(Id,_,_,_,_,_,_,_,_,_,_,_,_,_,_)),
	assert(odbc_open_base(Id,BaseName,Henv,Hdbc,Hstmt,TableName,SelectStr,NewMaxRow,MaxColumn,
	NameList,TypeList,FullSizeList,SearchableList,PrimaryList,UpdatableList)),!.


/***********************************************************************
			odbc_GetColumnAttr
***********************************************************************/
predicates
  odbc_GetColumnAttr(INTEGER Id,UNSIGNED Column,STRING Primary,STRING AutoIncrement,
	STRING CaseSensitive,STRING Count,STRING DisplaySize,STRING Label,
	STRING Length,STRING Money,STRING Name,STRING Nullable,STRING OwnerName,
	STRING Precision,STRING QualifierName,STRING Scale,STRING Searchable,
	STRING TableName,STRING Type,STRING TypeName,STRING Unsigned,STRING Updatable)
  get_attr(ODBC_COLUMN_DATA,STRING)
  get_primary(INTEGER Column,ILIST PrimaryList,STRING Primary)
clauses
  odbc_GetColumnAttr(Id,Column,Primary,AutoIncrement,CaseSensitive,Count,DisplaySize,Label,
	Length,Money,Name,Nullable,OwnerName,Precision,QualifierName,
	Scale,Searchable,TableName,Type,TypeName,Unsigned,Updatable):-

	odbc_open_base(Id,_,Henv,Hdbc,Hstmt,_,_,_,_,_,_,_,_,PrimaryList,_),
	get_primary(Column,PrimaryList,Primary),
	trap(odbcColAttributes(Henv,Hdbc,Hstmt,Column,odbc_column_auto_increment,Data1),_,fail),
	get_attr(Data1,AutoIncrement),
	trap(odbcColAttributes(Henv,Hdbc,Hstmt,Column,odbc_column_case_sensitive,Data2),_,fail),
	get_attr(Data2,CaseSensitive),
	trap(odbcColAttributes(Henv,Hdbc,Hstmt,Column,odbc_column_count,Data3),_,fail),
	get_attr(Data3,Count),
	trap(odbcColAttributes(Henv,Hdbc,Hstmt,Column,odbc_column_display_size,Data4),_,fail),
	get_attr(Data4,DisplaySize),
	trap(odbcColAttributes(Henv,Hdbc,Hstmt,Column,odbc_column_label,Data5),_,fail),
	get_attr(Data5,Label),
	trap(odbcColAttributes(Henv,Hdbc,Hstmt,Column,odbc_column_length,Data6),_,fail),
	get_attr(Data6,Length),
	trap(odbcColAttributes(Henv,Hdbc,Hstmt,Column,odbc_column_money,Data7),_,fail),
	get_attr(Data7,Money),
	trap(odbcColAttributes(Henv,Hdbc,Hstmt,Column,odbc_column_name,Data8),_,fail),
	get_attr(Data8,Name),
	trap(odbcColAttributes(Henv,Hdbc,Hstmt,Column,odbc_column_nullable,Data9),_,fail),
	get_attr(Data9,Nullable),
	trap(odbcColAttributes(Henv,Hdbc,Hstmt,Column,odbc_column_owner_name,Data10),_,fail),
	get_attr(Data10,OwnerName),
	trap(odbcColAttributes(Henv,Hdbc,Hstmt,Column,odbc_column_precision,Data11),_,fail),
	get_attr(Data11,Precision),
	trap(odbcColAttributes(Henv,Hdbc,Hstmt,Column,odbc_column_qualifier_name,Data12),_,fail),
	get_attr(Data12,QualifierName),
	trap(odbcColAttributes(Henv,Hdbc,Hstmt,Column,odbc_column_scale,Data13),_,fail),
	get_attr(Data13,Scale),
	trap(odbcColAttributes(Henv,Hdbc,Hstmt,Column,odbc_column_searchable,Data14),_,fail),
	get_attr(Data14,Searchable),
	trap(odbcColAttributes(Henv,Hdbc,Hstmt,Column,odbc_column_table_name,Data15),_,fail),
	get_attr(Data15,TableName),
	trap(odbcColAttributes(Henv,Hdbc,Hstmt,Column,odbc_column_type,Data16),_,fail),
	get_attr(Data16,Type),
	trap(odbcColAttributes(Henv,Hdbc,Hstmt,Column,odbc_column_type_name,Data17),_,fail),
	get_attr(Data17,TypeName),
	trap(odbcColAttributes(Henv,Hdbc,Hstmt,Column,odbc_column_unsigned,Data18),_,fail),
	get_attr(Data18,Unsigned),
	trap(odbcColAttributes(Henv,Hdbc,Hstmt,Column,odbc_column_updatable,Data19),_,fail),
	get_attr(Data19,Updatable),!.

predicates
  search_from_list(INTEGER,ILIST)
clauses
  get_primary(Column,PrimaryList,"TRUE"):-
	search_from_list(Column,PrimaryList),!.
  get_primary(_,_,"FALSE").

  search_from_list(Column,[Column|_]):-!.
  search_from_list(Column,[_|Rest]):-!,
	search_from_list(Column,Rest).

  get_attr(ai(b_true),"TRUE"):-!.
  get_attr(ai(b_false),"FALSE"):-!.
  get_attr(cs(b_true),"TRUE"):-!.
  get_attr(cs(b_false),"FALSE"):-!.
  get_attr(co(Data),DataS):-
	str_int(DataS,Data),!.
  get_attr(ds(Data),DataS):-
	trap(term_str(long,Data,DataS),_,fail),!.
  get_attr(la(DataS),DataS):-!.
  get_attr(le(Data),DataS):-
	trap(term_str(long,Data,DataS),_,fail),!.
  get_attr(mo(b_true),"TRUE"):-!.
  get_attr(mo(b_false),"FALSE"):-!.
  get_attr(na(DataS),DataS):-!.
  get_attr(nu(odbc_no_nulls),"No nulls"):-!.
  get_attr(nu(odbc_nullable),"Nullable"):-!.
  get_attr(nu(odbc_nullable_unknown),"Nullable unknown"):-!.
  get_attr(on(DataS),DataS):-!.
  get_attr(pr(Data),DataS):-
	trap(term_str(long,Data,DataS),_,fail),!.
  get_attr(qn(DataS),DataS):-!.
  get_attr(sc(Data),DataS):-
	trap(term_str(long,Data,DataS),_,fail),!.
  get_attr(se(odbc_unsearchable),"Unsearchable"):-!.
  get_attr(se(odbc_like_only),"Like only"):-!.
  get_attr(se(odbc_all_except_like),"All except like"):-!.
  get_attr(se(odbc_searchable),"Searchable"):-!.
  get_attr(tn(DataS),DataS):-!.
  get_attr(ty(odbc_string),"String"):-!.
  get_attr(ty(odbc_bit),"Bit"):-!.
  get_attr(ty(odbc_byte),"Byte"):-!.
  get_attr(ty(odbc_integer),"Integer"):-!.
  get_attr(ty(odbc_long),"Long"):-!.
  get_attr(ty(odbc_float),"Float"):-!.
  get_attr(ty(odbc_real),"Real"):-!.
  get_attr(ty(odbc_date),"Date"):-!.
  get_attr(ty(odbc_time),"Time"):-!.
  get_attr(ty(odbc_timestamp),"Timestamp"):-!.
  get_attr(ty(odbc_binary),"Binary"):-!.
  get_attr(ty(odbc_numeric),"Numeric"):-!.
  get_attr(ta(DataS),DataS):-!.
  get_attr(un(b_true),"TRUE"):-!.
  get_attr(un(b_false),"FALSE"):-!.
  get_attr(up(odbc_attr_readonly),"Readonly"):-!.
  get_attr(up(odbc_attr_write),"Write"):-!.
  get_attr(up(odbc_attr_readwrite_unknown),"Readwrite unknown"):-!.

/***********************************************************************
			odbc_Requery
***********************************************************************/
predicates
  odbc_Requery(INTEGER Id)
clauses
  odbc_Requery(Id):-
	odbc_open_base(Id,_,Henv,Hdbc,Hstmt,_,SelectStr,_,_,_,_,_,_,_,_),
	trap(odbcFreeStmt(Henv,Hdbc,Hstmt,odbc_close),_,fail),
	trap(odbcExecDirect(Henv,Hdbc,Hstmt,SelectStr),_,fail),
	retract(odbc_cursor(Id,_)),
	assert(odbc_cursor(Id,0)),
	retract(odbc_buffer_attr(Id,BuffSize,_,_)),
	assert(odbc_buffer_attr(Id,BuffSize,0,0)),
	retractall(odbc_buffer(Id,_,_)),!.

