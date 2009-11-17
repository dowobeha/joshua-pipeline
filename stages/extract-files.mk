################################################################################
################################################################################
####                                                                        ####
####                    File extraction make file                           ####
####                                                                        ####
################################################################################
################################################################################

$(info )
$(info This make file defines:)
$(info --- how to extract training data from the IBM compressed file archive)
$(info )


SCRIPT_NAME := extract.sh

# Define a shortcut to run the script
define run
${SCRIPT} $< $@
endef



# Calculate the directory where this make file is stored
PATH.TO.THIS.MAKEFILE:=$(dir $(lastword ${MAKEFILE_LIST}))

include ${PATH.TO.THIS.MAKEFILE}/_common.mk

all: | ${RESULT_DIR}

${RESULT_DIR}:
	mkdir -p $@
	${SCRIPT} ${PREREQ_DIR} ${RESULT_DIR}
