/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S 

 Project:  CAPSVPI
 FileName: BRWSLIST\BRWSLIST.PRO
 Purpose: VPI conversion of XVT Caps1.2
 Written by: CAPS team
 Comments:

    Future Optimization:
    the visual updating of the tree can be done in O(log(n)), where n is the number of nodes, by keeping a number in each node which
    indicates how many childs it contains.

******************************************************************************/
ifndef treebrws_pre_included
 #Error: this file requires include: treebrws.pre
enddef 

constants
  arrowup=301
  arrowdown=302
  arrowright=303
  arrowleft=304


domains
  BrowseRef=nil;ref(REF)
  DrawLine=line;noline
  DrawLineList=DrawLine*
  Ref_List = ref*
  BROWSENODE = leaf;node(BROWSELIST_STATE,STRING ChainID)
  BROWSEITEM = browseItem(WINDOW,BROWSELIST_USERITEMKEY,STRING Text,BROWSENODE,PICTURE,ILIST Pos,BrowseRef ParentRef,DrawLineList)

  VO = vo(BROWSEREF,ILIST Pos,RCT)
  VOList = VO*
  DOCALLBACK = dont_callback;do_callback
  
database - databaseobj
  db_is_open
DETERM  chainidlist(SLIST ChainIDList)
  
database - browselist_db
  toplevel(WINDOW,STRING TopLevelChainID)
  item_number(WINDOW,INTEGER)
DETERM  listnumber(INTEGER)
  
database - callback
  creating_win(BROWSELIST_INFORMATIONCALLBACK)
  informationcallback(WINDOW,BROWSELIST_INFORMATIONCALLBACK)

database - drawing
  drawing_ypos(WINDOW,INTEGER ypos)
  drawing_xpos(WINDOW,INTEGER xpos)

database - cursorpos
  cursor_pos(WINDOW,BROWSEREF,ILIST Pos,BROWSELIST_USERITEMKEY,RCT) %cursor_pos(WINDOW,BROWSEREF,ILIST Pos,BROWSELIST_USERITEMKEY, RCT,STRING Text,INTEGER XPos, INTEGER YPos)
  keypos(ILIST Pos)
  
database - xtremes
determ  max_char_width(integer)
determ  max_char_height(integer)
determ  max_r(integer)
determ  max_b(integer)
  
database - visualobj
  wingotfocus(WINDOW)
  windowrct(WINDOW,RCT)
  vo_plus_minus(WINDOW,VOList)
  vo_screen_item(WINDOW,VOlist)

facts - treebrowser_database_plusminus_icon
    determ treeBrowserPlusIcon(integer ResIdentifier)
    determ treeBrowserMinusIcon(integer ResIdentifier)

/* lib */
predicates
  procedure line_sync(WINDOW,INTEGER pixel,INTEGER syncedpixels)
clauses
  line_sync(_Win,Pixels,Syncedpixels):-
    Syncedpixels=Pixels - Pixels mod browselist_lineheight,
    Syncedpixels>=0,!.
  
  line_sync(_,_,0).

predicates
procedure  list_count(ILIST,INTEGER,INTEGER)

clauses

  list_count([],Length,Length).
  list_count([_|List],Length,ResLength):-
    NLength=Length+1,
    list_count(List,NLength,ResLength).

% Determins wether Pos1<Pos2
%---------------------------
predicates
determ  pos_IsMin(ILIST Pos1,ILIST Pos2)
clauses
  pos_IsMin([],_).
  pos_IsMin([P|APos],[P|Pos]):-!,
    pos_IsMin(APos,Pos).
  pos_IsMin([AP|_],[P|_]):-
    AP<P,!.
    
predicates
procedure  max(INTEGER,INTEGER,INTEGER)
procedure  min(INTEGER,INTEGER,INTEGER)
clauses

  max(A,B,A):-
    A>=B,!.
  max(_,B,B).

  min(A,B,A):-
    A<=B,!.
  min(_,B,B).

/* Conversions */
predicates
determ  rect_LPtoDP(WINDOW,RCT,RCT)
determ  rect_DPtoLP(WINDOW,RCT,RCT)

clauses

  rect_LPtoDP(Win,rct(LUX,LUY,LLX,LLY),rct(DUX,DUY,DLX,DLY)):-
    DList=win_LPtoDP(Win, [pnt(LUX,LUY),pnt(LLX,LLY)]),
    DList=[pnt(DUX,DUY),pnt(DLX,DLY)].

  rect_DPtoLP(Win,rct(DUX,DUY,DLX,DLY),rct(LUX,LUY,LLX,LLY)):-
    LList=win_DPtoLP(Win, [pnt(DUX,DUY),pnt(DLX,DLY)]),
    LList=[pnt(LUX,LUY),pnt(LLX,LLY)].

predicates
procedure  rev_list(ILIST,ILIST,ILIST)

clauses

  rev_list([],ResList,ResList).
  rev_list([Item|List],RevList,ResList):-
    rev_list(List,[Item|RevList],ResList).

predicates
procedure  ff_long(STRING,INTEGER) 
procedure  long_ff(INTEGER,STRING) 
procedure  ff2long(STRING,INTEGER,INTEGER) 
procedure  long2ff(INTEGER,STRING,STRING)

clauses
  ff_long(Str,Value):-
  	ff2long(Str,0,Value).
  	
  long_ff(Value,Str):-
  	long2ff(Value,"",Str).
  
  ff2long(Str,Value,ResValue):-
	frontchar(Str,FrontChar,RestStr),!,
  	char_int(FrontChar,IntVal),
   	NValue=Value*256+IntVal,
      	ff2long(RestStr,NValue,ResValue).
  ff2long(_,Value,Value):-!.
  
  long2ff(0,Str,Str):-!.
  long2ff(Value,Str,ResStr):-
    	AValue=Value mod 256,
    	char_int(FrontChar,AValue),
    	frontchar(NStr,FrontChar,Str),!,
    	NValue=Value div 256,
      	long2ff(NValue,NStr,ResStr).
  long2ff(_,Str,Str):-!.

/* DB HANDLING */
predicates
determ  open_initial_db
clauses  
  open_initial_db:-
    not(db_is_open),!,
    assert(db_is_open),
    trap(db_create(browselist_db,"brwslist",in_memory),_,fail).

  open_initial_db.

predicates
procedure  item_inc(WINDOW)
procedure  item_dec(WINDOW)

clauses

  item_inc(Win):-
	retract(item_number(Win,Number)),!,
	NNumber=Number+1,
	assert(item_number(Win,NNumber)).  
  item_inc(Win):-
	NNumber=1,
	assert(item_number(Win,NNumber)).

  item_dec(Win):-
	retract(item_number(Win,Number)),!,
	NNumber=Number-1,
	assert(item_number(Win,NNumber)).
  item_dec(_).

predicates
procedure  chainid_getNew(STRING ChainID)
procedure  getNew(SLIST,INTEGER,SLIST ResultingChainIDList,STRING ChainID)

clauses

  chainid_getNew(ChainID):-
	retract(chainidlist(ChainIDList)),!,
	getNew(ChainIDList,-1,NewChainIDList,ChainID),
	assert(chainidlist(NewChainIDList)).
  chainid_getNew(ChainID):-
	getNew([],-1,NewChainIDList,ChainID),
	assert(chainidlist(NewChainIDList)).

  getNew([],PreChainNumber,[ReChainID],ReChainID):-
	ReChainNumber=PreChainNumber+1,
	not(ReChainNumber mod 256 = 0),!,
	long_ff(ReChainNumber,ReChainID).
  getNew([],PreChainNumber,[ReChainID],ReChainID):-
	ReChainNumber=PreChainNumber+2,
	not(ReChainNumber mod 256 = 0),!,
	long_ff(ReChainNumber,ReChainID).
  getNew([],_,[],""):-	%dummy failure handler
	dlg_error("Error in treebrwstool. Proc. getNew: unexpected fail!").
  getNew([ChainID|ChainIDList],PreChainNumber,[ChainID|NewList],ReChainID):-
	ff_long(ChainID,ChainNumber),
	ChainNumber-PreChainNumber=1,!,
	getNew(ChainIDList,ChainNumber,NewList,ReChainID).
  getNew([ChainID|ChainIDList],PreChainNumber,[ReChainID,ChainID|ChainIDList],ReChainID):-
	ReChainNumber=PreChainNumber+1,
	not(ReChainNumber mod 256 = 0),!,
	long_ff(ReChainNumber,ReChainID).
  getNew([ChainID|ChainIDList],_PreChainNumber,[ChainID|NewList],ReChainID):-
	ff_long(ChainID,ChainNumber),
	getNew(ChainIDList,ChainNumber,NewList,ReChainID).

predicates
procedure  chainid_remove(STRING ChainID)
procedure  remove(SLIST ChainIDList,STRING ChainID,SLIST ResultingChainIDList)

clauses

  chainid_remove(ChainID):-
	retract(chainidlist(ChainIDList)),!,
	remove(ChainIDList,ChainID,NewChainIDList),
	assert(chainidlist(NewChainIDList)).
  chainid_remove(_).

  remove([],_RChain,[]).
  remove([RChainID|ChainIDList],RChainID,ChainIDList):-!.
  remove([ChainID|ChainIDList],RChainID,[ChainID|ReChainID]):-
	remove(ChainIDList,RChainID,ReChainID).

predicates
procedure  getDrawLineInfo(BrowseRef,DrawLine)

clauses
  getDrawLineInfo(ref(Ref),line):-
	chain_next(browselist_db,Ref,_),!.
  getDrawLineInfo(_,noline).

predicates
determ  create_item(WINDOW,BROWSELIST_ITEM,ILIST Pos,BROWSEREF,BROWSEREF ParentRef,BROWSEITEM Item,DRAWLINELIST)
determ  create_node(WINDOW,BROWSELIST_NODE,ILIST Pos,BROWSEREF ParentRef,BROWSENODE ItemNode,DRAWLINELIST)
determ  save_browselist_item(WINDOW,STRING ActChainID,ILIST Pos,BROWSEREF ParentRef,BROWSELIST_ITEM,DRAWLINELIST)
determ  save_browselist(WINDOW,STRING ActChainID,ILIST Pos,BROWSEREF ParentRef,BROWSELIST_LIST,DRAWLINELIST)
  
