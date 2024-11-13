/*****************************************************************************

		 Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  CALCCLI
 FileName: CALCCLI.PRO
 Purpose: No description
 Written by: Visual Prolog
 Comments:
******************************************************************************/

include "calccli.inc"
include "calccli.con"


/***************************************************************************

	We use Task Window only to activate our dialog window.

***************************************************************************/

%BEGIN_WIN Task Window
/***************************************************************************
	Event handling for Task Window
***************************************************************************/

PREDICATES

  task_win_eh : EHANDLER

CONSTANTS

%BEGIN Task Window, CreateParms, 18:44:21-10.10.1997, Code automatically updated!
  task_win_Flags = [wsf_DlgBorder,wsf_Invisible]
  task_win_Menu  = no_menu
  task_win_Title = "calccli"
  task_win_Help  = contents
%END Task Window, CreateParms

CLAUSES

%BEGIN Task Window, e_Create
  task_win_eh(_Win,e_Create(_),0):-!,
        dlg_calcclient_Create(_Win),
%BEGIN Task Window, InitControls, 18:44:21-10.10.1997, Code automatically updated!
%END Task Window, InitControls
%BEGIN Task Window, ToolbarCreate, 18:44:21-10.10.1997, Code automatically updated!
%END Task Window, ToolbarCreate
IFDEF use_message
	msg_Create(100),
ENDDEF
	win_Destroy(_Win),
	!.
%END Task Window, e_Create

%MARK Task Window, new events





%END_WIN Task Window

/***************************************************************************
	Invoking on-line Help
***************************************************************************/

  project_ShowHelpContext(HelpTopic):-
  	vpi_ShowHelpContext("calccli.hlp",HelpTopic).

/***************************************************************************
	Main Goal
***************************************************************************/

GOAL

IFDEF use_mdi
  vpi_SetAttrVal(attr_win_mdi,b_true),
ENDDEF
IFDEF ws_win
  IFDEF use_3dctrl
    vpi_SetAttrVal(attr_win_3dcontrols,b_true),
  ENDDEF
ENDDEF  
  create_calculator_objectB(),
  vpi_Init(task_win_Flags,task_win_eh,task_win_Menu,"calccli",task_win_Title),
  release_calculator_objectB().


%BEGIN_DLG CalcClient
/**************************************************************************
	Creation and event handling for dialog: CalcClient
**************************************************************************/

CONSTANTS

%BEGIN CalcClient, CreateParms, 19:40:20-24.11.1999, Code automatically updated!
  dlg_calcclient_ResID = idd_calcclient
  dlg_calcclient_DlgType = wd_Modal
  dlg_calcclient_Help = idh_contents
%END CalcClient, CreateParms

PREDICATES

  dlg_calcclient_eh : EHANDLER
  dlg_calcclient_handle_answer(INTEGER EndButton,DIALOG_VAL_LIST)
  dlg_calcclient_update(DIALOG_VAL_LIST)

  update_object_properties(window)

CLAUSES

  dlg_calcclient_Create(Parent):-
	check_calculator_objectB(),!,
%MARK CalcClient, new variables

	dialog_CreateModal(Parent,dlg_calcclient_ResID,"",
  		[
%BEGIN CalcClient, ControlList, 19:40:20-24.11.1999, Code automatically updated!
		df(idc_accumulator,editstr("",[]),nopr),
		df(idc_operator,editstr("",[]),nopr),
		df(idc_operand,editstr("",[]),nopr),
		df(idc_display,editstr("",[]),nopr)
%END CalcClient, ControlList
		],
		dlg_calcclient_eh,0,VALLIST,ANSWER),
	dlg_calcclient_handle_answer(ANSWER,VALLIST).

  dlg_calcclient_Create(_Parent).

  dlg_calcclient_handle_answer(idc_ok,VALLIST):-!,
	dlg_calcclient_update(VALLIST).

  dlg_calcclient_handle_answer(idc_cancel,_):-!.  % Handle Esc and Cancel here

  dlg_calcclient_handle_answer(_,_):-
	errorexit().

  dlg_calcclient_update(_VALLIST):-
%BEGIN CalcClient, Update controls, 19:40:20-24.11.1999, Code automatically updated!
	_IDC_ACCUMULATOR_VALUE = dialog_VLGetstr(idc_accumulator,_VALLIST),
	_IDC_OPERATOR_VALUE = dialog_VLGetstr(idc_operator,_VALLIST),
	_IDC_OPERAND_VALUE = dialog_VLGetstr(idc_operand,_VALLIST),
	_IDC_DISPLAY_VALUE = dialog_VLGetstr(idc_display,_VALLIST),
%END CalcClient, Update controls
	true.

%MARK CalcClient, new events

%BEGIN CalcClient, e_Create
  dlg_calcclient_eh(_Win,e_Create(_CreationData),0):-!,
  	update_object_properties(_Win),
	!.
%END CalcClient, e_Create

