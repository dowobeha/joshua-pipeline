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
export TRAINED_LM_DIR:=${EXPERIMENT_DIR}/${THIS.MAKEFILE.NAME}
export SRILM_NGRAM_COUNT:=${SRILM}/bin/macosx/ngram-count
export LM_TRAINING_DIR:=${EXPERIMENT_DIR}/008.NormalizedData
export LM_NGRAM_ORDER:=5
export TGT:=cz
export LM_TRAINING_FILE_NAMES:=czeng-train.${TGT} news-commentary10.${TGT} news.${TGT}.shuffled
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
export .DEFAULT_GOAL=build-lm
####                                                                        ####
################################################################################


################################################################################
####                     Define how to run this step:                       ####
####                                                                        ####
$(eval $(call import,${EXPERIMENT_MAKE_DIR}/build-language-model.mk))
####                                                                        ####
################################################################################
