/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S 

 FileName:	PROP_UT1.PRO
 Purpose:	Property Editor object
 Written by:	Andrey Skobelev
 Build:		008.981112
 Tested with:   Visual Prolog v.5.1 build 555a
 Comments:	
******************************************************************************/

/********* PROPERTY constants ***********/
constants
  % Control Identifiers
  propedit_idc_lbox			= 4200	% Table selector window ID
  propedit_idc_vscroll			= 4202	% Vertical scrollbar window ID
  propedit_idc_DynCtrl			= 4220	% DynControl (active control) window ID (edit or listedit or listbutton)
  propedit_idc_DynPB			= 4221	% Pushbutton window ID

  % Post event identifiers
  propedit_idc_post_getFocus		= 790	% getFocus Callback
  propedit_idc_post_lostFocus		= 791	% lostFocus Callback
  propedit_idc_post_ChkFocus		= 792	% Check editor focus
  propedit_idc_post_SendGetFocus	= 793	% Send Callback getFocus
  propedit_idc_post_DelActive		= 780	% Delete active control
  propedit_idc_post_MoveActive		= 779	% Move active control
  propedit_idc_post_OptimPos		= 778	% Set new field positions for new window size
  propedit_idc_post_MoveTableSel	= 777	% Move Table Selector
  propedit_idc_post_MoveActiveDown	= 801	% Move active control down
  propedit_idc_post_MoveActiveUp	= 802	% Move active control up
  propedit_idc_post_MoveActivePrev	= 803	% Move active control to previous position
  propedit_idc_post_ChangeTable		= 804	% Change active table
  propedit_idc_post_ChangeFont		= 794	% Change font
  
  % Window exterior
  propedit_con_separator		= 1     % Field separatop
  propedit_con_field_marg		= 4	% Field margin
  propedit_con_vscroll_width 		= 16	% Scroll width
  propedit_con_ScrollTopBotMarging	= 0	% Top Bottom Marging for scroll
  propedit_con_Push_width    		= 18	% Push Button width
  propedit_con_ListBut_Height		= 100	% ListButton Height with drop down
ifdef ws_win
  propedit_con_DeltaCtrlHeight		= 9	% Delta between text height and field height
  % Edit control flags
  propedit_edit_Flags	 		= [wsf_Invisible,wsf_Noborder,wsf_MultiLine,wsf_AutoHScroll]
  % List button flags
  propedit_lb_Flags			= [wsf_Invisible,wsf_Noborder,wsf_AutoVScroll,wsf_VScroll]
  % List edit flags
  propedit_le_Flags			= [wsf_Invisible,wsf_Noborder,wsf_AutoHScroll,wsf_VScroll,wsf_AutoVScroll]
  % Table Selector flags
  propedit_TblSel_Flags			= [wsf_Invisible,wsf_Noborder,wsf_AutoVScroll,wsf_VScroll]
elsedef
  propedit_con_DeltaCtrlHeight		= 10	% Delta between text height and field height
  % Edit control flags
  propedit_edit_Flags	 		= [wsf_Invisible,wsf_NoClipSiblings,wsf_Noborder,wsf_MultiLine,wsf_AutoHScroll]
  % List button flags
  propedit_lb_Flags			= [wsf_Invisible,wsf_NoClipSiblings,wsf_Noborder,wsf_AutoVScroll,wsf_VScroll]
  % List edit flags
  propedit_le_Flags			= [wsf_Invisible,wsf_NoClipSiblings,wsf_Noborder,wsf_AutoHScroll,wsf_VScroll,wsf_AutoVScroll]
  % Table Selector flags
  propedit_TblSel_Flags			= [wsf_Invisible,wsf_NoClipSiblings,wsf_Noborder,wsf_AutoVScroll,wsf_VScroll]
enddef
  propedit_con_DeltaSelHeight		= 15	% Margin from bottom Selector Area to top 1 field

domains
  TABLE = table(PROPERTY_TBLID,STRING TableTitle)
  TABLELIST = TABLE*
