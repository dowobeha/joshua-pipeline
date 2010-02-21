################################################################################
################################################################################
####                                                                        ####
####       Define variables necessary to run WMT10 translation pipeline     #### 
####                                                                        ####
################################################################################
################################################################################


# Define experiment-specific configuration options
export SRC=en
export TGT=de

# Define training files from which to subsample
export SUBSAMPLER_MANIFEST=news-commentary10.de-en europarl-v5.de-en

# Define dev and devtest files to translate
export FILES_TO_TRANSLATE=newssyscomb2009-src.${SRC} news-test2008-src.${SRC}



# Calculate the full path to this make file
PATH.TO.THIS.MAKEFILE:=$(realpath $(dir $(lastword ${MAKEFILE_LIST})))

# Include makefile for configuring the rest of the experiment
include ${PATH.TO.THIS.MAKEFILE}/jhu-a-node-config.mk