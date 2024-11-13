/******************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S 

			 VISUAL Prolog

 FileName:  DIALOG.PRO
 PURPOSE:   Dialog package
 Written by: 
 Comments:
 		LHJ 95.01.24	Single arity version of the predicate
 				dialog_CheckEditProperties, for checking validity 
 				of all edit fields of a dialog.
 		LHJ 95.01.26	NEW: SetCustom,GetCustom,VLGetCustom

    DOJ 95.08.30 Changed ignored_callback to ignore_event
                 Inserted documentation for the use of ignore_event
                 Removed retractall(ignore_event) before assert
                 Inserted test for ignore_event in int_dialog_event to
                 Revised error message for init_field and init_val to
                 include item that is unhandled

                 Comments for further improvements:
                 - make dlg_error in combination with init_val even
                   better, like "listbox(...) incompatible with editstr(...)"
                 - cleanup the indentation. Tabs are not a very good idea to
                   use if it is expected that the text should be read by users
                   with potentially different tab settings !
                 - change ignore_event to ignore_event(window) 
	LJP 95.11.20 A new property for reals. How many decimals shall be printet.
      YI  95.11.23 determ ignore_event => ignore_event(window)
	VY 96.05.25 inclusion of the dialog.con file deleted. Now it must be
                    included together with the dialog.pro by separate line. 
******************************************************************************/
ifndef error_con_included
 #Error: this file requires include: error.con
enddef 
ifndef dialog_pre_included
 #Error: this file requires include: dialog.pre
enddef 

ifndef dialog_con_included
include "dialog\\dialog.con"
enddef

domains 
 WINTYPELIST = WINTYPE*

database - dialog
  % modeless_info(Dlg_win,  Field_l, IsDialog)
  modeless_info(WINDOW, DIALOG_FIELD_LIST, BOOLEAN)

  % modal_info(Dlg_win, Field_l)
  modal_info(WINDOW, DIALOG_FIELD_LIST)

%  dialog_user_back_func(Window, DLGHANDLER)
  dialog_user_back_func(WINDOW, EHANDLER)

  /* validate_field(DIALOG_WINDOW, DLG_FIELD) */
  win_dlg_field(WINDOW, DIALOG_FIELD)

  win_dlg_val(WINDOW, DIALOG_VAL)

  /* Result from modal dialog: dlg_result(DLG_WINDOW, BUTTON) */
  dlg_result(WINDOW, INTEGER)


  first_item_text(WINDOW,INTEGER) % temp. var. used by init_fields and init_field
  disable_ok_button(WINDOW, BOOLEAN)
  ignore_event(WINDOW)
  dlg_user_title(STRING)

%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%	Internal predicates
%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

predicates
procedure  clean_up(WINDOW)
procedure  get_modal_results(WINDOW, DIALOG_VAL_LIST, INTEGER)
int_dialog_event           : EHANDLER
dialog_event_handler       : EHANDLER
determ  dlg_member(WSFLAG,WSFLAGS)
determ  dlg_member(WINTYPE,WINTYPELIST)
determ  dlg_member(WINDEF,WINDEF_LIST)
determ  dlg_member(DIALOG_CONTROL_ID, DIALOG_CONTROL_ID_L)
determ  dlg_member(DIALOG_REAL_PROP, DIALOG_REAL_PROPS)
procedure  run_safe_create(WINDOW,LONG)
determ  is_modal_dlg(WINDEF_LIST)
determ  is_modeless_dlg(WINDEF_LIST)
procedure  modeless_dialog_event(WINDOW,EVENT)
procedure  modal_dialog_event(WINDOW,EVENT)
determ  dialog_callback2(WINDOW, EVENT)
determ  run_create(WINDOW,LONG)
determ  init_fields(WINDOW, DIALOG_FIELD_LIST)
procedure init_field (WINDOW, DIALOG_CONTROL_ID, DIALOG_ITEM)

clauses
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%	INITIALIZATION
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
predicates
procedure	WINDOW dialog_Create1(WINDOW ParentWin, WINDEF_LIST DYNDIALOG, LONG ApplicationData)

clauses
  dialog_CreateModal(ParentWin,ResID,Title, FIELD_L, DLGHANDLER, ApplicationData, VAL_List, 
    BUTTON, Win):-
	asserta(dlg_user_title(Title)),
	Win = dialog_Create(ParentWin,[resdlg( ResID,wd_Modal)],FIELD_L,
			    DLGHANDLER,ApplicationData,VAL_List,BUTTON).
  dialog_CreateModeless(ParentWin,ResID,Title,FIELD_L,DLGHANDLER,ApplicationData,WIN) :-
	asserta(dlg_user_title(Title)),
	Win = dialog_Create(ParentWin,[resdlg( ResID,wd_Modeless)],FIELD_L,
			    DLGHANDLER, ApplicationData, _, _).

  dialog_Create(ParentWin,WINDEF_LIST,FIELD_L,DLGHANDLER,ApplicationData,[],0,WIN) :-
	dlg_member(topwin(_WDEF,_,_),WINDEF_LIST),!,
	Unknown_win = cast(window, 0),
	assert(dialog_user_back_func(Unknown_win, DLGHANDLER)),
	assert(modeless_info(Unknown_win, Field_l, 0)),
	WIN = win_CreateDyn(WINDEF_LIST, ParentWin,dialog_event_handler,ApplicationData),
	run_safe_create(WIN,ApplicationData),
	bound(WIN).
  dialog_Create(ParentWin,DYNDIALOG, FIELD_L, DLGHANDLER,ApplicationData,[],0,WIN):-
	is_modeless_dlg(DYNDIALOG),
	Unknown_win = cast(window, 0),
	assert(dialog_user_back_func(Unknown_win, DLGHANDLER)),
	assert(modeless_info(Unknown_win, Field_l, 1)),
	WIN = dialog_Create1(ParentWin,DYNDIALOG,ApplicationData),
	bound(WIN),!.
  dialog_Create(ParentWin,DYNDIALOG, FIELD_L, DLGHANDLER, ApplicationData, VAL_List, 
    BUTTON, Unknown_win):-
	is_modal_dlg(DYNDIALOG),
	Unknown_win = cast(window, 0),
	assert(dialog_user_back_func(Unknown_win, DLGHANDLER)),
	assert(modal_info(Unknown_win, Field_l)),
	WIN = dialog_Create1(ParentWin,DYNDIALOG,ApplicationData),
	retract(modal_info(Win, _)),!,
	get_modal_results (Win, VAL_List, BUTTON),
	clean_up(Win).
  dialog_Create(_,_, _, _,_,[],0,Unknown_win):-
	dlg_Error(dialog_const_error_create),
	Unknown_win = cast(window, 0),!.
	
  dialog_Create1(ParentWin,[resdlg(Dlg_ResID, Dlg_mode)],ApplicationData, Win) :-!,
        Win = win_CreateResDialog(ParentWin, Dlg_mode, Dlg_ResID, dialog_event_handler,ApplicationData).
  dialog_Create1(ParentWin,DYNDIALOG,ApplicationData, Win) :-
        Win =  win_CreateDynDialog(ParentWin,DYNDIALOG,dialog_event_handler,ApplicationData).
 
  is_modal_dlg([resdlg(_RESID,wd_Modal)]):-!.
  is_modal_dlg(WINDEF_LIST):-
	dlg_member(dlg(WDEF,_WSFLAGS), WINDEF_LIST),
	WDEF = wdef(wd_Modal,_RCT,_Title,_UNIT_TYPE),!.
  is_modal_dlg(WINDEF_LIST):-
	dlg_member(dlg_font(WDEF,_,_,_WSFLAGS), WINDEF_LIST),
	WDEF = wdef(wd_Modal,_RCT,_Title,_UNIT_TYPE),!.
  is_modeless_dlg([resdlg(_RESID,wd_Modeless)]):-!.
  is_modeless_dlg(WINDEF_LIST):-
	dlg_member(dlg(WDEF,_WSFLAGS), WINDEF_LIST),
	WDEF = wdef(wd_Modeless,_RCT,_Title,_UNIT_TYPE),!.
  is_modeless_dlg(WINDEF_LIST):-
	dlg_member(dlg_font(WDEF,_,_,_WSFLAGS), WINDEF_LIST),
	WDEF = wdef(wd_Modeless,_RCT,_Title,_UNIT_TYPE),!.

  run_safe_create(WIN,ApplicationData):-
	run_create(WIN,ApplicationData),!.
  run_safe_create(_,_):-!.

  run_create(WIN,ApplData):-
	Unknown_win = cast(window, 0),
	retract(modeless_info(Unknown_win, Field_l,IsDial)),!,
	assert(modeless_info(Win, Field_l, IsDial)),
	assert(ignore_event(Win)),
	retractall(first_item_text(Win,_)),
	assert(first_item_text(Win,0)),
	init_fields(Win,Field_l),
	retract(ignore_event(Win)),!,
	dialog_user_back_func(WIN, DLGHANDLER),
	DLGHANDLER(WIN, e_Create(ApplData)),!.

  clean_up(Win) :-  
	retractall(modeless_info(Win,_,_)),
	retractall(modal_info(Win,_)),
	retractall(win_dlg_field(WIN,_)),
	retractall(win_dlg_val(WIN,_)),
	retractall(first_item_text(Win,_)),
	retractall(dlg_result(WIN,_)).

%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%	Set values
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
predicates
procedure  set_field_values (WINDOW, DIALOG_FIELD_LIST)
procedure  init_val(WINDOW, DIALOG_VAL)
procedure  set_field_vals(WINDOW, DIALOG_VAL_LIST)
procedure  set_dialog_title(WINDOW)
procedure  set_dialog_title(WINDOW,STRING)
procedure  get_check_types(WINTYPELIST)

