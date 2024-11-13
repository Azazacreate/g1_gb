/******************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:	Label Expert
 FileName:	LABEL.PRO
 Purpose:	Main aplication module
 Written by:	Sergey Alexeev
 Build:		008.981112
 Comments:
******************************************************************************/

include "label.inc"
include "apptools\\layouted\\layouted.pre"
include "apptools\\pageset\\pageset.pre"
include "apptools\\print\\print.pre"
include "apptools\\editmode\\editmode.pre"

constants
  id_file_new		= 1000
  id_file_open		= 1001
  id_file_save		= 1002
  id_file_save_as	= 1003
  id_print_preview	= 1004
  id_printing		= 1005
  id_file_exit		= 1006
  id_edit_undo		= 1007
  id_edit_redo		= 1008
  id_edit_cut		= 1009
  id_edit_copy		= 1010
  id_edit_paste		= 1011
  id_edit_delete	= 1012
  id_edit_front		= 1013
  id_edit_back		= 1014
  id_edit_type		= 1015
  id_font		= 1016
  id_real_size		= 1017
  id_zoom_in		= 1018
  id_zoom_out		= 1019
  id_screen_update	= 1020
  id_elements_edit	= 1021
  id_text		= 1022
  id_counter		= 1023
  id_bitmap		= 1024
  id_rectangle		= 1025
  id_circle		= 1026
  id_line		= 1027
  id_help_contents	= 1028
  id_property		= 1029
  id_help_about		= 1030
  id_zoom		= 1031
  id_help		= 1032
  id_align		= 1033
  id_palette		= 1034
  id_file_close		= 1035
  id_auto_edit		= 1036
  id_print_border	= 1037

  id_window_tile	= 9201
  id_window_cascade	= 9202
  id_window_arricons	= 9203
  
  scale_thick		= 34
  
  empty_win		= 1
  layout_win		= 2
  printpreview_win	= 3
database - label_save_db
  determ field_layout(LE_FIELD_INFORMATIONLIST)
  determ page_layout(STRING Number,INTEGER FormPage,COLOR ColorPage,STRING Comment,
	REAL LeftMarg,REAL TopMarg,REAL HorSpace,REAL VertSpace,
	REAL LabelWidth, REAL LabelHeight,UNSIGNED NoHor,UNSIGNED NoVert,
	BOOLEAN Page_Roll,BOOLEAN Landscape,INTEGER Scale,FONT LabelFont,STRING LabelFontName)
database - label_save_db1
  determ program_font(FONT,STRING FontName)
  program_files(STRING FileName)
  program_size
database - label_db
  preview(WINDOW PVWin,WINDOW LEWin,INTEGER Scale)
  page(WINDOW LEWin,STRING Number,INTEGER FormPage,COLOR ColorPage,
	STRING Comment,REAL LeftMarg,REAL TopMarg,REAL HorSpace,REAL VertSpace,
	REAL LabelWidth,REAL LabelHeight,UNSIGNED NoHor,UNSIGNED NoVert,
	BOOLEAN Page_Roll,BOOLEAN Landscape,INTEGER Scale,BOOLEAN Saved,STRING FileName,
	BOOLEAN Modified,INTEGER Mode)
  scale_step(INTEGER)
  ask_button(INTEGER Id)
  stretch_button(BOOLEAN Stretch)
  disable_toolbar
  determ new_label_num(INTEGER)
  determ property_tobe
  determ align_tobe
  determ palette_tobe

  determ maximized_status(BOOLEAN)
  determ toolbar_status(INTEGER Situation)
  determ toolbar_win(WINDOW TBWin)

  determ auto_edit_status(BOOLEAN)
  determ print_border_status(BOOLEAN)
  determ focus_win(WINDOW LEWin)

%BEGIN_WIN Task Window
/***************************************************************************
		Event handling for Task Window
***************************************************************************/

predicates
  task_win_eh : EHANDLER
  le_cb : LE_CALLBACK
  pv_cb : PV_CALLBACK

constants
%BEGIN Task Window, CreateParms, 17:35:16-25.11.1999, Code automatically updated!
  task_win_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Close,wsf_Maximize,wsf_Minimize,wsf_ClipSiblings]
  task_win_Menu  = res_menu(idr_task_menu)
  task_win_Title = "LABEL"
  task_win_Help  = idh_contents
%END Task Window, CreateParms

predicates
  page_windows_disable()
  get_window_flags(BOOLEAN Maximized)

clauses
  page_windows_disable():-
	get_window_flags(Maximized),
	assert(maximized_status(Maximized)),
	fail.
  page_windows_disable():-
	page(LEWin,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_),
	win_SetState(LEWin,[wsf_Disabled]),
	fail.
  page_windows_disable().


predicates
  all_windows_disable()
clauses
  all_windows_disable():-
	page_windows_disable(),
	le_controls_off(),!.

predicates
  page_windows_enable()
clauses
  page_windows_enable():-
	page(LEWin,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_),
	win_SetState(LEWin,[wsf_Enabled]),
	fail.
  page_windows_enable().

predicates
  page_windows_restore()
clauses
  page_windows_restore():-
	retract(maximized_status(b_false)),
	page(LEWin,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_),
	win_SetState(LEWin,[wsf_Restored]),!.
  page_windows_restore():-
	retract(maximized_status(_)),
	page(LEWin,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_),
	win_SetState(LEWin,[wsf_Maximized]),!.

predicates
  all_windows_enable()
clauses
  all_windows_enable():-
	page_windows_enable(),
	page_windows_restore(),
	le_controls_on(),!.

predicates
  WINDOW page_create(WINDOW,STRING PageName,UNSIGNED NoHor,UNSIGNED NoVert,BOOLEAN Page_Roll,
	BOOLEAN Landscape,REAL LabelWidth,REAL LabelHeight,STRING Title,COLOR,INTEGER,INTEGER Scale)
  page_init(WINDOW,STRING PageName,UNSIGNED NoHor,UNSIGNED NoVert,BOOLEAN Page_Roll,
	BOOLEAN Landscape,REAL LabelWidth,REAL LabelHeight,COLOR,INTEGER)
  reset_step(INTEGER Val)
clauses
  scale_step(4).

  reset_step(0):-
	scale_step(8),!.
  reset_step(1):-
	scale_step(6),!.
  reset_step(2):-
	scale_step(4),!.
  reset_step(3):-
	scale_step(3),!.
  reset_step(4):-
	scale_step(2),!.
  reset_step(_):-
	retract(scale_step(_)),
	fail.
  reset_step(0):-
	assert(scale_step(8)),!.
  reset_step(1):-
	assert(scale_step(6)),!.
  reset_step(2):-
	assert(scale_step(4)),!.
  reset_step(3):-
	assert(scale_step(3)),!.
  reset_step(4):-
	assert(scale_step(2)),!.
  reset_step(_).

predicates
  min(INTEGER,INTEGER,INTEGER)
clauses
  min(A,B,A):-
	A < B,!.
  min(_,B,B).

predicates
  calc_sizes(WINDOW,REAL LabelWidth,REAL LabelHeight,INTEGER Step,RCT,RCT)
clauses
  calc_sizes(Win,LabelWidth,LabelHeight,Step,rct(L1,T1,R3,B3),rct(L4,T4,R4,B4)):-
	Rect = win_GetClientRect(Win),
	Rect = rct(L,T,R,B),
	L1 = L + 15, T1 = T + 10, R1 = (R - 360) div Step,
	B1 = (B - 120) div Step,
	R02 = L1 + LabelWidth + 50, B02 = T1 + LabelHeight + 50,
	R2 = val(integer,R02), B2 = val(integer,B02),
	min(R1,R2,R3),
	min(B1,B2,B3),
	L4 = 10, T4 = 10, R04 = L4 + LabelWidth, B04 = T4 + LabelHeight,
	R4 = val(integer,R04), B4 = val(integer,B04),!.

predicates
  get_default_size(WSFLAGS)
clauses
  get_window_flags(b_true):-
	page(LEWin,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_),
	Flags = win_GetState(LEWin),
	get_default_size(Flags),
	program_size,!.
  get_window_flags(b_false).

predicates
  property_set(WINDOW)
clauses
  property_set(Win):-
	retract(property_tobe),
	le_property_off(),
	menu_Check(Win,id_property,b_false),!.
  property_set(Win):-
	le_property_on(),
	menu_Check(Win,id_property,b_true),
	not(property_tobe),
	assert(property_tobe),!.
  property_set(_).

predicates
  property_create(WINDOW)
clauses
  property_create(_):-
	property_tobe,!.
  property_create(Win):-
	le_property_create(),
	menu_Check(Win,id_property,b_true),
	not(property_tobe),
	assert(property_tobe),!.
  property_create(_).

predicates
  property_destroy(WINDOW)
clauses
  property_destroy(_):-
	not(property_tobe),!.
  property_destroy(_):-
	page(_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_),!.
  property_destroy(Win):-
	le_property_destroy(),
	retractall(property_tobe),
	menu_Check(Win,id_property,b_false),!.

predicates
  align_set(WINDOW)
