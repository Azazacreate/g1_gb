/******************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:	Label Expert
 FileName:	EDITMODE.PRO
 Purpose:	Owner draw buttons for layout mode change
 Written by:	Sergey Alexeev
 Build:		008.981112
 Comments:
******************************************************************************/
constants
  edit_edit_mode	= 1
  edit_text		= 2
  edit_counter		= 3
  edit_bitmap		= 4
  edit_rectangle	= 5
  edit_circle		= 6
  edit_line		= 7
database - edit_db
  determ em_info(WINDOW ParentWin,WINDOW AlignWin,EM_CALLBACK)
predicates
  em_tb_callback : TOOLBAR_ACTION_FUNC
  editwin_eh : EHANDLER
clauses
  em_create(_,_,_,EditWin):-
	em_info(_,EditWin,_),!.
  em_create(Parent,pnt(L,T),CallbackFunc,EditWin):-
	R = L + 34, B = T + 190,
	EditWin = win_CreateDynDialog(Parent,[
	dlg(wdef(wd_ModeLess,rct(L,T,R,B),"",u_Pixels),[wsf_DlgBorder,wsf_TitleBar,wsf_Disabled,wsf_Invisible])
	],editwin_eh,0),

	toolbar_create(tb_inside(pnt(0,0)),0xC0C0C0,EditWin,
[tb_ctrl(edit_edit_mode,	pushb,	idb_edit_up,idb_edit_dn,idb_edit_dn,	label_msg156,b_true,b_true),
new_row,
tb_ctrl(edit_text,	pushb,	idb_text_up,idb_text_dn,idb_text_dn,		label_msg157,b_true,b_true),
new_row,
tb_ctrl(edit_counter,	pushb,	idb_dig_up,idb_dig_dn,idb_dig_dn,		label_msg158,b_true,b_true),
new_row,
tb_ctrl(edit_bitmap,	pushb,	idb_bitmap_up,idb_bitmap_dn,idb_bitmap_dn,	label_msg159,b_true,b_true),
new_row,
tb_ctrl(edit_rectangle,	pushb,	idb_rect_up,idb_rect_dn,idb_rect_dn,		label_msg160,b_true,b_true),
new_row,
tb_ctrl(edit_circle,	pushb,	idb_circle_up,idb_circle_dn,idb_circle_dn,	label_msg161,b_true,b_true),
new_row,
tb_ctrl(edit_line,	pushb,	idb_line_up,idb_line_dn,idb_line_dn,		label_msg162,b_true,b_true)],
	em_tb_callback),

	toolbar_GroupControls(EditWin,1,
		[edit_edit_mode,edit_text,edit_counter,edit_bitmap,edit_rectangle,
		edit_circle,edit_line]),
	toolbar_SetPressedButton(EditWin,1,edit_edit_mode),

	assert(em_info(Parent,EditWin,CallbackFunc)),!.

  editwin_eh(_,e_EraseBackGround,0):-!.
  editwin_eh(_,e_Update(_),0):-!.
  editwin_eh(EditWin,e_Destroy,0):-
	retract(em_info(_,EditWin,_)),!.

  em_destroy():-
	em_info(_,EditWin,_),
	toolbar_remove(EditWin),
	win_Destroy(EditWin),!.
  em_destroy().

  em_enable():-
	em_info(_,EditWin,_),
	win_SetState(EditWin,[wsf_Enabled,wsf_Visible]),!.
  em_enable().

  em_disable():-
	em_info(_,EditWin,_),
	win_SetState(EditWin,[wsf_Disabled,wsf_Invisible]),!.
  em_disable().

  em_SetPressedButton(edit_mode):-
	em_info(_,EditWin,_),
	toolbar_SetPressedButton(EditWin,1,edit_edit_mode),!.
  em_SetPressedButton(text):-
	em_info(_,EditWin,_),
	toolbar_SetPressedButton(EditWin,1,edit_text),!.
  em_SetPressedButton(counter):-
	em_info(_,EditWin,_),
	toolbar_SetPressedButton(EditWin,1,edit_counter),!.
  em_SetPressedButton(bitmap):-
	em_info(_,EditWin,_),
	toolbar_SetPressedButton(EditWin,1,edit_bitmap),!.
  em_SetPressedButton(rectangle):-
	em_info(_,EditWin,_),
	toolbar_SetPressedButton(EditWin,1,edit_rectangle),!.
  em_SetPressedButton(circle):-
	em_info(_,EditWin,_),
	toolbar_SetPressedButton(EditWin,1,edit_circle),!.
  em_SetPressedButton(line):-
	em_info(_,EditWin,_),
	toolbar_SetPressedButton(EditWin,1,edit_line),!.

predicates
  em_send_callback(EM_PUSH)
clauses
  em_send_callback(EditPush):-
	em_info(_,_,CallbackFunc),
	CallbackFunc(EditPush),!.

  em_tb_callback(_,edit_edit_mode,ctrl_value(b_true,b_false)):-
	em_send_callback(edit_mode),!.
  em_tb_callback(_,edit_text,ctrl_value(b_true,b_false)):-
	em_send_callback(text),!.
  em_tb_callback(_,edit_counter,ctrl_value(b_true,b_false)):-
	em_send_callback(counter),!.
  em_tb_callback(_,edit_bitmap,ctrl_value(b_true,b_false)):-
	em_send_callback(bitmap),!.
  em_tb_callback(_,edit_rectangle,ctrl_value(b_true,b_false)):-
	em_send_callback(rectangle),!.
  em_tb_callback(_,edit_circle,ctrl_value(b_true,b_false)):-
	em_send_callback(circle),!.
  em_tb_callback(_,edit_line,ctrl_value(b_true,b_false)):-
	em_send_callback(line),!.
