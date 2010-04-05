################################################################################
####            Define the purpose of this experimental step:               ####
####                                                                        ####
#### This step runs the Berkeley aligner
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
export BERKELEY_NUM_THREADS:=10
export BERKELEY_JVM_FLAGS:=-d64 -Dfile.encoding=utf8 -XX:MinHeapFreeRatio=10 -Xms25g -Xmx25g
export BERKELEY_ALIGN_DIR:=${EXPERIMENT_DIR}/${THIS.MAKEFILE.NAME}
####                                                                        ####
################################################################################


################################################################################
####                Import any immediate prerequisite steps:                ####
####                                                                        ####
$(eval $(call import,${PATH.TO.THIS.MAKEFILE}/004.BerkeleyAligner.mk))
$(eval $(call import,${PATH.TO.THIS.MAKEFILE}/010.Subsample.en-fr.run3.mk))
####                                                                        ####
################################################################################


################################################################################
####                     Define the target to be run:                       ####
####                                                                        ####
export .DEFAULT_GOAL=berkeley-align
####                                                                        ####
################################################################################


################################################################################
####                     Define how to run this step:                       ####
####                                                                        ####
$(eval $(call import,${EXPERIMENT_MAKE_DIR}/berkeley-align.mk))
####                                                                        ####
################################################################################
