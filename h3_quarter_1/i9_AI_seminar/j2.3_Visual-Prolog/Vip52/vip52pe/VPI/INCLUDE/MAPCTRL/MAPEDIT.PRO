/******************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S 

 FileName:	MAPEDIT.PRO
 PURPOSE:	Map viewer/editor custom contol
 Written by:	Alexander Butovsky
 Version:	1.0
 Build:		008.981112
 Tested with:   Visual Prolog v.5.1 build 555a
 Comments:	

******************************************************************************/

/**********************************************************************************
	Map in edit mode: object properties editor
**********************************************************************************/
predicates
  dlg_properties_eh : EHANDLER
  determ get_initial_settings(WINDOW,ULONG Id,INTEGER BorderColorIdx,INTEGER FillColorIdx,INTEGER LineStyleIdx,STRING CircleSizeStr,
				STRING LabelText,INTEGER LabelColorIdx,INTEGER LabelFontIdx,INTEGER LabelFontSizeIdx,
				INTEGER LabelFontStyleIdx,STRING LabelXStr,STRING LabelYStr,
				WSFLAGS EnableBrush,WSFLAGS EnableCircle)
  procedure get_label_settings(MAPCTRL_LABEL,STRING LabelText,COLOR LabelColor,FONTFAMILY LabelFont,INTEGER LabelFontSize,
				FONTSTYLE LabelFontStyle,INTEGER LabelX,INTEGER LabelY)
  determ color_index(COLOR,INTEGER ColorIdx)
  determ fontstyle_index(FONTSTYLE,INTEGER FontstyleIdx)
  determ linestyle_index(PENSTYLE,INTEGER PenStyleIdx)
  determ font_index(FONTFAMILY,INTEGER FontIdx)
  determ  fontsize_index(INTEGER FontSize,INTEGER FontSizeIdx)
  procedure set_object_properties(WINDOW MapCtrlWin,WINDOW DlgWin,ULONG Id,INTEGER BorderColorIdx,INTEGER FillColorIdx,
				INTEGER LineStyleIdx,STRING CircleSizeStr,STRING LabelText,INTEGER LabelColorIdx,
				INTEGER LabelFontIdx,INTEGER LabelFontSizeIdx,
				INTEGER LabelFontStyleIdx,STRING LabelXStr,STRING LabelYStr)
  determ check_str_int(WINDOW,INTEGER CtrlId,STRING,INTEGER)

clauses
ifdef os_os2
  dlg_properties_Create(Parent,Id):-
	win_CreateDynDialog(Parent,
		[dlg(wdef(wd_Modal,rct(50,40,318,191),editdlg_title,u_DlgBase),[wsf_Close,wsf_TitleBar]),
		 ctl(wdef(wc_LBoxButton,rct(44,15,105,77),   "",          u_DlgBase),idc_border_color,[wsf_Group,wsf_TabStop,wsf_VScroll]),
		 ctl(wdef(wc_LBoxButton,rct(133,15,194,77),  "",          u_DlgBase),idc_fill_color,  [wsf_Group,wsf_TabStop,wsf_VScroll]),
		 ctl(wdef(wc_LBoxButton,rct(43,38,106,90),   "",          u_DlgBase),idc_linestyle,   [wsf_Group,wsf_TabStop,wsf_VScroll]),
		 ctl(wdef(wc_Edit,      rct(161,38,194,49),  "",          u_DlgBase),idc_circle_size, [wsf_AlignLeft,wsf_Group,wsf_TabStop,wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,      rct(40,79,128,90),   "",          u_DlgBase),idc_label,       [wsf_AlignLeft,wsf_Group,wsf_TabStop,wsf_AutoHScroll]),
		 ctl(wdef(wc_LBoxButton,rct(133,79,194,141), "",          u_DlgBase),idc_color,       [wsf_Group,wsf_TabStop,wsf_VScroll]),
		 ctl(wdef(wc_LBoxButton,rct(40,100,82,150),  "",          u_DlgBase),idc_font,        [wsf_Group,wsf_TabStop,wsf_VScroll]),
		 ctl(wdef(wc_LBoxButton,rct(87,100,122,150), "",          u_DlgBase),idc_fontsize,    [wsf_Group,wsf_TabStop,wsf_VScroll]),
		 ctl(wdef(wc_LBoxButton,rct(127,100,194,150),"",          u_DlgBase),idc_fontstyle,   [wsf_Group,wsf_TabStop,wsf_VScroll]),
		 ctl(wdef(wc_Edit,      rct(69,121,92,132),  "",          u_DlgBase),idc_hor_pos,     [wsf_Group,wsf_TabStop,wsf_AutoHScroll,wsf_AlignLeft]),
		 ctl(wdef(wc_Edit,      rct(171,121,194,132),"",          u_DlgBase),idc_vert_pos,    [wsf_Group,wsf_TabStop,wsf_AutoHScroll,wsf_AlignLeft]),
		 ctl(wdef(wc_PushButton,rct(217,116,257,128),editdlg_pb1, u_DlgBase),idc_ok,          [wsf_Default,wsf_Group,wsf_TabStop]),
		 ctl(wdef(wc_PushButton,rct(217,131,257,143),editdlg_pb2, u_DlgBase),idc_cancel,      [wsf_Group,wsf_TabStop]),
		 ctl(wdef(wc_Text,      rct(12,40,38,50),    editdlg_txt1,u_DlgBase),idct_1,          [wsf_AlignRight]),
		 ctl(wdef(wc_Text,      rct(112,40,153,50),  editdlg_txt2,u_DlgBase),idct_2,          [wsf_AlignRight]),
		 ctl(wdef(wc_Text,      rct(12,80,35,93),    editdlg_txt3,u_DlgBase),idct_3,          [wsf_AlignLeft]),
		 ctl(wdef(wc_Text,      rct(12,102,34,115),  editdlg_txt4,u_DlgBase),idct_4,          [wsf_AlignLeft]),
		 ctl(wdef(wc_Text,      rct(11,122,61,132),  editdlg_txt5,u_DlgBase),idct_5,          [wsf_AlignRight]),
		 ctl(wdef(wc_Text,      rct(114,122,161,132),editdlg_txt6,u_DlgBase),idct_6,          [wsf_AlignRight]),
		 ctl(wdef(wc_Text,      rct(9,17,39,28),     editdlg_txt7,u_DlgBase),idct_7,          [wsf_AlignRight]),
		 ctl(wdef(wc_Text,      rct(113,17,129,27),  editdlg_txt8,u_DlgBase),idct_8,          [wsf_AlignRight]),
		 ctl(wdef(wc_GroupBox,  rct(5,5,205,60),     editdlg_grb1,u_DlgBase),idc_gb1,         [wsf_NoClipSiblings]),
		 ctl(wdef(wc_GroupBox,  rct(5,67,205,143),   editdlg_grb2,u_DlgBase),idc_gb2,         [wsf_NoClipSiblings])
		],dlg_properties_eh,Id),!.
