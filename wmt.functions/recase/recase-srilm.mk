################################################################################
####                       Purpose of this make file:                       ####
####                                                                        ####
#### This file defines functions to train a recaser using SRILM
####                                                                        ####
################################################################################

################################################################################
#### Function definition:              
####
define TRAIN_RECASE_SRILM
####
#### Required parameters:
$(if $1,,$(error Function $0: a required parameter $$1 (defining RECASE_SRILM_DIR) was omitted))
$(if $2,,$(error Function $0: a required parameter $$2 (defining SRILM_NGRAM_COUNT) was omitted))
$(if $3,,$(error Function $0: a required parameter $$3 (defining TGT) was omitted))
$(if $4,,$(error Function $0: a required parameter $$4 (defining RECASE_LM_NGRAM_ORDER) was omitted))
$(if $5,,$(error Function $0: a required parameter $$5 (defining RECASE_SRILM_TRAINING_FILE_NAMES) was omitted))
$(if $6,,$(error Function $0: a required parameter $$6 (defining TRUECASE_MAPPING_SCRIPT) was omitted))


# Convenient target
all: $1/$3.lm $1/truecase.$3.map

# Build language model
$1/$3.lm: $1/monolingual.$3 | $2 $1
	$2 -order $4 -interpolate -kndiscount -text $$< -lm $$@

# Concatenate the monolingual training files
$1/monolingual.$3: $5 $1/monolingual.$3.manifest | $1
	cat $$^ > $$@

# Save the file names used
$1/monolingual.$3.manifest: | $1
	for fileName in $5; do echo $$$$fileName >> $$@; done

# Create a casing map
$1/truecase.$3.map: | $1
	$6 < $5 > $$@

# Make output directory
$1:
	mkdir -p $$@

endef
####                                                                        ####
################################################################################

