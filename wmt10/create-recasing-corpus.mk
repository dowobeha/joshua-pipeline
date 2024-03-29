# Calculate the full path to this make file
THIS.MAKEFILE:= $(realpath $(lastword ${MAKEFILE_LIST}))
THIS.MAKEFILE.DIR:=$(dir ${THIS.MAKEFILE})

# Define how to run this file
define USAGE
	$(info  )
	$(info Usage:	make -f ${THIS.MAKEFILE} )
	$(info  )
	$(error )
endef


# If this required parameter is not defined,
#    print usage, then exit
RECASING_CORPUS_DIR ?= $(call USAGE)
TOKENIZED_DATA ?= $(call USAGE)
SUBSAMPLER_MANIFEST ?= $(call USAGE)
TGT ?= $(call USAGE)

RECASING_FILES:=$(foreach suffix,truecase lowercase,$(foreach file,${SUBSAMPLER_MANIFEST},${RECASING_CORPUS_DIR}/${file}.${TGT}.${suffix}))

recasing-corpus: ${RECASING_FILES}
all: recasing-corpus


# Create link for source file
${RECASING_CORPUS_DIR}/%.${TGT}.truecase: ${TOKENIZED_DATA}/%.${TGT} | ${RECASING_CORPUS_DIR}
	ln -fs $< $@

# Create lowercase file
${RECASING_CORPUS_DIR}/%.${TGT}.lowercase: ${TOKENIZED_DATA}/%.${TGT} | ${RECASING_CORPUS_DIR} ${THIS.MAKEFILE.DIR}/create-recasing-corpus.perl
	${THIS.MAKEFILE.DIR}/create-recasing-corpus.perl $< $@


# Create directory
${RECASING_CORPUS_DIR}:
	mkdir -p $@
