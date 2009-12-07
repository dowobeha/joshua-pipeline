################################################################################
################################################################################
####                                                                        ####
####                      Preprocessing make file                           ####
####                                                                        ####
################################################################################
################################################################################

$(info )
$(info This make file defines:)
$(info --- how to preprocess test files)
$(info )


SCRIPT_NAME := preprocess.pl
SCRIPTS_DIR ?= $(error SCRIPTS_DIR must be defined)
SCRIPT ?= ${SCRIPTS_DIR}/${SCRIPT_NAME}

# Define a shortcut to run the script
define run
${SCRIPT} $< $@
endef

EXPERIMENT_DIR ?= $(error EXPERIMENT_DIR is not defined)
STAGE_NAME ?= $(error STAGE_NAME is not defined)
STAGE_NUMBER ?= $(error STAGE_NUMBER is not defined)

TEST_OUTPUT_DIR ?= ${EXPERIMENT_DIR}/${STAGE_NUMBER}.${STAGE_NAME}

SUFFIX ?= .sgm

PREREQ_DIR ?= $(error PREREQ_DIR is not defined)
SGM_FILES ?= $(wildcard ${PREREQ_DIR}/*.sgm)

###############################################
# Calculate the list of files to create.....  #
###############################################
#
# Strip off the last suffix from each SGM file
SGM_FILENAMES_WITHOUT_SUFFIX:=$(basename ${SGM_FILES})
#
#$(info SGM_FILENAMES_WITHOUT_SUFFIX=${SGM_FILENAMES_WITHOUT_SUFFIX})
#$(info PREREQ_DIR=${PREREQ_DIR})

# Replace the directory part
FILES_TO_CREATE ?= $(foreach path,${SGM_FILENAMES_WITHOUT_SUFFIX},${TEST_OUTPUT_DIR}/$(notdir ${path}))

#$(info TEST_OUTPUT_DIR=${TEST_OUTPUT_DIR})
#$(info Files to create - ${FILES_TO_CREATE})

all: ${FILES_TO_CREATE}

.PHONY: all


${TEST_OUTPUT_DIR}:
	mkdir -p $@

${TEST_OUTPUT_DIR}/%: ${PREREQ_DIR}/%${SUFFIX} | ${TEST_OUTPUT_DIR}
	$(run)
