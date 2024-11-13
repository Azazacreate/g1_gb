/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  TABTEST
 FileName: TABTEST.PRO
 Purpose: Example for Table editor tool
 Written by: Andrey Skobelev
 Comments:
******************************************************************************/

include "tabtest.inc"
include "tabtest.con"
include "hlptopic.con"
include "tableed.pre"

constants
  tableed_class 	= "tableed_class"	% User defined name for the class
  tableed_id 		= 3278			% Control Id for tableed control created in window
  change_pictureevent	= 1808			% user change picture in Table editor

  size_of_buffer	= 16			% Size of internal data storage in rows
  initial_max_rows	= 40			% Max number of rows
  

database - tableedit_db
  test_Info(WINDOW)
  buffmode()
  buffData(TABLEEDIT_DATA)
  pictures(WINDOW,TABLEEDIT_CELLDATA PictureData)
  changepicture(WINDOW,INTEGER Row,INTEGER Column,TABLEEDIT_CELLDATA NewData)
  
predicates
  tab_Callback : TABLEEDIT_CALLBACK 
determ  test_member(TABLEEDIT_PROPERTY,TABLEEDIT_PROPERTIES)
determ  test_member(TABLEEDIT_COLUMNPROPERTY,TABLEEDIT_COLUMNPROPERTIES)
determ  setDataToDatabase(INTEGER Row,INTEGER Column,TABLEEDIT_CELLDATA CellData)
determ  getDataFromDatabase(INTEGER FrRow,INTEGER ToRow,TABLEEDIT_DATA OutData)
determ  insertRowsToDatabase(INTEGER Row,TABLEEDIT_DATA Data)
determ  deleteRowFromDatabase(INTEGER Row)
determ  handle_ModifiedForPicture(WINDOW,TABLEEDIT_EVENT)

clauses
  tab_Callback(_Win,Event):- nl,write(" CALLBACK: ",Event),fail. % Write event
  tab_Callback(_Win,Event):-
	Event = modified(_Row,Column,_OldValue,NewValue), 
	Column = 3, % Column 3 - data
	NewValue = s(DateString),
	DateForamatString = "%DD-%MD-%YS",
	% if DateString is not valid for date format (modified by paste operation),
	% then forbid cell modification
	not(dt_legal_date(DateString,DateForamatString)),
	!.
  tab_Callback(Win,Event):-
	handle_ModifiedForPicture(Win,Event),
	!.
  tab_Callback(_Win,Event):-
	buffmode(),
	Event = modified(Row,Column,_OldValue,NewValue),
	not(Column = 4),!,
	setDataToDatabase(Row,Column,NewValue),!,
	fail.
  tab_Callback(Win,Event):-
	buffmode(),
	Event = insert_row(Row,InsData), Data = [InsData],!,
	insertRowsToDatabase(Row,Data),
	MaxRows = tableedit_MaxRows(Win),
	NewMaxRows = MaxRows + 1,
	tableedit_Buff_SetMaxRows(Win,NewMaxRows),
	fail.
  tab_Callback(Win,Event):-
	buffmode(),
	Event = delete_row(Row,_DelData),!,
	deleteRowFromDatabase(Row),
	MaxRows = tableedit_MaxRows(Win),
	NewMaxRows = MaxRows - 1,
	tableedit_Buff_SetMaxRows(Win,NewMaxRows),
	fail.
  tab_Callback(_Win,Event):-
	buffmode(),
	Event =  copy(FromRow,ToRow,_FromColumn,_ToColumn),
	RowLimit = 300,
	ToRow - FromRow > RowLimit,
	dlg_Note("Area too large for copying"),
	!.
  tab_Callback(_Win,Event):-
	buffmode(),
	Event =  paste(FromRow,ToRow,_FromColumn,_ToColumn),
	RowLimit = 300,
	ToRow - FromRow > RowLimit,
	dlg_Note("Area too large for pasting"),
	!.
  tab_Callback(_Win,Event):-
	buffmode(),
	Event =  cut(FromRow,ToRow,_FromColumn,_ToColumn),
	RowLimit = 300,
	ToRow - FromRow > RowLimit,
	dlg_Note("Area too large for cutting"),
	!.
predicates
  assert_BuffDatabase()
  tableed_class_handler : EHANDLER	% Table editor custom control EVENT HANDLER
  compareFunc : TABLEEDIT_COMPARE
  buffAnswer : TABLEEDIT_ANSWERDATA_FUNC
  convertdata(TABLEEDIT_CELLDATA,STRING)
determ  set_PictureToTableed(WINDOW)
  assert_PictureDataBase(WINDOW)
clauses
% Data Request for table editor in buffering mode
  buffAnswer(_Win,FromRow,ToRow,Data):-
	write("\nData request FromRow=",FromRow," ToRow=",ToRow),
	getDataFromDatabase(FromRow,ToRow,Data),
	!.

  convertdata(s(Str),Str):-!.
  convertdata(sc(Str,_),Str):-!.
  convertdata(_,""):-!.

% Remove comment mark in line bellow to see how sorting algorithm works:
%  compareFunc(_,_,First,Second,equal):- write("\n COMPARE: ",First," ? ",Second),fail.
  compareFunc(_,3,First,Second,equal):-
	convertdata(First,Str1),
	convertdata(Second,Str2),
	Str1 = Str2,!.
  compareFunc(_,3,First,Second,less):-
	convertdata(First,Str1),
	convertdata(Second,Str2),
	dt_minstr_to_offset(Str1,"%DD-%MD-%YS",Offset1),
	dt_minstr_to_offset(Str2,"%DD-%MD-%YS",Offset2),
	Offset1 < Offset2,!.
  compareFunc(_,3,_,_,more).

/*******************************************************************
	Table Editor class event Handler
*******************************************************************/
  tableed_class_handler(GridWin,e_Create(_),0):-% CALL tableedit_Init on e_Create EVENT
	not(buffmode()),!,
	assert(test_Info(GridWin)),
	assert_PictureDataBase(GridWin),
 	tableedit_Init(GridWin,[callback(tab_Callback),compare(compareFunc)],
 		[column([title("Real Data"),column_type(te_real),validationtext("VText... Value: %")]),
 		 column([title("String Data")]),
 		 column([title("Date"),control(custom("date",[],date_put_string,date_get_string)),
		 	alignment(grid_left_align)]),
 		 column([title("Picture"),column_type(te_picture),
 		 	control(listbutton(["Copy Down","Copy Up","Cut Down","Cut Up"])),
 		 	alignment(grid_left_align)])
		],
		[ 
		  [r(1.0),s("1s"),sc("10-04-97",255),p(fromres(idb_copy_dn),b_false,"Copy Down")],
		  [r(2.0),s("2s"),sc("11-04-97",255),p(fromres(idb_copy_up),b_false,"Copy Up")],
		  [r(3.0),s("3s"),sc("12-04-97",255),p(fromres(idb_cut_dn),b_false,"Cut Down")],
		  [r(4.0),s("4s"),sc("13-04-97",255),p(fromres(idb_cut_up),b_false,"Cut Up")],
		  [r(5.0),s("5s"),sc("14-04-97",255),p(fromres(idb_copy_dn),b_false,"Copy Down")],
		  [r(6.0),s("6s"),void,void],
		  [r(7.0),s("7s"),void,void]
		]
	),fail.
  tableed_class_handler(GridWin,e_Create(_),0):-% CALL tableedit_Init on e_Create EVENT
	buffmode(),!,
	assert_BuffDatabase(),
	assert(test_Info(GridWin)), 
	assert_PictureDataBase(GridWin),
	Buff = size_of_buffer, 
	MaxRows = initial_max_rows,
 	tableedit_Init(GridWin,[callback(tab_Callback),undo_redo(b_false),
 		bufferingmode(buffering(buffAnswer,Buff,MaxRows))],
 		[column([title("Real Data"),column_type(te_real),validationtext("VText... Value: %")]),
 		 column([title("String Data")]),
 		 column([title("Date"),control(custom("date",[],date_put_string,date_get_string)),
		 	alignment(grid_left_align)]),
 		 column([title("Picture"),column_type(te_picture),
 		 	control(listbutton(["Copy Down","Copy Up","Cut Down","Cut Up"])),
 		 	alignment(grid_left_align)])
		],
		[]
	),
	fail.

  tableed_class_handler(Win,e_User(change_pictureevent,0),0):-
	% Set new picture
	set_PictureToTableed(Win),
	!.
  tableed_class_handler(GridWin,e_Destroy(),0):-!,
	retractAll(pictures(GridWin,p(fromres(idb_cut_up),b_false,"Cut Up"))),
	retract(test_Info(GridWin)),
	fail.

  tableed_class_handler(Win,EVENT,0):-		% CALL propedit_HandleEvent
	tableedit_HandleEvent(Win,Event),!.	% ON ANY OTHER EVENT

  assert_PictureDataBase(Win):-
	assert(pictures(Win,p(fromres(idb_copy_dn),b_false,"Copy Down"))), % assert pictures
	assert(pictures(Win,p(fromres(idb_copy_up),b_false,"Copy Up"))),
	assert(pictures(Win,p(fromres(idb_cut_dn),b_false,"Cut Down"))),
	assert(pictures(Win,p(fromres(idb_cut_up),b_false,"Cut Up"))),
	!.

  handle_ModifiedForPicture(Win,Event):-
	not(buffmode()),
	% Picture changed
	Event = modified(Row,Column,_OldValue,NewValue), 
	Column = 4, % te_picture type
	NewValue = p(_,_,PictureNameId),
	% The picture is found in a database
	pictures(Win,p(_Pic,_S,PictureNameId)),!,
	% assert NewValue and send win_PostEvent(...) for set new value
	assert(changepicture(Win,Row,Column,NewValue)),
	win_PostEvent(Win,e_User(change_pictureevent,0)),
	!,fail.
  handle_ModifiedForPicture(Win,Event):-
	not(buffmode()),
	% Picture changed
	Event = modified(Row,Column,_OldValue,void),
	Column = 4, % te_picture type
	% assert NewValue (void - no picture)and send win_PostEvent(...) for set new value (void)
	assert(changepicture(Win,Row,Column,void)),!,
	win_PostEvent(Win,e_User(change_pictureevent,0)),
	!,fail.

