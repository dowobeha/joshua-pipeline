################################################################################
####                     Define the target to be run:                       ####
####                                                                        ####
.DEFAULT_GOAL=all
####                                                                        ####
################################################################################


EXPERIMENT_DIR:=/mnt/data/wmt10.cz
EXPERIMENT_MAKE_DIR:=${EXPERIMENT_DIR}/000.makefiles
DOWNLOAD_DIR:=${EXPERIMENT_DIR}/001.OriginalData
UNZIPPED_DATA_DIR:=${EXPERIMENT_DIR}/002.OriginalDataUnzipped
CZEN_USERNAME:=fdf0c1
CZENG_SCRIPT:=${EXPERIMENT_MAKE_DIR}/scripts/prepare-czeng.perl
JOSHUA:=${EXPERIMENT_DIR}/003.Joshua
SRILM:=/home/zli/tools/srilm1.5.7.64bit.pic

BERKELEYALIGNER:=${EXPERIMENT_DIR}/004.BerkeleyAligner

WMT10_SCRIPTS:=${EXPERIMENT_DIR}/005.Scripts

# Subsampling
SUBSAMPLER_JVM_FLAGS:=-Xms30g -Xmx30g -Dfile.encoding=utf8
FILTER_SCRIPT:=${EXPERIMENT_MAKE_DIR}/scripts/filter-sentences.pl

RECASE_STRIP_TAGS_SCRIPT:=${EXPERIMENT_MAKE_DIR}/scripts/strip-sent-tags.perl


LM_NGRAM_ORDER:=5

ifeq (${TOY},true)
EXPERIMENT_DIR:=/mnt/data/wmt10.cz.toy
TOY_TEST_SGM_SCRIPT:=${EXPERIMENT_MAKE_DIR}/scripts/partial-sgm.pl
RECASE_LM_NGRAM_ORDER:=3
ifndef TOY_SIZE
TOY_SIZE:=10000
endif
ifndef TOY_TEST_SIZE
TOY_TEST_SIZE:=20
endif
else
RECASE_LM_NGRAM_ORDER:=${LM_NGRAM_ORDER}
endif

DATA_DIR:=${EXPERIMENT_DIR}/002.OriginalData


DATA_WITHOUT_XML:=${EXPERIMENT_DIR}/006.RemoveXML

