/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:  BBUILD
 FileName: Build.PRO
 Purpose: Demostrates using of the BUILD tool (VPI\INCLUDE\BUILD)
 Written by: Victor Yukhtenko
 Comments:
******************************************************************************/

include "buildEx.inc"
include "buildEx.con"
include "hlptopic.con"
include "PDCRUNT.PRE"
include "build\\build.pre"

DATABASE - user_interface
  single msg_win(Window)
  single err_win(Window)
  single edit_win(Window,STRING fileName)

DATABASE - compMsgStore
  single msg_Counter(UNSIGNED)
  bldDBint_msg(UNSIGNED repNo,STRING eORwSYM,INTEGER msgNo,UNSIGNED lineNo,UNSIGNED pos,STRING text)

DATABASE - options
  compilerOpt(STRING)
  fileOpt(STRING)
  linkerOpt(STRING)

DATABASE - executables
determ  exmplDB_ExeHandle(STRING fileName,LONG applicationID)
determ  exmplDB_DLLHandle(STRING fileName,LONG dllHandle)

/******************************************************
	MsgWin Handle
******************************************************/
PREDICATES
  exmpl_sendMsg(STRING text)
CLAUSES
  exmpl_sendMsg(""):-!.
  exmpl_sendMsg(Text):-
	msg_win(_Win),!,
	edit_AppendStr( _Win,Text).
  exmpl_sendMsg(_Text).

/******************************************************
  Build Tools Handling
******************************************************/
PREDICATES
  exmpl_MsgHandler : BldPD_Message
  exmpl_ErrorHandler: BldPD_CompErrAndWarn
  exmpl_Update: BldPD_Update
  nextNo(UNSIGNED)
  exmpl_BuildInit
nondeterm  exmpl_FormatReport(STRING)
  exmpl_ShowCompilerReport
  exmpl_Stop
  exmpl_Build(STRING compOpt,STRING linkOpt)
  exmpl_Compile(STRING compOpt)
  BOOLEAN exmpl_Link(STRING linkOpt)
  exmpl_SaveEditedText
  exmpl_Run(STRING LinkerArguments)
  exmpl_ForgetExecutable(LONG applicationId)
  exmpl_ExtractExecutable(STRING,STRING FileExt,STRING FileName)
  exmpl_FreeExecutable(STRING fileExt,STRING fileName)
  exmpl_FreeResources
CLAUSES

  msg_Counter(0).

  nextNo(OldNo):-
	msg_Counter(OldNo),!,
	NewNo=OldNo+1,
	assert(msg_Counter(NewNo)).
  nextNo(0).

  exmpl_BuildInit:-
	bldP_SetProperty(bldT_UpdateCB(exmpl_Update)),
	bldP_SetProperty(bldT_MessageCB(exmpl_MsgHandler)),
	bldP_SetProperty(bldT_CmpErrAndWarnCB(exmpl_ErrorHandler)).

  exmpl_MsgHandler(Text):-
	exmpl_sendMsg(Text).

  exmpl_ErrorHandler(EWsym,MsgNo,LineNo,Pos,Text):-
	nextNo(No),
  	assert(bldDBint_msg(No,EWsym,MsgNo,LineNo,Pos,Text)).

  exmpl_Update:-
  	vpi_ProcessEvents().

  exmpl_FormatReport(OutStr):-
	bldDBint_msg(_No,EWsym,_MsgNo,LineNo,Pos,Text),
	format(OutStr,"% Ln:% Pos:% ;%",EWsym,LineNo,Pos,Text).
	
  exmpl_ShowCompilerReport:-
	err_win(ErrWin),
	lbox_Clear(ErrWin),
	findall(Str,exmpl_FormatReport(Str),StrList),
	lbox_Add(ErrWin, StrList),
	lbox_SetTopIndex( ErrWin, 0 ),
	win_SetFocus(ErrWin).

  exmpl_Build(_CompilerOptions,_LinkOptions):-
	retractall(bldDBint_msg(_,_,_,_,_,_)),
	assert(msg_Counter(0)),
	fail.
  exmpl_Build(CompilerOptions,LinkOptions):-
  	exmpl_ExtractExecutable(LinkOptions,ExeType,FileName),
	exmpl_FreeExecutable(ExeType,FileName),
	exmpl_SaveEditedText,
	bldP_SetProperty(bldT_CmpFlags(CompilerOptions)),
	bldP_SetProperty(bldT_LnkFlags(LinkOptions)),
	exmpl_sendMsg("\nBuilding..."),
	BldResult = bldP_Build(),
	not(BldResult=b_False),!,
	exmpl_sendMsg("\nUnsuccessfull Build.").
  exmpl_Build(_CompilerOptions,_LinkOptions):-
	exmpl_sendMsg("\nDone Successfully.").

  exmpl_Compile(_CompilerOptions):-
	retractall(bldDBint_msg(_,_,_,_,_,_)),
	assert(msg_Counter(0)),
	fail.
  exmpl_Compile(CompilerOptions):-
	exmpl_SaveEditedText,
	CmpResult = bldP_CompileFile(CompilerOptions),
	not(CmpResult=b_False),!,
	exmpl_sendMsg("\nUnsuccessfull Compilation.").
  exmpl_Compile(_CompilerOptions):-
	exmpl_sendMsg("\nDone Successfully.").

  exmpl_Link(LinkOptions,b_True):-
  	exmpl_ExtractExecutable(LinkOptions,ExeType,FileName),
	exmpl_FreeExecutable(ExeType,FileName),
	exmpl_sendMsg("\nLinking..."),
	LnkResult = bldP_LinkTarget(LinkOptions),
	not(LnkResult=b_False),!,
	exmpl_sendMsg("\nUnsuccessfull Linking.").
  exmpl_Link(_LinkOptions,b_False):-
	exmpl_sendMsg("\nDone Successfully.").

  exmpl_Stop:-
  	bldP_Stop.

  exmpl_SaveEditedText:-
	NullWin=cast(window,0),
  	edit_win(EdWin,_FileName),
	not(EdWin=NullWin),!,
	win_SendEvent(EdWin,e_User(1,0)).
  exmpl_SaveEditedText.

  exmpl_FreeResources:-
	exmplDB_ExeHandle(_FileName,ApplicationId),
  	trap(vpi_CloseProcess( ApplicationId ),_E,fail),
	fail.	
  exmpl_FreeResources:-
	exmplDB_DllHandle(_FileName,DllHandle),
  	trap(vpi_FreeDll(DllHandle),_E,fail),
	fail.	
  exmpl_FreeResources.
 

