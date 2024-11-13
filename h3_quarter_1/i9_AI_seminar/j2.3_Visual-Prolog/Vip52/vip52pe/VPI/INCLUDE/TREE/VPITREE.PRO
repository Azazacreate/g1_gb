/******************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S 
			
			Visual Prolog 

 FileName: VPITREE.PRO
 PURPOSE: 
 Written by: 
 Comments:
 
******************************************************************************/
ifndef error_con_included
 #Error: this file requires inclusion of file: error.con
enddef 
ifndef vpitree_pre_included
 #Error: this file requires include: vpitree.pre
enddef 

constants
	tree_frame_hor                  = 3
	tree_frame_ver                  = 3
	tree_link_width                 = 5
	tree_skip                       = 2

	tree_scroll_hor                 = 20
	tree_scroll_ver                 = 20

	tree_selected_node_color        = color_Black
	tree_selected_text_color        = color_White
	tree_frame_color                = color_Black
	tree_link_color                 = color_Black

domains
	TREE_NODE       = node (INTEGER ColLR, INTEGER, INTEGER RowLR, INTEGER ColUD, INTEGER, INTEGER RowUD, INTEGER, INTEGER, INTEGER, TREE_SELECTOR, BOOLEAN Closed, BOOLEAN In, BOOLEAN Out, TREE_LINK, TREE_ARROW_TYPE );
			  row_mark ( INTEGER, INTEGER, INTEGER );
			  closed_mark ( TREE_SELECTOR, INTEGER )
	TREE_NODE_LIST  = TREE_NODE*
	TREE_LINK       = begin; end; cross; line

database - tree_base
	tree_above ( WINDOW, TREE_NODE )
	tree_below ( WINDOW, TREE_NODE )
	screen_context ( WINDOW, INTEGER, INTEGER, INTEGER )
	tree_size ( WINDOW, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER )
	multiple_selector ( WINDOW, TREE_SELECTOR )
	opened_multiple_in_tree_base ( WINDOW, TREE_NODE )
	opened_multiple_in_closed_base ( WINDOW, TREE_NODE, TREE_SELECTOR )
	win_info ( WINDOW, TREE_WIN_INFO )
	tree_callback ( WINDOW, EHANDLER )
	
predicates
	determ tree_base_clean_up ( WINDOW )
	determ tree_base_copy ( WINDOW From, WINDOW To )

clauses
	tree_base_clean_up ( Win ) :-
		retractall ( tree_above ( Win, _ ) ),
		retractall ( tree_below ( Win, _ ) ),
		retractall ( screen_context ( Win, _, _, _ ) ),
		retractall ( tree_size ( Win, _, _, _, _, _ ) ),
		retractall ( multiple_selector ( Win, _ ) ),
		retractall ( opened_multiple_in_tree_base ( Win, _ ) ),
		retractall ( opened_multiple_in_closed_base ( Win, _, _ ) ),
		retractall ( win_info ( Win, _ ) ),
		retractall ( tree_callback ( Win, _ ) ).

	tree_base_copy ( From, To ) :-
		tree_above ( From, Node ),
		assertz ( tree_above ( To, Node ) ), fail.
	tree_base_copy ( From, To ) :-
		tree_below ( From, Node ),
		assertz ( tree_below ( To, Node ) ), fail.
	tree_base_copy ( From, To ) :-
		screen_context ( From, XOff, YOff, Dir ),
		assert ( screen_context ( To, XOff, YOff, Dir ) ), fail.
	tree_base_copy ( From, To ) :-
		tree_size ( From, WidLR, HeiLR, WidUD, HeiUD, N ),
		assert ( tree_size ( To, WidLR, HeiLR, WidUD, HeiUD, N ) ), fail.
	tree_base_copy ( From, To ) :-
		multiple_selector ( From, Selector ),
		assert ( multiple_selector ( To, Selector ) ), fail.
	tree_base_copy ( From, To ) :-
		opened_multiple_in_tree_base ( From, Node ),
		assert ( opened_multiple_in_tree_base ( To, Node ) ), fail.
	tree_base_copy ( From, To ) :-
		opened_multiple_in_closed_base ( From, Node, Selector ),
		assert ( opened_multiple_in_closed_base ( To, Node, Selector ) ), fail.
	tree_base_copy ( From, To ) :-
		win_info ( From, TREE_WIN_INFO ),
		assert ( win_info ( To, TREE_WIN_INFO ) ), fail.
	tree_base_copy ( From, To ) :-
		tree_callback ( From, EHANDLER ),
		assert ( tree_callback ( To, EHANDLER ) ), fail.
	tree_base_copy ( _, _ ).

/******************************************************************************

		SELECTION HANDLING

******************************************************************************/
database - selection_base
	selected ( WINDOW, INTEGER, INTEGER, INTEGER )
	selected_old ( WINDOW, INTEGER, INTEGER, INTEGER )
	hit_point ( WINDOW, PNT )
	invalid_selection ( WINDOW, RCT )

predicates
	determ selection_update ( WINDOW, BOOLEAN )
	determ selection_set_old ( WINDOW )
	determ get_selected_node ( WINDOW, TREE_NODE )
	determ selection_base_clean_up ( WINDOW )
	determ selection_base_copy ( WINDOW From , WINDOW To )

clauses
	selection_update ( Win, b_false ) :- !,
		retractall ( invalid_selection ( Win, _ ) ),
		retractall ( selected_old ( Win, _, _, _ ) ).
	selection_update ( Win, _ ) :-
		selected ( Win, I, J, K ),
		selected_old ( Win, I, J, K ), !,
		retractall ( invalid_selection ( Win, _ ) ),
		retractall ( selected_old ( Win, _, _, _ ) ).
	selection_update ( Win, _ ) :-
		retract ( invalid_selection ( Win, RCT ) ),
		win_Invalidate ( Win, RCT ),
		win_Update ( Win ), fail.
	selection_update ( Win, _ ) :-
		retractall ( selected_old ( Win, _, _, _ ) ).

	selection_set_old ( Win ) :-
		selected ( Win, I, J, K ), !,
		retractall ( selected_old ( Win, _, _, _ ) ),
		assert ( selected_old ( Win, I, J, K ) ).
	selection_set_old ( _ ).

	get_selected_node ( Win, node ( ColLR, ColLR_, RowLR, ColUD, ColUD_, RowUD, I, J, K, Selector, Closed, In, Out, Link, ArrowType ) ) :-
		selected ( Win, I, J, K ),
		tree_below ( Win, node ( ColLR, ColLR_, RowLR, ColUD, ColUD_, RowUD, I, J, K, Selector, Closed, In, Out, Link, ArrowType ) ), !.
	get_selected_node ( Win, node ( ColLR, ColLR_, RowLR, ColUD, ColUD_, RowUD, I, J, K, Selector, Closed, In, Out, Link, ArrowType ) ) :-
		selected ( Win, I, J, K ),
		tree_above ( Win, node ( ColLR, ColLR_, RowLR, ColUD, ColUD_, RowUD, I, J, K, Selector, Closed, In, Out, Link, ArrowType ) ), !.

	selection_base_clean_up ( Win ) :-
		retractall ( selected ( Win, _, _, _ ) ),
		retractall ( selected_old ( Win, _, _, _ ) ),
		retractall ( hit_point ( Win, _ ) ),
		retractall ( invalid_selection ( Win, _ ) ).

	selection_base_copy ( From, To ) :-
		selected ( From, I, J, K ), !,
		assert ( selected ( To, I, J, K ) ).

/******************************************************************************

		SEARCH HANDLING

******************************************************************************/
database - search_base
	search_sel ( WINDOW, TREE_SELECTOR )
	search ( WINDOW, INTEGER, INTEGER, INTEGER )
	search_rct ( WINDOW, RCT )

predicates
	determ search_found ( INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER )
	determ search_rect ( WINDOW, INTEGER, INTEGER, BOOLEAN )
	determ search_rect_ ( RCT, RCT, INTEGER, INTEGER )
	determ search_base_clean_up ( WINDOW )

clauses
	search_found ( I0, _, _, I1, _, _ ) :-
		I0 > I1, !.
	search_found ( I, J0, _, I, J1, _ ) :-
		J0 < J1, !.
	search_found ( I, J, K0, I, J, K1 ) :-
		K0 > K1, !.

	search_rect ( Win, Dx, Dy, Update ) :-
		C = win_GetClientRect ( Win ),
		retract ( search_rct ( Win, R ) ), !,
		search_rect_ ( C, R, Dx, Dy ),
		selection_update ( Win, Update ).

	search_rect_ ( C, R, Dx, Dy ) :-
		I = rect_Intersect ( C, R ),
		I = rct ( 0, 0, 0, 0 ), !,
		C = rct ( Lc, Tc, Rc, Bc ),
		R = rct ( Lr, Tr, Rr, Br ),
		Dx = ( Lc - Lr + Rc - Rr ) div 2,
		Dy = ( Tc - Tr + Bc - Br ) div 2.
	search_rect_ ( C, R, Dx, Dy ) :-
		U = rect_Union ( C, R ),
		U = rct ( Lu, Tu, Ru, Bu ),
		C = rct ( Lc, Tc, Rc, Bc ),
		Dx = Lc - Lu + Rc - Ru,
		Dy = Tc - Tu + Bc - Bu.

	search_base_clean_up ( Win ) :-
		retractall ( search_sel ( Win, _ ) ),
		retractall ( search ( Win, _, _, _ ) ),
		retractall ( search_rct ( Win, _ ) ).

/******************************************************************************

		WRITING A TREE

******************************************************************************/
constants
	write_lr        = 0
	write_ud        = 1

	write_          = 0
	write_search    = 1
	write_searched  = 2
	write_selected  = 3

database - write_base
	write_mode ( WINDOW, INTEGER )
	tree_link ( WINDOW, INTEGER, INTEGER, TREE_LINK )
	global_link ( WINDOW, INTEGER, INTEGER )

database - write_check_stop
	write_stop_after_row ( WINDOW )
	write_stop ( WINDOW )

