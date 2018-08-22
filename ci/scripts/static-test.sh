#!/bin/bash
# Used to test the syntax of the code but will not implement a change

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
mkdir -p ${TOP}/static-test-error-files

# Test the code (-n will just verify syntax)
echo "Checking script syntax."
echo "--- acctctl.sh" >${TOP}/static-test-error-files/test.log 2>&1
bash -n git-stegeler/acctctl.sh >>${TOP}/static-test-error-files/test.log 2>&1
echo "--- add_user.sh" >>${TOP}/static-test-error-files/test.log 2>&1
bash -n git-stegeler/add_user.sh >>${TOP}/static-test-error-files/test.log 2>&1
echo "--- del_user.sh" >>${TOP}/static-test-error-files/test.log 2>&1
bash -n git-stegeler/del_user.sh >>${TOP}/static-test-error-files/test.log 2>&1

# Test the code itself against the user file
echo "Checking administrator user spec file and parsing script." >>${TOP}/static-test-error-files/test.log 2>&1
pushd git-stegeler
./acctctl.sh debug >>${TOP}/static-test-error-files/test.log 2>&1
popd

# Check what's in the output
echo "List out the output directory."
ls -lat ${TOP}/static-test-error-files
echo ""
