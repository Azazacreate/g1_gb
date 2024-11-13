/******************************************************************************

               Copyright (c) 1984 - 2000 Prolog Development Center A/S

                           Interface to SQL data bases

 ModuleName: SQLBIND
 FileName: SQLBIND.H
 AUTHOR:   Ole Kjaer Christensen, Henrik Lawaetz, Lars Henrik Jacobsen
 PURPOSE:  Prolog bindings to SQL data bases
 
 ---------------+------+----------------------------------------------------
  Date Modified,| By,  |  Comments.
 ---------------+------+----------------------------------------------------
   94-03-16     | HL   |  Present version supports only one connection at a time
   94-07-05     | LHJ  |  Multiple connections and statements
  17-08-1994    | LHJ  |  sql_GetReal changed
  03-11-1994    | LHJ  |  change sql_ColWidth to return an SDWORD
  09-11-1994    | LHJ  |  New functions: sql_ExecBnd, sql_ExecStmtBnd and sql_Get*Bnd
  02-03-1995    | LHJ  |  New functions: sql_ConnectOldStyle (OCI only)
  06-03-1995    | LHJ  |  Correct sql_ConnectOldStyle (OCI only)
  28-04-1995    | LHJ  |  New functions: sql_BeginParam, sql_ExecParam, sql_EndParam
  25-03-1997    | TLP  |  SQL_nullHandle changed from -1 to 0xffffffff,
                |      |  which has the correct type
                |      |
******************************************************************************/


// Do not use the emulator if pure prolog
#if 1
typedef struct { int w1; int w2; int w3; int w4; } PDC_DOUBLE;
#endif



/*---------------------------- Constants/Macros ---------------------------*/
                                    
#define SQL_MaxStringLength			255

#define SQL_MaxErrorMessageLength	1024
                                    
// Prolog Error Numbers for ODBCBIND

#define PROLOG_SQL_ERROR            2100
#define PROLOG_SQL_MAX_CONNECTIONS  2101
#define PROLOG_SQL_INVALID_HANDLE   2110
#define PROLOG_SQL_NEED_DATA        2120
#define PROLOG_SQL_STILL_EXECUTING  2130
#define PROLOG_SQL_DATATYPE_UNSUPP  2097
#define PROLOG_FAIL                 2098

#define PROLOG_OTHER_ERROR          2099

// Prolog Error Numbers for DB2BIND.
// DB2 returns negative error codes
// for SQL errors

#define sql_noErr                   0
#define sql_invalidHandleErr        4015
#define sql_columnTypeErr           4016
#define sql_columnRefErr            4017
#define sql_memoryErr               4018
#define sql_noFreeHandlesErr        4019
#define sql_functionUnsupportedErr  4020

// Common null handle 

#define sql_nullHandle             0xffffffff

// Column Types:       returned by sql_ColType

#define SQL_StringType              1
#define SQL_LongType                2
#define SQL_IntegerType             3
#define SQL_RealType                4
#define SQL_DateType                5
#define SQL_TimeType                6
#define SQL_TimeStampType           7

// COL_DATA domain functor constants (Note: The domain alternatives of
// COL_DATA in "sql_tool.dom" MUST be specified in the SAME order):

#define f_s    1     // s(STRING)
#define f_i    2     // i(SHORT)
#define f_l    3     // l(LONG)
#define f_r    4     // r(REAL)
#define f_d    5     // d(STRING)
#define f_t    6     // t(STRING)
#define f_ts   7     // ts(STRING)
#define f_null 8     // null_value

/*--------------------------------- Types ---------------------------------*/

typedef unsigned int   COL_REF;
typedef int            COL_TYPE;
typedef long           ERR_CODE;
typedef char          *STRING;
#ifndef DBC_HANDLE_DEF
typedef void FAR *     DBC_HANDLE;
#endif
#ifndef STMT_HANDLE_DEF
typedef void FAR *     STMT_HANDLE;
#endif
#ifndef UCHAR
typedef unsigned char UCHAR;
#endif

typedef void FAR * PARAM_HANDLE;

typedef struct col_data_struct {
   UCHAR fno;
   union {
         STRING s;
         short  i;
         long   l;
         PDC_DOUBLE  r;
         STRING d;
         STRING t;
         STRING ts;
      } u;
   } COL_DATA;

typedef struct col_data_list_struct {
	unsigned char fno;
	struct col_data_struct *data;
	struct col_data_list_struct *next;
} COL_DATA_LIST;

