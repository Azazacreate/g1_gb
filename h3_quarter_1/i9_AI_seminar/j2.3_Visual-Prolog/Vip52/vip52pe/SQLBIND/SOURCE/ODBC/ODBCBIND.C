/******************************************************************************

               Copyright (c) 1984 - 2000 Prolog Development Center A/S

                                 ODBC bindings

 ModuleName: ODBC
 FileName: ODBCBIND.C
 PURPOSE:  Prolog bindings to ODBC API
 
 ---------------+------+----------------------------------------------------
  Date Modified,| By,  |  Comments.
 ---------------+------+----------------------------------------------------
   1994-06-25   | LHJ  |  sql_ErrorMsg : uses SqlState also in error msg
   1994-06-25   | LHJ  |  sql_ExecDirect : closes stmt if not a SELECT stmt
   1994-06-27   | LHJ  |  sql_GetCursorName : returns current cursorname
   1994-06-27   | LHJ  |  sql_ExecDirectStmt : uses existing stmt handle
   1994-06-27   | LHJ  |  sql_Connect : set commit mode to manual
   1994-06-27   | LHJ  |  sql_Close : SQLFreeStmt use option SQL_DROP, not SQL_CLOSE
   1994-07-05   | LHJ  |  sql_Prepare, sql_ExecStmt, sql_BindCol, sql_SetParam
   1994-27-07   | LEO  |  Removed references to C libraries
  17-08-1994    | LHJ  |  sql_GetReal changed
  30-10-1994    | LHJ  |  sql_ErrorMsg changed; returns also the HSTMT with error
                |      |    if called with sql_nullHandle.
  02-11-1994    | LHJ  |  sql bind column handling (OCI-like adjustments)  +
                |      |    handling up to 3 connections. Each connection can 
                |      |    have only one statement handle
  09-11-1994    | LHJ  |  New functions: sql_ExecBnd, sql_ExecStmtBnd and sql_Get*Bnd
  14-11-1994    | LHJ  |  New function: sql_GetColDescrBnd
  27-04-1995    | LHJ  |  New functions: sql_BeginParam, sql_ExecParam, sql_EndParam
                |      |
******************************************************************************/


#include "windows.h"
#include "stdio.h"
#include "string.h"
#include "sql.h"
#include "sqlext.h" 
#include "time.h"
#include "pdcrunt.h"

#include "sqlbind.h"    

#define LISTFNO 1
#define NILLFNO 2
    
HENV    henv;
STMT_HANDLE hstmtError;
static int db_connections = 0;

typedef struct table_entry_struct {	// SELECT column data
	SDWORD	length;					//    Length of data for this column
	SWORD	type;					//    Type of data for this column
	char	*ptr;					//    Pointer to data for this column
} TABLE_ENTRY;

typedef struct select_struct {	// Data for one select 
   STMT_HANDLE	hstmt;				//    Current SELECT statement handle
   SWORD		numCols;			//    Current number of used columns
   SDWORD		table_length;		//    Current length of SELECT column data
   char			*ptr;				//    Pointer to SELECT column data
};

typedef struct conn_entry_struct {	// Data for one connection
   DBC_HANDLE	hdbc;				//    Connection handle
   struct select_struct ss;			//    Current SELECT statement handle
} CONN_ENTRY;

typedef struct col_desc_struct {	// Description for one column
    UCHAR	szColName[SQL_MaxStringLength];
    SWORD	cbColName;
    SWORD	fSqlType;
    SWORD	ibScale;
    SWORD	fNullable;
    UDWORD	cbColDef;
} COL_DESC, *PCOL_DESC;

#define BUF_TABLE_SIZE     50
#define MAX_DB_CONNECTIONS  3

static TABLE_ENTRY buf_table[MAX_DB_CONNECTIONS][BUF_TABLE_SIZE];	// SELECT column data
static CONN_ENTRY  conn_table[MAX_DB_CONNECTIONS];					// Data for all connections

static void clear_buf_table(int conn)
{
  int i;

   for (i=0; i<BUF_TABLE_SIZE; i++) {
      buf_table[conn][i].length = 0;
      buf_table[conn][i].type   = 0;
      buf_table[conn][i].ptr    = NULL;
      }
}

static void init_conn(DBC_HANDLE hdbc)
{
  int conn;

   if (db_connections == 0) {		// If this is the first connection
      for (conn=0; conn<MAX_DB_CONNECTIONS; conn++) {	// then init connection table
         conn_table[conn].hdbc = (DBC_HANDLE)0;		// for all connections
         }
      conn = 0;		// Let the first connection be nr. 0
      }
   else				// else if this is not the first connection
      for (conn=0; conn<MAX_DB_CONNECTIONS; conn++) {		// locate an un-used connection number
         if (conn_table[conn].hdbc == (DBC_HANDLE)0)
            break;
         }
   if (conn == MAX_DB_CONNECTIONS)	// If no un-used connection numbers then something is wrong
      return;

   db_connections++;	// Increment connection counter
   conn_table[conn].hdbc = hdbc;		// Store connection handle in connection table
   conn_table[conn].ss.hstmt = (STMT_HANDLE)0;
   conn_table[conn].ss.numCols = 0;
   conn_table[conn].ss.table_length = 0;
   conn_table[conn].ss.ptr = NULL;

   clear_buf_table(conn);			// Initialize column data buffer for this connection
}

static int conn_id(DBC_HANDLE hdbc)
{
  int conn;

	if (hdbc == (DBC_HANDLE)0)
		return(-1);

	for (conn=0; conn<MAX_DB_CONNECTIONS; conn++) {
		if (conn_table[conn].hdbc == hdbc)   // entry found
			return(conn);
		}
	if (conn == MAX_DB_CONNECTIONS)
		return(-1);
}

static int conn_id_from_stmt(STMT_HANDLE hstmt)
{
  int conn;

	if (hstmt == (STMT_HANDLE)0)
		return(-1);

	for (conn=0; conn<MAX_DB_CONNECTIONS; conn++) {
		if (conn_table[conn].ss.hstmt == hstmt)   // entry found
			return(conn);
		}
	if (conn == MAX_DB_CONNECTIONS)
		return(-1);
}

static void conn_clear_select(int conn)
{
	if ((conn >= 0) && (conn_table[conn].ss.numCols != 0)) {
		if (conn_table[conn].ss.ptr != NULL)
			MEM_ReleaseHeap(conn_table[conn].ss.ptr,(unsigned)(conn_table[conn].ss.table_length));
		conn_table[conn].ss.ptr = NULL;
		conn_table[conn].ss.table_length = 0;
		conn_table[conn].ss.hstmt = (STMT_HANDLE)0;
		conn_table[conn].ss.numCols = 0;
		}
}
static int dbc_clear_select(DBC_HANDLE hdbc)
{
  int conn;

   conn = conn_id(hdbc);
   if (conn>=0)
		conn_clear_select(conn);
   return(conn);
}

static void close_conn(DBC_HANDLE hdbc)
{
  int conn;

	conn = dbc_clear_select(hdbc);	// Just to be sure.
	if (conn>=0)
		conn_table[conn].hdbc = (DBC_HANDLE)0;
	if (db_connections > 0)
		db_connections--;
}


static UCHAR CH_myUpperTab[256] =
{
0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,
29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,
55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,
81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,
'A',  // 97='a'
'B',  // 98='b'
'C',  // 99='c'
'D',  // 100='d'
'E',  // 101='e'
'F',  // 102='f'
'G',  // 103='g'
'H',  // 104='h'
'I',  // 105='i'
'J',  // 106='j'
'K',  // 107='k'
'L',  // 108='l'
'M',  // 109='m'
'N',  // 110='n'
'O',  // 111='o'
'P',  // 112='p'
'Q',  // 113='q'
'R',  // 114='r'
'S',  // 115='s'
'T',  // 116='t'
'U',  // 117='u'
'V',  // 118='v'
'W',  // 119='w'
'X',  // 120='x'
'Y',  // 121='y'
'Z',  // 122='z'
123,124,125,126,127,128,
(UCHAR)'š',  // 129=''
'E',  // 130='‚'
'A',  // 131='ƒ'
(UCHAR)'Ž',  // 132='„'
'A',  // 133='…'
(UCHAR)'',  // 134='†'
'C',  // 135='‡'
'E',  // 136='ˆ'
'E',  // 137='‰'
'E',  // 138='Š'
'I',  // 139='‹'
'I',  // 140='Œ'
'I',  // 141=''
142,143,144,
(UCHAR)'’',  // 145='‘'
146,
'O',  // 147='“'
(UCHAR)'™',  // 148='”'
'O',  // 149='•'
'U',  // 150='–'
'U',  // 151='—'
'Y',  // 152='˜'
153,154,
(UCHAR)'',  // 155='›'
156,157,158,
(UCHAR)'ž',  // 159='Ÿ'
'A',  // 160=' '
'I',  // 161='¡'
'O',  // 162='¢'
'U',  // 163='£'
(UCHAR)'¥',  // 164='¤'
165,
(UCHAR)'§',  // 166='¦'
167,168,
(UCHAR)'ª',  // 169='©'
170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,185,186,187,188,189,
190,191,192,193,194,195,196,197,198,199,200,201,202,203,204,205,206,207,208,209,
210,211,212,213,214,215,216,217,218,219,220,221,222,223,224,225,226,227,228,229,
230,231,232,233,234,235,236,237,238,239,240,241,242,243,244,245,246,247,248,249,
250,251,252,253,254,255

};


