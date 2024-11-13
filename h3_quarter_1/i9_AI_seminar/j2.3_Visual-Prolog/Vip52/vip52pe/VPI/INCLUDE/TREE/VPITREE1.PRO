/******************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S 
			
			Visual Prolog 

 FileName: VPITREE1.PRO
 PURPOSE: 
 Written by: 
 Comments:
 
******************************************************************************/
/******************************************************************************

		TREE EVENT HANDLER

******************************************************************************/
predicates
	tree_no_handler : EHANDLER
	tree_user_call : EHANDLER
	tree_handler : EHANDLER

clauses
	tree_no_handler ( _, _, _ ) :- !, fail.

	tree_user_call ( W, Event, Ret ) :-
		tree_callback ( W, CALLBACK ), !,
		Ret = CALLBACK ( W, Event ).

	tree_handler ( W, e_Create ( CrData ), Ret ) :- !,
		retract ( convert_window ( Win ) ),
		tree_base_copy ( Win, W ),
		tree_base_clean_up ( Win ),
		selection_base_copy ( Win, W ),
		selection_base_clean_up ( Win ),
		retract ( win_info ( _, I ) ), !,
		assert ( win_info ( W, I ) ),
		I = tree_WinInfo ( FONT, _, _ ),
		win_SetFont ( W, FONT ),
		resize_tree ( W ),
		Ret = tree_user_call ( W, e_Create ( CrData ) ).

	tree_handler ( W, e_Destroy, Ret ) :- !,
		retract ( tree_callback ( W, CALLBACK ) ), !,
		tree_base_clean_up ( W ),
		selection_base_clean_up ( W ),
		search_base_clean_up ( W ),
		write_base_clean_up ( W ),
		scroll_base_clean_up ( W ),
		closed_base_clean_up ( W ),
		Ret = CALLBACK ( W, e_Destroy ).

	tree_handler ( W, e_Update ( UpData ), 0 ) :-
		Tree_BackColor = vpi_GetAttrVal(attr_color_window),
		win_SetPen ( W, pen ( 1, ps_Solid, Tree_backcolor ) ),
		win_SetBrush ( W, brush ( pat_Solid, Tree_backcolor ) ) ,
		draw_Rect ( W, UpData ),
		tree_user_call ( W, e_Update ( UpData ) ), fail.
	tree_handler ( W, e_Update ( _ ), 0 ) :- !,
		write_tree ( W ).

	tree_handler ( W, e_EraseBackground, Ret ) :- !,
		Ret = tree_user_call ( W, e_EraseBackground ).

	tree_handler ( W, e_CloseRequest, Ret ) :- !,
		Ret = tree_user_call ( W, e_CloseRequest ).

	tree_handler ( W, e_EndSession ( R ), Ret ) :- !,
		Ret = tree_user_call ( W, e_EndSession ( R ) ).

	tree_handler ( W, e_Size ( Width, Height ), Ret ) :- !,
		resize_tree ( W ),
		Ret = tree_user_call ( W, e_Size ( Width, Height ) ).

	tree_handler ( W, Event, Ret ) :-
		Ret = tree_user_call ( W, Event ), !.

	tree_handler ( W, e_MouseDown ( PNT, _, _ ), 0 ) :- !,
		retractall ( hit_point ( W, _ ) ),
		assert ( hit_point ( W, PNT ) ),

		write_set_mode ( W, write_selected ),
		write_tree ( W ),
		write_set_mode ( W, write_ ),

		retractall ( hit_point ( W, _ ) ),
		selection_update ( W, b_true ).

	tree_handler ( W, e_Char ( k_Down, _ ), 0 ) :-!,
		win_SendEvent ( W, e_VScroll ( sc_LineDown, 0 ) ).
	tree_handler ( W, e_Char ( k_Up, _ ), 0 ) :-!,
		win_SendEvent ( W, e_VScroll ( sc_LineUp, 0 ) ).
	tree_handler ( W, e_Char ( k_Right, _ ), 0 ) :-!,
		win_SendEvent ( W, e_HScroll ( sc_LineDown, 0 ) ).
	tree_handler ( W, e_Char ( k_Left, _ ), 0 ) :-!,
		win_SendEvent ( W, e_HScroll ( sc_LineUp, 0 ) ).
	tree_handler ( W, e_Char ( k_Prev, _ ), 0 ) :-!,
		win_SendEvent ( W, e_VScroll ( sc_PageUp, 0 ) ).
	tree_handler ( W, e_Char ( k_Next , _ ), 0 ) :-!,
		win_SendEvent ( W, e_VScroll ( sc_PageDown, 0 ) ).
	tree_handler ( W, e_Char ( k_Home, _ ), 0 ) :-!,
		win_SendEvent ( W, e_HScroll ( sc_PageUp, 0 ) ).
	tree_handler ( W, e_Char ( k_End, _ ), 0 ) :-!,
		win_SendEvent ( W, e_HScroll ( sc_PageDown, 0 ) ).

	tree_handler ( W, e_HScroll ( sc_LineDown, _ ), 0 ) :- !,
		scroll_tree ( W, -tree_scroll_hor, 0 ).
	tree_handler ( W, e_HScroll ( sc_LineUp, _ ), 0 ) :- !,
		scroll_tree ( W, tree_scroll_hor, 0 ).
	tree_handler ( W, e_HScroll ( sc_PageDown, _ ), 0 ) :- !,
		RCT = win_GetClientRect ( W ),
		RCT = rct ( L, _, R, _ ),
		Shift = L - R,
		scroll_tree ( W, Shift, 0 ).
	tree_handler ( W, e_HScroll ( sc_PageUp, _ ), 0 ) :- !,
		RCT = win_GetClientRect ( W ),
		RCT = rct ( L, _, R, _ ),
		Shift = R - L,
		scroll_tree ( W, Shift, 0 ).
	tree_handler( W, e_HScroll( sc_ThumbTrack, Pos_), 0):-
		screen_context( W, Pos, _, _ ),
		h_scroll( W, Ratio),!,
		Shift = Pos - val(integer, Pos_ * Ratio),
		scroll_tree( W, Shift, 0).
	tree_handler ( W, e_VScroll ( sc_LineDown, _ ), 0 ) :- !,
		scroll_tree ( W, 0, -tree_scroll_ver ).
	tree_handler ( W, e_VScroll ( sc_LineUp, _ ), 0 ) :- !,
		scroll_tree ( W, 0, tree_scroll_ver ).
	tree_handler ( W, e_VScroll ( sc_PageDown, _ ), 0 ) :- !,
		RCT = win_GetClientRect ( W ),
		RCT = rct ( _, T, _, B ),
		Shift = T - B,
		scroll_tree ( W, 0, Shift ).
	tree_handler ( W, e_VScroll ( sc_PageUp, _ ), 0 ) :- !,
		RCT = win_GetClientRect ( W ),
		RCT = rct ( _, T, _, B ),
		Shift = B - T,
		scroll_tree ( W, 0, Shift ).
	tree_handler( W, e_VScroll( sc_ThumbTrack, Pos_), 0):-
		screen_context( W, _, Pos, _),
		v_scroll( W, Ratio),!,
		Shift = Pos - val(integer, Pos_ * Ratio),
		scroll_tree( W, 0, Shift).