DOMAINS
  ExmplPD_DllCall = procedure (STRING CarName,INTEGER Age, ULONG price, ULONG miles, BOOLEAN Result) - (i,i,i,i,o) language pascal
  ExmplPD_MemMarkGstack =  procedure (ULONG) - (o)  language pascal
  ExmplPD_MemReleaseGstack  = procedure (ULONG) - (i) language pascal

  
PREDICATES
  exmpl_RunExecutable(WINDOW,STRING FileExt,STRING FileName)
CLAUSES


  exmpl_ExtractExecutable(LinkArguments,ExtLower,FileName):-
	searchstring(LinkArguments,"-o",ExeKeyPosFound),
	ExeKeyPos=ExeKeyPosFound+1,
	frontstr(ExeKeyPos,LinkArguments,_,Rest),
	searchchar(Rest,' ',SpacePosFound),
	SpacePos=SpacePosFound-1,
	frontstr(SpacePos,Rest,FileName,_),
	filenameext(FileName,_Name,Ext),!,
	upper_lower(Ext,ExtLower).
  exmpl_ExtractExecutable(_LinkArguments,"","").

  exmpl_ForgetExecutable(ApplicationId):-
	exmpl_sendMsg("\n.EXE type application ended."),
  	retract(exmplDB_ExeHandle(_FileName,ApplicationId)),!.
  exmpl_ForgetExecutable(_ApplicationId).

  exmpl_RunExecutable(TaskWin,".exe",FileName):-
	ApplicationId=vpi_CreateProcess(TaskWin,FileName,"",wsf_Restored),!,
	assert(exmplDB_ExeHandle(FileName,ApplicationId)).

  exmpl_RunExecutable(_TaskWin,".dll",FileName):-
	DllHandle = vpi_LoadDll( FileName ),!,
  	assert(exmplDB_DllHandle(FileName,DllHandle)),

	TaskWin = vpi_GetTaskWin(),
        dlg_testdlg_Create(TaskWin).

  exmpl_RunExecutable(_TaskWin,_Any,_FileName):-
	exmpl_sendMsg("\n.DLL did not load ??.").

  exmpl_FreeExecutable(".exe",FileName):-
  	exmplDB_ExeHandle(FileName,ApplicationId),
  	retractall(exmplDB_ExeHandle(FileName,ApplicationId)),
  	trap(vpi_CloseProcess( ApplicationId ),_E,fail),
  	fail.

  exmpl_FreeExecutable(".dll",FileName):-
  	exmplDB_DllHandle(FileName,OldDllHandle),
  	retractall(exmplDB_DllHandle(FileName,OldDllHandle)),
  	trap(vpi_FreeDll(OldDllHandle),_E,fail),
  	fail.
  exmpl_FreeExecutable(_Any,_FileName).
	
  exmpl_Run(LinkArguments):-
  	exmpl_ExtractExecutable(LinkArguments,ExeType,FileName),
	exmpl_FreeExecutable(ExeType,FileName),
	TaskWin=cast(window,vpi_GetAttrVal(attr_task_window)),
	b_False=exmpl_Link(LinkArguments),
	exmpl_RunExecutable(TaskWin,ExeType,FileName),!.
  exmpl_Run(_LinkArguments).