clauses
  dialog_SetCheck(WIN,ID,Checked):-!,
	dialog_SetValues(WIN, [dv(ID,checkbox(Checked))]).
  dialog_SetRadiobutton(WIN,First,Pushed):-!,
	dialog_SetValues(WIN, [dv(First,radiobuttongroup(Pushed))]).
  dialog_SetStr(WIN,ID,Title):-
	CW = win_GetCtlHandle(Win,ID),
	wc_Edit <> win_GetType(CW),
	dialog_SetControlTitle(WIN,ID,Title),!.
  dialog_SetStr(WIN,ID,Value):-!,
	dialog_SetValues(WIN, [dv(ID,editstr(Value))]).
  dialog_SetInt(WIN,ID,Value):-!,
	dialog_SetValues(WIN, [dv(ID,editint(Value))]).
  dialog_SetLong(WIN,ID,Value):-!,
	dialog_SetValues(WIN, [dv(ID,editlong(Value))]).
  dialog_SetReal(WIN,ID,Value):-!,
	dialog_SetValues(WIN, [dv(ID,editreal(Value))]).
  dialog_SetListEdit(WIN,ID,Value):-!,
	dialog_SetValues(WIN, [dv(ID,listedit(Value))]).
  dialog_SetScrollBar(WIN,ID,Value):-!,
	dialog_SetValues(WIN, [dv(ID,scrollbar(Value))]).
  dialog_SetListBox(WIN,ID,Value):-!,
	dialog_SetValues(WIN, [dv(ID,listbox([],Value))]).
  dialog_SetListButton(WIN,ID,Value):-!,
	dialog_SetValues(WIN, [dv(ID,listbutton("",Value))]).
  dialog_SetCustom(WIN,ID,Text,Value):-!,
	dialog_SetValues(WIN, [dv(ID,custom(Text,Value))]).
  dialog_SetDataField(WIN,ID,Data):-!,
	dialog_SetValues(WIN, [dv(ID,datafield(Data))]).

  dialog_SetControlTitle(WIN,ID,Title):-
	CW = win_GetCtlHandle(Win, Id),
	WinType=win_GetType(CW),
	get_check_types(WINTYPELIST),
	dlg_member(WinType,WINTYPELIST),!,
	win_SetText(CW,Title),!.
  dialog_SetControlTitle(WIN,ID,Title):-
	CW = win_GetCtlHandle(Win, Id),
	WinType=win_GetType(CW),
	WinType=wc_PushButton,!,
	dialog_SetValues(WIN, [dv(ID,pushbutton(Title))]).
  dialog_SetControlTitle(WIN,ID,Title):-
	CW = win_GetCtlHandle(Win, Id),
	WinType=win_GetType(CW),
%	WinType=wc_Text,!,
	dlg_member(WinType,[wc_Text,wc_GroupBox]),!,
	dialog_SetValues(WIN, [dv(ID,statictext(Title))]).
  dialog_SetControlTitle(_,_,_):-!. %YI

  dialog_SetFields(WIN, DLG_FIELD_LIST) :-
	ignore_event(WIN),!,
	set_field_values(Win, DLG_FIELD_LIST).
  dialog_SetFields(WIN, DLG_FIELD_LIST) :-
	assert(ignore_event(WIN)),
	set_field_values(Win, DLG_FIELD_LIST),
	retractall(ignore_event(WIN)),!.

  dialog_SetValues(WIN, DLG_VAL_LIST) :-
	ignore_event(WIN),!,
	set_field_vals(Win, DLG_VAL_LIST).
  dialog_SetValues(WIN, DLG_VAL_LIST) :-
	assert(ignore_event(WIN)),
	set_field_vals(Win, DLG_VAL_LIST),
	retractall(ignore_event(WIN)),!.

  set_field_vals(_Win, []):-!.
  set_field_vals(Win, [ITEM|DLG_VAL_LIST]):-
	init_val(Win,ITEM),!,
	set_field_vals(Win, DLG_VAL_LIST).
  set_field_vals(_,_):-errorexit(). % Should never be called !

  get_check_types([wc_CheckBox,wc_RadioButton]).

%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%	Set Enable/Disable Visible/Invisible control state
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
predicates

procedure  get_enable_flag(BOOLEAN,WSFLAG)
procedure  get_show_flag(BOOLEAN,WSFLAG)
procedure  change_state_edit(WINDOW,WINDOW)

clauses
  dialog_SetState(_, []) :- !.
  dialog_SetState(WIN, [enable(Control_id, Enable)|T]) :-
	CWIN = win_GetCtlHandle(WIN, Control_id),
	get_enable_flag(Enable,FLAG),
	win_SetState(CWIN,[FLAG]),
	change_state_edit(Win,CWin),!,
	dialog_SetState(WIN, T).
  dialog_SetState(WIN, [show(Control_id, Show)|T]) :-
	CWIN = win_GetCtlHandle(WIN, Control_id),
	get_show_flag(Show,FLAG),
	win_SetState(CWIN,[FLAG]),
	change_state_edit(Win,CWin),!,
	dialog_SetState(WIN, T).
  dialog_SetState(_,_) :-!,
	errorexit( error_vpi_package_bad_identifier ).

%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%	Retrieval
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
predicates
procedure  read_current_values (WINDOW)
procedure  get_dlg_values (WINDOW, DIALOG_VAL_LIST)
procedure  format_item(WINDOW, DIALOG_VAL, DIALOG_VAL)
clauses
  dialog_GetValues(WIN, DLG_VAL_LIST) :-
	read_current_values(WIN),
	get_dlg_values(WIN, DLG_VAL_LIST).

  dialog_GetCheck(WIN,ID,BOOL):-
	win_dlg_val(WIN, dv(ID, checkbox(BOOL))),!.
  dialog_GetCheck(_,_,b_false):-!.
  
  dialog_GetRadiobutton(WIN,ID,Pushed):-
	Value = dialog_GetValue(WIN,ID),
	Value = radiobuttongroup(Pushed),!.
  dialog_GetRadiobutton(_,_,0):-
	errorexit( error_vpi_package_identifier_registered ).
  
  dialog_GetStr(WIN,ID,Str):-
	Value = dialog_GetValue(WIN,ID),
	Value = editstr(Str),!.
  dialog_GetStr(_,_,""):-
	errorexit( error_vpi_package_identifier_registered ).
	
  dialog_GetInt(WIN,ID,Int):-
	Value = dialog_GetValue(WIN,ID),
	Value = editint(Int),!.
  dialog_GetInt(_,_,void):-
	errorexit( error_vpi_package_identifier_registered ).

  dialog_GetLong(WIN,ID,Long):-
	Value = dialog_GetValue(WIN,ID),
	Value = editlong(Long),!.
  dialog_GetLong(_,_,void):-
	errorexit( error_vpi_package_identifier_registered ).

  dialog_GetReal(WIN,ID,Real):-
	Value = dialog_GetValue(WIN,ID),
	Value = editreal(Real),!.
  dialog_GetReal(_,_,void):-
	errorexit( error_vpi_package_identifier_registered ).

  dialog_GetListEdit(WIN,ID,LE):-
	Value = dialog_GetValue(WIN,ID),
	Value = listedit(LE),!.
  dialog_GetListEdit(_,_,""):-
	errorexit( error_vpi_package_identifier_registered ).

  dialog_GetScrollBar(WIN,ID,SB):-
	Value = dialog_GetValue(WIN,ID),
	Value = scrollbar(SB),!.
  dialog_GetScrollBar(_,_,0):-
	errorexit( error_vpi_package_identifier_registered ).

  dialog_GetListBox(WIN,ID,SLIST,ILIST):-
	Value = dialog_GetValue(WIN,ID),
	Value = listbox(SLIST,ILIST),!.
  dialog_GetListBox(_,_,[],[]):-
	errorexit( error_vpi_package_identifier_registered ).

  dialog_GetListButton(WIN,ID,LB,Pos):-
	Value = dialog_GetValue(WIN,ID),
	Value = listbutton(LB,Pos),!.
  dialog_GetListButton(_,_,"",0):-
	errorexit( error_vpi_package_identifier_registered ).

  dialog_GetCustom(WIN,ID,Text,Data):-
	Value = dialog_GetValue(WIN,ID),
	Value = custom(Text,Data),!.
  dialog_GetCustom(_,_,"",0):-
	errorexit( error_vpi_package_identifier_registered ).

  dialog_GetDataField(WIN,ID,Data):-
	Value = dialog_GetValue(WIN,ID),
	Value = datafield(Data),!.
  dialog_GetDataField(_,_,""):-
	errorexit( error_vpi_package_identifier_registered ).

  dialog_GetValue(WIN,ID,Value):-
	win_dlg_val(WIN, dv(ID, VAL1)),!,
	format_item(WIN, dv(ID,VAL1), dv(_ID,Value)).
  dialog_GetValue(WIN,_,checkbox(0)):-
	win_dlg_val(WIN, _),!,
	errorexit( error_vpi_package_bad_identifier ).
  dialog_GetValue(_,_,checkbox(0)):-
	errorexit( error_vpi_package_bad_window ).

  dialog_VLGetCheck(Id, [dv(Id, checkbox(B))|_],B) :- !.
  dialog_VLGetCheck(Id, [_|T],B) :-!,
	B = dialog_VLGetCheck(Id, T).
  dialog_VLGetCheck(_, _,b_false) :-!,
	errorexit( error_vpi_package_identifier_registered ).

  dialog_VLGetRadiobutton(Id, [dv(Id, radiobuttongroup(R))|_],R) :- !.
  dialog_VLGetRadiobutton(Id, [_|T],B) :-!,
	B = dialog_VLGetRadiobutton(Id, T).
  dialog_VLGetRadiobutton(_, _,0) :-
	errorexit( error_vpi_package_identifier_registered ).

  dialog_VLGetStr(Id, [dv(Id, editstr(S))|_],S) :- !.
  dialog_VLGetStr(Id, [_|T],B) :-!,
	B = dialog_VLGetStr(Id, T).
  dialog_VLGetStr(_, _,"") :- !,
	errorexit( error_vpi_package_identifier_registered ).

  dialog_VLGetInt(Id, [dv(Id, editint(I))|_],I) :- !.
  dialog_VLGetInt(Id, [_|T],B) :-!,
	B = dialog_VLGetInt(Id, T).
  dialog_VLGetInt(_, _,void) :-!,
	errorexit( error_vpi_package_identifier_registered ).

  dialog_VLGetLong(Id, [dv(Id, editlong(I))|_],I) :- !.
  dialog_VLGetLong(Id, [_|T],B) :-!,
	B = dialog_VLGetLong(Id, T).
  dialog_VLGetLong(_, _,void) :-!,
	errorexit( error_vpi_package_identifier_registered ).

  dialog_VLGetReal(Id, [dv(Id, editreal(R))|_],R) :- !.
  dialog_VLGetReal(Id, [_|T],B) :-!,
	B = dialog_VLGetReal(Id, T).
  dialog_VLGetReal(_, _,void) :-!,
	errorexit( error_vpi_package_identifier_registered ).

  dialog_VLGetListBox(Id, [dv(Id, listbox(Sel,Ind))|_],Sel,Ind) :- !.
  dialog_VLGetListBox(Id, [_|T], Sel, Ind) :-!,
	dialog_VLGetListBox(Id, T , Sel, Ind).
  dialog_VLGetListBox(_, _, [], []) :-!,
	errorexit( error_vpi_package_identifier_registered ).

  dialog_VLGetListButton(Id, [dv(Id, listbutton(Sel,Ind))|_],Sel,Ind) :- !.
  dialog_VLGetListButton(Id, [_|T], Sel, Ind) :-!,
	dialog_VLGetListButton(Id, T , Sel, Ind).
  dialog_VLGetListButton(_, _, "", 0) :-!,
	errorexit( error_vpi_package_identifier_registered ).

  dialog_VLGetListEdit(Id, [dv(Id, listedit(Txt))|_],Txt) :- !.
  dialog_VLGetListEdit(Id, [_|T], Txt) :-!,
	Txt = dialog_VLGetListEdit(Id, T).
  dialog_VLGetListEdit(_, _, "") :-!,
	errorexit( error_vpi_package_identifier_registered ).

  dialog_VLGetScrollbar(Id, [dv(Id, scrollbar(P))|_],P) :- !.
  dialog_VLGetScrollbar(Id, [_|T],B) :-!,
	B = dialog_VLGetScrollbar(Id, T).
  dialog_VLGetScrollbar(_, _,0) :-!,
	errorexit( error_vpi_package_identifier_registered ).

  dialog_VLGetCustom(Id, [dv(Id, custom(Text,Value))|_],Text,Value) :- !.
  dialog_VLGetCustom(Id, [_|T], Text, Value) :-!,
	dialog_VLGetCustom(Id, T, Text, Value).
  dialog_VLGetCustom(_, _, "", 0) :-!,
	errorexit( error_vpi_package_identifier_registered ).

  dialog_VLGetDataField(Id, [dv(Id, datafield(Data))|_],Data) :- !.
  dialog_VLGetDataField(Id, [_|T], Data) :-!,
	Data = dialog_VLGetDataField(Id, T).
  dialog_VLGetDataField(_, _, "") :-!,
	errorexit( error_vpi_package_identifier_registered ).

  dialog_VLGetAllList(Id, [dv(Id, alllist(Data))|_],Data) :- !.
  dialog_VLGetAllList(Id, [_|T], Data) :-!,
	Data = dialog_VLGetAllList(Id, T).
  dialog_VLGetAllList(_, _, []) :-!,
	errorexit( error_vpi_package_identifier_registered ).

