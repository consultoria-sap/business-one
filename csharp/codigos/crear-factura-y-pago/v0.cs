/*
Fuente: https://foros.consultoria-sap.com/t/agregar-factura-y-aplicar-pago-al-mismo-tiempo-sdk/23372/2
Autor/es: chavalito 
*/

private void btnCrearFactura_y_Pago_Click(object sender, EventArgs e) {
    Company oEmpresa = new Company();

    try {
        string baseDeDatosEMPRESA = "NombreEmpresaSAP";
        oEmpresa.Server = "SERVIDOR";
        oEmpresa.LicenseServer = "SERVIDOR:30000";
        oEmpresa.CompanyDB = baseDeDatosEMPRESA;
        oEmpresa.UserName = "usuarioBdSap";
        oEmpresa.Password = "passwordBdSap";
        oEmpresa.DbUserName = "usuarioSQL";
        oEmpresa.DbPassword = "passwordSQL";
        oEmpresa.DbServerType = BoDataServerTypes.dst_MSSQL2014;
        oEmpresa.language = BoSuppLangs.ln_Spanish_La;
        oEmpresa.UseTrusted = false;

        if(oEmpresa.Connect() != 0) {
            //int errNumero = 0; string errMensaje = "";
            oEmpresa.GetLastError(out int errNumero, out string errMensaje);
            oEmpresa.Disconnect();
            Marshal.ReleaseComObject(oEmpresa);
            oEmpresa = null;
            MessageBox.Show("Ha ocurrido el siguiente error al intentar conectar a la Base de Datos " + baseDeDatosEMPRESA + " en SAP\n\n" + errMensaje, tituloMSGBOX, MessageBoxButtons.OK, MessageBoxIcon.Warning);
            return;
        }

        // inicia transaction para asegurarse de que si NO se realicen con éxito todas las operaciones, deshaga cualquier cambio realizado hasta antes del error en caso de ocurrir
        oEmpresa.StartTransaction();

        // procede a crear la factura de proveedores, tomando en cuenta todas las fichas/entradas involucradas
        SAPbobsCOM.Documents facturaCLIENTE = oEmpresa.GetBusinessObject(BoObjectTypes.oInvoices);
        facturaCLIENTE.CardCode = "C9999";

        facturaCLIENTE.DocDate = DateTime.Now;
        facturaCLIENTE.DocDueDate = DateTime.Now;
        facturaCLIENTE.TaxDate = DateTime.Now;
        //facturaCLIENTE.UserFields.Fields.Item("U_CampoUsuario").Value = "valor";    // ejemplo para asignar algún valor a un campo de usuario a nivel encabezado
        //facturaCLIENTE.Series = 99; // en caso de que tengas más de una serie (puede existir un combo como en SAP donde muestre la descripción y aquí plasmas su número
        facturaCLIENTE.Lines.ItemCode = "codigoProducto";
        facturaCLIENTE.Lines.Quantity = 1;
        facturaCLIENTE.Lines.UnitPrice = 5;
        facturaCLIENTE.Lines.TaxCode = "codigoImpuesto";
        //facturaCLIENTE.Lines.UserFields.Fields.Item("U_CampoUsuario").Value = "Valor";  // ejemplo para asignar algún valor a un campo de usuario a nivel linea
        facturaCLIENTE.Comments = "Concepto del documento";
        facturaCLIENTE.JournalMemo = "concepto de la póliza de la factura";      // recordar que este tiene menos capacidad
                                                                                    // encaso de que quieras aplicar un redondeo
                                                                                    //facturaCLIENTE.Rounding = BoYesNoEnum.tYES;
                                                                                    //facturaCLIENTE.RoundingDiffAmount = 0.02;

        int resultado = facturaCLIENTE.Add();
        if(resultado != 0) {
            //int errNumero = 0; string errMensaje = "";
            oEmpresa.GetLastError(out int errNumero, out string errMensaje);
            if(oEmpresa.InTransaction == true) {
                oEmpresa.EndTransaction(BoWfTransOpt.wf_RollBack);
            }        // si la transacción sigue abierta, la cierra deshaciendo todos los cambios realizados hasta el momento
            throw new Exception("Ha ocurrido el siguiente error, al intentar crear la Factura de Cliente, revise por favor ...\n\n" + errMensaje);
        }

        //string DocEntry_ultimaFacturaAdicionada = "";
        double totalFactura = 0;
        oEmpresa.GetNewObjectCode(out string DocEntry_ultimaFacturaAdicionada);
        if(facturaCLIENTE.GetByKey(Convert.ToInt32(DocEntry_ultimaFacturaAdicionada)) == true) {
            totalFactura = facturaCLIENTE.DocTotal;
            // aquí se pueden obtener más datos de la factura
        }
        else {
            // mostrar algún mensaje para informar al usuario, en supuesto de no encontrar la factura recién creada (se puede lanzar una excepción
        }
        facturaCLIENTE = null;


        SAPbobsCOM.Payments pagoRECIBIDO = oEmpresa.GetBusinessObject(BoObjectTypes.oIncomingPayments);
        pagoRECIBIDO.DocType = BoRcptTypes.rCustomer;
        pagoRECIBIDO.CardCode = "C9999";
        pagoRECIBIDO.DocDate = DateTime.Now;
        pagoRECIBIDO.DueDate = DateTime.Now;
        pagoRECIBIDO.TaxDate = DateTime.Now;
        pagoRECIBIDO.VatDate = DateTime.Now;
        pagoRECIBIDO.Remarks = "Concepto del pago";
        pagoRECIBIDO.JournalRemarks = "Concepto de la póliza del pago";
        //pagoRECIBIDO.Series = 99;     // en caso de tener varias series, espeficiar la que se desea
        // DETALE DE LAS FACTURAS, EN ESTE CASO SOLO ES LA QUE ACABAMOS DE CREAR
        pagoRECIBIDO.Invoices.InvoiceType = BoRcptInvTypes.it_Invoice;
        pagoRECIBIDO.Invoices.DocEntry = Int32.Parse(DocEntry_ultimaFacturaAdicionada);
        pagoRECIBIDO.Invoices.SumApplied = totalFactura;

        pagoRECIBIDO.CashAccount = "_SYS00000000001";
        pagoRECIBIDO.CashSum = totalFactura;

        resultado = 0;
        resultado = pagoRECIBIDO.Add();
        if(resultado != 0) {
            //int errNumero = 0; string errMensaje = "";
            oEmpresa.GetLastError(out int errNumero, out string errMensaje);
            if(oEmpresa.InTransaction == true) {
                oEmpresa.EndTransaction(BoWfTransOpt.wf_RollBack);
            }        // si la transacción sigue abierta, la cierra deshaciendo todos los cambios realizados hasta el momento
            throw new Exception("Ha ocurrido el siguiente error, al intentar crear el Pago Recibido, revise por favor ...\n\n" + errMensaje);
        }
        pagoRECIBIDO = null;

        // guarda en firma la información en la base de datos
        oEmpresa.EndTransaction(BoWfTransOpt.wf_Commit);
        MessageBox.Show("Las operaciones fueron realizadas con éxito, revise por favor ...", tituloMSGBOX, MessageBoxButtons.OK, MessageBoxIcon.Information);
        if(oEmpresa.Connected) {
            oEmpresa.Disconnect();
        }
        oEmpresa = null;
    }
    catch(Exception err) {
        // Control de errores
        MessageBox.Show(err.Message, tituloMSGBOX, MessageBoxButtons.OK, MessageBoxIcon.Warning);
        if(oEmpresa.InTransaction == true) {
            oEmpresa.EndTransaction(BoWfTransOpt.wf_RollBack);
        }        // si la transacción sigue abierta, la cierra deshaciendo todos los cambios realizados hasta el momento
        if (oEmpresa.Connected) {
            oEmpresa.Disconnect();
        }
        oEmpresa = null;
    }
}
