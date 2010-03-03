################################################################################
####            Define the purpose of this experimental step:               ####
####                                                                        ####
#### This step builds a language model 
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
export RECASE_SRILM_DIR:=${EXPERIMENT_DIR}/${THIS.MAKEFILE.NAME}
export TGT:=en
export RECASE_SRILM_TRAINING_DIR:=${EXPERIMENT_DIR}/007.TokenizedData
export RECASE_SRILM_TRAINING_FILE_NAMES:=europarl-v5.${TGT} news-commentary10.${TGT} news.${TGT}.shuffled undoc.2000.en-fr.${TGT} giga-fren.release2.${TGT}
####                                                                        ####
################################################################################


################################################################################
####                Import any immediate prerequisite steps:                ####
####                                                                        ####
$(eval $(call import,${PATH.TO.THIS.MAKEFILE}/007.TokenizedData.mk))
$(eval $(call import,${PATH.TO.THIS.MAKEFILE}/013.LanguageModel.${TGT}.run1.mk))
####                                                                        ####
################################################################################


################################################################################
####                     Define the target to be run:                       ####
####                                                                        ####
export .DEFAULT_GOAL=build-recase-srilm
####                                                                        ####
################################################################################


################################################################################
####                     Define how to run this step:                       ####
####                                                                        ####
$(eval $(call import,${EXPERIMENT_MAKE_DIR}/recase-srilm.mk))
####                                                                        ####
################################################################################