/******************************************************************************

		PRINT predicates

******************************************************************************/
database - print_base
	determ print_bottom ( INTEGER, INTEGER, INTEGER )

predicates
	determ print_tree ( WINDOW, INTEGER, INTEGER, INTEGER, STRING, INTEGER, INTEGER, FONT )
	determ print_tree_page ( WINDOW, INTEGER, INTEGER, INTEGER, INTEGER, FONT )
	determ print_tree_node ( WINDOW, TREE_NODE, INTEGER, INTEGER, INTEGER, INTEGER )
	determ print_link ( WINDOW, INTEGER, INTEGER, BOOLEAN, TREE_LINK, INTEGER, INTEGER, INTEGER )
	determ print_link ( WINDOW, INTEGER, INTEGER, BOOLEAN, INTEGER, INTEGER, INTEGER )
	determ print_link ( WINDOW, INTEGER, INTEGER )
	determ print_line ( WINDOW, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER )
	determ print_frame ( WINDOW, RCT, BOOLEAN, INTEGER )
	determ print_tree_adjust ( WINDOW, INTEGER )
	determ print_move_closed ( WINDOW )
	determ print_node_info ( WINDOW, TREE_SELECTOR, INTEGER, INTEGER, INTEGER, INTEGER, TREE_ARROW_TYPE )
	nondeterm print_get_parent ( WINDOW, INTEGER, INTEGER, INTEGER, TREE_NODE )
	determ print_get_max_parent ( TREE_NODE_LIST, TREE_NODE )

