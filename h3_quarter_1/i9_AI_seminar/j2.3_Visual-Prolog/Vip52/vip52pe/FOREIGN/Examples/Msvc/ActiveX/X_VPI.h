#if !defined(AFX_X_VPI_H__D7E5E843_82C5_11D2_A822_10005A149E0D__INCLUDED_)
#define AFX_X_VPI_H__D7E5E843_82C5_11D2_A822_10005A149E0D__INCLUDED_

#if _MSC_VER >= 1000
#pragma once
#endif // _MSC_VER >= 1000

// X_VPI.h : main header file for X_VPI.DLL

#if !defined( __AFXCTL_H__ )
	#error include 'afxctl.h' before including this file
#endif

#include "resource.h"       // main symbols

/////////////////////////////////////////////////////////////////////////////
// CX_VPIApp : See X_VPI.cpp for implementation.

class CX_VPIApp : public COleControlModule
{
public:
	BOOL InitInstance();
	int ExitInstance();
};

extern const GUID CDECL _tlid;
extern const WORD _wVerMajor;
extern const WORD _wVerMinor;

//{{AFX_INSERT_LOCATION}}
// Microsoft Developer Studio will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_X_VPI_H__D7E5E843_82C5_11D2_A822_10005A149E0D__INCLUDED)
