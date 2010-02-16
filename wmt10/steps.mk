

# Calculate the full path to this make file
PATH.TO.THIS.MAKEFILE:= $(realpath $(dir $(lastword ${MAKEFILE_LIST})))


download:
#
#	Download data from WMT10 web site
	$(MAKE) -f ${PATH.TO.THIS.MAKEFILE}/download-data.mk downloads

expand:
#	Expand compressed data from WMT10 web site
	$(MAKE) -f ${PATH.TO.THIS.MAKEFILE}/expand-data.mk expand


joshua:
#	Download and compile Joshua
	$(MAKE) -f ${PATH.TO.THIS.MAKEFILE}/install-joshua.mk joshua

berkeley-aligner:
#	Download and install Berkeley Aligner
	$(MAKE) -f ${PATH.TO.THIS.MAKEFILE}/install-berkeley.mk berkeley-aligner


.PHONY: all download expand joshua
