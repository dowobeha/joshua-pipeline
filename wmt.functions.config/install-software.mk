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
####                   Download and install software                        ####

# Download and install Joshua
$(eval $(call import,${EXPERIMENT_MAKE_DIR}/install/joshua_1.3.mk))
$(eval $(call INSTALL_JOSHUA,${JOSHUA},${SRILM}))

# Download and install Berkeley aligner
$(eval $(call import,${EXPERIMENT_MAKE_DIR}/install/berkeley_2.1.mk))
$(eval $(call INSTALL_BERKELEY_ALIGNER,${BERKELEYALIGNER}))

# Download and install WMT10 scripts
$(eval $(call import,${EXPERIMENT_MAKE_DIR}/install/wmt10-scripts.mk))
$(eval $(call INSTALL_WMT10_SCRIPTS,${WMT10_SCRIPTS}))

####                                                                        ####
####         ... done downloading and installing software                   ####
################################################################################
