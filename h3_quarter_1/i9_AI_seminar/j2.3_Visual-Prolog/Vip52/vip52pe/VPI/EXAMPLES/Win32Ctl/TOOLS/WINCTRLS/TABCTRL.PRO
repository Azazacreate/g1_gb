/******************************************************************************

		 Copyright (c) 1984 - 2000 Prolog Development Center A/S

 FileName:	TABCTRL.PRO
 Purpose:	Tab custom control object
 Written by:	Sergey Alexeev
 Version:	1.0
 Build:		002.000316
 Tested with:   Visual Prolog v.5.0 build 533
 Comments:
******************************************************************************/
ifdef use_winctrl_TabCtrl

ifndef winctrls_pre_included
 #Error: this file requires include: winctrls.pre
enddef 

ifndef error_con_included
 #Error: this file requires include: error.con
enddef 

DOMAINS
TC_NMHDR = struct nmhdr(WCC_POINT WTCWin,UNSIGNED IdFrom,UNSIGNED CodeOperation)
TC_ITEMS = struct item(UNSIGNED Mask,UNSIGNED Reserved1,UNSIGNED Reserved2,STRING Text,INTEGER TextLength,
	INTEGER BitmapIndex,LONG LParam)

CONSTANTS
ifndef unicode_set
tcm_getitem		= 0x1305
tcm_setitem		= 0x1306
tcm_insertitem		= 0x1307
elsedef
tcm_getitem		= 0x133c
tcm_setitem		= 0x133d
tcm_insertitem		= 0x133e
enddef
tcm_getimagelist	= 0x1302
tcm_setimagelist	= 0x1303
tcm_getitemcount	= 0x1304
tcm_deleteitem		= 0x1308
tcm_deleteallitems	= 0x1309
tcm_getitemrect		= 0x130a
tcm_getcursel		= 0x130b
tcm_setcursel		= 0x130c
tcm_hittest		= 0x130d
tcm_setitemextra	= 0x130e
tcm_adjustrect		= 0x1328
tcm_setitemsize		= 0x1329
tcm_removeimage		= 0x132a
tcm_setpadding		= 0x132b
tcm_getrowcount		= 0x132c
tcm_gettooltips		= 0x132d
tcm_settooltips		= 0x132e
tcm_getcurfocus		= 0x132f
tcm_setcurfocus		= 0x1330
tcm_setmintabwidth	= 0x1331
tcm_deselectall		= 0x1332

tcif_text		= 0x0001
tcif_image		= 0x0002
tcif_rtlreading		= 0x0004
tcif_param		= 0x0008
tcif_state		= 0x0010

tcn_keydown		= 0xfffffdda
tcn_selchange		= 0xfffffdd9
tcn_selchanging		= 0xfffffdd8

DATABASE - tc_db
  tc_info(WINDOW TCWin,WINDOW WTCWin,WCC_POINT Himage,TC_CALLBACK)
  tc_item_index(WINDOW TCWin,INTEGER Num,ILIST ControlIdList)
  tc_bitmap_index(WINDOW TCWin,UNSIGNED BitmapId,INTEGER BitmapIndex)

PREDICATES
  procedure tc_get_title_status(WINDOW TCWin,TC_TITLE Title,UNSIGNED Mask,STRING Text,INTEGER TextLength,INTEGER BitmapIndex)
CLAUSES
  tc_get_title_status(TCWin,mix(Text,BitmapId),Mask,Text,TextLength,BitmapIndex):-
	Mask = tcif_text + tcif_image,
	str_len(Text,TextLength),
	tc_bitmap_index(TCWin,BitmapId,BitmapIndex),!.
  tc_get_title_status(TCWin,bitmap(BitmapId),Mask,"",0,BitmapIndex):-
	Mask = tcif_text + tcif_image,
	tc_bitmap_index(TCWin,BitmapId,BitmapIndex),!.
  tc_get_title_status(_,text(Text),Mask,Text,TextLength,0):-
	Mask = tcif_text,
	str_len(Text,TextLength),!.
  tc_get_title_status(_,_,0,"",0,0):-
	errorexit(),!.

PREDICATES
  procedure tc_add_pages(WINDOW TCWin,WINDOW WTCWin,TC_PAGELIST,INTEGER Page)
CLAUSES
  tc_add_pages(_,_,[],_):-!.
  tc_add_pages(TCWin,WTCWin,[page(Title,ItemIdList)|Rest],Page):-
	tc_get_title_status(TCWin,Title,Mask,Text,TextLength,BitmapIndex),
	Item = item(Mask,0,0,Text,TextLength,BitmapIndex,0),
	ItemP = cast(long,Item),
	win_SendEvent(WTCWin,e_native(tcm_insertitem,Page,ItemP)),
	assert(tc_item_index(TCWin,Page,ItemIdList)),
	Page1 = Page + 1,!,
	tc_add_pages(TCWin,WTCWin,Rest,Page1).
  tc_add_pages(_,_,_,_):-
	errorexit(),!.

