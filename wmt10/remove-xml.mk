# Calculate the full path to this make file
THIS.MAKEFILE:= $(realpath $(lastword ${MAKEFILE_LIST}))

# Define how to run this file
define USAGE
	$(info  )
	$(info Usage:	make -f ${THIS.MAKEFILE} DATA_DIR=/path/to/data DATA_WITHOUT_XML=/path/to/dir remove-xml)
	$(info  )
	$(error )
endef


# If this required parameter is not defined,
#    print usage, then exit
DATA_DIR ?= $(call USAGE)
DATA_WITHOUT_XML ?= $(call USAGE)

# Get names of XML files, with path removed
#
# See sections 8.2 and 4.3.3 of the GNU Make Manual
XML_FILES:=$(patsubst ${DATA_DIR}/%,%,$(wildcard ${DATA_DIR}/*.sgm))

# Get names of XML files, with path and suffix removed
#
# See section 8.2 of the GNU Make Manual
BARE_XML_FILES:=$(patsubst %.sgm,%,${XML_FILES})

# Get names of original non-XML files, with path removed
#
# See sections 8.2 and 4.3.3 of the GNU Make Manual
NON_XML_FILES:=$(filter-out ${XML_FILES},$(patsubst ${DATA_DIR}/%,%,$(wildcard ${DATA_DIR}/*)))

# Get paths of XML files after processing
#
# See section 8.5 of the GNU Make Manual
PROCESSED_XML_FILES:=$(foreach file,${BARE_XML_FILES},${DATA_WITHOUT_XML}/${file})

# Get names for other non-XML files after processing
#
# See section 8.5 of the GNU Make Manual
PROCESSED_NON_XML_FILES:=$(foreach file,${NON_XML_FILES},${DATA_WITHOUT_XML}/${file})


# Define how to strip XML
#
# See sections 6.6, 8.6 and 8.8 of the GNU Make Manual
define STRIP_XML
${DATA_WITHOUT_XML}/${1}: ${DATA_DIR}/${1}.sgm | ${DATA_WITHOUT_XML}
	grep "<seg" ${DATA_DIR}/${1}.sgm | sed "s/[[:space:]]*<seg[^>]*>[[:space:]]*//; s/[[:space:]]*<\/seg>[[:space:]]*//" > ${DATA_WITHOUT_XML}/${1}
endef


# Dynamically create all of the actual rules to strip xml
#
# See sections 8.5, 8.6, and 8.8 of the GNU Make Manual
$(foreach file,${BARE_XML_FILES},$(eval $(call STRIP_XML,${file})))



# Declare a function defining how soft-link non-XML files
#
# See sections 6.6, 8.6 and 8.8 of the GNU Make Manual
define LINK_FILE
${DATA_WITHOUT_XML}/${1}: ${DATA_DIR}/${1} | ${DATA_WITHOUT_XML}
	ln -fs ${DATA_DIR}/${1} ${DATA_WITHOUT_XML}/${1}
endef

# Dynamically create all of the actual rules to link non-XML files
#
# See sections 8.5, 8.6, and 8.8 of the GNU Make Manual
$(foreach file,${NON_XML_FILES},$(eval $(call LINK_FILE,${file})))



# Convenience target
remove-xml: ${PROCESSED_XML_FILES} ${PROCESSED_NON_XML_FILES}

# Make directory
${DATA_WITHOUT_XML}:
	mkdir -p $@

