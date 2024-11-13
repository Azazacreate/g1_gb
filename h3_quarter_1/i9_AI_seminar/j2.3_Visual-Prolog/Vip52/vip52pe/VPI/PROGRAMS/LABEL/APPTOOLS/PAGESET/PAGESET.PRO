/******************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:	Label Expert
 FileName:	PAGESET.PRO
 Purpose:	Page setup
 Written by:	Sergey Alexeev
 Build:		008.981112
 Comments:
******************************************************************************/
domains
  MY_REAL_LIST = REAL*
constants
  page_rect		= 1
  page_roundrect	= 2
  page_ellipse		= 3
database - page_set_db
  lf(STRING Number,INTEGER FormPage,COLOR ColorPage,STRING Comment,
	REAL LeftMarg,REAL TopMarg,REAL HorSpace,REAL VertSpace,
	REAL LabelWidth,REAL LabelHeight,UNSIGNED NoHor,UNSIGNED NoVert,
	BOOLEAN Page_Roll,BOOLEAN Landscape,BOOLEAN Default)
database - ps_db
  determ ps_font(FONT)
  determ ps_numb(UNSIGNED)
  determ ps_sort(INTEGER)
  ps_row(UNSIGNED Row,STRING Number)
  ps_row1(STRING,STRING Number)
  ps_row2(REAL,STRING Number)
  ps_setup_create
  ps_setup_create_ok
  lf_setup(STRING Number,INTEGER FormPage,COLOR ColorPage,STRING Comment,
	REAL LeftMarg,REAL TopMarg,REAL HorSpace,REAL VertSpace,
	REAL LabelWidth,REAL LabelHeight,UNSIGNED NoHor,UNSIGNED NoVert,
	BOOLEAN Page_Roll,BOOLEAN Landscape)
  ps_end_fail
  determ ps_dialog_already_started
  determ lf_start_number(STRING StartNumber)
predicates
  ps_get_row(INTEGER Num)
clauses
  ps_get_row(Num):-
	retract(ps_numb(N)),
	Num = N + 1,
	assert(ps_numb(Num)),!.
  ps_get_row(1):-
	assert(ps_numb(1)),!.

predicates
  ps_sort_reverse(SLIST,SLIST,SLIST)
  ps_sort_reverse(MY_REAL_LIST,MY_REAL_LIST,MY_REAL_LIST)
clauses
  ps_sort_reverse([],IdList,IdList):-!.
  ps_sort_reverse([Id|Rest],IL,IdList):-!,
     ps_sort_reverse(Rest,[Id|IL],IdList).

predicates
  ps_sort_str(SLIST,SLIST,SLIST)
  ps_sort_str1(STRING,SLIST,SLIST,SLIST)
  ps_sort_str2(SLIST,SLIST,SLIST,SLIST)
  ps_sort_str0(MY_REAL_LIST,MY_REAL_LIST,MY_REAL_LIST)
  ps_sort_str01(REAL,MY_REAL_LIST,MY_REAL_LIST,MY_REAL_LIST)
  ps_sort_str02(MY_REAL_LIST,MY_REAL_LIST,MY_REAL_LIST,MY_REAL_LIST)
clauses
  ps_sort_str([],List,List):-!.
  ps_sort_str([String|Rest],StrList,List):-
	ps_sort_str1(String,StrList,[],StrList1),!,
	ps_sort_str(Rest,StrList1,List).

  ps_sort_str1(String,[],List,StrList):-
	ps_sort_reverse([String|List],[],StrList),!.
  ps_sort_str1(String,[Str|Rest],StrList,List):-
	Str > String,
	ps_sort_reverse([String|StrList],[],StrList1),
	ps_sort_str2(StrList1,[Str|Rest],[],List),!.
  ps_sort_str1(String,[Str|Rest],StrList,List):-!,
	ps_sort_str1(String,Rest,[Str|StrList],List).

  ps_sort_str2([],[],StrList,List):-
	ps_sort_reverse(StrList,[],List),!.
  ps_sort_str2([],[Str|Rest],StrList,List):-!,
	ps_sort_str2([],Rest,[Str|StrList],List).
  ps_sort_str2([Str|Rest],StrList2,StrList,List):-!,
	ps_sort_str2(Rest,StrList2,[Str|StrList],List).

  ps_sort_str0([],List,List):-!.
  ps_sort_str0([String|Rest],StrList,List):-
	ps_sort_str01(String,StrList,[],StrList1),!,
	ps_sort_str0(Rest,StrList1,List).

  ps_sort_str01(String,[],List,StrList):-
	ps_sort_reverse([String|List],[],StrList),!.
  ps_sort_str01(String,[Str|Rest],StrList,List):-
	Str > String,
	ps_sort_reverse([String|StrList],[],StrList1),
	ps_sort_str02(StrList1,[Str|Rest],[],List),!.
  ps_sort_str01(String,[Str|Rest],StrList,List):-!,
	ps_sort_str01(String,Rest,[Str|StrList],List).

  ps_sort_str02([],[],StrList,List):-
	ps_sort_reverse(StrList,[],List),!.
  ps_sort_str02([],[Str|Rest],StrList,List):-!,
	ps_sort_str02([],Rest,[Str|StrList],List).
  ps_sort_str02([Str|Rest],StrList2,StrList,List):-!,
	ps_sort_str02(Rest,StrList2,[Str|StrList],List).

predicates
  ps_get_str(INTEGER Num)
clauses
  ps_get_str(_):-
	retractall(ps_row1(_,_)),
	retractall(ps_row2(_,_)),
	fail.
  ps_get_str(1):-
	lf(Number,_,_,_,_,_,_,_,_,_,_,_,_,_,_),
	assert(ps_row1(Number,Number)),
	fail.
  ps_get_str(2):-
	lf(Number,_,_,_,_,_,_,_,Width,Height,_,_,_,_,_),
	Square = Width * Height,
	assert(ps_row2(Square,Number)),
	fail.
  ps_get_str(3):-
	lf(Number,_,_,Comment,_,_,_,_,_,_,_,_,_,_,_),
	format(String,"%s %s",Comment,Number),
	assert(ps_row1(String,Number)),
	fail.
  ps_get_str(4):-
	lf(Number,_,_,_,_,_,_,_,_,_,_,_,Page_Roll,_,_),
	format(String,"% %s",Page_Roll,Number),
	assert(ps_row1(String,Number)),
	fail.
  ps_get_str(_).

predicates
  ps_sort_row(INTEGER)
  ps_sort_row1(SLIST,INTEGER)
  ps_sort_row2(MY_REAL_LIST,INTEGER)
clauses
  ps_sort_row(_):-
	retractall(ps_row(_,_)),
	retractall(ps_numb(_)),
	fail.
  ps_sort_row(_):-
	lf(Number,_,_,_,_,_,_,_,_,_,_,_,_,_,_),
	ps_get_row(Row),
	assert(ps_row(Row,Number)),
	fail.
  ps_sort_row(2):-
	ps_get_str(2),
	findall(Str,ps_row2(Str,_),StrList),
	ps_sort_str0(StrList,[],StrList1),
	ps_sort_row2(StrList1,1),!.
  ps_sort_row(Num):-
	ps_get_str(Num),
	findall(Str,ps_row1(Str,_),StrList),
	ps_sort_str(StrList,[],StrList1),
	ps_sort_row1(StrList1,1),!.

  ps_sort_row1([],_):-!.
  ps_sort_row1([String|Rest],N):-
	retract(ps_row1(String,Number)),
	retract(ps_row(_,Number)),
	assert(ps_row(N,Number)),
	N1 = N + 1,!,
	ps_sort_row1(Rest,N1).

  ps_sort_row2([],_):-!.
  ps_sort_row2([String|Rest],N):-
	retract(ps_row2(String,Number)),
	retract(ps_row(_,Number)),
	assert(ps_row(N,Number)),
	N1 = N + 1,!,
	ps_sort_row2(Rest,N1).
predicates
  ps_load_page_data()
clauses
  ps_load_page_data():-
	ps_sort(_),!.
  ps_load_page_data():-
	syspath(Path,_),
	format(FileName,"%sLABEL.DBA",Path),
	retractall(lf(_,_,_,_,_,_,_,_,_,_,_,_,_,_,_)),
	format(ErrStr,label_msg105,"LABEL.DBA"),
	trap(consult(FileName,page_set_db),_,dlg_note(ErrStr)),
	assert(ps_sort(1)),
	ps_sort_row(1),!.

