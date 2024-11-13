/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:	TRANS
 FileName:	TRANS.PRO
 Purpose:	Transportation demo application
 Written by:	Andrey Skobelev
 Comments:
******************************************************************************/

include "trans.inc"
include "trans.con"
include "hlptopic.con"
include "tableed.pre"
include "editform.pre"
include "maphndl.pre"
include "calc.pre"
include "reptool.pre"

%BEGIN_WIN Task Window
/***************************************************************************
	Event handling for Task Window
***************************************************************************/

predicates

  task_win_eh : EHANDLER
procedure  trans
procedure  id_conv_con(INTEGER MenuId,INTEGER FormId)
procedure  get_save_name(STRING Path,STRING FileName)
procedure  start_init
procedure  set_NameToToolbar
determ	   save_Changes
procedure  set_MenuEnabled

constants

%BEGIN Task Window, CreateParms, 18:20:52-25.11.1999, Code automatically updated!
  task_win_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Close,wsf_Maximize,wsf_Minimize,wsf_ClipSiblings]
  task_win_Menu  = res_menu(idr_task_menu)
  task_win_Title = "Logistics demo"
  task_win_Help  = idh_contents
%END Task Window, CreateParms

database - trans_plan_db
	status_window(WINDOW)
	timerId(WINDOW,LONG ID)
clauses

%BEGIN Task Window, e_Create
  task_win_eh(_Win,e_Create(_),0):-!,
%BEGIN Task Window, InitControls, 18:20:52-25.11.1999, Code automatically updated!
%END Task Window, InitControls
%BEGIN Task Window, ToolbarCreate, 18:20:52-25.11.1999, Code automatically updated!
	tb_project_toolbar_Create(_Win),
	tb_help_line_Create(_Win),
%END Task Window, ToolbarCreate
ifdef use_message
	msg_Create(100),
enddef
% *********** Register class for Table editor  custom control************
	class_Create(tableed_class,tableed_class_handler),
% *********** Register class for Map custom control************
	class_Create("mapctrl",mapctrl_class_handler),
% *********** Register class for Report************
	class_Create("rp_progress",prgrs_eh),
  	start_init(),
	!.
%END Task Window, e_Create

%BEGIN Task Window, e_Destroy
  task_win_eh(_Win,e_Destroy(),0):-!,
% ********* Destroy class for Table editor custom control***************
	class_Destroy(tableed_class),
% ********* Destroy class for Map custom control***************
	class_Destroy("mapctrl"),
% ********* Destroy class for Report***************
	class_Destroy("rp_progress"),
	fail.
%END Task Window, e_Destroy

%MARK Task Window, new events

%BEGIN Task Window, id_plan_overview
  task_win_eh(_Win,e_Menu(id_plan_overview,_ShiftCtlAlt),0):-
	report_plan_overview(_Win),
	!.
%END Task Window, id_plan_overview

%BEGIN Task Window, id_font
  task_win_eh(_Win,e_Menu(id_font,_ShiftCtlAlt),0):-
	ini_db_font(OldFont),!,
	NewFont = dlg_ChooseFont(OldFont,_NewFontName,_),% Get FontName from dlg_ChooseFont
	retractAll(ini_db_font(_)),
	assert(ini_db_font(NewFont)),
	ef_set_font().
%END Task Window, id_font

%BEGIN Task Window, e_CloseRequest
  task_win_eh(_Win,e_CloseRequest(),0):-
	% Break exit if Cancel pressed
	not(save_Changes),
	!.
  task_win_eh(_Win,e_CloseRequest(),0):-
	% save layout for forms and map
	mv_StoreLayout,
	ef_write_formRct,!,fail.
%END Task Window, e_CloseRequest

%BEGIN Task Window, id_generation
  task_win_eh(_Win,e_Menu(id_generation,_ShiftCtlAlt),0):-
	% Plan generation
	ef_changeRegister,
	trans,
	ef_outforms_Update,
	mv_MapRefresh(),
	set_GenStatusToToolbar(),
	!.
%END Task Window, id_generation

