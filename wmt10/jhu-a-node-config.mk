################################################################################
################################################################################
####                                                                        ####
####       Define variables specific to the JHU CLSP a nodes                #### 
####                                                                        ####
################################################################################
################################################################################


# Define JVM flags for subsampling
export SUBSAMPLER_JVM_FLAGS=-Xms30g -Xmx30g -Dfile.encoding=utf8

# Define number of threads for Berkeley aligner
export BERKELEY_NUM_THREADS=10

export BERKELEY_JVM_FLAGS=-d64 -Dfile.encoding=utf8 -XX:MinHeapFreeRatio=10 -Xms25g -Xmx25g

export EXTRACT_RULES_JVM_FLAGS="-Xms30g -Xmx30g"

# Define directory where SRILM is installed
export SRILM=/home/zli/tools/srilm1.5.7.64bit.pic

# Define file where SRILM ngram-count is installed
export SRILM_NGRAM_COUNT=${SRILM}/bin/i686-m64/ngram-count


# Define where this experiment will be run
export EXPERIMENT_DIR=/mnt/data/wmt10

# Include makefile that defines the actual steps to run
include $(realpath $(dir $(lastword ${MAKEFILE_LIST})))/steps.mk
