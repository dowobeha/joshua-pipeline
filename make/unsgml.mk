###############################################################################
##                                                                           ##
##                            REMOVE SGML                                    ##
##                                                                           ##
###############################################################################


###############################################################################
## Certain variables must be defined for the functions in this file to work. ##
###############################################################################

ifndef UNSGML.SCRIPT
$(error UNSGML.SCRIPT is not defined. \
	Define it to point to an unsgml script)
endif

ifndef UNSGML.INPUT.SUFFIX
$(error UNSGML.INPUT.SUFFIX is not defined.)
endif

ifndef UNSGML.INPUT.FILES
$(error UNSGML.INPUT.FILES is not defined. \
	Define it as a list of file names including file paths)
endif

ifndef UNSGML.OUTPUT.DIR
$(error UNSGML.OUTPUT.DIR is not defined. \
	Define it to a directory for unsgml results)
endif

ifndef UNSGML.JOBS.DIR
$(error UNSGML.JOBS.DIR is not defined. \
	Define it to a directory for unsgml job scripts)
endif

ifndef UNSGML.LOG.DIR
$(error UNSGML.LOG.DIR is not defined. \
	Define it to a directory for unsgml log files)
endif

ifndef UNSGML.STATUS.DIR
$(error UNSGML.STATUS.DIR is not defined. \
	Define it to a directory for unsgml completion status)
endif

ifndef UNSGML.STATUS.SUFFIX
UNSGML.STATUS.SUFFIX:=.completed
endif

ifndef UNSGML.JOB.SUFFIX
UNSGML.JOB.SUFFIX:=.job
endif

ifndef UNSGML.LOG.SUFFIX
UNSGML.LOG.SUFFIX:=.log
endif

###############################################################################
## Define how to run an unsgml job.                                          ##
###############################################################################

# Check to see if the user has provided a custom definition for running jobs.
#
# This will happen, for example, if jobs should be run 
#     via qsub in a Sun Grid Engine environment.
#
# If the user has already defined this function, don't use the definition below
#
ifndef UNSGML.run

# Define UNSGML.run as a custom make function capable of running a job.
#
# Argument ${1} is the job script to be run
# Argument ${2} is desired filename for job logging output
define UNSGML.run
@${1} &> ${2};
endef

endif


###############################################################################
## Define the results of unsgml-ing all files.                            ##
###############################################################################

# When unsgml has completed, the following list of output files will exist.
#
UNSGML.OUTPUT.FILES:=$(foreach file,$(UNSGML.INPUT.FILES),\
         ${UNSGML.OUTPUT.DIR}/$(subst ${UNSGML.INPUT.SUFFIX},,$(notdir ${file})))

# When unsgml has completed, the following list of files will exist.
#
UNSGML.STATUS.FILES:=$(foreach file,${UNSGML.INPUT.FILES},\
         ${UNSGML.STATUS.DIR}/$(subst ${UNSGML.INPUT.SUFFIX},,$(notdir ${file}))${UNSGML.STATUS.SUFFIX})


###############################################################################
## Define how to create prerequisite directories for unsgml.                 ##
###############################################################################

# Define how to create this directory
#
${UNSGML.JOBS.DIR}:
	mkdir -p $@

# Define how to create this directory
#
${UNSGML.LOG.DIR}:
	mkdir -p $@

# Define how to create this directory
#
${UNSGML.OUTPUT.DIR}:
	mkdir -p $@

# Define how to create this directory
#
${UNSGML.STATUS.DIR}:
	mkdir -p $@


###############################################################################
## Define how to unsgml files.                                               ##
###############################################################################


# Define a single make target to unsgml all input files
#
unsgml: ${UNSGML.STATUS.FILES}
	@echo "`date`	All unsgmling is complete."


# Define how to unsgml a file, given the following arguments
#
#    ${1} - Name of file to be unsgmled
#    ${2} - Directory containing file to be unsgmled
#
#    ${UNSGML.OUTPUT.DIR} - Directory in which to put unsgmled file
#    ${UNSGML.STATUS.DIR} - Directory in which to put completion status
#    ${UNSGML.JOBS.DIR} - Directory in which to put job scripts
#    ${UNSGML.LOG.DIR} - Directory in which to put job log files
#
#    ${UNSGML.STATUS.DIR}/${1}${UNSGML.STATUS.SUFFIX} will be created 
#         if and when the job has successfully completed.
#
define UNSGML

