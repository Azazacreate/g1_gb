/******************************************************************************

		Copyright (c) 1984 - 1998 Prolog Development Center A/S

 Project:	ODBCLAB
 FileName:	ODBCLAB.PRO
 Purpose:	ODBC test program
 Written by:	Sergey Alexeev
 Build:		005.970916
 Comments:
******************************************************************************/
CODE = 5000

include "odbclab.con"
include "odbclab.inc"
include "dlg.pro"

/***************************************************************************
	Event handling for Task Window
***************************************************************************/
database - data_db
  determ data_henv(HENV)
  determ data_hdbc(HDBC)
  determ data_hstmt(HSTMT)
  determ data_connect()
  ham_column_data(HENV,HDBC,HSTMT,INTEGER Column,HAM)
  ham_param_data(HENV,HDBC,HSTMT,INTEGER IPar,HAM)
  ham_data(HAM)

constants
  task_win_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Close,wsf_Maximized,wsf_Maximize,wsf_Minimize,wsf_ClipSiblings]
  task_win_Menu  = res_menu(idr_task_menu)
  task_win_Title = "ODBC Laboratory"
predicates
  task_win_eh : EHANDLER
% Connect
  allocenv()
  allocconnect()
  connect(WINDOW)
  browseconnect(WINDOW)
  driverconnect(WINDOW)
  disconnect()
  freeconnect()
  freeenv()
  setconnectoption(WINDOW)
  getconnectoption(WINDOW)
  datasources(WINDOW)
  drivers(WINDOW)
  getinfo(WINDOW)
%
  fullconnect(WINDOW)
  fulldisconnect()
  fullgetinfo()
  fulldatasources()
  fulldrivers()
% Statement
  allocstmt()
  setstmtoption(WINDOW)
  getstmtoption(WINDOW)
  prepare(WINDOW)
  bindparameter(WINDOW)
  numparams()
  describeparam(WINDOW)
  execute()
  execdirect(WINDOW)
  setcursorname(WINDOW)
  getcursorname()
  paramdata()
  putdata()
  paramoptions(WINDOW)
  freestmt(WINDOW)
  nativesql(WINDOW)
%
  getbindparameter(WINDOW)
%
  reloadstmt()
% Results
  numresultcols()
  describecol(WINDOW)
  colattributes(WINDOW)
  rowcount()
  bindcol(WINDOW)
  fetch()
  extendedfetch(WINDOW)
  setpos(WINDOW)
  getdata(WINDOW)
  moreresults()
  setscrolloptions(WINDOW)
%
  getbindcol(WINDOW)
%
  fullgetdata()
  fullgetdatacolumn(WINDOW)
% Catalog
  gettypeinfo(WINDOW)
  tables(WINDOW)
  columns(WINDOW)
  statistics(WINDOW)
  primarykeys(WINDOW)
  foreignkeys(WINDOW)
  tableprivileges(WINDOW)
  columnprivileges(WINDOW)
  specialcolumns(WINDOW)
  procedures(WINDOW)
  procedurecolumns(WINDOW)
% Misc
  transact(WINDOW)
  cancel()
  geterror()
  getfunctions(WINDOW)
%
  fullgetfunctions()
%**************************%
  release_ham()
  error_h()
clauses
  release_ham():-
	retract(ham_column_data(_,_,_,_,Ham)),
	trap(odbcReleaseHam(Ham),_,error_h()),
	fail.
  release_ham():-
	retract(ham_param_data(_,_,_,_,Ham)),
	trap(odbcReleaseHam(Ham),_,error_h()),
	fail.
  release_ham().

  task_win_eh(_,e_Create(_),0):-
	odbcInit(),
	consult_base(),
	MsgWin = msg_Create(100),
	win_SetState(MsgWin,[wsf_Maximized]),!.
  task_win_eh(Win,e_Create(_),0):-!,
	dlg_Note("ODBC support is not instaled"),
	win_Destroy(Win),!.

  task_win_eh(_,e_Destroy,0):-!,
	save_base(),
	release_ham(),
	odbcDestroy().

% Connect
  task_win_eh(_Win,e_Menu(id_allocenv,_),0):-
	allocenv(),!.
  task_win_eh(_Win,e_Menu(id_allocconnect,_),0):-
	allocconnect(),!.
  task_win_eh(Win,e_Menu(id_connect,_),0):-
	connect(Win),!.
  task_win_eh(Win,e_Menu(id_browseconnect,_),0):-
	browseconnect(Win),!.
  task_win_eh(Win,e_Menu(id_driverconnect,_),0):-
	driverconnect(Win),!.
  task_win_eh(_Win,e_Menu(id_disconnect,_),0):-
	disconnect(),!.
  task_win_eh(_Win,e_Menu(id_freeconnect,_),0):-
	freeconnect(),!.
  task_win_eh(_Win,e_Menu(id_freeenv,_),0):-
	freeenv(),!.
  task_win_eh(Win,e_Menu(id_setconnectoption,_),0):-
	setconnectoption(Win),!.
  task_win_eh(Win,e_Menu(id_getconnectoption,_),0):-
	getconnectoption(Win),!.
  task_win_eh(Win,e_Menu(id_datasources,_),0):-
	datasources(Win),!.
  task_win_eh(Win,e_Menu(id_drivers,_),0):-
	drivers(Win),!.
  task_win_eh(Win,e_Menu(id_getinfo,_),0):-
	getinfo(Win),!.
%
  task_win_eh(Win,e_Menu(id_fullconnect,_),0):-
	fullconnect(Win),!.
  task_win_eh(_Win,e_Menu(id_fulldisconnect,_),0):-
	fulldisconnect(),!.
  task_win_eh(_Win,e_Menu(id_fullgetinfo,_),0):-
	fullgetinfo(),!.
  task_win_eh(_Win,e_Menu(id_fulldatasources,_),0):-
	fulldatasources(),!.
  task_win_eh(_Win,e_Menu(id_fulldrivers,_),0):-
	fulldrivers(),!.
% Statement
  task_win_eh(_Win,e_Menu(id_allocstmt,_),0):-
	allocstmt(),!.
  task_win_eh(Win,e_Menu(id_setstmtoption,_),0):-
	setstmtoption(Win),!.
  task_win_eh(Win,e_Menu(id_getstmtoption,_),0):-
	getstmtoption(Win),!.
  task_win_eh(Win,e_Menu(id_prepare,_),0):-
	prepare(Win),!.
  task_win_eh(Win,e_Menu(id_bindparameter,_),0):-
	bindparameter(Win),!.
  task_win_eh(_Win,e_Menu(id_numparams,_),0):-
	numparams(),!.
  task_win_eh(Win,e_Menu(id_describeparam,_),0):-
	describeparam(Win),!.
  task_win_eh(_Win,e_Menu(id_execute,_),0):-
	execute(),!.
  task_win_eh(Win,e_Menu(id_execdirect,_),0):-
	execdirect(Win),!.
  task_win_eh(Win,e_Menu(id_setcursorname,_),0):-
	setcursorname(Win),!.
  task_win_eh(_Win,e_Menu(id_getcursorname,_),0):-
	getcursorname(),!.
  task_win_eh(_Win,e_Menu(id_paramdata,_),0):-
	paramdata(),!.
  task_win_eh(_Win,e_Menu(id_putdata,_),0):-
	putdata(),!.
  task_win_eh(Win,e_Menu(id_paramoptions,_),0):-
	paramoptions(Win),!.
  task_win_eh(Win,e_Menu(id_freestmt,_),0):-
	freestmt(Win),!.
  task_win_eh(Win,e_Menu(id_nativesql,_),0):-
	nativesql(Win),!.
%
  task_win_eh(Win,e_Menu(id_getbindparameter,_),0):-
	getbindparameter(Win),!.
%
  task_win_eh(_Win,e_Menu(id_reloadstmt,_),0):-
	reloadstmt(),!.
% Results
  task_win_eh(_Win,e_Menu(id_numresultcols,_),0):-
	numresultcols(),!.
  task_win_eh(Win,e_Menu(id_describecol,_),0):-
	describecol(Win),!.
  task_win_eh(Win,e_Menu(id_colattributes,_),0):-
	colattributes(Win),!.
  task_win_eh(_Win,e_Menu(id_rowcount,_),0):-
	rowcount(),!.
  task_win_eh(Win,e_Menu(id_bindcol,_),0):-
	bindcol(Win),!.
  task_win_eh(_Win,e_Menu(id_fetch,_),0):-
	fetch(),!.
  task_win_eh(Win,e_Menu(id_extendedfetch,_),0):-
	extendedfetch(Win),!.
  task_win_eh(Win,e_Menu(id_setpos,_),0):-
	setpos(Win),!.
  task_win_eh(Win,e_Menu(id_getdata,_),0):-
	getdata(Win),!.
  task_win_eh(_Win,e_Menu(id_moreresults,_),0):-
	moreresults(),!.
  task_win_eh(Win,e_Menu(id_setscrolloptions,_),0):-
	setscrolloptions(Win),!.
%
  task_win_eh(Win,e_Menu(id_getbindcol,_),0):-
	getbindcol(Win),!.
%
  task_win_eh(_Win,e_Menu(id_fullgetdata,_),0):-
	fullgetdata(),!.
  task_win_eh(Win,e_Menu(id_fullgetdatacolumn,_),0):-
	fullgetdatacolumn(Win),!.
% Catalog
  task_win_eh(Win,e_Menu(id_gettypeinfo,_),0):-
	gettypeinfo(Win),!.
  task_win_eh(Win,e_Menu(id_tables,_),0):-
	tables(Win),!.
  task_win_eh(Win,e_Menu(id_columns,_),0):-
	columns(Win),!.
  task_win_eh(Win,e_Menu(id_statistics,_),0):-
	statistics(Win),!.
  task_win_eh(Win,e_Menu(id_primarykeys,_),0):-
	primarykeys(Win),!.
  task_win_eh(Win,e_Menu(id_foreignkeys,_),0):-
	foreignkeys(Win),!.
  task_win_eh(Win,e_Menu(id_tableprivileges,_),0):-
	tableprivileges(Win),!.
  task_win_eh(Win,e_Menu(id_columnprivileges,_),0):-
	columnprivileges(Win),!.
  task_win_eh(Win,e_Menu(id_specialcolumns,_),0):-
	specialcolumns(Win),!.
  task_win_eh(Win,e_Menu(id_procedures,_),0):-
	procedures(Win),!.
  task_win_eh(Win,e_Menu(id_procedurecolumns,_),0):-
	procedurecolumns(Win),!.
% Misc
  task_win_eh(Win,e_Menu(id_transact,_),0):-
	transact(Win),!.
  task_win_eh(_Win,e_Menu(id_cancel,_),0):-
	cancel(),!.
  task_win_eh(_Win,e_Menu(id_error,_),0):-
	geterror(),!.
  task_win_eh(Win,e_Menu(id_getfunctions,_),0):-
	getfunctions(Win),!.
%
  task_win_eh(_Win,e_Menu(id_fullgetfunctions,_),0):-
	fullgetfunctions(),!.

/***************************************************************************
	Main Goal
***************************************************************************/
GOAL
  vpi_SetAttrVal(attr_win_mdi,b_true),
  vpi_SetAttrVal(attr_win_3dcontrols,b_true),
  vpi_Init(task_win_Flags,task_win_eh,task_win_Menu,"ODBC Laboratory",task_win_Title).
predicates
  error()
  get_henv(HENV)
  get_hdbc(HDBC)
  get_hstmt(HSTMT)
clauses
  error_h():-
	odbcGetError(ErrCode,ErrFunc,ErrMess),
	format(Msg,"Error in predicate '%s': \"%s\" (ErrCode=%)",ErrFunc,ErrMess,ErrCode),
	dlg_Error(Msg),
	fail.
	
  error():-
	odbcGetError(ErrCode,ErrFunc,ErrMess),
	writef("Return: Function='%s', Message='%s' (Error code=%)\n",ErrFunc,ErrMess,ErrCode),!.

  get_henv(Henv):-
	data_henv(Henv),!.
  get_henv(Henv):-
	Henv = val(henv,0),!.
  get_hdbc(Hdbc):-
	data_hdbc(Hdbc),!.
  get_hdbc(Hdbc):-
	Hdbc = val(henv,0),!.
  get_hstmt(Hstmt):-
	data_hstmt(Hstmt),!.
  get_hstmt(Hstmt):-
	Hstmt = val(henv,0),!.
clauses
/***************************************************************************
	Connect
***************************************************************************/
  allocenv():-
	data_henv(_),
	writef("Return: Function='Application', Message='Env already allocated'\n"),!.
  allocenv():-
	trap(odbcAllocEnv(Henv),_,error_h()),
	assert(data_henv(Henv)),
	error(),!.
  allocenv():-
	error(),!.

  allocconnect():-
	data_hdbc(_),
	writef("Return: Function='Application', Message='Dbc already allocated'\n"),!.
  allocconnect():-
	get_henv(Henv),
	trap(odbcAllocConnect(Henv,Hdbc),_,error_h()),
	assert(data_hdbc(Hdbc)),
	error(),!.
  allocconnect():-
	error(),!.

predicates
  connect1(STRING BaseName,STRING UserId,STRING Password)
clauses
  connect(_):-
	data_connect(),
	writef("Return: Function='Application', Message='Already connected'\n"),!.
  connect(Win):-
	dialog_connect(Win,BaseName,UserId,Password),
	connect1(BaseName,UserId,Password),!.
  connect(_).
  connect1(BaseName,UserId,Password):-
	get_henv(Henv),
	get_hdbc(Hdbc),
	trap(odbcConnect(Henv,Hdbc,BaseName,UserId,Password),_,error_h()),
	assert(data_connect()),
	error(),!.
  connect1(_,_,_):-
	error(),!.

predicates
  browseconnect1(STRING ConnStrIn)
clauses
  browseconnect(Win):-
	dialog_browseconnect(Win,ConnStrIn),
	browseconnect1(ConnStrIn),!.
  browseconnect(_).
  browseconnect1(ConnStrIn):-
	get_henv(Henv),
	get_hdbc(Hdbc),
	trap(odbcBrowseConnect(Henv,Hdbc,ConnStrIn,ConnStrOut),_,error_h()),
	writef("  Answer: ConnStrOut = '%s'\n",ConnStrOut),
	error(),!.
  browseconnect1(_):-
	error(),!.

predicates
  driverconnect1(WINDOW Win,STRING ConnStrIn,UNSIGNED DriverCompletion)
clauses
  driverconnect(Win):-
	dialog_driverconnect(Win,ConnStrIn,DriverCompletion),
	driverconnect1(Win,ConnStrIn,DriverCompletion),!.
  driverconnect(_).
  driverconnect1(Win,ConnStrIn,DriverCompletion):-
	get_henv(Henv),
	get_hdbc(Hdbc),
	trap(odbcDriverConnect(Henv,Hdbc,Win,ConnStrIn,DriverCompletion,
		ConnStrOut),_,error_h()),
	writef("  Answer: ConnStrOut = '%s'\n",ConnStrOut),
	assert(data_connect()),
	error(),!.
  driverconnect1(_,_,_):-
	error(),!.

  disconnect():-
	get_henv(Henv),
	get_hdbc(Hdbc),
	trap(odbcDisconnect(Henv,Hdbc),_,error_h()),
	retract(data_connect()),
	error(),!.
  disconnect():-
	error(),!.

  freeconnect():-
	get_henv(Henv),
	get_hdbc(Hdbc),
	trap(odbcFreeConnect(Henv,Hdbc),_,error_h()),
	retract(data_hdbc(_)),
	error(),!.
  freeconnect():-
	error(),!.

  freeenv():-
	get_henv(Henv),
	trap(odbcFreeEnv(Henv),_,error_h()),
	retract(data_henv(_)),
	error(),!.
  freeenv():-
	error(),!.

predicates
  setconnectoption1(UNSIGNED Option,ODBC_CO_DATA Param)
clauses
  setconnectoption(Win):-
	dialog_setconnectoption(Win,Option,Param),
	setconnectoption1(Option,Param),!.
  setconnectoption(_).
  setconnectoption1(Option,Param):-
	get_henv(Henv),
	get_hdbc(Hdbc),
	trap(odbcSetConnectOption(Henv,Hdbc,Option,Param),_,error_h()),
	error(),!.
  setconnectoption1(_,_):-
	error(),!.

predicates
  getconnectoption1(UNSIGNED Option)
  get_connectparam(UNSIGNED Option,ODBC_CO_DATA Param,STRING Title,STRING Str)
clauses
  getconnectoption(Win):-
	dialog_getconnectoption(Win,Option),
	getconnectoption1(Option),!.
  getconnectoption(_).
  getconnectoption1(Option):-
	get_henv(Henv),
	get_hdbc(Hdbc),
	trap(odbcGetConnectOption(Henv,Hdbc,Option,Param),_,error_h()),
	get_connectparam(Option,Param,Title,Str),
	writef("  Answer: %s = '%s'\n",Title,Str),
	error(),!.
  getconnectoption1(_):-
	error(),!.

  get_connectparam(odbc_access_mode,l(odbc_mode_read_only),"odbc_access_mode","odbc_mode_read_only"):-!.
  get_connectparam(odbc_access_mode,l(odbc_mode_read_write),"odbc_access_mode","odbc_mode_read_write"):-!.
  get_connectparam(odbc_access_mode,l(Data),"odbc_access_mode",DataS):-
	trap(term_str(long,Data,DataS),_,fail),!.
  get_connectparam(odbc_autocommit,l(odbc_autocommit_off),"odbc_autocommit","odbc_autocommit_off"):-!.
  get_connectparam(odbc_autocommit,l(odbc_autocommit_on),"odbc_autocommit","odbc_autocommit_on"):-!.
  get_connectparam(odbc_autocommit,l(Data),"odbc_autocommit",DataS):-
	trap(term_str(long,Data,DataS),_,fail),!.
  get_connectparam(odbc_current_qualifier,s(DataS),"odbc_current_qualifier",DataS):-!.
  get_connectparam(odbc_login_timeout,l(Data),"odbc_login_timeout",DataS):-
	trap(term_str(long,Data,DataS),_,fail),!.
  get_connectparam(odbc_odbc_cursors,l(odbc_cur_use_if_needed),"odbc_odbc_cursors","odbc_cur_use_if_needed"):-!.
  get_connectparam(odbc_odbc_cursors,l(odbc_cur_use_odbc),"odbc_odbc_cursors","odbc_cur_use_odbc"):-!.
  get_connectparam(odbc_odbc_cursors,l(odbc_cur_use_driver),"odbc_odbc_cursors","odbc_cur_use_driver"):-!.
  get_connectparam(odbc_odbc_cursors,l(Data),"odbc_odbc_cursors",DataS):-
	trap(term_str(long,Data,DataS),_,fail),!.
  get_connectparam(odbc_opt_trace,l(odbc_opt_trace_off),"odbc_opt_trace","odbc_opt_trace_off"):-!.
  get_connectparam(odbc_opt_trace,l(odbc_opt_trace_on),"odbc_opt_trace","odbc_opt_trace_on"):-!.
  get_connectparam(odbc_opt_trace,l(Data),"odbc_opt_trace",DataS):-
	trap(term_str(long,Data,DataS),_,fail),!.
  get_connectparam(odbc_opt_tracefile,s(DataS),"odbc_opt_tracefile",DataS):-!.
  get_connectparam(odbc_packet_size,l(Data),"odbc_packet_size",DataS):-
	trap(term_str(long,Data,DataS),_,fail),!.
  get_connectparam(odbc_quiet_mode,l(Data),"odbc_quiet_mode",DataS):-
	trap(term_str(long,Data,DataS),_,fail),!.
  get_connectparam(odbc_translate_dll,s(DataS),"odbc_translate_dll",DataS):-!.
  get_connectparam(odbc_translate_option,l(Data),"odbc_translate_option",DataS):-
	trap(term_str(long,Data,DataS),_,fail),!.
  get_connectparam(odbc_txn_isolation,l(odbc_txn_read_uncommitted),"odbc_txn_isolation","odbc_txn_read_uncommitted"):-!.
  get_connectparam(odbc_txn_isolation,l(odbc_txn_read_committed),"odbc_txn_isolation","odbc_txn_read_committed"):-!.
  get_connectparam(odbc_txn_isolation,l(odbc_txn_repeatable_read),"odbc_txn_isolation","odbc_txn_repeatable_read"):-!.
  get_connectparam(odbc_txn_isolation,l(odbc_txn_serializable),"odbc_txn_isolation","odbc_txn_serializable"):-!.
  get_connectparam(odbc_txn_isolation,l(odbc_txn_versioning),"odbc_txn_isolation","odbc_txn_versioning"):-!.
  get_connectparam(odbc_txn_isolation,l(Data),"odbc_txn_isolation",DataS):-
	trap(term_str(long,Data,DataS),_,fail),!.

predicates
  datasources1(INTEGER Id)
clauses
  datasources(Win):-
	dialog_datasources(Win,Id),
	datasources1(Id),!.
  datasources(_).
  datasources1(Id):-
	get_henv(Henv),
	trap(odbcDataSources(Henv,Id,Name,Description),_,error_h()),
	writef("  Answer: Name='%s', Description='%s'\n",Name,Description),
	error(),!.
  datasources1(_):-
	error(),!.

predicates
  drivers1(INTEGER Id)
clauses
  drivers(Win):-
	dialog_drivers(Win,Id),
	drivers1(Id),!.
  drivers(_).
  drivers1(Id):-
	get_henv(Henv),
	trap(odbcDrivers(Henv,Id,Description,Attributes),_,error_h()),
	writef("  Answer: Description='%s', Attributes='%s'\n",Description,Attributes),
	error(),!.
  drivers1(_):-
	error(),!.

predicates
  getinfo1(STRING,INTEGER)
  get_data(ODBC_INFO_DATA,STRING)
clauses
  getinfo(Win):-
	dialog_getinfo(Win,Str,Id),
	getinfo1(Str,Id),!.
  getinfo(_).
  getinfo1(Str,Id):-
	get_henv(Henv),
	get_hdbc(Hdbc),
	trap(odbcGetInfo(Henv,Hdbc,Id,Data),_,error_h()),
	get_data(Data,DataS),
	writef("  Answer: %s = '%s'\n",Str,DataS),
	error(),!.
  getinfo1(_,_):-
	error(),!.

  get_data(i(Data),DataS):-
	str_int(DataS,Data),!.
  get_data(l(Data),DataS):-
	trap(term_str(long,Data,DataS),_,fail),!.
  get_data(s(DataS),DataS):-!.
%___________________________________________________________________________
  fullconnect(Win):-
	allocenv(),
	allocconnect(),
	connect(Win),
	allocstmt(),!.
  fullconnect(_).

predicates
  freestmt1(INTEGER Option)
clauses
  fulldisconnect():-
	freestmt1(odbc_drop),
	disconnect(),
	freeconnect(),
	freeenv(),!.
  fulldisconnect().

predicates
  fullgetinfo1(HENV,HDBC,SLIST,INTEGER)
clauses
  fullgetinfo():-
	get_henv(Henv),
	get_hdbc(Hdbc),
	info_list(List,_),
	write("  Answer:     Name          Description\n"),
	fullgetinfo1(Henv,Hdbc,List,1),
	error(),!.
  fullgetinfo():-
	error(),!.
  fullgetinfo1(_,_,[],_):-!.
  fullgetinfo1(Henv,Hdbc,[_|Rest],7):-!,
	fullgetinfo1(Henv,Hdbc,Rest,8).
  fullgetinfo1(Henv,Hdbc,[Str|Rest],Id):-
	trap(odbcGetInfo(Henv,Hdbc,Id,Data),_,error_h()),
	get_data(Data,DataS),
	writef("                 %s = '%s'\n",Str,DataS),!,
	I = Id + 1,
	fullgetinfo1(Henv,Hdbc,Rest,I).

predicates
  fulldatasources1(HENV)
clauses
  fulldatasources():-
	get_henv(Henv),
	trap(odbcDataSources(Henv,odbc_fetch_first,Name,Description),_,error_h()),
	writef("  Answer: Name='%s', Description='%s'\n",Name,Description),
	fulldatasources1(Henv),!.
  fulldatasources():-
	error(),!.
  fulldatasources1(Henv):-
	trap(odbcDataSources(Henv,odbc_fetch_next,Name,Description),_,error_h()),
	writef("                 Name='%s', Description='%s'\n",Name,Description),!,
	fulldatasources1(Henv).
  fulldatasources1(_):-
	error(),!.

predicates
  fulldrivers1(HENV)
clauses
  fulldrivers():-
	get_henv(Henv),
	trap(odbcDrivers(Henv,odbc_fetch_first,Description,Attributes),_,error_h()),
	writef("  Answer: Description='%s', Attributes='%s'\n",Description,Attributes),
	fulldrivers1(Henv),!.
  fulldrivers():-
	error(),!.
  fulldrivers1(Henv):-
	trap(odbcDrivers(Henv,odbc_fetch_next,Description,Attributes),_,error_h()),
	writef("                 Description='%s', Attributes='%s'\n",Description,Attributes),!,
	fulldrivers1(Henv).
  fulldrivers1(_):-
	error(),!.
