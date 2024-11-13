/*****************************************************************************

	(c) Copyright 1984 - 2000 Prolog Development Center A/S

 Project:  SETUP
 FileName: FILE.PRO
 Purpose: Setup Filesystem Engine
 Written by: Zaichenko Michael
 Comments:
 OS/2 support 07.12.96
 FDIR32 support 13.aug.96
 remove task_w fact : 04.02.97
******************************************************************************/
 
constants		% for debuging this file uncoment some next constants 
 %id_debug = 1
 %id_debug_span = 1
 %id_debug_FDIR_ISB =1
 %id_debug_FDIR_DIR =1
% id_debug_write_log  = 1
ifndef use_FDIR32
% ifdef platform_32bit 
 use_FDIR32 =1	      % set support 'FDIR32' format instead of FDIR
% enddef
enddef


/*ifndef use_fdir32
 .error must fdir32
enddef
*/
  file_idc_edit			= 101
  file_idc_skip			= 103
  file_idct_static_text		= 104
  file_idct_static_text1	= 105
  file_idct_filename 		= 106
  file_idct_copying_file	= 194
  file_idc_file			= 195
  file_idct_available_disk_space = 196
  file_idct_progress_indicator	= 197
  file_idc_progress		= 198
  file_idc_rem_disk_space	= 199
  file_idc_installation_information = 200
  file_idc_no_continue_installation = 202
  file_id_disk_name 		= 204
  file_id_df	    		= 205
  file_idc_retry		= 206
  file_idc_no			= 207
  file_idc_not_to_all		= 208
  file_idct_message		= 209
  file_idct_would_you_like	= 211

database - files
 determ spaceRequired(ULONG Space)
 determ spaceLeft(ULONG Space)
 determ file_p_add_to_bar(ULONG)
 
 determ spaceLeft2(ULONG)		%by MZ 11.09.96
 determ spaceBySumTree2(ULONG)		%by MZ 11.09.96
 determ license_txt(STRING) 
 single dlgErr_choosed_Last(STRING)



predicates
  determ addLeftToPBar(ULONG)			%by MZ 11.09.96
clauses
 dlgErr_choosed_Last("").

  addLeftToPBar(AddLeft):-		%by MZ 11.09.96
	spaceBySumTree2(MAXSIZE),
	retract(spaceLeft2(LEFT)),
	Nleft=Left+AddLeft,
	assert(spaceLeft2(NLEFT)),
	progress_w(Win),
	PCCWIN = win_GetCtlHandle(Win,file_idc_progress),
	progress_bar_set_value(PCCWIN,MaxSize,NLeft),
ifdef use_Message
	write("max=",MaxSize," Cur=",NLeft),nl,
enddef
	fail.
	
  addLeftToPBar(_):-		%by MZ 11.09.96
	getPath(Path),
	%frontchar(Path,Drive,_),
	%diskSpace(Drive,Space),
	file_GetDiskFree(Path,_,Space,_),
	SplitSpace = file_longToSplitString(SPACE),
	format(Sp,"%s KBytes",SplitSpace),
	progress_w(Win),
	CtrlWin2=win_GetCtlHandle(Win,file_idc_Rem_Disk_Space),
	win_SetText(CtrlWin2,SP),
	%dialog_SetStr(Win,file_idc_Rem_Disk_Space,SP),
	!.

predicates
  clear_ReadOnly(string FileName)-procedure(i)
clauses
  clear_ReadOnly(FName):-
  	trap(existFile(Fname),_,fail),
	trap(fileAttrib(Fname,Attr),_,fail),
	%format(TTTTT,"%s %X",Fname,Attr),
	%dlg_Note(TTTTT),
	bitand(Attr,1,NA),	%marked read only?
	NA=1,			%yes!
	TWin = vpi_GetTaskWin(),
	dlg_readonly_Create(Twin,FNAME),
	bitxor(Attr,1,NAttr),	%clear readonly
	NAttrV = val(ushort,NAttr),
	trap(fileattrib(Fname,NAttrV),_,fail),
	!.%set new attr
  clear_ReadOnly(_).
predicates
 % file_pathReduce(WINDOW Dialog,CTLID Id)-(i,i)
  determ STRING smaler1(WINDOW Task,STRING Path,INTEGER MaxX)
clauses
  file_pathReduce(WIN,CTLID):-
	install_work_now,
	CTRL=win_GetCtlHandle(Win,CTLID),
	Text=win_GetText(CTRL),
	RCT=win_GetClientRect(CTRL),
	RCT=rct(X1,_,X2,_),
	W = vpi_GetTaskWin(),
	frontStr(3,Text,T1,T2),
	!,	%T1="c:\" , T2="VPRO\aaa\bbb"
	win_GetTextExtent(W,T1,-1,XR1,_),
	Xm=X2-X1-XR1,
	T3=smaler1(W,T2,Xm),
	concat(T1,T3,Tout),
	win_setText(CTRL,TOUT).
  file_pathReduce(_,_).

  smaler1(Win,TEXT,XR,TEXT):-
	win_GetTextExtent(Win,TEXT,-1,X,_),
	X<=XR,
	!.
  smaler1(Win,T,XR,TOUT):-	%reduce filename
	frontchar(T,'.',_),	%found "...\"
	searchchar(T,'\\',P),
	frontstr(P,T,_,T2),	%cut "...\"
	searchchar(T2,'\\',P2),
	!,
	frontstr(P2,T2,_,T3),
	concat("...\\",T3,Tn),	%replace
	TOUT=smaler1(Win,Tn,XR).

  smaler1(Win,T,XR,TOUT):-
	not(frontchar(T,'.',_)),	
	searchchar(T,'\\',P),
	!,
	frontstr(P,T,_,T2),
	concat("...\\",T2,Tn),
	TOUT=smaler1(Win,Tn,XR).
  smaler1(_,T,_,T).

predicates
  nondeterm for(long Counter,long Start,long Stop)	%-(o,i,i)
  nondeterm member(dir_entry,directory) 
 
clauses
  file_my_processEvents:-
	install_work_now,
	!,
	vpi_processEvents(1).
  file_my_processEvents:-
	cursor_SetWait.
 
  member(H, [H|_]).
  member(H,[_|T]):- member(H,T).

  for(I,I,_).
  for(I,J,K):- 
	J<K,
	!,
	J2=J+1,
	for(I,J2,K).
 
 
predicates
  file_expandDirToBin(string,directory,diskstat,binary)-determ(i,i,i,o)
  file_expandToBin(string,dir_entry,diskstat,binary)-determ(i,i,i,o)
clauses 
  file_GetSmallFile(FileName,ID,Bin):-
	upper_Lower(FileName,Name),
	iscript(install_group(Id,DirList)),
	diskstat(DS),
	!,
	file_expandDirToBin(Name,DirList,DS,BIN).

  file_expandDirToBin(Name,DirList,DiskInfo,BINARY):-
	member(DirEntry,DirList),
	file_expandToBin(Name,DirEntry,DiskInfo,BinaRy),
	!.

  file_expandDirectory(DirList,DiskInfo):-
	disk(PreFix),
	format(LOG,"StartDir %s\n",PreFix),
	file_write_log_msg(Log),
	member(DirEntry,DirList),  %repeat-fail to keep Gstack collected
	install_work_now,
	  file_expand(DirEntry,Prefix,DiskInfo),    % (used by expand, file IO, etc)
	fail
	;
	true.
%BEGIN_DLG Setup Error
/**************************************************************************
	Creation and event handling for dialog: Setup Error
**************************************************************************/

constants

  dlg_setup_error_DlgType = wd_Modal
  dlg_setup_error_Title = "Setup Error"
  dlg_setup_error_RCT = rct(50,40,220,127)
  dlg_setup_error_Flags = [wsf_TitleBar]
  ids_YES	= "YES"
  ids_NOT	= "NO"
  ids_NotToALL	= "NOTALL"

predicates

  dlg_setup_error_eh : ehandler
  
  string dlg_FileErrorCreate(string Title ,string Filename)-(i,i)

clauses
  dlg_FileErrorCreate(_,_,ids_NotToALL):-
	dlgErr_choosed_Last(ids_NotToALL),
	!.

  dlg_FileErrorCreate(MESSAGE,Filename,Answer):-
	IDCT_MESSAGE_TITLE = MESSAGE,
	IDCT_FILENAME_TITLE = Filename,
