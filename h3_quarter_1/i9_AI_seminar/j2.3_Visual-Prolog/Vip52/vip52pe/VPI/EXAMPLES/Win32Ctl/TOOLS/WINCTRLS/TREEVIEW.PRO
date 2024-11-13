/******************************************************************************

		 Copyright (c) 1984 - 2000 Prolog Development Center A/S

 FileName:	TREEVIEW.PRO
 Purpose:	Tree View custom control object
 Written by:	Sergey Alexeev
 Version:	1.0
 Build:		002.000316
 Tested with:   Visual Prolog v.5.0 build 533
 Comments:
******************************************************************************/
ifdef use_winctrl_TreeView

ifndef winctrls_pre_included
 #Error: this file requires include: winctrls.pre
enddef 

ifndef error_con_included
 #Error: this file requires include: error.con
enddef 

DOMAINS
TV_ITEM = struct item(UNSIGNED Mask,WCC_POINT HItem,UNSIGNED State,UNSIGNED StateMask,
	STRING Text,INTEGER TextLength,INTEGER ImageIndex,INTEGER SelectImageId,INTEGER Children,LONG LParam)
TV_NMHDR = struct nmhdr(WCC_POINT WTVWin,UNSIGNED IdFrom,UNSIGNED CodeOperation)
TV_TREEVIEW = struct treeview(WCC_POINT WTVWin,UNSIGNED IdFrom,UNSIGNED CodeOperation,UNSIGNED Action,
	UNSIGNED MaskOld,LONG  ItemIndexOld,UNSIGNED StateOld,UNSIGNED StateMaskOld,STRING TextOld,
	INTEGER TextLengthOld,INTEGER ImageIndexOld,INTEGER SelectImageIdOld,INTEGER ChildrenOld,LONG LParamOld,
	UNSIGNED MaskNew,LONG  ItemIndexNew,UNSIGNED StateNew,UNSIGNED StateMaskNew,STRING TextNew,
	INTEGER TextLengthNew,INTEGER ImageIndexNew,INTEGER SelectImageIdNew,INTEGER ChildrenNew,LONG LParamNew,
	WCC_POINT PtDrag)
TV_DISPINFO = struct dispinfo(WCC_POINT WTVWin,UNSIGNED IdFrom,UNSIGNED CodeOperation,
	UNSIGNED Mask,LONG  ItemIndex,UNSIGNED State,UNSIGNED StateMask,STRING Text,
	INTEGER TextLength,INTEGER ImageIndex,INTEGER SelectImageId,INTEGER Children,LONG LParam)
TV_HITTESTINFO = struct hittestinfo(INTEGER X,INTEGER Y,UNSIGNED Flags,LONG ItemIndex)
TV_KEYDOWN = struct keydown(WCC_POINT WTVWin,UNSIGNED IdFrom,UNSIGNED CodeOperation,SHORT VKey,UNSIGNED Flags)
TV_INSERTITEM = struct insertitem(WCC_POINT Parent,WCC_POINT Previous,UNSIGNED Mask,WCC_POINT  HItem,
	UNSIGNED State,UNSIGNED StateMask,STRING Text,INTEGER TextLength,INTEGER ImageIndex,
	INTEGER SelectImageId,INTEGER Children,LONG LParam)

CONSTANTS
ifndef unicode_set
tvn_selchanging		= 0xfffffe6f
tvn_selchanged		= 0xfffffe6e
tvn_getdispinfo		= 0xfffffe6d
tvn_setdispinfo		= 0xfffffe6c
tvn_itemexpanding	= 0xfffffe6b
tvn_itemexpanded	= 0xfffffe6a
tvn_begindrag		= 0xfffffe69
tvn_beginrdrag		= 0xfffffe68
tvn_deleteitem		= 0xfffffe67
tvn_beginlabeledit	= 0xfffffe66
tvn_endlabeledit	= 0xfffffe65

tvm_insertitem		= 0x1100
tvm_getitem		= 0x110c
tvm_setitem		= 0x110d
tvm_editlabel		= 0x110e
tvm_getisearchstring	= 0x1117
elsedef
tvn_selchanging		= 0xfffffe3e
tvn_selchanged		= 0xfffffe3d
tvn_getdispinfo		= 0xfffffe3c
tvn_setdispinfo		= 0xfffffe3b
tvn_itemexpanding	= 0xfffffe3a
tvn_itemexpanded	= 0xfffffe39
tvn_begindrag		= 0xfffffe38
tvn_beginrdrag		= 0xfffffe37
tvn_deleteitem		= 0xfffffe36
tvn_beginlabeledit	= 0xfffffe35
tvn_endlabeledit	= 0xfffffe34

tvm_insertitem		= 0x1132
tvm_getitem		= 0x113e
tvm_setitem		= 0x113f
tvm_editlabel		= 0x1141
tvm_getisearchstring	= 0x1140
enddef

tvn_keydown		= 0xfffffe64

tvm_deleteitem		= 0x1101
tvm_expand		= 0x1102
tvm_getitemrect		= 0x1104
tvm_getcount		= 0x1105
tvm_getindent		= 0x1106
tvm_setindent		= 0x1107
tvm_getimagelist	= 0x1108
tvm_setimagelist	= 0x1109
tvm_getnextitem		= 0x110a
tvm_selectitem		= 0x110b
tvm_geteditcontrol	= 0x110f
tvm_getvisiblecount	= 0x1110
tvm_hittest		= 0x1111
tvm_createdragimage	= 0x1112
tvm_sortchildren	= 0x1113
tvm_ensurevisible	= 0x1114
tvm_sortchildrencb	= 0x1115
tvm_endeditlabelnow	= 0x1116
tvm_settooltips		= 0x1118
tvm_gettooltips		= 0x1119

tvgn_root		= 0x0000
tvgn_next		= 0x0001
tvgn_previous		= 0x0002
tvgn_parent		= 0x0003
tvgn_child		= 0x0004
tvgn_firstvisible	= 0x0005
tvgn_nextvisible	= 0x0006
tvgn_previousvisible	= 0x0007
tvgn_drophilite		= 0x0008
tvgn_caret		= 0x0009

tvif_text		= 0x0001
tvif_image		= 0X0002
tvif_param		= 0x0004
tvif_state		= 0x0008
tvif_handle		= 0x0010
tvif_selectedimage	= 0x0020
tvif_children		= 0x0040

tve_toggle		= 0x0003

tvi_root		= 0xffff0000
tvi_first		= 0xffff0001
tvi_last		= 0xffff0002
tvi_sort		= 0xffff0003