clauses

  create_item(Win,browselistItem(UserItemKey,Text,Node,IconResourceId),Pos,BrowseRef,ParentRef,Item,DrawLineList):-
	create_node(Win,Node,Pos,BrowseRef,ItemNode,DrawLineList),
	Item = browseItem(Win,UserItemKey,Text,ItemNode,IconResourceId,Pos,ParentRef,DrawLineList).

  create_node(Win,node(open,BrowseItemList),Pos,ParentRef,node(open,NewChainID),DrawLineList):-
	chainid_GetNew(NewChainID),
	save_browselist(Win,NewChainID,[0|Pos],ParentRef,BrowseItemList,DrawLineList).
  create_node(_,node(close,_),_,_,node(close,""),_).
  create_node(_,leaf,_,_,leaf,_).      

  save_browselist_item(Win,ChainID,Pos,ParentRef,  browselistItem(UserItemKey,Text,leaf,IconResourceID),DrawLineList):-
	chain_insertz(browselist_db,ChainID,browseitem,browseitem(Win,UserItemKey,Text,leaf,IconResourceID,Pos,ParentRef,DrawLineList),_Ref),
	item_inc(Win).
  save_browselist_item(Win,ChainID,Pos,ParentRef,browselistItem(UserItemKey,Text,node(close,_),IconResourceID),DrawLineList):-
	chain_insertz(browselist_db,ChainID,browseitem,browseitem(Win,UserItemKey,Text,node(close,""),IconResourceID,Pos,ParentRef,DrawLineList),_Ref),
	item_inc(Win).
  save_browselist_item(Win,ChainID,Pos,ParentRef,browselistItem(UserItemKey,Text,node(open,ChildBrowseList),IconResourceID),DrawLineList):-
	chainid_GetNew(NewChainID),
	chain_insertz(browselist_db,ChainID,browseitem,browseitem(Win,UserItemKey,Text,node(open,NewChainID),IconResourceID,Pos,ParentRef,DrawLineList),Ref),
	item_inc(Win),
	save_browselist(Win,NewChainID,[0|Pos],ref(Ref),ChildBrowseList,DrawLineList).

  save_browselist(_,_,_,_,[],_).
  save_browselist(Win,ChainID,[PosItem|Pos],ParentRef,[BrowseListItem|BrowseList],DrawLineList):-
	getDrawLineInfo(ParentRef,DrawLineInfo),
	save_browselist_item(Win,ChainID,[PosItem|Pos],ParentRef,BrowseListItem,[DrawLineInfo|DrawLineList]),
	NPosItem=PosItem+1,
	save_browselist(Win,ChainID,[NPosItem|Pos],ParentRef,BrowseList,DrawLineList).


predicates
determ  pos_GetRef(WINDOW,ILIST Pos,BROWSEREF)
determ  pos_GetRef2(Ref,ILIST Pos,Ref)
clauses

 pos_GetRef(Win,PosList,ref(Ref)):-
    toplevel(Win,TopLevelChainID),
    chain_first(browselist_db,TopLevelChainID,RootRef),
    pos_GetRef2(RootRef,[0|PosList],Ref),!.
  pos_GetRef(_,_,nil).
  
  
    pos_GetRef2(ResRef,[0],ResRef):-!.

    pos_GetRef2(Ref,[0|PosList],ResRef):-
      ref_term(browselist_db,browseitem,Ref,browseitem(_,_,_T,node(open,ChildChain),_,_,_,_)),            
      chain_first(browselist_db,ChildChain,FirstRef),!,
        pos_GetRef2(FirstRef,PosList,ResRef).
        
    pos_GetRef2(Ref,[PosItem|PosList],ResRef):-
      not(PosItem=0),
      NPosItem=PosItem-1,
      chain_next(browselist_db,Ref,NextRef),!,
        pos_GetRef2(NextRef,[NPosItem|PosList],ResRef).

    pos_GetRef2(Ref,_,Ref).



% MB960702 Retrieves browselist_item from internal representation
%----------------------------------------------------------------
predicates
determ    get_ExtItem(browseref,BROWSELIST_ITEM)
determ    get_ExtItemList(ref_list,BROWSELIST_LIST)
determ    get_ExtNode(BROWSENODE,BROWSELIST_NODE)

clauses
  browselist_GetItem(Win,Pos,Item):-
    pos_GetRef(Win,Pos,Ref),
    get_ExtItem(Ref,Item).

  
    get_ExtItem(ref(Ref),browselistItem(UserKey,Label,ExtNode,Picture)):-
      ref_term(browselist_db,browseitem,Ref,browseitem(_,UserKey,Label,IntNode,Picture,_,_,_)),
      get_ExtNode(IntNode,ExtNode).


    get_ExtItemList([],[]).

    get_ExtItemList([ItemRef|ItemRefList],[Item|ItemList]):-
      get_ExtItem(ref(ItemRef),Item),
      get_ExtItemList(ItemRefList,ItemList).
      


    get_ExtNode(leaf,leaf).

    get_ExtNode(node(close,_),node(close,[])).

    get_ExtNode(node(open,ChildChain),node(open,ExtChildItems)):-
      findall(ItemRef,chain_terms(browselist_db,ChildChain,browseitem,_,ItemRef),ItemRefList),
      get_ExtItemList(ItemRefList,ExtChildItems).


predicates
determ  getKeyPos(WINDOW,BROWSELIST_USERITEMKEY,ILIST Pos)
determ    getkeypos_chain(string,BROWSELIST_USERITEMKEY,ILIST Pos)
determ    getkeypos_ref(ref,BROWSELIST_USERITEMKEY,ILIST Pos)
determ    getkeypos_term(browseitem,BROWSELIST_USERITEMKEY,ILIST Pos)

clauses
  getKeyPos(Win,Key,Pos):-
    toplevel(Win,TopLevelChain),!,
    getkeypos_chain(TopLevelChain,Key,Pos).
    
  % MB960208 Another attempt at retrieving the position of a specified key correctly
  getkeypos_chain(Chain,Key,Pos):-    
    chain_first(browselist_db,Chain,FirstRef),  
    getkeypos_ref(FirstRef,Key,Pos).


  getkeypos_ref(Ref,Key,Pos):-  
    ref_term(browselist_db,browseitem,Ref,Item),    
    getkeypos_term(Item,Key,Pos),!.
    
  getkeypos_ref(Ref,Key,Pos):-    
    chain_next(browselist_db,Ref,NextRef),
    getkeypos_ref(NextRef,Key,Pos).

      
  getkeypos_term(browseitem(_,Key,_,_,_,Pos,_,_),Key,Pos):-!.
  
  getkeypos_term(browseitem(_,_,_,node(open,ChildChain),_,_,_,_),Key,Pos):-    
    getkeypos_chain(ChildChain,Key,Pos),!.

predicates
procedure  list_delete(STRING Chain)
procedure  item_delete(BROWSEITEM)

clauses

  list_delete(Chain):-
	chain_terms(browselist_db, Chain, browseitem, Item,Ref),
	  item_delete(Item),
	  term_delete(browselist_db,Chain,Ref),
	  Item= browseItem(Win,_,_,_,_,_,_,_),
	  item_dec(Win),
	fail.
  list_delete(Chain):-
	chainid_remove(Chain).
  
  item_delete(browseItem(_,_,_,node(open,ChildChain),_,_,_,_)):-!,
	list_delete(ChildChain).
  item_delete(_).


predicates
determ  getVOItem(WINDOW,VO)
determ  getVO(WINDOW,VO,VOLIST)
determ  getVOItem_pnt(WINDOW,VO,PNT)
determ  getVOX_pnt(WINDOW,VO,PNT)
determ  getVO_pnt(WINDOW,VO,VOLIST,PNT)

clauses
  getVOItem(Win,VO):-
	vo_screen_item(Win,VOList),!,
	getVO(Win,VO,VOList).

  getVO(_,VO,[VO|_]):-!.
  getVO(Win,VO,[_|VOList]):-
	getVO(Win,VO,VOList).

  getVOItem_pnt(Win,VO,Pnt):-
	vo_screen_item(Win,VOList),!,
	getVO_pnt(Win,VO,VOList,Pnt).

  getVOX_pnt(Win,VO,Pnt):-
	vo_plus_minus(Win,VOList),!,
	getVO_pnt(Win,VO,VOList,Pnt).
  getVO_pnt(_,vo(A,B,Rct),[vo(A,B,Rct)|_],Pnt):-
	rect_pntinside(Rct,Pnt),
	!.
  getVO_pnt(Win,VO,[_|VOList],Pnt):-
	getVO_pnt(Win,VO,VOList,Pnt).
    
predicates
procedure  clean_UpVOList(WINDOW,RCT LClientRct,RCT UpdateRCT,VOLIST In,VOLIST,VOLIST Cleaned)

clauses

  clean_UpVOList(_,_,_,[],VOList,VOList).
  clean_UpVOList(Win,LClientRCT,UpdateRCT,[vo(A,B,RCT)|VOList],CVOList,RVOList):-
	IRCT=rect_intersect(RCT,UpdateRCT),
	IRCT=rct(0,0,0,0),
	IIRCT=rect_intersect(RCT,LClientRCT),
	not(IIRCT=rct(0,0,0,0)),!,
	clean_UpVOList(Win,LClientRCT,UpdateRCT,VOList,[vo(A,B,RCT)|CVOList],RVOList).
  clean_UpVOList(Win,LClientRCT,UpdateRCT,[_|VOList],CVOList,RVOList):-
	clean_UpVOList(Win,LClientRCT,UpdateRCT,VOList,CVOList,RVOList).

predicates
procedure  conv_negative(integer,integer)

clauses
  conv_negative(A,A):-
	A>=0,!.
  conv_negative(_,0).
      
predicates
procedure  update_vertthumbrange(WINDOW)
procedure  update_horzthumbrange(WINDOW)
procedure  setScrollRange(WINDOW,SCROLL_TYPE, INTEGER, INTEGER)
determ  update_vertthumbpos(WINDOW)
determ  update_horzthumbpos(WINDOW)

