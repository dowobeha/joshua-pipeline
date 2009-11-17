################################################################################
################################################################################
####                                                                        ####
####                    File extraction make file                           ####
####                                                                        ####
################################################################################
################################################################################

$(info )
$(info This make file defines:)
$(info --- how to extract data to translate from the IBM compressed file archives)
$(info )


EXPERIMENT_DIR ?= $(error The EXPERIMENT_DIR variable is not defined. Please define it to point to the directory where the experimental results will go.) 
STAGE_NUMBER ?= $(error The STAGE_NUMBER variable is not defined.)
STAGE_NAME ?= $(error The STAGE_NAME variable is not defined.)

IBM_ARCHIVE ?= $(error The IBM_ARCHIVE variable is not defined.)
SGM_FILE ?= $(error The SGM_FILE variable is not defined.)


RESULT_DIR ?= ${EXPERIMENT_DIR}/${STAGE_NUMBER}.${STAGE_NAME}
$(info RESULT_DIR=${RESULT_DIR})

#all: ${RESULT_DIR}/$(notdir ${SGM_FILE})

#.PHONY: all

#$(info Need to build ${RESULT_DIR}/$(notdir ${SGM_FILE}))

${RESULT_DIR}/$(notdir ${SGM_FILE}): ${RESULT_DIR}/extracted/${SGM_FILE} | ${RESULT_DIR}
	ln -s ${RESULT_DIR}/extracted/${SGM_FILE} $@

${RESULT_DIR}/extracted/${SGM_FILE}: | ${IBM_ARCHIVE} ${RESULT_DIR}/extracted
	tar xvzf ${IBM_ARCHIVE} -C ${RESULT_DIR}/extracted ${SGM_FILE}

${RESULT_DIR}/extracted: | ${RESULT_DIR}
	mkdir -p $@

${RESULT_DIR}:
	mkdir -p $@
