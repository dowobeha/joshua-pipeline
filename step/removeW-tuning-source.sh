#!/bin/bash

# Figure out where this script is located
SCRIPT_PATH=`cd ${0%/*} && pwd`

# Include common functions
source ${SCRIPT_PATH}/_common.sh

log "Removing sentence-initial W-" && \
#
# Creating dummy files
log "Creating dummy target and dummy alignment files" && \
ruby -e "STDIN.each_line{|line| puts}" < ${DIR}/data/tuning/mt03-mt06.ar > ${DIR}/data/tuning/mt03-mt06.fakeEN && \
ruby -e "STDIN.each_line{|line| puts}" < ${DIR}/data/tuning/mt03-mt06.ar > ${DIR}/data/tuning/mt03-mt06.fakeALN && \
#
# Remove W from merged tuning source file 
log "Removing sentence-initial W- from ${DIR}/data/tuning/mt03-mt06.ar" && \
${REMOVE_W} --ar .ar --en .fakeEN --align .fakeALN --pp .noW ${DIR}/data/tuning/mt03-mt06 && \
#
# Removing temporary dummy files
log "Removing temporary dummy files" && \
rm ${DIR}/data/tuning/mt03-mt06.fakeEN && \
rm ${DIR}/data/tuning/mt03-mt06.fakeALN && \
rm ${DIR}/data/tuning/mt03-mt06.noW.fakeEN && \
rm ${DIR}/data/tuning/mt03-mt06.noW.fakeALN && \
#
log "Removing sentence-initial W- COMPLETE" && \
exit 0
