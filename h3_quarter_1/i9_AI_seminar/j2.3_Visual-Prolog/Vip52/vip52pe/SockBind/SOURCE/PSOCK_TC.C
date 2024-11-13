/***************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S

				Visual Prolog

 FileName: PSOCK_TC.C
 PURPOSE: Interface to the native Sockets. C implementation's specific
 Written by: Compiler Group, PDC Russia

 อออออออออออออออหออออออหออออออออออออออออออออออออออออออออออออออออออออออออออออ
  Date Modified,บ By,  บ        Comments.
 อออออออออออออออฮออออออฮออออออออออออออออออออออออออออออออออออออออออออออออออออ
                บ      บ
***************************************************************************/

#include <pdcrunt.h>

/***************************************************************************
***************************************************************************/

#ifndef FAR
  #ifdef MLINEAR
    #define FAR
  #else
    #define FAR far
  #endif
#endif

#if defined( __IBMC__ ) || defined( __OS2__ )
  #define INCL_NOCOMMON
  #ifndef INCL_DOSINCLUDED
    #define INCL_DOS
    #define INCL_DOSERRORS
    #define INCL_WINMESSAGEMGR
  #endif

  #include <os2.h>

  typedef int SOCKET;

  #define SOCK_SETMEM0( p, s )  MEM_SetMem( (char *)(p), (s), '\0' )

  #define NBBY		8				/* bits per byte */
  #define FD_SETSIZE	2048

  typedef unsigned	fd_mask;
  #define NFDBITS	(sizeof(fd_mask) * NBBY)	/* bits per mask */
  #define howmany(x, y)	(((x)+((y)-1))/(y))

  typedef struct fd_set {
	fd_mask fds_bits[ howmany( FD_SETSIZE, NFDBITS ) ];
  } fd_set;

  #define FD_SET( n, p )	{ fd_set * const __p = (fd_set * const)(p); \
				  __p->fds_bits[(n)/NFDBITS] |=		    \
					(unsigned)(1 << ((n) % NFDBITS));   \
				}

  #define FD_CLR( n, p )	{ fd_set * const __p = (fd_set * const)(p); \
				  __p->fds_bits[(n)/NFDBITS] &=		    \
					(unsigned)(~(1 << ((n) % NFDBITS)));\
				}

  static int __fdIsSet( const SOCKET Socket, const void * const pFdSet );

  #define FD_ISSET( n, p )	__fdIsSet( (n), (p) )
  #define FD_ZERO( p )		SOCK_SETMEM0( p, sizeof( fd_set ) )

  #ifdef __IBMC__

    #pragma map( c_MakeAListFromArray,	"_c_MakeAListFromArray" )
    #pragma map( c_MakeSListFromArray,	"_c_MakeSListFromArray" )
    #pragma map( c_MakeFdsFromSockList,	"_c_MakeFdsFromSockList" )
    #pragma map( c_MakeSockListFromFds,	"_c_MakeSockListFromFds" )

    #pragma map( c_Os2_AsyncSelect,	"_c_Os2_AsyncSelect" )
    #pragma map( c_Os2_CheckAcception,	"_c_Os2_CheckAcception" )
    #pragma map( c_Os2_RegClose,	"_c_Os2_RegClose" )
    #pragma map( c_Os2_RegConnect,	"_c_Os2_RegConnect" )
    #pragma map( c_Os2_CheckConnect,	"_c_Os2_CheckConnect" )
    #pragma map( c_Os2_RegListen,	"_c_Os2_RegListen" )
    #pragma map( c_Os2_RegShutDown,	"_c_Os2_RegShutDown" )
    #pragma map( c_Os2_ResetFdRead,	"_c_Os2_ResetFdRead" )
    #pragma map( c_Os2_ResetFdWrite,	"_c_Os2_ResetFdWrite" )

    #pragma map( c_Os2_Initiate,	"_c_Os2_Initiate" )
    #pragma map( c_Os2_Terminate,	"_c_Os2_Terminate" )

    #pragma map( sck_ASelectTimeOut_0,	"_sck_ASelectTimeOut_0" )
    #pragma map( sck_ASelectTimeOut_1,	"_sck_ASelectTimeOut_1" )

    #pragma map( sck_ASetNotifyFNS,	"_sck_ASetNotifyFNS" )
    #pragma map( sleep,	"_OS_Sleep" )

  #endif

#elif defined( __WIN__ )

  typedef unsigned SOCKET;

  #define FD_SETSIZE	64

  typedef struct fd_set {
	unsigned fd_count;		/* how many are SET?	*/
	SOCKET	 fd_array[FD_SETSIZE];	/* an array of SOCKETs	*/
  } fd_set;

  #define FD_CLR( fd, set )	{ fd_set FAR * const __p =		\
  						((fd_set FAR *)(set));	\
				  do {					\
				    unsigned __i;			\
				    for ( __i = 0;			\
					  __i < __p->fd_count;		\
					  __i++ ) {			\
				      if ( __p->fd_array[__i] == fd ) {	\
					while (__i < __p->fd_count-1) {	\
					  __p->fd_array[__i] =		\
						__p->fd_array[__i+1];	\
					  __i++;			\
					}				\
					__p->fd_count--;		\
					break;				\
				      }					\
				    }					\
				  } while( 0 );				\
				}

  #define FD_SET( fd, set )	{ fd_set FAR * const __p =		\
  						((fd_set FAR *)(set));	\
				  do {					\
				    if ( __p->fd_count < FD_SETSIZE ) {	\
				      __p->fd_array[__p->fd_count++] =	\
								(fd);	\
				    }					\
				  } while( 0 );				\
				}

  #define FD_ZERO( set )	(((fd_set FAR *)(set))->fd_count = 0)

  extern int PASCAL FAR __WSAFDIsSet( SOCKET, fd_set FAR * );

  #define FD_ISSET( fd, set )	__WSAFDIsSet((SOCKET)(fd), (fd_set FAR *)(set))

#else

  #error "Unsupported platform for the PDC Sockets"

#endif

/***************************************************************************
***************************************************************************/

typedef unsigned char TByte;
typedef unsigned long TIn_Addr;

#ifdef MLINEAR

  #if defined(__TURBOC__)
    #define PROLOG_FNO	TByte Fno;	\
			TByte _dummy_1;	\
			TByte _dummy_2;	\
			TByte _dummy_3
  #else
    #define PROLOG_FNO	TByte Fno
  #endif

#else

  #define PROLOG_FNO	TByte Fno

#endif	/* MLINEAR */

#ifndef NULL
  #define NULL	0
#endif

#define	List_FNO 1
#define	Nill_FNO 2

typedef struct _tVal4ListItem {
	PROLOG_FNO;
	unsigned long		Val_4;
	struct _tVal4ListItem * Next;
} TVal4ListItem;

typedef struct _tSockListItem {
	PROLOG_FNO;
	SOCKET		       Socket;
	struct _tSockListItem * Next;
} TSockListItem;

/***************************************************************************
***************************************************************************/

static TVal4ListItem * array_2_Val4List( const char **	Array,
					 const int	IsStrings ) {
  TVal4ListItem * val4List = (TVal4ListItem *) MEM_AllocGStack( sizeof( *val4List ) );

  val4List->Fno		= Nill_FNO;
  val4List->Val_4	= (unsigned long) -1;
  val4List->Next	= NULL;

  if ( Array != NULL ) {
    TVal4ListItem * pLastItem;
    unsigned	 i;

    for ( i = 0, pLastItem = NULL; ; i++ ) {
      const char * const pStr = (const char * const)(Array[i]);

      if ((pStr == NULL) || (*pStr == '\0')) {
	break;
      } else {
	TVal4ListItem * const pNewItem =
		(TVal4ListItem * const) MEM_AllocGStack( sizeof( *pNewItem ) );

	pNewItem->Fno = List_FNO;

	if ( IsStrings ) {
	  pNewItem->Val_4 = (unsigned long) MEM_SaveStringGStack( (char *) pStr );
	} else {
	  pNewItem->Val_4 = *((unsigned long *) pStr);
	}

	if ( pLastItem == NULL ) {
	  pNewItem->Next = val4List;
	  val4List	 = pNewItem;
	} else {
	  pNewItem->Next  = pLastItem->Next;
	  pLastItem->Next = pNewItem;
	}

	pLastItem = pNewItem;
      }
    }
  }

  return val4List;
}