%MARK Setup Error, new variables
	progress_w(Parent),
	dialog_Create(Parent,
		[
%BEGIN Setup Error, WinDefList, 19:09:51-9.3.1999, Code automatically updated!
		 dlg(wdef(dlg_setup_error_DlgType,dlg_setup_error_RCT,dlg_setup_error_Title,u_DlgBase),dlg_setup_error_Flags),
		 ctl(wdef(wc_PushButton,rct(11,68,51,80),"&Yes",u_DlgBase),file_idc_retry,[wsf_Group,wsf_TabStop]),
		 ctl(wdef(wc_PushButton,rct(65,68,105,80),"&No",u_DlgBase),file_idc_no,[wsf_Group,wsf_TabStop]),
		 ctl(wdef(wc_PushButton,rct(120,68,160,80),"N&o All",u_DlgBase),file_idc_not_to_all,[wsf_Group,wsf_TabStop]),
		 ctl(wdef(wc_Text,rct(5,8,165,18),"message",u_DlgBase),file_idct_message,[wsf_AlignCenter]),
		 ctl(wdef(wc_Text,rct(5,23,165,33),"Filename:",u_DlgBase),file_idct_filename,[wsf_AlignCenter]),
		 ctl(wdef(wc_Text,rct(5,53,165,63),"Would you like to try again?",u_DlgBase),file_idct_would_you_like,[wsf_AlignCenter]),
		 ctl(wdef(wc_Text,rct(5,38,165,48),"Please check file status or system restrictions.",u_DlgBase),file_idct_static_text,[wsf_AlignCenter])
%END Setup Error, WinDefList
		],
  		[
%BEGIN Setup Error, ControlList, 19:0]9:51-9.3.1999, Code automatically updated!
		df(file_idct_message,statictext(IDCT_MESSAGE_TITLE),nopr),
		df(file_idct_filename,statictext(IDCT_FILENAME_TITLE),nopr)
%END Setup Error, ControlList
		],
		dlg_setup_error_eh,0,_VALLIST,_),
		%Answer = dialog_VLGetDataField(file_id_df,VALLIST),
		%assert(dlgErr_choosed_Last(Answer)).
		dlgErr_choosed_Last(Answer).

predicates
  dlg_setup_idc2ids(INTEGER Id,STRING ids)-determ (i,o)
clauses
  dlg_setup_idc2ids(file_idc_not_to_all,ids_NotToALL):-!.
  dlg_setup_idc2ids(file_idc_no,ids_NOT):-!.
  dlg_setup_idc2ids(file_idc_retry,ids_YES).

  dlg_setup_error_eh(_Win,e_Control(CID,_,_,_),0):-
	dlg_setup_idc2ids(CID,IDS),
	%dialog_SetDataField(_Win,file_id_df,IDS),
	assert(dlgErr_choosed_Last(IDS)),
	win_Destroy(_Win).
	

%END_DLG Setup Error


predicates
  safe_OpenWrite(file,string)- determ(i,i)
  safe_OpenWrite2(file,string,binary)-determ(i,i,i)
  safe_WriteBlock(string,unsigned,binary)-determ (i,i,i)
  safe_WriteBlock2(string,unsigned,binary,binary)-determ(i,i,i,i)
  safe_ErrHandle(string,binary)-determ(i,i)
 % determ general_Cancel() 
clauses
/*
  general_Cancel():-
	TWin = vpi_GetTaskWin(),
	dlg_cancelation_Create(TWin),
	not(install_work_now),
	progress_w(PWin),
	win_destroy(PWin).
*/

  safe_OpenWrite(File,Name):-
	Flag = makeBinary(4),
	safe_openWrite2(File,Name,FLAG).

  safe_OpenWrite2(File,Name,FLAG):-
	install_work_now,
  	F=getDwordEntry(Flag,0),
  	F=0, 			%check previous error 
	setDwordEntry(Flag,0,0),
 	trap(openWrite(File,Name),Err,setDwordEntry(Flag,0,Err)),!.
 
  safe_OpenWrite2(File,Name,Flag):-	% when come here flag should contain error number
 	%_ErrNum = getDwordEntry(Flag,0),
	RetVal = dlg_FileErrorCreate("Can not open file for writing:",Name ),
	/*format(Err,"Can not open file:\n%s\nfor writing.\nError number: %U\nWould you like to try again?",Name,ErrNum),
	RetVal = dlg_MessageBox("Setup Error",Err,
				mesbox_IconQuestion,
				mesbox_buttonsYesNo,
				mesbox_DefaultFirst,
				mesbox_SuspendApplication),*/
	safe_ErrHandle(RetVal,Flag),
	safe_OpenWrite2(File,Name,Flag).

  safe_ErrHandle(ids_YES,Flag):-
	!,
	setDwordEntry(Flag,0,0). %clear flag and  try again
  safe_ErrHandle(ids_NOT,_Flag):-
 	!,
	fail.
  safe_ErrHandle(ids_NotToALL,_Flag):-
	fail.
%-----------------------------------------

  safe_WriteBlock(FileName,Bytes,Block):-
	FLAG = makeBinary(4),
	safe_WriteBlock2(FileName,Bytes,Block,FLAG).


  safe_WriteBlock2(_FileName,Bytes,Block,FLAG):-
	install_work_now,
  	F=getDwordEntry(Flag,0),
  	F=0, 			%check previous error 
	setDwordEntry(Flag,0,0),
 	trap(writeBlock(Bytes,Block),Err,setDwordEntry(Flag,0,Err)),
 	!.
  safe_WriteBlock2(FileName,Bytes,Block,FLAG):-
 	%ErrNum = getDwordEntry(Flag,0),
	RetVal = dlg_FileErrorCreate("Can not write to file" ,FileName),
	/*format(Err,"Can not write to file:\n%s\nError number: %U",FileName,ErrNum),
	RetVal = dlg_MessageBox("Setup Error",Err,
				mesbox_IconQuestion,
				mesbox_buttonsYesNo,
				mesbox_DefaultFirst,
				mesbox_SuspendApplication),*/
	safe_ErrHandle(RetVal,Flag),
	safe_WriteBlock2(FileName,Bytes,Block,FLAG).
	

predicates
 determ askCheck(string FileName,string DiskName)
 determ bumpDisk(diskstat,string FileName)
 determ maybeSwitch(integer CurrentDisk, integer TargetDisk, binary )
clauses

  askCheck(FileName, _DNAME):-
ifdef id_debug
	dlg_note(_DNAME),	%add 21.05.96
enddef
	existFile(FileName),
	!.

  askcheck(F,DiskName):-
	TWin = vpi_GetTaskWin(),
	dlg_disk_change_Create(TWin,DiskName),
	askCheck(F,DiskName).


  maybeSwitch(X,X,_):-
	!. % no switch needed
  maybeSwitch(_,  Target, Array):-
	format(DName,"Distribution Disk %",Target),
	setup_started_on_path(SPath),
	format(DISKN, "DISK_%", Target),
	filenamepath(Filename, Spath, DiskN),
        closeFile(archive),
	askCheck(FileName, DName),
	openread(archive,FileName),
	filemode(archive,0),
	setDwordEntry(Array,i_disk, Target). % and current disk no


   bumpDisk(DiskStat,FileName):-	%% ask for the next disk...
	NewDisk=getDwordEntry(DiskStat,i_disk)+1,
	setup_started_on_path(SPath),
	format(DiskN,"DISK_%",NewDisk),
	filenamepath(FileName, Spath,DiskN),
	format(UserName, "Distribution Disk %",NewDisk),
	askCheck(FileName, UserName),
	setDwordEntry(DiskStat, i_disk, NewDisk).

predicates
  determ expSegs(binary,dword CRC32,diskstat)
clauses
						% on a disk swap close/open
  expSegs(LenArray, ExpCrc,DS):-
	Last=(getBinarySize(LenArray) div 2)-1,
	CRCHolder=makeBinary(4),	   % used for local storage
	setDWordEntry(CRCHolder,0,init32), % to accumulate CRC
	for(Index,0,Last),
	   BlkSize=getWordEntry(LenArray,Index),
	   file_my_ProcessEvents,
	   install_work_now,
ifdef	id_debug
	   filepos(archive,CurPos,0),
	   format(MSG,"load seg:%d, size:%u, pos:%U",Index,BlkSize,CurPos),dlg_note(MSG),
enddef
	   file_readArcExpanding(BlkSize, ExpandedBin,DS),
	   file_my_ProcessEvents,
	   install_work_now,
	   CrcSeed=getDWordEntry(CRCHolder,0),       %safe from backtracking
	   CRCNext=crc32Binary(ExpandedBin, CrcSeed),
	   setDWordEntry(CRCHolder,0,CRCNext),
	   OutBlkSize=getBinarySize(ExpandedBin),
	   file_my_ProcessEvents,
	   safe_WriteBlock("",OutBlkSize, ExpandedBin),
	   addLeftToPBar(OutBlkSize),	%MZ 11.09.96
	   %p_bar_Set_AddVal(OutBlkSize),
	Index=Last,
	!,
	ExpCrc=init32-getDWordEntry(CRCHolder,0).     %crc = ~crc
  expSegs(_,_,_):-
  	closeFile(outfile),
  	fail.

ifdef id_debug
predicates
  procedure debuger_1(unsigned,unsigned,unsigned,unsigned)
clauses
  debuger_1(Size,MERGESIZE,SIZE1,SIZE2):-
	format(S,"Size=%u MERGESIZE=%u SIZE1=%u SIZE2=%u",Size,MERGESIZE,SIZE1,SIZE2),
	dlg_note(S).
enddef
  file_readArcExpanding(Size, Expanded,_DiskStat):-
	sizeOfDiskFile(DS),
	readdevice(Was),
	readdevice(archive),
	filepos(archive,XX,0),	%get pos
	DS>=XX+Size,
	!,
	trap(readblock(Size,Bin),_,dlg_note("readblock in readArcExp c0")),
	readdevice(Was),
	Expanded=expandBinary(Bin).
 
  file_readArcExpanding(Size,Expanded,DiskStat):-
	sizeOfDiskFile(DS),
	filepos(archive,Pos,0),	% get pos
	Size1=val(unsigned,DS-Pos),		 % from cur disk
	Size2=val(unsigned,Size-Size1),		% from new disk,
	readdevice(archive),
	readblock(Size1,Bin1),
	filepos(archive,Pos2,0),