/***************************************************************************
	Statement
***************************************************************************/
  allocstmt():-
	data_hstmt(_),
	writef("Return: Function='Application', Message='Stmt already allocated'\n"),!.
  allocstmt():-
	get_henv(Henv),
	get_hdbc(Hdbc),
	trap(odbcAllocStmt(Henv,Hdbc,Hstmt),_,error_h()),
	assert(data_hstmt(Hstmt)),
	error(),!.
  allocstmt():-
	error(),!.

predicates
  setstmtoption1(UNSIGNED Option,LONG Param)
clauses
  setstmtoption(Win):-
	dialog_setstmtoption(Win,Option,Param),
	setstmtoption1(Option,Param),!.
  setstmtoption(_).
  setstmtoption1(Option,Param):-
	get_henv(Henv),
	get_hdbc(Hdbc),
	get_hstmt(Hstmt),
	trap(odbcSetStmtOption(Henv,Hdbc,Hstmt,Option,Param),_,error_h()),
	error(),!.
  setstmtoption1(_,_):-
	error(),!.

predicates
  getstmtoption1(UNSIGNED Option)
  get_stmtparam(UNSIGNED Option,LONG Param,STRING Title,STRING Str)
clauses
  getstmtoption(Win):-
	dialog_getstmtoption(Win,Option),
	getstmtoption1(Option),!.
  getstmtoption(_).
  getstmtoption1(Option):-
	get_henv(Henv),
	get_hdbc(Hdbc),
	get_hstmt(Hstmt),
	trap(odbcGetStmtOption(Henv,Hdbc,Hstmt,Option,Param),_,error_h()),
	get_stmtparam(Option,Param,Title,Str),
	writef("  Answer: %s = '%s'\n",Title,Str),
	error(),!.
  getstmtoption1(_):-
	error(),!.

  get_stmtparam(odbc_async_enable,odbc_async_enable_off,"odbc_async_enable","odbc_async_enable_off"):-!.
  get_stmtparam(odbc_async_enable,odbc_async_enable_on,"odbc_async_enable","odbc_async_enable_on"):-!.
  get_stmtparam(odbc_async_enable,Data,"odbc_async_enable",DataS):-
	trap(term_str(long,Data,DataS),_,fail),!.
  get_stmtparam(odbc_bind_type,odbc_bind_by_column,"odbc_bind_type","odbc_bind_by_column"):-!.
  get_stmtparam(odbc_bind_type,Data,"odbc_bind_type",DataS):-
	trap(term_str(long,Data,DataS),_,fail),!.
  get_stmtparam(odbc_concurrency,odbc_concur_read_only,"odbc_concurrency","odbc_concur_read_only"):-!.
  get_stmtparam(odbc_concurrency,odbc_concur_lock,"odbc_concurrency","odbc_concur_lock"):-!.
  get_stmtparam(odbc_concurrency,odbc_concur_rowver,"odbc_concurrency","odbc_concur_rowver"):-!.
  get_stmtparam(odbc_concurrency,odbc_concur_values,"odbc_concurrency","odbc_concur_values"):-!.
  get_stmtparam(odbc_concurrency,Data,"odbc_concurrency",DataS):-
	trap(term_str(long,Data,DataS),_,fail),!.
  get_stmtparam(odbc_cursor_type,odbc_cursor_forward_only,"odbc_cursor_type","odbc_cursor_forward_only"):-!.
  get_stmtparam(odbc_cursor_type,odbc_cursor_static,"odbc_cursor_type","odbc_cursor_static"):-!.
  get_stmtparam(odbc_cursor_type,odbc_cursor_keyset_driven,"odbc_cursor_type","odbc_cursor_keyset_driven"):-!.
  get_stmtparam(odbc_cursor_type,odbc_cursor_dynamic,"odbc_cursor_type","odbc_cursor_dynamic"):-!.
  get_stmtparam(odbc_cursor_type,Data,"odbc_cursor_type",DataS):-
	trap(term_str(long,Data,DataS),_,fail),!.
  get_stmtparam(odbc_keyset_size,Data,"odbc_keyset_size",DataS):-
	trap(term_str(long,Data,DataS),_,fail),!.
  get_stmtparam(odbc_max_length,Data,"odbc_max_length",DataS):-
	trap(term_str(long,Data,DataS),_,fail),!.
  get_stmtparam(odbc_max_rows,Data,"odbc_max_rows",DataS):-
	trap(term_str(long,Data,DataS),_,fail),!.
  get_stmtparam(odbc_noscan,odbc_noscan_off,"odbc_noscan","odbc_noscan_off"):-!.
  get_stmtparam(odbc_noscan,odbc_noscan_on,"odbc_noscan","odbc_noscan_on"):-!.
  get_stmtparam(odbc_noscan,Data,"odbc_noscan",DataS):-
	trap(term_str(long,Data,DataS),_,fail),!.
  get_stmtparam(odbc_query_timeout,Data,"odbc_query_timeout",DataS):-
	trap(term_str(long,Data,DataS),_,fail),!.
  get_stmtparam(odbc_retrieve_data,odbc_rd_on,"odbc_retrieve_data","odbc_rd_on"):-!.
  get_stmtparam(odbc_retrieve_data,odbc_rd_off,"odbc_retrieve_data","odbc_rd_off"):-!.
  get_stmtparam(odbc_retrieve_data,Data,"odbc_retrieve_data",DataS):-
	trap(term_str(long,Data,DataS),_,fail),!.
  get_stmtparam(odbc_rowset_size,Data,"odbc_rowset_size",DataS):-
	trap(term_str(long,Data,DataS),_,fail),!.
  get_stmtparam(odbc_simulate_cursor,odbc_sc_non_unique,"odbc_simulate_cursor","odbc_sc_non_unique"):-!.
  get_stmtparam(odbc_simulate_cursor,odbc_sc_try_unique,"odbc_simulate_cursor","odbc_sc_try_unique"):-!.
  get_stmtparam(odbc_simulate_cursor,odbc_sc_unique,"odbc_simulate_cursor","odbc_sc_unique"):-!.
  get_stmtparam(odbc_simulate_cursor,Data,"odbc_simulate_cursor",DataS):-
	trap(term_str(long,Data,DataS),_,fail),!.
  get_stmtparam(odbc_use_bookmarks,odbc_ub_off,"odbc_use_bookmarks","odbc_ub_off"):-!.
  get_stmtparam(odbc_use_bookmarks,odbc_ub_on,"odbc_use_bookmarks","odbc_ub_on"):-!.
  get_stmtparam(odbc_use_bookmarks,Data,"odbc_use_bookmarks",DataS):-
	trap(term_str(long,Data,DataS),_,fail),!.
  get_stmtparam(odbc_get_bookmark,Data,"odbc_get_bookmark",DataS):-
	trap(term_str(long,Data,DataS),_,fail),!.
  get_stmtparam(odbc_row_number,Data,"odbc_row_number",DataS):-
	trap(term_str(long,Data,DataS),_,fail),!.

predicates
  prepare1(STRING Str)
clauses
  prepare(Win):-
	dialog_prepare(Win,Str),
	prepare1(Str),!.
  prepare(_).
  prepare1(Str):-
	get_henv(Henv),
	get_hdbc(Hdbc),
	get_hstmt(Hstmt),
	trap(odbcPrepare(Henv,Hdbc,Hstmt,Str),_,error_h()),
	error(),!.
  prepare1(_):-
	error(),!.

predicates
  bindparameter1(UNSIGNED Ipar,UNSIGNED ParamType,UNSIGNED DataType,
	LONG ColDef,INTEGER IbScale,UNSIGNED BufferLen)