% Buffering Mode
  handle_ModifiedForPicture(Win,Event):-
	buffmode(),
	% Picture changed
	Event = modified(Row,Column,_OldValue,NewValue), 
	Column = 4, % te_picture type
	NewValue = p(_,_,PictureNameId),
	% The picture is found in a database
	pictures(Win,p(Pic,S,PictureNameId)),!,
	% set NewValue to external database
	NewValue1 = p(Pic,S,PictureNameId),
	setDataToDatabase(Row,Column,NewValue1),!,
	fail.
  handle_ModifiedForPicture(_Win,Event):-
	buffmode(),
	% Picture changed
	Event = modified(Row,Column,_OldValue,void),
	Column = 4, % te_picture type
	% Set NewValue (void - no picture) to external database
	setDataToDatabase(Row,Column,void),!,
	fail.

  set_PictureToTableed(Win):-
	% handle modified(...) callback if picture changed
	% get New PictureNameId
	changepicture(Win,Row,Column,NewValue),
	NewValue = p(_,_,PictureNameId),
	% get picture from database with PictureNameId
	pictures(Win,p(Pic,S,PictureNameId)),
	retract(changepicture(Win,Row,Column,NewValue)),!,
	NewValue1 = p(Pic,S,PictureNameId),
	% Set new picture to Table Editor, according to PictureNameId
	tableedit_SetCellData(Win,Row,Column,NewValue1),
	!.
  set_PictureToTableed(Win):-
	retract(changepicture(Win,Row,Column,void)),
	tableedit_SetCellData(Win,Row,Column,void),
	!.


predicates
  date_handler : EHANDLER		% Predi

clauses
  date_handler(Win,e_Create(_),0):-
	date_cc_Init(Win,0,"%DD-%MD-%YS"),!.
  date_handler(Win,EVENT,0):-
	date_cc_HandleEvent(Win,EVENT),!.

predicates
  date_put_string  : GRID_PUT_CUSTOM_DATA

clauses
  date_put_string(Win,""):-
	trap(date_cc_SetValue(Win,0),_,fail),!.
  date_put_string(Win,String):-
	trap(dt_minstr_to_offset(String,"%DD-%MD-%YS",InitDate),_,fail),
	trap(date_cc_SetValue(Win,InitDate),_,fail),!.
  date_put_string(_Win,_):-!.

predicates
  date_get_string  : GRID_GET_CUSTOM_DATA

clauses
  date_get_string(Win,""):-
	Date = date_cc_GetValue(Win),
	Date = 0,!.
  date_get_string(Win,String):-
	Date = date_cc_GetValue(Win),
	dt_minoffset_to_str(Date,"%DD-%MD-%YS",String),!.
  date_get_string(_Win,""):-!.


predicates
/**************************************************************************
	Clauses for set/get Properties to/from test dialog.
**************************************************************************/
predicates
determ  test_ConvBoolean(BOOLEAN,INTEGER,SLIST)
  test_SetBoolean(WINDOW DlgWin,INTEGER IDC,BOOLEAN)
determ  test_ConvColor(INTEGER Sel,STRING ColorName,COLOR)
  test_GetColorText(SLIST)
  test_SetColor(WINDOW DlgWin,INTEGER IDC,COLOR)
determ  test_ConvGridRowSelector(GRID_ROW_SELECTOR,INTEGER Sel,SLIST)
determ  test_ConvWidthRowSelector(INTEGER Width,INTEGER Sel,SLIST)
  test_SetRowSel(WINDOW DlgWin,INTEGER IDC1,INTEGER IDC2,INTEGER IDC3,TABLEEDIT_PROPERTIES)
  test_SetInt_0(WINDOW DlgWin,INTEGER IDC,INTEGER)
  test_SetInt_1(WINDOW DlgWin,INTEGER IDC,INTEGER)
determ  test_ConvColRowMarker(TABLEEDIT_MARKERMODE,INTEGER Sel,SLIST)
  test_SetColRowMarker(WINDOW DlgWin,INTEGER IDC,TABLEEDIT_MARKERMODE)

  test_SetWidth(WINDOW DlgWin,INTEGER IDC,TABLEEDIT_COLUMNPROPERTIES)
determ  test_ConvHAlignment(GRID_HORALIGNMENT,INTEGER Sel,SLIST)
  test_SetHAlignment(WINDOW DlgWin,INTEGER IDC,TABLEEDIT_COLUMNPROPERTIES)
determ  test_ConvSortMode(TABLEEDIT_SORTMODE,INTEGER Sel,SLIST)
  test_SetSortMode(WINDOW DlgWin,INTEGER IDC,TABLEEDIT_COLUMNPROPERTIES)
determ  test_ConvDefRealVal(TABLEEDIT_CELLDATA,INTEGER Sel,SLIST)
determ  test_ConvDefString(TABLEEDIT_CELLDATA,INTEGER Sel,SLIST)
  test_SetDefVal(WINDOW DlgWin,INTEGER IDC,TABLEEDIT_COLUMNPROPERTIES)
determ  test_ConvRealRule(TABLEEDIT_RULELIST,INTEGER Sel,SLIST)
determ  test_ConvStrRule(TABLEEDIT_RULELIST,INTEGER Sel,SLIST)
  test_SetRule(WINDOW DlgWin,INTEGER IDC,TABLEEDIT_COLUMNPROPERTIES)
determ  test_ConvRealFilterToDialog(TABLEEDIT_ORFILTERLIST,INTEGER)
determ  test_ConvStringFilterToDialog(TABLEEDIT_ORFILTERLIST,INTEGER)
determ  test_SetFilterList(WINDOW DlgWin,INTEGER IDC,TABLEEDIT_COLUMNPROPERTIES)
determ  test_ConvControlR(TABLEEDIT_CONTROL_TYPE,INTEGER Sel,SLIST)
determ  test_ConvControlS(TABLEEDIT_CONTROL_TYPE,INTEGER Sel,SLIST)
  test_SetControl(WINDOW DlgWin,INTEGER IDC,TABLEEDIT_COLUMNPROPERTIES)