predicates
  ps_grid_handler : EHANDLER
  ps_grid_callback : GRID_CALLBACK
  ps_grid_callback1 : GRID_CALLBACK
clauses
  ps_grid_handler(GridWin,e_Create(_),0):-
	retract(ps_setup_create),
	ps_font(Font),
	grid_Init(GridWin,grid_style(grid_raised,color_gray,color_gray,0xC0DCC0,color_LtGray,color_Blue),
		grid_rowstyle(0,7,1,grid_nothing,b_false),
		grid_columnstyle(0,[grid_col(label_msg106,113,grid_left_align,grid_center,5,0,100),
				grid_col(label_msg107,144,grid_left_align,grid_center,5,0,100),
				grid_col(label_msg106,113,grid_left_align,grid_center,5,0,100),
				grid_col(label_msg107,144,grid_left_align,grid_center,5,0,100)
				]),ps_grid_callback1),
	win_SetFont(GridWin,Font),!.

  ps_grid_handler(GridWin,e_Create(_),0):-
	ps_font(Font),
	ps_numb(Num),
	grid_Init(GridWin,grid_style(grid_raised,color_gray,color_gray,0xC0DCC0,color_LtGray,color_Blue),
		grid_rowstyle(35,Num,1,grid_number,b_false),
		grid_columnstyle(0,[grid_col(label_msg108,100,grid_left_align,grid_center,5,0,100),
				grid_col(label_msg109,100,grid_center,grid_center,5,0,100),
				grid_col(label_msg110,180,grid_left_align,grid_center,5,0,100),
				grid_col(label_msg111,100,grid_left_align,grid_center,5,0,100)
				]),ps_grid_callback),
	win_SetFont(GridWin,Font),!.

  ps_grid_handler(GridWin,EVENT,0):-
  	grid_HandleEvent(GridWin,EVENT).

predicates
  ps_get_data(INTEGER From_Row,INTEGER To_Row,INTEGER From_Column,
	INTEGER To_Column,GRIDLIST2D,GRIDLIST2D)
  ps_get_data1(INTEGER Row,INTEGER From_Column,INTEGER To_Column,
	GRIDLIST,GRIDLIST)
  ps_get_data2(INTEGER Row,INTEGER Column,GRIDTEXT)
clauses
  ps_grid_callback(Win,
		user_action(grid_row_marker_beg(_)),
		event_answer(continue)):-
	grid_Marker(Win,grid_no_marker),!.
  ps_grid_callback(Win,
		user_action(grid_marker(grid_row_marker([gl(Row,_)]),b_true)),
		event_answer(continue)):-
	ps_row(Row,Number),
	lf(Number,FormPage,ColorPage,_,LeftMarg,TopMarg,HorSpace,
		VertSpace,LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,_,_),
	ParentWin = win_GetParent(Win),
	PreviewWin = win_GetCtlHandle(ParentWin,778),
	preview_set(PreviewWin,FormPage,ColorPage,LeftMarg,TopMarg,HorSpace,
		VertSpace,LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll),!.
  ps_grid_callback(_,
		 user_action(grid_marker(grid_all_marker,_)),
		 event_answer(stop)):-!.
  ps_grid_callback(Win,
		 user_action(grid_col_marker_beg(Column)),
		 event_answer(stop)):-
	grid_Marker(Win,Marker),
	Marker = grid_row_marker([gl(Row,_)]),
	ps_row(Row,Number),
	retract(ps_sort(_)),
	assert(ps_sort(Column)),
	ps_sort_row(Column),
	win_Invalidate(Win),
	ps_row(Row1,Number),
	grid_Marker(Win,grid_row_marker([gl(Row1,Row1)])),!.
  ps_grid_callback(Win,
		 user_action(grid_edit_cell_beg(Row,_)),
		 event_answer(stop)):-
	grid_Marker(Win,grid_row_marker([gl(Row,Row)])),
	ps_grid_callback(Win,user_action(grid_marker(grid_row_marker([gl(Row,Row)]),b_true)),_),!.
  ps_grid_callback(Win,
		 user_action(grid_area_marker_beg(Row,_)),
		 event_answer(stop)):-
	grid_Marker(Win,grid_row_marker([gl(Row,Row)])),
	ps_grid_callback(Win,user_action(grid_marker(grid_row_marker([gl(Row,Row)]),b_true)),_),!.
  ps_grid_callback(GridWin,event(e_MouseDbl(_,_,_)),
		 event_answer(stop)):-
	Win = win_GetParent(GridWin),
	CtrlWin = win_GetCtlHandle(Win,779),
	win_SendEvent(Win,e_Control(779,wc_PushButton,CtrlWin,activated())),!.

  ps_grid_callback(_Win,data_request(grid_area(From_Row,To_Row,From_Column,To_Column)),
				data_answer(grid_area_answer(CellList))):-
	ps_get_data(From_Row,To_Row,From_Column,To_Column,[],CellList),!.

  ps_get_data(From_Row,To_Row,_,_,CellList2d,CellList2d):-
	From_Row > To_Row,!.
  ps_get_data(From_Row,To_Row,From_Column,To_Column,List2d,CellList2d):-
	ps_get_data1(To_Row,From_Column,To_Column,[],List),
	TR = To_Row - 1,
	ps_get_data(From_Row,TR,From_Column,To_Column,[List|List2d],CellList2d),!.

  ps_get_data1(_,From_Column,To_Column,CellList,CellList):-
	From_Column > To_Column,!.
  ps_get_data1(Row,From_Column,To_Column,List,CellList):-
	ps_get_data2(Row,To_Column,Answer),
	TC = To_Column - 1,
	ps_get_data1(Row,From_Column,TC,[Answer|List],CellList),!.

  ps_get_data2(Row,1,textatr(Number,color_Black,color_LtGray)):-
	ps_row(Row,Number),!.
  ps_get_data2(Row,2,textatr(String,color_Black,color_LtGray)):-
	ps_row(Row,Number),
	lf(Number,_,_,_,_,_,_,_,Width,Height,_,_,_,_,_),
	format(String,"% X %",Width,Height),!.
  ps_get_data2(Row,3,textatr(Comment,color_Black,color_LtGray)):-
	ps_row(Row,Number),
	lf(Number,_,_,Comment,_,_,_,_,_,_,_,_,_,_,_),!.
  ps_get_data2(Row,4,textatr(label_msg112,color_Black,color_LtGray)):-
	ps_row(Row,Number),
	lf(Number,_,_,_,_,_,_,_,_,_,_,_,b_true,_,_),!.
  ps_get_data2(Row,4,textatr(label_msg113,color_Black,color_LtGray)):-
	ps_row(Row,Number),
	lf(Number,_,_,_,_,_,_,_,_,_,_,_,b_false,_,_),!.

  ps_get_data2(_,_,empty_answer).

predicates
  ps_preview_handler : EHANDLER
clauses
  ps_preview_handler(PreviewWin,e_Create(_),0):-
	lf(_,FormPage,ColorPage,_,LeftMarg,TopMarg,HorSpace,
		VertSpace,LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,_,b_true),
	preview_Init(PreviewWin,FormPage,ColorPage,LeftMarg,TopMarg,HorSpace,
		VertSpace,LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,color_LtGray),!.

  ps_preview_handler(PreviewWin,EVENT,0):-
  	preview_HandleEvent(PreviewWin,EVENT).

/**global PREDICATE*******************************************************
			     PAGESET_GET_CURRENT
*************************************************************************/
predicates
  ps_set_marker(WINDOW,INTEGER Row)
clauses
  ps_set_marker(GridWin,Row):-
	ps_numb(Row1),
	Row <= Row1,
	grid_Rows(GridWin,Row1),
	grid_Marker(GridWin,grid_row_marker([gl(Row,Row)])),!.
  ps_set_marker(GridWin,Row):-
	Row1 = Row - 1,
	grid_Rows(GridWin,Row1),
	grid_Marker(GridWin,grid_row_marker([gl(Row1,Row1)])),!.
