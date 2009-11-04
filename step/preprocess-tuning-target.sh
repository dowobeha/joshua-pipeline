#!/bin/bash

# Figure out where this script is located
SCRIPT_PATH=`cd ${0%/*} && pwd`

# Include common functions
source ${SCRIPT_PATH}/_common.sh

# Preprocess each tuning target data reference file
log "Preprocess tuning target data" && \
mkdir -p ${DIR}/data/tuning && \
#
split -d -a 1 -l 663 ${P4_DEV_TGT}/mt03-refs.txt ${DIR}/data/tuning/mt03.en. && \
split -d -a 1 -l 1353 ${P4_DEV_TGT}/mt04-refs.txt ${DIR}/data/tuning/mt04.en. && \
split -d -a 1 -l 1056 ${P4_DEV_TGT}/mt05-refs.txt ${DIR}/data/tuning/mt05.en. && \
split -d -a 1 -l 1797 ${P4_DEV_TGT}/mt06-refs.txt ${DIR}/data/tuning/mt06.en. && \
#
log "Merging mt03 mt04 mt05 mt06 target references 0 into ${DIR}/data/tuning/mt03-mt06.en.0" && \
cat ${DIR}/data/tuning/mt0[3456].en.0 > ${DIR}/data/tuning/mt03-mt06.en.0 && \
wc -l ${DIR}/data/tuning/mt0[3456].en.0 && \
wc -l ${DIR}/data/tuning/mt03-mt06.en.0 && \
#
log "Merging mt03 mt04 mt05 mt06 target references 1 into ${DIR}/data/tuning/mt03-mt06.en.1" && \
cat ${DIR}/data/tuning/mt0[3456].en.1 > ${DIR}/data/tuning/mt03-mt06.en.1 && \
wc -l ${DIR}/data/tuning/mt0[3456].en.1 && \
wc -l ${DIR}/data/tuning/mt03-mt06.en.1 && \
#
log "Merging mt03 mt04 mt05 mt06 target references 2 into ${DIR}/data/tuning/mt03-mt06.en.2" && \
cat ${DIR}/data/tuning/mt0[3456].en.2 > ${DIR}/data/tuning/mt03-mt06.en.2 && \
wc -l ${DIR}/data/tuning/mt0[3456].en.2 && \
wc -l ${DIR}/data/tuning/mt03-mt06.en.2 && \
#
log "Merging mt03 mt04 mt05 mt06 target references 3 into ${DIR}/data/tuning/mt03-mt06.en.3" && \
cat ${DIR}/data/tuning/mt0[3456].en.3 > ${DIR}/data/tuning/mt03-mt06.en.3 && \
wc -l ${DIR}/data/tuning/mt0[3456].en.3 && \
wc -l ${DIR}/data/tuning/mt03-mt06.en.3 && \
#
log "Preprocess tuning target data COMPLETE" && \
exit 0