ifdef id_debug_span
	format(MSG,"SPAN ds:%D pos:%D s1:%u s2%u S:%u",DS,Pos,Size1,Size2,Size),
	dlg_note(MSG),
enddef
	closeFile(archive),
ifdef id_debug_span
	dlg_note("SPAN file closed"),
enddef
	Pos2=DS,
	readdevice(Was2),
	bumpDisk(DiskStat,NewFileName),
	openread(archive,NewFileName),
	filemode(archive,0),
	file_SetDiskFileSize,
	readdevice(archive),
	readblock(Size2,BIN2),
	readdevice(Was2),
	Bin = mergeBinary(Bin1,Bin2),	% add by MZ 31.01.97
	%merge_bin(BIN1,BIN2,BIN),
	Expanded=expandBinary(Bin),
	!.

  file_readArcExpanding(_Size,_Expanded,_):-
	dlg_note("error file_readArcExpanding"),
	fail.
	

predicates
  determ setVirtualFpos(ulong VirtualFilePos,diskstat)
  determ realFpos(arcFilePOS,arcFilePOS,integer,integer,binary)
clauses

  setVirtualFpos(VirtFpos,DiskContext):-
	realFpos(VirtFpos, RealFpos, 1, TargetDisk, DiskContext),
	CurrentDisk=getDwordEntry(DiskContext,i_disk),
	maybeSwitch(CurrentDisk, TargetDisk,DiskContext),
	file_SetDiskFileSize,			%!add 22.05.96 this was is real bug
	filePos(archive,RealFpos,0).

%  the set of files DISK_1 to DISK_N is treated as a single virtual file,
%  where the directory in FDIR contains "virtual" file positions
%
%% map from Virtual file position to Disk No & actual position within file
%% disk array records for each disk its offset within the virtual file
  realFpos(VFpos, VFpos, Di, Di,Array):-
	TDi=Di+2,
	VFpos<getDwordEntry(Array, TDi),
	!.
  realFpos(VFpos, RFpos, Di, Disk, Array):-
	TDi=Di+2,
	FP2=Vfpos-getDwordEntry(Array,TDi),
	NextDisk=Di+1,
	realFpos(FP2, RFpos, NextDisk, Disk, Array).


%fdef os_os2 
predicates
  determ checkCarry(dword APIRet,string FileName)
clauses  
  checkCarry(APIRet,FileName):-
	APIRET<>0,
	!,
	format(Xm,"Internal Error: %x in set-date-time %s",APIRET,FileName),
	dlg_note(Xm).
%enddef 

predicates
 procedure setSelTime(file,unsigned,unsigned,string FileName)
clauses
  %% set the Date & Time on the File
ifdef ws_win
  setSelTime(_File,Date,Time,Filename):-
  	bitAnd(Date,0x1F,Day),		/*unpacking date structrure*/
  	bitRight(Date,5,Month1),
  	bitAnd(Month1,0x0f,Month),
  	bitRight(Month1,4,Year1),
  	Year=Year1+1980,
  					/*unpacking time structrure*/
  	
  	bitAnd(Time,0x1F,SecH),		/*unpacking date structrure*/
  	bitLeft(SecH,1,Sec),
  	bitRight(Time,5,Min1),
  	bitAnd(Min1,0x3F,Min),
  	bitRight(Min1,6,Hour),
  	
  	BMonth = cast(byte,Month),
  	BDay   = cast(byte,Day),
  	BHour  = cast(byte,Hour),
  	BMin   = cast(byte,Min),
  	BSec   = cast(byte,Sec),
  	
  	OS_TIME = os_time (Year,BMonth,BDay,BHour,BMin,BSec),
	OS_FILESTAMP = os_filestamp(OS_TIME
				       ifdef platform_32bit 	
				        ,OS_TIME,OS_TIME
				       enddef
			             ),
	trap(file_Time(Filename,OS_FILESTAMP),ApiRet,checkCarry(APIRet,FileName)),
	file_write_log_msg(" TS OK\n"),

	%format(TD,"Year %d, Month %d, Day %d,Hour %d,Minute %d,Second %d",Year,Month,Day,Hour,Min,Sec),
	%dlg_note(TD),
	!.
enddef

ifdef os_os2 		
  setSelTime(_,DATE,TIME,FileName):-
	API_RET = dTF_SetDateTime(FileName,DATE,TIME),
	format(Log, "TS %X\n",API_RET),
	file_write_log_msg(Log),
	checkCarry(API_Ret,FileName),
	!.
enddef
  setSelTime(_,_,_,_).

  file_test_crc(X,X,_):-
 	!.
  file_test_crc(_,_,File):-
	format(Msg,"CRC error expanding file %s",File),
	dlg_note(Msg).

  
  
predicates
  multimkdir(string Path,binary Result)-determ(i,i)	
  procedure cutdir(string,string)
  procedure trapmkdir(string)
clauses
  trapMKDir(D):-
	trap(mkdir(D),_,fail),
	fail.
  trapMKdir(_).
  
  cutdir(DIR,CUTDIR):-
	searchchar(Dir,'\\',Pos),
	Pos>1,
	Npos=Pos-1,
	substring(DIR,1,NPOS,CUTDIR),
	!.
  cutdir(DIR,DIR).






  multimkdir(DIR,Flag):-
	frontStr(2,Dir,Slash,CName),
	Slash = "\\\\",
	searchChar(Cname,'\\',Pos1),
	frontStr(Pos1,Cname,F,T),
	searchChar(T,'\\',Pos2),
	frontStr(Pos2,T,X,Path),
	!,
	format(UNCDrive,"\\\\%s%s",F,X),
	trap(disk(UNCDrive),Err,setDwordEntry(Flag,0,Err)),
	multimkdir(Path,Flag).

  multimkdir(DIR,Flag):-
   	not(searchchar(Dir,':',_)),
  	cutDir(Dir,CD),
  	trapmkdir(CD),
  	trap(disk(CD),Err,setDwordEntry(Flag,0,Err)),
 	searchchar(Dir,'\\',Pos),
	str_len(Dir,Len),
	NPos=Pos+1,
	Nlen=Len-Pos,
	substring(Dir,Npos,Nlen,NDir),
	!,
	multimkdir(NDir,Flag).
  multiMKDir(Dir,Flag):-
	searchchar(Dir,':',_),
	str_len(Dir,Len),
	Nlen=Len-3,
	NPos=4,
	substring(Dir,Npos,Nlen,NDir),
	substring(Dir,1,3,Root),
	trap(disk(Root),Err,setDwordEntry(Flag,0,Err)),
	multiMKDir(Ndir,Flag).

/****************************************
*		TopLevel		*
*****************************************/
  file_SetDiskFileSize:-
	retractall(sizeOfDiskFile(_)),
	filepos(archive,WAS,0),
	filepos(archive,0,2),		%set fp to end of file
	filepos(archive,SIZE,2),	%get file size
	filepos(archive,WAS,0),		%restore original pos
	assert(sizeOfDiskFile(Size)).
predicates
  file_setMake2(string,binary)-(i,i)
clauses
  file_setMake2(Dir,Flag):-
	install_work_now,
	F=getDwordEntry(Flag,0),
  	F=0, 			%check previous error 
  	str_len(Dir,Len),
  	Len>3,
	multimkdir(DIR,FLAG),	% is len big then "d:\"
	fail.
  file_setMake2(Dir,Flag):-
	F=getDwordEntry(Flag,0),
  	F=0, 			%check previous error 
	trap(disk(DIR),Err,setDwordEntry(Flag,0,Err)),
	!.
  file_setMake2(Dir,Flag):-
	RetVal = dlg_FileErrorCreate("Can not create Directory" ,Dir),
	safe_ErrHandle(RetVal,Flag),
	file_setMake2(Dir,Flag).

  file_setMake(Dir):-
	FLAG = makeBinary(4),
	file_setMake2(Dir,Flag).
	
	

  file_entriesInDir([_|T],C,Cr):-
	C2=C+1, file_entriesInDir(T,C2,Cr).
  file_entriesInDir([], C,C).





/***/
  file_expandToBin(Name,small_file(FileName,0,_Date,_Time,_,_,_),_,Bin):-
  	upper_Lower(FileName,Name2),
  	Name2 = Name,
  	!,
  	Bin = makeBinary(0).

  file_expandToBin(Name,small_file(FileName,_FileSize,_Date,_Time,CRCWas,ArcFpos,BlkSize),DS,ExpandedBin):-
  	upper_Lower(FileName,Name2),
  	Name2 = Name,
  	!,
	setVirtualFpos(ArcFpos,DS),
	file_readArcExpanding(BlkSize, ExpandedBin,DS),
	CRCNow=init32-crc32binary(ExpandedBin,init32),
	file_test_crc(CRCWas,CRCNow,FileName),
	!.

  file_expandToBin(Name,subdir(_, Directory),DS,BIN):-
	file_expandDirToBin(Name,Directory,DS,BIN),
	!.

