/******************************************************************************

		 Copyright (c) 1984 - 2000 Prolog Development Center A/S

 FileName:	LISTVIEW.PRO
 Purpose:	List View custom control object
 Written by:	Sergey Alexeev
 Version:	1.0
 Build:		002.000316
 Tested with:   Visual Prolog v.5.0 build 533
 Comments:
******************************************************************************/
ifdef use_winctrl_ListView

ifndef winctrls_pre_included
 #Error: this file requires include: winctrls.pre
enddef 

ifndef error_con_included
 #Error: this file requires include: error.con
enddef 

GLOBAL PREDICATES
  procedure void _wcc_SetWindowStyle(WINDOW WLVWin,LONG Style) - (i,i) language C
  procedure LONG /*Style*/ _wcc_GetWindowStyle(WINDOW WLVWin) - (i) language C

DOMAINS
LV_NMHDR = struct nmhdr(WCC_POINT WLVWin,UNSIGNED IdFrom,UNSIGNED CodeOperation)
LV_COLUMNS = struct column(UNSIGNED Mask,INTEGER Alignment,INTEGER Width,STRING Text,INTEGER TextLength,INTEGER SubColumn,INTEGER BitmapIndex,INTEGER Order)
LV_ITEMS = struct item(UNSIGNED Mask,INTEGER ItemIndex,INTEGER SubItem,UNSIGNED State,UNSIGNED StateMask,STRING Text,
	INTEGER TextLength,INTEGER BitmapIndex,LONG LParam,INTEGER Indent)
LV_HITTESTINFO = struct hittestinfo(INTEGER X,INTEGER Y,UNSIGNED Flags,INTEGER ItemIndex)
LV_LISTVIEW = struct listview(WCC_POINT WLVWin,UNSIGNED IdFrom,UNSIGNED CodeOperation,INTEGER ItemIndex,INTEGER SubItem,
	UNSIGNED NewState,UNSIGNED OldState,UNSIGNED Changed,WCC_POINT Action,LONG LParam)
LV_SORTFUNCTION = determ INTEGER (LONG ItemId1,LONG ItemId2,LONG DataToSortCallBack)
LV_KEYDOWN = struct keydown(WCC_POINT WTVWin,UNSIGNED IdFrom,UNSIGNED CodeOperation,SHORT VKey,UNSIGNED Flags)
LV_POINT = struct point(LONG X,LONG Y)
LV_DISPINFO = struct dispinfo(WCC_POINT WLVWin,UNSIGNED IdFrom,UNSIGNED CodeOperation,UNSIGNED Mask,INTEGER ItemIndex,
	INTEGER SubItem,UNSIGNED State,UNSIGNED StateMask,STRING Text,INTEGER TextLength,INTEGER BitmapIndex,LONG LParam,INTEGER Indent)

CONSTANTS
lvs_typemask		= 0x0003
lvs_revtypemask		= 0xfffffffc

lvs_stylemask		= 0x3bbc
lvs_revstylemask	= 0xffffc443

ifndef unicode_set
lvm_editlabel		= 0x1017
lvm_finditem		= 0x100d
lvm_getcolumn		= 0x1019
lvm_getisearchstring	= 0x1034
lvm_getitem		= 0x1005
lvm_getitemtext		= 0x102d
lvm_getstringwidth	= 0x1011
lvm_insertcolumn	= 0x101b
lvm_insertitem		= 0x1007
lvm_setcolumn		= 0x101a
lvm_setitem		= 0x1006
lvm_setitemtext		= 0x102e
elsedef
lvm_editlabel		= 0x1076
lvm_finditem		= 0x1053
lvm_getcolumn		= 0x105f
lvm_getisearchstring	= 0x1075
lvm_getitem		= 0x104b
lvm_getitemtext		= 0x1073
lvm_getstringwidth	= 0x1057
lvm_insertcolumn	= 0x1061
lvm_insertitem		= 0x104d
lvm_setcolumn		= 0x1060
lvm_setitem		= 0x104c
lvm_setitemtext		= 0x1074
enddef

lvm_arrange		= 0x1016
lvm_createdragimage	= 0x1021
lvm_deleteallitems	= 0x1009
lvm_deletecolumn	= 0x101c
lvm_deleteitem		= 0x1008
lvm_ensurevisible	= 0x1013
lvm_getbkcolor		= 0x1000
lvm_getcallbackmask	= 0x100a
lvm_getcolumnwidth	= 0x101d
lvm_getcountperpage	= 0x1028
lvm_geteditcontrol	= 0x1018
lvm_getimagelist	= 0x1002
lvm_getitemcount	= 0x1004
lvm_getitemposition	= 0x1010
lvm_getitemrect		= 0x100e
lvm_getitemspacing	= 0x1033
lvm_getitemstate	= 0x102c
lvm_getnextitem		= 0x100c
lvm_getorigin		= 0x1029
lvm_getselectedcount	= 0x1032
lvm_gettextbkcolor	= 0x1025
lvm_gettextcolor	= 0x1023
lvm_gettopindex		= 0x1027
lvm_getviewrect		= 0x1022
lvm_hittest		= 0x1012
lvm_redrawitems		= 0x1015
lvm_scroll		= 0x1014
lvm_setbkcolor		= 0x1001
lvm_setcallbackmask	= 0x100b
lvm_setcolumnwidth	= 0x101e
lvm_setimagelist	= 0x1003
lvm_setitemcount	= 0x102f
lvm_setitemposition	= 0x100f
lvm_setitemposition32	= 0x1031
lvm_setitemstate	= 0x102b
lvm_settextbkcolor	= 0x1026
lvm_settextcolor	= 0x1024
lvm_sortitems		= 0x1030
lvm_update		= 0x102a

lvcf_fmt		= 0x0001
lvcf_width		= 0x0002
lvcf_text		= 0x0004
lvcf_subitem		= 0x0008
lvcf_image		= 0x0010
lvcf_order		= 0x0020

lvcfmt_left		= 0x0000
lvcfmt_right		= 0x0001
lvcfmt_center		= 0x0002
lvcfmt_justifymask	= 0x0003
lvcfmt_image		= 0x0800
lvcfmt_bitmap_on_right	= 0x1000
lvcfmt_col_has_images	= 0x8000

lvif_text		= 0x0001
lvif_image		= 0x0002
lvif_param		= 0x0004
lvif_state		= 0x0008
lvif_indent		= 0x0010
lvif_norecompute	= 0x0800

lvsil_normal		= 0
lvsil_small		= 1
lvsil_state		= 2

ifndef unicode_set
lvn_beginlabeledit	= 0xffffff97
lvn_endlabeledit	= 0xffffff96
lvn_odfinditem		= 0xffffff68
elsedef
lvn_beginlabeledit	= 0xffffff51
lvn_endlabeledit	= 0xffffff50
lvn_odfinditem		= 0xffffff4d
enddef
lvn_itemchanging	= 0xffffff9c
lvn_itemchanged		= 0xffffff9b
lvn_insertitem		= 0xffffff9a
lvn_deleteitem		= 0xffffff99
lvn_deleteallitems	= 0xffffff98
lvn_columnclick		= 0xffffff94
lvn_begindrag		= 0xffffff93
lvn_beginrdrag		= 0xffffff91
lvn_odcachehint		= 0xffffff8f
lvn_itemactivate	= 0xffffff8e
lvn_keydown		= 0xffffff65

lva_default		= 0x0000
lva_alignleft		= 0x0001
lva_aligntop		= 0x0002
lva_snaptogrid		= 0x0005

lvni_above		= 0x0100
lvni_below		= 0x0200
lvni_toleft		= 0x0400
lvni_toright		= 0x0800

DATABASE - lv_db
  lv_bitmap_index(WINDOW LVWin,UNSIGNED BitmapId,INTEGER BitmapIndex,INTEGER Layer)
  lv_item_index(WINDOW LVWin,UNSIGNED ItemId,INTEGER ItemIndex,UNSIGNED LargeBitmapId,UNSIGNED SmallBitmapId)
  lv_info(WINDOW LVWin,WINDOW WLVWin,WCC_POINT HimageLarge,WCC_POINT HimageSmall,LV_CALLBACK,
	CURSOR DDCursor,CURSOR UnDDCursor,INTEGER NumColumn)
  lv_sorting(WINDOW LVWin,LV_SORTCALLBACK)
  lv_sorting1(WINDOW LVWin,LV_ORDER Order,UNSIGNED CulumnNumber,UNSIGNED HeaderRows,UNSIGNED FooterRows)
  lv_item_order(WINDOW LVWin,ILIST ItemIdList)
  lv_edit(UNSIGNED ItemId,STRING)
  lv_drag(UNSIGNED ItemId)
  lv_advanced(WINDOW LVWin,STRING Advanced)

PREDICATES
  procedure lv_get_bitmap_par(LV_ITEMLIST,INTEGER XinL,INTEGER YinL,ILIST BitmapsIdInL,INTEGER XoutL,INTEGER YoutL,ILIST BitmapsIdOutL,
	INTEGER XinS,INTEGER YinS,ILIST BitmapsIdInS,INTEGER XoutS,INTEGER YoutS,ILIST BitmapsIdOutS)
CLAUSES
  lv_get_bitmap_par([],XoutL,YoutL,BoutL,XoutL,YoutL,BoutL,XoutS,YoutS,BoutS,XoutS,YoutS,BoutS):-!.
  lv_get_bitmap_par([item(_,_,BitmapIdL,BitmapIdS,_,_)|Rest],XinL,YinL,BinL,XoutL,YoutL,BoutL,XinS,YinS,BinS,XoutS,YoutS,BoutS):-
	PictL = pict_GetFromRes(BitmapIdL),
	pict_GetSize(PictL,WidthL,HeightL,_),
	pict_Destroy (PictL),
	wcc_max(XinL,WidthL,XinL1),
	wcc_max(YinL,HeightL,YinL1),!,
	PictS = pict_GetFromRes(BitmapIdS),
	pict_GetSize(PictS,WidthS,HeightS,_),
	pict_Destroy (PictS),
	wcc_max(XinS,WidthS,XinS1),
	wcc_max(YinS,HeightS,YinS1),!,
	lv_get_bitmap_par(Rest,XinL1,YinL1,[BitmapIdL|BinL],XoutL,YoutL,BoutL,XinS1,YinS1,[BitmapIdS|BinS],XoutS,YoutS,BoutS).
  lv_get_bitmap_par(_,_,_,_,0,0,[],_,_,_,0,0,[]):-
	errorexit(),!.

