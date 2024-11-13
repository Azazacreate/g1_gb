// call_dll.h : main header file for the CALL_DLL application
//

#if !defined(AFX_CALL_DLL_H__4BA0B9C6_9039_11D2_83E7_00A0C9437EC0__INCLUDED_)
#define AFX_CALL_DLL_H__4BA0B9C6_9039_11D2_83E7_00A0C9437EC0__INCLUDED_

#if _MSC_VER >= 1000
#pragma once
#endif // _MSC_VER >= 1000

#ifndef __AFXWIN_H__
	#error include 'stdafx.h' before including this file for PCH
#endif

#include "resource.h"		// main symbols

/////////////////////////////////////////////////////////////////////////////
// CCall_dllApp:
// See call_dll.cpp for the implementation of this class
//

class CCall_dllApp : public CWinApp
{
public:
	CCall_dllApp();

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CCall_dllApp)
	public:
	virtual BOOL InitInstance();
	//}}AFX_VIRTUAL

// Implementation

	//{{AFX_MSG(CCall_dllApp)
		// NOTE - the ClassWizard will add and remove member functions here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};


/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Developer Studio will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_CALL_DLL_H__4BA0B9C6_9039_11D2_83E7_00A0C9437EC0__INCLUDED_)
