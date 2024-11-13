/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 FileName:	PROP.PRO
 Purpose:	Property Editor example application
 Written by:	Visual Prolog
 Comments:	
******************************************************************************/

include "prop.inc"
include "prop.con"
include "hlptopic.con"

constants
  propedit_class 	= "propedit_class"	% User defined name for the class
  propedit_id 		= 3248			% Control Id for propedit control created in window

% database for Property Editor example application
database - example_db
  example_db_tbl(WINDOW,Property_Sheet Table1_2,Property_Sheet Table3) 
  example_db_Prev(WINDOW,COLOR PenColor,COLOR FillColor,PATSTYLE,PENSTYLE,PENWIDTH,RCT)
  example_db_PrevFont(WINDOW,FONT)
  example_db_EditorInTopLevel(WINDOW)
  example_db_CustomControlEditor(WINDOW)

/*******************************************************************
	Property Editor class event Handler
*******************************************************************/
predicates
  propedit_class_handler : EHANDLER	% Property editor custom control EVENT HANDLER

clauses
  propedit_class_handler(Win,e_Create(_),0):-!,	% CALL propedit_CreateCustom on e_Create EVENT
	example_db_tbl(_TaskWin,Tbl1_2,_Tbl3),!,% Get tables 1,2 from database
	Font = font_Create(ff_helvetica,[],8),
	propedit_CreateCustom(Win,Font,Tbl1_2,prop_Callback,160),
	assert(example_db_CustomControlEditor(Win)). % Assert Window for custom control Property Editor 

  propedit_class_handler(Win,EVENT,0):-	% CALL propedit_HandleEvent
	propedit_HandleEvent(Win,Event),!.	% ON ANY OTHER EVENT

predicates
determ  colorNameToNumber(STRING,LONG)
determ  penNameToPENWIDTH_PENSTYLE(STRING,PENWIDTH,PENSTYLE)
determ  brushNameToPATSTYLE(STRING,PATSTYLE)

clauses
  colorNameToNumber("White",0xFFFFFF):-!.
  colorNameToNumber("Black",0x000000):-!.
  colorNameToNumber("Gray",0x808080):-!.
  colorNameToNumber("LtGray",0xC0C0C0):-!.
  colorNameToNumber("Red",0x0000FF):-!.
  colorNameToNumber("DkRed",0x000080):-!.
  colorNameToNumber("Green",0x00FF00):-!.
  colorNameToNumber("DkGreen",0x008000):-!.
  colorNameToNumber("Blue",0xFF0000):-!.
  colorNameToNumber("DkBlue",0x800000):-!.
  colorNameToNumber("Cyan",0xFFFF00):-!.
  colorNameToNumber(_,0):-!.
  
  penNameToPENWIDTH_PENSTYLE("Solid 1",1,ps_Solid):-!.
  penNameToPENWIDTH_PENSTYLE("Solid 3",3,ps_Solid):-!.
  penNameToPENWIDTH_PENSTYLE("Dash 1",1,ps_Dash):-!.
  penNameToPENWIDTH_PENSTYLE("Dot 1",1,ps_Dot):-!.
  penNameToPENWIDTH_PENSTYLE("DashDot 1",1,ps_DashDot):-!.
  penNameToPENWIDTH_PENSTYLE("DashDotDot 1",1,ps_DashDotDot):-!.
  penNameToPENWIDTH_PENSTYLE("Hollow 1",1,ps_Hollow):-!.

  brushNameToPATSTYLE("Hollow",pat_Hollow):-!.
  brushNameToPATSTYLE("Solid",pat_Solid):-!.
  brushNameToPATSTYLE("Horz",pat_Horz):-!.
  brushNameToPATSTYLE("Vert",pat_Vert):-!.
  brushNameToPATSTYLE("FDiag",pat_FDiag):-!.
  brushNameToPATSTYLE("BDiag",pat_BDiag):-!.
  brushNameToPATSTYLE("Cross",pat_Cross):-!.
  brushNameToPATSTYLE("DiagCross",pat_DiagCross):-!.

predicates
determ  draw_preview(WINDOW)
  draw_preview_frame(WINDOW,RCT)

