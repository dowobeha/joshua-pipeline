################################################################################
################################################################################
####                                                                        ####
####                          Decoder make file                             ####
####                                                                        ####
################################################################################
################################################################################

$(info This make file defines:)
$(info --- how to extract a grammar for a test set,)
$(info --- how to split the test set into multiple chunks,)
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

JOSHUA ?= $(error JOSHUA variable is not defined)
JOSHUA_MEMORY_FLAGS ?= $(error JOSHUA_MEMORY_FLAGS is not defined)
JOSHUA_CONFIG ?= $(error JOSHUA_CONFIG is not defined)
TRAINING_SRC ?= $(error TRAINING_SRC is not defined)
TRAINING_TGT ?= $(error TRAINING_TGT is not defined)
TRAINING_ALN ?= $(error TRAINING_ALN is not defined)
GRAMMAR_ROOT ?= $(error GRAMMAR_ROOT is not defined)
HIERO ?= $(error HIERO is not defined)
HIERO_COMPILE ?= $(error HIERO_COMPILE is not defined)
HIERO_COMPILE_INI ?= $(error HIERO_COMPILE_INI is not defined)
LM_FILE ?= $(error LM_FILE is not defined)
SPLIT_SIZE ?= $(error SPLIT_SIZE is not defined)
FILE_TO_TRANSLATE ?= $(error FILE_TO_TRANSLATE is not defined)
NBEST_OUTPUT ?= $(error NBEST_OUTPUT is not defined)
RENUMBER_NBEST_OUTPUT ?= $(error RENUMBER_NBEST_OUTPUT is not defined)



################################################################################
################################################################################
####                                                                        ####
####                        Derived Variables                               ####
####                                                                        ####
################################################################################
################################################################################


# Get the full canonical path to the file to be translated
#
# See section 8.3 Functions for File Names of the GNU Make Manual.
#
TRANSLATE_WITH_PATH:=$(realpath ${FILE_TO_TRANSLATE})

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
TRANSLATE_SIZE:=$(shell wc -l ${TRANSLATE} | cut -d " " -f 1)

# Calculate the number of lines in each split chunk of the file to be translated.
# 
# This command uses an inline perl script.
# See section 8.11 The shell Function of the GNU Make Manual for the shell function.
TRANSLATE_SIZE_PER_CHUNK:=$(shell perl -e "use POSIX qw(ceil); print ceil(${TRANSLATE_SIZE}/${SPLIT_SIZE})")

# Define the location of the Joshua glue grammar, unless it has already been defined.
GLUE_GRAMMAR ?= ${JOSHUA}/grammars/hiero.glue

# Calculate the name of each grammar file
#
# The shell command is more or less equivalant to using the `` notation.
# The cammand is an inline perl script. Note that dollar signs for perl variables are indicated by $$.
# Make uses $ as a variable indicator, so to let perl see the dollar sign, it must be escaped as $$.
#
# See section 6.1 Basics of Variable References of the GNU Make Manual for the $$ notation.
# See section 8.11 The shell Function of the GNU Make Manual for the shell function.
GRAMMARS=$(shell perl -e 'for ($$i=0; $$i<${SPLIT_SIZE}; $$i++) { printf("${GRAMMAR_ROOT}/${TRANSLATE}.%0".length(${SPLIT_SIZE}-1)."d.grammar ",$$i);}')

# Calculate the name of each nbest translation output file
#
# The shell command is more or less equivalant to using the `` notation.
# The cammand is an inline perl script. Note that dollar signs for perl variables are indicated by $$.
# Make uses $ as a variable indicator, so to let perl see the dollar sign, it must be escaped as $$.
#
# See section 6.1 Basics of Variable References of the GNU Make Manual for the $$ notation.
# See section 8.11 The shell Function of the GNU Make Manual for the shell function.
NBEST_PARTS=$(shell perl -e 'for ($$i=0; $$i<${SPLIT_SIZE}; $$i++) { printf("${NBEST_OUTPUT}.%0".length(${SPLIT_SIZE}-1)."d ",$$i);}')



################################################################################
################################################################################
####                                                                        ####
####                       Canned Commands                                  ####
####                                                                        ####
################################################################################
################################################################################


# Convenience function to run the decoder
#
# This is a canned command, as defined in 
# section 5.8 Defining Canned Command Sequences of the GNU Make Manual.
define RUN_DECODER
java ${JOSHUA_MEMORY_FLAGS} -cp ${JOSHUA}/bin -Djava.library.path=${JOSHUA}/lib -Dfile.encoding=utf8 joshua.decoder.JoshuaDecoder $^ $@.raw_output &> $@.log
endef

# Convenience function to run post-processing
#
# This is a canned command, as defined in 
# section 5.8 Defining Canned Command Sequences of the GNU Make Manual.
define POST_PROCESS
/scratch/lane/2009-11-09_subsampled.berkeley_alignments.mert/strip-nonASCII-v2.rb < $@.raw_output > $@
endef



################################################################################
################################################################################
####                                                                        ####
####                          Make targets                                  ####
####                                                                        ####
################################################################################
################################################################################

all: ${NBEST_OUTPUT}


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
${GRAMMAR_ROOT}/${TRANSLATE}/%: ${TRANSLATE_WITH_PATH} | ${GRAMMAR_ROOT}/${TRANSLATE}
	split -d -a ${DIGITS_IN_SPLIT_SIZE} -l ${TRANSLATE_SIZE_PER_CHUNK} ${TRANSLATE_WITH_PATH} ${GRAMMAR_ROOT}/${TRANSLATE}/

# Extract translation grammars for each chunk of data to be translated.
#
${GRAMMAR_ROOT}/${TRANSLATE}.%.grammar: ${GRAMMAR_ROOT}/${TRANSLATE}/% ${HIERO_EXTRACTION_INI} | ${GRAMMAR_ROOT} 
	${HIERO} $< -c ${HIERO_EXTRACTION_INI} -x $@

# Construct a Joshua configuration file for a chunk of the data to be translated.
#
${JOSHUA_CONFIG}.%: ${JOSHUA_CONFIG} | ${LM_FILE} ${GRAMMAR_ROOT}/${TRANSLATE}.%.grammar ${GLUE_GRAMMAR}
	echo "lm_file=${LM_FILE}" > $@
	echo "tm_file=${GRAMMAR_ROOT}/${TRANSLATE}.$*.grammar" >> $@
	echo "glue_file=${GLUE_GRAMMAR}" >> $@
	cat ${JOSHUA_CONFIG} >> $@

# Translate and post-process a chunk of the data to be translated.
#
${NBEST_OUTPUT}.%: ${JOSHUA_CONFIG}.% ${GRAMMAR_ROOT}/${TRANSLATE}/%
	${RUN_DECODER}
	${POST_PROCESS}

# Concatenate all translated data chunks.
#
${NBEST_OUTPUT}: ${NBEST_PARTS}
	cat ${NBEST_PARTS} > $@.raw
	${RENUMBER_NBEST_OUTPUT} < $@.raw > $@



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




###########################################
#
#  The following can probably be deleted.


# This function concatenates the contents of a list of prerequisite files ($^),
# into an output target file ($@).
#
# To use, put ${MERGE} as the contents of a make target.
#
# This is essentially equivalent to calling "cat $< > $@"
#
# However, when make is run with the -j option (parallel execution),
# it is dangerous and unpredictable to use standard input.
#
# See section 5.4 Parallel Execution of the GNU Make Manual for more on this problem.
#define MERGE
#perl -e '$$lastArg=$$#ARGV; $$lastArg>0 || exit; open OUT, ">$$ARGV[$$lastArg]" or die $$!; for ($$i=0; $$i<$$lastArg; $$i++) { open FILE, "$$ARGV[$$i]" or die $$!; while (my $$line = <FILE>) { print OUT "$$line";} close FILE;  } close OUT;' $^ $@
#endef


