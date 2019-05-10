if(!requireNamespace("RSocrata", quietly = TRUE))
  install.packages("RSocrata", quiet = TRUE, dependencies = TRUE)  
library("RSocrata")


ReadIcfes <- function(cod_departamento,and_query)
{
query = paste("https://www.datos.gov.co/resource/3vte-z7tr.json?",
              "$select=cole_cod_mcpio_ubicacion,cole_mcpio_ubicacion,max(punt_global),min(punt_global),avg(punt_global),count(*) as N",
              "&$where=cole_cod_depto_ubicacion='",cod_departamento,"' ",and_query,
              "&$group=cole_cod_mcpio_ubicacion,cole_mcpio_ubicacion",
              sep="")

dfx <- read.socrata(query)
row.names(dfx)<-dfx$cole_cod_mcpio_ubicacion
return (dfx)
}


cod_departamento = "15"
and_query = ""

data1 <- ReadIcfes(cod_departamento,and_query)