clauses
  align_set(Win):-
	retract(align_tobe),
	le_align_off(),
	menu_Check(Win,id_align,b_false),!.
  align_set(Win):-
	le_align_on(),
	menu_Check(Win,id_align,b_true),
	not(align_tobe),
	assert(align_tobe),!.
  align_set(_).

predicates
  align_create(WINDOW)
clauses
  align_create(_):-
	align_tobe,!.
  align_create(Win):-
	le_align_create(),
	menu_Check(Win,id_align,b_true),
	not(align_tobe),
	assert(align_tobe),!.
  align_create(_).

predicates
  align_destroy(WINDOW)
clauses
  align_destroy(_):-
	not(align_tobe),!.
  align_destroy(_):-
	page(_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_),!.
  align_destroy(Win):-
	le_align_destroy(),
	retractall(align_tobe),
	menu_Check(Win,id_align,b_false),!.

predicates
  palette_set(WINDOW)
clauses
  palette_set(Win):-
	retract(palette_tobe),
	le_palette_off(),
	menu_Check(Win,id_palette,b_false),!.
  palette_set(Win):-
	le_palette_on(),
	menu_Check(Win,id_palette,b_true),
	not(palette_tobe),
	assert(palette_tobe),!.
  palette_set(_).

predicates
  palette_create(WINDOW)
clauses
  palette_create(_):-
	palette_tobe,!.
  palette_create(Win):-
	le_palette_create(),
	menu_Check(Win,id_palette,b_true),
	not(palette_tobe),
	assert(palette_tobe),!.
  palette_create(_).

predicates
  palette_destroy(WINDOW)
clauses
  palette_destroy(_):-
	not(palette_tobe),!.
  palette_destroy(_):-
	page(_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_),!.
  palette_destroy(Win):-
	le_palette_destroy(),
	retractall(palette_tobe),
	menu_Check(Win,id_palette,b_false),!.

  page_create(Win,PageName,NoHor,NoVert,Page_Roll,Landscape,LabelWidth,LabelHeight,Title,Color,1,Scale,LEWin):-
	reset_step(Scale),
	scale_step(Step),
	calc_sizes(Win,LabelWidth,LabelHeight,Step,Rect1,Rect2),
	format(Tit,label_msg174,Title),
	program_font(Font,_),
	get_window_flags(Maximized),
	LEWin = le_create(Win,Maximized,PageName,LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,Landscape,
		Font,Tit,Step,Rect1,scale_thick,
		rectangle(Rect2,brush(pat_Solid,Color),color_LtGray,b_true),le_cb),
	retractall(focus_win(_)),
	assert(focus_win(LEWin)),
	property_create(Win),
	align_create(Win),
	palette_create(Win),
	toolbar_SetValue(Win,id_zoom,lbut_value(b_true,Scale)),!.
  page_create(Win,PageName,NoHor,NoVert,Page_Roll,Landscape,LabelWidth,LabelHeight,Title,Color,2,Scale,LEWin):-
	reset_step(Scale),
	scale_step(Step),
	calc_sizes(Win,LabelWidth,LabelHeight,Step,Rect1,Rect2),
	format(Tit,label_msg174,Title),
	program_font(Font,_),
	get_window_flags(Maximized),
	LEWin = le_create(Win,Maximized,PageName,LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,Landscape,
		Font,Tit,Step,Rect1,scale_thick,
		roundrect(Rect2,brush(pat_Solid,Color),5,color_LtGray,b_true),le_cb),
	retractall(focus_win(_)),
	assert(focus_win(LEWin)),
	property_create(Win),
	align_create(Win),
	palette_create(Win),
	toolbar_SetValue(Win,id_zoom,lbut_value(b_true,Scale)),!.
  page_create(Win,PageName,NoHor,NoVert,Page_Roll,Landscape,LabelWidth,LabelHeight,Title,Color,3,Scale,LEWin):-
	reset_step(Scale),
	scale_step(Step),
	calc_sizes(Win,LabelWidth,LabelHeight,Step,Rect1,Rect2),
	format(Tit,label_msg174,Title),
	program_font(Font,_),
	get_window_flags(Maximized),
	LEWin = le_create(Win,Maximized,PageName,LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,Landscape,
		Font,Tit,Step,Rect1,scale_thick,
		ellipse(Rect2,brush(pat_Solid,Color),color_LtGray,b_true),le_cb),
	retractall(focus_win(_)),
	assert(focus_win(LEWin)),
	property_create(Win),
	align_create(Win),
	palette_create(Win),
	toolbar_SetValue(Win,id_zoom,lbut_value(b_true,Scale)),!.

predicates
  dialog_Stretch(WINDOW LEWin,BOOLEAN Stretch)
  stretch_ask(WINDOW LEWin,REAL LabelWidth,REAL LabelHeight,BOOLEAN Stretch)
clauses
  stretch_ask(LEWin,LabelWidth,LabelHeight,b_true):-
	page(LEWin,_,_,_,_,_,_,_,_,LabelWidth,LabelHeight,_,_,_,_,_,_,_,_,_),!.
  stretch_ask(LEWin,_,_,Stretch):-
	dialog_Stretch(LEWin,Stretch),!.

  page_init(LEWin,PageName,NoHor,NoVert,Page_Roll,Landscape,LabelWidth,LabelHeight,Color,1):-
	stretch_ask(LEWin,LabelWidth,LabelHeight,Stretch),
	scale_step(Step),
	L = 10, T = 10, R0 = L + LabelWidth, B0 = T + LabelHeight,
	R = val(integer,R0), B = val(integer,B0),
	le_init(LEWin,PageName,LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,Landscape,Step,scale_thick,
		rectangle(rct(L,T,R,B),brush(pat_Solid,Color),color_LtGray,b_true),Stretch),!.
  page_init(LEWin,PageName,NoHor,NoVert,Page_Roll,Landscape,LabelWidth,LabelHeight,Color,2):-
	stretch_ask(LEWin,LabelWidth,LabelHeight,Stretch),
	scale_step(Step),
	L = 10, T = 10, R0 = L + LabelWidth, B0 = T + LabelHeight,
	R = val(integer,R0), B = val(integer,B0),
	le_init(LEWin,PageName,LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,Landscape,Step,scale_thick,
		roundrect(rct(L,T,R,B),brush(pat_Solid,Color),5,color_LtGray,b_true),Stretch),!.
  page_init(LEWin,PageName,NoHor,NoVert,Page_Roll,Landscape,LabelWidth,LabelHeight,Color,3):-
	stretch_ask(LEWin,LabelWidth,LabelHeight,Stretch),
	scale_step(Step),
	L = 10, T = 10, R0 = L + LabelWidth, B0 = T + LabelHeight,
	R = val(integer,R0), B = val(integer,B0),
	le_init(LEWin,PageName,LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,Landscape,Step,scale_thick,
		ellipse(rct(L,T,R,B),brush(pat_Solid,Color),color_LtGray,b_true),Stretch),!.
  page_init(_,_,_,_,_,_,_,_,_,_).

predicates
  save_file_all(WINDOW LEWin,INTEGER ButtonNo)
  INTEGER dialog_Ask(STRING Str)
clauses
  save_file_all(_,idc_cancel):-!.
  save_file_all(LEWin,idc_yes):-
	Win = win_GetParent(LEWin),
	task_win_eh(Win,e_Menu(id_file_save,0)),
	win_Destroy(LEWin),
	retractall(page(LEWin,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_)),
	page(LEWin1,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,FileName1,b_true,_),
	win_SetFocus(LEWin1),
	ButtonNo1 = dialog_Ask(FileName1),
	save_file_all(LEWin1,ButtonNo1),!.
  save_file_all(LEWin,idc_no):-
	win_Destroy(LEWin),
	retractall(page(LEWin,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_)),
	page(LEWin1,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,FileName1,b_true,_),
	win_SetFocus(LEWin1),
	ButtonNo1 = dialog_Ask(FileName1),
	save_file_all(LEWin1,ButtonNo1),!.

predicates
  del_file_all()
clauses
  del_file_all():-
	retract(page(LEWin,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_)),
	win_Destroy(LEWin),
	fail.

predicates
  menu_uncheck(WINDOW)
clauses
  menu_uncheck(Win):-
	menu_Check(Win,id_elements_edit,b_false),
	menu_Check(Win,id_text,b_false),
	menu_Check(Win,id_counter,b_false),
	menu_Check(Win,id_bitmap,b_false),
	menu_Check(Win,id_rectangle,b_false),
	menu_Check(Win,id_circle,b_false),
	menu_Check(Win,id_line,b_false),!.

predicates
  mode_reset(WINDOW LEWin,INTEGER Mode)
clauses
  mode_reset(LEWin,Mode):-
	retract(page(LEWin,Number,FormPage,ColorPage,Comment,LeftMarg,TopMarg,HorSpace,VertSpace,
	LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,Landscape,Scale,Saved,Name,Modified,_)),
	assert(page(LEWin,Number,FormPage,ColorPage,Comment,LeftMarg,TopMarg,HorSpace,VertSpace,
	LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,Landscape,Scale,Saved,Name,Modified,Mode)),!.

predicates
  menu_list(WINDOW Win,ILIST Items,BOOLEAN Enable)
