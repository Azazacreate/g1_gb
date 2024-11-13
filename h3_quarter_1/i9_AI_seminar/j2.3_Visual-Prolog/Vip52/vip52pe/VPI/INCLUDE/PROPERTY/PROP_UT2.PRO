/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S 

 FileName:	PROP_UT2.PRO
 Purpose:	Property Editor object
 Written by:	Andrey Skobelev
 Build:		008.981112
 Tested with:   Visual Prolog v.5.1 build 555a
 Comments:	
******************************************************************************/

predicates
procedure  propedit_GetTableList(PROPERTY_SHEET,TABLELIST)
determ propedit_InitTblDb(WINDOW,PROPERTY_SHEET)
determ propedit_InitFieldDb(WINDOW,PROPERTY_TBLID,INTEGER Pos,PROPERTY_LIST)
procedure  INTEGER propedit_GetSelAreaHeight(PROPERTY_SHEET,INTEGER Step)
procedure  propdit_assertSrollInfo(WINDOW,PROPERTY_TBLID,INTEGER MAX)
determ propedit_Chk_EditorFocus(WINDOW,WINDOW)

clauses

  propedit_Chk_AktivEditor(Win):- % If Custom Editor is not active 
	propedit_db_EditorIsCustom(Win),
	WinAct = win_GetFocus(),
	not(propedit_Chk_EditorFocus(Win,WinAct)),
	not(WinAct = win_GetParent(Win)),
	!.
  propedit_Chk_AktivEditor(Win):- % If Top level Editor is not active 
	propedit_db_TopLevelEditor(Win),
	WinAct = win_GetFocus(),
	not(propedit_Chk_EditorFocus(Win,WinAct)),
	!.

  propedit_Chk_EditorFocus(Win,WinAct):- WinAct = Win,!.
  propedit_Chk_EditorFocus(Win,WinAct):-
	trap(WinAct = win_GetCtlHandle(Win,propedit_idc_lbox),_,fail),!.
  propedit_Chk_EditorFocus(Win,WinAct):-
	trap(WinAct = win_GetCtlHandle(Win,propedit_idc_vscroll),_,fail),!.
  propedit_Chk_EditorFocus(Win,WinAct):-
	trap(WinAct = win_GetCtlHandle(Win,propedit_idc_DynCtrl),_,fail),!.
  propedit_Chk_EditorFocus(Win,WinAct):-
	trap(WinDynC = win_GetCtlHandle(Win,propedit_idc_DynCtrl),_,fail),
	WinDynC = win_GetParent(WinAct),!.
  propedit_Chk_EditorFocus(Win,WinAct):-
	trap(WinAct = win_GetCtlHandle(Win,propedit_idc_DynPB),_,fail),!.

  propedit_send_created_notification(Win,Callback):-Callback(Win,created),!. 
  propedit_send_created_notification(_,_). % created notification

  propedit_GetParent(WinCtrl,Win):- % Get parent for active control window
	trap(Win = win_GetParent(WinCtrl),_,fail),
	propedit_db_dyncontrol(Win,_TableId,_Pos,_PropID,b_false),!. 
  propedit_GetParent(WinCtrl,Win):- % Get parent for active wc_LBoxEdit control window
	trap(WinParent = win_GetParent(WinCtrl),_,fail),
	trap(Win = win_GetParent(WinParent),_,fail),
	propedit_db_dyncontrol(Win,_TableId,_Pos,_PropID,b_false),!. 

% ******** Database initialization *********
  propedit_init_db(Win,Property_Sheet,Callback,Size_title_fields):-
	propedit_GetTableList(Property_Sheet,TableList),% List of tables
	win_GetFontMetrics(Win,_,Asc,Desc), 
  	Step = Asc + Desc + propedit_con_DeltaCtrlHeight + propedit_con_separator,% Field step
	SelHeight = propedit_GetSelAreaHeight(Property_Sheet,Step),% Table Selector Area height
	RCT = win_GetClientRect(Win),
	RCT = rct(_,_,XR,_),
	Left = Size_title_fields, % Left and Right positions of the field
	Right = XR - propedit_con_field_marg,
	assert(propedit_db_info(Win,RCT,TableList,Callback,SelHeight,Step,Left,Right,Size_title_fields,Property_Sheet)),
	propedit_InitTblDb(Win,Property_Sheet),!.

  propedit_GetTableList([],[]):-!.
  propedit_GetTableList([pTbl(Id,Title,_)|L1],[table(Id,Title)|L2]):-!,
	propedit_GetTableList(L1,L2).
  propedit_GetTableList(_,[]):-!.

  propedit_GetSelAreaHeight([],_,0):-!.		% Empty list
  propedit_GetSelAreaHeight([_|[]],_,0):-!. 	% List contains 1 el.,SelHeight = 0
  propedit_GetSelAreaHeight(_,Step,SelHeight):-SelHeight = Step * 2.

  propedit_InitTblDb(_,[]):-!.
  propedit_InitTblDb(Win,[pTbl(TblId,_,FieldList)|L]):-
	propedit_InitFieldDb(Win,TblId,1,FieldList),!,
	propedit_InitTblDb(Win,L).

  propedit_InitFieldDb(Win,TblId,Max,[]):-!,
	NumFields = Max - 1,
	propdit_assertSrollInfo(Win,TblId,NumFields).% Assert number of fields for each table
  propedit_InitFieldDb(Win,TblId,Pos,[Prop|L]):-
	propedit_db_info(Win,_,_,_,SelHeight,Step,_,_,_,_),!,
	Top  = SelHeight + (Pos-1)*Step + propedit_con_separator,% Field top 
	assert(propedit_db_field(Win,TblId,Pos,Prop,Top)),
	Pos1 = Pos + 1,						% Field position
	propedit_InitFieldDb(Win,TblId,Pos1,L).

  propdit_assertSrollInfo(Win,TblId,NumFields):- 
	retract(propedit_db_scroll(Win,TblId,POS,_)), % assert information for scroll control
	assert(propedit_db_scroll(Win,TblId,POS,NumFields)),!.
  propdit_assertSrollInfo(Win,TblId,NumFields):-
	assert(propedit_db_scroll(Win,TblId,1,NumFields)),!.

  propedit_RenameFieldsToOld(Win):-
	retract(propedit_db_field(Win,TblId,Pos,Prop,Ft)),
	assert(propedit_db_field_old(Win,TblId,Pos,Prop,Ft)),
	fail.
  propedit_RenameFieldsToOld(Win):-
	retractAll(propedit_db_field(Win,_,_,_,_)),
	!.
% ******* Create Table Selector and Scrollbar **********
predicates
procedure  propedit_GetTitlelist(TABLELIST,SLIST)
procedure  propedit_CreateScrollbar(WINDOW,PROPERTY_TBLID)
procedure  propedit_CalcScrollRange(WINDOW,PROPERTY_TBLID,INTEGER NextPos,INTEGER Out_Pos)
procedure  propedit_DelScroll(WINDOW)
clauses
  propedit_del_LB(Win):- % Delete Table Selector
	trap(WinLb = win_GetCtlHandle(Win,propedit_idc_lbox),_,fail),
	win_Destroy(WinLb),!.
  propedit_del_LB(_).
  propedit_DelScroll(Win):- % Delete scroll
	trap(WinSc = win_GetCtlHandle(Win,propedit_idc_vscroll),_,fail),
	win_Destroy(WinSc),!.
  propedit_DelScroll(_).

  propedit_create_controls(Win):-
	propedit_db_info(Win,_,TableList,_,SelHeight,_,_,_,_,_),
	SelHeight > 0,!,			% If SelHeight > 0 then
	Fnt = win_GetFont(Win),
	ParentRCT = win_GetClientRect(Win),	%   create Table Selector
	ParentRCT = rct(_,_,R,_),		
	R1 = R - propedit_con_field_marg,
	SelWin = win_CreateControl(wc_LBoxButton,rct(propedit_con_field_marg,5,R1,propedit_con_ListBut_Height),"",Win,
		propedit_TblSel_Flags,propedit_idc_lbox),
 	win_SetState(SelWin,[wsf_Visible]),
	win_SetFont(SelWin,Fnt),
 	win_Clear(Win,rct(0,0,R,SelHeight),color_LtGray),
	propedit_GetTitlelist(TableList,TitleList), % Get Title list for Table Selector
	lbox_Add(SelWin,TitleList),
	lbox_SetSel(SelWin,0,b_true),
	propedit_HandleScroll(Win). % Create, move or delete scroll, if it is necessary
  propedit_create_controls(Win):-
	propedit_HandleScroll(Win),!.
  propedit_create_controls(_).

  propedit_CreateScrollbar(Win,TblId):- % Create Scroll control
	propedit_db_info(Win,_,_,_,SelHeight,_,_,_,_,_),
	CliRCT = win_GetClientRect(Win),
	CliRct = rct(_,_,R,B),
	SL = R - propedit_con_vscroll_width, 			% scroll left
	ST = SelHeight + propedit_con_ScrollTopBotMarging,	% scroll top
	SB = B - propedit_con_ScrollTopBotMarging,		% scroll bottom
	WinCtrl = win_CreateControl(wc_VScroll,rct(SL,ST,R,SB), "",Win,[wsf_NoClipSiblings,wsf_TabStop],propedit_idc_vscroll ),
	win_SetSubClassHandler(WinCtrl,propedit_subScroll_EH,b_false),
	propedit_CalcScrollRange(Win,TblId,1,EndPos),
	win_SetScrollRange(WinCtrl,sb_Ctl,1,EndPos),
	win_SetScrollPos(WinCtrl,sb_Ctl,1),
 	!.
  propedit_CreateScrollbar(_,_).

  propedit_GetTitlelist([],[]):-!. % Get Title list for Table Selector
  propedit_GetTitlelist([table(_,Title)|L1],[Title|L2]):-!,
	propedit_GetTitlelist(L1,L2).
  propedit_GetTitlelist(_,[]):-!.

