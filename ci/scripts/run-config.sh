#!/bin/bash
# run the configuration change

# this sets the script to die immediately on any error (-e) and
# to print out every command executed for ease of watching it run.
set -e -x

# Save current directory
TOP="$(pwd)"

# The code is located in git-steve
echo "Starting directory contents:"
ls -lat
echo ""

# Make the output area if it does not exist
mkdir -p ${TOP}/config-test-error-files

# Test the code
bash git-stegeler/acctctl.sh >${TOP}/config-test-error-files/run.log 2>&1

# Check whats here
echo "List out the output directory"
ls -lat ${TOP}/config-test-error-files/run.log
echo ""
