/* this ALWAYS GENERATED file contains the definitions for the interfaces */


/* File created by MIDL compiler version 3.01.75 */
/* at Wed Oct 22 17:27:45 1997
 */
/* Compiler settings for D:\Wrk.2\mycalc3\mycalc3.odl:
    Os (OptLev=s), W1, Zp8, env=Win32, ms_ext, c_ext
    error checks: none
*/
//@@MIDL_FILE_HEADING(  )
#include "rpc.h"
#include "rpcndr.h"

#ifndef __mcalci_h__
#define __mcalci_h__

#ifdef __cplusplus
extern "C"{
#endif 

/* Forward Declarations */ 

#ifndef __IMycalc3_FWD_DEFINED__
#define __IMycalc3_FWD_DEFINED__
typedef interface IMycalc3 IMycalc3;
#endif 	/* __IMycalc3_FWD_DEFINED__ */


#ifndef __IDualMycalc3_FWD_DEFINED__
#define __IDualMycalc3_FWD_DEFINED__
typedef interface IDualMycalc3 IDualMycalc3;
#endif 	/* __IDualMycalc3_FWD_DEFINED__ */


#ifndef __MycalcClass_FWD_DEFINED__
#define __MycalcClass_FWD_DEFINED__

#ifdef __cplusplus
typedef class MycalcClass MycalcClass;
#else
typedef struct MycalcClass MycalcClass;
#endif /* __cplusplus */

#endif 	/* __MycalcClass_FWD_DEFINED__ */


void __RPC_FAR * __RPC_USER MIDL_user_allocate(size_t);
void __RPC_USER MIDL_user_free( void __RPC_FAR * ); 


#ifndef __Mycalc3_LIBRARY_DEFINED__
#define __Mycalc3_LIBRARY_DEFINED__

/****************************************
 * Generated header for library: Mycalc3
 * at Wed Oct 22 17:27:45 1997
 * using MIDL 3.01.75
 ****************************************/
/* [version][uuid] */ 



DEFINE_GUID(LIBID_Mycalc3,0xFB1AE906,0x4A0B,0x11D1,0xB1,0xF7,0x00,0xAA,0x00,0x19,0xF5,0xFB);

#ifndef __IMycalc3_DISPINTERFACE_DEFINED__
#define __IMycalc3_DISPINTERFACE_DEFINED__

/****************************************
 * Generated header for dispinterface: IMycalc3
 * at Wed Oct 22 17:27:45 1997
 * using MIDL 3.01.75
 ****************************************/
/* [uuid] */ 



DEFINE_GUID(DIID_IMycalc3,0xFB1AE907,0x4A0B,0x11D1,0xB1,0xF7,0x00,0xAA,0x00,0x19,0xF5,0xFB);

#if defined(__cplusplus) && !defined(CINTERFACE)

    interface DECLSPEC_UUID("FB1AE907-4A0B-11D1-B1F7-00AA0019F5FB")
    IMycalc3 : public IDispatch
    {
    };
    
#else 	/* C style interface */

    typedef struct IMycalc3Vtbl
    {
        BEGIN_INTERFACE
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *QueryInterface )( 
            IMycalc3 __RPC_FAR * This,
            /* [in] */ REFIID riid,
            /* [iid_is][out] */ void __RPC_FAR *__RPC_FAR *ppvObject);
        
        ULONG ( STDMETHODCALLTYPE __RPC_FAR *AddRef )( 
            IMycalc3 __RPC_FAR * This);
        
        ULONG ( STDMETHODCALLTYPE __RPC_FAR *Release )( 
            IMycalc3 __RPC_FAR * This);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *GetTypeInfoCount )( 
            IMycalc3 __RPC_FAR * This,
            /* [out] */ UINT __RPC_FAR *pctinfo);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *GetTypeInfo )( 
            IMycalc3 __RPC_FAR * This,
            /* [in] */ UINT iTInfo,
            /* [in] */ LCID lcid,
            /* [out] */ ITypeInfo __RPC_FAR *__RPC_FAR *ppTInfo);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *GetIDsOfNames )( 
            IMycalc3 __RPC_FAR * This,
            /* [in] */ REFIID riid,
            /* [size_is][in] */ LPOLESTR __RPC_FAR *rgszNames,
            /* [in] */ UINT cNames,
            /* [in] */ LCID lcid,
            /* [size_is][out] */ DISPID __RPC_FAR *rgDispId);
        
        /* [local] */ HRESULT ( STDMETHODCALLTYPE __RPC_FAR *Invoke )( 
            IMycalc3 __RPC_FAR * This,
            /* [in] */ DISPID dispIdMember,
            /* [in] */ REFIID riid,
            /* [in] */ LCID lcid,
            /* [in] */ WORD wFlags,
            /* [out][in] */ DISPPARAMS __RPC_FAR *pDispParams,
            /* [out] */ VARIANT __RPC_FAR *pVarResult,
            /* [out] */ EXCEPINFO __RPC_FAR *pExcepInfo,
            /* [out] */ UINT __RPC_FAR *puArgErr);
        
        END_INTERFACE
    } IMycalc3Vtbl;

    interface IMycalc3
    {
        CONST_VTBL struct IMycalc3Vtbl __RPC_FAR *lpVtbl;
    };

    

