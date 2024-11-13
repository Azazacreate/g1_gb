// call_dllDlg.cpp : implementation file
//

#include "stdafx.h"
#include "call_dll.h"
#include "call_dllDlg.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

extern "C" {
  typedef LONG (APIENTRY *CallBack)( char* String );
  LONG APIENTRY myCallBack( char* String );
  
  /*Calls to "DLL1"*/
  void APIENTRY dll1_mark_gstack(unsigned long *out);
  void APIENTRY dll1_release_gstack(unsigned long in);
  HWND APIENTRY dll1_custom_Create(HWND Parent, RECT *rect, int Id);
  void APIENTRY dll1_custom_Destroy(HWND);
  
  /*Calls to "DLL2"*/
  void APIENTRY dll2_mark_gstack(unsigned long *out);
  void APIENTRY dll2_release_gstack(unsigned long in);
  void APIENTRY dll2_callCallback( CallBack );
  void APIENTRY dll2_getstring(char** Out);
}
/* Global variables */
HWND CustWIN = NULL;

/* constants */
#define MAX_STR 80
#define IDC_MY_CUSTOM 100

/**********************************
	callback that will be 
	  called from DLL
**********************************/
LONG APIENTRY myCallBack( char* String )
{
  MessageBox( NULL, String, "Message from DLL",
    MB_TASKMODAL | MB_ICONINFORMATION | MB_OK );
  return 0;
}

/////////////////////////////////////////////////////////////////////////////
// CAboutDlg dialog used for App About

class CAboutDlg : public CDialog
{
public:
	CAboutDlg();

// Dialog Data
	//{{AFX_DATA(CAboutDlg)
	enum { IDD = IDD_ABOUTBOX };
	//}}AFX_DATA

	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CAboutDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:
	//{{AFX_MSG(CAboutDlg)
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

CAboutDlg::CAboutDlg() : CDialog(CAboutDlg::IDD)
{
	//{{AFX_DATA_INIT(CAboutDlg)
	//}}AFX_DATA_INIT
}

void CAboutDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CAboutDlg)
	//}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CAboutDlg, CDialog)
	//{{AFX_MSG_MAP(CAboutDlg)
		// No message handlers
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CCall_dllDlg dialog

CCall_dllDlg::CCall_dllDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CCall_dllDlg::IDD, pParent)
{
	//{{AFX_DATA_INIT(CCall_dllDlg)
		// NOTE: the ClassWizard will add member initialization here
	//}}AFX_DATA_INIT
	// Note that LoadIcon does not require a subsequent DestroyIcon in Win32
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
}

void CCall_dllDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CCall_dllDlg)
		// NOTE: the ClassWizard will add DDX and DDV calls here
	//}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CCall_dllDlg, CDialog)
	//{{AFX_MSG_MAP(CCall_dllDlg)
	ON_WM_SYSCOMMAND()
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	ON_BN_CLICKED(IDC_get_string, Ongetstring)
	ON_BN_CLICKED(IDC_hello, Onhello)
	ON_BN_CLICKED(IDC_by_DLL1, OnbyDLL1)
	ON_WM_DESTROY()
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CCall_dllDlg message handlers

BOOL CCall_dllDlg::OnInitDialog()
{
	CDialog::OnInitDialog();

	// Add "About..." menu item to system menu.

	// IDM_ABOUTBOX must be in the system command range.
	ASSERT((IDM_ABOUTBOX & 0xFFF0) == IDM_ABOUTBOX);
	ASSERT(IDM_ABOUTBOX < 0xF000);

	CMenu* pSysMenu = GetSystemMenu(FALSE);
	if (pSysMenu != NULL)
	{
		CString strAboutMenu;
		strAboutMenu.LoadString(IDS_ABOUTBOX);
		if (!strAboutMenu.IsEmpty())
		{
			pSysMenu->AppendMenu(MF_SEPARATOR);
			pSysMenu->AppendMenu(MF_STRING, IDM_ABOUTBOX, strAboutMenu);
		}
	}

	// Set the icon for this dialog.  The framework does this automatically
	//  when the application's main window is not a dialog
	SetIcon(m_hIcon, TRUE);			// Set big icon
	SetIcon(m_hIcon, FALSE);		// Set small icon
	
	// TODO: Add extra initialization here
	
	return TRUE;  // return TRUE  unless you set the focus to a control
}

void CCall_dllDlg::OnSysCommand(UINT nID, LPARAM lParam)
{
	if ((nID & 0xFFF0) == IDM_ABOUTBOX)
	{
		CAboutDlg dlgAbout;
		dlgAbout.DoModal();
	}
	else
	{
		CDialog::OnSysCommand(nID, lParam);
	}
}

// If you add a minimize button to your dialog, you will need the code below
//  to draw the icon.  For MFC applications using the document/view model,
//  this is automatically done for you by the framework.

void CCall_dllDlg::OnPaint() 
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
HCURSOR CCall_dllDlg::OnQueryDragIcon()
{
	return (HCURSOR) m_hIcon;
}

void CCall_dllDlg::Ongetstring() 
{
	// TODO: Add your control notification handler code here
	  unsigned long StackMark;
	  char *Str, buff[MAX_STR];
	  
  	  dll2_mark_gstack( &StackMark );
    	  dll2_getstring(&Str);
    	  if( strlen( Str ) >= MAX_STR )
    	    Str[MAX_STR - 1] = '\0'; /*trancate long string*/
    	  strcpy( buff, Str );
  	  dll2_release_gstack( StackMark );

          MessageBox( buff, "Get" );
}

void CCall_dllDlg::Onhello() 
{
	// TODO: Add your control notification handler code here
  	  dll2_callCallback( myCallBack );
}

void CCall_dllDlg::OnbyDLL1() 
{
	// TODO: Add your control notification handler code here
          if( CustWIN )
          {
 	    dll1_custom_Destroy( CustWIN );
 	    CustWIN = NULL;
	    SendDlgItemMessage(  IDC_by_DLL1, BM_SETCHECK, 0, 0 );
          }
          else
          {
            RECT rct = {10,45,290,235};
  	    CustWIN = dll1_custom_Create( m_hWnd, &rct, IDC_MY_CUSTOM );
	    SendDlgItemMessage(  IDC_by_DLL1, BM_SETCHECK, 1, 0 );
          }
}

void CCall_dllDlg::OnDestroy() 
{
	CDialog::OnDestroy();
	
	// TODO: Add your message handler code here
      if( CustWIN )
      {
 	dll1_custom_Destroy( CustWIN );
 	CustWIN = NULL;
      }
}