/***************************************************************************
***************************************************************************/

TVal4ListItem * C_DECL c_MakeAListFromArray( const char ** Array ) {
  return array_2_Val4List( Array, 0 );
}

TVal4ListItem * C_DECL c_MakeSListFromArray( const char ** Array ) {
  return array_2_Val4List( Array, 1 );
}

void C_DECL c_MakeFdsFromSockList( const TSockListItem * const SocketsList,
				   int			       OldNFds,
				   const TByte **	       ppFdSet,
				   int * const		       pNewNFds ) {
  int             curNFds;
  TSockListItem * pItem;
  TByte * const	  pFdSet = (TByte * const) MEM_MakeBinaryGStack( sizeof( fd_set ) );

  FD_ZERO( pFdSet );

  for ( pItem = (TSockListItem * const) SocketsList, curNFds = OldNFds;
	(pItem != NULL) && (pItem->Fno == List_FNO);
	pItem = pItem->Next ) {
    FD_SET( pItem->Socket, pFdSet );

    if ( (int) pItem->Socket > curNFds ) {
      curNFds = (int) pItem->Socket;
    }
  }

  *pNewNFds = curNFds;
  *ppFdSet  = pFdSet;
}

TSockListItem * C_DECL c_MakeSockListFromFds( const TSockListItem * const SocketsList,
					      const TByte * const	  pFdSet ) {
  TSockListItem * pLastItem;
  TSockListItem * pOldList;
  TSockListItem * pNewList =
		(TSockListItem * const) MEM_AllocGStack( sizeof( *pNewList ) );

  pNewList->Fno    = Nill_FNO;
  pNewList->Socket = (SOCKET) -1;
  pNewList->Next   = NULL;

  for ( pOldList = (TSockListItem * const) SocketsList, pLastItem = NULL;
	(pOldList != NULL) && (pOldList->Fno == List_FNO);
	pOldList = pOldList->Next ) {
    if ( FD_ISSET( pOldList->Socket, pFdSet ) ) {
      TSockListItem * const pNewItem =
		(TSockListItem * const) MEM_AllocGStack( sizeof( *pNewItem ) );
      pNewItem->Fno	= List_FNO;
      pNewItem->Socket	= pOldList->Socket;

      if ( pLastItem == NULL ) {
	pNewItem->Next	= pNewList;
	pNewList	= pNewItem;
      } else {
	pNewItem->Next	= pLastItem->Next;
	pLastItem->Next	= pNewItem;
      }

      pLastItem = pNewItem;
    }
  }

  return pNewList;
}

/***************************************************************************
***************************************************************************/

		/*************************************/
		/* OS/2 asynchronous Sockets support */
		/*************************************/

#if defined( __IBMC__ ) || defined( __OS2__ )

// inserted by Dimitri
//#define _LOGREC_

#ifdef _LOGREC_		/* It can be defined in C Compiler's options */

  #include <stdarg.h>
  #include <stdio.h>

  static void __putLog__( const char * const Format, ... ) {
    #define LOGREC_NAME	"_psock_.log"
    
    FILE * const fp = fopen( LOGREC_NAME, "a" );
    if ( fp != NULL ) {
      va_list  argPtr;

      va_start( argPtr, Format );
      vfprintf( fp, Format, argPtr );
      va_end( argPtr );
      fclose( fp );
    }
  }

  #define LOG_1( m )		__putLog__( "%s\n", (m) )
  #define LOG_2( m, a )		__putLog__( (m), (a) )
  #define LOG_3( m, a1, a2 )	__putLog__( (m), (a1), (a2) )

#else

  #define LOG_1( m )
  #define LOG_2( m, a )
  #define LOG_3( m, a1, a2 )

#endif	/* _LOGREC_ */

/***************************************************************************
***************************************************************************/

typedef struct {
	unsigned long TV_Sec;
	unsigned long TV_USec;
} TSelectTimeVal;

typedef struct {
	fd_set		ReadFDS;
	fd_set		WriteFDS;
	fd_set		ExceptFDS;
	int		Width;
} TSelectVars;

typedef struct _tASocket {
	struct _tASocket * Next;
	volatile int	   IsActive;

	SOCKET		   Socket;
	HWND		   HWindow;
	unsigned	   Message;
	unsigned long	   Events;
	unsigned	   Flags;
} TASocket;

typedef struct {
	TID		  CtrlThreadID;
	volatile unsigned CtrlFlags;
	HEV		  StopHEV;
	HEV		  WaitHEV;

	volatile unsigned TotalActive;
	TASocket *	  ListHead;
	HMTX		  ListHMTX;
	TSelectTimeVal	  TimeVal;
} TControlBlock;

#define EMPTY_HEV		(HEV)(0)
#define EMPTY_HMTX		((HMTX) 0)
#define EMPTY_TID		((TID) -1)
#define EMPTY_SOCKET		((SOCKET) -1)
#define EMPTY_TIMEOUT		((unsigned long) SEM_INDEFINITE_WAIT)

/* Events */
#define FD_NONE			0x00000000
#define FD_READ			0x00000001
#define FD_WRITE		0x00000002
#define FD_OOB			0x00000004
#define FD_ACCEPT		0x00000008
#define FD_CONNECT		0x00000010
#define FD_CLOSE		0x00000020

/* Socket flags */
#define ENABLED_FD_READ_FLAG	0x00000001
#define ENABLED_FD_WRITE_FLAG	0x00000002
#define ENABLED_FD_OOB_FLAG	0x00000004
#define ENABLED_FD_ACCEPT_FLAG	0x00000008
#define ENABLED_FD_CONNECT_FLAG	0x00000010
#define ENABLED_FD_CLOSE_FLAG	0x00000020

#define IS_LISTEN_SOCKET_FLAG	0x00001000
#define IS_CLOSED_SOCKET_FLAG	0x00002000
#define IS_SHUT_R_SOCKET_FLAG	0x00004000
#define IS_SHUT_W_SOCKET_FLAG	0x00008000

#define IS_IN_CONNECTION_FLAG	0x40000000
#define IS_STREAM_SOCKET_FLAG	0x80000000

/* Control block flags */
#define CTRL_FLAG_INITIATED	0x00000001
#define CTRL_FLAG_TOSTOP	0x00000002
#define CTRL_FLAG_ISWAITING	0x00000004
/* ### #define CTRL_FLAG_LISTMODIFIED	0x00000008*/

#define CONTROL_THREAD_STACK	8192

#define SELECT_DELAY		1UL
#define WAIT_THREAD_END_DELAY	((unsigned long)(SELECT_DELAY * 2000))

/* Prolog run-time errors */
#define PDC_OS2_ERROR_BASE	7000

#define ERR_SCKDOUBLEINIT	11301
#define ERR_SCKNOTINIT		11302
#define ERR_SCKINVALIDPARMS	11303
#define ERR_SCKGENERAL		11304

#define API_ERROR( e )	RUN_Error( PDC_OS2_ERROR_BASE + (e) )

#define CHECK_INIT()	if (! (Current_CB.CtrlFlags & CTRL_FLAG_INITIATED)) { \
			  RUN_Error( ERR_SCKNOTINIT );			      \
			}

