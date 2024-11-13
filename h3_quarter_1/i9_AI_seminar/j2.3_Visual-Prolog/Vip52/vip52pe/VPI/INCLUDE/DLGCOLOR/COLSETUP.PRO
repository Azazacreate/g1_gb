/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S 

 FileName: COLSETUP.PRO
 Purpose: Color Setup tool
 Written by: Lars Henrik Jacobsen
 Comments: To be included in color module
******************************************************************************/
ifndef colsetup_pre_included
 #Error: this file requires include: colsetup.pre
enddef 

constants
  idd_color_selection = 100
  idc_colorrect1 = 102
  idc_colorrect9 = 103
  idc_colorrect17 = 104
  idc_colorrect25 = 105
  idc_colorrect33 = 106
  idc_colorrect41 = 107
  idc_colorrect49 = 108
  idc_colorrect65 = 110
  idc_colorrect73 = 111
  idc_colorrect81 = 112
  idc_colorrect89 = 113
  idc_colorrect97 = 114
  idc_colorrect2 = 115
  idc_colorrect10 = 116
  idc_colorrect18 = 117
  idc_colorrect26 = 118
  idc_colorrect34 = 119
  idc_colorrect42 = 120
  idc_colorrect50 = 121
  idc_colorrect58 = 122
  idc_colorrect66 = 123
  idc_colorrect74 = 124
  idc_colorrect82 = 125
  idc_colorrect90 = 126
  idc_colorrect98 = 127
  idc_colorrect3 = 128
  idc_colorrect11 = 129
  idc_colorrect19 = 130
  idc_colorrect27 = 131
  idc_colorrect35 = 132
  idc_colorrect43 = 133
  idc_colorrect51 = 134
  idc_colorrect59 = 135
  idc_colorrect67 = 136
  idc_colorrect75 = 137
  idc_colorrect83 = 138
  idc_colorrect91 = 139
  idc_colorrect99 = 140
  idc_colorrect4 = 141
  idc_colorrect12 = 142
  idc_colorrect20 = 143
  idc_colorrect28 = 144
  idc_colorrect36 = 145
  idc_colorrect44 = 146
  idc_colorrect52 = 147
  idc_colorrect60 = 148
  idc_colorrect68 = 149
  idc_colorrect76 = 150
  idc_colorrect84 = 151
  idc_colorrect92 = 152
  idc_colorrect100 = 153
  idc_colorrect13 = 155
  idc_colorrect21 = 156
  idc_colorrect29 = 157
  idc_colorrect37 = 158
  idc_colorrect45 = 159
  idc_colorrect53 = 160
  idc_colorrect61 = 161
  idc_colorrect69 = 162
  idc_colorrect77 = 163
  idc_colorrect85 = 164
  idc_colorrect93 = 165
  idc_colorrect101 = 166
  idc_colorrect6 = 167
  idc_colorrect14 = 168
  idc_colorrect22 = 169
  idc_colorrect30 = 170
  idc_colorrect38 = 171
  idc_colorrect46 = 172
  idc_colorrect54 = 173
  idc_colorrect62 = 174
  idc_colorrect70 = 175
  idc_colorrect78 = 176
  idc_colorrect86 = 177
  idc_colorrect94 = 178
  idc_colorrect102 = 179
  idc_colorrect7 = 180
  idc_colorrect15 = 181
  idc_colorrect23 = 182
  idc_colorrect31 = 183
  idc_colorrect39 = 184
  idc_colorrect47 = 185
  idc_colorrect55 = 186
  idc_colorrect63 = 187
  idc_colorrect71 = 188
  idc_colorrect79 = 189
  idc_colorrect87 = 190
  idc_colorrect95 = 191
  idc_colorrect103 = 192
  idc_colorrect57 = 221
  idc_colorrect5 = 238
  idc_color_items = 193
  idc_st_red = 194
  idc_red = 195
  idc_st_green = 196
  idc_green = 197
  idc_st_blue = 198
  idc_blue = 199
  idc_lines = 200
  idc_solid = 201
  idc_apply = 202
  idc_selcolor_0 = 203
  idc_selcolor_1 = 204
  idc_st_ditems = 205
  idc_accept = 206
  idc_cancel1 = 207
  idc_patterns = 208
  idc_pat1 = 209
  idc_pat2 = 210
  idc_pat3 = 211
  idc_pat4 = 212
  idc_pat5 = 213
  idc_pat6 = 214
  idc_pat7 = 215
  idc_current_item = 216

database - color_statics_db
  selpattern_window(WINDOW,PATSTYLE) % patstyle
  active(INTEGER,DIALOG_CONTROL_ID)
  determ next_id(INTEGER)
  determ dlg_window(WINDOW)
  determ par_window(WINDOW,COLOR_CALLBACK)
  determ cmode(Integer)

database - colorz
  item(INTEGER,STRING)
  color(INTEGER,BRUSH)
  color_list(COLOR_LIST)

database - local_color_vpi_db
  cbutton(DIALOG_CONTROL_ID,INTEGER,INTEGER,INTEGER)
  pbutton(DIALOG_CONTROL_ID,PATSTYLE)

  /************************ Colsetup_FOR  *******************************/
predicates
  nondeterm colsetup_for(Integer,Integer,Integer)
clauses
  colsetup_for(J,J,K) :- J <= K.
  colsetup_for(I,J,K) :-
    J < K,
    J1 = J + 1,
    colsetup_for(I,J1,K).

predicates
procedure  get_next_id(INTEGER)
clauses
  /* Return the current next id and assert the new next as current next */
  get_next_id(ID) :-
    next_id(ID), !,
    ID1 = ID + 1,
    retractall(next_id(_)),
    assert(next_id(ID1)).
  get_next_id(0) :-
    assert(next_id(1)).


predicates
determ set_color_configuration1(WINDOW,STRING,COLOR_LIST)
clauses
  set_color_configuration1(_Win,_TITLE,[]) :- !,
	dlg_color_selection_Create(_Win).
  set_color_configuration1(W,TITLE,[elem(NAME,BRUSH)|T]) :-
	get_next_id(ID),
	assert(item(ID,NAME)),
	assert(color(ID,BRUSH)), !,
	set_color_configuration1(W,TITLE,T).
  set_color_configuration1(_W,_TITLE,_) :-
	FAIL.

clauses
  colsetup_set_configuration(WIN,TITLE,CMODE,CB,INLIST) :- !,
    assert(par_window(WIN,CB)),
    assert(color_list(INLIST)),  /* Save the input list, use if Cancel */
    assert(cmode(CMODE)),	% either 0 (simple) or 1 (current item buttons)
    set_color_configuration1(WIN,TITLE,INLIST).


predicates
determ is_edit_event(INTEGER)
clauses
  is_edit_event(idc_red) :- !.
  is_edit_event(idc_green) :- !.
  is_edit_event(idc_blue) :- !.

predicates
determ  member_of(OD_STATE,OD_ITEMSTATE)
clauses
   member_of(A,[A|_]):-!.
   member_of(A,[_|FLIST]) :-
      member_of(A,FLIST).

