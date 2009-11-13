SCRIPTS_DIR ?= $(error The SCRIPTS_DIR variable is not defined. Please define it to point to the scripts directory, then try again.)

SCRIPT = $(abspath ${SCRIPTS_DIR}/${SCRIPT_NAME})

ifeq (${SCRIPT},)
$(error ${SCRIPTS_DIR}/${SCRIPT_NAME} does not exist. Cannot proceed with ${STAGE}.)
endif


PREREQ_DIR ?= $(error THE PREREQ_DIR variable is not defined. Please define it to point to the directory where the prerequisite files are located.)

ifeq ($(abspath ${PREREQ_DIR}),)
$(error ${PREREQ_DIR} does not exist. Please define it to point to the directory where the prerequisite files are located.)
endif

RESULT_DIR := ${PREREQ_DIR}.${STAGE}

run ?= $(error The function - run - has not been defined, so the ${STAGE} stage cannot be run. Please define this function.)

.PHONY: all

all: $(patsubst %,${RESULT_DIR}/%,$(patsubst ${PREREQ_DIR}/%,%,$(wildcard ${PREREQ_DIR}/*)))


${RESULT_DIR}:
	mkdir -p $@

${RESULT_DIR}/%: ${PREREQ_DIR}/% | ${RESULT_DIR}
	$(run)

define log
@echo "`date -u +"%Y-%m-%d %H:%M:%S %Z"`             ${1}"
endef
