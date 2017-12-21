import pandas as pd
import numpy as np
import string

import re
import json
import time
import csv
from tqdm import tqdm

from utils import *
import spacy

view_length = True

if __name__ == '__main__':
    start_time = time.time()
    s   = Session()
    df  = LoadData.load(s, phase = 'raw', frac  =1)

    nlp         = spacy.load('en')
    persons     = []        # People, including fictional.
    GPE         = []        # Countries, cities, states.
    ORG         = []        # Companies, agencies, institutions, etc.
    NORP        = []        # Nationalities or religious or political groups.
    entities    = []        # Other entities
    char_counts = []

    # Loop over each row of the data and store entities in lists: persons, GPE, ...
    for i,d in tqdm(df.iterrows()):
        char_counts.append(len(str(d.message).lower().strip()))
        doc = nlp(d.message)

        if len(doc.ents) > 0:
            for ent in doc.ents:
                word = str(ent).lower().strip()
                if ent.label_ == 'PERSON':
                    persons.append(word)
                elif ent.label_ == 'GPE':
                    GPE.append(word)
                elif ent.label_ == 'NORP':
                    NORP.append(word)
                elif ent.label_ == 'ORG':
                    ORG.append(word)
                # all the other entities that might make sense
                elif (ent.label_ not in ['CARDINAL', 'ORDINAL', 'PERCENT','DATE','TIME']) :
                    entities.append((word, ent.label_))

    # Save lists of entities to txt files for manual review
    open(DATA_PATH + 'persons.txt', 'w').write("\n".join( sorted(persons) ))
    open(DATA_PATH + 'gpe.txt', 'w').write("\n".join( sorted(GPE) ))
    open(DATA_PATH + 'norp.txt', 'w').write("\n".join( sorted(NORP) ))
    open(DATA_PATH + 'org.txt', 'w').write("\n".join( sorted(ORG) ))

    # Save lists of entities to txt files for manual review
    open(DATA_PATH + 'unique_persons.txt', 'w').write("\n".join( sorted(set(persons)) ))
    open(DATA_PATH + 'unique_gpe.txt', 'w').write("\n".join( sorted(set(GPE)) ))
    open(DATA_PATH + 'unique_norp.txt', 'w').write("\n".join( sorted(set(NORP)) ))
    open(DATA_PATH + 'unique_org.txt', 'w').write("\n".join( sorted(set(ORG)) ))

    # Save all other entittes with related entity type
    str_entities = [ "{0},{1}".format(e[1], str(e[0]).replace(',',' '))  for e in entities ]

    open(DATA_PATH + 'entities.csv', 'w').write("\n".join( str_entities ))

    cc = pd.DataFrame(columns = ['length'], data = char_counts, index = df.id)
    cc.to_csv(DATA_PATH +  'char_counts.csv',  index = False, header = True)

    print("NER done in {0:.2f}s".format(time.time() - start_time))
