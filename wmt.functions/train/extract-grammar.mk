################################################################################
####                       Purpose of this make file:                       ####
####                                                                        ####
#### This file defines functions to extract a translation grammar using Joshua
####                                                                        ####
################################################################################


################################################################################
#### Function definition:              
####
define EXTRACT_GRAMMAR
####
#### Required parameters:
$(if $1,,$(error Function $0: a required parameter $$1 (defining EXTRACT_RULES_DIR) was omitted))
$(if $2,,$(error Function $0: a required parameter $$2 (defining SRC) was omitted))
$(if $3,,$(error Function $0: a required parameter $$3 (defining TGT) was omitted))
$(if $4,,$(error Function $0: a required parameter $$4 (defining BERKELEY_ALIGN_DIR) was omitted))
$(if $5,,$(error Function $0: a required parameter $$5 (defining SUBSAMPLED_DATA) was omitted))
$(if $6,,$(error Function $0: a required parameter $$6 (defining JOSHUA) was omitted))
$(if $7,,$(error Function $0: a required parameter $$7 (defining EXTRACT_RULES_JVM_FLAGS) was omitted))


all: $1/$2-$3.grammar

# Extract grammar
$1/$2-$3.grammar: $1/compiledCorpus.josh $1/extract.xml $6/bin/joshua.jar $5/combined.test.$2 | $1
	export ANT_OPTS="$7"; \
	ant -f $1/extract.xml extractGrammar

# Compile corpus
$1/compiledCorpus.josh: $1/extract.xml $6/bin/joshua.jar $4/alignments/training.$2 $4/alignments/training.$3  $4/alignments/training.align | $1
	export ANT_OPTS="$7"; \
	ant -f $1/extract.xml compileCorpus

# Create ant build file defining how to compile corpus and extract grammar
$1/extract.xml: $6/bin/joshua.jar $4/alignments/training.$2 $4/alignments/training.$3  $4/alignments/training.align $5/combined.test.$2 | $1
	@echo "<project name=\"Joshua grammar extraction\">" > $$@; \
	echo "" >> $$@; \
	echo "	<!-- Declare custom ant tasks for Joshua grammar extraction -->" >> $$@; \
	echo "	<taskdef name=\"compileJosh\" classname=\"joshua.corpus.suffix_array.Compile\" classpath=\"$6/bin/joshua.jar\"/>" >> $$@; \
	echo "	<taskdef name=\"extractRules\" classname=\"joshua.prefix_tree.ExtractRules\" classpath=\"$6/bin/joshua.jar\"/>" >> $$@; \
	echo "" >> $$@; \
	echo "	<!-- Define task to compile aligned parallel corpus into binary memory-mappable files -->" >> $$@; \
	echo "	<target name=\"compileCorpus\">" >> $$@; \
	echo "		<compileJosh" >> $$@; \
	echo "			sourceCorpus=\"$4/alignments/training.$2\"" >> $$@; \
	echo "			targetCorpus=\"$4/alignments/training.$3\"" >> $$@; \
	echo "			alignments=\"$4/alignments/training.align\"" >> $$@; \
	echo "			outputDir=\"$1/compiledCorpus.josh\"" >> $$@; \
	echo "		/>" >> $$@; \
	echo "	</target>" >> $$@; \
	echo "" >> $$@; \
	echo "	<!-- Define task to extract test-set specific SCFG translation grammar -->" >> $$@; \
	echo "	<target name=\"extractGrammar\">" >> $$@; \
	echo "		<extractRules" >> $$@; \
	echo "			joshDir=\"$1/compiledCorpus.josh\"" >> $$@; \
	echo "			outputFile=\"$1/$2-$3.grammar\""  >> $$@; \
	echo "			testFile=\"$5/combined.test.$2\"" >> $$@; \
	echo "		/>" >> $$@; \
	echo "	</target>" >> $$@; \
	echo "" >> $$@; \
	echo "</project>" >> $$@; \

# Create directory
$1:
	mkdir -p $$@; \


endef

####                                                                        ####
################################################################################
