################################################################################
################################################################################
####                                                                        ####
####         Define where and how to run the WMT10 translation pipeline     #### 
####                                                                        ####
################################################################################
################################################################################

# Contents:
#
# 1) Perform some minor but necessary housekeeping details
# 2) Define directories for each step in the translation pipeline
# 3) Define steps to run the translation pipeline


################################################################################
#          Perform some minor but necessary housekeeping details               #
################################################################################

# Inform user what they are running
$(info Translation pipeline for ${SRC}-${TGT})

# Calculate the full path to this make file
PATH.TO.THIS.MAKEFILE:=$(realpath $(dir $(lastword ${MAKEFILE_LIST})))

# Require that the user defines the EXPERIMENT_DIR
EXPERIMENT_DIR ?= $(error The EXPERIMENT_DIR variable must be defined, but currently is not defined.)



################################################################################
#          Define directories for each step in the translation pipeline        #
################################################################################

# Define directory where log files will be located
export LOG_FILES_DIR=${EXPERIMENT_DIR}/999.logs


# Define directory to save downloaded data
export DOWNLOADS_DIR=${EXPERIMENT_DIR}/001.OriginalData

# Define directory to expand downloaded data
export DATA_DIR=${EXPERIMENT_DIR}/002.OriginalData

# Define directory where Joshua will be located
export JOSHUA=${EXPERIMENT_DIR}/003.Joshua

# Define directory where Berkeley Aligner will be located
export BERKELEYALIGNER=${EXPERIMENT_DIR}/004.BerkeleyAligner

# Define directory where WMT scripts will be located
export WMT_SCRIPTS=${EXPERIMENT_DIR}/005.Scripts

# Define directory where data stripped of XML will be located
export DATA_WITHOUT_XML=${EXPERIMENT_DIR}/006.RemoveXML

# Define directory where tokenized data will be located
export TOKENIZED_DATA=${EXPERIMENT_DIR}/007.TokenizedData

# Define directory where normalized data will be located
export NORMALIZED_DATA=${EXPERIMENT_DIR}/008.NormalizedData

# Define directory where unzipped data will be located
export UNZIPPED_DATA=${EXPERIMENT_DIR}/009.UnzippedData

# Define directory where subsampler results will be located
export SUBSAMPLED_DATA=${EXPERIMENT_DIR}/010.Subsample.${SRC}-${TGT}

# Define directory where Berkeley aligner results will be located
export BERKELEY_ALIGN_DIR=${EXPERIMENT_DIR}/011.BerkeleyAlign.${SRC}-${TGT}

# Define directory where rule extraction results will be located
export EXTRACT_RULES_DIR=${EXPERIMENT_DIR}/012.ExtractGrammar.${SRC}-${TGT}

# Define input for language model
export LM_TRAINING_DIR=${EXPERIMENT_DIR}/009.UnzippedData
# Define directory where language model will be located
export TRAINED_LM_DIR=${EXPERIMENT_DIR}/013.LanguageModel.${TGT}


################################################################################
#          Define steps to run the translation pipeline                        #
################################################################################

# Declare how to run all steps of this experiment
all: download expand joshua berkeley-aligner wmt-scripts remove-xml tokenize normalize unzip-data subsample berkeley-align extract-grammar build-lm


download:
#	Download data from WMT10 web site
	$(MAKE) -f ${PATH.TO.THIS.MAKEFILE}/download-data.mk downloads 

expand:
#	Expand compressed data from WMT10 web site
	$(MAKE) -f ${PATH.TO.THIS.MAKEFILE}/expand-data.mk expand

joshua:
#	Download and compile Joshua
	$(MAKE) -f ${PATH.TO.THIS.MAKEFILE}/install-joshua.mk joshua

berkeley-aligner:
#	Download and install Berkeley Aligner
	$(MAKE) -f ${PATH.TO.THIS.MAKEFILE}/install-berkeley.mk berkeley-aligner

wmt-scripts:
#	Download and install WMT scripts
	$(MAKE) -f ${PATH.TO.THIS.MAKEFILE}/install-wmt-scripts.mk wmt-scripts

remove-xml:
#	Remove XML from downloaded data
	$(MAKE) -f ${PATH.TO.THIS.MAKEFILE}/remove-xml.mk remove-xml

tokenize:
#	Tokenize data
	$(MAKE) -f ${PATH.TO.THIS.MAKEFILE}/tokenize.mk tokenize

normalize:
#	Normalize data (lowercase)
	$(MAKE) -f ${PATH.TO.THIS.MAKEFILE}/normalize.mk normalize

unzip-data:
#	Unzip compressed data
	$(MAKE) -f ${PATH.TO.THIS.MAKEFILE}/unzip-data.mk unzip-data

subsample:
#	Subsample training data for the test data
	$(MAKE) -f ${PATH.TO.THIS.MAKEFILE}/subsample.mk subsample

berkeley-align:
#	Word alignment using Berkeley aligner
	$(MAKE) -f ${PATH.TO.THIS.MAKEFILE}/berkeley-align.mk berkeley-align

extract-grammar:
#	Extract synchronous context-free translation grammar
	$(MAKE) -f ${PATH.TO.THIS.MAKEFILE}/extract-grammar.mk extract-grammar

build-lm:
#	Build language model
	$(MAKE) -f ${PATH.TO.THIS.MAKEFILE}/build-language-model.mk build-lm

.PHONY: all download expand joshua berkeley-aligner wmt-scripts remove-xml tokenize normalize unzip-data subsample berkeley-align extract-grammar build-lm
