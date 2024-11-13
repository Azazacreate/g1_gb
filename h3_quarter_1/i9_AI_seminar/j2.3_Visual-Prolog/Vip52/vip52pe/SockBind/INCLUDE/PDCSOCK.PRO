/***************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 FileName: PDCSOCK.PRO
 PURPOSE: Interface to the native Sockets
 Written by: Compiler Group, PDC Russia

 อออออออออออออออหออออออหออออออออออออออออออออออออออออออออออออออออออออออออออออ
  Date Modified,บ By,  บ        Comments.
 อออออออออออออออฮออออออฮออออออออออออออออออออออออออออออออออออออออออออออออออออ
                บ      บ
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

include "source\\psock_tp.pro"

			/***************************/
			/* Synchronous BSD Sockets */
			/***************************/
CLAUSES

  sck_Accept( ListenSocket, AcceptSocket ) :-
	NullAddr = cast( BINARY, native_NULL ),
	NullAddrLen = cast( BINARY, native_NULL ),
	AcceptSocket = bsd_Accept( ListenSocket, NullAddr, NullAddrLen ),
	ifdef os_os2
	  c_Os2_CheckAcception( ListenSocket, AcceptSocket ),
	enddef
	check_Socket( AcceptSocket ).

  sck_Accept( ListenSocket, AcceptAddr, AcceptSocket ) :-
	InAddress = makebinary( sockAddr_StructSize ),
	InAddrLen = make_IntPtrParm( sockAddr_StructSize ),
	AcceptSocket = bsd_Accept( ListenSocket, InAddress, InAddrLen ),
	ifdef os_os2
	  c_Os2_CheckAcception( ListenSocket, AcceptSocket ),
	enddef
	check_Socket( AcceptSocket ),
	AcceptAddr = check_OutBinParm( InAddress, InAddrLen ).

  sck_Bind( UnboundSocket, Name ) :-
	NameLen = getbinarysize( Name ),
	RC = bsd_Bind( UnboundSocket, Name, NameLen ),
	check_RetCode( RC ).

  sck_CloseSocket( Socket ) :-
	ifdef os_os2
	  c_Os2_RegClose( Socket ),
	enddef
	RC = bsd_CloseSocket( Socket ),
	check_RetCode( RC ).

  sck_Connect( Socket, Name ) :-
	NameLen = getbinarysize( Name ),
	ifdef os_os2
	  c_Os2_RegConnect( Socket ),
	enddef
	RC = bsd_Connect( Socket, Name, NameLen ),
	ifdef os_os2
	  c_Os2_CheckConnect( Socket, RC ),
	enddef
	check_RetCode( RC ).

  sck_GetPeerName( Socket, SckAddress ) :-
	InAddress = makebinary( sockAddr_StructSize ),
	InAddrLen = make_IntPtrParm( sockAddr_StructSize ),
	RC = bsd_GetPeerName( Socket, InAddress, InAddrLen ),
	check_RetCode( RC ),
	SckAddress = check_OutBinParm( InAddress, InAddrLen ).

  sck_GetSockName( Socket, SckAddress ) :-
	InAddress = makebinary( sockAddr_StructSize ),
	InAddrLen = make_IntPtrParm( sockAddr_StructSize ),
	RC = bsd_GetSockName( Socket, InAddress, InAddrLen ),
	check_RetCode( RC ),
	SckAddress = check_OutBinParm( InAddress, InAddrLen ).

  sck_GetSockOpt( Socket, OptionLevel, OptionName, OptionValue ) :-
	OptBuffer = make_SckOptBuffer( OptionName ),
	SizeOfOptBuff = getbinarysize( OptBuffer ),
	OptBuffLen = make_IntPtrParm( SizeOfOptBuff ),
	RC = bsd_GetSockOpt( Socket,
			     OptionLevel,
			     OptionName,
			     OptBuffer,
			     OptBuffLen ),
	check_RetCode( RC ),
	ResBuffer = check_OutBinParm( OptBuffer, OptBuffLen ),
	check_OutSckOption( ResBuffer, OptionName ),
	OptionValue = make_SckOption( ResBuffer, OptionName ).

  sck_IoCtlGet( Socket, cmd_FionRead, Result ) :-
	Result = ioCtl_Get( Socket, cmd_FionRead ), !.

  sck_IoCtlGet( Socket, cmd_SioCatMark, Result ) :-
	Result = ioCtl_Get( Socket, cmd_SioCatMark ), !.

  sck_IoCtlGet( _, _, 0 ) :-
	errorexit( err_SckInvalidParms ).

  sck_IoCtlSet( Socket, cmd_FionBio, Argument ) :-
	ioCtl_Set( Socket, cmd_FionBio, Argument ), !.

  sck_IoCtlSet( _, _, _ ) :-
	errorexit( err_SckInvalidParms ).

  sck_Listen( Socket, BackLog ) :-
	ifdef os_os2
	  c_Os2_RegListen( Socket ),
	enddef
	RC = bsd_Listen( Socket, BackLog ),
	check_RetCode( RC ).

  sck_Recv( Socket, RecvLength, RecvFlags, RecvBuffer ) :-
	receive( Socket, RecvLength, RecvFlags, is_Recv_Stream, RecvBuffer ).

  sck_Recv_DG( Socket, RecvLength, RecvFlags, RecvBuffer ) :-
	receive( Socket, RecvLength, RecvFlags, is_Recv_DataGram, RecvBuffer ).

  sck_RecvFrom( Socket, RecvLength, RecvFlags, FromAddr, RecvBuffer) :-
	receiveFrom( Socket,
		     RecvLength,
		     RecvFlags,
		     is_Recv_Stream,
		     FromAddr,
		     RecvBuffer).

  sck_RecvFrom_DG( Socket, RecvLength, RecvFlags, FromAddr, RecvBuffer) :-
	receiveFrom( Socket,
		     RecvLength,
		     RecvFlags,
		     is_Recv_DataGram,
		     FromAddr,
		     RecvBuffer).

  sck_Select( In_ReadFds,
	      In_WriteFds,
	      In_ExceptFds,
	      Out_ReadFds,
	      Out_WriteFds,
	      Out_ExceptFds ) :-
	c_MakeFdsFromSockList( In_ReadFds, 0, ReadFDS, NFds_R ),
	c_MakeFdsFromSockList( In_WriteFds, NFds_R, WriteFDS, NFds_W ),
	c_MakeFdsFromSockList( In_ExceptFds, NFds_W, ExceptFDS, NFds_E ),
	RealNFds = NFds_E + 1,
	TimeOut = cast( SCK_SELECT_TIMEVAL, native_NULL ),
	RC = bsd_Select( RealNFds, ReadFDS, WriteFDS, ExceptFDS, TimeOut),
	check_SockError( RC ),

	RC > 0, !,
	Out_ReadFds = c_MakeSockListFromFds( In_ReadFds, ReadFDS ),
	Out_WriteFds = c_MakeSockListFromFds( In_WriteFds, WriteFDS ),
	Out_ExceptFds = c_MakeSockListFromFds( In_ExceptFds, ExceptFDS ).

  sck_Select( _, _, _, [], [], [] ).

  sck_Select( In_ReadFds,
	      In_WriteFds,
	      In_ExceptFds,
	      TimeOut,
	      Out_ReadFds,
	      Out_WriteFds,
	      Out_ExceptFds ) :-
	c_MakeFdsFromSockList( In_ReadFds, 0, ReadFDS, NFds_R ),
	c_MakeFdsFromSockList( In_WriteFds, NFds_R, WriteFDS, NFds_W ),
	c_MakeFdsFromSockList( In_ExceptFds, NFds_W, ExceptFDS, NFds_E ),
	RealNFds = NFds_E + 1,

	RC = bsd_Select( RealNFds, ReadFDS, WriteFDS, ExceptFDS, TimeOut),
	check_SockError( RC ),

	RC > 0, !,
	Out_ReadFds = c_MakeSockListFromFds( In_ReadFds, ReadFDS ),
	Out_WriteFds = c_MakeSockListFromFds( In_WriteFds, WriteFDS ),
	Out_ExceptFds = c_MakeSockListFromFds( In_ExceptFds, ExceptFDS ).

  sck_Select( _, _, _, _, [], [], [] ).

  sck_Send( Socket, DataToSend, SendFlags, SendedLen ) :-
	Flags = make_Flags( SendFlags, is_SendCall ),
	DataLen = getbinarysize( DataToSend ),
	SendedLen = bsd_Send( Socket, DataToSend, DataLen, Flags ),
	ifdef os_os2
	  c_Os2_ResetFdWrite( Socket, SendedLen ),
	enddef
	check_SockError( SendedLen ).

  sck_SendTo( Socket, DataToSend, SendFlags, ToAddress, SendedLen ) :-
	Flags = make_Flags( SendFlags, is_SendCall ),
	DataLen = getbinarysize( DataToSend ),
	AddrLen = getbinarysize( ToAddress ),
	SendedLen = bsd_SendTo( Socket,
				DataToSend,
				DataLen,
				Flags,
				ToAddress,
				AddrLen ),
	ifdef os_os2
	  c_Os2_ResetFdWrite( Socket, SendedLen ),
	enddef
	check_SockError( SendedLen ).

  sck_SetSockOpt( Socket, OptionLevel, OptionName, OptionValue ) :-
	OptBuffer = make_SckOptBuffer( OptionName ),
	fill_SetOptBuffer( OptionName, OptionValue, OptBuffer ),
	OptBuffLen = getbinarysize( OptBuffer ),
	RC = bsd_SetSockOpt( Socket,
			     OptionLevel,
			     OptionName,
			     OptBuffer,
			     OptBuffLen ),
	check_RetCode( RC ).

  sck_ShutDown( Socket, How ) :-
	ifdef os_os2
	  c_Os2_RegShutDown( Socket, How ),
	enddef
	RC = bsd_ShutDown( Socket, How ),
	check_RetCode( RC ).

  sck_Socket( AddrFamily, Type, Protocol, Socket ) :-
  	Socket = bsd_Socket( AddrFamily, Type, Protocol ),
	check_Socket( Socket ).

			/************************/
			/* Asynchronous Sockets */
			/************************/