clauses
  menu_list(_,[],_):-!.
  menu_list(Win,[Id|Rest],Enable):-
	menu_Enable(Win,Id,Enable),!,
	menu_list(Win,Rest,Enable).

predicates
  save_options()
clauses
  save_options():-
	syspath(Path,_),
	format(FileName,"%sLABEL.INI",Path),
	trap(save(FileName,label_save_db1),_,fail),!.
  save_options().

predicates
  load_options()
clauses
  load_options():-
	assert(auto_edit_status(b_true)),
	assert(print_border_status(b_true)),
	syspath(Path,_),
	format(FileName,"%sLABEL.INI",Path),
	trap(consult(FileName,label_save_db1),_,fail),!.
  load_options():-
	Font = font_Create(ff_System,[],10),
	assert(program_font(Font,"System")).

predicates
  base_cut(SLIST Flist)
clauses
  base_cut([]):-!.
  base_cut([File|Rest]):-
	retract(program_files(File)),!,
	base_cut(Rest).

predicates
  list_cut(SLIST Flist,UNSIGNED Count,SLIST,SLIST Flist1)
clauses
  list_cut([],_,Flist,Flist):-!.
  list_cut(DelList,0,Flist,Flist):-
	base_cut(DelList),!.
  list_cut([File|Rest],C,F,Flist):-
	C1 = C - 1,!,
	list_cut(Rest,C1,[File|F],Flist).

predicates
  create_file_menu(UNSIGNED Item,SLIST Flist,MENU_ITEM_LIST,MENU_ITEM_LIST Files)
clauses
  create_file_menu(_,[],Files,Files):-!.
  create_file_menu(Item,[File|Rest],MIL,Files):-
	I = Item + 1,
	create_file_menu(I,Rest,[txt(Item,File,0,1,0,[])|MIL],Files).

predicates
  check_opening_files()
clauses
  check_opening_files():-
	program_files(F),
	not(existfile(F)),
	retract(program_files(F)),
	fail.
  check_opening_files().

predicates
  get_opening_files(MENU_ITEM_LIST)
clauses
  get_opening_files(Files):-
	check_opening_files(),
	program_files(_),
	findall(F,program_files(F),Flist),
	list_cut(Flist,10,[],Flist1),
	create_file_menu(10000,Flist1,[],Files1),
	Files = [separator|Files1],!.
  get_opening_files([]).

predicates
  add_opening_files(WINDOW,STRING FileName)
  menu_change(WINDOW Win,INTEGER Situation)
clauses
  add_opening_files(Win,FileName):-
	retract(program_files(FileName)),
	asserta(program_files(FileName)),
	menu_change(Win,layout_win),!.
  add_opening_files(Win,FileName):-
	asserta(program_files(FileName)),
	menu_change(Win,layout_win),!.

predicates
  search_FileName(UNSIGNED BegItem,UNSIGNED Item,SLIST Flist,STRING FileName)
clauses
  search_FileName(Item,Item,[FileName|_],FileName):-!.
  search_FileName(BegItem,Item,[_|Rest],FileName):-
	BI = BegItem + 1,!,
	search_FileName(BI,Item,Rest,FileName).

predicates
  listlength(SLIST,INTEGER)
clauses
  listlength([],0):-!.
  listlength([_|T],N1):-
	listlength(T,N),
	N1=N+1.

predicates
  get_filename_from_item(UNSIGNED Item,STRING FileName)
clauses
  get_filename_from_item(Item1,FileName):-
	findall(F,program_files(F),Flist),
	listlength(Flist,Len),
	Item = Len - (Item1 - 10000) + 9999,
	search_FileName(10000,Item,Flist,FileName),!.

  get_default_size([]):-
	retractall(program_size),!.
  get_default_size([wsf_Maximized|_]):-
	retractall(program_size),
	assert(program_size),!.
  get_default_size([_|Rest]):-!,
	get_default_size(Rest).

predicates
  set_default_size(WINDOW)
clauses
  set_default_size(Win):-
	program_size,
	win_SetState(Win,[wsf_Maximized]),!.
  set_default_size(_).

predicates
  get_file_name(STRING Title,WINDOW LEWin,BOOLEAN,STRING,STRING)
  tb_callback : TOOLBAR_ACTION_FUNC
  toolbar_creatempty(WINDOW Win)
  save_file(WINDOW LEWin,INTEGER ButtonNo)
  em_cb : EM_CALLBACK
  edit_SetPressedButton_my(INTEGER Mode)
clauses
  task_win_eh(Win,e_Create(_),0):-!,
	load_options(),
	toolbar_creatempty(Win),
	tb_help_line_Create(Win),
ifdef use_message
	msg_Create(100),
enddef
	menu_change(Win,empty_win),
	le_init_module(le_cb),
	assert(new_label_num(1)),
	win_PostEvent(Win,e_Menu(0,0)),!.

  task_win_eh(_,e_CloseRequest(),0):-
	page(LEWin,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,FileName,b_true,_),
	ButtonNo = dialog_Ask(FileName),
	save_file_all(LEWin,ButtonNo),!.
  task_win_eh(_,e_CloseRequest(),0):-
	del_file_all(),!.

  task_win_eh(Win,e_Destroy,0):-
	Wsflags = win_GetState(Win),
	get_default_size(Wsflags),
	save_options(),
	le_close_module(),!,fail.

  task_win_eh(Win,e_Size(_Width,_Height),0):-!,
	toolbar_Resize(Win),
ifdef use_message
	msg_Resize(Win),
