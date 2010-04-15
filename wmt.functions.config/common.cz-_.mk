################################################################################
####                 Gather information about this make file                ####
####                                                                        ####
#### Get the full path to this make file
PATH.TO.THIS.MAKEFILE:=$(abspath $(dir $(lastword ${MAKEFILE_LIST})))
####                                                                        ####
################################################################################

# Define how to import other make files
include ${PATH.TO.THIS.MAKEFILE}/import.mk

# Import common variables
$(eval $(call import,${PATH.TO.THIS.MAKEFILE}/common.mk))


SRC:=cz
