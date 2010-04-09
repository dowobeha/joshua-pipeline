################################################################################
####                       Purpose of this make file:                       ####
####                                                                        ####
#### This file defines a function to download WMT10 data
####                                                                        ####
################################################################################


################################################################################
#### Function definition:              
####
#### Parameter 1 (required): a directory into which data will be downloaded
####
#### Example usage: $(eval $(call DOWNLOAD_DATA,/path/to/save/data))
define DOWNLOAD_DATA_WMT10

$(if $1,,$(error Function $0: a required parameter $$1 (defining a DOWNLOADS_DIR) was omitted))

# If someone calls make all, do the sensible thing
all: downloads


# Make directory to store original downloaded data
$1:
	mkdir -p $1


# The following targets do not create actual files with that name
.PHONY: all downloads

endef
####
#### end of function
################################################################################


