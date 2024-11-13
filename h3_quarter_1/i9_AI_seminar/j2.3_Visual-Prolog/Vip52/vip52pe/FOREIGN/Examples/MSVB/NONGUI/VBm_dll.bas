Attribute VB_Name = "VBm_dll"
Public Declare Sub setString Lib "..\..\dlls\exe\TestDll" (ByVal InStr As String)
Public Declare Sub getString Lib "..\..\dlls\exe\TestDll" (ByRef OutStr As String)
Public Declare Sub setInteger Lib "..\..\dlls\exe\TestDll" (ByVal InInt As Integer)
Public Declare Sub getInteger Lib "..\..\dlls\exe\TestDll" (ByRef OutInt As Integer)
Public Declare Sub setReal Lib "..\..\dlls\exe\TestDll" (ByVal InReal As Double)
Public Declare Sub getReal Lib "..\..\dlls\exe\TestDll" (ByRef OutReal As Double)

Public Declare Sub dll_mark_gstack Lib "..\..\dlls\exe\TestDll" (ByRef Stack As Long)
Public Declare Sub dll_release_gstack Lib "..\..\dlls\exe\TestDll" (ByVal Stack As Long)

