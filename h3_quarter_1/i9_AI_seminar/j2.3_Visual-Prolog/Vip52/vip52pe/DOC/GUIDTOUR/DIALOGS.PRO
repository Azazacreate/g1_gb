/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  MYPROJ
 FileName: DIALOGS.PRO
 Purpose: A little Demo
 Written by: Leo Jensen
 Comments:
******************************************************************************/

include "myproj.inc"
include "myproj.con"
include "hlptopic.con"

%BEGIN_DLG Person
/**************************************************************************
        Handling of dialog: "Person"
**************************************************************************/

constants
%BEGIN Person, CreateParms, 10:06:32-24.11.1999, Code automatically updated!
  dlg_person_ResID = idd_person
  dlg_person_DlgType = wd_Modal
  dlg_person_Help = idh_contents
%END Person, CreateParms

domains
  PERSON = person(STRING Name,DIALOG_INT Age,BOOLEAN Married,ILIST Skills,DIALOG_CONTROL_ID Sex)

facts - employes
  employe(PERSON)  

clauses  % Initial value
  employe(person("",void,b_false,[],idc_male)).

predicates
  dlg_person_eh : EHANDLER
  dlg_person_update(DIALOG_VAL_LIST,CTLID,PERSON)
  my_person_Create(WINDOW Parent,PERSON In, PERSON Out)

clauses
  dlg_person_Create(Parent):-
	employe(Person),!,
	my_person_Create(Parent,Person,NewPerson),
	retract(employe(Person)),!,
	assert(employe(NewPerson)).

  my_person_Create(Parent,person(Name,Age,Married,Skills,Sex),NewPerson):-
%MARK Person, new variables

	dialog_Create(Parent,[resdlg(dlg_person_ResID,wd_Modal)],
  		[
%BEGIN Person, ControlList, 10:06:32-24.11.1999, Code automatically updated!
		df(idc_name,editstr(NAME,[]),nopr),
		df(idc_age,editint(AGE,[range(0,70)]),str_prompt("Age")),
		df(idc_married,checkbox(MARRIED),nopr),
		df(idc_skills,listbox(["prolog","c","c++","pascal","database","word","excel","basic"],SKILLS),nopr),
		df(SEX,radiobuttongroup([idc_male,idc_female]),nopr)
%END Person, ControlList
		],
		dlg_person_eh,0,_VALLIST,_ANSWER),
	dlg_person_update(_VALLIST,_ANSWER,NewPerson).

  dlg_person_update(_VALLIST,idc_ok,person(_Name,_Age,_Married,_Skills,_Sex)):-!,
%BEGIN Person, Update controls, 10:06:32-24.11.1999, Code automatically updated!
	_NAME = dialog_VLGetstr(idc_name,_VALLIST),
	_AGE = dialog_VLGetint(idc_age,_VALLIST),
	_MARRIED = dialog_VLGetCheck(idc_married,_VALLIST),
	dialog_VLGetListBox(idc_skills,_VALLIST,_IDC_LISTBOX_ITEMLIST,_SKILLS),
	_SEX = dialog_VLGetRadiobutton(idc_male,_VALLIST),
%END Person, Update controls
	!.

%MARK Person, new events

%BEGIN Person, idc_help _CtlInfo
  dlg_person_eh(_,e_Control(idc_help,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	!.
%END Person, idc_help _CtlInfo

%END_DLG Person
