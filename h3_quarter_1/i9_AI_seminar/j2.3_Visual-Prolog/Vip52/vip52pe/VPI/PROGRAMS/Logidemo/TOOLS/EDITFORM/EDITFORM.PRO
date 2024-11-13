/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:	EDITFORM
 FileName:	EDITFORM.PRE
 Purpose:	FORMS EDITOR
 Written by:	Andrey Skobelev
 Comments:
*****************************************************************************/

/**************************************************************************
Creation and event handling for producer form (Table Id - 1)
**************************************************************************/
include "trans.con"

domains
  LONGLIST = LONG*
  REALLIST = REAL*

constants
  id_formscreate =	2210
  id_change =		2211
  id_modified =		2212
  id_insert_row =	2213
  id_filter =		2214

database - edit_db
  ef_db_edit_forms(INTEGER TableId,WINDOW,WINLIST FormWindows)
  ef_db_FormMap(INTEGER IdForm,LONGLIST IdList)
  ef_db_ModifData(INTEGER IdForm,INTEGER IdOperation,INTEGER Row,INTEGER Column)
  ef_db_edit_filter(INTEGER IdForm,TABLEEDIT_FILTERS FilterList)
  ef_db_change

predicates
  ef_child_eh : EHANDLER
  ef_tab_Callback : TABLEEDIT_CALLBACK 
procedure  ef_formswins_Create(WINDOW)
procedure  ef_get_producerList(TABLEEDIT_DATA ProducerList)
procedure  ef_get_customerList(TABLEEDIT_DATA CustomerList)
procedure  ef_get_sortList(TABLEEDIT_DATA SortList)
procedure  ef_get_2xList(INTEGER IdCon,TABLEEDIT_DATA RowList,TABLEEDIT_COLUMNLIST TitleList)
procedure  ef_get_MoveList(TABLEEDIT_DATA MoveList)
procedure  ef_get_UnplacedNeedsList(INTEGER FormId,TABLEEDIT_COLUMNLIST TitleList,TABLEEDIT_DATA RowList)
procedure  ef_calc_UnplacedTotal(TABLEEDIT_DATA,TABLEEDIT_COLUMNDATA,TABLEEDIT_COLUMNDATA)

procedure  ef_init_forms(INTEGER IdForm)
procedure  ef_size_forms(WINDOW)
determ  ef_handle_modifiedRow(WINDOW,INTEGER Row,INTEGER Col)
determ  ef_handle_insert(WINDOW,INTEGER Row)
procedure  ef_reInitForms(WINDOW,INTEGER IdForm,INTEGER Row,INTEGER Column)
procedure  ef_handle_filter(WINDOW)
procedure  ef_get_formRct(INTEGER ID,RCT)
procedure  ef_get_formTitle(INTEGER FormId,STRING Title)
procedure  ef_reassert_NewFormRct()
procedure  ef_reassert_NewFormRct1(WINDOW FormWin,INTEGER IDForm)
procedure  get_DataPath(STRING FileName)

clauses

  %---------------------------------------
  % Registration of data changing
  %---------------------------------------
  ef_changeRegister():-
	retractAll(ef_db_change),
	assert(ef_db_change),
	!.

  %---------------------------------------
  % Unregistration of data changing
  %---------------------------------------
  ef_changeUnRegister():-
	retractAll(ef_db_change),
	!.
  
  %---------------------------------------
  % Data changed
  %---------------------------------------
  ef_change_Notify(ButtonNum):-
	ef_db_change,
	get_DataPath(FileName),
	format(NotifyStr,"Do you want to save changes to %s",FileName),
	ButtonNum=dlg_MessageBox("",NotifyStr,mesbox_iconInformation,mesbox_buttonsYesNoCancel,mesbox_defaultFirst,mesbox_suspendApplication),
	!.
  ef_change_Notify(2):-!.

  get_DataPath(FileName):-
	ini_db_name(FileName),!.
  get_DataPath(default_FileName):-!.
	  

  
  %---------------------------------------
  % Set font
  %---------------------------------------
  ef_set_font():-
	ini_db_font(NewFont),
	ef_db_edit_forms(_,_,[Win]),
	  win_SetFont(Win,NewFont),
	fail.
  ef_set_font():-!.

  %---------------------------------------
  % Close all forms
  %---------------------------------------
  ef_close_Form():-
	retract(ef_db_edit_forms(_,Win,_)),
	win_Destroy(Win),
	fail.
  ef_close_Form():-!.

  %---------------------------------------
  % retract databases
  %---------------------------------------
  ef_clear_Data():-
	retractAll(ef_db_FormMap(_,_)),
	retractAll(ef_db_ModifData(_,_,_,_)),
	retractAll(ef_db_edit_filter(_,_)),
	retractAll(ef_db_change()),
	retractAll(ini_db_name(_)),
	retractAll(_,trans_db),
	!.

  ef_get_formRct(ID,Rct):- ini_db_layout(ID,Rct,_),!.
  ef_get_formRct(con_producer,rct(90,90,390,390)):-!.
  ef_get_formRct(con_customer,rct(100,100,400,400)):-!.
  ef_get_formRct(con_distance,rct(110,110,610,410)):-!.
  ef_get_formRct(con_sort,rct(120,120,620,420)):-!.
  ef_get_formRct(con_production,rct(130,130,630,430)):-!.
  ef_get_formRct(con_custom,rct(140,140,640,440)):-!.
  ef_get_formRct(con_move,rct(150,150,650,450)):-!.
  ef_get_formRct(con_unplaced,rct(160,160,660,460)):-!.
  ef_get_formRct(con_needs,rct(170,170,670,470)):-!.
  ef_get_formRct(_,rct(50,50,550,350)):-!.
  
  ef_get_formTitle(con_producer,"Manufacturer"):-!.
  ef_get_formTitle(con_customer,"Customer"):-!.
  ef_get_formTitle(con_distance,"Transportation cost of one unit"):-!.
  ef_get_formTitle(con_sort,"Goods"):-!.
  ef_get_formTitle(con_production,"Production"):-!.
  ef_get_formTitle(con_custom,"Order"):-!.
  ef_get_formTitle(con_move,"Transportation"):-!.
  ef_get_formTitle(con_unplaced,"Unplaced goods"):-!.
  ef_get_formTitle(con_needs,"Backlog of demand"):-!.
  ef_get_formTitle(_,""):-!.

  % Set Generation status to toolbar
  set_GenStatusToToolbar():-
	genStatus(_,_,_,_,_,_,_),
	TaskWin = cast(window,vpi_GetAttrVal(attr_task_window)),
	Str = "Plan data available.",
	toolbar_SetValue(TaskWin,idt_2,text_value(Str)),
	!.
  set_GenStatusToToolbar():-
	not(genStatus(_,_,_,_,_,_,_)),
	TaskWin = cast(window,vpi_GetAttrVal(attr_task_window)),
	Str = "Plan data discarded.",
	toolbar_SetValue(TaskWin,idt_2,text_value(Str)),
	!.
  set_GenStatusToToolbar():-!.

  % Read data from "ini" file
  ef_read_formRct():-
	retractAll(_,transinit_db),
ifdef platform_16bit
	trap(consult("Trans.ini",transinit_db),_,fail),
elsedef
	trap(consult("Trans32.ini",transinit_db),_,fail),
enddef
	!.
  ef_read_formRct():-!.

  % Write data to "ini" file
  ef_write_formRct():-
	ef_reassert_NewFormRct,
ifdef platform_16bit
	trap(save("Trans.ini",transinit_db),_,fail),
elsedef
	trap(save("Trans32.ini",transinit_db),_,fail),
enddef
	!.
  ef_write_formRct():-!.

