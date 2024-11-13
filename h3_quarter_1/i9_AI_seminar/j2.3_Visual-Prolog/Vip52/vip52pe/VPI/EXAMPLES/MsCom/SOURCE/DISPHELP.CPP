/******************************************************************************
                                 DISPHELP.CPP


    General prolog helper procedures to create automation objects and to invoke
their methods and property accessor functions .

    The module is written for usage in WIN32 ANSI systems (WIN95 and NT).
******************************************************************************/


#include <windows.h>
#include <windowsx.h>

// Useful defines for "pdcrunt.h"
#ifndef WIN32
#define  WIN32
#endif

#ifndef MLINEAR
#define MLINEAR
#endif
// End of useful defines for "pdcrunt.h"

#include <pdcrunt.h>


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
 * comutilP_CreateAutomationObject
 *
 * Purpose:
 *  Creates an instance of the Automation object and obtains it's IDispatch interface.
 *
 * Parameters:
 *  pszProgID         ProgID of Automation object
 *  ppdisp             Returns IDispatch of Automation object
 *
 * Return Value:
 *  HRESULT indicating success or failure
 */
extern "C"
HRESULT comutilP_CreateAutomationObject(/*LPOLESTR pszProgID*/char* pId, IDispatch** ppdisp)
{
    CLSID clsid;                   
    HRESULT hr;
    LPUNKNOWN punk = NULL;         
    LPDISPATCH pdisp = NULL;       
    LPOLESTR pszProgID ; 


    *ppdisp = NULL;
    pszProgID = ConvertToUnicode(pId) ;

    hr = CLSIDFromProgID(pszProgID, &clsid);
    if (FAILED(hr))
        goto error;

    hr = CoCreateInstance(clsid, NULL, CLSCTX_SERVER,
                          IID_IUnknown, (void**)&punk);
    if (FAILED(hr))
        goto error;

    hr = punk->QueryInterface(IID_IDispatch, (void**)&pdisp);
    if (FAILED(hr))
        goto error;

    *ppdisp = pdisp;
    punk->Release();
    return NOERROR;

error:
    if (punk) punk->Release();
    if (pdisp) pdisp->Release();
    return hr;
}

//
//  Internal representation of Prolog vpcD_VariantArg domain.
//
struct vpcD_VariantArg {
  unsigned char vt ;
  union {
      short   i2 ;                  //  2 byte signed int
      long    i4 ;                  //  4 byte signed int
      double  r4 ;                  //  represents 4 byte real
      double  r8 ;                  //  8 byte real
      DWORD   cy  ;                 //  currency*
      double  date ;                //  date
      char*   bstr  ;               //  OLE Automation string
      DWORD   dispatch  ;           //  IDispatch*
      long    error ;               //  SCODE
      int     bool ;                //  True=-1  False=0
      DWORD   variant  ;            //  variant*
      DWORD   unknown  ;            //  IUnknown*
      byte    ui1      ;            //  unsigned char
      DWORD   array    ;            //  SAFEARRAY*
      DWORD   i2ref  ;              //  Pointer to 2 byte signed int
      DWORD   i4ref  ;              //  Pointer to 4 byte signed int
      DWORD   r4ref  ;              //  Pointer to 4 byte real
      DWORD   r8ref  ;              //  Pointer to 8 byte real
      DWORD   cyref  ;              //  Pointer to currency*
      DWORD   dateref  ;            //  Pointer to date (double)
      DWORD   bstrref  ;            //  Pointer to OLE Automation string
      DWORD   dispatchref  ;        //  Pointer to IDispatch*
      DWORD   errorref  ;           //  Pointer to SCODE
      DWORD   boolref  ;            //  Pointer to INTEGER ( True=-1  False=0 )
      DWORD   variantref  ;         //  Pointer to variant*
      DWORD   unknownref  ;         //  Pointer to IUnknown*
      DWORD   ui1ref       ;        //  Pointer to unsigned char
      DWORD   arrayref    ;         //  Pointer to SAFEARRAY*
  } vv ;
} ;

