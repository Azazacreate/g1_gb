/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  DBCLIENT
 FileName: ACCESS.PRO
 Purpose: No description
 Written by: Visual Prolog
 Comments:
******************************************************************************/

include "dbclient.inc"
include "dbclient.con"
include "hlptopic.con"

%BEGIN_DLG accessDB
/**************************************************************************
	Creation and event handling for dialog: accessDB
**************************************************************************/

CONSTANTS

%BEGIN accessDB, CreateParms, 10:42:12-26.11.1999, Code automatically updated!
  dlg_accessdb_ResID = idd_accessdb
  dlg_accessdb_DlgType = wd_Modal
  dlg_accessdb_Help = idh_contents
%END accessDB, CreateParms
PREDICATES
  getElement(Integer, SList, String)
  
CLAUSES
  getElement(0,[S|_],S):-!.
  getElement(N,[_|List],S):-
  	N1 = N - 1,
  	getElement(N1,List,S).

PREDICATES

  dlg_accessdb_eh : EHANDLER
  dlg_accessdb_update(DIALOG_VAL_LIST)

CLAUSES

  dlg_accessdb_Create(Parent):-
%MARK accessDB, new variables

	dialog_CreateModal(Parent,dlg_accessdb_ResID,"",
  		[
%BEGIN accessDB, ControlList, 10:42:12-26.11.1999, Code automatically updated!
		df(idc_database,listbutton([],0),nopr),
		df(idc_key,listbox([],[0]),nopr),
		df(idc_text,editstr("",[]),nopr)
%END accessDB, ControlList
		],
		dlg_accessdb_eh,0,VALLIST,ANSWER),
	ANSWER = idc_ok,
	dlg_accessdb_update(VALLIST),!.

  dlg_accessdb_update(_VALLIST):-!,
%BEGIN accessDB, Update controls, 10:42:12-26.11.1999, Code automatically updated!
	dialog_VLGetListBox(idc_key,_VALLIST,_IDC_KEY_ITEMLIST,_IDC_KEY_SELECT),
	dialog_VLGetListButton(idc_database,_VALLIST,_IDC_DATABASE_ITEMLIST,_IDC_DATABASE_SELECT),
	_IDC_TEXT_VALUE = dialog_VLGetstr(idc_text,_VALLIST),
%END accessDB, Update controls
	!.

%MARK accessDB, new events

%BEGIN accessDB, e_Create
  dlg_accessdb_eh(_Win,e_Create(_CreationData),0):-!,
  	currentSocket(Socket),
  	assert(accessDB(Socket,_Win)),
	db_list(Socket, DBNameList),
	currentDB(CurrentDB),
	getElement(CurrentDB, DBNameList, DBName),
	LB = win_GetCtlHandle(_Win, idc_database),
	lbox_add(LB,0,DBNameList),
	lbox_SetSel(LB,CurrentDB,b_true),
	sendRequest(Socket, req_key_list(DBName)),
	retractall(ed_mode(_)),
	assert(ed_mode(b_false)),
	!.
%END accessDB, e_Create

%BEGIN accessDB, idc_key selchanged
  dlg_accessdb_eh(_Win,e_Control(idc_key,_CtrlType,_CtrlWin,selchanged),0):-!,
	dialog_SetStr(_Win,idc_text,""),
  	currentSocket(Socket),
  	DBWin = win_GetCtlHandle(_Win,idc_database),
  	lbox_GetSel(DBWin,SelList,_),
  	SelList = [DBName],
  	KeyWin = win_GetCtlHandle(_Win,idc_key),
  	KeyInx = lbox_GetSelIndex(KeyWin),
  	Key = lbox_GetItem(KeyWin,KeyInx),
  	dialog_SetStr(_Win,idc_text,""),
  	sendRequest(Socket,req_find(DBName,Key)),
	!.
%END accessDB, idc_key selchanged

