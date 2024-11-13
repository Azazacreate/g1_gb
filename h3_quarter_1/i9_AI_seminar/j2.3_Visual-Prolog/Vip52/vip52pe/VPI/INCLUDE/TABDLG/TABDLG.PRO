/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S 

 FileName:	      TABDLG.PRO
 Purpose:	       This module implements tabbed dialogs via window class controls
 Written by:    Ole Kjær Christensen
 Last revised: 21/4/1984 - 2000

******************************************************************************/
ifndef tabdlg_pre_included
 #Error: this file requires include: tabdlg.pre
enddef 

constants
	radio_button_size = 10

database - tabdlg_db
	determ tabdlg_registered

	tabwin_created					  % List of created tab control windows
	(
		WINDOW		  TabWin
	)

	tabwin							  % List of created tab control windows for which
	(									       % a tabdlg_Create call has been issued:
		WINDOW		  TabWin,

		WINDOW		  Parent,	 % Parent dialog.
		CTLID		   ControlID,      % ID of the tab control window.
		FONT			    TabFont,		% Font used for tabs.
		BOOLEAN		 HasRadio,       % Radio buttons on tabs?
		TABDLG_STYLE    Style,	  % Style, i.e. top og left.
		UNSIGNED			Width,	  % Width of tabs.
		UNSIGNED			Height,	 % Height of tabs.
		RCT			     AllTabsRect,% Rectangle enclosing all tabs.
		RCT			     SheetRect       % Rectangle for the sheets.
	)

	tabwin_sheet					    % List of tab sheets for each tabwin control:
	(
		WINDOW		  TabWin,	 % Parent window class control handle.
		INTEGER		 SheetID,		% Sheet ID.

		TABDLG_TITLE    TabTitle,       % Title of tab associated with sheet.
		RCT			     TabRect	 % Rectangle of tab associated with sheet.
	)

	sheet_control					   % List of controls for each sheet in each tabwin control:
	(
		WINDOW		  TabWin,	 % Parent window class control handle
		INTEGER		 SheetID,		% Sheet ID
		CTLID		CtrlID	  % Control ID
	)
/*YI015*/sheet_control_flags		   % List of controls for each sheet in each tabwin control:
	(
		WINDOW		  TabWin,	 % Parent window class control handle
		INTEGER		 SheetID,		% Sheet ID
		CTLID		 CtrlID,	  % Control ID
		WSFLAGS		Flags  % enable and visible state 
	)

	current_sheet					   % Currently selected tab/sheet in tabwin.
	(
		WINDOW		  TabWin,	 % Parent window class control handle
		INTEGER		 SheetID	 % Currently selected/active tab/sheet
	)

	focus_sheet					     % Window has focus
	(
		WINDOW		  TabWin	  % window
	)

/*****************************************************************************/
/*							      REGISTER/UNREGISTER WINDOW CLASS							  */
/*****************************************************************************/

predicates
	tabdlg_eh : EHANDLER
clauses
	tabdlg_Register :-	% 17.09.1999 BB! (R990916.03)
		tabdlg_registered,!.
	tabdlg_Register :-
		not(tabdlg_registered),
		retractall(_, tabdlg_db),
		class_Create("PDCTAB",tabdlg_eh), !,
		assert(tabdlg_registered).
	tabdlg_Register :-
		exit(error_vpi_package_internal_error).

	tabdlg_Unregister :-	% 17.09.1999 BB! (R990916.03)
		not(tabdlg_registered),!.
	tabdlg_Unregister :-
		tabdlg_registered,
		class_Destroy("PDCTAB"), !,
		retractall(_, tabdlg_db).
	tabdlg_Unregister :-
		exit(error_vpi_package_internal_error).

/*----------------------------- Event Handling ------------------------------*/

predicates
procedure  draw_frame(WINDOW)
procedure  draw_tabs(WINDOW)
procedure  select_sheet(EHANDLER,WINDOW,INTEGER)
	dummy_eh : EHANDLER
procedure  get_back_color(COLOR)
procedure  get_shade_color(COLOR)
procedure  find_invalidate_rect(Window,TABDLG_STYLE,INTEGER,Rct,Rct)
determ  get_tabwin_style(WINDOW,TABDLG_STYLE)
determ  INTEGER change_sheet(INTEGER,INTEGER,ILIST)
clauses
	tabdlg_eh(TabWin, e_Create(_), 0) :- !,
		assert(tabwin_created(TabWin)).

	tabdlg_eh(TabWin, e_Update(_), 0) :- !,
%YI! 28.11.96   get_back_color(BackColor),
%	       win_Clear(TabWin, BackColor),
		draw_frame(TabWin),
		draw_tabs(TabWin).

	tabdlg_eh(TabWin, e_MouseDown(Point,_,_), 0) :-
		tabwin_sheet(TabWin, SheetID, _, Rect),
		rect_PntInside(Rect, Point),
		ParentDlg = win_GetParent(TabWin),		      % Override parent dialogs
		TheHandler = win_GetHandler(ParentDlg), % handler while selecting
%	       win_SetHandler(ParentDlg, dummy_eh),	    % the new sheet...
		select_sheet(TheHandler, TabWin, SheetID), !.
%	       win_SetHandler(ParentDlg, TheHandler).

	tabdlg_eh(TabWin, e_Char(Ch,_), 0) :- !,%YI
		findall(SheetID,tabwin_sheet(TabWin, SheetID, _, _),ListSheetID),
		current_sheet(TabWin, SheetID),
		NewSheetID = change_sheet(Ch,SheetID,ListSheetID),
		ParentDlg = win_GetParent(TabWin),		      % Override parent dialogs
		TheHandler = win_GetHandler(ParentDlg), % handler while selecting
		select_sheet(TheHandler, TabWin, NewSheetID),
		win_SetFocus(TabWin),!.

	tabdlg_eh(TabWin, e_GetFocus(), 0) :- !,%YI
		assert(focus_sheet(TabWin)),
		get_tabwin_style(TabWin, Style),
		current_sheet(TabWin, SheetID),
		tabwin_sheet(TabWin, SheetID, _, TabRect),
		find_invalidate_rect(TabWin,Style,SheetID,TabRect,Rect),
		win_Invalidate(TabWin,Rect),!.
	tabdlg_eh(TabWin, e_LoseFocus(), 0) :- !,%YI
		retract(focus_sheet(TabWin)),
		get_tabwin_style(TabWin, Style),
		current_sheet(TabWin, SheetID),
		tabwin_sheet(TabWin, SheetID, _, TabRect),
		find_invalidate_rect(TabWin,Style,SheetID,TabRect,Rect),
		win_Invalidate(TabWin,Rect),!.

	tabdlg_eh(TabWin, e_Destroy, 0) :- !,
		retractall(tabwin_created(TabWin)),
		retractall(tabwin(TabWin,_,_,_,_,_,_,_,_,_)),
		retractall(tabwin_sheet(TabWin,_,_,_)),
		retractall(sheet_control(TabWin,_,_)),
		retractall(sheet_control_flags(TabWin,_,_,_)),/*YI015*/
		retractall(current_sheet(TabWin,_)),
		retractall(focus_sheet(TabWin)).

	tabdlg_eh(_, e_EraseBackground, 0) :- !.

