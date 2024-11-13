/*****************************************************************************

		 Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  RICHEDIT
 FileName: RICHEDIT.PRO
 Purpose: RichEdit using sample
 Written by: Oleg V. Erjomin
 Comments:
******************************************************************************/

include "richedit.inc"
include "richedit.con"
include "hlptopic.con"

%BEGIN_WIN Task Window
/***************************************************************************
	Event handling for Task Window
***************************************************************************/
GLOBAL PREDICATES
  MEM_MovMem (string,string,unsigned) - (i,i,i) language c

GLOBAL DOMAINS
  FILE = rtf_file


PREDICATES

  task_win_eh : EHANDLER

CONSTANTS

%BEGIN Task Window, CreateParms, 13:51:04-24.11.1999, Code automatically updated!
  task_win_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Close,wsf_Maximize,wsf_Minimize,wsf_ClipSiblings]
  task_win_Menu  = res_menu(idr_edit_menu)
  task_win_Title = "Simple Word Processor"
  task_win_Help  = idh_contents
%END Task Window, CreateParms

CLAUSES

%BEGIN Task Window, e_Create
  task_win_eh(_Win,e_Create(_),0):-!,
  	vpi_LoadDLL ("RICHED32.DLL"),
%BEGIN Task Window, InitControls, 13:51:04-24.11.1999, Code automatically updated!
%END Task Window, InitControls
%BEGIN Task Window, ToolbarCreate, 13:51:04-24.11.1999, Code automatically updated!
	tb_project_toolbar_Create(_Win),
	tb_help_line_Create(_Win),
%END Task Window, ToolbarCreate
IFDEF use_message
	msg_Create(100),
ENDDEF
	!.
%END Task Window, e_Create

%MARK Task Window, new events

%BEGIN Task Window, id_file_open
  task_win_eh(Win,e_Menu(id_file_open,_ShiftCtlAlt),0):-!,
	FN=dlg_GetFileName("*.rtf",["RTF files (*.rtf)","*.rtf"],
  			"Open File",
  			[],
  			"",_),
  	win_Document_Create (Win,FN,0),
	!.
%END Task Window, id_file_open

%BEGIN Task Window, id_file_new
  task_win_eh(Win,e_Menu(id_file_new,_ShiftCtlAlt),0):-!,
  	win_Document_Create (Win,"Untitled Document",1),
	!.
%END Task Window, id_file_new

%BEGIN Task Window, id_help_contents
  task_win_eh(_Win,e_Menu(id_help_contents,_ShiftCtlAlt),0):-!,
  	vpi_ShowHelp("richedit.hlp"),
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
IFDEF use_tbar
	toolbar_Resize(_Win),
ENDDEF
IFDEF use_message
	msg_Resize(_Win),
ENDDEF
	!.
%END Task Window, e_Size

%END_WIN Task Window

/***************************************************************************
	Invoking on-line Help
***************************************************************************/

  project_ShowHelpContext(HelpTopic):-
  	vpi_ShowHelpContext("richedit.hlp",HelpTopic).

/***************************************************************************
	Main Goal
***************************************************************************/

GOAL

IFDEF use_mdi
  vpi_SetAttrVal(attr_win_mdi,b_true),
ENDDEF
IFDEF ws_win
  IFDEF use_3dctrl
    vpi_SetAttrVal(attr_win_3dcontrols,b_true),
  ENDDEF
ENDDEF  
  vpi_Init(task_win_Flags,task_win_eh,task_win_Menu,"richedit",task_win_Title).

%BEGIN_TLB Project toolbar, 13:51:16-24.11.1999, Code automatically updated!
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
		 tb_ctrl(id_Format_Effects_bold,pushb,idb_bold_up,idb_bold_down,idb_bold_up,"Bold;Bold Text",1,1),
		 tb_ctrl(id_Format_Effects_italic,pushb,idb_italic_up,idb_italic_down,idb_italic_up,"Italic;Cursive Text",1,1),
		 tb_ctrl(id_Format_Effects_underline,pushb,idb_underline_up,idb_underline_down,idb_underline_up,"Underline;Underlined Text",1,1),
		 tb_ctrl(id_Format_Effects_strike_out,pushb,idb_strike_up,idb_strike_down,idb_strike_up,"Strike Out;Strike Text Out",1,1),
		 separator,
		 tb_ctrl(id_Format_Alignment_left,pushb,idb_left_up,idb_left_down,idb_left_up,";Algn Left;Align Text Left",1,1),
		 tb_ctrl(id_Format_Alignment_right,pushb,idb_right_up,idb_right_down,idb_right_up,"Algn Right;Align Text Right",1,1),
		 tb_ctrl(id_Format_Alignment_center,pushb,idb_center_up,idb_center_down,idb_center_up,"Center;Center Text ",1,1),
		 separator,
		 tb_ctrl(id_help_contents,pushb,idb_help_up,idb_help_down,idb_help_up,"Help;Help",0,1)]),
enddef
	true.
%END_TLB Project toolbar

%BEGIN_TLB Help line, 13:51:20-24.11.1999, Code automatically updated!
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

CONSTANTS

%BEGIN About dialog, CreateParms, 15:02:14-25.11.1999, Code automatically updated!
  dlg_about_dialog_ResID = idd_dlg_about
  dlg_about_dialog_DlgType = wd_Modal
  dlg_about_dialog_Help = idh_contents
%END About dialog, CreateParms

PREDICATES

  dlg_about_dialog_eh : EHANDLER

CLAUSES

  dlg_about_dialog_Create(Parent):-
	win_CreateResDialog(Parent,dlg_about_dialog_DlgType,dlg_about_dialog_ResID,dlg_about_dialog_eh,0).

%BEGIN About dialog, idc_ok _CtlInfo
  dlg_about_dialog_eh(_Win,e_Control(idc_ok,_CtrlType,_CtrlWin,_CtrlInfo),0):-!,
	win_Destroy(_Win),
	!.
%END About dialog, idc_ok _CtlInfo
%MARK About dialog, new events

  dlg_about_dialog_eh(_,_,_):-!,fail.

%END_DLG About dialog

%BEGIN_WIN Document
/**************************************************************************
        Creation and event handling for window: Document
**************************************************************************/
/******************************************************
 *   Native  Messages                                 *
 ******************************************************/

