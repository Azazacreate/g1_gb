/*****************************************************************************

	(c) Copyright 1984 - 2000 Prolog Development Center A/S

 Project:  BUILD
 FileName: BUILD.PRO
 Purpose: Engine for Install Image Builder
 Written by: Michael Alexander
 Modified by: Zaichenko Michael
 Comments:

  Based on the script in ISCRIPT.PRO, first collect and compress the files in
  WINDOWS.IMG, then copy the content to floppy discs.

  This project sould producted two file : fdir and windows.img 
  also can producted fdir32 and fdir.s , this only for 32 bit platform

FDIR file format:
ÚÄÄÄÄÄÄÄ¿ÚÄÄÄÄÄÄÄÄÄÄÄÄ¿ÚÄÄÄÄÄÄÄÄÄÄÄÄ¿ÚÄÄÄ¿ÚÄÄÄ¿
³HEADER1³³directoryB 1³³directoryB 2³³...³³ISB³
ÀÄÄÄÄÄÄÄÙÀÄÄÄÄÄÄÄÄÄÄÄÄÙÀÄÄÄÄÄÄÄÄÄÄÄÄÙÀÄÄÄÙÀÄÄÄÙ

 HEADER1 struct{		/* C pseudocode*/
      unsigned long DiskOffs[max_disks];/**/
      unsigned long ISB_size;
      unsigned long ISB_offs;
      unsigned long ISB_crc;
	      };

 ISB		-> packed term: InstallScript (handled  directoryB)
 directoryB	-> packed term: Directory

WINDOWS.IMG
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿ÚÄÄÄÄÄ¿
³RawPackedBlock1³³RawPackedBlock2³³ ... ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÀÄÄÄÄÄÙ
******************************************************************************/
ifndef build_pre_included
 Error: this file requires include: build.pre
enddef 

/********************************************************************
	SOME DEFAULT constants, may redefined
*********************************************************************/
constants

ifndef bu_FDIR_NAME 
  bu_FDIR_NAME	      ="FDIR"		% fdir filename
enddef
ifndef bu_FDIR32_NAME
  bu_FDIR32_NAME      ="FDIR32"		% fdir32 filename
enddef
ifndef bu_INSTALL_INT_NAME
  bu_INSTALL_INT_NAME ="INSTALL.INT"	% main subdir
enddef
ifndef bu_IMAGE_NAME
  bu_IMAGE_NAME	      ="WINDOWS.IMG"	% install image name
enddef
ifndef bu_LOG_NAME
  bu_LOG_NAME	      ="BUILD.LOG"	% log File name
enddef

/********************************************************************

*********************************************************************/
predicates
  procedure open_log()
  procedure close_log()
  procedure write_log_msg(STRING)
clauses
  open_log():-
	openWrite(log_File,bu_LOG_NAME),
  	fileMode(log_File,1),!.
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
 
/***********************************************************
     term converter between "install_script" and "RawBinary"
************************************************************/
/*incluide "scrp_cnv.pro"*/

%igroup = bin (dword:GroupId,dword:DirFpos, dword:FileSize,dword UlongCrc32)
% 	/\ -size - 16 bytes
% igrp=struct igroup(INTEGER, ARCFPOS, FILESIZE, ULONG CRC32)


predicates
  procedure Word countListEntries(Install_Script)
  procedure Install_Script rawBin2Script(Binary)
  procedure rawBin2Script(Install_Script,Binary,WORD,WORD)
  procedure Binary script2RawBin(Install_Script)
  procedure script2RawBinL(Install_Script,BINARY,WORD)
clauses
  countListEntries([],0):-!.
  countListEntries([_|T],Give):-
  	GetEnt=countListEntries(T),
  	Give=GetEnt+1.
  
  script2RawBin(IScript,RawBin):-
	CNT= countListEntries(IScript),
	RawBin=makeBinary(CNT,16),
 	script2RawBinL(IScript,RawBin,0).
 
  script2RawBinL([],_,_):-!.
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
 	script2RawBinL(T,RAW,NIDX),
 	!.
/**/

 rawBin2Script(RawBin,IScript):-
	BS=getBinarySize(RawBin),
	MCNT=(BS div 16)-1,
	rawBin2Script(IScript,RawBin,0,MCNT).

  rawBin2Script([],_,X,MX):- X > Mx,!.
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
	rawBin2Script(T,RAW,NIDX,MaxIdx),
 	!.