%BEGIN Task Window, id_file_save
  task_win_eh(_Win,e_Menu(id_file_save,_ShiftCtlAlt),0):-!,
	% Save data,plan and reassert new path of dataset
	get_save_name(PathStart,FileName),
	OSFileName = dlg_GetFileName(FileName,["*.dba","*.dba"],
	"Save Plan & Data base",[],PathStart,_SLIST),
	syspath(Path,_Name),
	filenamereduce(OSFileName,Path,ReducedFileName),
	trap(save(OSFileName,trans_db),_,fail),
	retractAll(ini_db_name(_)),
	assert(ini_db_name(ReducedFileName)),
	set_NameToToolbar,
	ef_changeUnRegister(),
	!.
%END Task Window, id_file_save

%BEGIN Task Window, id_file_open
  task_win_eh(_Win,e_Menu(id_file_open,_ShiftCtlAlt),0):-
	% Break if Cancel pressed
	not(save_Changes),
	!.
  task_win_eh(_Win,e_Menu(id_file_open,_ShiftCtlAlt),0):-!,
	% Open dataset(data,plan), reassert new path of dataset and
	% refresh forms, map
	get_save_name(PathStart,FileName),
	OSFileName = dlg_GetFileName(FileName,["*.dba","*.dba"],
	"Open Plan & Data base",[],PathStart,_SLIST),
	ef_clear_Data,
	retractAll(genStatus(_,_,_,_,_,_,_)),
	syspath(Path,_Name),
	filenamereduce(OSFileName,Path,ReducedFileName),
	assert(ini_db_name(ReducedFileName)),
	trap(consult(OSFileName,trans_db),_,fail),
	set_NameToToolbar,
	ef_forms_Update,
	mv_MapRefresh(),
	ef_changeUnRegister(),
	set_MenuEnabled,	
	!.
%END Task Window, id_file_open

%BEGIN Task Window, id_file_new
  task_win_eh(_Win,e_Menu(id_file_new,_ShiftCtlAlt),0):-
	% Break if Cancel pressed
	not(save_Changes),
	!.
  task_win_eh(_Win,e_Menu(id_file_new,_ShiftCtlAlt),0):-!,
	ef_clear_Data,
	retractAll(genStatus(_,_,_,_,_,_,_)),
	set_NameToToolbar,
	mv_MapRefresh(),
	ef_forms_Update,
	ef_changeUnRegister(),
	set_MenuEnabled,	
	!.
%END Task Window, id_file_new

%BEGIN Task Window, id_Transportation_overview_grouped_by_sorts
  task_win_eh(_Win,e_Menu(id_Transportation_overview_grouped_by_sorts,_ShiftCtlAlt),0):-
	report_troverview_sort(_Win),
	!.
%END Task Window, id_Transportation_overview_grouped_by_sorts

%BEGIN Task Window, id_Transportation_overview_grouped_by_producers
  task_win_eh(_Win,e_Menu(id_Transportation_overview_grouped_by_producers,_ShiftCtlAlt),0):-
	report_troverview_producer(_Win),
	!.
%END Task Window, id_Transportation_overview_grouped_by_producers

%BEGIN Task Window, id_Transportation_overview_grouped_by_customers
  task_win_eh(_Win,e_Menu(id_Transportation_overview_grouped_by_customers,_ShiftCtlAlt),0):-
	report_troverview_customer(_Win),
	!.
%END Task Window, id_Transportation_overview_grouped_by_customers

%BEGIN Task Window, id_Reports_supply_overview
  task_win_eh(_Win,e_Menu(id_Reports_supply_overview,_ShiftCtlAlt),0):-
	report_supply_overview(_Win),
	!.
%END Task Window, id_Reports_supply_overview

%BEGIN Task Window, id_Reports_customer_overview
  task_win_eh(_Win,e_Menu(id_Reports_customer_overview,_ShiftCtlAlt),0):-
	report_custom_overview(_Win),
	!.
%END Task Window, id_Reports_customer_overview

%BEGIN Task Window, id_Map_view
  task_win_eh(TaskWin,e_Menu(id_Map_view,_ShiftCtlAlt),0):-!,
	mv_ShowMap(TaskWin).
%END Task Window, id_Map_view

%BEGIN Task Window, id_Map_edit
  task_win_eh(TaskWin,e_Menu(id_Map_edit,_ShiftCtlAlt),0):-!,
	mv_EditMap(TaskWin).
