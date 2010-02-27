################################################################################
####            Define the purpose of this experimental step:               ####
####                                                                        ####
#### This step defines the data and language pair to be used in subsampling
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
export SRC:=fr
export TGT:=en
####                                                                        ####
################################################################################


################################################################################
####                Import any immediate prerequisite steps:                ####
####                                                                        ####
include ${PATH.TO.THIS.MAKEFILE}/010.Subsample.mk
####                                                                        ####
################################################################################


################################################################################
####                     Define the target to be run:                       ####
####                                                                        ####
#### This is specified is ${PATH.TO.THIS.MAKEFILE}/010.Subsample.mk
####                                                                        ####
################################################################################


################################################################################
####                     Define how to run this step:                       ####
####                                                                        ####
#### This is specified is ${PATH.TO.THIS.MAKEFILE}/010.Subsample.mk
####                                                                        ####
################################################################################
