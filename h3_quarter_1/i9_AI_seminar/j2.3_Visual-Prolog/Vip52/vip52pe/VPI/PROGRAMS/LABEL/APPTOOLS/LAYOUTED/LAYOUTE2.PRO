/******************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:	Label Expert
 FileName:	LAYOUTED.PRO
 Purpose:	Layout Editor
 Written by:	Sergey Alexeev
 Build:		008.981112
 Comments:
******************************************************************************/
ifdef  use_odbc
predicates
  le_odbc_GetBaseNameList(SLIST NameList)
  le_odbc_GetBaseNameList1(HENV,SLIST Null,SLIST NameList)
clauses
  le_odbc_GetBaseNameList(NameList):-
	trap(odbcAllocEnv(Henv),_,fail),
	trap(odbcDataSources(Henv,odbc_fetch_first,Name,_),_,fail),
	le_odbc_GetBaseNameList1(Henv,[Name],NameList),
	trap(odbcFreeEnv(Henv),_,fail),!.

  le_odbc_GetBaseNameList1(Henv,NL,NameList):-
	trap(odbcDataSources(Henv,odbc_fetch_next,Name,_),_,fail),!,
	le_odbc_GetBaseNameList1(Henv,[Name|NL],NameList).
  le_odbc_GetBaseNameList1(_,NameList,NameList).

predicates
  le_getBaseNameList(SLIST BaseNameList)
clauses
  le_getBaseNameList(BaseNameList):-
	le_odbc_GetBaseNameList(BaseNameList),!.
  le_getBaseNameList(_):-
	odbcGetError(_,ErrFunc,ErrMess),
	TaskWin1 = vpi_GetAttrVal(attr_task_window),
	TaskWin = cast(window,TaskWin1),
	format(ErrStr,label_msg2,ErrFunc,ErrMess),
	toolbar_SetValue(TaskWin,idt_help_line,text_value(ErrStr)),
	fail.

predicates
  le_dlg_base_eh	: EHANDLER
  le_get_base_name(WINDOW PWIN,STRING BaseName)
clauses
  le_get_base_name(PWIN,BaseName):-
	retractall(le_base_answer(_)),
	win_CreateDynDialog(PWIN,[
	dlg(wdef(wd_Modal,rct(10,10,300,300),label_msg3,u_Pixels),[wsf_Close,wsf_DlgBorder,wsf_TitleBar]),
	ctl(wdef(wc_LBox,rct(5,5,285,260),"",u_Pixels),1,[wsf_VScroll]),
	ctl(wdef(wc_PushButton,rct(25,260,125,285),label_msg180,u_Pixels),idc_ok,[]),
	ctl(wdef(wc_PushButton,rct(165,260,265,285),label_msg181,u_Pixels),idc_cancel,[])
	],le_dlg_base_eh,0),
	retract(le_base_answer(BaseName)),!.

  le_dlg_base_eh(Win,e_Create(_),0):-
	le_getBaseNameList(BaseNameList),
	Window = win_GetCtlHandle(Win,1),
	lbox_Add(Window,BaseNameList),!.
  le_dlg_base_eh(Win,e_Control(idc_ok,_,_,activated()),0):-
	Window = win_GetCtlHandle(Win,1),
	SelIndex = lbox_GetSelIndex(Window),
	BaseName = lbox_GetItem(Window,SelIndex),
	assert(le_base_answer(BaseName)),
	win_destroy(Win),!.
  le_dlg_base_eh(Win,e_Control(idc_cancel,_,_,activated()),0):-
	win_destroy(Win),!.
  le_dlg_base_eh(Win,e_Control(1,_,_,activated()),0):-
	Window = win_GetCtlHandle(Win,idc_ok),
	win_SendEvent(Win,e_Control(idc_ok,wc_PushButton,Window,activated())),!.
enddef
predicates
  le_redraw_fields(WINDOW LOWin,ILIST IdList)
clauses
  le_redraw_fields(LOWin,IdList):-
	layout_rectangle(LOWin,IdList,Rect),
	Rect = rct(L1,T1,R1,B1),
	le_min(L1,R1,L),
	le_max(L1,R1,R),
	le_min(T1,B1,T),
	le_max(T1,B1,B),
	win_Invalidate(LOWin,rct(L,T,R,B)),!.

predicates
  le_get_font(WINDOW LEWin,ILIST IdList,FONT)
clauses
  le_get_font(LEWin,IdList,Font):-
	IdList = [Id|_],
	le_field_info(LEWin,Id,_,Text),
	Text = text(_,Font,_,_,_,_,_,_,_),!.
  le_get_font(LEWin,IdList,Font):-
	IdList = [Id|_],
	le_field_info(LEWin,Id,_,Counter),
	Counter = counter(_,_,_,_,Font,_,_,_,_,_,_),!.

predicates
  le_change_font(WINDOW LEWin,ILIST IdList,FONT,STRING FontName)
  le_to_stack(LE_ACTION)
clauses
  le_change_font(_,[],_,_):-!.
  le_change_font(LEWin,[Id|Rest],Font,FontName):-
	le_field_info(LEWin,Id,Orientation,Text),
	Text = text(String,OldFont,OldFontName,TextColor,Align,Pen,Brush,Wrap,Barcode),
	retract(le_field_info(LEWin,Id,Orientation,_)),
	assert(le_field_info(LEWin,Id,Orientation,text(String,Font,FontName,TextColor,Align,Pen,Brush,Wrap,Barcode))),
	le_to_stack(init(LEWin,Id,Orientation,text(String,OldFont,OldFontName,TextColor,Align,Pen,Brush,Wrap,Barcode),
	Orientation,text(String,Font,FontName,TextColor,Align,Pen,Brush,Wrap,Barcode))),!,
	le_change_font(LEWin,Rest,Font,FontName).
  le_change_font(LEWin,[Id|Rest],Font,FontName):-
	le_field_info(LEWin,Id,Orientation,Counter),
	Counter = counter(Start,End,Step,DigitNumber,OldFont,OldFontName,TextColor,Align,Pen,Brush,Barcode),
	retract(le_field_info(LEWin,Id,Orientation,_)),
	assert(le_field_info(LEWin,Id,Orientation,counter(Start,End,Step,DigitNumber,Font,FontName,TextColor,Align,Pen,Brush,Barcode))),
	le_to_stack(init(LEWin,Id,Orientation,counter(Start,End,Step,DigitNumber,OldFont,OldFontName,TextColor,Align,Pen,Brush,Barcode),
	Orientation,counter(Start,End,Step,DigitNumber,Font,FontName,TextColor,Align,Pen,Brush,Barcode))),!,
	le_change_font(LEWin,Rest,Font,FontName).

predicates
  le_change_slist(WINDOW LEWin,ILIST IdList,SLIST)
clauses
  le_change_slist(_,[],_):-!.
  le_change_slist(LEWin,[Id|Rest],Slist):-
	retract(le_field_info(LEWin,Id,Orientation,text(dyntext(OldSlist),Font,FontName,TextColor,Align,Pen,Brush,Wrap,Barcode))),
	assert(le_field_info(LEWin,Id,Orientation,text(dyntext(Slist),Font,FontName,TextColor,Align,Pen,Brush,Wrap,Barcode))),
	le_to_stack(init(LEWin,Id,Orientation,text(dyntext(OldSlist),Font,FontName,TextColor,Align,Pen,Brush,Wrap,Barcode),
	Orientation,text(dyntext(Slist),Font,FontName,TextColor,Align,Pen,Brush,Wrap,Barcode))),!,
	le_change_slist(LEWin,Rest,Slist).

predicates
  le_change_filename(WINDOW LEWin,ILIST IdList,STRING FileName)
