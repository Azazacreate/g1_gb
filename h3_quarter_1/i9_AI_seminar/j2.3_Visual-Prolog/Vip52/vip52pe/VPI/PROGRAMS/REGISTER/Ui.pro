/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  REGISTER
 FileName: UI.PRO
 Purpose: Users Interface
 Written by: Eugene Akimov
 Comments:

******************************************************************************/

include "register.inc"
include "register.con"

%BEGIN_DLG City
/**************************************************************************
	Creation and event handling for dialog: City
**************************************************************************/

CONSTANTS

%BEGIN City, CreateParms, 15:25:42-25.10.1998, Code automatically updated!
  dlg_city_ResID = idd_city
  dlg_city_DlgType = wd_Modal
  dlg_city_Help = idh_contents
%END City, CreateParms

PREDICATES

  dlg_city_eh : EHANDLER
  dlg_city_handle_answer(INTEGER EndButton,DIALOG_VAL_LIST)
  dlg_city_update(DIALOG_VAL_LIST)

CLAUSES

  dlg_city_Create(Parent):-

%MARK City, new variables

	dialog_CreateModal(Parent,dlg_city_ResID,"",
  		[
%BEGIN City, ControlList, 15:25:42-25.10.1998, Code automatically updated!
		df(idc_city_1,editstr("",[]),nopr),
		df(idc_city_2,editstr("",[]),nopr)
%END City, ControlList
		],
		dlg_city_eh,0,VALLIST,ANSWER),
	dlg_city_handle_answer(ANSWER,VALLIST).

  dlg_city_handle_answer(idc_ok,VALLIST):-!,
	dlg_city_update(VALLIST).
  dlg_city_handle_answer(idc_cancel,_):-!.  % Handle Esc and Cancel here
  dlg_city_handle_answer(_,_):-
	errorexit().

  dlg_city_update(_VALLIST):-
%BEGIN City, Update controls, 15:25:42-25.10.1998, Code automatically updated!
	_IDC_CITY_1_VALUE = dialog_VLGetstr(idc_city_1,_VALLIST),
	_IDC_CITY_2_VALUE = dialog_VLGetstr(idc_city_2,_VALLIST),
%END City, Update controls
	retractall(_,db1),
	asserta(cityno(_IDC_CITY_1_VALUE),db1),
	asserta(cityname(_IDC_CITY_2_VALUE),db1),
	true.

%MARK City, new events

  dlg_city_eh(_,_,_):-!,fail.

%END_DLG City

%BEGIN_DLG Person
/**************************************************************************
	Creation and event handling for dialog: Person
**************************************************************************/

CONSTANTS

%BEGIN Person, CreateParms, 15:45:38-25.10.1998, Code automatically updated!
  dlg_person_ResID = idd_person
  dlg_person_DlgType = wd_Modal
  dlg_person_Help = idh_contents
%END Person, CreateParms

PREDICATES

  dlg_person_eh : EHANDLER
  dlg_person_handle_answer(INTEGER EndButton,DIALOG_VAL_LIST)
  dlg_person_update(DIALOG_VAL_LIST)

CLAUSES

  dlg_person_Create(Parent):-

%MARK Person, new variables

	dialog_CreateModal(Parent,dlg_person_ResID,"",
  		[
%BEGIN Person, ControlList, 15:45:38-25.10.1998, Code automatically updated!
		df(idc_person_1,editstr("",[]),nopr),
		df(idc_person_2,editstr("",[]),nopr),
		df(idc_person_3,editstr("",[]),nopr),
		df(idc_person_4,editstr("",[]),nopr),
		df(idc_person_5,editstr("",[]),nopr)
%END Person, ControlList
		],
		dlg_person_eh,0,VALLIST,ANSWER),
	dlg_person_handle_answer(ANSWER,VALLIST).

  dlg_person_handle_answer(idc_ok,VALLIST):-!,
	dlg_person_update(VALLIST).
  dlg_person_handle_answer(idc_cancel,_):-!.  % Handle Esc and Cancel here
  dlg_person_handle_answer(_,_):-
	errorexit().

  dlg_person_update(_VALLIST):-
