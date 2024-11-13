/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  DBCLIENT
 FileName: DBCLIENT.PRO
 Purpose: No description
 Written by: Visual Prolog
 Comments:
******************************************************************************/

include "dbclient.inc"
include "dbclient.con"
include "hlptopic.con"
database - connect_db
  determ last_connectRequest_db(string, integer)
predicates
  port(integer)
  positionInList(string Elm,slist,integer FirstPos,integer Pos)
  updateMenu()
clauses
  port(8000).
  
  positionInList(Elm,[Elm|_],Pos,Pos):-!.
  positionInList(Elm,[_|List],PosIn,PosOut):-
  	PosInt = PosIn + 1,
  	positionInList(Elm,List,PosInt,PosOut).
  	
  updateMenu():-
  	active_Sockets(_,_,_),!,
	_Win = cast(window,vpi_GetAttrVal(attr_task_Window)),
	menu_enable(_Win,id_Connection_close,b_true),
	menu_enable(_Win,id_Connection_chose,b_true),
	menu_enable(_Win,id_accessdb,b_true),
	menu_Update(_Win).
  	
  updateMenu():-
	_Win = cast(window,vpi_GetAttrVal(attr_task_Window)),
	menu_enable(_Win,id_Connection_close,b_false),
	menu_enable(_Win,id_Connection_chose,b_false),
	menu_enable(_Win,id_accessdb,b_false),
	menu_Update(_Win).

/***************************************************************************************/
/*		Predicates for handling the connections                                */
/***************************************************************************************/
predicates
  connect(integer Port,string Server)
  connect_err(UNSIGNED)
  closeConnection(integer Port,string Server)
  close_err(unsigned)
  resetCurrentSocket(socket)
  updateAccessWin(socket)
  updateAccessWin(socket,slist)
  send_err(unsigned)
/* global predicate  sendRequest(socket,db_messages)                                   */
clauses
%Spb001
  connect_err(_):-
  	retract(last_connectRequest_db(_,_)),
  	fail.
%Spb001  	
  connect_err(msglay_errHost):-
  	write("Wrong host name"),nl,!,
  	fail.
  connect_err(msglay_errCreate):-
  	write("Not able to create Socket"),nl,!,
  	fail.
  connect_err(msglay_errConnect):-
  	write("Not able to connect to server"),nl,!,
  	msglay_lasterror(Err),
  	write("Error: ", Err),nl,
  	fail.

  connect(Port,Server):-
	write("Waiting for connection to server on ",Server),nl,
	assert(last_connectRequest_db(Server,Port)),
  	trap(msglay_Connect(Server, Port, client_handl,[]),Err,connect_err(Err)),
	!.
  connect(_,_).
  
  close_err(msglay_errClose):-
  	write("Not able to close the socket"),
  	fail.
  
  closeConnection(Port,Server):-
  	active_sockets(Server,Port,Socket),!,
  	trap(msglay_Close(Socket),Err,close_err(Err)),
  	!.
  closeConnection(_Port,Server):-
  	format(Str,"There is no connection to server: %s",Server),
  	dlg_note(Str).
  	
  resetCurrentSocket(Socket):-
  	retract(currentSocket(Socket)),
  	active_Sockets(Server,_,NewSocket),!,
  	write("The active connection is now to the server: ",Server),nl,
  	assert(currentSocket(NewSocket)).
  resetCurrentSocket(_).  	
  
  updateAccessWin(Socket):-
  	retract(accessDB(Socket,Win)),!,
	win_destroy(Win).
  updateAccessWin(_).
  
  updateAccessWin(Socket,[]):-   % DBList empty
  	accessDB(Socket,Win),!,
  	DBWin = win_GetCtlHandle(Win,idc_database),
  	KWin = win_GetCtlHandle(Win,idc_key),
  	lbox_Clear(KWin),
  	lbox_Clear(DBWin),
	dialog_SetStr(Win,idc_text,"").
  updateAccessWin(Socket,DBList):-  % The prev. selected is in new DBList
  	accessDB(Socket,Win),
  	DBWin = win_GetCtlHandle(Win,idc_database),
  	lbox_GetSel(DBWin,SelList,_IndexList),
  	SelList = [DBName],
	positionInList(DBName,DBList,0,Index),!,
  	KWin = win_GetCtlHandle(Win,idc_key),
  	lbox_Clear(KWin),
  	lbox_Clear(DBWin),
  	lbox_Add(DBWin,DBList),
	lbox_SetSel(DBWin,Index,b_true),
	sendRequest(Socket,req_Key_List(DBName)).
  updateAccessWin(Socket,DBList):- % The sel. DB. is not in dbList
  	accessDB(Socket,Win),!,
  	DBWin = win_GetCtlHandle(Win,idc_database),
  	KWin = win_GetCtlHandle(Win,idc_key),
	dialog_SetStr(Win,idc_text,""),
  	lbox_Clear(KWin),
  	lbox_Clear(DBWin),
  	lbox_Add(DBWin,DBList),
  	lbox_SetSel(DBWin,0,b_true),
  	DBList = [DBName|_],
	sendRequest(Socket,req_Key_List(DBName)).
  updateAccessWin(_,_). 	% The access window is not open
  
  send_err(msglay_errWrite):-
  	write("Request can not bee send"),nl.
 
  sendRequest(Socket,Req):-
  	term_str(db_messages,Req,ReqStr),
  	str_len(ReqStr,ReqL),
  	ReqL1 = ReqL + 1,
  	ReqBin = composeBinary(ReqStr,ReqL1),
  	trap(msglay_WriteBin(Socket,ReqBin),Err,send_err(Err)).