clauses
  le_change_filename(_,[],_):-!.
  le_change_filename(LEWin,[Id|Rest],FileName):-
	le_field_info(LEWin,Id,Orientation,Bitmap),
	Bitmap = bitmap(Pen,OldFileName,Stretch),
	retract(le_field_info(LEWin,Id,Orientation,_)),
	assert(le_field_info(LEWin,Id,Orientation,bitmap(Pen,FileName,Stretch))),
	le_to_stack(init(LEWin,Id,Orientation,bitmap(Pen,OldFileName,Stretch),
	Orientation,bitmap(Pen,FileName,Stretch))),!,
	le_change_filename(LEWin,Rest,FileName).
  le_change_filename(LEWin,[Id|Rest],FileName):-
	le_field_info(LEWin,Id,Orientation,TextFile),
	TextFile = text(ascii(OldFileName,From,To),Font,FontName,TextColor,Align,Pen,Brush,Wrap,Barcode),
	retract(le_field_info(LEWin,Id,Orientation,_)),
	assert(le_field_info(LEWin,Id,Orientation,text(ascii(FileName,From,To),Font,FontName,TextColor,Align,Pen,Brush,Wrap,Barcode))),
	le_to_stack(init(LEWin,Id,Orientation,text(ascii(OldFileName,From,To),Font,FontName,TextColor,Align,Pen,Brush,Wrap,Barcode),
	Orientation,text(ascii(FileName,From,To),Font,FontName,TextColor,Align,Pen,Brush,Wrap,Barcode))),!,
	le_change_filename(LEWin,Rest,FileName).
  le_change_filename(LEWin,[Id|Rest],BaseName):-
	le_field_info(LEWin,Id,Orientation,TextFile),
	TextFile = text(odbc(OldBaseName,Table,Column,User,Password),Font,FontName,TextColor,Align,Pen,Brush,Wrap,Barcode),
	retract(le_field_info(LEWin,Id,Orientation,_)),
	assert(le_field_info(LEWin,Id,Orientation,text(odbc(BaseName,Table,Column,User,Password),Font,FontName,TextColor,Align,Pen,Brush,Wrap,Barcode))),
	le_to_stack(init(LEWin,Id,Orientation,text(odbc(OldBaseName,Table,Column,User,Password),Font,FontName,TextColor,Align,Pen,Brush,Wrap,Barcode),
	Orientation,text(odbc(BaseName,Table,Column,User,Password),Font,FontName,TextColor,Align,Pen,Brush,Wrap,Barcode))),!,
	le_change_filename(LEWin,Rest,BaseName).
  le_change_filename(LEWin,[Id|Rest],FileName):-
	le_field_info(LEWin,Id,Orientation,TextFile),
	TextFile = text(dbase(OldFileName,Column),Font,FontName,TextColor,Align,Pen,Brush,Wrap,Barcode),
	retract(le_field_info(LEWin,Id,Orientation,_)),
	assert(le_field_info(LEWin,Id,Orientation,text(dbase(FileName,Column),Font,FontName,TextColor,Align,Pen,Brush,Wrap,Barcode))),
	le_to_stack(init(LEWin,Id,Orientation,text(dbase(OldFileName,Column),Font,FontName,TextColor,Align,Pen,Brush,Wrap,Barcode),
	Orientation,text(dbase(FileName,Column),Font,FontName,TextColor,Align,Pen,Brush,Wrap,Barcode))),!,
	le_change_filename(LEWin,Rest,FileName).
  le_change_filename(LEWin,[Id|Rest],FormatString):-
	le_field_info(LEWin,Id,Orientation,TextFile),
	TextFile = text(date(OldFormatString,Shift),Font,FontName,TextColor,Align,Pen,Brush,Wrap,Barcode),
	retract(le_field_info(LEWin,Id,Orientation,_)),
	assert(le_field_info(LEWin,Id,Orientation,text(date(FormatString,Shift),Font,FontName,TextColor,Align,Pen,Brush,Wrap,Barcode))),
	le_to_stack(init(LEWin,Id,Orientation,text(date(OldFormatString,Shift),Font,FontName,TextColor,Align,Pen,Brush,Wrap,Barcode),
	Orientation,text(date(FormatString,Shift),Font,FontName,TextColor,Align,Pen,Brush,Wrap,Barcode))),!,
	le_change_filename(LEWin,Rest,FormatString).

/*************************************************************************
			     LAYOUT CALLBACK FUNCTION
*************************************************************************/
predicates
  le_get_slist(WINDOW LEWin,ILIST IdList,SLIST,SLIST)
clauses
  le_get_slist(_,[],Slist,Slist):-!.
  le_get_slist(LEWin,[Id|Rest],Slist,OutSlist):-
	le_field_info(LEWin,Id,_,text(dyntext(Slist),_,_,_,_,_,_,_,_)),!,
	le_get_slist(LEWin,Rest,Slist,OutSlist).
  le_get_slist(_,_,_,[""]).

predicates
  le_convert_le_type(LE_FIELD_TYPE,LE_CREATE_TYPE)
clauses
  le_convert_le_type(rectangle(_,_),rectangle):-!.
  le_convert_le_type(ellipse(_,_),ellipse):-!.
  le_convert_le_type(line(_),line):-!.
  le_convert_le_type(bitmap(_,_,_),bitmap):-!.
  le_convert_le_type(text(_,_,_,_,_,_,_,_,_),text):-!.
  le_convert_le_type(counter(_,_,_,_,_,_,_,_,_,_,_),counter):-!.

  le_convert_type(line(_),line):-!.
  le_convert_type(ellipse(_,_),ellipse):-!.
  le_convert_type(_,rectangle):-!.

predicates
  le_size(WINDOW LOWin,ILIST IdList,INTEGER Width,INTEGER Height,ALIGN_PUSH)
clauses
  le_size(_,[],_,_,_):-!.
  le_size(LOWin,IdList,Width,Height,equal_all):-
	layout_size(LOWin,IdList,Width,Height),!.
  le_size(LOWin,[Id|Rest],Width,Height,equal_hor):-
	layout_rectangle(LOWin,[Id],Rect),
	Rect = rct(_,T,_,B),
	le_min(T,B,T1),
	le_max(T,B,B1),
	Height1 = (B1 - T1),
	layout_size(LOWin,[Id],Width,Height1),!,
	le_size(LOWin,Rest,Width,Height,equal_hor).
  le_size(LOWin,[Id|Rest],Width,Height,equal_ver):-
	layout_rectangle(LOWin,[Id],Rect),
	Rect = rct(L,_,R,_),
	le_min(L,R,L1),
	le_max(L,R,R1),
	Width1 = (R1 - L1),
	layout_size(LOWin,[Id],Width1,Height),!,
	le_size(LOWin,Rest,Width,Height,equal_ver).

predicates
  le_move(WINDOW OldLEWin,WINDOW NewLEWin,WINDOW LOWin,ILIST OldIdList,ILIST NewIdList,INTEGER OldPixInMM,
	INTEGER NewPixInMM,LAYOUT_RCTLIST NewRctList,LAYOUT_RCTLIST Empty,LAYOUT_RCTLIST NewNewRctList)
clauses
  le_move(_,_,_,[],_,_,_,_,Empty,NewNewRctList):-
	le_reverse(Empty,[],NewNewRctList),!.
  le_move(OldLEWin,NewLEWin,LOWin,[OldId|OldRest],[NewId|NewRest],OldPixInMM,NewPixInMM,[rct(L,T,R,B)|RctRest],Empty,NewNewRctList):-
	retract(le_field_info(OldLEWin,OldId,Orientation,Type)),
	assert(le_field_info(NewLEWin,NewId,Orientation,Type)),
	R1 = L + (R - L) * NewPixInMM / OldPixInMM, B1 = T + (B - T) * NewPixInMM / OldPixInMM,
	layout_rectangle(LOWin,[NewId],rct(L,T,R1,B1)),!,
	le_move(OldLEWin,NewLEWin,LOWin,OldRest,NewRest,OldPixInMM,NewPixInMM,RctRest,[rct(L,T,R1,B1)|Empty],NewNewRctList).

predicates
  le_copyF(WINDOW OldLEWin,WINDOW NewLEWin,WINDOW LOWin,ILIST OldIdList,ILIST NewIdList,INTEGER OldPixInMM,
	INTEGER NewPixInMM,LAYOUT_RCTLIST NewRctList,LAYOUT_RCTLIST Empty,LAYOUT_RCTLIST NewNewRctList)
clauses
  le_copyF(_,_,_,[],_,_,_,_,Empty,NewNewRctList):-
	le_reverse(Empty,[],NewNewRctList),!.
  le_copyF(OldLEWin,NewLEWin,LOWin,[OldId|OldRest],[NewId|NewRest],OldPixInMM,NewPixInMM,[rct(L,T,R,B)|RctRest],Empty,NewNewRctList):-
	le_field_info(OldLEWin,OldId,Orientation,Type),
	assert(le_field_info(NewLEWin,NewId,Orientation,Type)),
	R1 = L + (R - L) * NewPixInMM / OldPixInMM, B1 = T + (B - T) * NewPixInMM / OldPixInMM,
	layout_rectangle(LOWin,[NewId],rct(L,T,R1,B1)),!,
	le_copyF(OldLEWin,NewLEWin,LOWin,OldRest,NewRest,OldPixInMM,NewPixInMM,RctRest,[rct(L,T,R1,B1)|Empty],NewNewRctList).

predicates
  le_unedit(WINDOW Win)
