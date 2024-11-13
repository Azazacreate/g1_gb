/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  HANOI
 FileName: HANOI.PRO
 Purpose: Towers of Hanoi
 Written by: Eugeny Akimov
 Comments:

******************************************************************************/

include "hanoi.inc"
include "hanoi.con"

DATABASE - pictcolor
	forecolor(long)
	
DATABASE - hanoidb
determ hanoi(integer)
determ speed(integer)

DATABASE - drpict
      picture_Data(integer,integer,integer)
determ is_Running
	check_destroy
	stop
	qq
	st_run
determ cl(integer,integer)
	timer_id(long)
determ timer_flag

PREDICATES
  s_table(integer,integer,integer)
  normal_Draw(Brush)
  reverse_Draw(Brush)
  wait

CLAUSES
  normal_Draw(brush(pat_Solid,X)):-foreColor(X),!.
  reverse_Draw(brush(pat_Solid,color_Black)).

  s_table(0,100,1).
  s_table(1,50,1).
  s_table(2,0,1).
  s_table(3,0,4).
  s_table(4,0,8).

  wait:-stop,!.
  wait:-speed(Speed),Speed>1,!.
  wait:-retract(timer_flag,drpict),!.
  wait:-vpi_ProcessEvents(b_true),wait.

PREDICATES
  move_Up(WINDOW,integer,integer,integer,integer)
  move_Up1(WINDOW,integer,integer,integer,integer)
  move_Down(WINDOW,integer,integer,integer,integer)
  move_Right(WINDOW,integer,integer,integer,integer)
  move_Left(WINDOW,integer,integer,integer,integer)
  draw_NormalRect(WINDOW,integer,integer,integer,integer,integer,RCT)
  draw_ReverseRect(WINDOW,RCT)
    
CLAUSES
  draw_NormalRect(_Win,Q,W,X1,Y1,Size,RCT):-
	CW=Q-X1,
	CH=W-Y1,
	Left=CW-Size*4,
	Top=CH-11,
	Right=CW+Size*4,
	Bottom=CH+11,
	RCT=rct(Left,Top,Right,Bottom),
	normal_Draw(Brush),
	win_SetBrush(_Win,Brush), 
	draw_Rect(_Win,RCT).

  draw_ReverseRect(_Win,RCT):-
	reverse_Draw(Brush),
	win_SetBrush(_Win,Brush),
	draw_Rect(_Win,RCT),
	wait.

/*----------------- Move_Up ----------------*/
  move_Up(_Win,_,_,_,_):-stop,!.
  move_Up(_Win,Center_Line,Size,Ps,Pe):-
	RCT=win_GetClientRect(_Win),
	RCT=rct(_,_,R,B),
	Q=R div 2,
	W=B div 2,
	cl(X,Y),!,
	X1=X-Center_Line,
	Y1=Y-Ps,
	draw_NormalRect(_Win,Q,W,X1,Y1,Size,_),
	move_Up1(_Win,Center_Line,Size,Ps,Pe).

  move_Up1(_Win,_,_,_,_):-stop,!.    
  move_Up1(_Win,_,_,H,H):-!.            
  move_Up1(_Win,Center_Line,Size,Ps,Pe):-
     	vpi_ProcessEvents(b_true),
	RCT=win_GetClientRect(_Win),
	RCT=rct(_,_,R,B),
	Q=R div 2,
	W=B div 2,
	cl(X,Y),speed(V),s_table(V,_,H), Center_New=Ps-H,
	X1=X-Center_Line,Y1=Y-Center_New,XX=Y-Ps,
	retract(picture_Data(X1,XX,Size),drpict),
	asserta(picture_Data(X1,Y1,Size),drpict),!,
	draw_NormalRect(_Win,Q,W,X1,Y1,Size,rct(Left,_,Right,Bottom)),
	Bottom_OLD=Bottom+H,
	draw_ReverseRect(_Win,rct(Left,Bottom,Right,Bottom_OLD)),
	move_Up1(_Win,Center_Line,Size,Center_New,Pe).
      
