/******************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S 

 FileName:	DATE_CMI.PRO
 PURPOSE:	Date custom control
 Written by:	Alexander Butovsky
 Version:	1.0
 Build:		012.000316
 Tested with:   Visual Prolog v.5.1 build 565
 Comments:	

******************************************************************************/
constants
  %*** Constant bellow switches argument validation on ***
  date_cc_argvalidation = 1

  date_cc_edit_id = 7373
  date_cc_edit_flags = [wsf_ReadOnly]

domains
  DATE_CC_FIELD = dccf(INTEGER Position,INTEGER CodeLength,STRING FieldCode)
  DATE_CC_FIELDLIST = DATE_CC_FIELD*

database - date_cc
  date_cc_info(WINDOW 		 DateCustomCtrlWin,
	       WINDOW 		 EditCtrlWin,
	       STRING 		 FormatStr,
	       DATE_CC_FIELDLIST FieldMap,
	       INTEGER		 FieldPointer,
	       INTEGER		 PositionInFieldPointer,
	       MINUT_OFFSET	 CurrentValue)
  determ date_cc_zero()
  date_ActualWin(WINDOW)

/**** global PREDICATE **********************************/
/*							*/
/* 	Date custom control initialization		*/
/*							*/
/*  Put date_cc_Init call into e_Create event clause	*/
/*  of the class handler				*/
/*							*/
/*  date_cc_Init(WINDOW,	% Control window	*/
/*		 MINUT_OFFSET,	% Init value		*/
/*		 STRING)	% Format string		*/
/*                                                      */
/* RETURN VALUE: none					*/
/* FAIL: Newer fails                                    */
/*                                                      */
/********************************************************/
predicates
  subclass_eh : EHANDLER
  determ  build_field_map(STRING FormatStr,UNSIGNED Pos,DATE_CC_FIELDLIST FieldMap)
  procedure  dcc_set_sel(WINDOW EdWin,DATE_CC_FIELDLIST FieldMap,INTEGER FieldPtr)

clauses
  date_cc_Init(Win,InitValue,FormatStr):-
	dt_minoffset_to_str(InitValue,FormatStr,StrInitValue),
	RCT = win_GetClientRect(Win),
	build_field_map(FormatStr,0,FieldMap),
	EdWin = win_CreateControl(wc_Edit,RCT,StrInitValue,Win,
				  date_cc_edit_flags,date_cc_edit_id),
	assert(date_cc_info(Win,EdWin,FormatStr,FieldMap,1,1,InitValue)),
	win_SetSubclassHandler(EdWin,subclass_eh,b_false),
	!.
  date_cc_Init(_,_,_):-
  	errorExit(error_vpi_package_bad_data).


/**** global PREDICATE **********************************/
/*							*/
/* 	Date custom control event handling		*/
/*							*/
/*  Put date_cc_HandleEvent call into the clause for all*/
/*  events (except for e_Create) of the class handler	*/
/*							*/
/*  date_cc_HandleEvent(WINDOW,	% Control window	*/
/*		 	EVENT)	% Event			*/
/*                                                      */
/* RETURN VALUE: none					*/
/* FAIL: Always fails                                   */
/*                                                      */
/********************************************************/

  date_cc_HandleEvent(Win,e_User(1000,1)):-
ifdef os_os2
	date_ActualWin(Win),