/*end of include */ 

  
/************************************************************************
	command line parser
*************************************************************************/
predicates

  nondeterm sw_Script(STRING,CMD_Switch)
  procedure setSwitch(CMD_SWITCH)
  procedure parse_CmdLine(STRING)
  determ testSwitch(CMD_SWITCH)
  
clauses
  testSwitch(SWITCH):-
	have_sw(SWITCH),!.
  
  sw_Script("/32"   ,p('n','y')).	% -16, +32
  sw_Script("/both" ,p('y','y')).	% +16, +32
/*ifdef cd_ver			% mm not support
  sw_Script("/mm"   ,use_MM).
enddef*/
  sw_Script("/i"    ,make_image).
  sw_Script("/d"    ,make_DSet).

  setSwitch(p(P16,P32)):-!,
  	retractall(have_sw(p(_,_))),
	assert    (have_sw(p(P16,P32))).
  setSwitch(SW):-
	assert(have_sw(SW)).
	
ifndef cd_ver
  parse_CmdLine(CMD):-
	searchString(CMD,"/v",Pos),
	POS2=Pos+1,
	frontStr(Pos2,CMD,_,VAL),
	frontToken(VAL,TOK,_),
	term_str ( long, Size, TOK ), %str_long(TOK,Size), %str_long is not supported
	assert(volume_size(Size)),
	Size<360000,!,			% !!! must be size of groups(0-9)!
	write_log_msg("\nError: Volume size must be bigger then 360000 bytes\n"),
	exit.
enddef

  parse_CmdLine(CMD):-
	sw_Script(StrSw,TokSW),
	  searchString(CMD,StrSW,_),
	  setSwitch(TokSw),
	fail.
  parse_CmdLine(_).
	
	
/************************************************************************
	The usual for predicate
*************************************************************************/

predicates
 nondeterm for(INTEGER,INTEGER,INTEGER) - (o,i,i)

clauses
  for(I,I,_).
  for(I,J,K):-
	J<K,!,J2=J+1, for(I,J2,K).


/**************************************************************************
	The usual member predicate
***************************************************************************/
predicates
  nondeterm member(STRING,STRINGLIST)
  nondeterm member(FILE_OR_DIRECTORY,INCLUDE_LIST)

clauses
  member(H, [H|_]).
  member(H,[_|T]):- member(H,T).


/************************************************************************
	Sum the words in a binarry together
*************************************************************************/
predicates
  procedure FileSize sumArray(BINARY)
  procedure sa(INTEGER wordIndex,INTEGER maxWordIndex,BINARY, FILESIZE curSize, FILESIZE resultSize)

clauses
  sumArray(A,S):-
	Lim=getBinarySize(A)/2,
	sa(0,Lim,A,0,S).

  sa(Lim,Lim,_,S,S):-!.
  sa(I,Lim,A,S0,S):-
	S1 = S0 + getWordEntry(A,I),
	I2 = I + 1,
	sa(I2,Lim,A,S1,S).


/************************************************************************
	Compress a binary and write it to disk
*************************************************************************/
predicates
  procedure writeCompFpos(FILE, BINARY, UNSIGNED ReturnedSize, ULONG ReturnedFilePos)
  procedure writeComp(FILE, BINARY, UNSIGNED ReturnedSize)	-(i,i,o)

clauses
  writeCompFpos(File,BigBin, SizeWrote, Fpos):-
	filePos(File,Fpos,0),
	writeComp(File,BigBin, SizeWrote).

  writeComp(File,Bin,SizeWrote):-
	SmallBin = compressBinary(Bin),
	SizeWrote = GetBinarySize(SmallBin),
	writedevice(Was),
	writedevice(File),
	writeblock(SizeWrote,SmallBin),
	writedevice(Was).


/**************************************************************************
	Read a file and compress in several 64K segments
***************************************************************************/
predicates
  determ compressSegs(FILESIZE, BINARY, ULONG CRC32)
  procedure noOfSegs(FILESIZE, INTEGER,UNSIGNED)
  procedure nos(UNSIGNED,UNSIGNED,INTEGER,UNSIGNED)
  procedure readseg(INTEGER,INTEGER,UNSIGNED,BINARY)
  procedure segs_procent(INTEGER,INTEGER)