% read and assert new window position for forms
  ef_reassert_NewFormRct():-
	retract(ini_db_layout(IDForm,RCT,b_true)),
	assert(ini_db_layout(IDForm,RCT,b_false)),
	fail.
  ef_reassert_NewFormRct():-
	ef_db_edit_forms(IDForm,Win,_),
	ef_reassert_NewFormRct1(Win,IDForm),
	fail.
  ef_reassert_NewFormRct():-!.

  ef_reassert_NewFormRct1(Win,IDForm):-
	RCT = win_GetOuterRect(Win),
	RCT = rct(X1,Y1,X2,Y2),
	HT = win_GetAttrVal(Win,attr_title_height),
	HVDF = win_GetAttrVal(Win,attr_docframe_height),
	HHDF = win_GetAttrVal(Win,attr_docframe_width),
	XF1 = X1 + HHDF,
	YF1 = Y1 + HT + HVDF - 1,
	XF2 = X2 - HHDF,
	YF2 = Y2 - HVDF,
	RCT1 = rct(XF1,YF1,XF2,YF2),
	retractAll(ini_db_layout(IDForm,_,_)),
	assert(ini_db_layout(IDForm,RCT1,b_true)),
	!.
  ef_reassert_NewFormRct1(_,_):-errorexit().

  %---------------------------------------
  % Create/BringToTop child form window
  %---------------------------------------
  ef_form_Create(FormId,FilterList):- % if exist form - BringToTop
	ef_db_edit_forms(FormId,Win,[Win1]),
	tableedit_ReSetFilters(Win1,FilterList),
	ef_handle_filter(Win1),
	win_BringToTop(Win),
	!.
  ef_form_Create(FormId,FilterList):- % Create form window 
	Parent = cast(window,vpi_GetAttrVal(attr_task_window)),
	not(ef_db_edit_forms(FormId,_,_)),
	ef_get_formRct(FormId,Rct),
	ef_get_formTitle(FormId,Title),
	Win = win_Create(w_TopLevel,Rct,Title,no_menu,Parent,
		[wsf_SizeBorder,wsf_ClipChildren,wsf_ClipSiblings,wsf_TitleBar,wsf_Close],
		ef_child_eh,0),
	assert(ef_db_edit_forms(FormId,Win,[])),
	assert(ef_db_edit_filter(FormId,FilterList)),!.
  ef_form_Create(_,_):-errorexit().

  % Create custom control for table editor in child window
  ef_formswins_Create(Win):-
	retract(ef_db_edit_forms(Con,Win,[])),
	RCT = win_GetClientRect(Win),
	Wdef = wdef(wc_Custom,RCT,"",u_Pixels),
	WinDefList = [customctl(Wdef,tableed_class,tableed_id,[])],
	Win1 = win_CreateDynControl(WinDefList,Win),
	assert(ef_db_edit_forms(Con,Win,[Win1])),
	ini_db_font(Font),
	win_SetFont(Win1,Font),
	ef_init_forms(Con),
	!.
  ef_formswins_Create(_):-!.

  % initialization of table editor for form
  ef_init_forms(IdForm):-
	IdForm = con_producer,
	ef_db_edit_forms(IdForm,_Win,[Win1]),
	ef_get_producerList(ProducerList),
 	tableedit_Init(Win1,
 		[titlebackcolor(32896),callback(ef_tab_Callback),areamarker(singlearea)],
 		[column([title("Id"),column_type(te_long),width(0),resizable(b_false)]),
 		 column([title("Name"),alignment(grid_left_align)]),
 		 column([title("Comment"),width(150),alignment(grid_left_align)])
		],ProducerList),
	retract(ef_db_edit_filter(IdForm,FilterList)),
	tableedit_ReSetFilters(Win1,FilterList),
	ef_handle_filter(Win1),
	!.
  ef_init_forms(IdForm):-
	IdForm = con_customer,
	ef_db_edit_forms(IdForm,_Win,[Win1]),
	ef_get_customerList(CustomerList),
 	tableedit_Init(Win1,
 		[titlebackcolor(8421376),callback(ef_tab_Callback),areamarker(singlearea)],
 		[column([title("Id"),column_type(te_long),width(0),resizable(b_false)]),
 		 column([title("Name"),alignment(grid_left_align)]),
 		 column([title("Comment"),width(150),alignment(grid_left_align)])
		],CustomerList),
	retract(ef_db_edit_filter(IdForm,FilterList)),
	tableedit_ReSetFilters(Win1,FilterList),
	ef_handle_filter(Win1),
	!.
  ef_init_forms(IdForm):-
	IdForm = con_distance,
	ef_db_edit_forms(IdForm,_Win,[Win1]),
	retractAll(ef_db_FormMap(IdForm,_)),
	ef_get_2xList(IdForm,RowList,TitleList),
 	tableedit_Init(Win1,
 		[titlebackcolor(8421376),callback(ef_tab_Callback),
 		 rowselector(grid_number,0,b_false),insert_rows(b_false),
 		 delete_rows(b_false),nonscrollcol(2),undo_redo(b_false)
 		],
		TitleList,RowList),
	retract(ef_db_edit_filter(IdForm,FilterList)),
	tableedit_ReSetFilters(Win1,FilterList),
	ef_handle_filter(Win1),
	!.
  ef_init_forms(IdForm):-
	IdForm = con_sort,
	ef_db_edit_forms(IdForm,_Win,[Win1]),
	ef_get_sortList(SortList),
 	tableedit_Init(Win1,
 		[titlebackcolor(32768),callback(ef_tab_Callback),areamarker(singlearea)],
 		[column([title("Id"),column_type(te_long),width(0),resizable(b_false)]),
 		 column([title("Name"),alignment(grid_left_align)]),
 		 column([title("Comment"),width(150),alignment(grid_left_align)]),
 		 column([title("Draw"),alignment(grid_center)]),
 		 column([title("Color"),defaultvalue(voidc(color_Black))])
		],SortList),
	retract(ef_db_edit_filter(IdForm,FilterList)),
	tableedit_ReSetFilters(Win1,FilterList),
	ef_handle_filter(Win1),
	!.
  ef_init_forms(IdForm):-
	IdForm = con_production,
	ef_db_edit_forms(IdForm,_Win,[Win1]),
	retractAll(ef_db_FormMap(IdForm,_)),
	ef_get_2xList(IdForm,RowList,TitleList),
 	tableedit_Init(Win1,
 		[titlebackcolor(32768),callback(ef_tab_Callback),
 		 rowselector(grid_number,0,b_false),insert_rows(b_false),
 		 delete_rows(b_false),nonscrollcol(2),undo_redo(b_false)
 		],
		TitleList,RowList),
	retract(ef_db_edit_filter(IdForm,FilterList)),
	tableedit_ReSetFilters(Win1,FilterList),
	ef_handle_filter(Win1),
	!.
  ef_init_forms(IdForm):-
	IdForm = con_custom,
	ef_db_edit_forms(IdForm,_Win,[Win1]),
	retractAll(ef_db_FormMap(IdForm,_)),
	ef_get_2xList(IdForm,RowList,TitleList),
 	tableedit_Init(Win1,
 		[titlebackcolor(32768),callback(ef_tab_Callback),
 		 rowselector(grid_number,0,b_false),insert_rows(b_false),
 		 delete_rows(b_false),nonscrollcol(2),undo_redo(b_false)
 		],
		TitleList,RowList),
	retract(ef_db_edit_filter(IdForm,FilterList)),
	tableedit_ReSetFilters(Win1,FilterList),
	ef_handle_filter(Win1),
	!.
  ef_init_forms(IdForm):-
	IdForm = con_move,
	ef_db_edit_forms(IdForm,_Win,[Win1]),
	ef_get_MoveList(MoveList),
 	tableedit_Init(Win1,
 		[titlebackcolor(8388736),callback(ef_tab_Callback),
 		 insert_rows(b_false),
 		 delete_rows(b_false),readonly(b_true),footers(1),
		 allmarker(b_true),
		 areamarker(multi),
		 colmarker(singlearea),
		 rowmarker(singlearea),undo_redo(b_false)
 		],
 		[
 		 column([title("From ID"),column_type(te_long),width(0),resizable(b_false)]),
 		 column([title("To ID"),column_type(te_long),width(0),resizable(b_false)]),
 		 column([title("Manufacturer"),alignment(grid_left_align)]),
 		 column([title("Customer"),alignment(grid_left_align)]),
 		 column([title("Goods"),alignment(grid_left_align)]),
 		 column([title("Quantity"),column_type(te_real)]),
 		 column([title("Total cost"),column_type(te_real)])
		],
		MoveList),
	retract(ef_db_edit_filter(IdForm,FilterList)),
	tableedit_ReSetFilters(Win1,FilterList),
	ef_handle_filter(Win1),
	!.
  ef_init_forms(IdForm):-
	IdForm = con_unplaced,
	ef_db_edit_forms(IdForm,_Win,[Win1]),
	ef_get_UnplacedNeedsList(IdForm,TitleList,RowList),
 	tableedit_Init(Win1,
 		[titlebackcolor(32768),callback(ef_tab_Callback),
 		 insert_rows(b_false),
 		 delete_rows(b_false),readonly(b_true),footers(1),
		 allmarker(b_true),
		 areamarker(multi),
		 colmarker(singlearea),
		 rowmarker(singlearea),nonscrollcol(2),
		 undo_redo(b_false)
 		],
		TitleList,RowList),
	retract(ef_db_edit_filter(IdForm,FilterList)),
	tableedit_ReSetFilters(Win1,FilterList),
	ef_handle_filter(Win1),
	!.
  ef_init_forms(IdForm):-
	IdForm = con_needs,
	ef_db_edit_forms(IdForm,_Win,[Win1]),
	ef_get_UnplacedNeedsList(IdForm,TitleList,RowList),
 	tableedit_Init(Win1,
 		[titlebackcolor(32768),callback(ef_tab_Callback),
 		 insert_rows(b_false),
 		 delete_rows(b_false),readonly(b_true),footers(1),
		 allmarker(b_true),
		 areamarker(multi),
		 colmarker(singlearea),
		 rowmarker(singlearea),nonscrollcol(2),
		 undo_redo(b_false)
 		],
		TitleList,RowList),
	retract(ef_db_edit_filter(IdForm,FilterList)),
	tableedit_ReSetFilters(Win1,FilterList),
	ef_handle_filter(Win1),
	!.
  ef_init_forms(_):-!.

  %---------------------------------------
  % Child window event handler
  %---------------------------------------
  ef_child_eh(Win,e_Create(_),0):-  % Post event to create table editor custom control 
	win_PostEvent(Win,e_Menu(id_formscreate,c_Nothing)),
	!.

  ef_child_eh(Win,e_Menu(id_formscreate,_ShiftCtlAlt),0):-
	ef_formswins_Create(Win), % Create table editor custom control
	!.

  ef_child_eh(Win,e_Menu(id_change,_ShiftCtlAlt),0):-
	ef_db_edit_forms(IdForm,Win,[Win1]), % "modified" handling
	retract(ef_db_ModifData(IdForm,id_Modified,Row,Col)),
	ef_handle_modifiedRow(Win1,Row,Col),
	ef_reInitForms(Win1,_IdForm,Row,Col),
	!.
  ef_child_eh(Win,e_Menu(id_change,_ShiftCtlAlt),0):-
	ef_db_edit_forms(IdForm,Win,[Win1]), % "insert row" handling
	retract(ef_db_ModifData(IdForm,id_Insert_row,Row,Col)),
	ef_handle_insert(Win1,Row),
	ef_reInitForms(Win1,_IdForm,Row,Col),
	!.

  ef_child_eh(Win,e_Menu(id_filter,_ShiftCtlAlt),0):-
	ef_db_edit_forms(IdForm,Win,[Win1]), % "filter" handling
	retract(ef_db_ModifData(IdForm,id_filter,_,_)),
	ef_handle_filter(Win1),
	!.

  ef_child_eh(Win,e_Size(_Width,_Height),0):-
	ef_size_forms(Win), % move custom controm on e_Size of child window
	!.

  ef_child_eh(Win,e_CloseRequest(),0):-
	ef_reassert_NewFormRct(),
	retract(ef_db_edit_forms(_,Win,_)),!,
	ef_reassert_NewFormRct(),
	fail.

  ef_child_eh(_,_,0):-!,fail.

