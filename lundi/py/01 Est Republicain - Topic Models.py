
# coding: utf-8

# # Topic models - Est Republicain
# 
# Dans ce premier lab nous allons explorer un corpus en français propre et bien structuré de façon a nous familiariser avec les outils de topic models.
# 
# Nous comparons 2 librairies:
# * [Gensim](https://radimrehurek.com/gensim/) en python, 
# * [stm](http://www.structuraltopicmodel.com/) en R
# 
# Et differentes versions du corpus en commancant par la version brut puis en appliquant petit a petit des transformations qui vont nettoyer le contenu et améliorer les résultats.
# 
# 

# # Le corpus 
# 
# Constitué des articles publié dans l'Est Républicain de mai a septembre 1999. 
# Le corpus original se trouve sur http://www.cnrtl.fr/corpus/estrepublicain/. 
# 
# 133 fichiers au format XML.
# 
# 
# 
# Le corpus sur lequel nous allons travailler est sur ```../data/estrepublicain_annee_1999.csv```. 
# 
# Il contient 30k rows composés de paragraphes de longueur variable.
# 
# # Chargement et exploration

# In[54]:


import pandas as pd

DATA_PATH = '../data/'
filename  = 'estrepublicain_annee_1999.csv'

df = pd.read_csv(DATA_PATH + filename)
print("\nLe corpus contient {} rows et {} colonne(s)".format(df.shape[0], df.shape[1]))

print("\nColonnes: {} ".format(df.columns))

print("\n== Premier elements: ")

for i,d in df[5:10].iterrows():
    print('--- {}'.format(i))
    print(d.text)


# Ne garder que les 100 premiers commentaires

df = df[0:100]
    


# # Matrice Mots - Documents
# 
# Pour appliquer les models LDA et LSI de Gensim on doit d'abord construire la matrice mots - documents.
# Ce qui implique de tokenizer le contenu.
# 
# ## Tokenization
# 
# _converting a sequence of characters into a sequence of tokens_
# 
# Dans le context de l'analyse textuelle, un token peut etre 
# * un mot
# * un bigram, n-gram, skip-gram, ....
# 
# Pour extraire les tokens d'une phrase, on peut simplement splitter sur l'espace
# 
# ``` 'les médiateurs confirment « l'absence de solution parfaite ». '.split(' ') ```
# 
# Ce qui donne
# 
# ``` ['les', 'médiateurs', 'confirment', '«', "l'absence, 'de', 'solution', 'parfaite', '».', ''] ```
# 
# Noter l'espace à la fin, et les tokens de ponctuation
# 
# On peut aussi utiliser NLTK.
# 

# In[55]:


from nltk import word_tokenize

sentence = "les médiateurs confirment « l'absence de solution parfaite ». "

tokens = word_tokenize(sentence)
print(tokens)


# => Séparation de ```'»', '.'```
# 
# mais pas de ```l``` et ```'```.
# 
# 
# ## Ponctuation. 
# 
# Enlever des tokens les caractères de ponctuation
# 
# On utilise pour cela la librairie ```string``` et on crée un ```translator``` a partir de la liste des caracteres a supprimer.
# 
# ```
# punctuation_chars = ''.join([s for s in string.punctuation if s not in ['_',"'",'-']  ]) + '\r\n“”…»«' + "’"
# translator = str.maketrans(' ', ' ', punctuation_chars)
# ```

# In[65]:


import string

print("Liste original de signe de ponctuations")
print("\t{}".format(string.punctuation))


sentence = "les médiateurs confirment « l'absence de solution parfaite ». "

punctuation_chars = ''.join([s for s in string.punctuation if s not in ['_', '-']  ]) + '“”…»«’\r\n'
print("Liste étendue de signe de ponctuations")
print("\t{}".format(punctuation_chars))


#  Construction d'un dict { '~':' ', '$': ' ', ... }
d = {}
for k in punctuation_chars:
    d[k] = ' '

# L'operateur de translation
translator = str.maketrans(d)

sentence = "les médiateurs confirment « l'absence de solution parfaite ». Et ils n'en “pensent pas moins”!"
new_sentence = sentence.translate(translator)

print()
print("=== phrase originale \n\t{}\n".format(sentence))
print("=== sans la ponctuation \n\t{}\n".format(new_sentence))
                                  
                                  


# ## Stopwords
# 
# Liste de mots très fréquents, qui n'apportent rien en terme d'information
# 

# In[66]:


from nltk.corpus import stopwords

print("=== stopwords - français: \n{}".format(stopwords.words('french')))


# 
# # Nettoyage leger du corpus
# 
# 
# * Enlever la ponctuation des paragraphes
# * tokeniser
# 
# 
# On travail maitenant sur la DataFrame avec le pattern
# 
# ``` df['new_column']   = df.text.apply( lambda d : fonction(d)    ) ```
# 
# où new_column est la nouvelle representation des textes,  et fonction est la fonction que nous voulons appliquer: lower, stopwords, ponctuation, ...
# 
# Dans l'appel a lambda ```d``` est un row de la DataFrame ```df.text```
# 
# ### Enlever la ponctuation 
# 
# 
# 

# In[67]:


df['text_no_punctuation'] = df.text.apply(lambda d : ( d.translate(translator) ) )


# df.loc[5].text: le text du 5ieme row

print("\n=== Avant: \n\t{}".format(df.loc[5].text))
print("\n=== Apres: \n\t{}".format(df.loc[5].text_no_punctuation))


# In[68]:


# Tokenization et minuscule
df['tokens_all']  = df.text_no_punctuation.apply(lambda s : word_tokenize(s.lower()))


# In[71]:


# Stopwords

list_stopwords = stopwords.words('french')

# a partir d'une liste de tokens, retourne une liste sans les stopwords
def remove_stopword(tokens):
     return [w for w in tokens if (w not in list_stopwords) ]

df['tokens'] = df.tokens_all.apply(lambda tks : remove_stopword(tks) )

print("\n=== Original: \n\t{}".format(df.loc[6].text_no_punctuation))
print("\n=== Tokens: \n\t{}".format(df.loc[6].tokens_all))
print("\n=== Sans stopwords: \n\t{}".format(df.loc[6].tokens))




# ### Enlever les variables intermediaires

# In[76]:


print("df a maintenant {} rows et {} colonnes: \n{}".format( df.shape[0], df.shape[1], df.columns ))



print("\n* Ne garder que les colonnes text et tokens ")

df = df[['text', 'tokens']]

print("\n* Calcul du nombre de tokens")

df['len_tokens'] = df.tokens.apply(len)

print("\n* Distribution de la longueur des paragraphes tokenizés")

print(df.describe())


# In[79]:


import matplotlib.pyplot as plt
plt.hist(df.len_tokens)

