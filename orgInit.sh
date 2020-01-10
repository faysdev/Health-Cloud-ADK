#!/bin/bash

#
# Constants
#
# HEADLINE='\033[90m=== \033[34m' # Blue
# INFO='\033[90m' # Grey
# WARNING='\033[1;33m' # Yellow
# END='\033[0m' # No Color

#
# Determine global variables
# NOTE: "IF/THEN" statements do not work with heroku deployer, so instead comment/uncomment the correct section below
# NOTE: Variables do not work with heroku deployer, so instead do manual substitions to reflect the appropriate values
#
# PRERELEASE=true
# printf "${HEADLINE}Preparing to configure a Pre-release Scratch Org${END}\n"
# SCRATCH_ORG_NAME="healthcloud-prerelease"
# SCRATCH_ORG_DEF="config/healthcloud-prerelease-scratch-def.json"
# HEALTHCLOUD_PACKAGE="HealthCloud@224"
# printf "${WARNING}Health Cloud Pre-Release Not Available${END}\n"

# PRERELEASE=false
# printf "${HEADLINE}Preparing to configure the latest released Scratch Org version${END}\n"
# SCRATCH_ORG_NAME="healthcloud"
# SCRATCH_ORG_DEF="config/healthcloud-scratch-def.json"
# HEALTHCLOUD_PACKAGE="HealthCloud@222"

#
# Create Health Cloud Scratch Org
#
#printf "${HEADLINE}Creating Health Cloud Scratch Org${END}\n"
sfdx force:org:create -f config/healthcloud-prerelease-scratch-def.json -a healthcloud-prerelease

#
# Install Health Cloud
#
#printf "${HEADLINE}Installing Health Cloud${END}\n"
sfdx force:package:install -u healthcloud-prerelease --package HealthCloud@224 -w 50
sfdx force:package:install -u healthcloud-prerelease --package HealthCloud-UnmanagedExtension -w 30

#
# Push Default Configuration
#
#printf "${HEADLINE}Pushing Configuration${END}\n"
sfdx force:source:push -u healthcloud-prerelease

#
# Configure Admin User
#
#printf "${HEADLINE}Configuring Admin User${END}\n"
sfdx force:user:permset:assign -u healthcloud-prerelease -n HealthCloudPermissionSetLicense
sfdx force:user:permset:assign -u healthcloud-prerelease -n HealthCloudAdmin
sfdx force:user:permset:assign -u healthcloud-prerelease -n HealthCloudApi
sfdx force:user:permset:assign -u healthcloud-prerelease -n HealthCloudFoundation
sfdx force:user:permset:assign -u healthcloud-prerelease -n HealthCloudLimited
sfdx force:user:permset:assign -u healthcloud-prerelease -n HealthCloudMemberServices
sfdx force:user:permset:assign -u healthcloud-prerelease -n HealthCloudSocialDeterminants
sfdx force:user:permset:assign -u healthcloud-prerelease -n HealthCloudStandard
sfdx force:user:permset:assign -u healthcloud-prerelease -n HealthCloudUtilizationManagement
sfdx force:apex:execute -u healthcloud-prerelease -f demo/scripts/enable-person-account-record-type.apex
sfdx force:apex:execute -u healthcloud-prerelease -f demo/scripts/reset-user-password.apex

#
# Prepare the org for demo and development
#
#printf "${HEADLINE}Preparing Org${END}\n"
sfdx force:data:bulk:upsert -s Account -f ./demo/data/PersonAccounts.csv -i Id -u healthcloud-prerelease
sfdx force:apex:execute -u healthcloud-prerelease -f demo/scripts/assign-record-types.apex

#
# Open Health Cloud Scratch Org
#
#printf "${HEADLINE}Opening Health Cloud Scratch Org${END}\n"
sfdx force:org:open -u healthcloud-prerelease -p /one/one.app