CLAUSES

  sck_AsyncSelect( Socket, HWindow, Msg, EventsList ) :-
	Events = make_Events( EventsList ),

	ifdef os_os2
	  c_Os2_AsyncSelect( Socket, HWindow, Msg, Events ).
	elsedef
	  RC = wsa_AsyncSelect( Socket, HWindow, Msg, Events ),
	  check_RetCode( RC ).
	enddef

  sck_GetSelectEvent( LParam, Event ) :-
	ifdef platform_32bit
	  bitand( LParam, 0x0000FFFF, Event ).
	elsedef
	  /* ### Event = val( unsigned, LParam ).*/
	  Bin = makebinary( 4 ),
	  setdwordentry( Bin, 0, LParam ),
	  Event = getwordentry( Bin, 0 ).	/* ### ??? */
	enddef

  sck_GetSelectError( LParam, Error ) :-
	ifdef platform_32bit
	  bitright( LParam, 16, Tmp ),
	  bitand( Tmp, 0x0000FFFF, Error ).
	elsedef
	  Bin = makebinary( 4 ),
	  setdwordentry( Bin, 0, LParam ),
	  Error = getwordentry( Bin, 1 ).	/* ### ??? */
	enddef


			/*********************/
			/* Addresses support */
			/*********************/
CLAUSES

  sck_MergeAddress( Sa_Family, Sa_Data, Address ) :-
	Address = makebinary( sockAddr_StructSize ),
	setwordentry( Address, 0, Sa_Family ),
	fill_SAData( Address, Sa_Data ).

  sck_SplitAddress( Address, Sa_Family, Sa_Data ) :-
	SizeOfAddr = getbinarysize( Address ),
	SizeOfAddr >= sizeof( USHORT ), !,
	Sa_Family = getwordentry( Address, 0 ),
	Sa_Data = get_SAData( Address ).

  sck_SplitAddress( _, 0, NullSAData ) :-
	NullSAData = cast( BINARY, native_NULL ),
	errorexit( err_SckInvalidParms ).

  sck_MergeAddress_IN( Sin_Family, Sin_Port, Sin_Addr, Address ) :-
	Address = makebinary( sockAddr_StructSize ),
	setwordentry( Address, 0, Sin_Family ),
	setwordentry( Address, 1, Sin_Port ),
	setdwordentry( Address, 1, Sin_Addr ).

  sck_SplitAddress_IN( Address,	Sin_Family, Sin_Port, Sin_Addr ) :-
	SizeOfAddr = getbinarysize( Address ),
	SizeOfAddr >= (sockAddr_StructSize - sin_Zero_Size), !,
	Sin_Family = getwordentry( Address, 0 ),
	Sin_Port = getwordentry( Address, 1 ),
	Sin_Addr = getdwordentry( Address, 1 ).

  sck_SplitAddress_IN( _, 0, 0, 0 ) :-
	errorexit( err_SckInvalidParms ).

			/**********************/
			/* Conversion support */
			/**********************/
