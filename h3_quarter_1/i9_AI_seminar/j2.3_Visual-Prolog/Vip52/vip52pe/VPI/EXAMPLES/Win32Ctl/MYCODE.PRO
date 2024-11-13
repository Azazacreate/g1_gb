/******************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:	WINCTRLS
 FileName:	MYCODE.PRO
 Purpose:	Source code without code expert
 Written by:	Sergey Alexeev
 Comments:
******************************************************************************/
DATABASE - test_db
  parent_child(WINDOW Parent,WINDOW Child)
  bitmap_list(SLIST)

CLAUSES
  bitmap_list(["3'5 Floppy","Book","Book opened","CD-ROM","CD-ROM shared","Desktop",
		"Exclamation mark","Folder","Folder opened","Folder shared","HDD","HDD shared",
		"Help topic","Information","INI file","International","Internet","Key","Lock",
		"Mouse","MS DOS","MS Excell file","MS Word file","My Computer","Network drive",
		"Network Neighborhood","Port","Question mark","Recycle Bin","Stop","System",
		"Telephone","Text file","Traffic light green","Traffic light red",
		"Traffic light yellow","Unknown file","User","User group","Winhelp"]).

PREDICATES
  treeview_eh : EHANDLER
  tv_cb : TV_CALLBACK

CLAUSES

  treeview_eh(TVWin,e_Create(_),0):-!,
	TreeList=[
	tree(0,[tvis_bold],idb_7,"Hardware",[
		tree(1,[tvis_expanded],idb_11,"Server",[
			tree(11,[],idb_34,"System block",[]),
			tree(12,[],idb_34,"Monitor",[]),
			tree(13,[],idb_34,"Printer",[]),
			tree(14,[],idb_34,"CD_ROM",[]),
			tree(15,[],idb_34,"Keyboard",[]),
			tree(16,[],idb_34,"Mouse",[])]),
		tree(2,[],idb_9,"WorkStation 1",[
			tree(21,[],idb_34,"System block",[]),
			tree(22,[],idb_34,"Monitor",[]),
			tree(23,[],idb_34,"Keyboard",[]),
			tree(24,[],idb_34,"Mouse",[])]),
		tree(3,[],idb_9,"WorkStation 2",[
			tree(31,[],idb_34,"System block",[]),
			tree(32,[],idb_34,"Monitor",[]),
			tree(33,[],idb_34,"Scanner",[]),
			tree(34,[],idb_34,"Keyboard",[]),
			tree(35,[],idb_34,"Mouse",[])])
		])
	],

	tv_Init(TVWin,
	[tvs_showselalways,tvs_editlabels,tvs_hasbuttons,tvs_linesatroot,tvs_haslines],
	idc_dragdrop,idc_undragdrop,TreeList,tv_cb).
  treeview_eh(TVWin,Event,Answer):-
  	Answer = tv_HandleEvent(TVWin,Event).

PREDICATES
  procedure change_bitmap(WINDOW TVWin,UNSIGNED ItemId,RESID NewBitmapId,RESID AllowedBitmapId)
CLAUSES
  change_bitmap(TVWin,ItemId,NewBitmapId,_):-
	tv_get_item(TVWin,ItemId,_,_,BitMapId),
	BitMapId = NewBitmapId,!.
  change_bitmap(TVWin,ItemId,NewBitmapId,AllowedBitmapId):-
	tv_get_item(TVWin,ItemId,Text,StateList,BitMapId),
	BitMapId = AllowedBitmapId,!,
	tv_set_item(TVWin,ItemId,Text,StateList,NewBitmapId).
  change_bitmap(_,_,_,_).

PREDICATES
  procedure reload_traffic(WINDOW TVWin,UNSIGNED ItemId,BOOLEAN GreenOrRed)
CLAUSES
  reload_traffic(_,ItemId,_):-
	ItemId < 10,!.
  reload_traffic(_,ItemId,_):-
	ItemId = wcc_null,!.
  reload_traffic(TVWin,ItemId,b_true):-
	change_bitmap(TVWin,ItemId,idb_35,idb_34),!.
  reload_traffic(TVWin,ItemId,b_false):-
	change_bitmap(TVWin,ItemId,idb_34,idb_35),!.
  reload_traffic(_,_,_).

