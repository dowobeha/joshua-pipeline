

# Calculate the full path to this make file
THIS.MAKEFILE:= $(realpath $(lastword ${MAKEFILE_LIST}))
#$(dir $(lastword ${MAKEFILE_LIST}))/$(lastword ${MAKEFILE_LIST})

# Define how to run this file
define USAGE
	$(info  )
	$(info Usage:	make -f ${THIS.MAKEFILE} DOWNLOADS_DIR=/path/to/dir downloads)
	$(info  )
	$(error )
endef


# If this required parameter is not defined,
#    print usage, then exit
DOWNLOADS_DIR ?= $(call USAGE)

# If the user does not specify a target, print out how to run this file
usage:
	$(call USAGE)

# Download all files
downloads: ${DOWNLOADS_DIR}/training-parallel.tgz ${DOWNLOADS_DIR}/training-giga-fren.tar ${DOWNLOADS_DIR}/training-monolingual.tgz ${DOWNLOADS_DIR}/un.en-fr.tgz ${DOWNLOADS_DIR}/un.en-es.tgz ${DOWNLOADS_DIR}/dev.tgz ${DOWNLOADS_DIR}/scripts.tgz

# Download parallel corpus training data (520 MB)
${DOWNLOADS_DIR}/training-parallel.tgz: | ${DOWNLOADS_DIR}
	wget --no-verbose -P ${DOWNLOADS_DIR} http://www.statmt.org/wmt10/training-parallel.tgz

# Download 10^9 French-English corpus (2.3 GB)
${DOWNLOADS_DIR}/training-giga-fren.tar : | ${DOWNLOADS_DIR}
	wget --no-verbose -P ${DOWNLOADS_DIR} http://www.statmt.org/wmt10/training-giga-fren.tar

# Download monolingual language model training data (5.0 GB)
${DOWNLOADS_DIR}/training-monolingual.tgz : | ${DOWNLOADS_DIR}
	wget --no-verbose -P ${DOWNLOADS_DIR} http://www.statmt.org/wmt10/training-monolingual.tgz

# Download UN corpus French-English (671 MB)
${DOWNLOADS_DIR}/un.en-fr.tgz : | ${DOWNLOADS_DIR}
	wget --no-verbose -P ${DOWNLOADS_DIR} http://www.statmt.org/wmt10/un.en-fr.tgz

# Download UN corpus Spanish-English (594 MB)
${DOWNLOADS_DIR}/un.en-es.tgz : | ${DOWNLOADS_DIR}
	wget --no-verbose -P ${DOWNLOADS_DIR} http://www.statmt.org/wmt10/un.en-es.tgz

# Download development sets (4.0 MB)
${DOWNLOADS_DIR}/dev.tgz : | ${DOWNLOADS_DIR}
	wget --no-verbose -P ${DOWNLOADS_DIR} http://www.statmt.org/wmt10/dev.tgz



# If someone calls make all, do the sensible thing
all: downloads


# Make directory to store original downloaded data
${DOWNLOADS_DIR}:
	mkdir -p $@


# The following targets do not create actual files with that name
.PHONY: all downloads usage
