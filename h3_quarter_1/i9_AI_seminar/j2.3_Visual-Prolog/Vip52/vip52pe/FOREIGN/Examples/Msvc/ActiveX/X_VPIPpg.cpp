// X_VPIPpg.cpp : Implementation of the CX_VPIPropPage property page class.

#include "stdafx.h"
#include "X_VPI.h"
#include "X_VPIPpg.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif


IMPLEMENT_DYNCREATE(CX_VPIPropPage, COlePropertyPage)


/////////////////////////////////////////////////////////////////////////////
// Message map

BEGIN_MESSAGE_MAP(CX_VPIPropPage, COlePropertyPage)
	//{{AFX_MSG_MAP(CX_VPIPropPage)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()


/////////////////////////////////////////////////////////////////////////////
// Initialize class factory and guid

IMPLEMENT_OLECREATE_EX(CX_VPIPropPage, "XVPI.XVPIPropPage.1",
	0xd7e5e83f, 0x82c5, 0x11d2, 0xa8, 0x22, 0x10, 0, 0x5a, 0x14, 0x9e, 0xd)


/////////////////////////////////////////////////////////////////////////////
// CX_VPIPropPage::CX_VPIPropPageFactory::UpdateRegistry -
// Adds or removes system registry entries for CX_VPIPropPage

BOOL CX_VPIPropPage::CX_VPIPropPageFactory::UpdateRegistry(BOOL bRegister)
{
	if (bRegister)
		return AfxOleRegisterPropertyPageClass(AfxGetInstanceHandle(),
			m_clsid, IDS_X_VPI_PPG);
	else
		return AfxOleUnregisterClass(m_clsid, NULL);
}


/////////////////////////////////////////////////////////////////////////////
// CX_VPIPropPage::CX_VPIPropPage - Constructor

CX_VPIPropPage::CX_VPIPropPage() :
	COlePropertyPage(IDD, IDS_X_VPI_PPG_CAPTION)
{
	//{{AFX_DATA_INIT(CX_VPIPropPage)
	//}}AFX_DATA_INIT
}


/////////////////////////////////////////////////////////////////////////////
// CX_VPIPropPage::DoDataExchange - Moves data between page and properties

void CX_VPIPropPage::DoDataExchange(CDataExchange* pDX)
{
	//{{AFX_DATA_MAP(CX_VPIPropPage)
	//}}AFX_DATA_MAP
	DDP_PostProcessing(pDX);
}


/////////////////////////////////////////////////////////////////////////////
// CX_VPIPropPage message handlers
