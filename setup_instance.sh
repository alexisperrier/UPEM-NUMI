# ---------------------------------------------------------------------------
#  libs
# ---------------------------------------------------------------------------
sudo apt-get update
sudo apt-get install bzip2
sudo apt-get -y build-dep libcurl4-gnutls-dev
sudo apt-get -y install libcurl4-gnutls-dev

# ---------------------------------------------------------------------------
#  R
# ---------------------------------------------------------------------------

# ---------------------------------------------------------------------------
#  anaconda
# ---------------------------------------------------------------------------
14  wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
15  bash Miniconda3-latest-Linux-x86_64.sh
17  conda install scikit-learn pandas jupyter ipython
18  conda install -c gensim spacy nltk
19  conda config --show
20  conda install -c anaconda  gensim spacy nltk
21  python -m spacy download en
23  python -m spacy download fr

25  jupyter notebook --generate-config
26  jupyter notebook password

267  cd ~/.jupyter/
33  vim .jupyter/jupyter_notebook_config.py
269  vim jupyter_notebook_config.py
34  jupyter-notebook --no-browser --port=5000
41  sudo pip3 uninstall boto
42  conda uninstall boto
43  pip install google-compute-engine

46  conda install -c anaconda  gensim
254  conda install -c anaconda stop-words
255  pip install stop-words

# ---------------------------------------------------------------------------
#  Git & ssh
# ---------------------------------------------------------------------------
95  cd UPEM-NUMI/
94  sudo apt-get install git
96  git init
97  git commit -m "first commit"
98  git config --global user.email "alexis.perrier@gmail.com"
99  git config --global user.name "Alexis Perrier"

109  ssh-keygen -t rsa -b 4096 -C "alexis.perrier@gmail.com"
110  eval "$(ssh-agent -s)"
111  ssh-add -K ~/.ssh/id_rsa_gcloud_upem
112  ssh-add  ~/.ssh/id_rsa_gcloud_upem

115  cat id_rsa_gcloud_upem.pub

121  git remote add origin git@github.com:alexisperrier/UPEM-NUMI.git
122  git push -u origin master
123  git pull origin master

# ---------------------------------------------------------------------------
#
# ---------------------------------------------------------------------------

124  R
125  ll /usr/local/lib/R/site-library
126  ll /usr/local/lib/R/
127  sudo chmod 777 /usr/local/lib/R/site-library
128  ll /usr/local/lib/R/
129  R




282  vi .bashrc
283  source .bashrc
284  alias
285  start_jup
286  gst
287  git pull origin master
288  R
289  R --version
290  R
291  sudo apt-get update
292  R
294

-----------------------------------------------------------
sudo apt-get install r-base
sudo add-apt-repository ppa:marutter/rrutter
-----------------------------------------------------------


295  dmesg | head -1
296  sudo dmesg | head -1
297  sudo sh -c 'echo "deb http://cran.rstudio.com/bin/linux/debian jessie-cran3/" >> /etc/apt/sources.list'
298  sudo apt-key adv --keyserver subkeys.pgp.net --recv-key 381BA480


sudo apt-get install dirmngr

# sudo apt-key adv --keyserver subkeys.pgp.net --recv-key 381BA480

304  sudo apt-key adv --keyserver subkeys.pgp.net --recv-key 381BA480
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key 381BA480
306  sudo apt-get update
sudo apt-get install r-base r-base-dev
308  R --version
309  cd $HOME
310  wget https://cran.rstudio.com/src/base/R-3/R-3.4.0.tar.gz
311  sudo aptitude install g++
312  java -version
313  sudo ./configure --enable-R-shlib
314  sudo make
315  sudo make install
316  R --version
317  R
318  R --version
319  source .bashrc
320  R --version
321  vim .bashrc
322  ll
323  vim .bashrc
324  source .bashrc
325  R --versio
326  R --version
327  R
328  sudo apt-get install libxml2-dev
329  R
330  sudo apt-get install r-cran-xml
331  R
332  sudo apt-get remove libxml2-dev
333  ll /home/alexis/miniconda3/include/libxml2
334  ll /home/alexis/miniconda3/include/libxml2/libxml/


sudo apt-get install libxml2-dev

345  cd /
346  sudo find ./ | grep libicui18n.so
347  echo $LD_LIBRARY_PATH
348  LD_LIBRARY_PATH=/usr/lib/
349  LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/x86_64-linux-gnu/
350  export LD_LIBRARY_PATH
351  echo LD_LIBRARY_PATH
352  echo $LD_LIBRARY_PATH
353  LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu/
354  export LD_LIBRARY_PATH
355  echo $LD_LIBRARY_PATH
356  sudo ldconfig -v
357  which R
358  /usr/bin/R --version
359  dpkg -l | grep ^ii | grep -E "\Wr-"
360  sudo apt-get remove r-base-core
361  dpkg -l | grep ^ii | grep -E "\Wr-"
362  sudo apt-get update
sudo add-apt-repository "deb http://cran.rstudio.com/bin/linux/ubuntu $(lsb_release -sc)/"
364  sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
365  sudo add-apt-repository ppa:marutter/rdev