#ifdef COBJMACROS


#define IMycalc3_QueryInterface(This,riid,ppvObject)	\
    (This)->lpVtbl -> QueryInterface(This,riid,ppvObject)

#define IMycalc3_AddRef(This)	\
    (This)->lpVtbl -> AddRef(This)

#define IMycalc3_Release(This)	\
    (This)->lpVtbl -> Release(This)


#define IMycalc3_GetTypeInfoCount(This,pctinfo)	\
    (This)->lpVtbl -> GetTypeInfoCount(This,pctinfo)

#define IMycalc3_GetTypeInfo(This,iTInfo,lcid,ppTInfo)	\
    (This)->lpVtbl -> GetTypeInfo(This,iTInfo,lcid,ppTInfo)

#define IMycalc3_GetIDsOfNames(This,riid,rgszNames,cNames,lcid,rgDispId)	\
    (This)->lpVtbl -> GetIDsOfNames(This,riid,rgszNames,cNames,lcid,rgDispId)

#define IMycalc3_Invoke(This,dispIdMember,riid,lcid,wFlags,pDispParams,pVarResult,pExcepInfo,puArgErr)	\
    (This)->lpVtbl -> Invoke(This,dispIdMember,riid,lcid,wFlags,pDispParams,pVarResult,pExcepInfo,puArgErr)

#endif /* COBJMACROS */


#endif 	/* C style interface */


#endif 	/* __IMycalc3_DISPINTERFACE_DEFINED__ */


#ifndef __IDualMycalc3_INTERFACE_DEFINED__
#define __IDualMycalc3_INTERFACE_DEFINED__

/****************************************
 * Generated header for interface: IDualMycalc3
 * at Wed Oct 22 17:27:45 1997
 * using MIDL 3.01.75
 ****************************************/
/* [object][dual][oleautomation][uuid] */ 



DEFINE_GUID(IID_IDualMycalc3,0xE92E6F10,0x4AB5,0x11d1,0xB1,0xF8,0x00,0xAA,0x00,0x19,0xF5,0xFB);