PREDICATES
  procedure tc_set_items(WINDOW Win,ILIST ControlsId)
CLAUSES
  tc_set_items(_,[]):-!.
  tc_set_items(Win,[CtrlId|Rest]):-
	trap(CtrlWin = win_GetCtlHandle(Win,CtrlId),_,fail),
	win_BringToTop(CtrlWin),!,
	tc_set_items(Win,Rest).
  tc_set_items(Win,[_|Rest]):-!,
	tc_set_items(Win,Rest).
  tc_set_items(_,_):-
	errorexit(),!.

PREDICATES
  procedure tc_set_pages(WINDOW TCWin,INTEGER Page)
CLAUSES
  tc_set_pages(TCWin,Page):-
	win_BringToTop(TCWin),
	tc_item_index(TCWin,Page,ControlsId),
	ParentWin = win_GetParent(TCWin),
	tc_set_items(ParentWin,ControlsId),!.
  tc_set_pages(_,_).

PREDICATES
  procedure tc_get_mouse_pos(WINDOW TCWin,INTEGER X,INTEGER Y)
CLAUSES
  tc_get_mouse_pos(TCWin,X,Y):-
	tc_info(TCWin,WTCWin,_,_),
	Pnt = cursor_GetPos(WTCWin),
	Pnt = pnt(X,Y),!.
  tc_get_mouse_pos(_,0,0).

PREDICATES
  determ tc_get_bitmapid(TC_TITLE,RESID BitmapId)
CLAUSES
  tc_get_bitmapid(bitmap(BitmapId),BitmapId):-!.
  tc_get_bitmapid(mix(_,BitmapId),BitmapId):-!.

PREDICATES
  procedure tc_get_bitmap_par(TC_PAGELIST,INTEGER Xin,INTEGER Yin,ILIST BitmapsIdIn,INTEGER Xout,INTEGER Yout,ILIST BitmapsIdOut)
CLAUSES
  tc_get_bitmap_par([],Xout,Yout,Bout,Xout,Yout,Bout):-!.
  tc_get_bitmap_par([page(Title,_)|Rest],Xin,Yin,Bin,Xout,Yout,Bout):-
	tc_get_bitmapid(Title,BitmapId),
	Pict = pict_GetFromRes(BitmapId),
	pict_GetSize(Pict,Width,Height,_),
	pict_Destroy (Pict),
	wcc_max(Xin,Width,Xin1),
	wcc_max(Yin,Height,Yin1),!,
	tc_get_bitmap_par(Rest,Xin1,Yin1,[BitmapId|Bin],Xout,Yout,Bout).
  tc_get_bitmap_par([_|Rest],Xin,Yin,Bin,Xout,Yout,Bout):-!,
	tc_get_bitmap_par(Rest,Xin,Yin,Bin,Xout,Yout,Bout).
  tc_get_bitmap_par(_,_,_,_,0,0,[]):-
	errorexit(),!.

PREDICATES
  procedure tc_add_bitmaps(WINDOW TCWin,LONG Hinst,LONG Himage,ILIST)
CLAUSES
  tc_add_bitmaps(_,_,_,[]):-!.
  tc_add_bitmaps(TCWin,Hinst,Himage,[BitmapId|Rest]):-
	BitmapIndex = _wcc_bitmap_add(Hinst,Himage,BitmapId),
	assert(tc_bitmap_index(TCWin,BitmapId,BitmapIndex)),!,
	tc_add_bitmaps(TCWin,Hinst,Himage,Rest).
  tc_add_bitmaps(_,_,_,_):-
	errorexit(),!.

PREDICATES
  determ tc_check_code(ULONG CodeOperation,WINDOW TCWin,UNSIGNED WParam,LONG LParam,TC_MESSAGE,STRING Message)
CLAUSES
  tc_check_code(nm_outofmemory,_,_,_,outofmemory,"OutOfMemory"):-!.
  tc_check_code(nm_click,TCWin,_,_,click(pnt(X,Y)),"Click"):-
	tc_get_mouse_pos(TCWin,X,Y),!.
  tc_check_code(nm_rclick,TCWin,_,_,rclick(pnt(X,Y)),"RClick"):-
	tc_get_mouse_pos(TCWin,X,Y),!.
  tc_check_code(nm_setfocus,_,_,_,setfocus,"SetFocus"):-!.
  tc_check_code(nm_killfocus,_,_,_,losefocus,"KillFocus"):-!.
  tc_check_code(tcn_selchanging,TCWin,_,_,pagechanging(Page),"PageChanging"):-
	tc_get_page(TCWin,Page),!.
  tc_check_code(tcn_selchange,TCWin,_,_,pagechanged(Page),"PageChanged"):-
	tc_get_page(TCWin,Page),
	PageIndex = Page - 1,
	tc_set_pages(TCWin,PageIndex),!.

