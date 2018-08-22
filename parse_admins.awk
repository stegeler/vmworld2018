# Parses and acts on an administrator user spec file.
#
# The call flow is as follows:
#
#                     |-- add_user.sh
# parse_admins.awk -> |
#                     |-- del_user.sh
#
# The administrator user spec file # must contain lines of the form:
#
#   Group: <some_group>
#   User: A <some_user> <first_name> <last_name> [password]
#   User: D <some_other_user> <first_name> <last_name> [password]
#
# where Group: or User: represent the first set of characters on a single line.
# The Group sets the current local adminsitrators group to assign users to.
# Users follow and go into the Group or are deleted from Group until the next
# Group line appears, after which users are relative to that new Group.
#
# Passwords are optional, and passed to set by the add_user.sh script. If
# no password is provided, the assumption is add_user.sh generates one for
# the user.
#
# For example:
#   Group: Administrators
#   User: A steve Steve IsClient
#   User: A tom Tom IsMaster
#
BEGIN {
  # Set field separator to commas and whitespace
  FS = ",[ \t]*|[ \t]+"

  # setup global vars for number of added and deleted users
  g_adds = 0
  g_dels = 0
  g_group = "Administrators"

  # debug runs don't do anything other than print what would happen
  if (length(debug) > 0) {
    debug = 1
  } else {
    debug = 0
  }

  # keep track of invalid add/delete command lines
  # an add needs 'A' and delete needs an X as in:
  #   User: A tom
  #   User: D tom
  # any other character than A or D is flagged as an error
  exitcode=0
}

# Match groups and set the new group for use in future adds or deletes
/^Group:/ {
  g_group = $2
  print "Now acting on group: " g_group
}

# Match users and add or delete them, unless this is a debug run, in
# which case just print what would happen in a real run.
/^User:/ {
  if ($2 == "A") {
    cmd = "./add_user.sh" " " g_group " " $3 " " $4 " " $5 " " $6
    if (debug) {
      print "DEBUG: " cmd
    } else {
      system(cmd)
    }
    adds += 1
  } else if ($2 == "D") {
    cmd = "./del_user.sh" " " g_group " " $3 " " $4 " " $5
    if (debug) {
      print "DEBUG: " cmd
    } else {
      system(cmd)
    }
    dels += 1
  } else {
    printf "WARNING: I have no idea what %s means as a user action, so ignoring and moving on.\n", $2
	exitcode += 1
  }
}

# Print how many adds and deletes were asked in the user file.
# If we have any bogus lines, they are counted in exitcode. So
# if exitcode is greater than zero, the run fails.
# Executing the script in debug mode lets static tests take place
# without harming the state of the vCenter.
END {
  printf("Added %d users, deleted %d users.\n", adds, dels)
  if (exitcode > 0) {
    exit(exitcode)
  }
}
