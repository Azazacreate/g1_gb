/******************************************************************************

               Copyright (c) 1984 - 2000 Prolog Development Center A/S

                               ORACLE OCI bindings

 ModuleName: OCIBIND
 FileName: OCIBIND.C
 PURPOSE:  Prolog bindings to OCI API (using V7 OCI routines)
 
 ---------------+------+----------------------------------------------------
  Date Modified,| By,  |  Comments.
 ---------------+------+----------------------------------------------------
  14-11-1994    | LHJ  |  Built on top of odbcbind
  14-02-1995    | LHJ  |  Use Indicator variables for odefin (sql_BindCol), 
                |      |  avoiding NULL errors.
  02-03-1995    | LHJ  |  New functions: sql_ConnectOldStyle (OCI only)
  06-03-1995    | LHJ  |  Correct sql_ConnectOldStyle (OCI only)
  25-03-1997    | TLP  |  Correction of Collumn bindings
                |      |
******************************************************************************/



#if defined (__IBMC__)
#define UNDERSCORES 1
#define with_prologstuff 1
#include "ibmmap.h"
typedef unsigned char       BYTE;
typedef unsigned short      WORD;
typedef unsigned long       DWORD;
#endif

#if !defined (__IBMC__)
#include "windows.h"
#endif
#include "stdio.h"
#include "string.h"
#include "oratypes.h"
#include "ocidfn.h"
#include "ociapr.h"
#include "time.h"
#include "pdcrunt.h"

#define LISTFNO 1
#define NILLFNO 2
    
#define USING_DEFERRED 1

#define V6_BEHAVIOR 0
#define NORMAL_BEHAVIOR 1
#define V7_BEHAVIOR 2

#define OCI_SUCCESS			0
#define OCIV2_NO_MORE_DATA	4
#define OCI_VAR_NOT_IN_LIST	1007
#define OCI_NO_MORE_DATA	1403
#define OCI_COLVALUE_NULL	1405
#define OCI_INDVALUE_NULL	-1

typedef Lda_Def OCIFAR * DBC_HANDLE;   // equivalent to Oracle Logon Data Area, LDA
#define DBC_HANDLE_DEF
typedef Cda_Def OCIFAR * STMT_HANDLE;  // equivalent to Oracle Cursor Data Area, CDA
#define STMT_HANDLE_DEF


typedef unsigned int  UWORD;
typedef long int      SDWORD;
typedef int           SWORD;
typedef void far    * PTR;
typedef unsigned long UDWORD;

#include "sqlbind.h"    

static char OCIerror[255] = "";

static STMT_HANDLE hstmtError=0;

static int db_connections = 0;

typedef struct table_entry_struct {	// SELECT column data
	SDWORD	length;					//    Length of data for this column
	SWORD	type;					//    Type of data for this column
	sb2 ind; //  Indicator value
	ub2 rlen; // length of returned data
	ub2 rcode; // column return code
	ub1* ptr;					//    Pointer to data for this column
} TABLE_ENTRY;

typedef struct select_struct {	// Data for one select 
   STMT_HANDLE	hstmt;				//    Current SELECT statement handle (CURSOR)
   SWORD		numCols;			//    Current number of used columns
   SDWORD		table_length;		//    Current length of SELECT column data
   char			*ptr;				//    Pointer to SELECT column data
};

typedef struct conn_entry_struct {	// Data for one connection
   DBC_HANDLE	hdbc;				//    Connection handle (LDA)
   char			*hda;				//    Host Data Area (ORACLE ONLY)
   struct select_struct ss;			//    Current SELECT statement handle
} CONN_ENTRY;

typedef struct col_desc_struct {	// Description for one column
    UCHAR	szColName[SQL_MaxStringLength];
    SDWORD	cbColName;
    SWORD	fSqlType;
    SWORD	ibPrec;		// Precision (ORACLE)
    SWORD	ibScale;
    SWORD	fNullable;
    SDWORD	cbColDef;
    SDWORD	dsize;		// Display size (ORACLE)
} COL_DESC, *PCOL_DESC;

#define BUF_TABLE_SIZE     50
#define MAX_DB_CONNECTIONS  3

