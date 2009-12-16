# Welcome to GALE. We hope you have a pleasant stay.
$(info This file is for running the JHU GALE Arabic-English SMT system.)
$(info )



# The following variables must be defined
EXPERIMENT_DIR ?= $(error EXPERIMENT_DIR is not defined)
BERKELEY_ALIGNER_JAR ?= $(error BERKELEY_ALIGNER_JAR is not defined)
MAKE_DIR ?= $(error MAKE_DIR is not defined)
SCRIPTS_DIR ?= $(error SCRIPTS_DIR is not defined)
JOSHUA ?= $(error JOSHUA is not defined)
JOSHUA_MEMORY_FLAGS ?= $(error JOSHUA_MEMORY_FLAGS is not defined)
JOSHUA_THREADS ?= $(error JOSHUA_THREADS is not defined)
MBR_MEMORY_FLAGS ?= $(error MBR_MEMORY_FLAGS is not defined)
MBR_THREADS ?= $(error MBR_THREADS is not defined)
MERT_JVM_FLAGS ?= $(error MERT_JVM_FLAGS is not defined)
LM_FILE ?= $(error LM_FILE is not defined)
LM_ORDER ?= $(error LM_ORDER is not defined)
HIERO_DIR ?= $(error HIERO_DIR is not defined)
ARCHIVE_FILE ?= $(error ARCHIVE_FILE is not defined)
FILES_TO_EXTRACT ?= $(error FILES_TO_EXTRACT is not defined)
MANIFEST ?= $(error MANIFEST is not defined)


all: decode.nw decode.wb


#all: \
#	extract-training-data \
#	preprocess-training-data \
#	extract-test-data \
#	preprocess-test-data \
#	subsample \
#	${BERKELEY_ALIGNER_JAR} \
#	berkeley-align \
#	extract-grammar \
#	mert.nw \
#	mert.wb \
#	decode.nw \
#	decode.wb



${BERKELEY_ALIGNER_JAR}: ${EXPERIMENT_DIR}/berkeleyaligner/berkeleyaligner_unsupervised-2.1.tar.gz | ${EXPERIMENT_DIR}/berkeleyaligner
	tar xvzf $< berkeleyaligner/berkeleyaligner.jar
	@touch $@

${EXPERIMENT_DIR}/berkeleyaligner/berkeleyaligner_unsupervised-2.1.tar.gz: | ${EXPERIMENT_DIR}/berkeleyaligner
	wget http://berkeleyaligner.googlecode.com/files/berkeleyaligner_unsupervised-2.1.tar.gz
	mv berkeleyaligner_unsupervised-2.1.tar.gz ${EXPERIMENT_DIR}/berkeleyaligner

${EXPERIMENT_DIR}/berkeleyaligner:
	mkdir -p $@


extract-training-data:
#
#	Extract training files from IBM archive file
	$(MAKE) -f ${MAKE_DIR}/extract-files.mk -j 1 \
		STAGE_NUMBER=00 STAGE_NAME=extract_from_IBM \
		PREREQ_DIR=${ORIGINAL_GALE_FILES}
#
#	Create nicely-named links to the training source files
	$(MAKE) -f ${MAKE_DIR}/rename.mk \
		STAGE_NUMBER=00 STAGE_NAME=extract_from_IBM.ar \
		PREREQ_DIR=${EXPERIMENT_DIR}/00.extract_from_IBM/arfiles/atb
#
#	Create nicely-named links to the training source files
	$(MAKE) -f ${MAKE_DIR}/rename.mk \
		STAGE_NUMBER=00 STAGE_NAME=extract_from_IBM.en \
		PREREQ_DIR=${EXPERIMENT_DIR}/00.extract_from_IBM/enfiles/tok


