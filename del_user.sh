#!/bin/sh
# Deletes users from local vCenter groups.
# Syntax:
#   del_user.sh <group> <user>
#

# this sets the script to to print out every command executed
# for ease of watching it run.
set -x

# Print usage for the script
usage() {
  echo "$0 <group> <user>"
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

# Delete the user as requested
sshpass -p "${VCSA_PASSWORD}" ssh -o StrictHostKeyChecking=no ${VCSA_USER}@${VCSA_ADDRESS} \
  /usr/lib/vmware-vmafd/bin/dir-cli user find-by-name \
  --login ${VCENTER_ADMIN_USER} --password "${VCENTER_ADMIN_PASSWORD}" \
  --account ${user}
if [ $? -eq 0 ]; then
  sshpass -p "${VCSA_PASSWORD}" ssh -o StrictHostKeyChecking=no ${VCSA_USER}@${VCSA_ADDRESS} \
    /usr/lib/vmware-vmafd/bin/dir-cli user delete \
    --login ${VCENTER_ADMIN_USER} --password "${VCENTER_ADMIN_PASSWORD}" \
    --account ${user}
else
  echo "WARN: User ${user} not found, so cannot delete."
fi