elsedef		
  dlg_properties_Create(Parent,Id):-
	win_CreateDynDialog(Parent,
		[dlg(wdef(wd_Modal,rct(50,40,318,191),editdlg_title,u_DlgBase),[wsf_Close,wsf_TitleBar]),
		 ctl(wdef(wc_LBoxButton,rct(44,15,105,77),   "",          u_DlgBase),idc_border_color,[wsf_ClipSiblings,wsf_Group,wsf_TabStop,wsf_VScroll]),
		 ctl(wdef(wc_LBoxButton,rct(133,15,194,77),  "",          u_DlgBase),idc_fill_color,  [wsf_ClipSiblings,wsf_Group,wsf_TabStop,wsf_VScroll]),
		 ctl(wdef(wc_LBoxButton,rct(43,38,106,90),   "",          u_DlgBase),idc_linestyle,   [wsf_ClipSiblings,wsf_Group,wsf_TabStop,wsf_VScroll]),
		 ctl(wdef(wc_Edit,      rct(161,38,194,49),  "",          u_DlgBase),idc_circle_size, [wsf_AlignLeft,wsf_ClipSiblings,wsf_Group,wsf_TabStop,wsf_AutoHScroll]),
		 ctl(wdef(wc_Edit,      rct(40,79,128,90),   "",          u_DlgBase),idc_label,       [wsf_AlignLeft,wsf_ClipSiblings,wsf_Group,wsf_TabStop,wsf_AutoHScroll]),
		 ctl(wdef(wc_LBoxButton,rct(133,79,194,141), "",          u_DlgBase),idc_color,       [wsf_ClipSiblings,wsf_Group,wsf_TabStop,wsf_VScroll]),
		 ctl(wdef(wc_LBoxButton,rct(40,100,82,150),  "",          u_DlgBase),idc_font,        [wsf_ClipSiblings,wsf_Group,wsf_TabStop,wsf_VScroll]),
		 ctl(wdef(wc_LBoxButton,rct(87,100,122,150), "",          u_DlgBase),idc_fontsize,    [wsf_ClipSiblings,wsf_Group,wsf_TabStop,wsf_VScroll]),
		 ctl(wdef(wc_LBoxButton,rct(127,100,194,150),"",          u_DlgBase),idc_fontstyle,   [wsf_ClipSiblings,wsf_Group,wsf_TabStop,wsf_VScroll]),
		 ctl(wdef(wc_Edit,      rct(69,121,92,132),  "",          u_DlgBase),idc_hor_pos,     [wsf_ClipSiblings,wsf_Group,wsf_TabStop,wsf_AutoHScroll,wsf_AlignLeft]),
		 ctl(wdef(wc_Edit,      rct(171,121,194,132),"",          u_DlgBase),idc_vert_pos,    [wsf_ClipSiblings,wsf_Group,wsf_TabStop,wsf_AutoHScroll,wsf_AlignLeft]),
		 ctl(wdef(wc_PushButton,rct(217,116,257,128),editdlg_pb1, u_DlgBase),idc_ok,          [wsf_ClipSiblings,wsf_Default,wsf_Group,wsf_TabStop]),
		 ctl(wdef(wc_PushButton,rct(217,131,257,143),editdlg_pb2, u_DlgBase),idc_cancel,      [wsf_ClipSiblings,wsf_Group,wsf_TabStop]),
		 ctl(wdef(wc_Text,      rct(12,40,38,50),    editdlg_txt1,u_DlgBase),idct_1,          [wsf_AlignRight,wsf_ClipSiblings]),
		 ctl(wdef(wc_Text,      rct(112,40,153,50),  editdlg_txt2,u_DlgBase),idct_2,          [wsf_AlignRight,wsf_ClipSiblings]),
		 ctl(wdef(wc_Text,      rct(12,80,35,93),    editdlg_txt3,u_DlgBase),idct_3,          [wsf_AlignLeft,wsf_ClipSiblings]),
		 ctl(wdef(wc_Text,      rct(12,102,34,115),  editdlg_txt4,u_DlgBase),idct_4,          [wsf_AlignLeft,wsf_ClipSiblings]),
		 ctl(wdef(wc_Text,      rct(11,122,61,132),  editdlg_txt5,u_DlgBase),idct_5,          [wsf_AlignRight,wsf_ClipSiblings]),
		 ctl(wdef(wc_Text,      rct(114,122,161,132),editdlg_txt6,u_DlgBase),idct_6,          [wsf_AlignRight,wsf_ClipSiblings]),
		 ctl(wdef(wc_Text,      rct(9,17,39,28),     editdlg_txt7,u_DlgBase),idct_7,          [wsf_AlignRight,wsf_ClipSiblings]),
		 ctl(wdef(wc_Text,      rct(113,17,129,27),  editdlg_txt8,u_DlgBase),idct_8,          [wsf_AlignRight,wsf_ClipSiblings]),
		 ctl(wdef(wc_GroupBox,  rct(5,5,205,60),     editdlg_grb1,u_DlgBase),idc_gb1,         [wsf_NoClipSiblings]),
		 ctl(wdef(wc_GroupBox,  rct(5,67,205,143),   editdlg_grb2,u_DlgBase),idc_gb2,         [wsf_NoClipSiblings])
		],dlg_properties_eh,Id),!.		