preprocess-training-data: extract-training-data
#	Preprocess training data
	$(MAKE) -f ${MAKE_DIR}/preprocessed.mk STAGE_NUMBER=00 STAGE_NAME=preprocess.training.ar PREREQ_DIR=${EXPERIMENT_DIR}/00.extract_from_IBM.ar
	$(MAKE) -f ${MAKE_DIR}/preprocessed.mk STAGE_NUMBER=00 STAGE_NAME=preprocess.training.en PREREQ_DIR=${EXPERIMENT_DIR}/00.extract_from_IBM.en
#
#	Remove sentence-initial W- from Arabic training files
	$(MAKE) -f ${MAKE_DIR}/remove-all-initial-W.mk STAGE_NUMBER=01 STAGE_NAME=remove-all-initial-W.training.ar PREREQ_DIR=${EXPERIMENT_DIR}/00.preprocess.training.ar


extract-test-data:
#	Extract MT06 test file from IBM archive file
	$(MAKE) -f ${MAKE_DIR}/extract-test.mk STAGE_NUMBER=02 STAGE_NAME=extract_test_from_IBM.ar IBM_ARCHIVE=${ORIGINAL_GALE_FILES}/Rosetta-P4-ae-testsets-v1.1.tgz SGM_FILE=tok-v3-a/mt06_arabic_evlset_nist_part_v1.reforder.tok-v3.sgm
#	Extract NW test files from IBM archive file
	$(MAKE) -f ${MAKE_DIR}/extract-test.mk STAGE_NUMBER=02 STAGE_NAME=extract_test_from_IBM.ar IBM_ARCHIVE=${ORIGINAL_GALE_FILES}/GALE-P4-Rosetta-DryRun-Text.tgz SGM_FILE=arabic/source/ready-for-mt-atb-v3.1/GALE-DEV09-arabic-text-nw-dev.atb-v3.1.unk.split.sgm
	$(MAKE) -f ${MAKE_DIR}/extract-test.mk STAGE_NUMBER=02 STAGE_NAME=extract_test_from_IBM.ar IBM_ARCHIVE=${ORIGINAL_GALE_FILES}/GALE-P4-Rosetta-DryRun-Text.tgz SGM_FILE=arabic/source/ready-for-mt-atb-v3.1/GALE-DEV09-arabic-text-nw-tune.atb-v3.1.unk.split.sgm
	$(MAKE) -f ${MAKE_DIR}/extract-test.mk STAGE_NUMBER=02 STAGE_NAME=extract_test_from_IBM.ar IBM_ARCHIVE=${ORIGINAL_GALE_FILES}/GALE-P4-Rosetta-DryRun-Text.tgz SGM_FILE=arabic/source/ready-for-mt-atb-v3.1/GALE-DEV09test+P3unseq-arabic-text-nw.atb-v3.1.unk.split.sgm
	$(MAKE) -f ${MAKE_DIR}/extract-test.mk STAGE_NUMBER=02 STAGE_NAME=extract_test_from_IBM.ar IBM_ARCHIVE=${ORIGINAL_GALE_FILES}/GALE-P4-Rosetta-DryRun-Text.tgz SGM_FILE=arabic/source/ready-for-mt-atb-v3.1/mt08_arabic_evalset_current_v0-nw.atb-v3.1.unk.split.sgm
