---
layout: post
title: Query de ventas por clientes en un periodo
url: /query-ventas-por-clientes-periodo/
category: sql
published: true
date: 2018-03-19T11:17:00-03:00
---

Al entrar a este [fórum de Ayuda SAP](https://foros.consultoria-sap.com) buscaba como hacer consultas para hacer un análisis de ventas, seguí las recomendación que dieron y aquí les comparto el query que hice y que me dio resultados.

Reporte que muestra las Ventas Netas por cliente en el 2017 y calcula % que representa el total vendido al cliente en relación al monto total vendido en el año.

<!--more-->

## Código SQL

```sql
Declare @Venta2017 as numeric
 
SET @Venta2017= ( (Select SUM (T3.LineTotal) 
FROM OINV T2 INNER JOIN INV1 T3 ON T2.DocEntry = T3.DocEntry 
where T2.DocDate between '20170101' and '20171231') + (SELECT case when SUM (T5.LineTotal)*-1 < 0 THEN SUM (T5.LineTotal)*-1 ELSE 0 END
FROM ORIN T4 INNER JOIN RIN1 T5 ON T4.DocEntry = T5.DocEntry 
where T4.DocDate between '20170101' and '20171231'))

Select T2. Cardcode 'Cliente', T8.CardName 'Nombre Cliente',
SUM (T3.LineTotal) 'Total Facturado 2017',
(SELECT case when SUM (T5.LineTotal)*-1 < 0 THEN SUM (T5.LineTotal)*-1 ELSE 0 END
FROM ORIN T4 INNER JOIN RIN1 T5 ON T4.DocEntry = T5.DocEntry 
where T4.DocDate between '20170101' and '20171231' and T2. cardcode=T4.CardCode) 'Notas de Crédito 2017',

SUM (T3.LineTotal) +
(SELECT case when SUM (T5.LineTotal)*-1 < 0 THEN SUM (T5.LineTotal)*-1 ELSE 0 END
FROM ORIN T4 INNER JOIN RIN1 T5 ON T4.DocEntry = T5.DocEntry 
where T4.DocDate between '20170101' and '20171231' and T2.cardcode=T4.CardCode) 'Venta Neta 2017',

(SUM (T3.LineTotal) + (SELECT case when SUM (T5.LineTotal)*-1 < 0 THEN SUM (T5.LineTotal)*-1 ELSE 0 END
FROM ORIN T4 INNER JOIN RIN1 T5 ON T4.DocEntry = T5.DocEntry 
where T4.DocDate between '20170101' and '20171231' and T2.cardcode=T4.CardCode)) / @Venta2017*100 as'% del total vendido'

FROM OINV T2 
INNER JOIN INV1 T3 ON T2.DocEntry = T3.DocEntry 
INNER JOIN OCRD T8 ON T8.[CardCode]= T2.[CardCode]
where T2.DocDate between '20170101' and '20171231'
Group By T2.CardCode, T8.CardName
Order By 5 Desc
```

## Qué hace el reporte
El reporte presentado les permite mostrar las Ventas Netas por cliente en el 2017 (facturas menos NC) y además calcula % que representa el total vendido al cliente en relación al monto total vendido en ese año. En ese reporte primero declaro una variable para almacenar el total vendido (facturas – NC) por la empresa en ese año. Luego dentro de una consulta a las tablas de las facturas (OINV y INV1) primero calculo la columna total facturado a un cliente:
`SUM (T3.LineTotal) 'Total Facturado 2017’`

Y luego coloco una subconsulta para calcular el valor de las notas de crédito por cliente, la siguiente columna muestra la suma de lo facturado a un cliente mas el valor de las NC (que aparecen en negativo).

Por ultimo dividiendo el total facturado a un cliente entre la variable con el total vendido en el año, calculo que por ciento del total vendido corresponde a las ventas de ese cliente.

>Nota: dentro del subquery de la NC tuve que meter un case porque me traía valor null en aquellos casos que no tenían NC, por lo tanto tuve que ponerle valor cero para poderlo sumar con lo facturado y mostrar la columna del total

### Acerca del autor
[Erick Alvarez](https://foros.consultoria-sap.com/u/Alvarez) es consultor de certificado de SAP Business One desde diciembre del 2011, antes se dedicaba al soporte de IT en la parte de infraestructura informática. En estos años ha aprendido algo de Querys y es un tema que le gusta. Se unió a esta comunidad con el objetivo de seguir aprendiendo de como hacer reportes en Sql y al mismo tiempo poder compartir lo que ha aprendido. Actualmente trabaja con la version 9.2 PL 10.

