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
RECASING_CORPUS_ALIGNMENTS_DIR ?= $(call USAGE)
SUBSAMPLER_MANIFEST ?= $(call USAGE)
TGT ?= $(call USAGE)

RECASING_ALIGNMENTS_FILES:=$(foreach suffix,truecase lowercase align,$(foreach file,${SUBSAMPLER_MANIFEST},${RECASING_CORPUS_ALIGNMENTS_DIR}/${file}.${TGT}.${suffix}))

recasing-corpus-align: ${RECASING_ALIGNMENTS_FILES}
all: recasing-corpus-align



${RECASING_CORPUS_ALIGNMENTS_DIR}/%.${TGT}.truecase: ${RECASING_CORPUS_DIR}/%.${TGT}.truecase | ${RECASING_CORPUS_ALIGNMENTS_DIR}
	ln -fs $< $@

${RECASING_CORPUS_ALIGNMENTS_DIR}/%.${TGT}.lowercase: ${RECASING_CORPUS_DIR}/%.${TGT}.lowercase | ${RECASING_CORPUS_ALIGNMENTS_DIR}
	ln -fs $< $@

# Create lowercase file
${RECASING_CORPUS_ALIGNMENTS_DIR}/%.${TGT}.align: ${RECASING_CORPUS_DIR}/%.${TGT}.truecase | ${RECASING_CORPUS_ALIGNMENTS_DIR} ${THIS.MAKEFILE.DIR}/create-recasing-alignments.perl
	${THIS.MAKEFILE.DIR}/create-recasing-alignments.perl $< $@


# Create directory
${RECASING_CORPUS_ALIGNMENTS_DIR}:
	mkdir -p $@