/*---------------- Move_Down ----------------*/         
  move_Down(_Win,_,_,_,_):-stop,!.
  move_Down(_Win,_,_,H,H):-!.
  move_Down(_Win,Center_Line,Size,Ps,Pe):-
	vpi_ProcessEvents(b_true),
	RCT=win_GetClientRect(_Win),
	RCT=rct(_,_,R,B),
	Q=R div 2,
	W=B div 2,
	cl(X,Y),speed(V),s_table(V,_,H), Center_New=Ps+H,
	X1=X-Center_Line,Y1=Y-Center_New,XX=Y-Ps,
	retract(picture_Data(X1,XX,Size),drpict),
	asserta(picture_Data(X1,Y1,Size),drpict),!,
	draw_NormalRect(_Win,Q,W,X1,Y1,Size,rct(Left,Top,Right,_)),
	Bottom_OLD=Top-H,
	draw_ReverseRect(_Win,rct(Left,Top,Right,Bottom_OLD)),
	move_Down(_Win,Center_Line,Size,Center_New,Pe).
      
/*--------------- Move_Right -----------------*/          
  move_Right(_Win,_,_,_,_):-stop,!.
  move_Right(_Win,_,_,H,H):-!.
  move_Right(_Win,Row,Size,Cs,Ce):-
	vpi_ProcessEvents(b_true),
	RCT=win_GetClientRect(_Win),
	RCT=rct(_,_,R,B),
	Q=R div 2,
	W=B div 2,
	cl(X,Y),speed(V),s_table(V,_,H), Center_New=Cs+H,
	X1=X-Center_New,Y1=Y-Row,XX=X-Cs,
	retract(picture_Data(XX,Y1,Size),drpict),
	asserta(picture_Data(X1,Y1,Size),drpict),!,
	draw_NormalRect(_Win,Q,W,X1,Y1,Size,rct(Left,Top,_,Bottom)),
	Right1=Left-H,
	draw_ReverseRect(_Win,rct(Left,Top,Right1,Bottom)),
	move_Right(_Win,Row,Size,Center_New,Ce).
      
/*---------------- Move_Left -----------------*/    
  move_Left(_Win,_,_,_,_):-stop,!.
  move_Left(_Win,_,_,H,H):-!.
  move_Left(_Win,Row,Size,Cs,Ce):-
	vpi_ProcessEvents(b_true),
	RCT=win_GetClientRect(_Win),
	RCT=rct(_,_,R,B),
	Q=R div 2,W=B div 2,
	cl(X,Y),speed(V),s_table(V,_,H),Center_New=Cs-H,
	X1=X-Center_New,Y1=Y-Row,XX=X-Cs,
	retract(picture_Data(XX,Y1,Size),drpict),
	asserta(picture_Data(X1,Y1,Size),drpict),!,
	draw_NormalRect(_Win,Q,W,X1,Y1,Size,rct(_,Top,Right,Bottom)),
	Right_OLD=Right+H,
	draw_ReverseRect(_Win,rct(Right,Top,Right_OLD,Bottom)),
	move_Left(_Win,Row,Size,Center_New,Ce).

PREDICATES
  move_Vert(WINDOW,integer,integer,integer,integer,integer,integer)
  move_Horizon(WINDOW,integer,integer,integer,integer,integer,integer)

CLAUSES
/*--------------- move_Vert -----------------*/   
  move_Vert(_Win,_,_,_,_,_,_):-stop,!.
  move_Vert(_Win,_,_,H,H,_,_):-!.
  move_Vert(_Win,Col,Size,H1,H2,StRow,StCol):-H1>H2,!,
	Center_Line=((Size/2)+Col)*8+StCol,
	P1=StRow+(H1*24),
	P2=StRow+(H2*24),
	move_Up(_Win,Center_Line,Size,P1,P2).
  move_Vert(_Win,Col,Size,H1,H2,StRow,StCol):-H1<H2,!,
	Center_Line=((Size/2)+Col)*8+StCol,
	P1=StRow+(H1*24),
	P2=StRow+(H2*24),
	move_Down(_Win,Center_Line,Size,P1,P2).
                 