%END Task Window, id_Map_edit

%BEGIN Task Window, id_help_about
  task_win_eh(Win,e_Menu(id_help_about,_ShiftCtlAlt),0):-!,
	dlg_about_dialog_Create(Win),
	!.
%END Task Window, id_help_about

%BEGIN Task Window, id_file_exit
  task_win_eh(_Win,e_Menu(id_file_exit,_ShiftCtlAlt),0):-
	% Break exit if Cancel pressed
	not(save_Changes),
	!.
  task_win_eh(Win,e_Menu(id_file_exit,_ShiftCtlAlt),0):-
	mv_StoreLayout,
	ef_write_formRct,
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

% Create form from menu
  task_win_eh(_Win,e_Menu(MenuId,_ShiftCtlAlt),0):-
	id_conv_con(MenuId,FormId), not(FormId = 0),
	ef_form_Create(FormId,[]),
	!,fail.

%END_WIN Task Window

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
  vpi_Init(task_win_Flags,task_win_eh,task_win_Menu,"trans",task_win_Title).

%BEGIN_TLB Project toolbar, 18:21:04-25.11.1999, Code automatically updated!
/**************************************************************************
	Creation of toolbar: Project toolbar
**************************************************************************/

clauses

  tb_project_toolbar_Create(_Parent):-
ifdef use_tbar
	toolbar_create(tb_top,0xC0C0C0,_Parent,
		[tb_ctrl(id_file_new,pushb,idb_new_up,idb_new_dn,idb_new_up,"New;New database",1,1),
		 tb_ctrl(id_file_open,pushb,idb_open_up,idb_open_dn,idb_open_up,"Open;Open database",1,1),
		 tb_ctrl(id_file_save,pushb,idb_save_up,idb_save_dn,idb_save2,"Save;Database save",0,1),
		 separator,
		 tb_ctrl(id_generation,pushb,idb_gen,idb_gen1,idb_gen2,"Generation;Plan generation",0,1),
		 separator,
		 tb_ctrl(id_Map_view,pushb,idb_mapv,idb_mapv1,idb_mapv2,"Map view;Map view",0,1),
		 tb_ctrl(id_Map_edit,pushb,idb_mape,idb_mapv1,idb_mape2,"Map edit;Map edit",0,1),
		 separator,
		 separator]),
enddef
	true.
%END_TLB Project toolbar





%BEGIN_TLB Help line, 18:21:22-25.11.1999, Code automatically updated!
/**************************************************************************
	Creation of toolbar: Help line
**************************************************************************/

clauses

  tb_help_line_Create(_Parent):-
ifdef use_tbar
	toolbar_create(tb_bottom,0xC0C0C0,_Parent,
		[tb_text(idt_2,tb_static,212,0,1,10,0x0,""),
		 tb_text(idt_DataSetName,tb_static,160,0,1,10,0x0,""),
		 tb_text(idt_help_line,tb_context,452,0,4,10,0x0,"")]),
enddef
	true.
%END_TLB Help line











%BEGIN_DLG About dialog
/**************************************************************************
	Creation and event handling for dialog: About dialog
**************************************************************************/

constants

%BEGIN About dialog, CreateParms, 12:57:54-26.11.1999, Code automatically updated!
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

