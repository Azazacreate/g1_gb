/******************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S 

			 VISUAL Prolog

 FileName: OWNDRAW.PRO
 PURPOSE: Owner Draw Handling
 Written by Yuri Ilyin
 Comments:

******************************************************************************/
ifndef error_con_included
 #Error: this file requires inclusion of file: error.con
enddef 
ifndef owndraw_pre_included
 #Error: this file requires include: owndraw.pre
enddef 
constants
 od_GroupButton = 10
 od_RadioButton = 11
 
database - ownerdraw_internal_db
% ownerdraw_radio(ParentWINDOW,ControlID,CtrlWindow,Group,IsChoosed)
  ownerdraw_radio(WINDOW,       UNSIGNED, WINDOW,    SHORT,BOOLEAN)
% ownerdraw_group_radio(NumberGroup) for set one point in group
  ownerdraw_group_radio(SHORT)
  determ check_flag_button
  determ number_ownerdraw_groups(SHORT)
% ownerdraw_rectangle(ParentWin,ControlID,OwnRCT,od Constants)
  ownerdraw_rectangle(WINDOW,   UNSIGNED, RCT,   UNSIGNED)
% ownerdraw_checked(ControlWINDOW)
  ownerdraw_checked(WINDOW)
 
/********************************************************************************
	INTERNAL predicates
********************************************************************************/
predicates
  procedure owd_err_hnd(STRING, INTEGER)
  nondeterm own_member(OD_ITEMSTATE,OD_STATE)
  nondeterm own_member(OD_ITEMACTION,OD_ACTION)
  nondeterm own_member(ILIST,INTEGER)
  determ reverse_ownerdraw_checked(WINDOW)
  determ give_ownerdraw_checked(WINDOW,BOOLEAN)

%+++++ RETURN true for first radio control in window +++++
  procedure set_ownerdraw_init_radio(SHORT,BOOLEAN)
  procedure set_point_in_group(WINDOW,SHORT)
  procedure set_point_in_win(WINDOW)

  procedure equivalence(WINDOW,WINDOW,BOOLEAN)
  procedure set_ownerdraw_init_group(WINDOW,SHORT,RCT)
  procedure inc_number_ownerdraw_groups(SHORT)
  
clauses
  inc_number_ownerdraw_groups(X1):-
	number_ownerdraw_groups(X),!,
	retractall(number_ownerdraw_groups(X)),
	X1 = X+1,
	assert(number_ownerdraw_groups(X1)).
  inc_number_ownerdraw_groups(1).
  
  equivalence(X,X,b_true):-!.
  equivalence(_,_,b_false).
  
%+++++ grouping controls +++++
  set_ownerdraw_init_group(ParentWin,G,Rect):-
  	ownerdraw_rectangle(ParentWin,ID,RecRadio,od_RadioButton),
 	ownerdraw_radio(ParentWin,ID,CtrlWin,0,_),
  	retractall(ownerdraw_group_radio(0)),
  	RR = rect_Intersect(Rect,RecRadio), RR=rct(LZ,TZ,RZ,BZ),
  	LZ>0, TZ>0, RZ>0, BZ>0,
  	 retractall(ownerdraw_radio(ParentWin,ID,CtrlWin,0,_)),
    	 assert(ownerdraw_radio(ParentWin,ID,CtrlWin,G,b_False)),
  	fail.