DATABASE - tv_db
  tv_bitmap_index(WINDOW TVWin,UNSIGNED BitmapId,INTEGER BitmapIndex)
  tv_item_index(WINDOW TVWin,UNSIGNED ItemId,LONG ItemIndex)
  tv_item(WINDOW TVWin,LONG ItemIndex,LONG ParentIndex,LONG PreviosIndex,STRING Text,ILIST Flags,RESID BitmapId,INTEGER Layer)
  tv_info(WINDOW TVWin,WINDOW WTVWin,WCC_POINT Himage,TV_CALLBACK,CURSOR DDCursor,CURSOR UnDDCursor)
  tv_edit(UNSIGNED ItemId,STRING)
  tv_drag(UNSIGNED SourceItemId)
  tv_drag_last_send(WINDOW TVWin,UNSIGNED TItemId,BOOLEAN LastAnswer)
  tv_advanced(WINDOW TVWin,STRING Advanced)

PREDICATES
  procedure tv_add_bitmaps(WINDOW TVWin,LONG Hinst,LONG Himage,ILIST)
CLAUSES
  tv_add_bitmaps(_,_,_,[]):-!.
  tv_add_bitmaps(TVWin,Hinst,Himage,[BitmapId|Rest]):-
	BitmapIndex = _wcc_bitmap_add(Hinst,Himage,BitmapId),
	assert(tv_bitmap_index(TVWin,BitmapId,BitmapIndex)),!,
	tv_add_bitmaps(TVWin,Hinst,Himage,Rest).
  tv_add_bitmaps(_,_,_,_):-
	errorexit(),!.

PREDICATES
  procedure tv_get_bitmap_par(TV_TREELIST,INTEGER Xin,INTEGER Yin,ILIST BitmapsIdIn,INTEGER Xout,INTEGER Yout,ILIST BitmapsIdOut)
CLAUSES
  tv_get_bitmap_par([],Xout,Yout,Bout,Xout,Yout,Bout):-!.
  tv_get_bitmap_par([tree(_,_,BitmapId,_,List)|Rest],Xin,Yin,Bin,Xout,Yout,Bout):-
	tv_get_bitmap_par(List,Xin,Yin,Bin,Xin1,Yin1,Bin1),
	Pict = pict_GetFromRes(BitmapId),
	pict_GetSize(Pict,Width,Height,_),
	pict_Destroy (Pict),
	wcc_max(Xin1,Width,Xin2),
	wcc_max(Yin1,Height,Yin2),!,
	tv_get_bitmap_par(Rest,Xin2,Yin2,[BitmapId|Bin1],Xout,Yout,Bout).
  tv_get_bitmap_par(_,_,_,_,0,0,[]):-
	errorexit(),!.

PREDICATES
  procedure tv_correct_parentindex(LONG ParentIndexIn,LONG ParentIndexOut)
CLAUSES
  tv_correct_parentindex(0,tvi_root):-!.
  tv_correct_parentindex(ParentIndex,ParentIndex).

PREDICATES
  procedure tv_correct_previousindex(LONG PreviousIndexIn,LONG PreviousIndexOut)
CLAUSES
  tv_correct_previousindex(0,tvi_first):-!.
  tv_correct_previousindex(PreviousIndex,PreviousIndex).

PREDICATES
  procedure tv_add_items(WINDOW TVWin,WINDOW WTVWin,TV_TREELIST TreeList,INTEGER Layer,LONG Previos,LONG Parent)
CLAUSES
  tv_add_items(_,_,[],_,_,_):-!.
  tv_add_items(TVWin,WTVWin,[tree(ItemId,Flags,BitmapId,Text,List)|Rest],Layer,Previos1,Parent1):-
	wcc_summ_list(Flags,0,SummFlags),
	tv_bitmap_index(TVWin,BitmapId,BitmapIndex),
	tv_correct_parentindex(Parent1,Parent),
	tv_correct_previousindex(Previos1,Previos),
	str_len(Text,TextLength),
	Mask = tvif_text + tvif_image + tvif_selectedimage + tvif_param + tvif_state,
	Point = insertitem(Parent,Previos,Mask,0,SummFlags,0xffff,Text,TextLength,BitmapIndex,
		BitmapIndex,0,0),
	PointP = cast(long,Point),
	ItemIndex = win_SendEvent(WTVWin,e_native(tvm_insertitem,0,PointP)),
	assert(tv_item_index(TVWin,ItemId,ItemIndex)),
	assert(tv_item(TVWin,ItemIndex,Parent,Previos,Text,Flags,BitmapId,Layer)),
	Layer1 = Layer + 1,
	tv_add_items(TVWin,WTVWin,List,Layer1,0,ItemIndex),!,
	tv_add_items(TVWin,WTVWin,Rest,Layer,ItemIndex,Parent1).
  tv_add_items(_,_,_,_,_,_):-
	errorexit(),!.

PREDICATES
  procedure tv_get_item_id(WINDOW TVWin,LONG ItemIndex,UNSIGNED ItemId)
CLAUSES
  tv_get_item_id(TVWin,ItemIndex,ItemId):-
	tv_item_index(TVWin,ItemId,ItemIndex),!.
  tv_get_item_id(_,_,wcc_null).

PREDICATES
  procedure tv_get_item_index(WINDOW TVWin,UNSIGNED ItemId,LONG ItemIndex)
CLAUSES
  tv_get_item_index(TVWin,ItemId,ItemIndex):-
	tv_item_index(TVWin,ItemId,ItemIndex),!.
  tv_get_item_index(_,_,0).

PREDICATES
  procedure tv_reload_item_images(WINDOW TVWin,WINDOW WTVWin)
CLAUSES
  tv_reload_item_images(TVWin,WTVWin):-
	tv_item(TVWin,ItemIndex,_,_,_,_,BitmapId,_),
	tv_bitmap_index(TVWin,BitmapId,BitmapIndex),
	Mask = tvif_handle + tvif_image + tvif_selectedimage,
	Point = item(Mask,ItemIndex,0,0,"",0,BitmapIndex,BitmapIndex,0,0),
	PointP = cast(long,Point),
	win_SendEvent(WTVWin,e_native(tvm_setitem,0,PointP)),
	fail.
  tv_reload_item_images(_,_).

PREDICATES
  procedure tv_reload_bitmap(WINDOW TVWin,UNSIGNED NewBitmapId,LONG NewBitmapIndex)
