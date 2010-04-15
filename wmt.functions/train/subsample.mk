################################################################################
####                       Purpose of this make file:                       ####
####                                                                        ####
#### This file defines functions to subsample
####                                                                        ####
################################################################################


################################################################################
#### Function definition:              
####
#### Parameter 1 (required): SUBSAMPLED_DATA
#### Parameter 2 (required): SRC
#### Parameter 3 (required): TGT
#### Parameter 4 (required): SUBSAMPLER_MANIFEST
#### Parameter 5 (required): NORMALIZED_DATA
#### Parameter 6 (required): FILTER_SCRIPT
#### Parameter 7 (required): JOSHUA
#### Parameter 8 (required): SUBSAMPLER_JVM_FLAG
#### Parameter 9 (required): FILES_TO_TRANSLATES

define SUBSAMPLE_DATA

$(if $1,,$(error Function $0: a required parameter $$1 (defining SUBSAMPLED_DATA) was omitted))
$(if $2,,$(error Function $0: a required parameter $$2 (defining SRC) was omitted))
$(if $3,,$(error Function $0: a required parameter $$3 (defining TGT) was omitted))
$(if $4,,$(error Function $0: a required parameter $$4 (defining SUBSAMPLER_MANIFEST) was omitted))
$(if $5,,$(error Function $0: a required parameter $$5 (defining NORMALIZED_DATA) was omitted))
$(if $6,,$(error Function $0: a required parameter $$6 (defining FILTER_SCRIPT) was omitted))
$(if $7,,$(error Function $0: a required parameter $$7 (defining JOSHUA) was omitted))
$(if $8,,$(error Function $0: a required parameter $$8 (defining SUBSAMPLER_JVM_FLAGS) was omitted))
$(if $9,,$(error Function $0: a required parameter $$9 (defining FILES_TO_TRANSLATE) was omitted))


# Define convenience target for running everything
all: $1/subsampled/subsample.$2 $1/subsampled/subsample.$3

# Concatenate files to translate
$1/combined.test.$2: $(foreach file,$9,$1/test/${file}) | $1
	cat $$^ > $$@


# Define target to remove training lines with zero words on at least one side and those with 100+ words on at least one side
$1/training/%.$2 $1/training/%.$3: $5/%.$2 $5/%.$3 $6 | $1/training
	$6 $5/$$*.$2 $5/$$*.$3 $1/training/$$*.$2 $1/training/$$*.$3

# Define target to copy files to translate to subsampler dir
$1/test/%: $5/% | $1/test
	ln -fs $$< $$@

# Create manifest for subsampling
$1/manifest: | $1
	for name in $4; do echo $$$$name >> $$@; done




# Perform subsampling
$1/subsampled/%.$2 $1/subsampled/%.$3: $(foreach file,$4,$1/training/${file}.$2 $1/training/${file}.$3) $1/manifest $1/combined.test.$2  | $7/bin/joshua.jar $7/lib/commons-cli-2.0-SNAPSHOT.jar $1/subsampled $1/training
	java $8 -cp "$7/bin/joshua.jar:$7/lib/commons-cli-2.0-SNAPSHOT.jar" \
		joshua.subsample.Subsampler \
		-f $2 -e $3 \
		-fpath $1/training -epath $1/training \
		-output $1/subsampled/$$* \
		-ratio 1.04 \
		-test $1/combined.test.$2 \
		-training $1/manifest

# Create subsampler output directory
$1/subsampled:
	mkdir -p $$@

# Create subsampler test directory
$1/test:
	mkdir -p $$@

# Create subsampler training directory
$1/training:
	mkdir -p $$@

# Create subsampler directory
$1:
	mkdir -p $$@


endef

####                                                                        ####
################################################################################



