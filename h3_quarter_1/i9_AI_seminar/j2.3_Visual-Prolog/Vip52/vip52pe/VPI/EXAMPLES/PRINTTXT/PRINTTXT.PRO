/*****************************************************************************

		 Copyright (c) 1984 - 2000 Prolog Development Center A/S

			VISUAL Prolog

 Project:  PRINTTXT
 FileName: PRINTTXT.PRO
 Purpose: Printer handling
 Written by: Alexander Gostintcev
 Comments:
******************************************************************************/

include "printtxt.inc"
include "printtxt.con"
include "hlptopic.con"

DOMAINS
  PrintResolution = res(LONG HDPI,LONG VPIE,LONG Hres,LONG VRes)

/******************************************************
 Return the first line in a string,The returned line
 contains a linefeed character.
******************************************************/

PREDICATES
  get_line(STRING Input,CHAR NewLineChar,STRING Line,STRING Rest)
CLAUSES
  get_line(Str,Char,StartStr,Rest1):-
	searchchar(Str,Char,Pos),!,
	Len = Pos - 1,
	frontstr(Len,Str,StartStr,Rest),
	frontchar(Rest,_,Rest1).
  get_line(Str,_,Str,"").


/******************************************************
	Expand TAB's
******************************************************/

PREDICATES
  expand_tabs(INTEGER TabSize,STRING StrWithTabs,STRING Expanded)
  expand_tabs(INTEGER TabSize,INTEGER CurOffset,STRING StrWithTabs,STRING Expanded)
CLAUSES
  expand_tabs(TabSize,Str,Expanded):-
	expand_tabs(TabSize,0,Str,Expanded).

  expand_tabs(TabSize,Offset,Str,NewExpanded):-
	searchchar(Str,'\t',POS),!,
	Len = Pos - 1,
	frontstr(Len,Str,Start,Rest),
	frontchar(Rest,_,Rest1),
	NoOfSpaces = TabSize - (Offset + Len) mod TabSize,
	Offset1 = Offset + Len + NoOfSpaces,
	expand_tabs(TabSize,Offset1,Rest1,RestExpanded),
	str_len(Spaces,NoOfSpaces),
	format(NewExpanded,"%s%s%s",Start,Spaces,RestExpanded).
  expand_tabs(_,_,S,S).


/******************************************************
 Print a single line, if the line is longer than 80
 characters, the line wraps to the next line.
******************************************************/

PREDICATES
  print_line(WINDOW,INTEGER,INTEGER,INTEGER,STRING,INTEGER,INTEGER,INTEGER,INTEGER,STRING)

CLAUSES
  print_line(_,_,_,_,"",_,_,Delta1,Delta2,""):-!,                                       % At end of string
	Delta2 = Delta1 + 1.
  print_line(_,_,_,_,RestStrNEW,LineNo,LineNo,Delta,Delta,RestStrNEW):-!.       % At end of page
  print_line(PW,SX,SY,LH,NEWStr,LineNo,MaxLineNo,Delta1,Delta,Rest):-           % Long line that wraps
	str_len(NEWStr,LEN),
	LEN>=80,!,
	frontstr(80,NEWStr,StartStr,RestFROMNEW),
	draw_Text(PW,SX,SY,StartStr),
	Delta2=Delta1+1,
	LineNo1=LineNo+1,
	SYNEW=SY+LH,
	concat("==>",RestFROMNEW,RestFROMNEW1),
	print_line(PW,SX,SYNEW,LH,RestFROMNEW1,LineNo1,MaxLineNo,Delta2,Delta,Rest).
  print_line(PW,SX,SY,LH,NEWStr,Line1,Lines,Delta1,Delta,Rest):-
	draw_Text(PW,SX,SY,NEWStr),
	print_line(PW,SX,SY,LH,"",Line1,Lines,Delta1,Delta,Rest).


/******************************************************
	Print all the lines in a page
******************************************************/
PREDICATES
  print_PageLines(WINDOW,LONG StartX,LONG StartY,LONG LineW,LONG LineH,LONG NoOfLines,STRING Str,STRING Rest,INTEGER TabSize)
  print_PageLines(WINDOW,LONG StartX,LONG StartY,LONG LineW,LONG LineH,LONG CurrLine,LONG NoOfLines,STRING Str,STRING Rest,INTEGER TabSize)
  myconcat(STRING,STRING,STRING)
CLAUSES
  print_PageLines(PW,SX,SY,LW,LH,Lines,Str,Rest,TabSize):-
	print_PageLines(PW,SX,SY,LW,LH,0,Lines,Str,Rest,TabSize).

  print_PageLines(_,_,_,_,_,_,_,"","",_):-!.                            % At end of string
  print_PageLines(_,_,_,_,_,MaxLineNo,MaxLineNo,Str,Str,_):-!.  % At end of page
  print_PageLines(PW,SX,SY,LW,LH,LineNo,MaxLineNo,Str,Rest,TabSize):-
	get_line(Str,'\n',StartStr,RestStr2),
	expand_tabs(TabSize,StartStr,NEWStr),
	print_line(PW,SX,SY,LH,NEWStr,LineNo,MaxLineNo,0,Delta,RestStr1),
	LineNo1 = LineNo + Delta,
	SYNEW = SY + LH * Delta,
	myconcat(RestStr1,RestStr2,RestStr),
	print_PageLines(PW,SX,SYNEW,LW,LH,LineNo1,MaxLineNo,RestStr,Rest,TabSize).

  myconcat("",S,S):-!.
  myconcat(S,"",S):-!.
  myconcat(Str1,Str2,Result):-
	concat(Str1,Str2,Result).

