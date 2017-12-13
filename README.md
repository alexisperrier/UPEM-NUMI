# Data Sprint Topic Models

Voici les outils que nous utiliserons pour ce data sprint

Le mieux serait de les installer sur vos ordinateurs avant le debut du sprint pour ne pas perdre de temps le premier jours.

## Slack

Slack est une application de chat, tres utile pour échanger des fichiers, du code, ...

Notre workspace est [upem-numi.slack.com](https://upem-numi.slack.com). Clicker ici pour [recevoir une invitation](https://join.slack.com/t/upem-numi/shared_invite/enQtMjg1Njc5NDY5MDkwLTIxNzc0Nzk2NzRjOTNmOGExMTEyMDk1MmM5MjVkMTA2YTc2ZTMwMDhjZmFiMmEzMzRiMzA2NmQwZTAxYzJlNzk).


##  Github

Github est une plateforme pour echanger et developper du code collaborativement.

Tous le code sera mis sur github: [https://github.com/alexisperrier/UPEM-NUMI](https://github.com/alexisperrier/UPEM-NUMI)

Si vous n'avez pas de profils github, c'est le moment de vous en creer un.


## Jupyter Notebook

Nous travaillerons à partir de notebook jupyter (ipython) qui fournissent un environement de travail collaboratif en python à partir du navigateur.

Vous pouvez vous familiariser avec l'outil sur https://jupyter.org/

Notre espace de travail sera accessible a l'addresse [http://35.196.112.120:5000](http://35.196.112.120:5000).

Vous pourrez y creer vos propres notebook pour travailler collaborativement sur les differents corpus que nous analyserons.

# Python

## Python 3.6, distribution anaconda
Cette install comprends la plupart des packages pour le data science. Notamment pandas et numpy ainsi que les notebooks jupyter.

* suivre les instructions sur https://www.anaconda.com/download/


## Python NLP.
Pour les libraries de NLP nous utiliserons

* Spacy.io, https://anaconda.org/anaconda/spacy, https://spacy.io/

    Spacy.io est une librarie tres complete de traitement du text: lemmatization, POS, NER, ....

    Installation dans un terminal: ```  conda install -c anaconda spacy ```
    Puis charger les extensions ```fr``` et ```en```:
    ```python -m spacy download en```
    ```python -m spacy download fr```

    Enfin, tester que les modules ont été installé dans une session python:
    ```
    import spacy
    nlp = spacy.load('en')
    nlp = spacy.load('fr')
    ```

* NLTK http://www.nltk.org/, https://anaconda.org/anaconda/nltk

    Installation dans un terminal: ``` conda install -c anaconda nltk ```

    Il faut ensuite installer les modules comme stopwords: http://www.nltk.org/data.html

    Dans python:

        import nltk
        nltk.download()

    Cela ouvre un popup ou vous pouvez selectionner les modules que vous souhaitez installer.
    Nous aurons surtout besoin de stopwords en français et anglais.

* Gensim, https://anaconda.org/anaconda/gensim, https://radimrehurek.com/gensim/
    Gensim est une librarie python pour le topic modeling et word2vec

    Installation dans un terminal: ```  conda install -c anaconda gensim  ```


## R

Le meilleur module pour les topic models est STM en R. Voir http://www.structuraltopicmodel.com/.

Ce module offre de nombreuses fonctionnalitées: selection du nombre de topics par defaut, visualisation, variable externes, ...

Donc nous avons besoin de pourvoir travailler en R. Pour cela il nous faut installer R et Rstudio

* R disponible par exemple ici: https://cran.univ-paris1.fr/ (voir https://cran.r-project.org/mirrors.html pour la liste des mirroirs)
* R studio, version free disponible sur https://www.rstudio.com/products/rstudio/download/

Et il faudra installer les package suivants avec

    install.packages( c("stm", "tm", "splines", "stmBrowser"), dependencies = TRUE)
    install.packages( c('wordcloud', 'igraph', 'data.table'), dependencies = TRUE)
    install.packages( c("stringr", "RColorBrewer", "stringr"), dependencies = TRUE)
    install.packages( c("geometry", "Rtsne", "GetoptLong"), dependencies = TRUE )
