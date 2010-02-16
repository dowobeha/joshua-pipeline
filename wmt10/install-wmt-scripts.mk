
# Calculate the full path to this make file
THIS.MAKEFILE:= $(realpath $(lastword ${MAKEFILE_LIST}))

# Define how to run this file
define USAGE
	$(info  )
	$(info Usage:	make -f ${THIS.MAKEFILE} WMT_SCRIPTS=/path/to/dir downloads)
	$(info  )
	$(error )
endef


# If this required parameter is not defined,
#    print usage, then exit
WMT_SCRIPTS ?= $(call USAGE)

# If the user does not specify a target, print out how to run this file
usage:
	$(call USAGE)


# These files can be extracted from the tools bundle
SCRIPTS_FILES:=${WMT_SCRIPTS}/scripts/detokenizer.perl ${WMT_SCRIPTS}/scripts/wrap-xml.perl ${WMT_SCRIPTS}/scripts/lowercase.perl ${WMT_SCRIPTS}/scripts/tokenizer.perl ${WMT_SCRIPTS}/scripts/reuse-weights.perl ${WMT_SCRIPTS}/scripts/nonbreaking_prefixes/nonbreaking_prefix.de ${WMT_SCRIPTS}/scripts/nonbreaking_prefixes/nonbreaking_prefix.en ${WMT_SCRIPTS}/scripts/nonbreaking_prefixes/nonbreaking_prefix.el

# Define a conveniently named target
wmt-scripts: ${SCRIPTS_FILES}

# Extract files from tools (3 KB)
${SCRIPTS_FILES}: ${WMT_SCRIPTS}/scripts.tgz | ${WMT_SCRIPTS}
	tar -C ${WMT_SCRIPTS} --strip-components=1 --touch -x $(subst ${WMT_SCRIPTS}/,,$@) -vzf $<

# Download tools (3 KB)
${WMT_SCRIPTS}/scripts.tgz : | ${WMT_SCRIPTS}
	wget --no-verbose -P ${WMT_SCRIPTS} http://www.statmt.org/wmt08/scripts.tgz

# Make directory
${WMT_SCRIPTS}:
	mkdir -p $@

# This make file does not actually create files with the following names:
.PHONY: usage wmt-scripts 
