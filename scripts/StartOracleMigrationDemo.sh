#!/bin/bash

# Set environment variables for deployment
# TODO: Adjust these to avoid overlap between ARO cluster and Oracle Source
# azure
AZR_RESOURCE_LOCATION=eastus
AZR_RESOURCE_GROUP=DemoOracleMigration

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
# The static DNS name causes some challenges, ran into a collision already. Is this something
# we can retrieve instead of set? It returns JSON eventually so probably.

az vm create \
    --resource-group $AZR_RESOURCE_GROUP \
    --name vmoracle19c \
    --image Oracle:oracle-database-19-3:oracle-database-19-0904:latest \
    --size Standard_DS2_v2 \
    --admin-username azureuser \
    --generate-ssh-keys \
    --public-ip-address-allocation static \
    --public-ip-sku Standard \
    --public-ip-address-dns-name vmoracle19c

# Create and attach a new disk for Oracle Datafiles
az vm disk attach \
    --name oradata01 \
    --new \
    --resource-group $AZR_RESOURCE_GROUP \
    --size-gb 64 \
    --sku StandardSSD_LRS \
    --vm-name vmoracle19c

# Open ports for connectivity
az network nsg rule create \
    --resource-group $AZR_RESOURCE_GROUP \
    --nsg-name vmoracle19cNSG \
    --name allow-oracle \
    --protocol tcp \
    --priority 1001 \
    --destination-port-range 1521

# Install MedRecDDL onto Oracle Database VM

# Deploy Weblogic VM

# Deploy MedRec Application

# Create an Instance of Azure Database Migration Service -

# Install ora2pgsql and configure ora2pg.conf
wget https://github.com/darold/ora2pg/releases/tag/v22.1
tar -xvzf v20.0.tar.gz
cd ora2pg-20.0
perl Makefile.PL
make
sudo make install

# Test configure 

# Launch ora2pgsql and run amigration difficulty analysis - don't forget DUMP_AS_HTML
# Here is a sample.... https://ora2pg.darold.net/report.html

# Export full database

# Create ARO Cluster - Hold for Later

# Deploy Azure SQL
az group create --name $AZR_RESOURCE_GROUP --location $westus
