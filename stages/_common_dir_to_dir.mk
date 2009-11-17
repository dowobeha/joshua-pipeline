# Calculate the directory where this make file is stored
PATH.TO.THIS.MAKEFILE ?= $(dir $(lastword ${MAKEFILE_LIST}))

include ${PATH.TO.THIS.MAKEFILE}/_common.mk



################################################################################
################################################################################
####                                                                        ####
####      Verify that all required, user-defined functions are defined      ####
####                                                                        ####
################################################################################
################################################################################

run ?= $(error The function - run - has not been defined, so the ${STAGE} stage cannot be run. Please define this function.)



################################################################################
################################################################################
####                                                                        ####
####                          Make targets                                  ####
####                                                                        ####
################################################################################
################################################################################

RESULTS_TO_BUILD:=$(patsubst %,${RESULT_DIR}/%,$(patsubst ${PREREQ_DIR}/%,%,$(wildcard ${PREREQ_DIR}/*)))

all: ${RESULTS_TO_BUILD}


${RESULT_DIR}:
	mkdir -p $@

${RESULT_DIR}/%: ${PREREQ_DIR}/% | ${RESULT_DIR}
	$(run)


################################################################################
################################################################################
####                                                                        ####
####                   Misc make house-keeping                              ####
####                                                                        ####
################################################################################
################################################################################

# No actual file by this name is created.
# Run this target even if there's a file by this name that exists.
#
# See section 4.5 Phony Targets of the GNU Make Manual.
#
.PHONY: all