clauses
  segs_procent(_,0):-!.
  segs_procent(Current,Max):-
	P=trunc(100*(Current+1)/Max),
	writedevice(Was),
	writedevice(stdout),
	cursor(X,Y),
	write('>',P,"%  "),
	cursor(X,Y),
	writedevice(Was).
	

  compressSegs(Size, FLengthArray, CRC):-% returns array of lengths for
	noOfSegs(Size,NoSegs,LastSize),  % each compressed segment
	LastSeg=NoSegs-1,
	FLengthArray=makeBinary(NoSegs,2),
	CRCHolder=makeBinary(4),	  % using this to accum CRC instead
	setDWordEntry(CRCHolder,0,init32),% of database, since changes not
	for(Index,0,LastSeg),  	  % undome on backtracking...
		readSeg(Index, LastSeg, LastSize, Binary),	%-(i,i,i,o)
		CrcIn=getDWordEntry(CRCHolder,0),
		CrcOut=crc32Binary(Binary,CrcIn),
		setDWordEntry(CRCHolder,0,CrcOut),
		writeComp(archive,Binary, BlkSize),		%-(i,i,o)
		setWordEntry(FLengthArray, Index,BlkSize),
		segs_procent(Index,NoSegs),
	Index=LastSeg,!,
	CRC = init32 - getDWordEntry(CRCHolder,0). % CRC = ~crc

  readseg(Last,Last,LastSize, Binary):-!,  %if last one, read remainder
	readblock(LastSize, Binary).
  readseg(_,_,_,Binary):-	       % else read normal amount
	readblock(blockSize,Binary).

  noOfSegs(Size, NoSegs, LastSize):-
	N1=trunc( Size / blockSize ),
	Remainder = Size - (N1 * blockSize),
	nos(Remainder, N1, NoSegs,LastSize).

  nos(0, Segs,Segs, blockSize):-!. %size was evenly divisible
  nos(Last, N, Segs, Last):-Segs=N+1.


/**************************************************************************
	Compress one file
***************************************************************************/
predicates
  determ compressFile(FILESIZE, STRING FILENAME,UDATE,UTIME,STRING, DIR_ENTRY)
  procedure pct_Shrink1(BLKSIZE, FILESIZE, REAL)
  procedure pct_shrink2(BINARY, FILESIZE, REAL)

clauses
    compressFile(FileSize, FileName, Date,Time, Prefix,
		small_file(FileName,FileSize,Date,Time,0,0,0)):-
	FileSize =0,!,
	filenamepath(FP, Prefix, Filename),
	str_len(FileName,T), TabN=13-T, str_len(Tab,TabN),
	format(MSG,"\n packing: %s%s",Fp,Tab),
	write_log_msg(MSG).

  compressFile(FileSize, FileName, Date,Time, Prefix,
		small_file(FileName,FileSize,Date,Time,CRC,ArcFpos,BlkSize)):-
	FileSize < blockSize, !,
	filenamepath(FP, Prefix, Filename),
	str_len(FileName,T), TabN=13-T, str_len(Tab,TabN),
	format(MSG,"\n packing: %s%s",Fp,Tab),
	write_log_msg(MSG),
	file_bin(FileName, Binary),
	CRC = init32 - crc32binary(Binary,init32), % 32-bit CRC of original
	writeCompFpos(archive,Binary,Blksize,ArcFpos), % record compressed
	pct_shrink1(BlkSize, FileSize, PCT),
	format(MSG2,"  %2.0%%",PCT),
	write_log_msg(MSG2).

  compressFile(FileSize, FileName, Date,Time, Prefix,
	      large_file(FileName,FileSize, Date,Time,CRC,ArcFpos,LenArray)):-
	filenamepath(FP, Prefix, Filename),
	str_len(FileName,T),TabN=13-T, str_len(Tab,TabN),
	format(MSG,"\n packing: %s%s",Fp,Tab),
	write_log_msg(MSG),
	openread(infile,Filename),
	filemode(infile,0),
	readdevice(Was),
	readdevice(infile),
	filepos(archive, ArcFpos,0),	%Fpos of first segment
	compressSegs(FileSize, LenArray, CRC),
	readdevice(Was),
	closefile(infile),
	pct_shrink2(LenArray, FileSize, PCT),
	format(MSG2,"  %2.0%%",PCT),
	write_log_msg(MSG2).
	
  pct_shrink1(Csize,Size,PCT):-
	Csize<Size,!,
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
  determ tracefdir_s(DIRECTORY,INTEGER id)
  determ openFDir_s (BINARY dsikArray)
  determ closeFDir_s(BINARY dsikArray)

  % Low 
  determ flush_fdir(FILE,Install_scripT,BINARY diskArray)  