CONSTANTS
/* native richedit control messages */
 em_GETLIMITTEXT	= 1061
 em_POSFROMCHAR		= 1062
 em_CHARFROMPOS		= 1063
 em_SCROLLCARET		= 1073
 em_CANPASTE		= 1074
 em_DISPLAYBAND		= 1075
 em_EXGETSEL		= 1076
 em_EXLIMITTEXT		= 1077
 em_EXLINEFROMCHAR	= 1078
 em_EXSETSEL		= 1079
 em_FINDTEXT		= 1080
 em_FORMATRANGE		= 1081
 em_GETCHARFORMAT	= 1082
 em_GETEVENTMASK	= 1083
 em_GETOLEINTERFACE	= 1084
 em_GETPARAFORMAT	= 1085
 em_GETSELTEXT		= 1086
 em_HIDESELECTION	= 1087
 em_PASTESPECIAL	= 1088
 em_REQUESTRESIZE	= 1089
 em_SELECTIONTYPE	= 1090
 em_SETBKGNDCOLOR	= 1091
 em_SETCHARFORMAT	= 1092
 em_SETEVENTMASK	= 1093
 em_SETOLECALLBACK	= 1094
 em_SETPARAFORMAT	= 1095
 em_SETTARGETDEVICE	= 1096
 em_STREAMIN		= 1097
 em_STREAMOUT		= 1098
 em_GETTEXTRANGE	= 1099
 em_FINDWORDBREAK	= 1100
 em_SETOPTIONS		= 1101
 em_GETOPTIONS		= 1102
 em_FINDTEXTEX		= 1103
 em_GETWORDBREAKPROCEX	= 1104
 em_SETWORDBREAKPROCEX	= 1105
/* native edit control messages */
 em_GETRECT		= 0x00B2
 em_SETRECT		= 0x00B3
 em_GETSEL		= 0x00B0
 em_SETSEL		= 0x00B1
 em_CANUNDO		= 0x00C6
 em_UNDO		= 0x00C7
 em_GETMODIFY		= 0x00B8
 em_SETMODIFY		= 0x00B9
 wm_CUT			= 0x0300
 wm_COPY		= 0x0301
 wm_PASTE		= 0x0302
 wm_CLEAR		= 0x0303
 wm_NOTIFY		= 0x004E
 wm_COMMAND		= 0x0111
 en_CHANGE		= 0x0300
/* new notifications */
 en_MSGFILTER	  	= 0x0700
 en_REQUESTRESIZE	= 0x0701
 en_SELCHANGE		= 0x0702
 en_DROPFILES		= 0x0703
 en_PROTECTED		= 0x0704
/* PenWin specific */
 en_CORRECTTEXT		= 0x0705
/* back to new notifications */
 en_STOPNOUNDO		= 0x0706
/* Far East specific notification */
 en_IMECHANGE		= 0x0707
/* back to new notifications */
 en_SAVECLIPBOARD	= 0x0708
 en_OLEOPFAILED		= 0x0709

/* event notification masks */

 enm_NONE		= 0x00000000
 enm_CHANGE		= 0x00000001
 enm_UPDATE		= 0x00000002
 enm_SCROLL		= 0x00000004
 enm_KEYEVENTS		= 0x00010000
 enm_MOUSEEVENTS	= 0x00020000
 enm_REQUESTRESIZE	= 0x00040000
 enm_SELCHANGE		= 0x00080000
 enm_DROPFILES		= 0x00100000
 enm_PROTECTED		= 0x00200000
/* PenWin specific */
 enm_CORRECTTEXT	= 0x00400000
/* Far East specific notification mask */
 enm_IMECHANGE		= 0x00800000

/* CHARFORMAT masks */
 cfm_BOLD		= 0x00000001
 cfm_ITALIC		= 0x00000002
 cfm_UNDERLINE		= 0x00000004
 cfm_STRIKEOUT		= 0x00000008
 cfm_PROTECTED		= 0x00000010
 cfm_SIZE		= 0x80000000
 cfm_COLOR		= 0x40000000
 cfm_FACE		= 0x20000000
 cfm_OFFSET		= 0x10000000
 cfm_CHARSET		= 0x08000000

/* CHARFORMAT effects */
 cfe_BOLD		= 0x0001
 cfe_ITALIC		= 0x0002
 cfe_UNDERLINE		= 0x0004
 cfe_STRIKEOUT		= 0x0008
 cfe_PROTECTED		= 0x0010
/* NOTE: CFE_AUTOCOLOR corresponds to CFM_COLOR, which controls it */
 cfe_AUTOCOLOR		= 0x40000000

/* EM_SETCHARFORMAT wParam masks */
 scf_SELECTION		= 0x0001
 scf_WORD		= 0x0002

/* stream formats */
  sf_text	= 0x0001
  sf_rtf	= 0x0002
  sf_rtfnoobjs	= 0x0003  /* outbound only */
  sf_textized	= 0x0004  /* outbound only */
/* Flag telling stream operations to operate on the selection only */
/* EM_STREAMIN will replace the current selection */
/* EM_STREAMOUT will stream out the current selection */
  sff_selection	= 0x8000
/* Flag telling stream operations to operate on the common RTF keyword only */
/* EM_STREAMIN will accept the only common RTF keyword */
/* EM_STREAMOUT will stream out the only common RTF keyword */
  sff_plainrtf	= 0x4000

/* PARAFORMAT mask values */
 pfm_STARTINDENT	= 0x00000001
 pfm_RIGHTINDENT	= 0x00000002
 pfm_OFFSET		= 0x00000004
 pfm_ALIGNMENT		= 0x00000008
 pfm_TABSTOPS		= 0x00000010
 pfm_NUMBERING		= 0x00000020
 pfm_OFFSETINDENT	= 0x80000000

/* PARAFORMAT numbering options */
 pfn_BULLET		= 0x0001

/* PARAFORMAT alignment options */
 pfa_LEFT		= 0x0001
 pfa_RIGHT		= 0x0002
 pfa_CENTER		= 0x0003
/* Find text options            */
 fr_WHOLEWORD		= 0x0002
 fr_MATCHCASE		= 0x0004

