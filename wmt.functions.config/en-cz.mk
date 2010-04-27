################################################################################
####                 Gather information about this make file                ####
####                                                                        ####
#### Get the full path to this make file
PATH.TO.THIS.MAKEFILE:=$(abspath $(dir $(lastword ${MAKEFILE_LIST})))
####
#### Get the filename of this make file
THIS.MAKEFILE.NAME:=$(basename $(notdir $(lastword ${MAKEFILE_LIST})))
####                                                                        ####
################################################################################

# Define how to import other make files
include ${PATH.TO.THIS.MAKEFILE}/import.mk

# Define language pair
SRC:=en
TGT:=cz
RUN_ID:=run1

# Import common variables
$(eval $(call import,${PATH.TO.THIS.MAKEFILE}/common.mk))



################################################################################
####                                                                        ####
####                   Download and install software                        ####

# Download and install Joshua
$(eval $(call import,${EXPERIMENT_MAKE_DIR}/install/joshua_1.3.mk))
$(eval $(call INSTALL_JOSHUA,${JOSHUA},${SRILM}))

# Download and install Berkeley aligner
$(eval $(call import,${EXPERIMENT_MAKE_DIR}/install/berkeley_2.1.mk))
$(eval $(call INSTALL_BERKELEY_ALIGNER,${BERKELEYALIGNER}))

# Download and install WMT10 scripts
$(eval $(call import,${EXPERIMENT_MAKE_DIR}/install/wmt10-scripts.mk))
$(eval $(call INSTALL_WMT10_SCRIPTS,${WMT10_SCRIPTS}))

####                                                                        ####
####         ... done downloading and installing software                   ####
################################################################################



################################################################################
####                                                                        ####
####                    Download data from the web                          ####

# Make dir to store downloads
$(eval $(call import,${EXPERIMENT_MAKE_DIR}/download-data/wmt10/dir.mk))
$(eval $(call DOWNLOAD_DATA_WMT10,${DOWNLOAD_DIR}))

# Download training data
$(eval $(call import,${EXPERIMENT_MAKE_DIR}/download-data/wmt10/training.mk))
$(eval $(call DOWNLOAD_DATA_WMT10_TRAINING,${DOWNLOAD_DIR}))

# Download training data for CzEn
$(eval $(call import,${EXPERIMENT_MAKE_DIR}/download-data/wmt10/training-czen.mk))
$(eval $(call DOWNLOAD_DATA_WMT10_TRAINING_CZEN,${DOWNLOAD_DIR},${CZEN_USERNAME}))

# Download dev data
$(eval $(call import,${EXPERIMENT_MAKE_DIR}/download-data/wmt10/dev.mk))
$(eval $(call DOWNLOAD_DATA_WMT10_DEV,${DOWNLOAD_DIR}))

# Download test data
$(eval $(call import,${EXPERIMENT_MAKE_DIR}/download-data/wmt10/test.mk))
$(eval $(call DOWNLOAD_DATA_WMT10_TEST,${DOWNLOAD_DIR}))

####                                                                        ####
####             ... done downloading data from the web                     ####
################################################################################



################################################################################
####                                                                        ####
####                      Expand data from the web                          ####

# Make dir for expanded data
$(eval $(call import,${EXPERIMENT_MAKE_DIR}/expand-data/wmt10/dir.mk))
$(eval $(call EXPAND_DATA_WMT10_DIR,${UNZIPPED_DATA_DIR}))

# Expand monolingual Europarl training data
$(eval $(call import,${EXPERIMENT_MAKE_DIR}/expand-data/wmt10/training-monolingual.mk))
$(eval $(call EXPAND_DATA_WMT10_TRAINING_MONOLINGUAL,${DOWNLOAD_DIR},${UNZIPPED_DATA_DIR}))

# Expand parallel Europarl training data
$(eval $(call import,${EXPERIMENT_MAKE_DIR}/expand-data/wmt10/training-parallel.mk))
$(eval $(call EXPAND_DATA_WMT10_TRAINING_PARALLEL,${DOWNLOAD_DIR},${UNZIPPED_DATA_DIR}))

# Expand parallel Czeng training data
$(eval $(call import,${EXPERIMENT_MAKE_DIR}/expand-data/wmt10/training-cz-en.mk))
$(eval $(call EXPAND_DATA_WMT10_TRAINING_CZ_EN,${DOWNLOAD_DIR},${UNZIPPED_DATA_DIR},${CZENG_SCRIPT}))