database - propedit_db
  propedit_db_info(WINDOW		PropertySheetWindow,
		RCT			WindowRct,
		TABLELIST		TableIdsAndTitles,
		PROPERTY_CALLBACK	CallbackFunction,
		INTEGER			SelectorAreaHeight,
		INTEGER			FieldStep,
		INTEGER			Left_x,
		INTEGER			Right_x,
		INTEGER			Size_title_fields,
		Property_Sheet          Sheet)
  propedit_db_field(WINDOW		PropertySheetWindow,
		PROPERTY_TBLID		TableId,
		INTEGER			FieldPosition,
		PROPERTY		FieldDefinition,
		INTEGER			Top_y)
  propedit_db_field_old(WINDOW		PropertySheetWindow,
		PROPERTY_TBLID		TableId,
		INTEGER			FieldPosition,
		PROPERTY		FieldDefinition,
		INTEGER			Top_y)
  propedit_db_dyncontrol(WINDOW		PropertySheetWindow,
		PROPERTY_TBLID		TableId,
		INTEGER			FieldPosition,
		PROPERTY_ID 		TableId,
		BOOLEAN			CloseUpDropDown)
  propedit_db_scroll(WINDOW		PropertySheetWindow,
		PROPERTY_TBLID		TableId,
		INTEGER			VisibleFrom,
		INTEGER			TotalFields)
  propedit_db_PushPressed(WINDOW PushButtonPressed) 	% The button was pressed
  propedit_db_ControlMod(WINDOW) 			% The user modified value
  propedit_db_NoAskPrompt(WINDOW)
  propedit_db_PrevActCtrl(WINDOW,PROPERTY_ID,STRING)	% The user has entered a incompatible string
  propedit_db_NowResize(WINDOW)				
  propedit_db_ActiveEditor(WINDOW)			% One of elements is active in Editor window
  propedit_db_EditorIsCustom(WINDOW)
  propedit_db_TopLevelEditor(WINDOW)
  propedit_db_NewFont(WINDOW,FONT)
  propedit_db_Note(WINDOW)				% error dialog exist

predicates
 propedit_eh   : EHANDLER 	  % Property Sheet event handler
 propedit_subDyn_EH   : EHANDLER % DynControl sub class event handler
 propedit_subScroll_EH   : EHANDLER % Scroll sub class event handler

determ propedit_init_db(WINDOW,PROPERTY_SHEET,PROPERTY_CALLBACK,INTEGER) 
determ propedit_create_controls(WINDOW)
procedure  propedit_send_created_notification(WINDOW,PROPERTY_CALLBACK)
procedure  propedit_get_id_activ_ctrl(WINDOW,PROPERTY_ID)
procedure  propedit_move_lb(WINDOW)
procedure  propedit_del_prev_ctrl(WINDOW)
procedure  propedit_del_LB(WINDOW)
determ propedit_set_scrolling_field(WINDOW,PROPERTY_TBLID,INTEGER NextPos,INTEGER OutPos)
procedure  propedit_reload_scrolling_table(WINDOW)
determ propedit_move_dyn_controls(WINDOW)
determ propedit_Cliar_MargArea(WINDOW)
procedure  propedit_RenameFieldsToOld(WINDOW)
determ propedit_ShowFields(WINDOW,BOOLEAN NoFullRedraw)
procedure  propedit_ShowFieldsMode(WINDOW,INTEGER Size_title_fields_Old)
procedure  propedit_chekExistActivCtrl(WINDOW,PROPERTY_TBLID,Property_ID)
determ propedit_chekTypeActiveControl(WINDOW,Property_ID)
procedure  propedit_del_ctrl_NoNotification(WINDOW)
procedure  propedit_SetValToDyn(WINDOW,Property_Control)
determ propedit_Chk_AktivEditor(WINDOW)
clauses


