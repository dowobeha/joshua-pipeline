################################################################################
####                       Purpose of this make file:                       ####
####                                                                        ####
#### This file defines functions to extract the MBR-best Joshua translation
####                                                                        ####
################################################################################


################################################################################
#### Function definition:              
####
define JOSHUA_EXTRACT_MBR_BEST
####
#### Required parameters:
$(if $1,,$(error Function $0: a required parameter $$1 (defining JOSHUA_EXTRACT_MBR_BEST_DIR) was omitted))
$(if $2,,$(error Function $0: a required parameter $$2 (defining JOSHUA_EXTRACT_MBR_BEST_INPUT) was omitted))
$(if $3,,$(error Function $0: a required parameter $$3 (defining JOSHUA_EXTRACT_MBR_BEST_OUTPUT_FILENAME) was omitted))
$(if $4,,$(error Function $0: a required parameter $$4 (defining JOSHUA) was omitted))
$(if $5,,$(warning Function $0: an optional parameter $$5 (defining JOSHUA_EXTRACT_MBR_BEST_NUM_THREADS) was omitted. Assuming value of 1))

all: $1/$3

$1/$3: $2 | $1
	java -cp $4/bin/joshua.jar -Dfile.encoding=utf8 \
		joshua.decoder.NbestMinRiskReranker $$< $$@ false 1 $(call JOSHUA_EXTRACT_MBR_THREADS,$5)


$1:
	mkdir -p $$@

endef
####                                                                        ####
################################################################################


################################################################################
#### Helper function definition:              
####
define JOSHUA_EXTRACT_MBR_THREADS
$(if $1,$1,1)
endef
####                                                                        ####
################################################################################
