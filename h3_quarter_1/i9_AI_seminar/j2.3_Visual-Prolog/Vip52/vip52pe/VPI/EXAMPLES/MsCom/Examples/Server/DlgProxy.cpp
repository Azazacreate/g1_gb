// DlgProxy.cpp : implementation file
//

#include "stdafx.h"
#include "mycalc3.h"
#include "DlgProxy.h"
#include "myDlg.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CMycalc3DlgAutoProxy

IMPLEMENT_DYNCREATE(CMycalc3DlgAutoProxy, CCmdTarget)

CMycalc3DlgAutoProxy::CMycalc3DlgAutoProxy()
{
	EnableAutomation();
	
	// To keep the application running as long as an OLE automation 
	//	object is active, the constructor calls AfxOleLockApp.
	AfxOleLockApp();

	// Get access to the dialog through the application's
	//  main window pointer.  Set the proxy's internal pointer
	//  to point to the dialog, and set the dialog's back pointer to
	//  this proxy.
	ASSERT (AfxGetApp()->m_pMainWnd != NULL);
	ASSERT_VALID (AfxGetApp()->m_pMainWnd);
	ASSERT_KINDOF(CMycalc3Dlg, AfxGetApp()->m_pMainWnd);
	m_pDialog = (CMycalc3Dlg*) AfxGetApp()->m_pMainWnd;
	m_pDialog->m_pAutoProxy = this;
}

CMycalc3DlgAutoProxy::~CMycalc3DlgAutoProxy()
{
	// To terminate the application when all objects created with
	// 	with OLE automation, the destructor calls AfxOleUnlockApp.
	//  Among other things, this will destroy the main dialog
	AfxOleUnlockApp();
}

void CMycalc3DlgAutoProxy::OnFinalRelease()
{
	// When the last reference for an automation object is released
	// OnFinalRelease is called.  The base class will automatically
	// deletes the object.  Add additional cleanup required for your
	// object before calling the base class.

	CCmdTarget::OnFinalRelease();
}

BEGIN_MESSAGE_MAP(CMycalc3DlgAutoProxy, CCmdTarget)
	//{{AFX_MSG_MAP(CMycalc3DlgAutoProxy)
		// NOTE - the ClassWizard will add and remove mapping macros here.
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

BEGIN_DISPATCH_MAP(CMycalc3DlgAutoProxy, CCmdTarget)
	//{{AFX_DISPATCH_MAP(CMycalc3DlgAutoProxy)
	DISP_PROPERTY_EX(CMycalc3DlgAutoProxy, "Accumulator", GetAccumulator, SetAccumulator, VT_I4)
	DISP_PROPERTY_EX(CMycalc3DlgAutoProxy, "Operand", GetOperand, SetOperand, VT_I4)
	DISP_PROPERTY_EX(CMycalc3DlgAutoProxy, "Operator", GetOperator, SetOperator, VT_I4)
	DISP_PROPERTY_EX(CMycalc3DlgAutoProxy, "Display", GetDisplay, SetDisplay, VT_I4)
	DISP_FUNCTION(CMycalc3DlgAutoProxy, "Button", Button, VT_EMPTY, VTS_BSTR)
	DISP_FUNCTION(CMycalc3DlgAutoProxy, "Quit", Quit, VT_EMPTY, VTS_NONE)
	//}}AFX_DISPATCH_MAP
END_DISPATCH_MAP()

// Note: we add support for IID_IMycalc3 to support typesafe binding
//  from VBA.  This IID must match the GUID that is attached to the 
//  dispinterface in the .ODL file.
/*
// {FB1AE907-4A0B-11D1-B1F7-00AA0019F5FB}
static const IID IID_IMycalc3 =
{ 0xfb1ae907, 0x4a0b, 0x11d1, { 0xb1, 0xf7, 0x0, 0xaa, 0x0, 0x19, 0xf5, 0xfb } };
static const IID IID_IDualMycalc3 =
{ 0xE92E6F10, 0x4AB5, 0x11d1, { 0xB1, 0xF8, 0x0, 0xAA, 0x0, 0x19, 0xF5, 0xFB } } ;
*/

BEGIN_INTERFACE_MAP(CMycalc3DlgAutoProxy, CCmdTarget)
	INTERFACE_PART(CMycalc3DlgAutoProxy, DIID_IMycalc3, Dispatch)
	INTERFACE_PART(CMycalc3DlgAutoProxy, IID_IDualMycalc3, DualMycalc3)