PREDICATES
  determ get_state(INTEGER Control,INTEGER State,STRING StateStr)
CLAUSES
  get_state(1,tvis_selected,"tvis_selected"):-!.
  get_state(1,tvis_cut,"tvis_cut"):-!.
  get_state(1,tvis_drophilited,"tvis_drophilited"):-!.
  get_state(1,tvis_bold,"tvis_bold"):-!.
  get_state(1,tvis_expanded,"tvis_expanded"):-!.
  get_state(2,lvis_focused,"lvis_focused"):-!.
  get_state(2,lvis_selected,"lvis_selected"):-!.
  get_state(2,lvis_cut,"lvis_cut"):-!.
  get_state(2,lvis_drophilited,"lvis_drophilited"):-!.

PREDICATES
  determ write_state_list(INTEGER Control,ILIST StateList)
CLAUSES
  write_state_list(_,[]):-!.
  write_state_list(Control,[State|[]]):-
	get_state(Control,State,StateStr),
	write(StateStr),!.
  write_state_list(Control,[State|Rest]):-
	get_state(Control,State,StateStr),
	write(StateStr,","),!,
	write_state_list(Control,Rest).

  tv_cb(_TVWin,Message):-
	write("Tree View CallBack=",Message,"\n"),
	fail.

  tv_cb(TVWin,expanded(ItemId,b_true)):-
	tv_sort_children(TVWin,ItemId),
	ItemId <> 0,
	change_bitmap(TVWin,ItemId,idb_11,idb_9),!,
	fail.
  tv_cb(TVWin,expanded(ItemId,b_false)):-
	ItemId <> 0,
	change_bitmap(TVWin,ItemId,idb_9,idb_11),!,
	fail.
  tv_cb(TVWin,selected(ItemIdUnselect,ItemIdSelect)):-
	reload_traffic(TVWin,ItemIdUnselect,b_false),
	reload_traffic(TVWin,ItemIdSelect,b_true),!,
	fail.

  tv_cb(_,begindrag(ItemId)):-
	ItemId < 10,!.
  tv_cb(_,drag(_,_,ItemId)):-
	ItemId < 10,!.
  tv_cb(_,drag(_,_,ItemId)):-
	ItemId = wcc_null,!.
  tv_cb(_,drop(_,_,ItemId)):-
	ItemId < 10,!.
  tv_cb(_,drop(_,_,ItemId)):-
	ItemId = wcc_null,!.
  tv_cb(TVWin,drop(_,String,TargetId)):-
	trap(term_str(tv_dragdrop,Term,String),_,fail),
	Term = tv_dragdrop(_,_,_,Text,_),
	tv_get_item(TVWin,TargetId,_,StateList,BitmapId),
	tv_set_item(TVWin,TargetId,Text,StateList,BitmapId),!,
	fail.
  tv_cb(TVWin,drop(_,String,TargetId)):-
	trap(term_str(lv_dragdrop,Term,String),_,fail),
	Term = lv_dragdrop(_,Text,_,_,_,_,_),
	tv_get_item(TVWin,TargetId,_,StateList,BitmapId),
	tv_set_item(TVWin,TargetId,Text,StateList,BitmapId),!,
	fail.

  tv_cb(_,beginrdrag(_)):-!.

PREDICATES
  determ get_flags_list(ILIST Check,ILIST Flags,ILIST,ILIST StateList)
CLAUSES
  get_flags_list([],_,StateList,StateList):-!.
  get_flags_list([b_true|CRest],[Flag|FRest],C,StateList):-!,
	get_flags_list(CRest,FRest,[Flag|C],StateList).
  get_flags_list([_|CRest],[_|FRest],C,StateList):-!,
	get_flags_list(CRest,FRest,C,StateList).

PREDICATES
  determ member(INTEGER,ILIST)
CLAUSES
  member(S,[S|_]):-!.
  member(S,[_|L]):-
	member(S,L).

PREDICATES
  determ member_index(STRING,SLIST,UNSIGNED)
CLAUSES
  member_index(S,[S|_],0):-!.
  member_index(S,[_|L],M):-
	bound(M),!,
	N = M - 1,
	member_index(S,L,N),!.
  member_index(S,[_|L],M):-
	bound(S),
	member_index(S,L,N),!,
	M = N + 1.

