/******************************************************************************

                Copyright (c) 1984 - 2000 Prolog Development Center A/S

 FileName:       SPLIT.PRO
 Purpose:        Split window object. Top level. Module for Split window object.
 Written by:     Andrey Skobelev
 Version:	 1.0
 Build:		007.990304
 Tested with:   Visual Prolog v.5.1 build 563
 Comments:        
******************************************************************************/
%*********************************************************************
% ===================== Common utilities =============================
%*********************************************************************
predicates
    integer /* MinNumber*/ split_max(
        integer Number1,
        integer Number2)
    - procedure (i,i)
clauses
    split_max(N1,N2,N1):-
        N1 > N2,
        !.
    split_max(_,N2,N2).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Internal database.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
database - split_db
    split_Style_db(window SplitWin, split_style)
    split_Bar2dColor_db(window SplitWin, color Color)
    split_SplitEventsCallback_db(window SplitWin, split_events_cb EvetsCallback)
    split_SplitWinEhandler_db(
        window SplitWin,
        ehandler SplitWinEhandler)

%====================================================================
% Internal database support functions.
%====================================================================
%********************************************************************
% Database clear
%********************************************************************
predicates
    split_ClearDB(
        window SplitWin)
    - procedure (i)

clauses
    split_ClearDB(SplitWin):-
        retractall(split_Style_db(SplitWin, _)),
        retractall(split_Bar2dColor_db(SplitWin, _)),
        retractall(split_SplitWinEhandler_db(SplitWin, _)),
        retractall(split_SplitEventsCallback_db(SplitWin, _)).


%********************************************************************
% Check split window.
%********************************************************************
predicates
    split_IsSplitWin(
        window SplitWin)
    - determ (i)

clauses
    split_IsSplitWin(SplitWin):-
        split_Style_db(SplitWin, _),
        !.

%********************************************************************
% Get/Set Style 3D/2D from/to database
%********************************************************************
predicates
    split_style split_GetBarStyle(
        window SplitWin)
    - procedure (i)

clauses
    split_GetBarStyle(SplitWin, Style):-
        split_Style_db(SplitWin, Style),
        !.
    split_GetBarStyle(_, _):-
        errorexit(split_internal_error).

predicates
    split_SetBarStyle(
        window SplitWin, 
        split_style Style)
    - procedure (i, i)

clauses
    split_SetBarStyle(SplitWin, Style):-
        retractall(split_Style_db(SplitWin, _)),
        assert(split_Style_db(SplitWin, Style)).

%********************************************************************
% Set/Get 2D Resize bar color from/to database
%********************************************************************
predicates
    split_SetColor(
        window SplitWin,
        color Color)
    - procedure (i, i)

clauses
    split_SetColor(SplitWin, Color):-
        retractall(split_Bar2dColor_db(SplitWin,_)),
        assert(split_Bar2dColor_db(SplitWin, Color)).

predicates
    color split_GetColor(
        window SplitWin)
    - procedure (i)

clauses
    split_GetColor(SplitWin, Color):-
        split_Bar2dColor_db(SplitWin, Color),
        !.
    split_GetColor(_, _):-
        errorexit(split_internal_error).

%********************************************************************
% Get/Store application event handler from/to database
%********************************************************************
predicates
    ehandler split_GetApplicationEventHandler(
        window SplitWin)
    - procedure (i)

clauses
    split_GetApplicationEventHandler(SplitWin, SplitWinEhandler):-
        split_SplitWinEhandler_db(SplitWin,SplitWinEhandler),
        !.
    split_GetApplicationEventHandler(_, _):-
        errorexit(split_internal_error).

predicates
    split_StoreApplicationEventHandler(
        window SplitWin, 
        ehandler SplitWinEhandler)
    - procedure (i, i)

clauses
    split_StoreApplicationEventHandler(SplitWin, SplitWinEhandler):-
        assert(split_SplitWinEhandler_db(SplitWin, SplitWinEhandler)).