clauses
	print_tree ( Win, StartX, StartY, HeaderHei, Title, PageNo, PageHeight, Font ) :-
		retract ( screen_context ( Win, XOff, YOff, _ ) ), !,
		print_StartPage ( Win ),
		VRP = val( integer, vpi_GetAttrVal ( attr_printer_vres ) ),
		HRP = val( integer, vpi_GetAttrVal ( attr_printer_hres ) ),
		VRS = val( integer, vpi_GetAttrVal ( attr_screen_vres ) ),
		HRS = val( integer, vpi_GetAttrVal ( attr_screen_hres ) ),
		win_SetMapMode ( Win, mm_arbitrary ),
		win_SetMapScale ( Win, pnt ( 0, 0 ), pnt ( VRS, HRS ), pnt ( 0, 0 ), pnt ( VRP, HRP ) ),
		win_SetFont ( Win, Font ),
		format ( Header, "%s  Page -%d-", Title, PageNo ),
		draw_Text ( Win, StartX, StartY, Header ),
		YOff_ = YOff - HeaderHei,
		print_tree_page ( Win, XOff, YOff_, HeaderHei, PageHeight, Font ),
		print_link ( Win, HeaderHei, PageHeight ),
		print_EndPage ( Win ),
		PageNo_ = PageNo + 1,
		print_tree ( Win, StartX, StartY, HeaderHei, Title, PageNo_, PageHeight, Font ).
	print_tree ( _, _, _, _, _, _, _, _ ).

	print_tree_page ( Win, XOff, _, Top, _, Font ) :-
		VRP = val( integer, vpi_GetAttrVal ( attr_printer_vres ) ),
		HRP = val( integer, vpi_GetAttrVal ( attr_printer_hres ) ),
		VRS = val( integer, vpi_GetAttrVal ( attr_screen_vres ) ),
		HRS = val( integer, vpi_GetAttrVal ( attr_screen_hres ) ),
		win_SetMapMode ( Win, mm_arbitrary ),
		win_SetMapScale ( Win, pnt ( 0, 0 ), pnt ( VRS, HRS ), pnt ( 0, 0 ), pnt ( VRP, HRP ) ),
		win_SetFont ( Win, Font ),
		global_link ( Win, Col, _ ),
		Col_ = Col - XOff - tree_link_width,
		assert ( tree_link ( Win, Col_, Top, begin ) ), fail.
	print_tree_page ( Win, XOff, YOff, Top, Bottom, _ ) :-
		tree_below ( Win, NODE ),
		print_tree_node ( Win, NODE, XOff, YOff, Top, Bottom ), !.
	print_tree_page ( _, _, _, _, _, _ ).

	print_tree_node ( Win, row_mark ( MarkLR, _, _ ), XOff, YOff, _, Bottom ) :-
		MarkLR > Bottom + YOff, !,
		print_bottom ( PrintBottom0, _, PrintBottom2 ),
		YOff_ = ( PrintBottom0 + PrintBottom2 ) div 2,
 		assert ( screen_context ( Win, XOff, YOff_, tree_DirRight ) ),
		move_base ( Win ).
	print_tree_node ( _, row_mark ( MarkLR2, _, _ ), _, _, _, _ ) :-
		retract ( print_bottom ( _, MarkLR0, MarkLR1 ) ),
		assert ( print_bottom ( MarkLR0, MarkLR1, MarkLR2 ) ), !, fail.
	print_tree_node ( Win, NODE, XOff, YOff, Top, _ ) :-
		NODE    = node ( Col, Col_, Row, H, H_, _, _, _, _, Drawing, Closed, In, Out, Link, ArrowType ),
		Y = Row - YOff,
		L = Col - XOff,
		R = Col_ - XOff,
		T = Y - ( H_ - H ) div 2,
		B = T + H_ - H,
		RCT = rct ( L, T, R, B ),
		RCT = rct ( Xb, _, Xc, _ ),
		Xa = Xb - tree_link_width,
		Xd = Xc + tree_link_width,
		print_link ( Win, T, Top, In, Link, Xa, Xb, Y ),
		print_link ( Win, T, Top, Out, Xc, Xd, Y ),
		T > Top, !,
		win_GetFontMetrics( Win, _, Ascent, _ ),
		Xt = L + tree_frame_hor,
		Yt = T + tree_frame_ver + Ascent,
		print_frame ( Win, RCT, Closed, ArrowType ),
		draw_text ( Win, Xt, Yt, Drawing ), !, fail.

	print_link ( Win, T, Top, b_true, _, ColA, ColB, Row ) :-
		print_line ( Win, T, Top, ColA, Row, ColB, Row ), fail.
	print_link ( Win, _, _, b_true, begin, Col, _, Row ) :- !,
		assert ( tree_link ( Win, Col, Row, begin ) ).
	print_link ( Win, T, Top, b_true, end, Col, _, Row1 ) :-
		retract ( tree_link ( Win, Col, Row0, begin ) ), !,
		print_line ( Win, T, Top, Col, Row0, Col, Row1 ).
	print_link ( Win, _, _, b_true, end, Col, _, Row ) :- !,
		assert ( tree_link ( Win, Col, Row, end ) ).
	print_link ( Win, T, Top, b_true, cross, Col, _, Row1 ) :-
		tree_link ( Win, Col, Row0, begin ), !,
		print_line ( Win, T, Top, Col, Row0, Col, Row1 ).
	print_link ( Win, _, _, b_true, cross, Col, _, Row ) :- !,
		assert ( tree_link ( Win, Col, Row, end ) ),
		assert ( tree_link ( Win, Col, Row, begin ) ).
	print_link ( _, _, _, _, _, _, _, _ ).

	print_link ( Win, T, Top, b_true, ColC, ColD, Row ) :- !,
		print_line ( Win, T, Top, ColC, Row, ColD, Row ).
	print_link ( _, _, _, _, _, _, _ ).

	print_link ( Win, Row1, _ ) :-
		retract ( tree_link ( Win, Col, Row0, end ) ),
		print_line ( Win, 1, 0, Col, Row0, Col, Row1 ), fail.
	print_link ( Win, _, Row1 ) :-
		retract ( tree_link ( Win, Col, Row0, begin ) ),
		print_line ( Win, 1, 0, Col, Row0, Col, Row1 ), fail.
	print_link ( _, _, _ ).

	print_line ( _, T, Top, _, _, _, _ ) :-
		T <= Top, !.
	print_line ( Win, _, _, _, _, _, _ ) :-
		win_SetPen ( Win, pen ( 1, ps_Solid, tree_link_color ) ), fail.
	print_line ( Win, _, _, Col0, Row0, Col1, Row1 ) :- !,
		draw_line ( Win, pnt ( Col0, Row0 ), pnt ( Col1 , Row1 ) ).

	print_frame ( Win, RCT, b_true, ArrowType ) :- !,
		R_hor = 2 * tree_frame_hor,
		R_ver = 2 * tree_frame_ver,
		write_get_pen ( ArrowType, Pen ),
		win_SetPen ( Win, Pen ),
		draw_RoundRect ( Win, RCT, R_hor, R_ver ).
	print_frame ( Win, RCT, b_false, ArrowType ) :- !,
		write_get_pen ( ArrowType, Pen ),
		win_SetPen ( Win, Pen ),
		draw_Rect ( Win, RCT ).

	print_tree_adjust ( Win, PageWidth ) :-
		print_move_closed ( Win ),
		tree_below ( Win, node ( _, ColLR, _, _, _, _, I, J, _, _, _, _, _, _, _ ) ),
		ColLR + tree_frame_hor > PageWidth, !,
		findall ( Node, print_get_parent ( Win, PageWidth, I, J, Node ), List ),
		print_get_max_parent ( List, Parent ),
		Parent = node ( _, ColLR_par, _, _, ColUD_par, _, I_par, J_par, K_par, Selector, _, _, _, _, _ ),
		convert_tree ( Win, tree ( "", unmarked, [], 0 ), ColLR_par, ColUD_par, I_par, J_par, _, K_par, Selector, "", convert_close_tree_base ),
		move_base ( Win ),
		print_tree_adjust ( Win, PageWidth ).
	print_tree_adjust ( _, _ ).

	print_move_closed ( Win ) :-
		retract ( closed_above ( Win, NODE ) ),
		asserta ( closed_below ( Win, NODE ) ), fail.
	print_move_closed ( Win ) :-
		closed_below ( Win, closed_mark ( Sel, _ ) ),
		retract ( tree_size ( Win, TreeWidth, TreeHeight, _, _, N0 ) ), !,
		N1 = N0 + 1,
		N2 = N0 + 2,
		I = N0 + 3,
		N4 = N0 + 4,
		print_node_info ( Win, Sel, W, W_, ColUD, ColUD_, ArrowType ),
		ColLR = W_ - W + tree_frame_hor,
		Height = ColUD_ - ColUD + 2 * tree_skip,
		RowLR = ( I + 1 ) * Height div 2,
		TreeHeight_ = ( N4 + 1 ) div 2 * Height,
		NODE = node ( tree_frame_hor, ColLR, RowLR, ColUD, ColUD_, 0, I, 0, 0, Sel, b_true, b_false, b_false, line, ArrowType ), 
		assertz ( tree_below ( Win, row_mark ( TreeHeight, 0, N0 ) ) ),
		assertz ( tree_below ( Win, row_mark ( TreeHeight, 0, N1 ) ) ),
		assertz ( tree_below ( Win, row_mark ( TreeHeight, 0, N2 ) ) ),
		assertz ( tree_below ( Win, row_mark ( TreeHeight_, 0, I ) ) ),
		assertz ( tree_below ( Win, NODE ) ),
		assert ( tree_size ( Win, TreeWidth, TreeHeight_, 0, 0, N4 ) ),
		convert_tree ( Win, tree ( "", unmarked, [], 0 ), ColLR, 0, I, 0, _, 0, Sel, "", convert_open ),
		move_base ( Win ),
		print_move_closed ( Win ).
	print_move_closed ( _ ).

	print_node_info ( Win, Sel, ColLR, ColLR_, ColUD, ColUD_, ArrowType ) :-
		tree_below ( Win, node ( ColLR, ColLR_, _, ColUD, ColUD_, _, _, _, _, Sel, _, _, _, _, ArrowType ) ), !.
	print_node_info ( Win, Sel, ColLR, ColLR_, ColUD, ColUD_, ArrowType ) :-
		closed_below ( Win, node ( ColLR, ColLR_, _, ColUD, ColUD_, _, _, _, _, Sel, _, _, _, _, ArrowType ) ), !.

	print_get_parent ( Win, PageWidth, I, J, NODE ) :-
		tree_below ( Win, NODE ),
		NODE = node ( _, ColLR, _, _, _, _, I_, J_, _, _, _, _, _, _, _ ),
		I_ - J_ <= I - J,
		I_ + J_ >= I + J,
		ColLR + tree_frame_hor <= PageWidth.

	print_get_max_parent ( [ H ], H ) :- !.
	print_get_max_parent ( [ node ( _, Col0, _, _, _, _, _, _, _, _, _, _, _, _, _ ) | T ], P ) :-
		print_get_max_parent ( T, P ),
		P = node ( _, Col1, _, _, _, _, _, _, _, _, _, _, _, _, _ ),
		Col1 >= Col0, !.
	print_get_max_parent ( [ H | _ ], H ).

/******************************************************************************

		AUXILIARY predicates

******************************************************************************/
constants
	update_scroll   = 0
	update_full     = 1

database - open_close_info
	closed ( TREE_SELECTOR )
	opened ( SLIST )
	opened_checked ( SLIST )
	selected_route ( SLIST )
	selected_route_checked ( SLIST )

