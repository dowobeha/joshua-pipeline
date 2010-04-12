################################################################################
####                       Purpose of this make file:                       ####
####                                                                        ####
#### This file defines a function to download and install Berkeley aligner
####                                                                        ####
################################################################################


################################################################################
#### Function definition:              
####
#### Parameter 1 (required): a directory into which Berkeley aligner will be installed
####
define INSTALL_WMT10_SCRIPTS

$(if $1,,$(error Function $0: a required parameter $$1 (defining WMT_SCRIPTS) was omitted))

# Define a conveniently named target
all: $(call SCRIPTS_FILES,$1) 

# Extract files from tools (3 KB)
$(call SCRIPTS_FILES,$1): $1/scripts.tgz | $1
	tar -C $1 --strip-components=1 --touch -x $$(subst $1/,scripts/,$$@) -vzf $$<

# Download tools (3 KB)
$1/scripts.tgz : | $1
	wget --no-verbose -P $1 http://www.statmt.org/wmt08/scripts.tgz

# Make directory
$1:
	mkdir -p $$@


endef
####
#### end of function
################################################################################



################################################################################
#### Helper function definition: 
####
#### Parameter 1 (required): directory into which data will be expanded

# These files can be extracted from the tools bundle
define SCRIPTS_FILES
$(if $1,,$(error Function $0: a required parameter $$1 (WMT_SCRIPTS) was omitted))\
$1/detokenizer.perl $1/wrap-xml.perl $1/lowercase.perl $1/tokenizer.perl $1/reuse-weights.perl $1/nonbreaking_prefixes/nonbreaking_prefix.de $1/nonbreaking_prefixes/nonbreaking_prefix.en $1/nonbreaking_prefixes/nonbreaking_prefix.el
endef

####                                                                        ####
################################################################################
