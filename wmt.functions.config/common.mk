################################################################################
####                     Define the target to be run:                       ####
####                                                                        ####
.DEFAULT_GOAL=all
####                                                                        ####
################################################################################


# Sometimes we just want a toy example
# 
# Define special handling for that case
ifeq (${TOY},true)
EXPERIMENT_DIR:=/mnt/data/wmt10.cz.toy
TOY_TEST_SGM_SCRIPT=${EXPERIMENT_MAKE_DIR}/scripts/partial-sgm.pl
LM_NGRAM_ORDER=2
RECASE_LM_NGRAM_ORDER=2
SRILM_NGRAM_COUNT_FLAGS:=-unk
ifndef TOY_SIZE
TOY_SIZE:=10000
endif
ifndef TOY_TEST_SIZE
TOY_TEST_SIZE:=20
endif
else
RECASE_LM_NGRAM_ORDER:=5
LM_NGRAM_ORDER:=5
SRILM_NGRAM_COUNT_FLAGS:=-interpolate -kndiscount -unk
endif



define DIR_NAME_SRC_TGT_RUN
$(if ${SRC},,$(error SRC is not defined))\
$(if ${TGT},,$(error TGT is not defined))\
$(if ${RUN_ID},,$(error RUN_ID is not defined))\
$(if ${EXPERIMENT_DIR},,$(error EXPERIMENT_DIR is not defined))\
$(if $1,,$(error Required parameter is not defined))\
${EXPERIMENT_DIR}/$1.${SRC}-${TGT}.${RUN_ID}
endef

define DIR_NAME_TGT_RUN
$(if ${TGT},,$(error TGT is not defined))\
$(if ${RUN_ID},,$(error RUN_ID is not defined))\
$(if ${EXPERIMENT_DIR},,$(error EXPERIMENT_DIR is not defined))\
$(if $1,,$(error Required parameter is not defined))\
${EXPERIMENT_DIR}/$1.${TGT}.${RUN_ID}
endef


# Directories for results
EXPERIMENT_DIR:=/mnt/data/wmt10.cz
EXPERIMENT_MAKE_DIR:=${EXPERIMENT_DIR}/000.makefiles
JOSHUA:=${EXPERIMENT_DIR}/001.Joshua
BERKELEYALIGNER:=${EXPERIMENT_DIR}/002.BerkeleyAligner
WMT10_SCRIPTS:=${EXPERIMENT_DIR}/003.Scripts
DOWNLOAD_DIR:=${EXPERIMENT_DIR}/004.OriginalData
UNZIPPED_DATA_DIR:=${EXPERIMENT_DIR}/005.OriginalDataUnzipped
DATA_DIR:=${EXPERIMENT_DIR}/006.OriginalData
DATA_WITHOUT_XML:=${EXPERIMENT_DIR}/007.RemoveXML
TOKENIZED_DATA:=${EXPERIMENT_DIR}/008.TokenizedData
NORMALIZED_DATA:=${EXPERIMENT_DIR}/009.NormalizedData
NORMALIZED_LM_DIR:=$(call DIR_NAME_TGT_RUN,010.NormalizedLanguageModel)
TOKENIZED_LM_DIR:=$(call DIR_NAME_TGT_RUN,011.TokenizedLanguageModel)
SUBSAMPLED_DATA:=$(call DIR_NAME_SRC_TGT_RUN,012.Subsample)
BERKELEY_ALIGN_DIR:=$(call DIR_NAME_SRC_TGT_RUN,013.BerkeleyAlign)
EXTRACT_RULES_DIR:=$(call DIR_NAME_SRC_TGT_RUN,014.ExtractGrammar)
MERT_DIR:=$(call DIR_NAME_SRC_TGT_RUN,015.MERT)
JOSHUA_TRANSLATION_DIR:=$(call DIR_NAME_SRC_TGT_RUN,016.Translate)
JOSHUA_EXTRACT_1BEST_DIR:=$(call DIR_NAME_SRC_TGT_RUN,017.ExtractTopCand)
JOSHUA_EXTRACT_MBR_BEST_DIR:=$(call DIR_NAME_SRC_TGT_RUN,018.ExtractMBRCand)

