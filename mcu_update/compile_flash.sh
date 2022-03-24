#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "ERROR: Please run as root"
  exit
fi

cp -f /home/pi/klipper_config/boards/btt-skr-pro-12/skr_firmware.config /home/pi/klipper/.config
pushd /home/pi/klipper
make olddefconfig
make clean
make

if [ ! -d "/home/pi/klipper_config/firmware_binaries" ]
then
    mkdir /home/pi/klipper_config/firmware_binaries
    chown pi:pi /home/pi/klipper_config/firmware_binaries
fi
cp -f /home/pi/klipper/out/klipper.bin /home/pi/klipper_config/firmware_binaries/firmware-btt-skr-pro-12.bin
chown pi:pi /home/pi/klipper_config/firmware_binaries/firmware-btt-skr-pro-12.bin

service klipper stop
su -c "./scripts/flash-sdcard.sh -b 25000 -f /home/pi/klipper_config/firmware_binaries/firmware-btt-skr-pro-12.bin /dev/serial/by-id/usb-Klipper_stm32f407xx_4A004C001851363436393637-if00 btt-skr-pro-v1.2" pi
if [ $? -eq 0 ]; then
    echo "Flashing successful!"
else
    echo "Flashing failed :("
    service klipper start
    popd
    # Reset ownership
    chown pi:pi -R /home/pi/klipper
    exit 1
fi
# Reset ownership
chown pi:pi -R /home/pi/klipper
service klipper start
popd