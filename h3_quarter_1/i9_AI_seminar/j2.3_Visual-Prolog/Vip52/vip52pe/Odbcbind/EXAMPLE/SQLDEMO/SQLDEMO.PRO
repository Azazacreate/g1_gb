/******************************************************************************

		Copyright (c) 1984 - 1998 Prolog Development Center A/S

 Project:	SQLDEMO
 FileName:	SQLDEMO.PRO
 Purpose: Sample program shows how GRID custom control may be connected
 	  with various databases through Windows ODBC. Result - is the
 	  simple database browser/editor.
 Written by:	Sergey Alexeev
 Build:		005.970916
 Comments:
******************************************************************************/
ifdef platform_16bit
code = 5000
enddef

include "sqldemo.con"
include "sqldemo.inc"
include "dbfunc.pro"

constants
  grid_ctrl_id = 101
  idc_insert = 102
  idc_delete = 103

database - grid_sql_db
  base_win(WINDOW ChildWin,WINDOW GridWin,INTEGER IdBase)

constants
  demo_note1	= "	So far as SQLDEMO is the simplest database browser/editor it may fails to open some databases in cases as:"
  demo_note2	= "\n - database contains MEMO-fields or fields with very long strings,  pictures, sounds, OLE-objects;"
  demo_note3	= "\n - database contains indexes which are not consistent with data (records were edited but not reindexed);"
  demo_note4	= "\n - possibly in some other cases."
  demo_note5	= "\n	Please test this program with non-critical data, we cannot make guarantees for the security of "
  demo_note6	= "your data. We also cannot guarantee that this example application will run in every environment, on "
  demo_note7	= "any Windows compatible machine, together with any other application, without producing errors. Any liability for damage of any sort is hereby denied."
/***************************************************************************
		Event handling for the Task window
***************************************************************************/
predicates
  task_win_eh : EHANDLER
  childwin_eh : EHANDLER
  grid_class_handler : EHANDLER
  tb_Create(WINDOW Win)
  close_table_all()
  get_opening_base(INTEGER NumBase)

clauses
  task_win_eh(Win,e_Create(_),0):-
	odbcInit(),
	class_Create("grid",grid_class_handler),
	tb_Create(Win),
	msg_Create(100),
	win_PostEvent(Win,e_User(0,0)),
	!.
  task_win_eh(Win,e_Create(_),0):-
	dlg_Note("ODBC support is not instaled"),
	win_Destroy(Win),!.

  task_win_eh(_Win,e_User(0,0),0):-
	concat(demo_note1,demo_note2,Msg1),
	concat(Msg1,demo_note3,Msg2),
	concat(Msg2,demo_note4,Msg3),
	concat(Msg3,demo_note5,Msg4),
	concat(Msg4,demo_note6,Msg5),
	concat(Msg5,demo_note7,Msg),
	dlg_note(Msg),!.

  task_win_eh(Win,e_Menu(id_open_base,_ShiftCtlAlt),0):-
	get_opening_base(NumBase),
	L = 10 + NumBase * 20, T = 30 + NumBase * 20,
	R = L + 640, B = T + 440,
	win_Create(w_TopLevel,rct(L,T,R,B),"DB Browser",no_menu,Win,
		[wsf_SizeBorder,wsf_TitleBar,wsf_Close,wsf_ClipSiblings,wsf_ClipChildren],
		childwin_eh,0),!.

  task_win_eh(Win,e_Menu(id_exit,_ShiftCtlAlt),0):-
	win_Destroy(Win),!.

  task_win_eh(Win,e_Size(_Height,_Width),0):-
	toolbar_Resize(Win),
	msg_Resize(Win),!.

  task_win_eh(_,e_Destroy,0):-
	close_table_all(),
	odbcDestroy(),
	class_Destroy("grid"),
	!,fail.

  tb_Create(Win):-
	toolbar_create(tb_top,color_ltgray,Win,
		[tb_ctrl(id_open_base,pushb,idb_open_up,idb_open_dn,idb_open_up,"Open Base;Open Base",1,1),
		 separator,
		 tb_ctrl(id_exit,pushb,idb_exit_up,idb_exit_dn,idb_exit_up,"Exit;Exit",1,1)]),!.

