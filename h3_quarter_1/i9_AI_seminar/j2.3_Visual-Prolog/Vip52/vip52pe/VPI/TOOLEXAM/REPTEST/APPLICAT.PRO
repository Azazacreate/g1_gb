/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  APPLICAT
 FileName: APPLICAT.PRO
 Purpose: Test Application for Report Engine
 Written by: Alexandr Grachev
 Comments:
******************************************************************************/

include "applicat.inc"
include "applicat.con"
include "hlptopic.con"

include "applicat.pre"
include "reptool.pre"
constants
  win_edit_RCT = rct(300,60,900,500)

domains
  dbdom 	= city(CITYNO,CITYNAME);
		  person(FIRSTNAME,LASTNAME,STREET,CITYNO,CODE)
  CITYNO,CITYNAME,FIRSTNAME,LASTNAME,STREET,CODE = STRING
  BOOK		= continent(STRING,INTEGER);
		  country(STRING,STRING,LONG,INTEGER);
		  name(STRING,STRING,STRING,STRING,STRING,INTEGER);
		  banks(INTEGER,STRING,STRING,STRING)

database - appl
  determ edittext(WINDOW,STRING)
  determ temp_name(SLIST)

  determ wd(WINDOW)
  determ wd_stop

  init(STRING,RCT)
  index(UNSIGNED)
  continent(STRING,INTEGER)
  country(STRING,STRING,LONG,INTEGER)
  name(STRING,STRING,STRING,STRING,STRING,INTEGER)
  d_continent(LONG)
  d_country(LONG)
  d_name(LONG)
  s(STRING)

predicates
  change_fn(STRING,WINDOW)
  f_load(STRING,RCT)
  ini_form(WINDOW)
  ini_read     
  ini_err(STRING)
  ini_set
  param_set
  determ  param_1(STRING,STRING)
  adjust_preview_window(INTEGER,INTEGER,INTEGER,INTEGER)

clauses
   change_fn(FILENAME,EDWin):-
	bound(EDWin),
	retract(edittext(EDWin,_)),
	assert(edittext(EDWin,FILENAME)),
	!.
   change_fn(_,_):-
	retract(edittext(_,_)),
	fail.
   change_fn(FILENAME,EDWin):-
	bound(EDWin),
	assert(edittext(EDWin,FILENAME)),
	!.

   f_load(FILENAME,RCT) :-
	report_editScript(FILENAME,RCT,WINDOW),
        change_fn(FILENAME,WINDOW),
	!.	

    ini_form(_WIN):-
	edittext(EDWIN,STRING),
	trap(RCT=win_GetOuterRect(EDWIN),_,fail),
	RCT = rct(L,T,R,B),
	NL = L+4, NT=T+23, NR=R-4, NB=B-4,
	format(SOut,"[EditText]%s\n[EditWin] %d %d %d %d \n",STRING,NL,NT,NR,NB),
	openwrite(sFN,"Applicat.ini"),
	writedevice(sFN),
	write(SOut),
	closefile(sFN),
	!.
    ini_form(_).		

   ini_read:-
   	trap(ini_set,_V,ini_err("No previous settings")),
	init(S,R),
   	trap(f_load(S,R),_W,ini_err("No script for loading")),
   	!.
   ini_read.

   ini_err(S):-
   	trap(write(S),_,fail),
   	nl, !.

   ini_err(_).
   
   ini_set:-
	openread(sFN,"Applicat.ini"),
	readdevice(sFN),
	param_set,
	closefile(sFN).

  param_set:-
  	retract(init(_,_)),
  	fail.
  param_set:-
	readln(X),
	fronttoken(X,_,R),
	fronttoken(R,T2,R2),
	fronttoken(R2,_,R3),
	param_1(T2,R3),
	readln(Z),
	fronttoken(Z,_,Q),
	fronttoken(Q,U2,Q2),
	fronttoken(Q2,_,Q3),
	param_1(U2,Q3),
	!.
  param_set.	

  param_1("EditText",S):-
	retract(init(_,R)),
	assert(init(S,R)),
	!.
  param_1("EditText",S):-
  	assert(init(S,win_edit_RCT)),
  	!.
  param_1("EditWin",R):-
  	retract(init(S,_)),!,
  	fronttoken(R,R1,R12),
  	fronttoken(R12,R2,R22),
  	fronttoken(R22,R3,R4),
  	str_int(R1,I1),
  	str_int(R2,I2),
  	str_int(R3,I3),
  	str_int(R4,I4),
  	RCT = rct(I1,I2,I3,I4),
  	assert(init(S,RCT)),
  	!.  		  	
  param_1("EditWin",R):-
  	fronttoken(R,R1,R12),
  	fronttoken(R12,R2,R22),
  	fronttoken(R22,R3,R4),
  	str_int(R1,I1),
  	str_int(R2,I2),
  	str_int(R3,I3),
  	str_int(R4,I4),
  	RCT = rct(I1,I2,I3,I4),
  	assert(init("",RCT)),
  	!.

  adjust_preview_window(CR,CB,650,550):-
  	CR > 650, CB > 550, !.
  adjust_preview_window(CR,CB,R,B):-
	R = trunc(0.8 * CR),
  	B = trunc(0.85 * CB), !.