clauses
  update_vertthumbrange(Win):-
	DClientRct=win_getClientRect(Win),
	rect_DPtoLP(Win,DClientRct,rct(_,UY,_,LY)),
	max_b(Max),!,
	H=Max-(LY-UY) div browselist_lineheight,
	conv_negative(H,HighestTopLine),
	win_GetMapScale(Win,DO,_,_,_),DO=pnt(_,DOY),
	setscrollrange(Win,sb_vert,DOY,HighestTopLine).
  update_vertthumbrange(_).
  
  update_horzthumbrange(Win):-
	DClientRct=win_getClientRect(Win),
	rect_DPtoLP(Win,DClientRct,rct(UX,_,LX,_)),
	max_r(Max),!,
	H=Max-(LX-UX),
	conv_negative(H,HighestTopPos),
	win_GetMapScale(Win,DO,_,_,_),DO=pnt(DOX,_),
	setScrollRange(Win,sb_horz,DOX,HighestTopPos).
  update_horzthumbrange(_).

  setScrollRange(_,_,D,0):-
	D>0,!.
  setScrollRange(Win,SB,_,TP):-
	win_setscrollrange(Win,SB,0,TP).
			
  update_vertthumbpos(Win):-
	DClientRct=win_getClientRect(Win),
	rect_DPtoLP(Win,DClientRct,rct(_,UY,_,_)),
	Pos=UY div browselist_lineheight,
	win_SetScrollPos(Win, sb_vert, Pos).

  update_horzthumbpos(Win):-
	DClientRct=win_getClientRect(Win),
	rect_DPtoLP(Win,DClientRct,rct(UX,_,_,_)),
	win_SetScrollPos(Win, sb_horz, UX).

predicates
procedure    reset_pos(WINDOW)
determ    load_ypos(WINDOW,INTEGER YPos)
determ    load_xpos(WINDOW,INTEGER XPos)
procedure    save_ypos(WINDOW,INTEGER YPos)
procedure    save_xpos(WINDOW,INTEGER XPos)

clauses
  reset_pos(Win):-
	save_ypos(Win,0),
	save_xpos(Win,20).

  load_ypos(Win,YPos):-
	drawing_ypos(Win,YPos),!.

  load_xpos(Win,XPos):-
	drawing_xpos(Win,XPos),!.

  save_ypos(Win,YPos):-
	retract(drawing_ypos(Win,_)),!,
	assert(drawing_ypos(Win,YPos)).
  save_ypos(Win,YPos):-
	assert(drawing_ypos(Win,YPos)).

  save_xpos(Win,XPos):-
	retract(drawing_xpos(Win,_)),!,
	assert(drawing_xpos(Win,XPos)).
  save_xpos(Win,XPos):-
	assert(drawing_xpos(Win,XPos)).

predicates
procedure  setRMax(integer)
procedure  setBMax(integer)

clauses
  setRMax(R):-
	max_r(Max),
	R>Max,!,
	retractall(max_r(_)),
	assert(max_r(R)).
  setRMax(_).

  setBMax(B):-
	max_b(Max),
	B>Max,!,
	retractall(max_b(_)),
	assert(max_b(B)).
  setBMax(_).
    
predicates
determ findXtreme(WINDOW)
procedure  findXtreme_list(WINDOW,BROWSEREF)
procedure  findXtreme_Childlist(WINDOW,BROWSENODE)
procedure  findXtreme_NextItem(WINDOW,BROWSEREF ActItemRef)

clauses

  findXtreme(Win):-
	retractall(max_r(_)),
	retractall(max_b(_)),
	assert(max_r(0)),
	assert(max_b(0)),
	reset_pos(Win),
	toplevel(Win,TopLevelChainID),
	chain_first(browselist_db,TopLevelChainID,FirstItemRef),!,
	findXtreme_list(Win,ref(FirstItemRef)).

  findXtreme_list(_,nil).
  findXtreme_list(Win,ref(ItemRef)):-
	load_xpos(Win,XPos),
	load_ypos(Win,YPos),
	ref_term(browselist_db, browseitem, ItemRef, browseitem(_,_,Text,Node,_,_,_,_)),!,
	TextXPos=XPos+21,
	TextYPos=YPos+11,
	win_GetTextExtent(Win,Text,-1,Width,_),
	RXtreme=TextXPos+Width+4,%gives some space
	BXtreme=TextYPos div browselist_lineheight + 1,
	setRMax(RXtreme),
	setBMax(BXtreme),
	CXPos=browselist_itemwidth+XPos,
	CYPos=browselist_lineheight+YPos,
	save_xpos(Win,CXPos),
	save_ypos(Win,CYPos),
	findXtreme_Childlist(Win,Node),
	save_xpos(Win,XPos),
	findXtreme_NextItem(Win,ref(ItemRef)).
  findXtreme_list(_,ref(_)).

  findXtreme_Childlist(_,leaf).
  findXtreme_Childlist(_,node(close,_)).
  findXtreme_Childlist(_,node(open,"")):-!.
  findXtreme_Childlist(Win,node(open,ChainID)):-
	chain_first(browselist_db,ChainID,FirstRef),!,
	findXtreme_list(Win,ref(FirstRef)).
  findXtreme_Childlist(_,node(open,_)).

  findXtreme_NextItem(Win,ref(ActItemRef)):-
	chain_next(browselist_db,ActItemRef,NextItemRef),!,
	findXtreme_list(Win,ref(NextItemRef)).
  findXtreme_NextItem(_,_).

    
predicates
%CJ To be recoded 
determ  getListNo(WINDOW,BROWSEREF,INTEGER ListNumber)
determ    getListNo2(BROWSEREF,BROWSEREF,INTEGER,INTEGER ListNumber)
clauses
  getListNo(Win,BROWSEREF,ListNumber):-
    toplevel(Win,TopLevelChain),!,
    chain_first(browselist_db,TopLevelChain,FirstRef),
    not(getListNo2(ref(FirstRef),BROWSEREF,0,_)),
    retract(listnumber(ListNumber)).


  getListNo2(BROWSEREF,BROWSEREF,ListNumber,_):-
    assert(listnumber(ListNumber)),!,fail.

  getListNo2(ref(ItemRef),BROWSEREF,ListNumber,ResListNumber):-
    ref_term(browselist_db, browseitem, ItemRef, browseitem(_,_,_,leaf,_,_,_,_)),
    chain_next(browselist_db,ItemRef,NextRef),!,
    NListNumber=ListNumber+1,
      getListNo2(ref(NextRef),BROWSEREF,NListNumber,ResListNumber).
      
  getListNo2(ref(ItemRef),BROWSEREF,ListNumber,ResListNumber):-
    ref_term(browselist_db, browseitem, ItemRef, browseitem(_,_,_,node(close,_),_,_,_,_)),
    chain_next(browselist_db,ItemRef,NextRef),!,
    NListNumber=ListNumber+1,
      getListNo2(ref(NextRef),BROWSEREF,NListNumber,ResListNumber).


  getListNo2(ref(ItemRef),BROWSEREF,ListNumber,ResListNumber):-
    ref_term(browselist_db, browseitem, ItemRef, browseitem(_,_,_,node(open,ChildChain),_,_,_,_)),
    chain_first(browselist_db,ChildChain,FirstChildRef),
    chain_next(browselist_db,ItemRef,NextRef),!,
    NListNumber=ListNumber+1,
      getListNo2(ref(FirstChildRef),BROWSEREF,NListNumber,NNListNumber),
      getListNo2(ref(NextRef),BROWSEREF,NNListNumber,ResListNumber).
    
  getListNo2(ref(ItemRef),BROWSEREF,ListNumber,ResListNumber):-
    ref_term(browselist_db, browseitem, ItemRef, browseitem(_,_,_,node(open,ChildChain),_,_,_,_)),
    chain_first(browselist_db,ChildChain,FirstChildRef),!,
    NListNumber=ListNumber+1,
      getListNo2(ref(FirstChildRef),BROWSEREF,NListNumber,NNListNumber),
      ResListNumber=NNListNumber+0.

%No childs in an open node
  getListNo2(ref(ItemRef),BROWSEREF,ListNumber,ResListNumber):-
    ref_term(browselist_db, browseitem, ItemRef, browseitem(_,_,_,node(open,_),_,_,_,_)),
    chain_next(browselist_db,ItemRef,NextRef),!,
    NListNumber=ListNumber+1,
      getListNo2(ref(NextRef),BROWSEREF,NListNumber,ResListNumber).

  getListNo2(_,_,ListNumber,NListNumber):-
    NListNumber=ListNumber+1.

predicates
determ  getPrevItemRef(BROWSEREF,BROWSEREF PreviousBrowseRef)
determ  getYoungestRelativeItemRef(BROWSEREF,BROWSEREF YoungestRelativeBrowseRef)

clauses
  getPrevItemRef(ref(Ref),ResultRef):-
	chain_prev(browselist_db,Ref,PrevRef),!,
	getYoungestRelativeItemRef(ref(PrevRef),ResultRef).
  getPrevItemRef(ref(Ref),ParentsBrowseRef):-
	ref_term(browselist_db,browseitem,Ref,browseItem(_,_,_,_,_,_,ParentsBrowseRef,_)).

  getYoungestRelativeItemRef(ref(Ref),ResultRef):-
	ref_term(browselist_db,browseitem,Ref,browseItem(_,_,_,node(open,ChildChain),_,_,_,_)),
	chain_last(browselist_db,ChildChain,LastChildRef),!,
	getYoungestRelativeItemRef(ref(LastChildRef),ResultRef).
  getYoungestRelativeItemRef(BrowseRef,BrowseRef).
    
predicates
determ  getNextItemRef(BROWSEREF, BROWSEREF NextBrowseRef)
determ  getParentsNextRef(BROWSEREF, BROWSEREF NextBrowseRef)

clauses
  getNextItemRef(ref(Ref),ref(ResultRef)):-
	ref_term(browselist_db,browseitem,Ref,browseItem(_,_,_,node(open,ChildChain),_,_,_,_)),
	chain_first(browselist_db,ChildChain,ResultRef),!.
  getNextItemRef(ref(Ref),ref(ResultRef)):-
	chain_next(browselist_db,Ref,ResultRef),!.
  getNextItemRef(Ref,ResultRef):-
	getParentsNextRef(Ref,ResultRef),!.
  getNextItemRef(Ref,Ref).

  getParentsNextRef(ref(Ref),ref(ResultRef)):-
	chain_next(browselist_db,Ref,ResultRef),!.
  getParentsNextRef(ref(Ref),ref(ResultRef)):-
	ref_term(browselist_db,browseitem,Ref,browseItem(_,_,_,_,_,_,ParentRef,_)),
	getParentsNextRef(ParentRef,ref(ResultRef)).