predicates
  ps_style_eh : EHANDLER
  ps_setup(WINDOW Parent,STRING Number,INTEGER FormPage,COLOR ColorPage,STRING Comment,
	REAL LeftMarg,REAL TopMarg,REAL HorSpace,REAL VertSpace,
	REAL LabelWidth,REAL LabelHeight,UNSIGNED NoHor,UNSIGNED NoVert,
	BOOLEAN Page_Roll,BOOLEAN Landscape)
  ps_add(WINDOW Parent,STRING Number,INTEGER FormPage,COLOR ColorPage,STRING Comment,
	REAL LeftMarg,REAL TopMarg,REAL HorSpace,REAL VertSpace,
	REAL LabelWidth,REAL LabelHeight,UNSIGNED NoHor,UNSIGNED NoVert,
	BOOLEAN Page_Roll,BOOLEAN Landscape)
clauses
  pageset_get_current(_,_):-
	ps_dialog_already_started,!.
  pageset_get_current(ParentWin,Font):-
	assert(ps_dialog_already_started),
	retractall(ps_font(_)),
	assert(ps_font(Font)),
	ps_load_page_data(),
	class_Create("grid",ps_grid_handler),
	class_Create("preview",ps_preview_handler),
	win_CreateDynDialog(ParentWin,[
		dlg(wdef(wd_Modal,rct(10,10,710,426),label_msg114,u_Pixels),[wsf_TitleBar,wsf_Close]),
		customctl(wdef(wc_custom,rct(5,5,538,413),"",u_Pixels),"grid",777,[]),
		customctl(wdef(wc_custom,rct(550,209,691,411),"",u_Pixels),"preview",778,[]),
		ctl(wdef(wc_PushButton,rct(550,5,691,30),label_msg180,u_Pixels),779,[]),
		ctl(wdef(wc_PushButton,rct(550,40,691,65),label_msg181,u_Pixels),780,[]),
		ctl(wdef(wc_PushButton,rct(550,75,691,100),label_msg115,u_Pixels),781,[]),
		ctl(wdef(wc_PushButton,rct(550,110,691,135),label_msg116,u_Pixels),782,[]),
		ctl(wdef(wc_PushButton,rct(550,145,691,170),label_msg117,u_Pixels),783,[])
	],ps_style_eh,0),
	class_Destroy("preview"),
	class_Destroy("grid"),
	retractall(ps_numb(_)),
	retractall(ps_sort(_)),
	retractall(ps_row(_,_)),
	retractall(ps_row1(_,_)),
	retractall(ps_row2(_,_)),
	retractall(ps_dialog_already_started),
	syspath(Path,_),
	format(FileName,"%sLABEL.DBA",Path),
	trap(save(FileName,page_set_db),_,fail),
	retract(ps_end_fail),!.

  pageset_get_current1(_,_):-
	ps_dialog_already_started,!.
  pageset_get_current1(Win,Font):-
	assert(ps_dialog_already_started),
	retractall(ps_font(_)),
	assert(ps_font(Font)),
	ps_load_page_data(),
	class_Create("grid",ps_grid_handler),
	lf(Number,FormPage,ColorPage,Comment,LeftMarg,TopMarg,HorSpace,VertSpace,
	LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,Landscape,b_true),
	ps_setup(Win,Number,FormPage,ColorPage,Comment,LeftMarg,TopMarg,HorSpace,VertSpace,
	LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,Landscape),
	retract(lf_setup(Number1,FormPage1,ColorPage1,Comment1,LeftMarg1,TopMarg1,
	HorSpace1,VertSpace1,LabelWidth1,LabelHeight1,NoHor1,NoVert1,Page_Roll1,Landscape1)),
	retract(lf(Number,FormPage,ColorPage,Comment,LeftMarg,TopMarg,HorSpace,VertSpace,
	LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,Landscape,b_true)),
	assert(lf(Number1,FormPage1,ColorPage1,Comment1,LeftMarg1,TopMarg1,
	HorSpace1,VertSpace1,LabelWidth1,LabelHeight1,NoHor1,NoVert1,Page_Roll1,Landscape1,b_true)),
	class_Destroy("grid"),
	retractall(ps_numb(_)),
	retractall(ps_sort(_)),
	retractall(ps_row(_,_)),
	retractall(ps_row1(_,_)),
	retractall(ps_row2(_,_)),
	retractall(ps_dialog_already_started),
	syspath(Path,_),
	format(FileName,"%sLABEL.DBA",Path),
	trap(save(FileName,page_set_db),_,fail),!.
  pageset_get_current1(_,_):-
	class_Destroy("grid"),
	retractall(ps_numb(_)),
	retractall(ps_sort(_)),
	retractall(ps_row(_,_)),
	retractall(ps_row1(_,_)),
	retractall(ps_row2(_,_)),
	retractall(ps_dialog_already_started),!,
	fail.

predicates
  ps_set_default(STRING Number)
clauses
  ps_style_eh(Win,e_Create(_),0):-
	lf(Number,_,_,_,_,_,_,_,_,_,_,_,_,_,b_true),
	ps_row(Row,Number),
	GridWin = win_GetCtlHandle(Win,777),
	grid_Marker(GridWin,grid_row_marker([gl(Row,Row)])),
	ps_font(Font),
	Ctl1 = win_GetCtlHandle(Win,779),
	win_SetFont(Ctl1,Font),
	Ctl2 = win_GetCtlHandle(Win,780),
	win_SetFont(Ctl2,Font),
	Ctl3 = win_GetCtlHandle(Win,781),
	win_SetFont(Ctl3,Font),
	Ctl4 = win_GetCtlHandle(Win,782),
	win_SetFont(Ctl4,Font),
	Ctl5 = win_GetCtlHandle(Win,783),
	win_SetFont(Ctl5,Font),!.
  ps_style_eh(Win,e_Control(779,_,_,activated()),0):-
	retract(lf(Number,FormPage,ColorPage,Comment,LeftMarg,TopMarg,HorSpace,VertSpace,
	LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,Landscape,b_true)),
	assert(lf(Number,FormPage,ColorPage,Comment,LeftMarg,TopMarg,HorSpace,VertSpace,
	LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,Landscape,b_false)),
	GridWin = win_GetCtlHandle(Win,777),
	grid_Marker(GridWin,Marker),
	Marker = grid_row_marker([gl(Row,_)]),
	ps_row(Row,Number1),
	retract(lf(Number1,FormPage1,ColorPage1,Comment1,LeftMarg1,TopMarg1,HorSpace1,VertSpace1,
	LabelWidth1,LabelHeight1,NoHor1,NoVert1,Page_Roll1,Landscape1,_)),
	assert(lf(Number1,FormPage1,ColorPage1,Comment1,LeftMarg1,TopMarg1,HorSpace1,VertSpace1,
	LabelWidth1,LabelHeight1,NoHor1,NoVert1,Page_Roll1,Landscape1,b_true)),
	assert(ps_end_fail),
	win_Destroy(Win),!.
  ps_style_eh(Win,e_Control(780,_,_,activated()),0):-
	GridWin = win_GetCtlHandle(Win,777),
	grid_Marker(GridWin,grid_no_marker),
	win_Destroy(Win),!.
  ps_style_eh(Win,e_Control(781,_,_,activated()),0):-
	ps_add(Win,label_msg120,1,color_White,"",0,0,0,0,0,0,0,0,b_true,b_false),
	retract(lf_setup(Number,FormPage,ColorPage,Comment,LeftMarg,TopMarg,
	HorSpace,VertSpace,LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,Landscape)),
	assert(lf(Number,FormPage,ColorPage,Comment,LeftMarg,TopMarg,
	HorSpace,VertSpace,LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,Landscape,b_false)),
	ps_sort(Column),
	ps_sort_row(Column),
	ps_row(Row,Number),
	GridWin = win_GetCtlHandle(Win,777),
	ps_set_marker(GridWin,Row),
	win_Invalidate(Win),!.
  ps_style_eh(Win,e_Control(781,_,_,activated()),0):-
	retractall(lf_setup(_,_,_,_,_,_,_,_,_,_,_,_,_,_)),
	GridWin = win_GetCtlHandle(Win,777),
	grid_Marker(GridWin,Marker),
	Marker = grid_row_marker([gl(Row,_)]),
	ps_row(Row,Number),
	lf(Number,FormPage,ColorPage,_,LeftMarg,TopMarg,HorSpace,
		VertSpace,LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,_,_),
	PreviewWin = win_GetCtlHandle(Win,778),
	preview_set(PreviewWin,FormPage,ColorPage,LeftMarg,TopMarg,HorSpace,
		VertSpace,LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll),!.
  ps_style_eh(Win,e_Control(782,_,_,activated()),0):-
	GridWin = win_GetCtlHandle(Win,777),
	grid_Marker(GridWin,Marker),
	Marker = grid_row_marker([gl(Row,_)]),
	ps_row(Row,Number),
	lf(Number,FormPage,ColorPage,Comment,LeftMarg,TopMarg,HorSpace,VertSpace,
	LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,Landscape,_),
	ps_setup(Win,Number,FormPage,ColorPage,Comment,LeftMarg,TopMarg,HorSpace,VertSpace,
	LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,Landscape),
	retract(lf_setup(Number1,FormPage1,ColorPage1,Comment1,LeftMarg1,TopMarg1,
	HorSpace1,VertSpace1,LabelWidth1,LabelHeight1,NoHor1,NoVert1,Page_Roll1,Landscape1)),
	retract(lf(Number,FormPage,ColorPage,Comment,LeftMarg,TopMarg,HorSpace,VertSpace,
	LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,Landscape,Default)),
	assert(lf(Number1,FormPage1,ColorPage1,Comment1,LeftMarg1,TopMarg1,
	HorSpace1,VertSpace1,LabelWidth1,LabelHeight1,NoHor1,NoVert1,Page_Roll1,Landscape1,Default)),
	retract(ps_row(Row,Number)),
	assert(ps_row(Row,Number1)),
	win_Invalidate(Win),!.
  ps_style_eh(Win,e_Control(782,_,_,activated()),0):-
	retractall(lf_setup(_,_,_,_,_,_,_,_,_,_,_,_,_,_)),
	GridWin = win_GetCtlHandle(Win,777),
	grid_Marker(GridWin,Marker),
	Marker = grid_row_marker([gl(Row,_)]),
	ps_row(Row,Number),
	lf(Number,FormPage,ColorPage,_,LeftMarg,TopMarg,HorSpace,
		VertSpace,LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,_,_),
	PreviewWin = win_GetCtlHandle(Win,778),
	preview_set(PreviewWin,FormPage,ColorPage,LeftMarg,TopMarg,HorSpace,
		VertSpace,LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll),!.
  ps_style_eh(Win,e_Control(783,_,_,activated()),0):-
	GridWin = win_GetCtlHandle(Win,777),
	grid_Marker(GridWin,Marker),
	Marker = grid_row_marker([gl(Row,_)]),
	ps_row(Row,Number),
	retract(lf(Number,_,_,_,_,_,_,_,_,_,_,_,_,_,_)),
	ps_sort(Column),
	ps_sort_row(Column),
	ps_set_marker(GridWin,Row),
	win_Invalidate(Win),
	grid_Marker(GridWin,Marker1),
	Marker1 = grid_row_marker([gl(Row1,_)]),
	ps_row(Row1,Number1),
	ps_set_default(Number1),!.

  ps_set_default(Number):-
	not(lf(_,_,_,_,_,_,_,_,_,_,_,_,_,_,b_true)),
	retract(lf(Number,FormPage,ColorPage,Comment,LeftMarg,TopMarg,HorSpace,VertSpace,
	LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,Landscape,_)),
	assert(lf(Number,FormPage,ColorPage,Comment,LeftMarg,TopMarg,HorSpace,VertSpace,
	LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,Landscape,b_true)),!.