clauses
  tracefdir_s(_,_):-
	have_sw(p(_,'n')),!.

  tracefdir_s(DIR,Group):-
        term_str(directory,Dir, DirStr),
        term_bin(string,DirStr,DirBin),
        
	DirBinCrc=init32 - crc32binary(DirBin,init32),
	writeCompFpos(fdir_32, DirBin, TreeSize, TreeFpos),
        assertZ(fdir32_IS(igroup(Group, TreeFpos, TreeSize,DirBinCrc))),

	!.
	
  openFDir_s(_):-
	have_sw(p(_,'n')),!.
  openFDir_s(DiskArray):-
	openwrite(fdir_32,bu_FDIR32_NAME),
	filemode(fdir_32,0),
	writedevice(fdir_32),
	writeblock(0, DiskArray),	    % here, just reserving space
	writedevice(fdir_32).

  closeFDir_s(_):-
	have_sw(p(_,'n')),!.
  closeFDir_s(DiskArray):-
	findAll(CHUNK,retract(fdir32_IS(CHUNK)),ISCRIPT),
	flush_fdir(fdir_32,ISCRIPT,DiskArray).

 

  flush_fdir(FILE,ISCRIPT,DiskArray):-
	ScriptBin = script2RawBin(Iscript),

	SCrc = init32 - crc32binary(ScriptBin,init32),
	writeCompFpos(fdir_32, ScriptBin, SSize, SFpos),

	setDwordEntry(DiskArray,0,max_Disks),
	setDwordEntry(DiskArray,1,SFpos),
	setDwordEntry(DiskArray,2,SSize),
	setDwordEntry(DiskArray,3,SCRC),

	filepos(FILE,0,0),
	writedevice(WAS),
	writedevice(FILE),
	writeblock(0, DiskArray),
	writedevice(WAS),
	closeFile(FILE).

/******************************************************
      Checked all pathes
******************************************************/
database - bad
  bad_group(INTEGER group_numbers)
predicates
  procedure check_install(MAKE_SCRIPT)
  procedure check_paths(INTEGER Group,FROM_PATH)
clauses
  check_install([group(Id, Paths,_,_)|GTail]):-
	disk(WasHere),
	check_paths(Id,Paths),
	disk(WasHere),
	!,
	check_install(GTail).
  check_install([]):-nl.

  check_paths(_,fromInstallRoot):-!.
  check_paths(_,startFromPath(H)):-
	trap(disk(H),_,fail),!.
  check_paths(ID,startFromPath(H)):-
	format(MSG,"\nGroup number: %d is missing , Directory: %s not found",Id,H),
	write_log_msg(MSG),
	assert(bad_group(Id)).


/****************************************************************
                WildCard Support
*****************************************************************/
predicates
  determ name_match(STRING mask,STRING name_ext)	     %MZ 17.09.96
  procedure parse_name_ext(STRING fname,STRING name,STRING ext)%MZ 17.09.96
  % fname sould have no path, but may contain WildCards !!
  determ name_match2(String,STRING)
  determ any_til(STRING,STRING)
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

  name_match2("",""):-!.
  name_match2("*",_):-!.
  name_match2(A,B) :-
	frontchar(A,'*',Ar),!,
	any_til(Ar,B).
  name_match2(A,B) :-
	frontchar(A,'?', Ar),!,
	frontchar(B,_, Br),
	name_match2(Ar,Br).
  name_match2(A,B) :-
	frontchar(A,C,Ar),
	frontchar(B,C,Br),
	name_match2(Ar,Br).

  any_til(A,B):-
	name_match2(A,B),!.
  any_til(A,B):-
	frontChar(B,_,Br),
	any_til(A,Br).

/**************************************************************************
	Collect and compress the files in the userscript
***************************************************************************/
predicates
  determ make_install(MAKE_SCRIPT,INSTALL_SCRIPT)
  procedure collectTree(INCLUDE_LIST, DIRECTORY, LOCAL_EXCLUDES)
  nondeterm filesInDir(INCLUDE_LIST,DIR_ENTRY,LOCAL_EXCLUDES)
  procedure modify_tree(FROM_PATH,DIRECTORY,DIRECTORY)
  procedure mt(STRINGLIST,DIRECTORY,DIRECTORY)
  procedure descend(FROM_PATH)
  determ excluded(String,LOCAL_EXCLUDES)
  procedure disallow1(INTEGER,STRING)
