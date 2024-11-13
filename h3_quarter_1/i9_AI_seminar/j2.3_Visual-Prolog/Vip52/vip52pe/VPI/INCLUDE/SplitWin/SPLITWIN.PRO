/******************************************************************************

                Copyright (c) 1984 - 2000 Prolog Development Center A/S

 FileName:       SPLITWIN.PRO
 Purpose:        Split window object. Bottom level. Module for Split window object.
 Written by:     Andrey Skobelev
 Version:	1.0
 Build:		007.990304
 Tested with:   Visual Prolog v.5.1 build 563
 Comments:        
******************************************************************************/

%******************************************************************************
% Layout constants
%******************************************************************************
constants
% The default Margin Width can be changed by 
% splitwin_SetMarginWidth global predicate
    splitwin_DefaultMarginWidth = 1

% Minimally allowable Margin Width
    splitwin_MinMarginWidth = 0

% The default Resize Bar Width can be changed by 
% splitwin_SetResizeBarWidth global predicate
    splitwin_DefaultBarWidth = 6

% Minimally allowable Resize Bar Width
    splitwin_MinBarWidth = 2

% Minimally allowable Number of Columns or Rows
    splitwin_MinColumnsRows = 1

% Drag pointer - line(s) to be displayed when user drags
% resize bar by means of a mouse
    splitwin_DragPointerWidth = 1

%*********************************************************************
% ===================== Common utilities =============================
%*********************************************************************
domains
    splitwin_wintypes = wintype*

predicates
    splitwin_member(wsflag Flag, wsflags Flags) - determ (i,i)
    splitwin_member(wintype Wintype, splitwin_wintypes Wintypes) - determ (i,i)
clauses

    splitwin_member(S, [S|_]):-!.
    splitwin_member(S, [_|L]):-
        splitwin_member(S, L).

predicates
    integer /* MinNumber*/ splitwin_min(
        integer Number1,
        integer Number2)
    - procedure (i,i)
clauses
    splitwin_min(N1,N2,N1):-
        N1 < N2,
        !.
    splitwin_min(_,N2,N2).

predicates
    integer /* MinNumber*/ splitwin_max(
        integer Number1,
        integer Number2)
    - procedure (i,i)
clauses
    splitwin_max(N1,N2,N1):-
        N1 > N2,
        !.
    splitwin_max(_,N2,N2).

%*******************************************************************
% ================= Access to metrics information ==============
%*******************************************************************
database - splitwin_MarginAndResize_db
    splitwin_Params_db(
        window SplitWin, 
        integer MarginWidth, 
        integer BarWidth)

predicates
    splitwin_GetMargin(
        window SplitWin, 
        integer MarginWidth)
    - procedure (i, o)
clauses

    splitwin_GetMargin(SplitWin, MarginWidth):-
        splitwin_Params_db(SplitWin, MarginWidth, _), 
        !.
    splitwin_GetMargin(_, _):-
        errorexit(splitwin_InternalError).

predicates
    splitwin_ChangeMarginWidth(
        window SplitWin, 
        integer MarginWidth)
    - procedure (i, i)
clauses

    splitwin_ChangeMarginWidth(SplitWin, MarginWidth):-
        retract(splitwin_Params_db(SplitWin, _, ResizeWidth)), 
        !, 
        assert(splitwin_Params_db(SplitWin, MarginWidth, ResizeWidth)).
    splitwin_ChangeMarginWidth(_, _):-
        errorexit(splitwin_InternalError).

predicates
    splitwin_GetBarWidth(
        window SplitWin, 
        integer BarWidth)
    - procedure (i, o)
clauses

    splitwin_GetBarWidth(SplitWin, BarWidth):-
        splitwin_Params_db(SplitWin, _, BarWidth),
        !.
    splitwin_GetBarWidth(_, _):-
        errorexit(splitwin_InternalError).

predicates
    splitwin_ChangeBarWidth(
	window SplitWin, 
	integer BarWidth)
    - procedure (i, i)
clauses

    splitwin_ChangeBarWidth(SplitWin, BarWidth):-
        retract(splitwin_Params_db(SplitWin, Margin, _)), 
        !, 
        assert(splitwin_Params_db(SplitWin, Margin, BarWidth)).
    splitwin_ChangeBarWidth(_, _):-
        errorexit(splitwin_InternalError).

%*******************************************************************
%
% ========== Access to Initialization information ==============
%
%*******************************************************************
database - splitwin_Init_db
    splitwin_InitData_db(
        window SplitWin, % Split Window 
        splitwin_resize_cb ResizeCallback,  % See splitwin.dom 
        splitwin_update_cb UpdateCallback,  % See splitwin.dom 
        integer Columns, % Max number of columns
        integer Rows)    % Max number of rows
    splitwin_EventsCallback_db(
        window SplitWin, % Split Window
        splitwin_events_cb EvetsCallback)   % See splitwin.dom 

%*********************************************************************
% To check up: whether the window is initialized 
%*********************************************************************
predicates
    splitwin_IsSplitInitialized(
        window SplitWin)
    - determ (i)
clauses

    splitwin_IsSplitInitialized(SplitWin):-
        splitwin_InitData_db(SplitWin, _, _, _, _),
        !.

%********************************************************************
% Get Resize and Update callback functions
%********************************************************************
predicates
    splitwin_GetCallbacks(
        window SplitWin, 
        splitwin_resize_cb ResizeCallback, 
        splitwin_update_cb UpdateCallback)
    - procedure (i, o, o)
clauses

    splitwin_GetCallbacks(SplitWin, ResizeCallback, UpdateCallback):-
        splitwin_InitData_db(SplitWin, ResizeCallback, UpdateCallback, _, _), 
        !.
    splitwin_GetCallbacks(_, _, _):-
        errorexit(splitwin_InvalidSplitWindow).

%*********************************************************************
% Get number of - Colsumns or Rows 
%*********************************************************************
predicates
    splitwin_GetColumnsOrRows(
        window SplitWin, 
        splitwin_direction Direction, 
        integer ColumnsRows)
    - procedure (i, i, o)
clauses

    splitwin_GetColumnsOrRows(SplitWin, horizontal, Columns):-
        splitwin_InitData_db(SplitWin, _, _, Columns, _Rows),
        !.
    splitwin_GetColumnsOrRows(SplitWin, vertical, Rows):-
        splitwin_InitData_db(SplitWin, _, _, _Columns, Rows),
        !.
    splitwin_GetColumnsOrRows(_, _, _):-
        errorexit(splitwin_InvalidSplitWindow).

predicates
    splitwin_GetColumnsAndRows(
        window SplitWin,
        integer Columns,
        integer Rows)
    - procedure (i, o, o)
clauses

    splitwin_GetColumnsAndRows(SplitWin, Columns, Rows):-
        splitwin_GetColumnsOrRows(SplitWin, horizontal, Columns),
        splitwin_GetColumnsOrRows(SplitWin, vertical, Rows).

predicates
    splitwin_ChangeColumnsOrRows(
        window Win, 
        integer NewPanes, 
        splitwin_direction Direction)
    - procedure (i, i, i)

clauses
    splitwin_ChangeColumnsOrRows(SplitWin, NewColumn, horizontal):-
        retract(splitwin_InitData_db(SplitWin, ResizeCB, UpdateCB, _, R)),
        !, 
        assert(splitwin_InitData_db(SplitWin, ResizeCB, UpdateCB,
              NewColumn, R)).
    splitwin_ChangeColumnsOrRows(SplitWin, NewRows, vertical):-
        retract(splitwin_InitData_db(SplitWin, ResizeCB, UpdateCB, C, _)),
        !, 
        assert(splitwin_InitData_db(SplitWin, ResizeCB, UpdateCB, C, NewRows)).
    splitwin_ChangeColumnsOrRows(_, _, _):-
        errorexit(splitwin_InternalError).

%*********************************************************************
%
% Initialization support predicates.
%
%*********************************************************************
predicates
    splitwin_InitParams(
        window SplitWin,
        splitwin_resize_cb ResizeCallback,
        splitwin_update_cb UpdateCallback,
        splitwin_events_cb EventsCallback,
        integer Columns,
        integer Rows)
    - procedure (i, i, i, i, i, i)

    splitwin_InitParams(
        window SplitWin,
        splitwin_resize_cb ResizeCallback,
        splitwin_update_cb UpdateCallback,
        integer Columns,
        integer Rows)
    - procedure (i, i, i, i, i)

clauses

    splitwin_InitParams(SplitWin, ResizeCallback, UpdateCallback,
            Columns, Rows):- 
        assert(splitwin_InitData_db(SplitWin, ResizeCallback, UpdateCallback,
            Columns, Rows)),
        assert(splitwin_Params_db(SplitWin,
            splitwin_DefaultMarginWidth, splitwin_DefaultBarWidth)).

    splitwin_InitParams(SplitWin, ResizeCallback, UpdateCallback,
            EventsCallback, Columns, Rows):- 
        splitwin_InitParams(SplitWin, ResizeCallback, UpdateCallback,
            Columns, Rows),
        assert(splitwin_EventsCallback_db(SplitWin, EventsCallback)).

%********************************************************************
%
% ================== Access to the Window information ===============
%
%********************************************************************

%********************************************************************
% Get the window's horizontal or vertical size 
%********************************************************************
predicates
    splitwin_GetWinSize(
        window SplitWin, 
        splitwin_direction Direction, 
        integer WinSize)
    - procedure (i, i, o)
clauses

    splitwin_GetWinSize(SplitWin, horizontal, MaxX):-
        SplitWinRct = win_GetClientRect(SplitWin),
        SplitWinRct = rct(_, _, MaxX, _).
    splitwin_GetWinSize(SplitWin, vertical, MaxY):-
        SplitWinRct = win_GetClientRect(SplitWin),
        SplitWinRct = rct(_, _, _, MaxY).

