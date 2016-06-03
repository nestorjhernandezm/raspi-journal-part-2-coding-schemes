#!/bin/bash

mac=$(cat /sys/class/net/eth0/address)
hostname=$(grep $mac nodes.csv | cut -f2 -d' ')

# Assign hostname found in nodes.csv
if [ ! -z $hostname ]; then
    echo $hostname > /etc/hostname
    hostname $hostname
fi

