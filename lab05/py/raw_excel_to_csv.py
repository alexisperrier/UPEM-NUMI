'''
Takes the raw excel files, aggregates them and dumps into csv file
transforms cols names into lower_case
converts media_id and from_id into strings
renames some columns
reorders dataframe
'''

import pandas as pd
import numpy as np

def conversion(text):
    if str(text) == 'nan':
        return ''
    else:
        return str(int(text))

DATA_PATH = '../data/original_files/'

filenames = [
'dec_2015.xlsx',
'janv_2016.xlsx',
'fev_2016.xlsx',
'mars_avril2016.xlsx',
'mai_juin2016.xlsx',
'juillet_aout_sept_2016.xlsx',
'octobre2016.xlsx',
'novembre2016.xlsx',
'dec_2016.xlsx',
'trump_2_compatible.xls'
]
# filenames = ['trump_2_compatible.xls', 'fev_2016.xlsx']

other_file = ['base_de_donnee_fonctionnelle.csv', 'idpost.csv']

columns = ['Post ID', 'Comment ID', 'Comment Comment ID', 'Message',
       'Created Time', 'Updated Time', 'Post Type', 'Status Type', 'From Name',
       'Is Post Hidden', 'Is Post Published', 'Tagged Name List',
       'Tagged Type List', 'Link Name', 'Link Caption', 'Link Description',
       'Link URL', 'Parent ID', 'Media Thumnail URL', 'Video Length',
       'Media URL', 'Story Text', 'Posting Application', 'Place ID',
       'Place Name', 'Place Country', 'Place State', 'Place Region',
       'Place City', 'Place Street', 'Place Zip', 'Place Latitude',
       'Place Longitude', 'page', 'From ID', 'Tagged ID List', 'Media ID',
       'Share Count', 'Comment Count', 'Reaction Count']

cols = [c.lower().replace(' ','_') for c in columns]

mdf = pd.DataFrame(columns = cols)


for f in filenames:
    print("-- Loading {0}{1}".format(DATA_PATH,f))
    df = pd.read_excel('{0}{1}'.format(DATA_PATH,f), sheet = 1, convert_float=True, names = cols)

    df.columns = cols
    print(" {0} rows ".format(df.shape[0]) )

    print("converting media_id and from_id")
    df['media_id'] = df.media_id.apply(lambda t : conversion(t) )
    df['from_id']  = df.from_id.apply(lambda t : conversion(t) )

    df.loc[df.message.isnull(), 'message'] = ''

    print("rename columns")
    df['created_time'] = pd.to_datetime(df['created_time'])
    df['updated_time'] = pd.to_datetime(df['updated_time'])

    df.drop(['page'], axis = 1, inplace = True)
    print("append")
    mdf = mdf.append(df, verify_integrity= True, ignore_index= True)
    print(mdf.shape)

mdf = mdf.rename(columns = {
    'comment_comment_id':'cc_id',
    'created_time': 'created_at',
    'updated_time': 'updated_at',
    'story_text':'event',
    'status_type':'action',
    })

mdf = mdf[['post_id','parent_id','comment_id','cc_id','from_id','from_name','message','post_type','is_post_hidden','is_post_published','link_caption','link_description','link_name','link_url',
        'media_id','media_thumnail_url','media_url','page','place_city','place_country','place_id','place_latitude','place_longitude','place_name','place_region','place_state','place_street',
        'place_zip','reaction_count','share_count','comment_count','action','event','posting_application','tagged_id_list','tagged_name_list','tagged_type_list','video_length','updated_at','created_at']]

print(mdf.shape)

mdf.to_csv('../data/fbget_original_full_data_2016_and_2017.csv', index = False)

mdf[['post_id', 'comment_id', 'created_at' , 'message']].to_csv('../data/fbget_original_2016_17_post_id_created_at_message.csv', index = False)
mdf[['created_at' , 'message']].to_csv('../data/fbget_original_2016_17_created_at_message.csv', index = False)
