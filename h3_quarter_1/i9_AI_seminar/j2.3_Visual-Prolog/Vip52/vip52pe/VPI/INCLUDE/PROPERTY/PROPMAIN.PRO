/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S 

 FileName:	PROPMAIN.PRO
 Purpose:	Property Editor object
 Written by:	Andrey Skobelev
 Build:		008.981112
 Tested with:   Visual Prolog v.5.1 build 555a
 Comments:	
******************************************************************************/

clauses

/**** global ***************************************************************
	Create Property Editor as TopLevel window
***************************************************************************/
  propedit_Create(Parent,RCT,Title,Font,PropertySheet,Callback,Label_area_width,Flags,Win):-
	trap(Win = win_Create(w_TopLevel,RCT,Title,no_menu,
	  Parent,Flags,propedit_eh,0),_,fail),
	win_Clear(Win,color_LtGray),
	DrToolsNew = draw_tools(pen(1,ps_Hollow,color_Black),brush(pat_Solid,color_White),
	  dm_CopyPen,Font,color_Black,color_LtGray,bk_Opaque),
	win_SetDrawTools(Win,DrToolsNew),
	propedit_init_db(Win,PropertySheet,Callback,Label_area_width),
	propedit_create_controls(Win),
	win_SetState(Win,[wsf_Visible]),
	propedit_send_created_notification(Win,Callback),
	assert(propedit_db_TopLevelEditor(Win)),
	!.
  propedit_Create(_,_,_,_,_,_,_,_,Win):- Win = cast(WINDOW,0),errorexit(error_vpi_package_bad_data).

/**** global ***************************************************************
	Init a new Property Editor window as a Custom Control
***************************************************************************/
  propedit_CreateCustom(Win,Font,PropertySheet,Callback,Label_area_width):-
	trap(win_Clear(Win,color_LtGray),_,fail),
	DrToolsNew = draw_tools(pen(1,ps_Hollow,color_Black),brush(pat_Solid,color_White),
	  dm_CopyPen,Font,color_Black,color_LtGray,bk_Opaque),
	win_SetDrawTools(Win,DrToolsNew),
	propedit_init_db(Win,PropertySheet,Callback,Label_area_width),
	propedit_create_controls(Win),
	win_SetState(Win,[wsf_Visible]),
	propedit_send_created_notification(Win,Callback),
	assert(propedit_db_EditorIsCustom(Win)),
	!.
  propedit_CreateCustom(_,_,_,_,_):-errorexit(error_vpi_package_bad_data).
  
/**** global ***************************************************************
	Handle event in Property Sheet created as a Custom Control
***************************************************************************/
  propedit_HandleEvent(Win,Event):-
	propedit_eh(Win,Event).

/**** global ***************************************************************
	Reload Property Editor in Top Level
***************************************************************************/
  propedit_Reload(Win,Title,PropertySheet,Label_area_width):-
	propedit_db_info(Win,_,_,_,_,_,_,_,_,_),
	assert(propedit_db_NowResize(Win)),
	TblId = propedit_GetActiveTbl(Win), % Get ID active table
	propedit_get_id_activ_ctrl(Win,PropID), % Get ID active control
	win_SetText(Win,Title), % Set Title 
	propedit_DelScroll(Win), % Delete scroll control
	propedit_del_LB(Win), % Delete Table Selector
	propedit_RenameFieldsToOld(Win), 
	propedit_db_info(Win,_,_,Callback,_,_,_,_,Label_area_width_Old,_),
	retractAll(propedit_db_info(Win,_,_,_,_,_,_,_,_,_)),
	propedit_init_db(Win,PropertySheet,Callback,Label_area_width),
	propedit_create_controls(Win), % Create Scroll and Table Selector
	propedit_SetActiveTbl(Win,TblId), 
	propedit_ShowFieldsMode(Win,Label_area_width_Old), % Show fields
	propedit_reload_scrolling_table(Win), 
	propedit_chekExistActivCtrl(Win,TblId,PropID),
	retractAll(propedit_db_NowResize(Win)),
	!.
  propedit_Reload(_,_,_,_):-errorexit(error_vpi_package_bad_data).

