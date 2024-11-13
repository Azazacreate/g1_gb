/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  DIALPACK
 FileName: DIALPACK.PRO
 Purpose: Demonstrates Dialog Pack
 Written by: Eugene Akimov
 Comments:
******************************************************************************/

include "dialpack.inc"
include "dialpack.con"
include "hlptopic.con"

facts - db
 edit_string(string)
 edit_integer(integer)
 edit_real(real)
 edit_long(long)
 item_listbox(SLIST,ILIST)
 state_checkbox1(integer)
 state_checkbox2(integer)
 state_radiobutton(integer)
	
predicates
  custom_tree_eh : EHANDLER

clauses
  custom_tree_eh(_Win,e_Create(_),0):- 
	Tree = tree ("0:Null",unmarked,
			[
			tree("1:One",unmarked, 
			        [],0
			     ),
			tree("2:Two",unmarked,
			 	[tree("3:Three",unmarked,
			 		[],0
			 	     )
			 	],0
			      ),
			tree ("4:Four",unmarked,
			   	[],0
			       )
		        ],0
		     ),
	TreeFont = font_Create (ff_Times,[],10),
	TreeWinInfo = tree_WinInfo(TreeFont,tree_DirRight,[]),
	tree_CreateSubClass(_Win,Tree,TreeWinInfo,[]),
	fail.

  custom_tree_eh(W,e_MouseDbl(_,_,_),0):-
	tree_OpenCloseNode(W).
		
predicates
  custom_bmp1_eh  : EHANDLER

clauses
  custom_bmp1_eh(_Win,e_update(_),0):-
ifdef os_os2
	_Picture =pict_Load("..\\res\\os2\\5_up.BMP"),
elsedef
	_Picture =pict_Load("..\\res\\win\\5_up.BMP"),
enddef
	pict_GetSize(_Picture,X,Y,_Size),
	CustomWinRCT=win_GetClientRect(_Win),
	pict_Draw(_Win,_Picture,CustomWinRCT,rct(0,0,X,Y),rop_SrcCopy),
	!.

predicates
  custom_bmp2_eh  : EHANDLER

clauses
  custom_bmp2_eh(_Win,e_update(_),0):-
ifdef os_os2
	_Picture =pict_Load("..\\res\\os2\\16COLOR.BMP"),
elsedef
	_Picture =pict_Load("..\\res\\win\\16COLOR.BMP"),
enddef
	pict_GetSize(_Picture,X,Y,_Size),
	CustomWinRCT=win_GetClientRect(_Win),
	pict_Draw(_Win,_Picture,CustomWinRCT,rct(0,0,X,Y),rop_SrcCopy),
	!.
  	
predicates
  get_IncipientSettings(string,integer,real,long,integer,SLIST,ILIST,boolean,boolean)

clauses
  get_IncipientSettings(Str,Int,Real,Long,RBGROUP,ITEMLIST,SELECT_ITEM,CHECK_BOX1,CHECK_BOX2):-
	edit_string(Str),
	edit_integer(Int),
	edit_real(Real),
	edit_long(Long),
	item_listbox(ITEMLIST,SELECT_ITEM),
	state_checkbox1(CHECK_BOX1),
	state_checkbox2(CHECK_BOX2),
	state_radiobutton(RBGROUP),
	!.

predicates
  convert_RadioButtonValue(integer,string)
  convert_CheckBoxValue(integer,string)

clauses
  convert_RadioButtonValue(100,Str):-
	!,
	Str="Radio Button 1".
  convert_RadioButtonValue(101,Str):-
	!,
	Str="Radio Button 2".

  convert_CheckBoxValue(0,Str):-
	!,
	Str="b_false".
  convert_CheckBoxValue(1,Str):-
	!,
	Str="b_true".

%BEGIN_WIN Task Window
/***************************************************************************
	Event handling for Task Window
***************************************************************************/

predicates

  task_win_eh : EHANDLER

constants

%BEGIN Task Window, CreateParms, 12:04:28-24.11.1999, Code automatically updated!
  task_win_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Close,wsf_Maximize,wsf_Minimize,wsf_ClipSiblings]
  task_win_Menu  = res_menu(idr_task_menu)
  task_win_Title = "Dialog Package"
  task_win_Help  = idh_contents
%END Task Window, CreateParms

