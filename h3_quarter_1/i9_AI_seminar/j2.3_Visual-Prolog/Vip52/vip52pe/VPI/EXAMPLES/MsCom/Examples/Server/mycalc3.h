// mycalc3.h : main header file for the MYCALC3 application
//

#if !defined(AFX_MYCALC3_H__FB1AE90A_4A0B_11D1_B1F7_00AA0019F5FB__INCLUDED_)
#define AFX_MYCALC3_H__FB1AE90A_4A0B_11D1_B1F7_00AA0019F5FB__INCLUDED_

#if _MSC_VER >= 1000
#pragma once
#endif // _MSC_VER >= 1000

#ifndef __AFXWIN_H__
	#error include 'stdafx.h' before including this file for PCH
#endif

#include "resource.h"		// main symbols

/////////////////////////////////////////////////////////////////////////////
// CMycalc3App:
// See mycalc3.cpp for the implementation of this class
//

class CMycalc3App : public CWinApp
{
public:
	CMycalc3App();

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CMycalc3App)
	public:
	virtual BOOL InitInstance();
	//}}AFX_VIRTUAL

// Implementation

	//{{AFX_MSG(CMycalc3App)
		// NOTE - the ClassWizard will add and remove member functions here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};


/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Developer Studio will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_MYCALC3_H__FB1AE90A_4A0B_11D1_B1F7_00AA0019F5FB__INCLUDED_)
