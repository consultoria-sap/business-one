SELECT 
T0.[TransId], T0.[Line_ID], MAX(T0.[Account]), MAX(T0.[ShortName]), MAX(T0.[TransType]), MAX(T0.[CreatedBy]),
 MAX(T0.[BaseRef]), MAX(T0.[SourceLine]), MAX(T0.[RefDate]), MAX(T0.[DueDate]), MAX(T0.[TaxDate]), 
 MAX(T0.[BalDueCred]) + SUM(T1.[ReconSum]), MAX(T0.[BalFcCred]) + SUM(T1.[ReconSumFC]), MAX(T0.[BalScCred]) + SUM(T1.[ReconSumSC]), 
 MAX(T0.[LineMemo]), MAX(T3.[FolioPref]), MAX(T3.[FolioNum]), MAX(T0.[Indicator]),MAX(T4.[CardName]), MAX(T5.[CardCode]), 
 MAX(T5.[CardName]), MAX(T4.[Balance]), MAX(T5.[NumAtCard]), MAX(T5.[SlpCode]), MAX(T0.[Project]), MAX(T0.[Debit]) - MAX(T0.[Credit]), 
 MAX(T0.[FCDebit]) - MAX(T0.[FCCredit]), MAX(T0.[SYSDeb]) - MAX(T0.[SYSCred]), MAX(T4.[PymCode]), MAX(T5.[BlockDunn]), 
 MAX(T5.[DunnLevel]), MAX(T5.[TransType]), MAX(T5.[IsSales]), MAX(T4.[Currency]), MAX(T0.[FCCurrency]), MAX(T6.[SlpName]), 
 MAX(T4.[DunTerm]), MAX(T0.[DunnLevel]), T0.[BPLName], MAX(T4.[ConnBP]), MAX(T4.[CardCode]), T0.[TransId], MAX(T3.[AgrNo])
 FROM  [dbo].[JDT1] T0  
 INNER  JOIN [dbo].[ITR1] T1  ON  T1.[TransId] = T0.[TransId]  AND  T1.[TransRowId] = T0.[Line_ID]   
 INNER  JOIN [dbo].[OITR] T2  ON  T2.[ReconNum] = T1.[ReconNum]   
 INNER  JOIN [dbo].[OJDT] T3  ON  T3.[TransId] = T0.[TransId]   
 INNER  JOIN [dbo].[OCRD] T4  ON  T4.[CardCode] = T0.[ShortName]    
 LEFT OUTER  JOIN [dbo].[B1_JournalTransSourceView] T5  ON  T5.[ObjType] = T0.[TransType]  AND  T5.[DocEntry] = T0.[CreatedBy]  
 AND  (T5.[TransType] <> 'I'  OR  (T5.[TransType] = 'I'  AND  T5.[InstlmntID] = T0.[SourceLine] ))   
 LEFT OUTER  JOIN [dbo].[OSLP] T6  ON  T6.[SlpCode] = T5.[SlpCode]  OR  (T6.[SlpName] = '-Ningún empleado del departamento de ventas-'  AND  (T0.[TransType] = '30'  OR  
T0.[TransType] = '321'  OR  T0.[TransType] = '-5'  OR  T0.[TransType] = '-2'  OR  T0.[TransType] = '-3'  OR  T0.[TransType] = '-4' ))  
WHERE T0.[RefDate] <=  [%0]  AND  T0.[RefDate] <=  [%1]  AND  T4.[CardType] =  [%2]  AND  T4.[Balance] <>  [%3] 
 AND  T6.[SlpName] >=  [%4]  AND  T6.[SlpName] <=  [%5]  AND  T6.[Active] =  [%6]  AND  T2.[ReconDate] >  [%7]  
 AND  T1.[IsCredit] =  [%8]   GROUP BY T0.[TransId], T0.[Line_ID], T0.[BPLName] 
 HAVING MAX(T0.[BalFcCred]) <>- SUM(T1.[ReconSumFC])  OR  MAX(T0.[BalDueCred]) <>- SUM(T1.[ReconSum])   
 UNION ALL SELECT T0.[TransId], T0.[Line_ID], MAX(T0.[Account]), MAX(T0.[ShortName]), MAX(T0.[TransType]), 
 MAX(T0.[CreatedBy]), MAX(T0.[BaseRef]), MAX(T0.[SourceLine]), MAX(T0.[RefDate]), MAX(T0.[DueDate]), 
 MAX(T0.[TaxDate]),  - MAX(T0.[BalDueDeb]) - SUM(T1.[ReconSum]),  - MAX(T0.[BalFcDeb]) - SUM(T1.[ReconSumFC]), 
  - MAX(T0.[BalScDeb]) - SUM(T1.[ReconSumSC]), MAX(T0.[LineMemo]), MAX(T3.[FolioPref]), MAX(T3.[FolioNum]), 
  MAX(T0.[Indicator]), MAX(T4.[CardName]), MAX(T5.[CardCode]), MAX(T5.[CardName]), MAX(T4.[Balance]), 
  MAX(T5.[NumAtCard]), MAX(T5.[SlpCode]), MAX(T0.[Project]), MAX(T0.[Debit]) - MAX(T0.[Credit]), 
  MAX(T0.[FCDebit]) - MAX(T0.[FCCredit]), MAX(T0.[SYSDeb]) - MAX(T0.[SYSCred]), MAX(T4.[PymCode]), MAX(T5.[BlockDunn]), 
  MAX(T5.[DunnLevel]), MAX(T5.[TransType]), MAX(T5.[IsSales]), MAX(T4.[Currency]), MAX(T0.[FCCurrency]), MAX(T6.[SlpName]), 
  MAX(T4.[DunTerm]), MAX(T0.[DunnLevel]), T0.[BPLName], MAX(T4.[ConnBP]), MAX(T4.[CardCode]), T0.[TransId], MAX(T3.[AgrNo]) 
  FROM  [dbo].[JDT1] T0  
  INNER  JOIN [dbo].[ITR1] T1  ON  T1.[TransId] = T0.[TransId]  AND  T1.[TransRowId] = T0.[Line_ID]   
  INNER  JOIN [dbo].[OITR] T2  ON  T2.[ReconNum] = T1.[ReconNum]   
  INNER  JOIN [dbo].[OJDT] T3  ON  T3.[TransId] = T0.[TransId]   
  INNER  JOIN [dbo].[OCRD] T4  ON  T4.[CardCode] = T0.[ShortName]    
  LEFT OUTER  JOIN [dbo].[B1_JournalTransSourceView] T5  ON  T5.[ObjType] = T0.[TransType]  AND  T5.[DocEntry] = T0.[CreatedBy]  
  AND  (T5.[TransType] <> 'I'  OR  (T5.[TransType] = 'I'  AND  T5.[InstlmntID] = T0.[SourceLine] ))   
  LEFT OUTER  JOIN [dbo].[OSLP] T6  ON  T6.[SlpCode] = T5.[SlpCode]  OR  (T6.[SlpName] = '-Ningún empleado del departamento de ventas-                                                                                                               '  AND  (T0.[TransType] = '30'  OR  T0.[TransType] = '321'  OR  T0.[TransType] = '-5'  OR  T0.[TransType] = '-2'  OR  T0.[TransType] = '-3'  OR  T0.[TransType] = '-4' ))  WHERE 