clauses
  layout_cb(LOWin,event(Event),_):-
	le_layout(LEWin,_,LOWin,_,_),
	win_SendEvent(LEWin,Event),
	fail.
  layout_cb(LOWin,event(e_MouseDbl(pnt(X,Y),c_Nothing,mouse_button_left)),event_answer(stop)):-
	layout_get_field(LOWin,pnt(X,Y),Id),
	le_layout(LEWin,_,LOWin,_,_),
	le_edit(LEWin,Id),!.
  layout_cb(LOWin,event(e_MouseDown(pnt(X,Y),_,_)),event_answer(stop)):-
	le_layout(LEWin,_,LOWin,_,_),
	le_unedit(LEWin),
	retract(le_layout_size(LEWin,Align)),
	cursor_Set(LOWin,cursor_Arrow),
	win_ReleaseMouse(),
	layout_get_field(LOWin,pnt(X,Y),Id),
	layout_rectangle(LOWin,[Id],Rect),
	Rect = rct(L,T,R,B),
	le_min(L,R,L1),
	le_max(L,R,R1),
	le_min(T,B,T1),
	le_max(T,B,B1),
	layout_select(LOWin,IdList),
	Width = (R1 - L1), Height = (B1 - T1),
	le_size(LOWin,IdList,Width,Height,Align),!.
  layout_cb(LOWin,event(e_MouseDown(pnt(X,Y),c_Nothing,mouse_button_right)),event_answer(continue)):-
	layout_select(LOWin,IdList),
	layout_rectangle(LOWin,IdList,Rect),
	Rect = rct(L,T,R,B),
	L <= X, X <= R, T <= Y, Y <= B,
	retractall(le_move_right(_,_)),
	assert(le_move_right(X,Y)),!.
  layout_cb(LOWin,event(e_MouseUp(pnt(X,Y),c_Nothing,mouse_button_right)),event_answer(continue)):-
	retract(le_move_right(X,Y)),
	le_layout(LEWin,_,LOWin,_,_),
	PntList = win_MapPoints(LOWin,LEWin,[pnt(X,Y)]),
	PntList = [pnt(X1,Y1)],
	le_popup_menu(LEWin,pnt(X1,Y1)),!.
  layout_cb(_,event(e_MouseUp(_,c_Nothing,mouse_button_right)),event_answer(continue)):-
	retract(le_move_right(_,_)),!.
  layout_cb(LOWin,event(e_MouseUp(pnt(X,Y),c_Nothing,mouse_button_right)),event_answer(continue)):-
	le_layout(LEWin,_,LOWin,_,_),
	PntList = win_MapPoints(LOWin,LEWin,[pnt(X,Y)]),
	PntList = [pnt(X1,Y1)],
	le_popup_menu(LEWin,pnt(X1,Y1)),!.
  layout_cb(LOWin,event(e_GetFocus),event_answer(continue)):-
	le_layout(LEWin,_,LOWin,_,_),
	win_SendEvent(LEWin,e_GetFocus),!.
  layout_cb(LOWin,event(e_LoseFocus),event_answer(continue)):-
	le_layout(LEWin,_,LOWin,_,_),
	win_SendEvent(LEWin,e_LoseFocus),!.
  layout_cb(LOWin,event(e_MouseMove(pnt(X,Y),_,_)),event_answer(continue)):-
	le_layout(LEWin,_,LOWin,_,_),
	PntList = win_MapPoints(LOWin,LEWin,[pnt(X,Y)]),
	PntList = [pnt(X1,Y1)],
	le_scale(LEWin,HS_Win,VS_Win),
	scale_MovePnt(HS_Win,X1),
	scale_MovePnt(VS_Win,Y1),!.
  layout_cb(LOWin,user_action(select(IdList)),event_answer(continue)):-
	le_layout(LEWin,_,LOWin,_,_),
	le_scale(LEWin,HS_Win,VS_Win),
	layout_rectangle(LOWin,IdList,Rect),
	Rect = rct(L,T,R,B),
	le_min(L,R,L1),
	le_min(T,B,T1),
	le_max(L,R,R1),
	le_max(T,B,B1),
	PntList = win_MapPoints(LOWin,LEWin,[pnt(L1,T1),pnt(R1,B1)]),
	PntList = [pnt(L2,T2),pnt(R2,B2)],
	scale_MoveRct(HS_Win,L2,R2),
	scale_MoveRct(VS_Win,T2,B2),
%	le_to_stack(select(LEWin,IdList)),
	win_SendEvent(LEWin,e_GetFocus),!.
  layout_cb(LOWin,user_action(unSelect(_IdList)),event_answer(continue)):-
	le_layout(LEWin,_,LOWin,_,_),
	le_scale(LEWin,HS_Win,VS_Win),
	scale_RemoveRct(HS_Win),
	scale_RemoveRct(VS_Win),
%	le_to_stack(unselect(LEWin,IdList)),
	win_SendEvent(LEWin,e_GetFocus),!.
  layout_cb(LOWin,user_action(size(IdList,rct(L,T,R,B))),event_answer(continue)):-
	le_layout(LEWin,_,LOWin,_,_),
	layout_rectangle(LOWin,IdList,Rect),
	le_to_stack(size(LEWin,IdList,Rect,rct(L,T,R,B))),
	le_scale(LEWin,HS_Win,VS_Win),
	PntList = win_MapPoints(LOWin,LEWin,[pnt(L,T),pnt(R,B)]),
	PntList = [pnt(L1,T1),pnt(R1,B1)],
	scale_MoveRct(HS_Win,L1,R1),
	scale_MoveRct(VS_Win,T1,B1),
	le_auto_scroll(LEWin,rct(L1,T1,R1,B1)),!.
  layout_cb(OldLOWin,user_action(move(OldIdList,OldRctList,NewLOWin,NewIdList,NewRctList)),event_answer(continue)):-
	le_layout(OldLEWin,_,OldLOWin,_,_),
	le_layout(NewLEWin,_,NewLOWin,_,_),
	le_info(_,OldLEWin,_,_,_,_,_,_,_,OldPixInMM,_,_,_),
	le_info(_,NewLEWin,_,_,_,_,_,_,_,NewPixInMM,_,_,_),
	le_move(OldLEWin,NewLEWin,NewLOWin,OldIdList,NewIdList,OldPixInMM,NewPixInMM,NewRctList,[],NewNewRctList),
	le_reverse(OldIdList,[],OldIdList1),
	le_reverse(OldRctList,[],OldRctList1),
	le_reverse(NewIdList,[],NewIdList1),
	le_reverse(NewNewRctList,[],NewNewRctList1),
	le_to_stack(move(OldLEWin,OldIdList1,OldRctList1,NewLEWin,NewIdList1,NewNewRctList1)),!.
  layout_cb(OldLOWin,user_action(copy(OldIdList,OldRctList,NewLOWin,NewIdList,NewRctList)),event_answer(continue)):-
	le_layout(OldLEWin,_,OldLOWin,_,_),
	le_layout(NewLEWin,_,NewLOWin,_,_),
	le_info(_,OldLEWin,_,_,_,_,_,_,_,OldPixInMM,_,_,_),
	le_info(_,NewLEWin,_,_,_,_,_,_,_,NewPixInMM,_,_,_),
	le_copyF(OldLEWin,NewLEWin,NewLOWin,OldIdList,NewIdList,OldPixInMM,NewPixInMM,NewRctList,[],NewNewRctList),
	le_reverse(OldIdList,[],OldIdList1),
	le_reverse(OldRctList,[],OldRctList1),
	le_reverse(NewIdList,[],NewIdList1),
	le_reverse(NewNewRctList,[],NewNewRctList1),
	le_to_stack(copy(OldLEWin,OldIdList1,OldRctList1,NewLEWin,NewIdList1,NewNewRctList1)),!.
  layout_cb(LOWin,user_action(create(_,rct(L1,T1,R1,B1))),event_answer(stop)):-
	le_min(L1,R1,L),
	le_max(L1,R1,R),
	le_min(T1,B1,T),
	le_max(T1,B1,B),
	DX = R - L, DY = B - T,
	le_layout(LEWin,_,LOWin,_,_),
	le_info(_,LEWin,_,_,_,_,_,_,_,PixInMM,_,_,_),
	DX <= PixInMM, DY <= PixInMM,
	retract(le_field_info(LEWin,0,Orientation,Type)),
	le_convert_type(Type,Type1),
	R2 = L1 + 20 * PixInMM,
	B2 = T1 + 15 * PixInMM,
	layout_Create(LOWin,rct(L1,T1,R2,B2),Type1,Id),
	assert(le_field_info(LEWin,Id,Orientation,Type)),
	win_Invalidate(LOWin,rct(L1,T1,R2,B2)),
	le_to_stack(create(LEWin,Id,rct(L1,T1,R2,B2),Orientation,Type)),
	le_convert_le_type(Type,Type2),
	le_SetMode(LEWin,create_mode(Type2)),
	le_check_callback(LEWin,user_action(create_field)),!.
  layout_cb(LOWin,user_action(create(Id,Rect)),event_answer(continue)):-
	le_layout(LEWin,_,LOWin,_,_),
	retract(le_field_info(LEWin,0,Orientation,Type)),
	assert(le_field_info(LEWin,Id,Orientation,Type)),
	le_to_stack(create(LEWin,Id,Rect,Orientation,Type)),
	le_convert_le_type(Type,Type2),
	le_SetMode(LEWin,create_mode(Type2)),
	le_check_callback(LEWin,user_action(create_field)),!.
  layout_cb(LOWin,user_action(delete(Id,Rect)),event_answer(continue)):-
	le_layout(LEWin,_,LOWin,_,_),
	retract(le_field_info(LEWin,Id,Orientation,Type)),
	le_to_stack(delete(LEWin,Id,Rect,Orientation,Type)),!.
  layout_cb(LOWin,user_action(modified(_)),event_answer(continue)):-
	le_layout(LEWin,_,LOWin,_,_),
	le_check_callback(LEWin,user_action(modified)),
	win_SendEvent(LEWin,e_GetFocus),!.
  layout_cb(LOWin,user_action(draw(Id,Rect)),event_answer(continue)):-
	le_layout(LEWin,_,LOWin,_,_),
	le_info(_,LEWin,_,_,_,_,_,_,_,PixInMM,_,_,_),
	le_field_info(LEWin,Id,Orientation,line(Pen)),
	Rect = rct(L,T,R,B),
	L1 = L * 4 div PixInMM, T1 = T * 4 div PixInMM,
	R1 = L1 + (R - L) * 4 div PixInMM, B1 = T1 + (B - T) * 4 div PixInMM,
	win_SetMapScale(LOWin,pnt(0,0),pnt(4,4),pnt(0,0),pnt(PixInMM,PixInMM)),
	dr_draw_field(b_true,b_false,0,LOWin,1,rct(L1,T1,R1,B1),Orientation,line(Pen)),
	win_SetMapScale(LOWin,pnt(0,0),pnt(4,4),pnt(0,0),pnt(4,4)),!.
  layout_cb(LOWin,user_action(draw(Id,Rect)),event_answer(continue)):-
	le_layout(LEWin,_,LOWin,_,_),
	le_info(_,LEWin,_,_,_,_,_,_,_,PixInMM,_,_,_),
	le_field_info(LEWin,Id,Orientation,Type),
	Rect = rct(L,T,R,B),
	L1 = L * 4 div PixInMM, T1 = T * 4 div PixInMM,
	R1 = L1 + (R - L) * 4 div PixInMM, B1 = T1 + (B - T) * 4 div PixInMM,
	win_SetMapScale(LOWin,pnt(0,0),pnt(4,4),pnt(0,0),pnt(PixInMM,PixInMM)),
	win_SetClip(LOWin,rct(L,T,R,B)),
	dr_draw_field(b_true,b_false,0,LOWin,1,rct(L1,T1,R1,B1),Orientation,Type),
	win_SetMapScale(LOWin,pnt(0,0),pnt(4,4),pnt(0,0),pnt(4,4)),
	Rect1 = win_GetClientRect(LOWin),
	win_SetClip(LOWin,Rect1),!.

  le_date_redraw(LEWin):-
	le_field_info(LEWin,Id,_,text(date(_,_),_,_,_,_,_,_,_,_)),
	le_layout(LEWin,_,LOWin,_,_),
	layout_rectangle(LOWin,[Id],Rect),
	layout_cb(LOWin,user_action(draw(Id,Rect)),_),
	fail.
  le_date_redraw(_).

  le_max(A,B,A):-
	A > B,!.
  le_max(_,B,B).
  le_min(A,B,A):-
	A < B,!.
  le_min(_,B,B).