%BEGIN_WIN Task Window
/***************************************************************************
	Event handling for Task Window
***************************************************************************/

PREDICATES

  task_win_eh : EHANDLER
CONSTANTS

%BEGIN Task Window, CreateParms, 11:11:36-24.11.1999, Code automatically updated!
  task_win_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Close,wsf_Maximize,wsf_Minimize,wsf_ClipSiblings,wsf_Maximized]
  task_win_Menu  = res_menu(idr_task_menu)
  task_win_Title = "Build Tool Example"
  task_win_Help  = idh_contents
%END Task Window, CreateParms

CLAUSES

%BEGIN Task Window, e_Create
  task_win_eh(_Win,e_Create(_),0):-!,
%BEGIN Task Window, InitControls, 11:11:36-24.11.1999, Code automatically updated!
%END Task Window, InitControls
%BEGIN Task Window, ToolbarCreate, 11:11:36-24.11.1999, Code automatically updated!
	tb_project_toolbar_Create(_Win),
	tb_help_line_Create(_Win),
%END Task Window, ToolbarCreate
IFDEF use_message
	msg_Create(100),
ENDDEF
	win_messagewin_Create(_Win),
	win_soft_software_Create(_Win),
	dlg_compile_and_link_options_Create(_Win),
	!.
%END Task Window, e_Create

%MARK Task Window, new events

%BEGIN Task Window, e_Destroy
  task_win_eh(_Win,e_Destroy,0):-!,
	class_Destroy("Soft Softwere"),
	class_Destroy("MessageWin"),
	fail.
%END Task Window, e_Destroy

%BEGIN Task Window, e_EndApplication
  task_win_eh(_Win,e_EndApplication(_ApplicationID),0):-!,
	exmpl_ForgetExecutable(_ApplicationID),
	!.
%END Task Window, e_EndApplication

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
PREDICATES
  exmplP_FindHelpFile(STRING)
CLAUSES
  exmplP_FindHelpFile("..\\EXE32"):-
  	disk(CurPathUp),
  	upper_lower(CurPathUp,CurPathLow),
  	searchstring(CurPAthLow,"exe16",_FoundPos),!.
  exmplP_FindHelpFile(CurPath):-
  	disk(CurPath).

  project_ShowHelpContext(HelpTopic):-
	exmplP_FindHelpFile(HelpFilePath),
	filenamepath(FullHelpFileName,HelpFilePath,"build.hlp"),
	trap(existfile(FullHelpFileName),_E,fail),!,
  	vpi_ShowHelpContext(FullHelpFileName,HelpTopic).
  project_ShowHelpContext(_HelpTopic):-
	dlg_Note("Please check whether <build.hlp> file have been built using build32.VPR").
	
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
  vpi_Init(task_win_Flags,task_win_eh,task_win_Menu,"buildex",task_win_Title).

%BEGIN_TLB Project toolbar, 11:12:00-24.11.1999, Code automatically updated!
/**************************************************************************
	Creation of toolbar: Project toolbar
**************************************************************************/

clauses

  tb_project_toolbar_Create(_Parent):-
ifdef use_tbar
	toolbar_create(tb_top,0xC0C0C0,_Parent,
		[tb_fctrl(11147,"id_file_new",pushb,"New file Up","New file Down","New file Up","New;New file",1,1),
		 tb_fctrl(24490,"id_file_open",pushb,"Open file Up","Open file Down","Open file Up","Open;Open file",1,1),
		 tb_fctrl(7752,"id_file_save",pushb,"Save file Up","Save file Down","Save file Up","Save;File save",1,1),
		 separator,
		 tb_fctrl(2588,"id_edit_undo",pushb,"Undo Up","Undo Down","Undo Up","Undo;Undo",1,1),
		 tb_fctrl(15296,"id_edit_redo",pushb,"Redo Up","Redo Down","Redo Up","Redo;Redo",1,1),
		 separator,
		 tb_fctrl(5126,"id_edit_cut",pushb,"Cut Up","Cut Down","Cut Up","Cut;Cut to clipboard",1,1),
		 tb_fctrl(9785,"id_edit_copy",pushb,"Copy Up","Copy Down","Copy Up","Copy;Copy to clipboard",1,1),
		 tb_fctrl(14708,"id_edit_paste",pushb,"Paste Up","Paste Down","Paste Up","Paste;Paste from clipboard",1,1),
		 separator,
		 separator,
		 tb_fctrl(1,"id_help_contents",pushb,"Help up","Help down","Help up","Help;Help",1,1)]),