#	Extract WB test files from IBM archive file
	$(MAKE) -f ${MAKE_DIR}/extract-test.mk STAGE_NUMBER=02 STAGE_NAME=extract_test_from_IBM.ar IBM_ARCHIVE=${ORIGINAL_GALE_FILES}/GALE-P4-Rosetta-DryRun-Text.tgz SGM_FILE=arabic/source/ready-for-mt-atb-v3.1/GALE-DEV09-arabic-text-wb-dev.spell.atb-v3.1.unk.split.sgm
	$(MAKE) -f ${MAKE_DIR}/extract-test.mk STAGE_NUMBER=02 STAGE_NAME=extract_test_from_IBM.ar IBM_ARCHIVE=${ORIGINAL_GALE_FILES}/GALE-P4-Rosetta-DryRun-Text.tgz SGM_FILE=arabic/source/ready-for-mt-atb-v3.1/GALE-DEV09-arabic-text-wb-tune.spell.atb-v3.1.unk.split.sgm
	$(MAKE) -f ${MAKE_DIR}/extract-test.mk STAGE_NUMBER=02 STAGE_NAME=extract_test_from_IBM.ar IBM_ARCHIVE=${ORIGINAL_GALE_FILES}/GALE-P4-Rosetta-DryRun-Text.tgz SGM_FILE=arabic/source/ready-for-mt-atb-v3.1/GALE-DEV09test+DEV08-arabic-text-wb.spell.atb-v3.1.unk.split.sgm
	$(MAKE) -f ${MAKE_DIR}/extract-test.mk STAGE_NUMBER=02 STAGE_NAME=extract_test_from_IBM.ar IBM_ARCHIVE=${ORIGINAL_GALE_FILES}/GALE-P4-Rosetta-DryRun-Text.tgz SGM_FILE=arabic/source/ready-for-mt-atb-v3.1/mt08_arabic_evalset_current_v0-wb.spell.atb-v3.1.unk.split.sgm
#
#	Extract reference files from IBM archive file
	$(MAKE) -f ${MAKE_DIR}/extract-test.mk STAGE_NUMBER=02 STAGE_NAME=extract_test_from_IBM.en IBM_ARCHIVE=${ORIGINAL_GALE_FILES}/GALE-P4-Rosetta-DryRun-Text.tgz SGM_FILE=scoring/refs/arabic/GALE-DEV09-arabic-text-nw-tune.ref.sgm
	$(MAKE) -f ${MAKE_DIR}/extract-test.mk STAGE_NUMBER=02 STAGE_NAME=extract_test_from_IBM.en IBM_ARCHIVE=${ORIGINAL_GALE_FILES}/GALE-P4-Rosetta-DryRun-Text.tgz SGM_FILE=scoring/refs/arabic/GALE-DEV09-arabic-text-wb-tune.ref.sgm
	$(MAKE) -f ${MAKE_DIR}/extract-test.mk STAGE_NUMBER=02 STAGE_NAME=extract_test_from_IBM.en IBM_ARCHIVE=${ORIGINAL_GALE_FILES}/GALE-P4-Rosetta-DryRun-Text.tgz SGM_FILE=scoring/refs/arabic/GALE-DEV09-arabic-text-nw-dev.ref.sgm
	$(MAKE) -f ${MAKE_DIR}/extract-test.mk STAGE_NUMBER=02 STAGE_NAME=extract_test_from_IBM.en IBM_ARCHIVE=${ORIGINAL_GALE_FILES}/GALE-P4-Rosetta-DryRun-Text.tgz SGM_FILE=scoring/refs/arabic/GALE-DEV09-arabic-text-wb-dev.ref.sgm


preprocess-test-data: extract-test-data
#	Preprocess test files
	$(MAKE) -f ${MAKE_DIR}/preprocess-test.mk STAGE_NUMBER=02 STAGE_NAME=preprocess.test.ar PREREQ_DIR=${EXPERIMENT_DIR}/02.extract_test_from_IBM.ar
	$(MAKE) -f ${MAKE_DIR}/preprocess-test.mk STAGE_NUMBER=02 STAGE_NAME=preprocess.test.en PREREQ_DIR=${EXPERIMENT_DIR}/02.extract_test_from_IBM.en
#
#	Remove sentence-initial W- from Arabic test files
	$(MAKE) -f ${MAKE_DIR}/remove-all-initial-W.mk STAGE_NUMBER=02 STAGE_NAME=remove-all-initial-W.test.ar PREREQ_DIR=${EXPERIMENT_DIR}/02.preprocess.test.ar


subsample: preprocess-training-data preprocess-test-data
#	Perform subsampling
	$(MAKE) -f ${MAKE_DIR}/subsample.mk STAGE_NUMBER=03 STAGE_NAME=subsample SRC=ar TGT=en PREREQ_DIR_TEST=${EXPERIMENT_DIR}/02.remove-all-initial-W.test.ar PREREQ_DIR_SRC=${EXPERIMENT_DIR}/01.remove-all-initial-W.training.ar PREREQ_DIR_TGT=${EXPERIMENT_DIR}/00.preprocess.training.en