predicates
  get_opening_base1(ILIST BaseList,INTEGER Null,INTEGER NumBase)
clauses
  get_opening_base(NumBase):-
	findall(IdBase,base_win(_,_,IdBase),BaseList),
	get_opening_base1(BaseList,0,NumBase1),
	NumBase = NumBase1 mod 10,!.
	
  get_opening_base1([],NumBase,NumBase):-!.
  get_opening_base1([_|Rest],Null,NumBase):-
	N = Null + 1,!,
	get_opening_base1(Rest,N,NumBase).

  close_table_all():-
	base_win(ChildWin,_,_),
	Ctl1 = win_GetCtlHandle(ChildWin,idc_ok),
  	win_SendEvent(ChildWin,e_Control(idc_ok,wc_PushButton,Ctl1,activated())),
  	fail.
  close_table_all().

/***************************************************************************
			Main Goal Project
***************************************************************************/
GOAL
  vpi_SetAttrVal(attr_win_mdi,b_true),
  vpi_SetAttrVal(attr_win_3dcontrols,b_true),
  vpi_SetAttrVal(attr_win_tbar,28),
  vpi_Init([wsf_SizeBorder,wsf_TitleBar,wsf_Close,wsf_Maximize,
	    wsf_Minimize,wsf_Maximized,wsf_ClipSiblings,wsf_ClipChildren],
	    task_win_eh,res_menu(idr_task_menu),"sqldemo","GRID + SQL Demo").

/***************************************************************************
		child window event handler
***************************************************************************/
predicates
  records_insert(WINDOW GridWin)
  records_delete(WINDOW GridWin)
  close_base(INTEGER IdBase)

clauses
  childwin_eh(Win,e_Create(_),0):-
	win_SetForeColor(Win,color_Black),
	 win_CreateDynControl([
	 	customctl(wdef(wc_Custom,rct(10,10,630,380),"",u_Pixels),
			"grid",grid_ctrl_id,[ctl_Group,ctl_TabStop]),
	 	ctl(wdef(wc_PushButton,rct(10,390,210,410),"Close",u_Pixels),
			idc_ok,[ctl_Group,ctl_TabStop]),
	 	ctl(wdef(wc_PushButton,rct(220,390,420,410),"Insert record",u_Pixels),
			idc_insert,[ctl_Group,ctl_TabStop]),
	 	ctl(wdef(wc_PushButton,rct(430,390,630,410),"Delete record",u_Pixels),
			idc_delete,[ctl_Group,ctl_TabStop])
			],Win),!.

  childwin_eh(Win,e_Control(idc_ok,_,_,activated()),0):-
	retract(base_win(Win,_,IdBase)),!,
	close_base(IdBase),
	trap(win_Destroy(Win),_,fail).

  childwin_eh(Win,e_Control(idc_insert,_,_,activated()),0):-
	base_win(Win,GridWin,_),!,
	records_insert(GridWin).

  childwin_eh(Win,e_Control(idc_delete,_,_,activated()),0):-
	base_win(Win,GridWin,_),!,
	records_delete(GridWin).

  childwin_eh(Win,e_Update(_),0):-
	win_Clear(Win,0x808040),!.
  	
  childwin_eh(Win,e_Closerequest(),0):-
	retract(base_win(Win,_,IdBase)),!,
	close_base(IdBase),
	trap(win_Destroy(Win),_,fail).

  childwin_eh(Win,e_Size(Width,Height),0):-
	base_win(Win,GridWin,_),
	R = Width - 20,B = Height - 40,
	win_Move(GridWin,rct(10,10,R,B)),
	Ctrl1 = win_GetCtlHandle(Win,idc_ok),
	T1 = Height - 30, B1 = Height - 10,
	Size = (Width - 40) div 3,
	L1 = 10, R1 = L1 + Size,
	win_Move(Ctrl1,rct(L1,T1,R1,B1)),
	Ctrl2 = win_GetCtlHandle(Win,idc_insert),
	L2 = R1 + 10, R2 = L2 + Size,
	win_Move(Ctrl2,rct(L2,T1,R2,B1)),
	Ctrl3 = win_GetCtlHandle(Win,idc_delete),
	L3 = R2 + 10, R3 = L3 + Size,
	win_Move(Ctrl3,rct(L3,T1,R3,B1)),!.

  childwin_eh(_Win,_EVENT,0):-!,fail.

  close_base(0):-!.
  close_base(IdBase):-
	odbc_close_table(IdBase),!.
  close_base(_).