T0.[RefDate] <=  [%9]  AND  T0.[RefDate] <=  [%10]  AND  T4.[CardType] =  [%11]  AND  T4.[Balance] <>  [%12]  
AND  T6.[SlpName] >=  [%13]  AND  T6.[SlpName] <=  [%14]  AND  T6.[Active] =  [%15]  AND  T2.[ReconDate] >  [%16] 
AND  T1.[IsCredit] =  [%17]   
GROUP BY T0.[TransId], T0.[Line_ID], T0.[BPLName] HAVING 
MAX(T0.[BalFcDeb]) <>- SUM(T1.[ReconSumFC])  OR  MAX(T0.[BalDueDeb]) <>- SUM(T1.[ReconSum])   
UNION ALL SELECT T0.[TransId], T0.[Line_ID], MAX(T0.[Account]), 
MAX(T0.[ShortName]), MAX(T0.[TransType]), MAX(T0.[CreatedBy]), MAX(T0.[BaseRef]), MAX(T0.[SourceLine]), 
MAX(T0.[RefDate]), MAX(T0.[DueDate]),MAX(T0.[TaxDate]), MAX(T0.[BalDueCred]) - MAX(T0.[BalDueDeb]), 
MAX(T0.[BalFcCred]) - MAX(T0.[BalFcDeb]), MAX(T0.[BalScCred]) - MAX(T0.[BalScDeb]), 
MAX(T0.[LineMemo]), MAX(T1.[FolioPref]), MAX(T1.[FolioNum]), MAX(T0.[Indicator]), MAX(T2.[CardName]), MAX(T3.[CardCode]), 
MAX(T3.[CardName]), MAX(T2.[Balance]), MAX(T3.[NumAtCard]), MAX(T3.[SlpCode]), MAX(T0.[Project]), 
MAX(T0.[Debit]) - MAX(T0.[Credit]), MAX(T0.[FCDebit]) - MAX(T0.[FCCredit]), 
MAX(T0.[SYSDeb]) - MAX(T0.[SYSCred]), MAX(T2.[PymCode]), MAX(T3.[BlockDunn]), MAX(T3.[DunnLevel]), 
MAX(T3.[TransType]), MAX(T3.[IsSales]), MAX(T2.[Currency]), 
MAX(T0.[FCCurrency]), MAX(T4.[SlpName]), MAX(T2.[DunTerm]), MAX(T0.[DunnLevel]), T0.[BPLName], MAX(T2.[ConnBP]), 
MAX(T2.[CardCode]), T0.[TransId], MAX(T1.[AgrNo]) 
FROM  
[dbo].[JDT1] T0  
INNER  JOIN [dbo].[OJDT] T1  ON  T1.[TransId] = T0.[TransId]   
INNER  JOIN [dbo].[OCRD] T2  ON  T2.[CardCode] = T0.[ShortName]    
LEFT OUTER  JOIN [dbo].[B1_JournalTransSourceView] T3  ON  T3.[ObjType] = T0.[TransType]  AND  T3.[DocEntry] = T0.[CreatedBy]  AND  
(T3.[TransType] <> 'I'  OR  (T3.[TransType] = 'I'  AND  T3.[InstlmntID] = T0.[SourceLine] ))   
LEFT OUTER  JOIN [dbo].[OSLP] T4  ON  T4.[SlpCode] = T3.[SlpCode]  OR  (T4.[SlpName] = '-Ningún empleado del departamento de ventas-'  
AND (T0.[TransType] = '30'  OR  T0.[TransType] = '321'  OR  T0.[TransType] = '-5'  OR  T0.[TransType] = '-2'  OR  T0.[TransType] = '-3'