CLAUSES
  tv_reload_bitmap(TVWin,NewBitmapId,NewBitmapIndex):-
	findall(BitmapId,tv_bitmap_index(TVWin,BitmapId,_),BitmapIdList),
	wcc_del_equal([NewBitmapId|BitmapIdList],[],BitmapIdList1),
	wcc_get_bitmap_size(BitmapIdList1,0,0,X,Y),
	wcc_length_list(BitmapIdList1,NumBitmap),

	retract(tv_info(TVWin,WTVWin,Himage,CallBack,DDCursor,UnDDCursor)),
	retractall(tv_bitmap_index(TVWin,_,_)),
	Hinst = vpi_GetAttrVal(attr_win_instance),
	_wcc_bitmap_destroy(Himage),
	NewHimage = _wcc_bitmap_create(X,Y,NumBitmap),
	assert(tv_info(TVWin,WTVWin,NewHimage,CallBack,DDCursor,UnDDCursor)),
	tv_add_bitmaps(TVWin,Hinst,NewHimage,BitmapIdList1),
	win_SendEvent(WTVWin,e_native(tvm_setimagelist,0,NewHimage)),
	tv_reload_item_images(TVWin,WTVWin),
	tv_bitmap_index(TVWin,NewBitmapId,NewBitmapIndex),!.
  tv_reload_bitmap(_,_,0):-
	errorexit(),!.

PREDICATES
  procedure tv_get_layer(WINDOW TVWin,UNSIGNED ParentId,INTEGER Layer)
CLAUSES
  tv_get_layer(TVWin,ParentId,Layer):-
	tv_item_index(TVWin,ParentId,ParentIndex),
	tv_item(TVWin,ParentIndex,_,_,_,_,_,L),
	Layer = L + 1,!.
  tv_get_layer(_,_,1).

PREDICATES
  procedure tv_get_tv_par(WINDOW TVWin,WCC_POINT LParam,UNSIGNED ItemIdOld,UNSIGNED StateOld,UNSIGNED ItemIdNew,UNSIGNED StateNew)
CLAUSES
  tv_get_tv_par(TVWin,LParam,ItemIdOld,StateOld,ItemIdNew,StateNew):-
	Event = cast(tv_treeview,LParam),
	Event = treeview(_,_,_,_,_,ItemIndexOld,StateOld,_,_,_,_,_,_,_,_,ItemIndexNew,StateNew,_,_,_,_,_,_,_,_),
	tv_get_item_id(TVWin,ItemIndexOld,ItemIdOld),
	tv_get_item_id(TVWin,ItemIndexNew,ItemIdNew),!.

PREDICATES
  procedure tv_get_expanded(UNSIGNED State,BOOLEAN Expanded)
CLAUSES
  tv_get_expanded(State,b_true):-
	bitand(State,tvis_expanded,Result),
	Result = tvis_expanded,!.
  tv_get_expanded(_,b_false).

PREDICATES
  procedure tv_get_state(UNSIGNED State,BOOLEAN Expanded)
CLAUSES
  tv_get_state(State,Expanded):-
	tv_get_expanded(State,Expanded),!.

PREDICATES
  procedure tv_get_mouse_pos(WINDOW TVWin,INTEGER X,INTEGER Y)
CLAUSES
  tv_get_mouse_pos(TVWin,X,Y):-
	tv_info(TVWin,WTVWin,_,_,_,_),
	Pnt = cursor_GetPos(WTVWin),
	Pnt = pnt(X,Y),!.
  tv_get_mouse_pos(_,0,0).

PREDICATES
  procedure tv_get_tree(WINDOW TVWin,UNSIGNED RootId,TV_TREELIST Curr,TV_TREELIST TreeList)
  procedure tv_get_tree(WINDOW TVWin,UNSIGNED CurrId,TV_TREELIST TreeList)
CLAUSES
  tv_get_tree(TVWin,CurrId,Curr,TreeList):-
	tv_get_next(TVWin,CurrId,NextId),
	NextId <> wcc_null,
	tv_get_tree(TVWin,CurrId,ChildList),
	tv_get_item(TVWin,CurrId,Text,StateList,BitmapId),!,
	tv_get_tree(TVWin,NextId,[tree(CurrId,StateList,BitmapId,Text,ChildList)|Curr],TreeList).
  tv_get_tree(TVWin,CurrId,Curr,TreeList):-
	tv_get_tree(TVWin,CurrId,ChildList),
	tv_get_item(TVWin,CurrId,Text,StateList,BitmapId),
	wcc_reverse_list([tree(CurrId,StateList,BitmapId,Text,ChildList)|Curr],TreeList),!.
  tv_get_tree(_,_,_,[]):-
	errorexit(),!.
  tv_get_tree(TVWin,CurrId,ChildList):-
	tv_get_child(TVWin,CurrId,ChildId),
	ChildId <> wcc_null,
	tv_get_tree(TVWin,ChildId,[],ChildList),!.
  tv_get_tree(_,_,[]).

PREDICATES
  determ tv_check_code(ULONG CodeOperation,WINDOW TVWin,UNSIGNED WParam,LONG LParam,TV_MESSAGE,STRING Message)
CLAUSES
  tv_check_code(nm_outofmemory,_,_,_,outofmemory,"OutOfMemory"):-!.
  tv_check_code(nm_click,TVWin,_,_,click(pnt(X,Y)),"Click"):-
	tv_get_mouse_pos(TVWin,X,Y),!.
  tv_check_code(nm_dblclk,TVWin,_,_,dblclick(pnt(X,Y)),"DblClk"):-
	tv_get_mouse_pos(TVWin,X,Y),!.
  tv_check_code(nm_return,TVWin,_,_,return(ItemId),"Return"):-
	tv_get_sel(TVWin,ItemId),!.
  tv_check_code(nm_rclick,TVWin,_,_,rclick(pnt(X,Y)),"RClick"):-
	tv_get_mouse_pos(TVWin,X,Y),!.
  tv_check_code(nm_rdblclk,TVWin,_,_,rdblclick(pnt(X,Y)),"RDblClk"):-
	tv_get_mouse_pos(TVWin,X,Y),!.
  tv_check_code(nm_setfocus,_,_,_,setfocus,"SetFocus"):-!.
  tv_check_code(nm_killfocus,_,_,_,losefocus,"KillFocus"):-!.
%  tv_check_code(nm_customdraw,_,_,_,none,"CustomDraw"):-!.
%  tv_check_code(nm_hover,_,_,_,none,"Hover"):-!.
  tv_check_code(tvn_selchanging,TVWin,_,LParam,selecting(ItemFrom,ItemTo),"SelChanging"):-
	tv_get_tv_par(TVWin,LParam,ItemFrom,_,ItemTo,_),!.
  tv_check_code(tvn_selchanged,TVWin,_,LParam,selected(ItemFrom,ItemTo),"SelChanged"):-
	tv_get_tv_par(TVWin,LParam,ItemFrom,_,ItemTo,_),!.
