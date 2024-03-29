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

# Define variables that require the filename of this make file
SUBSAMPLED_DATA:=${THIS.MAKEFILE.NAME}

# Define how to import other make files
include ${PATH.TO.THIS.MAKEFILE}/import.mk

# Import common variables
$(eval $(call import,${PATH.TO.THIS.MAKEFILE}/common.cz-_.mk))
$(eval $(call import,${PATH.TO.THIS.MAKEFILE}/common._-en.mk))


# Define the rest of the variables needed for this step
SUBSAMPLED_DATA:=${EXPERIMENT_DIR}/${SUBSAMPLED_DATA}
SUBSAMPLER_MANIFEST:=news-commentary10.cz-en czeng-train


################################################################################
####                                                                        ####
####                   Download and install software                        ####

# Download and install Joshua
$(eval $(call import,${EXPERIMENT_MAKE_DIR}/train/subsample.mk))
$(eval $(call SUBSAMPLE_DATA,${SUBSAMPLED_DATA},${SRC},${TGT},${SUBSAMPLER_MANIFEST},${NORMALIZED_DATA},${FILTER_SCRIPT},${JOSHUA},${SUBSAMPLER_JVM_FLAGS},${SUBSAMPLER_FILES_TO_TRANSLATE}))

####                                                                        ####
####         ... done downloading and installing software                   ####
################################################################################



