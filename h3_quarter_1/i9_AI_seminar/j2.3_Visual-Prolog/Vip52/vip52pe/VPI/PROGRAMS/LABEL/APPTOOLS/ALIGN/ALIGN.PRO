/******************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:	Label Expert
 FileName:	ALIGN.PRO
 Purpose:	Owner draw buttons for aligning layout
 Written by:	Sergey Alexeev
 Build:		008.981112
 Comments:
******************************************************************************/
constants
  align_left_align	= 1
  align_top_align	= 2
  align_right_align	= 3
  align_bottom_align	= 4
  align_center_hor	= 5
  align_center_ver	= 6
  align_divider_hor	= 7
  align_divider_ver	= 8
  align_equal_hor	= 9
  align_equal_ver	= 10
  align_equal_all	= 11
database - align_db
  determ align_info(WINDOW ParentWin,WINDOW AlignWin,ALIGN_CALLBACK)
predicates
  align_tb_callback : TOOLBAR_ACTION_FUNC
  alignwin_eh : EHANDLER
clauses
  align_create(_,_,_,AlignWin):-
	align_info(_,AlignWin,_),!.
  align_create(Parent,pnt(L,T),CallbackFunc,AlignWin):-
	R = L + 104, B = T + 136,
	AlignWin = win_CreateDynDialog(Parent,[
	dlg(wdef(wd_ModeLess,rct(L,T,R,B),label_msg104,u_Pixels),[wsf_DlgBorder,wsf_TitleBar,wsf_Close])
	],alignwin_eh,0),

	toolbar_create(tb_inside(pnt(0,0)),0xC0C0C0,AlignWin,
[tb_ctrl(align_left_align,	pushb,	idb_left_up,idb_left_dn,idb_left_dn,		"",b_true,b_true),
tb_ctrl(align_center_hor,	pushb,	idb_cenhor_up,idb_cenhor_dn,idb_cenhor_dn,	"",b_true,b_true),
tb_ctrl(align_right_align,	pushb,	idb_right_up,idb_right_dn,idb_right_dn,		"",b_true,b_true),
new_row,
tb_ctrl(align_top_align,	pushb,	idb_top_up,idb_top_dn,idb_top_dn,		"",b_true,b_true),
tb_ctrl(align_center_ver,	pushb,	idb_cenver_up,idb_cenver_dn,idb_cenver_dn,	"",b_true,b_true),
tb_ctrl(align_bottom_align,	pushb,	idb_bottom_up,idb_bottom_dn,idb_bottom_dn,	"",b_true,b_true),
new_row,
tb_ctrl(align_equal_ver,	pushb,	idb_eqver_up,idb_eqver_dn,idb_eqver_dn,		"",b_true,b_true),
tb_ctrl(align_equal_all,	pushb,	idb_eq_up,idb_eq_dn,idb_eq_dn,			"",b_true,b_true),
tb_ctrl(align_equal_hor,	pushb,	idb_eqhor_up,idb_eqhor_dn,idb_eqhor_dn,		"",b_true,b_true),
new_row,
tb_ctrl(align_divider_hor,	pushb,	idb_divhor_up,idb_divhor_dn,idb_divhor_dn,	"",b_true,b_true),
separator,
separator,
tb_ctrl(align_divider_ver,	pushb,	idb_divver_up,idb_divver_dn,idb_divver_dn,	"",b_true,b_true)],
	align_tb_callback),
	assert(align_info(Parent,AlignWin,CallbackFunc)),!.

  alignwin_eh(_,e_EraseBackGround,0):-!.
  alignwin_eh(_,e_Update(_),0):-!.
  alignwin_eh(AlignWin,e_Destroy,0):-
	retract(align_info(_,AlignWin,CallbackFunc)),!,
	CallbackFunc(is_ToBeDestroyed),!.

  align_destroy():-
	align_info(_,AlignWin,_),
	toolbar_remove(AlignWin),
	win_Destroy(AlignWin),!.
  align_destroy().

predicates
  align_send_callback(ALIGN_PUSH)
clauses
  align_send_callback(AlignPush):-
	align_info(_,_,CallbackFunc),
	CallbackFunc(AlignPush),!.

  align_tb_callback(_,align_left_align,ctrl_value(b_true,b_true)):-
	align_send_callback(left_align),!.
  align_tb_callback(_,align_top_align,ctrl_value(b_true,b_true)):-
	align_send_callback(top_align),!.
  align_tb_callback(_,align_right_align,ctrl_value(b_true,b_true)):-
	align_send_callback(right_align),!.
  align_tb_callback(_,align_bottom_align,ctrl_value(b_true,b_true)):-
	align_send_callback(bottom_align),!.
  align_tb_callback(_,align_center_hor,ctrl_value(b_true,b_true)):-
	align_send_callback(center_hor),!.
  align_tb_callback(_,align_center_ver,ctrl_value(b_true,b_true)):-
	align_send_callback(center_ver),!.
  align_tb_callback(_,align_divider_hor,ctrl_value(b_true,b_true)):-
	align_send_callback(divider_hor),!.
  align_tb_callback(_,align_divider_ver,ctrl_value(b_true,b_true)):-
	align_send_callback(divider_ver),!.
  align_tb_callback(_,align_equal_hor,ctrl_value(b_true,b_true)):-
	align_send_callback(equal_hor),!.
  align_tb_callback(_,align_equal_ver,ctrl_value(b_true,b_true)):-
	align_send_callback(equal_ver),!.
  align_tb_callback(_,align_equal_all,ctrl_value(b_true,b_true)):-
	align_send_callback(equal_all),!.

