###############################################################################
##                                                                           ##
##             REMOVE SENTENCE-INITIAL W- FROM ARABIC SENTENCES              ##
##                                                                           ##
###############################################################################


###############################################################################
## Certain variables must be defined for the functions in this file to work. ##
###############################################################################

ifndef REMOVE-W.SUFFIX
REMOVE-W.SUFFIX:=.noW
endif

ifndef REMOVE-W.SOURCE.SUFFIX
$(error REMOVE-W.SOURCE.SUFFIX is not defined.)
endif

ifndef REMOVE-W.TARGET.SUFFIX
REMOVE-W.TARGET.SUFFIX:=.fakeTarget
endif

ifndef REMOVE-W.ALIGN.SUFFIX
REMOVE-W.ALIGN.SUFFIX:=.fakeAlign
endif

ifndef REMOVE-W.OUTPUT.SUFFIX
REMOVE-W.OUTPUT.SUFFIX:=.noW
endif

ifndef REMOVE-W.TARGET.SUFFIX
REMOVE-W.TARGET.SUFFIX:=.fakeTarget
endif

ifndef REMOVE-W.ALIGNMENT.SUFFIX
REMOVE-W.ALIGNMENT.SUFFIX:=.fakeAlign
endif

ifndef REMOVE-W.SCRIPT
$(error REMOVE-W.SCRIPT is not defined. \
	Define it to point to a REMOVE-W script)
endif

ifndef REMOVE-W.INPUT.FILES
$(error REMOVE-W.INPUT.FILES is not defined. \
	Define it as a list of file names including file paths)
endif

ifndef REMOVE-W.OUTPUT.DIR
$(error REMOVE-W.OUTPUT.DIR is not defined. \
	Define it to a directory for REMOVE-W results)
endif

ifndef REMOVE-W.JOBS.DIR
$(error REMOVE-W.JOBS.DIR is not defined. \
	Define it to a directory for REMOVE-W job scripts)
endif

ifndef REMOVE-W.LOG.DIR
$(error REMOVE-W.LOG.DIR is not defined. \
	Define it to a directory for REMOVE-W log files)
endif

ifndef REMOVE-W.STATUS.DIR
$(error REMOVE-W.STATUS.DIR is not defined. \
	Define it to a directory for REMOVE-W completion status)
endif

ifndef REMOVE-W.STATUS.SUFFIX
REMOVE-W.STATUS.SUFFIX:=.completed
endif

ifndef REMOVE-W.JOB.SUFFIX
REMOVE-W.JOB.SUFFIX:=.job
endif

ifndef REMOVE-W.LOG.SUFFIX
REMOVE-W.LOG.SUFFIX:=.log
endif


###############################################################################
## Define how to run a REMOVE-W job.                                         ##
###############################################################################

# Check to see if the user has provided a custom definition for running jobs.
#
# This will happen, for example, if jobs should be run 
#     via qsub in a Sun Grid Engine environment.
#
# If the user has already defined this function, don't use the definition below
#
ifndef REMOVE-W.run

# Define REMOVE-W.run as a custom make function capable of running a job.
#
# Argument ${1} is the job script to be run
# Argument ${2} is desired filename for job logging output
define REMOVE-W.run
@${1} &> ${2}
endef

endif


###############################################################################
## Define the results of REMOVE-W all files.                                 ##
###############################################################################

# When REMOVE-W has completed, the following list of output files will exist.
#
REMOVE-W.OUTPUT.FILES:=$(foreach file,$(REMOVE-W.INPUT.FILES),\
         ${REMOVE-W.OUTPUT.DIR}/$(notdir ${file})${REMOVE-W.SUFFIX}.${SRC}${TRAINING.SRC.SUFFIX})

# When REMOVE-W has completed, the following list of files will exist.
#
REMOVE-W.STATUS.FILES:=$(foreach file,${REMOVE-W.INPUT.FILES},\
         ${REMOVE-W.STATUS.DIR}/$(notdir ${file})${REMOVE-W.SUFFIX}.${SRC}${TRAINING.SRC.SUFFIX})


###############################################################################
## Define how to create prerequisite directories for REMOVE-W.               ##
###############################################################################

# Define how to create this directory
#
${REMOVE-W.JOBS.DIR}:
	mkdir -p $@

# Define how to create this directory
#
${REMOVE-W.LOG.DIR}:
	mkdir -p $@

# Define how to create this directory
#
${REMOVE-W.OUTPUT.DIR}:
	mkdir -p $@

# Define how to create this directory
#
${REMOVE-W.STATUS.DIR}:
	mkdir -p $@



###############################################################################
## Define how to remove sentence-initial W- from sentences in Arabic files.  ##
###############################################################################