% ********* Drawing of the Property fields **********
predicates
determ  propedit_DrawFields(WINDOW,PROPERTY_TBLID,INTEGER FirstVisible,INTEGER Step,INTEGER LeftField,INTEGER RightField,BOOLEAN Reload)
determ  propedit_PropCtrlToStr(PROPERTY_CONTROL,STRING)
determ  propedit_compare_NewOldField(WINDOW,PROPERTY_TBLID,INTEGER Pos,Property,INTEGER Ft,BOOLEAN Reload)
determ  propedit_MemberIndex(STRING,SLIST,INTEGER)
determ  propedit_MemberIndex(TABLE,TABLELIST,INTEGER)
%  propedit_member(STR_PROPERTY,STR_PROPERTIES)
determ  propedit_member(INT_PROPERTY,INT_PROPERTIES)
determ  propedit_member(LONG_PROPERTY,LONG_PROPERTIES)
determ  propedit_member(REAL_PROPERTY,REAL_PROPERTIES)
determ  propedit_member(TABLE,TABLELIST)
determ propedit_ChkRangeStr(WINDOW,Property_ERROR_PROMPT,STR_Properties,STRING,STRING)
determ  propedit_ChkRangeInt(WINDOW,Property_ERROR_PROMPT,INT_Properties,PROPERTY_INT,PROPERTY_INT)
determ  propedit_ChkRangeReal(WINDOW,Property_ERROR_PROMPT,REAL_Properties,PROPERTY_REAL,PROPERTY_REAL)
determ  propedit_ChkRangeLong(WINDOW,Property_ERROR_PROMPT,LONG_Properties,PROPERTY_LONG,PROPERTY_LONG)
determ propedit_HandleMinMaxRangeStr(WINDOW,Property_ERROR_PROMPT,STR_Property,STRING,STRING)
determ  propedit_HandleMinMaxRangeInt(WINDOW,Property_ERROR_PROMPT,INT_Property,PROPERTY_INT,PROPERTY_INT)
determ  propedit_HandleMinMaxRangeReal(WINDOW,Property_ERROR_PROMPT,REAL_Property,PROPERTY_REAL,PROPERTY_REAL)
determ  propedit_HandleMinMaxRangeLong(WINDOW,Property_ERROR_PROMPT,LONG_Property,PROPERTY_LONG,PROPERTY_LONG)
determ  propedit_BildMsgStr(WINDOW,STRING Input,STRING Min,STRING Max,STRING Len,Property_ERROR_PROMPT)
determ propedit_BildMsgStr1(WINDOW,STRING Input,STRING TestStr,STRING Min,STRING Max,STRING Len,Property_ERROR_PROMPT)
procedure  propedit_InsertSubString(STRING Input,STRING SubStr,STRING Insert,STRING Out)
procedure  propedit_OkNote(WINDOW,STRING)
procedure  propedit_frontstr(INTEGER,STRING,STRING)
  propedit_NoteEh : EHANDLER
clauses
  propedit_ShowFields(Win,Reload):- % If number of Tables > 1
	propedit_db_info(Win,_,_,_,SelHeight,Step,FL,FR,_,_),
	SelHeight > 0,
	TblId = propedit_GetActiveTbl(Win),
	propedit_db_scroll(Win,TblId,FirstVisible,_),!,
        % Draw line under Table Selector
	ParentRCT = win_GetClientRect(Win), ParentRCT=rct(_,_,XP,_),
	X1=propedit_con_field_marg,
	YLine=SelHeight - Step div 2, Pnt1=pnt(X1,YLine), Pnt2=pnt(Xp,YLine),
	win_SetPen(Win,pen(1,ps_Solid,color_Gray)),
	draw_Line(Win,Pnt1,Pnt2),
	win_SetPen(Win,pen(1,ps_Hollow,color_LtGray)),
	propedit_DrawFields(Win,TblId,FirstVisible,Step,FL,FR,Reload).
  propedit_ShowFields(Win,Reload):- % IF only 1 Table exist
	propedit_db_info(Win,_,TableList,_,_,Step,FL,FR,_,_),
	TableList = [table(TblId,_)],
	propedit_db_scroll(Win,TblId,FirstVisible,_),!,
	propedit_DrawFields(Win,TblId,FirstVisible,Step,FL,FR,Reload).

  propedit_DrawFields(Win,TblId,FirstVisible,Step,FL,FR,Reload):- % Draw fields
	ParentRCT = win_GetClientRect(Win),
	ParentRCT = rct(_,_,_,B),
	propedit_db_field(Win,TblId,Pos,Prop,Ft),
	  not(propedit_compare_NewOldField(Win,TblId,Pos,Prop,Ft,Reload)),
	  Pos >= FirstVisible,
	  FT1 = FT - Step*(FirstVisible - 1),
	  FB1 = FT1 + Step - propedit_con_separator,
	  FT1 <= B - propedit_con_separator,
	  Prop = property(_,Prop_Title,Prop_Ctrl,_,_),
     	  RCT_title = rct(propedit_con_field_marg,FT1,FL,FB1), FR1 = FR + 1,
ifdef ws_win
	  RCT_val = rct(FL,FT1,FR1,FB1),
elsedef
	  FT1os2 = FT1 - 1, FB1os2 = FB1 - 1, RCT_val = rct(FL,FT1os2,FR1,FB1os2),	
enddef
	  propedit_PropCtrlToStr(Prop_Ctrl,Str),
	  concat(Prop_Title,"...................................................................................................................................................",Title_out),
	  draw_TextInRect(Win,RCT_title,Title_out,-1,[dtext_left,dtext_SingleLine]),
	  draw_Rect(Win,RCT_val),
	  win_SetBackMode(Win,bk_Transparent),
	  draw_TextInRect(Win,RCT_val,Str ,-1,[dtext_Left,dtext_SingleLine]),
	  win_SetBackMode(Win,bk_Opaque),
	fail.
  propedit_DrawFields(Win,_,_,_,_,_,_):- % Clear under last field and clear marging area
	propedit_db_info(Win,rct(_,_,_,B),_,_,SelHeight,Step,_,FR,_,_),
	TblId = propedit_GetActiveTbl(Win),
	propedit_db_scroll(Win,TblId,FirstVisible,MaxFields),!,
	T = (MaxFields - FirstVisible + 1) * Step + SelHeight,
	propedit_Cliar_MargArea(Win), R = FR + propedit_con_field_marg,
 	win_Clear(Win,rct(0,T,R,B),color_LtGray),
	!.

  propedit_compare_NewOldField(_,_,_,_,_,b_false):- fail.
  propedit_compare_NewOldField(Win,TblId,Pos,property(PId,PTitle,editstr(Str,_),_,PB),Ft,b_true):-
	propedit_db_field_Old(Win,TblId,Pos,property(PId,PTitle,editstr(Str,_),_,PB),Ft),!.
  propedit_compare_NewOldField(Win,TblId,Pos,property(PId,PTitle,editInt(Str,_),_,PB),Ft,b_true):-
	propedit_db_field_Old(Win,TblId,Pos,property(PId,PTitle,editInt(Str,_),_,PB),Ft),!.
  propedit_compare_NewOldField(Win,TblId,Pos,property(PId,PTitle,editLong(Str,_),_,PB),Ft,b_true):-
	propedit_db_field_Old(Win,TblId,Pos,property(PId,PTitle,editLong(Str,_),_,PB),Ft),!.
  propedit_compare_NewOldField(Win,TblId,Pos,property(PId,PTitle,editReal(Str,_),_,PB),Ft,b_true):-
	propedit_db_field_Old(Win,TblId,Pos,property(PId,PTitle,editReal(Str,_),_,PB),Ft),!.
  propedit_compare_NewOldField(Win,TblId,Pos,property(PId,PTitle,listButton(Sl,Sel),_,PB),Ft,b_true):-
	propedit_db_field_Old(Win,TblId,Pos,property(PId,PTitle,listButton(Sl,Sel),_,PB),Ft),!.
  propedit_compare_NewOldField(Win,TblId,Pos,property(PId,PTitle,listEdit(Sl,Str,_),_,PB),Ft,b_true):-
	propedit_db_field_Old(Win,TblId,Pos,property(PId,PTitle,listEdit(Sl,Str,_),_,PB),Ft),!.

  propedit_PropCtrlToStr(editStr(STR,_),STR):-!. % Convertion Property_Control to string
  propedit_PropCtrlToStr(editInt(i(INT),_),STR):-
    	trap(str_int(STR,INT),_,fail),!.
  propedit_PropCtrlToStr(editInt(void,_),STR):-
    	STR="",!.
  propedit_PropCtrlToStr(editLong(l(LNG),_),STR):-
      	trap(term_str(long,LNG,STR),_,fail),!.
  propedit_PropCtrlToStr(editLong(void,_),STR):-
      	STR="",!.
  propedit_PropCtrlToStr(editReal(r(RL),_),STR):-
       	trap(str_real(STR,RL),_,fail),!.
  propedit_PropCtrlToStr(editReal(void,_),STR):-
       	STR="",!.
  propedit_PropCtrlToStr(listButton(SList,Index),STR):-
	I1 = Index + 1,
	propedit_MemberIndex(STR,SList,I1),!.
  propedit_PropCtrlToStr(listEdit(_,STR,_),STR):-!.