predicates
	determ	write_tree ( WINDOW )
	determ write_tree_check_stop ( WINDOW, TREE_NODE, INTEGER, INTEGER )
	determ write_tree_right ( WINDOW, INTEGER, INTEGER, INTEGER )
	determ write_tree_left ( WINDOW, INTEGER, INTEGER, INTEGER )
	determ write_tree_up ( WINDOW, INTEGER, INTEGER, INTEGER )
	determ write_tree_down ( WINDOW, INTEGER, INTEGER, INTEGER )
	determ write_drawing ( WINDOW, RCT, INTEGER, INTEGER, INTEGER, TREE_SELECTOR, BOOLEAN, TREE_ARROW_TYPE )
	determ write_drawing ( WINDOW, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, TREE_SELECTOR, BOOLEAN, TREE_ARROW_TYPE, RCT, RCT )
	determ write_frame ( WINDOW, RCT, BOOLEAN, TREE_ARROW_TYPE )
	determ write_get_pen ( TREE_ARROW_TYPE, PEN )
	determ write_get_pen ( TREE_ARROW_TYPE, TREE_ARROW_PEN_LIST, PEN )
	determ write_link ( WINDOW, BOOLEAN, TREE_LINK, INTEGER, INTEGER, INTEGER, INTEGER )
	determ write_link ( WINDOW, BOOLEAN, INTEGER, INTEGER, INTEGER, INTEGER )
	determ write_link ( WINDOW, INTEGER, INTEGER, INTEGER )
	determ write_line ( WINDOW, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER )
	determ write_set_mode ( WINDOW, INTEGER )
	determ write_base_clean_up ( WINDOW )

clauses
	write_tree ( Win ) :-
		retractall ( write_stop_after_row ( Win ) ),
		retractall ( write_stop ( Win ) ), fail.
	write_tree ( Win ) :-
		screen_context ( Win, XOff, YOff, tree_DirRight ), !,
		RCT = win_GetClientRect ( Win ),
		RCT = rct ( _, Top, _, Bottom ),
		write_tree_right ( Win, XOff, YOff, Bottom ),
		write_link ( Win, Top, Bottom, write_lr ).
	write_tree ( Win ) :-
		screen_context ( Win, XOff, YOff, tree_DirLeft ), !,
		tree_size ( Win, TreeWidth, _, _, _, _ ), !,
		XOff_ = XOff - TreeWidth,
		RCT = win_GetClientRect ( Win ),
		RCT = rct ( _, Top, _, Bottom ),
		write_tree_left ( Win, XOff_, YOff, Bottom ),
		write_link ( Win, Top, Bottom, write_lr ).
	write_tree ( Win ) :-
		screen_context ( Win, XOff, YOff, tree_DirUp ), !,
		RCT = win_GetClientRect ( Win ),
		RCT = rct ( Left, _, Right, _ ),
		write_tree_up ( Win, XOff, YOff, Right ),
		write_link ( Win, Left, Right, write_ud ).
	write_tree ( Win ) :-
		screen_context ( Win, XOff, YOff, tree_DirDown ), !,
		tree_size ( Win, _, _, _, TreeHeight, _ ), !,
		YOff_ = YOff - TreeHeight,
		RCT = win_GetClientRect ( Win ),
		RCT = rct ( Left, _, Right, _ ),
		write_tree_down ( Win, XOff, YOff_, Right ),
		write_link ( Win, Left, Right, write_ud ).

	write_tree_check_stop ( Win, row_mark ( _ , _, _ ), _, _ ) :-
		retract ( write_stop_after_row ( Win ) ), !,
		retractall ( write_stop ( Win ) ),
		assert ( write_stop ( Win ) ).
	write_tree_check_stop ( Win, node ( _, _, Row, _, _, _, _, _, _, _, _, _, _, _, _ ), StopRow, write_lr ) :-
		Row > StopRow, !,
		retractall ( write_stop_after_row ( Win ) ),
		assert ( write_stop_after_row ( Win ) ).
	write_tree_check_stop ( Win, node ( _, _, _, _, _, Row, _, _, _, _, _, _, _, _, _ ), StopRow, write_ud ) :-
		Row > StopRow, !,
		retractall ( write_stop_after_row ( Win ) ),
		assert ( write_stop_after_row ( Win ) ).
	write_tree_check_stop ( _, _, _, _ ).

	write_tree_right ( Win, XOff, _, _ ) :-
		write_mode ( Win, write_ ),
		global_link ( Win, Col, _ ),
		Col_ = Col - XOff - tree_link_width,
		assert ( tree_link ( Win, Col_, -1, begin ) ), fail.
	write_tree_right ( Win, XOff, YOff, Bottom ) :-
		tree_below ( Win, NODE ),
		StopRow = Bottom + YOff,
		write_tree_check_stop ( Win, NODE, StopRow, write_lr ),
		NODE = node ( Col, Col_, Row, H, H_, _, I, J, K, Drawing, Closed, In, Out, Link, ArrowType ),
		Y = Row - YOff,
		L = Col - XOff,
		R = Col_ - XOff,
		T = Y - ( H_ - H ) div 2,
		B = T + H_ - H,
		RCT = rct ( L, T, R, B ),
		write_drawing ( Win, RCT, I, J, K, Drawing, Closed, ArrowType ),
		not ( write_mode ( Win, write_search ) ),
		RCT = rct ( Xb, _, Xc, _ ),
		Xa = Xb - tree_link_width,
		Xd = Xc + tree_link_width,
		write_link ( Win, In, Link, Xa, Xb, Y, write_lr ),
		write_link ( Win, Out, Xc, Xd, Y, write_lr ),
		retract ( write_stop ( Win ) ), !.
	write_tree_right ( _, _, _, _ ).

	write_tree_left ( Win, XOff, _, _ ) :-
		write_mode ( Win, write_ ),
		global_link ( Win, Col, _ ),
		Col_ = -Col - XOff + tree_link_width,
		assert ( tree_link ( Win, Col_, -1, begin ) ), fail.
	write_tree_left ( Win, XOff, YOff, Bottom ) :-
		tree_below ( Win, NODE ),
		StopRow = Bottom + YOff,
		write_tree_check_stop ( Win, NODE, StopRow, write_lr ),
		NODE = node ( Col, Col_, Row, H, H_, _, I, J, K, Drawing, Closed, In, Out, Link, ArrowType ),
		Y = Row - YOff,
		L = -Col_ - XOff,
		R = -Col - XOff,
		T = Y - ( H_ - H ) div 2,
		B = T + H_ - H,
		RCT = rct ( L, T, R, B ),
		write_drawing ( Win, RCT, I, J, K, Drawing, Closed, ArrowType ),
		not ( write_mode ( Win, write_search ) ),
		RCT = rct ( Xc, _, Xb, _ ),
		Xa = Xb + tree_link_width,
		Xd = Xc - tree_link_width,
		write_link ( Win, In, Link, Xa, Xb, Y, write_lr ),
		write_link ( Win, Out, Xc, Xd, Y, write_lr ),
		retract ( write_stop ( Win ) ), !.
	write_tree_left ( _, _, _, _ ).

	write_tree_up ( Win, _, YOff, _ ) :-
		write_mode ( Win, write_ ),
		global_link ( Win, _, Col ),
		Col_ = Col - YOff - tree_link_width,
		assert ( tree_link ( Win, Col_, -1, begin ) ), fail.
	write_tree_up ( Win, XOff, YOff, Right ) :-
		tree_below ( Win, NODE ),
		StopRow = Right + XOff,
		write_tree_check_stop ( Win, NODE, StopRow, write_ud ),
		NODE = node ( H, H_, _, Col, Col_, Row, I, J, K, Drawing, Closed, In, Out, Link, ArrowType ),
		X = Row - XOff,
		L = X - ( H_ - H ) div 2,
		R = L + H_ - H,
		T = Col - YOff,
		B = Col_ - YOff,
		RCT = rct ( L, T, R, B ),
		write_drawing ( Win, RCT, I, J, K, Drawing, Closed, ArrowType ),
		not ( write_mode ( Win, write_search ) ),
		RCT = rct ( _, Yb, _, Yc ),
		Ya = Yb - tree_link_width,
		Yd = Yc + tree_link_width,
		write_link ( Win, In, Link, Ya, Yb, X, write_ud ),
		write_link ( Win, Out, Yc, Yd, X, write_ud ),
		retract ( write_stop ( Win ) ), !.
	write_tree_up ( _, _, _, _ ).

	write_tree_down ( Win, _, YOff, _ ) :-
		write_mode ( Win, write_ ),
		global_link ( Win, _, Col ),
		Col_ = -Col - YOff + tree_link_width,
		assert ( tree_link ( Win, Col_, -1, begin ) ), fail.
	write_tree_down ( Win, XOff, YOff, Right ) :-
		tree_below ( Win, NODE ),
		StopRow = Right + XOff,
		write_tree_check_stop ( Win, NODE, StopRow, write_ud ),
		NODE = node ( H, H_, _, Col, Col_, Row, I, J, K, Drawing, Closed, In, Out, Link, ArrowType ),
		X = Row - XOff,
		L = X - ( H_ - H ) div 2,
		R = L + H_ - H,
		T = -Col_ - YOff,
		B = -Col - YOff,
		RCT = rct ( L, T, R, B ),
		write_drawing ( Win, RCT, I, J, K, Drawing, Closed, ArrowType ),
		not ( write_mode ( Win, write_search ) ),
		RCT = rct ( _, Yc, _, Yb ),
		Ya = Yb + tree_link_width,
		Yd = Yc - tree_link_width,
		write_link ( Win, In, Link, Ya, Yb, X, write_ud ),
		write_link ( Win, Out, Yc, Yd, X, write_ud ),
		retract ( write_stop ( Win ) ), !.
	write_tree_down ( _, _, _, _ ).

	write_drawing ( Win, RCT, I, J, K, Drawing, Closed, ArrowType ) :- !,
		RCT = rct ( L, T, R, B ),
		L_ = L + tree_frame_hor,
		T_ = T + tree_frame_ver,
		R_ = R - tree_frame_hor,
		B_ = B - tree_frame_ver,
		RCT_ = rct ( L_, T_, R_, B_ ),
		win_GetFontMetrics( Win, _, Ascent, _ ),
		Xt = L_,
		Yt = T_ + Ascent,
		write_drawing ( Win, Xt, Yt, I, J, K, Drawing, Closed, ArrowType, RCT, RCT_ ).

	write_drawing ( Win, Xt, Yt, I, J, K, Drawing, Closed, ArrowType, RCT, RCT_ ) :-
		write_mode ( Win, write_ ),
		write_frame ( Win, RCT, Closed, ArrowType ),
		selected ( Win, I, J, K ), !,
		DRAWTOOLS = win_GetDrawTools ( Win ),
		win_SetBrush ( Win, brush ( pat_Solid, tree_selected_node_color ) ),
		win_SetPen ( Win, pen ( 1, ps_Solid, tree_selected_node_color ) ),
		win_SetForeColor ( Win, tree_selected_text_color ),
		draw_rect ( Win, RCT_ ),
		draw_text ( Win, Xt, Yt, Drawing ),
		win_SetDrawTools ( Win, DRAWTOOLS ).
	write_drawing ( Win, Xt, Yt, _, _, _, Drawing, _, _, _, _ ) :-
		write_mode ( Win, write_ ), !,
		draw_text ( Win, Xt, Yt, Drawing ).
	write_drawing ( Win, _, _, I, J, K, _, _, _, RCT, RCT_ ) :-
		write_mode ( Win, write_selected ),
		hit_point ( Win, PNT ),
		rect_PntInside ( RCT, PNT ), !,
		retractall ( selected ( Win, _, _, _ ) ),
		assert ( selected ( Win, I, J, K ) ),
		assert ( invalid_selection ( Win, RCT_ ) ).
	write_drawing ( Win, _, _, I, J, K, _, _, _, _, RCT_ ) :-
		write_mode ( Win, write_selected ),
		selected_old ( Win, I, J, K ), !,
		assert ( invalid_selection ( Win, RCT_ ) ).
	write_drawing ( Win, _, _, I, J, K, _, _, _, _, RCT_ ) :-
		write_mode ( Win, write_searched ),
		selected_old ( Win, I, J, K ), !,
		assert ( invalid_selection ( Win, RCT_ ) ).
	write_drawing ( Win, _, _, I, J, K, _, _, _, RCT, RCT_ ) :-
		write_mode ( Win, write_search ),
		search ( Win, I, J, K ), !,
		write_set_mode ( Win, write_searched ),
		retractall ( selected ( Win, _, _, _ ) ),
		assert ( selected ( Win, I, J, K ) ),
		assert ( invalid_selection ( Win, RCT_ ) ),
		retractall ( search_rct ( Win, _ ) ),
		assert ( search_rct ( Win, RCT ) ).
	write_drawing ( Win, _, _, I, J, K, _, _, _, _, RCT_ ) :-
		write_mode ( Win, write_search ),
		selected_old ( Win, I, J, K ), !,
		assert ( invalid_selection ( Win, RCT_ ) ).
	write_drawing ( _, _, _, _, _, _, _, _, _, _, _ ).

	write_frame ( Win, RCT, b_true, ArrowType ) :- !,
		R_hor = 2 * tree_frame_hor,
		R_ver = 2 * tree_frame_ver,
		Pen = win_GetPen ( Win ),
		write_get_pen ( ArrowType, Pen_ ),
		win_SetPen ( Win, Pen_ ),
		draw_RoundRect ( Win, RCT, R_hor, R_ver ),
		win_SetPen ( Win, Pen ).
	write_frame ( Win, RCT, b_false, ArrowType ) :- !,
		Pen = win_GetPen ( Win ),
		write_get_pen ( ArrowType, Pen_ ),
		win_SetPen ( Win, Pen_ ),
		draw_Rect ( Win, RCT ),
		win_SetPen ( Win, Pen ).

	write_get_pen ( ArrowType, Pen ) :-
		win_info ( _, tree_WinInfo ( _, _, List ) ), !,
		write_get_pen ( ArrowType, List, Pen ).
	write_get_pen ( ArrowType, Pen ) :-
		win_info ( _, tree_WinInfoAdv ( _, _, List, _, _ ) ), !,
		write_get_pen ( ArrowType, List, Pen ).
	write_get_pen ( _, pen ( 1, ps_Solid, tree_frame_color ) ).

	write_get_pen ( _, [], pen ( 1, ps_Solid, tree_frame_color ) ) :- !.
	write_get_pen ( ArrowType, [ tree_ArrowPen ( ArrowType, Pen ) | _ ], Pen ) :- !.
	write_get_pen ( ArrowType, [ _ | T ], Pen ) :-
		write_get_pen ( ArrowType, T, Pen ).

	write_link ( Win, _, _, _, _, _, _ ) :-
		write_mode ( Win, MODE ),
		MODE <> write_, !.
	write_link ( Win, b_true, _, ColA, ColB, Row, Dir ) :-
		write_line ( Win, ColA, Row, ColB, Row, Dir ), fail.
	write_link ( Win, b_true, begin, Col, _, Row, _ ) :- !,
		assert ( tree_link ( Win, Col, Row, begin ) ).
	write_link ( Win, b_true, end, Col, _, Row1, Dir ) :-
		retract ( tree_link ( Win, Col, Row0, begin ) ), !,
		write_line ( Win, Col, Row0, Col, Row1, Dir ).
	write_link ( Win, b_true, end, Col, _, Row, _ ) :- !,
		assert ( tree_link ( Win, Col, Row, end ) ).
	write_link ( Win, b_true, cross, Col, _, Row1, Dir ) :-
		tree_link ( Win, Col, Row0, begin ), !,
		write_line ( Win, Col, Row0, Col, Row1, Dir ).
	write_link ( Win, b_true, cross, Col, _, Row, _ ) :- !,
		assert ( tree_link ( Win, Col, Row, end ) ),
		assert ( tree_link ( Win, Col, Row, begin ) ).
	write_link ( _, _, _, _, _, _, _ ).

	write_link ( Win, _, _, _, _, _ ) :-
		write_mode ( Win, MODE ),
		MODE <> write_, !.
	write_link ( Win, b_true, ColC, ColD, Row, Dir ) :- !,
		write_line ( Win, ColC, Row, ColD, Row, Dir ).
	write_link ( _, _, _, _, _, _ ).

	write_link ( Win, _, _, _ ) :-
		write_mode ( Win, MODE ),
		MODE <> write_, !.
	write_link ( Win, Row1, _, Dir ) :-
		retract ( tree_link ( Win, Col, Row0, end ) ),
		write_line ( Win, Col, Row0, Col, Row1, Dir ), fail.
	write_link ( Win, _, Row1, Dir ) :-
		retract ( tree_link ( Win, Col, Row0, begin ) ),
		write_line ( Win, Col, Row0, Col, Row1, Dir ), fail.
	write_link ( _, _, _, _ ).

	write_line ( Win, _, _, _, _, _ ) :-
		win_SetPen ( Win, pen ( 1, ps_Solid, tree_link_color ) ), fail.
	write_line ( Win, Col0, Row0, Col1, Row1 , write_lr ) :- !,
		draw_line ( Win, pnt ( Col0, Row0 ), pnt ( Col1 , Row1 ) ).
	write_line ( Win, Col0, Row0, Col1, Row1 , write_ud ) :- !,
		draw_line ( Win, pnt ( Row0, Col0 ), pnt ( Row1 , Col1 ) ).

	write_set_mode ( Win, MODE ) :-
		retractall ( write_mode ( Win, _ ) ),
		assert ( write_mode ( Win, MODE ) ), fail.
	write_set_mode ( Win, write_selected ) :- !,
		selection_set_old ( Win ).
	write_set_mode ( Win, write_search ) :- !,
		selection_set_old ( Win ).
	write_set_mode ( _, _ ).

	write_base_clean_up ( Win ) :-
		retractall ( write_mode ( Win, _ ) ),
		retractall ( tree_link ( Win, _, _, _ ) ),
		retractall ( global_link ( Win, _, _ ) ).