%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%	Dummy predicate
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  dialog_no_handler(_,_,0):- !,fail.

%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%	Dialog/Window event handler
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  dialog_event_handler(W,e_Create(AD),VAL):-
	Unknown_win = cast(window, 0),
	retract(dialog_user_back_func(Unknown_win, DLGHANDLER)),!,
	assert(dialog_user_back_func(W, DLGHANDLER)),
	set_dialog_title(W),
	VAL = int_dialog_event(W,e_Create(AD)).

  dialog_event_handler(W,E,VAL):-%YI
	not(dialog_user_back_func(W, _)),
	Unknown_win = cast(window, 0),
	dialog_user_back_func(Unknown_win, DLGHANDLER),!,
	VAL = DLGHANDLER(W,E).

  dialog_event_handler(W,E,VAL):-
	VAL = int_dialog_event(W,E).

  set_dialog_title(W):-
	retract(dlg_user_title(Title)),!,
	set_dialog_title(W,Title),!.
  set_dialog_title(_):-!.

  set_dialog_title(W,Title):-
	Title <> "",
	win_SetText(W,Title),!.
  set_dialog_title(_W,_Title):-!.

  int_dialog_event(WIN, e_CloseRequest, Ret) :- !,
	dialog_user_back_func(WIN, DLGHANDLER),
	Ret = DLGHANDLER(WIN, e_CloseRequest),!.
  int_dialog_event(WIN, e_Control(idc_ok,T,W,INFO), Ret) :- 
	dialog_user_back_func(WIN, DLGHANDLER),
	Ret = DLGHANDLER(WIN, e_Control(idc_ok,T,W,INFO)),!.
  int_dialog_event(WIN, e_Control(idc_cancel,T,W,INFO), Ret) :- 
	dialog_user_back_func(WIN, DLGHANDLER),
	Ret = DLGHANDLER(WIN, e_Control(idc_cancel,T,W,INFO)),!.

  int_dialog_event(WIN, e_Destroy, 0) :- 
	dialog_user_back_func(WIN, DLGHANDLER),
	DLGHANDLER(WIN, e_Destroy),
	fail.
  int_dialog_event(WIN, e_Destroy, 0) :- !,
	retractall(dialog_user_back_func(Win, _)),
	dialog_callback2(Win, e_Destroy),!.
  
  int_dialog_event(WIN, e_Control(idc_ok,T,W,INFO), 0) :- !,
	dialog_callback2(Win, e_Control(idc_ok,T,W,INFO)),!.
  int_dialog_event(WIN, e_Control(idc_cancel,T,W,INFO), 0) :- !,
	dialog_callback2(Win, e_Control(idc_cancel,T,W,INFO)),!.

  int_dialog_event(WIN, e_Create(AD), 0) :-
	Unknown_win = cast(window, 0),
	retract(modal_info(Unknown_win, Field_l)),!,
	assert(modal_info(Win, Field_l)),
	assert(ignore_event(Win)),
	modal_dialog_event(Win, e_create(AD)),
	retract(ignore_event(Win)),!,
	dialog_user_back_func(WIN, DLGHANDLER),
	DLGHANDLER(WIN, e_Create(AD)),!.
  int_dialog_event(WIN, e_Create(AD), 0) :-
	Unknown_win = cast(window, 0),
	modeless_info(Unknown_win, _, 1), %check if it is modeless dialog, not window
	run_safe_create(WIN,AD),!.

  int_dialog_event(WIN, _, 0) :-
      ignore_event(WIN), !,fail.  /* DOJ */
  int_dialog_event(WIN, EVENT, VAL) :-
	dialog_callback2(Win, EVENT),!,
	dialog_user_back_func(WIN, DLGHANDLER),
	VAL = DLGHANDLER(WIN, EVENT),!.

  dialog_callback2(Win, Event) :-
	modal_info(Win,_),!,
	modal_dialog_event(Win, Event).
  dialog_callback2(Win, Event) :-
	modeless_info(Win,_,_),!,
	modeless_dialog_event(Win, Event).

%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%	read and set control values
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
predicates
procedure  toggle_state(WINDOW,INTEGER, INTEGER)
procedure  click_chk_box(WINDOW, DIALOG_CONTROL_ID, INTEGER)
procedure  click_radio_button(WINDOW, DIALOG_CONTROL_ID, DIALOG_CONTROL_ID_L)
procedure  read_edit_field (WINDOW, DIALOG_CONTROL_ID)
procedure  read_listedit (WINDOW, DIALOG_CONTROL_ID,CONTROL_INFO)
determ  read_list_control (WINDOW, DIALOG_CONTROL_ID, STRING)
procedure  read_current1(WINDOW,DIALOG_FIELD_LIST)
procedure  read_current2 ( WINDOW, DIALOG_CONTROL_ID, DIALOG_ITEM,CONTROL_INFO)
determ  read_and_set_scrollbar (WINDOW,DIALOG_CONTROL_ID,INTEGER,INTEGER,
	SCROLLCODE,INTEGER)
procedure  scroll_bar_inc (WINDOW,DIALOG_CONTROL_ID,INTEGER)
procedure  id_l_to_win_l(WINDOW, DIALOG_CONTROL_ID_L, WINLIST)
determ  save_list_control(STRING, WINDOW, DIALOG_CONTROL_ID, SLIST, ILIST)
procedure  dlg_min(INTEGER, INTEGER, INTEGER)
procedure  dlg_max(INTEGER, INTEGER, INTEGER)
determ  init_list_control (WINDOW, WINDOW, SLIST, ILIST, SLIST,INTEGER)
procedure  SLIST get_lbox_items(WINDOW,ILIST)
procedure  unselect_lbox_items(WINDOW,DIALOG_CONTROL_ID,WINDOW)	% LJ980108
determ  unselect_lbox_item(WINDOW,ILIST)						% LJ980108
procedure unselect_lbox_item1(WINDOW,ILIST)					% LJ980108
procedure  select_if_first(WINDOW,WINDOW,INTEGER)
clauses

  toggle_state(Win, Old, New) :- 
	Wsflags=win_GetState(Win),
	not(dlg_member(wsf_3State,Wsflags)),!,
	New = 1 - Old.
  toggle_state(_, checkbox_undeterm, checkbox_off ) :- !.
  toggle_state(_, Old, New):-
	New = 1 + Old.
	


  click_chk_box (WIN,ID,OLDSTATE):-
	CWIN = win_GetCtlHandle(WIN,ID),
	toggle_state(CWIN,OLDSTATE,NEWSTATE),
	retractall(win_dlg_val(WIN, dv(ID, checkbox(_)))),
	assert(win_dlg_val(WIN, dv(ID, checkbox(NEWSTATE)))),
	win_Check(CWIN,NEWSTATE).

  click_radio_button(WIN, ID, ID_L) :- 
	ID_L = [FIRST_ID|_],
	retractall(win_dlg_val(WIN, dv(FIRST_ID, radiobuttongroup(_)))),
	assert(win_dlg_val(WIN, dv(FIRST_ID, radiobuttongroup(ID)))),
	id_l_to_win_l(WIN, ID_L, WIN_L),
	CWIN = win_GetCtlHandle(WIN,ID),!,
	win_CheckRadioButton (CWIN, WIN_L).
  click_radio_button(_,_,_):-errorexit(). % Should never be called !

  id_l_to_win_l(_, [], []) :-!.
  id_l_to_win_l(WIN, [H1|T1], [H2|T2]) :-
	H2 = win_GetCtlHandle(WIN, H1),!,
	id_l_to_win_l(WIN, T1, T2).
  id_l_to_win_l(_,_,[]):-errorexit(). % Should never be called !

  read_edit_field (WIN, ID) :- 
    % editint, editlong, editreal and editstr are all represented internally as strings
	retractall(win_dlg_val(WIN, dv(ID, editstr(_)))),
	CWIN = win_GetCtlHandle(WIN, ID),
	TXT = win_GetText(CWIN),
	assert(win_dlg_val(WIN, dv(ID, editstr(TXT)))).

  read_list_control (WIN, ID, LIST_CONTROL_TYPE) :-
	CWIN = win_GetCtlHandle(WIN, ID),
	WinType=win_GetType(CWin),
	dlg_member(WinType,[wc_LBox,wc_LBoxEdit,wc_LBoxButton]),
	lbox_GetSel(CWIN,SLIST_SEL,ILIST_SEL),!,
	save_list_control(LIST_CONTROL_TYPE, WIN, ID, SLIST_SEL, ILIST_SEL).
  read_list_control (_, _, _) :-!.

  save_list_control("listbox", WIN, ID, SLIST, ILIST) :-
	retractall(win_dlg_val(WIN, dv(ID, listbox(_,_)))),
	assert(win_dlg_val(WIN, dv(ID, listbox(SLIST, ILIST)))),!.
  save_list_control("listbutton", WIN, ID, [S], [I]) :-
	retractall(win_dlg_val(WIN, dv(ID, listbutton(_,_)))),
	assert(win_dlg_val(WIN, dv(ID, listbutton(S, I)))).


  read_listedit(WIN, ID,selchanged()) :-
	CWIN = win_GetCtlHandle(WIN, ID),