clauses
  draw_preview(Win):- % draw example preview window
	example_db_Prev(Win,PenColor,FillColor,PATSTL,PENSTL,PENW,RCT),
	RCT = rct(Px,Py,Dx,Dy),
	WPx = Px + 10, WPy = Py + 30, WDx = Dx + 13, WDy = Dy + 53,
	win_Move(Win,rct(WPx,WPy,WDx,WDy)),
	win_Clear(Win,color_LtGray),
	P1x = Px + Dx, P1y = Py + Dy, 
	RctRam = rct(Px,Py,P1x,P1y),
	XPrev = Px + 5 + PENW div 2, YPrev = Py + 5 + PENW div 2,
	X1Prev = P1x - PENW div 2 - PENW mod 2 - 4, Y1Prev = P1y - PENW div 2 - PENW mod 2 - 4, 
	Xc = Px + 5, Yc = Py + 5, Xc1 = P1x - 5, Yc1 = P1y - 5,
	win_Clear(Win,RctRam,color_Gray),
	win_Clear(Win,rct(Xc,Yc,Xc1,Yc1),color_White),
	win_SetPen(Win,pen(PENW,PENSTL,PenColor)),
	win_SetBrush(Win,brush(PATSTL,FillColor)),
	draw_Rect(Win,rct(XPrev,YPrev,X1Prev,Y1Prev)),
	draw_preview_frame(Win,RctRam),
	PT1y = P1y + 20,
	win_SetForeColor(Win,color_Black),
	draw_TextInRect(Win,rct(Px,P1y,P1x,PT1y),"Test",-1,[dtext_Center,dtext_Vcenter,dtext_SingleLine]),
	!.

  draw_preview_frame(Win,Rct):-
	Rct = rct(X,Y,X1,Y1),
	Xx = X + 1, Xx1 = X1 -1, Yy = Y + 1, Yy1 = Y1 - 1,
	win_SetPen(Win,pen(1,ps_Solid,color_Gray)),
	draw_Line(Win,pnt(X,Yy),pnt(X,Y1)),
	draw_Line(Win,pnt(X,Y1),pnt(X1,Y1)),
	draw_Line(Win,pnt(X1,Y1),pnt(X1,Y)),
	win_SetPen(Win,pen(2,ps_Solid,color_Black)),
	draw_Line(Win,pnt(Xx,Yy1),pnt(Xx,Yy)),
	draw_Line(Win,pnt(Xx,Yy),pnt(Xx1,Yy)),
	win_SetPen(Win,pen(2,ps_Solid,color_White)),
	draw_Line(Win,pnt(Xx,Yy1),pnt(Xx1,Yy1)),
	draw_Line(Win,pnt(Xx1,Yy1),pnt(Xx1,Yy)),!.

predicates	
determ  get_StateFromDialog(WINDOW,WSFLAGS)
determ  set_StateToEditors(WSFLAGS)

clauses
  get_StateFromDialog(DlgWin,[wsf_Visible,wsf_Enabled]):-
	ChkWin = win_GetCtlHandle(DlgWin,idc_visible),
	Result = win_IsChecked(ChkWin),
	Result = checkbox_on,!.
  get_StateFromDialog(DlgWin,[wsf_Disabled,wsf_Visible]):-
	ChkWin = win_GetCtlHandle(DlgWin,idc_disabled),
	Result = win_IsChecked(ChkWin),
	Result = checkbox_on,!.
  get_StateFromDialog(DlgWin,[wsf_Invisible,wsf_Enabled]):-
	ChkWin = win_GetCtlHandle(DlgWin,idc_invisible),
	Result = win_IsChecked(ChkWin),
	Result = checkbox_on,!.

  set_StateToEditors(State):-
	example_db_EditorInTopLevel(Win),
	  trap(win_SetState(Win,State),_,fail),
	fail.
  set_StateToEditors(State):-
	example_db_CustomControlEditor(Win),
	  trap(win_SetState(Win,State),_,fail),
	fail.
  set_StateToEditors(_).

predicates
determ  setPreviewFromEditor(WINDOW)
  setFontPreview(WINDOW,WINDOW)

clauses
  setPreviewFromEditor(Win):-
	W = propedit_GetInt(Win,101), W = i(Width),
	H = propedit_GetInt(Win,102), H = i(Height),
	RctNew = rct(1,1,Width,Height),
	propedit_GetListButton(Win,106,STR,_),
	colorNameToNumber(STR,PenLColor),
	propedit_GetListButton(Win,109,StrFill,_),
	brushNameToPATSTYLE(StrFill,PAT),
	propedit_GetListButton(Win,108,StrPS,_),
	penNameToPENWIDTH_PENSTYLE(StrPS,PW,PS),
	FillCol = propedit_GetLong(Win,105), FillCol = l(FillLColor),
	retract(example_db_Prev(WinP,_,_,_,_,_,_)),
	assert(example_db_Prev(WinP,PenLColor,FillLColor,PAT,PS,PW,RctNew)),
	setFontPreview(Win,WinP),
	draw_preview(WinP),
	!.

  setFontPreview(Win,WinP):-
	example_db_PrevFont(Win,Font),
	win_SetFont(WinP,Font),
	!.
  setFontPreview(_Win,WinP):-
	Font = font_Create(ff_helvetica,[],8),
	win_SetFont(WinP,Font),
	!.
	
/*******************************************************************
	 Callback function example
*******************************************************************/
predicates
  prop_Callback : PROPERTY_CALLBACK 	% Callback for Property Editor

clauses
  prop_Callback(_Win,Event):- nl,write(" CALLBACK: ",Event),fail. % Write event

  prop_Callback(Win,modified(PropID)):-
	Val = propedit_GetValue(Win,PropID),% Write value and label
	propedit_GetPropertyLabel(Win,PropID,Title),
	write("  LABEL: ",Title," VALUE: ",Val),fail.