predicates
procedure  getPrevLevelItemRef(BROWSEREF,BROWSEREF PrevBrowseRef)

clauses
  getPrevLevelItemRef(ref(Ref),ParentBrowseRef):-
	ref_term(browselist_db,browseitem,Ref,browseItem(_,_,_,_,_,_,ParentBrowseRef,_)),!.
  getPrevLevelItemRef(_,nil).
  
predicates
procedure  getNextLevelItemRef(BROWSEREF,BROWSEREF PrevBrowseRef)

clauses
  getNextLevelItemRef(ref(Ref),ref(FirstChildRef)):-
	ref_term(browselist_db,browseitem,Ref,browseItem(_,_,_,node(open,ChildChain),_,_,_,_)),
	chain_first(browselist_db,ChildChain,FirstChildRef),!.
  getNextLevelItemRef(_,nil).

predicates
procedure  getPrevInLevelItemRef(BROWSEREF,BROWSEREF PrevBrowseRef)

clauses
  getPrevInLevelItemRef(ref(Ref),ref(PrevRef)):-
	chain_prev(browselist_db,Ref,PrevRef),!.
  getPrevInLevelItemRef(BrowseRef,BrowseRef).
  
predicates
procedure  getNextInLevelItemRef(BROWSEREF,BROWSEREF PrevBrowseRef)

clauses
  getNextInLevelItemRef(ref(Ref),ref(NextRef)):-
	chain_next(browselist_db,Ref,NextRef),!.
  getNextInLevelItemRef(BrowseRef,BrowseRef).

/* Callback */
predicates
determ  callback(DOCALLBACK,WINDOW,BROWSELIST_INFORMATIONTYPE)

clauses
  callback(dont_callback,_,_).
  callback(do_callback,Win,Information):-
      informationcallback(Win,InformationCallBack),!,
      InformationCallBack(Win,Information).

  
/* Screen Handling */
%Invalidates the part of the Window which is needed to show the node at pos POS
%-----------------------------------------------------------------------------
predicates
determ  invalidate_listwin(WINDOW,ILIST Pos,integer ItemNo,integer PreYoungestChildNo,integer ActYoungestChildNo)

clauses
% Pos is visual in the window -> update the window from Pos and down
  invalidate_listwin(Win,Pos,_,_,_):-
    getVOItem(Win,vo(_,Pos,LRCT)),!,
    rect_LPtoDP(Win,LRCT,rct(_,UY,_,_)),
    CRct=win_getClientRect(Win),
    CRct=rct(CUX,_,CLX,CLY),
    win_Invalidate(Win,rct(CUX,UY,CLX,CLY)).
% Pos is over the window -> update the entire window
  invalidate_listwin(Win,Pos,_,_,_):-
    getVOItem(Win,vo(_,APos,_)),
    pos_IsMin(Pos,APos),!,
    win_Invalidate(Win).
% Pos is under the window -> update nothing
  invalidate_listwin(_,_,_,_,_).

predicates
determ  browselist_UpdateItem(WINDOW,ILIST Pos,BROWSELIST_ITEM)
determ  browselist_update2(BROWSEITEM,BROWSEREF,BROWSELIST_ITEM)

clauses
  browselist_UpdateItem(Win,Pos,BrowseListItem):-    
    pos_GetRef(Win,Pos,ref(Ref)),
    ref_term(browselist_db,browseitem,Ref,ITEM),!,
    
    getYoungestRelativeItemRef(ref(Ref),ref(YoungestItemRef)),
    getListNo(Win,ref(Ref),ItemNo),
    getListNo(Win,ref(YoungestItemRef),YoungestNo),

    rev_list(Pos,[],RevPos),
    ITEM=browseItem(_,_,_,_,_,RevPos,_,_),    
    browselist_update2(ITEM,ref(Ref),BrowseListItem),
    findXtreme(Win),
    update_vertthumbrange(Win),
    update_vertthumbpos(Win),
    update_horzthumbrange(Win),
    update_horzthumbpos(Win),
    getYoungestRelativeItemRef(ref(Ref),ref(NYoungestItemRef)),
    getListNo(Win,ref(NYoungestItemRef),NYoungestNo),
    invalidate_listwin(Win,RevPos,ItemNo,YoungestNo,NYoungestNo).
      
  browselist_UpdateItem(Win,[],BrowseListItem):-    
    BrowseListItem=browselistitem(ItemKey,_,_,IconID),
    toplevel(Win,TopLevelChain),
    chain_inserta(browselist_db,TopLevelChain,browseitem,  browseItem(Win,ItemKey,"",leaf,IconID,[],nil,[]),Ref),!,
    create_item(Win,BrowseListItem,[],ref(Ref),nil,Item,[]),
    term_replace(browselist_db,browseitem,Ref,Item).
    
  browselist_update2(browseItem(Win,_,_,node(open,ChildChain),_,Pos,ParentRef,DrawLineList),ref(Ref),BrowseListItem):-!,
    list_delete(ChildChain),
    create_item(Win,BrowseListItem,Pos,ref(Ref),ParentRef,Item,DrawLineList),
    term_replace(browselist_db,browseitem,Ref,Item).
      
  browselist_update2(browseItem(Win,_,_,_,_,Pos,ParentRef,DrawLineList),ref(Ref),BrowseListItem):-
    create_item(Win,BrowseListItem,Pos,ref(Ref),ParentRef,Item,DrawLineList),
    term_replace(browselist_db,browseitem,Ref,Item).

predicates
determ  viewRange(WINDOW,integer,integer)
determ  calcWinRange(WINDOW,integer,integer)
determ  makeroom(WINDOW,integer,integer,integer,integer)

clauses

  viewRange(Win,Start,End):-
    calcWinRange(Win,Top,Bottom),
    makeroom(Win,Start,End,Top,Bottom).    
    
  calcWinRange(Win,Top,Bottom):-
    DClientRct=win_getClientRect(Win),
    rect_DPtoLP(Win,DClientRCT,ClientRCT),
    ClientRCT=rct(_,UY,_,LY),
    Top=UY div browselist_lineheight,
    Bottom=LY div browselist_lineheight-1.

% no spaceproblems
  makeroom(_,Start,End,Top,Bottom):-
    Top<=Start,
    Bottom>=End,
    !.
% room for the entire child list
  makeroom(Win,Start,End,Top,Bottom):-
    Bottom<End,
    End-Start<Bottom-Top,!,
    NTop=Top+(End-Bottom),
    NDOY=NTop*browselist_lineheight,
    win_GetMapScale(Win, DevOrg, DevExt, LogOrg, LogExt),
    DevOrg=pnt(DOX,DOY),
    Diff=DOY-NDOY,
    DClientRct=win_getClientRect(Win),
    win_SetMapScale(Win, pnt(DOX,NDOY), DevExt, LogOrg, LogExt),
    win_scroll(Win,DClientRct,0,Diff),
    update_vertthumbpos(Win).
% no room for the entire child list
  makeroom(Win,Start,_End,_Top,_Bottom):-
    NTop=Start,
    NDOY=NTop*browselist_lineheight,
    win_GetMapScale(Win, DevOrg, DevExt, LogOrg, LogExt),
    DevOrg=pnt(DOX,DOY),
    Diff=DOY-NDOY,
    DClientRct=win_getClientRect(Win),
    win_SetMapScale(Win, pnt(DOX,NDOY), DevExt, LogOrg, LogExt),
    win_scroll(Win,DClientRct,0,Diff),
    update_vertthumbpos(Win).

predicates
determ  setWinPos(WINDOW,INTEGER Pos)
determ  setWinPos(WINDOW,RCT DevClientRCT,RCT LogClientRCT,RCT ItemRCT).
procedure  calc_horz_pos(PNT,PNT,INTEGER) %CJ960617

clauses

  setWinPos(Win,Pos):-
    cursor_pos(Win,_,_,_,rct(UX,_,LX,_)),
    DClientRct=win_getClientRect(Win),
    rect_DPtoLP(Win,DClientRCT,ClientRCT),
    UPixelPos=Pos*browselist_lineheight,
    LPixelPos=(Pos+1)*browselist_lineheight-1,
    ItemRCT=rct(UX,UPixelPos,LX,LPixelPos),
    setWinPos(Win,DClientRct,ClientRCT,ItemRCT),!,
    win_update(Win),
    update_horzthumbpos(Win),
    update_vertthumbpos(Win).
  setWinPos(_,_).
  
  
    setWinPos(Win,DevClientRct,rct(CUX,CUY,CLX,_CLY),rct(IUX,IUY,ILX,_ILY)):-
      CUY>IUY,!,
      Diff=CUY-IUY,
      line_sync(Win,Diff,SyncedDiff),
      NSyncedDiff=SyncedDiff,
      NCUY=CUY-NSyncedDiff,
      win_GetMapScale(Win, _, DevExt, LogOrg, LogExt),
      calc_horz_pos(pnt(CUX,CLX),pnt(IUX,ILX),DOX),
      HorzDiff=DOX-CUX,
      win_SetMapScale(Win, pnt(DOX,NCUY), DevExt, LogOrg, LogExt),
      win_scroll(Win,DevClientRct,HorzDiff,NSyncedDiff).
    setWinPos(Win,DevClientRct,rct(CUX,CUY,CLX,CLY),rct(IUX,_IUY,ILX,ILY)):-
      CLY<ILY,!,
      Diff=ILY-CLY,
      line_sync(Win,Diff,SyncedDiff),
      NSyncedDiff=0-(SyncedDiff+browselist_lineheight),
      NCUY=CUY-NSyncedDiff,
      win_GetMapScale(Win, _, DevExt, LogOrg, LogExt),
      calc_horz_pos(pnt(CUX,CLX),pnt(IUX,ILX),DOX),
      HorzDiff=DOX-CUX,
      win_SetMapScale(Win, pnt(DOX,NCUY), DevExt, LogOrg, LogExt),
      win_scroll(Win,DevClientRct,HorzDiff,NSyncedDiff).
    setWinPos(Win,DevClientRct,rct(CUX,CUY,CLX,_),rct(IUX,_IUY,ILX,_)):-
      win_GetMapScale(Win, _, DevExt, LogOrg, LogExt),
      calc_horz_pos(pnt(CUX,CLX),pnt(IUX,ILX),DOX),
      HorzDiff=CUX-DOX,
      not(HorzDiff=0),
      win_SetMapScale(Win, pnt(DOX,CUY), DevExt, LogOrg, LogExt),
      win_scroll(Win,DevClientRct,HorzDiff,0).
      
      %Cursoritem's left side is not visible
      calc_horz_pos(pnt(CUX,_),pnt(IUX,_),NIUX):-
        CUX>(IUX-38),!,
        NIUX=IUX-38.
      %Curosritem's right side is not visible, and there is not enough space to show the entire cursoritem
      calc_horz_pos(pnt(CUX,CLX),pnt(IUX,ILX),NIUX):-
        CLX<ILX,
        CLX-CUX<=(ILX-IUX)+38,!,
        NIUX=IUX-38.
      %Curosritem's right side is not visible, and there is space enough to show the entire cursoritem
      calc_horz_pos(pnt(CUX,CLX),pnt(_,ILX),NIUX):-
        CLX<ILX,!,
        NIUX=CUX+((ILX-CLX)).
      %The entire cursor is visible
      calc_horz_pos(pnt(CUX,_),pnt(_,_),CUX).

