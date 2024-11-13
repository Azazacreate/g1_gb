/*****************************************************************************

	(c) Copyright 1984 - 2000 Prolog Development Center A/S

 Project:  BUILD
 FileName: BUILDv.PRO
 Purpose: 
 Written by: Michael Zaichenko
 Comments:
******************************************************************************/

ifndef	iodecl_con_included
 #error "iodecl.con" should be included
enddef

constants
   binary_filemode_flag=0
   blockSize=0xFE80
   max_Disks = 40

% resource
  build_idc_file_meter		= 200
  build_idc_total_meter		= 201
  build_idc_current_file	= 202
  build_idct_current_file 	= 203
  build_idct_total_progress	= 204

domains
 cmd_switch = 	p(char P16,char P32);
 		make_DSet(boolean);
 		make_image(boolean);
 		v(ulong)



database - local
  temp_files_size(long)
  fdir32_IS(build_igrp)
  fdir16_IS(build_igrp)
  determ volume_size(long)
  determ process_dlg(window,window,window,window)
  determ build_is_work

database - user_config
  single  exclude_all(slist)
  single  make_script(build_make_script)
  single  v_packed_ratio(ulong,ulong)
  copy_files_script(slist,integer)
  determ t_path(string)				% path!
  have_sw(cmd_switch)
  


predicates
  safe_OpenWrite(file,string)-procedure(i,i)
  safe_OpenWrite2(file,string,binary)-procedure(i,i,i)
  safe_OpenRead(file,string)-procedure(i,i)
  safe_Openread2(file,string,binary)-procedure(i,i,i)

  safe_WriteBlock(string,unsigned,binary)-procedure(i,i,i)
  safe_WriteBlock2(string,unsigned,binary,binary)-procedure(i,i,i,i)

  determ general_Cancel() 
  
  procedure dlg_cancelation_Create(window)-(i)
  dlg_cancelation_eh : ehandler
 
clauses

  general_Cancel():-
	TWin = vpi_GetTaskWin(),
	dlg_cancelation_Create(TWin),
	not(build_is_work),
	process_dlg(PWin,_,_,_),
	win_destroy(PWin).


  safe_OpenWrite(File,Name):-
	Flag = makeBinary(4),
	safe_openWrite2(File,Name,FLAG).

  safe_OpenWrite2(File,Name,FLAG):-
  	F=getDwordEntry(Flag,0),
  	F=0, 			%check previous error 
	setDwordEntry(Flag,0,0),
 	trap(openWrite(File,Name),Err,setDwordEntry(Flag,0,Err)),
 	!.
 
  safe_OpenWrite2(File,Name,Flag):-	% when come here flag should contain error number
 	ErrNum = getDwordEntry(Flag,0),
	format(Err,"Can not open file:\n%s\nfor writing.\nError number: %U",Name,ErrNum),
	RetVal = dlg_MessageBox("build Error",Err,
				mesbox_IconQuestion,
				mesbox_ButtonsRetryCancel,
				mesbox_DefaultFirst,
				mesbox_SuspendApplication),
	RetVal = 1,
	!,	
	setDwordEntry(Flag,0,0),	%clear flag and  try again
	safe_OpenWrite2(File,Name,Flag).
  safe_OpenWrite2(_,_,_):-
	general_Cancel(),
	!.
  safe_OpenWrite2(File,Name,Flag):-
 	safe_openWrite2(File,Name,Flag).

  safe_WriteBlock(FileName,Bytes,Block):-
	FLAG = makeBinary(4),
	safe_WriteBlock2(FileName,Bytes,Block,FLAG).


  safe_WriteBlock2(_FileName,Bytes,Block,FLAG):-
  	F=getDwordEntry(Flag,0),
  	F=0, 			%check previous error 
	setDwordEntry(Flag,0,0),
 	trap(writeBlock(Bytes,Block),Err,setDwordEntry(Flag,0,Err)),
 	!.
  safe_WriteBlock2(FileName,Bytes,Block,FLAG):-
 	ErrNum = getDwordEntry(Flag,0),
	format(Err,"Can not write to file:\n%s\nError number: %U",FileName,ErrNum),
	RetVal = dlg_MessageBox("Build Error",Err,
				mesbox_IconQuestion,
				mesbox_ButtonsRetryCancel,
				mesbox_DefaultFirst,
				mesbox_SuspendApplication),
	RetVal = 1,
	!,	
	setDwordEntry(Flag,0,0),	%clear flag and  try again
  safe_WriteBlock2(FileName,Bytes,Block,FLAG).
	
  safe_WriteBlock2(_,_,_,_):-
	general_Cancel(),
	!.
  safe_WriteBlock2(FileName,Bytes,Block,FLAG):-
	safe_WriteBlock2(FileName,Bytes,Block,FLAG).



  safe_OpenRead(File,Name):-
	Flag = makeBinary(4),
	safe_openRead2(File,Name,FLAG).

  safe_OpenRead2(File,Name,FLAG):-
  	F=getDwordEntry(Flag,0),
  	F=0, 			%check previous error 
	setDwordEntry(Flag,0,0),
 	trap(openRead(File,Name),Err,setDwordEntry(Flag,0,Err)),
 	!.
 
  safe_OpenRead2(File,Name,Flag):-	% when come here flag should contain error number
 	ErrNum = getDwordEntry(Flag,0),
	format(Err,"Can not open file:\n%s\nfor reading.\nError number: %U",Name,ErrNum),
	RetVal = dlg_MessageBox("build Error",Err,
				mesbox_IconQuestion,
				mesbox_ButtonsRetryCancel,
				mesbox_DefaultFirst,
				mesbox_SuspendApplication),
	RetVal = 1,
	!,	
	setDwordEntry(Flag,0,0),	%clear flag and  try again
	safe_OpenRead2(File,Name,Flag).
  safe_OpenRead2(_,_,_):-
	general_Cancel(),
	!.
  safe_OpenRead2(File,Name,Flag):-
 	safe_openRead2(File,Name,Flag).



predicates
  procedure downTotalMeter()
clauses
  downTotalMeter():-
	process_dlg(Win,_,_,_),
	W1 = win_GetCtlHandle(Win,build_idc_total_meter),
	W2 = win_GetCtlHandle(Win,build_idct_total_progress),
	win_SetState(W1,[wsf_Disabled]),
	win_SetState(W1,[wsf_Invisible]),
	win_SetState(W2,[wsf_Disabled]),
	win_SetState(W2,[wsf_Invisible]),
	!.
  downTotalMeter().


/**************************************************************************
	Windows Creation dialog: Cancelation
**************************************************************************/

