/******************************************************************************

		Copyright (c) 1984 - 1999 Prolog Development Center A/S

 FileName:	PDCRUNT.H
 Purpose:	Declarations for miscellaneous PDC Prolog runtime functions
		extracts from the PDC Professional User's Guide
 Written by:	Sergey Alexeev
 Version:	1.0
 Build:		001.971010
 Tested with:   Visual Prolog v.5.0 build 533
 Comments:
******************************************************************************/

#if defined(__cplusplus)
extern "C" {   /* Use this in connection with Borland C++ */
#endif

#ifdef __IBMC__
#define UNDERSCORES
#include "ibmmap.h"
#endif

typedef char PDC_BOOL;


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
#define PASCAL __pascal
#elif defined (_MSC_VER)
#define PASCAL __stdcall
#else
#define PASCAL _Pascal
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
#define MEM_MarkGStack() (MEM_GTop)
#define MEM_ReleaseGStack(Top) (MEM_GTop=(Top))
unsigned C_DECL MEM_GetBigGStack(unsigned request);
/* This will return request, or if too large a conservative
   maximum based on current process size and its ulimit.
*/
#else
typedef unsigned long STACKMARK;
STACKMARK C_DECL MEM_MarkGStack(void);
void C_DECL MEM_ReleaseGStack(STACKMARK);
void * C_DECL MEM_AllocNormGStack(unsigned size);
unsigned C_DECL MEM_GetMaxGStack(void);
#endif

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
extern unsigned NEAR RUN_ExitCode;

/* Flag to tell whether last exit was an error or not
 TRUE if trap activated by RUN_error, FALSE with RUN_exit */
extern char NEAR RUN_ErrorFlag;

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
unsigned C_DECL  STR_StrLen(char *);
void C_DECL STR_StrCat(char *Dest,char *Source);
void C_DECL STR_StrCat0(char *Dest,char *Source);
void C_DECL STR_StrCat0Max(char *Dest,char *Source, unsigned MaxLen);
void C_DECL STR_StrCatMax(char *Dest,char *Source,unsigned MaxLen);
#endif

void C_DECL  STR_ToUpper(char *str);
void C_DECL  STR_ToLower(char *str);
char * C_DECL  STR_ExtendStr(char *Str,unsigned NewLen);
unsigned C_DECL  STR_SearchStr(char *Str,char *Srch,PDC_BOOL CaseSens);
/* CaseSens has currently no effect, the search is _not_ case-sensitive */

int C_DECL  STR_StrCmp(char *,char *);
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
} /* extern "C" */
#endif