clauses
  make_install([group(Id, Paths, LocalExcludes, MaskList)|GTail],
	      [igroup(Id, TreeFpos, TreeSize,DirBinCrc)|ITail]):-
	not(bad_group(Id)),!,
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

	term_bin(directory, ArcDir2, DirBin),
        
	DirBinCrc=init32 - crc32binary(DirBin,init32),
	writeCompFpos(fdir, DirBin, TreeSize, TreeFpos),
	!,
	make_install(GTail,ITail).

  make_install([group(Id,_,_,_)|GTail],Itail):-
	bad_group(Id),!,
	make_install(GTail,ITail).
  make_install([],[]):-!.
  make_install(_,_):-
	write_log_msg("Error In Make_Install"),fail.


  mt([], A, A):-!.
  mt([H|T], A, [subdir(H,A2)]):-
	mt(T,A,A2).

  modify_Tree(fromInstallRoot,A,A):-!.
  modify_Tree(startFromPath(H),A,[subdir(H,A)]):-!.

  descend(fromInstallRoot):-!.
  descend(startFromPath(H)):-
	disk(H),!.
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
	name_match(Mask,FileName),!.
  excluded(Filename,excluding(Excludes)):-
	member(Mask,Excludes),
	name_match(Mask,FileName),!.


  disallow1(1,X):-!,
	format(MSG,"invalid mask: %s",X),
  	write_log_msg(MSG),
  	exit(0).
  disallow1(_,_).


predicates
  procedure out_progress(INTEGER progress)
clauses
  out_progress(Iperc):-
	cursor(Y,_),
	cursor(Y,1),
	writedevice(WAS),
	writedevice(screen),
	write("Copy Progress:" ,IPerc,"%   "),
	writedevice(WAS).



/************************************************************************
	Copy the Image file to floppy disc's
*************************************************************************/
predicates
  procedure subToBinary(BINARY,ULONG)
  nondeterm repeat
  determ copyToFloppy (Dword BytesLeft,Dword DiskLeft,Integer DiskNo,STRING path,Integer LDrive,Binary dWArray)
  determ copyToFloppy2(Binary bytesLeft,Binary diskLeft,Binary diskNo,STRING path,Binary dWArray)
  determ copyToOne(Binary bytesLeft)
  procedure clearKeyboardBuffer % Empty the keyboard buffer


clauses
  
  repeat.
  repeat:-repeat.


  subToBinary(Bin,Add):-
	Val = getDwordEntry(Bin,0),
	Val2=Val-Add,
	setDwordEntry(Bin,0,Val2).

  copyToOne(BytesLeft):-
  	Bytes=getDwordEntry(BytesLeft,0),
  	Bytes>0xFF00,!,
	readblock(0xFF00,BIn),
	writeblock(0xFF00,BIn),
	subToBinary(BytesLeft,0xFF00),
	fail.

  copyToOne(BytesLeft):-
  	Bytes=getDwordEntry(BytesLeft,0),
  	readblock(Bytes,In),
	writeblock(Bytes,In),!.
	
predicates	
  procedure Long  get_freeSpace(Char drive,Long subFromSize)
