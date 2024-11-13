/******************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S 

 FileName:	MAPCTRL.PRO
 PURPOSE:	Map viewer/editor custom contol
 Written by:	Alexander Butovsky
 Version:	1.0
 Build:		008.981112
 Tested with:   Visual Prolog v.5.1 build 555a
 Comments:	

******************************************************************************/

constants
  development_mode = 1
  % arrow_type_special = 1	% Comment this line to see 'normal' arrow

  % Control Ids
  hor_sc_id = 3430
  ver_sc_id = 3431
  pushb_id  = 3432

  line_marking_zone = 4
  max_int = 32767
  max_intR = 32767.0

  scale_limit = 0.01

  min_zoom_area = 5
  escape_key = 27

  %**************************
  % Popup menu Ids
  %**************************
  zoomin_id = 		4430
  zoomout_id = 		4431

  menu_addobj = 	7301
  menu_editobj = 	7302
  menu_removeobj = 	7303

  menu_poligon = 	7320
  menu_circle =		7321
  menu_arrow =		7322
  menu_bitmap =		7323
  menu_savemap =	7324


database - mapctrl
  mapctrl_info(WINDOW		MapctrlWin,
	       COLOR		BgColor,
	       MAPCTRL_MODE	ViewOrEdit,
	       MAPCTRL_MAPSCALE MapScale,
	       MAPCTRL_CALLBACK CallbackFunc)
  mapctrl_sensitive_rct_area(WINDOW	MapctrlWin,
			     ULONG	ObjectId,
			     RCT	SensitiveArea)
  mapctrl_sensitive_line_area(WINDOW	MapctrlWin,
			      ULONG	ObjectId,
			      PNT	LineSensitiveAreaFrom,
			      PNT	LineSensitiveAreaTo)

  mapctrl_bg_object(WINDOW,MAPCTRL_BGOBJ)
  mapctrl_object(WINDOW,MAPCTRL_OBJ)

  mapctrl_marker(WINDOW		MapctrlWin,
		 ULONGLIST	MarkedObjectIds)
  mapctrl_zoom(PNT,PNT)

database - edit_mode_temporary
  % Edit mode temporary storage
  determ mapctrl_poligon_input(PNTLIST)
  determ mapctrl_circle_input()
  determ mapctrl_bitmap_input()
  determ mapctrl_arrow_input(PNT)

/**** global PREDICATE **********************************/
/*							*/
/* 	Map custom control initialization		*/
/*							*/
/*  mapctrl_Init(WINDOW,	% Control window	*/
/*               COLOR          % Background color      */
/*		 MAPCTRL_DATA,	% Data to show		*/
/*               MAPCTRL_MODE   % View or edit          */
/*               MAPCTRL_MAPSCALE  % Scaling factor	*/
/*               MAPCTRL_CALLBACK) % Callback           */
/*                                                      */
/* RETURN VALUE: none					*/
/* FAIL: newer fails                                    */
/*                                                      */
/********************************************************/
predicates
  procedure create_scrollbars(WINDOW,MAPCTRL_MAPSCALE,REAL)
  procedure get_right_bottom(WINDOW,INTEGER,INTEGER,INTEGER,INTEGER)
  procedure change_maping_and_scaling(WINDOW,MAPCTRL_MAPSCALE,INTEGER,INTEGER,REAL)
  procedure change_maping_and_scaling_nocheck(WINDOW,MAPCTRL_MAPSCALE,INTEGER,INTEGER,REAL)
  procedure process_input_data(WINDOW,MAPCTRL_DATA)
  procedure clear_facts(WINDOW)
  procedure mmmin(REAL,REAL,REAL)
  procedure mmmax(REAL,REAL,REAL)
  procedure mmminI(INTEGER,INTEGER,INTEGER)
  procedure mmmaxI(INTEGER,INTEGER,INTEGER)

clauses
  mapctrl_Init(Win,BgColor,Data,Mode,Scale,Callback):-
	Scale = mapscale(Pnt0,_),
	create_scrollbars(Win,Scale,CorrectedScaleFactor),
	clear_facts(Win),
	process_input_data(Win,Data),
	win_SetFocus(Win),
	assert(mapctrl_info(Win,BgColor,Mode,mapscale(Pnt0,CorrectedScaleFactor),Callback)).

  create_scrollbars(Win,Scale,CorrectedScaleFactor):-
	mapctrl_info(Win,_,_,_,_),!,			% If mapctrl is alredy initialized
	get_right_bottom(Win,R1,B1,_,_),		%  ... then change mapscale only ...
	change_maping_and_scaling(Win,Scale,R1,B1,CorrectedScaleFactor),
	win_Invalidate(Win).
  create_scrollbars(Win,Scale,CorrectedScaleFactor):-	%  ...else:
	% Create hor and vert scrollbars and pushbutton
	get_right_bottom(Win,R1,B1,R,B),
	WDef1 = wdef(wc_HScroll,rct(0,B1,R1,B),"",u_Pixels),
	WDef2 = wdef(wc_VScroll,rct(R1,0,R,B1),"",u_Pixels),
	WDef3 = wdef(wc_PushButton,rct(R1,B1,R,B),"",u_Pixels),
	win_CreateDynControl([ctl(WDef1,hor_sc_id,[]),
			      ctl(WDef2,ver_sc_id,[]),
			      ctl(WDef3,pushb_id,[])],Win),
ifndef os_os2
	% Set clip area for control protection
	win_SetClip(Win,rct(0,0,R1,B1)),
enddef
	% Set mapping and scaling for the custom control window
	change_maping_and_scaling(Win,Scale,R1,B1,CorrectedScaleFactor).

  change_maping_and_scaling(Win,Scale,R1,B1,CorrectedScaleFactor):-
	% Change mapscale
	Scale = mapscale(pnt(X0,Y0),ScaleFactor),
	X1 = X0 + R1 * ScaleFactor, Y1 = Y0 + B1 * ScaleFactor,
	mmmin(max_intR,X1,X2), mmmin(max_intR,Y1,Y2),
	X3 = val(integer,X2), Y3 = val(integer,Y2),
	Sch = (X3 - X0)/ R1, Scv = (Y3 - Y0) / B1,
	mmmin(Sch,Scv,NewScaleFactor),
	mmmax(scale_limit,NewScaleFactor,CorrectedScaleFactor),
	RSS = R1 * CorrectedScaleFactor,
	BSS = B1 * CorrectedScaleFactor,
	mmmin(max_intR,RSS,RSS1),
	mmmin(max_intR,BSS,BSS1),
	X4 = val(integer,RSS1),
	Y4 = val(integer,BSS1),
	win_SetMapMode(Win,mm_Arbitrary),
	win_SetMapScale(Win,pnt(X0,Y0),pnt(X4,Y4),pnt(0,0),pnt(R1,B1)),
	% Set scrollbars range and position
	HorScWin = win_GetCtlHandle(Win,hor_sc_id),
	VerScWin = win_GetCtlHandle(Win,ver_sc_id),
	Hrange = max_int - X4, Vrange = max_int - Y4,
	win_SetScrollRange(HorScWin,sb_Ctl,0,Hrange),
	win_SetScrollRange(VerScWin,sb_Ctl,0,Vrange),
	win_SetScrollPos(HorScWin,sb_Ctl,X0),
	win_SetScrollPos(VerScWin,sb_Ctl,Y0).

  change_maping_and_scaling_nocheck(Win,Scale,R1,B1,CorrectedScaleFactor):-
	% Change mapscale
	Scale = mapscale(pnt(X0,Y0),ScaleFactor),
	X1 = R1 * ScaleFactor, Y1 = B1 * ScaleFactor,
	mmmin(max_intR,X1,X2), mmmin(max_intR,Y1,Y2),
	X3 = val(integer,X2), Y3 = val(integer,Y2),
	Sch = X3 / R1, Scv = Y3 / B1,
	mmmin(Sch,Scv,NewScaleFactor),
	mmmax(scale_limit,NewScaleFactor,CorrectedScaleFactor),
	X4 = val(integer,R1 * CorrectedScaleFactor),
	Y4 = val(integer,B1 * CorrectedScaleFactor),
	win_SetMapMode(Win,mm_Arbitrary),
	win_SetMapScale(Win,pnt(X0,Y0),pnt(X4,Y4),pnt(0,0),pnt(R1,B1)),
	% Set scrollbars range and position
	HorScWin = win_GetCtlHandle(Win,hor_sc_id),
	VerScWin = win_GetCtlHandle(Win,ver_sc_id),
	Hrange = max_int - X4, Vrange = max_int - Y4,
	win_SetScrollRange(HorScWin,sb_Ctl,0,Hrange),
	win_SetScrollRange(VerScWin,sb_Ctl,0,Vrange),
	win_SetScrollPos(HorScWin,sb_Ctl,X0),
	win_SetScrollPos(VerScWin,sb_Ctl,Y0).

  get_right_bottom(Win,R1,B1,R,B):-
	RCT = win_GetClientRect(Win),
	RCT = rct(_,_,R,B),
	B1 = B - vpi_GetAttrVal(attr_ctl_horz_sbar_height),
	R1 = R - vpi_GetAttrVal(attr_ctl_vert_sbar_width).


  %----------- Process map control input data -------
