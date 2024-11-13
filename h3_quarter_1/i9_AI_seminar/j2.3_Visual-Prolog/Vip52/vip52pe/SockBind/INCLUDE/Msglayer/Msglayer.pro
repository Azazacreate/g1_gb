/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Tool: Message layer
 FileName: msglayer.pro
 Purpose: A layer on top of sockets
 Written by: Visual Prolog
 Comments:
******************************************************************************/

CONSTANTS
  wm_socket = 0xC400		% picked almost at random
ifndef os_os2
  wm_async_req = 0xC401		% for sck_AsyncGetHostByName
enddef
  msgl_sendevent = 0xC402
  
  msgl_back_log = 5
    
  packed_begin_text = "REYALGSM"
  packed_end_text = "MSGLAYER"

  msgl_max_msg_size = 25000
  msgl_SyncConnect	= 0
  msgl_AsyncConnect	= 1
  
DOMAINS
  MSGL_CHARLIST = CHAR*
  MSGLAY_ERR_DOM = 
    msglay_err1(UNSIGNED);
    msglay_err2(SOCKET,UNSIGNED)
/*-------------------------------------------------------------------------
Socket administration
-------------------------------------------------------------------------*/

DATABASE - msgl_socket_administration
  determ msgl_window_db(WINDOW)
  nondeterm msgl_socket_handle_db(SOCKET, MSGLAY_HANDLER)
  nondeterm msgl_socket_eventqueue_db(SOCKET, MSGLAY_EVENT)
  nondeterm msgl_socket_option_db(SOCKET, MSGLAY_OPT)
  nondeterm msgl_softCloseOn_db(SOCKET)
  msgl_db_isclose( SOCKET )

DATABASE - msgl_read_db
  nondeterm msgl_read_que_db(SOCKET,BINARY)
  nondeterm msgl_socket_readLength_db(SOCKET, INTEGER Read_lengthBytes, ULONG WantedLength)
  nondeterm msgl_socket_readIndex_db(SOCKET, ULONG Index, ULONG MsgNum)
  nondeterm msgl_socket_msgNum_db(SOCKET, ULONG MsgNum)
  nondeterm msgl_socket_readNullStr_db(SOCKET, MSGL_CHARLIST)
  nondeterm msgl_socket_readTemp_db(SOCKET, ULONG Index, BINARY)
  nondeterm msgl_wrongFormatMsg_db(SOCKET, BINARY)
  nondeterm msgl_readPackBegin_db(SOCKET, STRING)
  nondeterm msgl_readPackEnd_db(SOCKET, STRING)
  determ msgl_treadDataInProcess_db

DATABASE - msgl_write_que
  nondeterm msgl_write_que_db(SOCKET, BINARY)
  nondeterm msgl_write_ready_db(SOCKET)

DATABASE - msgl_error
  determ msgl_last_error_db(MSGLAY_ERR_DOM)

ifndef os_os2
DATABASE - msgl_async_db
  ml_async_req_db(SCK_HANDLE,SOCKET,USHORT)
enddef

/*-------------------------------------------------------------------------
 Handling errors 
-------------------------------------------------------------------------*/
PREDICATES
  msgl_errConnect(SOCKET,UNSIGNED)
  msgl_errListen(SOCKET,UNSIGNED)
  msgl_errClose(SOCKET,UNSIGNED)
  msgl_errGetInf(SOCKET,UNSIGNED)
ifdef os_os2  
  msgl_errHost(UNSIGNED)
enddef
  msgl_errCreate(UNSIGNED)
  determ msgl_errWrite(SOCKET,UNSIGNED)
  determ msgl_errEvent(SOCKET,UNSIGNED, MSGLAY_ERROR_KIND)
  msgl_errCode(UNSIGNED ErrIn, UNSIGNED ErrOut)

CLAUSES
  msgl_errCode(err_SckGeneral,ErrOut):-
	ErrOut = sck_GetLastError(),!.
  msgl_errCode(err_SckInvalidParms,ErrOut):-
	ErrOut = sck_GetLastError(),!.
  msgl_errCode(Err, Err).

  msgl_errConnect(_, ErrIn):- 
	msgl_errCode(ErrIn, ErrOut),
	ErrOut = err_sockwouldblock,
	!.
  msgl_errConnect(Socket, ErrIn):-			% Not able to connect socket
	msgl_errCode(ErrIn, ErrOut),
	retractall(msgl_last_error_db(_)),
	assert(msgl_last_error_db(msglay_err2(Socket,ErrOut))),
	exit(msglay_errConnect).

  msgl_errListen(Socket, ErrIn):-			% Not able to make listen
	msgl_errCode(ErrIn, ErrOut),
	retractall(msgl_last_error_db(_)),
	assert(msgl_last_error_db(msglay_err2(Socket,ErrOut))),
	exit(msglay_errListen).
	
  msgl_errClose(Socket, ErrIn):-			
	msgl_errCode(ErrIn, ErrOut),
	retractall(msgl_last_error_db(_)),
	assert(msgl_last_error_db(msglay_err2(Socket,ErrOut))),
	exit(msglay_errClose).
	
  msgl_errGetInf(Socket, ErrIn):-			
	msgl_errCode(ErrIn, ErrOut),
	retractall(msgl_last_error_db(_)),
	assert(msgl_last_error_db(msglay_err2(Socket,ErrOut))),
	exit(msglay_errGetInf).
	
ifdef os_os2
  msgl_errHost(ErrIn):-					% Not able to find host
	msgl_errCode(ErrIn, ErrOut),
	retractall(msgl_last_error_db(_)),
	assert(msgl_last_error_db(msglay_err1(ErrOut))),
	exit(msglay_errHost).
enddef

  msgl_errCreate(ErrIn):-				% Not able to create a socket 
	msgl_errCode(ErrIn, ErrOut),
	retractall(msgl_last_error_db(_)),
	assert(msgl_last_error_db(msglay_err1(ErrOut))),
	exit(msglay_errCreate).
    
  msgl_errWrite(_,ErrIn):-
	msgl_errCode(ErrIn, ErrOut),
	ErrOut = err_sockwouldblock,!,
	fail.
  msgl_errWrite(Socket,ErrIn):-
	msgl_errCode(ErrIn, ErrOut),
	retractall(msgl_last_error_db(_)),
	assert(msgl_last_error_db(msglay_err2(Socket,ErrOut))),
	exit(msglay_errWrite).
	
  msgl_errEvent(_Socket, ErrIn, _Event):-
	msgl_errCode(ErrIn, ErrOut),
	ErrOut = err_sockwouldblock,
	!.
  msgl_errEvent(Socket, ErrIn, Event):-
	msgl_errCode(ErrIn, ErrOut),
	retractall(msgl_last_error_db(_)),
	assert(msgl_last_error_db(msglay_err2(Socket,ErrOut))),!,
	assertz(msgl_socket_eventqueue_db(Socket, e_Error(Event))),
	msgl_window_db(Win),
	win_SendEvent(Win,e_Native(msgl_sendevent,0,0)),!,
	fail.

%___________________________________________________
%     		Determs a destination address
%___________________________________________________
PREDICATES
  procedure msgl_make_conn( SOCKET, USHORT, STRING )		- (i,i,i)
  msgl_what_rem_inf(SCK_ADDRESS,STRING,UNSIGNED)
  msgl_Conn( SOCKET, SCK_ADDRESS, BOOLEAN )		- (i,i,i)
CLAUSES
  msgl_make_conn(Socket,Port,Host):-		% Server = "139.88.66.55"
  	trap(Host_l = sck_InetAddr(Host),_,true),	%error if INADDR_NONE
  	Port_h = sck_ntohs(Port),
  	Addr = sck_MergeAddress_IN(af_inet,Port_h,Host_l),
  	msgl_Conn(Socket, Addr, msgl_SyncConnect ),!.
  msgl_make_conn(Socket,Port,Host):-		% Server = "spb_nt_server"
ifdef os_os2
	trap(Hostent = sck_GetHostByName(Host), Error1, msgl_errHost(Error1)),
	Hostent = sck_hostent(_,_,_,_,Addrs),
	Port_h = sck_ntohs(Port),
	Addrs = [Host_l|_],
	Addr = sck_MergeAddress_IN(af_inet,Port_h,Host_l),
	msgl_Conn(Socket, Addr, msgl_SyncConnect ),!.
elsedef
	msgl_window_db(Win),
	Sck_Win = cast(SCK_HWND,Win),
	trap(HTask = sck_AsyncGetHostByName(Sck_win,wm_async_req,Host,sck_MaxGetHostStruct),Err,msgl_errConnect(Socket,Err)),
	assert(ml_async_req_db(HTask,Socket,Port)),
	!.
enddef
  msgl_make_conn(_,_,_).		%dummy to avoid "msgl_window_db(Win)," failure
	
%______Returns connected host IP address in dotted format if a host name cannot be resolved
  msgl_what_rem_inf(Hostaddr,Host,Port):-
  	sck_SplitAddress_IN(Hostaddr,_,Port_h,Addr_1),
	Port = sck_htons(Port_h),
	trap(Hostent = sck_GetHostByAddr(Addr_1,af_inet),_, true),
	Hostent = sck_hostent(Host,_,_,_,_),
	!.
  msgl_what_rem_inf(Hostaddr,Host,Port):-  % socket_GetHostByAddr exits with error
    	sck_SplitAddress_IN(Hostaddr,_,Port_h,Addr_1),
	Port = sck_htons(Port_h),
	Host = sck_InetNtoa(Addr_1),
	!.
	
