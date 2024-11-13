#include <windows.h>
#include <commctrl.h>
#include "pdcrunt.h"

HWND _wcc_create(HINSTANCE Hinst,HWND Parent,char *ClassName,char * WinName,unsigned Flags);
HIMAGELIST _wcc_bitmap_create(int Width,int Height,int Num);
int _wcc_bitmap_add(HINSTANCE Hinst,HIMAGELIST himl,int BitmapId);
void _wcc_bitmap_destroy(HIMAGELIST himl);
void _wcc_SetWindowStyle(HWND,DWORD Style);
DWORD _wcc_GetWindowStyle(HWND);
HWND _wcc_WindowFromPoint(int X,int Y);
DWORD _wcc_WinSendMessage(HWND hWnd,int mess,WPARAM wParam,LPARAM lParam);
ATOM _wcc_GlobalAddAtom(char *String);
void _wcc_GlobalDeleteAtom(ATOM nAtom);
char * _wcc_GlobalGetAtomName(ATOM nAtom);

HWND _wcc_create(HINSTANCE Hinst,HWND Parent,char *ClassName,char * WinName,unsigned Flags)
{
RECT rcClient;
HWND hwndTV;

InitCommonControls(); 
GetClientRect(Parent,&rcClient); 
hwndTV = CreateWindowEx(0,ClassName,WinName, 
WS_VISIBLE | WS_CHILD | WS_BORDER | Flags, 
0, 0, rcClient.right, rcClient.bottom, 
Parent,0,Hinst,NULL); 
return hwndTV; 
}

HIMAGELIST _wcc_bitmap_create(int Width,int Height,int Num)
{ 
HIMAGELIST himl;

himl=ImageList_Create(Width,Height,FALSE,Num,0);
return himl;
} 

int _wcc_bitmap_add(HINSTANCE Hinst,HIMAGELIST himl,int BitmapId)
{ 
HBITMAP hbmp;
int himage;

hbmp = LoadBitmap(Hinst,MAKEINTRESOURCE(BitmapId)); 
himage = ImageList_Add(himl,hbmp,(HBITMAP)NULL); 
DeleteObject(hbmp); 
return himage; 
} 

void _wcc_bitmap_destroy(HIMAGELIST himl)
{
ImageList_Destroy(himl);
return;
}

void _wcc_SetWindowStyle(HWND Window,DWORD Style) 
{ 
SetWindowLong(Window,GWL_STYLE,Style); 
return;
} 

DWORD _wcc_GetWindowStyle(HWND Window) 
{ 
return(GetWindowLong(Window,GWL_STYLE)); 
} 

HWND _wcc_WindowFromPoint(int X,int Y)
{
POINT  Point;

Point.x=X;
Point.y=Y;
return(WindowFromPoint(Point));
}

DWORD _wcc_WinSendMessage(HWND hWnd,int mess,WPARAM wParam,LPARAM lParam)
{
return(SendMessage(hWnd,mess,wParam,lParam));
}

ATOM _wcc_GlobalAddAtom(char *String)
{
return(GlobalAddAtom(String));
}

void _wcc_GlobalDeleteAtom(ATOM nAtom)
{
GlobalDeleteAtom(nAtom);
return;
}

char * _wcc_GlobalGetAtomName(ATOM nAtom)
{
char *Str;

Str = MEM_AllocGStack(255);
GlobalGetAtomName(nAtom,Str,255);
return(Str);
}