constants

  dlg_cancelation_DlgType = wd_Modal
  dlg_cancelation_Title = "Build"
  dlg_cancelation_Flags = [wsf_TitleBar]

clauses

  dlg_cancelation_Create(Parent):-
	win_CreateDynDialog(Parent,
		[
ifdef ws_win
		 dlg(wdef(dlg_cancelation_DlgType,rct(44,36,158,112),dlg_cancelation_Title,u_DlgBase),dlg_cancelation_Flags),
		 ctl(wdef(wc_PushButton,rct(15,38,100,52),"YES, Cancel!",u_DlgBase),idc_ok,[wsf_TabStop,wsf_Default]),
		 ctl(wdef(wc_PushButton,rct(15,56,100,70),"No, Continue Installation",u_DlgBase),idc_cancel,[wsf_TabStop]),
		 ctl(wdef(wc_Text,rct(12,8,102,34),"Installation is incomplete! Are you sure you want to cancel?",u_DlgBase),-1,[wsf_AlignCenter])
enddef
ifdef os_os2
		 dlg(wdef(dlg_cancelation_DlgType,rct(44,36,184,112),dlg_cancelation_Title,u_DlgBase),dlg_cancelation_Flags),
		 ctl(wdef(wc_PushButton,rct(15,39,125,53),"YES, Cancel!",u_DlgBase),idc_ok,[wsf_TabStop]),
		 ctl(wdef(wc_PushButton,rct(15,56,125,70),"No, Continue Installation",u_DlgBase),idc_cancel,[wsf_TabStop]),
		 ctl(wdef(wc_Text,rct(10,5,130,14),"Installation is incomplete!",u_DlgBase),-1,[wsf_AlignCenter]),
		 ctl(wdef(wc_Text,rct(10,16,130,25),"Are you sure you want to",u_DlgBase),-2,[wsf_AlignCenter]),
		 ctl(wdef(wc_Text,rct(10,27,130,36),"cancel?",u_DlgBase),-3,[wsf_AlignCenter])
enddef
		],dlg_cancelation_eh,0).


%         Cancelation         

  dlg_cancelation_eh(_Win,e_CloseRequest,0):-
	!.
  dlg_cancelation_eh(_Win,e_Control(idc_cancel,_,_,_),0):-
	!,
	win_destroy(_Win).
  dlg_cancelation_eh(_Win,e_Control(idc_ok,_CT,_CW,_CI),0):-
	retract(build_is_work),
	win_Destroy(_Win),
	!.
  dlg_cancelation_eh(_Win,e_Control(idc_ok,_CT,_CW,_CI),0):-
	Parent=win_GetParent(_Win),
	win_Destroy(_Win),
	win_Destroy(Parent).
	%TW = vpi_GetTaskWin(),
	%win_postEvent(TW,e_menu(id_file_task_destroy,0)),%add 20.05.96



clauses
  exclude_all([]).
  make_script([]).
  v_packed_ratio(0,0).

predicates
  testSwitch(cmd_switch)-determ(i)
clauses
  testSwitch(SWITCH):-
	have_sw(SWITCH),
	!.


predicates
  bd_SetCurrentFileName(string)-procedure(i)
clauses

  bd_SetCurrentFileName(Name):-
	process_dlg(_DW,_,_,EDW),
	trap(win_SetText(EDw,Name),_,fail),
	!.
  bd_SetCurrentFileName(_).
	
/********************************************************************
	SOME DEFAULT constants, may redefined
*********************************************************************/
constants

ifndef build_FDIR_NAME 
  build_FDIR_NAME	 ="FDIR"		% fdir filename
enddef
ifndef build_FDIR32_NAME
  build_FDIR32_NAME      ="FDIR32"		% fdir32 filename
enddef
ifndef build_INSTALL_INT_NAME
  build_INSTALL_INT_NAME ="INSTALL.INT"	% main subdir
enddef
ifndef build_IMAGE_NAME
  build_IMAGE_NAME	 ="WINDOWS.IMG"	% install image name
enddef
ifndef build_LOG_NAME
  build_LOG_NAME	 ="BUILD.LOG"	% log File name
enddef

/********************************************************************

*********************************************************************/
predicates
  procedure open_log()
  procedure close_log()
  procedure write_log_msg(string)
clauses
  open_log():-
	safe_openWrite(log_File,build_LOG_NAME),
  	fileMode(log_File,1),
  	!.
  open_log().
  
  close_log():-
	closeFile(log_File),
	!.
  close_log().
	
  write_log_msg(MSG):-
	writeDevice(Was),
	writeDevice(screen),
	write(MSG),
	writeDevice(log_File),
	write(MSG),
	writeDevice(Was),
	!.
  write_log_msg(_).
/**********************************************************************
    term converter between domains "install_script" and "RawBinary"
**********************************************************************/  
  
predicates
   Word countListEntries(Build_Install_Script)-procedure(i)
  procedure Build_Install_Script rawBin2Script(binary)
  procedure rawBin2Script(build_install_script,binary,word,word)
   Binary script2RawBin(build_install_script)-determ(i)
  determ script2RawBinL(build_install_script,binary,word)
clauses
  
  countListEntries([_|T],Give):-
  	GetEnt = countListEntries(T),
  	!,
  	Give = GetEnt+1.
  countListEntries(_,0).
  
  script2RawBin(IScript,RawBin):-
	CNT= countListEntries(IScript),
	RawBin=makeBinary(CNT,16),
	/*SSS = getBinarySize(RawBin),
	format(TXT,"SS(%)CNT(%)",SSS,CNT),
	write_log_msg(TXT),*/
 	script2RawBinL(IScript,RawBin,0).
 
  script2RawBinL([],_,_):-
	!.
  script2RawBinL([IS|T],RAW,IDX):-
	NIDX=IDX+1,
	GR_offs= Idx*4,
	FP_offs=GR_OFFS+1,
	FS_offs=GR_OFFS+2,
	CRC_offs=GR_OFFS+3,
	IS=igroup(GR,FP,FS,CRC),
	
	setDWordEntry(RAW,GR_offs,GR),
	setDwordEntry(RAW,FP_offs,FP),
	setDWordEntry(RAW,FS_offs,FS),
	setDwordEntry(RAW,CRC_offs,CRC),
 	script2RawBinL(T,RAW,NIDX).
/**/

 rawBin2Script(RawBin,IScript):-
	BS=getBinarySize(RawBin),
	MCNT=(BS div 16)-1,
	rawBin2Script(IScript,RawBin,0,MCNT).

  rawBin2Script([],_,X,MX):- X > Mx,
  	!.
  rawBin2Script([IS|T],RAW,IDX,MaxIDX):-
	NIDX=IDX+1,
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


