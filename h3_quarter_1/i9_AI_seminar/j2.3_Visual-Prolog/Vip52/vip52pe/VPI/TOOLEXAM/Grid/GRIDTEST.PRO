/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  GRIDTEST
 FileName: GRIDTEST.PRO
 Purpose: GRID custom control test program
 Written by: Sergey A. Alexeev
 Comments:
******************************************************************************/

include "gridtest.inc"
include "gridtest.con"
include "hlptopic.con"

database - gridtest_internal_db
  determ grid_conf(GRID_STYLE,GRID_ROWSTYLE,GRID_COLUMNSTYLE)
  determ column_conf(INTEGER Index,GRID_COLUMNSTYLE)
  determ row_conf(GRID_STYLE)
  grid_window(WINDOW ParentWin,WINDOW GridWin)
  determ grid_enable
  determ grid_visible

database - grid_data_db
  g(INTEGER Row,INTEGER Column,STRING,COLOR Fg_Col,COLOR Bg_Col)
  gp(INTEGER Row,INTEGER Column,STRING)

predicates
  date_put_string  : GRID_PUT_CUSTOM_DATA
  date_get_string  : GRID_GET_CUSTOM_DATA
  time_put_string  : GRID_PUT_CUSTOM_DATA
  time_get_string  : GRID_GET_CUSTOM_DATA

clauses
  date_put_string(Win,""):-
	date_cc_SetValue(Win,0),!.
  date_put_string(Win,String):-
	dt_minstr_to_offset(String,"%DD-%MD-%YL",InitDate),
	date_cc_SetValue(Win,InitDate),!.
  date_get_string(Win,""):-
	Date = date_cc_GetValue(Win),
	Date = 0,!.
  date_get_string(Win,String):-
	Date = date_cc_GetValue(Win),
	dt_minoffset_to_str(Date,"%DD-%MD-%YL",String),!.

  time_put_string(Win,""):-
	date_cc_SetValue(Win,0),!.
  time_put_string(Win,String):-
	dt_minstr_to_offset(String,"%HH:%MM",InitTime),
	date_cc_SetValue(Win,InitTime),!.
  time_get_string(Win,""):-
	Date = date_cc_GetValue(Win),
	Date = 0,!.
  time_get_string(Win,String):-
	Time = date_cc_GetValue(Win),
	dt_minoffset_to_str(Time,"%HH:%MM",String),!.

predicates
  grid_callback : GRID_CALLBACK
  get_data(INTEGER From_Row,INTEGER To_Row,INTEGER From_Column,
	INTEGER To_Column,GRIDLIST2D,GRIDLIST2D)
  get_data1(INTEGER Row,INTEGER From_Column,INTEGER To_Column,
	GRIDLIST,GRIDLIST)
  get_data2(INTEGER Row,INTEGER Column,GRIDTEXT)
  get_data3(INTEGER Row,INTEGER Column,STRING)
  replace_data(INTEGER Row,INTEGER Column,STRING String)

clauses
  replace_data(Row,7,String):-
	String <> "",
	gp(Row,7,String),!.
  replace_data(Row,Column,String):-
	String <> "",
	g(Row,Column,String,_,_),!.

  replace_data(Row,7,String):-
	retract(gp(Row,7,_)),
	String <> "",
	assert(gp(Row,7,String)),!.
  replace_data(Row,Column,String):-
	retract(g(Row,Column,_,Color1,Color2)),
	String <> "",
	assert(g(Row,Column,String,Color1,Color2)),!.

  replace_data(Row,7,String):-
	String <> "",
	assert(gp(Row,7,String)),!.
  replace_data(Row,Column,String):-
	String <> "",
	assert(g(Row,Column,String,color_White,color_Magenta)),!.
  replace_data(_,_,_).

  get_data(From_Row,To_Row,_,_,CellList2d,CellList2d):-
	From_Row > To_Row,!.
  get_data(From_Row,To_Row,From_Column,To_Column,List2d,CellList2d):-
	get_data1(To_Row,From_Column,To_Column,[],List),
	TR = To_Row - 1,
	get_data(From_Row,TR,From_Column,To_Column,[List|List2d],CellList2d),!.

  get_data1(_,From_Column,To_Column,CellList,CellList):-
	From_Column > To_Column,!.
  get_data1(Row,From_Column,To_Column,List,CellList):-
	get_data2(Row,To_Column,Answer),
	TC = To_Column - 1,
	get_data1(Row,From_Column,TC,[Answer|List],CellList),!.

  get_data2(Row,Column,picture(Picture,b_false)):-
	gp(Row,Column,Filename),
ifndef os_os2
	concat("..\\Res\\Win\\",Filename,OutStr),
	Picture = pict_Load(OutStr),
	!.
elsedef	
	concat("..\\Res\\OS2\\",Filename,OutStr),
	Picture = pict_Load(OutStr),!.
enddef
  get_data2(Row,Column,textatr(String,Fg_Col,Bg_Col)):-
	g(Row,Column,String,Fg_Col,Bg_Col),!.
  get_data2(_,_,empty_answer).

  get_data3(Row,Column,Filename):-
	gp(Row,Column,Filename),!.
  get_data3(Row,Column,String):-
	g(Row,Column,String,_,_),!.
  get_data3(_,_,"").

  % --- USER ACTION ---
%  grid_callback(_Win,user_action(grid_area_marker_beg(10,_)),event_answer(stop)):-!.

