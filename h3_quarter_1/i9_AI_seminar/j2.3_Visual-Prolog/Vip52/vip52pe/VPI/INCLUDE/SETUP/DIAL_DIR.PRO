/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S 

			 VISUAL Prolog

 FileName:  dial_dir.PRO
 PURPOSE:
 Written by: Yuri Ilyin 
 Comments:

******************************************************************************/
ifndef iodecl_con_included
 #Error: this file requires include: iodecl.con
enddef
ifndef dial_dir_pre_included
 #Error: this file requires include: dial_dir.pre
enddef 

constants 
 ctl_LBoxDir 	= 511
 ctl_Path 	= 512
 ctl_Dir_1 	= 513
 ctl_Drives	= 514
 ctl_Dir_2 	= 515
 ctl_Dir_3 	= 516
 ctl_DrivesMap 	= 517
 ctl_SubDir	= 518
 ctl_Dir_5 	= 519
 ctl_DrivesNet  = 520 /*YI 003*/
  
database - path_to_dir
determ  path_to_dir(STRING, BOOLEAN)
determ  path_to_dir_temp(STRING,STRING)
determ	current_item_sel_item(INTEGER)
	list_sub_directories(STRING)
determ 	sub_dir_str(STRING)
        list_drives(STRING) %YI 95.12.21
determ  create_flag
determ  font_item(FONT,INTEGER Height)
	
/***************************************************************************
	owner draw predicates
***************************************************************************/
predicates
  draw_LboxDir : OWNERDRAW_LBOX_FUNC
  determ shift_horizont(INTEGER,INTEGER,BOOLEAN)
  procedure draw_box_dir(WINDOW,BOOLEAN,INTEGER,PNT)
  procedure get_list_net_resources(WINDOW,STRING,SLIST) - (i,i,o)

clauses
  shift_horizont(I,X,b_true):-
	current_item_sel_item(C), 
	I <= C,!,
	X = I*5 + 3.
  shift_horizont(_,X,b_false):-
	current_item_sel_item(C), 
	X = (C+1)*5 + 3.
	
  draw_box_dir(W,_,_,_):-
	win_SetPen(W,pen(1,ps_Solid,color_Black)),
	win_SetBrush(W,brush(pat_Solid,color_Yellow)),
  	fail.
  draw_box_dir(W,b_false,X,pnt(Y1,Y2)):-!,
	T=Y1+3, B=Y2-3, R=X+14,
	draw_Rect(W,rct(X,T,R,B)),
	RCT=rect_Inflate(rct(X,T,R,B), -2, -2),
	RCT = rct(Li,Ti,Ri,Bi),
	win_SetPen(W,pen(1,ps_Solid,color_White)),
	draw_Polyline(W, [pnt(Li,Bi),pnt(Li,Ti),pnt(Ri,Ti)]),
	win_SetPen(W,pen(1,ps_Solid,color_Gray)),
	draw_Polyline(W, [pnt(Li,Bi),pnt(Ri,Bi),pnt(Ri,Ti)]).
  draw_box_dir(W,_,X,pnt(Y1,Y2)):-
	T=Y1+3, B=Y2-3, R=X+14,
	draw_Rect(W,rct(X,T,R,B)), X1=X+3, T1=T+3, X2=X1+ R-X,
	draw_Polygon(W,[pnt(X,B),pnt(X1,T1),pnt(X2,T1),pnt(R,B),pnt(X,B)]),
	Li = X+1, L1i = X1 + 1, Ti = T1+1, Ri = R-1, R1i = X2-1, Bi = B-1,
	win_SetPen(W,pen(1,ps_Solid,color_White)),
	draw_Polyline(W, [pnt(Li,Bi),pnt(L1i,Ti),pnt(R1i,Ti)]),
	win_SetPen(W,pen(1,ps_Solid,color_Gray)),
	draw_Polyline(W, [pnt(Li,Bi),pnt(Ri,Bi),pnt(R1i,Ti)]).

  draw_LboxDir(W,_,SHIFT,_,_):-
  	SHIFT <> 0,
	win_SetPen(W,pen(1,ps_Hollow,color_Black)),
	win_SetBrush(W,brush(pat_Solid,color_Black)),
	win_SetForeColor(W,color_White),
	win_SetBackColor(W,color_Black),
	fail.
  draw_LboxDir(W,_,0,_,_):-
ifdef os_os2
	Color = vpi_GetAttrVal(attr_color_tooltipback),  
elsedef
	Color = vpi_GetAttrVal(attr_color_window),