%+++++ set only one point in each group +++++
  set_ownerdraw_init_group(ParentWin,G,_):-
  	set_point_in_group(ParentWin,G),
  	set_point_in_win(ParentWin).


  set_point_in_group(ParentWin,G):-
 	ownerdraw_radio(ParentWin,ID,CtrlWin,G,_),!,
  	retractall(ownerdraw_radio(ParentWin,ID,_,_,_)),
    	assert(ownerdraw_radio(ParentWin,ID,CtrlWin,G,b_true)).
  set_point_in_group(_,_).

  set_point_in_win(ParentWin):-
 	ownerdraw_radio(ParentWin,ID,CtrlWin,0,_),!,
    	retractall(ownerdraw_radio(ParentWin,ID,_,_,_)),
  	assert(ownerdraw_radio(ParentWin,ID,CtrlWin,0,b_true)).
  set_point_in_win(_).

  set_ownerdraw_init_radio(C,b_false):-
	ownerdraw_group_radio(C),!.
  set_ownerdraw_init_radio(C,b_true):-
	assert(ownerdraw_group_radio(C)).

  give_ownerdraw_checked(CBOXWIN,b_true):-
  	ownerdraw_checked(CBOXWIN),!.
  give_ownerdraw_checked(CBOXWIN,b_false):-
  	not(ownerdraw_checked(CBOXWIN)).

  reverse_ownerdraw_checked(CBOXWIN):-
  	not(ownerdraw_checked(CBOXWIN)),
  	assert(ownerdraw_checked(CBOXWIN)),!.
  reverse_ownerdraw_checked(CBOXWIN):-
	ownerdraw_checked(CBOXWIN),
  	retractall(ownerdraw_checked(CBOXWIN)),!.

  owd_err_hnd(S, _) :-
    lasterror(ErrorNo, FileName, IncludeFileName, Position),
    format(Mes, "%s Error nr:% - Pos:% in % - Incl:%", 
           S, ErrorNo, Position, FileName, IncludeFileName),
    dlg_Error(Mes).

  own_member([X|_],X).
  own_member([_|T],X):-own_member(T,X).

/********************************************************************************
	translate structure ownerdraw menu to VPI menu
********************************************************************************/
predicates
procedure  translate_ODM_to_M(INTEGER,OWNERDRAW_MENU,MENU_ITEM_LIST)

clauses
  translate_ODM_to_M(_,[],[]):-!.
  translate_ODM_to_M(Y,[OH|OT],[MH|MT]):-
	OH = ownerdraw_item_def(MENU_TAG,WID,HEI,OSM),
	Y1 = Y + HEI,
	UNKNOWN = cast(window,0),
	retractall(ownerdraw_rectangle(UNKNOWN,MENU_TAG,_,_)),
	assert(ownerdraw_rectangle(UNKNOWN,MENU_TAG,rct(0,Y,WID,Y1),od_Menu)),
	translate_ODM_to_M(0,OSM,MSM),
	MH = ownerdraw(MENU_TAG,0,b_true,b_false,MSM),!,
	translate_ODM_to_M(Y1,OT,MT).
  translate_ODM_to_M(_,_,[]). %Error

/********************************************************************************
	DRAW predicates
********************************************************************************/
predicates
  determ draw_radiobutton_radio(WINDOW,RCT,RCT,UNSIGNED,OWNERDRAW_RADIO_FUNC,BOOLEAN)

clauses
  draw_radiobutton_radio(W,RECT,CRCT,CtrlID,USER_FUNC,Check):-
  	win_SetBrush(W,brush(pat_Solid,color_LtGray)),
  	win_SetPen(W,pen(1,ps_Solid,color_LtGray)),
  	draw_Rect(W,RECT), CR = rect_Inflate(CRCT,1,1),
  	win_SetBrush(W,brush(pat_Solid,color_White)),
  	win_SetPen(W,pen(1,ps_Solid,color_White)),
  	draw_Ellipse(W,CR), CR = rct(L,T,R,B),
	trap(USER_FUNC(CtrlID,W,RECT,CRCT,Check),E,
		owd_err_hnd("catch exit from draw_func", E)),
	CR1 = rect_Inflate(CR,1,1),
	Y1=((T+B) div 2)+2, X1=((R+L) div 2)+2,
	L1=L,T1=T,R1=R+5,B1=B+5, CR2=rct(L1,T1,R1,B1),
  	win_SetPen(W,pen(1,ps_Solid,color_Black)),
	draw_Arc(W,CR2,X1,T,L,Y1),
	Y2=(T+B) div 4, X2=(R+L) div 4,
  	win_SetPen(W,pen(1,ps_Solid,color_White)),
	draw_Arc(W,CR1,X2,B,R,Y2),
  	win_SetPen(W,pen(1,ps_Solid,color_LtGray)),
  	win_SetBrush(W,brush(pat_Hollow,color_LtGray)),
	draw_Ellipse(W,CR),
  	win_SetPen(W,pen(1,ps_Solid,color_Black)),
  	draw_Rect(W,RECT).