%  grid_callback(GridWin,event(e_MouseDown(pnt(X,Y),_ShiftCtlAlt,_Button)),event_answer(stop)):-
%	grid_get_pos(GridWin,X,Y,Row,Column),
%	Row <> 0, Column <> 0,
%	grid_Marker(GridWin,grid_edit_cell(Row,Column)),!.
%  grid_callback(GridWin,user_action(grid_area_marker_beg(Row,Column)),event_answer(stop)):-
%	grid_Marker(GridWin,grid_edit_cell(Row,Column)),!.


  grid_callback(_Win,user_action(Action),event_answer(continue)):-
	term_str(grid_user_action,Action,ActionStr),
	writef("Grid callback: %\n",ActionStr),fail.
  grid_callback(_Win,
		 user_action(grid_marker(grid_edit_cell(_Row,1),b_true)),
		 event_answer(continue)):-!.
  grid_callback(_Win,
		 user_action(grid_marker(grid_edit_cell(Row,2),b_true)),
		 event_answer(editCtrl(InitString))):-
	get_data3(Row,2,InitString),!.
  grid_callback(_Win,
		 user_action(grid_marker(grid_edit_cell(Row,3),b_true)),
		 event_answer(custom_ctrl("date",[],date_put_string,date_get_string,InitString))):-
	get_data3(Row,3,InitString),!.
  grid_callback(_Win,
		 user_action(grid_marker(grid_edit_cell(Row,4),b_true)),
		 event_answer(custom_ctrl("time",[],time_put_string,time_get_string,InitString))):-
	get_data3(Row,4,InitString),!.
  grid_callback(_Win,
		 user_action(grid_marker(grid_edit_cell(Row,5),b_true)),
		 event_answer(lBoxEdit(["New York","London","Moscow","Copenhagen"],InitString))):-
	get_data3(Row,5,InitString),!.
  grid_callback(_Win,
		 user_action(grid_marker(grid_edit_cell(Row,6),b_true)),
		 event_answer(lBoxButton(["USA","United Kingdom","Russia","Denmark"],InitString))):-
	get_data3(Row,6,InitString),!.
  grid_callback(_Win,
		 user_action(grid_marker(grid_edit_cell(Row,7),b_true)),
		 event_answer(lBoxButton(["COPY.BMP","CUT.BMP","PASTE.BMP",
		 "REDO.BMP","UNDO.BMP"],InitString))):-
	get_data3(Row,7,InitString),!.
%  grid_callback(_,user_action(modified(_,1,_)),event_answer(stop)):-!.
  grid_callback(_Win,
		 user_action(modified(Row,Column,String)),
		 event_answer(continue)):-
	replace_data(Row,Column,String).

  grid_callback(Win,event(e_MouseDbl(pnt(X,Y),_,mouse_button_left)),
		 event_answer(continue)):-
	grid_get_pos(Win,X,Y,Row,Column),
	Row = 0, Column = 0,!,
	dlg_grid_style_Create(Win).
  grid_callback(Win,event(e_MouseDbl(pnt(X,Y),_,mouse_button_left)),
		 event_answer(continue)):-
	grid_get_pos(Win,X,Y,Row,Column),
	Row = 0,!,
	dlg_grid_column_style_Create(Win,Column).
  grid_callback(Win,event(e_MouseDbl(pnt(X,Y),_,mouse_button_left)),
		 event_answer(continue)):-
	grid_get_pos(Win,X,Y,_,Column),
	Column = 0,
	dlg_grid_row_style_Create(Win),!.

  % --- DATA REQUEST ---
  grid_callback(_Win,data_request(Area),data_answer(empty_answer)):-
	term_str(grid_data_area,Area,AreaStr),
	writef("Grid callback: %\n",AreaStr),fail.
  grid_callback(_Win,data_request(grid_area(From_Row,To_Row,From_Column,To_Column)),
				data_answer(grid_area_answer(CellList))):-
	get_data(From_Row,To_Row,From_Column,To_Column,[],CellList),!.

predicates
  grid_handler : EHANDLER

clauses
  grid_handler(GridWin,e_Create(_),0):-!,
	grid_conf(GridStyle,RowStyle,ColumnStyle),
	grid_Init(GridWin,GridStyle,RowStyle,ColumnStyle,grid_callback),
	grid_VisitOrder(GridWin,90,c_Alt,grid_right).
  grid_handler(GridWin,EVENT,0):-
  	grid_HandleEvent(GridWin,EVENT).

predicates
  date_handler : EHANDLER

clauses
  date_handler(Win,e_Create(_),0):-
	date_cc_Init(Win,0,"%DD-%MD-%YL"),!.
  date_handler(Win,EVENT,0):-
	date_cc_HandleEvent(Win,EVENT),!.

predicates
  time_handler : EHANDLER

clauses
  time_handler(Win,e_Create(_),0):-
	date_cc_Init(Win,0,"%HH:%MM"),!.
  time_handler(Win,EVENT,0):-
	date_cc_HandleEvent(Win,EVENT),!.

predicates
  change_style(GRID_STYLE)
  DIALOG_CONTROL_ID style_get(GRID_CELLS_STYLE)
  GRID_CELLS_STYLE get_style(DIALOG_VAL_LIST)

clauses
  change_style(GridStyle):-
	Win = win_GetActiveWindow(),
	grid_window(Win,GridWin),
	grid_Style(GridWin,GridStyle),!.
  change_style(GridStyle):-
	free(GridStyle),
	grid_conf(GridStyle,_,_),!.
  change_style(GridStyle):-
	bound(GridStyle),!.

  get_style(Vallist,grid_raised):-
	Check = dialog_VLGetRadiobutton(idc_raised,Vallist),
	Check = idc_raised,!.
  get_style(Vallist,grid_plain):-
	Check = dialog_VLGetRadiobutton(idc_raised,Vallist),
	Check = idc_plain,!.
  get_style(_,grid_raisedplain).

  style_get(grid_raised,idc_raised):-!.
  style_get(_,idc_plain).

predicates
  change_rowstyle(GRID_ROWSTYLE)
  DIALOG_CONTROL_ID number_get(GRID_ROW_SELECTOR)
  DIALOG_CONTROL_ID pointer_get(BOOLEAN)
  GRID_ROW_SELECTOR get_number(DIALOG_VAL_LIST)
  BOOLEAN get_pointer(DIALOG_VAL_LIST)

clauses
  change_rowstyle(GridRowStyle):-
	Win = win_GetActiveWindow(),
	grid_window(Win,GridWin),
	grid_RowStyle(GridWin,GridRowStyle),!.
  change_rowstyle(GridRowStyle):-
	free(GridRowStyle),
	grid_conf(_,GridRowStyle,_),!.
  change_rowstyle(GridRowStyle):-
	bound(GridRowStyle),!.

  number_get(grid_number,idc_grid_number):-!.
  number_get(_,idc_grid_nothing).

  pointer_get(b_true,idc_grid_true):-!.
  pointer_get(_,idc_grid_false).

  get_number(Vallist,grid_number):-
	Check = dialog_VLGetRadiobutton(idc_grid_number,Vallist),
	Check = idc_grid_number,!.
  get_number(_,grid_nothing).

  get_pointer(Vallist,b_true):-
	Check = dialog_VLGetRadiobutton(idc_grid_true,Vallist),
	Check = idc_grid_true,!.
  get_pointer(_,b_false).

