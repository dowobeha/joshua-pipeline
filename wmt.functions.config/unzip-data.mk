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
####                      Unzip data from the web                           ####

# Make dir to store unzipped data
$(eval $(call import,${EXPERIMENT_MAKE_DIR}/expand-data/wmt10/dir.mk))
$(eval $(call EXPAND_DATA_WMT10_DIR,${DOWNLOAD_DIR},${UNZIPPED_DATA_DIR}))

# Expand parallel training data
$(eval $(call import,${EXPERIMENT_MAKE_DIR}/expand-data/wmt10/training-parallel.mk))
$(eval $(call EXPAND_DATA_WMT10_TRAINING_PARALLEL,${DOWNLOAD_DIR},${UNZIPPED_DATA_DIR}))

# Expand monolingual training data
$(eval $(call import,${EXPERIMENT_MAKE_DIR}/expand-data/wmt10/training-monolingual.mk))
$(eval $(call EXPAND_DATA_WMT10_TRAINING_MONOLINGUAL,${DOWNLOAD_DIR},${UNZIPPED_DATA_DIR}))

# Expand UN es-en training data
$(eval $(call import,${EXPERIMENT_MAKE_DIR}/expand-data/wmt10/training-un-es-en.mk))
$(eval $(call EXPAND_DATA_WMT10_TRAINING_UN_ES_EN,${DOWNLOAD_DIR},${UNZIPPED_DATA_DIR}))

# Expand UN fr-en training data
$(eval $(call import,${EXPERIMENT_MAKE_DIR}/expand-data/wmt10/training-un-fr-en.mk))
$(eval $(call EXPAND_DATA_WMT10_TRAINING_UN_FR_EN,${DOWNLOAD_DIR},${UNZIPPED_DATA_DIR}))

# Expand 10^9 fr-en training data
$(eval $(call import,${EXPERIMENT_MAKE_DIR}/expand-data/wmt10/training-huge-fr-en.mk))
$(eval $(call EXPAND_DATA_WMT10_TRAINING_HUGE_FR_EN,${DOWNLOAD_DIR},${UNZIPPED_DATA_DIR}))

# Expand cz-en training data
$(eval $(call import,${EXPERIMENT_MAKE_DIR}/expand-data/wmt10/training-cz-en.mk))
$(eval $(call EXPAND_DATA_WMT10_TRAINING_CZ_EN,${DOWNLOAD_DIR},${UNZIPPED_DATA_DIR},${CZENG_SCRIPT}))

# Expand dev data
$(eval $(call import,${EXPERIMENT_MAKE_DIR}/expand-data/wmt10/dev.mk))
$(eval $(call EXPAND_DATA_WMT10_DEV,${DOWNLOAD_DIR},${UNZIPPED_DATA_DIR}))

# Expand test data
$(eval $(call import,${EXPERIMENT_MAKE_DIR}/expand-data/wmt10/test.mk))
$(eval $(call EXPAND_DATA_WMT10_TEST,${DOWNLOAD_DIR},${UNZIPPED_DATA_DIR}))


####                                                                        ####
####             ... done unzipping data from the web                     ####
################################################################################
