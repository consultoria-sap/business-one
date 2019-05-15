---
layout: post
title: Script para enviar facturas desde SQL con XML PDF
url: /enviar-facturas-sql/
category: sql
published: true
date: 2019-05-15T18:25:00-03:00
---


Como primer paso debemos configurar el Database Mail.

Configurar Database Mail en SQL Server 2012

h_tps://drive.google.com/file/d/12EMlPapDBcgUiCZhF9zV16KJ8_cA25kQ/view?usp=sharing

Activarlo también con e siguiente query:

```
USE master
GO
sp_configure 'show advanced options',1
GO
RECONFIGURE WITH OVERRIDE
GO
sp_configure 'Database Mail XPs',1
GO
RECONFIGURE 
GO
```


Enseguida que configuramos el database mail google nos pide permisos para acceder a la cuenta, si tu cuenta es de google.

Después de realizar esta configuración nos vamos instalar el siguiente complemento de Crystal Reports que el archivo que exporta el reporte.

Creamos una carpeta nueva en el servidor principal donde se van a guardar todos los pdf´s o documentos que se crean, ahi mismo guardamos el siguiente archivo y cambiamos la extensión a .exe (ejecutable):
h_tps://drive.google.com/drive/folders/1IHX6bjKYYJkrqLQlbsIxhjiOYf7lLDHe
Dentro de esa misma carpeta debe estar el reporte de crystal reports que utilizan para crear su factura.
Es necesario contar con las librerías de Crystal.

32bit

h_tp://downloads.businessobjects.com/akdlm/crnetruntime/clickonce/CRRuntime_32bit_13_0_13.msi

64bit

h_tp://downloads.businessobjects.com/akdlm/crnetruntime/clickonce/CRRuntime_64bit_13_0_13.msi

En caso de que no les funcione el ejecutable anterior puede utilizar el siguiente convertidor actúa de la misma manera:
h_tps://drive.google.com/drive/folders/1IHX6bjKYYJkrqLQlbsIxhjiOYf7lLDHe

Dejo mas información de este en github.
h_tps://github.com/rainforestnet/CrystalReportsNinja

Procedimiento para enviar el correo:

