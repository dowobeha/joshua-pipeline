################################################################################
####                       Purpose of this make file:                       ####
####                                                                        ####
#### This file defines functions to recase text using SRILM
####                                                                        ####
################################################################################

################################################################################
#### Function definition:              
####
define TEST_RECASE_SRILM
####
#### Required parameters:
$(if $1,,$(error Function $0: a required parameter $$1 (defining RECASE_SRILM_TEST_DIR) was omitted))
$(if $2,,$(error Function $0: a required parameter $$2 (defining SRILM_DISAMBIG) was omitted))
$(if $3,,$(error Function $0: a required parameter $$3 (defining TGT) was omitted))
$(if $4,,$(error Function $0: a required parameter $$4 (defining RECASE_LM_NGRAM_ORDER) was omitted))
$(if $5,,$(error Function $0: a required parameter $$5 (defining RECASE_LANGUAGE_MODEL) was omitted))
$(if $6,,$(error Function $0: a required parameter $$6 (defining RECASE_MAP_FILE) was omitted))
$(if $7,,$(error Function $0: a required parameter $$7 (defining RECASE_STRIP_TAGS_SCRIPT) was omitted))
$(if $8,,$(error Function $0: a required parameter $$8 (defining RECASE_TEST_FILE) was omitted))

# Convenient target
all: $1/$(notdir $8)

# Perform recasing
$1/$(notdir $8): $8 $5 $6 | $2 $7 $1
	$2 -lm $5 -keep-unk -order $4 -map $6 -text $8 | perl $7 > $$@

# Make output directory
$1:
	mkdir -p $$@

endef
####                                                                        ####
################################################################################