% This dummy event handler is used to speed up the switching process, by
% temporarily replacing the parent dialogs eventhandler with a handler that
% ignores all update events e.t.c.
clauses
	dummy_eh(_,e_Native(_,_,_),0) :- !, fail.
	dummy_eh(_,e_User(_,_),0) :- !, fail.
	dummy_eh(_,e_EraseBackground,0) :- !, fail.     % YI! 29.11.96
	dummy_eh(_,_,0).

% Select tab dialog, and send losefocus/getfocus messages:
predicates
procedure  draw_single_tab(WINDOW TabWin, INTEGER SheetID)
procedure  show_sheet(WINDOW TabWin, INTEGER SheetID, BOOLEAN Show/*YI015 WSFLAG Flag*/ )
procedure  get_prev_sheet(INTEGER,ILIST,INTEGER,INTEGER)
determ  get_next_sheet(INTEGER,ILIST,INTEGER)
determ  set_focus_to_first_ctrl(WINDOW,INTEGER)
clauses
	change_sheet(k_left,SheetID,ListSheetID,NewSheetID):-
		ListSheetID = [FirstSheet|RestListSheetID],
		FirstSheet <> SheetID,!,
		get_prev_sheet(SheetID,RestListSheetID,FirstSheet,NewSheetID).
	change_sheet(k_up,SheetID,ListSheetID,NewSheetID):-
		ListSheetID = [FirstSheet|RestListSheetID],
		FirstSheet <> SheetID,!,
		get_prev_sheet(SheetID,RestListSheetID,FirstSheet,NewSheetID).
	change_sheet(k_right,SheetID,ListSheetID,NewSheetID):-!,
		get_next_sheet(SheetID,ListSheetID,NewSheetID).
	change_sheet(k_down,SheetID,ListSheetID,NewSheetID):-!,
		get_next_sheet(SheetID,ListSheetID,NewSheetID).

	get_prev_sheet(SheetID,[SheetID|_],NewSheetID,NewSheetID):-!. %sheet is found
	get_prev_sheet(SheetID,[PrevSheet|ListSheetID],_,NewSheetID):-!,
		get_prev_sheet(SheetID,ListSheetID,PrevSheet,NewSheetID).
	get_prev_sheet(_,_,ID,ID):-errorexit(). % Should never be called !

	get_next_sheet(SheetID,[SheetID|ListSheetID],NewSheetID):-!, %sheet is found
		ListSheetID = [NewSheetID|_]. %fail if current is last
	get_next_sheet(SheetID,[_|ListSheetID],NewSheetID):-!,
		get_next_sheet(SheetID,ListSheetID,NewSheetID).

	select_sheet(_, TabWin, SheetID) :-		     % Do nothing if already current
		current_sheet(TabWin, SheetID), !.

	select_sheet(Handler, TabWin, _) :-		     % Otherwise deselect current...
		ParentDlg = win_GetParent(TabWin),	      % if losefocus is not caught by
		current_sheet(TabWin,PrevSheetID),	      % dialog handler
		Handler(ParentDlg, e_User(PrevSheetID,b_false)), !.
	select_sheet(Handler, TabWin, _) :-		     % Otherwise deselect current...
		draw_frame(TabWin),
		retract(current_sheet(TabWin,PrevSheetID)),
		draw_single_tab(TabWin, PrevSheetID),
		ParentDlg = win_GetParent(TabWin),
		win_SetHandler(ParentDlg, dummy_eh),	    % the new sheet...
			show_sheet(TabWin, PrevSheetID, b_false),
		win_SetHandler(ParentDlg, Handler),
		fail.
	select_sheet(Handler, TabWin, SheetID) :-       % ...and select the new
		assert(current_sheet(TabWin,SheetID)),
		draw_single_tab(TabWin, SheetID),
		ParentDlg = win_GetParent(TabWin),
		win_SetHandler(ParentDlg, dummy_eh),	    % the new sheet...
			show_sheet(TabWin, SheetID, b_true),
			win_SetFocus(ParentDlg),
			set_focus_to_first_ctrl(TabWin,SheetID),%YI 970226
			retractall(sheet_control(~0,-1,_)),
		win_SetHandler(ParentDlg, Handler),
		Handler(ParentDlg, e_User(SheetID,b_true)),
		fail.
	select_sheet(_,_,_).

predicates
procedure get_vis_enable_state(WSFlags, WSFlags) - (i,o) %YI015 

clauses
	show_sheet(TabWin, SheetID, b_true) :-
		ParentDlg = win_getParent(TabWin),
		sheet_control(TabWin,SheetID, CtlID),
			sheet_control_flags(TabWin,SheetID, CtlID, Flags),
			CtlWin = win_GetCtlHandle(ParentDlg, CtlID),
			win_SetState(CtlWin, Flags),
ifdef ws_win    % YI! 28.11.96
			WinType = win_GetType(CtlWin),
			WinType <> wc_GroupBox,
enddef
			win_BringToTop(CtlWin),
		fail.
	show_sheet(TabWin, SheetID, b_false) :-
		ParentDlg = win_getParent(TabWin),
		sheet_control(TabWin,SheetID, CtlID),
			CtlWin = win_GetCtlHandle(ParentDlg, CtlID),