%*******************************************************************
%
%================= Access to the Resize Bar Information ============
%
%*******************************************************************
database - splitwin_BarInformation_db
    splitwin_BarsPos_db(
        window SplitWin, % Split window
        integer Bar,     % Resize bar index (from 0 to Columns/Rows - 2)
        integer Pos,     % Resize bar position
        splitwin_direction Direction) % by horizontal or vertical direction

predicates
    splitwin_ChangeBarIndex(
        window SplitWin, 
        integer OldBarIndex, 
        integer NewBarIndex, 
        splitwin_direction Direction)
    - procedure (i, i, i, i)
clauses

    splitwin_ChangeBarIndex(SplitWin, NewBarIndex, OldBarIndex, Direction):-
        retract(splitwin_BarsPos_db(SplitWin, OldBarIndex, Pos, Direction)), 
        !, 
        assert(splitwin_BarsPos_db(SplitWin, NewBarIndex, Pos, Direction)).
    splitwin_ChangeBarIndex(_, _, _, _):-
        errorexit(splitwin_InternalError).

predicates
    splitwin_ChangeBarPos(
        window SplitWin, 
        integer Bar, 
        splitwin_direction Direction, 
        integer NewPos)
    - procedure (i, i, i, i)
clauses

    splitwin_ChangeBarPos(SplitWin, Bar, Direction, NewPos):-
        retract(splitwin_BarsPos_db(SplitWin, Bar, _, Direction)), 
        !, 
        asserta(splitwin_BarsPos_db(SplitWin, Bar, NewPos, Direction)).
    splitwin_ChangeBarPos(_, _, _, _):-
        errorexit(splitwin_InternalError).

predicates
    splitwin_AssertBar(
        window SplitWin, 
        integer Bar, 
        splitwin_direction Direction, 
        integer NewPos)
    - procedure (i, i, i, i)
clauses

    splitwin_AssertBar(SplitWin, Bar, Direction, Pos):-
        asserta(splitwin_BarsPos_db(SplitWin, Bar, Pos, Direction)).

predicates
    splitwin_GetBarPos(
        window SplitWin, 
        integer Bar, 
        splitwin_direction Direction, 
        integer Pos)
    - procedure (i, i, i, o)
clauses

    splitwin_GetBarPos(SplitWin, Bar, Direction, Pos):-
        splitwin_BarsPos_db(SplitWin, Bar, Pos, Direction), 
        !.
    splitwin_GetBarPos(_, _, _, _):-
        errorexit(splitwin_InternalError).

predicates
    splitwin_DeleteBar(
        window SplitWin, 
        integer Bar, 
        splitwin_direction Direction)
    - procedure (i, i, i)
clauses

    splitwin_DeleteBar(SplitWin, Bar, Direction):-
        retract(splitwin_BarsPos_db(SplitWin, Bar, _, Direction)),
        !.
    splitwin_DeleteBar(_, _, _):-
        errorexit(splitwin_InternalError).

%*********************************************************************
%
%=============== Bars initialization =================================
%
%*********************************************************************
%*********************************************************************
% Calculate and set default bar positions. All panes size are equal.
%*********************************************************************
predicates
    splitwin_DisposeDefaultBars(
        window SplitWin, 
        integer Bars, 
        integer PaneWidth, 
        integer StartBarPosition, 
        integer StartBarIndex,
        splitwin_direction Direction, 
        integer BarWidth)
    - procedure (i, i, i, i, i, i, i)

clauses
    splitwin_DisposeDefaultBars(SplitWin, Bars, PaneWidth,
            Pos1, Bar1, Direction, Resize):-
        Bar1 < Bars,
	!, 
        Bar2 = Bar1 + 1,
        BarPos = Pos1 + PaneWidth,
        splitwin_AssertBar(SplitWin, Bar1, Direction, BarPos),
        Pos2 = BarPos + Resize,
        splitwin_DisposeDefaultBars(SplitWin, Bars, PaneWidth, Pos2,
            Bar2, Direction, Resize).
    splitwin_DisposeDefaultBars(_, _, _, _, _, _, _).

%*********************************************************************
% Calculate default Column width (Row hight), 
% create and set bars on default positions
% (in horizontal or vertical direction).
%*********************************************************************
predicates
    splitwin_CreateDefaultBars(
        window SplitWin, 
        integer ColumnsRows, 
        splitwin_direction Direction)
    - procedure (i, i, i)
clauses
    splitwin_CreateDefaultBars(Win, ColumnsRows, Direction):-
        splitwin_GetBarWidth(Win, Resize), 
        splitwin_GetMargin(Win, Margin), 
        splitwin_GetWinSize(Win, Direction, WinSize), 
	Bars = ColumnsRows - 1,
        PanesWidth = WinSize - (Margin * 2 + Resize * Bars),
        PaneWidth = val(INTEGER, PanesWidth / ColumnsRows),
        splitwin_DisposeDefaultBars(Win, Bars, PaneWidth, Margin, 
            0, Direction, Resize).

%*********************************************************************
% Horizontal and vertical bars creation.
%*********************************************************************
predicates
    splitwin_InitBars(
        window SplitWin, 
        integer Columns, 
        integer Rows)
    - procedure (i, i, i)

clauses
    splitwin_InitBars(SplitWin, Columns, Rows):-
        splitwin_CreateDefaultBars(SplitWin, Columns, horizontal), 
        splitwin_CreateDefaultBars(SplitWin, Rows, vertical).

%************************************************************************
%
% Bar handling on changin of window size, resize bar width, marging width
%
%************************************************************************
%********************************************************************
% Get Min and Max legal bar positions
%********************************************************************
predicates
    splitwin_GetRange(
        window SplitWin, 
        integer Bar, 
        integer Width_Height, 
        integer ColumnsRows, 
        integer MaxPosition,
        integer MinPosition)
    - procedure (i, i, i, i, o, o)
clauses

    splitwin_GetRange(SplitWin, Bar, WinSize, ColumnsRows, 
    AdjustedMaxPosition, MinPosition):-
        splitwin_GetMargin(SplitWin, Margin), 
        splitwin_GetBarWidth(SplitWin, Resize), 
        MaxPosition = 
            WinSize - Resize * (ColumnsRows - Bar - 1) - Margin,
        MinPosition = Resize * Bar + Margin,
% If the window is less than the administrative
% space (space occupied by the resize bars and the margins),
% then AdjustedMaxPosition = MinPosition
% otherwise AdjustedMaxPosition = MaxPosition
        AdjustedMaxPosition = splitwin_max(MinPosition, MaxPosition).

%********************************************************************
% Retrieves new legal Resize Bar position after any operation:
% Resize Bar moving, window Size changing, etc.
% The predicate is invariant for horizontal/vertical bars.
%********************************************************************
predicates
    splitwin_GetLegalPos(
        window SplitWin, 
        integer Bar, 
        integer BarPosition,
        integer WinSize, 
        integer ColumnsRows, 
        integer NewBarPosition)
    - procedure (i, i, i, i, i, o)
clauses

    splitwin_GetLegalPos(SplitWin, Bar, Pos, WinSize, ColumnsRows,
            AdjustedPos):-
        splitwin_GetRange(SplitWin, Bar, WinSize, ColumnsRows,
            MaxBarPosition, MinBarPosition),
        Pos1 = splitwin_min(Pos, MaxBarPosition),
        AdjustedPos = splitwin_max(Pos1,MinBarPosition).

%*********************************************************************
% Calculate legal bar position.
%*********************************************************************
predicates
    splitwin_ConvertPosToLegal(
        window SplitWin, 
        integer Bar, 
        integer Pos, 
        splitwin_direction Direction, 
        integer LegalPos)
    - procedure (i, i, i, i, o)
        
clauses
    splitwin_ConvertPosToLegal(SplitWin, Bar, Pos, Direction, LegalPos):-
        splitwin_GetColumnsOrRows(SplitWin, Direction, ColumnsRows),
        splitwin_GetWinSize(SplitWin, Direction, WinSize),
        splitwin_GetLegalPos(SplitWin, Bar, Pos, WinSize, ColumnsRows, LegalPos).

%*********************************************************************
% Reset positions of all bars to legal positions
%*********************************************************************
predicates
    splitwin_ResetBarsPos(window SplitWin) - procedure (i)
clauses

    splitwin_ResetBarsPos(SplitWin):-
        splitwin_BarsPos_db(SplitWin, Bar, Pos, Direction),
            splitwin_ConvertPosToLegal(SplitWin, Bar, Pos, Direction, LegalPos),
            splitwin_ChangeBarPos(SplitWin, Bar, Direction, LegalPos),
        fail.
    splitwin_ResetBarsPos(_).

%*********************************************************************
% Get left and right bar position,
% including left/top extra bar (-1)
% and right/bottom extra bar (N - 1 where N - number of columns/rows).
%*********************************************************************
predicates
    splitwin_GetExtraBarPos(
        window SplitWin, 
        integer NBar, 
        splitwin_direction HorBar, 
        integer StartBarPos, 
        integer EndBarPos)
    - procedure (i, i, i, o, o)
clauses

% Get position of left/top extra resize bar
    splitwin_GetExtraBarPos(SplitWin, -1, _, StartBarPos, EndBarPos):-
        !,
        splitwin_GetMargin(SplitWin, EndBarPos),
        splitwin_GetBarWidth(SplitWin, BarWidth),
        StartBarPos = EndBarPos - BarWidth.
