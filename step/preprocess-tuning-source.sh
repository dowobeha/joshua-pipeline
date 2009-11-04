#!/bin/bash

# Figure out where this script is located
SCRIPT_PATH=`cd ${0%/*} && pwd`

# Include common functions
source ${SCRIPT_PATH}/_common.sh

# Preprocess each tuning source data file
log "Preprocess tuning source data" && \
mkdir -p ${DIR}/data/tuning && \
#
${PREPROCESS} ${P4_DEV_SRC}/mt03_arabic_evlset_v0.atb-v3.unk.split.sgm ${DIR}/data/tuning/mt03.ar && \
${PREPROCESS} ${P4_DEV_SRC}/mt04_arabic_evlset_v0.atb-v3.unk.split.sgm ${DIR}/data/tuning/mt04.ar && \
${PREPROCESS} ${P4_DEV_SRC}/mt05_arabic_evlset_v0.atb-v3.unk.split.sgm ${DIR}/data/tuning/mt05.ar && \
${PREPROCESS} ${P4_DEV_SRC}/mt06_arabic_evlset_nist_part_v1.reforder.atb-v3.unk.split.sgm ${DIR}/data/tuning/mt06.ar && \
#
log "Merging mt03 mt04 mt05 mt06 source sentences into ${DIR}/data/tuning/mt03-mt06.ar"
cat ${DIR}/data/tuning/mt0[3456].ar > ${DIR}/data/tuning/mt03-mt06.ar && \
wc -l ${DIR}/data/tuning/mt0[3456].ar && \
wc -l ${DIR}/data/tuning/mt03-mt06.ar && \
#
log "Preprocess tuning source data COMPLETE"
exit 0
