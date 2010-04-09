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

define EXPAND_DATA_WMT10_TRAINING_UN_FR_EN

$(if $1,,$(error Function $0: a required parameter $$1 (defining DOWNLOADS_DIR) was omitted))
$(if $2,,$(error Function $0: a required parameter $$2 (defining DATA_DIR) was omitted))

all: $(call EXPAND_DATA_WMT10_TRAINING_UN_FR_EN_FILES,$2)

# Extract files from UN corpus French-English (671 MB)
$(call EXPAND_DATA_WMT10_TRAINING_UN_FR_EN_FILES,$2): $1/un.en-fr.tgz | $2
	tar -C $2 --touch -x $$(subst $2/,,$$@) -vzf $$<

endef

####                                                                        ####
################################################################################




################################################################################
#### Helper function definition:              
####
#### Parameter 1 (required): directory into which data will be expanded
####

# These files can be extracted from the UN French-English parallel corpus
define EXPAND_DATA_WMT10_TRAINING_UN_FR_EN_FILES
$1/undoc.2000.en-fr.en $1/undoc.2000.en-fr.fr
endef

####                                                                        ####
################################################################################