predicates
procedure  ef_handle_delete(WINDOW,INTEGER Row,TABLEEDIT_COLUMNDATA)
clauses

/*******************************************************************
	Table Editor class event Handler
*******************************************************************/

  tableed_class_handler(Win,EVENT,0):-		% CALL propedit_HandleEvent
	tableedit_HandleEvent(Win,Event),!.	% ON ANY EVENT

  %---------------------------------------
  % Table editor custom control callback function
  %---------------------------------------
  ef_tab_Callback(Win,delete_row(Row,Data)):- % delete row
	ef_changeRegister,
	ef_handle_delete(Win,Row,Data),
	ef_reInitForms(Win,_IdForm,Row,2),
	!,fail.

  ef_tab_Callback(Win,insert_row(Row,_)):- % insert row
	ef_changeRegister,
	ef_db_edit_forms(IdForm,MainWin,[Win]),
	assert(ef_db_ModifData(IdForm,id_Insert_row,Row,2)),!,
	win_PostEvent(MainWin,e_Menu(id_change,c_Nothing)),
	fail.

  ef_tab_Callback(Win,filter(_)):- % filtring
	ef_db_edit_forms(IdForm,MainWin,[Win]),
	assert(ef_db_ModifData(IdForm,id_filter,0,0)),!,
	win_PostEvent(MainWin,e_Menu(id_filter,c_Nothing)),
	fail.

  ef_tab_Callback(_Win,modified(_,_,_,_)):- 
 	ef_changeRegister,
 	fail.
 % forbid "viod" value seting to "Id" column
  ef_tab_Callback(Win,Mod):- 
	ef_db_edit_forms(con_producer,_MainWin,[Win]),
	Mod = modified(_,1,_,void),!.
  ef_tab_Callback(Win,Mod):- 
	ef_db_edit_forms(con_customer,_MainWin,[Win]),
	Mod = modified(_,1,_,void),!.
  ef_tab_Callback(Win,Mod):- 
	ef_db_edit_forms(con_sort,_MainWin,[Win]),
	Mod = modified(_,1,_,void),!.

  ef_tab_Callback(Win,modified(Row,Col,_Old,_New)):- 
	ef_db_edit_forms(IdForm,MainWin,[Win]),
	assert(ef_db_ModifData(IdForm,id_modified,Row,Col)),!,
	win_PostEvent(MainWin,e_Menu(id_change,c_Nothing)),
	fail.

  % Set "X" to column N 4 on action(area_marker_beg(...)) callback
  ef_tab_Callback(Win,action(Marker)):- 
	ef_db_edit_forms(con_sort,_MainWin,[Win]),
	Marker = area_marker_beg(Row,4),
	Draw = tableedit_GetCellData(Win,Row,4),
	IDT = tableedit_GetCellData(Win,Row,1),
	Draw = void, IdT = l(SortId),
	tableedit_SetCellData(Win,Row,4,s("X")),
	retract(tr_db_sort(SortId,SortName,Comment,_,Color)),
	assert(tr_db_sort(SortId,SortName,Comment,b_true,Color)),
	mv_MapRefresh(),
	!.
  % UnSet "X" to column N 4 on action(area_marker_beg(...)) callback
  ef_tab_Callback(Win,action(Marker)):- 
	ef_db_edit_forms(con_sort,_MainWin,[Win]),
	Marker = area_marker_beg(Row,4),
	Draw = tableedit_GetCellData(Win,Row,4),
	IDT = tableedit_GetCellData(Win,Row,1),
	Draw = s("X"), IdT = l(SortId), 
	tableedit_SetCellData(Win,Row,4,void),
	retract(tr_db_sort(SortId,SortName,Comment,_,Color)),
	assert(tr_db_sort(SortId,SortName,Comment,b_false,Color)),
	mv_MapRefresh(),
	!.
  % Set color to column N 5
  ef_tab_Callback(Win,A):- 
	ef_db_edit_forms(con_sort,_MainWin,[Win]),
	A = action(Marker),
	Marker = area_marker_beg(Row,5),
	Color = dlg_ChooseColor(color_Black),	% Get Color from dlg_ChooseColor 
	tableedit_SetCellData(Win,Row,5,voidc(Color)),
	IDT = tableedit_GetCellData(Win,Row,1),
	IdT = l(SortId),
	retract(tr_db_sort(SortId,SortName,Comment,Draw,_)),
	assert(tr_db_sort(SortId,SortName,Comment,Draw,Color)),
	mv_MapRefresh(),
	!.
  ef_tab_Callback(Win,A):- 
	ef_db_edit_forms(con_sort,_MainWin,[Win]),
	A = action(Marker),
	Marker = area_marker_beg(_Row,5),
	!.
  % forbid grid_edit_cell(_Row,Col) marker in column N 4 and 5
  ef_tab_Callback(Win,Marker):- 
	ef_db_edit_forms(con_sort,_MainWin,[Win]),
	Marker = marker(M,_MarkUnMark), M = grid_edit_cell(_Row,Col),
	Col >= 4,Col <= 5,!.

  ef_tab_Callback(Win,Marker):- 
	ef_db_edit_forms(con_distance,_MainWin,[Win]),
	Marker = marker(M,_MarkUnMark), M = grid_edit_cell(_Row,2),!.
  ef_tab_Callback(Win,Marker):- 
	ef_db_edit_forms(con_production,_MainWin,[Win]),
	Marker = marker(M,_MarkUnMark), M = grid_edit_cell(_Row,2),!.
  ef_tab_Callback(Win,Marker):- 
	ef_db_edit_forms(con_custom,_MainWin,[Win]),
	Marker = marker(M,_MarkUnMark), M = grid_edit_cell(_Row,2),!.
  % forbid area marker in last(footer) row - total row
  ef_tab_Callback(Win,A):- 
	ef_db_edit_forms(con_move,_MainWin,[Win]),
	A = action(Marker),
	Max = tableedit_MaxVisibleRows(Win),
	Marker = area_marker_beg(Max,_),!.
  ef_tab_Callback(Win,A):- 
	ef_db_edit_forms(con_unplaced,_MainWin,[Win]),
	A = action(Marker),
	Max = tableedit_MaxVisibleRows(Win),
	Marker = area_marker_beg(Max,_),!.
  ef_tab_Callback(Win,A):- 
	ef_db_edit_forms(con_needs,_MainWin,[Win]),
	A = action(Marker),
	Max = tableedit_MaxVisibleRows(Win),
	Marker = area_marker_beg(Max,_),!.
	
