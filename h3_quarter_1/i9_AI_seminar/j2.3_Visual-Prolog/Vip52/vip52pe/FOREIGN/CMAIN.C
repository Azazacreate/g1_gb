/***************************************************************************

			   PDC Prolog

	     Copyright (c) 1984 - 2000 Prolog Development Center A/S

 FileName: CMAIN.C
 PURPOSE: C main module

 อออออออออออออออหออออออหออออออออออออออออออออออออออออออออออออออออออออออออออออ
  Date Modified,บ By,  บ  Comments.
 อออออออออออออออฮออออออฮออออออออออออออออออออออออออออออออออออออออออออออออออออ
     30/06/95   บ SPB  บ Added exceptions handling for 32 bits platforms
                บ      บ (Windows, NT, OS/2)
     24/06/96   บSPB151บ Support DLL's & multithreding
      8/08/96   บSPB.VGบ Init for DLL's
     11/11/96   บSPB.VGบ vpi_ErrorMsg for PrologErrorReport
     10/07/96   บSPB.VGบ move DLL's to dllmain.c
     16/09/97   บSPB330บ R970618.01 main doesn't return code return
     20/01/98   บSPB.VGบ add GUI constant
     04/02/98   บSPB398บ Change exceptions handling
                บ      บ
***************************************************************************/

/* Defines for generation:					     */
/*	WIN32 - for Windows (with Microsoft or Borland C compilers)  */
/*	OS32  - for OS/2                        		     */
/*	PDCdummy - for using alternative way to start prolog	     */
/*	VPI      - for using with VPI.LIB                            */
/*	EasyWin  - for Easywin strategy                              */
/*	GUI      - for GUI in Windows (Winmain is used)              */

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
/*YI H66  unsigned near INIT_hInstance;  need for PROLOG.LIB  */
  extern  HINSTANCE far   xPDC_WIN_INSTANCE; /* need for VPI.LIB */
  #endif

  void vpi_ErrorMsg( const unsigned    Err_Code,
		   const unsigned      Err_IncludeNo,
		   const unsigned long Err_Position,
		   const char * const  Err_Message );
#endif

/*YI H66*/
#ifdef GUI
  #if (!defined(VPI) && !defined(EasyWin))
  #include <windows.h>
  #endif
  #ifndef OS32
  unsigned near INIT_hInstance; /* need for PROLOG.LIB */
  #endif
#endif

#ifndef EasyWin /*YI H21*/
 #include "pdcrunt.h"	/* Is situated in the FOREIGN directory    */

 #if defined(OS32)
  #define INCL_DOS
  #define INCL_DOSEXCEPTIONS

  #include <os2.h>	/* Is situated in the C compiler directory */
 #endif
#endif

#ifndef PDCdummy

/***************************************************************************
	Main C routine, call standard main GOAL
  It is recommended that Prolog call back to C, then exit's and
  fails's are automatically handled by Prolog
***************************************************************************/

/* SPB330 void main( void )*/
int main( void )		/* SPB330 */
{
  unsigned rc;
  /* SPB398 begin */
  /*
  #if defined(WIN32)
    RUN_ExceptionOpen();
  #elif defined(OS32)
    EXCEPTIONREGISTRATIONRECORD errRegRec;

    RUN_ExceptionOpen( &errRegRec );
  #endif
  */
  #if defined(OS32)
    EXCEPTIONREGISTRATIONRECORD errRegRec;
    RUN_SetExceptionRegRec_Ptr( &errRegRec );
  #endif
  /* SPB398 end */

  /* SPB330 RUN_Main( &PROLOG_Vars, */
  rc = RUN_Main( &PROLOG_Vars,
		 &PROLOG_SymbolTable,
		 PROLOG_Goal,
		 PROLOG_ErrReport,
		 &PROLOG_ModTab,
		 0,
		 1,
		 1 );

  /* SPB398
  #if defined(WIN32) || defined(OS32)
    RUN_ExceptionClose();
  #endif
  */
  return ( int )rc;		/* SPB330 */
}

#else

/***************************************************************************
  Alternative way to start prolog, by first calling an initialization
  function, and afterwards a termination function.
***************************************************************************/

/* Make sure that register ussage are turned off together with stacktrap etc. */
#include "prag_off.h"	/* Is situated in the FOREIGN directory    */

#ifdef __TURBOC__
  #pragma warn -aus
  #pragma warn -par
