/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  TANGRAM
 FileName: TANGRAM.PRO
 Purpose: Tangram puzzle game
 Written by: Hans Dybkjær
 Comments: From 2-3 years, kids like to puzzle and some continue to puzzle al 
 their life. Tangram is a bit different from the normal European style of puzzles. 
 It always consists of the same 7 tangrambricks that forms as square. From these 
 the task is to build all sorts of other shapes and figures. Some tasks are to 
 build other Euclidean shape and others are more artistic to build swimming humans, 
 pigs, pistols etc. Because the game requires both fantasy and intelligence, the 
 Chinese call it "The game of intelligence". The game has inspired lots of famous 
 authors, such as Jonathan Swift, Lewis Caroll and Sam Lloyd. Also Napoleon should 
 according to the legend have played Tangram in his time on Sc. Helena. 
 
 This implementation is done by Hans Dybkjær as a game for kids. The task is simply 
 to drag the puzzles from the rectangular area in the left side to form the figure 
 in the right. Be quick and try not to make too many mistakes, if you want to 
 accomplish high score!
 
******************************************************************************/

include "tangram.inc"
include "tangram.con"
include "hlptopic.con"

constants
  drawModeMove = dm_Not
  drawModeStd  = dm_CopyPen
database - tan
	pie_moving(WINDOW,PIEID) % flag if moving down piece
	pie_down(WINDOW,PIEID,PT,% clicked in Win at id, at pt
		PIEID) 		 % copy of id, before move
	pie_selected(PIEID) % pie_selected piece
	pie_lastpt(PIEID,PT) % last pnt in move
	tan_current(STRING)
	tan_loaded()
	testing(PIEID,PIEID)
	creator_name(STRING)
	tangram_name(STRING)
	
PREDICATES
  pieDeselect(WINDOW)
  pieSelect(PIEID)
  pieDown(WINDOW,PT)
  pieMove(WINDOW,PT)
  pieMoveAux(PIEID,PT,PT)
  pieUp(WINDOW,PT)
  pieUpAux(WINDOW,PIEID)
  pieUpAux2(WINDOW,PIEID)
  pieTurnEvent(WINDOW,INTEGER)
  pieFlipEvent(WINDOW)
  pieOverlapRestore(WINDOW,PIEID,PIEID)
  pieLock(WINDOW,PIEID)
  pieRegister(WINDOW,PIEID)
  pieRestore(WINDOW)
  pieSuccess(WINDOW,SET)	
  pieFailure(WINDOW,SET)

  pieOverlapMode(PIEID,SET)
  winRefresh(WINDOW,RCT)
  winRefresh(WINDOW)

CLAUSES

pieDeselect(Win) :- 
	pie_selected(pieid(Win,Set,N)),Id=pieid(Win,Set,N),
	retractall(pie_selected(Id)),
	pieGetMod(Id,Mod),not(Mod=locked),!,
	pieSetMod(Id,normal),
  	Id=pieId(Win,_,_), win_SetDrawMode(Win,drawModeStd),
	pieDraw(Id).
pieDeselect(_) :- !.	

pieSelect(Id) :- 
	assert(pie_selected(Id)),
	pieSetMod(Id,selected),
	pieDraw(Id).
	
pieDown(Win,Pt) :-
	pieFind(Win,tangram,Pt,Id), !,
	puzzleInit(Win,temporary),
	pieCopy(Win,temporary,Id,IdC), 
	assert(pie_down(Win,Id,Pt,IdC)),
	win_SetDrawMode(Win,drawModeStd),
	not(pie_selected(Id)),
  	pieDeselect(Win),
	pieSelect(Id).
pieDown(Win,_) :-
	pieDeselect(Win).	
	  
pieMove(Win,Pt2) :-
	pie_moving(Win,Id),!,
	pie_lastpt(Id,Pt1),!,
  	pieDraw(Id), % erase previous, we are in drawModeMove
  	pieMoveAux(Id,Pt1,Pt2).
	
pieMove(Win,Pt2) :- !,
	pie_down(Win,Id,Pt1,_),!,not(Pt1=Pt2),
	scoreIncMove(Win),
	assert(pie_moving(Win,Id)),
  	win_SetDrawMode(Win,drawModeMove),
  	pieMoveaux(Id,Pt1,Pt2).
	
pieMoveAux(Id,Pt1,Pt2) :-
	retractall(pie_lastpt(Id,_)),
	assert(pie_lastpt(Id,Pt2)),
  	pt2vec(Pt1,Pt2,V), pieSlide(Id,V),
  	pieOverlapMode(Id,tangram),
  	pieDraw(Id),
  	!.

pieOverlapMode(Id,Set) :- 
	pieOverlap(Id,Set,_),!,
 	pieSetMod(Id,secret).
 	