predicates
  determ draw_menu_items(WINDOW,MENU_TAG,OWNERDRAW_MENU_FUNC,BOOLEAN)
  procedure draw_all_menu_items(WINDOW,OWNERDRAW_MENU_FUNC)

clauses
  draw_all_menu_items(W,USER_FUNC):-
	NULL = cast(window,0),
 	ownerdraw_rectangle(NULL,TAG,Rect,od_Menu),
	 win_SetBrush(W,brush(pat_Solid,color_white)),
	 win_SetPen(W,pen(5,ps_solid,color_White)),
 	 draw_Rect(W,Rect),
	 trap(USER_FUNC(W,TAG,RECT,b_false),E,
		owd_err_hnd("catch exit from draw_func", E)),
 	fail.
  draw_all_menu_items(_,_).

  draw_menu_items(W,MENU_TAG,USER_FUNC,b_false):-
	NULL = cast(window,0),
 	ownerdraw_rectangle(NULL,MENU_TAG,Rect,od_Menu),!,
	win_SetBrush(W,brush(pat_Hollow,color_white)),
	win_SetPen(W,pen(5,ps_solid,color_White)),
 	draw_Rect(W,Rect),
	trap(USER_FUNC(W,MENU_TAG,RECT,b_false),E,
		owd_err_hnd("catch exit from draw_func", E)).
  draw_menu_items(W,MENU_TAG,USER_FUNC,b_true):-
	NULL = cast(window,0),
 	ownerdraw_rectangle(NULL,MENU_TAG,Rect,od_Menu),!,
	trap(USER_FUNC(W,MENU_TAG,RECT,b_true),E,
		owd_err_hnd("catch exit from draw_func", E)),
	win_SetBrush(W,brush(pat_Hollow,color_white)),
	win_SetPen(W,pen(5,ps_solid,color_Black)),
 	draw_Rect(W,Rect).

predicates
  determ draw_list_box_selected(WINDOW,STRING,INTEGER,RCT,OWNERDRAW_LBOX_FUNC,BOOLEAN,BOOLEAN)

clauses
  draw_list_box_selected(W,_,_,RECT,_,b_true,b_true):-
	RECT=rct(LEFT,TOP,RIGHT,BOTTOM),
	LEFT1=LEFT+1,RIGHT1=RIGHT-1,TOP1=TOP+1,BOTTOM1=BOTTOM-1,
	win_SetBrush(W,brush(pat_Solid,color_LtGray)),
	win_SetPen(W,pen(1,ps_Solid,color_LtGray)),
	draw_Rect(W,rct(LEFT,TOP,RIGHT,BOTTOM)),
	win_SetPen(W,pen(1,ps_Solid,color_Black)),
	draw_Polyline(W,[pnt(LEFT1,BOTTOM1),pnt(LEFT1,TOP1),pnt(RIGHT1,TOP1)]),
	fail.
  draw_list_box_selected(W,SITEM,INDEX,RECT,USER_FUNC,b_true,_):-
	trap(USER_FUNC(W,RECT,3,SITEM,INDEX),E,owd_err_hnd("catch exit from draw_func", E)),!.
  draw_list_box_selected(W,_,_,RECT,_,b_false,b_true):-
	RECT=rct(LEFT,TOP,RIGHT,BOTTOM),
	LEFT1=LEFT+1,RIGHT1=RIGHT-1,TOP1=TOP+1,BOTTOM1=BOTTOM-1,
	win_SetBrush(W,brush(pat_Solid,color_LtGray)),
	win_SetPen(W,pen(1,ps_Solid,color_LtGray)),
	draw_Rect(W,rct(LEFT,TOP,RIGHT,BOTTOM)),
	win_SetPen(W,pen(1,ps_Solid,color_White)),
	draw_Polyline(W,[pnt(LEFT1,BOTTOM1),pnt(LEFT1,TOP1),pnt(RIGHT1,TOP1)]),
	win_SetPen(W,pen(1,ps_Solid,color_Gray)),
	draw_Polyline(W,[pnt(LEFT1,BOTTOM1),pnt(RIGHT1,BOTTOM1),pnt(RIGHT1,TOP1)]),
	fail.
  draw_list_box_selected(W,SITEM,INDEX,RECT,USER_FUNC,_,_):-
	trap(USER_FUNC(W,RECT,0,SITEM,INDEX),E,owd_err_hnd("catch exit from draw_func", E)).