/*------------- Move_Horizon -----------------*/    
  move_Horizon(_Win,_,_,_,_,_,_):-stop,!.
  move_Horizon(_Win,_,_,H,H,_,_):-!.
  move_Horizon(_Win,Row,Size,C1,C2,StRow,StCol):-C1<C2,!,
	RR=StRow+(Row*24),
	CL1=((Size/2)+C1)*8+StCol,
	CL2=((Size/2)+C2)*8+StCol,
	move_Right(_Win,RR,Size,CL1,CL2).
  move_Horizon(_Win,Row,Size,C1,C2,StRow,StCol):-C1>C2,!,
	RR=StRow+(Row*24),
	CL1=((Size/2)+C1)*8+StCol,
	CL2=((Size/2)+C2)*8+StCol,
	move_Left(_Win,RR,Size,CL1,CL2).
      
PREDICATES
  makepole(WINDOW,integer,integer,integer,integer)
  move(WINDOW,integer,integer,integer,integer,integer,integer,integer,integer,integer,integer)
  inform(WINDOW,integer,integer,integer,integer,integer,integer,integer,integer)
  
CLAUSES
/*----------------- Makepole ---------------*/    
  makepole(_Win,_,_,_,_):-stop,!.
  makepole(_Win,0,_,_,_):-!.
  makepole(_Win,N,StRow,StCol,Center_Line):-
	vpi_ProcessEvents(b_true),
	Center_Rect=StRow+(N*24),Size=2*N,
	cl(X,Y),!,
	X1=X-Center_Line,Y1=Y-Center_Rect,
	Left=Center_Line-(N*8), Top=Center_Rect-11,
	Right=Center_Line+(N*8), Bottom=Center_Rect+11,
	RCT=rct(Left,Top,Right,Bottom),
	normal_Draw(Brush),
	win_SetBrush(_Win,Brush),
	draw_Rect(_Win,RCT),
	asserta(picture_Data(X1,Y1,Size),drpict),
	N1=N-1,
	makepole(_Win,N1,StRow,StCol,Center_Line).

/*----------------- Move -------------------*/
  move(_Win,_,_,_,_,_,_,_,_,_,_):-stop,!.
  move(_Win,H,1,HA,_,HC,CA,_,CH,StRow,StCol):-!,
	vpi_ProcessEvents(b_true),
	inform(_Win,H,1,HA,HC,CA,CH,StRow,StCol).
  move(_Win,H,N,HA,HB,HC,CA,CB,CC,StRow,StCol):-
	N1=N-1, HA1=HA+1,
	move(_Win,H,N1,HA1,HC,HB,CA,CC,CB,StRow,StCol),
	inform(_Win,H,N,HA,HC,CA,CC,StRow,StCol),
	HC1=HC+1,
	move(_Win,H,N1,HB,HA,HC1,CB,CA,CC,StRow,StCol).
      
/*---------------- Inform -----------------*/    
  inform(_Win,_,_,_,_,_,_,_,_):-stop,!.
  inform(_Win,H,N,H1,H2,C1,C2,StRow,StCol):-
	C11=C1-N, C22=C2-N, NN=2*N,
	H11=H-H1, H22=H-H2,
	move_Vert(_Win,C11,NN,H11,1,StRow,StCol),
	move_Horizon(_Win,1,NN,C11,C22,StRow,StCol),
	move_Vert(_Win,C22,NN,1,H22,StRow,StCol).
      
PREDICATES
  run(WINDOW)
  draw_BlackRect(WINDOW,RCT)
  draw_WhiteRect(WINDOW,integer,integer,integer,integer)
  draw_YellowRect(WINDOW,integer,integer,integer,integer,integer,RCT)
  draw_DiagCrossGrid(WINDOW,integer,integer)
  