berkeley-align: ${BERKELEY_ALIGNER_JAR} subsample
#	Perform Berkeley alignment
	$(MAKE) -f ${MAKE_DIR}/berkeley-align.mk STAGE_NUMBER=04 STAGE_NAME=berkeley-align PREREQ_DIR=${EXPERIMENT_DIR}/03.subsample SRC=ar TGT=en

extract-grammar: berkeley-align
#	Extract grammar 
	$(MAKE) -f ${MAKE_DIR}/extract-rules-hiero.mk STAGE_NUMBER=05 STAGE_NAME=hiero-extract-rules TRAINING_SRC=${EXPERIMENT_DIR}/04.berkeley-align/training/subsampled.ar TRAINING_TGT=${EXPERIMENT_DIR}/04.berkeley-align/training/subsampled.en TRAINING_ALIGN=${EXPERIMENT_DIR}/04.berkeley-align/alignments/training.en-ar.align TEST_SRC=${EXPERIMENT_DIR}/03.subsample/subsample.test.ar

mert.nw: extract-grammar
#	Run MERT for NW
	$(MAKE) -f ${MAKE_DIR}/mert.mk STAGE_NUMBER=06 STAGE_NAME=mert.nw \
		TM_GRAMMAR=${EXPERIMENT_DIR}/05.hiero-extract-rules/subsample.test.ar.grammar \
		FILE_TO_TRANSLATE=${EXPERIMENT_DIR}/02.preprocess.test.ar/GALE-DEV09-arabic-text-nw-tune.atb-v3.1.unk.split \
		NUM_REFERENCES=1 \
		REFERENCE_BASE=02.preprocess.test.en/GALE-DEV09-arabic-text-nw-tune.ref


mert.wb: extract-grammar
#	Run MERT for NW
	$(MAKE) -f ${MAKE_DIR}/mert.mk STAGE_NUMBER=06 STAGE_NAME=mert.wb \
		TM_GRAMMAR=${EXPERIMENT_DIR}/05.hiero-extract-rules/subsample.test.ar.grammar \
		FILE_TO_TRANSLATE=${EXPERIMENT_DIR}/02.preprocess.test.ar/GALE-DEV09-arabic-text-wb-tune.spell.atb-v3.1.unk.split \
		NUM_REFERENCES=1 \
		REFERENCE_BASE=02.preprocess.test.en/GALE-DEV09-arabic-text-wb-tune.ref



define DECODE
	$(MAKE) -f ${MAKE_DIR}/decode.mk STAGE_NUMBER=${1} STAGE_NAME=decode.${2} \
		FILE_TO_TRANSLATE=${3} \
		JOSHUA_CONFIG=06.mert.${2}/joshua.config.ZMERT.final
endef


define DECODE_BEAM
	$(MAKE) -f ${MAKE_DIR}/decode.mk STAGE_NUMBER=${1} STAGE_NAME=decode.${2}.${3} \
		FILE_TO_TRANSLATE=${4} \
		JOSHUA_CONFIG=06.mert.${2}/joshua.config.ZMERT.final \
		MAX_N_ITEMS=${3}
endef



decode.nw: mert.nw
#	Translate!
	$(call DECODE,07,nw,${EXPERIMENT_DIR}/02.preprocess.test.ar/GALE-DEV09-arabic-text-nw-dev.atb-v3.1.unk.split)
	$(call DECODE,07,nw,${EXPERIMENT_DIR}/02.preprocess.test.ar/mt08_arabic_evalset_current_v0-nw.atb-v3.1.unk.split)
	$(call DECODE,07,nw,${EXPERIMENT_DIR}/02.preprocess.test.ar/GALE-DEV09test+P3unseq-arabic-text-nw.atb-v3.1.unk.split)

