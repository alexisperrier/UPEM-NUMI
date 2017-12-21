'''
This script takes the raw data (420k rows), cleans it, flags it
and prepares it to be used as input for a topic model analysis.

The process is based on the following classes (in utils.py and session.py):

* Transform: defines all the transformations applied to a given text
* StmPrep: groups the messages by thread and concatenates the tokens
    as input corpus to a topic modeling analysis
* Categorize: given predefined categories and associated keywords,
    tags each message that include the keywords
* Entities: Creates json files with the required dictionnaries (entities, words, ...)
* Vocabularies: couple of methods to check if a word is acceptable and add plural
* LoadData: loads the documents form the raw file (fbget_original_full_data.csv)
* Session: initialize all filenames, loads spacy, enchant, inflect, stopwords, ...

Phase 1: clean up and tag:

    * loads the data from s.raw_file ()
    * Transforms and tags the raw data: lingo, apostrophes, contractions,
      remove urls, word unification with regex, possessive case, id important names
    * replaces names of participants with string: 'person_name'
    * flags the messages with category defined in s.tags
    * saves to s.tagged_file

Phase 2: topic modeling preparation

    * groups messages by thread
    * removes punctuation
    * lemmatization and tokenization
    * remove stopwords and non English words (pyEnchant)
    * sent_tokens: concatenates the tokens in a sentence (neccesary for topic models)
    * filters out documents that are too short (< 10 tokens) or too long (> 1500 )
    * creates log_days (0 to 10) and log_klout (1 to 8) features to be used as external variables
    * saves dataframe to s.stm_input_file

Input / Setup
-------

In session.py, set the path to the data in DATA_PATH and the name of the original
raw data file (fbget_original_full_data_2016_and_2017.csv). Also set the filenames of the
tagged data file (fbget_tagged.csv) and the final file ready for topic modeling:
(fbget_stm.csv).

Returns
-------
Saves the data in 2 files:

* Phase 1: s.tagged_file: 'fbget_tagged.csv'
* Phase 2: s.stm_input_file: 'fbget_stm.csv'

'''
import pandas as pd
import numpy as np
import string
import enchant

import csv
import re
import json
import time

from string import digits
from collections import Counter
from datetime import datetime as dt

import spacy
import inflect

from session import *
from utils import *

if __name__ == '__main__':

    start_time  = time.time()

    # -----------------------------------------------------------------------
    #  Phase 1: Load data, clean up, categorize
    # -----------------------------------------------------------------------
    s   = Session()
    df  = LoadData.load(s, frac  =1)
    M   = Transform.process(df.message, s)
    print("Data cleaned up in {0:.2f}s".format(time.time() - start_time))

    M.replace_names(s)
    df['message_'] = M.items
    print("Names replaced: {0:.2f}s".format(time.time() - start_time))

    # Flag with categories
    flagged = Categorize.categorize(M.items, s)
    df = df.merge(flagged, left_index= True, right_index = True)
    print("Categories flagged: {0:.2f}s".format(time.time() - start_time))

    # Save
    df.to_csv(s.tagged_file)

    print("== Phase 1: clean up and tagged done in {0:.2f}s".format(time.time() - start_time))

    # -----------------------------------------------------------------------
    #  Phase 2: Topic modeling preparation: aggregate comments by thread,
    #           create external variables, drops cols, and creates sent_tokens
    # -----------------------------------------------------------------------
    start_time  = time.time()
    df = df[df.message_ != 'person_name']
    print("df: {}".format(df.shape))

    df = df.groupby('pid').apply(lambda d : StmPrep.join_and_sum(d, flagged.columns))
    df.reset_index(inplace = True)
    print('Tokenization')
    M  = StmPrep.process(df.message_, s)

    df['tokens'] = M.items.values

    df['token_count'] = df.tokens.apply(lambda t : len(t))

    print("df: {}".format(df.shape))
    df['sent_tokens'] = df.tokens.apply( ' '.join)

    df = df[ (df.token_count > 10  )   & (df.token_count < 1500) ]
    print("keep tokens between [10, 1000] df: {}".format(df.shape))

    df.drop_duplicates(subset = 'sent_tokens', inplace = True)

    # Klout
    df['klout'] = df[['reaction_count', 'comment_count', 'share_count']].apply(lambda d : sum(d), axis =1)
    df['log_klout']      = round(np.log(df.klout+1), 0)

    df['days']          = df.apply(lambda d: int((dt.strptime(d.finished_at, '%Y-%m-%d %H:%M:%S').date() - dt.strptime(d.started_at, '%Y-%m-%d %H:%M:%S').date()).days), axis = 1)
    df['created_at']    = df.started_at.apply(lambda d: d.split(' ')[0]  )
    df['log_days']      = round(np.log(df.days+1), 0)

    df.drop(['message_', 'tokens'], inplace = True, axis=1)

    df.to_csv(s.stm_input_file, index=False)
    print("df: {}".format(df.shape))
    print("== Phase 2: STM Preparation in {0:.2f}s".format(time.time() - start_time))
