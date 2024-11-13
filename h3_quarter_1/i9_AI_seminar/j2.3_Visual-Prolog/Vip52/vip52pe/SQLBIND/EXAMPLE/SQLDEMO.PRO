/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  SQLDEMO
 FileName: SQLDEMO.PRO
 Purpose: A demo of SQLBIND
 Written by: Leo Jensen
 Comments:
******************************************************************************/

include "sqldemo.inc"
include "sqldemo.con"
include "hlptopic.con"


DATABASE - local
  dbhandle(DBC_HANDLE)
  determ sql_errcod(integer)

PREDICATES
  open_error(integer)
CLAUSES
  open_error(E) :-
    retractall(sql_errcod(_)),
    assert(sql_errcod(E)),
	dlg_note("You must define the ODBC datasource \"SQLBIND_Demo\"\nIn the Control Panel - ODBC").

PREDICATES
   errorstr(integer,string)
CLAUSES
   errorstr(prolog_sql_error,"sql_error") :- !.
   errorstr(prolog_sql_invalid_handle,"sql_invalid_handle") :- !.
   errorstr(prolog_sql_need_data,"sql_need_data") :- !.
   errorstr(prolog_sql_still_executing,"sql_still_executing") :- !.
   errorstr(prolog_fail,"fail") :- !.
   errorstr(prolog_other_error,"other_error") :- !.
   errorstr(E,EStr) :-
      str_int(EStr,E).

PREDICATES
   sql_err_hand(integer,string)
CLAUSES
   sql_err_hand(E, S) :-
      retractall(sql_errcod(_)),
      assert(sql_errcod(E)),
      errorstr(E,EStr),
      format(Str, "%s Error (%s)", S, EStr), 
      dlg_note(Str).


PREDICATES
   DBC_HANDLE tsql_Connect(string,string,string)
CLAUSES
   tsql_Connect(DB,UserName,Password,HDBC) :-
      trap(HDBC=sql_Connect(DB,UserName,Password), E, open_error(E)).

PREDICATES
   tsql_Disconnect(DBC_HANDLE)
CLAUSES
   tsql_Disconnect(HDBC) :-
      trap(sql_Disconnect(HDBC),  E, sql_err_hand(E,"DISCONNECT")).

PREDICATES
   tsql_Close(STMT_HANDLE)
CLAUSES
   tsql_Close(H) :-
      trap(sql_Close(H),       E, sql_err_hand(E,"CLOSE")).

PREDICATES
   tsql_Drop(STMT_HANDLE)
CLAUSES
   tsql_Drop(H) :-
      trap(sql_Drop(H),        E, sql_err_hand(E,"DROP")).

PREDICATES
   tsql_Commit(DBC_HANDLE)
CLAUSES
   tsql_Commit(HDBC) :-
      trap(sql_Commit(HDBC),      E, sql_err_hand(E,"COMMIT")).

PREDICATES
   tsql_Rollback(DBC_HANDLE)
CLAUSES
   tsql_Rollback(HDBC) :-
      trap(sql_Rollback(HDBC),    E, sql_err_hand(E,"ROLLBACK")).

PREDICATES
   STMT_HANDLE tsql_Prepare(DBC_HANDLE,string)
CLAUSES
   tsql_Prepare(HDBC,Stmt, H) :-
      trap(H = sql_Prepare(HDBC,Stmt), E, sql_err_hand(E,"PREPARE")).

PREDICATES
   STMT_HANDLE tsql_Exec(DBC_HANDLE,string)
CLAUSES
   tsql_Exec(HDBC,Stmt, H) :-
      trap(H = sql_Exec(HDBC,Stmt), E, sql_err_hand(E,"EXEC")), !.
   tsql_Exec(HDBC,_, _) :-
      H = cast(STMT_HANDLE, sql_nullHandle),
      trap(Str = sql_ErrorMsg(HDBC,H,H2),_,fail),
      tsql_Drop(H2),    % Drop the STMT_HANDLE in error
      dlg_note(Str),
      fail.

PREDICATES
   tsql_ExecStmt(DBC_HANDLE,STMT_HANDLE)
CLAUSES
   tsql_ExecStmt(_HDBC, H) :-
     	trap(sql_ExecStmt(H), E, sql_err_hand(E,"EXECSTMT")), !.
   tsql_ExecStmt(HDBC, H) :-
      trap(Str = sql_ErrorMsg(HDBC,H,_),_,fail),  % Don't drop the stmt_handle in error
      dlg_note(Str),
      fail.

PREDICATES
   tsql_FetchNext(STMT_HANDLE)
