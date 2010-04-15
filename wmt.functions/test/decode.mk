################################################################################
####                       Purpose of this make file:                       ####
####                                                                        ####
#### This file defines functions to translate using Joshua
####                                                                        ####
################################################################################


################################################################################
#### Function definition:              
####
define RUN_JOSHUA
####
#### Required parameters:
$(if $1,,$(error Function $0: a required parameter $$1 (defining JOSHUA_TRANSLATION_DIR) was omitted))
$(if $2,,$(error Function $0: a required parameter $$2 (defining JOSHUA) was omitted))
$(if $3,,$(error Function $0: a required parameter $$3 (defining JOSHUA_MEMORY_FLAGS) was omitted))
$(if $4,,$(error Function $0: a required parameter $$4 (defining JOSHUA_FILE_TO_TRANSLATE) was omitted))
$(if $5,,$(error Function $0: a required parameter $$5 (defining JOSHUA_NBEST_OUTPUT_FILENAME) was omitted))
$(if $6,,$(error Function $0: a required parameter $$6 (defining JOSHUA_TRAINED_CONFIG) was omitted))
$(if $7,,$(warning Function $0: an optional parameter $$7 (defining TRANSLATION_GRAMMAR) was omitted. This is probably OK, as long as the translation grammar that was used during MERT is valid for the file to translate $4. If you subsampled the training corpus, and subsampling did not have access to the current file to translate, then this message indicates that you probably should specify a different translation grammar as a parameter to $0))


all: $1/$5

$(if $7,\
$(eval $(call RUN_JOSHUA_CREATE_CONFIG,$1,$6,$7)),\
$(eval $(call RUN_JOSHUA_COPY_CONFIG,$1,$6)))

$1/$5: $4 $1/joshua.config $2/bin/joshua.jar | $1
#	Run Joshua using specified JVM parameters
	java $3 -cp $2/bin/joshua.jar \
		-Djava.library.path=$2/lib \
		-Dfile.encoding=utf8 \
		joshua.decoder.JoshuaDecoder \
		$1/joshua.config \
		$$< \
		$$@

$1:
	mkdir -p $$@

endef
####                                                                        ####
################################################################################


################################################################################
#### Helper function definition:              
####
define RUN_JOSHUA_COPY_CONFIG
$(if $1,,$(error Function $0: a required parameter $$1 (defining JOSHUA_TRANSLATION_DIR) was omitted))\
$(if $2,,$(error Function $0: a required parameter $$2 (defining JOSHUA_TRAINED_CONFIG) was omitted))\
$1/joshua.config: $2 | $1
	cp $$< $$@
endef
####                                                                        ####
################################################################################


################################################################################
#### Helper function definition:              
####
define RUN_JOSHUA_CREATE_CONFIG
$(if $1,,$(error Function $0: a required parameter $$1 (defining JOSHUA_TRANSLATION_DIR) was omitted))\
$(if $2,,$(error Function $0: a required parameter $$2 (defining JOSHUA_TRAINED_CONFIG) was omitted))\
$(if $3,,$(error Function $0: a required parameter $$3 (defining TRANSLATION_GRAMMAR) was omitted))
$1/joshua.config: $6 $3 | $1
	echo "tm_file=$3" > $$@; \
	cat $$< >> $$@
endef
####                                                                        ####
################################################################################
