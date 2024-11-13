/******************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 FileName:	MAPHNDL.PRO
 Purpose:	Map viewer and editor for TRANS project.
 Written by:	Alexander Butovsky
 Comments:
******************************************************************************/
constants
  mvwin_view_title = "Map view"	% Map window title for view mode
  mvwin_edit_title = "Map edit"	% Map window title for edit mode
  mvctrl_id = 7657		% Map custom control Id
  mv_filename = "Denmark.dat"	% File containing map background
  mv_object_size = 40		% Default size of the map foreground circles
  escape_key = 27

  % Right mouse button menu tags:
  %  - view mode
  mvmenu_zoomin_obj_id		= 15100
  mvmenu_zoomout_obj_id		= 15101
  mvmenu_before_id		= 15102
  mvmenu_deliveries_id		= 15103
  mvmenu_after_id		= 15104
  mvmenu_sorts_id		= 15105

  %  - edit mode
  mvmenu_add_manufacturer_id	= 15200
  mvmenu_add_customer_id	= 15201
  mvmenu_move_id		= 15202
  mvmenu_delete_id		= 15203

  % Right mouse button menu texts:
  %  - view mode
  mvmenu_zoomin_obj_txt	 = "Zoom objects in\tShift +"
  mvmenu_zoomout_obj_txt = "Zoom objects out\tShift -"
  mvmenu_before_txt	 = "Before transportation"
  mvmenu_deliveries_txt	 = "Transportation from/to"
  mvmenu_after_txt	 = "After transportation"
  mvmenu_sorts_txt	 = "Show transportation lines"

  %  - edit mode
  mvmenu_add_manufacturer_txt	= "Add manufacturer"
  mvmenu_add_customer_txt	= "Add customer"
  mvmenu_move_txt		= "Move object"
  mvmenu_delete_txt		= "Delete object"

  % Error messages
  mv_error_add_manufacturer_txt = "Can not add manufacturer. All known manufacturers are already on the map."
  mv_error_add_customer_txt = "Can not add customer. All known customers are already on the map."
  mv_delete_error = "No object(s) marked."

  % Object delete dialog in edit mode
  mv_delete_buttons = ["Delete","Cancel"]
  mv_delete_prompt = "Are you sure you want to delete marked object(s) from map?"

database - maphndl_local
  determ mode(WINDOW MapWin,INTEGER Mode) % 1 - view, 2 - edit
  determ click_point(PNT)		  % Position of last mouse click in map coordinates
  determ mv_move(ULONG)			  % Object Id

predicates
  procedure get_fgobject_size(INTEGER)
  procedure get_mapwin_initial_rct(RCT)
  procedure get_mapwin_initial_mapscale(MAPCTRL_MAPSCALE)
  procedure mv_display_foreground_objects(WINDOW,INTEGER)
  mv_eh : EHANDLER

  %-------------------------------------
  % -------- global predicates ---------
  %-------------------------------------
