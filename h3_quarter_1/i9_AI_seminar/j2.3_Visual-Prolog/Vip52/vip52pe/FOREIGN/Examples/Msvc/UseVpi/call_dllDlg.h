// call_dllDlg.h : header file
//

#if !defined(AFX_CALL_DLLDLG_H__4BA0B9C8_9039_11D2_83E7_00A0C9437EC0__INCLUDED_)
#define AFX_CALL_DLLDLG_H__4BA0B9C8_9039_11D2_83E7_00A0C9437EC0__INCLUDED_

#if _MSC_VER >= 1000
#pragma once
#endif // _MSC_VER >= 1000

/////////////////////////////////////////////////////////////////////////////
// CCall_dllDlg dialog

class CCall_dllDlg : public CDialog
{
// Construction
public:
	CCall_dllDlg(CWnd* pParent = NULL);	// standard constructor

// Dialog Data
	//{{AFX_DATA(CCall_dllDlg)
	enum { IDD = IDD_CALL_DLL_DIALOG };
		// NOTE: the ClassWizard will add data members here
	//}}AFX_DATA

	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CCall_dllDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:
	HICON m_hIcon;

	// Generated message map functions
	//{{AFX_MSG(CCall_dllDlg)
	virtual BOOL OnInitDialog();
	afx_msg void OnSysCommand(UINT nID, LPARAM lParam);
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	afx_msg void Ongetstring();
	afx_msg void Onhello();
	afx_msg void OnbyDLL1();
	afx_msg void OnDestroy();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Developer Studio will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_CALL_DLLDLG_H__4BA0B9C8_9039_11D2_83E7_00A0C9437EC0__INCLUDED_)