predicates
procedure  ef_find_FreeId(INTEGER FormId,LONG FreeId)  
procedure  ef_find_FreeId1(INTEGER FormId,LONG,LONG FreeId)  
procedure  ef_voidToString(TABLEEDIT_CELLDATA,STRING)
determ  ef_member_index(LONG,LONGLIST,INTEGER)
procedure  ef_set_2xData(INTEGER IdForm,LONG IdProducer_Customer,LONG IdCustomer_Sort,TABLEEDIT_CELLDATA NewData)
determ  ef_modified_2xForm(INTEGER IdForm,INTEGER Row,INTEGER Col,TABLEEDIT_CELLDATA NewData)
procedure  ef_Clear_Plan
determ  ef_check_plan
clauses
  % fail, if no plan
  ef_check_plan():- move(_,_,_,_),!.
  ef_check_plan():- unplaced(_,_,_),!.
  ef_check_plan():- needed(_,_,_),!.

  % If plan not actual, then close "transportation","unplaced","needs" forms and map refresh
  ef_Clear_Plan():-
	retract(ef_db_edit_forms(con_move,MainWin,_)),
	win_Destroy(MainWin),
	fail.
  ef_Clear_Plan():-
	retract(ef_db_edit_forms(con_unplaced,MainWin,_)),
	win_Destroy(MainWin),
	fail.
  ef_Clear_Plan():-
	retract(ef_db_edit_forms(con_needs,MainWin,_)),
	win_Destroy(MainWin),
	fail.
  ef_Clear_Plan():-
	ef_check_plan,
	retractAll(move(_,_,_,_)),
	retractAll(unplaced(_,_,_)),
	retractAll(needed(_,_,_)),
	retractAll(genStatus(_,_,_,_,_,_,_)),
  	mv_MapRefresh(),
	set_GenStatusToToolbar(),
  	!.
  ef_Clear_Plan():-!.


  ef_reInitForms(Win,IdForm,_Row,_Column):-
	ef_db_edit_forms(IdForm,_MainWin,[Win]),
	IdForm = con_production,
	ef_Clear_Plan(),
	!.
  ef_reInitForms(Win,IdForm,_Row,_Column):-
	ef_db_edit_forms(IdForm,_MainWin,[Win]),
	IdForm = con_custom,
	ef_Clear_Plan(),
	!.
  ef_reInitForms(Win,IdForm,_Row,_Column):-
	ef_db_edit_forms(IdForm,_MainWin,[Win]),
	IdForm = con_distance,
	ef_Clear_Plan(),
	!.
  ef_reInitForms(Win,IdForm,_Row,Column):-
	ef_db_edit_forms(IdForm,_MainWin,[Win]),
	Column = 2, IdForm = con_producer,
	ef_init_forms(con_distance),
	ef_init_forms(con_production),
	ef_Clear_Plan(),
	!.
  ef_reInitForms(Win,IdForm,_Row,Column):-
	ef_db_edit_forms(IdForm,_MainWin,[Win]),
	Column = 2, IdForm = con_customer,
	ef_init_forms(con_distance),
	ef_init_forms(con_custom),
	ef_Clear_Plan(),
	!.
  ef_reInitForms(Win,IdForm,_Row,Column):-
	ef_db_edit_forms(IdForm,_MainWin,[Win]),
	Column = 2, IdForm = con_sort,
	ef_init_forms(con_production),
	ef_init_forms(con_custom),
	ef_Clear_Plan(),
	!.
  ef_reInitForms(_,-1,_,_):-!.

  ef_voidToString(CellData,Str):- CellData = s(Str),!.
  ef_voidToString(CellData,Str):- CellData = sc(Str,_Color),!.
  ef_voidToString(CellData,""):- CellData = void,!.
  ef_voidToString(CellData,""):- CellData = voidc(_),!.
  ef_voidToString(_,""):- errorexit().

  % move table editor custom control in child RCT
  ef_size_forms(Win):-
	ef_db_edit_forms(_,Win,[Win1]),
	RCT = win_GetClientRect(Win),
	win_Move(Win1,RCT),!.
  ef_size_forms(_):-!.

predicates
procedure  ef_conv_DrawToBool(TABLEEDIT_CELLDATA,BOOLEAN)
procedure  ef_conv_TColorToColor(TABLEEDIT_CELLDATA,ULONG)
clauses

  ef_conv_DrawToBool(s("X"),b_true):-!.
  ef_conv_DrawToBool(_,b_false):-!.

  ef_conv_TColorToColor(voidc(C),C):-!.
  ef_conv_TColorToColor(_,0):-!.

  % reassert data base, if row modified
  ef_handle_modifiedRow(Win1,Row,_Col):-
	ef_db_edit_forms(con_producer,_Win,[Win1]),
	Data = tableedit_GetData(Win1,Row,Row,1,3),
	Data = [[l(Id),SName,SComment]],
	ef_voidToString(SName,Name), ef_voidToString(SComment,Comment),
	retract(tr_db_producer(Id,_,_,X,Y)),
	assert(tr_db_producer(Id,Name,Comment,X,Y)),
	!.
  ef_handle_modifiedRow(Win1,Row,_Col):-
	ef_db_edit_forms(con_customer,_Win,[Win1]),
	Data = tableedit_GetData(Win1,Row,Row,1,3),
	Data = [[l(Id),SName,SComment]],
	ef_voidToString(SName,Name), ef_voidToString(SComment,Comment),
	retract(tr_db_customer(Id,_,_,X,Y)),
	assert(tr_db_customer(Id,Name,Comment,X,Y)),
	!.
  ef_handle_modifiedRow(Win1,Row,_Col):-
	ef_db_edit_forms(con_sort,_Win,[Win1]),
	Data = tableedit_GetData(Win1,Row,Row,1,5),
	Data = [[l(Id),SName,SComment,DT,CT]],
	ef_voidToString(SName,Name), ef_voidToString(SComment,Comment),
	ef_conv_DrawToBool(DT,D),
	ef_conv_TColorToColor(CT,C),
	retract(tr_db_sort(Id,_,_,_,_)),
	assert(tr_db_sort(Id,Name,Comment,D,C)),
	!.
  ef_handle_modifiedRow(Win1,Row,Col):-
	ef_db_edit_forms(IdForm,_Win,[Win1]),
	IdForm = con_distance,
	Data = tableedit_GetCellData(Win1,Row,Col),
	ef_modified_2xForm(IdForm,Row,Col,Data),
	!.
  ef_handle_modifiedRow(Win1,Row,Col):-
	ef_db_edit_forms(IdForm,_Win,[Win1]),
	IdForm = con_production,
	Data = tableedit_GetCellData(Win1,Row,Col),
	ef_modified_2xForm(IdForm,Row,Col,Data),
	!.
  ef_handle_modifiedRow(Win1,Row,Col):-
	ef_db_edit_forms(IdForm,_Win,[Win1]),
	IdForm = con_custom,
	Data = tableedit_GetCellData(Win1,Row,Col),
	ef_modified_2xForm(IdForm,Row,Col,Data),
	!.

  ef_modified_2xForm(IdForm,Row,Col,NewData):-
	ef_db_edit_forms(IdForm,_Win,[Win1]),
	IdData = tableedit_GetCellData(Win1,Row,1),
	IdData = l(Id),
	Col1 = Col - 2,
	ef_db_FormMap(IdForm,Id1List),
	ef_member_index(Id1,Id1List,Col1),
	ef_set_2xData(IdForm,Id,Id1,NewData),
	!.

  ef_set_2xData(IdForm,IdP,IdC,r(Data)):-
	IdForm = con_distance,
	retractAll(tr_db_distance(IdP,IdC,_)),
	assert(tr_db_distance(IdP,IdC,Data)),!.
  ef_set_2xData(IdForm,IdP,IdC,void):-
	IdForm = con_distance,
	retractAll(tr_db_distance(IdP,IdC,_)),!.
  ef_set_2xData(IdForm,IdP,IdS,r(Data)):-
	IdForm = con_production,
	retractAll(tr_db_production(IdP,IdS,_)),
	assert(tr_db_production(IdP,IdS,Data)),!.
  ef_set_2xData(IdForm,IdP,IdS,void):-
	IdForm = con_production,
	retractAll(tr_db_production(IdP,IdS,_)),!.
  ef_set_2xData(IdForm,IdC,IdS,r(Data)):-
	IdForm = con_custom,
	retractAll(tr_db_custom(IdC,IdS,_)),
	assert(tr_db_custom(IdC,IdS,Data)),!.
  ef_set_2xData(IdForm,IdC,IdS,void):-
	IdForm = con_custom,
	retractAll(tr_db_custom(IdC,IdS,_)),!.
  ef_set_2xData(_,_,_,_):-errorexit().

  ef_member_index(S,[S|_],1):-!.
  ef_member_index(S,[_|L],M):-
        bound(M),!,
        N = M - 1,
        ef_member_index(S,L,N),!.
  ef_member_index(S,[_|L],M):-
        ef_member_index(S,L,N),!,
        M = N + 1.

  % Set id to "id" column for new producer/customer/sort
  ef_handle_insert(Win1,Row):-
	ef_db_edit_forms(con_producer,_Win,[Win1]),
	ef_find_FreeId(con_producer,FreeId),
	tableedit_SetCellData(Win1,Row,1,l(FreeId)),
	assert(tr_db_producer(FreeId,"","",0,0)),
	!.
  ef_handle_insert(Win1,Row):-
	ef_db_edit_forms(con_customer,_Win,[Win1]),
	ef_find_FreeId(con_customer,FreeId),
	tableedit_SetCellData(Win1,Row,1,l(FreeId)),
	assert(tr_db_customer(FreeId,"","",0,0)),
	!.
  ef_handle_insert(Win1,Row):-
	ef_db_edit_forms(con_sort,_Win,[Win1]),
	ef_find_FreeId(con_sort,FreeId),
	tableedit_SetCellData(Win1,Row,1,l(FreeId)),
	assert(tr_db_sort(FreeId,"","",b_false,0)),
	!.

