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
JOSHUA_EXTRACT_1BEST_DIR:=${THIS.MAKEFILE.NAME}

# Define how to import other make files
include ${PATH.TO.THIS.MAKEFILE}/import.mk

# Import common variables
$(eval $(call import,${PATH.TO.THIS.MAKEFILE}/015.Translate.cz-en.run1.mk))


# Finish initializing this variable
JOSHUA_EXTRACT_1BEST_DIR:=${EXPERIMENT_DIR}/${JOSHUA_EXTRACT_1BEST_DIR}


################################################################################
####                                                                        ####
####                   Download and install software                        ####

$(eval $(call import,${EXPERIMENT_MAKE_DIR}/test/extract-top-cand.mk))
$(eval $(call JOSHUA_EXTRACT_1BEST,${JOSHUA_EXTRACT_1BEST_DIR},${JOSHUA_EXTRACT_DEV_1BEST_INPUT},${JOSHUA_EXTRACT_DEV_1BEST_OUTPUT_FILENAME},${JOSHUA}))

####                                                                        ####
####         ... done downloading and installing software                   ####
################################################################################