/*********************************************************************************/
  set_MenuEnabled:-
  	NULLWIN=cast(window,0),
  	TMP = win_GetAttrVal(NULLWIN, attr_task_window),
  	Win =cast(window,TMP),
  	menu_Enable(Win,id_file_save,b_true),
  	menu_Enable(Win,id_producer,b_true),
  	menu_Enable(Win,id_customer,b_true),
  	menu_Enable(Win,id_sort,b_true),
  	menu_Enable(Win,id_production,b_true),
  	menu_Enable(Win,id_custom,b_true),
  	menu_Enable(Win,id_move,b_true),
  	menu_Enable(Win,id_unplaced,b_true),
  	menu_Enable(Win,id_needs,b_true),
  	menu_Enable(Win,id_distance,b_true),
  	menu_Enable(Win,id_generation,b_true),
  	menu_Enable(Win,id_plan_overview,b_true),
  	menu_Enable(Win,id_Reports_supply_overview,b_true),
  	menu_Enable(Win,id_Reports_customer_overview,b_true),
  	menu_Enable(Win,id_Reports_transportation_overview,b_true),
  	menu_Enable(Win,id_Map_view,b_true),
  	menu_Enable(Win,id_Map_edit,b_true),
  	menu_Enable(Win,id_Transportation_overview_grouped_by_sorts,b_true),
  	menu_Enable(Win,id_Transportation_overview_grouped_by_producers,b_true),
  	menu_Enable(Win,id_Transportation_overview_grouped_by_customers,b_true),
	toolbar_SetValue(Win, id_file_save, ctrl_value(b_true,b_true)),
	toolbar_SetValue(Win, id_generation, ctrl_value(b_true,b_true)),
	toolbar_SetValue(Win, id_Map_view, ctrl_value(b_true,b_true)),
	toolbar_SetValue(Win, id_Map_edit, ctrl_value(b_true,b_true)).
 	
predicates
determ	   save_Changes1(INTEGER ButtonNum)
clauses

  save_Changes():-
	ef_change_Notify(ButtonNum),
	save_Changes1(ButtonNum),
	!.

  save_Changes1(ButtonNum):-
	ButtonNum = 1, % Yes - Save dataset,plan
	get_save_name(Path,FileName),
	concat(Path,FileName,SaveFileName),
	save(SaveFileName,trans_db),
	!.
  save_Changes1(ButtonNum):-
	ButtonNum = 2, % NO
	!.
  save_Changes1(ButtonNum):-
	ButtonNum = 3, % Cancel
	!,fail.


% Set path of dataset to toolbar
  set_NameToToolbar():-
	TaskWin = cast(window,vpi_GetAttrVal(attr_task_window)),
	ini_db_name(ReducedFileName),
	toolbar_SetValue(TaskWin,idt_DataSetName,text_value(ReducedFileName)),
	set_GenStatusToToolbar,
	!.
  set_NameToToolbar():-
	TaskWin = cast(window,vpi_GetAttrVal(attr_task_window)),
	toolbar_SetValue(TaskWin,idt_DataSetName,text_value(default_FileName)),
	set_GenStatusToToolbar,
	!.
	
% Start initialization: path of dataset, form and map layout
  start_init():-
	retractAll(_,trans_db),
	ef_read_formRct,
	fail.
  start_init():-
	ini_db_name(ReducedFileName),
	trap(consult(ReducedFileName,trans_db),_,fail),
	set_MenuEnabled,
	set_NameToToolbar,
	fail.
  start_init():-
	not(ini_db_font(_)),
	Font = font_Create(ff_helvetica,[],10),
	assert(ini_db_font(Font)),
	fail.
  start_init():-
	ini_db_layout(IDFORM,_,b_true),
	ef_form_Create(IDFORM,[]),
	fail.
  start_init():-
	ini_map_layout(_,_,b_true),
	TaskWin = cast(window,vpi_GetAttrVal(attr_task_window)),
	mv_ShowMap(TaskWin),
	fail.
  start_init():-!.


  get_save_name(Path,FileName):- 
	ini_db_name(QualName),
	filenamepath(QualName,Path,FileName),
	!.
  get_save_name("",default_FileName):-!.

  % menu Id to form Id convertion
  id_conv_con(id_producer,con_producer):-!.
  id_conv_con(id_customer,con_customer):-!.
  id_conv_con(id_sort,con_sort):-!.
  id_conv_con(id_production,con_production):-!.
  id_conv_con(id_custom,con_custom):-!.
  id_conv_con(id_distance,con_distance):-!.
  id_conv_con(id_move,con_move):-!.
  id_conv_con(id_unplaced,con_unplaced):-!.
  id_conv_con(id_needs,con_needs):-!.
  id_conv_con(_,0):-!.

predicates
  dlg_status_eh : EHANDLER
  ani_eh : EHANDLER
procedure  dlg_status_Create(WINDOW Parent)
procedure  draw_animation(WINDOW)
procedure  cancel_Plan()
clauses
    
% Break plan calculation and break animation
  cancel_Plan():-
	status_window(_Win),
	calc_break(),
	retract(timerId(_,TimerId)),!,
	timer_Kill(TimerId),
	!.
  cancel_Plan():-!.

