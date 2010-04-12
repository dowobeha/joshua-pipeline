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
define INSTALL_BERKELEY_ALIGNER

$(if $1,,$(error Function $0: a required parameter $$1 (defining BERKELEYALIGNER) was omitted))

# Define a conveniently named target
all: $1/berkeleyaligner.jar

# Install Berkeley aligner
$1/berkeleyaligner.jar: $1/berkeleyaligner_unsupervised-2.1.tar.gz | $1
	tar -C $1 --touch --strip-components=1 -x berkeleyaligner/berkeleyaligner.jar -vzf $$< 

# Download Berkeley aligner
$1/berkeleyaligner_unsupervised-2.1.tar.gz: | $1
	wget --no-verbose -P $1 http://berkeleyaligner.googlecode.com/files/berkeleyaligner_unsupervised-2.1.tar.gz

# Make Berkeley directory
$1:
	mkdir -p $$@


endef
####
#### end of function
################################################################################


