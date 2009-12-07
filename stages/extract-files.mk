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



# Calculate the directory where this make file is stored
PATH.TO.THIS.MAKEFILE:=$(dir $(lastword ${MAKEFILE_LIST}))


# Include common make file
#
# This verifies that common required variables are defined
include ${PATH.TO.THIS.MAKEFILE}/_common.mk

ARCHIVE_FILE ?= $(error ARCHIVE_FILE must be defined to the bare filename of a tgz file located in ${PREREQ_DIR}.)

FILES_TO_EXTRACT ?= $(error FILES_TO_EXTRACT must be defined to the files that should be extracted from ${ARCHIVE_FILE}.)


ARCHIVE:=${PREREQ_DIR}/$(notdir ${ARCHIVE_FILE})

TAR_WILDCARDS:=$(foreach file,${FILES_TO_EXTRACT},'${file}')

$(info Reading manifest to extract from ${ARCHIVE})
$(if $(wildcard ${RESULT_DIR}.manifest),,$(shell tar -f ${ARCHIVE} --list --wildcards ${TAR_WILDCARDS} > ${RESULT_DIR}.manifest))
TAR_FILES:=$(shell cat ${RESULT_DIR}.manifest)

ALL_EXTRACTED_FILES:=$(foreach file,${TAR_FILES},${RESULT_DIR}/${file})

#$(info TAR_FILES=${TAR_FILES})
#$(info FILES_TO_EXTRACT=${FILES_TO_EXTRACT})
#$(foreach part,${FILES_TO_EXTRACT},$(info ${part}))
#$(info Here we go: ${ALL_EXTRACTED_FILES})

all: ${ALL_EXTRACTED_FILES} | ${ARCHIVE} ${RESULT_DIR}

#${RESULT_DIR}.manifest: | $(dir $@)
#	tar -f ${ARCHIVE} --list --wildcards ${TAR_WILDCARDS} > $@

${RESULT_DIR}:
	mkdir -p $@

${ALL_EXTRACTED_FILES}:  | ${ARCHIVE} ${RESULT_DIR} ${RESULT_DIR}.manifest
	tar xfvz ${ARCHIVE} -C ${RESULT_DIR} --wildcards ${TAR_WILDCARDS}