CLAUSES
   tsql_FetchNext(H) :-
      retractall(sql_errcod(_)),   % Clear the error indicator
      trap(sql_FetchNext(H),   E, sql_err_hand(E,"FETCHNEXT")), !.
   tsql_FetchNext(H) :-
      sql_errcod(_),           % Only proceed if there is an error code
      dbhandle(HDBC),
      trap(Str = sql_ErrorMsg(HDBC,H,_),_,fail),  % Don't drop the stmt_handle in error
      dlg_note(Str),
      fail.

PREDICATES
   string tsql_GetString(STMT_HANDLE,COL_REF)
CLAUSES
   tsql_GetString(H, I, X) :-
      trap(X = sql_GetString(H, I),    E, sql_err_hand(E,"GETSTRING")).

PREDICATES
   LONG tsql_GetLong(STMT_HANDLE,COL_REF)
CLAUSES
   tsql_GetLong(H, I, X) :-
      trap(X = sql_GetLong(H, I),      E, sql_err_hand(E,"GETLONG")).

PREDICATES
   SHORT tsql_GetInteger(STMT_HANDLE,COL_REF)
CLAUSES
   tsql_GetInteger(H, I, X) :-
      trap(X = sql_GetInteger(H, I),   E, sql_err_hand(E,"GETINTEGER")).

PREDICATES
   REAL tsql_GetReal(STMT_HANDLE,COL_REF)
CLAUSES
   tsql_GetReal(H, I, X) :-
      trap(sql_GetReal(H, I, X),       E, sql_err_hand(E,"GETREAL")).

PREDICATES
   string tsql_GetDate(STMT_HANDLE,COL_REF)
CLAUSES
   tsql_GetDate(H, I, X) :-
      trap(X = sql_GetDate(H, I),      E, sql_err_hand(E,"GETDATE")).

PREDICATES
   string tsql_GetTime(STMT_HANDLE,COL_REF)
CLAUSES
   tsql_GetTime(H, I, X) :-
      trap(X = sql_GetTime(H, I),      E, sql_err_hand(E,"GETTIME")).

PREDICATES
   string tsql_GetTimeStamp(STMT_HANDLE,COL_REF)
CLAUSES
   tsql_GetTimeStamp(H, I, X) :-
      trap(X = sql_GetTimeStamp(H, I), E, sql_err_hand(E,"GETTIMESTAMP")).

PREDICATES
   COL_DATA tsql_GetColData(STMT_HANDLE,COL_REF)
CLAUSES
   tsql_GetColData(H, I, X) :-
      trap(X = sql_GetColData(H, I), E, sql_err_hand(E,"GETCOLDATA")).


%BEGIN_WIN Task Window
/***************************************************************************
	Event handling for Task Window
***************************************************************************/

PREDICATES

  task_win_eh : EHANDLER

CONSTANTS

%BEGIN Task Window, CreateParms, 22:27:54-25.11.1999, Code automatically updated!
  task_win_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Close,wsf_Maximize,wsf_Minimize,wsf_ClipSiblings,wsf_ClipChildren]
  task_win_Menu  = res_menu(idr_task_menu)
  task_win_Title = "SQLDEMO"
  task_win_Help  = idh_contents
%END Task Window, CreateParms

CLAUSES

%BEGIN Task Window, e_Create
  task_win_eh(_Win,e_Create(_),0):-!,
%BEGIN Task Window, InitControls, 22:27:54-25.11.1999, Code automatically updated!
%END Task Window, InitControls
%BEGIN Task Window, ToolbarCreate, 22:27:54-25.11.1999, Code automatically updated!
	tb_project_toolbar_Create(_Win),
	tb_help_line_Create(_Win),
%END Task Window, ToolbarCreate
IFDEF use_message
	msg_Create(100),
ENDDEF
	DBH = tsql_Connect("SQLBIND_Demo","",""), !,
	assert(dbhandle(DBH)),
	win_PostEvent(_Win,e_Menu(id_file_new,0)),
	!.
%END Task Window, e_Create

%MARK Task Window, new events

%BEGIN Task Window, id_file_new
  task_win_eh(_Win,e_Menu(id_file_new,_ShiftCtlAlt),0):-!,
	dlg_form_Create(_Win),
	!.
%END Task Window, id_file_new

%BEGIN Task Window, id_help_contents
  task_win_eh(_Win,e_Menu(id_help_contents,_ShiftCtlAlt),0):-!,
  	vpi_ShowHelp("sqldemo.hlp"),
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
IFDEF use_tbar
	toolbar_Resize(_Win),
ENDDEF
IFDEF use_message
	msg_Resize(_Win),
ENDDEF
	!.
%END Task Window, e_Size

%BEGIN Task Window, e_User
% Help button in dialog "Find Text"
  task_win_eh(_Win,e_User(idc_help,edit_HelpFind),0):-!,
	!.