predicates
  determ  change_ac_state(WINDOW,BOOLEAN)
  procc_autocall(WINDOW)

clauses
  change_ac_state(Win,0):-
	CEd1 = win_GetCtlHandle(Win,idc_secs),
	win_SetState(CEd1,[wsf_Disabled]),
	CEd2 = win_GetCtlHandle(Win,idct_seconds),
	win_SetState(CEd2,[wsf_Disabled]),
	!.

  change_ac_state(Win,1):-
	CEd1 = win_GetCtlHandle(Win,idc_secs),
	win_SetState(CEd1,[wsf_Enabled]),
	CEd2 = win_GetCtlHandle(Win,idct_seconds),
	win_SetState(CEd2,[wsf_Enabled]),
	!.
  procc_autocall(Win):-
  	State = dialog_GetCheck(Win,idc_autocall),
  	State = 1,
	write("\nState =1"),
	Duration = dialog_GetInt(Win,idc_secs),
	Duration = i(Secs),
	write("\nThe autocall duration= ",Secs),
	Mscs = 1000 * Secs,
	N = cast(WINDOW,0),
	TASK_WIN_HDLE = cast(WINDOW,win_GetAttrVal(N,attr_task_window)),
	timer_Set(TASK_WIN_HDLE,Mscs),
	!.

  procc_autocall(_).
  
predicates
  open_dba
  determ	close_dba

clauses
  open_dba:-
	retract(index(_)),fail.
  open_dba:-
ifdef platform_16bit
	db_open(dba,"register.bin",in_file),
elsedef
	db_open(dba,"regist32.bin",in_file),
enddef
	bt_open(dba,"person_name",I),
	assert(index(I)),
	assert(d_continent(0)),
	assert(d_country(0)),
	assert(d_name(0)),
	consult("dbkeep.dba",appl),
  	!.

  close_dba:-
	index(I),
  	bt_close(dba,I),
  	db_close(dba),
  	!.

predicates
  change_continent(LONG)
  change_country(LONG)
  change_name(LONG)

clauses
   change_continent(_):-
	retract(d_continent(_)),
	fail.
   change_continent(POS):-
   	assert(d_continent(POS)), !.
   change_country(_):-
   	retract(d_country(_)),
   	fail.
   change_country(POS):-
   	assert(d_country(POS)), !.
   change_name(_):-
   	retract(d_name(_)),
   	fail.
   change_name(POS):-
   	assert(d_name(POS)), !.
   	
%-------------------- EXTERNAL DB EXTRACTING predicates ------------------------  		
predicates
  readterm_error_handler(STRING)
  term_p(STRING,STRING,STRING,STRING)
  retrieve_color(STRING,STRING)

clauses
  readterm_error_handler(Line):-
	readtermerror(Str,Pos),
	format(OUT,"Error while term reading in Line %s : %s, Pos %u",Line,Str,Pos),
	dlg_Note(OUT).
  	
  term_p(" ",STR,R,STORE):-
  	fronttoken(STR,TOK,REST),
  	term_p(TOK,REST,R,STORE),
  	!.
  term_p(",",STR,R,STORE):-
  	fronttoken(STR,TOK,REST),
  	term_p(TOK,REST,R,STORE),
  	!.
  term_p(TOK,REST,TOK,REST).
  
  retrieve_color("prolog","33023"):-!.
  retrieve_color("Prolog","4227200"):-!.
  retrieve_color(_,"16777215"):-!.