PREDICATES
  procedure lv_add_bitmaps(INTEGER Layer,WINDOW LVWin,LONG Hinst,LONG Himage,ILIST)
CLAUSES
  lv_add_bitmaps(_,_,_,_,[]):-!.
  lv_add_bitmaps(Layer,LVWin,Hinst,Himage,[BitmapId|Rest]):-
	BitmapIndex = _wcc_bitmap_add(Hinst,Himage,BitmapId),
	assert(lv_bitmap_index(LVWin,BitmapId,BitmapIndex,Layer)),!,
	lv_add_bitmaps(Layer,LVWin,Hinst,Himage,Rest).
  lv_add_bitmaps(_,_,_,_,_):-
	errorexit(),!.

PREDICATES
  procedure lv_convert_alignment(INTEGER Column,LV_ALIGNMENT,INTEGER)
CLAUSES
  lv_convert_alignment(0,_,lvcfmt_left):-!.
  lv_convert_alignment(_,left,lvcfmt_left):-!.
  lv_convert_alignment(_,right,lvcfmt_right):-!.
  lv_convert_alignment(_,center,lvcfmt_center):-!.
  lv_convert_alignment(_,_,lvcfmt_left).

PREDICATES
  procedure lv_convert_alignment1(LV_ALIGNMENT,INTEGER)
CLAUSES
  lv_convert_alignment1(left,lvcfmt_left):-!.
  lv_convert_alignment1(right,lvcfmt_right):-!.
  lv_convert_alignment1(center,lvcfmt_center):-!.
  lv_convert_alignment1(left,_).

PREDICATES
  procedure lv_add_columns(WINDOW WLVWin,LV_COLUMNLIST ListList,INTEGER Column)
CLAUSES
  lv_add_columns(_,[],_):-!.
  lv_add_columns(WLVWin,[column(Text,Width,AlignmentD)|Rest],Column):-
	lv_convert_alignment(Column,AlignmentD,Alignment),
	Mask = lvcf_fmt + lvcf_text + lvcf_width + lvcf_subitem,
	str_len(Text,TextLength),
%	column(Mask,Alignment,Width,Text,TextLength,SubColumn,BitmapIndex,Order)
	Point = column(Mask,Alignment,Width,Text,TextLength,Column,0,0),
	PointP = cast(long,Point),
	win_SendEvent(WLVWin,e_native(lvm_insertcolumn,Column,PointP)),
	Column1 = Column + 1,!,
	lv_add_columns(WLVWin,Rest,Column1).
  lv_add_columns(_,_,_):-
	errorexit(),!.

PREDICATES
  procedure lv_add_subitems(WINDOW WLVWin,INTEGER ItemIndex,SLIST SubItemText,INTEGER SubItem)
CLAUSES
  lv_add_subitems(_,_,[],_):-!.
  lv_add_subitems(WLVWin,ItemIndex,[Text|Rest],SubItem):-
	Mask = lvif_text,
	str_len(Text,TextLength),
%	item(Mask,ItemIndex,SubItem,State,StateMask,Text,TextLength,BitmapIndex,LParam,Indent)
	Point = item(Mask,ItemIndex,SubItem,0,0,Text,TextLength,0,0,0),
	PointP = cast(long,Point),
	win_SendEvent(WLVWin,e_native(lvm_setitemtext,ItemIndex,PointP)),
	SubItem1 = SubItem + 1,!,
	lv_add_subitems(WLVWin,ItemIndex,Rest,SubItem1).
  lv_add_subitems(_,_,_,_):-
	errorexit(),!.

PREDICATES
  procedure lv_get_bitmap_index(WINDOW LVWin,INTEGER ItemId,INTEGER BitmapIndex)
  procedure lv_get_bitmap_index(WINDOW LVWin,INTEGER LargeBitmapId,INTEGER SmallBitmapId,INTEGER BitmapIndex)
CLAUSES
  lv_get_bitmap_index(LVWin,ItemId,BitmapIndex):-
	lv_get_type(LVWIN,Type),
	Type = lvs_icon,
	lv_item_index(LVWin,ItemId,_,BitmapId,_),
	lv_bitmap_index(LVWin,BitmapId,BitmapIndex,1),!.
  lv_get_bitmap_index(LVWin,ItemId,BitmapIndex):-
	lv_get_type(LVWIN,Type),
	Type <> lvs_icon,
	lv_item_index(LVWin,ItemId,_,_,BitmapId),
	lv_bitmap_index(LVWin,BitmapId,BitmapIndex,2),!.
  lv_get_bitmap_index(_,_,0):-
	errorexit(),!.
  lv_get_bitmap_index(LVWin,BitmapId,_,BitmapIndex):-
	lv_get_type(LVWIN,Type),
	Type = lvs_icon,
	lv_bitmap_index(LVWin,BitmapId,BitmapIndex,1),!.
  lv_get_bitmap_index(LVWin,_,BitmapId,BitmapIndex):-
	lv_get_type(LVWIN,Type),
	Type <> lvs_icon,
	lv_bitmap_index(LVWin,BitmapId,BitmapIndex,2),!.
  lv_get_bitmap_index(_,_,_,0):-
	errorexit(),!.

PREDICATES
  procedure lv_add_items(WINDOW LVWin,WINDOW WLVWin,LV_ITEMLIST ItemList,INTEGER Item)
CLAUSES
  lv_add_items(_,_,[],_):-!.
  lv_add_items(LVWin,WLVWin,[item(ItemId,Text,LargeBitmapId,SmallBitmapId,StateList,SubItemText)|Rest],Item):-
	Mask = lvif_text + lvif_image + lvif_state + lvif_param,
	wcc_summ_list(StateList,0,State),
	str_len(Text,TextLength),
	lv_get_bitmap_index(LVWin,LargeBitmapId,SmallBitmapId,BitmapIndex),
%	item(Mask,ItemIndex,SubItem,State,StateMask,Text,TextLength,BitmapIndex,LParam,Indent)
	Point = item(Mask,Item,0,State,0xffff,Text,TextLength,BitmapIndex,ItemId,0),
	PointP = cast(long,Point),
	ItemIndex = win_SendEvent(WLVWin,e_native(lvm_insertitem,0,PointP)),
	lv_add_subitems(WLVWin,ItemIndex,SubItemText,1),
	assert(lv_item_index(LVWin,ItemId,ItemIndex,LargeBitmapId,SmallBitmapId)),
	Item1 = Item + 1,!,
	lv_add_items(LVWin,WLVWin,Rest,Item1).
  lv_add_items(_,_,_,_):-
	errorexit(),!.

PREDICATES
  procedure lv_get_mouse_pos(WINDOW LVWin,INTEGER X,INTEGER Y)
CLAUSES
  lv_get_mouse_pos(LVWin,X,Y):-
	lv_info(LVWin,WLVWin,_,_,_,_,_,_),
	Pnt = cursor_GetPos(WLVWin),
	Pnt = pnt(X,Y),!.
  lv_get_mouse_pos(_,0,0).

PREDICATES
  procedure lv_get_item_id(WINDOW LVWin,INTEGER ItemIndex,UNSIGNED ItemId)
CLAUSES
  lv_get_item_id(LVWin,ItemIndex,ItemId):-
	lv_item_index(LVWin,ItemId,ItemIndex,_,_),!.
  lv_get_item_id(_,_,wcc_null).

PREDICATES
  procedure lv_get_SubitemText(WINDOW WLVWin,INTEGER ItemIndex,INTEGER SubItem,SLIST,SLIST SubItemText)
CLAUSES
  lv_get_SubitemText(_,_,1,SubItemText,SubItemText):-!.
  lv_get_SubitemText(WLVWin,ItemIndex,SubItem,Curr,SubItemText):-
	SI = SubItem - 1,
	Mask = lvif_text,
	str_len(String,1000),
	Point = item(Mask,ItemIndex,SI,0,0,String,1000,0,0,0),
	PointP = cast(long,Point),
	win_SendEvent(WLVWin,e_native(lvm_getitemtext,ItemIndex,PointP)),
	Point1 = cast(lv_items,PointP),
	Point1 = item(_,_,_,_,_,Text,_,_,_,_),!,
	lv_get_SubitemText(WLVWin,ItemIndex,SI,[Text|Curr],SubItemText).

PREDICATES
  procedure lv_get_SelectedItems(WINDOW LVWin,ILIST ItemIdListFull,ILIST,ILIST ItemIdList)
CLAUSES
  lv_get_SelectedItems(_,[],ItemIdList,ItemIdList):-!.
  lv_get_SelectedItems(LVWin,[ItemId|Rest],Curr,ItemIdList):-
	lv_get_item(LVWin,ItemId,Item),
	Item = item(_,_,_,_,StateList,_),
	wcc_member(lvis_selected,StateList),!,
	lv_get_SelectedItems(LVWin,Rest,[ItemId|Curr],ItemIdList).
  lv_get_SelectedItems(LVWin,[_|Rest],Curr,ItemIdList):-!,
	lv_get_SelectedItems(LVWin,Rest,Curr,ItemIdList).
  lv_get_SelectedItems(_,_,_,[]):-
	errorexit(),!.

PREDICATES
  procedure lv_get_FocusedItem(WINDOW LVWin,ILIST ItemIdListFull,UNSIGNED ItemId)
CLAUSES
  lv_get_FocusedItem(_,[],wcc_null):-!.
  lv_get_FocusedItem(LVWin,[ItemId|_],ItemId):-
	lv_get_item(LVWin,ItemId,Item),
	Item = item(_,_,_,_,StateList,_),
	wcc_member(lvis_focused,StateList),!.
  lv_get_FocusedItem(LVWin,[_|Rest],ItemId):-!,
	lv_get_FocusedItem(LVWin,Rest,ItemId).
  lv_get_FocusedItem(_,_,wcc_null):-
	errorexit(),!.

PREDICATES
  procedure lv_adjust_style(ILIST Style1,ILIST Style2)
CLAUSES
  lv_adjust_style(Style1,Style2):-
	not(wcc_member(lvs_alignleft,Style1)),
	Style2 = [lvs_aligntop|Style1],!.
  lv_adjust_style(Style,Style).

PREDICATES
  procedure lv_adjust_style1(ILIST StyleList1,ILIST StyleList2,ILIST StyleListOut)