enddef
	date_cc_info(Win,EdWin,_,FieldMap,FieldPtr,_,_),!,
	trap(win_SetFocus(EdWin),_,fail),
	T=win_GetText(EdWin),
	win_SetText(EdWin,T),
	dcc_set_sel(EdWin,FieldMap,FieldPtr),
	trap(caret_Off(EdWin),_,fail),
	!.

  date_cc_HandleEvent(Win,e_GetFocus()):- % Set selection on GetFocus event
	retractAll(date_ActualWin(_)),
	assert(date_ActualWin(Win)),
	win_Postevent(Win,e_User(1000,1)),!.

  %---- E_Size ----
  date_cc_HandleEvent(Win,e_Size(_,_)):-
	date_cc_info(Win,EdWin,_,_,_,_,_),!,
	RCT = win_GetClientRect(Win),
	win_Move(EdWin,RCT),fail.

  %---- E_State ----	 
  date_cc_HandleEvent(Win,e_State(font(Font))):- % Set Font when win_SetFont is called
	date_cc_info(Win,EdWin,_,_,_,_,_),!,
	win_SetFont(EdWin,Font),
	caret_off(EdWin).
  date_cc_HandleEvent(Win,e_State(enabled())):-	 % Set ENABLED when win_SetState is called
	date_cc_info(Win,EdWin,_,_,_,_,_),!,
	win_SetState(EdWin,[wsf_Enabled]).
  date_cc_HandleEvent(Win,e_State(disabled())):- % Set DISABLED when win_SetState is called
	date_cc_info(Win,EdWin,_,_,_,_,_),!,
	win_SetState(EdWin,[wsf_Disabled]).
  date_cc_HandleEvent(Win,e_State(visible())):-  % Set VISIBLE when win_SetState is called
	date_cc_info(Win,EdWin,_,_,_,_,_),!,
	win_SetState(EdWin,[wsf_Visible]).
  date_cc_HandleEvent(Win,e_State(invisible())):-% Set INVISIBLE when win_SetState is called
	date_cc_info(Win,EdWin,_,_,_,_,_),!,
	win_SetState(EdWin,[wsf_Invisible]).

  %---- E_Destroy ----
  date_cc_HandleEvent(Win,e_Destroy()):-
	retractall(date_cc_info(Win,_,_,_,_,_,_)),fail.

/**** global PREDICATE **********************************/
/*							*/
/* 		Set Date custom control value		*/
/*							*/
/*  date_cc_SetValue(WINDOW,	    % Control window	*/
/*		     MINUT_OFFSET)  % Value		*/
/*                                                      */
/* NOTE: Moves the selection to the leftmost field      */
/* RETURN VALUE: none					*/
/* FAIL: Newer fails                                    */
/*                                                      */
/********************************************************/
  date_cc_SetValue(Win,Value):-
	retract(date_cc_info(Win,EdWin,FormatStr,FieldMap,_,_,_)),
	dt_minoffset_to_str(Value,FormatStr,StrValue),
	assert(date_cc_info(Win,EdWin,FormatStr,FieldMap,1,1,Value)),
	win_SetText(EdWin,StrValue),
	dcc_set_sel(EdWin,FieldMap,1),!.
  date_cc_SetValue(_,_):-
  	errorExit(error_vpi_package_bad_data).


/**** global PREDICATE **********************************/
/*							*/
/* 		Get Date custom control value		*/
/*							*/
/* MINUT_OFFSET date_cc_SetValue(WINDOW)% Control window*/
/*                                                      */
/* RETURN VALUE: Date control value in mins since 1/1-1	*/
/* FAIL: Newer fails                                    */
/*                                                      */
/********************************************************/
  date_cc_GetValue(Win,Value):-
	date_cc_info(Win,_,_,_,_,_,Value),!.
  date_cc_GetValue(_,0):-
  	errorExit(error_vpi_package_bad_data).


/*********************************************************
	EDIT CONTROL SUBCLASS EVENT HANDLER
*********************************************************/
predicates
  procedure STRING dcc_get_field_code(DATE_CC_FIELDLIST FieldMap,INTEGER FieldPtr)
  determ INTEGER dcc_get_field_pos(DATE_CC_FIELDLIST FieldMap,INTEGER FieldPtr,INTEGER CodeLength)
  determ dcc_numkey_handle(STRING FieldCode,INTEGER PosPtr0,INTEGER Input,INTEGER Y0,INTEGER M0,INTEGER D0,
		INTEGER H0,INTEGER Min0,INTEGER Y1,INTEGER M1,INTEGER D1,INTEGER H1,INTEGER Min1,
		INTEGER PosPtr1)
  determ dcc_arrowkey_handle(STRING FieldCode,INTEGER Key,INTEGER Y0,INTEGER M0,INTEGER D0,
		INTEGER H0,INTEGER Min0,INTEGER Y1,INTEGER M1,INTEGER D1,INTEGER H1,INTEGER Min1)
  procedure dcc_move_selection(WINDOW EdWin,DATE_CC_FIELDLIST FieldMap,INTEGER PosPtr,
			INTEGER OldFieldPtr,INTEGER NewFieldPtr)
  procedure dcc_listlength(DATE_CC_FIELDLIST FieldMap,INTEGER NumberOfFields)
  determ dcc_member(INTEGER,ILIST)
  determ difference(INTEGER,INTEGER)
  procedure dcc_add0(INTEGER Counter,STRING Input,STRING,STRING Output)
  procedure dcc_add01(STRING,STRING)
  determ dcc_CheckLegal(WINDOW EdWin,INTEGER Y1,INTEGER M1,INTEGER D1,INTEGER H1,INTEGER Min)
  procedure handle_year0001(INTEGER Year,INTEGER Month,INTEGER Day,INTEGER DayOut)

