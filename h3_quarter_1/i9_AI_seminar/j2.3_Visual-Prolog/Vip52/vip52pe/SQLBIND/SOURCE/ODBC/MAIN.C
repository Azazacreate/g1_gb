/******************************************************************************
		Copyright (c) 1984 - 2000 Prolog Development Center A/S

 FileName:	MAIN.C
 Purpose:	SQL binding
 Written by:	
 Build:		
 Comments:	
******************************************************************************/
#include "windows.h"
#include "stdio.h"
#include "string.h"
#include "sql.h"
#include "sqlext.h" 
#include "pdcrunt.h"

#include "sqlbind.h"

unsigned near INIT_hInstance;

void * far PROLOG_Vars;
void * far PROLOG_SymbolTable;
void * far PROLOG_ModTab;

void PROLOG_ErrReport(unsigned u)
{
}

WORD PrologWinMain(HANDLE h, HANDLE h1, LPSTR c1, int i)
{
	STMT_HANDLE hstmt;
	DBC_HANDLE hdbc = sql_Connect("RoseAccess","","");
	char *STDVAR,*DSTVAR,*DSTSTTIM,*DSTSTDAT,*DSTENDTIM,*DSTENDDAT;
    int CAP1MAX,CAP2MAX,SAFEOPECAP1,SAFEOPECAP2,SAFEOPECAP3,UNSAFEOPE,DEFCLO,DEFCLOSEC;

    hstmt = sql_ExecDirect(hdbc,"SELECT TZ_STDVAR,TZ_DSTVAR,TZ_DSTSTTIM,TZ_DSTSTDAT,TZ_DSTENDTIM,TZ_DSTENDDAT FROM DS_RO_TIMEZONE");
    sql_FetchNext(hstmt);
    
    STDVAR    = sql_GetString(hstmt, 1);
    DSTVAR    = sql_GetString(hstmt, 2);
    DSTSTTIM  = sql_GetString(hstmt, 3);
    DSTSTDAT  = sql_GetString(hstmt, 4);
    DSTENDTIM = sql_GetString(hstmt, 5);
    DSTENDDAT = sql_GetString(hstmt, 6);
    sql_Drop(hstmt);
        
    hstmt = sql_ExecDirect(hdbc,"SELECT * FROM DS_RO_SYSPARM");
    sql_FetchNext(hstmt);
      CAP1MAX     = sql_GetInteger(hstmt, 1);
      CAP2MAX     = sql_GetInteger(hstmt, 2);
      SAFEOPECAP1 = sql_GetInteger(hstmt, 3);
      SAFEOPECAP2 = sql_GetInteger(hstmt, 4);
      SAFEOPECAP3 = sql_GetInteger(hstmt, 5);
      UNSAFEOPE   = sql_GetInteger(hstmt, 6);
      DEFCLO      = sql_GetInteger(hstmt, 7);
      DEFCLOSEC   = sql_GetInteger(hstmt, 8);
    sql_Drop(hstmt);

	sql_Disconnect(hdbc);
	return(0);
}