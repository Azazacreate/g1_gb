/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 			VISUAL Prolog
 
 Project:  OFFICE
 FileName: OFFICE.PRO
 Purpose: DDE Example
 Written by: PDC
 Comments:
******************************************************************************/

include "office.inc"
include "office.con"
include "hlptopic.con"

%BEGIN_WIN Task Window
/***************************************************************************
		Event handling for task window
***************************************************************************/

PREDICATES

  task_win_eh : EHANDLER

CONSTANTS

%BEGIN Task Window, CreateParms, 18:18:10-23.11.1999, Code automatically updated!
  task_win_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Close,wsf_Maximize,wsf_Minimize,wsf_ClipSiblings]
  task_win_Menu  = res_menu(idr_task_menu)
  task_win_Title = "Office"
  task_win_Help  = idh_contents
%END Task Window, CreateParms

CLAUSES

%BEGIN Task Window, e_Create
  task_win_eh(_Win,e_Create(_),0):-!,
	dde_Init([ddef_clientonly]),
%BEGIN Task Window, InitControls, 18:18:10-23.11.1999, Code automatically updated!
%END Task Window, InitControls
%BEGIN Task Window, ToolbarCreate, 18:18:10-23.11.1999, Code automatically updated!
%END Task Window, ToolbarCreate
IFDEF use_message
	msg_Create(100),
ENDDEF
	!.
%END Task Window, e_Create

%MARK Task Window, new events

%BEGIN Task Window, id_help_contents
IFDEF use_on_line_help
  task_win_eh(_Win,e_Menu(id_help_contents,_ShiftCtlAlt),0):-!,
	vpi_ShowHelp("office.hlp"),
	!.
ENDDEF
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

%BEGIN Task Window, id_Word_get_open_files
  task_win_eh(_Win,e_Menu(id_Word_get_open_files,_ShiftCtlAlt),0):-!,
	trap(Conv = dde_Connect("WinWord","System"),_,write("WinWord not running\n")),
	dde_Request(Conv,"Topics",1000,ddecf_Text,Val),
	write("Got: ",Val),nl,
	dde_DisConnect(Conv),
	!.
%END Task Window, id_Word_get_open_files
%BEGIN Task Window, id_Word_open_ddetest
  task_win_eh(_Win,e_Menu(id_Word_open_ddetest,_ShiftCtlAlt),0):-!,
	trap(Conv = dde_Connect("WinWord","System"),_,write("WinWord not running\n")),
	filenamepath(FullName,"","ddetest.doc"),
	format(Command,"[FileOpen .Name=\"%\"]",FullName),
	write("Command=",Command),nl,
	dde_Execute(Conv,Command,0),
	dde_DisConnect(Conv),
	!.
%END Task Window, id_Word_open_ddetest
%BEGIN Task Window, id_Word_retrieve_bookmark
  task_win_eh(_Win,e_Menu(id_Word_retrieve_bookmark,_ShiftCtlAlt),0):-!,
	filenamepath(FullName,"","ddetest.doc"),
	trap(Conv = dde_Connect("WinWord",FullName),_,write("Document not loaded\n")),
	dde_Request(Conv,"bookmark1",1000,ddecf_Text,Val),
	write("Got: ",Val),nl,
	dde_DisConnect(Conv),
	!.
%END Task Window, id_Word_retrieve_bookmark
%BEGIN Task Window, id_Word_insert_text
  task_win_eh(_Win,e_Menu(id_Word_insert_text,_ShiftCtlAlt),0):-!,
	filenamepath(FullName,"","ddetest.doc"),
	trap(Conv = dde_Connect("WinWord",FullName),_,write("Document not loaded\n")),
	Text = dlg_GetStr("","Type text to insert in the word document",""),
	format(Command,"[EndOfDocument][Insert \"%\"]",Text),
	write("Command=",Command),nl,
	dde_Execute(Conv,Command,0),
	dde_DisConnect(Conv),
	!.
%END Task Window, id_Word_insert_text
%BEGIN Task Window, id_Excel_get_open_files
  task_win_eh(_Win,e_Menu(id_Excel_get_open_files,_ShiftCtlAlt),0):-!,
	trap(Conv = dde_Connect("Excel","System"),_,write("Excel not running\n")),
	dde_Request(Conv,"Topics",1000,ddecf_Text,Val),
	write("Got: ",Val),nl,
	dde_DisConnect(Conv),
	!.
%END Task Window, id_Excel_get_open_files
%BEGIN Task Window, id_Excel_open_new_sheet
  task_win_eh(_Win,e_Menu(id_Excel_open_new_sheet,_ShiftCtlAlt),0):-!,
	trap(Conv = dde_Connect("Excel","System"),_,write("Excel not running\n")),
	filenamepath(FullName,"","ddetest.xls"),
	format(Command,"[OPEN(\"%\")]",FullName),
	write("Command=",Command),nl,
	dde_Execute(Conv,Command,0),
	dde_DisConnect(Conv),
	!.
%END Task Window, id_Excel_open_new_sheet
%BEGIN Task Window, id_Excel_peek
  task_win_eh(_Win,e_Menu(id_Excel_peek,_ShiftCtlAlt),0):-!,
	dlg_excel_Create(_Win,Row,Col,_),
	trap(Conv = dde_Connect("Excel","[ddetest.xls]Sheet1"),_,write("ddetest.xls not loaded\n")),
	format(Item,"R%uC%u",Row,Col),
	write("Item=",Item),nl,
	dde_Request(Conv,Item,1000,ddecf_Text,Val),
	write("Got: ",Val),nl,
	dde_DisConnect(Conv),
	!.