/************************************************************************
	The usual for predicate
*************************************************************************/

predicates
  for(integer,integer,integer) -nondeterm (o,i,i)
clauses
  for(I,I,_).
  for(I,J,K):-
	J<K,
	!,
	J2=J+1,
	for(I,J2,K).


/**************************************************************************
	The usual member predicate
***************************************************************************/
predicates
  nondeterm member(string,slist)
  nondeterm member(build_file_or_directory,build_include_list)
  nondeterm member(build_mgrp,build_make_script)
 
clauses
  member(H, [H|_]).
  member(H,[_|T]):-
	member(H,T).

/************************************************************************
	Sum the words in a binarry together
*************************************************************************/
predicates
  procedure build_filesize sumArray(binary)
  procedure sa(integer WordIndex,integer MaxWordIndex,binary, build_filesize CurSize, build_filesize ResultSize)

clauses
  sumArray(A,S):-
	Lim=getBinarySize(A)/2,
	sa(0,Lim,A,0,S).

  sa(Lim,Lim,_,S,S):-
	!.
  sa(I,Lim,A,S0,S):-
	S1 = S0 + getWordEntry(A,I),
	I2 = I + 1,
	sa(I2,Lim,A,S1,S).

/************************************************************************
	Compress a binary and write it to disk
*************************************************************************/
predicates
  procedure writeCompFpos(string,file, binary, unsigned ReturnedSize, ulong ReturnedFilePos)
  procedure writeComp(string,file, binary, unsigned ReturnedSize)	-(i,i,i,o)

clauses
  writeCompFpos(Name,File,BigBin, SizeWrote, Fpos):-
	filePos(File,Fpos,0),
	writeComp(Name,File,BigBin, SizeWrote).

  writeComp(Name,File,Bin,SizeWrote):-
	SmallBin = compressBinary(Bin),
	SizeWrote = GetBinarySize(SmallBin),
	writedevice(Was),
	writedevice(File),
	safe_WriteBlock(Name,SizeWrote,SmallBin),
	writedevice(Was).

/**************************************************************************
	Read a file and compress in several 64K segments
***************************************************************************/
predicates
  determ compressSegs(string,build_FileSize, binary, ulong CRC32)
  procedure noOfSegs(build_filesize, integer,unsigned)
  procedure nos(unsigned,unsigned,integer,unsigned)
  procedure readseg(integer,integer,unsigned,binary)
  segs_procent(ULONG,ULONG)-procedure(i,i)
  setPackedRatio(Ulong,Ulong)-procedure(i,i)
clauses
  segs_procent(_,0):-
	!.
  segs_procent(Current,Max):-
	process_dlg(_,FPW,_,_),
	trap(progress_bar_set_value(FPW,Max,Current),_,fail),
	vpi_processEvents(),
	!.
  segs_procent(_,_).	
  
  setPackedRatio(S,Ps):-
	v_packed_ratio(OldS,OldPS),
	NewS  = OldS  + S,
	NewPS = OldPS + PS,
	assert(v_packed_ratio(NewS,NewPS)),
	process_dlg(_,_,TPRW,_),
	trap(progress_bar_set_value(TPRW,NewS,NewPS),_,fail),
	!.
  setPackedRatio(_,_).

  compressSegs(Name,Size, FLengthArray, CRC):-	% returns array of lengths for
	noOfSegs(Size,NoSegs,LastSize),		% each compressed segment
	segs_procent(0,10),			% reset
	LastSeg=NoSegs-1,
	FLengthArray=makeBinary(NoSegs,2),
	CRCHolder=makeBinary(4),		% using this to accum CRC instead
	setDWordEntry(CRCHolder,0,init32),	% of database, since changes not
	for(Index,0,LastSeg),			% undome on backtracking...
	  build_is_work,
	  readSeg(Index, LastSeg, LastSize, Binary),	%-(i,i,i,o)
	  vpi_ProcessEvents(),
	  CrcIn=getDWordEntry(CRCHolder,0),
	  CrcOut=crc32Binary(Binary,CrcIn),
	  setDWordEntry(CRCHolder,0,CrcOut),
	  writeComp(Name,archive,Binary, BlkSize),		%-(i,i,o)
	  setWordEntry(FLengthArray, Index,BlkSize),
	  segs_procent(Index,LastSeg),
	  vpi_ProcessEvents(),
	Index=LastSeg,
	!,
	CRC = init32 - getDWordEntry(CRCHolder,0). % CRC = ~crc

  readseg(Last,Last,LastSize, Binary):-
	!,  %if last one, read remainder
	readblock(LastSize, Binary).
  readseg(_,_,_,Binary):-	       % else read normal amount
	readblock(blockSize,Binary).

  noOfSegs(Size, NoSegs, LastSize):-
	N1=trunc( Size / blockSize ),
	Remainder = Size - (N1 * blockSize),
	nos(Remainder, N1, NoSegs,LastSize).

  nos(0, Segs,Segs, blockSize):-
	!. %size was evenly divisible
  nos(Last, N, Segs, Last):-Segs=N+1.

/**************************************************************************
	Compress one file
***************************************************************************/
predicates
  determ compressFile(build_FileSize, string FileName,build_udate,build_utime,string, build_Dir_Entry)
  procedure pct_Shrink1(long,long, real)
  procedure pct_shrink2(binary, long, real)

