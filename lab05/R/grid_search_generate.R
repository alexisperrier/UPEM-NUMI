
source("initialize.R")
source("config/config.R")

input_file    <- qq("@{data_path}@{trial}.csv")
envt_filename <- qq("@{data_path}@{trial}.RData")

# ------------------------------------------------------------------------------
#  Load data, rm heldout
# ------------------------------------------------------------------------------
qqcat("Load data from @{input_file}")

df        <- read.csv(input_file)
cond      <- (df[,text_feature] != '')
df        <- df[cond,]
dim(df)

if (max_rows > 0){
  qqcat("limit to @{max_rows} docs")
  df        <- df[0:max_rows, ]
}

# ------------------------------------------------------------------------------
# 1) pre processed the text with basic NLP massaging
# content candidates: df$NoteContent df$ActivityDetails or combination df$text
# ------------------------------------------------------------------------------
qqcat("Token Count\n")

# print(summary(df[,  c('hillaryclinton', 'barackobama', 'donaldtrump') ]))

qqcat("pre processing\n")

processed <- textProcessor(df[,text_feature],
                           lowercase        = FALSE,
                           removestopwords  = FALSE,
                           removenumbers    = FALSE,
                           removepunctuation = FALSE,
                           wordLengths      = c(3,Inf),
                           striphtml        = FALSE,
                           stem             = FALSE,
                           metadata         = df)

out   <- prepDocuments(processed$documents,
                       processed$vocab,
                       processed$meta,
                       lower.thresh = thresh.lower)

docs  <- out$documents
vocab <- out$vocab
meta  <- out$meta


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


if (save_envt){
  qqcat("saving to @{envt_filename}")
  save.image(envt_filename)
}

# ------------------------------------------------------------------------------
#  STM
# check residuals
# checkBeta(stmobject, tolerance = 0.01): Looks for words that load exclusively onto a topic
# ------------------------------------------------------------------------------
qqcat("fit stm\n")
fit <- stm(out$documents, out$vocab, 0,
           data        = meta,
           reportevery = 10,
           # emtol       = 1.0e-4,
           init.type   = "Spectral",
           seed        = 1)

qqcat("stm done\n")
if (save_envt){
  qqcat("saving to @{envt_filename}")
  save.image(envt_filename)
}
