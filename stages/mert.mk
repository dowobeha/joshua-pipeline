################################################################################
################################################################################
####                                                                        ####
####                             MERT make file                             ####
####                                                                        ####
################################################################################
################################################################################

$(info )
$(info This make file defines:)
$(info --- how to run MERT)
$(info )


################################################################################
################################################################################
####                                                                        ####
####      Verify that all required, user-defined variables are defined      ####
####                                                                        ####
################################################################################
################################################################################

EXPERIMENT_DIR ?= $(error EXPERIMENT_DIR is not defined)
STAGE_NAME ?= $(error STAGE_NAME is not defined)
STAGE_NUMBER ?= $(error STAGE_NUMBER is not defined)

JOSHUA ?= $(error JOSHUA variable is not defined)
JOSHUA_MEMORY_FLAGS ?= $(error JOSHUA_MEMORY_FLAGS is not defined)
JOSHUA_THREADS ?= $(error JOSHUA_THREADS is not defined)

MERT_JVM_FLAGS ?= $(error MERT_JVM_FLAGS is not defined)

TM_GRAMMAR ?= $(error TM_GRAMMAR is not defined)
LM_FILE ?= $(error LM_FILE is not defined)
LM_ORDER ?= $(error LM_ORDER is not defined)

#SPLIT_SIZE ?= $(error SPLIT_SIZE is not defined)
FILE_TO_TRANSLATE ?= $(error FILE_TO_TRANSLATE is not defined)
REFERENCE_BASE ?= $(error REFERENCE_BASE is not defined)
NUM_REFERENCES ?= $(error NUM_REFERENCES is not defined)

NBEST_OUTPUT ?= $(error NBEST_OUTPUT is not defined)
RENUMBER_NBEST_OUTPUT ?= $(error RENUMBER_NBEST_OUTPUT is not defined)


################################################################################
################################################################################
####                                                                        ####
####                        Derived Variables                               ####
####                                                                        ####
################################################################################
################################################################################


# Define the directory for stoing grammar files
MERT_DIR ?= ${EXPERIMENT_DIR}/${STAGE_NUMBER}.${STAGE_NAME}



################################################################################
################################################################################
####                                                                        ####
####                          Make targets                                  ####
####                                                                        ####
################################################################################
################################################################################


${MERT_DIR}/joshua.config.ZMERT.final: ${MERT_DIR}/mert.params ${MERT_DIR}/mert.config ${MERT_DIR}/joshua.config ${MERT_DIR}/decoder.command | ${MERT_DIR}
	java ${MERT_JVM_FLAGS} -cp ${JOSHUA}/bin joshua.zmert.ZMERT ${MERT_DIR}/mert.config &> ${MERT_DIR}/mert.out.log


${MERT_DIR}/mert.params: | ${MERT_DIR}
	@echo "lm			|||	1.000000		Opt	0.1	+Inf	+0.5	+1.5" > $@
	@echo "phrasemodel pt 0	|||	1.066893		Opt	-Inf	+Inf	-1	+1" >> $@
	@echo "phrasemodel pt 1	|||	0.752247		Opt	-Inf	+Inf	-1	+1" >> $@
	@echo "phrasemodel pt 2	|||	0.589793		Opt	-Inf	+Inf	-1	+1" >> $@
	@echo "wordpenalty		|||	-2.844814		Opt	-Inf	+Inf	-5	0" >> $@
	@echo "normalization = absval 1 lm" >> $@

${MERT_DIR}/mert.config: | ${MERT_DIR}
	@echo "-s	${FILE_TO_TRANSLATE}    # source sentences file name" > $@
	@echo "-r	${REFERENCE_BASE}                     # target sentences file name (in this case, file name prefix)" >> $@
	@echo "-rps	${NUM_REFERENCES}                       # references per sentence" >> $@
	@echo "-p	${MERT_DIR}/mert.params             # parameter file" >> $@
	@echo "-m	BLEU 4 closest          # evaluation metric and its options" >> $@
	@echo "-maxIt	20                      # maximum MERT iterations" >> $@
	@echo "-ipi	20                      # number of intermediate initial points per iteration" >> $@
	@echo "-cmd	${MERT_DIR}/decoder.command       # file containing commands to run decoder" >> $@
	@echo "-decOut	${MERT_DIR}/nbest.out               # file prodcued by decoder" >> $@
	@echo "-dcfg	${MERT_DIR}/joshua.config           # decoder config file" >> $@
	@echo "-N	300                     # size of N-best list generated each iteration" >> $@
	@echo "-v	2                       # verbosity level (0-2; higher value => more verbose)" >> $@
	@echo "-decV   1                       # print output from decoder" >> $@
	@echo "-seed   12341234                # random number generator seed" >> $@

