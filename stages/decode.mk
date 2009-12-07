################################################################################
################################################################################
####                                                                        ####
####                          Decoder make file                             ####
####                                                                        ####
################################################################################
################################################################################

$(info )
$(info This make file defines:)
$(info --- how to translate the chunks of the test set,)
$(info --- how to post-process the translated chunks of the test set, and)
$(info --- how to merge the final translated results into a single nbest output file.)
$(info )


################################################################################
################################################################################
####                                                                        ####
####      Verify that all required, user-defined variables are defined      ####
####                                                                        ####
################################################################################
################################################################################

EXPERIMENT_DIR ?= $(error EXPERIMENT_DIR is not defined)
STAGE_NAME ?= $(error STAGE_NAME is not defined)
STAGE_NUMBER ?= $(error STAGE_NUMBER is not defined)

JOSHUA ?= $(error JOSHUA variable is not defined)
JOSHUA_MEMORY_FLAGS ?= $(error JOSHUA_MEMORY_FLAGS is not defined)
JOSHUA_CONFIG ?= $(error JOSHUA_CONFIG is not defined)

MBR_MEMORY_FLAGS ?= $(error MBR_MEMORY_FLAGS is not defined)

FILE_TO_TRANSLATE ?= $(error FILE_TO_TRANSLATE is not defined)


################################################################################
################################################################################
####                                                                        ####
####                        Derived Variables                               ####
####                                                                        ####
################################################################################
################################################################################

# Strip the directory path from the file name
BASE_NAME:=$(notdir ${FILE_TO_TRANSLATE})

# Directory where results will be stored
BASE_DIR:=${EXPERIMENT_DIR}/${STAGE_NUMBER}.${STAGE_NAME}


################################################################################
################################################################################
####                                                                        ####
####                          Make targets                                  ####
####                                                                        ####
################################################################################
################################################################################

all: ${BASE_DIR}/nbest/${BASE_NAME} ${BASE_DIR}/1best/${BASE_NAME}


${BASE_DIR}/1best/${BASE_NAME}: ${BASE_DIR}/nbest/${BASE_NAME} | ${BASE_DIR}/1best
#	Run Minimum Bayes Risk extraction using specified JVM parameters
	java ${MBR_MEMORY_FLAGS} -cp ${JOSHUA}/bin \
		joshua.decoder.NbestMinRiskReranker $< $@ false 1

${BASE_DIR}/nbest/${BASE_NAME}: ${BASE_DIR}/raw_decoder_output/${BASE_NAME} | ${BASE_DIR}/nbest
	${SCRIPTS_DIR}/strip-nonASCII-v2.rb < $< > $@

${BASE_DIR}/raw_decoder_output/${BASE_NAME}: ${FILE_TO_TRANSLATE} ${JOSHUA_CONFIG} | ${BASE_DIR}/raw_decoder_output
#	Run Joshua using specified JVM parameters
	java ${JOSHUA_MEMORY_FLAGS} -cp ${JOSHUA}/bin \
		-Djava.library.path=${JOSHUA}/lib \
		-Dfile.encoding=utf8 \
		joshua.decoder.JoshuaDecoder \
		${JOSHUA_CONFIG} \
		${FILE_TO_TRANSLATE} \
		$@

${BASE_DIR}/1best:
	mkdir -p $@

${BASE_DIR}/nbest:
	mkdir -p $@

${BASE_DIR}/raw_decoder_output:
	mkdir -p $@

${BASE_DIR}:
	mkdir -p $@

################################################################################
################################################################################
####                                                                        ####
####                   Misc make house-keeping                              ####
####                                                                        ####
################################################################################
################################################################################

# No actual file by this name is created.
# Run this target even if there's a file by this name that exists.
#
# See section 4.5 Phony Targets of the GNU Make Manual.
#
.PHONY: all


# By default, make has a lot of old-fashioned suffix rules that it will try to use. 
#
# Since we don't want any of these rules to fire,
# disable them by setting the list of suffixes that use suffix rules to be empty.
# 
# See section 10.7 Old-Fashioned Suffix Rules of the GNU Make Manual.
#
.SUFFIXES:

