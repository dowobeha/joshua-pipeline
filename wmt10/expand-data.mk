

# Calculate the full path to this make file
THIS.MAKEFILE:= $(realpath $(lastword ${MAKEFILE_LIST}))

# Define how to run this file
define USAGE
	$(info  )
	$(info Usage:	make -f ${THIS.MAKEFILE} DOWNLOADS_DIR=/path/to/downloads DATA_DIR=/path/to/expand expand)
	$(info  )
	$(error )
endef


# If any of these required parameters are not defined,
#    print usage, then exit
DOWNLOADS_DIR ?= $(call USAGE)
DATA_DIR ?= $(call USAGE)


# If the user does not specify a target, print out how to run this file
usage:
	$(call USAGE)

# Download all files
expand: training

# These files can be extracted from the parallel corpus training data
PARALLEL_CORPORA:=${DATA_DIR}/training/europarl-v5.de-en.de ${DATA_DIR}/training/europarl-v5.de-en.en ${DATA_DIR}/training/europarl-v5.es-en.en ${DATA_DIR}/training/europarl-v5.es-en.es ${DATA_DIR}/training/europarl-v5.fr-en.en ${DATA_DIR}/training/europarl-v5.fr-en.fr ${DATA_DIR}/training/news-commentary10.cz-en.cz ${DATA_DIR}/training/news-commentary10.cz-en.en ${DATA_DIR}/training/news-commentary10.de-en.de ${DATA_DIR}/training/news-commentary10.de-en.en ${DATA_DIR}/training/news-commentary10.es-de.de ${DATA_DIR}/training/news-commentary10.es-de.es ${DATA_DIR}/training/news-commentary10.es-en.en ${DATA_DIR}/training/news-commentary10.es-en.es ${DATA_DIR}/training/news-commentary10.fr-en.en ${DATA_DIR}/training/news-commentary10.fr-en.fr

# These files can be extracted from the monolingual language model training data
MONOLINGUAL_CORPORA:=${DATA_DIR}/training/europarl-v5.en ${DATA_DIR}/training/europarl-v5.de ${DATA_DIR}/training/europarl-v5.es ${DATA_DIR}/training/europarl-v5.fr ${DATA_DIR}/training/news-commentary10.en ${DATA_DIR}/training/news-commentary10.cz ${DATA_DIR}/training/news-commentary10.fr ${DATA_DIR}/training/news-commentary10.de ${DATA_DIR}/training/news-commentary10.es ${DATA_DIR}/training/news.de.shuffled ${DATA_DIR}/training/news.es.shuffled ${DATA_DIR}/training/news.en.shuffled ${DATA_DIR}/training/news.cz.shuffled

# These files can be extracted from the 10^9 French-English parallel corpus
HUGE_FR_EN_CORPUS:=${DATA_DIR}/giga-fren.release2.fr.gz ${DATA_DIR}/giga-fren.release2.en.gz

# These files can be extracted from the UN French-English parallel corpus
UN_FR_EN_CORPUS:=${DATA_DIR}/undoc.2000.en-fr.en ${DATA_DIR}/undoc.2000.en-fr.fr

# These files can be extracted from the UN Spanish-English parallel corpus
UN_ES_EN_CORPUS:=${DATA_DIR}/undoc.2000.en-es.en ${DATA_DIR}/undoc.2000.en-es.es

