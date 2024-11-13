// mycalc3Dlg.cpp : implementation file
//

#include "stdafx.h"
#include "mycalc3.h"
#include "myDlg.h"
#include "DlgProxy.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CMycalc3Dlg dialog

IMPLEMENT_DYNAMIC(CMycalc3Dlg, CDialog);

CMycalc3Dlg::CMycalc3Dlg(CWnd* pParent /*=NULL*/)
	: CDialog(CMycalc3Dlg::IDD, pParent)
{
	//{{AFX_DATA_INIT(CMycalc3Dlg)
		// NOTE: the ClassWizard will add member initialization here
	//}}AFX_DATA_INIT
	// Note that LoadIcon does not require a subsequent DestroyIcon in Win32
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
	m_pAutoProxy = NULL;
}

CMycalc3Dlg::~CMycalc3Dlg()
{
	// If there is an automation proxy for this dialog, set
	//  its back pointer to this dialog to NULL, so it knows
	//  the dialog has been deleted.
	if (m_pAutoProxy != NULL)
		m_pAutoProxy->m_pDialog = NULL;
}

void CMycalc3Dlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CMycalc3Dlg)
		// NOTE: the ClassWizard will add DDX and DDV calls here
	//}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CMycalc3Dlg, CDialog)
	//{{AFX_MSG_MAP(CMycalc3Dlg)
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	ON_WM_CLOSE()
	ON_BN_CLICKED(IDC_FIVE, OnFive)
	ON_BN_CLICKED(IDC_FOUR, OnFour)
	ON_BN_CLICKED(IDC_DIV, OnDiv)
	ON_BN_CLICKED(IDC_EIGHT, OnEight)
	ON_BN_CLICKED(IDC_EQUALS, OnEquals)
	ON_BN_CLICKED(IDC_MINUS, OnMinus)
	ON_BN_CLICKED(IDC_MULT, OnMult)
	ON_BN_CLICKED(IDC_NINE, OnNine)
	ON_BN_CLICKED(IDC_ONE, OnOne)
	ON_BN_CLICKED(IDC_PLUS, OnPlus)
	ON_BN_CLICKED(IDC_SEVEN, OnSeven)
	ON_BN_CLICKED(IDC_SIX, OnSix)
	ON_BN_CLICKED(IDC_THREE, OnThree)
	ON_BN_CLICKED(IDC_TWO, OnTwo)
	ON_BN_CLICKED(IDC_ZERO, OnZero)
	ON_BN_CLICKED(IDC_CLEAR, OnClear)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CMycalc3Dlg message handlers

BOOL CMycalc3Dlg::OnInitDialog()
{
	CDialog::OnInitDialog();

	// Set the icon for this dialog.  The framework does this automatically
	//  when the application's main window is not a dialog
	SetIcon(m_hIcon, TRUE);			// Set big icon
	SetIcon(m_hIcon, FALSE);		// Set small icon
	
	// TODO: Add extra initialization here
	
	return TRUE;  // return TRUE  unless you set the focus to a control
}

// If you add a minimize button to your dialog, you will need the code below
//  to draw the icon.  For MFC applications using the document/view model,
//  this is automatically done for you by the framework.

void CMycalc3Dlg::OnPaint() 
{
	if (IsIconic())
	{
		CPaintDC dc(this); // device context for painting

		SendMessage(WM_ICONERASEBKGND, (WPARAM) dc.GetSafeHdc(), 0);

		// Center icon in client rectangle
		int cxIcon = GetSystemMetrics(SM_CXICON);
		int cyIcon = GetSystemMetrics(SM_CYICON);
		CRect rect;
		GetClientRect(&rect);
		int x = (rect.Width() - cxIcon + 1) / 2;
		int y = (rect.Height() - cyIcon + 1) / 2;

		// Draw the icon
		dc.DrawIcon(x, y, m_hIcon);
	}
	else
	{
		CDialog::OnPaint();
	}
}

// The system calls this to obtain the cursor to display while the user drags
//  the minimized window.
HCURSOR CMycalc3Dlg::OnQueryDragIcon()
{
	return (HCURSOR) m_hIcon;
}

// Automation servers should not exit when a user closes the UI
//  if a controller still holds on to one of its objects.  These
//  message handlers make sure that if the proxy is still in use,
//  then the UI is hidden but the dialog remains around if it
//  is dismissed.

void CMycalc3Dlg::OnClose() 
{
	if (CanExit())
		CDialog::OnClose();
}


void CMycalc3Dlg::OnOK() 
{
	if (CanExit())
		CDialog::OnOK();
}

void CMycalc3Dlg::OnCancel() 
{
	if (CanExit())
		CDialog::OnCancel();
}


BOOL CMycalc3Dlg::CanExit()
{
	// If the proxy object is still around, then the automation
	//  controller is still holding on to this application.  Leave
	//  the dialog around, but hide its UI.
	if (m_pAutoProxy != NULL)
	{
		ShowWindow(SW_HIDE);
		return FALSE;
	}

	return TRUE;
}

void CMycalc3Dlg::OnFive() 
{
	// TODO: Add your control notification handler code here
	//SetDlgItemText(IDC_DISPLAY,"5") ;
	m_arith.Button("5",this) ;
}

void CMycalc3Dlg::OnFour() 
{
	// TODO: Add your control notification handler code here
	//SetDlgItemText(IDC_DISPLAY,"4") ;
    m_arith.Button("4",this) ;
}

void CMycalc3Dlg::OnDiv() 
{
	// TODO: Add your control notification handler code here
	m_arith.Button("/",this) ;
}

void CMycalc3Dlg::OnEight() 
{
	// TODO: Add your control notification handler code here
	m_arith.Button("8",this) ;
}

void CMycalc3Dlg::OnEquals() 
{
	// TODO: Add your control notification handler code here
	m_arith.Button("=",this) ;
}

void CMycalc3Dlg::OnMinus() 
{
	// TODO: Add your control notification handler code here
	m_arith.Button("-",this) ;
}

void CMycalc3Dlg::OnMult() 
{
	// TODO: Add your control notification handler code here
	m_arith.Button("*",this) ;
}

void CMycalc3Dlg::OnNine() 
{
	// TODO: Add your control notification handler code here
	m_arith.Button("9",this) ;
}

void CMycalc3Dlg::OnOne() 
{
	// TODO: Add your control notification handler code here
	m_arith.Button("1",this) ;
}

void CMycalc3Dlg::OnPlus() 
{
	// TODO: Add your control notification handler code here
	m_arith.Button("+",this) ;
}

void CMycalc3Dlg::OnSeven() 
{
	// TODO: Add your control notification handler code here
	m_arith.Button("7",this) ;
}

void CMycalc3Dlg::OnSix() 
{
	// TODO: Add your control notification handler code here
	m_arith.Button("6",this) ;
}

void CMycalc3Dlg::OnThree() 
{
	// TODO: Add your control notification handler code here
	m_arith.Button("3",this) ;
}

void CMycalc3Dlg::OnTwo() 
{
	// TODO: Add your control notification handler code here
	m_arith.Button("2",this) ;
}

void CMycalc3Dlg::OnZero() 
{
	// TODO: Add your control notification handler code here
	m_arith.Button("0",this) ;
}


void CMycalc3Dlg::OnClear() 
{
	// TODO: Add your control notification handler code here
	m_arith.Button("C",this) ;
}
