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
JOSHUA_TRANSLATION_DIR:=${THIS.MAKEFILE.NAME}

# Define how to import other make files
include ${PATH.TO.THIS.MAKEFILE}/import.mk

# Import common variables
$(eval $(call import,${PATH.TO.THIS.MAKEFILE}/014.MERT.cz-en.bleu.run1.mk))


# Finish initializing this variable
JOSHUA_TRANSLATION_DIR:=${EXPERIMENT_DIR}/${JOSHUA_TRANSLATION_DIR}


################################################################################
####                                                                        ####
####                   Download and install software                        ####

$(eval $(call import,${EXPERIMENT_MAKE_DIR}/test/decode.mk))
$(eval $(call RUN_JOSHUA,${JOSHUA_TRANSLATION_DIR},${JOSHUA},${JOSHUA_MEMORY_FLAGS},${JOSHUA_DEV_FILE_TO_TRANSLATE},${JOSHUA_DEV_NBEST_OUTPUT_FILENAME},${MERT_RESULT_CONFIG},))

####                                                                        ####
####         ... done downloading and installing software                   ####
################################################################################