typedef struct col_bind_descr_struct {
	SWORD	colNo;
	SWORD	colCTyp;
	SDWORD	colLength;
} COL_BIND_DESCR;

typedef struct col_bind_descr_list_struct {
	unsigned char fno;
	struct col_bind_descr_struct *p;
	struct col_bind_descr_list_struct *next;
} COL_BIND_DESCR_LIST;

/*-------------------------- Function Prototypes --------------------------*/

DBC_HANDLE  sql_Connect     (UCHAR szDatabase[],UCHAR szUser[],UCHAR szPassword[]);
DBC_HANDLE  sql_ConnectOldStyle(UCHAR szDatabase[],UCHAR szUser[],UCHAR szPassword[]);  // OCI only (using olon)
void        sql_Disconnect  (DBC_HANDLE);
void        sql_Commit      (DBC_HANDLE);
void        sql_RollBack    (DBC_HANDLE);

void        sql_Drop        (STMT_HANDLE);
void        sql_Close       (STMT_HANDLE);
STMT_HANDLE sql_Prepare     (DBC_HANDLE, UCHAR szSqlStr[]);
STMT_HANDLE sql_Exec        (DBC_HANDLE, UCHAR szSqlStr[]);
STMT_HANDLE sql_ExecBnd     (DBC_HANDLE, UCHAR szSqlStr[], COL_BIND_DESCR_LIST*);
void        sql_ExecStmt    (STMT_HANDLE);
void        sql_ExecStmtBnd (STMT_HANDLE, UCHAR szSqlStr[], COL_BIND_DESCR_LIST*);
STMT_HANDLE sql_ExecDirect  (DBC_HANDLE, UCHAR szSqlStr[]);
void        sql_ExecDirectStmt(STMT_HANDLE, UCHAR szSqlStr[]);
void        sql_FetchNext   (STMT_HANDLE);
void        sql_FetchPrev   (STMT_HANDLE);
void        sql_BindCol     (STMT_HANDLE, UWORD, SWORD, PTR, SDWORD, SDWORD FAR *);
void        sql_SetParam    (STMT_HANDLE, UWORD, SWORD, SWORD, UDWORD, SWORD, PTR, SDWORD FAR *);
PARAM_HANDLE sql_BeginParam (STMT_HANDLE, COL_DATA_LIST *);
void        sql_EndParam    (PARAM_HANDLE);
void        sql_ExecParam   (STMT_HANDLE, PARAM_HANDLE, COL_DATA_LIST *);

STRING      sql_GetString   (STMT_HANDLE, COL_REF);
SDWORD      sql_GetLong     (STMT_HANDLE, COL_REF);
SWORD       sql_GetInteger  (STMT_HANDLE, COL_REF);
void        sql_GetReal     (STMT_HANDLE, COL_REF, PDC_DOUBLE*);
STRING      sql_GetDate     (STMT_HANDLE, COL_REF);
STRING      sql_GetTime     (STMT_HANDLE, COL_REF);
STRING      sql_GetTimeStamp(STMT_HANDLE, COL_REF);

STRING      sql_GetStringBnd(STMT_HANDLE, COL_REF);
SDWORD      sql_GetLongBnd  (STMT_HANDLE, COL_REF);
SWORD       sql_GetIntegerBnd(STMT_HANDLE, COL_REF);
void        sql_GetRealBnd  (STMT_HANDLE, COL_REF, PDC_DOUBLE*);
STRING      sql_GetTimeBnd  (STMT_HANDLE, COL_REF);
STRING      sql_GetDateBnd  (STMT_HANDLE, COL_REF);
STRING      sql_GetTimeStampBnd(STMT_HANDLE, COL_REF);
COL_DATA  * sql_GetColDataBnd(STMT_HANDLE, COL_REF);

COL_DATA  * sql_GetColData  (STMT_HANDLE, COL_REF);

COL_TYPE    sql_ColType     (STMT_HANDLE, COL_REF);
STRING      sql_ColName     (STMT_HANDLE, COL_REF);
SDWORD      sql_ColWidth    (STMT_HANDLE, COL_REF);
SWORD       sql_NumCols     (STMT_HANDLE);
STRING      sql_GetCursorName(STMT_HANDLE);

void 		sql_GetColDescrBnd(STMT_HANDLE, COL_BIND_DESCR_LIST**);

ERR_CODE    sql_Error       (STMT_HANDLE);
SDWORD      sql_NativeError (DBC_HANDLE, STMT_HANDLE);
STRING      sql_ErrorMsg    (DBC_HANDLE, STMT_HANDLE, STMT_HANDLE*);
