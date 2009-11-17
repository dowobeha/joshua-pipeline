################################################################################
################################################################################
####                                                                        ####
####                      Hiero rule extracton make file                    ####
####                                                                        ####
################################################################################
################################################################################

$(info )
$(info This make file defines:)
$(info --- how to extract a synchronous context-free grammar from an aligned parallel corpus using the Hiero suffix array grammar extractor.)
$(info )


################################################################################
################################################################################
####                                                                        ####
####      Verify that all required, user-defined variables are defined      ####
####                                                                        ####
################################################################################
################################################################################

STAGE_NAME ?= $(error STAGE_NAME is not defined)
STAGE_NUMBER ?= $(error STAGE_NUMBER is not defined)
EXPERIMENT_DIR ?= $(error EXPERIMENT_DIR is not defined)
TRAINING_SRC ?= $(error TRAINING_SRC is not defined)
TRAINING_TGT ?= $(error TRAINING_TGT is not defined)
TRAINING_ALIGN ?= $(error TRAINING_ALIGN is not defined)
TEST_SRC ?= $(error TEST_SRC is not defined)
HIERO_DIR ?= $(error HIERO_DIR is not defined)


################################################################################
################################################################################
####                                                                        ####
####                        Derived Variables                               ####
####                                                                        ####
################################################################################
################################################################################

TEST_NAME := $(notdir ${TEST_SRC})
RESULTS_DIR ?= ${EXPERIMENT_DIR}/${STAGE_NUMBER}.${STAGE_NAME}
SUFFIX_ARRAY := ${RESULTS_DIR}/sa_bin




################################################################################
################################################################################
####                                                                        ####
####                          Make targets                                  ####
####                                                                        ####
################################################################################
################################################################################


${RESULTS_DIR}/${TEST_NAME}.grammar: ${RESULTS_DIR}/${TEST_NAME}.ini | ${RESULTS_DIR} ${HIERO_DIR}/hiero/decoder.py
	cat ${TEST_SRC} | ${HIERO_DIR}/hiero/decoder.py -c $< -x $@

${SUFFIX_ARRAY} ${RESULTS_DIR}/${TEST_NAME}.ini: ${TRAINING_SRC} ${TRAINING_TGT} ${TRAINING_ALIGN} | ${RESULTS_DIR} ${HIERO_DIR}/sa-utils/compile_files.pl ${HIERO_DIR}/sa-utils/decoder.extract.ini
	${HIERO_DIR}/sa-utils/compile_files.pl ${TRAINING_SRC} ${TRAINING_TGT} ${TRAINING_ALIGN} /dev/null ${HIERO_DIR}/sa-utils/decoder.extract.ini ${SUFFIX_ARRAY} > ${RESULTS_DIR}/${TEST_NAME}.ini

${RESULTS_DIR}:
	mkdir -p $@
