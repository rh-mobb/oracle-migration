#!/bin/bash

# Set environment variables for deployment
# azure
AZR_RESOURCE_LOCATION=eastus
AZR_RESOURCE_GROUP=DemoOracleMigration

# OpenShift
AZR_CLUSTER=cluster
AZR_PULL_SECRET=~/Downloads/pull-secret.txt

# Oracle Migration Clean up

# Begin execution

# Delete ARO cluster
az aro delete -y \
  --resource-group $AZR_RESOURCE_GROUP \
  --name $AZR_CLUSTER

# Delete Resource Group
az group delete -y \
  --name $AZR_RESOURCE_GROUP
