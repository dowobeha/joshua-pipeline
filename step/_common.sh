#!/bin/bash

# Define function to log messages with timestamps
function log {
    echo "`date -u +"%Y-%m-%d %H:%M:%S %Z"`		${1}"
}

# Figure out where this script is located 
source `cd ${0%/*} && pwd`/_variables