predicates
  determ   get_key_pred(SLIST)
  get_key_1(SLIST)
  get_key_2(SLIST,SLIST)
  get_term(SLIST,SLIST)
  get_term_list(SLIST,SLIST)
  determ   get_interest(SLIST)
  determ   get_continent(SLIST)
  determ   get_country(SLIST,SLIST)
  determ   get_name(SLIST,SLIST)
  reinit_dba
  determ   open_looong
  determ   read_looong(STRING,STRING,STRING,STRING)
  clear_wd

clauses
  get_key_pred([SI,"headers"]):-
	index(I),
	str_int(SI,I),
	!.

  get_key_1([SI,SS]):-	
	index(I),
	key_first(dba,I,REF),
	str_int(SI,I),
	str_ref(SS,REF),
	!.
  get_key_1([""]).
  		
  get_key_2(["headers"],LIST):-
	get_key_1(LIST),
	!.
  get_key_2([SI],[SS]):-
	str_int(SI,I),
	key_next(dba,I,REF),
	str_ref(Ss,REF),
	!.
  get_key_2(_,[""]).

  get_term(["headers"],["First Name","Last Name","Address","Post Code","Interest"]):-!.
  get_term([SR],[FN,LN,ST,CN,CO]):-
	str_ref(SR,REF),
	ref_term(dba,dbdom,REF,TERM),
	TERM=person(FN,LN,ST,CN,CO),!.
  get_term(_,[]).
  	 	
  get_term_list([SR],[FN,LN,ST,CN]):-
	str_ref(SR,REF),
	ref_term(dba,dbdom,REF,TERM),
	TERM=person(FN,LN,ST,CN,CO),
	assert(s(CO)),
  	!.
  get_term_list(_,[]).
  
  get_interest([R,COLOR]):-
  	retract(s(STR)),
  	fronttoken(STR,TOK,REST),
  	term_p(TOK,REST,R,STORE),
  	retrieve_color(R,COLOR),
  	assert(s(STORE)),
  	!.
  
  get_continent([CONT]):-
	d_continent(POS),
	P = val(integer,POS + 1),
	continent(CONT,P),
  	change_continent(P),
  	!.

  get_country([CONT],[COUNTRY,COLOR]):-
  	d_country(POS),
  	P = val(integer,POS + 1),
	country(CONT,COUNTRY,LONG,P),
	term_str(long,LONG,COLOR),
  	change_country(P),  	
	!.  	
  get_country([CONT],[COUNTRY,COLOR]):-
  	d_country(POS),
	country(CONT,COUNTRY,LONG,P),
	P > POS,
	term_str(long,LONG,COLOR),
  	change_country(P),  	
	!.  	

  get_name([COUNTRY],[NAME,STREET,CITY,PHONE]):-
  	d_name(POS),
	P = val(integer,POS + 1),
	name(NAME,STREET,CITY,COUNTRY,PHONE,P), 
	change_name(P), !.
  get_name([COUNTRY],[NAME,STREET,CITY,PHONE]):-
  	d_name(POS),
	name(NAME,STREET,CITY,COUNTRY,PHONE,P), 
	P > POS,
	change_name(P), !.

  get_name(_,_):- 
  	change_name(0), !, fail.

  reinit_dba:-
	change_continent(0),
  	change_country(0),
  	change_name(0).

  open_looong:-
  	trap(openread(sFN,"xxx.txt"),_,dlg_Note("Error opening Long Data Base")),
  	readdevice(sFN),
  	!.

  read_looong(Line,S1,S2,S3):-
	not(eof(sFN)),
  	readdevice(sFN),
  	trap(readterm(BOOK,banks(_,S1,S2,S3)),_,readterm_error_handler(Line)),
	!.  
  read_looong(_,_,_,_):-closefile(sFN), fail.
  
  clear_wd:-
  	retract(wd(WD)),
  	win_Destroy(WD),
  	!.
  clear_wd.

predicates
  control_callback : PROCESS_PRED