enddef
	win_SetPen(W,pen(1,ps_Hollow,Color)),
	win_SetBrush(W,brush(pat_Solid,Color)), %YI 970306
	win_SetForeColor(W,color_Black),
	win_SetBackColor(W,Color),
	fail.
  draw_LboxDir(W,RECT,_,STRITEM,I):-
	draw_Rect(W,RECT),
	shift_horizont(I,X,Bool),
	RECT=rct(_,TOP,RIGHT,BOTTOM),
        font_item(FONT,_),
	win_SetFont(W,FONT), X1 = X+20,
	concat(" ",STRITEM,STR),
	draw_TextInRect(W,rct(X1,TOP,RIGHT,BOTTOM),STR,-1,[dtext_left,dtext_singleline,dtext_vcenter]),
	draw_box_dir(W,BOOL,X,pnt(Top,BOTTOM)),!.


/***************************************************************************
	additional predicates
***************************************************************************/
predicates
  procedure get_list_Directories(WINDOW,STRING,SLIST,INTEGER)
  procedure get_list_Drives(STRING,SLIST,INTEGER)
  determ    find_tree_list(STRING,SLIST,INTEGER,SLIST,INTEGER,STRING,STRING)
  procedure number_in_list(STRING,SLIST,INTEGER,INTEGER)
  procedure find_sub_dir(WINDOW,STRING,SLIST) - (i,i,o)
  procedure find_list_drive(SLIST)
  determ avail_drive(CHAR, STRING)
  procedure dlgdir_rev_list(SLIST,SLIST,SLIST)
  determ check_exist_path(STRING)
  procedure set_sub_dir(STRING,STRING)
  nondeterm get_all_grives(CHAR) %YI 95.12.21
  procedure pick_db_drives()
  determ get_drive_name(INTEGER,INTEGER,STRING)
  
clauses
  get_all_grives('A').
  get_all_grives('B').
  get_all_grives('C').
  get_all_grives('D').
  get_all_grives('E').
  get_all_grives('F').
  get_all_grives('G').
  get_all_grives('H').
  get_all_grives('I').
  get_all_grives('J').
  get_all_grives('K').
  get_all_grives('L').
  get_all_grives('M').
  get_all_grives('N').
  get_all_grives('O').
  get_all_grives('P').
  get_all_grives('Q').
  get_all_grives('R').
  get_all_grives('S').
  get_all_grives('T').
  get_all_grives('U').
  get_all_grives('V').
  get_all_grives('W').
  get_all_grives('X').
  get_all_grives('Y').
  get_all_grives('Z').

  dlgdir_rev_list([],L,L):-!.
  dlgdir_rev_list([H|L1],L2,L3):-!,
	dlgdir_rev_list(L1,[H|L2],L3). 
  dlgdir_rev_list(_,L,L):-errorexit(). % Should never be called !

  find_list_drive(LIST):-%YI 95.12.21
        retractall(list_drives(_)),
	disk(D),
        pick_db_drives(),
	disk(D),
	findall(NAME,list_drives(NAME), LIST ),
	!.
	
  pick_db_drives():-
  	get_all_grives(Letter),
 	  avail_drive(Letter, NAME),
  	  assert(list_drives(NAME)),
  	fail.
  pick_db_drives():-!.

  avail_drive(Letter, Name):-
 	str_char(SDrive,Letter),
	DRIVE = cast(integer,Letter),
  	I1 = Drive - 65,
	A = drive_GetType(I1),
	A > 1,
	get_drive_name(I1,A,LowName), %YF 19-12-96
	format(Name,"%s: %",SDrive,LowName).

  get_drive_name(_,2,""):-!.
  get_drive_name(DRIVE,4,LowName):-
	INT = drive_GetName(Drive, NameDrive),
	INT = 0,
	upper_lower(NameDrive,LowName),!.
  get_drive_name(_,4,""):-!. %YI 970704
  
  find_sub_dir(DW,Path,LIST):- %YI003
	frontchar(Path,'\\',S1),
	frontchar(S1,'\\',S2),
	not(searchchar(S2,'\\',_)),!,
	get_list_net_resources(DW,Path,List).
  find_sub_dir(_,ExistPath,[]):-
	concat(ExistPath,"\\*.*",Path),
  	trap(dirfiles(Path,fa_subdir,F,_,_,_,_,_,_,_,_),_,fail),
	  F <> ".", F <> "..",
  	  assert(list_sub_directories(F)),
  	fail.
  find_sub_dir(_,_,LIST):- 
	findall(F,list_sub_directories(F),List). %YI003

  number_in_list(CurDrive,ListDrive,I,StartIndexDrive):-
  	ListDrive = [H|T], I1 = I+1,
	frontstr(1,H,Letter,_),
  	not(CurDrive = Letter),!,
  	number_in_list(CurDrive,T,I1,StartIndexDrive).
  number_in_list(_,_,I,I).
  
  find_tree_list("",L,Num,L,Num,Path,Path):-!.
  find_tree_list(S,L,I,Lout,Num,CurPath,OutPath):-
	searchchar(S,'\\',Pos), 
	Pos > 1, %YI003
	Len = Pos - 1,
	frontstr(Len,S,Dir,Rest),
	format(ExistPath,"%s%s\\",CurPath,Dir), 
	check_exist_path(ExistPath),!,
	frontchar(Rest,_,S1),
	I1 = I+1,
	find_tree_list(S1,[Dir|L],I1,Lout,Num,ExistPath,OutPath).
  find_tree_list(S,L,I,Lout,Num,CurPath,OutPath):-%YI003
	frontchar(S,'\\',S1), 
	frontchar(S1,'\\',S2), 
	searchchar(S2,'\\',Pos), 
	Len = Pos + 1,
	frontstr(Len,S,Dir,Rest),
	format(ExistPath,"%s%s\\",CurPath,Dir), 
	check_exist_path(ExistPath),!,
	frontchar(Rest,_,Snext),
	I1 = I+1,
	find_tree_list(Snext,[Dir|L],I1,Lout,Num,ExistPath,OutPath).
  find_tree_list(S,L,I,[S|L],Num,CurPath,ExistPath):-
	format(ExistPath,"%s%s\\",CurPath,S), 
	check_exist_path(ExistPath),!,
  	Num = I+1.
  find_tree_list(_,L,Num,L,Num,Path,Path):-!.
	
  check_exist_path(ExistPath):-
  	concat(Path,"\\",ExistPath),
	frontchar(Path,'\\',S1), 
	frontchar(S1,'\\',S2), 
	not(searchchar(S2,'\\',_)),!.
  check_exist_path(ExistPath):-
  	concat(Path,"\\",ExistPath),
  	str_len(Path,Len),
  	Len > 2,!,
  	trap(disk(Path),_,fail),!.
  check_exist_path(_):-!.

  get_list_Directories(DW,Path,ListDir,StartIndexDir):-
 	find_tree_list(Path,[],-1,ListTree,StartIndexDir,"",EPath),
  	concat(ExistPath,"\\",EPath),
 	set_sub_dir(Path,EPath),
  	retractall(list_sub_directories(_)),
	find_sub_dir(DW,ExistPath,ListF),
  	br_sort(ListF,SortedLF),
  	dlgdir_rev_list(ListTree,SortedLF,ListDir),!.
  get_list_Directories(_,_,[],0):-!.
	
  set_sub_dir(Path,EPath):-
  	concat(EPath,SubDir,Path),
  	concat(ExistPath,"\\",EPath),
    	retractall(sub_dir_str(_)),
    	assert(sub_dir_str(SubDir)),