% Help button in dialog "Replace Text"
  task_win_eh(_Win,e_User(idc_help,edit_HelpReplace),0):-!,
	!.
% Help button in dialog "Go To Line"
  task_win_eh(_Win,e_User(idc_help,edit_HelpLine),0):-!,
	!.
% Help button in dialog "Go To Position"
  task_win_eh(_Win,e_User(idc_help,edit_HelpPos),0):-!,
	!.
% Help button in dialog "Editor Options"
  task_win_eh(_Win,e_User(idc_help,edit_HelpOptions),0):-!,
	!.
%END Task Window, e_User

%END_WIN Task Window

/***************************************************************************
	Invoking on-line Help
***************************************************************************/

  project_ShowHelpContext(HelpTopic):-
  	vpi_ShowHelpContext("sqldemo.hlp",HelpTopic),!.

/***************************************************************************
	Main Goal
***************************************************************************/

GOAL

IFDEF use_mdi
  vpi_SetAttrVal(attr_win_mdi,b_true),
ENDDEF
IFDEF use_3dctrl
  vpi_SetAttrVal(attr_win_3dcontrols,b_true),
ENDDEF
IFDEF use_tbar
  vpi_SetAttrVal(attr_win_tbar,use_tbar),
ENDDEF
IFDEF use_sbar
  vpi_SetAttrVal(attr_win_sbar,use_sbar),
ENDDEF
  vpi_Init(task_win_Flags,task_win_eh,task_win_Menu,"sqldemo",task_win_Title).

%BEGIN_TLB Project toolbar, 22:28:12-25.11.1999, Code automatically updated!
/**************************************************************************
	Creation of toolbar: Project toolbar
**************************************************************************/

clauses

  tb_project_toolbar_Create(_Parent):-
ifdef use_tbar
	toolbar_create(tb_top,0xC0C0C0,_Parent,
		[tb_ctrl(id_file_new,pushb,idb_new_up,idb_new_dn,idb_new_up,"New;New file",1,1),
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
		 tb_ctrl(id_help_contents,pushb,idb_help_up,idb_help_down,idb_help_up,"Help;Help",1,1)]),
enddef
	true.
%END_TLB Project toolbar




%BEGIN_TLB Help line, 22:28:18-25.11.1999, Code automatically updated!
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

CONSTANTS

%BEGIN About dialog, CreateParms, 22:46:00-25.11.1999, Code automatically updated!
  dlg_about_dialog_ResID = idd_dlg_about
  dlg_about_dialog_DlgType = wd_Modal
  dlg_about_dialog_Help = idh_contents
%END About dialog, CreateParms

PREDICATES

  dlg_about_dialog_eh : EHANDLER

CLAUSES

  dlg_about_dialog_Create(Parent):-
	win_CreateResDialog(Parent,dlg_about_dialog_DlgType,dlg_about_dialog_ResID,dlg_about_dialog_eh,0),!.

%BEGIN About dialog, idc_ok _CtlInfo
  dlg_about_dialog_eh(_Win,e_Control(idc_ok,_CtrlType,_CtrlWin,_CtrlInfo),0):-!,
	win_Destroy(_Win),
	!.
%END About dialog, idc_ok _CtlInfo
%MARK About dialog, new events

%BEGIN About dialog, e_User, Parent window 
  dlg_about_dialog_eh(Win,e_User(ID1,ID2),0):-!,
	PARENT = win_GetParent(Win),
	win_SendEvent(PARENT,e_User(ID1,ID2)),
	!.
%END About dialog, e_User, Parent window
%END_DLG About dialog


DATABASE - records
  record(integer,string,string)
  determ cur_record(WINDOW,integer)
  determ initnr(integer)
  determ count(integer)

PREDICATES
  retrieve_current(STMT_HANDLE)
  retrieve_dataset(STMT_HANDLE)
  show_current_record(WINDOW)
  set_current_record(WINDOW,INTEGER)
  get_current_record(WINDOW,STRING,STRING)

CLAUSES
  set_current_record(_Win,Id) :-
  	retractall(cur_record(_Win,_)),
  	assert(cur_record(_Win,Id)).

  show_current_record(_Win) :-
  	cur_record(_Win,0),
  	record(Id,_,_), !,
  	set_current_record(_Win,Id), !,
	show_current_record(_Win).
  show_current_record(_Win) :-
	get_current_record(_Win,FirstName,LastName),
	CtlH1 = win_GetCtlHandle(_Win,idc_firstname),
	CtlH2 = win_GetCtlHandle(_Win,idc_lastname),
	win_SetText(CtlH1,FirstName),
	win_SetText(CtlH2,LastName).
  
  get_current_record(_Win,FirstName,LastName) :-
  	cur_record(_Win,Id),
  	record(Id,FirstName,LastName), !.
  get_current_record(_,"","").
  
  retrieve_current(H):-
	Id = tsql_GetInteger(H, 1),
	FirstName = tsql_GetString(H, 3),
	LastName = tsql_GetString(H, 4),
	assertz(record(Id,FirstName,LastName)).

  retrieve_dataset(H) :-    % We need to retrieve all the entries at once, because we cannot
	tsql_FetchNext(H),   % use functions like Previous, Home, End.
	retrieve_current(H), !,
	retrieve_dataset(H).
  retrieve_dataset(_).