/******************************************************************************

		predicates TO MOVE TREE BASE

******************************************************************************/
predicates
	determ move_base ( WINDOW )
	determ move_base_lr ( WINDOW, INTEGER )
	determ move_base_ud ( WINDOW, INTEGER )
	determ move_above_lr ( WINDOW, INTEGER )
	determ move_below_lr ( WINDOW, INTEGER )
	determ move_above_ud ( WINDOW, INTEGER )
	determ move_below_ud ( WINDOW, INTEGER )
	determ move_global_link ( WINDOW, TREE_NODE, TREE_LINK, TREE_LINK )

clauses
	move_base ( Win ) :-
		screen_context ( Win, _, YOff, tree_DirRight ), !,
		move_base_lr ( Win, YOff ).
	move_base ( Win ) :-
		screen_context ( Win, _, YOff, tree_DirLeft ), !,
		move_base_lr ( Win, YOff ).
	move_base ( Win ) :-
		screen_context ( Win, XOff, _, tree_DirUp ), !,
		move_base_ud ( Win, XOff ).
	move_base ( Win ) :-
		screen_context ( Win, XOff, _, tree_DirDown ), !,
		move_base_ud ( Win, XOff ).

	move_base_lr ( Win, Row0 ) :-
		tree_above ( Win, row_mark ( Row1, _, _ ) ),
		Row0 <= Row1, !,
		move_above_lr ( Win, Row0 ).
	move_base_lr ( Win, Row0 ) :-
		tree_below ( Win, row_mark ( Row1, _, _ ) ),
		Row0 > Row1, !,
		move_below_lr ( Win, Row0 ).
	move_base_lr ( _, _ ).

	move_base_ud ( Win, Row0 ) :-
		tree_above ( Win, row_mark ( _, Row1, _ ) ),
		Row0 <= Row1, !,
		move_above_ud ( Win, Row0 ).
	move_base_ud ( Win, Row0 ) :-
		tree_below ( Win, row_mark ( _, Row1, _ ) ),
		Row0 > Row1, !,
		move_below_ud ( Win, Row0 ).
	move_base_ud ( _, _ ).

	move_above_lr ( Win, Row0 ) :-
		retract ( tree_above ( Win, NODE ) ),
		asserta ( tree_below ( Win, NODE ) ),
		move_global_link ( Win, NODE, end, begin ),
		NODE = row_mark ( Row1, _, _ ),
		Row0 > Row1, !.
	move_above_lr ( _, _ ).

	move_below_lr ( Win, Row0 ) :-
		retract ( tree_below ( Win, NODE ) ),
		asserta ( tree_above ( Win, NODE ) ),
		move_global_link ( Win, NODE, begin, end ),
		NODE = row_mark ( Row1, _, _ ),
		Row0 <= Row1, !,
		retract ( tree_above ( Win, NODE1 ) ), !,
		asserta ( tree_below ( Win, NODE1 ) ),
		move_above_lr ( Win, Row1 ).
	move_below_lr ( _, _ ).

	move_above_ud ( Win, Row0 ) :-
		retract ( tree_above ( Win, NODE ) ),
		asserta ( tree_below ( Win, NODE ) ),
		move_global_link ( Win, NODE, end, begin ),
		NODE = row_mark ( _, Row1, _ ),
		Row0 > Row1, !.
	move_above_ud ( _, _ ).

	move_below_ud ( Win, Row0 ) :-
		retract ( tree_below ( Win, NODE ) ),
		asserta ( tree_above ( Win, NODE ) ),
		move_global_link ( Win, NODE, begin, end ),
		NODE = row_mark ( _, Row1, _ ),
		Row0 <= Row1, !,
		retract ( tree_above ( Win, NODE1 ) ), !,
		asserta ( tree_below ( Win, NODE1 ) ),
		move_above_ud ( Win, Row1 ).
	move_below_ud ( _, _ ).

	move_global_link ( Win, node ( ColLR, _, _, ColUD, _, _, _, _, _, _, _, _, _, A, _ ), A, _ ) :- !,
		assert ( global_link ( Win, ColLR, ColUD ) ).
	move_global_link ( Win, node ( ColLR, _, _, ColUD, _, _, _, _, _, _, _, _, _, R, _ ), _, R ) :- !,
		retract ( global_link ( Win, ColLR, ColUD ) ), !.
	move_global_link ( _, _, _, _ ).