predicates
procedure ef_check_ProducerInMap(INTEGER Id,BOOLEAN UpdateMap)
procedure ef_check_CustomerInMap(INTEGER Id,BOOLEAN UpdateMap)
clauses

  % if X/Y not equal 0, then producer/customer fix on map
  ef_check_ProducerInMap(Id,b_true):- tr_db_producer(Id,_,_,X,_Y), not(X = 0),!.
  ef_check_ProducerInMap(Id,b_true):- tr_db_producer(Id,_,_,_X,Y), not(Y = 0),!.
  ef_check_ProducerInMap(_,b_false):-!.

  ef_check_CustomerInMap(Id,b_true):- tr_db_customer(Id,_,_,X,_Y), not(X = 0),!.
  ef_check_CustomerInMap(Id,b_true):- tr_db_customer(Id,_,_,_X,Y), not(Y = 0),!.
  ef_check_CustomerInMap(_,b_false):-!.
  
  % producer/customer/sort delete handling
  ef_handle_delete(Win1,_Row,Data):-
	ef_db_edit_forms(con_producer,_Win,[Win1]),
	Data = [l(Id),_,_],
	ef_check_ProducerInMap(Id,Update),
	retractAll(tr_db_producer(Id,_,_,_,_)),
	retractAll(tr_db_production(Id,_,_)),
	retractAll(tr_db_distance(Id,_,_)),
	Update = b_true,
  	mv_MapRefresh(),
	!.
  ef_handle_delete(Win1,_Row,Data):-
	ef_db_edit_forms(con_customer,_Win,[Win1]),
	Data = [l(Id),_,_],
	ef_check_CustomerInMap(Id,Update),
	retractAll(tr_db_customer(Id,_,_,_,_)),
	retractAll(tr_db_custom(Id,_,_)),
	retractAll(tr_db_distance(_,Id,_)),
	Update = b_true,
  	mv_MapRefresh(),
	!.
  ef_handle_delete(Win1,_Row,Data):-
	ef_db_edit_forms(con_sort,_Win,[Win1]),
	Data = [l(Id),_,_,_,_],
	retractAll(tr_db_sort(Id,_,_,_,_)),
	retractAll(tr_db_production(_,Id,_)),
	retractAll(tr_db_custom(_,Id,_)),
	!.
  ef_handle_delete(_,_,_):-!.

  ef_find_FreeId(FormId,FreeId):-ef_find_FreeId1(FormId,0,FreeId),!.
  ef_find_FreeId(_,0):-errorexit().

  ef_find_FreeId1(con_producer,Id,Id):- not(tr_db_producer(Id,_,_,_,_)),!.
  ef_find_FreeId1(con_customer,Id,Id):- not(tr_db_customer(Id,_,_,_,_)),!.
  ef_find_FreeId1(con_sort,Id,Id):- not(tr_db_sort(Id,_,_,_,_)),!.
  ef_find_FreeId1(Con,Id,FreeId):-!,
	NextId = Id + 1,
	ef_find_FreeId1(Con,NextId,FreeId).

  
predicates
procedure  ef_findAllProducer(LONGLIST IdList)
determ  ef_buildProducerList(LONGLIST IdList,TABLEEDIT_DATA,TABLEEDIT_DATA ProducerList)
procedure  ef_findAllCustomer(LONGLIST IdList)
determ  ef_buildCustomerList(LONGLIST IdList,TABLEEDIT_DATA,TABLEEDIT_DATA CustomerList)
procedure  ef_findAllSort(LONGLIST IdList)
determ  ef_buildSortList(LONGLIST IdList,TABLEEDIT_DATA,TABLEEDIT_DATA ProducerList)
clauses
  ef_get_producerList(ProducerList):-
	ef_findAllProducer(IdList),
	ef_buildProducerList(IdList,[],ProducerList),
	!.
  ef_get_producerList([]):-!.

  ef_buildProducerList([],ProducerList,ProducerList):-!.
  ef_buildProducerList([Id|L2],PList,M):-
	tr_db_producer(Id,Name,Comment,_X,_Y),!,
	P1 = [l(Id),s(Name),s(Comment)],
	PList1 = [P1|PList],
	ef_buildProducerList(L2,PList1,M).

  ef_findAllProducer(IdList):-
	findall(Id,tr_db_producer(Id,_Name,_Comment,_X,_Y),IdList),!.

  ef_get_customerList(CustomerList):-
	ef_findAllCustomer(IdList),
	ef_buildCustomerList(IdList,[],CustomerList),
	!.
  ef_get_customerList([]):-!.

  ef_buildCustomerList([],CustomerList,CustomerList):-!.
  ef_buildCustomerList([Id|L2],PList,M):-
	tr_db_customer(Id,Name,Comment,_X,_Y),!,
	P1 = [l(Id),s(Name),s(Comment)],
	PList1 = [P1|PList],
	ef_buildCustomerList(L2,PList1,M).

  ef_findAllCustomer(IdList):-
	findall(Id,tr_db_customer(Id,_Name,_Comment,_X,_Y),IdList),!.

  ef_get_sortList(SortList):-
	ef_findAllSort(IdList),
	ef_buildSortList(IdList,[],SortList),
	!.
  ef_get_sortList([]):-!.

predicates
procedure  ef_conv_DrawToTDraw(BOOLEAN,TABLEEDIT_CELLDATA)
procedure  ef_conv_ColorToTColor(ULONG,TABLEEDIT_CELLDATA)
clauses

  ef_conv_DrawToTDraw(b_true,s("X")):-!.
  ef_conv_DrawToTDraw(_,void):-!.

  ef_conv_ColorToTColor(C,voidc(C)):-!.

  ef_buildSortList([],SortList,SortList):-!.
  ef_buildSortList([Id|L2],PList,M):-
	tr_db_sort(Id,Name,Comment,D,C),!,
	ef_conv_DrawToTDraw(D,DT),
	ef_conv_ColorToTColor(C,DC),
	P1 = [l(Id),s(Name),s(Comment),DT,DC],
	PList1 = [P1|PList],
	ef_buildSortList(L2,PList1,M).

  ef_findAllSort(IdList):-
	findall(Id,tr_db_sort(Id,_Name,_Comment,_,_),IdList),!.

