setwd("~/amcp/upem/muni/R")
source("initialize.R")
source("config/config.R")

# ------------------------------------------------------------------------------
#  Load data
# ------------------------------------------------------------------------------
qqcat("Load data from @{s.input_file}")

df        <- read.csv(s.input_file)
# Remove rows with no content (just a precaution, prepare.py should have taken care of that)
df        <- df[(df[,s.text_feature] != ''),]
dim(df)

if (s.max_rows > 0){
  qqcat("limit to @{s.max_rows} docs\n")
  df        <- df[0:s.max_rows, ]
  dim(df)
}

# ------------------------------------------------------------------------------
# 1) pre processed the text with basic NLP massaging
# content candidates: df$NoteContent df$ActivityDetails or combination df$text
# ------------------------------------------------------------------------------
qqcat("Token Count\n")

qqcat("pre processing\n")
# df_samp        <- df[0:5000, ]

processed <- textProcessor(df[,s.text_feature],
                           lowercase        = TRUE,
                           removestopwords  = TRUE,
                           removenumbers    = TRUE,
                           removepunctuation = TRUE,
                           wordLengths      = c(s.min_wordlen,Inf),
                           striphtml        = TRUE,
                           stem             = FALSE,
                           metadata         = df)
print(processed)

if (TRUE){
    out   <- prepDocuments(processed$documents,
                           processed$vocab,
                           processed$meta,
                           lower.thresh = s.thresh.lower,
                           upper.thresh = s.thresh.upper
                       )

    docs  <- out$documents
    vocab <- out$vocab
    meta  <- out$meta
}
# ----------------------------------------------------------------------------
#  External variables
#  Too many values will slow down STM
# ----------------------------------------------------------------------------

# set external variable as factor. Too many
# meta$log_days    <- as.factor(meta$log_days)

# ----------------------------------------------------------------------------
#  STM (documents, vocabulary, n_topics, ...)
#
# check residuals
# checkBeta(stmobject, tolerance = 0.01): Looks for words that load exclusively onto a topic
# ----------------------------------------------------------------------------
if (TRUE){
    qqcat("fit stm\n")
    fit <- stm(out$documents, out$vocab, 0,
               # prevalence  =~ cat_america ,
               # prevalence  =~ cat_america + cat_donaldtrump,
               # data        = meta,
               reportevery = 10,
               # max.em.its  = 100,
               emtol       = 1.5e-4,
               init.type   = "Spectral",
               seed        = 1
           )

    qqcat("stm done\n")
    if (save_envt){
      qqcat("saving to @{s.envt_filename}")
      save.image(s.envt_filename)
    }
}
# ----------------------------------------------------------------------------
#  Exploration
# ----------------------------------------------------------------------------
if (FALSE){
    labelTopics(fit, n=10, c(28, 48))
    print(labelTopics(fit, n=10))

    png(s.topic_file, width = 800, height = 1200)
    par(mar=c(2,0.5,1,10))
    plot.STM(fit,type = "summary", labeltype= 'frex', main= 'Topic proportions', n = 10, xlim =c(0, 0.2))
    dev.off()

    #
    topicQuality(model=fit, documents=docs, main='Topic Quality',bty="n")
    #
    plot(fit, labeltype=c("frex"), main = 'Topic Most Frequent Words',bty="n")
    #
    # plotModels(fit, main='Model Selection - Best Likelihood')
    #
    stmBrowser(fit, data=out$meta, c('cat_america', 'cat_donaldtrump'), text="message", labeltype='frex')

    cloud(fit, 24)

    # which documents are the mst representative of a topic
    findThoughts(fit, texts = out$meta$note, topics = 11, n = 10 )

    # which topic contains the keywords
    findTopic(fit,n = 20, c("email"))


    # topic = 50
    # topic = 38 putin, russia, russian, russians, hacker, hack, nato, alqueda, nuclear, war

    labelTopics(fit, n=10, 38)
    # find docs that have the most topic 50
    which(fit$theta[,38] > 0.60)


    # doc 1709
    # doc 1855
    print(out$meta$display_message[95])

    # what other topics are in doc 1855 ?
    which(fit$theta[1709,] > 0.1)

    # Topc importance:
    colSums( fit$theta)

    # how many docs with t=24 as main topic
    which(fit$theta[,1] > 0.5)
}
# ----------------------------------------------------------------------------
# Save results
# ----------------------------------------------------------------------------

# fit$theta: document x topic matrix
# write.csv( fit$theta , file ='../data/theta_01.csv')

# document PIDS
# write.csv( out$meta$pid , file ='../data/pids_64.csv')

# Topics, frex,  with n words
# write.csv( labelTopics(fit, n=20)$frex, file = '../data/topics_64.csv')
