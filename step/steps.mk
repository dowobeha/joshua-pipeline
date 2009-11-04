
PATH_TO_MAKEFILE=$(dir $(abspath $(lastword $(MAKEFILE_LIST))))
include ${PATH_TO_MAKEFILE}/_variables

all: tuning-data devtest-data



tuning-data: ${DIR}/data/tuning/mt03-mt06.noW.ar ${DIR}/data/tuning/mt03-mt06.en.0 ${DIR}/data/tuning/mt03-mt06.en.1 ${DIR}/data/tuning/mt03-mt06.en.2 ${DIR}/data/tuning/mt03-mt06.en.3 

${DIR}/data/tuning/mt03-mt06.ar: 
	${DIR}/step/preprocess-tuning-source.sh

${DIR}/data/tuning/mt03-mt06.en.0 ${DIR}/data/tuning/mt03-mt06.en.1 ${DIR}/data/tuning/mt03-mt06.en.2 ${DIR}/data/tuning/mt03-mt06.en.3:
	${DIR}/step/preprocess-tuning-target.sh

${DIR}/data/tuning/mt03-mt06.noW.ar: ${DIR}/data/tuning/mt03-mt06.ar
	${DIR}/step/removeW-tuning-source.sh




devtest-data: ${DIR}/data/devtest/mt08.nw.noW.ar ${DIR}/data/devtest/mt08.wb.noW.ar

${DIR}/data/devtest/mt08.nw.ar ${DIR}/data/devtest/mt08.wb.ar:
	${DIR}/step/preprocess-devtest-source.sh

${DIR}/data/devtest/mt08.nw.noW.ar ${DIR}/data/devtest/mt08.wb.noW.ar: ${DIR}/data/devtest/mt08.nw.ar ${DIR}/data/devtest/mt08.wb.ar
	${DIR}/step/removeW-devtest-source.sh




cleanest:
	rm -rf ${DIR}/data


.PHONY: all tuning-data devtest-data