CLAUSES
  lv_adjust_style1(StyleList1,StyleList2,StyleListOut):-
	wcc_member(lvs_aligntop,StyleList1),
	wcc_member(lvs_alignleft,StyleList2),
	wcc_member(lvs_aligntop,StyleList2),
	wcc_del_from_list(StyleList2,lvs_aligntop,[],StyleList0),!,
	lv_adjust_style1(StyleList1,StyleList0,StyleListOut).
  lv_adjust_style1(StyleList1,StyleList2,StyleListOut):-
	wcc_member(lvs_alignleft,StyleList1),
	wcc_member(lvs_aligntop,StyleList2),
	wcc_member(lvs_alignleft,StyleList2),
	wcc_del_from_list(StyleList2,lvs_alignleft,[],StyleList0),!,
	lv_adjust_style1(StyleList1,StyleList0,StyleListOut).
  lv_adjust_style1(StyleList1,StyleList2,StyleListOut):-
	wcc_member(lvs_sortascending,StyleList1),
	wcc_member(lvs_sortdescending,StyleList2),
	wcc_member(lvs_sortascending,StyleList2),
	wcc_del_from_list(StyleList2,lvs_sortascending,[],StyleList0),!,
	lv_adjust_style1(StyleList1,StyleList0,StyleListOut).
  lv_adjust_style1(StyleList1,StyleList2,StyleListOut):-
	wcc_member(lvs_sortdescending,StyleList1),
	wcc_member(lvs_sortascending,StyleList2),
	wcc_member(lvs_sortdescending,StyleList2),
	wcc_del_from_list(StyleList2,lvs_sortdescending,[],StyleList0),!,
	lv_adjust_style1(StyleList1,StyleList0,StyleListOut).
  lv_adjust_style1(_,StyleList,StyleList).

PREDICATES
  procedure lv_save_items_order1(WINDOW LVWin,WINDOW WLVWin,INTEGER ItemCount,ILIST,ILIST ItemIdList)
CLAUSES
  lv_save_items_order1(_,_,-1,ItemIdList,ItemIdList):-!.
  lv_save_items_order1(LVWin,WLVWin,ItemIndex,Curr,ItemIdList):-
	Mask = lvif_param,
	Point = item(Mask,ItemIndex,0,0,0,"",0,0,0,0),
	PointP = cast(long,Point),
	win_SendEvent(WLVWin,e_native(lvm_getitem,0,PointP)),
	Point1 = cast(lv_items,PointP),
	Point1 = item(_,_,_,_,_,_,_,_,ItemId,_),
	II = ItemIndex - 1,!,
	lv_save_items_order1(LVWin,WLVWin,II,[ItemId|Curr],ItemIdList).
  lv_save_items_order1(_,_,_,_,[]):-
	errorexit(),!.

PREDICATES
  procedure lv_save_items_order(WINDOW LVWin)
CLAUSES
  lv_save_items_order(LVWin):-
	lv_info(LVWin,WLVWin,_,_,_,_,_,_),
	ItemCount = win_SendEvent(WLVWin,e_native(lvm_getitemcount,0,0)),
	IC = ItemCount - 1,
	lv_save_items_order1(LVWin,WLVWin,IC,[],ItemIdList),
	retractall(lv_item_order(LVWin,_)),
	wcc_reverse_list(ItemIdList,ItemIdList1),
	assert(lv_item_order(LVWin,ItemIdList1)),!.
  lv_save_items_order(_).

PREDICATES
  procedure lv_adjust_item_index1(WINDOW LVWin,WINDOW WLVWin,INTEGER ItemCount)
CLAUSES
  lv_adjust_item_index1(_,_,-1):-!.
  lv_adjust_item_index1(LVWin,WLVWin,ItemIndex):-
	Mask = lvif_param,
	Point = item(Mask,ItemIndex,0,0,0,"",0,0,0,0),
	PointP = cast(long,Point),
	win_SendEvent(WLVWin,e_native(lvm_getitem,0,PointP)),
	Point1 = cast(lv_items,PointP),
	Point1 = item(_,_,_,_,_,_,_,_,ItemId,_),
	retract(lv_item_index(LVWin,ItemId,_,LargeBitmapId,SmallBitmapId)),
	assert(lv_item_index(LVWin,ItemId,ItemIndex,LargeBitmapId,SmallBitmapId)),
	II = ItemIndex - 1,!,
	lv_adjust_item_index1(LVWin,WLVWin,II).
  lv_adjust_item_index1(_,_,_):-
	errorexit(),!.

PREDICATES
  procedure lv_adjust_item_index(WINDOW LVWin)
CLAUSES
  lv_adjust_item_index(LVWin):-
	lv_info(LVWin,WLVWin,_,_,_,_,_,_),
	ItemCount = win_SendEvent(WLVWin,e_native(lvm_getitemcount,0,0)),
	IC = ItemCount - 1,
	lv_adjust_item_index1(LVWin,WLVWin,IC),!.
  lv_adjust_item_index(_).

PREDICATES
  procedure lv_reload_item_images(WINDOW LVWin,WINDOW WLVWin)
CLAUSES
  lv_reload_item_images(LVWin,WLVWin):-
	lv_item_index(LVWin,ItemId,ItemIndex,_,_),
	lv_get_bitmap_index(LVWin,ItemId,BitmapIndex),
	Mask = lvif_image,
	Point = item(Mask,ItemIndex,0,0,0,"",0,BitmapIndex,0,0),
	PointP = cast(long,Point),
	win_SendEvent(WLVWin,e_native(lvm_setitem,0,PointP)),
	fail.
  lv_reload_item_images(_,_).

PREDICATES
  procedure lv_add_bitmap(WINDOW TVWin,UNSIGNED NewLargeBitmapId,UNSIGNED NewSmallBitmapId)
CLAUSES
  lv_add_bitmap(LVWin,NewLargeBitmapId,NewSmallBitmapId):-
	findall(LargeBitmapId,lv_item_index(LVWin,_,_,LargeBitmapId,_),LargeBitmapIdList),
	findall(SmallBitmapId,lv_item_index(LVWin,_,_,_,SmallBitmapId),SmallBitmapIdList),
	wcc_del_equal([NewLargeBitmapId|LargeBitmapIdList],[],LargeBitmapIdList1),
	wcc_del_equal([NewSmallBitmapId|SmallBitmapIdList],[],SmallBitmapIdList1),
	wcc_get_bitmap_size(LargeBitmapIdList1,0,0,LX,LY),
	wcc_get_bitmap_size(SmallBitmapIdList1,0,0,SX,SY),
	wcc_length_list(LargeBitmapIdList1,LargeNumBitmap),
	wcc_length_list(SmallBitmapIdList1,SmallNumBitmap),

	retract(lv_info(LVWin,WLVWin,HimageLarge,HimageSmall,CallBack,DDCursor,UnDDCursor,NumColumn)),
	retractall(lv_bitmap_index(LVWin,_,_,_)),
	Hinst = vpi_GetAttrVal(attr_win_instance),
	_wcc_bitmap_destroy(HimageLarge),
	_wcc_bitmap_destroy(HimageSmall),
	NewHimageLarge = _wcc_bitmap_create(LX,LY,LargeNumBitmap),
	NewHimageSmall = _wcc_bitmap_create(SX,SY,SmallNumBitmap),
	assert(lv_info(LVWin,WLVWin,NewHimageLarge,NewHimageSmall,CallBack,DDCursor,UnDDCursor,NumColumn)),
	lv_add_bitmaps(1,LVWin,Hinst,NewHimageLarge,LargeBitmapIdList1),
	lv_add_bitmaps(2,LVWin,Hinst,NewHimageSmall,SmallBitmapIdList1),
	win_SendEvent(WLVWin,e_native(lvm_setimagelist,lvsil_normal,NewHimageLarge)),
	win_SendEvent(WLVWin,e_native(lvm_setimagelist,lvsil_small,NewHimageSmall)),
	lv_reload_item_images(LVWin,WLVWin),!.
  lv_add_bitmap(_,_,_):-
	errorexit(),!.

PREDICATES
  procedure lv_convert_arrange(LV_ARRANGE,INTEGER)
CLAUSES
  lv_convert_arrange(alignleft,lva_alignleft):-!.
  lv_convert_arrange(aligntop,lva_aligntop):-!.
  lv_convert_arrange(default,lva_default):-!.
  lv_convert_arrange(snaptogrid,lva_snaptogrid):-!.
  lv_convert_arrange(_,lva_alignleft):-
	errorexit(),!.

PREDICATES
  procedure lv_convert_relpos(LV_RELATIVEPOS,INTEGER)
CLAUSES
  lv_convert_relpos(above,lvni_above):-!.
  lv_convert_relpos(below,lvni_below):-!.
  lv_convert_relpos(toleft,lvni_toleft):-!.
  lv_convert_relpos(toright,lvni_toright):-!.
  lv_convert_relpos(_,lvni_above):-
	errorexit(),!.

PREDICATES
  determ lv_check_edit()
CLAUSES
  lv_check_edit():-
	not(lv_edit(_,_)),!.
  lv_check_edit():-
	retract(lv_edit(_,_)),fail.

PREDICATES
  determ lv_check_code(ULONG CodeOperation,WINDOW LVWin,UNSIGNED WParam,LONG LParam,LV_MESSAGE,STRING Message)
CLAUSES
  lv_check_code(nm_outofmemory,_,_,_,outofmemory,"OutOfMemory"):-!.
  lv_check_code(nm_click,LVWin,_,_,click(pnt(X,Y)),"Click"):-
	lv_get_mouse_pos(LVWin,X,Y),!.
  lv_check_code(nm_dblclk,LVWin,_,_,dblclick(pnt(X,Y)),"DblClk"):-
	lv_get_mouse_pos(LVWin,X,Y),!.
  lv_check_code(nm_return,LVWin,_,_,return(ItemId),"Return"):-
	lv_get_focus(LVWin,ItemId),!.
  lv_check_code(nm_rclick,LVWin,_,_,rclick(pnt(X,Y)),"RClick"):-
	lv_get_mouse_pos(LVWin,X,Y),!.
  lv_check_code(nm_rdblclk,LVWin,_,_,rdblclick(pnt(X,Y)),"RDblClk"):-
	lv_get_mouse_pos(LVWin,X,Y),!.
  lv_check_code(nm_setfocus,_,_,_,setfocus,"SetFocus"):-!.
  lv_check_code(nm_killfocus,_,_,_,losefocus,"KillFocus"):-!.