/***************************************************************************
		"grid" custom control class handler
***************************************************************************/
predicates
  get_base_name(WINDOW PWIN,STRING BaseName)
  get_user_pass(WINDOW PWIN,STRING UserName,STRING Password)
  INTEGER getTableNameList(STRING BaseName,STRING UserName,STRING Password,SLIST TableNameList)
  get_table_name(WINDOW PWIN,SLIST TableNameList,STRING TableName)
  open_table(INTEGER IdBase,STRING TableName,LONG MaxRow,UNSIGNED MaxColumn,SLIST NameList,ILIST TypeList)
  get_column_style(INTEGER FromColumn,INTEGER ToColumn,SLIST NameList,
	ILIST TypeList,GRID_COLUMN_LIST,GRID_COLUMN_LIST)
  grid_callback : GRID_CALLBACK
clauses
  grid_class_handler(GridWin,e_Create(_),0):-
	ChildWin = win_GetParent(GridWin),
	assert(base_win(ChildWin,GridWin,0)),
	get_base_name(ChildWin,BaseName),
	format(Title1,"DB Browser: Base - \"%s\"",BaseName),
	win_SetText(ChildWin,Title1),
	get_user_pass(ChildWin,UserName,Password),
	IdBase = getTableNameList(BaseName,UserName,Password,TableNameList),
	retract(base_win(ChildWin,GridWin,0)),
	assert(base_win(ChildWin,GridWin,IdBase)),
	get_table_name(ChildWin,TableNameList,TableName),
	format(Title2,"DB Browser: Base - \"%s\", Table - \"%s\"",BaseName,TableName),
	win_SetText(ChildWin,Title2),
	open_table(IdBase,TableName,MaxRow,MaxColumn,NameList,TypeList),
	get_column_style(1,MaxColumn,NameList,TypeList,[],ColumnStyle),!,
	MaxRowInt=val(integer,MaxRow),
	grid_init(GridWin,
		grid_style(grid_raised,color_LtGray,0x808040,0xC0DCC0,color_LtGray,color_Blue),
		grid_rowstyle(50,MaxRowInt,1,grid_number,b_true),
		grid_columnstyle(0,ColumnStyle),
		grid_callback),!.
  grid_class_handler(GridWin,e_Create(_),0):-
	base_win(ChildWin,GridWin,_),!,
  	win_PostEvent(ChildWin,e_Closerequest()),!.

  grid_class_handler(GridWin,EVENT,0):-
  	grid_HandleEvent(GridWin,EVENT),!.


predicates
  dlg_base_eh	: EHANDLER
  getBaseNameList(SLIST BaseNameList)
clauses
  get_base_name(PWIN,BaseName):-
	getBaseNameList(BaseNameList),
	dialog_Create(PWIN,[resdlg(idd_select_data_base,wd_Modal)],
  		[
		df(idc_select_data_base_1,listbox(BaseNameList,[0]),nopr)
		],
		dlg_base_eh,0,VALLIST,ANSWER),
	vpi_ProcessEvents(b_false),
	ANSWER = idc_ok,
	dialog_VLGetListBox(idc_select_data_base_1,VALLIST,BaseName1,_),
	BaseName1 = [BaseName|_],!.

  dlg_base_eh(Win,e_Control(idc_select_data_base_1,_,_,activated()),0):-
	Window = win_GetCtlHandle(Win,idc_ok),
	win_SendEvent(Win,e_Control(idc_ok,wc_PushButton,Window,activated())),!.

