# STM R
#
# Dans ce deuxieme lab, nous allons reprendre le corpus de l'est republicain mais avec le package STM en R.
#
# Meme dataset que pour le lab 01
#
# Pourquoi le package STM en R?
#
# http://www.structuraltopicmodel.com/
#
#     Facile à utiliser
#     Beaucoup de fonctionnalités: preparation du corpus, visualization, ...
#     Nombre de topics suggérés et analysable
#
# Le code R :
#
#     Chargement du dataset dans une dataframe
#     Nettoyage du code
#     Filtrage des mots en fonction de leur fréquence
#     STM / LDA
#     Résultats
#     Bonheur / Bliss
#

# set working directory
setwd("~/amcp/upem/UPEM-NUMI/lab02/notebooks/")

# Chargement des packages
source('initialize.R')

# initialisation des parametres de l'experience
source('config.R')


# ------------------------------------------------------------------------------
#  Load data
# ------------------------------------------------------------------------------
qqcat("Load data from @{s.input_file}")

# Chargement du corpus dans une dataframe
df <- read.csv(s.input_file, nrows = s.max_rows, col.names = c(s.text_feature))

# combien de rows
qqcat("dimensions:")
dim(df)

# Vérifier le contenu
qqcat(" 2 premiers paragraphes")
df$text[0:2]


# Pre processing
#
# Le package stm fait tout!
#
# processed contient
#
#     processed$documents la matrice mots -documents
#     processed$vocab la liste des mots
#
# Parametres
#
#     lowercase
#     removestopwords: utilise le snowball stemmer (meme que NLTK) cf: http://snowball.tartarus.org/algorithms/french/stop.txt
#     ajouter des mots avec customstopwords
#     stem: stemming transforme le mot en sa racine != lematization



# ------------------------------------------------------------------------------
# 1) pre process the text with basic NLP massaging
# ------------------------------------------------------------------------------
qqcat("pre processing\n")
processed <- textProcessor(df[,s.text_feature],
                           language         = "fr",
                           lowercase        = TRUE,
                           removestopwords  = TRUE,
                           customstopwords  = c('des'),
                           removenumbers    = TRUE,
                           removepunctuation = TRUE,
                           wordLengths      = c(s.min_wordlen,Inf),
                           striphtml        = TRUE,
                           stem             = FALSE,
                           verbose          = FALSE,
                           metadata         = df)
print(processed)


# Reduire le corpus
#
# Exclure les mots trop frequents ou pas assez avec lower.thresh et upper.thresh


out   <- prepDocuments(processed$documents,
                       processed$vocab,
                       processed$meta,
                       lower.thresh = s.thresh.lower,
                       upper.thresh = s.thresh.upper
                   )

docs  <- out$documents
vocab <- out$vocab
meta  <- out$meta


# Le topic model
#
# On peut specifier un nombre de topic comme avec Gensim
#
# Mais aussi laisser le modele trouver le nombre de topic optimal en donnant la valeur 0


qqcat("fit stm\n")

num_topics <- 0
fit <- stm(out$documents, out$vocab,
           num_topics,
           reportevery = 10,
           max.em.its  = 100,
           emtol       = 1.5e-4,
           init.type   = "Spectral",
           seed        = 1
       )

# Sauver l'environnement
qqcat("stm done\n")
if (s.save_envt){
  qqcat("saving to @{s.envt_filename}")
  save.image(s.envt_filename)
}


plot.STM(fit,type = "summary", labeltype= 'frex', main= 'Topic proportions', n = 10, xlim =c(0, 0.2))
