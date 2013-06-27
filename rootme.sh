#!/bin/bash

echo DO NOT USE! DO NOT EDIT!
echo THIS ***WILL*** BRICK YOUR DEVICE!
exit


function pause(){
   read -p "Press [Enter] to continue"
}
export UNAME=`uname`
echo Welcome to the opportunity to free your Thrive!
echo Originally developed by TYBAR at the Thrive forums,
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

echo At this time, a screen will pop up on your device
echo asking for a restore. Press it. A whole bunch of
echo errors will appear on your comupter. Those are
echo also normal. Don\'t panic.

pause()

cd roottool
$UNAME/adb wait-for-device
$UNAME/adb restore fakebackup.ab
$UNAME/adb shell "while ! ln -s /data/local.prop /data/data/com.android.settings/a/file99; do :; done"
$UNAME/adb reboot

$UNAME/adb wait-for-device
echo Pushing unlocked bootloader....
$UNAME/adb push blob /mnt/sdcard/blob

echo Pushing CWM...
adb push recovery.img /mnt/sdcard/recovery.img

echo Bypassing sealime....
adb shell "mv /dev/block/mmcblk0p6 /dev/block/mmcblk0p9" 

echo Flashing unlocked bootloader....
$UNAME/adb shell dd if=/mnt/sdcard/blob of=/dev/block/mmcblk0p9
echo Flashing rootable boot image...
$UNAME/adb shell dd if=/mnt/sdcard/boot.img of=/dev/block/mmcblk0p2
echo Flashing CWM....
$UNAME/adb shell dd if=/mnt/sdcard/recovery.img of=/dev/block/mmcblk0p1

echo Rebooting to take effect...
adb reboot
$UNAME/adb wait-for-device

echo Pushing files....
$UNAME/adb wait-for-device 
$UNAME/adb shell "mkdir /data/x-root"
$UNAME/adb shell "mkdir /data/x-root/bin"
$UNAME/adb push busybox /data/x-root/bin/busybox
$UNAME/adb push su /data/x-root/bin/su

echo Setting up BusyBox and SU....
adb shell "chmod 755 /data/x-root/bin/busybox"

echo Mounting /System
$UNAME/adb remount

echo Pushing su binary into system....
$UNAME/adb shell "./busybox cp /data/x-root/bin/su /dev/tmpdir/bin/"
$UNAME/adb shell "chmod 4555 /dev/tmpdir/bin/su"
$UNAME/adb shell "umount /dev/tmpdir"
$UNAME/adb shell sync

echo Editing local.prop. for stable use....
$UNAME/adb shell "echo "ro.kernel.qemu=0" > /data/local.prop"
$UNAME/adb reboot

echo Now we need to install \"SuperUser\" from the Play store.
echo Free version is fine.
echo Please run it in order for root to work. We need
echo it to continue.

echo If it does not install, please let us know on the
echo Thrive forums.

echo If you do continue, make sure that both your computer
echo and tablet don\'t power off. What we are doing, if
echo interrupted, could fry your tablet permanently.
pause()

$UNAME/adb reboot

echo Grats, should now be running a fully open system.
echo Flash away!
echo Credit goes to pio_masaki, Walking_corpse, and AmEv for
echo testing and building this script.
pause