clauses
  mv_ShowMap(_):-
	mode(Win,1),
	win_BringToTop(Win),
	!.
  mv_ShowMap(_):-
	retract(mode(Win,2)),
	win_Destroy(Win),
	fail.
  mv_ShowMap(TaskWin):-
	ini_db_name(_),		% database has been loaded
	not(mode(_,_)),
	get_mapwin_initial_rct(Rct),
	Rct = rct(L,T,R,B), Width = R - L, Height = B - T,
	Win = win_Create(w_TopLevel,Rct,mvwin_view_title,no_menu,TaskWin,
					[wsf_TitleBar,wsf_SizeBorder,wsf_Minimize,wsf_Maximize,wsf_Close],mv_eh,0),
	assert(mode(Win,1)),
	WDEF = wdef(wc_Custom,rct(0,0,Width,Height),"",u_Pixels),
	MapW = win_CreateDynControl([customctl(WDEF,"mapctrl",mvctrl_id,[])],Win),
	win_SetFocus(MapW),!.

  mv_EditMap(_):-
	mode(Win,2),
	win_BringToTop(Win),
	!.
  mv_EditMap(_):-
	retract(mode(Win,1)),
	win_Destroy(Win),
	fail.
  mv_EditMap(TaskWin):-
	ini_db_name(_),		% database has been loaded
	not(mode(_,_)),
	get_mapwin_initial_rct(Rct),
	Rct = rct(L,T,R,B), Width = R - L, Height = B - T,
	Win = win_Create(w_TopLevel,Rct,mvwin_edit_title,no_menu,TaskWin,
					[wsf_TitleBar,wsf_SizeBorder,wsf_Minimize,wsf_Maximize,wsf_Close],mv_eh,0),
	assert(mode(Win,2)),
	WDEF = wdef(wc_Custom,rct(0,0,Width,Height),"",u_Pixels),
	MapW = win_CreateDynControl([customctl(WDEF,"mapctrl",mvctrl_id,[])],Win),
	win_SetFocus(MapW),!.

  mv_StoreLayout():-
	mode(Win,_),!,
	Rect = win_GetOuterRect(Win),
	Rect = rct(L,T,R,B),
	TitleHeight = vpi_GetAttrVal(attr_title_height),
	BorderHeight = vpi_GetAttrVal(attr_dblframe_height),
	BorderWidth = vpi_GetAttrVal(attr_dblframe_width),
	T1 = T + val(integer,TitleHeight) + BorderHeight + 1,
	L1 = L + BorderWidth + BorderWidth,
	R1 = R - BorderWidth - BorderWidth,
	B1 = B - BorderWidth - BorderWidth,
	MapctrlWin = win_GetCtlHandle(Win,mvctrl_id),
	MapScale = mapctrl_GetMapScale(MapctrlWin),
	retractall(ini_map_layout(_,_,_)),
	assert(ini_map_layout(rct(L1,T1,R1,B1),MapScale,b_true)).
  mv_StoreLayout():-
	retract(ini_map_layout(Rct,MapScale,_)),!,
	assert(ini_map_layout(Rct,MapScale,b_false)).
  mv_StoreLayout():-!.

  mv_MapRefresh():-
	mode(Win,_),!,
	MapctrlWin = win_GetCtlHandle(Win,mvctrl_id),
	mapctrl_RemoveArrows(MapctrlWin),
	mapctrl_RemoveCircles(MapctrlWin),
	get_fgobject_size(ObjectSize),
	mv_display_foreground_objects(MapctrlWin,ObjectSize).
  mv_MapRefresh().

  %---------------------------------------
  %  Map view/edit window event handler
  %---------------------------------------
clauses
  mv_eh(Win,e_Size(W,H),0):-
	trap(MapCtrlWin = win_GetCtlHandle(Win,mvctrl_id),_,fail),
	win_Move(MapCtrlWin,rct(0,0,W,H)),fail.

  mv_eh(_Win,e_Destroy(),0):-
	mv_StoreLayout(),
	retractall(mode(_,_)),fail.

  %---------------------------------------
  % Map custom control class event handler
  %---------------------------------------
predicates
  mapctrl_callback : MAPCTRL_CALLBACK

clauses
  mapctrl_class_handler(Win,e_Create(_),0):-!,
	get_mapwin_initial_mapscale(MapScale),
	mapctrl_Init(Win,color_Cyan,filename(mv_filename),view([]),MapScale,mapctrl_callback),
	get_fgobject_size(ObjectSize),
	mv_display_foreground_objects(Win,ObjectSize).
  mapctrl_class_handler(Win,Event,0):-
	mapctrl_HandleEvent(Win,Event).

  %---------------------------------------
  % Map custom control callback function
  %---------------------------------------
predicates
  procedure MENU_ITEM_LIST create_popup(ULONGLIST Marker,INTEGER ViewOrEditMode)
  procedure open_status_before(ULONG Id)
  procedure open_status_after(ULONG Id)
  determ check_not_empty(MENU_TAG,ULONGLIST)
  determ mv_member_index(ULONG,ULONGLIST,INTEGER)
  determ check_empty_marker(ULONGLIST)
  procedure mv_remove_objects(ULONGLIST)
  procedure mv_move_object(WINDOW,ULONG Id,INTEGER X,INTEGER Y)