enddef
	!.

  task_win_eh(Win,e_Menu(0,_ShiftCtlAlt),0):-
	set_default_size(Win),
	em_create(Win,pnt(10,40),em_cb),!.

  task_win_eh(Win,e_Menu(Item,_ShiftCtlAlt),0):-
	Item >= 10000,
	get_filename_from_item(Item,FileName),
	trap(consult(FileName,label_save_db),_,dlg_note(label_msg147)),
	retract(field_layout(Information)),
	retract(page_layout(Number,FormPage,ColorPage,Comment,LeftMarg,TopMarg,
	HorSpace,VertSpace,LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,Landscape,_,LabelFont,LabelFontName)),
	LEWin = page_create(Win,Number,NoHor,NoVert,Page_Roll,Landscape,LabelWidth,LabelHeight,FileName,ColorPage,FormPage,2),
	le_fields(LEWin,Information,LabelFont,LabelFontName),
	assert(page(LEWin,Number,FormPage,ColorPage,Comment,LeftMarg,TopMarg,
	HorSpace,VertSpace,LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,Landscape,2,
	b_true,FileName,b_false,id_elements_edit)),
	program_font(Font,_),
	pageset_set_default(Font,Number,FormPage,ColorPage,Comment,LeftMarg,TopMarg,
	HorSpace,VertSpace,LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,Landscape),
	format(ToolStr,label_msg148,FileName),
	toolbar_SetValue(Win,idt_help_line,text_value(ToolStr)),
	add_opening_files(Win,FileName),
	edit_SetPressedButton_my(id_elements_edit),!.

  task_win_eh(Win,e_Menu(id_help,_ShiftCtlAlt),0):-!,
	dlg_about_dialog_Create(Win).

  task_win_eh(Win,e_Menu(id_help_about,_ShiftCtlAlt),0):-!,
	dlg_about_dialog_Create(Win).

  task_win_eh(Win,e_Menu(id_file_exit,_ShiftCtlAlt),0):-!,
	not(task_win_eh(Win,e_CloseRequest())),
	property_destroy(Win),
	align_destroy(Win),
	palette_destroy(Win),
  	win_Destroy(Win),!.

  task_win_eh(_,e_Menu(id_printing,_ShiftCtlAlt),0):-
	LEWin = win_GetActiveWindow(),
	page(LEWin,_,FormPage,_,_,LeftMarg,TopMarg,HorSpace,VertSpace,
	LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,Landscape,_,_,_,_,_),
	le_fields(LEWin,Information,_,_),
	program_font(Font,_),
	print_border_status(PrintBorder),
	print_create(Font,PrintBorder,FormPage,LeftMarg,TopMarg,HorSpace,VertSpace,LabelWidth,LabelHeight,
	NoHor,NoVert,Page_Roll,Landscape,Information),!.
  task_win_eh(_,e_Menu(id_printing,_ShiftCtlAlt),0):-
	PVWin = win_GetActiveWindow(),
	preview(PVWin,LEWin,_),
	page(LEWin,_,FormPage,_,_,LeftMarg,TopMarg,HorSpace,VertSpace,
	LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,Landscape,_,_,_,_,_),
	le_fields(LEWin,Information,_,_),
	program_font(Font,_),
	print_create(Font,b_true,FormPage,LeftMarg,TopMarg,HorSpace,VertSpace,LabelWidth,LabelHeight,
	NoHor,NoVert,Page_Roll,Landscape,Information),!.

  task_win_eh(Win,e_Menu(id_print_preview,_ShiftCtlAlt),0):-
	LEWin = win_GetActiveWindow(),
	page(LEWin,_,FormPage,ColorPage,_,LeftMarg,TopMarg,HorSpace,VertSpace,
	LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,Landscape,_,_,Name,_,_),
	format(Title,label_msg167,Name),
	Rect = win_GetClientRect(Win),
	Rect = rct(L,T,R,B),
	reset_step(2),
	scale_step(Step),
	L1 = L + 5, T1 = T + 10, R1 = (R - 360) div Step,
	B1 = (B - 120) div Step,
	le_fields(LEWin,Information,_,_),
	all_windows_disable(),
	PVWin = pv_create(Win,b_true,Title,Step,rct(L1,T1,R1,B1),scale_thick,color_LtGray,FormPage,ColorPage,
	LeftMarg,TopMarg,HorSpace,VertSpace,LabelWidth,LabelHeight,NoHor,NoVert,
	Page_Roll,Landscape,Information,pv_cb),
	menu_change(Win,printpreview_win),
	toolbar_SetValue(Win,id_zoom,lbut_value(b_true,2)),
	assert(preview(PVWin,LEWin,2)),!.

  task_win_eh(Win,e_Menu(id_file_new,_ShiftCtlAlt),0):-
	program_font(LabelFont,LabelFontName),
	pageset_get_current(Win,LabelFont),
	pageset_get_default(Number,FormPage,ColorPage,Comment,LeftMarg,TopMarg,
	HorSpace,VertSpace,LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,Landscape),
	retract(new_label_num(NewLabNum)),
	NewLabNum1 = NewLabNum + 1,
	assert(new_label_num(NewLabNum1)),
	format(NewFileName,"%s%.lab",label_msg175,NewLabNum),
	menu_change(Win,layout_win),
	LEWin = page_create(Win,Number,NoHor,NoVert,Page_Roll,Landscape,LabelWidth,LabelHeight,NewFileName,
	ColorPage,FormPage,2),
	le_fields(LEWin,[],LabelFont,LabelFontName),
	assert(page(LEWin,Number,FormPage,ColorPage,Comment,LeftMarg,TopMarg,
	HorSpace,VertSpace,LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,Landscape,2,
	b_false,NewFileName,b_false,id_elements_edit)),
	edit_SetPressedButton_my(id_elements_edit),!.

  task_win_eh(Win,e_Menu(id_file_open,_ShiftCtlAlt),0):-
	FileName = dlg_GetOpenFileName("*.lab",[label_msg176,"*.lab",label_msg177,"*.*"],label_msg189),
	FileName <> "",
	trap(consult(FileName,label_save_db),_,dlg_note(label_msg147)),
	retract(field_layout(Information)),
	retract(page_layout(Number,FormPage,ColorPage,Comment,LeftMarg,TopMarg,
	HorSpace,VertSpace,LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,Landscape,_,LabelFont,LabelFontName)),
	add_opening_files(Win,FileName),
	LEWin = page_create(Win,Number,NoHor,NoVert,Page_Roll,Landscape,LabelWidth,LabelHeight,FileName,ColorPage,FormPage,2),
	le_fields(LEWin,Information,LabelFont,LabelFontName),
	assert(page(LEWin,Number,FormPage,ColorPage,Comment,LeftMarg,TopMarg,
	HorSpace,VertSpace,LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,Landscape,2,
	b_true,FileName,b_false,id_elements_edit)),
	program_font(Font,_),
	pageset_set_default(Font,Number,FormPage,ColorPage,Comment,LeftMarg,TopMarg,
	HorSpace,VertSpace,LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,Landscape),
	format(ToolStr,label_msg148,FileName),
	toolbar_SetValue(Win,idt_help_line,text_value(ToolStr)),
	edit_SetPressedButton_my(id_elements_edit),!.

  task_win_eh(_,e_Menu(id_file_close,_ShiftCtlAlt),0):-
	LEWin = win_GetActiveWindow(),
	page(LEWin,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,FileName,b_true,_),!,
	ButtonNo = dialog_Ask(FileName),
	not(save_file(LEWin,ButtonNo)),
	win_Destroy(LEWin),!.
  task_win_eh(_,e_Menu(id_file_close,_ShiftCtlAlt),0):-
	LEWin = win_GetActiveWindow(),
	page(LEWin,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_),
	win_Destroy(LEWin),!.
  task_win_eh(Win,e_Menu(id_file_close,_ShiftCtlAlt),0):-
	PVWin = win_GetActiveWindow(),
	preview(PVWin,_,_),
	win_SetState(PVWin,[wsf_Restored]),
	menu_change(Win,layout_win),
	all_windows_enable(),
	preview(PVWin,LEWin,_),
	win_Destroy(PVWin),
	win_SetFocus(LEWin),!.

  task_win_eh(Win,e_Menu(id_file_save,_ShiftCtlAlt),0):-
	LEWin = win_GetActiveWindow(),
	page(LEWin,Number,FormPage,ColorPage,Comment,LeftMarg,TopMarg,HorSpace,VertSpace,
	LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,Landscape,Scale,Saved,Name,_,_),
	get_file_name(label_msg178,LEWin,Saved,Name,FileName),
	le_fields(LEWin,Information,LabelFont,LabelFontName),
	assert(field_layout(Information)),
	assert(page_layout(Number,FormPage,ColorPage,Comment,LeftMarg,TopMarg,
	HorSpace,VertSpace,LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,Landscape,Scale,LabelFont,LabelFontName)),
	trap(save(FileName,label_save_db),_,fail),
	retract(page(LEWin,A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,_,Q,_,R)),
	assert(page(LEWin,A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,b_true,Q,b_false,R)),
	format(ToolStr,label_msg149,FileName),
	toolbar_SetValue(Win,idt_help_line,text_value(ToolStr)),
	format(Tit,label_msg174,FileName),
	win_SetText(LEWin,Tit),
	add_opening_files(Win,FileName),
	retract(field_layout(_)),
	retract(page_layout(_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_)),!.
  task_win_eh(_,e_Menu(id_file_save,_ShiftCtlAlt),0):-!.

  task_win_eh(Win,e_Menu(id_file_save_as,_ShiftCtlAlt),0):-!,
	LEWin = win_GetActiveWindow(),
	page(LEWin,Number,FormPage,ColorPage,Comment,LeftMarg,TopMarg,HorSpace,VertSpace,
	LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,Landscape,Scale,_,Name,_,_),
	get_file_name(label_msg210,LEWin,b_false,Name,FileName),
	le_fields(LEWin,Information,LabelFont,LabelFontName),
	assert(field_layout(Information)),
	assert(page_layout(Number,FormPage,ColorPage,Comment,LeftMarg,TopMarg,
	HorSpace,VertSpace,LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,Landscape,Scale,LabelFont,LabelFontName)),
	trap(save(FileName,label_save_db),_,fail),
	retract(page(LEWin,Number,FormPage,ColorPage,Comment,LeftMarg,TopMarg,HorSpace,VertSpace,
	LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,Landscape,Scale,_,_,_,Mode)),
	assert(page(LEWin,Number,FormPage,ColorPage,Comment,LeftMarg,TopMarg,HorSpace,VertSpace,
	LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,Landscape,Scale,b_true,FileName,b_false,Mode)),
	format(ToolStr,label_msg149,FileName),
	toolbar_SetValue(Win,idt_help_line,text_value(ToolStr)),
	format(Tit,label_msg174,FileName),
	win_SetText(LEWin,Tit),
	add_opening_files(Win,FileName),
	retract(field_layout(_)),
	retract(page_layout(_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_)),!.

  task_win_eh(_,e_Menu(id_edit_undo,_ShiftCtlAlt),0):-
	LEWin = win_GetActiveWindow(),
	win_SendEvent(LEWin,e_Char(26,c_Control)),!.
  task_win_eh(_,e_Menu(id_edit_redo,_ShiftCtlAlt),0):-
	LEWin = win_GetActiveWindow(),
	win_SendEvent(LEWin,e_Char(26,c_ShiftCtl)),!.
  task_win_eh(_,e_Menu(id_edit_cut,_ShiftCtlAlt),0):-
	LEWin = win_GetActiveWindow(),
	win_SendEvent(LEWin,e_Char(24,c_Control)),!.
  task_win_eh(_,e_Menu(id_edit_copy,_ShiftCtlAlt),0):-
	LEWin = win_GetActiveWindow(),
	win_SendEvent(LEWin,e_Char(3,c_Control)),!.
  task_win_eh(_,e_Menu(id_edit_paste,_ShiftCtlAlt),0):-
	LEWin = win_GetActiveWindow(),
	win_SendEvent(LEWin,e_Char(22,c_Control)),!.
  task_win_eh(_,e_Menu(id_edit_delete,_ShiftCtlAlt),0):-
	LEWin = win_GetActiveWindow(),
	win_SendEvent(LEWin,e_Char(k_del,c_Nothing)),!.

  task_win_eh(Win,e_Menu(id_edit_type,_ShiftCtlAlt),0):-
	program_font(Font,_),
	pageset_get_current(Win,Font),
	pageset_get_default(Number,FormPage,ColorPage,Comment,LeftMarg,TopMarg,
	HorSpace,VertSpace,LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,Landscape),
	LEWin = win_GetActiveWindow(),
	page(LEWin,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_),
	page_init(LEWin,Number,NoHor,NoVert,Page_Roll,Landscape,LabelWidth,LabelHeight,ColorPage,FormPage),
	retract(page(LEWin,_,_,_,_,_,_,_,_,_,_,_,_,_,_,Scale,Saved,Name,_,Mode)),
	assert(page(LEWin,Number,FormPage,ColorPage,Comment,LeftMarg,TopMarg,
	HorSpace,VertSpace,LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,Landscape,Scale,Saved,Name,b_true,Mode)),!.

  task_win_eh(_,e_Menu(id_elements_edit,_ShiftCtlAlt),0):-
	PVWin = win_GetActiveWindow(),
	preview(PVWin,LEWin,_),
	win_SetFocus(LEWin),!.
  task_win_eh(Win,e_Menu(id_elements_edit,_ShiftCtlAlt),0):-
	edit_SetPressedButton_my(id_elements_edit),
	menu_uncheck(Win),
	menu_Check(Win,id_elements_edit,b_true),
	LEWin = win_GetActiveWindow(),
	mode_reset(LEWin,id_elements_edit),
	le_SetMode(LEWin,edit_mode),!.
  task_win_eh(Win,e_Menu(id_text,_ShiftCtlAlt),0):-
	LEWin = win_GetActiveWindow(),
	mode_reset(LEWin,id_text),!,
	edit_SetPressedButton_my(id_text),
	menu_uncheck(Win),
	menu_Check(Win,id_text,b_true),
	not(le_SetMode(LEWin,create_mode(text))),
	task_win_eh(Win,e_Menu(id_elements_edit,_ShiftCtlAlt)),!.
  task_win_eh(Win,e_Menu(id_text,_ShiftCtlAlt),0):-
	task_win_eh(Win,e_Menu(id_elements_edit,_ShiftCtlAlt)),!.
  task_win_eh(Win,e_Menu(id_counter,_ShiftCtlAlt),0):-
	LEWin = win_GetActiveWindow(),
	mode_reset(LEWin,id_counter),!,
	edit_SetPressedButton_my(id_counter),
	menu_uncheck(Win),
	menu_Check(Win,id_counter,b_true),
	not(le_SetMode(LEWin,create_mode(counter))),
	task_win_eh(Win,e_Menu(id_elements_edit,_ShiftCtlAlt)),!.
  task_win_eh(Win,e_Menu(id_counter,_ShiftCtlAlt),0):-
	task_win_eh(Win,e_Menu(id_elements_edit,_ShiftCtlAlt)),!.
  task_win_eh(Win,e_Menu(id_bitmap,_ShiftCtlAlt),0):-
	LEWin = win_GetActiveWindow(),
	mode_reset(LEWin,id_bitmap),!,
	edit_SetPressedButton_my(id_bitmap),
	menu_uncheck(Win),
	menu_Check(Win,id_bitmap,b_true),
	not(le_SetMode(LEWin,create_mode(bitmap))),
	task_win_eh(Win,e_Menu(id_elements_edit,_ShiftCtlAlt)),!.
  task_win_eh(Win,e_Menu(id_bitmap,_ShiftCtlAlt),0):-
	task_win_eh(Win,e_Menu(id_elements_edit,_ShiftCtlAlt)),!.
  task_win_eh(Win,e_Menu(id_rectangle,_ShiftCtlAlt),0):-
	LEWin = win_GetActiveWindow(),
	mode_reset(LEWin,id_rectangle),!,
	edit_SetPressedButton_my(id_rectangle),
	menu_uncheck(Win),
	menu_Check(Win,id_rectangle,b_true),
	not(le_SetMode(LEWin,create_mode(rectangle))),
	task_win_eh(Win,e_Menu(id_elements_edit,_ShiftCtlAlt)),!.
  task_win_eh(Win,e_Menu(id_rectangle,_ShiftCtlAlt),0):-
	task_win_eh(Win,e_Menu(id_elements_edit,_ShiftCtlAlt)),!.
  task_win_eh(Win,e_Menu(id_circle,_ShiftCtlAlt),0):-
	LEWin = win_GetActiveWindow(),
	mode_reset(LEWin,id_circle),!,
	edit_SetPressedButton_my(id_circle),
	menu_uncheck(Win),
	menu_Check(Win,id_circle,b_true),
	not(le_SetMode(LEWin,create_mode(ellipse))),
	task_win_eh(Win,e_Menu(id_elements_edit,_ShiftCtlAlt)),!.
  task_win_eh(Win,e_Menu(id_circle,_ShiftCtlAlt),0):-
	task_win_eh(Win,e_Menu(id_elements_edit,_ShiftCtlAlt)),!.
  task_win_eh(Win,e_Menu(id_line,_ShiftCtlAlt),0):-
	LEWin = win_GetActiveWindow(),
	mode_reset(LEWin,id_line),!,
	edit_SetPressedButton_my(id_line),
	menu_uncheck(Win),
	menu_Check(Win,id_line,b_true),
	not(le_SetMode(LEWin,create_mode(line))),
	task_win_eh(Win,e_Menu(id_elements_edit,_ShiftCtlAlt)),!.
  task_win_eh(Win,e_Menu(id_line,_ShiftCtlAlt),0):-
	task_win_eh(Win,e_Menu(id_elements_edit,_ShiftCtlAlt)),!.
  task_win_eh(Win,e_Menu(id_auto_edit,_ShiftCtlAlt),0):-
	retract(auto_edit_status(b_true)),
	assert(auto_edit_status(b_false)),
	menu_Check(Win,id_auto_edit,b_false),!.
  task_win_eh(Win,e_Menu(id_auto_edit,_ShiftCtlAlt),0):-
	retract(auto_edit_status(b_false)),
	assert(auto_edit_status(b_true)),
	menu_Check(Win,id_auto_edit,b_true),!.
  task_win_eh(Win,e_Menu(id_print_border,_ShiftCtlAlt),0):-
	retract(print_border_status(b_true)),
	assert(print_border_status(b_false)),
	menu_Check(Win,id_print_border,b_false),!.
  task_win_eh(Win,e_Menu(id_print_border,_ShiftCtlAlt),0):-
	retract(print_border_status(b_false)),
	assert(print_border_status(b_true)),
	menu_Check(Win,id_print_border,b_true),!.

  task_win_eh(Win,e_Menu(id_real_size,_ShiftCtlAlt),0):-
	LEWin = win_GetActiveWindow(),
	page(LEWin,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_),
	tb_callback(Win,id_zoom,lbut_value(b_true,2)),
	toolbar_SetValue(Win,id_zoom,lbut_value(b_true,2)),!.
  task_win_eh(Win,e_Menu(id_real_size,_ShiftCtlAlt),0):-
	PVWin = win_GetActiveWindow(),
	preview(PVWin,_,_),
	tb_callback(Win,id_zoom,lbut_value(b_true,2)),
	toolbar_SetValue(Win,id_zoom,lbut_value(b_true,2)),!.
  task_win_eh(Win,e_Menu(id_zoom_in,_ShiftCtlAlt),0):-
	LEWin = win_GetActiveWindow(),
	page(LEWin,_,_,_,_,_,_,_,_,_,_,_,_,_,_,Scale,_,_,_,_),
	S = Scale - 1,
	S >= 0,
	tb_callback(Win,id_zoom,lbut_value(b_true,S)),
	toolbar_SetValue(Win,id_zoom,lbut_value(b_true,S)),!.
  task_win_eh(Win,e_Menu(id_zoom_in,_ShiftCtlAlt),0):-
	PVWin = win_GetActiveWindow(),
	preview(PVWin,_,Scale),
	S = Scale - 1,
	S >= 0,
	tb_callback(Win,id_zoom,lbut_value(b_true,S)),
	toolbar_SetValue(Win,id_zoom,lbut_value(b_true,S)),!.
  task_win_eh(Win,e_Menu(id_zoom_out,_ShiftCtlAlt),0):-
	LEWin = win_GetActiveWindow(),
	page(LEWin,_,_,_,_,_,_,_,_,_,_,_,_,_,_,Scale,_,_,_,_),
	S = Scale + 1,
	S <= 4,
	tb_callback(Win,id_zoom,lbut_value(b_true,S)),
	toolbar_SetValue(Win,id_zoom,lbut_value(b_true,S)),!.
  task_win_eh(Win,e_Menu(id_zoom_out,_ShiftCtlAlt),0):-
	PVWin = win_GetActiveWindow(),
	preview(PVWin,_,Scale),
	S = Scale + 1,
	S <= 4,
	tb_callback(Win,id_zoom,lbut_value(b_true,S)),
	toolbar_SetValue(Win,id_zoom,lbut_value(b_true,S)),!.
  task_win_eh(_,e_Menu(id_screen_update,_ShiftCtlAlt),0):-
	LEWin = win_GetActiveWindow(),
	page(LEWin,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_),
	le_Invalidate(LEWin),!.
  task_win_eh(Win,e_Menu(id_property,_ShiftCtlAlt),0):-
	property_set(Win),!.
  task_win_eh(Win,e_Menu(id_align,_ShiftCtlAlt),0):-
	align_set(Win),!.
  task_win_eh(Win,e_Menu(id_palette,_ShiftCtlAlt),0):-
	palette_set(Win),!.

  task_win_eh(_,e_Menu(id_edit_front,_ShiftCtlAlt),0):-
	LEWin = win_GetActiveWindow(),
	page(LEWin,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_),
	le_BringToFront(LEWin),!.
  task_win_eh(_,e_Menu(id_edit_back,_ShiftCtlAlt),0):-
	LEWin = win_GetActiveWindow(),
	page(LEWin,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_),
	le_SendToBack(LEWin),!.

  task_win_eh(_,e_Menu(id_font,_ShiftCtlAlt),0):-
	program_font(OldFont,_),
	Font = dlg_ChooseFont(OldFont,FontName,_),
	retractall(program_font(_,_)),
	assert(program_font(Font,FontName)),!.