/*-------------------------------------------------------------------------
 Handling reading 
 The read que is only used if there is no handler assigned to the socket.
-------------------------------------------------------------------------*/
Predicates
  msgl_data_read(SOCKET,BINARY)
  procedure msgl_read_ready(SOCKET)
  determ msgl_treadData(SOCKET, BINARY)
  determ msgl_endTreadData(SOCKET, BINARY, ULONG MsgNum)
  nondeterm msgl_readPackedStr_nd(SOCKET, BINARY, ULONG MsgNum, STRING)
  msgl_bin2Str(BINARY, STRING)
  nondeterm msgl_readStrUntilNull(SOCKET, BINARY, ULONG MsgNum, STRING)
  nondeterm msgl_readPackedBin_nd(SOCKET, BINARY, ULONG MsgNum, BINARY)
  determ msgl_readLength(SOCKET, BINARY, ULONG MsgNum, UNSIGNED MaxIndex, UNSIGNED)
  determ msgl_readBin(SOCKET, BINARY, UNSIGNED, ULONG MsgNum)
  determ msgl_readPackBegin(SOCKET, BINARY, UNSIGNED MaxIndex, ULONG MsgNum)
  determ msgl_readPackEnd(SOCKET, BINARY, UNSIGNED MaxIndex, ULONG MsgNum)  

  determ msgl_insertReadBin(SOCKET, BINARY, UNSIGNED, UNSIGNED)
  determ msgl_getReadBin(SOCKET, BINARY)
  msgl_initReadBin(SOCKET, UNSIGNED)
  determ msgl_getReadStr(SOCKET, STRING)
  msgl_initReadStr(SOCKET, UNSIGNED Length)

  msgl_initReadNullStr(SOCKET)
  determ msgl_insertReadNullStr(SOCKET, CHAR, ULONG Index, ULONG MsgNum, STRING)
  msgl_revers(msgl_charList, STRING, STRING)

  nondeterm msgl_repeatRead_nd(SOCKET, BINARY, ULONG MsgNum)
  determ msgl_resetReadIndex(SOCKET, ULONG MsgNumber)

Clauses
  msgl_data_read(Socket,Bin):-
    assertz(msgl_read_que_db(Socket, Bin)),
    msgl_read_ready(Socket).

  msgl_read_ready(Socket):- % This predicate is called from msglay_setHandle and msgl_data_read
    not(msgl_treadDataInProcess_db),
    retract(msgl_read_que_db(Socket,Bin)),	 % process what's in the que
      msgl_treadData(Socket, Bin), 
    fail.     
  msgl_read_ready(_Socket). % All data processed


%- msgl_treadData ------------------------------------------------------------
% Tread the incomming data according to the rcv option
  msgl_treadData(_,_):-
	assert(msgl_treadDataInProcess_db),
	fail.

  msgl_treadData(Socket, BinIn):-
    msgl_socket_option_db(Socket, msglay_Rcv(packed_str)),
    msgl_ResetReadIndex(Socket, MsgNum),
    msgl_readPackedStr_nd(Socket, BinIn, MsgNum, StrOut),
      assertz(msgl_socket_eventqueue_db(Socket, e_ReadStr(StrOut))),
      msgl_window_db(Win),
      win_SendEvent(Win,e_Native(msgl_sendevent,0,0)),
    fail.
  msgl_treadData(Socket, BinIn):-
    msgl_socket_option_db(Socket, msglay_Rcv(unpacked_str)),!,
    msgl_bin2Str(BinIn, StrOut),
    retract(msgl_treadDataInProcess_db),
    assertz(msgl_socket_eventqueue_db(Socket, e_ReadStr(StrOut))),
    msgl_window_db(Win),
    win_SendEvent(Win,e_Native(msgl_sendevent,0,0)).
  msgl_treadData(Socket, BinIn):-
    msgl_socket_option_db(Socket, msglay_Rcv(untilNull_str)),
    msgl_resetReadIndex(Socket, MsgNum),
    msgl_repeatRead_nd(Socket,BinIn,MsgNum),
      msgl_initReadNullStr(Socket),
      msgl_readStrUntilNull(Socket, BinIn, MsgNum, StrOut),
      assertz(msgl_socket_eventqueue_db(Socket, e_ReadStr(StrOut))),
      msgl_window_db(Win),
      win_SendEvent(Win,e_Native(msgl_sendevent,0,0)),
    fail.
  msgl_treadData(Socket, BinIn):-
    msgl_socket_option_db(Socket, msglay_Rcv(packed_bin)),
    msgl_resetReadIndex(Socket, MsgNum),
    msgl_readPackedBin_nd(Socket, BinIn, MsgNum, BinOut),
      assertz(msgl_socket_eventqueue_db(Socket, e_ReadBin(BinOut))),
      msgl_window_db(Win),
      win_SendEvent(Win,e_Native(msgl_sendevent,0,0)),
    fail.
  msgl_treadData(Socket, BinIn):-
    msgl_socket_option_db(Socket, msglay_Rcv(unpacked_bin)),!,
    retract(msgl_treadDataInProcess_db),
    assertz(msgl_socket_eventqueue_db(Socket, e_ReadBin(BinIn))),
    msgl_window_db(Win),
    win_SendEvent(Win,e_Native(msgl_sendevent,0,0)).
  msgl_treadData(_, _):-
    retractall(msgl_treadDataInProcess_db).

    
  msgl_endTreadData(Socket, BinIn, MsgNum):-
	msgl_socket_readIndex_db(Socket, Index, MsgNum),
	MaxIndex = getbinarysize(BinIn) - 1,
	Index > MaxIndex,!,
	retract(msgl_treadDataInProcess_db).
  msgl_endTreadData(_,_,_).
    
  
%- Read packed strings --------------------------------------------------------
  msgl_readPackedStr_nd(Socket, BinIn, MsgNum, StrOut):-
	MaxIndex = getbinarysize(BinIn) - 1,
	msgl_repeatRead_nd(Socket, BinIn, MsgNum),
        msgl_readLength(Socket, BinIn, MsgNum, MaxIndex, Length),
	msgl_readPackBegin(Socket, BinIn, MaxIndex, MsgNum),
	msgl_initReadStr(Socket, Length),
	msgl_readBin(Socket, BinIn, Length, MsgNum),
	msgl_readPackEnd(Socket, BinIn, MaxIndex, MsgNum),
	msgl_getReadStr(Socket, StrOut),
	msgl_endTreadData(Socket, BinIn, MsgNum).

%- Read packed binary messages ------------------------------------------------
  msgl_readPackedBin_nd(Socket, BinIn, MsgNum, BinOut):-
	MaxIndex = getbinarysize(BinIn) - 1,
	msgl_repeatRead_nd(Socket, BinIn, MsgNum),
	msgl_readLength(Socket, BinIn, MsgNum, MaxIndex, Length),
	msgl_readPackBegin(Socket, BinIn, MaxIndex, MsgNum),
	msgl_initReadBin(Socket, Length),
	msgl_readBin(Socket, BinIn, Length, MsgNum),
	msgl_readPackEnd(Socket, BinIn, MaxIndex, MsgNum),
	msgl_getReadBin(Socket, BinOut),
	msgl_endTreadData(Socket, BinIn, MsgNum).
    
%- Converts a binary to a string ----------------------------------------------
%- Where there is no null at the end of the string     
  msgl_bin2Str(Bin, Str):-
	Str1 = cast(string, Bin),
	Len = getbinarysize(Bin),
	Len1 = Len + 1,
	Bin1 = composebinary(Str1, Len1),
	setbyteentry(Bin1, Len, 0),
	Str = cast(string, Bin1).
     
%- Read the incomming binary message into a string until a null ---------------
  msgl_readStrUntilNull(Socket, BinIn, MsgNum, StrOut):-
	msgl_socket_readIndex_db(Socket, Index_ul, MsgNum),    % while Index <= MaxIndex
	Index = val( UNSIGNED, Index_ul ),
	MaxIndex = getbinarysize(BinIn) - 1,
	Index <= MaxIndex,
	Elm = getbyteentry(BinIn, Index),
	NextIndex = Index + 1,
	msgl_insertReadNullStr(Socket, Elm, NextIndex, MsgNum, StrOut), % break if Elm = 0
	msgl_endTreadData(Socket, BinIn, MsgNum),
	!.
  msgl_readStrUntilNull(Socket, BinIn, MsgNum, _):-
	msgl_socket_readIndex_db(Socket, Index, MsgNum),
	MaxIndex = getbinarysize(BinIn) - 1,
	Index > MaxIndex,!,
	retract(msgl_treadDataInProcess_db),
	fail.    

%- Reads the four length bytes ------------------------------------------------
  msgl_readLength(Socket, _BinIn, _, _, Length):-
	msgl_socket_readLength_db(Socket, 4, Length),
	!. % The four length bytes has been read
        
  msgl_readLength(Socket, BinIn, MsgNum, MaxIndex, Length):-
	msgl_socket_readLength_db(Socket, 0, 0),
	msgl_socket_readIndex_db(Socket, Index_ul, MsgNum),
	Index = val( UNSIGNED, Index_ul ),
	Index + 4 <= MaxIndex,
	L1 = getbyteentry(BinIn, Index),
	I2 = Index + 1, L2 = getbyteentry(BinIn, I2),
	I3 = Index + 2, L3 = getbyteentry(BinIn, I3),
	I4 = Index + 3, L4 = getbyteentry(BinIn, I4),
	Length = ((L1 * 256 + L2) * 256 + L3) * 256 + L4,
	retract(msgl_socket_readLength_db(Socket, _, _)),
	assert(msgl_socket_readLength_db(Socket, 4, Length)),
	NextIndex = Index + 4,
	retract(msgl_socket_readIndex_db(Socket, _, MsgNum)),
	assert(msgl_socket_readIndex_db(Socket, NextIndex, MsgNum)),
	!.

  msgl_readLength(Socket, BinIn, MsgNum, MaxIndex, Length):-
	msgl_socket_readLength_db(Socket, ReadBytes, ReadLength),
	msgl_socket_readIndex_db(Socket, Index_ul, MsgNum),
	Index = val( UNSIGNED, Index_ul ),
	Index <= MaxIndex,
	Len = getbyteentry(BinIn,Index),
	NewLength = ReadLength * 256 + Len,
	NewReadBytes = ReadBytes + 1,
	retract(msgl_socket_readLength_db(Socket, _, _)),
	assert(msgl_socket_readLength_db(Socket, NewReadBytes, NewLength)),
	NextIndex = Index + 1,
	retract(msgl_socket_readIndex_db(Socket, _, MsgNum)),
	assert(msgl_socket_readIndex_db(Socket, NextIndex, MsgNum)),
	!,
	msgl_readLength(Socket, BinIn, MsgNum, MaxIndex, Length),
	!.

  msgl_readLength(Socket, _, MsgNum, MaxIndex, _):-
	msgl_socket_readIndex_db(Socket, Index, MsgNum),
	Index > MaxIndex,!,
	retract(msgl_treadDataInProcess_db),
	fail.