predicates
	determ convert_tree_ ( WINDOW, TREE )
	determ close_node ( WINDOW )
	determ open_node ( WINDOW )
	determ close_opened_in_tree_base ( WINDOW, INTEGER, INTEGER, TREE_SELECTOR )
	determ close_opened_in_closed_base ( WINDOW, INTEGER, INTEGER, TREE_SELECTOR )
	determ adjust_selected ( WINDOW, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER )
	determ adjust_selected ( WINDOW, INTEGER, INTEGER, INTEGER, INTEGER )
	determ set_selected ( WINDOW, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER )
	determ set_selected_ ( WINDOW, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER )
	determ set_selected ( WINDOW, INTEGER, INTEGER, INTEGER )
	determ get_update_mode ( INTEGER, BOOLEAN )
	nondeterm get_selector ( WINDOW, TREE_SELECTOR )
	determ get_font ( TREE_WIN_INFO, FONT )
	determ set_context ( WINDOW, RCT, TREE_WIN_INFO )
	determ get_parent ( WINDOW, INTEGER, INTEGER, INTEGER, TREE_NODE )
	nondeterm parent ( WINDOW, INTEGER, INTEGER, INTEGER, TREE_NODE )
	determ parent_ ( INTEGER, INTEGER, INTEGER, TREE_NODE )
	determ parent ( TREE_NODE_LIST, TREE_NODE )
	determ parent__ ( INTEGER, INTEGER, INTEGER, INTEGER )
	determ INTEGER get_hscroll_height ( WINDOW )
	determ INTEGER get_vscroll_width ( WINDOW )
	determ save_closed ( WINDOW )
	determ restore_closed ( WINDOW )
	determ restore_closed ( WINDOW, TREE_SELECTOR )
	determ save_opened ( WINDOW )
	determ check_opened_or_selected ( TREE, INTEGER )
	determ check_opened_or_selected ( TREE, TREE, SLIST )
	determ check_opened_or_selected_ ( TREE, TREELIST, SLIST )
	determ restore_opened_or_selected ( TREE, TREE, TREE, SLIST, INTEGER )
	determ restore_opened_or_selected ( TREE, TREELIST, TREELIST, TREELIST, SLIST, INTEGER )
	determ tree_member ( SLIST, STRING )
	determ is_subpath ( SLIST, SLIST )
	determ get_subtree ( TREE, TREE_SELECTOR, TREELIST )
	determ get_subtree_ ( TREELIST, TREE_SELECTOR, TREELIST )
	determ reverse_list ( TREELIST, TREELIST, TREELIST )
	determ reverse_list ( SLIST, SLIST, SLIST )
	determ save_selected ( WINDOW )
	determ get_parent_list ( WINDOW, INTEGER, INTEGER, INTEGER, SLIST, SLIST )
	determ restore_selected ( WINDOW )
	determ search_by_route ( WINDOW, SLIST, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER )
	determ order_list ( SLIST, SLIST, SLIST )
	determ max_selector ( TREE_SELECTOR, TREE_SELECTOR, SLIST, SLIST, SLIST )
	determ EHANDLER tree_GetHandler ( WINDOW )

