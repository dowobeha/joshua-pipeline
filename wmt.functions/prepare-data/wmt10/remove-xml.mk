################################################################################
####                       Purpose of this make file:                       ####
####                                                                        ####
#### This file defines functions to remove XML
####                                                                        ####
################################################################################


################################################################################
#### Function definition:              
####
#### Parameter 1 (required): DATA_DIR
#### Parameter 2 (required): BARE_XML_FILES
#### Parameter 3 (required): NON_XML_FILES
#### Parameter 4 (required): PROCESSED_XML_FILES
#### Parameter 5 (required): PROCESSED_NON_XML_FILES
#### Parameter 6 (required): DATA_WITHOUT_XML
####
#### Example usage: $(eval $(call LINK_STRIP_XML_DATA,/path/to/data,/path/whereto/link))
define LINK_STRIP_XML_DATA

$(if $1,,$(error Function $0: a required parameter $$1 (defining DATA_DIR) was omitted))
$(if $2,,$(error Function $0: a required parameter $$2 (defining BARE_XML_FILES) was omitted))
$(if $3,,$(error Function $0: a required parameter $$3 (defining NON_XML_FILES) was omitted))
$(if $4,,$(error Function $0: a required parameter $$4 (defining PROCESSED_XML_FILES) was omitted))
$(if $5,,$(error Function $0: a required parameter $$5 (defining PROCESSED_NON_XML_FILES) was omitted))
$(if $6,,$(error Function $0: a required parameter $$6 (defining DATA_WITHOUT_XML) was omitted))

# Dynamically create all of the actual rules to strip xml
#
# See sections 8.5, 8.6, and 8.8 of the GNU Make Manual
$(foreach file,$2,$(eval $(call STRIP_XML,${file},$1,$6)))


# Dynamically create all of the actual rules to link non-XML files
#
# See sections 8.5, 8.6, and 8.8 of the GNU Make Manual
$(foreach file,$3,$(eval $(call LINK_NONXML_FILE,${file},$1,$6)))

# Convenience target
all: $4 $5

# Make directory
${6}:
	mkdir -p $$@

endef

####                                                                        ####
################################################################################



# Define how to strip XML
#
# See sections 6.6, 8.6 and 8.8 of the GNU Make Manual
define STRIP_XML
$3/${1}: $2/${1}.sgm | $3
	grep "<seg" $2/${1}.sgm | sed "s/[[:space:]]*<seg[^>]*>[[:space:]]*//; s/[[:space:]]*<\/seg>[[:space:]]*//" > $3/${1}
endef




# Declare a function defining how soft-link non-XML files
#
# See sections 6.6, 8.6 and 8.8 of the GNU Make Manual
define LINK_NONXML_FILE
$3/${1}: $2/${1} | $3
	ln -fs $2/${1} $3/${1}
endef


