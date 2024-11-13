/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

			VISUAL Prolog

 Project:  SERVER
 FileName: SERVER.PRO
 Purpose: DDE example
 Written by: Alexander Gostintsev
 Comments:
******************************************************************************/
include "server.inc"
include "server.con"
include "hlptopic.con"

/******************************************************

******************************************************/
DATABASE - dde
  tim(unsigned)

PREDICATES
  clear_timers

CLAUSES
  clear_timers:-
  	tim(ID),
  	timer_Kill(ID),
  	fail.
  clear_timers:-
  	retractall(_,dde).


%BEGIN_WIN Task Window
/***************************************************************************
		Event handling for task window
***************************************************************************/

PREDICATES

  task_win_eh : EHANDLER

CONSTANTS

%BEGIN Task Window, CreateParms, 18:05:56-15.2.1995, DO NOT edit this block of code!
	task_win_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Close,wsf_Maximize,wsf_Minimize]
	task_win_Menu  = res_menu(idr_task_menu)
	task_win_Title = "Server"

CLAUSES

%BEGIN Task Window, e_Create
  task_win_eh(_Win,e_Create(_),0):-!,
%BEGIN Task Window, ToolbarCreate, 18:21:36-23.11.1999, Code automatically updated!
%END Task Window, ToolbarCreate
IFDEF use_message
	msg_Create(100),
ENDDEF
    	dde_Init([]),
    	write("DDE is initialized"),nl,
  	dde_RegisterService("Myserv",b_true),
    	write("DDE is initialized & Service: 'Myserv' is registered"),nl,
	!.
%END Task Window, e_Create

%BEGIN Task Window, id_help_contents
IFDEF use_on_line_help
  task_win_eh(_Win,e_Menu(id_help_contents,_ShiftCtlAlt),0):-!,
  	vpi_ShowHelp("server.hlp"),
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
  	clear_timers,
  	dde_RegisterService("Myserv",b_false),
  	dde_End().
%END Task Window, e_Destroy

%BEGIN Task Window, e_Timer
  % Provoke an advisory event
  task_win_eh(_Win,e_Timer(_TimerId),0):-!,
  	write("CALL: dde_PostAdvise(\"Mytopic\",\"Myitem\").\n"),
  	dde_PostAdvise("Mytopic","Myitem").
%END Task Window, e_Timer

%BEGIN Task Window, id_View_clear
  task_win_eh(_Win,e_Menu(id_View_clear,_),0):-!,
	msg_Clear.
%END Task Window, id_View_clear


%***********************************
% DDE messages
%***********************************
  task_win_eh(_Win,e_DDE(Conv,DDE_Event),0):-
	Event = e_DDE(Conv,DDE_Event),
	term_str(event,Event,SS),
	storage(_,_,UsedGStack,_,_,_,_,_,_,_,_),
	format(SSS,"%:%\n",SS,UsedGStack),
	write(SSS),
	fail.

%BEGIN Task Window, connect
% return nonzero value when connection accepted
  task_win_eh(_Win,e_DDE(_Conv,connect("Myserv","Mytopic")),b_True):-!,
	!.
%END Task Window, connect

%BEGIN Task Window, System Topic
  task_win_eh(_Win,e_DDE(_Conv,connect("Myserv","System")),b_True):-!,
	!.
%END Task Window, System Topic

%BEGIN Task Window, request topics list
  % Return DATA to a client
  task_win_eh(_Win,e_DDE(_Conv,request("System","Topics")),DDE_DATA):-!,
	term_str(dde_service_info_list,[service_info("Myserv","Mytopic"),service_info("Myserv","System")],S),
	DDE_DATA=dde_MakeDDEReturnData(str(S)),
	format(SS,"Return: %\n",S),write(SS),
	!.
%END Task Window, request topics list

%BEGIN Task Window, disconnect
  task_win_eh(_Win,e_DDE(_Conv,disconnect()),0):-!,
	!.
%END Task Window, disconnect

%BEGIN Task Window, poke
  task_win_eh(_Win,e_DDE(_Conv,poke("Mytopic","Myitem",_DDE_DATA)),dderes_fack):-!,
	!.
%END Task Window, poke

%BEGIN Task Window, request
  % Return DATA to a client
  task_win_eh(_Win,e_DDE(_Conv,request("Mytopic","Myitem")),DDE_DATA):-!,
  	DDE_DATA=dde_MakeDDEReturnData(str("Hello from a Server")),
  	write("Return: str(\"Hello from a Server\")\n"),
	!.
%END Task Window, request

%BEGIN Task Window, advstart
  % start adv loop
  task_win_eh(_Win,e_DDE(_Conv,advstart("Mytopic","Myitem")),1):-!,
  	clear_timers,
  	TIMERID=timer_Set(_Win,500),
  	assert(tim(TIMERID)),
  	write("Start advise loop\n"),
	!.
%END Task Window, advstart

%BEGIN Task Window, advreq
  % return DATA inside advise loop
  task_win_eh(_Win,e_DDE(_Conv,advreq("Mytopic","Myitem")),DDE_DATA):-!,
        time(HH,MM,SS,_CC),format(Msg,"Hello from Server advise loop (%02:%02:%02)",HH,MM,SS),
  	MyData = str(Msg),
  	DDE_DATA=dde_MakeDDEReturnData(MyData),
  	format(SSS,"Return: %\n",Msg),write(SSS),
  	!.
%END Task Window, advreq

%BEGIN Task Window, advstop
  % stop an advise loop
  task_win_eh(_Win,e_DDE(_Conv,advstop("Mytopic","Myitem")),1):-!,
  	clear_timers,
  	write("Stop advise loop\n"),
	!.
%END Task Window, advstop

%BEGIN Task Window, connect_confirm
  task_win_eh(_Win,e_DDE(_Conv,connect_confirm(_Service,_Topic)),dderes_fack):-!,
	!.
%END Task Window, connect_confirm
%BEGIN Task Window, wildconnect
  task_win_eh(_Win,e_DDE(_Conv,wildconnect(_Service,_Topic)),ServiceInfo):-!,
	ServiceInfo=dde_MakeDDEReturnServiceInfo(
	  [service_info("Myserv","Mytopic"),service_info("Myserv","System")]),
	!.
%END Task Window, wildconnect
%BEGIN Task Window, execute
  task_win_eh(_Win,e_DDE(_Conv,execute(_Topic,_Command)),0):-!,
	!.
%END Task Window, execute
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
  vpi_Init(task_win_Flags,task_win_eh,task_win_Menu,"server",task_win_Title).

%END_WIN Task Window

%BEGIN_DLG About dialog
/**************************************************************************
        Creation and event handling for dialog: "About dialog"
	Code style: Single dialog
**************************************************************************/

CONSTANTS

%BEGIN About dialog, CreateParms, 18:21:32-23.11.1999, Code automatically updated!
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










