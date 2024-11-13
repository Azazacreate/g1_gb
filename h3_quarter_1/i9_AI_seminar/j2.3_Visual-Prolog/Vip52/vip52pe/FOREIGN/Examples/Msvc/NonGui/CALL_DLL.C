/*****************************************************************************

		Copyright (c) 1984 - 2000 Prolog Development Center A/S
		
			VISUAL Prolog

 Project:  TESTDLL
 FileName: CALL_DLL.C
 Purpose: 
 Written by: Visual Prolog
 Comments:
******************************************************************************/
#include "obj\\call_dll.h"
#include <windows.h>

BOOL CALLBACK myDlgProc( HWND hDlg, UINT iMessage, WPARAM wParam, LPARAM lParam );

void APIENTRY dll_mark_gstack(unsigned long *out);
void APIENTRY dll_release_gstack(unsigned long in);
void APIENTRY setInteger(int In );
void APIENTRY getInteger(int* Out);
void APIENTRY setReal(double In );
void APIENTRY getReal(double* Out );
void APIENTRY setString(char* In);
void APIENTRY getString(char** Out);

/**********************************
	Application entry
*/
int APIENTRY WinMain( HINSTANCE hInstance, HINSTANCE hPrevInstance,
		      LPSTR lpCmdLine, int nCmdShow )
{
  HWND hwnd;
  MSG         msg;
  
  hwnd = CreateDialog(  hInstance,  // handle to application instance
  	MAKEINTRESOURCE(idd_usedll),   // identifies dialog box template name
	NULL,      // handle to owner window
	myDlgProc // pointer to dialog box procedure
	);

  while( GetMessage( &msg, NULL, 0, 0 ) )
  {
    if( IsDialogMessage( hwnd, &msg ) )
      continue;
    TranslateMessage( &msg );
    DispatchMessage( &msg );
  }
  return 0;
}

/**********************************
	Dialog callback
*/
#define MAX_STR 80
BOOL CALLBACK myDlgProc( HWND hDlg, UINT iMessage, WPARAM wParam, LPARAM lParam )
{
  switch( iMessage )
  {
    case WM_INITDIALOG:
     return TRUE;

    case WM_COMMAND:
      switch( wParam )
      {
	case idc_ok:
	  DestroyWindow( hDlg );
	  break;

	case idc_get_s:
	{
	  unsigned long stackmark;
	  char *Out;
  	  dll_mark_gstack(&stackmark);
  	  getString(&Out);
    	  SetDlgItemText( hDlg, idc_s_ret, Out );
  	  dll_release_gstack(stackmark);
	  break;
	}

	case idc_set_s:
	{
	  char in[MAX_STR];
	  in[0] = '\0';
    	  GetDlgItemText( hDlg, idc_s, in, MAX_STR );
  	  setString( in );
	  break;
	}

	case idc_get_r:
	{
	  char buf[MAX_STR];
	  double Out;
  	  getReal(&Out );
	  buf[0] = '\0';
  	  _gcvt( Out, MAX_STR, buf );
    	  SetDlgItemText( hDlg, idc_r_ret, buf );
	  break;
	}

	case idc_set_r:
	{
	  char buf[MAX_STR];
	  double In;
	  buf[0] = '\0';
    	  GetDlgItemText( hDlg, idc_r, buf, MAX_STR );
  	  In = atof( buf );
	  setReal( In );
	  break;
	}

	case idc_get_i:
	{
	  char buf[MAX_STR];
	  int Out;
  	  getInteger(&Out );
	  buf[0] = '\0';
	  _itoa( Out, buf, 10 );
    	  SetDlgItemText( hDlg, idc_i_ret, buf );
	  break;
	}

	case idc_set_i:
	{
	  char buf[MAX_STR];
	  int In;
	  buf[0] = '\0';
    	  GetDlgItemText( hDlg, idc_i, buf, MAX_STR );
  	  In = atoi( buf );
	  setInteger( In );
	  break;
	}
      }
      return FALSE;

    case WM_SYSCOMMAND:
      if( wParam == SC_CLOSE )
	  DestroyWindow( hDlg );
      return FALSE;

    case WM_DESTROY:
      PostQuitMessage( 0 );
      return FALSE;

    default:
      return FALSE;
  }
}