% Get position of right/bottom extra resize bar 
    splitwin_GetExtraBarPos(SplitWin, Bar, Direction, MaxBarPosition, EndBarPos):-
        splitwin_GetColumnsOrRows(SplitWin, Direction, ColumnsRows),
        Bar = ColumnsRows - 1,
        !,
    	splitwin_GetWinSize(SplitWin, Direction, WinSize),
        splitwin_GetBarWidth(SplitWin, BarWidth),
        splitwin_GetRange(SplitWin, Bar, WinSize, ColumnsRows,
            MaxBarPosition, _),
        EndBarPos = MaxBarPosition + BarWidth.
% Now all variants are checked and the rest is genuine resize bar
    splitwin_GetExtraBarPos(SplitWin, Bar, Direction, StartBarPos, EndBarPos):-
        splitwin_GetBarPos(SplitWin, Bar, Direction, StartBarPos), 
        splitwin_GetBarWidth(SplitWin, BarWidth), 
        EndBarPos = StartBarPos + BarWidth.
        
%********************************************************************
%
% ==================== Panes handling ===============================
%
%********************************************************************
%********************************************************************
% Access to Pane's database
%********************************************************************
database - splitwin_Panes_db
    splitwins_Pane_db(
        window SplitWin, % Split window
        window PaneWin,  % Pane window
        integer Column,  % Pane column and row
        integer Row)

predicates
    splitwin_ChangePaneWin(
        window SplitWin, 
        integer Column, 
        integer Row, 
        window PaneWin)
    - procedure (i, i, i, i)
clauses

    splitwin_ChangePaneWin(SplitWin, Column, Row, PaneWin):-
        retract(splitwins_Pane_db(SplitWin, _, Column, Row)), 
        !, 
        assert(splitwins_Pane_db(SplitWin, PaneWin, Column, Row)).
    splitwin_ChangePaneWin(_, _, _, _):-
        errorexit(splitwin_InternalError).

predicates
    splitwin_AssertPane(
        window SplitWin, 
        integer Column, 
        integer Row, 
        window PaneWin)
    - procedure (i, i, i, i)
clauses

    splitwin_AssertPane(SplitWin, Column, Row, PaneWin):-
        assert(splitwins_Pane_db(SplitWin, PaneWin, Column, Row)).

predicates
    splitwin_IsPaneWin(
        window SplitWin, 
        integer Column, 
        integer Row, 
        window PaneWin)
    - determ (i, i, i, o), determ (i, o, o ,i)
clauses

    splitwin_IsPaneWin(SplitWin, Column, Row, PaneWin):-
        splitwins_Pane_db(SplitWin, PaneWin, Column, Row), 
        !.

predicates
    splitwin_DeletePane(
        window SplitWin, 
        integer Column, 
        integer Row)
    - procedure (i, i, i)
clauses

    splitwin_DeletePane(SplitWin, Column, Row):-
        retractAll(splitwins_Pane_db(SplitWin, _, Column, Row)).

%*********************************************************************
% Delete all panes and windows for specified column or row
%*********************************************************************
predicates
    splitwin_DeletePaneWins(
        window SplitWin, 
        integer Column_Row, 
        splitwin_direction Direction)
    - procedure (i, i, i)
clauses

    splitwin_DeletePaneWins(SplitWin, Column, horizontal):-
        retract(splitwins_Pane_db(SplitWin, PaneWin, Column, _Row)), 
            win_Destroy(PaneWin), 
        fail.
    splitwin_DeletePaneWins(SplitWin, Row, vertical):-
        retract(splitwins_Pane_db(SplitWin, PaneWin, _Column, Row)), 
            win_Destroy(PaneWin), 
        fail.
    splitwin_DeletePaneWins(_, _, _).

%*********************************************************************
% Change pane index for all panes in specified column or row
%*********************************************************************
predicates
    splitwin_ChangePanesIndex(
        window SplitWin, 
        integer NewPaneIndex, 
        integer OldPaneIndex, 
        splitwin_direction Direction)
    - procedure (i, i, i, i)
clauses

    splitwin_ChangePanesIndex(Win, NewPaneIndex, OldPaneIndex, horizontal):-
        retract(splitwins_Pane_db(Win, PaneWin, OldPaneIndex, Row)), 
            assert(splitwins_Pane_db(Win, PaneWin, NewPaneIndex, Row)), 
        fail.
    splitwin_ChangePanesIndex(Win, NewPaneIndex, OldPaneIndex, vertical):-
        retract(splitwins_Pane_db(Win, PaneWin, Column, OldPaneIndex)), 
            assert(splitwins_Pane_db(Win, PaneWin, Column, NewPaneIndex)), 
        fail.
    splitwin_ChangePanesIndex(_, _, _, _).

%*********************************************************************
% Gets the pane Width or Height for specified column_row and direction
%*********************************************************************
predicates
    splitwin_GetPaneSize(
        window SplitWin, 
        integer Pane, 
        splitwin_direction Direction, 
        integer PaneSize)
    - procedure (i, i, i, o)
clauses

    splitwin_GetPaneSize(SplitWin, Pane, Direction, PaneSize):-
        Pane1 = Pane - 1, 
        splitwin_GetExtraBarPos(SplitWin, Pane1, Direction, _, BarPos1),
        splitwin_GetExtraBarPos(SplitWin, Pane, Direction, BarPos2, _),
        PaneSize = BarPos2 - BarPos1.

%*********************************************************************
% Get pane rectangle for specified column and row
%*********************************************************************
predicates
    splitwin_GetPaneRct(
        window SplitWin, 
        integer Column, 
        integer Row, 
        rct PaneRct)
    - procedure (i, i, i, o)

clauses
    splitwin_GetPaneRct(SplitWin, Column, Row, Rct):-
        splitwin_GetExtraBarPos(SplitWin, Column, horizontal, X2, _),
        splitwin_GetExtraBarPos(SplitWin, Row, vertical, Y2, _),
        Column1 = Column - 1, Row1 = Row - 1,
        splitwin_GetExtraBarPos(SplitWin, Column1, horizontal, _, X1),
        splitwin_GetExtraBarPos(SplitWin, Row1, vertical, _, Y1),
        Rct = rct(X1, Y1, X2, Y2).


%*********************************************************************
% Moves the panes win to panes rct and redraw bars
%*********************************************************************
predicates
    splitwin_ResetPanesRct(window SplitWin) - procedure (i)

clauses
    splitwin_ResetPanesRct(SplitWin):-
        splitwins_Pane_db(SplitWin, PaneWin, Column, Row),
            splitwin_GetPaneRct(SplitWin, Column, Row, Rct),
            win_Move(PaneWin, Rct),
        fail.
    splitwin_ResetPanesRct(SplitWin):-
        win_SendEvent(SplitWin, e_User(splitwin_Update_id, 0)).


%************************************************************************
%
% Handling other bars when Active bar pushes them.
% (Active bar is the bar, which position is to be changed by 
% user mouse action or by setting new column width / row height)
%
%************************************************************************
%*********************************************************************
% Check whether a bar is to be pushed by another bar (Active bar).
% true - Should be moved.
% fail - The bar has a legal position.
%*********************************************************************
predicates
    splitwin_IsBarPushed(
        integer Bar,
        integer ActiveBar,
        integer BarPos,
        integer NewPos)
    - determ (i, i, i, i)
clauses

% The bar is to be pushed leftward or upward
    splitwin_IsBarPushed(Bar, ActiveBar, BarPos, NewPos):-
        Bar < ActiveBar, 
        BarPos > NewPos,
        !.
% The bar is to be pushed downward or rightward
    splitwin_IsBarPushed(Bar, ActiveBar, BarPos, NewPos):-
        Bar > ActiveBar, 
        BarPos < NewPos.

%*********************************************************************
% The position of the active bar has been changed.
% Push current bar to legal position.
%*********************************************************************
predicates
    splitwin_PushInactiveBar(
        window SplitWin, 
        integer Bar,                  % Current bar index
        splitwin_direction Direction, 
        integer ActiveBar,            % Active bar index
        integer ActiveBarPos)         % Active bar position
    - procedure (i, i, i, i, i)
clauses

% Push the Inactive bar from Active bar
    splitwin_PushInactiveBar(SplitWin, Bar, Direction, ActiveBar, ActiveBarPos):-
        splitwin_GetBarWidth(SplitWin, BarWidth), 
        splitwin_GetBarPos(SplitWin, Bar, Direction, BarPos), 
        NewBarPos = ActiveBarPos + (Bar - ActiveBar) * BarWidth,
        splitwin_IsBarPushed(Bar, ActiveBar, BarPos, NewBarPos),
        !, 
        splitwin_ChangeBarPos(SplitWin, Bar, Direction, NewBarPos).
% The inactive bar has a legal position, do nothing
    splitwin_PushInactiveBar(_, _, _, _, _).

%*********************************************************************
% The position of the active bar has been changed.
% Push other bars to legal positions.
%*********************************************************************
predicates
    splitwin_PushInactiveBars(
        window SplitWin, 
        integer ActiveBar, 
        integer NewActiveBarPos, 
        splitwin_direction HorBar_VertBar)
    - procedure  (i, i, i, i)
clauses

    splitwin_PushInactiveBars(SplitWin, ActiveBar, ActiveBarPos, Direction):-
        splitwin_BarsPos_db(SplitWin, Bar, _BarPos, Direction),
            not(Bar = ActiveBar),
            splitwin_PushInactiveBar(SplitWin, Bar, Direction, ActiveBar,
                ActiveBarPos),
        fail.
    splitwin_PushInactiveBars(_, _, _, _).

%*******************************************************************
% Handle bar position,
% NOREDUCE mode: exits if Bar position is not legal
% REDUCE mode: return LegalPos position
%*******************************************************************
predicates
    splitwin_HandlePos(
        window SplitWin, 
        integer Bar, 
        integer BarPos, 
        integer WinSize, 
        integer ColumnsRows,
        splitwin_PossibleToReduce Reduce,
        integer LegalPos)
    - procedure  (i, i, i, i, i, i, o)