decode.wb: mert.wb
#	Translate!
	$(call DECODE,07,wb,${EXPERIMENT_DIR}/02.preprocess.test.ar/GALE-DEV09-arabic-text-wb-dev.spell.atb-v3.1.unk.split)
	$(call DECODE,07,wb,${EXPERIMENT_DIR}/02.preprocess.test.ar/mt08_arabic_evalset_current_v0-wb.spell.atb-v3.1.unk.split)
	$(call DECODE,07,wb,${EXPERIMENT_DIR}/02.preprocess.test.ar/GALE-DEV09test+DEV08-arabic-text-wb.spell.atb-v3.1.unk.split)


decode.nw.50: mert.nw
#	Translate!
	$(call DECODE_BEAM,07,nw,50,${EXPERIMENT_DIR}/02.preprocess.test.ar/GALE-DEV09-arabic-text-nw-dev.atb-v3.1.unk.split)
#	$(call DECODE_BEAM,07,nw,50,${EXPERIMENT_DIR}/02.preprocess.test.ar/mt08_arabic_evalset_current_v0-nw.atb-v3.1.unk.split)
#	$(call DECODE_BEAM,07,nw,50,${EXPERIMENT_DIR}/02.preprocess.test.ar/GALE-DEV09test+P3unseq-arabic-text-nw.atb-v3.1.unk.split)

decode.wb.50: mert.wb
#	Translate!
	$(call DECODE_BEAM,07,wb,50,${EXPERIMENT_DIR}/02.preprocess.test.ar/GALE-DEV09-arabic-text-wb-dev.spell.atb-v3.1.unk.split)
#	$(call DECODE_BEAM,07,wb,50,${EXPERIMENT_DIR}/02.preprocess.test.ar/mt08_arabic_evalset_current_v0-wb.spell.atb-v3.1.unk.split)
#	$(call DECODE_BEAM,07,wb,50,${EXPERIMENT_DIR}/02.preprocess.test.ar/GALE-DEV09test+DEV08-arabic-text-wb.spell.atb-v3.1.unk.split)

decode.nw.75: mert.nw
#	Translate!
	$(call DECODE_BEAM,07,nw,75,${EXPERIMENT_DIR}/02.preprocess.test.ar/GALE-DEV09-arabic-text-nw-dev.atb-v3.1.unk.split)
#	$(call DECODE_BEAM,07,nw,75,${EXPERIMENT_DIR}/02.preprocess.test.ar/mt08_arabic_evalset_current_v0-nw.atb-v3.1.unk.split)
#	$(call DECODE_BEAM,07,nw,75,${EXPERIMENT_DIR}/02.preprocess.test.ar/GALE-DEV09test+P3unseq-arabic-text-nw.atb-v3.1.unk.split)

decode.wb.75: mert.wb
#	Translate!
	$(call DECODE_BEAM,07,wb,75,${EXPERIMENT_DIR}/02.preprocess.test.ar/GALE-DEV09-arabic-text-wb-dev.spell.atb-v3.1.unk.split)
#	$(call DECODE_BEAM,07,wb,75,${EXPERIMENT_DIR}/02.preprocess.test.ar/mt08_arabic_evalset_current_v0-wb.spell.atb-v3.1.unk.split)
#	$(call DECODE_BEAM,07,wb,75,${EXPERIMENT_DIR}/02.preprocess.test.ar/GALE-DEV09test+DEV08-arabic-text-wb.spell.atb-v3.1.unk.split)


decode.nw.100: mert.nw
#	Translate!
	$(call DECODE_BEAM,07,nw,100,${EXPERIMENT_DIR}/02.preprocess.test.ar/GALE-DEV09-arabic-text-nw-dev.atb-v3.1.unk.split)