predicates
  procedure read_objects(WINDOW,MAPCTRL_OBJLIST,MAPCTRL_OBJLIST)
  procedure add_to_list(WINDOW,STRING,MAPCTRL_OBJLIST,MAPCTRL_OBJLIST)
  procedure list_reverse(MAPCTRL_OBJLIST,MAPCTRL_OBJLIST,MAPCTRL_OBJLIST)
  procedure list_reverse(PNTLIST,PNTLIST,PNTLIST)
  procedure assert_bg_objects(WINDOW,MAPCTRL_BGOBJLIST)
  procedure assert_objects(WINDOW,MAPCTRL_OBJLIST)
  procedure assert_sensitive_areas(WINDOW,MAPCTRL_OBJLIST)
  procedure recalc_pntlist(PNT,PNTLIST,PNTLIST)
  procedure calc_area(PNTLIST,INTEGER,INTEGER,INTEGER,INTEGER,INTEGER,INTEGER,INTEGER,INTEGER)

clauses
  %---- Dynamic data -----
  process_input_data(Win,Data):-
	Data = data(BgList,FgList),!,
	assert_bg_objects(Win,BgList),
	assert_objects(Win,FgList),
	assert_sensitive_areas(Win,FgList).
  %---- Data from file -----
  process_input_data(Win,Data):-
	Data = filename(Filename),
	trap(openread(mapdata,Filename),_,fail),
	readdevice(mapdata),
	read_objects(Win,[],FgList),
	readdevice(keyboard),
	closefile(mapdata),!,
	assert_sensitive_areas(Win,FgList).
ifdef development_mode
  process_input_data(_,_):-
	write("Error reading input data file.\n").
elsedef
  process_input_data(_,_).
enddef

  assert_bg_objects(_,[]):-!.
  assert_bg_objects(Win,[Obj|Rest]):-
	assert(mapctrl_bg_object(Win,Obj)),
	assert_bg_objects(Win,Rest), !.
  assert_bg_objects(_,_):-errorexit().

  assert_objects(_,[]):-!.
  assert_objects(Win,[Obj|Rest]):-
	assert(mapctrl_object(Win,Obj)),
	assert_objects(Win,Rest), !.
  assert_objects(_,_):-errorexit().

  %------- Read objects from disk file --------
  read_objects(Win,FgList,FgListOut):-
	readln(Str),!,
	add_to_list(Win,Str,FgList,FgList1),
	read_objects(Win,FgList1,FgListOut).
  read_objects(_,FgList,FgListR):-
	list_reverse(FgList,[],FgListR).

  % Skip empty strings
  add_to_list(_,"",FgList,FgList):-!.
  % Skip comment lines
  add_to_list(_,Str,FgList,FgList):-
	fronttoken(Str,";",_),!.
  % If Str can be converted into bg object then assert fact
  add_to_list(Win,Str,FgList,FgList):-
	trap(term_str(mapctrl_bgobj,Term,Str),_,fail),!,
	assert(mapctrl_bg_object(Win,Term)).

  % ...else Str can be converted into fg object - add Term to FgList
  add_to_list(Win,Str,FgList,[Term|FgList]):-
	trap(term_str(mapctrl_obj,Term,Str),_,fail),!,
	assert(mapctrl_object(Win,Term)).
ifdef development_mode
  add_to_list(_,Str,FgList,FgList):-
	write("Invalid map data: ",Str,"\n").
elsedef
  add_to_list(_,_,FgList,FgList).
enddef

  %----------- Assert facts about foreground object sensitive areas -------
  %+++ Foreground Polygon
  assert_sensitive_areas(Win,[polygon(Id,Pnt,PntList,_,_,_)|Rest]):-!,
	recalc_pntlist(Pnt,PntList,AbsPntList),
	calc_area(AbsPntList,max_int,max_int,0,0,L,T,R,B),
	assert(mapctrl_sensitive_rct_area(Win,Id,rct(L,T,R,B))),
	assert_sensitive_areas(Win,Rest).
  %+++ Foreground Circle
  assert_sensitive_areas(Win,[circle(Id,Pnt,Diam,_,_,_)|Rest]):-!,
	Pnt = pnt(X,Y), Radius = Diam div 2,
	L = X - Radius, T = Y - Radius,
	R = X + Radius, B = Y + Radius,
	assert(mapctrl_sensitive_rct_area(Win,Id,rct(L,T,R,B))),!,
	assert_sensitive_areas(Win,Rest).
  %+++ Foreground Bitmap
  assert_sensitive_areas(Win,[bitmap(Id,Pnt,FileName,_,_)|Rest]):-
	trap(Picture = pict_Load(FileName),_,fail),!,
	pict_GetSize(Picture,Width,Height,_),
	pict_Destroy(Picture),
	Pnt = pnt(L,T),
	R = L + Width, B = T + Height,
	assert(mapctrl_sensitive_rct_area(Win,Id,rct(L,T,R,B))),
	assert_sensitive_areas(Win,Rest).
  assert_sensitive_areas(Win,[bitmap(_,_,_,_,_)|Rest]):-!,
	assert_sensitive_areas(Win,Rest).
  %+++ Foreground Picture
  assert_sensitive_areas(Win,[picture(Id,Pnt,Picture,_,_)|Rest]):-!,
	pict_GetSize(Picture,Width,Height,_),
	Pnt = pnt(L,T),
	R = L + Width, B = T + Height,
	assert(mapctrl_sensitive_rct_area(Win,Id,rct(L,T,R,B))),
	assert_sensitive_areas(Win,Rest).
  %+++ Foreground Arrow
  assert_sensitive_areas(Win,[arrow(Id,PntFrom,PntTo,_,_)|Rest]):-!,
	assert(mapctrl_sensitive_line_area(Win,Id,PntFrom,PntTo)),
	assert_sensitive_areas(Win,Rest).

  assert_sensitive_areas(_,_).

  calc_area([pnt(X,Y)|Rest],L0,T0,R0,B0,L,T,R,B):-
	mmminI(X,L0,L1), mmminI(Y,T0,T1),
	mmmaxI(X,R0,R1), mmmaxI(Y,B0,B1),!,
	calc_area(Rest,L1,T1,R1,B1,L,T,R,B).
  calc_area([],L,T,R,B,L,T,R,B):-!.
  calc_area(_,L,T,R,B,L,T,R,B):-errorexit().

/**** global PREDICATE **********************************/
/*							*/
/* 	Map custom control event handling		*/
/*							*/
/*  Put mapctrl_HandleEvent call into the clause for all*/
/*  events (except for e_Create) of the class handler	*/
/*							*/
/*  mapctrl_HandleEvent(WINDOW,	% Control window	*/
/*		 	EVENT)	% Event			*/
/*                                                      */
/********************************************************/
predicates
  procedure draw_objects(WINDOW)
  procedure draw_markers(WINDOW,ULONGLIST)
  determ    check_pnt(WINDOW,PNT,ULONG ObjectId)
  determ    point_close_to_line(REAL,PNT,PNT,PNT)
  procedure get_marker(WINDOW,ULONGLIST)
  procedure unmark_objects(WINDOW,MAPCTRL_CALLBACK,ULONGLIST)
  determ mmmember(ULONG,ULONGLIST)
  determ mmmember(WSFLAG,WSFLAGS)
  procedure MENU_ITEM_LIST build_popup_menulist(MENU_ITEM_LIST,INTEGER)
  procedure scroll_right(WINDOW,WINDOW,REAL)
  procedure scroll_left(WINDOW,WINDOW,REAL)
  procedure scroll_down(WINDOW,WINDOW,REAL)
  procedure scroll_up(WINDOW,WINDOW,REAL)
  procedure move_org_point(WINDOW,REAL,PNT,INTEGER,INTEGER)
  procedure lllistlength(MENU_ITEM_LIST,INTEGER)
  procedure lllistlength(PNTLIST,INTEGER)
  procedure wwwin_SetFocus(WINDOW)
  procedure calc_relative_points(PNT,PNTLIST,PNTLIST)
  procedure new_Id(WINDOW,ULONG,ULONG)
  procedure dlg_properties_Create(WINDOW ParentWin,ULONG ObjectId)
  procedure allowed_items(ULONGLIST MarkerList,BOOLEAN EditAllowed,BOOLEAN RemoveAllowed)