clauses

    splitwin_HandlePos(SplitWin, Bar, BarPos, WinSize, ColumnsRows, noreduce,
            LegalPos):-
        splitwin_GetLegalPos(SplitWin, Bar, BarPos, WinSize, ColumnsRows,
            LegalPos),
        BarPos = LegalPos,
        !.
    splitwin_HandlePos(_, _, _, _, _, noreduce, _):-
        errorexit(splitwin_InvalidColumnRowSize).
    splitwin_HandlePos(SplitWin, Bar, BarPos, WinSize, ColumnsRows, reduce,
            LegalPos):-
        splitwin_GetLegalPos(SplitWin, Bar, BarPos, WinSize, ColumnsRows,
            LegalPos).

%*********************************************************************
% This predicate sets the New Bar position,
% NOREDUCE mode means that illegal bar position causes errorexit.
% (Used with splitwin_SetColumnWidth and splitwin_SetRowHeight
% predicates)
% REDUCE mode means that illegal bar position must be corrected
%(column width (row height) must be reduced to fit in window)
%*********************************************************************
predicates
    splitwin_SetNewBarPos(
        window SplitWin, 
        integer ActiveBar, 
        integer NewBarPos, 
        splitwin_direction Direction, 
        splitwin_PossibleToReduce Reduce)
    - procedure (i, i, i, i, i)
clauses

% ActiveBar = -1 means that there are no VertResizeBar/HorzResizeBar 
    splitwin_SetNewBarPos(_, -1, _, _, _):-!.
    splitwin_SetNewBarPos(SplitWin, ActiveBar, NewBarPos, Direction, Reduce):-
	splitwin_GetColumnsOrRows(SplitWin, Direction, ColumnsRows), 
        splitwin_GetWinSize(SplitWin, Direction, WinSize), 
        splitwin_HandlePos(SplitWin, ActiveBar, NewBarPos, WinSize,
            ColumnsRows, Reduce, LegalPos),
        splitwin_ChangeBarPos(SplitWin, ActiveBar, Direction, LegalPos), 
        splitwin_PushInactiveBars(SplitWin, ActiveBar, LegalPos, Direction),
        splitwin_ResetPanesRct(SplitWin).

%*********************************************************************
% Sets Column Width or Row Height.
% NOREDUCE mode means that illegal Column Width or Row Height
% causes errorexit.
% REDUCE mode means that illegal Column Width or Row Height
% must be replaced with legal.
% (column width (row height) must be reduced to fit in window)
%*********************************************************************
predicates
    splitwin_SetColumnRowSize(
        window SplitWin, 
        integer ColumnRow,   % ColumnRow index
        integer ColumnsRows, % Max Columns or Rows
        splitwin_direction Direction, 
        integer Size,        % Column Width or Row Height
        splitwin_PossibleToReduce PossibleToReduce)
    - procedure (i, i, i, i, i, i)
clauses

% Column/Row is not last Column/Row - moving right bar to the right required,
% bar index = ColumnRow index
    splitwin_SetColumnRowSize(SplitWin, ColumnRow,
            ColumnsRows, Direction, Size, Reduce):-
        ColumnRow < ColumnsRows - 1, 
	!,
        splitwin_GetPaneSize(SplitWin, ColumnRow, Direction, OldSize), 
        splitwin_GetBarPos(SplitWin, ColumnRow, Direction, OldBarPos), 
        NewPos = OldBarPos + Size - OldSize, 
        splitwin_SetNewBarPos(SplitWin, ColumnRow, NewPos, Direction, Reduce).
% Column/Row is last Column/Row - moving left bar to the left required
% bar index = ColumnRow index - 1
    splitwin_SetColumnRowSize(SplitWin, ColumnRow, 
            _, Direction, Size, Reduce):-
	ColumnRow1 = ColumnRow - 1,
        splitwin_GetPaneSize(SplitWin, ColumnRow, Direction, OldSize), 
        splitwin_GetBarPos(SplitWin, ColumnRow1, Direction, OldBarPos), 
        NewPos = OldBarPos - Size + OldSize, 
        splitwin_SetNewBarPos(SplitWin, ColumnRow1, NewPos, Direction, Reduce).

%*********************************************************************
%
% =============== Mouse handling =====================================
%
%*********************************************************************
predicates
    splitwin_GetCoordinateFromPnt(
        pnt Pnt,
        splitwin_direction Direction,
        integer Coordinate)
    - procedure (i, i, o)

clauses
    splitwin_GetCoordinateFromPnt(pnt(X,_), horizontal, X).
    splitwin_GetCoordinateFromPnt(pnt(_,Y), vertical, Y).

%*********************************************************************
% Returns the horizontal or vertical bar index under mouse pointer
% and X or Y displacement of mouse position from bar position.
% Returns  -1 if there is no bar.
%*********************************************************************
predicates
    splitwin_pnt_IsInBar(
        window SplitWin, 
        pnt Point, 
        splitwin_direction Direction, 
        integer Bar,
        integer Displacement)
    - procedure (i, i, i, o, o)

clauses
    splitwin_pnt_IsInBar(Win, Pnt, Direction, Bar, Displacement):-
        splitwin_GetBarWidth(Win, BarWidth), 
        splitwin_BarsPos_db(Win, Bar, Pos, Direction), 
        splitwin_GetCoordinateFromPnt(Pnt, Direction, Coordinate),
        Coordinate >= Pos,
        Coordinate < Pos + BarWidth, 
        !,
        Displacement = Coordinate - Pos.
    splitwin_pnt_IsInBar(_, _, _, -1, 0).

%*********************************************************************
% Returns the horizontal and vertical bar index under mouse pointer
% and displacement of mouse point from bar point.
% Returns  -1 if there is no bar.
%*********************************************************************
predicates
    splitwin_GetMouseBar(
        window SplitWin, 
        pnt Point, 
        integer HorBar, 
        integer VertBar,
        pnt DisplacementPoint)
    - procedure (i, i, o, o, o)

clauses
    splitwin_GetMouseBar(Win, Pnt, HorBar, VertBar, pnt(DX,DY)):-
        splitwin_pnt_IsInBar(Win, Pnt, horizontal, HorBar, DX),
        splitwin_pnt_IsInBar(Win, Pnt, vertical, VertBar, DY).

%*********************************************************************
%
% ====== Resize callback and Drag Pointer handling =================
%
%*********************************************************************
%*********************************************************************
% ======= Access to Resize database
%*********************************************************************
% Database contains DragPointer position, 
% Horizontal and vertical bar index,
% (notes: The cursor can be placed in a cross,  a vertical or a horizontal resize bar.
% if the cursor is inside a horizontal resize bar then VertResizeBar is -1,
% if the cursor is inside a vertical resize bar then HorzResizeBar is -1.)
% the absolute range of legal movements, received as an answer to resize callback,
% displacement from resize bar start position and mouse down point

database - splitwin_Resizedb
    splitwin_Resize_db(
        window SplitWin,
        pnt DragPointerPnt,
        integer HBar, % Horizontal bar index, if index = -1 - No horizontal bar
        integer VBar, % Vertical bar index, if index = -1 - No vertical bar
        integer AbsoluteLeftLimit,  %
        integer AbsoluteRightLimit, %
        integer AbsoluteUpLimit,    % absolute range of legal movements
        integer AbsoluteDownLimit,  %
        pnt Displacement)

%*********************************************************************
% Check whether resize Drag Pointer exists.
% If exist, then returns resize params
% fail: No Drag Pointer
%*********************************************************************
predicates
    splitwin_IsResize(
        window SplitWin, 
        pnt DragPointerPnt, 
        integer HBar, 
        integer VBar, 
        integer AbsoluteLeftLimit,
        integer AbsoluteRightLimit,
        integer AbsoluteUpLimit,
        integer AbsoluteDownLimit,
        pnt Displacement)
    - determ (i, o, o, o, o, o, o, o, o)
clauses

    splitwin_IsResize(SplitWin, Pnt, HBar, VBar, AL, AR, AU, AD, Dis):-
        splitwin_Resize_db(SplitWin, Pnt, HBar, VBar, AL, AR, AU, AD, Dis),
	!.

predicates
    splitwin_DeleteResize(window SplitWin) - procedure (i)
clauses

    splitwin_DeleteResize(SplitWin):-
        retractAll(splitwin_Resize_db(SplitWin, _, _, _, _, _, _, _, _)).

predicates
    splitwin_GetLimitPos(
        splitwin_movedirection Movedirection,
        integer Pos,
        integer RelativeLimit,
        integer AbsolutePosition)
    - procedure (i, i, i, o)

clauses
    splitwin_GetLimitPos(left_up, Pos, RelativeLimit, AbsolutePosition):-
        AbsolutePosition = Pos - RelativeLimit.
    splitwin_GetLimitPos(right_down, Pos, RelativeLimit, AbsolutePosition):-
        AbsolutePosition = Pos + RelativeLimit.

%*********************************************************************
% Convert relative Drag Pointer limit from resize callback 
% to absolute limit position.
% If RelativeLimit = -1 then no limit from callback.
% If Bar = -1 - then no Vertical or Horizontal Bar.
% Returns absolute Drag Pointer limit position 
%*********************************************************************
predicates
    splitwin_RelLimitToAbs(
        window SplitWin, 
        integer Bar,          % Bar Index
        integer RelativeLimit,% rightwards or downwards or leftwards or upwards
                              % limits from resize callback
        splitwin_direction Direction, 
        splitwin_movedirection Movedirection,
        pnt Displacement,
        integer AbsolutePosition)
    - procedure (i, i, i, i, i, i, o)
clauses
  