% New width user entered
  prop_Callback(Win,modified(101)):-	% Get height,width from field and set new for preview
	W = propedit_GetInt(Win,101), W = i(Width),	% Get Width from field
	H = propedit_GetInt(Win,102), H = i(Height),	% Get Height from field
	RctNew = rct(1,1,Width,Height),
	retract(example_db_Prev(PreviewWin,PenColor,FillColor,PATSTYLE,PENSTYLE,PENWIDTH,_)),
	assert(example_db_Prev(PreviewWin,PenColor,FillColor,PATSTYLE,PENSTYLE,PENWIDTH,RctNew)),
	draw_preview(PreviewWin),	% Redraw preview window
	!. 
% New height user entered
  prop_Callback(Win,modified(102)):- 
	W = propedit_GetInt(Win,101), W = i(Width),	% Get height,width 
	H = propedit_GetInt(Win,102), H = i(Height),	% from field and set new for preview
	RctNew = rct(1,1,Width,Height),
	retract(example_db_Prev(PreviewWin,PenColor,FillColor,PATSTYLE,PENSTYLE,PENWIDTH,_)),
	assert(example_db_Prev(PreviewWin,PenColor,FillColor,PATSTYLE,PENSTYLE,PENWIDTH,RctNew)),
	draw_preview(PreviewWin),
	!. 
  prop_Callback(Win,callPBPressed(103)):- 
	example_db_Prev(PreviewWin,_,_,_,_,_,_),
	OldFont = win_GetFont(PreviewWin),
	NewFont = dlg_ChooseFont(OldFont,NewFontName,_),% Get FontName from dlg_ChooseFont,
	retractAll(example_db_PrevFont(Win,_)),
	assert(example_db_PrevFont(Win,NewFont)),
	propedit_SetStr(Win,103,NewFontName),		% set to field and preview
	win_SetFont(PreviewWin,NewFont),
	draw_preview(PreviewWin),
	!.
  prop_Callback(Win,callPBPressed(105)):- 
	example_db_Prev(_,_,FillColor,_,_,_,_),
	Color = dlg_ChooseColor(FillColor),		% Get Color from dlg_ChooseColor 
	Lcolor = cast(long,Color),
	propedit_SetLong(Win,105,l(Lcolor)),		% and set to "Fill Color" field
	retract(example_db_Prev(PreviewWin,PenColor,FillColor,PATSTYLE,PENSTYLE,PENWIDTH,RCT)),
	assert(example_db_Prev(PreviewWin,PenColor,Lcolor,PATSTYLE,PENSTYLE,PENWIDTH,RCT)),
	draw_preview(PreviewWin),
	!.
  prop_Callback(Win,modified(105)):- 
	Col = propedit_GetLong(Win,105), Col = l(LColor),	% Get Fill Color from field
	retract(example_db_Prev(PreviewWin,PenColor,_FillColor,PATSTYLE,PENSTYLE,PENWIDTH,RCT)),
	assert(example_db_Prev(PreviewWin,PenColor,Lcolor,PATSTYLE,PENSTYLE,PENWIDTH,RCT)),
	draw_preview(PreviewWin),
	!.
  prop_Callback(Win,modified(106)):- 
	propedit_GetListButton(Win,106,STR,_),		% Get Name of Pen Color from list
	colorNameToNumber(STR,Lcolor),			% Name to number transformation
	retract(example_db_Prev(PreviewWin,_PenColor,FillColor,PATSTYLE,PENSTYLE,PENWIDTH,RCT)),
	assert(example_db_Prev(PreviewWin,Lcolor,FillColor,PATSTYLE,PENSTYLE,PENWIDTH,RCT)),
	draw_preview(PreviewWin),
	!.  
  prop_Callback(Win,modified(108)):- 
	propedit_GetListButton(Win,108,STR,_),	% Get Name of PENSTYLE and PENWIDTH from list
	penNameToPENWIDTH_PENSTYLE(STR,PW,PS),	% Name to PENSTYLE and PENWIDTH transformation
	retract(example_db_Prev(PreviewWin,PenColor,FillColor,PATSTYLE,_PENSTYLE,_PENWIDTH,RCT)),
	assert(example_db_Prev(PreviewWin,PenColor,FillColor,PATSTYLE,PS,PW,RCT)),
	draw_preview(PreviewWin),
	!.  
  prop_Callback(Win,modified(109)):-
	propedit_GetListButton(Win,109,STR,_), 		% Get Name of Fill from list
	brushNameToPATSTYLE(STR,PAT),			% Name to PATSTYLE transformation
	retract(example_db_Prev(PreviewWin,PenColor,FillColor,_PATSTYLE,PENSTYLE,PENWIDTH,RCT)),
	assert(example_db_Prev(PreviewWin,PenColor,FillColor,PAT,PENSTYLE,PENWIDTH,RCT)),
	draw_preview(PreviewWin),
	!.  

  prop_Callback(Win,getFocus):- 		% Property editor get focus,
	setPreviewFromEditor(Win),		% get values from editor and redraw Preview window
	!.  

  prop_Callback(Win,is_ToBeDestroyed):- 		% Property editor in top level destroed
	TaskWin=vpi_GetTaskWin(),
	menu_Enable(TaskWin,"Test",b_false),
	menu_Update(TaskWin),
	retract(example_db_EditorInTopLevel(Win)),fail.
  	