END_INTERFACE_MAP()

// The IMPLEMENT_OLECREATE2 macro is defined in StdAfx.h of this project
// {FB1AE905-4A0B-11D1-B1F7-00AA0019F5FB}
IMPLEMENT_OLECREATE2(CMycalc3DlgAutoProxy, "Mycalc3.Application", 0xfb1ae905, 0x4a0b, 0x11d1, 0xb1, 0xf7, 0x0, 0xaa, 0x0, 0x19, 0xf5, 0xfb)

/////////////////////////////////////////////////////////////////////////////
// CMycalc3DlgAutoProxy message handlers

long CMycalc3DlgAutoProxy::GetAccumulator() 
{
	// TODO: Add your property handler here

	return m_pDialog->get_Accum() ;
}

void CMycalc3DlgAutoProxy::SetAccumulator(long nNewValue) 
{
	// TODO: Add your property handler here
	m_pDialog->set_Accum(nNewValue) ;
}

long CMycalc3DlgAutoProxy::GetOperand() 
{
	// TODO: Add your property handler here

	return m_pDialog->get_Opnd() ;
}

void CMycalc3DlgAutoProxy::SetOperand(long nNewValue) 
{
	// TODO: Add your property handler here
    m_pDialog->set_Opnd(nNewValue) ;
}

long CMycalc3DlgAutoProxy::GetOperator() 
{
	// TODO: Add your property handler here

	return m_pDialog->get_Op() ;
}

void CMycalc3DlgAutoProxy::SetOperator(long nNewValue) 
{
	// TODO: Add your property handler here
	m_pDialog->set_Op(nNewValue) ;
}


long CMycalc3DlgAutoProxy::GetDisplay() 
{
	// TODO: Add your property handler here

	return m_pDialog->get_Displ() ;
}

void CMycalc3DlgAutoProxy::SetDisplay(long nNewValue) 
{
	// TODO: Add your property handler here
    m_pDialog->set_Displ(nNewValue) ;
}

void CMycalc3DlgAutoProxy::Button(LPCTSTR b) 
{
	// TODO: Add your dispatch handler code here
	m_pDialog->Button(b) ;
}

void CMycalc3DlgAutoProxy::Quit() 
{
	// TODO: Add your dispatch handler code here
	m_pDialog->Quit() ;
}





STDMETHODIMP_(ULONG) CMycalc3DlgAutoProxy::XDualMycalc3::AddRef()
{
   METHOD_PROLOGUE(CMycalc3DlgAutoProxy, DualMycalc3)
   return pThis->ExternalAddRef();
}
STDMETHODIMP_(ULONG) CMycalc3DlgAutoProxy::XDualMycalc3::Release()
{
   METHOD_PROLOGUE(CMycalc3DlgAutoProxy, DualMycalc3)
   return pThis->ExternalRelease();
}
STDMETHODIMP CMycalc3DlgAutoProxy::XDualMycalc3::QueryInterface(
             REFIID iid, LPVOID* ppvObj)
{
   METHOD_PROLOGUE(CMycalc3DlgAutoProxy, DualMycalc3)
   return pThis->ExternalQueryInterface(&iid, ppvObj);
}
STDMETHODIMP CMycalc3DlgAutoProxy::XDualMycalc3::GetTypeInfoCount(
            UINT FAR* pctinfo)
{
   METHOD_PROLOGUE(CMycalc3DlgAutoProxy, DualMycalc3)
   LPDISPATCH lpDispatch = pThis->GetIDispatch(FALSE);
   ASSERT(lpDispatch != NULL);
   return lpDispatch->GetTypeInfoCount(pctinfo);
}
STDMETHODIMP CMycalc3DlgAutoProxy::XDualMycalc3::GetTypeInfo(
          UINT itinfo, LCID lcid, ITypeInfo FAR* FAR* pptinfo)
{
   METHOD_PROLOGUE(CMycalc3DlgAutoProxy, DualMycalc3)
   LPDISPATCH lpDispatch = pThis->GetIDispatch(FALSE);
   ASSERT(lpDispatch != NULL);
   return lpDispatch->GetTypeInfo(itinfo, lcid, pptinfo);
}
STDMETHODIMP CMycalc3DlgAutoProxy::XDualMycalc3::GetIDsOfNames(
       REFIID riid, OLECHAR FAR* FAR* rgszNames, UINT cNames,
       LCID lcid, DISPID FAR* rgdispid) 
{
   METHOD_PROLOGUE(CMycalc3DlgAutoProxy, DualMycalc3)
   LPDISPATCH lpDispatch = pThis->GetIDispatch(FALSE);
   ASSERT(lpDispatch != NULL);
   return lpDispatch->GetIDsOfNames(riid, rgszNames, cNames, 
                                    lcid, rgdispid);
}
STDMETHODIMP CMycalc3DlgAutoProxy::XDualMycalc3::Invoke(
    DISPID dispidMember, REFIID riid, LCID lcid, WORD wFlags,
    DISPPARAMS FAR* pdispparams, VARIANT FAR* pvarResult,
    EXCEPINFO FAR* pexcepinfo, UINT FAR* puArgErr)
{
   METHOD_PROLOGUE(CMycalc3DlgAutoProxy, DualMycalc3)
   LPDISPATCH lpDispatch = pThis->GetIDispatch(FALSE);
   ASSERT(lpDispatch != NULL);
   return lpDispatch->Invoke(dispidMember, riid, lcid,
                             wFlags, pdispparams, pvarResult,
                             pexcepinfo, puArgErr);
}

