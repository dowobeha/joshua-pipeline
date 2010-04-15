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
EXTRACT_RULES_DIR:=${THIS.MAKEFILE.NAME}

# Define how to import other make files
include ${PATH.TO.THIS.MAKEFILE}/import.mk

# Import common variables
$(eval $(call import,${PATH.TO.THIS.MAKEFILE}/011.BerkeleyAlign.cz-en.run1.mk))

# Finish initializing this variable
EXTRACT_RULES_DIR:=${EXPERIMENT_DIR}/${EXTRACT_RULES_DIR}

################################################################################
####                                                                        ####
####                   Download and install software                        ####

$(eval $(call import,${EXPERIMENT_MAKE_DIR}/train/extract-grammar.mk))
$(eval $(call EXTRACT_GRAMMAR,${EXTRACT_RULES_DIR},${SRC},${TGT},${BERKELEY_ALIGN_DIR},${SUBSAMPLED_DATA},${JOSHUA},${EXTRACT_RULES_JVM_FLAGS}))

####                                                                        ####
####         ... DONE downloading and installing software                   ####
################################################################################
