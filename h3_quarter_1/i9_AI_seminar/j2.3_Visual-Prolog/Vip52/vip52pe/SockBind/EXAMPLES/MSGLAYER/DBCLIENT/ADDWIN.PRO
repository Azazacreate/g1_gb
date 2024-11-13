/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  DBCLIENT
 FileName: ADDWIN.PRO
 Purpose: No description
 Written by: Visual Prolog
 Comments:
******************************************************************************/

include "dbclient.inc"
include "dbclient.con"
include "hlptopic.con"

%BEGIN_DLG Add
/**************************************************************************
	Creation and event handling for dialog: Add
**************************************************************************/

CONSTANTS

%BEGIN Add, CreateParms, 10:42:12-26.11.1999, Code automatically updated!
  dlg_add_ResID = idd_add
  dlg_add_DlgType = wd_Modal
  dlg_add_Help = idh_contents
%END Add, CreateParms

PREDICATES

  dlg_add_eh : EHANDLER
  dlg_add_update(DIALOG_VAL_LIST)

CLAUSES

  dlg_add_Create(Parent):-
%MARK Add, new variables

	dialog_CreateModal(Parent,dlg_add_ResID,"",
  		[
%BEGIN Add, ControlList, 10:42:12-26.11.1999, Code automatically updated!
		df(id_key_add,editstr("",[]),nopr),
		df(id_text_add,editstr("",[]),nopr)
%END Add, ControlList
		],
		dlg_add_eh,0,VALLIST,ANSWER),
	ANSWER = idc_ok,
	dlg_add_update(VALLIST),!.

  dlg_add_update(_VALLIST):-!,
%BEGIN Add, Update controls, 10:42:12-26.11.1999, Code automatically updated!
	_ID_KEY_ADD_VALUE = dialog_VLGetstr(id_key_add,_VALLIST),
	_ID_TEXT_ADD_VALUE = dialog_VLGetstr(id_text_add,_VALLIST),
%END Add, Update controls
	!.

%MARK Add, new events



%BEGIN Add, idc_ok _CtlInfo
  dlg_add_eh(_Win,e_Control(idc_ok,_CtrlType,_CtrlWin,_CtlInfo),0):-
  	currentSocket(Socket),
 	Key = dialog_GetStr(_Win,id_key_add),
  	Key <> "",
  	String = dialog_GetStr(_Win,id_text_add),
  	add_database(DBName),
  	sendRequest(Socket,req_add(DBName,Key,String)),
	!,
  	fail.
%END Add, idc_ok _CtlInfo


  dlg_add_eh(_,_,_):-!,fail.

%END_DLG Add