% clauses for Reload  
  propedit_chekExistActivCtrl(Win,TblId,PropID):- % If exist active control with same Id and TblID when reload happen
	propedit_db_field(Win,TblId,_Pos,Prop,_Ft),
	Prop = property(PropID,_,_,_,_),
	propedit_chekTypeActiveControl(Win,PropID),
	TblId = propedit_GetActiveTbl(Win),!,
	PropCtrlVal = propedit_GetValue(Win,PropID),
	propedit_SetValue(Win,PropID,PropCtrlVal),
	win_PostEvent(Win,e_Menu(propedit_idc_post_MoveActive,0)).
  propedit_chekExistActivCtrl(Win,_,PropID):- % If exist active control with same Id when reload happen
	propedit_db_field(Win,_,_Pos,Prop,_Ft),
	Prop = property(PropID,_,_,_,_),!,
	propedit_del_ctrl_NoNotification(Win),
	propedit_SetMarker(Win,PropID).
  propedit_chekExistActivCtrl(Win,_,_):- 
	propedit_del_ctrl_NoNotification(Win),
	!.

  propedit_chekTypeActiveControl(Win,PropID):- % fail if control window type or Slist change for listButton
	propedit_db_field(Win,_,_,property(PropID,_,listButton(SList,_Sel),_,_),_),
	trap(WinActCtrl = win_GetCtlHandle(Win,propedit_idc_DynCtrl),_,fail),
	trap(wc_LBoxButton = win_GetType(WinActCtrl),_,fail),
	trap(SlistCtrl = lbox_GetAll(WinActCtrl),_,fail),
	SlistCtrl = SList,
	!.
  propedit_del_ctrl_NoNotification(Win):- % Rmove DynControl without notification
	retractAll(propedit_db_dyncontrol(Win,_,_,_,_)),
	trap(WinCtrlPred = win_GetCtlHandle(Win,propedit_idc_DynCtrl),_,fail),
	trap(win_Destroy(WinCtrlPred),_,fail),
	trap(WinPB = win_GetCtlHandle(Win,propedit_idc_DynPB),_,fail),
	trap(win_Destroy(WinPB),_,fail),!.
  propedit_del_ctrl_NoNotification(_).

  propedit_ShowFieldsMode(Win,Size_title_fields_Old):-
	propedit_db_info(Win,_,_,_,_,_,_,_,Size_title_fields,_),
	Size_title_fields = Size_title_fields_Old,
	propedit_ShowFields(Win,b_false),
	!.
  propedit_ShowFieldsMode(Win,_):- win_Invalidate(Win),!. % If change label size for fields

predicates
determ propedit_RecalcControls(WINDOW)
determ propedit_CalcLeftRightFields(WINDOW,INTEGER Marging)
determ propedit_HandleScroll(WINDOW)
determ propedit_CalcNumberFieldsPage(WINDOW,INTEGER VisibleFieldsNum)
procedure  propedit_DynControlCreate(WINDOW,PROPERTY_TBLID,INTEGER FieldPos)
determ propedit_Str_To_PropControl(WINDOW,Property_Control,STRING STR,INTEGER Selected,Property_Control,Property_ERROR_PROMPT)
procedure  propedit_optim_pos(WINDOW)
determ propedit_ExtractFromControl(WINDOW,WINDOW)
determ propedit_GetParent(WINDOW,WINDOW)
procedure  propedit_SetMarker_NoMove(WINDOW,Property_ID)
procedure  propedit_SetNewEditorFont(WINDOW)

