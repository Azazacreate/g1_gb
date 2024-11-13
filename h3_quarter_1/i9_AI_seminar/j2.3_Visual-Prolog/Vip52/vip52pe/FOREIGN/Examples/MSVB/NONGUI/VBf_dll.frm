VERSION 5.00
Begin VB.Form VBf_dll 
   Caption         =   "Visual Basic Form (Set/Get value to/from Dll)"
   ClientHeight    =   2208
   ClientLeft      =   1548
   ClientTop       =   4104
   ClientWidth     =   6132
   LinkTopic       =   "Form1"
   ScaleHeight     =   2208
   ScaleWidth      =   6132
   StartUpPosition =   2  'CenterScreen
   Begin VB.CommandButton ComClose 
      Caption         =   "Close"
      Height          =   372
      Left            =   2280
      TabIndex        =   12
      Top             =   1680
      Width           =   1572
   End
   Begin VB.TextBox TextGetReal 
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   7.8
         Charset         =   204
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   312
      Left            =   4440
      Locked          =   -1  'True
      TabIndex        =   7
      TabStop         =   0   'False
      Top             =   660
      Width           =   1452
   End
   Begin VB.TextBox TextGetStr 
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   7.8
         Charset         =   204
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   312
      Left            =   4440
      Locked          =   -1  'True
      TabIndex        =   11
      TabStop         =   0   'False
      Top             =   1140
      Width           =   1452
   End
   Begin VB.TextBox TextGetInt 
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   7.8
         Charset         =   204
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   312
      Left            =   4440
      Locked          =   -1  'True
      TabIndex        =   3
      TabStop         =   0   'False
      Top             =   180
      Width           =   1452
   End
   Begin VB.CommandButton ComGetReal 
      Caption         =   "Get"
      Height          =   312
      Left            =   3720
      TabIndex        =   6
      Top             =   660
      Width           =   612
   End
   Begin VB.CommandButton ComGetStr 
      Caption         =   "Get"
      Height          =   312
      Left            =   3720
      TabIndex        =   10
      Top             =   1140
      Width           =   612
   End
   Begin VB.CommandButton ComGetInt 
      Caption         =   "Get"
      Height          =   312
      Left            =   3720
      TabIndex        =   2
      Top             =   180
      Width           =   612
   End
   Begin VB.CommandButton ComSetReal 
      Caption         =   "Set"
      Height          =   312
      Left            =   2880
      TabIndex        =   5
      Top             =   660
      Width           =   612
   End
   Begin VB.CommandButton ComSetStr 
      Caption         =   "Set"
      Height          =   312
      Left            =   2880
      TabIndex        =   9
      Top             =   1140
      Width           =   612
   End
   Begin VB.CommandButton ComSetInt 
      Caption         =   "Set"
      Height          =   312
      Left            =   2880
      TabIndex        =   1
      Top             =   180
      Width           =   612
   End
   Begin VB.TextBox TextSetStr 
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   7.8
         Charset         =   204
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   312
      Left            =   1200
      TabIndex        =   8
      Top             =   1140
      Width           =   1572
   End
   Begin VB.TextBox TextSetReal 
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   7.8
         Charset         =   204
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   312
      Left            =   1200
      TabIndex        =   4
      Top             =   660
      Width           =   1572
   End
   Begin VB.TextBox TextSetInt 
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   7.8
         Charset         =   204
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   312
      Left            =   1200
      TabIndex        =   0
      Top             =   180
      Width           =   1572
   End
   Begin VB.Label Label3 
      Caption         =   "String :"
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
      Left            =   240
      TabIndex        =   15
      Top             =   1170
      Width           =   852
   End
   Begin VB.Label Label2 
      Caption         =   "Real :"
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
      Left            =   240
      TabIndex        =   14
      Top             =   690
      Width           =   852
   End
   Begin VB.Label Label1 
      Caption         =   "Integer :"
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
      Left            =   240
      TabIndex        =   13
      Top             =   210
      Width           =   852
   End
End
Attribute VB_Name = "VBf_dll"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub ComClose_Click()
    Unload Me
End Sub

Private Sub ComGetInt_Click()
    Dim Value As Integer
    Call getInteger(Value)
    TextGetInt.Text = Str(Value)
End Sub

Private Sub ComGetReal_Click()
    Dim Value As Double
    Call getReal(Value)
    TextGetReal.Text = Str(Value)
End Sub

Private Sub ComGetStr_Click()
    Dim Value As String
    Dim NewValue As String
    Dim Stack As Long
    Call dll_mark_gstack(Stack)
    Call getString(Value)
    NewValue = Left(Value, Len(Value))
    TextGetStr.Text = NewValue
    Call dll_release_gstack(Stack)
End Sub

Private Sub ComSetInt_Click()
    Call setInteger(Val(TextSetInt.Text))
End Sub

Private Sub ComSetReal_Click()
    Call setReal(Val(TextSetReal.Text))
End Sub

Private Sub ComSetStr_Click()
    Call setString(TextSetStr.Text)
End Sub
