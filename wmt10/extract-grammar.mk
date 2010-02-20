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
JOSHUA ?= $(call USAGE)
SRC ?= $(call USAGE)
TGT ?= $(call USAGE)
SUBSAMPLED_DATA ?= $(call USAGE)
BERKELEY_ALIGN_DIR ?= $(call USAGE)
EXTRACT_RULES_DIR ?= $(call USAGE)
EXTRACT_RULES_JVM_FLAGS ?= $(call USAGE)

# If the user does not specify a target, print out how to run this file
usage:
	$(call USAGE)


COMPILED_JOSH_DIR:=${EXTRACT_RULES_DIR}/compiledCorpus.josh
EXTRACTED_GRAMMAR:=${EXTRACT_RULES_DIR}/${SRC}-${TGT}.grammar

# Convenient target
extract-grammar: ${EXTRACTED_GRAMMAR}

# Extract grammar
${EXTRACTED_GRAMMAR}: ${COMPILED_JOSH_DIR} ${EXTRACT_RULES_DIR}/extract.xml ${JOSHUA}/bin/joshua.jar ${SUBSAMPLED_DATA}/combined.test.${SRC} | ${EXTRACT_RULES_DIR}
	export ANT_OPTS=${EXTRACT_RULES_JVM_FLAGS}; \
	ant -f ${EXTRACT_RULES_DIR}/extract.xml extractGrammar

# Compile corpus
${COMPILED_JOSH_DIR}: ${EXTRACT_RULES_DIR}/extract.xml ${JOSHUA}/bin/joshua.jar ${BERKELEY_ALIGN_DIR}/alignments/training.${SRC} ${BERKELEY_ALIGN_DIR}/alignments/training.${TGT}  ${BERKELEY_ALIGN_DIR}/alignments/training.align | ${EXTRACT_RULES_DIR}
	export ANT_OPTS=${EXTRACT_RULES_JVM_FLAGS}; \
	ant -f ${EXTRACT_RULES_DIR}/extract.xml compileCorpus

# Create ant build file defining how to compile corpus and extract grammar
${EXTRACT_RULES_DIR}/extract.xml: ${JOSHUA}/bin/joshua.jar ${BERKELEY_ALIGN_DIR}/alignments/training.${SRC} ${BERKELEY_ALIGN_DIR}/alignments/training.${TGT}  ${BERKELEY_ALIGN_DIR}/alignments/training.align ${SUBSAMPLED_DATA}/combined.test.${SRC} | ${EXTRACT_RULES_DIR}
	@echo "<project name=\"Joshua grammar extraction\">" > $@
	@echo "" >> $@
	@echo "	<!-- Declare custom ant tasks for Joshua grammar extraction -->" >> $@
	@echo "	<taskdef name=\"compileJosh\" classname=\"joshua.corpus.suffix_array.Compile\" classpath=\"${JOSHUA}/bin/joshua.jar\"/>" >> $@
	@echo "	<taskdef name=\"extractRules\" classname=\"joshua.prefix_tree.ExtractRules\" classpath=\"${JOSHUA}/bin/joshua.jar\"/>" >> $@
	@echo "" >> $@
	@echo "	<!-- Define task to compile aligned parallel corpus into binary memory-mappable files -->" >> $@
	@echo "	<target name=\"compileCorpus\">" >> $@
	@echo "		<compileJosh" >> $@
	@echo "			sourceCorpus=\"${BERKELEY_ALIGN_DIR}/alignments/training.${SRC}\"" >> $@
	@echo "			targetCorpus=\"${BERKELEY_ALIGN_DIR}/alignments/training.${TGT}\"" >> $@
	@echo "			alignments=\"${BERKELEY_ALIGN_DIR}/alignments/training.align\"" >> $@
	@echo "			outputDir=\"${COMPILED_JOSH_DIR}\"" >> $@
	@echo "		/>" >> $@
	@echo "	</target>" >> $@
	@echo "" >> $@
	@echo "	<!-- Define task to extract test-set specific SCFG translation grammar -->" >> $@
	@echo "	<target name=\"extractGrammar\">" >> $@
	@echo "		<extractRules" >> $@
	@echo "			joshDir=\"${COMPILED_JOSH_DIR}\"" >> $@
	@echo "			outputFile=\"${EXTRACTED_GRAMMAR}\""  >> $@
	@echo "			testFile=\"${SUBSAMPLED_DATA}/combined.test.${SRC}\"" >> $@
	@echo "		/>" >> $@
	@echo "	</target>" >> $@
	@echo "" >> $@
	@echo "</project>" >> $@

# Create directory
${EXTRACT_RULES_DIR}:
	mkdir -p $@


# There aren't really files with these names
.PHONY: usage extract-grammar