%********************************************************************
% Get events callback from database
%********************************************************************
predicates
    split_events_cb split_GetEvetsCallback(
        window SplitWin)
    - procedure (i)

clauses
    split_GetEvetsCallback(SplitWin, EvetsCallback):-
        split_SplitEventsCallback_db(SplitWin, EvetsCallback),
        !.
    split_GetEvetsCallback(_, _):-
        errorexit(split_internal_error).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input arguments validation functions.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
predicates
    split_ValidateSplitWin(window SplitWin) - procedure (i)

clauses
    split_ValidateSplitWin(SplitWin):-
        split_IsSplitWin(SplitWin),
        !.
    split_ValidateSplitWin(_):-
        errorexit(split_bad_window).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Resize callback function from splitwin level.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
constants
    cursorOutOfBar	= -1	% Input argument value
    movementUnlimited	= -1	% Output argument value
    movementImpossible	=  0	% Output argument value

predicates
    splitwin_resizecb : splitwin_resize_cb

clauses
% Cursor on the cross of bars - cursor_SizeNWSE, movement in
% any direction
    splitwin_resizecb(
            _SplitWin,
            VertResizeBar, HorzResizeBar,
            movementUnlimited, movementUnlimited,
            movementUnlimited, movementUnlimited,
            cursor_SizeNWSE):-
        not(VertResizeBar = cursorOutOfBar),
        not(HorzResizeBar = cursorOutOfBar),
        !.
% Cursor on the horizontal bar - cursor_SizeNS, movement only in
% the vertical direction
    splitwin_resizecb(
            _SplitWin, 
            _VertResizeBar, HorzResizeBar,
            movementImpossible, movementImpossible,
            movementUnlimited, movementUnlimited,
            cursor_SizeNS):-
        not(HorzResizeBar = cursorOutOfBar),
        !.

% Cursor on the vertical bar - cursor_SizeWE, movement only in
% the horizontal direction
    splitwin_resizecb(
            _SplitWin,
            VertResizeBar, _HorzResizeBar,
            movementUnlimited, movementUnlimited,
            movementImpossible, movementImpossible,
            cursor_SizeWE):-
        not(VertResizeBar = cursorOutOfBar).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Update callback function from splitwin level.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
predicates
    splitwin_updatecb : splitwin_update_cb
    split_DrawBars(window SplitWin) - procedure (i)

clauses
    splitwin_updatecb(SplitWin):-
        split_DrawBars(SplitWin).

%====================================================================
% Update callback support functions.
%====================================================================
% Conditional switch for drawing orientation.
domains
    split_bar_orientation = 
        bar_is_horizontal;
        bar_is_vertical

%********************************************************************
% Calculation of border positions for bars (vertical or horizontal).
%********************************************************************
predicates
    ilist /* BarsPosList */ split_GetBarPosList(
        window SplitWin,
        integer BarNumbers,
        split_bar_orientation)
    - procedure (i,i,i)

clauses
    split_GetBarPosList(_, 0, _, []):-!.
    split_GetBarPosList(SplitWin, BarNumber, bar_is_horizontal,
            [Position|RowsPosList]):-
	NewBarNumber = BarNumber - 1,
        splitwin_GetRowBarPos(SplitWin, NewBarNumber, Position),
        RowsPosList = split_GetBarPosList(SplitWin, NewBarNumber,
            bar_is_horizontal).
    split_GetBarPosList(SplitWin, BarNumber, bar_is_vertical,
            [Position|RowsPosList]):-
	NewBarNumber = BarNumber - 1,
        splitwin_GetColumnBarPos(SplitWin, NewBarNumber, Position),
        RowsPosList = split_GetBarPosList(SplitWin, NewBarNumber,
            bar_is_vertical).

%********************************************************************
% Getting colors for drawing 3D borders from Windows system setting.
%********************************************************************
predicates
    split_Get3DBorderColors(
        color	ColorDark,
        color	ColorFace,
        color	ColorShadow,
        color	ColorLight)
    - procedure (o,o,o,o)

