# Calculate the full path to this make file
THIS.MAKEFILE:= $(realpath $(lastword ${MAKEFILE_LIST}))

# Define how to run this file
define USAGE
	$(info  )
	$(info Usage:	make -f ${THIS.MAKEFILE} SRC=srcLang TGT=tgtLang BERKELEYALIGNER=/path/to/dir BERKELEY_NUM_THREADS=numThreads BERKELEY_JVM_FLAGS=flags SUBSAMPLED_DATA=/path/to/dir BERKELEY_ALIGN_DIR=/path/to/results berkeley-aligner)
	$(info  )
	$(error )
endef


# If any of these required parameters are not defined,
#    print usage, then exit
BERKELEYALIGNER ?= $(call USAGE)
BERKELEY_NUM_THREADS ?= $(call USAGE)
BERKELEY_ALIGN_DIR ?= $(call USAGE)
BERKELEY_JVM_FLAGS ?= $(call USAGE)
SUBSAMPLED_DATA ?= $(call USAGE)
SRC ?= $(call USAGE)
TGT ?= $(call USAGE)

# If the user does not specify a target, print out how to run this file
usage:
	$(call USAGE)

# Convenient target
berkeley-align: ${BERKELEY_ALIGN_DIR}/alignments/training.align

# Run Berkeley aligner
${BERKELEY_ALIGN_DIR}/alignments/training.align: ${BERKELEY_ALIGN_DIR}/berkeley.aligner.config ${SUBSAMPLED_DATA}/subsampled/subsample.${SRC} ${SUBSAMPLED_DATA}/subsampled/subsample.${TGT}
	java ${BERKELEY_JVM_FLAGS} -jar ${BERKELEYALIGNER}/berkeleyaligner.jar ++${BERKELEY_ALIGN_DIR}/berkeley.aligner.config

# Create directory
${BERKELEY_ALIGN_DIR}:
	mkdir -p $@


##############################
### CREATE BERKELEY CONFIG ###
##############################
${BERKELEY_ALIGN_DIR}/berkeley.aligner.config: | ${BERKELEY_ALIGN_DIR}
	@echo "## In this configuration the Berkeley aligner uses two HMM" > $@
	@echo "## alignment models trained jointly and then decoded" >> $@
	@echo "## using the competitive thresholding heuristic." >> $@
	@echo "" >> $@
	@echo "##########################################" >> $@
	@echo "# Training: Defines the training regimen" >> $@
	@echo "##########################################" >> $@
	@echo "" >> $@
	@echo "forwardModels	MODEL1 HMM" >> $@
	@echo "reverseModels	MODEL1 HMM" >> $@
	@echo "mode	JOINT JOINT" >> $@
	@echo "iters	5 5" >> $@
	@echo "" >> $@
	@echo "###############################################" >> $@
	@echo "# Execution: Controls output and program flow" >> $@
	@echo "###############################################" >> $@
	@echo "" >> $@
	@echo "execDir	${BERKELEY_ALIGN_DIR}/alignments" >> $@
	@echo "create" >> $@
	@echo "saveParams	true" >> $@
	@echo "numThreads	${BERKELEY_NUM_THREADS}" >> $@
	@echo "msPerLine	10000" >> $@
	@echo "alignTraining" >> $@
	@echo "" >> $@
	@echo "#################" >> $@
	@echo "# Language/Data" >> $@
	@echo "#################" >> $@
	@echo "" >> $@
	@echo "foreignSuffix	${SRC}" >> $@
	@echo "englishSuffix	${TGT}" >> $@
	@echo "" >> $@
	@echo "# Tell aligner we don't have any test files" >> $@
	@echo "testSources	/dev/null" >> $@
	@echo "" >> $@
	@echo "# Choose the training sources, which can either be directories or files that list files/directories" >> $@
	@echo "trainSources	${SUBSAMPLED_DATA}/subsampled" >> $@
	@echo "sentences	MAX" >> $@
	@echo "" >> $@
	@echo "#################" >> $@
	@echo "# 1-best output" >> $@
	@echo "#################" >> $@
	@echo "" >> $@
	@echo "competitiveThresholding" >> $@
