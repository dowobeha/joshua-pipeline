#!/bin/bash

# Figure out where this script is located
SCRIPT_PATH=`cd ${0%/*} && pwd`

# Include common functions
source ${SCRIPT_PATH}/_common.sh

# Preprocess each tuning target data reference file
log "Preprocess tuning target data" && \
mkdir -p ${DIR}/data/tuning && \
#
cat ${P4_TUNING_TGT}/mt0[3456].nw.en.0 > ${DIR}/data/tuning/mt03-mt06.nw.en.0 && \
cat ${P4_TUNING_TGT}/mt0[3456].nw.en.1 > ${DIR}/data/tuning/mt03-mt06.nw.en.1 && \
cat ${P4_TUNING_TGT}/mt0[3456].nw.en.2 > ${DIR}/data/tuning/mt03-mt06.nw.en.2 && \
cat ${P4_TUNING_TGT}/mt0[3456].nw.en.3 > ${DIR}/data/tuning/mt03-mt06.nw.en.3 && \
#
log "Preprocess tuning target data COMPLETE" && \
exit 0 || \
#
exit -1

