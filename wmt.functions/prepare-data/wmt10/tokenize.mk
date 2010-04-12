################################################################################
####                       Purpose of this make file:                       ####
####                                                                        ####
#### This file defines functions to remove XML
####                                                                        ####
################################################################################


################################################################################
#### Function definition:              
####
#### Parameter 1 (required): WMT_SCRIPTS
#### Parameter 2 (required): DATA_WITHOUT_XML
#### Parameter 3 (required): TOKENIZED_DATA
#### Parameter 4 (required): TOKENIZED_FILES

define TOKENIZE_DATA

$(if $1,,$(error Function $0: a required parameter $$1 (defining WMT_SCRIPTS) was omitted))
$(if $2,,$(error Function $0: a required parameter $$2 (defining DATA_WITHOUT_XML) was omitted))
$(if $3,,$(error Function $0: a required parameter $$3 (defining TOKENIZED_DATA) was omitted))
$(if $4,,$(error Function $0: a required parameter $$4 (defining TOKENIZED_FILES) was omitted))

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



# Tokenize zipped plain text data
$3/%.gz: $2/%.gz $1/tokenizer.perl | $3
	zcat $$< | perl $1/tokenizer.perl -l $${LANGUAGE} | gzip - > $$@

# Tokenize plain text data
$3/%: $2/% $1/tokenizer.perl | $3
	cat $$< | perl $1/tokenizer.perl -l $${LANGUAGE} > $$@

# Tokenize all data
#
#    Look at all of the files in the prerequisite DATA_WITHOUT_XML directory,
#    and make a new tokenized file with the same name in the TOKENIZED_DATA directory.
all: $4


# Make directory to store tokenized data
$3:
	mkdir -p $$@


endef