% +++ Convertion string to Property_Control +++
% fail if new Property_Control = old Property_Control 
  propedit_Str_To_PropControl(Win,editStr(STRpred,P),STR,_Selected,editStr(StrOut,P),ERR_P):- 
	propedit_ChkRangeStr(Win,ERR_P,P,STR,StrOut),not(STRpred = StrOut),!. 				

  propedit_Str_To_PropControl(Win,editInt(i(INTpred),P),STR,_Selected,editInt(i(OutV),P),ERR_P):-
	trap(str_int(STR,INTV),_,fail), propedit_ChkRangeInt(Win,ERR_P,P,i(INTV),i(OutV)),!,
	not(INTpred = OutV).
  propedit_Str_To_PropControl(Win,editInt(void,P),STR,_Selected,editInt(i(OutV),P),ERR_P):-
	not(str_Len(STR,0)), trap(str_int(STR,INTV),_,fail),
	propedit_ChkRangeInt(Win,ERR_P,P,i(INTV),i(OutV)),!.
  propedit_Str_To_PropControl(Win,editInt(i(INTpred),P),STR,_Selected,editInt(i(OutV),P),ERR_P):-
	str_Len(STR,0),propedit_ChkRangeInt(Win,ERR_P,P,void,PO),PO = i(OutV),!,not(INTpred = OutV).
  propedit_Str_To_PropControl(Win,editInt(i(_INTpred),P),STR,_Selected,editInt(void,P),ERR_P):-
	str_Len(STR,0),propedit_ChkRangeInt(Win,ERR_P,P,void,PO),PO = void,!.

  propedit_Str_To_PropControl(Win,editLong(l(LONGpred),P),STR,_Selected,editLong(l(OutL),P),ERR_P):-
      	trap(term_str(long,LNG,STR),_,fail), propedit_ChkRangeLong(Win,ERR_P,P,l(LNG),l(OutL)),!,
      	not(LONGpred = OutL).
  propedit_Str_To_PropControl(Win,editLong(void,P),STR,_Selected,editLong(l(OutL),P),ERR_P):-
	not(str_Len(STR,0)), trap(term_str(long,LNG,STR),_,fail),
	propedit_ChkRangeLong(Win,ERR_P,P,l(LNG),l(OutL)),!.
  propedit_Str_To_PropControl(Win,editLong(l(LONGpred),P),STR,_Selected,editLong(l(OutL),P),ERR_P):-
	str_Len(STR,0),propedit_ChkRangeLong(Win,ERR_P,P,void,PO),PO = l(OutL),!,not(LONGpred = OutL).
  propedit_Str_To_PropControl(Win,editLong(l(_LONGpred),P),STR,_Selected,editLong(void,P),ERR_P):-
	str_Len(STR,0),propedit_ChkRangeLong(Win,ERR_P,P,void,PO),PO = void,!.

  propedit_Str_To_PropControl(Win,editReal(r(REALpred),P),STR,_Selected,editReal(r(OutR),P),ERR_P):-
	trap(str_real(STR,RL),_,fail), propedit_ChkRangeReal(Win,ERR_P,P,r(RL),r(OutR)),!,
	not(REALpred = OutR).
  propedit_Str_To_PropControl(Win,editReal(void,P),STR,_Selected,editReal(r(OutR),P),ERR_P):-
	not(str_Len(STR,0)), trap(str_real(STR,RL),_,fail),
	propedit_ChkRangeReal(Win,ERR_P,P,r(RL),r(OutR)),!.
  propedit_Str_To_PropControl(Win,editReal(r(REALpred),P),STR,_Selected,editReal(r(OutR),P),ERR_P):-
	str_Len(STR,0),propedit_ChkRangeReal(Win,ERR_P,P,void,PO),PO = r(OutR),!,not(REALpred = OutR).
  propedit_Str_To_PropControl(Win,editReal(r(_REALpred),P),STR,_Selected,editReal(void,P),ERR_P):-
	str_Len(STR,0),propedit_ChkRangeReal(Win,ERR_P,P,void,PO),PO = void,!.

  propedit_Str_To_PropControl(_Win,listButton(Sl,SelPred),_STR,Selected,listButton(Sl,Selected),_ERR_P):-
	not(SelPred = Selected),!.
  propedit_Str_To_PropControl(Win,listEdit(List,STRpred,P),StrIn,_Selected,listEdit(List,StrOut,P),ERR_P):-
	propedit_ChkRangeStr(Win,ERR_P,P,StrIn,StrOut),not(STRpred = StrOut),!.

  propedit_Str_To_PropControl(Win,_,STR,_Selected,_,ERR_P):-
	concat(Str," ",OutStr),
	propedit_BildMsgStr1(Win,STR,OutStr,"","","",Err_p),
	fail.

  propedit_BildMsgStr1(Win,InputStr,OutStr,MinStr,MaxStr,LenStr,Err_p):-
	not(InputStr = OutStr),
	propedit_BildMsgStr(Win,InputStr,MinStr,MaxStr,LenStr,Err_p), % check and create error messege
	!,fail.
  propedit_BildMsgStr1(_,_,_,_,_,_,_):-!.

  propedit_BildMsgStr(Win,InputStr,_MinStr,_MaxStr,_LenStr,user_prompt(PromptStr)):-
	propedit_InsertSubString(PromptStr,"%",InputStr,PromptStr1), % create error messege if 
	propedit_InsertSubString(PromptStr1,"%",InputStr,PromptStr2),% errror prompt is user prompt
	retract(propedit_db_NoAskPrompt(Win)),
	propedit_db_dyncontrol(Win,_TableId,_Pos,PropID,_),
	retractAll(propedit_db_PrevActCtrl(Win,_,_)),
	assert(propedit_db_PrevActCtrl(Win,PropID,InputStr)),
	assert(propedit_db_Note(Win)),
	propedit_OkNote(Win,PromptStr2),
	retract(propedit_db_Note(Win)),
	win_PostEvent(Win,e_Menu(propedit_idc_post_MoveActivePrev,0)),% Move active control to previous position
	!.
  propedit_BildMsgStr(_,_,_,_,_,user_prompt(_)):-!.

  propedit_OkNote(Win,Str):-
	not(propedit_db_NowResize(Win)),
	propedit_db_dyncontrol(Win,TableId,Pos,PropID,_),
	propedit_db_field(Win,TableId,Pos,Prop,_Top_y),
	Prop = property(PropID,Title,_PropCtrl,_Err_P,_OkPushbutton),!,
	concat(Title,"  ???",DlgTitle),
	dlg_Note(DlgTitle,STR),
	!.  
  propedit_OkNote(_,_).

  propedit_NoteEh(DlgWin,e_Control(_,_,_,activated()),0):-!,
	win_Destroy(DlgWin).
  propedit_NoteEh(_,_,0):-!,fail.

  propedit_InsertSubString(PromptStr,SubStr,InsertStr,OutStr):-
	searchstring(PromptStr,SubStr,Pos), FrontChars = Pos - 1,
	frontstr(FrontChars,PromptStr,StartStr,EndString),
	concat(SubStr,X,EndString),
	concat(StartStr,InsertStr,Str1),
	concat(Str1,X,OutStr),
	!.
  propedit_InsertSubString(PromptStr,_SubStr,_InsertStr,PromptStr):-!.

  propedit_ChkRangeStr(_Win,_,[],InV,InV):-!. % Check String (number of chars)
  propedit_ChkRangeStr(Win,ERR_P,[L1|L2],InVal,OutV):-!,
	propedit_HandleMinMaxRangeStr(Win,ERR_P,L1,InVal,OutVal),
	propedit_ChkRangeStr(Win,ERR_P,L2,OutVal,OutV).

  propedit_HandleMinMaxRangeStr(Win,ERR_P,length(Len),StrIn,StartStr):- % number of chars = Length (always)
	format(Fstring,"%s%ds","\%-",Len),format(StrOut,Fstring,StrIn),
	propedit_frontstr(Len,StrOut,StartStr),
	trap(str_int(StrLen,Len),_,fail),!,propedit_BildMsgStr1(Win,StrIn,StartStr,"","",StrLen,ERR_P).
  propedit_HandleMinMaxRangeStr(Win,ERR_P,minimum(Len),StrIn,StrOut):- % Number of chars: From ..
	format(Fstring,"%s%ds","\%-",Len),format(StrOut,Fstring,StrIn),
	trap(str_int(StrMin,Len),_,fail),!,propedit_BildMsgStr1(Win,StrIn,StrOut,StrMin,"","",ERR_P).
  propedit_HandleMinMaxRangeStr(Win,ERR_P,maximum(Len),StrIn,StartStr):- % Number of chars: .. To
	propedit_frontstr(Len,StrIn,StartStr),
	trap(str_int(StrMax,Len),_,fail),!,propedit_BildMsgStr1(Win,StrIn,StartStr,"",StrMax,"",ERR_P).
  propedit_HandleMinMaxRangeStr(Win,ERR_P,range(Min,Max),StrIn,StartStr):- % Number of chars: From MIN To MAX
	format(Fstring,"%s%ds","\%-",Min),format(StrOut,Fstring,StrIn),
	propedit_frontstr(Max,StrOut,StartStr),
	trap(str_int(StrMax,Max),_,fail),trap(str_int(StrMin,Min),_,fail),!,
	propedit_BildMsgStr1(Win,StrIn,StartStr,StrMin,StrMax,"",ERR_P).
  propedit_HandleMinMaxRangeStr(_Win,_,_,StrIn,StrIn).

  propedit_frontstr(Max,StrIn,StrOut):-
	str_len(StrIn,Len), Len>Max,
	frontstr(Max,StrIn,StrOut,_),
	!.
  propedit_frontstr(_,StrIn,StrIn).
  
  propedit_ChkRangeInt(_Win,_,[],InV,InV):-!. % Check INTEGER range 
  propedit_ChkRangeInt(Win,ERR_P,[L1|L2],InVal,OutV):-
	propedit_HandleMinMaxRangeInt(Win,ERR_P,L1,InVal,OutVal),
	propedit_ChkRangeInt(Win,ERR_P,L2,OutVal,OutV).

  propedit_HandleMinMaxRangeInt(Win,ERR_P,minimum(MinVal),i(InVal),i(MinVal)):- InVal < MinVal,
	trap(str_int(StrMin,MinVal),_,fail),
	trap(str_int(StrIn,InVal),_,fail),!,
	propedit_BildMsgStr1(Win,StrIn,StrMin,StrMin,"","",ERR_P).
  propedit_HandleMinMaxRangeInt(Win,ERR_P,minimum(MinVal),void,i(MinVal)):- 
	trap(str_int(StrMin,MinVal),_,fail),!,
	propedit_BildMsgStr1(Win,"",StrMin,StrMin,"","",ERR_P).
  propedit_HandleMinMaxRangeInt(_Win,_,minimum(_MinVal),i(InVal),i(InVal)):- !.

  propedit_HandleMinMaxRangeInt(Win,ERR_P,maximum(MaxVal),i(InVal),i(MaxVal)):- InVal > MaxVal,
	trap(str_int(StrMax,MaxVal),_,fail),
	trap(str_int(StrIn,InVal),_,fail),!,
	propedit_BildMsgStr1(Win,StrIn,StrMax,"",StrMax,"",ERR_P).
  propedit_HandleMinMaxRangeInt(Win,ERR_P,maximum(MaxVal),void,i(MaxVal)):-
	trap(str_int(StrMax,MaxVal),_,fail),!,
	propedit_BildMsgStr1(Win,"",StrMax,"",StrMax,"",ERR_P).
  propedit_HandleMinMaxRangeInt(_Win,_,maximum(_MaxVal),i(InVal),i(InVal)):-!.

  propedit_HandleMinMaxRangeInt(Win,ERR_P,range(MinVal,MaxVal),i(InVal),i(MinVal)):- InVal < MinVal,
	trap(str_int(StrMin,MinVal),_,fail),
	trap(str_int(StrMax,MaxVal),_,fail),
	trap(str_int(StrIn,InVal),_,fail),!,
	propedit_BildMsgStr1(Win,StrIn,StrMin,StrMin,StrMax,"",ERR_P).
  propedit_HandleMinMaxRangeInt(Win,ERR_P,range(MinVal,MaxVal),i(InVal),i(MaxVal)):- InVal > MaxVal,
	trap(str_int(StrMin,MinVal),_,fail),
	trap(str_int(StrMax,MaxVal),_,fail),
	trap(str_int(StrIn,InVal),_,fail),!,
	propedit_BildMsgStr1(Win,StrIn,StrMax,StrMin,StrMax,"",ERR_P).
  propedit_HandleMinMaxRangeInt(Win,ERR_P,range(MinVal,MaxVal),void,i(MinVal)):-
	trap(str_int(StrMin,MinVal),_,fail),
	trap(str_int(StrMax,MaxVal),_,fail),!,
	propedit_BildMsgStr1(Win,"",StrMin,StrMin,StrMax,"",ERR_P).
  propedit_HandleMinMaxRangeInt(_Win,_,_,PInVal,PInVal):- !.


  propedit_ChkRangeLONG(_Win,_,[],InV,InV):-!. % Check LONG range 
  propedit_ChkRangeLONG(Win,ERR_P,[L1|L2],InVal,OutV):-
	propedit_HandleMinMaxRangeLONG(Win,ERR_P,L1,InVal,OutVal),
	propedit_ChkRangeLONG(Win,ERR_P,L2,OutVal,OutV).

  propedit_HandleMinMaxRangeLong(Win,ERR_P,minimum(MinVal),l(InVal),l(MinVal)):- InVal < MinVal,
	trap(term_str(long,MinVal,StrMin),_,fail),
	trap(term_str(long,InVal,StrIn),_,fail),!,
	propedit_BildMsgStr1(Win,StrIn,StrMin,StrMin,"","",ERR_P).
  propedit_HandleMinMaxRangeLong(Win,ERR_P,minimum(MinVal),void,l(MinVal)):-
	trap(term_str(long,MinVal,StrMin),_,fail),!,
	propedit_BildMsgStr1(Win,"",StrMin,StrMin,"","",ERR_P).
  propedit_HandleMinMaxRangeLong(_Win,_,minimum(_MinVal),l(InVal),l(InVal)):- !.

  propedit_HandleMinMaxRangeLong(Win,ERR_P,maximum(MaxVal),l(InVal),l(MaxVal)):- InVal > MaxVal,
	trap(term_str(long,MaxVal,StrMax),_,fail),
	trap(term_str(long,InVal,StrIn),_,fail),!,
	propedit_BildMsgStr1(Win,StrIn,StrMax,"",StrMax,"",ERR_P).
  propedit_HandleMinMaxRangeLong(Win,ERR_P,maximum(MaxVal),void,l(MaxVal)):-
	trap(term_str(long,MaxVal,StrMax),_,fail),!,
	propedit_BildMsgStr1(Win,"",StrMax,"",StrMax,"",ERR_P).
  propedit_HandleMinMaxRangeLong(_Win,_,maximum(_MaxVal),l(InVal),l(InVal)):-!.

  propedit_HandleMinMaxRangeLong(Win,ERR_P,range(MinVal,MaxVal),l(InVal),l(MinVal)):- InVal < MinVal,
	trap(term_str(long,MinVal,StrMin),_,fail),
	trap(term_str(long,MaxVal,StrMax),_,fail),
	trap(term_str(long,InVal,StrIn),_,fail),!,
	propedit_BildMsgStr1(Win,StrIn,StrMin,StrMin,StrMax,"",ERR_P).
  propedit_HandleMinMaxRangeLong(Win,ERR_P,range(MinVal,MaxVal),l(InVal),l(MaxVal)):- InVal > MaxVal,
	trap(term_str(long,MinVal,StrMin),_,fail),
	trap(term_str(long,MaxVal,StrMax),_,fail),
	trap(term_str(long,InVal,StrIn),_,fail),!,
	propedit_BildMsgStr1(Win,StrIn,StrMax,StrMin,StrMax,"",ERR_P).
  propedit_HandleMinMaxRangeLong(Win,ERR_P,range(MinVal,MaxVal),void,l(MinVal)):-
	trap(term_str(long,MinVal,StrMin),_,fail),
	trap(term_str(long,MaxVal,StrMax),_,fail),!,
	propedit_BildMsgStr1(Win,"",StrMin,StrMin,StrMax,"",ERR_P).
  propedit_HandleMinMaxRangeLong(_Win,_,_,PInVal,PInVal):- !.

  propedit_ChkRangeReal(_Win,_,[],InV,InV):-!. % Check Real range 
  propedit_ChkRangeReal(Win,ERR_P,[L1|L2],InVal,OutV):-
	propedit_HandleMinMaxRangeReal(Win,ERR_P,L1,InVal,OutVal),
	propedit_ChkRangeReal(Win,ERR_P,L2,OutVal,OutV).

  propedit_HandleMinMaxRangeReal(Win,ERR_P,minimum(MinVal),r(InVal),r(MinVal)):- InVal < MinVal,
	trap(str_real(StrMin,MinVal),_,fail),
	trap(str_real(StrIn,InVal),_,fail),!,
	propedit_BildMsgStr1(Win,StrIn,StrMin,StrMin,"","",ERR_P).
  propedit_HandleMinMaxRangeReal(Win,ERR_P,minimum(MinVal),void,r(MinVal)):-
	trap(str_real(StrMin,MinVal),_,fail),!,
	propedit_BildMsgStr1(Win,"",StrMin,StrMin,"","",ERR_P).
  propedit_HandleMinMaxRangeReal(_Win,_,minimum(_MinVal),r(InVal),r(InVal)):- !.

  propedit_HandleMinMaxRangeReal(Win,ERR_P,maximum(MaxVal),r(InVal),r(MaxVal)):- InVal > MaxVal,
	trap(str_real(StrMax,MaxVal),_,fail),
	trap(str_real(StrIn,InVal),_,fail),!,
	propedit_BildMsgStr1(Win,StrIn,StrMax,"",StrMax,"",ERR_P).
  propedit_HandleMinMaxRangeReal(Win,ERR_P,maximum(MaxVal),void,r(MaxVal)):-
	trap(str_real(StrMax,MaxVal),_,fail),!,
	propedit_BildMsgStr1(Win,"",StrMax,"",StrMax,"",ERR_P).
  propedit_HandleMinMaxRangeReal(_Win,_,maximum(_MaxVal),r(InVal),r(InVal)):-!.

  propedit_HandleMinMaxRangeReal(Win,ERR_P,range(MinVal,MaxVal),r(InVal),r(MinVal)):- InVal < MinVal,
	trap(str_real(StrMin,MinVal),_,fail),
	trap(str_real(StrMax,MaxVal),_,fail),
	trap(str_real(StrIn,InVal),_,fail),!,
	propedit_BildMsgStr1(Win,StrIn,StrMin,StrMin,StrMax,"",ERR_P).
  propedit_HandleMinMaxRangeReal(Win,ERR_P,range(MinVal,MaxVal),r(InVal),r(MaxVal)):- InVal > MaxVal,
	trap(str_real(StrMin,MinVal),_,fail),
	trap(str_real(StrMax,MaxVal),_,fail),
	trap(str_real(StrIn,InVal),_,fail),!,
	propedit_BildMsgStr1(Win,StrIn,StrMax,StrMin,StrMax,"",ERR_P).
  propedit_HandleMinMaxRangeReal(Win,ERR_P,range(MinVal,MaxVal),void,r(MinVal)):-
	trap(str_real(StrMin,MinVal),_,fail),
	trap(str_real(StrMax,MaxVal),_,fail),!,
	propedit_BildMsgStr1(Win,"",StrMin,StrMin,StrMax,"",ERR_P).
  propedit_HandleMinMaxRangeReal(_Win,_,_,PInVal,PInVal):- !.