clauses
    compressFile(FileSize, FileName, Date,Time, Prefix,
		small_file(FileName,FileSize,Date,Time,0,0,0)):-
	build_is_work,
	FileSize =0,
	!,
	filenamepath(FP, Prefix, Filename),
	%str_len(FileName,T),
	/*TabN=13-T, str_len(Tab,TabN),*/
	%str_len(Tab,T),
	% VY 981222
	bd_SetCurrentFileName(Fp),
	format(MSG,"\n packing: %s ",Fp),
	write_log_msg(MSG),
	vpi_ProcessEvents().

  compressFile(FileSize, FileName, Date,Time, Prefix,
		small_file(FileName,FileSize,Date,Time,CRC,ArcFpos,BlkSize)):-
	build_is_work,
	FileSize < blockSize,
	!,
	filenamepath(FP, Prefix, Filename),
	%str_len(FileName,T),
	/* TabN=13-T, str_len(Tab,TabN),*/
	%str_len(Tab,T), % VY 981222
	format(MSG,"\n packing: %s ",Fp),
	bd_SetCurrentFileName(Fp),
	write_log_msg(MSG),
	vpi_ProcessEvents(),
	segs_procent(0,10),
	file_bin(FileName, Binary),
	CRC = init32 - crc32binary(Binary,init32), % 32-bit CRC of original
	segs_procent(5,10),
	writeCompFpos(FileName,archive,Binary,Blksize,ArcFpos), % record compressed
	segs_procent(10,10),
	pct_shrink1(BlkSize, FileSize, PCT),
	format(MSG2,"  %2.0%%",PCT),
	write_log_msg(MSG2).

  compressFile(FileSize, FileName, Date,Time, Prefix,
	      large_file(FileName,FileSize, Date,Time,CRC,ArcFpos,LenArray)):-
	build_is_work,
	filenamepath(FP, Prefix, Filename),
	%str_len(FileName,T),
	/* TabN=13-T, str_len(Tab,TabN),*/
	%str_len(Tab,T), % VY 981222
	format(MSG,"\n packing: %s ",Fp),
	bd_SetCurrentFileName(Fp),
	write_log_msg(MSG),
	safe_openRead(infile,Filename),
	filemode(infile,0),
	readdevice(Was),
	readdevice(infile),
	filepos(archive, ArcFpos,0),	%Fpos of first segment
	compressSegs(FileName,FileSize, LenArray, CRC),
	readdevice(Was),
	closefile(infile),
	pct_shrink2(LenArray, FileSize, PCT),
	format(MSG2,"  %2.0%%",PCT),
	write_log_msg(MSG2).
	
  pct_shrink1(Csize,Size,PCT):-
	setPackedRatio(Size,Csize),
	Csize<Size,
	!,
	Pct=(1-(CSize/Size))*100
	;
	Pct=0.

  pct_shrink2(Array, Size,PCT):-
	Csize = sumArray(Array),
	pct_shrink1(Csize,Size,PCT).

/*******************************************************
      FDIR 32bit format  SUPPORT
*******************************************************/
predicates
 % TOPLEVEL
  tracefdir_s(bUILD_Directory,integer Id)-determ(i,i)
  determ openFDir_s (binary DsikArray)
  determ closeFDir_s(binary DsikArray)
 % Low 
  determ flush_fdir(file,build_install_script,binary DiskArray)  
clauses
/*  tracefdir_s(_,_):-
	have_sw(p(_,'n')),
	!.
*/
  tracefdir_s(DIR,Group):-
        term_str(build_directory,Dir, DirStr),
        term_bin(string,DirStr,DirBin),
	DirBinCrc=init32 - crc32binary(DirBin,init32),
	writeCompFpos(build_FDIR32_NAME,fdir_32, DirBin, TreeSize, TreeFpos),
	assertZ(fdir32_IS(igroup(Group, TreeFpos, TreeSize,DirBinCrc))),
	!.
	
/*  openFDir_s(_):-
	have_sw(p(_,'n')),!.*/
  openFDir_s(DiskArray):-
	safe_openwrite(fdir_32,build_FDIR32_NAME),
	filemode(fdir_32,0),
	writedevice(fdir_32),
	safe_WriteBlock(build_FDIR32_NAME,0, DiskArray),	    % here, just reserving space
	writedevice(fdir_32).

/*  closeFDir_s(_):-
	have_sw(p(_,'n')),!.*/
  closeFDir_s(DiskArray):-
	findAll(CHUNK,retract(fdir32_IS(CHUNK)),ISCRIPT),
	flush_fdir(fdir_32,ISCRIPT,DiskArray).

 

  flush_fdir(FILE,ISCRIPT,DiskArray):-
	ScriptBin = script2RawBin(Iscript),
	SCrc = init32 - crc32binary(ScriptBin,init32),
	writeCompFpos(build_FDIR32_NAME,fdir_32, ScriptBin, SSize, SFpos),

	setDwordEntry(DiskArray,0,max_Disks),
	setDwordEntry(DiskArray,1,SFpos),
	setDwordEntry(DiskArray,2,SSize),
	setDwordEntry(DiskArray,3,SCRC),

	filePos(FILE,0,0),
	writedevice(WAS),
	writedevice(FILE),
	safe_WriteBlock(build_FDIR32_NAME,0, DiskArray),
	writedevice(WAS),
	closeFile(FILE).

/******************************************************
      Checked all pathes
******************************************************/
database - bad
  bad_group(integer Group_numbers)
predicates
  check_install(build_make_script)-determ(i)
  check_paths(integer Group,build_from_path)-determ(i,i)
clauses
  check_install([group(Id, Paths,_,_)|GTail]):-
	disk(WasHere),
	check_paths(Id,Paths),
	disk(WasHere),
	!,
	check_install(GTail).
  check_install([]):-nl.

  check_paths(_,fromInstallRoot):-
	!.
  check_paths(_,startFromPath(H)):-
	trap(disk(H),_,fail),
	!.
  check_paths(ID,startFromPath(H)):-
	format(MSG,"\nGroup number: %d is missing , Directory: %s not found",Id,H),
	write_log_msg(MSG),
	assert(bad_group(Id)).

/****************************************************************
                WildCard Support
*****************************************************************/
predicates
  determ name_match(string Mask,string Name_ext)	     %MZ 17.09.96
  procedure parse_name_ext(string Fname,string Name,string Ext)%MZ 17.09.96
  % fname sould have no path, but may contain WildCards !!
  determ name_match2(sTRING,string)
  determ any_til(string,string)
clauses
  name_match(Mask,Name):-
	parse_name_ext(Mask,MaskN,MaskE),
	parse_name_ext(Name,NameN,NameE),
	name_match2(MaskN,NameN),	%test name
	name_match2(MaskE,NameE).	%test extens.

  parse_name_ext(FName,Name,Ext):-
	searchChar(Fname,'.',Pos),
	Pos2=Pos-1,
	frontStr(Pos2,Fname,Name,Rest),
	frontChar(Rest,'.',Ext),
	!.
  parse_name_ext(FName,FName,"").	%Name contain no extension'

  name_match2("",""):-
 	!.
  name_match2("*",_):-
 	!.
  name_match2(A,B) :-
	frontchar(A,'*',Ar),
	!,
	any_til(Ar,B).
  name_match2(A,B) :-
	frontchar(A,'?', Ar),
	!,
	frontchar(B,_, Br),
	name_match2(Ar,Br).
  name_match2(A,B) :-
	frontchar(A,C2,Ar),
	frontchar(B,C3,Br),
	upper_Lower(C2,C3),	%diff case	% 27.12.1999 MZ!
	name_match2(Ar,Br).

  any_til(A,B):-
	name_match2(A,B),
	!.
  any_til(A,B):-
	frontChar(B,_,Br),
	any_til(A,Br).