/******************************************************
	Print One Single page
******************************************************/

PREDICATES
  print_Page(WINDOW,STRING,INTEGER PageNo,PrintResolution,STRING Inp,STRING Rest,INTEGER TabSize)

CLAUSES

  print_Page(PW,FName,PageNo,res(HRes,VRes,Height,Width),Str,RestStr,TabSize):-
	V_SCR_RES=vpi_GetAttrVal(attr_screen_vres),
	FSIZE=(10*VRes)/V_SCR_RES,
	FONT=font_Create(ff_Helvetica,[],FSIZE),
	win_SetFont(PW,FONT),
	print_StartPage(PW),
	% -1/2 inch from left and from right
	LineWidth = Width - HRes,
	StartX = HRes div 4,
	StartY = VRes div 2,
	format(Header,"%s  Page -%d-",FName,PageNo),
	draw_Text(PW,StartX,StartY,Header),     %print header
	% -1/2 inch from top and from bottom
	LineHeight=(15*VRes)/V_SCR_RES,
	Lines = (Height-VRes) / LineHeight,
	StartY1 = StartY + 2 * LineHeight,
	Lines1 = Lines-2,
	print_PageLines(PW,StartX,StartY1,LineWidth,LineHeight,0,Lines1,Str,RestStr,TabSize),
	print_EndPage(PW).

/******************************************************
	Print all the pages in a file
******************************************************/

PREDICATES
  print_Pages(WINDOW,STRING FName,INTEGER PageNo,PrintResolution,INTEGER TabSize,STRING)

CLAUSES
  print_Pages(_,_,_,_,_,""):-!.
  print_Pages(PW,FName,PageNo,PrintRes,TabSize,Str):-
	print_Page(PW,FName,PageNo,PrintRes,Str,RestStr,TabSize),
	PageNo1=PageNo+1,
	print_Pages(PW,FName,PageNo1,PrintRes,TabSize,RestStr).


/******************************************************
	Print file
******************************************************/

PREDICATES
  print_file(STRING FileName,INTEGER TabSize)

CLAUSES
  print_file(FName,TabSize):-
	file_str(FName,Str),
	trap(PW = print_StartJob("File printing..."),_,fail),
	!,
	Height = vpi_GetAttrVal(attr_printer_height),
	Width = vpi_GetAttrVal(attr_printer_width),
	HRes = vpi_GetAttrVal(attr_printer_hres),
	VRes = vpi_GetAttrVal(attr_printer_vres),
	PageNo=1,
	print_Pages(PW,FName,PageNo,res(HRes,VRes,Height,Width),TabSize,Str),
	print_EndJob(PW).
  print_file(_,_):-
	Msg="Cannot initialize a print job",
	dlg_Note(Msg).

%BEGIN_WIN Task Window
/***************************************************************************
		Event handling for task window
***************************************************************************/

PREDICATES

  task_win_eh : EHANDLER

CONSTANTS

%BEGIN Task Window, CreateParms, 12:40:56-24.11.1999, Code automatically updated!
  task_win_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Close,wsf_Maximize,wsf_Minimize,wsf_ClipSiblings]
  task_win_Menu  = res_menu(idr_task_menu)
  task_win_Title = "Printtxt"
  task_win_Help  = idh_contents
%END Task Window, CreateParms

CLAUSES

%BEGIN Task Window, e_Create
  task_win_eh(_Win,e_Create(_),0):-!,
%BEGIN Task Window, InitControls, 12:40:56-24.11.1999, Code automatically updated!
%END Task Window, InitControls
%BEGIN Task Window, ToolbarCreate, 12:40:56-24.11.1999, Code automatically updated!
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
	vpi_ShowHelp("printtxt.hlp"),
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

%BEGIN Task Window, e_Update
  task_win_eh(_Win,e_UpDate(RECT),0) :-!,
	DRAWTOOLS = win_GetDrawTools ( _Win ),
	win_SetPen ( _Win, pen ( 1, ps_Solid, color_White ) ),
	win_SetBrush ( _Win, brush ( pat_Solid, color_White ) ),
	draw_Rect ( _Win, RECT ),
	win_SetDrawTools ( _Win ,DRAWTOOLS ).
%END Task Window, e_Update

%BEGIN Task Window, id_print
  task_win_eh(_Win,e_Menu(id_print,_ShiftCtlAlt),0):-!,
    FILENAME=dlg_GetOpenFileName("*.txt",["*.txt","*.txt","*.pro","*.pro"],"Title"),
    FILENAME<>"",
    print_file(FILENAME,6).
%END Task Window, id_print

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
  vpi_Init(task_win_Flags,task_win_eh,task_win_Menu,"printtxt",task_win_Title).

%END_WIN Task Window

%BEGIN_DLG About dialog
/**************************************************************************
	Creation and event handling for dialog: "About dialog"
	Code style: Single dialog
**************************************************************************/

CONSTANTS

%BEGIN About dialog, CreateParms, 23:22:36-10.1.2000, Code automatically updated!
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


