predicates
procedure  ef_reverse(TABLEEDIT_DATA,TABLEEDIT_DATA,TABLEEDIT_DATA)
procedure  ef_reverse(TABLEEDIT_COLUMNDATA,TABLEEDIT_COLUMNDATA,TABLEEDIT_COLUMNDATA)
procedure  ef_reverse(TABLEEDIT_COLUMNLIST,TABLEEDIT_COLUMNLIST,TABLEEDIT_COLUMNLIST)
procedure  ef_reverse(REALLIST,REALLIST,REALLIST)
determ  ef_buildRowList(INTEGER Distance_Production_Custom,LONGLIST IdProducerList,LONGLIST IdCustomerList,TABLEEDIT_DATA,TABLEEDIT_DATA)
determ  ef_buildRowList1(INTEGER Distance_Production_Custom,LONGLIST IdCustomerList,LONG IdProducer,TABLEEDIT_COLUMNDATA,TABLEEDIT_COLUMNDATA)
procedure  ef_get_CellData(INTEGER Distance_Production_Custom,LONG IdProducer,LONG IdCustomer,TABLEEDIT_CELLDATA)
determ  ef_buildTitleList(INTEGER Distance_Production_Custom,LONGLIST IdCustomerList,TABLEEDIT_COLUMNLIST TitleList,TABLEEDIT_COLUMNLIST TitleList)

clauses

  ef_reverse([],IdList,IdList):-!.
  ef_reverse([Id|Rest],IL,IdList):-!,
	ef_reverse(Rest,[Id|IL],IdList).
  ef_reverse(_,_,[]):-errorexit().

  ef_get_2xList(IdCon,RowList,TitleList):-
	IdCon = con_distance,
	ef_findAllProducer(IdProducerList),
	ef_findAllCustomer(IdCustomerList),
	assert(ef_db_FormMap(IdCon,IdCustomerList)),
	ef_buildTitleList(IdCon,IdCustomerList,[],TitleList),
	ef_buildRowList(IdCon,IdProducerList,IdCustomerList,[],RowList),
	!.
  ef_get_2xList(IdCon,RowList,TitleList):-
	IdCon = con_production,
	ef_findAllProducer(IdProducerList),
	ef_findAllSort(IdSortList),
	assert(ef_db_FormMap(IdCon,IdSortList)),
	ef_buildTitleList(IdCon,IdSortList,[],TitleList),
	ef_buildRowList(IdCon,IdProducerList,IdSortList,[],RowList),
	!.
  ef_get_2xList(IdCon,RowList,TitleList):-
	IdCon = con_custom,
	ef_findAllCustomer(IdCustomerList),
	ef_findAllSort(IdSortList),
	assert(ef_db_FormMap(IdCon,IdSortList)),
	ef_buildTitleList(IdCon,IdSortList,[],TitleList),
	ef_buildRowList(IdCon,IdCustomerList,IdSortList,[],RowList),
	!.
  ef_get_2xList(_,[],[]):-errorexit().


  ef_buildRowList(_IdCon,[],_IdCustomerList,RowList1,RowList):-
	ef_reverse(RowList1,[],RowList),!.
  ef_buildRowList(IdCon,[IdP|L2],IdCustomerList,RList,M):-!,
	ef_buildRowList1(IdCon,IdCustomerList,IdP,[],R1),
	RList1 = [R1|RList],
	ef_buildRowList(IdCon,L2,IdCustomerList,RList1,M).

  ef_buildRowList1(IdCon,[],IdP,CellList1,CellList4):-
	IdCon = con_distance,
	ef_reverse(CellList1,[],CellList2),
	tr_db_producer(IdP,Name,_Comment,_X,_Y),
	CellList3 = [s(Name)|CellList2],
	CellList4 = [l(IdP)|CellList3],
	!.
  ef_buildRowList1(IdCon,[],IdP,CellList1,CellList4):-
	IdCon = con_production,
	ef_reverse(CellList1,[],CellList2),
	tr_db_producer(IdP,Name,_Comment,_X,_Y),
	CellList3 = [s(Name)|CellList2],
	CellList4 = [l(IdP)|CellList3],
	!.
  ef_buildRowList1(IdCon,[],IdC,CellList1,CellList4):-
	IdCon = con_custom,
	ef_reverse(CellList1,[],CellList2),
	tr_db_customer(IdC,Name,_Comment,_X,_Y),
	CellList3 = [s(Name)|CellList2],
	CellList4 = [l(IdC)|CellList3],
	!.
  ef_buildRowList1(IdCon,[IdC|L2],IdP,CList,M):-
	ef_get_CellData(IdCon,IdP,IdC,CellData),
	CList1 = [CellData|CList],
	ef_buildRowList1(IdCon,L2,IdP,CList1,M).

  ef_get_CellData(IdCon,IdP,IdC,CellData):-
	IdCon = con_distance,
	tr_db_distance(IdP,IdC,Distance),
	CellData = r(Distance),!.
  ef_get_CellData(IdCon,IdP,IdSort,CellData):-
	IdCon = con_production,
	tr_db_production(IdP,IdSort,Number),
	CellData = r(Number),!.
  ef_get_CellData(IdCon,IdC,IdSort,CellData):-
	IdCon = con_custom,
	tr_db_custom(IdC,IdSort,Number),
	CellData = r(Number),!.
  ef_get_CellData(_,_IdP,_IdC,void):-!.
	
  ef_buildTitleList(IdCon,[],TitleList1,TitleList4):-
	IdCon = con_distance,
	ef_reverse(TitleList1,[],TitleList2),
	TitleList3 = [column([title("Manufacturer\\Customer"),backcolor(32896),width(150)])| TitleList2],
	TitleList4 = [column([title("Id"),width(0),resizable(b_false),column_type(te_long)])| TitleList3],
	!.
  ef_buildTitleList(IdCon,[Id|L2],TList,M):-
	IdCon = con_distance,
	tr_db_customer(Id,Name,_Comment,_X,_Y),!,
	T1 = column([title(Name),width(100),column_type(te_real)]),
	TList1 = [T1|TList],
	ef_buildTitleList(IdCon,L2,TList1,M).
  ef_buildTitleList(IdCon,[],TitleList1,TitleList4):-
	IdCon = con_production,
	ef_reverse(TitleList1,[],TitleList2),
	TitleList3 = [column([title("Manufacturer"),backcolor(32896),width(150)])| TitleList2],
	TitleList4 = [column([title("Id"),width(0),resizable(b_false),column_type(te_long)])| TitleList3],
	!.
  ef_buildTitleList(IdCon,[Id|L2],TList,M):-
	IdCon = con_production,
	tr_db_sort(Id,Name,_Comment,_,_),!,
	T1 = column([title(Name),width(100),column_type(te_real)]),
	TList1 = [T1|TList],
	ef_buildTitleList(IdCon,L2,TList1,M).
  ef_buildTitleList(IdCon,[],TitleList1,TitleList4):-
	IdCon = con_custom,
	ef_reverse(TitleList1,[],TitleList2),
	TitleList3 = [column([title("Customer"),backcolor(8421376),width(150)])| TitleList2],
	TitleList4 = [column([title("Id"),width(0),resizable(b_false),column_type(te_long)])| TitleList3],
	!.
  ef_buildTitleList(IdCon,[Id|L2],TList,M):-
	IdCon = con_custom,
	tr_db_sort(Id,Name,_Comment,_,_),!,
	T1 = column([title(Name),width(100),column_type(te_real)]),
	TList1 = [T1|TList],
	ef_buildTitleList(IdCon,L2,TList1,M).

  ef_forms_Update:-
	ef_init_forms(con_producer),
	ef_init_forms(con_customer),
	ef_init_forms(con_sort),
	ef_init_forms(con_production),
	ef_init_forms(con_custom),
	ef_init_forms(con_distance),
	ef_init_forms(con_move),
	ef_init_forms(con_unplaced),
	ef_init_forms(con_needs),
	!.

  ef_outforms_Update:-
	ef_init_forms(con_move),
	ef_init_forms(con_unplaced),
	ef_init_forms(con_needs),
	!.

predicates
nondeterm  ef_buildMoveList(TABLEEDIT_COLUMNDATA)
procedure  ef_calc_MoveTotal(TABLEEDIT_DATA,REAL,REAL TotalQuantity,REAL,REAL TCost)
clauses
% Create list with total for "Transportation" form
  ef_get_MoveList(MoveList):-
	findAll(Move1,ef_buildMoveList(Move1),MoveList1),
	ef_calc_MoveTotal(MoveList1,0,TQ,0,TC),
	TotalMove = [void,void,sc("",33023),sc("",33023),sc("",33023),rc(TQ,33023),rc(TC,33023)],
	MoveList2 = [TotalMove | MoveList1],
	ef_reverse(MoveList2,[],MoveList),
	!.
  ef_get_MoveList([]):-!.

% Total quantity and total cost calculation
  ef_calc_MoveTotal([],TQ,TQ,TC,TC):-!.
  ef_calc_MoveTotal([L1|L2],TQ1,TQ,TC1,TC):-
	L1 = [_,_,_,_,_,r(Q),r(TotalCost)],!,
	TQ2 = TQ1 + Q,
	TC2 = TC1 + TotalCost,
	ef_calc_MoveTotal(L2,TQ2,TQ,TC2,TC).
  ef_calc_MoveTotal(_,_,0,_,0):-errorexit().

