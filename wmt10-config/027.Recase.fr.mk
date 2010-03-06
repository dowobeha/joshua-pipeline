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
LANG:=fr
export SRC:=lowercase
export TGT:=truecase
export JOSHUA_TRANSLATION_DIR:=${EXPERIMENT_DIR}/${THIS.MAKEFILE.NAME}
export JOSHUA_RULES_DIR:=025.ExtractHieroGrammarRecase.${LANG}
export JOSHUA_TRANSLATION_INPUT_DIR:=${EXPERIMENT_DIR}/020.RecasingCorpus.${LANG}
export JOSHUA_TRANSLATION_INPUT:=newstest2010.${LANG}.lowercase
export JOSHUA_TRANSLATION_OUTPUT:=newstest2010.${LANG}.truecase
export JOSHUA_MEMORY_FLAGS=-d64 -Dfile.encoding=utf8 -XX:MinHeapFreeRatio=10 -Xmx30g
export MERT_DIR:=${EXPERIMENT_DIR}/026.RecaseConfig.${LANG}
####                                                                        ####
################################################################################


################################################################################
####                Import any immediate prerequisite steps:                ####
####                                                                        ####
$(eval $(call import,${PATH.TO.THIS.MAKEFILE}/003.Joshua.mk))
#$(eval $(call import,${PATH.TO.THIS.MAKEFILE}/
####                                                                        ####
################################################################################


################################################################################
####                     Define the target to be run:                       ####
####                                                                        ####
export .DEFAULT_GOAL=joshua_decode
####                                                                        ####
################################################################################


################################################################################
####                     Define how to run this step:                       ####
####                                                                        ####
$(eval $(call import,${EXPERIMENT_MAKE_DIR}/decode.mk))
####                                                                        ####
################################################################################