predicates
  le_cut_stack(LE_ACTIONLIST,LE_ACTIONLIST)
clauses
  le_cut_stack([_|[]],[]):-!.
  le_cut_stack([X|XS],[X|ZS]):-
     le_cut_stack(XS,ZS).
predicates
  le_stack_plus()
clauses
  le_stack_plus():-
	le_stack(Count),
	Count = le_max_stack,
	retract(le_undo_stack(ActionList)),
	le_cut_stack(ActionList,ActionList1),
	assert(le_undo_stack(ActionList1)),!.
  le_stack_plus():-
	retract(le_stack(Count)),
	C = Count + 1,
	assert(le_stack(C)),!.

predicates
  le_stack_minus()
clauses
  le_stack_minus():-
	le_stack(0),!,fail.
  le_stack_minus():-
	retract(le_stack(Count)),
	C = Count - 1,
	assert(le_stack(C)),!.

predicates
  le_rect_summ1(LAYOUT_RCTLIST,RCT,RCT)
clauses
  le_rect_summ1([],RectOut,RectOut):-!.
  le_rect_summ1([rct(L,T,R,B)|Rest],rct(L1,T1,R1,B1),RectOut):-
	le_min(L,L1,L2),
	le_min(L2,R1,L3),
	le_min(L3,R,L4),
	le_min(T,T1,T2),
	le_min(T2,B1,T3),
	le_min(T3,B,T4),
	le_max(R,R1,R2),
	le_max(R2,L1,R3),
	le_max(R3,L,R4),
	le_max(B,B1,B2),
	le_max(B2,T1,B3),
	le_max(B3,T,B4),!,
	le_rect_summ1(Rest,rct(L4,T4,R4,B4),RectOut).

predicates
  le_rect_summ(LAYOUT_RCTLIST,RCT)
clauses
  le_rect_summ([Rect|Rest],RectOut):-
	le_rect_summ1(Rest,Rect,RectOut),!.

predicates
  le_move_fields(WINDOW OldLEWin,WINDOW NewLEWin,WINDOW OldLOWin,WINDOW NewLOWin,ILIST OldIdList,ILIST NewIdList,LAYOUT_RCTLIST NewRctList)
clauses
  le_move_fields(_,_,_,_,[],_,_):-!.
  le_move_fields(OldLEWin,NewLEWin,OldLOWin,NewLOWin,[OldId|OldRest],[NewId|NewRest],[rct(L,T,R,B)|RctRest]):-
	retract(le_field_info(OldLEWin,OldId,Orientation,Type)),
	layout_delete(OldLOWin,[OldId]),
	le_convert_type(Type,Type1),
	layout_Create(NewLOWin,rct(L,T,R,B),Type1,NewId),
	assert(le_field_info(NewLEWin,NewId,Orientation,Type)),
	le_min(L,R,L1),
	le_max(L,R,R1),
	le_min(T,B,T1),
	le_max(T,B,B1),
	win_Invalidate(NewLOWin,rct(L1,T1,R1,B1)),!,
	le_move_fields(OldLEWin,NewLEWin,OldLOWin,NewLOWin,OldRest,NewRest,RctRest).

predicates
  le_copy_fields(WINDOW OldLEWin,WINDOW NewLEWin,WINDOW NewLOWin,ILIST OldIdList,ILIST NewIdList,LAYOUT_RCTLIST NewRctList)
clauses
  le_copy_fields(_,_,_,[],_,_):-!.
  le_copy_fields(OldLEWin,NewLEWin,NewLOWin,[OldId|OldRest],[NewId|NewRest],[rct(L,T,R,B)|RctRest]):-
	le_field_info(OldLEWin,OldId,Orientation,Type),
	le_convert_type(Type,Type1),
	layout_Create(NewLOWin,rct(L,T,R,B),Type1,NewId),
	assert(le_field_info(NewLEWin,NewId,Orientation,Type)),
	le_min(L,R,L1),
	le_max(L,R,R1),
	le_min(T,B,T1),
	le_max(T,B,B1),
	win_Invalidate(NewLOWin,rct(L1,T1,R1,B1)),!,
	le_copy_fields(OldLEWin,NewLEWin,NewLOWin,OldRest,NewRest,RctRest).

predicates
  le_del_fields(WINDOW LEWin,ILIST IdList)
clauses
  le_del_fields(_,[]):-!.
  le_del_fields(LEWin,[Id|Rest]):-
	retract(le_field_info(LEWin,Id,_,_)),!,
	le_del_fields(LEWin,Rest).

predicates
  le_check_stack(LE_ACTION,LE_ACTION)
clauses
  le_check_stack(_,_):-
	le_not_stack(),!,fail.
  le_check_stack(init(_,_,Orientation,Type,Orientation,Type),_):-!,fail.
  le_check_stack(size(_,_,Rect,Rect),_):-!,fail.
  le_check_stack(move(LEWin,_,Rect,LEWin,_,Rect),_):-!,fail.
  le_check_stack(move(LEWin,Id,RectList1,LEWin,_,RectList2),size(LEWin,Id,Rect1,Rect2)):-
	le_rect_summ(RectList1,Rect1),
	le_rect_summ(RectList2,Rect2),!.
  le_check_stack(select(LEWin,IdList),_):-
	le_undo_stack(ActionList),
	ActionList = [Action|ActionRest],
	Action = unselect(LEWin,IdList),
	retract(le_undo_stack(ActionList)),
	assert(le_undo_stack(ActionRest)),
	le_stack_minus(),!,fail.
  le_check_stack(unselect(LEWin,IdList),_):-
	le_undo_stack(ActionList),
	ActionList = [Action|ActionRest],
	Action = select(LEWin,IdList),
	retract(le_undo_stack(ActionList)),
	assert(le_undo_stack(ActionRest)),
	le_stack_minus(),!,fail.
  le_check_stack(Action,Action).

  le_to_stack(Action0):-
	le_check_stack(Action0,Action),
	retractall(le_redo_stack(_)),
	assert(le_redo_stack([])),
	retract(le_undo_stack(ActionList)),
	assert(le_undo_stack([Action|ActionList])),
	le_stack_plus(),!.
  le_to_stack(_).

