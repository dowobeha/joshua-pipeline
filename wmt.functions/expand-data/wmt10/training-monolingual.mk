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

define EXPAND_DATA_WMT10_TRAINING_MONOLINGUAL

$(if $1,,$(error Function $0: a required parameter $$1 (defining DOWNLOADS_DIR) was omitted))
$(if $2,,$(error Function $0: a required parameter $$2 (defining DATA_DIR) was omitted))

all: $(call EXPAND_DATA_WMT10_TRAINING_MONOLINGUAL_FILES,$2)

# Extract files from monolingual language model training data (5.0 GB)
$(call EXPAND_DATA_WMT10_TRAINING_MONOLINGUAL_FILES,$2): $1/training-monolingual.tgz | $2
	tar -C $2 --touch --strip-components=1 -x $(subst $2/,training/,$$@) -vzf $$<

endef

####                                                                        ####
################################################################################



################################################################################
#### Helper function definition:              
####
#### Parameter 1 (required): directory into which data will be expanded
####

# These files can be extracted from the monolingual language model training data
define EXPAND_DATA_WMT10_TRAINING_MONOLINGUAL_FILES
$1/europarl-v5.en $1/europarl-v5.de $1/europarl-v5.es $1/europarl-v5.fr $1/news-commentary10.en $1/news-commentary10.cz $1/news-commentary10.fr $1/news-commentary10.de $1/news-commentary10.es $1/news.de.shuffled $1/news.es.shuffled $1/news.en.shuffled $1/news.cz.shuffled $1/news.fr.shuffled
endef

####                                                                        ####
################################################################################