clauses
  handle_year0001(1,1,0,1):-!.	% if date = 00-01-0001 replace day with 1...
  handle_year0001(_,_,D,D).	%  othervise keep existing day

  dcc_add0(_C,Input,Output,Output):- str_len(Input,Len1),str_len(Output,Len2),Len1=Len2,!.
  dcc_add0(C1,Input,Output1,Out):-!,
	substring(Input,C1,1,Str_out1), 
	dcc_add01(Str_out1,Str_out2),
	concat(Output1,Str_out2,Output2),
	C2 = C1 + 1,
	dcc_add0(C2,Input,Output2,Out).
  
  dcc_add01(" ","0"):-!.
  dcc_add01(C,C):-!.

  dcc_CheckLegal(_EdWin,Y1,M1,D0,H1,Min1):-
	handle_year0001(Y1,M1,D0,D1),
	format(String1,"%4d-%2d-%2d-%2d-%2d",Y1,M1,D1,H1,Min1),
	dcc_add0(1,String1,"",String2),
	FormatString = "%YL-%MD-%DD-%HH-%MM",
	Y1 < 3000,
	Y1 > 0,
	dt_legal_date(String2,FormatString),
	!.
  dcc_CheckLegal(EdWin,_Y1,_M1,_D1,_H1,_Min1):-
	vpi_Alarm(mesbox_iconerror),
	retract(date_cc_info(Win,EdWin,FormatStr,FieldMap,FieldPtr1,_,Value1)),!,
	assert(date_cc_info(Win,EdWin,FormatStr,FieldMap,FieldPtr1,1,Value1)),
	fail.

predicates
  procedure MINUT_OFFSET check_limits(INTEGER Key,MINUT_OFFSET OldValue,MINUT_OFFSET NewValue)

