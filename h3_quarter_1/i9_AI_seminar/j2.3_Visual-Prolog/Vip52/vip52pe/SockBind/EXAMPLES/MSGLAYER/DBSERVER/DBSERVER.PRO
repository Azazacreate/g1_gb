/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  DBSERVER
 FileName: DBSERVER.PRO
 Purpose: No description
 Written by: Visual Prolog
 Comments:
******************************************************************************/

include "dbserver.inc"
include "dbserver.con"
include "hlptopic.con"

database - client
  clients(socket)
  
database - server
  determ listenSocket(socket)

Predicates
  port( USHORT )
  makeNewDatabase(string)
  
Clauses
  port(8000).

  makeNewDatabase(DBName):-
  	dbNames(DBName),!,
	format(String,"The database %s alredy exists.",DBName),
  	dlg_note(String).
  	
  makeNewDatabase(DBName):-
  	assert(dbNames(DBName)).

  	
/*****************************************************************************/
/*		Sending messeges to the clients                              */
/*****************************************************************************/  	
predicates
  sendDBListToAll()
  sendDBList(socket)
  sendKeyListToAll(string)
  sendMessage(socket,db_messages)
clauses
  sendDBListToAll():-
  	clients(Socket),
  	sendDBList(Socket),
  	fail.
  sendDBListToAll().

  sendDBList(Socket):-
  	findAll(DBName,dbNames(DBName),DBList),
  	term_str(sList,DBList,DBListStr),
	term_str(db_messages,res_DB_list(DBListStr),ResStr),
  	str_len(ResStr,Len),
  	Len1 = Len + 1,
  	ResBin = composeBinary(ResStr,Len1),
  	trap(msglay_writeBin(Socket,ResBin),_,fail).

  sendKeyListToAll(DBName):-
  	findall(Key,db(DBName,Key,_),KeyList),
  	clients(Socket),
  	sendMessage(Socket,res_key_list(DBName,KeyList)),
  	fail.
  sendKeyListToAll(_).

  sendMessage(Socket,Mes):-
  	term_str(db_messages,Mes,MesStr),
  	str_len(MesStr,MesL),
  	MesL1 = MesL + 1,
  	MesBin = composeBinary(MesStr,MesL1),
  	trap(msglay_writeBin(Socket,MesBin),_,fail).


/*****************************************************************************/
/*		Serve requests from the client				     */
/*****************************************************************************/
predicates
  serveRequest(socket,db_messages)
clauses
/* *********************** Serve Requests for find ************************* */
%  serveRequest(Socket,Req):-
%  	write("Request received ", Req,"<<<"),nl,fail.
  	
  serveRequest(Socket,req_find(DBName,Key)):-
  	db(DBName,Key,Text),!,
  	sendMessage(Socket,res_find(DBName,Key,Text)).

  serveRequest(Socket,req_find(DBName,Key)):-
	sendMessage(Socket,res_find_failed(DBName,Key)).

/* *********************** Serve Requests for add ************************** */
  serveRequest(Socket,req_add(DBName,Key,_String)):-
	db(DBName,Key,_),!,
  	sendMessage(Socket,res_add_failed(DBName,Key)).
  	
  serveRequest(Socket,req_add(DBName,Key,String)):-
	assert(db(DBName,Key,String)),  
  	sendMessage(Socket,res_add_succes(DBName,Key)),
  	sendKeyListToAll(DBName).
  	
/* *********************** Serve Requests for edit ************************* */
  serveRequest(Socket,req_ed(DBName,Key)):-
	locked(_,DBName,Key),!,
  	sendMessage(Socket,res_ed_locked(DBName,Key)).

  serveRequest(Socket,req_ed(DBName,Key)):-
        db(DBName,Key,String),!,
        assert(locked(Socket,DBName,Key)),
  	sendMessage(Socket,res_ed(DBName,Key,String)).

  serveRequest(Socket,req_ed(DBName,Key)):-
  	sendMessage(Socket,res_ed_failed(DBName,Key)).