predicates
  determ get_horalignment(GRID_HORALIGNMENT,DIALOG_CONTROL_ID)
  determ get_veralignment(GRID_VERALIGNMENT,DIALOG_CONTROL_ID)

clauses
  get_horalignment(grid_left_align,idc_left_align):-!.
  get_horalignment(grid_right_align,idc_right_align):-!.
  get_horalignment(grid_center,idc_center1).

  get_veralignment(grid_top_align,idc_top_align):-!.
  get_veralignment(grid_bottom_align,idc_bottom_align):-!.
  get_veralignment(grid_center,idc_center2).

predicates
  str_int_my(STRING,INTEGER Default,INTEGER)

clauses
  str_int_my(Str,_,Int):-
	str_int(Str,Int),!.
  str_int_my(_,Def,Def).

predicates
  load_column_data(WINDOW)
  save_column_data(WINDOW)
  change_columnstyle(GRID_COLUMNSTYLE)
  procedure load_column_data1(WINDOW,INTEGER,GRID_COLUMN_LIST)
  nondeterm save_column_data1(WINDOW,INTEGER,GRID_COLUMN_LIST,GRID_COLUMN_LIST)

clauses
  change_columnstyle(GridColumnStyle):-
	Win = win_GetActiveWindow(),
	grid_window(Win,GridWin),
	grid_ColumnStyle(GridWin,GridColumnStyle),!.
  change_columnstyle(GridColumnStyle):-
	free(GridColumnStyle),
	grid_conf(_,_,GridColumnStyle),!.
  change_columnstyle(GridColumnStyle):-
	bound(GridColumnStyle),!.

  load_column_data(Win):-
	column_conf(_,grid_columnstyle(NonScrolColumns,ColumnList)),
	Ctrl = win_GetCtlHandle(Win,idc_num_column),
	lbox_GetSel(Ctrl,_,IndexList),
	IndexList = [Num],
	Ctrl1 = win_GetCtlHandle(Win,idc_grid_nonscroll),
	str_int(NonScrolColumnsS,NonScrolColumns),
	win_SetText(Ctrl1,NonScrolColumnsS),
	load_column_data1(Win,Num,ColumnList),!.
  load_column_data(_).

  save_column_data(Win):-
	retract(column_conf(Index,grid_columnstyle(_,ColumnList))),
	Ctrl = win_GetCtlHandle(Win,idc_num_column),
	lbox_GetSel(Ctrl,_,IndexList),
	IndexList = [Num],
	Ctrl1 = win_GetCtlHandle(Win,idc_grid_nonscroll),
	NonScrolColumnsS = win_GetText(Ctrl1),
	str_int(NonScrolColumnsS,NonScrolColumns),
	save_column_data1(Win,Num,ColumnList,NewColumnList),
	assert(column_conf(Index,grid_columnstyle(NonScrolColumns,NewColumnList))),!.
  save_column_data(_).

  load_column_data1(Win,0,[grid_col(Title,ColumnWidthInPixels,
		HorAlignment,VerAlignment,DX,DY,MaxTextLengthInChars)|_]):-
	Ctrl1 = win_GetCtlHandle(Win,idc_title),
	win_SetText(Ctrl1,Title),
	Ctrl2 = win_GetCtlHandle(Win,idc_width),
	str_int(ColumnWidthInPixelsStr,ColumnWidthInPixels),
	win_SetText(Ctrl2,ColumnWidthInPixelsStr),
	get_horalignment(HorAlignment,DefHorAlignment),
	dialog_SetRadiobutton(Win,idc_left_align,DefHorAlignment),
	get_veralignment(VerAlignment,DefVerAlignment),
	dialog_SetRadiobutton(Win,idc_top_align,DefVerAlignment),
	Ctrl5 = win_GetCtlHandle(Win,idc_dx),
	str_int(DXStr,DX),
	win_SetText(Ctrl5,DXStr),
	Ctrl6 = win_GetCtlHandle(Win,idc_dy),
	str_int(DYStr,DY),
	win_SetText(Ctrl6,DYStr),
	Ctrl7 = win_GetCtlHandle(Win,idc_textlength),
	str_int(MaxTextLengthInCharsStr,MaxTextLengthInChars),
	win_SetText(Ctrl7,MaxTextLengthInCharsStr),!.
  load_column_data1(Win,Num,[_|Rest]):-
	N = Num - 1,!,
	load_column_data1(Win,N,Rest).
  load_column_data1(_,_,_):-errorexit().

  save_column_data1(Win,0,[grid_col(_,OldColumnWidthInPixels,_,_,OldDX,OldDY,
		OldMaxTextLengthInChars)|Rest],[grid_col(Title,ColumnWidthInPixels,
		HorAlignment,VerAlignment,DX,DY,MaxTextLengthInChars)|Rest]):-
	Ctrl1 = win_GetCtlHandle(Win,idc_title),
	Title = win_GetText(Ctrl1),
	Ctrl2 = win_GetCtlHandle(Win,idc_width),
	ColumnWidthInPixelsStr = win_GetText(Ctrl2),
	str_int_my(ColumnWidthInPixelsStr,OldColumnWidthInPixels,ColumnWidthInPixels),
	DefHorAlignment = dialog_GetRadiobutton(Win,idc_left_align),
	get_horalignment(HorAlignment,DefHorAlignment),
	DefVerAlignment = dialog_GetRadiobutton(Win,idc_top_align),
	get_veralignment(VerAlignment,DefVerAlignment),
	Ctrl5 = win_GetCtlHandle(Win,idc_dx),
	DXStr = win_GetText(Ctrl5),
	str_int_my(DXStr,OldDX,DX),
	Ctrl6 = win_GetCtlHandle(Win,idc_dy),
	DYStr = win_GetText(Ctrl6),
	str_int_my(DYStr,OldDY,DY),
	Ctrl7 = win_GetCtlHandle(Win,idc_textlength),
	MaxTextLengthInCharsStr = win_GetText(Ctrl7),
	str_int_my(MaxTextLengthInCharsStr,OldMaxTextLengthInChars,MaxTextLengthInChars),!.
  save_column_data1(Win,Num,[Head|Rest],[Head|List1]):-
	N = Num - 1,
	save_column_data1(Win,N,Rest,List1).