predicates
  le_from_stack(LE_ACTION)
clauses
  le_from_stack(Action):-
	le_stack_minus(),
	retract(le_undo_stack([Action|ActionList])),
	assert(le_undo_stack(ActionList)),
	retract(le_redo_stack(ActionList1)),
	assert(le_redo_stack([Action|ActionList1])),!.

predicates
  le_from_stack1(LE_ACTION)
clauses
  le_from_stack1(_):-
	le_redo_stack([]),!,fail.
  le_from_stack1(Action):-
	retract(le_redo_stack([Action|ActionList])),
	assert(le_redo_stack(ActionList)),
	retract(le_undo_stack(ActionList1)),
	assert(le_undo_stack([Action|ActionList1])),
	le_stack_plus(),!.

predicates
  le_scale_off(WINDOW LEWin)
clauses
  le_scale_off(LEWin):-
	le_scale(LEWin,HS_Win,VS_Win),
	scale_RemoveRct(HS_Win),
	scale_RemoveRct(VS_Win),!.

predicates
  le_action(LE_ACTION)
clauses
  le_action(create(LEWin,Id,_,_,_)):-
	le_scale_off(LEWin),
	retract(le_field_info(LEWin,Id,_,_)),
	le_layout(LEWin,_,LOWin,_,_),
	layout_delete(LOWin,[Id]),!.
  le_action(delete(LEWin,_,Rect,Orientation,Type)):-
	le_scale_off(LEWin),
	le_layout(LEWin,_,LOWin,_,_),
	le_convert_type(Type,Type1),
	layout_Create(LOWin,Rect,Type1,Id),
	assert(le_field_info(LEWin,Id,Orientation,Type)),
	retract(le_redo_stack([_|ActionList])),
	assert(le_redo_stack([delete(LEWin,Id,Rect,Orientation,Type)|ActionList])),
	Rect = rct(L,T,R,B),
	le_min(L,R,L1),
	le_max(L,R,R1),
	le_min(T,B,T1),
	le_max(T,B,B1),
	win_Invalidate(LOWin,rct(L1,T1,R1,B1)),!.
  le_action(move(LEWin1,IdList1,RectList,LEWin2,IdList2,_)):-
	le_scale_off(LEWin1),
	le_scale_off(LEWin2),
	le_layout(LEWin2,_,LOWin2,_,_),
	le_layout(LEWin1,_,LOWin1,_,_),
	le_move_fields(LEWin2,LEWin1,LOWin2,LOWin1,IdList2,IdList1,RectList),!.
  le_action(copy(_,_,_,LEWin,IdList,_)):-
	le_scale_off(LEWin),
	le_del_fields(LEWin,IdList),
	le_layout(LEWin,_,LOWin,_,_),
	layout_delete(LOWin,IdList),!.
  le_action(size(LEWin,IdList,Rect,_)):-
	le_scale_off(LEWin),
	le_layout(LEWin,_,LOWin,_,_),
	layout_rectangle(LOWin,IdList,Rect),!.
  le_action(select(LEWin,_)):-
	le_scale_off(LEWin),
	le_layout(LEWin,_,LOWin,_,_),
	layout_unselect(LOWin),!.
  le_action(unselect(LEWin,IdList)):-
	le_scale_off(LEWin),
	le_layout(LEWin,_,LOWin,_,_),
	layout_select(LOWin,IdList),!.
  le_action(init(LEWin,Id,Orientation,Type,_,_)):-
	le_scale_off(LEWin),
	retract(le_field_info(LEWin,Id,_,_)),
	assert(le_field_info(LEWin,Id,Orientation,Type)),
	le_layout(LEWin,_,LOWin,_,_),
	le_redraw_fields(LOWin,[Id]),
	le_check_callback(LEWin,user_action(modified)),!.
  le_action(direction(LEWin,IdList,_)):-
	le_scale_off(LEWin),
	le_layout(LEWin,_,LOWin,_,_),
	layout_fields(LOWin,IdList),
	layout_rectangle(LOWin,IdList,Rect),
	win_Invalidate(LOWin,Rect),!.

predicates
  le_action1(LE_ACTION)
clauses
  le_action1(create(LEWin,_,Rect,Orientation,Type)):-
	le_layout(LEWin,_,LOWin,_,_),
	le_convert_type(Type,Type1),
	layout_Create(LOWin,Rect,Type1,Id),
	assert(le_field_info(LEWin,Id,Orientation,Type)),
	retract(le_undo_stack([_|ActionList])),
	assert(le_undo_stack([create(LEWin,Id,Rect,Orientation,Type)|ActionList])),
	Rect = rct(L,T,R,B),
	le_min(L,R,L1),
	le_max(L,R,R1),
	le_min(T,B,T1),
	le_max(T,B,B1),
	win_Invalidate(LOWin,rct(L1,T1,R1,B1)),!.
  le_action1(delete(LEWin,Id,_,_,_)):-
	retract(le_field_info(LEWin,Id,_,_)),
	le_layout(LEWin,_,LOWin,_,_),
	layout_delete(LOWin,[Id]),!.
  le_action1(move(LEWin1,IdList1,_,LEWin2,IdList2,RectList)):-
	le_scale_off(LEWin1),
	le_scale_off(LEWin2),
	le_layout(LEWin2,_,LOWin2,_,_),
	le_layout(LEWin1,_,LOWin1,_,_),
	le_move_fields(LEWin1,LEWin2,LOWin1,LOWin2,IdList1,IdList2,RectList),!.
  le_action1(copy(LEWin1,IdList1,_,LEWin2,IdList2,RectList)):-
	le_scale_off(LEWin1),
	le_scale_off(LEWin2),
	le_layout(LEWin2,_,LOWin2,_,_),
	le_copy_fields(LEWin1,LEWin2,LOWin2,IdList1,IdList2,RectList),!.
  le_action1(size(LEWin,IdList,_,Rect)):-
	le_layout(LEWin,_,LOWin,_,_),
	layout_rectangle(LOWin,IdList,Rect),!.
  le_action1(select(LEWin,IdList)):-
	le_layout(LEWin,_,LOWin,_,_),
	layout_select(LOWin,IdList),!.
  le_action1(unselect(LEWin,_)):-
	le_layout(LEWin,_,LOWin,_,_),
	layout_unselect(LOWin),!.
  le_action1(init(LEWin,Id,_,_,Orientation,Type)):-
	retract(le_field_info(LEWin,Id,_,_)),
	assert(le_field_info(LEWin,Id,Orientation,Type)),
	le_layout(LEWin,_,LOWin,_,_),
	le_redraw_fields(LOWin,[Id]),
	le_check_callback(LEWin,user_action(modified)),!.
  le_action1(direction(LEWin,_,IdList)):-
	le_layout(LEWin,_,LOWin,_,_),
	layout_fields(LOWin,IdList),
	layout_rectangle(LOWin,IdList,Rect),
	win_Invalidate(LOWin,Rect),!.

  le_undo():-
	le_from_stack(Action),
	assert(le_not_stack()),
	le_action(Action),
	retract(le_not_stack()),!.
  le_undo().

  le_redo():-
	le_from_stack1(Action),
	assert(le_not_stack()),
	le_action1(Action),
	retract(le_not_stack()),!.
  le_redo().

  le_cut(LEWin,IdList):-
	le_copy(LEWin,IdList),
	le_layout(LEWin,_,LOWin,_,_),
	layout_delete(LOWin,IdList),!.

predicates
  le_copy1(WINDOW Win,INTEGER PixInMM,ILIST IdList,STRING)
clauses
  le_copy(_,[]):-!.
  le_copy(LEWin,IdList):-
	le_reverse(IdList,[],IdList1),
	le_info(_,LEWin,_,_,_,_,_,_,_,PixInMM,_,_,_),
	le_copy1(LEWin,PixInMM,IdList1,""),!.

  le_copy1(_,_,[],String):-
	format(StringData,"Layout:%s#",String),
	cb_PutString(StringData),!.
  le_copy1(LEWin,PixInMM,[Id|Rest],Str):-
	le_field_info(LEWin,Id,Orientation,Type),
	le_layout(LEWin,_,LOWin,_,_),
	layout_rectangle(LOWin,[Id],Rect),
	Rect = rct(L,T,R,B),
	L1 = L / PixInMM, T1 = T / PixInMM, R1 = R / PixInMM, B1 = B / PixInMM,
	Rect1 = le_rct(L1,T1,R1,B1),
	term_str(le_rct,Rect1,RectStr),
	term_str(le_field_orientation,Orientation,OrientationStr),
	term_str(le_field_type,Type,TypeStr),
	format(String,"%s#%s#%s#%s",Str,RectStr,OrientationStr,TypeStr),!,
	le_copy1(LEWin,PixInMM,Rest,String).

