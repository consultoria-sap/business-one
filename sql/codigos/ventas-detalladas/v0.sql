-- Fuente: https://foros.consultoria-sap.com/t/33555
-- El query obtiene todas las facturas, el vendedor que la hizo, el cliente al que va dirigida la factura, 
-- así como los articulos, su fabricante, importe… etc.

DECLARE   @FechaInicio varchar(50)   
DECLARE   @FechaFin varchar (50)
DECLARE   @CodeArticulo varchar(50)
DECLARE   @CodeSN varchar(100)

SET @FechaInicio='[%0]'
SET @FechaFin='[%1]'
SET @CodeArticulo=select '[%2]'
SET @CodeSN=select '[%3]' 
 
IF @FechaInicio IS NOT NULL AND @FechaFin IS NOT NULL AND @CodeArticulo IS NOT NULL AND @CodeSN IS NOT NULL
SELECT  T1.SlpCode 'Código Vendedor', T1.SlpName 'Nombre Vendedor', T0.CardCode 'Código Cliente', T0.CardName 'Nombre del Cliente', 
CASE T0.ObjType 
WHEN 13 THEN 'FACTURA'
END 'Tipo Documento', 
T0.DocNum 'Folio', ' ' 'Documento al que aplica', FORMAT(T0.DocDate, 'yyyy-MM-dd') 'Fecha  Factura',  T2.ItemCode 'Código Artículo', T2.Dscription 'Descripción del Artículo', 
T4.ItmsGrpNam 'Grupo del artículo', T5.FirmName 'Nombre del fabricante', 
CASE T0.CANCELED 
WHEN 'C' THEN  '-' + CONVERT(VARCHAR(20), T2.Quantity)
WHEN 'N' THEN T2.Quantity
WHEN 'Y' THEN T2.Quantity
END  'Cantidad', 
CASE T0.CANCELED
WHEN 'C' THEN '-' + CONVERT(VARCHAR(20), T2.LineTotal)
WHEN 'N' THEN T2.LineTotal
WHEN 'Y' THEN T2.LineTotal
END  'Total Partida',
CASE T0.CANCELED
WHEN 'C' THEN '-' + CONVERT(VARCHAR(20),  (T2.StockPrice * T2.Quantity))
WHEN 'N' THEN (T2.StockPrice * T2.Quantity)
WHEN 'Y' THEN (T2.StockPrice * T2.Quantity)
END 'Costo por partida'
FROM OINV T0 
INNER JOIN OSLP T1 ON T0.SlpCode=T1.SlpCode
INNER JOIN INV1 T2 ON T0.DocEntry=T2.DocEntry
INNER JOIN OITM T3 ON T2.ItemCode=T3.ItemCode
INNER JOIN OITB T4 ON T3.ItmsGrpCod=T4.ItmsGrpCod
INNER JOIN OMRC T5 ON T5.FirmCode=T3.FirmCode
WHERE T0.DocDate BETWEEN @FechaInicio AND @FechaFin AND T0.CardName=@CodeSN AND T2.ItemCode=@CodeArticulo
UNION ALL
SELECT  T1.SlpCode 'Código Vendedor', T1.SlpName 'Nombre Vendedor', T0.CardCode 'Código Cliente', T0.CardName 'Nombre del Cliente', 
CASE T0.ObjType 
WHEN 14 THEN 'NC'
END 'Tipo Documento',  
T0.DocNum 'Folio',  
CASE T2.BaseType
WHEN 13 THEN 'F ' + T2.BaseRef
WHEN 14 THEN 'NC ' + T2.BaseRef
END  'Documento al que aplica',
 FORMAT(T0.DocDate, 'yyyy-MM-dd') 'Fecha  Factura', T2.ItemCode 'Código Artículo', T2.Dscription 'Descripción del Artículo', 
T4.ItmsGrpNam 'Grupo del artículo', T5.FirmName 'Nombre del fabricante',
CASE T2.BaseType
WHEN 14 THEN  T2.Quantity
ELSE '-' + CONVERT (VARCHAR(20), T2.Quantity)
END  'Cantidad', 
CASE T2.BaseType 
WHEN 14 THEN T2.LineTotal
ELSE '-' + CONVERT(VARCHAR(20), T2.LineTotal) 
END 'Total Partida',
 '-' + CONVERT(VARCHAR(20), (T2.StockPrice * T2.Quantity)) 'Costo por partida'