%  tv_check_code(nm_customdraw,_,_,_,none,"CustomDraw"):-!.
%  tv_check_code(nm_hover,_,_,_,none,"Hover"):-!.
  lv_check_code(lvn_itemchanging,LVWin,_,LParam,selecting(ItemId,b_true),"ItemSelecting"):-
	Event = cast(lv_listview,LParam),
	Event = listview(_,_,_,ItemIndex,_,NewState,OldState,_,_,_),
	bitand(OldState,lvis_selected,OldSelected),
	OldSelected <> lvis_selected,
	bitand(NewState,lvis_selected,NewSelected),
	NewSelected = lvis_selected,
	lv_item_index(LVWin,ItemId,ItemIndex,_,_),!.
  lv_check_code(lvn_itemchanging,LVWin,_,LParam,selecting(ItemId,b_false),"ItemSelecting"):-
	Event = cast(lv_listview,LParam),
	Event = listview(_,_,_,ItemIndex,_,NewState,OldState,_,_,_),
	bitand(OldState,lvis_selected,OldSelected),
	OldSelected = lvis_selected,
	bitand(NewState,lvis_selected,NewSelected),
	NewSelected <> lvis_selected,
	lv_item_index(LVWin,ItemId,ItemIndex,_,_),!.
  lv_check_code(lvn_itemchanged,LVWin,_,LParam,selected(ItemId,b_true),"ItemSelected"):-
	Event = cast(lv_listview,LParam),
	Event = listview(_,_,_,ItemIndex,_,NewState,OldState,_,_,_),
	bitand(OldState,lvis_selected,OldSelected),
	OldSelected <> lvis_selected,
	bitand(NewState,lvis_selected,NewSelected),
	NewSelected = lvis_selected,
	lv_item_index(LVWin,ItemId,ItemIndex,_,_),!.
  lv_check_code(lvn_itemchanged,LVWin,_,LParam,selected(ItemId,b_false),"ItemSelected"):-
	Event = cast(lv_listview,LParam),
	Event = listview(_,_,_,ItemIndex,_,NewState,OldState,_,_,_),
	bitand(OldState,lvis_selected,OldSelected),
	OldSelected = lvis_selected,
	bitand(NewState,lvis_selected,NewSelected),
	NewSelected <> lvis_selected,
	lv_item_index(LVWin,ItemId,ItemIndex,_,_),!.
  lv_check_code(lvn_itemchanging,LVWin,_,LParam,focusing(ItemId,b_true),"ItemFocusing"):-
	Event = cast(lv_listview,LParam),
	Event = listview(_,_,_,ItemIndex,_,NewState,OldState,_,_,_),
	bitand(OldState,lvis_focused,OldFocused),
	OldFocused <> lvis_focused,
	bitand(NewState,lvis_focused,NewFocused),
	NewFocused = lvis_focused,
	lv_item_index(LVWin,ItemId,ItemIndex,_,_),!.
  lv_check_code(lvn_itemchanging,LVWin,_,LParam,focusing(ItemId,b_false),"ItemFocusing"):-
	Event = cast(lv_listview,LParam),
	Event = listview(_,_,_,ItemIndex,_,NewState,OldState,_,_,_),
	bitand(OldState,lvis_focused,OldFocused),
	OldFocused = lvis_focused,
	bitand(NewState,lvis_focused,NewFocused),
	NewFocused <> lvis_focused,
	lv_item_index(LVWin,ItemId,ItemIndex,_,_),!.
  lv_check_code(lvn_itemchanged,LVWin,_,LParam,focused(ItemId,b_true),"ItemFocused"):-
	Event = cast(lv_listview,LParam),
	Event = listview(_,_,_,ItemIndex,_,NewState,OldState,_,_,_),
	bitand(OldState,lvis_focused,OldFocused),
	OldFocused <> lvis_focused,
	bitand(NewState,lvis_focused,NewFocused),
	NewFocused = lvis_focused,
	lv_item_index(LVWin,ItemId,ItemIndex,_,_),!.
  lv_check_code(lvn_itemchanged,LVWin,_,LParam,focused(ItemId,b_false),"ItemFocused"):-
	Event = cast(lv_listview,LParam),
	Event = listview(_,_,_,ItemIndex,_,NewState,OldState,_,_,_),
	bitand(OldState,lvis_focused,OldFocused),
	OldFocused = lvis_focused,
	bitand(NewState,lvis_focused,NewFocused),
	NewFocused <> lvis_focused,
	lv_item_index(LVWin,ItemId,ItemIndex,_,_),!.
  lv_check_code(lvn_columnclick,_,_,LParam,columnclick(ColumnNumber),"ColumnClick"):-
	Event = cast(lv_listview,LParam),
	Event = listview(_,_,_,_,ColumnNumber1,_,_,_,_,_),
	ColumnNumber = ColumnNumber1 + 1,!.
  lv_check_code(lvn_beginlabeledit,LVWin,_,LParam,edit(ItemId),"BeginLabelEdit"):-
	Event = cast(lv_dispinfo,LParam),
	Event = dispinfo(_,_,_,_,ItemIndex,_,_,_,_Text,_,_,_,_),
	lv_get_item_id(LVWin,ItemIndex,ItemId),!.
  lv_check_code(lvn_endlabeledit,LVWin,_,LParam,modified(ItemId,Text),"EndLabelEdit"):-
	Event = cast(lv_dispinfo,LParam),
	Event = dispinfo(_,_,_,_,ItemIndex,_,_,_,Text,_,_,_,_),
	PointToText = cast(long,Text),
	PointToText <> 0,
	lv_get_item_id(LVWin,ItemIndex,ItemId),
	assert(lv_edit(ItemId,Text)),!.
  lv_check_code(lvn_begindrag,LVWin,_,LParam,begindrag(ItemId),"BeginDrag"):-
	Event = cast(lv_listview,LParam),
	Event = listview(_,_,_,ItemIndex,_,_,_,_,_,_),
	lv_get_item_id(LVWin,ItemIndex,ItemId),
	lv_info(LVWin,WLVWin,_,_,_,_,UDDCursor,_),
	win_CaptureMouse(WLVWin),
	cursor_Set(LVWin,UDDCursor),
	assert(lv_drag(ItemId)),!.
  lv_check_code(lvn_beginrdrag,LVWin,_,LParam,beginrdrag(ItemId),"BeginDrag"):-
	Event = cast(lv_listview,LParam),
	Event = listview(_,_,_,ItemIndex,_,_,_,_,_,_),
	lv_get_item_id(LVWin,ItemIndex,ItemId),
	lv_info(LVWin,WLVWin,_,_,_,_,UDDCursor,_),
	win_CaptureMouse(WLVWin),
	cursor_Set(LVWin,UDDCursor),
	assert(lv_drag(ItemId)),!.
  lv_check_code(lvn_keydown,_,_,LParam,keydown(Key),"KeyDown"):-
	Event = cast(lv_keydown,LParam),
	Event = keydown(_,_,_,KeyS,_),
	Key = val(integer,KeyS),!.

/**GLOBAL PREDICATE*******************************************************
			     LV_GET_POS
 *************************************************************************/
  lv_get_pos(LVWin,X,Y,ItemId,Place):-
	lv_info(LVWin,WLVWin,_,_,_,_,_,_),
	Point = hittestinfo(X,Y,0,0),
	PointP = cast(long,Point),
	win_SendEvent(WLVWin,e_native(lvm_hittest,0,PointP)),
	Point1 = cast(lv_hittestinfo,PointP),
	Point1 = hittestinfo(_,_,Place,ItemIndex),
	lv_get_item_id(LVWin,ItemIndex,ItemId),!.
  lv_get_pos(_,_,_,0,0):-
	errorexit(error_vpi_package_bad_window),!.

/**GLOBAL PREDICATE*******************************************************
			     LV_ITEMID_ROW
 *************************************************************************/
  lv_itemid_row(LVWin,ItemId,Row):-
	lv_item_index(LVWin,ItemId,Row,_,_),!.
  lv_itemid_row(LVWin,_,_):-
	not(lv_info(LVWin,_,_,_,_,_,_,_)),
	errorexit(error_vpi_package_bad_window),
	!,fail.

/**GLOBAL PREDICATE*******************************************************
			     LV_ROW_ITEMID
 *************************************************************************/
  lv_row_itemid(LVWin,Row,ItemId):-
	lv_item_index(LVWin,ItemId,Row,_,_),!.
  lv_row_itemid(LVWin,_,_):-
	not(lv_info(LVWin,_,_,_,_,_,_,_)),
	errorexit(error_vpi_package_bad_window),
	!,fail.

/**GLOBAL PREDICATE*******************************************************
			     LV_GET_TYPE
 *************************************************************************/
  lv_get_type(LVWIN,Type):-
	lv_info(LVWin,WLVWin,_,_,_,_,_,_),
	Type1 = _wcc_GetWindowStyle(WLVWin),
	Type2 = val(unsigned,Type1),
	bitand(Type2,lvs_typemask,Type3),
	Type = Type3,!.
  lv_get_type(_,0):-
	errorexit(error_vpi_package_bad_window),!.

/**GLOBAL PREDICATE*******************************************************
			     LV_SET_TYPE
 *************************************************************************/
  lv_set_type(LVWIN,Type):-
	lv_info(LVWin,WLVWin,_,_,_,_,_,_),
	Type1 = _wcc_GetWindowStyle(WLVWin),
	bitand(Type,lvs_typemask,Type2),
	bitand(Type1,lvs_revtypemask,Type3),
	Type4 = Type2 + Type3,
	Type5 = val(long,Type4),
	_wcc_SetWindowStyle(WLVWin,Type5),
	lv_reload_item_images(LVWin,WLVWin),!.
  lv_set_type(_,_):-
	errorexit(error_vpi_package_bad_window),!.