predicates
determ  propedit_MoveCreateScroll(WINDOW,RCT,PROPERTY_TBLID)
determ  propedit_DestroyMoveScroll(WINDOW,RCT,INTEGER FirstPos)
procedure  propedit_SetScrollPosRange(WINDOW,INTEGER PosSet,INTEGER MaxFieldsScroll)
procedure  propedit_MoveDynByKind(WINDOW,Property_CONTROL,INTEGER Lf,INTEGER Top,INTEGER Rf,INTEGER Step)
determ  propedit_HandlePushButton(WINDOW,BOOLEAN OkPush,INTEGER Step,INTEGER Top,INTEGER Rf,INTEGER Rf1)
procedure  propedit_VisInvisDyn(WINDOW,WINDOW WinCtrl,RCT RctCtrl)
procedure  propedit_MoveIfChangeRct(WINDOW,RCT)
determ  propedit_ChangeTopLeftRight(RCT NewRctDyn,RCT OldRctDyn)
determ  propedit_Append(Property_List,Property_List,Property_List)
determ  propedit_Append(Property_Sheet,Property_Sheet,Property_Sheet)
procedure  propedit_ChekRightField(INTEGER Left,INTEGER Right,INTEGER RightOut)
procedure  propedit_ShowFieldsIfChangeScroll(WINDOW,INTEGER FirstPos,INTEGER NextPos)
clauses

  propedit_reload_scrolling_table(Win):- % If Table exist before
	TblId = propedit_GetActiveTbl(Win),
	propedit_db_scroll(Win,TblId,Pos,_), % Not change the previous positions of fields,
	propedit_set_scrolling_field(Win,TblId,Pos,_),!. %  if it is possible
  propedit_reload_scrolling_table(Win):- % If Table not exist before,
	TblId = propedit_GetActiveTbl(Win), % then first field on the first position
	propedit_set_scrolling_field(Win,TblId,1,_),!.
  propedit_reload_scrolling_table(_).

  propedit_CalcLeftRightFields(Win,Marg):- % Right, left fields calculation
	RCT = win_GetClientRect(Win),
	RCT = rct(_,_,XR,_),
	retract(propedit_db_info(Win,_,Callb,SAH,SelHeight,Step,_,_,Size_title_fields,Property_Sheet)),!,
  	Left = Size_title_fields,
  	Right = XR - Marg,
	propedit_ChekRightField(Left,Right,RightOut),
	assert(propedit_db_info(Win,RCT,Callb,SAH,SelHeight,Step,Left,RightOut,Size_title_fields,Property_Sheet)).

  propedit_ChekRightField(RightOut,Right,RightOut):- Right <= RightOut,!.
  propedit_ChekRightField(_,RightOut,RightOut).

  propedit_move_dyn_controls(Win):- % Move active control 
	TableId = propedit_GetActiveTbl(Win),
	propedit_db_info(Win,_,_,_,_,Step,Left,Right,_,_),
	propedit_db_dyncontrol(Win,TableId,_PosDyn,PropID,_),
	propedit_db_field(Win,TableId,_PosField,Prop,Top),
	propedit_db_scroll(Win,TableId,SrlPos,_),
	Prop=property(PropID,_,PropCtrl,_,OkPush),!,
	Top1=Top-(SrlPos-1)*Step,
	propedit_HandlePushButton(Win,OkPush,Step,Top1,Right,Rf1),
	propedit_MoveDynByKind(Win,PropCtrl,Left,Top1,Rf1,Step).
  propedit_move_dyn_controls(_).

  propedit_MoveDynByKind(Win,listEdit(_,_,_),Lf,Top,Rf,_Step):-% Move DynControl for listEdit
	Bottom = Top + propedit_con_ListBut_Height,
	Rct = rct(Lf,Top,Rf,Bottom),	
	propedit_MoveIfChangeRct(Win,Rct),
	!.
  propedit_MoveDynByKind(Win,listButton(_,_),Lf,Top,Rf,_Ste):-% Move DynControl for listButton
	Bottom = Top + propedit_con_ListBut_Height,
	Rct = rct(Lf,Top,Rf,Bottom),	
	propedit_MoveIfChangeRct(Win,Rct),
	!.
  propedit_MoveDynByKind(Win,_,Lf,Top,Rf,Step):-% Move DynControl for editStr,editInt,editLong,editRial
	Bottom = Top + Step - propedit_con_separator - 1,
	Rct = rct(Lf,Top,Rf,Bottom),	
	propedit_MoveIfChangeRct(Win,Rct),
	!.
  propedit_MoveDynByKind(_,_,_,_,_,_).

  propedit_MoveIfChangeRct(Win,Rct):- % Move DynControl if Top or Left or Right of field has changed
	trap(WinCtrl=win_GetCtlHandle(Win,propedit_idc_DynCtrl),_,fail),
	RctCtrl = win_GetOuterRect(WinCtrl),
	propedit_ChangeTopLeftRight(Rct,RctCtrl),
	propedit_VisInvisDyn(Win,WinCtrl,Rct), % Set Visible/Invisible
	propedit_db_dyncontrol(Win,_,_,PropID,_),
	propedit_SetMarker_NoMove(Win,PropID),
	!.
  propedit_MoveIfChangeRct(_,_).

  propedit_ChangeTopLeftRight(Rct,RctCtrl):- % If left has changed
	RctCtrl = rct(LC,_TC,_RC,_),
	Rct = rct(L,_T,_R,_),	
	not(L = LC),
	!.
  propedit_ChangeTopLeftRight(Rct,RctCtrl):- % If top has changed
	RctCtrl = rct(_LC,TC,_RC,_),
	Rct = rct(_L,T,_R,_),	
	not(T = TC),
	!.
  propedit_ChangeTopLeftRight(Rct,RctCtrl):- % If right has changed
	RctCtrl = rct(_LC,_TC,RC,_),
	Rct = rct(_L,_T,R,_),	
	not(R = RC),
	!.