#define AWAKE_DAEMON()	if ( Current_CB.CtrlFlags & CTRL_FLAG_ISWAITING ) { \
			  LOG_1( "AWAKE_DAEMON()" );			    \
			  DosPostEventSem( Current_CB.WaitHEV );	    \
			}

#define BLOCK_MODE(s,m)	if ( __SetBlockMode( s, m ) != 0 ) {	\
			  LOG_1( "!!! BLOCK_MODE() FAIL" );	\
			  RUN_Error( ERR_SCKGENERAL );		\
			}

#define DISABLE_RD( f )	(f) &= (unsigned)(~(ENABLED_FD_READ_FLAG	| \
					    ENABLED_FD_OOB_FLAG		| \
					    ENABLED_FD_ACCEPT_FLAG))

#define DISABLE_WR( f )	(f) &= (unsigned)(~(ENABLED_FD_WRITE_FLAG	| \
					    ENABLED_FD_CONNECT_FLAG))


#define DISABLE_ALL(f)	{ DISABLE_RD( (f) );				\
			  DISABLE_WR( (f) );				\
			  (f) &= (unsigned)(~ENABLED_FD_CLOSE_FLAG);	\
			}

/*###
#define CLOSE_ENABLE(f)	(((f) & ENABLED_FD_CLOSE_FLAG)	&&	\
			 ((f) & IS_STREAM_SOCKET_FLAG)	&&	\
			 ((f) & IS_IN_CONNECTION_FLAG))
*/
/*###
#define CLOSE_ENABLE(f)	(((f) & ENABLED_FD_CLOSE_FLAG)	&&	\
			 ((f) & IS_STREAM_SOCKET_FLAG))
*/

#define CLOSE_ENABLE(f)	(((f) & ENABLED_FD_CLOSE_FLAG)		&&	\
			 (! ((f) & IS_CLOSED_SOCKET_FLAG))	&&	\
			 ((f) & IS_STREAM_SOCKET_FLAG)		&&	\
			 (! (((f) & IS_SHUT_R_SOCKET_FLAG)	&&	\
			     ((f) & IS_SHUT_W_SOCKET_FLAG))))

#define SOCK_MEMALLOC( s )	MEM_AllocHeap( (s) )
#define SOCK_MEMFREE( p, s )	MEM_ReleaseHeap( (p), (s) )

typedef void C_DECL _tNotifyFNS( const HWND	     HWindow,
				 const unsigned	     Message,
				 const SOCKET	     Socket,
				 const unsigned long LParam );
typedef _tNotifyFNS * TNotifyFNS;

#define EMPTY_USER_FNS	(TNotifyFNS) NULL

/***************************************************************************
***************************************************************************/

#define INVALID_SOCKET		((SOCKET)(~0))
#define SOCKET_ERROR		(-1)
#define SOCBASEERR		10000
#define SOL_SOCKET		0xFFFF

#define IOC( x, y )		((x << 8) | y)

extern int APIENTRY BSDSELECT( int		  nFDS,
			       fd_set		* readFDS,
			       fd_set		* writeFDS,
			       fd_set		* exceptFDS,
			       TSelectTimeVal	* timeOut );

extern int APIENTRY GETSOCKOPT( const SOCKET Socket,
				const int    Level,
				const int    OptName,
				char * const OptVal,
				int * const  OptLen );

extern int APIENTRY IOCTL( const SOCKET Socket,
			   const int    Command,
			   char * const pArgument,
			   const int	ArgSize );

extern int APIENTRY RECV( const SOCKET Socket,
			  char * const Buffer,
			  const int    BuffLen,
			  const int    Flags );

extern int APIENTRY SOCK_ERRNO( void );

/***************************************************************************
***************************************************************************/

static TControlBlock Current_CB = { EMPTY_TID,
				    0,
				    EMPTY_HEV,
				    EMPTY_HEV,
				    0,
				    NULL,
				    EMPTY_HMTX };

static TNotifyFNS User_NotifyFNS = EMPTY_USER_FNS;

/***************************************************************************
***************************************************************************/

static int __fdIsSet( const SOCKET Socket, const void * const pFdSet ) {
  const fd_set * const p = (const fd_set * const) pFdSet;
  return (p->fds_bits[Socket/NFDBITS] & ((unsigned)(1 << (Socket % NFDBITS))));
}

static int __Is_OOB_Inline( const SOCKET Socket ) {
  #define SO_OOBINLINE	0x0100

  int oobInLineVal = 0;
  int oobInLineLen = sizeof( oobInLineVal );

  if ( GETSOCKOPT( Socket,
		   SOL_SOCKET,
		   SO_OOBINLINE,
		   (char *) &oobInLineVal,
		   (int *) &oobInLineLen ) == 0 ) {
    return oobInLineVal;
  } else {
    LOG_2( "!!! __Is_OOB_Inline() FAILED: Socket = %d\n", Socket );
    return 0;
  }
}

static int __Is_StreamSocket( const SOCKET Socket ) {
  #define SOCK_STREAM	1
  #define SO_TYPE	0x1008

  int soTypeVal = 0;
  int soTypeLen = sizeof( soTypeVal );

  if ( GETSOCKOPT( Socket,
		   SOL_SOCKET,
		   SO_TYPE,
		   (char *) &soTypeVal,
		   (int *) &soTypeLen ) == 0 ) {
    return (int)(soTypeVal == SOCK_STREAM);
  } else {
    LOG_2( "!!! __Is_StreamSocket() FAILED: Socket = %d\n", Socket );
    return 0;
  }
}

static int __Is_UnReadDataPresent( const TASocket * const pSock ) {
  #define FIONREAD_CMD IOC( 'f', 127 )

  unsigned long unReadDataLen = 0UL;

  if ( IOCTL( pSock->Socket,
	      FIONREAD_CMD,
	      (char * const) &unReadDataLen,
	      sizeof( unReadDataLen ) ) == 0 ) {
    return (int)(unReadDataLen != 0UL);
  }

  return 0;
}

static int __SetBlockMode( const SOCKET Socket, const int ToBlock ) {
  #define FIONBIO_CMD IOC( 'f', 126 )
  const unsigned long blockMode = (ToBlock) ? 0UL : 1UL;
  return IOCTL( Socket,
		FIONBIO_CMD,
		(char * const) &blockMode,
		sizeof( blockMode ) );
}

/***************************************************************************
***************************************************************************/

static TASocket * __find_ASocket( const SOCKET Socket ) {
  TASocket * pSock;

  for ( pSock = Current_CB.ListHead; pSock != NULL; pSock = pSock->Next ) {
    if ((pSock->Socket == Socket) && pSock->IsActive) {
      return pSock;
    }
  }

  return NULL;
}

static unsigned __make_SocketFlags( const SOCKET	Socket,
				    const unsigned long	Events,
				    const unsigned	IsOrgSocket,
				    const unsigned	OldFlags ) {
  unsigned flags = 0;

  if ( __Is_StreamSocket( Socket ) ) {
    flags |= IS_STREAM_SOCKET_FLAG;
  }

  if ( IsOrgSocket ) {
    if ( OldFlags != 0 ) {
      if ( OldFlags & IS_IN_CONNECTION_FLAG ) {
	flags |= IS_IN_CONNECTION_FLAG;
      }

      if ( OldFlags & IS_LISTEN_SOCKET_FLAG ) {
	flags |= IS_LISTEN_SOCKET_FLAG;
      }

      if ( OldFlags & IS_SHUT_R_SOCKET_FLAG ) {
	flags |= IS_SHUT_R_SOCKET_FLAG;
      }

      if ( OldFlags & IS_SHUT_W_SOCKET_FLAG ) {
	flags |= IS_SHUT_W_SOCKET_FLAG;
      }
    }
  } else {
    flags |= IS_IN_CONNECTION_FLAG;
  }

  if ( Events & FD_READ ) {
    flags |= ENABLED_FD_READ_FLAG;
  }

  if ( Events & FD_WRITE ) {
    flags |= ENABLED_FD_WRITE_FLAG;
  }

  if ( Events & FD_OOB ) {
    flags |= ENABLED_FD_OOB_FLAG;
  }

  if (IsOrgSocket && (Events & FD_ACCEPT)) {
    flags |= ENABLED_FD_ACCEPT_FLAG;
  }

  if ((Events & FD_CLOSE) && (flags & IS_STREAM_SOCKET_FLAG)) {
    flags |= ENABLED_FD_CLOSE_FLAG;
  }

  return flags;
}