clauses
  get_freeSpace(_,SUB,RESULT):-
	volume_size(Size),
	Size>SUB,!,
	RESULT = Size-SUB.
  get_freeSpace(_,_,0):-
	volume_size(_),!,
	write("Error: Volume size should be bigger!"),
	exit(1).
  get_freeSpace(D,_,S):-
	diskSpace(D,S).
	
  copyToFloppy(BytesTotal,DiskLeft,D_No,_,D_No,_):-	% COPY file on one disk without prompt
	BytesTotal<DiskLeft,!,	
	Bytes=makeBinary(4),
	setDwordEntry(Bytes,0,BytesTotal),
	repeat,
	  Current=BytesTotal-getDwordEntry(Bytes,0),
	  Perc= Current/ BytesTotal * 100,
	  Iperc=val(integer,Perc),
	  out_progress(Iperc),
	  copyToOne(Bytes),!,
	out_progress(100).
	
  copyToFloppy(BytesTotal,DiskLeft,D_No,Drive,LastDrive, DiskArray):-
	Bytes=makeBinary(4),
	setDwordEntry(Bytes,0,BytesTotal),
	Disk=makeBinary(4),
	setDwordEntry(Disk,0,DiskLeft),
	Disk_No=makeBinary(2),
	setWordEntry(Disk_no,0,D_No),
	repeat,
	  Current=BytesTotal-getDwordEntry(Bytes,0),
	  Perc= Current/ BytesTotal * 100,
	  Iperc=val(integer,Perc),
	  out_progress(Iperc),
	  copyToFloppy2(Bytes,Disk,Disk_No,Drive, DiskArray),
	  !,
	  out_progress(100),
	LastDrive = getWordEntry(Disk_No,0).
	
	  % We have reached the end
  copyToFloppy2(Bytes,Disk,_,_,_):-
	BytesLeft=getDwordEntry(Bytes,0),
	DiskLeft =getDwordEntry(Disk ,0),
	BytesLeft<=DiskLeft,
	BytesLeft<=0xFF00,
	!,
	readblock(BytesLeft,BIn),
	writeblock(BytesLeft,BIn).		%not fail!

  % The current disc gets full
  copyToFloppy2(Bytes,Disk,D_Number,Drive,DiskArray):-
	DiskLeft =getDwordEntry(Disk ,0),
	Dno	 =getWordEntry(D_Number ,0),

	DiskLeft<=0xFF00,!,
	readblock(DiskLeft,In),
	writeblock(DiskLeft,In),

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
	readchar(_),nl,
	filenamePath(FileName2, DRIVE,"DISK_"),
	format(FileName,"%s%",FileName2,Dno2),
	openwrite(diskfile,FileName),
	filemode(diskfile,binary_filemode_flag),
	readdevice(archive),
	writedevice(diskfile),
	frontChar(Drive,DriveChar,_),
	D2 = get_freeSpace(DriveChar,0),
	subToBinary(Bytes,DiskLeft),
	setDwordEntry(Disk,0,D2),!,
	fail.

  % Default, Put another 64K block to the disk !
  copyToFloppy2(BL,DL,_,_,_):-
	readblock(0xFF00,In),
	writeblock(0xFF00,In),
	subToBinary(BL,0xFF00),
	subToBinary(DL,0xFF00),!,
	fail.


  clearKeyboardBuffer:- inkey(_), !, clearKeyboardBuffer.
  clearKeyboardBuffer.


predicates
  determ mayChangeDisk(Word,Word)
clauses
  mayChangeDisk(D_no,D_no):-!.
  mayChangeDisk(_,_):-
	writeDevice(screen),
	write_log_msg("\nPlace Disk 1 in drive"),
	readDevice(keyboard),
	readChar(_).

/************************************************************************
	The main code for building the compressed image
*************************************************************************/

predicates
  procedure mayMake(STRING Path)
  determ make(INTEGER,STRING path)
  determ make2(STRING Root,STRING path,BINARY,STRING)
  procedure multimkdir(STRING)	
  procedure cutdir(STRING,STRING)
  procedure trapmkdir(STRING)	
clauses
  trapMKDir(D):-
	trap(mkdir(D),_,fail),
	fail.
  trapMKdir(_).
  
  cutdir(DIR,CUTDIR):-
	searchchar(Dir,'\\',Pos),
	Pos>1,!,
	Npos=Pos-1,
	substring(DIR,1,NPOS,CUTDIR).
	
  cutdir(DIR,DIR).

  multimkdir(DIR):-
   	not(searchchar(Dir,':',_)),
  	cutDir(Dir,CD),
  	trapmkdir(CD),
  	disk(CD),
 	searchchar(Dir,'\\',Pos),!,
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
	multiMKDir(Ndir),!.
  multiMKDir(_).

 
  mayMake(DirName):-
	disk(DIR),
	multimkdir(DirName),
	disk(DIR).
 
predicates
  procedure ULONG correct_size(ULONG)
  determ add_size_to_temp(STRING fileName)
clauses
  correct_size(SIZE,SIZE):-
	S = Size mod 512,
	S = 0,!.
  correct_size(SIZE,SizeC):-
	S = Size div 512,
	SizeC = (S+1)*512,!.
	
  add_size_to_temp(NAME):-
	dirfiles(NAME,0x61,_,_,_,_,_,_,_,_,Size),
	retract(temp_files_size(Old)),!,
	C = correct_size(Size),
	New = Old+C,
	assert(temp_files_size(New)).