DOMAINS
  charformat = struct charformat
                        (unsigned Size,            /* = 24+2+32 */
                         dword    Mask,
                         dword    Effects,
                         long     Height,
                         long     Offset,
                         dword    ColorRef,
                         byte     CharSet,
                         byte     PitchAndFamily,
                        /*  32 byte placeholder for LF_FACESIZE  */
                         byte,byte,byte,byte,byte,byte,byte,byte,
                         byte,byte,byte,byte,byte,byte,byte,byte,
                         byte,byte,byte,byte,byte,byte,byte,byte,
                         byte,byte,byte,byte,byte,byte,byte,byte 
                         )

 paraformat = struct paraformat (unsigned Size,
                                 dword Mask,
                                 word Numbering,
                                 word Reserved,
                                 long StartIndent,
                                 long RightIndent,
                                 long Offset,
                                 word Alignment,
                                 short TabCount,
                        /*  32 placeholders for TABS  */
                         long,long,long,long,long,long,long,long,
                         long,long,long,long,long,long,long,long,
                         long,long,long,long,long,long,long,long,
                         long,long,long,long,long,long,long,long)
                                 
 editstream = struct editstream (dword Cookie,
                                 dword Error,
                                 EDIT_STREAM_CALLBACK)
                                  
 nmhdr = struct nmhdr (WINDOW From,
    		       unsigned IdFrom,
                       unsigned NM_Code)
 reqresize = struct reqresize (NMHDR,RCT)
 
 charrange = struct charrange (long Min, long Max)
 findtext = struct findtext (long Min, long Max, string TextToFind)
 
DATABASE - docwindow
  determ streamfilename (String)
  determ filelen (Long)
  determ edit_with_focus (Window)
CONSTANTS
%BEGIN Document, CreateParms, 13:51:00-24.11.1999, Code automatically updated!
  win_document_WinType = w_TopLevel
  win_document_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Maximize,wsf_Minimize,wsf_Close,wsf_ClipSiblings]
  win_document_RCT = rct(100,80,566,372)
  win_document_Menu = res_menu(idr_edit_menu)
  win_document_Title = "Document"
  win_document_Help = idh_contents
%END Document, CreateParms

PREDICATES

  win_document_eh : EHANDLER
  
  nondeterm check_True_Item  (Window,MENU_TAG)
  nondeterm check_False_Item (Window,MENU_TAG)
  menu_ID_Color (integer,dword)
  menu_ID_Effect (integer,dword,dword)
  
  menuitem_switch(WINDOW,ILIST,BOOLEAN)
  get_editor_default_rct(RCT)
  
  onSaveDocument  (WINDOW)
  onLoadDocument  (WINDOW)
  onCloseDocument (WINDOW)
  onRequestResize (WINDOW,LONG)
  onCharFormat    (WINDOW,FONT)
  onParaAlignment (WINDOW,INTEGER)
  onCharEffect    (WINDOW,DWORD,DWORD)
  onFontColor     (WINDOW,DWORD)

CLAUSES

  get_editor_default_rct(RCT1):-	
	edit_with_focus(Win),
	trap(RCT=win_GetOuterRect(Win),_,fail),!,
	RCT = rct(L,T,_,_),
	ScrWidth = vpi_GetAttrVal(attr_screen_width),
	ScrHeight = vpi_GetAttrVal(attr_screen_height ),
	TitleBarHeight = vpi_GetAttrVal(attr_title_height) + vpi_GetAttrVal(attr_docframe_height),
	T1 = T + 2*TitleBarHeight, L1 = TitleBarHeight + L, 
	B1 = T1+ ScrHeight/2, R1 = L1+ 2*ScrWidth/3,
	RCT1 = rct(L1,T1,R1,B1),!.
  get_editor_default_rct(rct(L,T,R,B)):-!,
	ScrWidth = vpi_GetAttrVal(attr_screen_width),
	ScrHeight = vpi_GetAttrVal( attr_screen_height ),
	TitleBarHeight = vpi_GetAttrVal(attr_title_height) + vpi_GetAttrVal(attr_docframe_height),
  	L = 0.5*TitleBarHeight, 
  	T = 1.5*TitleBarHeight, R = L + 2*ScrWidth/3, B = T + ScrHeight/2.

  win_document_Create(Parent,Title,New):-
  	retractall (streamfilename(_)),
	assert (streamfilename(Title)),
	get_editor_default_rct(RCT),
	Win=win_Create(win_document_WinType,RCT,win_document_Title,
		   win_document_Menu,Parent,win_document_Flags,win_document_eh,New),
	win_SetText (Win,Title).

%BEGIN Document, e_Create
  win_document_eh(_Win,e_Create(1),0):-!,
  	win_EnableHook(_Win,b_True),
  	win_SetMapMode(_Win,mm_Twips),
%BEGIN Document, InitControls, 13:51:00-24.11.1999, Code automatically updated!
	ED=win_CreateDynControl([customctl(wdef(wc_Custom,rct(7,6,371,275),"",u_Pixels),"RichEdit",idc_richedit,[wsf_Group,wsf_TabStop,wsf_VScroll,wsf_HScroll,0,0x4,0x40,0x100,0x8000])],_Win),
%END Document, InitControls
	Mask = enm_REQUESTRESIZE+enm_CHANGE,
	win_SendEvent(ED,e_Native(em_SETEVENTMASK,0,Mask)).
  win_document_eh(_Win,e_Create(0),0):-!,
  	win_EnableHook(_Win,b_True),
  	win_SetMapMode(_Win,mm_Twips),
	ED=win_CreateDynControl([customctl(wdef(wc_Custom,rct(7,6,371,275),"",u_Pixels),"RichEdit",idc_richedit,[wsf_Group,wsf_TabStop,wsf_VScroll,wsf_HScroll,0,0x4,0x40,0x100,0x8000])],_Win),
	Mask = enm_REQUESTRESIZE+enm_CHANGE,
	win_SendEvent(ED,e_Native(em_SETEVENTMASK,0,Mask)),
	win_SendEvent(ED,e_Native(em_EXLIMITTEXT,0,0x8FFFFF)),
	/*
	PWIN=print_StartJob (""),
	HDC=win_GetNativeGraphicContext(PWIN,_RELEASE),
	win_SendEvent(ED,e_Native(em_SETTARGETDEVICE,HDC,1000)),
	print_EndJob (PWIN),
	*/
	win_SetFocus (ED),
	onLoadDocument (ED),
%BEGIN Document, ToolbarCreate, 13:51:00-24.11.1999, Code automatically updated!
%END Document, ToolbarCreate
	!.
%END Document, e_Create
%MARK Document, new events

%BEGIN Document, e_CloseRequest
  win_document_eh(Win,e_CloseRequest,0):-!,
  	ED = win_GetCtlHandle (Win,idc_richedit),
  	RET = win_SendEvent (ED,e_Native(em_GETMODIFY,0,0)),
  	not(RET = b_False),
  	onCloseDocument (ED),
	!.
%END Document, e_CloseRequest