%  	path_to_dir_temp(OldPath,_), 
  	retractall(path_to_dir_temp(_,_)), 
  	assert(path_to_dir_temp(ExistPath/*OldPath*/,ExistPath)), 
    	fail.
  set_sub_dir(_,_):-!.

  get_list_Drives("\\",[],0):-!. %YI003
  get_list_Drives(CurDrive,ListInOrder,StartIndexDrive):-
  	find_list_drive(ListInOrder),
%	dlgdir_rev_list(ListDrive,[],ListInOrder),
	number_in_list(CurDrive,ListInOrder,0,StartIndexDrive).

%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
predicates
  procedure show_new_path(WINDOW,STRING)
  determ STRING make_new_path(STRING,INTEGER,BOOLEAN)
  determ check_diskette(STRING)
  determ INTEGER get_pos_cut_path(STRING,INTEGER)
  determ front_name(STRING,STRING)
  procedure STRING if_choose(STRING,STRING,BOOLEAN)

clauses
  if_choose(OUT,_,b_false,OUT):-!.
  if_choose(_,OUT,_,OUT):-!.

  check_diskette(S):-
  	frontchar(S,CH,_),
	str_char(SH,CH),
  	concat(SH,":",Wild),
  	trap(disk(Wild),_,fail),!.

  front_name(S,Token):-%YI003
  	frontchar(S,'\\',S1),
  	frontchar(S1,'\\',Rest),
	searchchar(Rest,'\\',FoundPos),!,
	Len = FoundPos+1,
  	frontstr(Len,S,Token,_).
  front_name(Rest,Token):-
	searchchar(Rest,'\\',FoundPos),!,
	Len = FoundPos-1,
  	frontstr(Len,Rest,Token,_).
  front_name(Token,Token).

  get_pos_cut_path(_,0,0):-!.
  get_pos_cut_path(OldPath,INDEX,Pos):-%YI003
  	frontchar(OldPath,'\\',S1),
  	frontchar(S1,'\\',S3),
	searchchar(S3,'\\',FoundPos),
  	frontstr(FoundPos,S3,_,Rest),
  	I = INDEX - 1,!,
  	Pos = get_pos_cut_path(Rest,I) + FoundPos + 2.
  get_pos_cut_path(OldPath,INDEX,Pos):-
	searchchar(OldPath,'\\',FoundPos),
  	frontstr(FoundPos,OldPath,_,Rest),
  	I = INDEX - 1,!,
  	Pos = get_pos_cut_path(Rest,I) + FoundPos.

  make_new_path(_,INDEX,BOOL,Path):-
	current_item_sel_item(StartIndexDir),
	StartIndexDir >= INDEX,!,
	path_to_dir_temp(OldPath,_),
	Pos = get_pos_cut_path(OldPath,INDEX),
  	frontstr(Pos,OldPath,Beg,Rest),
	front_name(Rest,Token),
	format(Path,"%s%",Beg,Token),
  	retractall(path_to_dir_temp(_,_)), 
  	P = if_choose(OldPath,Path,BOOL),
  	assert(path_to_dir_temp(P,Path)),!.
  make_new_path(S,_,BOOL,Path):-
	path_to_dir_temp(OldPath,_),
  	format(Path,"%s\\%",OldPath,S),
  	retractall(path_to_dir_temp(_,_)), 
  	P = if_choose(OldPath,Path,BOOL),
  	assert(path_to_dir_temp(P,Path)),!.

