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
$(eval $(call import,${EXPERIMENT_MAKE_DIR}/prepare-data/wmt10/link-data.mk))
ifndef TOY_SIZE
$(eval $(call LINK_UNZIPPED_DATA,${UNZIPPED_DATA_DIR},${DATA_DIR}))
else
$(eval $(call LINK_UNZIPPED_DATA_TOY,${UNZIPPED_DATA_DIR},${DATA_DIR},${TOY_SIZE}))
endif

####                                                                        ####
####             ... done downloading data from the web                     ####
################################################################################
