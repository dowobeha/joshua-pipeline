

# Calculate the full path to this make file
PATH.TO.THIS.MAKEFILE:= $(realpath $(dir $(lastword ${MAKEFILE_LIST})))


all: download expand joshua berkeley-aligner wmt-scripts remove-xml tokenize normalize unzip-data

download:
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

wmt-scripts:
#	Download and install WMT scripts
	$(MAKE) -f ${PATH.TO.THIS.MAKEFILE}/install-wmt-scripts.mk wmt-scripts

remove-xml:
#	Remove XML from downloaded data
	$(MAKE) -f ${PATH.TO.THIS.MAKEFILE}/remove-xml.mk remove-xml

tokenize:
#	Tokenize data
	$(MAKE) -f ${PATH.TO.THIS.MAKEFILE}/tokenize.mk tokenize

normalize:
#	Normalize data (lowercase)
	$(MAKE) -f ${PATH.TO.THIS.MAKEFILE}/normalize.mk normalize

unzip-data:
#	Unzip compressed data
	$(MAKE) -f ${PATH.TO.THIS.MAKEFILE}/unzip-data.mk unzip-data


.PHONY: all download expand joshua berkeley-aligner wmt-scripts remove-xml tokenize normalize unzip-data