predicates
  reload_To_Table1_2()
  reload_To_Table3()

clauses
  reload_To_Table1_2():-				% If exist Property Editor in top level window,
	example_db_tbl(_TaskWin,Tbl1_2,_Tbl3),	% get example table 1,2 from database
	example_db_EditorInTopLevel(Win),		% and load it to Property editor
	  propedit_Reload(Win,"Property Editor in TopLevel window, table 1,2",Tbl1_2,160),
	  retractAll(example_db_PrevFont(Win,_)),
	  setPreviewFromEditor(Win),
	fail.
  reload_To_Table1_2():-				% If exist Custom control Property Editor 
	example_db_tbl(_TaskWin,Tbl1_2,_Tbl3),	% Get example table 1,2 from database
	example_db_CustomControlEditor(Win),	% and load it to Property editor
	  propedit_ReloadCustom(Win,Tbl1_2,160),
	  retractAll(example_db_PrevFont(Win,_)),
	  setPreviewFromEditor(Win),
	fail.	
  reload_To_Table1_2().	

  reload_To_Table3():-					% If exist Property Editor in top level window,
	example_db_tbl(_TaskWin,_Tbl1_2,Tbl3),	% get example table 3 from database
	example_db_EditorInTopLevel(Win),		% and load it to Property editor
	  propedit_Reload(Win,"Property Editor in TopLevel window, table 3",Tbl3,160),
	  retractAll(example_db_PrevFont(Win,_)),
	  setPreviewFromEditor(Win),
	fail.
  reload_To_Table3():-					% If exist Custom control Property Editor 
	example_db_tbl(_TaskWin,_Tbl1_2,Tbl3),		% Get example table 3 from database
	example_db_CustomControlEditor(Win),		% and load it to Property editor
	  propedit_ReloadCustom(Win,Tbl3,160),
	  retractAll(example_db_PrevFont(Win,_)),
	  setPreviewFromEditor(Win),
	fail.	
  reload_To_Table3().	

predicates
  get_Sheet()

clauses
  get_Sheet():-						% If Property Editor in top level window,
	example_db_EditorInTopLevel(Win),		% get Sheet from Property editor
	  Prop_Sheet = propedit_GetSheet(Win),		% and write Sheet
	  nl,write(" SHEET:  ",Prop_Sheet),nl,nl,
	fail.
  get_Sheet():-						% If Custom control Property Editor, 
	example_db_CustomControlEditor(Win),		% get Sheet from Property editor
	  Prop_Sheet = propedit_GetSheet(Win),		% and write Sheet
	  nl,write(" SHEET:  ",Prop_Sheet),nl,nl,
	fail.
  get_Sheet().						 

predicates
determ  set_NewFont
  set_Font(FONT)
determ  get_OldFont(FONT)

clauses
  set_NewFont():- % Set new font for Property Editor
	get_OldFont(OldFont),
	NewFont = dlg_ChooseFont(OldFont,NewFontName,Size),% Get FontName from dlg_ChooseFont
	set_Font(NewFont),
	nl,write("PROPERTY FONT: ",NewFontName,"  SIZE: ",Size),
	!.

  set_Font(NewFont):-
	example_db_EditorInTopLevel(Win),
	  trap(win_SetFont(Win,NewFont),_,fail), % Set font for Property Editor
	fail.
  set_Font(NewFont):-
	example_db_CustomControlEditor(Win),
	  trap(win_SetFont(Win,NewFont),_,fail), % Set font for Property Editor
	fail.
  set_Font(_).

  get_OldFont(OldFont):-
	example_db_EditorInTopLevel(Win),
	trap(OldFont = win_GetFont(Win),_,fail),
	!.
  get_OldFont(OldFont):-
	example_db_CustomControlEditor(Win),
	trap(OldFont = win_GetFont(Win),_,fail),
	!.

/**************************************************************************
	Tables example and clauses for Preview window 
**************************************************************************/
predicates
  init_example(WINDOW)
  create_example_window(WINDOW)

clauses
  init_example(Parent):-
	not(example_db_tbl(Parent,_,_)),
	create_example_window(Parent),
	!.
  init_example(_).

  create_example_window(Parent):-
