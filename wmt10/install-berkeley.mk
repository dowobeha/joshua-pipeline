

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

berkeley-aligner: ${BERKELEYALIGNER}/berkeleyaligner.jar

${BERKELEYALIGNER}/berkeleyaligner.jar: ${BERKELEYALIGNER}/berkeleyaligner_unsupervised-2.1.tar.gz | ${BERKELEYALIGNER}
	tar -C ${BERKELEYALIGNER} --touch --strip-components=1 -x berkeleyaligner/berkeleyaligner.jar -vzf $< 

${BERKELEYALIGNER}/berkeleyaligner_unsupervised-2.1.tar.gz: | ${BERKELEYALIGNER}
	wget --no-verbose -P ${BERKELEYALIGNER} http://berkeleyaligner.googlecode.com/files/berkeleyaligner_unsupervised-2.1.tar.gz

${BERKELEYALIGNER}:
	mkdir -p $@

.PHONY: berkeley-aligner