// extern char far CH_UpperTab[];

#define CH_toupper(c) CH_myUpperTab[c]

int StrNCmp(char *str1,char *str2,unsigned size)
{
   char ch;
   char *pch1=str1;
   char *pch2=str2;
   unsigned Cnt=size;

   while ( ((ch=CH_toupper(*pch1)) == *pch2) && ((Cnt--) > 0) )
      {
        if (ch == '\0') return(0);
        pch1++; pch2++;
      }

   if (Cnt && (ch > *pch2)) return(1);
   else if (!Cnt || (ch == *pch2)) return(0);
   else return(-1);
}

static SWORD SQLType2CType(SWORD SQLType)
{
	switch(SQLType) {
		case(SQL_CHAR):
		case(SQL_VARCHAR):
		case(SQL_LONGVARCHAR):
		case(SQL_DECIMAL):
		case(SQL_NUMERIC):
		case(SQL_BIGINT):
		case(SQL_BINARY):
		case(SQL_VARBINARY):
		case(SQL_LONGVARBINARY):
			return(SQL_C_CHAR);
			break;
		case(SQL_BIT):
		case(SQL_TINYINT):
		case(SQL_SMALLINT):
			return(SQL_C_SHORT);
			break;
		case(SQL_INTEGER):
			return(SQL_C_LONG);
			break;
		case(SQL_REAL):  
		case(SQL_FLOAT): 
		case(SQL_DOUBLE):
			return(SQL_C_DOUBLE);
			break;
		case(SQL_DATE):
			return(SQL_C_DATE);
			break;
		case(SQL_TIME):
			return(SQL_C_TIME);
			break;
		case(SQL_TIMESTAMP):
			return(SQL_C_TIMESTAMP);
			break;
		default : break;
		}
	return(SQL_C_DEFAULT);
}

static void odbc_RUN_Error(STMT_HANDLE hstmt, unsigned errorno)
{
    hstmtError = hstmt;
    RUN_Error(errorno);
}

static void set_coldescr(STMT_HANDLE hstmt, COL_BIND_DESCR_LIST *pList)
{
	int		conn;
	SDWORD	dwLength;
	UWORD	uwCol=0;

	if (pList->fno == NILLFNO)
		return;

	conn = conn_id_from_stmt(hstmt); 	// Connection not found, no bindcol
	if (conn<0)
		return;

	while (pList->fno == LISTFNO && uwCol < BUF_TABLE_SIZE) {
		dwLength = (pList->p)->colLength;
		if ((pList->p)->colCTyp == SQL_C_CHAR)
			dwLength++;
		buf_table[conn][uwCol].length = dwLength;
		buf_table[conn][uwCol].type = (pList->p)->colCTyp;

		uwCol++;
		pList = pList->next;
		}
	conn_table[conn].ss.numCols = uwCol;	// Prevents call to DescribeCol
}

void sql_GetColDescrBnd(STMT_HANDLE hstmt, COL_BIND_DESCR_LIST **ppList)
{
	int		conn;
	COL_BIND_DESCR_LIST *pl,*temp;
	COL_BIND_DESCR *pd;
	SWORD	wCol;

	conn = conn_id_from_stmt(hstmt); 	// Connection not found, no bindcol
	if (conn<0)
		return;

	pl = MEM_AllocGStack(sizeof(pl->fno));
	pl->fno = NILLFNO;
	for (wCol=(conn_table[conn].ss.numCols-1); wCol >= 0; wCol--) {
		temp = MEM_AllocGStack(sizeof(COL_BIND_DESCR_LIST));
		temp->next = pl;
		pl = temp;
  		pl->fno = LISTFNO;
		pd = MEM_AllocGStack(sizeof(COL_BIND_DESCR));
		pd->colNo = wCol + 1;
		pd->colCTyp   = buf_table[conn][wCol].type;
		pd->colLength = buf_table[conn][wCol].length;
		pl->p = pd;
		}
	*ppList = pl;
}

static void describe(STMT_HANDLE hstmt, UWORD icol, COL_DESC *psColDesc)
{
    RETCODE	rc;
    
    rc = SQLDescribeCol(hstmt,icol,psColDesc->szColName,SQL_MaxStringLength,
                       &(psColDesc->cbColName),&(psColDesc->fSqlType),&(psColDesc->cbColDef),&(psColDesc->ibScale),&(psColDesc->fNullable));
    switch(rc) {
        case SQL_SUCCESS           : break;
        case SQL_SUCCESS_WITH_INFO : break;
        case SQL_ERROR             : odbc_RUN_Error(hstmt,PROLOG_SQL_ERROR);break;
        case SQL_STILL_EXECUTING   : odbc_RUN_Error(hstmt,PROLOG_SQL_STILL_EXECUTING);break;
        case SQL_INVALID_HANDLE    : odbc_RUN_Error(hstmt,PROLOG_SQL_INVALID_HANDLE);break;
        default                    : odbc_RUN_Error(hstmt,PROLOG_OTHER_ERROR);break;
        }
}

#define COL_HDR sizeof(DWORD)

static void stmt_bind_cols(DBC_HANDLE hdbc, STMT_HANDLE hstmt, UCHAR szSqlStr[])
{
	SWORD       swCols;
	UWORD       uwCol;
	SWORD		swCType;
	SDWORD      dwLength;		// Descriptor info returned for SQL_COLUMN_LENGTH
	SDWORD      dwSqlDataSize;	// Accumulated size of data in exec
	int         conn;
	COL_DESC	sColDesc;		// Column Descriptor

	conn = conn_id(hdbc);		// Connection not found, no bindcol
	if (conn<0)
		return;
	
	if (StrNCmp(szSqlStr,"SELECT",6)==0) {		// This is a SELECT statement
		if (conn_table[conn].ss.numCols == 0) {
			swCols = sql_NumCols(hstmt);			// How many columns ?
			conn_table[conn].ss.hstmt = hstmt;
			conn_table[conn].ss.numCols = swCols;

			// For each column:
			dwSqlDataSize = 0;
			for (uwCol = 1; uwCol <= (UWORD)swCols; uwCol++) {
				describe(hstmt, uwCol, &sColDesc);
				swCType = SQLType2CType(sColDesc.fSqlType);
				dwLength = sColDesc.cbColDef; // Which length for each col ?
				if (swCType==SQL_C_CHAR)
					dwLength++;					// Add one for trailing zero on strings
				// Store length of each column data
				buf_table[conn][(int)uwCol-1].length = dwLength;
				buf_table[conn][(int)uwCol-1].type = swCType;
	
				// Accumulate length of returned data 
				// (add 4 for a SDWORD of length of returned data set by SQLBindCol 
				//   +----+------------+----+-----+----+---------+---
				//   |len1| data col 1 |len2|data2|len3| data 3  |
				//   +----+------------+----+-----+----+---------+---
				//    \  / \           /
				//     4      dwLength
				dwSqlDataSize += dwLength+COL_HDR;
				}
			}
		else {		// numCols > 0 because set_coldescr was called
			swCols = conn_table[conn].ss.numCols;
			dwSqlDataSize = 0;
			for (uwCol = 1; uwCol <= (UWORD)swCols; uwCol++) {
				dwSqlDataSize += buf_table[conn][uwCol-1].length+COL_HDR;
				}
			}
		conn_table[conn].ss.ptr = (char*)MEM_AllocHeap((unsigned)dwSqlDataSize);
		conn_table[conn].ss.table_length = dwSqlDataSize;
		// Start binding columns
		dwSqlDataSize = 0;
		for (uwCol = 1; uwCol <= (UWORD)swCols; uwCol++) {
			// Set ptr to data for this column
			buf_table[conn][uwCol-1].ptr = conn_table[conn].ss.ptr + dwSqlDataSize;
			sql_BindCol(hstmt, uwCol, 
						buf_table[conn][uwCol-1].type,			// Use C datatype specified for column
						buf_table[conn][uwCol-1].ptr+COL_HDR,	// Ptr to data
						buf_table[conn][uwCol-1].length,		// Length of data
						(SDWORD*)(buf_table[conn][uwCol-1].ptr));	// Ptr to length info (output)
			dwSqlDataSize += buf_table[conn][uwCol-1].length+COL_HDR;
			}
		}
	else {
		conn_table[conn].ss.hstmt = (STMT_HANDLE)0;
		conn_table[conn].ss.numCols = 0;
		}
}


// *** sql_NativeError ***
// Returns a Native Error Code (Specific to the data source)

