# STM R: LAB 03

# ------------------------------------------------------------------------------
#  Initialization
# ------------------------------------------------------------------------------
# set working directory
# A CHANGER pour votre propre repertoire sur votre machine
LAB_PATH  <- '/Users/alexis/amcp/upem/UPEM-NUMI/lab03/'
setwd(LAB_PATH)

# Chargement des packages
library('stmBrowser')
library('stm')
library('stringr')
library('wordcloud')
library('geometry')
library('Rtsne')
library('SnowballC')
library('GetoptLong')

# formatter la façon dont le text est printé
qq.options("cat_prefix" = function(x) format(Sys.time(), "\n[%H:%M:%S] "))

# initialisation des parametres de l'experience
s.source_file   <- 'fbget_sample_05.csv'
s.data_path     <- qq("@{LAB_PATH}")
s.experiment    <- '01'
s.source        <- strsplit(s.source_file, "\\.")[[1]][1]

# Input File
s.input_file    <- qq("@{s.data_path}@{s.source_file}")

# Output Files
s.envt_filename <- qq("@{s.data_path}@{s.source}_@{s.experiment}.RData")

# ------------------------------------------------------------------------------
#  Load data
# ------------------------------------------------------------------------------
qqcat("Load data from @{s.input_file}")

# Chargement du corpus dans une dataframe
# s.max_rows <- 5000

# df <- read.csv(s.input_file)
# df <- read.csv(s.input_file, encoding="UTF-8", nrows = 500)

df <- read.csv(s.input_file, encoding="UTF-8")

# combien de rows
qqcat("dimensions:")
dim(df)

# Vérifier le contenu
qqcat(" 2 premiers paragraphes")
df$message_clean[0:2]

# ------------------------------------------------------------------------------
# 1) pre process the text with basic NLP massaging
# ------------------------------------------------------------------------------
qqcat("pre processing\n")
# enlever les rows vide
cond      <- (df[,'message_clean'] != '')
df        <- df[cond,]

processed <- textProcessor(df[,'message_clean'],
                           language         = "en",
                           lowercase        = TRUE,
                           removestopwords  = TRUE,
                           # customstopwords  = c('des'),
                           removenumbers    = FALSE,
                           removepunctuation = FALSE,
                           wordLengths      = c(3,Inf),
                           striphtml        = TRUE,
                           stem             = FALSE,
                           verbose          = FALSE,
                           metadata         = df)
print(processed)

# ------------------------------------------------------------------------------
# 2) Réduire le corpus
#   Exclure les mots trop frequents ou pas assez avec lower.thresh et upper.thresh
# ------------------------------------------------------------------------------

out   <- prepDocuments(processed$documents,
                       processed$vocab,
                       processed$meta,
                       lower.thresh = 20,
                       upper.thresh = Inf
                   )

docs  <- out$documents
vocab <- out$vocab
meta  <- out$meta

# ------------------------------------------------------------------------------
#  3) Topic modeling
# ------------------------------------------------------------------------------
# specifier  num_topics  ou laisser le modele trouver le nombre de topic optimal avec num_topics = 0

qqcat("fit stm\n")
num_topics <- 0
fit <- stm(out$documents, out$vocab,
           num_topics,
           prevalence  =~ log_klout ,
           data = meta,
           reportevery = 10,
           max.em.its  = 100,
           emtol       = 1.5e-4,
           init.type   = "Spectral",
           seed        = 1
       )

# ------------------------------------------------------------------------------
#  4) Exploration
# ------------------------------------------------------------------------------

# Plot les topics
plot.STM(fit,type = "summary", labeltype= 'frex', main= 'Topic proportions', n = 10, xlim =c(0, 0.2))
# ou
plot(fit, labeltype=c("frex"), main = 'Topic Most Frequent Words',bty="n")

# plot topics quality
topicQuality(model=fit, documents=docs, main='Topic Quality',bty="n")

# Quels mots pour tous les topics
print(labelTopics(fit, n=10))
# ou pour les topics 2 et 8
labelTopics(fit, n=10, c(2, 8))

# Word cloud sur topic 5
cloud(fit, 5)

# Quels sont les documents du topic 11
findThoughts(fit, texts = out$meta$note, topics = 11, n = 10 )

# which topic contains the keywords: obama, clinton
findTopic(fit,n = 20, c("obama", 'clinton'))

# find docs that have the most of topic 7
which(fit$theta[,7] > 0.60)


# what other topics are in doc number 123 ?
which(fit$theta[123,] > 0.1)

# Topic importance:
colSums( fit$theta)

# Influence du klout
stmBrowser(fit, data=out$meta, c('log_klout'), text="message", labeltype='frex')



# ------------------------------------------------------------------------------
#  Grid search
# ------------------------------------------------------------------------------
n_topics = seq(from = 10, to = 80, by = 2)

gridsearch <- searchK(out$documents, out$vocab,
                    K = n_topics,
                    reportevery = 10,
                    # emtol       = 1.0e-4,
                    data = meta)

plot(gridsearch)
print(gridsearch)

# Select the best number of topics that maximizes both exclusivity  and semantic coherence
plot(gridsearch$results$exclus, gridsearch$results$semcoh)
text(gridsearch$results$exclus, gridsearch$results$semcoh, labels=gridsearch$results$K, cex= 0.7, pos = 2)

plot(gridsearch$results$semcoh, gridsearch$results$exclus)
text(gridsearch$results$semcoh, gridsearch$results$exclus, labels=gridsearch$results$K, cex= 0.7, pos = 2)