predicates
  determ draw_up_push_button(WINDOW,RCT,OWNERDRAW_BUT_FUNC)
  determ draw_down_push_button(WINDOW,RCT,OWNERDRAW_BUT_FUNC)

clauses
  draw_up_push_button(W,RECT,USER_FUNC):-
	win_SetPen(W,pen(1,ps_solid,color_Black)),
	win_SetBrush(W,brush(pat_Solid,color_LtGray)),
	Rect = rct(_,_,Wid,Hei),
	draw_Rect(W,rct(0,0,Wid,Hei)),
	trap(USER_FUNC(W,0,0,RECT),E,owd_err_hnd("catch exit from draw_func", E)),
	win_SetPen(W,pen(4,ps_solid,color_White)),
	RT = Wid - 3, LB = Hei - 3,
	draw_PolyLine(W,[pnt(RT,3),pnt(3,3),pnt(3,LB)]),
	win_SetPen(W,pen(4,ps_solid,color_Gray)),
	draw_PolyLine(W,[pnt(7,LB),pnt(RT,LB),pnt(RT,7)]),
	RT1 = WID - 1, LB1 = HEI - 1,
	draw_Line(W,pnt(5,LB1),pnt(10,LB1)),
	draw_Line(W,pnt(RT1,5),pnt(RT1,10)),	
	win_SetPen(W,pen(1,ps_solid,color_Black)),
	RT2 = WID - 6, LB2 = HEI - 6,
	draw_Line(W,pnt(0,Hei),pnt(6,LB2)),
	draw_Line(W,pnt(Wid,0),pnt(RT2,6)),
	draw_Line(W,pnt(Wid,Hei),pnt(RT2,LB2)),
	win_SetBrush(W,brush(pat_Hollow,color_LtGray)),
	draw_Rect(W,rct(0,0,WID,HEI)).

  draw_down_push_button(W,RECT,USER_FUNC):-
	win_SetPen(W,pen(1,ps_solid,color_Black)),
	win_SetBrush(W,brush(pat_Solid,color_LtGray)),
	Rect = rct(_,_,Wid,Hei),
	draw_Rect(W,rct(0,0,Wid,Hei)),
	trap(USER_FUNC(W,6,6,RECT),E,owd_err_hnd("catch exit from draw_func", E)),
	win_SetPen(W,pen(4,ps_solid,color_Black)),
	RT = Wid - 3, LB = Hei - 3,
	draw_PolyLine(W,[pnt(RT,3),pnt(3,3),pnt(3,LB)]),
	win_SetPen(W,pen(2,ps_solid,color_Black)),
	RT1 = WID - 1, LB1 = HEI - 1,
	draw_Line(W,pnt(0,LB1),pnt(RT1,LB1)).
  
predicates
  determ draw_checkbox_checked(WINDOW,RCT,RCT,OWNERDRAW_CHECK_FUNC,BOOLEAN)