% Create row for "Transportation" form
  ef_buildMoveList(M):-
	move(SortId,ProducerId,CustomerId,Q),
	tr_db_producer(ProducerId,PName,_,_,_),
	tr_db_customer(CustomerId,CName,_,_,_),
	tr_db_sort(SortId,SName,_,_,_),
	tr_db_distance(ProducerId,CustomerId,CostOf1unit),
	TotalCost = Q*CostOf1unit,
	M = [l(ProducerId),l(CustomerId),s(PName),s(CName),s(SName),r(Q),r(TotalCost)].
predicates
determ  ef_clear_TotalRow(WINDOW)
procedure  ef_create_VoidTotal(INTEGER,INTEGER MaxCol,TABLEEDIT_COLUMNDATA,TABLEEDIT_COLUMNDATA OutRow)

clauses

% If number of visible rows = 0 then set to total "void row"
  ef_clear_TotalRow(Win):-
	1 = tableedit_MaxVisibleRows(Win),
	MaxCol = tableedit_MaxCol(Win),
	ef_create_VoidTotal(0,MaxCol,[],OutRow),
	tableedit_SetData(Win,1,1,1,MaxCol,[OutRow]),
	!.

% Create "void row": [voidc(33023),voidc(33023),....]
  ef_create_VoidTotal(Col,MaxCol,OutRow,OutRow):- Col >= MaxCol,!.
  ef_create_VoidTotal(Col1,MaxCol,OutRow1,OutRow):-!,
	Col2 = Col1 + 1,
	ef_create_VoidTotal(Col2,MaxCol,[voidc(33023)|OutRow1],OutRow).
  ef_create_VoidTotal(_,_,_,[]):-errorexit().

% ---------------
% filter handling
% ---------------
  % If number of visible rows = 0 then set in total "void row" - [voidc(..),voidc(..),...]
  ef_handle_filter(Win1):-
	ef_db_edit_forms(con_move,_Win,[Win1]),
	ef_clear_TotalRow(Win1),!.
  ef_handle_filter(Win1):-
	ef_db_edit_forms(con_unplaced,_Win,[Win1]),
	ef_clear_TotalRow(Win1),!.
  ef_handle_filter(Win1):-
	ef_db_edit_forms(con_needs,_Win,[Win1]),
	ef_clear_TotalRow(Win1),!.

  % total row calculation and set to footer(total row) for new filter
  ef_handle_filter(Win1):-
	ef_db_edit_forms(con_move,_Win,[Win1]),
	Rows = tableedit_MaxVisibleRows(Win1),
	Rows1 =	Rows - 1,
	MoveList1 = tableedit_GetData(Win1,1,Rows1,1,7),
	ef_calc_MoveTotal(MoveList1,0,TQ,0,TC),
	TotalMove = [[void,void,sc("",33023),sc("",33023),sc("",33023),rc(TQ,33023),rc(TC,33023)]],
	tableedit_SetData(Win1,Rows,Rows,1,7,TotalMove),
	!.
  ef_handle_filter(Win1):-
	ef_db_edit_forms(con_unplaced,_Win,[Win1]),
	Rows = tableedit_MaxVisibleRows(Win1),
	Col = tableedit_MaxCol(Win1),
	Rows1 =	Rows - 1,
	UnplacedList1 = tableedit_GetData(Win1,1,Rows1,3,Col),
	ef_calc_UnplacedTotal(UnplacedList1,[],TotalRow),
	tableedit_SetData(Win1,Rows,Rows,3,Col,[TotalRow]),
	!.
  ef_handle_filter(Win1):-
	ef_db_edit_forms(con_needs,_Win,[Win1]),
	Rows = tableedit_MaxVisibleRows(Win1),
	Col = tableedit_MaxCol(Win1),
	Rows1 =	Rows - 1,
	NeedsList1 = tableedit_GetData(Win1,1,Rows1,3,Col),
	ef_calc_UnplacedTotal(NeedsList1,[],TotalRow),
	tableedit_SetData(Win1,Rows,Rows,3,Col,[TotalRow]),
	!.
  ef_handle_filter(_):-!.

predicates
procedure  ef_findAll_UnplacedNeedsSort(INTEGER FormID,LONGLIST SortIdList,LONGLIST,LONGLIST UnplacedSortIdList)
procedure  ef_findAll_UnplacedNeeds(INTEGER FormID,LONGLIST ProducerIdList,LONGLIST,LONGLIST UnplacedProducerIdList)
procedure  ef_buildUnplacedNeedsTitleList(INTEGER FormID,LONGLIST ProducerIdList,TABLEEDIT_COLUMNLIST,TABLEEDIT_COLUMNLIST Titles)
procedure  ef_buildUnplacedNeddsList(INTEGER FormID,LONGLIST SortIdList,LONGLIST ProducerIdList,TABLEEDIT_DATA,TABLEEDIT_DATA RowList,REALLIST,REALLIST)
procedure  ef_buildUnplacedNeedsList1(INTEGER FormID,LONGLIST SortIdList,LONG ProducerId,TABLEEDIT_COLUMNDATA,TABLEEDIT_COLUMNDATA,REAL,REAL RowTotal,REALLIST,REALLIST TotalList)
procedure  ef_sum_ColumnTotalQ(REALLIST,REALLIST,REALLIST,REALLIST)
procedure  ef_build_TotalRow(REALLIST,TABLEEDIT_COLUMNDATA,TABLEEDIT_COLUMNDATA TotalRow)
procedure  ef_calc_UnplacedTotal1(TABLEEDIT_COLUMNDATA,TABLEEDIT_COLUMNDATA,TABLEEDIT_COLUMNDATA,TABLEEDIT_COLUMNDATA)
procedure  ef_voidRealSum(TABLEEDIT_CELLDATA,TABLEEDIT_CELLDATA,TABLEEDIT_CELLDATA)

clauses
% Create "Title" and "Row" list for "Unplaced" and "Backlog" forms
  ef_get_UnplacedNeedsList(FormId,TitleList,RowList):-
	FormId = con_unplaced,
	findAll(SortId,tr_db_sort(SortId,_,_,_,_),SortIdList),
	findAll(ProducerId,tr_db_producer(ProducerId,_,_,_,_),ProducerIdList),
	ef_findAll_UnplacedNeedsSort(FormId,SortIdList,[],UnplacedSortIdList),
	ef_findAll_UnplacedNeeds(FormId,ProducerIdList,[],UnplacedProducerIdList),
	ef_buildUnplacedNeedsTitleList(FormId,UnplacedSortIdList,[],TitleList),
	ef_buildUnplacedNeddsList(FormId,UnplacedSortIdList,UnplacedProducerIdList,[],RowList,[],_),
	!.
  ef_get_UnplacedNeedsList(FormId,TitleList,RowList):-
	FormId = con_needs,
	findAll(SortId,tr_db_sort(SortId,_,_,_,_),SortIdList),
	findAll(CustomerId,tr_db_customer(CustomerId,_,_,_,_),CustomerIdList),
	ef_findAll_UnplacedNeedsSort(FormId,SortIdList,[],UnplacedSortIdList),
	ef_findAll_UnplacedNeeds(FormId,CustomerIdList,[],UnplacedCustomerIdList),
	ef_buildUnplacedNeedsTitleList(FormId,UnplacedSortIdList,[],TitleList),
	ef_buildUnplacedNeddsList(FormId,UnplacedSortIdList,UnplacedCustomerIdList,[],RowList,[],_),
	!.
  ef_get_UnplacedNeedsList(_,[],[]):-!.

% "Total row" calculation for "Unplaced" and "Backlog" forms
  ef_calc_UnplacedTotal([],TotalRow,TotalRow):-!.
  ef_calc_UnplacedTotal([L1|L2],M1,M):-
	ef_calc_UnplacedTotal1(L1,M1,[],M2),!,
	ef_calc_UnplacedTotal(L2,M2,M).
  ef_calc_UnplacedTotal(_,_,[]):-errorexit().

  ef_calc_UnplacedTotal1([],_,T1,T2):-
	ef_reverse(T1,[],T2),
	!.
  ef_calc_UnplacedTotal1([L1|L2],[LT1|LT2],LS1,T):-
	ef_voidRealSum(L1,LT1,LS2),!,
	ef_calc_UnplacedTotal1(L2,LT2,[LS2|LS1],T).
  ef_calc_UnplacedTotal1([L1|L2],LT2,LS1,T):-
	ef_voidRealSum(L1,r(0),LS2),!,
	ef_calc_UnplacedTotal1(L2,LT2,[LS2|LS1],T).
  ef_calc_UnplacedTotal1(_,_,_,[]):-errorexit().

  ef_voidRealSum(r(Q1),r(Q2),rc(Q,33023)):- Q = Q1 + Q2,!.
  ef_voidRealSum(rc(Q1,_),rc(Q2,_),rc(Q,33023)):- Q = Q1 + Q2,!.
  ef_voidRealSum(rc(Q1,_),r(Q2),rc(Q,33023)):- Q = Q1 + Q2,!.
  ef_voidRealSum(r(Q1),rc(Q2,_),rc(Q,33023)):- Q = Q1 + Q2,!.
  ef_voidRealSum(void,r(Q),rc(Q,33023)):-!.
  ef_voidRealSum(voidc(_),rc(Q,_),rc(Q,33023)):-!.
  ef_voidRealSum(void,rc(Q,_),rc(Q,33023)):-!.
  ef_voidRealSum(_,_,rc(0,33023)):-errorexit().