clauses
	convert_tree_ ( Win, Tree ) :-
		convert_tree ( Win, Tree, 0, 0, 0, 0, _, 0, "", "", convert ), !.
	convert_tree_ ( _, _ ) :-
		errorexit ( error_vpi_package_bad_data ).

	close_node ( Win ) :-
		get_selected_node ( Win, NODE ),
		NODE = node ( _, ColLR_sel, _, _, ColUD_sel, _, I_sel, J_sel, K_sel, Selector, b_false, _, b_true, _, _ ), !,
		I = I_sel - J_sel,
		convert_tree ( Win, tree ( "", unmarked, [], 0 ), ColLR_sel, ColUD_sel, I_sel, J_sel, _, K_sel, Selector, "", convert_close_tree_base ),
		set_selected ( Win, I, 0, K_sel, 0, 0, update_full ).

	open_node ( Win ) :-
		selected ( Win, _, 0, _ ),
		get_selected_node ( Win, NODE ),
		NODE =  node ( _, ColLR_sel, _, _, ColUD_sel, _, I_sel, 0, K_sel, Selector, b_true, _, b_false, _, _ ),
		close_opened_in_tree_base ( Win, I_sel , K_sel, Selector ), !,
		close_opened_in_closed_base ( Win, I_sel , K_sel, Selector ),
		selected ( Win, I_sel_, _ , _ ), !,
		convert_tree ( Win, tree ( "", unmarked, [], 0 ), ColLR_sel, ColUD_sel, I_sel_, 0, J_sel, K_sel, Selector, "", convert_open ),
		I = I_sel_ + J_sel,
		set_selected ( Win, I, J_sel, K_sel, 0, 0, update_full ).

	close_opened_in_tree_base ( Win, I_sel, K_sel, Selector ) :-
		opened_multiple_in_tree_base ( Win, node ( _, ColLR, _, _, ColUD, _, I, J, K, Selector, _, _, _, _, _ ) ), !,
		adjust_selected ( Win, I_sel, K_sel, I, J, K ),
		convert_tree ( Win, tree ( "", unmarked, [], 0 ), ColLR, ColUD, I, J, _, K, Selector, "", convert_close_tree_base ).
	close_opened_in_tree_base ( _, _, _, _ ).

	close_opened_in_closed_base ( Win, _, _, Selector ) :-
		retract ( opened_multiple_in_closed_base ( Win, node ( _, ColLR, _, _, ColUD, _, I, J, K, Selector, _, _, _, _, _ ), MarkSel ) ), !,
		convert_tree ( Win, tree ( "", unmarked, [], 0 ), ColLR, ColUD, I, J, _, K, Selector, MarkSel, convert_close_closed_base ).
	close_opened_in_closed_base ( _, _, _, _ ).

	adjust_selected ( Win, I_sel, K_sel, I, J, K ) :-
		convert_get_node_context ( I, J, K, I_sel, 0, K_sel, Context ),
		adjust_selected ( Win, I_sel, K_sel, J, Context ).

	adjust_selected ( _, _, _, _, convert_not ) :- !.
	adjust_selected ( Win, I_sel, K_sel, J, convert_single ) :- !,
		I_sel_ = I_sel - J,
		retractall ( selected ( Win, _, _, _ ) ),
		assert ( selected ( Win, I_sel_, 0, K_sel ) ).
	adjust_selected ( Win, I_sel, K_sel, J, convert_double ) :- !,
		I_sel_ = I_sel - 2 * J,
		retractall ( selected ( Win, _, _, _ ) ),
		assert ( selected ( Win, I_sel_, 0, K_sel ) ).

	set_selected ( Win, I, J, K, Dx, Dy, Update ) :-
		set_selected_ ( Win, I, J, K, Dx, Dy, Update ), !.
	set_selected ( Win, _, _, _, _, _, _ ) :-
		write_base_clean_up ( Win ),
		retract ( tree_above ( Win, NODE ) ),
		asserta ( tree_below ( Win, NODE ) ), fail.
	set_selected ( Win, I, J, K, Dx, Dy, Update ) :-
		set_selected_ ( Win, I, J, K, Dx, Dy, Update ), !.
	set_selected ( _, _, _, _, _, _, _ ).

	set_selected_ ( Win, I, J, K, Dx, Dy, Update ) :-
		screen_context ( Win, X, Y, _ ), !,
		retractall ( search ( Win, _, _, _ ) ),
		assert ( search ( Win, I, J, K ) ),
		write_set_mode ( Win, write_search ),
		write_tree ( Win ),
		write_set_mode ( Win, write_ ),
		get_update_mode ( Update, Update_ ),
		search_rect ( Win, Dx_, Dy_, Update_ ),
		X_ = X - Dx_ + Dx,
		Y_ = Y - Dy_ + Dy,
		set_selected ( Win, X_, Y_, Update ).

	set_selected ( Win, X_, Y_, update_scroll ) :- !,
		screen_context ( Win, X, Y, _ ), !,
		Dx = X - X_,
		Dy = Y - Y_,
		scroll_tree ( Win, Dx, Dy ).
	set_selected ( Win, X_, Y_, update_full ) :-
		retract ( screen_context ( Win, _, _, Dir ) ), !,
		assert ( screen_context ( Win, X_, Y_, Dir ) ),
		resize_tree ( Win ),
		win_Invalidate ( Win ),
		win_Update ( Win ).

	get_update_mode ( update_scroll, b_true ) :- !.
	get_update_mode ( update_full, b_false ) :- !.

	get_selector ( Win, S ) :-
		tree_above ( Win, node ( _, _, _, _, _, _, _, _, _, S, _, _, _, _, _ ) ),
		not ( multiple_selector ( Win, S ) ).
	get_selector ( Win, S ) :-
		tree_below ( Win, node ( _, _, _, _, _, _, _, _, _, S, _, _, _, _, _ ) ),
		not ( multiple_selector ( Win, S ) ).
	get_selector ( Win, S ) :-
		closed_above ( Win, node ( _, _, _, _, _, _, _, _, _, S, _, _, _, _, _ ) ),
		not ( multiple_selector ( Win, S ) ).
	get_selector ( Win, S ) :-
		closed_below ( Win, node ( _, _, _, _, _, _, _, _, _, S, _, _, _, _, _ ) ),
		not ( multiple_selector ( Win, S ) ).
	get_selector ( Win, S ) :-
		multiple_selector ( Win, S ).

	get_font ( tree_WinInfo( F, _, _ ), F ) :- !.
	get_font ( tree_WinInfoAdv( F, _, _, _, _ ), F ) :- !.

	set_context ( Win, _, tree_WinInfo( F, D, A ) ) :- !,
		assert ( win_info ( Win, tree_WinInfo ( F, D, A ) ) ),
		assert ( screen_context ( Win, 0, 0, D ) ),
		assert ( selected ( Win, 0, 0, 0 ) ).
	set_context ( Win, _, tree_WinInfoAdv( F, D, A, List, _ ) ) :-
		assert ( win_info ( Win, tree_WinInfo ( F, D, A ) ) ),
		assert ( screen_context ( Win, 0, 0, D ) ),
		tree_size ( Win, _, _, _, _, N ),
		R = N div 2,
		search_by_route ( Win, List, 0, R, R, 0, I, J, K ),
		set_selected ( Win, I, J, K, 0, 0, update_full ), !.
	set_context ( Win, _, tree_WinInfoAdv( _, _, _, List, _ ) ) :-
		reverse_list ( List, [], List_ ),
		List_ = [ Selector | _ ],
		tree_above ( Win, node ( _, _, _, _, _, _, I, J, K, Selector, _, _, _, _, _ ) ),
		set_selected ( Win, I, J, K, 0, 0, update_full ), !.
	set_context ( Win, _, _ ) :-
		retractall ( selected ( Win, _, _, _ ) ),
		assert ( selected ( Win, 0, 0, 0 ) ).

	get_parent ( Win, I, J, K, Parent ) :-
		findall ( NODE, parent ( Win, I, J, K, NODE ), List ),
		parent ( List, Parent ).

	parent ( Win, I, J, K, NODE ) :-
		tree_above ( Win, NODE ),
		parent_ ( I, J, K, NODE ).
	parent ( Win, I, J, K, NODE ) :-
		tree_below ( Win, NODE ),
		parent_ ( I, J, K, NODE ).

	parent_ ( I, J, K, node ( _, _, _, _, _, _, I, J, K_, _, _, _, _, _, _ ) ) :-
		K_ < K, !.
	parent_ ( I, J, 0, node ( _, _, _, _, _, _, I_, J_, _, _, _, _, _, _, _ ) ) :-
		I_ - J_ <= I - J,
		I_ + J_ >= I + J,
		( I_ - I ) * ( I_ - I ) + ( J_ - J ) * ( J_ - J ) <> 0.

	parent ( [P], P ) :- !.
	parent ( [P0|T], P1 ) :-
		parent ( T, P1 ),
		P0 = node ( _, _, _, _, _, _, _, J0, K0, _, _, _, _, _, _ ),
		P1 = node ( _, _, _, _, _, _, _, J1, K1, _, _, _, _, _, _ ),
		parent__ ( J0, J1, K0, K1 ), !.
	parent ( [P|_], P ).

	parent__ ( J0, J1, _, _ ) :-
		J1 < J0, !.
	parent__ ( J, J, K0, K1 ) :-
		K1 > K0, !.

	get_hscroll_height( Win, HScroll_height):-
		h_scroll( Win, _),!,
		HScroll_height = win_GetAttrVal( Win, attr_ctl_horz_sbar_height).
	get_hscroll_height( _, 0).

	get_vscroll_width( Win, VScroll_width):-
		v_scroll( Win, _),!,
		VScroll_width = win_GetAttrVal( Win, attr_ctl_vert_sbar_width).
	get_vscroll_width( _, 0).

	save_closed ( Win ) :-
		retract ( opened_multiple_in_closed_base ( Win, node ( _, ColLR, _, _, ColUD, _, I, J, K, Selector, _, _, _, _, _ ), MarkSel ) ), !,
		convert_tree ( Win, tree ( "", unmarked, [], 0 ), ColLR, ColUD, I, J, _, K, Selector, MarkSel, convert_close_closed_base ),
		save_closed ( Win ).
	save_closed ( _ ) :-
		retractall ( closed ( _ ) ), fail.
	save_closed ( Win ) :-
		closed_above ( Win, closed_mark ( Selector, _ ) ),
		assert ( closed ( Selector ) ), fail.
	save_closed ( Win ) :-
		closed_below ( Win, closed_mark ( Selector, _ ) ),
		assert ( closed ( Selector ) ), fail.
	save_closed ( _ ).

	restore_closed ( Win ) :-
		retract ( closed ( Selector ) ),
		restore_closed ( Win, Selector ), fail.
	restore_closed ( _ ).

	restore_closed ( Win, Selector ) :-
		tree_above ( Win, node ( _, ColLR_sel, _, _, ColUD_sel, _, I_sel, J_sel, K_sel, Selector, b_false, _, b_true, _, _ ) ), !,
		convert_tree ( Win, tree ( "", unmarked, [], 0 ), ColLR_sel, ColUD_sel, I_sel, J_sel, _, K_sel, Selector, "", convert_close_tree_base ).
	restore_closed ( Win, Selector ) :-
		tree_below ( Win, node ( _, ColLR_sel, _, _, ColUD_sel, _, I_sel, J_sel, K_sel, Selector, b_false, _, b_true, _, _ ) ), !,
		convert_tree ( Win, tree ( "", unmarked, [], 0 ), ColLR_sel, ColUD_sel, I_sel, J_sel, _, K_sel, Selector, "", convert_close_tree_base ).

	save_opened ( Win ) :-
		opened_multiple_in_tree_base ( Win, node ( _, _, _, _, _, _, I, J, K, Selector, _, _, _, _, _ ) ),
		get_parent_list ( Win, I, J, K, [ Selector ], List ),
		reverse_list ( List, [], List_ ),
		assert ( opened ( List_ ) ), fail.
	save_opened ( _ ).

	check_opened_or_selected ( T, b_true ) :-
		opened ( L ),
		reverse_list ( L, [], L_ ),
		check_opened_or_selected ( T, T, L_ ),
		assert ( opened_checked ( L ) ), fail.
	check_opened_or_selected ( T, b_false ) :-
		selected_route ( L ),
		reverse_list ( L, [], L_ ),
		check_opened_or_selected ( T, T, L_ ),
		assert ( selected_route_checked ( L ) ), fail.
	check_opened_or_selected ( _, _ ).

	check_opened_or_selected ( _, tree ( Sel, _, _, _ ), [ Sel ] ) :- !.
	check_opened_or_selected ( T, tree ( Sel, _, _, _ ), [ Sel | L ] ) :-
		get_subtree ( T, Sel, List ),
		check_opened_or_selected_ ( T, List, L ).

	check_opened_or_selected_ ( Tree, [ H | _ ], L ) :-
		check_opened_or_selected ( Tree, H, L ), !.
	check_opened_or_selected_ ( Tree, [ _ | T ], L ) :-
		check_opened_or_selected_ ( Tree, T, L ).

	restore_opened_or_selected ( Tree, tree ( Sel, Mark, _, ArrowType ), tree( Sel, Mark, List_, ArrowType ), L, b_true ) :-
		not ( tree_member ( L, Sel ) ),
		opened_checked ( OpPath ),
		CurPath = [ Sel | L ],
		is_subpath ( CurPath, OpPath ), !,
		get_subtree ( Tree, Sel, List ),
		restore_opened_or_selected ( Tree, List, [], List_, CurPath, b_true ).
	restore_opened_or_selected ( _, tree ( Sel, Mark, _, ArrowType ), tree( Sel, Mark, [], ArrowType ), _, b_true ) :-
		opened_checked ( [ Sel | _ ] ), !.
	restore_opened_or_selected ( Tree, tree ( Sel, Mark, _, ArrowType ), tree( Sel, Mark, List_, ArrowType ), L, b_false ) :-
		not ( tree_member ( L, Sel ) ),
		selected_route_checked ( SelPath ),
		CurPath = [ Sel | L ],
		is_subpath ( CurPath, SelPath ), !,
		get_subtree ( Tree, Sel, List ),
		restore_opened_or_selected ( Tree, List, [], List_, CurPath, b_false ).
	restore_opened_or_selected ( _, tree ( Sel, Mark, _, ArrowType ), tree( Sel, Mark, [], ArrowType ), _, b_false ) :-
		selected_route_checked ( [ Sel | _ ] ), !.
	restore_opened_or_selected ( Tree, tree ( Sel, Mark, List, ArrowType ), tree( Sel, Mark, List_, ArrowType ), L, Mode ) :-
		restore_opened_or_selected ( Tree, List, [], List_, [ Sel | L ], Mode ).

	restore_opened_or_selected ( _, [], L, L_, _, _ ) :-
		reverse_list ( L, [], L_ ), !.
	restore_opened_or_selected ( Tree, [ H | T ], L, L_, SL, Mode ) :-
		restore_opened_or_selected ( Tree, H, H_, SL, Mode ),
		restore_opened_or_selected ( Tree, T, [ H_ | L ], L_, SL, Mode ).

        tree_member ( [ H | _ ], H ) :- !.
        tree_member ( [ _ | T ], H ) :-
	        tree_member ( T, H ).

        is_subpath ( L, L ) :- !.
        is_subpath ( L, [ _ | T ] ) :-
	        is_subpath ( L, T ).

	get_subtree ( tree ( Sel, _, List, _ ), Sel, List ) :-
		List = [ _ | _ ], !.
	get_subtree ( tree ( _, _, List, _ ), Sel, List_ ) :-
		get_subtree_ ( List, Sel, List_ ), !.
	get_subtree ( _, _, [] ).

	get_subtree_ ( [], _, [] ) :- !.
	get_subtree_ ( [ H | _ ], Sel, L ) :-
		get_subtree ( H, Sel, L ),
		L = [ _ | _ ], !.
	get_subtree_ ( [ _ | T ], Sel, L ) :-
		get_subtree_ ( T, Sel, L ).

	reverse_list ( [], L, L ) :- !.
	reverse_list ( [ H | T ], L, L_ ) :-
		reverse_list ( T, [ H | L ], L_ ).

	save_selected ( Win ) :-
		get_selected_node ( Win, node ( _, _, _, _, _, _, I, J, K, Selector, _, _, _, _, _ ) ), !,
		get_parent_list ( Win, I, J, K, [ Selector ], List ),
		retractall ( selected_route ( _ ) ),
		reverse_list ( List, [], List_ ),
		assert ( selected_route ( List_ ) ).

	get_parent_list ( Win, I, J, K, L0, L1 ) :-
		get_parent ( Win, I, J, K, node ( _, _, _, _, _, _, I_, J_, K_, Selector, _, _, _, _, _ ) ), !,
		get_parent_list ( Win, I_, J_, K_, [ Selector | L0 ], L1 ).
	get_parent_list ( _, _, _, _, L, L ).

	restore_selected ( Win ) :-
		retractall ( selected ( Win, _, _, _ ) ),
		retract ( selected_route_checked ( List ) ),
		reverse_list ( List, [], List_ ),
		tree_size ( Win, _, _, _, _, N ),
		R = N div 2,
		search_by_route ( Win, List_, 0, R, R, 0, I, J, K ), !,
		assert ( selected ( Win, I, J, K ) ).
	restore_selected ( Win ) :-
		assert ( selected ( Win, 0, 0, 0 ) ).

	search_by_route ( _, [], _, I, J, K, I, J, K ) :- !.
	search_by_route ( Win, [ Selector | List ], Col0, I0, J0, _, I2, J2, K2 ) :-
		Col1 = Col0 + tree_link_width,
		tree_above ( Win, NODE ),
		NODE = node ( Col1, Col2, _, _, _, _, I1, J1, K1, Selector, _, _, _, _, _ ),
		I1 - J1 >= I0 - J0,
		I1 + J1 <= I0 + J0, !,
		Col3 = Col2 + tree_link_width,
		search_by_route ( Win, List, Col3, I1, J1, K1, I2, J2, K2 ).
	search_by_route ( Win, [ Selector | List ], Col0, I0, J0, _, I2, J2, K2 ) :-
		Col1 = Col0 + tree_link_width,
		tree_below ( Win, NODE ),
		NODE = node ( Col1, Col2, _, _, _, _, I1, J1, K1, Selector, _, _, _, _, _ ),
		I1 - J1 >= I0 - J0,
		I1 + J1 <= I0 + J0, !,
		Col3 = Col2 + tree_link_width,
		search_by_route ( Win, List, Col3, I1, J1, K1, I2, J2, K2 ).

	order_list ( [], L, L ) :- !.
	order_list ( [ S | L0 ], L1, L2 ) :-
		max_selector ( S, Smax, L0, [], L0_ ),
		order_list ( L0_, [ Smax | L1 ], L2 ).

	max_selector ( S, S, [], L, L ) :- !.
	max_selector ( S1, S, [ S0 | T0 ], L0, L1 ) :-
		S0 <= S1, !,
		max_selector ( S1, S, T0, [ S0 | L0 ], L1 ).
	max_selector ( S1, S, [ S0 | T0 ], L0, L1 ) :-
		max_selector ( S0, S, T0, [ S1 | L0 ], L1 ).
		
	tree_GetHandler ( W, EH ) :-
		tree_callback ( W, EH ), !.
	tree_GetHandler ( W, EH ) :-
		EH = win_GetHandler ( W ).