CLAUSES

  sck_InetAddr( DottedAddr, AddrIN ) :-
	AddrIN = bsd_InetAddr( DottedAddr ),
	AddrIN <> inAddr_None , !.

  sck_InetAddr( _, 0 ) :-
	errorexit( err_SckInvalidParms ).

  sck_InetNtoa( AddrIN, DottedAddr ) :-
	Result = bsd_InetNtoa( AddrIN ),
	Result <> native_NULL, !,
	ResStr = cast( STRING, Result ),
	DottedAddr = copy_String( ResStr ).

  sck_InetNtoa( _, DottedAddr ) :-
	DottedAddr = cast( STRING, native_NULL ),
	errorexit( err_SckInvalidParms ).

			/**********************/
			/* Get_X_by_Y support */
			/**********************/
CLAUSES

  sck_GetHostByAddr( AddressIN, Type, HostEnt ) :-
	AddrPtr = make_ULongPtrParm( AddressIN ),
	AddrLen = getbinarysize( AddrPtr ),
	Result	= bsd_GetHostByAddr( AddrPtr, AddrLen, Type ),
	HostEnt = copy_HostEnt( Result ).

  sck_GetHostByName( HostName, HostEnt ) :-
	Result	= bsd_GetHostByName( HostName ),
	HostEnt = copy_HostEnt( Result ).

  sck_GetHostName( ReqNameLen, HostName ) :-
	str_len( HostName, ReqNameLen ),
	RC = bsd_GetHostName( HostName, ReqNameLen ),
	check_RetCode( RC ).

  sck_GetProtoByName( ProtoName, ProtoEnt ) :-
	Result = bsd_GetProtoByName( ProtoName ),
	ProtoEnt = copy_ProtoEnt( Result ).

  sck_GetProtoByNumber( ProtoNumber, ProtoEnt ) :-
	Result = bsd_GetProtoByNumber( ProtoNumber ),
	ProtoEnt = copy_ProtoEnt( Result ).

  sck_GetServByName( ServiceName, ServEnt ) :-
	NullProto = cast( STRING, native_NULL ),
	Result = bsd_GetServByName( ServiceName, NullProto ),
	ServEnt = copy_ServEnt( Result ).

  sck_GetServByName( ServiceName, ProtocolName, ServEnt ) :-
	Result = bsd_GetServByName( ServiceName, ProtocolName ),
	ServEnt = copy_ServEnt( Result ).

  sck_GetServByPort( Port, ServEnt ) :-
	NullProto = cast( STRING, native_NULL ),
	Result = bsd_GetServByPort( Port, NullProto ),
	ServEnt = copy_ServEnt( Result ).

  sck_GetServByPort( Port, ProtocolName, ServEnt ) :-
	Result = bsd_GetServByPort( Port, ProtocolName ),
	ServEnt = copy_ServEnt( Result ).

			/*********************************/
			/* MS Windows specific routines */
			/*********************************/