#if defined(__cplusplus) && !defined(CINTERFACE)
    
    interface DECLSPEC_UUID("E92E6F10-4AB5-11d1-B1F8-00AA0019F5FB")
    IDualMycalc3 : public IDispatch
    {
    public:
        virtual /* [propput][id] */ HRESULT STDMETHODCALLTYPE put_Accumulator( 
            /* [in] */ long l) = 0;
        
        virtual /* [propget][id] */ HRESULT STDMETHODCALLTYPE get_Accumulator( 
            /* [retval][out] */ long __RPC_FAR *l) = 0;
        
        virtual /* [propput][id] */ HRESULT STDMETHODCALLTYPE put_Operand( 
            /* [in] */ long l) = 0;
        
        virtual /* [propget][id] */ HRESULT STDMETHODCALLTYPE get_Operand( 
            /* [retval][out] */ long __RPC_FAR *l) = 0;
        
        virtual /* [propput][id] */ HRESULT STDMETHODCALLTYPE put_Operator( 
            /* [in] */ long l) = 0;
        
        virtual /* [propget][id] */ HRESULT STDMETHODCALLTYPE get_Operator( 
            /* [retval][out] */ long __RPC_FAR *l) = 0;
        
        virtual /* [propput][id] */ HRESULT STDMETHODCALLTYPE put_Display( 
            /* [in] */ long l) = 0;
        
        virtual /* [propget][id] */ HRESULT STDMETHODCALLTYPE get_Display( 
            /* [retval][out] */ long __RPC_FAR *l) = 0;
        
        virtual /* [id] */ HRESULT STDMETHODCALLTYPE Button( 
            BSTR b) = 0;
        
        virtual /* [id] */ HRESULT STDMETHODCALLTYPE Quit( void) = 0;
        
    };
    
#else 	/* C style interface */

    typedef struct IDualMycalc3Vtbl
    {
        BEGIN_INTERFACE
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *QueryInterface )( 
            IDualMycalc3 __RPC_FAR * This,
            /* [in] */ REFIID riid,
            /* [iid_is][out] */ void __RPC_FAR *__RPC_FAR *ppvObject);
        
        ULONG ( STDMETHODCALLTYPE __RPC_FAR *AddRef )( 
            IDualMycalc3 __RPC_FAR * This);
        
        ULONG ( STDMETHODCALLTYPE __RPC_FAR *Release )( 
            IDualMycalc3 __RPC_FAR * This);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *GetTypeInfoCount )( 
            IDualMycalc3 __RPC_FAR * This,
            /* [out] */ UINT __RPC_FAR *pctinfo);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *GetTypeInfo )( 
            IDualMycalc3 __RPC_FAR * This,
            /* [in] */ UINT iTInfo,
            /* [in] */ LCID lcid,
            /* [out] */ ITypeInfo __RPC_FAR *__RPC_FAR *ppTInfo);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *GetIDsOfNames )( 
            IDualMycalc3 __RPC_FAR * This,
            /* [in] */ REFIID riid,
            /* [size_is][in] */ LPOLESTR __RPC_FAR *rgszNames,
            /* [in] */ UINT cNames,
            /* [in] */ LCID lcid,
            /* [size_is][out] */ DISPID __RPC_FAR *rgDispId);
        
        /* [local] */ HRESULT ( STDMETHODCALLTYPE __RPC_FAR *Invoke )( 
            IDualMycalc3 __RPC_FAR * This,
            /* [in] */ DISPID dispIdMember,
            /* [in] */ REFIID riid,
            /* [in] */ LCID lcid,
            /* [in] */ WORD wFlags,
            /* [out][in] */ DISPPARAMS __RPC_FAR *pDispParams,
            /* [out] */ VARIANT __RPC_FAR *pVarResult,
            /* [out] */ EXCEPINFO __RPC_FAR *pExcepInfo,
            /* [out] */ UINT __RPC_FAR *puArgErr);
        
        /* [propput][id] */ HRESULT ( STDMETHODCALLTYPE __RPC_FAR *put_Accumulator )( 
            IDualMycalc3 __RPC_FAR * This,
            /* [in] */ long l);
        
        /* [propget][id] */ HRESULT ( STDMETHODCALLTYPE __RPC_FAR *get_Accumulator )( 
            IDualMycalc3 __RPC_FAR * This,
            /* [retval][out] */ long __RPC_FAR *l);
        
        /* [propput][id] */ HRESULT ( STDMETHODCALLTYPE __RPC_FAR *put_Operand )( 
            IDualMycalc3 __RPC_FAR * This,
            /* [in] */ long l);
        
        /* [propget][id] */ HRESULT ( STDMETHODCALLTYPE __RPC_FAR *get_Operand )( 
            IDualMycalc3 __RPC_FAR * This,
            /* [retval][out] */ long __RPC_FAR *l);
        
        /* [propput][id] */ HRESULT ( STDMETHODCALLTYPE __RPC_FAR *put_Operator )( 
            IDualMycalc3 __RPC_FAR * This,
            /* [in] */ long l);
        
        /* [propget][id] */ HRESULT ( STDMETHODCALLTYPE __RPC_FAR *get_Operator )( 
            IDualMycalc3 __RPC_FAR * This,
            /* [retval][out] */ long __RPC_FAR *l);
        
        /* [propput][id] */ HRESULT ( STDMETHODCALLTYPE __RPC_FAR *put_Display )( 
            IDualMycalc3 __RPC_FAR * This,
            /* [in] */ long l);
        
        /* [propget][id] */ HRESULT ( STDMETHODCALLTYPE __RPC_FAR *get_Display )( 
            IDualMycalc3 __RPC_FAR * This,
            /* [retval][out] */ long __RPC_FAR *l);
        
        /* [id] */ HRESULT ( STDMETHODCALLTYPE __RPC_FAR *Button )( 
            IDualMycalc3 __RPC_FAR * This,
            BSTR b);
        
        /* [id] */ HRESULT ( STDMETHODCALLTYPE __RPC_FAR *Quit )( 
            IDualMycalc3 __RPC_FAR * This);
        
        END_INTERFACE
    } IDualMycalc3Vtbl;

    interface IDualMycalc3
    {
        CONST_VTBL struct IDualMycalc3Vtbl __RPC_FAR *lpVtbl;
    };

    