clauses

%BEGIN Task Window, e_Create
  task_win_eh(_Win,e_Create(_),0):-!,
%BEGIN Task Window, InitControls, 12:04:28-24.11.1999, Code automatically updated!
%END Task Window, InitControls
%BEGIN Task Window, ToolbarCreate, 12:04:28-24.11.1999, Code automatically updated!
	tb_project_toolbar_Create(_Win),
	tb_help_line_Create(_Win),
%END Task Window, ToolbarCreate
ifdef use_message
	msg_Create(1000),
enddef
	class_Create("CLASS",custom_tree_eh),
	class_Create("BMP1",custom_bmp1_eh),
	class_Create("BMP2",custom_bmp2_eh),
	assert(edit_string("Unknown")),
	assert(edit_integer(5)),
	assert(edit_real(1.5)),
	assert(edit_long(8)),
	assert(state_checkbox1(b_false)),
	assert(state_checkbox2(b_true)),
	assert(state_radiobutton(100)),
	assert(item_listbox(["MS-DOS"],[0])),
	!.
%END Task Window, e_Create

%MARK Task Window, new events

%BEGIN Task Window, id_open_window
  task_win_eh(_Win,e_Menu(id_open_window,_ShiftCtlAlt),0):-!,
	win_window_Create(_Win),
	!.
%END Task Window, id_open_window

%BEGIN Task Window, id_Open_Dialog_modelles_dialog
  task_win_eh(_Win,e_Menu(id_Open_Dialog_modelles_dialog,_ShiftCtlAlt),0):-!,
	dlg_modelles_dialog_Create(_Win),
	!.
%END Task Window, id_Open_Dialog_modelles_dialog

%BEGIN Task Window, id_Open_Dialog_modal_dialog
  task_win_eh(_Win,e_Menu(id_Open_Dialog_modal_dialog,_ShiftCtlAlt),0):-!,
	dlg_dialog_Create(_Win),
	!.
%END Task Window, id_Open_Dialog_modal_dialog

%BEGIN Task Window, id_file_open
  task_win_eh(_Win,e_Menu(id_file_open,_ShiftCtlAlt),0):-
	edit_string(S),
	write("String = ",S),nl,
	edit_integer(I),
	write("Integer = ",I),nl,
	edit_real(R),
	write("Real = ",R),nl,
	edit_long(L),
	write("Long = ",L),nl,
	state_checkbox1(A),
	convert_CheckBoxValue(A,A1),
	write("Checkbox1 = ",A1),nl,
	state_checkbox2(B),
	convert_CheckBoxValue(B,B1),
	write("Checkbox2 = ",B1),nl,
	state_radiobutton(X),
	convert_RadioButtonValue(X,X1),
	write("Radiobutton = ",X1),nl,
	item_listbox(Item,_),
	Item=[Item1|_],
	write("Item ListBox = ",Item1),nl,
	!.
%END Task Window, id_file_open

%BEGIN Task Window, id_help_contents
  task_win_eh(_Win,e_Menu(id_help_contents,_ShiftCtlAlt),0):-!,
  	vpi_ShowHelp("dialpack.hlp"),
	!.
%END Task Window, id_help_contents

%BEGIN Task Window, id_help_about
  task_win_eh(Win,e_Menu(id_help_about,_ShiftCtlAlt),0):-!,
	dlg_about_dialog_Create(Win),
	!.
%END Task Window, id_help_about

%BEGIN Task Window, id_file_exit
  task_win_eh(Win,e_Menu(id_file_exit,_ShiftCtlAlt),0):-!,
  	win_Destroy(Win),
	!.
%END Task Window, id_file_exit

%BEGIN Task Window, e_Size
  task_win_eh(_Win,e_Size(_Width,_Height),0):-!,
ifdef use_tbar
	toolbar_Resize(_Win),
enddef
ifdef use_message
	msg_Resize(_Win),
enddef
	!.
%END Task Window, e_Size

%END_WIN Task Window

/***************************************************************************
	Invoking on-line Help
***************************************************************************/

  project_ShowHelpContext(HelpTopic):-
  	vpi_ShowHelpContext("dialpack.hlp",HelpTopic),!.

/***************************************************************************
	Main Goal
***************************************************************************/

goal

ifdef use_mdi
  vpi_SetAttrVal(attr_win_mdi,b_true),