database - selcolor_db
  determ selected_color(COLOR)
  determ selected_pattern(PATSTYLE)
  determ old_color_button(WINDOW)
  rgb_edit_modifying(Integer)
  exist_old_color_for(integer,BRUSH)

domains
  COLZUP_A = struct color(COLOR)
  COLZUP_B = struct rgb(BYTE,BYTE,BYTE,BYTE)
  
predicates
/*procedure*/determ  colsetup_color_rgb(COLZUP_A,COLZUP_B)
clauses
  colsetup_color_rgb(A,B) :-
    B = cast(colzup_b,A).

predicates
procedure  set_selected_color(WINDOW,COLOR,BOOLEAN)
  % Assert fact "selected_color" and invalidates the "selcolor" color rectangles
clauses
  set_selected_color(_Win,_,b_true) :-
	selected_color(OLD_COLOR),
	colsetup_color_rgb(color(OLD_COLOR),rgb(RED,GREEN,BLUE,_)),
	cbutton(DIALOG_CONTROL_ID,RED,GREEN,BLUE),
	CtlW = win_GetCtlHandle(_Win,DIALOG_CONTROL_ID),
	assert(old_color_button(CtlW)),
	fail.
  set_selected_color(_Win,COLOR,_) :-
	retractall(selected_color(_)),
	assert(selected_color(COLOR)),
	fail.
  set_selected_color(_Win,_,b_true) :-
	CLRWIN = win_GetCtlHandle(_Win,idc_selcolor_0),
	win_Invalidate(CLRWIN),
%	win_Update(CLRWIN),
	fail.
  set_selected_color(_Win,_,b_true) :-
	CLRWIN = win_GetCtlHandle(_Win,idc_selcolor_1),
	win_Invalidate(CLRWIN),
%	win_Update(CLRWIN),
	fail.
  set_selected_color(_Win,_,b_true) :-
	selpattern_window(CLRWIN,_),
	  win_Invalidate(CLRWIN),
%	  win_Update(CLRWIN),
	fail.
  set_selected_color(_Win,_COLOR,b_true) :-
	retract(old_color_button(CtlW)),
ifndef os_os2
	win_Invalidate(CtlW),
elsedef
	win_Update(CtlW),
enddef
	fail.
  set_selected_color(_Win,COLOR,b_true) :-
	colsetup_color_rgb(color(COLOR),rgb(RED,GREEN,BLUE,_)),
	cbutton(DIALOG_CONTROL_ID,RED,GREEN,BLUE), % !,	% A button is found
	CtlW = win_GetCtlHandle(_Win,DIALOG_CONTROL_ID),
ifndef os_os2
	win_Invalidate(CtlW),
elsedef
	win_Update(CtlW),
enddef
	fail.
  set_selected_color(_Win,_,_).


predicates  
procedure  refresh_pattern_window(PATSTYLE)
procedure  set_selected_pattern(PATSTYLE,BOOLEAN)
procedure  init_pattern_windows(WINDOW)

clauses
  set_selected_pattern(PAT,b_false) :- !,
	retractall(selected_pattern(_)),
	assert(selected_pattern(PAT)).
  set_selected_pattern(PAT,_) :-
	selected_pattern(OLD_PAT), !,
	retractall(selected_pattern(_)),
	assert(selected_pattern(PAT)),
	refresh_pattern_window(OLD_PAT),
	refresh_pattern_window(PAT).
  set_selected_pattern(PAT,_) :-	% No previously selected pattern
	assert(selected_pattern(PAT)),
	refresh_pattern_window(PAT).

  refresh_pattern_window(PAT) :-
	selpattern_window(W,PAT), !,
	win_Invalidate(W).
%	win_Update(W).
  refresh_pattern_window(_).

  init_pattern_windows(_Win) :-
	pbutton(ID,PAT),
	  W = win_GetCtlHandle(_Win,ID),
	  assert(selpattern_window(W,PAT)),
	fail.
  init_pattern_windows(_Win).

predicates
determ get_color_rgbvalues(WINDOW,COLOR)
clauses
  get_color_rgbvalues(W,COLOR) :-  % can fail if error encountered
    REDW = win_GetCtlHandle(W,idc_red),
    GREENW = win_GetCtlHandle(W,idc_green),
    BLUEW = win_GetCtlHandle(W,idc_blue),
    RED_TXT = win_GetText(REDW),
    GREEN_TXT = win_GetText(GREENW),
    BLUE_TXT = win_GetText(BLUEW),
    trap(term_str(integer,RED,RED_TXT),_,fail),
    trap(term_str(integer,GREEN,GREEN_TXT),_,fail),
    trap(term_str(integer,BLUE,BLUE_TXT),_,fail),
    COLOR = vpi_ComposeRGB(RED,GREEN,BLUE).
  
predicates
determ draw_color_rgbvalues(WINDOW,COLOR)
clauses
  draw_color_rgbvalues(W,LCOLOR) :-
	colsetup_color_rgb(color(LCOLOR),rgb(RED,GREEN,BLUE,_)),
	REDW = win_GetCtlHandle(W,idc_red),
	GREENW = win_GetCtlHandle(W,idc_green),
	BLUEW = win_GetCtlHandle(W,idc_blue),
	term_str(byte,RED,RED_TXT),
	term_str(byte,GREEN,GREEN_TXT),
	term_str(byte,BLUE,BLUE_TXT),
	win_SetText(REDW,RED_TXT),
	win_SetText(GREENW,GREEN_TXT),
	win_SetText(BLUEW,BLUE_TXT),
	!.

predicates
procedure  draw_color_button(WINDOW,COLOR)

clauses
  draw_color_button(CtlW,Color) :-
	selected_color(Color), !,
	draw_button(CtlW,COLOR,b_true).
  draw_color_button(CtlW,Color) :-
	!,
	draw_button(CtlW,Color,b_false).

predicates
procedure  draw_pattern_button(WINDOW,PATSTYLE,RCT)
procedure  draw_pat_rect(WINDOW,PATSTYLE,RCT)

clauses
  draw_pattern_button(CtlW,Pat,RCT) :-
	selected_pattern(Pat), !,
	RCT3 = draw_3d_frame_in_rect(CtlW,RCT,b_true),
	draw_pat_rect(CtlW,Pat,RCT3).
  draw_pattern_button(CtlW,Pat,RCT) :-
	!,
	RCT3 = draw_3d_frame_in_rect(CtlW,RCT,b_false),
	draw_pat_rect(CtlW,Pat,RCT3).

  draw_pat_rect(W,PAT,RCT) :-
	selected_color(COLOR), !,
	win_SetPen(W,pen(1,ps_Solid,color_ltGray)),
	win_SetBrush(W,brush(pat_solid,color_ltGray)),
	draw_Rect(W,RCT),	% Draw background for pattern
	win_SetPen(W,pen(1,ps_Solid,COLOR)),
	win_SetBrush(W,brush(PAT,COLOR)),
	win_SetDrawMode(W,dm_CopyPen),
	draw_Rect(W,RCT).	% Draw the pattern in color
  draw_pat_rect(_W,_PAT,_RCT).
	