% Assert tables and create preview window
	assert(example_db_tbl(Parent,
% Tables 1,2  
	  [pTbl(71,"Table1",
		[property(101,"Width (30-70)",editInt(i(70),[range(30,70)]),user_prompt("Width must be an integer from 30 to 70. User input: %"),b_false),
		property(102,"Height (30-70)",editInt(i(70),[range(30,70)]),user_prompt("Height must be integer from 30 to 70. User input: %"),b_false),
		property(103,"Font Name",editStr("",[ronly]),nopr,b_true),
		property(106,"Pen color",listButton(
			["White","Black","Gray","LtGray","Red","DkRed",
			 "Green","DkGreen","Blue","DkBlue","Cyan"],1),nopr,b_false),
		property(105,"Brush color",editLong(l(0x808080),[]),nopr,b_true),
		property(108,"Pen",listButton(
			["Solid 1","Solid 3","Dash 1","Dot 1","DashDot 1","DashDotDot 1",
			 "Hollow 1"],0),nopr,b_false),
		property(109,"Fill",listButton(
			["Hollow","Solid","Horz","Vert","FDiag","BDiag",
			"Cross","DiagCross"],1),nopr,b_false)]),  
	  pTbl(72,"Table2",
		[property(201,"String (Upper)",editStr("UPPER",[upper]),nopr,b_false),
		property(202,"Real (>=5.0)",editReal(r(123.456),[minimum(5.0)]),nopr,b_false),
		property(204,"String (1-10 chars)",listEdit(["Alex","Bob","Tom"],"Alex",[range(1,10)]),
		  user_prompt("String must be from 1 to 10 chars. User input: %"),b_false),
		property(203,"Long",editLong(l(123456),[]),nopr,b_false)])]
	,
% Table 3  
	  [pTbl(73,"Table3",
		[property(101,"Width (30-70)",editInt(i(70),[range(30,70)]),user_prompt("Width must be an integer from 30 to 70. User input: %"),b_false),
		property(102,"Height (30-70)",editInt(i(70),[range(30,70)]),user_prompt("Height must be integer from 30 to 70. User input: %"),b_false),
		property(103,"Font Name",editStr("",[ronly]),nopr,b_true),
		property(106,"Pen color",listButton(
			["White","Black","Gray","LtGray","Red","DkRed",
			 "Green","DkGreen","Blue","DkBlue","Cyan"],1),nopr,b_false),
		property(105,"Brush color",editLong(l(0x808080),[]),nopr,b_true),
		property(108,"Pen",listButton(
			["Solid 1","Solid 3","Dash 1","Dot 1","DashDot 1","DashDotDot 1",
			 "Hollow 1"],0),nopr,b_false),
		property(109,"Fill",listButton(
			["Hollow","Solid","Horz","Vert","FDiag","BDiag",
			"Cross","DiagCross"],1),nopr,b_false)])]
	)),		
% Create preview window
	win_preview_Create(Parent),
	!.
predicates
  example_eh : EHANDLER

clauses
  example_eh(Win,e_Update(_),0):-!,
	draw_preview(Win), % draw preview window
	!.

%BEGIN_WIN Task Window
/***************************************************************************
	Event handling for Task Window
***************************************************************************/

predicates
  
  task_win_eh : EHANDLER		% Task window EVENT HANDLER

constants
%BEGIN Task Window, CreateParms, 15:01:42-24.11.1999, Code automatically updated!
  task_win_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Close,wsf_Maximize,wsf_Minimize,wsf_ClipSiblings]
  task_win_Menu  = res_menu(idr_task_menu)
  task_win_Title = "Property"
  task_win_Help  = idh_contents
%END Task Window, CreateParms

clauses

%BEGIN Task Window, e_Create
  task_win_eh(_Win,e_Create(_),0):-!,	 
%BEGIN Task Window, InitControls, 15:01:42-24.11.1999, Code automatically updated!
%END Task Window, InitControls
%BEGIN Task Window, ToolbarCreate, 15:01:42-24.11.1999, Code automatically updated!
	tb_project_toolbar_Create(_Win),
	tb_help_line_Create(_Win),
%END Task Window, ToolbarCreate
ifdef use_message
	msg_Create(100),
enddef
	menu_Enable(_Win,"Test",b_false),
/* Register class for custom control Property editor */
	class_Create(propedit_class,propedit_class_handler). 

%END Task Window, e_Create

%MARK Task Window, new events

%BEGIN Task Window, id_help_about
  task_win_eh(_Win,e_Menu(id_help_about,_ShiftCtlAlt),0):-!,
	dlg_about_dialog_Create(_Win),
	!.
%END Task Window, id_help_about


%BEGIN Task Window, e_Destroy
  task_win_eh(_Win,e_Destroy(),0):-		
/* Destroy class for custom control property editor */
	class_Destroy(propedit_class),fail.
%END Task Window, e_Destroy

%BEGIN Task Window, id_file_open
  task_win_eh(_Win,e_Menu(id_file_open,_ShiftCtlAlt),0):-!,
