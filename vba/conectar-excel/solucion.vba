Dim Logoncontrol As Object  
Dim objBAPIControl As Object
Dim sapConnection As Object
Dim Total
Dim MyFunc As Object
' Assign.
Set Logoncontrol = CreateObject("SAP.LogonControl.1")
Set objBAPIControl = CreateObject("SAP.Functions")
Set sapConnection = Logoncontrol.NewConnection

'Logon with initial values Credenciales de conexcion

sapConnection.Client = "200"
sapConnection.ApplicationServer = "10.10.0.111"
sapConnection.User = "USUARIO"
sapConnection.Password = "PASSWORD"
sapConnection.SystemNumber = "00"
sapConnection.System = "EMD"
sapConnection.UseSAPLogonIni = False
sapConnection.Language = "ES"
