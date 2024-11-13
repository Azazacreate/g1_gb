/***************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

				Visual Prolog

 FileName: PSOCK_TP.PRO
 PURPOSE: Miscellaneous tools for the PDC Socket's implementation
 Written by: Compiler Group, PDC Russia

 อออออออออออออออหออออออหออออออออออออออออออออออออออออออออออออออออออออออออออออ
  Date Modified,บ By,  บ        Comments.
 อออออออออออออออฮออออออฮออออออออออออออออออออออออออออออออออออออออออออออออออออ
    08/05/97    บ  KI  บ  A support for WSAAsyncGetXByY and other Windows 
    		บ      บ  specific routines was added.
***************************************************************************/

ifndef ws_win
  ifdef platform_32bit
    ifndef os_os2
      #error : Unsupported platform
    enddef
  elsedef
    #error : Unsupported platform
  enddef
enddef

CONSTANTS

  ifdef os_os2

    s_Proto_Offset	= 12		/* Offset in struct servent	*/

  elsedef

    ifdef platform_32bit

      version_Mask	= 0x80000000	/* Mask for query version	*/
      nt_SProto_Offs	= 12
      win95_SProto_Offs	= 10		/* Offset in struct servent	*/

    elsedef

      s_Proto_Offset	= 10		/* Offset in struct servent	*/

    enddef

  enddef

			/***********************/
			/* Miscellaneous tools */
			/***********************/

  ifndef os_os2

DATABASE - db_asyncget
  db_async( SCK_HANDLE, POINTER BufferPtr )
    
  enddef			
  
PREDICATES

  procedure check_Socket( SOCKET Socket ) - (i)
  
  procedure check_RetCode( INTEGER RetCode ) - (i)

  procedure check_SockError( INTEGER RetCode ) - (i)

  procedure BINARY check_OutBinParm( BINARY OutParm,
				     BINARY OutParmLen ) - (i,i)

  procedure BINARY make_IntPtrParm( INTEGER ParmValue ) - (i)

  procedure INTEGER get_IntPtrParmValue( BINARY IntPtrParm ) - (i)

  procedure BINARY make_ULongPtrParm( ULONG ParmValue ) - (i)

  procedure ULONG get_ULongPtrParmValue( BINARY ULongPtrParm ) - (i)

  procedure BINARY make_SckOptBuffer( SCK_OPTION_NAME OptionName ) - (i)

  procedure SCK_OPTION make_SckOption( BINARY	       OptBuffer,
				       SCK_OPTION_NAME OptionName ) - (i,i)

  procedure check_OutSckOption( BINARY		OptBuffer,
				SCK_OPTION_NAME	OptionName ) - (i,i)

  procedure ULONG ioCtl_Get( SOCKET		Socket,
			     SCK_IOCTL_COMMAND	Command ) - (i,i)

  procedure ioCtl_Set( SOCKET		 Socket,
		       SCK_IOCTL_COMMAND Command,
		       ULONG		 Argument ) - (i,i,i)

  procedure INTEGER make_Flags( SCK_FLAGS_LIST FlagsList,
				INTEGER	       IsRecvFlags ) - (i,i)

  procedure INTEGER parse_FlagsList( SCK_FLAGS_LIST FlagsList,
				     INTEGER	    Value,
				     INTEGER	    IsRecvFlags ) - (i,i,i)

  procedure check_Flag( SCK_FLAG Flag, INTEGER IsRecvFlags ) - (i,i)

  procedure check_RecvRC( INTEGER RetCode, INTEGER IsDataGram ) - (i,i)

  procedure INTEGER get_BytesRead( BINARY ReadData, INTEGER ReadLen ) - (i,i)

  procedure BINARY check_RecvBuffer( BINARY  ReadData,
				     INTEGER ReadLen,
				     INTEGER IsDataGram ) - (i,i,i)

  procedure fill_SetOptBuffer( SCK_OPTION_NAME OptionName,
			       SCK_OPTION      OptionValue,
			       BINARY	       OptBuffer ) - (i,i,i)

  procedure SCK_EVENT make_Events( SCK_EVENTS_LIST EventsList ) - (i)

  procedure SCK_EVENT parse_EventsList( SCK_EVENTS_LIST EventsList,
					SCK_EVENT	Value ) - (i,i)

  procedure check_Event( SCK_EVENT Event ) - (i)

  procedure fill_SAData( SCK_ADDRESS Address, BINARY Sa_Data ) - (i,i)

  procedure BINARY get_SAData( SCK_ADDRESS Address ) - (i)

  procedure STRING copy_String( STRING OrgStr ) - (i)

  procedure SCK_HOSTENT copy_HostEnt( SCK_HOSTENT OrgHostEnt ) - (i)

  procedure SCK_PROTOENT copy_ProtoEnt( SCK_PROTOENT OrgProtoEnt ) - (i)

  procedure UNSIGNED get_S_Proto_Offset()

  procedure SCK_SERVENT copy_ServEnt( ULONG OrgServEntAddr ) - (i)

  ifndef os_os2

    procedure SCK_WSA_DATA make_WSAData( BINARY Buffer, INTEGER RetCode ) - (i,i)
    
    procedure check_handle( SCK_HANDLE Handle ) - (i)
  
    procedure check_blockfunc( SCK_BLOCKFUNC BlockingFunction ) - (i)

    procedure cleanup_db_async()
    
    procedure clean_db_async_entry( SCK_HANDLE )
    
  enddef

  procedure INTEGER get_SocketType( SOCKET Socket ) - (i)

  procedure check_RecvSocketType( SOCKET Socket, INTEGER IsDataGram ) - (i,i)

  procedure receive( SOCKET	    Socket,
		     INTEGER	    RecvLength,
		     SCK_FLAGS_LIST RecvFlags,
		     INTEGER	    IsDataGram,
		     BINARY	    RecvBuffer ) - (i,i,i,i,o)

  procedure receiveFrom( SOCKET		Socket,
			 INTEGER	RecvLength,
			 SCK_FLAGS_LIST RecvFlags,
			 INTEGER        IsDataGram,
			 SCK_ADDRESS	FromAddr,
			 BINARY		RecvBuffer ) - (i,i,i,i,o,o)

