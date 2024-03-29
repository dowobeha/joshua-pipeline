################################################################################
################################################################################
####                                                                        ####
####                             MERT make file                             ####
####                                                                        ####
################################################################################
################################################################################

$(info )
$(info This make file defines:)
$(info --- how to merge tuning data for MERT)
$(info )


################################################################################
################################################################################
####                                                                        ####
####      Verify that all required, user-defined variables are defined      ####
####                                                                        ####
################################################################################
################################################################################

EXPERIMENT_DIR ?= $(error EXPERIMENT_DIR is not defined)
STAGE_NAME ?= $(error STAGE_NAME is not defined)
STAGE_NUMBER ?= $(error STAGE_NUMBER is not defined)

FILES_TO_MERGE ?= $(error FILES_TO_MERGE is not defined)
MERGED_RESULT_NAME ?= $(error MERGED_RESULT_NAME is not defined)


################################################################################
################################################################################
####                                                                        ####
####                        Derived Variables                               ####
####                                                                        ####
################################################################################
################################################################################


RESULTS_DIR ?= ${EXPERIMENT_DIR}/${STAGE_NUMBER}.${STAGE_NAME}

MERGED_RESULT:=${RESULTS_DIR}/${MERGED_RESULT_NAME}


################################################################################
################################################################################
####                                                                        ####
####                          Make targets                                  ####
####                                                                        ####
################################################################################
################################################################################

${MERGED_RESULT}: ${FILES_TO_MERGE} | $(dir ${MERGED_RESULT})
	cat ${FILES_TO_MERGE} > $@

$(dir ${MERGED_RESULT}):
	mkdir -p $@
