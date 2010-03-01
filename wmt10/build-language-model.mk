# Calculate the full path to this make file
THIS.MAKEFILE:= $(realpath $(lastword ${MAKEFILE_LIST}))

# Define how to run this file
define USAGE
	$(info  )
	$(info Usage:	make -f ${THIS.MAKEFILE} SRILM_NGRAM_COUNT=/path/to/ngram-count TGT=tgtlang LM_TRAINING_DIR=/path/to/data LM_TRAINING_FILE_NAMES=fileNamesWithoutPath LM_NGRAM_ORDER=n TRAINED_LM_DIR=/path/to/output trainLM)
	$(info  )
	$(error )
endef


# If a required parameter is not defined,
#    print usage, then exit
SRILM_NGRAM_COUNT ?= $(call USAGE)
TGT ?= $(call USAGE)
LM_TRAINING_DIR ?= $(call USAGE)
LM_TRAINING_FILE_NAMES ?= $(call USAGE)
LM_NGRAM_ORDER ?= $(call USAGE)
TRAINED_LM_DIR ?= $(call USAGE)


# Gather training file names with full path
LM_TRAINING_FILES:=$(foreach file,${LM_TRAINING_FILE_NAMES},$(abspath ${LM_TRAINING_DIR}/${file}))

# Convenient target
build-lm: ${TRAINED_LM_DIR}/${TGT}.lm

# Build language model
${TRAINED_LM_DIR}/${TGT}.lm: ${TRAINED_LM_DIR}/monolingual.${TGT} | ${SRILM_NGRAM_COUNT} ${TRAINED_LM_DIR}
	${SRILM_NGRAM_COUNT} -order ${LM_NGRAM_ORDER} -interpolate -kndiscount -text $< -lm $@

# Concatenate the monolingual training files
${TRAINED_LM_DIR}/monolingual.${TGT}: ${LM_TRAINING_FILES} ${TRAINED_LM_DIR}/monolingual.${TGT}.manifest | ${TRAINED_LM_DIR}
	cat $^ > $@

# Save the file names used
${TRAINED_LM_DIR}/monolingual.${TGT}.manifest: | ${TRAINED_LM_DIR}
	for fileName in ${LM_TRAINING_FILES}; do echo $$fileName >> $@; done

# Make output directory
${TRAINED_LM_DIR}:
	mkdir -p $@


# These targets don't actually build files with those names
.PHONY: usage build-lm