static void __new_ASocket( const SOCKET		Socket,
			   const HWND		HWindow,
			   const unsigned	Message,
			   const unsigned long	Events,
			   const unsigned	IsOrgSocket ) {
  TASocket * pSock;
  int	     isNew;

  for ( pSock = Current_CB.ListHead; pSock != NULL; pSock = pSock->Next ) {
    if ( ! pSock->IsActive ) {
      break;
    }
  }

  if ( pSock == NULL ) {
    pSock = SOCK_MEMALLOC( sizeof( *pSock ) );
    isNew = 1;
  } else {
    isNew = 0;
  }

  pSock->Socket	 = Socket;
  pSock->HWindow = HWindow;
  pSock->Message = Message;
  pSock->Events	 = Events;
  pSock->Flags	 = __make_SocketFlags( Socket, Events, IsOrgSocket, 0 );

  { const APIRET apiRC = DosRequestMutexSem( Current_CB.ListHMTX,
					     SEM_INDEFINITE_WAIT );
    if ( apiRC == 0 ) {
      if ( isNew ) {
	pSock->Next	    = Current_CB.ListHead;
	Current_CB.ListHead = pSock;
      }

      /* ### Current_CB.CtrlFlags |= CTRL_FLAG_LISTMODIFIED;*/

      pSock->IsActive = 1;
      Current_CB.TotalActive++;

      DosReleaseMutexSem( Current_CB.ListHMTX );
    } else {
      if ( isNew ) {
	SOCK_MEMFREE( pSock, sizeof( *pSock ) );
      }

      API_ERROR( apiRC );
    }
  }
}

static void __free_ASocket( TASocket * const pSock ) {
  const APIRET apiRC = DosRequestMutexSem( Current_CB.ListHMTX,
					   SEM_INDEFINITE_WAIT );
  if ( apiRC == 0 ) {
    Current_CB.TotalActive--;
    pSock->IsActive = 0;
    pSock->Socket   = EMPTY_SOCKET;

    /* ### Current_CB.CtrlFlags |= CTRL_FLAG_LISTMODIFIED;*/

    DosReleaseMutexSem( Current_CB.ListHMTX );
  } else {
    API_ERROR( apiRC );
  }
}

/***************************************************************************
***************************************************************************/

#ifdef _LOGREC_

static char * __getEventImage( const unsigned Event ) {
  switch ( Event ) {
    case FD_READ	:	return "FD_READ";
    case FD_WRITE	:	return "FD_WRITE";
    case FD_OOB		:	return "FD_OOB";
    case FD_ACCEPT	:	return "FD_ACCEPT";
    case FD_CONNECT	:	return "FD_CONNECT";
    case FD_CLOSE	:	return "FD_CLOSE";
    default		:	return "FD_?????";
  }
}

#endif	/* _LOGREC_ */

static void __asock_Notify( const TASocket * const pSock,
			    const unsigned	   Event,
			    const unsigned	   ErrCode ) {
  const unsigned long mParam2 = MAKEULONG( Event, ErrCode );

  #ifdef _LOGREC_
    __putLog__( "+++ Event = %s (error = %u), socket = %d\n",
		__getEventImage( Event ),
		ErrCode,
		pSock->Socket );
  #endif

  if ( User_NotifyFNS == EMPTY_USER_FNS ) {
    WinPostMsg( pSock->HWindow,
		pSock->Message,
		MPFROMLONG( pSock->Socket ),
		MPFROMLONG( mParam2 ) );
  } else {
    User_NotifyFNS( pSock->HWindow, pSock->Message, pSock->Socket, mParam2 );
  }
}

static void __asock_Close( TASocket * const pSock ) {
  DISABLE_ALL( pSock->Flags );
  pSock->Flags |= IS_CLOSED_SOCKET_FLAG;

  /* ### Deactivate? Under mutex? Or inside __cntrl_PreSelect()? */
}

static void __asock_Exception( TASocket * const pSock, const int ErrCode ) {
  /* 1. Test for connect() failure */
  if ( pSock->Flags & ENABLED_FD_CONNECT_FLAG ) {
    #define SOCECONNREFUSED (SOCBASEERR + 61)	/* ### ??? */

    __asock_Close( pSock );

    if ( pSock->Flags & IS_STREAM_SOCKET_FLAG ) {
      __asock_Notify( pSock, FD_CONNECT, SOCECONNREFUSED );
    } else {
      __asock_Notify( pSock, FD_WRITE, SOCECONNREFUSED );
    }

    return;
  }

  /* 2. Test for no-inline OOB presence */
  if ( pSock->Flags & ENABLED_FD_OOB_FLAG ) {
    if ((! __Is_OOB_Inline( pSock->Socket ))	&&
	__Is_UnReadDataPresent( pSock )) {
      pSock->Flags &= (unsigned)(~ENABLED_FD_OOB_FLAG);
      __asock_Notify( pSock, FD_OOB, ErrCode );
      return;
    }
  }

  /* 3. Test for closing stream socket */
  if ( CLOSE_ENABLE( pSock->Flags ) ) {
    __asock_Close( pSock );
    __asock_Notify( pSock, FD_CLOSE, ErrCode );
  }
}

static void __asock_Read( TASocket * const pSock, const int ErrCode ) {
  /* 1. Test for closing stream socket */
  if ( CLOSE_ENABLE( pSock->Flags ) ) {
    #define SOCECONNRESET (SOCBASEERR + 54)
    #define MSG_PEEK	  2

    char testData;

    switch ( RECV( pSock->Socket, &testData, sizeof( testData ), MSG_PEEK ) ) {
      case 0:
	/* Virtual circuit was closed gracefully */
	__asock_Close( pSock );
	__asock_Notify( pSock, FD_CLOSE, 0 );
	return;

      case SOCKET_ERROR:
	if ( SOCK_ERRNO() == SOCECONNRESET ) {
	  __asock_Close( pSock );
	  __asock_Notify( pSock, FD_CLOSE, SOCECONNRESET );
	  return;
	}
	break;

      default:
	break;
    }
  }

  /* 2. Test for accept */
  if ( pSock->Flags & ENABLED_FD_ACCEPT_FLAG ) {
    DISABLE_ALL( pSock->Flags );

    /* Notify: FD_ACCEPT for Stream, FD_READ - otherwize */
    if ( pSock->Flags & IS_STREAM_SOCKET_FLAG ) {
      __asock_Notify( pSock, FD_ACCEPT, ErrCode );
    } else {
      if ( pSock->Flags & ENABLED_FD_READ_FLAG ) {
	pSock->Flags &= (unsigned)(~ENABLED_FD_READ_FLAG);
      }
      __asock_Notify( pSock, FD_READ, ErrCode );
    }

    return;
  }

  /* 3. Test for inline OOB presence */
  if ((pSock->Flags & ENABLED_FD_OOB_FLAG) &&
      __Is_OOB_Inline( pSock->Socket )) {
    #define SIOCATMARK_CMD IOC( 's', 7 )
    int noUnReadOOB = 0;

    if ( IOCTL( pSock->Socket,
		SIOCATMARK_CMD,
		(char * const) &noUnReadOOB,
		sizeof( noUnReadOOB ) ) == 0 ) {
      if ( ! noUnReadOOB ) {
	/* Unread inline OOB are present */
	pSock->Flags &= (unsigned)(~ENABLED_FD_OOB_FLAG);
	__asock_Notify( pSock, FD_OOB, ErrCode );
	return;
      }
    }
  }

  /* 4. Test for usual unread data */
  if ((pSock->Flags & ENABLED_FD_READ_FLAG)	&&
      __Is_UnReadDataPresent( pSock )) {
    DISABLE_RD(pSock->Flags);  // Dimitri
//    pSock->Flags &= (unsigned)(~ENABLED_FD_READ_FLAG);
    __asock_Notify( pSock, FD_READ, ErrCode );
  }
}

