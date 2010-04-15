################################################################################
####                      Define a helper function:                         ####
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

