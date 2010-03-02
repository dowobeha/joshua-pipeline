################################################################################
####            Define the purpose of this experimental step:               ####
####                                                                        ####
#### This step translates using Joshua
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
export JOSHUA_TRANSLATION_DIR:=${EXPERIMENT_DIR}/${THIS.MAKEFILE.NAME}
export JOSHUA_RULES_DIR:=${EXPERIMENT_DIR}/012.ExtractGrammar.es-en.run2
export JOSHUA_TRANSLATION_INPUT_DIR:=${EXPERIMENT_DIR}/009.UnzippedData
export JOSHUA_TRANSLATION_INPUT:=newstest2010-src.es
export JOSHUA_TRANSLATION_OUTPUT:=newstest2010.en
####                                                                        ####
################################################################################


################################################################################
####                Import any immediate prerequisite steps:                ####
####                                                                        ####
$(eval $(call import,${PATH.TO.THIS.MAKEFILE}/014.MERT.es-en.bleu.run1.mk))
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