/***/

predicates
 compose_fullname(string Path,string Name,string Full)-(i,i,o)
 % check trail slash, remove it if need.
clauses
 compose_fullname(Path,Name,Full):-
	str_len(Path,L),
	L1 = L - 1,
	frontstr(L1,Path,So,EndStr),
	str_char(EndStr,'\\'),
	!,
	format(Full,"%s\\%s",So,Name).
 compose_fullname(Path,Name,Full):-
	format(Full,"%s\\%s",Path,Name).




  file_expand(small_file(FileName,FileSize,Date,Time,_,_,_),Pre,_):-	%zero Length
  	FileSize=0,
  	!,
	compose_fullname(Pre,FileName,Full),
ifdef id_debug
        concat("fileZero:",FileName,F_N),dlg_note(F_N),
enddef
	file_echo_file(Full),
	file_my_ProcessEvents,
	install_work_now,
	disk(Pre),
	clear_ReadOnly(FileName),
	safe_OpenWrite(outfile,FileName),
	filemode(outfile,0),
	% restore files date & time
/*ifdef ws_win
	setSelTime(outFile, Date,Time, FileName),
enddef*/
	closeFile(outFile),
/*ifdef os_os2*/
	setSelTime(outFile, Date,Time, FileName),
%enddef
	!.


  file_expand(small_file(FileName,FileSize,Date,Time,CRCWas,ArcFpos,BlkSize),Pre,DS):-
	compose_fullname(Pre,FileName,Full),
	format(LOG,"Expand %s",Full),
	file_write_log_msg(Log),

ifdef id_debug
       concat("fileS:",FileName,F_N),dlg_note(F_N),
enddef
	file_echo_file(Full),
	setVirtualFpos(ArcFpos,DS),
	file_my_ProcessEvents,
	install_work_now,
	file_readArcExpanding(BlkSize, ExpandedBin,DS),
	file_write_log_msg(" Ex. Ok"),
	CRCNow=init32-crc32binary(ExpandedBin,init32),
	file_test_crc(CRCWas,CRCNow,FileName),
	file_write_log_msg(" CRC Ok"),
	file_my_ProcessEvents,
	disk(Pre),
	clear_ReadOnly(FileName),
	
	safe_OpenWrite(outfile,FileName),
	filemode(outfile,0),
	writedevice(Was),
	writedevice(outfile),
	safe_WriteBlock(Full,FileSize,ExpandedBin),
	writedevice(Was),
	% restore files date & time
/*ifdef ws_win
	setSelTime(outFile, Date,Time, FileName),
	closeFile(outFile),
enddef*/
	addLeftToPBar(FileSize),	%MZ 11.09.96
%ifdef os_os2
	closeFile(outFile),
	setSelTime(outFile, Date,Time, FileName),
%enddef
	!.

  file_expand(large_file(FileName,_FileSize,Date,Time,CRCWas,ArcFpos,LenArray),Pre,DS):-
	compose_fullname(Pre,FileName,Full),
	format(LOG,"Expand %s",Full),
	file_write_log_msg(Log),
ifdef id_debug
       concat("fileL:",FileName,F_N),dlg_note(F_N),
enddef
	file_echo_file(Full),
	setVirtualFpos(ArcFpos,DS),
	disk(Pre),
	clear_ReadOnly(FileName),
	
	safe_OpenWrite(outfile,FileName),
	fileMode(outfile,0),
	writeDevice(Was),
	writeDevice(outfile),
	expSegs(LenArray,CRCNow,DS),
	file_write_log_msg(" Ex. Ok"),
	writeDevice(Was),
	file_test_crc(CRCWas,CRCNow,FileName),
	file_write_log_msg(" CRC Ok"),
/*ifdef ws_win
	setSelTime(outFile, Date,Time, FileName),
	closeFile(outFile),
enddef
ifdef os_os2*/
	closeFile(outFile),
	setSelTime(outFile, Date,Time, FileName),
%enddef
	%file_echo_Size(FileSize),	%MZ 11.09.96
	!.

  file_expand(subdir(DirName, Directory),Prefix,DS):-
	disk(Was),
ifdef id_debug
       concat("Dir:",DirName,F_N),dlg_note(F_N),
enddef
	compose_fullname(Prefix,DirName,FullDir),
	%file_entriesInDir(Directory,2,Entries), % start count w/ 2 for "." & ".."
	%Size=32*Entries,
	file_echo_file(FullDir),
	%file_echo_Size(Size),
	file_setMake(FullDir),
	file_expandDirectory(Directory,DS),
	disk(Was),
	!.
 
 
  file_expand(large_file(FileName,_,_,_,_,_,_),Pre,_):-
	not(install_work_Now),
	!,
	compose_fullname(Pre,FileName,Full),
	trap(deletefile(Full),_,fail),
	fail.
  file_expand(small_file(FileName,_,_,_,_,_,_),Pre,_):-
	not(install_work_Now),
	!,
	compose_fullname(Pre,FileName,Full),
	trap(deletefile(Full),_,fail),
	fail.
/*****************************************************************************
******************************************************************************/
predicates
  determ assemble2(install_script,diskStat)
  determ mustExist(string FileName)
  procedure occupiesOnDisk(ulong Size,ulong AcrualSize,ulong BPS)
clauses
  %% reassemble into list of groups from list of file pointers
  %%  to groups (segmented as otherwise list might exceed
  %%  64K in fixup format)
  assemble2([igroup(Id, Fpos, TreeSize,CRCWas)|Tail],DiskContext):-
ifdef id_debug_FDIR_DIR
	format(DB_MSG,"GR_id:%d Fpos:%d",Id,Fpos),
	dlg_note(DB_MSG),
enddef
	filepos(archive,Fpos,0),
	file_readArcExpanding(TreeSize, DirBin,DiskContext),
	CRCNow=init32-crc32binary(DirBin,init32),
	file_test_crc(CRCWas,CRCNow,"fdir - in proc:assemble2"),
ifdef use_FDIR32
	term_bin(string,DirStr,DirBin),
	term_str(directory,Directory, DirStr),
elsedef
	term_bin(directory,Directory,DirBin),
enddef
	assert(iscript(install_group( Id, Directory))),
	assemble2(Tail,DiskContext),
	!.
  assemble2([],_).

  mustExist(X):-
	existFile(X),
	!.
  mustExist(X):-
	upper_lower(X,XL),
	concat("Setup can not find file: ",XL,Msg),
	dlg_Error(Msg),
	fail.
/************************************************************/


%igroup = bin (dword:GroupId,dword:DirFpos, dword:FileSize,dword UlongCrc32)
% 	/\ -size - 12 bytes
% igrp=struct igroup(INTEGER, ARCFPOS, FILESIZE, ULONG CRC32)


predicates
% Word countListEntries(Install_Script)
 procedure Install_Script rawBin2Script(binary)
 procedure rawBin2Script(install_script,binary,word,word)
 %Binary script2RawBin(Install_Script)
 %script2RawBinL(Install_Script,BINARY,WORD)
clauses

 rawBin2Script(RawBin,IScript):-
	BS=getBinarySize(RawBin),
	MCNT=val(ushort,(BS div 16)-1),
	rawBin2Script(IScript,RawBin,0,MCNT).

  rawBin2Script([],_,X,MX):- X > Mx,
	!.
  rawBin2Script([IS|T],RAW,IDX,MaxIDX):-
	NIDX = val(word,IDX+1),
	GR_offs= Idx*4,
	FP_offs=GR_OFFS+1,
	FS_offs=GR_OFFS+2,
	CRC_offs=GR_OFFS+3,
	
	GR = getDWordEntry(RAW,GR_offs),
	FP = getDwordEntry(RAW,FP_offs),
	FS = getDWordEntry(RAW,FS_offs),
	CRC= getDwordEntry(RAW,CRC_offs),
 	
 	IS=igroup(GR,FP,FS,CRC),
	rawBin2Script(T,RAW,NIDX,MaxIdx).


predicates
  procedure set_InstallParams()
clauses
  set_InstallParams():-
	trap(consult("s_info.$$$",install_params),_,fail),
	deletefile("s_info.$$$"),
	!.
  set_InstallParams():-
	syspath(Path,_),
	assert(setup_started_on_path(Path)),
	!.



  file_readScript:-
	disk(MYPATH),
	set_InstallParams(),
	assert(mypath(MYPATH)),
	%dlg_note(MYPATH),
	setup_started_on_path(SPath),
ifdef use_FDIR32	
	fileNamePath(FdirName, Spath, "FDIR32"),
elsedef
	fileNamePath(FdirName, Spath, "FDIR"),
enddef
	fileNamePath(Disk1File,Spath, "DISK_1"),
	mustExist(FdirName),
	mustExist(Disk1File),
	trap(openread(archive,FdirName),_,dlg_error("Error in opening fdir file")),
	fileMode(archive,0),
	file_SetDiskFileSize,

	readdevice(ReadD),
	readdevice(archive),
	readBlock(4,MaxDisksBin),	% read Max Disks
	MaxDisks=getDwordEntry(MaxDisksBin,0),
	DaSize=(MaxDisks+3)*4,
	FdirFakeDA=makebinary(12),


	readblock(DaSize, DiskArray),
	
	SFpos=getDwordEntry(DiskArray,0),
	SSize=getDwordEntry(DiskArray,1),
	SCrc=getDwordEntry(DiskArray,2),
	
	filepos(archive,SFpos,0),