%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  show_new_path(W,PATH):-
    	EDWIN = win_GetCtlHandle(W,ctl_SubDir),
    	SubDir = win_GetText(EDWIN),
    	SubDir = "",!,
    	CWIN = win_GetCtlHandle(W,ctl_Path),
    	win_SetText(CWIN, PATH).
  show_new_path(W,PATH):-
    	EDWIN = win_GetCtlHandle(W,ctl_SubDir),
    	SubDir = win_GetText(EDWIN),
    	frontchar(SubDir,'\\',_),!,
    	concat(PATH,SubDir,FullPATH),
    	CWIN = win_GetCtlHandle(W,ctl_Path),
    	win_SetText(CWIN, FullPATH).
  show_new_path(W,PATH):-!,
    	EDWIN = win_GetCtlHandle(W,ctl_SubDir),
    	SubDir = win_GetText(EDWIN),
    	concat(PATH,"\\",S),
    	concat(S,SubDir,FullPATH),
    	CWIN = win_GetCtlHandle(W,ctl_Path),
    	win_SetText(CWIN, FullPATH).

/***************************************************************************
	find network resources. YI003
***************************************************************************/
database - net_list_res
determ  temp_win(WINDOW)
determ  temp_dlg(WINDOW,LONG)
determ  temp_app_id(LONG,STRING)

predicates
determ  get_temp_path(STRING) - (o)
procedure  remove_last_spaces(STRING,STRING) - (i,o)
determ	get_list_servers( STRING, INTEGER, SLIST ) - (i,i,o)
determ	get_list_items_int(STRING,INTEGER, SLIST) - (i,i,o)
  netlistres_eh : EHANDLER
  dlg_wait_for_retrieving_network_pathes_eh : EHANDLER 
determ delete_last_empty_lines(STRING,STRING) - (i,o)
procedure get_list_net_servers(WINDOW,SLIST) - (i,o)
determ get_new_disk_path(STRING,STRING) - (i,o)
determ give_warning_on_empty(SList) - (i)
  
clauses
  get_list_net_resources(_,_,[]):-
  	retract(temp_win(WINDOW)),
	trap(win_Destroy(WINDOW),_,fail),
	fail.
  get_list_net_resources(DW,Server,ListResources):-
  	get_temp_path(Path),
	trap(filenameunique("~DIR",Name),_,fail),
	trap(filenamepath(TempShortName,Path,Name),_,fail),
ifdef os_os2
	filenameext(BatName,TempShortName,".cmd"),
elsedef
	filenameext(BatName,TempShortName,".bat"),
enddef
	filenameext(TempName,TempShortName,".out"),
	TaskWin = vpi_GetTaskWin(),
	Window = win_Create(w_Child,rct(0,0,1,1), "",no_menu, TaskWin, [wsf_Invisible,wsf_Disabled], 
	  netlistres_eh, 0),
  	assert(temp_win(WINDOW)),
	format(Param,"net view %s >%s", Server, TempName),
	trap(file_str(BatName,Param),_,fail),
	trap(Id = vpi_CreateProcess(WINDOW, BatName, "", wsf_Invisible ),_,fail),
	assert(temp_app_id(Id,TempName)),
	win_CreateDynDialog(DW,
		[
		 dlg(wdef(wd_Modal,rct(50,40,196,66),"Wait for retrieving network pathes",u_DlgBase),[wsf_DlgBorder,wsf_Close,wsf_TitleBar]),
		 ctl(wdef(wc_PushButton,rct(21,7,125,20),"&Cancel",u_DlgBase),idc_cancel,[wsf_Group,wsf_TabStop])
		],dlg_wait_for_retrieving_network_pathes_eh,0),
	trap(file_str(TempName,TextList),_,fail),
	trap(deletefile(TempName),_,fail),
	trap(deletefile(BatName),_,fail),
	delete_last_empty_lines(TextList, TextListResources),
	get_list_servers( TextListResources, 12, ListResources ),
	win_Destroy(WINDOW),
	!.
  get_list_net_resources(_,_,[]):-
  	temp_win(WINDOW),
	win_Destroy(WINDOW),!.
  get_list_net_resources(_,_,[]).

  get_list_net_servers(_,[]):-
  	retract(temp_win(WINDOW)),
	trap(win_Destroy(WINDOW),_,fail),
	fail.
  get_list_net_servers(DW, ListServers):-
  	get_temp_path(Path),
	trap(filenameunique("~DIR",Name),_,fail),
	trap(filenamepath(TempShortName,Path,Name),_,fail),