FROM ORIN T0 
INNER JOIN OSLP T1 ON T0.SlpCode=T1.SlpCode
INNER JOIN RIN1 T2 ON T0.DocEntry=T2.DocEntry
INNER JOIN OITM T3 ON T2.ItemCode=T3.ItemCode
INNER JOIN OITB T4 ON T3.ItmsGrpCod=T4.ItmsGrpCod
INNER JOIN OMRC T5 ON T5.FirmCode=T3.FirmCode
WHERE T0.DocDate BETWEEN @FechaInicio AND @FechaFin AND T0.CardName=@CodeSN AND T2.ItemCode=@CodeArticulo
ELSE

IF @FechaInicio IS NULL AND @FechaFin IS NULL AND @CodeArticulo IS NOT NULL AND @CodeSN IS NOT NULL
SELECT  T1.SlpCode 'Código Vendedor', T1.SlpName 'Nombre Vendedor', T0.CardCode 'Código Cliente', T0.CardName 'Nombre del Cliente', 
CASE T0.ObjType 
WHEN 13 THEN 'FACTURA'
END 'Tipo Documento', 
T0.DocNum 'Folio', ' ' 'Documento al que aplica', FORMAT(T0.DocDate, 'yyyy-MM-dd') 'Fecha  Factura',  T2.ItemCode 'Código Artículo', T2.Dscription 'Descripción del Artículo', 
T4.ItmsGrpNam 'Grupo del artículo', T5.FirmName 'Nombre del fabricante', 
CASE T0.CANCELED 
WHEN 'C' THEN  '-' + CONVERT(VARCHAR(20), T2.Quantity)
WHEN 'N' THEN T2.Quantity
WHEN 'Y' THEN T2.Quantity
END  'Cantidad', 
CASE T0.CANCELED
WHEN 'C' THEN '-' + CONVERT(VARCHAR(20), T2.LineTotal)
WHEN 'N' THEN T2.LineTotal
WHEN 'Y' THEN T2.LineTotal
END  'Total Partida',
CASE T0.CANCELED
WHEN 'C' THEN '-' + CONVERT(VARCHAR(20),  (T2.StockPrice * T2.Quantity))
WHEN 'N' THEN (T2.StockPrice * T2.Quantity)
WHEN 'Y' THEN (T2.StockPrice * T2.Quantity)
END 'Costo por partida'
FROM OINV T0 
INNER JOIN OSLP T1 ON T0.SlpCode=T1.SlpCode
INNER JOIN INV1 T2 ON T0.DocEntry=T2.DocEntry
INNER JOIN OITM T3 ON T2.ItemCode=T3.ItemCode
INNER JOIN OITB T4 ON T3.ItmsGrpCod=T4.ItmsGrpCod
INNER JOIN OMRC T5 ON T5.FirmCode=T3.FirmCode
WHERE T0.DocDate >= '2010-01-01' AND T0.DocDate <= GETDATE()  AND T0.CardName=@CodeSN AND T2.ItemCode=@CodeArticulo
UNION ALL
SELECT  T1.SlpCode 'Código Vendedor', T1.SlpName 'Nombre Vendedor', T0.CardCode 'Código Cliente', T0.CardName 'Nombre del Cliente', 
CASE T0.ObjType 
WHEN 14 THEN 'NC'
END 'Tipo Documento',  
T0.DocNum 'Folio',  
CASE T2.BaseType
WHEN 13 THEN 'F ' + T2.BaseRef
WHEN 14 THEN 'NC ' + T2.BaseRef
END  'Documento al que aplica',
 FORMAT(T0.DocDate, 'yyyy-MM-dd') 'Fecha  Factura', T2.ItemCode 'Código Artículo', T2.Dscription 'Descripción del Artículo', 
T4.ItmsGrpNam 'Grupo del artículo', T5.FirmName 'Nombre del fabricante',
CASE T2.BaseType
WHEN 14 THEN  T2.Quantity
ELSE '-' + CONVERT (VARCHAR(20), T2.Quantity)
END  'Cantidad', 
CASE T2.BaseType 
WHEN 14 THEN T2.LineTotal
ELSE '-' + CONVERT(VARCHAR(20), T2.LineTotal) 
END 'Total Partida',
 '-' + CONVERT(VARCHAR(20), (T2.StockPrice * T2.Quantity)) 'Costo por partida'