clauses
% Property Editor event handler

  propedit_eh(Win,e_CloseRequest(),0):-
	propedit_db_info(Win,_,_,Callback,_,_,_,_,_,_),
	Callback(Win,is_ToBeDestroyed),!.

  propedit_eh(Win,e_Destroy,0):-
	retractAll(propedit_db_dyncontrol(Win,_,_,_,_)),
	retractAll(propedit_db_info(Win,_,_,_,_,_,_,_,_,_)),
	retractAll(propedit_db_field(Win,_,_,_,_)),
	retractAll(propedit_db_NoAskPrompt(Win)),
	retractAll(propedit_db_ControlMod(Win)),
	retractAll(propedit_db_scroll(Win,_,_,_)),
	retractAll(propedit_db_PushPressed(Win)),
	retractAll(propedit_db_PrevActCtrl(Win,_,_)),
	retractAll(propedit_db_NowResize(Win)),
	retractAll(propedit_db_EditorIsCustom(Win)),
	retractAll(propedit_db_TopLevelEditor(Win)),
	fail.

  propedit_eh(_Win,e_EraseBackground(),0):-!.

  propedit_eh(Win,e_Update(_RCT),0):-
	win_Clear(Win,color_LtGray),
	propedit_ShowFields(Win,b_false),
	!.

  propedit_eh(Win,e_State(font(Font)),0):-
	propedit_db_EditorIsCustom(Win),
	assert(propedit_db_NewFont(Win,Font)),
	win_PostEvent(Win,e_Menu(propedit_idc_post_ChangeFont,0)),
  	!.
  propedit_eh(Win,e_State(font(Font)),0):-
	propedit_db_TopLevelEditor(Win),
	assert(propedit_db_NewFont(Win,Font)),
	win_PostEvent(Win,e_Menu(propedit_idc_post_ChangeFont,0)),
  	!.

  propedit_eh(Win,e_Menu(propedit_idc_post_ChangeFont,_),0):-
	retract(propedit_db_NewFont(Win,_Font)),
	propedit_SetNewEditorFont(Win),
  	!.

  propedit_eh(Win,e_GetFocus(),0):- % getfocus event handling
	not(propedit_db_ActiveEditor(Win)),% If Property Editor get focus
	assert(propedit_db_ActiveEditor(Win)),
	win_PostEvent(Win,e_Menu(propedit_idc_post_getFocus,0)),
	!.

  propedit_eh(Win,e_Control(_Id,_CtrlType,_CtrlWin,getfocus()),0):-% e_control getfocus event handling
	not(propedit_db_ActiveEditor(Win)),% If Property Editor get focus
	assert(propedit_db_ActiveEditor(Win)),
	win_PostEvent(Win,e_Menu(propedit_idc_post_getFocus,0)),
	!.

  propedit_eh(Win,e_LoseFocus(),0):-	% losefocus event handling
	win_PostEvent(Win,e_Menu(propedit_idc_post_ChkFocus,0)),
	!.

  propedit_eh(Win,e_Control(_Id,_CtrlType,_CtrlWin,losefocus()),0):- % e_control losefocus event handling
	win_PostEvent(Win,e_Menu(propedit_idc_post_ChkFocus,0)),
	!.

  propedit_eh(Win,e_Menu(propedit_idc_post_ChkFocus,_),0):-
	propedit_Chk_AktivEditor(Win),	% If Property Editor lose focus
	not(retract(propedit_db_PushPressed(Win))),
	not(propedit_db_Note(Win)),
	win_PostEvent(Win,e_Menu(propedit_idc_post_DelActive,0)),
	retract(propedit_db_ActiveEditor(Win)),
	win_PostEvent(Win,e_Menu(propedit_idc_post_lostFocus,0)),
	!.

  propedit_eh(Win,e_Menu(propedit_idc_post_getFocus,_),0):-
	win_PostEvent(Win,e_Menu(propedit_idc_post_SendGetFocus,0)),
	!.

  propedit_eh(Win,e_Menu(propedit_idc_post_SendGetFocus,_),0):-
	propedit_db_info(Win,_,_,Callback,_,_,_,_,_,_),% getFocus notification
	Callback(Win,getFocus),
	!.

  propedit_eh(Win,e_Menu(propedit_idc_post_lostFocus,_),0):-
	propedit_db_info(Win,_,_,Callback,_,_,_,_,_,_),% loseFocus notification
	Callback(Win,loseFocus),
	!.

  propedit_eh(Win,e_Menu(propedit_idc_post_DelActive,_),0):-
	propedit_del_prev_ctrl(Win), % Delete active control
	!.

  propedit_eh(Win,e_Menu(propedit_idc_post_MoveActive,_),0):-
	propedit_move_dyn_controls(Win), % Move active control
	retractAll(propedit_db_NowResize(Win)),
	!.

  propedit_eh(Win,e_Menu(propedit_idc_post_OptimPos,_),0):-
	propedit_optim_pos(Win), % Set new fields position for new window size
	win_PostEvent(Win,e_Menu(propedit_idc_post_MoveActive,0)),
	!.

  propedit_eh(Win,e_Menu(propedit_idc_post_MoveTableSel,_),0):-
	propedit_move_lb(Win), % Move Table Selector
	win_PostEvent(Win,e_Menu(propedit_idc_post_OptimPos,0)),
	!.

  propedit_eh(Win,e_Size(Width,Height),0):- % e_Size event handling
	propedit_db_info(Win,_,_,_,SelHeight,_,_Lfold,Rfold,_,_),
	TableId = propedit_GetActiveTbl(Win),
	propedit_db_scroll(Win,TableId,Pos,_),
	propedit_set_scrolling_field(Win,TableId,Pos,_),
	win_Invalidate(Win,rct(Rfold,SelHeight,Width,Height)),
	assert(propedit_db_NowResize(Win)),
	win_PostEvent(Win,e_Menu(propedit_idc_post_MoveTableSel,0)),
	!.

  propedit_eh(Win,e_Control(propedit_idc_DynCtrl,_,_,modified()),0):- % Control modified
	retractAll(propedit_db_ControlMod(Win)),
	assert(propedit_db_ControlMod(Win)),
	!.

  propedit_eh(Win,e_Control(_Id,_CtrlType,_CtrlWin,scroll(sc_LineDown,_SET)),0):- % LineDown event handling
	TableId = propedit_GetActiveTbl(Win),
	propedit_db_scroll(Win,TableId,PrevPos,_),
	NextPos = PrevPos + 1,
	propedit_set_scrolling_field(Win,TableId,NextPos,_),
	win_PostEvent(Win,e_Menu(propedit_idc_post_MoveActive,0)),
	!.

  propedit_eh (Win,e_Control(_Id,_CtrlType,_CtrlWin,scroll(sc_LineUp,_SET)),0):- % LineUp event handling
	TableId = propedit_GetActiveTbl(Win),
	propedit_db_scroll(Win,TableId,PrevPos,_),
	NextPos = PrevPos - 1,
	propedit_set_scrolling_field(Win,TableId,NextPos,_),
	win_PostEvent(Win,e_Menu(propedit_idc_post_MoveActive,0)),
	!.

  propedit_eh(Win,e_Control(_Id,_CtrlType,_CtrlWin,scroll(sc_PageDown,_SET)),0):- % PageDown event handling
	TableId = propedit_GetActiveTbl(Win),
	propedit_db_scroll(Win,TableId,FirstPos,_),
	propedit_CalcNumberFieldsPage(Win,Nfields),
	NextPos = FirstPos + Nfields,
	propedit_set_scrolling_field(Win,TableId,NextPos,_),
	win_PostEvent(Win,e_Menu(propedit_idc_post_MoveActive,0)),
	!.

  propedit_eh(Win,e_Control(_Id,_CtrlType,_CtrlWin,scroll(sc_PageUp,_SET)),0):- % PageUp event handling
	TableId = propedit_GetActiveTbl(Win),
	propedit_db_scroll(Win,TableId,FirstPos,_),
	propedit_CalcNumberFieldsPage(Win,Nfields),
	NextPos = FirstPos - Nfields,
	propedit_set_scrolling_field(Win,TableId,NextPos,_),
	win_PostEvent(Win,e_Menu(propedit_idc_post_MoveActive,0)),
	!.

  propedit_eh(Win,e_Control(_Id,_CtrlType,_CtrlWin,scroll(sc_Thumb,SET)),0):- % Thumb event handling
	propedit_RecalcControls(Win),
	TableId = propedit_GetActiveTbl(Win),
	propedit_set_scrolling_field(Win,TableId,Set,_),
	win_PostEvent(Win,e_Menu(propedit_idc_post_MoveActive,0)),
	!.

  propedit_eh(Win,e_Menu(propedit_idc_post_ChangeTable,_),0):-
	TableId = propedit_GetActiveTbl(Win),
	not(propedit_db_dyncontrol(Win,TableId,_,_,_)),!,
	propedit_RecalcControls(Win),
	propedit_db_scroll(Win,TableId,FirstPos,_Max),
	propedit_set_scrolling_field(Win,TableId,FirstPos,_),
	win_Invalidate(Win),!.

  propedit_eh(Win,e_Control(propedit_idc_lbox,_,_,selchanged()),0):- % If change active table
	not(propedit_db_NowResize(Win)),
	propedit_del_prev_ctrl(Win),
	win_PostEvent(Win,e_Menu(propedit_idc_post_ChangeTable,0)),!.

  propedit_eh(Win,e_Control(propedit_idc_DynCtrl,_,_,selchanged()),0):- % If listButton selchanged 
	propedit_db_dyncontrol(Win,_,_,Property_Id,_),			% send "modified" notification
	propedit_db_field(Win,_,_,property(Property_Id,_,listButton(_,_),_,_),_Ft),
	trap(WinCtrl = win_GetCtlHandle(Win,propedit_idc_DynCtrl),_,fail),
	propedit_ExtractFromControl(Win,WinCtrl),
	propedit_db_info(Win,_,_,Callback,_,_,_,_,_,_),!,
	not(Callback(Win,modified(Property_Id))).

  propedit_eh(Win,e_Control(propedit_idc_DynCtrl,_,_,selchanged()),0):- % If listButton selchanged 
	propedit_db_dyncontrol(Win,_,_,Property_Id,_),			% send "modified" notification
	propedit_db_field(Win,_,_,property(Property_Id,_,listEdit(_,_,_),_,_),_Ft),
	retractAll(propedit_db_ControlMod(Win)),
	assert(propedit_db_ControlMod(Win)),!.

  propedit_eh(Win,e_Control(propedit_idc_DynCtrl,_,_,dropdown()),0):- % If listButton dropdown
	propedit_db_dyncontrol(Win,_,_,Property_Id,_),
	propedit_db_field(Win,_,_,property(Property_Id,_,listButton(_,_),_,_),_Ft),
	retract(propedit_db_dyncontrol(Win,TableId,Pos,Property_Id,_)),
	assert(propedit_db_dyncontrol(Win,TableId,Pos,Property_Id,b_true)),
	!.

  propedit_eh(Win,e_Control(propedit_idc_DynCtrl,_,_,closeup()),0):- % If listButton closeup
	propedit_db_dyncontrol(Win,_,_,Property_Id,_),
	propedit_db_field(Win,_,_,property(Property_Id,_,listButton(_,_),_,_),_Ft),
	retract(propedit_db_dyncontrol(Win,TableId,Pos,Property_Id,_)),
	assert(propedit_db_dyncontrol(Win,TableId,Pos,Property_Id,b_false)),
	!.

  propedit_eh(Win,e_MouseDown(pnt(X,Y),0,mouse_button_left),0):- % MouseDown, set active control
	TableId = propedit_GetActiveTbl(Win),
	propedit_db_info(Win,_,_,_,SelHeight,Step,_LF,RF,_,_),
	propedit_db_scroll(Win,TableId,FirstVisible,Max),!,
	X > propedit_con_field_marg, X <= RF,
	Y1 = Y - SelHeight,
	N = FirstVisible + (Y1 div Step),
	Y1 mod Step > propedit_con_separator,
	N <= Max,
	propedit_DynControlCreate(Win,TableId,N).

  propedit_eh(Win,e_Control(propedit_idc_DynPB,_,_,activated()),0):- % PushButton pressed
	TableId = propedit_GetActiveTbl(Win),
	propedit_db_info(Win,_,_,Callback,_,_,_,_,_,_),
	propedit_db_dyncontrol(Win,TableId,_,Property_Id,_),!,
	trap(WinCtrl = win_GetCtlHandle(Win,propedit_idc_DynCtrl),_,fail),
	win_SetFocus(WinCtrl),
	retractAll(propedit_db_PushPressed(Win)),
	assert(propedit_db_PushPressed(Win)),
	Callback(Win,callPBPressed(Property_Id)),
	!.

  propedit_eh(Win,e_Menu(propedit_idc_post_MoveActiveDown,_),0):- % Move active control Down
	propedit_db_dyncontrol(Win,TblId,FieldPos,_Prop_Id,_),
	Pos = FieldPos + 1,
	propedit_db_field(Win,TblId,Pos,property(Prop_ID_Next,_,_,_,_),_Ft),
	propedit_SetMarker(Win,Prop_ID_Next),
	!.
  propedit_eh(Win,e_Menu(propedit_idc_post_MoveActiveUp,_),0):- % Move active control Up
	propedit_db_dyncontrol(Win,TblId,FieldPos,_Prop_Id,_),
	Pos = FieldPos - 1,
	propedit_db_field(Win,TblId,Pos,property(Prop_ID_Next,_,_,_,_),_Ft),
	propedit_SetMarker(Win,Prop_ID_Next),
	!.
  propedit_eh(Win,e_Menu(propedit_idc_post_MoveActivePrev,_),0):- % Move active control to previous position
	win_SetFocus(Win),
	propedit_db_PrevActCtrl(Win,PropID,Str),
	propedit_SetMarker(Win,PropID),
	trap(WinCtrl = win_GetCtlHandle(Win,propedit_idc_DynCtrl),_,fail),
	win_SetText(WinCtrl,Str),
	str_len(Str,Length),
	win_SelectText(WinCtrl,0,Length),
	retractAll(propedit_db_ControlMod(Win)),
	assert(propedit_db_ControlMod(Win)),
	win_SetActiveWindow(Win),
	!.

