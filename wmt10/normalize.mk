# Calculate the full path to this make file
THIS.MAKEFILE:= $(realpath $(lastword ${MAKEFILE_LIST}))

# Define how to run this file
define USAGE
	$(info  )
	$(info Usage:	make -f ${THIS.MAKEFILE} TOKENIZED_DATA=/path/to/data WMT_SCRIPTS=/path/to/scripts NORMALIZED_DATA=/path/to/dir normalize)
	$(info  )
	$(error )
endef


# If this required parameter is not defined,
#    print usage, then exit
WMT_SCRIPTS ?= $(call USAGE)
TOKENIZED_DATA ?= $(call USAGE)
NORMALIZED_DATA ?= $(call USAGE)


# File names of files after processing
NORMALIZED_FILES:=$(patsubst ${TOKENIZED_DATA}/%,${NORMALIZED_DATA}/%,$(wildcard ${TOKENIZED_DATA}/*))

# Normalize zipped plain text data
${NORMALIZED_DATA}/%.gz: ${TOKENIZED_DATA}/%.gz ${WMT_SCRIPTS}/tokenizer.perl | ${NORMALIZED_DATA}
	zcat $< | perl ${WMT_SCRIPTS}/lowercase.perl | gzip - > $@

# Normalize plain text data
${NORMALIZED_DATA}/%: ${TOKENIZED_DATA}/% ${WMT_SCRIPTS}/tokenizer.perl | ${NORMALIZED_DATA}
	cat $< | perl ${WMT_SCRIPTS}/lowercase.perl > $@

# Normalize all data
#
#    Look at all of the files in the prerequisite TOKENIZED_DATA directory,
#    and make a new tokenized file with the same name in the NORMALIZED_DATA directory.
normalize: ${NORMALIZED_FILES}


# Make directory to store normalized data
${NORMALIZED_DATA}:
	mkdir -p $@