clauses
  %+++++++ e_Update
  mapctrl_HandleEvent(Win,e_Update(_)):-
	mapctrl_info(Win,BgColor,_,_,_),!,
	OldCursor = cursor_Get(Win),
	cursor_SetWait(),
	win_SetDrawMode(Win,dm_CopyPen),
	win_Clear(Win,BgColor),
	draw_objects(Win),
	get_marker(Win,MarkerList),
	draw_markers(Win,MarkerList),
	cursor_Set(Win,OldCursor).
  %+++++++ e_EraseBackground
  mapctrl_HandleEvent(_,e_EraseBackground()):-!.

  %+++++++ e_State
  mapctrl_HandleEvent(_,e_State(_)):-!,fail.

  %+++++++ send all other events to application
  mapctrl_HandleEvent(Win,Event):-
	mapctrl_info(Win,_,_,_,Callback),
	Callback(Win,event(Event)),!.	% If callback ends with true then stop handling the event!

  %+++++++ e_MouseDown
  mapctrl_HandleEvent(Win,e_MouseDown(Pnt0,c_Nothing,mouse_button_left)):-	% Left mouse button - polygon input
	retract(mapctrl_poligon_input(OldPntList)),!,				% in edit mode
	Pnt0 = pnt(X0,Y0),
	mmmaxI(X0,0,X1), mmminI(X1,max_int,X2),
	mmmaxI(Y0,0,Y1), mmminI(Y1,max_int,Y2),
	PntList = win_DPtoLP(Win,[pnt(X2,Y2)]),
	PntList = [Pnt],
	assert(mapctrl_poligon_input([Pnt|OldPntList])).

  mapctrl_HandleEvent(Win,e_MouseDown(Pnt0,c_Nothing,mouse_button_left)):-	% Left mouse button - circle input
	retract(mapctrl_circle_input()),!,					% in edit mode
	win_ReleaseMouse(),
	cursor_Set(Win,cursor_Arrow),
	Pnt0 = pnt(X0,Y0),
	mmmaxI(X0,0,X1), mmminI(X1,max_int,X2),
	mmmaxI(Y0,0,Y1), mmminI(Y1,max_int,Y2),
	PntList = win_DPtoLP(Win,[pnt(X2,Y2)]),
	PntList = [Pnt],
	% generate idle Id
	new_Id(Win,1,Id),
	% calculate label font size
	mapctrl_info(Win,_,_,Scale,_),!,
	Scale = mapscale(_,ScaleFactor),
	FontSize = val(integer,ScaleFactor * 6),
	% calculate label position
	Dx = val(integer,ScaleFactor * 10),
	Dy = val(integer,ScaleFactor * -5),
	Diam = val(integer,ScaleFactor * 10),
	mapctrl_AddObjects(Win,[circle(Id,Pnt,Diam,
					pen(1,ps_Solid,color_Black),
					brush(pat_Solid,color_White),
					label(pnt(Dx,Dy),circle_label,ff_Helvetica,[fs_Bold],FontSize,color_Blue))]).

  mapctrl_HandleEvent(Win,e_MouseDown(Pnt0,c_Nothing,mouse_button_left)):-	% Left mouse button - bitmap input
	retract(mapctrl_bitmap_input()),!,					% in edit mode
	win_ReleaseMouse(),
	cursor_Set(Win,cursor_Arrow),
	Pnt0 = pnt(X0,Y0),
	mmmaxI(X0,0,X1), mmminI(X1,max_int,X2),
	mmmaxI(Y0,0,Y1), mmminI(Y1,max_int,Y2),
	PntList = win_DPtoLP(Win,[pnt(X2,Y2)]),
	PntList = [Pnt],
	% generate idle Id
	new_Id(Win,1,Id),
	% calculate label font size
	mapctrl_info(Win,_,_,Scale,_),!,
	Scale = mapscale(_,ScaleFactor),
	FontSize = val(integer,ScaleFactor * 6),
	% calculate label position
	Dx = val(integer,ScaleFactor * 10),
	Dy = val(integer,ScaleFactor * -5),
	% get bitmap filename
	FileName = dlg_GetOpenFileName("*.bmp",[bitmap_select_text,"*.bmp"],bitmap_select_title),
	not(FileName = ""),
	mapctrl_AddObjects(Win,[bitmap(Id,Pnt,FileName,
					rop_SrcCopy,
					label(pnt(Dx,Dy),bitmap_label,ff_Helvetica,[fs_Bold],FontSize,color_Blue))]).

  mapctrl_HandleEvent(Win,e_MouseDown(_,c_Nothing,mouse_button_right)):-	% Right mouse button - end polygon input
	retract(mapctrl_poligon_input(PntList0)),!,				% in edit mode
	win_ReleaseMouse(),
	cursor_Set(Win,cursor_Arrow),
	lllistlength(PntList0,L), L > 2,
	% calculate list of polygon's vertices
	list_reverse(PntList0,[],PntList),
	PntList = [Pnt0|_],
	calc_relative_points(Pnt0,PntList,OutList),
	% generate idle Id
	new_Id(Win,1,Id),
	% calculate label font size
	mapctrl_info(Win,_,_,Scale,_),!,
	Scale = mapscale(_,ScaleFactor),
	FontSize = val(integer,ScaleFactor * 6),
	% calculate label position
	Dx = val(integer,ScaleFactor * 10),
	Dy = val(integer,ScaleFactor * -5),
	mapctrl_AddObjects(Win,[polygon(Id,Pnt0,OutList,
					pen(1,ps_Solid,color_Black),
					brush(pat_Solid,color_White),
					label(pnt(Dx,Dy),polygon_label,ff_Helvetica,[fs_Bold],FontSize,color_Blue))]).

  mapctrl_HandleEvent(Win,e_MouseDown(_,_,mouse_button_right)):-	% Right mouse button - terminate circle input
	retract(mapctrl_circle_input()),!,				% in edit mode
	win_ReleaseMouse(),
	cursor_Set(Win,cursor_Arrow).
  mapctrl_HandleEvent(Win,e_MouseDown(_,_,mouse_button_right)):-	% Right mouse button - terminate bitmap input
	retract(mapctrl_bitmap_input()),!,				% in edit mode
	win_ReleaseMouse(),
	cursor_Set(Win,cursor_Arrow).
  mapctrl_HandleEvent(Win,e_MouseDown(_,_,mouse_button_right)):-	% Right mouse button - terminate arrow input
	retract(mapctrl_arrow_input(_)),!,				% in edit mode
	win_ReleaseMouse(),
	cursor_Set(Win,cursor_Arrow).

  mapctrl_HandleEvent(Win,e_MouseDown(Pnt0,c_Nothing,mouse_button_left)):-	% Left mouse button - arrow input 1st click
	retract(mapctrl_arrow_input(pnt(-1,-1))),!,				% in edit mode
	Pnt0 = pnt(X0,Y0),
	mmmaxI(X0,0,X1), mmminI(X1,max_int,X2),
	mmmaxI(Y0,0,Y1), mmminI(Y1,max_int,Y2),
	PntList = win_DPtoLP(Win,[pnt(X2,Y2)]),
	PntList = [Pnt],
	assert(mapctrl_arrow_input(Pnt)).
  mapctrl_HandleEvent(Win,e_MouseDown(Pnt1,c_Nothing,mouse_button_left)):-	% Left mouse button - arrow input 2nd click
	retract(mapctrl_arrow_input(From)),!,					% in edit mode
	win_ReleaseMouse(),
	cursor_Set(Win,cursor_Arrow),
	Pnt1 = pnt(X1,Y1),
	mmmaxI(X1,0,X2), mmminI(X2,max_int,X3),
	mmmaxI(Y1,0,Y2), mmminI(Y2,max_int,Y3),
	PntList = win_DPtoLP(Win,[pnt(X3,Y3)]),
	PntList = [To],
	% generate idle Id
	new_Id(Win,1,Id),
	% calculate label font size
	mapctrl_info(Win,_,_,Scale,_),!,
	Scale = mapscale(_,ScaleFactor),
	FontSize = val(integer,ScaleFactor * 6),
	% calculate label position
	Dx = val(integer,ScaleFactor * 10),
	Dy = val(integer,ScaleFactor * -5),
	mapctrl_AddObjects(Win,[arrow(Id,From,To,
					pen(1,ps_Solid,color_Black),
					label(pnt(Dx,Dy),arrow_label,ff_Helvetica,[fs_Bold],FontSize,color_Blue))]).

  mapctrl_HandleEvent(Win,e_MouseDown(Pnt0,c_Nothing,mouse_button_left)):-	% Left mouse button inside
	PntList = win_DPtoLP(Win,[Pnt0]),					%  foreground object -
	PntList = [Pnt],							%  - mark object
	check_pnt(Win,Pnt,Id),
	get_marker(Win,OldMarkerList),
	mapctrl_info(Win,_,_,_,Callback),!,
	not(OldMarkerList = [Id]),
	unmark_objects(Win,Callback,OldMarkerList),
	not(Callback(Win,action(marker([Id],b_true)))),
	draw_markers(Win,[Id]),
	assert(mapctrl_marker(Win,[Id])).

  mapctrl_HandleEvent(Win,e_MouseDown(Pnt0,c_Control,mouse_button_left)):-	% Ctrl + Left mouse button
	PntList = win_DPtoLP(Win,[Pnt0]),					%  inside foreground object
	PntList = [Pnt],
	check_pnt(Win,Pnt,Id),	
	get_marker(Win,OldMarkerList),
	mapctrl_info(Win,_,_,_,Callback),!,
	not(mmmember(Id,OldMarkerList)),
	unmark_objects(Win,Callback,OldMarkerList),
	not(Callback(Win,action(marker([Id|OldMarkerList],b_true)))),
	draw_markers(Win,[Id|OldMarkerList]),
	assert(mapctrl_marker(Win,[Id|OldMarkerList])).

  mapctrl_HandleEvent(Win,e_MouseDown(Pnt0,_,mouse_button_left)):-		% Left mouse button outside
	PntList = win_DPtoLP(Win,[Pnt0]),					%  foreground object -
	PntList = [Pnt],							%  - remove markers, start
	get_marker(Win,OldMarkerList),						%  drawing zoom area border
	mapctrl_info(Win,_,_,_,Callback),!,
	unmark_objects(Win,Callback,OldMarkerList),
	win_CaptureMouse(Win),
	retractall(mapctrl_zoom(_,_)),
	assert(mapctrl_zoom(Pnt,Pnt)).

  mapctrl_HandleEvent(Win,e_MouseDown(Pnt0,_,mouse_button_right)):-		% Right mouse button in View mode -
	mapctrl_info(Win,_,Mode,_,_),						%  - invoke application popup menu
	Mode = view(ApplicationMenuItemList),!,
	MenuItemList = build_popup_menulist(ApplicationMenuItemList,_),
	menu_PopUp(Win,dyn_menu(MenuItemList),Pnt0,align_Left).

  mapctrl_HandleEvent(Win,e_MouseDown(Pnt0,_,mouse_button_right)):-		% Right mouse button in Edit mode -
	mapctrl_info(Win,_,Mode,_,_),						%  - invoke editor popup menu
	Mode = edit(),!,
	get_marker(Win,MarkerList),
	allowed_items(MarkerList,EditAllowed,RemoveAllowed),
	MenuSubList =  [txt(menu_poligon,  menu_poligon_text,  0,b_true,mis_None,[]),
			txt(menu_circle,   menu_circle_text,   0,b_true,mis_None,[]),
			txt(menu_arrow,    menu_arrow_text,    0,b_true,mis_None,[]),
			txt(menu_bitmap,   menu_bitmap_text,   0,b_true,mis_None,[])],
	MenuItemList = [txt(menu_addobj,   menu_addobj_text,   0,b_true,mis_None,MenuSubList),
			txt(menu_editobj,  menu_editobj_text,  0,EditAllowed,mis_None,[]),
			txt(menu_removeobj,menu_removeobj_text,0,RemoveAllowed,mis_None,[]),
			separator,
			txt(menu_savemap,  menu_savemap_text,  0,b_true,mis_None,[])],
	menu_PopUp(Win,dyn_menu(MenuItemList),Pnt0,align_Left).

  %+++++++ e_MouseMove
  mapctrl_HandleEvent(Win,e_MouseMove(Pnt0,c_Nothing,_)):-	% Dragging zoom area border
	retract(mapctrl_zoom(pnt(X1,Y1),pnt(X2,Y2))),!,
	get_right_bottom(Win,Width,Height,_,_),
	Pnt0 = pnt(X0,Y0),
	mmminI(X0,Width,X0i), mmminI(Y0,Height,Y0i),
	mmmaxI(X0i,0,X0m), mmmaxI(Y0i,0,Y0m),
	PntList = win_DPtoLP(Win,[pnt(X0m,Y0m)]),
	PntList = [pnt(X3,Y3)],
	win_SetPen(Win,pen(1,ps_Dot,color_White)),
	win_SetBrush(Win,brush(pat_Hollow,color_Blue)),
	win_SetDrawMode(Win,dm_XorPen),
	draw_Rect(Win,rct(X1,Y1,X2,Y2)),
	draw_Rect(Win,rct(X1,Y1,X3,Y3)),
	assert(mapctrl_zoom(pnt(X1,Y1),pnt(X3,Y3))).
	
  %+++++++ e_MouseUp
  mapctrl_HandleEvent(Win,e_MouseUp(Pnt,c_Nothing,mouse_button_left)):-	% Dragging zoom area border
	retract(mapctrl_zoom(pnt(Xo1,Yo1),pnt(Xo2,Yo2))),
	win_ReleaseMouse(),
	win_SetPen(Win,pen(1,ps_Dot,color_White)),
	win_SetBrush(Win,brush(pat_Hollow,color_Blue)),
	win_SetDrawMode(Win,dm_XorPen),
	draw_Rect(Win,rct(Xo1,Yo1,Xo2,Yo2)),
	PntList1 = win_LPtoDP(Win,[pnt(Xo1,Yo1)]),
	PntList1 = [pnt(Xw1,Yw1)],
	Pnt = pnt(Xm,Ym),
	mmminI(Xw1,Xm,X1), mmminI(Yw1,Ym,Y1),
	mmmaxI(Xw1,Xm,X2), mmmaxI(Yw1,Ym,Y2),
	X2 - X1 > min_zoom_area, Y2 - Y1 > min_zoom_area,
	retract(mapctrl_info(Win,Color,Mode,Scale,Callback)),!,
	Scale = mapscale(_,OldScaleFactor),
	get_right_bottom(Win,R1,B1,_,_),
	Vsc = (Y2 - Y1)*OldScaleFactor/B1,
	Hsc = (X2 - X1)*OldScaleFactor/R1,
	mmmax(Vsc,Hsc,NewScaleFactor),
	PntList2 = win_DPtoLP(Win,[pnt(X1,Y1)]),
	PntList2 = [pnt(X0,Y0)],
	change_maping_and_scaling(Win,mapscale(pnt(X0,Y0),NewScaleFactor),R1,B1,_),
	assert(mapctrl_info(Win,Color,Mode,mapscale(pnt(X0,Y0),NewScaleFactor),Callback)),
	win_Invalidate(Win),
	wwwin_SetFocus(Win).
	
  %+++++++ e_MouseDbl
  mapctrl_HandleEvent(Win,e_MouseDbl(Pnt0,c_Nothing,mouse_button_left)):-	% Left mouse button double click 
	PntList = win_DPtoLP(Win,[Pnt0]),					%  inside foreground object -
	PntList = [Pnt],							%  - send notification
	check_pnt(Win,Pnt,Id),
	mapctrl_info(Win,_,_,_,Callback),!,
	Callback(Win,action(double_click(Id))).

  %+++++++ e_Control
  mapctrl_HandleEvent(Win,e_Control(hor_sc_id,_,HorScWin,scroll(sc_LineDown,_))):-!,	% Hor scrollbar - line right
	scroll_right(Win,HorScWin,0.3333333).
  mapctrl_HandleEvent(Win,e_Control(hor_sc_id,_,HorScWin,scroll(sc_PageDown,_))):-	% Hor scrollbar - page right
	scroll_right(Win,HorScWin,1.0).
  mapctrl_HandleEvent(Win,e_Control(hor_sc_id,_,HorScWin,scroll(sc_LineUp,_))):-	% Hor scrollbar - line left
	scroll_left(Win,HorScWin,0.3333333).
  mapctrl_HandleEvent(Win,e_Control(hor_sc_id,_,HorScWin,scroll(sc_PageUp,_))):-	% Hor scrollbar - page left
	scroll_left(Win,HorScWin,1.0).
  mapctrl_HandleEvent(Win,e_Control(ver_sc_id,_,VerScWin,scroll(sc_LineDown,_))):-	% Vert scrollbar - line down
	scroll_down(Win,VerScWin,0.3333333).
  mapctrl_HandleEvent(Win,e_Control(ver_sc_id,_,VerScWin,scroll(sc_PageDown,_))):-	% Vert scrollbar - page down
	scroll_down(Win,VerScWin,1.0).
  mapctrl_HandleEvent(Win,e_Control(ver_sc_id,_,VerScWin,scroll(sc_LineUp,_))):-	% Vert scrollbar - line up
	scroll_up(Win,VerScWin,0.3333333).
  mapctrl_HandleEvent(Win,e_Control(ver_sc_id,_,VerScWin,scroll(sc_PageUp,_))):-	% Vert scrollbar - page up
	scroll_up(Win,VerScWin,1.0).

  mapctrl_HandleEvent(Win,e_Control(hor_sc_id,_,HorScWin,scroll(sc_Thumb,X1))):-	% Hor scrollbar - Thumb right
	mapctrl_info(Win,_,_,Scale,_),
	Scale = mapscale(pnt(X0,_),ScaleFactor),
	X1 > X0,!,
	get_right_bottom(Win,R1,_,_,_),
	ScrollValue = (X1 - X0) / R1 / ScaleFactor,
	scroll_right(Win,HorScWin,ScrollValue).
  mapctrl_HandleEvent(Win,e_Control(hor_sc_id,_,HorScWin,scroll(sc_Thumb,X1))):-	% Hor scrollbar - Thumb right
	mapctrl_info(Win,_,_,Scale,_),
	Scale = mapscale(pnt(X0,_),ScaleFactor),
	X1 < X0,!,
	get_right_bottom(Win,R1,_,_,_),
	ScrollValue = (X0 - X1) / R1 / ScaleFactor,
	scroll_left(Win,HorScWin,ScrollValue).

  mapctrl_HandleEvent(Win,e_Control(ver_sc_id,_,VerScWin,scroll(sc_Thumb,Y1))):-	% Ver scrollbar - Thumb down
	mapctrl_info(Win,_,_,Scale,_),
	Scale = mapscale(pnt(_,Y0),ScaleFactor),
	Y1 > Y0,!,
	get_right_bottom(Win,_,B1,_,_),
	ScrollValue = (Y1 - Y0) / B1 / ScaleFactor,
	scroll_down(Win,VerScWin,ScrollValue).
  mapctrl_HandleEvent(Win,e_Control(ver_sc_id,_,VerScWin,scroll(sc_Thumb,Y1))):-	% Ver scrollbar - Thumb up
	mapctrl_info(Win,_,_,Scale,_),
	Scale = mapscale(pnt(_,Y0),ScaleFactor),
	Y1 < Y0,!,
	get_right_bottom(Win,_,B1,_,_),
	ScrollValue = (Y0 - Y1) / B1 / ScaleFactor,
	scroll_up(Win,VerScWin,ScrollValue).

  mapctrl_HandleEvent(Win,e_Control(pushb_id,_,_,activated)):-	% Pushbutton (view mode)
	mapctrl_info(Win,_,Mode,_,_),
	Mode = view(ApplicationMenuItemList),!,
	get_right_bottom(Win,R1,B1,_,_),
	MenuItemList = build_popup_menulist(ApplicationMenuItemList,N),
	Y = B1 - 14 * N + 4,
	menu_PopUp(Win,dyn_menu(MenuItemList),pnt(R1,Y),align_Right).
  mapctrl_HandleEvent(Win,e_Control(pushb_id,_,_,activated)):-!,	% Pushbutton (edit mode)
	get_right_bottom(Win,R1,B1,_,_),
	MenuItemList = build_popup_menulist([],N),
	Y = B1 - 14 * N + 4,
	menu_PopUp(Win,dyn_menu(MenuItemList),pnt(R1,Y),align_Right).
	
  %+++++++ e_Menu
  mapctrl_HandleEvent(Win,e_Menu(zoomin_id,_SCA)):-			% Zoom in
	retract(mapctrl_info(Win,Color,Mode,Scale,Callback)),!,
	Scale = mapscale(Pnt0,OldScaleFactor),
	get_right_bottom(Win,R1,B1,_,_),
	NewScaleFactor = OldScaleFactor / 1.5,
	change_maping_and_scaling(Win,mapscale(Pnt0,NewScaleFactor),R1,B1,CorrectedScaleFactor),
	assert(mapctrl_info(Win,Color,Mode,mapscale(Pnt0,CorrectedScaleFactor),Callback)),
	CorrectedScaleFactor < OldScaleFactor,
	win_Invalidate(Win),
	wwwin_SetFocus(Win).
  mapctrl_HandleEvent(Win,e_Menu(zoomout_id,_SCA)):-			% Zoom out
	retract(mapctrl_info(Win,Color,Mode,Scale,Callback)),!,
	Scale = mapscale(Pnt0,OldScaleFactor),
	get_right_bottom(Win,R1,B1,_,_),
	NewScaleFactor = OldScaleFactor * 1.5,
	change_maping_and_scaling_nocheck(Win,mapscale(Pnt0,NewScaleFactor),R1,B1,CorrectedScaleFactor),
	assert(mapctrl_info(Win,Color,Mode,mapscale(Pnt0,CorrectedScaleFactor),Callback)),
	CorrectedScaleFactor > OldScaleFactor,
	move_org_point(Win,CorrectedScaleFactor,Pnt0,R1,B1),
	win_Invalidate(Win),
	wwwin_SetFocus(Win).

  mapctrl_HandleEvent(Win,e_Menu(menu_poligon,_SCA)):-!,		% Edit mode - start poligon input mode
	assert(mapctrl_poligon_input([])),
	win_CaptureMouse(Win),
	cursor_Set(Win,cursor_Cross).
  mapctrl_HandleEvent(Win,e_Menu(menu_circle,_SCA)):-!,			% Edit mode - start poligon input mode
	assert(mapctrl_circle_input()),
	win_CaptureMouse(Win),
	cursor_Set(Win,cursor_Cross).
  mapctrl_HandleEvent(Win,e_Menu(menu_bitmap,_SCA)):-!,			% Edit mode - start bitmap input mode
	assert(mapctrl_bitmap_input()),
	win_CaptureMouse(Win),
	cursor_Set(Win,cursor_Cross).
  mapctrl_HandleEvent(Win,e_Menu(menu_arrow,_SCA)):-!,			% Edit mode - start arrow input mode
	assert(mapctrl_arrow_input(pnt(-1,-1))),
	win_CaptureMouse(Win),
	cursor_Set(Win,cursor_Cross).

  mapctrl_HandleEvent(Win,e_Menu(menu_editobj,_SCA)):-			% Edit mode - edit object's properties
	get_marker(Win,MarkerList),
	MarkerList = [Id],!,
	dlg_properties_Create(Win,Id).

  mapctrl_HandleEvent(Win,e_Menu(menu_removeobj,_SCA)):-!,		% Edit mode - remove marked object
	Marker = mapctrl_GetMarker(Win),
	mapctrl_RemoveObjects(Win,Marker).

  mapctrl_HandleEvent(Win,e_Menu(menu_savemap,_SCA)):-!,		% Edit mode - save map to disk
	FileName = dlg_GetSaveFileName("*.dat",[save_filename_text,"*.dat"],save_filename_title),
	not(Filename = ""),
	mapctrl_SaveData(Win,Filename).

  %+++++++ e_Char
  mapctrl_HandleEvent(Win,e_Char(32,_)):-!,		% Space  - invoke popup menu
	mapctrl_HandleEvent(Win,e_Control(pushb_id,0,Win,activated)).
  mapctrl_HandleEvent(Win,e_Char(43,c_Nothing)):-!,	% " + "  - zoom in
	mapctrl_HandleEvent(Win,e_Menu(zoomin_id,0)).
  mapctrl_HandleEvent(Win,e_Char(45,c_Nothing)):-!,	% " - "  - zoom out
	mapctrl_HandleEvent(Win,e_Menu(zoomout_id,0)).
  mapctrl_HandleEvent(Win,e_Char(k_left,_)):-!,		% Left arrow
	HorScWin = win_GetCtlHandle(Win,hor_sc_id),
	mapctrl_HandleEvent(Win,e_Control(hor_sc_id,0,HorScWin,scroll(sc_LineUp,0))).
  mapctrl_HandleEvent(Win,e_Char(k_right,_)):-!,	% Right arrow
	HorScWin = win_GetCtlHandle(Win,hor_sc_id),
	mapctrl_HandleEvent(Win,e_Control(hor_sc_id,0,HorScWin,scroll(sc_LineDown,0))).
  mapctrl_HandleEvent(Win,e_Char(k_up,_)):-!,		% Up arrow
	VerScWin = win_GetCtlHandle(Win,ver_sc_id),
	mapctrl_HandleEvent(Win,e_Control(ver_sc_id,0,VerScWin,scroll(sc_LineUp,0))).
  mapctrl_HandleEvent(Win,e_Char(k_down,_)):-!,		% Down arrow
	VerScWin = win_GetCtlHandle(Win,ver_sc_id),
	mapctrl_HandleEvent(Win,e_Control(ver_sc_id,0,VerScWin,scroll(sc_LineDown,0))).
  mapctrl_HandleEvent(Win,e_Char(k_prev,_)):-!,		% PgUp
	VerScWin = win_GetCtlHandle(Win,ver_sc_id),
	mapctrl_HandleEvent(Win,e_Control(ver_sc_id,0,VerScWin,scroll(sc_PageUp,0))).
  mapctrl_HandleEvent(Win,e_Char(k_next,_)):-!,		% PgDown
	VerScWin = win_GetCtlHandle(Win,ver_sc_id),
	mapctrl_HandleEvent(Win,e_Control(ver_sc_id,0,VerScWin,scroll(sc_PageDown,0))).

  mapctrl_HandleEvent(Win,e_Char(escape_key,_)):-!,	% Esc - terminate object input 
	retractall(mapctrl_poligon_input(_)),		% in edit mode
	retractall(mapctrl_circle_input()),
	retractall(mapctrl_bitmap_input()),
	retractall(mapctrl_arrow_input(_)),
	win_ReleaseMouse(),
	cursor_Set(Win,cursor_Arrow).

  %+++++++ e_Size
  mapctrl_HandleEvent(Win,e_Size(_,_)):-
	get_right_bottom(Win,R1,B1,R,B),
	B1>0, 
	WinState = win_GetState(Win),
	not(mmmember(wsf_Minimized,WinState)),
	trap(HSWin = win_GetCtlHandle(Win,hor_sc_id),_,fail),
	trap(VSWin = win_GetCtlHandle(Win,ver_sc_id),_,fail),
	trap(PBWin = win_GetCtlHandle(Win,pushb_id),_,fail),
	win_Move(HSWin,rct(0,B1,R1,B)),
	win_Move(VSWin,rct(R1,0,R,B1)),
	win_Move(PBWin,rct(R1,B1,R,B)),
