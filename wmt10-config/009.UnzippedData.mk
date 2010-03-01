################################################################################
####            Define the purpose of this experimental step:               ####
####                                                                        ####
#### This step unzips data which had been zipped to save space
####                                                                        ####
################################################################################


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


################################################################################
####                Define where the experiment shall be run:               ####
####                                                                        ####
include ${PATH.TO.THIS.MAKEFILE}/000.experiment.mk
####                                                                        ####
################################################################################


################################################################################
####                    Define any required variables:                      ####
####                                                                        ####
export UNZIPPED_DATA:=${EXPERIMENT_DIR}/${THIS.MAKEFILE.NAME}
####                                                                        ####
################################################################################


################################################################################
####                Import any immediate prerequisite steps:                ####
####                                                                        ####
$(eval $(call import,${PATH.TO.THIS.MAKEFILE}/008.NormalizedData.mk))
####                                                                        ####
################################################################################


################################################################################
####                     Define the target to be run:                       ####
####                                                                        ####
export .DEFAULT_GOAL=unzip-data
####                                                                        ####
################################################################################


################################################################################
####                     Define how to run this step:                       ####
####                                                                        ####
$(eval $(call import,${EXPERIMENT_MAKE_DIR}/unzip-data.mk))
####                                                                        ####
################################################################################
