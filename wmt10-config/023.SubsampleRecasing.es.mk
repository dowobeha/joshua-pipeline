################################################################################
####            Define the purpose of this experimental step:               ####
####                                                                        ####
#### This step defines the test data to be used during subsampling
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
export SUBSAMPLED_DATA:=${EXPERIMENT_DIR}/${THIS.MAKEFILE.NAME}
export SRC:=lowercase
export TGT:=truecase
export NORMALIZED_DATA:=${EXPERIMENT_DIR}/020.RecasingCorpus.es
export FILES_TO_TRANSLATE:=newstest2010.es.lowercase
export SUBSAMPLER_MANIFEST:=news-commentary10.es-en.es europarl-v5.es-en.es undoc.2000.en-es.es
export FILTER_SCRIPT:=${EXPERIMENT_MAKE_DIR}/filter-sentences.pl
export SUBSAMPLER_JVM_FLAGS:=-Xms30g -Xmx30g -Dfile.encoding=utf8
####                                                                        ####
################################################################################


################################################################################
####                Import any immediate prerequisite steps:                ####
####                                                                        ####
$(eval $(call import,${PATH.TO.THIS.MAKEFILE}/003.Joshua.mk))
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
$(eval $(call import,${EXPERIMENT_MAKE_DIR}/subsample.mk))
####                                                                        ####
################################################################################