ifndef os_os2
	win_SetClip(Win,rct(0,0,R1,B1)),
enddef 
	retract(mapctrl_info(Win,Color,Mode,Scale,Callback)),!,
	Scale = mapscale(Pnt0,ScaleFactor),
	change_maping_and_scaling(Win,Scale,R1,B1,CorrectedScaleFactor),
	assert(mapctrl_info(Win,Color,Mode,mapscale(Pnt0,CorrectedScaleFactor),Callback)),
	wwwin_SetFocus(Win),
	CorrectedScaleFactor < ScaleFactor - 0.05,
	win_Invalidate(Win).

  %+++++++ e_Destroy
  mapctrl_HandleEvent(Win,e_Destroy()):-!,
	clear_facts(Win).

  %******************** Event handler end ********************
  
/*************************************************************
		SCROLLING predicates
*************************************************************/

  scroll_right(Win,HorScWin,ScrollValue):-
	mapctrl_info(Win,_,_,Scale,_),
	Scale = mapscale(pnt(_,Y0),ScaleFactor),
	win_GetMapScale(Win,_,LogExt,_,WinExt),
	WinExt = pnt(R1,B1),
	R1L = val(long,R1),
	SSS = R1L * (1 + ScrollValue),
	trap(Xw4 = val(integer,SSS),_,fail),
	PntList1 = win_DPtoLP(Win,[pnt(Xw4,0)]), PntList1 = [pnt(X4,_)],
	mmminI(X4,max_int,Xd),
	PntList2 = win_LPtoDP(Win,[pnt(Xd,0)]), PntList2 = [pnt(Xwd,_)],
	Diff = R1 - Xwd,
	Diff < 0,
	retract(mapctrl_info(Win,Color,Mode,_,Callback)),
	Xw1 = 0 - Diff, Xw2 = R1 + Diff,
	PntList3 = win_DPtoLP(Win,[pnt(Xw1,0)]), PntList3 = [pnt(X1,_)], !,
	assert(mapctrl_info(Win,Color,Mode,mapscale(pnt(X1,Y0),ScaleFactor),Callback)),
	win_SetMapScale(Win,pnt(X1,Y0),LogExt,pnt(0,0),WinExt),
	win_SetScrollPos(HorScWin,sb_Ctl,X1),
	win_Scroll(Win,rct(0,0,R1,B1),Diff,0),
	win_Invalidate(Win,rct(Xw2,0,R1,B1)).
  scroll_right(_,_,_).

  scroll_left(Win,HorScWin,ScrollValue):-
	mapctrl_info(Win,_,_,Scale,_),
	Scale = mapscale(pnt(_,Y0),ScaleFactor),
	win_GetMapScale(Win,_,LogExt,_,WinExt),
	WinExt = pnt(R1,B1),
	R1L = val(long,R1),
	trap(Xw4 = val(integer,0 - (R1L * ScrollValue)),_,fail),
	PntList1 = win_DPtoLP(Win,[pnt(Xw4,0)]), PntList1 = [pnt(X4,_)],
	mmmaxI(X4,0,Xd),
	PntList2 = win_LPtoDP(Win,[pnt(Xd,0)]), PntList2 = [pnt(Xwd,_)],
	Diff = 0 - Xwd,
	Diff > 0,
	retract(mapctrl_info(Win,Color,Mode,_,Callback)),!,
	assert(mapctrl_info(Win,Color,Mode,mapscale(pnt(Xd,Y0),ScaleFactor),Callback)),
	win_SetMapScale(Win,pnt(Xd,Y0),LogExt,pnt(0,0),WinExt),
	win_SetScrollPos(HorScWin,sb_Ctl,Xd),
	win_Scroll(Win,rct(0,0,R1,B1),Diff,0),
	win_Invalidate(Win,rct(0,0,Diff,B1)).
  scroll_left(_,_,_).

  scroll_down(Win,VerScWin,ScrollValue):-
	mapctrl_info(Win,_,_,Scale,_),
	Scale = mapscale(pnt(X0,_),ScaleFactor),
	win_GetMapScale(Win,_,LogExt,_,WinExt),
	WinExt = pnt(R1,B1),
	B1L = val(long,B1),
	SSS = B1L * (1 + ScrollValue),
	trap(Yw4 = val(integer,SSS),_,fail),
	PntList1 = win_DPtoLP(Win,[pnt(0,Yw4)]), PntList1 = [pnt(_,Y4)],
	mmminI(Y4,max_int,Yd),
	PntList2 = win_LPtoDP(Win,[pnt(0,Yd)]), PntList2 = [pnt(_,Ywd)],
	Diff = B1 - Ywd,
	Diff < 0,
	retract(mapctrl_info(Win,Color,Mode,_,Callback)),
	Yw1 = 0 - Diff, Yw2 = B1 + Diff,
	PntList3 = win_DPtoLP(Win,[pnt(0,Yw1)]), PntList3 = [pnt(_,Y1)], !,
	assert(mapctrl_info(Win,Color,Mode,mapscale(pnt(X0,Y1),ScaleFactor),Callback)),
	win_SetMapScale(Win,pnt(X0,Y1),LogExt,pnt(0,0),WinExt),
	win_SetScrollPos(VerScWin,sb_Ctl,Y1),
	win_Scroll(Win,rct(0,0,R1,B1),0,Diff),
	win_Invalidate(Win,rct(0,Yw2,R1,B1)).
  scroll_down(_,_,_).

  scroll_up(Win,VerScWin,ScrollValue):-
	mapctrl_info(Win,_,_,Scale,_),
	Scale = mapscale(pnt(X0,_),ScaleFactor),
	win_GetMapScale(Win,_,LogExt,_,WinExt),
	WinExt = pnt(R1,B1),
	B1L = val(long,B1),
	trap(Yw4 = val(integer,0 - (B1L * ScrollValue)),_,fail),
	PntList1 = win_DPtoLP(Win,[pnt(0,Yw4)]), PntList1 = [pnt(_,Y4)],
	mmmaxI(Y4,0,Yd),
	PntList2 = win_LPtoDP(Win,[pnt(0,Yd)]), PntList2 = [pnt(_,Ywd)],
	Diff = 0 - Ywd,
	Diff > 0,
	retract(mapctrl_info(Win,Color,Mode,_,Callback)),!,
	assert(mapctrl_info(Win,Color,Mode,mapscale(pnt(X0,Yd),ScaleFactor),Callback)),
	win_SetMapScale(Win,pnt(X0,Yd),LogExt,pnt(0,0),WinExt),
	win_SetScrollPos(VerScWin,sb_Ctl,Yd),
	win_Scroll(Win,rct(0,0,R1,B1),0,Diff),
	win_Invalidate(Win,rct(0,0,R1,Diff)).
  scroll_up(_,_,_).

  move_org_point(Win,ScaleFactor,pnt(X0,Y0),R1,B1):-
	Xmax = X0 + R1 * ScaleFactor,	   Ymax = Y0 + B1 * ScaleFactor,
	mmmax(Xmax,max_intR,Xm),	   mmmax(Ymax,max_intR,Ym),
	Dx = max_int - Xm,		   Dy = max_int - Ym,
	Dx + Dy <> 0,
	X1a = X0 + Dx,			   Y1a = Y0 + Dy,
	X1 = val(INTEGER,X1a),		   Y1 = val(INTEGER,Y1a),
	retract(mapctrl_info(Win,Color,Mode,_,Callback)),!,
	assert(mapctrl_info(Win,Color,Mode,mapscale(pnt(X1,Y1),ScaleFactor),Callback)),
	win_GetMapScale(Win,_,LogExt,_,WinExt),
	win_SetMapScale(Win,pnt(X1,Y1),LogExt,pnt(0,0),WinExt),
	HorScWin = win_GetCtlHandle(Win,hor_sc_id),
	VerScWin = win_GetCtlHandle(Win,ver_sc_id),
	win_SetScrollPos(HorScWin,sb_Ctl,X1),
	win_SetScrollPos(VerScWin,sb_Ctl,Y1).
  move_org_point(_,_,_,_,_).

  build_popup_menulist([],2,List):-!,
	List = [txt(zoomin_id,zoomin_text,0,b_true,mis_None,[]),
		txt(zoomout_id,zoomout_text,0,b_true,mis_None,[])].
  build_popup_menulist(AppList,N,List):-
	List = [txt(zoomin_id,zoomin_text,0,b_true,mis_None,[]),
		txt(zoomout_id,zoomout_text,0,b_true,mis_None,[]),
		separator|AppList],
	lllistlength(AppList,A),
	N = A + 3 .

  allowed_items([],b_false,b_false):-!. 	% empty markerlist
  allowed_items([_],b_true,b_true):-!.		% one object is marked
  allowed_items([_,_|_],b_false,b_true):-!.	% more than one object is marked
  allowed_items(_,b_false,b_false):-errorexit().

  calc_relative_points(_,[],[]):-!.
  calc_relative_points(pnt(X0,Y0),[pnt(X1,Y1)|PntList],[pnt(X2,Y2)|OutList]):-
	X2 = X1 - X0, Y2 = Y1 - Y0, !,
	calc_relative_points(pnt(X0,Y0),PntList,OutList).
  calc_relative_points(_,_,[]):-errorexit().

  %-------- Generate new Id for the foreground object