%	WinType=win_GetType(CWin),
%	dlg_member(WinType,[wc_LBox,wc_LBoxEdit,wc_LBoxButton]),!,
	IND = lbox_GetSelIndex(CWin),
	TXT = lbox_GetItem(CWin,Ind),
	retractall(win_dlg_val(WIN, dv(ID, listedit(_)))),
	assert(win_dlg_val(WIN, dv(ID, listedit(TXT)))),!.
  read_listedit(_, _,selchanged()) :-!.
  read_listedit(WIN, ID,_E) :-!,
	retractall(win_dlg_val(WIN, dv(ID, listedit(_)))),
	CWIN = win_GetCtlHandle(WIN, ID),
	TXT = win_GetText(CWIN),
	assert(win_dlg_val(WIN, dv(ID, listedit(TXT)))).

  read_and_set_scrollbar (_,_,_,_,sc_none,_) :- !.

  read_and_set_scrollbar (WIN,ID,LINE,_,sc_lineup,_) :- !,
	INC = -LINE,
	scroll_bar_inc (WIN,ID,INC).

  read_and_set_scrollbar (WIN,ID,LINE,_,sc_linedown,_) :- !,
	scroll_bar_inc (WIN,ID,LINE).

  read_and_set_scrollbar (WIN,ID,_,PAGE,sc_pageup,_) :- !,
	INC = -PAGE,
	scroll_bar_inc (WIN,ID,INC).

  read_and_set_scrollbar (WIN,ID,_,PAGE,sc_pagedown,_) :- !,
	scroll_bar_inc (WIN,ID,PAGE).

  read_and_set_scrollbar (WIN,ID,_,_,sc_thumb,THUMBPOS) :- !,
	retractall(win_dlg_val(WIN, dv(ID, scrollbar(_)))),
	CWIN = win_GetCtlHandle(WIN,ID),
	win_SetScrollPos(CWIN, sb_Ctl, THUMBPOS),
	assert(win_dlg_val(WIN, dv(ID, scrollbar(THUMBPOS)))).

  read_and_set_scrollbar(WIN,ID,_,_,sc_thumbtrack,THUMBPOS) :- 
	retractall(win_dlg_val(WIN, dv(ID, scrollbar(_)))),
	assert(win_dlg_val(WIN, dv(ID, scrollbar(THUMBPOS)))).

  scroll_bar_inc (WIN,ID,INC) :-
	win_dlg_field(WIN, df(ID,scrollbar(_,_,MIN,MAX,_),_)), 
	retract(win_dlg_val(WIN, dv(ID, scrollbar(POS)))),!,
	P = POS + INC,
	dlg_max(P, MIN, P1),
	dlg_min(P1, MAX, NEWPOS),
	CWIN = win_GetCtlHandle(WIN,ID),
	win_SetScrollPos(CWIN,sb_Ctl,NEWPOS),
	assert(win_dlg_val(WIN, dv(ID, scrollbar(NEWPOS)))).
  scroll_bar_inc (_,_,_):-beep.

  read_current_values (WIN) :-
	findall (FIELD,win_dlg_field(WIN, FIELD), FIELD_LIST), 
	read_current1 (WIN,FIELD_LIST),!.
  read_current_values (_).


  read_current1 (_, []):-!.
  read_current1 (WIN, [ FIELD | T ]) :-
	FIELD = df(ID,ITEM, _),
	read_current2 (WIN,ID,ITEM,activated()),!,
	read_current1 (WIN,T).
  read_current1 (_,_):-errorexit(). % Should never be called !
    
  read_current2 ( WIN, ID, listbutton(_,_),_) :-  
	read_list_control (WIN, ID, "listbutton"),!.
  read_current2 ( WIN, ID, listedit(_,_),INFO) :-  
	read_listedit (WIN, ID,INFO),!.
  read_current2 ( WIN, ID, listbox(_,_),_) :-  
	read_list_control (WIN, ID, "listbox"),!.
  read_current2 ( WIN, ID, editstr(_,_),_) :-  
	read_edit_field (WIN, ID),!.
  read_current2 ( WIN, ID, editint(_,_),_) :- 
	read_edit_field (WIN, ID),!.
  read_current2 ( WIN, ID, editlong(_,_),_) :- 
	read_edit_field (WIN, ID),!.
  read_current2 ( WIN, ID, editreal(_,_),_) :-
	read_edit_field (WIN, ID),!.
  read_current2 ( _, _, _,_).

  init_list_control(DWIN, CWIN, STRINGLIST, SELECTLIST, SELITEMS,FOCUS) :-
	WinType=win_GetType(CWin),
	dlg_member(WinType,[wc_LBox,wc_LBoxEdit,wc_LBoxButton]),!,
	lbox_Clear(CWIN),
	lbox_Suspend(CWIN),
	lbox_Add(CWin,-1,STRINGLIST),
	SELITEMS = get_lbox_items (CWIN, SELECTLIST),
	lbox_Resume(CWIN),
	select_if_first(DWIN,CWIN,FOCUS).

%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%	Initialization of controls fields
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
predicates
determ  get_text_rep(DIALOG_ITEM,DIALOG_ITEM_VAL, STRING)
determ INTEGER shrt_max(WINDOW) 
procedure  enable_Ok_button(WINDOW)
procedure  safe_SetFocus(WINDOW)
clauses
  init_fields (Dlg_window, Field_list) :-
	retractall(win_dlg_val(Dlg_window,  _)),
	retractall(win_dlg_field(Dlg_window, _)),
	set_field_values (DLG_WINDOW, FIELD_LIST).

  set_field_values (_,[]):-!.
  set_field_values (WIN, [ FIELD | TAIL ]) :-
	Field = df(ID,ITEM,_),
	retractall(win_dlg_field(Win, df(ID,_,_))), %IYY
	assert(win_dlg_field(Win, Field)),
	init_field (WIN, ID, ITEM),!,
	set_field_values (WIN, TAIL).
  set_field_values (_,_):-errorexit(). % Should never be called !

  init_field (WIN, ID, checkbox(STATE)) :- !,
	init_val(WIN,dv(ID,checkbox(STATE))).

  init_field (WIN, ID, statictext(TXT)) :- !,
	init_val(WIN,dv(ID,statictext(TXT))).

  init_field (WIN, ID, pushbutton(TXT)) :- !,
	init_val(WIN,dv(ID,pushbutton(TXT))).

  init_field ( WIN, ID, scrollbar(_,_,MIN,MAX,POS) ) :- !,
	CWIN = win_GetCtlHandle(WIN, ID),
	win_SetScrollRange(CWIN,sb_Ctl,MIN,MAX),
	init_val(WIN,dv(ID,scrollbar(POS))).
    
  init_field (WIN, ID, radiobuttongroup(ID_L)) :- %!,
	ID_L = [FIRST_ID|_],!,
	init_val(WIN,dv(FIRST_ID,radiobuttongroup(ID))).

  init_field (WIN, ID, listbox(STRINGLIST,SELECTLIST)) :-  
	CWIN = win_GetCtlHandle(WIN, ID),
	init_list_control(WIN, CWIN, STRINGLIST, SELECTLIST,ITEMS,3),
	retractall(win_dlg_val(WIN,  dv(ID, _))),
	assert(win_dlg_val(WIN, dv(ID, listbox(ITEMS,SELECTLIST)))),!.

  init_field (WIN, ID, listbutton(STRINGLIST,SELECT)) :-  
	CWIN = win_GetCtlHandle(WIN, ID),
	init_list_control(WIN, CWIN, STRINGLIST, [SELECT],ITEMS,2),
	ITEMS = [ITEM|_],
	retractall(win_dlg_val(WIN,  dv(ID, _))),
	assert(win_dlg_val(WIN, dv(ID, listbutton(ITEM,SELECT)))),!.

  init_field (WIN, ID, listedit(STRINGLIST,DEFAULT)) :- 
	CWIN = win_GetCtlHandle(WIN, ID),
	init_list_control(WIN, CWIN, STRINGLIST, [],_,4),
	win_SetText(CWIN, DEFAULT),
	retractall(win_dlg_val(WIN,  dv(ID, _))),
	assert(win_dlg_val(WIN, dv(ID, listedit(DEFAULT)))),!.

  init_field( WIN, ID, editstr(Data,_) ) :- !,
	init_val(WIN,dv(ID,editstr(DATA))).

  init_field( WIN, ID, editint(Data,_) ) :- !,
	init_val(WIN,dv(ID,editint(DATA))).

  init_field( WIN, ID, editlong(Data,_) ) :- !,
	init_val(WIN,dv(ID,editlong(DATA))).

  init_field( WIN, ID, editreal(Data,_) ) :- !,
	init_val(WIN,dv(ID,editreal(DATA))).

  init_field( WIN, ID, custom(Text,Value) ) :- !,
	init_val(WIN,dv(ID,custom(Text,Value))).

  init_field( WIN, ID, datafield(Data)) :- !,
	init_val(WIN,dv(ID,datafield(Data))).

  init_field( _, _, Field ) :- 
    term_str(dialog_item, Field, Str),!,
    format(Msg, "% %", dialog_const_error_init_field, Str),
    dlg_Error(Msg).

  init_field( _, _, _ ) :- 
    dlg_Error(dialog_const_error_init_field).

 
  select_if_first(DWIN,WIN,VAL):-
	first_item_text(DWin,OldVal),
	OldVal < VAL,
	retract(first_item_text(DWin,OldVal)),!,%for listbox,listedit,listbutton
%	assert(first_item_text(DWin,VAL)),
	safe_SetFocus(WIN).
  select_if_first(DWIN,WIN,0) :-
	retract(first_item_text(Dwin,_)),
	SHRT_MAX = shrt_max(WIN),!,
	safe_SetFocus(WIN),
	win_SelectText(WIN,0,SHRT_MAX).
  select_if_first(_,_,_).

  safe_SetFocus(WIN):-%YI 970324
	Wsflags=win_GetState(Win),
	dlg_member(wsf_Disabled,Wsflags),!.
  safe_SetFocus(WIN):-%YI 970324
	trap(win_SetFocus(WIN),_,fail),
	fail.
  safe_SetFocus(_):-!.
  
  init_val(Win,dv(ID,statictext(TXT))):- 
	CWIN = win_GetCtlHandle(WIN, ID),
	WinType = win_GetType(CWIN),
