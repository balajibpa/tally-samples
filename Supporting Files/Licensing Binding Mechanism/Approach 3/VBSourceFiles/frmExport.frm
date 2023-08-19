VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Begin VB.Form frmRequest 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Request Tally - Approach 3"
   ClientHeight    =   4260
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   6165
   BeginProperty Font 
      Name            =   "MS Sans Serif"
      Size            =   8.25
      Charset         =   0
      Weight          =   700
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   ScaleHeight     =   4260
   ScaleWidth      =   6165
   StartUpPosition =   3  'Windows Default
   Begin VB.TextBox txtResponseStr 
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   350
      Left            =   2040
      TabIndex        =   15
      Top             =   2760
      Width           =   3975
   End
   Begin VB.CommandButton CmdDecrypt 
      Caption         =   "&Decrypt"
      Height          =   375
      Left            =   2400
      TabIndex        =   13
      Top             =   3480
      Width           =   1455
   End
   Begin VB.TextBox txtResponseSlNo 
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   350
      Left            =   2040
      TabIndex        =   11
      Top             =   2280
      Width           =   3975
   End
   Begin VB.TextBox txtEncPwd 
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   350
      Left            =   2040
      TabIndex        =   4
      Text            =   "Password"
      Top             =   1440
      Width           =   3975
   End
   Begin MSComctlLib.StatusBar sbExport 
      Align           =   2  'Align Bottom
      Height          =   375
      Left            =   0
      TabIndex        =   8
      Top             =   3885
      Width           =   6165
      _ExtentX        =   10874
      _ExtentY        =   661
      Style           =   1
      _Version        =   393216
      BeginProperty Panels {8E3867A5-8586-11D1-B16A-00C0F0283628} 
         NumPanels       =   1
         BeginProperty Panel1 {8E3867AB-8586-11D1-B16A-00C0F0283628} 
         EndProperty
      EndProperty
   End
   Begin VB.TextBox txtPortNo 
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   350
      Left            =   4920
      MaxLength       =   5
      TabIndex        =   1
      Text            =   "9000"
      Top             =   120
      Width           =   855
   End
   Begin VB.TextBox txtSystemName 
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   350
      Left            =   2040
      MaxLength       =   100
      TabIndex        =   0
      Text            =   "LocalHost"
      Top             =   120
      Width           =   2655
   End
   Begin VB.CommandButton cmdExit 
      Cancel          =   -1  'True
      Caption         =   "E&xit"
      Height          =   375
      Left            =   4200
      TabIndex        =   5
      Top             =   3480
      Width           =   1215
   End
   Begin VB.CommandButton cmdRequest 
      Caption         =   "&Request Tally"
      Height          =   375
      Left            =   600
      TabIndex        =   3
      Top             =   3480
      Width           =   1455
   End
   Begin VB.TextBox txtEncStr 
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   350
      Left            =   2040
      TabIndex        =   2
      Text            =   "Govind"
      Top             =   960
      Width           =   3975
   End
   Begin VB.Label LblResponseStr 
      AutoSize        =   -1  'True
      Caption         =   "Response String"
      Height          =   195
      Index           =   1
      Left            =   120
      TabIndex        =   14
      Top             =   2880
      Width           =   1410
   End
   Begin VB.Label LblResponseSlNo 
      AutoSize        =   -1  'True
      Caption         =   "Response Serial No"
      Height          =   195
      Index           =   0
      Left            =   120
      TabIndex        =   12
      Top             =   2400
      Width           =   1695
   End
   Begin VB.Label Label1 
      Caption         =   ":"
      Height          =   135
      Left            =   5160
      TabIndex        =   10
      Top             =   240
      Width           =   375
   End
   Begin VB.Label LblEncPwd 
      AutoSize        =   -1  'True
      Caption         =   "Password to Encrypt"
      Height          =   195
      Index           =   1
      Left            =   120
      TabIndex        =   9
      Top             =   1560
      Width           =   1755
   End
   Begin VB.Label Label2 
      AutoSize        =   -1  'True
      Caption         =   "System IP:Port"
      Height          =   195
      Left            =   120
      TabIndex        =   7
      Top             =   240
      Width           =   1260
   End
   Begin VB.Label LblEncStr 
      AutoSize        =   -1  'True
      Caption         =   "String for Encryption"
      Height          =   195
      Index           =   0
      Left            =   120
      TabIndex        =   6
      Top             =   1080
      Width           =   1755
   End
