################################################################################
####                 Gather information about this make file                ####
####                                                                        ####
#### Get the full path to this make file
PATH.TO.THIS.MAKEFILE:=$(abspath $(dir $(lastword ${MAKEFILE_LIST})))
####
#### Get the filename of this make file
THIS.MAKEFILE.NAME:=$(basename $(notdir $(lastword ${MAKEFILE_LIST})))
####                                                                        ####
################################################################################



all:
	$(MAKE) -f ${PATH.TO.THIS.MAKEFILE}/download-data.mk
	$(MAKE) -f ${PATH.TO.THIS.MAKEFILE}/install-software.mk
	$(MAKE) -f ${PATH.TO.THIS.MAKEFILE}/prepare-data.mk
	$(MAKE) -f ${PATH.TO.THIS.MAKEFILE}/prepare-data-removexml.mk
	$(MAKE) -f ${PATH.TO.THIS.MAKEFILE}/prepare-data-tokenize.mk
	$(MAKE) -f ${PATH.TO.THIS.MAKEFILE}/prepare-data-normalize.mk

