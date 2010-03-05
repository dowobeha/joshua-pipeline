# Calculate the full path to this make file
THIS.MAKEFILE:= $(realpath $(lastword ${MAKEFILE_LIST}))

# Define how to run this file
define USAGE
	$(info  )
	$(info Usage:	make -f ${THIS.MAKEFILE} SRC=srcLang TGT=tgtLang EXTRACT_RULES_JVM_FLAGS=flags SUBSAMPLED_DATA=/path/to/dir BERKELEY_ALIGN_DIR=/path/to/dir JOSHUA=/path/to/joshua EXTRACT_RULES_DIR=/path/to/dir extract-rules)
	$(info  )
	$(error )
endef


# If any of these required parameters are not defined,
#    print usage, then exit
HIERO_DIR ?= $(call USAGE)
TGT ?= $(call USAGE)
RECASING_CORPUS_ALIGNMENTS_DIR ?= $(call USAGE)


SUBSAMPLED_DATA ?= $(call USAGE)
BERKELEY_ALIGN_DIR ?= $(call USAGE)
EXTRACT_RULES_DIR ?= $(call USAGE)



EXTRACTED_GRAMMAR:=${EXTRACT_RULES_DIR}/${SRC}-${TGT}.grammar

# Convenient target
extract-grammar: ${EXTRACTED_GRAMMAR}
all: extract-grammar



SUFFIX_ARRAY := ${EXTRACT_RULES_DIR}/sa_bin

# Extract grammar
${EXTRACTED_GRAMMAR}: ${EXTRACT_RULES_DIR}/${SRC}-${TGT}.ini ${SUBSAMPLED_DATA}/combined.test.${SRC} | ${EXTRACT_RULES_DIR}
	time cat ${SUBSAMPLED_DATA}/combined.test.${SRC} | ${HIERO_DIR}/hiero/decoder.py -c $< -x $@

# Compile corpus
${SUFFIX_ARRAY} ${EXTRACT_RULES_DIR}/${SRC}-${TGT}.ini: ${BERKELEY_ALIGN_DIR}/alignments/training.${SRC} ${BERKELEY_ALIGN_DIR}/alignments/training.${TGT}  ${BERKELEY_ALIGN_DIR}/alignments/training.align ${SUBSAMPLED_DATA}/combined.test.${SRC} | ${EXTRACT_RULES_DIR}
	time ${HIERO_DIR}/sa-utils/compile_files.pl \
		${BERKELEY_ALIGN_DIR}/alignments/training.${SRC} \
		${BERKELEY_ALIGN_DIR}/alignments/training.${TGT} \
		${BERKELEY_ALIGN_DIR}/alignments/training.align  \
		/dev/null \
		${HIERO_DIR}/sa-utils/decoder.extract.ini \
		${SUFFIX_ARRAY} > ${EXTRACT_RULES_DIR}/${SRC}-${TGT}.ini


# Create directory
${EXTRACT_RULES_DIR}:
	mkdir -p $@


