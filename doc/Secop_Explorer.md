# Secop Explorer

Esta herramienta sirve para explorar el dataset de [SECOP](https://www.datos.gov.co/Gastos-Gubernamentales/SECOP-I/nuxh-53y2) que se encuentra en el portal de [datos abiertos](datos.gov.co), con el fin de hacer hacer estadísticas por departamento y municipio. 

### Instrucciones de instalacion:

- Descargue el repositorio en la carpeta fija dentro del directorio `c:\esri\r-arcgis-bridge-col-demo` Si tiene git instalado ejecute los siguientes comandos

```
cd c:\
mkir esri
cd esri
git clone https://github.com/EsriColombia/r-arcgis-tools.git
cd r-arcgis-tools/datasets
unzip colombia.gdb.zip

```

Puede ejecutar el script R-Secop-Step-By-Step.R para comprobar funcionalidad

### Creacion de herramienta de geoprocesamiento

- Inicie una sesión de arcgis Pro.

- Cree una herramienta de geoprocesamiento a partir de un Script.

![R1](https://farm2.staticflickr.com/1897/42397090460_29cf5b5d0b_o.png)

- Agregue el script de R desde el directorio donde está el script y nombre la herramienta.

![R0](https://farm2.staticflickr.com/1890/29559998707_3f6c61761c_o.png)

- En el parametro Name, nómbrelo como **SecopExplorer**, en Label:  **Explora datos del portal de datos abiertos de Secop**, y las demás opciones, las que vienen por defecto, en la pestaña parametros 
llene los parámetros de la siguiente manera: 

![R2](https://farm2.staticflickr.com/1883/42397090320_c129f041cd_o.png)

- Al parametro año de consulta puede agregar un filtro manual con los años disponibles de consulta, que para el SECOP, son desde 2011 a 2018 (año de publicacion de esta herramienta)

![R3](https://farm2.staticflickr.com/1854/43486830794_dfdd00c111_o.png)

- Pruebe la herramienta ejecutandola directamente en ArcgisPro:

![R4](https://farm2.staticflickr.com/1845/42397090240_bdc4f649a8_o.png)

![R5](https://farm2.staticflickr.com/1860/44156787362_f9b9cf2205_o.png)

- Verifique el resultado y ajuste la simbologia del feature class de salida clasificando el resultado por la columna totalcontratado

![R6](https://farm2.staticflickr.com/1894/43486830674_815e8739a3_o.png)