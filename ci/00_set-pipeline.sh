#!/bin/bash

# Used to register the VMworld 2018 Concourse Pipeline

# Note: change the -var values below to match your environment

fly -t vsphereacct \
  -var vcsa_user="root" \
  -var vcsa_password='VMware1!'
  -var vcsa_address='vcsa-01a.corp.local' \
  -var vcenter_admin_user='administrator@vsphere.local' \
  set-pipeline --pipeline acctctl \
  --config pipeline.yml

if [ $? -eq 0 ]; then
	fly -t vsphereacct unpause-pipeline --pipeline acctctl
fi