clauses
  draw_checkbox_checked(W,RECT,CRCT,USER_FUNC,Check):-
  	win_SetBrush(W,brush(pat_Solid,color_LtGray)),
  	win_SetPen(W,pen(1,ps_Solid,color_LtGray)),
  	draw_Rect(W,RECT),
  	win_SetBrush(W,brush(pat_Solid,color_White)),
  	win_SetPen(W,pen(1,ps_Solid,color_White)),
  	draw_Rect(W,CRCT), CRCT = rct(L,T,R,B),
	trap(USER_FUNC(W,RECT,CRCT,Check),E,owd_err_hnd("catch exit from draw_func", E)),
  	win_SetPen(W,pen(1,ps_Solid,color_Gray)),
  	X1 = L-2, Y1 = T-2, X2 = R+2, Y2 = B+1, Y3 = B+2, Y4 = T-1, X3 = L-1,
  	Y5 = B-1, X4 = R+1,
  	draw_PolyLine(W,[pnt(X1,Y2),pnt(X1,Y1),pnt(X2,Y1)]),
  	win_SetPen(W,pen(1,ps_Solid,color_White)),
  	draw_PolyLine(W,[pnt(X1,Y3),pnt(X2,Y3),pnt(X2,Y4)]),
  	win_SetPen(W,pen(1,ps_Solid,color_Black)),
  	draw_PolyLine(W,[pnt(X3,Y5),pnt(X3,Y4),pnt(X4,Y4)]),
  	win_SetPen(W,pen(1,ps_Solid,color_LtGray)),
  	draw_PolyLine(W,[pnt(X3,Y2),pnt(X4,Y2),pnt(X4,T)]),
  	win_SetBrush(W,brush(pat_Hollow,color_LtGray)),
  	win_SetPen(W,pen(1,ps_Solid,color_Black)),
  	draw_Rect(W,RECT).

/****************************************************************************
	clauses FOR global predicates
****************************************************************************/

  /* dummy predicates */
  ownerdraw_no_button(_,_,_,_).
  ownerdraw_no_check(_,_,_,_).
  ownerdraw_no_lbox(_,_,_,_,_).
  ownerdraw_no_menu(_,_,_,_).
  ownerdraw_no_radio(_,_,_,_,_).
  
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  ownerdraw_MeasureControl(CtlId,SIZE):- 
	NULL = cast(window,0),
	ownerdraw_rectangle(NULL,CtlId,Rct,od_Menu),!,
	RCT = rct(L,T,R,B),
	W = R-L - 12, H = B-T,
	WL = cast(long,W), HL = cast(long,H),
	SIZE = WL + (0x10000 * HL).
  ownerdraw_MeasureControl(CtlId,SIZE):-
	ownerdraw_rectangle(_,CtlId,Rct,_),!,
	RCT = rct(L,T,R,B),
	W = R-L, H = B-T,
	WL = cast(long,W), HL = cast(long,H),
	SIZE = WL + (0x10000 * HL).
	
  ownerdraw_MeasureControl(CtlId,0):- 
  	format(S,"Error measuring Control ID=%",CtlId),
  	dlg_Error(S).