%BEGIN Person, Update controls, 15:45:38-25.10.1998, Code automatically updated!
	_IDC_PERSON_1_VALUE = dialog_VLGetstr(idc_person_1,_VALLIST),
	_IDC_PERSON_2_VALUE = dialog_VLGetstr(idc_person_2,_VALLIST),
	_IDC_PERSON_3_VALUE = dialog_VLGetstr(idc_person_3,_VALLIST),
	_IDC_PERSON_4_VALUE = dialog_VLGetstr(idc_person_4,_VALLIST),
	_IDC_PERSON_5_VALUE = dialog_VLGetstr(idc_person_5,_VALLIST),
%END Person, Update controls
	retractall(_,db1),
	asserta(first_Name(_IDC_PERSON_1_VALUE),db1),
	asserta(last_Name(_IDC_PERSON_2_VALUE),db1),
	asserta(street(_IDC_PERSON_3_VALUE),db1),
	asserta(zip_Code(_IDC_PERSON_4_VALUE),db1),
	asserta(person_Code(_IDC_PERSON_5_VALUE),db1),
	true.

%MARK Person, new events

  dlg_person_eh(_,_,_):-!,fail.

%END_DLG Person


%BEGIN_DLG City Information
/**************************************************************************
	Creation and event handling for dialog: City Information
**************************************************************************/

CONSTANTS

%BEGIN City Information, CreateParms, 19:14:14-25.11.1999, Code automatically updated!
  dlg_city_information_ResID = idd_city_information
  dlg_city_information_DlgType = wd_Modal
  dlg_city_information_Help = idh_contents
%END City Information, CreateParms

PREDICATES

  dlg_city_information_eh : EHANDLER
  dlg_city_information_handle_answer(INTEGER EndButton,DIALOG_VAL_LIST)
  dlg_city_information_update(DIALOG_VAL_LIST)

CLAUSES

  dlg_city_information_Create(Parent):-
	cityno(X1),
	cityname(X2),!,
%MARK City Information, new variables

	dialog_CreateModal(Parent,dlg_city_information_ResID,"",
  		[
%BEGIN City Information, ControlList, 19:14:14-25.11.1999, Code automatically updated!
		df(idc_city_information_1,editstr(X1,[]),nopr),
		df(idc_city_information_2,editstr(X2,[]),nopr)
%END City Information, ControlList
		],
		dlg_city_information_eh,0,VALLIST,ANSWER),
	dlg_city_information_handle_answer(ANSWER,VALLIST).

  dlg_city_information_handle_answer(idc_ok,VALLIST):-!,
	dlg_city_information_update(VALLIST).
  dlg_city_information_handle_answer(idc_cancel,_):-!.  % Handle Esc and Cancel here
  dlg_city_information_handle_answer(_,_):-
	errorexit().

  dlg_city_information_update(_VALLIST):-
%BEGIN City Information, Update controls, 19:14:14-25.11.1999, Code automatically updated!
	_IDC_CITY_INFORMATION_1_VALUE = dialog_VLGetstr(idc_city_information_1,_VALLIST),
	_IDC_CITY_INFORMATION_2_VALUE = dialog_VLGetstr(idc_city_information_2,_VALLIST),
%END City Information, Update controls
	true.

%MARK City Information, new events

