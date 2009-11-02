#!/bin/bash
#
# Wrapper script for reprocess_remove-W.pl

if [ "$#" -ne 2 ]; then
	echo "Usage: ${0} input output"
	exit -1
fi

INPUT="${1}"
OUTPUT="${2}"

filename="${1##*/}"
OUTPUT_DIR="${2%/*}"

# Get the full path to this script, including the filename
FULL_PATH_TO_THIS_SCRIPT=$(cd ${0%/*} && echo ${PWD}/${0##*/})

# Get the full path to this script, without the filename
JUST_PATH_TO_THIS_SCRIPT=`dirname "${FULL_PATH_TO_THIS_SCRIPT}"`

# Get the full path to the remove-w script
REMOVE_W_SCRIPT="${JUST_PATH_TO_THIS_SCRIPT}/reprocess_remove-W.pl"


# Define variables
REMOVE_W_TARGET_SUFFIX=".fakeTarget"
REMOVE_W_ALIGN_SUFFIX=".fakeAlign"
REMOVE_W_SUFFIX=".noW"

# Log that we have started
echo "`date`	Remove-W started for ${INPUT}"


# Create dummy target and alignment files
ruby -e "STDIN.each_line{|line| puts}" < ${1} > ${1}${REMOVE_W_TARGET_SUFFIX}
ruby -e "STDIN.each_line{|line| puts}" < ${1} > ${1}${REMOVE_W_ALIGN_SUFFIX}

# Run reprocess_remove-W.pl
echo "`date`	Running command: ${REMOVE_W_SCRIPT} --ar \"\" --en ${REMOVE_W_TARGET_SUFFIX} --align ${REMOVE_W_ALIGN_SUFFIX} --pp ${REMOVE_W_SUFFIX} ${1}"
${REMOVE_W_SCRIPT} --ar "" --en ${REMOVE_W_TARGET_SUFFIX} --align ${REMOVE_W_ALIGN_SUFFIX} --pp ${REMOVE_W_SUFFIX} ${1}

if [ $? -eq "0" ]; then

	echo "`date`	Removing temporary files" && \
	rm ${1}${REMOVE_W_TARGET_SUFFIX} ${1}${REMOVE_W_ALIGN_SUFFIX} ${1}${REMOVE_W_SUFFIX}${REMOVE_W_TARGET_SUFFIX} ${1}${REMOVE_W_SUFFIX}${REMOVE_W_ALIGN_SUFFIX} && \

	echo "`date`	Ensuring that target directory ${OUTPUT_DIR} exists." && \
	mkdir -p ${OUTPUT_DIR} && \

	echo "`date`	Copying result file ${1}${REMOVE_W_SUFFIX} to ${2}" && \
	cp ${1}${REMOVE_W_SUFFIX} ${2}  && \
	
	echo "`date`	Removing temporary file ${1}${REMOVE_W_SUFFIX}" && \
	rm ${1}${REMOVE_W_SUFFIX} && \
	
	echo "`date`	Remove-W complete for ${1}"

else

	echo "`date`	Command ${REMOVE_W_SCRIPT} failed."
	exit 1

fi