enddef
  dlg_properties_eh(DlgWin,e_Create(Id),0):-!,
	Win = win_GetParent(DlgWin),
	get_initial_settings(Win,Id,BorderIdx,FillIdx,LineStyleIdx,CircleSizeStr,
				LabelText,LabelIdx,LabelFontIdx,LabelFontSizeIdx,
				LabelFontStyleIdx,LabelXStr,LabelYStr,EnableBrush,EnableCircle),
	% Set listbutton lists and initial selections
	LboxWin1 = win_GetCtlHandle(DlgWin,idc_border_color),
	LboxWin2 = win_GetCtlHandle(DlgWin,idc_fill_color),
	LboxWin3 = win_GetCtlHandle(DlgWin,idc_color),
	LboxWin4 = win_GetCtlHandle(DlgWin,idc_fontstyle),
	LboxWin5 = win_GetCtlHandle(DlgWin,idc_linestyle),
	LboxWin6 = win_GetCtlHandle(DlgWin,idc_font),
	LboxWin7 = win_GetCtlHandle(DlgWin,idc_fontsize),
	lbox_Add(LboxWin1,editdlg_colorlist),
	lbox_Add(LboxWin2,editdlg_colorlist),
	lbox_Add(LboxWin3,editdlg_colorlist),
	lbox_Add(LboxWin4,editdlg_fslist),
	lbox_Add(LboxWin5,editdlg_lslist),
	lbox_Add(LboxWin6,editdlg_fontlist),
	lbox_Add(LboxWin7,editdlg_fontsizelist),
	lbox_SetSel(LboxWin1,BorderIdx,b_true),
	lbox_SetSel(LboxWin2,FillIdx,b_true),
	lbox_SetSel(LboxWin3,LabelIdx,b_true),
	lbox_SetSel(LboxWin4,LabelFontStyleIdx,b_true),
	lbox_SetSel(LboxWin5,LineStyleIdx,b_true),
	lbox_SetSel(LboxWin6,LabelFontIdx,b_true),
	lbox_SetSel(LboxWin7,LabelFontSizeIdx,b_true),
	% Set edit control's texts
	EditWin1 = win_GetCtlHandle(DlgWin,idc_circle_size),
	EditWin2 = win_GetCtlHandle(DlgWin,idc_label),
	EditWin3 = win_GetCtlHandle(DlgWin,idc_hor_pos),
	EditWin4 = win_GetCtlHandle(DlgWin,idc_vert_pos),
	win_SetText(EditWin1,CircleSizeStr),
	win_SetText(EditWin2,LabelText),
	win_SetText(EditWin3,LabelXStr),
	win_SetText(EditWin4,LabelYStr),
	% Enable controls depending on object type
	TxtWin1 = win_GetCtlHandle(DlgWin,idct_2),
	TxtWin2 = win_GetCtlHandle(DlgWin,idct_8),
	win_SetState(EditWin1,EnableCircle),
	win_SetState(TxtWin1,EnableCircle),
	win_SetState(LBoxWin2,EnableBrush),
	win_SetState(TxtWin2,EnableBrush).

  dlg_properties_eh(DlgWin,e_Control(idc_ok,_CtrlType,_CtrlWin,_CtrlInfo),0):-
	Win = win_GetParent(DlgWin),
	Id = win_GetData(DlgWin),
	% Get listbutton selections
	LboxWin1 = win_GetCtlHandle(DlgWin,idc_border_color),
	LboxWin2 = win_GetCtlHandle(DlgWin,idc_fill_color),
	LboxWin3 = win_GetCtlHandle(DlgWin,idc_color),
	LboxWin4 = win_GetCtlHandle(DlgWin,idc_fontstyle),
	LboxWin5 = win_GetCtlHandle(DlgWin,idc_linestyle),
	LboxWin6 = win_GetCtlHandle(DlgWin,idc_font),
	LboxWin7 = win_GetCtlHandle(DlgWin,idc_fontsize),
	BorderIdx         = lbox_GetSelIndex(LboxWin1),
	FillIdx           = lbox_GetSelIndex(LboxWin2),
	LabelIdx          = lbox_GetSelIndex(LboxWin3),
	LabelFontStyleIdx = lbox_GetSelIndex(LboxWin4),
	LineStyleIdx      = lbox_GetSelIndex(LboxWin5),
	LabelFontIdx      = lbox_GetSelIndex(LboxWin6),
	LabelFontSizeIdx  = lbox_GetSelIndex(LboxWin7),
	% Get edit control's texts
	EditWin1 = win_GetCtlHandle(DlgWin,idc_circle_size),
	EditWin2 = win_GetCtlHandle(DlgWin,idc_label),
	EditWin3 = win_GetCtlHandle(DlgWin,idc_hor_pos),
	EditWin4 = win_GetCtlHandle(DlgWin,idc_vert_pos),
	CircleSizeStr = win_GetText(EditWin1),
	LabelText =     win_GetText(EditWin2),
	LabelXStr =     win_GetText(EditWin3),
	LabelYStr =     win_GetText(EditWin4),
	set_object_properties(Win,DlgWin,Id,BorderIdx,FillIdx,LineStyleIdx,CircleSizeStr,
				LabelText,LabelIdx,LabelFontIdx,LabelFontSizeIdx,
				LabelFontStyleIdx,LabelXStr,LabelYStr),!,
	mapctrl_SetMarker(Win,[Id]),
	win_Destroy(DlgWin).
  dlg_properties_eh(_DlgWin,e_Control(idc_ok,_CtrlType,_CtrlWin,_CtrlInfo),0):-!.

  dlg_properties_eh(DlgWin,e_Control(idc_cancel,_CtrlType,_CtrlWin,_CtrlInfo),0):-!,
	win_Destroy(DlgWin).

  get_initial_settings(Win,Id,BorderIdx,FillIdx,LineStyleIdx,"0",
				LabelText,LabelIdx,LabelFontIdx,LabelFontSizeIdx,LabelFontStyleIdx,
				LabelXStr,LabelYStr,[wsf_Enabled],[wsf_Disabled]):-
	mapctrl_object(Win,polygon(Id,_,_,pen(_,LineStyle,BorderColor),brush(_,FillColor),Label)),!,
	get_label_settings(Label,LabelText,LabelColor,LabelFont,LabelFontSize,LabelFontStyle,LabelX,LabelY),
	linestyle_index(LineStyle,LineStyleIdx),
	fontstyle_index(LabelFontStyle,LabelFontStyleIdx),
	font_index(LabelFont,LabelFontIdx),
	fontsize_index(LabelFontSize,LabelFontSizeIdx),
	color_index(BorderColor,BorderIdx),
	color_index(FillColor,FillIdx),
	color_index(LabelColor,LabelIdx),
	str_int(LabelXStr,LabelX),
	str_int(LabelYStr,LabelY).
  get_initial_settings(Win,Id,BorderIdx,FillIdx,LineStyleIdx,CircleSizeStr,
				LabelText,LabelIdx,LabelFontIdx,LabelFontSizeIdx,LabelFontStyleIdx,
				LabelXStr,LabelYStr,[wsf_Enabled],[wsf_Enabled]):-
	mapctrl_object(Win,circle(Id,_,CircleSize,pen(_,LineStyle,BorderColor),brush(_,FillColor),Label)),!,
	get_label_settings(Label,LabelText,LabelColor,LabelFont,LabelFontSize,LabelFontStyle,LabelX,LabelY),
	linestyle_index(LineStyle,LineStyleIdx),
	fontstyle_index(LabelFontStyle,LabelFontStyleIdx),
	font_index(LabelFont,LabelFontIdx),
	fontsize_index(LabelFontSize,LabelFontSizeIdx),
	color_index(BorderColor,BorderIdx),
	color_index(FillColor,FillIdx),
	color_index(LabelColor,LabelIdx),
	str_int(CircleSizeStr,CircleSize),
	str_int(LabelXStr,LabelX),
	str_int(LabelYStr,LabelY).
  get_initial_settings(Win,Id,0,0,0,"0",
				LabelText,LabelIdx,LabelFontIdx,LabelFontSizeIdx,LabelFontStyleIdx,
				LabelXStr,LabelYStr,[wsf_Disabled],[wsf_Disabled]):-
	mapctrl_object(Win,bitmap(Id,_,_,_,Label)),!,
	get_label_settings(Label,LabelText,LabelColor,LabelFont,LabelFontSize,LabelFontStyle,LabelX,LabelY),
	fontstyle_index(LabelFontStyle,LabelFontStyleIdx),
	font_index(LabelFont,LabelFontIdx),
	fontsize_index(LabelFontSize,LabelFontSizeIdx),
	color_index(LabelColor,LabelIdx),
	str_int(LabelXStr,LabelX),
	str_int(LabelYStr,LabelY).
  get_initial_settings(Win,Id,BorderIdx,0,LineStyleIdx,"0",
				LabelText,LabelIdx,LabelFontIdx,LabelFontSizeIdx,LabelFontStyleIdx,
				LabelXStr,LabelYStr,[wsf_Disabled],[wsf_Disabled]):-
	mapctrl_object(Win,arrow(Id,_,_,pen(_,LineStyle,BorderColor),Label)),!,
	get_label_settings(Label,LabelText,LabelColor,LabelFont,LabelFontSize,LabelFontStyle,LabelX,LabelY),
	linestyle_index(LineStyle,LineStyleIdx),
	fontstyle_index(LabelFontStyle,LabelFontStyleIdx),
	font_index(LabelFont,LabelFontIdx),
	fontsize_index(LabelFontSize,LabelFontSizeIdx),
	color_index(BorderColor,BorderIdx),
	color_index(LabelColor,LabelIdx),
	str_int(LabelXStr,LabelX),
	str_int(LabelYStr,LabelY).


  get_label_settings(Label,LabelText,LabelColor,LabelFont,FontSize,FontStyle,X,Y):-
	Label = label(pnt(X,Y),LabelText,LabelFont,FontStyle,FontSize,LabelColor),!.
  get_label_settings(nolabel,"",color_Black,ff_Helvetica,100,[fs_Bold],20,-20):-!.
  get_label_settings(_,"",color_Black,ff_Helvetica,100,[fs_Bold],20,-20):-errorexit().

  set_object_properties(Win,DlgWin,Id,BorderIdx,FillIdx,LineStyleIdx,_,
				LabelText,LabelIdx,LabelFontIdx,LabelFontSizeIdx,LabelFontStyleIdx,
				LabelXStr,LabelYStr):-
	mapctrl_object(Win,polygon(Id,Pnt,PntList,_,_,_)),
	linestyle_index(LineStyle,LineStyleIdx),
	fontstyle_index(LabelFontStyle,LabelFontStyleIdx),
	font_index(LabelFont,LabelFontIdx),
	fontsize_index(LabelFontSize,LabelFontSizeIdx),
	color_index(BorderColor,BorderIdx),
	color_index(FillColor,FillIdx),
	color_index(LabelColor,LabelIdx),
	check_str_int(DlgWin,idc_hor_pos,LabelXStr,LabelX),
	check_str_int(DlgWin,idc_vert_pos,LabelYStr,LabelY),!,
	mapctrl_RemoveObjects(Win,[Id]),
	mapctrl_AddObjects(Win,[polygon(Id,Pnt,PntList,pen(1,LineStyle,BorderColor),brush(pat_Solid,FillColor),
					label(pnt(LabelX,LabelY),LabelText,LabelFont,LabelFontStyle,LabelFontSize,LabelColor))]).
  set_object_properties(Win,DlgWin,Id,BorderIdx,FillIdx,LineStyleIdx,CircleSizeStr,
				LabelText,LabelIdx,LabelFontIdx,LabelFontSizeIdx,LabelFontStyleIdx,
				LabelXStr,LabelYStr):-
	mapctrl_object(Win,circle(Id,Pnt,_,_,_,_)),
	linestyle_index(LineStyle,LineStyleIdx),
	fontstyle_index(LabelFontStyle,LabelFontStyleIdx),
	font_index(LabelFont,LabelFontIdx),
	fontsize_index(LabelFontSize,LabelFontSizeIdx),
	color_index(BorderColor,BorderIdx),
	color_index(FillColor,FillIdx),
	color_index(LabelColor,LabelIdx),
	check_str_int(DlgWin,idc_circle_size,CircleSizeStr,CircleSize),
	check_str_int(DlgWin,idc_hor_pos,LabelXStr,LabelX),
	check_str_int(DlgWin,idc_vert_pos,LabelYStr,LabelY),!,
	mapctrl_RemoveObjects(Win,[Id]),
	mapctrl_AddObjects(Win,[circle(Id,Pnt,CircleSize,pen(1,LineStyle,BorderColor),brush(pat_Solid,FillColor),
					label(pnt(LabelX,LabelY),LabelText,LabelFont,LabelFontStyle,LabelFontSize,LabelColor))]).
  set_object_properties(Win,DlgWin,Id,_,_,_,_,LabelText,LabelIdx,LabelFontIdx,LabelFontSizeIdx,
				LabelFontStyleIdx,LabelXStr,LabelYStr):-
	mapctrl_object(Win,bitmap(Id,Pnt,Filename,Rop,_)),
	fontstyle_index(LabelFontStyle,LabelFontStyleIdx),
	font_index(LabelFont,LabelFontIdx),
	fontsize_index(LabelFontSize,LabelFontSizeIdx),
	color_index(LabelColor,LabelIdx),
	check_str_int(DlgWin,idc_hor_pos,LabelXStr,LabelX),
	check_str_int(DlgWin,idc_vert_pos,LabelYStr,LabelY),!,
	mapctrl_RemoveObjects(Win,[Id]),
	mapctrl_AddObjects(Win,[bitmap(Id,Pnt,Filename,Rop,
					label(pnt(LabelX,LabelY),LabelText,LabelFont,LabelFontStyle,LabelFontSize,LabelColor))]).
  set_object_properties(Win,DlgWin,Id,BorderIdx,_,LineStyleIdx,_,
				LabelText,LabelIdx,LabelFontIdx,LabelFontSizeIdx,LabelFontStyleIdx,
				LabelXStr,LabelYStr):-
	mapctrl_object(Win,arrow(Id,Pnt1,Pnt2,_,_)),
	linestyle_index(LineStyle,LineStyleIdx),
	fontstyle_index(LabelFontStyle,LabelFontStyleIdx),
	font_index(LabelFont,LabelFontIdx),
	fontsize_index(LabelFontSize,LabelFontSizeIdx),
	color_index(BorderColor,BorderIdx),
	color_index(LabelColor,LabelIdx),
	check_str_int(DlgWin,idc_hor_pos,LabelXStr,LabelX),
	check_str_int(DlgWin,idc_vert_pos,LabelYStr,LabelY),!,
	mapctrl_RemoveObjects(Win,[Id]),
	mapctrl_AddObjects(Win,[arrow(Id,Pnt1,Pnt2,pen(1,LineStyle,BorderColor),
					label(pnt(LabelX,LabelY),LabelText,LabelFont,LabelFontStyle,LabelFontSize,LabelColor))]).
  set_object_properties(_,_,_,_,_,_,_,_,_,_,_,_,_,_).

  check_str_int(_,_,Str,Int):-
	trap(str_int(Str,Int),_,fail),
	Int < max_int,
	Int > 0 - max_int,
	!.
  check_str_int(Win,Id,Str,0):-
	CtrlWin = win_GetCtlHandle(Win,Id),
	win_SetFocus(CtrlWin),
	str_len(Str,Len),
	win_SelectText(CtrlWin,0,Len),
	format(Message,int_validation_message,Str),
	dlg_Note(Message),
	fail.

  color_index(0xFFFFFF,0):-!.
  color_index(0x000000,1):-!.
  color_index(0x808080,2):-!.
  color_index(0xC0C0C0,3):-!.
  color_index(0x0000FF,4):-!.
  color_index(0x000080,5):-!.
  color_index(0x00FF00,6):-!.
  color_index(0x008000,7):-!.
  color_index(0xFF0000,8):-!.
  color_index(0x800000,9):-!.
  color_index(0xFFFF00,10):-!.
  color_index(0x808000,11):-!.
  color_index(0xFF00FF,12):-!.
  color_index(0x800080,13):-!.
  color_index(0x00FFFF,14):-!.
  color_index(0x008080,15):-!.

  fontstyle_index([],0):-!.
  fontstyle_index([fs_Bold],1):-!.
  fontstyle_index([fs_Italic],2):-!.
  fontstyle_index([fs_Underline],3):-!.
  fontstyle_index([fs_Bold,fs_Italic],4):-!.
  fontstyle_index([fs_Bold,fs_Underline],5):-!.
  fontstyle_index([fs_Italic,fs_Underline],6):-!.

  linestyle_index(ps_Solid,0):-!.
  linestyle_index(ps_Dash,1):-!.
  linestyle_index(ps_Dot,2):-!.
  linestyle_index(ps_DashDot,3):-!.
  linestyle_index(ps_DashDotDot,4):-!.
  linestyle_index(ps_Hollow,5):-!.

  font_index(ff_System,0):-!.
  font_index(ff_Fixed,1):-!.
  font_index(ff_Times,2):-!.
  font_index(ff_Helvetica,3):-!.

