################################################################################
####                       Purpose of this make file:                       ####
####                                                                        ####
#### This file defines functions to link data and make toy data
####                                                                        ####
################################################################################


################################################################################
#### Function definition:              
####
#### Parameter 1 (required): directory where data was expanded
#### Parameter 2 (required): directory into which data will be linked
####
#### Example usage: $(eval $(call LINK_UNZIPPED_DATA,/path/to/data,/path/whereto/link))

define LINK_UNZIPPED_DATA

$(if $1,,$(error Function $0: a required parameter $$1 (defining UNZIPPED_DATA_DIR) was omitted))
$(if $2,,$(error Function $0: a required parameter $$2 (defining DATA_DIR) was omitted))

all: $(foreach file,$(wildcard $1/*),$(subst $1,$2,${file}))

$2/%: $1/% | $2
	ln -fs $$< $$@

$2:
	mkdir -p $$@

endef

####                                                                        ####
################################################################################



################################################################################
#### Function definition:              
####
#### Parameter 1 (required): directory where data was expanded
#### Parameter 2 (required): directory into which data will be linked
#### Parameter 3 (required): value to pass to head, when extracting just some lines
####
#### Example usage: $(eval $(call LINK_UNZIPPED_DATA_TOY,/path/to/data,/path/whereto/link))

define LINK_UNZIPPED_DATA_TOY

$(if $1,,$(error Function $0: a required parameter $$1 (defining UNZIPPED_DATA_DIR) was omitted))
$(if $2,,$(error Function $0: a required parameter $$2 (defining DATA_DIR) was omitted))
$(if $3,,$(error Function $0: a required parameter $$3 (defining TOY_SIZE) was omitted))
$(if $4,,$(error Function $0: a required parameter $$4 (defining TOY_TEST_SIZE) was omitted))
$(if $5,,$(error Function $0: a required parameter $$5 (defining TOY_TEST_SGM_SCRIPT) was omitted))

all: $(foreach file,$(wildcard $1/*),$(subst $1,$2,${file}))

$2/%.sgm: $1/%.sgm | $2
	$5 $$< $$@ $4

$2/%: $1/% | $2
	head -n $3 $$< > $$@ 

$2:
	mkdir -p $$@

endef

####                                                                        ####
################################################################################
