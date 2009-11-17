################################################################################
################################################################################
####                                                                        ####
####                    Make file for common functions                      ####
####                                                                        ####
################################################################################
################################################################################

$(info )
$(info Including make file for common functions.)
$(info )

################################################################################
################################################################################
####                                                                        ####
####      Verify that all required, user-defined variables are defined      ####
####                                                                        ####
################################################################################
################################################################################

SCRIPTS_DIR ?= $(error The SCRIPTS_DIR variable is not defined. Please define it to point to the scripts directory, then try again.)
PREREQ_DIR ?= $(error The PREREQ_DIR variable is not defined. Please define it to point to the directory where the prerequisite files are located.)
EXPERIMENT_DIR ?= $(error The EXPERIMENT_DIR variable is not defined. Please define it to point to the directory where the experimental results will go.) 
STAGE_NUMBER ?= $(error The STAGE_NUMBER variable is not defined.)
STAGE_NAME ?= $(error The STAGE_NAME variable is not defined.)


################################################################################
################################################################################
####                                                                        ####
####                 Verify that variable values                            ####
####                        specifying required files and directories       ####
####                        have non-empty values.                          ####
####                                                                        ####
################################################################################
################################################################################

SCRIPT ?= $(abspath ${SCRIPTS_DIR}/${SCRIPT_NAME})

ifeq (${SCRIPT},)
$(error ${SCRIPTS_DIR}/${SCRIPT_NAME} does not exist. Cannot proceed with ${STAGE}.)
endif

ifeq ($(abspath ${PREREQ_DIR}),)
$(error ${PREREQ_DIR} does not exist. Please define it to point to the directory where the prerequisite files are located.)
endif

RESULT_DIR ?= ${EXPERIMENT_DIR}/${STAGE_NUMBER}.${STAGE_NAME}
$(info RESULT_DIR=${RESULT_DIR})


define log
@echo "`date -u +"%Y-%m-%d %H:%M:%S %Z"`             ${1}"
endef


