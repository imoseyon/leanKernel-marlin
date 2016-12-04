#!/bin/bash

sdir="/lk2/build"
udir="/lk2/build/lk.utils"
objdir="/lk2/marlin_obj"
device="marlin"
cc="/data/toolchain/latest/bin/aarch64-linux-gnu-"
filename="lk_${device}-v${1}-fastboot.img"
mkbootimg="/data/mkbootimg_tools2/mkboot"

compile() {
  cd $sdir
  sed -i s/CONFIG_LOCALVERSION=\".*\"/CONFIG_LOCALVERSION=\"-lklite-${device}-${1}-\"/ $objdir/.config
  make O=$objdir ARCH=arm64 CROSS_COMPILE=$cc -j4
}

mkboot() {
  cd $sdir/lk.utils/ramdisk
  chmod 750 init* sbin/adbd* sbin/healthd
  chmod 644 default* uevent*
  chmod 755 sbin
  chmod 755 res res/images
  chmod 640 fstab.marlin
  cd $sdir
  $mkbootimg $udir /tmp/$filename
}

compile $1 && mkboot
