################################################################################
################################################################################
####                                                                        ####
####                          Decoder make file                             ####
####                                                                        ####
################################################################################
################################################################################

$(info )
$(info This make file defines:)
$(info --- how to extract a grammar for a test set,)
$(info --- how to split the test set into multiple chunks,)
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

TRAINING_SRC ?= $(error TRAINING_SRC is not defined)
TRAINING_TGT ?= $(error TRAINING_TGT is not defined)
TRAINING_ALN ?= $(error TRAINING_ALN is not defined)
FILE_TO_TRANSLATE ?= $(error FILE_TO_TRANSLATE is not defined)
SPLIT_SIZE ?= $(error SPLIT_SIZE is not defined. Define to be the number of parts the file to translate should be split into.)

HIERO_DIR ?= $(error HIERO_DIR is not defined)


################################################################################
################################################################################
####                                                                        ####
####                        Derived Variables                               ####
####                                                                        ####
################################################################################
################################################################################

# Get the path to the hiero decoder / rule extractor
HIERO ?= ${HIERO_DIR}/hiero/decoder.py

# Get the path to the hiero suffix array compilation code
HIERO_COMPILE := ${HIERO_DIR}/sa-utils/compile_files.pl

# Get the path to the hiero suffx array compilation config file
HIERO_COMPILE_INI := ${HIERO_DIR}/sa-utils/decoder.extract.ini


# Get the full canonical path to the file to be translated
#
# See section 8.3 Functions for File Names of the GNU Make Manual.
#
TRANSLATE_WITH_PATH:=$(realpath ${FILE_TO_TRANSLATE})

# Define the directory for stoing grammar files
GRAMMAR_ROOT ?= ${EXPERIMENT_DIR}/${STAGE_NUMBER}.${STAGE_NAME}

# Define the location where the hiero suffix array will be created.
HIERO_SUFFIX_ARRAY_DIR=${GRAMMAR_ROOT}/hiero_suffix_array

# Define the location where the hiero extraction configuration file will be created,
# unless this variable has already been defined.
HIERO_EXTRACTION_INI ?= ${HIERO_SUFFIX_ARRAY_DIR}/out.ini

# Calculate the number of digits needed to represent 
# all ${SPLIT_SIZE} split chunks of the file to be translated.
#                                                                                                                                                                                                  
# This command uses an inline perl script.                                                                                                                                                                      
# See section 8.11 The shell Function of the GNU Make Manual for the shell function. 
DIGITS_IN_SPLIT_SIZE:=$(shell perl -e "use POSIX qw(ceil); print length(ceil(${SPLIT_SIZE}-1))")

# Get the filename of the file to be translated, discarding any preceding path name information.
#
# See section 8.3 Functions for File Names of the GNU Make Manual for the notdir function
TRANSLATE:=$(notdir ${TRANSLATE_WITH_PATH})


# Calculate the number of lines in the file to be translated
#
# See section 8.11 The shell Function of the GNU Make Manual for the shell function. 
TRANSLATE_SIZE:=$(shell wc -l ${TRANSLATE_WITH_PATH} | cut -d " " -f 1)

# Calculate the number of lines in each split chunk of the file to be translated.
# 
# This command uses an inline perl script.
# See section 8.11 The shell Function of the GNU Make Manual for the shell function.
TRANSLATE_SIZE_PER_CHUNK:=$(shell perl -e "use POSIX qw(ceil); print ceil(${TRANSLATE_SIZE}/${SPLIT_SIZE})")

# Calculate the name of each grammar file
#
# The shell command is more or less equivalant to using the `` notation.
# The cammand is an inline perl script. Note that dollar signs for perl variables are indicated by $$.
# Make uses $ as a variable indicator, so to let perl see the dollar sign, it must be escaped as $$.
#
# See section 6.1 Basics of Variable References of the GNU Make Manual for the $$ notation.
# See section 8.11 The shell Function of the GNU Make Manual for the shell function.
GRAMMARS=$(shell perl -e 'for ($$i=0; $$i<${SPLIT_SIZE}; $$i++) { printf("${GRAMMAR_ROOT}/${TRANSLATE}.%0".length(${SPLIT_SIZE}-1)."d.grammar ",$$i);}')

# Calculate the name of each chunk of data to be translated
#
# The shell command is more or less equivalant to using the `` notation.
# The cammand is an inline perl script. Note that dollar signs for perl variables are indicated by $$.
# Make uses $ as a variable indicator, so to let perl see the dollar sign, it must be escaped as $$.
#
# See section 6.1 Basics of Variable References of the GNU Make Manual for the $$ notation.
# See section 8.11 The shell Function of the GNU Make Manual for the shell function.
SPLIT_CHUNKS=$(shell perl -e 'for ($$i=0; $$i<${SPLIT_SIZE}; $$i++) { printf("${GRAMMAR_ROOT}/${TRANSLATE}/%0".length(${SPLIT_SIZE}-1)."d ",$$i);}')



################################################################################
################################################################################
####                                                                        ####
####                          Make targets                                  ####
####                                                                        ####
################################################################################
################################################################################

all: ${GRAMMARS}


# Construct an empty directory for the Hiero suffix array files
#
${HIERO_SUFFIX_ARRAY_DIR}:
	mkdir -p $@

# Compile the Hiero suffix array,
# and construct a configuration file for use during grammar extraction
#
${HIERO_EXTRACTION_INI}:  ${TRAINING_SRC} ${TRAINING_TGT} ${TRAINING_ALN} | ${HIERO_SUFFIX_ARRAY_DIR}
	${HIERO_COMPILE} ${TRAINING_SRC} ${TRAINING_TGT} ${TRAINING_ALN} /dev/null ${HIERO_COMPILE_INI} ${HIERO_SUFFIX_ARRAY_DIR} > $@

# Construct an empty directory to store translation grammars and files to be translated.
#
${GRAMMAR_ROOT}:
	mkdir -p $@

# Construct an empty directory to store the chunks of data to be translated.
#
${GRAMMAR_ROOT}/${TRANSLATE}:
	mkdir -p $@

# Split the data to be translated into chunks
#
${SPLIT_CHUNKS}: ${TRANSLATE_WITH_PATH} | ${GRAMMAR_ROOT}/${TRANSLATE}
	split -d -a ${DIGITS_IN_SPLIT_SIZE} -l ${TRANSLATE_SIZE_PER_CHUNK} ${TRANSLATE_WITH_PATH} ${GRAMMAR_ROOT}/${TRANSLATE}/

# Extract translation grammars for each chunk of data to be translated.
#
${GRAMMAR_ROOT}/${TRANSLATE}.%.grammar: ${GRAMMAR_ROOT}/${TRANSLATE}/% ${HIERO_EXTRACTION_INI} | ${GRAMMAR_ROOT} 
	${HIERO} $< -c ${HIERO_EXTRACTION_INI} -x $@



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

# Automatically delete these files
#
# See section 10.4 Chains of Implicit Rules of the GNU Make Manual.
#
.INTERMEDIATE: ${JOSHUA_CONFIG}.* ${NBEST_OUTPUT}.*

# By default, make has a lot of old-fashioned suffix rules that it will try to use. 
#
# Since we don't want any of these rules to fire,
# disable them by setting the list of suffixes that use suffix rules to be empty.
# 
# See section 10.7 Old-Fashioned Suffix Rules of the GNU Make Manual.
#
.SUFFIXES:

