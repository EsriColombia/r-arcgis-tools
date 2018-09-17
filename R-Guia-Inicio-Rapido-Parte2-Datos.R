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




prommunicipios<- icfes$avg_punt_global
head(prommunicipios)
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



#Acumulativos
cumsum(prommunicipios) #The cumulative sum of a vector
cummax(prommunicipios) #The cumulative maximum value
cummin(prommunicipios) #The cumulative minimum value
cumprod(prommunicipios) #The cumulative product

##################################################
# Estadística descriptiva aplicada al dataframe
##################################################

resumen<-icfes[,c(1,4,5)]

rowMeans(resumen)

#Tabla de contingencia
table(resumen)




rowSums(resumen) # Calcula la suma por fila 
colSums(resumen) # Calcula la suma por columna

rowMeans(resumen) # Calcula la media por fila

colMeans(resumen) # Calcula la media por columna

#rm(resumenClas)
resumenClas <- resumen
resumenClas$clase = NA

determinarClase <- function(row)
{
  clase<-0
  promedio <- row[1]
  maximo <- row[2]
  minimo <- row[3]
  
  
  if (minimo>200 && promedio > 260 && maximo > 300)
  {
    clase <- 5
  }
  else if (minimo>180 && promedio > 250 && maximo > 290)
  {
    clase <- 4
  }
  else if (minimo>160 && promedio > 240 && maximo > 280)
  {
    clase <- 3
  }
  else if (minimo>150 && promedio > 220 && maximo > 260)
  {
    clase <- 2
  }
  else if (minimo>130 && promedio > 210 && maximo > 230)
  {
    clase <- 1
  }
  return(clase)
}

summary(resumen)
help(apply)
resumenClas$clase <- apply(resumenClas,1,determinarClase ) #Applies a function to rows or columns of a data frame, matrix, or
head(resumenClas)


prommunicipios <- as.integer(prommunicipios)

stem(prommunicipios,scale=6)
hist(prommunicipios)
hist(prommunicipios, breaks = 'FD')
hist(prommunicipios, breaks = 'Sturges')
hist(prommunicipios, breaks = 'Scott')
hist(prommunicipios, breaks = 'FD')
colors()
colours()
hist(prommunicipios, breaks = 'FD')
dens <- density(prommunicipios)

dens

plot(dens$x, dens$y)
lines(dens, lty = 2)


shapiro.test(prommunicipios)



######################################################################
# Crear datos aleatorios que cumplan con una determinada distribucion
######################################################################

datosNormales = rnorm(1200, mean = 250, sd = 1)
densd2 <- density(datosNormales)
plot(densd2$x,densd2$y)

hist(datosNormales)

######################################################################
# Otras distribuciones
######################################################################

#dbeta beta
#dbinom binomial (including Bernoulli)
#dcauchy Cauchy
#dchisq chi-squared
#dexp exponential
#df F distribution
#dgamma gamma
#dgeom geometric (special case of negative binomial)
#dhyper hypergeometric
#dlnorm log-normal
#dmultinom multinomial
#continues

 
datosCauchy
datosCauchy = dcauchy(0:200,location = 250,scale=1,log=FALSE)
hist(datosCauchy)

plot(density(datosCauchy))



# The Kolmogorov-Smirnov Test
# Permite comparar dos distribuciones, esto significa que se pude comparar una muestra de una distribución conocida
# o comporar dos distribuciones desconocidas para verificar si son o no las mismas. 
# Significancia estadística. La decisión se toma a menudo utilizando el valor p (o p-valor): si el valor p es inferior
# al nivel de significación, entonces la hipótesis nula es rechazada. Cuanto menor sea el valor p, más significativo será el resultado


ks.test(sort(prommunicipios), datosNormales)
ks.test(sort(prommunicipios), datosNormales)

# Si p-valor ??? ?? ??? Aceptar H0  contrario rechazar
# Si p-valor z


qqnorm(prommunicipios)
qqline(prommunicipios, lwd = 2, lty = 2)


########################################################################################################
# Prueba de Hipótesis
######################################################################################################## 






########################################################################################################
# Gráficos
######################################################################################################## 


boxplot(icfes$max_punt_global,icfes$avg_punt_global,icfes$min_punt_global, names= c("maximo", "promedio", "minimo"))