predicates
  procedure calc_nearest(INTEGER,INTEGER)

clauses
  fontsize_index(6,0):-!.
  fontsize_index(10,1):-!.
  fontsize_index(16,2):-!.
  fontsize_index(25,3):-!.
  fontsize_index(40,4):-!.
  fontsize_index(64,5):-!.
  fontsize_index(100,6):-!.
  fontsize_index(160,7):-!.
  fontsize_index(250,8):-!.
  fontsize_index(400,9):-!.
  fontsize_index(640,10):-!.
  fontsize_index(1000,11):-!.
  fontsize_index(NonStandard,Index):-
	bound(NonStandard),
	calc_nearest(NonStandard,Standard),
	fontsize_index(Standard,Index).

  calc_nearest(X,X):-
	mmmember(X,[6,10,16,25,40,64,100,160,250,400,640,1000]),!.
  calc_nearest(X,Standard):-
	X1 = X + 1,
	calc_nearest(X1,Standard).


/**** global predicates **********************************/
/*						 	 */
/*   Get foreground object's label text by known Id 	 */
/*                                                       */
/*   Get foreground object's coordinates by known Id 	 */
/*                                                       */
/*   Get foreground object's Id by known label text 	 */
/*                                                       */
/*********************************************************/
%  STRING mapctrl_GetObjectText(WINDOW,ULONG)	- (i,i)
%  PNT mapctrl_GetObjectCoor(WINDOW,ULONG)	- (i,i)
%  ULONG mapctrl_GetObjectId(WINDOW,STRING)	- (i,i)