/***************************************************************************
	Invoking on-line Help
***************************************************************************/
  project_ShowHelpContext(HelpTopic):-
  	vpi_ShowHelpContext("label.hlp",HelpTopic),!.

%END_WIN Task Window

/***************************************************************************
	Main Goal
***************************************************************************/

GOAL
  vpi_SetAttrVal(attr_win_mdi,b_true),
  vpi_SetAttrVal(attr_win_3dcontrols,b_true),
  vpi_Init(task_win_Flags,task_win_eh,task_win_Menu,"label",task_win_Title).

predicates
  reset_scale(INTEGER Val)
clauses
  reset_scale(Val):-
	PVWin = win_GetActiveWindow(),
	retract(preview(PVWin,LEWin,_)),
	assert(preview(PVWin,LEWin,Val)),
	scale_step(S2),
	pv_init(PVWin,S2),!.
  reset_scale(Val):-
	LEWin = win_GetActiveWindow(),
	retract(page(LEWin,Number,FormPage,ColorPage,Comment,LeftMarg,TopMarg,
	HorSpace,VertSpace,LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,Landscape,_,Saved,Name,Modified,Mode)),
	assert(page(LEWin,Number,FormPage,ColorPage,Comment,LeftMarg,TopMarg,
	HorSpace,VertSpace,LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,Landscape,Val,Saved,Name,Modified,Mode)),
	page_init(LEWin,Number,NoHor,NoVert,Page_Roll,Landscape,LabelWidth,LabelHeight,ColorPage,FormPage),!.

  tb_callback(_,id_zoom,lbut_value(b_true,Val)):-
	scale_step(S1),
	reset_step(Val),
	scale_step(S2),
	S1 <> S2,
	reset_scale(Val),!.
  tb_callback(Win,MenuId,_):-
	win_SendEvent(Win,e_Menu(MenuId,0)),!.

  em_cb(_):-
	focus_win(LEWin),
	win_SetFocus(LEWin),
	fail.
  em_cb(edit_mode):-
	TaskWin1 = vpi_GetAttrVal(attr_task_window),
	TaskWin = cast(window,TaskWin1),
	win_SendEvent(TaskWin,e_Menu(id_elements_edit,0)),!.
  em_cb(text):-
	TaskWin1 = vpi_GetAttrVal(attr_task_window),
	TaskWin = cast(window,TaskWin1),
	win_SendEvent(TaskWin,e_Menu(id_text,0)),!.
  em_cb(counter):-
	TaskWin1 = vpi_GetAttrVal(attr_task_window),
	TaskWin = cast(window,TaskWin1),
	win_SendEvent(TaskWin,e_Menu(id_counter,0)),!.
  em_cb(bitmap):-
	TaskWin1 = vpi_GetAttrVal(attr_task_window),
	TaskWin = cast(window,TaskWin1),
	win_SendEvent(TaskWin,e_Menu(id_bitmap,0)),!.
  em_cb(rectangle):-
	TaskWin1 = vpi_GetAttrVal(attr_task_window),
	TaskWin = cast(window,TaskWin1),
	win_SendEvent(TaskWin,e_Menu(id_rectangle,0)),!.
  em_cb(circle):-
	TaskWin1 = vpi_GetAttrVal(attr_task_window),
	TaskWin = cast(window,TaskWin1),
	win_SendEvent(TaskWin,e_Menu(id_circle,0)),!.
  em_cb(line):-
	TaskWin1 = vpi_GetAttrVal(attr_task_window),
	TaskWin = cast(window,TaskWin1),
	win_SendEvent(TaskWin,e_Menu(id_line,0)),!.