/**** global ***************************************************************
	Reload Property Editor as custom control
***************************************************************************/
  propedit_ReloadCustom(Win,PropertySheet,Label_area_width):-
	propedit_db_info(Win,_,_,_,_,_,_,_,_,_),
	assert(propedit_db_NowResize(Win)),
	TblId = propedit_GetActiveTbl(Win), % Get ID active table
	propedit_get_id_activ_ctrl(Win,PropID), % Get ID active control
	propedit_DelScroll(Win), % Delete scroll control
	propedit_del_LB(Win), % Delete Table Selector
	propedit_RenameFieldsToOld(Win), 
	propedit_db_info(Win,_,_,Callback,_,_,_,_,Label_area_width_Old,_),
	retractAll(propedit_db_info(Win,_,_,_,_,_,_,_,_,_)),
	propedit_init_db(Win,PropertySheet,Callback,Label_area_width),
	propedit_create_controls(Win), % Create Scroll and Table Selector
	propedit_SetActiveTbl(Win,TblId), 
	propedit_ShowFieldsMode(Win,Label_area_width_Old), % Show fields
	propedit_reload_scrolling_table(Win), 
	propedit_chekExistActivCtrl(Win,TblId,PropID),
	retractAll(propedit_db_NowResize(Win)),
	!.
  propedit_ReloadCustom(_,_,_):-errorexit(error_vpi_package_bad_data).