predicates
  le_paste1(WINDOW Win,INTEGER PixInMM,INTEGER HorStep,INTEGER VerStep,STRING,ILIST,ILIST)
clauses
  le_paste(LEWin):-
	cb_StringAvailable(),
	StringData = cb_GetString(),
	searchstring(StringData,"Layout:",Pos),
	Pos1 = Pos + 6,
	frontstr(Pos1,StringData,_,String),
	le_layout(LEWin,_,LOWin,_,_),
	layout_grid(LOWin,HorStep,VerStep,_,_),
	le_info(_,LEWin,_,_,_,_,_,_,_,PixInMM,_,_,_),
	le_paste1(LEWin,PixInMM,HorStep,VerStep,String,[],IdList),
	layout_select(LOWin,IdList),
	le_copy(LEWin,IdList),!.
  le_paste(_).

predicates
  INTEGER le_paste2(WINDOW Win,RCT,LE_FIELD_ORIENTATION,LE_FIELD_TYPE)
clauses
  le_paste1(LEWin,PixInMM,HorStep,VerStep,String,IDL,IdList):-
	frontchar(String,_,String1),
	searchchar(String1,'#',Pos),
	Pos1 = Pos - 1,
	frontstr(Pos1,String1,RectStr,String2),
	frontchar(String2,_,String3),
	searchchar(String3,'#',Pos2),
	Pos3 = Pos2 - 1,
	frontstr(Pos3,String3,OrientationStr,String4),
	frontchar(String4,_,String5),
	searchchar(String5,'#',Pos4),
	Pos5 = Pos4 - 1,
	frontstr(Pos5,String5,FieldTypeStr,String6),
	term_str(le_rct,Rect1,RectStr),
	term_str(le_field_orientation,Orientation,OrientationStr),
	term_str(le_field_type,FieldType,FieldTypeStr),
	Rect1 = le_rct(L,T,R,B),
	L1 = L * PixInMM, T1 = T * PixInMM, R1 = R * PixInMM, B1 = B * PixInMM,
	L2 = L1 + HorStep, T2 = T1 + VerStep, R2 = R1 + HorStep, B2 = B1 + VerStep,
	Id = le_paste2(LEWin,rct(L2,T2,R2,B2),Orientation,FieldType),!,
	le_paste1(LEWin,PixInMM,HorStep,VerStep,String6,[Id|IDL],IdList).
  le_paste1(_,_,_,_,_,IdList,IdList).

  le_paste2(LEWin,Rect,Orientation,Type,Id):-
	le_layout(LEWin,_,LOWin,_,_),
	le_convert_type(Type,Type1),
	layout_Create(LOWin,Rect,Type1,Id),
	assert(le_field_info(LEWin,Id,Orientation,Type)),
	win_Invalidate(LOWin,Rect),!.
  le_paste2(_,_,_,_,0).

predicates
  le_align_text(LE_TEXT_ALIGN,BOOLEAN Wrap,CTL_FLAGS)
clauses
  le_align_text(left,b_false,[ctl_MultiLine,ctl_AutoHScroll,ctl_AutoVScroll,ctl_WantReturn,ctl_AlignLeft]):-!.
  le_align_text(right,b_false,[ctl_MultiLine,ctl_AutoHScroll,ctl_AutoVScroll,ctl_WantReturn,ctl_AlignRight]):-!.
  le_align_text(center,b_false,[ctl_MultiLine,ctl_AutoHScroll,ctl_AutoVScroll,ctl_WantReturn,ctl_AlignCenter]):-!.
  le_align_text(left,b_true,[ctl_MultiLine,ctl_AutoVScroll,ctl_WantReturn,ctl_AlignLeft]):-!.
  le_align_text(right,b_true,[ctl_MultiLine,ctl_AutoVScroll,ctl_WantReturn,ctl_AlignRight]):-!.
  le_align_text(center,b_true,[ctl_MultiLine,ctl_AutoVScroll,ctl_WantReturn,ctl_AlignCenter]):-!.

predicates
  le_str_len(STRING,UNSIGNED Length)
  le_str_len1(STRING,UNSIGNED,UNSIGNED Length)
clauses
  le_str_len(String,Length):-
	le_str_len1(String,0,Length),!.

  le_str_len1(String,L,Length):-
	frontchar(String,FrontChar,RestString),
	FrontChar = '\n',
	L1 = L + 2,!,
	le_str_len1(RestString,L1,Length).
  le_str_len1(String,L,Length):-
	frontchar(String,_,RestString),
	L1 = L + 1,!,
	le_str_len1(RestString,L1,Length).
  le_str_len1(_,Length,Length).

predicates
  le_dyntext_edit(WINDOW LEWin,SLIST SlistOld,SLIST SlistNew)
clauses
  le_edit(LEWin,Id,Char):-
	le_field_info(LEWin,Id,_,text(text(_),Font,_,_,Align,_,_,Wrap,_)),
	str_char(String,Char),
	le_layout(LEWin,_,LOWin,_,_),
	layout_rectangle(LOWin,[Id],Rect),
	layout_unselect(LOWin),
	le_align_text(Align,Wrap,Flags),
	EditWin = win_CreateControl(wc_edit,Rect,String,LOWin,Flags,777),
	assert(le_edit_info(LEWin,Id,EditWin)),
	win_ValidateRect(LOWin,Rect),
	win_SetFont(EditWin,Font),
	trap(win_SetFocus(EditWin),_,true),
	le_str_len(String,Length),
	win_SelectText(EditWin,Length,Length),!.
  le_edit(_,_,_).
  le_edit(LEWin,Id):-
	le_field_info(LEWin,Id,_,text(text(String),Font,_,_,Align,_,_,Wrap,_)),
	le_layout(LEWin,_,LOWin,_,_),
	layout_rectangle(LOWin,[Id],Rect),
	layout_unselect(LOWin),
	le_align_text(Align,Wrap,Flags),
	EditWin = win_CreateControl(wc_edit,Rect,String,LOWin,Flags,777),
	assert(le_edit_info(LEWin,Id,EditWin)),
	win_ValidateRect(LOWin,Rect),
	win_SetFont(EditWin,Font),
	trap(win_SetFocus(EditWin),_,true),
	le_str_len(String,Length),
	win_SelectText(EditWin,0,Length),!.
  le_edit(LEWin,Id):-
	le_field_info(LEWin,Id,_,text(dyntext(OldSlist),_,_,_,_,_,_,_,_)),
	le_dyntext_edit(LEWin,OldSlist,Slist),
	retract(le_field_info(LEWin,Id,Orientation,text(dyntext(_),Font,FontName,TextColor,Align,Pen,Brush,Wrap,Barcode))),
	assert(le_field_info(LEWin,Id,Orientation,text(dyntext(Slist),Font,FontName,TextColor,Align,Pen,Brush,Wrap,Barcode))),
	le_to_stack(init(LEWin,Id,Orientation,text(dyntext(OldSlist),Font,FontName,TextColor,Align,Pen,Brush,Wrap,Barcode),
	Orientation,text(dyntext(Slist),Font,FontName,TextColor,Align,Pen,Brush,Wrap,Barcode))),
	le_layout(LEWin,_,LOWin,_,_),
	le_redraw_fields(LOWin,[Id]),!.
  le_edit(_,_).

  le_unedit(LEWin):-
	retract(le_edit_info(LEWin,Id,EditWin)),
	String = win_GetText(EditWin),
	win_Destroy(EditWin),
	retract(le_field_info(LEWin,Id,Orientation,text(text(OldString),Font,FontName,TextColor,Align,Pen,Brush,Wrap,Barcode))),
	assert(le_field_info(LEWin,Id,Orientation,text(text(String),Font,FontName,TextColor,Align,Pen,Brush,Wrap,Barcode))),
	le_to_stack(init(LEWin,Id,Orientation,text(text(OldString),Font,FontName,TextColor,Align,Pen,Brush,Wrap,Barcode),
	Orientation,text(text(String),Font,FontName,TextColor,Align,Pen,Brush,Wrap,Barcode))),!.
  le_unedit(_).

predicates
  le_style_eh : EHANDLER
  le_grid_handler : EHANDLER
  le_grid_callback : GRID_CALLBACK