/*
  propedit_ChangeLeftRight(Rct,RctCtrl):- % If left has changed
	RctCtrl = rct(LC,_TC,_RC,_),
	Rct = rct(L,_T,_R,_),	
	not(L = LC),
	!.
  propedit_ChangeLeftRight(Rct,RctCtrl):- % If right has changed
	RctCtrl = rct(_LC,_TC,RC,_),
	Rct = rct(_L,_T,R,_),	
	not(R = RC),
	!.
*/
  propedit_RecalcControls(Win):-	% Table Selector and scroll handling
	propedit_move_lb(Win),		% Move Table Selector
	propedit_HandleScroll(Win),	% Create or move or destroy scroll  
	!.

  propedit_move_lb(Win):-
	propedit_db_info(Win,rct(_,_,_ROld,_),TableList,_,SelHeight,_Step,_,_,_,_),
	SelHeight > 0,				% If SelHeight > 0 then
	Fnt = win_GetFont(Win),
	ParentRCT = win_GetClientRect(Win),	% move (destroy and create in new RCT) Table Selector 
	ParentRCT = rct(_,_,R,_),
	R1 = R - propedit_con_field_marg,
	trap(WinLb = win_GetCtlHandle(Win,propedit_idc_lbox),_,fail),
	LbRCT = win_GetClientRect(WinLb),% move Table Selector
        LbRCT = rct(_,_,WLbOLD,_), WLbNew = R1 - propedit_con_field_marg, 
	not(WLbOLD = WLbNew),
	lbox_GetSel(WinLb,_,SelList),
	SelList = [Index],
	propedit_del_lb(Win),
	SelWin = win_CreateControl(wc_LBoxButton,rct(propedit_con_field_marg,5,R1,propedit_con_ListBut_Height),"",Win,
		propedit_TblSel_Flags,propedit_idc_lbox),
 	win_SetState(SelWin,[wsf_Visible]),
	win_SetFont(SelWin,Fnt),
	propedit_GetTitlelist(TableList,TitleList), % Get Title list for Table Selector
	lbox_Add(SelWin,TitleList),
	lbox_SetSel(SelWin,Index,b_true),
