Attribute VB_Name = "Module1"
Public Type Rct
            L As Long
            T As Long
            R As Long
            B As Long
End Type

Public Win As Long

Public Const BaseLeft = 350
Public Const BaseTop = 800
Public Const BaseRight = 3500
Public Const BaseBottom = 2900

Public Const IDC As Long = 100

Public Declare Function dll1_custom_Create Lib "..\..\dlls\exe\Dll1" (ByVal Parent As Long, ByRef Rect As Rct, ByVal IDC As Long) As Long
Public Declare Sub dll1_custom_Destroy Lib "..\..\dlls\exe\Dll1" (ByVal Win As Long)

Public Declare Sub dll2_getstring Lib "..\..\dlls\exe\Dll2" (ByRef Str As String)
Public Declare Sub dll2_mark_gstack Lib "..\..\dlls\exe\Dll2" (ByRef Stack As Long)
Public Declare Sub dll2_release_gstack Lib "..\..\dlls\exe\Dll2" (ByVal Stack As Long)
