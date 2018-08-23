###############################################################
#   Demo paso a paso Secop Explorer con el ejemplo
#
#
###############################################################

###############################################################
# 1. Limpiar workspace y llamar las dependencias
###############################################################

rm(list=ls())


if(!requireNamespace("RSocrata", quietly = TRUE))
  install.packages("RSocrata", quiet = TRUE, dependencies = TRUE)  
if(!requireNamespace("arcgisbinding", quietly = TRUE))
  install.packages("arcgisbinding", quiet = TRUE, dependencies = TRUE)
if(!requireNamespace("stringi", quietly = TRUE))
  install.packages("stringi", quiet = TRUE, dependencies = TRUE)  
if(!requireNamespace("doBy", quietly = TRUE))
  install.packages("doBy", quiet = TRUE, dependencies = TRUE)
if(!requireNamespace("sp", quietly = TRUE))
  install.packages("sp", quiet = TRUE, dependencies = TRUE)
if(!requireNamespace("sqldf", quietly = TRUE))
  install.packages("sqldf", quiet = TRUE, dependencies = TRUE)


library("RSocrata")
library("arcgisbinding")
library("stringi")
library("doBy")
library("sp")
library("sqldf")

###############################################################
# 2. Checkeo de licencia de arcgis pro
###############################################################

arc.check_product()


###############################################################
# 3. Definicion de constantes
###############################################################


pathMunicipios <- "c:\\esri\\r-arcgis-bridge-col-demo\\colombia.gdb\\municipios"
portal_socrata = "https://www.datos.gov.co"
resource ="/resource/c6dm-udt9.json?"
ano_consulta = "2017"
querybase=""
salida = "c:\\esri\\r-arcgis-bridge-col-demo\\colombia.gdb\\analisissalida"
columna_municipio = "municipio_obtencion"

###############################################################
# 4. Elaboracion de las consultas
###############################################################

if (is.null(querybase) ){
  querybase<-""
}



query<- paste("$select=",columna_municipio,sep="")
query<- paste(query,",sum(cuantia_contrato)&$group=",sep="")
query<- paste(query,columna_municipio,sep="")
query<- paste(query,"&$where=anno_firma_del_contrato='",sep="")
query<- paste(query,ano_consulta,sep="")
query<- paste(query,"'&$order=",sep="")
query<- paste(query,columna_municipio,sep="")


if (querybase!="") {
  query <- paste(query,"$q=",sep="")
  query <- paste(query,querybase,sep="")
}


secop_portal_url <- paste(portal_socrata,resource,sep="")
request <- paste(secop_portal_url,query,sep="")

#typeof(querybase)

###############################################################
# 4. Cargue de datos al workspace
###############################################################


df <- read.socrata(request)
arcMuni <- arc.open(path=pathMunicipios)
d_sub <- arc.select(arcMuni, fields = "*", where_clause = "1=1")
element<- arc.data2sp(d_sub)

#rownames(element@data)

#summary(element)

#spplot(element)

#x<-element$data.frame

df$muniUpper <- toupper(df$municipio_obtencion)
df$muniUpper <-gsub("Á","A",df$muniUpper)
df$muniUpper <-gsub("É","I",df$muniUpper)
df$muniUpper <-gsub("Í","E",df$muniUpper)
df$muniUpper <-gsub("Ó","O",df$muniUpper)
df$muniUpper <-gsub("Ú","U",df$muniUpper)
df$cuantia <- as.numeric(df$sum_cuantia_contrato)/1000000


aggdata <- summaryBy(cuantia ~ muniUpper,data = df, FUN = sum)

mp <- element@data
OutDF<- sqldf("select a.*, b.'cuantia.sum' as totalContratado from mp as a left join aggdata as b on a.MPIO_CNMBR = b.muniUpper" )

element2 <- SpatialPolygonsDataFrame(element,OutDF,match.ID = FALSE)
#help("arc.sp2data")

#sx <- arc.sp2data(element2)

arc.write(salida,element2)