CZEN_USERNAME:=fdf0c1
CZENG_SCRIPT:=${EXPERIMENT_MAKE_DIR}/scripts/prepare-czeng.perl

SRILM:=/home/zli/tools/srilm1.5.7.64bit.pic



# Subsampling
SUBSAMPLER_JVM_FLAGS:=-Xms30g -Xmx30g -Dfile.encoding=utf8
FILTER_SCRIPT:=${EXPERIMENT_MAKE_DIR}/scripts/filter-sentences.pl

RECASE_STRIP_TAGS_SCRIPT:=${EXPERIMENT_MAKE_DIR}/scripts/strip-sent-tags.perl









# Get names of XML files, with path removed
#
# Start with an empty list, then add data sets
XML_FILES:=
# ... add news-test2008-ref
XML_FILES+=news-test2008-ref.cz.sgm news-test2008-ref.de.sgm news-test2008-ref.en.sgm news-test2008-ref.es.sgm news-test2008-ref.fr.sgm news-test2008-ref.hu.sgm 
# ... add news-test2008-src
XML_FILES+=news-test2008-src.cz.sgm news-test2008-src.de.sgm news-test2008-src.en.sgm news-test2008-src.es.sgm news-test2008-src.fr.sgm news-test2008-src.hu.sgm 
# ... add newssyscomb2009-ref
XML_FILES+=newssyscomb2009-ref.cz.sgm newssyscomb2009-ref.de.sgm newssyscomb2009-ref.en.sgm newssyscomb2009-ref.es.sgm newssyscomb2009-ref.fr.sgm newssyscomb2009-ref.hu.sgm newssyscomb2009-ref.it.sgm 
# ... add newssyscomb2009-src
XML_FILES+=newssyscomb2009-src.cz.sgm newssyscomb2009-src.de.sgm newssyscomb2009-src.en.sgm newssyscomb2009-src.es.sgm newssyscomb2009-src.fr.sgm newssyscomb2009-src.hu.sgm newssyscomb2009-src.it.sgm 
# ... add newstest2009-ref
XML_FILES+=newstest2009-ref.cz.sgm newstest2009-ref.de.sgm newstest2009-ref.en.sgm newstest2009-ref.es.sgm newstest2009-ref.fr.sgm newstest2009-ref.hu.sgm newstest2009-ref.it.sgm 
# ... add newstest2009-src
XML_FILES+=newstest2009-src.cz.sgm newstest2009-src.de.sgm newstest2009-src.en.sgm newstest2009-src.es.sgm newstest2009-src.fr.sgm newstest2009-src.hu.sgm newstest2009-src.it.sgm newstest2009-src.xx.sgm 
# ... add newstest2010-src
XML_FILES+=newstest2010-src.cz.sgm newstest2010-src.de.sgm newstest2010-src.en.sgm newstest2010-src.es.sgm newstest2010-src.fr.sgm


# Get names of XML files, with path and suffix removed
#
# See section 8.2 of the GNU Make Manual
BARE_XML_FILES:=$(patsubst %.sgm,%,${XML_FILES})

# Get names of original non-XML files, with path removed
#
# Start with an empty list, then add data sets
NON_XML_FILES:=
# ... add czeng-train
NON_XML_FILES+=czeng-train.cz czeng-train.en 
# ... add em+internal2009
NON_XML_FILES+=em+internal2009.cz em+internal2009.de em+internal2009.en em+internal2009.fr 
# ... add europarl-v5 monolingual
NON_XML_FILES+=europarl-v5.de europarl-v5.en europarl-v5.es europarl-v5.fr 
# ... add europarl-v5 bilingual
NON_XML_FILES+=europarl-v5.de-en.de europarl-v5.de-en.en europarl-v5.es-en.en europarl-v5.es-en.es europarl-v5.fr-en.en europarl-v5.fr-en.fr 
# ... add giga-fren.release2
NON_XML_FILES+=giga-fren.release2.en giga-fren.release2.fr 
# ... add news-commentary10 monolingual
NON_XML_FILES+=news-commentary10.cz news-commentary10.de news-commentary10.en news-commentary10.es news-commentary10.fr 
# ... add news-commentary10 bilingual
NON_XML_FILES+=news-commentary10.cz-en.cz news-commentary10.cz-en.en news-commentary10.de-en.de news-commentary10.de-en.en news-commentary10.es-de.de news-commentary10.es-de.es news-commentary10.es-en.en news-commentary10.es-en.es news-commentary10.fr-en.en news-commentary10.fr-en.fr 
# ... add monolingual news.*.shuffled
NON_XML_FILES+=news.cz.shuffled news.de.shuffled news.en.shuffled news.es.shuffled news.fr.shuffled 
# ... add undoc.2000
NON_XML_FILES+=undoc.2000.en-es.en undoc.2000.en-es.es undoc.2000.en-fr.en undoc.2000.en-fr.fr

