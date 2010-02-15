

# Calculate the full path to this make file
PATH.TO.THIS.MAKEFILE:= $(realpath $(dir $(lastword ${MAKEFILE_LIST})))


all:
#
#	Download data from WMT10 web site
	$(MAKE) -f ${PATH.TO.THIS.MAKEFILE}/download-data.mk downloads
#
#	Expand compressed data from WMT10 web site
	$(MAKE) -f ${PATH.TO.THIS.MAKEFILE}/expand-data.mk expand


.PHONY: all