predicates
  dlg_user_eh	: EHANDLER
clauses
  get_user_pass(PWIN,UserName,Password):-
	dialog_Create(PWIN,[resdlg(idd_user_password,wd_Modal)],
  		[
		df(idc_user_password_1,editstr("",[]),nopr),
		df(idc_user_password_2,editstr("",[]),nopr)
		],
		dlg_user_eh,0,VALLIST,ANSWER),
	vpi_ProcessEvents(b_false),
	ANSWER = idc_ok,
	UserName = dialog_VLGetStr(idc_user_password_1,VALLIST),
	Password = dialog_VLGetStr(idc_user_password_2,VALLIST),!.

  dlg_user_eh(_,_,0):-fail.

predicates
  put_error()
clauses
  getBaseNameList(BaseNameList):-
	odbc_GetBaseNameList(BaseNameList),!.
  getBaseNameList(_):-
	put_error(),
	fail.

  put_error():-
	odbcGetError(_,ErrFunc,ErrMess),
	format(ErrStr,"Error in function '%s': \"%s\"",ErrFunc,ErrMess),
	dlg_Note(ErrStr),!.

  getTableNameList(BaseName,UserName,Password,TableNameList,IdBase):-
	IdBase = odbc_GetTableNameList(BaseName,UserName,Password,TableNameList),!.
  getTableNameList(_,_,_,_,_):-
	put_error(),
	fail.


predicates
  dlg_table_eh	: EHANDLER
clauses
  get_table_name(PWIN,TableNameList,TableName):-
	dialog_Create(PWIN,[resdlg(idd_select_table,wd_Modal)],
  		[
		df(idc_select_table_1,listbox(TableNameList,[0]),nopr)
		],
		dlg_table_eh,0,VALLIST,ANSWER),
	vpi_ProcessEvents(b_false),
	ANSWER = idc_ok,
	dialog_VLGetListBox(idc_select_table_1,VALLIST,TableName1,_),
	TableName1 = [TableName|_],!.

  dlg_table_eh(Win,e_Control(idc_select_table_1,_,_,activated()),0):-
	Window = win_GetCtlHandle(Win,idc_ok),
	win_SendEvent(Win,e_Control(idc_ok,wc_PushButton,Window,activated())),!.

  open_table(IdBase,TableName,MaxRow,MaxColumn,NameList,TypeList):-
	odbc_open_table(IdBase,TableName,MaxRow,MaxColumn,NameList,TypeList),!.
  open_table(_,_,_,_,_,_):-
	put_error(),
	fail.

predicates
  reverse_list(GRID_COLUMN_LIST,GRID_COLUMN_LIST,GRID_COLUMN_LIST)
  get_hor_align(INTEGER,GRID_HORALIGNMENT)
clauses
  get_column_style(FromColumn,ToColumn,_,_,Style1,Style):-
	FromColumn > ToColumn,
	reverse_list(Style1,[],Style),!.
  get_column_style(FromColumn,ToColumn,[Name|NameRest],[Type|TypeRest],S,Style):-
	get_hor_align(Type,HorAlign),
	FC = FromColumn + 1,
	get_column_style(FC,ToColumn,NameRest,TypeRest,[grid_col(Name,200,HorAlign,grid_center,4,0,32000)|S],Style).

  reverse_list([],List,List):-!.
  reverse_list([A|Rest],MIL,List):-
	reverse_list(Rest,[A|MIL],List).

  get_hor_align(odbc_bit,grid_right_align):-!.
  get_hor_align(odbc_byte,grid_right_align):-!.
  get_hor_align(odbc_integer,grid_right_align):-!.
  get_hor_align(odbc_long,grid_right_align):-!.
  get_hor_align(odbc_float,grid_right_align):-!.
  get_hor_align(odbc_real,grid_right_align):-!.
  get_hor_align(_,grid_left_align):-!.