clauses
    split_Get3DBorderColors(ColorDark, ColorFace,
            ColorShadow, ColorLight):-
        ColorDark = color_Black,
        ColorFace = vpi_GetAttrVal(attr_color_btnface),
        ColorShadow = vpi_GetAttrVal(attr_color_btnshadow),
        ColorLight = vpi_GetAttrVal(attr_color_window).

%********************************************************************
% Getting color of split bars for 2D or 3D mode.
% For 2D mode use user setting, for 3D mode - Windows default
% color for controls.
%********************************************************************
predicates
    color /* BarColor */ split_GetActualBarColor(
        window SplitWin)
    - procedure (i)

clauses
    split_GetActualBarColor(SplitWin, BarColor):-
        Style = split_GetBarStyle(SplitWin),
        Style = split_style_3D,
        !,
        split_Get3DBorderColors(_, BarColor, _, _).
    split_GetActualBarColor(SplitWin, BarColor):-
        BarColor = split_GetColor(SplitWin).

%********************************************************************
% Getting Thick Divider (for border drawing) of split bars for 2D or 3D mode.
% For 2D mode thickness of border is zero, for 3D mode - 2 pixels.
%********************************************************************
constants
    split_2DThickDivider	= 0
    split_3DThickDivider	= 2

predicates
    integer /* BarThickDivider */ split_GetThickDivider(
        window SplitWin)
    - procedure (i)

clauses
    split_GetThickDivider(SplitWin, split_3DThickDivider):-
        Style = split_GetBarStyle(SplitWin),
        Style = split_style_3D,
        !.
    split_GetThickDivider(_, split_2DThickDivider).

%********************************************************************
% Drawing plain split bars. (that is enough for 2D mode).
%********************************************************************
predicates
    split_DrawSplitBars(
        window	SplitWin,
        ilist	BarsPosList,
        integer	BarWidth,
        integer	BarThickDivider,
        rct	LimitsRect,
        split_bar_orientation)
    - procedure (i,i,i,i,i,i)

clauses
    split_DrawSplitBars(_, [], _, _, _, _):-!.
    split_DrawSplitBars(SplitWin, [BarsPos|Rest],
            BarWidth, BarThickDivider, rct(L,T,R,B), bar_is_horizontal):-
        BarTop = BarsPos + BarThickDivider,
        BarBottom = BarsPos + BarWidth - BarThickDivider,
        BarLeft = L - BarThickDivider,
        BarRight = R + BarThickDivider,
        draw_Rect(SplitWin, rct(BarLeft,BarTop,BarRight,BarBottom)),
        split_DrawSplitBars(SplitWin, Rest, BarWidth, BarThickDivider,
            rct(L,T,R,B), bar_is_horizontal).
    split_DrawSplitBars(SplitWin, [BarsPos|Rest], BarWidth,
            BarThickDivider, rct(L,T,R,B), bar_is_vertical):-
        BarLeft = BarsPos + BarThickDivider,
        BarRight = BarsPos + BarWidth - BarThickDivider,
        BarTop = T - BarThickDivider,
        BarBottom = B + BarThickDivider,
        draw_Rect(SplitWin, rct(BarLeft,BarTop,BarRight,BarBottom)),
        split_DrawSplitBars(SplitWin, Rest, BarWidth, BarThickDivider, 
            rct(L,T,R,B), bar_is_vertical).

%********************************************************************
% Drawing plain margins around split window.
%********************************************************************
predicates
    split_DrawMargins(
        window	SplitWin,
        integer	BarThickDivider,
        rct	OuterRect,
        rct	InnerRect)
    - procedure (i,i,i,i)

clauses

    split_DrawMargins(SplitWin, BarThickDivider,
            rct(OutL,OutT,OutR,OutB), rct(InnLX,InnTX,InnRX,InnBX)):-
        InnL = InnLX - BarThickDivider,
        InnT = InnTX - BarThickDivider,
        InnR = InnRX + BarThickDivider,
        InnB = InnBX + BarThickDivider,
        draw_Rect(SplitWin, rct(OutL,OutT,InnR,InnT)),
        draw_Rect(SplitWin, rct(InnR,OutT,OutR,InnB)),
        draw_Rect(SplitWin, rct(InnL,InnB,OutR,OutB)),
        draw_Rect(SplitWin, rct(OutL,InnT,InnL,OutB)).

