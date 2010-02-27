################################################################################
################################################################################
####                                                                        ####
####       Configuration file defining how to run an experimental step      ####
####                                                                        ####
################################################################################
################################################################################


################################################################################
####            Define the purpose of this experimental step:               ####
####                                                                        ####
#### This step downloads compressed corpus data
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
####                     Define the target to be run:                       ####
####                                                                        ####
export .DEFAULT_GOAL=downloads
####                                                                        ####
################################################################################


################################################################################
####                    Define any required variables:                      ####
####                                                                        ####
#### Define directory to save downloaded data
export DOWNLOADS_DIR:=${EXPERIMENT_DIR}/${THIS.MAKEFILE.NAME}
####                                                                        ####
################################################################################


################################################################################
####                     Define how to run this step:                       ####
####                                                                        ####
include ${EXPERIMENT_MAKE_DIR}/download-data.mk
####                                                                        ####
################################################################################


