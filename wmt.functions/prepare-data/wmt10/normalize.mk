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
#### Parameter 2 (required): TOKENIZED_DATA
#### Parameter 3 (required): NORMALIZED_DATA
#### Parameter 4 (required): NORMALIZED_FILES

define NORMALIZE_DATA

$(if $1,,$(error Function $0: a required parameter $$1 (defining WMT_SCRIPTS) was omitted))
$(if $2,,$(error Function $0: a required parameter $$2 (defining TOKENIZED_DATA) was omitted))
$(if $3,,$(error Function $0: a required parameter $$3 (defining NORMALIZED_DATA) was omitted))
$(if $4,,$(error Function $0: a required parameter $$4 (defining NORMALIZED_FILES) was omitted))


# Normalize zipped plain text data
$3/%.gz: $2/%.gz $1/tokenizer.perl | $3
	zcat $$< | perl $1/lowercase.perl | gzip - > $$@

# Normalize plain text data
$3/%: $2/% $1/tokenizer.perl | $3
	cat $$< | perl $1/lowercase.perl > $$@

# Normalize all data
#
#    Look at all of the files in the prerequisite TOKENIZED_DATA directory,
#    and make a new tokenized file with the same name in the NORMALIZED_DATA directory.
all: $4


# Make directory to store normalized data
$3:
	mkdir -p $$@

endef

####                                                                        ####
################################################################################