# Create a job script
#
${UNSGML.JOBS.DIR}/${1}${UNSGML.JOB.SUFFIX}: ${2} | ${UNSGML.OUTPUT.DIR} ${UNSGML.STATUS.DIR} ${UNSGML.JOBS.DIR}
	@echo "`date`	Constructing job script ${UNSGML.JOBS.DIR}/${1}${UNSGML.JOB.SUFFIX}"
	@echo 'echo "`date`	Unsgmling started for ${1}"' > ${UNSGML.JOBS.DIR}/${1}${UNSGML.JOB.SUFFIX}
	@echo '${UNSGML.SCRIPT} ${2}/${1}${UNSGML.INPUT.SUFFIX} ${UNSGML.OUTPUT.DIR}/${1}' >> ${UNSGML.JOBS.DIR}/${1}${UNSGML.JOB.SUFFIX}
	@ruby -e 'print "if [ \"#{36.chr}"; print "?\" -eq \"0\" ]; then"; puts'  >> ${UNSGML.JOBS.DIR}/${1}${UNSGML.JOB.SUFFIX} 
	@echo 'echo `date` > ${UNSGML.STATUS.DIR}/${1}${UNSGML.STATUS.SUFFIX}' >> ${UNSGML.JOBS.DIR}/${1}${UNSGML.JOB.SUFFIX}
	@echo 'echo "`date`	Unsgmling is complete for ${1}"' >> ${UNSGML.JOBS.DIR}/${1}${UNSGML.JOB.SUFFIX}
	@echo 'else'  >> ${UNSGML.JOBS.DIR}/${1}${UNSGML.JOB.SUFFIX}
	@echo 'echo "`date`	Unsgmling failed for ${1}"'  >> ${UNSGML.JOBS.DIR}/${1}${UNSGML.JOB.SUFFIX}
	@echo 'exit 1'  >> ${UNSGML.JOBS.DIR}/${1}${UNSGML.JOB.SUFFIX}
	@echo 'fi'  >> ${UNSGML.JOBS.DIR}/${1}${UNSGML.JOB.SUFFIX}
	@chmod ug+x ${UNSGML.JOBS.DIR}/${1}${UNSGML.JOB.SUFFIX}	

# Run the job script. If successful, this will produce two files:
# 
#    ${UNSGML.OUTPUT.DIR}/${1} - The unsgmled file
#
#    ${UNSGML.STATUS.DIR}/${1}${UNSGML.STATUS.SUFFIX} - 
#                           A file containing the time and date 
#                           that the job successfully completed.
#
${UNSGML.OUTPUT.DIR}/${1} ${UNSGML.STATUS.DIR}/${1}${UNSGML.STATUS.SUFFIX}: ${2}/${1}${UNSGML.INPUT.SUFFIX} ${UNSGML.JOBS.DIR}/${1}${UNSGML.JOB.SUFFIX} | ${UNSGML.OUTPUT.DIR} ${UNSGML.STATUS.DIR} ${UNSGML.LOG.DIR}
	@echo "`date`	Launching job script ${UNSGML.JOBS.DIR}/${1}${UNSGML.JOB.SUFFIX}"
	$(call UNSGML.run,${UNSGML.JOBS.DIR}/${1}${UNSGML.JOB.SUFFIX},${UNSGML.LOG.DIR}/${1}${UNSGML.LOG.SUFFIX})
endef


# For each file in the input files,
#     dynamically construct a new make target (call does this)
#     that knows how to unsgml the input file.
#     Add that new make target to the make file (eval does this).
#
#    $(dir ${file}) is the path to the directory containing ${file}, with the file name stripped off
#    $(notdir ${file}) is the bare file name, with the directory path stripped off
#    $(subst ${UNSGML.INPUT.SUFFIX},,$(notdir ${file})) is the bare file name, with the .sgm suffix stripped off
#    See section 8.3 of the GNU Make Manual for more info on built-in functions for file names.
#
#     Using the slashes followed by newlines is simply to increase readability.
#
$(foreach file,\
	$(UNSGML.INPUT.FILES),\
	$(eval \
		$(call \
			UNSGML,$(subst ${UNSGML.INPUT.SUFFIX},,$(notdir ${file})),$(dir ${file}))\
	)\
)





###############################################################################
## Misc book-keeping. See section 4.5 of the GNU Make Manual.                ##
###############################################################################

# The unsgml target does not create an actual file called unsgml
#
.PHONY: unsgml
