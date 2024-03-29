# Define how to run this file
define USAGE
	$(info  )
	$(info Usage:	make -f $(abspath $(dir $(lastword ${MAKEFILE_LIST}))) DOWNLOADS_DIR=/path/to/dir downloads)
	$(info  )
	$(error )
endef


# If this required parameter is not defined,
#    print usage, then exit
DOWNLOADS_DIR ?= $(call USAGE)

# Download all files
downloads: ${DOWNLOADS_DIR}/training-parallel.tgz ${DOWNLOADS_DIR}/training-giga-fren.tar ${DOWNLOADS_DIR}/training-monolingual.tgz ${DOWNLOADS_DIR}/un.en-fr.tgz ${DOWNLOADS_DIR}/un.en-es.tgz ${DOWNLOADS_DIR}/dev.tgz ${DOWNLOADS_DIR}/test.tgz

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

# Download test sets (715 KB)
${DOWNLOADS_DIR}/test.tgz: | ${DOWNLOADS_DIR}
	wget --no-verbose -P ${DOWNLOADS_DIR} http://www.statmt.org/wmt10/test.tgz


ifdef CZENG_USERNAME

downloads: $(foreach n,0 1 2 3 4 5 6 7,${DOWNLOADS_DIR}/data-plaintext.${n}.tar)

${DOWNLOADS_DIR}/data-plaintext.%.tar: | ${DOWNLOADS_DIR}
	wget --no-verbose -P ${DOWNLOADS_DIR} --user=${CZENG_USERNAME} --password=czeng http://ufallab2.ms.mff.cuni.cz/~bojar/czeng09-data/data-plaintext.$*.tar

endif

# If someone calls make all, do the sensible thing
all: downloads


# Make directory to store original downloaded data
${DOWNLOADS_DIR}:
	mkdir -p $@


# The following targets do not create actual files with that name
.PHONY: all downloads usage
