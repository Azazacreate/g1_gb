// X_VPICtl.cpp : Implementation of the CX_VPICtrl ActiveX Control class.

#include "stdafx.h"
#include "X_VPI.h"
#include "X_VPICtl.h"
#include "X_VPIPpg.h"


#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

extern "C" {
	void __stdcall dll1_mark_gstack(unsigned long *out);
	void __stdcall dll1_release_gstack(unsigned long in);
	HWND __stdcall dll1_custom_Create(HWND Parent, const RECT *rect, int Id);
	void __stdcall dll1_custom_Destroy(HWND);
}


IMPLEMENT_DYNCREATE(CX_VPICtrl, COleControl)


/////////////////////////////////////////////////////////////////////////////
// Message map

BEGIN_MESSAGE_MAP(CX_VPICtrl, COleControl)
	//{{AFX_MSG_MAP(CX_VPICtrl)
	ON_WM_DESTROY()
	//}}AFX_MSG_MAP
	ON_OLEVERB(AFX_IDS_VERB_EDIT, OnEdit)
	ON_OLEVERB(AFX_IDS_VERB_PROPERTIES, OnProperties)
END_MESSAGE_MAP()


/////////////////////////////////////////////////////////////////////////////
// Dispatch map

BEGIN_DISPATCH_MAP(CX_VPICtrl, COleControl)
	//{{AFX_DISPATCH_MAP(CX_VPICtrl)
	//}}AFX_DISPATCH_MAP
END_DISPATCH_MAP()


/////////////////////////////////////////////////////////////////////////////
// Event map

BEGIN_EVENT_MAP(CX_VPICtrl, COleControl)
	//{{AFX_EVENT_MAP(CX_VPICtrl)
	//}}AFX_EVENT_MAP
END_EVENT_MAP()


/////////////////////////////////////////////////////////////////////////////
// Property pages

BEGIN_PROPPAGEIDS(CX_VPICtrl, 1)
	PROPPAGEID(CX_VPIPropPage::guid)
END_PROPPAGEIDS(CX_VPICtrl)


/////////////////////////////////////////////////////////////////////////////
// Initialize class factory and guid

IMPLEMENT_OLECREATE_EX(CX_VPICtrl, "XVPI.XVPICtrl.1",
	0xd7e5e83e, 0x82c5, 0x11d2, 0xa8, 0x22, 0x10, 0, 0x5a, 0x14, 0x9e, 0xd)


/////////////////////////////////////////////////////////////////////////////
// Type library ID and version

IMPLEMENT_OLETYPELIB(CX_VPICtrl, _tlid, _wVerMajor, _wVerMinor)


/////////////////////////////////////////////////////////////////////////////
// Interface IDs

const IID BASED_CODE IID_DX_VPI =
		{ 0xd7e5e83c, 0x82c5, 0x11d2, { 0xa8, 0x22, 0x10, 0, 0x5a, 0x14, 0x9e, 0xd } };
const IID BASED_CODE IID_DX_VPIEvents =
		{ 0xd7e5e83d, 0x82c5, 0x11d2, { 0xa8, 0x22, 0x10, 0, 0x5a, 0x14, 0x9e, 0xd } };


/////////////////////////////////////////////////////////////////////////////
// Control type information

static const DWORD BASED_CODE _dwX_VPIOleMisc =
	OLEMISC_SIMPLEFRAME |
	OLEMISC_ACTIVATEWHENVISIBLE |
	OLEMISC_SETCLIENTSITEFIRST |
	OLEMISC_INSIDEOUT |
	OLEMISC_CANTLINKINSIDE |
	OLEMISC_RECOMPOSEONRESIZE;

IMPLEMENT_OLECTLTYPE(CX_VPICtrl, IDS_X_VPI, _dwX_VPIOleMisc)


/////////////////////////////////////////////////////////////////////////////
// CX_VPICtrl::CX_VPICtrlFactory::UpdateRegistry -
// Adds or removes system registry entries for CX_VPICtrl

BOOL CX_VPICtrl::CX_VPICtrlFactory::UpdateRegistry(BOOL bRegister)
{
	// TODO: Verify that your control follows apartment-model threading rules.
	// Refer to MFC TechNote 64 for more information.
	// If your control does not conform to the apartment-model rules, then
	// you must modify the code below, changing the 6th parameter from
	// afxRegInsertable | afxRegApartmentThreading to afxRegInsertable.

	if (bRegister)
		return AfxOleRegisterControlClass(
			AfxGetInstanceHandle(),
			m_clsid,
			m_lpszProgID,
			IDS_X_VPI,
			IDB_X_VPI,
			afxRegInsertable | afxRegApartmentThreading,
			_dwX_VPIOleMisc,
			_tlid,
			_wVerMajor,
			_wVerMinor);
	else
		return AfxOleUnregisterClass(m_clsid, m_lpszProgID);
}


/////////////////////////////////////////////////////////////////////////////
// CX_VPICtrl::CX_VPICtrl - Constructor

CX_VPICtrl::CX_VPICtrl()
{
	InitializeIIDs(&IID_DX_VPI, &IID_DX_VPIEvents);

	EnableSimpleFrame();

	m_CustomCtl = NULL;
}


/////////////////////////////////////////////////////////////////////////////
// CX_VPICtrl::~CX_VPICtrl - Destructor

CX_VPICtrl::~CX_VPICtrl()
{
}


/////////////////////////////////////////////////////////////////////////////
// CX_VPICtrl::OnDraw - Drawing function

void CX_VPICtrl::OnDraw(
			CDC* pdc, const CRect& rcBounds, const CRect& rcInvalid)
{
	if( m_CustomCtl != NULL ){
		dll1_custom_Destroy( m_CustomCtl );
		m_CustomCtl = NULL;
	}
	else{
		RECT rect = {rcBounds.left,rcBounds.top,rcBounds.right,rcBounds.bottom};
		m_CustomCtl = dll1_custom_Create( this -> m_hWnd, &rect, 100 );
	}
}


/////////////////////////////////////////////////////////////////////////////
// CX_VPICtrl::DoPropExchange - Persistence support

void CX_VPICtrl::DoPropExchange(CPropExchange* pPX)
{
	ExchangeVersion(pPX, MAKELONG(_wVerMinor, _wVerMajor));
	COleControl::DoPropExchange(pPX);

}

/////////////////////////////////////////////////////////////////////////////
// CX_VPICtrl message handlers

void CX_VPICtrl::OnDestroy() 
{
	if( m_CustomCtl != NULL ){
		dll1_custom_Destroy( m_CustomCtl );
		m_CustomCtl = NULL;
	}

	COleControl::OnDestroy();
}