static void __asock_Write( TASocket * const pSock, const int ErrCode ) {
  /* 1. Test for successfull connect() */
  if ( pSock->Flags & ENABLED_FD_CONNECT_FLAG ) {
    pSock->Flags &= (unsigned)(~ENABLED_FD_CONNECT_FLAG);
    pSock->Flags &= (unsigned)(~ENABLED_FD_ACCEPT_FLAG);
    pSock->Flags |= IS_IN_CONNECTION_FLAG;

    __SetBlockMode( pSock->Socket, 0 );	/* ### check rc */

    /* Notify: FD_CONNECT + FD_WRITE (Stream), FD_WRITE (otherwise) */
    if ( pSock->Flags & IS_STREAM_SOCKET_FLAG ) {
      __asock_Notify( pSock, FD_CONNECT, ErrCode );
      /* Fall through to (2) */
    } else if (! (pSock->Flags & ENABLED_FD_WRITE_FLAG)) { /* ### */
      /* ### Must send FD_WRITE in any case */
      __asock_Notify( pSock, FD_WRITE, ErrCode );
      return;
    }
  }

  /* 2. Test for writing ability */
  if ( pSock->Flags & ENABLED_FD_WRITE_FLAG ) {
    pSock->Flags &= (unsigned)(~ENABLED_FD_WRITE_FLAG);
    __asock_Notify( pSock, FD_WRITE, ErrCode );
  } 
}

/* Returns 0 if errors were skipped, otherwise - 1 */
static int __cntrl_Select( TControlBlock * const pCB,
			   TSelectVars	 * const pSVars,
			   const int		 NothingOnError ) {
  fd_set	   readFDS;
  fd_set	   writeFDS;
  fd_set	   exceptFDS;
  int		   lastError = 0;
  TSelectTimeVal * pTimeVal  = &(pCB->TimeVal);

  if ((pTimeVal->TV_Sec == EMPTY_TIMEOUT)	&&
      (pTimeVal->TV_USec == EMPTY_TIMEOUT)) {
    pTimeVal = NULL;
  }

  MEM_MovMem( &(pSVars->ReadFDS), &(readFDS), sizeof( readFDS ) );
  MEM_MovMem( &(pSVars->WriteFDS), &(writeFDS), sizeof( writeFDS ) );
  MEM_MovMem( &(pSVars->ExceptFDS), &(exceptFDS), sizeof( exceptFDS ) );

  switch ( BSDSELECT( pSVars->Width,
		      &readFDS,
		      &writeFDS,
		      &exceptFDS,
		      pTimeVal ) ) {
    case 0: {		/* Time-out detected */
      LOG_1( "__BSDSelect Timed-out" );
      break;
      }
    case SOCKET_ERROR:	/* Select failed     */
      #define SOCENOTSOCK (SOCBASEERR + 38)
      lastError = SOCK_ERRNO();
      LOG_2( "__cntrl_Select():  FAILED with %d\n", lastError );
      if ( lastError == SOCENOTSOCK ) {
	lastError = 0;
	/* ### pCB->CtrlFlags |= CTRL_FLAG_LISTMODIFIED;*/
	if ( NothingOnError ) {
	  return 0;	/* Cause check for fd_sets */
	}
      }
      /* ### What should we do with this error ? */
      /* ### Skip ? Now drop to the default	 */

    default:		/* Some events came */
      if ( DosRequestMutexSem( pCB->ListHMTX, SEM_INDEFINITE_WAIT ) == 0 ) {
	TASocket * pSock;

	for ( pSock = pCB->ListHead; pSock != NULL; pSock = pSock->Next ) {
	  if (pSock->IsActive && (! (pSock->Flags & IS_CLOSED_SOCKET_FLAG))) {
	    if ( FD_ISSET( pSock->Socket, &(exceptFDS) ) ) {
              LOG_2( "Socket = %d in exceptsFDSet\n", pSock->Socket );
	      __asock_Exception( pSock, lastError );
	    }

	    if ( FD_ISSET( pSock->Socket, &(readFDS) ) ) {
              LOG_2( "Socket = %d in readFDSet\n", pSock->Socket );
	      __asock_Read( pSock, lastError );
	    }

	    if ( FD_ISSET( pSock->Socket, &(writeFDS) ) ) {
              LOG_2( "Socket = %d in writeFDSet\n", pSock->Socket );
	      __asock_Write( pSock, lastError );
	    }
	  }
	}

	DosReleaseMutexSem( pCB->ListHMTX );
      } else {
	/* ### What should we do with the error ??? */
	LOG_1( "!!! __cntrl_Select(): LIST ACCESS FAILED\n" );
      }
      break;
  }

  return 1;
}

static void __make_FdRead( const TASocket * const pSock,
			   TSelectVars    * const pSVars ) {
// CLOSE_ENABLE( pSock->Flags )			|| dimitri

  int ok = (int)((pSock->Flags & ENABLED_FD_ACCEPT_FLAG)	||
		 (pSock->Flags & ENABLED_FD_READ_FLAG));
  if ((! ok) && (pSock->Flags & ENABLED_FD_OOB_FLAG)) {
    ok = __Is_OOB_Inline( pSock->Socket );
  }

  if ( ok ) {
    FD_SET( pSock->Socket, &(pSVars->ReadFDS) );
    if ( pSock->Socket > pSVars->Width ) {
      pSVars->Width = (int) pSock->Socket;
    }
  }
}

static void __make_FdWrite( const TASocket * const pSock,
			    TSelectVars    * const pSVars ) {
  int ok = (int)((pSock->Flags & ENABLED_FD_CONNECT_FLAG)	&&
		 (! (pSock->Flags & IS_IN_CONNECTION_FLAG)));
  if ( ! ok ) {
    ok = (int)(pSock->Flags & ENABLED_FD_WRITE_FLAG);
  }

  if ( ok ) {
    FD_SET( pSock->Socket, &(pSVars->WriteFDS) );
    if ( pSock->Socket > pSVars->Width ) {
      pSVars->Width = (int) pSock->Socket;
    }
  }
}

static void __make_FdExcept( const TASocket * const pSock,
			      TSelectVars    * const pSVars ) {
  int ok = (int)((pSock->Flags & ENABLED_FD_CONNECT_FLAG)	&&
		 (! (pSock->Flags & IS_IN_CONNECTION_FLAG)));
  if ( ! ok ) {
    ok = (int) CLOSE_ENABLE( pSock->Flags );
  }

  if ((! ok) && (pSock->Flags & ENABLED_FD_OOB_FLAG)) {
    ok = (int)(! __Is_OOB_Inline( pSock->Socket ));
  }

  if ( ok ) {
    FD_SET( pSock->Socket, &(pSVars->ExceptFDS) );
    if ( pSock->Socket > pSVars->Width ) {
      pSVars->Width = (int) pSock->Socket;
    }
  }
}

