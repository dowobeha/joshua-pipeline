###############################################################################
##                                                                           ##
##                          PREPROCESSING                                    ##
##                                                                           ##
###############################################################################


###############################################################################
## Certain variables must be defined for the functions in this file to work. ##
###############################################################################


ifndef PREPROCESS.SCRIPT
$(error PREPROCESS.SCRIPT is not defined. \
	Define it to point to a preprocessing script)
endif

ifndef PREPROCESS.INPUT.FILES
$(error PREPROCESS.INPUT.FILES is not defined. \
	Define it as a list of file names including file paths)
endif

ifndef PREPROCESS.OUTPUT.DIR
$(error PREPROCESS.OUTPUT.DIR is not defined. \
	Define it to a directory for preprocessing results)
endif

ifndef PREPROCESS.JOBS.DIR
$(error PREPROCESS.JOBS.DIR is not defined. \
	Define it to a directory for preprocessing job scripts)
endif

ifndef PREPROCESS.LOG.DIR
$(error PREPROCESS.LOG.DIR is not defined. \
	Define it to a directory for preprocessing log files)
endif

ifndef PREPROCESS.STATUS.DIR
$(error PREPROCESS.STATUS.DIR is not defined. \
	Define it to a directory for preprocessing completion status)
endif

ifndef PREPROCESS.STATUS.SUFFIX
PREPROCESS.STATUS.SUFFIX:=.completed
endif

ifndef PREPROCESS.JOB.SUFFIX
PREPROCESS.JOB.SUFFIX:=.job
endif

ifndef PREPROCESS.LOG.SUFFIX
PREPROCESS.LOG.SUFFIX:=.log
endif

###############################################################################
## Define how to run a preprocessing job.                                    ##
###############################################################################

# Check to see if the user has provided a custom definition for running jobs.
#
# This will happen, for example, if jobs should be run 
#     via qsub in a Sun Grid Engine environment.
#
# If the user has already defined this function, don't use the definition below
#
ifndef PREPROCESS.run

# Define PREPROCESS.run as a custom make function capable of running a job.
#
# Argument ${1} is the job script to be run
# Argument ${2} is desired filename for job logging output
define PREPROCESS.run
@${1} &> ${2};
endef

endif


###############################################################################
## Define the results of preprocessing all files.                            ##
###############################################################################

# When preprocessing has completed, the following list of output files will exist.
#
PREPROCESS.OUTPUT.FILES:=$(foreach file,$(PREPROCESS.INPUT.FILES),\
         ${PREPROCESS.OUTPUT.DIR}/$(notdir ${file}))

# When preprocessing has completed, the following list of files will exist.
#
PREPROCESS.STATUS.FILES:=$(foreach file,${PREPROCESS.INPUT.FILES},\
         ${PREPROCESS.STATUS.DIR}/$(notdir ${file})${PREPROCESS.STATUS.SUFFIX})


###############################################################################
## Define how to create prerequisite directories for preprocessing.          ##
###############################################################################

# Define how to create this directory
#
${PREPROCESS.JOBS.DIR}:
	mkdir -p $@

# Define how to create this directory
#
${PREPROCESS.LOG.DIR}:
	mkdir -p $@

# Define how to create this directory
#
${PREPROCESS.OUTPUT.DIR}:
	mkdir -p $@

# Define how to create this directory
#
${PREPROCESS.STATUS.DIR}:
	mkdir -p $@



###############################################################################
## Define how to preprocess files.                                           ##
###############################################################################


# Define a single make target to preprocess all input files
#
preprocess: ${PREPROCESS.STATUS.FILES}
	@echo "`date`	All preprocessing is complete."


# Define how to preprocess a file, given the following arguments
#
#    ${1} - Name of file to be preprocessed
#    ${2} - Directory containing file to be preprocessed
#
#    ${PREPROCESS.OUTPUT.DIR} - Directory in which to put preprocessed file
#    ${PREPROCESS.STATUS.DIR} - Directory in which to put completion status
#    ${PREPROCESS.JOBS.DIR} - Directory in which to put job scripts
#    ${PREPROCESS.LOG.DIR} - Directory in which to put job log files
#
#    ${PREPROCESS.STATUS.DIR}/${1}${PREPROCESS.STATUS.SUFFIX} will be created 
#         if and when the job has successfully completed.
#
define PREPROCESS