```
USE [SBOSIP_PRUEBASPROCESOS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[CorreoFacturacion]
@DocEntry varchar(50)		
AS
BEGIN
Declare @NoFact as int,@NoFactDoc as int
Declare @cliente as varchar(200)
Declare @Fecha date
Declare @Total as Decimal(20,2)
Declare @contador int
Declare @TotalUSD as varchar(10)
Declare @Correos as varchar(max)
Declare @ListaD as varchar(max)
Declare @CodigoCliente as varchar(40)
DECLARE @Ruta as varchar(500)
DECLARE @RutaPDF as varchar(500)
DECLARE @RFC as varchar(100)
DECLARE @XML as varchar(1000)
DECLARE @PDF as varchar (500)
DECLARE @Cadena as varchar (500)
DECLARE @RUTA2 AS varchar(200)
DECLARE @NoFol as varchar(40)
DeCLARE @DocNum int


SET @contador =(SELECT count(T0.[DocEntry]) FROM OINV T0 WHERE
	T0.U_GeneraPDF='SI') --Busca cuantos PDF se generaron en la tabla de factura deudores principal
if @contador>0 

begin

SET @NoFact =(SELECT MAX(T0.[DocEntry]) FROM OINV T0 WHERE
	T0.U_GeneraPDF='SI' AND T0.DocNum=@DocEntry) --14353) Busca la llave primaria 
-------SET @NoFact =(SELECT MAX(T0.[DocEntry]) FROM OINV T0 WHERE
	--------T0.U_GeneraPDF='SI') --14353) Busca la llave primaria mas reciente que indique que si se debe generar el PDF
	--LISTA DE CORREOS
	----SET @ListaD =(SELECT T0.[U_Correo]
	----			FROM OINV T0 WHERE T0.[DocEntry]=@NoFact)--14353)--@NoFact)	--Busca los correos con la llave primaria encontrada en la parte de arriba

	exec [FACT_PDF] @NoFact

		

	SET @NoFactDoc =(SELECT T0.DocNum FROM OINV T0 WHERE
	T0.[DocEntry] = @NoFact)	
 SET @CodigoCliente = (SELECT T0.[CardCode] FROM OINV T0 WHERE T0.[DocEntry]=@NoFact) 
 SET @cliente = (SELECT T0.[CardName] FROM OINV T0 WHERE T0.[DocEntry]=@NoFact)   
 SET @Fecha = (SELECT T0.[DocDate] FROM OINV T0 WHERE T0.[DocEntry]=@NoFact)
--Condicion del Total, si DocTotalFC es igual a 0 slecciona a DocTotal
  SET @Total=(SELECT CASE T1.DocTotalFC WHEN 0 THEN T1.DocTotal ELSE T1.DocTotalFC END AS 'TOTAL' FROM [dbo].[OINV] T1 WHERE T1.[DocEntry]=@NoFact)
  SET @NoFol = (SELECT T0.ReportID FROM ECM2 T0 WHERE  T0.[SrcObjType]=13 AND T0.[SrcObjAbs]=@NoFact)
  
  SET @ListaD =(SELECT T0.[U_ListaDistrib] FROM CRD1 T0 WHERE T0.[CardCode] =@CodigoCliente and T0.[Address] ='CONTACTO_FACTURA')
  SET @Correos = @ListaD
DECLARE @Body NVARCHAR(MAX),
    @TableHead VARCHAR(max),
    @TableTail VARCHAR(max)

/*

SET @TableTail = '</table></body></html>' ;
SET @TableHead = '<html><head>' + '<style>'
    + 'td {border: solid black;border-width: 1px;padding-left:5px;padding-right:5px;padding-top:1px;padding-bottom:1px;font: 10px arial} '
    + '</style>' + '</head>' + '<body>' + 'REPORTE GENERADO DESDE EL SEVIDOR :  '
    + CONVERT(VARCHAR(50), GETDATE(), 106) 
    + ' <br> <table cellpadding=0 cellspacing=0 border=0>' 
   	+'<tr>'
    + '<tr> <td bgcolor=#E6E6FA><b>FACTURA</b></td>'
	+ '<td bgcolor=#E6E6FA><b>FECHA</b></td>'
	+ '<td bgcolor=#E6E6FA><b>CLIENTE</b></td>'
    + '<td bgcolor=#E6E6FA><b>TOTAL</b></td>';
SET @Body = ( SELECT    td = I.DocNum, '',
                        td = ISNULL(I.DocDate,'-'), '',
                        td = ISNULL(I.CardName,'-'), '',
                        td = @Total, ''					                  
				 FROM      OINV I
                        WHERE I.DocEntry =@NoFact
            FOR   XML RAW('tr'),
                  ELEMENTS
            )
			

SELECT  @Body = @TableHead + ISNULL(@Body, '') + @TableTail
*/
--------------------------------------------------------------
----Ruta del XML----------------
set @RUTA2= (select convert(varchar(4),year(t0.DocDate))+'-' + RIGHT('00' + Ltrim(Rtrim(month(t0.DocDate))),2) +'\'+T0.CardCode+'\IN\'
from OINV t0 WHERE t0.DocEntry=@NoFact)
SET @Ruta = (select convert(varchar(249),XmlPath)+'0010000100\'+@RUTA2 from OADM)
-----Ruta donde se guardan los PDF---------------
SET @Rutapdf = ('D:\SAP\' )
	SET @RFC =  (SELECT TaxIdNum FROM OADM)

------------------busca el nombre del XML----------------------
    SET @XML  = (@Ruta +   @NoFol + '.xml')
----------------------------------------------------------------

    SET @PDF = ('D:\SAP\'+convert(varchar(30),@NoFactDoc)+'.pdf')    
    SET @Cadena = (@XML + ';' + @PDF)

----------------------Esctructura del correo---------------
DECLARE @HTML varchar(8000)
	SET @HTML=
	N'
	Factura Fiscal Electrónica, enviada desde el Servidor...... ' + CHAR(13)+ char(13)+ 
	char (13)+ 'No de Documento Electrónico: ' +  @NoFol +	
	char (13)+ 'Folio Interno: '+ convert(varchar(20),@NoFactDoc)+ 
	
	char (13)+ 'Nombre del Cliente: ' + @cliente +--char (13)+
	--char (13)+ 'Código del Cliente: ' +  @SN +	

	--char (13)+ 'Ruta del XML: ' + + @XML
	+'     
	  '



-------------------------Informacion del correo-----------------

--SET @Cadena = ('D:\SAP\FC'+convert(varchar(30),@NoFactDoc)+'.pdf') --(@PDF)

Declare @asunto varchar(120)
SEt @asunto= ('SIP ENVIO DE FACTURA: '+ convert(varchar(10),@NoFactDoc))-----Asunto que va en el correo

	
		EXEC msdb.dbo.sp_send_dbmail
		@profile_name = 'Notificaciones_SIP1', -- nombre del Database Mail que creamos 
		--@body = @Body,
		@body = @HTML,
		--@body_format ='HTML',
		@recipients =@ListaD,--'ejemplo@hotmail.com;-- cambiar por tu correo para enviar copia
		@subject = @asunto ,
		@file_attachments=@Cadena;
     
update OINV SET U_GeneraPDF='ENV' WHERE OINV.DocEntry=@NoFact
end;


END
```


