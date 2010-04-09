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
define DOWNLOAD_DATA_WMT10_TRAINING

$(if $1,,$(error Function $0: a required parameter $$1 (defining a DOWNLOADS_DIR) was omitted))


# Download all files
downloads: $1/training-parallel.tgz $1/training-giga-fren.tar $1/training-monolingual.tgz $1/un.en-fr.tgz $1/un.en-es.tgz

# Download parallel corpus training data (520 MB)
$1/training-parallel.tgz: | $1
	wget --no-verbose -P $1 http://www.statmt.org/wmt10/training-parallel.tgz

# Download 10^9 French-English corpus (2.3 GB)
$1/training-giga-fren.tar : | $1
	wget --no-verbose -P $1 http://www.statmt.org/wmt10/training-giga-fren.tar

# Download monolingual language model training data (5.0 GB)
$1/training-monolingual.tgz : | $1
	wget --no-verbose -P $1 http://www.statmt.org/wmt10/training-monolingual.tgz

# Download UN corpus French-English (671 MB)
$1/un.en-fr.tgz : | $1
	wget --no-verbose -P $1 http://www.statmt.org/wmt10/un.en-fr.tgz

# Download UN corpus Spanish-English (594 MB)
$1/un.en-es.tgz : | $1
	wget --no-verbose -P $1 http://www.statmt.org/wmt10/un.en-es.tgz


# If someone calls make all, do the sensible thing
all: downloads


# The following targets do not create actual files with that name
.PHONY: all downloads

endef
####
#### end of function
################################################################################