enddef
ifdef use_3dctrl
  vpi_SetAttrVal(attr_win_3dcontrols,b_true),
enddef
  vpi_Init(task_win_Flags,task_win_eh,task_win_Menu,"dialpack",task_win_Title).

%BEGIN_TLB Project toolbar, 12:04:48-24.11.1999, Code automatically updated!
/**************************************************************************
	Creation of toolbar: Project toolbar
**************************************************************************/

clauses

  tb_project_toolbar_Create(_Parent):-
ifdef use_tbar
	toolbar_create(tb_top,0xC0C0C0,_Parent,
		[tb_ctrl(id_file_new,pushb,idb_new_up,idb_new_dn,idb_new_up,"New;New file",1,1),
		 tb_ctrl(id_file_open,pushb,idb_open_up,idb_open_dn,idb_open_up,"Open;Open file",1,1),
		 tb_ctrl(id_file_save,pushb,idb_save_up,idb_save_dn,idb_save_up,"Save;File save",1,1),
		 separator,
		 tb_ctrl(id_edit_undo,pushb,idb_undo_up,idb_undo_dn,idb_undo_up,"Undo;Undo",1,1),
		 tb_ctrl(id_edit_redo,pushb,idb_redo_up,idb_redo_dn,idb_redo_up,"Redo;Redo",1,1),
		 separator,
		 tb_ctrl(id_edit_cut,pushb,idb_cut_up,idb_cut_dn,idb_cut_up,"Cut;Cut to clipboard",1,1),
		 tb_ctrl(id_edit_copy,pushb,idb_copy_up,idb_copy_dn,idb_copy_up,"Copy;Copy to clipboard",1,1),
		 tb_ctrl(id_edit_paste,pushb,idb_paste_up,idb_paste_dn,idb_paste_up,"Paste;Paste from clipboard",1,1),
		 separator,
		 separator,
		 tb_ctrl(id_help_contents,pushb,idb_help_up,idb_help_down,idb_help_up,"Help;Help",0,1)]),
enddef
	true.
%END_TLB Project toolbar

%BEGIN_TLB Help line, 12:05:26-24.11.1999, Code automatically updated!
/**************************************************************************
	Creation of toolbar: Help line
**************************************************************************/

clauses

  tb_help_line_Create(_Parent):-
ifdef use_tbar
	toolbar_create(tb_bottom,0xC0C0C0,_Parent,
		[tb_text(idt_help_line,tb_context,452,0,4,10,0x0,"")]),
enddef
	true.
%END_TLB Help line

%BEGIN_DLG About dialog
/**************************************************************************
	Creation and event handling for dialog: About dialog
**************************************************************************/

constants

%BEGIN About dialog, CreateParms, 11:03:52-11.1.2000, Code automatically updated!
  dlg_about_dialog_ResID = idd_dlg_about
  dlg_about_dialog_DlgType = wd_Modal
  dlg_about_dialog_Help = idh_contents
%END About dialog, CreateParms

predicates

  dlg_about_dialog_eh : EHANDLER

clauses

  dlg_about_dialog_Create(Parent):-
	win_CreateResDialog(Parent,dlg_about_dialog_DlgType,dlg_about_dialog_ResID,dlg_about_dialog_eh,0),!.

%BEGIN About dialog, idc_ok _CtlInfo
  dlg_about_dialog_eh(_Win,e_Control(idc_ok,_CtrlType,_CtrlWin,_CtrlInfo),0):-!,
	win_Destroy(_Win),
	!.
%END About dialog, idc_ok _CtlInfo
%MARK About dialog, new events

  dlg_about_dialog_eh(_,_,_):-!,fail.

%END_DLG About dialog

%BEGIN_DLG Dialog
/**************************************************************************
	Creation and event handling for dialog: Dialog
**************************************************************************/

constants

%BEGIN Dialog, CreateParms, 17:25:04-16.3.2000, Code automatically updated!
  dlg_dialog_ResID = idd_dialog
  dlg_dialog_DlgType = wd_Modal
  dlg_dialog_Help = idh_contents
%END Dialog, CreateParms

predicates

  dlg_dialog_eh : EHANDLER
  dlg_dialog_update(DIALOG_VAL_LIST)