ifdef os_os2
	filenameext(BatName,TempShortName,".cmd"),
elsedef
	filenameext(BatName,TempShortName,".bat"),
enddef
	filenameext(TempName,TempShortName,".out"),
	TaskWin = vpi_GetTaskWin(),
	Window = win_Create(w_Child,rct(0,0,1,1), "",no_menu, TaskWin, [wsf_Invisible,wsf_Disabled], 
	  netlistres_eh, 0),
  	assert(temp_win(WINDOW)),
	format(Param,"net view >%s\n",TempName),
	trap(file_str(BatName,Param),_,fail),
	trap(Id = vpi_CreateProcess( Window, BatName, "", wsf_Invisible ),_,fail),
	retractall(temp_app_id(_,_)),
	assert(temp_app_id(Id,TempName)),
	win_CreateDynDialog(DW,
		[
		 dlg(wdef(wd_Modal,rct(50,40,196,66),"Wait for retrieving network pathes",u_DlgBase),[wsf_DlgBorder,wsf_Close,wsf_TitleBar]),
		 ctl(wdef(wc_PushButton,rct(21,7,125,20),"&Cancel",u_DlgBase),idc_cancel,[wsf_Group,wsf_TabStop])
		],dlg_wait_for_retrieving_network_pathes_eh,0),
	trap(file_str(TempName,TextList),_,fail),
	delete_last_empty_lines(TextList, TextListServers),
	trap(deletefile(TempName),_,fail),
	trap(deletefile(BatName),_,fail),
	not( TextListServers = "" ),
	get_list_servers( TextListServers, 18, ListServers ),
	win_Destroy(WINDOW),
	!.
  get_list_net_servers(_,[]):-
  	temp_win(WINDOW),
	win_Destroy(WINDOW),!.
  get_list_net_servers(_,[]).

  get_list_servers( TextListServers, Size, ListServers ):-
	searchstring(TextListServers,"----------------",FoundPos),
	frontstr(FoundPos,TextListServers,_,RestStr1),
	searchchar(RestStr1,'\n',FoundPos1),
	frontstr(FoundPos1,RestStr1,_,RestStr2),
%now we in the beginning of list of servers.
	get_list_items_int(RestStr2,Size, ListServers),!.
  get_list_servers( TextListServers, Size, ListServers ):-
  	Ch = val(char,0xC4),
  	searchchar(TextListServers,Ch,FoundPos),
	frontstr(FoundPos,TextListServers,_,RestStr1),
	searchchar(RestStr1,'\n',FoundPos1),
	frontstr(FoundPos1,RestStr1,_,RestStr2),
%now we in the beginning of list of servers.
	get_list_items_int(RestStr2,Size, ListServers).

  delete_last_empty_lines(TextList, TextListResources):-
  	concat(TextList1,"\n",TextList),!,
  	delete_last_empty_lines(TextList1, TextListResources).
  delete_last_empty_lines(TextList, TextList).

  get_list_items_int("",_,[]):-!.
  get_list_items_int(Str,_,[]):-
	not(searchchar(Str,'\n',_)),!.
  get_list_items_int(Str,Size,[Item|List]):-
	frontstr(Size,Str,StartStr,Rest),
	remove_last_spaces(StartStr,Item),
	searchchar(Rest,'\n',FoundPos),
	frontstr(FoundPos,Rest,_,Str1),
  	get_list_items_int(Str1,Size,List).

  remove_last_spaces(Str,Item):-
	concat(Str1," ",Str),!,
  	remove_last_spaces(Str1,Item).
  remove_last_spaces(Item,Item).
	
  get_temp_path(TEMP):-
	envsymbol("TEMP",TEMP),!.
  get_temp_path(TEMP):-
	envsymbol("TMP",TEMP),!.

  netlistres_eh(_,e_EndApplication(Id),0):-
	retract(temp_app_id(Id,_)),!.
  netlistres_eh(_,e_Destroy(),0):-
	retractall(temp_win(_)),!.

  dlg_wait_for_retrieving_network_pathes_eh(Win,e_Create(_),0):-
	NewTimerId = timer_Set(Win, 200),
	assert(temp_dlg(WIN,NewTimerId)),!.
  dlg_wait_for_retrieving_network_pathes_eh(Win,e_Timer(Id),0):-
	temp_dlg(WIN,Id),
	not(temp_app_id(_,_)),
  	win_Destroy(Win),!.
  dlg_wait_for_retrieving_network_pathes_eh(Win,e_Timer(Id),0):-
	temp_dlg(WIN,Id),
	temp_app_id(_,TempName),
  	trap(file_str(TempName,S),_,fail),
  	str_len(S,L),
  	L > 0,
	retractall(temp_app_id(_,_)), %bat finish 
  	win_Destroy(Win),!.
  dlg_wait_for_retrieving_network_pathes_eh(Win,e_Control(idc_Cancel,_,_,_),0):-
	retract(temp_app_id(_,_)),
  	win_Destroy(Win),!.
  dlg_wait_for_retrieving_network_pathes_eh(Win,e_Destroy(),0):-
	retract(temp_dlg(WIN,Id)),
	timer_Kill(Id),!.
	
  get_new_disk_path(STR,PATH):-
    	frontstr(1,STR,Letter,Rest),
	frontchar(Rest,':',_),!, %check here, other may be network path
    	concat(Letter,":",PATH),
    	check_diskette(STR).
  get_new_disk_path(STR,STR):-
	frontchar(STR,'\\',R),
	frontchar(R,'\\',_),!.

  give_warning_on_empty([]):-
	dlg_Note("Network is unavailable"),!,fail.
  give_warning_on_empty(_).