/******************************************************************************

		SCROLL predicates

******************************************************************************/
constants
	scroll_lr       = 0
	scroll_ud       = 1

database - scroll_base
	h_scroll( WINDOW, REAL)
	v_scroll( WINDOW, REAL)

predicates
	determ scroll_tree ( WINDOW, INTEGER, INTEGER )
	determ scroll_adjust ( WINDOW, INTEGER, INTEGER, INTEGER )
	determ scroll_get_bar( WINDOW, INTEGER, SCROLL_TYPE, REAL)
	determ scroll_update ( WINDOW, INTEGER, INTEGER, INTEGER )
	determ scroll_update_get_size ( WINDOW, INTEGER, INTEGER, INTEGER )
	determ scroll_update_get_range ( WINDOW, INTEGER, INTEGER, INTEGER, INTEGER, REAL)
	determ scroll_update_set_scroll ( WINDOW, INTEGER, REAL)
	determ scroll_base_clean_up ( WINDOW )
	determ scroll_null(INTEGER,INTEGER)	% BB! 13.10.97
	procedure get_ratio(INTEGER, REAL)

clauses

	scroll_null(0,0):-!.	% BB! 13.10.97

	scroll_tree ( Win, Dx, Dy ) :-
		scroll_adjust ( Win, scroll_lr, Dx, Dx_ ),
		scroll_adjust ( Win, scroll_ud, Dy, Dy_ ),
		not(scroll_null(Dx_,Dy_)),
		retract ( screen_context ( Win, X, Y, Dir ) ), !,
		X_ = X - Dx_,
		Y_ = Y - Dy_,
		assert ( screen_context ( Win, X_, Y_ , Dir ) ),
		scroll_update ( Win, Dir, X_, Y_ ),
		RCT = win_GetClientRect ( Win ),
		win_Scroll ( Win, RCT, Dx_, Dy_ ),
		win_Update(Win).
	scroll_tree ( _, _, _ ).

	scroll_adjust( _, _, 0, 0):-!.
	scroll_adjust( Win, scroll_lr, _, 0):-
		not(h_scroll( Win, _)),!.
	scroll_adjust( Win, scroll_ud, _, 0):-
		not(v_scroll( Win, _)),!.
	scroll_adjust( Win, SDir, Scroll, Pos1):-
		Scroll > 0,
		scroll_get_bar( Win, SDir, SB, Ratio),
		Pos = win_GetScrollPos( Win, SB),
		Pos1 = Pos * Ratio,
		Pos1 <=  Scroll,!.
	scroll_adjust( Win, SDir, Scroll, Scroll1):-
		Scroll < 0,
		scroll_get_bar( Win, SDir, SB, Ratio),
		win_GetScrollRange( Win, SB, _, Range),
		Pos = win_GetScrollPos( Win, SB),
		Scroll1 = (Pos - Range) * Ratio,
		Scroll1 >= Scroll,
		!.
	scroll_adjust( _, _, Scroll, Scroll).

	scroll_get_bar( Win, scroll_lr, sb_Horz, Ratio):-
		h_scroll( Win, Ratio),!.
	scroll_get_bar ( Win, scroll_ud, sb_Vert, Ratio):-
		v_scroll( Win, Ratio),!.

	scroll_update( Win, Dir, HPos, VPos):-
		RCT = win_GetClientRect(Win),
		RCT = rct( L, T, R, B),
		SWidth = R - L,
		SHeight = B - T,
		scroll_update_get_size( Win, Dir, TWidth, THeight),
		scroll_update_get_range( Win, scroll_lr, TWidth, SWidth, HRange, HRatio),
		scroll_update_get_range( Win, scroll_ud, THeight, SHeight, VRange, VRatio),
		win_SetScrollRange( Win, sb_Horz, 0, HRange),
		win_SetScrollRange( Win, sb_Vert, 0, VRange),
		HPos1 = val(integer, HPos / HRatio),
		VPos1 = val(integer, VPos / VRatio),
		win_SetScrollPos( Win, sb_Horz, HPos1),
		win_SetScrollPos(Win, sb_Vert, VPos1),
		move_base(Win).

	scroll_update_get_size ( Win, tree_DirRight, Width, Height ) :- !,
		tree_size ( Win, Width, Height, _, _, _ ), !.
	scroll_update_get_size ( Win, tree_DirLeft, Width, Height ) :- !,
		tree_size ( Win, Width, Height, _, _, _ ), !.
	scroll_update_get_size ( Win, tree_DirUp, Width, Height ) :- !,
		tree_size ( Win, _, _, Width, Height, _ ), !.
	scroll_update_get_size ( Win, tree_DirDown, Width, Height ) :- !,
		tree_size ( Win, _, _, Width, Height, _ ), !.

	scroll_update_get_range( Win, Dir, T, S, Range1, Ratio):-
		T > S, !,
		Range = T - S,
		get_ratio(Range, Ratio),
		Range1 = val(integer,Range / Ratio),
		scroll_update_set_scroll( Win, Dir, Ratio).
	scroll_update_get_range( Win, scroll_lr, _, _, 0, 1.0):-!,
		retractall(h_scroll( Win, _)).
	scroll_update_get_range( Win, scroll_ud, _, _, 0, 1.0):-!,
		retractall(v_scroll( Win, _)).

	scroll_update_set_scroll( Win, scroll_lr, Ratio):-
		retract(h_scroll( Win, _)),!,
		assert(h_scroll( Win, Ratio)).
	scroll_update_set_scroll( Win, scroll_lr, Ratio):-!,
		assert(h_scroll( Win, Ratio)).
	scroll_update_set_scroll( Win, scroll_ud, Ratio):-
		retract(v_scroll( Win, _)),!,
		assert(v_scroll( Win, Ratio)).
	scroll_update_set_scroll( Win, scroll_ud, Ratio):-!,
		assert(v_scroll( Win, Ratio)).

	scroll_base_clean_up( Win):-
		retractall(h_scroll( Win, _)),
		retractall(v_scroll( Win, _)).

	get_ratio(Range, 1.0):-
		Range <= 32767,!.
	get_ratio(Range, Ratio):-
		Ratio = Range / 32767,!.

/******************************************************************************

		SIZE HANDLING

******************************************************************************/
predicates
	determ resize_tree ( WINDOW )
	determ resize_offset ( INTEGER, INTEGER, INTEGER, INTEGER )
	determ resize_invalidate ( WINDOW, INTEGER, INTEGER, INTEGER, INTEGER )

clauses
	resize_tree ( Win ) :-
		retract ( screen_context ( Win, X, Y, Dir ) ),
		scroll_update_get_size ( Win, Dir, TWidth, THeight ),
		RCT = win_GetClientRect ( Win ),
		RCT = rct ( L, T, R, B ),
		SWidth = R - L,
		SHeight = B - T,
		resize_offset ( TWidth, SWidth, X, X_ ),
		resize_offset ( THeight, SHeight, Y, Y_ ),
		assert ( screen_context ( Win, X_, Y_, Dir ) ),
		scroll_update ( Win, Dir, X_, Y_ ),
		resize_invalidate ( Win, X, X_, Y, Y_ ), !.
	resize_tree ( _ ).

	resize_offset ( T, S, _, 0 ) :-
		S >= T, !.
	resize_offset ( _, _, O, 0 ) :-
		O <= 0, !.
	resize_offset ( T, S, O, O_ ) :-
		S + O >= T, !,
		O_ = T - S.
	resize_offset ( _, _, O, O ).

	resize_invalidate ( _, X, X, Y, Y ) :- !.
	resize_invalidate ( Win, _, _, _, _ ) :-
		win_Invalidate ( Win ).

