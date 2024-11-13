/*****************************************************************************

                Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  FTPAGENT
 FileName: SET_DIR.PRO
 Purpose: Example of Winsock 1.1 and FTP
 Written by: Konstantin Ivanov
 Comments: Implementation of custom controls that are used in dialogs to select a file.
 Custom control consists of edit field and a button. Edit field shows the filename of selected file.
******************************************************************************/

include "ftpagent.inc"
include "ftpagent.con"

GLOBAL PREDICATES
  set_dir_init(WINDOW,STRING) - (i,i)
  set_dir_event_proc(WINDOW,EVENT) - (i,i)
  
CONSTANTS
  set_dir_edit_id = 7720
  set_dir_pb_id = 7721
  set_dir_edit_flags = [wsf_AutoHScroll]
  set_dir_pb_flags = []
  
DATABASE - set_dir_in
  set_dir_db(WINDOW,WINDOW,WINDOW,INTEGER Kind) %Kind=0 - default - dir;Kind=1 - open
  set_dir_but(WINDOW,INTEGER,BOOLEAN Drawn)   %b_false - not drawn 
  
PREDICATES
  sd_ed_hndl : ehandler
  sd_pb_hndl : ehandler
  sd_draw(WINDOW,INTEGER) 		- (i,i)
  sd_draw_line(WINDOW) 			- (i)
  sd_test_mouse(WINDOW,PNT) 		- (i,i)
  sd_dialog(WINDOW) 			- (i)
  sd_IsDirExist( STRING, STRING )	- (i,o)
  
CLAUSES

/*  setdir_handler(_,Ev,0):-
  	term_str(EVENT,Ev,Ev_str),
%	format(S,"Setdir %s",Ev_str),
%	dlg_note(S),fail.
	write("CC: ",Ev),nl,fail.*/
  setdir_handler(Setdir_win,e_Create(_),0):-
  	set_dir_init(Setdir_win,""),!.
  setdir_handler(Win,Ev,0):-
  	set_dir_event_proc(Win,Ev),!.
  	
  set_dir_init(Parent,InitStr):-
	RCT = win_GetClientRect( Parent ),
	RCT = rct(L,T,R,B),
	H = B - T,
	R_e = R - H,
	Sd_ed_win = win_CreateDynControl([ctl(wdef(wc_Edit,rct(L,T,R_e,B),InitStr,u_Pixels),set_dir_edit_id,set_dir_edit_flags)],Parent),
	Sd_pb_win = win_CreateDynControl([ctl(wdef(wc_PushButton,rct(R_e,T,R,B),"..",u_Pixels),set_dir_pb_id, set_dir_pb_flags)],Parent),
	retractall(set_dir_but(Sd_pb_win,_,_)),
        assert(set_dir_but(Sd_pb_win,b_false,b_false)),
	win_SetSubclassHandler(Sd_ed_win, sd_ed_hndl, b_false ),
	win_SetSubclassHandler(Sd_pb_win, sd_pb_hndl, b_true ),
	assert(set_dir_db(Parent,Sd_ed_win,Sd_pb_win,0)),
	!.
  
  set_dir_set(Setdir_win,Str):-
  	set_dir_db(Setdir_win,Sd_ed_win,_,_),
  	win_SetText(Sd_ed_win,Str),!.
  set_dir_get(Setdir_win,Str):-
  	set_dir_db(Setdir_win,Sd_ed_win,_,_),
  	Str = win_GetText(Sd_ed_win),!.
  	
  set_dir_event_proc(Setdir_win,e_Destroy):-
  	retract(set_dir_db(Setdir_win,_,Sd_pb_win,_)),
  	retractall(set_dir_but(Sd_pb_win,_,_)),
  	!.
  set_dir_event_proc(Setdir_win,e_State(font(Font))):-
  	set_dir_db(Setdir_win,Sd_ed_win,Sd_pb_win,_),
  	win_SetFont(Sd_ed_win,Font),
  	win_SetFont(Sd_pb_win,Font),
  	caret_off(Sd_ed_win),
  	!.
  set_dir_event_proc(Setdir_win,e_State(disabled())):-
  	set_dir_db(Setdir_win,Sd_ed_win,Sd_pb_win,_),
	win_SetState(Sd_ed_win, [wsf_Disabled]),
	win_SetState(Sd_pb_win, [wsf_Disabled]),
	!.
  set_dir_event_proc(Setdir_win,e_State(enabled())):-
  	set_dir_db(Setdir_win,Sd_ed_win,Sd_pb_win,_),
	win_SetState(Sd_ed_win, [wsf_Enabled]),
	win_SetState(Sd_pb_win, [wsf_Enabled]),
	!.
  set_dir_event_proc(Setdir_win,e_GetFocus()):-
  	set_dir_db(Setdir_win,Sd_ed_win,_,_),
	win_SetFocus(Sd_ed_win),!.
  set_dir_event_proc(_,_):-fail.
  
  set_dir_set_kind(Win,Kind):-
  	retract(set_dir_db(Win,A,B,_)),
  	assert(set_dir_db(Win,A,B,Kind)),!.
  