CLAUSES

  ifdef ws_win

    sck_AsyncGetHostByAddr( HWindow, Msg, AddressIN, Type, BufLen, TaskHandle ) :-
	AddrPtr = make_ULongPtrParm( AddressIN ),
	AddrLen = getbinarysize( AddrPtr ),
	Buffer = mem_MakeBinaryHeap( BufLen ),
	BufferPtr = cast(POINTER, Buffer),
	TaskHandle = wsa_AsyncGetHostByAddr( HWindow, Msg, AddrPtr, AddrLen, Type, Buffer, BufLen),
	check_handle( TaskHandle ),
	clean_db_async_entry( TaskHandle ),
	assert(db_async( TaskHandle, BufferPtr )).

    sck_AsyncGetHostByName( HWindow, Msg, HostName, BufLen, TaskHandle ) :-
  	Buffer = mem_MakeBinaryHeap( BufLen ),
  	BufferPtr = cast(POINTER, Buffer),
	TaskHandle = wsa_AsyncGetHostByName( HWindow, Msg, HostName, Buffer, BufLen),
	check_handle( TaskHandle ),
	retractall(db_async( TaskHandle, _ )),
	assert(db_async( TaskHandle, BufferPtr )).
	
    sck_AsyncGetProtoByName( HWindow, Msg, ProtoName, BufLen, TaskHandle ) :-
  	Buffer = mem_MakeBinaryHeap( BufLen ),
  	BufferPtr = cast(POINTER, Buffer),
	TaskHandle = wsa_AsyncGetProtoByName( HWindow, Msg, ProtoName, Buffer, BufLen),
	check_handle( TaskHandle ),
	retractall(db_async( TaskHandle, _ )),
	assert(db_async( TaskHandle, BufferPtr )).
	
    sck_AsyncGetProtoByNumber( HWindow, Msg, ProtoNumber, BufLen, TaskHandle ) :-
  	Buffer = mem_MakeBinaryHeap( BufLen ),
  	BufferPtr = cast(POINTER, Buffer),
	TaskHandle = wsa_AsyncGetProtoByNumber( HWindow, Msg, ProtoNumber, Buffer, BufLen),
	check_handle( TaskHandle ),
	retractall(db_async( TaskHandle, _ )),
	assert(db_async( TaskHandle, BufferPtr )).
	
    sck_AsyncGetServByName( HWindow, Msg, ServName, BufLen, TaskHandle ) :-
  	Buffer = mem_MakeBinaryHeap( BufLen ),
  	BufferPtr = cast(POINTER, Buffer),
  	NullProto = cast( STRING, native_NULL ),
	TaskHandle = wsa_AsyncGetServByName( HWindow, Msg, ServName, NullProto, Buffer, BufLen),
	check_handle( TaskHandle ),
	retractall(db_async( TaskHandle, _ )),
	assert(db_async( TaskHandle, BufferPtr )).
	
    sck_AsyncGetServByName( HWindow, Msg, ServName, ProtoName, BufLen, TaskHandle ) :-
  	Buffer = mem_MakeBinaryHeap( BufLen ),
  	BufferPtr = cast(POINTER, Buffer),
	TaskHandle = wsa_AsyncGetServByName( HWindow, Msg, ServName, ProtoName, Buffer, BufLen),
	check_handle( TaskHandle ),
	retractall(db_async( TaskHandle, _ )),
	assert(db_async( TaskHandle, BufferPtr )).

    sck_AsyncGetServByPort( HWindow, Msg, PortNumber, BufLen, TaskHandle ) :-
  	Buffer = mem_MakeBinaryHeap( BufLen ),
  	BufferPtr = cast(POINTER, Buffer),
  	NullProto = cast( STRING, native_NULL ),
	TaskHandle = wsa_AsyncGetServByPort( HWindow, Msg, PortNumber, NullProto, Buffer, BufLen),
	check_handle( TaskHandle ),
	retractall(db_async( TaskHandle, _ )),
	assert(db_async( TaskHandle, BufferPtr )).
	
    sck_AsyncGetServByPort( HWindow, Msg, PortNumber, ProtoName, BufLen, TaskHandle ) :-
  	Buffer = mem_MakeBinaryHeap( BufLen ),
  	BufferPtr = cast(POINTER, Buffer),
	TaskHandle = wsa_AsyncGetServByPort( HWindow, Msg, PortNumber, ProtoName, Buffer, BufLen),
	check_handle( TaskHandle ),
	retractall(db_async( TaskHandle, _ )),
	assert(db_async( TaskHandle, BufferPtr )).

    sck_CancelAsyncRequest( TaskHandle ):-
  	not(db_async( TaskHandle, _ )),!,
	errorexit( err_SckInvalidParms ).
    sck_CancelAsyncRequest( TaskHandle ):-
  	db_async( TaskHandle, BufferPtr ),
  	RC = wsa_CancelAsyncRequest( TaskHandle ),
  	retract(db_async( TaskHandle, BufferPtr )),!,
  	Buffer = cast(BINARY,BufferPtr),
  	mem_ReleaseBinaryHeap( Buffer ),
  	check_SockError( RC ),
  	!.
    sck_CancelAsyncRequest( _ ).
    
    sck_GetAsyncHostent( TaskHandle, Result ):-
  	not(db_async( TaskHandle, _ )),!,
  	Result = cast( SCK_HOSTENT, native_NULL ),
	errorexit( err_SckInvalidParms ).
    sck_GetAsyncHostent( TaskHandle, HostEnt ):-
  	retract(db_async( TaskHandle, BufferPtr )),!,
  	Buffer = cast(BINARY,BufferPtr),
  	Result = cast( SCK_HOSTENT, Buffer ),
  	HostEnt = copy_HostEnt( Result ),
  	mem_ReleaseBinaryHeap( Buffer ),!.
    sck_GetAsyncHostent( _, Result ):-	% because it is a procedure
    	Result = cast( SCK_HOSTENT, native_NULL ).
    
    sck_GetAsyncProtoent( TaskHandle, Result ):-
  	not(db_async( TaskHandle, _ )),!,
  	Result = cast( SCK_PROTOENT, native_NULL ),
	errorexit( err_SckInvalidParms ).
    sck_GetAsyncProtoent( TaskHandle, ProtoEnt ):-
  	retract(db_async( TaskHandle, BufferPtr )),!,
  	Buffer = cast(BINARY,BufferPtr),
  	Result = cast( SCK_PROTOENT, Buffer ),
  	ProtoEnt = copy_ProtoEnt( Result ),
  	mem_ReleaseBinaryHeap( Buffer ),!.
    sck_GetAsyncProtoent( _, Result ):-	% because it is a procedure
    	Result = cast( SCK_PROTOENT, native_NULL ).
    	
    sck_GetAsyncServent( TaskHandle, Result ):-
  	not(db_async( TaskHandle, _ )),!,
  	Result = cast( SCK_SERVENT, native_NULL ),
	errorexit( err_SckInvalidParms ).
    sck_GetAsyncServent( TaskHandle, ServEnt ):-
  	retract(db_async( TaskHandle, BufferPtr )),!,
  	Buffer = cast(BINARY,BufferPtr),
  	Result = cast( ULONG, Buffer ),
  	ServEnt = copy_ServEnt( Result ),
  	mem_ReleaseBinaryHeap( Buffer ),!.
    sck_GetAsyncServent( _, Result ):-	% because it is a procedure
    	Result = cast( SCK_SERVENT, native_NULL ).
    	
    sck_GetAsyncBuflen( LParam, Buflen ) :-
	ifdef platform_32bit
	  bitand( LParam, 0x0000FFFF, Buflen ).
	elsedef
	  /* ### Event = val( unsigned, LParam ).*/
	  Bin = makebinary( 4 ),
	  setdwordentry( Bin, 0, LParam ),
	  Buflen = getwordentry( Bin, 0 ).	/* ### ??? */
	enddef

    sck_GetAsyncError( LParam, Error ) :-
	ifdef platform_32bit
	  bitright( LParam, 16, Tmp ),
	  bitand( Tmp, 0x0000FFFF, Error ).
	elsedef
	  Bin = makebinary( 4 ),
	  setdwordentry( Bin, 0, LParam ),
	  Error = getwordentry( Bin, 1 ).	/* ### ??? */
	enddef

    sck_CancelBlockingCall():-
  	RC = wsa_CancelBlockingCall(),
  	check_SockError(RC).
  	
    sck_SetBlockingHook( BlockFunc, Result ):-
  	Result = wsa_SetBlockingHook( BlockFunc ),
  	check_blockfunc( Result ).
  
    sck_UnhookBlockingHook():-
  	RC = wsa_UnhookBlockingHook(),
  	check_SockError(RC).
  	
  enddef

			/*****************/
			/* Miscellaneous */
			/*****************/
CLAUSES

  ifdef os_os2

    sck_Startup() :-
	RC = bsd_SockInit(),
	check_RetCode( RC ),
	c_Os2_Initiate().
  elsedef

    sck_Startup( VersionRequested, WSA_Data, RetCode ) :-
	BuffSize = (2 * sizeof( WORD ))		+
		   (wsaDescript_Len + 1)	+
		   (wsaSys_Status_Len + 1)	+
		   (2 * sizeof( USHORT ))	+
		   sizeof( VENDOR_INFO_PTR ),
	Buffer = makebinary( BuffSize ),

	RetCode = wsa_Startup( VersionRequested, Buffer ),
	WSA_Data = make_WSAData( Buffer, RetCode ).

  enddef

  sck_Cleanup():-
	ifdef os_os2
	  c_Os2_Terminate().
	elsedef
	  cleanup_db_async(),
	  RC = wsa_Cleanup(),
	  check_RetCode( RC ).
	enddef

