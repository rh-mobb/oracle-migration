#!/bin/bash

environment_setup() {

}

if [ whoami != root ]
    printf 'Root permissions are required to complete this script\n'
    printf 'Please login as "root" and try again\n'
else
    environment_setup
fi