% There is a Relative Limit (rightwards/downwards/leftwards/upwards) for
% specified Vertical or Horizontal resize bar: returns absolute limit position
    splitwin_RelLimitToAbs(SplitWin, Bar, RelativeLimit,
            Direction, Movedirection, Displacement, AbsolutePos):-
	not(Bar = -1),
        not(RelativeLimit = -1),
        !,
        splitwin_GetCoordinateFromPnt(Displacement, Direction, DXY),
        splitwin_GetBarPos(SplitWin, Bar, Direction, Pos),
        splitwin_GetLimitPos(Movedirection, Pos, RelativeLimit, AbsolutePos1),
        AbsolutePos = AbsolutePos1 + DXY.
% No rightwards or downwards Limit (RelativeLimit = -1): returns WinSize limit position
    splitwin_RelLimitToAbs(SplitWin, _, _,  Direction, right_down, _, WinSize):-
        splitwin_GetWinSize(SplitWin, Direction, WinSize).
% No leftwards or upwards Limit (RelativeLimit = -1): returns 0 limit position
    splitwin_RelLimitToAbs(_, _, _, _, left_up, _, 0).

%*********************************************************************
% Draw Drag Pointer.
% If the Horizontal Bar not equal -1:     draw vertical Drag pointer
% for columns moving.
% If the Vertical Bar not equal -1:       draw horizontal Drag pointer
% for rows moving.
% If the VertBar and HorBar not equal -1: draw cross Drag pointer.
%*********************************************************************
predicates
    splitwin_DrawDragPointer(
        window SplitWin, 
        pnt Pnt, 
        integer HorBar, 
        integer VertBar)
    - procedure (i, i, i, i)
clauses

% Draw vertical Drag pointer.
    splitwin_DrawDragPointer(SplitWin, Pnt, _HBar, VBar):-
        VBar = -1, 
        !, 
        splitwin_GetCoordinateFromPnt(Pnt, horizontal, X),
        splitwin_GetWinSize(SplitWin, vertical, Y2),
        draw_Line(SplitWin, pnt(X, 0), pnt(X, Y2)).
% Draw horizontal Drag pointer.
    splitwin_DrawDragPointer(SplitWin, Pnt, HBar, _VBar):-
        HBar = -1,
        !, 
        splitwin_GetCoordinateFromPnt(Pnt, vertical, Y),
        splitwin_GetWinSize(SplitWin, horizontal, X2),
        draw_Line(SplitWin, pnt(0, Y), pnt(X2, Y)).
% Draw cross Drag pointer.
    splitwin_DrawDragPointer(SplitWin, Pnt, _HBar, _VBar):-
        Pnt = pnt(X, Y), 
        RCT = win_GetClientRect(SplitWin),
        RCT = rct(_, _, X2, Y2), 
        draw_Line(SplitWin, pnt(X, 0), pnt(X, Y2)), 
        draw_Line(SplitWin, pnt(0, Y), pnt(X2, Y)).

%*********************************************************************
% Converts mouse pnt to default legal drag pointer pnt
%*********************************************************************
predicates
    splitwin_ConvPntToLegalDragPnt(
        window SplitWin, 
        integer HBar, 
        integer VBar, 
        pnt MousePnt,
        pnt Displacement,
        pnt LegalPnt)
    - procedure (i, i, i, i, i, o)

clauses
    splitwin_ConvPntToLegalDragPnt(Win, HBar, VBar, Pnt, pnt(DX,DY), LegalPnt):-
	Pnt = pnt(X, Y), % mouse pnt correction on displacement
	X1 = X - DX,
	Y1 = Y - DY,
        splitwin_ConvertPosToLegal(Win, HBar, X1, horizontal, LegalX),
        splitwin_ConvertPosToLegal(Win, VBar, Y1, vertical, LegalY),
        LegalX1 = LegalX + DX,
        LegalY1 = LegalY + DY, % Legal pnt correction on displacement
	LegalPnt = pnt(LegalX1, LegalY1).

%*********************************************************************
% Handle mouse down point.
% Handle Resize callback answer on mouse down -
% converts relative limit (rightwards/downwards/leftwards/upwards)
% from resize callback to absolute limit positions and stores positions.
% Returns: horizontal and vertical bar index under mouse point.
%*********************************************************************
predicates
    splitwin_HandleMouseDownPoint(
        window SplitWin,
        pnt MousePnt,
        integer HBar,
        integer VBar)
    - determ (i, i, o, o)

clauses
    splitwin_HandleMouseDownPoint(SplitWin, Pnt, HBar, VBar):-
        splitwin_GetMouseBar(SplitWin, Pnt, HBar, VBar, Displacement),
        splitwin_GetCallbacks(SplitWin, ResizeCallback, _),
        ResizeCallback(SplitWin, HBar, VBar, LW, RW, UW, DW, _),
        splitwin_RelLimitToAbs(SplitWin, HBar, LW, horizontal, left_up, Displacement, AbsLeft),
        splitwin_RelLimitToAbs(SplitWin, HBar, RW, horizontal, right_down, Displacement, AbsRight),
        splitwin_RelLimitToAbs(SplitWin, VBar, UW, vertical, left_up, Displacement, AbsUp),
        splitwin_RelLimitToAbs(SplitWin, VBar, DW, vertical, right_down, Displacement, AbsDown),
        assert(splitwin_Resize_db(SplitWin, Pnt, HBar, VBar,
            AbsLeft, AbsRight, AbsUp, AbsDown, Displacement)).

predicates
    splitwin_MoveDragPointer(
        window SplitWin, 
        pnt NewPnt)
    - procedure (i, i)

clauses
    splitwin_MoveDragPointer(SplitWin, NewPnt):-
        retract(splitwin_Resize_db(SplitWin, OldPnt, HBar, VBar, 
            ALW, ARW, AUW, ADW, Displacement)), 
        !, 
        splitwin_DrawDragPointer(SplitWin, OldPnt, HBar, VBar),
        splitwin_DrawDragPointer(SplitWin, NewPnt, HBar, VBar),
        assert(splitwin_Resize_db(SplitWin, NewPnt, HBar, VBar, 
            ALW, ARW, AUW, ADW, Displacement)).
    splitwin_MoveDragPointer(_, _):-
        errorexit(splitwin_InternalError).

%********************************************************************
% Move Drag Pointer on mouse move.
% Prdicate make default limitation of Drag Pointer and limitation,
% stored from resize callback.
%********************************************************************
predicates
    splitwin_MoveAndLimitDragPointer(
        window SplitWin, 
        pnt MousePnt)
    - procedure (i, i)

clauses
    splitwin_MoveAndLimitDragPointer(Win, Pnt):-
        splitwin_IsResize(Win, _, HBar, VBar, Left, Right, Up, Down,
            Displacement),
        !,
        % Default limitation of drag pointer position
        splitwin_ConvPntToLegalDragPnt(Win, HBar, VBar, Pnt, Displacement,
            CorPnt),
        % Limitation, stored from resize callback
        CorPnt = pnt(X, Y),
        X1 = splitwin_Max(X, Left),
        LegalX = splitwin_Min(X1, Right),
        Y1 = splitwin_Max(Y, Up),
        LegalY = splitwin_Min(Y1, Down),
        NewPnt = pnt(LegalX, LegalY),
        splitwin_MoveDragPointer(Win, NewPnt).
% No Drag pointer, do nothing with Drag pointer.
    splitwin_MoveAndLimitDragPointer(_, _).

%*********************************************************************
%
% ============== Cursor handling =====================================
%
%*********************************************************************
%********************************************************************
% Set Resize cursor.
% Request and set resize cursor on mouse move (mouse on bar) or
% set cursor_Arrow on mouse move
%********************************************************************
predicates
    splitwin_SetCursor(
        window SplitWin,
        pnt Point)
    - procedure (i, i)
clauses

% Resize in progress, no cursor changing.
    splitwin_SetCursor(SplitWin, _):-
        splitwin_IsResize(SplitWin, _, _, _, _ , _, _, _, _),
        !.
% Mouse on bar -> Request and set resize cursor
    splitwin_SetCursor(SplitWin, Point):-
        splitwin_GetCallbacks(SplitWin, ResizeCallback, _),
        splitwin_GetMouseBar(SplitWin, Point, HBar, VBar, _),
        ResizeCallback(SplitWin, HBar, VBar, _, _, _, _, Cursor),
        WinCursor = cursor_Get(SplitWin),
        not(WinCursor = Cursor),
        !,
        cursor_Set(SplitWin, Cursor).
% Mouse out of bar -> Set cursor_Arrow
    splitwin_SetCursor(SplitWin, Point):-
        splitwin_GetMouseBar(SplitWin, Point, HBar, VBar, _),
        HBar = -1,
        VBar = -1,
        WinCURSOR = cursor_Get(SplitWin),
        not(WinCURSOR = cursor_Arrow),
        !,
        cursor_Set(SplitWin, cursor_Arrow).
    splitwin_SetCursor(_, _).


%*********************************************************************
%
% ========= Predicates for inserting and deleting of row/column ======
%
%*********************************************************************
%*********************************************************************
% Delete left or right resize bar for specified Column/Row.
%*********************************************************************
predicates
    splitwin_DeleteLeftOrRightBar(
        window SplitWin, 
        integer ColumnRow, 
        integer ColumnsRows, 
        splitwin_direction Direction)
    - procedure (i, i, i, i)
clauses

% Column/Row is not the last
% right  Resize Bar index = Column/Row index, delete right Resize Bar
    splitwin_DeleteLeftOrRightBar(SplitWin, ColumnRow, Max, Direction):-
        ColumnRow < Max - 1, 
        !, 
        splitwin_DeleteBar(SplitWin, ColumnRow, Direction).
% Column/Row is the last
% delete left Resize Bar
    splitwin_DeleteLeftOrRightBar(SplitWin, ColumnRow, _Max, Direction):-
        LeftBar = ColumnRow - 1, 
        splitwin_DeleteBar(SplitWin, LeftBar, Direction).