predicates
  determ exist_Id(WINDOW,ULONG)

clauses
  new_Id(Win,Id,Id):-
	not(exist_Id(Win,Id)),!.
  new_Id(Win,Id,OutId):-
	Id1 = Id + 1,
	new_Id(Win,Id1,OutId).

  exist_Id(Win,Id):-
	mapctrl_object(Win,polygon(Id,_,_,_,_,_)),!.
  exist_Id(Win,Id):-
	mapctrl_object(Win,circle(Id,_,_,_,_,_)),!.
  exist_Id(Win,Id):-
	mapctrl_object(Win,bitmap(Id,_,_,_,_)),!.
  exist_Id(Win,Id):-
	mapctrl_object(Win,picture(Id,_,_,_,_)),!.
  exist_Id(Win,Id):-
	mapctrl_object(Win,arrow(Id,_,_,_,_)),!.

  %-------- Erase database facts 
  clear_facts(Win):-
	retractall(mapctrl_info(Win,_,_,_,_)),
	retractall(mapctrl_sensitive_rct_area(Win,_,_)),
	retractall(mapctrl_sensitive_line_area(Win,_,_,_)),
	retractall(mapctrl_marker(Win,_)),
	retractall(mapctrl_bg_object(Win,_)),
	retractall(mapctrl_object(Win,_)).

  %-------- Check if point is inside one of the sensitive areas
  check_pnt(Win,Pnt,Id):-
	mapctrl_sensitive_rct_area(Win,Id,RCT),		% Rectangular area
	rect_PntInside(RCT,Pnt),!.
  check_pnt(Win,Pnt,Id):-
	mapctrl_info(Win,_,_,mapscale(_,ScaleFactor),_),
	mapctrl_sensitive_line_area(Win,Id,PntFrom,PntTo),	% Line area
	point_close_to_line(ScaleFactor,Pnt,PntFrom,PntTo),!.

  point_close_to_line(ScaleFactor,pnt(X,Y),pnt(X1,Y1),pnt(X2,Y2)):-
	mmminI(Y1,Y2,Ymin), mmmaxI(Y1,Y2,Ymax),
	mmminI(X1,X2,Xmin), mmmaxI(X1,X2,Xmax),
	Zone = line_marking_zone * ScaleFactor,
	Y >= Ymin - Zone, Y <= Ymax + Zone,
	X >= Xmin - Zone, X <= Xmax + Zone,
	X1r = val(real,X1), X2r = val(real,X2),
	Y1r = val(real,Y1), Y2r = val(real,Y2),
	A = Y2r - Y1r,
	B = X1r - X2r,
	C = Y1r * X2r - X1r * Y2r,
	Dist = abs((A * X + B * Y + C) / sqrt(A*A + B*B)),
	Dist <= Zone,!.

  %-------- Get list of markered foreground objects
  get_marker(Win,MarkerList):-
	mapctrl_marker(Win,MarkerList),!.		% Marker already exists
  get_marker(_,[]).					% Marker not exists

  %-------- Send unmark callback and remove marker(s)
  unmark_objects(Win,_,[]):-!,
	retractall(mapctrl_marker(Win,_)).
  unmark_objects(Win,Callback,OldMarkerList):-
	not(Callback(Win,action(marker(OldMarkerList,b_false)))),!,
	draw_markers(Win,OldMarkerList),	% remove old markers
	retractall(mapctrl_marker(Win,_)).
  unmark_objects(_Win,_Callback,_MarkerList).