%YI015 begin
			AllFlags = win_GetState(CtlWin),
			get_vis_enable_state(AllFlags, Flags),
			retractall(sheet_control_flags(TabWin,SheetID, CtlID, _)),
			assert(sheet_control_flags(TabWin,SheetID, CtlID, Flags)),
			win_SetState(CtlWin, [wsf_Invisible]),
			not(wc_Edit = win_GetType(CtlWin)),	% BB! 16.11.1998 (R981116.02)
			win_SetState(CtlWin, [wsf_Disabled]),
%YI015 end
		fail.
	show_sheet(TabWin, _, _) :-
		win_Update(TabWin),
		fail.
	show_sheet(_, _, _).

	get_vis_enable_state([], []):-!.
	get_vis_enable_state([wsf_Visible|AllFlags], [wsf_Visible|Flags]):- !,
		get_vis_enable_state(AllFlags, Flags).
	get_vis_enable_state([wsf_InVisible|AllFlags], [wsf_InVisible|Flags]):- !,
		get_vis_enable_state(AllFlags, Flags).
	get_vis_enable_state([wsf_Disabled|AllFlags], [wsf_Disabled|Flags]):- !,
		get_vis_enable_state(AllFlags, Flags).
	get_vis_enable_state([wsf_Enabled|AllFlags], [wsf_Enabled|Flags]):- !,
		get_vis_enable_state(AllFlags, Flags).
	get_vis_enable_state([_|AllFlags], Flags):- !,
		get_vis_enable_state(AllFlags, Flags).
	get_vis_enable_state(_,[]):-
		errorexit().
	
	set_focus_to_first_ctrl(TabWin,SheetID):- %YI 970226
		retractall(sheet_control(~0,-1,_)),
		sheet_control(TabWin,SheetID, CtlID), %reverse controls to find the first
		  asserta(sheet_control(~0,-1,CtlID)),
		fail
		;
		ParentDlg = win_getParent(TabWin),
		retract(sheet_control(~0,-1,CtlID)),
		  CtlWin = win_GetCtlHandle(ParentDlg,CtlID),
		  trap(win_SetFocus(CtlWin),_,fail),
		!.

clauses
%       get_back_color(color_ltGray).
	get_back_color(BackColor) :-
		BackColor = vpi_GetAttrVal(attr_color_btnface).

%       get_shade_color(color_gray).
	get_shade_color(ShadeColor) :-
		ShadeColor = vpi_GetAttrVal(attr_color_btnshadow).

/*****************************************************************************/
/*			TAB WINDOW DRAWING									*/
/*****************************************************************************/

/*------------------------------ Draw Tabs ----------------------------------*/

predicates
procedure       draw_tab(TABDLG_STYLE,WINDOW,INTEGER,TABDLG_TITLE,RCT)
clauses
	draw_tabs(TabWin) :-
		get_tabwin_style(TabWin, Style),
		tabwin_sheet(TabWin, SheetID, Title, TabRect),
			draw_tab(Style, TabWin, SheetID, Title, TabRect),
		fail.
	draw_tabs(_).

	draw_single_tab(TabWin, SheetID) :-
		tabwin_sheet(TabWin, SheetID, Title, TabRect), 
		get_tabwin_style(TabWin, Style),!,
		get_back_color(BackColor),
		win_Clear(TabWin, TabRect, BackColor),
		draw_tab(Style, TabWin, SheetID, Title, TabRect).
	draw_single_tab(_,_) :-
		exit(error_vpi_package_internal_error).

	get_tabwin_style(TabWin, Style) :-
		tabwin(TabWin,_,_,_,_,Style,_,_,_,_), !.
%YI	get_tabwin_style(_, top) :-
%		exit(error_vpi_package_internal_error).