//
//  Possible values of vt flag .
//
#define vpcC_VT_EMPTY       1
#define vpcC_VT_NULL        2
#define vpcC_VT_I2          3
#define vpcC_VT_I4          4
#define vpcC_VT_R4          5
#define vpcC_VT_R8          6
#define vpcC_VT_CY          7
#define vpcC_VT_DATE        8
#define vpcC_VT_BSTR        9
#define vpcC_VT_DISPATCH    10
#define vpcC_VT_ERROR       11
#define vpcC_VT_BOOL        12
#define vpcC_VT_VARIANT     13
#define vpcC_VT_UNKNOWN     14
#define vpcC_VT_UI1         15
#define vpcC_VT_ARRAY       16
#define vpcC_VT_I2REF       17
#define vpcC_VT_I4REF       18
#define vpcC_VT_R4REF       19
#define vpcC_VT_R8REF       20
#define vpcC_VT_CYREF       21
#define vpcC_VT_DATEREF     22
#define vpcC_VT_BSTRREF     23
#define vpcC_VT_DISPATCHREF 24
#define vpcC_VT_ERRORREF    25
#define vpcC_VT_BOOLREF     26
#define vpcC_VT_VARIANTREF  27
#define vpcC_VT_UNKNOWNREF  28
#define vpcC_VT_UI1REF      29
#define vpcC_VT_ARRAYREF    30

struct vpcD_VariantArgListNode {
 unsigned char fno ;
 vpcD_VariantArg* va ;
 vpcD_VariantArgListNode* next ;
} ;

// Values for fno
#define LISTFNO  1
#define NILFNO   2

//
//  Internal representation of Prolog vpcD_InvokeFlag domain.
//
struct vpcD_InvokeFlag {
  unsigned char ivf ;
} ;

#define vpcC_DISP_PROPERTY_GET        1
#define vpcC_DISP_PROPERTY_PUT        2
#define vpcC_DISP_METHOD              3
#define vpcC_DISP_PROPERTY_PUTREF     4
#define vpcC_DISP_PROPERTY_GET_METHOD 5


//
//  Counts number of variant arguments in the given list.
//
static
UINT CountArgs( vpcD_VariantArgListNode* head )
{
 UINT cnt = 0 ;
 while( head->fno != NILFNO ) {
   ++cnt ;
   head = head->next ;
 }
 return cnt ;
}

//
// Translates Prolog InvokeFlag to WORD value understandable by OLE
//
static
WORD vpInvokeFlagToWord( vpcD_InvokeFlag* vpif )
{
  switch( vpif->ivf ) {
     case vpcC_DISP_PROPERTY_GET :
       return DISPATCH_PROPERTYGET ;
     case vpcC_DISP_PROPERTY_PUT :
       return DISPATCH_PROPERTYPUT ;
     case vpcC_DISP_METHOD       :
       return DISPATCH_METHOD ;
     case vpcC_DISP_PROPERTY_PUTREF :
       return DISPATCH_PROPERTYPUTREF ;
     case vpcC_DISP_PROPERTY_GET_METHOD :
       return DISPATCH_PROPERTYGET|DISPATCH_METHOD ;
  }
  return 0 ;
}



/*
 * utilP_DispInvoke
 *
 * Purpose:
 *  Invokes a property accessor function or method of an automation object. Uses Unicode with OLE.
 *
 * Parameters:
 *  pdisp         IDispatch* of automation object.
 *  vpInvokeFlag  Specfies if property is to be accessed or method to be invoked.
 *  pszName       Name of property or method.
 *  alist         List of variant arguments
 *  pvRet         NULL if caller excepts no result. Otherwise returns result.
 *  pexcepinfo    Returns exception info if DISP_E_EXCEPTION is returned. Can be NULL if
 *                caller is not interested in exception information.
 *  pnArgErr      If return is DISP_E_TYPEMISMATCH, this returns the index (in reverse
 *                order) of argument with incorrect type. Can be NULL if caller is not interested
 *                in this information.
 *
 * Return Value:
 *  HRESULT indicating success or failure
 *
 */
