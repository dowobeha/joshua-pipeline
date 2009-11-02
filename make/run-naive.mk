###############################################################################
##                                                                           ##
##                         GALE MT PIPELINE                                  ##
##                                                                           ##
###############################################################################

WORKING:=/Users/lane/Research/GALE/naive
WORKING.RESULTS.PREPROCESS:=${WORKING}/results/preprocessed
WORKING.RESULTS.REMOVE-W:=${WORKING}/results/removeW
WORKING.LOG.PREPROCESS:=${WORKING}/log/preprocessed
WORKING.LOG.REMOVE-W:=${WORKING}/log/removeW

# Define the parallel training corpus
TRAINING.SRC.DIR:=/Users/lane/Research/GALE/data/P4.training/arfiles/atb
TRAINING.TGT.DIR:=/Users/lane/Research/GALE/data/P4.training/enfiles/tok

PREPROCESS.SCRIPT:=/Users/lane/Research/GALE/scripts/preprocess.pl
REMOVE-W.SCRIPT:=/Users/lane/Research/GALE/scripts/removeW.sh

all:
	mkdir -p ${WORKING.RESULTS.PREPROCESS}
	${PREPROCESS.SCRIPT} ${TRAINING.SRC.DIR}/xin.ar.filtered ${WORKING.RESULTS.PREPROCESS}/xin.ar
	${PREPROCESS.SCRIPT} ${TRAINING.SRC.DIR}/ummah06.split-05.ar.filtered ${WORKING.RESULTS.PREPROCESS}/ummah06.split-05.ar
	mkdir -p ${WORKING.LOG.REMOVE-W}
	${REMOVE-W.SCRIPT} ${WORKING.RESULTS.PREPROCESS}/xin.ar ${WORKING.RESULTS.REMOVE-W}/xin.ar &> ${WORKING.LOG.REMOVE-W}/xin.ar
	${REMOVE-W.SCRIPT} ${WORKING.RESULTS.PREPROCESS}/ummah06.split-05.ar ${WORKING.RESULTS.REMOVE-W}/ummah06.split-05.ar &> ${WORKING.LOG.REMOVE-W}/ummah06.split-05.ar