/***************************************************************************************/
/*			Evaluation of the Responses form the server.                   */
/***************************************************************************************/
predicates
  evalRespons(socket,db_messages)
clauses
/* *********************** Respons for DB list *************************************** */  
  evalRespons(Socket,res_DB_list(DBNameStr)):-!,
  	term_str(slist,DBNameList, DBNameStr),
  	retractall(db_list(Socket,_)),
  	assert(db_list(Socket, DBNameList)),
  	updateAccessWin(Socket,DBNameList).

  evalRespons(Socket,res_key_list(DBName,KeyList)):-!,
  	accessDB(Socket,Win),
  	LBWin = win_GetCtlHandle(Win,idc_key),
  	DBWin = win_GetCtlHandle(Win,idc_database),
  	lbox_GetSel(DBWin,SelList,_),
  	SelList = [DBName1],
   	DBName = DBName1, 
  	lbox_Clear(LBWin),	
 	lbox_Add(LBWin,0,KeyList).
/* *********************** Respons for add requests ********************************** */
  evalRespons(_Socket,res_add_succes(DBName,Key)):-!,
  	Win = win_GetActiveWindow(),
  	write("The new text for key: ", Key, " has bin added in ",DBName),nl,
  	trap(dialog_SetStr(Win,id_text_add,""),_,true), %The trap is used if the access window has bin closed
  	trap(dialog_SetStr(Win,id_key_add,""),_,true).

  evalRespons(_Socket,res_add_failed(DBName,Key)):-!,
  	format(Str,"The key: %s in %s alredy exists.",Key,DBName),
  	dlg_note(Str).

/* *********************** Respons for edit requests ********************************* */  	
  evalRespons(_Socket,res_ed(DBName,Key,String)):-!,
  	Win = win_GetActiveWindow(),
  	DBWin = win_GetCtlHandle(Win,idc_database),
  	lbox_GetSel(DBWin,SelList,_),
  	SelList = [DBName1],
  	DBName1 = DBName,
   	KeyWin = win_GetCtlHandle(Win,idc_key),
  	KeyInx = lbox_GetSelIndex(KeyWin),
  	Key = lbox_GetItem(KeyWin,KeyInx),
  	dialog_SetState(Win,[enable(idc_edit,b_false),enable(idc_save,b_true),
  				enable(idc_new,b_false),
  				enable(idc_database,b_false),enable(idc_key,b_false),
  				enable(idc_text,b_true)]),
  	retract(ed_mode(_)),
  	assert(ed_mode(b_true)),
  	TWin = win_GetCtlHandle(Win,idc_text),
  	win_SetFocus(TWin),
  	dialog_SetStr(Win,idc_text,String).
  	
  evalRespons(_Socket,res_ed_failed(DBName,Key)):-!,
  	format(Str,"The key: %s do not exist in %s.",Key,DBName),
  	dlg_note(Str).

  evalRespons(_Socket,res_ed_locked(DBName,Key)):-!,
  	format(Str,"The key: %s is locked in %s.",Key,DBName),
  	dlg_note(Str).

