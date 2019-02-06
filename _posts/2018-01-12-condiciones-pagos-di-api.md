---
layout: post
title: Condiciones de Pagos por DI API
url: /condiciones-pagos-di-api/
category: csharp
published: true
date: 2018-01-12T15:04:54+00:00
---

¿Cómo podría obtener las condiciones de pago por di api, y este pueda llenar una grilla? 
Son las condiciones de pagos de los socios de negociaciones en la pestaña de condiciones de pago. 
¿Se podria obtener por SAPbobs ? 

<!--more-->

## Solución aceptada
SI vas a CONSULTAR cualquier objeto o tabla de SAP Tienes basicamente 2 vias:

* Por una consulta SELECT a traves del objeto oRecordset de la DIAPI .
* A traves de un SELECT a la DB de SAP mediante una conexion ODBC, ADO, JDBC, etc…(Dependera del Lenguaje Usado).

La tabla de Condiciones de Pago de los SN es OCTG

Para consultar la tabla OCTG por medio de la DIAPI:

{% highlight cs %}
Dim oRecordSet As SAPbobsCOM.Recordset
  Dim sCodigoCondicion as Int
  Dim sNombreCondicion as String

  oRecordSet = oCompany.GetBusinessObject(SAPbobsCOM.BoObjectTypes.BoRecordset)

  oRecordSet.DoQuery("SELECT * FROM OCTG")
  
  oRecordSet.MoveFirst()

  While Not oRecordSet.EoF

    sCodigoCondicion  = oRecordSet .Fields.Item("GroupNum").Value
    sNombreCondicion  = oRecordSet .Fields.Item("PymntGroup").Value)

    oRecordSet .MoveNext()

  End While
{% endhighlight %}



***

[Leer todo el debate original](https://foros.consultoria-sap.com/t/20158) - :+1: 
