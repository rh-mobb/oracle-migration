#!/bin/bash

# Set environment variables for deployment
# azure
AZR_RESOURCE_LOCATION=eastus
AZR_RESOURCE_GROUP_SOURCE=Demo_Oracle_Migration_Source
AZR_RESOURCE_GROUP_TARGET=Demo_Oracle_Migration_Target


# OpenShift
AZR_CLUSTER=cluster
AZR_PULL_SECRET=~/Downloads/pull-secret.txt

# OracleMigration

# Begin execution
# Create a resource group.
az login
az group create --name $AZR_RESOURCE_GROUP --location $AZR_RESOURCE_LOCATION

# Setup Legacy Environment of MedRec application
# Create Oracle Database VM
az vm create ^
    --resource-group $AZR_RESOURCE_GROUP ^
    --name vmoracle19c ^
    --image Oracle:oracle-database-19-3:oracle-database-19-0904:latest ^
    --size Standard_DS2_v2 ^
    --admin-username azureuser ^
    --generate-ssh-keys ^
    --public-ip-address-allocation static ^
    --public-ip-address-dns-name vmoracle19c

# Create and attach a new disk for Oracle Datafiles
az vm disk attach --name oradata01 --new --resource-group $AZR_RESOURCE_GROUP --size-gb 64 --sku StandardSSD_LRS --vm-name vmoracle19c

# Open ports for connectivity
az network nsg rule create ^
    --resource-group $AZR_RESOURCE_GROUP ^
    --nsg-name vmoracle19cNSG ^
    --name allow-oracle ^
    --protocol tcp ^
    --priority 1001 ^
    --destination-port-range 1521

#Get IP address
$AZR_DB_Source_IP = az network public-ip show ^
    --resource-group rg-oracle ^
    --name vmoracle19cPublicIP ^
    --query [ipAddress] ^

# Add DNS record

# Connect to Database
ssh azureuser@<publicIpAddress>

# Install MedRecDDL onto Oracle Database VM

# Create WebLogic VM

# Deploy MedRec

# Deploy MedRec Application

# Create an Instance of Azure Database Migration Service - HOLD FOR LATER

# Launch ora2pgsql and run analysis

# Create ARO Cluster - HOLD FOR LATER

# Launch Konveyor Operators (konveyor.io)

# Deploy Azure SQL
az group create --name $AZR_RESOURCE_GROUP1 --location $AZR_RESOURCE_LOCATION