# Expand parallel 10^9 Fr-En training data
$(eval $(call import,${EXPERIMENT_MAKE_DIR}/expand-data/wmt10/training-huge-fr-en.mk))
$(eval $(call EXPAND_DATA_WMT10_TRAINING_HUGE_FR_EN,${DOWNLOAD_DIR},${UNZIPPED_DATA_DIR}))

# Expand parallel UN Es-En training data
$(eval $(call import,${EXPERIMENT_MAKE_DIR}/expand-data/wmt10/training-un-es-en.mk))
$(eval $(call EXPAND_DATA_WMT10_TRAINING_UN_ES_EN,${DOWNLOAD_DIR},${UNZIPPED_DATA_DIR}))

# Expand parallel UN Fr-En training data
$(eval $(call import,${EXPERIMENT_MAKE_DIR}/expand-data/wmt10/training-un-fr-en.mk))
$(eval $(call EXPAND_DATA_WMT10_TRAINING_UN_FR_EN,${DOWNLOAD_DIR},${UNZIPPED_DATA_DIR}))

# Expand dev data
$(eval $(call import,${EXPERIMENT_MAKE_DIR}/expand-data/wmt10/dev.mk))
$(eval $(call EXPAND_DATA_WMT10_DEV,${DOWNLOAD_DIR},${UNZIPPED_DATA_DIR}))

# Expand test data
$(eval $(call import,${EXPERIMENT_MAKE_DIR}/expand-data/wmt10/test.mk))
$(eval $(call EXPAND_DATA_WMT10_TEST,${DOWNLOAD_DIR},${UNZIPPED_DATA_DIR}))


####                                                                        ####
####               ... done expanding data from the web                     ####
################################################################################



################################################################################
####                                                                        ####
####                        Prepare data for use                            ####

# Link unzipped data (or make toy versions of data)
$(eval $(call import,${EXPERIMENT_MAKE_DIR}/prepare-data/wmt10/link-data.mk))
ifndef TOY_SIZE
$(eval $(call LINK_UNZIPPED_DATA,${UNZIPPED_DATA_DIR},${DATA_DIR}))
else
$(eval $(call LINK_UNZIPPED_DATA_TOY,${UNZIPPED_DATA_DIR},${DATA_DIR},${TOY_SIZE},${TOY_TEST_SIZE},${TOY_TEST_SGM_SCRIPT}))
endif

# Strip XML
$(eval $(call import,${EXPERIMENT_MAKE_DIR}/prepare-data/wmt10/remove-xml.mk))
$(eval $(call LINK_STRIP_XML_DATA,${DATA_DIR},${BARE_XML_FILES},${NON_XML_FILES},${PROCESSED_XML_FILES},${PROCESSED_NON_XML_FILES},${DATA_WITHOUT_XML}))

# Tokenize data
$(eval $(call import,${EXPERIMENT_MAKE_DIR}/prepare-data/wmt10/tokenize.mk))
$(eval $(call TOKENIZE_DATA,${WMT10_SCRIPTS},${DATA_WITHOUT_XML},${TOKENIZED_DATA},${TOKENIZED_FILES}))

# Normalized data
$(eval $(call import,${EXPERIMENT_MAKE_DIR}/prepare-data/wmt10/normalize.mk))
$(eval $(call NORMALIZE_DATA,${WMT10_SCRIPTS},${TOKENIZED_DATA},${NORMALIZED_DATA},${NORMALIZED_FILES}))


####                                                                        ####
####                    ... done preparing data for use                     ####
################################################################################



################################################################################
####                                                                        ####
####                       Train language models                            ####

# Import function defining how to build a language model
$(eval $(call import,${EXPERIMENT_MAKE_DIR}/train/build-language-model.mk))

# Define the files to be used in building the language model
LM_TRAINING_FILE_NAMES:=$(if ${TGT},,$(error TGT is not defined))news-commentary10.${TGT} news.${TGT}.shuffled czeng-train.${TGT}

# Train normalized target language model
$(eval $(call BUILD_LANGUAGE_MODEL,${NORMALIZED_LM_DIR},${SRILM_NGRAM_COUNT},${TGT},${LM_NGRAM_ORDER},${LM_TRAINING_FILE_NAMES},${NORMALIZED_DATA},${SRILM_NGRAM_COUNT_FLAGS}))

# Train pre-normalized target language model for truecasing
$(eval $(call BUILD_LANGUAGE_MODEL,${TOKENIZED_LM_DIR},${SRILM_NGRAM_COUNT},${TGT},${LM_NGRAM_ORDER},${LM_TRAINING_FILE_NAMES},${TOKENIZED_DATA},${SRILM_NGRAM_COUNT_FLAGS}))