predicates
procedure       adjust_current_tab(WINDOW,INTEGER,RCT,INTEGER,INTEGER, RCT)
procedure       draw_tab_title(WINDOW,INTEGER,RCT,TABDLG_TITLE)
procedure       adjust_edge(WINDOW,INTEGER, INTEGER,INTEGER, INTEGER,INTEGER)
clauses
	draw_tab(top, TabWin, SheetID, Title, TabRect) :- !,
		adjust_current_tab(TabWin,SheetID,TabRect,0,2, TabRect1),
		TabRect1 = rct(L,T,R,B),
		T1 = T + 1,     T2 = T + 2,
		L1 = L + 1,     L2 = L + 2,
		R1 = R - 1, R2 = R - 2,
		B1 = B + 1,
		adjust_edge(TabWin,SheetID, B, 1, Bx1,Bx2),
		% Draw title:
		draw_tab_title(TabWin, SheetID, TabRect1, Title),
		% Draw left and top edges (white):
		win_SetPen(TabWin, pen(1,ps_Solid,color_white)),
		draw_Line(TabWin, pnt(L,T1),  pnt(L,Bx1)),
		draw_Line(TabWin, pnt(L1,T),  pnt(R1,T)),
		% Draw right edge (dark grey):
		get_shade_color(ShadeColor),
		win_SetPen(TabWin, pen(1,ps_Solid,ShadeColor)),
		draw_Line(TabWin, pnt(R2,T1), pnt(R2,Bx2)),
		win_SetPen(TabWin, pen(1,ps_Solid,color_black)),
		draw_Line(TabWin, pnt(R1,T2), pnt(R1,Bx1)),
		% Draw bottom edge if current (light grey):
		get_back_color(BackColor),
		win_SetPen(TabWin, pen(1,ps_Solid,BackColor)),
		draw_Line(TabWin, pnt(L1,T1), pnt(L1,Bx1)),
		draw_Line(TabWin, pnt(L2,T1), pnt(R2,T1)),
		draw_Line(TabWin, pnt(L2,B),  pnt(R2,B)),
		draw_Line(TabWin, pnt(L2,B1), pnt(R2,B1)).

	draw_tab(bottom, TabWin, SheetID, Title, TabRect) :- !,
		adjust_current_tab(TabWin,SheetID,TabRect,0,-2, TabRect1),
		TabRect1 = rct(L,T,R,B),
		T1 = T - 1,     T2 = T - 2,
		L1 = L + 1,     L2 = L + 2,
		R1 = R - 1, R2 = R - 2,
		B1 = B - 1, B2 = B - 2,
		% Draw title:
		draw_tab_title(TabWin, SheetID, TabRect1, Title),
		% Draw left edge (white):
		win_SetPen(TabWin, pen(1,ps_Solid,color_white)),
		adjust_edge(TabWin,SheetID, T, -1, Tx1,Tx2),
		draw_Line(TabWin, pnt(L,Tx1),  pnt(L,B2)),
		% Draw right and bottom edges (dark grey):
		get_shade_color(ShadeColor),
		win_SetPen(TabWin, pen(1,ps_Solid,ShadeColor)),
		draw_Line(TabWin, pnt(R2,Tx1),   pnt(R2,B2)),
		draw_Line(TabWin, pnt(L1,B2),  pnt(R1,B2)),
		win_SetPen(TabWin, pen(1,ps_Solid,color_black)),
		draw_Line(TabWin, pnt(R1,Tx1),   pnt(R1,B1)),
		draw_Line(TabWin, pnt(L1,B1),  pnt(R1,B1)),
		% Draw top edge if current (light grey):
		get_back_color(BackColor),
		win_SetPen(TabWin, pen(1,ps_Solid,BackColor)),
		draw_Line(TabWin, pnt(L1,Tx2), pnt(L1,B2)),
		draw_Line(TabWin, pnt(L2,T2),  pnt(R2,T2)),
		draw_Line(TabWin, pnt(L2,T1),  pnt(R2,T1)).

	draw_tab(right, TabWin, SheetID, Title, TabRect) :- !,
		adjust_current_tab(TabWin,SheetID,TabRect,-2,0, TabRect1),
		TabRect1 = rct(L,T,R,B),
		T1 = T + 1,     T2 = T + 2,
		L1 = L - 1,     L2 = L - 2,
		R1 = R - 1, R2 = R - 2,
		B1 = B - 1, B2 = B - 2,
		% Draw title:
		draw_tab_title(TabWin, SheetID, TabRect1, Title),
		% Draw top edge (white):
		win_SetPen(TabWin, pen(1,ps_Solid,color_white)),
		adjust_edge(TabWin,SheetID, L, -1, Lx1,Lx2),
		draw_Line(TabWin, pnt(Lx1,T),  pnt(R2,T)),
		% Draw right and bottom edges (dark gray):
		get_shade_color(ShadeColor),
		win_SetPen(TabWin, pen(1,ps_Solid,ShadeColor)),
		draw_Line(TabWin, pnt(R2,T1),  pnt(R2,B1)),
		draw_Line(TabWin, pnt(Lx1,B2),   pnt(R2,B2)),
		win_SetPen(TabWin, pen(1,ps_Solid,color_black)),
		draw_Line(TabWin, pnt(Lx1,B1),   pnt(R1,B1)),
		draw_Line(TabWin, pnt(R1,T1),  pnt(R1,B1)),
		% Draw left edge if current (light gray):
		get_back_color(BackColor),
		win_SetPen(TabWin, pen(1,ps_Solid,BackColor)),
		draw_Line(TabWin, pnt(Lx2,T1), pnt(R2,T1)),
		draw_Line(TabWin, pnt(L2,T2),  pnt(L2,B2)),
		draw_Line(TabWin, pnt(L1,T2),  pnt(L1,B2)).

	draw_tab(left, TabWin, SheetID, Title, TabRect) :- !,
		adjust_current_tab(TabWin,SheetID,TabRect,2,0, TabRect1),
		TabRect1 = rct(L,T,R,B),
		T1 = T + 1,     T2 = T + 2,
		L1 = L + 1,     %L2 = L + 2,
		R1 = R + 1,
		B1 = B - 1, B2 = B - 2,
		adjust_edge(TabWin,SheetID, R, 1, Rx1,Rx2),
		% Draw title:
		draw_tab_title(TabWin, SheetID, TabRect1, Title),
		% Draw top and left edges (white):
		win_SetPen(TabWin, pen(1,ps_Solid,color_white)),
		draw_Line(TabWin, pnt(L1,T),  pnt(Rx1,T)),
		draw_Line(TabWin, pnt(L,T1),  pnt(L,B2)),
		% Draw bottom edge (dark gray):
		get_shade_color(ShadeColor),
		win_SetPen(TabWin, pen(1,ps_Solid,ShadeColor)),
		draw_Line(TabWin, pnt(L,B2), pnt(Rx2,B2)),
		win_SetPen(TabWin, pen(1,ps_Solid,color_black)),
		draw_Line(TabWin, pnt(L1,B1), pnt(Rx1,B1)),
		% Draw right edge if current (light gray):
		get_back_color(BackColor),
		win_SetPen(TabWin, pen(1,ps_Solid,BackColor)),
		draw_Line(TabWin, pnt(L1,T1), pnt(Rx1,T1)),
		draw_Line(TabWin, pnt(L1,T2), pnt(L1,B2)),
		draw_Line(TabWin, pnt(R,T2),  pnt(R,B2)),
		draw_Line(TabWin, pnt(R1,T2), pnt(R1,B2)).
	draw_tab(_,_,_,_,_):-errorexit(). % Should never be called !	

predicates
procedure  check_draw_radio(WINDOW TabWin, INTEGER SheetID, RCT TitleRect, RCT NewTitleRect)