CLAUSES  
  draw_WhiteRect(_Win,Right_New,Bottom_New,Center_Width,Center_Height):-
	RCT=win_GetClientRect(_Win),
	RCT=rct(_,_,Right,Bottom),
	Right_New=Right-15,
	Bottom_New=Bottom-15,
	Center_Width=Right div 2,
	Center_Height=Bottom div 2,
	Brush=brush(pat_Solid,color_White),
	win_SetBrush(_Win,Brush),
	draw_Rect(_Win,RCT),
	asserta(cl(Center_Width,Center_Height),drpict).
	
  draw_DiagCrossGrid(_Win,Right,Bottom):-
	Brush=brush(pat_DiagCross,color_Black),
	RCT=rct(15,15,Right,Bottom),
	win_SetBrush(_Win,Brush),
	draw_Rect(_Win,RCT).

  draw_YellowRect(_Win,N,Center_Width,Center_Height,StCol,StRow,rct(K1,K2,K3,K4)):-
	StCol=Center_Width-(2*N+N)*8,
	StRow=Center_Height-(N/2)*24-12,
	K1=StCol-11,
	K2=StRow-12,
	K3=Center_Width+(2*N+N)*8+11,
	K4=Center_Height+(N/2+1)*24,
	KK1=K1-5, KK2=K2-5,
	KK3=K3+5, KK4=K4+5,
	normal_Draw(Brush),
	RCT=rct(KK1,KK2,KK3,KK4),
	win_SetBrush(_Win,Brush),
	draw_Rect(_Win,RCT).
  
  draw_BlackRect(_Win,RCT):-
	reverse_Draw(Brush),
	win_SetBrush(_Win,Brush),
	draw_Rect(_Win,RCT).
  	
  run(_Win):-
	retractall(_,drpict),
	assert(is_Running),
	draw_WhiteRect(_Win,Right,Bottom,Center_Width,Center_Height),
	assert(check_destroy,drpict),
/*------------ Draw DiagCross grid -------------*/        
	draw_DiagCrossGrid(_Win,Right,Bottom),
/*---------- Draw Yellow Rectangle -------------*/      
	hanoi(N),
	CV=N, CM=3*N, CH=5*N,
	draw_YellowRect(_Win,N,Center_Width,Center_Height,StCol,StRow,RCT),
/*----------- Draw Black Rectangle -------------*/      
	draw_BlackRect(_Win,RCT),
	Center_Line=N*8+StCol,
/*----------------- timer Set -----------------*/      
	speed(V),s_table(V,A,_),
	TimerID=timer_Set(_Win,A),
	asserta(timer_id(TimerID),drpict),
/*----------------- Main part ----------------*/      
	makepole(_Win,N,StRow,StCol,Center_Line),
	move(_Win,N,N,0,0,0,CV,CM,CH,StRow,StCol),
/*----------------- timer Kill ----------------*/      
	retract(timer_id(TimerID),drpict),
	timer_Kill(TimerID),stop,
	qq,win_Destroy(_Win),
	!.
  run(_Win):-
  	st_run,
  	retractall(_,drpict),
  	run(_Win),
  	!.
  run(_Win):-
  	check_destroy,
  	retractall(check_destroy),
  	!.

PREDICATES
  draw_picture_Data(WINDOW,integer,integer)
  
CLAUSES  
  draw_picture_Data(_Win,Center_Width,Center_Height):-
	picture_Data(Center_Line,Center_Rect,Size),
	CW=Center_Width-Center_Line,
	CH=Center_Height-Center_Rect,
	Left=CW-Size*4,
	Top=CH-11,
	Right=CW+Size*4,
	Bottom=CH+11,
	foreColor(Forecolor),
	Brush=brush(pat_Solid,Forecolor),
	RCT=rct(Left,Top,Right,Bottom),
	win_SetBrush(_Win,Brush),
	draw_Rect(_Win,RCT),
	fail.
  draw_picture_Data(_,_,_).

