################################################################################
####            Define the purpose of this experimental step:               ####
####                                                                        ####
#### This step runs MERT
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
export SRC:=en
export TGT:=es
export MERT_DIR:=${EXPERIMENT_DIR}/${THIS.MAKEFILE.NAME}
export MERT_INPUT_DIR:=${EXPERIMENT_DIR}/009.UnzippedData
export MERT_FILE_TO_TRANSLATE:=news-test2008-src.${SRC}
export MERT_REFERENCE_BASE:=news-test2008-src.${TGT}
export MERT_NUM_REFERENCES:=1
export MERT_METRIC_NAME:=bleu
export MERT_JVM_FLAGS:=-d64 -Dfile.encoding=utf8 -Xms2g -Xmx2g -Dfile.encoding=utf8
####                                                                        ####
################################################################################


################################################################################
####                Import any immediate prerequisite steps:                ####
####                                                                        ####
$(eval $(call import,${PATH.TO.THIS.MAKEFILE}/012.ExtractGrammar.en-es.run1.mk))
$(eval $(call import,${PATH.TO.THIS.MAKEFILE}/013.LanguageModel.es.run1.mk))
####                                                                        ####
################################################################################


################################################################################
####                     Define the target to be run:                       ####
####                                                                        ####
export .DEFAULT_GOAL=mert
####                                                                        ####
################################################################################


################################################################################
####                     Define how to run this step:                       ####
####                                                                        ####
$(eval $(call import,${EXPERIMENT_MAKE_DIR}/mert.mk))
####                                                                        ####
################################################################################
