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

define EXPAND_DATA_WMT10_DEV

$(if $1,,$(error Function $0: a required parameter $$1 (defining DOWNLOADS_DIR) was omitted))
$(if $2,,$(error Function $0: a required parameter $$2 (defining DATA_DIR) was omitted))


all: $(call EXPAND_DATA_WMT10_DEV_FILES,$2)

# Extract files from development sets (4.0 MB)
$(call EXPAND_DATA_WMT10_DEV_FILES,$2): $1/dev.tgz | $2
	tar -C $2 --touch --strip-components=1 -x $(subst $2/,dev/,$$@) -vzf $$<

endef

####                                                                        ####
################################################################################



################################################################################
#### Helper function definition:              
####
#### Parameter 1 (required): directory into which data will be expanded
####

# These files can be extracted from the development set data
define EXPAND_DATA_WMT10_DEV_FILES
$1/newssyscomb2009-ref.cz.sgm $1/newssyscomb2009-ref.de.sgm $1/newssyscomb2009-ref.en.sgm $1/newssyscomb2009-ref.es.sgm $1/newssyscomb2009-ref.fr.sgm $1/newssyscomb2009-ref.hu.sgm $1/newssyscomb2009-ref.it.sgm $1/newssyscomb2009-src.cz.sgm $1/newssyscomb2009-src.de.sgm $1/newssyscomb2009-src.en.sgm $1/newssyscomb2009-src.es.sgm $1/newssyscomb2009-src.fr.sgm $1/newssyscomb2009-src.hu.sgm $1/newssyscomb2009-src.it.sgm $1/newstest2009-ref.cz.sgm $1/newstest2009-ref.de.sgm $1/newstest2009-ref.en.sgm $1/newstest2009-ref.es.sgm $1/newstest2009-ref.fr.sgm $1/newstest2009-ref.hu.sgm $1/newstest2009-ref.it.sgm $1/newstest2009-src.cz.sgm $1/newstest2009-src.de.sgm $1/newstest2009-src.en.sgm $1/newstest2009-src.es.sgm $1/newstest2009-src.fr.sgm $1/newstest2009-src.hu.sgm $1/newstest2009-src.it.sgm $1/newstest2009-src.xx.sgm $1/news-test2008-ref.en.sgm $1/news-test2008-ref.es.sgm $1/news-test2008-ref.fr.sgm $1/news-test2008-ref.hu.sgm $1/news-test2008-src.cz.sgm $1/news-test2008-src.de.sgm $1/news-test2008-src.en.sgm $1/news-test2008-src.es.sgm $1/news-test2008-ref.cz.sgm $1/news-test2008-ref.de.sgm $1/news-test2008-src.fr.sgm $1/news-test2008-src.hu.sgm
endef

####                                                                        ####
################################################################################