pieOverlapMode(Id,_) :- !,
  	pieSetMod(Id,moving).
  	
pieUp(Win,_Pt) :- 
	pie_moving(Win,Id),
	pieOverlap(Id,tangram,_),!,
	pieRestore(Win).

pieUp(Win,_Pt) :- 
	pie_moving(Win,_),
	pie_down(Win,Id,_,_),!,
	retractall(pie_moving(Win,_)),
	retractall(pie_down(Win,_,_,_)),
	pieSetMod(Id,selected),
	win_SetDrawMode(Win,drawModeStd),
	pieUpAux(Win,Id).
pieUp(Win,_Pt) :- 
	pie_down(Win,Id,_,_),!,
	retractall(pie_down(Win,_,_,_)), 
	pieUpAux2(Win,Id),!.
	
pieUpAux(Win,Id) :- 
	pieRegister(Win,Id),!.
pieUpAux(Win,_) :- !,
	win_Invalidate(Win),
	!.
	
pieUpAux2(Win,Id) :- 
	pieRegister(Win,Id),!.
pieUpAux2(_,Id) :- !,
	pieDraw(Id),
	!.

pieRestore(Win) :-
	pie_down(Win,Id,_,IdC),!,
	retractall(pie_moving(Win,_)),
	retractall(pie_down(Win,_,_,_)),
	pieDraw(Id),pieCopy(IdC,Id),
	pieSetMod(Id,selected),pieDelete(IdC),
	win_SetDrawMode(Win,drawModeStd).	
		
pieLock(Win,Id):- % now test if Id should lock into destination
	scaleGet(Win,_,_,Ymin,Ymax),
	Epsilon=(Ymax-Ymin)/20,
	pieNear(Id,puzzle,Epsilon,Id2),
	pieCopy(Id2,Id),
	pieSetMod(Id,locked).

pieRegister(Win,Id) :- % now register if success
	pieLock(Win,Id),
	pieSuccess(Win,tangram),
	win_Invalidate(Win),
	scoreDlgSuccess(Win),
	tan_current(TangramName),!,
	puzzleSave(Win,puzzle,TangramName),
	scoreDlgShowHigh(Win),
	!.	

pieTurnEvent(Win,Ang) :-
  	pie_selected(Id),!, pieCopy(Win,temporary,Id,IdC),
	pieTurn(Id,angle(Ang)),scoreIncTurn(Win),
	pieOverlapRestore(Win,Id,IdC).
  
pieFlipEvent(Win) :-
  	pie_selected(Id),!, pieCopy(Win,temporary,Id,IdC), 
  	pieFlip(Id),scoreIncFlip(Win),
  	pieOverlapRestore(Win,Id,IdC).
  	
pieOverlapRestore(_,Id,IdC) :-
	pieOverlap(Id,tangram,_),!,pieCopy(IdC,Id).
pieOverlapRestore(Win,Id,_) :-
	pieRegister(Win,Id),!,
	win_Invalidate(Win).
pieOverlapRestore(Win,_,_) :-
	win_Invalidate(Win),!.
	
winRefresh(Win,Rct) :- !,
  	% win_SetDrawMode(Win,drawModeStd),
	_DrawMode=win_GetDrawMode(Win), 
	win_SetDrawMode(Win,drawModeStd),
  	win_Clear(Win,Rct,color_Magenta),
	piesDraw(Win,puzzle),
	piesDraw(Win,tangram),
	scoreDrawCurrent(Win),
	win_SetDrawMode(Win,_DrawMode),	
	!.
	
winRefresh(Win) :- !,
	Rct=win_GetClientRect(Win),
	win_Invalidate(Win,Rct).

pieSuccess(Win,Set) :-
	not(pieFailure(Win,Set)).
pieFailure(Win,Set) :-
	pieIter(Win,Set,Id), pieGetMod(Id,Mod),not(Mod=locked),!.
	
%BEGIN_WIN Task Window
/***************************************************************************
	Event handling for Task Window
***************************************************************************/

PREDICATES

  task_win_eh : EHANDLER

CONSTANTS

%BEGIN Task Window, CreateParms, 19:53:22-25.11.1999, Code automatically updated!
  task_win_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Close,wsf_Maximize,wsf_Minimize,wsf_ClipSiblings,wsf_Maximized]
  task_win_Menu  = no_menu
  task_win_Title = "TANGRAM"
  task_win_Help  = contents
%END Task Window, CreateParms

CLAUSES

%BEGIN Task Window, e_Create
  task_win_eh(_Win,e_Create(_),0):-!,
%BEGIN Task Window, InitControls, 19:53:22-25.11.1999, Code automatically updated!
%END Task Window, InitControls
%BEGIN Task Window, ToolbarCreate, 19:53:22-25.11.1999, Code automatically updated!
	tb_tangram_toolbar_Create(_Win),