clauses
  check_limits(k_down,Old,New,Old):-
	New > Old,!.
  check_limits(k_down,_,New,New):-!.

  check_limits(k_up,Old,New,Old):-
	New < Old,!.
  check_limits(_,_,New,New):-!.

  subclass_eh(EdWin,e_Char(Char,_SCA),0):-	% Numeric keys
	Char >= '0',
	Char <= '9',
	Inp = Char - 48,
	date_cc_info(Win,EdWin,FormatStr,FieldMap,FieldPtr0,PosPtr0,Value0),
	dt_offset_to_min(Value0,Y0,M0,_,D0,_,H0,Min0),
	FieldCode = dcc_get_field_code(FieldMap,FieldPtr0),
	dcc_numkey_handle(FieldCode,PosPtr0,Inp,Y0,M0,D0,H0,Min0,Y1,M1,D1,H1,Min1,PosPtr1),
	dt_min_to_offset(Y1,M1,D1,H1,Min1,Value1),
	dt_minoffset_to_str(Value1,FormatStr,StrValue),
	dcc_CheckLegal(EdWin,Y1,M1,D1,H1,Min1),
	win_SetText(EdWin,StrValue),
	dcc_move_selection(EdWin,FieldMap,PosPtr1,FieldPtr0,FieldPtr1),
	retract(date_cc_info(Win,EdWin,_,_,_,_,_)),!,
	assert(date_cc_info(Win,EdWin,FormatStr,FieldMap,FieldPtr1,PosPtr1,Value1))
	.

  subclass_eh(EdWin,e_Char(Key,_SCA),0):-	% Up and Down arrow keys
	dcc_member(Key,[k_up,k_down]),
	retract(date_cc_info(Win,EdWin,FormatStr,FieldMap,FieldPtr,_,Value0)),!,
	dt_offset_to_min(Value0,Y0,M0,_,D0,_,H0,Min0),
	FieldCode = dcc_get_field_code(FieldMap,FieldPtr),
	difference(Key,Diff),
	dcc_arrowkey_handle(FieldCode,Diff,Y0,M0,D0,H0,Min0,Y1,M1,D1,H1,Min1),
	dt_min_to_offset(Y1,M1,D1,H1,Min1,Value1),
	Value2 = check_limits(Key,Value0,Value1),
	dt_minoffset_to_str(Value2,FormatStr,StrValue),
	win_SetText(EdWin,StrValue),
	dcc_set_sel(EdWin,FieldMap,FieldPtr),
	assert(date_cc_info(Win,EdWin,FormatStr,FieldMap,FieldPtr,1,Value2))
	.

  subclass_eh(EdWin,e_Char(Key,_SCA),0):-	% Right and Left arrow keys
	dcc_member(Key,[k_right,k_left]),
	difference(Key,Diff),
	retract(date_cc_info(Win,EdWin,FormatStr,FieldMap,FieldPtr0,_,Value)),
	dcc_move_selection(EdWin,FieldMap,Diff,FieldPtr0,FieldPtr1),!,
	assert(date_cc_info(Win,EdWin,FormatStr,FieldMap,FieldPtr1,1,Value))
	.

  subclass_eh(EdWin,e_Char(Key,_SCA),0):-	% Home key, Ctrl-Home key
	dcc_member(Key,[k_lhome,k_home]),
	retract(date_cc_info(Win,EdWin,FormatStr,FieldMap,_,_,Value)),
	dcc_set_sel(EdWin,FieldMap,1),!,
	assert(date_cc_info(Win,EdWin,FormatStr,FieldMap,1,1,Value))
	.

  subclass_eh(EdWin,e_Char(Key,_SCA),0):-	% End key, Ctrl-End key
	dcc_member(Key,[k_lend,k_end]),
	retract(date_cc_info(Win,EdWin,FormatStr,FieldMap,_,_,Value)),
	dcc_listlength(FieldMap,LastPos),
	dcc_set_sel(EdWin,FieldMap,LastPos),!,
	assert(date_cc_info(Win,EdWin,FormatStr,FieldMap,LastPos,1,Value))
	.

  subclass_eh(EdWin,e_Char(Key,SCA),0):-
	date_cc_info(Win,EdWin,_,_,_,_,_),
	win_SendEvent(Win,e_Char(Key,SCA)),
	!,fail.
  subclass_eh(EdWin,e_KeyDown(Key,SCA),0):-	% Key events to avoid selection loss
	date_cc_info(Win,EdWin,_,_,_,_,_),
	win_SendEvent(Win,e_KeyDown(Key,SCA)),
	!.
  subclass_eh(EdWin,e_KeyUp(Key,SCA),0):-
	date_cc_info(Win,EdWin,_,_,_,_,_),
	win_SendEvent(Win,e_KeyUp(Key,SCA)),
	!.

  subclass_eh(EdWin,e_MouseDown(_,_,_),0):-	% Mouse event to avoid selection loss
	date_cc_info(Win,EdWin,_,_,_,_,_),!,
	win_Postevent(Win,e_User(1000,1)),fail.

  subclass_eh(EdWin,e_MouseUp(_,_,_),0):-
	date_cc_info(Win,EdWin,_,_,_,_,_),!,
	win_Postevent(Win,e_User(1000,1)),fail.

  subclass_eh(_EdWin,e_MouseDbl(_,_,_),0):-!.


/******* Set/Move selection in the date custom control ******/
  dcc_set_sel(EdWin,FieldMap,FieldPtr):-
	FieldPos = dcc_get_field_pos(FieldMap,FieldPtr,CodeLen),!, % fails if pos doesn't exists
	First = FieldPos - 1,
	Last = First + CodeLen,
	win_SelectText(EdWin,First,Last),
	caret_off(EdWin),
	!.			% remove caret
  dcc_set_sel(_,_,_):-!.

  dcc_move_selection(EdWin,FieldMap,1,FieldPtr0,FieldPtr1):-
	dcc_listlength(FieldMap,LastPos),
	FieldPtr1 = FieldPtr0 + 1,		 % select next field
	FieldPtr1 <= LastPos,
	dcc_set_sel(EdWin,FieldMap,FieldPtr1),!.
  dcc_move_selection(EdWin,FieldMap,-1,FieldPtr0,FieldPtr1):-
	FieldPtr0 > 1,
	FieldPtr1 = FieldPtr0 - 1,		 % select previous field
	dcc_set_sel(EdWin,FieldMap,FieldPtr1),!.
  dcc_move_selection(EdWin,FieldMap,_,FieldPtr,FieldPtr):-
	dcc_set_sel(EdWin,FieldMap,FieldPtr),!.  % select current field