clauses
  test_member(S,[S|_]):-!.
  test_member(S,[_|L]):-
	test_member(S,L).

  test_SetControl(DlgWin,IDC,ColProp):-
	test_member(column_type(te_real),ColProp),
	test_member(control(C),ColProp),
	CtrlWin = win_GetCtlHandle(DlgWin,IDC),
	test_ConvControlR(C,Sel,TitleList),
	lbox_Add(CtrlWin,TitleList),
	lbox_SetSel(CtrlWin,Sel,b_true),
	!.
  test_SetControl(DlgWin,IDC,ColProp):-
	test_member(column_type(te_string),ColProp),
	test_member(control(C),ColProp),
	CtrlWin = win_GetCtlHandle(DlgWin,IDC),
	test_ConvControlS(C,Sel,TitleList),
	lbox_Add(CtrlWin,TitleList),
	lbox_SetSel(CtrlWin,Sel,b_true),
	!.
  test_SetControl(_,_,_).
  
  test_ConvControlR(edit,0,["edit","listbutton(..)","listedit(..)"]):-!.
  test_ConvControlR(listbutton(["1","2","3","4","5","6","7"]),1,["edit","listbutton(..)","listedit(..)"]):-!.
  test_ConvControlR(listedit(["1","2","3","4","5","6","7"]),2,["edit","listbutton(..)","listedit(..)"]):-!.

  test_ConvControlS(edit,0,["edit","listbutton(..)","listedit(..)"]):-!.
  test_ConvControlS(listbutton(["1s","2s","3s","4s","5s","6s","7s"]),1,["edit","listbutton(..)","listedit(..)"]):-!.
  test_ConvControlS(listedit(["1s","2s","3s","4s","5s","6s","7s"]),2,["edit","listbutton(..)","listedit(..)"]):-!.

  test_ConvRealRule([],0,["[]","[r_min(5)]","[r_max(5)]"]):-!.
  test_ConvRealRule([r_min(5.0)],1,["[]","[r_min(5)]","[r_max(5)]"]):-!.
  test_ConvRealRule([r_max(5.0)],2,["[]","[r_min(5)]","[r_max(5)]"]):-!.

  test_ConvStrRule([],0,["[]","[s_length(2)]","[s_min(1)]","[s_max(2)]","[s_upper]","[s_lower]"]):-!.
  test_ConvStrRule([s_length(2)],1,["[]","[s_length(2)]","[s_min(1)]","[s_max(2)]","[s_upper]","[s_lower]"]):-!.
  test_ConvStrRule([s_min(1)],2,["[]","[s_length(2)]","[s_min(1)]","[s_max(2)]","[s_upper]","[s_lower]"]):-!.
  test_ConvStrRule([s_max(2)],3,["[]","[s_length(2)]","[s_min(1)]","[s_max(2)]","[s_upper]","[s_lower]"]):-!.
  test_ConvStrRule([s_upper],4,["[]","[s_length(2)]","[s_min(1)]","[s_max(2)]","[s_upper]","[s_lower]"]):-!.
  test_ConvStrRule([s_lower],5,["[]","[s_length(2)]","[s_min(1)]","[s_max(2)]","[s_upper]","[s_lower]"]):-!.

  test_SetRule(DlgWin,IDC,ColProp):-
	test_member(column_type(te_real),ColProp),
	test_member(validationrule(VR),ColProp),
	CtrlWin = win_GetCtlHandle(DlgWin,IDC),
	test_ConvRealRule(VR,Sel,TitleList),
	lbox_Add(CtrlWin,TitleList),
	lbox_SetSel(CtrlWin,Sel,b_true),
	!.
  test_SetRule(DlgWin,IDC,ColProp):-
	test_member(column_type(te_string),ColProp),
	test_member(validationrule(VR),ColProp),
	CtrlWin = win_GetCtlHandle(DlgWin,IDC),
	test_ConvStrRule(VR,Sel,TitleList),
	lbox_Add(CtrlWin,TitleList),
	lbox_SetSel(CtrlWin,Sel,b_true),
	!.
  test_SetRule(_,_,_).


  test_ConvDefRealVal(void,0,["void","voidc(100)","r(5.0)","rc(5.0,100)"]):-!.
  test_ConvDefRealVal(voidc(100),1,["void","voidc(100)","r(5.0)","rc(5.0,100)"]):-!.
  test_ConvDefRealVal(r(5.0),2,["void","voidc(100)","r(5.0)","rc(5.0,100)"]):-!.
  test_ConvDefRealVal(rc(5.0,100),3,["void","voidc(100)","r(5.0)","rc(5.0,100)"]):-!.

  test_ConvDefString(void,0,["void","voidc(100)","s(DefStr)","sc(DefStr,100)"]):-!.
  test_ConvDefString(voidc(100),1,["void","voidc(100)","s(DefStr)","sc(DefStr,100)"]):-!.
  test_ConvDefString(s("DefStr"),2,["void","voidc(100)","s(DefStr)","sc(DefStr,100)"]):-!.
  test_ConvDefString(sc("DefStr",100),3,["void","voidc(100)","s(DefStr)","sc(DefStr,100)"]):-!.
  
  test_SetDefVal(DlgWin,IDC,ColProp):-
	test_member(column_type(te_real),ColProp),
	test_member(defaultvalue(DFV),ColProp),
	CtrlWin = win_GetCtlHandle(DlgWin,IDC),
	test_ConvDefRealVal(DFV,Sel,TitleList),
	lbox_Add(CtrlWin,TitleList),
	lbox_SetSel(CtrlWin,Sel,b_true),
	!.
  test_SetDefVal(DlgWin,IDC,ColProp):-
	test_member(column_type(te_string),ColProp),
	test_member(defaultvalue(DFV),ColProp),
	CtrlWin = win_GetCtlHandle(DlgWin,IDC),
	test_ConvDefString(DFV,Sel,TitleList),
	lbox_Add(CtrlWin,TitleList),
	lbox_SetSel(CtrlWin,Sel,b_true),
	!.
  test_SetDefVal(_,_,_).

  test_ConvSortMode(ascending([]),0,["ascending([])","descending([])","none"]):-!.
  test_ConvSortMode(descending([]),1,["ascending([])","descending([])","none"]):-!.
  test_ConvSortMode(none,2,["ascending([])","descending([])","none"]):-!.

  test_SetSortMode(DlgWin,IDC,ColProp):-
	test_member(sortmode(S),ColProp),
	CtrlWin = win_GetCtlHandle(DlgWin,IDC),
	test_ConvSortMode(S,Sel,TitleList),
	lbox_Add(CtrlWin,TitleList),
	lbox_SetSel(CtrlWin,Sel,b_true),
	!.
  test_SetSortMode(_,_,_).

  test_ConvHAlignment(grid_left_align,0,["grid_left_align","grid_right_align","grid_center"]):-!.
  test_ConvHAlignment(grid_right_align,1,["grid_left_align","grid_right_align","grid_center"]):-!.
  test_ConvHAlignment(grid_center,2,["grid_left_align","grid_right_align","grid_center"]):-!.

  test_SetHAlignment(DlgWin,IDC,ColProp):-
	test_member(alignment(A),ColProp),
	CtrlWin = win_GetCtlHandle(DlgWin,IDC),
	test_ConvHAlignment(A,Sel,TitleList),
	lbox_Add(CtrlWin,TitleList),
	lbox_SetSel(CtrlWin,Sel,b_true),
	!.
  test_SetHAlignment(_,_,_).

  test_SetWidth(DlgWin,IDC,ColProp):-
	test_member(width(W),ColProp),
	CtrlWin = win_GetCtlHandle(DlgWin,IDC),
	lbox_Add(CtrlWin,["40","60","80","100","120","140","160"]),
	str_int(T,W),
	win_SetText(CtrlWin,T),
	!.
  test_SetWidth(_,_,_).

  test_SetFilterList(DlgWin,IDC,ColProp):-
	test_member(column_type(te_real),ColProp),
	test_member(filterlist(FilterList),ColProp),
	test_ConvRealFilterToDialog(FilterList,Sel),
	CtrlWin = win_GetCtlHandle(DlgWin,IDC),
	lbox_Add(CtrlWin,["[]","[rf_range(3,4)]","[rf_min(4.0)]","[rf_max(3.0)]","[rf_not(3.0)]","[fvoid]","[fvoid_not]"]),
	lbox_SetSel(CtrlWin,Sel,b_true),!.
  test_SetFilterList(DlgWin,IDC,ColProp):-
	test_member(column_type(te_real),ColProp),
	CtrlWin = win_GetCtlHandle(DlgWin,IDC),
	lbox_Add(CtrlWin,["[]","[rf_range(3,4)]","[rf_min(4.0)]","[rf_max(3.0)]","[rf_not(3.0)]","[fvoid]","[fvoid_not]"]),
	lbox_SetSel(CtrlWin,0,b_false),!.
  test_SetFilterList(DlgWin,IDC,ColProp):-
	test_member(column_type(te_string),ColProp),
	test_member(filterlist(FilterList),ColProp),
	test_ConvStringFilterToDialog(FilterList,Sel),
	CtrlWin = win_GetCtlHandle(DlgWin,IDC),
	lbox_Add(CtrlWin,["[]","[s_f(5s)]","[s_f_not(5s)]","[fvoid]","[fvoid_not]"]),
	lbox_SetSel(CtrlWin,Sel,b_true),!.
  test_SetFilterList(DlgWin,IDC,ColProp):-
	test_member(column_type(te_string),ColProp),
	CtrlWin = win_GetCtlHandle(DlgWin,IDC),
	lbox_Add(CtrlWin,["[]","[s_f(5s)]","[s_f_not(5s)]","[fvoid]","[fvoid_not]"]),
	lbox_SetSel(CtrlWin,0,b_false),!.

  test_ConvRealFilterToDialog([],0):-!.
  test_ConvRealFilterToDialog([rf_range(3.0,4.0)],1):-!.
  test_ConvRealFilterToDialog([rf_min(4.0)],2):-!.
  test_ConvRealFilterToDialog([rf_max(3.0)],3):-!.
  test_ConvRealFilterToDialog([rf_not(3.0)],4):-!.
  test_ConvRealFilterToDialog([fvoid],5):-!.
  test_ConvRealFilterToDialog([fvoid_not],6):-!.

  test_ConvStringFilterToDialog([],0):-!.
  test_ConvStringFilterToDialog([s_f("5s")],1):-!.
  test_ConvStringFilterToDialog([s_f_not("5s")],2):-!.
  test_ConvStringFilterToDialog([fvoid],3):-!.
  test_ConvStringFilterToDialog([fvoid_not],4):-!.

  test_ConvColRowMarker(singular,0,["singular","multi","none","singlearea"]):-!.
  test_ConvColRowMarker(multi,1,["singular","multi","none","singlearea"]):-!.
  test_ConvColRowMarker(none,2,["singular","multi","none","singlearea"]):-!.
  test_ConvColRowMarker(singlearea,3,["singular","multi","none","singlearea"]):-!.

  test_SetColRowMarker(DlgWin,IDC,MarkerMode):-
	test_ConvColRowMarker(MarkerMode,Sel,TitleList),
	CtrlWin = win_GetCtlHandle(DlgWin,IDC),
	lbox_Add(CtrlWin,TitleList),
	lbox_SetSel(CtrlWin,Sel,b_true),
	!.
  test_SetColRowMarker(_,_,_).

  test_SetRowSel(DlgWin,IDC1,IDC2,IDC3,TabProp):-
	test_member(rowselector(GRS,Width,ActRow),TabProp),
	test_ConvGridRowSelector(GRS,Sel1,TitleList1),
	CtrlWin1 = win_GetCtlHandle(DlgWin,IDC1),
	lbox_Add(CtrlWin1,TitleList1),
	lbox_SetSel(CtrlWin1,Sel1,b_true),
	test_ConvWidthRowSelector(Width,Sel2,TitleList2),
	CtrlWin2 = win_GetCtlHandle(DlgWin,IDC2),
	lbox_Add(CtrlWin2,TitleList2),
	lbox_SetSel(CtrlWin2,Sel2,b_true),
	test_SetBoolean(DlgWin,IDC3,ActRow),
	!.
  test_SetRowSel(_,_,_,_,_).

  test_ConvGridRowSelector(grid_number,0,["grid_number","grid_nothing"]):-!.
  test_ConvGridRowSelector(grid_nothing,1,["grid_number","grid_nothing"]):-!.
  test_ConvWidthRowSelector(30,0,["30","50","70"]):-!.
  test_ConvWidthRowSelector(50,1,["30","50","70"]):-!.
  test_ConvWidthRowSelector(70,2,["30","50","70"]):-!.

  test_SetInt_0(DlgWin,IDC,I):-
	CtrlWin = win_GetCtlHandle(DlgWin,IDC),
	lbox_Add(CtrlWin,["0","1","2","3"]),
	lbox_SetSel(CtrlWin,I,b_true),!.
  test_SetInt_1(DlgWin,IDC,I):-
	CtrlWin = win_GetCtlHandle(DlgWin,IDC),
	lbox_Add(CtrlWin,["1","2","3"]),
	I1 = I - 1,
	lbox_SetSel(CtrlWin,I1,b_true),!.

  test_SetBoolean(DlgWin,IDC,B):-
	test_ConvBoolean(B,Sel,TitleList),
	CtrlWin = win_GetCtlHandle(DlgWin,IDC),
	lbox_Add(CtrlWin,TitleList),
	lbox_SetSel(CtrlWin,Sel,b_true),
	!.
  test_SetBoolean(_,_,_).

  test_ConvBoolean(b_false,0,["b_false","b_true"]):-!.
  test_ConvBoolean(b_true,1,["b_false","b_true"]):-!.
  
  test_SetColor(DlgWin,IDC,Color):-
	test_GetColorText(TitleList),
	CtrlWin = win_GetCtlHandle(DlgWin,IDC),
	lbox_Add(CtrlWin,TitleList),
	test_ConvColor(Sel,_ColName,Color),
	lbox_SetSel(CtrlWin,Sel,b_true),
	!.
  test_SetColor(_,_,_).

  test_GetColorText(["White","Black","Gray","LtGray","Red","DkRed","Green","DkGreen","Blue","DkBlue","Cyan"]):-!.

  test_ConvColor(0,"White",0xFFFFFF):-!.
  test_ConvColor(1,"Black",0x000000):-!.
  test_ConvColor(2,"Gray",0x808080):-!.
  test_ConvColor(3,"LtGray",0xC0C0C0):-!.
  test_ConvColor(4,"Red",0x0000FF):-!.
  test_ConvColor(5,"DkRed",0x000080):-!.
  test_ConvColor(6,"Green",0x00FF00):-!.
  test_ConvColor(7,"DkGreen",0x008000):-!.
  test_ConvColor(8,"Blue",0xFF0000):-!.
  test_ConvColor(9,"DkBlue",0x800000):-!.
  test_ConvColor(10,"Cyan",0xFFFF00):-!.

predicates
  test_GetBoolean(WINDOW DlgWin,INTEGER IDC,BOOLEAN)
  test_GetColor(WINDOW DlgWin,INTEGER IDC,COLOR)
determ  test_GetRowSel(WINDOW DlgWin,INTEGER IDC1,INTEGER IDC2,INTEGER IDC3,TABLEEDIT_PROPERTY)
determ  test_GetInt_0(WINDOW DlgWin,INTEGER IDC1,INTEGER)
determ  test_GetInt_1(WINDOW DlgWin,INTEGER IDC1,INTEGER)
determ  test_GetColRowMarker(WINDOW DlgWin,INTEGER IDC,TABLEEDIT_MARKERMODE)

