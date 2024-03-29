 If Session.ActiveWindow.Text = "Error" Then Err.Raise 99 ' error detected?
    '
' find the collection object that contains the Message from the bottom of the SAP screen and write the message to Excel
    Info (17)    ' puts the Message in the 17th column on the Excel Spreadsheet - column "Q"
'
    If Session.ActiveWindow.Name = "wnd[1]" And Session.ActiveWindow.Text = "Log Off" Then
        Session.findById("wnd[1]/usr/btnSPOP-OPTION2").press
        Sheets("SAP_DATA").Cells(lDataRow, 16) = "error"
    End If
'-------------------------------------------------------
    Exit Sub
ErrorHandler:
    Sleep (1000)
        'return the error message 3/4/06 - ***
                sMessage = "Error # " & Str(Err.Number) & " was generated by " _
            & Err.Source & Chr(13) & Err.Description '& Err.HelpFile & Err.HelpContext
            Sheets("SAP_DATA").Cells(lDataRow, 21) = sMessage
'---------------------------------
    If StopOnErrors = vbYes Then
        Application.WindowState = xlMaximized
        If lDataRow > 10 Then ActiveWindow.ScrollRow = lDataRow - 5
        StopOnErrors = MsgBox("Do you want to Stop On the next Error ?", vbYesNo, "Error Found")
        Application.WindowState = xlMinimized
    Else
        If Session.ActiveWindow.Name = "wnd[1]" And Session.ActiveWindow.Type = "GuiModalWindow" Then ' Information Pop Up Box exists
            Sheets("SAP_DATA").Cells(lDataRow, 22) = Session.ActiveWindow.PopupDialogText ' capture message
            Session.findById("wnd[0]/tbar[0]/btn[0]").press '- enter key
        End If
        Info iColumn  'capture any SAP message and write to excel
        'test the message
        If Session.ActiveWindow.children.Count > 1 Then ' see if the collection item exists
            If Session.ActiveWindow.children.Item((Session.ActiveWindow.children.Count - 1)).Text <> "" Then 'message exists
                If Session.ActiveWindow.children.Item((Session.ActiveWindow.children.Count - 1)).MessageType <> "E" Then Session.findById("wnd[0]/tbar[0]/btn[0]").press 'enter through warnings and Informational messages
            End If