clauses
  le_dyntext_edit(_,_,[]):-
	dyntext_fact(_),!.
  le_dyntext_edit(LEWin,Slist,SlistNew):-
	assert(dyntext_fact(Slist)),
	class_Create("grid",le_grid_handler),
	L = 50, T = 70,
	R = L + 403, B = T + 303,
	win_CreateDynDialog(LEWin,[
		dlg(wdef(wd_Modal,rct(L,T,R,B),label_msg244,u_Pixels),[wsf_TitleBar,wsf_Close]),
		customctl(wdef(wc_custom,rct(5,5,241,300),"",u_Pixels),"grid",777,[]),
		ctl(wdef(wc_PushButton,rct(253,5,394,30),label_msg180,u_Pixels),779,[]),
		ctl(wdef(wc_PushButton,rct(253,40,394,65),label_msg181,u_Pixels),780,[]),
		ctl(wdef(wc_PushButton,rct(253,75,394,100),label_msg115,u_Pixels),781,[]),
		ctl(wdef(wc_PushButton,rct(253,110,394,135),label_msg117,u_Pixels),782,[])
	],le_style_eh,0),
	class_Destroy("grid"),
	retract(dyntext_fact(SlistNew)),!.

predicates
  le_replace_string(SLIST Old,INTEGER Index,STRING,SLIST New)
  le_add_string(SLIST Old,INTEGER Index,STRING,SLIST New)
  le_del_string(SLIST Old,INTEGER Index,SLIST New)
clauses
  le_add_string([YS1|XS],1,YS,[YS1,YS|XS]):-!.
  le_add_string([X|XS],Count,YS,[X|ZS]):-
	C = Count - 1,
	le_add_string(XS,C,YS,ZS).

  le_del_string([_|XS],1,XS):-!.
  le_del_string([X|XS],Count,[X|ZS]):-
	C = Count - 1,
     le_del_string(XS,C,ZS).

  le_replace_string([_|XS],1,YS,[YS|XS]):-!.
  le_replace_string([X|XS],Count,YS,[X|ZS]):-
	C = Count - 1,
	le_replace_string(XS,C,YS,ZS).


  le_style_eh(Win,e_Create(_),0):-
	GridWin = win_GetCtlHandle(Win,777),
	grid_Marker(GridWin,grid_row_marker([gl(1,1)])),
	le_font(Font),
	Ctl1 = win_GetCtlHandle(Win,779),
	win_SetFont(Ctl1,Font),
	Ctl2 = win_GetCtlHandle(Win,780),
	win_SetFont(Ctl2,Font),
	Ctl3 = win_GetCtlHandle(Win,781),
	win_SetFont(Ctl3,Font),
	Ctl4 = win_GetCtlHandle(Win,782),
	win_SetFont(Ctl4,Font),!.

  le_style_eh(_,e_CloseRequest(),0):-
	retract(dyntext_fact(_)),!,
	fail.
  le_style_eh(Win,e_Control(779,_,_,activated()),0):-
	win_Destroy(Win),!.
  le_style_eh(Win,e_Control(780,_,_,activated()),0):-
	retract(dyntext_fact(_)),!,
	win_Destroy(Win),!.
  le_style_eh(Win,e_Control(781,_,_,activated()),0):-
	GridWin = win_GetCtlHandle(Win,777),
	grid_Marker(GridWin,Marker),
	Marker = grid_row_marker([gl(Row,_)]),
	retract(dyntext_fact(Slist)),
	le_add_string(Slist,Row,"",NewSlist),
	assert(dyntext_fact(NewSlist)),
	grid_Rows(GridWin,MaxRows),
	MaxRows1 = MaxRows + 1,
	grid_Rows(GridWin,MaxRows1),
	Row1 = Row + 1,
	grid_Marker(GridWin,grid_edit_cell(Row1,1)),!.
  le_style_eh(Win,e_Control(781,_,_,activated()),0):-
	GridWin = win_GetCtlHandle(Win,777),
	grid_Marker(GridWin,Marker),
	Marker = grid_edit_cell(Row,_),
	retract(dyntext_fact(Slist)),
	le_add_string(Slist,Row,"",NewSlist),
	assert(dyntext_fact(NewSlist)),
	grid_Rows(GridWin,MaxRows),
	MaxRows1 = MaxRows + 1,
	grid_Rows(GridWin,MaxRows1),
	Row1 = Row + 1,
	grid_Marker(GridWin,grid_edit_cell(Row1,1)),!.
  le_style_eh(Win,e_Control(782,_,_,activated()),0):-
	GridWin = win_GetCtlHandle(Win,777),
	grid_Rows(GridWin,MaxRows),
	MaxRows > 1,
	grid_Marker(GridWin,Marker),
	Marker = grid_edit_cell(Row,_),
	grid_Marker(GridWin,grid_row_marker([gl(Row,Row)])),
	fail.
  le_style_eh(Win,e_Control(782,_,_,activated()),0):-
	GridWin = win_GetCtlHandle(Win,777),
	grid_Rows(GridWin,MaxRows),
	MaxRows > 1,
	grid_Marker(GridWin,Marker),
	Marker = grid_row_marker([gl(Row,_)]),
	retract(dyntext_fact(Slist)),
	le_del_string(Slist,Row,NewSlist),
	assert(dyntext_fact(NewSlist)),
	MaxRows1 = MaxRows - 1,
	grid_Rows(GridWin,MaxRows1),
	Row > MaxRows1,
	grid_Marker(GridWin,grid_row_marker([gl(MaxRows1,MaxRows1)])),!.

predicates
  le_listlength(SLIST,INTEGER)
clauses
  le_listlength([],0):-!.
  le_listlength([_|T],N1):-
	le_listlength(T,N),
	N1=N+1.

predicates
  le_member_index(STRING,SLIST,UNSIGNED)
clauses
  le_member_index(S,[S|_],1):-!.
  le_member_index(S,[_|L],M):-
        bound(M),!,
        N = M - 1,
        le_member_index(S,L,N),!.
  le_member_index(S,[_|L],M):-
        le_member_index(S,L,N),!,
        M = N + 1.

  le_grid_handler(GridWin,e_Create(_),0):-
	le_font(Font),
	dyntext_fact(Slist),
	le_listlength(Slist,Num),
	grid_Init(GridWin,grid_style(grid_raised,color_gray,color_gray,0xC0DCC0,color_LtGray,color_Blue),
		grid_rowstyle(35,Num,1,grid_number,b_false),
		grid_columnstyle(0,[grid_col(label_msg107,200,grid_left_align,grid_center,5,0,100)
			]),le_grid_callback),
	win_SetFont(GridWin,Font),!.

  le_grid_handler(GridWin,Event,0):-
  	grid_HandleEvent(GridWin,Event).

predicates
  le_get_data(INTEGER From_Row,INTEGER To_Row,INTEGER From_Column,
	INTEGER To_Column,GRIDLIST2D,GRIDLIST2D)
  le_get_data1(INTEGER Row,INTEGER From_Column,INTEGER To_Column,
	GRIDLIST,GRIDLIST)
  le_get_data2(INTEGER Row,INTEGER Column,GRIDTEXT)
clauses
  le_grid_callback(Win,
		 user_action(grid_row_marker_beg(Row)),
		 event_answer(stop)):-
	grid_Marker(Win,grid_row_marker([gl(Row,Row)])),!.
  le_grid_callback(_,
		 user_action(modified(Row,_,String)),
		 event_answer(continue)):-
	retract(dyntext_fact(Slist)),
	le_replace_string(Slist,Row,String,NewSlist),
	assert(dyntext_fact(NewSlist)),!.
  le_grid_callback(GridWin,
		 user_action(grid_vscroll_create),
		 event_answer(continue)):-
	ScrollWidth = vpi_GetAttrVal(attr_ctl_vert_sbar_width),
	grid_ColumnStyle(GridWin,OldColumnStyle),
	OldColumnStyle = grid_columnstyle(0,[grid_col(Name,OldWidth,HorzAlign,VertAlign,DX,DY,MaxChars)]),
	Width = OldWidth - ScrollWidth,
	grid_ColumnStyle(GridWin,grid_columnstyle(0,[grid_col(Name,Width,HorzAlign,VertAlign,DX,DY,MaxChars)])),!.
  le_grid_callback(GridWin,
		 user_action(grid_vscroll_destroy),
		 event_answer(continue)):-
	ScrollWidth = vpi_GetAttrVal(attr_ctl_vert_sbar_width),
	grid_ColumnStyle(GridWin,OldColumnStyle),
	OldColumnStyle = grid_columnstyle(0,[grid_col(Name,OldWidth,HorzAlign,VertAlign,DX,DY,MaxChars)]),
	Width = OldWidth + ScrollWidth,
	grid_ColumnStyle(GridWin,grid_columnstyle(0,[grid_col(Name,Width,HorzAlign,VertAlign,DX,DY,MaxChars)])),!.
  le_grid_callback(_,
		 user_action(grid_col_marker_beg(_)),
		 event_answer(stop)):-!.
  le_grid_callback(_,
		 user_action(grid_resize_column_beg(_)),
		 event_answer(stop)):-!.
  le_grid_callback(_,
		 user_action(grid_marker(grid_all_marker,_)),
		 event_answer(stop)):-!.

  le_grid_callback(_Win,data_request(grid_area(From_Row,To_Row,From_Column,To_Column)),
				data_answer(grid_area_answer(CellList))):-
	le_get_data(From_Row,To_Row,From_Column,To_Column,[],CellList),!.

  le_get_data(From_Row,To_Row,_,_,CellList2d,CellList2d):-
	From_Row > To_Row,!.
  le_get_data(From_Row,To_Row,From_Column,To_Column,List2d,CellList2d):-
	le_get_data1(To_Row,From_Column,To_Column,[],List),
	TR = To_Row - 1,
	le_get_data(From_Row,TR,From_Column,To_Column,[List|List2d],CellList2d),!.

  le_get_data1(_,From_Column,To_Column,CellList,CellList):-
	From_Column > To_Column,!.
  le_get_data1(Row,From_Column,To_Column,List,CellList):-
	le_get_data2(Row,To_Column,Answer),
	TC = To_Column - 1,
	le_get_data1(Row,From_Column,TC,[Answer|List],CellList),!.

  le_get_data2(Row,_,textatr(String,color_Black,color_LtGray)):-
	dyntext_fact(Slist),
	le_member_index(String,Slist,Row),!.