%END Task Window, ToolbarCreate
IFDEF use_message
	msg_Create(100),
ENDDEF
	!.
%END Task Window, e_Create

%MARK Task Window, new events


%BEGIN Task Window, e_MouseDown
  task_win_eh(_Win,e_MouseDown(_PNT,_ShiftCtlAlt,_Button),0):-!,
  	win_CaptureMouse(_Win),
  	mapDP2LP(_Win,_PNT,Pt),
	pieDown(_Win,Pt),
	!.
%END Task Window, e_MouseDown

%BEGIN Task Window, e_MouseUp
  task_win_eh(_Win,e_MouseUp(_PNT,_ShiftCtlAlt,_Button),0):-!,
  	win_ReleaseMouse(),
  	mapDP2LP(_Win,_PNT,Pt),
  	pieUp(_Win,Pt),  	
	!.
%END Task Window, e_MouseUp

%BEGIN Task Window, e_MouseMove
  task_win_eh(_Win,e_MouseMove(_PNT,_ShiftCtlAlt,_Button),0):-!,
  	mapDP2LP(_Win,_PNT,Pt),
  	pieMove(_Win,Pt),
	!.
%END Task Window, e_MouseMove

%BEGIN Task Window, e_Update
  task_win_eh(_Win,e_Update(_UpdateRct),0):-!,
  	winRefresh(_Win,_UpdateRct),
	!.
%END Task Window, e_Update

%BEGIN Task Window, idt_tangram_cheat
  task_win_eh(_Win,e_Menu(idt_tangram_cheat,_ShiftCtlAlt),0):-!,
  	tan_loaded(),
  	piesSetMod(_Win,puzzle,detail),
  	winRefresh(_Win),
	!.
%END Task Window, idt_tangram_cheat

%BEGIN Task Window, idt_tangram_flip
  task_win_eh(_Win,e_Menu(idt_tangram_flip,_ShiftCtlAlt),0):-!,
  	pieFlipEvent(_Win),
	!.
%END Task Window, idt_tangram_flip

%BEGIN Task Window, idt_tangram_load
  task_win_eh(_Win,e_Menu(idt_tangram_load,_ShiftCtlAlt),0):-!,
  	puzzleDlgLoadName(TangramName),
	puzzleLoad(_Win,TangramName),
	retractall(tan_current(_)),
	assert(tan_current(TangramName)),
  	assert(tan_loaded()),
	!.
%END Task Window, idt_tangram_load

%BEGIN Task Window, idt_tangram_reset
  task_win_eh(_Win,e_Menu(idt_tangram_reset,_ShiftCtlAlt),0):-!,
  	tan_current(TangramName),
	puzzleLoad(_Win,TangramName),
	!.
%END Task Window, idt_tangram_reset

%BEGIN Task Window, idt_tangram_save
  task_win_eh(_Win,e_Menu(idt_tangram_save,_ShiftCtlAlt),0):-
  	tan_loaded(),
  	puzzleDlgSaveName(TangramName),!,
	TangramName<>"",
  	puzzleDlgCreatorName(CreatorName),
  	puzzleSave(_Win,tangram,TangramName,CreatorName),
	puzzleLoad(_Win,TangramName),
	!.
  task_win_eh(_Win,e_Menu(idt_tangram_save,_ShiftCtlAlt),0):-!,
	!.
%END Task Window, idt_tangram_save

%BEGIN Task Window, idt_tangram_scores
  task_win_eh(_Win,e_Menu(idt_tangram_scores,_ShiftCtlAlt),0):-!,
  	tan_loaded(),
  	scoreDlgShowHigh(_Win),
	!.
%END Task Window, idt_tangram_scores

%BEGIN Task Window, idt_tangram_test
  task_win_eh(_Win,e_Menu(idt_tangram_test,_ShiftCtlAlt),0):-!,
	dlg_about_dialog_Create(_Win),
	!.
%END Task Window, idt_tangram_test

%BEGIN Task Window, idt_tangram_turn15
  task_win_eh(_Win,e_Menu(idt_tangram_turn15,_ShiftCtlAlt),0):-!,
  	pieTurnEvent(_Win,15),
	!.
%END Task Window, idt_tangram_turn15

%BEGIN Task Window, idt_tangram_turn30
  task_win_eh(_Win,e_Menu(idt_tangram_turn30,_ShiftCtlAlt),0):-!,
  	pieTurnEvent(_Win,30),
	!.
%END Task Window, idt_tangram_turn30

%BEGIN Task Window, idt_tangram_turn45
  task_win_eh(_Win,e_Menu(idt_tangram_turn45,_ShiftCtlAlt),0):-!,
  	pieTurnEvent(_Win,45),
	!.
%END Task Window, idt_tangram_turn45