clauses
  bindparameter(Win):-
	dialog_bindparameter(Win,Ipar,ParamType,DataType,ColDef,IbScale,BufferLen),
	bindparameter1(Ipar,ParamType,DataType,ColDef,IbScale,BufferLen),!.
  bindparameter(_).
  bindparameter1(Ipar,ParamType,DataType,ColDef,IbScale,BufferLen):-
	get_henv(Henv),
	get_hdbc(Hdbc),
	get_hstmt(Hstmt),
	trap(odbcBindParameter(Henv,Hdbc,Hstmt,Ipar,ParamType,DataType,ColDef,
		IbScale,BufferLen,Ham),_,error_h()),
	assert(ham_param_data(Henv,Hdbc,Hstmt,Ipar,Ham)),
	error(),!.
  bindparameter1(_,_,_,_,_,_):-
	error(),!.

  numparams():-
	get_henv(Henv),
	get_hdbc(Hdbc),
	get_hstmt(Hstmt),
	trap(odbcNumParams(Henv,Hdbc,Hstmt,NumPar),_,error_h()),
	writef("  Answer: Number of parameters = '%'\n",NumPar),
	error(),!.
  numparams():-
	error(),!.

predicates
  get_data3(INTEGER,STRING)
  get_data4(INTEGER,STRING)
  describeparam1(INTEGER)
clauses
  describeparam(Win):-
	dialog_describeparam(Win,Param),
	describeparam1(Param),!.
  describeparam(_).
  describeparam1(Param):-
	get_henv(Henv),
	get_hdbc(Hdbc),
	get_hstmt(Hstmt),
	trap(odbcDescribeParam(Henv,Hdbc,Hstmt,Param,Type,Precision,Scale,
		Nullable),_,error_h()),
	get_data3(Type,TypeS),
	get_data4(Nullable,NullableS),
	writef("  Answer: Type='%s', Precision='%', Scale='%', Nullable='%s'\n",
	Types,Precision,Scale,NullableS),
	error(),!.
  describeparam1(_):-
	error(),!.

  get_data3(odbc_string,"1 (odbc_string)"):-!.
  get_data3(odbc_bit,"2 (odbc_bit)"):-!.
  get_data3(odbc_byte,"3 (odbc_byte)"):-!.
  get_data3(odbc_integer,"4 (odbc_integer)"):-!.
  get_data3(odbc_long,"5 (odbc_long)"):-!.
  get_data3(odbc_float,"6 (odbc_float)"):-!.
  get_data3(odbc_real,"7 (odbc_real)"):-!.
  get_data3(odbc_date,"8 (odbc_date)"):-!.
  get_data3(odbc_time,"9 (odbc_time)"):-!.
  get_data3(odbc_timestamp,"10 (odbc_timestamp)"):-!.
  get_data3(odbc_binary,"11 (odbc_binary)"):-!.
  get_data3(odbc_numeric,"12 (odbc_numeric)"):-!.
  get_data3(odbc_memo,"13 (odbc_memo)"):-!.

  get_data4(odbc_no_nulls,"1 (odbc_no_nulls)"):-!.
  get_data4(odbc_nullable,"2 (odbc_nullable)"):-!.
  get_data4(odbc_nullable_unknown,"3 (odbc_nullable_unknown)"):-!.

  execute():-
	get_henv(Henv),
	get_hdbc(Hdbc),
	get_hstmt(Hstmt),
	trap(odbcExecute(Henv,Hdbc,Hstmt),_,error_h()),
	error(),!.
  execute():-
	error(),!.

predicates
  execdirect1(STRING Str)
clauses
  execdirect(Win):-
	dialog_execdirect(Win,Str),
	execdirect1(Str),!.
  execdirect(_).
  execdirect1(Str):-
	get_henv(Henv),
	get_hdbc(Hdbc),
	get_hstmt(Hstmt),
	trap(odbcExecDirect(Henv,Hdbc,Hstmt,Str),_,error_h()),
	error(),!.
  execdirect1(_):-
	error(),!.

predicates
  setcursorname1(STRING Str)
clauses
  setcursorname(Win):-
	dialog_setcursorname(Win,Str),
	setcursorname1(Str),!.
  setcursorname(_).
  setcursorname1(Str):-
	get_henv(Henv),
	get_hdbc(Hdbc),
	get_hstmt(Hstmt),
	trap(odbcSetCursorName(Henv,Hdbc,Hstmt,Str),_,error_h()),
	error(),!.
  setcursorname1(_):-
	error(),!.

  getcursorname():-
	get_henv(Henv),
	get_hdbc(Hdbc),
	get_hstmt(Hstmt),
	trap(odbcGetCursorName(Henv,Hdbc,Hstmt,Cursor),_,error_h()),
	writef("  Answer: Cursor name = '%s'\n",Cursor),
	error(),!.
  getcursorname():-
	error(),!.

  paramdata():-
	ham_data(_),
	writef("Return: Function='Application', Message='HAM is already allocated'\n"),!.
  paramdata():-
	get_henv(Henv),
	get_hdbc(Hdbc),
	get_hstmt(Hstmt),
	trap(odbcParamData(Henv,Hdbc,Hstmt,Ham),_,error_h()),
	assert(ham_data(Ham)),
	error(),!.
  paramdata():-
	error(),!.

  putdata():-
	not(ham_data(_)),
	writef("Return: Function='Application', Message='HAM is not allocated. Use 'odbcParamData'\n"),!.
  putdata():-
	get_henv(Henv),
	get_hdbc(Hdbc),
	get_hstmt(Hstmt),
	retract(ham_data(Ham)),
	trap(odbcPutdata(Henv,Hdbc,Hstmt,Ham),_,error_h()),
	error(),!.
  putdata():-
	error(),!.

predicates
  paramoptions1(LONG Crow)
clauses
  paramoptions(Win):-
	dialog_paramoptions(Win,Crow),
	paramoptions1(Crow),!.
  paramoptions(_).
  paramoptions1(Crow):-
	get_henv(Henv),
	get_hdbc(Hdbc),
	get_hstmt(Hstmt),
	odbcAllocHul(Irow),
	odbcPutHul(Irow,0),
	trap(odbcParamOptions(Henv,Hdbc,Hstmt,Crow,Irow),_,error_h()),
	error(),!.
  paramoptions1(_):-
	error(),!.

predicates
  freestmt2(INTEGER Option)
clauses
  freestmt(Win):-
	dialog_freestmt(Win,Option),
	freestmt1(Option),!.
  freestmt1(Option):-
	get_henv(Henv),
	get_hdbc(Hdbc),
	get_hstmt(Hstmt),
	trap(odbcFreeStmt(Henv,Hdbc,Hstmt,Option),_,error_h()),
	freestmt2(Option),
	release_ham(),
	error(),!.
  freestmt1(_):-
	error(),!.
  freestmt2(odbc_drop):-
	retract(data_hstmt(_)),!.
  freestmt2(_).

predicates
  nativesql1(STRING Str)
clauses
  nativesql(Win):-
	dialog_nativesql(Win,Str),
	nativesql1(Str),!.
  nativesql(_).
  nativesql1(Str):-
	get_henv(Henv),
	get_hdbc(Hdbc),
	trap(odbcNativeSql(Henv,Hdbc,Str,StrOut),_,error_h()),
	writef("  Answer: OutSQL = '%'\n",StrOut),
	error(),!.
  nativesql1(_):-
	error(),!.

%___________________________________________________________________________
predicates
  getbindparameter1(INTEGER IPar)
  getbindparameter2(HAM)
  get_data1(ODBC_DATA,STRING)
clauses
  getbindparameter(Win):-
	dialog_getbindparameter(Win,IPar),
	getbindparameter1(IPar),!.
  getbindparameter(_).
  getbindparameter1(IPar):-
	get_henv(Henv),
	get_hdbc(Hdbc),
	get_hstmt(Hstmt),
	ham_param_data(Henv,Hdbc,Hstmt,IPar,Ham),
	getbindparameter2(Ham),!.
  getbindparameter1(_):-
	writef("Return: Function='Application', Message='HAM is not allocated'\n"),!.
  getbindparameter2(Ham):-
	trap(odbcGetHam(Ham,Data),_,error_h()),
	get_data1(Data,DataS),
	writef("  Answer: '%s'\n",DataS),
	error(),!.
  getbindparameter2(_):-
	error(),!.

%___________________________________________________________________________
  reloadstmt():-
	freestmt1(odbc_close),
	get_henv(Henv),
	get_hdbc(Hdbc),
	get_hstmt(Hstmt),
	prepare_str(Str),
	trap(odbcExecDirect(Henv,Hdbc,Hstmt,Str),_,error_h()),
	error(),!.
  reloadstmt():-
	error(),!.

/***************************************************************************
	Results
***************************************************************************/
  numresultcols():-
	get_henv(Henv),
	get_hdbc(Hdbc),
	get_hstmt(Hstmt),
	trap(odbcNumResultCols(Henv,Hdbc,Hstmt,NumCol),_,error_h()),
	writef("  Answer: '%'\n",NumCol),
	error(),!.
  numresultcols():-
	error(),!.