SDWORD sql_NativeError(DBC_HANDLE hdbc, STMT_HANDLE hstmt)
    {
    SWORD   cbErrorMsg;
    UCHAR   szSqlState[SQL_MaxStringLength];
    UCHAR   szErrorMsg[SQL_MaxErrorMessageLength];
    SDWORD  fNativeError;

    SQLError(henv,hdbc,hstmt,szSqlState,&fNativeError,
              szErrorMsg,SQL_MaxErrorMessageLength,&cbErrorMsg);
    return(fNativeError);
    }


// *** sql_ErrorMsg ***
// Note that in ODBC error postings are stored hierarchially,
// subject to the Environment, Connection, Statement (see ODBC doc)
// Therefore call sql_ErrorMsgwith hstmt zero (0) to get Error Messages
// relating to sql_Connect and sql_Disconnect.

// Returns the ODBC Error message. 
// Fails if no error messages are available at that level
// Generates certain Prolog Errors

STRING sql_ErrorMsg(DBC_HANDLE hdbc, STMT_HANDLE hstmt, STMT_HANDLE *phstmtError)
    {
    SWORD    cbErrorMsg;
    UCHAR    szSqlState[SQL_MaxStringLength];
    UCHAR    szErrorMsg[SQL_MaxErrorMessageLength];
    UCHAR    szMsg[SQL_MaxStringLength+SQL_MaxErrorMessageLength+3];
    SDWORD   fNativeError;
    RETCODE  rc;
    STMT_HANDLE  hstmt_error=(hstmt==(STMT_HANDLE)sql_nullHandle?hstmtError:hstmt);
    
                  // Global handle stored before calling RUN_Error
                       // Global handle reset after function returns
    rc = SQLError(henv,hdbc,hstmt_error,szSqlState,&fNativeError,
                  szErrorMsg,SQL_MaxErrorMessageLength,&cbErrorMsg);
    switch(rc)
        {
        case SQL_SUCCESS			: break;
        case SQL_SUCCESS_WITH_INFO	: break;
        case SQL_NO_DATA_FOUND		: odbc_RUN_Error(hstmt,PROLOG_FAIL);break;
        case SQL_NEED_DATA			: odbc_RUN_Error(hstmt,PROLOG_SQL_NEED_DATA);break;
        case SQL_STILL_EXECUTING	: odbc_RUN_Error(hstmt,PROLOG_SQL_STILL_EXECUTING);break;
        case SQL_ERROR				: odbc_RUN_Error(hstmt,PROLOG_SQL_ERROR);break;
        case SQL_INVALID_HANDLE		: odbc_RUN_Error(hstmt,PROLOG_SQL_INVALID_HANDLE);break;
        default						: odbc_RUN_Error(hstmt,PROLOG_OTHER_ERROR);break;
        }                           
    hstmtError = (STMT_HANDLE)SQL_NULL_HSTMT;
    IO_SPrintf(szMsg,"%s - %s",szSqlState,szErrorMsg);
// ++ LHJ/1994-10-30
   *phstmtError = hstmt_error;
// --
    return(MEM_SaveStringGStack(szMsg));
    }

DBC_HANDLE sql_Connect(UCHAR szDatabase[],UCHAR szUser[],UCHAR szPassword[])
    {
    SWORD   cbDatabase, cbUser, cbPassword;
    RETCODE rc;      
    DBC_HANDLE hdbc;
    unsigned Err;

	if (db_connections==MAX_DB_CONNECTIONS)
		odbc_RUN_Error((STMT_HANDLE)0,PROLOG_SQL_MAX_CONNECTIONS);

	if (db_connections == 0) {   // F›rste mand t‘nder lyset
		rc = SQLAllocEnv(&henv);
		if (rc==SQL_ERROR)
			odbc_RUN_Error((STMT_HANDLE)0,PROLOG_SQL_ERROR);
		}

	rc = SQLAllocConnect(henv,&hdbc); 
	if((rc==SQL_SUCCESS)||(rc==SQL_SUCCESS_WITH_INFO))  {
		cbDatabase = STR_StrLen(szDatabase);
		cbUser = STR_StrLen(szUser);
		cbPassword = STR_StrLen(szPassword);
		rc = SQLConnect(hdbc,szDatabase,cbDatabase,szUser,cbUser,szPassword,cbPassword);
		if((rc==SQL_SUCCESS)||(rc==SQL_SUCCESS_WITH_INFO))  {
			SQLSetConnectOption(hdbc, SQL_AUTOCOMMIT, 0);

			init_conn(hdbc);     // Also increments db_connections

			return(hdbc);
			}
		else {
			switch(rc) {
				case SQL_ERROR:				Err = PROLOG_SQL_ERROR; break;
				case SQL_INVALID_HANDLE:	Err = PROLOG_SQL_INVALID_HANDLE; break;
				default:					Err = PROLOG_OTHER_ERROR; break;
				}
			SQLFreeConnect(hdbc);
			if (db_connections == 0)
				SQLFreeEnv(henv);

			odbc_RUN_Error((STMT_HANDLE)0,Err);
			}
		return(hdbc);
		}
	else {   // Error in SQLAllocConnect
		switch(rc) {
			case SQL_ERROR:				Err = PROLOG_SQL_ERROR; break;
			case SQL_INVALID_HANDLE:	Err = PROLOG_SQL_INVALID_HANDLE; break;
			default:					Err = PROLOG_OTHER_ERROR; break;
			}

		if (db_connections == 0)
			SQLFreeEnv(henv);

		odbc_RUN_Error((STMT_HANDLE)0,Err);
		}
	return(hdbc);
	}


void sql_Disconnect(DBC_HANDLE hdbc)
{  
    RETCODE     rc;
    rc = SQLDisconnect(hdbc);
    switch(rc)
        {
        case SQL_SUCCESS            : break;
        case SQL_SUCCESS_WITH_INFO  : break;
        case SQL_ERROR              : RUN_Error(PROLOG_SQL_ERROR);break;
        case SQL_INVALID_HANDLE     : RUN_Error(PROLOG_SQL_INVALID_HANDLE);break;
        default                     : RUN_Error(PROLOG_OTHER_ERROR);break;
        }
   
   close_conn(hdbc);    // Frees local storage and decrements db_connections

    rc = SQLFreeConnect(hdbc);
    switch(rc) {
		case SQL_SUCCESS		: break;
		case SQL_ERROR			: RUN_Error(PROLOG_SQL_ERROR);break;
		case SQL_INVALID_HANDLE	: RUN_Error(PROLOG_SQL_INVALID_HANDLE);break;
		default					: RUN_Error(PROLOG_OTHER_ERROR);break;
		}

	if (db_connections == 0) {    // Sidste mand slukker lyset
		rc = SQLFreeEnv(henv);
		switch(rc) {
			case SQL_SUCCESS  		: break;
			case SQL_ERROR	  		: RUN_Error(PROLOG_SQL_ERROR);break;
			case SQL_INVALID_HANDLE	: RUN_Error(PROLOG_SQL_INVALID_HANDLE);break;
			default			  		: RUN_Error(PROLOG_OTHER_ERROR);break;
			}
      	}
}


void sql_Commit(DBC_HANDLE hdbc)
    {    
    RETCODE     rc;
    rc = SQLTransact(henv,hdbc,SQL_COMMIT);
    switch(rc)
        {
        case SQL_SUCCESS		: break;
        case SQL_ERROR			: RUN_Error(PROLOG_SQL_ERROR);break;
        case SQL_INVALID_HANDLE	: RUN_Error(PROLOG_SQL_INVALID_HANDLE);break;
        default					: RUN_Error(PROLOG_OTHER_ERROR);break;
        }
    }

void sql_RollBack(DBC_HANDLE hdbc)
    {  
    RETCODE     rc;
    rc = SQLTransact(henv,hdbc,SQL_ROLLBACK);
    switch(rc)
        {
        case SQL_SUCCESS		: break;
        case SQL_ERROR			: RUN_Error(PROLOG_SQL_ERROR);break;
        case SQL_INVALID_HANDLE	: RUN_Error(PROLOG_SQL_INVALID_HANDLE);break;
        default					: RUN_Error(PROLOG_OTHER_ERROR);break;
        }
    }

void sql_Drop(STMT_HANDLE hstmt)
	{
	RETCODE     rc;
    
	conn_clear_select(conn_id_from_stmt(hstmt));

	rc = SQLFreeStmt(hstmt,SQL_DROP);
		// Release the hstmt, free all resources associated with it, 
		// close the cursor (if one is open), and discard all pending rows.
		// The SQL_DROP option terminates all access to the hstmt. 
		// The hstmt must be reallocated to be reused.
	switch(rc) {
		case SQL_SUCCESS			: break;
		case SQL_ERROR				: odbc_RUN_Error(hstmt,PROLOG_SQL_ERROR);break;
		case SQL_INVALID_HANDLE	: odbc_RUN_Error(hstmt,PROLOG_SQL_INVALID_HANDLE);break;
		default						: odbc_RUN_Error(hstmt,PROLOG_OTHER_ERROR);break;
		}
}

