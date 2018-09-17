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
rm(list=ls())
# Cargar datos desde la consola

consola <- scan()
consola

# Leer fichero de prueba
setwd("C:/ESRI/r-arcgis-tools")
icfes <- read.csv("icfes-boyaca-2017-2.csv")


row.names(icfes)<-icfes$"cole_cod_mcpio_ubicacion"
rownames(icfes)

colnames(icfes)
icfes




prommunicipios<- icfes$"avg_punt_global"
prommunicipios
prommunicipios[1]# Primer item en el vector.
prommunicipios[3] #Tercer item en el vector.
prommunicipios[1:3] #Items del primero al tercero
prommunicipios[-1] #Todos los elementos menos el primero
prommunicipios[c(1, 3, 4, 8)] #Muestra los items que están en el arreglo
prommunicipios[prommunicipios > 270] #Todos los puntajes por encima de 270.
prommunicipios[prommunicipios < 290 | prommunicipios > 270] #Los puntajes mayores a 270 y menores a 290


max(prommunicipios)


which(icfes$avg_punt_global == max(prommunicipios))


#Extraer secuencia, util para extraer valores de un vector a intervalos regulares
#seq(start, end, interval)

dx0 <- prommunicipios[seq(1, length(prommunicipios),2)]

sort(prommunicipios, decreasing=TRUE)

# Position en el vector en orden ascendente 

rank (prommunicipios)

#Posicion de los elementos de acuerdo a su valor, en que posicion está el elemento mas chico al 
#mas grande
order (prommunicipios)
min(prommunicipios)



#Municipio de soata

icfes["15753",]


row.names(icfes)


#Descripcion rápida de los datos
summary(icfes)

#Transponer dataframe o matriz

t(icfes)

#######################################
# Estadística descriptiva
#######################################

max(icfes$avg_punt_global)

min(prommunicipios, na.rm = FALSE) #Shows the minimum value in a vector. If there are NA values, this returns a value of NA unless na.rm = TRUE is used.
length(prommunicipios)# Gives the length of the vector and includes any NA values. The na.rm = instruction does not work with this command.
sum(prommunicipios, na.rm = FALSE) #Shows the sum of the vector elements.
mean(prommunicipios, na.rm = FALSE) #Shows the arithmetic mean.
median( prommunicipios, na.rm = FALSE) #Shows the median value of the vector.
sd(prommunicipios, na.rm = FALSE) #Shows the standard deviation.
var(prommunicipios, na.rm = FALSE) #Shows the variance.
mad(prommunicipios, na.rm = FALSE) #Shows the median absolute deviation.
