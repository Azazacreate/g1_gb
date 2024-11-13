/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S 

 Project:  Build
 FileName: COMPILE.PRO
 Purpose: Supports the runtime Build process using PDC Prolog Compiler
 	  and PDC Link
 Written by: Victor Yukhtenko
 Comments:
******************************************************************************/
ifndef bldC_PRE_file
  #Error: file vpi\include\build\build.Pre must be included
enddef

global predicates

% --- PDC Prolog Compiler support
  UNSIGNED CompileFile(STRING Options,BROWSINFO_CALLBK,ERR_REP_FNS,CompProcessEvent,BldPD_Message,INTEGER) - (i,i,i,i,i,i) language c as "_PASS_ExpandAndCompile"

% --- PDC Linker support
  INTEGER LinkTarget(STRING linkArguments,BldPD_Message,BldPD_Message Lnk_ErrorOutput,CompProcessEvent) - (i,i,i,i) language C as "_LnkMainS"

database - status
  single bldDB_CmpStatus(BOOLEAN b_TrueIfRunning)
  single bldDB_LnkStatus(BOOLEAN b_TrueIfRunning)

  determ bldDB_CompilerStop
  determ bldDB_LinkerStop

database - properties
  single bldDB_UpdateCB(BldPD_Update)
  single bldDB_MessageCB(BldPD_Message)
  single bldDB_CmpeANDwCB(BldPD_CompErrAndWarn)
  single bldDB_CmpFlags(STRING)
  single bldDB_LnkFlags(STRING)
 
predicates
%--- Native compilers callbacks
  cmpCB_BrowseInfo: BROWSINFO_CALLBK
  cmpCB_ErrAndWarn: ERR_REP_FNS
  cmpCB_ProcessEvent: CompProcessEvent
  lnkCB_ProcessEvent: CompProcessEvent
%--- Build Tool default callbacks
  bldPint_UpdateCB: BldPD_Update
  bldPint_CmpErrAndWarnCB:BldPD_CompErrAndWarn
  bldPint_MessageCB:BldPD_Message

clauses % initial databse and errANDwarn callback status

  bldDB_CmpStatus(b_False).
  bldDB_LnkStatus(b_False).

  bldDB_UpdateCB(bldPint_UpdateCB).
  bldDB_MessageCB(bldPint_MessageCB).

  bldDB_CmpeANDwCB(bldPint_CmpErrAndWarnCB).
  bldDB_CmpFlags("").
  bldDB_LnkFlags("").

clauses % default silent internal callbacks
%--- native compiler's callbacks
  cmpCB_BrowseInfo(_COMPINFO).
%--- Build Tool default callbacks
  bldPint_UpdateCB().
  bldPint_CmpErrAndWarnCB(_ErrOrWarn,_MsgNo,_LineNo,_Pos,_CommentText).
  bldPint_MessageCB(_StrMessage).
clauses

  bldP_SetProperty(bldT_UpdateCB(UpdateCB)):-!,
	assert(bldDB_UpdateCB(UpdateCB)).
  bldP_SetProperty(bldT_MessageCB(MessageCB)):-!,
	assert(bldDB_MessageCB(MessageCB)).
  bldP_SetProperty(bldT_CmpErrAndWarnCB(CompErrAndWarnCB)):-!,
	assert(bldDB_CmpeANDwCB(CompErrAndWarnCB)).

  bldP_SetProperty(bldT_CmpFlags(Argument)):-!,
	assert(bldDB_CmpFlags(Argument)).
  bldP_SetProperty(bldT_LnkFlags(Argument)):-!,
	assert(bldDB_LnkFlags(Argument)).

  bldP_SetProperty(bldT_Default()):-!,
	assert(bldDB_UpdateCB(bldPint_UpdateCB)),
	assert(bldDB_MessageCB(bldPint_MessageCB)),
	assert(bldDB_CmpeANDwCB(bldPint_CmpErrAndWarnCB)),
	assert(bldDB_CmpFlags("")),
	assert(bldDB_LnkFlags("")).
  bldP_SetProperty(_Any):-errorexit().
	
predicates
determ bldPint_IsCmpAccessable
determ bldPint_IsLnkAccessable