%BEGIN accessDB, idc_cancel _CtlInfo
  dlg_accessdb_eh(_Win,e_Control(idc_cancel,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	retract(accessDB(Socket,_Win)),
  	DBWin = win_GetCtlHandle(_Win,idc_database),
  	lbox_GetSel(DBWin,SelList,InxList),
  	SelList = [DBName],
  	InxList = [CurrentDB],
  	retract(currentDB(_)),
  	assert(currentDB(CurrentDB)),
  	!,
  	ed_mode(b_true),
  	KeyWin = win_GetCtlHandle(_Win,idc_key),
  	KeyInx = lbox_GetSelIndex(KeyWin),
  	Key = lbox_GetItem(KeyWin,KeyInx),
	sendRequest(Socket,req_removeLock(DBName,Key)),
	!,
	fail.
%END accessDB, idc_cancel _CtlInfo

%BEGIN accessDB, idc_new _CtlInfo
  dlg_accessdb_eh(_Win,e_Control(idc_new,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
  	DBWin = win_GetCtlHandle(_Win,idc_database),
  	lbox_GetSel(DBWin,SelList,_),
  	SelList = [DBName],
  	retractall(add_database(_)),
  	assert(add_database(DBName)),
  	dlg_add_Create(_Win),
  	retract(add_database(DBName)),
  	!.
%END accessDB, idc_new _CtlInfo

%BEGIN accessDB, e_CloseRequest
  dlg_accessdb_eh(_Win,e_CloseRequest,0):-!,
	retract(accessDB(Socket,_Win)),
  	DBWin = win_GetCtlHandle(_Win,idc_database),
  	CurrentDB = lbox_GetSelIndex(DBWin),
  	retract(currentDB(_)),
  	assert(currentDB(CurrentDB)),
  	!,
  	ed_mode(b_true),
  	DBWin = win_GetCtlHandle(_Win,idc_database),
  	lbox_GetSel(DBWin,SelList,_),
  	SelList = [DBName],
   	KeyWin = win_GetCtlHandle(_Win,idc_key),
  	KeyInx = lbox_GetSelIndex(KeyWin),
  	Key = lbox_GetItem(KeyWin,KeyInx),
	sendRequest(Socket,req_removeLock(DBName,Key)),
 	!,
 	fail.
%END accessDB, e_CloseRequest

%BEGIN accessDB, idc_ok _CtlInfo
  dlg_accessdb_eh(_Win,e_Control(idc_ok,_CtrlType,_CtrlWin,_CtlInfo),0):-
	retract(accessDB(Socket,_Win)),
	ed_mode(b_true),
  	currentSocket(Socket),
  	DBWin = win_GetCtlHandle(_Win,idc_database),
  	lbox_GetSel(DBWin,SelList,InxList),
  	SelList = [DBName],
  	InxList = [CurrentDB],
  	retract(currentDB(_)),
  	assert(currentDB(CurrentDB)),
  	KeyWin = win_GetCtlHandle(_Win,idc_key),
  	KeyInx = lbox_GetSelIndex(KeyWin),
  	Key = lbox_GetItem(KeyWin,KeyInx),
  	Contens = dialog_GetStr(_Win,idc_text),
   	dialog_SetState(_Win,[enable(idc_edit,b_true),enable(idc_save,b_false)]),
  	retract(ed_mode(_)),
  	assert(ed_mode(b_false)),
  	sendRequest(Socket,req_save(DBName,Key,Contens)),
	!,
	fail.

  dlg_accessdb_eh(_Win,e_Control(idc_ok,_CtrlType,_CtrlWin,_CtlInfo),0):-
  	DBWin = win_GetCtlHandle(_Win,idc_database),
  	CurrentDB = lbox_GetSelIndex(DBWin),
  	retract(currentDB(_)),
  	assert(currentDB(CurrentDB)),
  	!,
  	fail.

%END accessDB, idc_ok _CtlInfo

%BEGIN accessDB, idc_save _CtlInfo
  dlg_accessdb_eh(_Win,e_Control(idc_save,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
  	currentSocket(Socket),
  	DBWin = win_GetCtlHandle(_Win,idc_database),
  	lbox_GetSel(DBWin,SelList,_),
  	SelList = [DBName],
  	KeyWin = win_GetCtlHandle(_Win,idc_key),
  	KeyInx = lbox_GetSelIndex(KeyWin),
  	Key = lbox_GetItem(KeyWin,KeyInx),
  	Contens = dialog_GetStr(_Win,idc_text),
   	dialog_SetState(_Win,[enable(idc_edit,b_true),enable(idc_save,b_false),
   				enable(idc_new,b_true),
   				enable(idc_database,b_true),enable(idc_key,b_true),
   				enable(idc_text,b_false)]),
  	retract(ed_mode(_)),
  	assert(ed_mode(b_false)),
  	sendRequest(Socket,req_save(DBName,Key,Contens)),
	!.
%END accessDB, idc_save _CtlInfo

%BEGIN accessDB, idc_edit _CtlInfo
  dlg_accessdb_eh(_Win,e_Control(idc_edit,_CtrlType,_CtrlWin,_CtlInfo),0):-
  	currentSocket(Socket),
  	DBWin = win_GetCtlHandle(_Win,idc_database),
  	lbox_GetSel(DBWin,SelList,_),
  	SelList = [DBName],
  	KeyWin = win_GetCtlHandle(_Win,idc_key),
  	KeyInx = lbox_GetSelIndex(KeyWin),
  	Key = lbox_GetItem(KeyWin,KeyInx),
  	dialog_SetStr(_Win,idc_text,""),
  	sendRequest(Socket,req_ed(DBName,Key)),	
	!.
	
  dlg_accessdb_eh(_Win,e_Control(idc_edit,_CtrlType,_CtrlWin,_CtlInfo),0):-
	dlg_note("You got to select a key value"),
	!.


%END accessDB, idc_edit _CtlInfo


%BEGIN accessDB, idc_database selchanged
  dlg_accessdb_eh(_Win,e_Control(idc_database,_CtrlType,_CtrlWin,selchanged),0):-!,
	currentSocket(Socket),
  	DBWin = win_GetCtlHandle(_Win,idc_database),
  	lbox_GetSel(DBWin,SelList,_),
  	SelList = [DBName],
  	dialog_SetStr(_Win,idc_text,""),
	sendRequest(Socket,req_key_list(DBName)),
	!.
%END accessDB, idc_database selchanged

  dlg_accessdb_eh(_,_,_):-!,fail.

%END_DLG accessDB























