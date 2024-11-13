/***************************************************************************

			   PDC Prolog

	     Copyright (c) 1984 - 2000 Prolog Development Center A/S

 FileName: DLLMAIN.C
 PURPOSE: C main module for DLL

 อออออออออออออออหออออออหออออออออออออออออออออออออออออออออออออออออออออออออออออ
  Date Modified,บ By,  บ  Comments.
 อออออออออออออออฮออออออฮออออออออออออออออออออออออออออออออออออออออออออออออออออ
     30/06/95   บ SPB  บ Added exceptions handling for 32 bits platforms
                บ      บ (Windows, NT, OS/2)
     24/06/96   บSPB151บ Support DLL's & multithreding
      8/08/96   บSPB.VGบ Init for DLL's
     11/11/96   บSPB.VGบ vpi_ErrorMsg for PrologErrorReport
      4/07/96   บSPB.VGบ for VPI "XPDC_InitDll" is outside from GOAL
     04/02/98   บSPB398บ Change exceptions handling
		บ      บ
***************************************************************************/

/* Defines for generation:					     */
/*	WIN32 - for Windows (with Microsoft or Borland C compilers)  */
/*	OS32  - for OS/2 (with Borland C compiler		     */
/*	PDCdummy - for using alternative way to start prolog	     */
/*	VPI -   for using with VPI.LIB                               */

#if (defined(WIN32) && defined(__TURBOC__)) || (!defined(WIN32))
  unsigned _stklen = 10000;	/* Some C compilers use it to set stacksize */
#endif

#ifdef VPI
  extern void RUN_VpiPresent( void );
  void XPDC_FreeDll( void );
  int XPDC_InitDll( int );
  void logpr( const void *buff, unsigned size );
  #ifndef OS32
  #include <windows.h>
  unsigned near INIT_hInstance; /* need for PROLOG.LIB */
  extern  HINSTANCE far   xPDC_WIN_INSTANCE; /* need for VPI.LIB */
  #endif

  void vpi_ErrorMsg( const unsigned    Err_Code,
		   const unsigned      Err_IncludeNo,
		   const unsigned long Err_Position,
		   const char * const  Err_Message );
#endif

#include "pdcrunt.h"	/* Is situated in the FOREIGN directory    */

#if defined(OS32)
  #define INCL_DOS
  #define INCL_DOSEXCEPTIONS

  #include <os2.h>	/* Is situated in the C compiler directory */
#endif

/***************************************************************************
  Init of Prolog system for DLL
***************************************************************************/
  #ifdef VPI
    #ifdef OS32
      #pragma argsused
      #ifdef _IBMC
      #pragma linkage (_DLL_InitTerm, system)
unsigned long _DLL_InitTerm (unsigned long modhandle, unsigned long termflag)
      #else
ULONG  _dllmain( ULONG termflag, HMODULE modhandle )
      #endif
    #elif defined(WIN32)
      #ifdef __TURBOC__
BOOL   WINAPI   DllEntryPoint (HANDLE hInstance, ULONG ul_reason_for_call, PVOID lpReserved)
      #else
BOOL   WINAPI   DllMain (HANDLE hInstance, ULONG ul_reason_for_call, PVOID lpReserved)
      #endif
      #if defined( __TURBOC__ )
	#pragma warn -par
      #elif defined( _MSC_VER )
	#pragma warning( disable:4100 )
      #else
	#error >> Unsupported C compiler
      #endif
    #else
int CALLBACK LibMain( HINSTANCE hInstance, WORD wDataSeg, WORD cbHeapSize, LPSTR lpszCmdLine )
    #endif
{
  const PDC_BOOL oldtxt_kb_used  = (PDC_BOOL) FALSE;
  const PDC_BOOL oldtxt_scr_used = (PDC_BOOL) FALSE;

  BOOL ok = TRUE;
    #ifdef OS32
  switch( termflag )
  {
   case 0:
   {
    #elif defined(WIN32)
  switch( ul_reason_for_call )
  {
   case DLL_PROCESS_ATTACH:
   {
    #endif
    {
      const unsigned savedSP = GETSP;

    #if defined(OS32)
      EXCEPTIONREGISTRATIONRECORD errRegRec;
      /* SPB398 RUN_ExceptionOpen( &errRegRec );*/
      RUN_SetExceptionRegRec_Ptr( &errRegRec );
    #else
	/* SPB398
	#if defined(WIN32)
	RUN_ExceptionOpen();
	#endif
	*/
      xPDC_WIN_INSTANCE = hInstance;  //for use in VPI.LIB
    #endif

      RUN_VpiPresent();

    /* Initialize Prolog system */
      RUN_Init( &PROLOG_Vars,
		&PROLOG_SymbolTable,
		&PROLOG_ModTab,
		0,
		oldtxt_kb_used,
		oldtxt_scr_used );

      XPDC_InitDll( 1 );

      if ( RUN_StackTrap() ) {
	ok = FALSE;
	if ((! RUN_StackTrap()) && RUN_GetErrorFlag()) {
	  PROLOG_ErrReport( RUN_GetExitCode() );
	}
      }
      else if ( ! RUN_StackBTrack() ) {
	/* GOAL should be provided via valid facts handling.	*/
	/* It can be "empty".					*/
	PROLOG_Goal();
      }

      RUN_RemoveTrap( savedSP );			/* Remove the trap       */
    }

    #ifdef WIN16
    RUN_End( oldtxt_kb_used, oldtxt_scr_used );	/* End the Prolog system */
    #endif

    #ifdef OS32
    break;
   }
   case 1:
    XPDC_FreeDll();
    break;
   }
    #elif defined(WIN32)
    break;
   }
   case DLL_THREAD_ATTACH:
   case DLL_THREAD_DETACH:
      /* Nothing here: multithreading is not supported */
      break;
   case DLL_PROCESS_DETACH:
    XPDC_FreeDll();

    RUN_End( oldtxt_kb_used, oldtxt_scr_used );	/* End the Prolog system */
    /* SPB398
      #if defined(WIN32)|| defined(OS32)
    RUN_ExceptionClose();
      #endif
    */

    break;
  }
    #endif
  return ok;
}
    #ifdef WIN16
int FAR PASCAL WEP(int bSystemExit)
{
  XPDC_FreeDll();
  return TRUE;
}
    #endif
  #endif
/* Turn on optimizations again */
#include "prag_on.h"	/* Is situated in the FOREIGN directory    */