%BEGIN City Information, idc_move_up _CtlInfo
  dlg_city_information_eh(_Win,e_Control(idc_move_up,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	retractall(_,db1), arch1(Q), proces_u(Q),
	A1=win_GetCtlHandle(_Win,idc_city_information_1),
	cityno(Y1),
	win_SetText(A1,Y1),
	A2=win_GetCtlHandle(_Win,idc_city_information_2),
	cityname(Y2),
	win_SetText(A2,Y2),
	!.
%END City Information, idc_move_up _CtlInfo
%BEGIN City Information, idc_move_down _CtlInfo
  dlg_city_information_eh(_Win,e_Control(idc_move_down,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	retractall(_,db1), arch1(Q), proces_d(Q),
	A1=win_GetCtlHandle(_Win,idc_city_information_1),
	cityno(Y1),
	win_SetText(A1,Y1),
	A2=win_GetCtlHandle(_Win,idc_city_information_2),
	cityname(Y2),
	win_SetText(A2,Y2),
	!.
%END City Information, idc_move_down _CtlInfo
%BEGIN City Information, idc_new_record _CtlInfo
  dlg_city_information_eh(_Win,e_Control(idc_new_record,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	retractall(_,db1),
	dlg_city_Create(_Win),
	arch1(Q), proces_nr(Q),
	!.
%END City Information, idc_new_record _CtlInfo
%BEGIN City Information, idc_remove_record _CtlInfo
  dlg_city_information_eh(_Win,e_Control(idc_remove_record,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	arch1(Q), proces_rr(Q), browse(city),
	A1=win_GetCtlHandle(_Win,idc_city_information_1),
	cityno(Y1),
	win_SetText(A1,Y1),
	A2=win_GetCtlHandle(_Win,idc_city_information_2),
	cityname(Y2),
	win_SetText(A2,Y2),
	!.
%END City Information, idc_remove_record _CtlInfo
%BEGIN City Information, idc_search _CtlInfo
  dlg_city_information_eh(_Win,e_Control(idc_search,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	dlg_city_Create(_Win),
	proces_cs,
	dlg_search_city_Create(_Win),	
	!.
%END City Information, idc_search _CtlInfo
%BEGIN City Information, idc_replace _CtlInfo
  dlg_city_information_eh(_Win,e_Control(idc_replace,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	A1=win_GetCtlHandle(_Win,idc_city_information_1),
	Y1=win_GetText(A1),asserta(value(cityno,Y1)),
	A2=win_GetCtlHandle(_Win,idc_city_information_2),
	Y2=win_GetText(A2),asserta(value(cityname,Y2)),
	arch1(Q), proces_rp(Q),
	!.
%END City Information, idc_replace _CtlInfo

  dlg_city_information_eh(_,_,_):-!,fail.

%END_DLG City Information

%BEGIN_DLG Search City
/**************************************************************************
        Creation and event handling for dialog: "Search City"
**************************************************************************/

CONSTANTS

%BEGIN Search City, CreateParms, 19:14:02-25.11.1999, Code automatically updated!
  dlg_search_city_ResID = idd_search_city
  dlg_search_city_DlgType = wd_Modal
  dlg_search_city_Help = idh_contents
%END Search City, CreateParms

PREDICATES

  dlg_search_city_eh : EHANDLER
  dlg_search_city_update(DIALOG_VAL_LIST)

CLAUSES

  dlg_search_city_Create(Parent):-
	cityno(Y1),
	cityname(Y2),
%MARK Search City, new variables

	dialog_CreateModal(Parent,dlg_search_city_ResID,"",
  		[
%BEGIN Search City, ControlList, 19:14:02-25.11.1999, Code automatically updated!
		df(idc_search_city_1,editstr(Y1,[]),nopr),
		df(idc_search_city_2,editstr(Y2,[]),nopr)
%END Search City, ControlList
		],
		dlg_search_city_eh,0,VALLIST,ANSWER),
	ANSWER = idc_ok,
	dlg_search_city_update(VALLIST),!.

  dlg_search_city_update(_VALLIST):-!,
%BEGIN Search City, Update controls, 19:14:02-25.11.1999, Code automatically updated!
	_IDC_SEARCH_CITY_1_VALUE = dialog_VLGetstr(idc_search_city_1,_VALLIST),
	_IDC_SEARCH_CITY_2_VALUE = dialog_VLGetstr(idc_search_city_2,_VALLIST),
%END Search City, Update controls
	!.

%MARK Search City, new events

%BEGIN Search City, idc_move_down _CtlInfo
  dlg_search_city_eh(_Win,e_Control(idc_move_down,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	search_proces2_down,
	A1=win_GetCtlHandle(_Win,idc_search_city_1),
	cityno(Y1),
	win_SetText(A1,Y1),
	A2=win_GetCtlHandle(_Win,idc_search_city_2),
	cityname(Y2),
	win_SetText(A2,Y2),
	!.
%END Search City, idc_move_down _CtlInfo

%BEGIN Search City, idc_move_up _CtlInfo
  dlg_search_city_eh(_Win,e_Control(idc_move_up,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	search_proces2_up,
	A1=win_GetCtlHandle(_Win,idc_search_city_1),
	cityno(Y1),
	win_SetText(A1,Y1),
	A2=win_GetCtlHandle(_Win,idc_search_city_2),
	cityname(Y2),
	win_SetText(A2,Y2),
	!.
%END Search City, idc_move_up _CtlInfo

%BEGIN Search City, idc_help _CtlInfo
  dlg_search_city_eh(_,e_Control(idc_help,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
%	project_ShowHelpContext(dlg_search_city_Help),
	!.
%END Search City, idc_help _CtlInfo

  dlg_search_city_eh(_,_,0):-!,fail.
%END_DLG Search City

%BEGIN_DLG Person Information
/**************************************************************************
        Creation and event handling for dialog: "Person Information"
	Code style: Dialog with PDC DlgPackage
**************************************************************************/

CONSTANTS

%BEGIN Person Information, CreateParms, 19:14:20-25.11.1999, Code automatically updated!
  dlg_person_information_ResID = idd_person_info
  dlg_person_information_DlgType = wd_Modal
  dlg_person_information_Help = idh_contents
%END Person Information, CreateParms

PREDICATES

  dlg_person_information_eh : EHANDLER
  dlg_person_information_update(DIALOG_VAL_LIST)

CLAUSES

  dlg_person_information_Create(Parent):-
	first_Name(X1),
	last_Name(X2),
	street(X3),
	zip_Code(X4),
	city_Name(X5),
	person_Code(X6),
%MARK Person Information, new variables

	dialog_Create(Parent,[resdlg(dlg_person_information_ResID,dlg_person_information_DlgType)],
  		[
%BEGIN Person Information, ControlList, 19:14:20-25.11.1999, Code automatically updated!
		df(idc_person_information_1,editstr(X1,[]),nopr),
		df(idc_person_information_2,editstr(X2,[]),nopr),
		df(idc_person_information_3,editstr(X3,[]),nopr),
		df(idc_person_information_4,editstr(X4,[]),nopr),
		df(idc_person_information_5,editstr(X5,[]),nopr),
		df(idc_person_information_6,editstr(X6,[]),nopr)
%END Person Information, ControlList
		],
		dlg_person_information_eh,0,_VALLIST,_ANSWER),!.

  dlg_person_information_update(_VALLIST):-!,
%BEGIN Person Information, Update controls, 19:14:20-25.11.1999, Code automatically updated!
	_IDC_FNAME = dialog_VLGetstr(idc_person_information_1,_VALLIST),
	_IDC_LNAME = dialog_VLGetstr(idc_person_information_2,_VALLIST),
	_IDC_STREET = dialog_VLGetstr(idc_person_information_3,_VALLIST),
	_IDC_CITYNO = dialog_VLGetstr(idc_person_information_4,_VALLIST),
	_IDC_CITYNAME = dialog_VLGetstr(idc_person_information_5,_VALLIST),
	_IDC_CODE = dialog_VLGetstr(idc_person_information_6,_VALLIST),
%END Person Information, Update controls
	!.
%BEGIN Person Information, idc_ok _CtlInfo
  dlg_person_information_eh(_Win,e_Control(idc_ok,_CtrlType,_CtrlWin,_CtrlInfo),0):-!,
	VALLIST = dialog_GetValues(_Win),
	dlg_person_information_update(VALLIST),
	!,fail.
%END Person Information, idc_ok _CtlInfo
%MARK Person Information, new events

%BEGIN Person Information, idc_move_up _CtlInfo
  dlg_person_information_eh(_Win,e_Control(idc_move_up,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	retractall(_,db1), arch1(Q), proces_u(Q),
	A1=win_GetCtlHandle(_Win,idc_person_information_1),
	first_Name(Y1),
	win_SetText(A1,Y1),
	A2=win_GetCtlHandle(_Win,idc_person_information_2),
	last_Name(Y2),
	win_SetText(A2,Y2),
	A3=win_GetCtlHandle(_Win,idc_person_information_3),
	street(Y3),
	win_SetText(A3,Y3),
	A4=win_GetCtlHandle(_Win,idc_person_information_4),
	zip_Code(Y4),
	win_SetText(A4,Y4),
	A5=win_GetCtlHandle(_Win,idc_person_information_5),
	city_Name(Y5),
	win_SetText(A5,Y5),
	A6=win_GetCtlHandle(_Win,idc_person_information_6),
	person_Code(Y6),
	win_SetText(A6,Y6),
	!.
%END Person Information, idc_move_up _CtlInfo
%BEGIN Person Information, idc_move_down _CtlInfo
  dlg_person_information_eh(_Win,e_Control(idc_move_down,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	retractall(_,db1), arch1(Q), proces_d(Q),
	A1=win_GetCtlHandle(_Win,idc_person_information_1),
	first_Name(Y1),
	win_SetText(A1,Y1),
	A2=win_GetCtlHandle(_Win,idc_person_information_2),
	last_Name(Y2),
	win_SetText(A2,Y2),
	A3=win_GetCtlHandle(_Win,idc_person_information_3),
	street(Y3),
	win_SetText(A3,Y3),
	A4=win_GetCtlHandle(_Win,idc_person_information_4),
	zip_Code(Y4),
	win_SetText(A4,Y4),
	A5=win_GetCtlHandle(_Win,idc_person_information_5),
	city_Name(Y5),
	win_SetText(A5,Y5),
	A6=win_GetCtlHandle(_Win,idc_person_information_6),
	person_Code(Y6),
	win_SetText(A6,Y6),
	!.
%END Person Information, idc_move_down _CtlInfo
%BEGIN Person Information, idc_new_record _CtlInfo
  dlg_person_information_eh(_Win,e_Control(idc_new_record,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	retractall(_,db1),
	dlg_person_Create(_Win),
	arch1(Q), proces_nr(Q),
	browse(person),
	A1=win_GetCtlHandle(_Win,idc_person_information_1),
	first_Name(Y1),
	win_SetText(A1,Y1),
	A2=win_GetCtlHandle(_Win,idc_person_information_2),
	last_Name(Y2),
	win_SetText(A2,Y2),
	A3=win_GetCtlHandle(_Win,idc_person_information_3),
	street(Y3),
	win_SetText(A3,Y3),
	A4=win_GetCtlHandle(_Win,idc_person_information_4),
	zip_Code(Y4),
	win_SetText(A4,Y4),
	A5=win_GetCtlHandle(_Win,idc_person_information_5),
	city_Name(Y5),
	win_SetText(A5,Y5),
	A6=win_GetCtlHandle(_Win,idc_person_information_6),
	person_Code(Y6),
	win_SetText(A6,Y6),
	!.
%END Person Information, idc_new_record _CtlInfo
%BEGIN Person Information, idc_remove_record _CtlInfo
  dlg_person_information_eh(_Win,e_Control(idc_remove_record,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	arch1(Q), proces_rr(Q),browse(person),
	A1=win_GetCtlHandle(_Win,idc_person_information_1),
	first_Name(Y1),
	win_SetText(A1,Y1),
	A2=win_GetCtlHandle(_Win,idc_person_information_2),
	last_Name(Y2),
	win_SetText(A2,Y2),
	A3=win_GetCtlHandle(_Win,idc_person_information_3),
	street(Y3),
	win_SetText(A3,Y3),
	A4=win_GetCtlHandle(_Win,idc_person_information_4),
	zip_Code(Y4),
	win_SetText(A4,Y4),
	A5=win_GetCtlHandle(_Win,idc_person_information_5),
	city_Name(Y5),
	win_SetText(A5,Y5),
	A6=win_GetCtlHandle(_Win,idc_person_information_6),
	person_Code(Y6),
	win_SetText(A6,Y6),
	!.
%END Person Information, idc_remove_record _CtlInfo
%BEGIN Person Information, idc_search _CtlInfo
  dlg_person_information_eh(_Win,e_Control(idc_search,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	dlg_person_Create(_Win),
	proces_s,search_flag,
	dlg_search_person_Create(_Win),
	!.
%END Person Information, idc_search _CtlInfo
%BEGIN Person Information, idc_replace _CtlInfo
  dlg_person_information_eh(_Win,e_Control(idc_replace,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	A1=win_GetCtlHandle(_Win,idc_person_information_1),
	Y1=win_GetText(A1),asserta(value(fname,Y1)),
	A2=win_GetCtlHandle(_Win,idc_person_information_2),
	Y2=win_GetText(A2),asserta(value(lname,Y2)),
	A3=win_GetCtlHandle(_Win,idc_person_information_3),
	Y3=win_GetText(A3),asserta(value(street,Y3)),
	A4=win_GetCtlHandle(_Win,idc_person_information_4),
	Y4=win_GetText(A4),asserta(value(cityno,Y4)),
	A5=win_GetCtlHandle(_Win,idc_person_information_6),
	Y5=win_GetText(A5),asserta(value(code,Y5)),
	arch1(Q), proces_rp(Q),
	!.
%END Person Information, idc_replace _CtlInfo
%BEGIN Person Information, System handled events
%BEGIN Person Information, idc_help _CtlInfo
  dlg_person_information_eh(_,e_Control(idc_help,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
%	vpi_ShowHelpContext("register.hlp",dlg_person_information_Help),
	!.
%END Person Information, idc_help _CtlInfo

  dlg_person_information_eh(_,_,0):-!,fail.
%END Person Information, System handled events
%END_DLG Person Information

%BEGIN_DLG Search Person
/**************************************************************************
        Creation and event handling for dialog: "Search Person"
**************************************************************************/

CONSTANTS

%BEGIN Search Person, CreateParms, 19:14:08-25.11.1999, Code automatically updated!
  dlg_search_person_ResID = idd_search_person
  dlg_search_person_DlgType = wd_Modal
  dlg_search_person_Help = idh_contents
%END Search Person, CreateParms

PREDICATES

  dlg_search_person_eh : EHANDLER
  dlg_search_person_update(DIALOG_VAL_LIST)

CLAUSES

  dlg_search_person_Create(Parent):-
	first_Name(Y1),
	last_Name(Y2),
	street(Y3),
	zip_Code(Y4),
	city_Name(Y5),
	person_Code(Y6),
%MARK Search Person, new variables

	dialog_CreateModal(Parent,dlg_search_person_ResID,"",
  		[
%BEGIN Search Person, ControlList, 19:14:08-25.11.1999, Code automatically updated!
		df(idc_search_person_1,editstr(Y1,[]),nopr),
		df(idc_search_person_2,editstr(Y2,[]),nopr),
		df(idc_search_person_3,editstr(Y3,[]),nopr),
		df(idc_search_person_4,editstr(Y4,[]),nopr),
		df(idc_search_person_5,editstr(Y5,[]),nopr),
		df(idc_search_person_6,editstr(Y6,[]),nopr)
%END Search Person, ControlList
		],
		dlg_search_person_eh,0,VALLIST,ANSWER),
	ANSWER = idc_ok,
	dlg_search_person_update(VALLIST),!.

  dlg_search_person_update(_VALLIST):-!,
%BEGIN Search Person, Update controls, 19:14:08-25.11.1999, Code automatically updated!
	_IDC_SEARCH_PERSON_1_VALUE = dialog_VLGetstr(idc_search_person_1,_VALLIST),
	_IDC_SEARCH_PERSON_2_VALUE = dialog_VLGetstr(idc_search_person_2,_VALLIST),
	_IDC_SEARCH_PERSON_3_VALUE = dialog_VLGetstr(idc_search_person_3,_VALLIST),
	_IDC_SEARCH_PERSON_4_VALUE = dialog_VLGetstr(idc_search_person_4,_VALLIST),
	_IDC_SEARCH_PERSON_5_VALUE = dialog_VLGetstr(idc_search_person_5,_VALLIST),
	_IDC_SEARCH_PERSON_6_VALUE = dialog_VLGetstr(idc_search_person_6,_VALLIST),
%END Search Person, Update controls
	!.

%MARK Search Person, new events

%BEGIN Search Person, idc_move_down _CtlInfo
  dlg_search_person_eh(_Win,e_Control(idc_move_down,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	search_proces2_down,
	A1=win_GetCtlHandle(_Win,idc_search_person_1),
	first_Name(Y1),
	win_SetText(A1,Y1),
	A2=win_GetCtlHandle(_Win,idc_search_person_2),
	last_Name(Y2),
	win_SetText(A2,Y2),
	A3=win_GetCtlHandle(_Win,idc_search_person_3),
	street(Y3),
	win_SetText(A3,Y3),
	A4=win_GetCtlHandle(_Win,idc_search_person_4),
	zip_Code(Y4),
	win_SetText(A4,Y4),
	A5=win_GetCtlHandle(_Win,idc_search_person_5),
	city_Name(Y5),
	win_SetText(A5,Y5),
	A6=win_GetCtlHandle(_Win,idc_search_person_6),
	person_Code(Y6),
	win_SetText(A6,Y6),
	!.
%END Search Person, idc_move_down _CtlInfo

%BEGIN Search Person, idc_move_up _CtlInfo
  dlg_search_person_eh(_Win,e_Control(idc_move_up,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	search_proces2_up,
	A1=win_GetCtlHandle(_Win,idc_search_person_1),
	first_Name(Y1),
	win_SetText(A1,Y1),
	A2=win_GetCtlHandle(_Win,idc_search_person_2),
	last_Name(Y2),
	win_SetText(A2,Y2),
	A3=win_GetCtlHandle(_Win,idc_search_person_3),
	street(Y3),
	win_SetText(A3,Y3),
	A4=win_GetCtlHandle(_Win,idc_search_person_4),
	zip_Code(Y4),
	win_SetText(A4,Y4),
	A5=win_GetCtlHandle(_Win,idc_search_person_5),
	city_Name(Y5),
	win_SetText(A5,Y5),
	A6=win_GetCtlHandle(_Win,idc_search_person_6),
	person_Code(Y6),
	win_SetText(A6,Y6),
	!.
%END Search Person, idc_move_up _CtlInfo

%BEGIN Search Person, idc_help _CtlInfo
  dlg_search_person_eh(_,e_Control(idc_help,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
%	project_ShowHelpContext(dlg_search_person_Help),
	!.
%END Search Person, idc_help _CtlInfo

  dlg_search_person_eh(_,_,0):-!,fail.
%END_DLG Search Person