/**GLOBAL PREDICATE*******************************************************
			     LV_GET_STYLE
 *************************************************************************/
  lv_get_style(LVWIN,StyleList):-
	lv_info(LVWin,WLVWin,_,_,_,_,_,_),
	Style1 = _wcc_GetWindowStyle(WLVWin),
	Style2 = val(unsigned,Style1),
	bitand(Style2,lvs_stylemask,Style3),
	wcc_get_state_list(Style3,[lvs_singlesel,lvs_showselalways,lvs_sortascending,lvs_sortdescending,lvs_nolabelwrap,
		lvs_autoarrange,lvs_editlabels,lvs_noscroll,lvs_alignleft],[],StyleList1),
	lv_adjust_style(StyleList1,StyleList2),
	StyleList = StyleList2,!.
  lv_get_style(_,[]):-
	errorexit(error_vpi_package_bad_window),!.

/**GLOBAL PREDICATE*******************************************************
			     LV_SET_STYLE
 *************************************************************************/
  lv_set_style(LVWIN,StyleList):-
	lv_get_style(LVWIN,StyleList0),
	lv_adjust_style1(StyleList0,StyleList,StyleList1),
	wcc_summ_list(StyleList1,0,Style),
	lv_info(LVWin,WLVWin,_,_,_,_,_,_),
	Style1 = _wcc_GetWindowStyle(WLVWin),
	bitand(Style,lvs_stylemask,Style2),
	bitand(Style1,lvs_revstylemask,Style3),
	Style4 = Style2 + Style3,
	Style5 = val(long,Style4),
	_wcc_SetWindowStyle(WLVWin,Style5),
	RCT = win_GetOuterRect(LVWin),
	RCT = rct(L,T,R,B),
	R1 = R + 1,
	win_Move(LVWin,rct(L,T,R1,B)),
	win_Move(LVWin,RCT),!.
  lv_set_style(_,_):-
	errorexit(error_vpi_package_bad_window),!.

/**GLOBAL PREDICATE*******************************************************
			     LV_GET_SEC
 *************************************************************************/
  lv_get_sel(LVWin,ItemIdList):-
	findall(ItemId,lv_item_index(LVWin,ItemId,_,_,_),ItemIdListFull),
	lv_get_SelectedItems(LVWin,ItemIdListFull,[],ItemIdList),!.
  lv_get_sel(_,[]):-
	errorexit(error_vpi_package_bad_window),!.

/**GLOBAL PREDICATE*******************************************************
			     LV_GET_FOCUS
 *************************************************************************/
  lv_get_focus(LVWin,ItemId):-
	findall(Items,lv_item_index(LVWin,Items,_,_,_),ItemIdListFull),
	lv_get_FocusedItem(LVWin,ItemIdListFull,ItemId),!.
  lv_get_focus(_,0):-
	errorexit(error_vpi_package_bad_window),!.

/**GLOBAL PREDICATE*******************************************************
			     LV_GET_ITEM
 *************************************************************************/
  lv_get_item(LVWin,ItemId,Item):-
	lv_info(LVWin,WLVWin,_,_,_,_,_,NumColumn),
	lv_item_index(LVWin,ItemId,ItemIndex,_,_),
	Mask = lvif_text + lvif_image + lvif_state,
	str_len(String,1000),
	Point = item(Mask,ItemIndex,0,0,0xffff,String,1000,0,0,0),
	PointP = cast(long,Point),
	win_SendEvent(WLVWin,e_native(lvm_getitem,0,PointP)),
	Point1 = cast(lv_items,PointP),
	Point1 = item(_,_,_,State,_,Text,_,_,_,_),
	wcc_get_state_list(State,[lvis_focused,lvis_selected,lvis_cut,lvis_drophilited],[],StateList),
	lv_item_index(LVWin,ItemId,_,LargeBitmapId,SmallBitmapId),
	lv_get_SubitemText(WLVWin,ItemIndex,NumColumn,[],SubItemText),
	Item = item(ItemId,Text,LargeBitmapId,SmallBitmapId,StateList,SubItemText),!.
  lv_get_item(LVWin,_,Item):-
	lv_info(LVWin,_,_,_,_,_,_,_),
	Item = item(0,"",0,0,[],[]),
	errorexit(error_vpi_package_bad_identifier),!.
  lv_get_item(_,_,Item):-
	Item = item(0,"",0,0,[],[]),
	errorexit(error_vpi_package_bad_window),!.

/**GLOBAL PREDICATE*******************************************************
			     LV_SELECT
 *************************************************************************/
  lv_select(_,[],_):-!.
  lv_select(LVWin,[ItemId|Rest],b_true):-
	lv_get_item(LVWin,ItemId,Item),
	Item = item(ItemId,Text,LargeBitmap,SmallBitmap,StateList,SubItem),
	wcc_del_from_list(StateList,lvis_selected,[],StateList1),
	StateList2 = [lvis_selected|StateList1],
	lv_set_item(LVWin,item(ItemId,Text,LargeBitmap,SmallBitmap,StateList2,SubItem)),!,
	lv_select(LVWin,Rest,b_true).
  lv_select(LVWin,[ItemId|Rest],b_false):-
	lv_get_item(LVWin,ItemId,Item),
	Item = item(ItemId,Text,LargeBitmap,SmallBitmap,StateList,SubItem),
	wcc_del_from_list(StateList,lvis_selected,[],StateList1),
	lv_set_item(LVWin,item(ItemId,Text,LargeBitmap,SmallBitmap,StateList1,SubItem)),!,
	lv_select(LVWin,Rest,b_false).
  lv_select(LVWin,[_|Rest],Select):-!,
	lv_select(LVWin,Rest,Select).
  lv_select(_,_,_):-
	errorexit(error_vpi_package_bad_window),!.

/**GLOBAL PREDICATE*******************************************************
			     LV_FOCUS
 *************************************************************************/
  lv_focus(LVWin,ItemId,b_true):-
	lv_get_item(LVWin,ItemId,Item),
	Item = item(ItemId,Text,LargeBitmap,SmallBitmap,StateList,SubItem),
	wcc_del_from_list(StateList,lvis_focused,[],StateList1),
	StateList2 = [lvis_focused|StateList1],
	lv_set_item(LVWin,item(ItemId,Text,LargeBitmap,SmallBitmap,StateList2,SubItem)),!.
  lv_focus(LVWin,ItemId,b_false):-
	lv_get_item(LVWin,ItemId,Item),
	Item = item(ItemId,Text,LargeBitmap,SmallBitmap,StateList,SubItem),
	wcc_del_from_list(StateList,lvis_focused,[],StateList1),
	lv_set_item(LVWin,item(ItemId,Text,LargeBitmap,SmallBitmap,StateList1,SubItem)),!.
  lv_focus(_,_,_):-
	errorexit(error_vpi_package_bad_window),!.

/**GLOBAL PREDICATE*******************************************************
			     LV_SET_ITEM
 *************************************************************************/
  lv_set_item(LVWin,item(ItemId,Text,LargeBitmapId,SmallBitmapId,StateList,SubItemText)):-
	lv_info(LVWin,WLVWin,_,_,_,_,_,_),
	lv_item_index(LVWin,ItemId,ItemIndex,_,_),
	lv_add_bitmap(LVWin,LargeBitmapId,SmallBitmapId),
	Mask = lvif_text + lvif_image + lvif_state,
	str_len(Text,TextLength),
	wcc_summ_list(StateList,0,State),
	lv_get_bitmap_index(LVWin,LargeBitmapId,SmallBitmapId,BitmapIndex),
	Point = item(Mask,ItemIndex,0,State,0xffff,Text,TextLength,BitmapIndex,0,0),
	PointP = cast(long,Point),
	win_SendEvent(WLVWin,e_native(lvm_setitem,0,PointP)),
	retract(lv_item_index(LVWin,ItemId,ItemIndex,_,_)),
	assert(lv_item_index(LVWin,ItemId,ItemIndex,LargeBitmapId,SmallBitmapId)),
	lv_add_subitems(WLVWin,ItemIndex,SubItemText,1),!.
  lv_set_item(_,_):-
	errorexit(error_vpi_package_bad_window),!.

/**GLOBAL PREDICATE*******************************************************
			     LV_SORT_ITEM / 5
 *************************************************************************/
PREDICATES
  determ lv_check_HeaderFooter(UNSIGNED HeaderRows,UNSIGNED FooterRows,UNSIGNED ItemCount,UNSIGNED ItemIndex1,UNSIGNED ItemIndex2,INTEGER Answer)
CLAUSES
  lv_check_HeaderFooter(HeaderRows,_,_,ItemIndex1,ItemIndex2,-1):-
	ItemIndex1 <= HeaderRows, ItemIndex2 <= HeaderRows,
	ItemIndex1 < ItemIndex2,!.
  lv_check_HeaderFooter(HeaderRows,_,_,ItemIndex1,ItemIndex2,1):-
	ItemIndex1 <= HeaderRows, ItemIndex2 <= HeaderRows,!.
  lv_check_HeaderFooter(_,FooterRows,ItemCount,ItemIndex1,ItemIndex2,-1):-
	EndRows = ItemCount - FooterRows + 1,
	ItemIndex1 >= EndRows, ItemIndex2 >= EndRows,
	ItemIndex1 < ItemIndex2,!.
  lv_check_HeaderFooter(_,FooterRows,ItemCount,ItemIndex1,ItemIndex2,1):-
	EndRows = ItemCount - FooterRows + 1,
	ItemIndex1 >= EndRows, ItemIndex2 >= EndRows,!.
  lv_check_HeaderFooter(HeaderRows,_,_,ItemIndex1,_,-1):-
	ItemIndex1 <= HeaderRows,!.
  lv_check_HeaderFooter(HeaderRows,_,_,_,ItemIndex2,1):-
	ItemIndex2 <= HeaderRows,!.
  lv_check_HeaderFooter(_,FooterRows,ItemCount,ItemIndex1,_,1):-
	EndRows = ItemCount - FooterRows + 1,
	ItemIndex1 >= EndRows,!.
  lv_check_HeaderFooter(_,FooterRows,ItemCount,_,ItemIndex2,-1):-
	EndRows = ItemCount - FooterRows + 1,
	ItemIndex2 >= EndRows,!.

PREDICATES
  procedure lv_get_text_FromColumn(WINDOW LVWin,UNSIGNED ColumnNumber,UNSIGNED ItemId,STRING Text)
CLAUSES
  lv_get_text_FromColumn(LVWin,1,ItemId,Text):-
	lv_get_item(LVWin,ItemId,Item),
	Item = item(_,Text,_,_,_,_),!.
  lv_get_text_FromColumn(LVWin,ColumnNumber,ItemId,Text):-
	lv_get_item(LVWin,ItemId,Item),
	Item = item(_,_,_,_,_,SubItemText),
	CN = ColumnNumber - 1,
	wcc_get_from_list(SubItemText,CN,Text),!.
  lv_get_text_FromColumn(_,_,_,""):-
	errorexit(),!.