clauses
  test_GetBoolean(DlgWin,IDC,B):-
	CtrlWin = win_GetCtlHandle(DlgWin,IDC),
	lbox_GetSel(CtrlWin,_,IList), IList = [Sel],
	test_ConvBoolean(B,Sel,_TitleList),
	!.
  test_GetBoolean(_,_,b_false).

  test_GetColor(DlgWin,IDC,Color):-
	CtrlWin = win_GetCtlHandle(DlgWin,IDC),
	lbox_GetSel(CtrlWin,_,IList), IList = [Sel],
	test_ConvColor(Sel,_ColName,Color),
	!.
  test_GetColor(_,_,0).

  test_GetRowSel(DlgWin,IDC1,IDC2,IDC3,rowselector(GRS,Width,ActRow)):-
	CtrlWin1 = win_GetCtlHandle(DlgWin,IDC1),
	lbox_GetSel(CtrlWin1,_,IList1), IList1 = [Sel1],
	test_ConvGridRowSelector(GRS,Sel1,_TitleList1),
	CtrlWin2 = win_GetCtlHandle(DlgWin,IDC2),
	lbox_GetSel(CtrlWin2,_,IList2), IList2 = [Sel2],
	test_ConvWidthRowSelector(Width,Sel2,_TitleList2),
	test_GetBoolean(DlgWin,IDC3,ActRow),
	!.
  test_GetInt_0(DlgWin,IDC,Sel):-
	CtrlWin = win_GetCtlHandle(DlgWin,IDC),
	lbox_GetSel(CtrlWin,_,IList), IList = [Sel],
	!.
  test_GetInt_1(DlgWin,IDC,Sel1):-
	CtrlWin = win_GetCtlHandle(DlgWin,IDC),
	lbox_GetSel(CtrlWin,_,IList), IList = [Sel], Sel1 = Sel + 1,
	!.
  test_GetColRowMarker(DlgWin,IDC,MarkerMode):-
	CtrlWin = win_GetCtlHandle(DlgWin,IDC),
	lbox_GetSel(CtrlWin,_,IList), IList = [Sel],
	test_ConvColRowMarker(MarkerMode,Sel,_TitleList),
	!.

predicates
  test_GetWidth(WINDOW DlgWin,INTEGER IDC,TABLEEDIT_COLUMNPROPERTIES,TABLEEDIT_COLUMNPROPERTIES)
determ  test_GetHAlignment(WINDOW DlgWin,INTEGER IDC,GRID_HORALIGNMENT)
determ  test_GetSortMode(WINDOW DlgWin,INTEGER IDC,TABLEEDIT_SORTMODE)
determ  test_GetDefVal(WINDOW DlgWin,INTEGER IDC,TABLEEDIT_CELLDATA,INTEGER)
determ  test_GetRule(WINDOW DlgWin,INTEGER IDC,TABLEEDIT_RULELIST,INTEGER)
  test_GetFilterList(WINDOW DlgWin,INTEGER IDC,TABLEEDIT_COLUMNPROPERTIES,TABLEEDIT_COLUMNPROPERTIES,INTEGER)
determ  test_GetControl(WINDOW DlgWin,INTEGER IDC,TABLEEDIT_CONTROL_TYPE,INTEGER)

clauses
  test_GetControl(DlgWin,IDC,C,1):-
	CtrlWin = win_GetCtlHandle(DlgWin,IDC),
	lbox_GetSel(CtrlWin,_,IList), IList = [Sel],
	test_ConvControlR(C,Sel,_TitleList),
	!.
  test_GetControl(DlgWin,IDC,C,2):-
	CtrlWin = win_GetCtlHandle(DlgWin,IDC),
	lbox_GetSel(CtrlWin,_,IList), IList = [Sel],
	test_ConvControlS(C,Sel,_TitleList),
	!.

  test_GetFilterList(DlgWin,IDC,ColProp,OutColProp,1):-
	CtrlWin = win_GetCtlHandle(DlgWin,IDC),
	lbox_GetSel(CtrlWin,_,IList), IList = [Sel],
	test_ConvRealFilterToDialog(FilterList,Sel),
	OutColProp = [filterlist(FilterList)|ColProp],
	!.
  test_GetFilterList(DlgWin,IDC,ColProp,OutColProp,2):-
	CtrlWin = win_GetCtlHandle(DlgWin,IDC),
	lbox_GetSel(CtrlWin,_,IList), IList = [Sel],
	test_ConvStringFilterToDialog(FilterList,Sel),
	OutColProp = [filterlist(FilterList)|ColProp],
	!.
  test_GetFilterList(_DlgWin,_IDC,ColProp,ColProp,_):-!.

  test_GetRule(DlgWin,IDC,VR,1):-
	CtrlWin = win_GetCtlHandle(DlgWin,IDC),
	lbox_GetSel(CtrlWin,_,IList), IList = [Sel],
	test_ConvRealRule(VR,Sel,_TitleList),
	!.
  test_GetRule(DlgWin,IDC,VR,2):-
	CtrlWin = win_GetCtlHandle(DlgWin,IDC),
	lbox_GetSel(CtrlWin,_,IList), IList = [Sel],
	test_ConvStrRule(VR,Sel,_TitleList),
	!.

  test_GetDefVal(DlgWin,IDC,DFV,1):-
	CtrlWin = win_GetCtlHandle(DlgWin,IDC),
	lbox_GetSel(CtrlWin,_,IList), IList = [Sel],
	test_ConvDefRealVal(DFV,Sel,_TitleList),
	!.
  test_GetDefVal(DlgWin,IDC,DFV,2):-
	CtrlWin = win_GetCtlHandle(DlgWin,IDC),
	lbox_GetSel(CtrlWin,_,IList), IList = [Sel],
	test_ConvDefString(DFV,Sel,_TitleList),
	!.

  test_GetSortMode(DlgWin,IDC,S):-
	CtrlWin = win_GetCtlHandle(DlgWin,IDC),
	lbox_GetSel(CtrlWin,_,IList), IList = [Sel],
	test_ConvSortMode(S,Sel,_TitleList),
	!.

  test_GetHAlignment(DlgWin,IDC,A):-
	CtrlWin = win_GetCtlHandle(DlgWin,IDC),
	lbox_GetSel(CtrlWin,_,IList), IList = [Sel],
	test_ConvHAlignment(A,Sel,_TitleList),
	!.

  test_GetWidth(DlgWin,IDC,ColProp,OutColProp):-
	CtrlWin = win_GetCtlHandle(DlgWin,IDC),
	T = win_GetText(CtrlWin),
	str_int(T,W),
	OutColProp = [width(W)|ColProp],
	W >= 0,
	!.
  test_GetWidth(_DlgWin,_IDC,ColProp,ColProp):-!.

predicates
  test_SetTabPropToDialog(WINDOW DlgWin,TABLEEDIT_PROPERTIES)
  test_SetColPropToDialog(WINDOW DlgWin,TABLEEDIT_COLUMNPROPERTIES,INTEGER)
  test_GetTabPropFromDialog(WINDOW DlgWin,TABLEEDIT_PROPERTIES)
  test_GetColumnPropFromDialog(WINDOW DlgWin,TABLEEDIT_COLUMNPROPERTIES ColProp,INTEGER)