clauses

  dlg_dialog_Create(Parent):-
	get_IncipientSettings(IDC_DIALOG_1_VALUE,Int,Real,Long,RBGROUP,ITEMLIST,SELECT_ITEM,CHECK_BOX1,CHECK_BOX2),
	IDC_DIALOG_2_VALUE = i(Int),
	IDC_DIALOG_3_VALUE = r(Real),
	IDC_EDIT_VALUE = l(Long),
	ITEMLIST=[IDCT_OS_TITLE|_],
%MARK Dialog, new variables

	dialog_CreateModal(Parent,dlg_dialog_ResID,"",
  		[
%BEGIN Dialog, ControlList, 17:25:04-16.3.2000, Code automatically updated!
		df(idc_dialog_1,editstr(IDC_DIALOG_1_VALUE,[length(10)]),nopr),
		df(idc_dialog_2,editint(IDC_DIALOG_2_VALUE,[range(0,5)]),str_prompt("Variable of type integer")),
		df(idc_dialog_3,editreal(IDC_DIALOG_3_VALUE,[range(-9.9,2.5)]),str_prompt("Variable of type real")),
		df(idc_edit,editlong(IDC_EDIT_VALUE,[range(0,10)]),str_prompt("Variable of type long")),
		df(idc_check_box_1,checkbox(CHECK_BOX1),nopr),
		df(idc_check_box_2,checkbox(CHECK_BOX2),nopr),
		df(idc_dialog_4,listbox(["MS-DOS","Windows 16","Windows 32","OS/2","UNIX"],SELECT_ITEM),nopr),
		df(idct_os,statictext(IDCT_OS_TITLE),nopr),
		df(idc_listbox,statictext("ListBox"),nopr),
		df(RBGROUP,radiobuttongroup([100,101]),nopr)
%END Dialog, ControlList
		],
		dlg_dialog_eh,0,VALLIST,ANSWER),
	ANSWER = idc_ok,
	dlg_dialog_update(VALLIST),!.

  dlg_dialog_update(_VALLIST):-
%BEGIN Dialog, Update controls, 17:25:04-16.3.2000, Code automatically updated!
	_IDC_DIALOG_1_VALUE = dialog_VLGetstr(idc_dialog_1,_VALLIST),
	_IDC_DIALOG_2_VALUE = dialog_VLGetint(idc_dialog_2,_VALLIST),
	_IDC_DIALOG_3_VALUE = dialog_VLGetreal(idc_dialog_3,_VALLIST),
	_CHECK_BOX1 = dialog_VLGetCheck(idc_check_box_1,_VALLIST),
	_IDC_EDIT_VALUE = dialog_VLGetlong(idc_edit,_VALLIST),
	_CHECK_BOX2 = dialog_VLGetCheck(idc_check_box_2,_VALLIST),
	dialog_VLGetListBox(idc_dialog_4,_VALLIST,_ITEMLIST,_SELECT_ITEM),
	_RBGROUP = dialog_VLGetRadiobutton(100,_VALLIST),
%END Dialog, Update controls
	retract(edit_string(_),db),
	retract(edit_integer(_),db),
	retract(edit_real(_),db),
	retract(edit_long(_),db),
	retract(state_checkbox1(_),db),
	retract(state_checkbox2(_),db),
	retract(state_radiobutton(_),db),
	retract(item_listbox(_,_),db),
	!,
	assert(edit_string(_IDC_DIALOG_1_VALUE)),
	_IDC_DIALOG_2_VALUE=i(S),
	_IDC_DIALOG_3_VALUE=r(Q),
	_IDC_EDIT_VALUE=l(W),
	assert(edit_integer(S)),
	assert(edit_real(Q)),
	assert(edit_long(W)),
	assert(state_checkbox1(_CHECK_BOX1)),
	assert(state_checkbox2(_CHECK_BOX2)),
	assert(state_radiobutton(_RBGROUP)),
	assert(item_listbox(_ITEMLIST,_SELECT_ITEM)),
	!.

%MARK Dialog, new events

%BEGIN Dialog, idc_dialog_4 selchanged
  dlg_dialog_eh(_Win,e_Control(idc_dialog_4,_CtrlType,LBOX,selchanged),0):-!,
        Index=lbox_GetSelIndex(LBOX),
        Item=lbox_GetItem(LBOX,Index),
        W=win_GetCtlHandle(_Win,idct_os),
        win_SetText(W,Item),
	!.
