/*******************************************************************************

                                                COMCOM.C

    Visual Prolog COM utility library module.

    Contains misc. common functions.


  Global Functions :

comutilP_OleInitialize
comutilP_OleUninitialize
comutilP_OleFreeUnusedLibraries
comutilP_OleMemAlloc
comutilP_OleMemFree
comutilP_StringFromGUID
comutilP_SetClassRootRegistryKeyValue
comutilP_DeleteClassRootRegistryKey


    Written by Sergey Verkhovtsev


*******************************************************************************/

#include <windows.h>
#include <tchar.h>


// Useful defines for "pdcrunt.h"
#ifndef WIN32
#define  WIN32
#endif

#ifndef MLINEAR
#define MLINEAR
#endif
// End of useful defines for "pdcrunt.h"

#include <pdcrunt.h>


#define MAX_STRING_LENGTH       512



#define STRCONVERT_MAXLEN 640

static
char* ConvertToAnsi(OLECHAR FAR* szW)
{
  static char achA[STRCONVERT_MAXLEN];

  WideCharToMultiByte(CP_ACP, 0, szW, -1, achA, STRCONVERT_MAXLEN, NULL, NULL);
  return achA;
}

static
OLECHAR* ConvertToUnicode(char FAR* szA)
{
  static OLECHAR achW[STRCONVERT_MAXLEN];

  MultiByteToWideChar(CP_ACP, 0, szA, -1, achW, STRCONVERT_MAXLEN);
  return achW;
}



/*
   Initializes OLE library
*/
int comutilP_OleInitialize ( void )
{
        return OleInitialize(NULL) == S_OK ;
}



/*
   Uninitializes OLE Library
*/
void comutilP_OleUninitialize ( void )
{

        OleUninitialize() ;
}


/*
    Unloads any DLLs that are no longer in use and that, when loaded,
  were specified to be freed automatically.
*/
void comutilP_OleFreeUnusedLibraries ( void )
{
        CoFreeUnusedLibraries();
}


/*
    Allocates memory default OLE task memory allocator.

*/
void* comutilP_OleMemAlloc( unsigned size )
{
        return CoTaskMemAlloc(size) ;
}


/*
    Frees memory allocated by CoTaskMemAlloc

*/
void comutilP_OleMemFree( void* ptr )
{
        CoTaskMemFree(ptr) ;
}



/*
   Creates an instance of the object of the given class returning the pointer to the given interface
*/
HRESULT comutilP_CreateInstance(REFCLSID rclsid,DWORD dwClsContext,REFIID riid,LPVOID * ppv)
{
	return CoCreateInstance(rclsid,NULL,dwClsContext,riid,ppv) ;	
}



HRESULT comutilP_OleCreateGuid( void** dest )
{
  GUID guid ;
  HRESULT res = CoCreateGuid( &guid ) ;
  if( res == S_OK ) {
        *dest = MEM_NewCopyGStack(&guid,sizeof guid) ;
  }
  else {
        *dest = NULL ;
  }

  return res ;
}


/*=============================================================================
  Function: utilIntP_UnicodeToAnsi

  Convert a UNICODE input string to an output ANSI string.

  Args:     LPWSTR pszUc
              Pointer to a caller's input UNICODE wide string.
            LPSTR pszAnsi
              Pointer to a caller's output ANSI string.
            int cch
              Character count. If 0 then use length of pszUc.

  Returns:  HRESULT
              Standard OLE result code. NOERROR for success.
=============================================================================*/

HRESULT utilIntP_UnicodeToAnsi(
          LPWSTR pszUnicode,
          LPSTR pszAnsi,
          int cc)
{
  HRESULT hr = E_FAIL;
  int cSize;
  int cOut;

  if ( !cc )
    cSize = WideCharToMultiByte(CP_ACP,0,pszUnicode,-1,NULL,0,NULL,NULL);
  else
    cSize = cc;

  if (cSize)
  {
    cOut = WideCharToMultiByte(CP_ACP,0,pszUnicode,-1,pszAnsi,cSize,NULL,NULL);
    if (0 != cOut)
      hr = NOERROR;
  }

  return hr;
}