static
HRESULT
utilP_DispInvoke(
    LPDISPATCH pdisp,
    vpcD_InvokeFlag* vpInvokeFlag,
    char* pszNameA,
    vpcD_VariantArgListNode* alist,
    LPVARIANT pvRet,
    EXCEPINFO* pexcepinfo,
    UINT* pnArgErr
                )
{
    DISPID dispid;
    HRESULT hr;
    VARIANTARG* pvarg = NULL;
    LPOLESTR pszName ;

    if (pdisp == NULL)
        return ResultFromScode(E_INVALIDARG);

    // Get DISPID of property/method
	pszName = ConvertToUnicode(pszNameA) ;
    hr = pdisp->GetIDsOfNames(IID_NULL, &pszName, 1, LOCALE_USER_DEFAULT, &dispid);
    if(FAILED(hr))
        return hr;

    DISPPARAMS dispparams;
    _fmemset(&dispparams, 0, sizeof dispparams);

    // determine number of arguments
    dispparams.cArgs = CountArgs(alist) ;

    WORD wFlags = vpInvokeFlagToWord( vpInvokeFlag ) ;

    // Property puts have a named argument that represents the value that the property is
    // being assigned.
    DISPID dispidNamed = DISPID_PROPERTYPUT;
    if (wFlags & DISPATCH_PROPERTYPUT)
    {
        if (dispparams.cArgs == 0)
            return ResultFromScode(E_INVALIDARG);
        dispparams.cNamedArgs = 1;
        dispparams.rgdispidNamedArgs = &dispidNamed;
    }

    if (dispparams.cArgs != 0)
    {
        // allocate memory for all VARIANTARG parameters
        pvarg = new VARIANTARG[dispparams.cArgs];
        if(pvarg == NULL)
            return ResultFromScode(E_OUTOFMEMORY);
        dispparams.rgvarg = pvarg;
        _fmemset(pvarg, 0, sizeof(VARIANTARG) * dispparams.cArgs);

        // get ready to walk argument list
        vpcD_VariantArgListNode* head = alist ;
        pvarg += dispparams.cArgs - 1;   // params go in opposite order

        while (head->fno != NILFNO)
        {
            if (pvarg < dispparams.rgvarg)
            {
                hr = ResultFromScode(E_INVALIDARG);
                goto cleanup;
            }
            vpcD_VariantArg* va = head->va ;
            switch (va->vt)
            {
            case vpcC_VT_I2:
                pvarg->vt = VT_I2 ;
                V_I2(pvarg) = va->vv.i2 ;
                break;
            case vpcC_VT_I4:
                pvarg->vt = VT_I4 ;
                V_I4(pvarg) = va->vv.i4 ;
                break;
            case vpcC_VT_R4:
                pvarg->vt = VT_R4 ;
                V_R4(pvarg) = (float)va->vv.r4;
                break;
            case vpcC_VT_DATE:
                pvarg->vt = VT_DATE ;
                V_DATE(pvarg) = va->vv.date ;
                break ;
            case vpcC_VT_R8:
                pvarg->vt = VT_R8 ;
                V_R8(pvarg) = va->vv.r8;
                break;
            case vpcC_VT_CY:
                pvarg->vt = VT_CY ;
                V_CY(pvarg) = *(CY*)va->vv.cy;
                break;
            case vpcC_VT_BSTR:
                pvarg->vt = VT_BSTR ;
                V_BSTR(pvarg) = SysAllocString(ConvertToUnicode(va->vv.bstr));
                if (pvarg->bstrVal == NULL)
                {
                    hr = ResultFromScode(E_OUTOFMEMORY);
                    pvarg->vt = VT_EMPTY;
                    goto cleanup;
                }
                break;
            case vpcC_VT_DISPATCH:
                pvarg->vt = VT_DISPATCH ;
                V_DISPATCH(pvarg) = (IDispatch*)va->vv.dispatch;
                break;
            case vpcC_VT_ERROR:
                pvarg->vt = VT_ERROR ;
                V_ERROR(pvarg) = va->vv.error;
                break;
            case vpcC_VT_BOOL:
                pvarg->vt = VT_BOOL ;
                V_BOOL(pvarg) = (va->vv.bool) ? -1 : 0;
                break;
            case vpcC_VT_VARIANT:     
                *pvarg = *(VARIANT*)va->vv.variant;
                break;
            case vpcC_VT_UNKNOWN:
                pvarg->vt = VT_UNKNOWN ;
                V_UNKNOWN(pvarg) = (IUnknown*)va->vv.unknown;
                break;
            case vpcC_VT_I2REF:
                pvarg->vt = VT_I2|VT_BYREF;
                V_I2REF(pvarg) = ( short* )va->vv.i2ref;
                break;
            case vpcC_VT_I4REF:
                pvarg->vt = VT_I4|VT_BYREF;
                V_I4REF(pvarg) = ( long* )va->vv.i4ref;
                break;
            case vpcC_VT_R4REF:
                pvarg->vt = VT_R4|VT_BYREF;
                V_R4REF(pvarg) = ( float* )va->vv.r4ref;
                break;
            case vpcC_VT_R8REF:
                pvarg->vt = VT_R8|VT_BYREF;
                V_R8REF(pvarg) = ( double* )va->vv.r8ref;
                break;
            case vpcC_VT_DATEREF:
                pvarg->vt = VT_DATE|VT_BYREF;
                V_DATEREF(pvarg) = ( DATE* )va->vv.dateref;
                break;
            case vpcC_VT_CYREF:
                pvarg->vt = VT_CY|VT_BYREF;
				{
					CY** cyp = (CY**)va->vv.cyref ;
				    *cyp = (CY*)MEM_AllocGStack(sizeof(CY)) ;
                    V_CYREF(pvarg) = *cyp ;
				}
                break;
            case vpcC_VT_BSTRREF:
                pvarg->vt = VT_BSTR|VT_BYREF;
                V_BSTRREF(pvarg) = ( BSTR* )va->vv.bstrref;
                break;
            case vpcC_VT_DISPATCHREF:
                pvarg->vt = VT_DISPATCH|VT_BYREF;
                V_DISPATCHREF(pvarg) = ( LPDISPATCH* )va->vv.dispatchref;
                break;
            case vpcC_VT_ERRORREF:
                pvarg->vt = VT_ERROR|VT_BYREF;
                V_ERRORREF(pvarg) = ( SCODE* )va->vv.errorref;
                break;
            case vpcC_VT_BOOLREF:
                pvarg->vt = VT_BOOL|VT_BYREF;
                {
                    BOOL FAR* pbool = ( BOOL* )va->vv.boolref;
                    *pbool = 0;
                    V_BOOLREF(pvarg) = (VARIANT_BOOL* )pbool;
                }
                break;
            case vpcC_VT_VARIANTREF:
                pvarg->vt = VT_VARIANT|VT_BYREF;
                V_VARIANTREF(pvarg) = ( VARIANTARG* )va->vv.variantref;
                break;
            case vpcC_VT_UNKNOWNREF:
                pvarg->vt = VT_UNKNOWN|VT_BYREF;
                V_UNKNOWNREF(pvarg) = ( LPUNKNOWN* )va->vv.unknownref;
                break;

            default:
                {
                    hr = ResultFromScode(E_INVALIDARG);
                    goto cleanup;
                }
                break;
            }

            --pvarg; // get ready to fill next argument
            head = head->next ;
        } //while
    } //if

    VariantInit(pvRet);
    
    hr = pdisp->Invoke(dispid, IID_NULL, LOCALE_USER_DEFAULT, wFlags,
        &dispparams, pvRet, pexcepinfo, pnArgErr);

cleanup:
    // cleanup any arguments that need cleanup
    if (dispparams.cArgs != 0)
    {
        VARIANTARG* pvarg = dispparams.rgvarg;
        UINT cArgs = dispparams.cArgs;

        while (cArgs--)
        {
            switch (pvarg->vt)
            {
            case VT_BSTR:
                VariantClear(pvarg);
                break;
			case VT_R4|VT_BYREF :
				{
				  float ftmp = *V_R4REF(pvarg) ;
				  *V_R8REF(pvarg) = (double)ftmp ;	
				}
		        break ;         
			case VT_BSTR|VT_BYREF :
				if( *V_BSTRREF(pvarg) != NULL ) {
					char* tmp = MEM_SaveStringGStack(ConvertToAnsi(*V_BSTRREF(pvarg))) ;
					SysFreeString(*V_BSTRREF(pvarg)) ;
					*V_BSTRREF(pvarg) = (BSTR)tmp ;
				}
				break ;
			}
            ++pvarg;
        }
    }
    delete dispparams.rgvarg;
    return hr;
}