%	WinType = wc_Text,!,
	dlg_member(WinType,[wc_Text,wc_GroupBox]),!,
	retractall(win_dlg_val(WIN,  dv(ID, _ ))),
	assert(win_dlg_val(WIN, dv(ID, statictext(TXT)))),
	win_SetText(CWIN, TXT).

  init_val(WIN,dv(ID,pushbutton(TXT))):-
	CWIN = win_GetCtlHandle(WIN, ID),
	WinType = win_GetType(CWIN),
	WinType = wc_PushButton,!,
	retractall(win_dlg_val(WIN,  dv(ID, _ ))),
	assert(win_dlg_val(WIN, dv(ID, pushbutton(TXT)))),
	win_SetText(CWIN, TXT).

  init_val(WIN,dv(ID,checkbox(STATE))):-
	CWIN = win_GetCtlHandle(WIN, ID),
	WinType = win_GetType(CWIN),
	WinType = wc_CheckBox,!,
	retractall(win_dlg_val(WIN,  dv(ID, _ ))),
	assert(win_dlg_val(WIN, dv(ID, checkbox(STATE)))),
	win_Check(CWin,STATE).

  init_val(WIN,dv(ID,scrollbar(POS))):-
	CWIN = win_GetCtlHandle(WIN, ID),
	WinType = win_GetType(CWIN),
	dlg_member(WinType,[wc_HScroll,wc_VScroll]),!,
	retractall(win_dlg_val(WIN,  dv(ID, _ ))),
	assert(win_dlg_val(WIN, dv(ID, scrollbar(POS)))),
	win_SetScrollPos(CWIN,sb_Ctl,POS).

  init_val(WIN,dv(FIRST_ID,radiobuttongroup(ID))):-
	CWIN = win_GetCtlHandle(WIN, ID),
	WinType = win_GetType(CWIN),
	WinType = wc_RadioButton,
	win_dlg_field( WIN, df(_,ITEM,_) ),
	ITEM = radiobuttongroup(ID_L),
	ID_L = [FIRST_ID|_],!,
	retractall(win_dlg_val(WIN,  dv(FIRST_ID, radiobuttongroup(_)))),
	assert(win_dlg_val(WIN, dv(FIRST_ID, radiobuttongroup(ID)))),
	id_l_to_win_l(WIN, ID_L, WINLIST),
	win_CheckRadioButton(CWIN, WINLIST),
	select_if_first(WIN,CWIN,1).

  init_val(WIN,dv(ID,alllist(ITEMLIST))):-	% BB! 24.09.97 (R970923.09)
	CWIN = win_GetCtlHandle(WIN,ID),
	init_list_control(WIN,CWIN,ITEMLIST,[],_,-1),!.

  init_val(WIN,dv(ID,listbox(_,SELECTLIST))):-
	CWIN = win_GetCtlHandle(WIN, ID),
	WinType = win_GetType(CWIN),
	WinType = wc_LBox,!,
	unselect_lbox_items(WIN,ID,CWIN),			% LJ980108
	STRINGLIST = get_lbox_items(CWIN,SELECTLIST),
	retractall(win_dlg_val(WIN,  dv(ID, _))),
	assert(win_dlg_val(WIN, dv(ID, listbox(STRINGLIST,SELECTLIST)))),!.

  init_val(WIN,dv(ID,listbutton(_,SELECT))):-
	CWIN = win_GetCtlHandle(WIN, ID),
	WinType = win_GetType(CWIN),
	WinType = wc_LBoxButton,!,
	lbox_SetSel(CWin,SELECT,b_true),
	STRING = lbox_GetItem(CWin,SELECT),
	retractall(win_dlg_val(WIN,  dv(ID, _))),
	assert(win_dlg_val(WIN, dv(ID, listbutton(STRING,SELECT)))),!.

  init_val(WIN,dv(ID,listedit(TXT))):-
	CWIN = win_GetCtlHandle(WIN, ID),
	WinType = win_GetType(CWIN),
	WinType = wc_LBoxEdit,!,
	win_SetText(CWin,Txt),
	retractall(win_dlg_val(WIN,  dv(ID, _))),
	assert(win_dlg_val(WIN, dv(ID, listedit(TXT)))),!.

  init_val(WIN,dv(ID,custom(Text,Value))):-
	retractall(win_dlg_val(WIN,  dv(ID, _))),
	assert(win_dlg_val(WIN, dv(ID, custom(Text,Value)))),!.
  
  init_val(WIN,dv(ID,datafield(Data))):-
	retractall(win_dlg_val(WIN,  dv(ID,datafield(_)))),
	assert(win_dlg_val(Win, dv(ID,datafield(Data)))),!.

  init_val(WIN,dv(ID,ITEM)):-
	CWIN = win_GetCtlHandle(WIN, ID),
	WinType = win_GetType(CWIN),
	WinType = wc_Edit,
	win_dlg_field(WIN, DF),	%LJP
	DF = df(ID, DLG_ITEM, _),	%LJP
	get_text_rep(DLG_ITEM,ITEM, TXT), !, % editstr, editint, editlong and editreal
	retractall(win_dlg_val(WIN,  dv(ID, _ ))),
	assert(win_dlg_val(WIN, dv(ID, editstr(TXT)))),
	enable_Ok_button(Win),
	win_SetText(CWIN, TXT),
	select_if_first(WIN,CWIN,0).

  init_val(_,dv(_,ITEM)):-
	term_str(dialog_item_val, Item, Str),
	format(Msg, "% %", dialog_const_error_init_value, Str),!,
	dlg_Error(Msg).
  init_val(_,_):-
	dlg_Error(dialog_const_error_init_value).

  get_lbox_items(_,[],[]):-!.
  get_lbox_items(CWIN,[SELECT|SELECTLIST],[STRING|ITEMS]):-
	WinType=win_GetType(CWin),
	dlg_member(WinType,[wc_LBox,wc_LBoxEdit,wc_LBoxButton]),!,
	lbox_SetSel(CWin,SELECT,b_true),
	STRING = lbox_GetItem(CWin,SELECT),
	ITEMS = get_lbox_items(CWIN,SELECTLIST).
  get_lbox_items(_,_,[]):-
	errorexit().

  % LJ980108
  unselect_lbox_items(WIN,ID,CWIN):-
	win_dlg_val(WIN, dv(ID,listbox(_,SELECTLIST))),
	unselect_lbox_item(CWIN,SELECTLIST),!.
  unselect_lbox_items(_,_,_).

  unselect_lbox_item(CWIN,SELECTLIST):-
	WinType=win_GetType(CWin),
	dlg_member(WinType,[wc_LBox,wc_LBoxEdit,wc_LBoxButton]),!,
	unselect_lbox_item1(CWIN,SELECTLIST).

  unselect_lbox_item1(CWIN,[SELECT|SELECTLIST]):-
	lbox_SetSel(CWin,SELECT,b_false),!,
	unselect_lbox_item1(CWIN,SELECTLIST).
  unselect_lbox_item1(_,_).

%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%	get edit value
%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  get_text_rep(_,editstr(TXT), TXT) :- !.
  get_text_rep(_,editint(void), "" ) :- !.
  get_text_rep(_,editint(i(I)), TXT ) :- !,
	trap(str_int(TXT, I),_,fail).
  get_text_rep(_,editlong(void), "" ) :- !.
  get_text_rep(_,editlong(l(L)), TXT ) :- !,
	trap(term_str(long,L,TXT),_,fail).
  get_text_rep(_,editreal(void), "" ) :- !.
  get_text_rep(editreal(_,PROPS),editreal(r(R)), TXT ) :-
		dlg_member(decimals(Decimals),PROPS),
		!,
		format(FormatStr,"%%4.%f",Decimals),
		format(TXT,FormatStr,R).
  get_text_rep(_,editreal(r(R)), TXT ) :-
	trap(str_real(TXT, R),_,fail).

%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%	Validation
%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

database - validate
  validate_flag

predicates
determ  simple_validation(WINDOW)
determ  simple_validate_fields (WINDOW, DIALOG_FIELD_LIST, DIALOG_CONTROL_ID)
determ  simple_validate_field (WINDOW, DIALOG_CONTROL_ID, DIALOG_ITEM, DIALOG_ERROR_PROMPT)
determ  simple_validate_field1(WINDOW, DIALOG_CONTROL_ID, STRING, DIALOG_ITEM, DIALOG_ERROR_PROMPT,BOOLEAN Beep)
determ  simple_validate_str(WINDOW, DIALOG_CONTROL_ID, STRING, DIALOG_STR_PROPS, DIALOG_ERROR_PROMPT,BOOLEAN Beep)
determ  simple_validate_int(WINDOW, DIALOG_CONTROL_ID, STRING, DIALOG_INT_PROPS, DIALOG_ERROR_PROMPT,BOOLEAN Beep)
determ  simple_validate_long(WINDOW, DIALOG_CONTROL_ID, STRING, DIALOG_LONG_PROPS, DIALOG_ERROR_PROMPT,BOOLEAN Beep)
determ  simple_validate_real(WINDOW, DIALOG_CONTROL_ID, STRING, DIALOG_REAL_PROPS, DIALOG_ERROR_PROMPT,BOOLEAN Beep)
determ  get_default(DIALOG_STR_PROPS, STRING)
determ  get_default(DIALOG_LONG_PROPS, LONG)
determ  get_default(DIALOG_INT_PROPS, INTEGER)
determ  get_default(DIALOG_REAL_PROPS, REAL)
procedure  show_formatted_error (WINDOW, DIALOG_CONTROL_ID, STRING, DIALOG_ERROR_PROMPT, STRING,BOOLEAN Beep)
procedure  get_prompt_text (WINDOW,DIALOG_ERROR_PROMPT, STRING, STRING,STRING)
determ  simple_validate_str1(WINDOW, DIALOG_CONTROL_ID, STRING, DIALOG_STR_PROP, DIALOG_ERROR_PROMPT,BOOLEAN Beep)
determ  simple_validate_int1(WINDOW, DIALOG_CONTROL_ID, STRING, DIALOG_INT_PROP, DIALOG_ERROR_PROMPT,BOOLEAN Beep)
determ  simple_validate_int2(WINDOW, DIALOG_CONTROL_ID, INTEGER, DIALOG_INT_PROP, DIALOG_ERROR_PROMPT,BOOLEAN Beep)
determ  simple_validate_long1(WINDOW, DIALOG_CONTROL_ID, STRING, DIALOG_LONG_PROP, DIALOG_ERROR_PROMPT,BOOLEAN Beep)
determ  simple_validate_long2(WINDOW, DIALOG_CONTROL_ID, LONG, DIALOG_LONG_PROP, DIALOG_ERROR_PROMPT,BOOLEAN Beep)
determ  simple_validate_real1(WINDOW, DIALOG_CONTROL_ID, STRING, DIALOG_REAL_PROP, DIALOG_ERROR_PROMPT,BOOLEAN Beep)
determ  simple_validate_real2(WINDOW, DIALOG_CONTROL_ID, REAL, DIALOG_REAL_PROP, DIALOG_ERROR_PROMPT,BOOLEAN Beep)
clauses

  dialog_CheckEditProperties(WIN,ID):-		% BB!
	findall(FIELD, win_dlg_field(WIN, FIELD), FIELD_LIST),
	not(validate_flag),
	assert(validate_flag),
	simple_validate_fields (WIN, FIELD_LIST,ID),
	retractall(validate_flag),!.
  dialog_CheckEditProperties(_,_):-		% BB!
	retractall(validate_flag),!,
	fail.

  dialog_CheckEditProperties(WIN):-		% LHJ!
	simple_validation(WIN).

  simple_validation (WIN) :-
	findall(FIELD, win_dlg_field(WIN, FIELD), FIELD_LIST),
	not(validate_flag),
	assert(validate_flag),
	simple_validate_fields (WIN, FIELD_LIST,_ID/*BB*/),
	retractall(validate_flag),!.
  simple_validation (_) :-
	retractall(validate_flag),!,
	fail.

  simple_validate_fields (_, [], ID):-	% BB!
	bound(ID),!.
  simple_validate_fields (_, [],0):-!.
  simple_validate_fields (WIN, [ df(ID, ITEM, PROMPT ) | _ ], ID):-
	not(simple_validate_field (WIN, ID, ITEM, PROMPT)),!,
	fail.
  simple_validate_fields (WIN, [ _ | TAIL ], ID) :-
    /* skip head of list; complex validation or validation check succeeded */
	simple_validate_fields ( WIN, TAIL, ID).
    
  % fails if invalid
  simple_validate_field (WIN, ID, ITEM, PROMPT) :-
	win_dlg_val (WIN, dv(ID, ITEMVAL)),		% BB!
	ITEMVAL = editstr(_STR),   % validate edit fields only (str, int, real)
	CW  = win_GetCtlHandle(WIN,ID),
	Wsflags = win_GetState(CW),
	dlg_member(wsf_Enabled,Wsflags),