ifdef id_debug_FDIR_ISB
	dlg_note("before read ISB"),
enddef    	
	file_readArcExpanding(SSize, ScriptBin, FdirFakeDA),
	ExpCrc=init32-crc32binary(ScriptBin,init32),
	file_test_crc(SCrc, ExpCrc, "FDIR"),
ifdef id_debug_FDIR_ISB
	dlg_note("ISB expanded and crc ok!"),
enddef
       ScriptTemp = rawBin2Script(ScriptBin),
ifdef id_debug_FDIR_ISB
	term_str(install_script,ScriptTemp,TextScript),
	file_str("D:\\Three.spt",TextScript),
enddef
ifdef id_debug_FDIR_DIR
	dlg_note("before assemble 2"),
enddef
	assemble2(ScriptTemp,FdirFakeDA),
	assert(diskStat(DiskArray)),
	readdevice(ReadD),
	closeFile(archive),

ifdef id_debug_FDIR_DIR
	dlg_note("FDir read Success."),
enddef

ifdef id_debug
	save("setup.gdb",setup_g_database),
enddef
	!.
file_readScript:-
	dlg_error("Error in read Script"),fail.


  occupiesOnDisk(Size,Size,1):-
	!.
  occupiesOnDisk(Size,Size,0):-
	!.
  occupiesOnDisk(Size,Size,CBytes):-
	0=(Size mod Cbytes),
	!.
  occupiesOnDisk(Size,Asize,Cbytes):-
	Asize=(1+(Size div Cbytes))*Cbytes.



predicates 					%SETUP.PRO
  procedure mark_invisible(ulong Size,integer CtlId)
  determ set_invisible2(window Dialog,integer)
clauses
  mark_invisible(S,CtlId):-
	S<512,
	!,
	assert(invisible(CtlId)).
  mark_invisible(_,_).
  
  set_invisible2(DLG,CTL):-
    dialog_SetCheck(DLG,CTL,b_false),
    dialog_setState(DLG,[enable(CTL,b_false)]).
	
  file_setInvisible(DLG):-
  	retract(invisible(CTL)),
  	  set_invisible2(DLG,CTL),
	fail.
  file_setInvisible(_). 
  
  
  file_setOneGroup(b_true,ID):-
	assert(is_selected(ID)),
	assert(is_selected2(ID)),
	!.
  file_setOneGroup(b_false,_ID).

predicates
  sumTree(binary Sum,string Drive)-determ(i,i)
  procedure addTo(binary,filesize)
  determ sumfiles(directory, binary,ulong)

  procedure size_str(integer,ulong,string)
  determ get_size_one_group(integer GroupId,ulong Size)
  determ get_size_one_group2(integer GroupId,binary Sum,ulong BPC)

clauses
	
  getSizeSelected(Path,Size):-
	Sum=makeBinary(4), % make an accumulator for summing selected sizes
	sumTree(Sum,Path),
	Size=getDwordEntry(Sum,0).  % read back computed sum

  get_size_one_group(GroupId,0):-
	bad_Group(GroupId),
	!.
  get_size_one_group(GroupId,Size):-
  	path(PATH),
	retractall(is_selected(_)),
	assert(is_selected(GroupId)),
	file_GetDiskFree(Path,BPC,_,_),
	Sum=makeBinary(4), % make an accumulator for summing selected sizes
	get_size_one_group2(GroupId,Sum,BPC),
  	Size=getDwordEntry(Sum,0).
  
  get_size_one_group2(GroupId,Sum,BPC):-
	iScript(install_group(Id, Directory)),
	  selected(Id),
	  misk_select(ID,GroupId),
	  sumFiles(Directory,Sum, BPC),
	fail.  % sum for each selected (binary allows sum over backtracking)
  get_size_one_group2(_,_,_).
  
  get_size_one_group_str(GroupId,Str,CTL):-
 	get_size_one_group(GroupId,Size),
 	Size2=Size div 1024,
	mark_invisible(Size,CTL),
	size_str(GroupId,Size2,Str),
	!.

  size_str(Id,0,""):-
  	bad_group(Id),
  	!.
  size_str(Id,0,""):-
  	assert(bad_group(Id)),
  	!.
  size_str(_,Size2,STR):-
	format(Str,"%D Kb",Size2).
	/*term_str ( long, Size2, Size3 ), %str_long(Size3,Size2), %str_long is not supported
	concat(Size3," Kb",Str),!.*/
/************************************************************************
 Add up size requirements for the currently selected group(s)
 ************************************************************************/
  sumTree(Sum,Path):-
	file_GetDiskFree(Path,BytesPerCluster,_,_),
	%BytesPerCluster= 4096,
	iScript(install_group(Id, Directory)),		%30.05.96
	  selected(Id),
	  sumFiles(Directory,Sum, BytesPerCluster),
	fail.  % sum for each selected (binary allows sum over backtracking)
  sumTree(_,_).

ifdef os_dos
predicates
 determ  check_bpc_error(WORD ax,WORD cx,WORD BytesPerCluster)
  
clauses
  check_bpc_error($ffff,_,_):-
	!,fail.	%dos fn 36h returned error(drive not valid)
  check_bpc_error(AX,CX,BPC):-
	!,
	BPC=AX*CX.

  file_findAllocUnitSize(DriveLetter,BPC,TOTAL):-
	upper_lower(DRL1,DriveLetter),	      % Based on Dos fn 36h (Get drive free space)
	DX_I = cast(word,DRL1) - 64,	      % Expects Ah= 36h Dl= Drive number 0- current,1-A, etc
	bios($21,reg($3600,0,0,DX_I,0,0,0,0), % Returns Ax= 0FFFFh if drive in Dl not vaild drive 
		 reg(AX,_,CX,DX,_,_,_,_),_),  % Ax= sectors per cluster Cx= bytes per sector
	check_bpc_error(AX,CX,BPC),
	EDX=cast(ulong,DX),
	EBPC=cast(ulong,BPC),
	TOTAL=EDX*EBPC.
elsedef
 ifdef os_os2
  file_FindAllocUnitSize(DriveLetter,BPC,Total):-

    APIRET= dTF_GetDriveInfo(DriveLetter,BPC,_avail,Total),
    APIRET=0,!.
 elsedef
 % stub for win32 bit
  file_FindAllocUnitSize(DriveLetter,BPC,Total):-
	frontChar(Path,DriveLetter,":\\"),
	ApiRet = winNT_GetDiskFreeSpace(Path,SecPerClu,BPerSec,_FreeCl,TotCl),
	ApiRet = b_True,
	BPC = SecPerClu*BPerSec,
	Total = BPC*TotCl,
  !.
  	
 enddef
enddef

predicates
  lp2float(binary PULarge,uLong)-procedure(i,o) % for PUlarge integers
clauses
  lp2float(LPI,R):-
	D1 = val(real, getdwordentry(LPI, 0)),
	D2 = val(real, getdwordentry(LPI, 1)),
	R2 = (D1+(D2*4294967296))/1024,
	R = val(ulong,R2).

predicates
  cut_NetworkPath(string Path,string Drive)-procedure(i,o)
clauses
  cut_NetworkPath(Path,UNCDrive):-
	% if path is "\\CompName\shareDir\x\..."
	% return only \\CompName\shareDir\"
	frontStr(2,Path,Slash,CName),
	Slash = "\\\\",
	searchChar(Cname,'\\',Pos1),
	frontStr(Pos1,Cname,F,T),
	searchChar(T,'\\',Pos2),
	frontStr(Pos2,T,X,_),
	!,
	format(UNCDrive,"\\\\%s%s",F,X).
  cut_NetworkPath(Path,Drive):-
	% if drive "X:\...."
	%then return "X:\"
	frontStr(3,Path,Drive,_),
	frontChar(Drive,_,":\\"),
	!.
  cut_NetworkPath(X,X).


ifdef os_dos
  file_GetDiskFree(Path,BPC,FreeKB,TotalKB):-
	frontchar(Path,DriveLetter,_),
	upper_lower(DRL1,DriveLetter),	      % Based on Dos fn 36h (Get drive free space)
	DX_I = cast(word,DRL1) - 64,	      % Expects Ah= 36h Dl= Drive number 0- current,1-A, etc
	bios($21,reg($3600,0,0,DX_I,0,0,0,0), % Returns Ax= 0FFFFh if drive in Dl not vaild drive 
		 reg(AX,BX,CX,DX,_,_,_,_),_), % Ax= sectors per cluster Cx= bytes per sector
	check_bpc_error(AX,CX,BPC),
	!,
	EDX=cast(ulong,DX),
	EBPC=cast(ulong,BPC),
	EBX = cast(ulong,BX),
	TotalKB=(EDX*EBPC) div 1024,
	FreeKB=(EBX*EBPC) div 1024.
	
enddef

