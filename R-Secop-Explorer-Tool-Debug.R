##############################################################################################################
# R. Demo inicial de entrenamiento
# Autores: 
# Andres Felipe Riapira, ariapira@esri.co
# Andres Ignacio Báez Alba abaez@esri.co
# Nivel: Newbie
##############################################################################################################
##############################################################################################################
# Trabajar con los datos
##############################################################################################################

rm(list=ls())


entrada = c(c(2013,'80849753'))
workspace = "c:\\esri\\secop"
salida = c(c("C:\\Esri\\salidanacho.shp"))


tool_exec(entrada,salida)

in_params = entrada
out_params= salida