clauses
  test_SetTabProptoDialog(DlgWin,TabProp):-
	test_member(raised(R),TabProp),
	test_SetBoolean(DlgWin,idc_tp1,R),
	test_member(backcolor(BC),TabProp),
	test_SetColor(DlgWin,idc_tp2,BC),
	test_member(emptycolor(EC),TabProp),
	test_SetColor(DlgWin,idc_tp3,EC),
	test_member(titlebackcolor(TBC),TabProp),
	test_SetColor(DlgWin,idc_tp4,TBC),
	test_member(titleforecolor(TFC),TabProp),
	test_SetColor(DlgWin,idc_tp5,TFC),
	test_SetRowSel(DlgWin,idc_tp6,idc_tp7,idc_tp25,TabProp),
	test_member(nonscrollcol(NSC),TabProp),
	test_SetInt_0(DlgWin,idc_tp8,NSC),
	test_member(sortedby(SBY),TabProp),
	test_SetInt_1(DlgWin,idc_tp9,SBY),
	test_member(allmarker(ALLM),TabProp),
	test_SetBoolean(DlgWin,idc_tp10,ALLM),
	test_member(colmarker(ColMarkMode),TabProp),
  	test_SetColRowMarker(DlgWin,idc_tp11,ColMarkMode),
	test_member(rowmarker(RowMarkMode),TabProp),
  	test_SetColRowMarker(DlgWin,idc_tp12,RowMarkMode),
	test_member(areamarker(AreaMarkMode),TabProp),
  	test_SetColRowMarker(DlgWin,idc_tp23,AreaMarkMode),
	test_member(insert_rows(InsRows),TabProp),
	test_SetBoolean(DlgWin,idc_tp13,InsRows),
	test_member(delete_rows(DeleteRows),TabProp),
	test_SetBoolean(DlgWin,idc_tp14,DeleteRows),
	test_member(footers(FOOT),TabProp),
	test_SetInt_0(DlgWin,idc_tp18,FOOT),
	test_member(headers(Head),TabProp),
	test_SetInt_0(DlgWin,idc_tp19,Head),
	test_member(undo_redo(Undo_Redo),TabProp),
	test_SetBoolean(DlgWin,idc_tp20,Undo_Redo),
	test_member(paste(Paste),TabProp),
	test_SetBoolean(DlgWin,idc_tp21,Paste),
	test_member(cut(Cut),TabProp),
	test_SetBoolean(DlgWin,idc_tp22,Cut),
	test_member(defcellcolor(DCol),TabProp),
	test_SetColor(DlgWin,idc_tp24,Dcol),
	!.
  test_SetTabProptoDialog(_,_).

  test_SetColPropToDialog(DlgWin,ColProp,1):-
	test_member(title(T),ColProp),
	CtrlWin1 = win_GetCtlHandle(DlgWin,idc_1cp1),
	win_SetText(CtrlWin1,T),
	test_SetWidth(DlgWin,idc_1cp2,ColProp),
	test_member(backcolor(BC),ColProp),
	test_SetColor(DlgWin,idc_1cp3,BC),
	test_member(forecolor(FC),ColProp),
	test_SetColor(DlgWin,idc_1cp4,FC),
	test_SetHAlignment(DlgWin,idc_1cp5,ColProp),
	test_member(readonly(Ronly),ColProp),
	test_SetBoolean(DlgWin,idc_1cp6,Ronly),
	test_member(resizable(RE),ColProp),
	test_SetBoolean(DlgWin,idc_1cp7,RE),
	test_SetSortMode(DlgWin,idc_1cp8,ColProp),
	test_SetDefVal(DlgWin,idc_1cp9,ColProp),
	test_SetRule(DlgWin,idc_1cp10,ColProp),
	test_member(validationtext(ValT),ColProp),
	CtrlWin2 = win_GetCtlHandle(DlgWin,idc_1cp11),
	win_SetText(CtrlWin2,ValT),
	test_member(filter(Filter),ColProp),
	test_SetBoolean(DlgWin,idc_1cp12,Filter),
	test_SetFilterList(DlgWin,idc_1cp13,ColProp),
	test_SetControl(DlgWin,idc_1cp14,ColProp),
	test_member(mandatory(M),ColProp),
	test_SetBoolean(DlgWin,idc_1cp15,M),
	!.
  test_SetColPropToDialog(DlgWin,ColProp,2):-
	test_member(title(T),ColProp),
	CtrlWin1 = win_GetCtlHandle(DlgWin,idc_2cp1),
	win_SetText(CtrlWin1,T),
	test_SetWidth(DlgWin,idc_2cp2,ColProp),
	test_member(backcolor(BC),ColProp),
	test_SetColor(DlgWin,idc_2cp3,BC),
	test_member(forecolor(FC),ColProp),
	test_SetColor(DlgWin,idc_2cp4,FC),
	test_SetHAlignment(DlgWin,idc_2cp5,ColProp),
	test_member(readonly(Ronly),ColProp),
	test_SetBoolean(DlgWin,idc_2cp6,Ronly),
	test_member(resizable(RE),ColProp),
	test_SetBoolean(DlgWin,idc_2cp7,RE),
	test_SetSortMode(DlgWin,idc_2cp8,ColProp),
	test_SetDefVal(DlgWin,idc_2cp9,ColProp),
	test_SetRule(DlgWin,idc_2cp10,ColProp),
	test_member(validationtext(ValT),ColProp),
	CtrlWin2 = win_GetCtlHandle(DlgWin,idc_2cp11),
	win_SetText(CtrlWin2,ValT),
	test_member(filter(Filter),ColProp),
	test_SetBoolean(DlgWin,idc_2cp12,Filter),
	test_SetFilterList(DlgWin,idc_2cp13,ColProp),
	test_SetControl(DlgWin,idc_2cp14,ColProp),
	test_member(mandatory(M),ColProp),
	test_SetBoolean(DlgWin,idc_2cp15,M),
	!.
  test_SetColPropToDialog(_,_,_).
  
  test_GetTabPropFromDialog(DlgWin,TabProp):-
	test_GetBoolean(DlgWin,idc_tp1,R),
	test_GetColor(DlgWin,idc_tp2,BC),
	test_GetColor(DlgWin,idc_tp3,EC),
	test_GetColor(DlgWin,idc_tp4,TBC),
	test_GetColor(DlgWin,idc_tp5,TFC),
	test_GetRowSel(DlgWin,idc_tp6,idc_tp7,idc_tp25,RS),
	test_GetInt_0(DlgWin,idc_tp8,NSC),
	test_GetInt_1(DlgWin,idc_tp9,SBy),
	test_GetBoolean(DlgWin,idc_tp10,AllM),
	test_GetColRowMarker(DlgWin,idc_tp11,ColMarkMode),
	test_GetColRowMarker(DlgWin,idc_tp12,RowMarkMode),
	test_GetColRowMarker(DlgWin,idc_tp23,AreaMarkMode),
	test_GetBoolean(DlgWin,idc_tp13,InsRows),
	test_GetBoolean(DlgWin,idc_tp14,DelRows),
	test_GetInt_0(DlgWin,idc_tp18,Foot),
	test_GetInt_0(DlgWin,idc_tp19,Head),
	test_GetBoolean(DlgWin,idc_tp20,Undo_Redo),
	test_GetBoolean(DlgWin,idc_tp21,Paste),
	test_GetBoolean(DlgWin,idc_tp22,Cut),
	test_GetColor(DlgWin,idc_tp24,DCol),

 	TabProp = [raised(R),backcolor(BC),emptycolor(EC),titlebackcolor(TBC),
		titleforecolor(TFC),RS,nonscrollcol(NSC),sortedby(SBy),allmarker(AllM),
		colmarker(ColMarkMode),rowmarker(RowMarkMode),areamarker(AreaMarkMode),
		insert_rows(InsRows),delete_rows(DelRows),footers(Foot),headers(Head),
		undo_redo(Undo_Redo),paste(Paste),cut(Cut),defcellcolor(DCol)],
	!.
  test_GetTabPropFromDialog(_,[]):-!.

  test_GetColumnPropFromDialog(DlgWin,ColProp,1):-
	CtrlWin1 = win_GetCtlHandle(DlgWin,idc_1cp1),
	T = win_GetText(CtrlWin1),
	test_GetColor(DlgWin,idc_1cp3,BC),
	test_GetColor(DlgWin,idc_1cp4,FC),
	test_GetHAlignment(DlgWin,idc_1cp5,A),
	test_GetBoolean(DlgWin,idc_1cp6,Ronly),
	test_GetBoolean(DlgWin,idc_1cp7,RE),
	test_GetSortMode(DlgWin,idc_1cp8,S),
	test_GetDefVal(DlgWin,idc_1cp9,DFV,1),
	test_GetRule(DlgWin,idc_1cp10,VR,1),
	CtrlWin2 = win_GetCtlHandle(DlgWin,idc_1cp11),
	ValT = win_GetText(CtrlWin2),
	test_GetBoolean(DlgWin,idc_1cp12,Filter),
	test_GetControl(DlgWin,idc_1cp14,C,1),
	test_GetBoolean(DlgWin,idc_1cp15,M),

 	ColProp1 = [title(T),backcolor(BC),forecolor(FC),alignment(A),readonly(Ronly),
 			resizable(RE),sortmode(S),defaultvalue(DFV),validationrule(VR),
 			validationtext(ValT),filter(Filter),control(C),mandatory(M)],
	test_GetWidth(DlgWin,idc_1cp2,ColProp1,ColProp2),
	test_GetFilterList(DlgWin,idc_1cp13,ColProp2,ColProp,1),
	!.
  test_GetColumnPropFromDialog(DlgWin,ColProp,2):-
	CtrlWin1 = win_GetCtlHandle(DlgWin,idc_2cp1),
	T = win_GetText(CtrlWin1),
	test_GetColor(DlgWin,idc_2cp3,BC),
	test_GetColor(DlgWin,idc_2cp4,FC),
	test_GetHAlignment(DlgWin,idc_2cp5,A),
	test_GetBoolean(DlgWin,idc_2cp6,Ronly),
	test_GetBoolean(DlgWin,idc_2cp7,RE),
	test_GetSortMode(DlgWin,idc_2cp8,S),
	test_GetDefVal(DlgWin,idc_2cp9,DFV,2),
	test_GetRule(DlgWin,idc_2cp10,VR,2),
	CtrlWin2 = win_GetCtlHandle(DlgWin,idc_2cp11),
	ValT = win_GetText(CtrlWin2),
	test_GetBoolean(DlgWin,idc_2cp12,Filter),
	test_GetControl(DlgWin,idc_2cp14,C,2),
	test_GetBoolean(DlgWin,idc_2cp15,M),

 	ColProp1 = [title(T),backcolor(BC),forecolor(FC),alignment(A),readonly(Ronly),
 			resizable(RE),sortmode(S),defaultvalue(DFV),validationrule(VR),
 			validationtext(ValT),filter(Filter),control(C),mandatory(M)],
	test_GetWidth(DlgWin,idc_2cp2,ColProp1,ColProp2),
	test_GetFilterList(DlgWin,idc_2cp13,ColProp2,ColProp,2),
	!.
  test_GetColumnPropFromDialog(_,[],_).

%BEGIN_WIN Task Window
/***************************************************************************
	Event handling for Task Window
***************************************************************************/

predicates

  task_win_eh : EHANDLER

constants

%BEGIN Task Window, CreateParms, 16:15:24-24.11.1999, Code automatically updated!
  task_win_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Close,wsf_Maximize,wsf_Minimize,wsf_ClipSiblings]
  task_win_Menu  = res_menu(idr_task_menu)
  task_win_Title = "Tabtest"
  task_win_Help  = idh_contents
%END Task Window, CreateParms

clauses

%BEGIN Task Window, e_Create
  task_win_eh(_Win,e_Create(_),0):-!,
%BEGIN Task Window, InitControls, 16:15:24-24.11.1999, Code automatically updated!
%END Task Window, InitControls
%BEGIN Task Window, ToolbarCreate, 16:15:24-24.11.1999, Code automatically updated!
	tb_project_toolbar_Create(_Win),
	tb_help_line_Create(_Win),
%END Task Window, ToolbarCreate
ifdef use_message
	msg_Create(100),
enddef
% *********** Register class for date custom control*********************
	class_Create("date",date_handler),
% *********** Register class for Table editor  custom control************
	class_Create(tableed_class,tableed_class_handler), 
	!.
%END Task Window, e_Create

%MARK Task Window, new events

%BEGIN Task Window, id_optimize
  task_win_eh(_Win,e_Menu(id_optimize,_ShiftCtlAlt),0):-!,
	test_Info(GridWin),
	tableedit_OptimizeColumnsWidth(GridWin,b_false),
	!.
%END Task Window, id_optimize

%BEGIN Task Window, id_initbuff
  task_win_eh(_Win,e_Menu(id_initbuff,_ShiftCtlAlt),0):-!,
	assert(buffmode()),
	win_table_editor_Create(_Win),
	menu_Enable(_Win,"Test",b_true),
	menu_Enable(_Win,id_init,b_false),
	menu_Enable(_Win,id_initbuff,b_false),
	menu_Update(_Win),
	!.
%END Task Window, id_initbuff

%BEGIN Task Window, id_init
  task_win_eh(_Win,e_Menu(id_init,_ShiftCtlAlt),0):-!,
	retractAll(buffmode()),
	win_table_editor_Create(_Win),
	menu_Enable(_Win,"Test",b_true),
	menu_Enable(_Win,id_init,b_false),
	menu_Enable(_Win,id_initbuff,b_false),
	menu_Update(_Win),
	!.
%END Task Window, id_init

%BEGIN Task Window, id_setproperties
  task_win_eh(_Win,e_Menu(id_setproperties,_ShiftCtlAlt),0):-
	test_Info(GridWin),
	grid_Marker(GridWin,Marker),
	Marker = grid_edit_cell(_,_),
	dlg_error("Edit marker in the Grid control must be closed before calling this function"),
	!.
  task_win_eh(_Win,e_Menu(id_setproperties,_ShiftCtlAlt),0):-!,
	test_Info(_GridWin),
	dlg_propdlg_Create(_Win),
	!.