clauses
  mapctrl_callback(_Win,Event):-
	not(Event = event(e_MouseMove(_,_,_))),
	fail.

  % ++++ Disable multiple objects marking in view mode
  mapctrl_callback(_,event(e_MouseDown(_,c_Control,mouse_button_left))):-
	mode(_,Mode),
	Mode = 1,!.	% View mode

  % ++++ Store right mouse button click position for future use, change menu
  mapctrl_callback(Win,event(e_MouseDown(WinPNT,_SCA,mouse_button_right))):-
	MapPNT = mapctrl_WinToMap(Win,WinPNT),
	retractall(click_point(_)),
	assert(click_point(MapPnt)),
	Marker = mapctrl_GetMarker(Win),
	mode(_,Mode),
	MenuList = create_popup(Marker,Mode),
	mapctrl_SetMode(Win,view(MenuList)),
	fail.

  % ++++ Zoom foreground object in and out
  mapctrl_callback(Win,event(e_Menu(mvmenu_zoomin_obj_id,_SCA))):-!,
	mapctrl_callback(Win,event(e_Char(43,c_Shift))).
  mapctrl_callback(Win,event(e_Menu(mvmenu_zoomout_obj_id,_SCA))):-!,
	mapctrl_callback(Win,event(e_Char(45,c_Shift))).

  mapctrl_callback(Win,event(e_Char(43,c_Shift))):-!,	% Shift +
	get_fgobject_size(ObjectSize),
	NewSize = val(integer,ObjectSize * 1.5),
	retractall(ini_fgobject_size(_)),
	assert(ini_fgobject_size(NewSize)),
	mapctrl_RemoveCircles(Win),
	mv_display_foreground_objects(Win,NewSize).
  mapctrl_callback(Win,event(e_Char(45,c_Shift))):-!,	% Shift -
	get_fgobject_size(ObjectSize),
	NewSize = val(integer,ObjectSize / 1.5),
	retractall(ini_fgobject_size(_)),
	assert(ini_fgobject_size(NewSize)),
	mapctrl_RemoveCircles(Win),
	mv_display_foreground_objects(Win,NewSize).

  % ++++ Open forms from mouse menu 
  mapctrl_callback(Win,event(e_Menu(mvmenu_before_id,_SCA))):-	 % Manufacturer/Customer status before transportation
	Marker = mapctrl_GetMarker(Win),
	Marker = [Id],!,
	open_status_before(Id).
  mapctrl_callback(Win,event(e_Menu(mvmenu_deliveries_id,_SCA))):- % Transportation
	Marker = mapctrl_GetMarker(Win),
	Marker = [Id],
	Id < 10000,!,				% Manufacturer
	ef_form_Create(con_move,[columnfilter(1,[lf_range(Id,Id)])]).
  mapctrl_callback(Win,event(e_Menu(mvmenu_deliveries_id,_SCA))):- % Transportation
	Marker = mapctrl_GetMarker(Win),
	Marker = [Id],!, Id1 = Id - 10000, 	% Customer
	ef_form_Create(con_move,[columnfilter(2,[lf_range(Id1,Id1)])]).
  mapctrl_callback(Win,event(e_Menu(mvmenu_after_id,_SCA))):-	 % Manufacturer/Customer status after transportation
	Marker = mapctrl_GetMarker(Win),
	Marker = [Id],!,
	open_status_after(Id).

  % ++++ Handling rightmouse menu in edit mode ++++
  mapctrl_callback(Win,event(e_Menu(mvmenu_add_manufacturer_id,_SCA))):-		% Add new Manufacturer
	click_point(Pnt),
	findall(N,tr_db_producer(N,_,_,0,0),IdList),
	findall(Name,tr_db_producer(_,Name,_,0,0),NameList),
	check_not_empty(mvmenu_add_manufacturer_id,IdList),
	OK = dlg_ListSelect(Win,mvmenu_add_manufacturer_txt,NameList,0,Name,Index,b_false),
	OK = b_true, not(Name = ""),
	Index1 = Index + 1,
	mv_member_index(Id,IdList,Index1),
	Pnt = pnt(X,Y),
	retract(tr_db_producer(Id,_,Comm,_,_)),!,
	assert(tr_db_producer(Id,Name,Comm,X,Y)),
	get_fgobject_size(ObjectSize),
	mapctrl_AddObjects(Win,[circle(Id,Pnt,ObjectSize,pen(1,ps_Solid,color_Black),brush(pat_Solid,0x40FF00),
				       label(pnt(10,-20),Name,ff_Helvetica,[fs_Bold],ObjectSize,color_Black))]).

  mapctrl_callback(Win,event(e_Menu(mvmenu_add_customer_id,_SCA))):-		% Add new Customer
	click_point(Pnt),
	findall(N,tr_db_customer(N,_,_,0,0),IdList),
	findall(Name,tr_db_customer(_,Name,_,0,0),NameList),
	check_not_empty(mvmenu_add_customer_id,IdList),
	OK = dlg_ListSelect(Win,mvmenu_add_customer_txt,NameList,0,Name,Index,b_false),
	OK = b_true, not(Name = ""),
	Index1 = Index + 1,
	mv_member_index(Id,IdList,Index1),
	Pnt = pnt(X,Y),
	retract(tr_db_customer(Id,_,Comm,_,_)),!,
	assert(tr_db_customer(Id,Name,Comm,X,Y)),
	get_fgobject_size(ObjectSize),
	Id1 = Id + 10000,
	mapctrl_AddObjects(Win,[circle(Id1,Pnt,ObjectSize,pen(1,ps_Solid,color_Black),brush(pat_Solid,color_red),
				       label(pnt(10,-20),Name,ff_Helvetica,[fs_Bold],ObjectSize,color_Black))]).

  mapctrl_callback(Win,event(e_Menu(mvmenu_delete_id,_SCA))):-		% Remove marked objects
	Marker = mapctrl_GetMarker(Win),
	check_empty_marker(Marker),
	Answer = dlg_Ask(Win,mvmenu_delete_txt,mv_delete_prompt,mv_delete_buttons),
	Answer = resp_default,!,
	mv_remove_objects(Marker),
	mapctrl_RemoveObjects(Win,Marker).

  %+++ Move object
  mapctrl_callback(Win,event(e_Menu(mvmenu_move_id,_SCA))):-		% Start object move
	Marker = mapctrl_GetMarker(Win),
	Marker = [Id],
	retractall(mv_move(_)),
	assert(mv_move(Id)),
	cursor_Set(Win,cursor_Cross),
	win_CaptureMouse(Win).

  mapctrl_callback(Win,event(e_MouseDown(WinPNT,_SCA,mouse_button_left))):-  % Left mouse down in move mode -
	retract(mv_move(Id)),						     %  - move marked object here
	win_ReleaseMouse(),
	cursor_Set(Win,cursor_Arrow),
	RCT = win_GetClientRect(Win),
	rect_PntInside(RCT,WinPNT),!,
	MapPNT = mapctrl_WinToMap(Win,WinPNT),
	MapPNT = pnt(X,Y),
	mv_move_object(Win,Id,X,Y).


  mapctrl_callback(_Win,event(e_MouseUp(_PNT,_SCA,mouse_button_left))):-	% Left mouse up in move mode -
	mv_move(_),!.								%  - do nothing
  mapctrl_callback(_Win,event(e_MouseDown(_PNT,_SCA,mouse_button_right))):-	% Right mouse down in move mode -
	mv_move(_),!.								%  - do nothing

  mapctrl_callback(Win,event(e_Char(escape_key,_))):- 			% Escape key - terminate move mode
	win_ReleaseMouse(),
	cursor_Set(Win,cursor_Arrow),
	retractall(mv_move(_)),!.

  mapctrl_callback(_,action(marker(Marker,_))):- 			% Attempt to mark an arrow
	Marker = [777],!.

