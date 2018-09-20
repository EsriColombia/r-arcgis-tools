###################################
# Raster Processing
# Herramienta de demostracion para explorar datos del SECOP en forma de mapas
# 
# Requisitos: Arcgis Pro y R Studio, R-arcgis-binding instalado en el ambiente de R
# 
# Autores:  
# Andres Felipe Riapira: ariapira@esri.co
# Andres Ignacio Baez: abaez@esri.co
#
##################################
#Limpiando el espacio de trabajo
rm(list = ls())

#configurando el directorio de trabajo


#cargando las librerías
#install.packages("tmap")
#install.packages("raster")
#install.packages("randomForest")
#install.packages("sp")
#install.packages("devtools")
#library(devtools)
#install_github("rspatial/raster")


library(sp) 
library(raster)
library(arcgisbinding)
library(cluster)
library("r")

#verificando la licencia de ArcGIS
arc.check_product()
getwd()
setwd("c:\\esri\\r-arcgis-tools")
path_raster_entrada <- arc.open("cartagena.gdb\\cartagena")
path_raster_img <- "c:\\esri\\raster_salida"

#Leer raster de entrada
obj_data <- arc.open(path_raster_entrada)
#Convertirlo en un objeto r-arcgis
arc_raster <- arc.raster(obj_data)
#Convertirlo en un objeto raster
mi_raster <- as.raster(arc_raster)


#viendo el metadato
mi_raster
?raster

hist(mi_raster[], main=NULL)

dim(mi_raster)


#Color natural	4 3 2
plotRGB(mi_raster,r=4,g=3,b=2)
plotRGB(mi_raster,r=4,g=3,b=2, stretch="hist")

#Falso color (urbano)	7 6 4
plotRGB(mi_raster,r=7,g=6,b=4, stretch="hist")

#Color infrarrojo (vegetación)	5 4 3
plotRGB(mi_raster,r=5,g=4,b=3, stretch="hist")


#Agricultura	6 5 2
plotRGB(mi_raster,r=6,g=5,b=2, stretch="hist")

#Penetración atmosférica	7 6 5

plotRGB(mi_raster,r=7,g=6,b=5, stretch="hist")

#Vegetación saludable	5 6 2


#Tierra/agua	5 6 4

#Natural con remoción atmosférica	7 5 3

#Infrarrojo de onda corta	7 5 4


#Análisis de vegetación	6 5 4



plotRGB(mi_raster,r=3,g=2,b=1, stretch="hist")


plot(mi_raster)

#kmean calssification
?kmeans


v <- getValues(mi_raster)
i <- which(!is.na(v))
v <- na.omit(v)

E <- kmeans(v,12,iter.max = 100, nstart = 10)
kmeans_raster <- raster(mi_raster)
kmeans_raster[i] <- E$cluster

writeRaster(kmeans_raster, path_raster_img, format="HFA")








