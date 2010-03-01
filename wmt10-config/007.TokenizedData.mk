################################################################################
####            Define the purpose of this experimental step:               ####
####                                                                        ####
#### This step tokenizes the data 
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
TOKENIZED_DATA:=${EXPERIMENT_DIR}/${THIS.MAKEFILE.NAME}
####                                                                        ####
################################################################################


################################################################################
####                Import any immediate prerequisite steps:                ####
####                                                                        ####
$(eval $(call import,${PATH.TO.THIS.MAKEFILE}/005.Scripts.mk))
$(eval $(call import,${PATH.TO.THIS.MAKEFILE}/006.RemoveXML.mk))
####                                                                        ####
################################################################################


################################################################################
####                     Define the target to be run:                       ####
####                                                                        ####
export .DEFAULT_GOAL=tokenize
####                                                                        ####
################################################################################


################################################################################
####                     Define how to run this step:                       ####
####                                                                        ####
$(eval $(call import,${EXPERIMENT_MAKE_DIR}/tokenize.mk))
####                                                                        ####
################################################################################