#	$(call DECODE_BEAM,07,nw,100,${EXPERIMENT_DIR}/02.preprocess.test.ar/mt08_arabic_evalset_current_v0-nw.atb-v3.1.unk.split)
#	$(call DECODE_BEAM,07,nw,100,${EXPERIMENT_DIR}/02.preprocess.test.ar/GALE-DEV09test+P3unseq-arabic-text-nw.atb-v3.1.unk.split)

decode.wb.100: mert.wb
#	Translate!
	$(call DECODE_BEAM,07,wb,100,${EXPERIMENT_DIR}/02.preprocess.test.ar/GALE-DEV09-arabic-text-wb-dev.spell.atb-v3.1.unk.split)
#	$(call DECODE_BEAM,07,wb,100,${EXPERIMENT_DIR}/02.preprocess.test.ar/mt08_arabic_evalset_current_v0-wb.spell.atb-v3.1.unk.split)
#	$(call DECODE_BEAM,07,wb,100,${EXPERIMENT_DIR}/02.preprocess.test.ar/GALE-DEV09test+DEV08-arabic-text-wb.spell.atb-v3.1.unk.split)

decode.nw.125: mert.nw
#	Translate!
	$(call DECODE_BEAM,07,nw,125,${EXPERIMENT_DIR}/02.preprocess.test.ar/GALE-DEV09-arabic-text-nw-dev.atb-v3.1.unk.split)
#	$(call DECODE_BEAM,07,nw,125,${EXPERIMENT_DIR}/02.preprocess.test.ar/mt08_arabic_evalset_current_v0-nw.atb-v3.1.unk.split)
#	$(call DECODE_BEAM,07,nw,125,${EXPERIMENT_DIR}/02.preprocess.test.ar/GALE-DEV09test+P3unseq-arabic-text-nw.atb-v3.1.unk.split)

decode.wb.125: mert.wb
#	Translate!
	$(call DECODE_BEAM,07,wb,125,${EXPERIMENT_DIR}/02.preprocess.test.ar/GALE-DEV09-arabic-text-wb-dev.spell.atb-v3.1.unk.split)
#	$(call DECODE_BEAM,07,wb,125,${EXPERIMENT_DIR}/02.preprocess.test.ar/mt08_arabic_evalset_current_v0-wb.spell.atb-v3.1.unk.split)
#	$(call DECODE_BEAM,07,wb,125,${EXPERIMENT_DIR}/02.preprocess.test.ar/GALE-DEV09test+DEV08-arabic-text-wb.spell.atb-v3.1.unk.split)


decode.nw.150: mert.nw
#	Translate!
	$(call DECODE_BEAM,07,nw,150,${EXPERIMENT_DIR}/02.preprocess.test.ar/GALE-DEV09-arabic-text-nw-dev.atb-v3.1.unk.split)
#	$(call DECODE_BEAM,07,nw,150,${EXPERIMENT_DIR}/02.preprocess.test.ar/mt08_arabic_evalset_current_v0-nw.atb-v3.1.unk.split)
#	$(call DECODE_BEAM,07,nw,150,${EXPERIMENT_DIR}/02.preprocess.test.ar/GALE-DEV09test+P3unseq-arabic-text-nw.atb-v3.1.unk.split)

decode.wb.150: mert.wb
#	Translate!
	$(call DECODE_BEAM,07,wb,150,${EXPERIMENT_DIR}/02.preprocess.test.ar/GALE-DEV09-arabic-text-wb-dev.spell.atb-v3.1.unk.split)
#	$(call DECODE_BEAM,07,wb,150,${EXPERIMENT_DIR}/02.preprocess.test.ar/mt08_arabic_evalset_current_v0-wb.spell.atb-v3.1.unk.split)
#	$(call DECODE_BEAM,07,wb,150,${EXPERIMENT_DIR}/02.preprocess.test.ar/GALE-DEV09test+DEV08-arabic-text-wb.spell.atb-v3.1.unk.split)


decode.nw.175: mert.nw
#	Translate!
	$(call DECODE_BEAM,07,nw,175,${EXPERIMENT_DIR}/02.preprocess.test.ar/GALE-DEV09-arabic-text-nw-dev.atb-v3.1.unk.split)