%********************************************************************
% Calculation of vertical or horizontal border line positions 
% for each pane.
%********************************************************************
predicates
    ilist /* BarBordersList */ split_GetPanesBorderList(
        integer	StartPoint,
        ilist	BarsPosList,
        integer	BarWidth)
    - procedure (i,i,i)

clauses
    split_GetPanesBorderList(StartPoint, [], _, [StartPoint]):-!.
    split_GetPanesBorderList(StartPoint, [FirstPos|Rest],
            BarWidth, [SecondPos,FirstPos|BarBordersList]):-
        SecondPos = FirstPos + BarWidth,
        BarBordersList = split_GetPanesBorderList(StartPoint, Rest, BarWidth).

%********************************************************************
% Drawing vertex of rectangle with specified color.
%********************************************************************
predicates
    split_DrawVertex(
        window	SplitWin,
        color	Color,
        pnt	Point1,
        pnt	Point2,
        pnt	Point3)
    - procedure (i,i,i,i,i)

clauses
    split_DrawVertex(SplitWin,Color,Point1,Point2,Point3):-
        win_SetPen(SplitWin,pen(1,ps_Solid,Color)),
        draw_Line(SplitWin,Point1,Point2),
        draw_Line(SplitWin,Point2,Point3).

%********************************************************************
% Drawing rectangle with 3D borders.
%********************************************************************
predicates
    split_Draw3DRect(
        window	SplitWin,
        rct	Rect,
        color   ColorDark,
        color	ColorFace,
        color	ColorShadow,
        color	ColorLight)
    - procedure (i,i,i,i,i,i)

clauses
    split_Draw3DRect(SplitWin, rct(L,T,R1,B1),
            ColorDark, ColorFace, ColorShadow, ColorLight):-
        % Adjusted right
        AR = split_max(L,R1),
        % Adjusted bottom
        AB = split_max(T,B1),
        L1 = L - 1,
        T1 = T - 1,
        split_DrawVertex(SplitWin,ColorDark,
            pnt(L1,AB),pnt(L1,T1),pnt(AR,T1)),
        split_DrawVertex(SplitWin,ColorFace,
            pnt(AR,T1),pnt(AR,AB),pnt(L1,AB)),
        L2 = L1 - 1,
        T2 = T1 - 1,
        R2 = AR + 1,
        B2 = AB + 1,
        split_DrawVertex(SplitWin,ColorShadow,
            pnt(L2,B2),pnt(L2,T2),pnt(R2,T2)),
        split_DrawVertex(SplitWin,ColorLight,
            pnt(R2,T2),pnt(R2,B2),pnt(L2,B2)).

%********************************************************************
% Drawing 3D borders around each pane in one row of panes.
%********************************************************************
predicates
    split_DrawPanes3DBorderByRow(
        window	SplitWin,
        integer	Top,
        integer	Bottom,
        ilist	VertList,
        color   ColorDark,
        color	ColorFace,
        color	ColorShadow,
        color	ColorLight)
    - procedure (i,i,i,i,i,i,i,i)

clauses
    split_DrawPanes3DBorderByRow(_, _, _, [], _, _, _, _):-!.
    split_DrawPanes3DBorderByRow(SplitWin, Top, Bottom, [Right,Left|VertList],
            ColorDark, ColorFace, ColorShadow, ColorLight):-
        !,
        split_Draw3DRect(SplitWin, rct(Left,Top,Right,Bottom),
            ColorDark, ColorFace, ColorShadow, ColorLight),
        split_DrawPanes3DBorderByRow(SplitWin, Top, Bottom, VertList,
            ColorDark, ColorFace, ColorShadow, ColorLight).
    split_DrawPanes3DBorderByRow(_, _, _, _, _, _, _, _):-
        errorexit(split_internal_error).