%  tv_check_code(tvn_getdispinfo,_,_,_,none,"GetDispInfo"):-!.
%  tv_check_code(tvn_setdispinfo,_,_,_,none,"SetDispInfo"):-!.
  tv_check_code(tvn_itemexpanding,TVWin,_,LParam,expanding(Item,Expanded),"ItemExpanding"):-
	tv_get_tv_par(TVWin,LParam,_,_,Item,State),
	tv_get_state(State,Expanded),!.
  tv_check_code(tvn_itemexpanded,TVWin,_,LParam,expanded(Item,Expanded),"ItemExpanded"):-
	tv_get_tv_par(TVWin,LParam,_,_,Item,State),
	tv_get_state(State,Expanded),!.
  tv_check_code(tvn_begindrag,TVWin,_,LParam,begindrag(ItemId),"BeginDrag"):-
	Event = cast(tv_treeview,LParam),
	Event = treeview(_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,ItemIndex,_,_,_,_,_,_,_,_,_),
	tv_get_item_id(TVWin,ItemIndex,ItemId),
	tv_info(TVWin,WTVWin,_,_,_,UDDCursor),
	win_CaptureMouse(WTVWin),
	cursor_Set(TVWin,UDDCursor),
	assert(tv_drag(ItemId)),!.
  tv_check_code(tvn_beginrdrag,TVWin,_,LParam,beginrdrag(ItemId),"BeginrDrag"):-
	Event = cast(tv_treeview,LParam),
	Event = treeview(_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,ItemIndex,_,_,_,_,_,_,_,_,_),
	tv_get_item_id(TVWin,ItemIndex,ItemId),
	tv_info(TVWin,WTVWin,_,_,_,_),
	win_CaptureMouse(WTVWin),
	assert(tv_drag(ItemId)),!.
%  tv_check_code(tvn_deleteitem,_,_,_,none,"DeleteItema"):-!.
  tv_check_code(tvn_beginlabeledit,TVWin,_,LParam,edit(ItemId),"BeginLabelEdit"):-
	Event = cast(tv_dispinfo,LParam),
	Event = dispinfo(_,_,_,_,ItemIndex,_,_,_Text,_,_,_,_,_),
	tv_get_item_id(TVWin,ItemIndex,ItemId),!.
  tv_check_code(tvn_endlabeledit,TVWin,_,LParam,modified(ItemId,Text),"EndLabelEdit"):-
	Event = cast(tv_dispinfo,LParam),
	Event = dispinfo(_,_,_,_,ItemIndex,_,_,Text,_,_,_,_,_),
	PointToText = cast(long,Text),
	PointToText <> 0,
	tv_get_item_id(TVWin,ItemIndex,ItemId),
	assert(tv_edit(ItemId,Text)),!.
  tv_check_code(tvn_keydown,_,_,LParam,keydown(Key),"KeyDown"):-
	Event = cast(tv_keydown,LParam),
	Event = keydown(_,_,_,KeyS,_),
	Key = val(integer,KeyS),!.

PREDICATES
  determ tv_check_edit()
CLAUSES
  tv_check_edit():-
	not(tv_edit(_,_)),!.
  tv_check_edit():-
	retract(tv_edit(_,_)),fail.

PREDICATES
  determ tv_check_place(UNSIGNED Place)
CLAUSES
  tv_check_place(tvht_onitemlabel):-!.
  tv_check_place(tvht_onitemicon):-!.

PREDICATES
  procedure tv_retract_child(WINDOW TVWin,LONG ParentIndex)
CLAUSES
  tv_retract_child(TVWin,ParentIndex):-
	retract(tv_item(TVWin,ItemIndex,ParentIndex,_,_,_,_,_)),
	tv_item_index(TVWin,_,ItemIndex),
	fail.
  tv_retract_child(_,_).

PREDICATES
  procedure tv_correct_state_list(WINDOW TVWin,UNSIGNED ItemId,ILIST StateListIn,ILIST StateListOut)
CLAUSES
  tv_correct_state_list(TVWin,ItemId,StateListIn,StateListOut):-
	tv_get_item(TVWin,ItemId,_,StateListCurr,_),
	wcc_member(tvis_expanded,StateListCurr),
	wcc_del_from_list(StateListIn,tvis_expanded,[],StateListOut1),
	StateListOut = [tvis_expanded|StateListOut1],!.
  tv_correct_state_list(_,_,StateListIn,StateListOut):-
	wcc_del_from_list(StateListIn,tvis_expanded,[],StateListOut),!.
  tv_correct_state_list(_,_,StateList,StateList).

/**GLOBAL PREDICATE*******************************************************
			     TV_GET_POS
 *************************************************************************/
  tv_get_pos(TVWin,X,Y,ItemId,Place):-
	tv_info(TVWin,WTVWin,_,_,_,_),
	Point = hittestinfo(X,Y,0,0),
	PointP = cast(long,Point),
	win_SendEvent(WTVWin,e_native(tvm_hittest,0,PointP)),
	Point1 = cast(tv_hittestinfo,PointP),
	Point1 = hittestinfo(_,_,Place,ItemIndex),
	tv_get_item_id(TVWin,ItemIndex,ItemId),!.
  tv_get_pos(_,_,_,0,0):-
	errorexit(error_vpi_package_bad_window),!.

/**GLOBAL PREDICATE*******************************************************
			     TV_GET_SEL
 *************************************************************************/
  tv_get_sel(TVWin,ItemId):-
	tv_info(TVWin,WTVWin,_,_,_,_),
	ItemIndex = win_SendEvent(WTVWin,e_native(tvm_getnextitem,tvgn_caret,0)),
	tv_get_item_id(TVWin,ItemIndex,ItemId),!.
  tv_get_sel(_,0):-
	errorexit(error_vpi_package_bad_window),!.

/**GLOBAL PREDICATE*******************************************************
			     TV_GET_PARENT
 *************************************************************************/
  tv_get_parent(TVWin,ItemId,ParentId):-
	tv_info(TVWin,WTVWin,_,_,_,_),
	tv_get_item_index(TVWin,ItemId,ItemIndex),
	ParentIndex = win_SendEvent(WTVWin,e_native(tvm_getnextitem,tvgn_parent,ItemIndex)),
	tv_get_item_id(TVWin,ParentIndex,ParentId),!.
  tv_get_parent(TVWin,_,0):-
	tv_info(TVWin,_,_,_,_,_),
	errorexit(error_vpi_package_bad_identifier),!.
  tv_get_parent(_,_,0):-
	errorexit(error_vpi_package_bad_window),!.

