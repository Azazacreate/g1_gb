/******************************************************************************

               Copyright (c) 1984 - 2000 Prolog Development Center A/S

                           Runtime Control Functions

 ModuleName: RUN
 FileName: RUNCMAIN.C
 PURPOSE: _cmain if user does not provide one.
 VERSION: opsys == UNIX && complib_version == LIB

 ***************************************************************************
  Date Modified,* By,  *  Comments.
 ***************************************************************************
                *      *
******************************************************************************/

/* This is cmain for UNIX and XENIX.  If you need to change it, the
   preferable way is to put the modified copy somewhere in your home
   directory, compile it from there, and use the $HOME/bin command-line
   in /usr/lib/PDCProlog/cc_call to redirect linking to a modified
   copy of cc_call in your $HOME/bin directory.  Note that if you
   want to replace the original compiled version of this file,
   the name should be runcmainPLATFORM.o, where PLATFORM is UNX, or XNX.
   Remember to specify -xenix to the C compiler if you're replacing the
   XENIX file.

   For X/Motif links (via XVT), runcmain is replaced by xvtapplUNX.o;
   the source for this (xvtappl.c) is in the XVTLIB package of the
   distribution.
*/

#include <malloc.h>
#include <stdio.h>

#define TRUE 1
#define FALSE 0

extern char *IO_stdinbuf, *IO_stdoutbuf;
extern unsigned IO_stdinbuflen, IO_stdoutbuflen;

extern void * PROLOG_Vars;
extern void * PROLOG_SymbolTable;
#ifndef M_UNIX
extern void * PROLOG_ModTab;
#endif

/* SPB140 void PROLOG_ErrReport();*/
void PROLOG_ErrReport( unsigned );	/* SPB140 */
void PROLOG_Goal();
void PRN_Init();
int RUN_Main();

unsigned INIT_ArgC;
char **INIT_ArgV;

int main(argc,argv)
int argc;
char *argv[];
{
  INIT_ArgC = argc;
  INIT_ArgV = argv;

  /* SPB140 PRN_Init();	*/	/* Leave this in place if you want to be able	*/
			/* to redirect file handle 9 to log file.	*/

/* Be VERY careful wrt enabling M_MXFAST ... malloc on SCO (at least
   prior to V.3.4) is largely unable to recycle released small blocks.
   Also, mallinfo gives incorrect results for small blocks unless
   M_NLBLKS is explicitly set (to 0?).  This affects storage/0 and
   storage/11.
*/
/* SPB140
  mallopt(M_MXFAST,0);
  mallopt(M_NLBLKS,0);
*/
/*
  mallopt(M_MXFAST,64);
  mallopt(M_NLBLKS,25);
*/

  return(RUN_Main(&PROLOG_Vars,&PROLOG_SymbolTable,
#ifdef M_UNIX
	PROLOG_Goal,PROLOG_ErrReport,0,FALSE,TRUE,TRUE));
#else
	PROLOG_Goal,PROLOG_ErrReport,&PROLOG_ModTab,FALSE,TRUE,TRUE));
#endif
}
