import pandas as pd
import numpy as np
import string
import time
import csv
import re
import json
from session import *
from string import digits

from invariants import Invar

DATA_PATH = '/Users/alexis/amcp/memewar/data/'

class Categorize(object):

    @classmethod
    def categorize(cls,items, s):
        category_columns = []
        for key,words in s.tags.items():
            category_columns.append('cat_'+ key.lower().replace(' ','_'))

        flagged = pd.DataFrame(columns = category_columns)

        for key,words in s.tags.items():
            cat_column = 'cat_' + key.lower().replace(' ','_')
            pattern = re.compile(r'\b(' + '|'.join( words ) + r')\b', re.IGNORECASE)
            tagit = lambda m : 1 if pattern.search(m) else 0
            flagged[cat_column] = items.apply(lambda m : tagit(m))
        return flagged

class StmPrep(object):


    @classmethod
    def sentencify(cls, d):
        mergedlist = []
        for key in d.keys():
            mergedlist.extend( list(d[key]) )
        return ' '.join(mergedlist)



    @classmethod
    def process(cls, items, s):
        M = Transform(items, s)
        M.punctuation()
        M.items = M.items.apply(lambda m : Transform.lemmatize(m,s))
        M.stopwords(s)
        M.filter_english(s)
        return M


    @classmethod
    def join_and_sum(cls,x, category_columns):
        d = {
            'reaction_count'    : x['reaction_count'].sum(),
            'share_count'       : x['share_count'].sum(),
            'comment_count'     : x['comment_count'].sum(),
            'message'           : '.\n\r\t '.join(x['message']),
            'message_'     : '. '.join(x['message_']),
            'started_at'        : np.min(x.created_at),
            'finished_at'       : np.max(x.created_at),
        }
        for key in category_columns:
            d[key] = x[key].sum()

        return pd.Series(d)


class Transform(object):

    @classmethod
    def process(cls, items, s):
        M = Transform(items, s)
        M.lingo(s)
        M.apostrophe(s)
        M.contractions(s)
        M.remove_url(s)
        M.regex_replace(s)
        M.possessive(s)
        M.vip_persons(s)
        return M

    @classmethod
    def lemmatize(cls,text,s):
        doc = s.nlp(text)
        return [ token.lemma_.strip() for token in doc  ]

    def __init__(self,items, s):
        self.items = items

    def filter_english(self,s):
        self.items = self.items.apply(lambda tk : [w for w in tk if Vocabularies.existing_word(s.ench,w) ] )

    def stopwords(self,s):
        self.items = self.items.apply(lambda tk : [w.strip() for w in tk if (w not in s.stopwords) & (len(w) > 2) ] )

    def punctuation(self):
        punctuation_chars = ''.join([s for s in string.punctuation if s !='_'  ]) + "\x08" + '\r\n“”…’' + digits
        translator_chars  = str.maketrans(' ', ' ', punctuation_chars)
        self.items = self.items.apply(lambda s : s.translate(translator_chars))

    def lingo(self, s):
        pattern = re.compile(r'\b(' + '|'.join(s.lingo.keys()) + r')\b', re.IGNORECASE)
        self.items = self.items.apply(lambda t : pattern.sub(lambda x: s.lingo[x.group().lower()], t) )

    def apostrophe(self, s):
        translate_apostrophe = str.maketrans('’', "'") # ’ => '
        self.items = self.items.apply(lambda t : t.translate(translate_apostrophe))

    def contractions(self, s):
        pattern = re.compile(r'\b(' + '|'.join(s.contractions.keys()) + r')\b', re.IGNORECASE)
        self.items = self.items.apply(lambda t : pattern.sub(lambda x: s.contractions[x.group().lower()], t) )

    def regex_replace(self, s):
        for rgx in Invar.regex_translate().items():
            p = re.compile(rgx[0], re.IGNORECASE)
            self.items = self.items.apply(lambda t : p.sub(rgx[1], t) )

    def possessive(self, s):
        self.items = self.items.apply(lambda t : t.replace("'s",'') )

    def remove_url(self, s):
        url_pattern = re.compile(r'(http|ftp|https)://([\w_-]+(?:(?:\.[\w_-]+)+))([\w.,@?^=%&:/~+#-]*[\w@?^=%&/~+#-])?', re.IGNORECASE)
        self.items =  self.items.apply(lambda t :  url_pattern.sub('url', t))

    def vip_persons(self,s):
        for key,words in s.persons.items():
            tag =  key.lower().replace(' ','_')
            pattern = re.compile(r'\b(' + '|'.join( words ) + r')\b', re.IGNORECASE)
            self.items =  self.items.apply(lambda t :  pattern.sub(key, t))

    def replace_names(self,s):
        acceptables = sorted(list(set(list(s.tags.keys()) + list(s.persons.keys()) + list(s.acceptable_words))))
        replaced_names = []
        for i,m in self.items.items():
            doc = s.nlp(m)
            if len(doc.ents) > 0:
                for ent in doc.ents:
                    if (ent.label_ == 'PERSON') & ( ent.text not in  acceptables  ):
                        replaced_names.append(ent.text)
                        self.items[i] = m.replace(ent.text,'person_name')
        replaced_names = sorted(list(set(replaced_names)))
        print("{0} names saved to {1}".format(len(replaced_names), s.replaced_names_file))
        open(s.replaced_names_file, 'w').write("\n".join( replaced_names ))


class Vocabularies(object):
    '''
    Reads the dictionaries in Invariants
    and creates JSON files
    '''
    @classmethod
    def existing_word(cls, ench, tk):
        # if len(tk) > 1:
        return ench.check(tk) | ench.check(tk.lower()) | ench.check( string.capwords(tk.lower()) )
        # else
        #     return False

    @classmethod
    def add_plural(cls, pinf, ench, words):
        plur_words = []
        for word in words:
            plural_word = pinf.plural(word)
            if Vocabularies.existing_word(ench,plural_word):
                plur_words.append(plural_word)
        return words + plur_words


class Entities(object):

    def __init__(self):
        s = Session(load_files =False)

        # add plural to entity_persons
        entity_persons = {}
        for key,words in Invar.entity_persons().items():
            entity_persons[key] = Vocabularies.add_plural(s.pinf, s.ench, words)

        entity_tagging = {}
        for key,words in Invar.entity_tagging().items():
            entity_tagging[key] = Vocabularies.add_plural(s.pinf, s.ench, words)

        self.persons        = entity_persons
        self.tags           = entity_tagging

    def to_json(self):
        import json
        with open(DATA_PATH + 'entities/persons.json', 'w') as outfile:
            json.dump(self.persons, outfile, indent = 4)
        with open(DATA_PATH + 'entities/tags.json', 'w') as outfile:
            json.dump(self.tags, outfile, indent = 4)

        with open(DATA_PATH + 'entities/lingo.json', 'w') as outfile:
            json.dump({ **Invar.lingo() }, outfile, indent = 4)

        with open(DATA_PATH + 'entities/contractions.json', 'w') as outfile:
            json.dump({**Invar.contractions()}, outfile, indent = 4)

        with open(DATA_PATH + 'entities/stopwords.json', 'w') as outfile:
            json.dump({**Invar.contractions()}, outfile, indent = 4)