/**GLOBAL PREDICATE*******************************************************
			     TV_GET_CHILD
 *************************************************************************/
  tv_get_child(TVWin,ItemId,ChildId):-
	tv_info(TVWin,WTVWin,_,_,_,_),
	tv_get_item_index(TVWin,ItemId,ItemIndex),
	ChildIndex = win_SendEvent(WTVWin,e_native(tvm_getnextitem,tvgn_child,ItemIndex)),
	tv_get_item_id(TVWin,ChildIndex,ChildId),!.
  tv_get_child(TVWin,_,0):-
	tv_info(TVWin,_,_,_,_,_),
	errorexit(error_vpi_package_bad_identifier),!.
  tv_get_child(_,_,0):-
	errorexit(error_vpi_package_bad_window),!.

/**GLOBAL PREDICATE*******************************************************
			     TV_GET_NEXT
 *************************************************************************/
  tv_get_next(TVWin,ItemId,NextId):-
	tv_info(TVWin,WTVWin,_,_,_,_),
	tv_get_item_index(TVWin,ItemId,ItemIndex),
	NextIndex = win_SendEvent(WTVWin,e_native(tvm_getnextitem,tvgn_next,ItemIndex)),
	tv_get_item_id(TVWin,NextIndex,NextId),!.
  tv_get_next(TVWin,_,0):-
	tv_info(TVWin,_,_,_,_,_),
	errorexit(error_vpi_package_bad_identifier),!.
  tv_get_next(_,_,0):-
	errorexit(error_vpi_package_bad_window),!.

/**GLOBAL PREDICATE*******************************************************
			     TV_GET_PREVIOUS
 *************************************************************************/
  tv_get_previous(TVWin,ItemId,PreviousId):-
	tv_info(TVWin,WTVWin,_,_,_,_),
	tv_get_item_index(TVWin,ItemId,ItemIndex),
	PreviousIndex = win_SendEvent(WTVWin,e_native(tvm_getnextitem,tvgn_previous,ItemIndex)),
	tv_get_item_id(TVWin,PreviousIndex,PreviousId),!.
  tv_get_previous(TVWin,_,0):-
	tv_info(TVWin,_,_,_,_,_),
	errorexit(error_vpi_package_bad_identifier),!.
  tv_get_previous(_,_,0):-
	errorexit(error_vpi_package_bad_window),!.

/**GLOBAL PREDICATE*******************************************************
			     TV_GET_ALL
 *************************************************************************/
  tv_get_all(TVWin,TreeList):-
	tv_info(TVWin,_,_,_,_,_),
	tv_get_child(TVWin,wcc_null,FirstId),
	FirstId <> wcc_null,
	tv_get_tree(TVWin,FirstId,[],TreeList),!.
  tv_get_all(TVWin,[]):-
	tv_info(TVWin,_,_,_,_,_),
	errorexit(error_vpi_package_bad_identifier),!.
  tv_get_all(_,[]):-
	errorexit(error_vpi_package_bad_window),!.

/**GLOBAL PREDICATE*******************************************************
			     TV_GET_PART
 *************************************************************************/
  tv_get_part(TVWin,ItemId,TreeList):-
	tv_info(TVWin,_,_,_,_,_),
	tv_get_tree(TVWin,ItemId,[],TreeList),!.
  tv_get_part(TVWin,_,[]):-
	tv_info(TVWin,_,_,_,_,_),
	errorexit(error_vpi_package_bad_identifier),!.
  tv_get_part(_,_,[]):-
	errorexit(error_vpi_package_bad_window),!.

/**GLOBAL PREDICATE*******************************************************
			     TV_GET_COUNT
 *************************************************************************/
  tv_get_count(TVWin,Count):-
	tv_info(TVWin,WTVWin,_,_,_,_),
	Count = win_SendEvent(WTVWin,e_native(tvm_getcount,0,0)),!.
  tv_get_count(_,0):-
	errorexit(error_vpi_package_bad_window),!.

/**GLOBAL PREDICATE*******************************************************
			     TV_GET_ITEM
 *************************************************************************/
  tv_get_item(TVWin,ItemId,Text,StateList,BitmapId):-
	tv_info(TVWin,WTVWin,_,_,_,_),
	tv_item_index(TVWin,ItemId,ItemIndex),
	Mask = tvif_state + tvif_text + tvif_image,
	str_len(String,1000),
	Point = item(Mask,ItemIndex,0,0xffff,String,1000,0,0,0,0),
	PointP = cast(long,Point),
	win_SendEvent(WTVWin,e_native(tvm_getitem,0,PointP)),
	Point1 = cast(tv_item,PointP),
	Point1 = item(_,_,State,_,Text,_,BitmapIndex,_,_,_),
	wcc_get_state_list(State,[tvis_selected,tvis_cut,tvis_drophilited,tvis_bold,tvis_expanded],[],StateList),
	tv_bitmap_index(TVWin,BitmapId,BitmapIndex),!.
  tv_get_item(TVWin,_,"",[],0):-
	tv_info(TVWin,_,_,_,_,_),
	errorexit(error_vpi_package_bad_identifier),!.
  tv_get_item(_,_,"",[],0):-
	errorexit(error_vpi_package_bad_window),!.

/**GLOBAL PREDICATE*******************************************************
			     TV_EXPAND
 *************************************************************************/
  tv_expand(TVWin,ItemId):-
	tv_info(TVWin,WTVWin,_,_,_,_),
	tv_item_index(TVWin,ItemId,ItemIndex),
	win_SendEvent(WTVWin,e_native(tvm_expand,tve_toggle,ItemIndex)),!.
  tv_expand(TVWin,_):-
	tv_info(TVWin,_,_,_,_,_),
	errorexit(error_vpi_package_bad_identifier),!.
  tv_expand(_,_):-
	errorexit(error_vpi_package_bad_window),!.

/**GLOBAL PREDICATE*******************************************************
			     TV_SELECT
 *************************************************************************/
  tv_select(TVWin,ItemId,b_true):-
	tv_info(TVWin,WTVWin,_,_,_,_),
	tv_item_index(TVWin,ItemId,ItemIndex),
	win_SendEvent(WTVWin,e_native(tvm_selectitem,tvgn_caret,ItemIndex)),
	win_SendEvent(WTVWin,e_native(tvm_selectitem,tvgn_firstvisible,ItemIndex)),!.
  tv_select(TVWin,ItemId,b_false):-
	tv_get_item(TVWin,ItemId,Text,StateList,BitmapId),
	wcc_del_from_list(StateList,tvis_selected,[],StateList1),
	tv_set_item(TVWin,ItemId,Text,StateList1,BitmapId),!.
  tv_select(TVWin,_,_):-
	tv_info(TVWin,_,_,_,_,_),
	errorexit(error_vpi_package_bad_identifier),!.
  tv_select(_,_,_):-
	errorexit(error_vpi_package_bad_window),!.