enddef
	true.
%END_TLB Project toolbar


%BEGIN_TLB Help line, 11:12:06-24.11.1999, Code automatically updated!
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

%BEGIN About dialog, CreateParms, 19:58:42-24.11.1999, Code automatically updated!
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

%BEGIN_DLG Compile and Link Options
/**************************************************************************
	Creation and event handling for dialog: Compile and Link Options
**************************************************************************/

CONSTANTS

%BEGIN Compile and Link Options, CreateParms, 11:09:56-24.11.1999, Code automatically updated!
  dlg_compile_and_link_options_ResID = idd_compile_and_link_options
  dlg_compile_and_link_options_DlgType = wd_Modeless
  dlg_compile_and_link_options_Help = idh_contents
%END Compile and Link Options, CreateParms

PREDICATES

  dlg_compile_and_link_options_eh : EHANDLER
  dlg_compile_and_link_options_update(DIALOG_VAL_LIST)

CLAUSES
  err_win(~0).

  dlg_compile_and_link_options_Create(Parent):-

%MARK Compile and Link Options, new variables

	dialog_CreateModeless(Parent,dlg_compile_and_link_options_ResID,"",
  		[
%BEGIN Compile and Link Options, ControlList, 11:09:56-24.11.1999, Code automatically updated!
		df(idc_compiler_options,editstr("",[]),nopr),
		df(idc_link_options,editstr("",[]),nopr),
		df(idc_file_option,editstr("",[]),nopr),
		df(idc_errwin,listbox([],[0]),nopr)
%END Compile and Link Options, ControlList
		],
		dlg_compile_and_link_options_eh,0).

  dlg_compile_and_link_options_update(_VALLIST):-
%BEGIN Compile and Link Options, Update controls, 11:09:56-24.11.1999, Code automatically updated!
	_IDC_COMPILER_OPTIONS_VALUE = dialog_VLGetstr(idc_compiler_options,_VALLIST),
	_IDC_LINK_OPTIONS_VALUE = dialog_VLGetstr(idc_link_options,_VALLIST),
	_IDC_FILE_OPTION_VALUE = dialog_VLGetstr(idc_file_option,_VALLIST),
	dialog_VLGetListBox(idc_errwin,_VALLIST,_IDC_ERRWIN_ITEMLIST,_IDC_ERRWIN_SELECT),
%END Compile and Link Options, Update controls
	true.

%MARK Compile and Link Options, new events