predicates
  procedure c_copy_fdir(STRING,STRING)
  procedure copy_fdir16(STRING,STRING)
  procedure copy_fdir32(STRING,STRING)
  procedure modify_fdir(STRING,BINARY)
clauses
  copy_fdir16(_,_):-
  	have_sw(p('n',_)),!.
  copy_fdir16(Name,FullName):-
	c_copy_fdir(Name,FullName).

  copy_fdir32(_,_):-
	have_sw(p(_,'n')),!.
  copy_fdir32(Name,FullName):-
	c_copy_fdir(Name,FullName).
	
  c_copy_fdir(Name,FullName):-
	copyfile(Name,FullName),
	add_size_to_temp(NAME),!.
  c_copy_fdir(_,_):-!.

	
  modify_fdir(Name,DiskArray):-
  	format(MSG,"\n modify fdir:%s started",Name),
	write_log_msg(MSG),
	existfile(Name),
	openmodify(fdir,Name),
	filemode(fdir,binary_filemode_flag),
	filepos(fdir,0,0),
	writedevice(fdir),
	filepos(fdir,16,0),
	writeblock(0, DiskArray),
	closefile(fdir),!,
	write_log_msg("OK\n").
  modify_fdir(_,_):-
	write_log_msg("Error"),
  	!.
/****************************************************************
	copy files to floppy disk's  via "copy_Files_Script"
*****************************************************************/
predicates
 procedure add_files_to_distr(STRING from,STRING to)
 determ add_files_to_distr2(STRING from,STRING to,INTEGER group)
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
	   %fileNamePath(FR,FROM,PATH),
	   fileNamePath(SRC,FROM,FILE),
	   fileNamePath(DST,TO,Name),
	   format(MSG,"coping %s\n",FILE),
	   write_log_msg(MSG),
	   trap(copyFile(SRC,DST),_,write_log_msg("Error Coping!\n")),
	   add_size_to_temp(SRC),
	 fail.

/*********************************
***********************************/
  make(_Switch, Path):-
	disk(".."),
	disk(InstallRoot),
	mayMake(bu_INSTALL_INT_NAME),
	DaSize= (max_Disks + 4) * 4,
	DiskArray = makeBinary(DaSize),
	make2(InstallRoot,Path, DiskArray,bu_IMAGE_NAME).
		% this part do packed image
  make2(InstallRoot,_, DiskArray, ArcRoot):-
	testSwitch(make_image),
	disk(bu_INSTALL_INT_NAME),
	fileNameExt(ArcName, ArcRoot, ".IMG"),

	format(LMSG1,"creating packed image: %s\n",ArcName),
	write_log_msg(LMSG1),
	
	openwrite(archive, ArcName),
	filemode(archive, binary_filemode_flag),

	openwrite(fdir,bu_FDIR_NAME),
	openFDir_s(DiskArray),

	filemode(fdir,binary_filemode_flag),
	writedevice(fdir),
	writeblock(0, DiskArray),	    % here, just reserving space
	writedevice(fdir),

	disk(InstallRoot),

	make_script(MScript),			% Get user specified script

	writeDevice(OldCheck),
	writeDevice(screen),
	check_install(MScript), 		%test for exist all group's pathes
	writeDevice(OldCheck),

	make_install(MScript,IScript),  	% write 1 tree per group
	Iscript2=IScript,

 	ScriptBin = script2RawBin(Iscript2),

	closeFDir_s(DiskArray),

	SCrc = init32 - crc32binary(ScriptBin,init32),
	writeCompFpos(fdir, ScriptBin, SSize, SFpos),

	setDwordEntry(DiskArray,0,max_Disks),
	setDwordEntry(DiskArray,1,SFpos),
	setDwordEntry(DiskArray,2,SSize),
	setDwordEntry(DiskArray,3,SCRC),
	closefile(archive),

	filepos(fdir,0,0),
	writedevice(fdir),
	writeblock(0, DiskArray),
	closefile(fdir),
	write_log_msg("Packing OK.\n"),
	fail.
			% This Part making Disributive
  make2(InstallRoot, Drive, _,ArcName):-
	testSwitch(make_DSet),!,
	assert(temp_files_size(0)),
	disk(InstallRoot),
	mayMake(DRIVE),
	disk(bu_INSTALL_INT_NAME),

	DiskArray=makeBinary(max_Disks,4),
