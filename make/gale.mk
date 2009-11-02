###############################################################################
##                                                                           ##
##                         GALE MT PIPELINE                                  ##
##                                                                           ##
###############################################################################

# This file makes the following assumptions:
#
#    - All source language training files are located in ${TRAINING.SRC.DIR}
#
#    - All target language training files are located in ${TRAINING.TGT.DIR}
#
#    - The base file name for each training file is listed in ${TRAINING.BASENAMES}
#
#    - The path for each source language training file 
#        is defined by ${TRAINING.SRC.DIR}/${NAME}.${SRC}${TRAINING.SRC.SUFFIX}
#        where ${NAME} is the base file name of the file
#
#    - The path for each target language training file 
#        is defined by ${TRAINING.TGT.DIR}/${NAME}.${TGT}${TRAINING.TGT.SUFFIX}
#        where ${NAME} is the base file name of the file

###############################################################################
## Initial housekeeping.                                                     ##
###############################################################################

# Welcome to GALE. We hope you have a pleasant stay.
$(info Hello. This file is for running the JHU GALE Arabic-English SMT system.)

# Calculate the directory where this make file is stored
PATH.TO.THIS.MAKEFILE:=$(dir $(lastword ${MAKEFILE_LIST}))


# Include the GNU Makefile Standard Library
#   This provides functionality such as mapping and arithmetic.
#   See http://gmsl.sourceforge.net
include ${PATH.TO.THIS.MAKEFILE}/gmsl


# If no target is specified, all should be run
all:


###############################################################################
## User defined variables.                                                   ##
###############################################################################

# Define the source and target languages
SRC:=ar
TGT:=en

# Define the tuning data input file
TUNING.SRC.INPUT.SGML.NW:=/Users/lane/Research/GALE/data/dryrun09/arabic/source/ready-for-mt-atb-v3.1/GALE-DEV09-arabic-text-nw-tune.atb-v3.1.unk.split.sgm
DEVTEST.SRC.INPUT.SGML.NW:=/Users/lane/Research/GALE/data/dryrun09/arabic/source/ready-for-mt-atb-v3.1/GALE-DEV09-arabic-text-nw-dev.atb-v3.1.unk.split.sgm
TEST.SRC.INPUT.SGML.NW:=/Users/lane/Research/GALE/data/dryrun09/arabic/source/ready-for-mt-atb-v3.1/GALE-DEV09test+P3unseq-arabic-text-nw.atb-v3.1.unk.split.sgm

# Define an associative array that maps sgml file names to easy-to-remember names
# (this uses functions defined in the GNU Makefile Standard Library)
#$(call set,TUNING.SRC.SGML.NAMEMAP,GALE-DEV09-arabic-text-nw-tune.atb-v3.1.unk.split.sgm,GALE-DEV09-tune.nw)
#$(call set,TUNING.SRC.SGML.NAMEMAP,GALE-DEV09-arabic-text-wb-tune.spell.atb-v3.1.unk.split.sgm,GALE-DEV09-tune.wb)
# Gather up all tuning file names
#TUNING.SRC.SGML.BASENAMES:=$(call keys,TUNING.SRC.SGML.NAMEMAP)

###############################################################################
## Unsgml                                                                    ##
###############################################################################

# Define unsgml input files and output directories
UNSGML.SCRIPT:=/Users/lane/Research/GALE/scripts/preprocess.pl
UNSGML.INPUT.FILES:=${TUNING.SRC.INPUT.SGML.NW} ${DEVTEST.SRC.INPUT.SGML.NW} ${TEST.SRC.INPUT.SGML.NW}
UNSGML.INPUT.SUFFIX:=.sgm
UNSGML.JOBS.DIR:=/Users/lane/Research/GALE/working/jobs/unsgml
UNSGML.LOG.DIR:=/Users/lane/Research/GALE/working/log/unsgml
UNSGML.OUTPUT.DIR:=/Users/lane/Research/GALE/working/results/unsgml
UNSGML.STATUS.DIR:=/Users/lane/Research/GALE/working/status/unsgml


# Import the makefile that defines unsgml
include ${PATH.TO.THIS.MAKEFILE}/unsgml.mk

# The results of running unsgml are stored in ${UNSGML.OUTPUT.FILES}
ifndef UNSGML.OUTPUT.FILES
$(error The results of running unsgml are not defined.)
endif



