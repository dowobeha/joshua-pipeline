# Calculate the full path to this make file
THIS.MAKEFILE:= $(realpath $(lastword ${MAKEFILE_LIST}))

# Define how to run this file
define USAGE
	$(info  )
	$(info Usage:	make -f ${THIS.MAKEFILE} TGT=tgtlang LM_TRAINING_DIR=/path/to/data LM_TRAINING_FILE_NAMES=fileNamesWithoutPath TRAINED_LM_DIR=/path/to/output trainLM)
	$(info  )
	$(error )
endef


# If a required parameter is not defined,
#    print usage, then exit
TGT ?= $(call USAGE)
LM_TRAINING_DIR ?= $(call USAGE)
LM_TRAINING_FILE_NAMES ?= $(call USAGE)
TRAINED_LM_DIR ?= $(call USAGE)

# If the user does not specify a target, print out how to run this file
usage:
	$(call USAGE)


