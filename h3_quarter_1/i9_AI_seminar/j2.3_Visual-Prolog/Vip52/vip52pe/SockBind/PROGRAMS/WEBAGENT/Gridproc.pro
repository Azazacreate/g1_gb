/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  WEBAGENT
 FileName: GRID_PROC.PRO
 Purpose: Example of HTTP Layer
 Written by: Konstantin Ivanov
 Comments:
******************************************************************************/

include "webagent.inc"
include "webagent.con"
include "hlptopic.con"

DATABASE - grid_in
  row_sel(INTEGER,INTEGER)
  
PREDICATES
  grid_callback : GRID_CALLBACK
  get_state(INTEGER,INTEGER,STRING) - (i,i,o)
  get_uri(INTEGER,STRING) - (i,o)
  get_timer(INTEGER,STRING) - (i,o)
  test_row(WINDOW,INTEGER) - (i,i)
  test_rows(WINDOW,INTEGER,INTEGER) - (i,i,i)
  replace_data(INTEGER,INTEGER,STRING) - (i,i,i)
  replace_status(INTEGER,STRING) - (i,i)
  replace_uri(INTEGER,STRING) - (i,i)
  replace_timer(INTEGER,STRING) - (i,i)
  get_cell(INTEGER,INTEGER,GRIDTEXT) - (i,i,o)
  get_cells(INTEGER,INTEGER,INTEGER,INTEGER,GRIDLIST2D) - (i,i,i,i,o)
  get_row_cells(INTEGER,INTEGER,INTEGER,GRIDLIST) - (i,i,i,o)
  set_sel(INTEGER,INTEGER) - (i,i)
  set_desel(INTEGER,INTEGER) - (i,i)
  delete_rows(INTEGER,INTEGER) - (i,i)
  is_timer(INTEGER) - (i)
  renum_entry(INTEGER,INTEGER) - (i,i)
  color_renum_entry(INTEGER,INTEGER) - (i,i)
  stop_entry(INTEGER) - (i)
  test_uri_entry(INTEGER) - (i)
  procedure test_dbl_click(WINDOW,INTEGER,INTEGER) - (i,i,i)
  is_selected()
  test_marker(INTEGER,GRID_MARKER) - (i,i)
  
CLAUSES

  grid_handler(GridWin,e_Create(_),0):-!,
  	cols_width(C1,C2,C3,C4),
	Font = font_Create(ff_Fixed,[],8),
	grid_Init(GridWin,
		  grid_style(grid_raised,color_Gray,0xC0DCC0,0xC0DCC0,color_LtGray,color_Black),
		  grid_rowstyle(20,50,1,grid_number,b_false),
		  grid_columnstyle(0,[grid_col("Status",C1,grid_left_align,grid_top_align,5,0,10),
				grid_col("Address",C2,grid_left_align,grid_center,5,0,500),
				grid_col("Timer",C3,grid_left_align,grid_bottom_align,5,0,5),
				grid_col("Settings",C4,grid_center,grid_center,5,0,500)
				]),grid_callback),
	win_SetFont(GridWin, Font),
	grid_VisitOrder(GridWin,grid_key_enter,grid_right),
	grid_VisitOrder(GridWin,grid_key_enter,c_Shift,grid_left),
	assert(grid_win(GridWin)),
	!.
	
  grid_handler(_GridWin,e_closerequest(),0):-!.
  grid_handler(GridWin,e_Control(_,wc_LBoxButton,Win,closeup),0):-
  	grid_marker(GridWin,Mark),
  	Mark = grid_edit_cell(Row,_),
	Index=lbox_GetSelIndex(Win),
	Item=lbox_GetItem(Win,Index),
	retractall(row_lboxwin(Row,_)),
	assert(row_lboxwin(Row,Win)),
	proc_state(Row,Item),fail.
  grid_handler(GridWin,e_Control(_,wc_LBoxButton,Win,losefocus),0):-
  	grid_marker(GridWin,Mark),
  	Mark = grid_edit_cell(Row,_),
  	retractall(row_lboxwin(Row,Win)),
  	fail.
  
  grid_handler(_GridWin,e_KeyDown(k_del,c_Nothing),0):-
  	row_sel(RowB,RowE),
  	format(S,"Do you really want to delete rows:\n\n \t%d - %d?",RowB,RowE),
	resp_default = dlg_Ask(_GridWin,"Delete entries?",S,["OK","Cancel"]),
  	delete_rows(RowB,RowE),
  	Kolvo = RowE - RowB + 1,
  	renum_entry(RowB,Kolvo),
  	color_renum_entry(RowB,RowE),
  	grid_Invalidate(_GridWin,grid_all),
  	!.
  grid_handler(_GridWin,e_MouseDbl(pnt(X,Y),_,mouse_button_left),0):-
  	grid_get_pos(_GridWin,X,Y,Row,Column),
  	Column = 4,!,
  	test_dbl_click(_GridWin,Row,Column).
  grid_handler(GridWin,EVENT,0):-
  	grid_HandleEvent(GridWin,EVENT).
  	
  test_dbl_click(_,Row,4):-
  	uri_entry(Row,"Fetch",_,_,_,_,_,_),!.
  test_dbl_click(_,Row,4):-
  	entry_setts_db(Setts_win,Row),!,
	win_BringToTop(Setts_win).
  test_dbl_click(_Win,Row,4):-
    	not(entry_setts_db(_,Row)),!,
  	dlg_entry_settings_Create(_Win,Row).
  test_dbl_click(_,_,_):-!.
  	