static TABLE_ENTRY buf_table[MAX_DB_CONNECTIONS][BUF_TABLE_SIZE];	// SELECT column data
static CONN_ENTRY  conn_table[MAX_DB_CONNECTIONS];					// Data for all connections

static void oci_BindCol(STMT_HANDLE hstmt, UWORD icol, TABLE_ENTRY* entry);

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
	if (conn>=0) {
		MEM_ReleaseHeap(conn_table[conn].hdbc,(unsigned)sizeof(Lda_Def));
		if (conn_table[conn].hda != NULL)
			MEM_ReleaseHeap(conn_table[conn].hda,(unsigned)256);
		conn_table[conn].hdbc = (DBC_HANDLE)0;
		conn_table[conn].hda  = NULL;
		}
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

static SWORD SQLType2CType(COL_DESC *psColDesc, SDWORD *len)
{
	switch(psColDesc->fSqlType) {
		case SQLT_NUM :     //	2	NUMBER
			if (((psColDesc->ibPrec==0) && (psColDesc->ibScale==0)) ||
				(psColDesc->ibScale!=0) ||
				(psColDesc->ibPrec>9)) {
				*len = sizeof(PDC_DOUBLE);
				return SQL_RealType;
				}
			else
				if (psColDesc->ibPrec>4) {
					*len = sizeof(SDWORD);
					return SQL_LongType;
					}
				else {
					*len = sizeof(SWORD);
					return SQL_IntegerType;
					}
		case SQLT_CHR :     //	1	VARCHAR2
		case SQLT_LNG :     //	8	LONG
		case SQLT_RID :		//	11	ROWID
		case SQLT_DAT :		// 	12	DATE
		case SQLT_BIN : 	//	23	RAW
		case SQLT_LBI : 	//	24	LONG RAW
		case SQLT_AFC : 	//	96	ANSI FIXED CHAR
			*len = psColDesc->cbColDef+1;
			return SQL_StringType;
		default :
			*len = psColDesc->cbColDef;
			return SQL_StringType;
		}
	return(0);
}

static SWORD CType2SQLType(SWORD CType)
{
	switch(CType) {
		case SQL_StringType:
			return SQLT_STR;
		case SQL_LongType:
		case SQL_IntegerType:
			return SQLT_INT;
		case SQL_RealType:
			return SQLT_FLT;
		default : ;
		}
	return(0);
}

static void odbc_RUN_Error(STMT_HANDLE hstmt, unsigned errorno)
{
    hstmtError = hstmt;
    RUN_Error(errorno);
}

