###################################
# SECOP explorer
# Herramienta de demostracion para explorar datos del SECOP en forma de mapas
# 
# Requisitos: Arcgis Pro y R Studio, R-arcgis-binding instalado en el ambiente de R
# R-Mark-down
# Autores:  
#
# Andres Ignacio Baez: abaez@esri.co
#
##################################



tool_exec <- function(in_params, out_params){
  
  #####################################################################################################  
  ### 1.  Obtener variables de entorno del servicio de geoprocesamiento
  #####################################################################################################   
  
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
  if(!requireNamespace("spatialEco", quietly = TRUE))
    install.packages("spatialEco", quiet = TRUE, dependencies = TRUE)
  if(!requireNamespace("rmarkdown", quietly = TRUE))
    install.packages("rmarkdown", quiet = TRUE, dependencies = TRUE)
  if (!requireNamespace("knitr",quietly = TRUE))
    install.packages("knitr", quiet = TRUE, dependencies = TRUE)
  if (!requireNamespace("dplyr",quietly = TRUE))
    install.packages("dplyr", quiet = TRUE, dependencies = TRUE)
  if (!requireNamespace("reshape2",quietly = TRUE))
    install.packages("reshape2", quiet = TRUE, dependencies = TRUE)
  if (!requireNamespace("reshape",quietly = TRUE))
    install.packages("reshape", quiet = TRUE, dependencies = TRUE)
  if (!requireNamespace("ggplot2",quietly = TRUE))
    install.packages("ggplot2", quiet = TRUE, dependencies = TRUE)
  options(warn=-1)
  require("RSocrata")
  require("arcgisbinding")
  require("stringi")
  require("doBy")
  require("sp")
  require("sqldf")
  require("spatialEco")
  require("rmarkdown")
  require("knitr")
  require("dplyr")
  require("reshape2")
  require("reshape")
  require("ggplot2")
  print ("Verificando Licencia de arcgis pro")
  arc.check_product()
  
  imprimir <- function(msg,per)
  {
    arc.progress_label(msg)
    arc.progress_pos(per)
    print (msg)
  }
 
 
  imprimir ("Iniciando Geoproceso",1)
  
  
  ###############################################################
  # 2. Checkeo de licencia de arcgis pro y captura de parametros
  ###############################################################
  
  
  
  imprimir ("Cargando variables de entrada",2)
  querybase <- in_params[[1]]
  salida_shape <- out_params[[1]]
  salida_reporte <- out_params[[2]]
  
  
  imprimir (paste("Texto de Consulta",querybase),27)
  imprimir (paste("Feature Class de Salida",salida_shape),28)
  imprimir (paste("Reporte de Salida",salida_reporte),29)
  
  if (is.null(querybase) ){
    imprimir ("Fallo debido a texto de consulta",100)
    stop("Debe ingresar un texto de consulta")
  }
  
  
  ###############################################################
  # 3. Definicion de constantes
  ###############################################################
  imprimir (paste("Definiendo Constantes"),30)
  outputformathtml = "html_document"
  #outputformatpdf = "pdf_document"
  output_report_format = outputformathtml
  pathMunicipios <- "C:\\esri\\r-arcgis-tools\\datasets\\colombia.gdb\\deptos"
  pathReporte <- "c:\\esri\\r-arcgis-tools\\src\\ReportSecop.Rmd"
  portal_socrata = "https://www.datos.gov.co"
  resource ="/resource/c6dm-udt9.json?"
  columnas_interes <- list(c("identificacion_del_contratista",
                             "nom_raz_social_contratista",
                             "plazo_de_ejec_del_contrato",
                             "tiempo_adiciones_en_meses",
                             "anno_firma_del_contrato",
                             "dpto_y_muni_contratista",
                             "nombre_de_la_entidad",
                             "valor_contrato_con_adiciones",
                             "numero_de_proceso",
                             "numero_del_contrato",
                             "ruta_proceso_en_secop_i"))
  orderbycolumns <- list(c("anno_firma_del_contrato",
                           "valor_contrato_con_adiciones"))
  
  columnas <- stri_join_list(columnas_interes,sep=",")
  orderby <- stri_join_list(orderbycolumns,sep=",")
  
  columnas_rename <- list(c("ID",
                             "CONTRATISTA",
                             "PLAZO",
                             "ADICIONES",
                             "ANO",
                             "DEPARTAMENTO",
                             "ENTIDAD",
                             "VALOR",
                             "PROCESO",
                             "CONTRATO",
                             "URL"))
  
  
  ###############################################################
  # 4. Elaboracion de las consultas
  ###############################################################
  imprimir ("Cargando datos desde geodatabase local",33)
  arcMuni <- arc.open(path=pathMunicipios)
  d_sub <- arc.select(arcMuni, fields = "*", where_clause = "1=1")
  element<- arc.data2sp(d_sub)
  
  element@data$NOMBRE <- toupper(element@data$DPTO_CNMBR)
  element@data$NOMBRE <-gsub("Á","A",element@data$NOMBRE)
  element@data$NOMBRE <-gsub("É","E",element@data$NOMBRE)
  element@data$NOMBRE <-gsub("Í","I",element@data$NOMBRE)
  element@data$NOMBRE <-gsub("Ó","O",element@data$NOMBRE)
  element@data$NOMBRE <-gsub("Ú","U",element@data$NOMBRE)
  element@data$NOMBRE <-gsub("\\.","",element@data$NOMBRE)
  element@data$NOMBRE <-gsub(",","",element@data$NOMBRE)
  
  query<- paste("$select=",columnas,sep="")
  
  query <- paste(query,"&$q=",querybase,sep="")
  query<- paste(query,"&$order=",orderby,sep="")
  
  
  imprimir ("Hecho",33)

  
  ###############################################################
  # 4. Cargue de datos al workspace
  ###############################################################
  imprimir("Consultando portal de datos abiertos",42)
  secop_portal_url <- paste(portal_socrata,resource,sep="")
  request <- paste(secop_portal_url,query,sep="")
  df <- read.socrata(request)
  if (nrow(df)==0)
  {
    imprimir("No salio nada de la consulta de secop",100)
    stop("Debe ingresar un texto de consulta")
  }
  
  imprimir("Normalizando a millones",50)
  df_cp <- setNames(df, columnas_rename[[1]]) %>% mutate(VALOR = as.numeric(VALOR)/1000000)
  
  summary_year <- group_by(df_cp, ANO,DEPARTAMENTO) %>% 
                  summarize(TOTAL_CONT = sum(VALOR, na.rm=TRUE),
                            PROM = mean(VALOR, na.rm = TRUE),
                            MAX = max(VALOR, na.rm = TRUE),
                            MIN = min(VALOR, na.rm = TRUE))
  
  summary_tot <- select (summary_year,ANO:TOTAL_CONT)
  
  ano_ciudad <- cast(summary_tot , ANO~DEPARTAMENTO,value="TOTAL_CONT")
  
  ano_ciudad[is.na(ano_ciudad)] <- 0
  grafica_mun <- ggplot(summary_tot, aes(x=DEPARTAMENTO, y=TOTAL_CONT )) + geom_col(aes(fill = ANO), width = 0.7) + coord_flip() 
  imprimir("Construyendo Graficas de Salida",60)
  lista_graficas = c()
  for (i in 2:ncol(ano_ciudad))
  {
    imprimir (paste("Creando grafica en no ",i),62)
    subset <- ano_ciudad[,c(1,i)]
    depto <- colnames(subset)[2]
    label1 <- paste("Contratado en el depto de ",depto,sep="")
    colnames(subset)<-c('ano','valor')
    grafica_depto <- ggplot(subset, aes(x=ano, y = valor,  group=1)) + geom_point()  + geom_line()  + labs(title=label1)+ theme_minimal()
    lista_graficas <- c(lista_graficas,list(grafica_depto))
  }
  
  imprimir("Construyendo Join alfanumerico - espacial",70)
  
  ciudad_ano <- cast(summary_tot , DEPARTAMENTO~ANO,value="TOTAL_CONT")
  ciudad_ano[is.na(ciudad_ano)] <- 0
  ciudad_ano$DEPARTAMENTO <- toupper(ciudad_ano$DEPARTAMENTO)
  ciudad_ano$DEPARTAMENTO <-gsub("Á","A",ciudad_ano$DEPARTAMENTO)
  ciudad_ano$DEPARTAMENTO <-gsub("É","E",ciudad_ano$DEPARTAMENTO)
  ciudad_ano$DEPARTAMENTO <-gsub("Í","I",ciudad_ano$DEPARTAMENTO)
  ciudad_ano$DEPARTAMENTO <-gsub("Ó","O",ciudad_ano$DEPARTAMENTO)
  ciudad_ano$DEPARTAMENTO <-gsub("Ú","U",ciudad_ano$DEPARTAMENTO)
  ciudad_ano$DEPARTAMENTO <-gsub(",","",ciudad_ano$DEPARTAMENTO)
  ciudad_ano$DEPARTAMENTO <-gsub("\\.","",ciudad_ano$DEPARTAMENTO)
  

  
  
  
  
  imprimir("Haciendo Join Espacial",82)
  
  
  mp<- element@data
  
  OutDF<- sqldf("select a.*, b.* from mp as a left join ciudad_ano as b on a.NOMBRE = b.DEPARTAMENTO" )
  OutDF[is.na(OutDF)] <- 0
  
  
  
  imprimir("Creando feature de salida",83)
  
  element2 <- SpatialPolygonsDataFrame(element,OutDF,match.ID = FALSE)
  
  imprimir("Hecho",84)
  
  imprimir("Escribiendo feature de salida",85)
  #sx <- arc.sp2data(element2)
  parametros_reporte <- list(
    tabla_consulta = df_cp,
    texto_consulta = querybase, 
    tabla_resumen = summary_year,
    grafico_municipios = grafica_mun,
    graficas_individuales = lista_graficas
  )
  
  imprimir("Guardando feature class  de salida",86)
  arc.write(salida_shape,element2)
  
  imprimir("Construyendo reporte de salida",92)
  render(pathReporte, output_file = salida_reporte,
         params=parametros_reporte,
         output_format = output_report_format,encoding = "UTF-8" )
  

  
  imprimir("Hecho",100)
  
}


