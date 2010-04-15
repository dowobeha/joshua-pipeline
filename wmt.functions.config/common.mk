################################################################################
####                     Define the target to be run:                       ####
####                                                                        ####
export .DEFAULT_GOAL=all
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


ifeq (${TOY},true)
EXPERIMENT_DIR:=/mnt/data/wmt10.cz.toy
TOY_TEST_SGM_SCRIPT:=${EXPERIMENT_MAKE_DIR}/scripts/partial-sgm.pl
ifndef TOY_SIZE
TOY_SIZE:=10000
endif
ifndef TOY_TEST_SIZE
TOY_TEST_SIZE:=20
endif
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
SRILM_NGRAM_COUNT:=${SRILM}/bin/i686-m64/ngram-count
LM_TRAINING_DIR=${NORMALIZED_DATA}
LM_NGRAM_ORDER:=5

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