End
Attribute VB_Name = "frmRequest"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Public responsestr As String
Public XMLDOM As New MSXML2.DOMDocument30
Public CHILDNODEEncSl As Object
Public CHILDNODEEncStr As Object
Private Declare Function DecryptStr Lib "encryptdecrypt.dll" _
(ByVal InputStr As String, ByVal Key As String, ByRef outstr As String, ByRef outstrlen As Integer) As Integer
Option Explicit

Private Sub CmdExit_Click()
Unload Me
End
End Sub
Private Sub cmdRequest_Click()

Dim objXml As MSXML2.ServerXMLHTTP
Dim strXmldata As String

If Trim$(txtSystemName.Text) = vbNullString Then
    MsgBox "System Name/IP Address cannot be blank", , "Tally"
    txtSystemName.SetFocus
    Exit Sub
End If

If Trim$(txtPortNo.Text) = vbNullString Then
    MsgBox "Port No. cannot be blank", , "Tally"
    txtPortNo.SetFocus
    Exit Sub
End If

Set objXml = New MSXML2.ServerXMLHTTP

strXmldata = _
    "<ENVELOPE>" & vbCrLf & _
    "<HEADER>" & vbCrLf & _
    "<VERSION>1</VERSION>" & vbCrLf & _
    "<TALLYREQUEST>" & _
    "Export</TALLYREQUEST>" & vbCrLf & _
    "<TYPE>Data</TYPE>" & vbCrLf & _
    "<ID>Sec XML Request3</ID>" & vbCrLf & _
    "</HEADER>" & vbCrLf & _
    "<BODY>" & vbCrLf & _
    "<DESC>" & _
    "<STATICVARIABLES>" & _
    "<SVEXPORTFORMAT>$$SysName:XML</SVEXPORTFORMAT>" & _
    "<EncString>" & txtEncStr.Text & _
    "</EncString>" & _
    "<Password>" & txtEncPwd.Text & _
    "</Password>" & _
    "</STATICVARIABLES>" & _
    "</DESC></BODY></ENVELOPE>"

objXml.open "POST", "http://" & Trim$(txtSystemName.Text) & ":" & Trim$(txtPortNo.Text), False
objXml.send strXmldata
responsestr = objXml.responseText

XMLDOM.loadXML (responsestr)
Set CHILDNODEEncSl = XMLDOM.selectNodes("/ENVELOPE/TALLYLICENSEINFO/SERIALNUMBER")
Set CHILDNODEEncStr = XMLDOM.selectNodes("/ENVELOPE/TALLYLICENSEINFO/ENCRYPTEDSTRING")
txtResponseSlNo.Text = CHILDNODEEncSl(0).Text
txtResponseStr.Text = CHILDNODEEncStr(0).Text

CmdDecrypt.Enabled = True

End Sub

Private Sub CmdDecrypt_Click()
Dim outslno As String * 128
Dim outstr As String * 128
Dim mystr As String
Dim retval As Integer
Dim outbuflen As Integer

If txtResponseSlNo.Text = "" Or txtResponseStr.Text = "" Then
    CmdDecrypt.Enabled = False
    txtSystemName.SetFocus
Else
    mystr = txtResponseSlNo.Text
    retval = DecryptStr(mystr, txtEncPwd.Text, outslno, outbuflen)
    txtResponseSlNo.Text = StrConv(outslno, vbFromUnicode)
    
    mystr = txtResponseStr.Text
    retval = DecryptStr(mystr, txtEncPwd.Text, outstr, outbuflen)
    txtResponseStr.Text = StrConv(outstr, vbFromUnicode)
End If
End Sub

Private Sub Form_Load()
    CmdDecrypt.Enabled = False
End Sub