# Get names of XML files, with path removed
#
# See sections 8.2 and 4.3.3 of the GNU Make Manual
XML_FILES:=$(patsubst ${DATA_DIR}/%,%,$(wildcard ${DATA_DIR}/*.sgm))

# Get names of XML files, with path and suffix removed
#
# See section 8.2 of the GNU Make Manual
BARE_XML_FILES:=$(patsubst %.sgm,%,${XML_FILES})

# Get names of original non-XML files, with path removed
#
# See sections 8.2 and 4.3.3 of the GNU Make Manual
NON_XML_FILES:=$(filter-out ${XML_FILES},$(patsubst ${DATA_DIR}/%,%,$(wildcard ${DATA_DIR}/*)))

# Get paths of XML files after processing
#
# See section 8.5 of the GNU Make Manual
PROCESSED_XML_FILES:=$(foreach file,${BARE_XML_FILES},${DATA_WITHOUT_XML}/${file})

# Get names for other non-XML files after processing
#
# See section 8.5 of the GNU Make Manual
PROCESSED_NON_XML_FILES:=$(foreach file,${NON_XML_FILES},${DATA_WITHOUT_XML}/${file})



# File names of files after processing
TOKENIZED_DATA:=${EXPERIMENT_DIR}/007.TokenizedData
TOKENIZED_FILES:=$(patsubst ${DATA_WITHOUT_XML}/%,${TOKENIZED_DATA}/%,$(wildcard ${DATA_WITHOUT_XML}/*))

# File names of files after processing
NORMALIZED_DATA:=${EXPERIMENT_DIR}/008.NormalizedData
NORMALIZED_FILES:=$(patsubst ${TOKENIZED_DATA}/%,${NORMALIZED_DATA}/%,$(wildcard ${TOKENIZED_DATA}/*))



BERKELEY_NUM_THREADS:=10
BERKELEY_JVM_FLAGS:=-d64 -Dfile.encoding=utf8 -XX:MinHeapFreeRatio=10 -Xms25g -Xmx25g

EXTRACT_RULES_JVM_FLAGS:=-Xms30g -Xmx30g -Dfile.encoding=utf8
HIERO_DIR:=/home/zli/work/hiero/copy_2008/sa_copy/sa-hiero_adapted
SRILM_ARCH:=i686-m64
SRILM_NGRAM_COUNT:=${SRILM}/bin/${SRILM_ARCH}/ngram-count
SRILM_DISAMBIG:=${SRILM}/bin/${SRILM_ARCH}/disambig
LM_TRAINING_DIR=${NORMALIZED_DATA}


define SUBSAMPLER_FILES_TO_TRANSLATE
$(if ${SRC},newssyscomb2009-src.${SRC} news-test2008-src.${SRC} newstest2009-src.${SRC} newstest2010-src.${SRC},$(error SRC language is not defined))
endef

define TRANSLATION_GRAMMAR
$(if ${EXTRACT_RULES_DIR},,$(error EXTRACT_RULES_DIR is not defined))\
$(if ${SRC},,$(error SRC language is not defined))\
$(if ${TGT},,$(error TGT language is not defined))\
${EXTRACT_RULES_DIR}/${SRC}-${TGT}.grammar
endef

JOSHUA_MEMORY_FLAGS:=-d64 -Dfile.encoding=utf8 -XX:MinHeapFreeRatio=10 -Xmx30g

define LANGUAGE_MODEL
$(if ${TRAINED_LM_DIR},,$(error TRAINED_LM_DIR is not defined))\
$(if ${TGT},,$(error TGT language is not defined))\
${TRAINED_LM_DIR}/${TGT}.lm
endef

define MERT_FILE_TO_TRANSLATE
$(if ${SRC},news-test2008-src.${SRC},$(error SRC language is not defined))
endef

define MERT_REFERENCE_BASE
$(if ${TGT},news-test2008-src.${TGT},$(error TGT language is not defined))
endef

MERT_METRIC_NAME:=bleu
MERT_NUM_REFERENCES:=1

JOSHUA_MAX_N_ITEMS:=300
JOSHUA_THREADS:=20
MERT_JVM_FLAGS:=-d64 -Dfile.encoding=utf8 -Xms2g -Xmx2g -Dfile.encoding=utf8

define JOSHUA_DEV_FILE_TO_TRANSLATE
$(if ${SRC},${NORMALIZED_DATA}/newstest2009-src.${SRC},$(error SRC language is not defined))
endef

define JOSHUA_DEV_NBEST_OUTPUT_FILENAME
$(if ${TGT},newstest2009.nbest.${TGT},$(error TGT language is not defined))
endef

define MERT_RESULT_CONFIG
$(if ${MERT_DIR},${MERT_DIR}/joshua.config.ZMERT.final,$(error MERT_DIR is not defined))
endef

define JOSHUA_EXTRACT_DEV_1BEST_INPUT
$(if ${JOSHUA_TRANSLATION_DIR},,$(error JOSHUA_TRANSLATION_DIR is not defined))\
$(if ${JOSHUA_DEV_NBEST_OUTPUT_FILENAME},,$(error JOSHUA_DEV_NBEST_OUTPUT_FILENAME is not defined))\
${JOSHUA_TRANSLATION_DIR}/${JOSHUA_DEV_NBEST_OUTPUT_FILENAME}
endef

define JOSHUA_EXTRACT_DEV_1BEST_OUTPUT_FILENAME
$(if ${TGT},newstest2009.1best.${TGT},$(error TGT language is not defined))
endef

JOSHUA_EXTRACT_MBR_BEST_NUM_THREADS:=10

define JOSHUA_EXTRACT_DEV_MBR_BEST_INPUT
$(if ${JOSHUA_TRANSLATION_DIR},,$(error JOSHUA_TRANSLATION_DIR is not defined))\
$(if ${JOSHUA_DEV_NBEST_OUTPUT_FILENAME},,$(error JOSHUA_DEV_NBEST_OUTPUT_FILENAME is not defined))\
${JOSHUA_TRANSLATION_DIR}/${JOSHUA_DEV_NBEST_OUTPUT_FILENAME}
endef

define JOSHUA_EXTRACT_DEV_MBR_BEST_OUTPUT_FILENAME
$(if ${TGT},newstest2009.mbr.${TGT},$(error TGT language is not defined))
endef

define RECASE_TRUECASE_POSSIBLE_TRAINING_FILE_NAMES
$(if ${TGT},news-commentary10.${TGT} news.${TGT}.shuffled europarl-v5.${TGT} undoc.2000.en-fr.${TGT} undoc.2000.en-es.${TGT} giga-fren.release2.${TGT},$(error TGT is not defined))
endef

define RECASE_TRUECASE_TRAINING_DIR
$(if ${TOKENIZED_DATA},${TOKENIZED_DATA},$(error TOKENIZED_DATA is not defined))
endef

define RECASE_TRUECASE_TRAINING_FILE_NAMES
$(if ${RECASE_TRUECASE_TRAINING_DIR},\
	$(wildcard \
		$(foreach file,${RECASE_TRUECASE_POSSIBLE_TRAINING_FILE_NAMES},${RECASE_TRUECASE_TRAINING_DIR}/${file})\
	),\
	$(error RECASE_TRUECASE_TRAINING_DIR is not defined)\
)
endef

TRUECASE_MAPPING_SCRIPT:=${EXPERIMENT_MAKE_DIR}/scripts/truecase-map.perl

define RECASE_LANGUAGE_MODEL
$(if ${RECASE_SRILM_DIR},,$(error RECASE_SRILM_DIR is not defined))\
$(if ${TGT},,$(error TGT language is not defined))\
${RECASE_SRILM_DIR}/${TGT}.lm
endef

define RECASE_MAP_FILE
$(if ${RECASE_SRILM_DIR},,$(error RECASE_SRILM_DIR is not defined))\
$(if ${TGT},,$(error TGT language is not defined))\
${RECASE_SRILM_DIR}/truecase.${TGT}.map
endef

REMOVE_OOV_SCRIPT:=${EXPERIMENT_MAKE_DIR}/scripts/remove_OOV_tag.perl