%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  ownerdraw_CreateControl(CtlType,CtlId,OwnRCT,Title,ParentWin):-!,
	ownerdraw_CreateControl(CtlType,CtlId,OwnRCT,u_Pixels,Title,ParentWin).

  ownerdraw_CreateControl(wc_PushButton,CtlId,OwnRCT,BaseUnits,Title,ParentWin):-
        assert(ownerdraw_rectangle(ParentWin,CtlId,OwnRCT,od_Button)),
	win_CreateDynControl([ctl(wdef(wc_PushButton,OwnRCT,Title,BaseUnits),
        	CtlId,[wsf_OwnerDraw,wsf_TabStop,wsf_Group])],ParentWin),!.

  ownerdraw_CreateControl(wc_CheckBox,CtlId,OwnRCT,BaseUnits,Title,ParentWin):-
        assert(ownerdraw_rectangle(ParentWin,CtlId,OwnRCT,od_Button)),
	win_CreateDynControl([ctl(wdef(wc_CheckBox,OwnRCT,Title,BaseUnits),
        	CtlId,[wsf_OwnerDraw,wsf_TabStop,wsf_Group])],ParentWin),!.

  ownerdraw_CreateControl(wc_RadioButton,CtlId,OwnRCT,BaseUnits,Title,ParentWin):-
        assert(ownerdraw_rectangle(ParentWin,CtlId,OwnRCT,od_RadioButton)),
	CTRWIN = win_CreateDynControl([ctl(wdef(wc_RadioButton,OwnRCT,Title,BaseUnits),
        	CtlId,[wsf_OwnerDraw,wsf_TabStop])],ParentWin),
 	retractall(ownerdraw_radio(ParentWIN,CtlId,_,_,_)),
	set_ownerdraw_init_radio(0,B),
	assert(ownerdraw_radio(ParentWIN,CtlId,CTRWIN,0,B)),!.

  ownerdraw_CreateControl(_,_,_,_,_,_):-
  	errorexit( error_vpi_package_bad_window_type ).

  ownerdraw_CreateGroupBox(OwnRCT,ParentWin):-
	inc_number_ownerdraw_groups(C),
        set_ownerdraw_init_group(ParentWin,C,OwnRCT),!.

  ownerdraw_CreateListBox(CtlId,OwnRct,Title,W,LIST,StartIndex,NumVis):-!,
	ownerdraw_CreateListBox(CtlId,OwnRct,u_Pixels,Title,W,LIST,StartIndex,NumVis).

  ownerdraw_CreateListBox(CtlId,OwnRct,BaseUnits,Title,W,LIST,StartIndex,NumVis):-
	OwnRct = rct(L,T,R,B),
	H = ((B-T) div NumVis),
        assert(ownerdraw_rectangle(W,CtlId,rct(L,0,R,H),od_LBox)),
	LBOXWIN=win_CreateDynControl([ctl(wdef(wc_LBox,OwnRct,Title,BaseUnits),CtlId,
         	[wsf_OwnerDraw,wsf_HasStrings,wsf_VScroll,wsf_TabStop,wsf_Group])
                                     ],W),
	lbox_Suspend(LBOXWIN),
	lbox_Add(LBOXWIN,-1,LIST),
	lbox_Resume(LBOXWIN),
	lbox_SetSel(LBOXWIN,StartIndex,b_true),!.

  ownerdraw_CreateMenu(OwnerM,Menu):-
	translate_ODM_to_M(0,OwnerM,List),
	Menu = dyn_menu(List),!.
  
  ownerdraw_Destroy(ParentWin):-
	retractall(ownerdraw_rectangle(ParentWin,_,_,_)),!.
  ownerdraw_Destroy(ParentWin,CtlId):-
	retractall(ownerdraw_rectangle(ParentWin,CtlId,_,_)),!.

%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  ownerdraw_DrawButton(ACTIONLIST,_,_,_,_):- 
	not(own_member(ACTIONLIST,odact_Select)),
	check_flag_button,retractall(check_flag_button),!.

  ownerdraw_DrawButton(ACTIONLIST,_,RECT,W,USER_FUNC):- 
	own_member(ACTIONLIST,odact_DrawEntire),
 	draw_up_push_button(W,RECT,USER_FUNC),!.

  ownerdraw_DrawButton(ACTIONLIST,STATELIST,RECT,W,USER_FUNC):- 
	own_member(ACTIONLIST,odact_Select),
	own_member(STATELIST,odstate_Focus),
	own_member(STATELIST,odstate_Selected),
	draw_down_push_button(W,RECT,USER_FUNC),!.
	
  ownerdraw_DrawButton(_,STATELIST,RECT,W,USER_FUNC):- 
	own_member(STATELIST,odstate_Focus),
 	draw_up_push_button(W,RECT,USER_FUNC),
 	R = rect_Inflate(RECT,-6,-6),
	win_SetPen(W,pen(1,ps_Dot,color_Black)),
	win_SetBrush(W,brush(pat_Hollow,color_LtGray)),
	win_SetDrawMode(W,dm_CopyPen),
	draw_Rect(W,R),
	not(check_flag_button),assert(check_flag_button),!.

  ownerdraw_DrawButton(_,_,_,_,_).