predicates
  determ get_from_label(MAPCTRL_LABEL,STRING)

clauses
  mapctrl_GetObjectText(Win,Id,Str):-
	mapctrl_object(Win,polygon(Id,_,_,_,_,Label)),!,
	get_from_label(Label,Str).
  mapctrl_GetObjectText(Win,Id,Str):-
	mapctrl_object(Win,circle(Id,_,_,_,_,Label)),!,
	get_from_label(Label,Str).
  mapctrl_GetObjectText(Win,Id,Str):-
	mapctrl_object(Win,arrow(Id,_,_,_,Label)),!,
	get_from_label(Label,Str).
  mapctrl_GetObjectText(Win,Id,Str):-
	mapctrl_object(Win,bitmap(Id,_,_,_,Label)),!,
	get_from_label(Label,Str).
  mapctrl_GetObjectText(Win,Id,Str):-
	mapctrl_object(Win,picture(Id,_,_,_,Label)),!,
	get_from_label(Label,Str).
	
  get_from_label(Label,""):-
	Label = nolabel,!.
  get_from_label(Label,Str):-
	Label = label(_,Str,_,_,_,_),!.

  mapctrl_GetObjectId(Win,Str,Id):-
	mapctrl_object(Win,polygon(Id,_,_,_,_,Label)),
	get_from_label(Label,Str),!.
  mapctrl_GetObjectId(Win,Str,Id):-
	mapctrl_object(Win,circle(Id,_,_,_,_,Label)),
	get_from_label(Label,Str),!.
  mapctrl_GetObjectId(Win,Str,Id):-
	mapctrl_object(Win,arrow(Id,_,_,_,Label)),
	get_from_label(Label,Str),!.
  mapctrl_GetObjectId(Win,Str,Id):-
	mapctrl_object(Win,bitmap(Id,_,_,_,Label)),
	get_from_label(Label,Str),!.
  mapctrl_GetObjectId(Win,Str,Id):-
	mapctrl_object(Win,picture(Id,_,_,_,Label)),
	get_from_label(Label,Str),!.

  mapctrl_GetObjectCoor(Win,Id,Pnt):-
	mapctrl_object(Win,polygon(Id,Pnt,_,_,_,_)),!.
  mapctrl_GetObjectCoor(Win,Id,Pnt):-
	mapctrl_object(Win,circle(Id,Pnt,_,_,_,_)),!.
  mapctrl_GetObjectCoor(Win,Id,Pnt):-
	mapctrl_object(Win,arrow(Id,Pnt,_,_,_)),!.
  mapctrl_GetObjectCoor(Win,Id,Pnt):-
	mapctrl_object(Win,bitmap(Id,Pnt,_,_,_)),!.
  mapctrl_GetObjectCoor(Win,Id,Pnt):-
	mapctrl_object(Win,picture(Id,Pnt,_,_,_)),!.
	