predicates
procedure  save_last_color(integer)
clauses
  save_last_color(ID) :-
	exist_old_color_for(ID,_), !.
  save_last_color(ID) :-
	color(ID,BRUSH), !,
	assert(exist_old_color_for(ID,BRUSH)).
  save_last_color(_).

predicates
procedure  restore_old_color_for(integer)

clauses
  restore_old_color_for(ID) :-
	exist_old_color_for(ID,BRUSH), !,
	retractall(color(ID,_)),
	assert(color(ID,BRUSH)).
  restore_old_color_for(_).

predicates
determ get_item_cbrush(WINDOW,INTEGER,INTEGER,STRING,BRUSH)
clauses
  get_item_cbrush(W,CID,ID,ITEM,BRUSH) :-
	LBWIN = win_GetCtlHandle(W,CID),
	ID = lbox_GetSelIndex(LBWIN),
	ITEM = lbox_GetItem(LBWIN,ID),
	get_color_rgbvalues(W,COLOR),  % can fail if error encountered
	selected_pattern(PAT), !,
	BRUSH = brush(PAT,COLOR).


predicates
procedure  cancel_last_active
clauses
  cancel_last_active :-
	active(ID,_), !,
	restore_old_color_for(ID).
  cancel_last_active.

predicates  
procedure  update_pred(WINDOW,COLOR)
clauses
  update_pred(W,COLOR) :-
	RCT = win_GetClientRect(W),
	RCT3 = draw_3d_frame_in_rect(W,RCT,b_false),
	RCT3 = rct(L,T,R,B),
	win_SetPen(W,pen(1,ps_Solid,COLOR)),	% Width is 2*32
	R1 = R - 1, 
	colsetup_for(I,L,R1),
	  draw_Line(W,pnT(I,T),pnT(I,B)),	% Draw the pen-style area
	fail.
  update_pred(_W,_COLOR).

predicates  
determ get_color(INTEGER,BRUSH)
clauses
  get_color(ID,BRUSH) :-
	color(ID,BRUSH), !.
  get_color(ID,_) :- !,
	format(STR,"No color for ID % found",ID),
	dlg_Note(STR),
	fail.

predicates
determ show_stuff_for_display_item(WINDOW,Integer)
clauses
  show_stuff_for_display_item(_Win,ID) :-
	cancel_last_active,
	get_color(ID,brush(PAT,COLOR)),
	draw_color_rgbvalues(_Win,COLOR),
	set_selected_pattern(PAT,b_true),
	set_selected_color(_Win,COLOR,b_true).

predicates
procedure  init_list_box(WINDOW,INTEGER)
procedure  init_list_box1(WINDOW)
clauses
  init_list_box(W,ID) :-
    LBWIN = win_GetCtlHandle(W,ID),
    lbox_Clear(LBWIN),
    lbox_Suspend(LBWIN),
    init_list_box1(LBWIN),
    lbox_SetSel(LBWIN,0,b_true),
    lbox_Resume(LBWIN).

  init_list_box1(W) :-
    item(_,NAME),
      lbox_Add(W, -1, NAME),  /* add at the end */
    fail.
  init_list_box1(_).

ifdef test_ownerdraw
predicates
procedure  state_txt(OD_ITEMSTATE,Integer,OD_ITEMSTATE,String,String)
clauses
  state_txt(ItemState,N,[odstate_Selected|T],S0,S1) :-
	member_of(odstate_Selected,ItemState), !,
	N1 = N + 1,
	format(S,"% - item is selected",S0),
	state_txt(ItemState,N1,T,S,S1).
  state_txt(ItemState,N,[odstate_Grayed|T],S0,S1) :-
	member_of(odstate_Grayed,ItemState), !,
	N1 = N + 1,
	format(S,"% - item is to be grayed( only for menus )",S0),
	state_txt(ItemState,N1,T,S,S1).
  state_txt(ItemState,N,[odstate_Disabled|T],S0,S1) :-
	member_of(odstate_Disabled,ItemState), !,
	N1 = N + 1,
	format(S,"% - item is disabled",S0),
	state_txt(ItemState,N1,T,S,S1).
  state_txt(ItemState,N,[odstate_Checked|T],S0,S1) :-
	member_of(odstate_Checked,ItemState), !,
	N1 = N + 1,
	format(S,"% - item is to be checked( only for menus )",S0),
	state_txt(ItemState,N1,T,S,S1).
  state_txt(ItemState,N,[odstate_Focus|T],S0,S1) :-
	member_of(odstate_Focus,ItemState), !,
	N1 = N + 1,
	format(S,"% - item has focus",S0),
	state_txt(ItemState,N1,T,S,S1).
  state_txt(_ItemState,_N,[],S,S) :- !.
  state_txt(ItemState,N,[_|T],S,S1) :-
	state_txt(ItemState,N,T,S,S1).
enddef

%BEGIN_DLG Color Selection
/**************************************************************************
        Creation and event handling for dialog: "Color Selection"
	Code style: Dynamic Dialog
**************************************************************************/

