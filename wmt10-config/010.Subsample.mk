################################################################################
####            Define the purpose of this experimental step:               ####
####                                                                        ####
#### This step defines the general steps of running subsampling,
####    without specifying the subsampling parameters or the language pair  
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
export FILTER_SCRIPT:=${EXPERIMENT_MAKE_DIR}/strip.perl
export SUBSAMPLER_JVM_FLAGS:=-Xms30g -Xmx30g -Dfile.encoding=utf8
####                                                                        ####
################################################################################


################################################################################
####                Import any immediate prerequisite steps:                ####
####                                                                        ####
include ${PATH.TO.THIS.MAKEFILE}/009.UnzippedData.mk
####                                                                        ####
################################################################################


################################################################################
####                     Define the target to be run:                       ####
####                                                                        ####
export .DEFAULT_GOAL=subsample
####                                                                        ####
################################################################################


################################################################################
####                     Define how to run this step:                       ####
####                                                                        ####
include ${EXPERIMENT_MAKE_DIR}/subsample.mk
####                                                                        ####
################################################################################