% Scroll sub class event handler
  propedit_subScroll_EH(ScrollWin,e_GetFocus(),0):- % Scroll getfocus event handling
	Win = win_GetParent(ScrollWin),
	not(propedit_db_ActiveEditor(Win)),% If Property Editor get focus
	assert(propedit_db_ActiveEditor(Win)),
	win_PostEvent(Win,e_Menu(propedit_idc_post_getFocus,0)),
	!.
  propedit_subScroll_EH(ScrollWin,e_LoseFocus(),0):- % Scroll getfocus event handling
	Win = win_GetParent(ScrollWin),
	win_PostEvent(Win,e_Menu(propedit_idc_post_ChkFocus,0)),
	!.

% DynControl sub class event handler
  propedit_subDyn_EH(WinCtrl,e_KeyDown(k_down,c_Nothing),0):- % Down arrow
	propedit_GetParent(WinCtrl,Win),!,
	win_PostEvent(Win,e_Menu(propedit_idc_post_MoveActiveDown,0)).
  propedit_subDyn_EH(_,e_KeyUp(k_down,c_Nothing),0):-!.
  propedit_subDyn_EH(_,e_Char(k_down,c_Nothing),0):-!.

  propedit_subDyn_EH(WinCtrl,e_KeyDown(k_up,c_Nothing),0):- % Up arrow
	propedit_GetParent(WinCtrl,Win),!,
	win_PostEvent(Win,e_Menu(propedit_idc_post_MoveActiveUp,0)).
  propedit_subDyn_EH(_,e_KeyUp(k_up,c_Nothing),0):-!.
  propedit_subDyn_EH(_,e_Char(k_up,c_Nothing),0):-!.

  propedit_subDyn_EH(WinCtrl,e_KeyDown('\t',c_Nothing),0):- % Tab
	propedit_GetParent(WinCtrl,Win),!,
	win_PostEvent(Win,e_Menu(propedit_idc_post_MoveActiveDown,0)).
  propedit_subDyn_EH(_,e_KeyUp('\t',c_Nothing),0):-!.
  propedit_subDyn_EH(_,e_Char('\t',c_Nothing),0):-!.

  propedit_subDyn_EH(WinCtrl,e_KeyDown('\t',c_Shift),0):- % Shift Tab
	propedit_GetParent(WinCtrl,Win),!,
	win_PostEvent(Win,e_Menu(propedit_idc_post_MoveActiveUp,0)).
  propedit_subDyn_EH(_,e_KeyUp('\t',c_Shift),0):-!.
  propedit_subDyn_EH(_,e_Char('\t',c_Shift),0):-!.

  propedit_subDyn_EH(WinCtrl,e_KeyDown('\r',c_Nothing),0):- % Enter
	propedit_GetParent(WinCtrl,Win),!,
	win_PostEvent(Win,e_Menu(propedit_idc_post_MoveActiveDown,0)).
  propedit_subDyn_EH(_,e_KeyUp('\r',c_Nothing),0):-!.
  propedit_subDyn_EH(_,e_Char('\r',c_Nothing),0):-!.

  propedit_subDyn_EH(WinCtrl,e_KeyDown('\r',c_Shift),0):- % Shift Enter
	propedit_GetParent(WinCtrl,Win),!,
	win_PostEvent(Win,e_Menu(propedit_idc_post_MoveActiveUp,0)).
  propedit_subDyn_EH(_,e_KeyUp('\r',c_Shift),0):-!.
  propedit_subDyn_EH(_,e_Char('\r',c_Shift),0):-!.

