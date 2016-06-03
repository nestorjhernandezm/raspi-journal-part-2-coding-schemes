#!/usr/bin/env bash
# A script to download and install debian live cd to a usb pen

echo "change this to arch bootstrap image instead"
echo "See yaourt install script for how to install from AUR"
exit 0

dev="$1"  # E.g. /dev/sdb
IMAGE="debian-live-8.4.0-amd64-standard"


# Make sure the script can only be run as root or with sudo
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# Check that user specified an input argument
if [ "$#" != "1" ]; then
    echo "Please specify device to setup. E.g. /dev/sdb"
    echo "$0 <device>"
    exit 1
fi

# Check if device is a block device
if [ ! -b $dev ]; then
    echo "$dev is not a block device"
    exit 1
fi

# Make sure that the device is not mounted
if grep "${dev}" /etc/mtab > /dev/null 2>&1; then
    echo "Please unmount target device $dev and run the script again"
fi

# Download live cd image
#wget http://cdimage.debian.org/debian-cd/current-live/amd64/iso-hybrid/${IMAGE}.iso

echo "Writing ${IMAGE}.iso to $dev"
#dd if=${IMAGE}.iso of=$dev bs=4M && sync

# Mount image
loopdevice=$(losetup --show -f -P ${IMAGE}.iso)
echo "Mounted ${IMAGE}.iso to loop device $loopdevice"

# Mount image to temp directory
rootdir=$(/bin/mktemp -d)
mount -o rw ${loopdevice}p1 $rootdir
echo "Mounted ${loopdevice}p1 to temporary directory $rootdir"




# Unmount root device
if grep "${rootdir}" /etc/mtab > /dev/null 2>&1; then
    umount --recursive $rootdir
fi

# Unmount loopdevice
if grep "${loopdevice}" /etc/mtab > /dev/null 2>&1; then
    losetup -d $loopdevice
fi
