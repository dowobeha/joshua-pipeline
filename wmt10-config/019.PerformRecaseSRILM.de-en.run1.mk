################################################################################
####            Define the purpose of this experimental step:               ####
####                                                                        ####
#### This step ... 
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
export RECASE_SRILM_TEST_DIR:=${EXPERIMENT_DIR}/${THIS.MAKEFILE.NAME}
export SRILM_DISAMBIG:=${SRILM}/bin/i686-m64/disambig
export RECASE_SRILM_INPUT_DIR:=${EXPERIMENT_DIR}/017.ExtractMBRCand.de-en.run1
####                                                                        ####
################################################################################


################################################################################
####                Import any immediate prerequisite steps:                ####
####                                                                        ####
$(eval $(call import,${PATH.TO.THIS.MAKEFILE}/017.ExtractMBRCand.de-en.run1.mk))
$(eval $(call import,${PATH.TO.THIS.MAKEFILE}/018.RecaseSRILM.de.run1.mk))
####                                                                        ####
################################################################################


################################################################################
####                     Define the target to be run:                       ####
####                                                                        ####
export .DEFAULT_GOAL=recase-srilm-test
####                                                                        ####
################################################################################


################################################################################
####                     Define how to run this step:                       ####
####                                                                        ####
$(eval $(call import,${EXPERIMENT_MAKE_DIR}/recase-srilm-test.mk))
####                                                                        ####
################################################################################