ifdef ws_win
	SelRct = win_GetOuterRect(SelWin),
	win_ValidateRect(Win,SelRct), 
enddef
	!.
  propedit_move_lb(_).

/* Scroll Handling*/  
  propedit_HandleScroll(Win):- % Create or move or destroy scroll 
	propedit_db_info(Win,_,_,_,SelHeight,Step,_,_,_,_), % Move or create scroll
	TableId = propedit_GetActiveTbl(Win),
	propedit_db_scroll(Win,TableId,_FP,Max_fields),
	CliRCT = win_GetClientRect(Win),
	CliRct = rct(_,_,R,B),
	SL = R - propedit_con_vscroll_width,
	SR = R,
	ST = SelHeight + propedit_con_ScrollTopBotMarging,
	SB = B - propedit_con_ScrollTopBotMarging,
	B < Max_fields * Step + SelHeight + propedit_con_separator,!,
	propedit_MoveCreateScroll(Win,rct(SL,ST,SR,SB),TableId),
	propedit_Cliar_MargArea(Win).
  propedit_HandleScroll(Win):-
	TableId = propedit_GetActiveTbl(Win), % Destroy or move scroll
	propedit_db_info(Win,_,_,_,SelHeight,_,_,_,_,_),
	propedit_db_scroll(Win,TableId,FirstPos,_),
	CliRCT = win_GetClientRect(Win),
	CliRct = rct(_,_,R,B),
	SL = R - propedit_con_vscroll_width,
	SR = R,
	ST = SelHeight + propedit_con_ScrollTopBotMarging,
	SB = B - propedit_con_ScrollTopBotMarging,
	propedit_DestroyMoveScroll(Win,rct(SL,ST,SR,SB),FirstPos),
	propedit_Cliar_MargArea(Win),
	!.
  
  propedit_MoveCreateScroll(Win,RCTscroll,_TableId):- % Move scroll
	trap(WinScroll = win_GetCtlHandle(Win,propedit_idc_vscroll),_,fail),
	Marg = propedit_con_vscroll_width + propedit_con_field_marg,
  	propedit_CalcLeftRightFields(Win,Marg),
	win_Move(WinScroll,RCTscroll),
	!.
  propedit_MoveCreateScroll(Win,_RCTscroll,TableId):- % Create scroll
	Marg = propedit_con_vscroll_width + propedit_con_field_marg,
	propedit_CalcLeftRightFields(Win,Marg),
	propedit_CreateScrollbar(Win,TableId),
	!.
		
  propedit_DestroyMoveScroll(Win,_RCTscroll,FirstPos):- % Destroy scroll if all fields is visible
	FirstPos = 1,
	trap(WinScroll = win_GetCtlHandle(Win,propedit_idc_vscroll),_,fail),!,
	propedit_CalcLeftRightFields(Win,propedit_con_field_marg),
	propedit_db_info(Win,rct(_,_,R,B),_,_,SelHeight,_,_,_,_,_),!,
	win_Destroy(WinScroll),
	R1 = R - propedit_con_vscroll_width - propedit_con_field_marg - 1,
	win_Invalidate(Win,rct(R1,SelHeight,R,B)).
  propedit_DestroyMoveScroll(Win,RCTscroll,_):- % Move scroll
	trap(WinScroll = win_GetCtlHandle(Win,propedit_idc_vscroll),_,fail),
	Marg = propedit_con_vscroll_width + propedit_con_field_marg,
  	propedit_CalcLeftRightFields(Win,Marg),
	win_Move(WinScroll,RCTscroll),
	!.
  propedit_DestroyMoveScroll(Win,_,_):-
	propedit_CalcLeftRightFields(Win,propedit_con_field_marg),!.

  propedit_Cliar_MargArea(Win):- % Cliar marging area
	propedit_db_info(Win,_,_,_,SelHeight,_,_,Right,_,_),
	CliRct = win_GetClientRect(Win),
	CliRct = rct(_,_,_,B),   
	R = Right + propedit_con_field_marg,
	win_Clear(Win,rct(Right,SelHeight,R,B),color_LtGray),
	!.
  propedit_set_scrolling_field(Win,TableId,NextPos,NextPos):-	% Set new position for fields
	propedit_db_info(Win,_,_,_,SelHeight,Step,_,_,_,_),	% If next position >0 and <=last position
	propedit_db_scroll(Win,TableId,Fp,Max_fields),
	CliRCT = win_GetClientRect(Win),
	CliRct = rct(_,_,_,B),
	NextPos>0,
	B < (Max_fields-NextPos+2)*(Step)+SelHeight+propedit_con_separator,
	retract(propedit_db_scroll(Win,TableId,_,_)),
	assert(propedit_db_scroll(Win,TableId,NextPos,Max_fields)),
	propedit_HandleScroll(Win),
	propedit_CalcScrollRange(Win,TableId,1,NextPos1),
	propedit_SetScrollPosRange(Win,NextPos,NextPos1),
	propedit_ShowFieldsIfChangeScroll(Win,Fp,NextPos),!.
  propedit_set_scrolling_field(Win,TableId,NextPos,1):- % If next position < first position
	propedit_db_info(Win,_,_,_,_,_,_,_,_,_),
	propedit_db_scroll(Win,TableId,Fp,Max_fields),
	NextPos<1,
	propedit_CalcScrollRange(Win,TableId,1,NextPos1),
	retract(propedit_db_scroll(Win,TableId,_,Max_fields)),!,
	assert(propedit_db_scroll(Win,TableId,1,Max_fields)),
	propedit_HandleScroll(Win),
	propedit_SetScrollPosRange(Win,1,NextPos1),
	propedit_ShowFieldsIfChangeScroll(Win,Fp,1),!.	
  propedit_set_scrolling_field(Win,TableId,NextPos,NextPos1):-	% If next position > last position
	propedit_db_info(Win,_,_,_,_,_,_,_,_,_),
	propedit_db_scroll(Win,TableId,Fp,Max_fields),
	NextPos > 0,
	propedit_CalcScrollRange(Win,TableId,1,NextPos1),
	retract(propedit_db_scroll(Win,TableId,_,Max_fields)),!,
	assert(propedit_db_scroll(Win,TableId,NextPos1,Max_fields)),
	propedit_HandleScroll(Win),
 	propedit_SetScrollPosRange(Win,NextPos1,NextPos1),
	propedit_ShowFieldsIfChangeScroll(Win,Fp,NextPos1),!.
  propedit_set_scrolling_field(Win,TableId,_,Fp):-
	propedit_db_scroll(Win,TableId,Fp,_),
	!.

  propedit_ShowFieldsIfChangeScroll(Win,Fp,NextPos):- % Redraw fields if fields position has changed
	not(Fp = NextPos),
	propedit_ShowFields(Win,b_false),
	!.
  propedit_ShowFieldsIfChangeScroll(_,_,_).
  
  propedit_SetScrollPosRange(Win,Pos,Range):- % Set new state for scroll control
	trap(WinScroll=win_GetCtlHandle(Win,propedit_idc_vscroll),_,fail),
	win_SetScrollRange(WinScroll,sb_Ctl,1,Range),
	win_SetScrollPos(WinScroll,sb_Ctl,Pos),
	!.
  propedit_SetScrollPosRange(_,_,_).

  propedit_CalcScrollRange(Win,TableId,FirstPos,OP):- % Scroll range calculation
	propedit_db_info(Win,_,_,_,SelHeight,Step,_,_,_,_),
	propedit_db_scroll(Win,TableId,_,Max_fields),
	CliRCT = win_GetClientRect(Win),
	CliRct = rct(_,_,_,B),
	B < (Max_fields - FirstPos+1) * (Step) + SelHeight + propedit_con_separator,!,
	Next = FirstPos+1,
	propedit_CalcScrollRange(Win,TableId,Next,OP).
  propedit_CalcScrollRange(_,_,F,F):-!.

  propedit_CalcNumberFieldsPage(Win,Nfields):- % visible fields number calculation
	propedit_db_info(Win,_,_,_,SelHeight,Step,_,_,_,_),!,
	CliRCT = win_GetClientRect(Win),
	CliRct = rct(_,_,_,B),
	Nfields = (B - SelHeight - propedit_con_separator) div Step.

  propedit_optim_pos(Win):-% Set new fields position for new window size
	TableId = propedit_GetActiveTbl(Win),
	propedit_db_scroll(Win,TableId,Pos,Max_Fields),
	propedit_db_info(Win,_,_,_,_SelHeight,_Step,_,_,Size_title_fields_Old,_),
	propedit_CalcNumberFieldsPage(Win,Nfields),
	Nfields >= Max_Fields-Pos+1,
	propedit_set_scrolling_field(Win,TableId,Max_Fields,OutPos),
	not(Pos = OutPos), propedit_ShowFieldsMode(Win,Size_title_fields_Old),
	!.
  propedit_optim_pos(_).

% ***** Small utility predicates *****
  propedit_MemberIndex(S,[S|_],1):-!.
  propedit_MemberIndex(S,[_|L],M):-
	bound(M),!,
	N = M - 1,
	propedit_MemberIndex(S,L,N),!.
  propedit_MemberIndex(S,[_|L],M):-
	propedit_MemberIndex(S,L,N),!,
	M = N + 1.

  propedit_member(X,[X|_]):-!.
  propedit_member(X,[_|Rest]):-
	propedit_member(X,Rest).
	  
  propedit_Append([],L,L).	
  propedit_Append([N|L1],L2,[N|L3]):-
	propedit_Append(L1,L2,L3).	