/**global PREDICATE*******************************************************
			     PAGESET_GET_DEFAULT
*************************************************************************/
  pageset_get_default(Number,FormPage,ColorPage,Comment,LeftMarg,TopMarg,HorSpace,VertSpace,
	LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,Landscape):-
	ps_dialog_already_started,
	ps_load_page_data(),
	lf(Number,FormPage,ColorPage,Comment,LeftMarg,TopMarg,HorSpace,VertSpace,
	LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,Landscape,b_true),
	retractall(ps_numb(_)),
	retractall(ps_sort(_)),
	retractall(ps_row1(_,_)),
	retractall(ps_row2(_,_)),!.
  pageset_get_default(Number,FormPage,ColorPage,Comment,LeftMarg,TopMarg,HorSpace,VertSpace,
	LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,Landscape):-
	ps_load_page_data(),
	lf(Number,FormPage,ColorPage,Comment,LeftMarg,TopMarg,HorSpace,VertSpace,
	LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,Landscape,b_true),
	retractall(ps_numb(_)),
	retractall(ps_sort(_)),
	retractall(ps_row(_,_)),
	retractall(ps_row1(_,_)),
	retractall(ps_row2(_,_)),!.

/**global PREDICATE*******************************************************
			     PAGESET_SET_DEFAULT
*************************************************************************/
predicates
  ps_dialog_Ask()
clauses
  pageset_set_default(_,Number,FormPage,ColorPage,Comment,LeftMarg,TopMarg,HorSpace,VertSpace,
	LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,Landscape):-
	ps_load_page_data(),
	lf(Number,FormPage,ColorPage,Comment,LeftMarg,TopMarg,HorSpace,VertSpace,
	LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,Landscape,b_true),
	retractall(ps_numb(_)),
	retractall(ps_sort(_)),
	retractall(ps_row(_,_)),
	retractall(ps_row1(_,_)),
	retractall(ps_row2(_,_)),!.
  pageset_set_default(_,Number,FormPage,ColorPage,Comment,LeftMarg,TopMarg,HorSpace,VertSpace,
	LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,Landscape):-
	retract(lf(Number,FormPage,ColorPage,Comment,LeftMarg,TopMarg,HorSpace,VertSpace,
	LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,Landscape,_)),
	assert(lf(Number,FormPage,ColorPage,Comment,LeftMarg,TopMarg,HorSpace,VertSpace,
	LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,Landscape,b_true)),
	retract(lf(Number1,FormPage1,ColorPage1,Comment1,LeftMarg1,TopMarg1,HorSpace1,VertSpace1,
	LabelWidth1,LabelHeight1,NoHor1,NoVert1,Page_Roll1,Landscape1,b_true)),
	assert(lf(Number1,FormPage1,ColorPage1,Comment1,LeftMarg1,TopMarg1,HorSpace1,VertSpace1,
	LabelWidth1,LabelHeight1,NoHor1,NoVert1,Page_Roll1,Landscape1,b_false)),
	retractall(ps_numb(_)),
	retractall(ps_sort(_)),
	retractall(ps_row(_,_)),
	retractall(ps_row1(_,_)),
	retractall(ps_row2(_,_)),
	syspath(Path,_),
	format(FileName,"%sLABEL.DBA",Path),
	trap(save(FileName,page_set_db),_,fail),!.
  pageset_set_default(_,Number,FormPage,ColorPage,Comment,LeftMarg,TopMarg,HorSpace,VertSpace,
	LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,Landscape):-
	not(lf(Number,_,_,_,_,_,_,_,_,_,_,_,_,_,_)),
	assert(lf(Number,FormPage,ColorPage,Comment,LeftMarg,TopMarg,HorSpace,VertSpace,
	LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,Landscape,b_true)),
	retract(lf(Number1,FormPage1,ColorPage1,Comment1,LeftMarg1,TopMarg1,HorSpace1,VertSpace1,
	LabelWidth1,LabelHeight1,NoHor1,NoVert1,Page_Roll1,Landscape1,b_true)),
	assert(lf(Number1,FormPage1,ColorPage1,Comment1,LeftMarg1,TopMarg1,HorSpace1,VertSpace1,
	LabelWidth1,LabelHeight1,NoHor1,NoVert1,Page_Roll1,Landscape1,b_false)),
	retractall(ps_numb(_)),
	retractall(ps_sort(_)),
	retractall(ps_row(_,_)),
	retractall(ps_row1(_,_)),
	retractall(ps_row2(_,_)),
	syspath(Path,_),
	format(FileName,"%sLABEL.DBA",Path),
	trap(save(FileName,page_set_db),_,fail),!.
  pageset_set_default(Font,Number,FormPage,ColorPage,Comment,LeftMarg,TopMarg,HorSpace,VertSpace,
	LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,Landscape):-
	retractall(ps_font(_)),
	assert(ps_font(Font)),
	lf(Number,_,_,_,_,_,_,_,_,_,_,_,_,_,_),
	ps_dialog_Ask(),
	retract(lf(Number,_,_,_,_,_,_,_,_,_,_,_,_,_,_)),
	assert(lf(Number,FormPage,ColorPage,Comment,LeftMarg,TopMarg,HorSpace,VertSpace,
	LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,Landscape,b_true)),
	retract(lf(Number1,FormPage1,ColorPage1,Comment1,LeftMarg1,TopMarg1,HorSpace1,VertSpace1,
	LabelWidth1,LabelHeight1,NoHor1,NoVert1,Page_Roll1,Landscape1,b_true)),
	assert(lf(Number1,FormPage1,ColorPage1,Comment1,LeftMarg1,TopMarg1,HorSpace1,VertSpace1,
	LabelWidth1,LabelHeight1,NoHor1,NoVert1,Page_Roll1,Landscape1,b_false)),
	retractall(ps_numb(_)),
	retractall(ps_sort(_)),
	retractall(ps_row(_,_)),
	retractall(ps_row1(_,_)),
	retractall(ps_row2(_,_)),
	syspath(Path,_),
	format(FileName,"%sLABEL.DBA",Path),
	trap(save(FileName,page_set_db),_,fail),!.
  pageset_set_default(_,_,_,_,_,_,_,_,_,_,_,_,_,_,_):-
	retractall(ps_numb(_)),
	retractall(ps_sort(_)),
	retractall(ps_row(_,_)),
	retractall(ps_row1(_,_)),
	retractall(ps_row2(_,_)),!.

