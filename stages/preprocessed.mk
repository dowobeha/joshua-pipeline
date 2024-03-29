################################################################################
################################################################################
####                                                                        ####
####                      Preprocessing make file                           ####
####                                                                        ####
################################################################################
################################################################################

$(info )
$(info This make file defines:)
$(info --- how to preprocess a file)
$(info )


SCRIPT_NAME := preprocess.pl

# Define a shortcut to run the script
define run
${SCRIPT} $< $@
endef



# Calculate the directory where this make file is stored
PATH.TO.THIS.MAKEFILE:=$(dir $(lastword ${MAKEFILE_LIST}))

include ${PATH.TO.THIS.MAKEFILE}/_common_dir_to_dir.mk
