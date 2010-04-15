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
MERT_DIR:=${THIS.MAKEFILE.NAME}

# Define how to import other make files
include ${PATH.TO.THIS.MAKEFILE}/import.mk

# Import common variables
$(eval $(call import,${PATH.TO.THIS.MAKEFILE}/012.ExtractGrammar.cz-en.run1.mk))
$(eval $(call import,${PATH.TO.THIS.MAKEFILE}/013.LanguageModel.en.run1.mk))

# Finish initializing this variable
MERT_DIR:=${EXPERIMENT_DIR}/${MERT_DIR}


################################################################################
####                                                                        ####
####                   Run minimum error rate training                      ####

$(eval $(call import,${EXPERIMENT_MAKE_DIR}/train/mert.mk))
$(eval $(call MERT,${MERT_DIR},${TRANSLATION_GRAMMAR},${JOSHUA},${JOSHUA_MEMORY_FLAGS},${LANGUAGE_MODEL},${NORMALIZED_DATA},${MERT_FILE_TO_TRANSLATE},${MERT_REFERENCE_BASE},${MERT_METRIC_NAME},${MERT_NUM_REFERENCES},${LM_NGRAM_ORDER},${JOSHUA_MAX_N_ITEMS},${JOSHUA_THREADS},${MERT_JVM_FLAGS}))

####                                                                        ####
####         ... DONE running minimum error rate training                   ####
################################################################################
