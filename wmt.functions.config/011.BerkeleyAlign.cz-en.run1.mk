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
BERKELEY_ALIGN_DIR:=${THIS.MAKEFILE.NAME}

# Define how to import other make files
include ${PATH.TO.THIS.MAKEFILE}/import.mk

# Import common variables
$(eval $(call import,${PATH.TO.THIS.MAKEFILE}/010.Subsample.cz-en.run1.mk))

# Finish initializing this variable
BERKELEY_ALIGN_DIR:=${EXPERIMENT_DIR}/${BERKELEY_ALIGN_DIR}

################################################################################
####                                                                        ####
####                   Download and install software                        ####

# Download and install Joshua
$(eval $(call import,${EXPERIMENT_MAKE_DIR}/train/berkeley-align.mk))
$(eval $(call BERKELEY_ALIGN,${BERKELEY_ALIGN_DIR},${SRC},${TGT},${SUBSAMPLED_DATA},${BERKELEYALIGNER},${BERKELEY_NUM_THREADS},${BERKELEY_JVM_FLAGS}))

####                                                                        ####
####         ... done downloading and installing software                   ####
################################################################################