FROM ORIN T0 
INNER JOIN OSLP T1 ON T0.SlpCode=T1.SlpCode
INNER JOIN RIN1 T2 ON T0.DocEntry=T2.DocEntry
INNER JOIN OITM T3 ON T2.ItemCode=T3.ItemCode
INNER JOIN OITB T4 ON T3.ItmsGrpCod=T4.ItmsGrpCod
INNER JOIN OMRC T5 ON T5.FirmCode=T3.FirmCode
WHERE T0.DocDate >= '2010-01-01' AND T0.DocDate <= GETDATE()  AND T0.CardName=@CodeSN AND T2.ItemCode=@CodeArticulo
ELSE

IF @FechaInicio IS NULL AND @FechaFin IS NULL AND  @CodeArticulo IS NOT NULL  AND @CodeSN  IS NULL 
SELECT  T1.SlpCode 'Código Vendedor', T1.SlpName 'Nombre Vendedor', T0.CardCode 'Código Cliente', T0.CardName 'Nombre del Cliente', 
CASE T0.ObjType 
WHEN 13 THEN 'FACTURA'
END 'Tipo Documento', 
T0.DocNum 'Folio', ' ' 'Documento al que aplica', FORMAT(T0.DocDate, 'yyyy-MM-dd') 'Fecha  Factura',  T2.ItemCode 'Código Artículo', T2.Dscription 'Descripción del Artículo', 
T4.ItmsGrpNam 'Grupo del artículo', T5.FirmName 'Nombre del fabricante', 
CASE T0.CANCELED 
WHEN 'C' THEN  '-' + CONVERT(VARCHAR(20), T2.Quantity)
WHEN 'N' THEN T2.Quantity
WHEN 'Y' THEN T2.Quantity
END  'Cantidad', 
CASE T0.CANCELED
WHEN 'C' THEN '-' + CONVERT(VARCHAR(20), T2.LineTotal)
WHEN 'N' THEN T2.LineTotal
WHEN 'Y' THEN T2.LineTotal
END  'Total Partida',
CASE T0.CANCELED
WHEN 'C' THEN '-' + CONVERT(VARCHAR(20),  (T2.StockPrice * T2.Quantity))
WHEN 'N' THEN (T2.StockPrice * T2.Quantity)
WHEN 'Y' THEN (T2.StockPrice * T2.Quantity)
END 'Costo por partida'
FROM OINV T0 
INNER JOIN OSLP T1 ON T0.SlpCode=T1.SlpCode
INNER JOIN INV1 T2 ON T0.DocEntry=T2.DocEntry
INNER JOIN OITM T3 ON T2.ItemCode=T3.ItemCode
INNER JOIN OITB T4 ON T3.ItmsGrpCod=T4.ItmsGrpCod
INNER JOIN OMRC T5 ON T5.FirmCode=T3.FirmCode
WHERE T0.DocDate >= '2010-01-01' AND T0.DocDate <= GETDATE()  AND T2.ItemCode=@CodeArticulo
UNION ALL
SELECT  T1.SlpCode 'Código Vendedor', T1.SlpName 'Nombre Vendedor', T0.CardCode 'Código Cliente', T0.CardName 'Nombre del Cliente', 
CASE T0.ObjType 
WHEN 14 THEN 'NC'
END 'Tipo Documento',  
T0.DocNum 'Folio',  
CASE T2.BaseType
WHEN 13 THEN 'F ' + T2.BaseRef
WHEN 14 THEN 'NC ' + T2.BaseRef
END  'Documento al que aplica',
 FORMAT(T0.DocDate, 'yyyy-MM-dd') 'Fecha  Factura', T2.ItemCode 'Código Artículo', T2.Dscription 'Descripción del Artículo', 
T4.ItmsGrpNam 'Grupo del artículo', T5.FirmName 'Nombre del fabricante',
CASE T2.BaseType
WHEN 14 THEN  T2.Quantity
ELSE '-' + CONVERT (VARCHAR(20), T2.Quantity)
END  'Cantidad', 
CASE T2.BaseType 
WHEN 14 THEN T2.LineTotal
ELSE '-' + CONVERT(VARCHAR(20), T2.LineTotal) 
END 'Total Partida',
 '-' + CONVERT(VARCHAR(20), (T2.StockPrice * T2.Quantity)) 'Costo por partida'