/**** global predicates **********************************/
/*						 	 */
/* 	  Add object(s) to Map custom control 		 */
/*                                                       */
/*     Remove object(s) from Map custom control 	 */
/*                                                       */
/*       mapctrl_AddObjects(WINDOW,MAPCTRL_OBJLIST)      */
/*       mapctrl_RemoveObjects(WINDOW,ULONGLIST)         */
/*********************************************************/
predicates
  procedure add_objects(WINDOW,MAPCTRL_OBJLIST)
  procedure remove_object(WINDOW,ULONG ObjectId)
  procedure refresh_object_rect(WINDOW,RCT)
  procedure refresh_label_rect(WINDOW,PNT,MAPCTRL_LABEL)
  procedure remove_from_markerlist(WINDOW,ULONG ObjectId)
  procedure remove_from_markerlist1(ULONG ObjectId,ULONGLIST,ULONGLIST)

clauses
  mapctrl_AddObjects(Win,ObjectList):-
	process_input_data(Win,data([],ObjectList)),
	add_objects(Win,ObjectList).

  add_objects(_,[]):-!.
  add_objects(Win,[Obj|Rest]):-
	draw_fgobject(Win,Obj), !,
	add_objects(Win,Rest).
  add_objects(_,_):-errorexit().

  mapctrl_RemoveObjects(_,[]):-!.
  mapctrl_RemoveObjects(Win,[Id|Rest]):-
	remove_object(Win,Id), !,
	mapctrl_RemoveObjects(Win,Rest).
  mapctrl_RemoveObjects(_,_):-errorexit().

  remove_object(Win,Id):-
	retract(mapctrl_object(Win,polygon(Id,Pnt,_,_,_,Label))),
	retract(mapctrl_sensitive_rct_area(Win,Id,Rct)),!,
	remove_from_markerlist(Win,Id),
	refresh_object_rect(Win,Rct),
	refresh_label_rect(Win,Pnt,Label).
  remove_object(Win,Id):-
	retract(mapctrl_object(Win,circle(Id,Pnt,_,_,_,Label))),
	retract(mapctrl_sensitive_rct_area(Win,Id,Rct)),!,
	remove_from_markerlist(Win,Id),
	refresh_object_rect(Win,Rct),
	refresh_label_rect(Win,Pnt,Label).
  remove_object(Win,Id):-
	retract(mapctrl_object(Win,bitmap(Id,Pnt,_,_,Label))),
	retract(mapctrl_sensitive_rct_area(Win,Id,Rct)),!,
	remove_from_markerlist(Win,Id),
	refresh_object_rect(Win,Rct),
	refresh_label_rect(Win,Pnt,Label).
  remove_object(Win,Id):-
	retract(mapctrl_object(Win,picture(Id,Pnt,_,_,Label))),
	retract(mapctrl_sensitive_rct_area(Win,Id,Rct)),!,
	remove_from_markerlist(Win,Id),
	refresh_object_rect(Win,Rct),
	refresh_label_rect(Win,Pnt,Label).
  remove_object(Win,Id):-
	retract(mapctrl_object(Win,arrow(Id,_,_,_,Label))),
	retract(mapctrl_sensitive_line_area(Win,Id,From,To)),!,
	remove_from_markerlist(Win,Id),
	From = pnt(X1,Y1), To = pnt(X2,Y2),
	mmminI(X1,X2,Xi), mmminI(Y1,Y2,Yi),
	mmmaxI(X1,X2,Xa), mmmaxI(Y1,Y2,Ya),
	XaF=val(real,Xa),
	XiF=val(real,Xi),
	YaF=val(real,Ya),
	YiF=val(real,Yi),
	Area = val(integer,sqrt((XaF-XiF)*(XaF-XiF)+(YaF-YiF)*(YaF-YiF))/8),
	L = Xi - Area,
	T = Yi - Area,
	R = Xa + Area,
	B = Ya + Area,
	refresh_object_rect(Win,rct(L,T,R,B)),
	refresh_label_rect(Win,From,Label).
  remove_object(_Win,_Id).

  refresh_object_rect(Win,rct(L,T,R,B)):-
	PntList1 = win_LPtoDP(Win,[pnt(L,T),pnt(R,B)]),
	PntList1 = [pnt(Lw,Tw),pnt(Rw,Bw)],
	Lw1 = Lw - 2, Tw1 = Tw -2, Rw1 = Rw + 2, Bw1 = Bw + 2,
	win_Invalidate(Win,rct(Lw1,Tw1,Rw1,Bw1)), !.
  refresh_object_rect(_,_):-errorexit().

  refresh_label_rect(_,_,nolabel):-!.
  refresh_label_rect(Win,pnt(X0,Y0),Label):-
	Label = label(pnt(Dx,Dy),Str,FontFamily,StyleFlags,Size,_),
	Font = font_Create(FontFamily,StyleFlags,Size),
	win_SetFont(Win,Font),
	win_GetTextExtent(Win,Str,-1,Width,_Height),
	win_GetFontMetrics(Win,_,Ascent,Descent),
	L = X0 + Dx - 1,
	T = Y0 + Dy - Ascent - 1,
	R = X0 + Dx + Width + 1,
	B = Y0 + Dy + Descent + 1,
	RCT = rct(L,T,R,B),
	refresh_object_rect(Win,RCT), !.
  refresh_label_rect(_,_,_):-errorexit().


  remove_from_markerlist(Win,Id):-
	get_marker(Win,MarkerList),
	mmmember(Id,MarkerList),
	remove_from_markerlist1(Id,MarkerList,NewMarkerList),
	retract(mapctrl_marker(Win,_)),!,
	assert(mapctrl_marker(Win,NewMarkerList)).
  remove_from_markerlist(_,_).

  remove_from_markerlist1(_,[],[]):-!.
  remove_from_markerlist1(Id,[Id|Rest],OutList):-!,
	remove_from_markerlist1(Id,Rest,OutList).
  remove_from_markerlist1(Id,[Idx|Rest],[Idx|OutList]):- !,
	remove_from_markerlist1(Id,Rest,OutList).
  remove_from_markerlist1(_,_,[]):-errorexit().

