#!/bin/bash

# Set environment variables for deployment
# azure
ZR_RESOURCE_LOCATION=eastus
AZR_RESOURCE_GROUP_SOURCE=Demo_Oracle_Migration_Source
AZR_RESOURCE_GROUP_TARGET=Demo_Oracle_Migration_Target

# OpenShift
AZR_CLUSTER=cluster
AZR_PULL_SECRET=~/Downloads/pull-secret.txt

# Oracle Migration Clean up

# Begin execution

# Delete ARO cluster
az aro delete -y \
  --resource-group $AZR_RESOURCE_GROUP_TARGET \
  --name $AZR_CLUSTER

# Delete Source Resource Group
az group delete -y \
  --name $AZR_RESOURCE_GROUP_TARGET

# Delete Target Resource Group
  az group delete -y \
    --name $AZR_RESOURCE_GROUP_SOURCE
