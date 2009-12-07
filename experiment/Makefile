# Welcome to GALE. We hope you have a pleasant stay.
$(info This file is for running the JHU GALE toy Arabic-English SMT system.)
$(info )

# Calculate the directory where this make file is stored
PATH.TO.THIS.MAKEFILE ?= $(realpath $(dir $(lastword ${MAKEFILE_LIST})))



#################################################################################
####                                                                         ####
####                  Experiment-specific variables                          ####
####                                                                         ####
#################################################################################


# Define where other make files are stored
MAKE_DIR:=/home/lane/pipeline/stages

# Export this variable to make it visible to the make files called below.
export SCRIPTS_DIR:=/home/lane/pipeline/scripts

# Define where experimental results should be stored
#
# The following line says to use the dir where this make file is located:
export EXPERIMENT_DIR:=${PATH.TO.THIS.MAKEFILE}

export JOSHUA:=/scratch/lane/joshua
export JOSHUA_MEMORY_FLAGS:=-XX:MinHeapFreeRatio=10 -Xms50g -Xmx100g
export JOSHUA_THREADS:=20

export MBR_MEMORY_FLAGS:=-XX:MinHeapFreeRatio=10 -Xms2g -Xmx2g
export MBR_THREADS:=20

export MERT_JVM_FLAGS:=-Xms3g -Xmx3g

#export LM_FILE:=/scratch/lane/2009-11-09_subsampled.berkeley_alignments.mert/mert.berkeley.hiero.nw/giga_v4+p4.kn5.gz
#export LM_ORDER:=5

export LM_FILE:=${JOSHUA}/example/example.trigram.lm.gz
export LM_ORDER:=3

#################### Training archive ###########################################

# Define the original training tgz archive
export ARCHIVE_FILE=Rosetta-P4-ae-training-data-FOUO-v1.0.tgz 

# Define the files to extract from the original tgz archive 
#export FILES_TO_EXTRACT="arfiles/atb/*.filtered* enfiles/tok/*.filtered*"
export FILES_TO_EXTRACT=arfiles/atb/xin.ar.filtered arfiles/atb/afp.ar.filtered enfiles/tok/xin.en.filtered enfiles/tok/afp.en.filtered

export MANIFEST=xin afp



# Define where Hiero is installed
export HIERO_DIR:=/home/zli/work/hiero/copy_2008/sa_copy/sa-hiero_adapted

# Define how many parts to split into
export SPLIT_SIZE:=10

# Define what files need to be translated
#FILES_TO_TRANSLATE:=$(wildcard /scratch/lane/gale/02.remove-all-initial-W.test.ar/*)

# Define a make function
#    that defines how to extract rules for a file to translate
#
# This function takes 1 argument - the file to translate
#define EXTRACT_TEMPLATE
#	$(MAKE) -f ${MAKE_DIR}/extract-rules.mk -j ${SPLIT_SIZE} STAGE_NUMBER=05 STAGE_NAME=extract-rules TRAINING_SRC=${EXPERIMENT_DIR}/04.berkeley-align/training/subsampled.ar TRAINING_TGT=${EXPERIMENT_DIR}/04.berkeley-align/training/subsampled.en TRAINING_ALN=${EXPERIMENT_DIR}/04.berkeley-align/alignments/training.en-ar.align FILE_TO_TRANSLATE=$1
#endef

all:
#
#	Extract training files from IBM archive file
	$(MAKE) -f ${MAKE_DIR}/extract-files.mk -j 1 STAGE_NUMBER=00 STAGE_NAME=extract_from_IBM PREREQ_DIR=/scratch/OriginalFiles
#
#	Create nicely-named links to the training files
	$(MAKE) -f ${MAKE_DIR}/rename.mk STAGE_NUMBER=00 STAGE_NAME=extract_from_IBM.ar PREREQ_DIR=${EXPERIMENT_DIR}/00.extract_from_IBM/arfiles/atb
	$(MAKE) -f ${MAKE_DIR}/rename.mk STAGE_NUMBER=00 STAGE_NAME=extract_from_IBM.en PREREQ_DIR=${EXPERIMENT_DIR}/00.extract_from_IBM/enfiles/tok
#
#	Preprocess training data
	$(MAKE) -f ${MAKE_DIR}/preprocessed.mk STAGE_NUMBER=00 STAGE_NAME=preprocess.training.ar PREREQ_DIR=${EXPERIMENT_DIR}/00.extract_from_IBM.ar
	$(MAKE) -f ${MAKE_DIR}/preprocessed.mk STAGE_NUMBER=00 STAGE_NAME=preprocess.training.en PREREQ_DIR=${EXPERIMENT_DIR}/00.extract_from_IBM.en