%********************************************************************
% Drawing 3D borders around each pane in the split window.
%********************************************************************
predicates
    split_DrawPanes3DBorder(
        window	SplitWin,
        ilist	HorzList,
        ilist	VertList,
        color   ColorDark,
        color	ColorFace,
        color	ColorShadow,
        color	ColorLight)
    - procedure (i,i,i,i,i,i,i)

clauses
    split_DrawPanes3DBorder(_, [], _, _, _, _, _):-!.
    split_DrawPanes3DBorder(SplitWin, [Bottom,Top|HorzList], VertList,
            ColorDark, ColorFace, ColorShadow, ColorLight):-
        !,
        split_DrawPanes3DBorderByRow(SplitWin, Top, Bottom, VertList,
            ColorDark, ColorFace, ColorShadow, ColorLight),
        split_DrawPanes3DBorder(SplitWin, HorzList, VertList,
            ColorDark, ColorFace, ColorShadow, ColorLight).
    split_DrawPanes3DBorder(_, _, _, _, _, _, _):-
        errorexit(split_internal_error).

%********************************************************************
% Simulation of 3D effect, if style of split window
% is 'split_style_3D'
%********************************************************************
predicates
    split_Draw3DEffect(
        window	SplitWin,
        ilist	RowsPosList,
        ilist	ColumnsPosList,
        integer BarWidth,
        rct	InnerRect)
    - procedure (i,i,i,i,i)

clauses
    split_Draw3DEffect(SplitWin, RowsPosList, ColumnsPosList,
            BarWidth, rct(L,T,R,B)):-
        Style = split_GetBarStyle(SplitWin),
        Style = split_style_3D,
        !,
        HorzListX = split_GetPanesBorderList(
            T, RowsPosList, BarWidth),
        HorzList = [B|HorzListX],
        VertListX = split_GetPanesBorderList(
            L, ColumnsPosList, BarWidth),
        VertList = [R|VertListX],
        split_Get3DBorderColors(ColorDark, ColorFace,
            ColorShadow, ColorLight),
        split_DrawPanes3DBorder(SplitWin, HorzList, VertList,
            ColorDark, ColorFace, ColorShadow, ColorLight).
    split_Draw3DEffect(_, _, _, _, _).

%********************************************************************
% Drawing bars around panes and margins around split window.
% Main drawing predicate.
%********************************************************************
clauses
    split_DrawBars(SplitWin):-
        ClientRct = win_GetClientRect(SplitWin),
        ClientRct = rct(L,T,R,B),
        splitwin_GetMarginWidth(SplitWin, MarginWidth),
        TM = T + MarginWidth,
        LM = L + MarginWidth,
        RM = R - MarginWidth,
        BM = B - MarginWidth,
        splitwin_GetColumnsRows(SplitWin, Columns, Rows),
        splitwin_GetResizeBarWidth(SplitWin, BarWidth),
        LastRow = Rows - 1,
        RowsPosList = split_GetBarPosList(SplitWin, LastRow,
            bar_is_horizontal),
        LastColumn = Columns - 1,
        ColumnsPosList = split_GetBarPosList(SplitWin, LastColumn,
            bar_is_vertical),
        BarColor = split_GetActualBarColor(SplitWin),
        BarThickDivider = split_GetThickDivider(SplitWin),
        LM1 = LM - 2,
        TM1 = TM - 2,
        RM1 = RM + 2,
        BM1 = BM + 2,
        win_SetClip(SplitWin,rct(LM1,TM1,RM1,BM1)),
	win_SetPen(SplitWin, pen(0, ps_Solid, BarColor)),
	win_SetBrush(SplitWin, brush(pat_Solid, BarColor)),
        split_DrawSplitBars(SplitWin, RowsPosList, BarWidth, BarThickDivider,
            rct(LM,TM,RM,BM), bar_is_horizontal),
        split_DrawSplitBars(SplitWin, ColumnsPosList, BarWidth,
            BarThickDivider, rct(LM,TM,RM,BM), bar_is_vertical),
        split_Get3DBorderColors(_, MarginColor, _, _),
        split_Draw3DEffect(SplitWin, RowsPosList, ColumnsPosList,
            BarWidth, rct(LM,TM,RM,BM)),
	win_SetPen(SplitWin, pen(0, ps_Solid, MarginColor)),
	win_SetBrush(SplitWin, brush(pat_Solid, MarginColor)),
        win_SetClip(SplitWin,ClientRct),
        split_DrawMargins(SplitWin, BarThickDivider, 
            ClientRct, rct(LM,TM,RM,BM)).

