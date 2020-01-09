#!/bin/bash

# Define the variables
SCRATCH_ORG_NAME="healthcloud"
SCRATCH_ORG_DEF="config/healthcloud-scratch-def.json"

# Create a scratch org
sfdx force:org:create -f $SCRATCH_ORG_DEF -a $SCRATCH_ORG_NAME

# Use the healthcloud script to create and open an org
./healthcloud init