%-------------------------------------------------------------------

  open_status_before(Id):-
	Id < 10000,!,		% Manufacturer
	ef_form_Create(con_production,[columnfilter(1,[lf_range(Id,Id)])]).
  open_status_before(Id):-
	Id1 = Id - 10000,
	ef_form_Create(con_custom,[columnfilter(1,[lf_range(Id1,Id1)])]). % Customer

  open_status_after(Id):-
	Id < 10000,!,		% Manufacturer
	ef_form_Create(con_unplaced,[columnfilter(1,[lf_range(Id,Id)])]).
  open_status_after(Id):-
	Id1 = Id - 10000,
	ef_form_Create(con_needs,[columnfilter(1,[lf_range(Id1,Id1)])]). % Customer

  % LOCAL predicates
/**************************************************************************
	Creation of the popup menus (depending upon current selection)
**************************************************************************/
predicates
  get_view_permissions(ULONGLIST Marker,BOOLEAN)
  get_edit_permissions(ULONGLIST Marker,BOOLEAN,BOOLEAN)

clauses
  create_popup(Marker,1,MenuList):-		% Mode:  View
	get_view_permissions(Marker,A),
	Menulist = [
		txt(mvmenu_zoomin_obj_id,  mvmenu_zoomin_obj_txt,  0,b_true,mis_None,[]),
		txt(mvmenu_zoomout_obj_id, mvmenu_zoomout_obj_txt, 0,b_true,mis_None,[]),
		separator,
		txt(mvmenu_before_id,      mvmenu_before_txt,      0,A,mis_None,[]),
		txt(mvmenu_deliveries_id,  mvmenu_deliveries_txt,  0,A,mis_None,[]),
		txt(mvmenu_after_id,       mvmenu_after_txt,       0,A,mis_None,[]),
		separator,
		txt(mvmenu_sorts_id,       mvmenu_sorts_txt,       0,b_true,mis_None,[])
		   ],!.
  create_popup(Marker,2,MenuList):-	% Mode:  Edit
	get_edit_permissions(Marker,A3,A4),
	Menulist = [
		txt(mvmenu_add_manufacturer_id, mvmenu_add_manufacturer_txt, 0,b_true,mis_None,[]),
		txt(mvmenu_add_customer_id,     mvmenu_add_customer_txt,     0,b_true,mis_None,[]),
		txt(mvmenu_move_id,             mvmenu_move_txt,             0,A3,    mis_None,[]),
		txt(mvmenu_delete_id,           mvmenu_delete_txt,           0,A4,    mis_None,[])
		   ],!.

  create_popup(_,_,[]):-errorexit().

  get_view_permissions([],b_false):-!.	% Nothing is marked
  get_view_permissions(_,b_true).	% Something is marked

  get_edit_permissions([],b_false,b_false):-!.
  get_edit_permissions([_],b_true,b_true):-!.
  get_edit_permissions(_,b_false,b_true):-!.