FROM ORIN T0 
INNER JOIN OSLP T1 ON T0.SlpCode=T1.SlpCode
INNER JOIN RIN1 T2 ON T0.DocEntry=T2.DocEntry
INNER JOIN OITM T3 ON T2.ItemCode=T3.ItemCode
INNER JOIN OITB T4 ON T3.ItmsGrpCod=T4.ItmsGrpCod
INNER JOIN OMRC T5 ON T5.FirmCode=T3.FirmCode
WHERE T0.DocDate >= '2010-01-01' AND T0.DocDate <= GETDATE()  AND T2.ItemCode=@CodeArticulo
ELSE

IF @FechaInicio IS NULL AND @FechaFin IS NULL AND   @CodeSN IS NOT NULL  AND @CodeArticulo  IS NULL 
SELECT  T1.SlpCode 'Código Vendedor', T1.SlpName 'Nombre Vendedor', T0.CardCode 'Código Cliente', T0.CardName 'Nombre del Cliente', 
CASE T0.ObjType 
WHEN 13 THEN 'FACTURA'
END 'Tipo Documento', 
T0.DocNum 'Folio', ' ' 'Documento al que aplica', FORMAT(T0.DocDate, 'yyyy-MM-dd') 'Fecha  Factura',  T2.ItemCode 'Código Artículo', T2.Dscription 'Descripción del Artículo', 
T4.ItmsGrpNam 'Grupo del artículo', T5.FirmName 'Nombre del fabricante', 
CASE T0.CANCELED 
WHEN 'C' THEN  '-' + CONVERT(VARCHAR(20), T2.Quantity)
WHEN 'N' THEN T2.Quantity
WHEN 'Y' THEN T2.Quantity
END  'Cantidad', 
CASE T0.CANCELED
WHEN 'C' THEN '-' + CONVERT(VARCHAR(20), T2.LineTotal)
WHEN 'N' THEN T2.LineTotal
WHEN 'Y' THEN T2.LineTotal
END  'Total Partida',
CASE T0.CANCELED
WHEN 'C' THEN '-' + CONVERT(VARCHAR(20),  (T2.StockPrice * T2.Quantity))
WHEN 'N' THEN (T2.StockPrice * T2.Quantity)
WHEN 'Y' THEN (T2.StockPrice * T2.Quantity)
END 'Costo por partida'
FROM OINV T0 
INNER JOIN OSLP T1 ON T0.SlpCode=T1.SlpCode
INNER JOIN INV1 T2 ON T0.DocEntry=T2.DocEntry
INNER JOIN OITM T3 ON T2.ItemCode=T3.ItemCode
INNER JOIN OITB T4 ON T3.ItmsGrpCod=T4.ItmsGrpCod
INNER JOIN OMRC T5 ON T5.FirmCode=T3.FirmCode
WHERE T0.DocDate >= '2010-01-01' AND T0.DocDate <= GETDATE()  AND T0.CardName=@CodeSN
UNION ALL
SELECT  T1.SlpCode 'Código Vendedor', T1.SlpName 'Nombre Vendedor', T0.CardCode 'Código Cliente', T0.CardName 'Nombre del Cliente', 
CASE T0.ObjType 
WHEN 14 THEN 'NC'
END 'Tipo Documento',  
T0.DocNum 'Folio',  
CASE T2.BaseType
WHEN 13 THEN 'F ' + T2.BaseRef
WHEN 14 THEN 'NC ' + T2.BaseRef
END  'Documento al que aplica',
 FORMAT(T0.DocDate, 'yyyy-MM-dd') 'Fecha  Factura', T2.ItemCode 'Código Artículo', T2.Dscription 'Descripción del Artículo', 
T4.ItmsGrpNam 'Grupo del artículo', T5.FirmName 'Nombre del fabricante',
CASE T2.BaseType
WHEN 14 THEN  T2.Quantity
ELSE '-' + CONVERT (VARCHAR(20), T2.Quantity)
END  'Cantidad', 
CASE T2.BaseType 
WHEN 14 THEN T2.LineTotal
ELSE '-' + CONVERT(VARCHAR(20), T2.LineTotal) 
END 'Total Partida',
 '-' + CONVERT(VARCHAR(20), (T2.StockPrice * T2.Quantity)) 'Costo por partida'