PREDICATES
  determ get_check_list(ILIST OldFlags,ILIST Flags,ILIST,ILIST Check)
CLAUSES
  get_check_list(_,[],Check,Check):-!.
  get_check_list(OldFlags,[Flag|Rest],Curr,Check):-
	member(Flag,OldFlags),!,
	get_check_list(OldFlags,Rest,[b_true|Curr],Check).
  get_check_list(OldFlags,[_|Rest],Curr,Check):-!,
	get_check_list(OldFlags,Rest,[b_false|Curr],Check).

PREDICATES
  determ  get_bitmap_id(STRING BitmapName,INTEGER BitmapId)
CLAUSES
  get_bitmap_id("Desktop",idb_1):-!.
  get_bitmap_id("My Computer",idb_2):-!.
  get_bitmap_id("3'5 Floppy",idb_3):-!.
  get_bitmap_id("HDD shared",idb_4):-!.
  get_bitmap_id("CD-ROM shared",idb_5):-!.
  get_bitmap_id("Network drive",idb_6):-!.
  get_bitmap_id("Network Neighborhood",idb_7):-!.
  get_bitmap_id("Recycle Bin",idb_8):-!.
  get_bitmap_id("Folder",idb_9):-!.
  get_bitmap_id("Folder shared",idb_10):-!.
  get_bitmap_id("Folder opened",idb_11):-!.
  get_bitmap_id("HDD",idb_12):-!.
  get_bitmap_id("CD-ROM",idb_13):-!.
  get_bitmap_id("Winhelp",idb_14):-!.
  get_bitmap_id("Question mark",idb_15):-!.
  get_bitmap_id("INI file",idb_16):-!.
  get_bitmap_id("Unknown file",idb_17):-!.
  get_bitmap_id("MS Word file",idb_18):-!.
  get_bitmap_id("Text file",idb_19):-!.
  get_bitmap_id("MS Excell file",idb_20):-!.
  get_bitmap_id("User",idb_21):-!.
  get_bitmap_id("User group",idb_22):-!.
  get_bitmap_id("Telephone",idb_23):-!.
  get_bitmap_id("Mouse",idb_24):-!.
  get_bitmap_id("System",idb_25):-!.
  get_bitmap_id("International",idb_26):-!.
  get_bitmap_id("MS DOS",idb_27):-!.
  get_bitmap_id("Port",idb_28):-!.
  get_bitmap_id("Key",idb_29):-!.
  get_bitmap_id("Lock",idb_30):-!.
  get_bitmap_id("Book",idb_31):-!.
  get_bitmap_id("Book opened",idb_32):-!.
  get_bitmap_id("Help topic",idb_33):-!.
  get_bitmap_id("Traffic light red",idb_34):-!.
  get_bitmap_id("Traffic light green",idb_35):-!.
  get_bitmap_id("Traffic light yellow",idb_36):-!.
  get_bitmap_id("Internet",idb_37):-!.
  get_bitmap_id("Exclamation mark",idb_38):-!.
  get_bitmap_id("Stop",idb_39):-!.
  get_bitmap_id("Information",idb_40):-!.

PREDICATES
  listview_eh : EHANDLER
  lv_cb : LV_CALLBACK

CLAUSES

  listview_eh(LVWin,e_Create(_),0):-!,
	ColumnList=[
		column("Hardware",100,left),
		column("Type",100,left),
		column("Cost",100,left)
		   ],
	ItemList=[
		item(0,"System block",idb_1,idb_1,[],["Pentiun 200","$ 1000"]),
		item(1,"Monitor",idb_2,idb_2,[],["Sony 100 Hz","$ 350"]),
		item(2,"Printer",idb_19,idb_19,[],["HP 6P","$ 600"]),
		item(3,"CD_ROM",idb_13,idb_13,[],["Nec changer","$ 100"]),
		item(4,"Scanner",idb_32,idb_32,[],["Agfa","$ 2500"]),
		item(5,"Keyboard",idb_29,idb_29,[],["Standard 101 keys","$ 35"]),
		item(6,"Mouse",idb_24,idb_24,[],["Microsoft","$ 20"]),
		item(7,"Hard disk",idb_12,idb_12,[],["Quantum FB ST 2.1 Gb","$ 250"]),
		item(8,"Floppy disk",idb_3,idb_3,[],["Panasonic","$ 30"])
		 ],
	lv_Init(LVWin,lvs_icon,
	[lvs_showselalways,lvs_editlabels,lvs_autoarrange,lvs_alignleft],
	ColumnList,ItemList,idc_dragdrop,idc_undragdrop,lv_cb).
  listview_eh(LVWin,Event,Answer):-
  	Answer = lv_HandleEvent(LVWin,Event).

