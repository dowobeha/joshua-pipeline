
# Calculate the full path to this make file
THIS.MAKEFILE:= $(realpath $(lastword ${MAKEFILE_LIST}))

# Define how to run this file
define USAGE
	$(info  )
	$(info Usage:	make -f ${THIS.MAKEFILE} WMT_SCRIPTS=/path/to/dir wmt-scripts)
	$(info  )
	$(error )
endef


# If this required parameter is not defined,
#    print usage, then exit
WMT_SCRIPTS ?= $(call USAGE)


# These files can be extracted from the tools bundle
SCRIPTS_FILES:=${WMT_SCRIPTS}/detokenizer.perl ${WMT_SCRIPTS}/wrap-xml.perl ${WMT_SCRIPTS}/lowercase.perl ${WMT_SCRIPTS}/tokenizer.perl ${WMT_SCRIPTS}/reuse-weights.perl ${WMT_SCRIPTS}/nonbreaking_prefixes/nonbreaking_prefix.de ${WMT_SCRIPTS}/nonbreaking_prefixes/nonbreaking_prefix.en ${WMT_SCRIPTS}/nonbreaking_prefixes/nonbreaking_prefix.el

# Define a conveniently named target
wmt-scripts: ${SCRIPTS_FILES}
all: wmt-scripts

# Extract files from tools (3 KB)
${SCRIPTS_FILES}: ${WMT_SCRIPTS}/scripts.tgz | ${WMT_SCRIPTS}
	tar -C ${WMT_SCRIPTS} --strip-components=1 --touch -x $(subst ${WMT_SCRIPTS}/,scripts/,$@) -vzf $<

# Download tools (3 KB)
${WMT_SCRIPTS}/scripts.tgz : | ${WMT_SCRIPTS}
	wget --no-verbose -P ${WMT_SCRIPTS} http://www.statmt.org/wmt08/scripts.tgz

# Make directory
${WMT_SCRIPTS}:
	mkdir -p $@

# This make file does not actually create files with the following names:
.PHONY: usage wmt-scripts 