static int __cntrl_PreSelect( TControlBlock * const pCB,
			      TSelectVars   * const pSVars ) {
  pSVars->Width = 0;

  FD_ZERO( &(pSVars->ReadFDS) );
  FD_ZERO( &(pSVars->WriteFDS) );
  FD_ZERO( &(pSVars->ExceptFDS) );

  if ( DosRequestMutexSem( pCB->ListHMTX, SEM_INDEFINITE_WAIT ) == 0 ) {
    TASocket * pSock;

    for ( pSock = pCB->ListHead; pSock != NULL; pSock = pSock->Next ) {
      if ( pSock->IsActive ) {
	if ( pSock->Flags & IS_CLOSED_SOCKET_FLAG ) {
	  pSock->IsActive = 0;
	  pSock->Flags	  = 0;
	  pSock->Socket	  = EMPTY_SOCKET;

	  pCB->TotalActive--;
	} else {
	  __make_FdRead( pSock, pSVars );
	  __make_FdWrite( pSock, pSVars );
	  __make_FdExcept( pSock, pSVars );
	}
      }
    }

    DosReleaseMutexSem( pCB->ListHMTX );

    LOG_2( "__cntrl_PreSelect(): Real width = %u\n", (unsigned) pSVars->Width );

    if ( pSVars->Width != 0 ) {
      pSVars->Width++;
    }
  } else {
    /* ### What should we do with the error ??? */
    LOG_1( "!!! __cntrl_PreSelect(): LIST ACCESS FAILED\n" );
  }

  return pSVars->Width;
}

static int __cntrl_WaitCheck( TControlBlock * const pCB ) {
  while ( pCB->TotalActive == 0 ) {
    ULONG ulPostCnt;

    DosResetEventSem( pCB->WaitHEV, &ulPostCnt );

    pCB->CtrlFlags |= CTRL_FLAG_ISWAITING;

    LOG_1( "__cntrl_WaitCheck(): before wait loop" );
    while ( DosWaitEventSem( pCB->WaitHEV,
			     SEM_INDEFINITE_WAIT ) == ERROR_INTERRUPT ) {}
    LOG_2( "__cntrl_WaitCheck(): after wait loop, actives = %u\n", pCB->TotalActive );

    pCB->CtrlFlags &= (unsigned)(~CTRL_FLAG_ISWAITING);

    if ( pCB->CtrlFlags & CTRL_FLAG_TOSTOP ) {
      return 1;
    }
  }

  return 0;
}

static void APIENTRY __ControlThread( const ULONG AddressCB ) {
  TSelectVars   	sVars;
  int			skipErr	= 1;
  TControlBlock * const pCB	= (TControlBlock * const) AddressCB;

  LOG_1( "__ControlThread(): started" );
  SOCK_SETMEM0( &sVars, sizeof( sVars ) );

  do {
    if ( __cntrl_WaitCheck( pCB ) ) {
      LOG_1( "__ControlThread(): interrupted, exit from loop" );
      break;
    }

    if ( __cntrl_PreSelect( pCB, &sVars ) ) {
      skipErr = __cntrl_Select( pCB, &sVars, skipErr );
    } else {
      sleep(100); // Dimitri
      LOG_1("Sleep ....");
      skipErr = 1;
    }
  } while ( ! (pCB->CtrlFlags & CTRL_FLAG_TOSTOP) );

  DosEnterCritSec();

  pCB->CtrlThreadID = EMPTY_TID;
  if ( pCB->CtrlFlags & CTRL_FLAG_TOSTOP ) {
    LOG_1( "__ControlThread(): acknowledge stop signal" );	/* ### */
    pCB->CtrlFlags &= (unsigned)(~CTRL_FLAG_TOSTOP);
    DosPostEventSem( pCB->StopHEV );
  }

  DosExitCritSec();
  LOG_1( "__ControlThread(): stoped" );
  DosExit( 0, 0 );
}

/***************************************************************************
***************************************************************************/

static void __close_CB( void ) {
  if ((! (Current_CB.CtrlFlags & CTRL_FLAG_TOSTOP))	&&
      (Current_CB.CtrlThreadID != EMPTY_TID)		&&
      (Current_CB.StopHEV != EMPTY_HEV)) {
    ULONG ulPostCnt;

    LOG_1( "__close_CB(): will send signal to thread" );
    DosResetEventSem( Current_CB.StopHEV, &ulPostCnt );

    Current_CB.CtrlFlags |= CTRL_FLAG_TOSTOP;
    AWAKE_DAEMON();
    DosWaitEventSem( Current_CB.StopHEV, WAIT_THREAD_END_DELAY );
    Current_CB.CtrlFlags &= (unsigned)(~CTRL_FLAG_TOSTOP);
  }

  if ( Current_CB.CtrlThreadID != EMPTY_TID ) {
    LOG_1( "__close_CB(): thread still active, KILL it" );
    DosKillThread( Current_CB.CtrlThreadID );
    Current_CB.CtrlThreadID = EMPTY_TID;
  }

  if ( Current_CB.WaitHEV != EMPTY_HEV ) {
    DosCloseEventSem( Current_CB.WaitHEV );
    Current_CB.WaitHEV = EMPTY_HEV;
  }

  if ( Current_CB.StopHEV != EMPTY_HEV ) {
    DosCloseEventSem( Current_CB.StopHEV );
    Current_CB.StopHEV = EMPTY_HEV;
  }

  if ( Current_CB.ListHMTX != EMPTY_HMTX ) {
    DosCloseMutexSem( Current_CB.ListHMTX );
    Current_CB.ListHMTX = EMPTY_HMTX;
  }

  Current_CB.CtrlFlags	 = 0;
  Current_CB.TotalActive = 0;

  { const unsigned savedSP = GETSP;

    if ( RUN_StackTrap() ) {
      /* Nothing on error */
    } else {
      TASocket * P;
      TASocket * Q;

      for ( P = Current_CB.ListHead; P != NULL; P = Q ) {
	Q = P->Next;
	SOCK_MEMFREE( P, sizeof( *P ) );
      }

      RUN_RemoveTrap( savedSP );
    }

    Current_CB.ListHead = NULL;
  }
}

static APIRET __open_CB( void ) {
  APIRET apiRC;

  Current_CB.CtrlThreadID    = EMPTY_TID;
  Current_CB.CtrlFlags	     = 0;
  Current_CB.StopHEV	     = EMPTY_HEV;
  Current_CB.WaitHEV	     = EMPTY_HEV;
  Current_CB.TotalActive     = 0;
  Current_CB.ListHead	     = NULL;
  Current_CB.ListHMTX	     = EMPTY_HMTX;
  Current_CB.TimeVal.TV_Sec  = SELECT_DELAY;
  Current_CB.TimeVal.TV_USec = 0UL;

  apiRC = DosCreateEventSem( NULL, &(Current_CB.StopHEV), 0UL, 0 );
  if ( apiRC != 0 ) {
    return apiRC;
  }

  apiRC = DosCreateEventSem( NULL, &(Current_CB.WaitHEV), 0UL, 0 );
  if ( apiRC != 0 ) {
    return apiRC;
  }

  apiRC = DosCreateMutexSem( NULL, &(Current_CB.ListHMTX), 0UL, 0 );
  if ( apiRC != 0 ) {
    return apiRC;
  }

  apiRC = DosCreateThread( &(Current_CB.CtrlThreadID),
			   (PFNTHREAD) __ControlThread,
			   (ULONG)(&Current_CB),
			   0,
			   CONTROL_THREAD_STACK );
  if ( apiRC != 0 ) {
    Current_CB.CtrlThreadID = EMPTY_TID;
    return apiRC;
  }

  Current_CB.CtrlFlags |= CTRL_FLAG_INITIATED;

  return 0;
}

