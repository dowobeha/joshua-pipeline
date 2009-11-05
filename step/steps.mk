
PATH_TO_MAKEFILE=$(dir $(abspath $(lastword $(MAKEFILE_LIST))))
include ${PATH_TO_MAKEFILE}/_variables

all: tuning-nw-data tuning-wb-data devtest-nw-data devtest-wb-data

#######################################################
#
# Process tuning data
#
tuning-nw-data: ${DIR}/data/tuning/mt03-mt06.nw.noW.ar ${DIR}/data/tuning/mt03-mt06.nw.en.0 ${DIR}/data/tuning/mt03-mt06.nw.en.1 ${DIR}/data/tuning/mt03-mt06.nw.en.2 ${DIR}/data/tuning/mt03-mt06.nw.en.3 
tuning-wb-data: ${DIR}/data/tuning/mt03-mt06.wb.noW.ar ${DIR}/data/tuning/mt03-mt06.wb.en.0 ${DIR}/data/tuning/mt03-mt06.wb.en.1 ${DIR}/data/tuning/mt03-mt06.wb.en.2 ${DIR}/data/tuning/mt03-mt06.wb.en.3 
#
#
# Preprocess newswire source tuning data
${DIR}/data/tuning/mt03-mt06.nw.ar:
	${DIR}/step/preprocess-tuning-nw-source.sh
#
# Preprocess web source tuning data
${DIR}/data/tuning/mt03-mt06.wb.ar: 
	${DIR}/step/preprocess-tuning-wb-source.sh
#
####
#
# Preprocess newswire target tuning data
${DIR}/data/tuning/mt03-mt06.nw.en.0 ${DIR}/data/tuning/mt03-mt06.nw.en.1 ${DIR}/data/tuning/mt03-mt06.nw.en.2 ${DIR}/data/tuning/mt03-mt06.nw.en.3:
	${DIR}/step/preprocess-tuning-nw-target.sh
#
# Preprocess web target tuning data
${DIR}/data/tuning/mt03-mt06.wb.en.0 ${DIR}/data/tuning/mt03-mt06.wb.en.1 ${DIR}/data/tuning/mt03-mt06.wb.en.2 ${DIR}/data/tuning/mt03-mt06.wb.en.3:
	${DIR}/step/preprocess-tuning-wb-target.sh
#
####
#
# Remove W- from newswire source tuning data
${DIR}/data/tuning/mt03-mt06.nw.noW.ar: ${DIR}/data/tuning/mt03-mt06.wb.ar
	${DIR}/step/removeW-tuning-wb-source.sh
#
# Remove W- from web source tuning data
${DIR}/data/tuning/mt03-mt06.wb.noW.ar: ${DIR}/data/tuning/mt03-mt06.nw.ar
	${DIR}/step/removeW-tuning-nw-source.sh
#
#
#######################################################



#######################################################
#
# Process devtest data
#
devtest-nw-data: ${DIR}/data/devtest/mt08.nw.noW.ar 
devtest-wb-data: ${DIR}/data/devtest/mt08.wb.noW.ar
#
# Preprocess newswire source devtest data
${DIR}/data/devtest/mt08.nw.ar: 
	${DIR}/step/preprocess-devtest-nw-source.sh
#
# Preprocess web source devtest data
${DIR}/data/devtest/mt08.wb.ar:
	${DIR}/step/preprocess-devtest-wb-source.sh
#
####
#
# Remove W- from newswire source devtest data
${DIR}/data/devtest/mt08.nw.noW.ar: ${DIR}/data/devtest/mt08.nw.ar 
	${DIR}/step/removeW-devtest-nw.source.sh
#
# Remove W- from web source devtest data
${DIR}/data/devtest/mt08.wb.noW.ar: ${DIR}/data/devtest/mt08.wb.ar
	${DIR}/step/removeW-devtest-wb-source.sh
#
#
#######################################################




cleanest:
	rm -rf ${DIR}/data


.PHONY: all tuning-data devtest-data