%********************************************************************
% Event handler support functions.
%********************************************************************
predicates
    split_OnDestroy(window SplitWin) - procedure (i)

clauses
    split_OnDestroy(SplitWin):-
        split_ClearDB(SplitWin).

%********************************************************************
% Send Events to External (application) ehandler
% Is used if split_CreateInWindow predicate was used for creation
%********************************************************************
predicates
    long /*RetCode*/ split_SendEvents(
        window SplitWin,
        event Event)
    - determ (i, i)

clauses
    split_SendEvents(SplitWin, Events, Ret):-
        ApplicationEhandler = split_GetApplicationEventHandler(SplitWin),
        Ret = ApplicationEhandler(SplitWin, Events).

%********************************************************************
% Event handling from bottom level.
%
% Event handler is used if      split_CreateInWindow    predicate was
% used for creation
%
%********************************************************************
predicates
    split_split_eh : EHANDLER

clauses

% If split_CreateInWindow predicate was used for creation
% Send Events to External (application) ehandler
% fail: if Event handler fail,
% also always fails on e_Destroy event.
    split_split_eh(SplitWin, Event, Ret):-
        Ret = split_SendEvents(SplitWin, Event),
        not(Event = e_Destroy),
        !.

% Handle e_Destroy() from bottom level
    split_split_eh(SplitWin, e_Destroy(), 0):-
        split_OnDestroy(SplitWin),
        fail.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Send Events to application by split event callback.
% Is used if split_Create predicate was used for creation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
predicates
    long /*RetCode*/ split_SendEventsByCallback(
        window SplitWin, 
        event Event)
    - determ (i, i)
clauses

    split_SendEventsByCallback(SplitWin, Events, RetCode):-
        EvetsCallback = split_GetEvetsCallback(SplitWin),
        EvetsCallback(SplitWin, Events, RetCode).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Events callback handling from bottom level.
%
% *** Is used if   split_Create   predicate was used for creation **
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
predicates
    splitwin_eventscb : splitwin_events_cb
clauses

% Handle e_Create from bottom level
% if split_Create predicate was used for creation
   splitwin_eventscb(SplitWin, e_Create(_), 0):-
        NullWin = cast(window, 0),
        retract(split_SplitEventsCallback_db(NullWin, SplitEventsCallback)),
        assert(split_SplitEventsCallback_db(SplitWin, SplitEventsCallback)),
        split_SetBarStyle(SplitWin, split_style_3D),
        BarColor = vpi_GetAttrVal(attr_color_btnface),
        split_SetColor(SplitWin, BarColor),
        fail.

% Send Events by callback to application
% fail: if callback fail,
% also always fails on e_Destroy event.
   splitwin_eventscb(SplitWin, Event, RetCode):-
        RetCode = split_SendEventsByCallback(SplitWin, Event),
        not(Event = e_Destroy),
        !.