/***************************************************************************
		"grid" custom control callback function
***************************************************************************/
predicates
  column_attributes(WINDOW GridWin,UNSIGNED Column)
  get_data(INTEGER IdBase,INTEGER From_Row,INTEGER To_Row,INTEGER From_Column,
	INTEGER To_Column,GRIDLIST2D,GRIDLIST2D)
  get_data1(INTEGER IdBase,INTEGER Row,INTEGER From_Column,INTEGER To_Column,
	GRIDLIST,GRIDLIST)
  get_data2(INTEGER IdBase,INTEGER Row,INTEGER Column,GRIDTEXT)

clauses
  grid_callback(_,user_action(grid_all_marker_beg),event_answer(stop)):-!.
  grid_callback(_,user_action(grid_area_marker_beg(_,_)),event_answer(stop)):-!.
  grid_callback(GridWin,user_action(grid_row_marker_beg(Row)),event_answer(stop)):-
	grid_Marker(GridWin,grid_no_marker),
	grid_Marker(GridWin,grid_row_marker([gl(Row,Row)])),!.
  grid_callback(GridWin,user_action(grid_col_marker_beg(Column)),event_answer(stop)):-
	column_attributes(GridWin,Column),!.
  grid_callback(GridWin,data_request(grid_area(From_Row,To_Row,From_Column,To_Column)),
	data_answer(grid_area_answer(CellList))):-
	base_win(_,GridWin,IdBase),
	get_data(IdBase,From_Row,To_Row,From_Column,To_Column,[],CellList),!.
  grid_callback(GridWin,user_action(modified(Row,Column,String)),event_answer(continue)):-
	base_win(_,GridWin,IdBase),
	get_data2(IdBase,Row,Column,Answer),
	Answer = textatr(String,_,_),!.
  grid_callback(GridWin,user_action(modified(Row,Column,String)),event_answer(continue)):-
	base_win(_,GridWin,IdBase),
	RowChanged = odbc_PutData(IdBase,Row,Column,String),
	writef("% Row changed\n",RowChanged),
	grid_Invalidate(GridWin,grid_all),!.
  grid_callback(GridWin,user_action(modified(_,_,_)),event_answer(continue)):-
	base_win(_,GridWin,IdBase),
	put_error(),
	odbc_Requery(IdBase),!.

  get_data(_,From_Row,To_Row,_,_,CellList2d,CellList2d):-
	From_Row > To_Row,!.
  get_data(IdBase,From_Row,To_Row,From_Column,To_Column,List2d,CellList2d):-
	get_data1(IdBase,To_Row,From_Column,To_Column,[],List),
	TR = To_Row - 1,
	get_data(IdBase,From_Row,TR,From_Column,To_Column,[List|List2d],CellList2d),!.

  get_data1(_,_,From_Column,To_Column,CellList,CellList):-
	From_Column > To_Column,!.
  get_data1(IdBase,Row,From_Column,To_Column,List,CellList):-
	get_data2(IdBase,Row,To_Column,Answer),
	TC = To_Column - 1,
	get_data1(IdBase,Row,From_Column,TC,[Answer|List],CellList),!.

  get_data2(IdBase,Row,Column,textatr(String,color_Black,color_LtGray)):-
	odbc_GetData(IdBase,Row,Column,String),!.
  get_data2(_,_,_,empty_answer).

%------------------------------------------------------------------------
%		Database handling
%------------------------------------------------------------------------
  records_insert(GridWin):-
	base_win(_,GridWin,IdBase),
	RowInserted = odbc_InsRow(IdBase),
	writef("% Row inserted\n",RowInserted),
	grid_Rows(GridWin,MaxRowOld),
	MaxRowNew = MaxRowOld + RowInserted,
ifdef platform_16bit
	MaxRowNewConverted=val(integer,MaxRowNew),
	grid_Rows(GridWin,MaxRowNewConverted),
elsedef
	grid_Rows(GridWin,MaxRowNew),
enddef
	grid_Invalidate(GridWin,grid_all),
