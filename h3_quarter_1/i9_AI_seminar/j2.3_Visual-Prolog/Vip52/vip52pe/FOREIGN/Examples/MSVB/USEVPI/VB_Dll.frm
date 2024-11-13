VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Visual Basic Form (Test DLL)"
   ClientHeight    =   3732
   ClientLeft      =   48
   ClientTop       =   336
   ClientWidth     =   6552
   LinkTopic       =   "Form1"
   ScaleHeight     =   3732
   ScaleWidth      =   6552
   StartUpPosition =   2  'CenterScreen
   Begin VB.CommandButton ComClose 
      Caption         =   "Close"
      Height          =   372
      Left            =   2280
      TabIndex        =   3
      Top             =   3120
      Width           =   1572
   End
   Begin VB.Frame Frame2 
      Height          =   2772
      Left            =   4080
      TabIndex        =   0
      Top             =   120
      Width           =   2292
      Begin VB.CommandButton ComGetStr 
         Caption         =   "Get String"
         Height          =   372
         Left            =   360
         TabIndex        =   2
         Top             =   2040
         Width           =   1572
      End
      Begin VB.Label Label1 
         Alignment       =   2  'Center
         Caption         =   "Return value from DLL2"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   7.8
            Charset         =   204
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   252
         Left            =   120
         TabIndex        =   4
         Top             =   240
         Width           =   2052
      End
   End
   Begin VB.CheckBox Check1 
      Caption         =   "Create/Destroy control in DLL1"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   7.8
         Charset         =   204
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   492
      Left            =   480
      TabIndex        =   1
      Top             =   240
      Width           =   3492
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub Check1_Click()
    If Check1.Value = 1 Then
        Dim Rect As Rct
            Rect.L = BaseLeft / Screen.TwipsPerPixelX
            Rect.T = BaseTop / Screen.TwipsPerPixelY
            Rect.R = BaseRight / Screen.TwipsPerPixelX
            Rect.B = BaseBottom / Screen.TwipsPerPixelY
        Win = dll1_custom_Create(Me.hWnd, Rect, IDC)
    Else
        Call dll1_custom_Destroy(Win)
    End If
End Sub

Private Sub ComClose_Click()
    Unload Me
End Sub

Private Sub ComGetStr_Click()
    Dim Stack As Long
    Dim Str As String
    Call dll2_mark_gstack(Stack)
    Call dll2_getstring(Str)
    MsgBox Str, vbOKOnly, "Visual Basic"
    Call dll2_release_gstack(Stack)
End Sub

Private Sub Form_Load()

End Sub
