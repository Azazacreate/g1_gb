/******************************************************************
		PDCRUNT.H

      Declarations for miscellaneous PDC Prolog runtime functions

	extracts from the PDC Professional User's Guide

	Copyright (c) 1984 - 2000 Prolog Development Center A/S
*******************************************************************/

#if defined(__cplusplus)
extern "C" {   /* Use this in connection with Borland C++ */
#endif

#ifdef __IBMC__
#define UNDERSCORES
#include "ibmmap.h"
#endif

typedef char PDC_BOOL;

#define PDC_FALSE	((PDC_BOOL) 0)
#define PDC_TRUE	((PDC_BOOL) 1)

#ifndef NEAR
#ifdef MLINEAR
#define NEAR
#else
#define NEAR near
#endif
#endif

#ifndef PASCAL
#ifdef MLINEAR

#ifdef __TURBOC__
  #ifdef __OS2__
    #define PASCAL __pascal
  #else
    #define PASCAL __stdcall
  #endif
#elif defined (_MSC_VER)
  #define PASCAL __stdcall
#else
#  define PASCAL _Pascal
#endif


#else

#ifdef __TURBOC__
#define PASCAL pascal
#else
#if defined(_MSC_VER) && _MSC_VER > 600
#define PASCAL __pascal
#else
#define PASCAL _pascal
#endif
#endif

#endif

#endif


#if defined(__TURBOC__) || defined(_MSC_VER)
#if defined(_MSC_VER) && _MSC_VER > 600 || defined(__OS2__)
#define C_DECL __cdecl
#else
#define C_DECL _cdecl
#endif
#else
#define C_DECL
#endif



/****************************************************************************
	Memory handling
****************************************************************************/

/* Handling of gstack */

void * C_DECL MEM_AllocGStack(unsigned size);

#ifdef MLINEAR
typedef unsigned long STACKMARK;
extern STACKMARK MEM_GTop;
unsigned C_DECL MEM_GetBigGStack(unsigned request);
/* This will return request, or if too large a conservative
   maximum based on current process size and its ulimit.
*/
#else
typedef unsigned long STACKMARK;
void * C_DECL MEM_AllocNormGStack(unsigned size);
unsigned C_DECL MEM_GetMaxGStack(void);
#endif

STACKMARK C_DECL MEM_MarkGStack(void);			/* SPB151 */
void C_DECL MEM_ReleaseGStack(STACKMARK);		/* SPB151 */

void C_DECL MEM_AdjustGStackAlloc(void *ptr,unsigned realsiz);
/* Use this with care in linear ('386, UNIX) memory ... no relocation
   of the top segment on the gstack is performed, so if the next
   gstack allocation is too big to use the released part, it won't be
   properly released before the entire gstack drops below the segment.
*/


/* Handling of HEAP */
void * PASCAL MEM_AllocHeap(unsigned size);
void PASCAL MEM_ReleaseHeap(void* ptr,unsigned size);
void * C_DECL MEM_ReAllocHeap(void *Old, unsigned OldSize, unsigned NewSize);

/* Allocating and releasing a binary */
void * C_DECL MEM_MakeBinaryGStack(unsigned NoOfBytes);
void * C_DECL MEM_MakeBinaryHeap(unsigned NoOfBytes);
void C_DECL MEM_ReleaseBinaryHeap(void *Binary);

/* Making a string permanent */
char * C_DECL MEM_SaveStringGStack(char *);
char * C_DECL MEM_SaveStringHeap(char *str);

/* Copying a binary to another location */
void * C_DECL MEM_SaveBinaryGStack(void *bin);
void * C_DECL MEM_SaveBinaryHeap(void *bin);

/* Copying a piece of memory to another location */
void * C_DECL MEM_NewCopyHeap(void *ptr,unsigned size);
void * C_DECL MEM_NewCopyGStack(void *ptr,unsigned size);

/* Handy often used functions */
void C_DECL MEM_MovMem(void *source,void *dest,unsigned len);
void C_DECL MEM_SetMem(void *dest,unsigned count,unsigned char value);
void C_DECL MEM_SetMemW(void *dest,unsigned count,unsigned short value);
#ifdef MLINEAR
void C_DECL MEM_SetMemD(void *dest,unsigned count,unsigned long value);
#endif


/****************************************************************************
  Backtrack handling  (Btrack records are placed on the runtime stack)
****************************************************************************/

/* Generates a fail */
void C_DECL RUN_Fail(void);

/* Stack a backtrack point */
int C_DECL RUN_StackBTrack(void);

/* Cut backtrack points away */
void C_DECL RUN_Cut(unsigned SaveSP);

/* Stack a trap point */
int C_DECL RUN_StackTrap(void);

/* Remove trap point */
void C_DECL RUN_RemoveTrap(unsigned SaveSP);

#define RUN_JmpReturn RUN_JmpReturn1     /* error in PUG manual */

/* Perform a nondeterministic return */
void C_DECL RUN_JmpReturn1(void);

/* Semi-standard predicate bpoints(NoOfBPoints) */
void C_DECL RUN_BPoints(unsigned *);

/* Check for stack overrun */
void C_DECL RUN_StackCheck(void);

/* Record the instantiation  of a reference variable */
void C_DECL RUN_trail_ptr(void **);

/* Activate an error during execution */
void C_DECL RUN_Error(unsigned errorno);

/* Make an exit */
void C_DECL RUN_Exit(unsigned errorno);
void C_DECL RUN_ExitZero(void);

/* Error code from RUN_error or exit */
/* extern unsigned NEAR RUN_ExitCode;			   SPB151 */
unsigned C_DECL RUN_GetExitCode( void );		/* SPB151 */

/* Flag to tell whether last exit was an error or not
 TRUE if trap activated by RUN_error, FALSE with RUN_exit */
/* extern char NEAR RUN_ErrorFlag;			   SPB151 */
char C_DECL RUN_GetErrorFlag( void );			/* SPB151 */

/* Return current stacktop (SP) */
#ifdef __TURBOC__
#ifdef MLINEAR
#define GETSP  _ESP
#else
#define GETSP  _SP
#endif
#else
#define GETSP  RUN_GetSP()
unsigned C_DECL RUN_GetSP(void);
#endif

/* MACRO to avoid register variables in C function */
/* This is important when using LONG Jump's */
#ifdef CCUNIX
#define NOREGISTERVARS
#else
#define	NOREGISTERVARS	register int dummyregvar1=0; register int dummyregvar2=dummyregvar1; dummyregvar1=dummyregvar2;
#endif


/****************************************************************************
	String handling in the PDC Prolog library
****************************************************************************/

#ifdef CCUNIX
#include <string.h>
#define STR_StrLen(s) (strlen(s))
#define STR_StrCat(s1,s2) (strcat((s1),(s2)))
#define STR_StrCat0(s1,s2) (strcpy((s1),(s2)))
#define STR_StrCat0Max(s1,s2,l) (strncat(strcpy((s1),""),(s2),(l)-1))
#define STR_StrCatMax(s1,s2,l) (strncat((s1),(s2),(l)-1))
#else
unsigned C_DECL  STR_StrLen(const char * const);
void C_DECL STR_StrCat(char * const Dest,const char * const Source);
void C_DECL STR_StrCat0(char * const Dest,const char * const Source);
void C_DECL STR_StrCat0Max(char * const Dest,const char * const Source, unsigned MaxLen);
void C_DECL STR_StrCatMax(char * const Dest,const char * const Source,unsigned MaxLen);
#endif

void C_DECL  STR_ToUpper(char *str);
void C_DECL  STR_ToLower(char *str);
char * C_DECL  STR_ExtendStr(char *Str,unsigned NewLen);
unsigned C_DECL  STR_SearchStr(char *Str,char *Srch,PDC_BOOL CaseSens);
/* CaseSens has currently no effect, the search is _not_ case-sensitive */

int C_DECL  STR_StrCmp(const char * const,const char * const);
int STR_StrNCmp(char *str1,char *str2,unsigned Size);
/* Returns -1, 0, or 1 */

unsigned C_DECL  STR_UCat(char *Dest,unsigned short Numb);
/* Cat, with leading zeroes, an unsigned 16 bit onto an existing string,
   and return total length.
*/

/* Scanner functions */
int C_DECL SCAN_Intg(char *Str,long *Val,PDC_BOOL *Sign,PDC_BOOL *HexNotation);
int C_DECL SCAN_Real(char *Str,double *val);
int C_DECL SCAN_Uns(char *Str,unsigned *valp);
int C_DECL SCAN_Ref(char *Str,long *Ref);

/* Convert unsigned to string */
char * C_DECL CONV_UnsignedToStr( const unsigned Value );

/****************************************************************************
	Miscellaneous
****************************************************************************/

/* Insert string in symbol table */
char * C_DECL HASH_BinInsert(char *str);

/* Print symbol table */
void C_DECL HASH_Print(void);

/* Output in the PDC Prolog library; redirectable */
void C_DECL IO_WrStr(char *s);
void C_DECL IO_WrCh(char ch);
void C_DECL IO_WrIntg(int v);
void C_DECL IO_WrReal(double r);
void C_DECL IO_WrRef(long ref);
void C_DECL IO_Writef(char *format,...);
unsigned C_DECL IO_SPrintf(char *ds,char *cs,...);

/* Standard predicate: disk( string Path ) - (o) */
void C_DECL IO_Disk_o( char ** path );

/* Obtain IO_Vars.konsolinput (R970104.01, SPB244) */
PDC_BOOL C_DECL IO_IsConsoleInput( void );

/* Standard predicate: disk( string Path ) - (i) */
void C_DECL IO_Disk_i( const char * const path );

/* Miscellaneous IO */
char * C_DECL IO_getln( void );
char   C_DECL IO_GetCh( void );

/* SPB: prototypes for routines for exception handling (OS/2 and WIN32) */
#ifdef MLINEAR
  #if defined(__IBMC__) || (defined(__TURBOC__) && defined(__OS2__))
    void C_DECL RUN_SetExceptionRegRec_Ptr( void * const ExceptionRegRec_Ptr );
  #endif
#endif

/* SPB217 for FeedBack 950123.08 begin */
typedef void (* TUserErrRepFns)( const unsigned	     Err_Code,
				 const unsigned	     Err_IncludeNo,
				 const unsigned long Err_Position,
				 const char * const  Err_Message );

void C_DECL ERR_InstallUserRepFns( TUserErrRepFns UserErrRepFns );
/* SPB217 for FeedBack 950123.08 end */

/* Tell to RTS: "we are building" the DLL */
void C_DECL RUN_SetDllMode( void );

/***************************************************************************
	Variables public in Prolog main module and symbol file
   PROLOG_Vars:		Misc parameters transfered from compiler
   PROLOG_SymbolTable:	A pointer to the root of the symbol table
   PROLOG_ModTab:	A pointer to a description of the modules
   PROLOG_Goal:		Pointer to which prolog rouutine to call
   PROLOG_ErrReport:	Which errorlevel routine to call
***************************************************************************/


#ifdef MLINEAR
extern void * PROLOG_Vars;
extern void * PROLOG_SymbolTable;
extern void * PROLOG_ModTab;
#else
extern void * far PROLOG_Vars;
extern void * far PROLOG_SymbolTable;
extern void * far PROLOG_ModTab;
#endif

void C_DECL PROLOG_ErrReport(unsigned);
void C_DECL PROLOG_Goal(void);


/***************************************************************************
	Entry points to Prolog when C is the main module
***************************************************************************/

unsigned int C_DECL RUN_Init(void *runtimevars, void *symtab,
		void *modtab,PDC_BOOL allowreboot, PDC_BOOL kb, PDC_BOOL scr);
unsigned int C_DECL RUN_End(PDC_BOOL kb, PDC_BOOL wd);

unsigned C_DECL RUN_Main(
	void *PrologVars,		/* PROLOG_Vars */
	void *SymbolTable,		/* PROLOG_SymbolTable */
	void (*goal)(void),		/* PROLOG_Goal */
	void (*ERR_Report)(unsigned),	/* PROLOG_ErrReport */
	void *ModTab,		/* 0 for COFF files, &PROLOG_ModTab for OMF */
	int AllowReBoot,	/* Only applicable to DOS */
	PDC_BOOL kb,		/* Keyboard and screen used */
	PDC_BOOL scr );

#if defined(__cplusplus)
} // extern "C" */
#endif