predicates
  describecol1(INTEGER)
clauses
  describecol(Win):-
	dialog_describecol(Win,Column),
	describecol1(Column),!.
  describecol(_).
  describecol1(Column):-
	get_henv(Henv),
	get_hdbc(Hdbc),
	get_hstmt(Hstmt),
	trap(odbcDescribeCol(Henv,Hdbc,Hstmt,Column,Name,Type,Precision,
		Scale,Nullable),_,error_h()),
	get_data3(Type,TypeS),
	get_data4(Nullable,NullableS),
	writef("  Answer: Name='%s', Type='%s',\n          Precision='%', Scale='%', Nullable='%s'\n",
	Name,Types,Precision,Scale,NullableS),
	error(),!.
  describecol1(_):-
	error(),!.

predicates
  get_data2(ODBC_COLUMN_DATA,STRING)
  colattributes1(INTEGER,INTEGER)
clauses
  colattributes(Win):-
	dialog_colattributes(Win,Column,Id),
	colattributes1(Column,Id),!.
  colattributes(_).
  colattributes1(Column,Id):-
	get_henv(Henv),
	get_hdbc(Hdbc),
	get_hstmt(Hstmt),
	trap(odbcColAttributes(Henv,Hdbc,Hstmt,Column,Id,Data),_,error_h()),
	get_data2(Data,DataS),
	writef("  Answer: '%s'\n",DataS),
	error(),!.
  colattributes1(_,_):-
	error(),!.

  get_data2(ai(b_true),"TRUE"):-!.
  get_data2(ai(b_false),"FALSE"):-!.
  get_data2(cs(b_true),"TRUE"):-!.
  get_data2(cs(b_false),"FALSE"):-!.
  get_data2(co(Data),DataS):-
	str_int(DataS,Data),!.
  get_data2(ds(Data),DataS):-
	trap(term_str(long,Data,DataS),_,fail),!.
  get_data2(la(DataS),DataS):-!.
  get_data2(le(Data),DataS):-
	trap(term_str(long,Data,DataS),_,fail),!.
  get_data2(mo(b_true),"TRUE"):-!.
  get_data2(mo(b_false),"FALSE"):-!.
  get_data2(na(DataS),DataS):-!.
  get_data2(nu(odbc_no_nulls),"1 (odbc_no_nulls)"):-!.
  get_data2(nu(odbc_nullable),"2 (odbc_nullable)"):-!.
  get_data2(nu(odbc_nullable_unknown),"3 (odbc_nullable_unknown)"):-!.
  get_data2(on(DataS),DataS):-!.
  get_data2(pr(Data),DataS):-
	trap(term_str(long,Data,DataS),_,fail),!.
  get_data2(qn(DataS),DataS):-!.
  get_data2(sc(Data),DataS):-
	trap(term_str(long,Data,DataS),_,fail),!.
  get_data2(se(odbc_unsearchable),"1 (odbc_unsearchable)"):-!.
  get_data2(se(odbc_like_only),"2 (odbc_like_only)"):-!.
  get_data2(se(odbc_all_except_like),"3 (odbc_all_except_like)"):-!.
  get_data2(se(odbc_searchable),"4 (odbc_searchable)"):-!.
  get_data2(tn(DataS),DataS):-!.

  get_data2(ty(odbc_string),"1 (odbc_string)"):-!.
  get_data2(ty(odbc_bit),"2 (odbc_bit)"):-!.
  get_data2(ty(odbc_byte),"3 (odbc_byte)"):-!.
  get_data2(ty(odbc_integer),"4 (odbc_integer)"):-!.
  get_data2(ty(odbc_long),"5 (odbc_long)"):-!.
  get_data2(ty(odbc_float),"6 (odbc_float)"):-!.
  get_data2(ty(odbc_real),"7 (odbc_real)"):-!.
  get_data2(ty(odbc_date),"8 (odbc_date)"):-!.
  get_data2(ty(odbc_time),"9 (odbc_time)"):-!.
  get_data2(ty(odbc_timestamp),"10 (odbc_timestamp)"):-!.
  get_data2(ty(odbc_binary),"11 (odbc_binary)"):-!.
  get_data2(ty(odbc_numeric),"12 (odbc_numeric)"):-!.
  get_data2(ty(odbc_memo),"13 (odbc_memo)"):-!.
  get_data2(ta(DataS),DataS):-!.
  get_data2(un(b_true),"TRUE"):-!.
  get_data2(un(b_false),"FALSE"):-!.
  get_data2(up(odbc_attr_readonly),"1 (odbc_attr_readonly)"):-!.
  get_data2(up(odbc_attr_write),"2 (odbc_attr_write)"):-!.
  get_data2(up(odbc_attr_readwrite_unknown),"3 (odbc_attr_readwrite_unknown)"):-!.

  rowcount():-
	get_henv(Henv),
	get_hdbc(Hdbc),
	get_hstmt(Hstmt),
	trap(odbcRowCount(Henv,Hdbc,Hstmt,NumRow),_,error_h()),
	writef("  Answer: '%'\n",NumRow),
	error(),!.
  rowcount():-
	error(),!.

predicates
  bindcol1(INTEGER Column,INTEGER DataType,INTEGER Len)
clauses
  bindcol(Win):-
	dialog_bindcol(Win,Column,DataType,Len),
	bindcol1(Column,DataType,Len),!.
  bindcol(_).
  bindcol1(Column,DataType,Len):-
	get_henv(Henv),
	get_hdbc(Hdbc),
	get_hstmt(Hstmt),
	trap(odbcBindCol(Henv,Hdbc,Hstmt,Column,DataType,Len,Ham),_,error_h()),
	assert(ham_column_data(Henv,Hdbc,Hstmt,Column,Ham)),
	error(),!.
  bindcol1(_,_,_):-
	error(),!.

  fetch():-
	get_henv(Henv),
	get_hdbc(Hdbc),
	get_hstmt(Hstmt),
	trap(odbcFetch(Henv,Hdbc,Hstmt),_,error_h()),
	error(),!.
  fetch():-
	error(),!.

predicates
  extendedfetch1(INTEGER Option,LONG FetchRow)
clauses
  extendedfetch(Win):-
	dialog_extendedfetch(Win,Type,FetchRow),
	extendedfetch1(Type,FetchRow),!.
  extendedfetch1(Type,FetchRow):-
	get_henv(Henv),
	get_hdbc(Hdbc),
	get_hstmt(Hstmt),
	trap(odbcExtendedFetch(Henv,Hdbc,Hstmt,Type,FetchRow,RowFetched),_,error_h()),
	writef("  Answer: Row fetched: '%'\n",RowFetched),
	error(),!.
  extendedfetch1(_,_):-
	error(),!.

predicates
  setpos1(UNSIGNED Row,UNSIGNED Option,UNSIGNED Lock)
clauses
  setpos(Win):-
	dialog_setpos(Win,Row,Option,Lock),
	setpos1(Row,Option,Lock),!.
  setpos1(Row,Option,Lock):-
	get_henv(Henv),
	get_hdbc(Hdbc),
	get_hstmt(Hstmt),
	trap(odbcSetPos(Henv,Hdbc,Hstmt,Row,Option,Lock),_,error_h()),
	error(),!.
  setpos1(_,_,_):-
	error(),!.

predicates
  getdata1(INTEGER Column,INTEGER Type,UNSIGNED Size)
clauses
  getdata(Win):-
	dialog_getdata(Win,Column,Type,Size),
	getdata1(Column,Type,Size),!.
  getdata(_).
  getdata1(Column,Type,Size):-
	get_henv(Henv),
	get_hdbc(Hdbc),
	get_hstmt(Hstmt),
	trap(odbcGetData(Henv,Hdbc,Hstmt,Column,Type,Size,Data,_OutSize),_,error_h()),
	get_data1(Data,DataS),
	writef("  Answer: '%s'\n",DataS),
	error(),!.
  getdata1(_,_,_):-
	error(),!.

  get_data1(s(DataS),DataS):-!.
  get_data1(bit(Data),DataS):-
	str_int(DataS,Data),!.
  get_data1(byte(Data),DataS):-
	str_int(DataS,Data),!.
  get_data1(i(Data),DataS):-
	str_int(DataS,Data),!.
  get_data1(l(Data),DataS):-
	trap(term_str(long,Data,DataS),_,fail),!.
  get_data1(f(Data),DataS):-
	str_real(DataS,Data),!.
  get_data1(r(Data),DataS):-
	str_real(DataS,Data),!.
  get_data1(d(DataS),DataS):-!.
  get_data1(t(DataS),DataS):-!.
  get_data1(ts(DataS),DataS):-!.
  get_data1(b(Data),DataS):-
	Size = getbinarysize(Data),
	format(DataS,"Binary data, size = %",Size),!.
  get_data1(n(DataS),DataS):-!.
  get_data1(null,"NULL"):-!.

  moreresults():-
	get_henv(Henv),
	get_hdbc(Hdbc),
	get_hstmt(Hstmt),
	trap(odbcMoreResults(Henv,Hdbc,Hstmt),_,error_h()),
	error(),!.
  moreresults():-
	error(),!.