Procedimiento para generar el PDF u otro documento:

```
USE [SBOSIP_PRUEBASPROCESOS]
GO
/****** Object:  StoredProcedure [dbo].[FACT_PDF]    Script Date: 11/05/2019 11:05:13 a.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FACT_PDF]

@DocKey int = NULL--,
--@ObjectId varchar(3) = NULL
--WITH ENCRYPTION

AS
BEGIN
	SET NOCOUNT ON;
	--*****GENERADOR DE PDF*****
	--Se declaran las variables de la tabla de usuario CS_ENVIOCORREOS
	DECLARE @Factura varchar(10),
		@FacturaR varchar(10),
		@FacturaA varchar(10),
		@NotaC varchar(10),
		@NotaD varchar(10),
		@RutaXML varchar(355),
		@RutaPDF varchar(355),
		@CrystalCS varchar(10),
		@Servidor varchar(100),
		@Base varchar(100),
		@UserSQL varchar(100),
		@PassSQL varchar(100)

		
	--Se hace una consulta a la tabla CS_ENVIOCORREOS
	--SELECT TOP(1) 
	--	@Factura = '',--ISNULL(U_Factura,''),
	--	@FacturaR = '',--ISNULL(U_FacturaR,''),
	--	@FacturaA = '',--ISNULL(U_FacturaA,''),
	--	@NotaC = '',--ISNULL(U_NotaC,''),
	--	@NotaD = '',--ISNULL(U_NotaD,''),
	--	@RutaXML = '',--ISNULL(U_RutaXML,''),
		SET @RutaPDF = 'D:\SAP\'--,--ISNULL(U_RutaPDF,''),---esta ruta pueden cambiarla si quieren a C: o F: o E:
		SET @CrystalCS ='SI'--,--ISNULL(U_CrystalCS,''),
		SET @Servidor = 'nombre del servidor'--,--ISNULL(U_Servidor,''),
		SET @Base = 'nombre base de datos'--,--ISNULL(U_Base,''),
		SET @UserSQL = 'usuario de sql'--,--ISNULL(U_UserSQL,''),
		SET @PassSQL = 'password de sql'--ISNULL(U_PassSQL,'')
	--FROM dbo.[@CS_FACTURACION]

	--Imprime los resultados obtenidos
	----PRINT 'Facturas: '+@Factura
	

	--Se declaran una tabla con todas las variables a usar
	DECLARE @GENERADORPDF TABLE
	(
		ID int IDENTITY(1,1) PRIMARY KEY,
		DocEntry varchar(100),
		ObjType varchar(100),
		Tipo varchar(50),
		--EDocNum varchar(100),
		DocType varchar(10)
	)

	--Se insertaran los datos en la tabla temporal dependiendo del resultado de los queries
	INSERT INTO @GENERADORPDF (DocEntry, ObjType, Tipo, DocType)

	--Se hace un select al primer registro que encuentre
	SELECT TOP(1) 
		T0.DocEntry,
		T0.ObjType,
		'Factura',
		
		T0.DocType
		--(SELECT @@SERVERNAME),
		--(SELECT DB_NAME()),
		--(SELECT SYSTEM_USER)
	FROM dbo.OINV T0 INNER JOIN ECM2 T1 ON T1.[SrcObjAbs] = t0.DocEntry  
	WHERE T0.U_PDFGen = 'NO' AND T0.DocEntry = @DocKey
	--ISNULL(@DocKey, T0.DocEntry) 
	AND T0.ObjType = 13 AND T1.[SrcObjType] =13 

	select * from @GENERADORPDF
	--Se declaran las variables a las cuales se les asignaran los resultados de la tabla
	DECLARE	
		@Ruta varchar(100),
		@Programa varchar(100),
		@Formato varchar(100),
		@Contador int,
		@Vacio int,
		@Error varchar(1000),
		@EDocNum varchar(100),
		@Tipo varchar(50),
		@DocEntry varchar(100),
		@ObjType varchar(100),
		@DocType varchar(10),
		@Archivo varchar(100),
		@Parametro1 varchar(100),
		@Parametro2 varchar(100),
		@Final varchar(1000),
		@Resultado int,
		@CS_PdfGenerado varchar(100),
		@CS_PdfGenError varchar(100),
		@dOCnUM varchar(100)

	
	SET @EDocNum= (sELECT t1.ReportID 
	
	FROM dbo.OINV T0 INNER JOIN ECM2 T1 ON T1.[SrcObjAbs] = t0.DocEntry  
	WHERE T0.U_PDFGen = 'NO' AND T0.DocEntry = @DocKey
	--ISNULL(@DocKey, T0.DocEntry) 
	AND T0.ObjType = 13 AND T1.[SrcObjType] =13 )



	--Parametros necesarios para generar el PDF
	SET @Ruta = 'D:\SAP\' ---direccion donde se guarda el archivo crexport.exe y los pdf
	SET @Programa = 'crexport.exe'
	SET @Formato = 'pdf'

	--Se inicializa el contador en 1
	SET @Contador = 1

	--Se cuentan cuantos documentos estan pendientes por generar PDF
	SET @Vacio = (SELECT COUNT(*) FROM @GENERADORPDF)

	--Se muestran todos los documentos pendientes por generar PDF
	PRINT 'Numero de Documentos a generar PDF: '+CONVERT(varchar(10), @Vacio)

	WHILE @Contador <= @Vacio
	BEGIN
		--Se inicializa el mensaje de error en vacio
		SET @Error = ''

		PRINT '****Entro al ciclo '+CONVERT(varchar(10), @Contador)+' ****'

		--Se extraen de uno por uno los datos de la tabla
		SELECT 
			@Tipo = Tipo,
			@DocEntry = DocEntry,
			@ObjType = ObjType,
			@DocType = DocType
		FROM @GENERADORPDF
		WHERE ID = @Contador
			
		--Muestra el documento a generar
		PRINT char(9)+'EDocNum: '+@EDocNum
		PRINT char(9)+'Tipo: '+@Tipo
		PRINT char(9)+'DocEntry: '+CONVERT(varchar(10), @DocEntry)
		PRINT char(9)+'ObjType: '+@ObjType
		PRINT char(9)+'DocType: '+@DocType
		PRINT char(9)+'Ruta de los XML: '+@RutaXML
		PRINT char(9)+'Ruta de los PDF: '+@RutaPDF
		PRINT char(9)+'Formato CS: '+@CrystalCS
		PRINT char(9)+'Servidor: '+@Servidor
		PRINT char(9)+'Base de datos: '+@Base
		PRINT char(9)+'Usuario de SQL: '+@UserSQL
		PRINT char(9)+'Password: '+@PassSQL

		IF @CrystalCS = 'SI'
		BEGIN
			SET @Archivo = @Base+'.rpt'
			SET @Parametro1 = ' -a ObjectId@:'+@ObjType
			SET @Parametro2 = ' -a DocKey@:'+@DocEntry
		END
		ELSE
		BEGIN
			SET @Archivo = @Base+'-'+@Tipo+'-'+@DocType+'.rpt'
			IF @CrystalCS = 'NO'
			BEGIN
				SET @Parametro1 = ' -a ObjectId@:'+@ObjType
				SET @Parametro2 = ' -a DocKey@:'+@DocEntry
			END
			ELSE
			BEGIN
				SET @Parametro1 = ' '
				SET @Parametro2 = '-a DocKey@:'+@DocEntry
			END
		END
		DECLARE @CMD VARCHAR(1000)
		PRINT 'Parametro1: '+@Parametro1
		PRINT 'Parametro2: '+@Parametro2
			SET @dOCnUM = (Select DocNum from OINV WHERE DocEntry=@DocKey )
		--Busca el archivo crexport.exe
		SET @Final = @Ruta+@Programa
		EXEC master.dbo.xp_fileexist @Final, @Resultado OUTPUT
		IF @Resultado = 1
		BEGIN
			PRINT 'EXITO - Si se encontro el archivo para crear PDFs'

			--Busca el reporte de Crystal
			SET @Final = @Ruta+@Archivo
			EXEC master.dbo.xp_fileexist @Final, @Resultado OUTPUT
			IF @Resultado = 1
			BEGIN
				PRINT 'EXITO - Si se encontro el reporte de Crystal'

				--Busca el XML de la factura
				--SET @Final = @RutaXML+'\'+@EDocNum+'.xml'
				--EXEC master.dbo.xp_fileexist @Final, @Resultado OUTPUT
				--IF @Resultado = 1
				--BEGIN
				--	PRINT 'EXITO - Si se encontro el XML'

					IF @CrystalCS = 'SI'
					BEGIN
						SET @Resultado = 0
					END
				--	ELSE
				--	BEGIN
				--		--Copia el XML en la carpeta de CompuSoluciones
				--		SET @Final = 'copy /Y "'+@RutaXML+'\'+@EDocNum+'.xml" "C:\CompuSoluciones\XML.xml"'
				--		EXEC @Resultado = xp_cmdshell @Final, NO_OUTPUT
				--	END
					IF @Resultado = 0
					BEGIN
						--PRINT 'EXITO - Si se copio el XML'

						--Se juntan todos los parametros para juntar un solo parametro para CMD
						SET @Final = 'D:\SAP\crexport.exe -F D:\SAP\nombredetureportecrystal.rpt -O D:\SAP\'+@dOCnUM+'.pdf -E pdf -S nombreservidor -D basededatos -U usuariosql -P passsql ' +@Parametro2
						SET @CMD=    'D:\SAP\crexport.exe -F D:\SAP\nombredetureportecrystal.rpt -O D:\SAP\84.pdf -E pdf -S nombreservidor -D basededatos -U usuariosql -P passsql -a DocKey@:60391'
						PRINT @Final
						update OINV SET U_PDFGen='SI' WHERE OINV.DocEntry=@DocKey
						--Ejecuta el generador de PDFs desde CMD
						--EXEC master.dbo.xp_cmdshell @Final, NO_OUTPUT
						EXEC xp_cmdshell @Final
						--SET @Final = @RutaPDF+'\'+@EDocNum+'.pdf'
						--EXEC master.dbo.xp_fileexist @Final, @Resultado OUTPUT
						--update OINV SET U_GeneraPDF='SI' WHERE OINV.DocEntry=@DocKey
						IF @Resultado = 1
						BEGIN
							PRINT 'EXITO - Si se genero el PDF de la '+@Tipo+' '+CONVERT(varchar(10), @DocEntry)
							IF (@Tipo = 'Salida')
							BEGIN
								SET @CS_PdfGenerado = 'SI_NC'
								SET @CS_PdfGenError = ''
							END
							ELSE
							BEGIN
								SET @CS_PdfGenerado = 'SI'
								SET @CS_PdfGenError = ''
							END
							update OINV SET U_GeneraPDF='SI' WHERE OINV.DocEntry=@DocKey
							
						END
						ELSE
						BEGIN
							PRINT 'ERROR - No se genero el PDF en la ruta "'+@Final+'"'
							SET @CS_PdfGenerado = 'ERROR'
							SET @CS_PdfGenError = 'No se genero el PDF'
						END
					END
					ELSE
					BEGIN
						PRINT 'ERROR - No se copio el XML - '+@Final
						SET @CS_PdfGenerado = 'ERROR'
						SET @CS_PdfGenError = 'No se copio el XML'
					END
				END
				ELSE
				BEGIN
					PRINT 'ERROR - No se encontro el archivo XML en la ruta "'+@Final+'"'
					SET @CS_PdfGenerado = 'ERROR'
					SET @CS_PdfGenError = 'No se encontro el XML'
				END
			END
			ELSE
			BEGIN
				PRINT 'ERROR - No se encontro el reporte de Crystal en la ruta "'+@Final+'"'
				SET @CS_PdfGenerado = 'ERROR'
				SET @CS_PdfGenError = 'No se encontro el reporte de Crystal'
			END
		
		
		

		--Imprime salto de linea
		PRINT CHAR(13)
	SET @Contador = @Contador + 1
	END

END
```