%BEGIN Document, id_edit_select_all
  win_document_eh(Win,e_Menu(id_edit_select_all,_ShiftCtlAlt),0):-!,
  	ED = win_GetCtlHandle (Win,idc_richedit),
  	win_SendEvent (ED,e_Native(em_SETSEL,0,-1)),
	!.
%END Document, id_edit_select_all

%BEGIN Document, e_GetFocus
  win_document_eh(Win,e_GetFocus,0):-!,
  	retractall (edit_with_focus(_)),
  	assert (edit_with_focus(Win)),
  	ED = win_GetCtlHandle (Win,idc_richedit),
	win_SetFocus( ED ),
	!.
%END Document, e_GetFocus

  win_document_eh(Win,e_Menu(ID,_),0):-
  	menu_ID_Color(ID,Color),!,
  	ED = win_GetCtlHandle (Win,idc_richedit),
	onFontColor (ED,Color).
	
  win_document_eh(Win,e_Menu(ID,_),0):-
  	menu_ID_Effect(ID,Mask,Effect),!,
  	ED = win_GetCtlHandle (Win,idc_richedit),
	onCharEffect (ED,Mask,Effect).
%BEGIN Document, id_Format_Alignment_right
  win_document_eh(Win,e_Menu(id_Format_Alignment_right,_ShiftCtlAlt),0):-!,
  	onParaAlignment (Win,pfa_RIGHT),
	!.
%END Document, id_Format_Alignment_right

%BEGIN Document, id_Format_Alignment_left
  win_document_eh(Win,e_Menu(id_Format_Alignment_left,_ShiftCtlAlt),0):-!,
  	onParaAlignment (Win,pfa_LEFT),
	!.
%END Document, id_Format_Alignment_left

%BEGIN Document, id_Format_Alignment_center
  win_document_eh(Win,e_Menu(id_Format_Alignment_center,_ShiftCtlAlt),0):-!,
	onParaAlignment (Win,pfa_CENTER),
	!.
%END Document, id_Format_Alignment_center

%BEGIN Document, id_Format_paragraph
  win_document_eh(_Win,e_Menu(id_Format_paragraph,_ShiftCtlAlt),0):-!,
  	dlg_format_paragraph_Create (_Win),
	!.
%END Document, id_Format_paragraph

%BEGIN Document, id_Format_character
  win_document_eh(Win,e_Menu(id_Format_character,_ShiftCtlAlt),0):-!,
  	ED=win_GetCtlHandle(Win,idc_richedit),
  	OLDFONT=win_GetFont (Win),
   	NEWFONT=dlg_ChooseFont (OLDFONT),
	win_SetFont (Win,NEWFONT),
	onCharFormat (ED,NEWFONT),
	!.
%END Document, id_Format_character

%BEGIN Document, e_InitMenu
  win_document_eh(Win,e_InitMenu,0):-!,
  	ED=win_GetCtlHandle(Win,idc_richedit),
  	findall(Item1,check_True_Item (ED,Item1),ItemList1),
  	findall(Item2,check_False_Item (ED,Item2),ItemList2),
  	menuItem_Switch (Win,ItemList1,b_True),
  	menuItem_Switch (Win,ItemList2,b_False),
	!.
%END Document, e_InitMenu

%BEGIN Document, id_edit_undo
  win_document_eh(Win,e_Menu(id_edit_undo,_ShiftCtlAlt),0):-!,
  	ED=win_GetCtlHandle(Win,idc_richedit),
  	win_SendEvent(ED,e_Native(em_UNDO,0,0)),
	!.
%END Document, id_edit_undo

%BEGIN Document, id_edit_paste
  win_document_eh(Win,e_Menu(id_edit_paste,_ShiftCtlAlt),0):-!,
	ED=win_GetCtlHandle(Win,idc_richedit),
  	win_SendEvent(ED,e_Native(wm_PASTE,0,0)),
	!.
%END Document, id_edit_paste

%BEGIN Document, id_edit_find_
  win_document_eh(Win,e_Menu(id_edit_find_,_ShiftCtlAlt),0):-!,
  	dlg_find_text_create (Win),
	!.
%END Document, id_edit_find_

%BEGIN Document, id_edit_delete
  win_document_eh(Win,e_Menu(id_edit_delete,_ShiftCtlAlt),0):-!,
  	ED=win_GetCtlHandle(Win,idc_richedit),
  	win_SendEvent(ED,e_Native(wm_CLEAR,0,0)),
	!.
%END Document, id_edit_delete

%BEGIN Document, id_edit_cut
  win_document_eh(Win,e_Menu(id_edit_cut,_ShiftCtlAlt),0):-!,
  	ED=win_GetCtlHandle(Win,idc_richedit),
  	win_SendEvent(ED,e_Native(wm_CUT,0,0)),
	!.
%END Document, id_edit_cut

%BEGIN Document, id_edit_copy
  win_document_eh(Win,e_Menu(id_edit_copy,_ShiftCtlAlt),0):-!,
  	ED=win_GetCtlHandle(Win,idc_richedit),
  	win_SendEvent(ED,e_Native(wm_COPY,0,0)),
	!.
%END Document, id_edit_copy

%BEGIN Document, e_Destroy
  win_document_eh(_Win,e_Destroy,0):-!,
  	win_EnableHook (_Win,b_false),
	!.
%END Document, e_Destroy

%BEGIN Document, e_Native

  win_document_eh(Win,e_Native(en_REQUESTRESIZE,_WParam,_LParam),0):-!,
  	ED=win_GetCtlHandle(Win,idc_richedit),
  	onRequestResize (ED,_LParam),
	!.
%END Document, e_Native

%BEGIN Document, id_file_save_as
  win_document_eh(Win,e_Menu(id_file_save_as,_ShiftCtlAlt),0):-!,
  	ED=win_GetCtlHandle(Win,idc_richedit),
  	FN=dlg_GetFileName("*.rtf",["RTF files (*.rtf)","*.rtf"],
  			"Save File As",
  			[dlgfn_Save],
  			"",_),
  	retractall (streamfilename(_)),
  	assert (streamfilename(FN)),
    	onSaveDocument (ED),
    	win_SetText (Win,FN),
	!.
%END Document, id_file_save_as

