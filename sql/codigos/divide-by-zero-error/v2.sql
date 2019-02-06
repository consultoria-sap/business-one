-- Fuente: https://foros.consultoria-sap.com/t/22276/13?u=sidv
-- Autor: Marckosss_P

DECLARE @cambio numeric(22,12 )
SET @cambio=(SELECT avg(T0.[Rate]) 
			 FROM ORTT T0 
			 WHERE T0.[Currency] ='USD' 
				   and  T0.[RateDate] between [%0] and [%1])

SET @cambio = IIF(@cambio > 0, @cambio, 1) --VERIFICARMOS QUE LA TASA > 0

SELECT 
	T1.[ItemCode]
	,T2.[SWW]
	, T1.[Dscription]
	, AVG(T1.[Price]*@cambio)AS 'Precio Prome LPS'
	, T2.[AvgPrice]as 'Costo LPS'
	,(AVG(T1.[Price]*@cambio)-T2.[AvgPrice]) as'Ganancia'
	,((AVG(T1.[Price]*@cambio)-T2.[AvgPrice])/ AVG(T1.[Price]*@cambio))*100 as '%'
	,(SELECT 
		SUM(T4.[Quantity]) 
	  FROM 
		OINV T3 INNER JOIN INV1 T4 ON T3.DocEntry = T4.DocEntry 
	  WHERE 
		T3.[DocDate] between [%0] and [%1] 
		and T3.[InvntSttus] <> 'C'  
		and T4.[ItemCode] =T1.[ItemCode]) as 'Total item Vendidas' 
	,(T2.[AvgPrice]-(T2.[AvgPrice]*0.2)) as 'Costo -20%'
FROM 
	OINV T0  INNER JOIN INV1 T1 ON T0.DocEntry = T1.DocEntry 
	INNER JOIN OITM T2 ON T1.ItemCode = T2.ItemCode 
WHERE 
	T0.[DocDate] between [%0] and [%1] 
	and T0.[DocStatus] not Like 'c%%' 
	and T0.[InvntSttus] not Like 'c%%' 
              and T1.[Price] > 0
	and  T1.[ItemCode] NOT Like 'PRODUC%%' 
GROUP BY 
	T1.[ItemCode]
	,T2.[SWW],T1.[Dscription]
	,T2.[AvgPrice] 
ORDER BY 
	T1.[ItemCode]