####                                                                        ####
####                 ... done training language models                      ####
################################################################################



################################################################################
####                                                                        ####
####                       Train translation model                          ####

# Subsample
$(eval $(call import,${EXPERIMENT_MAKE_DIR}/train/subsample.mk))
SUBSAMPLER_MANIFEST:=news-commentary10.cz-en czeng-train  
SUBSAMPLER_FILES_TO_TRANSLATE:=$(if ${SRC},,$(error SRC is not defined))newssyscomb2009-src.${SRC} news-test2008-src.${SRC} newstest2009-src.${SRC} newstest2010-src.${SRC} em+internal2009.${SRC}
$(eval $(call SUBSAMPLE_DATA,${SUBSAMPLED_DATA},${SRC},${TGT},${SUBSAMPLER_MANIFEST},${NORMALIZED_DATA},${FILTER_SCRIPT},${JOSHUA},${SUBSAMPLER_JVM_FLAGS},${SUBSAMPLER_FILES_TO_TRANSLATE}))

# Align words
$(eval $(call import,${EXPERIMENT_MAKE_DIR}/train/berkeley-align.mk))
$(eval $(call BERKELEY_ALIGN,${BERKELEY_ALIGN_DIR},${SRC},${TGT},${SUBSAMPLED_DATA},${BERKELEYALIGNER},${BERKELEY_NUM_THREADS},${BERKELEY_JVM_FLAGS}))

# Extract Joshua grammar
$(eval $(call import,${EXPERIMENT_MAKE_DIR}/train/extract-grammar.mk))
$(eval $(call EXTRACT_GRAMMAR,${EXTRACT_RULES_DIR},${SRC},${TGT},${BERKELEY_ALIGN_DIR},${SUBSAMPLED_DATA},${JOSHUA},${EXTRACT_RULES_JVM_FLAGS}))

# Minimum error rate training
$(eval $(call import,${EXPERIMENT_MAKE_DIR}/train/mert.mk))
$(eval $(call MERT,${MERT_DIR},${TRANSLATION_GRAMMAR},${JOSHUA},${JOSHUA_MEMORY_FLAGS},${NORMALIZED_LANGUAGE_MODEL},${NORMALIZED_DATA},${MERT_FILE_TO_TRANSLATE},${MERT_REFERENCE_BASE},${MERT_METRIC_NAME},${MERT_NUM_REFERENCES},${LM_NGRAM_ORDER},${JOSHUA_MAX_N_ITEMS},${JOSHUA_THREADS},${MERT_JVM_FLAGS}))


####                                                                        ####
####                  ... done training translation model                   ####
################################################################################



################################################################################
####                                                                        ####
####                           Translate test set                           ####

# Translate using Joshua
$(eval $(call import,${EXPERIMENT_MAKE_DIR}/test/decode.mk))
$(eval $(call RUN_JOSHUA,${JOSHUA_TRANSLATION_DIR},${JOSHUA},${JOSHUA_MEMORY_FLAGS},${JOSHUA_DEV_FILE_TO_TRANSLATE},${JOSHUA_DEV_NBEST_OUTPUT_FILENAME},${MERT_RESULT_CONFIG},))

# Extract 1-best translations
$(eval $(call import,${EXPERIMENT_MAKE_DIR}/test/extract-top-cand.mk))
$(eval $(call JOSHUA_EXTRACT_1BEST,${JOSHUA_EXTRACT_1BEST_DIR},${JOSHUA_EXTRACT_DEV_1BEST_INPUT},${JOSHUA_EXTRACT_DEV_1BEST_OUTPUT_FILENAME},${JOSHUA},${REMOVE_OOV_SCRIPT}))

# Extract MBR-best translations
$(eval $(call import,${EXPERIMENT_MAKE_DIR}/test/extract-mbr-cand.mk))
$(eval $(call JOSHUA_EXTRACT_MBR_BEST,${JOSHUA_EXTRACT_MBR_BEST_DIR},${JOSHUA_EXTRACT_DEV_MBR_BEST_INPUT},${JOSHUA_EXTRACT_DEV_MBR_BEST_OUTPUT_FILENAME},${JOSHUA},${REMOVE_OOV_SCRIPT},${JOSHUA_EXTRACT_MBR_BEST_NUM_THREADS}))


####                                                                        ####
####                    ... done translating test set                       ####
################################################################################



################################################################################
####                                                                        ####
####                   Train truecasing translation model                   ####

####                                                                        ####
####            ... done training truecasing translation model              ####
################################################################################