predicates
  ps_dialog_ask_eh : EHANDLER
clauses
  ps_dialog_Ask():-
	TaskWin1 = vpi_GetAttrVal(attr_task_window),
	TaskWin = cast(window,TaskWin1),
	dialog_Create(TaskWin,[resdlg(idd_ps_ask,wd_Modal)],
  		[
		df(idct_ask_1,statictext(label_msg121),nopr),
		df(idct_ask_2,statictext(label_msg122),nopr),
		df(idc_ok,pushbutton(label_msg187),nopr),
		df(idc_cancel,pushbutton(label_msg188),nopr)
  		],
		ps_dialog_ask_eh,0,_,Answer),
	Answer = idc_ok,!.

  ps_dialog_ask_eh(Win,e_Create(_),0):-
	ps_font(Font),
	Ctl1 = win_GetCtlHandle(Win,idct_ask_1),
	win_SetFont(Ctl1,Font),
	Ctl2 = win_GetCtlHandle(Win,idct_ask_2),
	win_SetFont(Ctl2,Font),
	Ctl3 = win_GetCtlHandle(Win,idc_ok),
	win_SetFont(Ctl3,Font),
	Ctl4 = win_GetCtlHandle(Win,idc_cancel),
	win_SetFont(Ctl4,Font),!.

predicates
  ps_setup_eh : EHANDLER
clauses
  ps_setup(ParentWin,Number,FormPage,ColorPage,Comment,LeftMarg,TopMarg,HorSpace,VertSpace,
	LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,Landscape):-
	assert(ps_setup_create),
	assert(lf_setup(Number,FormPage,ColorPage,Comment,LeftMarg,TopMarg,
	HorSpace,VertSpace,LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,Landscape)),
	retractall(lf_start_number(_)),
	assert(lf_start_number(Number)),
	win_CreateDynDialog(ParentWin,[
		dlg(wdef(wd_Modal,rct(5,5,533,383),label_msg123,u_Pixels),[wsf_TitleBar,wsf_Close]),
		customctl(wdef(wc_custom,rct(5,5,521,238),"",u_Pixels),"grid",777,[]),
		ctl(wdef(wc_Text,rct(5,285,115,310),label_msg124,u_Pixels),781,[]),
		ctl(wdef(wc_Edit,rct(115,285,250,310),"",u_Pixels),782,[wsf_Disabled]),
		ctl(wdef(wc_Text,rct(276,285,436,310),label_msg125,u_Pixels),783,[]),
		ctl(wdef(wc_Edit,rct(436,285,521,310),"",u_Pixels),784,[wsf_Disabled]),
		ctl(wdef(wc_PushButton,rct(130,337,230,362),label_msg180,u_Pixels),779,[]),
		ctl(wdef(wc_PushButton,rct(296,337,396,362),label_msg181,u_Pixels),780,[])
	],ps_setup_eh,0),
	retractall(lf_start_number(_)),
	retract(ps_setup_create_ok),!.

predicates
  ps_get_str0(INTEGER Row,INTEGER Column,STRING Str)
clauses
  ps_setup_eh(Win,e_Create(_),0):-
	ps_get_str0(10,10,PageSize),
	ps_get_str0(20,20,Num),
	PageSizeWin = win_GetCtlHandle(Win,782),
	win_SetText(PageSizeWin,PageSize),
	NumWin = win_GetCtlHandle(Win,784),
	win_SetText(NumWin,Num),
	ps_font(Font),
	win_SetFont(PageSizeWin,Font),
	win_SetFont(NumWin,Font),
	Ctl1 = win_GetCtlHandle(Win,781),
	win_SetFont(Ctl1,Font),
	Ctl2 = win_GetCtlHandle(Win,783),
	win_SetFont(Ctl2,Font),
	Ctl3 = win_GetCtlHandle(Win,779),
	win_SetFont(Ctl3,Font),
	Ctl4 = win_GetCtlHandle(Win,780),
	win_SetFont(Ctl4,Font),
	fail.
  ps_setup_eh(Win,e_Control(779,_,_,activated()),0):-
	GridWin = win_GetCtlHandle(Win,777),
	grid_Marker(GridWin,grid_no_marker),
	lf_start_number(StartNumber),
	lf_setup(Number,_,_,_,_,_,_,_,_,_,_,_,_,_),
	StartNumber <> Number,
	lf(Number,_,_,_,_,_,_,_,_,_,_,_,_,_,_),
	format(Str,label_msg126,Number),
	dlg_note(Str),!.
  ps_setup_eh(Win,e_Control(779,_,_,activated()),0):-
	assert(ps_setup_create_ok),
	win_Destroy(Win),!.
  ps_setup_eh(Win,e_Control(780,_,_,activated()),0):-
	win_Destroy(Win),!.

predicates
  ps_add_eh : EHANDLER
clauses
  ps_add(ParentWin,Number,FormPage,ColorPage,Comment,LeftMarg,TopMarg,HorSpace,VertSpace,
	LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,Landscape):-
	assert(ps_setup_create),
	assert(lf_setup(Number,FormPage,ColorPage,Comment,LeftMarg,TopMarg,
	HorSpace,VertSpace,LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,Landscape)),
	win_CreateDynDialog(ParentWin,[
		dlg(wdef(wd_Modal,rct(5,5,533,383),label_msg123,u_Pixels),[wsf_TitleBar,wsf_Close]),
		customctl(wdef(wc_custom,rct(5,5,521,238),"",u_Pixels),"grid",777,[]),
		ctl(wdef(wc_Text,rct(5,285,115,310),label_msg124,u_Pixels),781,[]),
		ctl(wdef(wc_Edit,rct(115,285,250,310),"",u_Pixels),782,[wsf_Disabled]),
		ctl(wdef(wc_Text,rct(276,285,436,310),label_msg125,u_Pixels),783,[]),
		ctl(wdef(wc_Edit,rct(436,285,521,310),"",u_Pixels),784,[wsf_Disabled]),
		ctl(wdef(wc_PushButton,rct(130,337,230,362),label_msg180,u_Pixels),779,[]),
		ctl(wdef(wc_PushButton,rct(296,337,396,362),label_msg181,u_Pixels),780,[])
	],ps_add_eh,0),
	retract(ps_setup_create_ok),!.
predicates
  ps_set_preview(WINDOW)