PREDICATES
  lv_sortcb : LV_SORTCALLBACK
CLAUSES
  lv_sortcb(LVWin,ItemId1,ItemId2,1,b_true):-
	lv_get_item(LVWin,ItemId1,Item1),
	Item1 = item(_,Text1,_,_,_,_),
	lv_get_item(LVWin,ItemId2,Item2),
	Item2 = item(_,Text2,_,_,_,_),
	Text1 < Text2,!.
  lv_sortcb(_,_,_,1,b_false):-!.
  lv_sortcb(LVWin,ItemId1,ItemId2,2,b_true):-
	lv_get_item(LVWin,ItemId1,Item1),
	Item1 = item(_,_,_,_,_,SubItemsText1),
	lv_get_item(LVWin,ItemId2,Item2),
	Item2 = item(_,_,_,_,_,SubItemsText2),
	SubItemsText1 = [Text1|_],
	SubItemsText2 = [Text2|_],
	Text1 < Text2,!.
  lv_sortcb(_,_,_,2,b_false):-!.
  lv_sortcb(LVWin,ItemId1,ItemId2,3,b_true):-
	lv_get_item(LVWin,ItemId1,Item1),
	Item1 = item(_,_,_,_,_,SubItemsText1),
	lv_get_item(LVWin,ItemId2,Item2),
	Item2 = item(_,_,_,_,_,SubItemsText2),
	SubItemsText1 = [_,Text1|_],
	SubItemsText2 = [_,Text2|_],
	Text1 < Text2,!.
  lv_sortcb(_,_,_,3,b_false):-!.

PREDICATES
  procedure get_unical_ItemId(WINDOW LVWin,INTEGER,INTEGER ItemId)
CLAUSES
  get_unical_ItemId(LVWin,Num,ItemId):-
	trap(lv_get_item(LVWin,Num,_),_,fail),
	Num1 = Num + 1,!,
	get_unical_ItemId(LVWin,Num1,ItemId).
  get_unical_ItemId(_,ItemId,ItemId).

  lv_cb(_LVWin,Message):-
	write("List View CallBack=",Message,"\n"),
	fail.

  lv_cb(LVWin,columnclick(ColumnNumber)):-
	lv_sort_items(LVWin,ColumnNumber,lv_sortcb),!,
	fail.

  lv_cb(_LVWin,drag(_,_,_,TargetItemId)):-
	TargetItemId <> wcc_null,!.
  lv_cb(LVWin,drop(_,String,pnt(X,Y),_)):-
	trap(term_str(tv_dragdrop,Term,String),_,fail),
	Term = tv_dragdrop(_,_,BitmapId,Text,_),
	get_unical_ItemId(LVWin,1,ItemId),
	lv_insert_item(LVWin,item(ItemId,Text,BitmapId,BitmapId,[],[])),
	lv_setitemposition(LVWin,ItemId,pnt(X,Y)),
	!,fail.
  lv_cb(LVWin,drop(FromWin,String,pnt(X,Y),_)):-
	LVWin <> FromWin,
	trap(term_str(lv_dragdrop,Term,String),_,fail),
	Term = lv_dragdrop(_,Text,LargeBitmapId,SmallBitmapId,Flags,SubItemText,_),
	get_unical_ItemId(LVWin,1,ItemId),
	lv_insert_item(LVWin,item(ItemId,Text,LargeBitmapId,SmallBitmapId,Flags,SubItemText)),
	lv_setitemposition(LVWin,ItemId,pnt(X,Y)),
	!,fail.
  lv_cb(LVWin,drop(_,String,pnt(X,Y),_)):-
	trap(term_str(lv_dragdrop,Term,String),_,fail),
	Term = lv_dragdrop(ItemId,_,_,_,_,_,_),
	lv_setitemposition(LVWin,ItemId,pnt(X,Y)),
	!,fail.

  lv_cb(_,beginrdrag(_)):-!.