%- Reads the packed begin code ----------------------------------------------------
  msgl_readPackBegin(Socket, _BinIn, _, _MsgNum):-
	not(msgl_readPackBegin_db(Socket, _)),
	assert(msgl_readPackBegin_db(Socket, packed_begin_text)),
	fail.
    
  msgl_readPackBegin(Socket, _BinIn, _, _MsgNum):-
	msgl_readPackBegin_db(Socket, ""),  % The begin text has bin read
	!.
    
  msgl_readPackBegin(Socket, BinIn, MaxIndex, MsgNum):-
	msgl_readPackBegin_db(Socket, packed_begin_text),
	msgl_socket_readIndex_db(Socket, Index_ul, MsgNum),
	Index = val( UNSIGNED, Index_ul ),
	Index + 7 <= MaxIndex,
	'R' = getbyteentry(BinIn, Index),
	I1 = Index + 1, 'E' = getbyteentry(BinIn, I1),
	I2 = Index + 2, 'Y' = getbyteentry(BinIn, I2),
	I3 = Index + 3, 'A' = getbyteentry(BinIn, I3),
	I4 = Index + 4, 'L' = getbyteentry(BinIn, I4),
	I5 = Index + 5, 'G' = getbyteentry(BinIn, I5),
	I6 = Index + 6, 'S' = getbyteentry(BinIn, I6),
	I7 = Index + 7, 'M' = getbyteentry(BinIn, I7),
	!,
	retract(msgl_readPackBegin_db(Socket, _)),
	retract(msgl_socket_readIndex_db(Socket, _, MsgNum)),
	NextIndex = Index + 8,
	assert(msgl_readPackBegin_db(Socket, "")),
	assert(msgl_socket_readIndex_db(Socket, NextIndex, MsgNum)),
	!.

  msgl_readPackBegin(Socket, BinIn, MaxIndex, MsgNum):-
	msgl_readPackBegin_db(Socket, BeginText),
	frontchar(BeginText,Char,RestText),
	msgl_socket_readIndex_db(Socket, Index_ul, MsgNum),
	Index = val( UNSIGNED, Index_ul ),
	Index <= MaxIndex,
	ReadChar = getbyteentry(BinIn,Index),
	Char = ReadChar,
	!,
	retract(msgl_readPackBegin_db(Socket, _)),
	retract(msgl_socket_readIndex_db(Socket, _, MsgNum)),!,
	NextIndex = Index + 1,
	assert(msgl_readPackBegin_db(Socket, RestText)),
	assert(msgl_socket_readIndex_db(Socket, NextIndex, MsgNum)),
	msgl_readPackBegin(Socket, BinIn, MaxIndex, MsgNum),
	!.

  msgl_readPackBegin(Socket, BinIn, MaxIndex, MsgNum):-
	msgl_socket_readIndex_db(Socket, Index, MsgNum),
	Index <= MaxIndex,
	retract(msgl_socket_readIndex_db(Socket, _, MsgNum)),
	retract(msgl_readPackBegin_db(Socket, _)),
	Length = getbinarysize(BinIn),
	assert(msgl_socket_readIndex_db(Socket, Length, MsgNum)),
	assertz(msgl_wrongFormatMsg_db(Socket, BinIn)),
	retract(msgl_socket_readLength_db(Socket, _, _)),
	assert(msgl_socket_readLength_db(Socket, 0, 0)),
	assertz(msgl_socket_eventqueue_db(Socket, e_Error(msglay_errEvReadPacked))),
	msgl_window_db(Win),
	win_SendEvent(Win,e_Native(msgl_sendevent,0,0)),
	!,
	fail.
    
  msgl_readPackBegin(Socket, _, MaxIndex, MsgNum):-
	msgl_socket_readIndex_db(Socket, Index, MsgNum),
	Index > MaxIndex,!,
	retract(msgl_treadDataInProcess_db),
	fail.

%- Reads the packed end code ----------------------------------------------------
  msgl_readPackEnd(Socket, _BinIn, _, _):-
	not(msgl_readPackEnd_db(Socket, _)),
	assert(msgl_readPackEnd_db(Socket, packed_end_text)),
	fail.
    
  msgl_readPackEnd(Socket, _BinIn, _, _):-
	msgl_readPackEnd_db(Socket, ""),  % The End text has bin read
	!.
    
  msgl_readPackEnd(Socket, BinIn, MaxIndex, MsgNum):-
	msgl_readPackEnd_db(Socket, packed_end_text),
	msgl_socket_readIndex_db(Socket, Index_ul, MsgNum),
	Index = val( UNSIGNED, Index_ul ),
	Index + 7 <= MaxIndex,
	'M' = getbyteentry(BinIn, Index),
	I1 = Index + 1, 'S' = getbyteentry(BinIn, I1),
	I2 = Index + 2, 'G' = getbyteentry(BinIn, I2),
	I3 = Index + 3, 'L' = getbyteentry(BinIn, I3),
	I4 = Index + 4, 'A' = getbyteentry(BinIn, I4),
	I5 = Index + 5, 'Y' = getbyteentry(BinIn, I5),
	I6 = Index + 6, 'E' = getbyteentry(BinIn, I6),
	I7 = Index + 7, 'R' = getbyteentry(BinIn, I7),
	!,
	retract(msgl_readPackEnd_db(Socket, _)),
	retract(msgl_socket_readIndex_db(Socket, _, MsgNum)),
	NextIndex = Index + 8,
	assert(msgl_readPackEnd_db(Socket, "")),
	assert(msgl_socket_readIndex_db(Socket, NextIndex, MsgNum)),
	!.
    
  msgl_readPackEnd(Socket, BinIn, MaxIndex, MsgNum):-
	msgl_readPackEnd_db(Socket, BeginText),
	frontchar(BeginText,Char,RestText),
	msgl_socket_readIndex_db(Socket, Index_ul, MsgNum),
	Index = val( UNSIGNED, Index_ul ),
	Index <= MaxIndex,
	ReadChar = getbyteentry(BinIn,Index),
	Char = ReadChar,
	!,
	retract(msgl_readPackEnd_db(Socket, _)),
	retract(msgl_socket_readIndex_db(Socket, _, MsgNum)),!,
	NextIndex = Index + 1,
	assert(msgl_readPackEnd_db(Socket, RestText)),
	assert(msgl_socket_readIndex_db(Socket, NextIndex, MsgNum)),
	msgl_readPackEnd(Socket, BinIn, MaxIndex, MsgNum),
	!.

  msgl_readPackEnd(Socket, BinIn, MaxIndex, MsgNum):-
	msgl_socket_readIndex_db(Socket, Index, MsgNum),
	Index <= MaxIndex,
	retract(msgl_socket_readIndex_db(Socket, _, MsgNum)),
	retract(msgl_readPackBegin_db(Socket, _)),
	retract(msgl_readPackEnd_db(Socket, _)),
	Length = getbinarysize(BinIn),
	assert(msgl_socket_readIndex_db(Socket, Length, MsgNum)),
	assertz(msgl_wrongFormatMsg_db(Socket, BinIn)),
	retract(msgl_socket_readTemp_db(Socket, _, _)),
	retract(msgl_socket_readLength_db(Socket, _, _)),
	assert(msgl_socket_readLength_db(Socket, 0, 0)),
	!,
	assertz(msgl_socket_eventqueue_db(Socket, e_Error(msglay_errEvReadPacked))),
	msgl_window_db(Win),
	win_SendEvent(Win,e_Native(msgl_sendevent,0,0)),
	fail.

  msgl_readPackEnd(Socket, _, MaxIndex, MsgNum):-
	msgl_socket_readIndex_db(Socket, Index, MsgNum),
	Index > MaxIndex,!,
	retract(msgl_treadDataInProcess_db),
	fail.

