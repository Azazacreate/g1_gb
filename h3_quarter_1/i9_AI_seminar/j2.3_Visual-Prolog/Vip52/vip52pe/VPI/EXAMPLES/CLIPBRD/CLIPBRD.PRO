/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

			VISUAL Prolog

 Project:  CLIPBRD
 FileName: CLIPBRD.PRO
 Purpose: Clipboard handling
 Written by: Illin Yuri
 Comments:
******************************************************************************/

include "clipbrd.inc"
include "clipbrd.con"
include "hlptopic.con"

/***************************************************************************
    Following structure contains the user's current format options,
    changed only when the OK button in the format dialog is clicked.
    Following structure contains the current data gotten from the clipboard.
***************************************************************************/

DATABASE - clip_board_format
  name_binary(STRING)                   % Current selected name for binary format
  tmp_cbformat(INTEGER,STRING)  % Current selected format in dialog

/***************************************************************************
    Predicate to show clipboard text in the TASK window, during update.
***************************************************************************/

PREDICATES
  show_text(WINDOW,STRING)
  show_line(WINDOW,STRING,INTEGER,INTEGER)
  get_line(STRING Input,STRING Line,STRING Rest)
  drop_lf(STRING,STRING)

CLAUSES
  show_text(_Win,Text) :- !,
	NFont = font_Create(ff_helvetica,[],12),
	win_SetFont(_Win,NFont),
	win_GetFontMetrics(_Win,L,A,_),
	Spacing = L+A,
	show_line(_Win,Text,0,Spacing).

  show_line(_,"",_,_):-!.
  show_line(_Win,Text,Y,Spacing) :-
	get_line(Text,Line,TextEnd),
	Y1 = Y + Spacing,
	draw_text(_Win,10,Y1,Line),
	show_line(_Win,TextEnd,Y1,Spacing).

  get_line(Str,StartStr1,Rest1):-
	searchchar(Str,'\n',Pos),!,
	Len = Pos - 1,
	frontstr(Len,Str,StartStr,Rest),
	frontchar(Rest,_,Rest1),
	drop_lf(StartStr,StartStr1).
  get_line(Str,Str,"").

  drop_lf(S,Rest):-
	str_len(S,Len),
	subchar(S,Len,Char),
	Char = '\r', !,
	Len1 = Len-1,
	frontstr(Len1,S,Rest,_).
  drop_lf(S,S).

/***************************************************************************
    Predicate to put data onto the clipboard.
***************************************************************************/

PREDICATES
  clip_put(INTEGER CB_Type,STRING Name)

CLAUSES
  clip_put(idc_binary,Name) :-!,
	retractall(name_binary(Name)), 
	assert(name_binary(Name)),
	term_bin(string,Name,Bin),
	cb_PutBin(Name,Bin).

  clip_put(idc_text,_) :-
	cb_PutString("The quick brown fox\njumped over the\nlazy dogs.").

  clip_put(idc_picture,_) :-
	Frame = rct(0,0,100,100),
	PW = pict_Open(Frame),
	win_SetBrush(PW,brush(pat_diagcross,color_black)),
	win_setpen(PW, pen( 1, ps_Solid, color_red )),
	draw_Ellipse(PW,Frame),
	Pict = pict_Close(PW),
	cb_PutPicture(Pict),
	pict_Destroy(Pict).

/***************************************************************************
    Predicate to update the standard window.
***************************************************************************/

PREDICATES
  update(WINDOW)
  draw_data(WINDOW)

CLAUSES
  update(_Win) :-
	NFont = font_Create(ff_helvetica,[],12),
	win_setfont(_Win,NFont),
	DrawTools = win_GetDrawTools ( _Win ),
	win_SetPen ( _Win, pen ( 1, ps_Solid, color_White ) ),
	win_SetBrush ( _Win ,brush ( pat_Solid, color_White ) ),
	RCT = win_GetClientRect ( _Win ),
	draw_Rect ( _Win, RCT ),
	win_SetDrawTools ( _Win, DrawTools ),
	draw_data(_Win),!.

  draw_data(_Win) :-
	cb_PictureAvailable(),!,
	Pict = cb_GetPicture(),
	pict_Draw(_Win,Pict,pnt(1,1),rop_SrcCopy).

  draw_data(_Win) :-
	name_binary(Name),
	cb_BinAvailable(Name), !,
	Bin = cb_GetBin(Name),
	format(BUF,"Application data in % format: %", Name,Bin),
	draw_text(_Win,20, 20, BUF).

  draw_data(_Win):-
	cb_StringAvailable(),!,
	Str = cb_GetString(),
	show_text(_Win,Str).
    
  draw_data(_Win) :- !,
	draw_text(_Win,10, 20, "No information in clipboard", -1),
	!.