% Create dialog for display of plan generation results 
  dlg_status_Create(Parent):-
	dialog_CreateModeless(Parent,idd_status,"",[],dlg_status_eh,0),!.
  
% Draw animation picture
  draw_animation(Win):-
	time(_Hours,_Minutes,Seconds,Hundredths),
	Picture = pict_GetFromRes(idb_animation),
	Pos = (Seconds + Hundredths/100)*16.67,
	Pos1 = val(integer,Pos),
	Pos2 = Pos1 - 1000,
	pict_Draw(Win,Picture,pnt(Pos1,1),rop_SrcCopy),
	pict_Draw(Win,Picture,pnt(Pos2,1),rop_SrcCopy),
	pict_Destroy(Picture),
	!.
  draw_animation(_):-!.

% Plan generation dialog HANDLER
  dlg_status_eh(Win,e_Create(_),_):-!,
	assert(status_window(Win)),
	RCT = win_GetClientRect(Win),
	RCT = rct(X,_Y,X1,Y1), Yw = Y1 - 45,
	win_Create(w_Child,rct(X,Yw,X1,Y1),"",no_menu,
	  Win,[wsf_ClipSiblings,wsf_ClipChildren],ani_eh,0),
	fail.
  dlg_status_eh(Win,e_CloseRequest(),_):-
	cancel_Plan(),
	retract(status_window(Win)),!,
	fail.
  dlg_status_eh(_Win,e_Control(idc_ok,wc_PushButton,_,activated()),_):-
	cancel_Plan(),
	fail.
  dlg_status_eh(Win,e_Control(idc_ok,wc_PushButton,_,activated()),_):-
	retract(status_window(Win)),!,
	win_Destroy(Win),fail.

% Animation window HANDLER
  ani_eh(Win,e_Create(_),0):-!,
	TimerId = timer_Set(Win,100),
	assert(timerId(Win,TimerId)),
	fail.
  ani_eh(Win,e_Timer(TimerId),0):-
	timerId(Win,TimerId),
	draw_animation(Win),
	!.
  ani_eh(Win,e_Update(_),0):-
	win_Clear(Win,color_LtGray),
	draw_animation(Win),
	!.
	
predicates
procedure  summ_rlist(RLIST,REAL,REAL)
clauses
  summ_rlist([],Out,Out):-!.
  summ_rlist([R|Rest],Curr,Out):-
	C = Curr + R,!,
	summ_rlist(Rest,C,Out).
  summ_rlist(_,_,0):-errorexit().

predicates
  nondeterm get_source(CALC_ITEM)
  nondeterm get_source(ULONG SortId,CALC_ITEM)
clauses
  get_source(Out):-
	tr_db_producer(Id,_,_,_,_),
	findall(Quantity,tr_db_production(Id,_,Quantity),QuantityList),
	summ_rlist(QuantityList,0,Quantity),
	Out = i(Id,Quantity).

  get_source(SortId,Out):-
	tr_db_production(Id,SortId,Quantity),
	Out = i(Id,Quantity).

predicates
  nondeterm get_target(CALC_ITEM)
  nondeterm get_target(ULONG SortId,CALC_ITEM)
clauses
  get_target(Out):-
	tr_db_customer(Id,_,_,_,_),
	findall(Quantity,tr_db_custom(Id,_,Quantity),QuantityList),
	summ_rlist(QuantityList,0,Quantity),
	Out = i(Id,Quantity).

  get_target(SortId,Out):-
	tr_db_custom(Id,SortId,Quantity),
	Out = i(Id,Quantity).

predicates
  nondeterm get_cost(CALC_COST)
clauses
  get_cost(Out):-
	tr_db_distance(FromId,ToId,Dist),
	Cost = val(real,Dist),
	Out = c(FromId,ToId,Cost).

