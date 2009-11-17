#!/bin/bash

EXPECTED_ARGS=2

if [ $# -ne $EXPECTED_ARGS ]
then
  echo "Usage: `basename $0` prereq_dir results_dir"
  exit -1
fi


tar xvzf $1/Rosetta-P4-ae-training-data-FOUO-v1.0.tgz -C $2 --wildcards 'arfiles/atb/*.filtered*' 'enfiles/tok/*.filtered*'

