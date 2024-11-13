/*****************************************************************************

	(c) Copyright 1984 - 2000 Prolog Development Center A/S

 Project:  SETUP
 FileName: SETUPDDE.PRO
 Purpose: Setup Program
 Written by: Zaichenko Michael
 Comments:
******************************************************************************/
constants
  ddeTimeOut =	3000	
database - dde
  determ conv(DDE_CONV)
  determ os_ver(ULONG)
predicates
 
 determ execute_cmd(STRING Cmd)
 procedure execute_cmd2(DDE_CONV Conv,STRING Cmd)
  
 procedure  cmd_AddItem(INTEGER cond,STRING descr,STRING path,STRING prodir)
 procedure  cmd_DeleteItem(INTEGER cond,STRING descr)
 determ  cmd_CreateGroup(STRING Name)
 determ  cmd_ShowGroup(STRING Name)
 
 
clauses
ifdef ws_win
 ifdef platform_16bit
  setupDDE_Register():-
 	V = winapi_GetVersion(),
 	bitAnd(V,0xffff,V2),
 	retract(os_ver(_)),
 	assert(os_ver(V2)),
	fail.
 enddef
  setupDDE_Register():-
	trap(dde_init([ddef_clientonly]),_,fail),
	!.
enddef
setupDDE_Register().	


clauses
  execute_cmd(Command):-
	conv(Conv),
	execute_cmd2(Conv,Command),
	vpi_processEvents(0),
	!.
ifdef ws_win	
  execute_cmd2(CONV,Command):-
	trap(dde_Execute(CONV,Command,ddeTimeOut),_,Fail),
	!.
	
enddef
  execute_cmd2(_,_).
	
ifdef ws_win
  cmd_AddItem(Cond,Descr,PATH,PRODIR):-
	selected(Cond),
	format(CMD,"[AddItem(%c%s%s%c,%s)]",'"',PRODIR,PATH,'"',Descr),
	execute_cmd(CMD),
	!.
enddef
  cmd_AddItem(_,_,_,_).

  cmd_DeleteItem(Cond,Descr):-
	os_ver(V2),
	V2 > 0x0a03,
	selected(Cond),
	format(CMD,"[DeleteItem(%s)]",Descr),
	execute_cmd(CMD),
	!.
  cmd_DeleteItem(_,_).
	
  cmd_CreateGroup(Name):-
	format(CMD,"[CreateGroup(%s)]",Name),
	execute_cmd(CMD),!.
  
  cmd_ShowGroup(Name):-
	format(CMD,"[ShowGroup(%s,1)]",Name),
	execute_cmd(CMD),!.

predicates
 determ  doIconScript(PROGRAM_ItemL)
clauses

  doIconScript([pItem(Cond,Descr,PATH,PRODIR)|T]):-!,
	cmd_DeleteItem(Cond,Descr),
	cmd_AddItem(Cond,Descr,PATH,PRODIR),
	doIconScript(T).
	
  doIconScript([pGroup(GroupTitle)|T]):-!,
	cmd_CreateGroup(GroupTitle),
	cmd_ShowGroup(GroupTitle),
	doIconScript(T).
 
  setupDDE_createGroup([]):-!.	% do nothing if void script 

ifdef ws_win
  setupDDE_createGroup(IconItemScript):-
	trap(Conv=dde_connect("PROGMAN","PROGMAN"),_,dlg_note("Error on DDE Connect to Program Manager")),
	retractall(conv(_)),
	assert(conv(Conv)),
	doIconScript(IconItemScript),
	fail.
  setupDDE_createGroup(_):-
	retract(conv(CONV)),
	dde_Disconnect(CONV),!.
enddef
