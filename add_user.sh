#!/bin/sh
# Add users to local vCenter groups.
# Syntax:
#   add_user.sh <group> <user> [password]
#

# Print usage for the script
usage() {
  echo "$0 <group> <user> [password]"
}

# If the env does not contain our vSphere user and password, die out
if [ -z "${VCSA_ADDRESS}" ]; then
  echo "ERROR: no vcenter appliance address supplied. Aborting."
  exit 1
fi

if [ -z "${VCSA_USER}" ]; then
  echo "ERROR: no vcenter appliance ssh user supplied. Aborting."
  exit 1
fi

if [ -z "${VCSA_PASSWORD}" ]; then
  echo "ERROR: no vcenter appliance ssh user password. Aborting."
  exit 1
fi

if [ -z "${VCENTER_ADMIN_USER}" ]; then
  echo "ERROR: no vsphere admin user supplied. Aborting."
  exit 1
fi

if [ -z "${VCENTER_ADMIN_PASSWORD}" ]; then
  echo "ERROR: no vsphere admin user supplied. Aborting."
  exit 1
fi

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

# add sshpass for calling on vcsa remotely.
# NOTE: ASSUMING golant:1.9.1 docker container image as base.
apt-get update
apt-get install -y sshpass

# Add the user as requested
sshpass -p "${VCSA_PASSWORD}" ssh -o StrictHostKeyChecking=no ${VCSA_USER}@${VCSA_ADDRESS} \
  /usr/lib/vmware-vmafd/bin/dir-cli --login ${VCENTER_ADMIN_USER} --password "${VCENTER_ADMIN_PASSWORD}" group list --name ${group}
