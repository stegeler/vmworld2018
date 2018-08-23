#!/bin/bash

# Used to register the VMworld 2018 Concourse Pipeline

# Note: change the -var values below to match your environment

fly -t vsphereacct \
  set-pipeline --pipeline acctctl \
  --config pipeline.yml \
  --var 'vcsa_address=vcsa-01a.corp.local' \
  --var 'vcsa_user=root' \
  --var 'vcsa_password=VMware1!' \
  --var 'vcenter_admin_user=administrator@vsphere.local' \
  --var 'vcenter_admin_password=VMware1!' \
  --var 'debug_mode=true'

if [ $? -eq 0 ]; then
	fly -t vsphereacct unpause-pipeline --pipeline acctctl
fi