%- Read the incomming binarymessage as a blocks of bytes and insert them into --    
%- the readTemp buffer, until there is no more to read, or the number of bytes in ----
%- msgl_socket_readLength_db has been read. -----------------------------------------
  msgl_readBin(Socket, BinIn, WantedLength, MsgNum):- 
	LengthIn = getbinarysize(BinIn),
	msgl_socket_readindex_db(Socket, Index_ul, MsgNum),
	Index = val( UNSIGNED, Index_ul ),
	AvailableLength = LengthIn - Index,
	WantedLength <= AvailableLength,!,
	% BinIn contains the rest of the message, and maybe more
	NextIndex = Index + WantedLength,
	msgl_insertReadBin(Socket, BinIn, Index, WantedLength),
	retract(msgl_socket_readIndex_db(Socket, _, MsgNum)),!,
	assert(msgl_socket_readIndex_db(Socket, NextIndex, MsgNum)),
	retract(msgl_socket_readLength_db(Socket, Rb, _)),!,
	assert(msgl_socket_readLength_db(Socket, Rb, 0)).
  msgl_readBin(Socket, BinIn, WantedLength, MsgNum):- 
	LengthIn = getbinarysize(BinIn),
	msgl_socket_readindex_db(Socket, Index_ul, MsgNum),
	Index = val( UNSIGNED, Index_ul ),
	AvailableLength = LengthIn - Index,
	% WantedLength > AvailableLength
	% BinIn contains less than the rest of the message
	NewWantedLength = WantedLength - AvailableLength,
	msgl_insertReadBin(Socket, BinIn, Index, AvailableLength),
	retract(msgl_socket_readIndex_db(Socket, _, MsgNum)),!,
	assert(msgl_socket_readIndex_db(Socket, LengthIn, MsgNum)),
	retract(msgl_socket_readLength_db(Socket, Rb, _)),!,
	assert(msgl_socket_readLength_db(Socket, Rb, NewWantedLength)),
	retract(msgl_treadDataInProcess_db),
	fail.

%- The database msgl_socket_readNullStr_db works as a buffer for the read charecters    
  msgl_initReadNullStr(Socket):-
	not(msgl_socket_readNullStr_db(Socket, _)),!,
	assert(msgl_socket_readNullStr_db(Socket, [])).
  msgl_initReadNullStr(_). % the nullstr has been initialised

  msgl_insertReadNullStr(Socket, 0, NextIndex, MsgNum, StrOut):-!,
	retract(msgl_socket_readIndex_db(Socket, _, MsgNum)),
	assert(msgl_socket_readIndex_db(Socket, NextIndex, MsgNum)),
	retract(msgl_socket_readNullStr_db(Socket, ReadList)),!,
	msgl_revers(ReadList, "", StrOut).
    
  msgl_insertReadNullStr(Socket, Elm, NextIndex, MsgNum, _):-
	retract(msgl_socket_readIndex_db(Socket, _, MsgNum)),
	assert(msgl_socket_readIndex_db(Socket, NextIndex, MsgNum)),
	retract(msgl_socket_readNullStr_db(Socket, ReadList)),
	assert(msgl_socket_readNullStr_db(Socket, [Elm|ReadList])),
	!,  
	fail.
    
  msgl_revers([], Str, Str):-!.
    
  msgl_revers([Char|RList], RStr, StrOut):-
	frontchar(Str, Char, RStr),
	msgl_revers(RList, Str, StrOut).
    
%- The database msgl_socket_readTemp_db works as a buffer for the read bytes    
  msgl_initReadBin(Socket, Length):-
	not(msgl_socket_readTemp_db(Socket, _, _)),!,
	BinInit = makebinary(Length),
	assert(msgl_socket_readTemp_db(Socket, 0, BinInit)).
  msgl_initReadBin(_, _). % ReadBin has been initialized

  msgl_insertReadBin(Socket, Source, IndexSrc, Length):-
	retract(msgl_socket_readTemp_db(Socket, IndexDest, Destination)),!,
	NewIndexDest = IndexDest + Length,
	
	PtrSrc1 = cast(STRING, Source),
	ptr_dword(PtrSrc1, SegSrc, OffSrc1),
	OffSrc2 = OffSrc1 + IndexSrc,
	ptr_dword(PtrSrc2, SegSrc, OffSrc2),

	PtrDst1 = cast(STRING, Destination),
	ptr_dword(PtrDst1, SegDst, OffDst1),
	OffDst2_ul = OffDst1 + IndexDest,
	OffDst2 = val( UNSIGNED, OffDst2_ul ),
	ptr_dword(PtrDst2, SegDst, OffDst2),
    	
    	PtrSrc3 = cast(POINTER, PtrSrc2),
    	PtrDst3 = cast(POINTER, PtrDst2),
	movMem(PtrSrc3, PtrDst3, Length),
	assert(msgl_socket_readTemp_db(Socket, NewIndexDest, Destination)).
    
  msgl_getReadBin(Socket, BinOut):- % Empty the buffer
	retract(msgl_socket_readTemp_db(Socket, _, BinOut)),
	retract(msgl_readPackBegin_db(Socket, _)),
	retract(msgl_readPackEnd_db(Socket, _)),
	retract(msgl_socket_readLength_db(Socket, _, _)),
	assert(msgl_socket_readLength_db(Socket, 0, 0)),!.

  msgl_initReadStr(Socket, Length):-
	not(msgl_socket_readTemp_db(Socket, _, _)),!,
	Length1 = Length + 1,
	BinInit = makebinary(Length1),
	setbyteentry(BinInit, Length, 0), % make it a null terminated string
	assert(msgl_socket_readTemp_db(Socket, 0, BinInit)).
  msgl_initReadStr(_,_).% readsString has been initialized
    
  msgl_getReadStr(Socket, Str):- % Empty the buffer
	retract(msgl_socket_readTemp_db(Socket, _, ReadBin)),
	retract(msgl_readPackBegin_db(Socket, _)),
	retract(msgl_readPackEnd_db(Socket, _)),
	retract(msgl_socket_readLength_db(Socket, _, _)),
	assert(msgl_socket_readLength_db(Socket, 0, 0)),!,
	Str = cast(string, ReadBin).

%- msgl_repeatRead ---------------------------------------------------------
%  Succedes while index <= Maxindex
  msgl_RepeatRead_nd(_Socket, _BinIn, _MsgNum).

  msgl_RepeatRead_nd(Socket, BinIn, MsgNum):-
	msgl_socket_readIndex_db(Socket, Index, MsgNum),
	MaxIndex = getbinarysize(BinIn) - 1,
	Index <= MaxIndex,
	msgl_RepeatRead_nd(Socket, BinIn, MsgNum).

%- ResetReadIndex -----------------------------------------------------------
%  Set ReadIndex to 0.
  msgl_ResetReadIndex(Socket, MsgNum):-
	retract(msgl_socket_msgNum_db(Socket, MsgNum)),
	retract(msgl_socket_readIndex_db(Socket, _, _)),
	assert(msgl_socket_readIndex_db(Socket, 0, MsgNum)),
	NextMsgNum = MsgNum + 1,
	assert(msgl_socket_msgNum_db(Socket, NextMsgNum)),
	!.
    
/*-------------------------------------------------------------------------
 Handling Writing 
-------------------------------------------------------------------------*/
Predicates
  msgl_ready_write(SOCKET) - determ (i)
  msgl_write_direct(SOCKET, BINARY) - determ (i,i)
  procedure msgl_processEvents(SOCKET)
  msgl_all_sent(SOCKET, BINARY, UNSIGNED) - procedure (i,i,i)
  msgl_CheckNotify(SOCKET,INTEGER) - procedure (i,i)
  msgl_CheckDirectWrite(socket, binary Old, binary Left) - procedure (i,i,i)
  msgl_CheckDirectWrite( SOCKET, BINARY ) - procedure (i,i)

Predicates
  msgl_try_send(socket, binary, unsigned) - determ (i,i,o)
Clauses
  msgl_try_send(Socket, Bin, Sent):-
%    Size = getbinarysize(Bin),
%    write("msgl_try_send - sending ", Size),nl,
    trap(Sent = sck_send(Socket,Bin,[]),Err, msgl_errWrite(Socket, Err)),
    !.
%    write("msgl_try_send - sent ",Sent),nl.
  msgl_try_send(_, _, _):-
%    write("msgl_try_send - failed"),nl,
    fail.
    
  

Clauses
  msgl_write_direct(Socket, Bin):-
    msgl_try_send(Socket,Bin,Send_b),
    !,
    msgl_all_sent(Socket,Bin,Send_b),
    msgl_ready_write(Socket),
    !.
  msgl_write_direct(Socket, Bin):-
    assertz(msgl_write_que_db(Socket, Bin)),
    !.

  msgl_ready_write(Socket):-
    msgl_write_que_db(Socket,Bin),!,
    msgl_try_send(Socket,Bin,Send_b),
    msgl_all_sent(Socket,Bin,Send_b),
    msgl_ready_write(Socket),
    !.
  msgl_ready_write(Socket):- % nothing to send
    not(msgl_write_ready_db(Socket)),
    assert(msgl_write_ready_db(Socket)),
    fail.
  msgl_ready_write(Socket):- % nothing to send    
    msgl_softCloseOn_db(Socket),
    msglay_close(Socket),
    !.
  msgl_ready_write(_Socket).
  
  msgl_processEvents(Socket):-
	msgl_socket_option_db(Socket, msglay_VpiProcessEvents(automatic)),!,
	vpi_processevents().
  msgl_processEvents(Socket):- msgl_socket_option_db(Socket, msglay_VpiProcessEvents( manual )),!.
  msgl_processEvents( _ ).	% dummy
    
  msgl_all_sent( Socket, Block, 0 ):-	%nothing was sent
  	msgl_CheckDirectWrite( Socket, Block ),!.
  msgl_all_sent( Socket, _, Sent ):-
	msgl_CheckNotify( Socket, Sent ),fail.
  msgl_all_sent(Socket,Block,Sent):-
  	Tosend_b = getbinarysize(Block),
  	Tosend_b = Sent,
  	retract(msgl_write_que_db( Socket, Block )),
  	!.
  msgl_all_sent( Socket, Block, Sent ):-
	Tosend_b = getbinarysize(Block),
	Tosend_b <> Sent,
	Block_ptr = cast( ULONG, Block ),
	Left_place = Block_ptr + Sent,
	LeftSize = Tosend_b - Sent,
	trap( Left = makebinary( LeftSize ),Err, msgl_errWrite(Socket,Err)),!,
	Left_ptr = cast( ULONG, Left ),
	movmem( Left_place, Left_ptr, LeftSize ),
	msgl_CheckDirectWrite( Socket, Block, Left ).
  msgl_all_sent(_,_,_).
	

  msgl_CheckDirectWrite( Socket, Block, Left ):-	%it's not direct write
	retract(msgl_write_que_db( Socket, Block )),!,
	asserta(msgl_write_que_db( Socket, Left )).
  msgl_CheckDirectWrite( Socket, _, Left ):-
	asserta(msgl_write_que_db( Socket, Left )).

  msgl_CheckDirectWrite( Socket, Block ):-
	msgl_write_que_db( Socket, Block ),!.		%it's not direct write
  msgl_CheckDirectWrite( Socket, Block ):-
	asserta(msgl_write_que_db( Socket, Block )).
  
  msgl_CheckNotify(Socket,SizeSentData):-
  	msgl_socket_option_db(Socket, msglay_SndNotify(b_true)),
  	msgl_window_db(Win),!,
  	assertz(msgl_socket_eventqueue_db(Socket,e_Notify(SizeSentData))),
	win_SendEvent(Win,e_Native(msgl_sendevent,0,0)).
  msgl_CheckNotify(_,_). 

