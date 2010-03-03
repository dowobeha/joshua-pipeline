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
	$(info Usage:	make -f ${THIS.MAKEFILE} JOSHUA=/path/to/joshua joshua-extract-top-cand)
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

JOSHUA ?= $(call USAGE)

JOSHUA_TRANSLATION_OUTPUT ?= $(call USAGE)
JOSHUA_TRANSLATION_DIR ?= $(call USAGE)

JOSHUA_EXTRACT_TOP_CAND_DIR ?= $(call USAGE)


################################################################################
################################################################################
####                                                                        ####
####                          Make targets                                  ####
####                                                                        ####
################################################################################
################################################################################

joshua-extract-top-cand: ${JOSHUA_EXTRACT_TOP_CAND_DIR}/${JOSHUA_TRANSLATION_OUTPUT}
all: joshua-extract-top-cand

${JOSHUA_EXTRACT_TOP_CAND_DIR}/${JOSHUA_TRANSLATION_OUTPUT}: ${JOSHUA_TRANSLATION_DIR}/${JOSHUA_TRANSLATION_OUTPUT} | ${JOSHUA_EXTRACT_TOP_CAND_DIR}
	java -cp ${JOSHUA}/bin/joshua.jar -Dfile.encoding=utf8 \
		joshua.util.ExtractTopCand $< $@


${JOSHUA_EXTRACT_TOP_CAND_DIR}:
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

