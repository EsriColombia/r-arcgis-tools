###################################
# SECOP explorer
# Herramienta de demostracion para explorar datos del SECOP en forma de mapas
# 
# Requisitos: Arcgis Pro y R Studio, R-arcgis-binding instalado en el ambiente de R
# 
# Autores:  
# Andres Felipe Riapira: ariapira@esri.co
# Andres Ignacio Baez: abaez@esri.co
#
##################################



tool_exec <- function(in_params, out_params){
  
  imprimir <- function(msg,per)
  {
    arc.progress_label(msg)
    arc.progress_pos(per)
    print (msg)
  }
  
  
  
  #####################################################################################################  
  ### 1.  Obtener variables de entorno del servicio de geoprocesamiento
  #####################################################################################################   
  env <- arc.env()
  workspace <- env$workspace
  cat(paste0("\n", "............................................", "\n"))
  cat(paste0("\n", "Current Workspace:", "\n"))
  print(workspace)
  
  print ("Cargando dependencias.")
  
  
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
  
  require("RSocrata")
  require("arcgisbinding")
  require("stringi")
  require("doBy")
  require("sp")
  require("sqldf")
  
  
  print ("Verificando Licencia de arcgis pro")
  arc.check_product()
  
  imprimir ("hecho",25)
  
  
  
  ###############################################################
  # 2. Checkeo de licencia de arcgis pro y captura de parametros
  ###############################################################
  
  
  ano_consulta  <- in_params[[1]]
  querybase <- in_params[[2]]
  salida <- out_params[[1]]
  
  imprimir (paste("Ano de consulta :",ano_consulta),26)
  imprimir (paste("Texto de Consulta",querybase),27)
  imprimir (paste("Feature Class de Salida",salida),28)
  
  
  if (is.null(querybase) ){
    querybase<-""
  }
  
  
  ###############################################################
  # 3. Definicion de constantes
  ###############################################################
  
  
  pathMunicipios <- "C:\\esri\\r-arcgis-tools\\colombia.gdb\\municipios"
  portal_socrata = "https://www.datos.gov.co"
  resource ="/resource/c6dm-udt9.json?"
  columna_municipio = "municipio_obtencion"
  
  
  imprimir ("Procesando",29)
  
  ###############################################################
  # 4. Elaboracion de las consultas
  ###############################################################
  
  
  query<- paste("$select=",columna_municipio,sep="")
  query<- paste(query,",sum(cuantia_contrato)&$group=",sep="")
  query<- paste(query,columna_municipio,sep="")
  query<- paste(query,"&$where=anno_firma_del_contrato='",sep="")
  query<- paste(query,ano_consulta,sep="")
  query<- paste(query,"'&$order=",sep="")
  query<- paste(query,columna_municipio,sep="")
  
  imprimir ("Elaborando Consulta",30)
  
  imprimir (typeof(querybase),31)
  
  if (querybase!="") {
    query <- paste(query,"&$q=",sep="")
    query <- paste(query,querybase,sep="")
  }
  
  
  
  imprimir("Consultando portal de datos abiertos",32)
  
  
  
  secop_portal_url <- paste(portal_socrata,resource,sep="")
  request <- paste(secop_portal_url,query,sep="")
  
  
  ###############################################################
  # 4. Cargue de datos al workspace
  ###############################################################
  
  
  df <- read.socrata(request)
  
  imprimir("Hecho",35)
  

  arcMuni <- arc.open(path=pathMunicipios)
  
  
  imprimir("Cargando Datos de Geodatabase Local",37)
  
  
  d_sub <- arc.select(arcMuni, fields = "*", where_clause = "1=1")
  element<- arc.data2sp(d_sub)
  
  imprimir ("Hecho",39)
  
  
  #rownames(element@data)
  
  #summary(element)
  
  #spplot(element)
  
  #x<-element$data.frame
  
  imprimir("Procesando Datos",50)
  
  
  df$muniUpper <- toupper(df$municipio_obtencion)
  df$muniUpper <-gsub("Á","A",df$muniUpper)
  df$muniUpper <-gsub("É","I",df$muniUpper)
  df$muniUpper <-gsub("Í","E",df$muniUpper)
  df$muniUpper <-gsub("Ó","O",df$muniUpper)
  df$muniUpper <-gsub("Ú","U",df$muniUpper)
  df$cuantia <- as.numeric(df$sum_cuantia_contrato)/1000000
  
  aggdata <- summaryBy(cuantia ~ muniUpper,data = df, FUN = sum)
  
  imprimir("Hecho",60)
  
  
  imprimir("Haciendo Join Espacial",62)
  
  
  mp <- element@data
  OutDF<- sqldf("select a.*, b.'cuantia.sum' as totalContratado from mp as a left join aggdata as b on a.MPIO_CNMBR = b.muniUpper" )
  
  imprimir("Hecho",68)
  
  imprimir("Creando feature de salida",69)
  
  
  element2 <- SpatialPolygonsDataFrame(element,OutDF,match.ID = FALSE)
  #help("arc.sp2data")
  
  imprimir("Hecho",80)
  
  imprimir("Escribiendo feature de salida",90)
  #sx <- arc.sp2data(element2)
  
  arc.write(salida,element2)
  
  imprimir("Hecho",100)
  
}