################################################################################
################################################################################
####                                                                        ####
####                          Decoder make file                             ####
####                                                                        ####
################################################################################
################################################################################

# Calculate the full path to this make file
THIS.MAKEFILE:= $(realpath $(lastword ${MAKEFILE_LIST}))

# Define how to run this file
define USAGE
	$(info  )
	$(info Usage:	make -f ${THIS.MAKEFILE} JOSHUA=/path/to/joshua decode)
	$(info  )
	$(error )
endef


################################################################################
################################################################################
####                                                                        ####
####      Verify that all required, user-defined variables are defined      ####
####                                                                        ####
################################################################################
################################################################################

SRC ?= $(call USAGE)
TGT ?= $(call USAGE)

JOSHUA ?= $(call USAGE)
JOSHUA_MEMORY_FLAGS ?= $(call USAGE)

MERT_DIR ?= $(call USAGE)

JOSHUA_RULES_DIR ?= $(call USAGE)

JOSHUA_TRANSLATION_INPUT_DIR ?= $(call USAGE)
JOSHUA_TRANSLATION_INPUT ?= $(call USAGE)
JOSHUA_TRANSLATION_OUTPUT ?= $(call USAGE)

JOSHUA_TRANSLATION_DIR ?= $(call USAGE)



################################################################################
################################################################################
####                                                                        ####
####                          Make targets                                  ####
####                                                                        ####
################################################################################
################################################################################

joshua_decode: ${JOSHUA_TRANSLATION_DIR}/${JOSHUA_TRANSLATION_OUTPUT}
all: joshua_decode

${JOSHUA_TRANSLATION_DIR}/joshua.config: ${MERT_DIR}/joshua.config.ZMERT.final ${JOSHUA_RULES_DIR}/${SRC}-${TGT}.grammar | ${JOSHUA_TRANSLATION_DIR}
	echo "tm_file=${JOSHUA_RULES_DIR}/${SRC}-${TGT}.grammar" > $@
	cat $< | sed 's/tm_file.*//' >> $@

${JOSHUA_TRANSLATION_DIR}/${JOSHUA_TRANSLATION_OUTPUT}: ${JOSHUA_TRANSLATION_INPUT_DIR}/${JOSHUA_TRANSLATION_INPUT} ${JOSHUA_TRANSLATION_DIR}/joshua.config ${JOSHUA}/bin/joshua.jar | ${JOSHUA_TRANSLATION_DIR}
#	Run Joshua using specified JVM parameters
	java ${JOSHUA_MEMORY_FLAGS} -cp ${JOSHUA}/bin/joshua.jar \
		-Djava.library.path=${JOSHUA}/lib \
		-Dfile.encoding=utf8 \
		joshua.decoder.JoshuaDecoder \
		${JOSHUA_TRANSLATION_DIR}/joshua.config \
		$< \
		$@

${JOSHUA_TRANSLATION_DIR}:
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