void sql_Close(STMT_HANDLE hstmt)
   {
	RETCODE     rc;

	conn_clear_select(conn_id_from_stmt(hstmt));

	rc = SQLFreeStmt(hstmt,SQL_CLOSE);
		// SQL_CLOSE: Close the cursor associated with hstmt 
		// (if one was defined) and discard all pending results. 
		// The application can reopen this cursor later by executing a SELECT 
		// statement again with the same or different parameter values. 
		// If no cursor is open, this option has no effect for the application.
	switch(rc) {
		case SQL_SUCCESS			: break;
		case SQL_ERROR				: odbc_RUN_Error(hstmt,PROLOG_SQL_ERROR);break;
		case SQL_INVALID_HANDLE	: odbc_RUN_Error(hstmt,PROLOG_SQL_INVALID_HANDLE);break;
		default						: odbc_RUN_Error(hstmt,PROLOG_OTHER_ERROR);break;
		}
}

STMT_HANDLE sql_Prepare(DBC_HANDLE hdbc, UCHAR szSqlStr[])
    {
    SDWORD      cbSqlStr;
    STMT_HANDLE     hstmt;
    RETCODE     rc;
    rc = SQLAllocStmt(hdbc,&hstmt);
    switch(rc)
        {
        case SQL_SUCCESS		: break;
        case SQL_ERROR			: odbc_RUN_Error(hstmt,PROLOG_SQL_ERROR);break;
        case SQL_INVALID_HANDLE	: odbc_RUN_Error(hstmt,PROLOG_SQL_INVALID_HANDLE);break;
        default					: odbc_RUN_Error(hstmt,PROLOG_OTHER_ERROR);break;
        }                           
    cbSqlStr = STR_StrLen(szSqlStr);
    rc = SQLPrepare(hstmt,szSqlStr,cbSqlStr);
    switch(rc)
        {
        case SQL_SUCCESS			: break;
        case SQL_STILL_EXECUTING	: odbc_RUN_Error(hstmt,PROLOG_SQL_STILL_EXECUTING);break;
        case SQL_ERROR				: odbc_RUN_Error(hstmt,PROLOG_SQL_ERROR);break;
        case SQL_INVALID_HANDLE		: odbc_RUN_Error(hstmt,PROLOG_SQL_INVALID_HANDLE);break;
        default						: odbc_RUN_Error(hstmt,PROLOG_OTHER_ERROR);break;
        }        
    return(hstmt);
}

void sql_ExecStmt(STMT_HANDLE hstmt)
{
    RETCODE     rc; 

    rc = SQLExecute(hstmt);
    switch(rc)
        {
        case SQL_SUCCESS			: break;
        case SQL_SUCCESS_WITH_INFO	: break;
        case SQL_NEED_DATA			: odbc_RUN_Error(hstmt,PROLOG_SQL_NEED_DATA);break;
        case SQL_STILL_EXECUTING	: odbc_RUN_Error(hstmt,PROLOG_SQL_STILL_EXECUTING);break;
        case SQL_ERROR				: odbc_RUN_Error(hstmt,PROLOG_SQL_ERROR);break;
        case SQL_INVALID_HANDLE		: odbc_RUN_Error(hstmt,PROLOG_SQL_INVALID_HANDLE);break;
        default						: odbc_RUN_Error(hstmt,PROLOG_OTHER_ERROR);break;
        }                           
}

STMT_HANDLE sql_Exec(DBC_HANDLE hdbc, UCHAR szSqlStr[])
{
    STMT_HANDLE	hstmt;

	hstmt = sql_Prepare(hdbc, szSqlStr);
	sql_ExecStmt(hstmt);
    return(hstmt);
}

STMT_HANDLE sql_ExecBnd(DBC_HANDLE hdbc, UCHAR szSqlStr[], COL_BIND_DESCR_LIST *pList)
{
	STMT_HANDLE hstmt;

	hstmt = sql_Prepare(hdbc, szSqlStr);
	set_coldescr(hstmt, pList);
	stmt_bind_cols(hdbc, hstmt, szSqlStr);
	sql_ExecStmt(hstmt);
	return(hstmt);
}

void sql_ExecStmtBnd(STMT_HANDLE hstmt, UCHAR szSqlStr[], COL_BIND_DESCR_LIST *pList)
{
// hstmt must have been previously allocated (by SQLAllocStmt) and free of pending resultsets (closed by SQLTransact(SQL_CLOSE))
	RETCODE     rc; 
	SDWORD      cbSqlStr;
	int         conn;

	conn = conn_id_from_stmt(hstmt);
	if (conn<0)
		return;
	
	cbSqlStr = STR_StrLen(szSqlStr);
	rc = SQLPrepare(hstmt,szSqlStr,cbSqlStr);
	switch(rc) {
		case SQL_SUCCESS			: break;
		case SQL_STILL_EXECUTING	: odbc_RUN_Error(hstmt,PROLOG_SQL_STILL_EXECUTING);break;
		case SQL_ERROR				: odbc_RUN_Error(hstmt,PROLOG_SQL_ERROR);break;
		case SQL_INVALID_HANDLE		: odbc_RUN_Error(hstmt,PROLOG_SQL_INVALID_HANDLE);break;
		default						: odbc_RUN_Error(hstmt,PROLOG_OTHER_ERROR);break;
		}        
	set_coldescr(hstmt, pList);
	stmt_bind_cols(conn_table[conn].hdbc, hstmt, szSqlStr);
	sql_ExecStmt(hstmt);
}

void sql_ExecDirectStmt(STMT_HANDLE hstmt, UCHAR szSqlStr[])
{
    SDWORD      cbSqlStr;
    RETCODE     rc; 

    cbSqlStr = STR_StrLen(szSqlStr);
    rc = SQLExecDirect(hstmt,szSqlStr,cbSqlStr);
    switch(rc)
        {
        case SQL_SUCCESS			: break;
        case SQL_SUCCESS_WITH_INFO	: break;
        case SQL_NEED_DATA			: odbc_RUN_Error(hstmt,PROLOG_SQL_NEED_DATA);break;
        case SQL_STILL_EXECUTING	: odbc_RUN_Error(hstmt,PROLOG_SQL_STILL_EXECUTING);break;
        case SQL_ERROR				: odbc_RUN_Error(hstmt,PROLOG_SQL_ERROR);break;
        case SQL_INVALID_HANDLE		: odbc_RUN_Error(hstmt,PROLOG_SQL_INVALID_HANDLE);break;
        default						: odbc_RUN_Error(hstmt,PROLOG_OTHER_ERROR);break;
        }
}

STMT_HANDLE sql_ExecDirect(DBC_HANDLE hdbc, UCHAR szSqlStr[])
{
    SDWORD		cbSqlStr;
    STMT_HANDLE	hstmt;
    RETCODE		rc;

    rc = SQLAllocStmt(hdbc,&hstmt);
    switch(rc)
        {
        case SQL_SUCCESS            : break;
        case SQL_ERROR              : odbc_RUN_Error(hstmt,PROLOG_SQL_ERROR);break;
        case SQL_INVALID_HANDLE     : odbc_RUN_Error(hstmt,PROLOG_SQL_INVALID_HANDLE);break;
        default                     : odbc_RUN_Error(hstmt,PROLOG_OTHER_ERROR);break;
        }                           
    cbSqlStr = STR_StrLen(szSqlStr);
    rc = SQLExecDirect(hstmt,szSqlStr,cbSqlStr);
    switch(rc)
        {
        case SQL_SUCCESS			: break;
        case SQL_SUCCESS_WITH_INFO	: break;
        case SQL_NEED_DATA			: odbc_RUN_Error(hstmt,PROLOG_SQL_NEED_DATA);break;
        case SQL_STILL_EXECUTING	: odbc_RUN_Error(hstmt,PROLOG_SQL_STILL_EXECUTING);break;
        case SQL_ERROR				: odbc_RUN_Error(hstmt,PROLOG_SQL_ERROR);break;
        case SQL_INVALID_HANDLE		: odbc_RUN_Error(hstmt,PROLOG_SQL_INVALID_HANDLE);break;
        default						: odbc_RUN_Error(hstmt,PROLOG_OTHER_ERROR);break;
        }
   if (StrNCmp(szSqlStr,"SELECT",6)!=0) {    // This is not a SELECT statement
        sql_Drop(hstmt);              // close the statement handle, we don't need it
        return (STMT_HANDLE)sql_nullHandle;
        }
    else return(hstmt);
}


SWORD sql_NumCols(STMT_HANDLE hstmt)
{
    SWORD    cols;
    RETCODE  rc;

   rc = SQLNumResultCols(hstmt,&cols);
   switch(rc) {
      case SQL_SUCCESS				: break;
      case SQL_SUCCESS_WITH_INFO	: break;
      case SQL_STILL_EXECUTING		: odbc_RUN_Error(hstmt,PROLOG_SQL_STILL_EXECUTING);break;
      case SQL_ERROR				: odbc_RUN_Error(hstmt,PROLOG_SQL_ERROR);break;
      case SQL_INVALID_HANDLE		: odbc_RUN_Error(hstmt,PROLOG_SQL_INVALID_HANDLE);break;
      default						: odbc_RUN_Error(hstmt,PROLOG_OTHER_ERROR);break;
      }                           

    return(cols);
}

