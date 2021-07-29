# oracle-migration
Demo for oracle migration to OpenShift

References for building demo.

- [Medrec Sample App](https://github.com/vijaykumaryenne/medrec-sampleui-app)
- [Migrating Oracle to AzureSQL and PostgreSQL](https://github.com/Microsoft/MCW-Migrating-Oracle-to-Azure-SQL-and-PostgreSQL)
- [Create an Oracle database in an Azure VM](https://docs.microsoft.com/en-us/azure/virtual-machines/workloads/oracle/oracle-database-quick-create)

## Related References
- [Oracle to Azure Database for PostgreSQL Migration Cookbook](https://github.com/Microsoft/DataMigrationTeam/blob/master/Whitepapers/Oracle%20to%20Azure%20PostgreSQL%20Migration%20Cookbook.pdf)
- [Microsoft Cloud Workshops - Migrating Oracle to Azure SQL and PostgreSQL](https://github.com/microsoft/MCW-Migrating-Oracle-to-Azure-SQL-and-PostgreSQL/blob/master/Hands-on%20lab/Before%20the%20HOL%20-%20Migrating%20Oracle%20to%20Azure%20SQL%20and%20PostgreSQL.md)

## Target Audience
- Application Developer
- SQL Developer
- Database Administrator

## Azure services and related products
- [OpenShift on Azure (ARO)](https://azure.microsoft.com/en-us/pricing/details/openshift/#overview)
- [Azure Database for PostgreSQL](https://azure.microsoft.com/en-us/services/postgresql/#overview)
- Azure Database Migration Service *Coming Later*

## Other products/services leveraged
- [Konveyor](https://konveyor.io)
- [ora2pgsql](https://ora2pg.darold.net/)

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
        --resource-group $AZR_ORACLE_RG \
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
        --resource-group $AZR_ORACLE_RG \
        --size-gb 64 \
        --sku StandardSSD_LRS \
        --vm-name vmoracle19c
    ```

1. Open ports for connectivity

    ```bash
    az network nsg rule create \
        --resource-group $AZR_ORACLE_RG \
        --nsg-name vmoracle19cNSG \
        --name allow-oracle \
        --protocol tcp \
        --priority 1001 \
        --destination-port-range 1521
    ```

1. Retrieve the public IP of the VM and store as `$PUBLIC_IP`.
    > **NOTE** The public IP address is also needed on the VM, so it should be noted down for future use. You can view the IP from the env var set here with `echo $PUBLIC_IP`

    ```bash
    PUBLIC_IP=$(az network public-ip show \
        --resource-group $AZR_ORACLE_RG \
        --name vmoracle19cPublicIP \
        --query ipAddress \
        --output tsv)
    ```

### Prep the Oracle VM

1. Connect over SSH and assume root user

    ```bash
    ssh azureuser@$PUBLIC_IP
    sudo su -
    ```

1. Determine the device name for HDD formatting and store as $DISK. Store the partition name as $PART

    ```bash
        DISK=$(ls -alt /dev/sd*|head -1 | awk '{print $NF}')
        PART="${DISK}1"
    ```

1. Following proceedure outlined in [Microsoft docs](https://docs.microsoft.com/en-us/azure/virtual-machines/workloads/oracle/oracle-database-quick-create). **TODO**: Replace with a script download and run...

    ```bash
        parted $DISK mklabel gpt
        parted -a optimal $DISK mkpart primary 0GB 64GB
        parted $DISK print
        mkfs -t ext4 $PART
        mkdir /u02
        mount $PART /u02
        chmod 777 /u02
        echo "/dev/sdc1               /u02                    ext4    defaults        0 0" >> /etc/fstab
        echo "$PUBLIC_IP $HOSTNAME.eastus.cloudapp.azure.com $HOSTNAME" >> /etc/hosts
        sed -i 's/$/\.eastus\.cloudapp\.azure\.com &/' /etc/hostname
        firewall-cmd --zone=public --add-port=1521/tcp --permanent
        firewall-cmd --zone=public --add-port=5502/tcp --permanent
        firewall-cmd --reload
    ```

### Create the Oracle Database
The below steps continue to follow the process outlined in the microsoft document linked in the previous steps.

1. Switch to the Oracle User

    ```bash
    sudo su - oracle
    ```

1. Download the sample database ddl for loading after DB creation

    ```bash
    wget https://raw.githubusercontent.com/rh-mobb/oracle-migration/main/sample_apps/demo_oracle.ddl
    ```


1. Start the database listener

    ```bash
    lsnrctl start
    ```

The output should be similar to the following

    ```
    LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 20-OCT-2020 01:58:18

    Copyright (c) 1991, 2019, Oracle.  All rights reserved.

    Starting /u01/app/oracle/product/19.0.0/dbhome_1/bin/tnslsnr: please wait...

    TNSLSNR for Linux: Version 19.0.0.0.0 - Production
    Log messages written to /u01/app/oracle/diag/tnslsnr/vmoracle19c/listener/alert/log.xml
    Listening on: (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=vmoracle19c.eastus.cloudapp.azure.com)(PORT=1521)))

    Connecting to (ADDRESS=(PROTOCOL=tcp)(HOST=)(PORT=1521))
    STATUS of the LISTENER
    ------------------------
    Alias                     LISTENER
    Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
    Start Date                20-OCT-2020 01:58:18
    Uptime                    0 days 0 hr. 0 min. 0 sec
    Trace Level               off
    Security                  ON: Local OS Authentication
    SNMP                      OFF
    Listener Log File         /u01/app/oracle/diag/tnslsnr/vmoracle19c/listener/alert/log.xml
    Listening Endpoints Summary...
    (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=vmoracle19c.eastus.cloudapp.azure.com)(PORT=1521)))
    The listener supports no services
    The command completed successfully
    ```

1. Create a data directory for the Oracle files

```bash
mkdir /u02/oradata
```

1. Run the database creation assistant

    ```bash
    dbca -silent \
        -createDatabase \
        -templateName General_Purpose.dbc \
        -gdbname test \
        -sid test \
        -responseFile NO_VALUE \
        -characterSet AL32UTF8 \
        -sysPassword OraPasswd1 \
        -systemPassword OraPasswd1 \
        -createAsContainerDatabase false \
        -databaseType MULTIPURPOSE \
        -automaticMemoryManagement false \
        -storageType FS \
        -datafileDestination "/u02/oradata/" \
        -ignorePreReqs
   ```

1. Load the oracle SID into the oracle user's environment variables

    ```bash
    echo "export ORACLE_SID=test" >> ~oracle/.bashrc
    source ~/.bashrc
    ```

1. use `sqlplus` to connect to the oracle DB and load sample data

    ```
    sqlplus sys as sysdba
    SQL > @demo_oracle.ddl
    ```

### Setup the Weblogic VM


### more things

- [x] Install MedRecDDL onto Oracle Database VM

- [ ] Deploy Weblogic VM

- [ ] Create an Instance of Azure Database Migration Service

- [ ] Launch `ora2pgsql`

- [ ] Install and run Konveyor

- [ ] Deploy Azure PostgreSQL (in ARO environment?)

## Addendum

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
# Conversion considerations

## Oracle to AzureSQL for Postgres DB - mostly differences between Oracle and PostgreSQL
-  [ora2pgsql](https://ora2pg.darold.net/) doesn’t migrate every single object or function - Sometimes is easier to make the change on the Oracle side to make the migration easier
  - e.g If you use Oracle packages extensively - assume some level of manual porting will be necessary or proactively get rid of them ahead of time
- Transactions in PostgreSQL are different than Oracle.  Oracle supports nested transactions, PostgreSQL does not.  SAVEPOINTs can work; but if you have PL/SQL w/ nested transactions - likely manual porting will be necessary
- Schema ownership is different
  - Oracle schemas are scoped to namespaces or scope to databases
  - PostgreSQL schemas are independent - roles, users and groups are global objects