CLAUSES

  ifdef os_os2

    check_Socket( invalid_Socket ) :- !,
	errorexit( err_SckGeneral ).

    check_Socket( _ ).

  elsedef

    check_Socket( Socket ) :-
	Int_S = val( INTEGER, Socket ),
	Int_S = invalid_Socket, !,
	errorexit( err_SckGeneral ).

    check_Socket( _ ).

    check_handle( 0 ):- !,errorexit( err_SckGeneral ).
    check_handle( _ ).
    
    check_blockfunc( BlockFunc ):-
    	UL_BlockFunc = cast( ULONG, BlockFunc ),
    	UL_BlockFunc = native_Null,
    	!,errorexit( err_SckGeneral ).
    check_blockfunc( _ ).

  enddef

  check_RetCode( nativeCall_OK ) :- !.
  check_RetCode( _ )		 :- errorexit( err_SckGeneral ).

  check_SockError( socket_Error ) :- !, errorexit( err_SckGeneral ).
  check_SockError( _ ).

  check_OutBinParm( OutParm, OutParmLen, Result ) :-
	ResultLen = get_IntPtrParmValue( OutParmLen ),
	ResultLen < getbinarysize( OutParm ),	/* ### if > ?! */
	Result = makebinary( ResultLen ),
	mem_MovMem( OutParm, Result, ResultLen ), !.

  check_OutBinParm( OutParm, _, Result ) :-
	Result = OutParm.

  make_IntPtrParm( ParmValue, Result ) :-
	SizeOfIntPtr = sizeof( INTEGER ),
	Result = makebinary( SizeOfIntPtr ),
	ifdef platform_32bit
	  setdwordentry( Result, 0, ParmValue ).
	elsedef
	  setwordentry( Result, 0, ParmValue ).
	enddef

  get_IntPtrParmValue( IntPtrParm, ParmValue ) :-
	ifdef platform_32bit
	  ParmValue = getdwordentry( IntPtrParm, 0 ).
	elsedef
	  ParmValue = getwordentry( IntPtrParm, 0 ).
	enddef

  make_ULongPtrParm( ParmValue, Result ) :-
	SizeOfUlongPtr = sizeof( ULONG ),
	Result = makebinary( SizeOfUlongPtr ),
	setdwordentry( Result, 0, ParmValue ).

  get_ULongPtrParmValue( ULongPtrParm, ParmValue ) :-
	ParmValue = getdwordentry( ULongPtrParm, 0 ).

  make_SckOptBuffer( so_linger, OptionBuffer ) :-
	ifdef os_os2
	  SizeOfOptLinger = sizeof( INTEGER ) * totLingerOptFields,
	elsedef
	  SizeOfOptLinger = sizeof( USHORT ) * totLingerOptFields,
	enddef
	OptionBuffer = makebinary( SizeOfOptLinger ), !.

  make_SckOptBuffer( _, OptionBuffer ) :-
	SizeOfOptOthers = sizeof( INTEGER ),
	OptionBuffer = makebinary( SizeOfOptOthers ).

  check_OutSckOption( OptBuffer, so_linger ) :-
	Len = getbinarysize( OptBuffer ),
	ifdef os_os2
	  Len = sizeof( INTEGER ) * totLingerOptFields,
	elsedef
	  Len = sizeof( USHORT ) * totLingerOptFields,
	enddef
	!.

  check_OutSckOption( OptBuffer, _ ) :-
	Len = getbinarysize( OptBuffer ),
	Len = sizeof( INTEGER ), !.

  check_OutSckOption( _, _ ) :-
	errorexit( err_SckInvalidParms ).

  make_SckOption( OptBuffer, so_linger, OptValue ) :-
	ifdef os_os2
	  L_OnOff = getwordentry( OptBuffer, 0 ),
	  L_Linger = getwordentry( OptBuffer, 1 ),
	elsedef
	  L_OnOff = getwordentry( OptBuffer, 0 ),
	  L_Linger = getwordentry( OptBuffer, 1 ),
	enddef
	OptValue = sck_LingerOpt( L_OnOff, L_Linger ), !.

  make_SckOption( OptBuffer, _, OptValue ) :-
	ifdef platform_32bit
	  Value = getdwordentry( OptBuffer, 0 ),
	elsedef
	  Value = getwordentry( OptBuffer, 0 ),
	enddef
	OptValue = sck_SimpleOpt( Value ).

  ioCtl_Get( Socket, Command, Argument ) :-
	ArgPtr = make_ULongPtrParm( 0 ),

	ifdef os_os2

	  ArgLen = sizeof( ULONG ),
	  RC = bsd_IoCtl( Socket, Command, ArgPtr, ArgLen ),

	elsedef

	  RC = bsd_IoCtl( Socket, Command, ArgPtr ),

	enddef

	check_RetCode( RC ),
	Argument = get_ULongPtrParmValue( ArgPtr ), !.

  ioCtl_Set( Socket, Command, Argument ) :-
	ArgPtr = make_ULongPtrParm( Argument ),

	ifdef os_os2

	  ArgLen = sizeof( ULONG ),
	  RC = bsd_IoCtl( Socket, Command, ArgPtr, ArgLen ),

	elsedef

	  RC = bsd_IoCtl( Socket, Command, ArgPtr ),

	enddef

	check_RetCode( RC ).

  make_Flags( FlagsList, IsRecvFlags, Result ) :-
	Result = parse_FlagsList( FlagsList, 0, IsRecvFlags ).

  parse_FlagsList( [], Result, _, Result ):-!.
  parse_FlagsList( [Head | Tail], Value, IsRecvFlags, Result ) :-
	check_Flag( Head, IsRecvFlags ),!,
	TmpRes = parse_FlagsList( Tail, Value, IsRecvFlags ),
	bitor( TmpRes, Head, Result ).
  parse_FlagsList( _, Val, _, Val ).	%dummy

  check_Flag( msg_Deflt_Flag, _ )		:- !.
  check_Flag( msg_OOB_Flag, _ )			:- !.
  check_Flag( msg_Peek_Flag, is_RecvCall )	:- !.
  check_Flag( msg_DontRoute_Flag, is_SendCall )	:- !.
  check_Flag( _, _ )				:- errorexit( err_SckInvalidParms ).

  check_RecvRC( socket_Error, is_Recv_Stream ) :- !,
	errorexit( err_SckGeneral ).

  check_RecvRC( socket_Error, _ ) :-
	err_sockmsgsize <> sck_GetLastError(), !,
	errorexit( err_SckGeneral ).

  check_RecvRC( _, _ ).

  get_BytesRead( ReadData, socket_Error, BytesRead ) :- !,
	BytesRead = getbinarysize( ReadData ).

  get_BytesRead( _, ReadLen, ReadLen ).

  check_RecvBuffer( ReadData, ReadLen, IsDataGram, Result ) :-
	check_RecvRC( ReadLen, IsDataGram ),
	ReadBytes = get_BytesRead( ReadData, ReadLen ),
	CurLen = getbinarysize( ReadData ),
	CurLen > ReadBytes, !,	/* ### if ? */
	Result = makebinary( ReadBytes ),
	mem_MovMem( ReadData, Result, ReadBytes ).

  check_RecvBuffer( ReadData, _, _, Result ) :-
	Result = ReadData.

  fill_SetOptBuffer( so_linger,
		     sck_LingerOpt( L_OnOff, L_Linger ),
		     OptBuffer ) :-
	ifdef os_os2
	  setdwordentry( OptBuffer, 0, L_OnOff ),
	  setdwordentry( OptBuffer, 1, L_Linger ),
	elsedef
	  setwordentry( OptBuffer, 0, L_OnOff ),
	  setwordentry( OptBuffer, 1, L_Linger ),
	enddef
	!.

  fill_SetOptBuffer( _, sck_SimpleOpt( Value ), OptBuffer ) :-
	ifdef platform_32bit
	  setdwordentry( OptBuffer, 0, Value ),
	elsedef
	  setwordentry( OptBuffer, 0, Value ),
	enddef
	!.

  fill_SetOptBuffer( _, _, _ ) :-
	errorexit( err_SckInvalidParms ).

  make_Events( EventsList, Result ) :-
	Result = parse_EventsList( EventsList, 0 ).

  parse_EventsList( [], Result, Result ):-!.
  parse_EventsList( [Head | Tail], Value, Result ) :-
	check_Event( Head ),!,
	TmpRes = parse_EventsList( Tail, Value ),
  
	ifdef platform_32bit
	  bitor( TmpRes, Head, Result ).
	elsedef
	  TmpRes_16 = val( unsigned, TmpRes ),
	  Head_16   = val( unsigned, Head ),
	  bitor( TmpRes_16, Head_16, Res_16 ),
	  Result = val( SCK_EVENT, Res_16 ).
	enddef
  parse_EventsList( _, Val, Val ).	% dummy


  check_Event( fd_none )	:- !.
  check_Event( fd_read )	:- !.
  check_Event( fd_write )	:- !.
  check_Event( fd_oob )		:- !.
  check_Event( fd_accept )	:- !.
  check_Event( fd_connect )	:- !.
  check_Event( fd_close )	:- !.
  check_Event( _ )		:- errorexit( err_SckInvalidParms ).

  fill_SAData( Address, Sa_Data ) :-
	SAData_Size = getbinarysize( Sa_Data ),
	SAData_Size <= sckAddr_DataMaxSize, !,
	ULong_Addr = cast( ULONG, Address ),
	To_Ptr = ULong_Addr + sizeof( USHORT ),
	From_Ptr = cast( ULONG, Sa_Data ),
	mem_MovMem( From_Ptr, To_Ptr, SAData_Size ).

  fill_SAData( _, _ ) :-
	errorexit( err_SckInvalidParms ).

  get_SAData( Address, Sa_Data ) :-
	SizeOfAddr = getbinarysize( Address ),
	SAData_Size = SizeOfAddr - sizeof( USHORT ),
	SAData_Size > 0, !,
	Sa_Data = makebinary( SAData_Size ),
	To_Ptr = cast( ULONG, Sa_Data ),
	ULong_Addr = cast( ULONG, Address ),
	From_Ptr = ULong_Addr + sizeof( USHORT ),
	mem_MovMem( From_Ptr, To_Ptr, SAData_Size ).

  get_SAData( _, Sa_Data ) :-
	Sa_Data = makebinary( 0 ).

  copy_String( OrgStr, ResStr ) :-
	UL_OrgStr = cast( ULONG, OrgStr ),
	UL_OrgStr = native_NULL, !,
	ResStr = "".

  copy_String( OrgStr, ResStr ) :-
	str_len( OrgStr, StrLen ),
	str_len( ResStr, StrLen ),
	mem_MovMem( OrgStr, ResStr, StrLen ).

  copy_HostEnt( HostEnt, Result ) :-
	UL_HostEnt = cast( ULONG, HostEnt ),
	UL_HostEnt = native_NULL, !,
	Result = cast( SCK_HOSTENT, native_NULL ),
	errorexit( err_SckGeneral ).

  copy_HostEnt( sck_hostent( Org_H_Name,
			     Org_H_Aliases,
			     Org_H_AddrType,
			     Org_H_AddrLen,
			     Org_H_AddrList ),
		Result ) :-
	Res_H_Name = copy_String( Org_H_Name ),
	Res_H_Aliases = c_MakeSListFromArray( Org_H_Aliases ),
	Res_H_AddrList = c_MakeAListFromArray( Org_H_AddrList ),
	Result = sck_hostent( Res_H_Name,
			      Res_H_Aliases,
			      Org_H_AddrType,
			      Org_H_AddrLen,
			      Res_H_AddrList ).

  copy_ProtoEnt( ProtoEnt, Result ) :-
	UL_ProtoEnt = cast( ULONG, ProtoEnt ),
	UL_ProtoEnt = native_NULL, !,
	Result = cast( SCK_PROTOENT, native_NULL ),
	errorexit( err_SckGeneral ).

  copy_ProtoEnt( sck_protoent( Org_P_Name, Org_P_Aliases, Org_P_Proto ),
		 Result ) :-
	Res_P_Name = copy_String( Org_P_Name ),
	Res_P_Aliases = c_MakeSListFromArray( Org_P_Aliases ),
	Result = sck_protoent( Res_P_Name, Res_P_Aliases, Org_P_Proto ).

  ifdef os_os2

    get_S_Proto_Offset( s_Proto_Offset ).

  elsedef

    ifdef platform_32bit

      get_S_Proto_Offset( Offset ) :-
		Version = get_OS_Version(),
		bitand( Version, version_Mask, NT_Flag ),
		NT_Flag = 0, !,
		Offset = nt_SProto_Offs.

      get_S_Proto_Offset( win95_SProto_Offs ).

    elsedef

      get_S_Proto_Offset( s_Proto_Offset ).

    enddef

  enddef

  copy_ServEnt( native_NULL, sck_servent( "", [], 0, "" ) ) :- !,
	errorexit( err_SckGeneral ).

  copy_ServEnt( OrgServEntAddr, ServEnt ) :-
	get_MemDWord( OrgServEntAddr, S_Name_Addr ),
	S_Name = cast( STRING, S_Name_Addr ),
	Res_S_Name = copy_String( S_Name ),

	S_Aliases_Ptr = OrgServEntAddr + sizeof( DWORD ),
	get_MemDWord( S_Aliases_Ptr, S_Aliases_Addr ),
	S_Aliases = cast( SCK_SLIST, S_Aliases_Addr ),
	Res_S_Aliases = c_MakeSListFromArray( S_Aliases ),

	S_Port_Ptr = S_Aliases_Ptr + sizeof( DWORD ),
	ifdef os_os2
	  get_MemDWord( S_Port_Ptr, Res_S_Port ),
	elsedef
	  get_MemWord( S_Port_Ptr, Res_S_Port ),
	enddef

	S_Proto_Offset = get_S_Proto_Offset(),
	S_Proto_Ptr = OrgServEntAddr + S_Proto_Offset,
	get_MemDWord( S_Proto_Ptr, S_Proto_Addr ),
	S_Proto = cast( STRING, S_Proto_Addr ),
	Res_S_Proto = copy_String( S_Proto ),

	ServEnt = sck_servent( Res_S_Name,
			       Res_S_Aliases,
			       Res_S_Port,
			       Res_S_Proto ).

  ifndef os_os2

    make_WSAData( Buffer, nativeCall_OK, WSA_Data ) :-
	Version = getwordentry( Buffer, 0 ),
	HighVersion = getwordentry( Buffer, 1 ),

	BuffPtr = cast( ULONG, Buffer ),
	DescrPtr = BuffPtr + (2 * sizeof( WORD )),
	DescrStr = cast( STRING, DescrPtr ),
	Description = copy_String( DescrStr ),

	StatusPtr = DescrPtr + (wsaDescript_Len + 1),
	StatusStr = cast( STRING, StatusPtr ),
	Status = copy_String( StatusStr ),

	TailPtr = StatusPtr + (wsaSys_Status_Len + 1),
	TailBin = cast( BINARY, TailPtr ),
	MaxSockets = getwordentry( TailBin, 0 ),
	MaxUdpDg = getwordentry( TailBin, 1 ),
	VendorInfo = getdwordentry( TailBin, 1 ),

	WSA_Data = sck_wsa_data( Version,
				 HighVersion,
				 Description,
				 Status,
				 MaxSockets,
				 MaxUdpDg,
				 VendorInfo ), !.

    make_WSAData( _, _, sck_wsa_data( 0, 0, "", "", 0, 0, 0 ) ).

    cleanup_db_async():-
    	retract( db_async( _, BufferPtr )),
    		Buffer = cast(BINARY, BufferPtr),
    		mem_ReleaseBinaryHeap( Buffer ),
    	fail.
    cleanup_db_async().
    
    clean_db_async_entry( TaskHandle ):-
    	retract( db_async( TaskHandle, BufferPtr )),!,
    	Buffer = cast(BINARY, BufferPtr),
    	mem_ReleaseBinaryHeap( Buffer ).
    clean_db_async_entry( _ ).	

  enddef

  get_SocketType( Socket, SocketType ) :-
	SimpleOpt = sck_GetSockOpt( Socket, sol_socket, so_type ),
	SimpleOpt = sck_SimpleOpt( SocketType ), !.

  get_SocketType( _, sock_Stream ) :-
	errorexit( err_SckGeneral ).

  check_RecvSocketType( Socket, is_Recv_DataGram ) :-
	sock_DGram = get_SocketType( Socket ), !.

  check_RecvSocketType( _, is_Recv_DataGram ) :- !,
	errorexit( err_SckInvalidParms ).

  check_RecvSocketType( Socket, _ ) :-
	sock_DGram = get_SocketType( Socket ), !,
	errorexit( err_SckInvalidParms ).

  check_RecvSocketType( _, _ ).

  receive( Socket, RecvLength, RecvFlags, IsDataGram, RecvBuffer ) :-
	check_RecvSocketType( Socket, IsDataGram ),
	Flags = make_Flags( RecvFlags, is_RecvCall ),
	Buffer = makebinary( RecvLength ),
	ReadLen = bsd_Recv( Socket, Buffer, RecvLength, Flags ),
	ifdef os_os2
	  c_Os2_ResetFdRead( Socket, 1 ),
	enddef
	RecvBuffer = check_RecvBuffer( Buffer, ReadLen, IsDataGram ).

  receiveFrom( Socket,
	       RecvLength,
	       RecvFlags,
	       IsDataGram,
	       FromAddr,
	       RecvBuffer ) :-
	check_RecvSocketType( Socket, IsDataGram ),
	Flags = make_Flags( RecvFlags, is_RecvCall ),
	Buffer = makebinary( RecvLength ),
	InAddress = makebinary( sockAddr_StructSize ),
	InAddrLen = make_IntPtrParm( sockAddr_StructSize ),
	ReadLen = bsd_RecvFrom( Socket,
				Buffer,
				RecvLength,
				Flags,
				InAddress,
				InAddrLen ),
	ifdef os_os2
	  c_Os2_ResetFdRead( Socket, 0 ),
	enddef
	RecvBuffer = check_RecvBuffer( Buffer, ReadLen, IsDataGram ),
	FromAddr = check_OutBinParm( InAddress, InAddrLen ).

