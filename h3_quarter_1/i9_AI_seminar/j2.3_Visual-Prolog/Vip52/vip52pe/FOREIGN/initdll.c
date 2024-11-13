/*****************************************************************************

                Copyright (c) 1984 - 2000 Prolog Development Center A/S

                        VISUAL Prolog

 Project:  PROLOG
 FileName: cmain.c
 Purpose: Main dll call
 Written by: PDC
 Comments:

 อออออออออออออออหออออออหออออออออออออออออออออออออออออออออออออออออออออออออออออ
  Date Modified,บ By,  บ  Comments.
 อออออออออออออออฮออออออฮออออออออออออออออออออออออออออออออออออออออออออออออออออ
     04/02/98   บSPB398บ Change exceptions handling
                บ      บ
******************************************************************************/


#include <windows.h>
#include "pdcrunt.h"

/* Make sure that register ussage are turned off together with stacktrap etc. */
#include "prag_off.h"   /* Is situated in the FOREIGN directory    */

/* SPB398 begin */
#if defined( WIN16 )
  unsigned near INIT_hInstance; /* need for PROLOG.LIB */
#endif
/* SPB398 end */

#if defined( WIN32 )
  BOOL WINAPI
  #ifdef __TURBOC__
    DllEntryPoint( HANDLE hInstance,
                   ULONG  ul_reason_for_call,
                   PVOID lpReserved )
  #else
    DllMain ( HANDLE hInstance,
              ULONG  ul_reason_for_call,
              PVOID  lpReserved )
  #endif
#elif defined( WIN16 )

  int CALLBACK LibMain( HINSTANCE hInstance,
                        WORD      wDataSeg,
                        WORD      cbHeapSize,
                        LPSTR     lpszCmdLine )
#else
  #error "Unsupported platform"
#endif
{
  const PDC_BOOL oldtxt_kb_used  = 0;
  const PDC_BOOL oldtxt_scr_used = 0;

  BOOL ok = TRUE;

  /* SPB398 begin */
  #if defined( WIN16 )
    INIT_hInstance = (unsigned near) hInstance;
  #endif
  /* SPB398 end */

#ifdef WIN32
  switch( ul_reason_for_call ) {
   case DLL_PROCESS_ATTACH:
#endif
   {
    const unsigned SaveSP = GETSP;

    /* SPB398
    #ifdef WIN32
      RUN_ExceptionOpen();
    #endif
    */

    if ( RUN_Init( &PROLOG_Vars,
                   &PROLOG_SymbolTable,
                   &PROLOG_ModTab,
                   0,
                   oldtxt_kb_used,
                   oldtxt_scr_used ) != 0 ) {
      return FALSE;
    }

    if ( RUN_StackTrap() ) {
      ok = FALSE;
      if ((! RUN_StackTrap()) && RUN_GetErrorFlag() ) {
        PROLOG_ErrReport( RUN_GetExitCode() );
      }
    } else if ( ! RUN_StackBTrack() ) {
      PROLOG_Goal();
    }

    RUN_RemoveTrap( SaveSP );

    #ifdef WIN16
      RUN_End( oldtxt_kb_used, oldtxt_scr_used );
    #endif

   }
#ifdef WIN32
     break;
   case DLL_THREAD_DETACH:
   case DLL_THREAD_ATTACH:
     /* Nothing */
     break;

   case DLL_PROCESS_DETACH:
     RUN_End( oldtxt_kb_used, oldtxt_scr_used );
     /* SPB398 RUN_ExceptionClose();*/
     break;
  }
#endif
  return ok;
}

#ifdef WIN16
int FAR PASCAL WEP(int bSystemExit)
{
  return(TRUE);
}
#endif

/* Turn on optimizations again */
#include "prag_on.h"    /* Is situated in the FOREIGN directory    */