%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  ownerdraw_DrawCheck(ACTIONLIST,_,RECT,CRCT,_W,CBOXWIN,USER_FUNC):-
	own_member(ACTIONLIST,odact_DrawEntire),
	give_ownerdraw_checked(CBOXWIN,B),
	draw_checkbox_checked(CBOXWIN,RECT,CRCT,USER_FUNC,B),!.

  ownerdraw_DrawCheck(ACTIONLIST,STATELIST,_,_,_,CBOXWIN,_):-
  	own_member(ACTIONLIST,odact_Select),
  	own_member(STATELIST,odstate_Selected),
	reverse_ownerdraw_checked(CBOXWIN),!.

  ownerdraw_DrawCheck(_,STATELIST,RECT,CRCT,_W,CBOXWIN,USER_FUNC):-
 	own_member(STATELIST,odstate_Focus),
 	not(own_member(STATELIST,odstate_Selected)),
	give_ownerdraw_checked(CBOXWIN,B),
	draw_checkbox_checked(CBOXWIN,RECT,CRCT,USER_FUNC,B),
 	R = rect_Inflate(RECT,-2,-2),
	win_SetPen(CBOXWIN,pen(1,ps_Dot,color_Black)),
	win_SetBrush(CBOXWIN,brush(pat_Hollow,color_LtGray)),
	draw_Rect(CBOXWIN,R),!.
    
  ownerdraw_DrawCheck(_,_,_,_,_,_,_).
  	
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%  ownerdraw_DrawListBox(ACTIONLIST,_,RECT ,W,LBOXWIN,INDEX,USER_FUNC,BOOL):-
% 	own_member(ACTIONLIST,odact_DrawEntire),
%	lbox_IsSel(LBOXWIN,INDEX),!,
%	STRITEM=lbox_GetItem(LBOXWIN,INDEX),
%	draw_list_box_selected(W,STRITEM,INDEX,RECT,USER_FUNC,b_true,BOOL),!.
  ownerdraw_DrawListBox(ACTIONLIST,_,RECT ,_W,LBOXWIN,INDEX,USER_FUNC,BOOL):-
	own_member(ACTIONLIST,odact_DrawEntire),
	STRITEM=lbox_GetItem(LBOXWIN,INDEX),
	draw_list_box_selected(LBOXWIN,STRITEM,INDEX,RECT,USER_FUNC,b_false,BOOL),!.
	
  ownerdraw_DrawListBox(ACTIONLIST,_STATELIST,RECT ,_W,LBOXWIN,INDEX,
   USER_FUNC,BOOL):-
	own_member(ACTIONLIST,odact_select),
ifndef os_nt
	not(own_member(_STATELIST,odstate_Selected)),
enddef
	STRITEM=lbox_GetItem(LBOXWIN,INDEX),
	draw_list_box_selected(LBOXWIN,STRITEM,INDEX,RECT,USER_FUNC,b_false,BOOL),!.
    
  ownerdraw_DrawListBox(_ACTIONLIST,STATELIST,RECT ,_W,LBOXWIN,INDEX,USER_FUNC,BOOL):-
ifdef ws_win
	own_member(_ACTIONLIST,odact_Focus),
enddef
	own_member(STATELIST,odstate_Focus),
ifdef os_nt
	own_member(STATELIST,odstate_Selected),
enddef
	STRITEM=lbox_GetItem(LBOXWIN,INDEX),
	draw_list_box_selected(LBOXWIN,STRITEM,INDEX,RECT,USER_FUNC,b_true,BOOL),
	BOOL = b_true,!,
 	R1 = rect_Inflate(RECT,-2,-2), R = rect_OffSet(R1,0,1),
	win_SetPen(LBOXWIN,pen(1,ps_Dot,color_Black)),
	win_SetBrush(LBOXWIN,brush(pat_Hollow,color_LtGray)),
	draw_Rect(LBOXWIN,R),!.

ifndef os_nt    
  ownerdraw_DrawListBox(_ACTIONLIST,STATELIST,RECT ,_W,LBOXWIN,INDEX,USER_FUNC,BOOL):-
ifdef ws_win
	own_member(_ACTIONLIST,odact_Focus),
enddef
	not(own_member(STATELIST,odstate_Focus)),
	STRITEM=lbox_GetItem(LBOXWIN,INDEX),
	draw_list_box_selected(LBOXWIN,STRITEM,INDEX,RECT,USER_FUNC,b_true,BOOL),!.