/* *********************** Serve Requests for save ************************* */
  serveRequest(Socket,req_save(DBName,Key,String)):-
  	retract(locked(Socket,DBName,Key)),
  	retract(db(DBName,Key,_)),!,
  	assert(db(DBName,Key,String)),
  	sendMessage(Socket,res_save(DBName,Key)).
  	
  serveRequest(Socket,req_key_list(DBName)):-
  	findall(Key,db(DBName,Key,_),KeyList),
  	sendMessage(Socket,res_key_list(DBName,KeyList)).
  
  serveRequest(Socket,req_removeLock(DBName,Key)):-
  	retract(locked(Socket,DBName,Key)),!.
/* *********************** serveRequests End ******************************* */


/*****************************************************************************/
/*		Event handlers 						     */
/*****************************************************************************/
predicates
  port_hand : msglay_handler
  listen_hand : msglay_handler
  listenError(unsigned)
clauses
  port_hand(Socket,e_ReadBin(ReqBin)):-!,
  	ReqStr = cast(string,ReqBin),
  	term_str(db_messages,Req,ReqStr),
  	serveRequest(Socket,Req).
  	
  port_hand(Socket,e_Close(msglay_incoming)):-
  	retract(clients(Socket)),
  	retractall(locked(Socket,_,_)),!,
  	write("One client less"),nl.

  listen_hand(_S,e_Connect(Socket)):-
  	msglay_SetHandler(Socket, port_hand,[]),
  	sendDBList(Socket),
  	assert(clients(Socket)),
  	msglay_GetRemoteInf(Socket,Host,Port),
  	write("New client: host  - ", Host, " port - ", Port),nl.
  	
  listenError(msglay_errCreate):-
  	write("Not able to Create a socket"),nl,!,
  	fail.
  	
  listenError(msglay_errListen):-
  	write("Not able to Listen"),nl,!,
  	fail.
  	


%BEGIN_WIN Task Window
/***************************************************************************
	Event handling for Task Window
***************************************************************************/

PREDICATES

  task_win_eh : EHANDLER

CONSTANTS

%BEGIN Task Window, CreateParms, 11:28:34-26.11.1999, Code automatically updated!
  task_win_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Close,wsf_Maximize,wsf_Minimize,wsf_ClipSiblings]
  task_win_Menu  = res_menu(idr_servermenu)
  task_win_Title = "DBSERVER"
  task_win_Help  = idh_contents
%END Task Window, CreateParms

CLAUSES

%BEGIN Task Window, e_Create
  task_win_eh(_Win,e_Create(_),0):-!,
%BEGIN Task Window, InitControls, 11:28:34-26.11.1999, Code automatically updated!
%END Task Window, InitControls
%BEGIN Task Window, ToolbarCreate, 11:28:34-26.11.1999, Code automatically updated!
%END Task Window, ToolbarCreate
IFDEF use_message
	msg_Create(100),
ENDDEF
	win_help_Create(_Win),
	!.
%END Task Window, e_Create

%MARK Task Window, new events

%BEGIN Task Window, e_Destroy
  task_win_eh(_Win,e_Destroy,0):-
  	retract(listenSocket(LSocket)),!,
  	msglay_close(LSocket),
  	msglay_CloseSession(),
	!.
  task_win_eh(_Win,e_Destroy,0):-!.
%END Task Window, e_Destroy

%BEGIN Task Window, id_help
  task_win_eh(_Win,e_Menu(id_help,_ShiftCtlAlt),0):-!,
  	not(helpWinOpen()),
  	win_help_Create(_Win),
	!.
%END Task Window, id_help

%BEGIN Task Window, id_File_list
  task_win_eh(_Win,e_Menu(id_File_list,_ShiftCtlAlt),0):-!,
  	dlg_list_databases_Create(_Win),
	!.
%END Task Window, id_File_list

%BEGIN Task Window, id_File_close_all
  task_win_eh(_Win,e_Menu(id_File_close_all,_ShiftCtlAlt),0):-
  	dbNames(_),!,
  	retractall(dbNames(_)),
  	retractall(db(_,_,_)),
	retractall(locked(_,_,_)),
	write("All databases is closed."),nl,
	sendDBListToAll(),  
	!.
  task_win_eh(_Win,e_Menu(id_File_close_all,_ShiftCtlAlt),0):-
	dlg_note("There is no open databases").	
%END Task Window, id_File_close_all

%BEGIN Task Window, id_File_close
  task_win_eh(_Win,e_Menu(id_File_close,_ShiftCtlAlt),0):-
  	findall(DBName,dbNames(DBName),DBList),
  	not(DBList = []),!,
  	_Bool = dlg_ListSelect("Remove Database",DBList,-1,CloseDB,_),
  	retract(dbNames(CloseDB)),!,
  	retractall(db(CloseDB,_,_)),
  	retractall(locked(_,CloseDB,_)),
  	write("The database: ",CloseDB," is removed."),nl,
  	sendDBListToAll(),
	!.
  task_win_eh(_Win,e_Menu(id_File_close,_ShiftCtlAlt),0):-
	dlg_note("There is no open databases").
%END Task Window, id_File_close

%BEGIN Task Window, id_File_new
  task_win_eh(_Win,e_Menu(id_File_new,_ShiftCtlAlt),0):-!,
  	NewDBName = dlg_GetStr("New database","Enter the name of the new database:",""),
  	makeNewDatabase(NewDBName),
  	sendDBListToAll(),
	!.
%END Task Window, id_File_new

%BEGIN Task Window, id_File_save
  task_win_eh(_Win,e_Menu(id_File_save,_ShiftCtlAlt),0):-
	dbNames(_),!,
  	FileName = dlg_GetSaveFileName("*.db",["*.db","*.*"],"Save the database in"),
  	not(FileName = ""),
	save(FileName,dbase),
	!.
  task_win_eh(_Win,e_Menu(id_File_save,_ShiftCtlAlt),0):-
	dlg_note("There is no open databases").	
%END Task Window, id_File_save

%BEGIN Task Window, id_File_open
  task_win_eh(_Win,e_Menu(id_File_open,_ShiftCtlAlt),0):-!,
  	FileName = dlg_GetOpenFileName("*.db",["*.db","*.*"],"Consult the database in"),
  	not(FileName = ""),
  	consult(FileName,dbase),
  	write( "Databases were opened\n" ),
  	sendDBListToAll(),
	!.
%END Task Window, id_File_open

%BEGIN Task Window, id_listen
  task_win_eh(_Win,e_Menu(id_listen,_ShiftCtlAlt),0):-!,
  	port(Port),
  	trap(LSocket = msglay_Listen(Port, listen_hand),Error,listenError(Error)),
  	assert(listenSocket(LSocket)),
  	write("Listen on port: ", Port),nl,
  	menu_Enable(_Win,id_listen,b_false),
  	menu_Update(_Win),
	!.
%END Task Window, id_listen

%BEGIN Task Window, id_help_contents
  task_win_eh(_Win,e_Menu(id_help_contents,_ShiftCtlAlt),0):-!,
  	vpi_ShowHelp("dbserver.hlp"),
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

%END_WIN Task Window

/***************************************************************************
	Invoking on-line Help
***************************************************************************/

  project_ShowHelpContext(HelpTopic):-
  	vpi_ShowHelpContext("dbserver.hlp",HelpTopic),!.

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

 vpi_Init(task_win_Flags,task_win_eh,task_win_Menu,"dbserver",task_win_Title).

%BEGIN_TLB Project toolbar, 11:29:02-26.11.1999, Code automatically updated!
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


%BEGIN_TLB Help line, 11:29:08-26.11.1999, Code automatically updated!
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