clauses
  /* Different shades of red; light at the top and dark at the bottom */
  cbutton(idc_colorrect1,255,192,192).
  cbutton(idc_colorrect2,255,128,128).
  cbutton(idc_colorrect3,255, 64, 64).
  cbutton(idc_colorrect4,255,  0,  0).
  cbutton(idc_colorrect5,192,  0,  0).
  cbutton(idc_colorrect6,128,  0,  0).
  cbutton(idc_colorrect7, 64,  0,  0).

  /* Different shades of orange; light at the top and dark at the bottom */
  cbutton(idc_colorrect9,255,192,128).
  cbutton(idc_colorrect10,255,176, 96).
  cbutton(idc_colorrect11,255,160, 64).
  cbutton(idc_colorrect12,255,128,  0).
  cbutton(idc_colorrect13,192, 96,  0).
  cbutton(idc_colorrect14,160, 80,  0).
  cbutton(idc_colorrect15,128, 64,  0).

  /* Different shades of yellow; light at the top and dark at the bottom */
  cbutton(idc_colorrect17,255,255,192).
  cbutton(idc_colorrect18,255,255,128).
  cbutton(idc_colorrect19,255,255, 64).
  cbutton(idc_colorrect20,255,255,  0).
  cbutton(idc_colorrect21,192,192,  0).
  cbutton(idc_colorrect22,128,128,  0).
  cbutton(idc_colorrect23, 64, 64,  0).

  /* Different shades of greenish/yellow; light at the top and dark at the bottom */
  cbutton(idc_colorrect25,192,255,128).
  cbutton(idc_colorrect26,176,255, 96).
  cbutton(idc_colorrect27,160,255, 64).
  cbutton(idc_colorrect28,128,255,  0).
  cbutton(idc_colorrect29, 96,192,  0).
  cbutton(idc_colorrect30, 80,160,  0).
  cbutton(idc_colorrect31, 64,128,  0).

  /* Different shades of green; light at the top and dark at the bottom */
  cbutton(idc_colorrect33,192,255,192).
  cbutton(idc_colorrect34,128,255,128).
  cbutton(idc_colorrect35, 64,255, 64).
  cbutton(idc_colorrect36,  0,255,  0).
  cbutton(idc_colorrect37,  0,192,  0).
  cbutton(idc_colorrect38,  0,128,  0).
  cbutton(idc_colorrect39,  0, 64,  0).

  /* Different shades of greenish/magenta; light at the top and dark at the bottom */
  cbutton(idc_colorrect41,128,255,192).
  cbutton(idc_colorrect42, 96,255,176).
  cbutton(idc_colorrect43, 64,255,160).
  cbutton(idc_colorrect44,  0,255,128).
  cbutton(idc_colorrect45,  0,192, 96).
  cbutton(idc_colorrect46,  0,160, 80).
  cbutton(idc_colorrect47,  0,128, 64).

  /* Different shades of magenta; light at the top and dark at the bottom */
  cbutton(idc_colorrect49,192,255,255).
  cbutton(idc_colorrect50,128,255,255).
  cbutton(idc_colorrect51, 64,255,255).
  cbutton(idc_colorrect52,  0,255,255).
  cbutton(idc_colorrect53,  0,192,192).
  cbutton(idc_colorrect54,  0,128,128).
  cbutton(idc_colorrect55,  0, 64, 64).

  /* Different shades of blueish/magenta; light at the top and dark at the bottom */
  cbutton(idc_colorrect57,128,192,255).
  cbutton(idc_colorrect58, 96,176,255).
  cbutton(idc_colorrect59, 64,160,255).
  cbutton(idc_colorrect60,  0,128,255).
  cbutton(idc_colorrect61,  0, 96,192).
  cbutton(idc_colorrect62,  0, 80,160).
  cbutton(idc_colorrect63,  0, 64,128).

  /* Different shades of blue; light at the top and dark at the bottom */
  cbutton(idc_colorrect65,192,192,255).
  cbutton(idc_colorrect66,128,128,255).
  cbutton(idc_colorrect67, 64, 64,255).
  cbutton(idc_colorrect68,  0,  0,255).
  cbutton(idc_colorrect69,  0,  0,192).
  cbutton(idc_colorrect70,  0,  0,128).
  cbutton(idc_colorrect71,  0,  0, 64).

  /* Different shades of blueish/cyan; light at the top and dark at the bottom */
  cbutton(idc_colorrect73,192,128,255).
  cbutton(idc_colorrect74,176, 96,255).
  cbutton(idc_colorrect75,160, 64,255).
  cbutton(idc_colorrect76,128,  0,255).
  cbutton(idc_colorrect77, 96,  0,192).
  cbutton(idc_colorrect78, 80,  0,160).
  cbutton(idc_colorrect79, 64,  0,128).

  /* Different shades of cyan; light at the top and dark at the bottom */
  cbutton(idc_colorrect81,255,192,255).
  cbutton(idc_colorrect82,255,128,255).
  cbutton(idc_colorrect83,255, 64,255).
  cbutton(idc_colorrect84,255,  0,255).
  cbutton(idc_colorrect85,192,  0,192).
  cbutton(idc_colorrect86,128,  0,128).
  cbutton(idc_colorrect87, 64,  0, 64).

  /* Different shades of reddish/cyan; light at the top and dark at the bottom */
  cbutton(idc_colorrect89,255,128,192).
  cbutton(idc_colorrect90,255, 96,176).
  cbutton(idc_colorrect91,255, 64,160).
  cbutton(idc_colorrect92,255,  0,128).
  cbutton(idc_colorrect93,192,  0, 96).
  cbutton(idc_colorrect94,160,  0, 80).
  cbutton(idc_colorrect95,128,  0, 64).

  /* Different shades of gray; light at the top and dark at the bottom */
  cbutton(idc_colorrect97,255,255,255).
  cbutton(idc_colorrect98,192,192,192).
  cbutton(idc_colorrect99,160,160,160).
  cbutton(idc_colorrect100,128,128,128).
  cbutton(idc_colorrect101, 96, 96, 96).
  cbutton(idc_colorrect102, 64, 64, 64).
  cbutton(idc_colorrect103,  0,  0,  0).

  /* Patterns */
  pbutton(idc_pat1,pat_Solid).
  pbutton(idc_pat2,pat_Horz).
  pbutton(idc_pat3,pat_Vert).
  pbutton(idc_pat4,pat_FDiag).
  pbutton(idc_pat5,pat_BDiag).
  pbutton(idc_pat6,pat_Cross).
  pbutton(idc_pat7,pat_DiagCross).

constants

%BEGIN Color Selection, CreateParms, 12:38:21-1.3.1995, DO NOT edit this block of code!
  dlg_color_selection_DlgType = wd_Modal
  dlg_color_selection_Title = "Color Selection"
  dlg_color_selection_RCT = rct(78,38,400,237)
  dlg_color_selection_Flags = [wsf_Close,wsf_TitleBar]
  dlg_color_selection_Font = "MS Sans Serif"
  dlg_color_selection_FSize = 8
%END Color Selection, CreateParms


predicates
procedure  adjust_ui_for_cmode(WINDOW)
clauses
  adjust_ui_for_cmode(_Win) :-
	cmode(0), !,	% Simple mode, hide current item buttons
	W1 = win_GetCtlHandle(_Win,idc_apply),
	W2 = win_GetCtlHandle(_Win,idc_accept),
	W3 = win_GetCtlHandle(_Win,idc_cancel1),
	W4 = win_GetCtlHandle(_Win,idc_current_item),
	win_SetState(W1,[wsf_Invisible]),
	win_SetState(W2,[wsf_Invisible]),
	win_SetState(W3,[wsf_Invisible]),
	win_SetState(W4,[wsf_Invisible]).
	
  adjust_ui_for_cmode(_Win).
  
predicates
  dlg_color_selection_eh : EHANDLER