${MERT_DIR}/joshua.config: | ${MERT_DIR}
	@echo "tm_file=${TM_GRAMMAR}" > $@ 
	@echo "lm_file=${LM_FILE}" >> $@
	@echo "glue_file=${JOSHUA}/grammars/hiero.glue" >> $@
	@echo "" >> $@
	@echo "tm_format=hiero" >> $@
	@echo "glue_format=hiero" >> $@
	@echo "" >> $@
	@echo "#lm config" >> $@
	@echo "use_srilm=true" >> $@
	@echo "lm_ceiling_cost=100" >> $@
	@echo "use_left_equivalent_state=false" >> $@
	@echo "use_right_equivalent_state=false" >> $@
	@echo "order=${LM_ORDER}" >> $@
	@echo "" >> $@
	@echo "" >> $@
	@echo "#tm config" >> $@
	@echo "span_limit=10" >> $@
	@echo "phrase_owner=pt" >> $@
	@echo "mono_owner=mono" >> $@
	@echo "begin_mono_owner=begin_mono" >> $@
	@echo "default_non_terminal=X" >> $@
	@echo "goalSymbol=S" >> $@
	@echo "" >> $@
	@echo "#pruning config" >> $@
	@echo "fuzz1=0.1" >> $@
	@echo "fuzz2=0.1" >> $@
	@echo "max_n_items=30" >> $@
	@echo "relative_threshold=10.0" >> $@
	@echo "max_n_rules=50" >> $@
	@echo "rule_relative_threshold=10.0" >> $@
	@echo "" >> $@
	@echo "#nbest config" >> $@
	@echo "use_unique_nbest=true" >> $@
	@echo "use_tree_nbest=false" >> $@
	@echo "add_combined_cost=true" >> $@
	@echo "top_n=300" >> $@
	@echo "" >> $@
	@echo "" >> $@
	@echo "#remoter lm server config,we should first prepare remote_symbol_tbl before starting any jobs" >> $@
	@echo "use_remote_lm_server=false" >> $@
	@echo "remote_symbol_tbl=./voc.remote.sym" >> $@
	@echo "num_remote_lm_servers=4" >> $@
	@echo "f_remote_server_list=./remote.lm.server.list" >> $@
	@echo "remote_lm_server_port=9000" >> $@
	@echo "" >> $@
	@echo "" >> $@
	@echo "#parallel deocoder: it cannot be used together with remote lm" >> $@
	@echo "num_parallel_decoders=${JOSHUA_THREADS}" >> $@
	@echo "parallel_files_prefix=/tmp/" >> $@
	@echo "" >> $@
	@echo "" >> $@
	@echo "###### model weights" >> $@
	@echo "#lm order weight" >> $@
	@echo "lm 1.0" >> $@
	@echo "" >> $@
	@echo "#phrasemodel owner column(0-indexed) weight" >> $@
	@echo "phrasemodel pt 0 1.066893" >> $@
	@echo "phrasemodel pt 1 0.752247" >> $@
	@echo "phrasemodel pt 2 0.589793" >> $@
	@echo "" >> $@
	@echo "#wordpenalty weight" >> $@
	@echo "wordpenalty -2.844814" >> $@


${MERT_DIR}/decoder.command: | ${MERT_DIR}
	@echo "#!/bin/bash" > $@
	@echo "" >> $@
	@echo "java ${JOSHUA_MEMORY_FLAGS} -cp ${JOSHUA}/bin -Djava.library.path=${JOSHUA}/lib -Dfile.encoding=utf8 joshua.decoder.JoshuaDecoder ${MERT_DIR}/joshua.config ${FILE_TO_TRANSLATE} ${MERT_DIR}/nbest.out.with_untranslated_words" >> $@
	@echo "" >> $@
	@echo "${SCRIPTS_DIR}/strip-nonASCII-v2.rb < ${MERT_DIR}/nbest.out.with_untranslated_words > ${MERT_DIR}/nbest.out" >> $@
	chmod ug+x $@


${MERT_DIR}:
	mkdir -p $@
