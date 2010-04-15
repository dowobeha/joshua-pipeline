################################################################################
####                 Gather information about this make file                ####
####                                                                        ####
#### Get the full path to this make file
PATH.TO.THIS.MAKEFILE:=$(abspath $(dir $(lastword ${MAKEFILE_LIST})))
####
#### Get the filename of this make file
THIS.MAKEFILE.NAME:=$(basename $(notdir $(lastword ${MAKEFILE_LIST})))
####                                                                        ####
################################################################################


# Start initializing this variable
TRAINED_LM_DIR:=${THIS.MAKEFILE.NAME}

# Define how to import other make files
include ${PATH.TO.THIS.MAKEFILE}/import.mk

# Import common variables
$(eval $(call import,${PATH.TO.THIS.MAKEFILE}/common._-en.mk))


# Finish initializing this variable
TRAINED_LM_DIR:=${EXPERIMENT_DIR}/${TRAINED_LM_DIR}

LM_TRAINING_FILE_NAMES:=europarl-v5.${TGT} news-commentary10.${TGT} news.${TGT}.shuffled

################################################################################
####                                                                        ####
####                   Download and install software                        ####

$(eval $(call import,${EXPERIMENT_MAKE_DIR}/train/build-language-model.mk))
$(eval $(call BUILD_LANGUAGE_MODEL,${TRAINED_LM_DIR},${SRILM_NGRAM_COUNT},${TGT},${LM_NGRAM_ORDER},${LM_TRAINING_FILE_NAMES},${LM_TRAINING_DIR}))

####                                                                        ####
####         ... done downloading and installing software                   ####
################################################################################