%END Task Window, id_setproperties

%BEGIN Task Window, id_getrowdata
  task_win_eh(_Win,e_Menu(id_getrowdata,_ShiftCtlAlt),0):-!,
	test_Info(GridWin),
	Ndata = tableedit_MaxRows(GridWin),
	Ndata > 0,
	Str = tableedit_GetRowData(GridWin,1,Ndata),
	nl,write(Str),
	!.
%END Task Window, id_getrowdata

%BEGIN Task Window, id_getallVisibledata
  task_win_eh(_Win,e_Menu(id_getallVisibledata,_ShiftCtlAlt),0):-!,
	test_Info(GridWin),
	Data = tableedit_GetAllVisibleData(GridWin),
	nl,write(Data),
	!.
%END Task Window, id_getallVisibledata

%BEGIN Task Window, id_getalldata
  task_win_eh(_Win,e_Menu(id_getalldata,_ShiftCtlAlt),0):-!,
	test_Info(GridWin),
	Data = tableedit_GetAllData(GridWin),
	nl,write(Data),
	!.
%END Task Window, id_getalldata

%BEGIN Task Window, id_gettableproperties
  task_win_eh(_Win,e_Menu(id_gettableproperties,_ShiftCtlAlt),0):-!,
	test_Info(GridWin),
	TabProp = tableedit_GetProperties(GridWin),
	nl,write(TabProp),
	!.
%END Task Window, id_gettableproperties

%BEGIN Task Window, id_winsetfont
  task_win_eh(_Win,e_Menu(id_winsetfont,_ShiftCtlAlt),0):-!,
	test_Info(GridWin),
	OldFont = win_GetFont(GridWin),
	NewFont = dlg_ChooseFont(OldFont,_NewFontName,_),% Get FontName from dlg_ChooseFont
	win_SetFont(GridWin,NewFont),
	!.
%END Task Window, id_winsetfont

%BEGIN Task Window, id_getcolumn2properties
  task_win_eh(_Win,e_Menu(id_getcolumn2properties,_ShiftCtlAlt),0):-!,
	test_Info(GridWin),
	ColProp = tableedit_GetColumnProperties(GridWin,2),
	nl,write(ColProp),
	!.
%END Task Window, id_getcolumn2properties

%BEGIN Task Window, id_getcolumn1properties
  task_win_eh(_Win,e_Menu(id_getcolumn1properties,_ShiftCtlAlt),0):-!,
	test_Info(GridWin),
	ColProp = tableedit_GetColumnProperties(GridWin,1),
	nl,write(ColProp),
	!.
%END Task Window, id_getcolumn1properties

%BEGIN Task Window, e_Destroy
  task_win_eh(_Win,e_Destroy,0):-!,
% ********* Destroy class for date custom control************************
	class_Destroy("date"),
% ********* Destroy class for  Table editor custom control***************
	class_Destroy(tableed_class),
	!.
%END Task Window, e_Destroy

%BEGIN Task Window, id_help_contents
  task_win_eh(_Win,e_Menu(id_help_contents,_ShiftCtlAlt),0):-!,
  	vpi_ShowHelp("tabtest.hlp"),
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
ifdef use_tbar
	toolbar_Resize(_Win),
enddef
ifdef use_message
	msg_Resize(_Win),
enddef
	!.
%END Task Window, e_Size

%END_WIN Task Window

/***************************************************************************
	Invoking on-line Help
***************************************************************************/

  project_ShowHelpContext(HelpTopic):-
  	vpi_ShowHelpContext("tabtest.hlp",HelpTopic).

/***************************************************************************
	Main Goal
***************************************************************************/

GOAL

ifdef use_mdi
  vpi_SetAttrVal(attr_win_mdi,b_true),
enddef
ifdef ws_win
  ifdef use_3dctrl
    vpi_SetAttrVal(attr_win_3dcontrols,b_true),
  enddef
enddef  
  vpi_Init(task_win_Flags,task_win_eh,task_win_Menu,"tabtest",task_win_Title).

%BEGIN_TLB Project toolbar, 16:15:40-24.11.1999, Code automatically updated!
/**************************************************************************
	Creation of toolbar: Project toolbar
**************************************************************************/

clauses

  tb_project_toolbar_Create(_Parent):-
ifdef use_tbar
	toolbar_create(tb_top,0xC0C0C0,_Parent,
		[tb_ctrl(id_init,pushb,idb_new_up,idb_new_dn,idb_new_up,"New;New file",1,1),
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
		 tb_ctrl(id_help_contents,pushb,idb_help_up,idb_help_down,idb_help_up,"Help;Help",0,1)]),
enddef
	true.
%END_TLB Project toolbar




%BEGIN_TLB Help line, 16:15:48-24.11.1999, Code automatically updated!
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

constants

%BEGIN About dialog, CreateParms, 19:58:32-24.11.1999, Code automatically updated!
  dlg_about_dialog_ResID = idd_dlg_about
  dlg_about_dialog_DlgType = wd_Modal
  dlg_about_dialog_Help = idh_contents
%END About dialog, CreateParms

predicates

  dlg_about_dialog_eh : EHANDLER

clauses

  dlg_about_dialog_Create(Parent):-
	win_CreateResDialog(Parent,dlg_about_dialog_DlgType,dlg_about_dialog_ResID,dlg_about_dialog_eh,0).

%BEGIN About dialog, idc_ok _CtlInfo
  dlg_about_dialog_eh(_Win,e_Control(idc_ok,_CtrlType,_CtrlWin,_CtrlInfo),0):-!,
	win_Destroy(_Win),
	!.
%END About dialog, idc_ok _CtlInfo
%MARK About dialog, new events

  dlg_about_dialog_eh(_,_,_):-!,fail.

%END_DLG About dialog

%BEGIN_DLG PropDlg
/**************************************************************************
	Creation and event handling for dialog: PropDlg
**************************************************************************/

constants

%BEGIN PropDlg, CreateParms, 16:14:50-24.11.1999, Code automatically updated!
  dlg_propdlg_ResID = idd_propdlg
  dlg_propdlg_DlgType = wd_Modal
  dlg_propdlg_Help = idh_contents
%END PropDlg, CreateParms

predicates

  dlg_propdlg_eh : EHANDLER
  dlg_propdlg_handle_answer(INTEGER EndButton,DIALOG_VAL_LIST)
  dlg_propdlg_update(DIALOG_VAL_LIST)

clauses

  dlg_propdlg_Create(Parent):-

%MARK PropDlg, new variables

	dialog_CreateModal(Parent,dlg_propdlg_ResID,"",
  		[
%BEGIN PropDlg, ControlList, 16:14:50-24.11.1999, Code automatically updated!
		df(idc_tp1,listbutton([],0),nopr),
		df(idc_tp2,listbutton([],0),nopr),
		df(idc_tp4,listbutton([],0),nopr),
		df(idc_tp3,listbutton([],0),nopr),
		df(idc_tp6,listbutton([],0),nopr),
		df(idc_tp7,listbutton([],0),nopr),
		df(idc_tp5,listbutton([],0),nopr),
		df(idc_tp12,listbutton([],0),nopr),
		df(idc_tp13,listbutton([],0),nopr),
		df(idc_tp14,listbutton([],0),nopr),
		df(idc_tp10,listbutton([],0),nopr),
		df(idc_tp11,listbutton([],0),nopr),
		df(idc_tp9,listbutton([],0),nopr),
		df(idc_tp8,listbutton([],0),nopr),
		df(idc_tp19,listbutton([],0),nopr),
		df(idc_tp18,listbutton([],0),nopr),
		df(idc_1cp8,listbutton([],0),nopr),
		df(idc_1cp3,listbutton([],0),nopr),
		df(idc_1cp4,listbutton([],0),nopr),
		df(idc_1cp5,listbutton([],0),nopr),
		df(idc_1cp6,listbutton([],0),nopr),
		df(idc_1cp7,listbutton([],0),nopr),
		df(idc_1cp9,listbutton([],0),nopr),
		df(idc_1cp10,listbutton([],0),nopr),
		df(idc_1cp12,listbutton([],0),nopr),
		df(idc_1cp1,editstr("",[]),nopr),
		df(idc_1cp13,listbutton([],0),nopr),
		df(idc_1cp14,listbutton([],0),nopr),
		df(idc_1cp15,listbutton([],0),nopr),
		df(idc_1cp11,editstr("",[]),nopr),
		df(idc_2cp14,listbutton([],0),nopr),
		df(idc_2cp15,listbutton([],0),nopr),
		df(idc_2cp13,listbutton([],0),nopr),
		df(idc_2cp12,listbutton([],0),nopr),
		df(idc_2cp8,listbutton([],0),nopr),
		df(idc_2cp3,listbutton([],0),nopr),
		df(idc_2cp4,listbutton([],0),nopr),
		df(idc_2cp5,listbutton([],0),nopr),
		df(idc_2cp6,listbutton([],0),nopr),
		df(idc_2cp7,listbutton([],0),nopr),
		df(idc_2cp9,listbutton([],0),nopr),
		df(idc_2cp10,listbutton([],0),nopr),
		df(idc_2cp11,editstr("",[]),nopr),
		df(idc_2cp1,editstr("",[]),nopr),
		df(idc_1cp2,listedit([],""),nopr),
		df(idc_2cp2,listedit([],""),nopr),
		df(idc_tp20,listbutton([],0),nopr),
		df(idc_tp21,listbutton([],0),nopr),
		df(idc_tp22,listbutton([],0),nopr),
		df(idc_tp23,listbutton([],0),nopr),
		df(idc_tp24,listbutton([],0),nopr),
		df(idc_tp25,listbutton([],0),nopr)
%END PropDlg, ControlList
		],
		dlg_propdlg_eh,0,VALLIST,ANSWER),
	dlg_propdlg_handle_answer(ANSWER,VALLIST).

  dlg_propdlg_handle_answer(idc_ok,VALLIST):-!,
	dlg_propdlg_update(VALLIST).
  dlg_propdlg_handle_answer(idc_cancel,_):-!.  % Handle Esc and Cancel here
  dlg_propdlg_handle_answer(_,_):-
	errorexit().

  dlg_propdlg_update(_VALLIST):-