/**GLOBAL PREDICATE*******************************************************
			     TC_GET_PAGE
 *************************************************************************/
  tc_get_page(TCWin,Page):-
	tc_info(TCWin,WTCWin,_,_),
	PageIndex = win_SendEvent(WTCWin,e_native(tcm_getcursel,0,0)),
	Page = PageIndex + 1,!.
  tc_get_page(_,0):-
	errorexit(error_vpi_package_bad_window),!.

/**GLOBAL PREDICATE*******************************************************
			     TC_SET_PAGE
 *************************************************************************/
  tc_set_page(TCWin,Page):-
	PageIndex = Page - 1,
	tc_info(TCWin,WTCWin,_,_),
	win_SendEvent(WTCWin,e_native(tcm_setcursel,PageIndex,0)),!.
  tc_set_page(_,_):-
	errorexit(error_vpi_package_bad_window),!.

/**GLOBAL PREDICATE*******************************************************
			     TC_INIT
 *************************************************************************/
  tc_Init(TCWin,_,_):-
	tc_info(TCWin,WTCWin,_,_),
	win_Destroy(WTCWin),
	tc_HandleEvent(TCWin,e_Destroy),
	fail.
  tc_Init(TCWin,PageList,CallBack):-
	tc_get_bitmap_par(PageList,0,0,[],X,Y,BitmapIdList),
	wcc_del_equal(BitmapIdList,[],BitmapIdList1),
	wcc_length_list(BitmapIdList1,C),
	Hinst = vpi_GetAttrVal(attr_win_instance),
	WTCWin = _wcc_create(Hinst,TCWin,"SysTabControl32","Tab Control",0),
	Himage = _wcc_bitmap_create(X,Y,C),
	assert(tc_info(TCWin,WTCWin,Himage,CallBack)),
	tc_add_bitmaps(TCWin,Hinst,Himage,BitmapIdList1),
	win_SendEvent(WTCWin,e_native(tcm_setimagelist,0,Himage)),
	tc_add_pages(TCWin,WTCWin,PageList,0),
	win_EnableHook(TCWin,b_true),
	win_PostEvent(TCWin,e_User(16011966,25011965)),
	ParentWin = win_GetParent(TCWin),
	trap(Font = win_GetFont(ParentWin),_,fail),
	trap(win_SetFont(TCWin,Font),_,true),!.
  tc_Init(_,_,_).

/*************************************************************************
			     EVENT HANDLER
 *************************************************************************/
  tc_HandleEvent(TCWin,e_User(16011966,25011965),0):-
	tc_set_pages(TCWin,0),!.
  tc_HandleEvent(TCWin,e_native(wm_notify,WParam,LParam),-1):-
	Event = cast(tc_nmhdr,LParam),
	Event = nmhdr(_,_,CodeOperation),
	tc_check_code(CodeOperation,TCWin,WParam,LParam,TC_Message,_Message),
%	write("_Message=",_Message,"\n"),
	tc_info(TCWin,_,_,CallBack),
	CallBack(TCWin,TC_Message),!.
  tc_HandleEvent(TCWin,e_Size(Width,Height),0):-
	tc_info(TCWin,WTCWin,_,_),
	win_Move(WTCWin,rct(0,0,Width,Height)),!.
  tc_HandleEvent(TCWin,e_State(font(Font)),0):-
	tc_info(TCWin,WTCWin,_,_),
	win_SetFont(WTCWin,Font),!.
  tc_HandleEvent(TCWin,e_State(disabled()),0):-
	tc_info(TCWin,WTCWin,_,_),
	win_SetState(WTCWin,[wsf_Disabled]),!.
  tc_HandleEvent(TCWin,e_State(enabled()),0):-
	tc_info(TCWin,WTCWin,_,_),
	win_SetState(WTCWin,[wsf_Enabled]),!.
  tc_HandleEvent(TCWin,e_State(invisible()),0):-
	tc_info(TCWin,WTCWin,_,_),
	win_SetState(WTCWin,[wsf_Invisible]),!.
  tc_HandleEvent(TCWin,e_State(visible()),0):-
	tc_info(TCWin,WTCWin,_,_),
	win_SetState(WTCWin,[wsf_Visible]),!.
  tc_HandleEvent(TCWin,e_Destroy,0):-
	retractall(tc_info(TCWin,_,_,_)),
	retractall(tc_item_index(TCWin,_,_)),!,
	fail.

enddef /*** use_winctrl_TabCtrl ***/