/**** global predicates **********************************/
/*						 	 */
/*   	  Get current mapping and scaling status	 */
/*                                                       */
/*   	    Set new mapping and scaling status  	 */
/*                                                       */
/*********************************************************/
%  MAPCTRL_MAPSCALE mapctrl_GetMapScale(WINDOW)	- (i)
%  mapctrl_SetMapScale(WINDOW,MAPCTRL_MAPSCALE)	- (i,i)

  mapctrl_GetMapScale(Win,MapScale):-
	mapctrl_info(Win,_,_,MapScale,_),!.
  mapctrl_GetMapScale(_,mapscale(pnt(0,0),1.0)).

  mapctrl_SetMapScale(Win,MapScale):-
	retract(mapctrl_info(Win,Color,Mode,_,Callback)),!,
	assert(mapctrl_info(Win,Color,Mode,MapScale,Callback)).
  mapctrl_SetMapScale(_,_).

/**** global PREDICATE ***********************************/
/*						 	 */
/*   	  Generate new unical foreground object Id	 */
/*                                                       */
/*********************************************************/
  mapctrl_GetNewId(Win,Id):-
	new_Id(Win,1,Id).

/**** global predicates **********************************/
/*						 	 */
/*   	  Convert Window coordinates into Map coor-	 */
/*                  dinates and back                     */
/*                                                       */
/*********************************************************/
  mapctrl_WinToMap(Win,WinPNT,MapPNT):-
	PntList = win_DPtoLP(Win,[WinPNT]),
	PntList = [MapPNT], !.
  mapctrl_WinToMap(_,_,pnt(0,0)):-errorexit().

  mapctrl_MapToWin(Win,MapPNT,WinPNT):-
	PntList = win_LPtoDP(Win,[MapPNT]),
	PntList = [WinPNT], !.
  mapctrl_MapToWin(_,_,pnt(0,0)):-errorexit().

