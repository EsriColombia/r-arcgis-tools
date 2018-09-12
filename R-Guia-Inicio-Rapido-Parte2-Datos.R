##############################################################################################################
# R. Demo inicial de entrenamiento
# Autores: 
# Andres Felipe Riapira, ariapira@esri.co
# Andres Ignacio Báez Alba abaez@esri.co
# Nivel: Novato
# El propósito de este script es introducir rápidamente al lenguaje de programación R.
# No genera ningún tipo de producto final, solamente sirve para proposito educativo de entrenamiento
##############################################################################################################

##############################################################################################################
# Trabajar con los datos
##############################################################################################################

# Cargar datos desde la consola

consola <- scan()
consola
row.names(icfes)<-icfes$"cole_cod_mcpio_ubicacion"
rownames(icfes)

colnames(icfes)
icfes


#maximo promedio icfes
maximoIcfex<-(icfes$avg_punt_global)
maximo

municipios<- icfes$"avg_punt_global"
municipios
municipios[1]# Shows the first item in the vector.
municipios[3] #Shows the third item.
municipios[1:3] #Shows the first to the third items.
data1[-1] Shows all except the first item.
data1[c(1, 3, 4, 8)] Shows the items listed in the c() part.
data1[data1 > 3] Shows all items greater than 3.
data1[data1 < 5 | data1 > 7] Shows items less than 5 or greater than 7.