#endif
#include <stdio.h>
/*YI H21 #if (!defined(VPI) || defined(OS32))*/
/*YI H66 #if ((!defined(VPI) && !defined(EasyWin)) || defined(OS32)) YI H21*/
#if (!defined(GUI) || defined(OS32)) /*YI H66*/
/* SPB330 void main( void ) */
  int main( void )		/* SPB330 */
#elif defined(WIN32)
  int APIENTRY WinMain( HINSTANCE hInstance, HINSTANCE hPrevInstance,
		      LPSTR lpCmdLine, int nCmdShow )
#else
  int PASCAL WinMain( HINSTANCE hInstance, HINSTANCE hPrevInstance,
		    LPSTR lpCmdLine, int nCmdShow )
  #ifdef __TURBOC__
    #pragma .par
  #endif
#endif
{
  unsigned rc = 0;		/* SPB330 */
  PDC_BOOL oldtxt_kb_used  = (PDC_BOOL) 0;
  PDC_BOOL oldtxt_scr_used = (PDC_BOOL) 0;
  unsigned SaveSP	   = GETSP;

  /* SPB398 begin */
  /*
  #if defined(WIN32)
    RUN_ExceptionOpen();
  #elif defined(OS32)
    EXCEPTIONREGISTRATIONRECORD errRegRec;

    RUN_ExceptionOpen( &errRegRec );
  #endif
  */
  #if defined(OS32)
    EXCEPTIONREGISTRATIONRECORD errRegRec;
    RUN_SetExceptionRegRec_Ptr( &errRegRec );
  #endif
  /* SPB398 begin */

  #ifdef GUI /*YI H66*/
    #ifndef OS32
      INIT_hInstance = ( unsigned near ) hInstance;
    #endif
  #endif
  #ifdef VPI
    #ifndef OS32
/*YI H66    INIT_hInstance = ( unsigned near ) hInstance; */
    xPDC_WIN_INSTANCE = hInstance;
    #endif
  RUN_VpiPresent();
  ERR_InstallUserRepFns( vpi_ErrorMsg );
  #elif defined(EasyWin)
/*YI H21 begin*/
/*YI H66
    #ifndef OS32
    INIT_hInstance = ( unsigned near ) hInstance;
    #endif
*/
  RUN_EasyWinPresent();
/*YI H21 end*/
  #endif

  /* Initialize Prolog system */
  rc = RUN_Init( &PROLOG_Vars,
		 &PROLOG_SymbolTable,
		 &PROLOG_ModTab,
		 0,
		 oldtxt_kb_used,
		 oldtxt_scr_used );

  /* Between RUN_Init and RUN_End Prolog predicates can be called as many
     times as desired, however calls to prolog should always be surrounded
     by call's to RUN_StackTrap() and RUN_StackBTrack() if there is any
     chance that the Prolog program might fail.
  */

  /* SPB330 begin */
  if ( rc == 0 ) {
    if ( RUN_StackTrap() ) {			/* Catch EXIT's here  */
      rc = RUN_GetExitCode();
      if ((! RUN_StackTrap()) && RUN_GetErrorFlag() ) {	/* Avoid double error */	/* SPB151 */
        PROLOG_ErrReport( RUN_GetExitCode() );		/* Normal prolog error*/	/* SPB151 */
      }
    }
    else if ( ! RUN_StackBTrack() ) {		/* Catch a fail here  */
    /* Call your predicates here the goal is no differnt
       from other predicates
    */
    #ifdef EasyWin
      EasyWin_Init( );/*YI H21*/
    #endif
      PROLOG_Goal();
    }


    RUN_RemoveTrap( SaveSP );				/* Remove the trap       */
    {
      const unsigned rc_end = RUN_End( oldtxt_kb_used, oldtxt_scr_used );	/* End the Prolog system */
      if ( rc == 0 ) {
         rc = rc_end;
      }
    }
  }
  /* SPB3303 end */


  /* SPB398
  #if defined(WIN32) || defined(OS32)
    RUN_ExceptionClose();
  #endif
  */
  #ifdef EasyWin
  EasyWin_End( );/*YI H21*/
  #endif
  /* SPB330 #if (defined(VPI) && !defined(OS32))
  return 0;
  SPB330 #endif */
  return (int) rc;
}
#ifdef __TURBOC__
  #pragma warn .aus
#endif

/* Turn on optimizations again */
#include "prag_on.h"	/* Is situated in the FOREIGN directory    */

#endif
