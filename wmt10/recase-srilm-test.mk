# Calculate the full path to this make file
THIS.MAKEFILE:= $(realpath $(lastword ${MAKEFILE_LIST}))
THIS.MAKEFILE.DIR:=$(dir ${THIS.MAKEFILE})

# Define how to run this file
define USAGE
	$(info  )
	$(info Usage:	make -f ${THIS.MAKEFILE} SRILM_NGRAM_COUNT=/path/to/ngram-count TGT=tgtlang LM_TRAINING_DIR=/path/to/data LM_TRAINING_FILE_NAMES=fileNamesWithoutPath LM_NGRAM_ORDER=n RECASE_SRILM_DIR=/path/to/output trainLM)
	$(info  )
	$(error )
endef


# If a required parameter is not defined,
#    print usage, then exit
SRILM_DISAMBIG ?= $(call USAGE)
TGT ?= $(call USAGE)
RECASE_SRILM_TEST_DIR ?= $(call USAGE)
RECASE_SRILM_INPUT_DIR ?= $(call USAGE)
JOSHUA_TRANSLATION_OUTPUT ?= $(call USAGE)

RECASE_SRILM_TRAINING_DIR ?= $(call USAGE)
RECASE_SRILM_TRAINING_FILE_NAMES ?= $(call USAGE)
LM_NGRAM_ORDER ?= $(call USAGE)
RECASE_SRILM_DIR ?= $(call USAGE)



# Convenient target
recase-srilm-test: ${RECASE_SRILM_TEST_DIR}/${JOSHUA_TRANSLATION_OUTPUT}
all: recase-srilm-test

# Construct recasing map
${RECASE_SRILM_TEST_DIR}/recase.map: ${RECASE_SRILM_DIR}/monolingual.${TGT} ${THIS.MAKEFILE.DIR}/truecase-map.perl | ${RECASE_SRILM_TEST_DIR} 
	${THIS.MAKEFILE.DIR}/truecase-map.perl < $< > $@

# Recase output
${RECASE_SRILM_TEST_DIR}/${JOSHUA_TRANSLATION_OUTPUT}: ${RECASE_SRILM_TEST_DIR}/recase.map ${RECASE_SRILM_INPUT_DIR}/${JOSHUA_TRANSLATION_OUTPUT} | ${THIS.MAKEFILE.DIR}/strip-sent-tags.perl ${SRILM_DISAMBIG} ${RECASE_SRILM_TEST_DIR}
	${SRILM_DISAMBIG} -lm ${RECASE_SRILM_DIR}/${TGT}.lm \
		-keep-unk \
		-order ${LM_NGRAM_ORDER} \
		-map ${RECASE_SRILM_TEST_DIR}/recase.map \
		-text ${RECASE_SRILM_INPUT_DIR}/${JOSHUA_TRANSLATION_OUTPUT} \
		| ${THIS.MAKEFILE.DIR}/strip-sent-tags.perl \
		> $@

${RECASE_SRILM_TEST_DIR}:
	mkdir -p $@

# These targets don't actually build files with those names
.PHONY: usage build-recase-srilm