/***************************************************************************
***************************************************************************/

void C_DECL c_Os2_AsyncSelect( const SOCKET	   Socket,
			       const HWND	   HWindow,
			       const unsigned	   Message,
			       const unsigned long Events ) {
  TASocket * pSock;

  CHECK_INIT();
  LOG_3( ">>> c_Os2_AsyncSelect: Socket = %d, Events = %04X\n", Socket, Events );

  pSock = __find_ASocket( Socket );
  if ( pSock == NULL ) {
    /* Activate new asynchronous socket */
    if ( Events == FD_NONE ) {
      RUN_Error( ERR_SCKINVALIDPARMS );
    }

    BLOCK_MODE( Socket, 0 );
    __new_ASocket( Socket, HWindow, Message, Events, 1 );
    AWAKE_DAEMON();
  } else if ( Events == FD_NONE ) {
    /* Disable all events for the asynchronous socket and deactivate it */
    __asock_Close( pSock );
    __free_ASocket( pSock );
  } else if ((pSock->Flags & IS_CLOSED_SOCKET_FLAG)	||
	     ((pSock->Flags & IS_SHUT_R_SOCKET_FLAG)	&&
	      (pSock->Flags & IS_SHUT_W_SOCKET_FLAG))) {
    /* ### ??? Closed or gracefully shutdown => nothing */
  } else {
    /* Modify parameters for active asynchronous socket */
    pSock->Events  = Events;
    pSock->HWindow = HWindow;
    pSock->Message = Message;
    pSock->Flags   = __make_SocketFlags( Socket, Events, 1, pSock->Flags );

    /* ### Current_CB.CtrlFlags |= CTRL_FLAG_LISTMODIFIED;*/
  }
}

void C_DECL c_Os2_CheckAcception( const SOCKET ListenSocket,
				  const SOCKET AcceptedSocket ) {
  TASocket * pSock_L;

  CHECK_INIT();
  pSock_L = __find_ASocket( ListenSocket );

  if ((pSock_L == NULL)				||
      (pSock_L->Flags & IS_CLOSED_SOCKET_FLAG)	||
      (pSock_L->Flags & IS_SHUT_R_SOCKET_FLAG)) {
    return;
  }

  if ((pSock_L->Flags & IS_STREAM_SOCKET_FLAG) &&
      (pSock_L->Events & FD_ACCEPT)) {
    LOG_3( ">>> c_Os2_CheckAcception: Listened = %d, Accepted = %d\n",
	   ListenSocket,
	   AcceptedSocket );
    if ( AcceptedSocket != INVALID_SOCKET ) {
      BLOCK_MODE( AcceptedSocket, 0 );
      __new_ASocket( AcceptedSocket,
		     pSock_L->HWindow,
		     pSock_L->Message,
		     pSock_L->Events,
		     0 );
      AWAKE_DAEMON();
    }

    pSock_L->Flags |= ENABLED_FD_ACCEPT_FLAG;
  } else {
    LOG_3( "!!! c_Os2_CheckAcception FAILED: Listened = %d, Accepted = %d\n",
	   ListenSocket,
	   AcceptedSocket );
    RUN_Error( ERR_SCKINVALIDPARMS );	/* ### ??? */
  }
}

void C_DECL c_Os2_RegClose( const SOCKET Socket ) {
  TASocket * pSock;

  CHECK_INIT();
  pSock = __find_ASocket( Socket );

  if ( pSock != NULL ) {
    /* Disable all events for the asynchronous socket and deactivate it */
    LOG_2( ">>> c_Os2_RegClose for Socket = %d\n", pSock->Socket );
    __asock_Close( pSock );
    __free_ASocket( pSock );
  }
}

void C_DECL c_Os2_RegConnect( const SOCKET Socket ) {
  TASocket * pSock;

  CHECK_INIT();
  pSock = __find_ASocket( Socket );

  if ((pSock == NULL)				||
      (pSock->Flags & IS_CLOSED_SOCKET_FLAG)	||
      (pSock->Flags & IS_SHUT_W_SOCKET_FLAG)) {
    return;
  }

  if ((pSock->Events & FD_CONNECT) &&
      (! (pSock->Flags & IS_LISTEN_SOCKET_FLAG))) {
    /* Note: 1. stream not-connected socket => allow FD_CONNECT + FD_WRITE */
    /*	     2. connected stream socket	    => allow FD_WRITE		   */
    /*	     3. not stream socket	    => allow FD_WRITE		   */
    LOG_2( ">>> c_Os2_RegConnect(): Socket = %d\n", pSock->Socket );

    if ((pSock->Flags & IS_STREAM_SOCKET_FLAG)	&&
	(! (pSock->Flags & IS_IN_CONNECTION_FLAG))) {
      BLOCK_MODE( Socket, 1 );
/*      pSock->Flags |= ENABLED_FD_CONNECT_FLAG;*/
    }

/*    if ( pSock->Events & FD_WRITE ) {
      pSock->Flags |= ENABLED_FD_WRITE_FLAG;
    }*/
    /*###
    BLOCK_MODE( Socket, 1 );
    pSock->Flags |= ENABLED_FD_CONNECT_FLAG;
    pSock->Flags &= (unsigned)(~ENABLED_FD_ACCEPT_FLAG);	/ *###* /
    */
  } else {
    LOG_2( "!!! c_Os2_RegConnect() FAILED: Socket = %d\n", pSock->Socket );
    RUN_Error( ERR_SCKINVALIDPARMS );	/* ### ??? */
  }
}

void C_DECL c_Os2_CheckConnect( const SOCKET Socket, const int RetCode ) {

  TASocket * pSock;

  CHECK_INIT();
  pSock = __find_ASocket( Socket );

  if ((pSock == NULL)				||
      (pSock->Flags & IS_CLOSED_SOCKET_FLAG)	||
      (pSock->Flags & IS_SHUT_W_SOCKET_FLAG)) {
    return;
  }

  if ((pSock->Events & FD_CONNECT) &&
      (! (pSock->Flags & IS_LISTEN_SOCKET_FLAG))) {
    /* Note: 1. stream not-connected socket => allow FD_CONNECT + FD_WRITE */
    /*	     2. connected stream socket	    => allow FD_WRITE		   */
    /*	     3. not stream socket	    => allow FD_WRITE		   */
    LOG_2( ">>> c_Os2_CheckConnect(): Socket = %d\n", pSock->Socket );
    
    if ( !RetCode ){
      if ((pSock->Flags & IS_STREAM_SOCKET_FLAG)	&&
         (! (pSock->Flags & IS_IN_CONNECTION_FLAG))) {
        BLOCK_MODE( Socket, 1 );
        pSock->Flags |= ENABLED_FD_CONNECT_FLAG;
      }
      if ( pSock->Events & FD_WRITE ) {
         pSock->Flags |= ENABLED_FD_WRITE_FLAG;
      }
      __asock_Write( pSock, RetCode );

    }else{

      __asock_Notify( pSock, FD_CONNECT, SOCK_ERRNO() );
    }

  } else {
    LOG_2( "!!! c_Os2_CheckConnect() FAILED: Socket = %d\n", pSock->Socket );
    RUN_Error( ERR_SCKINVALIDPARMS );	/* ### ??? */
  }
}