COL_TYPE sql_ColType(STMT_HANDLE hstmt, COL_REF icol)
{
    UCHAR       szColName[SQL_MaxStringLength];
    SWORD       cbColName, fSqlType, ibScale, fNullable;
    UDWORD      cbColDef;
    RETCODE     rc;
    rc = SQLDescribeCol(hstmt,icol,szColName,SQL_MaxStringLength,
                       &cbColName,&fSqlType,&cbColDef,&ibScale,&fNullable);
    switch(rc)
        {
        case SQL_SUCCESS           : break;
        case SQL_SUCCESS_WITH_INFO : break;
        case SQL_STILL_EXECUTING   : odbc_RUN_Error(hstmt,PROLOG_SQL_STILL_EXECUTING);break;
        case SQL_ERROR             : odbc_RUN_Error(hstmt,PROLOG_SQL_ERROR);break;
        case SQL_INVALID_HANDLE    : odbc_RUN_Error(hstmt,PROLOG_SQL_INVALID_HANDLE);break;
        default                    : odbc_RUN_Error(hstmt,PROLOG_OTHER_ERROR);break;
        }                           
    switch(fSqlType)
        {
        case(SQL_CHAR):    // Character string of fixed string length n (1 < n < 254).
        case(SQL_VARCHAR): // Variable-length character string with a maximum string length n (1 < n < 254).
        case(SQL_LONGVARCHAR):// Variable length character data. Maximum length is data source-dependent.
        case(SQL_DECIMAL): // Signed, exact, numeric value with a precision p and scale s (1 < p < 15; 0 < s < p).
        case(SQL_NUMERIC): // Signed, exact, numeric value with a precision p and scale s (1 < p < 15; 0 < s < p).
        case(SQL_BIGINT):  // Exact numeric value with precision 19 (if signed) or 20 (if unsigned) and scale 0
        case(SQL_BINARY):  // Binary data is represented as hexadecimal digits
        case(SQL_VARBINARY):
        case(SQL_LONGVARBINARY):
         return(SQL_StringType);
        case(SQL_BIT):      // Single bit binary data
        case(SQL_TINYINT): // Exact numeric value with precision 3 and scale 0 (signed: -128 < n < 127, unsigned: 0 < n < 256) (a).
        case(SQL_SMALLINT):// Exact numeric value with precision 5 and scale 0 (signed: -32768 < n < 32767, unsigned: 0 < n < 65536) (a).
         return(SQL_IntegerType);
        case(SQL_INTEGER): // Exact numeric value with precision 10 and scale 0 (signed: -2,147,483,648 < n < 2,147,483,647, unsigned: 0 < n < 4,294,967,296) (a).
         return(SQL_LongType);
        case(SQL_REAL):    // Signed, approximate, numeric value with a mantissa precision 7 (zero or absolute value 1E-39 to 1E39).
        case(SQL_FLOAT):   // Signed, approximate, numeric value with a mantissa precision 15 (zero or absolute value 1E-39 to 1E39).
        case(SQL_DOUBLE):
         return(SQL_RealType);
        case(SQL_DATE):
         return(SQL_DateType);
        case(SQL_TIME):
         return(SQL_TimeType);
        case(SQL_TIMESTAMP):
         return(SQL_TimeStampType);
        default:                break;    
        }
    odbc_RUN_Error(hstmt,PROLOG_SQL_DATATYPE_UNSUPP);

   return(0);   // Never reached, just to please compiler
}


STRING sql_ColName(STMT_HANDLE hstmt, COL_REF icol)
{
    UCHAR	szColName[SQL_MaxStringLength];
    SWORD	cbColName, fSqlType, ibScale, fNullable;
    UDWORD	cbColDef;
    RETCODE	rc;
    rc = SQLDescribeCol(hstmt,icol,szColName,SQL_MaxStringLength,
                       &cbColName,&fSqlType,&cbColDef,&ibScale,&fNullable);
    switch(rc)
        {
        case SQL_SUCCESS           : break;
        case SQL_SUCCESS_WITH_INFO : break;
        case SQL_ERROR             : odbc_RUN_Error(hstmt,PROLOG_SQL_ERROR);break;
        case SQL_STILL_EXECUTING   : odbc_RUN_Error(hstmt,PROLOG_SQL_STILL_EXECUTING);break;
        case SQL_INVALID_HANDLE    : odbc_RUN_Error(hstmt,PROLOG_SQL_INVALID_HANDLE);break;
        default                    : odbc_RUN_Error(hstmt,PROLOG_OTHER_ERROR);break;
        }
    return(MEM_SaveStringGStack(szColName));
}

SDWORD sql_ColWidth(STMT_HANDLE hstmt, COL_REF icol)
{
    PTR         rgbValue=NULL;
    SWORD       cbDesc;
    SDWORD      fDesc;
    RETCODE     rc;

    rc = SQLColAttributes(hstmt,icol,SQL_COLUMN_LENGTH,rgbValue,0,&cbDesc,&fDesc);
    switch(rc)
        {
        case SQL_SUCCESS           : break;
        case SQL_SUCCESS_WITH_INFO : break;
        case SQL_ERROR             : odbc_RUN_Error(hstmt,PROLOG_SQL_ERROR);break;
        case SQL_STILL_EXECUTING   : odbc_RUN_Error(hstmt,PROLOG_SQL_STILL_EXECUTING);break;
        case SQL_INVALID_HANDLE    : odbc_RUN_Error(hstmt,PROLOG_SQL_INVALID_HANDLE);break;
        default                    : odbc_RUN_Error(hstmt,PROLOG_OTHER_ERROR);break;
        }
        return(fDesc);
}

COL_DATA *sql_GetColData(STMT_HANDLE hstmt, COL_REF icol)
{
	UCHAR		szString[SQL_MaxStringLength];
	UCHAR		szColName[SQL_MaxStringLength];
	SWORD		cbColName, fSqlType, ibScale, fNullable;
	UDWORD		cbColDef;
	SWORD		sqlctype;
	VOID		*sqlvaraddr;
	SDWORD		sqlvaluemax;
	SDWORD		cbValue;
	DATE_STRUCT	dsDate;
	TIME_STRUCT	tsTime;
	TIMESTAMP_STRUCT	tssStamp;
	COL_DATA	*data;
	RETCODE		rc;

	data = MEM_AllocGStack(sizeof(COL_DATA));
	rc = SQLDescribeCol(hstmt,icol,szColName,SQL_MaxStringLength,
						&cbColName,&fSqlType,&cbColDef,&ibScale,&fNullable);
    switch(rc)
        {
        case SQL_SUCCESS           : break;
        case SQL_SUCCESS_WITH_INFO : break;
        case SQL_ERROR             : odbc_RUN_Error(hstmt,PROLOG_SQL_ERROR);break;
        case SQL_STILL_EXECUTING   : odbc_RUN_Error(hstmt,PROLOG_SQL_STILL_EXECUTING);break;
        case SQL_INVALID_HANDLE    : odbc_RUN_Error(hstmt,PROLOG_SQL_INVALID_HANDLE);break;
        default                    : odbc_RUN_Error(hstmt,PROLOG_OTHER_ERROR);break;
        }
    switch(fSqlType)
        {
        case(SQL_CHAR):
        case(SQL_VARCHAR):
        case(SQL_LONGVARCHAR):
        case(SQL_DECIMAL):
        case(SQL_NUMERIC):
        case(SQL_BIGINT):
        case(SQL_BINARY):
        case(SQL_VARBINARY):
        case(SQL_LONGVARBINARY):
         data->fno = f_s;
         sqlctype = SQL_C_CHAR;
         sqlvaraddr = szString;
         sqlvaluemax = SQL_MaxStringLength;
         break;
        case(SQL_BIT):
        case(SQL_TINYINT):
        case(SQL_SMALLINT):
         data->fno = f_i;
         sqlctype = SQL_C_SHORT;
         sqlvaraddr = &data->u.i;
         sqlvaluemax = 0;
         break;
        case(SQL_INTEGER):
         data->fno = f_l;
         sqlctype = SQL_C_LONG;
         sqlvaraddr = &data->u.l;
         sqlvaluemax = 0;
         break;
        case(SQL_REAL):  
        case(SQL_FLOAT): 
        case(SQL_DOUBLE):
         data->fno = f_r;
         sqlctype = SQL_C_DOUBLE;
         sqlvaraddr = &data->u.r;
         sqlvaluemax = 0;
         break;
        case(SQL_DATE):
         data->fno = f_d;
         sqlctype = SQL_C_DATE;
         sqlvaraddr = &dsDate;
         sqlvaluemax = SQL_MaxStringLength;
         break;
        case(SQL_TIME):
         data->fno = f_t;
         sqlctype = SQL_C_TIME;
         sqlvaraddr = &tsTime;
         sqlvaluemax = SQL_MaxStringLength;
         break;
        case(SQL_TIMESTAMP):
         data->fno = f_ts;
         sqlctype = SQL_C_TIMESTAMP;
         sqlvaraddr = &tssStamp;
         sqlvaluemax = SQL_MaxStringLength;
         break;
        default                    : break;
        }
   rc = SQLGetData(hstmt,icol,sqlctype,sqlvaraddr,sqlvaluemax,&cbValue);
   switch(rc) {
      case SQL_SUCCESS           : break;
      case SQL_SUCCESS_WITH_INFO : break;
      case SQL_NO_DATA_FOUND     :
//		odbc_RUN_Error(hstmt,PROLOG_FAIL);
		break;
      case SQL_ERROR             : odbc_RUN_Error(hstmt,PROLOG_SQL_ERROR);break;
      case SQL_STILL_EXECUTING   : odbc_RUN_Error(hstmt,PROLOG_SQL_STILL_EXECUTING);break;
      case SQL_INVALID_HANDLE    : odbc_RUN_Error(hstmt,PROLOG_SQL_INVALID_HANDLE);break;
      default                    : odbc_RUN_Error(hstmt,PROLOG_OTHER_ERROR);break;
      }
   if (cbValue == SQL_NULL_DATA)   // The data value is NULL
      data->fno = f_null;
   else
      switch (data->fno) {
         case f_s:
            data->u.s = MEM_SaveStringGStack(szString);
            break;
         case f_d:
            IO_SPrintf(szString,"%-4d-%-2d-%-2d",dsDate.year,dsDate.month,dsDate.day);
            data->u.d = MEM_SaveStringGStack(szString);
            break;
         case f_t:
            IO_SPrintf(szString,"%-2d:%-2d:%-2d",tsTime.hour,tsTime.minute,tsTime.second);
            data->u.t = MEM_SaveStringGStack(szString);
            break;
         case f_ts:
            IO_SPrintf(szString,"%-4d-%-2d-%-2d %-2d:%-2d:%-2d",
                     tssStamp.year,tssStamp.month,tssStamp.day,
                     tssStamp.hour,tssStamp.minute,tssStamp.second);
            data->u.ts = MEM_SaveStringGStack(szString);
            break;
         default:;
         }
   return(data);
}
        
