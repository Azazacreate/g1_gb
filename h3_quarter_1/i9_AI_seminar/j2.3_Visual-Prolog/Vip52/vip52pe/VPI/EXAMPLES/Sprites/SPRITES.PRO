/*****************************************************************************

		Copyright (c)  1986,98 Gregory Bourassa Computer Engineering

 Project:  SPRITES
 FileName: SPRITES.PRO
 Purpose: Demo of Sprite Code in VPI
 Written by: Gregory Bourassa
 Comments:
******************************************************************************/

include "sprites.inc"
include "sprites.con"
include "hlptopic.con"

DATABASE - spriteDb

  background( window, picture )
  sprite( string, picture, picture )  %IDString, Bitmap, Mask

%BUILD A SPRITE FROM TWO BITMAPS
% These bitmaps are identical except for the background colours,
% one of which is white and the other black

PREDICATES
  make_sprite_frame( string, picture, picture, spriteDb )

CLAUSES
  make_sprite_frame( ID, Picture, Picture2, sprite( ID, Picture, Mask ) ) :-
	WinLong = vpi_GetAttrVal( attr_task_window ),
	_Win = cast(window, WinLong ),
	pict_Draw( _Win, Picture, pnt(0,0), rop_SrcCopy),
	pict_Draw( _Win, Picture2, pnt(0,0), rop_SrcInvert ),
	pict_GetSize( Picture, Width, Height, _ ),
	WdLessOne = Width - 1,
	HtLessOne = Height - 1,
	Mask = pict_GetFromWin( _Win, rct(0,0,WdLessOne,HtLessOne)),
	!.

% MOVE A SPRITE OVER A BACKGROUND
% This version is pretty hard-coded in terms of spatial movement
% The general notion is 
%    1) to get the background for the whole area
%       covered by the old position and the new position,
%    2) make this the background of an invisible pict_window
%    3) draw the sprite mask in the new position so as to
%       "punch a black hole" in the background using ROPs
%    4) draw the black-backgrounded sprite bitmap onto this
%       same position so as to fill the black hole only

PREDICATES
  move_sprite_from_to( window, spriteDb, pnt, pnt )

CLAUSES
  move_sprite_from_to( Hwnd, sprite( _, Bitmap, Mask ), pnt(OldX,OldY), pnt(NewX,NewY) ) :-
	background( Hwnd, BackGroundPicture ),
	pict_GetSize( Bitmap, Cx, Cy, _ ),

	OldBRX = OldX + Cx,
	OldBRY = OldY + Cy,
	NewBRX = NewX + Cx,
	NewBRY = NewY + Cy,
	OldRect = rct(OldX,OldY,OldBRX,OldBRY ),
	NewRect = rct(NewX,NewY,NewBRX,NewBRY),
   
	WholeRect = rect_Union( OldRect,NewRect ),
	WholeRect = rct(TLX,TLY,BRX,BRY),
	WholeCx = BRX - TLX,
	WholeCy = BRY - TLY,
	PictWinRect = rct(0,0,WholeCx,WholeCy),
    
	YDist = NewY - OldY, %Only works for down motion
    
	PictWin = pict_Open( PictWinRect ),
	pict_Draw( PictWin, BackGroundPicture, PictWinRect, WholeRect, rop_SrcCopy ),
	pict_Draw( PictWin, Mask, pnt(0,YDist), rop_SrcAnd ),
	pict_Draw( PictWin, Bitmap, pnt(0,YDist), rop_SrcPaint ),
	TheSprite = pict_Close( PictWin ),
	pict_Draw( Hwnd, TheSprite, pnt(NewX,OldY), rop_SrcCopy ), %Only works for down left
	pict_Destroy( TheSprite ),
	fail.
  move_sprite_from_to( _, _, _, _).
    

%BEGIN_WIN Task Window
/***************************************************************************
	Event handling for Task Window
***************************************************************************/

PREDICATES

  task_win_eh : EHANDLER

CONSTANTS

%BEGIN Task Window, CreateParms, 14:14:34-24.11.1999, Code automatically updated!
  task_win_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Close,wsf_Maximize,wsf_Minimize,wsf_ClipSiblings]
  task_win_Menu  = res_menu(idr_task_menu)
  task_win_Title = "Sprites"
  task_win_Help  = idh_contents
