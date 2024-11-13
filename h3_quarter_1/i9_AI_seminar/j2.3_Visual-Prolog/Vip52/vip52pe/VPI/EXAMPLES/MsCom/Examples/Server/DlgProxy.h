// DlgProxy.h : header file
//

#if !defined(AFX_DLGPROXY_H__FB1AE90E_4A0B_11D1_B1F7_00AA0019F5FB__INCLUDED_)
#define AFX_DLGPROXY_H__FB1AE90E_4A0B_11D1_B1F7_00AA0019F5FB__INCLUDED_

#if _MSC_VER >= 1000
#pragma once
#endif // _MSC_VER >= 1000

class CMycalc3Dlg;

/////////////////////////////////////////////////////////////////////////////
// CMycalc3DlgAutoProxy command target

class CMycalc3DlgAutoProxy : public CCmdTarget
{
	DECLARE_DYNCREATE(CMycalc3DlgAutoProxy)

	CMycalc3DlgAutoProxy();           // protected constructor used by dynamic creation

// Attributes
public:
	CMycalc3Dlg* m_pDialog;

// Operations
public:

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CMycalc3DlgAutoProxy)
	public:
	virtual void OnFinalRelease();
	//}}AFX_VIRTUAL

// Implementation
protected:
	virtual ~CMycalc3DlgAutoProxy();

	// Generated message map functions
	//{{AFX_MSG(CMycalc3DlgAutoProxy)
		// NOTE - the ClassWizard will add and remove member functions here.
	//}}AFX_MSG

	DECLARE_MESSAGE_MAP()
	DECLARE_OLECREATE(CMycalc3DlgAutoProxy)

	// Generated OLE dispatch map functions
	//{{AFX_DISPATCH(CMycalc3DlgAutoProxy)
	afx_msg long GetAccumulator();
	afx_msg void SetAccumulator(long nNewValue);
	afx_msg long GetOperand();
	afx_msg void SetOperand(long nNewValue);
	afx_msg long GetOperator();
	afx_msg void SetOperator(long nNewValue);
	afx_msg long GetDisplay();
	afx_msg void SetDisplay(long nNewValue);
	afx_msg void Button(LPCTSTR b);
	afx_msg void Quit();
	//}}AFX_DISPATCH
	DECLARE_DISPATCH_MAP()
	DECLARE_INTERFACE_MAP()
	
	BEGIN_DUAL_INTERFACE_PART(DualMycalc3,IDualMycalc3)
	  STDMETHOD(put_Accumulator)(THIS_ long newAccum);
	  STDMETHOD(get_Accumulator)(THIS_ long FAR* retval);
	  STDMETHOD(put_Operand)(THIS_ long newOperand);
	  STDMETHOD(get_Operand)(THIS_ long FAR* retval);
	  STDMETHOD(put_Operator)(THIS_ long newOperator);
	  STDMETHOD(get_Operator)(THIS_ long FAR* retval);
	  STDMETHOD(put_Display)(THIS_ long newDisplay);
	  STDMETHOD(get_Display)(THIS_ long FAR* retval);	  
	  STDMETHOD(Button)(THIS_ BSTR b);
	  STDMETHOD(Quit)(THIS);	  
	END_DUAL_INTERFACE_PART(DualMycalc3)

};

/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Developer Studio will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_DLGPROXY_H__FB1AE90E_4A0B_11D1_B1F7_00AA0019F5FB__INCLUDED_)