clauses
  ps_add_eh(Win,e_Create(_),0):-
	GridWin = win_GetCtlHandle(Win,777),
	grid_Marker(GridWin,grid_edit_cell(1,2)),
	ps_get_str0(10,10,PageSize),
	ps_get_str0(20,20,Num),
	PageSizeWin = win_GetCtlHandle(Win,782),
	win_SetText(PageSizeWin,PageSize),
	NumWin = win_GetCtlHandle(Win,784),
	win_SetText(NumWin,Num),
	ps_set_preview(Win),
	ps_font(Font),
	win_SetFont(PageSizeWin,Font),
	win_SetFont(NumWin,Font),
	Ctl1 = win_GetCtlHandle(Win,781),
	win_SetFont(Ctl1,Font),
	Ctl2 = win_GetCtlHandle(Win,783),
	win_SetFont(Ctl2,Font),
	Ctl3 = win_GetCtlHandle(Win,779),
	win_SetFont(Ctl3,Font),
	Ctl4 = win_GetCtlHandle(Win,780),
	win_SetFont(Ctl4,Font),
	fail.
  ps_add_eh(Win,e_Control(779,_,_,activated()),0):-
	GridWin = win_GetCtlHandle(Win,777),
	grid_Marker(GridWin,grid_no_marker),
	lf_setup(Number,_,_,_,_,_,_,_,_,_,_,_,_,_),
	lf(Number,_,_,_,_,_,_,_,_,_,_,_,_,_,_),
	format(Str,label_msg126,Number),
	dlg_note(Str),!.
  ps_add_eh(Win,e_Control(779,_,_,activated()),0):-
	assert(ps_setup_create_ok),
	win_Destroy(Win),!.
  ps_add_eh(Win,e_Control(780,_,_,activated()),0):-
	GridWin = win_GetCtlHandle(Win,777),
	grid_Marker(GridWin,grid_no_marker),
	win_Destroy(Win),!.

predicates
  ps_get_data0(INTEGER From_Row,INTEGER To_Row,INTEGER From_Column,
	INTEGER To_Column,GRIDLIST2D,GRIDLIST2D)
  ps_get_data01(INTEGER Row,INTEGER From_Column,INTEGER To_Column,
	GRIDLIST,GRIDLIST)
  ps_get_data02(INTEGER Row,INTEGER Column,GRIDTEXT)
  ps_set_value(WINDOW GridWin,INTEGER Row,INTEGER Column,STRING Str)
clauses
  ps_set_preview(Win):-
	ParentWin1 = win_GetParent(Win),
	ParentWin = win_GetParent(ParentWin1),
	trap(PreviewWin = win_GetCtlHandle(ParentWin,778),_,fail),
	lf_setup(_,FormPage,ColorPage,_,LeftMarg,TopMarg,HorSpace,
		VertSpace,LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,_),
	preview_set(PreviewWin,FormPage,ColorPage,LeftMarg,TopMarg,HorSpace,
		VertSpace,LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll),!.
  ps_set_preview(_).

  ps_grid_callback1(_,
		 user_action(grid_resize_column_beg(_)),
		 event_answer(stop)):-!.
  ps_grid_callback1(_,
		 user_action(grid_marker(grid_all_marker,_)),
		 event_answer(stop)):-!.
  ps_grid_callback1(_,
		 user_action(grid_col_marker_beg(_)),
		 event_answer(stop)):-!.
  ps_grid_callback1(_,
		 user_action(grid_row_marker_beg(_)),
		 event_answer(stop)):-!.
  ps_grid_callback1(Win,
		 user_action(grid_marker(grid_edit_cell(Row,1),b_true)),
		 event_answer(stop)):-
	grid_Marker(Win,grid_edit_cell(Row,2)),!.
  ps_grid_callback1(Win,
		 user_action(grid_marker(grid_edit_cell(Row,3),b_true)),
		 event_answer(stop)):-
	grid_Marker(Win,grid_edit_cell(Row,4)),!.
  ps_grid_callback1(_,
		 user_action(grid_marker(grid_edit_cell(2,2),b_true)),
		 event_answer(lBoxButton([label_msg112,label_msg113],Str))):-
	ps_get_str0(2,2,Str),!.
  ps_grid_callback1(_,
		 user_action(grid_marker(grid_edit_cell(3,2),b_true)),
		 event_answer(lBoxButton([label_msg127,label_msg128,label_msg129],Str))):-
	ps_get_str0(3,2,Str),!.
  ps_grid_callback1(_,
		 user_action(grid_marker(grid_edit_cell(4,2),b_true)),
		 event_answer(lBoxButton([label_msg30,label_msg31,label_msg32,label_msg33,
		 label_msg34,label_msg35,label_msg36,label_msg37,label_msg38,label_msg39,
		 label_msg40,label_msg41,label_msg42,label_msg43,label_msg44,label_msg45],Str))):-
	ps_get_str0(4,2,Str),!.
  ps_grid_callback1(_,
		 user_action(grid_marker(grid_edit_cell(5,2),b_true)),
		 event_answer(lBoxButton([label_msg130,label_msg131],Str))):-
	ps_get_str0(5,2,Str),!.
  ps_grid_callback1(_,
		 user_action(grid_marker(grid_edit_cell(Row,2),b_true)),
		 event_answer(editCtrl(Str))):-
	ps_get_str0(Row,2,Str),!.
  ps_grid_callback1(_,
		 user_action(grid_marker(grid_edit_cell(Row,4),b_true)),
		 event_answer(editCtrl(Str))):-
	ps_get_str0(Row,4,Str),!.

  ps_grid_callback1(Win,
		 user_action(modified(Row,Column,Str)),
		 event_answer(continue)):-
	ps_get_str0(Row,Column,Str1),
	Str <> Str1,
	ps_set_value(Win,Row,Column,Str),
	ParentWin1 = win_GetParent(Win),
	ps_get_str0(10,10,PageSize),
	ps_get_str0(20,20,Num),
	PageSizeWin = win_GetCtlHandle(ParentWin1,782),
	win_SetText(PageSizeWin,PageSize),
	NumWin = win_GetCtlHandle(ParentWin1,784),
	win_SetText(NumWin,Num),
	ps_set_preview(Win),!.

  ps_grid_callback1(_Win,data_request(grid_area(From_Row,To_Row,From_Column,To_Column)),
				data_answer(grid_area_answer(CellList))):-
	ps_get_data0(From_Row,To_Row,From_Column,To_Column,[],CellList),!.

  ps_get_data0(From_Row,To_Row,_,_,CellList2d,CellList2d):-
	From_Row > To_Row,!.
  ps_get_data0(From_Row,To_Row,From_Column,To_Column,List2d,CellList2d):-
	ps_get_data01(To_Row,From_Column,To_Column,[],List),
	TR = To_Row - 1,
	ps_get_data0(From_Row,TR,From_Column,To_Column,[List|List2d],CellList2d),!.

  ps_get_data01(_,From_Column,To_Column,CellList,CellList):-
	From_Column > To_Column,!.
  ps_get_data01(Row,From_Column,To_Column,List,CellList):-
	ps_get_data02(Row,To_Column,Answer),
	TC = To_Column - 1,
	ps_get_data01(Row,From_Column,TC,[Answer|List],CellList),!.

predicates
  ps_get_color(ULONG,STRING)
clauses
  ps_get_color(0xFFFFFF,label_msg30):-!.
  ps_get_color(0x000000,label_msg31):-!.
  ps_get_color(0x808080,label_msg32):-!.
  ps_get_color(0xC0C0C0,label_msg33):-!.
  ps_get_color(0x0000FF,label_msg34):-!.
  ps_get_color(0x000080,label_msg35):-!.
  ps_get_color(0x00FF00,label_msg36):-!.
  ps_get_color(0x008000,label_msg37):-!.
  ps_get_color(0xFF0000,label_msg38):-!.
  ps_get_color(0x800000,label_msg39):-!.
  ps_get_color(0xFFFF00,label_msg40):-!.
  ps_get_color(0x808000,label_msg41):-!.
  ps_get_color(0xFF00FF,label_msg42):-!.
  ps_get_color(0x800080,label_msg43):-!.
  ps_get_color(0x00FFFF,label_msg44):-!.
  ps_get_color(0x008080,label_msg45):-!.

predicates
  ps_min(INTEGER X1,INTEGER X2,INTEGER X3)
