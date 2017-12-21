import pandas as pd
import string
import time
import spacy
import enchant
import inflect
import json
from nltk.corpus import stopwords
from invariants import Invar

DATA_PATH = '/Users/alexis/amcp/memewar/data/'

class Session(object):

    def __init__(self, load_files =True):
        self.raw_file               = DATA_PATH + 'fbget_original_full_data_2016_and_2017.csv'
        self.tagged_file            = DATA_PATH + 'fbget_tagged.csv'
        self.stm_input_file         = DATA_PATH + 'fbget_stm.csv'
        self.acceptable_words_file  = DATA_PATH + 'entities/acceptable_words.txt'
        self.replaced_names_file    = DATA_PATH + 'entities/replaced_names.txt'

        self.nlp            = spacy.load('en')
        self.pinf           = inflect.engine()
        self.ench           = enchant.DictWithPWL("en_US", self.acceptable_words_file)

        self.stopwords = sorted(stopwords.words('english') + Invar.extra_stopwords())

        if load_files:

            with open( self.acceptable_words_file  ) as f:
                acceptable_words = f.readlines()
            self.acceptable_words = sorted(list(set([x.strip() for x in acceptable_words])))

            json_data=open(DATA_PATH + 'entities/tags.json')
            self.tags = json.load(json_data)
            json_data.close()

            json_data=open(DATA_PATH + 'entities/persons.json')
            self.persons = json.load(json_data)
            json_data.close()

            json_data=open(DATA_PATH + 'entities/lingo.json')
            self.lingo = json.load(json_data)
            json_data.close()

            json_data=open(DATA_PATH + 'entities/contractions.json')
            self.contractions = json.load(json_data)
            json_data.close()

class LoadData(object):
    @classmethod
    def load(cls, s, frac = None, nrows = None):
        print("\n== \tfrac: {0} \tnrows: {1}".format(frac, nrows) )
        start_time   = time.time()
        dtypes = {
            'from_id': str,     'media_id': str,
            'post_id': str,     'parent_id': str,
            'comment_id': str,  'cc_id': str,
            'place_id':str,     'place_zip':str,
            'tagged_id_list':str
        }

        if frac != None:
            df = pd.read_csv(s.raw_file, low_memory=False, dtype = dtypes ).sample(frac = frac)
        elif nrows != None:
            df = pd.read_csv(s.raw_file, low_memory=False, dtype = dtypes, nrows = nrows )

        df.dropna(axis=0, subset=['message'], inplace=True)
        drop_features= ['is_post_hidden', 'page', 'place_region', 'posting_application', 'tagged_type_list',
            'place_city', 'place_country', 'place_id', 'place_latitude', 'place_longitude',
            'place_name', 'place_state', 'place_street', 'place_zip']
        df.drop(drop_features, axis = 1, inplace = True)

        # Cast NaN as 0
        int_features = ['reaction_count','share_count','comment_count','is_post_published']
        for f in int_features:
            df[f].fillna(0, inplace = True)

        # Cast as str
        str_features = ['tagged_id_list', 'comment_id', 'post_id', 'from_id', 'cc_id', 'parent_id', 'media_id', 'action', 'event', 'tagged_name_list']
        for f in str_features:
            df[f].fillna('', inplace = True)

        # Extract post id from composite post_id
        df['pid'] = df.post_id.apply(lambda p :  p.split('_')[1])
        keep_columns = ['post_id', 'parent_id', 'comment_id', 'cc_id', 'from_id',
           'from_name', 'message', 'reaction_count', 'share_count',
           'comment_count', 'created_at', 'pid']
        df = df[keep_columns]

        print("Data {0} loaded in {1:.2f}s".format(df.shape, time.time() - start_time))
        return df