predicates
  setscrolloptions1(UNSIGNED Concurrency,LONG CrowKeyset,UNSIGNED CrowRowset)
clauses
  setscrolloptions(Win):-
	dialog_setscrolloptions(Win,Concurrency,CrowKeyset,CrowRowset),
	setscrolloptions1(Concurrency,CrowKeyset,CrowRowset),!.
  setscrolloptions1(Concurrency,CrowKeyset,CrowRowset):-
	get_henv(Henv),
	get_hdbc(Hdbc),
	get_hstmt(Hstmt),
	trap(odbcSetScrollOptions(Henv,Hdbc,Hstmt,Concurrency,CrowKeyset,
		CrowRowset),_,error_h()),
	error(),!.
  setscrolloptions1(_,_,_):-
	error(),!.

%___________________________________________________________________________
predicates
  getbindcol1(INTEGER Column)
  getbindcol2(HAM)
clauses
  getbindcol(Win):-
	dialog_getbindcol(Win,Column),
	getbindcol1(Column),!.
  getbindcol(_).
  getbindcol1(Column):-
	get_henv(Henv),
	get_hdbc(Hdbc),
	get_hstmt(Hstmt),
	ham_column_data(Henv,Hdbc,Hstmt,Column,Ham),
	getbindcol2(Ham),!.
  getbindcol1(_):-
	writef("Return: Function='Application', Message='Ham is not allocated'\n"),!.
  getbindcol2(Ham):-
	trap(odbcGetHam(Ham,Data),_,error_h()),
	get_data1(Data,DataS),
	writef("  Answer: '%s'\n",DataS),
	error(),!.
  getbindcol2(_):-
	error(),!.

%___________________________________________________________________________
predicates
  get_column_attr(HENV,HDBC,HSTMT,INTEGER NumCol,SLIST Names,
  	SLIST NamesList,ILIST Types,ILIST TypesList)
  write_title(SLIST NamesList)
  fullgetdata1(HENV,HDBC,HSTMT,ILIST TypesList)
  fullgetdata2(HENV,HDBC,HSTMT,INTEGER BegCol,ILIST TypesList)
clauses
  fullgetdata():-
	get_henv(Henv),
	get_hdbc(Hdbc),
	get_hstmt(Hstmt),
	trap(odbcNumResultCols(Henv,Hdbc,Hstmt,NumCol),_,error_h()),
	get_column_attr(Henv,Hdbc,Hstmt,NumCol,[],NamesList,[],TypesList),
	write("                  "),
	write_title(NamesList),
	nl,
	fullgetdata1(Henv,Hdbc,Hstmt,TypesList),!.
  fullgetdata():-
	error(),!.

  get_column_attr(_,_,_,0,NamesList,NamesList,TypesList,TypesList):-!.
  get_column_attr(Henv,Hdbc,Hstmt,NumCol,Names,NamesList,Types,TypesList):-
	trap(odbcDescribeCol(Henv,Hdbc,Hstmt,NumCol,Name,Type,_,_,_),_,error_h()),
	NC = NumCol - 1,
	get_column_attr(Henv,Hdbc,Hstmt,NC,[Name|Names],NamesList,[Type|Types],TypesList).

  write_title([]):-!.
  write_title([Name|Rest]):-
	writef(" '%s'",Name),
	write_title(Rest).

  fullgetdata1(Henv,Hdbc,Hstmt,TypesList):-
	trap(odbcFetch(Henv,Hdbc,Hstmt),_,error_h()),
	write("  Answer:"),
	fullgetdata2(Henv,Hdbc,Hstmt,1,TypesList),
	nl,!,
	fullgetdata1(Henv,Hdbc,Hstmt,TypesList).
  fullgetdata1(_,_,_,_):-
	error(),!.

  fullgetdata2(_,_,_,_,[]):-!.
  fullgetdata2(Henv,Hdbc,Hstmt,Col,[Type|Rest]):-
	busize_init(Size),
	trap(odbcGetData(Henv,Hdbc,Hstmt,Col,Type,Size,Data,_OutData),_,error_h()),
	get_data1(Data,DataS),
	writef(" '%s'",DataS),
	C = Col + 1,!,
	fullgetdata2(Henv,Hdbc,Hstmt,C,Rest).
  fullgetdata2(_,_,_,_,_):-
	error(),!.

predicates
  fullgetdatacolumn1(HENV,HDBC,HSTMT,INTEGER Column,INTEGER Type,UNSIGNED Size,INTEGER Row)
clauses
  fullgetdatacolumn(Win):-
	dialog_getdata(Win,Column,Type,Size),
	get_henv(Henv),
	get_hdbc(Hdbc),
	get_hstmt(Hstmt),
	trap(odbcDescribeCol(Henv,Hdbc,Hstmt,Column,Name,_,_,_,_),_,error_h()),
	writef("                  '%s'\n",Name),
	fullgetdatacolumn1(Henv,Hdbc,Hstmt,Column,Type,Size,1),!.
  fullgetdatacolumn(_).

  fullgetdatacolumn1(Henv,Hdbc,Hstmt,Column,Type,Size,Row):-
	trap(odbcFetch(Henv,Hdbc,Hstmt),_,error_h()),
	trap(odbcGetData(Henv,Hdbc,Hstmt,Column,Type,Size,Data,_OutSize),_,error_h()),
	get_data1(Data,DataS),
	writef("  Answer: '%s'\n",DataS),!,
	R = Row + 1,
	fullgetdatacolumn1(Henv,Hdbc,Hstmt,Column,Type,Size,R).
  fullgetdatacolumn1(_,_,_,_,_,_,_):-
	error(),!.

/***************************************************************************
	Catalog
***************************************************************************/
predicates
  gettypeinfo1(INTEGER Type)
clauses
  gettypeinfo(Win):-
	dialog_gettypeinfo(Win,Type),
	gettypeinfo1(Type),!.
  gettypeinfo(_).
  gettypeinfo1(Type):-
	get_henv(Henv),
	get_hdbc(Hdbc),
	get_hstmt(Hstmt),
	trap(odbcGetTypeInfo(Henv,Hdbc,Hstmt,Type),_,error_h()),
	error(),!.
  gettypeinfo1(_):-
	error(),!.

predicates
  tables1(STRING Qualifier,STRING Owner,STRING Names,STRING Types)
clauses
  tables(Win):-
	dialog_tables(Win,Qualifier,Owner,Names,Types),
	tables1(Qualifier,Owner,Names,Types),!.
  tables(_).
  tables1(Qualifier,Owner,Names,Types):-
	get_henv(Henv),
	get_hdbc(Hdbc),
	get_hstmt(Hstmt),
	trap(odbcTables(Henv,Hdbc,Hstmt,Qualifier,Owner,Names,Types),_,error_h()),
	error(),!.
  tables1(_,_,_,_):-
	error(),!.

predicates
  columns1(STRING Qualifier,STRING Owner,STRING Names,STRING ColumnNames)
clauses
  columns(Win):-
	dialog_columns(Win,Qualifier,Owner,Names,ColumnNames),
	columns1(Qualifier,Owner,Names,ColumnNames),!.
  columns(_).
  columns1(Qualifier,Owner,Names,ColumnNames):-
	get_henv(Henv),
	get_hdbc(Hdbc),
	get_hstmt(Hstmt),
	trap(odbcColumns(Henv,Hdbc,Hstmt,Qualifier,Owner,Names,ColumnNames),_,error_h()),
	error(),!.
  columns1(_,_,_,_):-
	error(),!.

predicates
  statistics1(STRING Qualifier,STRING Owner,STRING Names,
	UNSIGNED Unique,UNSIGNED Accuracy)
