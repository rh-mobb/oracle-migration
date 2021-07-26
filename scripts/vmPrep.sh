#!/bin/bash

environment_setup() {
    # Get Disk Information for formatting and set variables
    DISK="$(ls -alt /dev/sd*|head -1 | awk '{print $NF}')"
    PART="${DISK}1"

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
}

if [ whoami != root ]
    printf 'Root permissions are required to complete this script\n'
    printf 'Please login as "root" and try again\n'
else
    environment_setup
fi