PREDICATES
  procedure convert_typeflag(UNSIGNED,MENU_TAG)
CLAUSES
  convert_typeflag(lvs_report,id_Actions_View_details):-!.
  convert_typeflag(lvs_smallicon,id_Actions_View_small_icons):-!.
  convert_typeflag(lvs_list,id_Actions_View_list):-!.
  convert_typeflag(_,id_Actions_View_large_icons).

PREDICATES
  determ convert_styleflag(UNSIGNED,MENU_TAG)
CLAUSES
  convert_styleflag(lvs_singlesel,id_Actions_Style_singlesel):-!.
  convert_styleflag(lvs_showselalways,id_Actions_Style_showselalways):-!.
  convert_styleflag(lvs_sortascending,id_Actions_Style_sortascending):-!.
  convert_styleflag(lvs_sortdescending,id_Actions_Style_sortdescending):-!.
  convert_styleflag(lvs_nolabelwrap,id_Actions_Style_nolabelwrap):-!.
  convert_styleflag(lvs_autoarrange,id_Actions_Style_autoarrange):-!.
  convert_styleflag(lvs_editlabels,id_Actions_Style_editlabels):-!.
  convert_styleflag(lvs_noscroll,id_Actions_Style_noscroll):-!.
  convert_styleflag(lvs_alignleft,id_Actions_Style_alignleft):-!.
  convert_styleflag(lvs_aligntop,id_Actions_Style_aligntop):-!.

PREDICATES
  determ style_check(WINDOW LVWin,ILIST StyleList)
CLAUSES
  style_check(_,[]):-!.
  style_check(LVWin,[Style|Rest]):-
	convert_styleflag(Style,StyleItemTag),
	menu_Check(LVWin,StyleItemTag,b_true),!,
	style_check(LVWin,Rest).

PREDICATES
  procedure check_style(WINDOW Win)
CLAUSES
  check_style(Win):-
	menu_Check(Win,id_Actions_View_large_icons,b_false),
	menu_Check(Win,id_Actions_View_small_icons,b_false),
	menu_Check(Win,id_Actions_View_list,b_false),
	menu_Check(Win,id_Actions_View_details,b_false),
	parent_child(Win,LVWin),
	lv_get_type(LVWin,Type),
	convert_typeflag(Type,TypeItemTag),
	menu_Check(Win,TypeItemTag,b_true),
	menu_Check(Win,id_Actions_Style_alignleft,b_false),
	menu_Check(Win,id_Actions_Style_aligntop,b_false),
	menu_Check(Win,id_Actions_Style_singlesel,b_false),
	menu_Check(Win,id_Actions_Style_showselalways,b_false),
	menu_Check(Win,id_Actions_Style_sortascending,b_false),
	menu_Check(Win,id_Actions_Style_sortdescending,b_false),
	menu_Check(Win,id_Actions_Style_nolabelwrap,b_false),
	menu_Check(Win,id_Actions_Style_autoarrange,b_false),
	menu_Check(Win,id_Actions_Style_editlabels,b_false),
	menu_Check(Win,id_Actions_Style_noscroll,b_false),
	lv_get_style(LVWin,StyleList),
	style_check(Win,StyleList),
	!.
  check_style(_).

PREDICATES
  determ del_from_list(ILIST In,INTEGER Item,ILIST,ILIST Out)
CLAUSES
  del_from_list([],_,Out,Out):-!.
  del_from_list([Item|Rest],Item,Curr,Out):-!,
	del_from_list(Rest,Item,Curr,Out).
  del_from_list([I|Rest],Item,Curr,Out):-!,
	del_from_list(Rest,Item,[I|Curr],Out).

PREDICATES
  procedure set_style(WINDOW Win,MENU_TAG)
CLAUSES
  set_style(Win,StyleItemTag):-
	parent_child(Win,LVWin),
	lv_get_style(LVWin,StyleList),
	convert_styleflag(Style,StyleItemTag),
	member(Style,StyleList),
	del_from_list(StyleList,Style,[],StyleList1),
	lv_set_style(LVWin,StyleList1),!.
  set_style(Win,StyleItemTag):-
	parent_child(Win,LVWin),
	lv_get_style(LVWin,StyleList),
	convert_styleflag(Style,StyleItemTag),
	StyleList1 = [Style|StyleList],
	lv_set_style(LVWin,StyleList1),!.
  set_style(_,_).