% Create "Title" list for "Unplaced" and "Backlog" forms
  ef_buildUnplacedNeedsTitleList(con_unplaced,[],TitleList1,TitleList5):-
	TitleList2 = [column([title("Total"),width(100),column_type(te_real)]) | TitleList1],
	ef_reverse(TitleList2,[],TitleList3),
	TitleList4 = [column([title("Unplaced"),width(100),backcolor(32896)]) | TitleList3],
	TitleList5 = [column([title("Id"),width(0),resizable(b_false),column_type(te_long)]) | TitleList4],
	!.
  ef_buildUnplacedNeedsTitleList(con_needs,[],TitleList1,TitleList5):-
	TitleList2 = [column([title("Total"),width(100),column_type(te_real)]) | TitleList1],
	ef_reverse(TitleList2,[],TitleList3),
	TitleList4 = [column([title("Backlog"),width(100),backcolor(8421376)]) | TitleList3],
	TitleList5 = [column([title("Id"),width(0),resizable(b_false),column_type(te_long)]) | TitleList4],
	!.
  ef_buildUnplacedNeedsTitleList(FormId,[UnplacedSortId|L2],TL1,TL):-
	tr_db_sort(UnplacedSortId,Name,_,_,_),!,
	T1 = column([title(Name),width(100),column_type(te_real)]),
	ef_buildUnplacedNeedsTitleList(FormId,L2,[T1|TL1],TL).
  ef_buildUnplacedNeedsTitleList(_,_,_,[]):-errorexit().
  
  ef_findAll_UnplacedNeedsSort(_,[],M,M):-!.
  ef_findAll_UnplacedNeedsSort(con_unplaced,[SortId|L2],M1,M):-
	unplaced(SortId,_,_),!,
	M2 = [SortId|M1],
	ef_findAll_UnplacedNeedsSort(con_unplaced,L2,M2,M).
  ef_findAll_UnplacedNeedsSort(con_needs,[SortId|L2],M1,M):-
	needed(SortId,_,_),!,
	M2 = [SortId|M1],
	ef_findAll_UnplacedNeedsSort(con_needs,L2,M2,M).
  ef_findAll_UnplacedNeedsSort(FormId,[_|L2],M1,M):-!,
	ef_findAll_UnplacedNeedsSort(FormId,L2,M1,M).
  ef_findAll_UnplacedNeedsSort(_,_,_,[]):-errorexit().

  ef_findAll_UnplacedNeeds(_,[],M,M):-!.
  ef_findAll_UnplacedNeeds(con_unplaced,[ProducerId|L2],M1,M):-
	unplaced(_,ProducerId,_),!,
	M2 = [ProducerId|M1],
	ef_findAll_UnplacedNeeds(con_unplaced,L2,M2,M).
  ef_findAll_UnplacedNeeds(con_needs,[CustomerId|L2],M1,M):-
	needed(_,CustomerId,_),!,
	M2 = [CustomerId|M1],
	ef_findAll_UnplacedNeeds(con_needs,L2,M2,M).
  ef_findAll_UnplacedNeeds(FormId,[_|L2],M1,M):-!,
	ef_findAll_UnplacedNeeds(FormId,L2,M1,M).
  ef_findAll_UnplacedNeeds(_,_,_,[]):-errorexit().

% Create "Row" list with "Total row" for "Unplaced" and "Backlog" forms
  ef_buildUnplacedNeddsList(_,_,[],RowList1,RowList3,CostList,CostList):-
	ef_build_TotalRow(CostList,[],TotalRow),
	RowList2 = [TotalRow|RowList1],
	ef_reverse(RowList2,[],RowList3),
	!.
  ef_buildUnplacedNeddsList(FormId,SortIdList,[ProducerId|L2],M1,M,TotalList1,TL):-!,
	ef_buildUnplacedNeedsList1(FormId,SortIdList,ProducerId,[],OutRow,0,_,[],TotalList),
	M2 = [OutRow | M1],
	ef_sum_ColumnTotalQ(TotalList,TotalList1,[],OutCostList),
	ef_buildUnplacedNeddsList(FormId,SortIdList,L2,M2,M,OutCostList,TL).
  ef_buildUnplacedNeddsList(_,_,_,_,[],_,[]):-errorexit().

  ef_buildUnplacedNeedsList1(con_unplaced,[],ProducerId,M1,M5,TQ,TQ,TotalList1,TotalList3):-
	tr_db_producer(ProducerId,Name,_,_,_),
	M2 = [rc(TQ,33023)|M1],
	TotalList2 = [TQ | TotalList1],
	ef_reverse(TotalList2,[],TotalList3),
	ef_reverse(M2,[],M3),
	M4 = [s(Name)|M3],
	M5 = [l(ProducerId)|M4],
	!.
  ef_buildUnplacedNeedsList1(con_unplaced,[SortId|L2],ProducerId,M1,M,QT1,TQ,TL1,TL):-
	unplaced(SortId,ProducerId,Q),!,
	M2 = [r(Q)|M1], QT2 = QT1 + Q, TL2 = [Q|TL1],
	ef_buildUnplacedNeedsList1(con_unplaced,L2,ProducerId,M2,M,QT2,TQ,TL2,TL).
  ef_buildUnplacedNeedsList1(con_needs,[],CustomerId,M1,M5,TQ,TQ,TotalList1,TotalList3):-
	tr_db_customer(CustomerId,Name,_,_,_),
	M2 = [rc(TQ,33023)|M1],
	TotalList2 = [TQ | TotalList1],
	ef_reverse(TotalList2,[],TotalList3),
	ef_reverse(M2,[],M3),
	M4 = [s(Name)|M3],
	M5 = [l(CustomerId)|M4],
	!.
  ef_buildUnplacedNeedsList1(con_needs,[SortId|L2],CustomerId,M1,M,QT1,TQ,TL1,TL):-
	needed(SortId,CustomerId,Q),!,
	M2 = [r(Q)|M1], QT2 = QT1 + Q, TL2 = [Q|TL1],
	ef_buildUnplacedNeedsList1(con_needs,L2,CustomerId,M2,M,QT2,TQ,TL2,TL).
  ef_buildUnplacedNeedsList1(FormId,[_SortId|L2],ProducerId,M1,M,QT1,TQ,TL1,TL):-!,
	M2 = [void|M1], TL2 = [0|TL1],
	ef_buildUnplacedNeedsList1(FormId,L2,ProducerId,M2,M,QT1,TQ,TL2,TL).
  ef_buildUnplacedNeedsList1(_,_,_,_,[],_,0,_,[]):-errorexit().

  ef_sum_ColumnTotalQ([],_,OutQList1,OutQList2):-
	ef_reverse(OutQList1,[],OutQList2),
	!.
  ef_sum_ColumnTotalQ([Q|L2],[TotalQ|L22],QL,OutQList):-!,
	Q2 = Q + TotalQ,
	ef_sum_ColumnTotalQ(L2,L22,[Q2|QL],OutQList).
  ef_sum_ColumnTotalQ([Q|L2],L22,QL,OutQList):-!,
	ef_sum_ColumnTotalQ(L2,L22,[Q|QL],OutQList).
  ef_sum_ColumnTotalQ(_,_,_,[]):-errorexit().

  ef_build_TotalRow([],TotalRow1,TotalRow4):-
	ef_reverse(TotalRow1,[],TotalRow2),
	TotalRow3 = [voidc(33023)|TotalRow2],
	TotalRow4 = [voidc(33023)|TotalRow3],
	!.
  ef_build_TotalRow([Total|L2],R1,R):-!,
	R2 = [rc(Total,33023)|R1],
	ef_build_TotalRow(L2,R2,R).
  ef_build_TotalRow(_,_,[]):-errorexit().
 