/***/
	openread(archive,ArcName),
	filemode(archive, binary_filemode_flag),

	writedevice(screen),
	readdevice(keyboard),
	format(LMSG3,"\nInsert disk 1 in drive %s\n",Drive),
	write_log_msg(LMSG3), 
	readchar(_),
  % Copy non standart files
	disk(FromPath),				%-| MZ add 17.09.96
	add_files_to_distr(FromPath,DRIVE),	%/
  % Copy FDIR's  
	filenamePath(DiskFdir  ,DRIVE,bu_FDIR_NAME  ),
	filenamePath(DiskFdir32,DRIVE,bu_FDIR32_NAME),
	copy_fdir16(bu_FDIR_NAME  , DiskFdir  ),%copyfile("FDIR", DiskFdir),
	copy_fdir32(bu_FDIR32_NAME, DiskFdir32),%add_size_to_temp("FDIR"),

  % Copy the large image to discs
	filenamePath(FlopName, DRIVE,"DISK_1"),

	openwrite(diskfile,FlopName),
	filemode(diskfile,binary_filemode_flag),
	writedevice(diskfile),
	readdevice(archive),
	filepos(archive,0,2),
	filepos(archive, TotalArcSize,0),
	filepos(archive,0,0),
	frontChar(Drive,DriveChar,_),

	temp_files_size(Size_For_Sub),!,
	FreeSpace = get_freeSpace(DriveChar,Size_For_Sub),
	copyToFloppy(TotalArcSize, FreeSpace,1,Drive,Last,DiskArray),

	filepos(diskfile,Fsize,0),

	Di=Last-1,
	
	setDwordEntry(DiskArray, Di, Fsize),

	closefile(diskfile),

	mayChangeDisk(1,Last),

	modify_fdir(DiskFDir  ,DiskArray),
	modify_fdir(DiskFDir32,DiskArray),

	disk(InstallRoot),!,
	write_log_msg("Copy OK.\n").

  make2(_,_,_,_):-!,
  	not(testSwitch(make_image)),
	write_log_msg("You should use /d or /i switches.\n"),
	disk(bu_INSTALL_INT_NAME),!
	;
	true.

predicates
  procedure getPath(STRING,STRING,STRING)
  procedure cutFrontSpace(STRING,STRING)
clauses
  cutFrontSpace(PathI,Cut):-
	frontChar(PathI,' ',P),!,
	cutFrontSpace(P,Cut).
  cutFrontSpace(PATH,PATH).
	

  getPath(Args,Path,Rest):-
	searchChar(Args,' ',SpacePos),
	SpacePos2=SpacePos-1,
	frontstr(SpacePos2,Args,Path,Rest),!.
  getPath(Path,Path,""):-!.

	
		

/************************************************************************
	The main GOAL
*************************************************************************/
GOAL
	assert(  have_sw(p('y','n'))),		% default cfg
	open_log(),
ifdef professional
	write_log_msg("\n\tPROFESSIONAL"),
elsedef
	write_log_msg("\n\tSTANDARD "),
enddef

ifdef cd_ver
	write_log_msg("\t 'CD' "),
elsedef
	write_log_msg("\t DISK "),
enddef
	write_log_msg(" VERSION"),nl,
	comline(ARGS),
	cutFrontSpace(ARGS,CutARGS),
	upper_lower(CutARGS, ArgsLow),
	getPath(ArgsLow,Letter,Rest),
	parse_CmdLine(Rest),
	frontchar(Letter,_,Drive1),
	frontchar(Drive1,':',_),
	upper_lower(Drive,Letter),
	make(0, Drive),
	close_Log()
	  ;
	write("options: BUILD <Drive:\\[Path]> [/d|/i] [/Vxx] [/32|/both]\n\n",
		"all option are isn't case sensitive\n",
		"/d - create distributive set from exist image (only copy files).\n",
		"/i - create packed image only.\n",
ifdef cd_ver
		"in 'CD' version option /Vxx ignored\n",
%%		"/MM - use multimedia group (setup can play animation )\n",
elsedef
		"/Vxx -set multivolume distibutive set mode , when xx- size of volume.\n",
%%		"/MM - option used only for 'CD' version\n",
enddef
		"/32 - enable generation only  for 32bit platform\n" ,
		"/both -enable generation for both 32bit and 16 bit platforms\n"
	    ).
