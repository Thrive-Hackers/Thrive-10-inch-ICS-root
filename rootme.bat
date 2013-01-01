@echo off

echo Welcome to the opportunity to free your Thrive!
echo.
echo Originally developed by TYBAR at the Thrive forums,
echo this tool pushes several files onto your device,
echo then flashes the unlocked bootloader, then
echo installs the SU binary and Superuser app.
echo.
echo I am not responsible if you break your tablet, you
echo were the one that ran this. In the off chance that
echo something does happen, please PM me, pio_masaki,
echo or dalepl for help. Also, I am completely not 
echo responsible for pixies flying out of your HDMI
echo port, either. ;)
echo.
echo Please connect your tablet now, or exit to keep
echo a full stock Thrive. Also, either be plugged in,
echo or have at least 30% battery.

pause

echo.
echo.
echo At this time, a screen will pop up on your device
echo asking for a restore. Press it. A whole bunch of
echo errors will appear on your comupter. Those are
echo also normal. Don't panic.
pause

cd roottool
adb wait-for-device
adb shell "while ! ln -s /data/local.prop /data/data/com.android.settings/a/file99; do :; done"
adb reboot

echo.
echo Pushing files....
adb wait-for-device 
adb shell "mkdir /data/x-root"
adb shell "mkdir /data/x-root/bin"
adb push busybox /data/x-root/bin/busybox
adb push su /data/x-root/bin/su
echo.
echo Setting up BusyBox and SU....
adb shell "chmod 755 /data/x-root/bin/busybox"
echo.
echo Mounting /System via loopback....
adb shell "/data/x-root/bin/busybox mknod /dev/loop0 b 7 0"
adb shell "/data/x-root/bin/busybox losetup -o 20971520 /dev/loop0 /dev/block/mmcblk0"
adb shell "mkdir /dev/tmpdir"
adb shell "/data/x-root/bin/busybox mount -t ext4 /dev/loop0 /dev/tmpdir"
echo.
echo Pushing su binary into system....
adb shell "./busybox cp /data/x-root/bin/su /dev/tmpdir/bin/"
adb shell "chmod 4555 /dev/tmpdir/bin/su"
adb shell "umount /dev/tmpdir"
adb shell sync
echo.
echo Editing local.prop. for stable use....
adb shell "echo "ro.kernel.qemu=0" > /data/local.prop"
adb reboot

echo Now we need to install "SuperUser" from the Play store.
echo Free version is fine.
echo Please run it in order for root to work. We need
echo it to continue.
echo.
echo If it does not install, please let us know on the
echo Thrive forums.
echo.
echo If you do continue, make sure that both your computer
echo and tablet don't power off. What we are doing, if
echo interrupted, could fry your tablet permanently.
pause
echo.
echo Pushing unlocked bootloader....
adb push blob /mnt/sdcard0/blob
echo.
echo Pushing CWM...
adb push recovery.img /mnt/sdcard0/recovery.img
echo.
echo At this time, we are about to push the unlocked 
echo bootloader. It is imperative that you have a working
echo Superuser install. Otherwise, this will not work.
pause
adb shell su
echo.
echo Flashing unlocked bootloader....
adb shell dd if=/mnt/sdcard0/blob of=/dev/block/mmcblk0p6
echo Flashing CWM....
adb shell dd if=/mnt/sdcard0/recovery.img of=/dev/block/mmcblk0p1
echo.
echo Let's check that recovery did flash and that the new bootloader
echo isn't giving us the finger running it
adb reboot
echo To get to recovery, Hold Volume + and select recovery 

echo Grats, should now be running a fully open system.
echo Flash away!
echo Credit goes to pio_masaki, Walking_corpse, and AmEv for
echo testing and building this script.
pause