/***************************************************************************

***************************************************************************/

PREDICATES
  BOOLEAN set_visible(INTEGER,DIALOG_STR_PROPS)

CLAUSES
  set_visible(idc_text,[],b_false):-!.
  set_visible(idc_picture,[],b_false):-!.
  set_visible(idc_binary,[mandatory,length(10)],b_true):-!.

%BEGIN_WIN Task Window
/***************************************************************************
		Event handling for task window
***************************************************************************/

PREDICATES

  task_win_eh : EHANDLER

CONSTANTS

%BEGIN Task Window, CreateParms, 17:21:08-23.11.1999, Code automatically updated!
  task_win_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Close,wsf_Maximize,wsf_Minimize,wsf_ClipSiblings]
  task_win_Menu  = res_menu(idr_task_menu)
  task_win_Title = "Clipbrd"
  task_win_Help  = idh_contents
%END Task Window, CreateParms

CLAUSES

%BEGIN Task Window, e_Create
  task_win_eh(_Win,e_Create(_),0):-!,
%BEGIN Task Window, InitControls, 17:21:08-23.11.1999, Code automatically updated!
%END Task Window, InitControls
%BEGIN Task Window, ToolbarCreate, 17:21:08-23.11.1999, Code automatically updated!
%END Task Window, ToolbarCreate
IFDEF use_message
	msg_Create(1000),
ENDDEF
	!.
%END Task Window, e_Create

%MARK Task Window, new events

%BEGIN Task Window, id_clipboard
  task_win_eh(_Win,e_Menu(id_clipboard,_ShiftCtlAlt),0):-!,
	dlg_clipboard_format_Create(_Win),
	tmp_cbformat(Type,Name),!,
	clip_put(Type,Name),
	RCT  = win_GetClientRect(_Win),
	win_Invalidate(_Win,RCT),
	!.
%END Task Window, id_clipboard

%BEGIN Task Window, id_help_contents
IFDEF use_on_line_help
  task_win_eh(_Win,e_Menu(id_help_contents,_ShiftCtlAlt),0):-!,
	vpi_ShowHelp("clipbrd.hlp"),
	!.
ENDDEF
%END Task Window, id_help_contents

%BEGIN Task Window, id_help_about
  task_win_eh(_Win,e_Menu(id_help_about,_ShiftCtlAlt),0):-!,
	dlg_about_dialog_Create(_Win),
	!.
%END Task Window, id_help_about

%BEGIN Task Window, id_file_exit
  task_win_eh(Win,e_Menu(id_file_exit,_ShiftCtlAlt),0):-!,
	win_Destroy(Win),
	!.
%END Task Window, id_file_exit

%BEGIN Task Window, e_Update
  task_win_eh(_Win,e_Update(_UpdateRct), 0):-!,
	update(_Win).
%END Task Window, e_Update
%BEGIN Task Window, e_GetFocus
  task_win_eh(_Win,e_GetFocus, 0):-!,
	RCT  = win_GetClientRect(_Win),
	win_Invalidate(_Win,RCT).
%END Task Window, e_GetFocus

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
  vpi_Init(task_win_Flags,task_win_eh,task_win_Menu,"clipbrd",task_win_Title).

%END_WIN Task Window

%BEGIN_DLG About dialog
/**************************************************************************
	Creation and event handling for dialog: "About dialog"
	Code style: Single dialog
**************************************************************************/

CONSTANTS

%BEGIN About dialog, CreateParms, 17:21:04-23.11.1999, Code automatically updated!
  dlg_about_dialog_ResID = idd_dlg_about
  dlg_about_dialog_DlgType = wd_Modal
  dlg_about_dialog_Help = idh_contents
%END About dialog, CreateParms