/*  grid_callback(_Win,user_action(Action),event_answer(continue)):-
	term_str(grid_user_action,Action,ActionStr),
	format(S,"Grid callback: %",ActionStr),
%	dlg_note(S),
write(S),nl,
	fail.*/
  grid_callback(_Win,user_action(grid_marker(grid_row_marker([gl(RowB,RowE)|_]),b_true)),event_answer(continue)):-
	 retract(row_sel(RB,RE)),!,
	 set_desel(RB,RE),
	 assert(row_sel(RowB,RowE)),
	 set_sel(RowB,RowE),
	 grid_Invalidate(_Win,grid_area(RowB,RowE,1,4)),
	 !.
  grid_callback(_Win,user_action(grid_marker(grid_row_marker([gl(RowB,RowE)|_]),b_true)),event_answer(continue)):-
	 not(row_sel(_,_)),!,
	 assert(row_sel(RowB,RowE)),
	 set_sel(RowB,RowE),
	 grid_Invalidate(_Win,grid_area(RowB,RowE,1,4)),
	 !.
  grid_callback(_Win,user_action(grid_marker(grid_row_marker([gl(RowB,RowE)|_]),b_false)),event_answer(continue)):-
	 set_desel(RowB,RowE),
	 grid_Invalidate(_Win,grid_area(RowB,RowE,1,4)),
	 !.
  grid_callback(_Win,user_action(grid_marker(grid_edit_cell(Row,_),b_true)),event_answer(continue)):-
	test_row(_Win,Row),
	fail.
  grid_callback(_Win,user_action( grid_area_marker_beg( Row, Col )),event_answer( stop )):-
  	grid_marker( _Win, grid_edit_cell( Row, Col )),!.
  grid_callback(_Win,user_action(grid_marker(grid_area_marker([ga(RowB,RowE,_,_)|_]),b_true)),event_answer(continue)):-
  	test_rows(_Win,RowB,RowE),
	fail.
  grid_callback(_Win,user_action(grid_marker(grid_area_marker([ga(RowB,RowE,_,_)|_]),b_false)),event_answer(continue)):-
	set_desel(RowB,RowE),
	grid_Invalidate(_Win,grid_area(RowB,RowE,1,4)),
 	fail.
  grid_callback(_Win,user_action(grid_marker(grid_area_marker([ga(Row,Row,2,2)|_]),b_true)),event_answer(editCtrl(InitString))):-
  	get_uri(Row,InitString),!.
  grid_callback(_Win,user_action(grid_marker(grid_area_marker([ga(Row,Row,3,3)|_]),b_true)),event_answer(editCtrl(InitString))):-
	get_timer(Row,InitString),!.
  grid_callback(_Win,user_action(grid_marker(grid_edit_cell(Row,1),b_true)),event_answer(lBoxButton(["Stop"],InitString))):-	% no uri or path
	get_state(Row,1,InitString),!.
  grid_callback(_Win,user_action(grid_marker(grid_edit_cell(Row,1),b_true)),event_answer(lBoxButton(["Stop","Fetch"],InitString))):- % no timer
	get_state(Row,2,InitString),!.
  grid_callback(_Win,user_action(grid_marker(grid_edit_cell(Row,1),b_true)),event_answer(lBoxButton(["Stop","Wait","Fetch"],InitString))):- % all ok
	get_state(Row,3,InitString),!.
  grid_callback(_Win,user_action(grid_marker(grid_edit_cell(Row,2),b_true)),event_answer(stop)):-
	uri_entry(Row,"Fetch",_,_,_,_,_,_),!.
  grid_callback(_Win,user_action(grid_marker(grid_edit_cell(Row,2),b_true)),event_answer(editCtrl(InitString))):-
	get_uri(Row,InitString),!.
  grid_callback(_Win,user_action(grid_marker(grid_edit_cell(Row,3),b_true)),event_answer(editCtrl(InitString))):-
	get_timer(Row,InitString),!.
  grid_callback(_Win,user_action(grid_marker(grid_edit_cell(Row,4),b_true)),event_answer(stop)):-
  	grid_Invalidate(_Win,grid_area(Row,Row,4,4)),!.
  grid_callback(_Win,user_action(modified(Row,Column,NewString)),event_answer(continue)):-
	replace_data(Row,Column,NewString),!.