#	$(call DECODE_BEAM,07,nw,175,${EXPERIMENT_DIR}/02.preprocess.test.ar/mt08_arabic_evalset_current_v0-nw.atb-v3.1.unk.split)
#	$(call DECODE_BEAM,07,nw,175,${EXPERIMENT_DIR}/02.preprocess.test.ar/GALE-DEV09test+P3unseq-arabic-text-nw.atb-v3.1.unk.split)

decode.wb.175: mert.wb
#	Translate!
	$(call DECODE_BEAM,07,wb,175,${EXPERIMENT_DIR}/02.preprocess.test.ar/GALE-DEV09-arabic-text-wb-dev.spell.atb-v3.1.unk.split)
#	$(call DECODE_BEAM,07,wb,175,${EXPERIMENT_DIR}/02.preprocess.test.ar/mt08_arabic_evalset_current_v0-wb.spell.atb-v3.1.unk.split)
#	$(call DECODE_BEAM,07,wb,175,${EXPERIMENT_DIR}/02.preprocess.test.ar/GALE-DEV09test+DEV08-arabic-text-wb.spell.atb-v3.1.unk.split)


decode.nw.200: mert.nw
#	Translate!
	$(call DECODE_BEAM,07,nw,200,${EXPERIMENT_DIR}/02.preprocess.test.ar/GALE-DEV09-arabic-text-nw-dev.atb-v3.1.unk.split)
#	$(call DECODE_BEAM,07,nw,200,${EXPERIMENT_DIR}/02.preprocess.test.ar/mt08_arabic_evalset_current_v0-nw.atb-v3.1.unk.split)
#	$(call DECODE_BEAM,07,nw,200,${EXPERIMENT_DIR}/02.preprocess.test.ar/GALE-DEV09test+P3unseq-arabic-text-nw.atb-v3.1.unk.split)

decode.wb.200: mert.wb
#	Translate!
	$(call DECODE_BEAM,07,wb,200,${EXPERIMENT_DIR}/02.preprocess.test.ar/GALE-DEV09-arabic-text-wb-dev.spell.atb-v3.1.unk.split)
#	$(call DECODE_BEAM,07,wb,200,${EXPERIMENT_DIR}/02.preprocess.test.ar/mt08_arabic_evalset_current_v0-wb.spell.atb-v3.1.unk.split)
#	$(call DECODE_BEAM,07,wb,200,${EXPERIMENT_DIR}/02.preprocess.test.ar/GALE-DEV09test+DEV08-arabic-text-wb.spell.atb-v3.1.unk.split)


decode.nw.300: mert.nw
#	Translate!
	$(call DECODE_BEAM,07,nw,300,${EXPERIMENT_DIR}/02.preprocess.test.ar/GALE-DEV09-arabic-text-nw-dev.atb-v3.1.unk.split)
#	$(call DECODE_BEAM,07,nw,300,${EXPERIMENT_DIR}/02.preprocess.test.ar/mt08_arabic_evalset_current_v0-nw.atb-v3.1.unk.split)
#	$(call DECODE_BEAM,07,nw,300,${EXPERIMENT_DIR}/02.preprocess.test.ar/GALE-DEV09test+P3unseq-arabic-text-nw.atb-v3.1.unk.split)

decode.wb.300: mert.wb
#	Translate!
	$(call DECODE_BEAM,07,wb,300,${EXPERIMENT_DIR}/02.preprocess.test.ar/GALE-DEV09-arabic-text-wb-dev.spell.atb-v3.1.unk.split)
#	$(call DECODE_BEAM,07,wb,300,${EXPERIMENT_DIR}/02.preprocess.test.ar/mt08_arabic_evalset_current_v0-wb.spell.atb-v3.1.unk.split)
#	$(call DECODE_BEAM,07,wb,300,${EXPERIMENT_DIR}/02.preprocess.test.ar/GALE-DEV09test+DEV08-arabic-text-wb.spell.atb-v3.1.unk.split)