%BEGIN Compile and Link Options, idc_run _CtlInfo
  dlg_compile_and_link_options_eh(_Win,e_Control(idc_run,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	LinkOptions = dialog_GetStr(_Win,idc_link_options),
	exmpl_Run(LinkOptions),
	!.
%END Compile and Link Options, idc_run _CtlInfo

%BEGIN Compile and Link Options, idc_pb_build _CtlInfo
  dlg_compile_and_link_options_eh(_Win,e_Control(idc_pb_build,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	CompilerOptions = dialog_GetStr(_Win,idc_compiler_options),
	LinkOptions = dialog_GetStr(_Win,idc_link_options),
	exmpl_Build(CompilerOptions,LinkOptions),
	exmpl_ShowCompilerReport,
	!.
%END Compile and Link Options, idc_pb_build _CtlInfo

%BEGIN Compile and Link Options, idc_pb_link _CtlInfo
  dlg_compile_and_link_options_eh(_Win,e_Control(idc_pb_link,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	LinkOptions = dialog_GetStr(_Win,idc_link_options),
	exmpl_Link(LinkOptions),
	!.
%END Compile and Link Options, idc_pb_link _CtlInfo

%BEGIN Compile and Link Options, idc_pb_compiile _CtlInfo
  dlg_compile_and_link_options_eh(_Win,e_Control(idc_pb_compile,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	CompilerOptions = dialog_GetStr(_Win,idc_compiler_options),
	exmpl_Compile(CompilerOptions),
	exmpl_ShowCompilerReport,
	!.
%END Compile and Link Options, idc_pb_compiile _CtlInfo

%BEGIN Compile and Link Options, idc_help _CtlInfo
  dlg_compile_and_link_options_eh(_Win,e_Control(idc_help,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	project_ShowHelpContext(dlg_compile_and_link_options_Help),
	!.
%END Compile and Link Options, idc_help _CtlInfo

%BEGIN Compile and Link Options, idc_about _CtlInfo
  dlg_compile_and_link_options_eh(_Win,e_Control(idc_about,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	dlg_about_dialog_Create(_Win),
	!.
%END Compile and Link Options, idc_about _CtlInfo

%BEGIN Compile and Link Options, idc_stop _CtlInfo
  dlg_compile_and_link_options_eh(_Win,e_Control(idc_stop,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	exmpl_Stop,
	!.
%END Compile and Link Options, idc_stop _CtlInfo

%BEGIN Compile and Link Options, idc_errwin selchanged
  dlg_compile_and_link_options_eh(_Win,e_Control(idc_errwin,_CtrlType,_CtrlWin,selchanged),0):-
	NullWin=cast(window,0),
	edit_win(Ed_Win,_FileName),
	not(Ed_Win=NullWin),!,
	Index = lbox_GetSelIndex(_CtrlWin),
	bldDBint_msg(Index,_EWsym,_MsgNo,_LineNo,Pos,_Text),!,
	Result=edit_GotoPos( Ed_Win, Pos ),
	not(Result=b_True),
	exmpl_sendMsg("\nThe position is out of text size.").
  dlg_compile_and_link_options_eh(_Win,e_Control(idc_errwin,_CtrlType,_CtrlWin,selchanged),0):-!,
	Index = lbox_GetSelIndex(_CtrlWin),
	bldDBint_msg(Index,_EWsym,_MsgNo,_LineNo,Pos,_Text),
	win_text_editor_Create(_Win),
	edit_win(Ed_Win,_FileName),
	Result=edit_GotoPos( Ed_Win, Pos ),
	not(Result=b_True),
	exmpl_sendMsg("\nThe position is out of text size."),
	!.
%END Compile and Link Options, idc_errwin selchanged

%BEGIN Compile and Link Options, idc_errwin activated
  dlg_compile_and_link_options_eh(_Win,e_Control(idc_errwin,_CtrlType,_CtrlWin,activated),0):-!,
	Index = lbox_GetSelIndex(_CtrlWin),
	bldDBint_msg(Index,_EWsym,_MsgNo,_LineNo,Pos,_Text),
	win_text_editor_Create(_Win),
	edit_win(Ed_Win,_FileName),
	Result=edit_GotoPos( Ed_Win, Pos ),
	not(Result=b_True),
	exmpl_sendMsg("\nThe position is out of file size."),
	!.
%END Compile and Link Options, idc_errwin activated

%BEGIN Compile and Link Options, idc_edit _CtlInfo
  dlg_compile_and_link_options_eh(_Win,e_Control(idc_edit,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	win_text_editor_Create(_Win),
	!.
%END Compile and Link Options, idc_edit _CtlInfo

%BEGIN Compile and Link Options, idc_brows _CtlInfo
  dlg_compile_and_link_options_eh(_Win,e_Control(idc_brows,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	disk(Disk),
	Filename=dlg_GetOpenFileName("*.pro",["*.pro","*.pro","*.*","*.*"],"Load the File"),
	disk(Disk),
	not(Filename = ""),
	dialog_SetFields(_Win, 
		[
		df(idc_file_option,editstr(Filename,[]),nopr)
		]),
	!.
%END Compile and Link Options, idc_brows _CtlInfo

%BEGIN Compile and Link Options, e_Create
  dlg_compile_and_link_options_eh(_Win,e_Create(_CreationData),0):-!,
	exmpl_BuildInit,
	CtrlWin = win_GetCtlHandle(_Win, idc_errwin),
	assert(err_win(CtrlWin)),
	retractall(_,options),
	DefaultFileName="default.opt",
	consult(DefaultFileName,options),
	compilerOpt(CompilerOpt),
	fileOpt(FileOpt),
	linkerOpt(LinkerrOpt),
	dialog_SetFields(_Win, 
		[
		df(idc_compiler_options,editstr(CompilerOpt,[]),nopr),
		df(idc_link_options,editstr(LinkerrOpt,[]),nopr),
		df(idc_file_option,editstr(FileOpt,[]),nopr)
		]),
	!.
%END Compile and Link Options, e_Create

%BEGIN Compile and Link Options, idc_exit _CtlInfo
  dlg_compile_and_link_options_eh(_Win,e_Control(idc_exit,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	win_Destroy(_Win),
	!.
%END Compile and Link Options, idc_exit _CtlInfo

%BEGIN Compile and Link Options, idc_default_options _CtlInfo
  dlg_compile_and_link_options_eh(_Win,e_Control(idc_default_options,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	retractall(_,options),
	DefaultFileName=dlg_GetOpenFileName("*.opt",["*.opt","*.opt","*.*","*.*"],"Load Build Settings"),
	not(DefaultFileName = ""),
	consult(DefaultFileName,options),
	compilerOpt(CompilerOpt),
	fileOpt(FileOpt),
	linkerOpt(LinkerrOpt),
	dialog_SetFields(_Win, 
		[
		df(idc_compiler_options,editstr(CompilerOpt,[]),nopr),
		df(idc_link_options,editstr(LinkerrOpt,[]),nopr),
		df(idc_file_option,editstr(FileOpt,[]),nopr)
		]),
	!.

%END Compile and Link Options, idc_default_options _CtlInfo


%BEGIN Compile and Link Options, e_Destroy
  dlg_compile_and_link_options_eh(_Win,e_Destroy,0):-!,
	exmpl_FreeResources,
	TaskWinAttr=vpi_GetAttrVal(attr_task_window),
	TaskWin=cast(window,TaskWinAttr),
	win_PostEvent(TaskWin,e_CloseRequest),
	fail.
	
%END Compile and Link Options, e_Destroy

  dlg_compile_and_link_options_eh(_,_,_):-!,fail.

%END_DLG Compile and Link Options



%BEGIN_WIN Soft Software
/**************************************************************************
	Creation and event handling for class: "Soft Software"
**************************************************************************/

CONSTANTS

%BEGIN Soft Software, CreateParms, 11:11:22-24.11.1999, Code automatically updated!
  win_soft_software_ClassName = "Soft Software"
  win_soft_software_Help = idh_contents
%END Soft Software, CreateParms

PREDICATES

  win_soft_software_eh : EHANDLER

CLAUSES

  win_soft_software_Create(_Parent):-
	class_Create(win_soft_software_ClassName,win_soft_software_eh).

%BEGIN Soft Software, e_Create
  win_soft_software_eh(_Win,e_Create(_),0):-!,
%BEGIN Soft Software, InitControls, 11:11:22-24.11.1999, Code automatically updated!
%END Soft Software, InitControls
	!.
%END Soft Software, e_Create
%MARK Soft Software, new events

%BEGIN Soft Software, e_Update
  win_soft_software_eh(_Win,e_Update(_UpdateRct),0):-!,
	Pict =pict_Load("..\\..\\..\\..\\bin\\win\\prolog.bmp"),
	pict_GetSize(PICT, Xsrc, Ysrc, _Size),X=Xsrc,Y=Ysrc-130,
	CustomWinRCT=win_GetClientRect(_Win),
	pict_Draw(_Win,PICT,CustomWinRCT,rct(2,2,X,Y),rop_SrcCopy),
	!.
%END Soft Software, e_Update

%BEGIN Soft Software, e_Menu, Parent window 
  win_soft_software_eh(Win,e_Menu(ID,CAS),0):-!,
	PARENT = win_GetParent(Win),
	win_SendEvent(PARENT,e_Menu(ID,CAS)),
	!.
%END Soft Software, e_Menu, Parent window

%END_WIN Soft Software

%BEGIN_WIN MessageWin
/**************************************************************************
	Creation and event handling for class: "MessageWin"
**************************************************************************/

CONSTANTS

%BEGIN MessageWin, CreateParms, 11:11:08-24.11.1999, Code automatically updated!
  win_messagewin_ClassName = "MessageWin"
  win_messagewin_Help = idh_contents
%END MessageWin, CreateParms

PREDICATES

  win_messagewin_eh : EHANDLER
  msg_handler : EHANDLER

CONSTANTS
  ctrlX = 24
  ctrlC = 3
  ctrlV = 22

CLAUSES

  msg_win(~0).

  msg_handler (_Win,e_Char(ctrlX,_),0 ) :-
	edit_Cut(_Win),!.
  msg_handler (_Win,e_Char(ctrlC,_),0 ) :-
	edit_Copy(_Win),!.
  msg_handler (_Win,e_Char(ctrlV,_),0 ) :-
	edit_Paste(_Win),!.
  msg_handler ( W, e_MouseDown ( _, _, _ ), 0 ) :- !, 
	win_SetFocus ( W ), fail.

  win_messagewin_Create(_Parent):-
	class_Create(win_messagewin_ClassName,win_messagewin_eh).

%BEGIN MessageWin, e_Create
  win_messagewin_eh(_Win,e_Create(_),0):-!,
	assert(msg_win(_Win)),
%BEGIN MessageWin, InitControls, 11:11:08-24.11.1999, Code automatically updated!
%END MessageWin, InitControls
	Font = font_Create ( ff_Times, [], 8 ),
	TEXT="\nHello Dear User! Welcome to the BUILD tool example!",
	edit_CreateSubClass ( _Win, "*.txt", Font, b_True, b_true, b_false,Text, 1, msg_handler ),
	!.
%END MessageWin, e_Create
%MARK MessageWin, new events


%BEGIN MessageWin, e_Menu, Parent window 
  win_messagewin_eh(Win,e_Menu(ID,CAS),0):-!,
	PARENT = win_GetParent(Win),
	win_SendEvent(PARENT,e_Menu(ID,CAS)),
	!.
%END MessageWin, e_Menu, Parent window

%END_WIN MessageWin

%BEGIN_WIN Text Editor
/**************************************************************************
	Creation and event handling for window: "Text Editor"
**************************************************************************/

CONSTANTS

%BEGIN Text Editor, CreateParms, 11:10:40-24.11.1999, Code automatically updated!
  win_text_editor_WinType = w_TopLevel
  win_text_editor_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Maximize,wsf_Minimize,wsf_Close,wsf_ClipSiblings]
  win_text_editor_RCT = rct(30,30,370,190)
  win_text_editor_Menu = no_menu
  win_text_editor_Title = "Source Prolog File Editor"
  win_text_editor_Help = idh_contents
%END Text Editor, CreateParms

PREDICATES

  win_text_editor_eh : EHANDLER
  determ handle_Answer(INTEGER responce,WINDOW,STRING fileName)

CLAUSES
  edit_win(~0,"").

  handle_Answer(resp_default,_Win,FileName):-
	Text = edit_GetText(_Win),
	format(MSG1,"Can not save file %s. Cancelled.",FileName),
	trap(file_str(FileName,Text),_E,dlg_Error(MSG1)),
	NullWin=cast(window,0),
	assert(edit_win(NullWin,"")),!,fail.
  handle_Answer(resp_2,_Win,_FileName):-
	NullWin=cast(window,0),
	assert(edit_win(NullWin,"")),
	!,fail.
  handle_Answer(resp_3,_Win,_FileName).

  win_text_editor_Create(_Parent):-
	FileName=dialog_GetStr(_Parent,idc_file_option),	
  	edit_win(Win,FileName),
	NullWin=cast(window,0),
  	not(Win=NullWin),!,
  	win_SetFocus(Win).
  win_text_editor_Create(_Parent):-
	FileName=dialog_GetStr(_Parent,idc_file_option),	
  	edit_win(Win,OptFileName),
  	not(FileName=OptFileName),
	NullWin=cast(window,0),
  	not(Win=NullWin),
	trap(existfile(FileName),_E,dlg_Error("Can not find the specified file!")),!,
  	file_str(FileName,Text),
  	assert(edit_win(Win,FileName)),
  	edit_PasteStr(Win,Text),
  	win_SetFocus(Win).
  win_text_editor_Create(_Parent):-
	FileName=dialog_GetStr(_Parent,idc_file_option),
	trap(existfile(FileName),_E,dlg_Error("Can not find the specified file!")),!,
  	file_str(FileName,Text),
	ScreenWin=cast(window,vpi_GetAttrVal(attr_task_window)),
IFDEF use_editor
	Font = font_Create(ff_Fixed,[],10),
	ReadOnly = b_false, Indent = b_true, InitPos = 1,
	Win=edit_Create(win_text_editor_WinType,win_text_editor_RCT,win_text_editor_Title,
		 win_text_editor_Menu,ScreenWin,win_text_editor_Flags,Font,ReadOnly,
		 Indent,Text,InitPos,win_text_editor_eh),
	edit_SetColoring(Win, edit_ftype_pro),
ENDDEF
	assert(edit_win(Win,FileName)),
	true.
  win_text_editor_Create(_Parent).

%BEGIN Text Editor, e_Create
  win_text_editor_eh(_Win,e_Create(_),0):-!,
%BEGIN Text Editor, InitControls, 11:10:40-24.11.1999, Code automatically updated!
%END Text Editor, InitControls
%BEGIN Text Editor, ToolbarCreate, 11:10:40-24.11.1999, Code automatically updated!
%END Text Editor, ToolbarCreate
	!.
%END Text Editor, e_Create

%BEGIN Text Editor, e_Menu, Editor default popup menu 
  win_text_editor_eh(_Win,e_Menu(ID,_CAS),0):-
	ID >= edit_MenuUndo, ID <= edit_MenuFont, 
	!,fail.
%END Text Editor, e_Menu, Editor default popup menu
%MARK Text Editor, new events

%BEGIN Text Editor, e_User
  win_text_editor_eh(_Win,e_User(1,_Ptr),0):-
	b_True = edit_IsModified( _Win ),
	edit_win(_Win,FileName),
	Text = edit_GetText(_Win),
	format(MSG1,"Can not save Editor's content in file %s. Compiling source on disk.",FileName),
	trap(file_str(FileName,Text),_E,dlg_Error(MSG1)),
	edit_ClearModified( _Win ),
	!.
%END Text Editor, e_User

%BEGIN Text Editor, e_CloseRequest
  win_text_editor_eh(_Win,e_CloseRequest,0):-
	b_True = edit_IsModified( _Win ),!,
	edit_win(_Win,FileName),
	format(MSG,"The content have been modifyed. Do you want to save conent in file %s?",FileName),
	Answer = dlg_Ask( MSG, ["OK","No","Cancel"] ),
	handle_Answer(Answer,_Win,FileName).
  win_text_editor_eh(_Win,e_CloseRequest,0):-
	NullWin=cast(window,0),
	assert(edit_win(NullWin,"")),
	fail.
  
%END Text Editor, e_CloseRequest

%BEGIN Text Editor, e_Size
  win_text_editor_eh(_Win,e_Size(_Width,_Height),0):-!,
IFDEF use_tbar
	toolbar_Resize(_Win),
ENDDEF
	!.
%END Text Editor, e_Size

%BEGIN Text Editor, e_Menu, Parent window 
  win_text_editor_eh(Win,e_Menu(ID,CAS),0):-!,
	PARENT = win_GetParent(Win),
	win_SendEvent(PARENT,e_Menu(ID,CAS)),
	!.
%END Text Editor, e_Menu, Parent window

%END_WIN Text Editor

/******************************************************
   Call the .DLL and Check the Values
******************************************************/
PREDICATES
  Test_Check(WINDOW,STRING Name,INTEGER Year,LONG Price,LONG Miles)
  procedure showResult(INTEGER)
CLAUSES
  Test_Check(_Win,CarName,Year,Price,Miles):-
	exmplDB_DllHandle(_,DllHandle),!,
	CheckProcCall = cast(exmplPD_DllCall,vpi_GetDllProc( DllHandle, "CHECK_CAR" )),
	Dll_mem_MarkGstack = cast(exmplPD_MemMarkGstack,vpi_GetDllProc( DllHandle, "DLL_MARKGSTACK" )),
	Dll_mem_ReleaseGstack = cast(exmplPD_MemReleaseGstack,vpi_GetDllProc( DllHandle, "DLL_RELEASEGSTACK" )),

	Dll_mem_MarkGstack(GTOP),
	CheckProcCall(CarName,Year,Price,Miles,Result),
	showResult(Result),
	Dll_mem_ReleaseGstack(GTOP).
  Test_Check(_Win,_,_,_,_):-errorexit().

  showResult(1):-!,
	dlg_Note("Yes, This sounds interesting").
  showResult(_):-
	dlg_Note("No, This is not interesting").



%BEGIN_DLG testdlg
/**************************************************************************
	Creation and event handling for dialog: testdlg
**************************************************************************/

CONSTANTS

%BEGIN testdlg, CreateParms, 11:09:22-24.11.1999, Code automatically updated!
  dlg_testdlg_ResID = idd_testdlg
  dlg_testdlg_DlgType = wd_Modal
  dlg_testdlg_Help = idh_contents
%END testdlg, CreateParms

PREDICATES
  dlg_testdlg_eh : EHANDLER

CLAUSES

  dlg_testdlg_Create(Parent):-

%MARK testdlg, new variables

	dialog_CreateModal(Parent,dlg_testdlg_ResID,"",
  		[
%BEGIN testdlg, ControlList, 11:09:22-24.11.1999, Code automatically updated!
		df(idc_name,editstr("Volvo",[]),nopr),
		df(idc_miles,editlong(l(5000),[default(0)]),nopr),
		df(idc_year,editint(i(1993),[default(0),range(0,2010)]),nopr),
		df(idc_price,editlong(l(3500),[]),nopr)
%END testdlg, ControlList
		],
		dlg_testdlg_eh,0,_VALLIST,_ANSWER).


%MARK testdlg, new events

%BEGIN testdlg, idc_check _CtlInfo
  dlg_testdlg_eh(_Win,e_Control(idc_check,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	CarName = dialog_Getstr(_Win,idc_name),
	_IDC_MILES_VALUE = dialog_Getlong(_Win,idc_miles),_IDC_MILES_VALUE = l(MILES),
	_IDC_YEAR_VALUE = dialog_Getint(_Win,idc_year),_IDC_YEAR_VALUE = i(Year),
	_IDC_PRICE_VALUE = dialog_Getlong(_Win,idc_price),_IDC_PRICE_VALUE = l(PRICE),
	Test_Check(_Win,CarName,Year,Price,Miles),
	!.
%END testdlg, idc_check _CtlInfo

  dlg_testdlg_eh(_,_,_):-!,fail.

%END_DLG testdlg




