/**************************************************************************
	Creation of toolbar: Help line
**************************************************************************/
clauses
  tb_help_line_Create(Parent):-
%	program_font(Font,_),
	toolbar_create(tb_bottom,0xC0C0C0,Parent,
		[tb_text(idt_help_line,tb_static,600,0,1,10,0,"")]),!.

%BEGIN_DLG About dialog
/**************************************************************************
	Creation and event handling for dialog: About dialog
**************************************************************************/

constants
  dlg_about_dialog_ResID = idd_dlg_about
  dlg_about_dialog_DlgType = wd_Modal
  dlg_about_dialog_Help = Contents

predicates
  dlg_about_dialog_eh : EHANDLER

clauses
  dlg_about_dialog_Create(Parent):-
	win_CreateResDialog(Parent,dlg_about_dialog_DlgType,dlg_about_dialog_ResID,dlg_about_dialog_eh,0),!.

  dlg_about_dialog_eh(Win,e_Create(_),0):-!,
	program_font(Font,_),
	CtrlWin1 = win_GetCtlHandle(Win,idc_dlg_about_st_prj),
	win_SetFont(CtrlWin1,Font),
	CtrlWin2 = win_GetCtlHandle(Win,idc_about_dialog_4),
	win_SetFont(CtrlWin2,Font),
	CtrlWin3 = win_GetCtlHandle(Win,idc_about_dialog_6),
	win_SetFont(CtrlWin3,Font),
	CtrlWin4 = win_GetCtlHandle(Win,idc_about_dialog_7),
	win_SetFont(CtrlWin4,Font),
	CtrlWin5 = win_GetCtlHandle(Win,idc_ok),
	win_SetFont(CtrlWin5,Font),!.

  dlg_about_dialog_eh(_Win,e_Control(idc_ok,_CtrlType,_CtrlWin,_CtrlInfo),0):-!,
	win_Destroy(_Win),!.