ifdef os_nt
  file_GetDiskFree(Path,ByesPerCl,FreeKB,TotalKB):-
	HKernel = winNT_GetModuleHandle("kernel32.dll"),
	H = winNT_GetProcAddress(HKernel,"GetDiskFreeSpaceExA"),
	H<>0,
	B1 = makeBinary(8),
	B2 = makeBinary(8),
	B3 = makeBinary(8),
	GetDiskSpace = cast(wapi_getDiskSpace,H),
	cut_NetworkPath(Path,UNCDrive),
	0 <> GetDiskSpace(UNCDrive,B1,B2,B3),
	!,
	lp2float(B1,FreeKB),
	lp2float(B2,TotalKB),
	ByesPerCl = 512.
	
  file_GetDiskFree(Path,BPC,FreeKB,TotalKB):-
	0 <> winNT_GetDiskFreeSpace(Path,SecPerClu,BPerSec,FreeCl,TotCl),
	BPC = SecPerClu*BPerSec,
	TotalKB = (BPC*TotCl) div 1024,
	FreeKB = (BPC*FreeCl) div 1024,
  	!.
enddef
ifdef os_os2
  file_GetDiskFree(Path,BPC,FreeKB,TotalKB):-
	frontChar(Path,Drive,R),
	frontChar(R,':',_),
	0 = dTF_GetDriveInfo(Drive,BPC,Avail,Total),
	!,
	FreeKB = Avail div 1024,
	TotalKB = Total div 1024.
 enddef
  file_GetDiskFree(_,0,0,0).

%% factor in the allocation unit size for the target drive

  addTo(Sum,Amount):-
	New=GetDwordEntry(Sum,0)+Amount,
	SetDwordEntry(Sum,0,New).

   % count the number of entries in a directory (also takes up space!)

  sumfiles([small_file(_,Size,_,_,_,_,_)|T],Sum,BPC):-
	occupiesOnDisk(Size,Asize,BPC),
	addto(Sum,ASize),
	sumfiles(T,Sum,BPC).

  sumfiles([large_file(_,Size,_,_,_,_,_)|T],Sum,BPC):-
	occupiesOnDisk(Size,Asize,BPC),
	addto(Sum,ASize),
	sumfiles(T,Sum,BPC).
  sumfiles([subdir(_,Dir)|T],Sum,BPC):-
	file_entriesInDir(Dir,2,Entries), % start count w/ 2 for "." & ".."
	Size4Dir=32*Entries,
	occupiesOnDisk(Size4Dir, ActualSize, BPC),
	addto(Sum,ActualSize),    % add a cluster for the directory
	sumfiles(Dir, Sum,BPC),
	sumfiles(T,Sum,BPC).
  sumfiles([],_,_).



predicates			   % by MZ 11.09.96 new algorythm of ProgressBar !
  determ sumTree2(binary Sum)		   % calculate file sum of selected items
  determ sumFiles2(directory, binary Sum) % not use 'BPC',add only raw size of file
clauses				   % directory size ignored
  sumTree2(Sum):-
	iScript(install_group(Id, Directory)),
	  selected(Id),
	  sumFiles2(Directory,Sum),
	  fail.
  sumTree2(_).

  sumfiles2([small_file(_,Size,_,_,_,_,_)|T],Sum):-
	addto(Sum,Size),
	sumfiles2(T,Sum).

  sumfiles2([large_file(_,Size,_,_,_,_,_)|T],Sum):-
	addto(Sum,Size),
	sumfiles2(T,Sum).
  sumfiles2([subdir(_,Dir)|T],Sum):-
	sumfiles2(Dir, Sum),
	sumfiles2(T,Sum).
  sumfiles2([],_).



  file_SetSpaceValue(Required,Left):-
	retractall(spaceRequired(_)),
	assert(spaceRequired(Required)),
	retractall(spaceLeft(_)),
	assert(spaceLeft(Left)).



predicates
 determ string get_notExistFileName(char Drive)
 determ read_only_test(integer)
clauses
  get_notExistFileName(DRIVE,NAME):-
	for(C,0,9999),
	  format(NAME,"%c:\\%s.$$$",DRIVE,C),
	  not(trap(existfile(NAME),_,fail)),
	!.
	
  file_IsDriveNoReadOnly(Drive):-
	NAME = get_notExistFileName(DRIVE),
	Str="1",
	trap(file_str(Name,Str),Err,read_only_test(Err)),
	trap(deletefile(Name),_,fail),
	!.
  read_only_test(7019):-
	!,
	dlg_note("Drive is write protected"),
	fail.
  read_only_test(7005):-
	!,
	dlg_note("access denied"),
	fail.
  read_only_test(Error):-
	format(MSG,"Error No:%d on drive",Error),
	dlg_note(MSG),
	fail.
  
  file_echo_file(FileName):-
	install_work_now,
	progress_w(Win),
	CtrlWin=win_GetCtlHandle(Win,file_idc_file),
	win_SetText(CtrlWin,FileName),
	vpi_processEvents(1),
	file_pathReduce(Win,file_idc_file),
	!.
  file_echo_file(_).


predicates
  nondeterm for_step(long Counter,long Start,long Stop, long Step)
clauses
  for_step(I,I,_,_).
  for_step(I,J,K,S):-
	J<K,
	!,
	J2=J+S,
	for_step(I,J2,K,S).

  file_DrawBlueWin(_Win,rct(X0,Y0,X1,Y1)):-
	Client=win_GetClientRect(_Win),
	Client=rct(_,_,_,Ymax),
	Step=10,
	Xdraw1=X0-1,Xdraw2=X1+1,
	StartLine=val(long,trunc(Y0/Step)*Step),
	for_Step(I,StartLine,Y1,Step),
	  Color1=((255*I) div Ymax), 		% calc color intens.
	  bitXor(Color1,0xFF,Color2),		% inverse intens.
	  Color= Color2 * 0x10000,		% convert I to blue color
	  win_SetPen(_Win,pen(0,ps_Hollow,Color)),
	  win_setBrush(_Win,brush(pat_Solid,Color)),
	  Y=I+Step+1,	% 1- thickness
	  Ydraw=I-1,
	  draw_rect(_Win,rct(Xdraw1,Ydraw,Xdraw2,Y)),
	fail.
/*********************************************
 Convert Long to String with comma
**********************************************/
predicates
  determ insert_pos(integer,string)
  determ integer insert_comma(string,string) -(i,o)
% STRING file_longToSplitString(ULONG)-(i)
clauses
  insert_pos(3,","):-!.
  insert_pos(6,","):-!.
  insert_pos(9,","):-!.
  insert_pos(_,"").
 
  insert_comma(InStr,"",0):-
 	str_len(InStr,0),
 	!.
  insert_comma(InStr,Out2,N2):-
	frontchar(InStr,Ch,Rest),
	N=insert_comma(Rest,Get),
	N2=N+1,
	insert_pos(N,INS),
	format(Out2,"%c%s%s",Ch,Ins,Get).
	

  file_longToSplitString(ULONG,Split):-
ifdef ws_win
	Split = numberFormat( ULONG ).
elsedef
	term_str ( long, Ulong, Str ), %str_long(Str,Ulong), %str_long is not supported
	insert_comma(STR,SPLIT).
enddef

/**************************************************************************
			DYN DIALOGS PART
**************************************************************************/

    /***************************************************
		Event handlers from dynamical  dialogs
    ****************************************************/
predicates
  dlg_disk_change_eh	: ehandler
  dlg_readonly_eh	: ehandler
  dlg_license_eh	: ehandler
  dlg_installation_in_progress_eh : ehandler
  dlg_cancelation_eh	: ehandler
clauses
%         Disk Change         

  dlg_disk_change_eh(_Win,e_CloseRequest,0):-
	!.
  dlg_disk_change_eh(_Win,e_Control(idc_cancel,_CT,_CW,_CI),0):-
	dlg_cancelation_Create(_Win),
	not(install_work_now),
	!,
	progress_w(PWin),
	win_destroy(PWin),
	win_destroy(_Win).
  dlg_disk_change_eh(_Win,e_Control(idc_cancel,_CT,_CW,_CI),0):-
	!.
  dlg_disk_change_eh(_Win,e_Control(idc_ok,_CT,_CW,_CI),0):-
	!,
	win_Destroy(_Win).

%          Read Only          
  dlg_readonly_eh(_Win,e_CloseRequest,0):-
	!.
  dlg_readonly_eh(_Win,e_Create(_),0):-
	!,
	file_pathReduce(_Win,file_idct_filename).

  dlg_readonly_eh(_Win,e_Control(file_idc_skip,_CT,_CW,_CI),0):-
	!,
	win_destroy(_Win).

  dlg_readonly_eh(_Win,e_Control(idc_cancel,_CT,_CW,_CI),0):-
  	dlg_cancelation_Create(_Win),
	not(install_work_now),
	!,
	progress_w(PWin),
	win_destroy(PWin),
	win_destroy(_Win).
  dlg_readonly_eh(_Win,e_Control(idc_cancel,_CT,_CW,_CI),0).

%           License            

  dlg_license_eh(_Win,e_CloseRequest,0):-
	!,
	dlg_cancelation_create(_Win).		% was Tw 


  dlg_license_eh(Win,e_Create(_),0):-
ifdef ws_win
	OK =win_GetCtlHandle(Win, idc_ok),
	win_SetFocus(OK),
