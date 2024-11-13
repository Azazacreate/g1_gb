/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S 

 FileName: SYSINFO.PRO
 Purpose: System Information
 Written by: Eugene Akimov
 Comments:
******************************************************************************/
ifndef sysinfo_pre_included
 #Error: this file requires include: sysinfo.pre
enddef 

/**************************************************************************
	Creation and event handling for window: System Info
	Code style: Single window
**************************************************************************/
constants
	idc_mem1 = 126
	idc_mem2 = 127
	idc_mem3 = 128
	idc_mem4 = 129
	idc_mem5 = 130
	idc_mem6 = 131
	idc_mem7 = 132
	idc_stack = 133
	idc_gstack = 134
	idc_gstack_alloc = 135
	idc_heap_used = 136
	idc_heap_free = 137
	idc_system_mem = 138
	idc_backtracks = 139
	idc_close = 140

database - db
  sysinfo_create_flag
	
predicates
  procedure set_val(WINDOW,INTEGER,ULONG)

clauses
  set_val(_Win,CtrlId,Val):-
	term_str(ulong,Val,Str),
	CtrlHndl = win_GetCtlHandle(_Win,CtrlId),
	OldVal = win_GetText(CtrlHndl),
	OldVal >< Str,
	!,
	win_SetText(CtrlHndl,Str).
  set_val(_Win,_CtrlId,_Val).

constants
  win_memview_WinType = w_TopLevel
  win_memview_Flags = [wsf_Border,wsf_TitleBar,wsf_Close,wsf_ClipSiblings,wsf_ClipChildren]
ifdef os_os2
  win_memview_RCT = rct(10,30,270,220)
elsedef
  win_memview_RCT = rct(10,30,248,220)
enddef
  win_memview_Menu = no_menu
  win_memview_Title = "System Info"

predicates
  system_Info_eh : EHANDLER

clauses
  info_Create(_):-
	sysinfo_create_flag,
	!.
  info_Create(Parent):-
	win_Create(win_memview_WinType,win_memview_RCT,win_memview_Title,
		   win_memview_Menu,Parent,win_memview_Flags,system_Info_eh,0),
	asserta(sysinfo_create_flag).		   

  system_Info_eh(_Win,e_Create(_),0):-!,
	win_CreateControl(wc_Text,rct(10,10,110,26),"Used stack",_Win,[wsf_AlignLeft],idc_mem1),
	win_CreateControl(wc_Text,rct(10,30,110,46),"Used GStack",_Win,[wsf_AlignLeft],idc_mem2),
	win_CreateControl(wc_Text,rct(10,50,110,66),"Free GStack",_Win,[wsf_AlignLeft],idc_mem3),
	win_CreateControl(wc_Text,rct(10,70,110,86),"Used Heap",_Win,[wsf_AlignLeft],idc_mem4),
	win_CreateControl(wc_Text,rct(10,90,110,106),"Free Heap",_Win,[wsf_AlignLeft],idc_mem5),
	win_CreateControl(wc_Text,rct(10,110,110,126),"System Mem",_Win,[wsf_AlignLeft],idc_mem6),
	win_CreateControl(wc_Text,rct(10,130,140,146),"Backtrack Points",_Win,[wsf_AlignLeft],idc_mem7),
	win_CreateControl(wc_Text,rct(150,10,250,26),"stack",_Win,[wsf_AlignLeft],idc_stack),
	win_CreateControl(wc_Text,rct(150,30,250,46),"gstack",_Win,[wsf_AlignLeft],idc_gstack),
	win_CreateControl(wc_Text,rct(150,50,250,66),"gstack_alloc",_Win,[wsf_AlignLeft],idc_gstack_alloc),
	win_CreateControl(wc_Text,rct(150,70,250,86),"heap_used",_Win,[wsf_AlignLeft],idc_heap_used),
	win_CreateControl(wc_Text,rct(150,90,250,106),"heap_free",_Win,[wsf_AlignLeft],idc_heap_free),
	win_CreateControl(wc_Text,rct(150,110,250,126),"system",_Win,[wsf_AlignLeft],idc_system_mem),
	win_CreateControl(wc_Text,rct(150,130,250,146),"backtrack",_Win,[wsf_AlignLeft],idc_backtracks),
	win_CreateControl(wc_PushButton,rct(75,156,155,176),"Close",_Win,[wsf_Group,wsf_TabStop],idc_close),
	timer_Set(_Win, 100),
	!.

  system_Info_eh(_Win,e_Update(_UpdateRct),0):-!,
  	win_Clear(_Win,color_LtGray),
	!.

  system_Info_eh(_Win,e_Timer(_TimerId),0):-!,
	storage(UsedStack,_FreeStack,
		UsedGStack,FreeGStack,
		UsedHeap,FreeHeap,_NoOfHeapFreeSpaces,
		_UsedTrail,_AllocatedTrail,
		SystemFreeMem,NoOfBPoints),
		set_val(_Win,idc_stack,UsedStack),
		set_val(_Win,idc_gstack,UsedGStack),
		set_val(_Win,idc_gstack_alloc,FreeGStack),
		set_val(_Win,idc_heap_used,UsedHeap),
		set_val(_Win,idc_heap_free,FreeHeap),
		set_val(_Win,idc_system_mem,SystemFreeMem),
		set_val(_Win,idc_backtracks,NoOfBPoints),
		!.

  system_Info_eh(_Win,e_Destroy(),0):-!,
	retractall(_,db),
	!.

  system_Info_eh(_Win,e_Control(idc_close,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	win_Destroy(_Win),
	!.

  system_Info_eh(_,_,0):-!,fail.