%END Task Window, CreateParms

CLAUSES

%BEGIN Task Window, e_Create
  task_win_eh(_Win,e_Create(_),0):-!,
%BEGIN Task Window, InitControls, 14:14:34-24.11.1999, Code automatically updated!
%END Task Window, InitControls
%BEGIN Task Window, ToolbarCreate, 14:14:34-24.11.1999, Code automatically updated!
%END Task Window, ToolbarCreate
IFDEF use_message
	msg_Create(100),
ENDDEF
	!.
%END Task Window, e_Create

%MARK Task Window, new events

%BEGIN Task Window, id_Process_move_sprite
  task_win_eh(_Win,e_Menu(id_Process_move_sprite,_ShiftCtlAlt),0):-
	sprite("THE_SPRITE",Bmp,Mask),
	TheSprite = sprite("THE_SPRITE",Bmp,Mask),
	move_sprite_from_to( _Win, TheSprite, pnt(400,100), pnt(375,125)),
	move_sprite_from_to( _Win, TheSprite, pnt(375,125), pnt(350,150)),
	move_sprite_from_to( _Win, TheSprite, pnt(350,150), pnt(325,175)),
	move_sprite_from_to( _Win, TheSprite, pnt(325,175), pnt(300,200)),
	move_sprite_from_to( _Win, TheSprite, pnt(300,200), pnt(275,225)),
	move_sprite_from_to( _Win, TheSprite, pnt(275,225), pnt(250,250)),
	move_sprite_from_to( _Win, TheSprite, pnt(250,250), pnt(225,275)),
	move_sprite_from_to( _Win, TheSprite, pnt(225,275), pnt(200,300)),
	move_sprite_from_to( _Win, TheSprite, pnt(200,300), pnt(175,325)),
	!.
%END Task Window, id_Process_move_sprite

%BEGIN Task Window, e_Update
  task_win_eh(_Win,e_Update(_UpdateRct),0):-
	background( _Win, Picture ),
	!,
	pict_Draw( _Win,Picture, pnt(0,0), rop_SrcCopy ).

  task_win_eh(_Win,e_Update(_UpdateRct),0):-
	Picture = pict_GetFromRes( idb_background ),
	pict_Draw( _Win,Picture, pnt(0,0), rop_SrcCopy ),
	assert( background( _Win, Picture )),
	!.
%END Task Window, e_Update

%BEGIN Task Window, id_Process_build_sprite
  task_win_eh(_Win,e_Menu(id_Process_build_sprite,_ShiftCtlAlt),0):-
	BlackBGNDPic = pict_GetFromRes( idb_black_bckgnd_source ),
	WhiteBGNDPic = pict_GetFromRes( idb_white_bckgnd_source ),
	make_sprite_frame( "THE_SPRITE", BlackBGNDPic, WhiteBGNDPic, TheSprite ),
	retractall( sprite("THE_SPRITE",_,_)),
	assert(TheSprite),
	menu_Enable(_Win,id_Process_move_sprite,b_true),
	menu_Enable(_Win,id_Process_build_sprite,b_false),
	!.
%END Task Window, id_Process_build_sprite

%BEGIN Task Window, id_help_contents
  task_win_eh(_Win,e_Menu(id_help_contents,_ShiftCtlAlt),0):-!,
ifdef platform_16bit
  	vpi_ShowHelp("sprt_w16.hlp"),
elsedef
  	vpi_ShowHelp("sprites.hlp"),
enddef
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
ifdef platform_16bit
  	vpi_ShowHelpContext("sprt_w16.hlp",HelpTopic).
elsedef
  	vpi_ShowHelpContext("sprites.hlp",HelpTopic).
enddef
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
  vpi_Init(task_win_Flags,task_win_eh,task_win_Menu,"sprites",task_win_Title).

%BEGIN_DLG About dialog
/**************************************************************************
	Creation and event handling for dialog: About dialog
**************************************************************************/

CONSTANTS

%BEGIN About dialog, CreateParms, 14:14:30-24.11.1999, Code automatically updated!
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



















