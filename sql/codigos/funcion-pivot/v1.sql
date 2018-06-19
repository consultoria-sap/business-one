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
