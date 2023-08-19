VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Begin VB.Form frmRequest 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Request Tally - Approach 1"
   ClientHeight    =   2820
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   6300
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
   ScaleHeight     =   2820
   ScaleWidth      =   6300
   StartUpPosition =   3  'Windows Default
   Begin VB.TextBox txtResponseAccID 
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
      Left            =   2160
      TabIndex        =   9
      Top             =   1440
      Width           =   3975
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
      Left            =   2160
      TabIndex        =   6
      Top             =   840
      Width           =   3975
   End
   Begin MSComctlLib.StatusBar sbExport 
      Align           =   2  'Align Bottom
      Height          =   255
      Left            =   0
      TabIndex        =   5
      Top             =   2565
      Width           =   6300
      _ExtentX        =   11113
      _ExtentY        =   450
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
      Left            =   5280
      MaxLength       =   5
      TabIndex        =   1
      Text            =   "9000"
      Top             =   240
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
      Left            =   2160
      MaxLength       =   100
      TabIndex        =   0
      Text            =   "Localhost"
      Top             =   240
      Width           =   2655
   End
   Begin VB.CommandButton cmdExit 
      Cancel          =   -1  'True
      Caption         =   "E&xit"
      Height          =   375
      Left            =   3480
      TabIndex        =   3
      Top             =   2040
      Width           =   1215
   End
   Begin VB.CommandButton cmdRequest 
      Caption         =   "&Request Tally"
      Height          =   375
      Left            =   1320
      TabIndex        =   2
      Top             =   2040
      Width           =   1455
   End
   Begin VB.Label LblResponseStr 
      AutoSize        =   -1  'True
      Caption         =   "Response Account ID"
      Height          =   195
      Index           =   1
      Left            =   120
      TabIndex        =   8
      Top             =   1560
      Width           =   1875
   End
   Begin VB.Label LblResponseSlNo 
      AutoSize        =   -1  'True
      Caption         =   "Response Serial No"
      Height          =   195
      Index           =   0
      Left            =   120
      TabIndex        =   7
      Top             =   960
      Width           =   1695
   End
   Begin VB.Label Label2 
      AutoSize        =   -1  'True
      Caption         =   "System IP:Port"
      Height          =   195
      Left            =   120
      TabIndex        =   4
      Top             =   360
      Width           =   1260
   End
End
Attribute VB_Name = "frmRequest"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Public XMLDOM As New MSXML2.DOMDocument30
Public CHILDNODESlNo As Object
Public CHILDNODEAccID As Object

Private Sub CmdExit_Click()
Unload Me
End
End Sub
Private Sub cmdRequest_Click()

Dim responsestr As String
Dim strParam As String

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

strParam = "SERIALNUMBER"
responsestr = RequestXMLTally(strParam)

txtResponseSlNo.Text = responsestr

strParam = "ACCOUNTID"
responsestr = RequestXMLTally(strParam)

txtResponseAccID.Text = responsestr

End Sub

Private Function RequestXMLTally(pStrParam As String)

Dim objXml As MSXML2.ServerXMLHTTP
Dim strXmldata As String
Dim responsestr As String

Set objXml = New MSXML2.ServerXMLHTTP
strXmldata = _
    "<ENVELOPE>" & vbCrLf & _
    "<HEADER>" & vbCrLf & _
    "<VERSION>1</VERSION>" & vbCrLf & _
    "<TALLYREQUEST>" & _
    "Export</TALLYREQUEST>" & vbCrLf & _
    "<TYPE>Function</TYPE>" & vbCrLf & _
    "<ID>$$LicenseInfo</ID>" & vbCrLf & _
    "</HEADER>" & vbCrLf & _
    "<BODY>" & vbCrLf & _
    "<DESC>" & _
    "<STATICVARIABLES>" & _
    "<SVEXPORTFORMAT>$$SysName:XML</SVEXPORTFORMAT>" & _
    "</STATICVARIABLES>" & _
    "<FUNCPARAMLIST>" & _
    "<PARAM>" & pStrParam & "</PARAM>" & _
    "</FUNCPARAMLIST>" & _
    "</DESC></BODY></ENVELOPE>"

objXml.open "POST", "http://" & Trim$(txtSystemName.Text) & ":" & Trim$(txtPortNo.Text), False
objXml.send strXmldata

responsestr = objXml.responseText

XMLDOM.loadXML (responsestr)
Set CHILDNODEStr = XMLDOM.selectNodes("/ENVELOPE/BODY/DATA/RESULT")
RequestXMLTally = CHILDNODEStr(0).Text

End Function