FROM ORIN T0 
INNER JOIN OSLP T1 ON T0.SlpCode=T1.SlpCode
INNER JOIN RIN1 T2 ON T0.DocEntry=T2.DocEntry
INNER JOIN OITM T3 ON T2.ItemCode=T3.ItemCode
INNER JOIN OITB T4 ON T3.ItmsGrpCod=T4.ItmsGrpCod
INNER JOIN OMRC T5 ON T5.FirmCode=T3.FirmCode
WHERE T0.DocDate >= '2010-01-01' AND T0.DocDate <= GETDATE()  AND T0.CardName=@CodeSN
ELSE

IF @FechaInicio IS NOT NULL AND @FechaFin IS NOT NULL AND   @CodeSN IS NULL  AND @CodeArticulo  IS NULL 
SELECT  T1.SlpCode 'Código Vendedor', T1.SlpName 'Nombre Vendedor', T0.CardCode 'Código Cliente', T0.CardName 'Nombre del Cliente', 
CASE T0.ObjType 
WHEN 13 THEN 'FACTURA'
END 'Tipo Documento', 
T0.DocNum 'Folio', ' ' 'Documento al que aplica', FORMAT(T0.DocDate, 'yyyy-MM-dd') 'Fecha  Factura',  T2.ItemCode 'Código Artículo', T2.Dscription 'Descripción del Artículo', 
T4.ItmsGrpNam 'Grupo del artículo', T5.FirmName 'Nombre del fabricante', 
CASE T0.CANCELED 
WHEN 'C' THEN  '-' + CONVERT(VARCHAR(20), T2.Quantity)
WHEN 'N' THEN T2.Quantity
WHEN 'Y' THEN T2.Quantity
END  'Cantidad', 
CASE T0.CANCELED
WHEN 'C' THEN '-' + CONVERT(VARCHAR(20), T2.LineTotal)
WHEN 'N' THEN T2.LineTotal
WHEN 'Y' THEN T2.LineTotal
END  'Total Partida',
CASE T0.CANCELED
WHEN 'C' THEN '-' + CONVERT(VARCHAR(20),  (T2.StockPrice * T2.Quantity))
WHEN 'N' THEN (T2.StockPrice * T2.Quantity)
WHEN 'Y' THEN (T2.StockPrice * T2.Quantity)
END 'Costo por partida'
FROM OINV T0 
INNER JOIN OSLP T1 ON T0.SlpCode=T1.SlpCode
INNER JOIN INV1 T2 ON T0.DocEntry=T2.DocEntry
INNER JOIN OITM T3 ON T2.ItemCode=T3.ItemCode
INNER JOIN OITB T4 ON T3.ItmsGrpCod=T4.ItmsGrpCod
INNER JOIN OMRC T5 ON T5.FirmCode=T3.FirmCode
WHERE T0.DocDate >= @FechaInicio AND T0.DocDate <= @FechaFin
UNION ALL
SELECT  T1.SlpCode 'Código Vendedor', T1.SlpName 'Nombre Vendedor', T0.CardCode 'Código Cliente', T0.CardName 'Nombre del Cliente', 
CASE T0.ObjType 
WHEN 14 THEN 'NC'
END 'Tipo Documento',  
T0.DocNum 'Folio',  
CASE T2.BaseType
WHEN 13 THEN 'F ' + T2.BaseRef
WHEN 14 THEN 'NC ' + T2.BaseRef
END  'Documento al que aplica',
 FORMAT(T0.DocDate, 'yyyy-MM-dd') 'Fecha  Factura', T2.ItemCode 'Código Artículo', T2.Dscription 'Descripción del Artículo', 
T4.ItmsGrpNam 'Grupo del artículo', T5.FirmName 'Nombre del fabricante',
CASE T2.BaseType
WHEN 14 THEN  T2.Quantity
ELSE '-' + CONVERT (VARCHAR(20), T2.Quantity)
END  'Cantidad', 
CASE T2.BaseType 
WHEN 14 THEN T2.LineTotal
ELSE '-' + CONVERT(VARCHAR(20), T2.LineTotal) 
END 'Total Partida',
 '-' + CONVERT(VARCHAR(20), (T2.StockPrice * T2.Quantity)) 'Costo por partida'
FROM ORIN T0 
INNER JOIN OSLP T1 ON T0.SlpCode=T1.SlpCode
INNER JOIN RIN1 T2 ON T0.DocEntry=T2.DocEntry
INNER JOIN OITM T3 ON T2.ItemCode=T3.ItemCode
INNER JOIN OITB T4 ON T3.ItmsGrpCod=T4.ItmsGrpCod
INNER JOIN OMRC T5 ON T5.FirmCode=T3.FirmCode
WHERE T0.DocDate >= @FechaInicio AND T0.DocDate <= @FechaFin 
ELSE