# Define a single make target to process all input files
#
removeW: ${REMOVE-W.PREREQUISITES} ${REMOVE-W.STATUS.FILES}
	@echo "`date`	All REMOVE-W is complete"


# Define how to process a file, given the following arguments
#
#    ${1} - Base name of file to be processed, without suffix
#    ${2} - Directory containing file to be processed
#
#    ${REMOVE-W.OUTPUT.DIR} - Directory in which to put preprocessed file
#    ${REMOVE-W.STATUS.DIR} - Directory in which to put completion status
#    ${REMOVE-W.JOBS.DIR} - Directory in which to put job scripts
#    ${REMOVE-W.LOG.DIR} - Directory in which to put job log files
#
#    ${REMOVE-W.STATUS.DIR}/${1}${REMOVE-W.STATUS.SUFFIX} will be created 
#         if and when the job has successfully completed.
#
define REMOVE-W

# Create a job script
#
${REMOVE-W.JOBS.DIR}/${1}${REMOVE-W.JOB.SUFFIX}: | ${2} ${REMOVE-W.OUTPUT.DIR} ${REMOVE-W.STATUS.DIR} ${REMOVE-W.JOBS.DIR}
	@echo "`date`	Constructing job script ${REMOVE-W.JOBS.DIR}/${1}${REMOVE-W.JOB.SUFFIX}"
	@echo 'echo "`date`	Remove-W started for ${1}"' > ${REMOVE-W.JOBS.DIR}/${1}${REMOVE-W.JOB.SUFFIX}
	@echo 'ruby -e "STDIN.each_line{|line| puts}" < ${2}${1}${REMOVE-W.SOURCE.SUFFIX} > ${2}${1}${REMOVE-W.TARGET.SUFFIX}' >> ${REMOVE-W.JOBS.DIR}/${1}${REMOVE-W.JOB.SUFFIX}
	@echo 'ruby -e "STDIN.each_line{|line| puts}" < ${2}${1}${REMOVE-W.SOURCE.SUFFIX} > ${2}${1}${REMOVE-W.ALIGN.SUFFIX}'  >> ${REMOVE-W.JOBS.DIR}/${1}${REMOVE-W.JOB.SUFFIX}
	@echo '${REMOVE-W.SCRIPT} --ar ${REMOVE-W.SOURCE.SUFFIX} --en ${REMOVE-W.TARGET.SUFFIX} --align ${REMOVE-W.ALIGN.SUFFIX} --pp ${REMOVE-W.SUFFIX} ${2}${1}' >> ${REMOVE-W.JOBS.DIR}/${1}${REMOVE-W.JOB.SUFFIX}
	@ruby -e 'print "if [ \"#{36.chr}"; print "?\" -eq \"0\" ]; then"; puts'  >> ${REMOVE-W.JOBS.DIR}/${1}${REMOVE-W.JOB.SUFFIX} 
	@echo 'echo "`date`	Moving results from ${2} to ${REMOVE-W.OUTPUT.DIR}"' >> ${REMOVE-W.JOBS.DIR}/${1}${REMOVE-W.JOB.SUFFIX}
	@echo 'cp ${2}${1}${REMOVE-W.SUFFIX}${REMOVE-W.SOURCE.SUFFIX} ${REMOVE-W.OUTPUT.DIR}/${1}${REMOVE-W.SUFFIX}${REMOVE-W.SOURCE.SUFFIX}' >> ${REMOVE-W.JOBS.DIR}/${1}${REMOVE-W.JOB.SUFFIX}
	@echo 'echo "`date`	Removing temporary file ${2}${1}${REMOVE-W.SUFFIX}.${REMOVE-W.SOURCE.SUFFIX}"' >> ${REMOVE-W.JOBS.DIR}/${1}${REMOVE-W.JOB.SUFFIX}
	@echo 'rm ${2}${1}${REMOVE-W.SUFFIX}${REMOVE-W.SOURCE.SUFFIX}' >> ${REMOVE-W.JOBS.DIR}/${1}${REMOVE-W.JOB.SUFFIX}
	@echo 'echo "`date`	Removing temporary file ${2}${1}${REMOVE-W.SUFFIX}${REMOVE-W.TARGET.SUFFIX}"' >> ${REMOVE-W.JOBS.DIR}/${1}${REMOVE-W.JOB.SUFFIX}
	@echo 'rm ${2}${1}${REMOVE-W.SUFFIX}${REMOVE-W.TARGET.SUFFIX}' >> ${REMOVE-W.JOBS.DIR}/${1}${REMOVE-W.JOB.SUFFIX}
	@echo 'echo "`date`	Removing temporary file ${2}${1}${REMOVE-W.SUFFIX}${REMOVE-W.ALIGN.SUFFIX}"'  >> ${REMOVE-W.JOBS.DIR}/${1}${REMOVE-W.JOB.SUFFIX}
	@echo 'rm ${2}${1}${REMOVE-W.SUFFIX}${REMOVE-W.ALIGN.SUFFIX}'  >> ${REMOVE-W.JOBS.DIR}/${1}${REMOVE-W.JOB.SUFFIX}
	@echo 'echo "`date`	Removing temporary file ${2}${1}${REMOVE-W.TARGET.SUFFIX}"' >> ${REMOVE-W.JOBS.DIR}/${1}${REMOVE-W.JOB.SUFFIX}
	@echo 'rm ${2}${1}${REMOVE-W.TARGET.SUFFIX}' >> ${REMOVE-W.JOBS.DIR}/${1}${REMOVE-W.JOB.SUFFIX}
	@echo 'echo "`date`	Removing temporary file ${2}${1}${REMOVE-W.ALIGN.SUFFIX}"'  >> ${REMOVE-W.JOBS.DIR}/${1}${REMOVE-W.JOB.SUFFIX}
	@echo 'rm ${2}${1}${REMOVE-W.ALIGN.SUFFIX}' >> ${REMOVE-W.JOBS.DIR}/${1}${REMOVE-W.JOB.SUFFIX}
	@echo 'echo `date` > ${REMOVE-W.STATUS.DIR}/${1}${REMOVE-W.SUFFIX}.${SRC}${TRAINING.SRC.SUFFIX}' >> ${REMOVE-W.JOBS.DIR}/${1}${REMOVE-W.JOB.SUFFIX}
	@echo 'echo "`date`	Remove-W is complete for ${1}"' >> ${REMOVE-W.JOBS.DIR}/${1}${REMOVE-W.JOB.SUFFIX}
	@echo 'else' >> ${REMOVE-W.JOBS.DIR}/${1}${REMOVE-W.JOB.SUFFIX}
	@echo 'echo "`date`	Preprocessing failed for ${1}"' >> ${REMOVE-W.JOBS.DIR}/${1}${REMOVE-W.JOB.SUFFIX}
	@echo 'exit 1' >> ${REMOVE-W.JOBS.DIR}/${1}${REMOVE-W.JOB.SUFFIX}
	@echo 'fi'  >> ${REMOVE-W.JOBS.DIR}/${1}${REMOVE-W.JOB.SUFFIX}
	@chmod ug+x ${REMOVE-W.JOBS.DIR}/${1}${REMOVE-W.JOB.SUFFIX}	