enddef
	license_txt(STR),
	!,
	%trap(file_str("LICENSE.TXT",Str),_,dlg_note("Fail: Read License!")),
	%deletefile("LICENSE.TXT"),
	%STR= "it is a license ",
	TWin =win_GetCtlHandle(Win, file_idc_edit),
	win_SetText(TWin,STR),
	win_SelectText(TWin, 0, 0).

  dlg_license_eh(_Win,e_Control(idc_ok,_CT,_CW,_CI),0):-
	!,
	%dlg_note("IDC_OK in LICense"),
	%win_destroy(_Win),
	TW = vpi_GetTaskWin(),
	win_PostEvent(TW,e_Menu(id_file_start,0)),
	win_PostEvent(TW,e_Menu(id_file_dlg1,0)),
	fail.
	%dlg_note("license:Events was post").

  dlg_license_eh(_Win,e_Control(idc_cancel,_CT,_CW,_CI),0):-
	!,
	dlg_cancelation_create(_Win).%before 20.05.96 was TW 

/*************************
Install P.
**************************/

  dlg_installation_in_progress_eh(_Win,e_CloseRequest,0):-
	!.
  dlg_installation_in_progress_eh(_Win,e_Destroy,0):-
	!,
	retractall(progress_w(_Win)).

  dlg_installation_in_progress_eh(_Win,e_Control(idc_cancel,_CT,_CW,_CI),0):-
	not(install_work_now),
	!,
	Button = dlg_Ask("Exit?",["Yes","No"]),
	Button = resp_default,
	win_destroy(_Win),
	TWin = vpi_GetTaskWin(),
	win_postEvent(TWin,e_menu(id_file_task_Destroy,0)).

  dlg_installation_in_progress_eh(_Win,e_Control(idc_cancel,_CT,_CW,_CI),0):-
	dlg_cancelation_Create(_Win),
	not(install_work_now),
	!,
	retractall(progress_w(_Win)),	%add 20.05.96
	win_destroy(_Win).

  dlg_installation_in_progress_eh(Win,e_Create(_),0):-
	!,
	assert(progress_w(Win)),
	PCCWIN = win_GetCtlHandle(Win,file_idc_progress),%\add 12.09.96
	progress_bar_set_value(PCCWIN,0,0).		 %/MZ


%         Cancelation         

  dlg_cancelation_eh(_Win,e_CloseRequest,0):-
	!.
/*  dlg_cancelation_eh(_Win,e_Control(CONTROL_ID,_,_,_),0):-
%	write("CONTROL_ID:",CONTROL_ID," in cancelation \n"),
	fail.*/
  dlg_cancelation_eh(_Win,e_Control(idc_cancel,_,_,_),0):-
	!,
%	write("idc_cancel in cancelation \n"),
	win_destroy(_Win).

  dlg_cancelation_eh(_Win,e_Control(idc_ok,_CT,_CW,_CI),0):-
	progress_w(_),
	!,
	retractall(install_work_now),
	win_Destroy(_Win).
  dlg_cancelation_eh(_Win,e_Control(idc_ok,_CT,_CW,_CI),0):-
	space_removeDlg,
	Parent=win_GetParent(_Win),
	win_Destroy(_Win),
	%vpi_processEvents(1),			%add 20.05.96
	win_Destroy(Parent),
	%vpi_processEvents(1),			%add 20.05.96
	TW = vpi_GetTaskWin(),
	win_postEvent(TW,e_menu(id_file_task_destroy,0)),%add 20.05.96
	!.


/**************************************************************************
	Windows Creation dialog: Disk Change
**************************************************************************/

constants
  dlg_disk_change_DlgType = wd_Modal
  dlg_disk_change_Title = "Visual Prolog Installation"
  dlg_disk_change_Flags = [wsf_TitleBar]
  dlg_disk_change_Help = Contents
  
clauses

  dlg_disk_change_Create(Parent,DiskName):-
	dialog_Create(Parent,
		[
ifdef	ws_win	

		 dlg(wdef(dlg_disk_change_DlgType,rct(17,19,164,108),dlg_disk_change_Title,u_DlgBase),dlg_disk_change_Flags),
		 ctl(wdef(wc_PushButton,rct(18,61,60,75),"Continue",u_DlgBase),idc_ok,[wsf_TabStop]),
		 ctl(wdef(wc_PushButton,rct(79,61,121,75),"Cancel",u_DlgBase),idc_cancel,[wsf_TabStop]),
		 ctl(wdef(wc_Text,rct(14,16,136,25),"Please insert the following disk:",u_DlgBase),-1,[wsf_AlignCenter]),
		 ctl(wdef(wc_Edit,rct(29,30,117,42),DiskName,u_DlgBase),file_id_disk_name,[wsf_AlignLeft,wsf_Disabled])
enddef
ifdef os_os2
		 dlg(wdef(dlg_disk_change_DlgType,rct(17,19,176,92),dlg_disk_change_Title,u_DlgBase),dlg_disk_change_Flags),
		 ctl(wdef(wc_PushButton,rct(95,46,145,60),"Continue",u_DlgBase),idc_ok,[wsf_TabStop]),
		 ctl(wdef(wc_PushButton,rct(10,46,60,60),"Cancel",u_DlgBase),idc_cancel,[wsf_TabStop]),
		 ctl(wdef(wc_Text,rct(10,10,145,19),"Please insert the following disk:",u_DlgBase),-1,[wsf_AlignLeft]),
		 ctl(wdef(wc_Edit,rct(10,24,145,36),DiskName,u_DlgBase),file_id_disk_name,[wsf_AlignLeft])
enddef
		],
  		[
		],
		dlg_disk_change_eh,0,_VALLIST,_ANSWER).


/**************************************************************************
	Windows Creation dialog: readonly
**************************************************************************/

constants

  dlg_readonly_DlgType = wd_Modal
  dlg_readonly_Title = "WARNING!"
  dlg_readonly_Flags = [wsf_TitleBar,wsf_ClipSiblings]
  dlg_readonly_Help = Contents

clauses

  dlg_readonly_Create(Parent,FILENAME):-
	dialog_Create(Parent,
		[
ifdef ws_win
		 dlg(wdef(dlg_readonly_DlgType,rct(50,40,220,115),dlg_readonly_Title,u_DlgBase),dlg_readonly_Flags),
		 ctl(wdef(wc_PushButton,rct(7,54,47,66),"Rewrite",u_DlgBase),idc_ok,[wsf_Default,wsf_Group,wsf_TabStop]),
		 ctl(wdef(wc_PushButton,rct(64,54,104,66),"Skip",u_DlgBase),file_idc_skip,[wsf_Group,wsf_TabStop]),
		 ctl(wdef(wc_PushButton,rct(120,54,160,66),"Cancel",u_DlgBase),idc_cancel,[wsf_Group,wsf_TabStop]),
		 ctl(wdef(wc_Text,rct(7,5,161,14),"The following file is marked Read Only",u_DlgBase),file_idct_static_text,[wsf_AlignCenter]),
		 ctl(wdef(wc_Text,rct(7,36,161,45),"Do you stil wish to rewrite it ?",u_DlgBase),file_idct_static_text1,[wsf_AlignCenter]),
		 ctl(wdef(wc_Text,rct(7,21,161,30),FILENAME,u_DlgBase),file_idct_filename,[wsf_AlignCenter])
enddef
ifdef os_os2
		 dlg(wdef(dlg_readonly_DlgType,rct(50,40,230,113),dlg_readonly_Title,u_DlgBase),dlg_readonly_Flags),
		 ctl(wdef(wc_PushButton,rct(7,54,52,66),"Rewrite",u_DlgBase),idc_ok,[wsf_Default,wsf_Group,wsf_TabStop]),
		 ctl(wdef(wc_PushButton,rct(67,54,112,66),"Skip",u_DlgBase),file_idc_skip,[wsf_Group,wsf_TabStop]),
		 ctl(wdef(wc_PushButton,rct(127,54,172,66),"Cancel",u_DlgBase),idc_cancel,[wsf_Group,wsf_TabStop]),
		 ctl(wdef(wc_Text,rct(7,5,172,14),"The following file is marked Read Only",u_DlgBase),file_idct_static_text,[wsf_AlignCenter]),
		 ctl(wdef(wc_Text,rct(7,36,172,45),"Do you stil wish to rewrite it ?",u_DlgBase),file_idct_static_text1,[wsf_AlignCenter]),
		 ctl(wdef(wc_Text,rct(7,21,172,30),FileName,u_DlgBase),file_idct_filename,[wsf_AlignCenter])
enddef

		],
  		[
		],
		dlg_readonly_eh,0,_VALLIST,_ANSWER).

/**************************************************************************
	Windows Creation dialog: license
**************************************************************************/

constants

  dlg_license_DlgType = wd_Modal
  dlg_license_Title = "License"
  dlg_license_RCT = rct(10,50,328,255)
  dlg_license_Flags = [wsf_TitleBar,wsf_ClipSiblings]
  dlg_license_Help = idh_contents
  dlg_license_Font = "System"
  dlg_license_FSize = 10