/******************************************************************************

		CONVERT predicates

******************************************************************************/
constants
	convert                         = 0
	convert_base_                   = 1
	convert_to_closed_base          = 2
	convert_open                    = 3
	convert_close_tree_base         = 4
	convert_close_closed_base       = 5

	convert_close                   = 0
	convert_not                     = 1
	convert_single                  = 2
	convert_choosen                 = 3
	convert_double                  = 4
	convert_close_                  = 5

database - closed_base
	closed_above ( WINDOW, TREE_NODE )
	closed_below ( WINDOW, TREE_NODE )

predicates
	determ closed_base_clean_up ( WINDOW )
	determ closed_base_copy ( WINDOW From, WINDOW To )

clauses
	closed_base_clean_up ( Win ) :-
		retractall ( closed_above ( Win, _ ) ),
		retractall ( closed_below ( Win, _ ) ).

	closed_base_copy ( From, To ) :-
		closed_above ( From, NODE ),
		assertz ( closed_above ( To, NODE ) ), fail.
	closed_base_copy ( From, To ) :-
		closed_below ( From, NODE ),
		assertz ( closed_below ( To, NODE ) ), fail.
	closed_base_copy ( _, _ ).

database - convert_base
	convert_window ( WINDOW )
	tree_convert ( TREE_NODE )
	tree_height ( INTEGER, INTEGER, INTEGER )
	registered_selector ( TREE_SELECTOR, BOOLEAN )
	max_off_lr ( INTEGER )
	max_off_ud ( INTEGER )

predicates
	determ convert_tree ( WINDOW, TREE, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, TREE_SELECTOR, TREE_SELECTOR, INTEGER )
	determ convert_begin ( WINDOW, TREE, INTEGER, TREE_SELECTOR, TREE_SELECTOR, INTEGER )
	determ convert_main ( WINDOW, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, TREE_SELECTOR, INTEGER )
	determ convert_main_ ( WINDOW, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, TREE_SELECTOR, TREE_NODE )
	determ convert_tree_base ( WINDOW, TREE, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, BOOLEAN, TREE_LINK, INTEGER )
	determ convert_treelist_base ( WINDOW, TREELIST, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, BOOLEAN, BOOLEAN, INTEGER )
	determ convert_treelist_base ( TREELIST, BOOLEAN )
	determ convert_node_base ( WINDOW, TREE_NODE, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER )
	nondeterm convert_get_child ( WINDOW, TREE_NODE, INTEGER, INTEGER, INTEGER )
	determ convert_nodelist_base ( WINDOW, TREE_NODE_LIST, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER )
	determ convert_max ( INTEGER, INTEGER, INTEGER )
	nondeterm convert_set_closed_base ( WINDOW, INTEGER )
	determ convert_set_closed_base ( WINDOW, TREE_SELECTOR, INTEGER )
	determ convert_get_J ( WINDOW, INTEGER, INTEGER )
	determ convert_closed ( WINDOW, TREE_NODE, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER )
	determ convert_node ( WINDOW, TREE_NODE, INTEGER, INTEGER, INTEGER, INTEGER )
	determ convert_get_coord ( WINDOW, TREE_NODE, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER )
	determ convert_node ( WINDOW, TREE_NODE, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, TREE_SELECTOR, INTEGER, INTEGER )
	determ convert_node ( WINDOW, TREE_NODE, INTEGER )
	determ convert_get_shift ( INTEGER, INTEGER, INTEGER, BOOLEAN, BOOLEAN, INTEGER )
	determ convert_get_range ( WINDOW, INTEGER, INTEGER, INTEGER, INTEGER )
	determ convert_get_size ( WINDOW, INTEGER, INTEGER, INTEGER, INTEGER )
	determ convert_get_node_context ( INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER )
	determ convert_get_node_context ( INTEGER, INTEGER, INTEGER, INTEGER )
	determ convert_row ( WINDOW, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER )
	nondeterm convert_row ( INTEGER, INTEGER )
	determ convert_row ( ILIST , INTEGER, INTEGER )
	determ convert_register_selector ( WINDOW, TREE )
	determ convert_register_selector ( WINDOW, TREE_SELECTOR, BOOLEAN, BOOLEAN )
	determ convert_register_selector_ ( WINDOW, TREELIST )
	determ convert_register_multiple ( WINDOW, TREE_SELECTOR )
	determ convert_multiple ( WINDOW, TREE_NODE )
	determ convert_multiple ( WINDOW, TREE_NODE, INTEGER )
	determ convert_adjust_tree_size ( TREE_NODE, INTEGER )
	determ convert_adjust_tree_size_lr ( INTEGER )
	determ convert_adjust_tree_size_ud ( INTEGER )
	nondeterm convert_for ( INTEGER, INTEGER, INTEGER )