static int is_string_type(SWORD colCTyp)
{
	if (colCTyp == SQL_StringType)
		return(1);
	else
		return(0);
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
		if (is_string_type((pList->p)->colCTyp))
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

static SWORD describe(STMT_HANDLE hstmt, UWORD icol, COL_DESC *psColDesc)
{
	psColDesc->cbColName = SQL_MaxStringLength;  // Used for IN/OUT

	odescr(hstmt, (sword)icol, (sb4*)&(psColDesc->cbColDef),
				(sb2*)&(psColDesc->fSqlType),(sb1*)psColDesc->szColName,
				(sb4*)&(psColDesc->cbColName),(sb4*)&(psColDesc->dsize),
				(sb2*)&(psColDesc->ibPrec), (sb2*)&(psColDesc->ibScale),
				(sb2*)&(psColDesc->fNullable));
	return (hstmt->rc);
}

static void stmt_bind_cols(DBC_HANDLE hdbc, STMT_HANDLE hstmt, UCHAR szSqlStr[])
{
	SWORD       RC;
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
//			swCols = sql_NumCols(hstmt);			// How many columns ?
			conn_table[conn].ss.hstmt = hstmt;

			// For each column:
			dwSqlDataSize = 0;
			for (uwCol = 1; uwCol <= BUF_TABLE_SIZE; uwCol++) {
				RC = describe(hstmt, uwCol, &sColDesc);
				if (RC == OCI_VAR_NOT_IN_LIST)
					break;	// Break on end of select list
				else
					if (RC != OCI_SUCCESS)
						odbc_RUN_Error(hstmt,PROLOG_SQL_ERROR);

				swCType = SQLType2CType(&sColDesc,&dwLength);

				// Store length of each column data
				buf_table[conn][(int)uwCol-1].length = dwLength;
				buf_table[conn][(int)uwCol-1].type = swCType;
	
				// Accumulate length of returned data buffer
				// (add 4 for a SDWORD of length of returned data set by SQLBindCol 
				//  and 2 for a WORD of column return code such as null_value)
				//   +----+----+----+------------+----+----+----+-----+----+----+----+---------+---
				//   |len1|rcd1|ind1| data col 1 |len2|rcd2|ind2|data2|len3|rcd3|ind3| data 3  |
				//   +----+----+----+------------+----+----+----+-----+----+----+----+---------+---
				//    \  / \  / \  / \           /
				//     4    2    2      dwLength
				dwSqlDataSize += dwLength;
				}
			conn_table[conn].ss.numCols = uwCol-1;
			}
		else {		// numCols > 0 because set_coldescr was called
			dwSqlDataSize = 0;
			for (uwCol = 1; uwCol <= (UWORD)conn_table[conn].ss.numCols; uwCol++) {
				dwSqlDataSize += buf_table[conn][uwCol-1].length;
				}
			}
		conn_table[conn].ss.ptr = (char*)MEM_AllocHeap((unsigned)dwSqlDataSize);
		conn_table[conn].ss.table_length = dwSqlDataSize;
		// Start binding columns
		dwSqlDataSize = 0;
		for (uwCol = 1; uwCol <= (UWORD)conn_table[conn].ss.numCols; uwCol++) {
			// Set ptr to data for this column
			buf_table[conn][uwCol-1].ptr = conn_table[conn].ss.ptr + dwSqlDataSize;
			oci_BindCol(hstmt, uwCol, &buf_table[conn][uwCol-1]);
			dwSqlDataSize += buf_table[conn][uwCol-1].length;
			}
		}
	else {
		conn_table[conn].ss.hstmt = (STMT_HANDLE)0;
		conn_table[conn].ss.numCols = 0;
		}
}

static STMT_HANDLE open_cursor(DBC_HANDLE hdbc)
{
	int conn = conn_id(hdbc);

	STMT_HANDLE hstmt = MEM_AllocHeap(sizeof(Cda_Def));

	if (oopen(hstmt, hdbc, NULL, -1, -1, NULL, -1))
		odbc_RUN_Error(hstmt,PROLOG_SQL_ERROR);

    conn_table[conn].ss.hstmt = hstmt;

	return(hstmt);
}

static int is_null_value(TABLE_ENTRY* p)
{
	return (p->rcode == OCI_COLVALUE_NULL) || (p->ind == OCI_INDVALUE_NULL);
}

// *** sql_NativeError ***
// Returns a Native Error Code (Specific to the data source)

SDWORD sql_NativeError(DBC_HANDLE hdbc, STMT_HANDLE hstmt)
{
	hdbc = hdbc;

	return (SDWORD)(hstmt->rc);
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
	char	errmsg[SQL_MaxErrorMessageLength];
    STMT_HANDLE  hstmt_error=(hstmt==(STMT_HANDLE)sql_nullHandle?hstmtError:hstmt);

	if (hstmt_error)
		oerhms(hdbc, hstmt_error->rc, (char far *)errmsg, sizeof(errmsg)-1);
	else
		STR_StrCat0(errmsg,"Not an ORACLE error.");

	hstmtError = (STMT_HANDLE)0;

	*phstmtError = hstmt_error;
    return(MEM_SaveStringGStack(errmsg));
}

DBC_HANDLE sql_Connect(UCHAR szDatabase[],UCHAR szUser[],UCHAR szPassword[])
{
	int conn;
	DBC_HANDLE hdbc;
    char buf[255];
	char *hda;

	if (db_connections==MAX_DB_CONNECTIONS)
		odbc_RUN_Error((STMT_HANDLE)0,PROLOG_SQL_MAX_CONNECTIONS);

	hdbc = (DBC_HANDLE)MEM_AllocHeap(sizeof(Lda_Def));	// hdbc is the LDA
	hda  = MEM_AllocHeap(256);	// Host Data Area

	STR_StrCat0(buf,(char*)szUser);
    STR_StrCat(buf,"@");
    STR_StrCat(buf,(char *) szDatabase);

	if (orlon(hdbc, (ub1 OCIFAR *)hda, (char OCIFAR *)buf, -1, (char OCIFAR *)szPassword, -1, 0))
		odbc_RUN_Error((STMT_HANDLE)hdbc,PROLOG_SQL_ERROR);

	// Now we're logged on 

	init_conn(hdbc);     // Also increments db_connections
	conn = conn_id(hdbc);
	conn_table[conn].hda = hda;	// hdbc and hda goes in pairs

	return(hdbc);
}


