# ------------------------------------------------------------------------------
#  Packages
# ------------------------------------------------------------------------------

# Uncomment if not packages not yet installed
# install.packages( c("stm", "tm", "splines", "stmBrowser"), dependencies = TRUE)
# install.packages( c('wordcloud', 'igraph', 'data.table'), dependencies = TRUE)
# install.packages( c("stringr", "RColorBrewer", "stringr"), dependencies = TRUE)
# install.packages( c("geometry", "Rtsne", "GetoptLong"), dependencies = TRUE )

install.packages('igraph')
install.packages('stm')
install.packages('stmBrowser')


# charger les packages suivants
library('stringr')
library('wordcloud')
library('geometry')
library('Rtsne')
library('data.table')
library('SnowballC')
library('GetoptLong')

library('igraph')
library('stm')
library('stmBrowser')


# formatter le print
qq.options("cat_prefix" = function(x) format(Sys.time(), "\n[%H:%M:%S] "))