%BEGIN CalcClient, idc_calcclient_18 _CtlInfo
  dlg_calcclient_eh(_Win,e_Control(idc_calcclient_18,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
  	calc_PushB("/"),
  	update_object_properties(_Win),
	!.
%END CalcClient, idc_calcclient_18 _CtlInfo

%BEGIN CalcClient, idc_calcclient_17 _CtlInfo
  dlg_calcclient_eh(_Win,e_Control(idc_calcclient_17,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
  	calc_PushB("*"),
  	update_object_properties(_Win),
	!.
%END CalcClient, idc_calcclient_17 _CtlInfo

%BEGIN CalcClient, idc_calcclient_16 _CtlInfo
  dlg_calcclient_eh(_Win,e_Control(idc_calcclient_16,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
  	calc_PushB("-"),
  	update_object_properties(_Win),
	!.
%END CalcClient, idc_calcclient_16 _CtlInfo

%BEGIN CalcClient, idc_calcclient_15 _CtlInfo
  dlg_calcclient_eh(_Win,e_Control(idc_calcclient_15,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
  	calc_PushB("+"),
  	update_object_properties(_Win),
	!.
%END CalcClient, idc_calcclient_15 _CtlInfo

%BEGIN CalcClient, idc_calcclient_14 _CtlInfo
  dlg_calcclient_eh(_Win,e_Control(idc_calcclient_14,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
  	calc_PushB("="),
  	update_object_properties(_Win),
	!.
%END CalcClient, idc_calcclient_14 _CtlInfo

%BEGIN CalcClient, idc_calcclient_13 _CtlInfo
  dlg_calcclient_eh(_Win,e_Control(idc_calcclient_13,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
  	calc_PushB("C"),
  	update_object_properties(_Win),
	!.
%END CalcClient, idc_calcclient_13 _CtlInfo

%BEGIN CalcClient, idc_calcclient_12 _CtlInfo
  dlg_calcclient_eh(_Win,e_Control(idc_calcclient_12,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
  	calc_PushB("0"),
  	update_object_properties(_Win),
	!.
%END CalcClient, idc_calcclient_12 _CtlInfo

%BEGIN CalcClient, idc_calcclient_11 _CtlInfo
  dlg_calcclient_eh(_Win,e_Control(idc_calcclient_11,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
  	calc_PushB("3"),
  	update_object_properties(_Win),
	!.
%END CalcClient, idc_calcclient_11 _CtlInfo

%BEGIN CalcClient, idc_calcclient_10 _CtlInfo
  dlg_calcclient_eh(_Win,e_Control(idc_calcclient_10,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
  	calc_PushB("2"),
  	update_object_properties(_Win),
	!.
%END CalcClient, idc_calcclient_10 _CtlInfo

%BEGIN CalcClient, idc_calcclient_9 _CtlInfo
  dlg_calcclient_eh(_Win,e_Control(idc_calcclient_9,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
  	calc_PushB("1"),
  	update_object_properties(_Win),
	!.
%END CalcClient, idc_calcclient_9 _CtlInfo

%BEGIN CalcClient, idc_calcclient_8 _CtlInfo
  dlg_calcclient_eh(_Win,e_Control(idc_calcclient_8,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
  	calc_PushB("6"),
  	update_object_properties(_Win),
	!.
%END CalcClient, idc_calcclient_8 _CtlInfo

%BEGIN CalcClient, idc_calcclient_7 _CtlInfo
  dlg_calcclient_eh(_Win,e_Control(idc_calcclient_7,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
  	calc_PushB("5"),
  	update_object_properties(_Win),
	!.
%END CalcClient, idc_calcclient_7 _CtlInfo

%BEGIN CalcClient, idc_calcclient_6 _CtlInfo
  dlg_calcclient_eh(_Win,e_Control(idc_calcclient_6,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
  	calc_PushB("4"),
  	update_object_properties(_Win),
	!.
%END CalcClient, idc_calcclient_6 _CtlInfo

%BEGIN CalcClient, idc_calcclient_5 _CtlInfo
  dlg_calcclient_eh(_Win,e_Control(idc_calcclient_5,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
  	calc_PushB("9"),
  	update_object_properties(_Win),
	!.
%END CalcClient, idc_calcclient_5 _CtlInfo

%BEGIN CalcClient, idc_calcclient_4 _CtlInfo
  dlg_calcclient_eh(_Win,e_Control(idc_calcclient_4,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
  	calc_PushB("8"), 
  	update_object_properties(_Win),
	!.
%END CalcClient, idc_calcclient_4 _CtlInfo

%BEGIN CalcClient, idc_7 _CtlInfo
  dlg_calcclient_eh(_Win,e_Control(idc_7,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
  	calc_PushB("7"),
  	update_object_properties(_Win),
	!.
%END CalcClient, idc_7 _CtlInfo


  dlg_calcclient_eh(_,_,_):-!,fail.

%END_DLG CalcClient

  update_object_properties(Win) :-
  	calc_get_DisplB(Displ),
  	calc_get_AccumulatorB(Accum),
  	calc_get_OperatorB(Operator),
  	calc_get_OpndB(Opnd),
  	DisplWin = win_GetCtlHandle(Win,idc_display),
  	AccumWin = win_GetCtlHandle(Win,idc_accumulator),
  	OptWin   = win_GetCtlHandle(Win,idc_operator),
  	OpndWin  = win_GetCtlHandle(Win,idc_operand),
  	win_SetText(DisplWin,Displ),
  	win_SetText(AccumWin,Accum),
  	win_SetText(OptWin,Operator),
  	win_SetText(OpndWin,Opnd).

