#!/bin/bash

# Figure out where this script is located
SCRIPT_PATH=`cd ${0%/*} && pwd`

# Include common functions
source ${SCRIPT_PATH}/_common.sh

# Preprocess each tuning source data file
log "Preprocess tuning source data" && \
mkdir -p ${DIR}/data/tuning && \
#
log "Preprocessing wb data for mt06"
${PREPROCESS} ${P4_TUNING_SRC}/mt06.wb.ar.sgml ${DIR}/data/tuning/mt06.nw.ar && \
#
log "Merging wb data for mt03 mt04 mt05 mt06 source sentences into ${DIR}/data/tuning/mt03-mt06.ar"
cat ${DIR}/data/tuning/mt0[3456].wb.ar > ${DIR}/data/tuning/mt03-mt06.wb.ar && \
wc -l ${DIR}/data/tuning/mt0[3456].wb.ar && \
wc -l ${DIR}/data/tuning/mt03-mt06.wb.ar && \
#
log "Preprocess tuning source data COMPLETE" && \
exit 0 || \
#
exit -1