Por ultimo debemos modificar el procedimiento de SBO_SP_PosTransactionNotice agregando o siguiente: 

```
IF @transaction_type IN ('A','U')  AND @object_type = '13'
BEGIN 
   Begin 
       if exists(select T0.U_GeneraPDF from OINV T0 where T0.U_GeneraPDF = 'SI' )	   
       Begin 
	   exec [CorreoFacturacion] 
         set @error=101
         set @error_message= 'Mensaje  enviado'
       END   
    END
END
```

Y en SBO_SP_TransactionNotification agregue: 
```
IF @transaction_type IN ('A','U')  AND @object_type = '13'
BEGIN 
declare @correolleno as nvarchar (20)
declare @correovacio as nvarchar(max)
Set @correovacio=(select isnull(T0.U_Correo,'0') from OINV T0 where docentry=@list_of_cols_val_tab_del ) 
   Begin 
       if (@correovacio=NULL or @correovacio=' ' or @correovacio='0')	   
       Begin  
         set @error=101
         set @error_message= 'Mensaje no enviado, introducir correos'
       END   
    END
END
```

Esta ultima parte la pueden manejar como gusten enviar los correos.

Si tiene alguna duda puedo apoyarlos, también si pase por alto algún detalle.

Le comparto que si me funciona en la base de datos de prueba
![image|654x500](https://foros.consultoria-sap.com/uploads/default/optimized/3X/f/2/f23042e6d60949161f9f898d7d4c9a436216b59d_2_654x500.png)  

Asi es como esta actualmente el procedimiento
![image|647x500](https://foros.consultoria-sap.com/uploads/default/optimized/3X/e/5/e58a6003f5c4653c449080bfdf4ed4492c17ba40_2_647x500.png)