enddef

  ownerdraw_DrawListBox(_,_,_,_,_,_,_,_).

%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  ownerdraw_DrawMenu(ACTIONLIST,_STATELIST,W,_MENU_TAG,USER_FUNC):-
	own_member(ACTIONLIST,odact_DrawEntire),
	draw_all_menu_items(W,USER_FUNC),!.

  ownerdraw_DrawMenu(ACTIONLIST,STATELIST,W,MENU_TAG,USER_FUNC):-
	own_member(ACTIONLIST,odact_Select),
	own_member(STATELIST,odstate_Selected),
	draw_menu_items(W,MENU_TAG,USER_FUNC,b_true),!.

  ownerdraw_DrawMenu(ACTIONLIST,_,W,MENU_TAG,USER_FUNC):-
	own_member(ACTIONLIST,odact_Select),
	draw_menu_items(W,MENU_TAG,USER_FUNC,b_false),!.

  ownerdraw_DrawMenu(_,_,_,_,_).
    
%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  ownerdraw_DrawRadio(ACTIONLIST,_,RECT,CRCT,W,LW,CtrlID,USER_FUNC):-
	own_member(ACTIONLIST,odact_DrawEntire),
	ownerdraw_radio(W,CtrlID,_,G,B),
	retractall(ownerdraw_radio(W,CtrlID,_,_,_)),
	assert(ownerdraw_radio(W,CtrlID,LW,G,B)),
	draw_radiobutton_radio(LW,RECT,CRCT,CtrlID,USER_FUNC,B),!.

  ownerdraw_DrawRadio(ACTIONLIST,STATELIST,_,_,W,LW,CtrlID,_):-
  	own_member(ACTIONLIST,odact_Select),
  	own_member(STATELIST,odstate_Selected),
	ownerdraw_radio(W,CtrlID,LW,G,b_false), %if select selected, nothing to do
	ownerdraw_radio(W,OldId,OldWin,G,b_true),
	retractall(ownerdraw_radio(W,OldId,OldWin,G,b_true)),
	assert(ownerdraw_radio(W,OldId,OldWin,G,b_false)),
	retractall(ownerdraw_radio(W,CtrlID,LW,G,b_false)),
	assert(ownerdraw_radio(W,CtrlID,LW,G,b_true)),
	win_SetState(OldWin,[wsf_Invisible]),
	win_SetState(OldWin,[wsf_Visible]),!.

  ownerdraw_DrawRadio(_,STATELIST,RECT,CRCT,_W,LW,CtrlID,USER_FUNC):-
  	own_member(STATELIST,odstate_Focus),
  	not(own_member(STATELIST,odstate_Selected)),
	ownerdraw_radio(W,CtrlID,LW,G,_),
	ownerdraw_radio(W,_,OldWin,G,b_true),
	equivalence(OldWin,LW,B),
	draw_radiobutton_radio(LW,RECT,CRCT,CtrlID,USER_FUNC,B),
 	R = rect_Inflate(RECT,-2,-2),
	win_SetPen(LW,pen(1,ps_Dot,color_Black)),
	win_SetBrush(LW,brush(pat_Hollow,color_LtGray)),
	draw_Rect(LW,R),!.

  ownerdraw_DrawRadio(_,_,_,_,_,_,_,_).
  	
%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  ownerdraw_GroupControls(IdGroup,IdList,ParentWin):-	% BB! 13.10.97
	own_member(IdList,ID),
 	  ownerdraw_radio(ParentWin,ID,CtrlWin,0,_),
  	  retractall(ownerdraw_group_radio(0)),
	  retractall(ownerdraw_radio(ParentWin,ID,CtrlWin,0,_)),
	  assert(ownerdraw_radio(ParentWin,ID,CtrlWin,IdGroup,b_false)),
  	fail.
  ownerdraw_GroupControls(IdGroup,_,ParentWin):-
  	set_point_in_group(ParentWin,IdGroup),
  	set_point_in_win(ParentWin),!.