%END Dialog, idc_dialog_4 selchanged

  dlg_dialog_eh(_,_,_):-!,fail.

%END_DLG Dialog

%BEGIN_DLG Modelles Dialog
/*************************************************************************
	Creation and event handling for dialog: Modelles Dialog
**************************************************************************/

CONSTANTS

%BEGIN Modelles Dialog, CreateParms, 17:31:36-16.3.2000, Code automatically updated!
  dlg_modelles_dialog_ResID = idd_modelles_dialog
  dlg_modelles_dialog_DlgType = wd_Modeless
  dlg_modelles_dialog_Help = idh_contents
%END Modelles Dialog, CreateParms

PREDICATES

  dlg_modelles_dialog_eh : EHANDLER
  dlg_modelles_dialog_update(DIALOG_VAL_LIST)

CLAUSES

  dlg_modelles_dialog_Create(Parent):-
	get_IncipientSettings(IDC_DIALOG_1_VALUE,Int,Real,Long,RBGROUP,ITEMLIST,SELECT_ITEM,CHECK_BOX1,CHECK_BOX2),
	IDC_DIALOG_2_VALUE = i(Int),
	IDC_DIALOG_3_VALUE = r(Real),
	IDC_EDIT_VALUE = l(Long),
	ITEMLIST=[IDCT_OS_TITLE|_],
%MARK Modelles Dialog, new variables

	dialog_CreateModeless(Parent,dlg_modelles_dialog_ResID,"",
  		[
%BEGIN Modelles Dialog, ControlList, 17:31:36-16.3.2000, Code automatically updated!
		df(idc_dialog_1,editstr(IDC_DIALOG_1_VALUE,[length(10)]),nopr),
		df(idc_dialog_2,editint(IDC_DIALOG_2_VALUE,[range(0,5)]),str_prompt("Variable of type integer")),
		df(idc_dialog_3,editreal(IDC_DIALOG_3_VALUE,[range(-9.9,2.5)]),str_prompt("Variable of type real")),
		df(idc_edit,editlong(IDC_EDIT_VALUE,[range(0,10)]),str_prompt("Variable of type long")),
		df(idc_check_box_1,checkbox(CHECK_BOX1),nopr),
		df(idc_check_box_2,checkbox(CHECK_BOX2),nopr),
		df(idc_dialog_4,listbox(["MS-DOS","Windows16","Windows32","OS/2","UNIX"],SELECT_ITEM),nopr),
		df(idct_os,statictext(IDCT_OS_TITLE),nopr),
		df(RBGROUP,radiobuttongroup([100,101]),nopr)
%END Modelles Dialog, ControlList
		],
		dlg_modelles_dialog_eh,0),!.

  dlg_modelles_dialog_update(_VALLIST):-
%BEGIN Modelles Dialog, Update controls, 17:31:36-16.3.2000, Code automatically updated!
	_IDC_DIALOG_1_VALUE = dialog_VLGetstr(idc_dialog_1,_VALLIST),
	_IDC_DIALOG_2_VALUE = dialog_VLGetint(idc_dialog_2,_VALLIST),
	_IDC_DIALOG_3_VALUE = dialog_VLGetreal(idc_dialog_3,_VALLIST),
	_CHECK_BOX1 = dialog_VLGetCheck(idc_check_box_1,_VALLIST),
	_IDC_EDIT_VALUE = dialog_VLGetlong(idc_edit,_VALLIST),
	_CHECK_BOX2 = dialog_VLGetCheck(idc_check_box_2,_VALLIST),
	dialog_VLGetListBox(idc_dialog_4,_VALLIST,_ITEMLIST,_SELECT_ITEM),
	_RBGROUP = dialog_VLGetRadiobutton(100,_VALLIST),