%BEGIN Document, id_file_save
  win_document_eh(Win,e_Menu(id_file_save,_ShiftCtlAlt),0):-
  	Title=win_GetText (Win),
  	Title="Untitled Document",!,
  	ED=win_GetCtlHandle(Win,idc_richedit),
  	FN=dlg_GetFileName("*.rtf",["RTF files (*.rtf)","*.rtf"],
  			"Save File As",
  			[dlgfn_Save],
  			"",_),
  	retractall (streamfilename(_)),
  	assert (streamfilename(FN)),
    	onSaveDocument (ED),
    	win_SetText (Win,FN),
	!.
  win_document_eh(Win,e_Menu(id_file_save,_ShiftCtlAlt),0):-!,
  	ED=win_GetCtlHandle(Win,idc_richedit),
    	onSaveDocument (ED).
%END Document, id_file_save
%BEGIN Document, e_Size
  win_document_eh(Win,e_Size(_Width,_Height),0):-!,
IFDEF use_tbar
	toolbar_Resize(Win),
ENDDEF
	ED=win_GetCtlHandle(Win,idc_richedit),
  	RCT = rct(0,0,_Width,_Height),
  	win_SendEvent (ED,e_Native(em_REQUESTRESIZE,0,0)),
  	win_Move (ED,RCT),
	!.
%END Document, e_Size

%BEGIN Document, e_Menu, Parent window 
  win_document_eh(Win,e_Menu(ID,CAS),0):-!,
	PARENT = win_GetParent(Win),
	win_SendEvent(PARENT,e_Menu(ID,CAS)),
	!.
%END Document, e_Menu, Parent window

%END_WIN Document


/******************************************************
     Stream In/Out
     
     RichEdit calls callback function to perform
     input/output operation for the portion of
     its content.
******************************************************/

DOMAINS
  EDIT_STREAM_CALLBACK = determ DWORD (DWORD Cookie, STRING Buff, LONG Cb, LONG Pb) 
                                       - (i,i,i,o) language stdcall

PREDICATES
   myStreamCallBack : EDIT_STREAM_CALLBACK
   streamReadWrite (Integer,String,Long,Long)
   streamIn (Long,               % file lenght
             Long,               % count of bytes to read
             String,             % buffer
             Long)               % actual read
   str_ncpy (integer,integer,integer,integer,long)
   str_ncpy2 (integer,integer,integer,integer,long)
CLAUSES
   %
   %  Stream callback function
   %
   %  Cookie = 1 to stream out
   %         = 0 to stream in
   %
   %  Nonzero value of Pb (in practice) indicates the operation continue
   %  (but in documentation the return value is used for this porpuse)
   %
   myStreamCallBack (Cookie, Buff, Cb, Pb, 0) :-
   	streamReadWrite (Cookie,Buff,Cb,ActualReadWrite),
   	Pb=ActualReadWrite.
   	
   streamReadWrite (1,Buff,_Cb,ActualWrite) :- !,
   	str_len (Buff,ActualWrite),
   	writeblock (ActualWrite,Buff).
   streamReadWrite (0,Buff,Cb,ActualRead) :-
   	filelen (Len),
   	streamIn (Len,Cb,Buff1,ActualRead),
   	ptr_dword (Buff1,Src_SEG,Src_OFF),
	ptr_dword (Buff,Dest_SEG,Dest_OFF),
	str_ncpy (Dest_SEG,Dest_OFF,Src_SEG,Src_OFF,ActualRead).
   %
   %   input procedure
   %
   streamIn (Len,Cb,Buff,Cb) :-
  	filepos (rtf_file,Pos,0),
  	Rest = Len - Pos,
  	Rest >= Cb,!,
  	readblock (Cb,Bin),
  	term_bin(string,Buff,Bin).
   streamIn (Len,_Cb,Buff,Rest) :-
  	filepos (rtf_file,Pos,0),
  	Rest = Len - Pos,
  	readblock(Rest,Bin),
  	term_bin (string,Buff,Bin).
  %
  %  the strcpy analogue
  %
  str_ncpy (_,_,_,_,0) :-!.
  str_ncpy (Dest_SEG,Dest_OFF,Src_SEG,Src_OFF,Cb) :-
	membyte (Src_SEG,Src_OFF,B),%B<>0,!,
	membyte (Dest_SEG,Dest_OFF,B),
	Dest_OFF_1 = Dest_OFF + 1,
	Src_OFF_1 = Src_OFF + 1,
	Cb1 = Cb-1,!,
	str_ncpy (Dest_SEG,Dest_OFF_1,Src_SEG,Src_OFF_1,Cb1).

  str_ncpy2 (_,_,_,_,0) :-!.
  str_ncpy2 (Dest_SEG,Dest_OFF,Src_SEG,Src_OFF,_) :-
	membyte (Src_SEG,Src_OFF,B),B=0,!,
	membyte (Dest_SEG,Dest_OFF,B).
  str_ncpy2 (Dest_SEG,Dest_OFF,Src_SEG,Src_OFF,Cb) :-
	membyte (Src_SEG,Src_OFF,B),B<>0,!,
	membyte (Dest_SEG,Dest_OFF,B),
	Dest_OFF_1 = Dest_OFF + 1,
	Src_OFF_1 = Src_OFF + 1,
	Cb1 = Cb-1,!,
	str_ncpy2 (Dest_SEG,Dest_OFF_1,Src_SEG,Src_OFF_1,Cb1).

/******************************************************
    Input/Output Procedures
    
    Fill the EDITSTREAM structure, then pass
    ES_STREAMIN/ES_STREAMOUT messages to the
    control
******************************************************/
PREDICATES
   save_discard_cancel (integer,window)
   ask_for_filename_and_save (window)