# These files can be extracted from the development set data
DEV_CORPORA:=${DATA_DIR}/dev/newssyscomb2009-ref.cz.sgm ${DATA_DIR}/dev/newssyscomb2009-ref.de.sgm ${DATA_DIR}/dev/newssyscomb2009-ref.en.sgm ${DATA_DIR}/dev/newssyscomb2009-ref.es.sgm ${DATA_DIR}/dev/newssyscomb2009-ref.fr.sgm ${DATA_DIR}/dev/newssyscomb2009-ref.hu.sgm ${DATA_DIR}/dev/newssyscomb2009-ref.it.sgm ${DATA_DIR}/dev/newssyscomb2009-src.cz.sgm ${DATA_DIR}/dev/newssyscomb2009-src.de.sgm ${DATA_DIR}/dev/newssyscomb2009-src.en.sgm ${DATA_DIR}/dev/newssyscomb2009-src.es.sgm ${DATA_DIR}/dev/newssyscomb2009-src.fr.sgm ${DATA_DIR}/dev/newssyscomb2009-src.hu.sgm ${DATA_DIR}/dev/newssyscomb2009-src.it.sgm ${DATA_DIR}/dev/newstest2009-ref.cz.sgm ${DATA_DIR}/dev/newstest2009-ref.de.sgm ${DATA_DIR}/dev/newstest2009-ref.en.sgm ${DATA_DIR}/dev/newstest2009-ref.es.sgm ${DATA_DIR}/dev/newstest2009-ref.fr.sgm ${DATA_DIR}/dev/newstest2009-ref.hu.sgm ${DATA_DIR}/dev/newstest2009-ref.it.sgm ${DATA_DIR}/dev/newstest2009-src.cz.sgm ${DATA_DIR}/dev/newstest2009-src.de.sgm ${DATA_DIR}/dev/newstest2009-src.en.sgm ${DATA_DIR}/dev/newstest2009-src.es.sgm ${DATA_DIR}/dev/newstest2009-src.fr.sgm ${DATA_DIR}/dev/newstest2009-src.hu.sgm ${DATA_DIR}/dev/newstest2009-src.it.sgm ${DATA_DIR}/dev/newstest2009-src.xx.sgm ${DATA_DIR}/dev/news-test2008-ref.en.sgm ${DATA_DIR}/dev/news-test2008-ref.es.sgm ${DATA_DIR}/dev/news-test2008-ref.fr.sgm ${DATA_DIR}/dev/news-test2008-ref.hu.sgm ${DATA_DIR}/dev/news-test2008-src.cz.sgm ${DATA_DIR}/dev/news-test2008-src.de.sgm ${DATA_DIR}/dev/news-test2008-src.en.sgm ${DATA_DIR}/dev/news-test2008-src.es.sgm ${DATA_DIR}/dev/news-test2008-ref.cz.sgm ${DATA_DIR}/dev/news-test2008-ref.de.sgm ${DATA_DIR}/dev/news-test2008-src.fr.sgm ${DATA_DIR}/dev/news-test2008-src.hu.sgm

# These files can be extracted from the tools bundle
SCRIPTS_FILES:=${DATA_DIR}/scripts/detokenizer.perl ${DATA_DIR}/scripts/wrap-xml.perl ${DATA_DIR}/scripts/lowercase.perl ${DATA_DIR}/scripts/tokenizer.perl ${DATA_DIR}/scripts/reuse-weights.perl ${DATA_DIR}/scripts/nonbreaking_prefixes/nonbreaking_prefix.de ${DATA_DIR}/scripts/nonbreaking_prefixes/nonbreaking_prefix.en ${DATA_DIR}/scripts/nonbreaking_prefixes/nonbreaking_prefix.el



training: ${PARALLEL_CORPORA} ${MONOLINGUAL_CORPORA} ${HUGE_FR_EN_CORPUS} ${UN_FR_EN_CORPUS} ${UN_ES_EN_CORPUS} ${DEV_CORPORA}



# Extract files from parallel corpus training data
${PARALLEL_CORPORA}: ${DOWNLOADS_DIR}/training-parallel.tgz | ${DATA_DIR}
	tar -C ${DATA_DIR} --touch -x $(subst ${DATA_DIR}/,,$@) -vzf $<

# Extract files from 10^9 French-English corpus (2.3 GB)
${HUGE_FR_EN_CORPUS}: ${DOWNLOADS_DIR}/training-giga-fren.tar | ${DATA_DIR}
	tar -C ${DATA_DIR} --touch -x $(subst ${DATA_DIR}/,,$@) -vf $<

# Extract files from monolingual language model training data (5.0 GB)
${MONOLINGUAL_CORPORA}: ${DOWNLOADS_DIR}/training-monolingual.tgz | ${DATA_DIR}
	tar -C ${DATA_DIR} --touch -x $(subst ${DATA_DIR}/,,$@) -vzf $<

# Extract files from UN corpus French-English (671 MB)
${UN_FR_EN_CORPUS}: ${DOWNLOADS_DIR}/un.en-fr.tgz | ${DATA_DIR}
	tar -C ${DATA_DIR} --touch -x $(subst ${DATA_DIR}/,,$@) -vzf $<

# Extract files from UN corpus Spanish-English (594 MB)
${UN_ES_EN_CORPUS}: ${DOWNLOADS_DIR}/un.en-es.tgz | ${DATA_DIR}
	tar -C ${DATA_DIR} --touch -x $(subst ${DATA_DIR}/,,$@) -vzf $<

# Extract files from development sets (4.0 MB)
${DEV_CORPORA}: ${DOWNLOADS_DIR}/dev.tgz | ${DATA_DIR}
	tar -C ${DATA_DIR} --touch -x $(subst ${DATA_DIR}/,,$@) -vzf $<

# Extract files from tools (3 KB)
${SCRIPTS_FILES}: ${DOWNLOADS_DIR}/scripts.tgz | ${DATA_DIR}
	tar -C ${DATA_DIR} --touch -x $(subst ${DATA_DIR}/,,$@) -vzf $<


# If someone calls make all, do the sensible thing
all: training


# Make directory to store original downloaded data
${DATA_DIR}:
	mkdir -p $@


# The following targets do not create actual files with that name
.PHONY: all usage expand training 