/* *********************** Respons for save requests ********************************** */
  evalRespons(_Socket,res_save(DBName,Key)):-!,
  	write("The new content for key: ", Key, " in ",DBName, " is saved."),nl.

/* *********************** Respons for find requests ********************************** */
  evalRespons(_Socket,res_find(DBName,Key,String)):-!,
  	Win = win_GetActiveWindow(),
  	DBWin = win_GetCtlHandle(Win,idc_database),
  	lbox_GetSel(DBWin,SelList,_),
  	SelList = [DBName1],
  	DBName1 = DBName,
   	KeyWin = win_GetCtlHandle(Win,idc_key),
  	KeyInx = lbox_GetSelIndex(KeyWin),
  	Key = lbox_GetItem(KeyWin,KeyInx),
   	dialog_SetStr(Win,idc_text,String).

  evalRespons(_Socket,res_find_failed(DBName,Key)):-!,
  	format(Str,"The key: %s do not exist in %s.",Key,DBName),
  	dlg_note(Str).
/* *********************** evalRespons end. ******************************************* */



/****************************************************************************************/
/*			client_hand							*/
/****************************************************************************************/
predicates
  client_handl : msglay_handler
clauses  
  client_handl(_Socket, e_error(Err)):-
  	write("Error event: ", Err),nl,
  	retractall(last_connectRequest_db( _, _ )),
  	!.

/* *********************** e_Read events ********************************************** */
  client_handl(Socket, e_ReadBin(ResBin)):-
  	ResStr = cast(string,ResBin),
  	term_str(db_messages,Res,ResStr),
  	evalRespons(Socket,Res),
  	!.

/* *********************** e_Close events ********************************************* */
  client_handl(Socket, e_Close(msglay_self)):-
  	retract(active_sockets(Server, _, Socket)),!,
  	retractall(db_list(Socket,_)),
  	write("The connection to ",Server," is closed."),nl,
  	resetCurrentSocket(Socket),
  	updateMenu().

  client_handl(Socket, e_Close(msglay_incoming)):-
  	retract(active_sockets(Server, _Port, Socket)),!,
  	retractall(db_list(Socket,_)),
  	updateMenu(),
  	format(Note,"The conection to %s is closed by the server.",Server),
  	dlg_note(Note),
  	resetCurrentSocket(Socket),
  	updateAccessWin(Socket).
  	
/* *********************** e_Connect events ******************************************** */
  client_handl(Socket, e_Connect(Socket)):-
      	retractall(currentSocket(_)),
      	msglay_GetRemoteInf(Socket, Host, Port),
  	write("Connection to server: ",Host," established, on port: ",Port),nl,      	
  	assert(currentSocket(Socket)),
  	retract(last_connectRequest_db(Server, Port)),
  	assert(active_sockets(Server,Port,Socket)),!,
  	updateMenu().

/* *********************** client_handl end ******************************************* */


%BEGIN_WIN Task Window
/***************************************************************************
	Event handling for Task Window
***************************************************************************/

PREDICATES

  task_win_eh : EHANDLER

CONSTANTS

%BEGIN Task Window, CreateParms, 10:42:44-26.11.1999, Code automatically updated!
  task_win_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Close,wsf_Maximize,wsf_Minimize,wsf_ClipSiblings]
  task_win_Menu  = res_menu(idr_clientmenu)
  task_win_Title = "DBCLIENT"
  task_win_Help  = idh_contents
%END Task Window, CreateParms

CLAUSES

%BEGIN Task Window, e_Create
  task_win_eh(_Win,e_Create(_),0):-!,
%BEGIN Task Window, InitControls, 10:42:44-26.11.1999, Code automatically updated!
%END Task Window, InitControls
%BEGIN Task Window, ToolbarCreate, 10:42:44-26.11.1999, Code automatically updated!
%END Task Window, ToolbarCreate
IFDEF use_message
	msg_Create(100),