#ifdef COBJMACROS


#define IDualMycalc3_QueryInterface(This,riid,ppvObject)	\
    (This)->lpVtbl -> QueryInterface(This,riid,ppvObject)

#define IDualMycalc3_AddRef(This)	\
    (This)->lpVtbl -> AddRef(This)

#define IDualMycalc3_Release(This)	\
    (This)->lpVtbl -> Release(This)


#define IDualMycalc3_GetTypeInfoCount(This,pctinfo)	\
    (This)->lpVtbl -> GetTypeInfoCount(This,pctinfo)

#define IDualMycalc3_GetTypeInfo(This,iTInfo,lcid,ppTInfo)	\
    (This)->lpVtbl -> GetTypeInfo(This,iTInfo,lcid,ppTInfo)

#define IDualMycalc3_GetIDsOfNames(This,riid,rgszNames,cNames,lcid,rgDispId)	\
    (This)->lpVtbl -> GetIDsOfNames(This,riid,rgszNames,cNames,lcid,rgDispId)

#define IDualMycalc3_Invoke(This,dispIdMember,riid,lcid,wFlags,pDispParams,pVarResult,pExcepInfo,puArgErr)	\
    (This)->lpVtbl -> Invoke(This,dispIdMember,riid,lcid,wFlags,pDispParams,pVarResult,pExcepInfo,puArgErr)


#define IDualMycalc3_put_Accumulator(This,l)	\
    (This)->lpVtbl -> put_Accumulator(This,l)

#define IDualMycalc3_get_Accumulator(This,l)	\
    (This)->lpVtbl -> get_Accumulator(This,l)

#define IDualMycalc3_put_Operand(This,l)	\
    (This)->lpVtbl -> put_Operand(This,l)

#define IDualMycalc3_get_Operand(This,l)	\
    (This)->lpVtbl -> get_Operand(This,l)

#define IDualMycalc3_put_Operator(This,l)	\
    (This)->lpVtbl -> put_Operator(This,l)

#define IDualMycalc3_get_Operator(This,l)	\
    (This)->lpVtbl -> get_Operator(This,l)