% The predicates exits if an error occurs. If the resolving of hostname is async. 
% then the exit() is not trapped anywhere.
% KI begin 14.06.98 --
/*  msgl_Conn(Socket, Addr ):-
	trap(sck_connect(Socket, Addr), Err, msgl_errConnect(Socket, Err)),
	!.*/
%KI end 14.06.98 --
% KI begin 14.06.98 ++
  msgl_Conn(Socket, Addr, msgl_SyncConnect ):-
	trap(sck_connect(Socket, Addr), Err, msgl_errConnect(Socket, Err)),
	!.
  msgl_Conn(Socket, Addr, msgl_AsyncConnect ):-
	trap(sck_connect(Socket, Addr), Err, msgl_errEvent( Socket, Err, msglay_errEvConnect )),
	!.
% KI end 14.06.98 ++
  msgl_Conn(_,_,_).

/*-------------------------------------------------------------------------
 Initialising the window that receives the socket events.
-------------------------------------------------------------------------*/
Predicates
  procedure msglay_init()
  procedure msgl_StartSession()
  msgl_event_eh : EHANDLER
  procedure msgl_event_processing(WINDOW, SOCKET, LONG)		- (i,i,i)
  msgl_test_event(SOCKET, MSGLAY_EVENT)
  procedure msgl_SetDefaultOptions(SOCKET)
  procedure msgl_check_close( SOCKET )
  procedure msgl_clear_socket_db( SOCKET )
  procedure msgl_closeIt( SOCKET )

Clauses
  msglay_init():-
    not(msgl_window_db(_)),
    msgl_StartSession(),
    ScreenWindow = cast(window,vpi_GetAttrVal(attr_screen_window)),
    WinDefs = [dlg(wdef(wd_ModeLess,rct(0,0,0,0),"",u_Pixels),[wsf_Invisible,wsf_Disabled])],
    CreateData = cast(long,0),
    win_CreateDynDialog(
      ScreenWindow,
      WinDefs,
      msgl_event_eh,
      CreateData),
    !.
  msglay_init().

  msgl_StartSession():-
ifdef os_os2
	sck_Startup(),
elsedef
	sck_StartUp(0x101,_WSA_Data,RetCode ),
	RetCode = 0,
enddef
	!.
  msgl_StartSession():-
  	exit(msglay_errStartUp).	

  msgl_test_event(Socket,e_Close(msglay_self)):-	
	retract(msgl_socket_handle_db(Socket,_Handle)),
%KI add begin 27.11.1998
	retractall(msgl_socket_eventqueue_db(Socket,_)),
%KI end begin 27.11.1998
	!.
  msgl_test_event(Socket,e_Close(msglay_incoming)):-	
	retract(msgl_socket_handle_db(Socket,_Handle)),
%KI add begin 27.11.1998
	retractall(msgl_socket_eventqueue_db(Socket,_)),
%KI end begin 27.11.1998
	!.
  msgl_test_event(_,_).


Predicates
  callHandler(msglay_handler,socket,msglay_event) - procedure (i,i,i)
Clauses
  callHandler(Handler,Socket,Event):-
%    write("callHandler(",Event,")"),nl,
    trap(Handler(Socket,Event),E,write("ERROR: callHandler(",E,")\n")), !.
%    write("callHandlerEnd"),nl.
  callHandler(_,_,_):- !.
%    write("ERROR: callHandler - failed "),nl.
  

%- socket_event_eh Handling the socket events in the window ---------------

%  msgl_event_eh(_,E,_):-
%    write("msgl_event_eh(",E,")\n"),
%    fail. % ###CKH
    
  msgl_event_eh(Win,e_Create(_),0):- !,
	assert(msgl_window_db(Win)),
	win_EnableHook(Win, b_true),
	_TimerId = timer_Set(Win,1000).

  msgl_event_eh(Win,e_Timer(_),0):-
    % Assume that some event got lost and do as if it had been sent !!
    % This is a terrible hack !!
    msgl_socket_handle_db(Socket, _),
      msgl_event_processing(Win,Socket,fd_read),
      msgl_event_processing(Win,Socket,fd_write),
    fail.
    
	
%  msgl_event_eh(_Win,e_menu(msgl_sendevent, _),0):-
  msgl_event_eh(_Win,e_Native(msgl_sendevent, _, _),0):-
% begin KI 04.06.98 	--
% event stays in queue even if handle was removed
%	msgl_socket_eventqueue_db(Socket, Event),
% 	msgl_socket_handle_db(Socket, Handle),
% end KI 04.06.98
	retract(msgl_socket_eventqueue_db(Socket, Event)),
% begin KI 04.06.98	++
		msgl_socket_handle_db(Socket, Handle),
% end KI 04.06.98		
		msgl_test_event(Socket,Event),
		callHandler(Handle,Socket, Event),
	fail.
  msgl_event_eh(_Win,e_Native(msgl_sendevent, _, _),0).

ifndef os_os2  
  msgl_event_eh(_Win,e_Native(wm_async_req,HTask,LParam),0):-
  	ml_async_req_db(HTask,Socket,Port),
  	trap( Hostent = sck_GetAsyncHostent(HTask),_, true ),
  	0 = sck_GetAsyncError(LParam),!,
  	retractall(ml_async_req_db(HTask,Socket,Port)),
	Hostent = sck_hostent(_,_,_,_,[Host_l|_]),
	Port_h = sck_ntohs(Port),
	Addr = sck_MergeAddress_IN(af_inet,Port_h,Host_l),
	msgl_Conn(Socket, Addr, msgl_AsyncConnect ),!.
  msgl_event_eh(_Win,e_Native(wm_async_req,HTask,LParam),0):-
  	ml_async_req_db(HTask,Socket,_),
  	Err = sck_GetAsyncError(LParam),
  	Err <> 0,!,
  	retractall(ml_async_req_db(HTask,Socket,_)),
  	msgl_errEvent( Socket, Err, msglay_errEvConnect ),!.
  msgl_event_eh(_Win,e_Native(wm_async_req,_HTask,_LParam),0).
enddef
  
/*  The WParam argument identifies the socket on wich a network event has occured.
    	This is converted into a PDCSocket by socket_Message2Socket, witch can exit
    	with a err_socknotfound.
    The high word of LParam contains any error code.
    The low word of LParam specifies the network event that has occured. This can be
    	fd_read, fd_write, fd_oob, fd_accept, fd_connect or fd_close */
/*  msgl_event_eh(Win,e_Native(wm_socket,Socket,LParam),0):-
  	Error = sck_GetSelectError(LParam),
  	Event = sck_GetSelectEvent(LParam),
	write("Socket: ", Socket,"; Event: ",Event,"; Error: ",Error),nl,
  	fail.*/
  msgl_event_eh(Win,e_Native(wm_socket,Socket,LParam),0):-
	Er = sck_GetSelectError(LParam),
	Er = 0x0, !, % no error
	Event = sck_GetSelectEvent(LParam),
	msgl_event_processing(Win,Socket,Event).
  msgl_event_eh(_Win,e_Native(wm_socket,Socket,LParam),0):- % error while establishing connection
	Err = sck_GetSelectError(LParam),
	Event = sck_GetSelectEvent(LParam),
	Event = fd_connect,!,
	msgl_errEvent( Socket, Err, msglay_errEventConnect( Err ) ),
	!.
  msgl_event_eh(_Win,e_Native(wm_socket,Socket,LParam),0):- % other events wirh errors
	Err = sck_GetSelectError(LParam),
	Event = sck_GetSelectEvent(LParam),
	msgl_window_db( Win ),
	assertz( msgl_socket_eventqueue_db( Socket, e_close(msglay_error( Event, Err )))),
	win_SendEvent(Win,e_Native(msgl_sendevent,0,0)),
	!.


%- socket_event_processing handling the socket events ----------------------------
/*Predicates
  msgl_event2Str(UNSIGNED,STRING)

Clauses
  msgl_event2Str(fd_none,"fd_none").
  msgl_event2Str(fd_read,"fd_read").
  msgl_event2Str(fd_write,"fd_write").
  msgl_event2Str(fd_oob,"fd_oob").
  msgl_event2Str(fd_accept,"fd_accept").
  msgl_event2Str(fd_connect,"fd_connect").
  msgl_event2Str(fd_close,"fd_close").


  msgl_event_processing(Win,Socket,Event):-
    msgl_event2Str(Event,EStr),
    format(Str,"socket event Win %, Sock %, %s\n",Win,Socket,EStr),
   write(Str),
%    dlg_note(Str),
    fail.*/