ENDDEF
	assert(currentDB(0)),
	updateMenu(),
	win_help_Create(_Win),
	!.
%END Task Window, e_Create

%MARK Task Window, new events

%BEGIN Task Window, e_Destroy
  task_win_eh(_Win,e_Destroy,0):-!,
  	msglay_CloseSession(),
	!.
%END Task Window, e_Destroy

%BEGIN Task Window, id_help
  task_win_eh(_Win,e_Menu(id_help,_ShiftCtlAlt),0):-!,
  	not(helpDialog(_)),
	win_help_Create(_Win),
	!.
%END Task Window, id_help

%BEGIN Task Window, id_accessdb
  task_win_eh(_Win,e_Menu(id_accessdb,_ShiftCtlAlt),0):-
  	dlg_accessdb_Create(_Win),
	!.
%END Task Window, id_accessdb

%BEGIN Task Window, id_Connection_exit
  task_win_eh(_Win,e_Menu(id_Connection_exit,_ShiftCtlAlt),0):-!,
  	win_destroy(_Win),
	!.
%END Task Window, id_Connection_exit

%BEGIN Task Window, id_Connection_chose
  task_win_eh(_Win,e_Menu(id_Connection_chose,_ShiftCtlAlt),0):-
  	findall(Server,active_sockets(Server,_Port,_Socket),ServerList),
  	not(ServerList = []),!,
  	currentSocket(CurrentSocket),
  	active_sockets(CurrentServer,_,CurrentSocket),
  	positionInList(CurrentServer,ServerList,0,Index),
  	b_true = dlg_ListSelect("Chose connection",ServerList,Index,SelServer,_),
  	active_sockets(SelServer,_,Socket),
  	retractall(currentSocket(_)),
  	assert(currentSocket(Socket)),  	
  	write("The active connection is now to the server: ",SelServer),nl,
	!.
  task_win_eh(_Win,e_Menu(id_Connection_chose,_ShiftCtlAlt),0):-	
  	dlg_note("There is no open connections").
%END Task Window, id_Connection_chose


%BEGIN Task Window, id_Connection_close
  task_win_eh(_Win,e_Menu(id_Connection_close,_ShiftCtlAlt),0):-
  	findall(Server,active_sockets(Server,_,_),ServerList),
  	not(ServerList = []),!,
  	b_true = dlg_ListSelect("Close Connection",ServerList,0,SelServer,_),
  	port(Port),
  	closeConnection(Port,SelServer).
  	
  task_win_eh(_Win,e_Menu(id_Connection_close,_ShiftCtlAlt),0):-
	dlg_note("Ther is no open connections").
%END Task Window, id_Connection_close

%BEGIN Task Window, id_Connection_connect
  task_win_eh(_Win,e_Menu(id_Connection_connect,_ShiftCtlAlt),0):-!,
  	Server = dlg_GetStr("Connect to server","Insert the name off the machine\nwhere the server is running",""),
  	not(Server = ""),
  	port(Port),
  	connect(Port,Server).
%END Task Window, id_Connection_connect

%BEGIN Task Window, id_help_contents
  task_win_eh(_Win,e_Menu(id_help_contents,_ShiftCtlAlt),0):-!,
  	vpi_ShowHelp("dbclient.hlp"),
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
	helpDialog(HDWin),
	win_Invalidate(HDWin),
	!.
%END Task Window, e_Size

%END_WIN Task Window

/***************************************************************************
	Invoking on-line Help
***************************************************************************/

  project_ShowHelpContext(HelpTopic):-
  	vpi_ShowHelpContext("dbclient.hlp",HelpTopic),!.

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

  vpi_Init(task_win_Flags,task_win_eh,task_win_Menu,"dbclient",task_win_Title).

%BEGIN_TLB Project toolbar, 10:43:28-26.11.1999, Code automatically updated!
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


%BEGIN_TLB Help line, 10:43:56-26.11.1999, Code automatically updated!
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

%BEGIN About dialog, CreateParms, 13:48:12-26.11.1999, Code automatically updated!
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

  dlg_about_dialog_eh(_,_,_):-!,fail.

%END_DLG About dialog











