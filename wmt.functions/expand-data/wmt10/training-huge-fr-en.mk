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

define EXPAND_DATA_WMT10_TRAINING_HUGE_FR_EN

$(if $1,,$(error Function $0: a required parameter $$1 (defining DOWNLOADS_DIR) was omitted))
$(if $2,,$(error Function $0: a required parameter $$2 (defining DATA_DIR) was omitted))

all: $(call EXPAND_DATA_WMT10_TRAINING_HUGE_FR_EN_FILES,$2)

# Extract files from 10^9 French-English corpus (2.3 GB)
.INTERMEDIATE: $2/giga-fren.release2.fr.gz $2/giga-fren.release2.en.gz
$(call EXPAND_DATA_WMT10_TRAINING_HUGE_FR_EN_FILES_GZ,$2): $1/training-giga-fren.tar | $2
	tar -C $2 --touch -x $$(subst $2/,,$$@) -vf $$<

$(call EXPAND_DATA_WMT10_TRAINING_HUGE_FR_EN_FILES,$2): $(call EXPAND_DATA_WMT10_TRAINING_HUGE_FR_EN_FILES_GZ,$2) | $2
	gunzip $$@.gz

endef

####                                                                        ####
################################################################################


# These files can be extracted from the 10^9 French-English parallel corpus
define EXPAND_DATA_WMT10_TRAINING_HUGE_FR_EN_FILES
$(foreach file,$(call EXPAND_DATA_WMT10_TRAINING_HUGE_FR_EN_FILES_GZ,$1),$(basename ${file}))
endef


# These gzipped files can be extracted from the 10^9 French-English parallel corpus
define EXPAND_DATA_WMT10_TRAINING_HUGE_FR_EN_FILES_GZ
$1/giga-fren.release2.fr.gz $1/giga-fren.release2.en.gz
endef
