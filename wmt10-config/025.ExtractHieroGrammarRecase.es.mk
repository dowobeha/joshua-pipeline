################################################################################
####            Define the purpose of this experimental step:               ####
####                                                                        ####
#### This step extracts a grammar using Hiero's rule extractor
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
export EXTRACT_RULES_DIR:=${EXPERIMENT_DIR}/${THIS.MAKEFILE.NAME}
export HIERO_DIR:=/home/zli/work/hiero/copy_2008/sa_copy/sa-hiero_adapted
export BERKELEY_ALIGN_DIR:=${EXPERIMENT_DIR}/024.RecasingCorpusAlignments.es
####                                                                        ####
################################################################################


################################################################################
####                Import any immediate prerequisite steps:                ####
####                                                                        ####
$(eval $(call import,${PATH.TO.THIS.MAKEFILE}/023.SubsampleRecasing.es.mk))
####                                                                        ####
################################################################################


################################################################################
####                     Define the target to be run:                       ####
####                                                                        ####
export .DEFAULT_GOAL=extract-grammar
####                                                                        ####
################################################################################


################################################################################
####                     Define how to run this step:                       ####
####                                                                        ####
$(eval $(call import,${EXPERIMENT_MAKE_DIR}/extract-grammar-hiero.mk))
####                                                                        ####
################################################################################