clauses

  dlg_license_Create(Parent,Str):-
  ifdef setup_use_screen
	P1 = cast(window,vpi_getAttrVal(attr_screen_window)),
	PWRC = win_GetOuterRect(P1),
  	PWRC1= rect_GetClient([],b_false,PWRC),
  elsedef
	PWRC = win_GetOuterRect(Parent),
  	PWRC1= rect_GetClient([wsf_titlebar,wsf_Border],b_false,PWRC),
  enddef
  	PWRC1 = rct(Xs1,Ys1,XsD1,YsD1),
  	CRct = rct(10,50,328,255),
	CRct = rct(X1,Y1,X2,Y2),
	vpi_GetBaseUnits(DlgBaseWidth,DlgBaseHeigth),
	bitLeft(Xs1,2,Xs2),	% mul by 4
	bitLeft(Ys1,3,Ys2),	% mul by 8
	bitLeft(XsD1,2,XsD2),	% mul by 4
	bitLeft(YsD1,3,YsD2),	% mul by 8
	Xs=Xs2 div DlgBaseWidth,
	Ys=Ys2 div DlgBaseHeigth,
	XsD=XsD2 div DlgBaseWidth,
	YsD=YsD2 div DlgBaseHeigth,	/*Screen dimensions on dlg unit */
	
	DlgX = X2 - X1,			/* Dialogs dimensions*/
	DlgY = Y2 - Y1,			/* Screen  dimensions*/

	ScrX = XsD - Xs,
	ScrY = YsD - Ys,
	ifdef ws_win
	X = (ScrX- DlgX) div 2,
	Y = (ScrY- DlgY) div 2,
	elsedef
	X = (ScrX- DlgX) div 2,
	Y = (ScrY- DlgY) div 3+15,
	enddef
	Xn = X + DlgX,
	Yn = Y + DlgY,
	
	DRct = rct(X,Y,Xn,Yn),

	retractall(license_txt(_)),
	assert  (license_txt(STR)),
	
	
%MARK license, new variables

	dialog_Create(Parent,
		[
		 dlg_font(wdef(dlg_license_DlgType,DRCT,dlg_license_Title,u_DlgBase),
		 	  dlg_license_Font,dlg_license_FSize,dlg_license_Flags),
ifdef ws_win

		 ctl(wdef(wc_PushButton,rct(10,183,125,195),"Accept License Agreement",u_DlgBase),idc_ok,[wsf_Default,wsf_Group,wsf_TabStop]),
		 ctl(wdef(wc_PushButton,rct(138,183,178,195),"Cancel",u_DlgBase),idc_cancel,[wsf_Group,wsf_TabStop]),
		 ctl(wdef(wc_Edit,rct(4,5,309,178),"",u_DlgBase),file_idc_edit,[wsf_AlignLeft,wsf_Group,wsf_TabStop,wsf_MultiLine,wsf_VScroll,wsf_AutoVScroll,wsf_ReadOnly])
enddef
ifdef os_os2
		 ctl(wdef(wc_PushButton,rct(5,184,125,196),"Accept License Agreement",u_DlgBase),idc_ok,[wsf_Default,wsf_Group,wsf_TabStop]),
		 ctl(wdef(wc_PushButton,rct(138,184,178,196),"Cancel",u_DlgBase),idc_cancel,[wsf_Group,wsf_TabStop]),
		 ctl(wdef(wc_Edit,rct(5,6,310,179),"",u_DlgBase),file_idc_edit,[wsf_AlignLeft,wsf_Group,wsf_TabStop,wsf_MultiLine,wsf_VScroll,wsf_AutoVScroll/*,wsf_ReadOnly*/])
enddef
		],
  		[
		],
		dlg_license_eh,0,_VALLIST,ANSWER),
	ANSWER = idc_ok.


/**************************************************************************
	Windows Creation dialog: Installation In Progress
**************************************************************************/

constants
  dlg_installation_in_progress_DlgType = wd_Modeless
  dlg_installation_in_progress_Title = "Installation in Progress"
  dlg_installation_in_progress_RCT = rct(50,50,264,162)
  dlg_installation_in_progress_Flags = [wsf_TitleBar]
  dlg_installation_in_progress_Help = Contents
  dlg_installation_in_progress_Font = "System"
  dlg_installation_in_progress_FSize = 10

clauses
  dlg_installation_in_progress_Create(_):-
	SUM=makeBinary(5),
	sumTree2(Sum),
	RealSum=getDwordEntry(SUM,0),
	retractall(spaceBySumTree2(_)),
	assert(spaceBySumTree2(RealSum)),
	assert(spaceLeft2(0)),
	fail.
	
  dlg_installation_in_progress_Create(Parent):-
	space_removeDlg, 
	win_CreateDynDialog(Parent,
		[

%ifdef ws_win
		 dlg_font(wdef(dlg_installation_in_progress_DlgType,dlg_installation_in_progress_RCT,dlg_installation_in_progress_Title,u_DlgBase),
		 	  dlg_installation_in_progress_Font,dlg_installation_in_progress_FSize,dlg_installation_in_progress_Flags),
		 ctl(wdef(wc_PushButton,rct(50,92,154,106),"Cancel Installation",u_DlgBase),idc_cancel,[wsf_TabStop,wsf_Default]),
		 ctl(wdef(wc_Edit,rct(105,38,204,50),"Edit",u_DlgBase),file_idc_rem_disk_space,[wsf_AlignLeft,wsf_TabStop,wsf_ReadOnly,wsf_Disabled]),
		 ctl(wdef(wc_Text,rct(10,25,65,33),"Copying File:",u_DlgBase),file_idct_copying_file,[wsf_AlignLeft,wsf_Group]),
		 ctl(wdef(wc_Edit,rct(72,23,204,35),"file",u_DlgBase),file_idc_file,[wsf_AlignLeft,wsf_Disabled]),
		 ctl(wdef(wc_Text,rct(9,40,104,48),"Remaining disk space:",u_DlgBase),file_idct_available_disk_space,[wsf_AlignLeft]),
		 ctl(wdef(wc_Text,rct(9,54,39,62),"Progress",u_DlgBase),file_idct_progress_indicator,[wsf_AlignLeft]),
		 customctl(wdef(wc_Custom,rct(9,65,204,78),"Progress",u_DlgBase),"PROGRESS",file_idc_progress,[]),
		 ctl(wdef(wc_GroupBox,rct(5,10,208,86),"Installation Information",u_DlgBase),file_idc_installation_information,[])
/*enddef		% remed by MZ 25.03.97
*/
		],dlg_installation_in_progress_eh,0),
	TW = vpi_GetTaskWin(),
	win_postevent(Tw,e_menu(id_file_inst,0)).

/**************************************************************************
	Windows Creation dialog: Cancelation
**************************************************************************/

constants

  dlg_cancelation_DlgType = wd_Modal
  dlg_cancelation_Title = "Visual Prolog"
  dlg_cancelation_Flags = [wsf_TitleBar]
  dlg_cancelation_Help = Contents

clauses


  dlg_cancelation_Create(Parent):-
	win_CreateDynDialog(Parent,
		[
ifdef ws_win
		 dlg(wdef(dlg_cancelation_DlgType,rct(44,36,158,112),dlg_cancelation_Title,u_DlgBase),dlg_cancelation_Flags),
		 ctl(wdef(wc_PushButton,rct(15,38,100,52),"Yes, cancel!",u_DlgBase),idc_ok,[wsf_TabStop,wsf_Default]),
		 ctl(wdef(wc_PushButton,rct(15,56,100,70),"No, Continue Installation",u_DlgBase),idc_cancel,[wsf_TabStop]),
		 ctl(wdef(wc_Text,rct(12,8,102,34),"Installation is incomplete! Are you sure you want to cancel?",u_DlgBase),-1,[wsf_AlignCenter])
enddef
ifdef os_os2
		 dlg(wdef(dlg_cancelation_DlgType,rct(44,36,184,112),dlg_cancelation_Title,u_DlgBase),dlg_cancelation_Flags),
		 ctl(wdef(wc_PushButton,rct(15,39,125,53),"Yes, cancel!",u_DlgBase),idc_ok,[wsf_TabStop]),
		 ctl(wdef(wc_PushButton,rct(15,56,125,70),"No, Continue Installation",u_DlgBase),idc_cancel,[wsf_TabStop]),
		 ctl(wdef(wc_Text,rct(10,5,130,14),"Installation is incomplete!",u_DlgBase),-1,[wsf_AlignCenter]),
		 ctl(wdef(wc_Text,rct(10,16,130,25),"Are you sure you want to",u_DlgBase),-2,[wsf_AlignCenter]),
		 ctl(wdef(wc_Text,rct(10,27,130,36),"cancel?",u_DlgBase),-3,[wsf_AlignCenter])
enddef
		],dlg_cancelation_eh,0).



ifdef id_debug_write_log
  file_open_log():-
	safe_OpenWrite(log_File,"setup.log"),
  	fileMode(log_File,1),
  	!.
enddef
  file_open_log().
  
ifdef id_debug_write_log
  file_close_log():-
	closeFile(log_File),
	!.
enddef
  file_close_log().
	
	
	
ifdef id_debug_write_log
  file_write_log_msg(MSG):-
	dlg_note(MSG),
	writeDevice(Was),
	writeDevice(log_File),
	trap(write(MSG),_,writeDevice(Was)),
	writeDevice(Was),
	!.
enddef
  file_write_log_msg(_).