%BEGIN PropDlg, Update controls, 16:14:50-24.11.1999, Code automatically updated!
	dialog_VLGetListButton(idc_tp1,_VALLIST,_IDC_TP1_ITEMLIST,_IDC_TP1_SELECT),
	dialog_VLGetListButton(idc_tp2,_VALLIST,_IDC_TP2_ITEMLIST,_IDC_TP2_SELECT),
	dialog_VLGetListButton(idc_tp4,_VALLIST,_IDC_TP4_ITEMLIST,_IDC_TP4_SELECT),
	dialog_VLGetListButton(idc_tp3,_VALLIST,_IDC_TP3_ITEMLIST,_IDC_TP3_SELECT),
	dialog_VLGetListButton(idc_tp6,_VALLIST,_IDC_TP6_ITEMLIST,_IDC_TP6_SELECT),
	dialog_VLGetListButton(idc_tp7,_VALLIST,_IDC_TP7_ITEMLIST,_IDC_TP7_SELECT),
	dialog_VLGetListButton(idc_tp5,_VALLIST,_IDC_TP5_ITEMLIST,_IDC_TP5_SELECT),
	dialog_VLGetListButton(idc_tp12,_VALLIST,_IDC_TP12_ITEMLIST,_IDC_TP12_SELECT),
	dialog_VLGetListButton(idc_tp13,_VALLIST,_IDC_TP13_ITEMLIST,_IDC_TP13_SELECT),
	dialog_VLGetListButton(idc_tp14,_VALLIST,_IDC_TP14_ITEMLIST,_IDC_TP14_SELECT),
	dialog_VLGetListButton(idc_tp10,_VALLIST,_IDC_TP10_ITEMLIST,_IDC_TP10_SELECT),
	dialog_VLGetListButton(idc_tp11,_VALLIST,_IDC_TP11_ITEMLIST,_IDC_TP11_SELECT),
	dialog_VLGetListButton(idc_tp9,_VALLIST,_IDC_TP9_ITEMLIST,_IDC_TP9_SELECT),
	dialog_VLGetListButton(idc_tp8,_VALLIST,_IDC_TP8_ITEMLIST,_IDC_TP8_SELECT),
	dialog_VLGetListButton(idc_tp19,_VALLIST,_IDC_TP19_ITEMLIST,_IDC_TP19_SELECT),
	dialog_VLGetListButton(idc_tp18,_VALLIST,_IDC_TP18_ITEMLIST,_IDC_TP18_SELECT),
	dialog_VLGetListButton(idc_1cp8,_VALLIST,_IDC_1CP8_ITEMLIST,_IDC_1CP8_SELECT),
	dialog_VLGetListButton(idc_1cp3,_VALLIST,_IDC_1CP3_ITEMLIST,_IDC_1CP3_SELECT),
	dialog_VLGetListButton(idc_1cp4,_VALLIST,_IDC_1CP4_ITEMLIST,_IDC_1CP4_SELECT),
	dialog_VLGetListButton(idc_1cp5,_VALLIST,_IDC_1CP5_ITEMLIST,_IDC_1CP5_SELECT),
	dialog_VLGetListButton(idc_1cp6,_VALLIST,_IDC_1CP6_ITEMLIST,_IDC_1CP6_SELECT),
	dialog_VLGetListButton(idc_1cp7,_VALLIST,_IDC_1CP7_ITEMLIST,_IDC_1CP7_SELECT),
	dialog_VLGetListButton(idc_1cp9,_VALLIST,_IDC_1CP9_ITEMLIST,_IDC_1CP9_SELECT),
	dialog_VLGetListButton(idc_1cp10,_VALLIST,_IDC_1CP10_ITEMLIST,_IDC_1CP10_SELECT),
	dialog_VLGetListButton(idc_1cp12,_VALLIST,_IDC_1CP12_ITEMLIST,_IDC_1CP12_SELECT),
	_IDC_1CP1_VALUE = dialog_VLGetstr(idc_1cp1,_VALLIST),
	dialog_VLGetListButton(idc_1cp13,_VALLIST,_IDC_1CP13_ITEMLIST,_IDC_1CP13_SELECT),
	dialog_VLGetListButton(idc_1cp14,_VALLIST,_IDC_1CP14_ITEMLIST,_IDC_1CP14_SELECT),
	dialog_VLGetListButton(idc_1cp15,_VALLIST,_IDC_1CP15_ITEMLIST,_IDC_1CP15_SELECT),
	_IDC_1CP11_VALUE = dialog_VLGetstr(idc_1cp11,_VALLIST),
	dialog_VLGetListButton(idc_2cp14,_VALLIST,_IDC_2CP14_ITEMLIST,_IDC_2CP14_SELECT),
	dialog_VLGetListButton(idc_2cp15,_VALLIST,_IDC_2CP15_ITEMLIST,_IDC_2CP15_SELECT),
	dialog_VLGetListButton(idc_2cp13,_VALLIST,_IDC_2CP13_ITEMLIST,_IDC_2CP13_SELECT),
	dialog_VLGetListButton(idc_2cp12,_VALLIST,_IDC_2CP12_ITEMLIST,_IDC_2CP12_SELECT),
	dialog_VLGetListButton(idc_2cp8,_VALLIST,_IDC_2CP8_ITEMLIST,_IDC_2CP8_SELECT),
	dialog_VLGetListButton(idc_2cp3,_VALLIST,_IDC_2CP3_ITEMLIST,_IDC_2CP3_SELECT),
	dialog_VLGetListButton(idc_2cp4,_VALLIST,_IDC_2CP4_ITEMLIST,_IDC_2CP4_SELECT),
	dialog_VLGetListButton(idc_2cp5,_VALLIST,_IDC_2CP5_ITEMLIST,_IDC_2CP5_SELECT),
	dialog_VLGetListButton(idc_2cp6,_VALLIST,_IDC_2CP6_ITEMLIST,_IDC_2CP6_SELECT),
	dialog_VLGetListButton(idc_2cp7,_VALLIST,_IDC_2CP7_ITEMLIST,_IDC_2CP7_SELECT),
	dialog_VLGetListButton(idc_2cp9,_VALLIST,_IDC_2CP9_ITEMLIST,_IDC_2CP9_SELECT),
	dialog_VLGetListButton(idc_2cp10,_VALLIST,_IDC_2CP10_ITEMLIST,_IDC_2CP10_SELECT),
	_IDC_2CP11_VALUE = dialog_VLGetstr(idc_2cp11,_VALLIST),
	_IDC_2CP1_VALUE = dialog_VLGetstr(idc_2cp1,_VALLIST),
	_IDC_1CP2_DEFAULT = dialog_VLGetListEdit(idc_1cp2,_VALLIST),
	_IDC_2CP2_DEFAULT = dialog_VLGetListEdit(idc_2cp2,_VALLIST),
	dialog_VLGetListButton(idc_tp20,_VALLIST,_IDC_TP20_ITEMLIST,_IDC_TP20_SELECT),
	dialog_VLGetListButton(idc_tp21,_VALLIST,_IDC_TP21_ITEMLIST,_IDC_TP21_SELECT),
	dialog_VLGetListButton(idc_tp22,_VALLIST,_IDC_TP22_ITEMLIST,_IDC_TP22_SELECT),
	dialog_VLGetListButton(idc_tp23,_VALLIST,_IDC_TP23_ITEMLIST,_IDC_TP23_SELECT),
	dialog_VLGetListButton(idc_tp24,_VALLIST,_IDC_TP24_ITEMLIST,_IDC_TP24_SELECT),
	dialog_VLGetListButton(idc_tp25,_VALLIST,_IDC_TP25_ITEMLIST,_IDC_TP25_SELECT),
%END PropDlg, Update controls
	true.

%MARK PropDlg, new events

%BEGIN PropDlg, idc_cancel _CtlInfo
  dlg_propdlg_eh(_Win,e_Control(idc_cancel,_CtrlType,_CtrlWin,activated()),0):-!,
	win_Destroy(_Win),
	!.
%END PropDlg, idc_cancel _CtlInfo

%BEGIN PropDlg, idc_ok _CtlInfo
  dlg_propdlg_eh(_Win,e_Control(idc_ok,_CtrlType,_CtrlWin,activated()),0):-!,
	test_Info(GridWin),
	test_GetTabPropFromDialog(_Win,TabProp),
	tableedit_SetProperties(GridWin,TabProp), 	% Set table Properties
	test_GetColumnPropFromDialog(_Win,ColProp1,1),
	tableedit_SetColumnProperties(GridWin,1,ColProp1), % Set Column Properties to Column 1
	test_GetColumnPropFromDialog(_Win,ColProp2,2),
	tableedit_SetColumnProperties(GridWin,2,ColProp2), % Set Column Properties to Column 2
	win_Destroy(_Win),
	!.
%END PropDlg, idc_ok _CtlInfo

%BEGIN PropDlg, e_Create
  dlg_propdlg_eh(_Win,e_Create(_CreationData),0):-!,
	test_Info(GridWin),
	TabProp = tableedit_GetProperties(GridWin), % Get table Properties from table editor window
	test_SetTabProptoDialog(_Win,TabProp),
	Col1Prop1 = tableedit_GetColumnProperties(GridWin,1),	% Get Column Properties of column 1 
	test_SetColPropToDialog(_Win,Col1Prop1,1),		% from table editor window
	Col1Prop2 = tableedit_GetColumnProperties(GridWin,2),	% Get Column Properties of column 2 
	test_SetColPropToDialog(_Win,Col1Prop2,2),		% from table editor window
	!.
%END PropDlg, e_Create

  dlg_propdlg_eh(_,_,_):-!,fail.

%END_DLG PropDlg


%BEGIN_WIN Table Editor
/**************************************************************************
        Creation and event handling for window: Table Editor
**************************************************************************/

constants
%BEGIN Table Editor, CreateParms, 16:15:18-24.11.1999, Code automatically updated!
  win_table_editor_WinType = w_TopLevel
  win_table_editor_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Close,wsf_ClipSiblings,wsf_ClipChildren]
  win_table_editor_RCT = rct(100,100,550,450)
  win_table_editor_Menu = no_menu
  win_table_editor_Title = "Table Editor test"
  win_table_editor_Help = idh_contents
%END Table Editor, CreateParms

predicates

  win_table_editor_eh : EHANDLER

clauses

  win_table_editor_Create(_Parent):-
	not(test_Info(_)),
	win_Create(win_table_editor_WinType,win_table_editor_RCT,win_table_editor_Title,
		   win_table_editor_Menu,_Parent,win_table_editor_Flags,win_table_editor_eh,0),!.
  win_table_editor_Create(_Parent):-!.

%BEGIN Table Editor, e_Create
  win_table_editor_eh(_Win,e_Create(_),0):-!,