#${REMOVE-W.OUTPUT.DIR}/${1}


# Run the job script. If successful, this will produce two files:
# 
#    ${REMOVE-W.OUTPUT.DIR}/${1} - The processed file
#
#    ${REMOVE-W.STATUS.DIR}/${1}${REMOVE-W.STATUS.SUFFIX} - 
#                           A file containing the time and date 
#                           that the job successfully completed.
#
${REMOVE-W.OUTPUT.DIR}/${1}${REMOVE-W.SUFFIX}.${SRC}${TRAINING.SRC.SUFFIX} ${REMOVE-W.STATUS.DIR}/${1}${REMOVE-W.SUFFIX}.${SRC}${TRAINING.SRC.SUFFIX}: ${2}${1}.${SRC}${TRAINING.SRC.SUFFIX} ${REMOVE-W.JOBS.DIR}/${1}${REMOVE-W.JOB.SUFFIX} | ${REMOVE-W.OUTPUT.DIR} ${REMOVE-W.STATUS.DIR} ${REMOVE-W.LOG.DIR}
	@echo "`date`	Launching job script ${REMOVE-W.JOBS.DIR}/${1}${REMOVE-W.JOB.SUFFIX}"
	$(call REMOVE-W.run,${REMOVE-W.JOBS.DIR}/${1}${REMOVE-W.JOB.SUFFIX},${REMOVE-W.LOG.DIR}/${1}${REMOVE-W.LOG.SUFFIX})

endef




# For each file in the input files,
#     dynamically construct a new make target (call does this)
#     that knows how to preprocess the input file.
#     Add that new make target to the make file (eval does this).
#
#    $(dir ${file}) is the path to the directory containing ${file}, with the file name stripped off
#    $(notdir ${file}) is the bare file name, with the directory path stripped off
#    See section 8.3 of the GNU Make Manual for more info on built-in functions for file names.
#
#     Using the slashes followed by newlines is simply to increase readability.
#
$(foreach file,\
	$(REMOVE-W.INPUT.FILES),\
	$(eval \
		$(call \
			REMOVE-W,$(notdir ${file}),$(dir ${file}))\
	)\
)




###############################################################################
## Misc book-keeping. See section 4.5 of the GNU Make Manual.                ##
###############################################################################

# The remove-initial-W target does not create an actual file called remove-initial-W
#
.PHONY: remove-initial-W