clauses
  dlg_color_selection_Create(W):-
  	retractall(_,selcolor_db),
	win_CreateDynDialog(W,
		[
%BEGIN Color Selection, WinDefList, 16:11:17-1.3.1995, DO NOT edit this block of code!
		 dlg_font(wdef(dlg_color_selection_DlgType,dlg_color_selection_RCT,dlg_color_selection_Title,u_DlgBase),
		 	  dlg_color_selection_Font,dlg_color_selection_FSize,dlg_color_selection_Flags),
		 ctl(wdef(wc_PushButton,rct(8,170,63,182),"OK",u_DlgBase),idc_ok,[ctl_Default,ctl_Group,ctl_TabStop]),
		 ctl(wdef(wc_PushButton,rct(68,170,123,182),"Cancel",u_DlgBase),idc_cancel,[ctl_Group,ctl_TabStop]),
		 ctl(wdef(wc_Text,rct(12,10,57,18),"Display Items",u_DlgBase),idc_st_ditems,[ctl_AlignLeft]),
		 ctl(wdef(wc_LBox,rct(12,20,118,108),"",u_DlgBase),idc_color_items,[ctl_Group,ctl_TabStop,ctl_VScroll]),
		 ctl(wdef(wc_PushButton,rct(126,12,139,25),"",u_DlgBase),idc_colorrect1,[ctl_TabStop,ctl_OwnerDraw,ctl_Group]),
		 ctl(wdef(wc_PushButton,rct(140,12,153,25),"",u_DlgBase),idc_colorrect9,[ctl_OwnerDraw]),
		 ctl(wdef(wc_PushButton,rct(154,12,167,25),"",u_DlgBase),idc_colorrect17,[ctl_OwnerDraw]),
		 ctl(wdef(wc_PushButton,rct(168,12,181,25),"",u_DlgBase),idc_colorrect25,[ctl_OwnerDraw]),
		 ctl(wdef(wc_PushButton,rct(182,12,195,25),"",u_DlgBase),idc_colorrect33,[ctl_OwnerDraw]),
		 ctl(wdef(wc_PushButton,rct(196,12,209,25),"",u_DlgBase),idc_colorrect41,[ctl_OwnerDraw]),
		 ctl(wdef(wc_PushButton,rct(210,12,223,25),"",u_DlgBase),idc_colorrect49,[ctl_OwnerDraw]),
		 ctl(wdef(wc_PushButton,rct(224,12,237,25),"",u_DlgBase),idc_colorrect57,[ctl_OwnerDraw]),
		 ctl(wdef(wc_PushButton,rct(238,12,251,25),"",u_DlgBase),idc_colorrect65,[ctl_OwnerDraw]),
		 ctl(wdef(wc_PushButton,rct(252,12,265,25),"",u_DlgBase),idc_colorrect73,[ctl_OwnerDraw]),
		 ctl(wdef(wc_PushButton,rct(266,12,279,25),"",u_DlgBase),idc_colorrect81,[ctl_OwnerDraw]),
		 ctl(wdef(wc_PushButton,rct(280,12,293,25),"",u_DlgBase),idc_colorrect89,[ctl_OwnerDraw]),
		 ctl(wdef(wc_PushButton,rct(294,12,307,25),"",u_DlgBase),idc_colorrect97,[ctl_OwnerDraw]),
		 ctl(wdef(wc_PushButton,rct(126,26,139,39),"",u_DlgBase),idc_colorrect2,[ctl_OwnerDraw]),
		 ctl(wdef(wc_PushButton,rct(140,26,153,39),"",u_DlgBase),idc_colorrect10,[ctl_OwnerDraw]),
		 ctl(wdef(wc_PushButton,rct(154,26,167,39),"",u_DlgBase),idc_colorrect18,[ctl_OwnerDraw]),
		 ctl(wdef(wc_PushButton,rct(168,26,181,39),"",u_DlgBase),idc_colorrect26,[ctl_OwnerDraw]),
		 ctl(wdef(wc_PushButton,rct(182,26,195,39),"",u_DlgBase),idc_colorrect34,[ctl_OwnerDraw]),
		 ctl(wdef(wc_PushButton,rct(196,26,209,39),"",u_DlgBase),idc_colorrect42,[ctl_OwnerDraw]),
		 ctl(wdef(wc_PushButton,rct(210,26,223,39),"",u_DlgBase),idc_colorrect50,[ctl_OwnerDraw]),
		 ctl(wdef(wc_PushButton,rct(224,26,237,39),"",u_DlgBase),idc_colorrect58,[ctl_OwnerDraw]),
		 ctl(wdef(wc_PushButton,rct(238,26,251,39),"",u_DlgBase),idc_colorrect66,[ctl_OwnerDraw]),
		 ctl(wdef(wc_PushButton,rct(252,26,265,39),"",u_DlgBase),idc_colorrect74,[ctl_OwnerDraw]),
		 ctl(wdef(wc_PushButton,rct(266,26,279,39),"",u_DlgBase),idc_colorrect82,[ctl_OwnerDraw]),
		 ctl(wdef(wc_PushButton,rct(280,26,293,39),"",u_DlgBase),idc_colorrect90,[ctl_OwnerDraw]),
		 ctl(wdef(wc_PushButton,rct(294,26,307,39),"",u_DlgBase),idc_colorrect98,[ctl_OwnerDraw]),
		 ctl(wdef(wc_PushButton,rct(126,40,139,53),"",u_DlgBase),idc_colorrect3,[ctl_OwnerDraw]),
		 ctl(wdef(wc_PushButton,rct(140,40,153,53),"",u_DlgBase),idc_colorrect11,[ctl_OwnerDraw]),
		 ctl(wdef(wc_PushButton,rct(154,40,167,53),"",u_DlgBase),idc_colorrect19,[ctl_OwnerDraw]),
		 ctl(wdef(wc_PushButton,rct(168,40,181,53),"",u_DlgBase),idc_colorrect27,[ctl_OwnerDraw]),
		 ctl(wdef(wc_PushButton,rct(182,40,195,53),"",u_DlgBase),idc_colorrect35,[ctl_OwnerDraw]),
		 ctl(wdef(wc_PushButton,rct(196,40,209,53),"",u_DlgBase),idc_colorrect43,[ctl_OwnerDraw]),
		 ctl(wdef(wc_PushButton,rct(210,40,223,53),"",u_DlgBase),idc_colorrect51,[ctl_OwnerDraw]),
		 ctl(wdef(wc_PushButton,rct(224,40,237,53),"",u_DlgBase),idc_colorrect59,[ctl_OwnerDraw]),
		 ctl(wdef(wc_PushButton,rct(238,40,251,53),"",u_DlgBase),idc_colorrect67,[ctl_OwnerDraw]),
		 ctl(wdef(wc_PushButton,rct(252,40,265,53),"",u_DlgBase),idc_colorrect75,[ctl_OwnerDraw]),
		 ctl(wdef(wc_PushButton,rct(266,40,279,53),"",u_DlgBase),idc_colorrect83,[ctl_OwnerDraw]),
		 ctl(wdef(wc_PushButton,rct(280,40,293,53),"",u_DlgBase),idc_colorrect91,[ctl_OwnerDraw]),
		 ctl(wdef(wc_PushButton,rct(294,40,307,53),"",u_DlgBase),idc_colorrect99,[ctl_OwnerDraw]),
		 ctl(wdef(wc_PushButton,rct(126,54,139,67),"",u_DlgBase),idc_colorrect4,[ctl_OwnerDraw]),
		 ctl(wdef(wc_PushButton,rct(140,54,153,67),"",u_DlgBase),idc_colorrect12,[ctl_OwnerDraw]),
		 ctl(wdef(wc_PushButton,rct(154,54,167,67),"",u_DlgBase),idc_colorrect20,[ctl_OwnerDraw]),
		 ctl(wdef(wc_PushButton,rct(168,54,181,67),"",u_DlgBase),idc_colorrect28,[ctl_OwnerDraw]),
		 ctl(wdef(wc_PushButton,rct(182,54,195,67),"",u_DlgBase),idc_colorrect36,[ctl_OwnerDraw]),
		 ctl(wdef(wc_PushButton,rct(196,54,209,67),"",u_DlgBase),idc_colorrect44,[ctl_OwnerDraw]),
		 ctl(wdef(wc_PushButton,rct(210,54,223,67),"",u_DlgBase),idc_colorrect52,[ctl_OwnerDraw]),
		 ctl(wdef(wc_PushButton,rct(224,54,237,67),"",u_DlgBase),idc_colorrect60,[ctl_OwnerDraw]),
		 ctl(wdef(wc_PushButton,rct(238,54,251,67),"",u_DlgBase),idc_colorrect68,[ctl_OwnerDraw]),
		 ctl(wdef(wc_PushButton,rct(252,54,265,67),"",u_DlgBase),idc_colorrect76,[ctl_OwnerDraw]),
		 ctl(wdef(wc_PushButton,rct(266,54,279,67),"",u_DlgBase),idc_colorrect84,[ctl_OwnerDraw]),
		 ctl(wdef(wc_PushButton,rct(280,54,293,67),"",u_DlgBase),idc_colorrect92,[ctl_OwnerDraw]),
		 ctl(wdef(wc_PushButton,rct(294,54,307,67),"",u_DlgBase),idc_colorrect100,[ctl_OwnerDraw]),
		 ctl(wdef(wc_PushButton,rct(126,68,139,81),"",u_DlgBase),idc_colorrect5,[ctl_OwnerDraw]),
		 ctl(wdef(wc_PushButton,rct(140,68,153,81),"",u_DlgBase),idc_colorrect13,[ctl_OwnerDraw]),
		 ctl(wdef(wc_PushButton,rct(154,68,167,81),"",u_DlgBase),idc_colorrect21,[ctl_OwnerDraw]),
		 ctl(wdef(wc_PushButton,rct(168,68,181,81),"",u_DlgBase),idc_colorrect29,[ctl_OwnerDraw]),
		 ctl(wdef(wc_PushButton,rct(182,68,195,81),"",u_DlgBase),idc_colorrect37,[ctl_OwnerDraw]),
		 ctl(wdef(wc_PushButton,rct(196,68,209,81),"",u_DlgBase),idc_colorrect45,[ctl_OwnerDraw]),
		 ctl(wdef(wc_PushButton,rct(210,68,223,81),"",u_DlgBase),idc_colorrect53,[ctl_OwnerDraw]),
		 ctl(wdef(wc_PushButton,rct(224,68,237,81),"",u_DlgBase),idc_colorrect61,[ctl_OwnerDraw]),
		 ctl(wdef(wc_PushButton,rct(238,68,251,81),"",u_DlgBase),idc_colorrect69,[ctl_OwnerDraw]),
		 ctl(wdef(wc_PushButton,rct(252,68,265,81),"",u_DlgBase),idc_colorrect77,[ctl_OwnerDraw]),
		 ctl(wdef(wc_PushButton,rct(266,68,279,81),"",u_DlgBase),idc_colorrect85,[ctl_OwnerDraw]),
		 ctl(wdef(wc_PushButton,rct(280,68,293,81),"",u_DlgBase),idc_colorrect93,[ctl_OwnerDraw]),
		 ctl(wdef(wc_PushButton,rct(294,68,307,81),"",u_DlgBase),idc_colorrect101,[ctl_OwnerDraw]),
		 ctl(wdef(wc_PushButton,rct(126,82,139,95),"",u_DlgBase),idc_colorrect6,[ctl_OwnerDraw]),
		 ctl(wdef(wc_PushButton,rct(140,82,153,95),"",u_DlgBase),idc_colorrect14,[ctl_OwnerDraw]),
		 ctl(wdef(wc_PushButton,rct(154,82,167,95),"",u_DlgBase),idc_colorrect22,[ctl_OwnerDraw]),
		 ctl(wdef(wc_PushButton,rct(168,82,181,95),"",u_DlgBase),idc_colorrect30,[ctl_OwnerDraw]),
		 ctl(wdef(wc_PushButton,rct(182,82,195,95),"",u_DlgBase),idc_colorrect38,[ctl_OwnerDraw]),
		 ctl(wdef(wc_PushButton,rct(196,82,209,95),"",u_DlgBase),idc_colorrect46,[ctl_OwnerDraw]),
		 ctl(wdef(wc_PushButton,rct(210,82,223,95),"",u_DlgBase),idc_colorrect54,[ctl_OwnerDraw]),
		 ctl(wdef(wc_PushButton,rct(224,82,237,95),"",u_DlgBase),idc_colorrect62,[ctl_OwnerDraw]),
		 ctl(wdef(wc_PushButton,rct(238,82,251,95),"",u_DlgBase),idc_colorrect70,[ctl_OwnerDraw]),
		 ctl(wdef(wc_PushButton,rct(252,82,265,95),"",u_DlgBase),idc_colorrect78,[ctl_OwnerDraw]),
		 ctl(wdef(wc_PushButton,rct(266,82,279,95),"",u_DlgBase),idc_colorrect86,[ctl_OwnerDraw]),
		 ctl(wdef(wc_PushButton,rct(280,82,293,95),"",u_DlgBase),idc_colorrect94,[ctl_OwnerDraw]),
		 ctl(wdef(wc_PushButton,rct(294,82,307,95),"",u_DlgBase),idc_colorrect102,[ctl_OwnerDraw]),
		 ctl(wdef(wc_PushButton,rct(126,96,139,109),"",u_DlgBase),idc_colorrect7,[ctl_OwnerDraw]),
		 ctl(wdef(wc_PushButton,rct(140,96,153,109),"",u_DlgBase),idc_colorrect15,[ctl_OwnerDraw]),
		 ctl(wdef(wc_PushButton,rct(154,96,167,109),"",u_DlgBase),idc_colorrect23,[ctl_OwnerDraw]),
		 ctl(wdef(wc_PushButton,rct(168,96,181,109),"",u_DlgBase),idc_colorrect31,[ctl_OwnerDraw]),
		 ctl(wdef(wc_PushButton,rct(182,96,195,109),"",u_DlgBase),idc_colorrect39,[ctl_OwnerDraw]),
		 ctl(wdef(wc_PushButton,rct(196,96,209,109),"",u_DlgBase),idc_colorrect47,[ctl_OwnerDraw]),
		 ctl(wdef(wc_PushButton,rct(210,96,223,109),"",u_DlgBase),idc_colorrect55,[ctl_OwnerDraw]),
		 ctl(wdef(wc_PushButton,rct(224,96,237,109),"",u_DlgBase),idc_colorrect63,[ctl_OwnerDraw]),
		 ctl(wdef(wc_PushButton,rct(238,96,251,109),"",u_DlgBase),idc_colorrect71,[ctl_OwnerDraw]),
		 ctl(wdef(wc_PushButton,rct(252,96,265,109),"",u_DlgBase),idc_colorrect79,[ctl_OwnerDraw]),
		 ctl(wdef(wc_PushButton,rct(266,96,279,109),"",u_DlgBase),idc_colorrect87,[ctl_OwnerDraw]),
		 ctl(wdef(wc_PushButton,rct(280,96,293,109),"",u_DlgBase),idc_colorrect95,[ctl_OwnerDraw]),
		 ctl(wdef(wc_PushButton,rct(294,96,307,109),"",u_DlgBase),idc_colorrect103,[ctl_OwnerDraw]),
		 ctl(wdef(wc_Text,rct(12,118,39,126),"Patterns",u_DlgBase),idc_patterns,[ctl_AlignLeft]),
		 ctl(wdef(wc_PushButton,rct(16,128,29,141),"",u_DlgBase),idc_pat1,[ctl_TabStop,ctl_OwnerDraw,ctl_Group]),
		 ctl(wdef(wc_PushButton,rct(30,128,43,141),"",u_DlgBase),idc_pat2,[ctl_OwnerDraw]),
		 ctl(wdef(wc_PushButton,rct(44,128,57,141),"",u_DlgBase),idc_pat3,[ctl_OwnerDraw]),
		 ctl(wdef(wc_PushButton,rct(58,128,71,141),"",u_DlgBase),idc_pat4,[ctl_OwnerDraw]),
		 ctl(wdef(wc_PushButton,rct(72,128,85,141),"",u_DlgBase),idc_pat5,[ctl_OwnerDraw]),
		 ctl(wdef(wc_PushButton,rct(86,128,99,141),"",u_DlgBase),idc_pat6,[ctl_OwnerDraw]),
		 ctl(wdef(wc_PushButton,rct(100,128,113,141),"",u_DlgBase),idc_pat7,[ctl_OwnerDraw]),
		 ctl(wdef(wc_Text,rct(256,114,279,122),"Red:",u_DlgBase),idc_st_red,[ctl_AlignRight]),
		 ctl(wdef(wc_Edit,rct(280,112,306,124),"",u_DlgBase),idc_red,[ctl_Group,ctl_TabStop,ctl_AutoHScroll,ctl_AlignLeft]),
		 ctl(wdef(wc_Text,rct(256,128,279,136),"Green:",u_DlgBase),idc_st_green,[ctl_AlignRight]),
		 ctl(wdef(wc_Edit,rct(280,126,306,138),"",u_DlgBase),idc_green,[ctl_Group,ctl_TabStop,ctl_AutoHScroll,ctl_AlignLeft]),
		 ctl(wdef(wc_Text,rct(256,142,279,150),"Blue:",u_DlgBase),idc_st_blue,[ctl_AlignRight]),
		 ctl(wdef(wc_Edit,rct(280,140,306,152),"",u_DlgBase),idc_blue,[ctl_Group,ctl_TabStop,ctl_AutoHScroll,ctl_AlignLeft]),
		 ctl(wdef(wc_Text,rct(142,144,160,152),"Lines",u_DlgBase),idc_lines,[ctl_AlignLeft]),
		 ctl(wdef(wc_Text,rct(172,144,189,152),"Solid",u_DlgBase),idc_solid,[ctl_AlignLeft]),
		 ctl(wdef(wc_PushButton,rct(164,110,196,142),"",u_DlgBase),idc_selcolor_0,[ctl_Group,ctl_OwnerDraw,ctl_Disabled]),
		 ctl(wdef(wc_PushButton,rct(132,110,164,142),"",u_DlgBase),idc_selcolor_1,[ctl_Group,ctl_OwnerDraw,ctl_Disabled]),
		 ctl(wdef(wc_GroupBox,rct(130,158,306,189),"Current Item",u_DlgBase),idc_current_item,[]),
		 ctl(wdef(wc_PushButton,rct(136,170,186,182),"Accept",u_DlgBase),idc_accept,[ctl_Group,ctl_TabStop]),
		 ctl(wdef(wc_PushButton,rct(193,170,243,182),"Cancel",u_DlgBase),idc_cancel1,[ctl_Group,ctl_TabStop]),
		 ctl(wdef(wc_PushButton,rct(250,170,300,182),"Apply",u_DlgBase),idc_apply,[ctl_Group,ctl_TabStop])
%END Color Selection, WinDefList
		],dlg_color_selection_eh,0),!.

