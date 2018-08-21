#!/bin/bash
# steves static.sh

set -e -x

# Save current directory
TOP="$(pwd)"

# The code is located in git-steve
echo "Starting directory contents:"
ls -lat
echo ""

# Make the output area if it does not exist
mkdir -p ${TOP}/static-error-files

# Test the code
bash git-steve/acctctl.sh >${TOP}/static-error-files/run.log 2>&1

# Check whats here
echo "List out the output directory"
ls -lat ${TOP}/static-error-files/run.log
echo ""
