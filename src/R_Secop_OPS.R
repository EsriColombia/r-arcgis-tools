###############################################################
#   Demo paso a paso Secop Explorer ejemplo 2
#   Extraer datos para contratos de prestacion de servicios
#   Por mes, por año
#   Por municipio
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
if(!requireNamespace("dplyr", quietly = TRUE))
  install.packages("dplyr", quiet = TRUE, dependencies = TRUE)

library("RSocrata")
library("arcgisbinding")
library("stringi")
library("doBy")
library("sp")
library("sqldf")
library("dplyr")


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

ano_inicial <- 2011
ano_final <- 2012

salida = "c:\\esri\\r-arcgis-bridge-col-demo\\colombia.gdb\\analisissalida"
columna_municipio = "municipio_obtencion"
departamento = "Boyacá"
codigo_departamento ="15"
###############################################################
# 4. Elaboracion de las consultas
###############################################################

  




getSecopData<- function (ano_consulta, mesconsulta, departamento)
{
  #ano_consulta <- 2017
  #mesconsulta <- 1
  #select=min(valor_contrato_con_adiciones),max(valor_contrato_con_adiciones)
  
  query<- paste("$select=",columna_municipio,sep="")
  query<- paste(query,",sum(valor_contrato_con_adiciones) as ","valor_contrato_",ano_consulta,"_",mesconsulta,sep="")
  query<- paste(query,",count(municipio_obtencion) as ","no_contratos_",ano_consulta,"_",mesconsulta,sep="")
  query<- paste(query,",avg(valor_contrato_con_adiciones) as ","avg_",ano_consulta,"_",mesconsulta,sep="")
  query<- paste(query,",min(valor_contrato_con_adiciones) as ","min_",ano_consulta,"_",mesconsulta,sep="")
  query<- paste(query,",max(valor_contrato_con_adiciones) as ","max_",ano_consulta,"_",mesconsulta,sep="")
  query<- paste(query,"&$group=",columna_municipio,sep="")
  query<- paste(query,"&$where=anno_firma_del_contrato='",ano_consulta,"'  AND id_grupo='F' AND date_extract_m(fecha_ini_ejec_contrato) = ",mesconsulta," AND municipios_ejecucion like '%",departamento,"%'",sep="")
  query<- paste(query,"&$order=", columna_municipio, sep="")
  
  secop_portal_url <- paste(portal_socrata,resource,sep="")
  request <- paste(secop_portal_url,query,sep="")
  df <- read.socrata(request)
  row.names(df)<- df$municipio_obtencion
  rownames(df)
  return(df)
}

#df1 = getSecopData(2017,1,departamento)

buildDS <- function(aini,afin) 
{
  outDF <- data.frame()
  for (ano in c(aini:afin)){
    for (mes in c(1:12)){
      #ano <- 2011
      #mes <- 1
      str<-paste("Obteniendo dataset para Año :",ano,", mes :",mes)
      print (str) 
      d1 <- getSecopData(ano,mes)
      
      d2 <- merge(d1, outDF, all = T)
      outDF <- d2
    }
  }
  return(outDF)
}

arcMuni <- arc.open(path=pathMunicipios)
d_sub <- arc.select(arcMuni, fields = "*", where_clause = paste("DPTO_DPTO_='",codigo_departamento,"'",sep=""))
element<- arc.data2sp(d_sub)

df <- buildDS(ano_inicial,ano_final)
df$muniUpper <- toupper(df$municipio_obtencion)
df$muniUpper <-gsub("Á","A",df$muniUpper)
df$muniUpper <-gsub("É","I",df$muniUpper)
df$muniUpper <-gsub("Í","E",df$muniUpper)
df$muniUpper <-gsub("Ó","O",df$muniUpper)
df$muniUpper <-gsub("Ú","U",df$muniUpper)


mp <- element@data
OutDF<- sqldf("select a.*, b.* from mp as a left join df as b on a.MPIO_CNMBR = b.muniUpper" )

row.names(OutDF) <- OutDF$MPIO_cNMBR
NumeroContratos <- select(OutDF,starts_with("MPIO_cNMBR","no_contratos"))
str(NumeroContratos)










element2 <- SpatialPolygonsDataFrame(element,OutDF,match.ID = FALSE)
#help("arc.sp2data")

#sx <- arc.sp2data(element2)

arc.write(salida,element2)






