#!/bin/bash

function pause(){
   read -p "Press [Enter] to continue"
}
export UNAME=`uname`
echo Welcome to the opportunity to free your Thrive!
echo Originally developed by TYBAR at the Thrive forums
echo and finalized by AmEv and pio_masaki,
echo this tool pushes several files onto your device,
echo then flashes the unlocked bootloader, then
echo installs the SU binary and Superuser app.
echo I am not responsible if you break your tablet, you
echo were the one that ran this. In the off chance that
echo something does happen, please PM me, pio_masaki,
echo or dalepl for help. Also, I am completely not 
echo responsible for pixies flying out of your HDMI
echo port, either. \;\)
echo Please connect your tablet now, or exit to keep
echo a full stock Thrive. Also, either be plugged in,
echo or have at least 30% battery.

pause()

echo At this time, a screen will  pop up on your device
echo asking for a restore. There are no passwords. Press it. 

pause()

cd roottool
$UNAME/adb wait-for-device
$UNAME/adb restore fakebackup.ab
$UNAME/adb shell "while ! ln -s /data/local.prop /data/data/com.android.settings/a/file99; do :; done" > $NUL
echo
echo Backup restore successful! Rebooting...
$UNAME/adb reboot

$UNAME/adb wait-for-device
echo Making tempdirs...
$UNAME/adb shell "mkdir /data/x-root"
$UNAME/adb shell "mkdir /data/x-root/bin"
echo Pushing unlocked bootloader....
$UNAME/adb push blob /data/x-root/blob

echo Pushing CWM...
adb push recovery.img /data/x-root/recovery.img

echo Bypassing sealime....
adb shell "mv /dev/block/mmcblk0p6 /dev/block/mmcblk0p9" 

echo Flashing unlocked bootloader....
$UNAME/adb shell dd if=/data/x-rootblob of=/dev/block/mmcblk0p9
echo Flashing rootable boot image...
$UNAME/adb shell dd if=/data/x-root/boot.img of=/dev/block/mmcblk0p2
echo Flashing CWM....
$UNAME/adb shell dd if=/data/x-root/recovery.img of=/dev/block/mmcblk0p1

echo Rebooting to take effect...
adb reboot
echo Your screen will most likely go blank here.
echo DO NOT POWER OFF! Give it a full 60 seconds
echo before calling for help!
$UNAME/adb wait-for-device

echo Pushing files....
$UNAME/adb wait-for-device 
$UNAME/adb push busybox /data/x-root/bin/busybox
$UNAME/adb push su /data/x-root/bin/su

echo Setting up BusyBox and SU....
adb shell "chmod 755 /data/x-root/bin/busybox"

echo Mounting /System
$UNAME/adb remount

echo Pushing su binary into system....
$UNAME/adb shell "data/x-root/bin/busybox cp /data/x-root/bin/su /system/bin/"
$UNAME/adb shell "data/x-root/bin/busybox cp /data/x-root/bin/busybox /system/xbin/"
$UNAME/adb shell "chmod 4555 /system/su"
$UNAME/adb shell sync

echo Editing local.prop for stable use....
$UNAME/adb shell "echo "ro.kernel.qemu=0" > /data/local.prop"
$UNAME/adb reboot

echo Now we need to install \"SuperUser\" from the Play store.
echo Free version is fine.
echo Please run it in order for root to work. We need
echo it to continue.

echo If it does not install, please let us know on the
echo Thrive forums.
pause()

echo Cleaning up....

adb shell "rm /data/x-root -rf"

$UNAME/adb reboot

echo Grats, should now be running a fully open system.
echo Flash away!
echo Credit goes to pio_masaki, Walking_corpse, and AmEv for
echo testing and building this script.
pause