%*********************************************************************
% Decrement Bar and Pane indexes
%*********************************************************************
predicates
    splitwin_DecrementBarsIndex(
        window SplitWin, 
        integer Bar, 
        integer MaxPane, 
        splitwin_direction HorVerBar)
    - procedure (i, i, i, i)
clauses

    splitwin_DecrementBarsIndex(Win, Bar1, MaxPane, HorVerBar):-
        Bar1 < MaxPane - 2, 
        Bar2 = Bar1 + 1, 
        % Decrement bars index
        splitwin_ChangeBarIndex(Win, Bar1, Bar2, HorVerBar),
        fail.
    splitwin_DecrementBarsIndex(Win, Bar1, MaxPane, HorVerBar):-
        Bar1 < MaxPane - 1,
        !,
        Bar2 = Bar1 + 1,
        % Decrement panes index
        splitwin_ChangePanesIndex(Win, Bar1, Bar2, HorVerBar),
        splitwin_DecrementBarsIndex(Win, Bar2, MaxPane, HorVerBar).
    splitwin_DecrementBarsIndex(_, _, _, _).

%*********************************************************************
% Delete column or row
%*********************************************************************
predicates
    splitwin_DeleteLine(
        window SplitWin, 
        integer ColumnRow, 
        splitwin_direction Direction)
    - procedure (i, i, i)
clauses

    splitwin_DeleteLine(Win, ColumnRow, Direction):-
        splitwin_GetColumnsOrRows(Win, Direction, ColumnsRows),
        ColumnsRows > splitwin_MinColumnsRows,
	!,
        % Reset -- Max Number of Column Row
        NewColumnsRows = ColumnsRows - 1, 
        splitwin_ChangeColumnsOrRows(Win, NewColumnsRows, Direction), 
        splitwin_DeletePaneWins(Win, ColumnRow, Direction), 
        % Delete column bar
        splitwin_DeleteLeftOrRightBar(Win, ColumnRow, ColumnsRows, Direction),
        % Decrement column bar Index
        splitwin_DecrementBarsIndex(Win, ColumnRow, ColumnsRows, Direction), 
        % Change Panes Rct
        splitwin_ResetPanesRct(Win).
    splitwin_DeleteLine(_, _, horizontal):-
        errorexit(splitwin_ImpossibleToDeleteLastColumn).
    splitwin_DeleteLine(_, _, vertical):-
        errorexit(splitwin_ImpossibleToDeleteLastRow).

%********************************************************************
% Increment index of Bars and Panes
%********************************************************************
predicates
    splitwin_IncrementBarsIndex(
        window SplitWin, 
        integer FromBar, 
        integer Bar, 
        integer MaxPane, 
        splitwin_direction HorVerBar)
    - procedure (i, i, i, i, i)

clauses
    splitwin_IncrementBarsIndex(_, From, Bar1, _, _):-
        Bar1 <= From,
        !.
    splitwin_IncrementBarsIndex(Win, _From, Bar1, MaxPane, HorVer):-
        % Increment bars index
        Bar1 < MaxPane,
        Bar2 = Bar1 - 1,
        splitwin_ChangeBarIndex(Win, Bar1, Bar2, HorVer),
        fail.
    splitwin_IncrementBarsIndex(Win, From, Bar1, MaxPane, HorVer):-
        % Increment panes index
        Bar2 = Bar1 - 1,
        splitwin_ChangePanesIndex(Win, Bar1, Bar2, HorVer),
        splitwin_IncrementBarsIndex(Win, From, Bar2, MaxPane, HorVer).

%********************************************************************
% Insert new bar for specified column or row.
%********************************************************************
predicates
    splitwin_InsertBar(
        window SplitWin, 
        integer RightBar,
        integer MaxColumnsRows,
        splitwin_direction Direction)
    - procedure (i, i, i, i)
clauses

% Inserted bar is not last
    splitwin_InsertBar(SplitWin, RightBar, Max, Direction):-
        RightBar < Max,
        !,
        % Increment other Index of bars and panes
        splitwin_IncrementBarsIndex(SplitWin, RightBar, Max, Max, Direction),
        splitwin_AssertBar(SplitWin, RightBar, Direction, 0).
% Inserted bar is last
    splitwin_InsertBar(SplitWin, RightBar, _Max, Direction):-
        LeftBar = RightBar - 1,
        splitwin_AssertBar(SplitWin, LeftBar, Direction, 0).

%********************************************************************
% Set Column Width or Row Height.
%********************************************************************
predicates
    splitwin_SetInsertWidth(
          window SplitWin, 
          integer ColumnRow, 
          integer ColumnsRows, 
          integer Size,
          splitwin_direction Direction)
      - procedure (i, i, i, i, i)
clauses

% Set Width/Height when column/row is not the last,
% move  right/bottom column/row bar to the rightwards/downwards
    splitwin_SetInsertWidth(SplitWin, ColumnRow, ColumnsRows, Size,
            Direction):-
        ColumnRow < ColumnsRows, 
        !, 
        splitwin_SetColumnRowSize(SplitWin, ColumnRow, ColumnsRows, Direction,
            Size, reduce).
% Set Width/Height when column/row is the last
% move left/up column/row bar to the leftwards/upwards
    splitwin_SetInsertWidth(SplitWin, ColumnRow, ColumnsRows, Size,
            Direction):-
        ColumnRow1 = ColumnRow - 1, 
        splitwin_SetColumnRowSize(SplitWin, ColumnRow1, ColumnsRows, Direction,
            Size, reduce).

%*********************************************************************
% Insert new Column or row 
%*********************************************************************
predicates
    splitwin_InsertLine(
        window SplitWin, 
        integer ColumnRow, 
        integer Size, 
        splitwin_direction Direction)
    - procedure (i, i, i, i)
clauses

    splitwin_InsertLine(SplitWin, ColumnRow, Size, Direction):-
        splitwin_GetColumnsOrRows(SplitWin, Direction, ColumnsRows),
        NewColumnsRows = ColumnsRows + 1,
        splitwin_ChangeColumnsOrRows(SplitWin, NewColumnsRows, Direction),
        splitwin_InsertBar(SplitWin, ColumnRow, ColumnsRows, Direction),
        splitwin_SetInsertWidth(SplitWin, ColumnRow, NewColumnsRows,
        Size, Direction).


%*********************************************************************
% Delete wsf_ClipChildren and wsf_Visible flags for split window.
% Removing of wsf_ClipChildren flag is necessary for correct resize 
% bars drawing.
%*********************************************************************
predicates
    splitwin_DeleteFlags(
        wsflags Input, 
        wsflags Output)
    - procedure (i, o)
clauses

    splitwin_DeleteFlags([], []):-!.
    splitwin_DeleteFlags([F|Fs], DFs):-
        splitwin_member(F, [wsf_ClipChildren, wsf_Visible]),
        !, 
        splitwin_DeleteFlags(Fs, DFs).
    splitwin_DeleteFlags([F|Fs], [F|DFs]):-
        !, 
        splitwin_DeleteFlags(Fs, DFs).
    splitwin_DeleteFlags(_, _):-
        errorexit(splitwin_InternalError).

predicates
    splitwin_IsMinimized(window SplitWin) - determ (i)
clauses

    splitwin_IsMinimized(SplitWin):-
        Flags = win_GetState(SplitWin), 
        splitwin_member(wsf_Minimized, Flags).

%********************************************************************
%
% ================= Predicates for Event handling ===================
%
%********************************************************************
predicates
    splitwin_lb_OnMouseUp(window SplitWin) - procedure (i)
clauses

    splitwin_lb_OnMouseUp(Win):-                
        splitwin_IsResize(Win, NewPnt, HBar, VBar, _, _, _, _, Displacement),
        splitwin_DrawDragPointer(Win, NewPnt, HBar, VBar),
	splitwin_DeleteResize(Win), 
        win_SetPen(Win, pen(1, ps_Solid, color_Black)), 
        win_SetDrawMode(Win, dm_CopyPen), 
        win_ReleaseMouse(), 
        Displacement = pnt(DX, DY),
        NewPnt = pnt(X, Y),
        X1 = X - DX,
        Y1 = Y - DY,
        splitwin_SetNewBarPos(Win, HBar, X1, horizontal, reduce), 
        splitwin_SetNewBarPos(Win, VBar, Y1, vertical, reduce), 
        !.
    splitwin_lb_OnMouseUp(_).

database - splitwin_Ehandler
    splitwin_ExternalEhandler_db(
        window SplitWin,
        ehandler SplitWinEhandler)

%********************************************************************
% Move Drag Pointer (if exists) or
% Set Resize cursor or Set Arrow cursor.
%********************************************************************
predicates
    splitwin_OnMouseMove(
        window SplitWin, 
        pnt Point)
    - procedure (i, i)
clauses

    splitwin_OnMouseMove(Win, Pnt):-
        splitwin_MoveAndLimitDragPointer(Win, Pnt), 
        splitwin_SetCursor(Win, Pnt).

predicates
    splitwin_OnDestroy(window Win) - procedure (i)
clauses

    splitwin_OnDestroy(Win):-                
        retractAll(splitwin_ExternalEhandler_db(Win, _)),
        retractAll(splitwin_EventsCallback_db(Win, _)),
        retractAll(splitwin_InitData_db(Win, _, _, _, _)), 
        retractAll(splitwins_Pane_db(Win, _, _, _)), 
        retractAll(splitwin_Params_db(Win, _, _)), 
        retractAll(splitwin_BarsPos_db(Win, _, _, _)), 
        retractAll(splitwin_Resize_db(Win, _, _, _, _, _, _, _, _)).

predicates
    splitwin_OnUpdate(window Win) - procedure (i)
