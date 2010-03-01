################################################################################
####            Define the purpose of this experimental step:               ####
####                                                                        ####
#### This step decompresses downloaded corpus data. 
####                                                                        ####
################################################################################


################################################################################
####                    Define any required variables:                      ####
####                                                                        ####
#### Define experimental directory
export EXPERIMENT_DIR:=/mnt/data/wmt10.labelled
####                                                                        ####
#### Define make scripts directory
export EXPERIMENT_MAKE_DIR:=${EXPERIMENT_DIR}/000.makefiles
####                                                                        ####
################################################################################


################################################################################
####                    Define any required functions:                      ####
####                                                                        ####
#### Define a function to import another make file 
####      only if it has not already been imported.
####                                                                        ####
#### To use, add this line:
####         $(eval $(call import,/path/to/other.mk))
#### instead of using the traditional
####         include /path/to/other.mk
define import
ifndef $1
$1:=$1
include $1
endif
endef
####                                                                        ####
################################################################################


# List known phony targets. See GNU Make manual section 4.5
.PHONY: all usage

# Disable make's default suffix rules. See GNU Make manual section 10.7
.SUFFIXES: