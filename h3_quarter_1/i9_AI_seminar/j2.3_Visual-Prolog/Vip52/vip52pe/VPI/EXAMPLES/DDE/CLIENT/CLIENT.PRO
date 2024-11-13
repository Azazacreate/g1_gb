/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

			VISUAL Prolog

 Project:  CLIENT
 FileName: CLIENT.PRO
 Purpose: DDE example
 Written by: Alexander Gostintsev
 Comments:
******************************************************************************/

include "client.inc"
include "client.con"
include "hlptopic.con"

DOMAINS % User
 face = head or tail
 cast = coin(face)

DATABASE - coins
  throw(cast) 

DATABASE - dde
  conv(DDE_CONV)
  adv_loop(DDE_CONV)
  trid(DDE_CONV,DDE_TRANSID)

PREDICATES
  dde_clear
  dde_StopLoops(DDE_CONV)
  dde_StopTransactions(DDE_CONV)

CLAUSES
  % disconnect all conversations
  dde_clear:-
  	conv(C),
  	dde_StopLoops(C),
  	dde_StopTransactions(C),
  	dde_DisConnect(C),
  	fail.
  dde_clear:-
  	retractall(_,dde),!.

  % Stop all advise loops for given conversation
  dde_StopLoops(C):-
  	adv_loop(C),
  	dde_StopAdv(C,"Myitem",5000),
  	fail.
  dde_StopLoops(_).

  % Stop all asynchronous transactions
  dde_StopTransactions(C):-
  	trid(C,ID),
  	dde_AbandonTrans(C,ID),
  	fail.
  dde_StopTransactions(_).

%BEGIN_WIN Task Window
/***************************************************************************
		Event handling for task window
***************************************************************************/

PREDICATES
  task_win_eh : EHANDLER

CONSTANTS

%BEGIN Task Window, CreateParms, 18:16:04-23.11.1999, Code automatically updated!
  task_win_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Close,wsf_Maximize,wsf_Minimize,wsf_ClipSiblings]
  task_win_Menu  = res_menu(idr_task_menu)
  task_win_Title = "Client"
  task_win_Help  = idh_contents
%END Task Window, CreateParms

CLAUSES

%BEGIN Task Window, e_Create
  task_win_eh(_Win,e_Create(_),0):-!,
%BEGIN Task Window, InitControls, 18:16:04-23.11.1999, Code automatically updated!
%END Task Window, InitControls
%BEGIN Task Window, ToolbarCreate, 18:16:04-23.11.1999, Code automatically updated!
%END Task Window, ToolbarCreate
%BEGIN Task Window, ToolbarCreate, 17:53:37-15.2.1995, Code automatically updated!
%END Task Window, ToolbarCreate
IFDEF use_message
	msg_Create(100),
ENDDEF
    	dde_Init([]),
    	write("DDE is initialized"),
    	nl,
  	menu_Enable(_Win,id_Disconnect_from_server,b_false),
  	menu_Enable(_Win,"Mess",b_false),
  	menu_Update(_Win),
	!.
%END Task Window, e_Create

%BEGIN Task Window, id_help_contents
IFDEF use_on_line_help
  task_win_eh(_Win,e_Menu(id_help_contents,_ShiftCtlAlt),0):-!,
  	vpi_ShowHelp("client.hlp"),
	!.
ENDDEF
%END Task Window, id_help_contents

%BEGIN Task Window, id_help_about
  task_win_eh(_Win,e_Menu(id_help_about,_ShiftCtlAlt),0):-!,
	dlg_about_dialog_Create(_Win),
	!.
%END Task Window, id_help_about

%BEGIN Task Window, id_file_exit
  task_win_eh(Win,e_Menu(id_file_exit,_ShiftCtlAlt),0):-!,
  	win_Destroy(Win),
	!.
%END Task Window, id_file_exit
%BEGIN Task Window, e_Destroy
  task_win_eh(_Win,e_Destroy,0):-!,
  	dde_Clear,
  	dde_End().
%END Task Window, e_Destroy
%BEGIN Task Window, id_Connect_to_server
  task_win_eh(_Win,e_Menu(id_Connect_to_server,_),0):-!,
  	dde_clear,
  	trap(CONVERSATION=dde_Connect("Myserv","Mytopic"),_,
  		dlg_note("CLIENT.PRO","Unable to connect to Server")),
  	assert(conv(CONVERSATION)),
  	write("Connection is established: ",CONVERSATION),nl,
  	menu_Enable(_Win,id_Connect_to_server,b_false),
        menu_Enable(_Win,id_Disconnect_from_server,b_true),
  	menu_Enable(_Win,"Mess",b_true),
  	menu_Update(_Win),
	!.
%END Task Window, id_Connect_to_server
%BEGIN Task Window, id_Connect_wild_connect
  task_win_eh(_Win,e_Menu(id_Connect_wild_connect,_ShiftCtlAlt),0):-!,
	write("Make a connection to all topics for Myserv\n"),
	trap(_Dde_Conv=dde_Connect("Myserv", ""),_,
		dlg_note("CLIENT.PRO","Unable to connect to Server")),
	write("Returned: ",_Dde_Conv),nl,
	!.
%END Task Window, id_Connect_wild_connect
%BEGIN Task Window, id_Connect_connect_mult
  task_win_eh(_Win,e_Menu(id_Connect_connect_mult,_ShiftCtlAlt),0):-!,
	write("Connect to all servers for (Myserv,Mytopic)\n"),
	trap(DDEConvList=dde_ConnectMult("Myserv", "Mytopic", _ConvMult),_,
		dlg_note("CLIENT.PRO","Unable to connect to Server")),
	write("Returned: ",DDEConvList),nl,
	!.
%END Task Window, id_Connect_connect_mult
%BEGIN Task Window, id_Disconnect_from_server
  task_win_eh(_Win,e_Menu(id_Disconnect_from_server,_),0):-!,
  	dde_Clear,
  	write("Disconnect from server\n"),
  	menu_Enable(_Win,id_Connect_to_server,b_true),
  	menu_Enable(_Win,id_Disconnect_from_server,b_false),
  	menu_Enable(_Win,"Mess",b_false),
  	menu_Update(_Win),
	!.
%END Task Window, id_Disconnect_from_server
%BEGIN Task Window, id_Messages_system_topic

  task_win_eh(_Win,e_Menu(id_Messages_system_topic,_ShiftCtlAlt),0):-!,
	trap(Conv = dde_Connect("Myserv","System"),_,dlg_note("CLIENT.PRO","Unable to connect to Server")),
       	trap(dde_Request(Conv,"Topics",5000,ddecf_Text,DATA),_,
       	                   dlg_note("CLIENT.PRO","Unable to retrieve service/topic list")),
  	DATA=str(D),
  	term_str(dde_service_info_list,DDE_SERVICE_INFO_LIST,D),
  	write("Received from a server(synchronous request):\n ",DDE_SERVICE_INFO_LIST,"\n"),
     	dde_DisConnect(Conv),
     	write("Disconnected from System Topic\n"),
     	!.
%END Task Window, id_Messages_system_topic
%BEGIN Task Window, id_messages_Poke
  task_win_eh(_Win,e_Menu(id_Messages_poke,_),0):-!,
  	conv(C),!,
  	format(SS,"CALL: dde_Poke(%,\"Myitem\",str(\"Hello from a client\"),cf_Text,5000)\n",C),write(SS),
  	dde_Poke(C,"Myitem",str("Hello from a client"),ddecf_Text,5000),
	!.
%END Task Window, id_messages_Poke
%BEGIN Task Window, id_messages_request
  task_win_eh(_Win,e_Menu(id_Messages_request,_),0):-!,
  	conv(C),!,
  	format(SS,"CALL: dde_Request(%,\"Myitem\",5000,cf_Text,DATA)\n",C),write(SS),
  	trap(dde_Request(C,"Myitem",5000,ddecf_Text,DATA),_,dlg_note("CLIENT.PRO","Unable to retrieve 'Myitem'")),
	DATA = str(STR),
	format(SS1,"Received: %\n",STR),
  	write(SS1),
	!.
%END Task Window, id_messages_request
%BEGIN Task Window, id_Messages_request_as
  task_win_eh(_Win,e_Menu(id_Messages_request_as,_),0):-!,
  	conv(C),!,
  	format(SS,"CALL: dde_Request(%,\"Myitem\",0,cf_Text,_)\n",C),write(SS),
  	trap(TransID=dde_Request(C,"Myitem",0,ddecf_Text,_),_,dlg_note("CLIENT.PRO","Unable to request 'Myitem'")),
  	assert(trid(C,TransID)).