clauses
  control_callback(ID,_,[]):-
  	upper_lower(ID,"dba_open"),!,
  	open_dba.	
  control_callback(ID,_,[]):-
  	upper_lower(ID,"reinit_dba"),!,
  	reinit_dba.
  control_callback(ID,_,OUT):-
  	upper_lower(ID,"get_pred_key"),!,
  	get_key_pred(OUT).	
  control_callback(ID,_,OUT):-
  	upper_lower(ID,"get_first_key"),!,
  	get_key_1(OUT).	
  control_callback(ID,IN,OUT):-
  	upper_lower(ID,"get_next_key"),!,
  	get_key_2(IN,OUT).	
  control_callback(ID,IN,OUT):-
  	upper_lower(ID,"get_term"),!,
  	get_term(IN,OUT).
  control_callback(ID,IN,OUT):-
  	upper_lower(ID,"get_term_list"),!,
  	get_term_list(IN,OUT).  		
  control_callback(ID,_,OUT):-
  	upper_lower(ID,"get_interest"),!,
  	get_interest(OUT).
  control_callback(ID,_,[]):-
  	upper_lower(ID,"dba_close"),!,
  	close_dba.	
  control_callback(ID,_,OUT):-
	upper_lower(ID,"get_continent"),!,
	get_continent(OUT).
  control_callback(ID,IN,OUT):-
	upper_lower(ID,"get_country"),!,
	get_country(IN,OUT).
  control_callback(ID,IN,OUT):-
  	upper_lower(ID,"get_name"),!,
  	get_name(IN,OUT).
  control_callback(ID,_,[]):-
  	upper_lower(ID,"open_long"),!,
  	open_looong.
  control_callback(ID,[SL],[S1,S2,S3]):-
  	upper_lower(ID,"read_long"),!,
  	read_looong(SL,S1,S2,S3).
  	
  control_callback(ID,_,[SF]):-
  	upper_lower(ID,"get_cyrfont"),!,
	OLD = font_Create(ff_system,[],10),
	LOGF = dlg_ChooseFont(OLD),
	term_str(FONT,LOGF,SF),
	!.

predicates
  progress_cb	 : PROGRESS_PRED

clauses
%----------------- CONTROLL CALLBACK clauses -------------------------------
  progress_cb(starting,_,b_false):-
	clear_wd,
	TaskWin=vpi_GetTaskWin(),
	dlg_cancel_dialog_Create(TaskWin),
	!.

  progress_cb(finish,_,b_false):-
  	retract(wd(WD)),
  	win_Destroy(WD),
  	!.

  progress_cb(_,_,b_true):-
  	retract(wd_stop),
  	!.
  	
  progress_cb(_,_,b_false):-
  	vpi_Processevents(b_true),
  	!.
	
%BEGIN_WIN Task Window
/***************************************************************************
	Event handling for Task Window
***************************************************************************/

predicates

  task_win_eh : EHANDLER

constants

%BEGIN Task Window, CreateParms, 21:48:56-5.9.1997, Code automatically updated!
  task_win_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Close,wsf_Maximize,wsf_Minimize,wsf_ClipChildren]
  task_win_Menu  = res_menu(idr_task_menu)
  task_win_Title = "Applicat"
  task_win_Help  = contents
%END Task Window, CreateParms

clauses

%BEGIN Task Window, e_Create
  task_win_eh(_Win,e_Create(_),0):-!,
%BEGIN Task Window, InitControls, 21:48:56-5.9.1997, Code automatically updated!
%END Task Window, InitControls
%BEGIN Task Window, ToolbarCreate, 21:48:56-5.9.1997, Code automatically updated!
	tb_help_line_Create(_Win),
	tb_project_toolbar_Create(_Win),
%END Task Window, ToolbarCreate
ifdef use_message
	msg_Create(100),
enddef
	ini_read,
	open_dba,
	!.
%END Task Window, e_Create

%MARK Task Window, new events

%BEGIN Task Window, e_Update
  task_win_eh(_Win,e_Update(_UpdateRct),0):-
	C = vpi_GetAttrVal(attr_color_appworkspace),
	SpaceColor = cast(COLOR,C),
	win_Clear(_Win,SpaceColor),
	!.
%END Task Window, e_Update

%BEGIN Task Window, id_Report_print
  task_win_eh(_Win,e_Menu(id_Report_print,_ShiftCtlAlt),0):-!,
        edittext(EDW,_FN),
	trap(win_GetState(EDW),_,fail),
	dlg_page_range_set_up_Create(_Win),
	!.
%END Task Window, id_Report_print

%BEGIN Task Window, e_Destroy
  task_win_eh(_Win,e_Destroy,0):-!,
	close_dba,
	ini_form(_Win),
	trap(deletefile("rep$$$.tmp"),_,fail),
	!.