%term_str(INTEGER,State,SSS),
%dlg_note(SSS),  
%  sd_ed_hndl(_,Ev,0):-write("ED: ",Ev),nl,fail.
  sd_ed_hndl(_,_,0):-fail.
        
%  sd_pb_hndl(_,Ev,0):-write("PB: ",Ev),nl,fail.
  sd_pb_hndl(Win,e_LoseFocus,0):-
	win_ReleaseMouse(),
  	retractall(set_dir_but(Win,_,_)),
        assert(set_dir_but(Win,b_false,b_false)),!.
  sd_pb_hndl(Win,e_MouseMove(PNT,_,_),0):-
  	sd_test_mouse(Win,PNT),!.
  sd_pb_hndl(Win,e_Update(_RCT),0):-
%dlg_note("E_Update"),  
	set_dir_but(Win,State,_),
	sd_draw(Win,State),!.
  sd_pb_hndl(Win,e_MouseDown(Pnt,c_Nothing,mouse_button_left),0):-
  	RCT = win_GetClientRect( Win ),
	rect_PntInside(RCT,PNT),!,
	win_CaptureMouse(Win),
        retractall(set_dir_but(Win,_,_)),
        assert(set_dir_but(Win,b_true,b_true)),
        sd_draw(Win,b_true),
        !.
  sd_pb_hndl(Win,e_MouseUp(Pnt,c_Nothing,mouse_button_left),0):-
	win_ReleaseMouse(),
	retractall(set_dir_but(Win,_,_)),
        assert(set_dir_but(Win,b_false,b_true)),
        sd_draw(Win,b_false),
  	RCT = win_GetClientRect( Win ),
	rect_PntInside(RCT,Pnt),!,
	sd_dialog(Win),
        !.
  sd_pb_hndl(Win,e_State(enabled()),0):-
	retractall(set_dir_but(Win,_,_)),
        assert(set_dir_but(Win,0,b_true)),
  	sd_draw(Win,0),!.  	
  sd_pb_hndl(Win,e_State(disabled()),0):-
	retractall(set_dir_but(Win,_,_)),
        assert(set_dir_but(Win,2,b_true)),  
  	sd_draw(Win,2),!.
  sd_pb_hndl(_,_,0):-fail.
  
  sd_draw(Win,0):-  
	Value=vpi_GetAttrVal(attr_color_btnface),
        win_Clear(Win,Value),
        sd_draw_line(Win),
  	RCT_but = win_GetClientRect( Win ),
  	RCT_but = rct(L,T,R,B),
  	L1 = L + 3, T1 = T + 3, R1 = R - 3, B1 = B - 3,
	Set_dir_pict = pict_GetFromRes(idb_set_dir_up1),
	pict_GetSize(Set_dir_pict, W, H, _),
