#!/bin/bash

# Figure out where this script is located
SCRIPT_PATH=`cd ${0%/*} && pwd`

# Include common functions
source ${SCRIPT_PATH}/_common.sh

# Preprocess each tuning source data file
log "Preprocess devtest source data" && \
mkdir -p ${DIR}/data/devtest && \
#
${PREPROCESS} ${P4_DEV_SRC}/mt08_arabic_evalset_current_v0-wb.spell.atb-v3.unk.split.sgm ${DIR}/data/devtest/mt08.wb.ar && \
wc -l ${DIR}/data/devtest/mt08.wb.ar && \
#
log "Preprocess devtest source data COMPLETE" && \
exit 0 || \
#
exit -1