%END_DLG About dialog

  pv_cb(PVWin,event(e_Destroy)):-
	retract(preview(PVWin,_,_)),!.

  pv_cb(PVWin,go_to_source):-
	Win = win_GetParent(PVWin),
	task_win_eh(Win,e_Menu(id_file_close,0)),!.

  edit_SetPressedButton_my(id_elements_edit):-
	em_SetPressedButton(edit_mode),!.
  edit_SetPressedButton_my(id_text):-
	em_SetPressedButton(text),!.
  edit_SetPressedButton_my(id_counter):-
	em_SetPressedButton(counter),!.
  edit_SetPressedButton_my(id_bitmap):-
	em_SetPressedButton(bitmap),!.
  edit_SetPressedButton_my(id_rectangle):-
	em_SetPressedButton(rectangle),!.
  edit_SetPressedButton_my(id_circle):-
	em_SetPressedButton(circle),!.
  edit_SetPressedButton_my(id_line):-
	em_SetPressedButton(line),!.

  le_cb(LEWin,event(e_GetFocus),continue):-
	page(LEWin,_,_,_,_,_,_,_,_,_,_,_,_,_,_,Scale,_,_,_,Mode),
	Win = win_GetParent(LEWin),
	reset_step(Scale),
	toolbar_SetValue(Win,id_zoom,lbut_value(b_true,Scale)),
	edit_SetPressedButton_my(Mode),
	menu_uncheck(Win),
	menu_Check(Win,Mode,b_true),
	retractall(focus_win(_)),
	assert(focus_win(LEWin)),!,fail.

  le_cb(LEWin,event(e_Destroy),continue):-
	retractall(page(LEWin,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_)),
	not(page(_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_)),
	Win = win_GetParent(LEWin),
	property_destroy(Win),
	align_destroy(Win),
	palette_destroy(Win),
	menu_change(Win,empty_win),!.

  le_cb(LEWin,event(e_CloseRequest()),stop):-
	Win = win_GetParent(LEWin),
	task_win_eh(Win,e_Menu(id_file_close,0)),!.

  le_cb(_,user_action(property_destroy),continue):-
	retract(property_tobe),
	Win1 = vpi_GetAttrVal(attr_task_window),
	Win = cast(window,Win1),
	menu_Check(Win,id_property,b_false),!.
  le_cb(_,user_action(align_destroy),continue):-
	retract(align_tobe),
	Win1 = vpi_GetAttrVal(attr_task_window),
	Win = cast(window,Win1),
	menu_Check(Win,id_align,b_false),!.
  le_cb(_,user_action(palette_destroy),continue):-
	retract(palette_tobe),
	Win1 = vpi_GetAttrVal(attr_task_window),
	Win = cast(window,Win1),
	menu_Check(Win,id_palette,b_false),!.
  le_cb(_,user_action(property_create),continue):-
	not(property_tobe),
	assert(property_tobe),
	Win1 = vpi_GetAttrVal(attr_task_window),
	Win = cast(window,Win1),
	menu_Check(Win,id_property,b_true),!.
  le_cb(_,user_action(align_create),continue):-
	not(align_tobe),
	assert(align_tobe),
	Win1 = vpi_GetAttrVal(attr_task_window),
	Win = cast(window,Win1),
	menu_Check(Win,id_align,b_true),!.
  le_cb(_,user_action(palette_create),continue):-
	not(palette_tobe),
	assert(palette_tobe),
	Win1 = vpi_GetAttrVal(attr_task_window),
	Win = cast(window,Win1),
	menu_Check(Win,id_palette,b_true),!.

  le_cb(LEWin,user_action(create_field),continue):-
	auto_edit_status(b_true),
	Win = win_GetParent(LEWin),
	task_win_eh(Win,e_Menu(id_elements_edit,0)),!.

  le_cb(LEWin,user_action(page_change),continue):-
	Win = win_GetParent(LEWin),
	task_win_eh(Win,e_Menu(id_edit_type,0)),!.
  le_cb(LEWin,user_action(page_setup),continue):-
	Win = win_GetParent(LEWin),
	program_font(Font,_),
	pageset_get_current1(Win,Font),
	pageset_get_default(Number,FormPage,ColorPage,Comment,LeftMarg,TopMarg,
	HorSpace,VertSpace,LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,Landscape),
	LEWin = win_GetActiveWindow(),
	retract(page(LEWin,_,_,_,_,_,_,_,_,_,_,_,_,_,_,Scale,Saved,Name,_,Mode)),
	assert(page(LEWin,Number,FormPage,ColorPage,Comment,LeftMarg,TopMarg,
	HorSpace,VertSpace,LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,Landscape,Scale,Saved,Name,b_true,Mode)),
	page_init(LEWin,Number,NoHor,NoVert,Page_Roll,Landscape,LabelWidth,LabelHeight,ColorPage,FormPage),!.

  le_cb(LEWin,user_action(modified),continue):-
	retract(page(LEWin,Number,FormPage,ColorPage,Comment,LeftMarg,TopMarg,HorSpace,VertSpace,
	LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,Landscape,Scale,Saved,Name,_,Mode)),
	assert(page(LEWin,Number,FormPage,ColorPage,Comment,LeftMarg,TopMarg,HorSpace,VertSpace,
	LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,Landscape,Scale,Saved,Name,b_true,Mode)),!.

  le_cb(LEWin,user_action(go_to_preview),continue):-
	Win = win_GetParent(LEWin),
	task_win_eh(Win,e_Menu(id_print_preview,0)),!.

  save_file(_,idc_cancel):-!.
  save_file(LEWin,idc_yes):-
	Win = win_GetParent(LEWin),
	task_win_eh(Win,e_Menu(id_file_save,0)),
	retract(page(LEWin,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_)),!,fail.
  save_file(LEWin,idc_no):-
	retract(page(LEWin,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_)),!,fail.

  get_file_name(_,_,b_true,Name,Name):-!.
  get_file_name(Title,LEWin,b_false,_,Name):-
	syspath(Path,_),
	disk(Path),
	Name1 = dlg_GetSaveFileName("*.lab",[label_msg176,"*.lab",label_msg177,"*.*"],Title),
	Name1 <> "",
	filenameext(Name,Name1,".lab"),
	retract(page(LEWin,Number,FormPage,ColorPage,Comment,LeftMarg,TopMarg,
	HorSpace,VertSpace,LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,Landscape,Scale,
	_,_,Modified,Mode)),
	assert(page(LEWin,Number,FormPage,ColorPage,Comment,LeftMarg,TopMarg,
	HorSpace,VertSpace,LabelWidth,LabelHeight,NoHor,NoVert,Page_Roll,Landscape,Scale,
	b_true,Name,Modified,Mode)),!.

predicates
  dialog_ask_eh : EHANDLER
clauses
  dialog_Ask(Str,ButtonNo):-
	TaskWin1 = vpi_GetAttrVal(attr_task_window),
	TaskWin = cast(window,TaskWin1),
	concat(Str," ?",Str1),
	dialog_Create(TaskWin,[resdlg(idd_ask,wd_Modal)],
  		[
		df(idct_ask_1,statictext(label_msg166),nopr),
		df(idct_ask_2,statictext(Str1),nopr),
		df(idc_yes,pushbutton(label_msg187),nopr),
		df(idc_no,pushbutton(label_msg188),nopr),
		df(idc_cancel,pushbutton(label_msg181),nopr)
  		],
		dialog_ask_eh,0,_,_),
	retract(ask_button(ButtonNo)),!.

  dialog_ask_eh(Win,e_Create(_),0):-
	program_font(Font,_),
	Ctl1 = win_GetCtlHandle(Win,idct_ask_1),
	win_SetFont(Ctl1,Font),
	Ctl2 = win_GetCtlHandle(Win,idct_ask_2),
	win_SetFont(Ctl2,Font),
	Ctl3 = win_GetCtlHandle(Win,idc_yes),
	win_SetFont(Ctl3,Font),
	Ctl4 = win_GetCtlHandle(Win,idc_no),
	win_SetFont(Ctl4,Font),
	Ctl5 = win_GetCtlHandle(Win,idc_cancel),
	win_SetFont(Ctl5,Font),!.
  dialog_ask_eh(Win,e_Control(Id,_,_,activated()),0):-
	assert(ask_button(Id)),
	win_Destroy(Win),!.

predicates
  dialog_stretch_eh : EHANDLER
clauses
  dialog_Stretch(Win,b_false):-
	le_fields(Win,Information,_,_),
	Information = [],!.
  dialog_Stretch(_,ButtonNo):-
	TaskWin1 = vpi_GetAttrVal(attr_task_window),
	TaskWin = cast(window,TaskWin1),
	dialog_Create(TaskWin,[resdlg(idd_stretch,wd_Modal)],
  		[
		df(idct_ask_1,statictext(label_msg229),nopr),
		df(idc_yes,pushbutton(label_msg187),nopr),
		df(idc_no,pushbutton(label_msg188),nopr),
		df(idc_cancel,pushbutton(label_msg181),nopr)
  		],
		dialog_stretch_eh,0,_,_),
	retract(stretch_button(ButtonNo)),!.

  dialog_stretch_eh(Win,e_Create(_),0):-
	program_font(Font,_),
	Ctl1 = win_GetCtlHandle(Win,idct_ask_1),
	win_SetFont(Ctl1,Font),
	Ctl3 = win_GetCtlHandle(Win,idc_yes),
	win_SetFont(Ctl3,Font),
	Ctl4 = win_GetCtlHandle(Win,idc_no),
	win_SetFont(Ctl4,Font),
	Ctl5 = win_GetCtlHandle(Win,idc_cancel),
	win_SetFont(Ctl5,Font),!.
  dialog_stretch_eh(Win,e_Control(idc_yes,_,_,activated()),0):-
	assert(stretch_button(b_true)),
	win_Destroy(Win),!.
  dialog_stretch_eh(Win,e_Control(idc_no,_,_,activated()),0):-
	assert(stretch_button(b_false)),
	win_Destroy(Win),!.

  toolbar_creatempty(Win):-
	TBWin = toolbar_create(tb_top,0xC0C0C0,Win,[tb_ctrl(id_file_new,pushb,idb_new_up,idb_new_dn,idb_new_dn,label_msg150,b_true,b_true)],
		tb_callback),
	assert(toolbar_win(TBWin)),!.

predicates
  toolbar_change(INTEGER Situation)
clauses
  toolbar_change(layout_win):-
	toolbar_win(TBWin),
	toolbar_reload(TBWin,
[tb_ctrl(id_file_new,	pushb,	idb_new_up,idb_new_dn,idb_new_dn,	label_msg150,b_true,b_true),
tb_ctrl(id_file_open,	pushb,	idb_open_up,idb_open_dn,idb_open_dn,	label_msg151,b_true,b_true),
tb_ctrl(id_file_save,	pushb,	idb_save_up,idb_save_dn,idb_save_dn,	label_msg152,b_true,b_true),
separator,
tb_ctrl(id_printing,	pushb,	idb_print_up,idb_print_dn,idb_print_dn,	label_msg153,b_true,b_true),
tb_ctrl(id_print_preview,pushb,	idb_preview_up,idb_preview_dn,idb_preview_dn,label_msg154,b_true,b_true),
separator,
tb_ctrl(id_edit_type,	pushb,	idb_page_up,idb_page_dn,idb_page_dn,	label_msg155,b_true,b_true),
separator,
tb_ctrl(id_edit_front,	pushb,	idb_front_up,idb_front_dn,idb_front_dn,	label_msg163,b_true,b_true),
tb_ctrl(id_edit_back,	pushb,	idb_back_up,idb_back_dn,idb_back_dn,	label_msg164,b_true,b_true),
separator,
tb_lbut(id_zoom,	100,	["200 %","150 %","100 %","75 %","50 %"],b_true,2),
separator,
tb_ctrl(id_help,	pushb,	idb_help_up,idb_help_dn,idb_help_dn,label_msg165,b_true,b_true)]),

	em_enable(),!.
  toolbar_change(empty_win):-
	toolbar_win(TBWin),
	toolbar_reload(TBWin,
[tb_ctrl(id_file_new,	pushb,	idb_new_up,idb_new_dn,idb_new_dn,	label_msg150,b_true,b_true),
tb_ctrl(id_file_open,	pushb,	idb_open_up,idb_open_dn,idb_open_dn,	label_msg151,b_true,b_true),
separator,
tb_ctrl(id_edit_type,	pushb,	idb_page_up,idb_page_dn,idb_page_dn,	label_msg155,b_true,b_true),
separator,
tb_ctrl(id_help,	pushb,	idb_help_up,idb_help_dn,idb_help_dn,label_msg165,b_true,b_true)]),
	em_disable(),!.
  toolbar_change(printpreview_win):-
	toolbar_win(TBWin),
	toolbar_reload(TBWin,
[tb_ctrl(id_printing,	pushb,	idb_print_up,idb_print_dn,idb_print_dn,	label_msg153,b_true,b_true),
separator,
tb_lbut(id_zoom,	100,	["200 %","150 %","100 %","75 %","50 %"],b_true,2),
separator,
tb_ctrl(id_help,	pushb,	idb_help_up,idb_help_dn,idb_help_dn,label_msg165,b_true,b_true)]),
	em_disable(),!.