#
#	Remove sentence-initial W- from Arabic training files
	$(MAKE) -f ${MAKE_DIR}/remove-all-initial-W.mk STAGE_NUMBER=01 STAGE_NAME=remove-all-initial-W.training.ar PREREQ_DIR=${EXPERIMENT_DIR}/00.preprocess.training.ar
#
#
#	Extract MT06 test file from IBM archive file
	$(MAKE) -f ${MAKE_DIR}/extract-test.mk STAGE_NUMBER=02 STAGE_NAME=extract_test_from_IBM.ar IBM_ARCHIVE=/scratch/OriginalFiles/Rosetta-P4-ae-testsets-v1.1.tgz SGM_FILE=tok-v3-a/mt06_arabic_evlset_nist_part_v1.reforder.tok-v3.sgm
#	Extract NW test files from IBM archive file
	$(MAKE) -f ${MAKE_DIR}/extract-test.mk STAGE_NUMBER=02 STAGE_NAME=extract_test_from_IBM.ar IBM_ARCHIVE=/scratch/OriginalFiles/GALE-P4-Rosetta-DryRun-Text.tgz SGM_FILE=arabic/source/ready-for-mt-atb-v3.1/GALE-DEV09-arabic-text-nw-dev.atb-v3.1.unk.split.sgm
	$(MAKE) -f ${MAKE_DIR}/extract-test.mk STAGE_NUMBER=02 STAGE_NAME=extract_test_from_IBM.ar IBM_ARCHIVE=/scratch/OriginalFiles/GALE-P4-Rosetta-DryRun-Text.tgz SGM_FILE=arabic/source/ready-for-mt-atb-v3.1/GALE-DEV09-arabic-text-nw-tune.atb-v3.1.unk.split.sgm
	$(MAKE) -f ${MAKE_DIR}/extract-test.mk STAGE_NUMBER=02 STAGE_NAME=extract_test_from_IBM.ar IBM_ARCHIVE=/scratch/OriginalFiles/GALE-P4-Rosetta-DryRun-Text.tgz SGM_FILE=arabic/source/ready-for-mt-atb-v3.1/GALE-DEV09test+P3unseq-arabic-text-nw.atb-v3.1.unk.split.sgm
	$(MAKE) -f ${MAKE_DIR}/extract-test.mk STAGE_NUMBER=02 STAGE_NAME=extract_test_from_IBM.ar IBM_ARCHIVE=/scratch/OriginalFiles/GALE-P4-Rosetta-DryRun-Text.tgz SGM_FILE=arabic/source/ready-for-mt-atb-v3.1/mt08_arabic_evalset_current_v0-nw.atb-v3.1.unk.split.sgm
#	Extract WB test files from IBM archive file
	$(MAKE) -f ${MAKE_DIR}/extract-test.mk STAGE_NUMBER=02 STAGE_NAME=extract_test_from_IBM.ar IBM_ARCHIVE=/scratch/OriginalFiles/GALE-P4-Rosetta-DryRun-Text.tgz SGM_FILE=arabic/source/ready-for-mt-atb-v3.1/GALE-DEV09-arabic-text-wb-dev.spell.atb-v3.1.unk.split.sgm
	$(MAKE) -f ${MAKE_DIR}/extract-test.mk STAGE_NUMBER=02 STAGE_NAME=extract_test_from_IBM.ar IBM_ARCHIVE=/scratch/OriginalFiles/GALE-P4-Rosetta-DryRun-Text.tgz SGM_FILE=arabic/source/ready-for-mt-atb-v3.1/GALE-DEV09-arabic-text-wb-tune.spell.atb-v3.1.unk.split.sgm
	$(MAKE) -f ${MAKE_DIR}/extract-test.mk STAGE_NUMBER=02 STAGE_NAME=extract_test_from_IBM.ar IBM_ARCHIVE=/scratch/OriginalFiles/GALE-P4-Rosetta-DryRun-Text.tgz SGM_FILE=arabic/source/ready-for-mt-atb-v3.1/GALE-DEV09test+DEV08-arabic-text-wb.spell.atb-v3.1.unk.split.sgm
	$(MAKE) -f ${MAKE_DIR}/extract-test.mk STAGE_NUMBER=02 STAGE_NAME=extract_test_from_IBM.ar IBM_ARCHIVE=/scratch/OriginalFiles/GALE-P4-Rosetta-DryRun-Text.tgz SGM_FILE=arabic/source/ready-for-mt-atb-v3.1/mt08_arabic_evalset_current_v0-wb.spell.atb-v3.1.unk.split.sgm
