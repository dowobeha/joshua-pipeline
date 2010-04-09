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
#### Parameter 2 (required): directory into which data will be expanded
####
#### Example usage: $(eval $(call DOWNLOAD_DATA,/path/to/downloads,/path/to/expanded))

define EXPAND_DATA_WMT10_DIR

$(if $1,,$(error Function $0: a required parameter $$1 (defining DATA_DIR) was omitted))

# Make directory to store original downloaded data
$2:
	mkdir -p $$@

endef

####                                                                        ####
################################################################################