%BEGIN Color Selection, e_Create
  dlg_color_selection_eh(_Win,e_Create(_),0):-!,
	assert(dlg_window(_Win)),
	init_list_box(_Win,idc_color_items),	% Initialize list of display items and select item 0
	init_pattern_windows(_Win),
	show_stuff_for_display_item(_Win,0),	% Show all the stuff for item 0 (color, pattern,..)
	adjust_ui_for_cmode(_Win),
	LBW = win_GetCtlHandle(_Win,idc_color_items),
	win_SetFocus(LBW),
	!.
%END Color Selection, e_Create
%BEGIN Color Selection, idc_ok _CtlInfo
  dlg_color_selection_eh(_Win,e_Control(idc_ok,_CtrlType,_CtrlWin,_CtrlInfo),0):-
	par_window(_,CB),			% Confirm all changes made to all display items
	LBWIN = win_GetCtlHandle(_Win,idc_color_items),
	ID = lbox_GetSelIndex(LBWIN),
	ITEM = lbox_GetItem(LBWIN,ID),
  	get_color_rgbvalues(_Win,COLOR),
	selected_pattern(PAT), !,
	CB(_Win,color_cb_ok,ID,ITEM,brush(PAT,COLOR)), % by calling the user's ok-callback
	win_Destroy(_Win),
	!.
  dlg_color_selection_eh(_Win,e_Control(idc_ok,_CtrlType,_CtrlWin,_CtrlInfo),0):-!, % No selection
	par_window(_,CB),
	CB(_Win,color_cb_cancel,-1,"",brush(pat_solid,0)),
	win_Destroy(_Win),
	!.