%END Task Window, id_Messages_request_as
%BEGIN Task Window, id_Messages_start_an_advise_loop
  task_win_eh(_Win,e_Menu(id_Messages_start_an_advise_loop,_),0):-!,
  	conv(C),!,
  	dde_StartAdv(C,"Myitem",ddecf_Text,[],5000),
  	format(SS,"CALL: dde_StartAdv(%,\"Myitem\",cf_Text,[],5000)\n",C),write(SS),
	!.
%END Task Window, id_Messages_start_an_advise_loop
%BEGIN Task Window, id_Messages_stop_an_advise_loop
  task_win_eh(_Win,e_Menu(id_Messages_stop_an_advise_loop,_),0):-!,
  	conv(C),!,
  	dde_StopAdv(C,"Myitem",5000),
  	format(SS,"CALL: dde_StopAdv(%,\"Myitem\",5000)\n",C),write(SS),
	!.
%END Task Window, id_Messages_stop_an_advise_loop

%********************************************
%  Client DDE messages
%********************************************
  task_win_eh(_Win,e_DDE(Conv,DDE_Event),0):-
	Event = e_DDE(Conv,DDE_Event),
	term_str(event,Event,SS),
	storage(_,_,UsedGStack,_,_,_,_,_,_,_,_),
	format(SSS,"%:%\n",SS,UsedGStack),
	write(SSS),
	fail.

%BEGIN Task Window, advdata
  task_win_eh(_Win,e_DDE(_Conv,advdata(_Topic,_Item,_DDE_DATA)),0):-!,
  	_DDE_DATA=str(Str),
  	write("Received: ",Str),nl,
	!.
%END Task Window, advdata
%BEGIN Task Window, trans_complete
  task_win_eh(_Win,e_DDE(_Conv,trans_complete(_Topic,_Item,_TRANSID,_DDE_DATA)),0):-!,
  	retract(trid(_Conv,_TRANSID)),!,
  	_DDE_DATA=str(Data),
  	write("Received (asynchronous): ",Data),nl,
  	!.
%END Task Window, trans_complete
%BEGIN Task Window, disconnect
  task_win_eh(_Win,e_DDE(_Conv,disconnect()),0):-!,
  	retractall(conv(_Conv)),
  	retractall(adv_loop(_Conv)),
  	write("Conversation is completed\n"),
	!.
%END Task Window, disconnect

%BEGIN Task Window, id_View_clear
  task_win_eh(_Win,e_Menu(id_View_clear,_),0):-!,
	msg_Clear.
%END Task Window, id_View_clear

%BEGIN Task Window, System handled events
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

  task_win_eh(_,_,0):-fail.
%END Task Window, System handled events

/***************************************************************************
			Main Goal Project
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
  vpi_Init(task_win_Flags,task_win_eh,task_win_Menu,"client",task_win_Title).

%END_WIN Task Window

%BEGIN_DLG About dialog
/**************************************************************************
        Creation and event handling for dialog: "About dialog"
	Code style: Single dialog
**************************************************************************/

CONSTANTS

%BEGIN About dialog, CreateParms, 23:22:58-10.1.2000, Code automatically updated!
  dlg_about_dialog_ResID = idd_dlg_about
  dlg_about_dialog_DlgType = wd_Modal
  dlg_about_dialog_Help = idh_contents
%END About dialog, CreateParms

PREDICATES

  dlg_about_dialog_eh : EHANDLER

CLAUSES

  dlg_about_dialog_Create(_Win):-
	win_CreateResDialog(_Win,dlg_about_dialog_DlgType,dlg_about_dialog_ResID,dlg_about_dialog_eh,0),!.

%BEGIN About dialog, idc_ok _CtlInfo
  dlg_about_dialog_eh(_Win,e_Control(idc_ok,_CtrlType,_CtrlWin,_CtrlInfo),0):-!,
	win_Destroy(_Win),
	!.
%END About dialog, idc_ok _CtlInfo
%END_CSTYLE About dialog, Mark point for Single dialog code style

%BEGIN About dialog, System handled events
  dlg_about_dialog_eh(_,_,0) :- !,fail.
%END About dialog, System handled events
%END_DLG About dialog

