static
void utilP_CreateVPVariant (
                    LPVARIANT pva,                 // (i)
                    vpcD_VariantArg** vp_result    // (o)
                            )
{
  vpcD_VariantArg* wres ;
  
   if( V_VT(pva) == VT_VARIANT ) {
	  utilP_CreateVPVariant (V_VARIANTREF(pva),&wres) ;
   }
   else {
    wres = (vpcD_VariantArg*)MEM_AllocGStack(sizeof(vpcD_VariantArg)) ;
    switch ( V_VT(pva) ) {
      case VT_I2 :
        wres->vt = vpcC_VT_I2 ;
        wres->vv.i2 = V_I2(pva) ;
        break ;
      case VT_I4 :
        wres->vt = vpcC_VT_I4 ;
        wres->vv.i4 = V_I4(pva) ;
        break ;
      case VT_R4 :
        wres->vt = vpcC_VT_R4 ;
        wres->vv.r4 = V_R4(pva) ;
        break ;
      case VT_R8 :
        wres->vt = vpcC_VT_R8 ;
        wres->vv.r8 = V_R8(pva) ;
        break ;
      case VT_DATE :
        wres->vt = vpcC_VT_DATE ;
        wres->vv.date = V_DATE(pva) ;
        break ;
      case VT_CY :								// !!!
        wres->vt = vpcC_VT_CY ;
        wres->vv.cy = (DWORD)MEM_NewCopyGStack(&(V_CY(pva)),sizeof(CY)) ;
        break ;
      case VT_BSTR :
        wres->vt = vpcC_VT_BSTR ;
        wres->vv.bstr = MEM_SaveStringGStack(ConvertToAnsi(V_BSTR(pva))) ;    // !!!
		VariantClear(pva) ;
        break ;
      case VT_DISPATCH :
        wres->vt = vpcC_VT_DISPATCH ;
        wres->vv.dispatch = (DWORD)V_DISPATCH(pva) ;
        break ;
      case VT_ERROR :
        wres->vt = vpcC_VT_ERROR ;
        wres->vv.error = V_ERROR(pva) ;
        break ;
      case VT_BOOL :
        wres->vt = vpcC_VT_BOOL ;
        wres->vv.bool = V_BOOL(pva) ;
        break ;
      case VT_UNKNOWN :
        wres->vt = vpcC_VT_UNKNOWN ;
        wres->vv.unknown = (DWORD)V_UNKNOWN(pva) ;
        break ;
      default :
        wres->vt = vpcC_VT_NULL ;
    }		
   }
  
  *vp_result = wres ;
}