/**************************************************************************
	Collect and compress the files in the userscript
***************************************************************************/
predicates
  determ make_install(build_make_script)
  determ make_installOneG(build_mgrp)
  procedure collectTree(build_Include_List, build_Directory, build_Local_Excludes)
  nondeterm filesInDir(build_Include_List,build_Dir_Entry,build_LOCAL_EXCLUDES)
  procedure modify_tree(build_From_Path,build_Directory,build_Directory)
  procedure mt(slist,build_Directory,build_Directory)
  procedure descend(build_From_Path)
  determ excluded(string,build_LOCAL_EXCLUDES)
  procedure disallow1(integer,string)
  
clauses
  make_install(SCRP1):-
 	member(HEAD_S,SCRP1),
 	  make_installOneG(HEAD_S),
 	fail.
  make_install(_).
 	
  make_installOneG(group(Id, Paths, LocalExcludes, MaskList)):-
	build_is_work,
	not(bad_group(Id)),
	%!,
	format(MSG,"\n\tGroup %d",Id),
	write_log_msg(MSG),
	writedevice(Was),
	disk(WasHere),
	descend(Paths),
	collectTree(MaskList,ArcDir,LocalExcludes),
	modify_tree(Paths, ArcDir,ArcDir2),
	disk(WasHere),
	writedevice(Was),
%MZ 12.aug.96	
	tracefdir_s(ArcDir2,ID),
	term_bin(build_directory, ArcDir2, DirBin),
       
        DirBinCrc=init32 - crc32binary(DirBin,init32),
	writeCompFpos(build_FDIR_NAME,fdir, DirBin, TreeSize, TreeFpos),
	assertZ(fdir16_IS(igroup(ID, TreeFpos, TreeSize,DirBinCrc))),
	!.
  make_installOneG(group(Id, _Paths, _LocalExcludes, _MaskList)):-
	build_is_work,
	bad_group(Id),
	!.
  make_installOneG(group(_Id, _Paths, _LocalExcludes,_MaskList)):-
	build_is_work,
	!,
	write_log_msg("Error In Make_Install").


  mt([], A, A):-
	!.
  mt([H|T], A, [subdir(H,A2)]):-
	mt(T,A,A2).

  modify_Tree(startFromPath(H),A,[subdir(H,A)]):-!.
  modify_Tree(_,A,A).
 
  descend(fromInstallRoot):-
  	!.
  descend(startFromPath(H)):-
	disk(H),
	!.
  descend(_).

  collectTree(MaskList,Dir,Excludes):-
	findall(DE,filesInDir(MaskList,DE,Excludes),Dir).

  filesInDir(MaskList, DirEntry,LocalExcludes):-
	disk(Prefix),
	member(file(Mask),MaskList),
	dirfiles(Mask,$40,FileName,_,Hour,Min,Sec,Year,Month,Day,Size),
	Size > 0,   % if you need zero-length files, unpack needs change
		    %  ie readblock(0,B) reads as much as fits...
	not(excluded(FileName,LocalExcludes)),
	DosDate = (Year - 1980) * 512 + Month * 32 + Day,
	DosTime = Hour * 2048 + Min * 32 + Sec / 2,
	compressFile(Size, FileName, DosDate, DosTime, Prefix, DirEntry).

  filesInDir(MaskList,subdir(DirName,SubDir),LE):-
	member(directory(Dmask), MaskList),
	searchchar(Dmask,'\\',Pos),
	disallow1(Pos,Dmask),
	First = Pos - 1,
	frontstr(First,Dmask,Dirname,RestString),
	not(excluded(DirName,LE)),
	frontchar(Reststring,_,Dmask2),
	disk(SaveIt),
	disk(DirName),
	collectTree([directory(Dmask2)],SubDir,LE),
	disk(SaveIt).

  filesInDir(MaskList,subdir(DirName,SubDir),LE):-
	member(directory(Dmask), MaskList),
	not(searchchar(Dmask,'\\',_)),
	dirfiles(Dmask,fa_subdir,DirName,_,_,_,_,_,_,_,_),
	not(frontchar(DirName,'.',_)),
	not(excluded(DirName,LE)),
	disk(SaveIt),
	disk(DirName),
	collectTree([file("*.*"),directory("*.*")],SubDir,LE),
	disk(SaveIt).

  excluded(Filename,_):-
	exclude_all(ExList),
	member(Mask,ExList),
	 name_match(Mask,FileName),
	!.
  excluded(Filename,excluding(Excludes)):-
	member(Mask,Excludes),
	 name_match(Mask,FileName),
	!.


  disallow1(1,X):-
	!,
	format(MSG,"invalid mask: %s",X),
  	write_log_msg(MSG),
  	exit(0).
  disallow1(_,_).


/************************************************************************
	Copy the Image file to floppy disc's
*************************************************************************/
predicates
  procedure subToBinary(binary,ulong)
  nondeterm repeat
  determ copyToFloppy (string,dword BytesLeft,dword DiskLeft,integer DiskNo,string Path,integer LDrive,binary DWArray)
  determ copyToFloppy2(string,binary BytesLeft,binary DiskLeft,binary DiskNo,string Path,binary DWArray)
  determ copyToOne(string,binary BytesLeft)
  procedure clearKeyboardBuffer % Empty the keyboard buffer
clauses
  
  repeat.
  repeat:-
	repeat.


  subToBinary(Bin,Add):-
	Val = getDwordEntry(Bin,0),
	Val2=Val-Add,
	setDwordEntry(Bin,0,Val2).

  copyToOne(Name,BytesLeft):-
  	Bytes=getDwordEntry(BytesLeft,0),
  	Bytes>0xFF00,
  	!,
	readblock(0xFF00,BIn),
	safe_WriteBlock(Name,0xFF00,BIn),
	subToBinary(BytesLeft,0xFF00),
	fail.

  copyToOne(Name,BytesLeft):-
  	Bytes=getDwordEntry(BytesLeft,0),
  	readblock(Bytes,In),
	safe_WriteBlock(Name,Bytes,In).
	
predicates	
 procedure long  get_freeSpace(char Drive,long SubFromSize)