clauses
  bldPint_IsCmpAccessable:-
	bldDB_CmpStatus(b_False),!.
  bldPint_IsCmpAccessable:-
  	errorexit(bldC_ERR_CmpRunning).

  bldPint_IsLnkAccessable:-
	bldDB_LnkStatus(b_False),!.
  bldPint_IsLnkAccessable:-
  	errorexit(bldC_ERR_LnkRunning).

  bldP_CompileFile(CompArgument,CompResult):-
	bldDB_UpdateCB(UpdateCB),
	bldDB_CmpeANDwCB(CompErrAndWarnCB),
	bldDB_MessageCB(MessageCB),!,
	CompResult=bldP_CompileFile(CompArgument,UpdateCB,CompErrAndWarnCB,MessageCB).
  bldP_CompileFile(_CompArgument,b_True):-errorexit().

  bldP_CompileFile(Argument,UpdateCB,CompErrAndWarnCB,MessageCB,Result):-
	bldPint_IsCmpAccessable,
	assert(bldDB_CmpeANDwCB(CompErrAndWarnCB)),
	assert(bldDB_UpdateCB(UpdateCB)),
	assert(bldDB_MessageCB(MessageCB)),
	retractall(bldDB_CompilerStop),
	assert(bldDB_CmpStatus(b_True)),
	ResultUns = compileFile(Argument,cmpCB_BrowseInfo,cmpCB_ErrAndWarn,cmpCB_ProcessEvent,MessageCB,0),
	Result=val(integer,ResultUns),
	assert(bldDB_CmpStatus(b_False)),
	!.
  bldP_CompileFile(_Argument,_UpdateCB,_CompErrAndWarnCB,_MessageCB,b_True):-errorexit().

  bldP_LinkTarget(LnkArgument,Result):-
	bldDB_UpdateCB(UpdateCB),
	bldDB_MessageCB(MessageCB),
	Result=bldP_LinkTarget(LnkArgument,UpdateCB,MessageCB),!.
  bldP_LinkTarget(_LnkArgument,b_True):-errorexit().

  bldP_LinkTarget(Argument,UpdateCB,MessageCB, Result):-
	bldPint_IsLnkAccessable,
	assert(bldDB_UpdateCB(UpdateCB)),
	assert(bldDB_MessageCB(MessageCB)),
	retractall(bldDB_LinkerStop),
	assert(bldDB_LnkStatus(b_True)),
  	Result=linkTarget(Argument,MessageCB,MessageCB,lnkCB_ProcessEvent),
	assert(bldDB_LnkStatus(b_False)),!.
  bldP_LinkTarget(_Argument,_UpdateCB,_MessageCB, b_True).

  bldP_IsToolAccessable(compiler):-
 	bldDB_CmpStatus(b_False),!.
  bldP_IsToolAccessable(linker):-
 	bldDB_LnkStatus(b_False),!.
  bldP_IsToolAccessable(compilerANDlinker):-
 	bldDB_CmpStatus(b_False),
 	bldDB_LnkStatus(b_False).

  bldP_Build(b_False):-
	bldPint_IsCmpAccessable,
	bldPint_IsLnkAccessable,
	bldDB_UpdateCB(UpdateCB),
	bldDB_MessageCB(MessageCB),
	bldDB_CmpeANDwCB(CompErrAndWarnCB),
	bldDB_CmpFlags(CompArgument),
	b_False=bldP_CompileFile(CompArgument,UpdateCB,CompErrAndWarnCB,MessageCB),
	bldDB_LnkFlags(LnkArgument),
	LnkResult=bldP_LinkTarget(LnkArgument,UpdateCB,MessageCB),
	LnkResult=b_False,!.
  bldP_Build(b_True).
  
  bldP_Stop:-
  	bldP_Stop(compiler),
  	bldP_Stop(linker),!.

  bldP_Stop(compiler):-bldDB_CompilerStop,!.
  bldP_Stop(compiler):-assert(bldDB_CompilerStop),!.
  bldP_Stop(linker):-bldDB_LinkerStop,!.
  bldP_Stop(linker):-assert(bldDB_LinkerStop),!.
  bldP_Stop(compilerANDlinker):-
  	bldP_Stop(compiler),
  	bldP_Stop(linker),!.
  bldP_Stop(_Any).
  
predicates
  procedure bldPint_Convert(BOOLEAN errORWarnBOOL,STRING errORWarnSYM)
clauses

  bldPint_Convert(b_True,"E;"):-!.
  bldPint_Convert(b_False,"W;"):-!.
  bldPint_Convert(_Any,""):-errorexit().

  cmpCB_ErrAndWarn(MsgNo,ErrORWarnBOOL,_FN,LineNo,Pos,TextComment,_):-
	bldDB_CmpeANDwCB(CompErrAndWarnCB),
	bldPint_Convert(ErrORWarnBOOL,ErrORWarnSTR),
	CompErrAndWarnCB(ErrORWarnSTR,MsgNo,LineNo,Pos,TextComment),!.
  cmpCB_ErrAndWarn(_ErrNo,_ErrORWarn,_FN,_LineNo,_Pos,_TextComment,_Any).
  
  cmpCB_ProcessEvent(b_True):-
	retract(bldDB_CompilerStop),!.
  cmpCB_ProcessEvent(b_False):-
	bldDB_UpdateCB(UpdateCB),
	UpdateCB(),!.
  cmpCB_ProcessEvent(b_False).

  lnkCB_ProcessEvent(b_True):-
	retract(bldDB_LinkerStop),!.
  lnkCB_ProcessEvent(b_False):-
	bldDB_UpdateCB(UpdateCB),
	UpdateCB(),!.
  lnkCB_ProcessEvent(b_False).