predicates
determ  set_output_data(ULONG SortId,CALC_MOVELIST MoveList,CALC_ITEMLIST UnplacedList,CALC_ITEMLIST NeededList)
procedure round2d(REAL InputVal,REAL OutputVal)
clauses

  round2d(InputVal,OutputVal):-
	V1 = InputVal * 1000,
	V2 = round(V1),
	OutputVal = V2 / 1000,
	!.

  set_output_data(_,[],[],[]):-!.
  set_output_data(SortId,[m(FromId,ToId,Quantity)|Rest],UnplacedList,NeededList):-
	round2d(Quantity,Quantity1),
	assert(move(SortId,FromId,ToId,Quantity1)),!,
	set_output_data(SortId,Rest,UnplacedList,NeededList).
  set_output_data(SortId,[],[i(FromId,Quantity)|Rest],NeededList):-
	round2d(Quantity,Quantity1),
	assert(unplaced(SortId,FromId,Quantity1)),!,
	set_output_data(SortId,[],Rest,NeededList).
  set_output_data(SortId,[],[],[i(ToId,Quantity)|Rest]):-
	round2d(Quantity,Quantity1),
	assert(needed(SortId,ToId,Quantity1)),!,
	set_output_data(SortId,[],[],Rest).

predicates
procedure  set_status_title(STRING SortName,BOOLEAN Gen)
procedure  set_ProductionToDialog()
procedure  set_ProductionToDialog1(WINDOW ControlWin)
procedure  set_OrderToDialog()
procedure  set_OrderToDialog1(WINDOW ControlWin)
clauses

  set_ProductionToDialog():-
	status_window(Win),
	CtrlWinProduction = win_GetCtlHandle(Win,idc_p),
	set_ProductionToDialog1(CtrlWinProduction),
	!.
  set_ProductionToDialog():-!.
  
  set_ProductionToDialog1(CtrlWin):-
	tr_db_production(_ProducerId,_SortId,Number),
	round2d(Number,Number1),
	Str1 = win_GetText(CtrlWin),
	str_real(Str1,N1),
	N2 = N1 + Number1,
	str_real(Str2,N2),
	win_SetText(CtrlWin,Str2),
	fail.
  set_ProductionToDialog1(_):-!.
  
  set_OrderToDialog():-
	status_window(Win),
	CtrlWin = win_GetCtlHandle(Win,idc_o),
	set_OrderToDialog1(CtrlWin),
	Strorder = win_GetText(CtrlWin),
	str_real(Strorder,N),
	CtrlWin1 = win_GetCtlHandle(Win,idc_p),
	StrProduction = win_GetText(CtrlWin1),
	str_real(StrProduction,N1),
	N1 <> 0,	
	OrderPercent =N / N1 * 100,
	format(Str1,"%5.1f",OrderPercent), concat(Str1,"%",Str2),
	CtrlWin2 = win_GetCtlHandle(Win,idc_op),
	win_SetText(CtrlWin2,Str2),

	CtrlWinTransportation = win_GetCtlHandle(Win,idc_t),
	win_SetText(CtrlWinTransportation,Strorder),

	!.
  set_OrderToDialog():-!.
  
  set_OrderToDialog1(CtrlWin):-
	tr_db_custom(_ProducerId,_SortId,Number),
	round2d(Number,Number1),
	Str1 = win_GetText(CtrlWin),
	str_real(Str1,N1),
	N2 = N1 + Number1,
	str_real(Str2,N2),
	win_SetText(CtrlWin,Str2),
	fail.
  set_OrderToDialog1(_):-!.

  set_status_title(SortName,b_true):-
	status_window(Win),
	CtrlWin = win_GetCtlHandle(Win,idc_s),
	format(OutputString,"Generating plan for %s ...",SortName),
	win_SetText(CtrlWin,OutputString),!.
  set_status_title(_SortName,b_false):-
	status_window(Win),
	SortCtrlWin = win_GetCtlHandle(Win,idc_s),
	OkButtonCtrlWin = win_GetCtlHandle(Win,idc_ok),
	win_SetText(SortCtrlWin,"Plan generation  finished !"),
	win_SetText(OkButtonCtrlWin,"Ok"),!.
  set_status_title(_,_).

  
predicates
  calc_callback : CALC_CALLBACK