%BEGIN_WIN Task Window
/***************************************************************************
	Event handling for Task Window
***************************************************************************/

predicates

  task_win_eh : EHANDLER

constants

%BEGIN Task Window, CreateParms, 12:33:04-24.11.1999, Code automatically updated!
  task_win_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Close,wsf_Maximize,wsf_Minimize,wsf_ClipSiblings]
  task_win_Menu  = res_menu(idr_task_menu)
  task_win_Title = "Grid test application"
  task_win_Help  = idh_contents
%END Task Window, CreateParms

clauses

%BEGIN Task Window, e_Create
  task_win_eh(_Win,e_Create(_),0):-!,
%BEGIN Task Window, InitControls, 12:33:04-24.11.1999, Code automatically updated!
%END Task Window, InitControls
%BEGIN Task Window, ToolbarCreate, 12:33:04-24.11.1999, Code automatically updated!
	tb_project_toolbar_Create(_Win),
	tb_help_line_Create(_Win),
%END Task Window, ToolbarCreate
ifdef use_message
	msg_Create(100),
enddef
	assert(grid_conf(grid_style(grid_raised,color_LtGray,color_LtGray,color_LtGray,color_LtGray,color_Blue),
		grid_rowstyle(50,100,1,grid_number,b_false),
		grid_columnstyle(0,[grid_col("First name",100,grid_left_align,grid_center,5,0,100),
				grid_col("Last name",100,grid_left_align,grid_center,5,0,100),
				grid_col("Date",140,grid_right_align,grid_center,5,0,100),
				grid_col("Time",100,grid_right_align,grid_center,5,0,100),
				grid_col("City",140,grid_left_align,grid_center,5,0,100),
				grid_col("Country",150,grid_left_align,grid_center,5,0,100),
				grid_col("Photo",100,grid_left_align,grid_top_align,0,0,0)
				]))),

	assert(grid_enable),
	assert(grid_visible),

	class_Create("grid",grid_handler),
	class_Create("date",date_handler),
	class_Create("time",time_handler),
ifndef os_os2
	trap(consult("GRIDTEST.DBA",grid_data_db),_,dlg_note("Error loading GRIDTEST.DBA")),
	write("Database GRIDTEST.DBA has been loaded.\n"),
elsedef
	trap(consult("GRIDTOS2.DBA",grid_data_db),_,dlg_note("Error loading GRIDTOS2.DBA")),
	write("Database GRIDTOS2.DBA has been loaded.\n"),
enddef
	!.
%END Task Window, e_Create

%MARK Task Window, new events

%BEGIN Task Window, id_grid_column_style
  task_win_eh(_Win,e_Menu(id_grid_column_style,_ShiftCtlAlt),0):-!,
	dlg_grid_column_style_Create(_Win,1),
	!.
%END Task Window, id_grid_column_style

%BEGIN Task Window, id_grid_row_style
  task_win_eh(_Win,e_Menu(id_grid_row_style,_ShiftCtlAlt),0):-!,
	dlg_grid_row_style_Create(_Win),
	!.
%END Task Window, id_grid_row_style

%BEGIN Task Window, id_grid_style
  task_win_eh(_Win,e_Menu(id_grid_style,_ShiftCtlAlt),0):-!,
	dlg_grid_style_Create(_Win),
	!.
%END Task Window, id_grid_style

%BEGIN Task Window, id_create
  task_win_eh(_Win,e_Menu(id_create,_ShiftCtlAlt),0):-!,
	win_grid_window_Create(_Win),
	!.
%END Task Window, id_create

%BEGIN Task Window, id_visible
  task_win_eh(_Win,e_Menu(id_visible,_ShiftCtlAlt),0):-
	Parent = win_GetActiveWindow(),
	grid_window(Parent,GridWin),
	retract(grid_visible),
	menu_Check(_Win,id_visible,b_false),
	win_SetState(GridWin,[wsf_Invisible]),
	!.
  task_win_eh(_Win,e_Menu(id_visible,_),0):-
	Parent = win_GetActiveWindow(),
	grid_window(Parent,GridWin),
	assert(grid_visible),
	menu_Check(_Win,id_visible,b_true),
	win_SetState(GridWin,[wsf_Visible]),
	!.
%END Task Window, id_visible

%BEGIN Task Window, id_enabled
  task_win_eh(_Win,e_Menu(id_enabled,_ShiftCtlAlt),0):-
	Parent = win_GetActiveWindow(),
	grid_window(Parent,GridWin),
	retract(grid_enable),
	menu_Check(_Win,id_enabled,b_false),
	win_SetState(GridWin,[wsf_Disabled]),
	!.
  task_win_eh(_Win,e_Menu(id_enabled,_),0):-
	Parent = win_GetActiveWindow(),
	grid_window(Parent,GridWin),
	assert(grid_enable),
	menu_Check(_Win,id_enabled,b_true),
	win_SetState(GridWin,[wsf_Enabled]),
	!.
%END Task Window, id_enabled

%BEGIN Task Window, id_set_font
  task_win_eh(_Win,e_Menu(id_set_font,_ShiftCtlAlt),0):-!,
	Parent = win_GetActiveWindow(),
	grid_window(Parent,GridWin),
	OldFont = win_GetFont(GridWin),
	NewFont = dlg_ChooseFont(OldFont),
	win_SetFont(GridWin,NewFont),
	!.
%END Task Window, id_set_font

%BEGIN Task Window, e_Destroy
  task_win_eh(_Win,e_Destroy,0):-!,
ifdef os_os2
	trap(save("GRIDTOS2.DBA",grid_data_db),_,dlg_note("Error saving GRIDTEST.DBA")),
