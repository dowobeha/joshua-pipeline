################################################################################
####                       Purpose of this make file:                       ####
####                                                                        ####
#### This file defines functions to extract a translation grammar using Hiero
####                                                                        ####
################################################################################


################################################################################
#### Function definition:              
####
define EXTRACT_GRAMMAR_HIERO
####
#### Required parameters:
$(if $1,,$(error Function $0: a required parameter $$1 (defining EXTRACT_RULES_DIR) was omitted))
$(if $2,,$(error Function $0: a required parameter $$2 (defining SRC) was omitted))
$(if $3,,$(error Function $0: a required parameter $$3 (defining TGT) was omitted))
$(if $4,,$(error Function $0: a required parameter $$4 (defining BERKELEY_ALIGN_DIR) was omitted))
$(if $5,,$(error Function $0: a required parameter $$5 (defining SUBSAMPLED_DATA) was omitted))
$(if $6,,$(error Function $0: a required parameter $$6 (defining HIERO_DIR) was omitted))

# Convenient target
all: $1/$2-$3.grammar


# Extract grammar
$1/$2-$3.grammar: $1/$2-$3.ini $5/combined.test.$2 | $1
	time cat $5/combined.test.$2 | $6/hiero/decoder.py -c $$< -x $$@

# Compile corpus
$1/sa_bin $1/$2-$3.ini: $4/alignments/training.$2 $4/alignments/training.$3  $4/alignments/training.align $5/combined.test.$2 | $1
	time $6/sa-utils/compile_files.pl \
		$4/alignments/training.$2 \
		$4/alignments/training.$3 \
		$4/alignments/training.align  \
		/dev/null \
		$6/sa-utils/decoder.extract.ini \
		$1/sa_bin > $1/$2-$3.ini


# Create directory
$1:
	mkdir -p $$@


endef

####                                                                        ####
################################################################################
