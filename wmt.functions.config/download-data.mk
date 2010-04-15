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

# Define how to import other make files
include ${PATH.TO.THIS.MAKEFILE}/import.mk

# Import common variables
$(eval $(call import,${PATH.TO.THIS.MAKEFILE}/common.mk))




################################################################################
####                                                                        ####
####                    Download data from the web                          ####

# Make dir to store downloads
$(eval $(call import,${EXPERIMENT_MAKE_DIR}/download-data/wmt10/dir.mk))
$(eval $(call DOWNLOAD_DATA_WMT10,${DOWNLOAD_DIR}))

# Download training data
$(eval $(call import,${EXPERIMENT_MAKE_DIR}/download-data/wmt10/training.mk))
$(eval $(call DOWNLOAD_DATA_WMT10_TRAINING,${DOWNLOAD_DIR}))

# Download training data for CzEn
$(eval $(call import,${EXPERIMENT_MAKE_DIR}/download-data/wmt10/training-czen.mk))
$(eval $(call DOWNLOAD_DATA_WMT10_TRAINING_CZEN,${DOWNLOAD_DIR},${CZEN_USERNAME}))

# Download dev data
$(eval $(call import,${EXPERIMENT_MAKE_DIR}/download-data/wmt10/dev.mk))
$(eval $(call DOWNLOAD_DATA_WMT10_DEV,${DOWNLOAD_DIR}))

# Download test data
$(eval $(call import,${EXPERIMENT_MAKE_DIR}/download-data/wmt10/test.mk))
$(eval $(call DOWNLOAD_DATA_WMT10_TEST,${DOWNLOAD_DIR}))

####                                                                        ####
####             ... done downloading data from the web                     ####
################################################################################




