#!/bin/bash

# Figure out where this script is located
SCRIPT_PATH=`cd ${0%/*} && pwd`

# Include common functions
source ${SCRIPT_PATH}/_common.sh

log "Removing sentence-initial W-" && \
#
# Creating dummy files
log "Creating dummy target and dummy alignment files" && \
ruby -e "STDIN.each_line{|line| puts}" < ${DIR}/data/devtest/mt08.wb.ar > ${DIR}/data/devtest/mt08.wb.fakeEN && \
ruby -e "STDIN.each_line{|line| puts}" < ${DIR}/data/devtest/mt08.wb.ar > ${DIR}/data/devtest/mt08.wb.fakeALN && \
#
# Remove W from merged devtest source file 
log "Removing sentence-initial W- from ${DIR}/data/devtest/mt08.wb.ar" && \
${REMOVE_W} --ar .ar --en .fakeEN --align .fakeALN --pp .noW ${DIR}/data/devtest/mt08.wb && \
#
# Removing temporary dummy files
log "Removing temporary dummy files" && \
rm ${DIR}/data/devtest/mt08.wb.fakeEN && \
rm ${DIR}/data/devtest/mt08.wb.fakeALN && \
rm ${DIR}/data/devtest/mt08.wb.noW.fakeEN && \
rm ${DIR}/data/devtest/mt08.wb.noW.fakeALN && \
#
log "Removing sentence-initial W- COMPLETE" && \
exit 0 || \
#
exit -1