predicates
  le_prop_cb : Property_Callback
  le_change_prop(WINDOW LEWin,WINDOW LOWin,ILIST IdList,INTEGER PrId,PROPERTY_CTRLVAL)
  le_prop_status2(WINDOW LEWin,ILIST)
  le_get_format_string(WINDOW PWIN,STRING FormatString)
  le_page_setup(INTEGER PrId)
clauses
  le_page_setup(le_PAGE_SIZE):-!.
  le_page_setup(le_PAGE_NUMB):-!.
  le_page_setup(le_PAGE_ORIENT):-!.

  le_prop_cb(Win,is_ToBeDestroyed):-
	retract(le_property(_)),
	le_check_callback1(Win,user_action(property_destroy)),!,fail.

  le_prop_cb(PRWin,modified(Id)):-
	le_focus_win(LEWin),
	le_layout(LEWin,_,LOWin,_,_),
	layout_select(LOWin,IdList),
	Value = propedit_GetValue(PRWin,Id),
	le_change_prop(LEWin,LOWin,IdList,Id,Value),
	le_prop_status2(LEWin,IdList),!,
	fail.

  le_prop_cb(PRWin,callPBPressed(le_Text_String)):-
	le_focus_win(LEWin),
	le_layout(LEWin,_,LOWin,_,_),
	layout_select(LOWin,IdList),
	IdList = [Id|_],
	le_field_info(LEWin,Id,_,text(dyntext(InitSlist),_,_,_,_,_,_,_,_)),!,
	le_get_slist(LEWin,IdList,InitSlist,OldSlist),
	le_dyntext_edit(LEWin,OldSlist,Slist),
	not(Slist=[]),
	le_change_slist(LEWin,IdList,Slist),
	le_redraw_fields(LOWin,IdList),
	Slist = [String|_],
	propedit_SetValue(PRWin,le_Bitmap_FileName,editStr(String)),
	fail.
  le_prop_cb(PRWin,callPBPressed(le_Bitmap_FileName)):-
	le_focus_win(LEWin),
	le_layout(LEWin,_,LOWin,_,_),
	layout_select(LOWin,IdList),
	FileNameX = dlg_GetFileName("*.bmp",[label_msg182,"*.bmp",label_msg177,"*.*"],label_msg183,[],"",_),
	FileNameX <> "",
	syspath(ExeStartupPath,_),
	filenamereduce(FileNameX,ExeStartupPath,FileName),
	le_change_filename(LEWin,IdList,FileName),
	le_redraw_fields(LOWin,IdList),
	propedit_SetValue(PRWin,le_Bitmap_FileName,editStr(FileName)),
	fail.
  le_prop_cb(PRWin,callPBPressed(le_ASCII_FileName)):-
	le_focus_win(LEWin),
	le_layout(LEWin,_,LOWin,_,_),
	layout_select(LOWin,IdList),
	FileNameX = dlg_GetFileName("*.txt",[label_msg184,"*.txt",label_msg177,"*.*"],label_msg183,[],"",_),
	FileNameX <> "",
	syspath(ExeStartupPath,_),
	filenamereduce(FileNameX,ExeStartupPath,FileName),
	le_change_filename(LEWin,IdList,FileName),
	le_redraw_fields(LOWin,IdList),
	propedit_SetValue(PRWin,le_ASCII_FileName,editStr(FileName)),
	fail.
ifdef use_odbc
  le_prop_cb(PRWin,callPBPressed(le_ODBC_BaseName)):-
	le_odbc,
	le_focus_win(LEWin),
	le_layout(LEWin,_,LOWin,_,_),
	layout_select(LOWin,IdList),
	le_get_base_name(PRWin,BaseName),
	le_change_filename(LEWin,IdList,BaseName),
	le_redraw_fields(LOWin,IdList),
	propedit_SetValue(PRWin,le_ODBC_BaseName,editStr(BaseName)),
	fail.
enddef
  le_prop_cb(PRWin,callPBPressed(le_DBASE_FileName)):-
	le_focus_win(LEWin),
	le_layout(LEWin,_,LOWin,_,_),
	layout_select(LOWin,IdList),
	FileNameX = dlg_GetFileName("*.dbf",[label_msg185,"*.txt",label_msg177,"*.*"],label_msg183,[],"",_),
	FileNameX <> "",
	syspath(ExeStartupPath,_),
	filenamereduce(FileNameX,ExeStartupPath,FileName),
	le_change_filename(LEWin,IdList,FileName),
	le_redraw_fields(LOWin,IdList),
	propedit_SetValue(PRWin,le_DBASE_FileName,editStr(FileName)),
	fail.
  le_prop_cb(PRWin,callPBPressed(le_DATE_Format_string)):-
	le_focus_win(LEWin),
	le_layout(LEWin,_,LOWin,_,_),
	layout_select(LOWin,IdList),
	le_get_format_string(PRWIN,FormatString),
	FormatString <> "",
	le_change_filename(LEWin,IdList,FormatString),
	le_redraw_fields(LOWin,IdList),
	propedit_SetValue(PRWin,le_DATE_Format_string,editStr(FormatString)),
	fail.
  le_prop_cb(PRWin,callPBPressed(le_Font_Name)):-
	le_focus_win(LEWin),
	le_layout(LEWin,_,LOWin,_,_),
	layout_select(LOWin,IdList),
	FontNameVal = propedit_GetValue(PRWin,le_Font_Name),
	FontNameVal = editStr(OldFontName),
	OldFontName <> "",!,
	le_get_font(LEWin,IdList,OldFont),
	Font = dlg_ChooseFont(OldFont,FontName,_),
	le_change_font(LEWin,IdList,Font,FontName),
	le_redraw_fields(LOWin,IdList),
	propedit_SetValue(PRWin,le_Font_Name,editStr(FontName)),
	fail.
  le_prop_cb(PRWin,callPBPressed(le_Font_Name)):-
	le_focus_win(LEWin),
	le_layout(LEWin,_,LOWin,_,_),
	layout_select(LOWin,IdList),
	OldFont = font_Create(ff_System,[],10),
	Font = dlg_ChooseFont(OldFont,FontName,_),
	le_change_font(LEWin,IdList,Font,FontName),
	le_redraw_fields(LOWin,IdList),
	propedit_SetValue(PRWin,le_Font_Name,editStr(FontName)),
	fail.
  le_prop_cb(_,callPBPressed(le_PAGE_NAME)):-
	le_focus_win(LEWin),
	le_check_callback1(LEWin,user_action(page_change)),
	fail.
  le_prop_cb(_,callPBPressed(PrId)):-
	le_page_setup(PrId),
	le_focus_win(LEWin),
	le_check_callback1(LEWin,user_action(page_setup)),
	fail.
  le_prop_cb(PRWin,callPBPressed(le_PAGE_FONT)):-
	le_focus_win(LEWin),
	le_label_style(LEWin,OldFont,_),
	Font = dlg_ChooseFont(OldFont,FontName,_),
	retractall(le_label_style(LEWin,_,_)),
	assert(le_label_style(LEWin,Font,FontName)),
	propedit_SetValue(PRWin,le_PAGE_FONT,editStr(FontName)),
	fail.
  le_prop_cb(_,callPBPressed(_)):-
	le_focus_win(LEWin),
	win_SendEvent(LEWin,e_GetFocus),
	fail.
