# Calculate the full path to this make file
THIS.MAKEFILE:= $(realpath $(lastword ${MAKEFILE_LIST}))

# Define how to run this file
define USAGE
	$(info  )
	$(info Usage:	make -f ${THIS.MAKEFILE} JOSHUA=/path/to/joshua MERT_DIR=/path/to/dir mert)
	$(info  )
	$(error )
endef


# If any of these required parameters are not defined,
#    print usage, then exit
SRC ?= $(call USAGE)
TGT ?= $(call USAGE)
JOSHUA ?= $(call USAGE)
MERT_FILE_TO_TRANSLATE ?= $(call USAGE)
MERT_REFERENCE_BASE ?= $(call USAGE)
MERT_NUM_REFERENCES ?= $(call USAGE)
MERT_METRIC_NAME ?= $(call USAGE)
LM_NGRAM_ORDER ?= $(call USAGE)
TRAINED_LM_DIR ?= $(call USAGE)
EXTRACT_RULES_DIR ?= $(call USAGE)
JOSHUA_MAX_N_ITEMS ?= $(call USAGE)
JOSHUA_THREADS ?= $(call USAGE)
JOSHUA_MEMORY_FLAGS ?= $(call USAGE)
MERT_JVM_FLAGS ?= $(call USAGE)

# Translate the human-readable metric name (bleu or ter_bleu)
#   into a Z-MERT-readable metric configuration
#   or throw an error if the metric name is ill-defined.
ifeq (${MERT_METRIC_NAME},bleu)
MERT_METRIC:=BLEU 4 closest
else ifeq (${MERT_METRIC_NAME},ter_bleu)
MERT_METRIC:=TER-BLEU nocase punc 20 50 ${MERT_DIR}/tercom.7.25.jar 6 4 closest
${MERT_DIR}/joshua.config.ZMERT.final ${MERT_DIR}/mert.config: ${MERT_DIR}/tercom.7.25.jar
else
MERT_METRIC:=$(error MERT_METRIC_NAME must be set to bleu or ter_bleu)
endif


# If the user does not specify a target, print out how to run this file
usage:
	$(call USAGE)

# Define how to create a tuned Joshua configuration using Z-MERT
${MERT_DIR}/joshua.config.ZMERT.final: ${JOSHUA}/bin/joshua.jar ${MERT_DIR}/mert.params ${MERT_DIR}/mert.config ${MERT_DIR}/joshua.config ${MERT_DIR}/decoder.command | ${MERT_DIR}
	java ${MERT_JVM_FLAGS} -cp ${JOSHUA}/bin/joshua.jar joshua.zmert.ZMERT ${MERT_DIR}/mert.config &> ${MERT_DIR}/mert.out.log

# Define MERT parameters
${MERT_DIR}/mert.params: | ${MERT_DIR}
	@echo "lm			|||	1.000000		Opt	0.1	+Inf	+0.5	+1.5" > $@
	@echo "phrasemodel pt 0	|||	1.066893		Opt	-Inf	+Inf	-1	+1" >> $@
	@echo "phrasemodel pt 1	|||	0.752247		Opt	-Inf	+Inf	-1	+1" >> $@
	@echo "phrasemodel pt 2	|||	0.589793		Opt	-Inf	+Inf	-1	+1" >> $@
	@echo "wordpenalty		|||	-2.844814		Opt	-Inf	+Inf	-5	0" >> $@
	@echo "normalization = absval 1 lm" >> $@


# Configure MERT
${MERT_DIR}/mert.config: | ${MERT_DIR}
	@echo "-s	${MERT_FILE_TO_TRANSLATE}		# source sentences file name" > $@
	@echo "-r	${MERT_REFERENCE_BASE}		# target sentences file name or file name prefix, if multiple references" >> $@
	@echo "-rps	${MERT_NUM_REFERENCES}		# references per sentence" >> $@
	@echo "-p	${MERT_DIR}/mert.params		# mert parameter definitions file" >> $@
	@echo "-m	${MERT_METRIC}		# evaluation metric and its options" >> $@
	@echo "-maxIt	20		# maximum MERT iterations" >> $@
	@echo "-ipi	20		# number of intermediate initial points per iteration" >> $@
	@echo "-cmd	${MERT_DIR}/decoder.command		# file containing commands to run decoder" >> $@
	@echo "-decOut	${MERT_DIR}/nbest.out		# file produced by decoder" >> $@
	@echo "-dcfg	${MERT_DIR}/joshua.config		# decoder config file" >> $@
	@echo "-N	300		# size of N-best list generated each iteration" >> $@
	@echo "-v	2		# verbosity level (0-2; higher value => more verbose)" >> $@
	@echo "-decV   1		# print output from decoder" >> $@
	@echo "-seed   12341234		# random number generator seed" >> $@

# Configure Joshua for MERT iteration runs
${MERT_DIR}/joshua.config: | ${MERT_DIR}
	@echo "tm_file=${EXTRACT_RULES_DIR}/${SRC}-${TGT}.grammar" > $@ 
	@echo "lm_file=${TRAINED_LM_DIR}/${TGT}.lm" >> $@
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
	@echo "order=${LM_NGRAM_ORDER}" >> $@
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
	@echo "max_n_items=${JOSHUA_MAX_N_ITEMS}" >> $@
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


${MERT_DIR}/decoder.command: ${JOSHUA}/bin/joshua.jar ${MERT_DIR}/joshua.config | ${MERT_DIR}
	@echo "#!/bin/bash" > $@
	@echo "" >> $@
	@echo "java ${JOSHUA_MEMORY_FLAGS} -cp ${JOSHUA}/bin/joshua.jar -Djava.library.path=${JOSHUA}/lib -Dfile.encoding=utf8 joshua.decoder.JoshuaDecoder ${MERT_DIR}/joshua.config ${MERT_FILE_TO_TRANSLATE} ${MERT_DIR}/nbest.out" >> $@
	chmod ug+x $@

# Download TER
${MERT_DIR}/tercom-0.7.25.tgz: | ${MERT_DIR}
	wget --no-verbose -P ${MERT_DIR} http://www.cs.umd.edu/~snover/tercom/tercom-0.7.25.tgz

# Extract TER jar file
${MERT_DIR}/tercom.7.25.jar: ${MERT_DIR}/tercom-0.7.25.tgz | ${MERT_DIR}
	tar -C ${MERT_DIR} --touch --strip-components=1 -x $(subst ${MERT_DIR}/,tercom-0.7.25/,$@) -vzf $<

# Create directory
${MERT_DIR}:
	mkdir -p $@