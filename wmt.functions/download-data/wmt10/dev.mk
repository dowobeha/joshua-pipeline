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
define DOWNLOAD_DATA_WMT10_DEV

$(if $1,,$(error Function $0: a required parameter $$1 (defining a DOWNLOADS_DIR) was omitted))


# Download all files
downloads: $1/dev.tgz

# Download development sets (4.0 MB)
$1/dev.tgz : | $1
	wget --no-verbose -P $1 http://www.statmt.org/wmt10/dev.tgz


# If someone calls make all, do the sensible thing
all: downloads



# The following targets do not create actual files with that name
.PHONY: all downloads

endef
####
#### end of function
################################################################################


