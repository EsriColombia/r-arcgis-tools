##############################################################################################################
# R. Demo inicial de entrenamiento
# Autores: 
# Andres Felipe Riapira, ariapira@esri.co
# Andres Ignacio Báez Alba abaez@esri.co
# Nivel: Novato
# El propósito de este script es introducir rápidamente al lenguaje de programación R.
# No genera ningún tipo de producto final, solamente sirve para proposito educativo de entrenamiento
# 
#
# Este demo tiene la regionalización del tutorial r-arcgis-bridge 
# Léase https://learn.arcgis.com/es/projects/analyze-crime-using-statistics-and-the-r-arcgis-bridge/lessons/install-the-r-arcgis-bridge-and-start-statistical-analysis.htm
# Contiene un dataset de ejemplo que tiene los resultados de aplicar los geoprocesos.
##############################################################################################################

rm(list=ls())
#install.packages("import")
#install.packages("ggplot2")
#install.packages("sp")
#install.packages("spdep")
#install.packages("reshape2")
#install.packages("ggmap")
library (reshape2)
library (ggplot2)
library (ggmap)
library(arcgisbinding)
library(sp)
library(spdep)
library(dplyr)
arc.check_product()




# Get lower triangle of the correlation matrix
get_lower_tri<-function(cormat) {
  cormat[upper.tri(cormat)] <- NA
  return(cormat)
}
#
# Get upper triangle of the correlation matrix
get_upper_tri <- function(cormat) {
  cormat[lower.tri(cormat)] <- NA
  return(cormat)
}
#
reorder_cormat <- function(cormat) {
  # Use correlation between variables as distance
  dd <- as.dist((1-cormat) / 2)
  hc <- hclust(dd)
  cormat <- cormat [hc$order, hc$order]
}






pathds <- "c:\\ESRI\\r-arcgis-tools\\seguridad.gdb\\hotspothomicidiosenriquecido"
pathdssuavizado <- "c:\\ESRI\\r-arcgis-tools\\seguridad.gdb\\hotspothomicidiosenriquecidosuave"

enrichdf <- arc.open(path=pathds)
columnasDS <-  c('OBJECTID',
  'SUM_VALUE',
  'TOTPOP',
  'TOTHH',
  'AVGHHSZ',
  'TOTMALES',
  'TOTFEMALES',
  'PAGE01_CY',
  'PAGE02_CY',
  'PAGE03_CY',
  'PAGE04_CY',
  'PAGE05_CY',
  'CS01_CY',
  'CS02_CY',
  'CS03_CY',
  'CSPC10_CY',
  'CS13_CY',
  'PP_CY',
  'PPPC_CY')
enrich_select_df <- arc.select(object = enrichdf, fields = columnasDS )


enrich_spdf <- arc.data2sp(enrich_select_df)

colnames(enrich_spdf@data) <- columnasDS

colnames(enrich_spdf@data)

filtrado <- filter(enrich_spdf@data,TOTPOP>0)

head(enrich_spdf@data)



n <- filtrado$SUM_VALUE
x <- filtrado$TOTPOP
EB <- EBest (n, x)
p <- EB$raw
b <- attr(EB, "parameters")$b
a <- attr(EB, "parameters")$a
v <- a + (b/x)
v[v < 0] <- b/x
z <- (p - b)/sqrt(v)


newds <- filtrado
newds$EB_Rate <- z


enrich_spdf@data <- newds

arcgis_df <- arc.sp2data(enrich_spdf)

arc.write(pathdssuavizado,arcgis_df)

analysisColumns = c('PAGE01_CY',
'PAGE02_CY',
'PAGE03_CY',
'PAGE04_CY',
'PAGE05_CY',
'CS01_CY',
'CS02_CY',
'CS03_CY',
'CSPC10_CY',
'CS13_CY',
'PP_CY',
'PPPC_CY',
"EB_Rate")


corr_sub <- newds [ analysisColumns]
cormax <- round (cor(corr_sub), 2)
upper_tri <- get_upper_tri (cormax)
melted_cormax <- melt (upper_tri, na.rm = TRUE)
cormax <- reorder_cormat (cormax)
upper_tri <- get_upper_tri (cormax)
melted_cormax <- melt (upper_tri, na.rm = TRUE)
ggheatmap <- ggplot (melted_cormax, aes (Var2, Var1, fill = value)) +
  geom_tile(color = "white") +
  scale_fill_gradient2 (low = "blue", high = "red", mid = "white", midpoint = 0, limit = c(-1,1), space = "Lab", name = "Pearson\nCorrelation") +
  theme_minimal() + # minimal theme
  theme (axis.text.x = element_text(angle = 45, vjust = 1, size = 12, hjust = 1)) +
  coord_fixed()
print (ggheatmap)
ggheatmap +
  geom_text (aes (Var2, Var1, label = value), color = "black", size = 4) +
  theme (
    axis.title.x = element_blank(),
    axis.title.y = element_blank(),
    panel.grid.major = element_blank(),
    panel.border = element_blank(),
    axis.ticks = element_blank(),
    legend.justification = c (1, 0),
    legend.position = c (0.6, 0.7),
    legend.direction = "horizontal") +
  guides (fill = guide_colorbar (barwidth = 7, barheight = 1, title.position = "top", title.hjust = 0.5))








