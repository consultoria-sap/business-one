/*
Fuente: https://foros.consultoria-sap.com/t/actualizar-dos-form-a-la-vez-c/22030
Autor: Esteban_P
*/

string Extraerdequery1;
        private void Button0_ClickBefore(object sboObject, SAPbouiCOM.SBOItemEventArg pVal, out bool BubbleEvent)
        {
            BubbleEvent = true;
            oUserTable = oCompany.UserTables.Item("SUPRASECCIONESCOL");
            if (oForm.Mode.Equals(SAPbouiCOM.BoFormMode.fm_OK_MODE) || (Grid0.Rows.SelectedRows.Count == 0))
            {


                Button0.Caption = "OK";

            }

            else
            {
                SAPbobsCOM.Recordset oRec = (SAPbobsCOM.Recordset)oCompany.GetBusinessObject(SAPbobsCOM.BoObjectTypes.BoRecordset);
                oRec.DoQuery("SELECT U_CodigoSS AS 'Código' FROM  [@SUPRASECCIONESCOL");

                oRec.MoveFirst();
                while (!oRec.EoF)
                {

                    Extraerdequery1 = oRec.Fields.Item("Código").Value.ToString();


                    oRec.MoveNext();

                }

                //if (Grid2.Rows.SelectedRows.Count > 0)   //VERIFICA QUE EXISTA UN ROW SELECCIONADO
                //{


                int nRow = Grid0.Rows.SelectedRows.Item(0, SAPbouiCOM.BoOrderType.ot_RowOrder);
                oApp.SendKeys("({TAB})");//aca aplico tabular para que tome el campo para actualizar




                //Grid2.Rows.SelectedRows.Equals(nRow);
                String sValorGrid = Convert.ToString(Grid0.DataTable.GetValue("Código", nRow));

                // Grid2.Columns.Item("CODE").Click();
                //bool num = (Grid2.Rows.SelectedRows.Count > 0);
                if (oUserTable.GetByKey(sValorGrid.ToString())) // Esto devuelve true si existe el registro
                {

                    //

                    string nom = (string)(Grid0.DataTable.GetValue("Nombre", nRow));




                    // oCompany.StartTransaction();
                    oUserTable.Code = sValorGrid;
                    oUserTable.Name = sValorGrid;
                    oUserTable.UserFields.Fields.Item("U_CodigoSS").Value = sValorGrid;
                    oUserTable.UserFields.Fields.Item("U_NombreSS").Value = nom;


                    int i = oUserTable.Update();

                    if (i != 0)
                    {
                        oApp.SetStatusBarMessage("Error" + oCompany.GetLastErrorDescription(), SAPbouiCOM.BoMessageTime.bmt_Medium, false);

                    }
                    else
                    {
                        oApp.SetStatusBarMessage("Exito en la Actualización", SAPbouiCOM.BoMessageTime.bmt_Medium, false);

                        oForm.Mode = SAPbouiCOM.BoFormMode.fm_OK_MODE;
                        oForm.DataSources.DataTables.Item(0).ExecuteQuery("SELECT U_CodigoSS AS 'Código',U_NombreSS AS 'Nombre' FROM  [@SUPRASECCIONESCOL]");
                        Grid0.DataTable = oForm.DataSources.DataTables.Item("DTSPSEC");

                        Grid0.DataTable.Rows.Add(1);
                        for (int j = 1; j <= this.Grid0.DataTable.Rows.Count; j += 1)
                        {

                            if (j < this.Grid0.DataTable.Rows.Count)
                            {

                                Grid0.Rows.SelectedRows.Add(j);
                            }

                        }

                        RowNumberGrid(Grid0);
                        BubbleEvent = false;

                    }


                }


                     //si no existe el dato, lo agregara
                else
                {


                    //   Button0.Caption = "Agregar";
                    //   oUserTable = oCompany.UserTables.Item("EDICIONESCOL");
                    int nRow2 = Grid0.Rows.SelectedRows.Item(0, SAPbouiCOM.BoOrderType.ot_RowOrder);
                    String sValorGrid2 = Convert.ToString(Grid0.DataTable.GetValue("Código", nRow2));
                    //string nNOM2 = (string)Grid2.DataTable.GetValue("NOM", nRow2);
                    // string cod2 = (string)(Grid2.DataTable.GetValue("Código", nRow2));
                    string nom2 = (string)(Grid0.DataTable.GetValue("Nombre", nRow2));


                    oUserTable.Code = sValorGrid2;
                    oUserTable.Name = sValorGrid2;
                    oUserTable.UserFields.Fields.Item("U_CodigoSS").Value = sValorGrid2;
                    oUserTable.UserFields.Fields.Item("U_NombreSS").Value = nom2;

                    int j = oUserTable.Add();

                    if (j != 0)
                    {
                        oApp.SetStatusBarMessage("Error" + oCompany.GetLastErrorDescription(), SAPbouiCOM.BoMessageTime.bmt_Medium, false);

                    }
                    else
                    {
                        oApp.SetStatusBarMessage("Exito en la inserción", SAPbouiCOM.BoMessageTime.bmt_Medium, false);

                        oForm.Mode = SAPbouiCOM.BoFormMode.fm_OK_MODE;

                        Grid0.DataTable.Rows.Add(1);

                        oForm.DataSources.DataTables.Item(0).ExecuteQuery("SELECT U_CodigoSS AS 'Código',U_NombreSS AS 'Nombre' FROM  [@SUPRASECCIONESCOL]");
                        Grid0.DataTable = oForm.DataSources.DataTables.Item("DTSPSEC");

                        for (int i = 1; i <= this.Grid0.DataTable.Rows.Count; i += 1)
                        {

                            if (i < this.Grid0.DataTable.Rows.Count)
                            {

                                Grid0.Rows.SelectedRows.Add(i);
                            }

                        }

                        RowNumberGrid(Grid0);
                        BubbleEvent = false;



                    }
                }

            }

        }
