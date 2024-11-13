// myDlg.h : header file
//

#if !defined(AFX_MYCALC3DLG_H__FB1AE90C_4A0B_11D1_B1F7_00AA0019F5FB__INCLUDED_)
#define AFX_MYCALC3DLG_H__FB1AE90C_4A0B_11D1_B1F7_00AA0019F5FB__INCLUDED_

#if _MSC_VER >= 1000
#pragma once
#endif // _MSC_VER >= 1000

#include "CArith.h"

class CMycalc3DlgAutoProxy;

/////////////////////////////////////////////////////////////////////////////
// CMycalc3Dlg dialog

class CMycalc3Dlg : public CDialog
{
	DECLARE_DYNAMIC(CMycalc3Dlg);
	friend class CMycalc3DlgAutoProxy;

// Construction
public:
	
	CArith m_arith;
	CMycalc3Dlg(CWnd* pParent = NULL);	// standard constructor
	virtual ~CMycalc3Dlg();

    long get_Accum() { return m_arith.get_Accum() ; }
	void set_Accum(long l) { m_arith.put_Accum(l) ; }
	long get_Opnd()  { return m_arith.get_Opnd() ; }
	void set_Opnd(long l)  { m_arith.put_Opnd(l) ; }
	long get_Op()    { return m_arith.get_Op() ; }
	void set_Op(long l)  { m_arith.put_Op(l) ; }
	long get_Displ() { return m_arith.get_Displ() ; }
	void set_Displ(long l) { m_arith.put_Displ(l) ; }
    void Button(LPCTSTR b)  { m_arith.Button(b,this) ; }
	void Quit ()  { m_arith.Quit() ; }

// Dialog Data
	//{{AFX_DATA(CMycalc3Dlg)
	enum { IDD = IDD_MYCALC3_DIALOG };
		// NOTE: the ClassWizard will add data members here
	//}}AFX_DATA

	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CMycalc3Dlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
//protected:
	CMycalc3DlgAutoProxy* m_pAutoProxy;
	HICON m_hIcon;

	BOOL CanExit();

	// Generated message map functions
	//{{AFX_MSG(CMycalc3Dlg)
	virtual BOOL OnInitDialog();
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	afx_msg void OnClose();
	virtual void OnOK() ;
    virtual void OnCancel() ;
	afx_msg void OnFive();
	afx_msg void OnFour();
	afx_msg void OnDiv();
	afx_msg void OnEight();
	afx_msg void OnEquals();
	afx_msg void OnMinus();
	afx_msg void OnMult();
	afx_msg void OnNine();
	afx_msg void OnOne();
	afx_msg void OnPlus();
	afx_msg void OnSeven();
	afx_msg void OnSix();
	afx_msg void OnThree();
	afx_msg void OnTwo();
	afx_msg void OnZero();
	afx_msg void OnClear();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Developer Studio will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_MYCALC3DLG_H__FB1AE90C_4A0B_11D1_B1F7_00AA0019F5FB__INCLUDED_)