%BEGIN_WIN Task Window
/***************************************************************************
		Event handling for task window
***************************************************************************/

PREDICATES

  task_win_eh : EHANDLER

CONSTANTS

%BEGIN Task Window, CreateParms, 17:14:12-25.11.1999, Code automatically updated!
  task_win_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Close,wsf_Maximize,wsf_Minimize,wsf_ClipSiblings]
  task_win_Menu  = res_menu(idr_task_menu)
  task_win_Title = "Hanoi"
  task_win_Help  = idh_contents
%END Task Window, CreateParms

CLAUSES


%BEGIN Task Window, e_Create
  task_win_eh(_Win,e_Create(_),0):-!,
%BEGIN Task Window, ToolbarCreate, 17:14:12-25.11.1999, Code automatically updated!
%END Task Window, ToolbarCreate
IFDEF use_message
	msg_Create(100),
ENDDEF
	!.
%END Task Window, e_Create

%BEGIN Task Window, id_help_contents
IFDEF use_on_line_help
  task_win_eh(_Win,e_Menu(id_help_contents,_ShiftCtlAlt),0):-!,
  	vpi_ShowHelp("hanoi.hlp"),
	!.
ENDDEF
%END Task Window, id_help_contents

%BEGIN Task Window, id_help_about
  task_win_eh(_Win,e_Menu(id_help_about,_ShiftCtlAlt),0):-!,
	dlg_about_dialog_Create(_Win),
	!.
%END Task Window, id_help_about

%BEGIN Task Window, id_file_exit
  task_win_eh(_Win,e_Menu(id_file_exit,_ShiftCtlAlt),0):-
      check_destroy,!,
      asserta(stop),
      asserta(qq),
	!.
  task_win_eh(_Win,e_Menu(id_file_exit,_ShiftCtlAlt),0):-!,
	retractall(_,drpict),
	retractall(_,hanoidb),
	win_destroy(_Win),!.
%END Task Window, id_file_exit

%BEGIN Task Window, id_run
  task_win_eh(_Win,e_Menu(id_run,_ShiftCtlAlt),0):-
	check_destroy,!,
	asserta(stop),
	asserta(st_run),!.
%	run(_WIN),!.
 
  task_win_eh(_Win,e_Menu(id_run,_ShiftCtlAlt),0):-!,
	run(_WIN),!.
%END Task Window, id_run

%BEGIN Task Window, e_Timer
  task_win_eh(_Win,e_Timer(TimerID),0):-
      timer_id(TimerID),!,
 	retractall(timer_flag,drpict),
  	assert(timer_flag,drpict),
	!.
%END Task Window, e_Timer
  	
%BEGIN Task Window, e_Update
  task_win_eh(_Win,e_Update(_Rct),0):-!,
	win_Clear(_Win,color_White),
	is_Running,
	RCT=win_GetClientRect(_Win),
	RCT=rct(_,_,R,B),
	Right=R-15, Bottom=B-15,
	Center_Width=R div 2,
	Center_Height=B div 2,
	draw_DiagCrossGrid(_Win,Right,Bottom),
	hanoi(N),
	draw_YellowRect(_Win,N,Center_Width,Center_Height,_,_,RCT1),
	draw_BlackRect(_Win,RCT1),
	draw_picture_Data(_Win,Center_Width,Center_Height),
	!.
%END Task Window, e_Update
%BEGIN Task Window, id_set
  task_win_eh(_Win,e_Menu(id_set,_ShiftCtlAlt),0):-!,
	dlg_setting_Create(_Win),
	!.
%END Task Window, id_set
%BEGIN Task Window, e_CloseRequest
  task_win_eh(_Win,e_CloseRequest,0):-!,
	check_destroy,!,
	assert(stop),
	asserta(qq),
	!.
%END Task Window, e_CloseRequest
%MARK Task Window, new events
%BEGIN Task Window, e_Size
  task_win_eh(_Win,e_Size(_Width,_Height),0):-!,