elsedef
	trap(save("GRIDTEST.DBA",grid_data_db),_,dlg_note("Error saving GRIDTEST.DBA")),
enddef
	class_Destroy("time"),
	class_Destroy("date"),
	class_Destroy("grid"),
	!.
%END Task Window, e_Destroy

%BEGIN Task Window, id_help_contents
  task_win_eh(_Win,e_Menu(id_help_contents,_ShiftCtlAlt),0):-!,
  	vpi_ShowHelp("gridtest.hlp"),
	!.
%END Task Window, id_help_contents

%BEGIN Task Window, id_help_about
  task_win_eh(Win,e_Menu(id_help_about,_ShiftCtlAlt),0):-!,
	dlg_about_dialog_Create(Win),
	!.
%END Task Window, id_help_about

%BEGIN Task Window, id_file_exit
  task_win_eh(Win,e_Menu(id_exit,_ShiftCtlAlt),0):-!,
  	win_Destroy(Win),
	!.
%END Task Window, id_file_exit

%BEGIN Task Window, e_Size
  task_win_eh(_Win,e_Size(_Width,_Height),0):-!,
ifdef use_tbar
	toolbar_Resize(_Win),
enddef
ifdef use_message
	msg_Resize(_Win),
enddef
	!.
%END Task Window, e_Size

%END_WIN Task Window

/***************************************************************************
	Invoking on-line Help
***************************************************************************/

  project_ShowHelpContext(HelpTopic):-
  	vpi_ShowHelpContext("gridtest.hlp",HelpTopic).

/***************************************************************************
	Main Goal
***************************************************************************/

GOAL

ifdef use_mdi
  vpi_SetAttrVal(attr_win_mdi,b_true),
enddef
ifdef ws_win
  ifdef use_3dctrl
    vpi_SetAttrVal(attr_win_3dcontrols,b_true),
  enddef
enddef  
  vpi_Init(task_win_Flags,task_win_eh,task_win_Menu,"gridtest",task_win_Title).

%BEGIN_TLB Project toolbar, 12:33:22-24.11.1999, Code automatically updated!
/**************************************************************************
	Creation of toolbar: Project toolbar
**************************************************************************/

clauses

  tb_project_toolbar_Create(_Parent):-
ifdef use_tbar
	toolbar_create(tb_top,0xC0C0C0,_Parent,
		[tb_ctrl(id_create,pushb,idb_new_up,idb_new_dn,idb_new_up,"New;New file",1,1),
		 tb_ctrl(id_file_open,pushb,idb_open_up,idb_open_dn,idb_open_up,"Open;Open file",1,1),
		 tb_ctrl(id_file_save,pushb,idb_save_up,idb_save_dn,idb_save_up,"Save;File save",1,1),
		 separator,
		 tb_ctrl(id_edit_undo,pushb,idb_undo_up,idb_undo_dn,idb_undo_up,"Undo;Undo",1,1),
		 tb_ctrl(id_edit_redo,pushb,idb_redo_up,idb_redo_dn,idb_redo_up,"Redo;Redo",1,1),
		 separator,
		 tb_ctrl(id_edit_cut,pushb,idb_cut_up,idb_cut_dn,idb_cut_up,"Cut;Cut to clipboard",1,1),
		 tb_ctrl(id_edit_copy,pushb,idb_copy_up,idb_copy_dn,idb_copy_up,"Copy;Copy to clipboard",1,1),
		 tb_ctrl(id_edit_paste,pushb,idb_paste_up,idb_paste_dn,idb_paste_up,"Paste;Paste from clipboard",1,1),
		 separator,
		 separator,
		 tb_ctrl(id_help_contents,pushb,idb_help_up,idb_help_down,idb_help_up,"Help;Help",0,1)]),
enddef
	true.
%END_TLB Project toolbar










%BEGIN_TLB Help line, 12:33:30-24.11.1999, Code automatically updated!
/**************************************************************************
	Creation of toolbar: Help line
**************************************************************************/

clauses

  tb_help_line_Create(_Parent):-
ifdef use_tbar
	toolbar_create(tb_bottom,0xC0C0C0,_Parent,
		[tb_text(idt_help_line,tb_context,452,0,4,10,0x0,"")]),
enddef
	true.
%END_TLB Help line


%BEGIN_DLG About dialog
/**************************************************************************
	Creation and event handling for dialog: About dialog
**************************************************************************/

constants

%BEGIN About dialog, CreateParms, 11:03:48-11.1.2000, Code automatically updated!
  dlg_about_dialog_ResID = idd_dlg_about
  dlg_about_dialog_DlgType = wd_Modal
  dlg_about_dialog_Help = idh_contents
%END About dialog, CreateParms

predicates

  dlg_about_dialog_eh : EHANDLER

clauses

  dlg_about_dialog_Create(Parent):-
	win_CreateResDialog(Parent,dlg_about_dialog_DlgType,dlg_about_dialog_ResID,dlg_about_dialog_eh,0).

%BEGIN About dialog, idc_ok _CtlInfo
  dlg_about_dialog_eh(_Win,e_Control(idc_ok,_CtrlType,_CtrlWin,_CtrlInfo),0):-!,
	win_Destroy(_Win),
	!.
%END About dialog, idc_ok _CtlInfo
%MARK About dialog, new events

  dlg_about_dialog_eh(_,_,_):-!,fail.

%END_DLG About dialog

%BEGIN_WIN Grid Window
/**************************************************************************
        Creation and event handling for window: Grid Window
**************************************************************************/

constants
%BEGIN Grid Window, CreateParms, 12:32:58-24.11.1999, Code automatically updated!
  win_grid_window_WinType = w_TopLevel
  win_grid_window_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Maximize,wsf_Minimize,wsf_Close,wsf_ClipSiblings,wsf_ClipChildren]
  win_grid_window_RCT = rct(50,50,850,550)
  win_grid_window_Menu = no_menu
  win_grid_window_Title = "Grid Window"
  win_grid_window_Help = idh_contents
%END Grid Window, CreateParms

predicates

  win_grid_window_eh : EHANDLER

clauses

  win_grid_window_Create(_Parent):-
	win_Create(win_grid_window_WinType,win_grid_window_RCT,win_grid_window_Title,
		   win_grid_window_Menu,_Parent,win_grid_window_Flags,win_grid_window_eh,0).