/* Create Custom control Property editor in modeless dialog */
	dlg_property_sheet_in_modeless_dialog_Create(_Win),
	menu_Enable(_Win,"Test",b_true),
	menu_Update(_Win),
	!.
%END Task Window, id_file_open

%BEGIN Task Window, id_file_new
/* Create Property Editor in top level window */
  task_win_eh(TaskWin,e_Menu(id_file_new,_ShiftCtlAlt),0):-
	init_example(TaskWin), % Create preview window and assert database 
	example_db_tbl(TaskWin,Tbl1_2,_Tbl3),!,	% Get tables 1,2 from database
	Font = font_Create(ff_helvetica,[],8),	% Create Font for Property Editor window
  	Flags = [wsf_Invisible,wsf_SizeBorder,wsf_TitleBar,wsf_Maximize,wsf_Minimize,wsf_Close,wsf_ClipSiblings,wsf_ClipChildren],
	Win = propedit_Create(TaskWin,rct(150,30,440,250),%Create Property Editor in top level window
		"Property Editor in TopLevel window",
		Font,Tbl1_2,prop_Callback,160,Flags),
	assert(example_db_EditorInTopLevel(Win)), % Assert Property Editor Window in database
	menu_Enable(TaskWin,"Test",b_true),
	menu_Update(TaskWin).
%END Task Window, id_file_new

%BEGIN Task Window, id_Test_Setfont
/* Set new font for Property editors */
  task_win_eh(_TaskWin,e_Menu(id_Test_Setfont,_ShiftCtlAlt),0):-!,
	set_NewFont().
%END Task Window, id_Test_Setfont

%BEGIN Task Window, id_Test_State
/* Set new state for Property editors */
  task_win_eh(_Win,e_Menu(id_Test_State,_ShiftCtlAlt),0):-!,
	dlg_state_dialog_Create(_Win),
	!.
%END Task Window, id_Test_State

%BEGIN Task Window, id_Test_Reload
/* Reload tables  */
  task_win_eh(_Win,e_Menu(id_Test_Reload,_ShiftCtlAlt),0):-!,
	dlg_reload_dialog_Create(_Win),
	!.
%END Task Window, id_Test_Reload

%BEGIN Task Window, id_Test_GetSheet
/* Get Sheet from Edietor */
  task_win_eh(_TaskWin,e_Menu(id_Test_GetSheet,_ShiftCtlAlt),0):-!,
	get_Sheet().
%END Task Window, id_Test_GetSheet

%BEGIN Task Window, id_file_exit
  task_win_eh(Win,e_Menu(id_file_exit,_ShiftCtlAlt),0):-!,
  	win_Destroy(Win),fail.
%END Task Window, id_file_exit

%BEGIN Task Window, id_help_contents
  task_win_eh(_Win,e_Menu(id_help_contents,_ShiftCtlAlt),0):-!,
  	vpi_ShowHelp("prop.hlp"),!.
%END Task Window, id_help_contents

%BEGIN Task Window, e_Size
  task_win_eh(_Win,e_Size(_Width,_Height),0):-!,
	toolbar_Resize(_Win),
	msg_Resize(_Win),
	!.
%END Task Window, e_Size

%END_WIN Task Window

%BEGIN_DLG Property sheet in Modeless dialog
/**************************************************************************
Creation and event handling for dialog: Property sheet in Modeless dialog
**************************************************************************/
predicates
  dlg_property_eh : EHANDLER

clauses
  dlg_property_sheet_in_modeless_dialog_Create(Parent):- % Create dialog from resurse 
	init_example(Parent), % Create preview window and assert database 
	win_CreateResDialog(Parent,wd_Modeless,idd_propmodeless,
	dlg_property_eh,0),!.

  dlg_property_eh(_Win,e_CloseRequest,0):-!,
	TaskWin=vpi_GetTaskWin(),
	menu_Enable(TaskWin,"Test",b_false),
	menu_Update(TaskWin),
	win_Destroy(_Win),
	!.

  dlg_property_eh(_,_,_):-!,fail.
%END_DLG Property sheet in Modeless dialog

/***************************************************************************
	Invoking on-line Help
***************************************************************************/
  project_ShowHelpContext(HelpTopic):-
  	vpi_ShowHelpContext("prop.hlp",HelpTopic),!.

/***************************************************************************
	Main Goal
***************************************************************************/
GOAL
  vpi_SetAttrVal(attr_win_mdi,b_true),
  vpi_SetAttrVal(attr_win_3dcontrols,b_true),
  vpi_Init(task_win_Flags,task_win_eh,task_win_Menu,"prop",task_win_Title).

%BEGIN_TLB Project toolbar, 15:03:18-24.11.1999, Code automatically updated!
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



%BEGIN_TLB Help line, 16:02:33-10.10.1996, Code automatically updated!
/**************************************************************************
	Creation of toolbar: Help line
**************************************************************************/

clauses

  tb_help_line_Create(_Parent):-