PREDICATES
  procedure lv_compare_strings(LV_ORDER,STRING Text1,STRING Text2,INTEGER Answer)
CLAUSES
  lv_compare_strings(_,Text,Text,0):-!.
  lv_compare_strings(ascending,Text1,Text2,-1):-
	Text1 < Text2,!.
  lv_compare_strings(ascending,_,_,1):-!.
  lv_compare_strings(descending,Text1,Text2,1):-
	Text1 < Text2,!.
  lv_compare_strings(descending,_,_,-1):-!.
  lv_compare_strings(_,_,_,0):-!.

PREDICATES
  lv_my_sort_callback : LV_SORTFUNCTION
CLAUSES
  lv_my_sort_callback(_,ItemId2,ItemId1,Answer):-
	lv_sorting1(LVWin,_,_,HeaderRows,FooterRows),
	lv_item_index(LVWin,ItemId1,ItemIndex01,_,_),
	lv_item_index(LVWin,ItemId2,ItemIndex02,_,_),
	ItemIndex1 = ItemIndex01 + 1,
	ItemIndex2 = ItemIndex02 + 1,
	lv_info(LVWin,WLVWin,_,_,_,_,_,_),
	ItemCount = win_SendEvent(WLVWin,e_native(lvm_getitemcount,0,0)),
	lv_check_HeaderFooter(HeaderRows,FooterRows,ItemCount,ItemIndex1,ItemIndex2,Answer),!.
  lv_my_sort_callback(_,ItemId2,ItemId1,Answer):-
	lv_sorting1(LVWin,Order,ColumnNumber,_,_),
	lv_get_text_FromColumn(LVWin,ColumnNumber,ItemId1,Text01),
	lv_get_text_FromColumn(LVWin,ColumnNumber,ItemId2,Text02),
	upper_lower(Text01,Text1),
	upper_lower(Text02,Text2),
	lv_compare_strings(Order,Text1,Text2,Answer),!.
  lv_my_sort_callback(_,_,_,0).

PREDICATES
  lv_my_unsort_callback : LV_SORTFUNCTION
CLAUSES
  lv_my_unsort_callback(_,ItemId2,ItemId1,1):-
	lv_sorting1(LVWin,unsorting,_,_,_),
	lv_item_order(LVWin,ItemIdList),
	wcc_member_index(ItemId1,ItemIdList,Pos1),
	wcc_member_index(ItemId2,ItemIdList,Pos2),
	Pos1 < Pos2,!.
  lv_my_unsort_callback(_,_,_,-1).

  lv_sort_items(LVWin,unsorting,_,_,_):-
	retractall(lv_sorting1(_,_,_,_,_)),
	assert(lv_sorting1(LVWin,unsorting,0,0,0)),
	lv_info(LVWin,WLVWin,_,_,_,_,_,_),
	PointP = cast(long,lv_my_unsort_callback),
	win_SendEvent(WLVWin,e_native(lvm_sortitems,0,PointP)),
	lv_adjust_item_index(LVWin),
	lv_reload_item_images(LVWin,WLVWin),!.
  lv_sort_items(LVWin,Order,ColumnNumber,HeaderRows,FooterRows):-
	retractall(lv_sorting1(_,_,_,_,_)),
	assert(lv_sorting1(LVWin,Order,ColumnNumber,HeaderRows,FooterRows)),
	lv_info(LVWin,WLVWin,_,_,_,_,_,_),
	PointP = cast(long,lv_my_sort_callback),
	win_SendEvent(WLVWin,e_native(lvm_sortitems,0,PointP)),
	lv_adjust_item_index(LVWin),
	lv_reload_item_images(LVWin,WLVWin),!.
  lv_sort_items(_,_,_,_,_):-
	errorexit(error_vpi_package_bad_window),!.

/**GLOBAL PREDICATE*******************************************************
			     LV_SORT_ITEM / 3
 *************************************************************************/
PREDICATES
  lv_sort_callback : LV_SORTFUNCTION
CLAUSES
  lv_sort_callback(DataToSortCallBack,ItemId2,ItemId1,1):-
	lv_sorting(LVWin,SortCallBack),
	SortCallBack(LVWin,ItemId1,ItemId2,DataToSortCallBack,Answer),
	Answer = b_false,!.
  lv_sort_callback(_,_,_,-1).

  lv_sort_items(LVWin,DataToSortCallBack,SortCallBack):-
	retractall(lv_sorting(_,_)),
	assert(lv_sorting(LVWin,SortCallBack)),
	lv_info(LVWin,WLVWin,_,_,_,_,_,_),
	PointP = cast(long,lv_sort_callback),
	win_SendEvent(WLVWin,e_native(lvm_sortitems,DataToSortCallBack,PointP)),
	lv_adjust_item_index(LVWin),
	lv_reload_item_images(LVWin,WLVWin),!.
  lv_sort_items(_,_,_):-
	errorexit(error_vpi_package_bad_window),!.

/**GLOBAL PREDICATE*******************************************************
			     LV_DELETE_ITEM
 *************************************************************************/
  lv_delete_item(LVWin,ItemId):-
	lv_item_index(LVWin,ItemId,ItemIndex,_,_),
	lv_info(LVWin,WLVWin,_,_,_,_,_,_),
	win_SendEvent(WLVWin,e_native(lvm_deleteitem,ItemIndex,0)),
	retract(lv_item_index(LVWin,ItemId,ItemIndex,_,_)),
	lv_adjust_item_index(LVWin),
	lv_reload_item_images(LVWin,WLVWin),
	retract(lv_item_order(LVWin,ItemIdList)),
	wcc_del_from_list(ItemIdList,ItemId,[],ItemIdList1),
	assert(lv_item_order(LVWin,ItemIdList1)),!.
  lv_delete_item(LVWin,_):-
	lv_info(LVWin,_,_,_,_,_,_,_),
	errorexit(error_vpi_package_bad_identifier),!.
  lv_delete_item(_,_):-
	errorexit(error_vpi_package_bad_window),!.

/**GLOBAL PREDICATE*******************************************************
			     LV_INSERT_ITEM
 *************************************************************************/
  lv_insert_item(LVWin,item(ItemId,Text,LargeBitmapId,SmallBitmapId,Flags,SubItemText)):-
	lv_info(LVWin,WLVWin,_,_,_,_,_,_),
	ItemCount = win_SendEvent(WLVWin,e_native(lvm_getitemcount,0,0)),
	lv_add_bitmap(LVWin,LargeBitmapId,SmallBitmapId),
	lv_add_items(LVWin,WLVWin,[item(ItemId,Text,LargeBitmapId,SmallBitmapId,Flags,SubItemText)],ItemCount),
	retract(lv_item_order(LVWin,ItemIdList)),
	ItemIdList1 = [ItemId|ItemIdList],
	assert(lv_item_order(LVWin,ItemIdList1)),!.
  lv_insert_item(_,_):-
	errorexit(error_vpi_package_bad_window),!.

/**GLOBAL PREDICATE*******************************************************
			     LV_INSERT_COLUMN
 *************************************************************************/
  lv_insert_column(_,ColumnPos,_):-
	ColumnPos < 2,
	dlg_error("Column number must be greater than 1"),!.
  lv_insert_column(LVWin,ColumnPos,_):-
	lv_info(LVWin,_,_,_,_,_,_,NumColumn),
	ColumnPos > NumColumn + 1,
	dlg_error("Column number must be less than or equal to the number of existing columns"),!.
  lv_insert_column(LVWin,ColumnPos,Column):-
	ColumnPos1 = ColumnPos - 1,
	lv_info(LVWin,WLVWin,_,_,_,_,_,NumColumn),
	lv_add_columns(WLVWin,[Column],ColumnPos1),
	NumColumn1 = NumColumn + 1,
	retract(lv_info(LVWin,WLVWin,HimageLarge,HimageSmall,CallBack,DDCursor,UnDDCursor,NumColumn)),
	assert(lv_info(LVWin,WLVWin,HimageLarge,HimageSmall,CallBack,DDCursor,UnDDCursor,NumColumn1)),
	win_Invalidate(WLVWin),!.
  lv_insert_column(_,_,_):-
	errorexit(error_vpi_package_bad_window),!.

/**GLOBAL PREDICATE*******************************************************
			     LV_DELETE_COLUMN
 *************************************************************************/
  lv_delete_column(_,ColumnNum):-
	ColumnNum < 2,
	dlg_error("Column number must be greater than 1"),!.
  lv_delete_column(LVWin,ColumnNum):-
	lv_info(LVWin,_,_,_,_,_,_,NumColumn),
	NumColumn1 = NumColumn + 1,
	ColumnNum > NumColumn1,
	dlg_error("Column number must be less than or equal to the number of existing columns"),!.
  lv_delete_column(LVWin,ColumnNum):-
	ColumnNum1 = ColumnNum - 1,
	lv_info(LVWin,WLVWin,_,_,_,_,_,NumColumn),
	win_SendEvent(WLVWin,e_native(lvm_deletecolumn,ColumnNum1,0)),
	NumColumn1 = NumColumn - 1,
	retract(lv_info(LVWin,WLVWin,HimageLarge,HimageSmall,CallBack,DDCursor,UnDDCursor,NumColumn)),
	assert(lv_info(LVWin,WLVWin,HimageLarge,HimageSmall,CallBack,DDCursor,UnDDCursor,NumColumn1)),
	win_Invalidate(WLVWin),!.
  lv_delete_column(_,_):-
	errorexit(error_vpi_package_bad_window),!.