clauses
	draw_tab_title(TabWin, SheetID, TabRect, _) :-%YI 970223 erase focus frame
		not(focus_sheet(TabWin)),
		current_sheet(TabWin, SheetID),
		TitleRect = rect_Inflate(TabRect, -4, -4),
		check_draw_radio(TabWin, SheetID, TitleRect, TitleRect1),
		FocusRect = rect_Inflate(TitleRect1, 1, 1),
		get_back_color(BackColor),
		win_SetPen(TabWin,pen(1,ps_Solid,BackColor)),
		win_SetBrush(TabWin,brush(pat_hollow,color_black)),
		draw_Rect(TabWin,FocusRect),
		fail.
	draw_tab_title(TabWin, SheetID, TabRect, text(Title)) :-
		TitleRect = rect_Inflate(TabRect, -4, -2),
		check_draw_radio(TabWin, SheetID, TitleRect, TitleRect1),
		draw_TextInRect(TabWin, TitleRect1, Title, -1, [dtext_vcenter,dtext_left]),
		fail.
	draw_tab_title(TabWin, SheetID, TabRect, icon(ResID)) :-
		TitleRect = rect_Inflate(TabRect, -4, -4),
		check_draw_radio(TabWin, SheetID, TitleRect, TitleRect1),
		TitleRect1 = rct(L,T,_,_),
		draw_Icon(TabWin, L, T, ResID),
		fail.
	draw_tab_title(TabWin, SheetID, TabRect, bmp(ResID)) :-
		TitleRect = rect_Inflate(TabRect, -4, -4),
		check_draw_radio(TabWin, SheetID, TitleRect, TitleRect1),
		TitleRect1 = rct(L,T,_,_),
		Pict  = pict_GetFromRes(ResID),
		pict_Draw(TabWin,Pict,pnt(L,T),rop_SrcCopy),
		pict_Destroy(Pict),
		fail.
	draw_tab_title(TabWin, SheetID, TabRect, _) :-%YI 970223 draw focus frame
		focus_sheet(TabWin),
		current_sheet(TabWin, SheetID),
		TitleRect = rect_Inflate(TabRect, -4, -4),
		check_draw_radio(TabWin, SheetID, TitleRect, TitleRect1),
		FocusRect = rect_Inflate(TitleRect1, 1, 1),
		win_SetPen(TabWin,pen(1,ps_Dot,color_black)),
		win_SetBrush(TabWin,brush(pat_hollow,color_black)),
		draw_Rect(TabWin,FocusRect),
		fail.
	draw_tab_title(_, _, _, _) :-!.

	find_invalidate_rect(TabWin,top,SheetID,TabRect,Rect):-
		adjust_current_tab(TabWin,SheetID,TabRect,0,2, Rect),!.
	find_invalidate_rect(TabWin,bottom,SheetID,TabRect,Rect):-
		adjust_current_tab(TabWin,SheetID,TabRect,0,-2, Rect),!.
	find_invalidate_rect(TabWin,right,SheetID,TabRect,Rect):-
		adjust_current_tab(TabWin,SheetID,TabRect,-2,0, Rect),!.
	find_invalidate_rect(TabWin,left,SheetID,TabRect,Rect):-
		adjust_current_tab(TabWin,SheetID,TabRect,2,0, Rect),!.
	find_invalidate_rect(_,_,_,_,rct(0,0,0,0)):-errorexit(). % Should never be called !

	check_draw_radio(TabWin, _, TitleRect, TitleRect) :-		    % Never mind if no
		tabwin(TabWin,_,_,_,b_false,_,_,_,_,_), !.						      % radio buttons...
	check_draw_radio(TabWin, SheetID, rct(L,T,_,_), _) :-
		T1 = T + 2, %(T + B - radio_button_size)/2,
		B1 = T1 + radio_button_size,
		R1 = L + radio_button_size,
		RadioRect = rct(L,T1,R1,B1),
		win_SetPen(TabWin, pen(1,ps_Solid,color_black)),
		win_SetBrush(TabWin, brush(pat_Solid,color_White)),
		draw_Ellipse(TabWin, RadioRect),
		current_sheet(TabWin, SheetID),
		BulletRect = rect_Inflate(RadioRect, -2, -2),
		win_SetBrush(TabWin, brush(pat_Solid,color_Black)),
		draw_Ellipse(TabWin, BulletRect),
		fail.
	check_draw_radio(_, _, rct(L,T,R,B), rct(L1,T,R,B)) :-
		L1 = L + radio_button_size + 4.

clauses
	adjust_current_tab(TabWin, SheetID, TabRect,_,_, TabRect) :-
		current_sheet(TabWin, SheetID), !.
	adjust_current_tab(_,_, TabRect,DX,DY, TabRect1) :-
		TabRect1 = rect_OffSet(TabRect, DX, DY).

	adjust_edge(TabWin,SheetID, X,DX, X1,X2) :-
		current_sheet(TabWin, SheetID), !,
		X1 = X + DX,
		X2 = X + 2*DX.
	adjust_edge(_,_, X,DX ,X1,X2) :-
		X1 = X - 2*DX,
		X2 = X - 2*DX.

/*------------------------------ Draw Frame ---------------------------------*/

clauses
	draw_frame(TabWin) :-
		tabwin(TabWin,_,_,_,_,_,_,_,_,rct(L,T,R,B)), !,
		L1 = L + 1,
		T1 = T + 1, T2 = T + 2,
		R1 = R - 1, R2 = R - 2,
		B1 = B - 1, B2 = B - 2,
		win_SetPen(TabWin, pen(1,ps_Solid,color_white)),
		draw_Line(TabWin, pnt(L,T),  pnt(R,T)),
		draw_Line(TabWin, pnt(L,T),  pnt(L,B1)),
		get_back_color(BackColor),
		win_SetPen(TabWin, pen(1,ps_Solid,BackColor)),
		draw_Line(TabWin, pnt(L1,T1), pnt(R1,T1)),
		draw_Line(TabWin, pnt(L1,T1),  pnt(L1,B2)),
		win_SetPen(TabWin, pen(1,ps_Solid,color_black)),
		draw_Line(TabWin, pnt(R1,T1), pnt(R1,B)),
		draw_Line(TabWin, pnt(L,B1), pnt(R,B1)),
		get_shade_color(ShadeColor),
		win_SetPen(TabWin, pen(1,ps_Solid,ShadeColor)),
		draw_Line(TabWin, pnt(R2,T2), pnt(R2,B1)),
		draw_Line(TabWin, pnt(L1,B2), pnt(R1,B2)).
	draw_frame(_) :-
		exit(error_vpi_package_internal_error).

/*****************************************************************************/
/*			CREATE TAB DIALOGS									*/
/*****************************************************************************/

predicates

procedure       tab_maxsize_sheetTitle(WINDOW,TABDLG_LIST,INTEGER,INTEGER,INTEGER,INTEGER)
procedure       tab_max(INTEGER,INTEGER,INTEGER)
procedure       tab_adjust(TABDLG_STYLE,UNSIGNED,UNSIGNED,RCT, RCT,RCT,RCT/*,UNSIGNED,UNSIGNED*/)       % BB! 4.01.97
procedure  create_sheets(WINDOW, INTEGER,INTEGER, RCT,TABDLG_STYLE, TABDLG_LIST)		  % BB! 4.01.97