ifdef use_tbar
	toolbar_create(tb_bottom,0xC0C0C0,_Parent,
		[tb_text(idt_help_line,tb_context,452,0,4,10,0x0,"")]),
enddef
	!.
%END_TLB Help line

%BEGIN_DLG About dialog
/**************************************************************************
	Creation and event handling for dialog: About dialog
**************************************************************************/
constants
  dlg_about_dialog_ResID = idd_dlg_about
  dlg_about_dialog_DlgType = wd_Modal
  dlg_about_dialog_Help = idh_contents
predicates
  dlg_about_dialog_eh : EHANDLER

clauses
  dlg_about_dialog_Create(Parent):-
	win_CreateResDialog(Parent,dlg_about_dialog_DlgType,dlg_about_dialog_ResID,dlg_about_dialog_eh,0),
	!.
%BEGIN About dialog, idc_ok _CtlInfo
  dlg_about_dialog_eh(_Win,e_Control(idc_ok,_CtrlType,_CtrlWin,_CtrlInfo),0):-!,
	win_Destroy(_Win),
	!.
%END About dialog, idc_ok _CtlInfo
%MARK About dialog, new events

  dlg_about_dialog_eh(_,_,0):- fail.

%END_DLG About dialog

%BEGIN_DLG State dialog
/**************************************************************************
	Creation and event handling for dialog: State dialog
**************************************************************************/

constants

%BEGIN State dialog, CreateParms, 14:59:54-24.11.1999, Code automatically updated!
  dlg_state_dialog_ResID = idd_state
  dlg_state_dialog_DlgType = wd_Modal
  dlg_state_dialog_Help = idh_contents
%END State dialog, CreateParms

predicates

  dlg_state_dialog_eh : EHANDLER
  dlg_state_dialog_handle_answer(INTEGER EndButton,DIALOG_VAL_LIST)
  dlg_state_dialog_update(DIALOG_VAL_LIST)

clauses

  dlg_state_dialog_Create(Parent):-

%MARK State dialog, new variables

	dialog_CreateModal(Parent,dlg_state_dialog_ResID,"",
  		[
%BEGIN State dialog, ControlList, 14:59:54-24.11.1999, Code automatically updated!
%END State dialog, ControlList
		],
		dlg_state_dialog_eh,0,VALLIST,ANSWER),!,
	dlg_state_dialog_handle_answer(ANSWER,VALLIST).

  dlg_state_dialog_handle_answer(idc_ok,VALLIST):-!,
	dlg_state_dialog_update(VALLIST).
  dlg_state_dialog_handle_answer(idc_cancel,_):-!.  % Handle Esc and Cancel here
  dlg_state_dialog_handle_answer(_,_):-
	errorexit().

  dlg_state_dialog_update(_VALLIST):-
%BEGIN State dialog, Update controls, 14:59:54-24.11.1999, Code automatically updated!
%END State dialog, Update controls
	true.

%MARK State dialog, new events