#define IDualMycalc3_put_Display(This,l)	\
    (This)->lpVtbl -> put_Display(This,l)

#define IDualMycalc3_get_Display(This,l)	\
    (This)->lpVtbl -> get_Display(This,l)

#define IDualMycalc3_Button(This,b)	\
    (This)->lpVtbl -> Button(This,b)

#define IDualMycalc3_Quit(This)	\
    (This)->lpVtbl -> Quit(This)

#endif /* COBJMACROS */


#endif 	/* C style interface */



/* [propput][id] */ HRESULT STDMETHODCALLTYPE IDualMycalc3_put_Accumulator_Proxy( 
    IDualMycalc3 __RPC_FAR * This,
    /* [in] */ long l);


void __RPC_STUB IDualMycalc3_put_Accumulator_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


/* [propget][id] */ HRESULT STDMETHODCALLTYPE IDualMycalc3_get_Accumulator_Proxy( 
    IDualMycalc3 __RPC_FAR * This,
    /* [retval][out] */ long __RPC_FAR *l);


void __RPC_STUB IDualMycalc3_get_Accumulator_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


/* [propput][id] */ HRESULT STDMETHODCALLTYPE IDualMycalc3_put_Operand_Proxy( 
    IDualMycalc3 __RPC_FAR * This,
    /* [in] */ long l);


void __RPC_STUB IDualMycalc3_put_Operand_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


/* [propget][id] */ HRESULT STDMETHODCALLTYPE IDualMycalc3_get_Operand_Proxy( 
    IDualMycalc3 __RPC_FAR * This,
    /* [retval][out] */ long __RPC_FAR *l);


void __RPC_STUB IDualMycalc3_get_Operand_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


/* [propput][id] */ HRESULT STDMETHODCALLTYPE IDualMycalc3_put_Operator_Proxy( 
    IDualMycalc3 __RPC_FAR * This,
    /* [in] */ long l);


void __RPC_STUB IDualMycalc3_put_Operator_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


/* [propget][id] */ HRESULT STDMETHODCALLTYPE IDualMycalc3_get_Operator_Proxy( 
    IDualMycalc3 __RPC_FAR * This,
    /* [retval][out] */ long __RPC_FAR *l);


void __RPC_STUB IDualMycalc3_get_Operator_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


/* [propput][id] */ HRESULT STDMETHODCALLTYPE IDualMycalc3_put_Display_Proxy( 
    IDualMycalc3 __RPC_FAR * This,
    /* [in] */ long l);


void __RPC_STUB IDualMycalc3_put_Display_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


/* [propget][id] */ HRESULT STDMETHODCALLTYPE IDualMycalc3_get_Display_Proxy( 
    IDualMycalc3 __RPC_FAR * This,
    /* [retval][out] */ long __RPC_FAR *l);


void __RPC_STUB IDualMycalc3_get_Display_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


/* [id] */ HRESULT STDMETHODCALLTYPE IDualMycalc3_Button_Proxy( 
    IDualMycalc3 __RPC_FAR * This,
    BSTR b);


void __RPC_STUB IDualMycalc3_Button_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


/* [id] */ HRESULT STDMETHODCALLTYPE IDualMycalc3_Quit_Proxy( 
    IDualMycalc3 __RPC_FAR * This);


void __RPC_STUB IDualMycalc3_Quit_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);



#endif 	/* __IDualMycalc3_INTERFACE_DEFINED__ */


#ifdef __cplusplus
DEFINE_GUID(CLSID_MycalcClass,0xFB1AE905,0x4A0B,0x11D1,0xB1,0xF7,0x00,0xAA,0x00,0x19,0xF5,0xFB);

class DECLSPEC_UUID("FB1AE905-4A0B-11D1-B1F7-00AA0019F5FB")
MycalcClass;
#endif
#endif /* __Mycalc3_LIBRARY_DEFINED__ */

/* Additional Prototypes for ALL interfaces */

/* end of Additional Prototypes */

#ifdef __cplusplus
}
#endif

#endif