clauses
  get_freeSpace(_,SUB,RESULT):-
	volume_size(Size),
	Size>SUB,
	!,
	RESULT = Size-SUB.
  get_freeSpace(_,_,0):-
	volume_size(_),
	!,
	write("Error: Volume size should be bigger!"),
	exit(1).
  get_freeSpace(D,_,S):-
	diskSpace(D,S).
	
  copyToFloppy(Name,BytesTotal,DiskLeft,D_No,_,D_No,_):-	% COPY file on one disk without prompt
	bd_SetCurrentFileName(Name),
	BytesTotal > 0,
	BytesTotal<DiskLeft,
	!,	
	Bytes=makeBinary(4),
	setDwordEntry(Bytes,0,BytesTotal),
	repeat,
	  Current=BytesTotal-getDwordEntry(Bytes,0),
	  segs_procent(Current,BytesTotal),
	  %Perc= Current/ BytesTotal * 100,
	  %Iperc=val(integer,Perc),
	  %out_progress(Iperc),
	  copyToOne(Name,Bytes),
	  !,
	segs_procent(10,10).
	
  copyToFloppy(Name,BytesTotal,DiskLeft,D_No,Drive,LastDrive, DiskArray):-
	BytesTotal > 0,
	Bytes=makeBinary(4),
	setDwordEntry(Bytes,0,BytesTotal),
	Disk=makeBinary(4),
	setDwordEntry(Disk,0,DiskLeft),
	Disk_No=makeBinary(2),
	setWordEntry(Disk_no,0,D_No),
	repeat,
	  Current=BytesTotal-getDwordEntry(Bytes,0),
	%  Perc= Current/ BytesTotal * 100,
	%  Iperc=val(integer,Perc),
	%  out_progress(Iperc),
	  segs_procent(Current,BytesTotal),

	  copyToFloppy2(Name,Bytes,Disk,Disk_No,Drive, DiskArray),
	  !,
	  segs_procent(10,10),
	LastDrive = getWordEntry(Disk_No,0).
	
	  % We have reached the end
  copyToFloppy2(Name,Bytes,Disk,_,_,_):-
	BytesLeft=getDwordEntry(Bytes,0),
	DiskLeft =getDwordEntry(Disk ,0),
	BytesLeft<=DiskLeft,
	BytesLeft<=0xFF00,
	!,
	readblock(BytesLeft,BIn),
	safe_WriteBlock(Name,BytesLeft,BIn).		%not fail!

  % The current disc gets full
  copyToFloppy2(Name,Bytes,Disk,D_Number,Drive,DiskArray):-
	DiskLeft =getDwordEntry(Disk ,0),
	Dno	 =getWordEntry(D_Number ,0),
	DiskLeft<=0xFF00,
	!,
	readblock(DiskLeft,In),
	safe_WriteBlock(Name,DiskLeft,In),

	Dno2=Dno+1,
	setWordEntry(D_Number,0,Dno2),
	
	filepos(diskfile, FileSize, 0),

	AI=DNO-1,
	setDwordEntry(DiskArray,Ai, FileSize),

	closefile(diskfile),
	readdevice(keyboard),
	clearKeyboardBuffer,
	format(LMSG1,"Insert Disk No %d",Dno2),
	write_log_msg(LMSG1),
	dlg_Note(LMSG1),
	filenamePath(FileName2, DRIVE,"DISK_"),
	format(FileName,"%s%",FileName2,Dno2),
	safe_openwrite(diskfile,FileName),
	filemode(diskfile,binary_filemode_flag),
	readdevice(archive),
	writedevice(diskfile),
	frontChar(Drive,DriveChar,_),
	D2 = get_freeSpace(DriveChar,0),
	subToBinary(Bytes,DiskLeft),
	setDwordEntry(Disk,0,D2),
	!,
	fail.

  % Default, Put another 64K block to the disk !
  copyToFloppy2(Name,BL,DL,_,_,_):-
	readblock(0xFF00,In),
	safe_WriteBlock(Name,0xFF00,In),
	subToBinary(BL,0xFF00),
	subToBinary(DL,0xFF00),
	!,
	fail.


%  clearKeyboardBuffer:- inkey(_), !, clearKeyboardBuffer.	%% +++++++? MZ
  clearKeyboardBuffer.
predicates
  determ mayChangeDisk(word,word)
clauses
  mayChangeDisk(D_no,D_no):-
	!.
  mayChangeDisk(_,_):-
	writeDevice(screen),
	write_log_msg("\nPlace Disk 1 in drive"),
	readDevice(keyboard),
	readChar(_).

/************************************************************************
	The main code for building the compressed image
*************************************************************************/

predicates
  procedure mayMake(string Path)
  procedure multimkdir(string)-(i)
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
	!,
	Npos=Pos-1,
	substring(DIR,1,NPOS,CUTDIR).
  cutdir(DIR,DIR).

  multimkdir(DIR):-
   	not(searchchar(Dir,':',_)),
  	cutDir(Dir,CD),
  	trapmkdir(CD),
  	disk(CD),
 	searchchar(Dir,'\\',Pos),
 	!,
	str_len(Dir,Len),
	NPos=Pos+1,
	Nlen=Len-Pos,
	substring(Dir,Npos,Nlen,NDir),
	multimkdir(NDir).
  multiMKDir(Dir):-
	searchchar(Dir,':',_),
	str_len(Dir,Len),
	Nlen=Len-3,
	NPos=4,
	substring(Dir,Npos,Nlen,NDir),
	substring(Dir,1,3,Root),
	disk(Root),
	multiMKDir(Ndir),
	!.
  multiMKDir(_).

 
  mayMake(DirName):-
	disk(DIR),
	multimkdir(DirName),
	disk(DIR).
 
predicates
  procedure ulong correct_size(ulong)
  determ add_size_to_temp(string FileName)
clauses
  correct_size(SIZE,SIZE):-
	S = Size mod 512,
	S = 0,
	!.
  correct_size(SIZE,SizeC):-
	S = Size div 512,
	SizeC = (S+1)*512.
	
  add_size_to_temp(NAME):-
	dirfiles(NAME,0x61,_,_,_,_,_,_,_,_,Size),
	retract(temp_files_size(Old)),
	!,
	C = correct_size(Size),
	New = Old+C,
	assert(temp_files_size(New)).

predicates
  procedure c_copy_fdir(string,string)
  procedure copy_fdir16(string,string)
  procedure copy_fdir32(string,string)
  procedure modify_fdir(string,binary)
clauses
  copy_fdir16(_,_):-
  	have_sw(p('n',_)),
  	!.
  copy_fdir16(Name,FullName):-
	c_copy_fdir(Name,FullName).

