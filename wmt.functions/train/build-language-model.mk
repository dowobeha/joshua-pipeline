################################################################################
####                       Purpose of this make file:                       ####
####                                                                        ####
#### This file defines functions to extract a translation grammar using Joshua
####                                                                        ####
################################################################################


################################################################################
#### Function definition:              
####
define BUILD_LANGUAGE_MODEL
####
#### Required parameters:
$(if $1,,$(error Function $0: a required parameter $$1 (defining TRAINED_LM_DIR) was omitted))
$(if $2,,$(error Function $0: a required parameter $$2 (defining SRILM_NGRAM_COUNT) was omitted))
$(if $3,,$(error Function $0: a required parameter $$3 (defining TGT) was omitted))
$(if $4,,$(error Function $0: a required parameter $$4 (defining LM_NGRAM_ORDER) was omitted))
$(if $5,,$(error Function $0: a required parameter $$5 (defining LM_TRAINING_FILE_NAMES) was omitted))
$(if $6,,$(error Function $0: a required parameter $$6 (defining LM_TRAINING_DIR) was omitted))

# Convenient target
all: $1/$3.lm

# Build language model
$1/$3.lm: $1/monolingual.$3 | $2 $1
	$2 -order $4 -interpolate -kndiscount -text $$< -lm $$@

# Concatenate the monolingual training files
$1/monolingual.$3: $$(call LM_TRAINING_FILES,$5,$6) $1/monolingual.$3.manifest | $1
	cat $$^ > $$@

# Save the file names used
$1/monolingual.$3.manifest: | $1
	for fileName in $$(call LM_TRAINING_FILES,$5,$6); do echo $$$$fileName >> $$@; done

# Make output directory
$1:
	mkdir -p $$@


endef

####                                                                        ####
################################################################################



################################################################################
#### Helper function definition:              
####
define LM_TRAINING_FILES
$(if $1,,$(error Function $0: a required parameter $$1 (defining LM_TRAINING_FILE_NAMES) was omitted))\
$(if $2,,$(error Function $0: a required parameter $$2 (defining LM_TRAINING_DIR) was omitted))\
$(foreach file,$1,$(abspath $2/${file}))
endef

####                                                                        ####
################################################################################
