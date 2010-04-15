################################################################################
####                       Purpose of this make file:                       ####
####                                                                        ####
#### This file defines functions to run minimum error rate training
####                                                                        ####
################################################################################


################################################################################
#### Function definition:              
####
define MERT
####
#### Required parameters:
$(if $1,,$(error Function $0: a required parameter $$1 (defining MERT_DIR) was omitted))
$(if $2,,$(error Function $0: a required parameter $$2 (defining TRANSLATION_GRAMMAR) was omitted))
$(if $3,,$(error Function $0: a required parameter $$3 (defining JOSHUA) was omitted))
$(if $4,,$(error Function $0: a required parameter $$4 (defining JOSHUA_MEMORY_FLAGS) was omitted)) 
$(if $5,,$(error Function $0: a required parameter $$5 (defining LANGUAGE_MODEL) was omitted))
$(if $6,,$(error Function $0: a required parameter $$6 (defining MERT_INPUT_DIR) was omitted))
$(if $7,,$(error Function $0: a required parameter $$7 (defining MERT_FILE_TO_TRANSLATE) was omitted))
$(if $8,,$(error Function $0: a required parameter $$8 (defining MERT_REFERENCE_BASE) was omitted))
$(if $9,,$(error Function $0: a required parameter $$9 (defining MERT_METRIC_NAME) was omitted))
$(if ${10},,$(error Function $0: a required parameter $${10} (defining MERT_NUM_REFERENCES) was omitted))
$(if ${11},,$(error Function $0: a required parameter $${11} (defining LM_NGRAM_ORDER) was omitted))
$(if ${12},,$(error Function $0: a required parameter $${12} (defining JOSHUA_MAX_N_ITEMS) was omitted))
$(if ${13},,$(error Function $0: a required parameter $${13} (defining JOSHUA_THREADS) was omitted))
$(if ${14},,$(error Function $0: a required parameter $${14} (defining MERT_JVM_FLAGS) was omitted))

all: $1/joshua.config.ZMERT.final

# Define how to create a tuned Joshua configuration using Z-MERT
$1/joshua.config.ZMERT.final: $(call MERT_REQUIRED_JARS,$1,$9,$3) $1/mert.params $1/mert.config $1/joshua.config $1/decoder.command | $1
	java ${14} -cp $(call ADD_CLASSPATH_COLONS,$(call MERT_REQUIRED_JARS,$1,$9,$3)) joshua.zmert.ZMERT $1/mert.config &> $1/mert.out.log

# Define MERT parameters
$1/mert.params: | $1
	@echo "lm			|||	1.000000		Opt	0.1	+Inf	+0.5	+1.5" > $$@; \
	echo "phrasemodel pt 0	|||	1.066893		Opt	-Inf	+Inf	-1	+1" >> $$@; \
	echo "phrasemodel pt 1	|||	0.752247		Opt	-Inf	+Inf	-1	+1" >> $$@; \
	echo "phrasemodel pt 2	|||	0.589793		Opt	-Inf	+Inf	-1	+1" >> $$@; \
	echo "wordpenalty		|||	-2.844814		Opt	-Inf	+Inf	-5	0" >> $$@; \
	echo "normalization = absval 1 lm" >> $$@


# Configure MERT
$1/mert.config: | $1
	@echo "-s	$6/$7		# source sentences file name" > $$@; \
	echo "-r	$6/$8		# target sentences file name or file name prefix, if multiple references" >> $$@; \
	echo "-rps	${10}		# references per sentence" >> $$@; \
	echo "-p	$1/mert.params		# mert parameter definitions file" >> $$@; \
	echo "-m	$(call MERT_METRIC,$1,$9)		# evaluation metric and its options" >> $$@; \
	echo "-maxIt	20		# maximum MERT iterations" >> $$@; \
	echo "-ipi	20		# number of intermediate initial points per iteration" >> $$@; \
	echo "-cmd	$1/decoder.command		# file containing commands to run decoder" >> $$@; \
	echo "-decOut	$1/nbest.out		# file produced by decoder" >> $$@; \
	echo "-dcfg	$1/joshua.config		# decoder config file" >> $$@; \
	echo "-N	300		# size of N-best list generated each iteration" >> $$@; \
	echo "-v	2		# verbosity level (0-2; higher value => more verbose)" >> $$@; \
	echo "-decV   1		# print output from decoder" >> $$@; \
	echo "-seed   12341234		# random number generator seed" >> $$@

