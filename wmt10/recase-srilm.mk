# Calculate the full path to this make file
THIS.MAKEFILE:= $(realpath $(lastword ${MAKEFILE_LIST}))

# Define how to run this file
define USAGE
	$(info  )
	$(info Usage:	make -f ${THIS.MAKEFILE} SRILM_NGRAM_COUNT=/path/to/ngram-count TGT=tgtlang LM_TRAINING_DIR=/path/to/data LM_TRAINING_FILE_NAMES=fileNamesWithoutPath LM_NGRAM_ORDER=n RECASE_SRILM_DIR=/path/to/output trainLM)
	$(info  )
	$(error )
endef


# If a required parameter is not defined,
#    print usage, then exit
SRILM_NGRAM_COUNT ?= $(call USAGE)
TGT ?= $(call USAGE)
RECASE_SRILM_TRAINING_DIR ?= $(call USAGE)
RECASE_SRILM_TRAINING_FILE_NAMES ?= $(call USAGE)
LM_NGRAM_ORDER ?= $(call USAGE)
RECASE_SRILM_DIR ?= $(call USAGE)


# Gather training file names with full path
RECASE_SRILM_TRAINING_FILES:=$(foreach file,${RECASE_SRILM_TRAINING_FILE_NAMES},$(abspath ${RECASE_SRILM_TRAINING_DIR}/${file}))

# Convenient target
build-recase-srilm: ${RECASE_SRILM_DIR}/${TGT}.lm

# Build language model
${RECASE_SRILM_DIR}/${TGT}.lm: ${RECASE_SRILM_DIR}/monolingual.${TGT} | ${SRILM_NGRAM_COUNT} ${RECASE_SRILM_DIR}
	${SRILM_NGRAM_COUNT} -order ${LM_NGRAM_ORDER} -interpolate -kndiscount -text $< -lm $@

# Concatenate the monolingual training files
${RECASE_SRILM_DIR}/monolingual.${TGT}: ${RECASE_SRILM_TRAINING_FILES} ${RECASE_SRILM_DIR}/monolingual.${TGT}.manifest | ${RECASE_SRILM_DIR}
	cat $^ > $@

# Save the file names used
${RECASE_SRILM_DIR}/monolingual.${TGT}.manifest: | ${RECASE_SRILM_DIR}
	for fileName in ${RECASE_SRILM_TRAINING_FILES}; do echo $$fileName >> $@; done

# Make output directory
${RECASE_SRILM_DIR}:
	mkdir -p $@


# These targets don't actually build files with those names
.PHONY: usage build-recase-srilm