%BEGIN Grid Window, e_Create
  win_grid_window_eh(_Win,e_Create(_),0):-!,
%BEGIN Grid Window, InitControls, 12:32:58-24.11.1999, Code automatically updated!
%END Grid Window, InitControls
%BEGIN Grid Window, ToolbarCreate, 12:32:58-24.11.1999, Code automatically updated!
%END Grid Window, ToolbarCreate
	 GridWin = win_CreateDynControl([
	 	customctl(wdef(wc_Custom,rct(10,10,730,430),"",u_Pixels),
			"grid",777,[ctl_Group,ctl_TabStop])],_Win),
	assert(grid_window(_Win,GridWin)),
	!.
%END Grid Window, e_Create
%MARK Grid Window, new events

%BEGIN Grid Window, e_GetFocus
  win_grid_window_eh(_Win,e_GetFocus,0):-
	grid_window(_Win,GridWin),
	trap(win_SetFocus(GridWin),_,fail),
	!.
  win_grid_window_eh(_Win,e_GetFocus,0):-!.
%END Grid Window, e_GetFocus


%BEGIN Grid Window, e_Destroy
  win_grid_window_eh(_Win,e_Destroy,0):-!,
	retract(grid_window(_Win,_)),!,
	fail.
%END Grid Window, e_Destroy

%BEGIN Grid Window, e_Update
  win_grid_window_eh(_Win,e_Update(_UpdateRct),0):-!,
	win_Clear(_Win,color_Gray),
	!.
%END Grid Window, e_Update

%BEGIN Grid Window, e_Size
  win_grid_window_eh(_Win,e_Size(Width,Height),0):-!,
ifdef use_tbar
	toolbar_Resize(_Win),
enddef
	GridWin = win_GetCtlHandle(_Win,777),
	R = Width - 20,B = Height - 20,
	win_Move(GridWin,rct(10,10,R,B)),
	!.
%END Grid Window, e_Size

%BEGIN Grid Window, e_Menu, Parent window 
  win_grid_window_eh(Win,e_Menu(ID,CAS),0):-!,
	PARENT = win_GetParent(Win),
	win_SendEvent(PARENT,e_Menu(ID,CAS)),
	!.
%END Grid Window, e_Menu, Parent window

%END_WIN Grid Window


%BEGIN_DLG Grid style
/**************************************************************************
	Creation and event handling for dialog: Grid style
**************************************************************************/

constants

%BEGIN Grid style, CreateParms, 12:31:52-24.11.1999, Code automatically updated!
  dlg_grid_style_ResID = idd_grid_style
  dlg_grid_style_DlgType = wd_Modal
  dlg_grid_style_Help = idh_contents
%END Grid style, CreateParms

predicates

  dlg_grid_style_eh : EHANDLER
  dlg_grid_style_handle_answer(INTEGER EndButton,DIALOG_VAL_LIST)
  dlg_grid_style_update(DIALOG_VAL_LIST)

clauses

  dlg_grid_style_Create(Parent):-

	change_style(GridStyle),
	retractall(row_conf(_)),
	assert(row_conf(GridStyle)),
	GridStyle = grid_style(CellStyle,_,_,_,_,_),
	DefCellStyle = style_get(CellStyle),
%MARK Grid style, new variables

	dialog_CreateModal(Parent,dlg_grid_style_ResID,"",
  		[
%BEGIN Grid style, ControlList, 12:31:52-24.11.1999, Code automatically updated!,
		df(DEFCELLSTYLE,radiobuttongroup([idc_raised,idc_plain,idc_raisedplain]),nopr)
%END Grid style, ControlList
		],
		dlg_grid_style_eh,0,VALLIST,ANSWER),
	dlg_grid_style_handle_answer(ANSWER,VALLIST).

  dlg_grid_style_handle_answer(idc_ok,VALLIST):-!,
	dlg_grid_style_update(VALLIST).
  dlg_grid_style_handle_answer(idc_cancel,_):-!.  % Handle Esc and Cancel here
  dlg_grid_style_handle_answer(_,_):-
	errorexit().

  dlg_grid_style_update(_VALLIST):-
%BEGIN Grid style, Update controls, 12:31:52-24.11.1999, Code automatically updated!
	_DEFCELLSTYLE = dialog_VLGetRadiobutton(idc_raised,_VALLIST),
%END Grid style, Update controls

	NewCellStyle = get_style(_Vallist),
	retract(grid_conf(_,RowStyle,ColumnStyle)),
	row_conf(grid_style(_,DefaultCellColor,BackGroundColor,EmptyCellColor,
		BackGroundTitleColor,ForeGroundTitleColor)),!,
	assert(grid_conf(grid_style(NewCellStyle,DefaultCellColor,BackGroundColor,EmptyCellColor,
		BackGroundTitleColor,ForeGroundTitleColor),RowStyle,ColumnStyle)),
	change_style(grid_style(NewCellStyle,DefaultCellColor,BackGroundColor,EmptyCellColor,
		BackGroundTitleColor,ForeGroundTitleColor)),
	true.
  dlg_grid_style_update(_).

%MARK Grid style, new events

%BEGIN Grid style, idc_color5 _CtlInfo
  dlg_grid_style_eh(_Win,e_Control(idc_color5,_CtrlType,_CtrlWin,activated()),0):-!,
	row_conf(grid_style(_,DefaultCellColor,_,_,_,_)),
	NewDefaultCellColor = dlg_ChooseColor(DefaultCellColor),
	retract(row_conf(grid_style(CellStyle,_,BackGroundColor,EmptyCellColor,
		BackGroundTitleColor,ForeGroundTitleColor))),
	assert(row_conf(grid_style(CellStyle,NewDefaultCellColor,BackGroundColor,EmptyCellColor,
		BackGroundTitleColor,ForeGroundTitleColor))),
	!.
%END Grid style, idc_color5 _CtlInfo

