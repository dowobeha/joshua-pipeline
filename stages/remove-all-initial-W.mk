################################################################################
################################################################################
####                                                                        ####
####                      Preprocessing make file                           ####
####                                                                        ####
################################################################################
################################################################################

$(info )
$(info This make file defines:)
$(info --- how to remove all sentence-initial W- from an Arabic file)
$(info )




SCRIPT_NAME := reprocess_remove-W.pl

define run
$(call log,"Remove all sentence-initial W-")
rm -f $@.fakeAR
ln -s $< $@.fakeAR
perl -e 'open INPUT, "$$ARGV[0]" or die $$!; open OUTPUT, ">$$ARGV[1]" or die $$!; while (<INPUT>) { print OUTPUT "\n"; }' $@.fakeAR $@.fakeEN
perl -e 'open INPUT, "$$ARGV[0]" or die $$!; open OUTPUT, ">$$ARGV[1]" or die $$!; while (<INPUT>) { print OUTPUT "\n"; }' $@.fakeAR $@.fakeALN
${SCRIPT} --ar .fakeAR --en .fakeEN --align .fakeALN --pp .noW $@
rm $@.fakeAR $@.fakeEN $@.fakeALN $@.noW.fakeEN $@.noW.fakeALN
mv $@.noW.fakeAR $@
$(call log,"Remove all sentence-initial W- COMPLETE")
endef


# Calculate the directory where this make file is stored
PATH.TO.THIS.MAKEFILE:=$(dir $(lastword ${MAKEFILE_LIST}))

include ${PATH.TO.THIS.MAKEFILE}/_common_dir_to_dir.mk