predicates
procedure  draw_list(WINDOW,RCT UpdateArea,BROWSEREF,INTEGER YPos,VOList,VOList,VOList,VOList)
procedure  draw_ItemIcon(WINDOW,RCT UpdateArea,INTEGER XPos, INTEGER YPos,PICTURE)
procedure  draw_ItemText(WINDOW,BROWSEREF,RCT UpdateArea,INTEGER XPos, INTEGER YPos,STRING Text)
procedure  draw_ItemText(WINDOW,BROWSEREF,INTEGER XPos, INTEGER YPos,STRING Text)
procedure  drawfocusmark(WINDOW)
procedure  draw_plus_minus(WINDOW,RCT UpdateArea,BROWSENODE,BROWSEREF,ILIST Pos,INTEGER XPos,INTEGER YPos,INTEGER IconAdded,VOList,VOList)
procedure  draw_Childlist(WINDOW,RCT UpdateArea,BROWSENODE,INTEGER YPos,VOList,VOList,VOList,VOList)
procedure  draw_NextItem(WINDOW,RCT UpdateArea,BROWSEREF ActItemRef,INTEGER YPos,VOList,VOList,VOList,VOList)
procedure  save_pickarea(RCT UpdateRCT,VO,VOList,VOLIST)

clauses

  draw_list(_,_,nil,_,VOXList,VOItemList,VOXList,VOItemList).
  draw_list(Win,URCT,ref(ItemRef),LineYPos,VOXList,VOItemList,RVOXList,RVOItemList):-
    URCT=rct(_UUX,_UUY,_ULX,ULY),
    LineYPos<=ULY,
    load_xpos(Win,XPos),
    load_ypos(Win,YPos),
    /* Vert line */
    VLineStartX=XPos-9,
    VLineStartY=YPos+7,
    VLineEndX=VLineStartX,
    VLineEndY=LineYpos,
    draw_line(Win,pnt(VLineStartX,VLineStartY),pnt(VLineEndX,VLineEndY)),
    YPos<=ULY,
    /* Horz line */
    HLineStartX=VLineStartX+8,
    HLineStartY=VLineStartY,
    HLineEndX=VLineStartX,
    HLineEndY=VLineStartY,
    draw_line(Win,pnt(HLineStartX,HLineStartY),pnt(HLineEndX,HLineEndY)),
	ref_term(browselist_db, browseitem, ItemRef, browseitem(_,_,Text,Node,Icon,Pos,_,_)),!,
     /* Draw Icon */
    IconXPos=XPos,
    IconYPos=YPos,
    draw_ItemIcon(Win,URCT,IconXPos,IconYPos,Icon),
    /* Draw Text */
    TextXPos=XPos+21,
    TextYPos=YPos+11,
    draw_ItemText(Win,ref(ItemRef),URCT,TextXPos,TextYPos,Text),
    /* Plus or Minus icon */
    PMXPos=VLineStartX-4,
    PMYPos=VLineStartY-4,
    draw_plus_minus(Win,URct,Node,ref(ItemRef),Pos,PMXPos,PMYPos,IconAdded,VOXList,NVOXList),
    /* Childlist */
    CXPos=browselist_itemwidth+XPos,
    CYPos=browselist_lineheight+YPos,
    save_xpos(Win,CXPos),
    save_ypos(Win,CYPos),
    CLineYPos=YPos+15,
    draw_Childlist(Win,URCT,Node,CLineYPos,NVOXList,VOItemList,NNVOXList,NVOItemList),
    /* Save placement of the icon + text */
    UX=IconXPos-1,
    UY=IconYPos,
    LX=TextXPos+browselist_maxTextWidth,
    LY=TextYPos+4,
    VOItem=vo(ref(ItemRef),Pos,rct(UX,UY,LX,LY)),
    save_pickarea(URCT,VOItem,NVOItemList,NNVOItemList),
    /* Next item in the actual level */
    save_xpos(Win,XPos),
    NLineYPos=VLineStartY+IconAdded,
      draw_NextItem(Win,URct,ref(ItemRef),NLineYpos,NNVOXList,NNVOItemList,RVOXList,RVOItemList).
  draw_list(_,_,ref(_),_,VOXList,VOItemList,VOXList,VOItemList).

      draw_ItemIcon(Win,URCT,XPos,YPos,Icon):-
        LX=XPos+15,
        LY=YPos+15,
        IRCT=rect_intersect(URCT,rct(XPos,YPos,LX,LY)),
        not(IRCT=rct(0,0,0,0)),!,
        pict_draw(Win,Icon,pnt(XPos,YPos),rop_SrcCopy).
      draw_ItemIcon(_,_,_,_,_).

      draw_ItemText(Win,BrowseRef,rct(_UUX,UUY,_ULX,ULY),XPos,YPos,Text):-
        UUY-10<YPos,
        YPos<ULY+10,!,
        draw_ItemText(Win,BrowseRef,XPos,YPos,Text).
      draw_ItemText(_,_,_,_,_,_).
    
        %Got Cursor
        draw_ItemText(Win,BrowseRef,XPos,YPos,Text):-
          cursor_pos(Win,BrowseRef,_,_,RCT),!,
          drawfocusmark(Win),
          win_SetBackMode(Win, bk_Opaque),          
          draw_Rect(Win,RCT),
          win_SetBackMode(Win, bk_Transparent),
          draw_Text(Win,XPos,YPos,Text),
          win_SetForeColor(Win,color_black),
          win_SetPen(Win,pen(1,ps_solid,color_ltgray)).
        draw_ItemText(Win,_,XPos,YPos,Text):-
          draw_text(Win,XPos,YPos,Text).

          drawfocusmark(Win):-
            wingotfocus(Win),!,
            win_SetForeColor(Win,color_white),
            win_SetBrush(Win,brush(pat_solid,0x00660000)),
            win_SetBackColor(Win,color_yellow),
            win_SetPen(Win,pen(1,ps_dot,color_black)).
          drawfocusmark(Win):-            
            win_SetBrush(Win,brush(pat_solid,color_white)),
            win_SetBackColor(Win,color_white),
            win_SetPen(Win,pen(1,ps_dot,color_gray)).

predicates
      draw_PlusIcon(window Win, integer UXPos, integer UYPos) - procedure (i,i,i)
      draw_MinusIcon(window Win, integer UXPos, integer UYPos) - procedure (i,i,i)

clauses

      draw_PlusIcon(Win, UXPos, UYPos):-
          treeBrowserPlusIcon(Idi_plus),
          !,
          draw_icon(Win,UXPos,UYpos, Idi_plus).
      draw_PlusIcon(Win, UXPos, UYPos):-
          OldPen = win_GetPen(Win),
          OldBrush = win_GetBrush(Win),
          win_SetPen(Win, pen(1, ps_solid, color_Gray)),
          win_SetBrush(Win, brush(pat_solid, color_white)),
          URightPos = UXPos + 9, UBottomPos = UYPos + 9,
          draw_Rect(Win, rct(UXPos, UYPos, UrightPos, UBottomPos)),
          win_SetPen(Win, pen(1, ps_solid, color_Black)),
          HorLineLeftXPos = UXPos + 2, HorLineRightXPos = UXPos + 7,
          HorLineYPos = UYPos + 4,
          draw_Line(Win, pnt(HorLineLeftXPos, HorLineYPos), pnt(HorLineRightXPos, HorLineYPos)),
          VerLineTopYPos = UYPos + 2, VerLineBottomYPos = UYPos + 7,
          VerLineXPos = UXPos + 4,
          draw_Line(Win, pnt(VerLineXPos, VerLineTopYPos), pnt(VerLineXPos, VerLineBottomYPos)),
          win_SetPen(Win, OldPen),
          win_SetBrush(Win, OldBrush).

      draw_MinusIcon(Win, UXPos, UYPos):-
          treeBrowserMinusIcon(Idi_Minus),
          !,
          draw_icon(Win,UXPos,UYpos, Idi_Minus).
      draw_MinusIcon(Win, UXPos, UYPos):-
          OldPen = win_GetPen(Win),
          OldBrush = win_GetBrush(Win),
          win_SetPen(Win, pen(1, ps_solid, color_Gray)),
          win_SetBrush(Win, brush(pat_solid, color_white)),
          URightPos = UXPos + 9, UBottomPos = UYPos + 9,
          draw_Rect(Win, rct(UXPos, UYPos, UrightPos, UBottomPos)),
          win_SetPen(Win, pen(1, ps_solid, color_Black)),
          HorLineLeftXPos = UXPos + 2, HorLineRightXPos = UXPos + 7,
          HorLineYPos = UYPos + 4,
          draw_Line(Win, pnt(HorLineLeftXPos, HorLineYPos), pnt(HorLineRightXPos, HorLineYPos)),
          win_SetPen(Win, OldPen),
          win_SetBrush(Win, OldBrush).