IF @FechaInicio IS NOT NULL AND @FechaFin IS NOT NULL AND   @CodeSN IS NOT NULL  AND @CodeArticulo  IS NULL 
SELECT  T1.SlpCode 'Código Vendedor', T1.SlpName 'Nombre Vendedor', T0.CardCode 'Código Cliente', T0.CardName 'Nombre del Cliente', 
CASE T0.ObjType 
WHEN 13 THEN 'FACTURA'
END 'Tipo Documento', 
T0.DocNum 'Folio', ' ' 'Documento al que aplica', FORMAT(T0.DocDate, 'yyyy-MM-dd') 'Fecha  Factura',  T2.ItemCode 'Código Artículo', T2.Dscription 'Descripción del Artículo', 
T4.ItmsGrpNam 'Grupo del artículo', T5.FirmName 'Nombre del fabricante', 
CASE T0.CANCELED 
WHEN 'C' THEN  '-' + CONVERT(VARCHAR(20), T2.Quantity)
WHEN 'N' THEN T2.Quantity
WHEN 'Y' THEN T2.Quantity
END  'Cantidad', 
CASE T0.CANCELED
WHEN 'C' THEN '-' + CONVERT(VARCHAR(20), T2.LineTotal)
WHEN 'N' THEN T2.LineTotal
WHEN 'Y' THEN T2.LineTotal
END  'Total Partida',
CASE T0.CANCELED
WHEN 'C' THEN '-' + CONVERT(VARCHAR(20),  (T2.StockPrice * T2.Quantity))
WHEN 'N' THEN (T2.StockPrice * T2.Quantity)
WHEN 'Y' THEN (T2.StockPrice * T2.Quantity)
END 'Costo por partida'
FROM OINV T0 
INNER JOIN OSLP T1 ON T0.SlpCode=T1.SlpCode
INNER JOIN INV1 T2 ON T0.DocEntry=T2.DocEntry
INNER JOIN OITM T3 ON T2.ItemCode=T3.ItemCode
INNER JOIN OITB T4 ON T3.ItmsGrpCod=T4.ItmsGrpCod
INNER JOIN OMRC T5 ON T5.FirmCode=T3.FirmCode
WHERE T0.DocDate >= @FechaInicio AND T0.DocDate <= @FechaFin  AND T0.CardName=@CodeSN
UNION ALL
SELECT  T1.SlpCode 'Código Vendedor', T1.SlpName 'Nombre Vendedor', T0.CardCode 'Código Cliente', T0.CardName 'Nombre del Cliente', 
CASE T0.ObjType 
WHEN 14 THEN 'NC'
END 'Tipo Documento',  
T0.DocNum 'Folio',  
CASE T2.BaseType
WHEN 13 THEN 'F ' + T2.BaseRef
WHEN 14 THEN 'NC ' + T2.BaseRef
END  'Documento al que aplica',
 FORMAT(T0.DocDate, 'yyyy-MM-dd') 'Fecha  Factura', T2.ItemCode 'Código Artículo', T2.Dscription 'Descripción del Artículo', 
T4.ItmsGrpNam 'Grupo del artículo', T5.FirmName 'Nombre del fabricante',
CASE T2.BaseType
WHEN 14 THEN  T2.Quantity
ELSE '-' + CONVERT (VARCHAR(20), T2.Quantity)
END  'Cantidad', 
CASE T2.BaseType 
WHEN 14 THEN T2.LineTotal
ELSE '-' + CONVERT(VARCHAR(20), T2.LineTotal) 
END 'Total Partida',
 '-' + CONVERT(VARCHAR(20), (T2.StockPrice * T2.Quantity)) 'Costo por partida'
FROM ORIN T0 
INNER JOIN OSLP T1 ON T0.SlpCode=T1.SlpCode
INNER JOIN RIN1 T2 ON T0.DocEntry=T2.DocEntry
INNER JOIN OITM T3 ON T2.ItemCode=T3.ItemCode
INNER JOIN OITB T4 ON T3.ItmsGrpCod=T4.ItmsGrpCod
INNER JOIN OMRC T5 ON T5.FirmCode=T3.FirmCode
WHERE T0.DocDate >= @FechaInicio AND T0.DocDate <= @FechaFin  AND T0.CardName=@CodeSN
ELSE