predicates
% DynControl creation 
determ  propedit_CreateDynByKind(WINDOW,PROPERTY_TBLID,INTEGER NField,Property_Control,INTEGER Lf,INTEGER Top,INTEGER Rf,INTEGER Step)
procedure  propedit_AskCallback(WINDOW,Property_Callback,Property_Id)
procedure  propedit_RedrawField(WINDOW,PROPERTY_TBLID,INTEGER Top)
procedure  propedit_SetValToDynListButton(WINDOW,Property_Control)
procedure  propedit_AppendDynFlags(Property_Control,CTL_FLAGS)
procedure  propedit_AppendDynEditFlags(STR_Properties,CTL_FLAGS,CTL_FLAGS)
procedure  propedit_CalcDynFlags(STR_Property,CTL_FLAGS,CTL_FLAGS)
determ  propedit_CalcPosMarker(WINDOW,PROPERTY_TBLID,INTEGER Step,INTEGER Top_y,INTEGER Pos,INTEGER SelH)
procedure  propedit_BildPropList(WINDOW,PROPERTY_TBLID,Property_List)
procedure  propedit_AppendToPropList(WINDOW,PROPERTY_TBLID,Property_List,INTEGER Pos,Property_List)
procedure  propedit_BildTableList(WINDOW,Property_Sheet,Property_Sheet,Property_Sheet)
procedure  propedit_SetDynFocus(WINDOW)

clauses
  
  
  propedit_DynControlCreate(Win,TableId,Pos):-	% Delete previous,
	propedit_del_prev_ctrl(Win),		%  notification and create new active control
	propedit_db_info(Win,_,_,_,_SelHeight,Step,Lf,Rf,_,_),
	propedit_db_field(Win,TableId,Pos,Prop,Top),
	propedit_db_scroll(Win,TableId,SrlPos,_Max_fields),
	Top1 = Top - (SrlPos - 1) * Step,
	Prop=property(PropID,_,PropCtrl,_,OkPush),
	not(propedit_db_dyncontrol(Win,_,_,_,_)),
	propedit_HandlePushButton(Win,OkPush,Step,Top1,Rf,Rf1),
	propedit_CreateDynByKind(Win,TableId,Pos,PropCtrl,Lf,Top1,Rf1,Step),
	assert(propedit_db_dyncontrol(Win,TableId,Pos,PropID,b_false)),!.
  propedit_DynControlCreate(_,_,_).

  propedit_HandlePushButton(Win,b_true,Step,Top,Rf,Rf1):- % Move PushButton (Rf1 - new right field for DynControl) 
	trap(WinPB = win_GetCtlHandle(Win,propedit_idc_DynPB),_,fail),
	propedit_db_info(Win,_,_,_,_,_,Lf,_,_,_),
	Rf1 = Rf - propedit_con_Push_width, Top1 = Top,
	Y1 = Top1 + Step - propedit_con_separator -1,
	RPB = Rf,
	LPB = Rf1,
	LPB >= Lf,
	propedit_VisInvisDyn(Win,WinPB,rct(LPB,Top1,RPB,Y1)),
	win_Move(WinPB,rct(LPB,Top1,RPB,Y1)),!.
  propedit_HandlePushButton(Win,b_true,Step,Top,Rf,Rf1):- % Create PushButton
	propedit_db_info(Win,_,_,_,_,_,Lf,_,_,_),
	RPB = Rf,
	Rf1 = Rf - propedit_con_Push_width, Top1 = Top,
	LPB = Rf1,
	Y1 = Top1 + Step - propedit_con_separator -1,
	LPB >= Lf,
        WinPB = win_CreateControl(wc_PushButton,rct(LPB,Top1,RPB,Y1), "...",Win,
	 [wsf_NoClipSiblings,wsf_Invisible],propedit_idc_DynPB),
	propedit_VisInvisDyn(Win,WinPB,rct(LPB,Top1,RPB,Y1)),!.
  propedit_HandlePushButton(_,b_false,_,_,Rf,Rf):-!.

  propedit_VisInvisDyn(Win,WinCtrl,RctCtrl):-% Active control is visible
	propedit_db_info(Win,_,_,_,SelHeight,_,_,_,_,_),
	RctCtrl = rct(_,Yc,_,_),
	Yc >= SelHeight,
	win_SetState(WinCtrl,[wsf_Visible]),
	!.
  propedit_VisInvisDyn(_,WinCtrl,_):-% Active control is invisible
	win_SetState(WinCtrl,[wsf_Invisible]),% If DynControl top < SelHeight(Table Selector height)
	!.

  propedit_del_prev_ctrl(Win):- % Rmove DynControl and send notification
	propedit_db_dyncontrol(Win,_,_,Property_Id,_),
	trap(WinCtrlPred = win_GetCtlHandle(Win,propedit_idc_DynCtrl),_,fail),
	propedit_ExtractFromControl(Win,WinCtrlPred), % If value  has changed
	propedit_db_info(Win,_,_,Callback,_,_,_,_,_,_),
	propedit_AskCallback(Win,Callback,Property_Id),
	trap(WinCtrlPred = win_GetCtlHandle(Win,propedit_idc_DynCtrl),_,fail),
	retract(propedit_db_dyncontrol(Win,_,_,Property_Id,_)),
	trap(win_Destroy(WinCtrlPred),_,fail),
	trap(WinPB = win_GetCtlHandle(Win,propedit_idc_DynPB),_,fail),
	trap(win_Destroy(WinPB),_,fail),!.
  propedit_del_prev_ctrl(Win):-
	propedit_db_dyncontrol(Win,_,_,_,_),
	trap(WinCtrlPred = win_GetCtlHandle(Win,propedit_idc_DynCtrl),_,fail),
	not(propedit_ExtractFromControl(Win,WinCtrlPred)),
	retract(propedit_db_dyncontrol(Win,_,_,_,_)),
	trap(win_Destroy(WinCtrlPred),_,fail),
	trap(WinPB = win_GetCtlHandle(Win,propedit_idc_DynPB),_,fail),
	trap(win_Destroy(WinPB),_,fail),!.
  propedit_del_prev_ctrl(_).

  propedit_get_id_activ_ctrl(Win,IdCtrl):-
	propedit_db_dyncontrol(Win,_,_,IdCtrl,_),!.
  propedit_get_id_activ_ctrl(_,0).

  propedit_AskCallback(Win,Callback,Property_Id):- % send modified callback notification
	not(Callback(Win,modified(Property_Id))),!.
  propedit_AskCallback(_,_,_).

  propedit_ExtractFromControl(Win,WinCtrlPred):- % Extract from DynControl and assetr new value
	propedit_db_dyncontrol(Win,TableId,Pos,PropID,_),
	propedit_db_field(Win,TableId,Pos,Prop,Top_y),
	Prop = property(PropID,Title,PropCtrl,Err_P,OkPushbutton),
	PropCtrl = listButton(_,_),!,
	Selected = lbox_GetSelIndex(WinCtrlPred), % Extract for listButton
	propedit_Str_To_PropControl(Win,PropCtrl,"",Selected,PropCtrl2,Err_p), % fail if old value = new value
	Prop2 = property(PropID,Title,PropCtrl2,Err_P,OkPushbutton),
	retract(propedit_db_field(Win,TableId,Pos,Prop,Top_y)),!,
	assert(propedit_db_field(Win,TableId,Pos,Prop2,Top_y)).

  propedit_ExtractFromControl(Win,WinCtrlPred):-
	propedit_db_dyncontrol(Win,TableId,Pos,PropID,_),
	propedit_db_field(Win,TableId,Pos,Prop,Top_y),
	Prop = property(PropID,Title,PropCtrl,Err_P,OkPushbutton),
	OutString = win_GetText(WinCtrlPred), % Extract for other
	propedit_db_ControlMod(Win),!,
	propedit_Str_To_PropControl(Win,PropCtrl,OutString,0,PropCtrl2,Err_p),
	Prop2 = property(PropID,Title,PropCtrl2,Err_P,OkPushbutton),
	retract(propedit_db_field(Win,TableId,Pos,Prop,Top_y)),!,
	assert(propedit_db_field(Win,TableId,Pos,Prop2,Top_y)).

  propedit_CreateDynByKind(Win,_TableId,_Pos,listButton(Slist,InitValue),Lf,Top,Rf,_Step):-
	Fnt = win_GetFont(Win),	% Create listButton DynControl
	Bottom = Top + propedit_con_ListBut_Height, Rf1 = Rf,
	Rct = rct(Lf,Top,Rf1,Bottom),!,	
	WinLB = win_CreateControl(wc_LBoxButton,Rct,"",Win,
	 propedit_lb_Flags,propedit_idc_DynCtrl),	
	propedit_VisInvisDyn(Win,WinLB,Rct),
	win_SetFont(WinLB,Fnt),
	retractAll(propedit_db_NoAskPrompt(Win)),
	assert(propedit_db_NoAskPrompt(Win)),
	retractAll(propedit_db_ControlMod(Win)),
	lbox_Add(WinLB,SList),
	lbox_SetSel(WinLB,InitValue,b_true),
	propedit_SetDynFocus(WinLB),
	win_SetSubClassHandler(WinLB,propedit_subDyn_EH,b_false).
  propedit_CreateDynByKind(Win,_TableId,_Pos,listEdit(Slist,InitString,_),Lf,Top,Rf,_Step):-
	Fnt = win_GetFont(Win),	% Create listEdit DynControl
	Bottom = Top + propedit_con_ListBut_Height, Rf1 = Rf,
	Rct = rct(Lf,Top,Rf1,Bottom),!,	
	WinLBE = win_CreateControl(wc_LBoxEdit,Rct,InitString,Win,
	 propedit_le_Flags,propedit_idc_DynCtrl),	
	propedit_VisInvisDyn(Win,WinLBE,Rct),
	win_SetFont(WinLBE,Fnt),
	retractAll(propedit_db_NoAskPrompt(Win)),
	assert(propedit_db_NoAskPrompt(Win)),
	retractAll(propedit_db_ControlMod(Win)),
	lbox_Add(WinLBE,SList),
