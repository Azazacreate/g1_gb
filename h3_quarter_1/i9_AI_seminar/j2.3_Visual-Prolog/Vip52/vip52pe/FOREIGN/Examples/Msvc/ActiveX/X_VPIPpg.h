#if !defined(AFX_X_VPIPPG_H__D7E5E84C_82C5_11D2_A822_10005A149E0D__INCLUDED_)
#define AFX_X_VPIPPG_H__D7E5E84C_82C5_11D2_A822_10005A149E0D__INCLUDED_

#if _MSC_VER >= 1000
#pragma once
#endif // _MSC_VER >= 1000

// X_VPIPpg.h : Declaration of the CX_VPIPropPage property page class.

////////////////////////////////////////////////////////////////////////////
// CX_VPIPropPage : See X_VPIPpg.cpp.cpp for implementation.

class CX_VPIPropPage : public COlePropertyPage
{
	DECLARE_DYNCREATE(CX_VPIPropPage)
	DECLARE_OLECREATE_EX(CX_VPIPropPage)

// Constructor
public:
	CX_VPIPropPage();

// Dialog Data
	//{{AFX_DATA(CX_VPIPropPage)
	enum { IDD = IDD_PROPPAGE_X_VPI };
	//}}AFX_DATA

// Implementation
protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

// Message maps
protected:
	//{{AFX_MSG(CX_VPIPropPage)
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()

};

//{{AFX_INSERT_LOCATION}}
// Microsoft Developer Studio will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_X_VPIPPG_H__D7E5E84C_82C5_11D2_A822_10005A149E0D__INCLUDED)