/************* Build field map *************/
predicates
  determ check_fieldcode(STRING FieldCode)
  procedure get_CodeLength(STRING Code,INTEGER Lenght)

clauses
  build_field_map(FormatStr,Current,[dccf(RealPos,CodeLen,FieldCode)|FieldMap]):-
	% Remove first N symbols from FormatStr
	% Move pointer Return position in formatted date Extract FieldCode
	searchchar(FormatStr,'%',Pos),!,
	N = Pos + 2,			
	frontstr(N,FormatStr,_,RestStr),
	CodePos = Pos + 1,
	substring(FormatStr,CodePos,2,FieldCode),
ifdef date_cc_argvalidation
	check_fieldcode(FieldCode),
enddef
	get_CodeLength(FieldCode,CodeLen),
	RealPos = Current + Pos,
	Next = Current + Pos + CodeLen - 1,
	build_field_map(RestStr,Next,FieldMap).
  build_field_map(_,_,[]).

  get_CodeLength("DD",2):-!.
  get_CodeLength("MD",2):-!.
  get_CodeLength("YS",2):-!.
  get_CodeLength("HH",2):-!.
  get_CodeLength("MM",2):-!.
  get_CodeLength("YL",4):-!.
  get_CodeLength(_,0):-errorexit().

  % *** Format string validation ***
  check_fieldcode("DD"):-!.
  check_fieldcode("MD"):-!.
  check_fieldcode("YS"):-!.
  check_fieldcode("HH"):-!.
  check_fieldcode("MM"):-!.
  check_fieldcode("YL"):-!.
  check_fieldcode(IllegalCode):-
	format(Msg,"Illegal field code in Date custom control format string - '%'",IllegalCode),
	dlg_note(Msg),
	errorexit().

/************* Get entry from the field map *************/
  dcc_get_field_code([dccf(_,_,FieldCode)|_],1,FieldCode):-!.
  dcc_get_field_code([_|Rest],FieldPtr,FieldCode):-
	FieldPtr1 = FieldPtr - 1,
	FieldCode = dcc_get_field_code(Rest,FieldPtr1),!.
  dcc_get_field_code(_,_,""):-errorexit().

  dcc_get_field_pos([dccf(FieldPos,CodeLen,_)|_],1,CodeLen,FieldPos):-!.
  dcc_get_field_pos([_|Rest],FieldPtr,CodeLen,FieldPos):-
	FieldPtr1 = FieldPtr - 1,
	FieldPos = dcc_get_field_pos(Rest,FieldPtr1,CodeLen),!.