STDMETHODIMP CMycalc3DlgAutoProxy::XDualMycalc3::put_Accumulator( long l )
{
   METHOD_PROLOGUE(CMycalc3DlgAutoProxy, DualMycalc3)
   pThis->SetAccumulator(l) ;
   return NOERROR ;
}

STDMETHODIMP CMycalc3DlgAutoProxy::XDualMycalc3::get_Accumulator( long* l )
{
   METHOD_PROLOGUE(CMycalc3DlgAutoProxy, DualMycalc3)
   *l = pThis->GetAccumulator() ;
   return NOERROR ;
}

STDMETHODIMP CMycalc3DlgAutoProxy::XDualMycalc3::put_Operand( long l )
{
   METHOD_PROLOGUE(CMycalc3DlgAutoProxy, DualMycalc3)
   pThis->SetOperand(l) ;
   return NOERROR ;
}

STDMETHODIMP CMycalc3DlgAutoProxy::XDualMycalc3::get_Operand( long* l )
{
   METHOD_PROLOGUE(CMycalc3DlgAutoProxy, DualMycalc3)
   *l = pThis->GetOperand() ;
   return NOERROR ;
}

STDMETHODIMP CMycalc3DlgAutoProxy::XDualMycalc3::put_Operator( long l )
{
   METHOD_PROLOGUE(CMycalc3DlgAutoProxy, DualMycalc3)
   pThis->SetOperator(l) ;
   return NOERROR ;
}

STDMETHODIMP CMycalc3DlgAutoProxy::XDualMycalc3::get_Operator( long* l )
{
   METHOD_PROLOGUE(CMycalc3DlgAutoProxy, DualMycalc3)
   *l = pThis->GetOperator() ;
   return NOERROR ;
}

STDMETHODIMP CMycalc3DlgAutoProxy::XDualMycalc3::get_Display( long* l )
{
   METHOD_PROLOGUE(CMycalc3DlgAutoProxy, DualMycalc3)
   *l = pThis->GetDisplay() ;
   return NOERROR ;
}

STDMETHODIMP CMycalc3DlgAutoProxy::XDualMycalc3::put_Display( long l )
{
   METHOD_PROLOGUE(CMycalc3DlgAutoProxy, DualMycalc3)
   pThis->SetDisplay(l) ;
   return NOERROR ;
}


STDMETHODIMP CMycalc3DlgAutoProxy::XDualMycalc3::Button( BSTR b )
{
   METHOD_PROLOGUE(CMycalc3DlgAutoProxy, DualMycalc3)

   CString cs(b) ;
   pThis->Button( LPCTSTR(cs) ) ;
   return NOERROR ;
}

STDMETHODIMP CMycalc3DlgAutoProxy::XDualMycalc3::Quit()
{
   METHOD_PROLOGUE(CMycalc3DlgAutoProxy, DualMycalc3)
   pThis->Quit() ;
   return NOERROR ;
}


