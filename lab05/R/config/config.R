# ----------------------------------------------------------------------------
#  Data source created by the prepare.py script
# ----------------------------------------------------------------------------
s.source        <- 'fbget_stm_01'
s.experiment    <- '01'
# ----------------------------------------------------------------------------
#  Path and files
# ----------------------------------------------------------------------------
s.data_path     <- '/Users/alexis/amcp/memewar/data/'
s.img_path      <- '/Users/alexis/amcp/memewar/R/images/'
s.wd_path       <- '/Users/alexis/amcp/memewar/R'

# Input File
s.input_file    <- qq("@{s.data_path}@{s.source}.csv")

# Output Files
s.envt_filename <- qq("@{s.data_path}@{s.source}_@{s.experiment}.RData")
s.topic_file    <- qq("@{s.img_path}@{s.source}_@{s.experiment}.png")

# ----------------------------------------------------------------------------
#  Workflow, session and stm parameters
# ----------------------------------------------------------------------------

# Workflow: Save environment at the end (.Rdata files are not in git)
s.save_envt     <- TRUE

# Workflow: Perform grid search on number of topics
s.gridsearch    <- FALSE

# Session: Limit number of rows in dataframe. 0 for no limit.
s.max_rows      <- 0

# STM: Name of the content column in the input csv file
s.text_feature  <- 'sent_tokens'

# STM: Minimum / Maximum length of words to be included in the corpus
s.min_wordlen   <- 3
s.max_wordlen   <- Inf

# STM: lower.thresh: Words not in a number of documents > lower.thresh will be dropped.
s.thresh.lower  <- 50 # Words must be at least in 50 documents (0.6%)
# STM: upper.thresh: Words in at least this number of documents will be dropped.
s.thresh.upper  <- Inf