%BEGIN Task Window, idt_tangram_turn60
  task_win_eh(_Win,e_Menu(idt_tangram_turn60,_ShiftCtlAlt),0):-!,
  	pieTurnEvent(_Win,60),
	!.
%END Task Window, idt_tangram_turn60

%BEGIN Task Window, idt_tangram_turn75
  task_win_eh(_Win,e_Menu(idt_tangram_turn75,_ShiftCtlAlt),0):-!,
  	pieTurnEvent(_Win,75),
	!.
%END Task Window, idt_tangram_turn75

%BEGIN Task Window, idt_tangram_turn90
  task_win_eh(_Win,e_Menu(idt_tangram_turn90,_ShiftCtlAlt),0):-!,
  	pieTurnEvent(_Win,90),
	!.
%END Task Window, idt_tangram_turn90

%BEGIN Task Window, id_help_contents
  task_win_eh(_Win,e_Menu(id_help_contents,_ShiftCtlAlt),0):-!,
  	vpi_ShowHelp("tangram.hlp"),
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
  	mapSet(_Win),
	win_Invalidate(_Win),
	!.
%END Task Window, e_Size

%END_WIN Task Window

/***************************************************************************
	Invoking on-line Help
***************************************************************************/

  project_ShowHelpContext(HelpTopic):-
  	vpi_ShowHelpContext("tangram.hlp",HelpTopic),!.

/***************************************************************************
	Main Goal
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
  vpi_Init(task_win_Flags,task_win_eh,task_win_Menu,"tangram",task_win_Title).

%BEGIN_DLG About dialog
/**************************************************************************
	Creation and event handling for dialog: About dialog
**************************************************************************/

CONSTANTS

%BEGIN About dialog, CreateParms, 12:57:54-26.11.1999, Code automatically updated!
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

  dlg_about_dialog_eh(_,_,_):-!,fail.

%END_DLG About dialog


%BEGIN_TLB Tangram toolbar, 19:53:42-25.11.1999, Code automatically updated!
/**************************************************************************
	Creation of toolbar: Tangram toolbar
**************************************************************************/

clauses

  tb_tangram_toolbar_Create(_Parent):-
ifdef use_tbar
	toolbar_create(tb_top,0xFF0000,_Parent,
		[tb_ctrl(idt_tangram_load,pushb,idb_tangram_load,idb_tangram_load,idb_tangram_load,"Load new tangram",1,1),
		 tb_ctrl(idt_tangram_reset,pushb,idb_tangram_reset,idb_tangram_reset,idb_tangram_reset,"Restart the tangram",1,1),
		 separator,
		 separator,
		 tb_ctrl(idt_tangram_flip,pushb,idb_tangram_flip,idb_tangram_flip,idb_tangram_flip,"Flip",1,1),
		 separator,
		 tb_ctrl(idt_tangram_turn15,pushb,idb_tangram_turn15,idb_tangram_turn15,idb_tangram_turn15,"Turn 15 degrees",1,1),
		 tb_ctrl(idt_tangram_turn30,pushb,idb_tangram_turn30,idb_tangram_turn30,idb_tangram_turn30,"Turn 30 degrees",1,1),
		 tb_ctrl(idt_tangram_turn45,pushb,idb_tangram_turn45,idb_tangram_turn45,idb_tangram_turn45,"Turn 45 degrees",1,1),
		 tb_ctrl(idt_tangram_turn60,pushb,idb_tangram_turn60,idb_tangram_turn60,idb_tangram_turn60,"Turn 60 degrees",1,1),
		 tb_ctrl(idt_tangram_turn75,pushb,idb_tangram_turn75,idb_tangram_turn75,idb_tangram_turn75,"Turn 75 degrees",1,1),
		 tb_ctrl(idt_tangram_turn90,pushb,idb_tangram_turn90,idb_tangram_turn90,idb_tangram_turn90,"Turn 90 degrees",1,1),
		 separator,
		 tb_ctrl(idt_tangram_scores,pushb,idb_tangram_scores,idb_tangram_scores,idb_tangram_scores,"Show best scores",1,1),
		 separator,
		 separator,
		 tb_ctrl(idt_tangram_save,pushb,idb_tangram_save,idb_tangram_save,idb_tangram_save,"Save new tangram",1,1),
		 tb_ctrl(idt_tangram_cheat,pushb,idb_tangram_cheat,idb_tangram_cheat,idb_tangram_cheat,"Cheat!!!",1,1),
		 tb_ctrl(idt_tangram_test,pushb,idb_tangram_test,idb_tangram_test,idb_tangram_test,"Who made it?",1,1),
		 tb_text(idt_tangram_shorthelp,tb_context,256,0,1,10,0xFFFF,"Point to a button")]),
enddef
	true.
%END_TLB Tangram toolbar