IFDEF use_tbar
	toolbar_Resize(_Win),
ENDDEF
IFDEF use_message
	msg_Resize(_Win),
ENDDEF
	RCT=win_GetClientRect(_Win),
	win_Invalidate(_Win,RCT),!.
%END Task Window, e_Size

  task_win_eh(_Win,_,0):-!,fail.

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
	assert(hanoi(5)),
	assert(speed(2)),
	assert(forecolor(color_Yellow)),
  vpi_Init(task_win_Flags,task_win_eh,task_win_Menu,"hanoi",task_win_Title).

%END_WIN Task Window

%BEGIN_DLG About dialog
/**************************************************************************
        Creation and event handling for dialog: "About dialog"
	Code style: Single dialog
**************************************************************************/

CONSTANTS

%BEGIN About dialog, CreateParms, 17:14:08-25.11.1999, Code automatically updated!
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

%BEGIN About dialog, System handled events
  dlg_about_dialog_eh(_,_,0):-fail.
%END About dialog, System handled events
%END_DLG About dialog

%BEGIN_DLG Setting
/**************************************************************************
        Creation and event handling for dialog: "Setting"
	Code style: Dialog with PDC DlgPackage
**************************************************************************/

CONSTANTS

%BEGIN Setting, CreateParms, 17:14:04-25.11.1999, Code automatically updated!
  dlg_setting_ResID = idd_setting
  dlg_setting_DlgType = wd_Modal
  dlg_setting_Help = idh_contents
%END Setting, CreateParms

PREDICATES

  dlg_setting_eh : EHANDLER
  dlg_setting_update(DIALOG_VAL_LIST)

CLAUSES

  dlg_setting_Create(Parent):-
	hanoi(DISKS),
	speed(SPEED),
%MARK Setting, new variables
	dialog_Create(Parent,[resdlg(dlg_setting_ResID,dlg_setting_DlgType)],
  		[
%BEGIN Setting, ControlList, 17:14:04-25.11.1999, Code automatically updated!
		df(idc_set_1,editint(i(DISKS),[mandatory,default(5),range(2,10)]),str_prompt("No of disks")),
		df(idc_set_2,editint(i(Speed),[mandatory,default(2),range(0,4)]),str_prompt("Speed"))
%END Setting, ControlList
		],
		dlg_setting_eh,0,_VALLIST,_ANSWER),
		_ANSWER=idc_ok,
		dlg_setting_update(_VALLIST),
		TaskWin=vpi_GetTaskWin(),
		win_SendEvent(TaskWin,e_menu(id_run,c_Nothing)).

  dlg_setting_update(_VALLIST):-!,
%BEGIN Setting, Update controls, 17:14:04-25.11.1999, Code automatically updated!
	_IDC_SET_1_VALUE = dialog_VLGetint(idc_set_1,_VALLIST),
	_IDC_SET_2_VALUE = dialog_VLGetint(idc_set_2,_VALLIST),
%END Setting, Update controls
	_IDC_SET_1_VALUE=i(SET),SET>=2,SET<11,
	_IDC_SET_2_VALUE=i(SSS),SSS>=0,SSS<5,
	retractall(_,hanoidb),
	asserta(hanoi(SET)),
	asserta(speed(SSS)),!.
%MARK Setting, new events

  dlg_setting_update(_VALLIST).



%BEGIN Setting, idc_fore_color _CtlInfo
  dlg_setting_eh(_Win,e_Control(idc_fore_color,_CtrlType,_CtrlWin,_CtlInfo),0):-
	forecolor(InitCOLOR),!,
	_NewCOLOR = dlg_ChooseColor(InitCOLOR),
	retractall(forecolor(_)),
	asserta(forecolor(_NewCOLOR)),
	!.
%END Setting, idc_fore_color _CtlInfo


%BEGIN Setting, System handled events
  dlg_setting_eh(_,_,0):-fail.
%END Setting, System handled events
%END_DLG Setting



