PREDICATES
  retrieve_count(STMT_HANDLE)
CLAUSES
  retrieve_count(H) :-
	tsql_FetchNext(H), !,  % use functions like Previous, Home, End.
	Count = tsql_GetLong(H, 1),
	assert(count(Count)).
  retrieve_count(_H) :-
  	assert(count(0)).


%BEGIN_DLG form
/**************************************************************************
	Creation and event handling for dialog: form
**************************************************************************/

CONSTANTS

%BEGIN form, CreateParms, 22:27:38-25.11.1999, Code automatically updated!
  dlg_form_ResID = idd_records
  dlg_form_DlgType = wd_Modal
  dlg_form_Help = idh_contents
%END form, CreateParms

PREDICATES

  dlg_form_eh : EHANDLER
  dlg_form_update(DIALOG_VAL_LIST)

CLAUSES

  dlg_form_Create(Parent):-
	dbhandle(DBH),
  	retractall(_,records),
%  	dlg_note("selecting from persons"),
	H0 = tsql_Exec(DBH,"SELECT count(*) FROM Persons"),
	retrieve_count(H0),
	tsql_Drop(H0),
	H = tsql_Exec(DBH,"SELECT * FROM Persons"),
	retrieve_dataset(H),
	tsql_Drop(H),
	Nr = 1,
	assert(initnr(Nr)),
  	record(Nr,FirstName,LastName), !,

%MARK form, new variables

	dialog_CreateModal(Parent,dlg_form_ResID,"",
  		[
%BEGIN form, ControlList, 22:27:38-25.11.1999, Code automatically updated!
		df(idc_firstname,editstr(FIRSTNAME,[]),nopr),
		df(idc_lastname,editstr(LASTNAME,[]),nopr)
%END form, ControlList
		],
		dlg_form_eh,0,VALLIST,ANSWER),
	ANSWER = idc_ok,
	dlg_form_update(VALLIST),!.

  dlg_form_update(_VALLIST):-!,
%BEGIN form, Update controls, 22:27:38-25.11.1999, Code automatically updated!
	_FIRSTNAME = dialog_VLGetstr(idc_firstname,_VALLIST),
	_LASTNAME = dialog_VLGetstr(idc_lastname,_VALLIST),
%END form, Update controls
	!.

%MARK form, new events

%BEGIN form, idc_end _CtlInfo
  dlg_form_eh(_Win,e_Control(idc_end,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
  	count(Count),
	set_current_record(_Win,Count),  % Needs to be changed !!!!
  	show_current_record(_Win),
	!.
%END form, idc_end _CtlInfo

%BEGIN form, idc_home _CtlInfo
  dlg_form_eh(_Win,e_Control(idc_home,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	set_current_record(_Win,0),
  	show_current_record(_Win),
	!.
%END form, idc_home _CtlInfo

%BEGIN form, idc_next _CtlInfo
  dlg_form_eh(_Win,e_Control(idc_next,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
  	cur_record(_Win,Id),
  	Id1 = Id + 1,
  	record(Id1,_,_), !,
	set_current_record(_Win,Id1),
  	show_current_record(_Win),
	!.
%END form, idc_next _CtlInfo

%BEGIN form, idc_prev _CtlInfo
  dlg_form_eh(_Win,e_Control(idc_prev,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
  	cur_record(_Win,Id),
  	Id1 = Id - 1,
  	record(Id1,_,_), !,
	set_current_record(_Win,Id1),
  	show_current_record(_Win),
	!.
%END form, idc_prev _CtlInfo

%BEGIN form, e_Create
  dlg_form_eh(_Win,e_Create(_CreationData),0):-!,
  	retract(initnr(Nr)), !,
  	retractall(cur_record(_Win,_)),
	assert(cur_record(_Win,Nr)),
  	show_current_record(_Win),
	!.
%END form, e_Create

%BEGIN form, e_User, Parent window 
  dlg_form_eh(Win,e_User(ID1,ID2),0):-!,
	PARENT = win_GetParent(Win),
	win_SendEvent(PARENT,e_User(ID1,ID2)),
	!.
%END form, e_User, Parent window
%END_DLG form




