%**** global *******************************************************
%		Get/Set field value; Set marker; Get sheet; Get/Set Label
%*******************************************************************
  propedit_SetMarker(Win,PropID):- % Set active DynControl
	propedit_db_info(Win,_,_,_,SelHeight,Step,_LF,_RF,_,_),
	propedit_db_field(Win,TblId,Pos,property(PropID,_,_,_,_),Top_y),
	TblIdOld = propedit_GetActiveTbl(Win),
	propedit_SetActiveTbl(Win,TblId),
	propedit_reload_scrolling_table(Win), % Set active DynControl position inside visible area
	propedit_CalcPosMarker(Win,TblId,Step,Top_y,Pos,SelHeight),
	propedit_DynControlCreate(Win,TblId,Pos),
	not(TblIdOld = TblId),!,
	win_Invalidate(Win).
  propedit_SetMarker(Win,PropID):-
	propedit_db_info(Win,_,_,_,_SelHeight,_Step,_LF,_RF,_,_),
	propedit_db_field(Win,_TblId,_Pos,property(PropID,_,_,_,_),_Top_y),!.
  propedit_SetMarker(_,_):-!.

  propedit_GetValue(Win,PropID,editStr(Val)):-
	propedit_db_field(Win,_,_,property(PropID,_,Prop_Control,_,_),_),
	Prop_Control = editStr(Val,_),!.
  propedit_GetValue(Win,PropID,editInt(Val)):-
	propedit_db_field(Win,_,_,property(PropID,_,Prop_Control,_,_),_),
	Prop_Control = editInt(Val,_),!.
  propedit_GetValue(Win,PropID,editLong(Val)):-
	propedit_db_field(Win,_,_,property(PropID,_,Prop_Control,_,_),_),
	Prop_Control = editLong(Val,_),!.
  propedit_GetValue(Win,PropID,editReal(Val)):-
	propedit_db_field(Win,_,_,property(PropID,_,Prop_Control,_,_),_),
	Prop_Control = editReal(Val,_),!.
  propedit_GetValue(Win,PropID,listButton(Val)):-
	propedit_db_field(Win,_,_,property(PropID,_,Prop_Control,_,_),_),
	Prop_Control = listButton(_,Val),!.
  propedit_GetValue(Win,PropID,listEdit(Val)):-
	propedit_db_field(Win,_,_,property(PropID,_,Prop_Control,_,_),_),
	Prop_Control = listEdit(_,Val,_),!.
  propedit_GetValue(_,_,editStr("")):-
	errorexit(error_vpi_package_bad_data).

  propedit_GetStr(Win,PropID,OutStr):-
	propedit_db_field(Win,_,_,property(PropID,_,editStr(OutStr,_),_,_),_),!.
  propedit_GetStr(_,_,""):-errorexit(error_vpi_package_bad_data).

  propedit_GetInt(Win,PropID,OutInt):-
	propedit_db_field(Win,_,_,property(PropID,_,editInt(OutInt,_),_,_),_),!.
  propedit_GetInt(_,_,i(0)):-errorexit(error_vpi_package_bad_data).

  propedit_GetLong(Win,PropID,OutLong):-
	propedit_db_field(Win,_,_,property(PropID,_,editLong(OutLong,_),_,_),_),!.
  propedit_GetLong(_,_,l(0)):-errorexit(error_vpi_package_bad_data).

  propedit_GetReal(Win,PropID,OutRial):-
	propedit_db_field(Win,_,_,property(PropID,_,editReal(OutRial,_),_,_),_),!.
  propedit_GetReal(_,_,r(0)):-errorexit(error_vpi_package_bad_data).

  propedit_GetListEdit(Win,PropID,OutStr):-
	propedit_db_field(Win,_,_,property(PropID,_,listEdit(_,OutStr,_),_,_),_),!.
  propedit_GetListEdit(_,_,""):-errorexit(error_vpi_package_bad_data).

  propedit_GetListButton(Win,PropID,OutStr,Sel):-
	propedit_db_field(Win,_,_,property(PropID,_,listButton(SList,Sel),_,_),_),
	I1 = Sel + 1,
	propedit_MemberIndex(OutStr,SList,I1),!.
  propedit_GetListButton(_,_,"",0):-
	errorexit(error_vpi_package_bad_data).
	
  propedit_SetValue(Win,PropID,Prop_Cont_val):-
	propedit_db_field(Win,TableId,Pos,property(PropID,Title,Prop_Cont_Old,Er,OkPB),Top),
	Prop_Cont_Old = editStr(_,P), Prop_Cont_val = editStr(Val), Prop_Control = editStr(Val,P),
	retract(propedit_db_field(Win,TableId,Pos,property(PropID,Title,Prop_Cont_Old,Er,OkPB),Top)),
	assert(propedit_db_field(Win,TableId,Pos,property(PropID,Title,Prop_Control,Er,OkPB),Top)),!,
	propedit_SetValToDyn(Win,Prop_Control),
	propedit_RedrawField(Win,TableId,Top).
  propedit_SetValue(Win,PropID,Prop_Cont_val):-
	propedit_db_field(Win,TableId,Pos,property(PropID,Title,Prop_Cont_Old,Er,OkPB),Top),
	Prop_Cont_Old = editInt(_,P), Prop_Cont_val = editInt(Val), Prop_Control = editInt(Val,P),
	retract(propedit_db_field(Win,TableId,Pos,property(PropID,Title,Prop_Cont_Old,Er,OkPB),Top)),
	assert(propedit_db_field(Win,TableId,Pos,property(PropID,Title,Prop_Control,Er,OkPB),Top)),!,
	propedit_SetValToDyn(Win,Prop_Control),
	propedit_RedrawField(Win,TableId,Top).
  propedit_SetValue(Win,PropID,Prop_Cont_val):-
	propedit_db_field(Win,TableId,Pos,property(PropID,Title,Prop_Cont_Old,Er,OkPB),Top),
	Prop_Cont_Old = editLong(_,P), Prop_Cont_val = editLong(Val), Prop_Control = editLong(Val,P),
	retract(propedit_db_field(Win,TableId,Pos,property(PropID,Title,Prop_Cont_Old,Er,OkPB),Top)),
	assert(propedit_db_field(Win,TableId,Pos,property(PropID,Title,Prop_Control,Er,OkPB),Top)),!,
	propedit_SetValToDyn(Win,Prop_Control),
	propedit_RedrawField(Win,TableId,Top).
  propedit_SetValue(Win,PropID,Prop_Cont_val):-
	propedit_db_field(Win,TableId,Pos,property(PropID,Title,Prop_Cont_Old,Er,OkPB),Top),
	Prop_Cont_Old = editReal(_,P), Prop_Cont_val = editReal(Val), Prop_Control = editReal(Val,P),
	retract(propedit_db_field(Win,TableId,Pos,property(PropID,Title,Prop_Cont_Old,Er,OkPB),Top)),
	assert(propedit_db_field(Win,TableId,Pos,property(PropID,Title,Prop_Control,Er,OkPB),Top)),!,
	propedit_SetValToDyn(Win,Prop_Control),
	propedit_RedrawField(Win,TableId,Top).
  propedit_SetValue(Win,PropID,Prop_Cont_val):-
	propedit_db_field(Win,TableId,Pos,property(PropID,Title,Prop_Cont_Old,Er,OkPB),Top),
	Prop_Cont_Old = listButton(P,_), Prop_Cont_val = listButton(Val), Prop_Control = listButton(P,Val),
	retract(propedit_db_field(Win,TableId,_,property(PropID,Title,Prop_Cont_Old,Er,OkPB),Top)),
	assert(propedit_db_field(Win,TableId,Pos,property(PropID,Title,Prop_Control,Er,OkPB),Top)),!,
	propedit_SetValToDynListButton(Win,Prop_Control),
	propedit_RedrawField(Win,TableId,Top).
  propedit_SetValue(Win,PropID,Prop_Cont_val):-
	propedit_db_field(Win,TableId,Pos,property(PropID,Title,Prop_Cont_Old,Er,OkPB),Top),
	Prop_Cont_Old = listEdit(Sl,_,P), Prop_Cont_val = listEdit(Val), Prop_Control = listEdit(Sl,Val,P),
	retract(propedit_db_field(Win,TableId,Pos,property(PropID,Title,Prop_Cont_Old,Er,OkPB),Top)),
	assert(propedit_db_field(Win,TableId,Pos,property(PropID,Title,Prop_Control,Er,OkPB),Top)),!,
	propedit_SetValToDyn(Win,Prop_Control),
	propedit_RedrawField(Win,TableId,Top).
  propedit_SetValue(_,_,_):-errorexit(error_vpi_package_bad_data).

  propedit_SetStr(Win,PropID,Str):-
	propedit_db_field(Win,TableId,Pos,property(PropID,Title,Prop_ConOld,Er,OkPB),Top),
	Prop_ConOld=editStr(_,P),
	Prop_Control=editStr(Str,P),
	retract(propedit_db_field(Win,TableId,Pos,property(PropID,Title,Prop_ConOld,Er,OkPB),Top)),
	assert(propedit_db_field(Win,TableId,Pos,property(PropID,Title,Prop_Control,Er,OkPB),Top)),!,
	propedit_SetValToDyn(Win,Prop_Control),
	propedit_RedrawField(Win,TableId,Top).
  propedit_SetStr(_,_,_):-errorexit(error_vpi_package_bad_data).

  propedit_SetInt(Win,PropID,InInt):-
	propedit_db_field(Win,TableId,Pos,property(PropID,Title,Prop_ConOld,Er,OkPB),Top),
	Prop_ConOld = editInt(_,P),
	Prop_Control = editInt(InInt,P),
	retract(propedit_db_field(Win,TableId,Pos,property(PropID,Title,Prop_ConOld,Er,OkPB),Top)),
	assert(propedit_db_field(Win,TableId,Pos,property(PropID,Title,Prop_Control,Er,OkPB),Top)),!,
	propedit_SetValToDyn(Win,Prop_Control),
	propedit_RedrawField(Win,TableId,Top).
  propedit_SetInt(_,_,_):-errorexit(error_vpi_package_bad_data).

  propedit_SetLong(Win,PropID,InLong):-
	propedit_db_field(Win,TableId,Pos,property(PropID,Title,Prop_ConOld,Er,OkPB),Top),
	Prop_ConOld = editLong(_,P),
	Prop_Control = editLong(InLong,P),
	retract(propedit_db_field(Win,TableId,Pos,property(PropID,Title,Prop_ConOld,Er,OkPB),Top)),
	assert(propedit_db_field(Win,TableId,Pos,property(PropID,Title,Prop_Control,Er,OkPB),Top)),!,
	propedit_SetValToDyn(Win,Prop_Control),
	propedit_RedrawField(Win,TableId,Top).
  propedit_SetLong(_,_,_):-errorexit(error_vpi_package_bad_data).

  propedit_SetReal(Win,PropID,InReal):-
	propedit_db_field(Win,TableId,Pos,property(PropID,Title,Prop_ConOld,Er,OkPB),Top),
	Prop_ConOld = editReal(_,P),
	Prop_Control = editReal(InReal,P),
	retract(propedit_db_field(Win,TableId,Pos,property(PropID,Title,Prop_ConOld,Er,OkPB),Top)),
	assert(propedit_db_field(Win,TableId,Pos,property(PropID,Title,Prop_Control,Er,OkPB),Top)),!,
	propedit_SetValToDyn(Win,Prop_Control),
	propedit_RedrawField(Win,TableId,Top).
  propedit_SetReal(_,_,_):-errorexit(error_vpi_package_bad_data).

  propedit_SetListEdit(Win,PropID,Str):-
	propedit_db_field(Win,TableId,Pos,property(PropID,Title,Prop_ConOld,Er,OkPB),Top),
	Prop_ConOld = listEdit(Sl,_,P),
	Prop_Control = listEdit(Sl,Str,P),
	retract(propedit_db_field(Win,TableId,Pos,property(PropID,Title,Prop_ConOld,Er,OkPB),Top)),
	assert(propedit_db_field(Win,TableId,Pos,property(PropID,Title,Prop_Control,Er,OkPB),Top)),!,
	propedit_SetValToDyn(Win,Prop_Control),
	propedit_RedrawField(Win,TableId,Top).
  propedit_SetListEdit(_,_,_):-errorexit(error_vpi_package_bad_data).

  propedit_SetListButton(Win,PropID,Sel):-
	propedit_db_field(Win,TableId,Pos,property(PropID,Title,Prop_ConOld,Er,OkPB),Top),
	Prop_ConOld = listButton(Sl,_),
	Prop_Control = listButton(Sl,Sel),
	retract(propedit_db_field(Win,TableId,Pos,property(PropID,Title,Prop_ConOld,Er,OkPB),Top)),
	assert(propedit_db_field(Win,TableId,Pos,property(PropID,Title,Prop_Control,Er,OkPB),Top)),
	propedit_SetValToDynListButton(Win,Prop_Control),
	propedit_RedrawField(Win,TableId,Top),!.
  propedit_SetListButton(_,_,_):-errorexit(error_vpi_package_bad_data).

  propedit_GetSheet(Win,Prop_Sheet):-
	propedit_db_info(Win,_,_,_,_,_,_,_,_,Prop_S),
	propedit_BildTableList(Win,Prop_S,[],Prop_Sheet),!.
  propedit_GetSheet(_,[]):-errorexit(error_vpi_package_bad_window).

  propedit_SetPropertyLabel(Win,PropID,Title):-
	propedit_db_field(Win,TableId,Pos,property(PropID,_TitleOld,Prop_Cont,Er,OkPB),Top),
	propedit_db_scroll(Win,TableId,SrlPos,_),
	propedit_db_info(Win,_,_,_,_SelHeight,Step,Lf,_Rf,_,_),
	Top1 = Top - (SrlPos - 1) * Step, Bot = Top1 + Step + propedit_con_separator,
	Rct = rct(0,Top1,Lf,Bot),
	retract(propedit_db_field(Win,TableId,Pos,property(PropID,_TitleOld,Prop_Cont,Er,OkPB),Top)),
	assert(propedit_db_field(Win,TableId,Pos,property(PropID,Title,Prop_Cont,Er,OkPB),Top)),
	TableId = propedit_GetActiveTbl(Win),
	win_Invalidate(Win,Rct),!.
  propedit_SetPropertyLabel(_,_,_):-errorexit(error_vpi_package_bad_data).

  propedit_GetPropertyLabel(Win,PropID,Title):-
	propedit_db_field(Win,_TableId,_Pos,property(PropID,Title,_Prop_Cont,_Er,_OkPB),_Top),!.
  propedit_GetPropertyLabel(_,_,""):-
	errorexit(error_vpi_package_bad_data).

  propedit_GetActiveTbl(Win,TableId):- % If Table Selector exist
	propedit_db_info(Win,_,TableList,_,_SelHeight,_Step,_,_,_,_),
	trap(SelWin = win_GetCtlHandle(Win,propedit_idc_lbox),_,fail),
	lbox_GetSel(SelWin,_,SelList),
	SelList = [Index],
	Index1 = Index + 1,
	propedit_MemberIndex(El,TableList,Index1),
	El = table(TableId,_),
	!.
  propedit_GetActiveTbl(Win,TableId):- % If only 1 Table
	propedit_db_info(Win,_,TableList,_,_SelHeight,_Step,_,_,_,_),
	Index1 = 1,
	propedit_MemberIndex(El,TableList,Index1),
	El = table(TableId,_),
	!.
  propedit_GetActiveTbl(_Win,0):-!.

  propedit_SetActiveTbl(Win,TableId):- % Set active table
	trap(SelWin = win_GetCtlHandle(Win,propedit_idc_lbox),_,fail),
	propedit_db_info(Win,_,TableList,_,_SelHeight,_Step,_,_,_,_),
	propedit_member(table(TableId,_),TableList),
	propedit_MemberIndex(table(TableId,_),TableList,Index),
	Index1 = Index - 1,
	lbox_SetSel(SelWin,Index1,b_true),
  	!.
  propedit_SetActiveTbl(Win,_):-
	trap(SelWin = win_GetCtlHandle(Win,propedit_idc_lbox),_,fail),
	lbox_SetSel(SelWin,0,b_true),
	!.
  propedit_SetActiveTbl(_,_).