procedure  set_StartDataBySortToDialog(WINDOW DlgWin,REAL SuorseUnplaced,REAL SuorseUnload)
procedure  reset_MoveDataToDialog(REAL Quantity)
procedure  set_Transportation(WINDOW,REAL TotalProduction,REAL SuorseOverload,REAL Transportation)
procedure  set_Unplaced(WINDOW,REAL TotalProduction,REAL NewTransportation,REAL NewUnplaced)
procedure  set_Backlog(WINDOW,REAL TotalProduction,REAL TotalOrder,REAL NewTransportation,REAL NewBackLog)
procedure  set_StatusRetries(REAL Retries)
procedure  set_StatusConflictsSolved(REAL ConflictsSolved)
procedure  set_StatusData(REAL Production,REAL Order,REAL Transportation,REAL Unplaced,REAL Backlog)
procedure  cliar_StatusData()
clauses

% Set transportation,unplaced,backlog quantity to dialog
  reset_MoveDataToDialog(TransQuantity):-
	status_window(Win),
	SuorseOverload = -TransQuantity,
	set_StartDataBySortToDialog(Win,SuorseOverload,0),
	!.
  reset_MoveDataToDialog(_):-errorexit().

  set_StartDataBySortToDialog(Win,SuorseOverload,_SuorseUnload):-
	CtrlWin4 = win_GetCtlHandle(Win,idc_p),
	Str4 = win_GetText(CtrlWin4),
	str_real(Str4,TotalProduction),
	CtrlWin2 = win_GetCtlHandle(Win,idc_o),
	Str2 = win_GetText(CtrlWin2),
	str_real(Str2,TotalOrder),

	set_Transportation(Win,TotalProduction,SuorseOverload,NewTransportation),
	set_Unplaced(Win,TotalProduction,NewTransportation,NewUnplaced),
	set_Backlog(Win,TotalProduction,TotalOrder,NewTransportation,NewBackLog),

	set_StatusData(TotalProduction,TotalOrder,NewTransportation,NewUnplaced,NewBackLog),
	!.
  set_StartDataBySortToDialog(_,_,_):-errorexit().

  set_Unplaced(Win,TotalProduction,NewTransportation,TotalUnplaced):-
	CtrlWinUnplaced = win_GetCtlHandle(Win,idc_u),
	TotalUnplaced = TotalProduction - NewTransportation,
	str_real(StrUp,TotalUnplaced),
	win_SetText(CtrlWinUnplaced,StrUp),
	TotalUnplacedPercent = TotalUnplaced / TotalProduction * 100,
	CtrlWinup = win_GetCtlHandle(Win,idc_up),
	format(Strupp1,"%5.1f",TotalUnplacedPercent), concat(Strupp1,"%",Strupp2),
	win_SetText(CtrlWinup,StrUpp2),
	!.

  set_Backlog(Win,TotalProduction,TotalOrder,NewTransportation,TotalBacklog):-
	CtrlWinBacklog = win_GetCtlHandle(Win,idc_b),
	TotalBacklog = TotalOrder - NewTransportation,
	str_real(StrBl,TotalBacklog),
	win_SetText(CtrlWinBacklog,StrBl),
	TotalBacklogPercent = TotalBacklog / TotalProduction * 100,
	CtrlWinBl = win_GetCtlHandle(Win,idc_bp),
	format(StrBpp1,"%5.1f",TotalBacklogPercent), concat(Strbpp1,"%",Strbpp2),
	win_SetText(CtrlWinBl,StrBpp2),
	!.

  set_Transportation(Win,TotalProduction,SuorseOverload,NewTransportation):-
	CtrlWinTransportation = win_GetCtlHandle(Win,idc_t),
	StrTransportation = win_GetText(CtrlWinTransportation),
	str_real(StrTransportation,Transportation),
	NewTransportation = Transportation - SuorseOverload,
	str_real(NewStrTransportation,NewTransportation),
	win_SetText(CtrlWinTransportation,NewStrTransportation),

	TransportationPercent = NewTransportation / TotalProduction * 100,
	CtrlWintp = win_GetCtlHandle(Win,idc_tp),
	format(Strtpp1,"%5.1f",TransportationPercent), concat(Strtpp1,"%",Strtpp2),
	win_SetText(CtrlWintp,StrTpp2),
	!.
  set_Transportation(_,_,_,0):-errorexit().

  set_StatusRetries(Retries):-
	retract(genStatus(_,ConflictsSolved,Production,Order,Transportation,Unplaced,Backlog)),
	assert(genStatus(Retries,ConflictsSolved,Production,Order,Transportation,Unplaced,Backlog)),
	!.
  set_StatusRetries(Retries):-
	assert(genStatus(Retries,0,0,0,0,0,0)),
	!.

  set_StatusConflictsSolved(ConflictsSolved):-
	retract(genStatus(Retries,_,Production,Order,Transportation,Unplaced,Backlog)),
	assert(genStatus(Retries,ConflictsSolved,Production,Order,Transportation,Unplaced,Backlog)),
	!.
  set_StatusConflictsSolved(ConflictsSolved):-
	assert(genStatus(0,ConflictsSolved,0,0,0,0,0)),
	!.

  set_StatusData(Production,Order,Transportation,Unplaced,Backlog):-
	retract(genStatus(Retries,ConflictsSolved,_,_,_,_,_)),
	assert(genStatus(Retries,ConflictsSolved,Production,Order,Transportation,Unplaced,Backlog)),
	!.
  set_StatusData(Production,Order,Transportation,Unplaced,Backlog):-
	assert(genStatus(0,0,Production,Order,Transportation,Unplaced,Backlog)),
	!.
	
  cliar_StatusData():-move(_,_,_,_),!.
  cliar_StatusData():-unplaced(_,_,_),!.
  cliar_StatusData():-needed(_,_,_),!.
  cliar_StatusData():-retractAll(genStatus(_,_,_,_,_,_,_)),!.	
	
