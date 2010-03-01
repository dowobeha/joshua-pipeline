
# Calculate the full path to this make file
THIS.MAKEFILE:= $(realpath $(lastword ${MAKEFILE_LIST}))

# Define how to run this file
define USAGE
	$(info  )
	$(info Usage:	make -f ${THIS.MAKEFILE} SRILM=/path/to/srilm JOSHUA=/path/to/install joshua)
	$(info  )
	$(error )
endef


# If any of these required parameters are not defined,
#    print usage, then exit
SRILM ?= $(call USAGE)
JOSHUA ?= $(call USAGE)


# Install Joshua
joshua: ${JOSHUA}/bin/joshua.jar
all: joshua

# Compile Joshua
${JOSHUA}/bin/joshua.jar: ${JOSHUA}/joshua-1.3.tgz | ${JOSHUA}
	tar -C ${JOSHUA} --touch --strip-components=1 -xvzf $<
	cd ${JOSHUA} && ant jar

# Download Joshua
${JOSHUA}/joshua-1.3.tgz: | ${JOSHUA}
	wget --no-verbose -P ${JOSHUA} http://voxel.dl.sourceforge.net/sourceforge/joshua/joshua-1.3.tgz

# Make Joshua directory
${JOSHUA}:
	mkdir -p $@

# There's not really a file called joshua
.PHONY: joshua
