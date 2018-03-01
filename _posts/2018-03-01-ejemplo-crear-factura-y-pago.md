---
layout: post
title: Ejemplo Crear Factura y Pago
url: /ejemplo-crear-factura-pago/
category: csharp
published: true
date: 2018-03-01T14:26:00-03:00
---

Quiero saber como podria ingresar una factura a SAP y aplicar al mismo tiempo el pago de esa factura por medio del SDK(DI API).

Ya que en SAP al momento de ingresar la factura puedo aplicar el pago de esta manera:
![Crear Factura y Pago Business One](https://foros.consultoria-sap.com/uploads/default/optimized/2X/5/5b326968eb1e738ec34f96eb54910229aa10d377_1_690x401.jpg "Crear Factura y Pago")

<!--more-->

# Código de Ejemplo

{% highlight cs %}
private void btnCrearFactura_y_Pago_Click(object sender, EventArgs e) {
    Company oEmpresa = new Company();

    try {
        string baseDeDatosEMPRESA = "NombreEmpresaSAP";
        oEmpresa.Server = "SERVIDOR";
        oEmpresa.LicenseServer = "SERVIDOR:30000";
        oEmpresa.CompanyDB = baseDeDatosEMPRESA;
        oEmpresa.UserName = "usuarioBdSap";
        oEmpresa.Password = "passwordBdSap";
        oEmpresa.DbUserName = "usuarioSQL";
        oEmpresa.DbPassword = "passwordSQL";
        oEmpresa.DbServerType = BoDataServerTypes.dst_MSSQL2014;
        oEmpresa.language = BoSuppLangs.ln_Spanish_La;
        oEmpresa.UseTrusted = false;

        if(oEmpresa.Connect() != 0) {
            //int errNumero = 0; string errMensaje = "";
            oEmpresa.GetLastError(out int errNumero, out string errMensaje);
            oEmpresa.Disconnect();
            Marshal.ReleaseComObject(oEmpresa);
            oEmpresa = null;
            MessageBox.Show("Ha ocurrido el siguiente error al intentar conectar a la Base de Datos " + baseDeDatosEMPRESA + " en SAP\n\n" + errMensaje, tituloMSGBOX, MessageBoxButtons.OK, MessageBoxIcon.Warning);
            return;
        }

        // inicia transaction para asegurarse de que si NO se realicen con éxito todas las operaciones, deshaga cualquier cambio realizado hasta antes del error en caso de ocurrir
        oEmpresa.StartTransaction();
        
        // continúa el código ...
{% endhighlight %}

[Ver código completo](https://github.com/consultoria-sap/business-one/blob/master/csharp/codigos/crear-factura-y-pago/v0.cs)


## Qué hace el código

Realiza son las siguientes acciones:

1. Se conecta a la base de datos de SAP especificada, desde luego con las credenciales de un usuario de SAP, en caso de no plasmar la informaCIÓN correcta de un usuario, muestra un mensaje para informarlo.
1. En caso de conectarse con éxito, inicia una transacción, ésta sirva para encapsular más de una operación, de tal forma que podamos asegurarnos de que todas las operaciones se realicen con éxito.
1. Crea una factura con los datos que el usuario introduzca.
1. Como hasta este punto estamos en una transacción en proceso, podemos estar seguros que ningún otro usuario podra crear otro documento y tendremos la certeza de poder recuperar el último “DocEntry” del documento en cuestión, para posteriormente utilizarlo en la creación del pago.
1. Creamos el pago teniendo la certeza de que tenemos el “DocEntry” del documento que acabamos de crear.
1. Cerramos la transacción y en este momento nos aseguramos de DOS posibles resultados, si ejecutamos el comando “Commit” y todo es correcto, estamos guardando en firme en la Base de Datos toda la información, de lo contrario si existe algún problema (error), entonces nos encargamos de deshacer los cambios y ninguna operación será afectada en la Base de datos.

>NOTA: Este código lo adecué para efectos de apoyarle a nuestro compañero **@Oscar_Lara**, de un proceso que tengo para cargar entradas de mercancías, facturas de proveedores, anticipos, pago de liquidaciones, etc. de un Sistema de Cosecha de Granos que desarrollé para automatizar la carga de toda esta información a SAP, desde luego con enlaces nativos del Sistema SAP.

## Información sobre el autor
Con respecto a mi persona, mi nombre completo es Salvador Escobar Cabrera, actualemente estoy trabajando en GRUPO NU3, en La Piedad Michoacán, es un grupo muy diverso, tiene varias plantas de alimentos balanceados, para ganado vacuno, caballos, gallos, para mascotas (perros, gatos), empacadora, invernaderos, una financiera, semillas y fetilizantes para siembra, una Harinera, etc.

Actualmente estoy como lider de proyecto en un equipo de implementación de SAP Business One que yo mismo propuse y cree, conozco a SAP desde 2010 (hace más de 7 años), me certifiqué en la academia de SAP B1 Familia 8, en Mayo 2013 (0010576547), he fungido como lider de implementación en 3 plantas de alimentos balanceados (Santa Ana Pco. Pénjamo Gto, Veracruz, Lagos de Moreno), una Harinera de trigo en Lagos de Moreno, una empresa de Semillas y Fertilizantes para Siembra en Santa Ana Pco, Pénjamo Gto, varias boutiques (mascotas) en León, Acapulco, La Piedad, Morelia, etc. etc.; no puedo dejar de mencionar que siempre he tenido personas muy capaces en mi equipo, en su momento **@Gera_Mendez, @SAMUEL , @Fer_Solis2** y otros dos amigos y compañeros Janeth Barrientos y Joel Escobar, peronas muy importante en mi proceso de aprendizaje.

Actualmente estoy en vías de crear DOS equipos de implementación con Samuel, Fer, Janeth y Joel, de hecho están en proceso de capacitación a excepción de Samuel que ya tiene bastante experiencia; ellos TRES estan iniciando en involucrarse en una implementación, por ejemplo ahora estamos trabajando en paralelo en una implementaicón de otra boutique de mascotas en la Piedad y próximamente una en Guadalajara, y una Agropecuaria en La Piedad Mich., estamos entrando al mundo de las Agropecuarias Porcinas.

Asistí a una academia de SDK en Septiembre 2014, y que dicho sea de paso no nos permitieron certificarnos que porque no era posible para quienes no eramos partners ???, adqurí algunos conocimientos y más seguridad, porque dicha academia se enfocó para responder el examen y hubo muy poca práctica, en fin.

Desarrollo macros en VBA, también desarrollo en C#, realizo aplicaciones para controles administrativos así como aplicaciones/procesos para conectarme con DI API a SAP para automatizar tareas.

Con UI API, he hecho algunos pequeños procesos como la conexión de básculas industriales a SAP para extraer los pesajes, algunos botones para generar reportes u otro tipo de información; hago de todo un poco.

***

### [Contactar a Salvador a través del foro](https://foros.consultoria-sap.com/u/chavalito)
