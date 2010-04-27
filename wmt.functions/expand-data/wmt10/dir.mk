################################################################################
####                       Purpose of this make file:                       ####
####                                                                        ####
#### This file defines a function to download WMT10 data
####                                                                        ####
################################################################################


################################################################################
#### Function definition:              
####
#### Parameter 1 (required): directory where data was downloaded
####
#### Example usage: $(eval $(call UNZIPPED_DATA_DIR,/path/to/expanded))

define EXPAND_DATA_WMT10_DIR

$(if $1,,$(error Function $0: a required parameter $$1 (defining DATA_DIR) was omitted))

# Make directory to store original downloaded data
$1:
	mkdir -p $$@

endef

####                                                                        ####
################################################################################