%BEGIN Grid style, idc_color4 _CtlInfo
  dlg_grid_style_eh(_Win,e_Control(idc_color4,_CtrlType,_CtrlWin,activated()),0):-!,
	row_conf(grid_style(_,_,_,_,_,ForeGroundTitleColor)),
	NewForeGroundTitleColor = dlg_ChooseColor(ForeGroundTitleColor),
	retract(row_conf(grid_style(CellStyle,Font,BackGroundColor,EmptyCellColor,
		BackGroundTitleColor,_))),
	assert(row_conf(grid_style(CellStyle,Font,BackGroundColor,EmptyCellColor,
		BackGroundTitleColor,NewForeGroundTitleColor))),
	!.
%END Grid style, idc_color4 _CtlInfo

%BEGIN Grid style, idc_color3 _CtlInfo
  dlg_grid_style_eh(_Win,e_Control(idc_color3,_CtrlType,_CtrlWin,activated()),0):-!,
	row_conf(grid_style(_,_,_,_,BackGroundTitleColor,_)),
	NewBackGroundTitleColor = dlg_ChooseColor(BackGroundTitleColor),
	retract(row_conf(grid_style(CellStyle,Font,BackGroundColor,EmptyCellColor,
		_,ForeGroundTitleColor))),
	assert(row_conf(grid_style(CellStyle,Font,BackGroundColor,EmptyCellColor,
		NewBackGroundTitleColor,ForeGroundTitleColor))),
	!.
%END Grid style, idc_color3 _CtlInfo

%BEGIN Grid style, idc_color2 _CtlInfo
  dlg_grid_style_eh(_Win,e_Control(idc_color2,_CtrlType,_CtrlWin,activated()),0):-!,
	row_conf(grid_style(_,_,_,EmptyCellColor,_,_)),
	NewEmptyCellColor = dlg_ChooseColor(EmptyCellColor),
	retract(row_conf(grid_style(CellStyle,Font,BackGroundColor,_,
		BackGroundTitleColor,ForeGroundTitleColor))),
	assert(row_conf(grid_style(CellStyle,Font,BackGroundColor,NewEmptyCellColor,
		BackGroundTitleColor,ForeGroundTitleColor))),
	!.
%END Grid style, idc_color2 _CtlInfo

%BEGIN Grid style, idc_color1 _CtlInfo
  dlg_grid_style_eh(_Win,e_Control(idc_color1,_CtrlType,_CtrlWin,activated()),0):-!,
	row_conf(grid_style(_,_,BackGroundColor,_,_,_)),
	NewBackGroundColor = dlg_ChooseColor(BackGroundColor),
	retract(row_conf(grid_style(CellStyle,Font,_,EmptyCellColor,
		BackGroundTitleColor,ForeGroundTitleColor))),
	assert(row_conf(grid_style(CellStyle,Font,NewBackGroundColor,EmptyCellColor,
		BackGroundTitleColor,ForeGroundTitleColor))),
	!.
%END Grid style, idc_color1 _CtlInfo

  dlg_grid_style_eh(_,_,_):-!,fail.

%END_DLG Grid style



%BEGIN_DLG Grid column style
/**************************************************************************
	Creation and event handling for dialog: Grid column style
**************************************************************************/

constants

%BEGIN Grid column style, CreateParms, 12:32:32-24.11.1999, Code automatically updated!
  dlg_grid_column_style_ResID = idd_grid_column_style
  dlg_grid_column_style_DlgType = wd_Modal
  dlg_grid_column_style_Help = idh_contents
%END Grid column style, CreateParms

predicates

  dlg_grid_column_style_eh : EHANDLER
  dlg_grid_column_style_handle_answer(INTEGER EndButton,DIALOG_VAL_LIST)
  dlg_grid_column_style_update(DIALOG_VAL_LIST)

clauses

  dlg_grid_column_style_Create(Parent,Index):-
	change_columnstyle(ColumnStyle),
	retractall(column_conf(_,_)),
	Ind = Index - 1,
	assert(column_conf(Ind,ColumnStyle)),

%MARK Grid column style, new variables

	dialog_CreateModal(Parent,dlg_grid_column_style_ResID,"",
  		[
%BEGIN Grid column style, ControlList, 12:32:32-24.11.1999, Code automatically updated!
		df(idc_title,editstr("",[]),nopr),
		df(idc_width,editstr("",[]),nopr),
		df(idc_dx,editstr("",[]),nopr),
		df(idc_dy,editstr("",[]),nopr),
		df(idc_textlength,editstr("",[]),nopr),
		df(idc_num_column,listbutton(["Column1","Column2","Column3","Column4","Column5","Column6","Column7"],0),nopr),
		df(idc_grid_nonscroll,editint(i(0),[mandatory]),nopr),
		df(idc_left_align,radiobuttongroup([idc_left_align,idc_right_align,idc_center1]),nopr),
		df(idc_top_align,radiobuttongroup([idc_top_align,idc_bottom_align,idc_center2]),nopr)
%END Grid column style, ControlList
		],
		dlg_grid_column_style_eh,0,VALLIST,ANSWER),
	dlg_grid_column_style_handle_answer(ANSWER,VALLIST).

  dlg_grid_column_style_handle_answer(idc_ok,VALLIST):-!,
	dlg_grid_column_style_update(VALLIST).
  dlg_grid_column_style_handle_answer(idc_cancel,_):-!.  % Handle Esc and Cancel here
  dlg_grid_column_style_handle_answer(_,_):-
	errorexit().

  dlg_grid_column_style_update(_VALLIST):-
%BEGIN Grid column style, Update controls, 12:32:32-24.11.1999, Code automatically updated!
	_IDC_TITLE_VALUE = dialog_VLGetstr(idc_title,_VALLIST),
	_IDC_WIDTH_VALUE = dialog_VLGetstr(idc_width,_VALLIST),
	_IDC_DX_VALUE = dialog_VLGetstr(idc_dx,_VALLIST),
	_IDC_DY_VALUE = dialog_VLGetstr(idc_dy,_VALLIST),
	_IDC_TEXTLENGTH_VALUE = dialog_VLGetstr(idc_textlength,_VALLIST),
	dialog_VLGetListButton(idc_num_column,_VALLIST,_IDC_NUM_COLUMN_ITEMLIST,_IDC_NUM_COLUMN_SELECT),
	_IDC_GRID_NONSCROLL_VALUE = dialog_VLGetint(idc_grid_nonscroll,_VALLIST),
	_IDC_LEFT_ALIGN = dialog_VLGetRadiobutton(idc_left_align,_VALLIST),
	_IDC_TOP_ALIGN = dialog_VLGetRadiobutton(idc_top_align,_VALLIST),