/**GLOBAL PREDICATE*******************************************************
			     TV_SET_ITEM
 *************************************************************************/
  tv_set_item(TVWin,ItemId,Text,StateList1,BitmapId):-
	tv_correct_state_list(TVWin,ItemId,StateList1,StateList),
	tv_info(TVWin,WTVWin,_,_,_,_),
	tv_item_index(TVWin,ItemId,ItemIndex),
	retract(tv_item(TVWin,ItemIndex,ParentIndex,PreviosIndex,_,_,_,Layer)),
	assert(tv_item(TVWin,ItemIndex,ParentIndex,PreviosIndex,Text,StateList,BitmapId,Layer)),
	tv_reload_bitmap(TVWin,BitmapId,_),
	Mask = tvif_state + tvif_text,
	str_len(Text,TextLen),
	wcc_summ_list(StateList,0,State),
	Point = item(Mask,ItemIndex,State,0xffff,Text,TextLen,0,0,0,0),
	PointP = cast(long,Point),
	win_SendEvent(WTVWin,e_native(tvm_setitem,0,PointP)),!.
  tv_set_item(TVWin,_,_,_,_):-
	tv_info(TVWin,_,_,_,_,_),
	errorexit(error_vpi_package_bad_identifier),!.
  tv_set_item(_,_,_,_,_):-
	errorexit(error_vpi_package_bad_window),!.

/**GLOBAL PREDICATE*******************************************************
			     TV_INSERT_ITEM
 *************************************************************************/
  tv_insert_item(TVWin,ItemId,Parent,Previos,Text,StateList,BitmapId):-
	tv_info(TVWin,WTVWin,_,_,_,_),
	tv_get_item_index(TVWin,Parent,ParentIndex1),
	tv_correct_parentindex(ParentIndex1,ParentIndex),
	tv_get_item_index(TVWin,Previos,PreviosIndex1),
	tv_correct_previousindex(PreviosIndex1,PreviosIndex),
	wcc_summ_list(StateList,0,State),
	tv_reload_bitmap(TVWin,BitmapId,BitmapIndex),
	tv_get_layer(TVWin,Parent,Layer),
	str_len(Text,TextLength),
	Mask = tvif_text + tvif_image + tvif_selectedimage + tvif_param + tvif_state,
	Point = insertitem(ParentIndex,PreviosIndex,Mask,0,State,0xffff,Text,TextLength,BitmapIndex,
		BitmapIndex,0,0),
	PointP = cast(long,Point),
	ItemIndex = win_SendEvent(WTVWin,e_native(tvm_insertitem,0,PointP)),
	assert(tv_item(TVWin,ItemIndex,ParentIndex,PreviosIndex,Text,StateList,BitmapId,Layer)),
	assert(tv_item_index(TVWin,ItemId,ItemIndex)),!.
  tv_insert_item(_,_,_,_,_,_,_):-
	errorexit(error_vpi_package_bad_window),!.

/**GLOBAL PREDICATE*******************************************************
			     TV_DELETE_ITEM
 *************************************************************************/
  tv_delete_item(TVWin,ItemId):-
	tv_info(TVWin,WTVWin,_,_,_,_),
	retract(tv_item_index(TVWin,ItemId,ItemIndex)),
	retract(tv_item(TVWin,ItemIndex,_,_,_,_,_,_)),
	tv_retract_child(TVWin,ItemIndex),
	win_SendEvent(WTVWin,e_native(tvm_deleteitem,0,ItemIndex)),!.
  tv_delete_item(TVWin,_):-
	tv_info(TVWin,_,_,_,_,_),
	errorexit(error_vpi_package_bad_identifier),!.
  tv_delete_item(_,_):-
	errorexit(error_vpi_package_bad_window),!.

/**GLOBAL PREDICATE*******************************************************
			     TV_SORT_CHILDREN
 *************************************************************************/
  tv_sort_children(TVWin,ItemId):-
	tv_info(TVWin,WTVWin,_,_,_,_),
	tv_item_index(TVWin,ItemId,ItemIndex),
	win_SendEvent(WTVWin,e_native(tvm_sortchildren,0,ItemIndex)),!.
  tv_sort_children(TVWin,_):-
	tv_info(TVWin,_,_,_,_,_),
	errorexit(error_vpi_package_bad_identifier),!.
  tv_sort_children(_,_):-
	errorexit(error_vpi_package_bad_window),!.

/**GLOBAL PREDICATE*******************************************************
			     TV_EDIT_BEGIN
 *************************************************************************/
  tv_edit_begin(TVWin,ItemId):-
	tv_info(TVWin,WTVWin,_,_,_,_),
	tv_item_index(TVWin,ItemId,ItemIndex),
	win_SendEvent(WTVWin,e_native(tvm_editlabel,0,ItemIndex)),!.
  tv_edit_begin(TVWin,_):-
	tv_info(TVWin,_,_,_,_,_),
	errorexit(error_vpi_package_bad_identifier),!.
  tv_edit_begin(_,_):-
	errorexit(error_vpi_package_bad_window),!.

/**GLOBAL PREDICATE*******************************************************
			     TV_EDIT_END
 *************************************************************************/
  tv_edit_end(TVWin):-
	tv_info(TVWin,WTVWin,_,_,_,_),
	win_SendEvent(WTVWin,e_native(tvm_endeditlabelnow,b_false,0)),!.
  tv_edit_end(_):-
	errorexit(error_vpi_package_bad_window),!.

/**GLOBAL PREDICATE*******************************************************
			     TV_ENSURE_VISIBLE
 *************************************************************************/
  tv_ensure_visible(TVWin,ItemId):-
	tv_info(TVWin,WTVWin,_,_,_,_),
	tv_item_index(TVWin,ItemId,ItemIndex),
	win_SendEvent(WTVWin,e_native(tvm_ensurevisible,0,ItemIndex)),!.
  tv_ensure_visible(TVWin,_):-
	tv_info(TVWin,_,_,_,_,_),
	errorexit(error_vpi_package_bad_identifier),!.
  tv_ensure_visible(_,_):-
	errorexit(error_vpi_package_bad_window),!.

/**GLOBAL PREDICATE*******************************************************
			     TV_GET_INDENT
 *************************************************************************/
  tv_get_indent(TVWin,Indent):-
	tv_info(TVWin,WTVWin,_,_,_,_),
	Indent = win_SendEvent(WTVWin,e_native(tvm_getindent,0,0)),!.
  tv_get_indent(_,0):-
	errorexit(error_vpi_package_bad_window),!.

