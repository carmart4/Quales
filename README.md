# Análisis de datos y gestión de la información: DataShop 🚀

<div id = "header" align = "center">
</div>

Proyecto final integrador para la capacitación de análisis de datos y gestión de la información recibido por Quales, empresa de tecnología especialista en el diseño e implementación de soluciones de datos. 

<div id = "header" align = "center">
  <img src="https://github.com/smartinez24/Quales/blob/main/Diagramas/Diagrama_modelo_completo.png" width="700" />
</div>

<div id ='badges' align = 'center'>
  <a href = 'https://www.linkedin.com/in/carlos-martinez08'>
    <img src = 'https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white' alt = 'LinkedIn Badge' />
</div>

<div align = 'center'>
</div>

---
<h3> Descripción </h3>

Este proyecto desarrolla una solución integral de datos, abordando los conceptos de ***cultura de datos , gestión y visualización, y relevamiento funcional***, para una empresa ficticia dedicada al comercio minorista de electrodomésticos, con el fin de analizar los datos de ventas, facilitar la toma de decisiones informadas y asegurar un mantenimiento evolutivo del sistema. 

---

<h3> Contexto </h3>

Se plantea de forma práctica, para una empresa ficticia llamada DataShop dedicada al comercio minorista de electrodomésticos, una solución integral que le permita *analizar sus datos de ventas y tomar decisiones informadas*. 
Esta _primera parte_ será llevada a cabo siguiendo las siguientes fases:
-	Creación del Data Warehouse: partiendo de los datos con los que actualmente cuenta el negocio, modelar el caso. 
-	Procesos de ETL con Python y SQL: desarrollo de scripts de Python para la extracción de datos y desarrollo de Store Procedures en SQL para la carga de datos, manteniendo el flujo documentado. 
-	Creación de tablero de PowerBI: creación de un informe en PowerBI, que permita analizar KPI’s, detalles de ventas y comparativas de ventas.

<div id = "header" align = "center">
  <img src="https://github.com/smartinez24/Quales/blob/main/Diagramas/Diagrama_modelo_parcial.png" width="500" />
</div>

Luego, para la _segunda parte_ de este proyecto integrador, el cliente decide contratarnos nuevamente para realizar un mantenimiento evolutivo de la solución de datos ya desarrollada.
El cliente ha decidido mejorar el seguimiento de sus pedidos desde la venta hasta la entrega final, por lo que es necesario implementar un modelo de datos extendido que permita *analizar de manera detallada el desempeño de sus procesos de ventas y logística*, siguiendo las siguientes reglas de negocio:

<div id = "header" align = "center">
  <img src="https://github.com/smartinez24/Quales/blob/main/Diagramas/Reglas_negocio.png" width="500" />
</div>

Los pasos desarrollados para la incorporación en el modelo son: 
-	Armar el modelo lógico y físico: detección de las tablas de hechos y dimensiones para lograr las relaciones entre entidades y la incorporación al Data Warehouse.  
-	Procesos de ETL: ajustar los procesos existentes para la carga de las entidades, realizando nuevas limpiezas y validaciones. 
-	Visualización en PowerBI: agregar KPI’s y visualizaciones para conocer las entregas promedio, tiempos de entrega, porcentaje de pedidos, entre otros.

Cabe resaltar que, para ambas instancias del proyecto, los procesos de ETL, validación y visualización fueron llevados a cabo con el mismo flujo de trabajo. 

<div id = "header" align = "center">
  <img src="https://github.com/smartinez24/Quales/blob/main/Diagramas/Flujo.png" width="500" />
</div>

---

<h3> Contenido del proyecto </h3>

- 🔍 Extracción y limpieza de datos
- 📊 Análisis exploratorio de datos
- ✅ Validación e incorporación 
- 📈 Visualizaciones interactivas 

---

<h3> Estructura archivos y ruta de ejecución </h3>

> [!WARNING]
> Esta estructura está pensada en la ruta de ejecución. Dentro del proyecto se verán los ficheros de cada carpeta. 

```
Quales
├─── SQL_Scripts
    ├─── fase1
    │   ├─── creation # Es importante seguir el orden MODEL, INTER y en último lugar STG.
    │   └─── stored_procedures_created
│─── Python_Scripts
│   ├───fase1 # VENTAS es la tabla de hechos. Es por eso que en todas las fases, los procesos etl de ventas, se debe ejecutar en último lugar. 
│   │   ├─── STG
│   │   ├─── INT
│   │   └─── DW
├─── SQL_Scripts
    ├─── fase2
        │   ├─── creation # Es importante seguir el orden MODEL, INTER y en último lugar STG.
        │   └─── stored_procedures_created
└─── Python_Scripts
│   ├─── fase2 # Dada la jerarquía del modelo, PROVINCIA se debe ejecutar en primer lugar. Por último, la dimensión ENTREGA, que será nuestra tabla de hechos. 
│   │   ├─── STG_log
│   │   ├─── INT_log
│   │   └─── DW_log

```

---

<h3> Visualizaciones </h3>

<h4> Resumen de KPIs de ventas </h4>

<div id = "header" align = "center">
  <img src="https://github.com/carmart4/Quales/blob/main/PowerBI/capturas/ventas.jpg" width="600" />
</div>

<h4> Resumen de KPIs de productos y clientes </h4>

<div id = "header" align = "center">
  <img src="https://github.com/carmart4/Quales/blob/main/PowerBI/capturas/prod_client.jpg" width="600" />
</div>

<h4> Tabla de detalles de ventas </h4>

<div id = "header" align = "center">
  <img src="https://github.com/carmart4/Quales/blob/main/PowerBI/capturas/detvtas.jpg" width="600" />
</div>

<h4> Tabla comparativa de ventas por tienda </h4>

<div id = "header" align = "center">
  <img src="https://github.com/carmart4/Quales/blob/main/PowerBI/capturas/tiendavtas.jpg" width="600" />
</div>

<h4> Tablero de KPIs y visualizaciones sobre entregas </h4>

<div id = "header" align = "center">
  <img src="https://github.com/carmart4/Quales/blob/main/PowerBI/capturas/entregas.jpg" width="600" />
</div>

---

<h3> Tecnologías </h3>

- 🐍 Python - Pandas 
- 🧾 SQL Server Management Studio
- 📊 PowerBI - DAX

---