COL_DATA *sql_GetColDataBnd(STMT_HANDLE hstmt, COL_REF icol)
{
	UCHAR				szString[SQL_MaxStringLength];
	DATE_STRUCT 	 *	pdsDate;
	TIME_STRUCT 	 *	ptsTime;
	TIMESTAMP_STRUCT *	ptssStamp;
	COL_DATA		 *	data;
	TABLE_ENTRY		 *	p;
	int					conn;

	data = MEM_AllocGStack(sizeof(COL_DATA));
	data->fno = f_null;

	conn = conn_id_from_stmt(hstmt);
	if (conn<0)
		return(data);

	p = &buf_table[conn][icol-1];
	if (*(SDWORD*)(p->ptr) == SQL_NULL_DATA)
		return(data);

    switch(p->type) {
        case SQL_C_CHAR:
			data->fno = f_s;
			data->u.s = MEM_SaveStringGStack((char*)((p->ptr)+COL_HDR));
			break;
        case SQL_C_SHORT:
			data->fno = f_i;
			data->u.i = *(SWORD*)((p->ptr)+COL_HDR);
			break;
        case SQL_C_LONG:
			data->fno = f_l;
			data->u.l = *(SDWORD*)((p->ptr)+COL_HDR);
			break;
        case SQL_C_DOUBLE:  
			data->fno = f_r;
			data->u.r = *(PDC_DOUBLE*)((p->ptr)+COL_HDR);
			break;
        case SQL_C_DATE:
			data->fno = f_d;
			pdsDate   = (DATE_STRUCT*)((p->ptr)+COL_HDR);
			IO_SPrintf(szString,"%-4d-%-2d-%-2d",pdsDate->year,pdsDate->month,pdsDate->day);
			data->u.d = MEM_SaveStringGStack(szString);
			break;
        case SQL_C_TIME:
			data->fno = f_t;
			ptsTime   = (TIME_STRUCT*)((p->ptr)+COL_HDR);
			IO_SPrintf(szString,"%-2d:%-2d:%-2d",ptsTime->hour,ptsTime->minute,ptsTime->second);
			data->u.t = MEM_SaveStringGStack(szString);
			break;
        case SQL_C_TIMESTAMP:
			data->fno = f_ts;
			ptssStamp  = (TIMESTAMP_STRUCT*)((p->ptr)+COL_HDR);
			IO_SPrintf(szString,"%-4d-%-2d-%-2d %-2d:%-2d:%-2d",
						ptssStamp->year,ptssStamp->month,ptssStamp->day,
						ptssStamp->hour,ptssStamp->minute,ptssStamp->second);
			data->u.ts = MEM_SaveStringGStack(szString);
			break;
        default                    : break;
        }
   return(data);
}
        
void sql_FetchNext(STMT_HANDLE hstmt)
{                
    RETCODE     rc;

    rc = SQLFetch(hstmt);
    switch(rc)
        {
        case SQL_SUCCESS           : break;
        case SQL_SUCCESS_WITH_INFO : break;
        case SQL_NO_DATA_FOUND     : RUN_Fail();break;
        case SQL_STILL_EXECUTING   : odbc_RUN_Error(hstmt,PROLOG_SQL_STILL_EXECUTING);break;
        case SQL_NEED_DATA         : odbc_RUN_Error(hstmt,PROLOG_SQL_NEED_DATA);break;
        case SQL_ERROR             : odbc_RUN_Error(hstmt,PROLOG_SQL_ERROR);break;
        case SQL_INVALID_HANDLE    : odbc_RUN_Error(hstmt,PROLOG_SQL_INVALID_HANDLE);break;
        default                    : odbc_RUN_Error(hstmt,PROLOG_OTHER_ERROR);break;
        }                           
}

void sql_BindCol(STMT_HANDLE hstmt, UWORD icol,SWORD fCType,PTR rgbValue,SDWORD cbValueMax, SDWORD FAR *pcbValue)
{
    RETCODE     rc;
    // FILE         *stream;       
    rc = SQLBindCol(hstmt,icol,fCType,rgbValue,cbValueMax,pcbValue);
    switch(rc)
        {
        case SQL_SUCCESS		: break;
        case SQL_ERROR			: RUN_Error(PROLOG_SQL_ERROR);break;
        case SQL_INVALID_HANDLE	: RUN_Error(PROLOG_SQL_INVALID_HANDLE);break;
        default					: RUN_Error(PROLOG_OTHER_ERROR);break;
        }                           
}

void sql_SetParam(STMT_HANDLE hstmt,UWORD ipar,SWORD fCType,SWORD fSqlType,UDWORD cbColDef,  // )
                  SWORD ibScale,PTR rgbValue,SDWORD FAR *pcbValue)
{
    RETCODE     rc;
    // FILE         *stream;       
    rc = SQLSetParam(hstmt,ipar,fCType,fSqlType,cbColDef,ibScale,rgbValue,pcbValue);
    switch(rc)
        {
        case SQL_SUCCESS		: break;
        case SQL_ERROR			: RUN_Error(PROLOG_SQL_ERROR);break;
        case SQL_INVALID_HANDLE	: RUN_Error(PROLOG_SQL_INVALID_HANDLE);break;
        default					: RUN_Error(PROLOG_OTHER_ERROR);break;
        }                           
}

STRING sql_GetString(STMT_HANDLE hstmt,COL_REF icol)
{   
    SDWORD      cbValue;
    UCHAR       szString[SQL_MaxStringLength];
    RETCODE     rc;
    rc = SQLGetData(hstmt,icol,SQL_C_CHAR,szString,SQL_MaxStringLength,&cbValue);
    switch(rc)
        {
        case SQL_SUCCESS           : break;
        case SQL_SUCCESS_WITH_INFO : break;
        case SQL_NO_DATA_FOUND     : odbc_RUN_Error(hstmt,PROLOG_FAIL);break;
        case SQL_ERROR             : odbc_RUN_Error(hstmt,PROLOG_SQL_ERROR);break;
        case SQL_STILL_EXECUTING   : odbc_RUN_Error(hstmt,PROLOG_SQL_STILL_EXECUTING);break;
        case SQL_INVALID_HANDLE    : odbc_RUN_Error(hstmt,PROLOG_SQL_INVALID_HANDLE);break;
        default                    : odbc_RUN_Error(hstmt,PROLOG_OTHER_ERROR);break;
        }
    return(MEM_SaveStringGStack(szString));
}

STRING sql_GetStringBnd(STMT_HANDLE hstmt,COL_REF icol)
{
	SDWORD	len;
	char	*dest;
	char	*sour;
	int 	conn = conn_id_from_stmt(hstmt);

	if (conn>=0) {

		if ((len = *(SDWORD*)(buf_table[conn][icol-1].ptr))==SQL_NULL_DATA)  // Excl null byte
			return(MEM_SaveStringGStack(" "));
		
		sour = (char*)(buf_table[conn][icol-1].ptr+4);
		dest = MEM_AllocGStack((unsigned)len+1);

		MEM_MovMem(sour,dest,(unsigned)len);
		dest[len] = '\0';

		return(dest);
		}
	else
		return(MEM_SaveStringGStack(" "));
}

