#!/bin/sh
# Add users to local vCenter groups.
# Syntax:
#   add_user.sh <group> <user> <first_name> <last_name> [password]
#

# this sets the script to to print out every command executed
# for ease of watching it run.
set -x

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
if [ $# -lt 4 ]; then
  echo "ERROR: insufficient arguments"
  usage
  exit 1
fi

# gather required parameters into 'human readable' variables
group="$1"
user="$2"
first_name="$3"
last_name="$4"

# get the password if it exists.
if [ -n "${5}" ]; then
  password="${5}"
else
  # for now, just use a default password since none provided.
  password="password_${user}"
fi

# Add the user as requested
#sshpass -p "${VCSA_PASSWORD}" ssh -o StrictHostKeyChecking=no ${VCSA_USER}@${VCSA_ADDRESS} \
#  /usr/lib/vmware-vmafd/bin/dir-cli group list \
#  --login ${VCENTER_ADMIN_USER} --password "${VCENTER_ADMIN_PASSWORD}" \
#  --name "${group}"
sshpass -p "${VCSA_PASSWORD}" ssh -o StrictHostKeyChecking=no ${VCSA_USER}@${VCSA_ADDRESS} \
  /usr/lib/vmware-vmafd/bin/dir-cli user find-by-name \
  --login ${VCENTER_ADMIN_USER} --password "${VCENTER_ADMIN_PASSWORD}" \
  --account ${user}
if [ $? -ne 0 ]; then
  sshpass -p "${VCSA_PASSWORD}" ssh -o StrictHostKeyChecking=no ${VCSA_USER}@${VCSA_ADDRESS} \
    /usr/lib/vmware-vmafd/bin/dir-cli user create \
    --login ${VCENTER_ADMIN_USER} --password "${VCENTER_ADMIN_PASSWORD}" \
    --account ${user} --user-password "${password}" \
    --first-name ${first_name} --last-name ${last_name}
  sshpass -p "${VCSA_PASSWORD}" ssh -o StrictHostKeyChecking=no ${VCSA_USER}@${VCSA_ADDRESS} \
    /usr/lib/vmware-vmafd/bin/dir-cli group modify \
    --login ${VCENTER_ADMIN_USER} --password "${VCENTER_ADMIN_PASSWORD}" \
    --name ${group} --add ${user}
else
  echo "WARN: User ${user} already exists, not adding."
fi