/**GLOBAL PREDICATE*******************************************************
			     LV_GET_COLUMN
 *************************************************************************/
  lv_get_column(_,ColumnPos,Column):-
	ColumnPos < 1,
	Column = column("",0,left),
	errorexit(error_vpi_package_bad_data),!.
  lv_get_column(LVWin,ColumnPos,Column):-
	lv_info(LVWin,_,_,_,_,_,_,NumColumn),
	ColumnPos > NumColumn,
	Column = column("",0,left),
	errorexit(error_vpi_package_bad_data),!.
  lv_get_column(LVWin,ColumnPos,Column):-
	ColumnPos1 = ColumnPos - 1,
	lv_info(LVWin,WLVWin,_,_,_,_,_,_),
	Mask = lvcf_fmt + lvcf_text + lvcf_width,
	str_len(Text,1000),
	Point = column(Mask,0,0,Text,1000,0,0,0),
	PointP = cast(long,Point),
	win_SendEvent(WLVWin,e_native(lvm_getcolumn,ColumnPos1,PointP)),
	Point1 = cast(lv_columns,PointP),
	Point1 = column(_,Alignment,Width,Text,_,_,0,0),
	lv_convert_alignment1(AlignmentD,Alignment),
	Column = column(Text,Width,AlignmentD),!.
  lv_get_column(_,_,Column):-
	Column = column("",0,left),
	errorexit(error_vpi_package_bad_window),!.

/**GLOBAL PREDICATE*******************************************************
			     LV_SET_COLUMN
 *************************************************************************/
  lv_set_column(_,ColumnPos,Column):-
	ColumnPos < 1,
	Column = column("",0,left),
	errorexit(error_vpi_package_bad_data),!.
  lv_set_column(LVWin,ColumnPos,Column):-
	lv_info(LVWin,_,_,_,_,_,_,NumColumn),
	Column = column("",0,left),
	ColumnPos > NumColumn,
	errorexit(error_vpi_package_bad_data),!.
  lv_set_column(LVWin,ColumnPos,column(Text,Width,AlignmentD)):-
	ColumnPos1 = ColumnPos - 1,
	lv_convert_alignment(ColumnPos1,AlignmentD,Alignment),
	lv_info(LVWin,WLVWin,_,_,_,_,_,_),
	Mask = lvcf_fmt + lvcf_text + lvcf_width,
	str_len(Text,TextLength),
	Point = column(Mask,Alignment,Width,Text,TextLength,0,0,0),
	PointP = cast(long,Point),
	win_SendEvent(WLVWin,e_native(lvm_setcolumn,ColumnPos1,PointP)),!.
  lv_set_column(_,_,_):-
	errorexit(error_vpi_package_bad_window),!.

/**GLOBAL PREDICATE*******************************************************
			     LV_GET_COLOR
 *************************************************************************/
  lv_get_color(LVWin,TextColor,TextBgColor):-
	lv_info(LVWin,WLVWin,_,_,_,_,_,_),
	win_Invalidate(WLVWin),
	TextColor = win_SendEvent(WLVWin,e_native(lvm_gettextcolor,0,0)),
	TextBgColor = win_SendEvent(WLVWin,e_native(lvm_gettextbkcolor,0,0)),!.
  lv_get_color(_,0,0):-
	errorexit(error_vpi_package_bad_window),!.

/**GLOBAL PREDICATE*******************************************************
			     LV_SET_COLOR
 *************************************************************************/
  lv_set_color(LVWin,TextColor,TextBgColor):-
	lv_info(LVWin,WLVWin,_,_,_,_,_,_),
	win_SendEvent(WLVWin,e_native(lvm_settextcolor,0,TextColor)),
	win_SendEvent(WLVWin,e_native(lvm_settextbkcolor,0,TextBgColor)),
	win_Invalidate(WLVWin),!.
  lv_set_color(_,_,_):-
	errorexit(error_vpi_package_bad_window),!.

/**GLOBAL PREDICATE*******************************************************
			     LV_ARRANGE
 *************************************************************************/
  lv_arrange(LVWin,LVArrange):-
	lv_convert_arrange(LVArrange,WLVArrange),
	lv_info(LVWin,WLVWin,_,_,_,_,_,_),
	win_SendEvent(WLVWin,e_native(lvm_arrange,WLVArrange,0)),
	win_Invalidate(WLVWin),!.
  lv_arrange(_,_):-
	errorexit(error_vpi_package_bad_window),!.

/**GLOBAL PREDICATE*******************************************************
			     LV_DELETE_ALLITEMS
 *************************************************************************/
  lv_delete_allitems(LVWin):-
	lv_info(LVWin,WLVWin,_,_,_,_,_,_),
	win_SendEvent(WLVWin,e_native(lvm_deleteallitems,0,0)),!.
  lv_delete_allitems(_):-
	errorexit(error_vpi_package_bad_window),!.

/**GLOBAL PREDICATE*******************************************************
			     LV_ENSUREVISIBLE
 *************************************************************************/
  lv_ensurevisible(LVWin,ItemId):-
	lv_info(LVWin,WLVWin,_,_,_,_,_,_),
	lv_item_index(LVWin,ItemId,ItemIndex,_,_),
	win_SendEvent(WLVWin,e_native(lvm_ensurevisible,ItemIndex,0)),!.
  lv_ensurevisible(_,_):-
	errorexit(error_vpi_package_bad_window),!.

/**GLOBAL PREDICATE*******************************************************
			     LV_GETCOUNTPERPAGE
 *************************************************************************/
  lv_getcountperpage(LVWin,NumItems):-
	lv_info(LVWin,WLVWin,_,_,_,_,_,_),
	NumItems = win_SendEvent(WLVWin,e_native(lvm_getcountperpage,0,0)),!.
  lv_getcountperpage(_,0):-
	errorexit(error_vpi_package_bad_window),!.

/**GLOBAL PREDICATE*******************************************************
			     LV_GETITEMCOUNT
 *************************************************************************/
  lv_getitemcount(LVWin,NumItems):-
	lv_info(LVWin,WLVWin,_,_,_,_,_,_),
	NumItems = win_SendEvent(WLVWin,e_native(lvm_getitemcount,0,0)),!.
  lv_getitemcount(_,0):-
	errorexit(error_vpi_package_bad_window),!.

/**GLOBAL PREDICATE*******************************************************
			     LV_GETITEMPOSITION
 *************************************************************************/
  lv_getitemposition(LVWin,ItemId,Position):-
	lv_info(LVWin,WLVWin,_,_,_,_,_,_),
	lv_item_index(LVWin,ItemId,ItemIndex,_,_),
	Point0 = point(0,0),
	PointP = cast(long,Point0),
	win_SendEvent(WLVWin,e_native(lvm_getitemposition,ItemIndex,PointP)),
	Point = cast(lv_point,PointP),
	Point = point(X,Y),
	Position = pnt(X,Y),!.
  lv_getitemposition(_,_,Position):-
	Position = pnt(0,0),
	errorexit(error_vpi_package_bad_window),!.

/**GLOBAL PREDICATE*******************************************************
			     LV_SETITEMPOSITION
 *************************************************************************/
  lv_setitemposition(LVWin,ItemId,pnt(X,Y)):-
	lv_info(LVWin,WLVWin,_,_,_,_,_,_),
	lv_item_index(LVWin,ItemId,ItemIndex,_,_),
	Point = point(X,Y),
	PointP = cast(long,Point),
	win_SendEvent(WLVWin,e_native(lvm_setitemposition32,ItemIndex,PointP)),!.
  lv_setitemposition(_,_,_):-
	errorexit(error_vpi_package_bad_window),!.

/**GLOBAL PREDICATE*******************************************************
			     LV_GETNEXTITEM
 *************************************************************************/
  lv_getnextitem(LVWin,ItemId,LVPosition,OutItemId):-
	lv_convert_relpos(LVPosition,WLVPosition),
	lv_info(LVWin,WLVWin,_,_,_,_,_,_),
	lv_item_index(LVWin,ItemId,ItemIndex,_,_),
	OutItemIndex = win_SendEvent(WLVWin,e_native(lvm_getnextitem,ItemIndex,WLVPosition)),
	lv_get_item_id(LVWin,OutItemIndex,OutItemId),!.
  lv_getnextitem(_,_,_,0):-
	errorexit(error_vpi_package_bad_window),!.

/**GLOBAL PREDICATE*******************************************************
			     LV_GET_ADVANCEDDATA
 *************************************************************************/
  lv_get_AdvancedData(LVWin,Data):-
	lv_advanced(LVWin,Advanced),
	Data = Advanced,!.
  lv_get_AdvancedData(_,""):-
	errorexit(error_vpi_package_bad_window),!.

/**GLOBAL PREDICATE*******************************************************
			     LV_GET_ADVANCEDDATA
 *************************************************************************/
  lv_set_AdvancedData(LVWin,Data):-
	retract(lv_advanced(LVWin,_)),
	assert(lv_advanced(LVWin,Data)),!.
  lv_set_AdvancedData(_,_):-
	errorexit(error_vpi_package_bad_window),!.

/**GLOBAL PREDICATE*******************************************************
			     LV_INIT
 *************************************************************************/
PREDICATES
  lv_subclass_eh : EHANDLER
  lv_dd_cb : DD_CALLBACK
CLAUSES

  lv_Init(LVWin,_,_,_,_,_,_,_):-
	lv_info(LVWin,WLVWin,_,_,_,_,_,_),
	win_Destroy(WLVWin),
	lv_HandleEvent(LVWin,e_Destroy),
	fail.
  lv_Init(LVWin,Type,Flags,ColumnList,ItemList,DDCursor,UnDDCursor,CallBack):-
	retractall(lv_bitmap_index(LVWin,_,_,_)),
	retractall(lv_item_index(LVWin,_,_,_,_)),
	retractall(lv_info(LVWin,_,_,_,_,_,_,_)),
	lv_get_bitmap_par(ItemList,0,0,[],X1,Y1,BitmapsId1,0,0,[],X2,Y2,BitmapsId2),
	wcc_del_equal(BitmapsId1,[],BitmapsId11),
	wcc_del_equal(BitmapsId2,[],BitmapsId21),
	wcc_length_list(BitmapsId1,C1),
	wcc_length_list(BitmapsId2,C2),
	wcc_length_list(ColumnList,NumColumn),
	wcc_summ_list(Flags,0,SummFlags1),
	SummFlags = SummFlags1 + Type,
	Hinst = vpi_GetAttrVal(attr_win_instance),
	WLVWin = _wcc_create(Hinst,LVWin,"SysListView32","List View",SummFlags),
	Himage1 = _wcc_bitmap_create(X1,Y1,C1),
	Himage2 = _wcc_bitmap_create(X2,Y2,C2),
	assert(lv_info(LVWin,WLVWin,Himage1,Himage2,CallBack,DDCursor,UnDDCursor,NumColumn)),
	lv_add_bitmaps(1,LVWin,Hinst,Himage1,BitmapsId11),
	lv_add_bitmaps(2,LVWin,Hinst,Himage2,BitmapsId21),
	win_SendEvent(WLVWin,e_native(lvm_setimagelist,lvsil_normal,Himage1)),
	win_SendEvent(WLVWin,e_native(lvm_setimagelist,lvsil_small,Himage2)),
	lv_add_columns(WLVWin,ColumnList,0),
	lv_add_items(LVWin,WLVWin,ItemList,0),
	lv_adjust_item_index(LVWin),
	lv_reload_item_images(LVWin,WLVWin),
	lv_save_items_order(LVWin),
	assert(lv_advanced(LVWin,"")),
	win_SetSubClassHandler(WLVWin,lv_subclass_eh,b_false),
	win_EnableHook(LVWin,b_true),
	dd_client(WLVWin,lv_dd_cb),
	ParentWin = win_GetParent(LVWin),
	trap(Font = win_GetFont(ParentWin),_,fail),
	trap(win_SetFont(LVWin,Font),_,true),!.
  lv_Init(_,_,_,_,_,_,_,_).