clauses

    splitwin_OnUpdate(Win):-                
        win_SendEvent(Win, e_User(splitwin_Update_id, 0)).
        
predicates
    splitwin_OnPostUpdate(window Win) - procedure (i)
clauses

    splitwin_OnPostUpdate(Win):-
	!,
        splitwin_GetCallbacks(Win, _, SplitwinUpdateCallback), 
        SplitwinUpdateCallback(Win).
    splitwin_OnPostUpdate(_).

predicates
    splitwin_lb_OnMouseDown(
            window SplitWin, 
            pnt MousePnt)
    - procedure (i, i)
clauses

    splitwin_lb_OnMouseDown(SplitWin, Pnt):-                
	win_SetFocus(SplitWin),
        splitwin_HandleMouseDownPoint(SplitWin, Pnt, HBar, VBar),
        !,
        win_CaptureMouse(SplitWin),
        win_SetPen(SplitWin, pen(splitwin_DragPointerWidth, ps_Solid, color_Black)),
        win_SetDrawMode(SplitWin, dm_NotXorPen),
        splitwin_DrawDragPointer(SplitWin, Pnt, HBar, VBar).
    splitwin_lb_OnMouseDown(_, _).

predicates
    splitwin_OnSize(window SplitWin) - procedure (i)

clauses
    splitwin_OnSize(SplitWin):-
        not(splitwin_IsMinimized(SplitWin)),
        !, 
        splitwin_ResetBarsPos(SplitWin),
        splitwin_ResetPanesRct(SplitWin).
    splitwin_OnSize(_).

%********************************************************************
% Sending Events to External ehandler (top level or application),
% if splitwin_CreateInWindow predicate was used for creation
% fail: 1) if splitwin_Create predicate was used for creation
%       2) if External Ehandler fail
%********************************************************************
predicates
    long /*RetCode*/ splitwin_SendEvents(
        window SplitWin,
        event Event)
    - determ (i,i)
clauses

    splitwin_SendEvents(SplitWin, Events, Ret):-
        splitwin_ExternalEhandler_db(SplitWin, ExternalEhandler),
        !,
        Ret = ExternalEhandler(SplitWin, Events).

%********************************************************************
% Sending Events (by Events Callback) from bottom level to Top level
% or application, if splitwin_Create predicate was used for creation
% fail: 1) if splitwin_CreateInWindow predicate was used for creation
%       2) if Evets Callback fail
%********************************************************************
predicates
    long /*RetCode*/ splitwin_SendEventsByCallback(
        window SplitWin, 
        event Event)
    - determ (i, i)
clauses

    splitwin_SendEventsByCallback(SplitWin, Events, RetCode):-
        splitwin_EventsCallback_db(SplitWin, EvetsCallback),
        !,
        EvetsCallback(SplitWin, Events, RetCode).

% Is used for input arguments passing inside of e_Create event
domains
    splitwin_CreationData = data(
        splitwin_resize_cb ResizeCallback,
        splitwin_update_cb UpdateCallback,
        splitwin_events_cb EventsCallback,
        integer Columns,
        integer Rows)

% ===================================================================
% ===== Splitwin event handler ======================================
% ===================================================================
predicates
    splitwin_split_eh : ehandler

clauses

% e_Create handling if splitwin_Create predicate was used for creation.
    splitwin_split_eh(Win, e_Create(CreationData), 0):-
        CreationData1 = cast(splitwin_CreationData, CreationData),
        CreationData1 = data(ResizeCallback, UpdateCallback,
            EventCallback, Columns, Rows),
        splitwin_InitParams(Win, ResizeCallback, UpdateCallback,
            EventCallback, Columns, Rows),
        splitwin_InitBars(Win, Columns, Rows),
        fail.

%********************************************************************
% Handle events if splitwin_Create or
% splitwin_CreateInWindow predicate was used for creation.
%********************************************************************
    splitwin_split_eh(_Win, e_EraseBackground(), 0):-!.

    splitwin_split_eh(Win, e_MouseUp(_Pnt, _, mouse_button_left), 0):-
        splitwin_lb_OnMouseUp(Win), 
        fail.

    splitwin_split_eh(Win, e_MouseMove(Pnt, _, _), 0):-
        splitwin_OnMouseMove(Win, Pnt), 
        fail.

    splitwin_split_eh(Win, e_Update(_UpdateRct), 0):-
        splitwin_OnUpdate(Win), 
        fail.

    splitwin_split_eh(Win, e_User(splitwin_Update_id, _), 0):-
        splitwin_OnPostUpdate(Win), 
        fail.

    splitwin_split_eh(Win, e_MouseDown(Point, _, mouse_button_left), 0):-
        splitwin_lb_OnMouseDown(Win, Point),
        fail.

    splitwin_split_eh(Win, e_Size(_Width, _Height), 0):-
        splitwin_OnSize(Win), 
        fail.

    splitwin_split_eh(Win, e_Menu(ID, CAS), 0):-
        PARENT = win_GetParent(Win), 
        win_SendEvent(PARENT, e_Menu(ID, CAS)),
        fail.

% If splitwin_Create predicate was used for creation
%    then Send Events by callback to Top level or application
%    else - fail.
% Also always fails on e_Destroy event.
    splitwin_split_eh(Win, Event, RetCode):-
        RetCode = splitwin_SendEventsByCallback(Win, Event),
        not(Event = e_Destroy),
        !.

% If splitwin_CreateInWindow predicate was used for creation
%    then Send Events to External ehandler (top level or application)
%    else - fail.
% Also always fails on e_Destroy event.
    splitwin_split_eh(Win, Event, RetCode):-
        RetCode = splitwin_SendEvents(Win, Event),
        not(Event = e_Destroy),
        !.

    splitwin_split_eh(Win, e_Destroy(), 0):-
        splitwin_OnDestroy(Win),
        fail.

%********************************************************************
% ===========  Error handling predicates  ===========================
%********************************************************************
predicates
    splitwin_ValidateWinType(wintype WinType) - procedure (i)

clauses
    splitwin_ValidateWinType(WinType):-
         splitwin_member(WinType,[w_Child,w_TopLevel]),
         !.
    splitwin_ValidateWinType(_):-
         errorexit(splitwin_InvalidWinType).

predicates
    splitwin_ValidateWindow(window SplitWin) - procedure (i)

clauses
    splitwin_ValidateWindow(SplitWin):-
        splitwin_IsSplitInitialized(SplitWin),
        !.
    splitwin_ValidateWindow(_):-
         errorexit(splitwin_InvalidSplitWindow).

constants
% Correction types in splitwin_ValidateBarIndex
% Valid values -1 till Max
    splitwin_one_left = -1
% Valid values 0 till Max
    splitwin_no_correction = 0
% Valid values 0 till Max+1
    splitwin_one_right = 1

predicates
    splitwin_ValidateBarIndex(
        window SplitWin,
        integer ColumnOrRow,
        splitwin_direction Direction,
        integer LeftCorrection,
        integer RightCorrection)
    - procedure (i, i, i, i, i)

    splitwin_ValidateBarIndex(
        window SplitWin,
        integer ColumnOrRow,
        splitwin_direction Direction)
    - procedure (i, i, i)

clauses
    splitwin_ValidateBarIndex(SplitWin, ColumnOrRow, Direction, LeftCorrection,
        RightCorrection):-
        splitwin_GetColumnsOrRows(SplitWin, Direction, ColumnsRows),
        ColumnOrRow >= LeftCorrection,
        CorrectedColumnsRows = ColumnsRows + RightCorrection,
        ColumnOrRow < CorrectedColumnsRows, 
	!.
    splitwin_ValidateBarIndex(_, _, horizontal, _, _):-
        errorexit(splitwin_InvalidColumn).
    splitwin_ValidateBarIndex(_, _, vertical, _, _):-
        errorexit(splitwin_InvalidRow).

    splitwin_ValidateBarIndex(SplitWin, ColumnOrRow, Direction):-
        splitwin_ValidateBarIndex(SplitWin, ColumnOrRow, Direction,
        splitwin_no_correction, splitwin_no_correction).
predicates
    splitwin_ValidatePaneWinType(window SplitWin) - procedure (i)

clauses
    splitwin_ValidatePaneWinType(PaneWin):-
        WinType = win_GetType(PaneWin),
        splitwin_member(
            WinType,
            [w_Child, wc_PushButton, wc_RadioButton, wc_Custom,
            wc_CheckBox, wc_Edit, wc_LBox, wc_Text, wc_LBoxEdit]),
        !.
    splitwin_ValidatePaneWinType(_):-
        errorexit(splitwin_InvalidPaneWindowType).

predicates
    splitwin_ValidateExistPaneWin(
        window SplitWin,
        window PaneWin)
    - procedure (i, i)

clauses
    splitwin_ValidateExistPaneWin(SplitWin, PaneWin):-
        splitwin_IsPaneWin(SplitWin, _Column, _Row, PaneWin),
        !.
    splitwin_ValidateExistPaneWin(_, _):-
        errorexit(splitwin_InvalidPaneWindow).

predicates
    splitwin_ValidateBarWidth(integer Width) - procedure (i)

clauses
    splitwin_ValidateBarWidth(Width):-
        Width >= splitwin_MinBarWidth,
        !.
    splitwin_ValidateBarWidth(_):-
        errorexit(splitwin_InvalidBarWidth).

predicates
    splitwin_ValidateMarginWidth(integer Width) - procedure (i)

clauses
    splitwin_ValidateMarginWidth(Width):-
        Width >= splitwin_MinMarginWidth,
        !.
    splitwin_ValidateMarginWidth(_):-
        errorexit(splitwin_InvalidMarginWidth).

predicates
    splitwin_ValidateStartColumnsRows(
        integer Columns,
        integer Rows)
    - procedure (i, i)