/**** global PREDICATE **********************************/
/*							*/
/* 	Save Map custom control data to disk		*/
/*							*/
/*  mapctrl_SaveData(WINDOW,	% Control window	*/
/*		     STRING)	% Filename		*/
/*                                                      */
/********************************************************/
predicates
  procedure write_objects(WINDOW)

clauses
  mapctrl_SaveData(Win,FileName):-
	trap(openwrite(mapdata,FileName),_,fail),
	writedevice(mapdata),
	write_objects(Win),
	writedevice(screen),
	closefile(mapdata),!.
ifdef development_mode
  mapctrl_SaveData(_Win,FileName):-
	write("Cannot open file '",FileName,"'\n").
elsedef
  mapctrl_SaveData(_Win,_FileName).
enddef

  write_objects(Win):-		% write bg objects
	mapctrl_bg_object(Win,Term),
	  term_str(mapctrl_bgobj,Term,Str),
	  write(Str),nl,
	fail.
  write_objects(Win):-		% write fg objects
	mapctrl_object(Win,Term),
	  term_str(mapctrl_obj,Term,Str),
	  write(Str),nl,
	fail.
  write_objects(_).

/*******************************************************
	Drawing of mapctrl markers
*******************************************************/
  draw_markers(_,[]):-!.
  draw_markers(Win,[Id|Rest]):-				% rectangular area
	mapctrl_sensitive_rct_area(Win,Id,RCT),!,
	win_SetPen(Win,pen(1,ps_Dot,color_White)),
	win_SetBrush(Win,brush(pat_Hollow,color_Blue)),
	win_SetDrawMode(Win,dm_XorPen),
	draw_Rect(Win,RCT),
	draw_markers(Win,Rest).
  draw_markers(Win,[Id|Rest]):-				% line area
	mapctrl_sensitive_line_area(Win,Id,PntFrom,PntTo),!,
	win_SetPen(Win,pen(1,ps_Dot,color_White)),
	win_SetDrawMode(Win,dm_XorPen),
	draw_Line(Win,PntFrom,PntTo),
	draw_markers(Win,Rest).