clauses
	tabdlg_Create(Parent,TabID, Font,Style,Width,Height, SheetList, FirstSheetID) :-
		tabdlg_Create(Parent,TabID, Font,b_false,Style,Width,Height, SheetList, FirstSheetID).

	tabdlg_Create(Parent,TabID, Font,HasRadio,Style,_Width,_Height, SheetList, FirstSheetID) :-
		tabdlg_registered,
		not(SheetList = []),
		TabWin = win_GetCtlHandle(Parent, TabID),
		% Check that tab class control is created, and that tabdlg_Create has
		% not yet been called:
		tabwin_created(TabWin),
		not(tabwin(TabWin,_,_,_,_,_,_,_,_,_)), !,

		win_SetFont(TabWin, Font),
		tab_maxsize_sheetTitle(TabWin,SheetList,0,0,Width,Height),      % BB! 4.01.97   Get Width & Height Tag of sheet
		Rect = win_GetClientRect(TabWin),
		tab_adjust(Style,Width,Height,Rect, AllTabsRect,SheetRect, FirstTabRect/*,DW,DH*/),     % BB! 4.01.97
		assert(tabwin(TabWin,Parent,TabID,Font,HasRadio,Style,Width,Height,AllTabsRect,SheetRect)),
		win_Invalidate(TabWin, AllTabsRect),

		OuterRect = win_GetOuterRect(TabWin),
		OuterRect = rct(X1,Y1,_,_),
		SheetRect = rct(X2,Y2,_,_),

		vpi_getBaseUnits(DUWide, DUHigh),
		win_DialogRatio(Parent,PNTr),	% BB! New VPI predicate
		PNTr = pnt(RX,RY),

		X = 100*((X1*4 div DUWide) + (X2*4 div DUWide)) div RX,	% BB! 27.11.97 (016)
		Y = 100*((Y1*8 div DUHIgh) + (Y2*8 div DUHigh)) div RY,

		TheHandler = win_GetHandler(Parent),    % handler while selecting
		win_SetHandler(Parent, dummy_eh),	       % the new sheet...
		create_sheets(TabWin,X,Y, FirstTabRect,Style,SheetList),
		win_SetHandler(Parent, TheHandler),

		select_sheet(TheHandler, TabWin, FirstSheetID).

	tabdlg_Create(_,_, _,_,_,_,_, _,_) :-
		exit(error_vpi_package_internal_error).

	tab_max(A,B,A):-
		A >= B,!.
	tab_max(_,B,B):-!.

	tab_maxsize_sheetTitle(_TabWin,[],Width,Height,Width,Height):-!.
	tab_maxsize_sheetTitle(TabWin,[tabdlg(_,text(Title),_,_)|SheetList],W,H,Width,Height):-
		win_GetTextExtent(TabWin,Title,-1,WT,HT),
		W1 = WT + 10,
		H1 = HT + 8,
		tab_max(W,W1,WM),
		tab_max(H,H1,HM),!,
		tab_maxsize_sheetTitle(TabWin,SheetList,WM,HM,Width,Height).
	tab_maxsize_sheetTitle(TabWin,[tabdlg(_,bmp(BmpID),_,_)|SheetList],W,H,Width,Height):-
		Pict  = pict_GetFromRes(BmpID),
		pict_GetSize(Pict,WB,HB,_),
		W1 = WB + 10,
		H1 = HB + 10,
		tab_max(W,W1,WM),
		tab_max(H,H1,HM),!,
		tab_maxsize_sheetTitle(TabWin,SheetList,WM,HM,Width,Height).
	tab_maxsize_sheetTitle(TabWin,[tabdlg(_,icon(_IconID),_,_)|SheetList],W,H,Width,Height):-
		tab_max(W,42,WM),
		tab_max(H,42,HM),!,
		tab_maxsize_sheetTitle(TabWin,SheetList,WM,HM,Width,Height).
	tab_maxsize_sheetTitle(_,_,W,H,W,H):-errorexit(). % Should never be called !

	tab_adjust(top,Width,Height,rct(L,T,R,B),rct(L,T,R,T1),rct(L,T1,R,B),rct(L,T,R1,T1)):-!,
		T1 = T + Height,	% Top edge of sheet
		R1 = L + Width.		% Right edge of first tab
	tab_adjust(bottom,Width,Height,rct(L,T,R,B),rct(L,B1,R,B),rct(L,T,R,B1),rct(L,B1,R1,B)):-!,
		B1 = B - Height,	% Bottom edge of sheet
		R1 = L + Width.		% Right edge of first tab
	tab_adjust(left,Width,Height,rct(L,T,R,B),rct(L,T,L1,B),rct(L1,T,R,B),rct(L,T,L1,B1)):-!,
		L1 = L + Width,		% Left edge of sheet
		B1 = T + Height.	% Bottom edge of first tab
	tab_adjust(right,Width,Height,rct(L,T,R,B),rct(R1,T,R,B),rct(L,T,R1,B),rct(R1,T,R,B1)):-!,
		R1 = R - Width,		% Right edge of sheet
		B1 = T + Height.	% Bottom edge of first tab
	tab_adjust(_,_,_,RCT,RCT,RCT,RCT):-errorexit(). % Should never be called !

% This part creates each of the subdialogs/layers, as well as the associated
% controls. Also, the tabs are created. The logical subdialog ID is sent as
% creation data to the subdialog handler.

predicates

procedure  get_sheetRect(WINDOW,TABDLG_STYLE,RCT,TABDLG_TITLE,RCT,INTEGER,INTEGER)	 % BB! 4.01.97
procedure  create_sheet(TABDLG_DEF, WINDEF_LIST)
procedure  scan_windefs(WINDOW,INTEGER, INTEGER,INTEGER, WINDEF_LIST, WINDEF_LIST)
procedure  set_dlg_fields(WINDOW, DIALOG_FIELD_LIST)
procedure  get_invisible_disable_and_visible_state(WSFLAGS,WSFLAGS,WSFLAGS,WSFLAGS) - (i,i,o,o) %YI015

