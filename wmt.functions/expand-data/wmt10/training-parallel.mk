################################################################################
####                       Purpose of this make file:                       ####
####                                                                        ####
#### This file defines a function to extract WMT10 data
####                                                                        ####
################################################################################


################################################################################
#### Function definition:              
####
#### Parameter 1 (required): directory where data was downloaded
#### Parameter 2 (required): directory into which data will be expanded
####
#### Example usage: $(eval $(call DOWNLOAD_DATA,/path/to/downloads,/path/to/expanded))

define EXPAND_DATA_WMT10_TRAINING_PARALLEL

$(if $1,,$(error Function $0: a required parameter $$1 (defining DOWNLOADS_DIR) was omitted))
$(if $2,,$(error Function $0: a required parameter $$2 (defining DATA_DIR) was omitted))

all: $(call EXPAND_DATA_WMT10_TRAINING_PARALLEL_FILES,$2)

# Extract files from parallel corpus training data
$(call EXPAND_DATA_WMT10_TRAINING_PARALLEL_FILES,$2): $1/training-parallel.tgz | $2
	tar -C $2 --touch --strip-components=1 -x $(subst $2/,training/,$$@) -vzf $$<

endef

####                                                                        ####
################################################################################



################################################################################
#### Helper function definition:              
####
#### Parameter 1 (required): directory into which data will be expanded
####

# These files can be extracted from the parallel corpus training data
define EXPAND_DATA_WMT10_TRAINING_PARALLEL_FILES
$1/europarl-v5.de-en.de $1/europarl-v5.de-en.en $1/europarl-v5.es-en.en $1/europarl-v5.es-en.es $1/europarl-v5.fr-en.en $1/europarl-v5.fr-en.fr $1/news-commentary10.cz-en.cz $1/news-commentary10.cz-en.en $1/news-commentary10.de-en.de $1/news-commentary10.de-en.en $1/news-commentary10.es-de.de $1/news-commentary10.es-de.es $1/news-commentary10.es-en.en $1/news-commentary10.es-en.es $1/news-commentary10.fr-en.en $1/news-commentary10.fr-en.fr
endef

####                                                                        ####
################################################################################
