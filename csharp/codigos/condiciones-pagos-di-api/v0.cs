/*
Fuente: https://foros.consultoria-sap.com/t/llenar-una-grilla-con-las-formas-de-pago-con-diapi/20158
Autor/es: GrabrielGS 
*/

Dim oRecordSet As SAPbobsCOM.Recordset
  Dim sCodigoCondicion as Int
  Dim sNombreCondicion as String

  oRecordSet = oCompany.GetBusinessObject(SAPbobsCOM.BoObjectTypes.BoRecordset)

  oRecordSet.DoQuery("SELECT * FROM OCTG")
  
  oRecordSet.MoveFirst()

  While Not oRecordSet.EoF

    sCodigoCondicion  = oRecordSet .Fields.Item("GroupNum").Value
    sNombreCondicion  = oRecordSet .Fields.Item("PymntGroup").Value)

    oRecordSet .MoveNext()

  End While