clauses
      draw_plus_minus(Win,URct,node(close,_),Ref,Pos,UXPos,UYPos,4,VOXList,[VOX|VOXList]):-
        LXPos=UXPos+8,
        LYPos=UYPos+8,
        IRCT=rect_intersect(URCT,rct(UXPos,UYPos,LXPos,LYPos)),
        not(IRCT=rct(0,0,0,0)),!,
        VOX=vo(Ref,Pos,rct(UXPos,UYPos,LXPos,LYPos)),
        draw_PlusIcon(Win,UXPos,UYpos). %draw correct image
      draw_plus_minus(Win,URct,node(open,_),Ref,Pos,UXPos,UYPos,4,VOXList,[VOX|VOXList]):-
        LXPos=UXPos+8,
        LYPos=UYPos+8,
        IRCT=rect_intersect(URCT,rct(UXPos,UYPos,LXPos,LYPos)),
        not(IRCT=rct(0,0,0,0)),!,
        VOX=vo(Ref,Pos,rct(UXPos,UYPos,LXPos,LYPos)),
        draw_MinusIcon(Win,UXPos,UYpos). %draw correct image
      draw_plus_minus(_,_,_,_,_,_,_,0,VOXList,VOXList).

      draw_Childlist(_,_,leaf,_,VOXList,VOItemList,VOXList,VOItemList).
      draw_Childlist(_,_,node(close,_),_,VOXList,VOItemList,VOXList,VOItemList).
      draw_Childlist(_,_,node(open,""),_,VOXList,VOItemList,VOXList,VOItemList):-!.
      draw_Childlist(Win,URCT,node(open,ChainID),LineYPos,VOXList,VOItemList,RVOXList,RVOItemList):-
        chain_first(browselist_db,ChainID,FirstRef),!,
        draw_list(Win,URCT,ref(FirstRef),LineYPos,VOXList,VOItemList,RVOXList,RVOItemList).
      draw_Childlist(_,_,node(open,_),_,VOXList,VOItemList,VOXList,VOItemList).

      draw_NextItem(Win,URCT,ref(ActItemRef),LineYPos,VOXList,VOItemList,RVOXList,RVOItemList):-
        chain_next(browselist_db,ActItemRef,NextItemRef),!,
        draw_list(Win,URCT,ref(NextItemRef),LineYPos,VOXList,VOItemList,RVOXList,RVOItemList).
      draw_NextItem(_,_,_,_,VOXList,VOItemList,VOXList,VOItemList).

      save_pickarea(UpdateRCT,vo(A,B,RCT),VOList,[vo(A,B,RCT)|VOLIST]):-
        IRCT=rect_intersect(UpdateRCT,RCT),
        not(IRCT=rct(0,0,0,0)),!.
      save_pickarea(_,_,VOList,VOLIST).
      
/* Cursor Handling */
predicates
determ  changeCursor(WINDOW,ILIST Pos,DOCALLBACK)
determ  looseOldCursor(WINDOW,DOCALLBACK)
determ  setCursor(WINDOW,ILIST OldPos,ILIST Pos,DOCALLBACK)
    
clauses

  changeCursor(Win,NewPos,DoCallBack):-    
    cursor_pos(Win,_,OldPos,_,_),!,    
    looseOldCursor(Win,DoCallBack),
    setCursor(Win,OldPos,NewPos,DoCallBack).

    
  changeCursor(Win,NewPos,DoCallBack):-    
    setCursor(Win,[],NewPos,DoCallBack).
  
    looseOldCursor(Win,Callback):-
      cursor_pos(Win,_,PrevPos,PrevUserItemKey,RCT),!,
      rev_list(PrevPos,[],RevPrevPos),
      % MB960321 If callback fails nothing should happen!
      callBack(Callback,Win,cursor_lost(PrevUserItemKey,RevPrevPos)),      
      retractall(cursor_pos(Win,_,_,_,_)),
      rect_LPtoDP(Win,RCT,DRRCT),
      win_invalidate(Win,DRRCT).
          
        
    setCursor(Win,_,RevPos,DoCallBack):-
      rev_list(RevPos,[],Pos),
      pos_GetRef(Win,Pos,ref(ItemRef)),
      ref_term(browselist_db,browseitem,ItemRef,browseitem(_,UserItemKey,Text,_,_,NPos,_,_)),
      % MB960321 If callback fails, cursor should be replaced at old position 
      rev_list(NPos,[],RNPos),
      callback(DoCallBack,Win,cursor_got(UserItemKey,RNPos)),
      win_GetTextExtent(Win,Text,-1,Width,Height),
      getListNo(Win,ref(ItemRef),LinePos),!,
      UY=LinePos*browselist_lineheight,
      list_count(NPos,0,HorzPos),
      UX=(HorzPos+2)*browselist_itemwidth+8,
      RUX=UX,
      RUY=UY,
      RLX=RUX+Width+4,
      RLY=RUY+Height+2,
      RRct=rct(RUX,RUY,RLX,RLY),      
      assert(cursor_pos(Win,ref(ItemRef),NPos,UserItemKey,RRCT)),
      rect_LPtoDP(Win,RRCT,DRRCT),
        win_invalidate(Win,DRRCT).

    setCursor(Win,OldPos,_,CallBack):-      
      rev_list(OldPos,[],RevOldPos),
      setCursor(Win,[],RevOldPos,CallBack).

predicates
determ  validatecursor(WINDOW,ILIST Pos)
clauses

% Cursor pos is still valid
  validatecursor(Win,Pos):-
    cursor_pos(Win,_,Pos,_,_),
     pos_GetRef(Win,Pos,ref(ItemRef)),
    ref_term(browselist_db,browseitem,ItemRef,browseitem(_,_,_,_,_,Pos,_,_)),!,
    looseOldCursor(Win,dont_callBack),
    setCursor(Win,Pos,Pos,dont_callBack).


% Cursor pos is not valid
  validatecursor(Win,Pos):-
    cursor_pos(Win,_,Pos,_,_),!,
    looseOldCursor(Win,do_callBack),
    setCursor(Win,Pos,Pos,do_callBack).



  validatecursor(Win,Pos):-
    cursor_pos(Win,_,CPos,_,_),
    pos_GetRef(Win,CPos,ref(Ref)),
    ref_term(browselist_db,browseitem,Ref,browseitem(_,_,_,_,_,NPos,_,_)),
    not (CPos=NPos),!,    
    changeCursor(Win,Pos,do_callBack).

  validatecursor(Win,Pos):-
    cursor_pos(Win,_,CPos,_,_),
    pos_GetRef(Win,CPos,nil),!,    
    changeCursor(Win,Pos,do_callBack).

  validatecursor(_,_).

predicates
determ  explode_click(WINDOW,BROWSELIST_STATE,BROWSELIST_USERITEMKEY,ILIST Pos)
clauses
  explode_click(Win,open,UserItemKey,Pos):-
    informationcallback(Win,InformationCallBack),!,
    InformationCallback(Win,node_close(UserItemKey,Pos)).
  
  explode_click(Win,close,UserItemKey,Pos):-
    informationcallback(Win,InformationCallBack),!,
    InformationCallback(Win,node_open(UserItemKey,Pos)).


/* Action clauses */
clauses
  browselist_KeyToPos(Win,Key,Pos):-
    getKeyPos(Win,Key,RevPos),  
    rev_list(RevPos,[],Pos).
    
  browselist_ItemUpdate(Win,Pos,ITEM):-
    browselist_UpdateItem(Win,Pos,ITEM),
    rev_list(Pos,[],RevPos),
    validatecursor(Win,RevPos).
        
  browselist_CursorGet(Win,Pos,UserItemKey):-
    cursor_pos(Win,_,RevPos,UserItemKey,_),!,
    rev_list(RevPos,[],Pos).

  browselist_CursorSet(Win,Pos):-    
    rev_list(Pos,[],RevPos),
    changeCursor(Win,RevPos,do_callback).
    
  browselist_CursorMoveNext(Win):-
    cursor_pos(Win,BrowseRef,_,_,_),!,
    getNextItemRef(BrowseRef,ref(NextRef)),
    ref_term(browselist_db,browseitem,NextRef,browseItem(_,_,_,_,_,NextPos,_,_)),
    getListNo(Win,ref(NextRef),ItemNo),
    changeCursor(Win,NextPos,do_callback),
    win_update(Win),
    setWinPos(Win,ItemNo).
        
  browselist_CursorMovePrev(Win):-
    cursor_pos(Win,BrowseRef,_,_,_),!,
    getPrevItemRef(BrowseRef,PrevBrowseRef),
    PrevBrowseRef=ref(PrevRef),
    ref_term(browselist_db,browseitem,PrevRef,browseItem(_,_,_,_,_,PrevPos,_,_)),
    getListNo(Win,ref(PrevRef),ItemNo),
    changeCursor(Win,PrevPos,do_callback),
    win_update(Win),
    setWinPos(Win,ItemNo),
    win_update(Win).
  
  browselist_CursorLevelMoveNext(Win):-
    cursor_pos(Win,BrowseRef,_,_,_),!,
    getNextLevelItemRef(BrowseRef,NextBrowseRef),
    NextBrowseRef=ref(NextRef),
    ref_term(browselist_db,browseitem,NextRef,browseItem(_,_,_,_,_,NextPos,_,_)),
    getListNo(Win,ref(NextRef),ItemNo),
    changeCursor(Win,NextPos,do_callback),
    win_update(Win),
    setWinPos(Win,ItemNo),
    win_update(Win).
    
  browselist_CursorLevelMovePrev(Win):-
    cursor_pos(Win,BrowseRef,_,_,_),!,
    getPrevLevelItemRef(BrowseRef,PrevBrowseRef),
    PrevBrowseRef=ref(PrevRef),
    ref_term(browselist_db,browseitem,PrevRef,browseItem(_,_,_,_,_,PrevPos,_,_)),
    getListNo(Win,ref(PrevRef),ItemNo),
    changeCursor(Win,PrevPos,do_callback),
    win_update(Win),
    setWinPos(Win,ItemNo),
    win_update(Win).

  browselist_CursorMoveNextInLevel(Win):-
    cursor_pos(Win,BrowseRef,_,_,_),!,
    getNextInLevelItemRef(BrowseRef,NextBrowseRef),
    NextBrowseRef=ref(NextRef),
    ref_term(browselist_db,browseitem,NextRef,browseItem(_,_,_,_,_,NextPos,_,_)),
    getListNo(Win,ref(NextRef),ItemNo),
    changeCursor(Win,NextPos,do_callback),
    win_update(Win),
    setWinPos(Win,ItemNo),
    win_update(Win).

  browselist_CursorMovePrevInLevel(Win):-
    cursor_pos(Win,BrowseRef,_,_,_),!,
    getPrevInLevelItemRef(BrowseRef,PrevBrowseRef),
    PrevBrowseRef=ref(PrevRef),
    ref_term(browselist_db,browseitem,PrevRef,browseItem(_,_,_,_,_,PrevPos,_,_)),
    getListNo(Win,ref(PrevRef),ItemNo),
    changeCursor(Win,PrevPos,do_callback),
    win_update(Win),
    setWinPos(Win,ItemNo),
    win_update(Win).

  browselist_ScrollPageUp(Win):-
    win_sendevent(Win,e_vscroll(sc_PageUp,0)).

  browselist_ScrollPageDown(Win):-
    win_sendevent(Win,e_vscroll(sc_PageDown,0)).
  
  browselist_ScrollLineUp(Win):-
    win_sendevent(Win,e_vscroll(sc_LineUp,0)).

  browselist_ScrollLineDown(Win):-
    win_sendevent(Win,e_vscroll(sc_LineDown,0)).
  
  browselist_ScrollLeft(Win):-
    win_sendevent(Win,e_hscroll(sc_LineUp,0)).

  browselist_ScrollRight(Win):-
    win_sendevent(Win,e_hscroll(sc_LineDown,0)).
  
    
  browselist_CloseItem(Win,Pos):-
    pos_GetRef(Win,Pos,ref(ItemRef)),
    ref_term(browselist_db,browseitem,ItemRef,browseItem(_,UserItemKey,_,node(_,_),_,_,_,_)),!,
    explode_click(Win,open,UserItemKey,Pos),
    findXtreme(Win).

  browselist_OpenItem(Win,Pos):-
    pos_GetRef(Win,Pos,ref(ItemRef)),
    ref_term(browselist_db,browseitem,ItemRef,browseItem(_,UserItemKey,_,node(_,_),_,_,_,_)),!,
    explode_click(Win,close,UserItemKey,Pos),
    findXtreme(Win).

  browselist_IsOpen(Win,Pos):- %CJ961219 En toolbruger f†r sine ›nsker opfyldt
    browselist_GetItem(Win,Pos,Item),
    Item = browselistitem(_,_,node(open(),_),_).
    
  browselist_IsClosed(Win,Pos):- %CJ961219 En toolbruger f†r sine ›nsker opfyldt
    browselist_GetItem(Win,Pos,Item),
    Item = browselistitem(_,_,node(close(),_),_).

  browselist_IsLeaf(Win,Pos):- %CJ961219 En toolbruger f†r sine ›nsker opfyldt
    browselist_GetItem(Win,Pos,Item),
    Item = browselistitem(_,_,leaf(),_).

	browselist_PntToNode(Win,PNT,Pos,UserItemKey):-
  	LList=win_DPtoLP(Win,[PNT]),
    LList=[LPNT],
    getVOItem_pnt(Win,vo(ref(ItemRef),_,RCT),LPNT),
    rect_PntInside(RCT, LPNT),
    ref_term(browselist_db,browseitem,ItemRef,browseItem(_,UserItemKey,_,_,_,RevPos,_,_)),!,
    rev_list(RevPos,[],Pos).

  browselist_MakeVisible(Win,Pos):-
    pos_GetRef(Win,Pos,ItemRef),
    getYoungestRelativeItemRef(ItemRef,ref(YoungestItemRef)),
    getListNo(Win,ItemRef,ItemNo),
    getListNo(Win,ref(YoungestItemRef),YoungestNo),
    viewRange(Win,ItemNo,YoungestNo).    
    
    
