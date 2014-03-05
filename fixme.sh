#!/bin/bash

function pause(){
   read -p "Press [Enter] to continue"
}

UNAME=`uname`
ADBPATH=`pwd`/roottool/$UNAME
ADBTOOL=`pwd`/roottool/$UNAME/adb
export PATH=$PATH:$ADBPATH

chmod +x $ADBTOOL

echo "This will attempt to stop the temp root bootloops"
$ADBTOOL "wait-for-device"
clear

echo "reverting temp root"
$ADBTOOL shell "echo "ro.kernel.qemu=0" > /data/local.prop"
echo "rebooting..."
$ADBTOOL reboot
clear

echo "Cleaning up..."

$ADBTOOL shell "busybox rm /data/x-root -rf"

echo "System stability should be restored"
pause
clear