predicates
  menu_change_file(INTEGER Situation,MENU_ITEM)
clauses
  menu_change_file(layout_win,MenuItem):-
	get_opening_files(Files),
	MenuItem = txt(1,label_msg190,0,1,0,[
		txt(id_file_new,label_msg191,0,1,0,[]),
		txt(id_file_open,label_msg192,0,1,0,[]),
		txt(id_file_save,label_msg193,0,1,0,[]),
		txt(id_file_save_as,label_msg194,0,1,0,[]),
		txt(id_file_close,label_msg242,0,1,0,[]),
		separator,
		txt(id_print_preview,label_msg195,0,1,0,[]),
		txt(id_printing,label_msg196,0,1,0,[]),
		separator,
		txt(id_file_exit,label_msg197,0,1,0,[])|Files]),!.
  menu_change_file(empty_win,MenuItem):-
	get_opening_files(Files),
	MenuItem = txt(1,label_msg190,0,1,0,[
		txt(id_file_new,label_msg191,0,1,0,[]),
		txt(id_file_open,label_msg192,0,1,0,[]),
		separator,
		txt(id_file_exit,label_msg197,0,1,0,[])|Files]),!.
  menu_change_file(printpreview_win,MenuItem):-
	MenuItem = txt(1,label_msg190,0,1,0,[
		txt(id_file_close,label_msg242,0,1,0,[]),
		separator,
		txt(id_printing,label_msg196,0,1,0,[]),
		separator,
		txt(id_file_exit,label_msg197,0,1,0,[])]),!.

predicates
  menu_change_edit(MENU_ITEM)
clauses
  menu_change_edit(MenuItem):-
	MenuItem = txt(1,label_msg198,0,1,0,[
		txt(id_edit_undo,label_msg199,0,1,0,[]),
		txt(id_edit_redo,label_msg200,0,1,0,[]),
		separator,
		txt(id_edit_cut,label_msg201,0,1,0,[]),
		txt(id_edit_copy,label_msg202,0,1,0,[]),
		txt(id_edit_paste,label_msg203,0,1,0,[]),
		txt(id_edit_delete,label_msg204,0,1,0,[]),
		separator,
		txt(id_edit_front,label_msg205,0,1,0,[]),
		txt(id_edit_back,label_msg206,0,1,0,[])]),!.

predicates
  menu_change_view(INTEGER Situation,MENU_ITEM)
clauses
  menu_change_view(layout_win,MenuItem):-
	MenuItem = txt(1,label_msg209,0,1,0,[
		txt(id_real_size,label_msg211,0,1,0,[]),
		txt(id_zoom_in,label_msg212,0,1,0,[]),
		txt(id_zoom_out,label_msg213,0,1,0,[]),
		separator,
		txt(id_screen_update,label_msg214,0,1,0,[]),
		separator,
		txt(id_property,label_msg119,0,1,0,[]),
		txt(id_align,label_msg225,0,1,0,[]),
		txt(id_palette,label_msg234,0,1,0,[])]),!.
  menu_change_view(printpreview_win,MenuItem):-
	MenuItem = txt(1,label_msg209,0,1,0,[
		txt(id_real_size,label_msg211,0,1,0,[]),
		txt(id_zoom_in,label_msg212,0,1,0,[]),
		txt(id_zoom_out,label_msg213,0,1,0,[])]),!.

predicates
  menu_change_auto_edit(MENU_ITEM)
clauses
  menu_change_auto_edit(MenuItem):-
	auto_edit_status(b_false),
	MenuItem = txt(id_auto_edit,label_msg238,0,1,0,[]),!.
  menu_change_auto_edit(MenuItem):-
	auto_edit_status(b_true),
	MenuItem = txt(id_auto_edit,label_msg238,0,1,1,[]),!.

predicates
  menu_change_print_border(MENU_ITEM)
clauses
  menu_change_print_border(MenuItem):-
	print_border_status(b_false),
	MenuItem = txt(id_print_border,label_msg247,0,1,0,[]),!.
  menu_change_print_border(MenuItem):-
	print_border_status(b_true),
	MenuItem = txt(id_print_border,label_msg247,0,1,1,[]),!.

predicates
  menu_change_elements(INTEGER Situation,MENU_ITEM)
clauses
  menu_change_elements(layout_win,MenuItem):-
	MenuItem = txt(1,label_msg215,0,1,0,[
		txt(id_elements_edit,label_msg216,0,1,1,[]),
		separator,
		txt(id_text,label_msg217,0,1,0,[]),
		txt(id_counter,label_msg218,0,1,0,[]),
		txt(id_bitmap,label_msg219,0,1,0,[]),
		separator,
		txt(id_rectangle,label_msg220,0,1,0,[]),
		txt(id_circle,label_msg221,0,1,0,[]),
		txt(id_line,label_msg222,0,1,0,[])]),!.

predicates
  menu_change_options(MENU_ITEM)
clauses
  menu_change_options(MenuItem):-
	menu_change_auto_edit(AutoEdit),
	menu_change_print_border(PrintBorder),
	MenuItem = txt(1,label_msg246,0,1,0,[
		txt(id_edit_type,label_msg207,0,1,0,[]),
		txt(id_font,label_msg208,0,1,0,[]),
		AutoEdit,PrintBorder]),!.

predicates
  menu_change_help(MENU_ITEM)
clauses
  menu_change_help(MenuItem):-
	MenuItem = txt(1,label_msg223,0,1,0,[
		txt(id_help_about,label_msg226,0,1,0,[])]),!.

predicates
  toolbar_set(INTEGER Situation)
clauses
  toolbar_set(Situation):-
	toolbar_status(Situation),!.
  toolbar_set(Situation):-
	retractall(toolbar_status(_)),
	assert(toolbar_status(Situation)),
	toolbar_change(Situation),!.

  menu_change(Win,layout_win):-
	menu_change_file(layout_win,FileItem),
	menu_change_edit(EditItem),
	menu_change_view(layout_win,ViewItem),
	menu_change_elements(layout_win,ElementsItem),
	menu_change_options(OptionsItem),
	menu_change_help(HelpItem),
	Menu = dyn_menu([FileItem,EditItem,ViewItem,ElementsItem,OptionsItem,HelpItem]),
	menu_Set(Win,Menu),
	menu_SetText(Win,id_window_tile,label_msg239),
	menu_SetText(Win,id_window_cascade,label_msg240),
	menu_SetText(Win,id_window_arricons,label_msg241),
	menu_list(Win,[id_window_tile,id_window_cascade,id_window_arricons],b_true),
	toolbar_set(layout_win),!.
  menu_change(Win,empty_win):-
	menu_change_file(empty_win,FileItem),
	menu_change_options(OptionsItem),
	menu_change_help(HelpItem),
	Menu = dyn_menu([FileItem,OptionsItem,HelpItem]),
	menu_Set(Win,Menu),
	menu_SetText(Win,id_window_tile,label_msg239),
	menu_SetText(Win,id_window_cascade,label_msg240),
	menu_SetText(Win,id_window_arricons,label_msg241),
	menu_list(Win,[id_window_tile,id_window_cascade,id_window_arricons],b_false),
	toolbar_set(empty_win),!.
  menu_change(Win,printpreview_win):-
	menu_change_file(printpreview_win,FileItem),
	menu_change_view(printpreview_win,ViewItem),
	menu_change_options(OptionsItem),
	menu_change_help(HelpItem),
	Menu = dyn_menu([FileItem,ViewItem,OptionsItem,HelpItem]),
	menu_Set(Win,Menu),
	menu_SetText(Win,id_window_tile,label_msg239),
	menu_SetText(Win,id_window_cascade,label_msg240),
	menu_SetText(Win,id_window_arricons,label_msg241),
	menu_list(Win,[id_window_tile,id_window_cascade,id_window_arricons],b_false),
	toolbar_set(printpreview_win),!.
























































