/* Socket is ready for accepting a new incoming connection. */
  msgl_event_processing(Win,Socket,fd_accept):-
	trap(S1 = sck_Accept( Socket ), Err, msgl_errEvent(Socket, Err, msglay_errEvAccept)),
	Events = [fd_read, fd_write, fd_close],
	% Set same options for the new socket as of "parent"
	msglay_GetOptions(Socket,SockOpts),
	msglay_SetOptions(S1,SockOpts),
	assertz(msgl_socket_eventqueue_db(Socket,e_Connect(S1))),
	win_SendEvent(Win,e_Native(msgl_sendevent,0,0)),
	Sck_Win = cast(SCK_HWND,Win),
	trap(sck_AsyncSelect(S1,Sck_Win,wm_socket,Events),Err2, msgl_errEvent(S1, Err2, msglay_errEvAccept)),
	!.

/* Connection on Socket completed */
  msgl_event_processing(Win,Socket,fd_connect):-
	Events = [fd_read, fd_write, fd_close],
	Sck_Win = cast(SCK_HWND,Win),
	trap(sck_AsyncSelect(Socket,Sck_Win,wm_socket,Events),Err,msgl_errEvent(Socket, Err, msglay_errEvConnect)),
	assertz(msgl_socket_eventqueue_db(Socket,e_Connect(Socket))),
	win_SendEvent(Win,e_Native(msgl_sendevent,0,0)),
	!.
    
/* Socket ready for reading. */
  msgl_event_processing(_Win,Socket,fd_read):-
  	trap(Size = sck_IoCtlGet(Socket, cmd_FionRead), Err1, msgl_errEvent(Socket, Err1, msglay_errEvRead)),
  	Size_i = val( INTEGER, Size ),
%  	write("sck_Rcv(",Size_i,")"),nl,
  	Size_i > 0,
	trap(sck_Recv(Socket,Size_i,[],Bin), Err2, msgl_errEvent(Socket, Err2, msglay_errEvRead)),
	msgl_data_read(Socket,Bin),
	msgl_check_close( Socket ),
	!.

/* A fd_write event arrives when the connection is established with socket_connect(), or
   socket_tryAccept(). And after a socket_write that fails. */
  msgl_event_processing(_Win,Socket,fd_write):-
	trap( msgl_ready_write( Socket ), Err, msgl_errEvent( Socket, Err, msglay_errEvWrite )),
	!.

/* Connection identified by Socket has been closed. */
  msgl_event_processing( _, Socket, fd_close):-
  	assert( msgl_db_isclose( Socket ) ),
  	msgl_check_close( Socket ),
	!.

  msgl_event_processing(_,_,_).		% dummy

%-----------------------------------------------------------------------------

  msgl_check_close( Socket ):-
  	msgl_db_isclose( Socket ),
  	trap(Size = sck_IoCtlGet( Socket, cmd_FionRead ), _, true ),
  	Size = 0,
  	msgl_window_db( Win ),
  	assertz(msgl_socket_eventqueue_db( Socket, e_close( msglay_incoming ))),
  	retract( msgl_db_isclose( Socket ) ),
  	msgl_clear_socket_db( Socket ),
	msgl_closeIt( Socket ),
	win_SendEvent(Win,e_Native(msgl_sendevent,0,0)),
	!.
  msgl_check_close( _ ).
  
  msgl_closeIt( Socket ):-
  	trap( sck_CloseSocket( Socket ), _, true ),
  	!.
  msgl_closeIt( _ ).
  
  msgl_clear_socket_db( Socket ):-
	retractall(msgl_write_que_db( Socket, _ )),
	retractall(msgl_write_ready_db( Socket )),
	retractall(msgl_read_que_db( Socket, _ )),
	retractall(msgl_softCloseOn_db( Socket )),
	retractall(msgl_socket_option_db( Socket, _ )),
	retractall(msgl_socket_readLength_db( Socket, _, _ )),
	retractall(msgl_socket_readIndex_db( Socket, _, _ )),
%KI add begin 27.11.1998
	retractall(msgl_socket_msgNum_db( Socket, _ )),
%KI add end 27.11.1998	
	retractall(msgl_socket_readNullStr_db( Socket, _ )),
	retractall(msgl_socket_readTemp_db( Socket, _, _ )).
	
/*-------------------------------------------------------------------------
Global Message Layer predicates
-------------------------------------------------------------------------*/

/*---------------------------------------------------------------------------------
Msglay_LISTEN:
---------------------------------------------------------------------------------*/
Clauses
  msglay_Listen(Port,Handler,Socket):-
	msglay_init(),
	trap(Socket = sck_socket(af_inet,sock_Stream, ipproto_tcp), Error1, msgl_errCreate(Error1)),
	retractall(msgl_socket_handle_db(Socket,_)),
	assert(msgl_socket_handle_db(Socket,Handler)),
	trap(sck_SetsockOpt( Socket, sol_socket, so_reuseaddr, sck_SimpleOpt(1) ), Error2, msgl_errListen(Socket,Error2)),
	Event = [fd_accept],
	msgl_window_db(Win),
	Sck_Win = cast(SCK_HWND,Win),
	trap(sck_AsyncSelect(Socket,Sck_Win,wm_socket,Event), Error3, msgl_errListen(Socket,Error3)),
	assert(msgl_socket_readLength_db(Socket, 0, 0)), % Initial values for read
	assert(msgl_socket_readIndex_db(Socket, 0, 0)),
	assert(msgl_socket_msgNum_db(Socket, 1)),
	msgl_SetDefaultOptions(Socket),
	Port_h = sck_ntohs(Port),
	L_addr = sck_MergeAddress_IN(af_inet,Port_h,0), %INADDR_ANY
	trap( sck_bind(Socket,L_addr), Error4, msgl_errListen(Socket,Error4)),
	trap(sck_Listen(Socket, msgl_back_log), Error5, msgl_errListen(Socket,Error5)),
	!.
  msglay_Listen( _, _ , 0 ).

/*---------------------------------------------------------------------------------
Msglay_CONNECT:
---------------------------------------------------------------------------------*/
Clauses
  msglay_Connect(Server, Port, Handler, Opt_list, Socket):-
	msglay_init(),
	trap(Socket = sck_socket(af_inet,sock_Stream, ipproto_tcp), Error2, msgl_errCreate(Error2)),
	retractall(msgl_socket_handle_db(Socket,_)),
	assert(msgl_socket_handle_db(Socket,Handler)),
	Events = [fd_connect],
%	Events = [0x01, 0x02, 0x04, 0x08, 0x10, 0x20],
	msgl_window_db(Win),
	Sck_Win = cast(SCK_HWND,Win),
	trap(sck_AsyncSelect(Socket,Sck_Win,wm_socket,Events), Error3, msgl_errConnect(Socket,Error3)),
	assert(msgl_socket_readLength_db(Socket, 0, 0)), % Initial values for read
	assert(msgl_socket_readIndex_db(Socket, 0, 0)),
	assert(msgl_socket_msgNum_db(Socket, 1)),
	msgl_SetDefaultOptions(Socket),
	msglay_SetOptions(Socket, Opt_list),
	msgl_make_conn( Socket, Port, Server ),
	!.
  msglay_Connect( _, _, _, _, 0 ).

/*---------------------------------------------------------------------------------
Msglay_SETHANDLER:
	Always succeeds
---------------------------------------------------------------------------------*/
Clauses
  msglay_setHandler(Socket, Handler, Opt_list):-
	retractall(msgl_socket_handle_db(Socket,_)),
	assert(msgl_socket_handle_db(Socket,Handler)),
	msglay_SetOptions(Socket, Opt_list),
	msgl_read_ready(Socket),
	!.

/*---------------------------------------------------------------------------------
Msglay_writeBin:
  	Writing on a socket 
Msglay_writeStr
---------------------------------------------------------------------------------*/
Database - msgl_split_msg_database
  msgl_split_msg_db(LONG)

Predicates
ifdef os_os2
  nondeterm msgl_composeBinMsg(BINARY, BINARY)
  nondeterm msgl_mkMsg(STRING, LONG, BINARY)
  nondeterm msgl_composeStrMsg(STRING, BINARY)
elsedef
  msgl_composeBinMsg(BINARY, BINARY)
  msgl_composeStrMsg(STRING, BINARY)
enddef
  msgl_SetLength(LONG, BINARY)
  msgl_SetBegintxt(BINARY)
  msgl_SetEndTxt(LONG, BINARY)
  determ msgl_writeBin(SOCKET, BINARY)
  determ msgl_writeStr(SOCKET, STRING)
  determ msgl_writeStrNull(SOCKET, STRING)

Clauses
ifdef os_os2
  msgl_composeBinMsg(BinIn, BinOut):-
	Length = getbinarysize(BinIn),
	PtrIn = cast(string, BinIn),
	msgl_mkMsg(PtrIn, Length, BinOut).
elsedef
  msgl_composeBinMsg(BinIn, BinOut):-
	Length = getbinarysize(BinIn),
	PtrIn = cast(string, BinIn),
	MsgSize = Length + 20,
	BinOut = makebinary(MsgSize),
	msgl_SetLength(Length, BinOut),
	msgl_SetBegintxt(BinOut),
	msgl_SetEndTxt(MsgSize, BinOut),
	% Insert Msg
	PtrOut1 = cast(string, BinOut),
	ptr_dword(PtrOut1, SegOut, OffOut1),
	OffOut2 = OffOut1 + 12,
	ptr_dword(PtrOut2, SegOut, OffOut2),
    	PtrIn1 = cast(POINTER, PtrIn),
    	PtrOut3 = cast(POINTER, PtrOut2),
	movMem(PtrIn1, PtrOut3, Length).