%	not(dlg_member(wsf_Invisible,Wsflags)),
	  STR = win_GetText(CW),!,
	  simple_validate_field1 (WIN, ID, STR, ITEM, PROMPT,b_false).
  simple_validate_field (_,_,_,_).

  simple_validate_field1(_,_,"",editstr(_,PROPS),_,_):-
	get_default(PROPS, _), !.
  simple_validate_field1(W,ID,VAL,editstr(_,PROPS),PROMPT,Beep):-!,
	simple_validate_str(W,ID,VAL,PROPS,PROMPT,Beep).
  simple_validate_field1(_,_, "", editint(_,PROPS),_,_):-
	get_default(PROPS, _), !.
  simple_validate_field1(W,ID,VAL,editint(_,PROPS),PROMPT,Beep):-!,
	simple_validate_int(W,ID,VAL,PROPS,PROMPT,Beep).
  simple_validate_field1(_,_, "", editlong(_,PROPS),_,_):-
	get_default(PROPS, _), !.
  simple_validate_field1(W,ID,VAL,editlong(_,PROPS),PROMPT,Beep):-!,
	simple_validate_long(W,ID,VAL,PROPS,PROMPT,Beep).
  simple_validate_field1(_,_, "", editreal(_,PROPS),_,_):-
	get_default(PROPS, _), !.
  simple_validate_field1(W,ID,VAL,editreal(_,PROPS),PROMPT,Beep):-!,
	simple_validate_real(W,ID,VAL,PROPS,PROMPT,Beep).

  get_default([default(DEF)|_],DEF) :- !.
  get_default([_|T],DEF) :- 
	get_default(T,DEF).

  simple_validate_str(_,_,_, [], _,_) :- !.
  simple_validate_str(WIN, ID, VALUE, [H|T], PROMPT,Beep) :-
	simple_validate_str1(WIN, ID, VALUE, H, PROMPT,Beep),
	simple_validate_str(WIN, ID, VALUE, T, PROMPT,Beep).

  /* simple_validate_str1 fails if invalid. */
  simple_validate_str1(WIN, ID, "", mandatory, PROMPT,Beep) :- !,
	show_formatted_error(WIN, ID, dialog_const_error_mandatory, PROMPT, "",Beep),
	fail.
  simple_validate_str1(WIN, ID, VALUE, length(L), PROMPT,Beep) :-
	str_len(VALUE,L1),
	L1 > L,!,
	format (ERR,dialog_const_error_length, L),
	show_formatted_error (WIN, ID, "%s %s", PROMPT, ERR,Beep),
	fail.
  simple_validate_str1(_,_,_,_,_,_). % field is ok

  simple_validate_int(_,_,"",[],_,_):-!.	% 4.01.1999 BB!
  simple_validate_int(_,_,VALUE,[],_,_):- 
	trap(str_int(VALUE,_),_,fail),!.
ifndef os_nt
  simple_validate_int(WIN,ID,VALUE,[],PROMPT,Beep):-
	trap(term_str(long,_,VALUE),_,fail),
	show_formatted_error(WIN,ID,dialog_const_error_long_integer,PROMPT,"",Beep),!,
	fail.
enddef
  simple_validate_int(WIN,ID,_,[],PROMPT,Beep):-
	show_formatted_error(WIN,ID,dialog_const_error_integer,PROMPT,"",Beep),!,
	fail.
  simple_validate_int(WIN, ID, VALUE, [H|T], PROMPT,Beep) :-
	simple_validate_int1(WIN, ID, VALUE, H, PROMPT,Beep),
	simple_validate_int(WIN, ID, VALUE, T, PROMPT,Beep).

  /* simple_validate_int1 fails if invalid. */
  simple_validate_int1(WIN, ID, "", mandatory, PROMPT,Beep) :- !,
	show_formatted_error (WIN, ID, dialog_const_error_mandatory, PROMPT, "",Beep),
	fail.
  simple_validate_int1(_,_, "", _, _,_) :- !.
  simple_validate_int1(WIN, ID, VALUE, PROP, PROMPT,Beep) :-
	trap(str_int(VALUE, INT),_,fail),!,
	simple_validate_int2(WIN, ID, INT, PROP, PROMPT,Beep).
ifndef os_nt
  simple_validate_int1(WIN, ID, VALUE, _, PROMPT,Beep) :-
	trap(term_str(long, _, VALUE), _, fail),
	show_formatted_error (WIN, ID, dialog_const_error_long_integer, PROMPT, "",Beep),!,
	fail.
enddef
  simple_validate_int1(WIN, ID,  _, _, PROMPT,Beep) :-
	show_formatted_error (WIN, ID, dialog_const_error_integer, PROMPT, "",Beep),
	fail.

  simple_validate_int2(_,_, VALUE, range(FROM, TO), _,_) :-
	FROM <= VALUE,
	VALUE <= TO, !.
  simple_validate_int2(WIN, ID, VALUE, range(FROM, TO), PROMPT,Beep) :- !,
	format (ERR,dialog_const_error_range, FROM, TO, VALUE),
	show_formatted_error (WIN, ID, "%s %s", PROMPT, ERR,Beep),
	fail.
  simple_validate_int2(WIN, ID, VALUE, minimum(MIN), PROMPT,Beep) :- 
	VALUE < MIN, !,
	format (ERR,dialog_const_error_minimum, MIN),
	show_formatted_error (WIN, ID, "%s %s", PROMPT, ERR,Beep),
	fail.
  simple_validate_int2(WIN, ID, VALUE, maximum(MAX), PROMPT,Beep) :- 
	VALUE > MAX, !,
	format (ERR,dialog_const_error_maximum, MAX),
	show_formatted_error (WIN, ID, "%s %s", PROMPT, ERR,Beep),
	fail.
  simple_validate_int2(_,_,_,_,_,_).

  simple_validate_long(_,_,"",[], _,_):-!.	% 4.01.1999 BB!
  simple_validate_long(_,_,VALUE,[], _,_):-
	trap(term_str(long,_,VALUE),_,fail),!.
  simple_validate_long(WIN,ID,_,[],PROMPT,Beep):-
	show_formatted_error(WIN,ID,dialog_const_error_long,PROMPT,"",Beep),!,
	fail.
  simple_validate_long(WIN, ID, VALUE, [H|T], PROMPT,Beep) :-
	simple_validate_long1(WIN, ID, VALUE, H, PROMPT,Beep),
	simple_validate_long(WIN, ID, VALUE, T, PROMPT,Beep).

  /* simple_validate_long1 fails if invalid. */
  simple_validate_long1(WIN, ID, "", mandatory, PROMPT,Beep) :- !,
	show_formatted_error (WIN, ID, dialog_const_error_mandatory, PROMPT, "",Beep),
	fail.
  simple_validate_long1(_,_, "", _, _,_) :- !.
  simple_validate_long1(WIN, ID, VALUE, PROP, PROMPT,Beep) :-
	trap(term_str(long,L,VALUE),_,fail),!,
	simple_validate_long2(WIN, ID, L, PROP, PROMPT,Beep).
  simple_validate_long1(WIN, ID,  _, _, PROMPT,Beep) :-
	show_formatted_error (WIN, ID, dialog_const_error_long, PROMPT, "",Beep),
	fail.

  simple_validate_long2(_,_, VALUE, range(FROM, TO), _,_) :-
	FROM <= VALUE,
	VALUE <= TO, !.
  simple_validate_long2(WIN, ID, VALUE, range(FROM, TO), PROMPT,Beep) :- !,
	format (ERR,dialog_const_error_range, FROM, TO, VALUE),
	show_formatted_error (WIN, ID, "%s %s", PROMPT, ERR,Beep),
	fail.
  simple_validate_long2(WIN, ID, VALUE, minimum(MIN), PROMPT,Beep) :- 
	VALUE < MIN, !,
	format (ERR,dialog_const_error_minimum, MIN),
	show_formatted_error (WIN, ID, "%s %s", PROMPT, ERR,Beep),
	fail.
  simple_validate_long2(WIN, ID, VALUE, maximum(MAX), PROMPT,Beep) :- 
	VALUE > MAX, !,
	format (ERR,dialog_const_error_maximum, MAX),
	show_formatted_error (WIN, ID, "%s %s", PROMPT, ERR,Beep),
	fail.
  simple_validate_long2(_,_,_,_,_,_).

  simple_validate_real(_,_,"",[],_,_):-!.	% 4.01.1999 BB!
  simple_validate_real(_,_,VALUE,[],_,_):-
	trap(str_real(VALUE,_),_,fail),!.
  simple_validate_real(WIN,ID,_,[],PROMPT,Beep):-
	show_formatted_error(WIN,ID,dialog_const_error_real,PROMPT,"",Beep),!,
	fail.
  simple_validate_real(W, ID, VALUE, [H|T], PROMPT,Beep) :-
	simple_validate_real1(W, ID, VALUE, H, PROMPT,Beep),
	simple_validate_real(W, ID, VALUE, T, PROMPT,Beep).

  /* simple_validate_real1 fails if invalid. */
  simple_validate_real1(W, ID, "", mandatory, PROMPT,Beep) :- !,
	show_formatted_error (W, ID, dialog_const_error_mandatory, PROMPT, "",Beep),
	fail.
  simple_validate_real1(_,_, "", _, _,_) :- !.
  simple_validate_real1(W, ID, VALUE, PROP, PROMPT,Beep) :-
	trap(str_real(VALUE, Real),_,fail),!,
	simple_validate_real2(W, ID, Real, PROP, PROMPT,Beep).
  simple_validate_real1(W, ID, _, _, PROMPT,Beep) :-
	show_formatted_error (W, ID, dialog_const_error_real, PROMPT, "",Beep),
	fail.

  simple_validate_real2(_,_, VALUE, range(FROM, TO), _,_) :-
	FROM <= VALUE,
	VALUE <= TO, !.
  simple_validate_real2(W, ID, VALUE, range(FROM, TO), PROMPT,Beep) :- !,
	format (ERR,dialog_const_error_range, FROM, TO,VALUE),
	show_formatted_error (W, ID, "%s %s", PROMPT, ERR,Beep),
	fail.
  simple_validate_real2(W, ID, VALUE, minimum(MIN), PROMPT,Beep) :- 
	VALUE < MIN, !,
	format (ERR,dialog_const_error_minimum, MIN),
	show_formatted_error (W, ID, "%s %s", PROMPT, ERR,Beep),
	fail.
  simple_validate_real2(W, ID, VALUE, maximum(MAX), PROMPT,Beep) :- 
	VALUE > MAX, !,
	format (ERR,dialog_const_error_maximum, MAX),
	show_formatted_error (W, ID, "%s %s", PROMPT, ERR,Beep),
	fail.
  simple_validate_real2(_,_,_,_,_,_).

  get_prompt_text (_,own_prompt(ERR),_FORM,_STR, ERR) :- !.
  get_prompt_text (W,dlg_prompt(ID),FORM,STR, ERR) :- !,
	CWIN = win_GetCtlHandle(W,ID),
	PTEXT = win_GetText(CWIN),
	format (ERR, FORM, PTEXT, STR),!.
  get_prompt_text (_,str_prompt(PTEXT),FORM,STR, ERR) :- !,
	format (ERR, FORM, PTEXT, STR),!.
  get_prompt_text (_,_,FORM, STR,ERR):-
	PTEXT = dialog_const_prompt_default,
	format (ERR, FORM, PTEXT, STR),!.


  show_formatted_error (WIN, ID, FORM, PROMPT, STR,b_false) :-