DBC_HANDLE sql_ConnectOldStyle(UCHAR szDatabase[],UCHAR szUser[],UCHAR szPassword[])
{
	int conn;
	DBC_HANDLE hdbc;
    char buf[255];

	if (db_connections > 0)		// olon requires only one connection active
		odbc_RUN_Error((STMT_HANDLE)0,PROLOG_SQL_MAX_CONNECTIONS);

	hdbc = (DBC_HANDLE)MEM_AllocHeap(sizeof(Lda_Def));	// hdbc is the LDA

	STR_StrCat0(buf,(char*)szUser);
    STR_StrCat(buf,"@");
    STR_StrCat(buf,(char *) szDatabase);
	if (olon(hdbc, (char OCIFAR *)buf, -1, (char OCIFAR *)szPassword, -1, -1))
		odbc_RUN_Error((STMT_HANDLE)hdbc,PROLOG_SQL_ERROR);

	// Now we're logged on 

	init_conn(hdbc);     // Also increments db_connections
	conn = conn_id(hdbc);
	conn_table[conn].hda = NULL;	// No hda here

	return(hdbc);
}


void sql_Disconnect(DBC_HANDLE hdbc)
{  
	if (ologof(hdbc))
		odbc_RUN_Error((STMT_HANDLE)hdbc,PROLOG_SQL_ERROR);

	close_conn(hdbc);    // Frees local storage and decrements db_connections
}


void sql_Commit(DBC_HANDLE hdbc)
{    
	if (ocom(hdbc))
		odbc_RUN_Error((STMT_HANDLE)hdbc,PROLOG_SQL_ERROR);
}

void sql_RollBack(DBC_HANDLE hdbc)
{
	if (orol(hdbc))
		odbc_RUN_Error((STMT_HANDLE)hdbc,PROLOG_SQL_ERROR);
}

void sql_Drop(STMT_HANDLE hstmt)
	{
	int conn;
    
	conn = conn_id_from_stmt(hstmt);
	conn_clear_select(conn);

	if (oclose(hstmt)) {
		conn_table[conn].hdbc->rc = hstmt->rc;
		MEM_ReleaseHeap(hstmt,sizeof(Cda_Def));
		odbc_RUN_Error((STMT_HANDLE)conn_table[conn].hdbc,PROLOG_SQL_ERROR);
		}

		// oclose: Disconnect a cursor from the data areas with which it
		// is associated (by a call to oopen).

	MEM_ReleaseHeap(hstmt,sizeof(Cda_Def));
}

void sql_Close(STMT_HANDLE hstmt)
   {
	conn_clear_select(conn_id_from_stmt(hstmt));

	if (ocan(hstmt))
		odbc_RUN_Error(hstmt,PROLOG_SQL_ERROR);

		// ocan: Cancel a query after the desired number of rows have been 
		// fetched (discard all pending results).
		// Keeps the cursor associated with its parsed represenation
		// in the shared SQL area.
}

STMT_HANDLE sql_Prepare(DBC_HANDLE hdbc, UCHAR szSqlStr[])
{
    STMT_HANDLE	hstmt;

	hstmt = open_cursor(hdbc);
	if (oparse(hstmt,szSqlStr,(sb4)-1,(sword)USING_DEFERRED,(ub4)V7_BEHAVIOR))
		odbc_RUN_Error(hstmt,PROLOG_SQL_ERROR);

    return(hstmt);
}