enddef

ifdef os_os2
  msgl_mkMsg(PtrIn, Length, BinOut):-
	not(msgl_split_msg_db(_)),
	Length <= msgl_max_msg_size,!,
	MsgSize = Length + 20,
	BinOut = makebinary(MsgSize),
	msgl_SetLength(Length, BinOut),
	msgl_SetBegintxt(BinOut),
	msgl_SetEndTxt(MsgSize, BinOut),
	% Insert Msg
	PtrOut1 = cast(string, BinOut),
	ptr_dword(PtrOut1, SegOut, OffOut1),
	OffOut2 = OffOut1 + 12,
	ptr_dword(PtrOut2, SegOut, OffOut2),
	PtrIn_ptr = cast( POINTER, PtrIn ),
	PtrOut2_ptr = cast( POINTER, PtrOut2 ),
	movMem(PtrIn_ptr, PtrOut2_ptr, Length).
    
  msgl_mkMsg(PtrIn, Length, BinOut):-
	not(msgl_split_msg_db(_)),
	MsgSize = msgl_max_msg_size + 12,
	BinOut = makebinary(MsgSize),
	msgl_SetLength(Length, BinOut),
	msgl_SetBegintxt(BinOut),
	% Insert Msg
	PtrOut1 = cast(string, BinOut),
	ptr_dword(PtrOut1, SegOut, OffOut1),
	OffOut2 = OffOut1 + 12,
	ptr_dword(PtrOut2, SegOut, OffOut2),
	PtrIn_ptr = cast( POINTER, PtrIn ),
	PtrOut2_ptr = cast( POINTER, PtrOut2 ),	
	movMem(PtrIn_ptr, PtrOut2_ptr, msgl_max_msg_size),
	assert(msgl_split_msg_db(msgl_max_msg_size)).
    
  msgl_mkMsg(PtrIn1, Length, BinOut):-
	msgl_split_msg_db(WroteChar),
	RestLength = Length - WroteChar,
	RestLength <= msgl_max_msg_size, !,
	retract(msgl_split_msg_db(_)),
	MsgSize = RestLength + 8,
	BinOut = makebinary(MsgSize),
	msgl_SetEndTxt(MsgSize, BinOut),
	% Insert Msg
	PtrOut = cast(string, BinOut),
	ptr_dword(PtrIn1, SegIn, OffIn1),
	OffIn2 = OffIn1 + WroteChar,
	ptr_dword(PtrIn2, SegIn, OffIn2),
	PtrIn2_ptr = cast( POINTER, PtrIn2 ),
	PtrOut_ptr = cast( POINTER, PtrOut ),
	movMem(PtrIn2_ptr, PtrOut_ptr, RestLength).
    
  msgl_mkMsg(PtrIn1, _Length, BinOut):-
	getbacktrack(BTOP),
	retract(msgl_split_msg_db(WroteChar)),
	MsgSize = msgl_max_msg_size,
	NewWroteChar = WroteChar + MsgSize,
	BinOut = makebinary(MsgSize),
	% Insert Msg
	PtrOut = cast(string, BinOut),
	ptr_dword(PtrIn1, SegIn, OffIn1),
	OffIn2 = OffIn1 + WroteChar,
	ptr_dword(PtrIn2, SegIn, OffIn2),
	PtrIn2_ptr = cast( POINTER, PtrIn2 ),
	PtrOut_ptr = cast( POINTER, PtrOut ),
	movMem(PtrIn2_ptr, PtrOut_ptr, msgl_max_msg_size),
	assert(msgl_split_msg_db(NewWroteChar)),
	cutbacktrack(BTOP).
    
  msgl_mkMsg(PtrIn, Length, BinOut):-
	msgl_split_msg_db(_),!,
	msgl_mkMsg(PtrIn, Length, BinOut).
enddef
    
ifdef os_os2
  msgl_composeStrMsg(StrIn, BinOut):-
	str_len(StrIn, Length),
	msgl_mkMsg(StrIn, Length, BinOut).
elsedef
  msgl_composeStrMsg(StrIn, BinOut):-
	str_len(StrIn, Length),
	MsgSize = Length + 20,
	BinOut = makebinary(MsgSize),
	msgl_SetLength(Length, BinOut),
	msgl_SetBegintxt(BinOut),
	msgl_SetEndTxt(MsgSize, BinOut),
	% Insert Msg
	PtrOut1 = cast(string, BinOut),
	ptr_dword(PtrOut1, SegOut, OffOut1),
	OffOut2 = OffOut1 + 12,
	ptr_dword(PtrOut2, SegOut, OffOut2),
    	StrIn1 = cast(POINTER, StrIn),
    	PtrOut3 = cast(POINTER, PtrOut2),
	movMem(StrIn1, PtrOut3, Length).
enddef

  msgl_SetLength(Length, BinOut):-
	% Set Length
	B1 = Length div 16777216,
%KI
%BugFix 18.06.1998 - digit '7' was missed
%	L2 = Length - B1 * 1677216,
	L2 = Length - B1 * 16777216,
	B2 = L2 div 65536,
	L3 = L2 - B2 * 65536,
	B3 = L3 div 256,
	B4 = L3 - B3 * 256,
/*	setdwordEntry(BinOut,0,B1),
	setdwordEntry(BinOut,1,B2),
	setdwordEntry(BinOut,2,B3),
	setdwordEntry(BinOut,3,B4).*/
	B1_w = cast( BYTE, B1 ),
	B2_w = cast( BYTE, B2 ),
	B3_w = cast( BYTE, B3 ),
	B4_w = cast( BYTE, B4 ),
	setbyteEntry(BinOut,0,B1_w),
	setbyteEntry(BinOut,1,B2_w),
	setbyteEntry(BinOut,2,B3_w),
	setbyteEntry(BinOut,3,B4_w).	

  msgl_SetBegintxt(BinOut):-
	% Set begin text
	setbyteEntry(BinOut,4,'R'),
	setbyteEntry(BinOut,5,'E'),
	setbyteEntry(BinOut,6,'Y'),
	setbyteEntry(BinOut,7,'A'),
	setbyteEntry(BinOut,8,'L'),
	setbyteEntry(BinOut,9,'G'),
	setbyteEntry(BinOut,10,'S'),
	setbyteEntry(BinOut,11,'M').

  msgl_SetEndTxt(MsgSize_l, BinOut):-
  	MsgSize = val( UNSIGNED, MsgSize_l ),
	% Set End text
	P1 = MsgSize - 8, setbyteEntry(BinOut,P1,'M'),
	P2 = MsgSize - 7, setbyteEntry(BinOut,P2,'S'),
	P3 = MsgSize - 6, setbyteEntry(BinOut,P3,'G'),
	P4 = MsgSize - 5, setbyteEntry(BinOut,P4,'L'),
	P5 = MsgSize - 4, setbyteEntry(BinOut,P5,'A'),
	P6 = MsgSize - 3, setbyteEntry(BinOut,P6,'Y'),
	P7 = MsgSize - 2, setbyteEntry(BinOut,P7,'E'),
	P8 = MsgSize - 1, setbyteEntry(BinOut,P8,'R').

ifdef os_os2
  msglay_WriteBin(Socket, Bin):-
	msgl_socket_option_db(Socket, msglay_SndBin(packed)),
	msgl_composeBinMsg(Bin, SendBin),
		msgl_writeBin(Socket, SendBin),
	fail.
    
  msglay_WriteBin(Socket, _):-
	msgl_socket_option_db(Socket, msglay_SndBin(packed)),
	msgl_processEvents(Socket),!.
    
elsedef
  msglay_WriteBin(Socket, Bin):-
	msgl_socket_option_db(Socket, msglay_SndBin(packed)),
	msgl_composeBinMsg(Bin, SendBin),
	msgl_writeBin(Socket, SendBin),
	msgl_processEvents(Socket),!.
enddef
  msglay_WriteBin(Socket, Bin):-
	msgl_socket_option_db(Socket, msglay_SndBin(unpacked)),
	msgl_writeBin(Socket, Bin),
	msgl_processEvents(Socket),!.
  msglay_WriteBin( _, _).
  
ifdef os_os2
  msglay_WriteStr(Socket, Str):-
	msgl_socket_option_db(Socket, msglay_SndStr(packed)),
	msgl_composeStrMsg(Str, SendBin),
		msgl_writeBin(Socket, SendBin),
	fail.
  msglay_WriteStr(Socket, _):-
	msgl_socket_option_db(Socket, msglay_SndStr(packed)),
	msgl_processEvents(Socket),!.
    
elsedef
  msglay_WriteStr(Socket, Str):-
%    write("msglay_WriteStr(",Str,")"),nl,
    msgl_socket_option_db(Socket, msglay_SndStr(packed)),
    msgl_composeStrMsg(Str, SendBin),
    msgl_writeBin(Socket, SendBin),
    msgl_processEvents(Socket),!.
enddef

  msglay_WriteStr(Socket, Str):-
	msgl_socket_option_db(Socket, msglay_SndStr(unpacked)),
	msgl_writeStr(Socket, Str),
	msgl_processEvents(Socket),!.
  msglay_WriteStr(Socket, Str):-
	msgl_socket_option_db(Socket, msglay_SndStr(nullTerminated)),
	msgl_writeStrNull(Socket, Str),
	msgl_processEvents(Socket),!.
  msglay_WriteStr( _, _ ).
    
