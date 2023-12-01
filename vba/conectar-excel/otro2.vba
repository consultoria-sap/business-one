'Para ocultar el proceso
Application.ScreenUpdating = False
'Declaration

Dim objBAPIControl As Object 'Function Control (Collective object)
Dim sapConnection As Object 'Connection object
Dim Total
Dim MyFunc As Object
' Assign.
Set objBAPIControl = CreateObject("SAP.Functions")
Set sapConnection = objBAPIControl.Connection

'Logon with initial values Credenciales de conexcion

sapConnection.Client = "mandante"
sapConnection.User = "usuario"
sapConnection.Password = "contraseña"
sapConnection.SystemNumber = 1
sapConnection.System = "system"
sapConnection.HostName = "hostname"
sapConnection.Language = "ES"

If sapConnection.logon(1, True) <> True Then
    MsgBox "No connection to R/3!"
    Exit Sub
End If


Dim SEL_TAB, NAMETAB, TABENTRY, ROW As Object
Dim Result As Boolean
Dim iRow, iColumn, iStart, iStartRow As Integer

iStartRow = 4

Sheets("Obj_ORD").Select

Cells.Clear



'*****************************************************
'Call RFC function TABLE_ENTRIES_GET_VIA_RFC
'*****************************************************
Set MyFunc = objBAPIControl.Add("TABLE_ENTRIES_GET_VIA_RFC")

Dim oParam1 As Object
Dim oParam2 As Object
Dim oParam3 As Object
Dim oParam4 As Object
Dim lv_text As String

Dim lv_contador As Integer


'Descripción de la orden
oParam1.Value = "E"
oParam2.Value = ""
oParam3.Value = "E07T"

Dim lv_orden

lv_orden = "TRKORR = '" + orden + "'"

If lv_orden <> "" Then
    oParam4.Rows.Add
    oParam4.Value(1, "ZEILE") = lv_orden
End If

Result = MyFunc.Call

If Result = True Then
  Set NAMETAB = MyFunc.Tables("NAMETAB")
  Set SEL_TAB = MyFunc.Tables("SEL_TAB")
  Set TABENTRY = MyFunc.Tables("TABENTRY")
Else
    MsgBox MyFunc.EXCEPTION
    objBAPIControl.Connection.LOGOFF
    Exit Sub
End If



If Result <> True Then
  MsgBox (EXCEPTION)
  Exit Sub
End If

'Display Contents of the table

    lv_rango = "D" + CStr(fila)
    Range(lv_rango).Select
'Extraemos desde la pos 21, 60 caracteres de la entrada 1
    Range(lv_rango).Value = Mid(TABENTRY(1, "ENTRY"), 22, 60)
    Range(lv_rango).EntireRow.AutoFit




'*******************************************
'Quit the SAP Application
'*******************************************
objBAPIControl.Connection.LOGOFF

End Sub
