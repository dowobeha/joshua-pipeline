################################################################################
####                     Define the target to be run:                       ####
####                                                                        ####
export .DEFAULT_GOAL=all
####                                                                        ####
################################################################################


################################################################################
####                      Define a helper function:                         ####
####                                                                        ####
#### Define a function to import another make file 
####      only if it has not already been imported.
####                                                                        ####
#### To use, add this line:
####         $(eval $(call import,/path/to/other.mk))
#### instead of using the traditional
####         include /path/to/other.mk
define import
ifndef $1
$1:=$1
include $1
endif
endef
####                                                                        ####
################################################################################


EXPERIMENT_DIR:=/mnt/data/wmt10.cz
EXPERIMENT_MAKE_DIR:=${EXPERIMENT_DIR}/000.makefiles
DOWNLOAD_DIR:=${EXPERIMENT_DIR}/001.OriginalData
UNZIPPED_DATA_DIR:=${EXPERIMENT_DIR}/002.OriginalDataUnzipped
DATA_DIR:=${EXPERIMENT_DIR}/002.OriginalData
#TOY_SIZE:=10000
CZEN_USERNAME:=fdf0c1
CZENG_SCRIPT:=${EXPERIMENT_MAKE_DIR}/scripts/prepare-czeng.perl


JOSHUA:=${EXPERIMENT_DIR}/003.Joshua
SRILM:=/home/zli/tools/srilm1.5.7.64bit.pic

BERKELEYALIGNER:=${EXPERIMENT_DIR}/004.BerkeleyAligner

WMT10_SCRIPTS:=${EXPERIMENT_DIR}/005.Scripts

DATA_WITHOUT_XML:=${EXPERIMENT_DIR}/006.RemoveXML

# Get names of XML files, with path removed
#
# See sections 8.2 and 4.3.3 of the GNU Make Manual
XML_FILES:=$(patsubst ${DATA_DIR}/%,%,$(wildcard ${DATA_DIR}/*.sgm))

# Get names of XML files, with path and suffix removed
#
# See section 8.2 of the GNU Make Manual
BARE_XML_FILES:=$(patsubst %.sgm,%,${XML_FILES})

# Get names of original non-XML files, with path removed
#
# See sections 8.2 and 4.3.3 of the GNU Make Manual
NON_XML_FILES:=$(filter-out ${XML_FILES},$(patsubst ${DATA_DIR}/%,%,$(wildcard ${DATA_DIR}/*)))

# Get paths of XML files after processing
#
# See section 8.5 of the GNU Make Manual
PROCESSED_XML_FILES:=$(foreach file,${BARE_XML_FILES},${DATA_WITHOUT_XML}/${file})

# Get names for other non-XML files after processing
#
# See section 8.5 of the GNU Make Manual
PROCESSED_NON_XML_FILES:=$(foreach file,${NON_XML_FILES},${DATA_WITHOUT_XML}/${file})



# File names of files after processing
TOKENIZED_DATA:=${EXPERIMENT_DIR}/007.TokenizedData
TOKENIZED_FILES:=$(patsubst ${DATA_WITHOUT_XML}/%,${TOKENIZED_DATA}/%,$(wildcard ${DATA_WITHOUT_XML}/*))