CLAUSES
   onSaveDocument (Win) :-
   	ESTREAM = editstream (1,0,myStreamCallBack),
   	LPARAM = cast (long,ESTREAM),
   	WPARAM = sf_rtf,
   	streamfilename (FN),
   	writedevice (Old),
   	format (Err,"Cannot open %s for output",FN),
   	trap(openwrite (rtf_file,FN),_,dlg_Error(Err)),
   	writedevice (rtf_file),
   	win_SendEvent (Win, e_Native(em_STREAMOUT,WPARAM,LPARAM)),
   	writedevice (Old),
   	trap(closefile(rtf_file),_,fail).

   onLoadDocument (Win) :-
   	ESTREAM = editstream (0,0,myStreamCallBack),
   	LPARAM = cast (long,ESTREAM),
   	WPARAM = sf_rtf,
   	streamfilename (FN),
   	readdevice (Old),
   	format (Err,"Cannot open %s for input",FN),
   	trap(openread (rtf_file,FN),_,dlg_Error(Err)),
   	readdevice (rtf_file),
   	filepos (rtf_file,0,2),   % move to the EOF,
   	filepos (rtf_file,Len,0), % retrieve file lenth
   	filepos (rtf_file,0,0),   % move to BOF,
	retractall (filelen(_)),
	assert (filelen(Len)),
   	win_SendEvent (Win, e_Native(em_STREAMIN,WPARAM,LPARAM)),
   	win_SendEvent (Win, e_Native(em_SETMODIFY,b_False,0)),
   	readdevice (Old),
   	trap(closefile(rtf_file),_,fail).
   
   onRequestResize (Win,LParam) :-
   	REQRESIZE = cast(reqresize,LParam),
   	REQRESIZE = reqresize(_,RCT),
   	write ("REQ=",REQRESIZE),
   	win_Move (Win,RCT).
   	
   onCloseDocument (ED) :-
   	Win=win_GetParent(ED),
   	Title=win_GetText (Win),
   	format (Ask,"%s has been changed",Title),
   	RET=dlg_Ask ("Simple Word Processor",Ask,["Save","Discard","Cancel"]),
   	save_discard_cancel (Ret,ED).
   	
   save_discard_cancel (resp_default,ED) :- !,
   	ask_for_filename_and_save (ED).
   save_discard_cancel (resp_2,_) :- !,fail.
   save_discard_cancel (resp_3,_) :- !,true.   % don't close me

   ask_for_filename_and_save (ED) :-
   	Win=win_GetParent(ED),
   	Title=win_GetText (Win),
  	Title="Untitled Document",
  	ED=win_GetCtlHandle(Win,idc_richedit),
  	FN=dlg_GetFileName("*.rtf",["RTF files (*.rtf)","*.rtf"],
  			"Save File As",
  			[dlgfn_Save],
  			"",_),!,		% get filename and save
  	retractall (streamfilename(_)),
  	assert (streamfilename(FN)),
    	onSaveDocument (ED),
    	fail.
   ask_for_filename_and_save (ED) :-
   	Win=win_GetParent(ED),
   	Title=win_GetText (Win),
  	Title="Untitled Document",!,
  	true.					% don't close me
   ask_for_filename_and_save (ED) :- !,
   	onSaveDocument (ED),
   	fail.
/******************************************************
     Character Formatting
******************************************************/
PREDICATES
  get_FaceName (FONT,UNSIGNED,STRING,STRING)
  cfe_SetBold (integer,dword,dword)
  cfe_SetItalic (integer,dword,dword)
  cfe_SetStrike (integer,dword,dword)
  cfe_SetUnderline (integer,dword,dword)
  
CLAUSES
  onCharFormat (Win,Font) :-
  	/*  parse font binary */
  	LFHeight         = getdwordentry(FONT,0),
	_LFWidth          = getdwordentry(FONT,1),
	_LFEscapement     = getdwordentry(FONT,2),
	_LFOrientaion     = getdwordentry(FONT,3),
	LFWeight         = getdwordentry(FONT,4),
	LFItalic         = getbyteentry(FONT,20),
	LFUnderline      = getbyteentry(FONT,21),
	LFStrikeOut      = getbyteentry(FONT,22),
	LFCharSet        = getbyteentry(FONT,23),
	_LFOutPrecision   = getbyteentry(FONT,24),
	_LFClipPrecision  = getbyteentry(FONT,25),
	_LFQuality        = getbyteentry(FONT,26),
	LFPitchAndFamily = getbyteentry(FONT,27),
	get_FaceName (FONT,28,"",LFFaceName),
	/*  fill char format structure  */
 	MAsk = cfm_BOLD+cfm_ITALIC+cfm_UNDERLINE+cfm_STRIKEOUT+cfm_PROTECTED+
 	       cfm_SIZE+cfm_COLOR+cfm_FACE+cfm_OFFSET+cfm_CHARSET,
	cfe_SetBold (LFWeight,0,CFE_1),
	cfe_SetItalic (LFItalic,CFE_1,CFE_2),
	cfe_SetStrike (LFStrikeOut,CFE_2,CFE_3),
	cfe_SetUnderline (LFUnderline,CFE_3,Effects),
	HRES=vpi_GetAttrVal(attr_screen_hres),
	Size = -LFHeight * 1440 / HRES,
	CF = charformat (60,Mask,Effects,Size,0,0,LFCharSet,LFPitchAndFamily,
	                 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	                 ),
	PCF = cast(string,CF),
	ptr_dword (LFFaceName,SEG_1,OFF_1),
	ptr_dword (PCF,SEG_2,OFF_2),
	OFF_3 = OFF_2 + 26,
	str_ncpy2 (SEG_2,OFF_3,SEG_1,OFF_1,32),
	/*  set the new font  */
	LPARAM = cast (long, CF),
	win_SendEvent (Win,e_Native(em_SETCHARFORMAT,scf_SELECTION,LPARAM)).

  get_FaceName (FONT,Index,Buff,FaceName) :-
  	NextByte = getbyteentry(FONT,Index),
  	NextByte <> 0,!,
  	Ch = cast(char,NextByte),
  	str_char(Str,Ch),
  	concat (Buff,Str,Buff1),
  	Index1 = Index+1,
  	get_FaceName (FONT,Index1,Buff1,FaceName).
  get_FaceName (_,_,FaceName,FaceName).
  
  cfe_SetBold (Weight,E1,E2) :-
  	Weight > 500, E2 = E1 + cfe_Bold,!.
  cfe_SetBold (_,E,E).
  
  cfe_SetItalic (0,E,E) :- !.
  cfe_SetItalic (_,E1,E2) :- E2 = E1 + cfe_Italic.
  
  cfe_SetStrike (0,E,E) :- !.
  cfe_SetStrike (_,E1,E2) :- E2 = E1 + cfe_StrikeOut.
  
  cfe_SetUnderline (0,E,E) :- !.
  cfe_SetUnderline (_,E1,E2) :- E2 = E1 + cfe_Underline.

  menu_ID_Effect (id_Format_Effects_underline,	cfm_UNDERLINE,	cfe_UNDERLINE).
  menu_ID_Effect (id_Format_Effects_strike_out,	cfm_STRIKEOUT,	cfe_STRIKEOUT).
  menu_ID_Effect (id_Format_Effects_italic,	cfm_ITALIC,	cfe_ITALIC).
  menu_ID_Effect (id_Format_Effects_bold,	cfm_BOLD,	cfe_BOLD).
  
  onCharEffect (ED,Mask,Effect) :-
 	CF = charformat (60,Mask,Effect,0,0,0,0,0,
	                 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	                 ),
	LPARAM = cast (long, CF),
	win_SendEvent (ED,e_Native(em_SETCHARFORMAT,scf_SELECTION,LPARAM)).