#
#	Extract reference files from IBM archive file
	$(MAKE) -f ${MAKE_DIR}/extract-test.mk STAGE_NUMBER=02 STAGE_NAME=extract_test_from_IBM.en IBM_ARCHIVE=/scratch/OriginalFiles/GALE-P4-Rosetta-DryRun-Text.tgz SGM_FILE=scoring/refs/arabic/GALE-DEV09-arabic-text-nw-tune.ref.sgm
	$(MAKE) -f ${MAKE_DIR}/extract-test.mk STAGE_NUMBER=02 STAGE_NAME=extract_test_from_IBM.en IBM_ARCHIVE=/scratch/OriginalFiles/GALE-P4-Rosetta-DryRun-Text.tgz SGM_FILE=scoring/refs/arabic/GALE-DEV09-arabic-text-wb-tune.ref.sgm
#
#	Preprocess test files
	$(MAKE) -f ${MAKE_DIR}/preprocess-test.mk STAGE_NUMBER=02 STAGE_NAME=preprocess.test.ar PREREQ_DIR=${EXPERIMENT_DIR}/02.extract_test_from_IBM.ar
	$(MAKE) -f ${MAKE_DIR}/preprocess-test.mk STAGE_NUMBER=02 STAGE_NAME=preprocess.test.en PREREQ_DIR=${EXPERIMENT_DIR}/02.extract_test_from_IBM.en
#
#	Remove sentence-initial W- from Arabic test files
	$(MAKE) -f ${MAKE_DIR}/remove-all-initial-W.mk STAGE_NUMBER=02 STAGE_NAME=remove-all-initial-W.test.ar PREREQ_DIR=${EXPERIMENT_DIR}/02.preprocess.test.ar
#
#	Perform subsampling
	$(MAKE) -f ${MAKE_DIR}/subsample.mk STAGE_NUMBER=03 STAGE_NAME=subsample SRC=ar TGT=en PREREQ_DIR_TEST=${EXPERIMENT_DIR}/02.remove-all-initial-W.test.ar PREREQ_DIR_SRC=${EXPERIMENT_DIR}/01.remove-all-initial-W.training.ar PREREQ_DIR_TGT=${EXPERIMENT_DIR}/00.preprocess.training.en
#
#	Perform Berkeley alignment
	$(MAKE) -f ${MAKE_DIR}/berkeley-align.mk STAGE_NUMBER=04 STAGE_NAME=berkeley-align PREREQ_DIR=${EXPERIMENT_DIR}/03.subsample SRC=ar TGT=en BERKELEY_ALIGNER_JAR=${EXPERIMENT_DIR}/berkeleyaligner.jar
#
#	Extract grammar 
	$(MAKE) -f ${MAKE_DIR}/extract-rules-hiero.mk STAGE_NUMBER=05 STAGE_NAME=hiero-extract-rules TRAINING_SRC=${EXPERIMENT_DIR}/04.berkeley-align/training/subsampled.ar TRAINING_TGT=${EXPERIMENT_DIR}/04.berkeley-align/training/subsampled.en TRAINING_ALIGN=${EXPERIMENT_DIR}/04.berkeley-align/alignments/training.en-ar.align TEST_SRC=${EXPERIMENT_DIR}/03.subsample/subsample.test.ar
#
#	Run MERT for NW
	$(MAKE) -f ${MAKE_DIR}/mert.mk STAGE_NUMBER=06 STAGE_NAME=mert.nw TM_GRAMMAR=${EXPERIMENT_DIR}/05.hiero-extract-rules/subsample.test.ar.grammar FILE_TO_TRANSLATE=${EXPERIMENT_DIR}/02.preprocess.test.ar/GALE-DEV09-arabic-text-nw-tune.atb-v3.1.unk.split NUM_REFERENCES=1 REFERENCE_BASE=02.preprocess.test.en/GALE-DEV09-arabic-text-nw-tune.ref
#
#	Translate!
	$(MAKE) -f ${MAKE_DIR}/decode.mk STAGE_NUMBER=07 STAGE_NAME=decode.nw \
		FILE_TO_TRANSLATE=${EXPERIMENT_DIR}/02.preprocess.test.ar/GALE-DEV09-arabic-text-nw-dev.atb-v3.1.unk.split \
		JOSHUA_CONFIG=06.mert.nw/joshua.config.ZMERT.final

cleanest:
	@clear
#	rm -rf $(wildcard [0-9][0-9].*)
	rm -rf $(shell ls -dp */)
	@pwd
	@ls

.PHONY: all