clauses
  statistics(Win):-
	dialog_statistics(Win,Qualifier,Owner,Names,Unique,Accuracy),
	statistics1(Qualifier,Owner,Names,Unique,Accuracy),!.
  statistics(_).
  statistics1(Qualifier,Owner,Names,Unique,Accuracy):-
	get_henv(Henv),
	get_hdbc(Hdbc),
	get_hstmt(Hstmt),
	trap(odbcStatistics(Henv,Hdbc,Hstmt,Qualifier,Owner,Names,Unique,
		Accuracy),_,error_h()),
	error(),!.
  statistics1(_,_,_,_,_):-
	error(),!.

predicates
  primarykeys1(STRING Qualifier,STRING Owner,STRING Names)
clauses
  primarykeys(Win):-
	dialog_primarykeys(Win,Qualifier,Owner,Names),
	primarykeys1(Qualifier,Owner,Names),!.
  primarykeys(_).
  primarykeys1(Qualifier,Owner,Names):-
	get_henv(Henv),
	get_hdbc(Hdbc),
	get_hstmt(Hstmt),
	trap(odbcPrimaryKeys(Henv,Hdbc,Hstmt,Qualifier,Owner,Names),_,error_h()),
	error(),!.
  primarykeys1(_,_,_):-
	error(),!.

predicates
  foreignkeys1(STRING Qualifier,STRING Owner,STRING Names,STRING FkQualifier,
	STRING FkOwner,STRING FkNames)
clauses
  foreignkeys(Win):-
	dialog_foreignkeys(Win,Qualifier,Owner,Names,FkQualifier,FkOwner,FkNames),
	foreignkeys1(Qualifier,Owner,Names,FkQualifier,FkOwner,FkNames),!.
  foreignkeys(_).
  foreignkeys1(Qualifier,Owner,Names,FkQualifier,FkOwner,FkNames):-
	get_henv(Henv),
	get_hdbc(Hdbc),
	get_hstmt(Hstmt),
	trap(odbcForeignKeys(Henv,Hdbc,Hstmt,Qualifier,Owner,Names,FkQualifier,
		FkOwner,FkNames),_,error_h()),
	error(),!.
  foreignkeys1(_,_,_,_,_,_):-
	error(),!.

predicates
  tableprivileges1(STRING Qualifier,STRING Owner,STRING Names)
clauses
  tableprivileges(Win):-
	dialog_tableprivileges(Win,Qualifier,Owner,Names),
	tableprivileges1(Qualifier,Owner,Names),!.
  tableprivileges(_).
  tableprivileges1(Qualifier,Owner,Names):-
	get_henv(Henv),
	get_hdbc(Hdbc),
	get_hstmt(Hstmt),
	trap(odbcTablePrivileges(Henv,Hdbc,Hstmt,Qualifier,Owner,Names),_,error_h()),
	error(),!.
  tableprivileges1(_,_,_):-
	error(),!.

predicates
  columnprivileges1(STRING Qualifier,STRING Owner,STRING Names,STRING ColumnNames)
clauses
  columnprivileges(Win):-
	dialog_columnprivileges(Win,Qualifier,Owner,Names,ColumnNames),
	columnprivileges1(Qualifier,Owner,Names,ColumnNames),!.
  columnprivileges(_).
  columnprivileges1(Qualifier,Owner,Names,ColumnNames):-
	get_henv(Henv),
	get_hdbc(Hdbc),
	get_hstmt(Hstmt),
	trap(odbcColumnPrivileges(Henv,Hdbc,Hstmt,Qualifier,Owner,Names,
		ColumnNames),_,error_h()),
	error(),!.
  columnprivileges1(_,_,_,_):-
	error(),!.

predicates
  specialcolumns1(UNSIGNED ColType,STRING Qualifier,STRING Owner,STRING Names,
	UNSIGNED Scope,UNSIGNED NullAble)
clauses
  specialcolumns(Win):-
	dialog_specialcolumns(Win,ColType,Qualifier,Owner,Names,Scope,NullAble),
	specialcolumns1(ColType,Qualifier,Owner,Names,Scope,NullAble),!.
  specialcolumns(_).
  specialcolumns1(ColType,Qualifier,Owner,Names,Scope,NullAble):-
	get_henv(Henv),
	get_hdbc(Hdbc),
	get_hstmt(Hstmt),
	trap(odbcSpecialColumns(Henv,Hdbc,Hstmt,ColType,Qualifier,Owner,Names,
		Scope,NullAble),_,error_h()),
	error(),!.
  specialcolumns1(_,_,_,_,_,_):-
	error(),!.

predicates
  procedures1(STRING Qualifier,STRING Owner,STRING Names)
clauses
  procedures(Win):-
	dialog_procedures(Win,Qualifier,Owner,Names),
	procedures1(Qualifier,Owner,Names),!.
  procedures(_).
  procedures1(Qualifier,Owner,Names):-
	get_henv(Henv),
	get_hdbc(Hdbc),
	get_hstmt(Hstmt),
	trap(odbcProcedures(Henv,Hdbc,Hstmt,Qualifier,Owner,Names),_,error_h()),
	error(),!.
  procedures1(_,_,_):-
	error(),!.

predicates
  procedurecolumns1(STRING Qualifier,STRING Owner,STRING Names,STRING ColumnNames)
clauses
  procedurecolumns(Win):-
	dialog_procedurecolumns(Win,Qualifier,Owner,Names,ColumnNames),
	procedurecolumns1(Qualifier,Owner,Names,ColumnNames),!.
  procedurecolumns(_).
  procedurecolumns1(Qualifier,Owner,Names,ColumnNames):-
	get_henv(Henv),
	get_hdbc(Hdbc),
	get_hstmt(Hstmt),
	trap(odbcProcedureColumns(Henv,Hdbc,Hstmt,Qualifier,Owner,Names,
		ColumnNames),_,error_h()),
	error(),!.
  procedurecolumns1(_,_,_,_):-
	error(),!.

/***************************************************************************
	Misc
***************************************************************************/
predicates
  transact1(UNSIGNED Type)
clauses
  transact(Win):-
	dialog_transact(Win,Type),
	transact1(Type),!.
  transact(_).
  transact1(Type):-
	get_henv(Henv),
	get_hdbc(Hdbc),
	trap(odbcTransact(Henv,Hdbc,Type),_,error_h()),
	error(),!.
  transact1(_):-
	error(),!.

  cancel():-
	get_henv(Henv),
	get_hdbc(Hdbc),
	get_hstmt(Hstmt),
	trap(odbcCancel(Henv,Hdbc,Hstmt),_,error_h()),
	error(),!.
  cancel():-
	error(),!.

  geterror():-
	odbcGetError(ErrCode,ErrFunc,ErrMess),
	writef("  Answer: Function='%s', Message='%s' (Error code=%)\n",ErrFunc,ErrMess,ErrCode),!.

predicates
  getfunctions1(STRING,INTEGER)
  get_data5(BOOLEAN,STRING)
clauses
  getfunctions(Win):-
	dialog_getfunctions(Win,Str,Id),
	getfunctions1(Str,Id),!.
  getfunctions(_).
  getfunctions1(Str,Id):-
	get_henv(Henv),
	get_hdbc(Hdbc),
	trap(odbcGetFunctions(Henv,Hdbc,Id,Data),_,error_h()),
	get_data5(Data,DataS),
	writef("  Answer: %s = '%s'\n",Str,DataS),
	error(),!.
  getfunctions1(_,_):-
	error(),!.

  get_data5(b_true,"TRUE"):-!.
  get_data5(b_false,"FALSE"):-!.
%___________________________________________________________________________
predicates
  fullgetfunctions1(HENV,HDBC,SLIST,INTEGER)
clauses
  fullgetfunctions():-
	get_henv(Henv),
	get_hdbc(Hdbc),
	func_list(List,_),
	write("  Answer:     Name          Description\n"),
	fullgetfunctions1(Henv,Hdbc,List,1),
	error(),!.
  fullgetfunctions():-
	error(),!.

  fullgetfunctions1(_,_,[],_):-!.
  fullgetfunctions1(Henv,Hdbc,[Str|Rest],Id):-
	trap(odbcGetFunctions(Henv,Hdbc,Id,Data),_,error_h()),
	get_data5(Data,DataS),
	writef("                 %s = '%s'\n",Str,DataS),!,
	I = Id + 1,
	fullgetfunctions1(Henv,Hdbc,Rest,I).