/******************************************************
    Font Colouring
******************************************************/
CLAUSES
  menu_ID_Color (id_Format_Font_Color_Black, 	0x000000).
  menu_ID_Color (id_Format_Font_Color_Green, 	0x008000).
  menu_ID_Color (id_Format_Font_Color_Silver, 	0xC0C0C0).
  menu_ID_Color (id_Format_Font_Color_Lime,	0x00FF00).
  menu_ID_Color (id_Format_Font_Color_Gray, 	0x808080).
  menu_ID_Color (id_Format_Font_Color_Olive, 	0x008080).
  menu_ID_Color (id_Format_Font_Color_White, 	0xFFFFFF).
  menu_ID_Color (id_Format_Font_Color_Yellow, 	0x00FFFF).
  menu_ID_Color (id_Format_Font_Color_Maroon, 	0x000080).
  menu_ID_Color (id_Format_Font_Color_Navy, 	0x800000).
  menu_ID_Color (id_Format_Font_Color_Red, 	0x0000FF).
  menu_ID_Color (id_Format_Font_Color_Blue,	0xFF0000).
  menu_ID_Color (id_Format_Font_Color_Purple, 	0x800080).
  menu_ID_Color (id_Format_Font_Color_Teal,	0x808000).
  menu_ID_Color (id_Format_Font_Color_Fuchsia, 	0xFF00FF).
  menu_ID_Color (id_Format_Font_Color_Aqua,	0xFFFF00).
  
  onFontColor (ED,Color) :-
  	Mask = cfm_COLOR,
  	CF = charformat (60,Mask,0,0,0,Color,0,0,
	                 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	                 ),
	LPARAM = cast (long, CF),
	win_SendEvent (ED,e_Native(em_SETCHARFORMAT,scf_SELECTION,LPARAM)).

/******************************************************
     Menu Enable/Disable Handling
******************************************************/
PREDICATES
  nondeterm member (integer,ilist)
CLAUSES

  member (X,[X|_]).
  member (X,[_|T]):-member(X,T).
  
  menuitem_switch(W,[],_):-
        menu_Update(W),!.
  menuitem_switch(W,[First|Rest],Boolean):-
        menu_Enable(W,First,Boolean),
        menuitem_switch(W,Rest,Boolean).

  check_true_item (_,Item) :-
  	member(Item,[id_edit_delete,id_edit_find_,
  		    id_file_save,id_file_save_as]).
  check_true_item (ED,id_edit_paste) :-
  	RET=win_SendEvent(ED,e_Native(em_CANPASTE,0,0)),
  	RET=b_True.
  check_true_item (ED,Item) :-
  	RET=win_SendEvent(ED,e_Native(em_GETSEL,0,0)),
  	BIN=makebinary(4),
  	setdwordentry(BIN,0,RET),
  	LOWORD=getwordentry(BIN,0),
  	HIWORD=getwordentry(BIN,1),
  	LOWORD<>HIWORD,
  	member (Item,[id_edit_cut,id_edit_copy]).
  check_true_item (ED,id_edit_undo) :-
  	RET=win_SendEvent(ED,e_Native(em_CANUNDO,0,0)),
  	RET=b_true.
  
  check_false_item (ED,id_edit_paste) :-
  	RET=win_SendEvent(ED,e_Native(em_CANPASTE,0,0)),
  	RET=b_false.
  check_false_item (ED,Item) :-
  	RET=win_SendEvent(ED,e_Native(em_GETSEL,0,0)),
  	BIN=makebinary(4),
  	setdwordentry(BIN,0,RET),
  	LOWORD=getwordentry(BIN,0),
  	HIWORD=getwordentry(BIN,1),
  	LOWORD=HIWORD,
  	member (Item,[id_edit_cut,id_edit_copy]).
  check_false_item (ED,id_edit_undo) :-
  	RET=win_SendEvent(ED,e_Native(em_CANUNDO,0,0)),
  	RET=b_false.
  	
%BEGIN_DLG Format Paragraph
/**************************************************************************
	Creation and event handling for dialog: Format Paragraph
**************************************************************************/

CONSTANTS

%BEGIN Format Paragraph, CreateParms, 13:50:56-24.11.1999, Code automatically updated!
  dlg_format_paragraph_ResID = idd_format_paragraph
  dlg_format_paragraph_DlgType = wd_Modal
  dlg_format_paragraph_Help = idh_contents
%END Format Paragraph, CreateParms

PREDICATES

  dlg_format_paragraph_eh : EHANDLER
  para_alignment (integer,word)
  
CLAUSES

  dlg_format_paragraph_Create(Parent):-
	ED = win_GetCtlHandle (Parent,idc_richedit),
	Size = sizeof(paraformat),
	ALIGN = idc_pf_left,
	LEFT_INDENT = r(0),
	RIGHT_INDENT = r(0),
	FIRST_LINE = r(0),
	IS_LIST = b_false,
%MARK Format Paragraph, new variables

	dialog_CreateModal(Parent,dlg_format_paragraph_ResID,"",
  		[
%BEGIN Format Paragraph, ControlList, 13:50:56-24.11.1999, Code automatically updated!
		df(idc_pf_left_indent,editreal(LEFT_INDENT,[]),nopr),
		df(idc_pf_right_indent,editreal(RIGHT_INDENT,[]),nopr),
		df(idc_pf_first_line,editreal(FIRST_LINE,[]),nopr),
		df(idc_pf_list,checkbox(IS_LIST),nopr),
		df(ALIGN,radiobuttongroup([idc_pf_left,idc_pf_center,idc_pf_right]),nopr)
%END Format Paragraph, ControlList
		],
		dlg_format_paragraph_eh,0,VALLIST,ANSWER),
	ANSWER = idc_ok,
	_LEFT_INDENT = dialog_VLGetReal(idc_pf_left_indent,VALLIST),
	_RIGHT_INDENT = dialog_VLGetReal(idc_pf_right_indent,VALLIST),
	_FIRST_LINE = dialog_VLGetReal(idc_pf_first_line,VALLIST),
	_ALIGN = dialog_VLGetRadiobutton(idc_pf_left,VALLIST),
	_IS_LIST = dialog_VLGetCheck(idc_pf_list,VALLIST),
	Mask =  pfm_STARTINDENT+pfm_RIGHTINDENT+pfm_OFFSET+pfm_ALIGNMENT+
 		pfm_TABSTOPS+pfm_NUMBERING,
 	Numbering = _IS_LIST, Reserved = 0,
 	para_Alignment (_ALIGN,Alignment),
 	_RIGHT_INDENT=r(RI),_LEFT_INDENT=r(LI),_FIRST_LINE=r(FL),
 	RightIndent = RI * 1440,
 	StartIndent = (FL + LI) * 1440,
 	Offset = -FL * 1440,
 	PF = paraformat (Size,Mask,Numbering,Reserved,
 	                  StartIndent,RightIndent,Offset,
 	                  Alignment,0,
 	                  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
 	                  ),
 	LPARAM = cast (long,PF),
 	win_SendEvent (ED,e_Native(em_SETPARAFORMAT,0,LPARAM)).