ifdef development_mode
  draw_markers(Win,[Id|Rest]):-				% object not found - display error message
	write("Wrong object id - ",Id,"\n"),!,
	draw_markers(Win,Rest).
elsedef
  draw_markers(Win,[_|Rest]):-!,
	draw_markers(Win,Rest).
enddef
  draw_markers(_,_):-errorexit().
	
/*******************************************************
	Drawing of mapctrl objects
*******************************************************/
predicates
  procedure draw_bgobject(WINDOW,MAPCTRL_BGOBJ)
  procedure draw_fgobject(WINDOW,MAPCTRL_OBJ)

clauses
  draw_objects(Win):-
	mapctrl_bg_object(Win,BgObj),
	  draw_bgobject(Win,BgObj),
	fail.
  draw_objects(Win):-
	mapctrl_object(Win,Obj),
	  draw_fgobject(Win,Obj),
	fail.
  draw_objects(_).

  %+++ Background Polygon
  draw_bgobject(Win,polygon_bg(PntList,Pen,Brush)):-
	win_SetPen(Win,Pen),
	win_SetBrush(Win,Brush),
	win_SetDrawMode(Win,dm_CopyPen),
	draw_Polygon(Win,PntList),!.
  %+++ Background Polyline
  draw_bgobject(Win,polyline_bg(PntList,Pen)):-
	win_SetPen(Win,Pen),
	win_SetDrawMode(Win,dm_CopyPen),
	draw_PolyLine(Win,PntList),!.
  %+++ Background Circle
  draw_bgobject(Win,circle_bg(pnt(X,Y),Diam,Pen,Brush)):-
	win_SetPen(Win,Pen),
	win_SetBrush(Win,Brush),
	win_SetDrawMode(Win,dm_CopyPen),
	Radius = Diam div 2,
	L = X - Radius, R = X + Radius,
	T = Y - Radius, B = Y + Radius,
	draw_Ellipse(Win,rct(L,T,R,B)),!.
  %+++ Background Bitmap
  draw_bgobject(Win,bitmap_bg(Pnt,FileName,Rop)):-
	trap(Picture = pict_Load(FileName),_,fail),
	pict_Draw(Win,Picture,Pnt,Rop),
	pict_Destroy(Picture),!.
  %+++ Background Picture
  draw_bgobject(Win,picture_bg(Pnt,Picture,Rop)):-
	pict_Draw(Win,Picture,Pnt,Rop),!.
  %+++ Background Text
  draw_bgobject(Win,text_bg(pnt(X,Y),Text,FontFamily,StyleFlags,Size,Color)):-
	Font = font_Create(FontFamily,StyleFlags,Size),
	win_SetFont(Win,Font),
	win_SetForeColor(Win,Color),
	draw_Text(Win,X,Y,Text),!.
  draw_bgobject(_Win,_BgObj).

