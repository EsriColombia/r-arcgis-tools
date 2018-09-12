#######################################################################
# R. Demo inicial de entrenamiento, para familiarizarse con el 
#lenguaje de programación
# Autores: 
# Andres Felipe Riapira, ariapira@esri.co
# Andres Ignacio Báez Alba abaez@esri.co
# Nivel: Novato
# El propósito de este script es introducir rápidamente al lenguaje de programación R.
# No genera ningún tipo de producto final, solamente sirve para proposito educativo de entrenamiento
#######################################################################

################################################
# Seccion 1. Buscar ayuda
################################################
################################################
# Limpiar el workspace 
################################################
rm(list=ls())

################################################
# - Obtener toda la documentación disponible
################################################


help.start()

################################################
# - Obtener ayuda con respecto a una funcion 
################################################

help(lm)
?lm
help(mean)
help.search("Predictive")
??"hypothesis"
################################################
# - Obtener ayuda con respecto a los parámetros
################################################

args(mean)
args(lm)

################################################
# - Ejemplo del uso de una determinada función
################################################

example (mean)
example(lm)

################################################
# - Viñetas
################################################

vignette(package="sp")


################################################
# - Buscar en la web
################################################

RSiteSearch("stepwise")
RSiteSearch("olsrr")

################################################
# Seccion 2. Tipos básicos y funciones básicas
################################################

################################################
# - Imprimir algo
################################################

pi

sqrt(2)

print(pi)

print (sqrt(2))

print(matrix(c(1,2,3,4), 2, 2))

print(list("a","b","c"))


################################################
# - Establecer el directorio de trabajo
################################################

setwd("C:/ESRI/r-arcgis-tools")

getwd()


################################################
# OPERACIONES BÁSICAS
################################################

# Asignar a una variable.

x<-200
y<-3
n<-2
pi #The value of pi (??), which is approximately 3.142.
x^y #The value of x is raised to the power of y, that is, xy.
sqrt(x) #The square root of x.
abs(x) # The absolute value of x.
factorial(x)# The factorial of x.
log(x, base = n)# The logarithm of x using base = n (natural log if none specified).
log10(x)#pi The value of pi (??), which is approximately 3.142.
x^y #The value of x is raised to the power of y, that is, xy.
sqrt(x)#The square root of x.
abs(x)# The absolute value of x.
factorial(5) #The factorial of x.
log(x, base = n)# The logarithm of x using base = n (natural log if none specified).
log10(x)
log2(x)
#"Logarithms of x to the base of 10 or 2."
exp(x) #The exponent of x.
angle <- 45*(pi/180)

m <- cos(angle)
m
sin(angle)
tan(angle)
acos(m)*(180/pi)
asin(m)
atan(m)
log2(x)
#Logarithms of x to the base of 10 or 2.
exp(x) #The exponent of x.
atan(m)

################################################
# Combinar datos
################################################


data1 = c(3, 5, 7, 5, 3, 2, 6, 8, 5, 6, 9)

################################################
# Leer datos de csv 
################################################



icfes <- read.csv("icfes-boyaca-2017-2.csv")

#ver datos cargados en el workspace

ls()

ls(pattern="icf*")
  
#remover objetos del workspace

rm(m)
rm(x)




################################################
# Tipos de Datos y COnversiones
################################################

# Numeros, pueden ser de dos clases enteros y numerics

numero1 <- integer(12)
numero2 <- as.integer(12)

typeof(numero1)
typeof(numero2)

numero2 <- 12.33
# Conversion del tipo caracter a numero
numero3 <- as.numeric("112.222")
numero4 <- as.numeric("112,2")

typeof(numero2)
texto1 <- "Torta"
typeof(texto1)



# Factor, Converte un texto en un tipo de variable nominal

# variable gender with 20 "male" entries and 
# 30 "female" entries 
gender <- c(rep("male",20), rep("female", 30))
gender2 <- factor(gender) 
# stores gender as 20 1s and 30 2s and associates
# 1=female, 2=male internally (alphabetically)
# R now treats gender as a nominal variable 
summary(gender2)

#An ordered factor is used to represent an ordinal variable.




#Vectores

a <- c(1,2,5.3,6,-2,4) # numeric vector
b <- c("one","two","three") # character vector
c <- c(TRUE,TRUE,TRUE,FALSE,TRUE,FALSE) #logical vector


#Matrices 


y<-matrix(1:20, nrow=5,ncol=4)

# another example
cells <- c(1,26,24,68)
rnames <- c("R1", "R2")
cnames <- c("C1", "C2") 
mymatrix <- matrix(cells, nrow=2, ncol=2, byrow=TRUE,dimnames=list(rnames, cnames))

#Identificando Matrices
x<-matrix(1:20, nrow=5,ncol=4)
x[,4] # 4th column of matrix
x[3,] # 3rd row of matrix 
x[2:4,1:3] # rows 2,3,4 of columns 1,2,3

# Arreglos
# Arreglos son similares a las matrices, pero pueden tener mas de dos dimensiones

help(array)

help("data.frame")


#Listas


# ejemplo de una lista con varios componentes
# a string, a numeric vector, a matrix, and a scaler 
w <- list(name="Fred", mynumbers=a, mymatrix=x, age=5.3)

# example of a list containing two lists 
w

#Salvar el workspace a alguna parte:

save(file="c:/esritraining/democcu")

#cargardatos

load(file="c:/esritraining/democcu")

dir()

archivito <- file.choose()

