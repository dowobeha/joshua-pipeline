

# Calculate the full path to this make file
THIS.MAKEFILE:= $(realpath $(lastword ${MAKEFILE_LIST}))

# Define how to run this file
define USAGE
	$(info  )
	$(info Usage:	make -f ${THIS.MAKEFILE} BERKELEYALIGNER=/path/to/install berkeley-aligner)
	$(info  )
	$(error )
endef


# If any of these required parameters are not defined,
#    print usage, then exit
BERKELEYALIGNER ?= $(call USAGE)


# If the user does not specify a target, print out how to run this file
usage:
	$(call USAGE)

# Define a conveniently named target
berkeley-aligner: ${BERKELEYALIGNER}/berkeleyaligner.jar

# Install Berkeley aligner
${BERKELEYALIGNER}/berkeleyaligner.jar: ${BERKELEYALIGNER}/berkeleyaligner_unsupervised-2.1.tar.gz | ${BERKELEYALIGNER}
	tar -C ${BERKELEYALIGNER} --touch --strip-components=1 -x berkeleyaligner/berkeleyaligner.jar -vzf $< 

# Download Berkeley aligner
${BERKELEYALIGNER}/berkeleyaligner_unsupervised-2.1.tar.gz: | ${BERKELEYALIGNER}
	wget --no-verbose -P ${BERKELEYALIGNER} http://berkeleyaligner.googlecode.com/files/berkeleyaligner_unsupervised-2.1.tar.gz

# Make Berkeley directory
${BERKELEYALIGNER}:
	mkdir -p $@

# There's not really a file called berkeley-aligner
.PHONY: berkeley-aligner