/*  copy_fdir32(_,_):-
	have_sw(p(_,'n')),!.*/
  copy_fdir32(Name,FullName):-
	c_copy_fdir(Name,FullName).
	
  c_copy_fdir(Name,FullName):-
	bd_SetCurrentFileName(FullName),
	trap(copyfile(Name,FullName),_,write_log_msg("error when coping file\n")),
	add_size_to_temp(NAME),
	!.
  c_copy_fdir(_,_).

	
  modify_fdir(Name,DiskArray):-
  	format(MSG,"\n modify fdir:%s started",Name),
	write_log_msg(MSG),
	existfile(Name),
	openmodify(fdir,Name),
	filemode(fdir,binary_filemode_flag),
	filepos(fdir,0,0),
	writedevice(fdir),
	filepos(fdir,16,0),
	safe_WriteBlock(Name,0, DiskArray),
	closefile(fdir),
	!,
	write_log_msg("OK\n").
  modify_fdir(_,_):-
	write_log_msg("Error").
/****************************************************************
	copy files to floppy disk's  via "copy_Files_Script"
*****************************************************************/
predicates
 procedure add_files_to_distr(string From,string To)
 determ add_files_to_distr2(string From,string To,integer Group)
clauses

  add_files_to_distr(FROM,TO):-
	have_sw(p('y',_)),				%16 bit gropu
	add_files_to_distr2(FROM,TO,0),
	fail.

  add_files_to_distr(FROM,TO):-
	have_sw(p(_,'y')),				%32 bit group
	add_files_to_distr2(FROM,TO,1),
	fail.
  add_files_to_distr(_,_).
  
  add_files_to_distr2(FROM,TO,ID):-
	copy_Files_Script(FILES,ID),
	member(File,FileS),
	   fileNamePath(File,_,Name),
	   fileNamePath(SRC,FROM,FILE),
	   fileNamePath(DST,TO,Name),
	   format(MSG,"coping %s\n",FILE),
	   write_log_msg(MSG),
	   bd_SetCurrentFileName(DST),
	   vpi_ProcessEvents(),
	   trap(copyFile(SRC,DST),_,write_log_msg("Error Coping!\n")),
	   add_size_to_temp(SRC),
	   bd_SetCurrentFileName(""),
	 fail.

predicates
  determ make(integer,string Path)
  determ make2(string Root,string Path,binary,string)
clauses
/*********************************
***********************************/
  make(_Switch, Path):-
	disk(".."),
	disk(InstallRoot),
	mayMake(build_INSTALL_INT_NAME),
	DaSize= (max_Disks + 4) * 4,
	DiskArray = makeBinary(DaSize),
	make2(InstallRoot,Path, DiskArray,build_IMAGE_NAME).
		% this part do packed image
  make2(InstallRoot,_, DiskArray, ArcRoot):-
	testSwitch(make_image(b_true)),
	disk(build_INSTALL_INT_NAME),
	fileNameExt(ArcName, ArcRoot, ".IMG"),

	format(LMSG1,"creating packed image: %s\n",ArcName),
	write_log_msg(LMSG1),
	
	safe_openwrite(archive, ArcName),
	filemode(archive, binary_filemode_flag),

	safe_openwrite(fdir,build_FDIR_NAME),
	openFDir_s(DiskArray),

	filemode(fdir,binary_filemode_flag),
	writedevice(fdir),
	safe_WriteBlock(build_FDIR_NAME,0, DiskArray),	    % here, just reserving space
	writedevice(fdir),

	disk(InstallRoot),

	make_script(MScript),			% Get user specified script

	writeDevice(OldCheck),
	writeDevice(screen),
	check_install(MScript), 		%test for exist all group's pathes
	writeDevice(OldCheck),

	%make_install(MScript,IScript),  	% write 1 tree per group
	make_install(MScript),  	% write 1 tree per group
	findAll(Chunk16,retract(fdir16_IS(Chunk16)),Iscript),
 	ScriptBin = script2RawBin(Iscript),
	closeFDir_s(DiskArray),

	SCrc = init32 - crc32binary(ScriptBin,init32),
	writeCompFpos(build_FDIR_NAME,fdir, ScriptBin, SSize, SFpos),

	setDwordEntry(DiskArray,0,max_Disks),
	setDwordEntry(DiskArray,1,SFpos),
	setDwordEntry(DiskArray,2,SSize),
	setDwordEntry(DiskArray,3,SCRC),
	closefile(archive),

	filepos(fdir,0,0),
	writedevice(fdir),
	safe_WriteBlock(build_FDIR_NAME,0, DiskArray),
	closefile(fdir),
	build_is_work,
	write_log_msg("Packing OK.\n"),
	fail.
			% This Part making Disributive
  make2(InstallRoot, Drive, _,ArcName):-
 	build_is_work,
 	downTotalMeter(),
	testSwitch(make_DSet(b_true)),
	!,
	assert(temp_files_size(0)),
	disk(InstallRoot),
	mayMake(DRIVE),
	disk(build_INSTALL_INT_NAME),

	DiskArray=makeBinary(max_Disks,4),
/***/
	safe_OpenRead(archive,ArcName),
 	build_is_work,
	filemode(archive, binary_filemode_flag),
	format(LMSG3,"\nInsert disk 1 in drive %s\n",Drive),
	write_log_msg(LMSG3), 
	dlg_Note(LMSG3),
	vpi_ProcessEvents(),
  % Copy non standart files
	disk(FromPath),				%-| MZ add 17.09.96
	add_files_to_distr(FromPath,DRIVE),	%/
  % Copy FDIR's  
	%filenamePath(DiskFdir  ,DRIVE,build_FDIR_NAME  ),
	filenamePath(DiskFdir32,DRIVE,build_FDIR32_NAME),
	%copy_fdir16(build_FDIR_NAME  , DiskFdir  ),%copyfile("FDIR", DiskFdir),
	copy_fdir32(build_FDIR32_NAME, DiskFdir32),%add_size_to_temp("FDIR"),

  % Copy the large image to discs
	filenamePath(FlopName, DRIVE,"DISK_1"),
	bd_SetCurrentFileName(FlopName),
	safe_openwrite(diskfile,FlopName),
	build_is_work,
	filemode(diskfile,binary_filemode_flag),
	writedevice(diskfile),
	readdevice(archive),
	filepos(archive,0,2),
	filepos(archive, TotalArcSize,0),
	filepos(archive,0,0),
	frontChar(Drive,DriveChar,_),
	TotalArcSize <> 0,
	temp_files_size(Size_For_Sub),
	!,
	FreeSpace = get_freeSpace(DriveChar,Size_For_Sub),
      format(LLMSG,"Total Arch Size % \n",TotalArcSize),
      write_log_msg(LLMSG),
      
	copyToFloppy(FlopName,TotalArcSize, FreeSpace,1,Drive,Last,DiskArray),

	filepos(diskfile,Fsize,0),

	Di=Last-1,
	
	setDwordEntry(DiskArray, Di, Fsize),

	closefile(diskfile),

	mayChangeDisk(1,Last),

	%modify_fdir(DiskFDir  ,DiskArray),
	modify_fdir(DiskFDir32,DiskArray),

	disk(InstallRoot),
	!,
	write_log_msg("Copy OK.\n").

  make2(_,_,_,_):-
	not(testSwitch(make_image(b_true))),
	write_log_msg("You should use /d or /i switches.\n"),
	disk(build_INSTALL_INT_NAME),
	!
	;
	true.