clauses
  % Display map foreground objects
  mv_display_foreground_objects(Win,ObjectSize):-	% Manufacturers
	tr_db_producer(Id,Name,_,X,Y),
	  X > 0, Y > 0,
	  mapctrl_AddObjects(Win,[circle(Id,pnt(X,Y),ObjectSize,pen(1,ps_Solid,color_Black),brush(pat_Solid,0x40FF00),
				       label(pnt(10,-20),Name,ff_Helvetica,[fs_Bold],ObjectSize,color_Black))]),
	fail.
  mv_display_foreground_objects(Win,ObjectSize):-	% Customers
	tr_db_customer(Id,Name,_,X,Y),
	  X > 0, Y > 0,
	  Id1 = Id + 10000,
	  mapctrl_AddObjects(Win,[circle(Id1,pnt(X,Y),ObjectSize,pen(1,ps_Solid,color_Black),brush(pat_Solid,color_red),
				       label(pnt(10,-20),Name,ff_Helvetica,[fs_Bold],ObjectSize,color_Black))]),
	fail.
  mv_display_foreground_objects(Win,_):-	% Sorts
	mode(_,Mode), Mode = 1, % View
	tr_db_sort(SortId,_,_,Draw,Color),
	  Draw = b_true,
	  move(SortId,FromId,ToId,_),
	    tr_db_producer(FromId,_,_,FromX,FromY),
	    FromX > 0, FromY > 0,
	    tr_db_customer(ToId,_,_,ToX,ToY),
	    ToX > 0, ToY > 0,
	    mapctrl_AddObjects(Win,[arrow(777,pnt(FromX,FromY),pnt(ToX,ToY),pen(1,ps_Solid,Color),nolabel)]),
	fail.
  mv_display_foreground_objects(_,_).

  % Remove marked objects from map
  mv_remove_objects([]):-!.
  mv_remove_objects([Id|Rest]):-
	Id < 10000,		% Manufacturer
	retract(tr_db_producer(Id,Name,Comm,_,_)),!,
	assert(tr_db_producer(Id,Name,Comm,0,0)),
	mv_remove_objects(Rest).
  mv_remove_objects([Id|Rest]):-
	Id1 = Id - 10000,
	retract(tr_db_customer(Id1,Name,Comm,_,_)),!,
	assert(tr_db_customer(Id1,Name,Comm,0,0)),
	mv_remove_objects(Rest).
  mv_remove_objects(_):-errorexit.

  % Move marked object to another location
  mv_move_object(Win,Id,X,Y):-
	Id < 10000,		% Manufacturer
	retract(tr_db_producer(Id,Name,Comm,_,_)),!,
	assert(tr_db_producer(Id,Name,Comm,X,Y)),
	mapctrl_RemoveObjects(Win,[Id]),
	get_fgobject_size(ObjectSize),
	mapctrl_AddObjects(Win,[circle(Id,pnt(X,Y),ObjectSize,pen(1,ps_Solid,color_Black),brush(pat_Solid,0x40FF00),
				       label(pnt(10,-20),Name,ff_Helvetica,[fs_Bold],ObjectSize,color_Black))]).
  mv_move_object(Win,Id,X,Y):-
	Id1 = Id - 10000,		% Customer
	retract(tr_db_customer(Id1,Name,Comm,_,_)),!,
	assert(tr_db_customer(Id1,Name,Comm,X,Y)),
	mapctrl_RemoveObjects(Win,[Id]),
	get_fgobject_size(ObjectSize),
	mapctrl_AddObjects(Win,[circle(Id,pnt(X,Y),ObjectSize,pen(1,ps_Solid,color_Black),brush(pat_Solid,color_Red),
				       label(pnt(10,-20),Name,ff_Helvetica,[fs_Bold],ObjectSize,color_Black))]).
  mv_move_object(_,_,_,_):-errorexit.

  % Small utility predicates
  get_mapwin_initial_rct(Rct):-
	ini_map_layout(Rct,_,_),!.
  get_mapwin_initial_rct(rct(30,30,430,430)).

  get_mapwin_initial_mapscale(MapScale):-
	ini_map_layout(_,MapScale,_),!.
  get_mapwin_initial_mapscale(mapscale(pnt(1000,1000),60)).

  get_fgobject_size(ObjectSize):-
	ini_fgobject_size(ObjectSize),!.
  get_fgobject_size(mv_object_size).

  check_not_empty(mvmenu_add_manufacturer_id,[]):-
	dlg_Error(mv_error_add_manufacturer_txt),!,fail.
  check_not_empty(mvmenu_add_customer_id,[]):-
	dlg_Error(mv_error_add_customer_txt),!,fail.
  check_not_empty(_,_).

  mv_member_index(S,[S|_],1):-!.
  mv_member_index(S,[_|L],M):-
	bound(M),!,
	N = M - 1,
	mv_member_index(S,L,N),!.
  mv_member_index(S,[_|L],M):-
	mv_member_index(S,L,N),!,
	M = N + 1.

  check_empty_marker([]):-!,
	dlg_Error(mv_delete_error),fail.
  check_empty_marker(_).