/***************************************************************************
	Event handling for the dialog
***************************************************************************/
predicates
  dialog_event	: EHANDLER
  lbox_eh	: EHANDLER

% flow pattern - (i,i,o,o,o,o)
% show_directories_information(DW,PATH,ListDir,StartIndexDir,ListDrive,StartIndexDrive)
  determ show_directories_information(WINDOW,STRING,SLIST,INTEGER,SLIST,INTEGER) - (i,i,o,o,o,o)

clauses
  show_directories_information(DW,PATH,ListDir,StartIndexDir,ListDrive,StartIndexDrive):-
    frontstr(1,PATH,CurDrive,_),
    concat(CurDrive,":",STR),
    check_diskette(STR),!,
    get_list_Directories(DW,PATH,ListDir,StartIndexDir),
    get_list_Drives(CurDrive,ListDrive,StartIndexDrive).
  show_directories_information(DW,PATH,ListDir,StartIndexDir,ListDrive,StartIndexDrive):-
    frontchar(PATH,'\\',S1),
    frontchar(S1,'\\',_),!, %YI003
    get_list_Directories(DW,PATH,ListDir,StartIndexDir),
    get_list_Drives("C",ListDrive,StartIndexDrive).
  show_directories_information(_,PATH,[],0,ListDrive,StartIndexDrive):-!,
    frontstr(1,PATH,CurDrive,_),
    get_list_Drives(CurDrive,ListDrive,StartIndexDrive).

  dialog_event(W,e_create(_),0) :- 
    retractall(create_flag),
    assert(create_flag),
    MapDriveWin = win_GetCtlHandle(W, ctl_DrivesMap),%YI003
    win_Check(MapDriveWin,1),%YI003
    retractall(sub_dir_str(_)),
    assert(sub_dir_str("")),
    path_to_dir(PATH,_),
    retractall(path_to_dir_temp(_,_)),
    assert(path_to_dir_temp(PATH,PATH)),
    show_directories_information(W,PATH,ListDir,StartIndexDir,ListDrive,StartIndexDrive),
    show_new_path(W,PATH),
    retractall(current_item_sel_item(_)), 
    assert(current_item_sel_item(StartIndexDir)),
    LBOXW2 = win_GetCtlHandle(W,ctl_Drives),
    lbox_Suspend(LBOXW2),
    lbox_Add(LBOXW2,-1,ListDrive),
    lbox_Resume(LBOXW2),
    lbox_SetSel(LBOXW2,StartIndexDrive,b_true),!,
	vpi_ProcessEvents(),
	LBOXWIN = win_GetCtlHandle(W,ctl_LBoxDir),	% BB! 1.11.96
	win_SetSubclassHandler(LBOXWIN, lbox_eh, 0 ), %YI 970306
	lbox_Suspend(LBOXWIN),
	lbox_Clear(LBOXWIN),
	lbox_Add(LBOXWIN,-1,LISTdir),
	lbox_Resume(LBOXWIN),
	lbox_SetSel(LBOXWIN,StartIndexdir,b_true),
    WSubDir = win_GetCtlHandle(W,ctl_SubDir),
    sub_dir_str(SubDir),
    win_SetText(WSubDir,SubDir),!,
    WDir = win_GetCtlHandle(W,ctl_LBoxDir),
    win_SetFocus(WDir),
    retractall(create_flag),!.

  dialog_event(W,e_closerequest,0) :- !,
    win_Destroy(W).
    
  dialog_event(W,e_control(idc_cancel,_,_,_),0) :-!,
    win_Destroy(W).

