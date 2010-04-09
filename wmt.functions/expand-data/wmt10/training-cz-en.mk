################################################################################
####                       Purpose of this make file:                       ####
####                                                                        ####
#### This file defines a function to extract WMT10 data
####                                                                        ####
################################################################################


################################################################################
#### Function definition:              
####
#### Parameter 1 (required): directory where data was downloaded
#### Parameter 2 (required): directory into which data will be expanded
####
#### Example usage: $(eval $(call DOWNLOAD_DATA,/path/to/downloads,/path/to/expanded))

define EXPAND_DATA_WMT10_TRAINING_CZ_EN

$(if $1,,$(error Function $0: a required parameter $$1 (defining DOWNLOADS_DIR) was omitted))
$(if $2,,$(error Function $0: a required parameter $$2 (defining DATA_DIR) was omitted))


# Extract unzipped files from Czech-English corpus
#
# There are 7 tar files
# .... each of which contains 10 gz files
# ........ call the function to get the name of an unzipped file
# ............ passing the directory, tens digit, and ones digit as parameters
$(foreach tensDigit,0 1 2 3 4 5 6 7,\
	$(foreach digit,0 1 2 3 4 5 6 7 8 9,\
		$(eval $(call EXPAND_DATA_WMT10_TRAINING_CZ_EN_FILES_GUNZIP,\
			$2,${tensDigit},${digit}))))


# Extract gzipped files from Czech-English corpus
#
# There are 7 tar files
# .... call the function to get the name of the zipped files
# ........ passing the downloads dir, the data dir, and the digit as parameters
$(foreach tensDigit,0 1 2 3 4 5 6 7,\
	$(eval $(call EXPAND_DATA_WMT10_TRAINING_CZ_EN_FILES_UNTAR,\
		$1,$2,${tensDigit})))

endef

####                                                                        ####
################################################################################



################################################################################
#### Helper function definition: 
####
#### Parameter 1 (required): directory into which data will be expanded
#### Parameter 2 (required): tens digit
#### Parameter 3 (required): ones digit
####

# Dynamically create new make targets for a file to be unzipped
define EXPAND_DATA_WMT10_TRAINING_CZ_EN_FILES_GUNZIP

$(if $1,,$(error Function $0: a required parameter $$1 (DATA_DIR) was omitted))
$(if $2,,$(error Function $0: a required parameter $$2 (TENS_DIGIT) was omitted))
$(if $3,,$(error Function $0: a required parameter $$3 (ONES_DIGIT) was omitted))

# Add this file to list of targets that should be made by all
all: ${1}/data-plaintext/${2}${3}train

# Actually define the dynamically created target
${1}/data-plaintext/${2}${3}train: ${1}/data-plaintext/${2}${3}train.gz
	gunzip $$@.gz
endef

####                                                                        ####
################################################################################





################################################################################
#### Helper function definition: 
####
#### Parameter 1 (required): directory where data was downloaded
#### Parameter 2 (required): directory into which data will be expanded
#### Parameter 3 (required): tens digit
####

# Dynamically create new make targets for files to be untarred
define EXPAND_DATA_WMT10_TRAINING_CZ_EN_FILES_UNTAR

$(if $1,,$(error Function $0: a required parameter $$1 (DOWNLOADS_DIR) was omitted))
$(if $2,,$(error Function $0: a required parameter $$2 (DATA_DIR) was omitted))
$(if $3,,$(error Function $0: a required parameter $$3 (TENS_DIGIT) was omitted))

# Declare these files to be temporary - it's ok to delete them later
.INTERMEDIATE: $(call EXPAND_DATA_WMT10_TRAINING_CZ_EN_FILES_GZ,$2,$3)

# Actually define the dynamically created target
$(foreach d,0 1 2 3 4 5 6 7 8 9,${2}/data-plaintext/%${d}train.gz): $1/data-plaintext.%.tar | $2
	tar -C $2 --touch -x $$(subst $2/,,$(foreach d,0 1 2 3 4 5 6 7 8 9,${2}/data-plaintext/$$*${d}train.gz)) -vf $$<
endef

####                                                                        ####
################################################################################
#$(call EXPAND_DATA_WMT10_TRAINING_CZ_EN_FILES_GZ,$2,$3): $1/data-plaintext.%.tar | $2
#$
#$2/%0train.gz $2/%1train.gz $2/%2train.gz: $1/data-plaintext.%.tar | $2



################################################################################
#### Helper function definition: 
####
#### Parameter 1 (required): directory into which data will be expanded
#### Parameter 2 (required): tens digit

# Calculate list of gzipped files contained in a tar file
define EXPAND_DATA_WMT10_TRAINING_CZ_EN_FILES_GZ
$(if $1,,$(error Function $0: a required parameter $$1 (DATA_DIR) was omitted))\
$(if $2,,$(error Function $0: a required parameter $$2 (TENS_DIGIT) was omitted))\
$(foreach digit,0 1 2 3 4 5 6 7 8 9,$1/data-plaintext/%${digit}train.gz)
endef

####                                                                        ####
################################################################################