clauses
  browselist_destroy(Win):-
    retract(toplevel(Win,TopLevelChainID)),
    list_delete(TopLevelChainID),
    retractall(item_number(Win,_)),
    retract(informationcallback(Win,_)),!,
    retractall(drawing_ypos(Win,_)),
    retractall(drawing_xpos(Win,_)),
    retractall(cursor_pos(Win,_,_,_,_)),
    retractall(vo_plus_minus(Win,_)),
    retractall(vo_screen_item(Win,_)),
    win_destroy(Win).

  browselist_destroy(_).


/* event actions */

predicates
determ  mousedown_action(WINDOW,PNT)
clauses
  mousedown_action(Win,PNT):-
  	LList=win_DPtoLP(Win,[PNT]),
    LList=[LPNT],
    getVOItem_pnt(Win,vo(_ItemRef,Pos,RCT),LPNT),
    rect_PntInside(RCT, LPNT),!,
    changeCursor(Win,Pos,do_callback).
    
  mousedown_action(Win,PNT):-
    LList=win_DPtoLP(Win,[PNT]),
    LList=[LPNT],
    getVOX_pnt(Win,vo(ref(ItemRef),RevPos,RCT),LPNT),
    rect_PntInside(RCT, LPNT),
    ref_term(browselist_db,browseitem,ItemRef,browseItem(_,UserItemKey,_,node(State,_),_,RevPos,_,_)),!,
    rev_list(RevPos,[],Pos),
    explode_click(Win,State,UserItemKey,Pos).

  mousedown_action(_,_):-!.

predicates
determ  mousedbl_action(WINDOW,PNT)
clauses  
  mousedbl_action(Win,PNT):-
    LList=win_DPtoLP(Win,[PNT]),
    LList=[LPNT],
    getVOX_pnt(Win,vo(ref(ItemRef),RevPos,RCT),LPNT),
    rect_PntInside(RCT, LPNT),
    ref_term(browselist_db,browseitem,ItemRef,browseItem(_,UserItemKey,_,node(State,_),_,RevPos,_,_)),!,
    rev_list(RevPos,[],Pos),
    explode_click(Win,State,UserItemKey,Pos).

  mousedbl_action(Win,PNT):-
    LList=win_DPtoLP(Win,[PNT]),
    LList=[LPNT],
    getVOItem_pnt(Win,vo(ref(ItemRef),RevPos,RCT),LPNT),
    rect_PntInside(RCT, LPNT),
    ref_term(browselist_db,browseitem,ItemRef,browseItem(_,UserItemKey,_,node(State,_),_,RevPos,_,_)),!,
    rev_list(RevPos,[],Pos),
    explode_click(Win,State,UserItemKey,Pos).

/* Win Handling */  
predicates
procedure  winInformation(WINDOW)
clauses
  winInformation(Win):-
    windowRct(Win,Rct),
    StateList=win_GetState(Win),
    InformationCallback(Win,InformationCallback),
    InformationCallback(Win,actualWindowProperties(Rct,StateList)),!.
  winInformation(_).


predicates
  browselist_eh : EHANDLER
procedure  browselist_winupdate(WINDOW,RCT)
clauses
  browselist_winupdate(Win,RCT):-
    ClientRct=win_getClientRect(Win),
    rect_DPtoLP(Win,ClientRct,LClientRct),
    reset_pos(Win), % set xpos and ypos to initial values
    win_setpen(Win,pen(1,ps_solid,color_ltGray)),
    toplevel(Win,TopLevelChainID),
    chain_first(browselist_db,TopLevelChainID,FirstItemRef),
    retract(vo_plus_minus(Win,VOXList)),
    clean_UpVOList(Win,LClientRct,RCT,VOXList,[],CVOXList),
    retract(vo_screen_item(Win,VOItemList)),!,
    clean_UpVOList(Win,LClientRct,RCT,VOItemList,[],CVOItemList),

%    find_StartingNode(Win,RCT,Pos,ref(StartingItemRef)),
%    draw_list(Win,RCT,ref(StartingItemRef),Pos,CVOXList,CVOItemList,RVOXList,RVOItemList),    
    draw_list(Win,RCT,ref(FirstItemRef),0,CVOXList,CVOItemList,RVOXList,RVOItemList),
    assert(vo_plus_minus(Win,RVOXList)),
    assert(vo_screen_item(Win,RVOItemList)).
  
  browselist_winupdate(_,_).


    
  browselist_create(WINTYPE,RCT,Title,MENU,WINDOW,WSFLAGS,AppData,BROWSELIST_INFORMATIONCALLBACK,WinID):-!,
    open_initial_db,
    assert(creating_win(BrowseList_INFORMATIONCALLBACK)),
    WinID=win_create(WINTYPE,RCT,Title,MENU,WINDOW,WSFLAGS,browselist_eh,AppData),
    assert(windowRCT(WinID,Rct)).