clauses
	convert_tree ( Win, Tree, ColLR_sel, ColUD_sel, I_sel, J_sel, J_sel_, K_sel, Selector, MarkSel, Mode ) :-
		retractall ( _, convert_base ),
		convert_begin ( Win, Tree, J_sel, Selector, MarkSel, Mode ),
		convert_get_J ( Win, J_sel_, Mode ),
		convert_main ( Win, ColLR_sel, ColUD_sel, I_sel, J_sel, J_sel_, K_sel, Selector, Mode ),
		convert_get_range ( Win, J_sel, N_, N__, Mode ),
		convert_for ( I, N_, N__ ),
		convert_row ( Win, I, RowLR, RowMarkLR, RowUD, RowMarkUD ),
		asserta ( tree_above ( Win, row_mark ( RowMarkLR, RowMarkUD, I ) ) ),
		retract ( tree_convert ( node ( ColLR, ColLR_, _, ColUD, ColUD_, _, I, J, K, Drawing, Closed, In, Out, Link, ArrowType ) ) ),
		NODE = node ( ColLR, ColLR_, RowLR, ColUD, ColUD_, RowUD, I, J, K, Drawing, Closed, In, Out, Link, ArrowType ),
		asserta ( tree_above ( Win, NODE ) ),
		convert_multiple ( Win, NODE ),
		move_global_link ( Win, NODE, begin, end ),
		convert_adjust_tree_size ( NODE, Mode ),
		fail.
	convert_tree ( Win, _, _, _, _, _, 0, _, _, _, convert ) :- !,
		retract ( tree_size ( Win, WidLR, HeiLR, _, HeiUD, N ) ), !,
		tree_height ( _, _, WidUD ), !,
		assert ( tree_size ( Win, WidLR, HeiLR, WidUD, HeiUD, N ) ),
		retractall ( _, convert_base ).
	convert_tree ( Win, _, _, _, _, _, 0, _, _, _, convert_base_ ) :- !,
		retract ( tree_size ( Win, WidLR, HeiLR, _, HeiUD, N ) ), !,
		tree_height ( _, _, WidUD ), !,
		assert ( tree_size ( Win, WidLR, HeiLR, WidUD, HeiUD, N ) ),
		retractall ( _, convert_base ).
	convert_tree ( Win, _, _, _, _, J_sel, J_sel_, _, _, _, Mode ) :-
		convert_get_size ( Win, J_sel, J_sel_, N, Mode ),
		win_GetFontMetrics( Win, _, Ascent, Descent),
		Height = Ascent + Descent + 2 * tree_frame_ver + 2 * tree_skip,
		HeiLR =  ( N div 2 + 1 ) * Height,
		max_off_lr ( WidLR ),
		max_off_ud ( HeiUD ),
		tree_height ( _, _, WidUD ), !,
		retractall ( tree_size ( Win, _, _, _, _, _ ) ),
		assert ( tree_size ( Win, WidLR, HeiLR, WidUD, HeiUD, N ) ),
		retractall ( _, convert_base ).
	convert_tree ( _, _, _, _, _, _, 0, _, _, _, _ ) :-
		retractall ( _, convert_base ).

	convert_begin ( Win, _, _, _, _, Mode ) :-
		Mode <> convert_close_closed_base,
		write_base_clean_up ( Win ),
		write_set_mode ( Win, write_ ), fail.
	convert_begin ( Win, Tree, _, _, _, convert ) :- !,
		convert_register_selector ( Win, Tree ),
		convert_tree_base ( Win, Tree, 0, Y, 0, 0, MaxOffLR, 0, MaxOffUD, b_false, line, convert ),
		N = Y * 2 - 1,
		win_GetFontMetrics( Win, _, Ascent, Descent),
		Height = Ascent + Descent + 2 * tree_frame_ver + 2 * tree_skip,
		TreeHeightLR = Y * Height,
		retractall ( tree_size ( Win, _, _, _, _, _ ) ),
		assert ( tree_size ( Win, MaxOffLR, TreeHeightLR, 0, MaxOffUD, N ) ).
	convert_begin ( Win, _, _, _, _, convert_base_ ) :-
		retractall ( opened_multiple_in_tree_base ( Win, _ ) ),
		retract ( tree_above ( Win, NODE ) ),
		asserta ( tree_below ( Win, NODE ) ), fail.
	convert_begin ( Win, _, _, _, _, convert_base_ ) :-
		tree_size ( Win, _, _, _, _, N ),
		I = N div 2,
		convert_get_child ( Win, NODE, I, I, 0 ),
		convert_node_base ( Win, NODE, 0, MaxOffLR, 0, MaxOffUD, convert_base_ ),
		win_GetFontMetrics( Win, _, Ascent, Descent),
		Height = Ascent + Descent + 2 * tree_frame_ver + 2 * tree_skip,
		TreeHeightLR = ( N + 1 ) div 2 * Height,
		retractall ( tree_size ( Win, _, _, _, _, _ ) ),
		assert ( tree_size ( Win, MaxOffLR, TreeHeightLR, 0, MaxOffUD, N ) ),
		retractall ( tree_above ( Win, _ ) ),
		retractall ( tree_below ( Win, _ ) ), fail.
	convert_begin ( Win, _, _, _, _, convert_base_ ) :-
		retractall ( opened_multiple_in_closed_base ( Win, _ , _ ) ),
		retract ( closed_below ( Win, NODE ) ),
		asserta ( closed_above ( Win, NODE ) ), fail.
	convert_begin ( Win, _, _, _, _, convert_base_ ) :-
		convert_set_closed_base ( Win, J ),
		findall ( NODE, convert_get_child ( Win, NODE, J, J, tree_link_width ), List ),
		convert_nodelist_base ( Win, List, tree_link_width, 0, _, tree_link_width, 0, _, convert_to_closed_base ),
		retractall ( tree_below ( Win, _ ) ), fail.
	convert_begin ( _, _, _, _, _, convert_base_ ) :- !.
	convert_begin ( Win, _, _, _, _, Mode ) :-
		Mode <> convert_close_closed_base,
		retractall ( opened_multiple_in_tree_base ( Win, _ ) ),
		assert ( max_off_lr ( 0 ) ),
		assert ( max_off_ud ( 0 ) ),
		retract ( tree_above ( Win, NODE ) ),
		asserta ( tree_below ( Win, NODE ) ), fail.
	convert_begin ( Win, _, _, _, _, Mode ) :-
		Mode <> convert_close_tree_base,
		retract ( closed_above ( Win, NODE ) ),
		asserta ( closed_below ( Win, NODE ) ), fail.
	convert_begin ( Win, _, J_sel, Selector, _, Mode ) :-
		Mode <> convert_open,
		assertz ( closed_below ( Win, closed_mark ( Selector, J_sel ) ) ), fail.
	convert_begin ( Win, _, _, Selector, _, convert_open ) :- !,
		convert_set_closed_base ( Win, Selector, _ ).
	convert_begin ( _, _, _, _, _, convert_close_tree_base ) :- !.
	convert_begin ( Win, _, J_sel, _, MarkSel, convert_close_closed_base ) :- !,
		convert_set_closed_base ( Win, MarkSel, N ),
		retract ( closed_above ( Win, closed_mark ( _, _ ) ) ), !,
		N_ = N - J_sel,
		asserta ( closed_above ( Win, closed_mark ( MarkSel, N_ ) ) ).

	convert_main ( Win, ColLR_sel, ColUD_sel, I_sel, J_sel, _, K_sel, Selector, convert_close_closed_base ) :-
		retract ( closed_below ( Win, NODE ) ), !,
		convert_main_ ( Win, ColLR_sel, ColUD_sel, I_sel, J_sel, K_sel, Selector, NODE ).
	convert_main ( Win, ColLR_sel, ColUD_sel, I_sel, J_sel, J_sel_, K_sel, Selector, Mode ) :-
		Mode <> convert,
		Mode <> convert_base_,
		retract ( tree_below ( Win, NODE ) ),
		convert_closed ( Win, NODE, ColLR_sel, ColUD_sel, I_sel, K_sel, Mode ),
		convert_get_coord ( Win, NODE, J_sel, I, J, K, Mode ),
		convert_get_node_context ( I_sel, J_sel, K_sel, I, J, K, Context ),
		convert_node ( Win, NODE, ColLR_sel, ColUD_sel, I_sel, J_sel, J_sel_, K_sel, Selector, Context, Mode ), fail.
	convert_main ( _, _, _, _, _, _, _, _, _ ).

	convert_main_ ( Win, _, _, _, _, _, _, NODE ) :-
		NODE = closed_mark ( MarkSel, J ), !,
		asserta ( closed_above ( Win, closed_mark ( MarkSel, J ) ) ).
	convert_main_ ( Win, ColLR_sel, ColUD_sel, I_sel, J_sel, K_sel, Selector, NODE ) :-
		NODE = node ( _, _, _, _, _, _, I, J, K, _, _, _, _, _, _ ),
		convert_get_node_context ( I_sel, J_sel, K_sel, I, J, K, Context ),
		convert_node ( Win, NODE, ColLR_sel, ColUD_sel, I_sel, J_sel, 0, K_sel, Selector, Context, convert_close_closed_base ),
		convert_main ( Win, ColLR_sel, ColUD_sel, I_sel, J_sel, 0, K_sel, Selector, convert_close_closed_base ).

	convert_tree_base ( Win, tree ( Selector, _, List, ArrowType ), X, Y, K, OffLR, MaxOffLR, OffUD, MaxOffUD, In, Link, Mode ) :-
		win_GetTextExtent ( Win, Selector, -1, Width, _ ),
		win_GetFontMetrics( Win, _, Ascent, Descent),
		Height = Ascent + Descent,
		OffLR1 = OffLR + tree_link_width,
		OffUD1 = OffUD + tree_link_width,
		OffLR2 = OffLR1 + Width + 2 * tree_frame_hor,
		OffUD2 = OffUD1 + Height + 2 * tree_frame_ver,
		OffLR3 = OffLR2 + tree_link_width,
		OffUD3 = OffUD2 + tree_link_width,
		convert_treelist_base ( Win, List, X, Y, K, OffLR3, 0, MaxOffLR, OffUD3, 0, MaxOffUD, b_true, b_true, Mode ),
		convert_treelist_base ( List, Out ),
		I = X + Y - 1,
		J = Y - X - 1,
		convert_register_selector ( Win, Selector, Out, Closed ),
		NODE = node ( OffLR1, OffLR2, 0, OffUD1, OffUD2, 0, I, J, K, Selector, Closed, In, Out, Link, ArrowType ),
		convert_node ( Win, NODE, Mode ).

	convert_treelist_base ( _, [], X0, X1, _, OffLR, 0, OffLR, OffUD, 0, OffUD, _, b_true, _ ) :- !,
		X1 = X0 + 1.
	convert_treelist_base ( Win, [H], X0, X1, K, OffLR, 0, MaxOffLR, OffUD, 0, MaxOffUD, In, b_true, Mode ) :- !,
		K_ = K + 1,
		convert_tree_base ( Win, H, X0, X1, K_, OffLR, MaxOffLR, OffUD, MaxOffUD, In, line, Mode ).
	convert_treelist_base ( Win, [H|T], X0, X2, K, OffLR, 0, MaxOffLR, OffUD, 0, MaxOffUD, In, b_true, Mode ) :- !,
		convert_tree_base ( Win, H, X0, X1, 0, OffLR, OffLR1, OffUD, OffUD1, In, begin, Mode ),
		convert_treelist_base ( Win, T, X1, X2, K, OffLR, OffLR1, MaxOffLR, OffUD, OffUD1, MaxOffUD, In, b_false, Mode ).
	convert_treelist_base ( Win, [H], X0, X1, _, OffLR, MaxOffLR0, MaxOffLR1, OffUD, MaxOffUD0, MaxOffUD1, In, b_false, Mode ) :- !,
		convert_tree_base ( Win, H, X0, X1, 0, OffLR, OffLR1, OffUD, OffUD1, In, end, Mode ),
		convert_max ( MaxOffLR0, OffLR1, MaxOffLR1 ),
		convert_max ( MaxOffUD0, OffUD1, MaxOffUD1 ).
	convert_treelist_base ( Win, [H|T], X0, X2, K, OffLR, MaxOffLR0, MaxOffLR2, OffUD, MaxOffUD0, MaxOffUD2, In, b_false, Mode ) :- !,
		convert_tree_base ( Win, H, X0, X1, 0, OffLR, OffLR1, OffUD, OffUD1, In, cross, Mode ),
		convert_max ( MaxOffLR0, OffLR1, MaxOffLR1 ),
		convert_max ( MaxOffUD0, OffUD1, MaxOffUD1 ),
		convert_treelist_base ( Win, T, X1, X2, K, OffLR, MaxOffLR1, MaxOffLR2, OffUD, MaxOffUD1, MaxOffUD2, In, b_false, Mode ).

	convert_treelist_base ( [], b_false ) :- !.
	convert_treelist_base ( _, b_true ).

	convert_node_base ( Win, node ( _, Col, _, _, _, _, I, J, K, Selector, Closed, In, Out, Link, ArrowType ), OffLR, MaxOffLR, OffUD, MaxOffUD, Mode ) :-
		win_GetTextExtent ( Win, Selector, -1, Width, _ ),
		win_GetFontMetrics( Win, _, Ascent, Descent),
		Height = Ascent + Descent,
		OffLR1 = OffLR + tree_link_width,
		OffUD1 = OffUD + tree_link_width,
		OffLR2 = OffLR1 + Width + 2 * tree_frame_hor,
		OffUD2 = OffUD1 + Height + 2 * tree_frame_ver,
		OffLR3 = OffLR2 + tree_link_width,
		OffUD3 = OffUD2 + tree_link_width,
		Col_ = Col + tree_link_width,
		findall ( NODE_, convert_get_child ( Win, NODE_, I, J, Col_ ), List ),
		convert_nodelist_base ( Win, List, OffLR3, 0, MaxOffLR, OffUD3, 0, MaxOffUD, Mode ),
		NODE = node ( OffLR1, OffLR2, 0, OffUD1, OffUD2, 0, I, J, K, Selector, Closed, In, Out, Link, ArrowType ),
		convert_multiple ( Win, NODE, Mode ),
		convert_node ( Win, NODE, Mode ).

	convert_get_child ( Win, NODE, I, J, Col ) :-
		Col_ = Col + tree_link_width,
		tree_below ( Win, NODE ),
		NODE = node ( Col_, _, _, _, _, _, I_, J_, _, _, _, _, _, _, _ ),
		I_ - J_ >= I - J,
		I_ + J_ <= I + J.

	convert_nodelist_base ( _, [], OffLR, _, OffLR, OffUD, _, OffUD, _ ) :- !.
	convert_nodelist_base ( Win, [H|T], OffLR, MaxOffLR0, MaxOffLR2, OffUD, MaxOffUD0, MaxOffUD2, Mode ) :- !,
		convert_node_base ( Win, H, OffLR, OffLR1, OffUD, OffUD1, Mode ),
		convert_nodelist_base ( Win, T, OffLR, MaxOffLR0, MaxOffLR1, OffUD, MaxOffUD0, MaxOffUD1, Mode ),
		convert_max ( MaxOffLR1, OffLR1, MaxOffLR2 ),
		convert_max ( MaxOffUD1, OffUD1, MaxOffUD2 ).

	convert_max ( X, Y, X ) :-
		X >= Y, !.
	convert_max ( _, Y, Y ).

	convert_set_closed_base ( Win, J ) :-
		retract ( closed_above ( Win, NODE ) ),
		asserta ( tree_below ( Win, NODE ) ),
		NODE = closed_mark ( _, J ),
		assertz ( closed_below ( Win, NODE ) ).

	convert_set_closed_base ( Win, Selector, J ) :-
		retract ( closed_below ( Win, NODE ) ),
		asserta ( closed_above ( Win, NODE ) ),
		NODE = closed_mark ( Selector, J ), !.

	convert_get_J ( Win, J, convert_open ) :- !,
		closed_above ( Win, closed_mark ( _, J ) ), !.
	convert_get_J ( _, 0, _ ).

	convert_closed ( Win, row_mark ( _, _, I_sel ), ColLR_sel, ColUD_sel, I_sel, K_sel, convert_open ) :-
		retract ( closed_below ( Win, NODE ) ),
		convert_node ( Win, NODE, ColLR_sel, ColUD_sel, I_sel, K_sel ), !.
	convert_closed ( _, _, _, _, _, _, _ ).

	convert_node ( Win, closed_mark ( Sel, J ), _, _, _, _ ) :- !,
		asserta ( closed_below ( Win, closed_mark ( Sel, J ) ) ).
	convert_node ( Win, NODE, ColLR_sel, ColUD_sel, I_sel, K_sel ) :-
		NODE = node ( ColLR, ColLR_, RowLR, ColUD, ColUD_, RowUD, 0, J_sel_, K, Sel, Closed, In, Out, Link, ArrowType ),
		closed_above ( Win, closed_mark ( _, J_sel_ ) ), !,
		K_ = K + K_sel,
		ColLR1 = ColLR + ColLR_sel,
		ColUD1 = ColUD + ColUD_sel,
		ColLR_1 = ColLR_ + ColLR_sel,
		ColUD_1 = ColUD_ + ColUD_sel,
		NODE_ = node ( ColLR1, ColLR_1, RowLR, ColUD1, ColUD_1, RowUD, I_sel, J_sel_, K_, Sel, Closed, In, Out, Link, ArrowType ),
		assert ( tree_convert ( NODE_ ) ),
		convert_multiple ( Win, NODE, convert_open ), fail.
	convert_node ( Win, NODE, ColLR_sel, ColUD_sel, I_sel, _ ) :- !,
		NODE = node ( ColLR, ColLR_, RowLR, ColUD, ColUD_, RowUD, I, J, K, Sel, Closed, In, Out, Link, ArrowType ),
		I_ = I + I_sel,
		ColLR1 = ColLR + ColLR_sel,
		ColUD1 = ColUD + ColUD_sel,
		ColLR_1 = ColLR_ + ColLR_sel,
		ColUD_1 = ColUD_ + ColUD_sel,
		NODE_ = node ( ColLR1, ColLR_1, RowLR, ColUD1, ColUD_1, RowUD, I_, J, K, Sel, Closed, In, Out, Link, ArrowType ),
		assert ( tree_convert ( NODE_ ) ),
		convert_multiple ( Win, NODE, convert_open ), fail.

	convert_get_coord ( Win, row_mark ( _, _, I ), J_sel, 0, 0, 0, Mode ) :- !,
		I_ = I - 2 * J_sel - 1,
		convert_row ( Win, I_, RowLR, RowMarkLR, RowUD, RowMarkUD ),
		asserta ( tree_above ( Win, row_mark ( RowMarkLR, RowMarkUD, I_ ) ) ),
		retract ( tree_convert ( node ( ColLR, ColLR_, _, ColUD, ColUD_, _, I_, J, K, Drawing, Closed, In, Out, Link, ArrowType ) ) ),
		NODE = node ( ColLR, ColLR_, RowLR, ColUD, ColUD_, RowUD, I_, J, K, Drawing, Closed, In, Out, Link, ArrowType ),
		asserta ( tree_above ( Win, NODE ) ),
		convert_multiple ( Win, NODE ),
		move_global_link ( Win, NODE, begin, end ),
		convert_adjust_tree_size ( NODE, Mode ), fail.
	convert_get_coord ( _, NODE, _, I, J, K, _ ) :-
		NODE = node ( _, _, _, _, _, _, I, J, K, _, _, _, _, _, _ ).

	convert_node ( Win, NODE, ColLR_sel, ColUD_sel, I_sel, J_sel, _, _, Selector, convert_close, Mode ) :-
		NODE = node ( ColLR, ColLR_, _, ColUD, ColUD_, _, I, J, K, Sel, b_false, In, b_true, Link, ArrowType ),
		multiple_selector ( Win, Sel ), !,
		ColLR1 = ColLR - ColLR_sel,
		ColUD1 = ColUD - ColUD_sel,
		ColLR_1 = ColLR_ - ColLR_sel,
		ColUD_1 = ColUD_ - ColUD_sel,
		I_ = I - I_sel + J_sel,
		NODE_ = node ( ColLR1, ColLR_1, 0, ColUD1, ColUD_1, 0, I_, J, K, Sel, b_false, In, b_true, Link, ArrowType ),
		assertz ( closed_below ( Win, NODE_ ) ),
		convert_multiple ( Win, NODE, Mode ),
		assert ( opened_multiple_in_closed_base ( Win, NODE_, Selector ) ).
	convert_node ( Win, node ( ColLR, ColLR_, _, ColUD, ColUD_, _, I, J, K, Sel, Closed, In, Out, Link, ArrowType ), ColLR_sel, ColUD_sel, I_sel, J_sel, _, _, _, convert_close, _ ) :- !,
		ColLR1 = ColLR - ColLR_sel,
		ColUD1 = ColUD - ColUD_sel,
		ColLR_1 = ColLR_ - ColLR_sel,
		ColUD_1 = ColUD_ - ColUD_sel,
		I_ = I - I_sel + J_sel,
		assertz ( closed_below ( Win, node ( ColLR1, ColLR_1, 0, ColUD1, ColUD_1, 0, I_, J, K, Sel, Closed, In, Out, Link, ArrowType ) ) ).
	convert_node ( Win, NODE, _, _, _, _, _, _, _, convert_not, Mode ) :- !,
		convert_node ( Win, NODE, Mode ).
	convert_node ( Win, node ( ColLR, ColLR_, RowLR, ColUD, ColUD_, RowUD, I, J, K, Sel, Closed, In, Out, Link, ArrowType ), _, _, _, J_sel, J_sel_, _, _, convert_single, Mode ) :- !,
		convert_get_shift ( J_sel, J_sel_, Shift, _, _, Mode ),
		I_ = I + Shift,
		J_ = J + Shift,
		convert_node ( Win, node ( ColLR, ColLR_, RowLR, ColUD, ColUD_, RowUD, I_, J_, K, Sel, Closed, In, Out, Link, ArrowType ), Mode ).
	convert_node ( Win, node ( ColLR, ColLR_, RowLR, ColUD, ColUD_, RowUD, I, J, K, Sel, _, In, _, Link, ArrowType ), _, _, _, J_sel, J_sel_, _, _, convert_choosen, Mode ) :- !,
		convert_get_shift ( J_sel, J_sel_, Shift, Closed, Out, Mode ),
		I_ = I + Shift,
		J_ = J + Shift,
		convert_node ( Win, node ( ColLR, ColLR_, RowLR, ColUD, ColUD_, RowUD, I_, J_, K, Sel, Closed, In, Out, Link, ArrowType ), Mode ).
	convert_node ( Win, node ( ColLR, ColLR_, RowLR, ColUD, ColUD_, RowUD, I, J, K, Sel, Closed, In, Out, Link, ArrowType ), _, _, _, J_sel, J_sel_, _, _, convert_double, Mode ) :- !,
		convert_get_shift ( J_sel, J_sel_, Shift, _, _, Mode ),
		I_ = I + 2 * Shift,
		convert_node ( Win, node ( ColLR, ColLR_, RowLR, ColUD, ColUD_, RowUD, I_, J, K, Sel, Closed, In, Out, Link, ArrowType ), Mode ) .
	convert_node ( Win, NODE, ColLR_sel, ColUD_sel, I_sel, J_sel, _, K_sel, Selector, convert_close_, Mode ) :-
		NODE = node ( ColLR, ColLR_, _, ColUD, ColUD_, _, I, J, K, Sel, b_false, In, b_true, Link, ArrowType ),
		multiple_selector ( Win, Sel ), !,
		ColLR1 = ColLR - ColLR_sel,
		ColUD1 = ColUD - ColUD_sel,
		ColLR_1 = ColLR_ - ColLR_sel,
		ColUD_1 = ColUD_ - ColUD_sel,
		I_ = I - I_sel + J_sel,
		K_ = K - K_sel,
		NODE_ = node ( ColLR1, ColLR_1, 0, ColUD1, ColUD_1, 0, I_, J, K_, Sel, b_false, In, b_true, Link, ArrowType ),
		assertz ( closed_below ( Win, NODE_ ) ),
		convert_multiple ( Win, NODE, Mode ),
		assert ( opened_multiple_in_closed_base ( Win, NODE_, Selector ) ).
	convert_node ( Win, node ( ColLR, ColLR_, _, ColUD, ColUD_, _, I, J, K, Sel, Closed, In, Out, Link, ArrowType ), ColLR_sel, ColUD_sel, I_sel, J_sel, _, K_sel, _, convert_close_, _ ) :- !,
		ColLR1 = ColLR - ColLR_sel,
		ColUD1 = ColUD - ColUD_sel,
		ColLR_1 = ColLR_ - ColLR_sel,
		ColUD_1 = ColUD_ - ColUD_sel,
		I_ = I - I_sel + J_sel,
		K_ = K - K_sel,
		assertz ( closed_below ( Win, node ( ColLR1, ColLR_1, 0, ColUD1, ColUD_1, 0, I_, J, K_, Sel, Closed, In, Out, Link, ArrowType ) ) ).

	convert_node ( Win, NODE, convert_to_closed_base ) :- !,
		assertz ( closed_below ( Win, NODE ) ).
	convert_node ( Win, NODE, convert_close_closed_base ) :- !,
		asserta ( closed_above ( Win, NODE ) ).
	convert_node ( _, NODE, _ ) :-
		assert ( tree_convert ( NODE ) ).

	convert_get_shift ( _, J, J, b_false, b_true, convert_open ) :- !.
	convert_get_shift ( J, _, J_, b_true, b_false, _ ) :-
		J_ = -J.

	convert_get_range ( Win, _, 0, N, convert ) :- !,
		tree_size ( Win, _, _, _, _, N ), !.
	convert_get_range ( Win, _, 0, N, convert_base_ ) :- !,
		tree_size ( Win, _, _, _, _, N ), !.
	convert_get_range ( Win, _, N_, N__, convert_open ) :- !,
		closed_above ( Win, closed_mark ( _, J_sel ) ),
		tree_size ( Win, _, _, _, _, N ), !,
		N_ = N - 1,
		N__ = N + 2 * J_sel.
	convert_get_range ( Win, J_sel, N_, N__, convert_close_tree_base ) :- !,
		tree_size ( Win, _, _, _, _, N ), !,
		N_ = N - 2 * J_sel - 1,
		N__ = N_ + 1.
	convert_get_range ( _, _, 0, 0, _ ).

	convert_get_size ( Win, _, J_sel, N_, convert_open ) :- !,
		retract ( closed_above ( Win, closed_mark ( _, J_sel ) ) ), !,
		tree_size ( Win, _, _, _, _, N ), !,
		N_ = N + 2 * J_sel.
	convert_get_size ( Win, J_sel, 0, N_, convert_close_tree_base ) :- !,
		tree_size ( Win, _, _, _, _, N ), !,
		N_ = N - 2 * J_sel.

	convert_get_node_context ( I_sel, J_sel, K_sel, I_sel, J_sel, K_sel, convert_choosen ) :- !.
	convert_get_node_context ( I_sel, J_sel, K_sel, I_sel, J_sel, K, convert_single ) :-
		K < K_sel, !.
	convert_get_node_context ( I_sel, J_sel, _, I_sel, J_sel, _, convert_close_ ) :- !.
	convert_get_node_context ( I_sel, J_sel, _, I, J, _, Context ) :-
		X_sel = I_sel - J_sel,
		Y_sel = I_sel + J_sel,
		X = I - J,
		Y = I + J + 1,
		convert_get_node_context ( X, X_sel, Y_sel, X_ ),
		convert_get_node_context ( Y, X_sel, Y_sel, Y_ ),
		Context = X_ * Y_.

	convert_get_node_context ( A, B, _, 1 ) :-
		A <= B, !.
	convert_get_node_context ( A, _, B, 0 ) :-
		A <= B, !.
	convert_get_node_context ( _, _, _, 2 ).

	convert_row ( _, I, 0, 0, 0, 0 ) :-
		I < 0, !, fail.
	convert_row ( Win, 0, RowLR, Height, RowUD, RowMarkUD ) :- !,
		win_GetFontMetrics( Win, _, Ascent, Descent),
		Height = Ascent + Descent + 2 * tree_frame_ver + 2 * tree_skip,
		RowLR = Height div 2,
		findall ( HeightUD , convert_row ( 0, HeightUD ), ListUD ),
		convert_row ( ListUD, 0, MaxHeightUD ),
		RowUD = MaxHeightUD div 2 + tree_frame_hor + tree_skip,
		retractall ( tree_height ( _, _, _ ) ),
		TreeHeightUD = RowUD + MaxHeightUD div 2 + tree_frame_hor + tree_skip,
		assert ( tree_height ( MaxHeightUD, RowUD, TreeHeightUD ) ),
		RowMarkUD = RowUD + MaxHeightUD div 2.
	convert_row ( Win, I, RowLR, RowMarkLR, RowUD1, RowMarkUD ) :-
		win_GetFontMetrics( Win, _, Ascent, Descent),
		Height = Ascent + Descent + 2 * tree_frame_ver + 2 * tree_skip,
		RowLR = ( I + 1 ) * Height div 2,
		RowMarkLR = ( I + 2 ) * Height div 2,
		findall ( HeightUD , convert_row ( I, HeightUD ), ListUD ),
		convert_row ( ListUD, 0, MaxHeightUD1 ),
		retract ( tree_height ( MaxHeightUD0, RowUD0, _ ) ), !,
		convert_max ( MaxHeightUD0, MaxHeightUD1, MaxHeightUD2 ),
		RowUD1 = RowUD0 + MaxHeightUD2 div 2 + tree_frame_hor + tree_skip,
		TreeHeightUD = RowUD1 + MaxHeightUD1 div 2 + tree_frame_hor + tree_skip,
		assert ( tree_height ( MaxHeightUD1, RowUD1, TreeHeightUD ) ),
		RowMarkUD = RowUD1 + MaxHeightUD1 div 2.

	convert_row ( I, H ) :-
		tree_convert ( node ( H_, H__, _, _, _, _, I, _, _, _, _, _, _, _, _ ) ),
		H = H__ - H_ - 2 * tree_frame_hor.

	convert_row ( [] , H, H ) :- !.
	convert_row ( [H|T] , MaxH0, MaxH2 ) :-
		convert_max ( H, MaxH0, MaxH1 ),
		convert_row ( T, MaxH1, MaxH2 ).

	convert_register_selector ( Win, tree ( Selector, _, [], _ ) ) :-
		registered_selector ( Selector, _ ),!,
		convert_register_multiple ( Win, Selector ).
	convert_register_selector ( _, tree ( Selector, _, TreeList, _ ) ) :-
		registered_selector ( Selector, _ ), !,
		convert_treelist_base ( TreeList, _ ).
	convert_register_selector ( Win, tree ( Selector, _, TreeList, _ ) ) :-
		retract ( registered_selector ( Selector , _ ) ), !,
		assert ( registered_selector ( Selector, b_true ) ),
		convert_register_multiple ( Win, Selector ),
		convert_register_selector_ ( Win, TreeList ).
	convert_register_selector ( Win, tree ( Selector, _, TreeList, _ ) ) :-
		convert_treelist_base ( TreeList, Out ),
		assert ( registered_selector ( Selector, Out ) ),
		convert_register_selector_ ( Win, TreeList ).

	convert_register_selector ( Win, Selector, _, b_false ) :-
		not ( multiple_selector ( Win, Selector ) ), !.
	convert_register_selector ( _, Selector, _, b_false ) :-
		registered_selector ( Selector, b_false ), !.
	convert_register_selector ( _, _, b_true, b_false ) :- !.
	convert_register_selector ( _, _, b_false, b_true ) :- !.

	convert_register_selector_ ( _, [] ) :- !.
	convert_register_selector_ ( Win, [H|T] ) :-
		convert_register_selector ( Win, H ),
		convert_register_selector_ ( Win, T ).

	convert_register_multiple ( Win, Selector ) :-
		multiple_selector ( Win, Selector ), !.
	convert_register_multiple ( Win, Selector ) :-
		assert ( multiple_selector ( Win, Selector ) ).

	convert_multiple ( Win, NODE ) :-
		NODE = node ( _, _, _, _, _, _, _, _, _, Selector, b_false, _, b_true, _, _ ),
		multiple_selector ( Win, Selector ), !,
		assert ( opened_multiple_in_tree_base ( Win, NODE ) ).
	convert_multiple ( _, _ ).

	convert_multiple ( _, _, convert_base_ ) :- !.
	convert_multiple ( Win, NODE, convert_to_closed_base ) :-
		NODE = node ( _, _, _, _, _, _, _, _, _, Selector, b_false, _, b_true, _, _ ),
		multiple_selector ( Win, Selector ),
		tree_below ( Win, closed_mark ( MarkSel, _ ) ), !,
		assert ( opened_multiple_in_closed_base ( Win, NODE, MarkSel ) ).
	convert_multiple ( _, _, convert_to_closed_base ) :- !.
	convert_multiple ( Win, NODE, Mode ) :-
		Mode <> convert_close_tree_base, !,
		closed_above ( Win, closed_mark ( MarkSel, _ ) ),
		retract ( opened_multiple_in_closed_base ( Win, NODE, MarkSel ) ), !.
	convert_multiple ( _, _, _ ).

	convert_adjust_tree_size ( node ( _, ColLR, _, _, ColUD, _, _, _, _, _, _, _, _, _, _ ), Mode ) :-
		Mode <> convert,
		Mode <> convert_base_,
		Mode <> convert_close_closed_base, !,
		OffLR = ColLR + tree_link_width,
		OffUD = ColUD + tree_link_width,
		convert_adjust_tree_size_lr ( OffLR ),
		convert_adjust_tree_size_ud ( OffUD ).
	convert_adjust_tree_size ( _, _ ).
		
	convert_adjust_tree_size_lr ( Off ) :-
		max_off_lr ( MaxOff ),
		Off <= MaxOff, !.
	convert_adjust_tree_size_lr ( Off ) :-
		retract ( max_off_lr ( _ ) ), !,
		assert ( max_off_lr ( Off ) ).

	convert_adjust_tree_size_ud ( Off ) :-
		max_off_ud ( MaxOff ),
		Off <= MaxOff, !.
	convert_adjust_tree_size_ud ( Off ) :-
		retract ( max_off_ud ( _ ) ), !,
		assert ( max_off_ud ( Off ) ).

	convert_for ( I, I, _ ).
	convert_for ( I, I0, N) :-
		I1 = I0 + 1,
		I1 < N,
		convert_for ( I, I1, N ).

include "tree\\vpitree1.pro"