# Define the parallel training corpus
TRAINING.SRC.DIR:=/Users/lane/Research/GALE/data/P4.training/arfiles/atb
TRAINING.TGT.DIR:=/Users/lane/Research/GALE/data/P4.training/enfiles/tok
TRAINING.SRC.SUFFIX:=.filtered
TRAINING.TGT.SUFFIX:=.filtered

TRAINING.BASENAMES:=xin ummah06.split-05

# Derive the lists of training files.
TRAINING.SRC.FILES:=$(foreach NAME,${TRAINING.BASENAMES},${NAME}.${SRC}${TRAINING.SRC.SUFFIX})
TRAINING.TGT.FILES:=$(foreach NAME,${TRAINING.BASENAMES},${NAME}.${TGT}${TRAINING.TGT.SUFFIX})

# Derive the lists of training files, incorporating the directory path.
TRAINING.SRC.FILES.WITH.DIR:=$(foreach file,${TRAINING.SRC.FILES},${TRAINING.SRC.DIR}/${file})
TRAINING.TGT.FILES.WITH.DIR:=$(foreach file,${TRAINING.TGT.FILES},${TRAINING.TGT.DIR}/${file}) 

# Define the list of tuning files



###############################################################################
## Pre-processing                                                            ##
###############################################################################

# Define preprocessing input files and output directories
PREPROCESS.SCRIPT:=/Users/lane/Research/GALE/scripts/preprocess.pl
PREPROCESS.INPUT.FILES:=${TRAINING.SRC.FILES.WITH.DIR} ${TRAINING.TGT.FILES.WITH.DIR} ${UNSGML.OUTPUT.FILES}
PREPROCESS.JOBS.DIR:=/Users/lane/Research/GALE/working/jobs/preprocessed
PREPROCESS.LOG.DIR:=/Users/lane/Research/GALE/working/log/preprocessed
PREPROCESS.OUTPUT.DIR:=/Users/lane/Research/GALE/working/results/preprocessed
PREPROCESS.STATUS.DIR:=/Users/lane/Research/GALE/working/status/preprocessed

# Import the makefile that defines preprocessing
include ${PATH.TO.THIS.MAKEFILE}/preprocess.mk

# The results of running preprocessing are stored in ${PREPROCESS.OUTPUT.FILES}


###############################################################################
## Pre-processing                                                            ##
###############################################################################

# Define remove-W input files and output directories
REMOVE-W.SCRIPT:=/Users/lane/Research/GALE/scripts/reprocess_remove-W.pl
REMOVE-W.JOBS.DIR:=/Users/lane/Research/GALE/working/jobs/remove-W
REMOVE-W.LOG.DIR:=/Users/lane/Research/GALE/working/log/remove-W
REMOVE-W.OUTPUT.DIR:=/Users/lane/Research/GALE/working/results/remove-W
REMOVE-W.STATUS.DIR:=/Users/lane/Research/GALE/working/status/remove-W

#REMOVE-W.INPUT.FILES:=$(foreach name,${TRAINING.BASENAMES},${PREPROCESS.OUTPUT.DIR}/${name})
#REMOVE-W.SOURCE.SUFFIX:=.ar.filtered
#REMOVE-W.INPUT.FILES:=${PREPROCESS.OUTPUT.FILES}
#REMOVE-W.SOURCE.SUFFIX:=""

# Define remove-W prerequisites to be the results of preprocessing source files
REMOVE-W.PREREQUISITES:=${PREPROCESS.STATUS.FILES} ${PREPROCESS.OUTPUT.FILES}

# Import the makefile that defines how to remove sentence-initial W#.
include ${PATH.TO.THIS.MAKEFILE}/remove-initial-W.mk


###############################################################################
## User defined targets and dependencies.                                    ##
###############################################################################

all: unsgml preprocess removeW

cleanest:
	rm -rf ${PREPROCESS.OUTPUT.DIR} ${PREPROCESS.STATUS.DIR} ${PREPROCESS.JOBS.DIR} ${PREPROCESS.LOG.DIR}
	rm -rf ${REMOVE-W.OUTPUT.DIR} ${REMOVE-W.STATUS.DIR} ${REMOVE-W.JOBS.DIR} ${REMOVE-W.LOG.DIR}




###############################################################################
## Misc book-keeping. See section 4.5 of the GNU Make Manual.                ##
###############################################################################

# The all target does not create an actual file called all
#
.PHONY: all cleanest
