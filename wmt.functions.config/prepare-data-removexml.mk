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
$(eval $(call import,${EXPERIMENT_MAKE_DIR}/prepare-data/wmt10/remove-xml.mk))
$(eval $(call LINK_STRIP_XML_DATA,${DATA_DIR},${BARE_XML_FILES},${NON_XML_FILES},${PROCESSED_XML_FILES},${PROCESSED_NON_XML_FILES},${DATA_WITHOUT_XML}))



####                                                                        ####
####             ... done downloading data from the web                     ####
################################################################################