SDWORD sql_GetLong(STMT_HANDLE hstmt,COL_REF icol)
{   
    SDWORD      cbValue;
    SDWORD      sLongValue;
    RETCODE     rc;
    rc = SQLGetData(hstmt,icol,SQL_C_LONG,&sLongValue,0,&cbValue);
    switch(rc)
        {
        case SQL_SUCCESS           : break;
        case SQL_SUCCESS_WITH_INFO : break;
        case SQL_NO_DATA_FOUND     : odbc_RUN_Error(hstmt,PROLOG_FAIL);break;
        case SQL_ERROR             : odbc_RUN_Error(hstmt,PROLOG_SQL_ERROR);break;
        case SQL_STILL_EXECUTING   : odbc_RUN_Error(hstmt,PROLOG_SQL_STILL_EXECUTING);break;
        case SQL_INVALID_HANDLE    : odbc_RUN_Error(hstmt,PROLOG_SQL_INVALID_HANDLE);break;
        default                    : odbc_RUN_Error(hstmt,PROLOG_OTHER_ERROR);break;
        }
    return(sLongValue);
}

SDWORD sql_GetLongBnd(STMT_HANDLE hstmt,COL_REF icol)
{   
	int conn = conn_id_from_stmt(hstmt);
	if (conn>=0) {
		if (*(SDWORD*)(buf_table[conn][icol-1].ptr)==SQL_NULL_DATA)  
			return(-1);
		return *(SDWORD*)(buf_table[conn][icol-1].ptr+4);
		}
	else
		return(-1);
}

SWORD sql_GetInteger(STMT_HANDLE hstmt,COL_REF icol)
{   
    SDWORD      cbValue;
    SWORD       sIntegerValue;
    RETCODE     rc;
    rc = SQLGetData(hstmt,icol,SQL_C_SHORT,&sIntegerValue,0,&cbValue);
    switch(rc)
        {
        case SQL_SUCCESS           : break;
        case SQL_SUCCESS_WITH_INFO : break;
        case SQL_NO_DATA_FOUND     : odbc_RUN_Error(hstmt,PROLOG_FAIL);break;
        case SQL_ERROR             : odbc_RUN_Error(hstmt,PROLOG_SQL_ERROR);break;
        case SQL_STILL_EXECUTING   : odbc_RUN_Error(hstmt,PROLOG_SQL_STILL_EXECUTING);break;
        case SQL_INVALID_HANDLE    : odbc_RUN_Error(hstmt,PROLOG_SQL_INVALID_HANDLE);break;
        default                    : odbc_RUN_Error(hstmt,PROLOG_OTHER_ERROR);break;
        }
    return(sIntegerValue);
}

SWORD sql_GetIntegerBnd(STMT_HANDLE hstmt,COL_REF icol)
{   
	int conn = conn_id_from_stmt(hstmt);
	if (conn>=0) {
		if (*(SDWORD*)(buf_table[conn][icol-1].ptr)==SQL_NULL_DATA)  
			return(-1);
		return *(SWORD*)(buf_table[conn][icol-1].ptr+4);
		}
	else
		return(-1);
}

void sql_GetReal(STMT_HANDLE hstmt,COL_REF icol, PDC_DOUBLE* pReal)
{   
    SDWORD      cbValue;
    PDC_DOUBLE  sRealValue;
    RETCODE     rc;
    rc = SQLGetData(hstmt,icol,SQL_C_DOUBLE,&sRealValue,0,&cbValue);
    switch(rc)
        {
        case SQL_SUCCESS           : break;
        case SQL_SUCCESS_WITH_INFO : break;
        case SQL_NO_DATA_FOUND     : odbc_RUN_Error(hstmt,PROLOG_FAIL);break;
        case SQL_ERROR             : odbc_RUN_Error(hstmt,PROLOG_SQL_ERROR);break;
        case SQL_STILL_EXECUTING   : odbc_RUN_Error(hstmt,PROLOG_SQL_STILL_EXECUTING);break;
        case SQL_INVALID_HANDLE    : odbc_RUN_Error(hstmt,PROLOG_SQL_INVALID_HANDLE);break;
        default                    : odbc_RUN_Error(hstmt,PROLOG_OTHER_ERROR);break;
        }
    *pReal = *(PDC_DOUBLE*)&sRealValue;
}

void sql_GetRealBnd(STMT_HANDLE hstmt,COL_REF icol, PDC_DOUBLE* pReal)
{   
    PDC_DOUBLE  sRealValue = {0,0,0,0};

	int conn = conn_id_from_stmt(hstmt);
	if (conn>=0) {
		if (*(SDWORD*)(buf_table[conn][icol-1].ptr)==SQL_NULL_DATA)  
			*pReal = *(PDC_DOUBLE*)&sRealValue;
		*pReal = *(PDC_DOUBLE*)(buf_table[conn][icol-1].ptr+4);
		}
	else 
		*pReal = *(PDC_DOUBLE*)&sRealValue;
}           

STRING sql_GetTime(STMT_HANDLE hstmt,COL_REF icol)
{   
    SDWORD      cbValue;
    TIME_STRUCT Stamp;
    UCHAR       szTime[8];
    RETCODE     rc;
    rc = SQLGetData(hstmt,icol,SQL_C_TIME,&Stamp,SQL_MaxStringLength,&cbValue);
    switch(rc)
        {
        case SQL_SUCCESS:               
        case SQL_SUCCESS_WITH_INFO:
                IO_SPrintf(szTime,"%-2d:%-2d:%-2d",Stamp.hour,Stamp.minute,Stamp.second);
                return(MEM_SaveStringGStack(szTime));
        case SQL_NO_DATA_FOUND:
                break;
        case SQL_ERROR             : odbc_RUN_Error(hstmt,PROLOG_SQL_ERROR);break;
        case SQL_STILL_EXECUTING   : odbc_RUN_Error(hstmt,PROLOG_SQL_STILL_EXECUTING);break;
        case SQL_INVALID_HANDLE    : odbc_RUN_Error(hstmt,PROLOG_SQL_INVALID_HANDLE);break;
        default                    : odbc_RUN_Error(hstmt,PROLOG_OTHER_ERROR);break;
        }
      return(MEM_SaveStringGStack(""));
}

STRING sql_GetTimeBnd(STMT_HANDLE hstmt,COL_REF icol)
{   
	TIME_STRUCT * pStamp;
	UCHAR		szTime[8];
	int conn = conn_id_from_stmt(hstmt);

	if (conn>=0) {
		if (*(SDWORD*)(buf_table[conn][icol-1].ptr)==SQL_NULL_DATA)  
			return(MEM_SaveStringGStack(" "));
		pStamp = (TIME_STRUCT*)(buf_table[conn][icol-1].ptr+4);
		IO_SPrintf(szTime,"%-2d:%-2d:%-2d",pStamp->hour,pStamp->minute,pStamp->second);
		return(MEM_SaveStringGStack(szTime));
		}
	else
		return(MEM_SaveStringGStack(" "));
}

STRING sql_GetDate(STMT_HANDLE hstmt,COL_REF icol)
{   
    SDWORD      cbValue;
    DATE_STRUCT Stamp;
    UCHAR       szDate[10];
    RETCODE     rc;
    rc = SQLGetData(hstmt,icol,SQL_C_DATE,&Stamp,SQL_MaxStringLength,&cbValue);
    switch(rc)
        {
        case SQL_SUCCESS:
        case SQL_SUCCESS_WITH_INFO:
                IO_SPrintf(szDate,"%-4d-%-2d-%-2d",Stamp.year,Stamp.month,Stamp.day);
                return(MEM_SaveStringGStack(szDate));
        case SQL_NO_DATA_FOUND:
                break;
        case SQL_ERROR             : odbc_RUN_Error(hstmt,PROLOG_SQL_ERROR);break;
        case SQL_STILL_EXECUTING   : odbc_RUN_Error(hstmt,PROLOG_SQL_STILL_EXECUTING);break;
        case SQL_INVALID_HANDLE    : odbc_RUN_Error(hstmt,PROLOG_SQL_INVALID_HANDLE);break;
        default                    : odbc_RUN_Error(hstmt,PROLOG_OTHER_ERROR);break;
        }
      return(MEM_SaveStringGStack(""));
}

STRING sql_GetDateBnd(STMT_HANDLE hstmt,COL_REF icol)
{   
	DATE_STRUCT * pStamp;
	UCHAR       szDate[10];
	int conn = conn_id_from_stmt(hstmt);

	if (conn>=0) {
		if (*(SDWORD*)(buf_table[conn][icol-1].ptr)==SQL_NULL_DATA)  
			return(MEM_SaveStringGStack(" "));
		pStamp = (DATE_STRUCT*)(buf_table[conn][icol-1].ptr+4);
		IO_SPrintf(szDate,"%-4d-%-2d-%-2d",pStamp->year,pStamp->month,pStamp->day);
		return(MEM_SaveStringGStack(szDate));
		}
	else
		return(MEM_SaveStringGStack(""));
}

