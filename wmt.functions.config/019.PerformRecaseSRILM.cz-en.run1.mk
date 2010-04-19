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
RECASE_SRILM_TEST_DIR:=${THIS.MAKEFILE.NAME}

# Define how to import other make files
include ${PATH.TO.THIS.MAKEFILE}/import.mk

# Import common variables
$(eval $(call import,${PATH.TO.THIS.MAKEFILE}/016.ExtractTopCand.cz-en.run1.mk))
$(eval $(call import,${PATH.TO.THIS.MAKEFILE}/017.ExtractMBRCand.cz-en.run1.mk))
$(eval $(call import,${PATH.TO.THIS.MAKEFILE}/018.RecaseSRILM.en.run1.mk))


# Finish initializing this variable
RECASE_SRILM_TEST_DIR:=${EXPERIMENT_DIR}/${RECASE_SRILM_TEST_DIR}


################################################################################
####                                                                        ####
####                   Download and install software                        ####

$(eval $(call import,${EXPERIMENT_MAKE_DIR}/recase/recase-srilm-test.mk))
$(eval $(call TEST_RECASE_SRILM,${RECASE_SRILM_TEST_DIR},${SRILM_DISAMBIG},${TGT},${RECASE_LM_NGRAM_ORDER},${RECASE_LANGUAGE_MODEL},${RECASE_MAP_FILE},${RECASE_STRIP_TAGS_SCRIPT},${JOSHUA_EXTRACT_MBR_BEST_DIR}/${JOSHUA_EXTRACT_DEV_MBR_BEST_OUTPUT_FILENAME}))
$(eval $(call TEST_RECASE_SRILM,${RECASE_SRILM_TEST_DIR},${SRILM_DISAMBIG},${TGT},${RECASE_LM_NGRAM_ORDER},${RECASE_LANGUAGE_MODEL},${RECASE_MAP_FILE},${RECASE_STRIP_TAGS_SCRIPT},${JOSHUA_EXTRACT_1BEST_DIR}/${JOSHUA_EXTRACT_DEV_1BEST_OUTPUT_FILENAME}))

####                                                                        ####
####         ... done downloading and installing software                   ####
################################################################################