%END Color Selection, idc_ok _CtlInfo
%MARK Color Selection, new events

%BEGIN Color Selection, idc_color_items _CtlInfo
  dlg_color_selection_eh(_Win,e_Control(idc_color_items,_CtrlType,LBWIN,_CtlInfo),0):-!,
	ID = lbox_GetSelIndex(LBWIN),		% Get the ID of the chosen display item
	show_stuff_for_display_item(_Win,ID),	% and show all the stuff for it (color, pattern,..)
	!.
%END Color Selection, idc_color_items _CtlInfo
%BEGIN Color Selection, e_Destroy
  dlg_color_selection_eh(_Win,e_Destroy,0):-!,
	retractall(_,color_statics_db),
	retractall(_,colorz),
	!.
%END Color Selection, e_Destroy
%BEGIN Color Selection, idc_cancel _CtlInfo
  dlg_color_selection_eh(_Win,e_Control(idc_cancel,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	par_window(_,CB),			% Cancel all changes made to all display items
	CB(_Win,color_cb_cancel,-1,"",brush(pat_solid,0)), % by calling the user's cancel-callback
	win_Destroy(_Win),
	!.
%END Color Selection, idc_cancel _CtlInfo
%BEGIN Color Selection, idc_apply _CtlInfo
  dlg_color_selection_eh(_Win,e_Control(idc_apply,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	par_window(_,CB),			% Apply the changes to the current display item
	get_item_cbrush(_Win,idc_color_items,ID,ITEM,BRUSH), !,
	retractall(exist_old_color_for(ID,_)),
	retractall(color(ID,_)),
	assert(color(ID,BRUSH)),
	CB(_Win,color_cb_apply,ID,ITEM,BRUSH),	% by calling the user's apply callback
	!.
%END Color Selection, idc_apply _CtlInfo
%BEGIN Color Selection, idc_accept _CtlInfo
  dlg_color_selection_eh(_Win,e_Control(idc_accept,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	par_window(_,CB),			% Accept the changes to the current display item
	get_item_cbrush(_Win,idc_color_items,ID,ITEM,BRUSH), !,
	retractall(exist_old_color_for(ID,_)),
	retractall(color(ID,_)),
	assert(color(ID,BRUSH)),
	CB(_Win,color_cb_accept,ID,ITEM,BRUSH),	% by calling the user's accept callback
	!.
%END Color Selection, idc_accept _CtlInfo
%BEGIN Color Selection, idc_cancel1 _CtlInfo
  dlg_color_selection_eh(_Win,e_Control(idc_cancel1,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	LBWIN = win_GetCtlHandle(_Win,idc_color_items),	% Cancelling the changes for current item (not apply/accept)
	ID = lbox_GetSelIndex(LBWIN),		% Get the current display item
	restore_old_color_for(ID),		% and restore its old color
	get_color(ID,brush(PAT,COLOR)),
	draw_color_rgbvalues(_Win,COLOR),	% and write the Red, Green and Blue values
	set_selected_color(_Win,COLOR,b_true),	% and set the active color
	set_selected_pattern(PAT,b_true),	% and set the active pattern
	!.
%END Color Selection, idc_cancel1 _CtlInfo
%BEGIN Color Selection, idc_red modified
  dlg_color_selection_eh(_Win,e_Control(CID,_CtrlType,_CtrlWin,modified),0):-
	is_edit_event(CID), !,			% Modifying in an RGB-edit window
	rgb_edit_modifying(CID),		% and it's the user (not set by another control)
	get_color_rgbvalues(_Win,COLOR),	% then read the RGB values
	set_selected_color(_Win,COLOR,b_true),	% and set the active color
	!.
%END Color Selection, idc_red modified
%BEGIN Color Selection, idc_red getfocus
  dlg_color_selection_eh(_Win,e_Control(CID,_CtrlType,_CtrlWin,getfocus),0):-
	is_edit_event(CID), !,			% Gaining focus in an RGB-edit window
	assert(rgb_edit_modifying(CID)),	% then assert the user is modifying
	!.
%END Color Selection, idc_red getfocus
%BEGIN Color Selection, idc_red losefocus
  dlg_color_selection_eh(_Win,e_Control(CID,_CtrlType,_CtrlWin,losefocus),0):-
	is_edit_event(CID), !,			% Losing focus in an RGB-edit window
	retractall(rgb_edit_modifying(CID)),	% then the user has stopped modifying
	!.
%END Color Selection, idc_red losefocus
%BEGIN Color Selection, System handled events
%BEGIN Color Selection, e_OwnerDraw
ifdef test_ownerdraw
  dlg_color_selection_eh(_Win,e_OwnerDraw(od_Button,CID,_ItemId,[odact_DrawEntire],ItemState,CtlW,_RectItem,_ItemData),0):-
	state_txt(ItemState,0,[odstate_Selected,odstate_Grayed,odstate_Disabled,odstate_Checked,odstate_Focus],"",S1),
	format(Str,"Ownerdraw: CID=%, CtlW=% - draw entire item %",CID,CtlW,S1),
	tdebug(Str),
	FAIL.
  dlg_color_selection_eh(_Win,e_OwnerDraw(od_Button,CID,_ItemId,[odact_Focus],ItemState,CtlW,_RectItem,_ItemData),0):-
	state_txt(ItemState,0,[odstate_Selected,odstate_Grayed,odstate_Disabled,odstate_Checked,odstate_Focus],"",S1),
	format(Str,"Ownerdraw: CID=%, CtlW=% - gain focus %",CID,CtlW,S1),
	tdebug(Str),
	FAIL.
  dlg_color_selection_eh(_Win,e_OwnerDraw(od_Button,CID,_ItemId,[odact_Select],ItemState,CtlW,_RectItem,_ItemData),0):-
	state_txt(ItemState,0,[odstate_Selected,odstate_Grayed,odstate_Disabled,odstate_Checked,odstate_Focus],"",S1),
	format(Str,"Ownerdraw: CID=%, CtlW=% - selection is changed %",CID,CtlW,S1),
	tdebug(Str),
	FAIL.
enddef
  dlg_color_selection_eh(_Win,e_OwnerDraw(od_Button,idc_selcolor_0,_ItemId,[odact_DrawEntire],_ItemState,CtlW,_RectItem,_ItemData),0):-!,
	selected_color(COLOR),			% Drawing the 'solid' selected color button
	draw_button(CtlW,COLOR,b_false),	% by drawing a rectangle
	!.
  dlg_color_selection_eh(_Win,e_OwnerDraw(od_Button,idc_selcolor_1,_ItemId,[odact_DrawEntire],_ItemState,CtlW,_RectItem,_ItemData),0):-!,
	selected_color(COLOR),			% Drawing the 'lines' selected color button
	update_pred(CtlW,COLOR),		% by drawing lines
	!.

  dlg_color_selection_eh(_Win,e_OwnerDraw(od_Button,CtlId,_ItemId,[odact_DrawEntire],_ItemState,CtlW,RectItem,_ItemData),0):-
	cbutton(CtlId,Red,Green,Blue), !,	% Drawing a color button
	Color=vpi_ComposeRGB(Red,Green,Blue),
	draw_color_button(CtlW,Color)
	;
  	pbutton(CtlId,Pat), !,			% Drawing a pattern button
  	draw_pattern_button(CtlW,Pat,RectItem).

  dlg_color_selection_eh(_Win,e_OwnerDraw(od_Button,CtlId,_ItemId,[odact_Select],ItemState,_CtlW,_RectItem,_ItemData),0):-
  	member_of(odstate_Focus,ItemState),	% Focus is set
	cbutton(CtlId,Red,Green,Blue), !,	% on a color button
	Color=vpi_ComposeRGB(Red,Green,Blue),	% then decode the RGB-value
	draw_color_rgbvalues(_Win,COLOR),	% and write the Red, Green and Blue values
	set_selected_color(_Win,COLOR,b_true),	% then make the color button active
	LBWIN = win_GetCtlHandle(_Win,idc_color_items),
	ID = lbox_GetSelIndex(LBWIN),		% Get the current display item
	save_last_color(ID),			% and save the last color (if cancelling new choice)
	! ;
  	member_of(odstate_Focus,ItemState),	% Focus is set
  	pbutton(CtlId,Pat), !,			% on a pattern button
	set_selected_pattern(Pat,b_true),	% then make it active
	!.

%END Color Selection, e_OwnerDraw
%BEGIN Color Selection, e_OwnerMeasureItem
  dlg_color_selection_eh(_Win,e_OwnerMeasureItem(_CtlType,_CtlId,_ItemId,_Data),0x0A000A):-!,
	!.
%END Color Selection, e_OwnerMeasureItem

%END Color Selection, System handled events
%END_DLG Color Selection