# Configure Joshua for MERT iteration runs
$1/joshua.config: | $1
	@echo "tm_file=$2" > $$@; \
	echo "lm_file=$5" >> $$@; \
	echo "glue_file=$3/grammars/hiero.glue" >> $$@; \
	echo "" >> $$@; \
	echo "tm_format=hiero" >> $$@; \
	echo "glue_format=hiero" >> $$@; \
	echo "" >> $$@; \
	echo "#lm config" >> $$@; \
	echo "use_srilm=true" >> $$@; \
	echo "lm_ceiling_cost=100" >> $$@; \
	echo "use_left_equivalent_state=false" >> $$@; \
	echo "use_right_equivalent_state=false" >> $$@; \
	echo "order=${11}" >> $$@; \
	echo "" >> $$@; \
	echo "" >> $$@; \
	echo "#tm config" >> $$@; \
	echo "span_limit=10" >> $$@; \
	echo "phrase_owner=pt" >> $$@; \
	echo "mono_owner=mono" >> $$@; \
	echo "begin_mono_owner=begin_mono" >> $$@; \
	echo "default_non_terminal=X" >> $$@; \
	echo "goalSymbol=S" >> $$@; \
	echo "" >> $$@; \
	echo "#pruning config" >> $$@; \
	echo "fuzz1=0.1" >> $$@; \
	echo "fuzz2=0.1" >> $$@; \
	echo "max_n_items=${12}" >> $$@; \
	echo "relative_threshold=10.0" >> $$@; \
	echo "max_n_rules=50" >> $$@; \
	echo "rule_relative_threshold=10.0" >> $$@; \
	echo "" >> $$@; \
	echo "#nbest config" >> $$@; \
	echo "use_unique_nbest=true" >> $$@; \
	echo "use_tree_nbest=false" >> $$@; \
	echo "add_combined_cost=true" >> $$@; \
	echo "top_n=300" >> $$@; \
	echo "" >> $$@; \
	echo "" >> $$@; \
	echo "#remoter lm server config,we should first prepare remote_symbol_tbl before starting any jobs" >> $$@; \
	echo "use_remote_lm_server=false" >> $$@; \
	echo "remote_symbol_tbl=./voc.remote.sym" >> $$@; \
	echo "num_remote_lm_servers=4" >> $$@; \
	echo "f_remote_server_list=./remote.lm.server.list" >> $$@; \
	echo "remote_lm_server_port=9000" >> $$@; \
	echo "" >> $$@; \
	echo "" >> $$@; \
	echo "#parallel deocoder: it cannot be used together with remote lm" >> $$@; \
	echo "num_parallel_decoders=${13}" >> $$@; \
	echo "parallel_files_prefix=/tmp/" >> $$@; \
	echo "" >> $$@; \
	echo "" >> $$@; \
	echo "###### model weights" >> $$@; \
	echo "#lm order weight" >> $$@; \
	echo "lm 1.0" >> $$@; \
	echo "" >> $$@; \
	echo "#phrasemodel owner column(0-indexed) weight" >> $$@; \
	echo "phrasemodel pt 0 1.066893" >> $$@; \
	echo "phrasemodel pt 1 0.752247" >> $$@; \
	echo "phrasemodel pt 2 0.589793" >> $$@; \
	echo "" >> $$@; \
	echo "#wordpenalty weight" >> $$@; \
	echo "wordpenalty -2.844814" >> $$@


$1/decoder.command: $1/joshua.config | $1
	@echo "#!/bin/bash" > $$@; \
	echo "" >> $$@; \
	echo "java $4 -cp $3/bin/joshua.jar -Djava.library.path=$3/lib -Dfile.encoding=utf8 joshua.decoder.JoshuaDecoder $1/joshua.config $6/$7 $1/nbest.out" >> $$@; \
	chmod ug+x $$@

# Download TER
$1/tercom-0.7.25.tgz: | $1
	wget --no-verbose -P $1 http://www.cs.umd.edu/~snover/tercom/tercom-0.7.25.tgz

# Extract TER jar file
$1/tercom.7.25.jar: $1/tercom-0.7.25.tgz | $1
	tar -C $1 --touch --strip-components=1 -x $$(subst $1/,tercom-0.7.25/,$$@) -vzf $$<

# Create directory
$1:
	mkdir -p $$@

endef

####                                                                        ####
################################################################################

################################################################################
#### Helper function definition:              
####
define MERT_METRIC
$(if $1,,$(error Function $0: a required parameter $$1 (defining MERT_DIR) was omitted))\
$(if $2,,$(error Function $0: a required parameter $$2 (defining MERT_METRIC_NAME) was omitted))\
$(if $(strip $(filter-out bleu,$2)),\
$(if $(strip $(filter-out ter_bleu,$2)),\
$(error MERT_METRIC_NAME must be set to bleu or ter_bleu. Currently value is $2),\
TER-BLEU nocase punc 20 50 $1/tercom.7.25.jar 6 4 closest),\
BLEU 4 closest)
endef
####                                                                        ####
################################################################################

################################################################################
#### Helper function definition:              
####
define MERT_REQUIRED_JARS
$(if $1,,$(error Function $0: a required parameter $$1 (defining MERT_DIR) was omitted))\
$(if $2,,$(error Function $0: a required parameter $$2 (defining MERT_METRIC_NAME) was omitted))\
$(if $3,,$(error Function $0: a required parameter $$3 (defining JOSHUA) was omitted))\
$(if $(strip $(filter-out bleu,$2)),\
$(if $(strip $(filter-out ter_bleu,$2)),\
$(error MERT_METRIC_NAME must be set to bleu or ter_bleu. Currently value is $2),\
$3/bin/joshua.jar $1/tercom.7.25.jar),\
$3/bin/joshua.jar)
endef
####                                                                        ####
################################################################################

################################################################################
#### Helper function definition:              
####
#### The goal of this function is to take the parameter (a list of file names)
#### and replace the separating spaces with colons, 
#### in order to make a well-formed Java classpath name list.
#### 
#### The subst function in make needs to be told 
#### that the thing to be substituted is a literal space character.
####
#### To get a literal space character that make won't ignore,
#### this function creates the string "_ _", 
#### then substitutes the empty string for each "_" character.
####
#### The resulting literal space character is then provided
#### as the first argument to the outermost subst function.
define ADD_CLASSPATH_COLONS
$(subst $(subst _,,$(join _ _,)),:,$(strip $1))
endef
####                                                                        ####
################################################################################