%END Task Window, e_Destroy

%BEGIN Task Window, e_CloseRequest
  task_win_eh(_Win,e_CloseRequest,0):-!,
	report_Close,
	win_Destroy(_Win),
	!.
%END Task Window, e_CloseRequest

%BEGIN Task Window, e_Timer
  task_win_eh(_Win,e_Timer(TimerId),0):-!,
	timer_Kill(TimerId),
	report_GetStatus(Generation,Printing),
	Generation = 0,
	Printing = 0,
	write("\n Timer Gets"),
	edittext(EDW,_FN),
	trap(win_GetState(EDW),_,fail),
	InpStr = edit_GetText(EDW),
	report_Print(InpStr,control_callback,progress_cb,
	print(1,band(0,0))),
	!.
%END Task Window, e_Timer

%BEGIN Task Window, id_printer_setup
  task_win_eh(_Win,e_Menu(id_printer_setup,_ShiftCtlAlt),0):-!,
	dlg_PrintSetup(NoOfCopies,FirstPage,LastPage),
	write("\nNoOfCopies=",NoOfCopies," First=",FirstPage," Last=",LastPage),
	!.
%END Task Window, id_printer_setup

%BEGIN Task Window, id_Report_transfer_to_rtf
  task_win_eh(_Win,e_Menu(id_Report_transfer_to_rtf,_ShiftCtlAlt),0):-!,
        win_SendEvent(_Win,e_Menu(id_file_save,0)),
        edittext(EDW,_FN),
	trap(win_GetState(EDW),_,fail),
        InpStr = edit_GetText(EDW),
	File = dlg_GetSaveFilename("*.rtf",["RTFormat Files","*.rtf","All Files","*.*"],"Set File Name:"),
	File >< "",
        report_Print(InpStr,control_callback,progress_cb,
        convert_rtf(File)),
	!.
%END Task Window, id_Report_transfer_to_rtf

%BEGIN Task Window, id_Report_generate
  task_win_eh(_Win,e_Menu(id_Report_generate,_ShiftCtlAlt),0):-!,
	win_SendEvent(_Win,e_Menu(id_file_save,0)),
	edittext(EDW,_FN),
	trap(win_GetState(EDW),_,fail),
	InpStr = edit_GetText(EDW),
	RCT = win_GetClientRect(_Win),
	RCT = rct(_,_,CR,CB),
	adjust_preview_window(CR,CB,R,B),
	RRR = rct(10,34,R,B),
	report_Print(InpStr,control_callback,progress_cb,
	preview("Report LayOut",RRR,[repw_Zoomed])),
	!.
%END Task Window, id_Report_generate

%BEGIN Task Window, id_file_save_as
  task_win_eh(_Win,e_Menu(id_file_save_as,_ShiftCtlAlt),0):-!,
	FILENAME = dlg_GetSaveFileName("*.rep",["*.*","*.*","*.rep","*.rep"],""),!,
	not(FILENAME = ""),
	change_fn(FILENAME,EDWin),
	Text = edit_GetText(EDWin),
	file_str(FILENAME,Text),
	!.
  task_win_eh(_Win,e_Menu(id_file_save_as,_ShiftCtlAlt),0):-!.
%END Task Window, id_file_save_as

%BEGIN Task Window, id_file_save
  task_win_eh(_Win,e_Menu(id_file_save,_ShiftCtlAlt),0):-!,
	edittext(EDWin,FILENAME),
	trap(win_GetState(EDWin),_,fail),
	Text = edit_GetText(EDWin),
	file_str(FILENAME,Text),
	!.
%END Task Window, id_file_save

%BEGIN Task Window, id_file_open
  task_win_eh(_Win,e_Menu(id_file_open,_ShiftCtlAlt),0):-
	FILENAME=dlg_GetOpenFileName("*.rep",["*.rep","*.rep","*.txt","*.txt","*.*","*.*"],""),
	FILENAME >< "",
ifdef no_scanner
	RCT = win_GetClientRect(_Win),
	RCT = rct(_,_,CR,CB),
	adjust_preview_window(CR,CB,R,B),
	RRR = rct(10,34,R,B),
	report_Print(FILENAME,control_callback,progress_cb,
	preview("Report LayOut",RRR,[repw_Zoomed])),
elsedef
	f_load(FILENAME,win_edit_RCT),
	menu_Enable(_Win,"Report",b_true),
	menu_Update(_Win),