/**** global predicates **********************************/
/*						 	 */
/*   	  	   Get current mode			 */
/*   	    	    Set new mode 		 	 */
/*                                                       */
/*********************************************************/
%  MAPCTRL_MODE mapctrl_GetMode(WINDOW)	- (i)
%  mapctrl_SetMode(WINDOW,MAPCTRL_MODE)	- (i,i)

  mapctrl_GetMode(Win,Mode):-
	mapctrl_info(Win,_,Mode,_,_),!.
  mapctrl_GetMode(_,view([])).
	
  mapctrl_SetMode(Win,Mode):-
	retract(mapctrl_info(Win,Color,_,Scale,Callback)),!,
	assert(mapctrl_info(Win,Color,Mode,Scale,Callback)).
  mapctrl_SetMode(_,_).

/**** global predicates **********************************/
/*						 	 */
/* 	Get list of objects currently marked in		 */
/*		Map custom control 			 */
/*                                                       */
/*       Set marker in Map custom control                */
/*                                                       */
/*       ULONGLIST mapctrl_GetMarker(WINDOW)             */
/*       mapctrl_SetMarker(WINDOW,ULONGLIST)             */
/*********************************************************/
clauses
  mapctrl_GetMarker(Win,MarkerList):-
	get_marker(Win,MarkerList).

  mapctrl_SetMarker(Win,NewMarkerList):-
	get_marker(Win,OldMarkerList),
	retractall(mapctrl_marker(Win,_)),
	draw_markers(Win,OldMarkerList),	% remove old markers
	assert(mapctrl_marker(Win,NewMarkerList)),
	draw_markers(Win,NewMarkerList).	% draw new markers