-=================================================================
sudo apt-get install software-properties-common
sudo add-apt-repository "deb http://cran.rstudio.com/bin/linux/ubuntu $(lsb_release -sc)/"
sudo add-apt-repository ppa:marutter/rdev
369  sudo apt-get update
370  sudo apt-get upgrade
371  sudo apt-get install r-base
372  R --version
373  sudo apt-get install build-essential
374  sudo apt-get install fort77
375  sudo apt-get install xorg-dev
376  sudo apt-get install build-essential
377  sudo apt-get install fort77
378  sudo apt-get install xorg-dev
379  sudo apt-get install liblzma-dev  libblas-dev gfortran
380  sudo apt-get install gcc-multilib
381  sudo apt-get install gobjc++
382  sudo apt-get install aptitude
383  sudo aptitude install libreadline-dev
384  sudo aptitude install libcurl4-openssl-dev
385  sudo apt-get install default-jdk
386  sudo apt-get install texlive-latex-base
387  sudo apt-get install libcairo2-dev
388  sudo apt-get install r-base
389  hg remove
390  sudo apt-get remove r-base-core
391  sudo apt-get install r-base
392  ll
393  cd
394  ll
395  rm -r R-3.4.0
396  sudo rm -r R-3.4.0
397  sudo rm -r R-3.4.0.tar.gz
398  ./configure --prefix=/home/jtrembla/software/R/R-3.4.0 --with-x=yes --enable-R-shlib=yes --with-cairo=yes
399  cd R-3.4.0.tar.gz
400  gunzip R-3.4.0.tar.gz
401  ll
402  tar -xvf R-3.4.0.tar
403  cd R-3.4.0
404  ./configure --prefix=/home/jtrembla/software/R/R-3.4.0 --with-x=yes --enable-R-shlib=yes --with-cairo=yes
405  make
406  ll doc/
407  touch doc/NEWS.pdf
408  ll doc/
409  make install
410  mkdir -p -- /home/jtrembla/software/R/R-3.4.0/lib/R
411  sudo mkdir -p -- /home/jtrembla/software/R/R-3.4.0/lib/R
412  make install
413  sudo make install
414  ll ~/software/R/R-3.4.0/bin
415  ll ~/R/R-3.4.0/bin
416  ll ~/R-3.4.0/bin
417  export PATH=~/R-3.4.0/bin:$PATH
418  R --version
419  R
420  sudo apt-get install libjpeg62
421  sudo apt-get install libxml2-dev
422  sudo apt-get install t1-xfree86-nonfree ttf-xfree86-nonfree ttf-xfree86-nonfree-syriac xfonts-75dpi xfonts-100dpi
423  hg PATH
424  cd
425  cd /home/alexis/miniconda3/include/
426  ll
427  rm -rf libxml2
428  sudo apt-get install libxml2-dev
429  sudo apt-get remove libxml2-dev
430  cd /
431  hg find
432  sudo find ./ | grep libxml
433  cd
434  rm -rf miniconda3/
435  de UPEM-NUMI/
436  cd UPEM-NUMI/
437  gst
438  gitco "lab 02"
439  gpom
440  git pull origin master
441  vim lab02/notebooks/Topic Modeling in R with STM.ipynb
442  vim lab02/notebooks/Topic\ Modeling\ in\ R\ with\ STM.ipynb
443  gst
444  gitco "merge conflict"
445  gst
446  gpom
447  git pull origin master
448  cd
449  ll
450  wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
451  bash Miniconda3-latest-Linux-x86_64.sh
452  conda install numpy
453  conda install -c anaconda spacy
454  python -m spacy download en
455  python -m spacy download fr
456  conda install -c anaconda pandas jupyter ipython
457  conda install -c anaconda inflection
458  jup?
459  cd UPEM-NUMI/
460  ll
461  gst
462  git pull origin master
463  start_jup
464  R
465  cd UPEM-NUMI/
466  R
467  hg find
468  cd /
469  sudo find ./ | grep stmBrowser
470  cd
471  ll /home/alexis/R-3.4.0/library
472  ll /home/alexis/R-3.4.0/
473  sudo chmod 777 library
474  sudo chmod 777 /home/alexis/R-3.4.0/library
475  sudo chmod 777 /home/alexis/R-3.4.0
476  ll /home/alexis/R-3.4.0/
477  ll /home/alexis/R-3.4.0/library/
478  jup?
479  kill 3322
480  jup?
481  start_jup
482  jup?
483  kill alexis   11952  2538  0 11:52 pts/1    00:00:01 /home/alexis/miniconda3/bin/python /home/alexis/miniconda3/bin/jupyter-notebook --no-browser --port=8888
484  start_jup
485  R --version
486  R
487  Rstudio
488  rstudio
489  which R
490  hg find
491  ll /home/alexis/R-3.4.0/bin/R
492  ll /home/alexis/R-3.4.0/bin
493  cd /
494  hg find
495  sudo find ./ | grep Rd2pdf
496  cd
497  /usr/lib/R/bin/R --version
498  /usr/lib/R/bin/R
499  jupyter kernelspec list
500  cd /usr/lib/
501  ll
502  which R
503  rm -r /usr/lib/R
504  sudo rm -rf /usr/lib/R
505  which R
506  hg apt-get
507  use apt-get build-dep r-base-dev
508  apt-get build-dep r-base-dev
509  sudo apt-get build-dep r-base-dev
510  cd
511  jup?
512  start_jup
513  hg nltk
514  conda install -c nltk
515  conda install -c anaconda nltk
516  ipython
517  conda install -c r r-essentials
518  history
alexis@sparrow:~$