predicates
  procedure draw_label(WINDOW,PNT,MAPCTRL_LABEL)
  procedure calc_angles(INTEGER,INTEGER,INTEGER,INTEGER,REAL,REAL)
  
clauses
  %+++ Foreground Polygon
  draw_fgobject(Win,polygon(_Id,Pnt,PntList,Pen,Brush,Label)):-!,
	recalc_pntlist(Pnt,PntList,AbsPntList),
	win_SetPen(Win,Pen),
	win_SetBrush(Win,Brush),
	win_SetDrawMode(Win,dm_CopyPen),
	draw_Polygon(Win,AbsPntList),
	draw_label(Win,Pnt,Label).
  %+++ Foreground Circle
  draw_fgobject(Win,circle(_Id,Pnt,Diam,Pen,Brush,Label)):-!,
	win_SetPen(Win,Pen),
	win_SetBrush(Win,Brush),
	win_SetDrawMode(Win,dm_CopyPen),
	Pnt = pnt(X,Y), Radius = Diam div 2,
	L = X - Radius, R = X + Radius,
	T = Y - Radius, B = Y + Radius,
	draw_Ellipse(Win,rct(L,T,R,B)),
	draw_label(Win,Pnt,Label).
  %+++ Foreground Bitmap
  draw_fgobject(Win,bitmap(_Id,Pnt,FileName,Rop,Label)):-
	trap(Picture = pict_Load(FileName),_,fail),!,
	pict_Draw(Win,Picture,Pnt,Rop),
	pict_Destroy(Picture),
	draw_label(Win,Pnt,Label).
  %+++ Foreground Picture
  draw_fgobject(Win,picture(_Id,Pnt,Picture,Rop,Label)):-!,
	pict_Draw(Win,Picture,Pnt,Rop),
	draw_label(Win,Pnt,Label).
  %+++ Foreground Arrow
  draw_fgobject(Win,arrow(_Id,PntFrom,PntTo,Pen,Label)):-!,
	PntFrom = pnt(X1,Y1), PntTo = pnt(X2,Y2),
	win_SetDrawMode(Win,dm_CopyPen),
ifdef arrow_type_special
	Pen = pen(_PWidth,_PStyle,PColor),
	X3 = (X1 div 2) + (X2 div 2),
	Y3 = (Y1 div 2) + (Y2 div 2),
	win_SetPen(Win,pen(1,ps_Solid,PColor)),
	draw_Line(Win,PntFrom,pnt(X3,Y3)),
	win_SetPen(Win,pen(1,ps_Dot,PColor)),
	draw_Line(Win,pnt(X3,Y3),PntTo),
elsedef
	win_SetPen(Win,Pen),
	draw_Line(Win,PntFrom,PntTo),
	X3 = (X1/10 + 9/10 * X2),
	Y3 = (Y1/10 + 9/10 * Y2),
	ArrowLength = sqrt((X2 - X3)*(X2 - X3) + (Y2 - Y3)*(Y2 - Y3)),
	calc_angles(X1,Y1,X2,Y2,A1,A2),
	X4 = val(integer,X2 + ArrowLength * cos(A1)),
	Y4 = val(integer,Y2 - ArrowLength * sin(A1)),
	X5 = val(integer,X2 + ArrowLength * cos(A2)),
	Y5 = val(integer,Y2 - ArrowLength * sin(A2)),
	draw_Line(Win,pnt(X2,Y2),pnt(X4,Y4)),
	draw_Line(Win,pnt(X2,Y2),pnt(X5,Y5)),
enddef
	draw_label(Win,PntFrom,Label).

  draw_fgobject(_Win,_Obj).

  calc_angles(X,Y1,X,Y2,1.0472,2.0944):-		% Vertical arrow down
  	Y1 < Y2,!.	
  calc_angles(X,_,X,_,4.1888,5.2360):-!.		% Vertical arrow up
  calc_angles(X1,Y,X2,Y,0.5236,-0.5236):-		% Horizontal arrow to the left
  	X1 > X2,!.	
  calc_angles(_,Y,_,Y,2.6180,3.6652):-!.		% Horizontal arrow to the right

  calc_angles(X1,Y1,X2,Y2,A1,A2):-			% Non vertical arrows directed to the left
  	D = (Y1-Y2)/(X2-X1),
	X1 > X2,!,
  	A = arctan(D),
  	A1 = A - 0.5236,	 % - 30 deg
  	A2 = A + 0.5236.	 % + 30 deg
  calc_angles(X1,Y1,X2,Y2,A1,A2):-			% Non vertical arrows directed to the right
  	A = arctan((Y1-Y2)/(X2-X1)),
  	A1 = A + 2.6180,	 % + 150 deg
  	A2 = A + 3.6652.	 % + 210 deg

  recalc_pntlist(Pnt,[pnt(X1,Y1)|L1],[pnt(X2,Y2)|L2]):-
	Pnt = pnt(X0,Y0),
	X2 = X0 + X1,
	Y2 = Y0 + Y1,!,
	recalc_pntlist(Pnt,L1,L2).
  recalc_pntlist(_,[],[]):-!.
  recalc_pntlist(_,_,[]):-errorexit().

  draw_label(_,_,nolabel):-!.
  draw_label(Win,Pnt0,Label):-
	Label = label(pnt(X1,Y1),Text,FontFamily,StyleFlags,Size,Color),
	Font = font_Create(FontFamily,StyleFlags,Size),
	win_SetFont(Win,Font),
	win_SetForeColor(Win,Color),
	win_SetBackMode(Win,bk_Transparent),
	Pnt0 = pnt(X0,Y0),
	X = X0 + X1, Y = Y0 + Y1,
	draw_Text(Win,X,Y,Text),!.
  draw_label(_,_,_):-errorexit().

/**** global PREDICATE ***********************************/
/*						 	 */
/*   	  Remove all foreground arrows from map		 */
/*                                                       */
/*********************************************************/
  mapctrl_RemoveArrows(Win):-
	findall(Id,mapctrl_object(Win,arrow(Id,_,_,_,_)),IdList),
	mapctrl_RemoveObjects(Win,IdList).
	
/**** global PREDICATE ***********************************/
/*						 	 */
/*   	  Remove all foreground circles from map		 */
/*                                                       */
/*********************************************************/
  mapctrl_RemoveCircles(Win):-
	findall(Id,mapctrl_object(Win,circle(Id,_,_,_,_,_)),IdList),
	mapctrl_RemoveObjects(Win,IdList).
	
  %========== SMALL USEFULL predicates ==========

  list_reverse([],L,L):-!.
  list_reverse([H|T],L,L1):- !,
	list_reverse(T,[H|L],L1).
  list_reverse(_,_,[]):-errorexit().

  mmmin(X,Y,X):-
	X < Y,!.
  mmmin(_,Y,Y).

  mmmax(X,Y,X):-
	X > Y,!.
  mmmax(_,Y,Y).

  mmminI(X,Y,X):-
	X < Y,!.
  mmminI(_,Y,Y).

  mmmaxI(X,Y,X):-
	X > Y,!.
  mmmaxI(_,Y,Y).


  mmmember(X,[X|_]):-!.
  mmmember(X,[_|Rest]):-
	mmmember(X,Rest).

  lllistlength([],0):-!.
  lllistlength([_|Rest],X1):-
	lllistlength(Rest,X),
	X1 = X + 1, !.
  lllistlength(_,0):-errorexit().

  wwwin_SetFocus(Win):-
	trap(win_SetFocus(Win),_,fail),!.
  wwwin_SetFocus(_).
