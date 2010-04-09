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
#### Example usage: $(eval $(call DOWNLOAD_DATA,/path/to/downloads,/path/to/expanded))

define EXPAND_DATA_WMT10_TEST

$(if $1,,$(error Function $0: a required parameter $$1 (defining DOWNLOADS_DIR) was omitted))
$(if $2,,$(error Function $0: a required parameter $$2 (defining DATA_DIR) was omitted))

all: $(call EXPAND_DATA_WMT10_TEST_FILES,$2)

# Extract files from test sets (715 KB)
$(call EXPAND_DATA_WMT10_TEST_FILES,$2): $1/test.tgz | $2
	tar -C $2 --touch --strip-components=1 -x $(subst $2/,test/,$$@) -vzf $$<

endef

####                                                                        ####
################################################################################



################################################################################
#### Helper function definition:              
####
#### Parameter 1 (required): directory into which data will be expanded
####

# These files can be extracted from the test set data
define EXPAND_DATA_WMT10_TEST_FILES
$1/newstest2010-src.cz.sgm $1/newstest2010-src.de.sgm $1/newstest2010-src.en.sgm $1/newstest2010-src.es.sgm $1/newstest2010-src.fr.sgm
endef

####                                                                        ####
################################################################################
