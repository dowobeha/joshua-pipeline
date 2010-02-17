# Calculate the full path to this make file
THIS.MAKEFILE:= $(realpath $(lastword ${MAKEFILE_LIST}))

# Define how to run this file
define USAGE
	$(info  )
	$(info Usage:	make -f ${THIS.MAKEFILE} NORMALIZED_DATA=/path/to/data UNZIPPED_DATA=/path/to/dir unzip-data)
	$(info  )
	$(error )
endef


# If this required parameter is not defined,
#    print usage, then exit
NORMALIZED_DATA ?= $(call USAGE)
UNZIPPED_DATA ?= $(call USAGE)

# If the user does not specify a target, print out how to run this file
usage:
	$(call USAGE)


# Get names of GZIP files, with path removed
#
# See sections 8.2 and 4.3.3 of the GNU Make Manual
GZIP_FILES:=$(patsubst ${NORMALIZED_DATA}/%,%,$(wildcard ${NORMALIZED_DATA}/*.gz))

# Get names of GZIP files, with path and suffix removed
#
# See section 8.2 of the GNU Make Manual
BARE_GZIP_FILES:=$(patsubst %.gz,%,${GZIP_FILES})

# Get names of original non-GZIP files, with path removed
#
# See sections 8.2 and 4.3.3 of the GNU Make Manual
NON_GZIP_FILES:=$(filter-out ${GZIP_FILES},$(patsubst ${NORMALIZED_DATA}/%,%,$(wildcard ${NORMALIZED_DATA}/*)))

# Get paths of GZIP files after processing
#
# See section 8.5 of the GNU Make Manual
PROCESSED_GZIP_FILES:=$(foreach file,${BARE_GZIP_FILES},${UNZIPPED_DATA}/${file})

# Get names for other non-GZIP files after processing
#
# See section 8.5 of the GNU Make Manual
PROCESSED_NON_GZIP_FILES:=$(foreach file,${NON_GZIP_FILES},${UNZIPPED_DATA}/${file})



# Define how to strip GZIP
#
# See sections 6.6, 8.6 and 8.8 of the GNU Make Manual
define STRIP_GZIP
${UNZIPPED_DATA}/${1}: ${NORMALIZED_DATA}/${1}.gz | ${UNZIPPED_DATA}
	zcat ${NORMALIZED_DATA}/${1}.gz > ${UNZIPPED_DATA}/${1}
endef


# Dynamically create all of the actual rules to strip xml
#
# See sections 8.5, 8.6, and 8.8 of the GNU Make Manual
$(foreach file,${BARE_GZIP_FILES},$(eval $(call STRIP_GZIP,${file})))



# Declare a function defining how soft-link non-GZIP files
#
# See sections 6.6, 8.6 and 8.8 of the GNU Make Manual
define LINK_FILE
${UNZIPPED_DATA}/${1}: ${NORMALIZED_DATA}/${1} | ${UNZIPPED_DATA}
	ln -s ${NORMALIZED_DATA}/${1} ${UNZIPPED_DATA}/${1}
endef

# Dynamically create all of the actual rules to link non-GZIP files
#
# See sections 8.5, 8.6, and 8.8 of the GNU Make Manual
$(foreach file,${NON_GZIP_FILES},$(eval $(call LINK_FILE,${file})))



# Convenience target
unzip-data: ${PROCESSED_NON_GZIP_FILES} ${PROCESSED_GZIP_FILES} 

# Make directory
${UNZIPPED_DATA}:
	mkdir -p $@