%    Highlight invalid item and put up error message 
	CWIN = win_GetCtlHandle(WIN, ID),
	get_prompt_text (WIN,PROMPT,FORM, STR, ERR),
	dlg_Error (ERR),
	SHRT_MAX = shrt_max(CWIN),!,
	safe_SetFocus(CWIN),
	win_SelectText(CWIN,0,SHRT_MAX).
  show_formatted_error (_WIN, _ID, _FORM, _PROMPT, _STR,_Any/*b_true*/) :-!.
	%sound(10,1000)

%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%	Retrieval
%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
predicates
procedure  get_modal_results1 (INTEGER,WINDOW, DIALOG_VAL_LIST)
procedure  format_items (WINDOW, DIALOG_VAL_LIST, DIALOG_VAL_LIST)
procedure  format_fields(DIALOG_FIELD_LIST,DIALOG_VAL_LIST,DIALOG_VAL_LIST)	% BB! 27.11.97 (R971127.05)
procedure  format_item1(DIALOG_ITEM, DIALOG_ITEM_VAL, DIALOG_ITEM_VAL)
procedure  format_str(DIALOG_STR_PROPS, STRING, STRING)
procedure  format_str1(DIALOG_STR_PROP, STRING, STRING)
clauses
  get_modal_results(WIN,RESULTLIST,BUTTON) :-
	dlg_result(WIN, BUTTON),!,
	get_modal_results1(Button, Win, Resultlist).
  get_modal_results (_,[],idc_cancel).

  get_modal_results1(idc_ok, Win, Resultlist) :- !,
	get_dlg_values (WIN, RESULTLIST).
  get_modal_results1(_,_, []).

  get_dlg_values(WIN,RESULTLIST):-
	findall(DLG_VAL,win_dlg_val(WIN,DLG_VAL),DLG_VALLIST),!,
	format_items(WIN,DLG_VALLIST,VALUELIST),
 	findall(DF,win_dlg_field(WIN,DF),DF_LIST),	% BB! 27.11.97 (R971127.05)
 	format_fields(DF_LIST,VALUELIST,RESULTLIST).
  get_dlg_values(_,[]).

  format_items(_,[],[]):-!.
  format_items(WIN,[DLG_VAL|T],[DLG_VAL1|LIST]):-
	format_item(WIN,DLG_VAL,DLG_VAL1),!,
	format_items(WIN,T,LIST).
  format_items(_,_,[]):-errorexit(). % Should never be called !

  format_fields([],VALLIST,VALLIST):-!.
  format_fields([df(ID,listbox(ALLLIST,_),_)|LIST1],VALLIST,[dv(ID,alllist(ALLLIST))|LIST2]):-!,
 	format_fields(LIST1,VALLIST,LIST2).
  format_fields([df(ID,listbutton(ALLLIST,_),_)|LIST1],VALLIST,[dv(ID,alllist(ALLLIST))|LIST2]):-!,
 	format_fields(LIST1,VALLIST,LIST2).
  format_fields([df(ID,listedit(ALLLIST,_),_)|LIST1],VALLIST,[dv(ID,alllist(ALLLIST))|LIST2]):-!,
 	format_fields(LIST1,VALLIST,LIST2).
  format_fields([_|LIST1],VALLIST,LIST2):-!,
 	format_fields(LIST1,VALLIST,LIST2).
  format_fields(_,_,[]):-errorexit(). % Should never be called !

  format_item(WIN, dv(ID, VAL1), dv(ID, VAL2)) :-
	win_dlg_field(WIN, DF),
	DF = df(ID, DLG_ITEM, _),!,
	format_item1(DLG_ITEM, VAL1, VAL2).
  format_item(_, ITEM_VAL, ITEM_VAL).
    
  format_item1(editstr(_,PROPS), editstr(""), editstr(TXT)) :-
	get_default(PROPS, Def), !,
	format_str(PROPS, Def, TXT).
  format_item1(editstr(_,PROPS), editstr(TXT1), editstr(TXT2)) :-!, 
	format_str(PROPS, TXT1, TXT2).

  format_item1(editint(_,PROPS), editstr(""), editint(i(Def))) :-
	get_default(PROPS, Def), !.
  format_item1(editint(_,_), editstr(""), editint(void)) :- !.
  format_item1(editint(_,_), editstr(TXT), editint(i(INT))) :-
	trap(str_int(TXT, INT),_,fail),!.

  % an integer may not be valid if format_item1 is called before validation
  % this is the case for get_user_action
  format_item1(editint(_,_), editstr(TXT), editstr(TXT)) :- !.

  format_item1(editlong(_,PROPS), editstr(""), editlong(l(Def))) :-
	get_default(PROPS, Def), !.
  format_item1(editlong(_,_), editstr(""), editlong(void)) :- !.
  format_item1(editlong(_,_), editstr(TXT), editlong(l(L))) :-
	trap(term_str(long,L,TXT),_,fail),!.

  % a long may not be valid if format_item1 is called before validation
  % this is the case for get_user_action
  format_item1(editlong(_,_), editstr(TXT), editstr(TXT)) :- !.

  format_item1(editreal(_,PROPS), editstr(""), editreal(r(Def))) :-
	get_default(PROPS, Def), !.
  format_item1(editreal(_,_), editstr(""), editreal(void)) :- !.
  format_item1(editreal(_,_), editstr(TXT), editreal(r(REAL))) :-
	trap(str_real(TXT, REAL),_,fail),!.

  % a real may not be valid if format_item1 is called before validation
  % this is the case for get_user_action
  format_item1(editreal(_,_), editstr(TXT), editstr(TXT)) :- !.

  format_item1(_, VAL, VAL).

  format_str([], S, S) :- !.
  format_str([H|T], S1, S3) :-
	format_str1(H, S1, S2),!,
	format_str(T, S2, S3).
  format_str(_,_,""):-errorexit(). % Should never be called !

  format_str1(upper, S1, S2) :- upper_lower(S2, S1),!.
  format_str1(lower, S1, S2) :- upper_lower(S1, S2),!.
  format_str1(_, S, S).
    
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%	Utility
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  dlg_member(ID, [ID|_]):-!.
  dlg_member(ID, [_|T]):-
	dlg_member(ID,T).

  get_enable_flag(b_true,wsf_Enabled):-!.
  get_enable_flag(_Any,wsf_Disabled).

  get_show_flag(b_true,wsf_Visible):-!.
  get_show_flag(_Any,wsf_Invisible).

  dlg_min(A,B,A) :- A < B,!.
  dlg_min(_,B,B).

  dlg_max(A,B,A) :- A > B,!.
  dlg_max(_,B,B).

  shrt_max(Win,Len):-
	String=win_GetText(Win),
	str_len(String,Len),!.
  
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% 	Modeless dialog callback function                             
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
predicates
procedure  user_dialog_control(WINDOW, DIALOG_CONTROL_ID,WINTYPE,
                      CONTROL_INFO)
determ  modeless_dlg_ok(WINDOW, BOOLEAN)
determ  modeless_dialog_callback(WINDOW, DIALOG_CONTROL_ID,WINTYPE,
		 CONTROL_INFO, BOOLEAN)
