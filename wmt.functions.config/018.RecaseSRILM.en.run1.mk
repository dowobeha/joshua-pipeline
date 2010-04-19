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
RECASE_SRILM_DIR:=${THIS.MAKEFILE.NAME}

# Define how to import other make files
include ${PATH.TO.THIS.MAKEFILE}/import.mk

# Import common variables
$(eval $(call import,${PATH.TO.THIS.MAKEFILE}/015.Translate.cz-en.run1.mk))


# Finish initializing this variable
RECASE_SRILM_DIR:=${EXPERIMENT_DIR}/${RECASE_SRILM_DIR}


################################################################################
####                                                                        ####
####                   Download and install software                        ####

$(eval $(call import,${EXPERIMENT_MAKE_DIR}/recase/recase-srilm.mk))
$(eval $(call TRAIN_RECASE_SRILM,${RECASE_SRILM_DIR},${SRILM_NGRAM_COUNT},${TGT},${RECASE_LM_NGRAM_ORDER},${RECASE_TRUECASE_TRAINING_FILE_NAMES},${TRUECASE_MAPPING_SCRIPT}))

####                                                                        ####
####         ... done downloading and installing software                   ####
################################################################################