ifdef platform_16bit
	grid_Marker(GridWin,grid_row_marker([gl(MaxRowNewConverted,MaxRowNewConverted)])),
elsedef
	grid_Marker(GridWin,grid_row_marker([gl(MaxRowNew,MaxRowNew)])),
enddef
	grid_Marker(GridWin,grid_no_marker),!.
  records_insert(GridWin):-
	dlg_Note("Can not insert row to this table"),
	base_win(_,GridWin,IdBase),
	odbc_Requery(IdBase),!.

predicates
  records_delete1(WINDOW GridWin,LONG Row)
clauses
  records_delete(GridWin):-
	grid_Marker(GridWin,Marker),
	Marker = grid_row_marker([gl(Row,_)]),!,
	records_delete1(GridWin,Row).
  records_delete(_):-
	dlg_Note("To delete record(s) put the row marker first by clicking mouse button inside record selector area.").

  records_delete1(GridWin,Row):-
	base_win(_,GridWin,IdBase),
	RowDeleted = odbc_DelRow(IdBase,Row),
	writef("% Row deleted\n",RowDeleted),
	grid_Rows(GridWin,MaxRowOld),
	MaxRowNew = MaxRowOld - RowDeleted,
ifdef platform_16bit
	MaxRowNewConverted=val(integer,MaxRowNew),
	grid_Rows(GridWin,MaxRowNewConverted),
elsedef
	grid_Rows(GridWin,MaxRowNew),
enddef
	grid_Invalidate(GridWin,grid_all),!.
  records_delete1(GridWin,_):-
	base_win(_,GridWin,IdBase),
	put_error(),
	odbc_Requery(IdBase),!.

predicates
  dlg_column_eh : EHANDLER
clauses
  column_attributes(GridWin,Column):-
	base_win(_,GridWin,IdBase),
	odbc_GetColumnAttr(IdBase,Column,Primary,AutoIncrement,CaseSensitive,_Count,DisplaySize,Label,
	Length,Money,Name,Nullable,OwnerName,Precision,QualifierName,
	Scale,Searchable,TableName,Type,TypeName,Unsigned,Updatable),
	str_int(ColumnS,Column),
	dialog_Create(GridWin,[resdlg(idd_column_attributes,wd_Modal)],
  		[
		df(idc_column_attributes_1,editstr(ColumnS,[]),nopr),
		df(idc_column_attributes_2,editstr(Name,[]),nopr),
		df(idc_column_attributes_3,editstr(Type,[]),nopr),
		df(idc_column_attributes_4,editstr(Length,[]),nopr),
		df(idc_column_attributes_5,editstr(TypeName,[]),nopr),
		df(idc_column_attributes_6,editstr(DisplaySize,[]),nopr),
		df(idc_column_attributes_7,editstr(Scale,[]),nopr),
		df(idc_column_attributes_8,editstr(QualifierName,[]),nopr),
		df(idc_column_attributes_9,editstr(Precision,[]),nopr),
		df(idc_column_attributes_10,editstr(OwnerName,[]),nopr),
		df(idc_column_attributes_11,editstr(Unsigned,[]),nopr),
		df(idc_column_attributes_12,editstr(TableName,[]),nopr),
		df(idc_column_attributes_13,editstr(AutoIncrement,[]),nopr),
		df(idc_column_attributes_14,editstr(Label,[]),nopr),
		df(idc_column_attributes_15,editstr(CaseSensitive,[]),nopr),
		df(idc_column_attributes_16,editstr(Money,[]),nopr),
		df(idc_column_attributes_17,editstr(Nullable,[]),nopr),
		df(idc_column_attributes_18,editstr(Searchable,[]),nopr),
		df(idc_column_attributes_19,editstr(Updatable,[]),nopr),
		df(idc_column_attributes_20,editstr(Primary,[]),nopr)
		],
		dlg_column_eh,0,_,_),!.
  column_attributes(_,_):-
	put_error(),
	fail.

  dlg_column_eh(_,_,0):-fail.

	