/**GLOBAL PREDICATE*******************************************************
			     TV_SET_INDENT
 *************************************************************************/
  tv_set_indent(TVWin,Indent):-
	tv_info(TVWin,WTVWin,_,_,_,_),
	win_SendEvent(WTVWin,e_native(tvm_setindent,Indent,0)),!.
  tv_set_indent(_,_):-
	errorexit(error_vpi_package_bad_window),!.

/**GLOBAL PREDICATE*******************************************************
			     TV_GET_ADVANCEDDATA
 *************************************************************************/
  tv_get_AdvancedData(TVWin,Data):-
	tv_advanced(TVWin,Advanced),
	Data = Advanced,!.
  tv_get_AdvancedData(_,""):-
	errorexit(error_vpi_package_bad_window),!.

/**GLOBAL PREDICATE*******************************************************
			     TV_SET_ADVANCEDDATA
 *************************************************************************/
  tv_set_AdvancedData(TVWin,Data):-
	retract(tv_advanced(TVWin,_)),
	assert(tv_advanced(TVWin,Data)),!.
  tv_set_AdvancedData(_,_):-
	errorexit(error_vpi_package_bad_window),!.

/**GLOBAL PREDICATE*******************************************************
			     TV_INIT
 *************************************************************************/
PREDICATES
tv_subclass_eh : EHANDLER
tv_dd_cb : DD_CALLBACK
CLAUSES

  tv_Init(TVWin,_,_,_,_,_):-
	tv_info(TVWin,WTVWin,_,_,_,_),
	win_Destroy(WTVWin),
	tv_HandleEvent(TVWin,e_Destroy),
	fail.
  tv_Init(TVWin,Flags,DDCursor,UnDDCursor,TreeList,CallBack):-
	tv_get_bitmap_par(TreeList,0,0,[],X,Y,BitmapsId),
	wcc_del_equal(BitmapsId,[],BitmapsId1),
	wcc_length_list(BitmapsId1,C),
	wcc_summ_list(Flags,0,SummFlags),
	Hinst = vpi_GetAttrVal(attr_win_instance),
	WTVWin = _wcc_create(Hinst,TVWin,"SysTreeView32","Tree View",SummFlags),
	Himage = _wcc_bitmap_create(X,Y,C),
	assert(tv_info(TVWin,WTVWin,Himage,CallBack,DDCursor,UnDDCursor)),
	tv_add_bitmaps(TVWin,Hinst,Himage,BitmapsId1),
	win_SendEvent(WTVWin,e_native(tvm_setimagelist,0,Himage)),
	tv_add_items(TVWin,WTVWin,TreeList,1,0,0),
	assert(tv_advanced(TVWin,"")),
	win_SetSubClassHandler(WTVWin,tv_subclass_eh,b_false),
	win_EnableHook(TVWin,b_true),
	dd_client(WTVWin,tv_dd_cb),
	ParentWin = win_GetParent(TVWin),
	trap(Font = win_GetFont(ParentWin),_,fail),
	trap(win_SetFont(TVWin,Font),_,fail),!.
  tv_Init(_,_,_,_,_,_).

/*************************************************************************
			     EVENT HANDLER
 *************************************************************************/
  tv_HandleEvent(TVWin,e_native(wm_notify,WParam,LParam),-1):-
	Event = cast(tv_nmhdr,LParam),
	Event = nmhdr(_,_,CodeOperation),
	tv_check_code(CodeOperation,TVWin,WParam,LParam,TV_Message,_Message),
%	write("_Message=",_Message,"\n"),
	tv_info(TVWin,_,_,CallBack,_,_),
	CallBack(TVWin,TV_Message),!,
	win_ReleaseMouse(),
	cursor_Set(TVWin,cursor_Arrow),
	retractall(tv_drag(_)),
	tv_check_edit(),!.
  tv_HandleEvent(TVWin,e_native(wm_notify,_,_),0):-
	retract(tv_edit(ItemId,Text)),
	tv_get_item(TVWin,ItemId,_,StateList,BitmapId),
	tv_set_item(TVWin,ItemId,Text,StateList,BitmapId),
	!,fail.
  tv_HandleEvent(TVWin,e_Size(Width,Height),0):-
	tv_info(TVWin,WTVWin,_,_,_,_),
	win_Move(WTVWin,rct(0,0,Width,Height)),!.
  tv_HandleEvent(TVWin,e_State(font(Font)),0):-
	tv_info(TVWin,WTVWin,_,_,_,_),
	win_SetFont(WTVWin,Font),!.
  tv_HandleEvent(TVWin,e_State(disabled()),0):-
	tv_info(TVWin,WTVWin,_,_,_,_),
	win_SetState(WTVWin,[wsf_Disabled]),!.
  tv_HandleEvent(TVWin,e_State(enabled()),0):-
	tv_info(TVWin,WTVWin,_,_,_,_),
	win_SetState(WTVWin,[wsf_Enabled]),!.
  tv_HandleEvent(TVWin,e_State(invisible()),0):-
	tv_info(TVWin,WTVWin,_,_,_,_),
	win_SetState(WTVWin,[wsf_Invisible]),!.
  tv_HandleEvent(TVWin,e_State(visible()),0):-
	tv_info(TVWin,WTVWin,_,_,_,_),
	win_SetState(WTVWin,[wsf_Visible]),!.
  tv_HandleEvent(TVWin,e_GetFocus,0):-
	tv_info(TVWin,WTVWin,_,_,_,_),
	win_SetFocus(WTVWin),!.
  tv_HandleEvent(TVWin,e_Destroy,0):-
	tv_info(TVWin,_,Himage,_,_,_),
	_wcc_bitmap_destroy(Himage),
	retractall(tv_bitmap_index(TVWin,_,_)),
	retractall(tv_item_index(TVWin,_,_)),
	retractall(tv_item(TVWin,_,_,_,_,_,_,_)),
	retractall(tv_info(TVWin,_,_,_,_,_)),
	retractall(tv_edit(_,_)),
	retractall(tv_drag(_)),
	retractall(tv_advanced(TVWin,_)),!,
	fail.

PREDICATES
  procedure tv_undrophilited(WINDOW TVWin)
CLAUSES
  tv_undrophilited(TVWin):-
	tv_item_index(TVWin,ItemId,_),
	tv_get_item(TVWin,ItemId,Text,StateList,BitmapId),
	wcc_member(tvis_drophilited,StateList),
	wcc_del_from_list(StateList,tvis_drophilited,[],StateList1),
	tv_set_item(TVWin,ItemId,Text,StateList1,BitmapId),
	fail.
  tv_undrophilited(_).