%BEGIN_DLG build process
/**************************************************************************
	Creation and event handling for dialog: build process
**************************************************************************/

constants

%BEGIN build process, CreateParms, 17:39:27-21.8.1997, Code automatically updated!
  dlg_build_process_DlgType = wd_Modeless
  dlg_build_process_Title = "build process state"
  dlg_build_process_RCT = rct(50,20,211,90)
  dlg_build_process_Flags = [wsf_DlgBorder,wsf_Close,wsf_TitleBar,wsf_Minimize]
  dlg_build_process_Help = idh_contents
%END build process, CreateParms

predicates

  dlg_build_process_eh : ehandler

clauses

  dlg_build_process_Create(Parent):-
	not(process_dlg(_,_,_,_)),
	win_CreateDynDialog(Parent,
		[
%BEGIN build process, WinDefList, 17:39:27-21.8.1997, Code automatically updated!
		 dlg(wdef(dlg_build_process_DlgType,dlg_build_process_RCT,dlg_build_process_Title,u_DlgBase),dlg_build_process_Flags),
		 ctl(wdef(wc_PushButton,rct(55,50,95,62),"&Cancel",u_DlgBase),idc_cancel,[wsf_Group,wsf_TabStop]),
		 customctl(wdef(wc_Custom,rct(81,20,156,30),"Custom",u_DlgBase),"PROGRESS",build_idc_file_meter,[wsf_Group,wsf_TabStop]),
		 customctl(wdef(wc_Custom,rct(81,35,156,45),"Custom",u_DlgBase),"PROGRESS",build_idc_total_meter,[wsf_Group,wsf_TabStop]),
		 ctl(wdef(wc_Edit,rct(5,5,155,16),"",u_DlgBase),build_idc_current_file,[wsf_Group,wsf_TabStop,wsf_AutoHScroll,wsf_AlignLeft]),
		 ctl(wdef(wc_Text,rct(4,20,76,30),"Current File Progress",u_DlgBase),build_idct_current_file,[wsf_AlignRight]),
		 ctl(wdef(wc_Text,rct(5,35,76,45),"Total Packing Ratio",u_DlgBase),build_idct_total_progress,[wsf_AlignRight])
%END build process, WinDefList
		],dlg_build_process_eh,0).

%MARK build process, new events

%BEGIN build process, e_CloseRequest
  dlg_build_process_eh(_Win,e_CloseRequest,0):-
	dlg_cancelation_Create(_Win),
	!.
%END build process, e_CloseRequest

%BEGIN build process, idc_cancel _CtlInfo
  dlg_build_process_eh(_Win,e_Control(idc_cancel,_CtrlType,_CtrlWin,_CtlInfo),0):-
  	dlg_cancelation_Create(_Win),
  	!.
%END build process, idc_cancel _CtlInfo

%BEGIN build process, e_Destroy
  dlg_build_process_eh(_Win,e_Destroy,0):-
	!,
	retractall(process_dlg(_Win,_,_,_)).
%END build process, e_Destroy

%BEGIN build process, e_Create
  dlg_build_process_eh(_Win,e_Create(_CreationData),0):-
	!,
	FileW = win_GetCtlHandle(_Win,build_idc_file_meter),
	TotalW = win_GetCtlHandle(_Win,build_idc_total_meter),
	EditW = win_GetCtlHandle(_Win,build_idc_current_file),
	assert(process_dlg(_Win,FileW,TotalW,EditW)).
%END build process, e_Create

%END_DLG build process
/****************************************************
	Global Predicates
*****************************************************/
predicates
 procedure addSlashToRoot(string,string)-(i,o)
 procedure dest_codec(char,char,integer)-(o,o,i)
clauses
  dest_codec('y','n',0):-!.
  dest_codec('n','y',1):-!.
  dest_codec('y','y',_).
  
  addSlashToRoot(P,NP):-
	not(searchChar(P,'\\',_)),
	frontChar(P,D,Re),
	frontChar(Re,':',Re2),
	format(NP,"%c:\\%s",D,Re2),
	!.
  addSlashToRoot(X,X).
  

  build_initScripts(ExcludeList,GeneralMAKE_SCRIPT):-
	assert(exclude_all(ExcludeList)),
	assert(make_script(GeneralMAKE_SCRIPT)).

  build_initCopyScript(FileList,Group):-
	assert(copy_files_script(FileList,Group)),
	!.

  build_initValues(_,P,_,_,_,_):-
	retractall(t_path(_)),
	retractall(volume_size(_)),
	retractall(have_sw(_)),
	dest_codec(Win,OS,P),
	assert(have_sw(p(Win,Os))),
	fail.

  build_initValues(_,_,b_true,Size,_,_):-
 	retractAll(volume_size(_)),
 	assert(volume_size(Size)),
 	fail.

  build_initValues(PATH,_P,_UseSize,_Size,E_DSET,E_Image):-
	addSlashToRoot(PATH,Path2),
	%write("p:",Path2),nl,
	assert(t_path(Path2)),
	assert(have_sw(make_DSet(E_DSET))),
	assert(have_sw(make_image(E_Image))).

/*  build_Go():-
	have_sw(SW),
	  write(SW),nl,
	  fail.*/
  build_Go():-
	retractall(fdir16_IS(_)),
	retractall(fdir32_IS(_)),
 	open_log(),
  	TW = vpi_GetTaskWin(),
  	dlg_build_process_Create(TW),
  	retractAll(build_is_work),
  	assert(build_is_work),
	assert(v_packed_ratio(0,0)),
  	vpi_ProcessEvents(),
  	vpi_ProcessEvents(),
	t_path(Path),
	frontchar(Path,_,Path2),
	frontchar(Path2,':',_),
	upper_lower(UPath,Path),
	%writef("Upath % \n",UPath),
	make(0,UPath),
	fail.

  build_Go():-
	not(build_is_work),
	dlg_note("Build Work Is Not Completed!"),
	fail.

  build_Go():-
	build_is_work,
	dlg_note("Build Work Is Full Completed!"),
	fail.

  build_Go():-
	retractall(build_is_work),
	process_dlg(Win,_,_,_),
	win_Destroy(Win),
	fail.
  build_Go():-
  	close_log().
	



