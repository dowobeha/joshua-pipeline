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


.PHONY: all usage
