# Calculate the full path to this make file
THIS.MAKEFILE:= $(realpath $(lastword ${MAKEFILE_LIST}))

# Define how to run this file
define USAGE
	$(info  )
	$(info Usage:	make -f ${THIS.MAKEFILE} DATA_WITHOUT_XML=/path/to/data WMT_SCRIPTS=/path/to/scripts TOKENIZED_DATA=/path/to/dir tokenize)
	$(info  )
	$(error )
endef


# If this required parameter is not defined,
#    print usage, then exit
WMT_SCRIPTS ?= $(call USAGE)
DATA_WITHOUT_XML ?= $(call USAGE)
TOKENIZED_DATA ?= $(call USAGE)

# If the user does not specify a target, print out how to run this file
usage:
	$(call USAGE)


# Set a pattern-specific variable to define the language being tokenized
#
#   These rules look at the filename of the target being made (the bit before the colon),
#   and set a new variable value (the bit after the colon) based on what was found.
%.cz:          LANGUAGE=cz
%.cz.gz:       LANGUAGE=cz
%.cz.shuffled: LANGUAGE=cz
%.de:          LANGUAGE=de
%.de.gz:       LANGUAGE=de
%.de.shuffled: LANGUAGE=de
%.en:          LANGUAGE=en
%.en.gz:       LANGUAGE=en
%.en.shuffled: LANGUAGE=en
%.es:          LANGUAGE=es
%.es.gz:       LANGUAGE=es
%.es.shuffled: LANGUAGE=es
%.fr:          LANGUAGE=fr
%.fr.gz:       LANGUAGE=fr
%.fr.shuffled: LANGUAGE=fr
%.hu:          LANGUAGE=hu
%.hu.gz:       LANGUAGE=hu
%.hu.shuffled: LANGUAGE=hu
%.it:          LANGUAGE=it
%.it.gz:       LANGUAGE=it
%.it.shuffled: LANGUAGE=it
%.xx:          LANGUAGE=xx
%.xx.gz:       LANGUAGE=xx
%.xx.shuffled: LANGUAGE=xx


# File names of files after processing
TOKENIZED_FILES:=$(patsubst ${DATA_WITHOUT_XML}/%,${TOKENIZED_DATA}/%,$(wildcard ${DATA_WITHOUT_XML}/*))

# Tokenize zipped plain text data
${TOKENIZED_DATA}/%.gz: ${DATA_WITHOUT_XML}/%.gz ${WMT_SCRIPTS}/tokenizer.perl | ${TOKENIZED_DATA}
	zcat $< | perl ${WMT_SCRIPTS}/tokenizer.perl -l ${LANGUAGE} | gzip - > $@

# Tokenize plain text data
${TOKENIZED_DATA}/%: ${DATA_WITHOUT_XML}/% ${WMT_SCRIPTS}/tokenizer.perl | ${TOKENIZED_DATA}
	cat $< | perl ${WMT_SCRIPTS}/tokenizer.perl -l ${LANGUAGE} > $@

# Tokenize all data
#
#    Look at all of the files in the prerequisite DATA_WITHOUT_XML directory,
#    and make a new tokenized file with the same name in the TOKENIZED_DATA directory.
tokenize: ${TOKENIZED_FILES}


# Make directory to store tokenized data
${TOKENIZED_DATA}:
	mkdir -p $@
