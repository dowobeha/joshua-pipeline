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
#### Parameter 2 (required): username for downloading the czeng09-data 
####
#### Example usage: $(eval $(call DOWNLOAD_DATA,/path/to/save/data,myUserName))
define DOWNLOAD_DATA_WMT10_TRAINING_CZEN

$(if $1,,$(error Function $0: a required parameter $$1 (defining a DOWNLOADS_DIR) was omitted))
$(if $2,,$(error Function $0: a required parameter $$2 (defining a CZEN_USERNAME) was omitted))


# Download all files
downloads: $(foreach n,0 1 2 3 4 5 6 7,$1/data-plaintext.${n}.tar)

$1/data-plaintext.%.tar: | $1
	wget --no-verbose -P $1 --user=${2} --password=czeng http://ufallab2.ms.mff.cuni.cz/~bojar/czeng09-data/data-plaintext.$$*.tar


# If someone calls make all, do the sensible thing
all: downloads


# The following targets do not create actual files with that name
.PHONY: all downloads

endef
####
#### end of function
################################################################################