clauses
    splitwin_ValidateStartColumnsRows(Columns, Rows):-
        Columns >= splitwin_MinColumnsRows,
        Rows >= splitwin_MinColumnsRows,
        !.
    splitwin_ValidateStartColumnsRows(_, _):-
        errorexit(splitwin_InvalidStartColumnsRows).

%********************************************************************
% ===========  Global predicates ====================================
% =========== see SPLITWIN.PRE for details ==========================
%********************************************************************
    splitwin_Create(WinType, Rectangle, Title, Menu, ParentWindow, Flags,
            ResizeCallback, UpdateCallback, EventsCallback, Columns, Rows, 
        SplitWin):-
ifdef splitwin_argumentValidation
        splitwin_ValidateWinType(WinType),
        splitwin_ValidateStartColumnsRows(Columns, Rows),
enddef
        splitwin_DeleteFlags(Flags, OutFlags),
        Flags1 = [wsf_Invisible | OutFlags], 
        CreationData = data(ResizeCallback, UpdateCallback,
            EventsCallback, Columns, Rows),
        CreationData1 = cast(long, CreationData),
        SplitWin = win_Create(WinType, Rectangle, Title, Menu, ParentWindow,
            Flags1, splitwin_split_eh, CreationData1).

    splitwin_CreateInWindow(SplitWin, ResizeCallback, UpdateCallback,
            Columns, Rows):-
ifdef splitwin_argumentValidation
        splitwin_ValidateStartColumnsRows(Columns, Rows),
enddef
        % Get application or top level handler
        ExEhandler = win_GetHandler(SplitWin),
        % Store application or top level handler for sending events
        % to application or top level handler
        assert(splitwin_ExternalEhandler_db(SplitWin, ExEhandler)),
        % Set bottom level handler
        win_SetHandler(SplitWin, splitwin_split_eh),
        splitwin_InitParams(SplitWin, ResizeCallback, UpdateCallback,
            Columns, Rows),
        splitwin_InitBars(SplitWin, Columns, Rows).
        
    splitwin_Show(SplitWin):-
ifdef splitwin_argumentValidation
        splitwin_ValidateWindow(SplitWin),
enddef
        splitwin_ResetPanesRct(SplitWin), 
        win_SetState(SplitWin, [wsf_Visible]).

    splitwin_ClearPane(SplitWin, Column, Row, PaneWin):-
ifdef splitwin_argumentValidation
        splitwin_ValidateWindow(SplitWin),
        splitwin_ValidateBarIndex(SplitWin, Column, horizontal),
        splitwin_ValidateBarIndex(SplitWin, Row, vertical),
enddef
        PaneWin = splitwin_GetPane(SplitWin, Column, Row), 
        splitwin_DeletePane(SplitWin, Column, Row).

    splitwin_GetPane(SplitWin, Column, Row, PaneWin):-
ifdef splitwin_argumentValidation
        splitwin_ValidateWindow(SplitWin),
enddef
        splitwin_IsPaneWin(SplitWin, Column, Row, PaneWin),
        !.
    splitwin_GetPane(_, _, _, PaneWin):-
        PaneWin = cast(WINDOW, 0).

    splitwin_GetPaneCoordinate(_SplitWin, PaneWin, pnt(X, Y)):-
ifdef splitwin_argumentValidation
        splitwin_ValidateExistPaneWin(_SplitWin, PaneWin),
enddef
        PaneRct = win_GetOuterRect(PaneWin),
        PaneRct = rct(X, Y, _, _).

    splitwin_GetMarginWidth(SplitWin, MarginWidth):-
ifdef splitwin_argumentValidation
        splitwin_ValidateWindow(SplitWin),
enddef
	splitwin_GetMargin(SplitWin, MarginWidth).

    splitwin_SetMarginWidth(SplitWin, MarginWidth):-
ifdef splitwin_argumentValidation
        splitwin_ValidateWindow(SplitWin),
        splitwin_ValidateMarginWidth(MarginWidth),
enddef
        splitwin_ChangeMarginWidth(SplitWin, MarginWidth), 
        splitwin_ResetBarsPos(SplitWin), 
        splitwin_ResetPanesRct(SplitWin), 
        win_PostEvent(SplitWin, e_User(splitwin_Update_id, 0)).

    splitwin_GetResizeBarWidth(SplitWin, BarWidth):-
ifdef splitwin_argumentValidation
        splitwin_ValidateWindow(SplitWin),
enddef
	splitwin_GetBarWidth(SplitWin, BarWidth).

    splitwin_SetResizeBarWidth(SplitWin, BarWidth):-
ifdef splitwin_argumentValidation
        splitwin_ValidateWindow(SplitWin),
        splitwin_ValidateBarWidth(BarWidth),
enddef
        splitwin_ChangeBarWidth(SplitWin, BarWidth), 
        splitwin_ResetBarsPos(SplitWin), 
        splitwin_ResetPanesRct(SplitWin), 
        win_PostEvent(SplitWin, e_User(splitwin_Update_id, 0)).

    splitwin_SetPane(SplitWin, Column, Row, PaneWin, OldPaneWin):-
ifdef splitwin_argumentValidation
        splitwin_ValidateWindow(SplitWin),
        splitwin_ValidateBarIndex(SplitWin, Column, horizontal),
        splitwin_ValidateBarIndex(SplitWin, Row, vertical),
        splitwin_ValidatePaneWinType(PaneWin),
enddef
        splitwin_IsPaneWin(SplitWin, Column, Row, OldPaneWin), 
	!, 
        splitwin_ChangePaneWin(SplitWin, Column, Row, PaneWin), 
        splitwin_ResetPanesRct(SplitWin).
    splitwin_SetPane(SplitWin, Column, Row, PaneWin, OldPaneWin):-
        splitwin_AssertPane(SplitWin, Column, Row, PaneWin), 
        splitwin_ResetPanesRct(SplitWin), 
        OldPaneWin = cast(WINDOW, 0).

    splitwin_GetColumnWidth(SplitWin, Column, Width):-
ifdef splitwin_argumentValidation
        splitwin_ValidateWindow(SplitWin),
        splitwin_ValidateBarIndex(SplitWin, Column, horizontal),
enddef
        splitwin_GetPaneSize(SplitWin, Column, horizontal, Width).

    splitwin_SetColumnWidth(SplitWin, Column, Width):-
ifdef splitwin_argumentValidation
        splitwin_ValidateWindow(SplitWin),
        splitwin_ValidateBarIndex(SplitWin, Column, horizontal),
enddef
        splitwin_GetColumnsAndRows(SplitWin, Columns, _Rows), 
        splitwin_SetColumnRowSize(SplitWin, Column, Columns, 
            horizontal, Width, noreduce).

    splitwin_GetRowHeight(SplitWin, Row, Height):-
ifdef splitwin_argumentValidation
        splitwin_ValidateWindow(SplitWin),
        splitwin_ValidateBarIndex(SplitWin, Row, vertical),
enddef
        splitwin_GetPaneSize(SplitWin, Row, vertical, Height).

    splitwin_SetRowHeight(SplitWin, Row, Height):-
ifdef splitwin_argumentValidation
        splitwin_ValidateWindow(SplitWin),
        splitwin_ValidateBarIndex(SplitWin, Row, vertical),
enddef
        splitwin_GetColumnsAndRows(SplitWin, _Columns, Rows),
        splitwin_SetColumnRowSize(SplitWin, Row, Rows, vertical, Height,
            noreduce).

    splitwin_GetColumnBarPos(SplitWin, Column, Position):-
ifdef splitwin_argumentValidation
        splitwin_ValidateWindow(SplitWin),
        splitwin_ValidateBarIndex(SplitWin, Column, horizontal, 
            splitwin_one_left, splitwin_one_right),
enddef
        splitwin_GetExtraBarPos(SplitWin, Column, horizontal, Position, _).

    splitwin_GetRowBarPos(SplitWin, Row, Position):-
ifdef splitwin_argumentValidation
        splitwin_ValidateWindow(SplitWin),
        splitwin_ValidateBarIndex(SplitWin, Row, vertical,
            splitwin_one_left, splitwin_one_right),
enddef
        splitwin_GetExtraBarPos(SplitWin, Row, vertical, Position, _).

    splitwin_DeleteColumn(SplitWin, Column):-
ifdef splitwin_argumentValidation
        splitwin_ValidateWindow(SplitWin),
        splitwin_ValidateBarIndex(SplitWin, Column, horizontal),
enddef
        splitwin_DeleteLine(SplitWin, Column, horizontal).

    splitwin_DeleteRow(SplitWin, Row):-
ifdef splitwin_argumentValidation
        splitwin_ValidateWindow(SplitWin),
        splitwin_ValidateBarIndex(SplitWin, Row, vertical),
enddef
        splitwin_DeleteLine(SplitWin, Row, vertical).

    splitwin_InsertColumnAt(SplitWin, Column, Width):-
ifdef splitwin_argumentValidation
        splitwin_ValidateWindow(SplitWin),
        splitwin_ValidateBarIndex(SplitWin, Column, horizontal,
            splitwin_no_correction, splitwin_one_right),
enddef
        splitwin_InsertLine(SplitWin, Column, Width, horizontal).

    splitwin_InsertRowAt(SplitWin, Row, Height):-
ifdef splitwin_argumentValidation
        splitwin_ValidateWindow(SplitWin),
        splitwin_ValidateBarIndex(SplitWin, Row, vertical,
            splitwin_no_correction, splitwin_one_right),
enddef
        splitwin_InsertLine(SplitWin, Row, Height, vertical).

    splitwin_GetColumnsRows(SplitWin, Columns, Rows):-
ifdef splitwin_argumentValidation
        splitwin_ValidateWindow(SplitWin),
enddef
        splitwin_GetColumnsAndRows(SplitWin, Columns, Rows).

        