IF @FechaInicio IS NOT NULL AND @FechaFin IS NOT NULL AND   @CodeSN IS  NULL  AND @CodeArticulo  IS NOT NULL 
SELECT  T1.SlpCode 'Código Vendedor', T1.SlpName 'Nombre Vendedor', T0.CardCode 'Código Cliente', T0.CardName 'Nombre del Cliente', 
CASE T0.ObjType 
WHEN 13 THEN 'FACTURA'
END 'Tipo Documento', 
T0.DocNum 'Folio', ' ' 'Documento al que aplica', FORMAT(T0.DocDate, 'yyyy-MM-dd') 'Fecha  Factura',  T2.ItemCode 'Código Artículo', T2.Dscription 'Descripción del Artículo', 
T4.ItmsGrpNam 'Grupo del artículo', T5.FirmName 'Nombre del fabricante', 
CASE T0.CANCELED 
WHEN 'C' THEN  '-' + CONVERT(VARCHAR(20), T2.Quantity)
WHEN 'N' THEN T2.Quantity
WHEN 'Y' THEN T2.Quantity
END  'Cantidad', 
CASE T0.CANCELED
WHEN 'C' THEN '-' + CONVERT(VARCHAR(20), T2.LineTotal)
WHEN 'N' THEN T2.LineTotal
WHEN 'Y' THEN T2.LineTotal
END  'Total Partida',
CASE T0.CANCELED
WHEN 'C' THEN '-' + CONVERT(VARCHAR(20),  (T2.StockPrice * T2.Quantity))
WHEN 'N' THEN (T2.StockPrice * T2.Quantity)
WHEN 'Y' THEN (T2.StockPrice * T2.Quantity)
END 'Costo por partida'
FROM OINV T0 
INNER JOIN OSLP T1 ON T0.SlpCode=T1.SlpCode
INNER JOIN INV1 T2 ON T0.DocEntry=T2.DocEntry
INNER JOIN OITM T3 ON T2.ItemCode=T3.ItemCode
INNER JOIN OITB T4 ON T3.ItmsGrpCod=T4.ItmsGrpCod
INNER JOIN OMRC T5 ON T5.FirmCode=T3.FirmCode
WHERE T0.DocDate >= @FechaInicio AND T0.DocDate <= @FechaFin  AND T2.ItemCode=@CodeArticulo
UNION ALL
SELECT  T1.SlpCode 'Código Vendedor', T1.SlpName 'Nombre Vendedor', T0.CardCode 'Código Cliente', T0.CardName 'Nombre del Cliente', 
CASE T0.ObjType 
WHEN 14 THEN 'NC'
END 'Tipo Documento',  
T0.DocNum 'Folio',  
CASE T2.BaseType
WHEN 13 THEN 'F ' + T2.BaseRef
WHEN 14 THEN 'NC ' + T2.BaseRef
END  'Documento al que aplica',
 FORMAT(T0.DocDate, 'yyyy-MM-dd') 'Fecha  Factura', T2.ItemCode 'Código Artículo', T2.Dscription 'Descripción del Artículo', 
T4.ItmsGrpNam 'Grupo del artículo', T5.FirmName 'Nombre del fabricante',
CASE T2.BaseType
WHEN 14 THEN  T2.Quantity
ELSE '-' + CONVERT (VARCHAR(20), T2.Quantity)
END  'Cantidad', 
CASE T2.BaseType 
WHEN 14 THEN T2.LineTotal
ELSE '-' + CONVERT(VARCHAR(20), T2.LineTotal) 
END 'Total Partida',
 '-' + CONVERT(VARCHAR(20), (T2.StockPrice * T2.Quantity)) 'Costo por partida'
FROM ORIN T0 
INNER JOIN OSLP T1 ON T0.SlpCode=T1.SlpCode
INNER JOIN RIN1 T2 ON T0.DocEntry=T2.DocEntry
INNER JOIN OITM T3 ON T2.ItemCode=T3.ItemCode
INNER JOIN OITB T4 ON T3.ItmsGrpCod=T4.ItmsGrpCod
INNER JOIN OMRC T5 ON T5.FirmCode=T3.FirmCode
WHERE T0.DocDate >= @FechaInicio AND T0.DocDate <= @FechaFin  AND T2.ItemCode=@CodeArticulo