STMT_HANDLE sql_Exec(DBC_HANDLE hdbc, UCHAR szSqlStr[])
{
	COL_BIND_DESCR_LIST *pList;

	pList = (COL_BIND_DESCR_LIST*)MEM_AllocGStack(sizeof(pList->fno));
	pList->fno = NILLFNO;

    return sql_ExecBnd(hdbc, szSqlStr, pList);
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

void sql_ExecStmt(STMT_HANDLE hstmt)
{
	if (oexec(hstmt))
		odbc_RUN_Error(hstmt,PROLOG_SQL_ERROR);
}

void sql_ExecStmtBnd(STMT_HANDLE hstmt, UCHAR szSqlStr[], COL_BIND_DESCR_LIST *pList)
{
// hstmt must have been previously allocated (by open_cursor) and free of pending resultsets (closed by ocan)
	int	conn;

	conn = conn_id_from_stmt(hstmt);
	if (conn<0)
		return;
	// is it OK to call oparse after ocan on the same cursor ?
	if (oparse(hstmt,szSqlStr,(sb4)-1,(sword)USING_DEFERRED,(ub4)V7_BEHAVIOR))
		odbc_RUN_Error(hstmt,PROLOG_SQL_ERROR);
	set_coldescr(hstmt, pList);
	stmt_bind_cols(conn_table[conn].hdbc, hstmt, szSqlStr);
	sql_ExecStmt(hstmt);
}

void sql_ExecDirectStmt(STMT_HANDLE hstmt, UCHAR szSqlStr[])
{
	if (oparse(hstmt,szSqlStr,(sb4)-1,(sword)USING_DEFERRED,(ub4)V7_BEHAVIOR))
		odbc_RUN_Error(hstmt,PROLOG_SQL_ERROR);
	sql_ExecStmt(hstmt);
}

STMT_HANDLE sql_ExecDirect(DBC_HANDLE hdbc, UCHAR szSqlStr[])
{
    STMT_HANDLE	hstmt;

	hstmt = sql_Exec(hdbc,szSqlStr);
	if (StrNCmp(szSqlStr,"SELECT",6)!=0) {    // This is not a SELECT statement
		sql_Drop(hstmt);              // close the statement handle, we don't need it
		return (STMT_HANDLE)0;
		}
    else return(hstmt);
}


SWORD sql_NumCols(STMT_HANDLE hstmt)
{
	COL_DESC sColDesc;
	SWORD    pos;

	for ( pos=1; pos<=BUF_TABLE_SIZE; pos++) {
		sColDesc.cbColName = SQL_MaxStringLength;  // Used for IN/OUT
		if (odescr(hstmt, pos, (sb4*)&(sColDesc.cbColDef),
					(sb2*)&(sColDesc.fSqlType),(sb1*)sColDesc.szColName,
					(sb4*)&(sColDesc.cbColName),(sb4*)&(sColDesc.dsize),
					(sb2*)&(sColDesc.ibPrec), (sb2*)&(sColDesc.ibScale),
					(sb2*)&(sColDesc.fNullable)))
			// Break on end of select list
			if (hstmt->rc == OCI_VAR_NOT_IN_LIST)
				break;
			else
				odbc_RUN_Error(hstmt,PROLOG_SQL_ERROR);
		}
    return(pos-1);
}

STRING sql_ColName(STMT_HANDLE hstmt, COL_REF icol)
{
	COL_DESC sColDesc;

	describe(hstmt, icol, &sColDesc);
    return(MEM_SaveStringGStack(sColDesc.szColName));
}

SDWORD sql_ColWidth(STMT_HANDLE hstmt, COL_REF icol)
{
	COL_DESC sColDesc;

	describe(hstmt, icol, &sColDesc);
	return(sColDesc.cbColDef);
}

COL_DATA *sql_GetColData(STMT_HANDLE hstmt, COL_REF icol)
{
	return sql_GetColDataBnd(hstmt, icol);
}
        
COL_DATA *sql_GetColDataBnd(STMT_HANDLE hstmt, COL_REF icol)
{
/*
	UCHAR				szString[SQL_MaxStringLength];
	DATE_STRUCT 	 *	pdsDate;
	TIME_STRUCT 	 *	ptsTime;
	TIMESTAMP_STRUCT *	ptssStamp;
*/
	COL_DATA		 *	data;
	TABLE_ENTRY		 *	p;
	int					conn;

	data = MEM_AllocGStack(sizeof(COL_DATA));
	data->fno = f_null;

	conn = conn_id_from_stmt(hstmt);
	if (conn<0)
		return(data);

	p = &buf_table[conn][icol-1];
	if (is_null_value(p))
		return(data);

    switch(p->type) {
        case SQL_StringType:
			data->fno = f_s;
			data->u.s = MEM_SaveStringGStack((char*)(p->ptr));
			break;
        case SQL_IntegerType:
			data->fno = f_i;
			data->u.i = *(SWORD*)(p->ptr);
			break;
        case SQL_LongType:
			data->fno = f_l;
			data->u.l = *(SDWORD*)(p->ptr);
			break;
        default:
			break;
        }
   return(data);
}
        
void sql_FetchNext(STMT_HANDLE hstmt)
{
	SWORD rc;

	rc = ofetch(hstmt);
	switch (rc) {
		case OCI_SUCCESS: 		break;
		case OCI_COLVALUE_NULL: break;	// Probably not returned because we use the column indicator field
		case OCIV2_NO_MORE_DATA:
		case OCI_NO_MORE_DATA:	RUN_Fail();break;
		default:
//			odbc_RUN_Error(hstmt,PROLOG_SQL_ERROR);
			odbc_RUN_Error(hstmt,rc);
		}
}

void oci_BindCol(
		STMT_HANDLE hstmt,
		UWORD icol,
		TABLE_ENTRY* entry)
{
	SWORD fSQLType = CType2SQLType(entry->type);

	int rcode = odefin(
	        // cursor
		    hstmt,
			// pos
			(sword)icol,
			// buf
			entry->ptr,
			//bufl
			entry->length,
			// ftype
			fSQLType,
			// scale
			(sword)-1,
			// indp
			&(entry->ind),
			// fmt
			(text*)0,
			// fmtl
			(sword)-1,
			// fmtt
			(sword)-1,
			// rlen
		    &(entry->rlen),
			// rcode
			&(entry->rcode));
	
	if (rcode)
		odbc_RUN_Error(hstmt,PROLOG_SQL_ERROR);
}

COL_TYPE sql_ColType(STMT_HANDLE hstmt, COL_REF icol)
{
/*
	COL_DESC sColDesc;

	describe(hstmt, iCol, &sColDesc);
	if (sColDesc.ibPrec)


    switch(sColDesc.fSqlType)
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
*/
   return(0);   // Never reached, just to please compiler
}


void sql_SetParam(STMT_HANDLE hstmt,UWORD ipar,SWORD fCType,SWORD fSqlType,UDWORD cbColDef,  // )
                  SWORD ibScale,PTR rgbValue,SDWORD FAR *pcbValue)
{
/*
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
*/
}

TABLE_ENTRY* oci_GetEntry(STMT_HANDLE hstmt,COL_REF icol)
{   
	int conn = conn_id_from_stmt(hstmt);

	if (conn>=0)
		return &buf_table[conn][icol-1];
	else
		return NULL;
}

ub1* oci_GetPtr(STMT_HANDLE hstmt,COL_REF icol)
{   
	TABLE_ENTRY * p = oci_GetEntry(hstmt, icol);
	if ( is_null_value(p))
		return NULL;
	else
		return p->ptr;
}

STRING sql_GetString(STMT_HANDLE hstmt,COL_REF icol)
{   
	return sql_GetStringBnd(hstmt,icol);
}

STRING sql_GetStringBnd(STMT_HANDLE hstmt,COL_REF icol)
{
	SDWORD	len;
	char	*dest;
	char	*sour;
	TABLE_ENTRY * p = oci_GetEntry(hstmt, icol);

	if (is_null_value(p))
		return(MEM_SaveStringGStack(""));
		
	len  = p->rlen;	// Excl null byte
	sour = (char*)p->ptr;
	dest = MEM_AllocGStack((int)len+1);
	MEM_MovMem(sour, dest, (unsigned)len);
	dest[len] = '\0';

	return(dest);
}

SDWORD sql_GetLong(STMT_HANDLE hstmt,COL_REF icol)
{   
	return sql_GetLongBnd(hstmt,icol);
}

SDWORD sql_GetLongBnd(STMT_HANDLE hstmt,COL_REF icol)
{   
	SDWORD* ptr = (SDWORD*) oci_GetPtr(hstmt, icol);
	if (ptr)
		return *ptr;
	else
		return (SDWORD) 0;
}

SWORD sql_GetInteger(STMT_HANDLE hstmt,COL_REF icol)
{   
	return sql_GetIntegerBnd(hstmt,icol);
}

SWORD sql_GetIntegerBnd(STMT_HANDLE hstmt,COL_REF icol)
{   
	SWORD* ptr = (SWORD*) oci_GetPtr(hstmt, icol);
	if (ptr)
		return *ptr;
	else
		return (SWORD) 0;
}

void sql_GetReal(STMT_HANDLE hstmt,COL_REF icol, PDC_DOUBLE* pReal)
{   
	sql_GetRealBnd(hstmt,icol,pReal);
}

void sql_GetRealBnd(STMT_HANDLE hstmt,COL_REF icol, PDC_DOUBLE* pReal)
{   
    PDC_DOUBLE  sRealValue = {0,0,0,0};

	PDC_DOUBLE* ptr = (PDC_DOUBLE*) oci_GetPtr(hstmt, icol);
	if (ptr)
		*pReal = *ptr;
	else
		*pReal = sRealValue;
}           

STRING sql_GetTime(STMT_HANDLE hstmt,COL_REF icol)
{   
	return sql_GetTimeBnd(hstmt,icol);
}

STRING sql_GetTimeBnd(STMT_HANDLE hstmt,COL_REF icol)
{
/*
	TABLE_ENTRY * p;
	TIME_STRUCT * pStamp;
	UCHAR		szTime[8];
	int conn = conn_id_from_stmt(hstmt);

	if (conn>=0) {
		p = &buf_table[conn][icol-1];
		
		if (is_null_value(p))
			return(MEM_SaveStringGStack(" "));
		pStamp = (TIME_STRUCT*)((ub1*)(p->ptr)+COL_HDR);
		IO_SPrintf(szTime,"%-2d:%-2d:%-2d",pStamp->hour,pStamp->minute,pStamp->second);
		return(MEM_SaveStringGStack(szTime));
		}
	else
*/
		return(MEM_SaveStringGStack(" "));
}

STRING sql_GetDate(STMT_HANDLE hstmt,COL_REF icol)
{   
	return sql_GetDateBnd(hstmt,icol);
}

STRING sql_GetDateBnd(STMT_HANDLE hstmt,COL_REF icol)
{
/*
	TABLE_ENTRY * p;
	DATE_STRUCT * pStamp;
	UCHAR       szDate[10];
	int conn = conn_id_from_stmt(hstmt);

	if (conn>=0) {
		p = &buf_table[conn][icol-1];

		if (is_null_value(p))
			return(MEM_SaveStringGStack(" "));
		pStamp = (DATE_STRUCT*)((ub1*)(p->ptr)+COL_HDR);
		IO_SPrintf(szDate,"%-4d-%-2d-%-2d",pStamp->year,pStamp->month,pStamp->day);
		return(MEM_SaveStringGStack(szDate));
		}
	else
*/
		return(MEM_SaveStringGStack(""));
}

STRING sql_GetTimeStamp(STMT_HANDLE hstmt,COL_REF icol)
{   
	return sql_GetTimeStampBnd(hstmt,icol);
}

STRING sql_GetTimeStampBnd(STMT_HANDLE hstmt,COL_REF icol)
{
/*
	TABLE_ENTRY * p;
	TIMESTAMP_STRUCT *	pStamp;
	UCHAR       szDate[10];
	UCHAR       szTime[8];
	UCHAR       szTimeStamp[19];
	int conn = conn_id_from_stmt(hstmt);

	if (conn>=0) {
		p = &buf_table[conn][icol-1];

		if (is_null_value(p))
			return(MEM_SaveStringGStack(" "));
		pStamp = (TIMESTAMP_STRUCT*)((ub1*)(p->ptr)+COL_HDR);
		IO_SPrintf(szDate,"%-4d-%-2d-%-2d",pStamp->year,pStamp->month,pStamp->day);
		IO_SPrintf(szTime,"%-2d:%-2d:%-2d",pStamp->hour,pStamp->minute,pStamp->second);
		IO_SPrintf(szTimeStamp,"%s %s",szDate,szTime);
		return(MEM_SaveStringGStack(szTimeStamp));
		}
	else
*/
		return(MEM_SaveStringGStack(" "));
}            

STRING sql_GetCursorName(STMT_HANDLE hstmt)
{   
    return(MEM_SaveStringGStack(""));
}