extern "C"
HRESULT
comutilP_DispInvoke(
    LPDISPATCH pdisp,
    vpcD_InvokeFlag* vpInvokeFlag,
    char* pszName,
    vpcD_VariantArgListNode* alist,
    vpcD_VariantArg** vpresult 

                )
{

  VARIANT vRet ;

  HRESULT hr = utilP_DispInvoke(pdisp,vpInvokeFlag,pszName,alist,&vRet,NULL,NULL) ;

  utilP_CreateVPVariant(&vRet,vpresult) ;

  return hr ;
}


//
//      !! Low Level !!
//      comutilP_CreateRefArg
//
static
void utilP_CreateRefArg( int vt, void* varaddress, vpcD_VariantArg** rva )
{
 vpcD_VariantArg* va = (vpcD_VariantArg*)MEM_AllocGStack(sizeof(vpcD_VariantArg)) ;
 va->vt = vt ;
 va->vv.i2ref = (DWORD)varaddress ;
 *rva = va ;
}


#define REFARGFUNC(vt,vartype)	\
extern "C" void comutilP_Create##vt##RefArg(vartype* va,vpcD_VariantArg** rva)  \
{ utilP_CreateRefArg(vpcC_VT_##vt##REF,va,rva) ; } 


REFARGFUNC(I2,short)
REFARGFUNC(I4,long)
REFARGFUNC(R4,double)
REFARGFUNC(R8,double)
REFARGFUNC(CY,CY*)          
REFARGFUNC(DATE,DATE)        
REFARGFUNC(BSTR,char*)        
REFARGFUNC(DISPATCH,DWORD)    
REFARGFUNC(ERROR,long)       
REFARGFUNC(BOOL,int)        
REFARGFUNC(VARIANT,DWORD)     
REFARGFUNC(UNKNOWN,DWORD)     
REFARGFUNC(ARRAY,DWORD)       



extern "C"
HRESULT comutilP_QueryInterface( IUnknown* punk, REFIID iid, void** ppvObject )
{
	return punk->QueryInterface(iid,ppvObject) ;
}

extern "C"
ULONG comutilP_Release( IUnknown* punk )
{
  return punk->Release() ;
}

extern "C"
ULONG comutilP_AddRef( IUnknown* punk )
{
  return punk->AddRef() ;
}