% Handle e_Destroy from bottom level
   splitwin_eventscb(SplitWin, e_Destroy(), 0):-
        split_OnDestroy(SplitWin),
        fail.
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GLOBAL PREDICATES.
% See 'split.pre' file for details.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clauses
    split_Create(WinType, Rectangle, Title, Menu, ParentWindow,
            Flags, SplitEventsCallback, Columns, Rows, SplitWin):-
        NullWin = cast(window, 0),
        assert(split_SplitEventsCallback_db(NullWin, SplitEventsCallback)),
        SplitWin = splitwin_Create(WinType, Rectangle, Title, Menu,
            ParentWindow, Flags,
            splitwin_resizecb, splitwin_updatecb, splitwin_eventscb,
            Columns, Rows).

    split_CreateInWindow(SplitWin, Columns, Rows):-
        % Get application handler
        Ehandler = win_GetHandler(SplitWin),
        % Store application handler for sending events
        % to application
        split_StoreApplicationEventHandler(SplitWin, Ehandler),
        % Set top level handler
        win_SetHandler(SplitWin, split_split_eh),
        splitwin_CreateInWindow(SplitWin,
            splitwin_resizecb, splitwin_updatecb,
            Columns, Rows),
        split_SetBarStyle(SplitWin, split_style_3D),
        BarColor = vpi_GetAttrVal(attr_color_btnface),
        split_SetColor(SplitWin, BarColor).

    split_Show(SplitWin):-
        splitwin_Show(SplitWin).

    split_SetPane(SplitWin, Column, Row, PaneWin, OldWin):-
        OldWin = splitwin_SetPane(SplitWin, Column, Row, PaneWin).

    split_GetPane(SplitWin, Column, Row, PaneWin):-
        PaneWin = splitwin_GetPane(SplitWin, Column, Row).

    split_GetPaneCoordinate(SplitWin, PaneWin, Pnt):-
        Pnt = splitwin_GetPaneCoordinate(SplitWin, PaneWin).

    split_SetStyle(SplitWin, Style):-
ifdef split_argumentValidation
        split_ValidateSplitWin(SplitWin),
enddef
        split_SetBarStyle(SplitWin, Style),
        split_DrawBars(SplitWin).

    split_GetStyle(SplitWin, Style):-
ifdef split_argumentValidation
        split_ValidateSplitWin(SplitWin),
enddef
        Style = split_GetBarStyle(SplitWin).

    split_SetMarginWidth(SplitWin, MarginWidth):-
        splitwin_SetMarginWidth(SplitWin, MarginWidth).

    split_GetMarginWidth(SplitWin, MarginWidth):-
        splitwin_GetMarginWidth(SplitWin, MarginWidth).

    split_GetResizeBarWidth(SplitWin, ResizeBarWidth):-
        splitwin_GetResizeBarWidth(SplitWin, ResizeBarWidth).

    split_SetResizeBarWidth(SplitWin, ResizeBarWidth):-
        splitwin_SetResizeBarWidth(SplitWin, ResizeBarWidth).

    split_GetResizeBarColor(SplitWin, Color):-
ifdef split_argumentValidation
        split_ValidateSplitWin(SplitWin),
enddef
        Color = split_GetColor(SplitWin).

    split_SetResizeBarColor(SplitWin, Color):-
ifdef split_argumentValidation
        split_ValidateSplitWin(SplitWin),
enddef
        split_SetColor(SplitWin, Color),
        split_DrawBars(SplitWin).

    split_ClearPane(SplitWin, Column, Row, PaneWin):-
        PaneWin = splitwin_ClearPane(SplitWin, Column, Row).

    split_DeleteColumn(SplitWin, Column):-
        splitwin_DeleteColumn(SplitWin, Column).

    split_DeleteRow(SplitWin, Row):-
        splitwin_DeleteRow(SplitWin, Row).

    split_GetColumnWidth(SplitWin, Column, Width):-
        splitwin_GetColumnWidth(SplitWin, Column, Width).

    split_SetColumnWidth(SplitWin, Column, Width):-
        splitwin_SetColumnWidth(SplitWin, Column, Width).
  
    split_GetRowHeight(SplitWin, Row, Height):-
        splitwin_GetRowHeight(SplitWin, Row, Height).

    split_SetRowHeight(SplitWin, Row, Hight):-
        splitwin_SetRowHeight(SplitWin, Row, Hight).

    split_InsertColumnAt(SplitWin, Column, Width):-
        splitwin_InsertColumnAt(SplitWin, Column, Width).

    split_InsertRowAt(SplitWin, Row, Height):-
        splitwin_InsertRowAt(SplitWin, Row, Height).