%END Task Window, id_Excel_peek
%BEGIN Task Window, id_Excel_poke
  task_win_eh(_Win,e_Menu(id_Excel_poke,_ShiftCtlAlt),0):-!,
	dlg_excel_Create(_Win,Row,Col,Val),
	trap(Conv = dde_Connect("Excel","[ddetest.xls]Sheet1"),_,write("ddetest.xls not loaded\n")),
	format(Item,"R%uC%u",Row,Col),
	write("Item=",Item),nl,
	dde_Poke(Conv,Item,str(Val),ddecf_text,0),
	dde_DisConnect(Conv),
	!.
%END Task Window, id_Excel_poke
%BEGIN Task Window, e_Destroy
  task_win_eh(_Win,e_Destroy,0):-!,
	dde_End(),
	!.
%END Task Window, e_Destroy
%BEGIN Task Window, e_Size
  task_win_eh(_Win,e_Size(_Width,_Height),0):-!,
IFDEF use_tbar
	toolbar_Resize(_Win),
ENDDEF
IFDEF use_message
	msg_Resize(_Win),
ENDDEF
	!.
%END Task Window, e_Size

/***************************************************************************
			Main Goal Project
***************************************************************************/

GOAL

IFDEF use_mdi
  vpi_SetAttrVal(attr_win_mdi,b_true),
ENDDEF
IFDEF use_3dctrl
  vpi_SetAttrVal(attr_win_3dcontrols,b_true),
ENDDEF
IFDEF use_tbar
  vpi_SetAttrVal(attr_win_tbar,use_tbar),
ENDDEF
IFDEF use_sbar
  vpi_SetAttrVal(attr_win_sbar,use_sbar),
ENDDEF
  vpi_Init(task_win_Flags,task_win_eh,task_win_Menu,"office",task_win_Title).

%END_WIN Task Window

%BEGIN_DLG About dialog
/**************************************************************************
	Creation and event handling for dialog: "About dialog"
	Code style: Single dialog
**************************************************************************/

CONSTANTS

%BEGIN About dialog, CreateParms, 18:18:06-23.11.1999, Code automatically updated!
  dlg_about_dialog_ResID = idd_dlg_about
  dlg_about_dialog_DlgType = wd_Modal
  dlg_about_dialog_Help = idh_contents
%END About dialog, CreateParms

PREDICATES

  dlg_about_dialog_eh : EHANDLER

CLAUSES

  dlg_about_dialog_Create(Parent):-
	win_CreateResDialog(Parent,dlg_about_dialog_DlgType,dlg_about_dialog_ResID,dlg_about_dialog_eh,0),!.

%BEGIN About dialog, idc_ok _CtlInfo
  dlg_about_dialog_eh(_Win,e_Control(idc_ok,_CtrlType,_CtrlWin,_CtrlInfo),0):-!,
	win_Destroy(_Win),
	!.
%END About dialog, idc_ok _CtlInfo
%MARK About dialog, new events

  dlg_about_dialog_eh(_,_,0):-!,fail.
%END_DLG About dialog

%BEGIN_DLG excel
/**************************************************************************
	Creation and event handling for dialog: "excel"
	Code style: Dialog with PDC DlgPackage
**************************************************************************/

CONSTANTS

%BEGIN excel, CreateParms, 18:18:04-23.11.1999, Code automatically updated!
  dlg_excel_ResID = idd_excel
  dlg_excel_DlgType = wd_Modal
  dlg_excel_Help = idh_contents
%END excel, CreateParms

PREDICATES

  dlg_excel_eh : EHANDLER
  dlg_excel_update(DIALOG_VAL_LIST,BOOLEAN Answer,INTEGER Row,INTEGER Col,STRING Val)

CLAUSES

  dlg_excel_Create(Parent,Row,Col,Val):-

%MARK excel, new variables

	dialog_Create(Parent,[resdlg(dlg_excel_ResID,dlg_excel_DlgType)],
		[
%BEGIN excel, ControlList, 18:18:04-23.11.1999, Code automatically updated!
		df(idc_row,editint(i(0),[range(0,9999)]),nopr),
		df(idc_col,editint(i(0),[range(0,9999)]),nopr),
		df(idc_value,editstr("",[]),nopr)
%END excel, ControlList
		],
		dlg_excel_eh,0,VALLIST,ANSWER),
	  dlg_excel_update(VALLIST,AnsWer,Row,Col,Val),
	!.

  dlg_excel_update(_VALLIST,b_true,Row,Col,_Value):-!,
%BEGIN excel, Update controls, 18:18:04-23.11.1999, Code automatically updated!
	_ROW = dialog_VLGetint(idc_row,_VALLIST),
	_COL = dialog_VLGetint(idc_col,_VALLIST),
	_VALUE = dialog_VLGetstr(idc_value,_VALLIST),
%END excel, Update controls
	_ROW = i(ROW),
	_COL = i(Col),
	!.

%MARK excel, new events

  dlg_excel_eh(_,_,0):-!,fail.
%END_DLG excel