enddef
	!.
  task_win_eh(_Win,e_Menu(id_file_open,_ShiftCtlAlt),0):- !.
%END Task Window, id_file_open

%BEGIN Task Window, id_help_contents
  task_win_eh(_Win,e_Menu(id_help_contents,_ShiftCtlAlt),0):-!,
  	vpi_ShowHelp("applicat.hlp"),
	!.
%END Task Window, id_help_contents

%BEGIN Task Window, id_help_about
  task_win_eh(Win,e_Menu(id_help_about,_ShiftCtlAlt),0):-!,
	dlg_about_dialog_Create(Win),
	!.
%END Task Window, id_help_about

%BEGIN Task Window, id_file_exit
  task_win_eh(Win,e_Menu(id_file_exit,_ShiftCtlAlt),0):-!,
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

  task_win_eh(_,EVENT,0):-
	edittext(EdWin,_),
	trap(win_SendEvent(EdWin,EVENT),_,fail),
	!.
%END_WIN Task Window

/***************************************************************************
	Invoking on-line Help
***************************************************************************/

  project_ShowHelpContext(HelpTopic):-
  	vpi_ShowHelpContext("applicat.hlp",HelpTopic).

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
  vpi_Init(task_win_Flags,task_win_eh,task_win_Menu,"applicat",task_win_Title).

%BEGIN_DLG About dialog
/**************************************************************************
	Creation and event handling for dialog: About dialog
**************************************************************************/

constants

%BEGIN About dialog, CreateParms, 14:37:48-5.9.1997, Code automatically updated!
  dlg_about_dialog_ResID = idd_dlg_about
  dlg_about_dialog_DlgType = wd_Modal
  dlg_about_dialog_Help = contents
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

%BEGIN_TLB Help line, 15:20:34-24.11.1999, Code automatically updated!
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





%BEGIN_TLB Project toolbar, 15:20:22-24.11.1999, Code automatically updated!
/**************************************************************************
	Creation of toolbar: Project toolbar
**************************************************************************/

clauses

  tb_project_toolbar_Create(_Parent):-
ifdef use_tbar
	toolbar_create(tb_top,0xC0C0C0,_Parent,
		[tb_ctrl(id_file_new,pushb,idb_new_up,idb_new_dn,idb_new_up,"New file",1,1),
		 tb_ctrl(id_file_open,pushb,idb_open_up,idb_open_dn,idb_open_up,"Open file",1,1),
		 tb_ctrl(id_file_save,pushb,idb_save_up,idb_save_dn,idb_save_up,"File save",1,1),
		 separator,
		 separator,
		 tb_ctrl(id_Report_generate,pushb,idb_report_gen_up,idb_report_gen_dn,idb_report_gen_dn,"",1,1),
		 tb_ctrl(id_file_exit,pushb,idb_exit_up,idb_exit_dn,idb_exit_dn,"Exit",1,1)]),
enddef
	true.
%END_TLB Project toolbar







%BEGIN_DLG Cancel Dialog
/**************************************************************************
	Creation and event handling for dialog: Cancel Dialog
**************************************************************************/

constants

%BEGIN Cancel Dialog, CreateParms, 17:19:57-5.9.1997, Code automatically updated!
  dlg_cancel_dialog_ResID = idd_cancel_dialog
  dlg_cancel_dialog_DlgType = wd_Modeless
  dlg_cancel_dialog_Help = contents
%END Cancel Dialog, CreateParms

predicates

  dlg_cancel_dialog_eh : EHANDLER

clauses

  dlg_cancel_dialog_Create(Parent):-

%MARK Cancel Dialog, new variables

	WD=dialog_CreateModeless(Parent,dlg_cancel_dialog_ResID,"",
  		[
%BEGIN Cancel Dialog, ControlList, 17:19:57-5.9.1997, Code automatically updated!
%END Cancel Dialog, ControlList
		],
		dlg_cancel_dialog_eh,0),
	assert(wd(WD)).


%MARK Cancel Dialog, new events