clauses
  modeless_dialog_event(Win, e_create(_)) :-
	modeless_info(Win, Field_l,_),
	init_fields(Win,Field_l),!.
  modeless_dialog_event(W, e_destroy) :-
	clean_up(W), !.
  modeless_dialog_event(W, e_control(ID,TYPE,_, INFO)) :-
	modeless_dialog_callback(W, ID,TYPE, INFO, KEEP),
	KEEP = b_false,!,
	win_Destroy(W).
  modeless_dialog_event(W, e_Char(27, _)) :-
	trap(CW = win_GetCtlHandle(W,idc_cancel),_,fail),!,
	win_SendEvent(W,e_Control(idc_cancel,wc_PushButton,CW, activated())).
  modeless_dialog_event(W, e_Char(13, _)) :-
	trap(CW = win_GetCtlHandle(W, idc_ok),_,fail),!,
	win_SendEvent(W,e_Control(idc_ok,wc_PushButton,CW, activated())).
  modeless_dialog_event(_,_).

  modeless_dialog_callback (WIN,_,_,_, b_true) :-
	ignore_event(WIN),!,fail. % see definition for documentation
  modeless_dialog_callback (_Win, idc_cancel,_, _, b_false) :- !.
  modeless_dialog_callback (Win, idc_ok,_, _, Keep) :-
	modeless_dlg_ok(Win, Keep), !.
  modeless_dialog_callback (_, idc_ok,_, _, b_true) :- !.

    /* Check for any user defined dialog controls */
  modeless_dialog_callback (Win, DLG_CONTROL_ID,TYPE, DLG_INFO, b_true) :-
	modeless_info(Win, _, _),
	user_dialog_control(Win, DLG_CONTROL_ID,TYPE, DLG_INFO),!.
  modeless_dialog_callback (_,_,_,_, b_true).

  modeless_dlg_ok(Win, b_false) :-
	read_current_values(Win),
	simple_validation(Win).

%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% 	Modal dialog callback function                             
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
predicates
procedure  modal_dlg_ok(WINDOW, BOOLEAN)
determ  modal_dialog_callback(WINDOW, DIALOG_CONTROL_ID,WINTYPE, CONTROL_INFO, BOOLEAN)
clauses
  modal_dialog_event(Win, e_create(_)) :-
	modal_info(Win, Field_l),
	retractall(first_item_text(Win,_)),
	assert(first_item_text(Win,0)),
	init_fields(Win,Field_l),!.
  modal_dialog_event(W, e_control(CID,Type,_,CONTROL_INFO)) :-
	modal_dialog_callback(W, CID,Type, CONTROL_INFO, KEEP),
	KEEP = b_false,!,
	win_Destroy(W).
  modal_dialog_event(_, _).

  modal_dialog_callback(WIN,_,_,_,b_true) :-
	ignore_event(WIN), !,fail. % see declaration for documentation
  modal_dialog_callback (Win, idc_cancel,_, _, b_false) :-!,
	assert(dlg_result(WIN, idc_cancel)).
  modal_dialog_callback (Win, idc_ok,_, _, Keep_dialog) :- !,
	modal_dlg_ok(Win, Keep_dialog).

  /* Check for any user defined dialog controls */
  modal_dialog_callback (WIN, ID,Type, DLG_INFO, b_true) :-
	modal_info(Win, _),
	user_dialog_control(WIN, ID,Type, DLG_INFO),!.
  modal_dialog_callback (_,_,_,_, b_true).

  modal_dlg_ok(Win, b_false) :-
	read_current_values(Win),
	simple_validation(Win),
	modal_info(Win,_),!,
	assert(dlg_result(WIN,idc_ok)).
  modal_dlg_ok(_, b_true).

%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%	handle e_Control event
%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
predicates
determ  call_field (WINDOW,DIALOG_CONTROL_ID,DIALOG_ITEM,CONTROL_INFO)
determ  get_item (WINDOW, INTEGER,WINTYPE, DIALOG_ITEM)
determ  lock_large_length(DIALOG_STR_PROPS,STRING,WINDOW)
determ  enable_Ok_button1(WINDOW,DIALOG_ITEM)
determ  is_exist_mandatory(DIALOG_STR_PROPS)
determ  is_exist_mandatory(DIALOG_INT_PROPS)
determ  is_exist_mandatory(DIALOG_LONG_PROPS)
determ  is_exist_mandatory(DIALOG_REAL_PROPS)
clauses
%default property
  user_dialog_control(WIN, ID,wc_Edit, losefocus()) :-
	CW  = win_GetCtlHandle(Win,Id),
	S = win_GetText(CW), S = "",
	win_dlg_field(WIN, df(ID,DLG_ITEM,_)),
	format_item1(DLG_ITEM, editstr(""), ITEM),
	get_text_rep(DLG_ITEM,ITEM, TXT),
	TXT <> "",
	win_SetText(CW,TXT),
	fail.
%length property
  user_dialog_control(WIN, ID,wc_Edit, modified()) :-
	CW  = win_GetCtlHandle(Win,Id),
	S = win_GetText(CW),
	win_dlg_field(WIN, df(ID,editstr(_,PROP),_)),
	lock_large_length(PROP,S,CW),
	!.
/*
%simple validation
  user_dialog_control(WIN, ID,wc_Edit, losefocus()) :-
	win_dlg_field(WIN,df(ID, ITEM, PROMPT )),
	CW  = win_GetCtlHandle(Win,Id),
	S = win_GetText(CW),
	strip_trailing_spaces(S, STR1),
	not(simple_validate_field1 (WIN, ID, STR1, ITEM, PROMPT,b_true)),
	fail.
*/
%mandatory property
  user_dialog_control(WIN, ID,Type, DLG_INFO) :-
	get_item(WIN, ID,Type,ITEM ), 
	call_field(WIN, ID, ITEM, DLG_INFO),
	fail. 
  user_dialog_control(WIN, _,wc_Edit, modified()) :-
	enable_Ok_button(WIN),
	fail.
  user_dialog_control(_,_,_,_) :- !.

  call_field (WIN, ID, checkbox(_), _) :- 
	win_dlg_val (WIN, dv(ID, ITEM)), 
	ITEM = checkbox(STATE), !,
	click_chk_box (WIN, ID, STATE).

  call_field (WIN, ID, radiobuttongroup(ID_L), _) :- 
	click_radio_button(WIN, ID, ID_L),!.
    
  call_field (WIN, ID, scrollbar(LINE,PAGE,_,_,_), INFO) :-!,
	INFO = scroll(SCROLLCONTROL,THUMBPOS),
	read_and_set_scrollbar (WIN,ID,LINE,PAGE,SCROLLCONTROL,THUMBPOS).
    
  call_field(WIN,ID,ITEM,modified):-
	read_current2 ( WIN, ID, ITEM,modified),!.
  call_field(WIN,ID,ITEM,selchanged()):-
	read_current2 ( WIN, ID, ITEM,selchanged()),!.
  call_field(WIN,ID,ITEM,activated()):-
	read_current2 ( WIN, ID, ITEM,activated()),!.

  call_field (_,_,_,_).

  get_item(WIN,ID,_Type,ITEM) :-
	win_dlg_field( WIN, df(ID,ITEM,_) ), !.
  get_item(WIN,ID,_Type,ITEM) :-
	win_dlg_field( WIN, df(_,ITEM,_) ),
	ITEM = radiobuttongroup(ID_L),
	dlg_member(ID, ID_L),!.
  get_item(WIN,ID,wc_CheckBox,checkbox(b_false)) :-!,
	assert(win_dlg_field( WIN, df(ID,checkbox(b_false),nopr) )), 
	assert(win_dlg_val(WIN, dv(ID, checkbox(b_false)))).

  lock_large_length([],_,_):-!,fail.
  lock_large_length([length(L)|_],S,CW):-
	str_len(S,Lcur),
	Lcur > L,
	frontstr(L,S,TXT,_),!,
	win_SetText(CW,TXT),
	safe_SetFocus(CW),
	win_SelectText(CW,L,L).
  lock_large_length([_|PROP],S,CW):-
	lock_large_length(PROP,S,CW),!.

  change_state_edit(Win,CWin):-
	WinType = win_GetType(CWIN),
	WinType = wc_Edit,
	enable_Ok_button(Win),!.
  change_state_edit(_,_):-!.

  enable_Ok_button(Win):-
	retractall(disable_ok_button(Win,_)),
 	assert(disable_ok_button(Win,1)),
	fail.
  enable_Ok_button(Win):-
	win_dlg_val(WIN, dv(ID,editstr(Val))),
	  win_dlg_field(WIN, df(ID,DLG_ITEM,_)),
	  Val = "",
	  trap(Edit  = win_GetCtlHandle(Win,ID),_,fail),
	  Wsflags = win_GetState(Edit),
	  dlg_member(wsf_Enabled,Wsflags),
%	  not(dlg_member(wsf_Invisible,Wsflags)),
	    enable_Ok_button1(Win,DLG_ITEM),
	fail.
  enable_Ok_button(Win):-
	disable_ok_button(Win,0),	%need to disable
	trap(Ok  = win_GetCtlHandle(Win,idc_ok),_,fail),
	Wsflags=win_GetState(Ok),
	dlg_member(wsf_Enabled,Wsflags),%gray if enabled
	win_SetState(Ok,[wsf_Disabled]),
	fail.
  enable_Ok_button(Win):-
	disable_ok_button(Win,1), %all mandatory field are not empty
	trap(Ok  = win_GetCtlHandle(Win,idc_ok),_,fail),
	Wsflags=win_GetState(Ok),
	dlg_member(wsf_Disabled,Wsflags),%enable if grayed
	win_SetState(Ok,[wsf_Enabled]),
	fail.
  enable_Ok_button(_):-!.

  enable_Ok_button1(Win,editstr(_, PROPS)):-
	is_exist_mandatory(PROPS),
	retractall(disable_ok_button(Win,_)),
	assert(disable_ok_button(Win,0)),!.
  enable_Ok_button1(Win,editint(_, PROPS)):-
	is_exist_mandatory(PROPS),
	retractall(disable_ok_button(Win,_)),
	assert(disable_ok_button(Win,0)),!.
  enable_Ok_button1(Win,editlong(_, PROPS)):-
	is_exist_mandatory(PROPS),
	retractall(disable_ok_button(Win,_)),
	assert(disable_ok_button(Win,0)),!.
  enable_Ok_button1(Win,editreal(_, PROPS)):-
	is_exist_mandatory(PROPS),
	retractall(disable_ok_button(Win,_)),
	assert(disable_ok_button(Win,0)),!.

  is_exist_mandatory([]):-!,fail.
  is_exist_mandatory([mandatory|_]):-!.
  is_exist_mandatory([_|PROPS]):-
	is_exist_mandatory(PROPS).

%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
