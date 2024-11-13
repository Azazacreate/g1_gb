/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 Project:
 FileName: APINet.PRO
 Purpose: A Visual Prolog interface to API NET calls
 Written by: Konstantin Ivanov & Compiler Group
 Comments: FOR INTERNAL USE ONLY
******************************************************************************/

include "webagent.inc"

ifndef ws_win
  ifdef platform_32bit
    ifndef os_os2
      #error Unsupported platform
    enddef
  elsedef
    #error Unsupported platform
  enddef
enddef

ifndef apicalls_dom_included
  #Error : apicalls.dom must be included
enddef

ifndef apicalls_con_included
  #Error : apicalls.con must be included
enddef

ifndef apicalls_pre_included
  #Error : apicalls.pre must be included
enddef
ifndef apinet_pre_included
  #Error : apinet.pre must be included
enddef

ifndef apinet_pro_included

  CONSTANTS

    apinet_pro_included = 1

			/************************/
			/* Names of API calls  */
			/************************/
  ifdef os_nt

    DOMAINS

      NetMessageBufferSend 	= procedure DWORD ( STRING, STRING, STRING, STRING, DWORD ) 	- (i,i,i,i,i) language stdcall
      NetMessageNameAdd		= procedure DWORD ( STRING, STRING )				- (i,i)	language stdcall
      NetMessageNameDel		= procedure DWORD ( STRING, STRING )				- (i,i) language stdcall

  enddef

  ifdef os_nt

    CONSTANTS

      nt_error_offset = 7000
    
    DATABASE - apinet_db
      
      determ apinet( OS_HANDLE )

  enddef

  ifdef os_nt

    PREDICATES

      procedure getNetHandle( OS_HANDLE Handle ) 			- (o)

    CLAUSES

      getNetHandle( Handle ):- apinet( Handle ),!.
      getNetHandle( Handle ):-
     		Handle = api_LoadLibrary( "netapi32" ),
     		assert(apinet( Handle )).

    CLAUSES
    
     api_NetInit():-apinet(_),!.
     api_NetInit():-
     		Handle = api_LoadLibrary( "netapi32" ),
     		assert(apinet( Handle )).
     
     api_NetTerminate():- not(apinet(_)),!.
     api_NetTerminate():-
     		apinet( Handle ),
     		api_FreeLibrary( Handle ),
     		retract(apinet( Handle )),!.
     api_NetTerminate().

     api_NetMessageBufferSend( "", MsgName, "", Buffer, RC ):-
     		getNetHandle( Handle ),
     		NullServerName = cast( STRING, 0 ),
     		NullFromName = cast( STRING, 0 ),
     		L = api_lstrlen( Buffer ),L1 = L*2,	% wide char twice larger than common string
     		NetMessageBufferSend_ptr = cast( NetMessageBufferSend, api_GetProcAddress( Handle, "NetMessageBufferSend")),
     		RC = NetMessageBufferSend_ptr( NullServerName, MsgName, NullFromName, Buffer, L1),!.
     api_NetMessageBufferSend( ServerName, MsgName, "", Buffer, RC ):-
     		getNetHandle( Handle ),
     		NullFromName = cast( STRING, 0 ),
     		L = api_lstrlen( Buffer ),L1 = L*2,
     		NetMessageBufferSend_ptr = cast( NetMessageBufferSend, api_GetProcAddress( Handle, "NetMessageBufferSend")),
     		RC = NetMessageBufferSend_ptr( ServerName, MsgName, NullFromName, Buffer, L1),!.
     api_NetMessageBufferSend( "", MsgName, FromName, Buffer, RC ):-
     		getNetHandle( Handle ),
     		NullServerName = cast( STRING, 0 ),
     		L = api_lstrlen( Buffer ),L1 = L*2,
     		NetMessageBufferSend_ptr = cast( NetMessageBufferSend, api_GetProcAddress( Handle, "NetMessageBufferSend")),
     		RC = NetMessageBufferSend_ptr( NullServerName, MsgName, FromName, Buffer, L1),!.
     api_NetMessageBufferSend( ServerName, MsgName, FromName, Buffer, RC ):-
     		getNetHandle( Handle ),
     		L = api_lstrlen( Buffer ),L1 = L*2,
     		NetMessageBufferSend_ptr = cast( NetMessageBufferSend, api_GetProcAddress( Handle, "NetMessageBufferSend")),
     		RC = NetMessageBufferSend_ptr( ServerName, MsgName, FromName, Buffer, L1).
     		
     api_NetMessageNameAdd( "", MsgName, RC ):-
     		getNetHandle( Handle ),
     		NullServerName = cast( STRING, 0 ),
     		NetMessageNameAdd_ptr = cast( NetMessageNameAdd, api_GetProcAddress( Handle, "NetMessageNameAdd")),
     		RC = NetMessageNameAdd_ptr( NullServerName, MsgName ),!.
     api_NetMessageNameAdd( ServerName, MsgName, RC ):-
     		getNetHandle( Handle ),
     		NetMessageNameAdd_ptr = cast( NetMessageNameAdd, api_GetProcAddress( Handle, "NetMessageNameAdd")),
     		RC = NetMessageNameAdd_ptr( ServerName, MsgName ).
     		
     api_NetMessageNameDel( "", MsgName, RC ):-
     		getNetHandle( Handle ),
     		NullServerName = cast( STRING, 0 ),
     		NetMessageNameDel_ptr = cast( NetMessageNameDel, api_GetProcAddress( Handle, "NetMessageNameDel")),
     		RC = NetMessageNameDel_ptr( NullServerName, MsgName ),!.
     api_NetMessageNameDel( ServerName, MsgName, RC ):-
     		getNetHandle( Handle ),
     		NetMessageNameDel_ptr = cast( NetMessageNameDel, api_GetProcAddress( Handle, "NetMessageNameDel")),
     		RC = NetMessageNameDel_ptr( ServerName, MsgName ),!.

  enddef	/* os_nt */
  
enddef
