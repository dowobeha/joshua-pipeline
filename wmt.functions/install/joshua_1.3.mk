################################################################################
####                       Purpose of this make file:                       ####
####                                                                        ####
#### This file defines a function to download and install Joshua
####                                                                        ####
################################################################################


################################################################################
#### Function definition:              
####
#### Parameter 1 (required): a directory into which Joshua will be installed
#### Parameter 2 (optional): directory in which SRILM is installed
####
define INSTALL_JOSHUA

$(if $1,,$(error Function $0: a required parameter $$1 (defining JOSHUA) was omitted))

# Install Joshua
all: $1/bin/joshua.jar

# Compile Joshua
$1/bin/joshua.jar: $1/joshua-1.3.tgz | $1
	tar -C $1 --touch --strip-components=1 -xvzf $$<
	cd $1 && export SRILM=$2 && ant jar 

$1/lib/commons-cli-2.0-SNAPSHOT.jar: $1/bin/joshua.jar

# Download Joshua
$1/joshua-1.3.tgz: | $1
	wget --no-verbose -P $1 http://voxel.dl.sourceforge.net/sourceforge/joshua/joshua-1.3.tgz

# Make Joshua directory
$1:
	mkdir -p $$@

endef
####
#### end of function
################################################################################