/*=============================================================================
  Internal Utility Function: utilIntP_StringFromGUID2
=============================================================================*/

HRESULT utilIntP_StringFromGUID2(REFGUID guid, LPSTR pszGUID, int cch)
{
  HRESULT hr = E_INVALIDARG;
  LPWSTR  pszUc;

  if ( pszGUID && cch > 0 )
  {
    pszUc = (LPWSTR)CoTaskMemAlloc((cch+1)*sizeof(TCHAR));
        if( pszUc ) {
                hr = StringFromGUID2(guid, pszUc, cch);
        if (SUCCEEDED(hr))
          hr = utilIntP_UnicodeToAnsi(pszUc, pszGUID, cch);
        CoTaskMemFree(pszUc);
        }
        else
                hr = E_OUTOFMEMORY;
  }

  return hr;
}



/*=============================================================================
  Function: comutilP_StringFromGUID
=============================================================================*/

HRESULT comutilP_StringFromGUID( REFGUID guid, char** ppszGUID )
{
  char szGUID[MAX_STRING_LENGTH] ;
  char* pszResult = "" ;


  HRESULT hr = utilIntP_StringFromGUID2(guid,szGUID,MAX_STRING_LENGTH) ;
  if( SUCCEEDED(hr) ) pszResult = szGUID ;
  *ppszGUID = MEM_SaveStringGStack(pszResult) ;

  return hr ;
}



/*=============================================================================
  Function: comutilP_SetClassRootRegistryKeyValue

  Utility function to set a Key, Subkey, and value
            in the system Registry.

  Args:     LPTSTR pszKey,
            LPTSTR pszSubkey,   May be NULL or ""
            LPTSTR pszValue)

  Returns:  BOOL
              TRUE if success; FALSE if not.
=============================================================================*/

BOOL comutilP_SetClassRootRegistryKeyValue(
       LPTSTR pszKey,
       LPTSTR pszSubkey,
       LPTSTR pszValue)
{
  BOOL bOk = FALSE;
  LONG rck_ret;
  HKEY hKey;
  CHAR szKey[MAX_STRING_LENGTH];

  lstrcpy(szKey, pszKey);

  if (pszSubkey && pszSubkey[0] )
  {
    lstrcat(szKey, "\\");
    lstrcat(szKey, pszSubkey);
  }

  rck_ret = RegCreateKeyEx(
         HKEY_CLASSES_ROOT,
         szKey,
         0,
         NULL,
         REG_OPTION_NON_VOLATILE,
         KEY_ALL_ACCESS,
         NULL,
         &hKey,
         NULL);

  if ( pszValue && rck_ret == ERROR_SUCCESS )
  {
    rck_ret = RegSetValueEx(
           hKey,
           NULL,
           0,
           REG_SZ,
           (BYTE *)pszValue,
           (lstrlen(pszValue)+1)*sizeof(TCHAR));
    if (rck_ret == ERROR_SUCCESS)
      bOk = TRUE;
    RegCloseKey(hKey);
  }

  return bOk;
}


/*=============================================================================
  Function: comutilP_DeleteClassRootRegistryKey

  Utility function to delete a Key + Subkey
            in the system Registry.

  Args:     LPTSTR pszKey,
            LPTSTR pszSubkey    May be NULL or ""


  Returns:  BOOL
              TRUE if success; FALSE if not.
=============================================================================*/

BOOL comutilP_DeleteClassRootRegistryKey(
       LPTSTR pszKey,
       LPTSTR pszSubkey
       )
{
  BOOL bOk = FALSE;
  CHAR szKey[MAX_STRING_LENGTH];

  lstrcpy(szKey, pszKey);

  if (pszSubkey && pszSubkey[0] )
  {
    lstrcat(szKey, "\\");
    lstrcat(szKey, pszSubkey);
  }

  if( RegDeleteKey(HKEY_CLASSES_ROOT, szKey) == ERROR_SUCCESS ) bOk = TRUE ;

  return bOk ;
}



void comutilP_StringToBSTR( char* src, BSTR* dest )
{
	*dest = SysAllocString(ConvertToUnicode(src)) ;
}


void comutilP_FreeBSTR( BSTR src )
{
	SysFreeString(src) ;
}