%YI003 begin
  dialog_event(W,e_Control(ctl_DrivesMap,_,CtlWin,_),0):-
	NetCtrlWin = win_GetCtlHandle(W, ctl_DrivesNet),
	win_CheckRadioButton(CtlWin, [CtlWin, NetCtrlWin]),
  	fail.
  dialog_event(W,e_Control(ctl_DrivesMap,_,_,_),0):-!,
	find_list_drive(List),
	LBOXW = win_GetCtlHandle(W, ctl_Drives),
    	lbox_Clear(LBOXW),
    	lbox_Add(LBOXW,List),
    	lbox_SetSel(LBOXW,0,b_true),!.

  dialog_event(_,e_Control(ctl_DrivesNet,_,_,_),0):-
	temp_dlg(_,_),!.
  dialog_event(W,e_Control(ctl_DrivesNet,_,CtlWin,_),0):-
	MapCtrlWin = win_GetCtlHandle(W, ctl_DrivesMap),
	win_CheckRadioButton(CtlWin, [MapCtrlWin, CtlWin]),
  	fail.
  dialog_event(W,e_Control(ctl_DrivesNet,_,_,_),0):-!,
  	get_list_net_servers(W,List),
	give_warning_on_empty(List),
	LBOXW = win_GetCtlHandle(W, ctl_Drives),
    	lbox_Clear(LBOXW),
    	lbox_Add(LBOXW,List),
    	lbox_SetSel(LBOXW,0,b_true),
    	win_SendEvent(W,e_Control(ctl_Drives,wc_LBoxButton,LBOXW,selchanged())),!.
%YI003 end

  dialog_event(W,e_Control(ctl_Drives,_,LBOXW,selchanged()),0):-!,
    not(create_flag),
    INDEX=lbox_GetSelIndex(LBOXW),
    STR=lbox_GetItem(LBOXW,INDEX),
    get_new_disk_path(STR,PATH), %YI003
    retractall(path_to_dir_temp(_,_)), 
    assert(path_to_dir_temp(PATH,PATH)),
    LBOXW1 = win_GetCtlHandle(W,ctl_LBoxDir),
/*MZ*/	setup_updateSpaceDialog(PATH),
    lbox_Suspend(LBOXW1),
    lbox_Clear(LBOXW1),
    show_new_path(W,PATH),
    show_directories_information(W,PATH,ListDir,StartIndexDir,_,_),
    retractall(current_item_sel_item(_)), 
    assert(current_item_sel_item(StartIndexDir)),
    lbox_Add(LBOXW1,-1,ListDir),
    lbox_Resume(LBOXW1),
    lbox_SetSel(LBOXW1,StartIndexDir,b_true),!.

  dialog_event(W,e_Control(ctl_LBoxDir,_,LBOXW1,activated()),0):-!,
    INDEX=lbox_GetSelIndex(LBOXW1),
    STR=lbox_GetItem(LBOXW1,INDEX),
    lbox_Suspend(LBOXW1),
    lbox_Clear(LBOXW1),
    Path = make_new_path(Str,INDEX,b_true),
    show_new_path(W,PATH),
    show_directories_information(W,PATH,ListDir,StartIndexDir,_,_),
    retractall(current_item_sel_item(_)), 
    assert(current_item_sel_item(StartIndexDir)),
    lbox_Add(LBOXW1,-1,ListDir),
    lbox_Resume(LBOXW1),
    lbox_SetSel(LBOXW1,StartIndexDir,b_true),!.

  dialog_event(W,e_Control(ctl_LBoxDir,_,LBOXW1,selchanged()),0):-!,
    INDEX=lbox_GetSelIndex(LBOXW1),
    STR=lbox_GetItem(LBOXW1,INDEX),
    Path = make_new_path(Str,INDEX,b_false),
    show_new_path(W,PATH).

  dialog_event(W,e_control(ctl_SubDir,_,_,modified),0) :-!,
    path_to_dir_temp(_,PATH),!,
    show_new_path(W,PATH).

ifdef ws_win
  dialog_event(W,e_control(idc_ok,_,_,_),0):-
	LBOXWIN = win_GetCtlHandle(W,ctl_LBoxDir),
	LBOXWIN = win_GetFocus(),!,
  	win_SendEvent(W,e_Control(ctl_LBoxDir,wc_LBox,LBOXWIN,activated()) ),!.
enddef
  dialog_event(W,e_control(idc_ok,_,_,_),0):-!,
    	CWIN = win_GetCtlHandle(W,ctl_Path),
    	PATH = win_GetText(CWIN),
    	retractall(path_to_dir(_,_)), 
    	assert(path_to_dir(PATH,b_true)),
    	win_Destroy(W).

  dialog_event(W,e_OwnerDraw(od_LBox,ctl_LBoxDir,ITEM,ACTIONLIST,
  	STATELIST,LBOXWIN,RECT,_),0):-
  	ownerdraw_DrawListBox(ACTIONLIST,STATELIST,RECT,W,LBOXWIN,ITEM,
  		draw_LboxDir,b_false),
	!.
  dialog_event(Win,e_OwnerMeasureItem(od_LBox,ID,_,_),SIZE):-