clauses
  ps_min(X1,X2,X1):-
	X1 < X2,!.
  ps_min(_,X2,X2).

  ps_get_data02(1,2,textatr(Number,color_Black,color_LtGray)):-
	lf_setup(Number,_,_,_,_,_,_,_,_,_,_,_,_,_),!.
  ps_get_data02(2,2,textatr(label_msg112,color_Black,color_LtGray)):-
	lf_setup(_,_,_,_,_,_,_,_,_,_,_,_,b_true,_),!.
  ps_get_data02(2,2,textatr(label_msg113,color_Black,color_LtGray)):-
	lf_setup(_,_,_,_,_,_,_,_,_,_,_,_,b_false,_),!.
  ps_get_data02(3,2,textatr(label_msg127,color_Black,color_LtGray)):-
	lf_setup(_,1,_,_,_,_,_,_,_,_,_,_,_,_),!.
  ps_get_data02(3,2,textatr(label_msg128,color_Black,color_LtGray)):-
	lf_setup(_,2,_,_,_,_,_,_,_,_,_,_,_,_),!.
  ps_get_data02(3,2,textatr(label_msg129,color_Black,color_LtGray)):-
	lf_setup(_,3,_,_,_,_,_,_,_,_,_,_,_,_),!.
  ps_get_data02(4,2,textatr(Str,color_Black,color_LtGray)):-
	lf_setup(_,_,ColorPage,_,_,_,_,_,_,_,_,_,_,_),
	ps_get_color(ColorPage,Str),!.
  ps_get_data02(5,2,textatr(label_msg131,color_Black,color_LtGray)):-
	lf_setup(_,_,_,_,_,_,_,_,_,_,_,_,_,b_true),!.
  ps_get_data02(5,2,textatr(label_msg130,color_Black,color_LtGray)):-
	lf_setup(_,_,_,_,_,_,_,_,_,_,_,_,_,b_false),!.
  ps_get_data02(6,2,textatr(Str,color_Black,color_LtGray)):-
	lf_setup(_,_,_,_,_,_,_,_,LabelWidth,_,_,_,_,_),
	format(Str,"%",LabelWidth),!.
  ps_get_data02(7,2,textatr(Str,color_Black,color_LtGray)):-
	lf_setup(_,_,_,_,_,_,_,_,_,LabelHeight,_,_,_,_),
	format(Str,"%",LabelHeight),!.
  ps_get_data02(1,4,textatr(Str,color_Black,color_LtGray)):-
	lf_setup(_,_,_,_,_,_,_,_,_,_,NoHor,_,_,_),
	format(Str,"%",NoHor),!.
  ps_get_data02(2,4,textatr(Str,color_Black,color_LtGray)):-
	lf_setup(_,_,_,_,_,_,_,_,_,_,_,NoVert,_,_),
	format(Str,"%",NoVert),!.
  ps_get_data02(3,4,textatr(Str,color_Black,color_LtGray)):-
	lf_setup(_,_,_,_,LeftMarg,_,_,_,_,_,_,_,_,_),
	format(Str,"%",LeftMarg),!.
  ps_get_data02(4,4,textatr(Str,color_Black,color_LtGray)):-
	lf_setup(_,_,_,_,_,TopMarg,_,_,_,_,_,_,_,_),
	format(Str,"%",TopMarg),!.
  ps_get_data02(5,4,textatr(Str,color_Black,color_LtGray)):-
	lf_setup(_,_,_,_,_,_,HorSpace,_,_,_,_,_,_,_),
	format(Str,"%",HorSpace),!.
  ps_get_data02(6,4,textatr(Str,color_Black,color_LtGray)):-
	lf_setup(_,_,_,_,_,_,_,VertSpace,_,_,_,_,_,_),
	format(Str,"%",VertSpace),!.
  ps_get_data02(7,4,textatr(Comment,color_Black,color_LtGray)):-
	lf_setup(_,_,_,Comment,_,_,_,_,_,_,_,_,_,_),!.

  ps_get_data02(10,10,textatr(Str,0x808040,color_LtGray)):-
	lf_setup(_,_,_,_,LeftMarg,TopMarg,HorSpace,VertSpace,
	LabelWidth,LabelHeight,NoHor,NoVert,b_true,_),
	ps_min(NoHor,1,NH),
	Width = LeftMarg * 2 + LabelWidth * NoHor + HorSpace * NH,
	ps_min(NoVert,1,NV),
	Height = TopMarg * 2 + LabelHeight * NoVert + VertSpace * NV,
	format(Str,"% X %",Width,Height),!.
  ps_get_data02(10,10,textatr(Str,0x808040,color_LtGray)):-
	lf_setup(_,_,_,_,LeftMarg,_,HorSpace,_,
	LabelWidth,_,NoHor,_,b_false,_),
	ps_min(NoHor,1,NH),
	Width = LeftMarg * 2 + LabelWidth * NoHor + HorSpace * NH,
	format(Str,"% X ~~~",Width),!.

  ps_get_data02(20,20,textatr(Str,0x808040,color_LtGray)):-
	lf_setup(_,_,_,_,_,_,_,_,_,_,NoHor,NoVert,b_true,_),
	Num = NoHor * NoVert,
	format(Str,"%",Num),!.
  ps_get_data02(20,20,textatr("~~~",0x808040,color_LtGray)):-!.

  ps_get_data02(1,1,textatr(label_msg132,0x808040,color_LtGray)):-!.
  ps_get_data02(2,1,textatr(label_msg133,0x808040,color_LtGray)):-!.
  ps_get_data02(3,1,textatr(label_msg134,0x808040,color_LtGray)):-!.
  ps_get_data02(4,1,textatr(label_msg135,0x808040,color_LtGray)):-!.
  ps_get_data02(5,1,textatr(label_msg136,0x808040,color_LtGray)):-!.
  ps_get_data02(6,1,textatr(label_msg137,0x808040,color_LtGray)):-!.
  ps_get_data02(7,1,textatr(label_msg138,0x808040,color_LtGray)):-!.
  ps_get_data02(1,3,textatr(label_msg139,0x808040,color_LtGray)):-!.
  ps_get_data02(2,3,textatr(label_msg140,0x808040,color_LtGray)):-!.
  ps_get_data02(3,3,textatr(label_msg141,0x808040,color_LtGray)):-!.
  ps_get_data02(4,3,textatr(label_msg142,0x808040,color_LtGray)):-!.
  ps_get_data02(5,3,textatr(label_msg143,0x808040,color_LtGray)):-!.
  ps_get_data02(6,3,textatr(label_msg144,0x808040,color_LtGray)):-!.
  ps_get_data02(7,3,textatr(label_msg110,0x808040,color_LtGray)):-!.

  ps_get_data02(_,_,empty_answer).

  ps_get_str0(Row,Column,Str):-
	ps_get_data02(Row,Column,Answer),
	Answer = textatr(Str,_,_),!.

  ps_set_value(_,1,2,Str):-
	retract(lf_setup(_,FormPage,ColorPage,Comment,LeftMarg,TopMarg,
	HorSpace,VertSpace,LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,Landscape)),
	assert(lf_setup(Str,FormPage,ColorPage,Comment,LeftMarg,TopMarg,
	HorSpace,VertSpace,LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,Landscape)),!.
  ps_set_value(GridWin,2,2,label_msg112):-
	retract(lf_setup(Number,FormPage,ColorPage,Comment,LeftMarg,TopMarg,
	HorSpace,VertSpace,LabelWidth,LabelHeight,NoHor,_,_,b_false)),
	assert(lf_setup(Number,FormPage,ColorPage,Comment,LeftMarg,TopMarg,
	HorSpace,VertSpace,LabelWidth,LabelHeight,NoHor,1,b_true,b_false)),
	grid_Invalidate(GridWin,grid_area(2,2,4,4)),!.
  ps_set_value(GridWin,2,2,label_msg112):-
	retract(lf_setup(Number,FormPage,ColorPage,Comment,LeftMarg,TopMarg,
	HorSpace,VertSpace,LabelWidth,LabelHeight,_,NoVert,_,b_true)),
	assert(lf_setup(Number,FormPage,ColorPage,Comment,LeftMarg,TopMarg,
	HorSpace,VertSpace,LabelWidth,LabelHeight,1,NoVert,b_true,b_true)),
	grid_Invalidate(GridWin,grid_area(1,1,4,4)),!.
  ps_set_value(GridWin,2,2,label_msg113):-
	retract(lf_setup(Number,FormPage,ColorPage,Comment,LeftMarg,TopMarg,
	HorSpace,VertSpace,LabelWidth,LabelHeight,NoHor,_,_,b_false)),
	assert(lf_setup(Number,FormPage,ColorPage,Comment,LeftMarg,TopMarg,
	HorSpace,VertSpace,LabelWidth,LabelHeight,NoHor,0,b_false,b_false)),
	grid_Invalidate(GridWin,grid_area(2,2,4,4)),!.
  ps_set_value(GridWin,2,2,label_msg113):-
	retract(lf_setup(Number,FormPage,ColorPage,Comment,LeftMarg,TopMarg,
	HorSpace,VertSpace,LabelWidth,LabelHeight,_,NoVert,_,b_true)),
	assert(lf_setup(Number,FormPage,ColorPage,Comment,LeftMarg,TopMarg,
	HorSpace,VertSpace,LabelWidth,LabelHeight,0,NoVert,b_false,b_true)),
	grid_Invalidate(GridWin,grid_area(1,1,4,4)),!.
  ps_set_value(_,3,2,label_msg127):-
	retract(lf_setup(Number,_,ColorPage,Comment,LeftMarg,TopMarg,
	HorSpace,VertSpace,LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,Landscape)),
	assert(lf_setup(Number,1,ColorPage,Comment,LeftMarg,TopMarg,
	HorSpace,VertSpace,LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,Landscape)),!.
  ps_set_value(_,3,2,label_msg128):-
	retract(lf_setup(Number,_,ColorPage,Comment,LeftMarg,TopMarg,
	HorSpace,VertSpace,LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,Landscape)),
	assert(lf_setup(Number,2,ColorPage,Comment,LeftMarg,TopMarg,
	HorSpace,VertSpace,LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,Landscape)),!.
  ps_set_value(_,3,2,label_msg129):-
	retract(lf_setup(Number,_,ColorPage,Comment,LeftMarg,TopMarg,
	HorSpace,VertSpace,LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,Landscape)),
	assert(lf_setup(Number,3,ColorPage,Comment,LeftMarg,TopMarg,
	HorSpace,VertSpace,LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,Landscape)),!.
  ps_set_value(_,4,2,Str):-
	ps_get_color(ColorPage,Str),
	retract(lf_setup(Number,FormPage,_,Comment,LeftMarg,TopMarg,
	HorSpace,VertSpace,LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,Landscape)),
	assert(lf_setup(Number,FormPage,ColorPage,Comment,LeftMarg,TopMarg,
	HorSpace,VertSpace,LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,Landscape)),!.
  ps_set_value(GridWin,5,2,label_msg131):-
	retract(lf_setup(Number,FormPage,ColorPage,Comment,LeftMarg,TopMarg,
	HorSpace,VertSpace,LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,_)),
	assert(lf_setup(Number,FormPage,ColorPage,Comment,TopMarg,LeftMarg,
	VertSpace,HorSpace,LabelHeight,LabelWidth,NoVert,NoHor,Page_Roll,b_true)),
	grid_Invalidate(GridWin,grid_all),!.
  ps_set_value(GridWin,5,2,label_msg130):-
	retract(lf_setup(Number,FormPage,ColorPage,Comment,LeftMarg,TopMarg,
	HorSpace,VertSpace,LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,_)),
	assert(lf_setup(Number,FormPage,ColorPage,Comment,TopMarg,LeftMarg,
	VertSpace,HorSpace,LabelHeight,LabelWidth,NoVert,NoHor,Page_Roll,b_false)),
	grid_Invalidate(GridWin,grid_all),!.
  ps_set_value(_,6,2,Str):-
	trap(term_str(real,LabelWidth,Str),_,fail),
	retract(lf_setup(Number,FormPage,ColorPage,Comment,LeftMarg,TopMarg,
	HorSpace,VertSpace,_,LabelHeight,NoHor,NoVert,Page_Roll,Landscape)),
	assert(lf_setup(Number,FormPage,ColorPage,Comment,LeftMarg,TopMarg,
	HorSpace,VertSpace,LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,Landscape)),!.
  ps_set_value(_,7,2,Str):-
	trap(term_str(real,LabelHeight,Str),_,fail),
	retract(lf_setup(Number,FormPage,ColorPage,Comment,LeftMarg,TopMarg,
	HorSpace,VertSpace,LabelWidth,_,NoHor,NoVert,Page_Roll,Landscape)),
	assert(lf_setup(Number,FormPage,ColorPage,Comment,LeftMarg,TopMarg,
	HorSpace,VertSpace,LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,Landscape)),!.
  ps_set_value(GridWin,1,4,_):-
	retract(lf_setup(Number,FormPage,ColorPage,Comment,LeftMarg,TopMarg,
	HorSpace,VertSpace,LabelWidth,LabelHeight,_,NoVert,b_false,b_true)),
	assert(lf_setup(Number,FormPage,ColorPage,Comment,LeftMarg,TopMarg,
	HorSpace,VertSpace,LabelWidth,LabelHeight,0,NoVert,b_false,b_true)),
	grid_Invalidate(GridWin,grid_area(1,1,4,4)),!.
  ps_set_value(_,1,4,Str):-
	trap(term_str(unsigned,NoHor,Str),_,fail),
	retract(lf_setup(Number,FormPage,ColorPage,Comment,LeftMarg,TopMarg,
	HorSpace,VertSpace,LabelWidth,LabelHeight,_,NoVert,Page_Roll,Landscape)),
	assert(lf_setup(Number,FormPage,ColorPage,Comment,LeftMarg,TopMarg,
	HorSpace,VertSpace,LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,Landscape)),!.
  ps_set_value(GridWin,2,4,_):-
	retract(lf_setup(Number,FormPage,ColorPage,Comment,LeftMarg,TopMarg,
	HorSpace,VertSpace,LabelWidth,LabelHeight,NoHor,_,b_false,b_false)),
	assert(lf_setup(Number,FormPage,ColorPage,Comment,LeftMarg,TopMarg,
	HorSpace,VertSpace,LabelWidth,LabelHeight,NoHor,0,b_false,b_false)),
	grid_Invalidate(GridWin,grid_area(2,2,4,4)),!.
  ps_set_value(_,2,4,Str):-
	trap(term_str(unsigned,NoVert,Str),_,fail),
	retract(lf_setup(Number,FormPage,ColorPage,Comment,LeftMarg,TopMarg,
	HorSpace,VertSpace,LabelWidth,LabelHeight,NoHor,_,Page_Roll,Landscape)),
	assert(lf_setup(Number,FormPage,ColorPage,Comment,LeftMarg,TopMarg,
	HorSpace,VertSpace,LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,Landscape)),!.
  ps_set_value(_,3,4,Str):-
	trap(term_str(real,LeftMarg,Str),_,fail),
	retract(lf_setup(Number,FormPage,ColorPage,Comment,_,TopMarg,
	HorSpace,VertSpace,LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,Landscape)),
	assert(lf_setup(Number,FormPage,ColorPage,Comment,LeftMarg,TopMarg,
	HorSpace,VertSpace,LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,Landscape)),!.
  ps_set_value(_,4,4,Str):-
	trap(term_str(real,TopMarg,Str),_,fail),
	retract(lf_setup(Number,FormPage,ColorPage,Comment,LeftMarg,_,
	HorSpace,VertSpace,LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,Landscape)),
	assert(lf_setup(Number,FormPage,ColorPage,Comment,LeftMarg,TopMarg,
	HorSpace,VertSpace,LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,Landscape)),!.
  ps_set_value(_,5,4,Str):-
	trap(term_str(real,HorSpace,Str),_,fail),
	retract(lf_setup(Number,FormPage,ColorPage,Comment,LeftMarg,TopMarg,
	_,VertSpace,LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,Landscape)),
	assert(lf_setup(Number,FormPage,ColorPage,Comment,LeftMarg,TopMarg,
	HorSpace,VertSpace,LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,Landscape)),!.
  ps_set_value(_,6,4,Str):-
	trap(term_str(real,VertSpace,Str),_,fail),
	retract(lf_setup(Number,FormPage,ColorPage,Comment,LeftMarg,TopMarg,
	HorSpace,_,LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,Landscape)),
	assert(lf_setup(Number,FormPage,ColorPage,Comment,LeftMarg,TopMarg,
	HorSpace,VertSpace,LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,Landscape)),!.
  ps_set_value(_,7,4,Str):-
	retract(lf_setup(Number,FormPage,ColorPage,_,LeftMarg,TopMarg,
	HorSpace,VertSpace,LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,Landscape)),
	assert(lf_setup(Number,FormPage,ColorPage,Str,LeftMarg,TopMarg,
	HorSpace,VertSpace,LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,Landscape)),!.