/*************************************************************************
			     EVENT HANDLER
 *************************************************************************/
  lv_HandleEvent(LVWin,e_native(wm_notify,WParam,LParam),-1):-
	Event = cast(lv_nmhdr,LParam),
	Event = nmhdr(_,_,CodeOperation),
	lv_check_code(CodeOperation,LVWin,WParam,LParam,LV_Message,_Message),
%	write("_Message=",_Message,"\n"),
	lv_info(LVWin,_,_,_,CallBack,_,_,_),
	CallBack(LVWin,LV_Message),!,
	win_ReleaseMouse(),
	cursor_Set(LVWin,cursor_Arrow),
	retractall(lv_drag(_)),
	lv_check_edit(),!.
  lv_HandleEvent(LVWin,e_native(wm_notify,_,_),0):-
	retract(lv_edit(ItemId,Text)),
	lv_get_item(LVWin,ItemId,Item),
	Item = item(ItemId,_,LargeBitmapId,SmallBitmapId,Flags,SubItemText),
	lv_set_item(LVWin,item(ItemId,Text,LargeBitmapId,SmallBitmapId,Flags,SubItemText)),
	!,fail.
  lv_HandleEvent(LVWin,e_Size(Width,Height),0):-
	lv_info(LVWin,WLVWin,_,_,_,_,_,_),
	win_Move(WLVWin,rct(0,0,Width,Height)),!.
  lv_HandleEvent(LVWin,e_State(font(Font)),0):-
	lv_info(LVWin,WLVWin,_,_,_,_,_,_),
	win_SetFont(WLVWin,Font),!.
  lv_HandleEvent(LVWin,e_State(disabled()),0):-
	lv_info(LVWin,WLVWin,_,_,_,_,_,_),
	win_SetState(WLVWin,[wsf_Disabled]),!.
  lv_HandleEvent(LVWin,e_State(enabled()),0):-
	lv_info(LVWin,WLVWin,_,_,_,_,_,_),
	win_SetState(WLVWin,[wsf_Enabled]),!.
  lv_HandleEvent(LVWin,e_State(invisible()),0):-
	lv_info(LVWin,WLVWin,_,_,_,_,_,_),
	win_SetState(WLVWin,[wsf_Invisible]),!.
  lv_HandleEvent(LVWin,e_State(visible()),0):-
	lv_info(LVWin,WLVWin,_,_,_,_,_,_),
	win_SetState(WLVWin,[wsf_Visible]),!.
  lv_HandleEvent(LVWin,e_Destroy,0):-
	lv_info(LVWin,_,Himage1,Himage2,_,_,_,_),
	_wcc_bitmap_destroy(Himage1),
	_wcc_bitmap_destroy(Himage2),
	retractall(lv_bitmap_index(LVWin,_,_,_)),
	retractall(lv_item_index(LVWin,_,_,_,_)),
	retractall(lv_info(LVWin,_,_,_,_,_,_,_)),
	retractall(lv_sorting(LVWin,_)),
	retractall(lv_sorting1(LVWin,_,_,_,_)),
	retractall(lv_item_order(LVWin,_)),
	retractall(lv_advanced(LVWin,_)),!,
	fail.

PREDICATES
  procedure lv_undrophilited(WINDOW LVWin)
CLAUSES
  lv_undrophilited(LVWin):-
	lv_item_index(LVWin,ItemId,_,_,_),
	lv_get_item(LVWin,ItemId,Item),
	Item = item(ItemId,Text,LargeBitmap,SmallBitmap,StateList,SubItem),
	wcc_member(lvis_drophilited,StateList),
	wcc_del_from_list(StateList,lvis_drophilited,[],StateList1),
	lv_set_item(LVWin,item(ItemId,Text,LargeBitmap,SmallBitmap,StateList1,SubItem)),
	fail.
  lv_undrophilited(_).

PREDICATES
  procedure lv_drophilited(WINDOW LVWin,UNSIGNED ItemId)
CLAUSES
  lv_drophilited(LVWin,ItemId):-
	trap(lv_get_item(LVWin,ItemId,Item),_,fail),
	Item = item(ItemId,Text,LargeBitmap,SmallBitmap,StateList,SubItem),
	StateList1 = [tvis_drophilited|StateList],
	lv_set_item(LVWin,item(ItemId,Text,LargeBitmap,SmallBitmap,StateList1,SubItem)),!.
  lv_drophilited(_,_).

PREDICATES
  determ lv_send_drag_callback(WINDOW LVWin,INTEGER MouseButton,WINDOW FromWin,STRING Data,PNT,UNSIGNED TItemId)
CLAUSES
  lv_send_drag_callback(LVWin,mouse_button_left,FromWin,Data,PNT,TItemId):-
	lv_info(LVWin,_,_,_,CallBack,_,_,_),
	not(CallBack(LVWin,drag(FromWin,Data,PNT,TItemId))),!.
  lv_send_drag_callback(LVWin,mouse_button_right,FromWin,Data,PNT,TItemId):-
	lv_info(LVWin,_,_,_,CallBack,_,_,_),
	not(CallBack(LVWin,rdrag(FromWin,Data,PNT,TItemId))),!.

PREDICATES
  determ lv_send_drop_callback(WINDOW LVWin,INTEGER MouseButton,WINDOW FromWin,STRING Data,PNT,UNSIGNED TItemId)
CLAUSES
  lv_send_drop_callback(LVWin,mouse_button_left,FromWin,Data,PNT,TItemId):-
	lv_info(LVWin,_,_,_,CallBack,_,_,_),
	not(CallBack(LVWin,drop(FromWin,Data,PNT,TItemId))),!.
  lv_send_drop_callback(LVWin,mouse_button_right,FromWin,Data,PNT,TItemId):-
	lv_info(LVWin,_,_,_,CallBack,_,_,_),
	not(CallBack(LVWin,rdrop(FromWin,Data,PNT,TItemId))),!.

PREDICATES
  procedure lv_set_cursor(WINDOW LVWin,CURSOR Cursor)
CLAUSES
  lv_set_cursor(LVWin,Cursor):-
	OldCursor = cursor_Get(LVWin),
	OldCursor = Cursor,!.
  lv_set_cursor(LVWin,Cursor):-
	cursor_Set(LVWin,Cursor),!.

/*** Drag and Drop client part ***/

  lv_subclass_eh(WLVWIN,e_MouseMove(Point,c_Nothing,[MouseButton]),0):-
	lv_drag(ItemId),
	lv_info(LVWin,WLVWin,_,_,_,DDCursor,_,_),
	lv_get_item(LVWin,ItemId,Item),
	Item = item(ItemId,Text,LargeBitmap,SmallBitmap,StateList,SubItem),
	lv_advanced(LVWin,Advanced),
	Data = lv_dragdrop(ItemId,Text,LargeBitmap,SmallBitmap,StateList,SubItem,Advanced),
	trap(term_str(lv_dragdrop,Data,String),_,fail),
	dd_drag(LVWIN,Point,MouseButton,String),
	lv_set_cursor(LVWin,DDCursor),
	!,fail.
  lv_subclass_eh(WLVWIN,e_MouseMove(_,_,_),0):-
	lv_drag(_),
	lv_info(LVWin,WLVWin,_,_,_,_,UnDDCursor,_),
	lv_set_cursor(LVWin,UnDDCursor),
	!,fail.

  lv_subclass_eh(WLVWIN,e_MouseUp(Point,c_Nothing,MouseButton),0):-
	retract(lv_drag(ItemId)),
	win_ReleaseMouse(),
	cursor_Set(WLVWIN,cursor_Arrow),
	lv_info(LVWin,WLVWin,_,_,_,_,_,_),
	lv_get_item(LVWin,ItemId,Item),
	Item = item(ItemId,Text,LargeBitmap,SmallBitmap,StateList,SubItem),
	lv_advanced(LVWin,Advanced),
	Data = lv_dragdrop(ItemId,Text,LargeBitmap,SmallBitmap,StateList,SubItem,Advanced),
	trap(term_str(lv_dragdrop,Data,String),_,fail),
	dd_drop(LVWIN,Point,MouseButton,String),
	!,fail.

/*** Drag and Drop server part ***/

  lv_dd_cb(dragend,WLVWin,_,_,_,_):-
	lv_info(LVWin,WLVWin,_,_,_,_,_,_),
	lv_undrophilited(LVWin),
	!,fail.
  lv_dd_cb(drag,WLVWin,FromWin,pnt(X,Y),MouseButton,String):-
	lv_info(LVWin,WLVWin,_,_,_,_,_,_),
	lv_get_pos(LVWin,X,Y,TItemId,_),
	lv_undrophilited(LVWin),
	lv_send_drag_callback(LVWin,MouseButton,FromWin,String,pnt(X,Y),TItemId),
	lv_drophilited(LVWin,TItemId),
	!,fail.
  lv_dd_cb(drop,WLVWin,FromWin,pnt(X,Y),MouseButton,String):-
	lv_info(LVWin,WLVWin,_,_,_,_,_,_),
	lv_get_pos(LVWin,X,Y,TItemId,_),
	lv_undrophilited(LVWin),
	lv_send_drop_callback(LVWin,MouseButton,FromWin,String,pnt(X,Y),TItemId),
	!,fail.
  lv_dd_cb(_,_,_,_,_,_).

enddef /*** use_winctrl_ListView ***/
