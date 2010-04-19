################################################################################
####                       Purpose of this make file:                       ####
####                                                                        ####
#### This file defines functions to extract the 1-best Joshua translation
####                                                                        ####
################################################################################


################################################################################
#### Function definition:              
####
define JOSHUA_EXTRACT_1BEST
####
#### Required parameters:
$(if $1,,$(error Function $0: a required parameter $$1 (defining JOSHUA_EXTRACT_1BEST_DIR) was omitted))
$(if $2,,$(error Function $0: a required parameter $$2 (defining JOSHUA_EXTRACT_1BEST_INPUT) was omitted))
$(if $3,,$(error Function $0: a required parameter $$3 (defining JOSHUA_EXTRACT_1BEST_OUTPUT_FILENAME) was omitted))
$(if $4,,$(error Function $0: a required parameter $$4 (defining JOSHUA) was omitted)) \
$(if $5,,$(error Function $0: a required parameter $$5 (defining REMOVE_OOV_SCRIPT) was omitted))

all: $1/$3

$1/$3.withOOV: $2 | $1
	java -cp $4/bin/joshua.jar -Dfile.encoding=utf8 \
		joshua.util.ExtractTopCand $$< $$@

$1/$3: $1/$3.withOOV $5 | $1
	$5 $$< $$@


$1:
	mkdir -p $$@

endef
####                                                                        ####
################################################################################
