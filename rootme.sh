#!/bin/bash

function pause(){
   read -p "Press [Enter] to continue"
}

UNAME=`uname`
ADBPATH=`pwd`/roottool/$UNAME
ADBTOOL=`pwd`/roottool/$UNAME/adb
export PATH=$PATH:$ADBPATH

chmod +x $ADBTOOL
echo "If you can read this, it means that your Thrive"
echo "isn't connected, you have USB Debugging disabled on your"
echo "Thrive, or the ADB drivers are not installed on"
echo "your computer."
echo "If it is simply that you have USB Debugging disabled"
echo "(as it is on any stock device), then please go to"
echo "Settings -\> Developer Options -\> USB debugging enabled."
$ADBTOOL "wait-for-device"
clear

echo "At this time, a screen will  pop up on your device"
echo "asking for a restore. There are no passwords. Press it."

pause
cd roottool

$ADBTOOL "wait-for-device"
$ADBTOOL restore fakebackup.ab
$ADBTOOL shell "while ! ln -s /data/local.prop /data/data/com.android.settings/a/file99; do :; done" > /dev/null

echo "Backup restore successful! Rebooting..."
$ADBTOOL reboot
$ADBTOOL "wait-for-device"
clear
echo "Making tempdirs..."
$ADBTOOL shell "mkdir -p /data/x-root"
$ADBTOOL shell "mkdir -p /data/x-root/bin"
echo "Pushing unlocked bootloader...."
$ADBTOOL push blob /data/x-root/blob
echo "Pushing rootable boot image"
$ADBTOOL push boot.img /data/x-root/boot.img
echo "Pushing CWM..."
$ADBTOOL push recovery.img /data/x-root/recovery.img

echo "Bypassing sealime...."
$ADBTOOL shell "mv /dev/block/mmcblk0p6 /dev/block/mmcblk0p9" 

echo "Flashing unlocked bootloader..."
$ADBTOOL shell dd if=/data/x-root/blob of=/dev/block/mmcblk0p9
echo "Flashing rootable boot image..."
$ADBTOOL shell dd if=/data/x-root/boot.img of=/dev/block/mmcblk0p2
echo "Flashing CWM...."
$ADBTOOL shell dd if=/data/x-root/recovery.img of=/dev/block/mmcblk0p1

echo "Rebooting to take effect..."
$ADBTOOL reboot
echo "Your screen will most likely go blank here."
echo "DO NOT POWER OFF! Give it a full 60 seconds"
echo "before calling for help!"
$ADBTOOL "wait-for-device"
clear

echo "Pushing files..."
$ADBTOOL push busybox /data/x-root/bin/busybox
$ADBTOOL push su /data/x-root/bin/su

echo "Setting up BusyBox and SU..."
$ADBTOOL shell "chmod 755 /data/x-root/bin/busybox"

echo "Mounting /System"
$ADBTOOL remount

echo "Pushing su binary into system..."
$ADBTOOL shell "data/x-root/bin/busybox cp /data/x-root/bin/su /system/bin/"
$ADBTOOL shell "data/x-root/bin/busybox cp /data/x-root/bin/busybox /system/xbin/"
$ADBTOOL shell "chmod 4555 /system/bin/su"
$ADBTOOL shell sync

echo "Pushing matching kernel modules..."
$ADBTOOL push bcm4329.ko /system/lib/modules/bcm4329.ko
$ADBTOOL push bcmdhd.ko /system/lib/modules/bcmdhd.ko
$ADBTOOL push scsi_wait_scan.ko /system/lib/modules/scsi_wait_scan.ko

echo "Setting permissions..."
$ADBTOOL shell chown root.root /system/lib/modules/bcm4329.ko
$ADBTOOL shell chown root.root /system/lib/modules/bcmdhd.ko
$ADBTOOL shell chown root.root /system/lib/modules/scsi_wait_scan.ko
$ADBTOOL shell chmod 0644 /system/lib/modules/bcm4329.ko
$ADBTOOL shell chmod 0644 /system/lib/modules/bcmdhd.ko
$ADBTOOL shell chmod 0644 /system/lib/modules/scsi_wait_scan.ko

echo "Editing local.prop for stable use...."
$ADBTOOL shell "echo "ro.kernel.qemu=0" > /data/local.prop"
$ADBTOOL reboot
clear

echo "Now we need to install ChainsDD\'s \"SuperUser\""
echo "from the Play store. Free version is fine."
echo "Please run it in order for root to work. We need"
echo "it to continue."

echo "If it does not install, please let us know on the"
echo "Thrive forums."
pause
clear

echo "Cleaning up..."

$ADBTOOL shell "busybox rm /data/x-root -rf"

echo "Grats, should now be running a fully open system."
echo "Flash away!"
echo "Credit goes to pio_masaki, Walking_corpse, and AmEv for"
echo "testing and building this script."
pause
clear