% ------------------------
% Plan generation callback
% ------------------------
  calc_callback(status(SuorseOverload,SuorseUnload,UnsatisfiedTarget,_)):-
	SuorseOverload1 = SuorseOverload + UnsatisfiedTarget,
	round2d(SuorseOverload1,SuorseOverload2),
	status_window(Win),
	set_StartDataBySortToDialog(Win,SuorseOverload2,SuorseUnload),
	!.	
% Set number of retries to dialog
  calc_callback(find_way(_IdList)):-
	status_window(Win),
	CtrlWin = win_GetCtlHandle(Win,idc_ret),
	Str1 = win_GetText(CtrlWin),
	str_real(Str1,Ret1),
	Ret2 = Ret1 + 1,
	str_real(Str2,Ret2),
	win_SetText(CtrlWin,Str2),
	set_StatusRetries(Ret2),
	vpi_ProcessEvents(),
	!.
  calc_callback(move(_IdList,TransQuantity)):-
	round2d(TransQuantity,TransQuantity1),
	status_window(Win),
	% Set number of "Conflicts solved" to dialog
	CtrlWin = win_GetCtlHandle(Win,idc_cs),
	Str1 = win_GetText(CtrlWin),
	str_real(Str1,Solv1),
	Solv2 = Solv1 + 1,
	str_real(Str2,Solv2),
	win_SetText(CtrlWin,Str2),
	set_StatusConflictsSolved(Solv2),
	% Set transportation,unplaced,backlog quantity to dialog
	reset_MoveDataToDialog(TransQuantity1),
	vpi_ProcessEvents(),
	!.

% Plan generation
  trans():-
	retractall(move(_,_,_,_)),
	retractall(needed(_,_,_)),
	retractall(unplaced(_,_,_)),
	cancel_Plan(),
	retract(status_window(Win)),
	win_Destroy(Win),
	fail.
  trans():-
	Parent = cast(window,vpi_GetAttrVal(attr_task_window)),
	dlg_status_Create(Parent),
	set_ProductionToDialog,
	set_OrderToDialog,
	tr_db_sort(SortId,SortName,_,_,_),
	  set_status_title(SortName,b_true),
	  findall(Source,get_source(SortId,Source),SourceList),
	  findall(Target,get_target(SortId,Target),TargetList),
	  findall(Cost,get_cost(Cost),CostList),
	  calc_trans(SourceList,TargetList,CostList,calc_callback,middle,MoveList,UnplacedList,NeededList),
	  set_output_data(SortId,MoveList,UnplacedList,NeededList),
	fail.
  trans():-
	status_window(_Win),
	set_status_title("",b_false),
	fail.
  trans():-
	cancel_Plan(),
	cliar_StatusData(),
	fail.
  trans():-!.











