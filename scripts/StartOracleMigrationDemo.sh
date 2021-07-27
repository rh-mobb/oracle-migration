#!/bin/bash

# Set environment variables for deployment
# TODO: Adjust these to avoid overlap between ARO cluster and Oracle Source
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
az group create --name $AZR_RESOURCE_GROUP_SOURCE --location $AZR_RESOURCE_LOCATION

# Setup Legacy Environment of MedRec application
# Create Oracle Database VM
# The static DNS name causes some challenges, ran into a collision already. Is this something
# we can retrieve instead of set? It returns JSON eventually so probably.

echo "Create OracleVM named vmoracle19c"
az vm create \
    --resource-group $AZR_RESOURCE_GROUP_SOURCE \
    --name vmoracle19c \
    --image Oracle:oracle-database-19-3:oracle-database-19-0904:latest \
    --size Standard_DS2_v2 \
    --admin-username azureuser \
    --generate-ssh-keys \
    --public-ip-address-allocation static \
    --public-ip-sku Standard \
    --public-ip-address-dns-name vmoracle19c

# Create and attach a new disk for Oracle Datafiles
echo "Create and attach a new disk for Oracle Datafiles"
az vm disk attach \
    --name oradata01 \
    --new \
    --resource-group $AZR_RESOURCE_GROUP_SOURCE \
    --size-gb 64 \
    --sku StandardSSD_LRS \
    --vm-name vmoracle19c

# Open ports for connectivity
echo "Open ports for connectivity"
az network nsg rule create \
    --resource-group $AZR_RESOURCE_GROUP_SOURCE \
    --nsg-name vmoracle19cNSG \
    --name allow-oracle \
    --protocol tcp \
    --priority 1001 \
    --destination-port-range 1521

# Install MedRecDDL onto Oracle Database VM
echo "Install MedRecDDL onto Oracle Database VM"

# Deploy Weblogic VM
echo "Deploy Weblogic VM"

# Deploy MedRec Application
echo "Deply MedRec Application"

# Install ora2pgsql and configure ora2pg.conf
echo "Install ora2pgsql and configure ora2pg.conf"
az vm run-command invoke -g $AZR_RESOURCE_GROUP_SOURCE -n vmoracle19c --command-id RunShellScript --scripts "wget https://github.com/darold/ora2pg/releases/tag/v22.1"
az vm run-command invoke -g $AZR_RESOURCE_GROUP_SOURCE -n vmoracle19c --command-id RunShellScript --scripts "tar -xvzf v20.0.tar.gz"
az vm run-command invoke -g $AZR_RESOURCE_GROUP_SOURCE -n vmoracle19c --command-id RunShellScript --scripts "cd ora2pg-22.1"
az vm run-command invoke -g $AZR_RESOURCE_GROUP_SOURCE -n vmoracle19c --command-id RunShellScript --scripts "perl Makefile.PL"
az vm run-command invoke -g $AZR_RESOURCE_GROUP_SOURCE -n vmoracle19c --command-id RunShellScript --scripts "make"
az vm run-command invoke -g $AZR_RESOURCE_GROUP_SOURCE -n vmoracle19c --command-id RunShellScript --scripts "sudo make install"

# Test configure

# Launch ora2pgsql and run amigration difficulty analysis - don't forget DUMP_AS_HTML
# Here is a sample.... https://ora2pg.darold.net/report.html

# Export full database

# Create an Instance of Azure Database Migration Service -

# Create ARO Cluster - Hold for Later

# Load Konveyor Operators

# Deploy Azure SQL
az group create --name $AZR_RESOURCE_GROUP_TARGET --location $AZR_RESOURCE_LOCATION