/******************************************************************************

******************************************************************************/
predicates
  determ selected_ ( WINDOW, INTEGER, INTEGER, INTEGER )

clauses
  selected_ ( W, I, J, K ) :-
	selected ( W, I, J, K ), !.
  selected_ ( _, 0, 0, 0 ).

/******************************************************************************

		clauses FOR global predicates

******************************************************************************/
clauses
	tree_Create( WinType, RCT, Title, Menu, Parent, Flags,
			EventHandler, CreationData, Tree,
			TreeWinInfo, _Path, W ) :-

		Win = win_Create ( w_Child, RCT, "", no_menu, Parent, [ wsf_Invisible ], tree_no_handler, 0 ),
		get_font ( TreeWinInfo, FONT ),
		win_SetFont ( Win, FONT ),
		tree_base_clean_up ( Win ),
		convert_tree_ ( Win, Tree ),
		set_context ( Win, RCT, TreeWinInfo ),
		assert ( tree_callback ( Win, EventHandler ) ),
		assert ( convert_window ( Win ) ),
		W = win_Create ( WinType, RCT, Title, Menu, Parent, Flags, tree_handler, CreationData ),
		search_base_clean_up ( Win ),
		scroll_base_clean_up ( Win ),
		closed_base_clean_up ( Win ),
		win_Destroy ( Win ),
		selected_ ( W, I, J, K ),
		set_selected ( W, I, J, K, 0, 0, update_full ),
		!.
	tree_Create( _, _, _, _, _, _, _, _, _, _, _, W ) :-
		W = cast ( window, 0 ),
		errorexit ( error_vpi_package_bad_data ).

	tree_CreateSubclass( W, Tree, TreeWinInfo, _Path ) :-
		EventHandler = tree_GetHandler ( W ),
		tree_base_clean_up ( W ),
		selection_base_clean_up ( W ),
		search_base_clean_up ( W ),
		scroll_base_clean_up ( W ),
		closed_base_clean_up ( W ),
		RCT = win_GetClientRect ( W ),
		Task = cast ( window, vpi_GetAttrVal ( attr_task_window ) ),
		Win = win_Create ( w_TopLevel, RCT, "", no_menu, Task, [ wsf_Invisible ], tree_no_handler, 0 ),
		get_font ( TreeWinInfo, FONT ),
		win_SetFont ( Win, FONT ),
		tree_base_clean_up ( Win ),
		convert_tree_ ( Win, Tree ),
		set_context ( Win, RCT, TreeWinInfo ),
		assert ( tree_callback ( Win, EventHandler ) ),
		assert ( convert_window ( Win ) ),
		win_SetHandler ( W, tree_handler ),
		retract ( convert_window ( Win ) ),
		tree_base_copy ( Win, W ),
		tree_base_clean_up ( Win ),
		write_set_mode ( W, write_ ),
		selection_base_copy ( Win, W ),
		selection_base_clean_up ( Win ),
		retract ( win_info ( W, Inf ) ),
		assert ( win_info ( W, Inf ) ),
		win_SetFont ( W, FONT ),
		resize_tree ( W ),
		search_base_clean_up ( Win ),
		scroll_base_clean_up ( Win ),
		closed_base_clean_up ( Win ),
		win_Destroy ( Win ),
		selected_ ( W, I, J, K ),
		set_selected ( W, I, J, K, 0, 0, update_full ), !.
	tree_CreateSubclass( _, _, _, _ ) :-
		errorexit ( error_vpi_package_internal_error ).

	tree_GetAllNodes( W, L_ ) :-
		findall ( S, get_selector ( W, S ), L ),
		order_list ( L, [], L_ ), !.
	tree_GetAllNodes( _, [] ).

	tree_GetSelectedNode( W, Selector ) :-
		get_selected_node ( W, NODE ),
		NODE = node ( _, _, _, _, _, _, _, _, _, Selector, _, _, _, _, _ ), !.
	tree_GetSelectedNode( _, "" ) :-
		errorexit ( error_vpi_package_internal_error ).

	tree_GetParentNode( W, Selector ) :-
		selected ( W, I, J, K ), !,
		get_parent ( W, I, J, K, NODE ),
		NODE = node ( _, _, _, _, _, _, _, _, _, Selector, _, _, _, _, _ ).

	tree_GetNodeArrowType( W, ArrowType ) :-
		get_selected_node ( W, NODE ),
		NODE = node ( _, _, _, _, _, _, _, _, _, _, _, _, _, _, ArrowType ), !.
	tree_GetNodeArrowType( _, 0 ) :-
		errorexit ( error_vpi_package_internal_error ).

	tree_GetWinInfo( W, tree_WinInfoAdv ( F, D, A, List, pnt ( 0, 0 ) ) ) :-
		get_selected_node ( W, node ( _, _, _, _, _, _, I, J, K, Selector, _, _, _, _, _ ) ),
		get_parent_list ( W, I, J, K, [ Selector ], List ),
		win_info ( W, tree_WinInfo ( F, D, A ) ), !.
	tree_GetWinInfo( _, tree_WinInfo ( F, 0, [] ) ) :-
		F = cast ( font, 0 ),
		errorexit ( error_vpi_package_internal_error ).

	tree_GetWinRect ( W, PW, rct ( L0, T0, R0, B0 ) ) :-
		HW = get_hscroll_height ( W ),
		VW = get_vscroll_width ( W ),
		RCT = win_GetClientRect ( W ),
		RCT = rct ( L, T, R, B ),
		Rn = R + VW, Bn = B + HW,
		PNTLIST = win_MapPoints ( W, PW, [pnt ( L, T ), pnt ( Rn, Bn )] ),
		PNTLIST = [pnt ( L0, T0 ), pnt ( R0, B0 )],!.
	tree_GetWinRect(_,_,rct(0,0,0,0)):-errorexit(). % Should never be called !

	tree_GetCurrentSearch( W, Selector ) :-
		search_sel ( W, Selector ), !.

	tree_SetSelectedNode( W, Selector ):-
		tree_SearchFirstNode ( W, Selector ), !.
	tree_SetSelectedNode( _, _ ).

	tree_SetDirection( W, Dir ) :-
		retractall ( screen_context ( W, _, _, _ ) ),
		assert ( screen_context ( W, 0, 0, Dir ) ),
		selected_ ( W, I, J, K ),
		set_selected ( W, I, J, K, 0, 0, update_full ), !.
	tree_SetDirection( _, _ ) :-
		errorexit ( error_vpi_package_internal_error ).

	tree_SetFont( W, FONT ) :-
		cursor_SetWait (),
		retract ( win_info ( W, tree_WinInfo( _, Dir, ArrPenList ) ) ),
		assert ( win_info ( W, tree_WinInfo( FONT, Dir, ArrPenList ) ) ),
		win_SetFont ( W, FONT ),
		convert_tree ( W, tree ( "", unmarked, [], 0 ), 0, 0, 0, 0, _, 0, "", "", convert_base_ ),
		selected ( W, I, J, K ),
		set_selected ( W, I, J, K, 0, 0, update_full ), !.
	tree_SetFont( _, _ ) :-
		errorexit ( error_vpi_package_internal_error ).

	tree_Update( W, Tree, _ ) :-
		cursor_SetWait (),
		retractall ( _, open_close_info ),
		save_closed ( W ),
		save_opened ( W ),
		save_selected ( W ),
		retract ( win_info ( W, TREE_WIN_INFO ) ),
		retract ( tree_callback ( W, HANDLER ) ),
		tree_base_clean_up ( W ),
		selection_base_clean_up ( W ),
		scroll_base_clean_up ( W ),
		closed_base_clean_up ( W ),
		retractall ( _, convert_base ),
		convert_register_selector ( W, Tree ),
		check_opened_or_selected ( Tree, b_true ),
		restore_opened_or_selected ( Tree, Tree, Tree_, [], b_true ),
		check_opened_or_selected ( Tree_, b_false ),
		restore_opened_or_selected ( Tree_, Tree_, Tree__, [], b_false ),
		tree_base_clean_up ( W ),
		convert_tree_ ( W, Tree__ ),
		set_context ( W, rct ( 0, 0, 0, 0 ), TREE_WIN_INFO ),
		assert ( tree_callback ( W, HANDLER ) ),
		restore_closed ( W ),
		restore_selected ( W ),
		retractall ( _, open_close_info ),
		selected ( W, I, J, K ),
		set_selected ( W, I, J, K, 0, 0, update_full ), !.
	tree_Update( _, _, _ ) :-
		errorexit ( error_vpi_package_internal_error ).

	tree_OpenCloseNode( W ) :-
		open_node ( W ), !.
	tree_OpenCloseNode( W ) :-
		close_node ( W ), !.
	tree_OpenCloseNode( _ ).

	tree_SearchFirstNode( W, Selector ) :-
		retractall ( search_sel ( W, _ ) ),
		assert ( search_sel ( W, Selector ) ),
		write_base_clean_up ( W ),
		retract ( tree_above ( W, NODE ) ),
		asserta ( tree_below ( W, NODE ) ), fail.
	tree_SearchFirstNode( W, Selector ) :-
		tree_below ( W, node ( _, _, _, _, _, _, I, J, K, Selector, _, _, _, _, _ ) ),
		retractall ( search ( W, _, _, _ ) ),
		assert ( search ( W, I, J, K ) ),
		write_set_mode ( W, write_search ),
		write_tree ( W ),
		write_set_mode ( W, write_ ),
		search_rect ( W, Dx, Dy, b_true ), !,
		scroll_tree ( W, Dx, Dy ).
	tree_SearchFirstNode ( W, _ ) :-
		write_set_mode ( W, write_ ),!,
		fail.