#$(info NON_XML_FILES=${NON_XML_FILES})
#$(info BARE_XML_FILES=${BARE_XML_FILES})

# Get paths of XML files after processing
#
# See section 8.5 of the GNU Make Manual
PROCESSED_XML_FILES:=$(foreach file,${BARE_XML_FILES},${DATA_WITHOUT_XML}/${file})

# Get names for other non-XML files after processing
#
# See section 8.5 of the GNU Make Manual
PROCESSED_NON_XML_FILES:=$(foreach file,${NON_XML_FILES},${DATA_WITHOUT_XML}/${file})



# File names of files after processing
#TOKENIZED_FILES:=$(patsubst ${DATA_WITHOUT_XML}/%,${TOKENIZED_DATA}/%,$(wildcard ${DATA_WITHOUT_XML}/*))
TOKENIZED_FILES:=$(foreach file,${BARE_XML_FILES} ${NON_XML_FILES},${TOKENIZED_DATA}/${file})

#$(info ${TOKENIZED_FILES})

# File names of files after processing

#NORMALIZED_FILES:=$(patsubst ${TOKENIZED_DATA}/%,${NORMALIZED_DATA}/%,$(wildcard ${TOKENIZED_DATA}/*))
NORMALIZED_FILES:=$(foreach file,${BARE_XML_FILES} ${NON_XML_FILES},${NORMALIZED_DATA}/${file})


BERKELEY_NUM_THREADS:=10
BERKELEY_JVM_FLAGS:=-d64 -Dfile.encoding=utf8 -XX:MinHeapFreeRatio=10 -Xms25g -Xmx25g

EXTRACT_RULES_JVM_FLAGS:=-Xms30g -Xmx30g -Dfile.encoding=utf8
HIERO_DIR:=/home/zli/work/hiero/copy_2008/sa_copy/sa-hiero_adapted
SRILM_ARCH:=i686-m64
SRILM_NGRAM_COUNT:=${SRILM}/bin/${SRILM_ARCH}/ngram-count

SRILM_DISAMBIG:=${SRILM}/bin/${SRILM_ARCH}/disambig



define SUBSAMPLER_FILES_TO_TRANSLATE
$(if ${SRC},,$(error SRC is not defined))\
newssyscomb2009-src.${SRC} news-test2008-src.${SRC} newstest2009-src.${SRC} newstest2010-src.${SRC} em+internal2009.${SRC}
endef

define TRANSLATION_GRAMMAR
$(if ${EXTRACT_RULES_DIR},,$(error EXTRACT_RULES_DIR is not defined))\
$(if ${SRC},,$(error SRC language is not defined))\
$(if ${TGT},,$(error TGT language is not defined))\
${EXTRACT_RULES_DIR}/${SRC}-${TGT}.grammar
endef

JOSHUA_MEMORY_FLAGS:=-d64 -Dfile.encoding=utf8 -XX:MinHeapFreeRatio=10 -Xmx30g

define NORMALIZED_LANGUAGE_MODEL
$(if ${NORMALIZED_LM_DIR},,$(error TRAINED_LM_DIR is not defined))\
$(if ${TGT},,$(error TGT language is not defined))\
${NORMALIZED_LM_DIR}/${TGT}.lm
endef

define TOKENIZED_LANGUAGE_MODEL
$(if ${TOKENIZED_LM_DIR},,$(error TRAINED_LM_DIR is not defined))\
$(if ${TGT},,$(error TGT language is not defined))\
${TOKENIZED_LM_DIR}/${TGT}.lm
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

