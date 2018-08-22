#!/bin/sh

# The call flow is this:
#
#                                   |-- add_user.sh
# acctctl.sh -> parse_admins.awk -> |
#                                   |-- del_user.sh
#
# the adminusers.txt file must contain lines of the form:
#
#   Group: <some_group>
#   User: A <some_user>
#   User: D <some_other_user>
#
# where Group: or User: represent the first set of characters on a single line.
# The Group sets the current local adminsitrators group to assign users to.
# Users follow and go into the Group or are deleted from Group until the next
# Group line appears, after which users are relative to that new Group.
# Passwords are always set to 'password_<username>' for now. under normal
# circumstances, the password would be generated and placed in a store such as
# Vault or the like.
#
# For example:
#   Group: Administrators
#   User: A steve
#   User: A tom
#
#   Group: MoreAdmins
#   User: A john
#   User: A dan
#  
#  

# add sshpass for calling on vcsa remotely.
# NOTE: ASSUMING golant:1.9.1 docker container image as base.
apt-get update
apt-get install -y sshpass

# Parse out the administrator user file and issue add or delete commands per user
# Note, the add will fail if the user already exists, which is concidered fine
# for this demo.

if [ "${1}x" = "debugx" ]; then
  awk -v debug=true -f parse_admins.awk adminusers.txt
else
  awk -f parse_admins.awk adminusers.txt
fi

exit
