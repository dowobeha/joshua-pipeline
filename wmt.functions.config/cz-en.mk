################################################################################
####                 Gather information about this make file                ####
####                                                                        ####
#### Get the full path to this make file
PATH.TO.THIS.MAKEFILE:=$(abspath $(dir $(lastword ${MAKEFILE_LIST})))
####
#### Get the filename of this make file
THIS.MAKEFILE.NAME:=$(basename $(notdir $(lastword ${MAKEFILE_LIST})))
####                                                                        ####
################################################################################


all:
	$(MAKE) -f ${PATH.TO.THIS.MAKEFILE}/experiment.mk
	$(MAKE) -f ${PATH.TO.THIS.MAKEFILE}/010.Subsample.cz-en.run1.mk
	$(MAKE) -f ${PATH.TO.THIS.MAKEFILE}/011.BerkeleyAlign.cz-en.run1.mk
	$(MAKE) -f ${PATH.TO.THIS.MAKEFILE}/012.ExtractGrammar.cz-en.run1.mk
	$(MAKE) -f ${PATH.TO.THIS.MAKEFILE}/013.LanguageModel.en.run1.mk
	$(MAKE) -f ${PATH.TO.THIS.MAKEFILE}/014.MERT.cz-en.bleu.run1.mk
	$(MAKE) -f ${PATH.TO.THIS.MAKEFILE}/015.Translate.cz-en.run1.mk
	$(MAKE) -f ${PATH.TO.THIS.MAKEFILE}/016.ExtractTopCand.cz-en.run1.mk
	$(MAKE) -f ${PATH.TO.THIS.MAKEFILE}/017.ExtractMBRCand.cz-en.run1.mk
