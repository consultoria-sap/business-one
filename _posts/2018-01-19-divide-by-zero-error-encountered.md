---
layout: post
title: Error en Query SQL Divide by Zero
url: /divide-by-zero-error-encountered/
category: sql
published: true
date: 2018-01-19T14:08:00-03:00
---

Hola Podrían ayudarme con un Query que dejo de funcionar sin explicacion!
el error que me aparece es **divide by zero error encountered SWEI**
Les dejo la consulta SQL que uso.

<!--more-->

## Causa
Una línea manda un campo en 0 que quieres dividir

La solución es identificar dicho campo que se manda en `0` antecedele `ISNULL(tucampo,1)`

Pero el problema esta división

`/AVG(T1.[Price]*@cambio))*100`

No puedes dividir números entre `0` puedes ponerle

```sql
CASE WHEN AVG(T1.[Price]*@cambio))100 = 0 THEN 1
ELSE AVG(T1.[Price]@cambio))*100 END
```

### Variable @cambio
El problema como ya te comentaron, es que la variable `@cambio` esta obteniendo el valor 0 en ciertos rangos de fecha, por eso debes validar dicho valor antes de hacer el resto de la consulta.

`AVG(T1.[Price]*@cambio) AS ‘Precio promedio’` o en algún otro AVG…

Consulta las facturas de algún periodo donde te marque error tu query (tablas `OINV` , `INV1`) muy muy probablemente tengas un precio en `0` y es lo que está originando el problema, filtra donde `price` sea `= ‘0’` para ubicarlo mas rápido

## SQL final (funcionando)

{% highlight sql %}
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
{% endhighlight %}



***

[Leer todo el debate original](http://foros.consultoria-sap.com/t/error-de-query-en-sap/22276)
