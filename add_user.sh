#!/bin/sh
# Add users to local vCenter groups.
# Syntax:
#   add_user.sh <group> <user> [password]
#

# Print usage for the script
usage() {
  echo "$0 <group> <user> [password]"
}

# If there is not a group and user on the command line, die out.
if [ $# -lt 2 ]; then
	echo "ERROR: insufficient arguments"
	usage
	exit 1
fi

# gather required parameters into 'human readable' variables
group="$1"
user="$2"

# get the password if it exists.
if [ -n "${3}" ]; then
  password="${3}"
else
  # for now, just use a default password since none provided.
  password="password_${user}"
fi

# Add the user as requested
echo "add user ${user} to group ${group} with password \"${password}\"."