%	W1 = W - 1, H1 = H - 1,
	pict_Draw(Win,Set_dir_pict,rct(L1,T1,R1,B1),rct(0,0,W,H),rop_SrcCopy),
	pict_Destroy(Set_dir_pict),
	!.
  sd_draw(Win,1):-  
	Value=vpi_GetAttrVal(attr_color_btnface),
        win_Clear(Win,Value),
        sd_draw_line(Win),
  	RCT_but = win_GetClientRect( Win ),
  	RCT_but = rct(L,T,R,B),
  	L1 = L + 3, T1 = T + 3, R1 = R - 3, B1 = B - 3,
	Set_dir_pict = pict_GetFromRes(idb_set_dir_dn),
	pict_GetSize(Set_dir_pict, W, H, _),
	W1 = W - 1, H1 = H - 1,
	pict_Draw(Win,Set_dir_pict,rct(L1,T1,R1,B1),rct(0,0,W1,H1),rop_SrcCopy),
	pict_Destroy(Set_dir_pict),
	!.
  sd_draw(Win,2):-
	Value=vpi_GetAttrVal(attr_color_btnface),
        win_Clear(Win,Value),
        sd_draw_line(Win),
  	RCT_but = win_GetClientRect( Win ),
  	RCT_but = rct(L,T,R,B),
  	L1 = L + 3, T1 = T + 3, R1 = R - 3, B1 = B - 3,
	Set_dir_pict = pict_GetFromRes(idb_set_dir_dis),
	pict_GetSize(Set_dir_pict, W, H, _),
%	W1 = W - 1, H1 = H - 1,
	pict_Draw(Win,Set_dir_pict,rct(L1,T1,R1,B1),rct(0,0,W,H),rop_SrcCopy),
	pict_Destroy(Set_dir_pict),
	!.	

  sd_draw_line(Win):-
	RCT = win_GetClientRect( Win ),
	RCT = rct(L,T,R,B),
	win_SetDrawMode(Win,dm_CopyPen),
	win_SetForeColor(Win,color_Black),
        Value=vpi_GetAttrVal(attr_color_btnface),	
	win_SetBackColor(Win,Value),
	win_SetPen(Win,pen(2,ps_Solid,color_Black)),
	win_SetBrush(Win,brush(pat_Hollow,color_White)),
	win_SetBackMode(Win,bk_Opaque),
	L1=L+1,T1=T+1,R1=R-1,B1=B-1,
	draw_Line(Win,pnt(L1,B1),pnt(R1,B1)),
	draw_Line(Win,pnt(R1,T1),pnt(R1,B1)),
	win_SetPen(Win,pen(1,ps_Solid,color_White)),
	draw_Line(Win,pnt(L1,T1),pnt(R1,T1)),
	draw_Line(Win,pnt(L1,T1),pnt(L1,B1)),!.

  sd_test_mouse(Win,PNT):-
	RCT = win_GetClientRect( Win ),
	rect_PntInside(RCT,PNT),
	retract(set_dir_but(Win,b_true,b_false)),
	assert(set_dir_but(Win,b_true,b_true)),
	sd_draw(Win,b_true),!.
  sd_test_mouse(Win,PNT):-
  	RCT = win_GetClientRect( Win ),
	not(rect_PntInside(RCT,PNT)),
	retract(set_dir_but(Win,b_true,b_true)),
	assert(set_dir_but(Win,b_true,b_false)),
	sd_draw(Win,b_false),!.
  sd_test_mouse(_,_).

  sd_dialog(Win):-
	set_dir_db(_Cust,Ed,Win,0),  
	Current_path = win_GetText(Ed),
	fa_dialog(DlgWin),
        Success = dlg_GetDirectoryName(DlgWin,Current_path,NewPath),
        Success=1,!,
        win_SetText(Ed,NewPath),!.
  sd_dialog(Win):-
	set_dir_db(_,Ed,Win,1),
	Current_path = win_GetText(Ed),
	filenamepath( Current_path, Path, Name ),
	sd_IsDirExist( Path, PathToDlg ),
  	FileName = dlg_GetFileName( Name, ["All files","*.*"], "Choose file", [], PathToDlg, _FileName ),
        win_SetText( Ed, FileName ),
        !.
  sd_dialog(_).

  sd_IsDirExist( Path, Path ):-
  	str_len( Path, L ),
  	L1 = L - 1,
  	substring( Path, 1, L1, Path1 ),
  	trap(diropen( Path1, 0x10, _Bl),_,true),
  	trap(dirclose( _Bl ),_,true),
  	!.
  sd_IsDirExist( _, "" ).