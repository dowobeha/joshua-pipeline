# Welcome to GALE. We hope you have a pleasant stay.
$(info This file is for running the JHU GALE toy Arabic-English SMT system.)
$(info )

# Calculate the directory where this make file is stored
PATH.TO.THIS.MAKEFILE ?= $(realpath $(dir $(lastword ${MAKEFILE_LIST})))


# Define where other make files are stored
MAKE_DIR:=/home/lane/pipeline/stages

# Define where experimental results should be stored
#
# The following line says to use the dir where this make file is located:
export EXPERIMENT_DIR:=${PATH.TO.THIS.MAKEFILE}

# Export this variable to make it visible to the make files called below.
export SCRIPTS_DIR:=/home/lane/pipeline/scripts

# Define where Hiero is installed
export HIERO_DIR:=/home/zli/work/hiero/copy_2008/sa_copy/sa-hiero_adapted

# Define how many parts to split into
export SPLIT_SIZE:=10

# Define what files need to be translated
FILES_TO_TRANSLATE:=$(wildcard /scratch/lane/gale/02.remove-all-initial-W.test.ar/*)

# Define a make function
#    that defines how to extract rules for a file to translate
#
# This function takes 1 argument - the file to translate
define EXTRACT_TEMPLATE
	$(MAKE) -f ${MAKE_DIR}/extract-rules.mk -j ${SPLIT_SIZE} STAGE_NUMBER=05 STAGE_NAME=extract-rules TRAINING_SRC=${EXPERIMENT_DIR}/04.berkeley-align/training/subsampled.ar TRAINING_TGT=${EXPERIMENT_DIR}/04.berkeley-align/training/subsampled.en TRAINING_ALN=${EXPERIMENT_DIR}/04.berkeley-align/alignments/training.en-ar.align FILE_TO_TRANSLATE=$1
endef


all:
#	$(MAKE) -f ${MAKE_DIR}/preprocessed.mk STAGE_NUMBER=00 STAGE_NAME=preprocess.training.ar PREREQ_DIR=/scratch/lane/DATA/toy.gale/ar.training.atb.filtered
#	$(MAKE) -f ${MAKE_DIR}/preprocessed.mk STAGE_NUMBER=00 STAGE_NAME=preprocess.training.en PREREQ_DIR=/scratch/lane/DATA/toy.gale/en.training.tok.filtered
#	$(MAKE) -f ${MAKE_DIR}/remove-all-initial-W.mk STAGE_NUMBER=01 STAGE_NAME=remove-all-initial-W.training.ar PREREQ_DIR=${EXPERIMENT_DIR}/00.preprocess.training.ar
#	$(MAKE) -f ${MAKE_DIR}/berkeley-align.mk STAGE_NUMBER=04 STAGE_NAME=berkeley-align PREREQ_DIR=${EXPERIMENT_DIR}/03.subsample SRC=ar TGT=en BERKELEY_ALIGNER_JAR=${EXPERIMENT_DIR}/berkeleyaligner.jar
#	$(MAKE) -f ${MAKE_DIR}/extract-rules-hiero.mk STAGE_NUMBER=05 STAGE_NAME=hiero-extract-rules TRAINING_SRC=${EXPERIMENT_DIR}/04.berkeley-align/training/subsampled.ar TRAINING_TGT=${EXPERIMENT_DIR}/04.berkeley-align/training/subsampled.en TRAINING_ALIGN=${EXPERIMENT_DIR}/04.berkeley-align/alignments/training.en-ar.align TEST_SRC=/scratch/lane/gale/02.remove-all-initial-W.test.ar/mt06_arabic_evlset_nist_part_v1.reforder.tok-v3 HIERO_DIR=/home/zli/work/hiero/copy_2008/sa_copy/sa-hiero_adapted
#	$(MAKE) -f ${MAKE_DIR}/extract-rules-hiero.mk STAGE_NUMBER=05 STAGE_NAME=hiero-extract-rules TRAINING_SRC=${EXPERIMENT_DIR}/04.berkeley-align/training/subsampled.ar TRAINING_TGT=${EXPERIMENT_DIR}/04.berkeley-align/training/subsampled.en TRAINING_ALIGN=${EXPERIMENT_DIR}/04.berkeley-align/alignments/training.en-ar.align TEST_SRC=/scratch/lane/gale/02.remove-all-initial-W.test.ar/GALE-DEV09-arabic-text-nw-tune.atb-v3.1.unk.split HIERO_DIR=/home/zli/work/hiero/copy_2008/sa_copy/sa-hiero_adapted
#
# For each file to translate,
#     call the above make function.
# Doing so will tell make
#     to run rule extraction for each file to translate.
#	for file in ${FILES_TO_TRANSLATE}; do $(MAKE) -f ${MAKE_DIR}/extract-rules.mk -j ${SPLIT_SIZE} STAGE_NUMBER=05 STAGE_NAME=extract-rules TRAINING_SRC=${EXPERIMENT_DIR}/04.berkeley-align/training/subsampled.ar TRAINING_TGT=${EXPERIMENT_DIR}/04.berkeley-align/training/subsampled.en TRAINING_ALN=${EXPERIMENT_DIR}/04.berkeley-align/alignments/training.en-ar.align FILE_TO_TRANSLATE=$${file}xf; done
#
#$(foreach file,${FILES_TO_TRANSLATE},$(eval $(call EXTRACT_TEMPLATE,${file})))
#


.PHONY: all
