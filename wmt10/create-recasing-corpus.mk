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
SRC ?= $(call USAGE)
TGT ?= $(call USAGE)

RECASING_FILES:=$(foreach lang,${SRC} ${TGT},$(foreach file,${SUBSAMPLER_MANIFEST},${RECASING_CORPUS_DIR}/${file}.${lang}))

recasing-corpus: ${RECASING_FILES}
all: recasing-corpus

$(info ${RECASING_FILES})


# Create link for source file
${RECASING_CORPUS_DIR}/%.${SRC}: ${TOKENIZED_DATA}/%.${SRC} | ${RECASING_CORPUS_DIR}
	ln -fs $< $@

# Create lowercase file
${RECASING_CORPUS_DIR}/%.${TGT}: ${TOKENIZED_DATA}/%.${TGT} | ${RECASING_CORPUS_DIR} ${THIS.MAKEFILE.DIR}/create-recasing-corpus.perl
	${THIS.MAKEFILE.DIR}/create-recasing-corpus.perl $< $@


# Create directory
${RECASING_CORPUS_DIR}:
	mkdir -p $@
