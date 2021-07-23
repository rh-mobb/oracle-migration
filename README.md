# oracle-migration
Demo for oracle migration to OpenShift

References for building demo.

- [Medrec Sample App](https://github.com/vijaykumaryenne/medrec-sampleui-app)
- [Migrating Oracle to AzureSQL and PostgreSQL](https://github.com/Microsoft/MCW-Migrating-Oracle-to-Azure-SQL-and-PostgreSQL)

## Related References
- [Oracle to Azure Database for PostgreSQL Migration Cookbook](https://github.com/Microsoft/DataMigrationTeam/blob/master/Whitepapers/Oracle%20to%20Azure%20PostgreSQL%20Migration%20Cookbook.pdf)
- [Microsoft Cloud Workshops - Migrating Oracle to Azure SQL and PostgreSQL](https://github.com/microsoft/MCW-Migrating-Oracle-to-Azure-SQL-and-PostgreSQL/blob/master/Hands-on%20lab/Before%20the%20HOL%20-%20Migrating%20Oracle%20to%20Azure%20SQL%20and%20PostgreSQL.md)
Based on

## Target Audience
- Application Developer
- SQL Developer
- Database Administrator

## Azure services and related products
- OpenShift on AzureSQL
- Azure Database for PostgreSQL
- Azure Database Migration Service
- ora2pg
- Oracle

A Quickstart guide to migrating an Oracle Application to ARO.  This project provides working code for a demonstration using the MedRec application.

Working code for an Oracle Migration onto OpenShift.  This leverages [ora2pgsql](https://ora2pg.darold.net/)

Author: [Bryan Coapstick](https://twitter.com/bcoapstick), Aaron Aldrich

## Prerequisites

- Microsoft Azure subscription must be pay-as-you-go or MSDN
- Azure CLI [Installation Instructions](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)

## ARO Quickstart

A Quickstart guide to deploying an Azure RedHat OpenShift cluster.  I copied it in for ease, but you can access the latest [here](https://mobb.ninja/docs/quickstart-aro.html) developed by [Paul Czarkowski](https://twitter.com/pczarkowski)

## Video Walkthrough

TODO

## Begin Setting up a Target ARO Cluster

1. Setup an ARO cluster and login. For more information on setting up and configuring accounts for ARO, see the [ARO Quickstart Guide](https://mobb.ninja/docs/quickstart-aro.html). This setup takes some time to complete. While waiting for the `az aro create` command to complete, you can continue setting up hte Legacy App environment.

## Setup the Source Oracle Environment

1.  Set the following environment variables

 > **NOTE**: if needed, change these values to suit your environment, but the defaults should be OK. TODO: Update as needed

  ```bash
  AZR_RESOURCE_LOCATION=eastus
  AZR_ORACLE_RG=DemoOracleSource
  ORACLE_VM_NAME=vmoracle19c
  ```

1. Create an Azure Resource Group for the Oracle Environement. 

  > **NOTE:** You do not have to run `az login` if still logged in from setting up the ARO cluster

  ```bash
  az login
  az group create --name $AZR_ORACLE_RG --location $AZR_RESOURCE_LOCATION
  ```

1. Create the Oracle Database VM

  > **Warning** The public DNS name needs to be unique and will need to be changed from the sample command. 
  > **TODO**: Find a workaround for this

  ```bash
  az vm create \
    --resource-group $AZR_RESOURCE_GROUP \
    --name $ORACLE_VM_NAME \
    --image Oracle:oracle-database-19-3:oracle-database-19-0904:latest \
    --size Standard_DS2_v2 \
    --admin-username azureuser \
    --generate-ssh-keys \
    --public-ip-address-allocation static \
    --public-ip-sku Standard \
    --public-ip-address-dns-name vmoracle19c
  ```

1. Create and attach a new disk for Oracle Datafiles

  ```bash
  az vm disk attach \
    --name oradata01 \
    --new \
    --resource-group $AZR_RESOURCE_GROUP \
    --size-gb 64 \
    --sku StandardSSD_LRS \
    --vm-name vmoracle19c
  ```

1. Open ports for connectivity

  ```bash
  az network nsg rule create \
    --resource-group $AZR_RESOURCE_GROUP \
    --nsg-name vmoracle19cNSG \
    --name allow-oracle \
    --protocol tcp \
    --priority 1001 \
    --destination-port-range 1521
  ```

## Addendum

### Adding Quota to ARO account

![aro quota support ticket request example](./images/aro-quota.png)

1. [Create an Azure Support Request](https://portal.azure.com/#blade/Microsoft_Azure_Support/HelpAndSupportBlade/newsupportrequest)

1. Set **Issue Type** to "Service and subscription limits (quotas)"

1. Set **Quota Type** to "Compute-VM (cores-vCPUs) subscription limit increases"

1. Click **Next Solutions >>**

1. Click **Enter details**

1. Set **Deployment Model** to "Resource Manager

1. Set **Locations** to "(US) East US"

1. Set **Types** to "Standard"

1. Under **Standard** check "DSv3" and "DSv4"

1. Set **New vCPU Limit** for each (example "60")

1. Click **Save and continue**

1. Click **Review + create >>**

1. Wait until quota is increased.