ifdef ws_win
	win_SetText(WinLBE,InitString),
enddef
	propedit_SetDynFocus(WinLBE),
	win_SelectText(WinLBE,0,0),
	trap(win_SetSubClassHandler(WinLBE,propedit_subDyn_EH,b_false),_,fail),!.

  propedit_CreateDynByKind(Win,_TableId,_Pos,PropCtrl,Lf,Top,Rf,Step):-
	Bottom = Top + Step - propedit_con_separator - 1, Rf1 = Rf, % Create other DynControl
	Rct = rct(Lf,Top,Rf1,Bottom),	
	propedit_AppendDynFlags(PropCtrl,SlFlags), 
	propedit_PropCtrlToStr(PropCtrl,Str),
	WinE = win_CreateControl(wc_Edit,Rct,STR,Win,SlFlags,propedit_idc_DynCtrl),	
	propedit_VisInvisDyn(Win,WinE,Rct),
	Fnt = win_GetFont(Win),	
	win_SetFont(WinE,Fnt),
	retractAll(propedit_db_NoAskPrompt(Win)),
	assert(propedit_db_NoAskPrompt(Win)),
	retractAll(propedit_db_ControlMod(Win)),
	propedit_SetDynFocus(WinE),
	win_SelectText(WinE,0,0),
	win_SetSubClassHandler(WinE,propedit_subDyn_EH,b_false),!.	
  propedit_CreateDynByKind(_,_,_,_,_,_,_,_).
  
  propedit_SetDynFocus(Win):-
	trap(win_SetFocus(Win),_,fail),
	!.
  propedit_SetDynFocus(_).

% Append flags handling
  propedit_AppendDynFlags(editStr(_,STR_Prop),OutFlags):- % Append flags for editStr DynControl
	propedit_AppendDynEditFlags(STR_Prop,propedit_edit_Flags,OutFlags),!.% wsf_ReadOnly,wsf_UpperCase,wsf_LowerCase
  propedit_AppendDynFlags(editInt(_,List),[wsf_ReadOnly | propedit_edit_Flags]):- 
	propedit_member(ronly,List),!. % Append flag wsf_ReadOnly for other DynControls
  propedit_AppendDynFlags(editLong(_,List),[wsf_ReadOnly | propedit_edit_Flags]):-
	propedit_member(ronly,List),!.
  propedit_AppendDynFlags(editReal(_,List),[wsf_ReadOnly | propedit_edit_Flags]):-
	propedit_member(ronly,List),!.
  propedit_AppendDynFlags(_,propedit_edit_Flags).

  propedit_AppendDynEditFlags([],OutF,OutF):-!.
  propedit_AppendDynEditFlags([L1|L2],Inflags,OutFlags):-!,
	propedit_CalcDynFlags(L1,Inflags,OF),
	propedit_AppendDynEditFlags(L2,OF,OutFlags).
  propedit_AppendDynEditFlags(_,OutF,OutF):-!.

  propedit_CalcDynFlags(ronly,Inflags,[wsf_ReadOnly|Inflags]):-!.
  propedit_CalcDynFlags(upper,Inflags,[wsf_UpperCase|Inflags]):-!.
  propedit_CalcDynFlags(lower,Inflags,[wsf_LowerCase|Inflags]):-!.
  propedit_CalcDynFlags(_,Flags,Flags).
  
  propedit_CalcPosMarker(Win,TblId,Step,Top_y,Pos,SelHeight):-	% Calculation and set fields position 
	propedit_db_scroll(Win,TblId,FVis,_Max),		% for propedit_SetMarker 
	RCT = win_GetClientRect(Win),				% global predicate
	RCT = rct(_,Yt,_,_Yb),
	Top_y - (FVis - 1) * Step < Yt + SelHeight,!,
	propedit_set_scrolling_field(Win,TblId,Pos,_).
  propedit_CalcPosMarker(Win,TblId,Step,Top_y,Pos,_):-
	propedit_db_scroll(Win,TblId,FVis,_Max),
	RCT = win_GetClientRect(Win),
	RCT = rct(_,_Yt,_,Yb),
	Top_y + Step - propedit_con_separator - (FVis - 1) * Step > Yb,!,
	propedit_CalcNumberFieldsPage(Win,Nfields),
	Pos1=Pos - Nfields + 1,
	propedit_set_scrolling_field(Win,TblId,Pos1,_).
  propedit_CalcPosMarker(_,_,_,_,_,_).

  propedit_RedrawField(Win,TableId,Top):- % Redraw field for propedit_Set... global predicates
	TableId = propedit_GetActiveTbl(Win),
	propedit_db_scroll(Win,TableId,SrlPos,_),
	propedit_db_info(Win,_,_,_,_SelHeight,Step,Lf,Rf,_,_),
	Top1 = Top - (SrlPos - 1) * Step, Bot = Top1 + Step + propedit_con_separator,
	Rct = rct(Lf,Top1,Rf,Bot),
	win_Invalidate(Win,Rct),!.
  propedit_RedrawField(_,_,_).

  propedit_SetValToDyn(Win,Prop_Control):- % Set new value for propedit_Set... global predicates
	trap(WinCtl=win_GetCtlHandle(Win,propedit_idc_DynCtrl),_,fail),
	propedit_PropCtrlToStr(Prop_Control,STR),
	win_SetText(WinCtl,STR),!.
  propedit_SetValToDyn(_,_).

  propedit_SetValToDynListButton(Win,Prop_Control):- % Set new value for propedit_Set... global predicates
	trap(WinLB=win_GetCtlHandle(Win,propedit_idc_DynCtrl),_,fail),% if 
	Prop_Control = listButton(_,Index),
	lbox_SetSel(WinLB,Index,b_true),!.
  propedit_SetValToDynListButton(_,_).

% clauses for propedit_GetSheet global predicate
  propedit_BildTableList(_,[],Out_Sheet,Out_Sheet):-!.
  propedit_BildTableList(Win,[pTbl(TblId,Prop_Title,_)|L],Ps,Out_S):-
	propedit_BildPropList(Win,TblId,Prop_list),
	propedit_Append(Ps,[pTbl(TblId,Prop_Title,Prop_list)],Prop_Sheet),!,
	propedit_BildTableList(Win,L,Prop_Sheet,Out_S).
  propedit_BildTableList(_,_,Out_Sheet,Out_Sheet):-!.
	
  propedit_BildPropList(Win,TblId,Prop_list):-
	propedit_AppendToPropList(Win,TblId,[],1,Prop_list),!.

  propedit_AppendToPropList(Win,TblId,In_Pl,Pos,Prop_list):-
	propedit_db_field(Win,TblId,Pos,Prop,_),
	propedit_Append(In_pl,[Prop],Prop_append),!,
	PosNext = Pos + 1,
	propedit_AppendToPropList(Win,TblId,Prop_append,PosNext,Prop_list).
  propedit_AppendToPropList(_,_,Out_Plist,_,Out_Plist):-!.

  propedit_SetMarker_NoMove(Win,PropID):-			  % Set marker,
	propedit_db_info(Win,_,_,_,_SelHeight,_Step,_LF,_RF,_,_), % fields position same
	propedit_db_field(Win,TblId,Pos,property(PropID,_,_,_,_),_Top_y),
	TblIdOld = propedit_GetActiveTbl(Win),
	propedit_SetActiveTbl(Win,TblId),
	propedit_DynControlCreate(Win,TblId,Pos),
	not(TblIdOld = TblId),!,
	win_Invalidate(Win).
  propedit_SetMarker_NoMove(_,_).

  propedit_SetNewEditorFont(Win):-
	propedit_db_info(Win,_,_,Callback,_,_,_,_,Label_area_width,_),
	TblId = propedit_GetActiveTbl(Win), % Get ID active table
	PropertySheet = propedit_GetSheet(Win),
	propedit_get_id_activ_ctrl(Win,PropID), % Get ID active control
	propedit_del_ctrl_NoNotification(Win),
	propedit_DelScroll(Win), % Delete scroll control
	propedit_del_LB(Win), % Delete Table Selector
	propedit_RenameFieldsToOld(Win), 
	retractAll(propedit_db_info(Win,_,_,_,_,_,_,_,_,_)),
	propedit_init_db(Win,PropertySheet,Callback,Label_area_width),
	propedit_create_controls(Win), % Create Scroll and Table Selector
	propedit_SetActiveTbl(Win,TblId), 
	propedit_reload_scrolling_table(Win), 
	propedit_SetMarker(Win,PropID),
	win_Invalidate(Win),
	!.
  propedit_SetNewEditorFont(_).