%END Modelles Dialog, Update controls
	retractall(edit_string(_),db),
	retractall(edit_integer(_),db),
	retractall(edit_real(_),db),
	retractall(edit_long(_),db),
	retractall(state_checkbox1(_),db),
	retractall(state_checkbox2(_),db),
	retract(state_radiobutton(_),db),
	retract(item_listbox(_,_),db),
	!,
	assert(edit_string(_IDC_DIALOG_1_VALUE)),
	_IDC_DIALOG_2_VALUE=i(S),
	_IDC_DIALOG_3_VALUE=r(Q),
	_IDC_EDIT_VALUE=l(W),
	assert(edit_integer(S)),
	assert(edit_real(Q)),
	assert(edit_long(W)),
	assert(state_checkbox1(_CHECK_BOX1)),
	assert(state_checkbox2(_CHECK_BOX2)),
	assert(state_radiobutton(_RBGROUP)),
	assert(item_listbox(_ITEMLIST,_SELECT_ITEM)),
	!.

%MARK Modelles Dialog, new events

%BEGIN Modelles Dialog, idc_ok _CtlInfo
  dlg_modelles_dialog_eh(_Win,e_Control(idc_ok,_CtrlType,_CtrlWin,_CtlInfo),0):-
	not(dialog_CheckEditProperties(_Win)),
	!.
  dlg_modelles_dialog_eh(_Win,e_Control(idc_ok,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	VALLIST = dialog_GetValues(_Win),
	dlg_modelles_dialog_update(VALLIST),
	!,fail.
	
%END Modelles Dialog, idc_ok _CtlInfo

%BEGIN Modelles Dialog, idc_dialog_4 selchanged
  dlg_modelles_dialog_eh(_Win,e_Control(idc_dialog_4,_CtrlType,LBOX,selchanged),0):-!,
        Index=lbox_GetSelIndex(LBOX),
        Item=lbox_GetItem(LBOX,Index),
        W=win_GetCtlHandle(_Win,idct_os),
        win_SetText(W,Item),
	!.
%END Modelles Dialog, idc_dialog_4 selchanged

  dlg_modelles_dialog_eh(_,_,_):-!,fail.

%END_DLG Modelles Dialog

%BEGIN_WIN Window
/**************************************************************************
	Creation and event handling for window: "Window"
**************************************************************************/

CONSTANTS

%BEGIN Window, CreateParms, 14:05:55-4.4.2000, Code automatically updated!
  win_window_WinType = w_TopLevel
  win_window_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Maximize,wsf_Minimize,wsf_Close,wsf_ClipSiblings]
  win_window_RCT = rct(100,80,637,403)
  win_window_Menu = no_menu
  win_window_Title = "Window"
  win_window_Help = idh_contents
%END Window, CreateParms

PREDICATES

  win_window_eh : EHANDLER
  win_window_update(DIALOG_VAL_LIST)

CLAUSES

  win_window_Create(Parent):-
	get_IncipientSettings(IDC_DIALOG_1_VALUE,Int,Real,Long,RBGROUP,ITEMLIST,SELECT_ITEM,CHECK_BOX1,CHECK_BOX2),
	IDC_DIALOG_2_VALUE = i(Int),
	IDC_DIALOG_3_VALUE = r(Real),
	IDC_EDIT_VALUE = l(Long),
	ITEMLIST=[IDCT_OS_TITLE|_],
%MARK Window, new variables

	dialog_Create(Parent,
		[
%BEGIN Window, WinDefList, 14:05:55-4.4.2000, Code automatically updated!
		 topwin(wdef(win_window_WinType,win_window_RCT,win_window_Title,u_Pixels),
			win_window_Menu,win_window_Flags),
		 ctl(wdef(wc_Edit,rct(142,21,238,45),"",u_Pixels),idc_dialog_1,[wsf_Group,wsf_TabStop,wsf_AutoHScroll,wsf_AlignLeft]),
		 ctl(wdef(wc_Edit,rct(142,49,238,73),"",u_Pixels),idc_dialog_2,[wsf_Group,wsf_TabStop,wsf_AutoHScroll,wsf_AlignLeft]),
		 ctl(wdef(wc_Edit,rct(142,77,238,101),"",u_Pixels),idc_dialog_3,[wsf_Group,wsf_TabStop,wsf_AutoHScroll,wsf_AlignLeft]),
		 ctl(wdef(wc_Edit,rct(142,105,238,129),"",u_Pixels),idc_edit,[wsf_Group,wsf_TabStop,wsf_AutoHScroll,wsf_AlignLeft]),
		 ctl(wdef(wc_RadioButton,rct(280,22,398,40),"Radio Button 1",u_Pixels),100,[wsf_TabStop,wsf_Group]),
		 ctl(wdef(wc_RadioButton,rct(280,53,400,71),"Radio Button 2",u_Pixels),101,[wsf_TabStop]),
		 ctl(wdef(wc_CheckBox,rct(280,81,380,99),"Check Box 1",u_Pixels),idc_check_box_1,[wsf_Group,wsf_TabStop,wsf_Auto]),
		 ctl(wdef(wc_CheckBox,rct(280,111,380,129),"Check Box 2",u_Pixels),idc_check_box_2,[wsf_Group,wsf_TabStop,wsf_Auto]),
		 customctl(wdef(wc_Custom,rct(10,163,238,263),"Custom",u_Pixels),"CLASS",idc_custom,[wsf_Group,wsf_TabStop]),
		 ctl(wdef(wc_LBox,rct(280,165,430,229),"",u_Pixels),idc_dialog_4,[wsf_Group,wsf_TabStop,wsf_VScroll,wsf_Sort,wsf_NoIntegralHeight]),
		 ctl(wdef(wc_PushButton,rct(70,285,150,309),"OK",u_Pixels),idc_ok,[wsf_Default,wsf_Group,wsf_TabStop]),
		 ctl(wdef(wc_PushButton,rct(223,285,303,309),"Cancel",u_Pixels),idc_cancel,[wsf_Group,wsf_TabStop]),
		 ctl(wdef(wc_PushButton,rct(375,285,455,309),"Help",u_Pixels),idc_help,[wsf_Group,wsf_TabStop]),
		 customctl(wdef(wc_Custom,rct(462,66,534,138),"Custom",u_Pixels),"BMP1",idc_custom1,[wsf_Group,wsf_TabStop]),
		 customctl(wdef(wc_Custom,rct(462,153,534,269),"Custom",u_Pixels),"BMP2",idc_custom_2,[wsf_Group,wsf_TabStop]),
		 ctl(wdef(wc_Text,rct(10,23,128,41),"String (length 10)",u_Pixels),idct_write_a_string,[wsf_AlignLeft]),
		 ctl(wdef(wc_Text,rct(10,53,106,71),"Integer (0 - 5)",u_Pixels),idct_write_a_integer,[wsf_AlignLeft]),
		 ctl(wdef(wc_Text,rct(10,83,124,101),"Real (-9.9 - 2.5)",u_Pixels),idct_write_a_real,[wsf_AlignLeft]),
		 ctl(wdef(wc_Text,rct(10,111,106,129),"Long (0 - 10)",u_Pixels),idct_write_a_long,[wsf_AlignLeft]),
		 ctl(wdef(wc_Text,rct(280,239,430,257),"",u_Pixels),idct_os,[wsf_AlignCenter]),
		 icon(wdef(wc_Icon,rct(480,25,512,57),"",u_Pixels),idc_window_1,idi_dlgpackicon,[]),
		 ctl(wdef(wc_GroupBox,rct(2,145,246,271),"Custom Control",u_Pixels),idc_groupbox1,[]),
		 ctl(wdef(wc_GroupBox,rct(262,1,446,139),"GroupBox",u_Pixels),idc_groupbox2,[]),
		 ctl(wdef(wc_GroupBox,rct(261,145,445,271),"ListBox",u_Pixels),idc_listbox,[]),
		 ctl(wdef(wc_GroupBox,rct(2,1,246,139),"Edit Control",u_Pixels),idc_groupbox,[])
%END Window, WinDefList
		],
  		[
%BEGIN Window, ControlList, 14:05:55-4.4.2000, Code automatically updated!
		df(idc_dialog_1,editstr(IDC_DIALOG_1_VALUE,[length(10)]),nopr),
		df(idc_dialog_2,editint(IDC_DIALOG_2_VALUE,[range(0,5)]),str_prompt("Variable of type integer")),
		df(idc_dialog_3,editreal(IDC_DIALOG_3_VALUE,[range(-9.9,2.5)]),str_prompt("Variable of type real")),
		df(idc_edit,editlong(IDC_EDIT_VALUE,[range(0,10)]),str_prompt("Variable of type long")),
		df(idc_check_box_1,checkbox(CHECK_BOX1),nopr),
		df(idc_check_box_2,checkbox(CHECK_BOX2),nopr),
		df(idc_dialog_4,listbox(["MS-DOS","Windows16","Windows32","OS/2","UNIX"],SELECT_ITEM),nopr),
		df(idct_os,statictext(IDCT_OS_TITLE),nopr),
		df(RBGROUP,radiobuttongroup([100,101]),nopr)
%END Window, ControlList
		],
		win_window_eh,0,_,_),!.

  win_window_update(_VALLIST):-
%BEGIN Window, Update controls, 14:05:55-4.4.2000, Code automatically updated!
	_IDC_DIALOG_1_VALUE = dialog_VLGetstr(idc_dialog_1,_VALLIST),
	_IDC_DIALOG_2_VALUE = dialog_VLGetint(idc_dialog_2,_VALLIST),
	_IDC_DIALOG_3_VALUE = dialog_VLGetreal(idc_dialog_3,_VALLIST),
	_CHECK_BOX1 = dialog_VLGetCheck(idc_check_box_1,_VALLIST),
	_IDC_EDIT_VALUE = dialog_VLGetlong(idc_edit,_VALLIST),
	_CHECK_BOX2 = dialog_VLGetCheck(idc_check_box_2,_VALLIST),
	dialog_VLGetListBox(idc_dialog_4,_VALLIST,_ITEMLIST,_SELECT_ITEM),
	_RBGROUP = dialog_VLGetRadiobutton(100,_VALLIST),
%END Window, Update controls
	retractall(edit_string(_),db),
	retractall(edit_integer(_),db),
	retractall(edit_real(_),db),
	retractall(edit_long(_),db),
	retractall(state_checkbox1(_),db),
	retractall(state_checkbox2(_),db),
	retract(state_radiobutton(_),db),
	retract(item_listbox(_,_),db),
	!,
	assert(edit_string(_IDC_DIALOG_1_VALUE)),
	_IDC_DIALOG_2_VALUE=i(S),
	_IDC_DIALOG_3_VALUE=r(Q),
	_IDC_EDIT_VALUE=l(W),
	assert(edit_integer(S)),
	assert(edit_real(Q)),
	assert(edit_long(W)),
	assert(state_checkbox1(_CHECK_BOX1)),
	assert(state_checkbox2(_CHECK_BOX2)),
	assert(state_radiobutton(_RBGROUP)),
	assert(item_listbox(_ITEMLIST,_SELECT_ITEM)),
	!.

%BEGIN Window, e_Create
  win_window_eh(_Win,e_Create(_),0):-!,
%BEGIN Window, ToolbarCreate, 14:05:55-4.4.2000, Code automatically updated!
%END Window, ToolbarCreate
	!.
%END Window, e_Create

%BEGIN Window, idc_ok _CtlInfo
  win_window_eh(_Win,e_Control(idc_ok,_CtrlType,_CtrlWin,_CtrlInfo),0):-
	not(dialog_CheckEditProperties(_Win)),
	!.
  win_window_eh(_Win,e_Control(idc_ok,_CtrlType,_CtrlWin,_CtrlInfo),0):-!,
	VALLIST = dialog_GetValues(_Win),
	win_window_update(VALLIST),
	!,fail.
%END Window, idc_ok _CtlInfo
%MARK Window, new events

%BEGIN Window, e_Update
  win_window_eh(_Win,e_Update(_UpdateRct),0):-!,
	win_Clear(_Win,color_LtGray),
	!.
%END Window, e_Update

%BEGIN Window, idc_dialog_4 selchanged
  win_window_eh(_Win,e_Control(idc_dialog_4,_CtrlType,LBOX,selchanged),0):-!,
        Index=lbox_GetSelIndex(LBOX),
        Item=lbox_GetItem(LBOX,Index),
        W=win_GetCtlHandle(_Win,idct_os),
        win_SetText(W,Item),
	!.
%END Window, idc_dialog_4 selchanged

%BEGIN Window, e_Size
  win_window_eh(_Win,e_Size(_Width,_Height),0):-!,
IFDEF use_tbar
	toolbar_Resize(_Win),
ENDDEF
	!.
%END Window, e_Size

%BEGIN Window, e_Menu, Parent window 
  win_window_eh(Win,e_Menu(ID,CAS),0):-!,
	PARENT = win_GetParent(Win),
	win_SendEvent(PARENT,e_Menu(ID,CAS)),
	!.
%END Window, e_Menu, Parent window

%END_WIN Window




