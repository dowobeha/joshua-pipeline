#!/usr/bin/make -f

################################################################################
################################################################################
####                                                                        ####
####       Define variables necessary to run WMT10 translation pipeline     #### 
####                                                                        ####
################################################################################
################################################################################


# Define experiment-specific configuration options
export SRC=es
export TGT=en

# Define training files from which to subsample
export SUBSAMPLER_MANIFEST=news-commentary10.es-en europarl-v5.es-en undoc.2000.en-es 

# Define dev and devtest files to translate
export FILES_TO_TRANSLATE=newssyscomb2009-src.${SRC} news-test2008-src.${SRC}

# Define monolingual target language files to use for training language model
export LM_TRAINING_FILE_NAMES=europarl-v5.${TGT} news-commentary10.${TGT} news.${TGT}.shuffled undoc.2000.en-es.${TGT} giga-fren.release2.${TGT}

# Calculate the full path to this make file
PATH.TO.THIS.MAKEFILE:=$(realpath $(dir $(lastword ${MAKEFILE_LIST})))

# Define files and settings for running MERT
include ${PATH.TO.THIS.MAKEFILE}/wmt10-mert-config.mk

# Include makefile for configuring the rest of the experiment
include ${PATH.TO.THIS.MAKEFILE}/jhu-a-node-config.mk
