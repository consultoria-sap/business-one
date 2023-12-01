---
layout: base
title: SAP Business One VBA
category: vba
---

# SAP Business One VBA

## SAP B1: Visual Basic
Nuestra [comunidad de Ayuda SAP](https://foros.consultoria-sap.com) lleva años brindando información, y soporte a miles de consultas de forma desinteresada y gratuita. 

### ¿Por qué compartir código?
A medida que más desarrolladores se unen a nuestra comunidad, vemos que los códigos se comparten entre sus miembros, pero no hay evolución ni mejoras a dichos códigos.

La idea de este repositorio es que el código pueda ser mejorado con el tiempo, o bien servir a otros usuarios que usan GitHub y comuidades afines para encontrar el código y aprender más sobre el mismo.

### Ayuda con VBA para SAP Business One
Si necesitas una mano, hay programadores evacuando sus dudas en nuestra comunidad de Ayuda SAP.

Dale una leída a los debates marcados con [#vba](https://foros.consultoria-sap.com/tags/vba) (o bien, envía tus consultas nuevas).

## Índice de códigos

<ul>
  {% for post in site.categories[page.category] %}
    <li>
      <a href="{{ site.baseurl }}{{ post.url }}">{{ post.title }}</a>
      {{ post.excerpt }}
    </li>
  {% endfor %}
</ul>



