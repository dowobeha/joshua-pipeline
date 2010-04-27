################################################################################
####                       Purpose of this make file:                       ####
####                                                                        ####
#### This file defines functions to run Berkeley aligner
####                                                                        ####
################################################################################


################################################################################
#### Function definition:              
####
#### Parameter 1 (required): BERKELEY_ALIGN_DIR
#### Parameter 2 (required): SRC
#### Parameter 3 (required): TGT
#### Parameter 4 (required): SUBSAMPLED_DATA
#### Parameter 5 (required): BERKELEYALIGNER
#### Parameter 6 (required): BERKELEY_NUM_THREADS
#### Parameter 7 (required): BERKELEY_JVM_FLAGS

define BERKELEY_ALIGN

$(if $1,,$(error Function $0: a required parameter $$1 (defining BERKELEY_ALIGN_DIR) was omitted))
$(if $2,,$(error Function $0: a required parameter $$2 (defining SRC) was omitted))
$(if $3,,$(error Function $0: a required parameter $$3 (defining TGT) was omitted))
$(if $4,,$(error Function $0: a required parameter $$4 (defining SUBSAMPLED_DATA) was omitted))
$(if $5,,$(error Function $0: a required parameter $$5 (defining BERKELEYALIGNER) was omitted))
$(if $6,,$(error Function $0: a required parameter $$6 (defining BERKELEY_NUM_THREADS) was omitted))
$(if $7,,$(error Function $0: a required parameter $$7 (defining BERKELEY_JVM_FLAGS) was omitted))


# Convenient target
all: $1/alignments/training.align

# Run Berkeley aligner
.PRECIOUS: $1/alignments/%.$2 $1/alignments/%.$3 $1/alignments/%.align
$1/alignments/%.$2 $1/alignments/%.$3 $1/alignments/%.align: $1/berkeley.aligner.config $4/subsampled/subsample.$2 $4/subsampled/subsample.$3
	java $7 -jar $5/berkeleyaligner.jar ++$1/berkeley.aligner.config

# Create directory
$1:
	mkdir -p $$@


##############################
### CREATE BERKELEY CONFIG ###
##############################
$1/berkeley.aligner.config: | $1
	@echo "## In this configuration the Berkeley aligner uses two HMM" > $$@; \
	echo "## alignment models trained jointly and then decoded" >> $$@; \
	echo "## using the competitive thresholding heuristic." >> $$@; \
	echo "" >> $$@; \
	echo "##########################################" >> $$@; \
	echo "# Training: Defines the training regimen" >> $$@; \
	echo "##########################################" >> $$@; \
	echo "" >> $$@; \
	echo "forwardModels	MODEL1 HMM" >> $$@; \
	echo "reverseModels	MODEL1 HMM" >> $$@; \
	echo "mode	JOINT JOINT" >> $$@; \
	echo "iters	5 5" >> $$@; \
	echo "" >> $$@; \
	echo "###############################################" >> $$@; \
	echo "# Execution: Controls output and program flow" >> $$@; \
	echo "###############################################" >> $$@; \
	echo "" >> $$@; \
	echo "execDir	$1/alignments" >> $$@; \
	echo "create" >> $$@; \
	echo "saveParams	true" >> $$@; \
	echo "numThreads	$6" >> $$@; \
	echo "safeConcurrency" >> $$@; \
	echo "msPerLine	10000" >> $$@; \
	echo "alignTraining" >> $$@; \
	echo "" >> $$@; \
	echo "#################" >> $$@; \
	echo "# Language/Data" >> $$@; \
	echo "#################" >> $$@; \
	echo "" >> $$@; \
	echo "foreignSuffix	$2" >> $$@; \
	echo "englishSuffix	$3" >> $$@; \
	echo "" >> $$@; \
	echo "# Tell aligner we don't have any test files" >> $$@; \
	echo "testSources	/dev/null" >> $$@; \
	echo "" >> $$@; \
	echo "# Choose the training sources, which can either be directories or files that list files/directories" >> $$@; \
	echo "trainSources	$4/subsampled" >> $$@; \
	echo "sentences	MAX" >> $$@; \
	echo "" >> $$@; \
	echo "#################" >> $$@; \
	echo "# 1-best output" >> $$@; \
	echo "#################" >> $$@; \
	echo "" >> $$@; \
	echo "competitiveThresholding" >> $$@; \


endef

####                                                                        ####
################################################################################