%END Grid column style, Update controls
	column_conf(_,NewColumnStyle),
	retract(grid_conf(GridStyle,RowStyle,_)),!,
	assert(grid_conf(GridStyle,RowStyle,NewColumnStyle)),
	change_columnstyle(NewColumnStyle),
	true.
  dlg_grid_column_style_update(_).

%MARK Grid column style, new events

%BEGIN Grid column style, idc_num_column selchanged
  dlg_grid_column_style_eh(_Win,e_Control(idc_num_column,_CtrlType,_CtrlWin,selchanged),0):-!,
	load_column_data(_Win),!,fail.
%END Grid column style, idc_num_column selchanged

%BEGIN Grid column style, idc_num_column dropdown
  dlg_grid_column_style_eh(_Win,e_Control(idc_num_column,_CtrlType,_CtrlWin,dropdown),0):-!,
	save_column_data(_Win),!,fail.
%END Grid column style, idc_num_column dropdown

%BEGIN Grid column style, idc_ok _CtlInfo
  dlg_grid_column_style_eh(_Win,e_Control(idc_ok,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	save_column_data(_Win),!,fail.
%END Grid column style, idc_ok _CtlInfo

%BEGIN Grid column style, e_Create
  dlg_grid_column_style_eh(_Win,e_Create(_CreationData),0):-!,
	column_conf(Index,_),
	Ctrl = win_GetCtlHandle(_Win,idc_num_column),
	lbox_SetSel(Ctrl,Index,b_true),
	load_column_data(_Win),!,fail.
%END Grid column style, e_Create

  dlg_grid_column_style_eh(_,_,_):-!,fail.

%END_DLG Grid column style


%BEGIN_DLG Grid row style
/**************************************************************************
	Creation and event handling for dialog: Grid row style
**************************************************************************/

constants

%BEGIN Grid row style, CreateParms, 12:32:16-24.11.1999, Code automatically updated!
  dlg_grid_row_style_ResID = idd_grid_row_style
  dlg_grid_row_style_DlgType = wd_Modal
  dlg_grid_row_style_Help = idh_contents
%END Grid row style, CreateParms

predicates

  dlg_grid_row_style_eh : EHANDLER
  dlg_grid_row_style_handle_answer(INTEGER EndButton,DIALOG_VAL_LIST)
  dlg_grid_row_style_update(DIALOG_VAL_LIST)

clauses

  dlg_grid_row_style_Create(Parent):-

	change_rowstyle(GridRowStyle),
	GridRowStyle = grid_rowstyle(RowSelectorAreaWidth,MaxRows,MaxTextLinesInRow,RowSelector,ActivePointer),
	DefRowSelector = number_get(RowSelector),
	DefActivePointer = pointer_get(ActivePointer),
%MARK Grid row style, new variables

	dialog_CreateModal(Parent,dlg_grid_row_style_ResID,"",
  		[
%BEGIN Grid row style, ControlList, 12:32:16-24.11.1999, Code automatically updated!
		df(idc_edit,editint(i(RowSelectorAreaWidth),[default(RowSelectorAreaWidth),minimum(1)]),nopr),
		df(idc_edit1,editint(i(MaxRows),[default(MaxRows),minimum(1)]),nopr),
		df(idc_edit2,editint(i(MaxTextLinesInRow),[default(MaxTextLinesInRow),minimum(1)]),nopr),
		df(DEFACTIVEPOINTER,radiobuttongroup([idc_grid_true,idc_grid_false]),nopr),
		df(DEFROWSELECTOR,radiobuttongroup([idc_grid_number,idc_grid_nothing]),nopr)
%END Grid row style, ControlList
		],
		dlg_grid_row_style_eh,0,VALLIST,ANSWER),
	dlg_grid_row_style_handle_answer(ANSWER,VALLIST).

  dlg_grid_row_style_handle_answer(idc_ok,VALLIST):-!,
	dlg_grid_row_style_update(VALLIST).
  dlg_grid_row_style_handle_answer(idc_cancel,_):-!.  % Handle Esc and Cancel here
  dlg_grid_row_style_handle_answer(_,_):-
	errorexit().

  dlg_grid_row_style_update(_VALLIST):-
%BEGIN Grid row style, Update controls, 12:32:16-24.11.1999, Code automatically updated!
	_IDC_EDIT_VALUE = dialog_VLGetint(idc_edit,_VALLIST),
	_IDC_EDIT1_VALUE = dialog_VLGetint(idc_edit1,_VALLIST),
	_IDC_EDIT2_VALUE = dialog_VLGetint(idc_edit2,_VALLIST),
	_DEFACTIVEPOINTER = dialog_VLGetRadiobutton(idc_grid_true,_VALLIST),
	_DEFROWSELECTOR = dialog_VLGetRadiobutton(idc_grid_number,_VALLIST),
%END Grid row style, Update controls
	NewRowSelector = get_number(_Vallist),
	NewActivePointer = get_pointer(_Vallist),
	_IDC_EDIT_VALUE = i(NewRowSelectorAreaWidth),
	_IDC_EDIT1_VALUE = i(NewMaxRows),
	_IDC_EDIT2_VALUE = i(NewMaxTextLinesInRow),
	retract(grid_conf(GridStyle,_,ColumnStyle)),!,
	assert(grid_conf(GridStyle,grid_rowstyle(NewRowSelectorAreaWidth,NewMaxRows,
		NewMaxTextLinesInRow,NewRowSelector,NewActivePointer),ColumnStyle)),
	change_rowstyle(grid_rowstyle(NewRowSelectorAreaWidth,NewMaxRows,
		NewMaxTextLinesInRow,NewRowSelector,NewActivePointer)),
	true.
  dlg_grid_row_style_update(_VALLIST).

%MARK Grid row style, new events

  dlg_grid_row_style_eh(_,_,_):-!,fail.

%END_DLG Grid row style













