STRING sql_GetTimeStamp(STMT_HANDLE hstmt,COL_REF icol)
{   
    SDWORD      cbValue;
    TIMESTAMP_STRUCT    Stamp;
    UCHAR       szDate[10];
    UCHAR       szTime[8];
    UCHAR       szTimeStamp[19];
    RETCODE     rc;
    rc = SQLGetData(hstmt,icol,SQL_C_TIMESTAMP,&Stamp,SQL_MaxStringLength,&cbValue);
    switch(rc)
        {
        case SQL_SUCCESS:
        case SQL_SUCCESS_WITH_INFO:
                IO_SPrintf(szDate,"%-4d-%-2d-%-2d",Stamp.year,Stamp.month,Stamp.day);
                IO_SPrintf(szTime,"%-2d:%-2d:%-2d",Stamp.hour,Stamp.minute,Stamp.second);
                IO_SPrintf(szTimeStamp,"%s %s",szDate,szTime);
                return(MEM_SaveStringGStack(szTimeStamp));
        case SQL_NO_DATA_FOUND:
                break;
        case SQL_ERROR             : odbc_RUN_Error(hstmt,PROLOG_SQL_ERROR);break;
        case SQL_STILL_EXECUTING   : odbc_RUN_Error(hstmt,PROLOG_SQL_STILL_EXECUTING);break;
        case SQL_INVALID_HANDLE    : odbc_RUN_Error(hstmt,PROLOG_SQL_INVALID_HANDLE);break;
        default                    : odbc_RUN_Error(hstmt,PROLOG_OTHER_ERROR);break;
        }
      return(MEM_SaveStringGStack(""));
}

STRING sql_GetTimeStampBnd(STMT_HANDLE hstmt,COL_REF icol)
{   
	TIMESTAMP_STRUCT *	pStamp;
	UCHAR       szDate[10];
	UCHAR       szTime[8];
	UCHAR       szTimeStamp[19];
	int conn = conn_id_from_stmt(hstmt);

	if (conn>=0) {
		if (*(SDWORD*)(buf_table[conn][icol-1].ptr)==SQL_NULL_DATA)  
			return(MEM_SaveStringGStack(" "));
		pStamp = (TIMESTAMP_STRUCT*)(buf_table[conn][icol-1].ptr+4);
		IO_SPrintf(szDate,"%-4d-%-2d-%-2d",pStamp->year,pStamp->month,pStamp->day);
		IO_SPrintf(szTime,"%-2d:%-2d:%-2d",pStamp->hour,pStamp->minute,pStamp->second);
		IO_SPrintf(szTimeStamp,"%s %s",szDate,szTime);
		return(MEM_SaveStringGStack(szTimeStamp));
		}
	else
		return(MEM_SaveStringGStack(" "));
}            

STRING sql_GetCursorName(STMT_HANDLE hstmt)
{   
    SWORD       cbValue;
    UCHAR       szString[SQL_MaxStringLength];
    RETCODE     rc;
    rc = SQLGetCursorName(hstmt,szString,SQL_MaxStringLength,&cbValue);
    switch(rc)
        {
        case SQL_SUCCESS           : break;
        case SQL_SUCCESS_WITH_INFO : break;
        case SQL_NO_DATA_FOUND     : odbc_RUN_Error(hstmt,PROLOG_FAIL);break;
        case SQL_ERROR             : odbc_RUN_Error(hstmt,PROLOG_SQL_ERROR);break;
        case SQL_STILL_EXECUTING   : odbc_RUN_Error(hstmt,PROLOG_SQL_STILL_EXECUTING);break;
        case SQL_INVALID_HANDLE    : odbc_RUN_Error(hstmt,PROLOG_SQL_INVALID_HANDLE);break;
        default                    : odbc_RUN_Error(hstmt,PROLOG_OTHER_ERROR);break;
        }
    return(MEM_SaveStringGStack(szString));
}

#define MAX_COLUMNS BUF_TABLE_SIZE

PARAM_HANDLE sql_BeginParam(STMT_HANDLE hstmt, COL_DATA_LIST *cdl)
{
	UWORD i=0,j=0;
	UDWORD udwTotalSize=sizeof(UDWORD);	// At least is should contain itself
	COL_DATA *cd;
	SWORD cType[MAX_COLUMNS];
	SWORD sqlType[MAX_COLUMNS];
	UDWORD len[MAX_COLUMNS];
	UDWORD size[MAX_COLUMNS];
	char *ptr[MAX_COLUMNS];
	char *totptr;
	char *tmpptr;

	if (cdl->fno == NILLFNO)
		return(NULL);

	while (cdl->fno == LISTFNO) {
		cd = cdl->data;
		len[i] = 0;
		size[i] = 0;

		switch (cd->fno) {
			case f_s:
				cType[i] = SQL_C_CHAR;
				sqlType[i] = SQL_CHAR;
				len[i] = STR_StrLen(cd->u.s)+1;
				size[i] = len[i];
				break;
			case f_i:
				cType[i] = SQL_C_SHORT;
				sqlType[i] = SQL_SMALLINT;
				size[i] = sizeof(SWORD);
				break;
			case f_l:
				cType[i] = SQL_C_LONG;
				sqlType[i] = SQL_INTEGER;
				size[i] = sizeof(SDWORD);
				break;
			case f_r:
				cType[i] = SQL_C_DOUBLE;
				sqlType[i] = SQL_DOUBLE;
				size[i] = sizeof(PDC_DOUBLE);
				break;
			case f_d:
				cType[i] = SQL_C_CHAR;
				sqlType[i] = SQL_CHAR;
				len[i] = 11;
				size[i] = len[i];
				break;
			case f_t:
				cType[i] = SQL_C_CHAR;
				sqlType[i] = SQL_CHAR;
				len[i] = 9;
				size[i] = len[i];
				break;
			case f_ts:
				cType[i] = SQL_C_CHAR;
				sqlType[i] = SQL_CHAR;
				len[i] = 20;
				size[i] = len[i];
				break;
			}

		udwTotalSize += sizeof(UWORD)+size[i];
		i++;
		cdl = cdl->next;
		}
	totptr = (char*)MEM_AllocHeap((unsigned)udwTotalSize);
	*((UDWORD*)totptr) = udwTotalSize;  // Store size into size field
	tmpptr = totptr + sizeof(UDWORD);	// Bump past the size field

	/* Remember to release this memory again !! */

	for (j=0;j<i;j++) {
		ptr[j] = tmpptr+sizeof(UWORD);	// Store pointer to var's data
		*(UWORD*)tmpptr = (UWORD)size[j]; // Write the var's size within block
		tmpptr += sizeof(UWORD)+size[j];// Point to next var
		}

	/* Specify the storage locations for each parameter */
	for (j=0;j<i;j++)
		sql_SetParam(hstmt,(j+1),cType[j],sqlType[j],len[j],0,ptr[j],NULL);

	return(totptr);
}

void sql_EndParam(PARAM_HANDLE h)
{
	MEM_ReleaseHeap((void*)h,(unsigned)(*(UDWORD*)h));
//	*ph = NULL;	  // As a side effect, set the parameter block handle to NULL
}

void sql_ExecParam(STMT_HANDLE hstmt, PARAM_HANDLE totptr, COL_DATA_LIST *cdl)
{
	UWORD			 i=0;
	COL_DATA 		*cd;
	char 			*p;

	if (cdl->fno == NILLFNO)
		return;

	if (totptr == NULL)
		return;

	p = (char*)totptr+sizeof(UDWORD);

	/* Called for each row of data, given 1) a parameter block returned */
	/* by a call to sql_BeginParam and 2) a list of parameter values */
	/* corresponding to the parameters specified in the parameter block */

	while (cdl->fno == LISTFNO) {
		cd = cdl->data;
		/* Store the var's values into the parameter block's data areas */
		switch (cd->fno) {
			case f_s:
				STR_StrCat0Max((p+sizeof(UWORD)),(cd->u.s), (unsigned)(*(UWORD*)p));
				break;
			case f_i:
				MEM_MovMem(&cd->u.i,(char*)(p+sizeof(UWORD)),(unsigned)sizeof(SWORD));
				break;
			case f_l:
				MEM_MovMem(&cd->u.l,(char*)(p+sizeof(UWORD)),(unsigned)sizeof(SDWORD));
				break;
			case f_r:
				MEM_MovMem(&cd->u.r,(char*)(p+sizeof(UWORD)),(unsigned)sizeof(PDC_DOUBLE));
				break;
			case f_d:
				STR_StrCat0Max((p+sizeof(UWORD)),(cd->u.d), (unsigned)(*(UWORD*)p));
				break;
			case f_t:
				STR_StrCat0Max((p+sizeof(UWORD)),(cd->u.t), (unsigned)(*(UWORD*)p));
				break;
			case f_ts:
				STR_StrCat0Max((p+sizeof(UWORD)),(cd->u.ts), (unsigned)(*(UWORD*)p));
				break;
			}
		/* Move the dest pointer */
		p += *(UWORD*)p + sizeof(UWORD);

		/* Move to next element in list */
		cdl = cdl->next;
		}

	sql_ExecStmt(hstmt);
}