clauses

	create_sheets(_, _,_,_,_, []) :- !.
	create_sheets(TabWin, X,Y, MaxTabRect, Style, [tabdlg(SheetID,Title,CtlSpec,FList)|SheetList]) :-
		get_sheetRect(TabWin,Style,MaxTabRect,Title,TabRect,DW,DH),     % BB! 4.01.97   Get RCT for Tag of Sheet & Rectangle Offset
		assert(tabwin_sheet(TabWin,SheetID,Title,TabRect)),
		create_sheet(CtlSpec, WDefList),
		scan_windefs(TabWin,SheetID, X,Y, WDefList, WDefList1),
		ParentDlg = win_GetParent(TabWin),
		win_CreateDynControl(WDefList1, ParentDlg),
		set_dlg_fields(ParentDlg, FList),
		TabRect1 = rect_Offset(TabRect,DW,DH),!,
		create_sheets(TabWin, X,Y, TabRect1, Style, SheetList).
	create_sheets(_,_,_,_,_,_):-errorexit(). % Should never be called !

	get_sheetRect(TabWin,Style,rct(L,T,_R,B),text(Title),rct(L,T,R1,B),DW,0):-
		not(Style = left), not(Style = right),
		win_GetTextExtent(TabWin,Title,-1,WT,_),
		DW = WT + 10,
		R1 = L + DW,!.
	get_sheetRect(TabWin,_,rct(L,T,R,_B),text(Title),rct(L,T,R,B1),0,DH):-
		win_GetTextExtent(TabWin,Title,-1,_,HT),
		DH = HT + 8,
		B1 = T + DH,!.
	get_sheetRect(_,Style,rct(L,T,_R,B),bmp(BmpID),rct(L,T,R1,B),DW,0):-
		not(Style = left), not(Style = right),
		Pict  = pict_GetFromRes(BmpID),
		pict_GetSize(Pict,WB,_,_),
		DW = WB + 10,
		R1 = L + DW,!.
	get_sheetRect(_,_,rct(L,T,R,_B),bmp(BmpID),rct(L,T,R,B1),0,DH):-
		Pict  = pict_GetFromRes(BmpID),
		pict_GetSize(Pict,_,HB,_),
		DH = HB + 10,
		B1 = T + DH,!.
	get_sheetRect(_,Style,rct(L,T,_R,B),icon(_IconID),rct(L,T,R1,B),DW,0):-
		not(Style = left), not(Style = right),
		DW = 42,
		R1 = L + DW,!.
	get_sheetRect(_,_,rct(L,T,R,_B),icon(_IconID),rct(L,T,R,B1),0,DH):-
		DH = 42,
		B1 = T + DH,!.
	get_sheetRect(_,_,RCT,_,RCT,0,0):-errorexit(). % Should never be called !

	create_sheet(dyn(CtlList),CtlList):-!.
	create_sheet(res(ResID),CtlList):-!,
		CtlList = win_GetResDialog(ResID).
	create_sheet(_,[]):-errorexit(). % Should never be called !

	scan_windefs(_,_,_,_,[],[]):-!.
	% Normal controls:
	scan_windefs(TabWin,SheetID, X,Y, [Ctrl|WDefList], [Ctrl1|WDefList1]) :-
		Ctrl  = ctl(wdef(Wintype,Rect,Title,UType), CtlID, Flags), !,
		get_invisible_disable_and_visible_state(Flags,[wsf_Visible,wsf_enabled],InvisFlags,VisFlags), %YI015
		Rect1 = rect_offset(Rect,X,Y),
		Ctrl1 = ctl(wdef(Wintype,Rect1,Title,UType), CtlID, InvisFlags/*YI015 [wsf_Invisible|Flags]*/),
		asserta(sheet_control(TabWin,SheetID,CtlID)),
		assert(sheet_control_flags(TabWin,SheetID,CtlID,VisFlags)),%YI015
		scan_windefs(TabWin,SheetID, X,Y, WDefList, WDefList1).
	% Custom controls:
	scan_windefs(TabWin,SheetID, X,Y, [Ctrl|WDefList], [Ctrl1|WDefList1]) :-
		Ctrl  = customctl(wdef(Wintype,Rect,Title,UType), ClassName, CtlID, Flags), !,
		get_invisible_disable_and_visible_state(Flags,[wsf_Visible,wsf_enabled],InvisFlags,VisFlags), %YI015
		Rect1 = rect_offset(Rect,X,Y),
		Ctrl1 = customctl(wdef(Wintype,Rect1,Title,UType), ClassName, CtlID, InvisFlags/*YI015 [wsf_Invisible|Flags]*/),
		asserta(sheet_control(TabWin,SheetID,CtlID)),
		assert(sheet_control_flags(TabWin,SheetID,CtlID,VisFlags)),/*YI015*/
		scan_windefs(TabWin,SheetID, X,Y, WDefList, WDefList1).
/*	% Icons:
	scan_windefs(TabWin,SheetID, X,Y, [Icon|WDefList], [Icon1|WDefList1]) :-
		Icon  = icon(wdef(Wintype,Rect,Title,UType), CtlID, ResID, Flags), !,
		Rect1 = rect_offset(Rect,X,Y),
		Icon1 = icon(wdef(Wintype,Rect1,Title,UType), CtlID, ResID, [wsf_Invisible|Flags]),
		assert(sheet_control(TabWin,SheetID,CtlID)),
		scan_windefs(TabWin,SheetID, X,Y, WDefList, WDefList1).
*/	% Skip everything else:
	scan_windefs(TabWin,SheetID, X,Y, [_|WDefList], WDefList1):-!,
		scan_windefs(TabWin,SheetID, X,Y, WDefList, WDefList1).
	scan_windefs(_,_,_,_,_,[]):-errorexit(). % Should never be called !

	set_dlg_fields(_, []) :- !.
	set_dlg_fields(ParentDlg, FList) :-
		dialog_SetFields(ParentDlg, FList), !.
	set_dlg_fields(_, _) :-
		exit(error_vpi_package_internal_error).
