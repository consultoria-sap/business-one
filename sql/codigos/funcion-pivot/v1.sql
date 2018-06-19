SELECT
Código,
Nombre_Proveedor,
País,
ISNULL ([2014],0) as ‘2014’,
ISNULL ([2015],0) as ‘2015’,
ISNULL ([2016],0) as ‘2016’,
ISNULL ([2017],0) as ‘2017’,
ISNULL ([2018],0) as ‘2018’,
ISNULL ([2014],0)+ ISNULL ([2015],0) + ISNULL ([2016],0) + ISNULL ([2017],0) + ISNULL ([2018],0) as’Total Comprado’
FROM
(
SELECT
T0.[CardCode]‘Código’,
T0.[CardName] ‘Nombre_Proveedor’,
T2.Country ‘País’,
Year (T0.[DocDate]) ‘Año’,
SUM (T1.[LineTotal]) ‘Total’
FROM OPCH T0
INNER JOIN PCH1 T1 ON T0.[DocEntry] = T1.[DocEntry]
INNER JOIN OCRD T2 ON T0.CardCode = T2.CardCode
WHERE T1.[TargetType] <>19 and T0.[CANCELED]=‘N’ and T0.[DocType] =‘I’
and year (T0.[DocDate]) Between 2014 and 2018
GROUP BY T0.[CardCode], T0.[CardName], T2.Country, year (T0.[DocDate])
) A
Pivot (SUM (Total) for Año IN ([2014],[2015],[2016],[2017],[2018]) ) A
ORDER BY 7 DESC

El segundo Query que les presentare es mas complejo porque incluye la unión de varias consultas
– Resumen comparativo entre Inventario comprado, Importe vendido y el Costo de lo Vendido.

SELECT
A.[Area],
[1] ‘Enero’,
[2] ‘Febrero’,
[3] ‘Marzo’,
[4] ‘Abril’,
[5] ‘Mayo’,
[6] ‘Junio’,
[7] ‘Julio’,
[8] ‘Agosto’,
[9] ‘Septiembre’,
[10] ‘Octubre’,
[11] ‘Noviembre’,
[12] ‘Diciembre’

FROM
(
– Importe comprado en el mes
SELECT
‘Valor Comprado’ as Area,
Month (T0.[DocDate]) ‘Mes’,
SUM (T1.[LineTotal]) ‘Total’
FROM OPCH T0
INNER JOIN PCH1 T1 ON T0.[DocEntry] = T1.[DocEntry]
WHERE T1.[TargetType] <>19 and T0.[CANCELED]=‘N’ and T0.[DocType] =‘I’ and year (T0.[DocDate])=2018
GROUP BY Month (T0.[DocDate]), DateName (Month, T0.[DocDate])

UNION
– Importe vendido en el mes
SELECT
‘Total Vendido’ as Area,
Month (T0.[DocDate]) ‘Mes’,
SUM (T1.[LineTotal]) ‘Total’
FROM OINV T0
INNER JOIN INV1 T1 ON T0.[DocEntry] = T1.[DocEntry]
WHERE T0.[CANCELED]=‘N’ and T0.[DocType] =‘I’ and year (T0.[DocDate])=2018
GROUP BY Month (T0.[DocDate]), DateName (Month, T0.[DocDate])
UNION
SELECT
‘Total Vendido’ as Area,
Month (T0.[DocDate]) ‘Mes’,
SUM (T1.[LineTotal])*-1 ‘Total’
FROM ORIN T0
INNER JOIN RIN1 T1 ON T0.[DocEntry] = T1.[DocEntry]
WHERE T0.[CANCELED]=‘N’ and T0.[DocType] =‘I’ and year (T0.[DocDate])=2018
GROUP BY Month (T0.[DocDate]), DateName (Month, T0.[DocDate])

UNION
– Costo de las mercancias vendidas
SELECT
‘Costo Vendido’ as Area,
Month (T0.[DocDate]) ‘Mes’,
SUM (T1.[GPTtlBasPr]) ‘Total’
FROM OINV T0
INNER JOIN INV1 T1 ON T0.[DocEntry] = T1.[DocEntry]
WHERE T0.[CANCELED]=‘N’ and T0.[DocType] =‘I’ and year (T0.[DocDate])=2018
GROUP BY Month (T0.[DocDate]), DateName (Month, T0.[DocDate])
UNION
SELECT
‘Costo Vendido’ as Area,
Month (T0.[DocDate]) ‘Mes’,
SUM (T1.[GPTtlBasPr])*-1 ‘Total’
FROM ORIN T0
INNER JOIN RIN1 T1 ON T0.[DocEntry] = T1.[DocEntry]
WHERE T0.[CANCELED]=‘N’ and T0.[DocType] =‘I’ and year (T0.[DocDate])=2018
GROUP BY Month (T0.[DocDate])
) A
PIVOT (SUM (Total) FOR [MES] IN ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12]) ) A
