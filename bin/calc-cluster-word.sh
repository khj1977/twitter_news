#!/bin/bash

export LANG=ja_JP.utf8
BASE_DIR=/home/ec2-user/pub/twitter-news/

cd $BASE_DIR/bin/
./TWGenerateInputToSVD.rb > ../data/wd.tsv

cd $BASE_DIR/bin/svd
rm -f *.p
python do-svd.py ../../data/wd.tsv
python print-kmeans.py > ../../data/kmeans-in.tsv

cd $BASE_DIR/bin/kmeans
java -jar kmeans.jar ../../data/kmeans-in.tsv 120 200 > ../../data/kmeans-out.tsv

cd $BASE_DIR
grep "	民主党	" data/kmeans-out.tsv > data/clustered-words.tsv

cd $BASE_DIR/bin/
./TWInsertPopWords.rb ../data/clustered-words.tsv