PREDICATES
  determ get_order(INTEGER OrderId,LV_ORDER Order)
CLAUSES
  get_order(idc_ascending,ascending):-!.
  get_order(idc_descending,descending):-!.
  get_order(idc_sort_item_10,unsorting):-!.

PREDICATES
  determ get_align(INTEGER AlignId,LV_ALIGNMENT Align)
CLAUSES
  get_align(idc_left,left):-!.
  get_align(idc_right,right):-!.
  get_align(idc_center,center):-!.

PREDICATES
  tabctrl_eh : EHANDLER
  tc_cb : TC_CALLBACK
CLAUSES
  tabctrl_eh(TCWin,e_Create(_),0):-!,
	TabList = [
		page(mix("First",idb_1),[idc_treeview,idc_radio_button_1,idc_radio_button_2,idc_radio_button_3,idc_radio_button_4,idc_apply]),
		page(mix("Second",idb_2),[idc_listview,idc_check_box_1,idc_check_box_2,idc_check_box_3,idc_check_box_4,idc_apply])
		],
	tc_Init(TCWin,TabList,tc_cb).
  tabctrl_eh(TCWin,Event,Answer):-
  	Answer = tc_HandleEvent(TCWin,Event).

  tc_cb(_TCWin,Message):-
	write("Tab Control CallBack=",Message,"\n"),
	fail.

PREDICATES
  updown_eh : EHANDLER
  ud_cb : UD_CALLBACK
CLAUSES
  updown_eh(UDWin,e_Create(_),0):-
	ControlId = win_GetCtlId(UDWin),
	ControlId = idc_updown,
	ud_Init(UDWin,[uds_setbuddyint],ud_cb),
	ParentWin = win_GetParent(UDWin),
	CtrlWin = win_GetCtlHandle(ParentWin,idc_edit),
	ud_set_buddy(UDWin,CtrlWin),!.
  updown_eh(UDWin,e_Create(_),0):-
	ControlId = win_GetCtlId(UDWin),
	ControlId = idc_updown1,
	ud_Init(UDWin,[uds_horz,uds_setbuddyint],ud_cb),
	ParentWin = win_GetParent(UDWin),
	CtrlWin = win_GetCtlHandle(ParentWin,idc_edit1),
	ud_set_buddy(UDWin,CtrlWin),!.
  updown_eh(UDWin,Event,Answer):-
  	Answer = ud_HandleEvent(UDWin,Event).

  ud_cb(_UDWin,Message):-
	write("Up Down CallBack=",Message,"\n"),
	fail.

PREDICATES
  treebut_eh : EHANDLER
CLAUSES

  treebut_eh(TBWin,e_Create(_),0):-!,
	TreeList=[
	tree(0,[tvis_bold],idb_7,"Hardware",[
		tree(1,[tvis_expanded],idb_11,"Server",[
			tree(11,[],idb_34,"System block",[]),
			tree(12,[],idb_34,"Monitor",[]),
			tree(13,[],idb_34,"Printer",[]),
			tree(14,[],idb_34,"CD_ROM",[]),
			tree(15,[],idb_34,"Keyboard",[]),
			tree(16,[],idb_34,"Mouse",[])]),
		tree(2,[],idb_9,"WorkStation 1",[
			tree(21,[],idb_34,"System block",[]),
			tree(22,[],idb_34,"Monitor",[]),
			tree(23,[],idb_34,"Keyboard",[]),
			tree(24,[],idb_34,"Mouse",[])]),
		tree(3,[],idb_9,"WorkStation 2",[
			tree(31,[],idb_34,"System block",[]),
			tree(32,[],idb_34,"Monitor",[]),
			tree(33,[],idb_34,"Scanner",[]),
			tree(34,[],idb_34,"Keyboard",[]),
			tree(35,[],idb_34,"Mouse",[])])
		])
	],
	tb_Init(TBWin,TreeList,0).
  treebut_eh(TBWin,Event,0):-
  	tb_HandleEvent(TBWin,Event).