PREDICATES

  dlg_about_dialog_eh : EHANDLER

CLAUSES

  dlg_about_dialog_Create(_Win):-
	win_CreateResDialog(_Win,dlg_about_dialog_DlgType,dlg_about_dialog_ResID,dlg_about_dialog_eh,0),!.

%BEGIN About dialog, idc_ok _CtlInfo
  dlg_about_dialog_eh(_Win,e_Control(idc_ok,_CtrlType,_CtrlWin,_CtrlInfo),0):-!,
	win_Destroy(_Win),
	!.
%END About dialog, idc_ok _CtlInfo
%MARK About dialog, new events

  dlg_about_dialog_eh(_,_,0):-!,fail.
%END_DLG About dialog
%BEGIN_DLG ClipBoard Format
/**************************************************************************
	Creation and event handling for dialog: ClipBoard Format
**************************************************************************/

CONSTANTS

%BEGIN ClipBoard Format, CreateParms, 17:32:28-23.11.1999, Code automatically updated!
  dlg_clipboard_format_ResID = idd_clipboard_format
  dlg_clipboard_format_DlgType = wd_Modal
  dlg_clipboard_format_Help = idh_contents
%END ClipBoard Format, CreateParms

PREDICATES

  dlg_clipboard_format_eh : EHANDLER
  dlg_clipboard_format_update(DIALOG_VAL_LIST)

CLAUSES

  dlg_clipboard_format_Create(_):-
	not(tmp_cbformat(_,_)),
	assert(tmp_cbformat(idc_text,"")),
	fail.
  dlg_clipboard_format_Create(Parent):-

	tmp_cbformat(ID,NAME),
	set_visible(ID,PROP),
%MARK ClipBoard Format, new variables

	dialog_CreateModal(Parent,dlg_clipboard_format_ResID,"",
  		[
%BEGIN ClipBoard Format, ControlList, 17:32:28-23.11.1999, Code automatically updated!
		df(idc_name,editstr(NAME,PROP),nopr),
		df(ID,radiobuttongroup([idc_text,idc_picture,idc_binary]),nopr)
%END ClipBoard Format, ControlList
		],
		dlg_clipboard_format_eh,0,VALLIST,ANSWER),!,
	ANSWER = idc_ok,
	dlg_clipboard_format_update(VALLIST),!.

  dlg_clipboard_format_Create(_):-
	dlg_Note("Error: Fail in dlg_clipboard_format_Create").

  dlg_clipboard_format_update(_VALLIST):-
%BEGIN ClipBoard Format, Update controls, 17:32:28-23.11.1999, Code automatically updated!
	_NAME = dialog_VLGetstr(idc_name,_VALLIST),
	_ID = dialog_VLGetRadiobutton(idc_text,_VALLIST),
%END ClipBoard Format, Update controls
	NewID = dialog_VLGetRadiobutton(idc_text, _VALLIST),
	NewName = dialog_VLGetStr(idc_name, _VALLIST),
	retractall(tmp_cbformat(_,_)),
	assert(tmp_cbformat(NewID,NewNAME)),
	!.
  dlg_clipboard_format_update(_):-
	dlg_Note("Error: Fail in dlg_clipboard_format_update").

%MARK ClipBoard Format, new events

%BEGIN ClipBoard Format, e_Create
  dlg_clipboard_format_eh(_Win,e_Create(_CreationData),0):-!,
	VAL_LIST = dialog_GetValues(_Win),
	ID = dialog_VLGetRadiobutton(idc_text, VAL_LIST),
	B = set_visible(ID,_),!,
	dialog_SetState(_Win, [show(idc_name, B)]),
	!.
%END ClipBoard Format, e_Create

  dlg_clipboard_format_eh(_Win,e_Control(ID,_WinType,_CtlWin,_CtlInfo),0):-
	VAL_LIST = dialog_GetValues(_Win),
	Name = dialog_VLGetStr(idc_name, VAL_LIST),
	B = set_visible(ID,PROP),!,
	dialog_SetFields(_Win, [ df(idc_name,editstr(NAME,PROP),nopr)]),
	dialog_SetState(_Win, [show(idc_name, B)]).
  dlg_clipboard_format_eh(_,_,_):-!,fail.

%END_DLG ClipBoard Format








