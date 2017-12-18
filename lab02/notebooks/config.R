# ----------------------------------------------------------------------------
#  Data source created by the prepare.py script
# ----------------------------------------------------------------------------
s.source_file   <- 'estrepublicain_annee_1999.csv'
s.experiment    <- '01'
s.source        <- strsplit(s.source_file, "\\.")[[1]][1]
# ----------------------------------------------------------------------------
#  Path and files
# ----------------------------------------------------------------------------
LAB_PATH        <- '/Users/alexis/amcp/upem/UPEM-NUMI/lab02/'
s.data_path     <- qq("@{LAB_PATH}data/")
s.img_path      <- qq("@{LAB_PATH}images/")
s.wd_path       <- qq("@{LAB_PATH}notebooks/")

# Input File
s.input_file    <- qq("@{s.data_path}@{s.source}.csv")

# Output Files
s.envt_filename <- qq("@{s.data_path}@{s.source}_@{s.experiment}.RData")
s.topic_file    <- qq("@{s.img_path}@{s.source}_@{s.experiment}.png")

# ----------------------------------------------------------------------------
#  Workflow, session and stm parameters
# ----------------------------------------------------------------------------

# Workflow: Save environment at the end (.Rdata files are not in git)
s.save_envt     <- FALSE

# Workflow: Perform grid search on number of topics
s.gridsearch    <- FALSE

# Session: Limit number of rows in dataframe. 0 for no limit.
s.max_rows      <- 10000

# STM: Name of the content column in the input csv file
s.text_feature  <- 'text'

# STM: Minimum / Maximum length of words to be included in the corpus
s.min_wordlen   <- 3        # remove words shorter than 3 characters
s.max_wordlen   <- Inf      # no limit

# STM: lower.thresh: Words not in a number of documents > lower.thresh will be dropped.
s.thresh.lower  <- 20       # Words must be at least in N documents

# STM: upper.thresh: Words in at least this number of documents will be dropped.
s.thresh.upper  <- Inf      # No limit

qqcat("Config loaded: \n\texperiment: @{s.experiment}\n\ton source: @{s.source_file} \n")