%YI015 begin
predicates
procedure remove_wsflag(WSFLAGS,WSFLAG,WSFLAGS) - (i,i,o)
clauses
	get_invisible_disable_and_visible_state([], DefFlags, [wsf_Invisible,wsf_Disabled], DefFlags):-!. 
	get_invisible_disable_and_visible_state([wsf_Invisible|Flags], DefFlags, InvisFlags,[wsf_Invisible|VisFlags]):-% wsf_Invisible is added to VisFlags to avoid win_SetState(Win,[])
		remove_wsflag(DefFlags,wsf_Visible,DefFlags1),!,
		get_invisible_disable_and_visible_state(Flags,DefFlags1,InvisFlags,VisFlags).
	get_invisible_disable_and_visible_state([wsf_visible|Flags], DefFlags, InvisFlags,[wsf_Visible|VisFlags]):-
		remove_wsflag(DefFlags,wsf_Visible,DefFlags1),!,
		get_invisible_disable_and_visible_state(Flags,DefFlags1,InvisFlags,VisFlags).
	get_invisible_disable_and_visible_state([wsf_Disabled|Flags], DefFlags, InvisFlags,VisFlags):-
		remove_wsflag(DefFlags,wsf_Enabled,DefFlags1),!,
		get_invisible_disable_and_visible_state(Flags,DefFlags1,InvisFlags,VisFlags).
	get_invisible_disable_and_visible_state([wsf_Enabled|Flags], DefFlags, InvisFlags,[wsf_Enabled|VisFlags]):-
		remove_wsflag(DefFlags,wsf_Enabled,DefFlags1),!,
		get_invisible_disable_and_visible_state(Flags,DefFlags1,InvisFlags,VisFlags).
	get_invisible_disable_and_visible_state([F|Flags], DefFlags, [F|InvisFlags],VisFlags):-!,
		get_invisible_disable_and_visible_state(Flags,DefFlags,InvisFlags,VisFlags).
	get_invisible_disable_and_visible_state(_, _, [],[]):-!,
		errorexit.

	remove_wsflag([],_,[]):-!.
	remove_wsflag([F|Flags],F,Flags1):-!,
		remove_wsflag(Flags,F,Flags1).
	remove_wsflag([OtherFlag|Flags],F,[OtherFlag|Flags1]):-!,
		remove_wsflag(Flags,F,Flags1).
	remove_wsflag(_,_,[]):-!,
		errorexit.

%YI015 end	

/*****************************************************************************/
/*			SELECT TAB DIALOGS									*/
/*****************************************************************************/

clauses
	tabdlg_Select(ParentDlg, TabID, SheetID) :-
		free(SheetID),
		TabWin = win_GetCtlHandle(ParentDlg,TabID),
		current_sheet(TabWin, SheetID), !.
	tabdlg_Select(_ParentDlg, _TabID, SheetID) :- %YI 970429
		free(SheetID),
		SheetID = 0,!,
		exit(error_vpi_package_internal_error).
	tabdlg_Select(ParentDlg, TabID, SheetID) :-
		bound(SheetID),
		TabWin = win_GetCtlHandle(ParentDlg, TabID),
		TheHandler = win_GetHandler(ParentDlg),
		select_sheet(TheHandler, TabWin, SheetID), !.

/*****************************************************************************/
/*			RETRIEVING SHEET/CONTROL IDS						      */
/*****************************************************************************/

clauses
	tabdlg_GetSheetID(ParentDlg, CtrlID, SheetID) :-	% (i,i,o)
		sheet_control(TabWin, SheetID, CtrlID),
		Parent = win_GetParent(TabWin),
		Parent = ParentDlg, !.
	tabdlg_GetSheetID(_,_,0) :-
		exit(error_vpi_package_internal_error).

	tabdlg_GetSheetControls(ParentDlg, SheetID, CtrlID) :-	% (i,i,o)
		sheet_control(TabWin, SheetID, CtrlID),
			Parent = win_GetParent(TabWin),
			Parent = ParentDlg.

/*****************************************************************************/
/*	SET ENABLE/DISABLE VISIBLE/INVISIBLE CONTROL STATE		     */
/*****************************************************************************/
predicates

  determ get_enableFlag(INTEGER,CTLID,BOOLEAN,WSFLAG)
  determ get_showFlag(INTEGER,CTLID,BOOLEAN,WSFLAG)

clauses
	tabdlg_SetState(_, []):-!.
	tabdlg_SetState(DlgWin, [enable(CtlID,Enable)|T]) :-
		CWIN = win_GetCtlHandle(DlgWin, CtlID),
		tabdlg_GetSheetID(DlgWin, CtlID, SheetID),
		get_enableFlag(SheetID, CtlID, Enable, FLAG),
		win_SetState(CWIN, [FLAG]),!,
		tabdlg_SetState(DlgWin, T).
	tabdlg_SetState(DlgWin, [show(CtlID, Show)|T]):-
		CWIN = win_GetCtlHandle(DlgWin, CtlID),
		tabdlg_GetSheetID(DlgWin, CtlID, SheetID),
		get_showFlag(SheetID, CtlID, Show, FLAG),
		win_SetState(CWIN, [FLAG]),!,
		tabdlg_SetState(DlgWin, T).
	tabdlg_SetState(_,_):-!,
		errorexit(error_vpi_package_bad_identifier).

	get_enableFlag(SheetID, CtlID, 0, wsf_Disabled):-
		retract(sheet_control_flags(TabWin, SheetID, CtlID, DefFlags)),
		remove_wsflag(DefFlags, wsf_Enabled, DefFlags1),
		assert(sheet_control_flags(TabWin, SheetID, CtlID, [wsf_Disabled|DefFlags1])),!.
	get_enableFlag(SheetID, CtlID, 1, wsf_Enabled):-
		retract(sheet_control_flags(TabWin, SheetID, CtlID, DefFlags)),
		remove_wsflag(DefFlags,wsf_Disabled,DefFlags1),!,
		assert(sheet_control_flags(TabWin, SheetID, CtlID, [wsf_Enabled|DefFlags1])),!.

	get_showFlag(SheetID, CtlID, 0, wsf_Invisible):-
		retract(sheet_control_flags(TabWin, SheetID, CtlID, DefFlags)),
		remove_wsflag(DefFlags, wsf_Visible, DefFlags1),
		assert(sheet_control_flags(TabWin, SheetID, CtlID, [wsf_Invisible|DefFlags1])),!.
	get_showFlag(SheetID, CtlID, 1, wsf_Visible):-
		retract(sheet_control_flags(TabWin, SheetID, CtlID, DefFlags)),
		remove_wsflag(DefFlags,wsf_Invisible,DefFlags1),!,
		assert(sheet_control_flags(TabWin, SheetID, CtlID, [wsf_Visible|DefFlags1])),!.
