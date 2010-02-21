# Calculate the full path to this make file
THIS.MAKEFILE:= $(realpath $(lastword ${MAKEFILE_LIST}))
THIS.MAKEFILE.DIR:=$(dir ${THIS.MAKEFILE})

# Define how to run this file
define USAGE
	$(info  )
	$(info Usage:	make -f ${THIS.MAKEFILE} SUBSAMPLER_JVM_FLAGS=jvmFlags SRC=srclang TGT=tgtlang UNZIPPED_DATA=/path/to/data FILTER_SCRIPT=/path/to/script JOSHUA=/path/to/joshua SUBSAMPLER_MANIFEST=manifestList FILES_TO_TRANSLATE=fileNamesWithoutPath SUBSAMPLED_DATA=/path/to/dir subsample)
	$(info  )
	$(error )
endef


# If a required parameter is not defined,
#    print usage, then exit
SRC ?= $(call USAGE)
TGT ?= $(call USAGE)
JOSHUA ?= $(call USAGE)
UNZIPPED_DATA ?= $(call USAGE)
FILTER_SCRIPT ?= $(call USAGE)
SUBSAMPLER_MANIFEST ?= $(call USAGE)
FILES_TO_TRANSLATE ?= $(call USAGE)
SUBSAMPLED_DATA ?= $(call USAGE)
SUBSAMPLER_JVM_FLAGS ?= $(call USAGE)

# If the user does not specify a target, print out how to run this file
usage:
	$(call USAGE)


# Define where training files for subsampler will be placed
SUBSAMPLER_TRAINING_DIR:=${SUBSAMPLED_DATA}/training

# Gather names of source and target language training files to create for subsampler
SUBSAMPLER_TRAINING_SRC_FILES:=$(foreach file,${SUBSAMPLER_MANIFEST},${SUBSAMPLER_TRAINING_DIR}/${file}.${SRC})
SUBSAMPLER_TRAINING_TGT_FILES:=$(foreach file,${SUBSAMPLER_MANIFEST},${SUBSAMPLER_TRAINING_DIR}/${file}.${TGT})

# Define target to gather all required training files for subsampler
subsampler_training: ${SUBSAMPLER_TRAINING_SRC_FILES} ${SUBSAMPLER_TRAINING_TGT_FILES}

# Define where files to translate for subsampler will be placed
SUBSAMPLER_TEST_DIR:=${SUBSAMPLED_DATA}/test

# Gather names of source files to translate
SUBSAMPLER_TEST_SRC_FILES:=$(foreach file,${FILES_TO_TRANSLATE},${SUBSAMPLER_TEST_DIR}/${file})

# Concatenate files to translate
${SUBSAMPLED_DATA}/combined.test.${SRC}: ${SUBSAMPLER_TEST_SRC_FILES} | ${SUBSAMPLED_DATA}
	cat $^ > $@

# Define convenience target for running everything
subsample: ${SUBSAMPLED_DATA}/subsampled/subsample.${SRC} ${SUBSAMPLED_DATA}/subsampled/subsample.${TGT}


# Define target to remove training lines with zero words on at least one side and those with 100+ words on at least one side
${SUBSAMPLER_TRAINING_DIR}/%.${SRC} ${SUBSAMPLER_TRAINING_DIR}/%.${TGT}: ${UNZIPPED_DATA}/%.${SRC} ${UNZIPPED_DATA}/%.${TGT} ${THIS.MAKEFILE.DIR}/filter-sentences.pl | ${SUBSAMPLER_TRAINING_DIR}
	${THIS.MAKEFILE.DIR}/filter-sentences.pl ${UNZIPPED_DATA}/$*.${SRC} ${UNZIPPED_DATA}/$*.${TGT} ${SUBSAMPLER_TRAINING_DIR}/$*.${SRC} ${SUBSAMPLER_TRAINING_DIR}/$*.${TGT}

# Define target to copy files to translate to subsampler dir
${SUBSAMPLER_TEST_DIR}/%: ${UNZIPPED_DATA}/% | ${SUBSAMPLER_TEST_DIR}
	cp $< $@

# Create manifest for subsampling
${SUBSAMPLED_DATA}/manifest: | ${SUBSAMPLED_DATA}
	for name in ${SUBSAMPLER_MANIFEST}; do echo $$name >> $@; done

# Perform subsampling
${SUBSAMPLED_DATA}/subsampled/subsample.${SRC} ${SUBSAMPLED_DATA}/subsampled/subsample.${TGT}:  ${SUBSAMPLER_TRAINING_SRC_FILES} ${SUBSAMPLER_TRAINING_TGT_FILES} ${SUBSAMPLED_DATA}/manifest ${SUBSAMPLED_DATA}/combined.test.${SRC}  | ${JOSHUA}/bin/joshua.jar ${JOSHUA}/lib/commons-cli-2.0-SNAPSHOT.jar ${SUBSAMPLED_DATA}/subsampled ${SUBSAMPLER_TRAINING_DIR}
	java ${SUBSAMPLER_JVM_FLAGS} -cp "${JOSHUA}/bin/joshua.jar:${JOSHUA}/lib/commons-cli-2.0-SNAPSHOT.jar" \
		joshua.subsample.Subsampler \
		-f ${SRC} -e ${TGT} \
		-fpath ${SUBSAMPLER_TRAINING_DIR} -epath ${SUBSAMPLER_TRAINING_DIR} \
		-output ${SUBSAMPLED_DATA}/subsampled/subsample \
		-ratio 1.04 \
		-test ${SUBSAMPLED_DATA}/combined.test.${SRC} \
		-training ${SUBSAMPLED_DATA}/manifest

# Create subsampler output directory
${SUBSAMPLED_DATA}/subsampled:
	mkdir -p $@

# Create subsampler test directory
${SUBSAMPLER_TEST_DIR}:
	mkdir -p $@

# Create subsampler training directory
${SUBSAMPLER_TRAINING_DIR}:
	mkdir -p $@

# Create subsampler directory
${SUBSAMPLED_DATA}:
	mkdir -p $@


# The following targets don't actually create files with those names
.PHONY: usage subsampler_training subsample