%BEGIN State dialog, idc_cancel _CtlInfo
  dlg_state_dialog_eh(_Win,e_Control(idc_cancel,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	win_Destroy(_Win),
	!.
%END State dialog, idc_cancel _CtlInfo

%BEGIN State dialog, idc_ok _CtlInfo
  dlg_state_dialog_eh(_Win,e_Control(idc_ok,_CtrlType,_CtrlWin,activated()),0):-!,
	get_StateFromDialog(_Win,State),
	set_StateToEditors(State),
	win_Destroy(_Win),	
	!.
%END State dialog, idc_ok _CtlInfo

%BEGIN State dialog, e_Create
  dlg_state_dialog_eh(_Win,e_Create(_CreationData),0):-!,
	Chk1Win = win_GetCtlHandle(_Win,idc_visible),
	Chk2Win = win_GetCtlHandle(_Win,idc_disabled),
	Chk3Win = win_GetCtlHandle(_Win,idc_invisible),
	win_CheckRadioButton(Chk1Win,[Chk1Win,Chk2Win,Chk3Win]),
	!.
%END State dialog, e_Create

  dlg_state_dialog_eh(_,_,_):-!,fail.

%END_DLG State dialog

%BEGIN_DLG Reload Dialog
/**************************************************************************
	Creation and event handling for dialog: Reload Dialog
**************************************************************************/

constants

%BEGIN Reload Dialog, CreateParms, 15:00:22-24.11.1999, Code automatically updated!
  dlg_reload_dialog_ResID = idd_reload
  dlg_reload_dialog_DlgType = wd_Modal
  dlg_reload_dialog_Help = idh_contents
%END Reload Dialog, CreateParms

predicates

  dlg_reload_dialog_eh : EHANDLER
  dlg_reload_dialog_handle_answer(INTEGER EndButton,DIALOG_VAL_LIST)
  dlg_reload_dialog_update(DIALOG_VAL_LIST)

clauses

  dlg_reload_dialog_Create(Parent):-

%MARK Reload Dialog, new variables

	dialog_CreateModal(Parent,dlg_reload_dialog_ResID,"",
  		[
%BEGIN Reload Dialog, ControlList, 15:00:22-24.11.1999, Code automatically updated!
%END Reload Dialog, ControlList
		],
		dlg_reload_dialog_eh,0,VALLIST,ANSWER),!,
	ANSWER = idc_ok,
	dlg_reload_dialog_handle_answer(ANSWER,VALLIST).

  dlg_reload_dialog_handle_answer(idc_ok,VALLIST):-!,
	dlg_reload_dialog_update(VALLIST).
  dlg_reload_dialog_handle_answer(idc_cancel,_):-!.  % Handle Esc and Cancel here
  dlg_reload_dialog_handle_answer(_,_):-
	errorexit().

  dlg_reload_dialog_update(_VALLIST):-
%BEGIN Reload Dialog, Update controls, 15:00:22-24.11.1999, Code automatically updated!
%END Reload Dialog, Update controls
	true.

%MARK Reload Dialog, new events

%BEGIN Reload Dialog, idc_cancel _CtlInfo
  dlg_reload_dialog_eh(_Win,e_Control(idc_cancel,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	win_Destroy(_Win),
	!.
%END Reload Dialog, idc_cancel _CtlInfo

%BEGIN Reload Dialog, idc_ok _CtlInfo
  dlg_reload_dialog_eh(_Win,e_Control(idc_ok,_CtrlType,_CtrlWin,activated()),0):-
	Chk12Win = win_GetCtlHandle(_Win,idc_tab12),
	Result = win_IsChecked(Chk12Win),
	Result = checkbox_on,
	reload_To_Table1_2(),!,
	win_Destroy(_Win),
	!.	
  dlg_reload_dialog_eh(_Win,e_Control(idc_ok,_CtrlType,_CtrlWin,activated()),0):-
	reload_To_Table3(),
	win_Destroy(_Win),
	!.	
%END Reload Dialog, idc_ok _CtlInfo

%BEGIN Reload Dialog, e_Create
  dlg_reload_dialog_eh(_Win,e_Create(_CreationData),0):-!,
	Chk12Win = win_GetCtlHandle(_Win,idc_tab12),
	Chk3Win = win_GetCtlHandle(_Win,idc_tab3),
	win_CheckRadioButton(Chk12Win,[Chk12Win,Chk3Win]),
	!.
%END Reload Dialog, e_Create

  dlg_reload_dialog_eh(_,_,_):-!,fail.

%END_DLG Reload Dialog
%BEGIN_WIN Preview
/**************************************************************************
        Creation and event handling for window: Preview
**************************************************************************/

constants
%BEGIN Preview, CreateParms, 15:01:34-24.11.1999, Code automatically updated!
  win_preview_WinType = w_TopLevel
  win_preview_Flags = [wsf_SizeBorder,wsf_TitleBar]
  win_preview_RCT = rct(1,1,3,3)
  win_preview_Menu = no_menu
  win_preview_Title = "Preview"
  win_preview_Help = idh_contents
%END Preview, CreateParms

predicates

  win_preview_eh : EHANDLER

clauses

  win_preview_Create(_Parent):-
	Win=win_Create(win_preview_WinType,win_preview_RCT,win_preview_Title,
		   win_preview_Menu,_Parent,win_preview_Flags,win_preview_eh,0),
	RctPr = rct(1,1,70,70),
%	Win = win_Create(w_TopLevel,rct(1,1,2,2),"Preview",no_menu,
%	  Parent,[wsf_TitleBar],example_eh,0),
	assert(example_db_Prev(Win,color_Black,color_Gray,pat_Solid,ps_Solid,1,RctPr)).

%BEGIN Preview, e_Create
  win_preview_eh(_Win,e_Create(_),0):-!,
%BEGIN Preview, InitControls, 15:01:34-24.11.1999, Code automatically updated!
%END Preview, InitControls
%BEGIN Preview, ToolbarCreate, 15:01:34-24.11.1999, Code automatically updated!
%END Preview, ToolbarCreate
	!.
%END Preview, e_Create
%MARK Preview, new events

%BEGIN Preview, e_Update
  win_preview_eh(_Win,e_Update(_UpdateRct),0):-!,
	draw_preview(_Win), % draw preview window
	!.
%END Preview, e_Update

%BEGIN Preview, e_Size
  win_preview_eh(_Win,e_Size(_Width,_Height),0):-!,
ifdef use_tbar
	toolbar_Resize(_Win),
enddef
	RCT=win_GetClientRect(_Win),
	win_Invalidate(_Win,RCT),
	!.
%END Preview, e_Size

%BEGIN Preview, e_Menu, Parent window 
  win_preview_eh(Win,e_Menu(ID,CAS),0):-!,
	PARENT = win_GetParent(Win),
	win_SendEvent(PARENT,e_Menu(ID,CAS)),
	!.
%END Preview, e_Menu, Parent window

%END_WIN Preview
