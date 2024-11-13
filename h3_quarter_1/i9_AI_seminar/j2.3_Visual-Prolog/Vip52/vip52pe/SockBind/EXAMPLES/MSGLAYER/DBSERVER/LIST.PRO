/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  DBSERVER
 FileName: LIST.PRO
 Purpose: No description
 Written by: Visual Prolog
 Comments:
******************************************************************************/

include "dbserver.inc"
include "dbserver.con"
include "hlptopic.con"

%BEGIN_DLG List databases
/**************************************************************************
	Creation and event handling for dialog: List databases
************************************************************************* */
predicates
  listToStr(slist, string)
  
clauses
  listToStr([],"").
  listToStr([S|Ss],StrOut):-
  	listToStr(Ss,StrInt),
  	concat("\n",StrInt,StrInt1),
  	concat(S,StrInt1,StrOut).


CONSTANTS

%BEGIN List databases, CreateParms, 11:28:20-26.11.1999, Code automatically updated!
  dlg_list_databases_ResID = idd_list_databases
  dlg_list_databases_DlgType = wd_Modal
  dlg_list_databases_Help = idh_contents
%END List databases, CreateParms

PREDICATES

  dlg_list_databases_eh : EHANDLER
  dlg_list_databases_update(DIALOG_VAL_LIST)

CLAUSES

  dlg_list_databases_Create(Parent):-
%MARK List databases, new variables

	dialog_CreateModal(Parent,dlg_list_databases_ResID,"",
  		[
%BEGIN List databases, ControlList, 11:28:20-26.11.1999, Code automatically updated!
		df(idc_list_databases,editstr("",[]),nopr)
%END List databases, ControlList
		],
		dlg_list_databases_eh,0,VALLIST,ANSWER),
	ANSWER = idc_ok,
	dlg_list_databases_update(VALLIST),!.

  dlg_list_databases_update(_VALLIST):-!,
%BEGIN List databases, Update controls, 11:28:20-26.11.1999, Code automatically updated!
	_IDC_LIST_DATABASES_VALUE = dialog_VLGetstr(idc_list_databases,_VALLIST),
%END List databases, Update controls
	!.

%MARK List databases, new events

%BEGIN List databases, e_Create
  dlg_list_databases_eh(_Win,e_Create(_CreationData),0):-!,
	findall(DBName,dbNames(DBName),DBList),
	listToStr(DBList,DBStr),
	dialog_SetStr(_Win,idc_list_databases,DBStr),
	!.
%END List databases, e_Create

  dlg_list_databases_eh(_,_,_):-!,fail.

%END_DLG List databases











