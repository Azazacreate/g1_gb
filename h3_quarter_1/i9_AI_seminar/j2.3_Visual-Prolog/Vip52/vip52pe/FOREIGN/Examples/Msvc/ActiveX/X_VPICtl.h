#if !defined(AFX_X_VPICTL_H__D7E5E84A_82C5_11D2_A822_10005A149E0D__INCLUDED_)
#define AFX_X_VPICTL_H__D7E5E84A_82C5_11D2_A822_10005A149E0D__INCLUDED_

#if _MSC_VER >= 1000
#pragma once
#endif // _MSC_VER >= 1000

// X_VPICtl.h : Declaration of the CX_VPICtrl ActiveX Control class.

/////////////////////////////////////////////////////////////////////////////
// CX_VPICtrl : See X_VPICtl.cpp for implementation.

class CX_VPICtrl : public COleControl
{
	DECLARE_DYNCREATE(CX_VPICtrl)

// Constructor
public:
	CX_VPICtrl();

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CX_VPICtrl)
	public:
	virtual void OnDraw(CDC* pdc, const CRect& rcBounds, const CRect& rcInvalid);
	virtual void DoPropExchange(CPropExchange* pPX);
	//}}AFX_VIRTUAL

// Implementation
protected:
	~CX_VPICtrl();

	DECLARE_OLECREATE_EX(CX_VPICtrl)    // Class factory and guid
	DECLARE_OLETYPELIB(CX_VPICtrl)      // GetTypeInfo
	DECLARE_PROPPAGEIDS(CX_VPICtrl)     // Property page IDs
	DECLARE_OLECTLTYPE(CX_VPICtrl)		// Type name and misc status

// Message maps
	//{{AFX_MSG(CX_VPICtrl)
	afx_msg void OnDestroy();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()

// Dispatch maps
	//{{AFX_DISPATCH(CX_VPICtrl)
	//}}AFX_DISPATCH
	DECLARE_DISPATCH_MAP()

// Event maps
	//{{AFX_EVENT(CX_VPICtrl)
	//}}AFX_EVENT
	DECLARE_EVENT_MAP()

// Dispatch and event IDs
public:
	enum {
	//{{AFX_DISP_ID(CX_VPICtrl)
	//}}AFX_DISP_ID
	};
private:
	HWND m_CustomCtl;
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Developer Studio will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_X_VPICTL_H__D7E5E84A_82C5_11D2_A822_10005A149E0D__INCLUDED)