%		dlg_Note ( "Search node not found" ).

	tree_SearchNodeAgain ( W ) :-
		search_sel ( W, Selector ),
		selected ( W, I, J, K ),
		tree_below ( W, node ( _, _, _, _, _, _, I_, J_, K_, Selector, _, _, _, _, _ ) ),
		search_found ( I_, J_, K_, I, J, K ),
		retractall ( search ( W, _, _, _ ) ),
		assert ( search ( W, I_, J_, K_ ) ),
		write_set_mode ( W, write_search ),
		write_tree ( W ),
		write_set_mode ( W, write_ ),
		search_rect ( W, Dx, Dy, b_true ),
		scroll_tree ( W, Dx, Dy ), !.
	tree_SearchNodeAgain ( _ ) :-
		dlg_Note ( "Search node not found" ).

	tree_MoveToSelectedNode( W ) :-
		selected_ ( W, I, J, K ),
		set_selected ( W, I, J, K, 0, 0, update_scroll ), !.
	tree_MoveToSelectedNode( _ ).

	tree_MoveToParentNode( W ) :-
		selected_ ( W, I, J, K ),
		get_parent ( W, I, J, K, NODE ),
		NODE = node ( _, _, _, _, _, _, I_, J_, K_, _, _, _, _, _, _ ),
		set_selected ( W, I_, J_, K_, 0, 0, update_scroll ), !.
	tree_MoveToParentNode( _ ).

	tree_Print ( W, Title ) :-
		VRP = val( integer, vpi_GetAttrVal ( attr_printer_vres ) ),
		HRP = val( integer, vpi_GetAttrVal ( attr_printer_hres ) ),
		VRS = val( integer, vpi_GetAttrVal ( attr_screen_vres ) ),
		HRS = val( integer, vpi_GetAttrVal ( attr_screen_hres ) ),
		VP = val( integer, vpi_GetAttrVal ( attr_printer_height ) ),
		HP = val( integer, vpi_GetAttrVal ( attr_printer_width ) ),
		PW = print_StartJob ( Title ),
		win_SetMapMode ( PW, mm_arbitrary ),
		win_SetMapScale ( PW, pnt ( 0, 0 ), pnt ( VRS, HRS ), pnt ( 0, 0 ), pnt ( VRP, HRP ) ),
		tree_base_copy ( W, PW ),
		closed_base_copy ( W, PW ),
		Font = win_GetFont ( W ),
		win_SetFont ( PW, Font ),
		cursor_SetWait (),
		convert_tree ( PW, tree ( "", unmarked, [], 0 ), 0, 0, 0, 0, _, 0, "", "", convert_base_ ),
		retractall ( screen_context ( PW, _, _, _ ) ),
		assert ( screen_context ( PW, 0, 0, tree_DirRight ) ),
		move_base ( PW ),
		write_base_clean_up ( PW ),
		write_set_mode ( PW, write_ ),
		retractall ( _, print_base ),
		assert ( print_bottom ( 0, 0, 0 ) ),
		LHRS = val(long,HRS),
		LPageWidth = (HP * LHRS) div HRP,
%		HDel = HRS div HRP,	% 12.01.1998 BB! (replace "/" to "div")
		PageWidth = val(integer,LPageWidth),
		LVRS = val(long,VRS),
		LPageHeight = (VP * LVRS) div VRP,
%		VDel = VRS div VRP,	% 12.01.1998 BB! (replace "/" to "div")
		PageHeight = val(integer,LPageHeight),
		StartX = HRS div 2,
		StartY = VRS div 2,
		win_GetFontMetrics ( PW, Leading, Ascent, Descent ),
		HeaderHei = Leading + Ascent + Descent + StartY,
		print_tree_adjust ( PW, PageWidth ),
		print_tree ( PW, StartX, StartY, HeaderHei, Title, 1, PageHeight, Font ),
		print_EndJob ( PW ),
		tree_base_clean_up ( PW ),
		write_base_clean_up ( PW ),
		retractall ( _, print_base ), !.
	tree_Print ( _, _ ) :-
		errorexit ( error_vpi_package_internal_error ).