%   Window events
%-------------------------------------------
  browselist_eh(Win,e_closeRequest,0):-
    informationcallback(Win,InformationCallBack),!,
    InformationCallBack(Win,closeRequest).

  browselist_eh(Win,e_destroy,0):-
    informationcallback(Win,InformationCallBack),!,
    InformationCallBack(Win,destroy).
    
  browselist_eh(Win,e_create(Data),0):-
    chainID_getNew(TopLevelChainID),
    assert(toplevel(Win,TopLevelChainID)),
    assert(vo_plus_minus(Win,[])),
    assert(vo_screen_item(Win,[])),
    retractall(max_r(_)),
    retractall(max_b(_)),
    assert(max_r(0)),
    assert(max_b(0)),
    FONT=font_create(ff_helvetica,[],8),
    win_SetFont(Win,FONT),
    win_setmapmode(Win,mm_arbitrary),
    update_vertthumbrange(Win),
    update_vertthumbpos(Win),
    update_horzthumbrange(Win),
    update_horzthumbpos(Win),
    retract(creating_win(BrowseList_INFORMATIONCALLBACK)),!,
    assert(informationcallback(Win,BROWSELIST_INFORMATIONCALLBACK)),
    BrowseList_InformationCallBack(Win,create(Data)).

  browselist_eh(_,e_create(_),0):-!.

  browselist_eh(Win,e_update(RCT),0):-!,
    RCT=rct(UX,UY,LX,LY),
    DList=[pnt(UX,UY),pnt(LX,LY)],
    LList=win_DPtoLP(Win, DList),
    LList=[pnt(LUX,LUY),pnt(LLX,LLY)],
    LRct=rct(LUX,LUY,LLX,LLY),
    win_SetDrawMode(Win,dm_copypen),
    win_clear(Win,LRct,color_white),
    browselist_winupdate(Win,LRct).
  
  browselist_eh(Win,e_Move(UX,UY),0):-
    retract(windowrct(Win,rct(OUX,OUY,OLX,OLY))),!, 
    LX=UX+(OLX-OUX),
    LY=UY+(OLY-OUY),
    assert(windowrct(Win,rct(UX,UY,LX,LY))),
    winInformation(Win).

  browselist_eh(Win,e_Size(W,H),0):-
    update_vertthumbrange(Win),
    update_vertthumbpos(Win),
    update_horzthumbrange(Win),
    update_horzthumbpos(Win),
    retract(windowrct(Win,rct(UX,UY,_,_))),!,
    LX=UX+W,
    LY=UY+H,
    assert(windowrct(Win,rct(UX,UY,LX,LY))),
    winInformation(Win).


  browselist_eh(Win,e_mousedown(PNT,ShtCtlAlt,Button),0):-
    mousedown_action(Win,PNT),
    informationcallback(Win,InformationCallBack),!,
    InformationCallBack(Win,mouse_down(PNT,ShtCtlAlt,Button)).

  browselist_eh(Win,e_mouseup(PNT,ShtCtlAlt,Button),0):-
    informationcallback(Win,InformationCallBack),!,
    InformationCallBack(Win,mouse_up(PNT,ShtCtlAlt,Button)).

  browselist_eh(Win,e_mouseDbl(PNT,ShtCtlAlt,Button),0):-
    mousedbl_action(Win,PNT),
    informationcallback(Win,InformationCallBack),!,
    InformationCallBack(Win,mouse_dbl(PNT,ShtCtlAlt,Button)).

  browselist_eh(Win,e_hscroll(sc_LineDown,_),0):-!,
    DispX=-browselist_lineheight,
    win_GetMapScale(Win, DevOrg, DevExt, LogOrg, LogExt),
    DevOrg=pnt(DOX,DOY),
    NDOX=DOX-DispX, 
    win_getscrollrange(Win,sb_horz,_,Max),
    min(Max,NDOX,DX),
    NDispX=DOX-DX,
    win_SetMapScale(Win, pnt(DX,DOY),DevExt, LogOrg, LogExt),
    ClientRct=win_GetClientRect(Win),
    update_horzthumbpos(Win),
    win_scroll(Win,ClientRct,NDispX,0).
    
  browselist_eh(Win,e_hscroll(sc_LineUp,_),0):-!,
    DispX=browselist_lineheight,
    win_GetMapScale(Win, DevOrg, DevExt, LogOrg, LogExt),
    DevOrg=pnt(DOX,DOY),
    NDOX=DOX-DispX,
    win_getscrollrange(Win,sb_horz,Min,_),
    max(Min,NDOX,DX),
    NDispX=DOX-DX,
    win_SetMapScale(Win, pnt(DX,DOY),DevExt, LogOrg, LogExt),
    ClientRct=win_GetClientRect(Win),
    update_horzthumbpos(Win),
    win_scroll(Win,ClientRct,NDispX,0).


  browselist_eh(Win,e_hscroll(sc_PageDown,_),0):-!,
    RCT=win_getclientrect(Win),
    RCT=rct(_,_,Value,_),
    DispX=0-(Value-browselist_lineheight),
    win_GetMapScale(Win, DevOrg, DevExt, LogOrg, LogExt),
    DevOrg=pnt(DOX,DOY),
    NDOX=DOX-DispX,
    win_getscrollrange(Win,sb_horz,_,Max),
    min(Max,NDOX,DX),
    NDispX=DOX-DX,
    win_SetMapScale(Win, pnt(DX,DOY),DevExt, LogOrg, LogExt),
    ClientRct=win_GetClientRect(Win),
    update_horzthumbpos(Win),
    win_scroll(Win,ClientRct,NDispX,0).

  browselist_eh(Win,e_hscroll(sc_PageUp,_),0):-!,
    RCT=win_getclientrect(Win),
    RCT=rct(_,_,Value,_),
    DispX=(Value-browselist_lineheight),
    win_GetMapScale(Win, DevOrg, DevExt, LogOrg, LogExt),
    DevOrg=pnt(DOX,DOY),
    NDOX=DOX-DispX, 
    win_getscrollrange(Win,sb_horz,Min,_),
    max(Min,NDOX,DX),
    NDispX=DOX-DX,
    win_SetMapScale(Win, pnt(DX,DOY), DevExt, LogOrg, LogExt),
    ClientRct=win_GetClientRect(Win),
    update_horzthumbpos(Win),
    win_scroll(Win,ClientRct,NDispX,0).

  browselist_eh(Win,e_hscroll(sc_ThumbTrack,Pos),0):-!,
    win_GetMapScale(Win, DevOrg, DevExt, LogOrg, LogExt),
    DevOrg=pnt(DOX,DOY),
    Diff=DOX-Pos,
    win_SetMapScale(Win, pnt(Pos,DOY), DevExt, LogOrg, LogExt),
    ClientRct=win_GetClientRect(Win),
    update_horzthumbpos(Win),
    win_scroll(Win,ClientRct,Diff,0).




  browselist_eh(Win,e_vscroll(sc_LineDown,_),0):-!,
    DispY=-browselist_lineheight,
    win_GetMapScale(Win, DevOrg, DevExt, LogOrg, LogExt),
    DevOrg=pnt(DOX,DOY),
    NDOY=DOY-DispY,
    win_getscrollrange(Win,sb_vert,_,Max),
    ExpMax=Max*browselist_lineheight,
    min(NDOY,ExpMax,DY),
    line_sync(Win,DY,CDY),
    NDispY=DOY-CDY,
    win_SetMapScale(Win, pnt(DOX,CDY),DevExt, LogOrg, LogExt),
    ClientRct=win_GetClientRect(Win),
    update_vertthumbpos(Win),
    win_scroll(Win,ClientRct,0,NDispY).

  browselist_eh(Win,e_vscroll(sc_LineUp,_),0):-!,
    DispY=browselist_lineheight,
    win_GetMapScale(Win, DevOrg, DevExt, LogOrg, LogExt),
    DevOrg=pnt(DOX,DOY),
    NDOY=DOY-DispY,
    win_getscrollrange(Win,sb_vert,Min,_),
    ExpMin=Min*browselist_lineheight,
    max(NDOY,ExpMin,DY),
    line_sync(Win,DY,CDY),
    NDispY=DOY-CDY,
    win_SetMapScale(Win, pnt(DOX,CDY), DevExt, LogOrg, LogExt),
    ClientRct=win_GetClientRect(Win),
    update_vertthumbpos(Win),
    win_scroll(Win,ClientRct,0,NDispY).

  browselist_eh(Win,e_vscroll(sc_PageDown,_),0):-!,
    RCT=win_getclientrect(Win),
    RCT=rct(_,_,_,Value),
    DispY=0-(Value - browselist_lineheight),
    win_GetMapScale(Win, DevOrg, DevExt, LogOrg, LogExt),
    DevOrg=pnt(DOX,DOY),
    NDOY=DOY-DispY,
    win_getscrollrange(Win,sb_vert,_,Max),
    ExpMax=Max*browselist_lineheight,
    min(ExpMax,NDOY,DY),
    line_sync(Win,DY,CDY),
    NDispY=DOY-CDY,
    win_SetMapScale(Win, pnt(DOX,CDY), DevExt, LogOrg, LogExt),
    ClientRct=win_GetClientRect(Win),
    update_vertthumbpos(Win),
    win_scroll(Win,ClientRct,0,NDispY).
    
  browselist_eh(Win,e_vscroll(sc_PageUp,_),0):-!,
    RCT=win_getclientrect(Win),
    RCT=rct(_,_,_,Value),
    DispY=(Value - browselist_lineheight),
    win_GetMapScale(Win, DevOrg, DevExt, LogOrg, LogExt),
    DevOrg=pnt(DOX,DOY),
    NDOY=DOY-DispY,
    win_getscrollrange(Win,sb_vert,Min,_),
    ExpMin=Min*browselist_lineheight,
    max(ExpMin,NDOY,DY),
    line_sync(Win,DY,CDY),
    NDispY=DOY-CDY,
    win_SetMapScale(Win, pnt(DOX,CDY), DevExt, LogOrg, LogExt),
    ClientRct=win_GetClientRect(Win),
    update_vertthumbpos(Win),
    win_scroll(Win,ClientRct,0,NDispY).
  

  browselist_eh(Win,e_vscroll(sc_ThumbTrack,Pos),0):-!,
    CoorPos=Pos*browselist_lineheight,
    win_GetMapScale(Win, DevOrg, DevExt, LogOrg, LogExt),
    DevOrg=pnt(DOX,DOY),
    Diff=DOY-CoorPos,
    win_SetMapScale(Win, pnt(DOX,CoorPos), DevExt, LogOrg, LogExt),
    ClientRct=win_GetClientRect(Win),
    update_vertthumbpos(Win),
    win_scroll(Win,ClientRct,0,Diff).


  browselist_eh(Win,e_Char(Char,ShiftCtlAlt),0):-
    informationcallback(Win,InformationCallBack),!,
    InformationCallBack(Win,char(Char,ShiftCtlAlt)).

  browselist_eh(Win,e_keyDown(Char,ShiftCtlAlt),0):-
    informationcallback(Win,InformationCallBack),!,
    InformationCallBack(Win,key_Down(Char,ShiftCtlAlt)).

  browselist_eh(Win,e_keyUp(Char,ShiftCtlAlt),0):-
    informationcallback(Win,InformationCallBack),!,
    InformationCallBack(Win,key_Up(Char,ShiftCtlAlt)).

  browselist_eh(Win,e_GetFocus,0):-
    retractall(wingotfocus(Win)),
    assert(wingotfocus(Win)),
    cursor_pos(Win,_,_,_,RCT),!,
    win_invalidate(Win,RCT).

  browselist_eh(Win,e_LoseFocus,0):-
    retractall(wingotfocus(Win)),
    cursor_pos(Win,_,_,_,RCT),!,
    RCT=rct(UX,UY,LX,LY),
    LList=[pnt(UX,UY),pnt(LX,LY)],
    DList=win_LPtoDP(Win, LList),
    DList=[pnt(DUX,DUY),pnt(DLX,DLY)],
    DRCT=rct(DUX,DUY,DLX,DLY),
    win_invalidate(Win,DRCT).

  browselist_eh(_Win,_,0).

  browselist_SetPlusMinusIcon(PlusIconId, MinusIconId):-
    assert(treeBrowserPlusIcon(PlusIconId)),
    assert(treeBrowserMinusIcon(MinusIconId)).

