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

include ${PATH.TO.THIS.MAKEFILE}/common.mk


################################################################################
####                                                                        ####
####                        Prepare data for use                            ####

# Link data
$(eval $(call import,${EXPERIMENT_MAKE_DIR}/prepare-data/wmt10/normalize.mk))
$(eval $(call NORMALIZE_DATA,${WMT10_SCRIPTS},${TOKENIZED_DATA},${NORMALIZED_DATA},${NORMALIZED_FILES}))

####                                                                        ####
####             ... done downloading data from the web                     ####
################################################################################