%BEGIN Table Editor, InitControls, 16:15:18-24.11.1999, Code automatically updated!
%END Table Editor, InitControls
%BEGIN Table Editor, ToolbarCreate, 16:15:18-24.11.1999, Code automatically updated!
%END Table Editor, ToolbarCreate
	RCT = win_GetClientRect(_Win),
	Wdef = wdef(wc_Custom,RCT,"",u_Pixels),
	WinDefList = [customctl(Wdef,tableed_class,tableed_id,[])],
	win_CreateDynControl(WinDefList,_Win),
	!.
%END Table Editor, e_Create
%MARK Table Editor, new events

%BEGIN Table Editor, e_CloseRequest
  win_table_editor_eh(_Win,e_CloseRequest,0):-!,
	TaskWin=vpi_GetTaskWin(),
	menu_Enable(TaskWin,"Test",b_false),
	menu_Enable(TaskWin,id_init,b_true),
	menu_Enable(TaskWin,id_initbuff,b_true),
	menu_Update(TaskWin),
	test_Info(GridWin),	% Send e_CloseRequest() to table editor custom control 
	tableedit_HandleEvent(GridWin,e_CloseRequest()),
	!. % from test window
%END Table Editor, e_CloseRequest

%BEGIN Table Editor, e_Size
  win_table_editor_eh(_Win,e_Size(_Width,_Height),0):-!,
ifdef use_tbar
	toolbar_Resize(_Win),
enddef
	test_Info(GridWin),
	RCT = win_GetClientRect(_Win),
	win_Move(GridWin,RCT),
	!.  % Move table editor custom control 
%END Table Editor, e_Size

%BEGIN Table Editor, e_Menu, Parent window 
  win_table_editor_eh(Win,e_Menu(ID,CAS),0):-!,
	PARENT = win_GetParent(Win),
	win_SendEvent(PARENT,e_Menu(ID,CAS)),
	!.
%END Table Editor, e_Menu, Parent window

%END_WIN Table Editor

% Application database handling
predicates
procedure  reverse(TABLEEDIT_DATA,TABLEEDIT_DATA,TABLEEDIT_DATA)
procedure  reverse(TABLEEDIT_COLUMNDATA,TABLEEDIT_COLUMNDATA,TABLEEDIT_COLUMNDATA)

procedure  insListRows(INTEGER FrRow,TABLEEDIT_DATA,TABLEEDIT_DATA,
		       TABLEEDIT_DATA,TABLEEDIT_DATA)

procedure  getDataFromToRow(INTEGER FrRow,
			    INTEGER ToRow,
			    TABLEEDIT_DATA,TABLEEDIT_DATA,TABLEEDIT_DATA)
procedure  setDataFromToRow(INTEGER Row,INTEGER FrRow,
			    INTEGER ToRow,INTEGER FrCol,INTEGER ToCol,
			    TABLEEDIT_DATA,TABLEEDIT_DATA,TABLEEDIT_DATA,
			    TABLEEDIT_DATA)
procedure  setDataFromToCol(INTEGER Row,
			    INTEGER Column,INTEGER FrCol,INTEGER ToCol,
			    TABLEEDIT_COLUMNDATA,TABLEEDIT_COLUMNDATA,
			    TABLEEDIT_COLUMNDATA,TABLEEDIT_COLUMNDATA)
procedure  delRow(INTEGER Row,TABLEEDIT_DATA,TABLEEDIT_DATA,TABLEEDIT_DATA)
clauses
  reverse([],IdList,IdList):-!.
  reverse([Id|Rest],IL,IdList):-!,
	reverse(Rest,[Id|IL],IdList).
  reverse(_,_,[]):-errorExit().

  deleteRowFromDatabase(Row):-
	buffData(Data),
	delRow(Row,Data,[],NewData),
	retract(buffData(_)),
	assert(buffData(NewData)),
	!.

  insertRowsToDatabase(Row,InsData):-
	buffData(Data),
	insListRows(Row,InsData,Data,[],NewData),
	retract(buffData(_)),
	assert(buffData(NewData)),
	!.

  delRow(_Row,[],DelData1,DelData2):-reverse(DelData1,[],DelData2),!.
  delRow(Row,[_Data|Rest],DD,DD1):- 
	R = Row - 1,
	R = 0,!,
	delRow(R,Rest,DD,DD1).
  delRow(Row,[Data|Rest],DD,DD1):- 
	R = Row - 1,!,
	delRow(R,Rest,[Data|DD],DD1).
  delRow(_,_,_,[]):- errorexit().

  insListRows(_FrRow,[],[],AData,ANewData):- reverse(AData,[],ANewData),!.
  insListRows(FrRow,[Data1|Rest1],Data2,AD,NewData):- 
	FrRow <= 1,
	FR = FrRow - 1,!,
	insListRows(FR,Rest1,Data2,[Data1|AD],NewData).
  insListRows(FrRow,Data1,[Data2|Rest2],AD,NewData):- 
	FR = FrRow - 1,!, 
	insListRows(FR,Data1,Rest2,[Data2|AD],NewData).
  insListRows(_,_,_,_,[]):- errorexit().

  setDataFromToRow(_Row,_FrRow,_ToRow,_FRColumn,_ToColumn,_InData,[],AData,ANewData):- reverse(AData,[],ANewData),!.
  setDataFromToRow(Row,FrRow,ToRow,FRColumn,ToColumn,[InData|InRest],[Data|Rest],AD,NewData):-
	FrRow <= 1, ToRow > 0,
	FR = FrRow - 1, TR = ToRow - 1,!,
	setDataFromToCol(Row,1,FRColumn,ToColumn,InData,Data,[],NewOutData),
	Row1 = Row + 1,
	setDataFromToRow(Row1,FR,TR,FRColumn,ToColumn,InRest,Rest,[NewOutData|AD],NewData).
  setDataFromToRow(Row,FrRow,ToRow,FRColumn,ToColumn,InD,[Data|Rest],AD,NewData):-
	FR = FrRow - 1, TR = ToRow - 1,Row1 = Row + 1,!, 
	setDataFromToRow(Row1,FR,TR,FRColumn,ToColumn,InD,Rest,[Data|AD],NewData).
  setDataFromToRow(_,_,_,_,_,_,_,_,[]):- errorexit().

  setDataFromToCol(_Row,_Col,_FrCol,_ToCol,_InData,[],AData,ANewData):- reverse(AData,[],ANewData),!.
  setDataFromToCol(Row,Col,FrCol,ToCol,[InData|InRest],[_Data|Rest],AD,NewData):-
	FrCol <= 1, ToCol > 0,
	FC = FrCol - 1, TC = ToCol - 1, Col1 = Col + 1,!,
	setDataFromToCol(Row,Col1,FC,TC,InRest,Rest,[InData|AD],NewData).
  setDataFromToCol(Row,Col,FrRow,ToRow,InD,[Data|Rest],AD,NewData):-
	FR = FrRow - 1, TR = ToRow - 1, Col1 = Col + 1,!,
	setDataFromToCol(Row,Col1,FR,TR,InD,Rest,[Data|AD],NewData).
  setDataFromToCol(_,_,_,_,_,_,_,[]):- errorexit().

  getDataFromToRow(_FrRow,_ToRow,[],AData,ANewData):- reverse(AData,[],ANewData),!.
  getDataFromToRow(_,0,_,AData,ANewData):-reverse(AData,[],ANewData),!.
  getDataFromToRow(FrRow,ToRow,[Data|Rest],AD,NewData):-
	FrRow <= 1, ToRow > 0,
	FR = FrRow - 1, TR = ToRow - 1,!,
	getDataFromToRow(FR,TR,Rest,[Data|AD],NewData).
  getDataFromToRow(FrRow,ToRow,[_Data|Rest],AD,NewData):-
	FR = FrRow - 1, TR = ToRow - 1,!, 
	getDataFromToRow(FR,TR,Rest,AD,NewData).
  getDataFromToRow(_,_,_,_,[]):-errorexit().

  setDataToDatabase(Row,Column,CellData):-
	InData = [[CellData]],
	retract(buffData(Data)),
	setDataFromToRow(1,Row,Row,Column,Column,InData,Data,[],NewData),
	assert(buffData(NewData)),
	!.

  getDataFromDatabase(FrRow,ToRow,OutData):-
	buffData(Data),
	getDataFromToRow(FrRow,ToRow,Data,[],OutData),
	!.

  assert_BuffDatabase():-
	retractAll(buffData(_)),

	P1 = p(fromres(idb_copy_dn),b_false,"Copy Down"),
	P2 = p(fromres(idb_copy_up),b_false,"Copy Up"),
	P3 = p(fromres(idb_cut_dn),b_false,"Cut Down"),
	P4 = p(fromres(idb_cut_up),b_false,"Cut Up"),

	assert(buffData(
		[ 
		  [r(1.0),s("1s"),sc("10-04-97",255),P1],
		  [r(2.0),s("2s"),sc("11-04-97",255),P2],
		  [r(3.0),s("3s"),sc("12-04-97",255),P3],
		  [r(4.0),s("4s"),sc("13-04-97",255),P4],
		  [r(5.0),s("5s"),sc("14-04-97",255),P1],
		  [r(6.0),s("6s"),void,P2],
		  [r(7.0),s("7s"),void,P3],
		  [r(8.0),s("8s"),void,P4],
		  [r(9.0),s("9s"),void,void],
		  [r(10.0),s("10s"),void,void],
		  [r(11.0),s("11s"),void,void],
		  [r(12.0),s("12s"),void,void],
		  [r(13.0),s("13s"),void,void],
		  [r(14.0),s("14s"),void,void],
		  [r(15.0),s("15s"),void,void],
		  [r(16.0),s("16s"),void,void],
		  [r(17.0),s("17s"),void,void],
		  [r(18.0),s("18s"),void,void],
		  [r(19.0),s("19s"),void,void],
		  [r(20.0),s("20s"),void,void],
		  [r(21.0),s("21s"),void,void],
		  [r(22.0),s("22s"),void,void],
		  [r(23.0),s("23s"),void,void],
		  [r(24.0),s("24s"),void,void],
		  [r(25.0),s("25s"),void,void],
		  [r(26.0),s("26s"),void,void],
		  [r(27.0),s("27s"),void,void],
		  [r(28.0),s("28s"),void,void],
		  [r(29.0),s("29s"),void,void],
		  [r(30.0),s("30s"),void,void],
		  [r(31.0),s("31s"),void,void],
		  [r(32.0),s("32s"),void,void],
		  [r(33.0),s("33s"),void,void],
		  [r(34.0),s("34s"),void,void],
		  [r(35.0),s("35s"),void,P1],
		  [r(36.0),s("36s"),void,P2],
		  [r(37.0),s("37s"),void,P3],
		  [r(38.0),s("38s"),void,P4],
		  [r(39.0),s("39s"),void,P3],
		  [r(40.0),s("40s"),void,P2]
		]
	)),
	!.