%BEGIN Cancel Dialog, idc_cancel_button _CtlInfo
  dlg_cancel_dialog_eh(_Win,e_Control(idc_cancel_button,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
  	not(wd_stop),
  	assert(wd_stop),
	!.
%END Cancel Dialog, idc_cancel_button _CtlInfo

  dlg_cancel_dialog_eh(_,_,_):-!,fail.

%END_DLG Cancel Dialog


%BEGIN_DLG Page Range Set up
/**************************************************************************
	Creation and event handling for dialog: Page Range Set up
**************************************************************************/

constants

%BEGIN Page Range Set up, CreateParms, 18:48:24-5.9.1997, Code automatically updated!
  dlg_page_range_set_up_ResID = idd_page_range_set_up
  dlg_page_range_set_up_DlgType = wd_Modal
  dlg_page_range_set_up_Help = contents
%END Page Range Set up, CreateParms

predicates

  dlg_page_range_set_up_eh : EHANDLER
  dlg_page_range_set_up_handle_answer(INTEGER EndButton,DIALOG_VAL_LIST)
  dlg_page_range_set_up_update(DIALOG_VAL_LIST)

clauses

  dlg_page_range_set_up_Create(Parent):-

%MARK Page Range Set up, new variables

	dialog_CreateModal(Parent,dlg_page_range_set_up_ResID,"",
  		[
%BEGIN Page Range Set up, ControlList, 18:48:24-5.9.1997, Code automatically updated!
		df(idc_frompage,editint(i(1),[mandatory]),nopr),
		df(idc_topage,editint(i(1),[mandatory]),nopr),
		df(idc_numofcop,editint(i(1),[mandatory]),nopr),
		df(idc_autocall,checkbox(b_false),nopr),
		df(idc_secs,editint(void,[range(1,25)]),nopr)
%END Page Range Set up, ControlList
		],
		dlg_page_range_set_up_eh,0,VALLIST,ANSWER),
	dlg_page_range_set_up_handle_answer(ANSWER,VALLIST).

  dlg_page_range_set_up_handle_answer(idc_ok,VALLIST):-!,
	dlg_page_range_set_up_update(VALLIST).
  dlg_page_range_set_up_handle_answer(idc_cancel,_):-!.  % Handle Esc and Cancel here
  dlg_page_range_set_up_handle_answer(_,_):-
	errorexit().

  dlg_page_range_set_up_update(_VALLIST):-
%BEGIN Page Range Set up, Update controls, 18:48:24-5.9.1997, Code automatically updated!
	_IDC_FROMPAGE_VALUE = dialog_VLGetint(idc_frompage,_VALLIST),
	_IDC_TOPAGE_VALUE = dialog_VLGetint(idc_topage,_VALLIST),
	_IDC_NUMOFCOP_VALUE = dialog_VLGetint(idc_numofcop,_VALLIST),
	_IDC_AUTOCALL_CHECKED = dialog_VLGetCheck(idc_autocall,_VALLIST),
	_IDC_SECS_VALUE = dialog_VLGetint(idc_secs,_VALLIST),
%END Page Range Set up, Update controls
	true.

%MARK Page Range Set up, new events

%BEGIN Page Range Set up, idc_ok _CtlInfo
  dlg_page_range_set_up_eh(_Win,e_Control(idc_ok,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	From = dialog_GetInt(_Win,idc_frompage),
	From = i(From_Page),
	To = dialog_GetInt(_Win,idc_topage),
	To = i(To_Page),
	Copies = dialog_GetInt(_Win,idc_numofcop),
	Copies = i(NumOfCopy),
	procc_autocall(_Win),
	win_Destroy(_Win),
        edittext(EDW,_FN),
	trap(win_GetState(EDW),_,fail),
        InpStr = edit_GetText(EDW),
        report_Print(InpStr,control_callback,progress_cb,
        print(NumOfCopy,band(From_Page,To_Page))),
	!.
%END Page Range Set up, idc_ok _CtlInfo

%BEGIN Page Range Set up, idc_cancel _CtlInfo
  dlg_page_range_set_up_eh(_Win,e_Control(idc_cancel,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	win_Destroy(_Win),
	!.
%END Page Range Set up, idc_cancel _CtlInfo

%BEGIN Page Range Set up, idc_autocall _CtlInfo
  dlg_page_range_set_up_eh(_Win,e_Control(idc_autocall,_CtrlType,CW,activated()),0):-!,
	State = win_Ischecked(CW),
	change_ac_state(_Win,State),
	!.
%END Page Range Set up, idc_autocall _CtlInfo

  dlg_page_range_set_up_eh(_,_,_):-!,fail.

%END_DLG Page Range Set up