/*MZ*/	CTLW=win_getCtlHandle(Win,ID),
	Rct=win_getClientRect(CTLW),
	RCT = rct(L,_T,R,_B),
        font_item(_,H),%YI 970306
	W = R-L, %H = (B-T) div 8,
	WL = cast(long,W), 
	HL = cast(long,H),
	SIZE = WL + (0x10000 * HL),
	!.
%MZ	ownerdraw_MeasureControl(ID,SIZE),!.

  dialog_event(W,e_Destroy,0):-!,
  	retractall(path_to_dir_temp(_,_)),
  	retractall(current_item_sel_item(_)),
  	retractall(list_sub_directories(_)),
  	retractall(sub_dir_str(_)),
  	retractall(font_item(_,_)),
  	ownerdraw_Destroy(W).

  lbox_eh(LBOXWIN, e_Char(13,_),0):-
	W=win_GetParent(LBoxWin),
  	win_SendEvent(W,e_Control(ctl_LBoxDir,wc_LBox,LBOXWIN,activated()) ),!.
  lbox_eh(LBOXWIN, e_Char(' ',_),0):-
	W=win_GetParent(LBoxWin),
  	win_SendEvent(W,e_Control(ctl_LBoxDir,wc_LBox,LBOXWIN,activated()) ),!.
  	
/***************************************************************************
        Call dialog for choosing directories 
***************************************************************************/
clauses
  dlg_GetDirectoryName(TW, OldPathCr, NewPath, OkIsPressed):-
    upper_lower(OldPathU,OldPathCr),
    fileNamePath(OldPath,"",OldPathU),		/*add MZ 14.01.97*/
    retractall(path_to_dir(_,_)), 
    assert(path_to_dir(OldPath, b_false)),
    disk(Cur),
    TempWin=win_Create(w_Child,rct(0,0,10,10), "",no_menu, TW,[wsf_Invisible,wsf_Disabled], lbox_eh, 0),
    FONT=font_Create(ff_Helvetica,[],8),
    win_SetFont(TempWin, Font),
    win_GetTextExtent(TempWin, "Yy", -1, _, Height),
    win_Destroy(TempWin),
    Height1 = Height + 2,
    retractall(font_item(_,_)),
    assert(font_item(FONT,Height1)),
    win_CreateDynDialog(TW,
	[
    	dlg_font(wdef(wd_Modal,rct(50,20,231,173),"Set New Directory",u_DlgBase),"MS Sans Serif",8,[wsf_Titlebar,wsf_Close,wsf_Visible]),
	ctl(wdef(wc_LBox,rct(7,36,115,120),"",u_DlgBase),ctl_LBoxDir,[wsf_OwnerDraw,wsf_HasStrings,wsf_VScroll,wsf_TabStop,wsf_Group,wsf_NoIntegralHeight]),
    	ctl(wdef(wc_Edit,rct(122,35,177,47),"",u_DlgBase),ctl_SubDir,[wsf_AutoHScroll,wsf_Group,wsf_TabStop]),
    	ctl(wdef(wc_PushButton,rct(122,91,177,103),"&OK",u_DlgBase),idc_ok,[wsf_Default,wsf_Group,wsf_TabStop]),
    	ctl(wdef(wc_PushButton,rct(122,108,177,120),"&Cancel",u_DlgBase),idc_cancel,[wsf_Group,wsf_TabStop]),
    	ctl(wdef(wc_RadioButton,rct(7,127,62,136),"&Drives:",u_DlgBase),ctl_DrivesMap,[wsf_Group,wsf_TabStop]), /*YI003*/
    	ctl(wdef(wc_RadioButton,rct(77,127,176,136),"&Network Drives:",u_DlgBase),ctl_DrivesNet,[wsf_TabStop]), /*YI003*/
    	ctl(wdef(wc_LBoxButton,rct(7,137,176,192),"",u_DlgBase),ctl_Drives,[wsf_Group,wsf_TabStop,wsf_HScroll,wsf_VScroll]),
    	ctl(wdef(wc_Edit,rct(25,6,176,18),"",u_DlgBase),ctl_Path,[wsf_AlignLeft,wsf_AutoHScroll,wsf_ReadOnly]),
    	ctl(wdef(wc_Text,rct(2,7,18,17),"Path:",u_DlgBase),ctl_Dir_2,[wsf_AlignLeft]),
    	ctl(wdef(wc_Text,rct(5,23,45,33),"Directories:",u_DlgBase),ctl_Dir_3,[wsf_AlignLeft]),
    	ctl(wdef(wc_Text,rct(122,23,177,33),"Subdirectory:",u_DlgBase),ctl_Dir_5,[wsf_AlignLeft])
    	],dialog_event,0),
    disk(Cur),
    path_to_dir(NewPath, OkIsPressed),!.
  dlg_GetDirectoryName(_, Path, Path, b_false):-!.%dummy