# Create a job script
#
${PREPROCESS.JOBS.DIR}/${1}${PREPROCESS.JOB.SUFFIX}: ${2} | ${PREPROCESS.OUTPUT.DIR} ${PREPROCESS.STATUS.DIR} ${PREPROCESS.JOBS.DIR}
	@echo "`date`	Constructing job script ${PREPROCESS.JOBS.DIR}/${1}${PREPROCESS.JOB.SUFFIX}"
	@echo 'echo "`date`	Preprocessing started for ${1}"' > ${PREPROCESS.JOBS.DIR}/${1}${PREPROCESS.JOB.SUFFIX}
	@echo '${PREPROCESS.SCRIPT} ${2}/${1} ${PREPROCESS.OUTPUT.DIR}/${1}' >> ${PREPROCESS.JOBS.DIR}/${1}${PREPROCESS.JOB.SUFFIX}
	@ruby -e 'print "if [ \"#{36.chr}"; print "?\" -eq \"0\" ]; then"; puts'  >> ${PREPROCESS.JOBS.DIR}/${1}${PREPROCESS.JOB.SUFFIX} 
	@echo 'echo `date` > ${PREPROCESS.STATUS.DIR}/${1}${PREPROCESS.STATUS.SUFFIX}' >> ${PREPROCESS.JOBS.DIR}/${1}${PREPROCESS.JOB.SUFFIX}
	@echo 'echo "`date`	Preprocessing is complete for ${1}"' >> ${PREPROCESS.JOBS.DIR}/${1}${PREPROCESS.JOB.SUFFIX}
	@echo 'else'  >> ${PREPROCESS.JOBS.DIR}/${1}${PREPROCESS.JOB.SUFFIX}
	@echo 'echo "`date`	Preprocessing failed for ${1}"'  >> ${PREPROCESS.JOBS.DIR}/${1}${PREPROCESS.JOB.SUFFIX}
	@echo 'exit 1'  >> ${PREPROCESS.JOBS.DIR}/${1}${PREPROCESS.JOB.SUFFIX}
	@echo 'fi'  >> ${PREPROCESS.JOBS.DIR}/${1}${PREPROCESS.JOB.SUFFIX}
	@chmod ug+x ${PREPROCESS.JOBS.DIR}/${1}${PREPROCESS.JOB.SUFFIX}	

# Run the job script. If successful, this will produce two files:
# 
#    ${PREPROCESS.OUTPUT.DIR}/${1} - The preprocessed file
#
#    ${PREPROCESS.STATUS.DIR}/${1}${PREPROCESS.STATUS.SUFFIX} - 
#                           A file containing the time and date 
#                           that the job successfully completed.
#
${PREPROCESS.OUTPUT.DIR}/${1} ${PREPROCESS.STATUS.DIR}/${1}${PREPROCESS.STATUS.SUFFIX}: ${2}/${1} ${PREPROCESS.JOBS.DIR}/${1}${PREPROCESS.JOB.SUFFIX} | ${PREPROCESS.OUTPUT.DIR} ${PREPROCESS.STATUS.DIR} ${PREPROCESS.LOG.DIR}
	@echo "`date`	Launching job script ${PREPROCESS.JOBS.DIR}/${1}${PREPROCESS.JOB.SUFFIX}"
	$(call PREPROCESS.run,${PREPROCESS.JOBS.DIR}/${1}${PREPROCESS.JOB.SUFFIX},${PREPROCESS.LOG.DIR}/${1}${PREPROCESS.LOG.SUFFIX})
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
	$(PREPROCESS.INPUT.FILES),\
	$(eval \
		$(call \
			PREPROCESS,$(notdir ${file}),$(dir ${file}))\
	)\
)





###############################################################################
## Misc book-keeping. See section 4.5 of the GNU Make Manual.                ##
###############################################################################

# The preprocess target does not create an actual file called preprocess
#
.PHONY: preprocess