#decode.nw.400: mert.nw
#	Translate!
#	$(call DECODE_BEAM,07,nw,400,${EXPERIMENT_DIR}/02.preprocess.test.ar/GALE-DEV09-arabic-text-nw-dev.atb-v3.1.unk.split)
#	$(call DECODE_BEAM,07,nw,400,${EXPERIMENT_DIR}/02.preprocess.test.ar/mt08_arabic_evalset_current_v0-nw.atb-v3.1.unk.split)
#	$(call DECODE_BEAM,07,nw,400,${EXPERIMENT_DIR}/02.preprocess.test.ar/GALE-DEV09test+P3unseq-arabic-text-nw.atb-v3.1.unk.split)

#decode.wb.400: mert.wb
#	Translate!
#	$(call DECODE_BEAM,07,wb,400,${EXPERIMENT_DIR}/02.preprocess.test.ar/GALE-DEV09-arabic-text-wb-dev.spell.atb-v3.1.unk.split)
#	$(call DECODE_BEAM,07,wb,400,${EXPERIMENT_DIR}/02.preprocess.test.ar/mt08_arabic_evalset_current_v0-wb.spell.atb-v3.1.unk.split)
#	$(call DECODE_BEAM,07,wb,400,${EXPERIMENT_DIR}/02.preprocess.test.ar/GALE-DEV09test+DEV08-arabic-text-wb.spell.atb-v3.1.unk.split)


#decode.nw.500: mert.nw
#	Translate!
#	$(call DECODE_BEAM,07,nw,500,${EXPERIMENT_DIR}/02.preprocess.test.ar/GALE-DEV09-arabic-text-nw-dev.atb-v3.1.unk.split)
#	$(call DECODE_BEAM,07,nw,500,${EXPERIMENT_DIR}/02.preprocess.test.ar/mt08_arabic_evalset_current_v0-nw.atb-v3.1.unk.split)
#	$(call DECODE_BEAM,07,nw,500,${EXPERIMENT_DIR}/02.preprocess.test.ar/GALE-DEV09test+P3unseq-arabic-text-nw.atb-v3.1.unk.split)

#decode.wb.500: mert.wb
#	Translate!
#	$(call DECODE_BEAM,07,wb,500,${EXPERIMENT_DIR}/02.preprocess.test.ar/GALE-DEV09-arabic-text-wb-dev.spell.atb-v3.1.unk.split)
#	$(call DECODE_BEAM,07,wb,500,${EXPERIMENT_DIR}/02.preprocess.test.ar/mt08_arabic_evalset_current_v0-wb.spell.atb-v3.1.unk.split)
#	$(call DECODE_BEAM,07,wb,500,${EXPERIMENT_DIR}/02.preprocess.test.ar/GALE-DEV09test+DEV08-arabic-text-wb.spell.atb-v3.1.unk.split)

beams: decode.nw.50 decode.wb.50 decode.nw.75 decode.wb.75 decode.nw.100 decode.wb.100 decode.nw.125 decode.wb.125 decode.nw.150 decode.wb.150 decode.nw.175 decode.wb.175 decode.nw.200 decode.wb.200 decode.nw.300 decode.wb.300 #decode.nw.400 decode.wb.400 decode.nw.500 decode.wb.500


cleanest:
	@clear
	rm -rf $(shell ls -dp */)
	@pwd
	@ls

.PHONY: all extract-training-data preprocess-training-data extract-test-data preprocess-test-data subsample berkeley-align extract-grammar mert.nw mert.wb decode.nw decode.wb decode.nw.50 decode.wb.50 decode.nw.75 decode.wb.75 decode.nw.100 decode.wb.100 decode.nw.125 decode.wb.125 decode.nw.150 decode.wb.150 decode.nw.175 decode.wb.175 decode.nw.200 decode.wb.200 decode.nw.300 decode.wb.300 beams cleanest