%MARK Format Paragraph, new events

  dlg_format_paragraph_eh(_,_,_):-!,fail.

%END_DLG Format Paragraph

  para_alignment (idc_pf_left,pfa_LEFT).
  para_alignment (idc_pf_right,pfa_RIGHT).
  para_alignment (idc_pf_center,pfa_CENTER).

  onParaAlignment (Win,Alignment) :-
  	ED = win_GetCtlHandle (Win,idc_richedit),
	Size = sizeof(paraformat),
	Mask = pfm_ALIGNMENT,
 	PF = paraformat (Size,Mask,0,0,0,0,0,
 	                  Alignment,0,
 	                  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
 	                  ),
 	LPARAM = cast (long,PF),
 	win_SendEvent (ED,e_Native(em_SETPARAFORMAT,0,LPARAM)).

%BEGIN_DLG Find Text
/**************************************************************************
	Creation and event handling for dialog: Find Text
**************************************************************************/

CONSTANTS

%BEGIN Find Text, CreateParms, 13:50:48-24.11.1999, Code automatically updated!
  dlg_find_text_ResID = idd_find_text
  dlg_find_text_DlgType = wd_Modal
  dlg_find_text_Help = idh_contents
%END Find Text, CreateParms

PREDICATES

  dlg_find_text_eh : EHANDLER
  dlg_find_text_update(DIALOG_VAL_LIST,WINDOW,word,word)
  
  find_text_scope (word,word,integer)
  find_set_case (boolean,word,word)
  find_set_whole_words (boolean,word,word)
  find_get_range (integer SCOPE,integer DIRECTION,
                  integer SELMIN,integer SELMAX,
                  integer FINDMIN,integer FINDMAX)
  ifTextFound (WINDOW, integer, string)

CLAUSES

  find_text_scope (W,W,idc_from_cursor):-!.
  find_text_scope (_,_,idc_selected_text).

  dlg_find_text_Create(Parent):-
	ED = win_GetCtlHandle (Parent,idc_richedit),
	%  get selection
	RET=win_SendEvent(ED,e_Native(em_GETSEL,0,0)),
  	BIN=makebinary(4),
  	setdwordentry(BIN,0,RET),
  	LOWORD=getwordentry(BIN,0),
  	HIWORD=getwordentry(BIN,1),
  	find_text_scope (HIWORD,LOWORD,SCOPE),

	TEXT_TO_FIND = "",
	CASE_SENSITIVE = b_false,
	WHOLE_WORDS = b_false,
	DIRECTION = idc_forward,
	
%MARK Find Text, new variables

	dialog_CreateModal(Parent,dlg_find_text_ResID,"",
  		[
%BEGIN Find Text, ControlList, 13:50:48-24.11.1999, Code automatically updated!
		df(idc_text_to_find,editstr(TEXT_TO_FIND,[mandatory]),nopr),
		df(idc_case_sencitive,checkbox(CASE_SENSITIVE),nopr),
		df(idc_whole_words_only,checkbox(WHOLE_WORDS),nopr),
		df(DIRECTION,radiobuttongroup([idc_forward,idc_backward]),nopr),
		df(SCOPE,radiobuttongroup([idc_entire_scope,idc_from_cursor,idc_selected_text]),nopr)
%END Find Text, ControlList
		],
		dlg_find_text_eh,0,VALLIST,ANSWER),
	ANSWER = idc_ok,
	dlg_find_text_update(VALLIST,ED,LOWORD,HIWORD).

  dlg_find_text_update(_VALLIST,ED,SELMIN,SELMAX):-
	TEXT_TO_FIND = dialog_VLGetstr(idc_text_to_find,_VALLIST),
	CASE_SENSITIVE = dialog_VLGetCheck(idc_case_sencitive,_VALLIST),
	WHOLE_WORDS = dialog_VLGetCheck(idc_whole_words_only,_VALLIST),
	DIRECTION = dialog_VLGetRadiobutton(idc_forward,_VALLIST),
	SCOPE = dialog_VLGetRadiobutton(idc_entire_scope,_VALLIST),
	find_set_case (CASE_SENSITIVE,0,OPT1),
	find_set_whole_words (WHOLE_WORDS,OPT1,OPTS),
	find_get_range (SCOPE,DIRECTION,SELMIN,SELMAX,FINDMIN,FINDMAX),
	FT = findtext (FINDMIN,FINDMAX,TEXT_TO_FIND),
	LPARAM = cast(long,FT),
	RET = win_SendEvent (ED,e_Native(em_FINDTEXT,OPTS,LPARAM)),
	ifTextFound (ED,RET,TEXT_TO_FIND).

%MARK Find Text, new events

  dlg_find_text_eh(_,_,_):-!,fail.

%END_DLG Find Text

  find_set_case (b_True,OPT1,OPT2) :-!,OPT2=OPT1+fr_MATCHCASE.
  find_set_case (_,OPT,OPT).
  
  find_set_whole_words (b_True,OPT1,OPT2) :-!,OPT2=OPT1+fr_WHOLEWORD.
  find_set_whole_words (_,OPT,OPT).

  find_get_range (idc_selected_text,_,MIN,MAX,MIN,MAX) :-!.
  find_get_range (idc_entire_scope,_,_,_,0,-1) :-!.
  find_get_range (idc_from_cursor,idc_forward,MIN,_,MIN,-1):-!.
  find_get_range (idc_from_cursor,idc_backward,_,MAX,0,MAX):-!.
  
  ifTextFound (_,-1,TEXT_TO_FIND) :- !,
  	format (Str,"Text is not found in the selected scope: %s",TEXT_TO_FIND),
  	dlg_Note (Str).
  ifTextFound (ED,POS,_) :-
  	win_SendEvent (ED,e_Native(em_SETSEL,POS,POS)),
  	win_SetFocus (ED).
  	

















