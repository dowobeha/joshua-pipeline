#!/bin/bash

EXPECTED_ARGS=2

if [ $# -ne $EXPECTED_ARGS ]
then
  echo "Usage: `basename $0` prereq_dir results_dir"
  exit -1
fi

# Create results directory
mkdir -p $2 && cd $2;

for name in `cd $1 && ls -1 *.filtered.05_27_2009.*`; do 

    link=`echo $name | sed 's/.en.filtered.05_27_2009./.split-/; s/.ar.filtered.05_27_2009./.split-/'`;
    ln -s $1/$name $link; 

done


for name in `cd $1 && ls -1 *.filtered`; do

    link=`echo $name | sed 's/.en.filtered//; s/.ar.filtered//'`;
    ln -s $1/$name $link;

done