/************** Keyboard input handling ******************/
  % ---> DAY
  dcc_numkey_handle("DD",1,0,Y,M,D,H,Min,Y,M,D,H,Min,2):-!,	% First key is '0'
	retractall(date_cc_zero()),
	assert(date_cc_zero()).
  dcc_numkey_handle("DD",1,Inp,Y,M,_,H,Min,Y,M,Inp,H,Min,2):-!.
  dcc_numkey_handle("DD",2,Inp,Y,M,_,H,Min,Y,M,Inp,H,Min,1):-	% First key was '0'
	retract(date_cc_zero()),!.
  dcc_numkey_handle("DD",2,Inp,Y,M,D,H,Min,Y,M,Out,H,Min,1):-!,
	Out = D * 10 + Inp.
  % ---> MONTH
  dcc_numkey_handle("MD",1,0,Y,M,D,H,Min,Y,M,D,H,Min,2):-!,	% First key is '0'
	retractall(date_cc_zero()),
	assert(date_cc_zero()).
  dcc_numkey_handle("MD",1,Inp,Y,_,D,H,Min,Y,Inp,D,H,Min,2):-!.
  dcc_numkey_handle("MD",2,Inp,Y,_,D,H,Min,Y,Inp,D,H,Min,1):-	% First key was '0'
	retract(date_cc_zero()),!.
  dcc_numkey_handle("MD",2,Inp,Y,M,D,H,Min,Y,Out,D,H,Min,1):-!,
	Out = M * 10 + Inp.
  % ---> YEAR Short
  dcc_numkey_handle("YS",1,Inp,_,M,D,H,Min,Out,M,D,H,Min,2):-!,
	Out = 2000 + Inp.
  dcc_numkey_handle("YS",2,Inp,Y,M,D,H,Min,Out,M,D,H,Min,1):-
	A = Y mod 10,
	A < 2,!,
	Out = 2000 + A * 10 + Inp.
  dcc_numkey_handle("YS",2,Inp,Y,M,D,H,Min,Out,M,D,H,Min,1):-
	Out = 1900 + (Y mod 10) * 10 + Inp.

  % ---> YEAR Long
  dcc_numkey_handle("YL",1,0,Y,M,D,H,Min,Y,M,D,H,Min,2):- % Inset 0
	retractall(date_cc_zero()),
	assert(date_cc_zero()),!.
  dcc_numkey_handle("YL",2,0,Y,M,D,H,Min,Y,M,D,H,Min,3):-date_cc_zero(),!.
  dcc_numkey_handle("YL",3,0,Y,M,D,H,Min,Y,M,D,H,Min,4):-date_cc_zero(),!.

  dcc_numkey_handle("YL",2,Inp,_Y,M,D,H,Min,Inp,M,D,H,Min,3):- % Insert not 0 , but previous is 0
	retract(date_cc_zero()),
	!.
  dcc_numkey_handle("YL",3,Inp,_Y,M,D,H,Min,Inp,M,D,H,Min,4):-
	retract(date_cc_zero()),
	!.
  dcc_numkey_handle("YL",4,Inp,_Y,M,D,H,Min,Inp,M,D,H,Min,1):-
	retract(date_cc_zero()),
	!.
  dcc_numkey_handle("YL",1,Inp,_,M,D,H,Min,Inp,M,D,H,Min,2):-!.
  dcc_numkey_handle("YL",2,Inp,Y,M,D,H,Min,Out,M,D,H,Min,3):-Out = Y * 10 + Inp,!.
  dcc_numkey_handle("YL",3,Inp,Y,M,D,H,Min,Out,M,D,H,Min,4):-Out = Y * 10 + Inp,!.
  dcc_numkey_handle("YL",4,Inp,Y,M,D,H,Min,Out,M,D,H,Min,1):-Out = Y * 10 + Inp,!.

  % ---> HOUR
  dcc_numkey_handle("HH",1,Inp,Y,M,D,_,Min,Y,M,D,Inp,Min,2):-!.
  dcc_numkey_handle("HH",2,Inp,Y,M,D,H,Min,Y,M,D,Out,Min,1):-!,
	Out = H * 10 + Inp.
  % ---> MIN
  dcc_numkey_handle("MM",1,Inp,Y,M,D,H,_,Y,M,D,H,Inp,2):-!.
  dcc_numkey_handle("MM",2,Inp,Y,M,D,H,Min,Y,M,D,H,Out,1):-!,
	Out = Min * 10 + Inp.

  dcc_arrowkey_handle("DD",Diff,Y,M,D0,H,Min,Y,M,D1,H,Min):-!,
	D1 = D0 + Diff.
  dcc_arrowkey_handle("MD",Diff,Y,M0,D,H,Min,Y,M1,D,H,Min):-!,
	M1 = M0 + Diff.
  dcc_arrowkey_handle("YS",Diff,Y0,M,D,H,Min,Y1,M,D,H,Min):-!,
	Y1 = Y0 + Diff.
  dcc_arrowkey_handle("YL",Diff,Y0,M,D,H,Min,Y1,M,D,H,Min):-!,
	Y1 = Y0 + Diff.
  dcc_arrowkey_handle("HH",Diff,Y,M,D,H0,Min,Y,M,D,H1,Min):-!,
	H1 = H0 + Diff.
  dcc_arrowkey_handle("MM",Diff,Y,M,D,H,Min0,Y,M,D,H,Min1):-!,
	Min1 = Min0 + Diff.

  %-- small useful predicates ---
  dcc_listlength([],0):-!.
  dcc_listlength([_|T],N1):-
	dcc_listlength(T,N),
	N1=N+1,!.
  dcc_listlength(_,0):-errorexit().

  dcc_member(X,[X|_]):-!.
  dcc_member(X,[_|Rest]):-!,
	dcc_member(X,Rest).

  difference(k_up,1):-!.
  difference(k_down,-1):-!.
  difference(k_right,1):-!.
  difference(k_left,-1):-!.
