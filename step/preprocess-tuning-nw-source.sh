#!/bin/bash

# Figure out where this script is located
SCRIPT_PATH=`cd ${0%/*} && pwd`

# Include common functions
source ${SCRIPT_PATH}/_common.sh

# Preprocess each tuning source data file
log "Preprocess tuning source data" && \
mkdir -p ${DIR}/data/tuning && \
#
log "Preprocessing nw data for mt03-mt06"
${PREPROCESS} ${P4_TUNING_SRC}/mt03.nw.ar.sgml ${DIR}/data/tuning/mt03.nw.ar && \
${PREPROCESS} ${P4_TUNING_SRC}/mt04.nw.ar.sgml ${DIR}/data/tuning/mt04.nw.ar && \
${PREPROCESS} ${P4_TUNING_SRC}/mt05.nw.ar.sgml ${DIR}/data/tuning/mt05.nw.ar && \
${PREPROCESS} ${P4_TUNING_SRC}/mt06.nw.ar.sgml ${DIR}/data/tuning/mt06.nw.ar && \
#
log "Merging nw data for mt03 mt04 mt05 mt06 source sentences into ${DIR}/data/tuning/mt03-mt06.ar"
cat ${DIR}/data/tuning/mt0[3456].nw.ar > ${DIR}/data/tuning/mt03-mt06.nw.ar && \
wc -l ${DIR}/data/tuning/mt0[3456].nw.ar && \
wc -l ${DIR}/data/tuning/mt03-mt06.nw.ar && \
#
log "Preprocess tuning source data COMPLETE"
exit 0