void C_DECL c_Os2_RegListen( const SOCKET Socket ) {
  TASocket * pSock;

  CHECK_INIT();
  pSock = __find_ASocket( Socket );

  if ((pSock == NULL)				||
      (pSock->Flags & IS_CLOSED_SOCKET_FLAG)	||
      (pSock->Flags & IS_SHUT_R_SOCKET_FLAG)) {
    return;
  }

  if ((pSock->Flags & IS_STREAM_SOCKET_FLAG)	&&
      (pSock->Events & FD_ACCEPT)               &&
      (! (pSock->Flags & IS_LISTEN_SOCKET_FLAG))) {
    LOG_2( ">>> c_Os2_RegListen(): Socket = %d\n", pSock->Socket );
    BLOCK_MODE( Socket, 0 );
    pSock->Flags |= ENABLED_FD_ACCEPT_FLAG;
    pSock->Flags |= IS_LISTEN_SOCKET_FLAG;
  } else {
    LOG_2( "!!! c_Os2_RegListen() FAILED: Socket = %d\n", pSock->Socket );
    RUN_Error( ERR_SCKINVALIDPARMS );	/* ### ??? */
  }
}

void C_DECL c_Os2_RegShutDown( const SOCKET Socket, const int How ) {
  TASocket * pSock;

  CHECK_INIT();
  pSock = __find_ASocket( Socket );

  if ((pSock == NULL) ||
      (pSock->Flags & IS_CLOSED_SOCKET_FLAG)) {
    return;
  }

  if ( pSock->Flags & IS_LISTEN_SOCKET_FLAG ) {
    LOG_2( "!!! _c_Os2_RegShutDown() FAILED: Socket = %d\n", pSock->Socket );
    RUN_Error( ERR_SCKINVALIDPARMS );	/* ### ??? */
  }

  #define HOW_RECV_DISABLE 0	/* Subsequent receives will be disallow.*/
  #define HOW_SEND_DISABLE 1	/* Subsequent sends will be disallowed	*/
  #define HOW_BOTH_DISABLE 2	/* Receives & sends will be disallowed	*/

  LOG_3( ">>> c_Os2_RegShutDown: Socket = %d, How = %d\n", Socket, How );

  switch ( How ) {
    case HOW_RECV_DISABLE:
      DISABLE_RD( pSock->Flags );
      pSock->Flags |= IS_SHUT_R_SOCKET_FLAG;
      break;

    case HOW_SEND_DISABLE:
      DISABLE_WR( pSock->Flags );
      pSock->Flags |= IS_SHUT_W_SOCKET_FLAG;
      break;

    case HOW_BOTH_DISABLE:
      DISABLE_RD( pSock->Flags );
      DISABLE_WR( pSock->Flags );
      pSock->Flags |= IS_SHUT_R_SOCKET_FLAG;
      pSock->Flags |= IS_SHUT_W_SOCKET_FLAG;
      break;

    default:
      LOG_2( "!!! c_Os2_RegShutDown() FAILED: Socket = %d\n", pSock->Socket );
      RUN_Error( ERR_SCKINVALIDPARMS );	/* ### ??? */
      break;
  }
}

void C_DECL c_Os2_ResetFdRead( const SOCKET Socket, const int AlsoResetFdOOB ) {
  TASocket * pSock;

  CHECK_INIT();
  pSock = __find_ASocket( Socket );

  if ((pSock == NULL)				||
      (pSock->Flags & IS_CLOSED_SOCKET_FLAG)	||
      (pSock->Flags & IS_SHUT_R_SOCKET_FLAG)) {
    return;
  }

  if ( pSock->Flags & IS_LISTEN_SOCKET_FLAG ) {
    LOG_2( "!!! _c_Os2_ResetFdRead() FAILED: Socket = %d\n", pSock->Socket );
    RUN_Error( ERR_SCKINVALIDPARMS );	/* ### ??? */
  }

  if ((pSock->Events & FD_READ) || (pSock->Events & FD_OOB)) {
    int ok = 1;

    if ((pSock->Flags & IS_STREAM_SOCKET_FLAG)	&&
	(! (pSock->Flags & IS_IN_CONNECTION_FLAG))) {
      ok = 0;
    }

    if ( ok ) {
      LOG_2( ">>> c_Os2_ResetFdRead: Socket = %d\n", pSock->Socket );

      if ( pSock->Events & FD_READ ) {
	pSock->Flags |= ENABLED_FD_READ_FLAG;
      }

      if ((pSock->Events & FD_OOB) && AlsoResetFdOOB) {
	pSock->Flags |= ENABLED_FD_OOB_FLAG;
      }
    }
  }
}

void C_DECL c_Os2_ResetFdWrite( const SOCKET Socket, const int SendRC ) {
  TASocket * pSock;

  CHECK_INIT();
  pSock = __find_ASocket( Socket );

  if ((pSock == NULL)				||
      (pSock->Flags & IS_CLOSED_SOCKET_FLAG)	||
      (pSock->Flags & IS_SHUT_W_SOCKET_FLAG)	||
      (! (pSock->Events & FD_WRITE))) {
    return;
  }

  if ( pSock->Flags & IS_LISTEN_SOCKET_FLAG ) {
    LOG_2( "!!! _c_Os2_ResetFdWrite() FAILED: Socket = %d\n", pSock->Socket );
    RUN_Error( ERR_SCKINVALIDPARMS );	/* ### ??? */
  }

  { int ok;

    if ((pSock->Flags & IS_STREAM_SOCKET_FLAG)	&&
	(! (pSock->Flags & IS_IN_CONNECTION_FLAG))) {
      ok = 0;
    } else {
      ok = 1;
    }

    if ( ok ) {
      LOG_3( ">>> c_Os2_ResetFdWrite: Socket = %d, RC = %d\n",
	     pSock->Socket,
	     SendRC );

      #define SOCEWOULDBLOCK (SOCBASEERR + 35)
      if ((SendRC == SOCKET_ERROR) && (SOCK_ERRNO() == SOCEWOULDBLOCK)) {
	pSock->Flags |= ENABLED_FD_WRITE_FLAG;
      }
    }
  }
}

void 
C_DECL c_Os2_Initiate( void ) {
  LOG_1( ">>> c_Os2_Initiate" );
  if ( Current_CB.CtrlFlags & CTRL_FLAG_INITIATED ) {
    RUN_Error( ERR_SCKDOUBLEINIT );
  } else {
    const APIRET apiRC = __open_CB();

    if ( apiRC != 0 ) {
      __close_CB();
      API_ERROR( apiRC );
    }
  }
}

void C_DECL c_Os2_Terminate( void ) {
  LOG_1( ">>> c_Os2_Terminate" );
  CHECK_INIT();

  __close_CB();
  Current_CB.CtrlFlags &= (unsigned)(~CTRL_FLAG_INITIATED);
}

/***************************************************************************
***************************************************************************/

void C_DECL sck_ASelectTimeOut_0( const TSelectTimeVal * const pTimeVal ) {

  CHECK_INIT();

  Current_CB.TimeVal.TV_Sec  = pTimeVal->TV_Sec;
  Current_CB.TimeVal.TV_USec = pTimeVal->TV_USec;
  LOG_3( ">>> sck_ASelectTimeOut: set ( %u : %u )\n",
	 Current_CB.TimeVal.TV_Sec,
	 Current_CB.TimeVal.TV_USec );
}

void C_DECL sck_ASelectTimeOut_1(  const TSelectTimeVal ** ppTimeVal ) {
  TSelectTimeVal * pTimeVal;

  CHECK_INIT();

  pTimeVal = (TSelectTimeVal *) MEM_AllocGStack( sizeof( *pTimeVal ) );

  pTimeVal->TV_Sec  = Current_CB.TimeVal.TV_Sec;
  pTimeVal->TV_USec = Current_CB.TimeVal.TV_USec;

  *ppTimeVal = pTimeVal;
}

/***************************************************************************
***************************************************************************/

TNotifyFNS C_DECL sck_ASetNotifyFNS( TNotifyFNS NotifyFNS ) {
  TNotifyFNS curFNS = User_NotifyFNS;
  User_NotifyFNS    = NotifyFNS;
  return curFNS;
}

#endif	/* defined( __IBMC__ ) || defined( __OS2__ ) */