% Local predicates --------------------------------------------------------------
  msgl_writeStr(Socket, Str):-
	str_len(Str, Len),
	Bin = composeBinary(Str, Len),
	msgl_WriteBin(Socket, Bin).

  msgl_writeStrNull(Socket, Str):-
	str_len(Str, Len),
	Len1 = Len + 1,
	Bin = makebinary(Len1),
	setbyteentry(Bin, Len, 0),
	Ptr = cast(string, Bin),
    	Str1 = cast(POINTER, Str),
    	Ptr1 = cast(POINTER, Ptr),	
	movMem(Str1, Ptr1, Len),
	msgl_writeBin(Socket, Bin).
    
  msgl_WriteBin(Socket,Bin):-
	not(msgl_write_que_db(Socket,_)),
	retract(msgl_write_ready_db(Socket)),!,
	msgl_write_direct(Socket, Bin),
	!.
  msgl_WriteBin(Socket,Bin):-
	assertz(msgl_write_que_db(Socket,Bin)),
	retract(msgl_write_ready_db(Socket)),
	msgl_ready_write(Socket),
	!.
  msgl_WriteBin(_,_).
 
/*---------------------------------------------------------------------------------
Msglay_SetOptions:
---------------------------------------------------------------------------------*/
Predicates
  msgl_initReadIndex(SOCKET, MSGLAY_RCVDOM)
  msgl_initReadLength(SOCKET, MSGLAY_RCVDOM)
  msgl_checkNewOption(SOCKET)
  msgl_SetOption(SOCKET,MSGLAY_OPT) - (i,i)
  
Clauses
  msglay_SetOptions(_, []):-!.
  msglay_SetOptions(Socket, [Option|OptList]):-
	msgl_SetOption(Socket, Option),!,
	msglay_SetOptions(Socket, OptList).
  msglay_SetOptions( _, _ ).	%dummy
    
  msgl_SetOption(Socket, msglay_SndBuf(Size)):-
	trap( sck_SetSockOpt(Socket, sol_socket, so_SndBuf, sck_simpleOpt(Size)), _, true ),!.
  msgl_SetOption(_Socket, msglay_SndBuf(_)).
  msgl_SetOption(Socket, msglay_RcvBuf(Size)):-
	trap( sck_SetSockOpt(Socket, sol_socket, so_RcvBuf, sck_simpleOpt(Size)), _, true ),!.
  msgl_SetOption(_Socket, msglay_RcvBuf(_)).
  msgl_SetOption(Socket, msglay_VpiProcessEvents(Opt)):-
	retractall(msgl_socket_option_db(Socket, msglay_VpiProcessEvents(_))),
	assert(msgl_socket_option_db(Socket, msglay_VpiProcessEvents(Opt))).
  msgl_SetOption(Socket, msglay_SndStr(Opt)):-
	retractall(msgl_socket_option_db(Socket, msglay_SndStr(_))),
	assert(msgl_socket_option_db(Socket, msglay_SndStr(Opt))).
  msgl_SetOption(Socket, msglay_SndBin(Opt)):-
	retractall(msgl_socket_option_db(Socket, msglay_SndBin(_))),
	assert(msgl_socket_option_db(Socket, msglay_SndBin(Opt))).
  msgl_SetOption(Socket, msglay_Rcv(Opt)):-
	retractall(msgl_socket_option_db(Socket, msglay_Rcv(_))),!,
	msgl_checkNewOption(Socket),
	msgl_initReadIndex(Socket, Opt),
	msgl_initReadLength(Socket, Opt),
	assert(msgl_socket_option_db(Socket, msglay_Rcv(Opt))).
  msgl_SetOption(Socket, msglay_SndNotify(Opt)):-
	retractall(msgl_socket_option_db(Socket, msglay_SndNotify(_))),
	assert(msgl_socket_option_db(Socket, msglay_SndNotify(Opt))).

  msgl_initReadIndex(Socket, _):-
	retractAll(msgl_socket_msgNum_db(Socket,_)),
	retract(msgl_socket_readIndex_db(Socket, _, _)),
	fail.
  msgl_initReadIndex(Socket, packed_str):-!,
	assert(msgl_socket_msgNum_db(Socket,1)),
	assert(msgl_socket_readIndex_db(Socket, 0, 0)).
  msgl_initReadIndex(Socket, packed_bin):-!,
	assert(msgl_socket_msgNum_db(Socket,1)),
	assert(msgl_socket_readIndex_db(Socket, 0, 0)).
  msgl_initReadIndex(Socket, untilNull_str):-!,
	assert(msgl_socket_msgNum_db(Socket,1)),
	assert(msgl_socket_readIndex_db(Socket, 0, 0)).
  msgl_initReadIndex(_, _).
  
  msgl_initReadLength(Socket, _):-
	retract(msgl_socket_readLength_db(Socket, _, _)),
	fail.
  msgl_initReadLength(Socket, packed_str):-!,
	assert(msgl_socket_readLength_db(Socket, 0, 0)).
  msgl_initReadLength(Socket, packed_bin):-!,
	assert(msgl_socket_readLength_db(Socket, 0, 0)).
  msgl_initReadLength(_, _).
  
  msgl_checkNewOption(Socket):-
	msgl_socket_readTemp_db(Socket, _, _),!,
	exit(msglay_errSetOption).
  msgl_checkNewOption(_).
  
  % Set default options for the new socket.
  msgl_SetDefaultOptions(Socket):-
  	assert(msgl_socket_option_db(Socket,msglay_VpiProcessEvents(manual))),
	assert(msgl_socket_option_db(Socket,msglay_SndStr(unpacked))),
	assert(msgl_socket_option_db(Socket,msglay_SndBin(unpacked))),
	assert(msgl_socket_option_db(Socket,msglay_Rcv(unpacked_bin))),
	assert(msgl_socket_option_db(Socket,msglay_SndNotify(b_false))),
	!.
  
/*---------------------------------------------------------------------------------
Msglay_GetOptions:
---------------------------------------------------------------------------------*/
  msglay_GetOptions(S, [msglay_SndBuf(Size),msglay_RcvBuf(Size1),msglay_VpiProcessEvents(Opt),
	msglay_SndStr(Opt1),msglay_SndBin(Opt2),msglay_Rcv(Opt3),msglay_SndNotify(Opt4)]):-
	trap( Sz = sck_GetSockOpt(S,sol_socket,so_SndBuf), _, true ),
	Sz = sck_SimpleOpt(Size),
	trap( Sz1 = sck_GetSockOpt(S,sol_socket,so_RcvBuf), _, true ),
	Sz1 = sck_SimpleOpt(Size1),
	msgl_socket_option_db(S, msglay_VpiProcessEvents(Opt)),
	msgl_socket_option_db(S, msglay_SndStr(Opt1)),
	msgl_socket_option_db(S, msglay_SndBin(Opt2)),
	msgl_socket_option_db(S, msglay_Rcv(Opt3)),
	msgl_socket_option_db(S, msglay_SndNotify(Opt4)),!.
  msglay_GetOptions( _, [] ).	
  	      
/*---------------------------------------------------------------------------------
Msglay_Close:
Msglay_CloseSoft:
---------------------------------------------------------------------------------*/
Clauses
  msglay_Close(Socket):-
	msgl_clear_socket_db( Socket ),
	trap(sck_CloseSocket(Socket),Error, msgl_errClose( Socket, Error )),
	msgl_window_db(Win),
	assertz(msgl_socket_eventqueue_db(Socket,e_close(msglay_self))),
	win_SendEvent(Win,e_Native(msgl_sendevent,0,0)),
	!.
  msglay_Close(_Socket).

  msglay_closeSoft(Socket):-
	not(msgl_write_que_db(Socket,_)),
	msglay_close(Socket),!.
  msglay_closeSoft(Socket):-
	msgl_write_que_db(Socket,_),
	assert(msgl_softCloseOn_db(Socket)),!.
  msglay_closeSoft(_Socket).

/*---------------------------------------------------------------------------------
Msglay_CLOSEALL:
---------------------------------------------------------------------------------*/
Clauses
  msglay_CloseAll():-
	msgl_socket_handle_db(Socket,_),
		msglay_Close(Socket),
	fail.
  msglay_CloseAll().
/*---------------------------------------------------------------------------------
Msglay_CloseSession:
---------------------------------------------------------------------------------*/
  msglay_CloseSession():-
  	retract(msgl_window_db(Win)),
	win_Destroy(Win),
  	trap(sck_CleanUp(),_,true),!.
  msglay_CloseSession(). % because  sck_CleanUp can exit with error
  
/*---------------------------------------------------------------------------------
Msglay_LastError:
---------------------------------------------------------------------------------*/  
  msglay_LastError(Err):-
  	msgl_last_error_db(msglay_err1(Err)),!.
  msglay_LastError(Err):-
  	msgl_last_error_db(msglay_err2(_,Err)),!.
  msglay_LastError( 0 ). 		% no errors
  	
/*---------------------------------------------------------------------------------
Msglay_GetWrongMsgBin & Msglay_GetWrongMsgStr
---------------------------------------------------------------------------------*/  	
  msglay_GetWrongMsgBin(Socket, Bin):-
	retract(msgl_wrongFormatMsg_db(Socket, Bin)),!.
    
  msglay_GetWrongMsgStr(Socket, StrMsg):-
	retract(msgl_wrongFormatMsg_db(Socket, BinMsg)),!,
	msgl_bin2Str(BinMsg, StrMsg).
	
/*---------------------------------------------------------------------------------
Msglay_GetRemoteInf
---------------------------------------------------------------------------------*/
  msglay_GetRemoteInf(Socket, Host, Port):-
	trap(HostAddr = sck_GetPeerName(Socket), Err1, msgl_errGetInf(Socket, Err1)),
	msgl_what_rem_inf(HostAddr, Host, Port),!.
  msglay_GetRemoteInf( _, "", 0).	%dummy