/*  grid_callback(_Win,data_request(Area),data_answer(empty_answer)):-
	term_str(grid_data_area,Area,AreaStr),
	format(S,"Grid data callback: %",AreaStr),
	write(S),nl,
%	dlg_note(S),
	fail.*/
  grid_callback(_Win,data_request(grid_area(From_Row,To_Row,From_Column,To_Column)),data_answer(grid_area_answer(CellList))):-
	get_cells(From_Row,To_Row,From_Column,To_Column,CellList),!.

  get_state(Row,1,Status):-
 	uri_entry(Row,Status,"",_,_,_,_,_),!. % no uri
  get_state(Row,1,Status):-
 	uri_entry(Row,Status,_,_,setts(_,_,_,"",_),_,_,_),!. % no path
  get_state(Row,2,Status):-
 	uri_entry(Row,Status,Uri,"",_,_,_,_),
 	Uri <> "",!.
  get_state(Row,3,Status):-
 	uri_entry(Row,Status,_,_,_,_,_,_),!.
  get_state(Row,_,""):-
  	not(uri_entry(Row,_,_,_,_,_,_,_)),!.	
  get_uri(Row,Uri):-
 	uri_entry(Row,_,Uri,_,_,_,_,_),!.
  get_uri(Row,""):-
  	not(uri_entry(Row,_,_,_,_,_,_,_)),!.
  get_timer(Row,Timer):-
 	uri_entry(Row,_,_,Timer,_,_,_,_),!.
  get_timer(Row,""):-
  	not(uri_entry(Row,_,_,_,_,_,_,_)),!.
 	
  test_rows(Win,Row,Row):-
  	test_row(Win,Row),!.
  test_rows(Win,RowB,RowE):-
  	test_row(Win,RowB),
  	RowN = RowB + 1,!,
  	test_rows(Win,RowN,RowE).
  	
  test_row(_,Row):-
  	uri_entry(Row,_,_,_,_,_,color_White,color_Blue),!.	%row wasn't changed
  test_row(Win,Row):-
  	is_selected(),
  	set_sel(Row,Row),
 	grid_Invalidate(Win,grid_area(Row,Row,1,4)),
 	!.

  replace_data(Row,_,_):-
  	set_desel(Row,Row),
  	grid_win(Win),
  	grid_Invalidate(Win,grid_area(Row,Row,1,4)),
  	fail.
  replace_data(Row,1,Status):-
	not(row_lboxwin(Row,_)),
  	replace_status(Row,Status),!.
  replace_data(Row,2,Uri):-
  	replace_uri(Row,Uri),!.
  replace_data(Row,3,Timer):-
  	replace_timer(Row,Timer),!.
  replace_data(_,_,_).
  	
  replace_status(Row,Status):-
  	uri_entry(Row,Status,_,_,_,_,_,_),!.
  replace_status(Row,Status):-
  	retract(uri_entry(Row,_,Uri,Timer,Path,Levels,Color1,Color2)),!,
	assert(uri_entry(Row,Status,Uri,Timer,Path,Levels,Color1,Color2)),
	grid_win(Gwin),
	grid_Invalidate(Gwin,grid_area(Row,Row,3,3)).
  replace_status(Row,Status):-
  	assert(uri_entry(Row,Status,"","",setts("2",b_false,notify_setts([],""),"",auth(0,$[0x4F,0x67,0x3D,0x3D,0x00])),stat(""),color_White,color_Blue)).
  replace_uri(Row,Uri):-
  	uri_entry(Row,_,Uri,_,_,_,_,_),!.
  replace_uri(Row,_):-
  	uri_entry(Row,"Fetch",_,_,_,_,_,_),
  	dlg_error("Address can not be changed during fetching!"),!.
  replace_uri(Row,Uri):-
  	Uri <> "",
  	uri_entry(Row,Status,_,Timer,Path,Levels,Color1,Color2),!,
  	test_uri_entry(Row),
	retract(uri_entry(Row,Status,_,Timer,Path,Levels,Color1,Color2)),!,
	assert(uri_entry(Row,Status,Uri,Timer,Path,Levels,Color1,Color2)).
  replace_uri(Row,""):-
  	uri_entry(Row,_,_,Timer,Path,Levels,Color1,Color2),!,
  	test_uri_entry(Row),
  	retract(uri_entry(Row,_,_,Timer,Path,Levels,Color1,Color2)),!,
	assert(uri_entry(Row,"Stop","",Timer,Path,Levels,Color1,Color2)),
	grid_win(Win),
	grid_Invalidate(Win,grid_area(Row,Row,1,1)),!.
  replace_uri(Row,Uri):-
  	assert(uri_entry(Row,"",Uri,"",setts("2",b_false,notify_setts([],""),"",auth(0,$[0x4F,0x67,0x3D,0x3D,0x00])),stat(""),color_White,color_Blue)).
  replace_timer(Row,Timer):-
	uri_entry(Row,_,_,Timer,_,_,_,_),!.
  replace_timer(Row,Timer):-
	trap(str_int(Timer,Tm),_,true),
	Tm > 0,
	retract(uri_entry(Row,Status,Uri,_,Path,Levels,Color1,Color2)),!,
	assert(uri_entry(Row,Status,Uri,Timer,Path,Levels,Color1,Color2)),
	restart_timer(Row),!.
  replace_timer(Row,Timer):-
  	trap(str_int(Timer,Tm),_,true),
	Tm <= 0,!,
	dlg_error("Timer value must be more 0!"),
	stop_entry(Row),
	stop_timer(Row),
	grid_win(Win),
  	grid_Invalidate(Win,grid_area(Row,Row,1,1)),!.
  replace_timer(Row,""):-
  	stop_entry(Row),
  	stop_timer(Row),
  	grid_win(Win),
	grid_Invalidate(Win,grid_area(Row,Row,1,1)),!.
  replace_timer(Row,Timer):-
  	not(str_int(Timer,_)),
  	dlg_error("Timer value must be integer!"),
  	stop_entry(Row),
  	stop_timer(Row),
  	grid_win(Win),
	grid_Invalidate(Win,grid_area(Row,Row,1,1)),!.
  replace_timer(Row,Timer):-
  	assert(uri_entry(Row,"","",Timer,setts("2",b_false,notify_setts([],""),"",auth(0,$[0x4F,0x67,0x3D,0x3D,0x00])),stat(""),color_White,color_Blue)).
  	  	
  stop_entry(Row):-
  	retract(uri_entry(Row,"",Uri,_,Path,Levels,Color1,Color2)),
	assert(uri_entry(Row,"",Uri,"",Path,Levels,Color1,Color2)),!.
  stop_entry(Row):-
  	retract(uri_entry(Row,_,Uri,_,Path,Levels,Color1,Color2)),
	assert(uri_entry(Row,"Stop",Uri,"",Path,Levels,Color1,Color2)),!.
	
  test_uri_entry(Row):-
  	retractall(already_req(Row,_,_,_)),
  	retractall(file_refs(Row,_,_,_)),
  	done_lst(Row,_),
  	retract(done_lst(Row,_)),
  	make_done_lst(),fail.
  test_uri_entry(Row):-
  	uri_entry(Row,_,_,_,setts(_,_,_,Dir,_),_,_,_),
  	Dir <> "",
  	trap(diropen(Dir,0x10,_Bl),_,true),
  	trap(dirclose(_Bl),_,true),
  	format(Str,"Clear directory\n %s?",Dir),
	resp_default = dlg_Ask("Attention!",Str,["&Yes","&No"]),
	format(P,"%s",Dir),
	del_dirry(P),!.
  test_uri_entry(_).
  	  	
  get_cell(Row,1,textatr(Status,Fg_Col,Bg_Col)):-
	uri_entry(Row,Status,_,_,_,_,Fg_Col,Bg_Col),!.
  get_cell(Row,2,textatr(Uri,Fg_Col,Bg_Col)):-
	uri_entry(Row,_,Uri,_,_,_,Fg_Col,Bg_Col),!.
  get_cell(Row,3,textatr(NextTimer,Fg_Col,Bg_Col)):-
  	uri_entry(Row,"Wait",_,_,_,_,Fg_Col,Bg_Col),
	grid_win(Gwin),
  	grid_Marker(Gwin,Marker),
	test_marker(Row,Marker),
	row_next_timer(Row,NextTimer),!.
  get_cell(Row,3,textatr(Timer,Fg_Col,Bg_Col)):-
	uri_entry(Row,_,_,Timer,_,_,Fg_Col,Bg_Col),!.
  get_cell(_Row,4,textatr("Entry Settings",color_Black,Value)):-
  	Value = vpi_GetAttrVal(attr_color_btnface),!.
  get_cell(_,_,empty_answer).
  
  get_row_cells(_Row,Fr_col,To_col,[]):-
  	Fr_col > To_col,!.
  get_row_cells(Row,Fr_col,To_col,[Res|Cells]):-
  	get_cell(Row,Fr_col,Res),
  	FC = Fr_col + 1,!,
  	get_row_cells(Row,FC,To_col,Cells).
  	
  get_cells(Fr_row,To_row,_Fr_col,_To_col,[]):-
  	Fr_row > To_row,!.
  get_cells(Fr_row,To_row,Fr_col,To_col,[Res|Cells]):-
  	get_row_cells(Fr_row,Fr_col,To_col,Res),
  	FR = Fr_row + 1,!,
  	get_cells(FR,To_row,Fr_col,To_col,Cells).
  	
  set_sel(RowB,RowE):-
  	RowB > RowE,!.
  set_sel(RowB,RowE):-
  	retract(uri_entry(RowB,Stat,Uri,Timer,Settgs,Stats,_,_)),!,
 	assert(uri_entry(RowB,Stat,Uri,Timer,Settgs,Stats,color_White,color_Blue)),
 	R = RowB + 1,!,
 	set_sel(R,RowE).
  set_sel(RowB,RowE):-
  	assert(uri_entry(RowB,"","","",setts("2",b_false,notify_setts([],""),"",auth(0,$[0x4F,0x67,0x3D,0x3D,0x00])),stat(""),color_White,color_Blue)),
 	R = RowB + 1,!,
 	set_sel(R,RowE).
 	
  set_desel(RowB,RowE):-
  	RowB > RowE,!.
  set_desel(RowB,RowE):-
	retract(uri_entry(RowB,Stat,Uri,Timer,Settgs,Stats,_,_)),!,
 	assert(uri_entry(RowB,Stat,Uri,Timer,Settgs,Stats,color_Black,0xC0DCC0)),
 	R = RowB + 1,!,
 	set_desel(R,RowE).
  set_desel(RowB,RowE):-
 	R = RowB + 1,!,
 	set_desel(R,RowE).	
 
  is_selected():-
  	retract(uri_entry(Row,Stat,Uri,Timer,Path,Levels,color_White,color_Blue)),
	  	assert(uri_entry(Row,Stat,Uri,Timer,Path,Levels,color_Black,0xC0DCC0)),
	  	grid_win(G_win),
	  	grid_Invalidate(G_win,grid_area(Row,Row,1,4)),
	fail.
  is_selected().
 	
  delete_rows(RowB,RowE):-
  	RowB > RowE,!.
  delete_rows(RowB,RowE):-
  	retract(uri_entry(RowB,_,_,_,_,_,_,_)),!,
  	is_timer(RowB),  	
  	R = RowB + 1,
  	delete_rows(R,RowE).
  delete_rows(RowB,RowE):-
  	R = RowB + 1,
  	is_timer(RowB),
  	delete_rows(R,RowE).
  
  is_timer(Row):-
  	retractall(row_lboxwin(Row,_)),
  	retractall(done_lst(Row,_)),
  	retractall(already_req(Row,_,_,_)),
  	retractall(row_remote(Row,_,_,_,_)),
  	retractall(to_conn(_,Row,_,_,_)),
	retractall(to_answer_http(Row,_,_,_)),
	retractall(to_send_req(Row,_,_,_)),
	retractall(row_next_timer(Row,_)),
  	retract(row_timer(Row,T_id,_)),
	timer_Kill(T_id),!.
  is_timer(_).
  	
  renum_entry(Beg,Kolvo):-
  	R = Kolvo + Beg,
  	retract(uri_entry(R,Status,Uri,Timer,Setts,Stat,FC,BC)),!,
  	assert(uri_entry(Beg,Status,Uri,Timer,Setts,Stat,FC,BC)),
  	B1 = Beg + 1,
  	renum_entry(B1,Kolvo).
  renum_entry(_,_).	
 
  color_renum_entry(Beg,End):-
  	End < Beg,!.
  color_renum_entry(Beg,End):-
  	retract(uri_entry(End,Status,Uri,Timer,Setts,Stat,_,_)),!,
  	assert(uri_entry(End,Status,Uri,Timer,Setts,Stat,color_White,color_Blue)),
  	E = End - 1,
  	color_renum_entry(Beg,E).
  color_renum_entry(Beg,End):-
  	assert(uri_entry(End,"","","",setts("2",b_false,notify_setts([],""),"",auth(0,$[0x4F,0x67,0x3D,0x3D,0x00])),stat(""),color_White,color_Blue)),
  	E = End - 1,
  	color_renum_entry(Beg,E).
	
  proc_state(Row,"Stop"):-  /*stop timer, stop fetching*/
  	stop_timer(Row),
	stop_fetch(Row),
  	!.
  proc_state(Row,"Wait"):-  /*stop fetching, run timer*/
  	stop_fetch(Row),
  	stop_timer(Row),
  	test_entry_timer(Row),
  	!.
  proc_state(Row,"Fetch"):- /*stop timer, run fetch*/
  	stop_fetch(Row),
  	stop_timer(Row),
  	start_fetch(Row),!.
  	
  test_marker(Row,grid_edit_cell(Row,3)):-!,fail.
  test_marker(_,_).