PREDICATES
  procedure tv_drophilited(WINDOW TVWin,UNSIGNED ItemId)
CLAUSES
  tv_drophilited(TVWin,ItemId):-
	tv_get_item(TVWin,ItemId,Text,StateList,BitmapId),
	StateList1 = [tvis_drophilited|StateList],
	tv_set_item(TVWin,ItemId,Text,StateList1,BitmapId),!.
  tv_drophilited(_,_).

PREDICATES
  determ tv_send_drag_callback(WINDOW TVWin,INTEGER MouseButton,WINDOW FromWin,STRING Data,UNSIGNED TItemId)
CLAUSES
  tv_send_drag_callback(TVWin,_,_,_,TItemId):-
	tv_drag_last_send(TVWin,TItemId,b_true),!.
  tv_send_drag_callback(TVWin,_,_,_,TItemId):-
	tv_drag_last_send(TVWin,TItemId,b_false),!,fail.
  tv_send_drag_callback(TVWin,mouse_button_left,FromWin,Data,TItemId):-
	tv_info(TVWin,_,_,CallBack,_,_),
	retractall(tv_drag_last_send(TVWin,_,_)),
	assert(tv_drag_last_send(TVWin,TItemId,b_false)),
	not(CallBack(TVWin,drag(FromWin,Data,TItemId))),
	retractall(tv_drag_last_send(TVWin,_,_)),
	assert(tv_drag_last_send(TVWin,TItemId,b_true)),!.
  tv_send_drag_callback(TVWin,mouse_button_right,FromWin,Data,TItemId):-
	tv_info(TVWin,_,_,CallBack,_,_),
	retractall(tv_drag_last_send(TVWin,_,_)),
	assert(tv_drag_last_send(TVWin,TItemId,b_false)),
	not(CallBack(TVWin,rdrag(FromWin,Data,TItemId))),
	retractall(tv_drag_last_send(TVWin,_,_)),
	assert(tv_drag_last_send(TVWin,TItemId,b_true)),!.

PREDICATES
  determ tv_send_drop_callback(WINDOW TVWin,INTEGER MouseButton,WINDOW FromWin,STRING Data,UNSIGNED TItemId)
CLAUSES
  tv_send_drop_callback(TVWin,mouse_button_left,FromWin,Data,TItemId):-
	tv_info(TVWin,_,_,CallBack,_,_),
	not(CallBack(TVWin,drop(FromWin,Data,TItemId))),!.
  tv_send_drop_callback(TVWin,mouse_button_right,FromWin,Data,TItemId):-
	tv_info(TVWin,_,_,CallBack,_,_),
	not(CallBack(TVWin,rdrop(FromWin,Data,TItemId))),!.

PREDICATES
  procedure tv_set_cursor(WINDOW TVWin,CURSOR Cursor)
CLAUSES
  tv_set_cursor(TVWin,Cursor):-
	OldCursor = cursor_Get(TVWin),
	OldCursor = Cursor,!.
  tv_set_cursor(TVWin,Cursor):-
	cursor_Set(TVWin,Cursor),!.

  tv_subclass_eh(WTVWIN,e_MouseDown(pnt(X,Y),c_Nothing,mouse_button_left),-1):-
	tv_info(TVWin,WTVWin,_,CallBack,_,_),
	tv_get_pos(TVWin,X,Y,ItemId,Place),
	tv_check_place(Place),
	tv_get_sel(TVWin,ItemId1),
	ItemId <> ItemId1,
	not(CallBack(TVWin,click(pnt(X,Y)))),
	tv_select(TVWin,ItemId,b_true),!.

/*** Drag and Drop client part ***/

  tv_subclass_eh(WTVWIN,e_MouseMove(Point,c_Nothing,[MouseButton]),0):-
	tv_drag(ItemId),
	tv_info(TVWin,WTVWin,_,_,DDCursor,_),
	tv_get_item(TVWin,ItemId,Text,StateList,BitmapId),
	tv_advanced(TVWin,Advanced),
	Data = tv_dragdrop(ItemId,StateList,BitmapId,Text,Advanced),
	trap(term_str(tv_dragdrop,Data,String),_,fail),
	dd_drag(WTVWIN,Point,MouseButton,String),
	tv_set_cursor(TVWin,DDCursor),
	!,fail.
  tv_subclass_eh(WTVWIN,e_MouseMove(_,_,_),0):-
	tv_drag(_),
	tv_info(TVWin,WTVWin,_,_,_,UnDDCursor),
	tv_set_cursor(TVWin,UnDDCursor),
	!,fail.

  tv_subclass_eh(WTVWIN,e_MouseUp(Point,c_Nothing,MouseButton),0):-
	retract(tv_drag(ItemId)),
	win_ReleaseMouse(),
	cursor_Set(WTVWIN,cursor_Arrow),
	tv_info(TVWin,WTVWin,_,_,_,_),
	tv_get_item(TVWin,ItemId,Text,StateList,BitmapId),
	tv_advanced(TVWin,Advanced),
	Data = tv_dragdrop(ItemId,StateList,BitmapId,Text,Advanced),
	trap(term_str(tv_dragdrop,Data,String),_,fail),
	dd_drop(WTVWIN,Point,MouseButton,String),
	!,fail.

/*** Drag and Drop server part ***/

  tv_dd_cb(dragend,WTVWin,_,_,_,_):-
	tv_info(TVWin,WTVWin,_,_,_,_),
	tv_undrophilited(TVWin),
	!,fail.
  tv_dd_cb(drag,WTVWin,FromWin,pnt(X,Y),MouseButton,String):-
	tv_info(TVWin,WTVWin,_,_,_,_),
	tv_get_pos(TVWin,X,Y,TItemId,_),
	tv_undrophilited(TVWin),
	tv_send_drag_callback(TVWin,MouseButton,FromWin,String,TItemId),
	tv_drophilited(TVWin,TItemId),
	!,fail.
  tv_dd_cb(drop,WTVWin,FromWin,pnt(X,Y),MouseButton,String):-
	retractall(tv_drag_last_send(_,_,_)),
	tv_info(TVWin,WTVWin,_,_,_,_),
	tv_get_pos(TVWin,X,Y,TItemId,_),
	tv_undrophilited(TVWin),
	tv_send_drop_callback(TVWin,MouseButton,FromWin,String,TItemId),
	!,fail.
  tv_dd_cb(_,_,_,_,_,_).

enddef /*** use_winctrl_TreeView ***/
